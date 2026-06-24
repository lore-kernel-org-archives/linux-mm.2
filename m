Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7582CDE003
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AEFA6B0088; Wed, 24 Jun 2026 09:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738ED6B008A; Wed, 24 Jun 2026 09:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB496B008C; Wed, 24 Jun 2026 09:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB226B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:44:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7614E1C2669
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:44:41 +0000 (UTC)
X-FDA: 84914926362.01.9EA49A3
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5F836140005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:44:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lbDc9a/H";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782308679;
	b=BSG0yZZdrn5uPcKVyruWUHmiBBUK3nQjSVblkIumAG+Nc7Ff8s+9XTf1IjPtaTfHjZN1Q6
	mP31XeIuXqCQDxczzc22YLxLjLtGWlvzmaPuN6487r9/cqKVmigBa3T6K8wu4J/6i4WCzj
	qs61oc/ttHDN8dC9rkhfPqSVa21ilxE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782308679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMYX25sMe8BokvDqBMKpyH1gjAy6dHukDWPb7UeMT1Q=;
	b=LZcl7c2hAFDzdqZ1kQxGEJILm7w4W0xPi/9/bptdZHnVepM2RRdZyXyyNi6CoPOvydrzHx
	NcGU3GW0x2pglz+9ZD/rPzWiBH4IRhnUxYsGajt0TOCRyoVnO7SZXBUz7f5csw7fCYfy9w
	TQtZFtSf4SGgMsFzVCn/ErB40j2Dj/c=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lbDc9a/H";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=ackerleytng@google.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-13981833e13so1254413c88.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:44:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782308678; cv=none;
        d=google.com; s=arc-20240605;
        b=diXzLFg/tSRDwX+65wuolMZ1wlcEg5O91LxO45JE4ep7U0QZZpxchHiBrZfiWPUX0s
         9vNEuJhRqHYZz0PNuEINuwcVp8ufccj1vKqC3wKu1ZZgj6NudBkNfULZOnWThcZKEQyn
         vwMsxvg4s4/SlSrmibGIm9q0VlNjCo5jv41aAMSYL77QHApvHptQ2KVJrdgrjgllKoYB
         6O+MvF7J6Pkvun+qfTJwWm0mfSme0Er7syFnE3VD4i4JtAONok29DMFUKztacgWTbrzq
         sLoQR57VPyZqkcM7ASDVsC0iejRDA8wwJylBS/fuifB66WiPOZrEj/64DzB/C7ibESuE
         ENSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=OMYX25sMe8BokvDqBMKpyH1gjAy6dHukDWPb7UeMT1Q=;
        fh=Zj2LQ4NlOSXZAfaP651iCeTd6PrgXTOQZaq9eY66xaA=;
        b=h8ARRRuNR3odk/A1M0n3WGvBvBYyecGluTrM9Kmr16wzdYV+RiLAW9ApxIj6hy5Gv0
         UQmURoCE8Ss889iGK7LcoQvHk3p3/joBRuOzOGm+C3l+4IuyBXjw1RF/LahcREroPCI/
         hA//CQGmBJFQvkSKo3VXuFdn/j+lhnG9Qed8RhlNzhGCszwIxit4jRxGK6NEl0z3Odt4
         3Vf5T0+lYiPmvl1fLyGWigZdR4iC4DyJXhpZ1tquQHdefpP7xf4xlEW+LBQJvuCwO0Rk
         PIu/iclFiLXrQC6sf2Ldei0t0v+dkQSjbclxyce/y9rE9m9FcN4N4W1seKv8kS0Sfsf8
         u8cg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782308678; x=1782913478; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=OMYX25sMe8BokvDqBMKpyH1gjAy6dHukDWPb7UeMT1Q=;
        b=lbDc9a/H01csksa1/wp89q2/hDNsLXtllmW3dBRm4nJRTflLNi2pQYcJlpYKJif2tG
         cvMPX5R1h3A4L1ZeEYioRMVy1WkHkBsAKjScZNYDF+1doin25XKekcV2QCAH+jlSZNkw
         ri0HFctB0SZObiHgg96BO7BSzTj8Xqcb90JZLqqwJcLYtlUe7siOVAoDBYKOBK5+CJLe
         nda2+PnDiHBSWuwEfizld9d1x+Vghi7mIfafL/yG9kddURnXLkDoWkWSI3uy5e6D+rD1
         QV7i0UtQ5RER6OAAYxSA8uJnusCkIGglX26dMRARCmPg3byO3JGFzsNCPp3M6NTqsJ8X
         Zg3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308678; x=1782913478;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OMYX25sMe8BokvDqBMKpyH1gjAy6dHukDWPb7UeMT1Q=;
        b=QO7Trd4G42Xhupnp8dEu3b25pYJuVw5n6AM7pPi3XsH5e6TgepEBVVpOMa8RkzBqOP
         g4YhRO5lTmVP+WKlKLRG6eC9fUFO1xI16nYMNtGHMS2m86ndVuyYnA/RFkmHqILf997r
         hD03dZ65YJHT/65OAjR+gCR1vj1V842l650XkDieiUX/fsjViB3TuJszbrwTwrodNAae
         skHSSBRU/WY5VfUqU6qz9dbRDgZvMS6i6VfbVtpaxYHMk0kXChPGDdacnow7nTdP2A6A
         0Y8amkEH4475xqS8SskBbDuXWrz30hsfx2TpCAVta1JPhH5nrl/9mUQANibdYNgHd/Tk
         XcRw==
X-Forwarded-Encrypted: i=1; AFNElJ/nvvvD05PtZW4m7Hb9p6ylUzgCmQBPEb1CLgflJW3WTVB0RxaUdknIs2wfODJFopdbk4wF2FcXzg==@kvack.org
X-Gm-Message-State: AOJu0YyvYUHn7zvofy1rTs0SyIN4moGNT5tx8gqyvBhv2dgia1d1Sha9
	k0b6cD69vIirsh2LgZh4MzwrJ7ZCDu1vwR+BXcliWHlmciTyEqfcwCx9mSkLM6fI66EIsnNIG86
	1Cf5HxvafL9++cC9a8Xh03cjJ0s+nCFih1WTedROH
X-Gm-Gg: AfdE7cn83+KIbGURTyVB4gIOQcm8JVwKRHnMR09SnYNPwzEMlkmTz1tmCbx8B/D2eGx
	p/xNS7kh5IUoNbQxVmHYl223jNOIHiYqjb85pCtcblGrZTOa6wPZA1P7SH6b3DpmJCJABO8KOpC
	mSja9zoeR6nZgI7i1bg7W9BdSuOT+zzZSPl4TWqpUVFr+XeGOlwhsQS6guk2oNPzF1TQRADxGfW
	qLQ049sg6zOwGB9OPJHSuMCTUJ+Aya3Au+WoVcloNyCTOR2ZhihwFa/RWFJ+CkoPiPZvDPxPBZo
	+KKcWITh/CazrFazatcCx+/JFEUb
X-Received: by 2002:a05:7022:ec0e:b0:137:eb26:10d with SMTP id
 a92af1059eb24-139c5b99857mr4976083c88.0.1782308676421; Wed, 24 Jun 2026
 06:44:36 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 06:44:35 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 06:44:35 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <96fb369d-dbff-4ed6-b1f9-0ce63d7d4ed0@linux.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com> <96fb369d-dbff-4ed6-b1f9-0ce63d7d4ed0@linux.intel.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 06:44:35 -0700
X-Gm-Features: AVVi8Ce7qJauzHB_wQ4GZOmMbMs8hfgU2sTfkjTDTjUh6bKjOQAsxLqy1nK_op4
Message-ID: <CAEvNRgGbBcrX5Fw3vNTsTOBNC=Ypi=9-S07674yPxLU9i4akjA@mail.gmail.com>
Subject: Re: [PATCH v8 07/46] KVM: Rename memory attribute APIs to prepare for
 in-place gmem conversion
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F836140005
X-Stat-Signature: o4cqtyekionoo1ghoddah1wdw5j8pcdb
X-HE-Tag: 1782308679-937227
X-HE-Meta: U2FsdGVkX1+R4sopkg1rkZ/3i3toOTcP4Ry+lcmTgWrvGm5uhsULcsKDc35ZBTYnI4nGMR0GrWLSSdPWo3RM4wjGHadcPZpXS6oR5WcbLJ3Pu5OKS7EzDsF84ZLnnKc9DhpxMM5agtwWbL+NwtAnhYgcSUH5TWV+95pM2vQTo5JCI7+nhOnF4spkYBmNBFdRAGMaEvi2u/Wnxx/IAxHsi5zNlDCmO6tzQlJ3cQH/ig8Pbm6kxveUhiogFpH3izBAHaSP6Xs//0Zw7Z3/R9lhR07wNtp1+h33Fmlo9yG88MsvM/MhCwmurR+qtHBR/ky1k3hMAOYpxHPvesInKVK29G7Bb7bXU+0A+/Hwh5YYzKrFfgVRJAGIx/Bzxph0px1G0WjH7lwRopbrn7vxpnpnpTh0p+noOBqAVlumKiHJ3YhF5b0acjDklK0KSETIfwUvOAxjwmq32o2MB2w9uAyz2te05moSRhJ7+s65+wn4mFzuxIDPLF3fatFL9i+8L5WDIkGwG395Vm0A7cqWvLIvUOOpEH92LKvOZcqj/mWJrhDBd+MjIE0aP6Xt2UyYo8zaAOOfWJc8RgNelSDmrAh1R/UcbgArqc648taw3jt1tmhT+FQo8Qg+QUvF7n8ZGUhk1QMeN/RAoOfK0vHP02TQO+2TkoAcQVuWcLH69+vKUJh0N4cepYsd/6rrL47bg18i7axFk/sOWvcMgbpPfZlTnbFP5qnbC7v7tWrhw71LZ5W9GTEGanZcnBaxM2qaxi0pvwuA/Kz7k7ep1ZePPIBHwpPOZk15Y3o0u+XNsK4mkWnbpZiWHJOj0CJbYv4xR3DcaZMgjcofwuM2bonPvdjDoc2EZRr4d24RZbS23toqNWcQLdso75rs2tDg9KTF/cs59S8/V2uLAAaILz6Su7TRHdF9kWORy1dTpjWlcYKy1UG1v5RujH3zv564U+NU42Reo0eLyHFnYxO+F9ozKhr
 WxvPkUg7
 aoWtI4Fn+NMsFWsS6lcOeJkjSALAkwO9OyIlh2JeM0lpjN5JzOLWIWZwUhgsk1/63u66lglDZIzRPkjokxgsOhxBlbr3dfZ5Xd01Gi7gw97fkkbEYqrKQubLAdgVoYnx3su5Vju1H8glSMfqYMVCo+UAkwUawVcDgWWqwrNgsxjRimCBUzlma0WVVcyVM0Pxra94qDezELeDowdedrZKvH53BvLtFMQfWF7uzdyyoJzLZY6keEqiXIFr967Pg/wxNeOFUwSG3NKCXaL5+ZWsxgwg6dhblyz1dQIrNN662K6UpZNKqaXFwfNt/DqSdcnH0V2ZyXQoonfSqS5LDoSOiuu8CZFsjABpKQtdrdCRAOHoeKlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Binbin Wu <binbin.wu@linux.intel.com> writes:

>
> [...snip...]
>
>> +static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
>> +					    gfn_t end)
>> +{
>> +	return kvm_range_has_vm_memory_attributes(kvm, start, end,
>> +						  KVM_MEMORY_ATTRIBUTE_PRIVATE,
>> +						  KVM_MEMORY_ATTRIBUTE_PRIVATE);
>>  }
>
> This function is added, but never used in this patch series.
> Is it intended to be called only when CONFIG_KVM_VM_MEMORY_ATTRIBUTES is
> enabled?
>

Thank you for catching this! I think in some earlier revision this was
meant to be used from the guest_memfd populate flow.

I think the version of kvm_gmem_range_is_private in this revision is
good because it is symmetric. If conversion is enabled, call the gmem
range-has-attributes function, and if conversion is disabled, use the VM
range-has-attributes function.

Sean, if no new revision is needed would you be able to drop
kvm_mem_range_is_private() while you're pulling it in?

>>
>> [...snip...]
>>

