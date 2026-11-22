Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E157606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ha6fN7S/
Received: by kanga.kvack.org (Postfix)
	id 29A3E6B05C4; Sun, 22 Nov 2026 10:46:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271EB6B05C5; Sun, 22 Nov 2026 10:46:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187FF6B05C6; Sun, 22 Nov 2026 10:46:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E70946B05C4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 650FC1A06DC
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:59 +0000 (UTC)
X-FDA: 85463180838.23.A84FA96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B6E0E180005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ha6fN7S/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362357;
	b=dsi+Y9Lo81UznC/j0SHt2VqViOxo6nkhIVqmIF4cm+NcfmmMabFeKCAITYlKz608CnvThi
	P+idWCfUgca7VFgeliBf1VKgQxjK9RORtAwfgyS4VLa8qed4c90loZiqIoOWLYyyV0kQEW
	mrDmdkLbDFf2XZpcvjp686Sv42PpYMQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qUTcdUqoqYYz/SsteL+pOmg3FB4zklLKIQLHT5osUo=;
	b=IK7JlkJvRyZSr/fkY5WwpHobVacww/ZIHFkGZvavbmUElJp9cdOLja8gAZnRZHelwzzyQN
	ind82UDT6aa/jKxV2f5IrUukDGWb/+N7HtY1WSIhmc32HHo/HWd2H2XtdMKFxARO4qoJVA
	F3Cx4FuZOtT3ofU7g61Rct9KDiieSXw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ha6fN7S/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1078145100;
	Sun, 22 Nov 2026 15:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DA51F000E6;
	Sun, 22 Nov 2026 15:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362356;
	bh=5qUTcdUqoqYYz/SsteL+pOmg3FB4zklLKIQLHT5osUo=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ha6fN7S/3BJr6XmbYQao28niAg/XvimgnMNeZc5BOUyZcblWR3JSYSvOcSXvU8aH3
	 8bPaEBBg2ITzfwQwnnzVRZP63We/Y6nLUgpQiquoL2uCteZwVOQvmWuN1vYZ0GRqyo
	 rYs5GvMLRRha6Cg3UjIIaXwRyZWDDn8B2EpLC9kvCc0R1HHfTTwNea1hwG75iwmCQn
	 5XNReQBmbluL7DxrMz1JNUmwQ+gJyeTEWVmXtmSZBD7DE/Wxq88y2vWFJAydraJJ2j
	 GDpBv57hfDsY61XD90tto98VlHj4xwp1ZUjyq+190zixNFL91P08nFAUWQ9/xQ56NL
	 SwyxkT7t9n+IA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 11/11] mm/mm_init: move pageblock migratetype init
 to memmap helpers
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120100856.16929-12-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-12-songmuchun@bytedance.com>
Date: Sun, 22 Nov 2026 17:45:01 +0200
Message-Id: <179536230139.3933282.1358905817325491581.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B6E0E180005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: iyjhmpruygxsj4rou5u4117zidhh3wqz
X-HE-Tag: 1795362357-2447
X-HE-Meta: U2FsdGVkX1+GMm6bVZSMoqRtoPA7V1o+u5jnvvax2OGxLSJG3hMfeWsmkwxaBZI41jmJ7z4eN1FFd7s3hg1KRQA5aemcbTneECLYag6uzAnJRp44JxjxOZtGEOub+/RxzgjE5mN0kt8MewBlldSlozkM/0Lw6pbVpWkYnVgzZPfkxZDXNqwh9xHh2ADl49HLq7EZURKEAtpkJF7Ieb2Nesz/FUCaJurzi2davDT4KFpIjAM1uYl8WrzuJ9628tgU/7nIidiMi8vZFSVq7t0EJ16o97oE71g4DojoSFGbnzW1HiOeVZWRWR8InmLhzR79/1q8255UcgxJX0JNyNojGVZGKK/10SAbsnv4WnnIVvmvwWpeZJMRUaA6VqSmST+eklwdJSFvK34Yy0rbhxpChIrDhGCvt6AOUsAe9+xhuRMaBwgbNoV3fmEOCTzfi1CjKRf4e8Ldt1zw9KBcZUCJSUtTFtKofmy7ooHPNgLbT29srYK/VLBligNyEE/2Mt8sTgbrz237aq8iHIRCs4sk2nNxRi6CdA++b3XR393Z26ymewd7fGNQnXxeBAfb+p0G4VyZDXZQe/NK8SPY3ZVtsHvDyRBNWekQILgSDWogg9ujDamTvn/cEX2GhnS5b3Bzm6RHSJry4tHb0oYy/j1CY2OuEAMwR5WRNsWJ0Lcynigqmom/xWed4gkLacbO3tDDKf6jEjAO1GusLdbvuDnh9Ys8AClXgng8ZYmC3Wrn4Dd5UirF6CTQCyhdX+pc7ma0tomFMkKFisktWF3+ZckeVQ9lX5HFXLFnUi9bRE15cynDWtnvcNo/tT1Ssqz3ij6RzbRGKjRfDGci4uNnLvjRUnQVFRxX38sas5GhAWOaOZybSH5lOUCgohocJTl67Qqi/aW/Xz5CmxHwbLlde4rLxB6opjho4RvnSfnh2cWjiQunxlSCuMDnSV4Z1FPkPPSNHh3GgxacfMgFp8VWbPn
 n9qOakc5
 tvgGTovElKQT2hDyL4IhhWTWQj2uAyAFK2GcmgBKXtzC03lc0tUulI10Xlbmov0cY4fZ+zKmFllzh3yFkCQAxKivLdnGVA+j8Tnkoin9awnWqC48VBHa/WX7ppFVZaIHLm9Dgq8WVdC7JtwJB+LtzSOePyQbL85tuvB0DTen21y56765m0IvtuFBKgQJDrJUX1X6PnSYtD6c09FsVGPcctPXVdfbKlyaqTNvfexblvI2B7zbC+dYOdVcQ3P/FdcJy4lqALb7YP9ogp9QtsllYLxvLwuDbk+IE2bBBOakCm7Rg68DaQFdm6YDVJ5gmgD5RwYtPIoL9zs8x+FLyzANgoK5gsJQH4C04YZevVNz+pwLo/5Fkd3Mke64sgFQj7SFYccQkPsAp4tW3keJ1bxFBZuJr8uGIu5kg3yZLVQ3GYcBGrs8H8U/XmsgL/psRGExjt20a0z9knIvTEdRuqcnjKUJL2xrM5oJwFqd08zc+R6JQxb4Ztid8kh549+6o5rpVS9DY+uoSVxuXqec2fa6FdgMLR0GYcDMhkfAT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 18:08:56 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> ZONE_DEVICE memmap initialization already initializes pageblock
> migratetype after all struct pages have been initialized, while hugetlb
> bootmem folios have their own duplicate bootmem-specific initialization.
> 
> Move the MIGRATE_MOVABLE pageblock initialization into the frozen memmap
> initialization helpers instead, so the ZONE_DEVICE and hugetlb bootmem
> paths can share the same initialization.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


