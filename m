Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16FD0CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113856B800B; Fri, 22 Aug 2025 14:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D4E8E009D; Fri, 22 Aug 2025 14:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDA46B800B; Fri, 22 Aug 2025 14:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5EE88E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:53:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40312B80B8
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:53:12 +0000 (UTC)
X-FDA: 83805291024.15.C476A97
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 569A5180010
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:53:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iw5pkBWh;
	spf=pass (imf16.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755888790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgQUn5CtNABDqKDSDivPq45BncqGSev+VDo5NGeADv8=;
	b=kfrSzweXdtCmZENz1zGRlzHr08uGLghYcVZEMQxDIf3yVnvyqkacPYeViPOsVI65rAijkT
	GupHZfFvtp19gu4zu8nyO7SCRlh9fod+cbuCIbbAfcuHNMnUEkVZdoOEcu/71/PE9v1Hpc
	Qd3Ke82e77gpiY40FUi4YOEQd0VP27o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iw5pkBWh;
	spf=pass (imf16.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755888790; a=rsa-sha256;
	cv=none;
	b=yT+fglZwpML8iJFio75TknkLKUtC2UxxxLzAFNS1Dalw1TXYRiWDF/2BuG8fqHwCNz/ly/
	511LLHLOI1r67/k0WGsqnFkg4jgV5VhQcPDALdbaD4aXEo3Gae+6j+BGVCM4/OVeJU/eKG
	FoTiK1HAxvYK09wKEY8RqqzoQXQe34k=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a1b0d224dso12327425e9.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755888789; x=1756493589; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kgQUn5CtNABDqKDSDivPq45BncqGSev+VDo5NGeADv8=;
        b=iw5pkBWhAGyuIPl92FvcZW07yhGMjI1u/juknEUydI/zPpNLnVetS4Yx1MLmkD06cF
         uDCLr0N0tK9UfakmEGoYXGhv+HucH3LldOjZLNGSrkFTY4OZLDR46Tv7i7Z6X09qwUVc
         Aef6wN7NyoeDL+n5M66HBNJ5ZCTsG0AQ+FCU/RnaX6JZh6FVYxlac3QDWmb4Srv3aQqc
         Ea95yD2PEWNR9+Wcl3KmYpdO5lwbu9FyDmkTL1aXQ5vsotyoY0VnfK77wAj4wmj6LmX7
         zct5EJ79eWQbScPaodqUs7Nq6FVeMqEenA8FtK2cm7aJFOwWXroBoj7CtMbT8lune3UQ
         FFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755888789; x=1756493589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgQUn5CtNABDqKDSDivPq45BncqGSev+VDo5NGeADv8=;
        b=IGwlS9n9gzYJe4VQIXlI6AzqeEXb+ifWjdNQ0iBLP+6IvSAdoPM2r+QlcDuxs46DxO
         D6PyW5//3KJhCxTwDqtGpjdratASt80wT1m+RnnAwIVnW27sNkzOpev0FLIXrAnXKHwQ
         K5NSj/V1k4ZVrhNBDSVk+IJTW4V7FooQToyvLOrENaPQqDS5VTC9R/wtlo4QOnhRcBXY
         LEzfR1rVBKi9q4H887HqjgpHOSAwP1SssIabx8dYi8209XvIL9gGVEe/x+gcnXfZdDQ+
         zXvLXGoRKnxiGg2wEsglyZ+AuIJc4es0jA0V6AOAr/dDD7FwMK7UICWGl8mY4yMHRCZ0
         Jd1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXATudo8c0aqWE3d6Vp5VVC+zAvDMUiORX12pkEBaQO8zcfwPheswnNU/ruB/YVBAgehy5rt2Og4A==@kvack.org
X-Gm-Message-State: AOJu0Yxw+MBXcdIzMxoh3XaXFmwjFxD4JmMhZ+CIFb5KeW2DyweLgume
	8JA/HG/h59od60/H01l1hTYRGkVp2bFYL2iG+cOl+eLNBFpgGBjNmdMU
X-Gm-Gg: ASbGncsGOtz5EC/fh7oQseVn8dnaO3Oi+NXWN1EJ8O6mG/8AK8wWGrXtE4lmfwWJsGt
	2HKfZyZx+1LP2ZAf4xqMBZepe05QZrNB80N8IAr/iMAFl9/bLeBIXBqYUuXPAaXTyFUe6YmyBdS
	zce9cHCx1+oGMeWz5+vLmN+lpfopgErCeVZwUlEOJ23g7WSBmfsMtYASIns8iprDLpYmdUrAp9j
	f2o81aEW4iqmk69OK6K5rbIMgDYeMV+rOuCZ29AvAiqzL4HvomGQVL/b5RjZTnUAKmB9dbqX/XQ
	myunwPUzb4ei0Lpbr17BLoem7TXsTgVdNVqNIZLjFsPEFfOOnENjnVWE0IEPQB7s2Qydauxwfte
	p1ZaGaIIMRUscs/lZSQSYWBlX4MZYIBvoiESqzZhHROVbCzusChQgZhbaVYyjyLg/
X-Google-Smtp-Source: AGHT+IH2CJD7uzzmkgj7levHo8yeRDnD2Rey6jjYpn4mLRK/SjHZtD8Mo7fIGKErdyaVDFxn1SiP2A==
X-Received: by 2002:a05:600c:1d02:b0:43d:42b:e186 with SMTP id 5b1f17b1804b1-45b5178e6d8mr38320405e9.8.1755888788475;
        Fri, 22 Aug 2025 11:53:08 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70f238640sm527339f8f.26.2025.08.22.11.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 11:53:08 -0700 (PDT)
Date: Fri, 22 Aug 2025 19:53:03 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>, Michael Ellerman
 <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>,
 Davidlohr Bueso <dave@stgolabs.net>, Andre Almeida
 <andrealmeid@igalia.com>, Andrew Morton <akpm@linux-foundation.org>, Dave
 Hansen <dave.hansen@linux.intel.com>, Daniel Borkmann
 <daniel@iogearbox.net>, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 02/10] uaccess: Add speculation barrier to
 copy_from_user_iter()
Message-ID: <20250822195303.0d9fb6eb@pumpkin>
In-Reply-To: <CAHk-=whKeVCEtR2mQJQjT2ndSOXGDdb+L0=WoVUQUGumm88VpA@mail.gmail.com>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
	<82b9c88e63a6f1f5926e39471364168b345d84cc.1755854833.git.christophe.leroy@csgroup.eu>
	<CAHk-=whKeVCEtR2mQJQjT2ndSOXGDdb+L0=WoVUQUGumm88VpA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 569A5180010
X-Rspam-User: 
X-Stat-Signature: kbd7z54dpjoth34fxn94ygqjm9hu1a7u
X-Rspamd-Server: rspam09
X-HE-Tag: 1755888790-473210
X-HE-Meta: U2FsdGVkX1+nGjLCr/aLg0HonmOZg+oSSdlPDLtbqeTIXfm9A8KnKx3uMsASzpxfAW148qMaLAwLpZGJ0MeFFBr8XfNImB0uU+Z39KniJOckAyCxZaqsEXkE5ktyXOUD8gxijm2dVkFhuzAr7D+JBZq+Qn4N/gjC+a31FaSjNXBWLGbw+hotWP266a0jiiebC0KIb6SVaAAS0NMeiCXxdkvDMu0tEr5qFzKaZjoAIDJ3jzuwZbQkE792QWLhGya+vtyuOzvc1ED/xVte2zDPE807h+xpkEdExL0Dr1RW3BFVJAxk5utJjgh25UrZI3kqcW2fi2Jf9I7XUHCF3jSEja+ppeMymDvFQdiUxAKMwXNnMgmrU0OLfVwGjaHnn4HDNqZcGAuzetjnefMWfnW3UxG5Gul7R2h3wreTVG9B5AnAJmixTtOaWXO7jqZ07VTAnYU3MSpSFYCTWIvs7bKQPYI2dZpf///NujUBg2Fz6fqJIxoSlBxC0djw2DhMwda5cAvO9YHvoOgqoWJHJgXAO7mTph7fRKEy+ZU9ukvbxQ0G2fl/BXgdT3RsFS4SliCx6o3LuonTl/VbQEaqWnrZM814etQbj3FRTIqeY5Hb9B2zehVUDMbcSkQrAYLwyKgzPoz55RjtzYusQe7rNjC7KNoWOd08AQAlCBNjjcD2rpbXb9z3QSOh6s8ZIDpPZZHstki/DpnvkcudV9gLrkqmqSEpAe8dsSc+0hfs17nKojoHFRrsuWSe2k2wS9s61Pn3I3qFuDTrqUO9Ac/RPe/5u4F79egMuP3Zu8fpB+jB5ANjaVeRZfSKfhmOPEZ0qoa4nEsQXKbODXhXYd+7aXwcKJ10i/jmWQRM2YjcVBtuvZMJcWphyhVwA2qnpRlNvlNGAwo5s7rqHe2LLgjn6oxtxshF+mKMynxcxiTbaq0jdAFEEi3EkKYxJkw2Ty7epXDnkZCgiNxaJZqPS+0dwEJ
 7gPaGwUZ
 GxFyRWn3OoYIM2+VsNPy/w1SBiMTA/fNtqJJ8ppUwMKYOJs9wQxIRRrz4MDrt+EOuKOPnGTmoOqqLp4x9ei4Ll6rs7RXD7D9/jelcAlVHya/UVfFSiDP21e/nqUElV6Ch0qqkLjLD+j5EJqXTz583XBLE6Om1cLNsHvgi+lzD4lM/T4OfPsmbC22zLxSfPKwgL/kUoyplCHIqfZ8HURXENAiNPwJ6Iy3EzBsbxahkwLoq2iWETgCRFU79XxU78jku3hvCIvkO6wSbeQEer2NglKi3xgh63xK4JepZDa6RzKS/F7jnIevtocT/FYHCYneoYmVvaafyrx9y6G3o7P8Nnoa1QqA+zI/E22jQuQ/e3LrYWFg5H9kmxHo0GqHLDn1rSSaGFawAbgakLtR4Rg2zWmOFAblvDSXSFZ/RIPVFfOhjxTlGimXxOMXHL58EmKR5O0jFw2eJbWjoLOJspCV03LRL1ow3ZcecPl9NHHPvnRHBYFOQRRPH4lsMvpRZtL/SsYR3g5d/zTDL9OMsyiuWEBpLAWynDOuYJBh567WfmoOiMg1FtinDj3cM7+2/SXatffojDqcGb7mWdkU6unAj+/8JVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 09:46:37 -0400
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 22 Aug 2025 at 05:58, Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
> >
> > The results of "access_ok()" can be mis-speculated.  The result is that
> > you can end speculatively:
> >
> >         if (access_ok(from, size))
> >                 // Right here
> 
> I actually think that we should probably just make access_ok() itself do this.

You'd need to re-introduce the read/write parameter.
And you'd want it to be compile time.
Although going through the code changing them to read_access_ok()
and write_access_ok() would probably leave you with a lot fewer calls.

> We don't have *that* many users since we have been de-emphasizing the
> "check ahead of time" model, and any that are performance-critical can
> these days be turned into masked addresses.

Or aim to allocate a guard page on all archs, support 'masked' access
on all of them, and then just delete access_ok().
That'll make it look less ugly.
Perhaps not this week though :-)

	David

> 
> As it is, now we're in the situation that careful places - like
> _inline_copy_from_user(), and with your patch  copy_from_user_iter() -
> do maybe wethis by hand and are ugly as a result, and lazy and
> probably incorrect places don't do it at all.
> 
> That said, I don't object to this patch and maybe we should do that
> access_ok() change later and independently of any powerpc work.
> 
>                  Linus


