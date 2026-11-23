Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8FA606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mkURuO/o
Received: by kanga.kvack.org (Postfix)
	id 8ED126B05C1; Mon, 23 Nov 2026 11:27:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5486B05C2; Mon, 23 Nov 2026 11:27:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B31C6B05C3; Mon, 23 Nov 2026 11:27:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A47A6B05C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:27:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB1F9A809A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:27:21 +0000 (UTC)
X-FDA: 85466913882.05.1542785
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 35A23140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:27:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mkURuO/o";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451240;
	b=g84/LDwXcRCaNXCISXdtmKc2VKGzf6v9UZxj+Kb10hE7EmVnoBq+s22S6ce3xkE31yvCpi
	niOaLwzkJlw7GWh5XBviOV9d52GC9zTA/OumXyYo280DpqYaJd5qeqJyZ4VQ00gbRF7SDA
	LCvTpaK5FKYrbyOsDJTfdnn0ZffG+Is=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvM3jUunlZEyJZhci9V5BaFyjvhFVzYl/wg6Ouo9vg8=;
	b=14KWqy1J8opSMs3CwpYoTo6xO+9rVj/hAwWHG5Yrfxqe70Ntk592leacDW0eF/e7anfh51
	7pi2Xt3bCYXtFgbqTF8ruU9qB8CUF0A0VTC/t/vlBfUYQWv/kOxE6ZTSuJNLJ2oW0R4FMB
	6Z1PSkUYPgwSHy27mjriizUhkBEAP2A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mkURuO/o";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58FE74040D;
	Mon, 23 Nov 2026 16:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35771F000C6;
	Mon, 23 Nov 2026 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795451238;
	bh=OvM3jUunlZEyJZhci9V5BaFyjvhFVzYl/wg6Ouo9vg8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mkURuO/oPrFCChNLUmQvKUWYsxvB39BRI6HI+jVHtvQd7tCureqiVGFDLVeTTL/qL
	 atY09NVWYFLdr0zq+pCEFwIZEf5CxOyGFvxFmkNIEq09wt3nIW1o/dUbHIHX5l2ta5
	 009lvaywxEeDbUkth9tPVVu9vdvp+QcIvhLfLYx0fMSTt3I9jZL+R1P6ipIMqTotKz
	 opmvGfyI0qJf3pophh/jR8GQEr0QbxZBHgaWtPKwrcqZEAi6RrkJExbgoe7do6XuI0
	 ZMW5bi/gR1cV4xbmwJRhqJOT2PoWQP0AG/pW2svT0QtXlPonZ0gCqLQdlZoP0oR45d
	 5yET9izTjpg3w==
Message-ID: <7c9ad493-d9be-4606-9f7e-8154aca1c45e@kernel.org>
Date: Mon, 23 Nov 2026 17:27:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: fix deadlock on the folio lock due to inode
 eviction
To: Chris Down <chris@chrisdown.name>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
 <awPUxY7eDWuo_5qP@chrisdown.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <awPUxY7eDWuo_5qP@chrisdown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tfm99fd7nqipidiyruqjrd5g1gymqht1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35A23140003
X-Rspam-User:
X-HE-Tag: 1795451240-350413
X-HE-Meta: U2FsdGVkX19830uhyPPuaTMexPbJtjUDrp7oHqAMjPhg0S+zyNDBEZ5hYmmO9mqP9KsFQRYz9e8K4nI964lR47ln+qCiHMqM0hASP9IyuyIqIPabgMZDmyy+0B4YIEN8x/Kq9U8P7fphhDI6ImJ9+YCkS0ugxtYh3drQVuyW1Weru6Pxx+Mi/1mmCwIlrERMF+7dFbRnAzRyl/rUfRn+pa5InLX1NWgvunU8ftYoXpmvUurrOrpal4S/UTXu8PYFIHKyTqaK9ijfhweA8j4b9Yk5yJRaWclfqsEyiALMfHHU35eaym4hj8Dsua0Y/mwhRfLJC/rH5OsuwS9TX+ARpJ10+J/IUOiX+3e0NlSe2QBwlcN6TIyoB6iqm9FF78dC6zMHaQwhW2j6ZeFhYWI/4qQ73YSaI0oX0PllqP2BMoyrEtOgp7gplKtNxb7z4NEUyI9Y4z7RxNORsrBOPPx1WCBPshFr6/umXBO4lAFBVB2jUSdKK+WCvxJU9WGxRxDaocoUsbJKqQZR01mOuVwl1HrlRYxTlf3CKIPrU7HsXqR2n0eL9c0qiJZN+KNrc1ZSI7Raotv9SCfT/0ZKgeP8oRBCRoPaTx71JMe60L5F6iXbs/0YI6NeYQx1aiWsr6Z38kl7uz3H0nNRDuP1tcJfDBDCvzIl7UPYE19BdGe2xAU+gTOo/tbqleNn6FbXvTRINF7z+v1Vi89QuFTfDGIviI2ueD/sSk9/z4OyWkCDtwZ5bfYO++1a/ey6Qj/fV67x34snhkDINPAGyWBpn+KZXqXxdFa/UV/uc8lXdfNUT6hjxLz3PvFkZoEjR2AVBe4DdmTVzqzqrOQx9LG+kOl/hc1QlX4R6dvdz7/usaMhkKGh3anX6MNXeLzDdQJ3pyf4Dh2nvuTxJZwXmEF6wJqxjQztpj1H3QSnFfQUuI8QjdXQV++3ZjLNV0SVkOuA/uD11sOXlWW4bupjgAozVqp
 yDJgl8nA
 3oq/Iare4KUtcyBbl8NAn3U4t/ieOLALYhgvIfwZUXNNXL7SC6xRKxhwDQ9GboyHwqpXZzeHXeac6eW12injhoV5pV/q2C5AH/JiDRNUhDZ/vq0XcVGHkWvR36AHFVpoxBd33oDQmBgbukeIevIhn7Bxwhq0KzQwrshIpgSyzXcRELEJ2zRUzRdY9mURJ8FYu8RluJlE8AvBDI18s0YN9tgIt8Ua7cVPfSmHQESs+3K2dZrb9bOBx3ABWD8OsGbhe+tOt7gJTC+aCbWXMPzuDLn3VqHZ4BNxxweE9AhFo/dz9eso9jpHNafjPTNar/HKtBSvjMmFjS4OB4WID9D7BqlWwZ8NpgfhgbnIAYVhlgeuaMshYlnseRSvD6NDVLuuAImVE3q9xDJ6CYan7a6upSb/r0+BNIfZ6xE4l5kWKV8MfsZnGUruLPFZDwUCuwMue2LGENEGJbAP+7bbS63Zo9x/pmbyvAS1lWou88q/kUVdw+HbsBWI/LVqqR7WPkb6QpJZyqejjXGIYu5EYClN6NAtU8QDd7PWB3pLaXPWwX5NsD3IUZ+JNkJZ0MZ7DJEd2CWGW8J2vJ+XTmY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 06:53, Chris Down wrote:
> Hi David,
> 
> Thanks, this looks good. I exercised that in a VM:
> 
> - with the series applied, migrate_pages() on a virtiofs file mapping
>    no longer allocates destination folios while it holds folios from
>    the batch locked
> - splitting a file THP no longer passes __GFP_FS to the XArray node
>    allocations
> - and the migration and split_huge_page selftests still pass
> 
> That said, I didn't manage to practically trigger the deadlock with a
> virtiofs mbind() migration racing an unmap before this patch. It might
> just be that I am unlucky though, and the code looks correct.
> 
> Given that for the whole series:
> 
> Reviewed-by: Chris Down <chris@chrisdown.name>

Thanks everyone for the very fast review!

-- 
Cheers,

David

