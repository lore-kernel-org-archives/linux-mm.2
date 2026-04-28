Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43745FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4D56B0112; Tue, 28 Apr 2026 19:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC2F6B0114; Tue, 28 Apr 2026 19:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2E16B0115; Tue, 28 Apr 2026 19:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6A56B0112
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:41:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BAB440703
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:40:58 +0000 (UTC)
X-FDA: 84709587396.28.05BDCCE
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 73B3F18000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:40:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="S5KLc29/";
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777419656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSQsiZsSkLpyfyftl7NX7sITr7YX8npk81aNrWQuVW0=;
	b=QGTYBH4EWxy0GDE8pMLWNZ1EO3tZpoXaJHwcpL7W4ZjHL4DTnWvNwDsAKyKo76IioPwCAh
	GWL6DyljsnESvWMt2Z18Jp4BLQUDx2uEB9LrzKB18NQXHTGpOi9/LEq/4nVBFABlXuD2ik
	qwq7NZYmI9xbGiUQFqUXCXhN1rZ52T8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777419656; a=rsa-sha256;
	cv=pass;
	b=ipbTEpkEXZRiLsdLadI/TvCVE+tsybvrPy0/0i59QAE/X65lV1dQeVaicByxrz6ybLy3s8
	q4693Wo0XvxYqmaX+rYsGOCqm8VIXF0iTLfXBrQFcdh+ZyevqsYq3COEAEF5vmzoELOZ3v
	CfZ0qNG7TwYJG1rQHrqG/HS0SvKBojA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="S5KLc29/";
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-60fee2fa3b8so3720468137.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:40:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777419655; cv=none;
        d=google.com; s=arc-20240605;
        b=PALQyX8Jgt58lVy9KDDf1YgMxYTaCHLLp5IOBIJmvkubaDPLdVyLLB/wxZJMZxFbhl
         bsCOCksZTjBAkr8Q3OeeNT7NqJvapBsl/Jr3jgvLcgY6rcT/6FvZZdwB48MaF4Hj2R6H
         bmYHXUd/eATOocx5/r6ok752yI6mM9S3w0/y7PsIOxUyYC/yFo5yeAkZER6qNvq4odXA
         roOjSpMoF1rBctEZkQ3Yh79/4lujfiZltCIP0Ooa7EOOC7qgnPAKn0WFuMMgI4d+aKAH
         98PatVKWbRYjWfXwvdjMuZHKCeGGuY+AlPcJIi19i8XkktN2E4a0l2qudDZq2gXyJn6G
         wSfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=fSQsiZsSkLpyfyftl7NX7sITr7YX8npk81aNrWQuVW0=;
        fh=hQsnU+On9aq1Dafvw0Z1ROxE+qwqXo8lHmhCZShos/I=;
        b=GyuN1Ln1z+jFgI8YXn9wU7WU7qMN2WG2HsK5GmMLEObo3ytk/KCX0zzDVlJe/LYju9
         Zq36B0CVd8i1zJuFQKAWUudXLwctrbYobEVmIBhx8+DckHH8EkhsfxmALk7+F6bKnAbj
         5zI9543vcysTcL45K5vZ1AjiSTtD97EQ2NI1uTQJLC7kpOp27KYHYTtZ1IgXLC9mJmWL
         5h9osZKC2taHbLJMfiwv+TLhUjmocckYaC79mc3CceWmsEhKxQ0mw1boWBNmY+4fK6jT
         ZAMJmVgxS1AfTDVfVW+gheU57H/ozB+8aToBz7AJphJwKBj9OpMMtKs7+u0mjZFFKXJA
         t6DQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777419655; x=1778024455; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fSQsiZsSkLpyfyftl7NX7sITr7YX8npk81aNrWQuVW0=;
        b=S5KLc29/AwyrydmpTomsnIR0BzlbrMdysERj7vdr9/GPiVle7RvnZzdiNir8eyc544
         EXahopmZONwgdIZa984DetKkNiLdaVj3FKY6pKmACuP9NBXTTNT89LQt5hEIUPvuln0O
         sIiaH+TCBMvDDng9DmHV5qdHiHj1ePhEHG2zdArev2nmUHhiBtwZh6DT9APOl38ukyJC
         ThsZnUKFykNtYY5oaUEF2eoi5bSkC2wwWxZ4ig2LRpDvy/BSmmwB1BT9yenhZDKYRuVy
         HL5oo6+Qq/gOAOfy+pxuiWC1bNVGGCqvR4V+oBotsgcX308KVdZDCJYe9uiQ0My3UYsf
         QJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777419655; x=1778024455;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fSQsiZsSkLpyfyftl7NX7sITr7YX8npk81aNrWQuVW0=;
        b=gCeJXIx4eF0Ze+nLYKgDsUxJ+Vj1JOhSuC7ydm+f7F16fNYkOzP9GVOlHCeywY01Zh
         OR1TQPYim8+11lVdmFYYxDBBuffyXUiKQSbtj+hwlK2nqC+RufDT0+isDClVicCgDnaU
         PeZzJI9Op5sIjEsiAlfRnSGidiN+x5jOTScqv0SozmtIQd3mbdzuA9bUWEe03mMfvPgF
         qvfEepfaqOvdxSWNlmk8SKZdZzSbS6hP096ERy3P/CDe9h60EWjrUcsgWtvTxf59aIEb
         MxlevXxdVSMxGA4wf1JwBlBdAsDp6lwsmZiuwAyBrcNcYzuMqShXV8lShLibpk7KZLvK
         CtfA==
X-Forwarded-Encrypted: i=1; AFNElJ+ev5BG+Kkq9maVF/51n0BThdeQSI4E9YiQkvESL8xI1M41HRG6uf7SapTc07+YGhl5YVbZGzfB6w==@kvack.org
X-Gm-Message-State: AOJu0YxKY9rmwRneU3Iu9T90UK6T5j2wrjHdCth0KcOJ9PwzHTa7OsrH
	W5lhN3MQdgJ/e4ONphrBH4KBfUFOJU8MEfdhBS0aoDazKGD6Xd6kPyRaxMoIC1PKlY66hekrZ3L
	j9lQQZnn/Wwk86cR27iBJmCCPr3b+Ya8ebZKxGMJt
X-Gm-Gg: AeBDieug1GxAvJ/isTUtZi7hLp/dfyKdghk5uXkCaU17BxQWdWUc9m1P+mHfJ80GPVU
	TdqmyT+Vgc+0oqQnKcCTRcEnU5uVgpnZPMKvPfI4SkEUDiWq6Zj7mvk6UVKPhUpUkMnRZDC3bjE
	uuCgosOgApFaixUUMLP5Q/dMOxXtw2IkArvVJunSuSazNgURh13ltrOEoa1rmEnu54KwwO+iszZ
	ui2k63EYHUlMhfzqWKGLiHz/FOn32i+f6vhHadyAWwWPaODfaZIhrv14YDwIhEnIfJFl8nrI+qE
	Cc9eU047wOJg+vm1CfH5ihjOnu6uTKqK5142LAxOTx5Nq5pWkRBYmv4kIaDeb5Ge3ild9+UtMzc
	He/lKbh+CngojKiw=
X-Received: by 2002:a05:6102:809e:b0:606:49d:183f with SMTP id
 ada2fe7eead31-6280b1df187mr2828068137.26.1777419655062; Tue, 28 Apr 2026
 16:40:55 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 28 Apr 2026 16:40:53 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 28 Apr 2026 16:40:53 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-24-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com> <20260428-gmem-inplace-conversion-v5-24-d8608ccfca22@google.com>
MIME-Version: 1.0
Date: Tue, 28 Apr 2026 16:40:53 -0700
X-Gm-Features: AVHnY4K8zc89tOubY_FIZvJs5RqMpzsyiDSJNy3Ts6m6f6GRhz2hBKqCaZ_7fHQ
Message-ID: <CAEvNRgGv3RZipinpQLCGUfBCAfS0PRc1mCx2yc3JgjfEu=QhdQ@mail.gmail.com>
Subject: Re: [PATCH RFC v5 24/53] KVM: SEV: Make 'uaddr' parameter optional
 for KVM_SEV_SNP_LAUNCH_UPDATE
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 73B3F18000D
X-Rspam-User: 
X-Stat-Signature: yjzfao8fuwf3cqctpad358z7ie47zrfg
X-HE-Tag: 1777419656-252494
X-HE-Meta: U2FsdGVkX18Irw1uat3mTx2Ju3YwwIGggbRUDJLtfJoUWZQYA5fwziFwmU3UDd1z1lspUCmLdova2mv0VVOMuzKIic0NQd1z308JtLNKBLIxWBEtnis2ZYQvCxhILjbOyUE1syCXNvHzizeKvJoOdx6RfuRUYih1/Wl8mxdehd1h9tfT1Mmu8C7Z1/TbK+P9fRIm2cP3u3Okj6TFZE4pBUSnrbclrjJJIGQN5QvZhDMkp09ieEOQm8yEgDrRWvW/9VHiKwrbykme2VR8eX2IUmyJt1ZaPzucebfcOBJR48MogM57mX1vGarkrcK78ttLgnfEQsKJyn49K9GAsmVcXBoJkvCc27eNoqq5eOp372nDs6++/xDdcuSRg5xJ10S+1Dwl2cvrqGpTcwbRJ6FXQGkS6tUH4oS1e8URN1MOVc4jRsphy6L0u3asx7N0wBN+U+BughybbsggP+LtdFGt2MRu0hJ4LzP6bq4uWVgRWZpUBZEOARHpzZIgFUzX61pfJmzJm4EZ/9QIMcEA7gJyXVF2VGlh3/Qx8YTS4T/MDwKM1BWWpb3trOGoTf1R11DnPBUwbVyv3RoFOEHLEPZg1x/y18wMx8Qr41tlvYrRvKdBNA3ytyrmjzW8zJpbGo3ICXvzTkuz7ayLGSyR9+7YPLfhv5vmBfyD8j43e9+wHxQnpEt8eUotjPD4Ppwep7J2CBzpXfwSn1lUO5f5Jny2tmQduTE6hnJJsEznCBmYTqAxvLtJGHqe93cJk/726x66XoZ8dWLnIhq+sR2SRbB01cJTChxZNIX3CFCjMu3VzirOAHJOQENDpRJI+69ZCtUhzEOXM8CYgGogldcNfVMAFkLYw5jaxIJI++5XSvlr2HBjtx20L7NFsFkl3y61hMdd5AnkrG2lqyBZxH0qWxU7CahKSOqM5R5WFmTqGr+YYEVRdJeLWA7GVtSHrY3mlv3x/piZ+qk2w/1RlxusQiU
 pWeqZIMu
 Y0lOUYrju2kBzSE/AWLOWfNZe7JWVmTvktoLX35nn5XnaC0+zTwj2sEWoEk99vQnqjB38Oddxlgqrrj7oypchCorwi9v584etB1n9V3CqHZmdXaM3WpV2VzksAIpjGvgjIWWQTjReugy+ZrC9NFhu9s0ykKCaByyJyYQod2sJPtkmvZtPoaFAt1XEW66FJIlzqaSbr3BnUaNlVXhVKRqxGF4RGjvSZBs2YfDyhvbAdNVP8GhFZGqFKvd/ekRLobRjjfL213dw6r4Mh6d5qWL5RxTmX8qvCq60B3Gb5jFxUCRRfbCWXV9SnHxx+PO122J55wAH6W5mplicfM9hYnXjH61NiUAT+B/FAJ72tW7oUvxQtvZEcLClifThJYXYIK6iSZXcp/vdaoJ3D1UgkIqAn9+V/eBWyp8OAIA62bkGH6IgmxHucv8lCFeDccNYLGq4Qz6uIikvvLzVeFqr503SaRuR41lbg8nzO7xDp83bFr66zusfQ2IT8eQD6Qqat96wLVOFEF51hlb3NJeNTgwAbc59KHFNG2EZeBnCVokt96uBG91CXmxV4ukYlbs153yna1Lex4CG63fkeFsqwqx6leMiYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> From: Michael Roth <michael.roth@amd.com>
>

Thanks Michael!

>
> [...snip...]
>
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c2126b3c30724..bf10d24907a00 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2343,7 +2343,15 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	int level;
>  	int ret;
>
> -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
> +	/*
> +	 * For vm_memory_attributes=1, in-place conversion/population is not
> +	 * supported, so the initial contents necessarily need to come from a
> +	 * separate src address. For vm_memory_attributes=0, this isn't
> +	 * necessarily the case, since the pages may have been populated
> +	 * directly from userspace before calling KVM_SEV_SNP_LAUNCH_UPDATE.
> +	 */

I dropped the #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES from [1] since
vm_memory_attributes is #define-d as false when if
CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not defined.

> +	if (vm_memory_attributes &&
> +	    sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page)
>  		return -EINVAL;
>
>  	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);

[1] https://github.com/AMDESE/linux/commit/7e7c29afdf3763822ced0b7007fc0f93b8fb993d

>
> [...snip...]
>

