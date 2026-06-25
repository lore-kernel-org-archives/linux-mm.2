Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67FC7CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CA76B0005; Thu, 25 Jun 2026 04:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E46B6B0095; Thu, 25 Jun 2026 04:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FBA26B0096; Thu, 25 Jun 2026 04:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29CF96B0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:54:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C24B1C33EB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:54:11 +0000 (UTC)
X-FDA: 84917823102.25.61835D0
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id B68F5180002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:54:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pibbz1dp;
	spf=pass (imf24.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782377649;
	b=W6Qc8eqLLqUognP9pMjKSgEiAl6Dvi/w+Ql9/kKbMyCsCEFDrIneGtCLYI8fuUxa1SBFcz
	vqR5Cb50fjjK+wMzB7siw7zgHHvQ+ncGRLZybcGKSYMrzGiETkYar7eHvoBI0zvmfIMQyL
	pnZXh1/2/IQ9vsx/XuVok0DX2aSso1w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782377649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jDoMmJJU0PpNgF+w3Xx9Gr+Xmtdk7u64RSrEr55CTg=;
	b=rwjPBxfk8sb8dw8MgdFYZ0eAgDktL19xlcIu5nLonqutpRAZiKwZWs8hun7AiTi9xCccUk
	RLCP4szzdY476gICaLQkk5tWnKQqYSWE6RQluTJvJ0Uac2y393xUSdMe/Xe2YJ0R+Q0+25
	tNeL5DOIZyPJrHDkJcF6GOA5E1jrhPc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pibbz1dp;
	spf=pass (imf24.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-46e30429b10so64268f8f.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782377648; x=1782982448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jDoMmJJU0PpNgF+w3Xx9Gr+Xmtdk7u64RSrEr55CTg=;
        b=pibbz1dpHmwx8F6xaYHZADYWPG1KbggXNG3b+clgAaig6dkppM0DWHYOMliPNS6UvH
         Fp1J2D/Ex7egRRQFIZ4FSI9Bt7o6fX+0HLhkrBJG4uylwO4VTrVMUV5Gi13OMUOwQbyU
         SeeH6c1yMUFIGcJv9oAE+qs58b8zH3ZhzroGjHu1Y+XLNHY+8kRwCtb8voJEVgEb3w4Z
         V9MtnSUIhuENPBdAm01NDo6gIjLERitZoN50eLfBXTHhzftQhcYFTwYPDI1eDneh6OCK
         Tdi8gde2oQfb+jQ98mKkpEQng2/dp0igTXFSTPV1bTiuYGd1YpfDDPp3JGcZrUdihoHj
         nHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377648; x=1782982448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/jDoMmJJU0PpNgF+w3Xx9Gr+Xmtdk7u64RSrEr55CTg=;
        b=dd39VMLBl46Q2nB9HQAax0UZRq0fb/z3XbHCqza4bJYQmYPc779/rXUvEwDppXbXz+
         x0BhCz3uZ5N6S4mDbKebFQbpRfKaX59OuuYERF1L2ejeb40WNwAWtHbaYdFJOb0R0OKw
         IQrEjGYk4JsEDktGHp0pL/UrjeC8j/AxGiYXF38kCDfhH21DZ6VaTc1tQZOmh318t4kB
         iZD23jirD5+T0QVeaz+ux0ct1Qx3+n3Qd604wq52DcD1mbQI38c8u1rV+5WgBPVMP3Xn
         Yuay6CddPye/rSrI4YU7KZjWhN414iGkVpzlIU9hiY3NiGmX08prUfz8UH+FqOCHGdrh
         NGJA==
X-Forwarded-Encrypted: i=1; AHgh+RrQhk4B/ZxhGYZzLyuqpfGqQSLjCau+XnSr+X9fXcu5vVtX1596Ff7GFi2wDF04hF9vSiyEuieg2g==@kvack.org
X-Gm-Message-State: AOJu0Ywczo/7ybSVMnFddDZ33uLJp+olddDaiZFDPdy64byEzVMdDXst
	TgY2chSXBjfNmdllO48zVddKSzEYZabS9Bkj+p2Wh6BSfHDnRWqXIv0O
X-Gm-Gg: AfdE7cmPZrq+tiicF5Svm1CbPFnt59nByzQ28lOQZjSHzNh0Q5jwJO9m4PjzheMs81j
	JUAeyw3x49pkRfYV21e+b9uLYknaYVL5SV5Ls7M+FHAMMB5FbmMc6dSzJ3l0vACpPyOX2Ybsz/Q
	X3/4leKNcQTsUv+wn0FF99OvTxdA5DUxDiJM8/xovlZRYFShucbu7y6KXn2tlRsrJzQxBpro9Yt
	I5keOSpZi7vuWLSxgNrjssi0qQWGtp+GQ3lF1mKbK/lLlFRtCPlxRNSIqljuhB/NtE+c3zAqFwM
	prdTm7Shlw4EkUfj/XYlDaeyrNMEN59H5NDmQ9T2CPVmrT6AvL3vHa5f9qZ5PJYtcjbousUwLaQ
	dF+xsd4lQbGLAuEGI1xEISqaVS2mCAOeXOiZnu6AwlI8e50bjWY3cr1tlOPH2eJn0I11yot6oQo
	OXjoXjTlvJ
X-Received: by 2002:a5d:64e4:0:b0:460:67b7:54f1 with SMTP id ffacd0b85a97d-46dc30e2c21mr2268492f8f.42.1782377648254;
        Thu, 25 Jun 2026 01:54:08 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c1ee018e8sm15530598f8f.11.2026.06.25.01.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:54:07 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: avagin@gmail.com
Cc: akpm@linux-foundation.org,
	alexander@mihalicyn.com,
	axboe@kernel.dk,
	bernd@bsbernd.com,
	brauner@kernel.org,
	criu@lists.linux.dev,
	david@kernel.org,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	val@packett.cool,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu, 25 Jun 2026 11:53:57 +0300
Message-ID: <20260625085401.3787887-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANaxB-xUrLQYGiRJZc4Boi+KX=0TJSWymErNovANVko20fMDVA@mail.gmail.com>
References: <CANaxB-xUrLQYGiRJZc4Boi+KX=0TJSWymErNovANVko20fMDVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B68F5180002
X-Stat-Signature: 9h71f88wd5xnkorpgfdy163rk5gctpyt
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782377649-756988
X-HE-Meta: U2FsdGVkX1+n4peuF2cJiloRilY4beXXG9Q/k4BkJtquobnA++hpgiTyZNvWH1U3m9mG1gcvQiEIW1V1AMZMuoz16LX4R8K9HNFmpsI5wjZjlmUZ0DkRY4tpWDCmncBgz4DY8yAiO2m7BlEuRtKti94GYj+orcPBaKiVy1t2J0VHU+E8mlXRH5eg3r1gKeG3cOOV+TmcVee58TKMuoR3CMJTEoSZGqZCGCJHUmtTiqXboSkj/AHfKpvGU6caGsSydukhsTujft6VB9I2wHadbuumgAFKbZ9qEesosGz/QQIEJIvs2qYO4IoonthjM4sJA5WCHkew4bJl38g3ZjEKQFnogeR0CQiICUpKwrAeSuzfFj7Hi1SWgFRGvskCR9MPtHUW0WbEhkLJWUPMZadXuBXwiFRG0yvG1JKkaVw8q+Kc3KH+gvLKr0plHc1NsDXJFnOiAA9kj1C/k15fHx/7cwIoJ0Vz3+wwWO4BiKquLhnkVe2byywh5PwiLYty5RPudg+50oR3JCgJ0hPlluoAdc8KmN0ekB+BHqCWFmhtRxHj5LECaE7x48Z5CteXDJiMPLyo0YWSlMWYoQHPb07mKvx7Ll+PU49xcUKiTMFZ6uF3moRdkojmDUpu+VX+4hZR1hmHX6jTgi/eDBEDopm/a/uUZ8J9O6MNYqltrpbgpbLazGJhVGpi1Z08liUVItm9RrB1heZd7eX5T7D89ZO+kumElfVcQrtvl28Ag4UW/pjpVq3RTbk3GW1j4IQyud66Z9SGUD0pGrRMiBGHwDqf8zpJGD1Dw4L0M9l6zzNe4+p4CEQJhrwpT1ZD8nDWQxroxcfbe6arGyr+YoHxP66FnojQzJoDssdUbHtCui3NZ65V4ppNahAg39UBRf1AT+kJx5tL4PZjDrewUw4Xd7PxHB4/otabYD+NRC0OwQblHUFma3RGJWjPCOJR4fN+VCz5DooqQWNNToG2OXtHHBA
 vlidhnGQ
 17H881zEJNOZmPYpRgeYZ7DGg1nGgDad/cq00BZSsAvA0QMccA7y5RKVcWvCm95tEc5fMrp2WByqwmnDXoPPwl+1/j0qMfc3Xh7CdYZNRF9bYDTWYQEAnoWP3bzHoFIw8lrQwh3kdgr2EoaX0GP5lmOtouS0DHy0tDp6m+OutoLiAljwyU5/G68c/JJLRiLc8S+Vvgv3lltN2RSIVsfMHgzypv7WS1BjZ98XS57npzQoyBQWwJvpMQX+kJSQe9xXYnWOuG8LiNoryVAiuQSLSx5rtZ66Ij8O6nH28cco+CTdzAEmVpab3V4XvjpAkHz9iAPjJxuVpqiREw0qZiTNN1KUeDFm9CS4MZnkX3/iUzcmiLxVb8l6JmwYY+ZKfH9ivQny9h4rJ+Wktq6eF56Zy4m/WM7gfQ9VVJpB3vJT1Sawpez+gzeTrDqjSqWCA835MXz8tTKhhLs4EtUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrei Vagin <avagin@gmail.com>:
> On Wed, Jun 24, 2026 at 12:12 AM Askar Safin <safinaskar@gmail.com> wrote:
> > Does CRIU actually rely on ability to do SPLICE_F_NONBLOCK vmsplice into
> > named fifos? Or this is merely a test?
> 
> Yes, it does.

I. e. CRIU relies on that named fifo behavior? Okay, I just sent
v2 version of my fixes. The patchset contains fix for named fifos.

Please, test that this fixes that named fifo problem.

> I already explained that this isn't just a perfomance degradation, it
> actually breaks the pre-dump mechanism in CRIU. vmsplice is invoked from
> our parasite code within the context of a user process, where execution
> speed is critical. A heavy performance penalty completely invalidates
> the pre-dump logic, making the feature useless.

This is very unfortunate. But I still want to remove vmsplice.

> At a minimum, we may need to consider a deprecation plan where vmsplice
> with SPLICE_F_GIFT triggers a warning for a few releases before these
> changes are applied. Alternatively, we could introduce the proposed
> behavior alongside a sysctl to fall back to the old behavior and explicitly
> state that this fallback path will be completely deprecated in a future kernel
> version.

My patches change not only SPLICE_F_GIFT behavior, but also vmsplice
behavior in general.

Let other developers decide what to do (i. e. do nothing, remove
vmsplice now or implement some deprecation scheme).

-- 
Askar Safin

