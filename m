Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C394B606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l6B0GB2g
Received: by kanga.kvack.org (Postfix)
	id 9B61E6B0683; Tue, 27 Oct 2026 06:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98DE06B0685; Tue, 27 Oct 2026 06:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8575C6B0686; Tue, 27 Oct 2026 06:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9436B0683
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:12:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C60D0A09F2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:12:54 +0000 (UTC)
X-FDA: 85367992668.16.2106E5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED31AC0008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:12:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l6B0GB2g;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793095973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avPXzVQ8Sv0mXM7J/XwGviolaYaj4EwFoFF2wFHiFRc=;
	b=5cJW98oVxB7C+suBVA2LsG3z1TiGzpgjkczpnzCJGdVN787MmTFy/m3j25gqwhfOd6Hrdy
	JpWCZ4PEKMDlW1Gs90AMtdMtxHb2pISTmdpPY1bbXL2AeqQCc+hxnLEodMwqWSsAT3LD0o
	auu3l+Y55CB+mdYW6Tc3J9MzZSQ++/o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l6B0GB2g;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793095973;
	b=ArReyCeGzqQ9edPA2QAMkWm4WaG4UwFytapYpje+GqVk/RVdvp3g4eblchqoYspKts6f9E
	0KdzbW1nIzpA2vG4NuVW7I7ZEQ/blL4LYKkI7fF9LfkB9o+vG8a/B09GShxAz8GrIQshZd
	RrgsoWAQL5CvhSosQZJQlrMdM2tlBWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C83C541A6C;
	Tue, 27 Oct 2026 10:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E1F1F01825;
	Tue, 27 Oct 2026 10:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793095971;
	bh=avPXzVQ8Sv0mXM7J/XwGviolaYaj4EwFoFF2wFHiFRc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l6B0GB2gMZJVQmNXNyQkUTQFmNTG2L2sQw3JH51LnfGHfk0fJfp3u4KIliry77RnZ
	 6L+8rWFBuuEVcqScZ7japagye2r1+3xE0a1ye4Ol8oMN23ZPF/qY9JSgk1v87ZEyzg
	 kEiydfIYYjt4VqQMx+sfNpVQQTCPwtyG3d8Qvcgv3SIWHolvnk0ueBypnzvxVbIUu2
	 sznCxrFJgr6x/fSx8xoS+PgycQUZBWjWGt2uOavqMlynIBKud5h5fv1Lby22tmDbYJ
	 HSC3WppnUj0RPFr256eeusjYKlZ3x4wE2zCkjnZ1AT0pmPNpUwFDzaj+XAyAW3VNsZ
	 Ao39ZbOCXwI6A==
Message-ID: <3022ba03-54c6-499d-b07a-2ca8d033a56d@kernel.org>
Date: Tue, 27 Oct 2026 10:34:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] mm/shmem: various (urgent?) fixes
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <at-yaxmjeOXtA15M@gourry-fedora-PF4VCD3F>
 <5d10eba8-11cb-4031-84e1-a394ca5b4cba@kernel.org>
 <179304984259.319828.7383468637599462048.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179304984259.319828.7383468637599462048.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED31AC0008
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: mg945nka91onypk9xoufbgduidq5it81
X-HE-Tag: 1793095972-509250
X-HE-Meta: U2FsdGVkX18CgGTwYC60krcvc9Q5uvEv5FXO5xb4KhmnBgdYUqNMZnrKJrUrTBcpxMezomCzabHhxHg3jh9vt4VFXr7DUB2HQ8FRcimJ1ETcq/5N/+bJhw4V+6PnlZsFMU4huf/Is20zI0BXeWHQ1kggIBaqwZ77VnzWBQKx7bOYyQEbhL2OvSXoLdz790ROwMFuEobyPcX2bVN6TrZIJQ6EamWfyB17ufXLxpzQPi6sSkznKkPPQ9DBclPSxbYK3IEMDHQZ59yhbl8duG9Y31koKnbbPjAHvPNPS3hITaStFlUHnftc0+uyKBg9/jvXEvdBRPPmXPHi+8jozv1HmUdS+myjR98mIh1RQypA1nPMk3h23qBaWUxT6aQQCsp/BctQZ7IVs+lv3LCKXGeHdvrboJjMAL/RKFcprUtsDtPLH1kWcUj8QBA/MLUMGNpz+Wm3+VCaCzfGjMuTYcZBd1YoRPztxy5AaJS5TFSd/EwUIinDwoCHi48FwyCR2PkdOkwRYGW8bFjHr7EfGjjP97y1YweduSe/tpI0tEuRgq4rGn2aK6jWlpKCQYsAjeBxdXVIwEHNwnv1iYvNnXmc5dQpBR7bRzbbL+PubtNnPufjWHJk4wKworOqmP/9bK3wASSww7fTbHqeKErSuFFO4LpB2kQBrluM8SW/hwiomMfix4YYzcKj3koBg1W74vYsEmzGvd4d6cZlC5Ocj/dOy8rd2dlboJt+CHr+Xm9hO7w4kZwcsygVHiA81XnWu/rsWgyhSDaDUlwao/Wl9CsgWB+mxRJQqKK4xK53MdEr1t4kvTsW1SXIGNPGxNuAAXdvv/k0JuSNG6bhMFbz0LVzwS4BxkQjqaqMOFwmx8ov3RRct3hweypTWZfUNGXD+fCktC82GqoVWX+Z6WhenNDC4gFATDCmZ0becfq/GoCFkbq6/285Dr6qb3+Y8ddSxLzSI98cEN9jVMVs7PljSo+
 BS05JzSb
 7/j+r8JkPj27NxNUFodQ7V0HsNUko5z/CdkQaWU3xQVcQ0I7NVeHIEVDTMCG9sAN9+WU/3BiDI7kVSe5ztMb2Enb8GaTvDWH0GWldrPFXNbw+ufmwSVUg35RG8XCXlEIWkp3D/+SYhluagbMYfouy1tlI5VgXgA6w1ny95PIorLDSljmiB+bGwWnjvnGZV3PdHLvF58/bDaMXHlvRBSbAfSleasLYljXnozbU/IYXTHXwn9MszYaTYsFuXUENppn2eddo+A+QBoi9hsMH1QMBpCZQnukGJAQWxqgqprWaAqzB3hA7EZmVwGWN46Dnd4kildKDIuINliYvADHfQlBA7SJI1ngX8kkxOC8eRv+Va3e80mmwDtxUeYVUMODZH7sy5MOK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 22:24, Gregory Price (Meta) wrote:
> On 2026-10-26 22:09 +0100, David Hildenbrand (Arm) wrote:
>> On 10/26/26 21:08, Gregory Price wrote:
>>>
>>> feel free to take or leave the selftests.
>>
>> Thanks, no time to polish selftest ;)
>>
> 
> It's there to show the work more than to merge, but the long-term goal
> here is to feed these tests into a larger session that does the polish.

Agreed. But a note that if these essentially contain reproducers that can cause
harm on real systems, posting them upstream might not be a very good idea until
fixed.

Well, unless people can trivially generate them already.

-- 
Cheers,

David

