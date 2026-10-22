Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405C9606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 19:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kGaVyFZt
Received: by kanga.kvack.org (Postfix)
	id 3E4BC6B09BA; Thu, 22 Oct 2026 15:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395E16B09BC; Thu, 22 Oct 2026 15:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285F16B09BD; Thu, 22 Oct 2026 15:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F42046B09BA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:39:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E86A8C027B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:39:23 +0000 (UTC)
X-FDA: 85351276206.22.23B3840
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 14DF010000E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:39:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kGaVyFZt;
	spf=pass (imf14.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792697962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXFOQ58yRb7ArLvRTOCPZICunogkgYzN7mdYgP5TB4k=;
	b=6jxlw+ofkLAYO3D2iCPLOpI6bggJF+S+qWFVD/Hs/I2OwRmTY0hzZTIdWuPywCsM7koQK4
	Fia1wHag/pxsk7muvZouOBNfb6tQUI1dqHbNe+u2bHbwkHVvCx6dtSQ8gn6httKQQgP9nN
	aG+ox7RsIrMYrD4QV/tWvEgIxtuy2cM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kGaVyFZt;
	spf=pass (imf14.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792697962;
	b=AM7XEc2ALTfDoULEPMv5UUChUJ9nRwRPMe2uS4CKcekQacgSwl4FiQZnR6KpcRsxq16U9V
	51Cocpuk9uY+5JsR+Fe9wcdR81y7kkNLBdsLw9+ioPiLvcScBehiT+6KBawYmoBGuIwk5E
	4OUJpscjjARp4HUcSqiHj/hAr5DOFG8=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1ec92f655so1125025e9.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792697960; x=1793302760; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CXFOQ58yRb7ArLvRTOCPZICunogkgYzN7mdYgP5TB4k=;
        b=kGaVyFZtfjw6hwN8o4koom6fSoyvgUmqUhPaSQN7OzZBeHLZMFV8qriDmZqQrqS5yn
         4p4vUZ0K1+l8rECJpe6pv6jVNHYfS/n9dSfrD4A6kKQrZrMgzUCJJ5U7D/3fx7C330Rm
         5JOWTNxenadwbWhfMY/PmEKPgeaRmNH3wu3nai5ib3VQ11ZRMdvA8YmNnSxC7fD+YGNk
         4kSwpBqLteanrglXbSYT2jzfw8MbbQx0+5My4vqg/9mU1x4UpB2FaqI7MTqIlElrr4yf
         Tw0pMV9ggkPQiHXmtTfG/+rG/Wt3X2hf5GCXDERuDVqVYF4dTFY4bFQCPZCMyGNNk0Zf
         +NRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792697960; x=1793302760;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CXFOQ58yRb7ArLvRTOCPZICunogkgYzN7mdYgP5TB4k=;
        b=fADqzr5G+lX2conR6VSoB/T43QpRNZcGsmYGdri4gSaKVEWqmRG8A968T7b/s1csxk
         GsT2f4pTIIGKbFm6bbgHBcNbCd0KLKg5M+K2bu4YT17Ngi4cz/0nkYta3kLQbJCMkq5B
         JCMSDKC1q7lFEEbGm6ahw30dcmWIbdY0dEfWyTEtHuRqmCXyjJwkmtplvpd1MIT0Y98C
         wMXm0OwGjiwetOX6GO8DRdfKY1qpPmXFgemYpT4pmTlu2v4IiGKNDhHYqSwHW8RwWWLv
         o37OXEM7o0Fggadhy0bmFEYngwkwlJwgnvlw09zpMxKhn6Nq+lvWBhQBwIbE3I5ImmpT
         S5Bw==
X-Forwarded-Encrypted: i=1; AKwUvByy+jj/JuidPkTJYyawNARzGbqiywyMZIi6uAAK0xOYIAMY4NhY1aTUN6vSDxy+b7Eqlu1kDUltww==@kvack.org
X-Gm-Message-State: AFq9FYK6MQlcw+1Yx6Url2w5+51uBFi3W9ZRMs6W+Fp+gLOgOuVE0Ae8
	KTgLtXTadqg0XkWMoHLrtuw9T7LobxaNX5Nx1T6jLtK9oCPjIio9bbtB
X-Gm-Gg: AYBFou1NT+xUGTFWGCcBdnIPdkcFFGvtMRj5U1exh4FlyQBZaQd2BiMaHyiz4yeF3iZ
	IxYqlNaGkh36l1s6PEz+L4/U6t5h7cT+hDSfluXsOgpnBpiXUHtgw053k/rLIwJkAtArgmgdAlA
	DoGjYP0Rbf1z7HlSApbaEyV+EV9yAVU0pHiP7rTQQNJq4rvy/536u+MZJAQa0O21Nm0IaydaWuX
	bTQ/n2Pr8e8Z39hKiXxYMm14xTYY2zxVYY1QH5hLzZk5D2c/7Xt3VY9TEP2Gol73fiXMWwx3uLl
	xbMGPC6d2AF4eFvt/MWdWQDXFxsfGmxk1WbYwJZZ5ch4YAvfwnex1wGDMWL5WLPefV1Uh8XRc3V
	fGxZr5zqD4P4lwlI042qWUoFcIFwbFo6vxQ1fmrnOgFqK/rsl9yYpfXVsoE/91v8J7TQFicc7dt
	E2TK9qA20vrqTatzv5f4pMoZBXS+OplMz/kTt1/eazCUMTKI0ALVJYTMtz9o2kUtUL4Q3ojiHjH
	q4m9GH+h+tk6lP0h0xtHB17HmkEBGB2yTv2ovRKRGM=
X-Received: by 2002:a05:600c:1d1e:b0:4a0:34a:588c with SMTP id 5b1f17b1804b1-4a211c859dbmr1721105e9.14.1792697960247;
        Thu, 22 Oct 2026 12:39:20 -0700 (PDT)
Received: from krava ([176.74.159.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a2101cedcesm20827015e9.0.2026.10.22.12.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 12:39:19 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Thu, 22 Oct 2026 21:39:18 +0200
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC bpf-next 3/9] mm: Expose locked mprotect operation
Message-ID: <atpmZt_Je09hdlja@krava>
References: <20261021195759.119421-1-jolsa@kernel.org>
 <20261021195759.119421-4-jolsa@kernel.org>
 <atnjEc2-6CuKjFzH@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atnjEc2-6CuKjFzH@gremlin>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14DF010000E
X-Stat-Signature: jnc9adxdfena9jtpyn4mh44y3uxmfq7e
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792697961-886388
X-HE-Meta: U2FsdGVkX188W/lyOfQhNQNl28+foxFQeS7Vuc1/FJPpmze9y8npTFeUVMahitsTgxnUNKS+RpxVLwZk/n1inD/Ozz9hfV5HMvP8eUr3t0o25FDQoV/0nViHVpgykuyJ/oBbWe4cjcIO1VFrcSZTRp332n3EJ4E9qvOm8PDRi74gWnPt+DX46v+CATwMk505zmKrYO2U4NtnDGTt1pwHGtbD1zozekSlrqnO2hBZcGVeC9tqHsL5vTzo7q64TpeTaX+6JNER5doKPX1nH7LvF019Tklgn9ieADtcaZyhkLIqJ+v3nBb19Xo9ojFZgQMckK/fQ7duy/Zp6VhpLLbzXmYRRgvzDsAG7rYuMOGQKzCoZEO8HANJhncmsx9E/CFoezfUCVofaGgAjNtftP6Fl15U9C8y42A3db2ag+OqaVEzY+oyVa8I0RiWVvib9kfNMA8QshdwK8fGBuN38PIXNz/lFItqyqSHt+wmaHz/K3vXFg/44EafRJfBsxrOKHHe15gzThTYLfoIcJQBOEHzDA8K+fhDP1Ll7odk1eGZ8OVayqX2k6Cp973E0ED13eheE1VcS9j52D0dNlGpmTN06WQ60gWSPhsNJjxFyo2bgDCMTJXS1lvwKMWFKd5aiYZWf9yBCkyoHcNBhPFMez54C3WLri7tKV2SnuXYicZCgfP+iEaqe9a5+argrcaN5yF3UwFsSYfXt+FMJl/sppwF241yHCrZK/VwBvnSmFRzCwMnypT8rakOlQWgekhn8a/ffIRVpDurFt/M1r75MlnU1zTeR8hlubqwgsniEdSApPpvaN1O9PIYP+Vqg+HwP3wQEw2LiNYxwZSNhk780xvv11sdBHToeuy5zEy24TluPDicgzt8oYH/n3sy5I70BRzrrKZgGQpzh5e3deBLPs2ZbVcdIi4iyMidOzQvccerlr33cFDpelgxEEw28GqtvkmTM1csN7acXq+NAlirv0t
 6wlqPWhZ
 Qs1ce4TvVPYlSTXl0L14LjB0ZQgikOQBDe+n0onQvXnXJwDCM49ufOPYdQd7lLIVlkVCh6wpxtXAYy51euHcp2OuPBD4N9ZMcoXdP1+n9zidIXGXV89NQJDvj1HaxZo6ppHGnH8jZfh4FJw+eeknATTUTOAG9njLNgxyp+Je6JTSuaI1PtmKN9YPksfVCCbq8pKZLbjbERuAtroR2gtKJ1kwn7OsySbI1U9xK5DhRHeBwPoHl4LAslyvnp95xHP3ZZ6urUwjr6rzQYiCdbiwGLmvMdKUf5VmrMWDQuwbxY83kcrSz8p+O/XFBOTaudz3xwAce4w4Zf8sV6N6mDSPd5YjC3SyDmbFQWuNcrfWMTMNoabXh++wI0Y5rFOHlW0baPNxnzvVpGUbRCGk6aVoCtOyWyEp8K+6P/GXm82U/d6HVz8cvt9jLNQnBghBe6dd3oZjsyDTBhtDKKDpnw2fUd4gE/v8M82wRTYd2GZ0O2qB1XdyBCegYLucMfuJ/bw7/cdwfMMLDTlqtrnF2ufz4XR546nStzBJyW1tQ0nAYqjnFzNJvCdKByvwZFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 11:25:31AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Oct 21, 2026 at 09:57:52PM +0200, Jiri Olsa wrote:
> > The bpf_user_page_exec() in following patch needs to change page
> > protections while holding current->mm's mmap write lock.
> >
> > Exposing the do_mprotect_pkey_locked helper for that.
> 
> Err, we'll need some more justification than this for exposing internal mm
> logic to the rest of the kernel please.
> 
> Note that you're already allowing any caller to bypass
> CONFIG_ARCH_HAS_PKEYS here which is immediately a broken thing.
> 
> >
> > Assisted-by: Codex:GPT-6
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> It's a no to this in its current form.

yes I suspected it'd be a problem, but as you mentioned
in the other reply, Alexei's proposal takes care of that

thanks,
jirka

> 
> > ---
> >  include/linux/mm.h |  3 +++
> >  mm/mprotect.c      | 20 +++++++++++++++-----
> >  2 files changed, 18 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 63f40e615754..47e853093601 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3435,6 +3435,9 @@ extern long change_protection(struct mmu_gather *tlb,
> >  extern int mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> >  	  struct vm_area_struct *vma, struct vm_area_struct **pprev,
> >  	  unsigned long start, unsigned long end, vm_flags_t newflags);
> > +/* Caller must hold current->mm's mmap write lock. */
> > +int do_mprotect_pkey_locked(unsigned long start, size_t len,
> > +			    unsigned long prot, int pkey);
> >
> >  /*
> >   * doesn't attempt to fault and will return short.
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 2888ee638d87..8d800830d3e1 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -868,8 +868,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> >  /*
> >   * pkey==-1 when doing a legacy mprotect()
> >   */
> > -static int do_mprotect_pkey(unsigned long start, size_t len,
> > -		unsigned long prot, int pkey)
> > +int do_mprotect_pkey_locked(unsigned long start, size_t len,
> > +			    unsigned long prot, int pkey)
> >  {
> >  	unsigned long nstart, end, tmp, reqprot;
> >  	struct vm_area_struct *vma, *prev;
> > @@ -899,8 +899,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> >
> >  	reqprot = prot;
> >
> > -	if (mmap_write_lock_killable(current->mm))
> > -		return -EINTR;
> > +	mmap_assert_write_locked(current->mm);
> >
> >  	/*
> >  	 * If userspace did not allocate the pkey, do not let
> > @@ -1013,10 +1012,21 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> >  		error = -ENOMEM;
> >
> >  out:
> > -	mmap_write_unlock(current->mm);
> >  	return error;
> >  }
> >
> > +static int do_mprotect_pkey(unsigned long start, size_t len,
> > +			    unsigned long prot, int pkey)
> > +{
> > +	int ret;
> > +
> > +	if (mmap_write_lock_killable(current->mm))
> > +		return -EINTR;
> > +	ret = do_mprotect_pkey_locked(start, len, prot, pkey);
> > +	mmap_write_unlock(current->mm);
> > +	return ret;
> > +}
> > +
> >  SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
> >  		unsigned long, prot)
> >  {
> > --
> > 2.54.0
> >
> 
> --
> Cheers, Lorenzo

