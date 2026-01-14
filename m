Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8935BD29FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2B676B00BE; Wed, 14 Jan 2026 07:01:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8C76B00C2; Wed, 14 Jan 2026 07:01:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4EF6B00C4; Wed, 14 Jan 2026 07:01:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAFA16B00BE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:01:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEA181404A3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:01:56 +0000 (UTC)
X-FDA: 84330430632.30.5604470
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id E17C81C0002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:01:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AWqIZBsX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768392115; a=rsa-sha256;
	cv=none;
	b=2r6pRBLFXIz8E4mHQrN9N0U1XznqmVe3C6I3a3OJdwABvJDmq1hRhXzoDDx2bOZhiDovHW
	23w/KC8OppxAAF46PeSXVo5wXjiGJaC1w0WFa8VZalWw26HZw173GD6qzdfgcmom5iIvKE
	3UmQwisxOHqPjpGIIao5zE3N54q8Sys=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AWqIZBsX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768392115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gsd8G2M81+WYoxdkuRC18RhaEdxHWf3NY55zL6lQS6M=;
	b=DAup1nWp7ivfui3qpl/qZV7u7qV1mUlV9zWVv2x/YmF/Zrcl8UODTL0g31ho2GcmY/iQpz
	4WASOVJy5GD1M6aTnXX/ca3aEA7Rd3jXXLDCD7mpHn+I0ULCAVFSQZLatjTzSmfUfb+KbY
	u3M5DN/oSmDYpu9M+HxWiYSCcOe4PIY=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64d30dc4ed7so16950782a12.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768392113; x=1768996913; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gsd8G2M81+WYoxdkuRC18RhaEdxHWf3NY55zL6lQS6M=;
        b=AWqIZBsXQbqj2hBO6MeEfBMZ9qU1jJUr+kUqRPQDnazjybJsP6ekvpqUx8hFD3zuyo
         adyUGxmFUxxd0Y09k1BdGZyh/PC/8tDbdTgwa1xzX2lhBhVoUFDqcqxW27sw27MWqtEs
         tVTVrwEXiO4i1AVZUDcQ5xztXGos9FtjKO7jt21FYX042prTBd6vqJlK6kwaYonyANb7
         ktXiVg5hvdMrHSh+nr8tJ2Va8i5ug3KDQZcUEs6vAtZSdoQ5Io2omLe85xj3TuDC9IYd
         PzA12LxZT0YCWd74/ByPBDEK4nuEagg0QoFi7s4ZjnFOydrSiUKc29Xk0txBKl6FW+kL
         bgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768392113; x=1768996913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gsd8G2M81+WYoxdkuRC18RhaEdxHWf3NY55zL6lQS6M=;
        b=ZuKF3G22rESNMtgoGgtO88XtkcrIGSPby3QAT23PJk4mtF2Sgw9Mi5tgHD2yVSqMiQ
         Hfq0FbbzLtk0fz/cHI5Lx4BdMT0xRINZ91EOvNtOEWukQxstfbo5qpmf35HHz8YQqo/o
         2djV8gWrEPKPzrCKwGdhp3b7hfOZ01PoQ2FACY2uS4/FBb/7HqNzmeYocusEAy2R7r05
         7+/nOusWmJyNpA9O+NtPaq0m96k+FyY6WZaJweZkXxhfhvI03nKdYBkhTE2r/pOkYREg
         6b5dQu5KBwDe1734lG/pxVOVlaFRzhQzX3BiXCoul5KUQxo1nBm9VPJ4x5o6Xv1ljI4L
         iIyA==
X-Forwarded-Encrypted: i=1; AJvYcCWAal3UT+3e8Eks8irudxMomwnq6xOBbpcnfkE+D2FgrLcGq6J1WuC6QKAhhn8xYQF6SU8InmZYpg==@kvack.org
X-Gm-Message-State: AOJu0YyEk4bJoP+MB5NqFYX/akyrISjVrpCTzShbjZ6FJTgF5/KhZcIy
	5SSQ9M7LqjXoLr1ZmFiBYb1Ngp0wF77ii/kWvCaScSVhMPUVBPVwUU9F1Ev+aQ==
X-Gm-Gg: AY/fxX6rMSPihl9Za9hk/U2hjVkHJi0z8U1fp2nVio+rm5rOSucj2HnOQtZ2xp635ev
	2Ymtk4U2Unlbalm0nmu+GLtDhz7tAir7gI7d36yN0Eady1cauGMlRFnTWOjnKMy7WteuKf8ekmj
	nXAGIcaWyLANAGCzdf/NhRpc4T3P56ogejdgToZZjhaA+XHUaMm2uzaXnw/0vLUtXX1vLrrY4yY
	cot7rB3KOTBxeNEPfcMxOhsRzh+Qs91sj7idKFXH0FTNUbkw8vRo2MkOt8slVbAhuVV13GVsjCK
	xnoiBOZ8xvrB3+KqD9awHgLFvsgzHe07O37RJcmy/bRPwsxbSkwD5thjKb8relhIKo7+9HnuKqe
	e+YjVGq95YiHs5EFEgsO0yRtG2IGlrGtODA+J0sh/dvsBkXWTgdyQR0te9jPA19CiXzAH6w9LKI
	fNsC5MSIYkkBbT+nrx9Zo7YAp6HH+eZPYE62HjAa/p2e2/Csn0wJASFXiOV/NrnIs=
X-Received: by 2002:a05:600c:c16a:b0:46f:d682:3c3d with SMTP id 5b1f17b1804b1-47ee32f14ddmr22777885e9.13.1768386665307;
        Wed, 14 Jan 2026 02:31:05 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee5914232sm24680845e9.14.2026.01.14.02.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 02:31:05 -0800 (PST)
Date: Wed, 14 Jan 2026 10:31:03 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>, Nicolas Pitre
 <npitre@baylibre.com>, linux-mips@vger.kernel.org, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>
Subject: Re: mips64-linux-ld: div64.c:undefined reference to `__multi3'
Message-ID: <20260114103103.216aa122@pumpkin>
In-Reply-To: <alpine.DEB.2.21.2601140453090.6421@angie.orcam.me.uk>
References: <202601140146.hMLODc6v-lkp@intel.com>
	<20260113200455.3dffe121@pumpkin>
	<alpine.DEB.2.21.2601140453090.6421@angie.orcam.me.uk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 6gkd9n1obroes78171hhoswqyucjmzci
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E17C81C0002
X-HE-Tag: 1768392114-246059
X-HE-Meta: U2FsdGVkX18OjOp9IcdczxpthemvuUS5icuNcMCP30lnB523R61rd8udOeQc6UA9j0BoShwQAEIqepk+bHRCwPFoYEwieNeQ5rvu9KiFeIMa6r54tSQHoGipiZiFiEE4FGdaXFJVHb/BkTiZGdDtiSGFZtIcr1asdk4pHmdCgYVtuYD3trcvESws001HAQM2Rc94BPWEr7n2nu2p+NS3K0htVflHZRIXJJ3N/Dgz6zhTRGvNjgY01uE9DcBSiG5qyb4uuDh2SRyMnHFSpWgfrNr9g6H0pKIKT3YPjVvAqZcDLM5dCzJYlyFfErX2qjjUe/ebewnZwh3o4hsmWuL3L3OcBO0DujvEZkUJDcF8v16Bt+e97xEX0PryUDb4jfXOD4D2MIWhOxHZYacaGSiu7IWXVhBNfl0TVpCtUDWldzavu0d18JVd0kRAZVYDEd8vlgeojHvR7qS/0U+9hgTzpUdOCsKelivGc+F7kp6erpyrpAMLSm9tF2A1Tm0cq0oOLZALwB+MEjqNyOM59BTs+st286G/tp1jrA57fhT9HAfal8mgoWelqJn7hA27l3gpOBqhe3a2meXOf66cWtbR50bXoOq3HZ+qlHBZL8wIBhCllRalGYVm0lTe9HtcwmZwmhsuah7IUp65u8o8flLubUxYowpIEc6IpA8p95qhSznIiWOdMhpPJqhkW046b3Xd5+1dQLkxyVEEergJ8BoJXiDoa4O+OeYbuYSboe/BdY5d3uR2Y+LdnT5dSstxqWN+X7XIQ+Uz/l8zbkn97eKOZ/ydsRLP2Rxwocs4wEo/64ynpTWx/37AH6i0FmNdRcGJESPyPGglZn8DMiz4w2NbLZjKtl/kvFYzi8Qgj9aiJG+/h2rkTzt8llPOY6M4oO15bXDqepVV+3h0+iKbmobnWMs6zrSUI+QOA9bYUNQPBZVL1J1BKxuJzq7OtUVLRF+OyPTrcP9KlxAWfgH2xoU
 KkxokqBH
 VO842Rb60MsD8Z1fPttaejV17airk2o40BapOAGTBEmhsDYynSjZD9zQ7bIvNvszoyWx1GB1DgRR5kJwI32WZkK1KEEpb9HKO6cXWzjMo4+ziG6zE9Ykh6SS3svuGJX80WwyDReItiBmBY4AjtSvbHYjedie/qDVreHNdIJlftzWM/zmWt8wfnZdIQJ1Xrariy8eZgk/5KFDnT3gLVy0I4VZLJaGqqxrjOizM90i08tsnTfpynYS6IgGqQdpYueRg/M/jefHYzHOB+2Ho9u96Bt6WcFvL2UHUuCTX2cGEfF1dOEdyMo+EQxghjiD17u8BF8+b+5fpzLyclIWCOtBBTv08cdIYx28DeShG1/XoX3ll9qxNo6gAATZ5m3Y5QuSafXY9XdbOf8e9WQrjHVHpe3TM91jQ8xsdwU6MletvaQuCsrxG7qypXePUMzS1NNDPYnTu8eW8UIFTUT7kbfzcGyKZM+asrVNHsFUgSqAQZ6ATkdtzbLhpgmSw12HubJ8Vt7uToPQlg+zethmmiKv9jEkgq7+5U+GyzY6Snqg6GNSb/Q2rVXSzK0/M2UDgJV94um5q96eQ7YzmjB6QfrnyTkO6bFH4ewn0aneJBK6IAINhBIzTEODhMiYOk6G3cvyErJTugsgUyZFczLs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 06:19:02 +0000 (GMT)
"Maciej W. Rozycki" <macro@orcam.me.uk> wrote:

> On Tue, 13 Jan 2026, David Laight wrote:
> 
> > > All errors (new ones prefixed by >>):
> > > 
> > >    mips64-linux-ld: lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
> > >    div64.c:(.text+0x84): undefined reference to `__multi3'  
> > > >> mips64-linux-ld: div64.c:(.text+0x11c): undefined reference to `__multi3'    
> > >   
> > 
> > This looks like a bug in the mips 'port'.
> > arch/mips/lib/multi3.c has the comment:
> > 
> > /*
> >  * GCC 7 & older can suboptimally generate __multi3 calls for mips64r6, so for
> >  * that specific case only we implement that intrinsic here.
> >  *
> >  * See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82981
> >  */
> > #if defined(CONFIG_64BIT) && defined(CONFIG_CPU_MIPSR6) && (__GNUC__ < 8)
> > 
> > So this code is excluded for gcc 8.5 but the compiler is generating the call.
> > 
> > Looking at the git log for that file there is a comment that includes:
> > 	"we wouldn't expect any calls to __multi3 to be generated from
> > 	 kernel code".
> > Not true....
> > Not sure why the link didn't fail before though, something subtle must
> > have changed.
> > 
> > I think the fix is just to remove the gcc version check.  
> 
>  Or rather fix the version check.  The GCC fix went in with GCC 10:

Does that mean the GCC 10 generates the multiply instructions and never calls
__multi3?
(Rather than just not using __multi3() for that specific example.)

In this case gcc knows the high bits are all zero - so just needs the two
instructions to generate the high and low parts.

	David

> 
> $ git log -1 --pretty=oneline 48b2123f6336
> 48b2123f6336ba6c06846d7c8b60bd14eaeae7ec re PR target/82981 (unnecessary __multi3 call for mips64r6 linux kernel)
> $ git show 48b2123f6336:gcc/BASE-VER
> 10.0.0
> $ 
> 
> I don't know why the PR got it all wrong; I've fixed it now.
> 
>   Maciej
> 


