Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14EA9FA1FED
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 19:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255736B0088; Wed, 22 Apr 2026 15:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22CF76B008A; Wed, 22 Apr 2026 15:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143B56B008C; Wed, 22 Apr 2026 15:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02A586B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:47:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C25CC1786
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:47:13 +0000 (UTC)
X-FDA: 84687225546.08.7C951E8
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 98919100014
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:47:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BD4wv9WO;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776887231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGdOZjYFd//HiRQ+b4VwV4BRdopXfvmgy3UzEHyg/Zc=;
	b=qwulT7joinLfq7TNTXp6Hk5/NBzsJLYeVvQpCgjI52NbFO/JwlTV4AE0EClkG01OnTsaeI
	3avcMoY5N+W02MPSJB0rYAS2YOqfxS2HsbNIDj182vLq6qnx2yZ8H7+Uo48c1UeVPE2+vU
	+QzcGFBNBZCX7bob6NZaPSqi98oEnYk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BD4wv9WO;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776887231; a=rsa-sha256;
	cv=none;
	b=Vn6er3cEnTfIJ2ei2cH+BaYZGchJI8osrqVwM2LXNelB0D+m2yCbsbJ/NZXnmErubNNBxz
	tIdZz4v8sbyoVyo8uCpYC5xW+420NPGZ5YDTb3PYEOZj4kdiDlHeGjBkUxlMF+uh6LBNYd
	kqpO7IFTez3gLKewd3n2OnvXrDnIsHs=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-89fc4147f2eso65048376d6.3
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776887230; x=1777492030; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pGdOZjYFd//HiRQ+b4VwV4BRdopXfvmgy3UzEHyg/Zc=;
        b=BD4wv9WOkrQWR7W6WDE19Zj5T/0R+OILAeV8Z4EAQBz9hWYQcEZiRPtgyYwbBQUfmY
         1+HAGGBPWEbYW8C89FebvsfxRrqcaYhG5NfCmLubfb4qjegzAYKtpbZ6UYL1GCPcG9Ba
         vmtj14hc30eoGKNCJfi3jkI6FQfuPIs+5sGUKNtbzfT3Z4TLlL0+WTKAp86g7PdqnDbc
         WQSfuipcwNTfv6AMNEg+unHunCd40ym5FFplCBi1f7JmMnUMy4EDtYLFwxKiYSBsdJE0
         3sRTBTtC5ZieFLBCFe+O1Y7no0BbU+PidGs//hM7gj9BjJVftBYN7Y8Pum64sXh20XMM
         0ahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776887230; x=1777492030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pGdOZjYFd//HiRQ+b4VwV4BRdopXfvmgy3UzEHyg/Zc=;
        b=gX+/lgPms67GOeAtedODLElOlzuMaZb2xZx+BZkKQmn6AYfeJtIBpVchQGGmCqGmWz
         Y1pE0n1e8oZ4/L+lwAwcnjxYMHaCRCYKlVhr4oGX9p1C4beznW2Of1ambDw7IdRhETVs
         zM4ItoRQQyZ9Hy6J2rLxDz0amkdqAOsgdLvVO4/RtNoPOIAX7bHVoFli/mvgHKId8GgS
         9ZKgVEvZfAn5nyx31iSWLsNzqJOPGmhR3hR+e1uIyjrf0aqSQ4H550MsOo7NoZyvi9Lr
         GUm/Z6FxiqzcEs78y4gAcrcPtq6YtzgzgvUAqtLD65UzfJWXasL6cbmplzQlJl7IMR8F
         wvtA==
X-Forwarded-Encrypted: i=1; AFNElJ/lppI5bnnd6E/FN+urMKq0KrEPtpUWMWZBQQA4Hi+YtdtHYwTBEN4cnfF/Y2iAb3rq0Nwov5GwTw==@kvack.org
X-Gm-Message-State: AOJu0YzrMh6QLkVpoxZd9g2bnE9s99/ZlSwAC6D1Zop+gOF6t0eC4Q1h
	qs6GKAXcP/L7hi5Fcmw/vEuCeZWN8OBKkOZK6vk1JVR0D4tE0GxoLDI80tVVswrfc8w=
X-Gm-Gg: AeBDieu2laxnLH8RW8xDPZwGNclsveS5+4jx5A6KG9JeEc3AwITur9RFQhzWxQAfHHl
	1ZFX1EmULjdJU+8mqoVdcrHmFNv+T4Tk1nDvu8dBCt5VzYUAerW+AnQNqbT3002YNF0hSguU1Sy
	+KlPHGblNkfroNgQan3hGPSeANKzfgNJLzSoEcOTDauJ2hDtd+wI82ROcj+LY4ugHSW1j487CWb
	BUSGlz0iKv231YaD60SLu1BslDaLAtP1H8ZpuZDNKT5zepOJHwgOOiDNiaKnjFSnG/ICpe8Q+8s
	P2mHcgIG8b6R8zVOqQByigT8DAMzHqKL05775Ndz+mL2vfFZH/taa0zCTlH1JQXk2QtGHM/BzuV
	nnBR8mnS/JZA5pcEKSuedQfNBySQjKFdZcM6DrSHbpuY/5TUK3hq0SihNT5X32xLqVXp83nX9wI
	qCn4etoalwYAqxBjPuDgMy3/j/yOzIAylBR9T5kAJ5xM7vHA/pl+oLGGO/HKdekfNqx75SRD5gt
	bl0k/tts3g/T6Fa6b+Z
X-Received: by 2002:a05:6214:5e08:b0:89c:6a86:e632 with SMTP id 6a1803df08f44-8b028061bf0mr329097316d6.18.1776887230490;
        Wed, 22 Apr 2026 12:47:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-246-228-50.washdc.fios.verizon.net. [71.246.228.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aec3a3bsm138295346d6.49.2026.04.22.12.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 12:47:09 -0700 (PDT)
Date: Wed, 22 Apr 2026 15:47:07 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
X-Stat-Signature: rg5rkgx6ebr1qrt4tn4mmsaptt6txi9z
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98919100014
X-HE-Tag: 1776887231-410967
X-HE-Meta: U2FsdGVkX18PVc3/ZyI5OmQNxQgkR7Ylo1Y+qvYb34kjufDCLgyg52Z7lYqmhYLmrV3Z/Kv4/Xn5jKW40rqvacRcUfa/g/T3NKpDO2X22YLJs0vvblxR6uM7tyWfS/sZz6RrpS4Owq5+6gZqXRCcSso/ucMYOORWGz/3B6INicakJRMJAGuBqy4BX/7KO0QIhnAy/VLrAPCe7SJ9eVueTASogyjtl51UecupPBK850YEKOUkQ7KKyDHb3KePVziaXIzFUCkCa34LaGNkqpfteDILmeJ9DKyawjOTtOlgq+7VCNq/WG2wFEX9lGSTjjbsYk9xMBSygwGi93IpAEByepVDCxeKpReG6f71fHtHFecKqBG5fO0X70oVoqRIOmq//6M0gyEjLxZwunIFyDJmn2RSbBX0jxjvFsmqBZjuJG+IQeDYL/sRZzNfZaaTWGvt8MhmuWH5JnsiqamRcCRDbu4vEjh7CJupALm2u8p4Y4fLjMtK61uVzB8NLRvuh+kgdgH6HkoXaXGdiJMtE7kCYKGPsTJ5CwvDpN4DW9sx+adc5gL9bh7Xt+Re8qWACgUYmWfoL/+NdEznJtrpjZz1cIminsTwusipDSG0cWBZtseY/IUpS1J5vLbxP+iW6PYrLatuzqEOVtSPc9zvcFnZidp64BPa1VRTu2TUC5U0Np1GLXSCZQWNyPIFEDuKqyKyti41srYN7MNSdoD0bq+efe5wuhCMVqTq44HTh6bIJqgS9K/RUQWs/LF9LCl3jUjO+0qmQrS1ZL+POk4+V2T2F8IAeDoBuW/DCo3VOo0Ubfb+Z24RCV8DUStrB/Q1pe3YbsBhhWAQQKwLf64PcPxC9iyIqmTVr8/wPar3TiCaRzvIoJrBB1IrcYwdGiTjhgV95vaSizGnyf4eFKnF0SHxm9j6gZLvnu2tdr9mJE8aLevqptL8Wke64fA67u1WsskZTnF4jTMecOQz9HgMO9X
 7aEW5a/p
 fkF3NREhhueCWg127SiDMkqJzc/yDsM9OtOO2KgwXQktK58aBOACQ8FVnUqhZOW+YH3QsfT8iO/91lekeXfcNWN6iR+0zbwdAIguoHuDC3lcaj9TWYqBcOs4MJrhRJZSyd//1hd3xaaPF0jTSwUSEPcPgjp4qD9ivISV4V4SRqKjtT0HP5lW5FQPO4QMWg8uIqDidJYtGK5Kw9nCLvHT5WuZz2sr3q5QxJf5pR/fkmafxPYnJI9oSYTVl2kpm/sz2FWWHcmB/ylIXX1cYjKZAT2oWwe+Tzz7cDtyb9T0nQ4TTmNX2pBn51bwINbUmNe5DhZRw+4zh4fVjgQNYhN3fYH7VhVxIgk0iebEacFUeXz1ecjM/i8BdWTAzSMn+1Fv8FGFtL+bjPwU8G4phpPmy0vn0xijmFs+ZymzOcue1w7mTkdoZ1ojGb9iBLuZsLmxueZPA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 06:01:10PM -0400, Michael S. Tsirkin wrote:
> Thread a user virtual address from vma_alloc_folio() down through
> the page allocator to post_alloc_hook().  This is plumbing preparation
> for a subsequent patch that will use user_addr to call folio_zero_user()
> for cache-friendly zeroing of user pages.
> 
> The user_addr is stored in struct alloc_context and flows through:
>   vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
>   __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
>   post_alloc_hook
> 
> Public APIs (__alloc_pages, __folio_alloc, folio_alloc_mpol) gain a
> user_addr parameter directly.  Callers that do not need user_addr
> pass USER_ADDR_NONE ((unsigned long)-1), since
> address 0 is a valid user mapping.
> 

Question: rather than churning the entirety of the existing interfaces,
is there a possibility of adding an explicit interface for this
interaction that amounts to:

__alloc_user_pages(..., gfp_t gfp, user_addr)
{
    BUG_ON(!(gfp & __GFP_ZERO));

    /* post_alloc_hook implements the already-zeroed skip */
    page = alloc_page(..., gfp, ...); /* existing interface */

    /* Do the cacheline stuff here instead of in the core */
    cacheline_nonsense(page, user_addr);

    return page; /* user doesn't need to do explicit zeroing */
}

Then rather than leaking information out of the buddy, we just need to
get the zeroed information *into* the buddy.

the users that want zeroing but need the explicit user_addr step just
defer the zeroing to outside post_alloc_hook().

That's just my immediate gut reaction to all this churn on the existing
interfaces.

Existing users can continue using the buddy as-is, and enlightened users
can optimize for this specific kind of __GFP_ZERO interaction.

~Gregory

