Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9D9606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XJuN6bGQ
Received: by kanga.kvack.org (Postfix)
	id 931416B00EF; Mon, 16 Nov 2026 03:30:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E25A6B05B6; Mon, 16 Nov 2026 03:30:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1126B05B7; Mon, 16 Nov 2026 03:30:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFA86B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:30:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEC39A86A2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:30:23 +0000 (UTC)
X-FDA: 85440310326.22.F0D5036
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7B8874000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:30:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XJuN6bGQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794817821;
	b=MNTWWnndAGI/Cl1QkhhWUCcRPrC+ym7q0Z0puJp06Dt+lyXfAkCOQU8QhSZQV3BseQ3yUL
	lw60hNOIYo424bfFTMhD5LFgPLN1d+sMa6dwUVQcXdfL6vdIrsX+qg9szRJujB7cEHnlcz
	+bsELeY2M4u1gDKdAWKVn9MfJGk2L4A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794817821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcxVbOcOy4JVEhqcYNolqzI7uMO52IjTv8D4sfciG7I=;
	b=h4WXrZbhbWdQ9bb6KUIPuN91prRzUxFsF689kL7Sqtz1Mko+Fre4dUg361rUfFLvSrQmUs
	rw8IZsnr3HmhcHMiznIKvc1zt3PVVBSbyt6fpZ0vYlKV31EpxNiL40yML9Oec6QV3m0Zqw
	lO2lZFGx0jQiZz+lsObUoct6mpu2dr0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XJuN6bGQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of mpilaniy@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpilaniy@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794817819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HcxVbOcOy4JVEhqcYNolqzI7uMO52IjTv8D4sfciG7I=;
	b=XJuN6bGQqf6W/ocxGmz8TkekE+MYOZaXko4yn6xoUI8nDAGyKZdITQydIbjAxjaaTbXtiC
	q8TZoVX2zpAXzLbDwgglE6NfXMv4v4rY5cGN0Zqh5R4d0AXExuSqZAro7gW1MzBqslsn2Z
	y5p3nolO4TF2dptyghW0Ui0nnWmsNyk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-arxaR-vOPtaf7ClaTQ4LGA-1; Mon, 16 Nov 2026 03:30:17 -0500
X-MC-Unique: arxaR-vOPtaf7ClaTQ4LGA-1
X-Mimecast-MFC-AGG-ID: arxaR-vOPtaf7ClaTQ4LGA_1794817817
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ee1ed68286so23385575ad.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:30:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794817817; x=1795422617;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HcxVbOcOy4JVEhqcYNolqzI7uMO52IjTv8D4sfciG7I=;
        b=YzIRCF4DHUSbCxH0SZHCnqRGo1KX1Vka4Zj/DAM8q8/1RV5nm6PhLA13pw97clICaK
         zXqDptz84mfvUFTc1i+5lDUhu7rj6WCuZ1oY4vkXPJ76lFl6mLc8cXfQSIxzBdSUHkBq
         pxAQ+SrXwglHLzfEJcmzRI2Lomd8CvITIVvTZiU6RdAP+CmPt+w3+7SY1THhaed4fYIX
         aohQ4/XNiWMMwuM/tZRZ4J53/XvVTta5f4jtVcYnbOGx5/YH4oxCCs2F23WVByzW9obW
         dzxc8HBc/i3cxxIs7L/s8QXD+Wf0AnnjtPgxDKM/6tzVtoePBGlN4piFXmytDcOlZTRN
         Pn9w==
X-Forwarded-Encrypted: i=1; AL+hErHMmSTuwVxj7Rxrc8veAWYaE2Ha2eYMWyM3XLMPgJbc4+7O+BopX/Rg13AainB19huT+PQez3sbpA==@kvack.org
X-Gm-Message-State: APuU4Z8IEEjQspKVYirto9MVf5cEgATQQ3IGxAz/tmdhKEuGo6uYoLMH
	1HIzw0ITr2fZZmd8TIq+FZc8WWOz4eH/eWhTLOHfniC5mOZNk3xtzi7ajxKGVq+aOLhx0mE4vn6
	PZUVzES7f5RfAX4Dhs/Twazabq3Y2LZFNFzFQ79ZhzajXbABHQLjz
X-Gm-Gg: AZFdTZeCtCX3bc1rt+cWrSWywVkbV3iazeMAGeuAhd9YehjlG1veNcgJeyCCXRPJE6d
	BGe5ImZ1RsXIVQdU+wj90iGB2w5LbaAstIbteOp4sSg4TmnJucvDea10ffDRjH8kDWMuNIa/15o
	jW00ZOjtSpEYSQCZeCz8ZAua8t/8ilj5J6BPR3uO2QJERIPvXE+9rZeTJCsziOzrtzrLVnlnG5v
	OKh1ZPMZn6kD6Q53D7jreyGb62IikTKyPVz3pL7eQgfLJVw++SQhlfnzQGlhqZMw0MLJaCE4uMm
	oV7DlmGEsyxjHTGDRm6Rvdq+zaJxxqvEgrmGqJpZ2zmT5qEh2Prwximp9z/c7wzcg+n1IO7CQ/i
	otioAJRCKQ2e2SCwjwcafui3AY/dZZZDQHNOnV/dBvIJZ0m70rrNTQ2YHBWkK7X5yQuoW
X-Received: by 2002:a17:903:2281:b0:2e9:55fc:ded2 with SMTP id d9443c01a7336-2ee0dec63demr105228425ad.52.1794817816643;
        Mon, 16 Nov 2026 00:30:16 -0800 (PST)
X-Received: by 2002:a17:903:2281:b0:2e9:55fc:ded2 with SMTP id d9443c01a7336-2ee0dec63demr105228045ad.52.1794817816125;
        Mon, 16 Nov 2026 00:30:16 -0800 (PST)
Received: from [192.168.1.41] ([117.245.173.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f4ad519sm33628995ad.2.2026.11.16.00.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 00:30:15 -0800 (PST)
Message-ID: <f402c25e-df9f-4007-914c-263694a00885@redhat.com>
Date: Mon, 16 Nov 2026 14:00:08 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] kho: walk bootmem areas in address order
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>,
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
 <990cc079-70ab-4fcf-9974-679aaf07849e@redhat.com>
 <avV9qoaPMBLCNOXD@kernel.org>
 <7d5f300f-ab18-4086-8a61-c3347168067a@redhat.com>
 <avl5QjUdYWcCP8Yo@kernel.org>
From: Mukesh Pilaniya <mpilaniy@redhat.com>
In-Reply-To: <avl5QjUdYWcCP8Yo@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XDkDAaa26lEMo-FfWHLsHb07Fcmib2FBIGxi_gD63w0_1794817817
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7B8874000A
X-Rspamd-Server: rspam12
X-Stat-Signature: ko6ri7ownzzi5gcopk8rwkmrf7fdbeya
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794817820-145618
X-HE-Meta: U2FsdGVkX19PXSmjp0hvpGNzQyznd1DDxg4BoD1Jy+65KisRVcPJ4cUuTHDOwVSiKUJ+aPJaxUDgc74B0S5Lo7Y6vCKRphetAfkL6Ru/Hg9PUF+AbTDFgm1lhSswXi4/IMLrfJtQBtakSrfzc/n8NtnsCissNNd2EPj3q7lumLXGs0ARHL7ULswDzWzkqUjETAfEmI3Y6jN7oB+hq6o9rSUL4H5dRbg6OsP6RR4Lm17NZdfomO3hCRZga/JFgnUDY54ARk1D2AEmQuO5Kx5/B8HNcP4c7mf8gDn62dRGPLeoSo5tHk9UgcPUducSwf0UAm1grV4joX+n5RJxKmkjn5MGOrGenBYG4ISaCCK2DxHGI1hP0YRo/rdYUfKlPKIR4u4lpe3vltrH5bREROKhHz6bq89FdIkfnwYRc5DxsTSAMgmofe362OjhTyjIWhOBvCpSqyyJmRVIMWEeNAsIXRqKyahVynxHHFK3XdjT7DbTFYVEptYMb9hK5vWwFAkkeuk2F+7t6UdnCUA/n8JKSoCPb+H1kPRwFYz9cKVeD5ChoUuwr6ioIaCa3na84ygWXKpy0XvmKszzoMntvQf0EOdsZ/dhAg3/MZJU7uqEGu04JL0Q9Z2/BR0sli8/OQEe8Yasz+tWRt5cNkdbbv4TrNN6QFRteUocVfbnIVyC2szguNcbiRuOBAUbGjl9f8797nN/uBQMDWIJkPrKFREyu77K/z6F9OsS6RpP5pb9MRZO2qeLr0dC44nY1aROQzsT4JizJrcsvSXYwtlMe8+O+Bb0XXqtqdixpwXs+dCcFDcRKt+iFI5S4ve2b5ZoazyRH0M3IqYiR3r+6FZJAekgbiXTeB70maqemj0VI0qQogacww3YHRbfVDmne0uo+By3iK0tptP89b7FPVp+xZrdBUPT3WObva6d8NKR64OvP3MI46OyQy9UHz39qMEZLf/0OZxvuhRbrEQi7DPkTHg
 t6Usu3v/
 SVarw6kjNgVi4ap8AjI9OVHP1Z0Dau4tJuzGQYKZRWEuVTwdpa3myvkePPV3+6Ndg/kNQEzROUg2XyYgbdazBH9yC7QkvWxQ2SNfIJfigRGzANp7BO77YVtF3QBoRHgfPeRS2ixHPZkH41fneVigLsfHDty8Fbaq9ZPhyWyv1WYu/Ra7rT95W8za6+5018OklmQYzlqV1k/boBeuDtIESePWLF+wF4WkYybzxhVkXUzVy4vzo5jG5M5HujXEJmTuW83VXNAJCIRP5lalt87GbzCE2cPnRUBJB0XsqREQ4GUFZK+vOMoK0JqJfuhLh3egk79LINtpt0rhNsIp8HYYHd9Vc0D8spr0ZQpgPzdernZyo7OqzH2KNE8ZT8+GTrFuivSbohTGdKUWSkHlZ4844ExPh2v/XnJwQgnfCJ8JM4FBKcvSKdHtbXFXnriGPNt2evT/lrcVOdk/1QdmmqNQuoc3mZEmkXEj5jQvF6pOEsHz0i/FmKHFBx7NBhvm03xycCe5rPgLfeoh95HDuOW9S5/0OxUFpsGHEqb4Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mike,

On 15/11/26 2:50 pm, Mike Rapoport wrote:
> On Fri, Nov 13, 2026 at 10:34:06PM +0530, Mukesh Pilaniya wrote:
>> Hi Mike,
>>
>> Thanks for the quick check. I apologies in advance if I am missing
>> something obvious.
>>
>> On 12/11/26 2:19 pm, Mike Rapoport wrote:
>>> On Thu, Nov 12, 2026 at 12:02:05PM +0530, Mukesh Pilaniya wrote:
>>>> Hi Mike,
>>>>
>>>> On 04/11/26 10:20 pm, Mike Rapoport (Microsoft) wrote:
>>>>> kexec_add_buffer() users may depend on the order in which memory holes are
>>>>> searched. For instance, arm64 places the kernel bottom-up and then
>>>>> requires the DTB to be above the kernel.
>>>>>
>>>>> kho_walk_bootmem() walks the bootmem areas in the order they were
>>>>> reserved, so if the kernel lands in a small area at the top of the memory
>>>>> there is no room left for the DTB and kexec fails. For example, on an
>>>>> arm64 VM with 2G of RAM and kho_bootmem=8M,64M,64M, the lowmem area is
>>>>> reserved first at the top of the memory, the kernel image takes most of
>>>>> it and kexec fails with
>>>>>
>>>>>   kexec_file(Image): Could not find any suitable kernel location!
>>>>>
>>>>> Sort the bootmem areas by address and walk them in ascending order, or in
>>>>> descending order for top-down searches, like kexec_walk_resources() does.
>>>>>
>>>>> Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
>>>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>>> ---
>>>>>  kernel/liveupdate/kexec_handover.c | 57 ++++++++++++++++++++++++++++++--------
>>>>>  1 file changed, 46 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>>>>> index 6f1f55fe31819..2ac5d94f33fd4 100644
>>>>> --- a/kernel/liveupdate/kexec_handover.c
>>>>> +++ b/kernel/liveupdate/kexec_handover.c
>>>>> @@ -26,6 +26,7 @@
>>>>>  #include <linux/list.h>
>>>>>  #include <linux/memblock.h>
>>>>>  #include <linux/page-isolation.h>
>>>>> +#include <linux/sort.h>
>>>>>  #include <linux/unaligned.h>
>>>>>  #include <linux/vmalloc.h>
>>>>>  
>>>>> @@ -820,6 +821,14 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
>>>>>  	return false;
>>>>>  }
>>>>>  
>>>>> +static int __init kho_bootmem_cmp(const void *_a, const void *_b)
>>>>> +{
>>>>> +	const struct kho_bootmem *a = _a;
>>>>> +	const struct kho_bootmem *b = _b;
>>>>> +
>>>>> +	return cmp_int(a->addr, b->addr);
>>>>> +}
>>>>> +
>>>>>  /**
>>>>>   * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
>>>>>   *
>>>>> @@ -904,6 +913,9 @@ static void __init kho_reserve_bootmem(void)
>>>>>  	 */
>>>>>  	kho_bootmem_cnt = i;
>>>>>  
>>>>> +	sort(kho_bootmem, kho_bootmem_cnt, sizeof(*kho_bootmem),
>>>>> +	     kho_bootmem_cmp, NULL);
>>>> This only covers the case where this kernel allocated the areas itself.
>>>> On a KHO boot the array comes from the previous kernel. A kernel with
>>>> this series that is handed over from one without it therefore keeps
>>>> walking the areas in reservation order for every following
>>>> kexec_file_load, and the arm64 failure you describe comes back until the
>>>> next cold boot and vise versa because the ABI string is still
>>>> "kho-v4".
>>>
>>> If we were able to kexec from a kernel with no reservation ordering, the
>>> issue is not there, isn't it?
>> IMHO that holds for the image that was just handed over, but maybe not
>> for the next one. The producer's last kexec_file_load did place that
>> exact Image, DTB and command line through the areas in that order, so I
>> agree that reloading the same image from the consumer will find the same
>> spot. The order is still arbitrary though, and whether it works seems to
>> depend on the size of the image being loaded.
>>
>> To give you the case I was looking at: on a QEMU arm64 guest with 4K
>> pages, 2 GiB of RAM and kho_bootmem=44M,64M,64M, the 44 MiB lowmem area
>> is reserved first, at the top of RAM (0xb8800000). The Image is about
>> 38 MiB, and the DTB has to go above it on a 2 MiB boundary, which lands
>> exactly on 0xbb400000, the end of that area. The load then fails with
>> "kexec_file_load failed: Cannot assign requested address", and the next
>> area is never tried, because the walk stops at the first area that
>> cannot take the buffer. With the areas walked in address order the same
>> image is placed in a lower, larger area and boots. So the first area
>> decides, and a few MiB of growth in the Image or a larger DTB is enough
>> to flip the result -- which is the part that makes me a bit nervous
>> about the first kexec after a handover.
> 
> There's always a risk that KHO will run out of bootmem, even presuming we
> fixed all our bugs :)
> 
> In your example it happens sooner then it should because there's still
> free memory that kexec won't use, but it's still the same - we've run out
> of bootmem.
> 
> I prefer to keep the sorting in the cold boot going forward to save a few
> cycles at kexec time, so I'd rather not add sorting to the kexec'ed boot.
Fair enough, and I'll drop the sorting-in-retrieve suggestion.

> 
> So the kernel from 7.5 will have it right and if there's a case when we use
> an older stable kernel for the cold boot, and we see that we *really* need
> sorting after kexec there we can just add such sort as a fix for stable.
That works for me. The change is small, so the backport should be
mechanical.

> 
> BTW, in your case it's enough to switch lowmem and global sizes to gain a
> few megs for future image growth, isn't it?
>  
>> It also does not settle down the chain, as far as I can tell. A kernel
>> booted by KHO never reserves, so it never sorts: B inherits A's order,
>> C inherits B's order, and only a cold boot sorts. That makes the same
>> binary behave differently depending on how it was started. Sorting in
>> kho_mem_retrieve as well would cover it.
>>>
>>> And after a cycle of KHO boots to newer kernels we anyway can get to the
>>> point when bootmem is not large enough.
>> That is the same argument, and it is probably why I am not fully
>> convinced that the previous successful kexec covers the ordering case
>> either. The inherited state was adequate for the load that produced the
>> running kernel, not necessarily for the load it is about to perform.
>>
>>>  
>>>>> +static int kho_bootmem_walk_top_down(struct kexec_buf *kbuf,
>>>>> +				     int (*func)(struct resource *, void *))
>>>>>  {
>>>>>  	int ret = 0;
>>>>> -	int i;
>>>>>  
>>>>> -	for (i = 0; i < kho_bootmem_cnt; i++) {
>>>>> -		struct resource res = {
>>>>> -			.start = kho_bootmem[i].addr,
>>>>> -			.end = kho_bootmem[i].addr + kho_bootmem[i].size - 1,
>>>>> -		};
>>>>> +	for (int i = kho_bootmem_cnt - 1; i >= 0; i--) {
>>>>
>>>> kho_bootmem_cnt is unsigned, but the reverse loops in
>>>> kho_reserve_bootmem() and kho_bootmem_walk_top_down() start an int
>>>> counter at kho_bootmem_cnt - 1, which for a zero count is UINT_MAX
>>>> converted to int.  That conversion is implementation-defined; with the
>>>> current compilers it yields -1 and the loop body is skipped.
>>>
>>> We never get here with kho_bootmem_cnt == 0.
>> Unless I am misreading it, we do, via kho_bootmem=0%. The parser accepts
>> it and stores the scale without a zero check, then bootmem_size_update()
>> takes the explicit-size branch and assigns the zero-initialised
>> bootmem_size_pernode to every node. kho_reserve_bootmem_area() returns
>> early for a zero size without recording the area, so kho_bootmem_cnt
>> stays 0 and kho_enable is left alone and only the error path clears it.
>>
>> kho_locate_mem_hole() is guarded by kho_enable only, so with cnt == 0
>> both walks return 0 and the caller turns that into -EADDRNOTAVAIL: KHO
>> is enabled with no regions and every kexec_file_load fails with "Cannot
>> assign requested address".
>>
>> FWIW this became possible with 214f9649 commit, before it the
>> zero-sized areas were recorded, so cnt was never 0. The zero-scale patch
>> you posted in the v4 series [v3 1/5]thread closes this one.
>>
>>>  
>>>> How about using this one.
>>>> 	for (unsigned int i = kho_bootmem_cnt; i-- > 0;)
>>>>
>>>> Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>
>>>
>>> Thanks!
>>>  
>>>> -- 
>>>> Regards,
>>>> Mukesh Pilaniya
>>>>
>>>
>>
>> -- 
>> Regards,
>> Mukesh Pilaniya
>>
> 

-- 
Regards,
Mukesh Pilaniya


