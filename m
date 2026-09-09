Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E02C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 20:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C666B0092; Wed,  9 Sep 2026 16:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D276B0093; Wed,  9 Sep 2026 16:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BD06B0095; Wed,  9 Sep 2026 16:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB1C76B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:11:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76E2980317
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:11:10 +0000 (UTC)
X-FDA: 85195317900.22.1A5AAC2
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9DE0E40003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:11:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a3YhvLvu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a3YhvLvu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788984668;
	b=WMtfq4OceenP9+WfaxvPPfUXITvguZMaoDYkn2xS8dIevm+5SE1p3mtSzcg7tA1TW87d9W
	dGux3JH6UO7iPK6m85xO6bglMU95vdhkhdn+5A2NvoqgA0VeePRGDrW3aTaPzWf2uLaBcu
	A6aa1XXZ/QBImcZAnPDMKbUVtvUyp4g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788984668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nqOuwsqgg0fRM3HpI/iUpxVRO339G5Gp0/QcOudjtY=;
	b=nGjH/EIT+EHQZUqZsjrg+RJc+FdXjKzBv2v+1AUnlMkP71dx1Pvo36bRbdtcqWktaQiFQP
	IgKLHEnpFseUd17XmniSA3NfDBWmR8rI3mntEhPsNDk+9tlPDagkuim1NWvwrI1Ycjy6hC
	Lr4oujbhOdVl31d4y3S8r7fnj90BM+U=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d944747d41so70375065ad.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 13:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788984667; x=1789589467; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/nqOuwsqgg0fRM3HpI/iUpxVRO339G5Gp0/QcOudjtY=;
        b=a3YhvLvuDrxoETyV8W7sBLmrMD9G2E0JnrdMPTevx9OMl0L9l568vcpNIFbWvAuXvl
         D7w3Q/Bf4ziNPdUV/2ZuqUPo9iswSmMmuktEx++HhilSAewzYGE1QxNBVaQIJVtdf7px
         pBe6HOtEzkPtxOIh83lVHfcqZiaLmgIr0XxYKr9gvyV++cev4wypzbIpoVnp2ib4KJGs
         WAxp/v/v72IQB11wQ1fJW1d4QIB130h9di78KNfbi8CUZelgCLSiMbSZsCS+vUJ/vPjI
         XoZJa9Avmt9MJnW5oPDUctWNEeBPf2VZdTgk7DRhLCC/rsA1Mmmhx7ItIzZbRbyrjQrh
         nXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788984667; x=1789589467;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/nqOuwsqgg0fRM3HpI/iUpxVRO339G5Gp0/QcOudjtY=;
        b=jjAuUZUycDek59G6QPEcyTr2vKBIWWVfvkHcMnAXHEBZgKZDNZsO7MfoeIChzUsxIa
         /GAB/mrIeP702VSc2/sb6y996iTRe2B7x2DnQzv6WraZStspwc3B0pwJNeTsbvHByoZ1
         ZV9rmf+zzk8ikRL+OC6hmflFjLVomb3HT/HKzQNy8W8lNGzcdq+8vH+GWFME3Bqowejj
         SZZYuuHeQ0RxCRczJuNGTdc1Aonmd4xGhL3K3leoQ++jk8Tk3cO9W4PwOsy3E4ZsXtjK
         BKJf0n8GNH4R1rk24BBX06+8KgfMJe9i3XsrP+zFpPtgQMlfQLltVq73L5DuKfcX2BG0
         p13g==
X-Forwarded-Encrypted: i=1; AKwUvByH+Es1mpJt+RPtPZ+aKmSrf98tGFLN4a3S+TXdRD4KRHohMIhfDDt5XfjMgWPBN3DWikRNyiF8Zg==@kvack.org
X-Gm-Message-State: AFuF++mevc4QdqfoGmdw8fJ6eBPIVfrHSSyYMcCnQzylncJx+uaQPVz2
	Ip8oviNK+5XEifcLQ0FhBolv/97gbi7iYQ4tkqxJzdYLPLLpA8XM8S9J
X-Gm-Gg: AYBFou2vQ/g/f9pTpIb2Bw2oH8pkjBV3/GF9LkN0KPToQfSYDB0B//csUMGc+G5J92w
	XvHj0DwcI8nT3vkRT5bFKAHTokXMrqpo1hAnE5gjqTeoxSXcFe1ELUG6LX2J42N+Q3HMpq/lsRc
	qfAkxJ8i5QE7W0g3oVfm0e2dhMMgw7pBN5V1l9ozmosLf4FHxXAGAxvBKWEi8xiG5cxLaUYi/W+
	A8rw6JJ3gWYe1lL3MxHeYaGfC5CY3AT0374OX5/+hcNOm4f7jymAM4Saq58GChfyn3toHa5aply
	TjFS4WjtNzDIW8DprDCtZc8mwGWn8wuc7n6TeLlD1DRgDV9/d8plPxBzSen0gXVwvL84Ntv69vH
	UiU3Ub0ncMJAfN/7VdaMIWaXKwrGLt34+TH02jxXZbfqES+dTEzs857qjP4eAX/XHaLXF9W/Rh0
	XhcTlnaFK0xYH1XHt4K41f8Fh9C2+B7TLcxGDEjCwnwHO13/qPhRhDupJQpydvbFZUcZxUlSlWR
	V/itJkmEyxeFKq9gIuBuaxPd3U027KywdHWfE7TPW0MYpTVb7vbjmbL
X-Received: by 2002:a17:902:ef44:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2db1259d1f8mr510415315ad.14.1788984667252;
        Wed, 09 Sep 2026 13:11:07 -0700 (PDT)
Received: from mars.local.gmail.com ([153.246.84.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db63c00837sm41962775ad.40.2026.09.09.13.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 13:11:06 -0700 (PDT)
Date: Thu, 10 Sep 2026 05:11:03 +0900
Message-ID: <m2cxum423s.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org
Cc: tasos.papagiannnis@gmail.com,
	linux-mm@kvack.org,
	liam@infradead.org,
	ljs@kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/nommu: Reject wrapping ranges in access_remote_vm()
In-Reply-To: <20260909001341.6a7c3556259f7cf9a79c1da7@linux-foundation.org>
References: <20260909064231.18693-1-tasos.papagiannnis@gmail.com>
	<20260909001341.6a7c3556259f7cf9a79c1da7@linux-foundation.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DE0E40003
X-Stat-Signature: 1dyx1b8uq15yoinkm9rmdpqsq3kit4g1
X-Rspamd-Server: rspam01
X-HE-Tag: 1788984668-640282
X-HE-Meta: U2FsdGVkX18TqqypzdmThOE8RJoC39BhVFN7xdnfN11rkQqj+ztKk4G1ghcDil5cg9WnNz8z3j3CdwTmKv6CtQh6Z3LBxT492ziPrxeCSfzOw+X3BjGRVbpg6Uc22wKFP7XxWRHIFf7Wg99BNde1GWIv88n8bc99dUBlOMp6wIIplcC1Lx4Jl8iekskPkCVVTKmlzfXVq07aanv5EvNgBq3Td/fGkmE1NmpGJHF6nEjyEkcKG5oe+u99ebis8MnpqpO8H+kESXUYYF4/MkTfmtk5EgiNOFjNbtOoNy5h5EB2aJq5vY5GsLcIv9rrXZa7cSPmJSrTjVAA6rnE0vAnZHeVIajnxGk+8Xf5yx3hLbUOAUochSPHVxDnRGpfJT73GsxZ3d7wS2jqszZh5lP1TaKg8Zxi5llARJY0YabWN/NJEinO23zDYmLtU0J2Zq535893sZrZzDWjuXkz82QRTPYebLY0rCYFQHPsMDXCZ5Dvptqvn4Sjsxnvbrhgvi/gyvMdk7rQ4pKTfze1wAs7IXehetWlajpcCMa4LIB1Ck9mpAXwiELxcNFYvd0Lkr0fy6ADSC6afeTCFbdR2D4k6unVLv6huNA7gQ4U5GtmU8DynXZX9rI56vqwcpeZ7XqyBMFWbnjhJw5LZR2d2Ng6iqJ2b3UhrQ2FF9Iu4eW7OcjHVQVIpf3oXTjVwL94i/hKkoBfpzMZWso8CfJNpHmSHZAOd9FCuwM0BN6KO7b2+DjnRm0m1C2SL7ksQt7fv3DX0UJwJLZygwPJ/lPLV8FzfvRtXX5KFhy27KtRrFlWyXvSNoP2x1j7pQM0YX2VlDfsCzSszHIan6HMKzAWLSicVlAldX84IP3WEdrV81lgp2bxA0OnkyfUxoigM40pcRXW+iiaicdbA7/esgmXTTsWw8HpqLR4EphqOalx1xL4RmYiNjaICFJthfPic+DzHi7PUpzeVs8E1KJpNmtPLoz
 aJH38K7I
 ibo6gDXg7f13SiJPZ54yXA4sS1pALc3D5hcrOmi00wehxoo8+R+5rdRiT0UrHHuh/U78EVhGbggBsrR/G0Z+NX4mOATuzcnMOq4MhGS8oW1EzMMn8QHY5o3MsLsiRU4MgNS42pG5vTP/ikeX/8yKeGf0yhjpge2ZSWk62rA7FM662wPi76hWHtlDwB558iDTFDyqGnNAp9NZOljvOzYS4sxbxGOnFHC4zfJtwWlpvNt950fzQJD6lE25HwbIONwlrIs/Cjh69BstEkKn51dncE7wA/fQHWCUtS8d3nh4CJ63KHKHJO/VT1keINXOodCXJmrBC2G9w2v37fAVGQoMmZ0qhHpSL8PapXqVZxr9rKOTPQQ/QFXVabEQbDTKA0DHdSWUnbcqRz1h2n3fdANzwejt4UdrhfgZ0ynk92zqS1tdcPcjqO49ag/AgHa+FKTaEaSSKYn6CKN6ykh/9WozsJ9fryJdqmbJGtpTeGKP1xzY0lbOHmAHuVrarpc7uAl5uu9S30xPufKyb5YRNscm5CzIvHgRPWn+J0SavtGW1V+MrLY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello,

On Wed, 09 Sep 2026 16:13:41 +0900,
Andrew Morton wrote:
> 
> On Wed,  9 Sep 2026 09:42:31 +0300 Anastasios Papagiannis <tasos.papagiannnis@gmail.com> wrote:
> 
> > The NOMMU implementation of access_process_vm() rejects address ranges
> > whose end wraps around, but access_remote_vm() bypasses this check even
> > though both functions delegate to __access_remote_vm().
> > 
> > Move the wraparound check into __access_remote_vm() so it applies to
> > both entry points.
> 
> lgtm, thanks.
> 
> > This is originally reported in [1].
> > 
> > [1] https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/
> 
> Ah, bpfbot scored one.
> 
> Sashiko might have found more issues in there:
> 	https://sashiko.dev/#/patchset/20260909064231.18693-1-tasos.papagiannnis@gmail.com
> 
> I'll optimistically cc Hajime Tazaki, who has been doing some NOMMU
> work recently.

I got a similar review (from Sashiko) that current use of
!vma->vm_file isn't appropriate and should use vma_set_anonymous().  IIUC
that case happens only (I may miss something) with /dev/zero (via
mmap_zero_prepare()).

I also had a patch but am currently waiting for Lorenzo's input for
his work on /dev/zero, which mentioned in his reply.

https://lore.kernel.org/linux-mm/an8BlTgk7sc5vFJ1@lucifer/

Thus 3 comments of Sashiko (all about vma->vm_file) can be addressed
in future, and are not needed an immediate fix.

I wish to ask this to Lorenzo too.

-- Hajime

