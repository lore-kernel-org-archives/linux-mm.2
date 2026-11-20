Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5178606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XtH8hZT2
Received: by kanga.kvack.org (Postfix)
	id ED9B46B05B3; Fri, 20 Nov 2026 04:31:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0FE6B05B4; Fri, 20 Nov 2026 04:31:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6B86B05B7; Fri, 20 Nov 2026 04:31:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCB3D6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:31:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B0FE140DDA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:31:23 +0000 (UTC)
X-FDA: 85454979246.03.A155D90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 690461C0009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:31:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtH8hZT2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795167081;
	b=Ba2A0BywuI+wD4hs0mrqKar8bN+0VXSIeeS38+S3bTOnWtxbm2OLkPJSQJkD8/Qc94gRr8
	g+1u9qRjSqtxWj3SdJc4esNBSxvAenMcVAmF9lvQHlan0IN1LQr3yhOFH1Kr0AnwXWivee
	dk89wDk4yG7EmMz5HVqEOgepLE0ZoTo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795167081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bm+fmzDzNdr8isbrhqngN9fgikR0ji/6yEcUPTWrUSc=;
	b=uBavyseRmTOurgm8+XOGHDFPTwSLb21oGb0Qx1YmYTqsMmh0RH8/v02fTpgKcphP4+Pa7w
	0ulGfJLzWZG2wOkOf1AmtiaXR/WmwaP2KPktI4TvytHr6/B5/9vfUpm2pb4Y9mKgEcz/BG
	z1vkFJSsxIkFFPX/sc1kVhYJQRxjvYE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtH8hZT2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 993AC45991;
	Fri, 20 Nov 2026 09:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F321F000D1;
	Fri, 20 Nov 2026 09:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795167080;
	bh=bm+fmzDzNdr8isbrhqngN9fgikR0ji/6yEcUPTWrUSc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XtH8hZT2dYdT1KrzhYRGEG27GZWawzgVEOX4sOsBPjKdHSse/oexrzM03xNGccN8R
	 yxAx6TgkI+sQVCfY0IteUpk6AQQNN6gRXtKHQq14yybiTfaDiPQ6YrEQNeybodZeNt
	 3nb7DgrTTWFcNv1WcgRJRZml0I3mBe+4Knd2tvnOfzbVPD0BERuikdvJYwly5P5t/s
	 pHKiNztflFXUPJGhFwSt/OFTQyIPubVHN1eFCDhmXjKCVC7XHuISf/FKSHdC/CjcTe
	 /N/oAkOIE8BIhKvKglJmrVc3G++sbwlEMiBFmhMsB53wm0Ma8u7o5vnwbIm5q2uZ+Z
	 gOxst6tEQ8gkA==
Message-ID: <3f23e91b-7616-418f-8f31-c7af667156ee@kernel.org>
Date: Fri, 20 Nov 2026 10:31:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/gup: add file_is_memfd_compatible() helper
To: Jiahao Xu <xujiahao@cmss.chinamobile.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Samiullah Khawaja <skhawaja@google.com>,
 syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com
References: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 690461C0009
X-Stat-Signature: 4o8jzbifpxp6h8iy9c3n9qi8q5sib5tz
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795167081-442889
X-HE-Meta: U2FsdGVkX18hDRxM9/iRXs5bg1xBCC34UJ5Mke+Zob50TDq8TRopa9jmNcZtHnJCH7wqKJyaJhvSzH1dW8f14wx1zUf0dLizF5pKofytmPkmEiJhehytjjrJXQPPlEXzB6fxoTDskZqu3Nwu6CXSdUcp26EHS722G6I3IxXVUgcaB9rMg+Mm0s8lCbGDJ8TJ76A3bHRp2Aqq8G3NmUpieNEdTmm50hyi5Cu8vilY2F/taM5dSEWH4Zg8rj1CZ6QBLLzO38BB3YDBhMIhVUTdA2k0L7VkX6oKvZb02j5Ep2I1vnPVGLNuHUp3J/sK6Fj/ne7ZGI6QT+nX0Ba+pfYAOfzHHmgj+6qOmYEudpCGuaJvyAYO8IkAp0ruVpDoZ4x2wXy8EnpXCHY0ZRT6kf4iuSUiPxHWRVjKBZ5ZJTBcVZY2XzXsUuY94LQGyRo4Pq5cTwq7U9Gxp4nMId+qBubA6SRztYbD3y6x2DuN0ouQ6XL/f0Gd5usXD4wLDeqebl8Lv8UT98C/6mLkyPdyf8SP4h0Gxyj4qkj4RsvFJvfntoj3J38kOGnilw0TYnlwUSCkDQxH5VSK6XIsDFUY/Je6fdAT148ZB5L6sF+HbErkJiIkVZZ7SlTuUn0kFfkrf0DsB9GXh6Yu8PBmsLJeeb7ODHx6ox+0Jz+SK6+1H1qctT1qPP9msZlkDLCEQeS/zV3jtvUVaxVi3j+U9S1qyErlhYXahoDBBnWQsU2eF4O9mxVkuw6Dk28ruM5Q3dw7HIWjOES6HuoLKjnm+Pw7olghMtf/Vt/q/Z474VfLRvNQ+KGnNPrlGsZ1I3FpPSsopQR8lpaTce97LAMkduxM8xrGdiNaxM+rnA9JyQlcR/6wALuMxD4IKNs/Zub2iJbdizu+uss3eWzYpMw4csN/c8ohUG1cJfWJZ39T+RITW8Ml/F2mjIokenDlLsqYMOweb4szifr5Tr2YetN7pPGT8zR
 tjta2cEN
 6/XA114XsS+HBY0tDHn9WV5kRRIeiQYlwseAz6RfASAo1+cgFBGBkJQl9A59o/2+vHOddtfcNvj9WVtrsOm4qFrIrI3bjlF8FHOnLN2nmbunOH3AMeZwgwfBS6qt0V76zE00F0KL0MzuRrruOhcofTTFyS/4B2jaIxUqngOMdG+py7feMktIrIxHKfiVE0UM8ePZjXbFiDUDlxMuZMs52KEoIhH+FB/xAA7fa0w3x+FEdlk2cKcRknPndMAQAFjMAwtfBWNb6217J7OcRP1b5seNSbjI7U/4HaAksZgWeP7/sna2+p08wrLUB9FbIprdVxXaFs5lnbtS22mSYyCWiezwkDUWefeAN6mNvkXhdMSdEqj2p4QwWnHkxKanL8S4M5snDLEOLlOuyQgGNbMR1RERE8wfJP1+ryMwgJsMQ1th0q/ewva4qcQz4LmdCU/D3BxoVOiP14PYA6EXC6xTvgtcHSJhmpRRpyYshJgejOchqxdozRyIKdSPgN/AESKR/R99wImM70Df4RodXx184BSWid0gQsxo+od7ljRzZgOvUaZanhrrTBU7X0u/4OjOQb+78yFjuKw/g9a53m36vWts+mlJO16ZRG0rF0C7JAkxPNj2jb+D8rJtyeDcBNPk7717QkGiuQKQ4qHBq8kjm2wbSzqObwf04AhH3bTnuyLOz691ElIRRgytGyIEmEUFELR5L/CRosJtUFlM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 09:35, Jiahao Xu wrote:
> memfd_pin_folios() accepts only shmem and file-hugetlb files and enforces
> that inline with shmem_file() and is_file_hugepages().  A caller that has
> to know up front whether a file may be handed to memfd_pin_folios()
> cannot use those predicates: since d3710111839d ("mm/shmem: make
> shmem_file() check the file's inode") shmem_file() is an out-of-line
> function in mm/shmem.c which is not exported, so modules cannot call it,
> and is_file_hugepages() on its own is not the same question.
> 
> Provide the check as an exported helper next to memfd_pin_folios() and
> use it inside memfd_pin_folios() itself, so that a single place decides
> which files may be pinned.
> 
> Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
> ---
> v2:
>  - Rename memfd_pin_folios_supported() to file_is_memfd_compatible(),
>    suggested by David Hildenbrand: the predicate asks about the file, not
>    about the memfd interface.
> v1: https://lore.kernel.org/all/20261119104417.312237-1-xujiahao@cmss.chinamobile.com/
> ---
>  include/linux/mm.h |  1 +
>  mm/gup.c           | 23 ++++++++++++++++++++++-
>  2 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 040cff643..dffcc0b5a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3600,6 +3600,7 @@ long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
>  long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
>  		      struct folio **folios, unsigned int max_folios,
>  		      pgoff_t *offset);
> +bool file_is_memfd_compatible(struct file *file);
>  int folio_add_pins(struct folio *folio, unsigned int pins);
>  
>  int get_user_pages_fast(unsigned long start, int nr_pages,
> diff --git a/mm/gup.c b/mm/gup.c
> index 7605da0e0..da8a2c29b 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -3449,6 +3449,27 @@ long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
>  }
>  EXPORT_SYMBOL(pin_user_pages_unlocked);
>  
> +/**
> + * file_is_memfd_compatible() - check if a file may be used with
> + *				memfd_pin_folios()
> + * @file: the file to check
> + *
> + * memfd_pin_folios() only accepts files backed by shmem or by hugetlb.
> + * This is wider than "is a memfd": every shmem file matches, not only the
> + * unlinked ones memfd_create() produces, and file-hugetlb files are not
> + * memfds at all.
> + *
> + * Callers that have to validate a file before pinning it, or before taking
> + * a reference to it, can use this helper instead of duplicating the check.
> + *
> + * Return: true if @file may be passed to memfd_pin_folios().
> + */
> +bool file_is_memfd_compatible(struct file *file)
> +{
> +	return shmem_file(file) || is_file_hugepages(file);
> +}
> +EXPORT_SYMBOL_GPL(file_is_memfd_compatible);

Work for me, but maybe others have better naming suggestions.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

