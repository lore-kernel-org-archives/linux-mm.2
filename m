Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6888E606A335
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knANyb0T
Received: by kanga.kvack.org (Postfix)
	id 6904B6B05BA; Sun, 22 Nov 2026 10:45:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6682E6B05BB; Sun, 22 Nov 2026 10:45:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4E66B05BC; Sun, 22 Nov 2026 10:45:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 375B86B05BA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9315C1C3FBD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:18 +0000 (UTC)
X-FDA: 85463179116.30.C258DA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id D6DFC20009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=knANyb0T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362317;
	b=dK9LLAg1aMyrQ8hNtJJR5YLph4dw3JmngzX8rb/uwf40m6TJCSr7aWyfbvpQZIQMWwa26Y
	/daZbY01ict+S1CbsakucPvqYtD9RDpYLvEwriFwsR42OghuPs/3jV519cwLQ/dv3rF2kf
	V+/v3VuyKrZMhmEchFUOnMgN3NIBlMY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFZH0AZyXfU9b1MVkZv6qUaABnlF4rXr9gf9ekczrx4=;
	b=XqlyvmVStILBSXDubgNKPn4HZyxojfXHKQxwr4twOdM4BXGREDIx7GUc7BQbg2clYT7w7K
	Hi1GRWBVYFgfj42zHmaov/AKjnH3EdIKswx1Buqso483QnwKRfyGiiB0gRJ3BMVdPYY8nU
	rhSKaeL+trYTZj21gLgk6Ssmteg0+Ns=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=knANyb0T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42A8C43273;
	Sun, 22 Nov 2026 15:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B401F000C4;
	Sun, 22 Nov 2026 15:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362315;
	bh=KFZH0AZyXfU9b1MVkZv6qUaABnlF4rXr9gf9ekczrx4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=knANyb0TG8HksC2vzIjoaZcR6GLrc4P/hYaBK6c00mYHbs1h8ZLgdtKvdlUWattto
	 AAp5APUZp0QJT4XobHoXoH0Or68apPKc2CwPG0/+kW6oiljIG4X4MYCi9kKup0PO2o
	 ifyNAnwMotnHyLsgYfHJQ3EJLEVAWbGdQ8oL7Tj8Y+sAo53Yv1bJ0EdJm1dioc3oNr
	 LIxWNoDiGDKNjTJ43tlqqrWl46/ZuoI+csB7sb5z/2hNEppMm1uVPRKJBMPxisAz5X
	 91RhKRjhVrsK7jZA/W2/76qLhuxK3ZvkUAClZp94kkSwrpGZLbqnUSK9VzvGpWPtCJ
	 UHhatCzKG67fQ==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 03/11] mm/mm_init: simplify zone device page
 initialization
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
In-Reply-To: <20261120100856.16929-4-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-4-songmuchun@bytedance.com>
Date: Sun, 22 Nov 2026 17:45:01 +0200
Message-Id: <179536230136.3933282.15537267556935821561.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 1dsfphqx9btgr5zf5zi6pqi9j8q1qkmw
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D6DFC20009
X-HE-Tag: 1795362316-132241
X-HE-Meta: U2FsdGVkX1+NsSfas+/GVnU24DEXtJ6HlixCF/r7vQyUzCi5PXVg10G04hidwfrYj6f50G6i5VcYoqVXUB6LKFCdnr18LpCRbm5XykDrUps2Mne6kVNdZq8s7Kt5Xh11aLufJJTfNPoCTIHb6WBwlwdIcxpX7sfioaQZXCFE5s0+SK66h7WfK19eP/SVoQOXZ4CoibiB4TzR++61W9Zm9Eu1XTHfhkl6nDaLnULEZh9PPYH3MH7KZ5pmLSTne3lmUrS1FJsLsd8t6F8aGkPWhvgvUE0aCu9q489+QXaZJv/MJ+M/4gvuHLHdrcLfASOc8k/ul6Pywlwv/ephk4iFb5OZ/vreI89L8Dkmn11Dy3K9A5dqAdPerWR7kWXhLcaGaB2J7RX/Q6DqAfGnY9PeY0GKBoRIVe1pTTc7EjdnVPjLqSzMl1XRlV2S/cKzTNi4mG4ueI5UBkQuME1Jq64ApUXdj9zMMYeSy/IDtHbqVRAAiJ5Ue29XT0C+t48s6tZTuTB5nrz3kW66wfGJCSGc40uBv7gFk2NXYuAuujb3kv4OPpcFGG/dVp0I5H+ZZm9gbZy1uZL/RWLgyQOuQfPGamUxTyRCZqz8q4EO7yJ/u4Gamj7k4VWpNDBnzg6EO0cR97VegXpR2HNkS16X8Gta/jpnJdpb/JrbygUl3JCYZ1qWqabzIU5/ryLmUh+Ic61i/srcJuZmD+qehPLhZjYnuI2szA+h+ULG3iIsFZNXBYNYz65ci0fPqjhdY+L6dvQd3UJqXCmFEV0iXW1hVKKEWFnMQFIBCwLDgR03vcFrNhzzY0jH+C2KIbkOn8B46zGkx1vnp8+3HQTVC0rzILM6zL7CcT5+4eIy+R4akAHJOnUarE3ezxrlsxhCMe8RkTLlDbyTjW1RrBhoZfbpk0+3A+etbaPavZCkfrDCzp6xvdWo1De8q737hS80Q+7ffzGdvJFt8cOVc+Gv2S8SYl6
 jQvqNf/U
 dANluOehIKjiiE+oe6LxwzrBe6XgMfi+isruKtxTTKpWsp0IBgYop6NdCP2q8zoa8JS4iMEo938EErI9EpWXWLuZbPKscEOAtgPoLFgiSdHPrbzDA0Yg1L1BMlodDiKs62LVoJ/jmW+hyf+hwm7JAlbcaX9cYZlYbCDJBo5vH2RStYiNYMxESvuFWiYFvodRzjiAgx+nYHw6wndTObwlj8EVK6px0wr1U+oRL3A85GpiOd/MI/sNZnEqa4Z17ItMWy8HdrHSQmixd3bX7NyDgVRz3vZwzasgdjs4I71B5eHqn1nLhwwXZf+B3a1/omPB9H1I8OOzMD6B4S8MV1IJfkTItOLhaRiZPTFBINNG03EtdLXNZ5euVWqiln1JPv5HbzXxJQxjHzaLFy7GU4Xnl6uXRPxOnSNxsJqmfct0aSzrWI95/HI0+c2vqqW9BBHp1bbIYEJ6Qu66Y7OsaZgv5D6HqydeiXL/TYL1u2B5C9+7AuVKrrPbFrrhkkKvoi3afy8RcXBVB59YZRbMxjvJrYAoFmdK+Vg/9pVtH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 18:08:48 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> memmap_init_zone_device() currently seeds its reusable head and tail
> templates by fully initializing the first real struct page and copying
> it back into a stack object. This keeps the first page outside the
> common loops and leaves __init_zone_device_page() only for template
> construction.
> 
> Build both templates directly from the PFN-independent state. Add the
> head-specific pgmap and refcount state to the head template and the
> compound metadata to the tail template, then initialize every page
> through zone_device_page_init_from_template().
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


