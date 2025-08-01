Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AD8C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 19:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8BA26B0089; Fri,  1 Aug 2025 15:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B635E6B008A; Fri,  1 Aug 2025 15:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9FDC6B008C; Fri,  1 Aug 2025 15:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2A36B0089
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:35:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F46F160154
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:35:43 +0000 (UTC)
X-FDA: 83729193366.14.5F0C3DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BA4C6100005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:35:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MLZV5Olb;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754076941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VG74Xjxww0kY/xkAidIKhxJHl3ErUsN7G3TG0s+PFk0=;
	b=tzxFI6Zuz1hvEDMbxcCReBna6begSaov82aOTApvX2dVsNXbbLWKB5+0SDlLRgqdQTeSl3
	nKFQpR8iWD4Szvnnu2+qn/qvi4F29RuHw4F9e6PflpSzW8ebRxkBEbd6bHN+Ynpl3uw0Ff
	OlC1swHONKQsrC1EeHvnDdY3v8Dd4d4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754076941; a=rsa-sha256;
	cv=none;
	b=MJ9egTYKP5vKO6giEdUIa4V/rp+Zat4juCLdVsfzECTKbSRi3joMeTp8+FVOlT42RqQQFj
	vriddE1P9lxLxj2lza6nMQnhRGqyM6f8tjYj4JNwYPS2k4zgXQ049PdOkOG2djlNjuod2M
	G0B7OI0WPgn8qwhO7TETqqkGVPYhsVo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MLZV5Olb;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 248E46112D;
	Fri,  1 Aug 2025 19:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8589C4CEE7;
	Fri,  1 Aug 2025 19:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754076940;
	bh=N4zcWxz0G70Gk7ZR1SotpUujN9s9JmpktFgtGaCKwN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLZV5OlbajLgE60JrNadzVZxjWK7VS0m42e2TNn6c+TEg9vu7pw3tsZmpKAcV6c4Q
	 zhsBn6Bc6EtM4AwoZaQ7bL/ygInRzT725Tz77TO8jgrjhcZY/LCuy5qv0WAVhTBBOq
	 ZYC+MgrCc6R6pnOuWcvhiAxJ2l46PW4ZPg9FSz8F8nIE/hCUaux8Oh1YWBtzzJfL5K
	 IojollchCFzQw8OPB8CwLdfCMxZr9je0nRrnVswN5dbJI+qQc96ydQcOcPlf3rcrg6
	 f5cQOcWgz0C9X7iVDLuBGqwMz6AdnK3LWefoZjvraJ/olE6oTX+8B3Hp1UxRxSO0qC
	 SRiZxRyc+6njw==
From: SeongJae Park <sj@kernel.org>
To: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	willy@infradead.org,
	vbabka@suse.cz,
	jannh@google.com,
	pfalcato@suse.de,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com
Subject: Re: [PATCH] mm/nommu: convert kobjsize() to folios
Date: Fri,  1 Aug 2025 12:35:37 -0700
Message-Id: <20250801193537.1149-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731202629.3729139-1-sidhartha.kumar@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA4C6100005
X-Stat-Signature: q4mbd3i4a17boerrnk8n1z51cjzbwi1n
X-Rspam-User: 
X-HE-Tag: 1754076941-205178
X-HE-Meta: U2FsdGVkX1+OoLa9YvmUggzEJ7CFVggOJijjk/JbvTRyV6HqnDz4RCcoa8V57u72g5hvj+mgo0TqMJ6+5u/tFiqKP8RpY023VcnIJW+HHTqrRxO9006rG1vo+PNfo2zu8T0he0UFc0LirAqiYdYgZoqTGYBqs/Firv9mEbmgwgqqAjv4MVF4I84WFEa68DNDDLLHR8cpE3/4E+Q581D3T2t37NL85b0CQAcSupejveaVo94A0zGiQsUAf3sjHPb3MIY5bnh5uwkosofE93Luz8GdVWsOR577zJWIKS9Tbr7yKk9TyadRquhZj44T9AyRziNEVSJc6kpX8/4eOxYIJaSgPHMN8TaI1KeXq8jkSMw8uKgaCBBAuruWgRaq+EtTHt3r+nVGN0Uk1cjuwRdFZVrVliU2WWXcnTJNTUPeF/lIvA24ogDfI31q2eW6cMbnKiAxUNgCFic1WIaoZOm97SQxLPvoZfJv1wEfpvFcIJ48cTtz6QbX32bUDP/GVjIWeaFgT9KfI8091NlO+mIU2reqVODKaL7vlFdQwl+7T4EQ6lYznxj/jWYZ/KtGTty1j2eH0i2GgSmCSDf+TXhOhbwpNmiP7/qG50Jhy2uG9XCsBO5Xq/6XNebX6lf19aq3WKJjs78bk4bbq2Kamt66yZncLejiguJaYn36Lxgx3ZeOkZJ/3Rm6H6qzeUtFU9iRik69k5AYMmqzFFRHI9LYm09xTVYjhI7S6q8UjJQeLApX2fJLGsaP7ZH8UQ09w1HoTjnZLUtVv8r6roP1RHqfESzkwi4P3ifvonzH1xXBDfK2wlNaiK0r5bw7yG0jL9T08YNxXQ3DrbMz2lDNztiBtz+3qDib8NWLuxwu798kYMFBOeEM51YtGwLAMrV4B9Nas3RaO935oxUD8p07vsQTtWKkL7M9a2Y1B4XZhvP8vdk2leTN+fIT5CYobheeu+dxccZ8b4HH7sY3AUDZr+V
 BIITyYK/
 cylQ7eZ01pjc+osEnOdRU3BmtC2FKlamB3VDCOT3D5HFnTZZLMd50Ro/MAaFH6CkStpr3lrR44zljJSqXbUAV/oLPWEh3PQM5UNjWVvcOYOWf6kEZKDvQfln9CUnIjkZ1x272QiH4TYyiy34OUPI/MyeXiPeh4coZTOFKT6He4R6XGqsH5mInriVUibOTY8cHN+tAsoFxTCnstJn37MZnLaleBQFyCd/kFckOQApi7sOvE4MSP2yoVL0+a7qk3CqGAAYg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 31 Jul 2025 20:26:29 +0000 Sidhartha Kumar <sidhartha.kumar@oracle.com> wrote:

> Simple folio conversion to remove a user of PageSlab() and
> PageCompound().
> 
> Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>

I have a trivial comment below, but since it is just a trivial one that I don't
really care,

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/nommu.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 07504d666d6a..a00f8fc316c1 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -64,7 +64,7 @@ const struct vm_operations_struct generic_file_vm_ops = {
>   */
>  unsigned int kobjsize(const void *objp)
>  {
> -	struct page *page;
> +	struct folio *folio;
>  
>  	/*
>  	 * If the object we have should not have ksize performed on it,
> @@ -73,22 +73,22 @@ unsigned int kobjsize(const void *objp)
>  	if (!objp || !virt_addr_valid(objp))
>  		return 0;
>  
> -	page = virt_to_head_page(objp);
> +	folio = virt_to_folio(objp);
>  
>  	/*
>  	 * If the allocator sets PageSlab, we know the pointer came from
>  	 * kmalloc().
>  	 */
> -	if (PageSlab(page))
> +	if (folio_test_slab(folio))
>  		return ksize(objp);
>  
>  	/*
> -	 * If it's not a compound page, see if we have a matching VMA
> +	 * If it's not a compound folio, see if we have a matching VMA

Nit.  I think "a large folio" rather than "a compound folio" is more consistent
and easier to read/understand.  No strong opinion, though.

>  	 * region. This test is intentionally done in reverse order,
>  	 * so if there's no VMA, we still fall through and hand back
> -	 * PAGE_SIZE for 0-order pages.
> +	 * PAGE_SIZE for 0-order folios.
>  	 */
> -	if (!PageCompound(page)) {
> +	if (!folio_test_large(folio)) {
>  		struct vm_area_struct *vma;
>  
>  		vma = find_vma(current->mm, (unsigned long)objp);
> @@ -100,7 +100,7 @@ unsigned int kobjsize(const void *objp)
>  	 * The ksize() function is only guaranteed to work for pointers
>  	 * returned by kmalloc(). So handle arbitrary pointers here.
>  	 */
> -	return page_size(page);
> +	return folio_size(folio);
>  }
>  
>  void vfree(const void *addr)
> -- 
> 2.43.0


Thanks,
SJ

