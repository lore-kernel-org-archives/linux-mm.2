Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0873AE67A9C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE516B0096; Tue,  3 Mar 2026 03:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC786B009D; Tue,  3 Mar 2026 03:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A42A6B00A1; Tue,  3 Mar 2026 03:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49F356B0096
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:49:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB9DC1602B8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:49:24 +0000 (UTC)
X-FDA: 84504127848.12.4F30E69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0DF43180003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:49:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J/72Vv2c";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772527763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbGWYBMaMvRnDZWdaGCfThHaOw2+2lhf0ftPsW5hryg=;
	b=czuKr+BmS5QP/0X9dcUs+yQRQxcRyg0YWUG+Pe6dMQiSuwSSjjFM82gvW3ik4nuJFpsdoJ
	K7f7Ur3HBUBk3yTiGdTnv/atwUiGLYFr0PxUTwuQlbgXHc4DulTeDGcuiCGVnwY8Nar70z
	RFXOt6hPMysEJ6b8zDHHVP5Aj/RLfkg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J/72Vv2c";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772527763; a=rsa-sha256;
	cv=none;
	b=xuHieOfkW6OEgvmupD+mVRCEKsDLfd8QkP2tE3p7kTpMrpOhlB8NcVhVhMRgiTlZLk7NLP
	cIKNkcCKjckYjn17W0CgPOg/8g+hutqQN2rJjwsK16ayn3mJGg4w7PVp4lKwewyrTVbeTW
	5scYivjYpAtbtDJrgF4wKmwj+JNbhvU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A0854413E;
	Tue,  3 Mar 2026 08:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B26C116C6;
	Tue,  3 Mar 2026 08:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772527762;
	bh=JaD79dXQHufCQnM1pCE8hYRquoIOvY5KaE/X/JmRPFU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J/72Vv2cjiRCjXUsiQrPB1gIu96TS7IExQyAgZolreyw41sVbQb0G+pb+PBfOUyO4
	 BT4v9iTvSH/1Cb7uCZ7tgNLFRH8Zdt48mm4ctlT9ezNtMH0fTTFa+YTAsWrcknEJJ7
	 Jn+VvKYIRQHCAfHwqRhKo5sgm3LUm63RcoLE46XcMa2fIanDS3kHAl2NZ64dALZuCu
	 VGKIPNo/gkkcfkzhXlk1BfJNI9Au3hJQ2Gsp4BRwvI5n9TWDGiRSmOrVMmEMFsB9D0
	 6q9jBIAtgAuB69Xa1Qxm6OcYw/K45SosrJZ1xTvfMQKxBZforaU4xKB9IYSacKcsi5
	 b3dSX3KC2vWmQ==
Message-ID: <b1499bfa-a16f-4242-8715-ddd9a4246fe3@kernel.org>
Date: Tue, 3 Mar 2026 09:49:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: fix memory corruption on huge
 zero page move
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Chris Down <chris@chrisdown.name>, Suren Baghdasaryan <surenb@google.com>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
 <901fec30-c5c2-46c5-b48d-f9a8f5e5c928@kernel.org>
 <f11357fa-29ac-436c-a9a9-8406f516ea30@lucifer.local>
 <20260302125032.313797b0ec908cd133f3ed82@linux-foundation.org>
 <a1e787dd-b911-474d-8570-f37685357d86@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a1e787dd-b911-474d-8570-f37685357d86@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0DF43180003
X-Rspamd-Server: rspam07
X-Stat-Signature: ybwjws1pj3psrnhjw4k7grnj8huqo8ac
X-Rspam-User: 
X-HE-Tag: 1772527762-490373
X-HE-Meta: U2FsdGVkX1+DCKT4hjaRN4GvHzF+O/QmwiAWC8R+AjT89y9NAI1PdfPFZR/AoDAw/9+h1oiw9C8l72LB0od1PNTfn+9aLNBOlOogbfp9ImdD5JOzzBwuQgHOCAMZtWjJsVyVQ3nYPQ9dVMHfJnSvqL/BDfz2+Eav9Cz2Me5hnMzkkReyUdQu7rr5zXWci+llmiza/NWWiZftEwAzmxpLq/c7L2XlBGJxVKkmUn/EldSRz6MjPadSi8HyLu0iLOqznbZrshvISbSyEguHHVtMnRuhdTc3QALJp5vqq6I+CdfIwyV4/u/fVjcya5VZUxM/dU/wCy4L8TGxfC0M/LQZdNHSFPvJTnfatIbxMHE/iya3kXFY/vXSo910z5NPdZsTLJUC/IECsVASvYhL+PD8qBsv4CgHF65HibC3NFNoFvEF21ED65WMADJvwDFdJ35xL4Qnnfo2I2ORPZahP0DSes76TOQZVgt6HbGtd0fPCQwe6eLrYFTQZjuxUOAd1V8M3v/MhxSgC6gSiDm/znkQgz0Vg4LY7Gz+bzD/O+MaaYVAXJ7AimF2aUKneR+8+YgQjdwLjN+b5Hn/LCD3XXLWDKjm1PAsMOBZ2UubavbC8li28gOYdo+ueZoIJoVe6WFl56w4OrtBqI76tIqSw/AfV92VM3ex8tE+Ok3I2dT9d318kr10KiXpILZyM+LWR1MyI2lHpwLzO0cTfx1fhLTdEVgVrimYZ3Q9dPnSL5b+1vcdx6NnBaeMyuuWWYJtsD7wOaY0PQtSahZqNRi73uxlCPWlxjVx+zsX8lFe5KWblqQa0HZ+a/cC5VVKawnrQI0mAHjouz4RvcFdgs6Rl86P950x0P/nP2gMn1U81j5NWtQIyDgkMePF+QlLrfTyQwS48K/FBPTfcRKs3Cr8bMIxEYivlsQJID/xRScm3KkzxvqklPGwGecKnJPNdUGYqcUKE2QONDAX3r+jLA0VRDY
 6RpJ1RcT
 G/szJkyol/p0N2Zn6qrS+sarWEhGQ3QvN1Kwi2lN8vNSQWAEZQezAVxfCtQkaJChvDoI2FWa0Vcz/3qTz4V7lyPe0awi3+jTRN4rdXNo9Yqtk/4UxxVr7wCj+FwFY3JngGJ1+RxMNdPIX30GBOA93E1E3za/IkNVhFdwm68dOlLqeGzQWqvZxsTxyZPUbfoTOyW66nvxAPue2dDyaddBBRcnC30kooOOpYdQR/4zZ3ra+upttzlN9eI2DgFPizPeinL6UYlDzTDiwwQ17QPqmIXgayrOTMcC/DSGCLnfBBBU2CrSJVLAcMHPedxS6V2ueGhCy7aQur48r45c2fvQrmCYas9gbGlwfDhxH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 08:25, Lorenzo Stoakes wrote:
> On Mon, Mar 02, 2026 at 12:50:32PM -0800, Andrew Morton wrote:
>> On Mon, 2 Mar 2026 17:19:15 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>>
>>>
>>> Yup, if people would actually cc the right people I'd not have wasted my
>>> afternoon.
>>>
>>> Replying there.
>>>
>>
>> I'm not sure where this is headed but I'll queue this patch for now, to
>> get it some testing, to lessen duplicated bug reports and to generally track things.
> 
> Hi Andrew -
> 
> We should drop my patch and take Chris's.
> 
> However, life isn't so simple :) as there's been some confusion with his series
> since his email client seemed to mess up somehow and a couple patches need to be
> squashed on one another.
> 
> So to make life easier, I enclose a squashed patch (combining the commit
> message from both), with my R-b, T-b tags attached, please replace my patch
> with this one.
> 
> Also, could you make this into a 2 patch series with
> https://lore.kernel.org/linux-mm/aaBWG4fajXXbjpVN@chrisdown.name/ _after_ this
> one?
> 
> mm-unstable (I'm not sure why we're rushing changes there so quick...) had
> _only_ this regression test patch in it, so we were left with a kernel that
> splatted on running mm selftests, which is not what we want.
> 
> (It seems to me this is what mm-new is for, and it seems we have some holes in
> our testing still since this got thorugh).
> 
> Please drop the patch you have for this already in mm-unstable and make sure we
> only have it _after_ the fix is applied :)
> 
> Thanks, Lorenzo
> 
> ----8<----
> From fbabbc38c000308d2c621a4b3ec1f4bca1d71c1d Mon Sep 17 00:00:00 2001
> From: Chris Down <chris@chrisdown.name>
> Date: Tue, 3 Mar 2026 07:21:21 +0000
> Subject: [PATCH] mm/huge_memory: Fix use of NULL folio in
>  move_pages_huge_pmd()
> 
> move_pages_huge_pmd() handles UFFDIO_MOVE for both normal THPs and huge
> zero pages. For the huge zero page path, src_folio is explicitly set to
> NULL, and is used as a sentinel to skip folio operations like lock and
> rmap.
> 
> In the huge zero page branch, src_folio is NULL, so folio_mk_pmd(NULL,
> pgprot) passes NULL through folio_pfn() and page_to_pfn(). With
> SPARSEMEM_VMEMMAP this silently produces a bogus PFN, installing a PMD
> pointing to non-existent physical memory. On other memory models it is a
> NULL dereference.
> 
> Use page_folio(src_page) to obtain the valid huge zero folio from the
> page, which was obtained from pmd_page() and remains valid throughout.
> 
> After commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the
> huge zero folio special"), moved huge zero PMDs must remain special so
> vm_normal_page_pmd() continues to treat them as special mappings.
> 
> move_pages_huge_pmd() currently reconstructs the destination PMD in the
> huge zero page branch, which drops PMD state such as pmd_special() on
> architectures with CONFIG_ARCH_HAS_PTE_SPECIAL. As a result,
> vm_normal_page_pmd() can treat the moved huge zero PMD as a normal page
> and corrupt its refcount.
> 
> Instead of reconstructing the PMD from the folio, derive the destination
> entry from src_pmdval after pmdp_huge_clear_flush(), then handle the PMD
> metadata the same way move_huge_pmd() does for moved entries by marking
> it soft-dirty and clearing uffd-wp.
> 
> Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
> Cc: stable@vger.kernel.org
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

