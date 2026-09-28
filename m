Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94EEFC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24436B0088; Mon, 28 Sep 2026 05:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE616B009B; Mon, 28 Sep 2026 05:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875C56B009E; Mon, 28 Sep 2026 05:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 674D66B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:11:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC69DC014B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:11:19 +0000 (UTC)
X-FDA: 85262602278.11.EC45052
Received: from mta1.migadu.com (out-51.mta1.migadu.com [95.215.58.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 435CC40008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:11:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z7mQmQQt;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.51 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790586678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MiVDg1DVl5jaFqWBwl3swEi0Hui4WZ+52TsuW+vxMk=;
	b=Qv97fBG31b3HUZ7d69AF6tpZihSMEES7tKVVt0PGBfap9Mc7dhjTWkvZVdaPNdvrknL/Bk
	uRS7frkL7nm9YDOij6oR8xAS7g0fzlfMybvFxxAjlL8R1VCdzEnfsRCj++1S1pPnHakh1j
	BGczoAXLGo3OGIxkH8AtZREM/39/RO4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z7mQmQQt;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.51 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790586678;
	b=7dekwM1ndDo5Cl1BOclTPNyO5+EXnyZic42i6155RkJ/WAW7jQV/d/2yI6U7C4a1GYlces
	5THV6tOtZ+lYS3R/s+3paz/RnzsvebIRSJjuH5eswLeLVakRh2Mb6t3gN401s4S6Wkefnn
	L7BweEFtI1CobdXg0e0Gc2UuVWsxoNY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=t2bV+J7yQGAh8QlD1zm5r+V9wMPmlwMAn8PlZVKY1jc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790586673; v=1; x=1791191473;
 b=Z7mQmQQt5XEcyW4cCAXjzYJMSGaQ7aWkhSPucj68B/NzyTdvNt8m7UJDSDcZAmtwxLPuT7aH
 Ryb+/b1/nOLqGlx81w8EA9HGttWMV4QkZzTmjXVUHKA/4Y1DuxfL+nNupbGuMKV0mzwUP8iamXf
 whLA/8yc0dowa/UnFIFAzhxE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 65f31ff16b613622;
	Mon, 28 Sep 2026 09:11:13 +0000
X-Mizu-Trace-ID: 65f31ff16b613622
X-Migadu-Flow: FLOW_OUT
Date: Mon, 28 Sep 2026 17:11:08 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>,
	Dave Young <ruirui.yang@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] vmcoreinfo: export SECTION_HAS_MEM_MAP
Message-ID: <arovLO37djQderTB@MiWiFi-R3L-srv>
References: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 435CC40008
X-Stat-Signature: 5eydztd8znqqgt6f1u1reiq63aotkrgb
X-HE-Tag: 1790586676-917023
X-HE-Meta: U2FsdGVkX19UfHRZbHzHSPwOMMmmQOfrum2CagR5mjg5of6vI/IGP8F6rBwfZOp0tRv4afxTUcGHEHOtuBx1rn3TsjpO7Us11T5LTYaCIdUcu4gPlvmxyUjZ51aWePjAbVBrjHz0Q2iugqWUvj6gbjhE3oOO1FSrYmPA3hd5zl9pwWuGR8eHw5MfSJ342ThOiBS9P/rPJTBJZcGMxVlncNhAjmH81OSaJ9rN/rg7iyY0QHxSqJxwNrAheI+fMYPWcvJMMjL9/86p0PmDrg7yKHoPK5nYE5GrvRquiEqMtwDTn7htQa98hc4xf0mpZm4wYzidTCudM96DAtXnicJ4X+KvPHotvpaNV+Xl+M1UKl7+OgYQXwfZD6B20eFdjNfN/jZBGOYVj3fX1fUr30IO4kfFmAKhN7wwyxqwy1LQrLlddVDBsDp5zBAW5z4Tyf3dDC0dodXtuvBvGbIsPIOykSF6I1q/ucrDMyQgOa1uvRPccq0Bec9hbGNf7H7922YvUX0eD++bfshfuDmShh2cyie9G2LJog46l1heOMl5VOTVFu4xVbSPZDGPFn73B6uKJifoJD5D7dOMYIoLzhDGW7kX+Xkh4u9pXXtvZZl5O6oasOC86S4g48gEnztkYuXWHgWIOege/5zc+WV5P7djZZDltcJ99nqiGuW4euf8/frf3yWBlJ191IAWTd7R8NF7f9yWZe/Gn9zETmIUZEnKcA9DKYdWcKNCFsSq6cphFZrCguXy8A4hA5MSxnyCJXlH48w+3kPYSwLKt6IZLAuaKYYGs4DuN0kEu+AJK3TOeUYvqmK6P6Kf4Wn6VmetcB5Z2SrAiplDo0B4QBdDfhdfWsRBPh+k/mDjAraa52YQGdhKkM4z+353vCBL6bhCiScO2prYNVfwrsFjykqMz/Isu8SUc8Q8RpAjTzFRfdGmlRMMe08UfTYYt8uj1UhXuKiusrMsvnLv7WdVVA9uR27
 eW0NkqMX
 eJ04pccyuSMVR0eqC6L2PCZXZGSX7MiTKUfxKBqyNG1sKBSkuEmBHsykRlt/KZoQYfi30rnBt74s3R0++VyYq4MfqKIobvlzqWQka/vY8G51EfmZogRa+Tq2ixZVjnWNANMY6iCOasjJuPSrgOFg8UotuE5EN4Bq3kWInQEBpGUnqd+POEB9ObSR2EOHgY2XBh0eRSWSLZH1w2DGp20ZdY5BtoptayIe7JO8SW/cDCI4qOL1sn3np+09TU1W+oktJ3YvnoXr4YwNXzS1diAZ7bYRVEeWFGPrLXdSEuQX6QVV65l5pq/6+ijFrhaUvnqlCcARFkUUUtcJNV++4T8sqCw1V3kyDPlVZuOsPsoInD8AB9efWrAMZp1OeLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/28/26 at 10:48am, David Hildenbrand (Arm) wrote:
> The crash tool currently hardcodes SECTION_HAS_MEM_MAP, and makedumpfile
> needs similar information (although still relying on
> SECTION_MARKED_PRESENT, it should switch to SECTION_HAS_MEM_MAP).
> 
> Let's just export the value instead, so tools that work on vmcoreinfo
> will not have to guess.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Result of the discussion in reply to "[PATCH v2 00/13] mm/sparse: remove
> SECTION_MARKED_PRESENT and further cleanups" [1]
> 
> This patch can go in independently. It would be preferable if both
> go into the same kernel release ;)
> 
> [1] https://lore.kernel.org/r/20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org 
> ---
>  kernel/vmcore_info.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
> index 5a417f8a922a..7833a36064a8 100644
> --- a/kernel/vmcore_info.c
> +++ b/kernel/vmcore_info.c
> @@ -182,6 +182,7 @@ static int __init crash_save_vmcoreinfo_init(void)
>  	VMCOREINFO_STRUCT_SIZE(mem_section);
>  	VMCOREINFO_OFFSET(mem_section, section_mem_map);
>  	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
> +	VMCOREINFO_NUMBER(SECTION_HAS_MEM_MAP);
>  	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
>  #endif
>  	VMCOREINFO_STRUCT_SIZE(page);

It would be good to add one section in
Documentation/admin-guide/kdump/vmcoreinfo.rst, e.g

SECTION_HAS_MEM_MAP
-------------------

Indicates a memory section has struct page array (mem_map). User-space
tools should read this value but not hardcode it since the bit position
could change between kernel versions.

The code change looks good to me.

> 
> ---
> 
> base-commit: 57e4ac91fc62d75d84b5a03827a19ceb4094ecd9
> 
> change-id: 20260928-section_has_mem_map-6205dc90a09f
> 
> --
> 
> Cheers,
> 
> David
> 

