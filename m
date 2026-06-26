Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F0F5CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0DF6B00A1; Thu, 25 Jun 2026 20:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559246B00A3; Thu, 25 Jun 2026 20:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423216B00A6; Thu, 25 Jun 2026 20:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CCE36B00A1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:07:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DC0440332
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:07:29 +0000 (UTC)
X-FDA: 84920124618.16.D6837F0
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id 799C94000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:07:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cZzbppWf;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782432447;
	b=CBGOrNA3QliQMLTBw19+S1dnzYVFW3pUPIRqH+GBXMxt9kroh7k83/pWxxdgStf9C6mVjM
	+AdsOX5+45UOShamBDy9rwt8GJTNMySjuOWfR+dorp9LsB/fv9CT8dUeJb3kAG6HiVhy6n
	D3ivc0QgmtTlVZNbajpzuSJTxM1/eTs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782432447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNd8RQ2oAjOine6lO9TBbPn3RS+xKH28gpFKike5xvo=;
	b=m5kbSO6VYCSAlW8rfBaTtk3wwbTIIrSqGHE8xo9S1VZfUR4NnMnNafC5SWQVkY/Ce1TW6L
	vO9YxWr5Adxedn6Esq+8RbenptUn57+m1hMMZfxxw95lfINvBfaOkeGr4A+BdwOUdi6LCY
	KJX+ys89IeIdfrapUPJ7p3XPI6v7rKw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cZzbppWf;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1384ebe7a10so1017923c88.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:07:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782432446; cv=none;
        d=google.com; s=arc-20260327;
        b=WWouaN4R7CWmlwRigri8Q4ZVHw32MtYR2lL8I0PJQJLvCmtF0j7sKcQ30egpQ9nRGM
         dtAuk/CN1O8A4hKVcUM2S6uZo0sMZZUGw+Tq7g5nP2bwk5w7/snhdMvkU5/XfbKDXMeO
         8+lZ0T/4UEF/CNpmKm5/CnXNIH9T0+3xvoMOdYFLOmY4UlkKXn84XkVOPWHUs9U92pN1
         IFSzgqP5lQQJ4j8Tq8mhS4CM4gUY08r/VMXMzfQv+0jVntwzEN5+OB+7mqloRJ7Bb7jv
         LAub/NL0soTrbR2q9QtaDMLDgnr8sH4U6xghHVbxUNSIihBZAVWvystxQFH+y0SK2TuB
         hOaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=NNd8RQ2oAjOine6lO9TBbPn3RS+xKH28gpFKike5xvo=;
        fh=OU6d5nh+fZsPWZ8uFKGrm6vXNErwimEc0+OKFkKnaOU=;
        b=LIT4Q6Zm0HjgXf+e281ogHUHred1Fbgw9M1Zxy22Rbj18mCTwdWOYKpIwTciyNK7QM
         Hgkah9yzlo9q/6fbA9zyXBEw3foivH3s47oSX8wf/4v1ulZUbShAVIo25AN8U72YF5/P
         BQ5WYrxGJtx9qcoaNTJdpkODVxbloVLwb+7AdVKx/fGOzGcwjrxHxYX2hjBeKamMkV0h
         lm26u7xj1ka4dEhcO0Nz6GmGbqM6McvPVLeT7y86wuXx9MOTI3qHQwkSbACTB6/NaIvN
         EXdyd39Ui4iKC6dDAhom/+38Jyhr0R1Z+T6Fmx5fWoJJNC4peWDMqCFbgLYqbW6QcM1z
         Zaag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782432446; x=1783037246; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=NNd8RQ2oAjOine6lO9TBbPn3RS+xKH28gpFKike5xvo=;
        b=cZzbppWfPtCh5uF+7XlCQiQT4g88Ixf88EN4lAMxq57bLt7qDRJc0LJGaeHnBl+58+
         W/Xm+wek5tkwYVFtDSMCdhpnI0zW5Ue78X83lu0sARUwZeKRBN01Z36MDMXxMHz9Uf8G
         W4/u3DSnQd1kOKgbPSE2vyOiX8MhPPwWPLFbFlQK7Fpc4Z/3+u9QkTPLluRrwTfybizO
         2G9kMyezcSoHx3nNBf+Rw42g7jsJi0ELjI6Tk+gfxLJkSeSwVo4OUe0fY+UPXC0KMr3V
         fBhkIx2Whjm4LPY3zkhT2vZAlRacYGfh7vTSCm2Ww3ID2E65G5Ah5WumnAkelP8y3xMN
         x2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782432446; x=1783037246;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NNd8RQ2oAjOine6lO9TBbPn3RS+xKH28gpFKike5xvo=;
        b=PvNfSsE+pzgL8WX68tUZeq8xjEfA8f0wQukoOb5OYhRR7rT+by4Y29g6ce5JI4YWJJ
         Iyd092BmW30xg2P+VpSHKjqKTp4z8zgtv2xuSdt9AXTpxrGF1JgVA3DsKvRD57GkNQ4L
         R9sBucEC1FytMzXLOmH/32xvTKBCIFDIDQaN1SUQYTLOUcMxoCGMzdIm3ga3AdYiegYB
         dEt/jQWy8zTHYzUSeYrSBGXrgPQNalCamr3HmhWSnWY0ZXG3gjbnXlRFlTKZuCJaMt36
         /TogEzvtWj05F7Ew0XwzvCfRSpL5j8Pfk4RAKT4kwrrFggH0vJKjQaOqBxkvAP2XHbgE
         1Cbg==
X-Forwarded-Encrypted: i=1; AFNElJ9chBJQLWefZSsd4HEqsK+mr8GySK//N2pDZXMaHXzvqqEmdHbiiTSmhsQFvd6CGfy/WgwwbcydXQ==@kvack.org
X-Gm-Message-State: AOJu0YyJi1ZaXQgxCJlbi2CNkX4SWjqCZ1XHFxaCFo82GA7YdGK3Fl57
	sj0ty2XV4eu+ZfdsR9DkCPDmpjuhKJ+mecSI8/HWuuA9MEFJpOxmTxjicSkLk7BT3oSDjkjXWBN
	40d1aJkL3utW2qhPOKxOcKNrQdJPMcq7FKhCP0CCC
X-Gm-Gg: AfdE7clV7Vk8lj2/07WyHYmuDGu/vOn3H86re9rKVKL9fbfmxj5Ff30COo3wzcvUf1E
	G25aVQRrAmrBIeaklOJtgHklpuv0gQCIevp1Vdn5oSXpgt5WURCXV25/6qWFt+klQ/D7Pa3utNc
	hq9pS7eisR7s8hW07xCxvX7++EjFJksWv+EtUsm579Yfk/hSBbmtcV/Srd2fNlZfSpLGpUE320+
	ow6tkTqOEPE+nRbOJkmm5cvi52D3XzPJnYO9H9CN6gQX95ePyFI7nzCsS7dDnyQuAlAI7lWEF6N
	0L1nUSDF50XYreFN4VbjEeg1rCOTCaPs/ux2fd3qKGKZGNCU9Ix/RpoRJQA=
X-Received: by 2002:a05:7022:43a4:b0:137:f49d:3388 with SMTP id
 a92af1059eb24-139dbb5b144mr4108872c88.21.1782432444996; Thu, 25 Jun 2026
 17:07:24 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 17:07:23 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 17:07:23 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ajyRg3BwGu5dCfOn@yzhao56-desk.sh.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
 <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com> <ajnf5Z9nWZxoLS4x@google.com>
 <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com> <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com>
 <ajxasFBzp_9KnQLq@google.com> <CAEvNRgG1nHipzw4=eBgwhvyXi8xYo7FQD_sy9Ax6FDf7YDu3Og@mail.gmail.com>
 <ajyRg3BwGu5dCfOn@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Date: Thu, 25 Jun 2026 17:07:23 -0700
X-Gm-Features: AVVi8CeCYnzA1y3pJSgcOnrMDG9x7K-8H5mOt6-X5dtowJ5-kK2ahwrJyY06kZw
Message-ID: <CAEvNRgH5KOHoemnC9QOn_oK97=KeAH1XuX3ps36-pJ0Fn0aBHQ@mail.gmail.com>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: y7oa4hxxg9owzkkzmf6oc1c7wbzbew7w
X-Rspamd-Queue-Id: 799C94000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782432447-263992
X-HE-Meta: U2FsdGVkX1/JoKuQmbdd8O/xW1Ght+0zV1Uqy73t88+MSCdmG9uP+GK+vk8vxkLJDIrO9d7NS+W8hQfdti+YJFvkpPWNs9iml/9yM/+EKD6JMAyawctgYG/aN+G/qBz4FfhoHJAuE8jmVLl/QlKv9pyDYvkwCwtovEc/lXP4A3uRZXiFld7E+HU4zriZVDEgcKQt0AR2VDW5zHUOYKR+U70QeLxRdpnwISuaDKriRSABC9Bn7U7ivRYqb3j2Un0JieA/bh7rydUEjgutkMBgIguO0Vi9wDQ+81xTj8GmMS7E9iVX4Am5z6UtYJL7sLPIqtcPusVRE64apbBMA4Ix65FIqBE6TcJOqr7271WBOtLZwgfV5hshDubwSDwCTSFiqp7dxx+KIN+XmJHunV2rk/oWWbwG0MN82KIQWHO0dSYK54iPzFombMAPiT5B+0zgeupEDE/T8LWEgIcfPY14UPPD5cG9844qETdE3107pr4b7A1sVC6+nvFfRa7n27C1UlvyDG7ZZrui3SjS2+7JXKqfZQSwlPZrb63DrawMkKfUqbmK66YdM0oH5llKrLSCjxCO0/AEUQkgZdphg7MKGi71KPuLiuOHFbfIfWx24eC+tX5x1BWpTzM8B128jWzI1u78u7R4+t0fqOvAaBYmVg+lPB1QO3TW04oD+GjcIDuDPSbByUx/vHXcFC7i+ZsRODp/dLhU/3zN1bz4gBkvPn4h86p7sRqkTQGDqU1kYCYPQgdU+xM1NCLhQInjWGWlGfrJt1dqL0v0yBu2SN6Ac7PCBcFQrsyfk7lmFXGz9eXmTNqK584LoKhMqN+/BHzW0eyN2mqUWHOM0Y3ejSGqcki5Rn/mHnErt1GqYSYwf3qQ8lqxVi59hTaW0yyc4YH3C7ct6Bo80g/aGP0B+3icKj0WKWGvt2jXQVUaknUtD/LMEPZpK+EhXyLyaGC4GxYygOr3UGxiQHJvKDIlwQ4
 Cy0ef59g
 PzErUZTAx+snbWIh1FC/1o3lNYBl4dFOb62RN218jhXEFOzmsZgaEFjbZKhU5r3VRI6wdnbUUNTEFbup0SDkUJTKZuUKWx8jNcYCG97CvAlk/63uqPdfoNwH4Fowqg+MelkZ8/8bnq81sfIuLcpfjmk4SLJrVJnmOyNUnLLjYgx2ff+t7XjvljkqpFeHLWgzNx11N9eo9o+euYQU2y4uBPML08QpCqy8ou5zUyQW+ObJl8tpfirFvw3FhE2CX8kjQ9Or04/wq57sQda0MMMlrStB/aDQ2aV3l9ZPTzs6z3wKLz9lNLpyuJr0aht/RF05EAPp+Zq6OkMTFwM06wp1dFegUEDPez8qbQXiOEvxBLWFZgsRPFVjBX4eRIYuRNQfRDx1jHCPYrIGijFBDyJSnRr/BO8Y5KHyNPLc+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Wed, Jun 24, 2026 at 04:00:32PM -0700, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>
>> > On Tue, Jun 23, 2026, Yan Zhao wrote:
>> >> On Tue, Jun 23, 2026 at 01:16:14PM +0800, Yan Zhao wrote:
>> >> > On Mon, Jun 22, 2026 at 06:22:45PM -0700, Sean Christopherson wrote:
>> >> > > On Mon, Jun 22, 2026, Yan Zhao wrote:
>> >> > > > On Thu, Jun 18, 2026 at 05:32:00PM -0700, Ackerley Tng via B4 Relay wrote:
>> >> > > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> >> > > > > index ffe9d0db58c59..56d10333c61a7 100644
>> >> > > > > --- a/arch/x86/kvm/vmx/tdx.c
>> >> > > > > +++ b/arch/x86/kvm/vmx/tdx.c
>> >> > > > > @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>> >> > > > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>> >> > > > >  		return -EIO;
>> >> > > > >
>> >> > > > > -	if (!src_page)
>> >> > > > > -		return -EOPNOTSUPP;
>> >> > > > > +	if (!src_page) {
>> >> > > > > +		if (!gmem_in_place_conversion)
>> >> > > > When userspace turns on gmem_in_place_conversion while creating guest_memfd
>> >> > > > without the MMAP flag, the absence of src_page should still be treated as an
>> >> > > > error.
>> >> > >
>> >> > > Why MMAP?
>> >> > Hmm, I was showing a scenario that in-place conversion couldn't occur.
>> >> > I didn't mean that with the MMAP flag, mmap() and user write must occur.
>> >> >
>> >> > > Shouldn't this be a general "if (!src_page && !up-to-date)"?  Just
>> >> > > because userspace _can_ mmap() the memory doesn't mean userspace _has_ mmap()'d
>> >> > > and written memory.  And when write() lands, MMAP wouldn't be necessary to
>> >> > > initialize the memory.
>> >> > Do you mean using up-to-date flag as below?
>> >
>> > Yes?  I didn't actually look at the implementation details.
>> >
>> >> > if (!src_page) {
>> >> > 	src_page = pfn_to_page(pfn);
>> >> > 	if (!folio_test_uptodate(page_folio(src_page)))
>> >> > 		return -EOPNOTSUPP;
>> >> > }
>>
>> Yan is right that with the earlier patch "Zero page while getting pfn",
>> folio_test_uptodate() here will always return true.
>>
>> Actually, this is an alternative fix for the issue Sashiko pointed out
>> on v7 where userspace can do a populate() (either TDX or SNP) without
>> first allocating the page, with src_address == NULL, and leak
>> uninitialized memory into the guest.
>>
>> Advantage of using the uptodate check in populate: if the host never
>> allocates the page, populate doesn't incur zeroing before writing the
>> page anyway in populate().
>>
>> Disadvantage: Both TDX and SNP will have to implement this uptodate
>> check. guest_memfd can't check centrally because for SNP, for a
>> PAGE_TYPE_ZERO, !src_page should be allowed with a !uptodate page since
>> firmware will zero and there's no leakage of uninitialized host memory?
> Another disadvantage: the uptodate flag is per-folio. What if the folio
> is only partially initialized by the userspace especially after huge page is
> supported?
>

Good point on huge pages!

The uptodate flag on the folio in guest_memfd means "this folio has been
written to". As of now (before patch at [1]), this happens when

+ folio is zeroed on first use by userspace
+ folio is zeroed on first use of the guest
+ folio is populated

When huge pages are supported, the folio can't partially be initialized?

On allocation, if any part is shared, we split the page. The parts are
separate folios that have their own uptodate flags.

On splitting, if the huge page is uptodate, the split pages will also be
uptodate. If the huge page is not uptodate, the split pages won't be
uptodate, but that's ok since they will be marked uptodate on first use.

On merging, the non-uptodate parts have to be zeroed and then marked
uptodate. Any parts that are in use would have been marked uptodate
already, so there's no overwriting data that is in use. I'll need to
think more about when it's safe to zero.

I'm still on the fence between the two options

1. Using uptodate check in populate to reject src_pages that have never
   been written to or
2. Always zero before populate

but whether the uptodate flag is per-folio or not doesn't affect these
two options in terms of fixing the leak of uninitialized host memory,
right?

>
>> >> Another concern with this fix is that:
>> >> commit "KVM: guest_memfd: Zero page while getting pfn" [1] always marks the
>> >> folio uptodate before reaching post_populate().
>> >>
>> >> [1] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-21-9d2959357853@google.com/
>> >>
>> >> > One concern is that TDX now does not much care about the up-to-date flag since
>> >> > TDX doesn't rely on the flag to clear pages on conversions.
>> >> > I'm not sure if the flag can be reliably checked in this case. e.g.,
>> >> > now the whole folio is marked up-to-date even if only part of it is faulted by
>> >> > user access.
>> >> > Ensuring that the up-to-date flag works correctly with huge page support seems
>> >> > to have more effort than introducing a dedicated flag for TDX.
>> >> >
>> >> > > > Additionally, to properly enable in-place copying for the TDX initial memory
>> >> > > > region, userspace must not only specify source_addr to NULL, but also follow
>> >> > > > a specific sequence (where steps 1/2/3/7 are required only for in-place copy):
>> >> > > > 1. create guest_memfd with MMAP flag
>> >> > > > 2. mmap the guest_memfd.
>> >> > > > 3. convert the initial memory range to shared.
>> >> > > > 4. copy initial content to the source page.
>> >> > > > 5. convert the initial memory range to private
>> >> > > > 6. invoke ioctl KVM_TDX_INIT_MEM_REGION.
>> >> > > > 7. do not unmap the source backend.
>> >> > > >
>> >> > > > So, would it be reasonable to introduce a dedicated flag that allows userspace
>> >> > > > to explicitly opt into the in-place copy functionality? e.g.,
>> >> > >
>> >> > > Why?  It's userspace's responsibility to get the above right.  If userspace fails
>> >> > > to provide a src_page when it doesn't want in-place copy, that's a userspace bug.
>>
>> Yan, is your concern that userspace forgot to update the code and
>> forgets to provide a src_page, and if we keep the "Zero page while
> Yes. Previously, it would be rejected after GUP fails.
>

I see, didn't realize previously it would be rejected because GUP
fails. GUP failed because it wasn't faulted into the host?

That's kind of orthogonal, I don't think GUP fail leading to rejecting
populate was meant to help userspace catch these issues. GUP would also
fail if the user did mmap(), write to it, unmap using
madvise(MADV_DONTNEED), then forget and pass 0 as src_address.

>> getting pfn" patch, ends up with the guest silently having a zero page?
>> I think that would be found quite early in userspace VMM testing...
> I actually encountered this during testing this patch.
> I update most code path to follow this sequence. However, still some corner ones
> for TDVF HOB, which are less obvious and harder to update.
> The TD just booted up and hang silently.
>

I think this is just the life of a close-to-hardware software engineer
:P no errors, got stuck somewhere, root cause is some unitialized
thing.

>> >> > I mean if userspace specifies a NULL source_addr by mistake, it's better for
>> >> > kernel to detect this mistake, similar to how it validates whether source_addr
>> >> > is PAGE_ALIGNED.
>> >
>> > The alignment case is different.  If userspace provides an unaligned value, KVM
>> > *can't* do what userspace is asking because hardware and thus KVM only supports
>> > converting on page boundaries.
>> >
>> > For a NULL source, KVM can still do what userspace is asking.  Rejecting userspace's
>> > request would then be making assumptions about what userspace wants.
>> >
>>
>> Also, +1 on this, what if userspace, knowing that pages are zeroed on
>> allocation, actually wants to rely on that to get a zero page in the guest?
> What if 0 uaddr is a valid address? :)
>
>> >> > Since userspace already needs to perform additional steps to enable in-place
>> >> > copy, specifying a dedicated flag to indicate that the NULL source_addr is
>> >> > intentional seems like a reasonable burden.
>> >
>> > I don't see how it adds any value.  I wouldn't be at all surprised if most VMMs
>> > just wen up with code that does:
>> >
>> > 	if (in-place) {
>> > 		src = NULL;
>> > 		flags |= KVM_TDX_IN_PLACE_COPY_INITIAL_MEMORY_REGION;
>> > 	}
>>

