Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92B10CD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 21:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50966B0096; Thu, 21 May 2026 17:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27E86B0098; Thu, 21 May 2026 17:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916E46B0099; Thu, 21 May 2026 17:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3016B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:27:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FA6B90A9D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:27:09 +0000 (UTC)
X-FDA: 84792712578.21.2487D96
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 280AE1C000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:27:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UOVpaPeP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779398827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpWgFYhhbnAeBja5/b81jA1gJjkVzB/mfvPZ3ghPp+g=;
	b=FDOASKXmcpGWskxqChRY2EEn0Eh9a7ovAsE/Upnn1XfLCooOfsnmVvCQULLaiKZY/UB8i0
	IFJCsIL1j9jrk2jLY/y6XmmDisKg0UNiMDA4pjnqIyjFcEo/kY/n7ndalr9YIpK8nxlhXN
	rjIWLiQ9JTonmdmWIrDXrWbXI2kh7Yg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UOVpaPeP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779398827; a=rsa-sha256;
	cv=pass;
	b=cnsl0PqXpYUI5h5ahIQ5v8UTYLdL5kkqKNLUnhFb04LDP81E/bxxXLHmmPecKxOxj5Ht5r
	MyAy6yI5VLywUOfLR6H67P2Tn+5v7w861J4NDov+jfl2i5eNWZbXfD3ohB43fW0wM1z8rP
	kRjb4dOmkKReGdHmf4RoptLUcmWWHCU=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-63130466364so2418715137.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 14:27:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779398826; cv=none;
        d=google.com; s=arc-20240605;
        b=R/sKrs7/7Ss+d6PTlW8YqftgLBh3XwJ+gk4W2tXSAiZA8UrXyO9WlhxIWlRJ6GpeBR
         HxneGIrLIGI1jxE5x9eiT98PD2iNSRWbXbzG8NEZ3QsNmq847wwXml1rkT3D5bmIsvsA
         0XdeMs+LyQfE8GxCP2aT101M3O8VBq1y4WbVujiOkUjB0NBTVR9f+b83mRR9w3pK+pPJ
         2IQR3ZOj8s6/DJwok/RqG9WWid22PJCUGY3K6qTS61Ry6hrC6zGxCXmhWSJiVMuaBLm1
         zz4+4Ta8KJSKrP+91aRKC/6/cK8oLmR/++ElFcWBWTNG1RJi6dI1lfj3CaV+UWagrHKy
         YSjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=jpWgFYhhbnAeBja5/b81jA1gJjkVzB/mfvPZ3ghPp+g=;
        fh=aG0SBMwtanAh9ZOgRt44tUb8H6Obb/8b4mSkp+4mBA4=;
        b=kpc0mNeimaiLx9BZ0PU9sYXXuCn30J1ugQkgFQypPkl2pM6f7AJ8AspvFLpJltXDF5
         /dqwQAhQRBYqHuOGuq2isCQQDP2pSEzJDpXWrESMNIxnxi1MJWBR0yh4d+QOqpci32/T
         wmG0oURoiE2ykAvSOyXKZmbtvRraJ4qnpHOjbroPsUmv26elvolZaOEYJJfKW8L3/C6B
         bfeiPJsoR87anVv0huu1oXRCOuUPwOkZRaYJZxKetZdPioBmVK2Gkn2DAst+/SMX3FuA
         3/dZTqSyxAsSSYCMubmyM26AHX3vqYBt2+vQ7Ne6Y676RVDN0Uj3G7Q0kxkII8X+tFjI
         SOHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779398826; x=1780003626; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jpWgFYhhbnAeBja5/b81jA1gJjkVzB/mfvPZ3ghPp+g=;
        b=UOVpaPePhkRc35llGJ0IGs23nkI0TITKaG4faoDSJ/WIT0KAn7Zi919hX9I2x20ge4
         X5vvJwBNN+DRJZ0WzQ+v3z56QeHRL0Fb+/QQVWvx6z6/BdwFVwVvCp/xAe1O1hKbF1s2
         8OCJ/6SLbsHH7PHtZcTExvLY35gpxAB+s5xZkxxLjW1H46zzEzJDHgT9y9ieUbF37/Mj
         tNTefS0o+Q1ULymMe+4gjf0t0HocQgg41VfZexU5J0t+XLBXk5i1TxUgbvDDVAUamsPx
         2nPcXlsfkuntcicHgI82lTLIBU+Akk1KwtBXVhZnvXekXl+RTbFOoiXkmw4K0+hPaYPg
         js1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779398826; x=1780003626;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jpWgFYhhbnAeBja5/b81jA1gJjkVzB/mfvPZ3ghPp+g=;
        b=PIFT6YyKbx+zpOflctSXUQBf6DkxGqr4bpSORn4ODAqrE9Yd6qdeLspry97Z99pSa/
         AtKhQq4Go4NiAkMcYMfRRluP8/aAJIi0r1V3X3NbQVHzzQmuSGKzNeo/TQcPk2GiDduY
         VUij9wzx+XdVw0gleBrwBNSOlUD2zS7XpboH/3J0FU4Lu9MerVHG1GSlfB9IXyQjip9N
         7wYmvR/cfndEsEN1KefsqeRbPQIi1e96WVOEi1Y6ttyToXqgbruD44IQwG/b7TPMaGP7
         9RYDRP6hhtAXfzejPYzSN9ET0oj1EgGZYpIwiUenbMjlv17xnYg2aZK/egb2976vExQe
         yhpg==
X-Forwarded-Encrypted: i=1; AFNElJ9dRik8t3RIVCozCiCr8jGfu3xzzMHe+o7BxuA+1cZSgfr+rLivoUhycdKYdhZzBLiFiopQGEQQiA==@kvack.org
X-Gm-Message-State: AOJu0Ywvrb57XF/49QEMjSG8aGva/zQM/pA5HX8HEN4VQxQEuJvC5Xo9
	k7gXbLYdnp6gLqFuzlIRHz5ZS7v05UbtP3aPdqmzuvPninRd3Hl/HBANbME2s7yUcqN4P3ayxP6
	WJxSFtXblWuOtN5cPpWUryLbDcpzI/5oVjyEEfQTD
X-Gm-Gg: Acq92OGuWpiuOlc4zZdbL10Qew0MXXM8pc53ve3gf00O7yt6fiQ2OF01sjmGi5DnwbV
	HyjtKAE0gWIqnMSw5+sHD6I652Vswdj4Dfu0QbBROi3uD1h2KTqXszsrRiWhOSppKm4dgXT8Y73
	nT5IAcpA956uQwpqh4awDj2fsSv3MDtbjcGnv0o9ExomhP/s4Pa5G28kCTWyTOura353o62Pfhs
	IuE6vKyABgGq5MRr+k6m1v5I6MKB1BSeOY+33QwS/SJcZY0pCrXm9ZLq7+joI8LHJ5V/Ryxznns
	e/LeYy7G/AnWxqq+j8VKEtrx4WR5bUVKUfBDGisFgLYRad276oczCAhNKdNzNwteNQQu1BIa2Xk
	cRsiR
X-Received: by 2002:a67:e7cb:0:b0:605:6773:611d with SMTP id
 ada2fe7eead31-67c7405f583mr398913137.1.1779398825479; Thu, 21 May 2026
 14:27:05 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 21 May 2026 14:27:04 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 21 May 2026 14:27:04 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ag8G7Wq5PbEdKloG@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-21-91ab5a8b19a4@google.com>
 <CA+EHjTwrygfMrZZSw4y7-ry8fidW2x0C7iuF2Q=dnPNHUmNtUg@mail.gmail.com> <ag8G7Wq5PbEdKloG@google.com>
MIME-Version: 1.0
Date: Thu, 21 May 2026 14:27:04 -0700
X-Gm-Features: AVHnY4JKrLHcWBnwxG_jlJLfen-f7c-olGgUCItaPr4oaASPSS6SIhxF205tXG4
Message-ID: <CAEvNRgFB8ydih9JTmsH06H32j38tH-iViZqN_eZ_gQAmXpw+Dw@mail.gmail.com>
Subject: Re: [PATCH v6 21/43] KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 643prxyrt7cja3oik9aquu9pug1e4fs7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 280AE1C000A
X-HE-Tag: 1779398826-867437
X-HE-Meta: U2FsdGVkX18EKHIMAzNFX4aRxJ0XcYEaKa5Z15z1L2WbFGKrdWr/iCKkpdgoSXYBjuKypTLSUC8O+Yza6h8ssOehFFspkFXh8BIf12HtCsVaJfHviA/qGjloirsxwb94DOdi5giingIABoHFm1QaecXt9VhDX8iOjDh7Em/goD3u2HEF/4BQ738fa0gFcjPvCZZlVnwjvLNrLVyWsrJXICj7ZLeWW8RstykzT6zlyiyLYpMREiRt9USGqJa4gY3CzanVkL8Ir7XdtPZ/9oQzA6Kb3754qWVlYoYKZy2jKUXy01di0wTvC3mvZQDxNOMCjrxaRePVa4FXLle4VEB3AJ4rE/LaETtpn5srUF7eH9j+iH5GT9JyYpUXo9gSikhXQKtMEuHEX2NywdjyoAvZfFTMlaFUzcX4TGBm0wv2+HgnbSPXHvv+zw5x/ICEAMvuBrHqVD9MDLnB3ZJeefFFd3ajk9GXCCsBSmgMyK33oRZja9NQhSN3FqhDRePRmsO8wim6jmQ9qKXMHo5qgn0JeI1pVhgoA4L1ABNTmgpa0jiSs0tHP2Beg+7y7FDTAiB/0evG/M4aRoC+7nlBqu8onXnMPdGuNuMP74YbAnXaYupw9/V+0RZvI7Ag7I3gD3aktWIgFa7IbJWsGJjl9R67lyVoxMkMI3cu8uUqe9Y2kfpouLOwd6E4xnsoCRTjZmcBzU/hRie0XKKPhh6iHApCPiKioFcQWxIH7HTfrQ54EOjqZCLYPzZ5e96fL6xdk2H+nBAKCH0YfjUmoegSHl8viNOcWh63f7De4NQJa0ZF07BHnlAK1OR4EK7M1tBPZE75xObS49EoPzlqLAXd1TXxBymARD0eGhwNuswjkHIqllEvBQzkMge+UyOMYnwZ/GK3E7rKkmlSptRj+7Y4DI15q35y3CUhdObP5wJsqFziQtkvA/CZT+FZYYMT4You6hEJkax3kt3TJyEkkLKqlaT
 HEIc/jJv
 3qMatfbQWljnd6K1UZ4YL93Mr7cCY4HzHavtOiytt5bzEmA0CpaSDCq8bAI28AJUBYGs1CAKqoS2S/JFpsAZRCc6Vaf3jCmwuFBK+pOPih9JorOhdEPksQZAAI6+N900JH3zXmP4pLewvqX2pag9kofSpADecx/8Q0I3HDP4yUpDLNGPK8BSNN+xgt6lrHcNayqGaDIJgsMN1mEAgOpRgdol2G22CxItKlwMwRzzyxSMWCzdFrMVlLhS9RT3WkBh6fYUSuYzkc2E95SPgsFFPnS2B0lWNFcSSIphvOanjNVMbQixKZbYOIrJAaHQXUjy3PBC02WXNjYA1eoTGyKhRls8pew08KId1mhp10q5MhEK8eS4Nm0hKP4dmILm8oDm3mWF1V6/3Xm3rc3GkgLAqxa1lWReuGZUKANuYT//RMGxjXT55S3p89a/2KVo2yCR/VitZzgC3AmHmVyym0XCVO75NyVGUWakFCOma
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Thu, May 21, 2026, Fuad Tabba wrote:
>> Hi,
>>
>> On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
>> <devnull+ackerleytng.google.com@kernel.org> wrote:
>> >
>> > From: Michael Roth <michael.roth@amd.com>
>> >
>> > For vm_memory_attributes=1, in-place conversion/population is not
>> > supported, so the initial contents necessarily must need to come
>> > from a separate src address, which is enforced by the current
>> > implementation. However, for vm_memory_attributes=0, it is possible for
>> > guest memory to be initialized directly from userspace by mmap()'ing the
>> > guest_memfd and writing to it while the corresponding GPA ranges are in
>> > a 'shared' state before converting them to the 'private' state expected
>> > by KVM_SEV_SNP_LAUNCH_UPDATE.
>> >
>> > Update the handling/documentation for KVM_SEV_SNP_LAUNCH_UPDATE to allow
>> > for 'uaddr' to be set to NULL when vm_memory_attributes=0, which
>> > SNP_LAUNCH_UPDATE will then use to determine when it should/shouldn't
>> > copy in data from a separate memory location. Continue to enforce
>> > non-NULL for the original vm_memory_attributes=1 case.
>> >
>> > Signed-off-by: Michael Roth <michael.roth@amd.com>
>> > [Added src_page check in error handling path when the firmware command fails]
>> > [Dropped ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES]
>> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>
>> I'm not very familiar with the SEV-SNP populate flows, but it looks
>> like Sashiko is on to something:
>> https://sashiko.dev/#/patchset/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4%40google.com?part=21
>>
>> - a potential read-only page overwrite, because src_page is acquired
>> via get_user_pages_fast() without the FOLL_WRITE flag, but is then
>> overwritten via memcpy
>
> Oof, yeah, that's bad.  Adding FOLL_WRITE to kvm_gmem_populate() feels wrong, and
> could break uABI, but doing gup() in SNP code would reintroduce the AB-BA issue
> with filemap_invalidate_lock().
>
> Aha!  Not if we use get_user_page_fast_only().  Ugh, but then we'd have to plumb
> the userspace address into the post-populated callback.
>
> Hrm.  Given that no one has yelled about overwriting their CPUID page, and given
> that the CPUID page is likely dynamically created and thus is unlikely to be a
> read-only mapping (e.g. versus the initial image), maybe this?
>

Overwriting the CPUID page is by design, I think. IIUC if the SNP
firmware doesn't like something about the CPUID page, it can update
src_page and then return an error to userspace.

Userspace should then check if it agrees with the updated CPUID contents
and then retry if it agrees.

> diff --git arch/x86/kvm/svm/sev.c arch/x86/kvm/svm/sev.c
> index 37d4cfa5d980..c73c028d72c1 100644
> --- arch/x86/kvm/svm/sev.c
> +++ arch/x86/kvm/svm/sev.c
> @@ -2456,6 +2456,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         sev_populate_args.type = params.type;
>
>         count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
> +                                 params.type == KVM_SEV_SNP_PAGE_TYPE_CPUID,

I think this makes sense given that writing to src_page can only happen
when params.type == KVM_SEV_SNP_PAGE_TYPE_CPUID (this is explicitly one
of the guards in sev_gmem_post_populate()):

	/*
	 * If the firmware command failed handle the reclaim and cleanup of that
	 * PFN before reporting an error.
	 *
	 * Additionally, when invalid CPUID function entries are detected,
	 * firmware writes the expected values into the page and leaves it
	 * unencrypted so it can be used for debugging and error-reporting.
	 *
	 * Copy this page back into the source buffer so userspace can use this
	 * information to provide information on which CPUID leaves/fields
	 * failed CPUID validation.
	 */
	if (ret && !snp_page_reclaim(kvm, pfn) &&
	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM && src_page) {
		void *src_vaddr = kmap_local_page(src_page);
		void *dst_vaddr = kmap_local_pfn(pfn);

		memcpy(src_vaddr, dst_vaddr, PAGE_SIZE);

		kunmap_local(src_vaddr);
		kunmap_local(dst_vaddr);
	}

>                                   sev_gmem_post_populate, &sev_populate_args);
>         if (count < 0) {
>                 argp->error = sev_populate_args.fw_error;
> diff --git arch/x86/kvm/vmx/tdx.c arch/x86/kvm/vmx/tdx.c
> index f97bcf580e6d..33f35be4455b 100644
> --- arch/x86/kvm/vmx/tdx.c
> +++ arch/x86/kvm/vmx/tdx.c
> @@ -3188,7 +3188,7 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>                 };
>                 gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
>                                              u64_to_user_ptr(region.source_addr),
> -                                            1, tdx_gmem_post_populate, &arg);
> +                                            1, false, tdx_gmem_post_populate, &arg);

And TDX doesn't try to write src_page, so this is good too.

>                 if (gmem_ret < 0) {
>                         ret = gmem_ret;
>                         break;
> diff --git include/linux/kvm_host.h include/linux/kvm_host.h
> index 61a3430957f2..b83cda2870ba 100644
> --- include/linux/kvm_host.h
> +++ include/linux/kvm_host.h
> @@ -2596,7 +2596,8 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
>  typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>                                     struct page *page, void *opaque);
>
> -long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> +long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src,
> +                      long npages, bool writable,

What do you think of need_writable_src instead of just writable for the
variable name?

>                        kvm_gmem_populate_cb post_populate, void *opaque);
>  #endif
>
> diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
> index a35a55571a2d..6553d4e032ce 100644
> --- virt/kvm/guest_memfd.c
> +++ virt/kvm/guest_memfd.c
> @@ -858,7 +858,8 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>         return ret;
>  }
>
> -long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
> +long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src,
> +                      long npages, bool writable,
>                        kvm_gmem_populate_cb post_populate, void *opaque)
>  {
>         struct kvm_memory_slot *slot;
> @@ -892,8 +893,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>
>                 if (src) {
>                         unsigned long uaddr = (unsigned long)src + i * PAGE_SIZE;
> +                       unsigned int flags = writable ? FOLL_WRITE : 0;

How about using FOLL_WRITE | FOLL_NOFAULT so if it weren't writable to
start with, don't CoW, just error out?

Like you said above the CPUID page provided as src_page would have been
written to before, so it should have been mapped as writable.

>
> -                       ret = get_user_pages_fast(uaddr, 1, 0, &src_page);
> +                       ret = get_user_pages_fast(uaddr, 1, flags, &src_page);

If we stick with FOLL_WRITE, this also solves the case where a read-only
mapping or global zero page are provided as src_page, since
get_user_pages_fast() will do a copy-on-write if those were the inputs,
making it writable before the write happens (on failure) in
sev_gmem_post_populate().

>                         if (ret < 0)
>                                 break;
>                         if (ret != 1) {
>
>> - an ordering violation with the kunmap_local() calls
>
> Yeesh, that's a new one for me.  Thankfully this is 64-bit only, so it's not an
> issue.
>
>> These predate this patch series and are just being touched by the
>> 'src_page' addition, but if Sashiko's right, these should probably be
>> fixed sooner rather than later.
>
> Yeah, ditto with the offset wrapping case.

