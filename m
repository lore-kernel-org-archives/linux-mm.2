Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B88CCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740298E0052; Wed, 17 Sep 2025 12:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EFD78E0002; Wed, 17 Sep 2025 12:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DECD8E0052; Wed, 17 Sep 2025 12:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3268E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:14:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 889911405E3
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:14:37 +0000 (UTC)
X-FDA: 83899240194.16.2351C3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CDECA14000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:14:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BpucwN7v;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758125675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGl5c/CvBmpRNd2XSXrDHHz+AgO0uWyNQ7gcjS9bW9c=;
	b=oem88AfPKsAnabFlahkkx/RxvPbdcPs8Ip5fm0m5uZNtbkf0ZgExi7HJLNKWv98E2t+Ll5
	t8NeQUlW3UBZg7j/kfiXTL+lTwr/PNbuzX0IRVXvCtfzM1TgRoAQfL24ma/bkNFwirhU+T
	XyJw3rXm1joftZZqe5QE0sfjwWC5ZI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758125675; a=rsa-sha256;
	cv=none;
	b=e5Zoj8hccI1zdxbrzaakNiI3YiO2/Aiy7i4uKd304M3nGO4Y+kTQEN9TpA0U6a3TbvUiMb
	a23KDKMK+EHGYixUTVeI3XeOWhANeGoKPoW5itOls+cI4Loo/hFD4JwgnBZVjYKZpiK3EU
	Fjp+BW4hSYcRerb/C/6ynxn8vkBhKrc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BpucwN7v;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A061438B6;
	Wed, 17 Sep 2025 16:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D51DC4CEF7;
	Wed, 17 Sep 2025 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125674;
	bh=GCsBS5m7MCqJPnLz24lD//JDAj5Is8wBCI9hodf7iV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpucwN7vO4NcN9CHMFiJKpRclWRN3wAmHiNSLulXaIZyohOLl8TZBgHCLTmQABbG6
	 Ma8Uopca0ncu0I6m2dsSirzpRXXOEr9h71NP0f0beyJn4k5A7v5jEdnNK1GNwdmeOW
	 7clgDkP6pmjDqSWHd1lWw8y2LMktoVOwRG1ou2bjmjeZyr3qxZwwGiSs26Ias53Ja1
	 jCdXatFqFs+SfVpsQ2IrnbQjtRPQtwsC3V5asvuIDN+1KryCNoKP3sOvb9Zj/EXgZj
	 Difz98KyzAZK4Wn1+/OvAFchrvCvLGnnTp4VRwejZyu+qOODv86IWmiCV3Jkjyh85Y
	 6GVXsRtMSBslw==
From: SeongJae Park <sj@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
Date: Wed, 17 Sep 2025 09:14:32 -0700
Message-Id: <20250917161432.53960-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916160100.31545-2-ryncsn@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CDECA14000C
X-Stat-Signature: 9f7khme3tr8efw8wd3zn4npsx6uq3zxq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758125675-231973
X-HE-Meta: U2FsdGVkX1/UaXcrvsrb8A6tn+hGL+hlVLyyOQ57BZFW/9nTKPaOUWr+tZrZmYd5NWWBuzoMHuCi0R0sC/XS9fMZt2SAnHEBeoErTCUCVBokmXI4ovEN6NEFpkZ+93UkDld5nflb1komXzF05whsrkxFtl3Hb7kyxzanxLuBsPisydF+Jpzi7bTjqCF6h9vtS1v8LtUr1CRIozpbYsJ8OWSVHSgIaRsopKyUuUrnynarYDGDClBnLLTNd1zbFrpKVjBI9lpZhi/CXY5e7jmRhuL2ipyoOTTvoM0M/Cx5gHBq1f7VczV+JlXx19JImLODQRXLWUuBTP3xSiPwYfcj1G1fEqBXVTwOgDyA2NT9W4r23XFNaxBHASYf6sXlR/bYkXFT+rW+3ckfE3fLanP4DjkxdzGMU8AUj77/Wig8ALj75qtPcyS5MWK1vepVv8DYaoWmQYPhDRScdvtcQX0sPW+k5oz3JvBvjiT05na/pKLktF1gQ9AtXJkqS9pRUCxur6aE+0blqH6jIeY9UyVp1ScDLhVDPw9/dr9RmVgS4gD+EQc8iFkRi0d/WR04famWan0X/3vkXBwD9//JmVJ4xaNeosF+DiuAE/MNqM/e1xSIeEdQIbzshXnPrCu6uayFn2V4+GLbuTKH++m4Hh0Kik4qKsSFDEWs0/pvhet80S//Ft+hyKDW2XMe/r11SzJqcPfijLHr3XIMGpUJK+pJd2NQetlDNqADsCpr7lRUljtQtCw2p3pjWVm8olLVrvjhLA4VpVUh0aErpMl0LsusMJC5fAJdfq+mcs0YmBxBO8VALQQ4b1820u5E5xV6VqJSjcw4PjGZJJCRkJJNfKwZoqDrCqdN4CK/QnPe2jgZLIN0Bvu/fokiDE19ARlvzWB0LcGnzzUrgAONS2djevstFj2U723ewSq6eJe/i+bwFolzyQ5Rdzbgbh3llDnm+3EbMtzMSV0CjW/TjZQeAyB
 XDomKkD2
 4VzfwlXjFfVy+hpWu8z8zasmSBiwGnMs5zAz3RQC+Pvv7fsOqEaI6eUIOHOSan982iWRZHVYrKxQwqus13yaw+QdJMUMo5ZGemZhLdE6XRoD1TpIrrG6DFNWTNx/ZWv2B1RWBXuv81QrQDqfUlyes0Bb41EybAnd8U4hWOeB5DOwPoF/vQQ6cz14zEKaWGR6PNLEn24MV01Hp4n+T0ZvQnhobQmcf3iyLGUc+C9a9L4qpP+SiCUsGbK4OIvxNJYNvvT18FptyOFoBZLqnpo6OiAaeRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sep 2025 00:00:46 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> From: Chris Li <chrisl@kernel.org>
> 
> Swap table is the new swap cache.

Thank you very much for doing this great work!

> 
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  Documentation/mm/index.rst      |  1 +
>  Documentation/mm/swap-table.rst | 72 +++++++++++++++++++++++++++++++++
>  MAINTAINERS                     |  1 +
>  3 files changed, 74 insertions(+)
>  create mode 100644 Documentation/mm/swap-table.rst
> 
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index fb45acba16ac..828ad9b019b3 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -57,6 +57,7 @@ documentation, or deleted if it has served its purpose.
>     page_table_check
>     remap_file_pages
>     split_page_table_lock
> +   swap-table
>     transhuge
>     unevictable-lru
>     vmalloced-kernel-stacks

The above diff is adding this great document on 'Unsorted Documentation'
section.  Could we add the document on the main section?  I think swap.rst on
the main section could be a good place, and wondering what others think.


Thanks,
SJ

[...]

