Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61986C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510586B0099; Tue,  4 Aug 2026 11:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0DC6B00E0; Tue,  4 Aug 2026 11:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3651B6B010B; Tue,  4 Aug 2026 11:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3CC86B0099
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:39:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BB92120179
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:39:52 +0000 (UTC)
X-FDA: 85063997424.24.D723C4A
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 92A7516000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:39:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mQudjkWq;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785857990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CroU6+PYSvOtV4uy1av7nC/Q1rK5iyolsTF+JTm0nJU=;
	b=C34OTuNNUypggvFO/iqXyjP/b00aiPf/VssnUvfPIZVREDWvD/vE7abP7i8hfYi+TzL7kT
	ekJi+hi4CMeJ7lP356MStMZHnS/PsQAucmm0xXyBun7kEEA4KJ0x+fFRudsQf+PfUaHgKD
	qYU7L41t8D1kbTtXNZbLbFhaJyC4B+k=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mQudjkWq;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785857990;
	b=KGvb/ChVZwscorOMktY+jMJu17RkPIiyS4UeEYgDNoINQli9r2GkCJU0nqEMddBld0OVqU
	Mrt2B7/dijGLUtj4OPmtOff1Aap3yuFdAhye43AkSGMcQXHprtXKLWnb8r/QRKtrcpQGTo
	wgqD7y/BbNpsRbbBhSjcTYecyGCtyIU=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso3722998a91.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 08:39:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785857989; cv=none;
        d=google.com; s=arc-20260327;
        b=RFSLrPBEBWYK2tEG6/IN3ISshIQOGC0xBERGxa3GxYgmP/KlWil9N+AzRqNtQ6Ucju
         ARZU9dK7RpnKrzMFgbrYJ2urmGgWWBYMdNXA50D9qqAunl88OXB1hD50jlw+g5dmA6zK
         CcWeH1UgKXIldhsON3TMRkGGwHoHti3lnJrBNfJPOxVqiaUL50bsGb53dQ31ONu+D76M
         Yd64/bFjQ9MaT1yTHPm6NM6xwQPsykz9a4P93L64GjUceolPrhLCROIuYftcVLqZiSF5
         SSH6c1jEoTL+Y+slEE+fGPwnOKcnZPXZEkyEoqgg6EFusDEnUCrxtmHBzOLpoGIywpsn
         8sjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=CroU6+PYSvOtV4uy1av7nC/Q1rK5iyolsTF+JTm0nJU=;
        fh=Bdg72t7AKefOHwazfUxlRHrK0BJ4qm4/m+qcfFQ66+o=;
        b=SraZR8KbtcNFW0hGEwxF3wITxewjviNLQ5Ywh30c6Kwl8d9ec06IOHLl0V/cmcxoTh
         bZkDu9HcWrfvNNvHWfsMbftdOJ0QaKOVvFqSCPZpL1Wd2xSQ+p+I4QrQ750601A+MNqZ
         Bkh00jbjYAn4cLj4o5jnaD1eeLVPbbMP92B6jDzD5M6M8aV6gYxACX//+p3p+JZfNxm5
         rC15stjhf94B0/Fu7E5ZNiliqv1VikXaKC+eiu0pzPIIM+ttAodP9xsviua0JLvfIHQn
         jWux+wWpJ71/Dsrvd/ksVxdFR7uNsjedBI2CzU6vZqfZLd1bic8QxQkyIEwQEX+bIKAe
         Admg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785857989; x=1786462789; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CroU6+PYSvOtV4uy1av7nC/Q1rK5iyolsTF+JTm0nJU=;
        b=mQudjkWq0vS1dUXqklNdYhLYrPLzHCfZSAXsIzYSSgrytQhhDPjDim7NP845kdJ9UZ
         ztmeM789vxYdF+y2cXnZhWn3RAONptERvs/jBAJ57ct8U7AhimyYBRlWmDKo2F8BxEnR
         AI10H8yn/LY/QKKKt41usop8a5odnmU076zNP2tAQuidqzcbJMSqMsOwyxNkjHigdVaB
         o9O5g9KyDsesGZ//bvP65R89kStOUOGMLv20S1xKbXECEtSrTqxhvn+h1BqlaxH5Gvja
         86Ynj59xRN5PFyA2VUict0k01AXlHN8hBobBmfa0SSKvvapJgfq3Tq+RO2EwIk9j6uE+
         073A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785857989; x=1786462789;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CroU6+PYSvOtV4uy1av7nC/Q1rK5iyolsTF+JTm0nJU=;
        b=Fo8uHr/LgqvQAENqMzsRN+F0gtsuOtnv2Q+eZTXNFlISeZu3LlWSHOUBIVtzrrru2U
         YSaBt8UbiHYmQqgU6QgZN77Ks7aJDCleXniUCe0a19gAErEzOMNCnELxzTMGsNB9+AgV
         UeQOxM/R+9jzWJzVPGbtRc2URhRxEXzLidah5XLZpFr0pH4zprXP37mj6K0e7OROlCn7
         NhaBxyq/ryPmuiZBFdDVvLl/D9GtKP7eCg3Bbum53fb0ZFXVxRLStWgm7uHIE2x7Om0k
         +25r60FV/05voaIaq83jBFkhOuksof8LtvNlTh+mzQgTI6M1KtSiza0aafHEIOrPnS0l
         Nkug==
X-Forwarded-Encrypted: i=1; AHgh+Rqyfv0MCKp1tC7SoHmmRBvqlR5MdDupopIEWOj/Lba19C/iR2JunYv2ihqWnEGlpk6Xbq28bbKGyQ==@kvack.org
X-Gm-Message-State: AOJu0YwSKlRuDN+HAkpaE/oCat0HAAOldCYHIJjY2Iqrq43MpnVs2EMg
	4Eey4iZ/w4Crd7EY8vt/Maj/jswjqS9WpnecFHD8dqf9GPyiEh2TxcZX1S+do/NJRXT7n+Nrd6v
	3ZSESJRUMyhwczrYBZFom28q92tdkQ5Vz8X+nDc2/
X-Gm-Gg: AR+sD12CERV/emQIRfwfFsn8fsYNpFuqcEyCk2a+NzlEAhsZHSPkbm7V4HBSuxAW/XK
	wVBe/NT1lLvoofOXeJL5Ov8XLCqruOBKExYsXe7GsjCLbFqrEpqVxGViB7PXY1OkwlzxYM0QWUM
	EMAypemzC9jOMbvs3DXO3I/BTjtJKTpPujvi2kJwYQWIhnJNwjhAUCSFPW46cfZewPovlvRLkv2
	L9BjqAz5yfu3n0m1wjNrlUxfy2hQj4ZMBVeC5G070/s3Lo+CFlNQ80w2H351VRnb6zwXVoHpb2k
	Hi3spCAl2kbze8YJ0G53Dd12wKzk81B7qMwr+rZtrpIm3Cq0+jAee6GrnCJOdrPHraNXkvCUJDz
	n4g/2jOPF3pA=
X-Received: by 2002:a17:90b:1c8e:b0:38f:1a80:d1e7 with SMTP id
 98e67ed59e1d1-3903c596de7mr90484a91.13.1785857988201; Tue, 04 Aug 2026
 08:39:48 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 4 Aug 2026 08:39:47 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 4 Aug 2026 08:39:47 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <7f23d149-b7f0-465a-a9c0-5c7484e289d2@intel.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-20-35f9aec2aed2@google.com> <7f23d149-b7f0-465a-a9c0-5c7484e289d2@intel.com>
MIME-Version: 1.0
Date: Tue, 4 Aug 2026 08:39:47 -0700
X-Gm-Features: AUfX_my5tJzuKxcHX_DSDai20MF8F8MLGyTCXlBPRZTIfOOy8MGvwUJsA-dI9HA
Message-ID: <CAEvNRgErZqaLPpBveBd2VxdrS_8mjMbArL_=AhzMdikXmUU5VA@mail.gmail.com>
Subject: Re: [PATCH v9 20/41] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
To: Xiaoyao Li <xiaoyao.li@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92A7516000B
X-Stat-Signature: rt68w3ez8wuhgpco8nnrogoo4nb4h5nw
X-HE-Tag: 1785857990-57360
X-HE-Meta: U2FsdGVkX1/LgcZNYZf3AK2C8jtKNpvg0v25Q3xZKHmSn0GVX+7+ronIP/rVM8xu90Iie6WgKCw3eOOVzND8bGMzpcat0ArA2uJrqOHYFgW3tbEBymJC6dMOl99f2SH2U6GESCG4Z2J9AQQxpiOnnaKub7qbF/c9KVvKn51R4dZOQRj/sOsxzQS68u5I6GDb2QQXj+MDAnA7idVQLFJyVOSOKGFcUqf5ghtFa/MfZixswQv63QwLk1xLQd/dZne9Zwc8XrG6Y+eFzPgpZxGRPN+6ZGeT1C6zpaQoBX2oQy7Qs54aWu/2aPdnqT1SlBst/DVHVlHubVYXTC3lQA0WOXWXo4fbVoK+15CFoBBopHmQ9E9BgdU3pqzzWvNQrUMmcQauPOzaH12dMGCmak0vxUKeuJtgvRuCbXBUaTyGOPoeTCVaMorXUu3jtNNAv48WQ87sv55u+9+0VQUn2sNmB/0lQ1DwrVfFEj09sF1Xnv/4I48wV1UnFG5X6x13Y19TQLXIIiFrimwF6f09D3xNqBvx1kltSfGbfUFhGmDctqHNL5oYfwdG0EVl47tHHFBp9IEZZpZiYlPAgzYGTru4VsrKTcevHZATr+omYd43mXb4zGesxHdJfBPTAtBanuDpuDu9WsX+2KPdiZM/RiOb1FBeO/BD3vqYPLpjWfobm2yrD1EFxbXIyREU+0Pa0JOgMEgZG0uWrEYB4iZ3yW0uqWvyMtS7qYEBv6hVWYu7vsucgeSX9nShc4uZ/dwIMfuycE6OUjHRJAxX8nm0+9YGymRQYCBWlOkyVaqwuYd9S45Tu0Ko3FW3aL4lSBt3UZXaqAYP1D1COurOs++dQRikkwgIL33iU3uO/1fA7wRoFN7oQlkT7ZBTdOFWcYsESKCtqXTMtpUjMGQbQOT/NDNeru1tcW2kjWoiP4jgvqon3pf3taMv8xXID1tp7xzb0dh1SeKL5wX3mr6iZaQEe7q
 eIbagid2
 fh2s80MxjLK5FJf0ioQkYC5h1o0v6ct+QI8x9X4K/kpO/JI1E5DCHRn1U1EfIC1YdMQcJB8Wg3T5QjTJQpSBoiKGeXy9X//02ecYma0rZiAs0yhyesdvooxq0Pc6dQ+ChlvICvLnCDt2GmxXceO6yUbKLfI03ZJMoya9ocM3UK1jfVf3aiDDwWeo2UGQKHrW+vBjcBVGVqeA9bq3etWtEAXSdfBmUzONSExaocGSYX1EKLtD5oav8l7D5MqANpmCrqnfwKt7tHs4v67xM/+0+/0Muby/AITwROx52ua2MREF60XsCIqm3JBHOAec9vl/Kgah9eOSbdOLKs6JLeYiZyWIxI5RcYQpCmVz3u3rd+SdjLLDPeZO97X9X2UnIuQLVrHtP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xiaoyao Li <xiaoyao.li@intel.com> writes:

>
> [...snip...]
>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index ea2752989f8bd..df67a6188aa99 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -1137,10 +1137,12 @@ static bool kvm_range_is_private(struct file *file, pgoff_t index,
>>   {
>>   	struct inode *inode = file_inode(file);
>>
>> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>>   	if (!gmem_in_place_conversion)
>>   		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>>   							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
>>   							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
>> +#endif
>>
>>   	return kvm_gmem_range_has_attributes(inode, index, nr_pages,
>>   					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
>
> With my suggestion[1] on patch 7, this diff block can be dropped.
>
> [1]
> https://lore.kernel.org/all/dd4201f2-3660-46ad-958f-c70feb1ab1c3@intel.com/
>
> The code looks good to me,
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>

I think your earlier suggestion on only defining the module_param when
CONFIG_KVM_VM_MEMORY_ATTRIBUTES is selected still applies, since it
removes an avenue for a user to turn off gmem_in_place_conversion if
the other option (VM memory attributes) isn't available.

  +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
  +module_param(gmem_in_place_conversion, bool, 0444);
  +#endif

Given that we're now dropping the diff block as you suggested, do you
agree that we should keep this #ifdef?

>>
>> [...snip...]
>>

