Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49162C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19266B0088; Thu, 27 Aug 2026 10:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9976B008C; Thu, 27 Aug 2026 10:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C950A6B0095; Thu, 27 Aug 2026 10:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 959906B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:58:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08C06120260
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:58:23 +0000 (UTC)
X-FDA: 85147355286.28.0FD14CE
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf25.hostedemail.com (Postfix) with ESMTP id 18F9FA0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:58:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k wRWFxP";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HRh8b7GR;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787842701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZZ93FItI8JMFjwX7flkmn3kmtJ4ez+8sQ/nTIMgQBQ=;
	b=1n059sbnWIzhYHJpqJ3E8vDpysN51ZR9XnopHyAJ7WmINyj9LdFH/72UHVX6X5GKflnxzo
	YZzsIJ4JTAaoy+c4xKYopslDUAwZv14SKeOApIwMqjJeTzkr8YoWK9ijhBk2Kf7/CKfQWZ
	3zF7FZfVKD7zmaA6dZtEtFpf6JUno0o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k wRWFxP";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=HRh8b7GR;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787842701;
	b=J98NQEwidO91/qynAi6aR8AsYwY8jClRVllnHSnlCj2V7AUfRh1LkhRKq9l/Y4JUvAH/r7
	mSaeNKEVjY42YDhmid5qLpp0MGCmZG6LY+jcZDPlQLuydoG7jOJTU1vyojBFh8eUM6fksb
	MGsoQhVqCamLAp6fSi9ZUe9A5/r6mgU=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 7BF531380214;
	Thu, 27 Aug 2026 10:58:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 27 Aug 2026 10:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787842700; x=
	1787849900; bh=CZZ93FItI8JMFjwX7flkmn3kmtJ4ez+8sQ/nTIMgQBQ=; b=k
	wRWFxPChA/+9q+HXIqhe4ILwZV2YnpovrcH33nZrbiiMbQv1Fb+Vnsi/lA2l5bSA
	xGihqJFSM+OwSgMYJVfjxXYCrksDRFTu5rOsa0XTxp567gZ23vBrGn51zfXyTGTc
	LFBbkqCw0uaAQAkdY/KjMbfFBQqzNJw4IfOvhvWV+rPv5e+uWb7xOEURMNFWR3Ac
	MPn9RkUTT6q7Oim6HiVL5x08Edh6IFC/IKsi8H0SP/rlRkc+GhJ0vP9dOaN8fVGU
	MTz9FzosWpNr8iPWDVXbmhod78y68G/YIZXM5s2H8uKfZc83l0qruPm5fhiope58
	OMRGp7Kdkkq2E2BQNreKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787842700; x=1787849900; bh=CZZ93FItI8JMFjwX7flkmn3kmtJ4ez+8sQ/
	nTIMgQBQ=; b=HRh8b7GRH1oVgBmOfpccKrPL4lzHiPSwPGvF15i6Zk/kFma2Rj0
	1KYJBxiBW1zwVpIKsjfKiQmFaYmTe4eCk5G6YxZYQDmZ1IWj/4aoD8V5sLRFw9VO
	V2J875dwPmZ9NB5qmpcFeQFd7WjvDCj+hyvIkNXJH9qCKA4LS3+jdCyiPc0yfmOt
	9uxsNpe2sjsyR5BW031SMj8xs2PSZ9LHjJrOTiXfIFYZCJ8Nk1y+m20vdi5WYVjJ
	8fArNzR5ibVBACypZmPUJBnEtLv5GyyJCSLdya1h5nCrmluvqaHw5D7Jg4q+2o2i
	L7zRfxvncrbbXu/b3Th2M+LipExr4E7lnNQ==
X-ME-Sender: <xms:i1CQagHyJ0lwB2kqPyRyW2BYpU9wl7uTP81o2juYRSsER3KImi2aBg>
    <xme:i1CQanwBzFJFmYZ_x3r8WuA3n_V5vrQVA3yfopp7LpzTo0R05lSA4jHifIenK8fHt
    LnazRcIDtxmPDNTGokkbnRGzktQHp5LlPlOKT0qErxtQukkkp8RzBI>
X-ME-Received: <xmr:i1CQahSR7m8G-qZG30T61Iv8QvfBPRX5puQ6op5WJnXhOif80VIqToSjikI>
X-ME-Proxy-Cause: dmFkZTE2YGGlRLn8o8CpHCnnIZ36wcEkXQe2Zjt8vFyB0bm/6DdRWdjZgbt61ucV3J13VS
    VBz7jEGs3zGW3cd925nfXGhllcdmwWbs8OS7LzZPwF9aCj7PiYtuU2lbI3gWb2EEkcuO36
    iBb2WiHb0wSh/94oaiLLIOYIrhAHpNzqYHK5aAs02VkOKvVSNBLejFtl8+O0/TudfepxNA
    hla3yKqiRsIxTgZ9VU+t0AfjLb3BTnimv8pVLf6zyDT1EwCn540egbr7DcqcQ8wAzCLyCI
    S4wSXwx9Sr39euN967/gs3pN7QBLtYZMoBkD0zKPKKzvBx8Ue3bz9HZmsFLc31PX0PD0IX
    iI1A1/Y6oRDRCc1/W7I3g8DCnrfc5ZKjvCDzBoVr9yr8vHTChO/+chuA3eGn457/5B/JGi
    KJ8tXmHSiqEbDrMEY75S50FZ2uWuzu7mSQuEJhea7I4OJdFWQmuuGSQb574XLRvq0KkW6p
    MjBuX2Tq2UABEWaiZLUB/uXwHbxCCmTZprHWVdM5Bq3sRhp3ap6/hXM+VLfCf3KHH6jWVb
    0ZL0yj+LgtaLv0I7aRd9DNn59Oi0Kag7HySLWszn4fNXbuxluVTZLb7E3d2ZXuRTZS6G9g
    tJOA3TYqfUhC9XalRHOJZpRgNpXEplDVeJla67NoyYSqftq1bKSWBfBHskvA
X-ME-Proxy: <xmx:i1CQalpylsfbtaEyTdhXSZn_ds3otriGSfgqgu6f56nlfdkdrxFg7Q>
    <xmx:i1CQapuop743oa6li2OV9TsENEu-IKFvBgfc7gn_Z7ulkkJm_qgiPQ>
    <xmx:i1CQaivBY3IlTxWkhzT5KRi0jfnDxpQh-V_1agwEo2cgnfFy4TGR_Q>
    <xmx:i1CQalqU2CupyrkpQvw8sQ0Z_yR9SFiZig1ox4inh-Z_50AuQeZPog>
    <xmx:jFCQaj-27eYq4kc0_VDKfCjwNfh9YXV3D2BjOisJWW6D1UoQRcnxI6A5>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 10:58:18 -0400 (EDT)
Date: Thu, 27 Aug 2026 15:58:17 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 04/18] mm/huge_memory: split the routine for splitting
 anon and file folio
Message-ID: <apBPFRdRdJqODHzQ@thinkstation>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-4-9b43f5163238@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-swap-thp-cleanup-v3-4-9b43f5163238@tencent.com>
X-Stat-Signature: 3swbkwqzrhdr64j3byanteta48shr1zn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18F9FA0009
X-Rspam-User: 
X-HE-Tag: 1787842700-990253
X-HE-Meta: U2FsdGVkX1+W/DYcZcF+POd25mQx8UHASLIEN9uAV9lsqbGoYeHmM4+Dy96ijCmRPiXi4CuABzwiKSiZSO6rodYzlxibtisZtZPblaB2pyFcvU00rb2m7mvdGaStvxu8+x33jPvnmLlRkvXDT9/Htk8j698UBEYeYfiqbajnz8+OpNsso4fwko5H2aUiFVE1qd1T5d5yf9qANI+5oyp6+HqBY1a+GEc9etQfXyT42U9TeilABvQ3zOtJbn5KHXX7JGlaF+0yLpv5DUIHbIK44q7yzxT0jEvHJjlkuf44pL6v5kLjCr5G/Ehm4XbCiW3ZXVB3ByqKwwsOcru3qLjp/XuelSF5TbF0WIzkjC0DUROtvmD+T4w2OnZz6FhKlcQugbDvqGBO56PJsw5ZVDMFoo+X1WUz0p8zSFfQQkd7Cc7aBmahyZ2BWbVXueYUj68/m+XwRva2FLfTMShV56vUkT/ZcJ2tTEFYjxHDdAF03yC6hp758spP8BiJJ3U2UczxY5LWEm/NMr9AFhPWjAcxCYo4uLHJl5l2Zs4b0eG60CGbEToY7NdS4BJ5YhEcrpG7j/KjeSPNFvVcB2PQ94bhW0UuRuMAsZ9hka6LUZxiqRiP8eFDzG27T3wa0Ko0/IGRFXvgWeCltFLuelm1M5ZOmfzMHkUJQw9D+rYu/vUoBIaBTWfnhm1kIGDDZmAikP5xzfVOlk+YlNScVss+/tgbm4zAvPnCJ0g5uTnDXotr+bX9SUNoh6VgdFUI4qDFsUFapZddEbx9kVyNjV1j5uAq8GWyudwBL2GTUNSdoKAD2imVNgoCiTZPP1EIbY6kGOiruKSodU57msc8+RVaPNdQOs0pOC7XjMnr+vejSxl9x2PeojPuQY7kINJQIIVSWBMHVWtM+gc4Ox3wVK8D5wkbf38BRqEOCbAk4oc8igkwfeG+UiSRhSPEWZcqDufVbbQgOJ71r6FV1k1HKKUOfaD
 aOdNNSvC
 mPwUcBDzaCvFDBLOMjEfEx/cX8uLKBVjVvgoltb5JpD7Bn7jyCMSUhpp7KU0RYpyTqcg5rvHeADrEPYm86zP+dhY8ee9J7k95OEfj3HABC+PgiNDDL+p9o2QqH7LiPNlBf/thC2PCNMGiA+5XWvcMRGe8leq81icdxOKwoomLnUVIqmzOFFRwR+CRiAalyRpMPQ6R41tUVDxhLIg5ieWjCFFdSCFteoDIQ8KvZivqVTAPyteHh7TApkAGL+cRLXijcckTbn05/zxW35DNK05IfvQIeoe/U5RMiKbjuAg8aYUQnACKYUQAOEEWZTL4JsaFanXiGX+0HpPYeiM0SjE5ZqnTExPXM8rrr8T88g197InDn08Qtd32kS3lVYzmsFPlo+vuTic85H7w46Xbe83pgsRRyF/C9V6VR+BG2G5BwdAsG/zlIK2NnDMVd/zQmpNSSdNh+ILy+CvIbaF6FoGYxSpWATua2g0Eb0HeO9xxXKeEty4gblJVhXmKdNhAE38SMWGJz47PbbSiN2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 02:55:17AM +0800, Kairui Song via B4 Relay wrote:
> @@ -4064,7 +4095,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  		folio_put_refs(new_folio, nr_pages);
>  	}
>  
> -	zone_device_private_split_cb(folio, NULL);
>  	/*
>  	 * Unfreeze @folio only after all page cache entries, which
>  	 * used to point to it, have been updated with new folios.

This gave me a pause.

I don't know much about the zone device private thing and I had to dig
to check if such folios are always anon. They are. But it is not obvious
to me why this limitation could not be lifted tomorrow. Nothing in "not
directly addressable by the CPU" implies anon-only.

I would appreciate some explanation in the commit message and maybe
VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio) in the file
path to flag surprises.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

