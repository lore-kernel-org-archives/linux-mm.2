Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19029CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52DFC6B00A1; Fri,  5 Jun 2026 11:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506946B00A2; Fri,  5 Jun 2026 11:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 443166B00A3; Fri,  5 Jun 2026 11:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37BCF6B00A1
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:20:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5CEB140197
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:20:38 +0000 (UTC)
X-FDA: 84846220956.22.CC3A74B
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1393914000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:20:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=samba.org header.s=42 header.b=bXg9PA03;
	spf=pass (imf23.hostedemail.com: domain of metze@samba.org designates 144.76.82.148 as permitted sender) smtp.mailfrom=metze@samba.org;
	dmarc=pass (policy=quarantine) header.from=samba.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780672837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eOwiV4Ir0+AZG7wQerQDpTKBJ828HFU+2fFToq4R8DU=;
	b=hWSNdzvFizayTA5TrWaxuVCIXvuSZ3bnW/saSLGKjGStPSRJGNvGLQjVSKCp+J88vxU9LR
	+wYZFArz56Q1AoXCWBUF28R7aq9ScIl/gQpUJAEsM7uOSnidDrBpybV03tXaghALaGZ7MT
	gRF6OMlIJjKvvAMOjHvxNJeWXT9BHaA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=samba.org header.s=42 header.b=bXg9PA03;
	spf=pass (imf23.hostedemail.com: domain of metze@samba.org designates 144.76.82.148 as permitted sender) smtp.mailfrom=metze@samba.org;
	dmarc=pass (policy=quarantine) header.from=samba.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780672837;
	b=Qv6mag2GmRcbDXap/mTeH4dJl3lm9Qa3PQjSS7RWpXtJ0QD0zA65gDcGfZxY/IDDKNd2Yx
	X7w/++IMH3SbWVhVYjZAiO6ST6u9GDK/KVpRvxUUVw3kMQTbsyhxgldWvp07sVxZAvQIYL
	bxD61tvEq32Wqa2d++LlRjYGD18gKvM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=eOwiV4Ir0+AZG7wQerQDpTKBJ828HFU+2fFToq4R8DU=; b=bXg9PA03iupcur1W8zNsLEJbSn
	WPIQsFUFOt1tjTFPx3VEwwZmycHAOidk+WXf6OUAYhMmZWSV2Icros8OIx55vd8XKMGcTuZcAFET2
	BZZFGA9Zz5XAizo04SUszT5UUNSVOFV77/3CwRFg/A4QsS+pv9hgsYlIOJIVMEqf71zb6hw2+rhkW
	UmknKXYhZ52hNX8yGlFlLi9QVzLTSX+NIVHkXOQlz7nXw0cJ/qiqyk7MutHtBNCuVaOIwB7vXsDyv
	I8WqM2bl8ZO31yWY7tVo6H36eyeSwgAaS6WDOX9qAJHHskKWKnpVjquP7MlO2ZKcNaa5USncoxLlH
	TAlnaZreCOxo+GcFE9FgvwJQbiIJAf2ILv6Gxv4LNL0cniGNhkYWJtYZJ104yN93+YRd16K8/kAJC
	56gnrQbqwk8IJFUxth/6IMTICraMrYnRWT83BS/1Z2bO5cg9DTZSWZ7o0+3z3vE8awC648WxiWShc
	Gx/sER+fb6Ht88EdEMSAAV6M;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wVWLb-0000000EIWE-2JiY;
	Fri, 05 Jun 2026 15:20:35 +0000
Message-ID: <634c8ae2-3f1c-46b1-b002-1e2ac797dd80@samba.org>
Date: Fri, 5 Jun 2026 17:20:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
To: David Laight <david.laight.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com>
 <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <512d948f-7883-4d8c-b2c5-a777e70ca975@samba.org>
 <20260605131942.4584728e@pumpkin>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260605131942.4584728e@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1393914000D
X-Stat-Signature: n7kwih7ehn64oegxhmktq6ef3csm7go8
X-Rspam-User: 
X-HE-Tag: 1780672836-886020
X-HE-Meta: U2FsdGVkX19Qu0Zj7x/dgbhn3QZYoIqKWolIGgI54VqGbA+Hw5t8QfwrcMrQMNlt+S/4CsIHmroEJFCr1Kfo6zeg8qGFORJ2uconkcAbx2LTsL78Xym0l44baU34MnzKoKEowkP48AIFNr80UVD4EbmOTs4J+CigzwoF0b1mynaXtwZWZDP4UnaMfV1CMimnudbw/SbIav3S1PmG1FRuFYOj3I9InCCo3zIk7B/4po6av54IahDWyCyJ4LKk/OCR0lWF8FQ/zoOACjSiPdvD6rZDLSzZ5ahQSSNhbWA5i87JMSwM+cheiVC4scBXK74o45Y6ZHNhzu5dCD6FZA66S0eo2CeQmJzIwlbmDW3mtZPC+MySXN7IpKGTnzWZ608YScgd45pFIeRfdWl3j12zTfJ3rew9UUVc4jzNuz4ylNc5pBHczajlnOOKLEyvUUsxovi0v6p4dllIBDbyJuqgP4YXEummLtNW0LW9AltZexi/lWGeNjp7GK3tjllmsKhbIVxMxndYcqCISTg2E4rYVvVrJcU6B8gehGbnxrr59AGni8K6SpDtGdnqC9FbTq9lAwWQptHh7plznVPNsTMwS0FL6/x7PVJw15mmIUoudO+Bsb1bJRH/WCSuOOe3mmbjyVe3nWASaPPyoUtmDAZ6BFcJF2xkD9f5qgpnv53A4vT3Ixi6pVhFsngeWjrDtCUiX7kO3hUtvKHhUzDwhfnShcytgy3ejTZ/Xty3Xfa9bUvFdSMwTp3yVdzV5nCL9kH04VJ7Q4Ws1Lhl9NrhssOMaotr6CX4FBD7ddzKZ9LFeZt/ioELN/7jgPpgOREAgDZx7yje5u/ybE4s4ad4XwZ0vEpdR1Rmd5M1FN3Cnw/OseTYBsG/cC7xPMzJyOOToy5Eg/IKGH69KFgmayiiWvrcTLPPl+H8I9EWSUuXPz4QF3VN6fCVhFNbPV4uNPEYagfuWceM7RoviC1ZD9tTTB8
 fdFn2bSf
 eJlorj/f5lEGUHagAwQxAoakWz9J4zH41nylcsTflH/dVgow2zBwJOeqxoCwqUSCj1jp1443tIG09A+oXmIzaiQil8GgS+6RLEsafXwiPTe6N9lD2Qi01GpGOXdSHDuowPl0GSdmzA+26kY8u4jWTS03WA2AK4S7O46PlE/jbdzN4HcTfqpvUUuQoMP3mhkSizSsYHPPhPEFKhpAnXGpXELdPwoZLoQiw/s625f/MKnCF5TO6QqB8PhkqU+7b8ynIz1oSxBFozuhWHdYrBWpHwkBdKvQYa3sCRsqLxiJqiQMT94oW5ujrX1vSD3iqA1vSXsHTqLTnwXpC1DPJTsblI3n0pLa6IJHq5SL3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

>>> So sendfile() as a concept (whether you use combinations of splice()
>>> system calls or the sendfile system call itsefl) isn't necessarily
>>> only about the zero-copy, it's really also about avoiding the user
>>> space memory management.
>>
>> I don't think so. Ok, maybe for webservers just serving tiny
>> html files, that's true. But for me with Samba it's really the
>> copy_to/from_iter() that is the major factor.
> 
> Is that copy also doing the ip checksum?

Not in my tests. I guess there's offload in the network hardware
for this.

At least at the syscall layer of sendmsg() there's no checksuming
happening.

metze

