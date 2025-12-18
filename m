Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB45D6ACD5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7756B0088; Thu, 18 Dec 2025 04:09:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354EB6B0089; Thu, 18 Dec 2025 04:09:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236EC6B008A; Thu, 18 Dec 2025 04:09:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 107496B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:09:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B909E1A0DD5
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:09:30 +0000 (UTC)
X-FDA: 84232018500.14.B88CDB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id F116E18000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:09:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RUwTZfEp;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766048969; a=rsa-sha256;
	cv=none;
	b=BuuTZC1gTUGZaAK9wJx4yW/zFg9YQqfgLlB6cy3UiDfebZwfC3ybIzFVMqjwYnyXtXQt85
	AQpJrOQ9suqQFnsy26RqLzrdjY8MZQjd14cCCTbiY3nxlOt2gZOUVSBGpSzPK5idEBEwnB
	czBkHLiMmW/v0CYrjjaM3PDtL5pWNgM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RUwTZfEp;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766048969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUdZKPRQK50nnb0G4YRlqMcv/TyxJJ8z+MMHnn0aXRQ=;
	b=AWf63hMPdghnx9mqThh/WIzpcgP2Zg76Qo/ESRY+v9h1cVlDs0M1Au3WLatQbkrsyFUH53
	cVpdIPQgWu8jAGcOggSkMu32figlJfY4jkgEFtULAy6U3jugQY/BfbE4yosoJujIb1GvbM
	MyXD66p2EsbWviAQbIPL9PTk0Jjpx4g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3235C600AC;
	Thu, 18 Dec 2025 09:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47EAC4CEFB;
	Thu, 18 Dec 2025 09:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766048967;
	bh=cy6MizIU13WGE5axn5arnaf5rhN5ZiFE8ex8K1Wi8R8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RUwTZfEpT3RS/Yc0n40yQFEks21Ug9cS7pT/oBG2l3gPWBMXll3cWqRb4bsmIKBuI
	 TpyrA/6eRsJ5rekjU/PiGTvoEVYK4YuHbKnRFRRnbnyjdujNPKIvXM/LmOx1n6mNZQ
	 /hEJ23EBt4Cyp56TWXusIE5oCTHDotgtvp3AzFvUy1o/WeGSV1A2KLkcQcAf5zSy3U
	 /27qcDJL9F3uBSn8UF5qruCwE23yBabi3UNyLnCm0VA9opcyOagXKTnLwAVQaBYlzA
	 enYz1yaUrs3Z1OymV7JL07tkK9a513V2JsIKvO6pYu8xwV6X+8S0x1dlW5sEPpWMCD
	 StnHpnGbDB9SA==
Message-ID: <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
Date: Thu, 18 Dec 2025 10:09:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F116E18000F
X-Rspamd-Server: rspam04
X-Stat-Signature: 7dhi7nyqs5jaz49qfo1k7wkpkkhqnzqn
X-HE-Tag: 1766048968-906684
X-HE-Meta: U2FsdGVkX18lyjH8tHLwgR+IaL+ay9LoozU8zwBw+ZHxjToLgSDdD3L6P1S2Mu6jms0dI4LI61jBWTMK7EmIfMVn2jOjqTO3TrJ0frg16dffvJ7Y4jPBRjZ6/o9J1oEC9f7jfQHINgDV9p7Iq60YBQr9ru29Ekbmbqmy1pEuh+HGZ5HGSbJ+sGh4sLvgUWAdblN7Tv+/NAlZnT3Cov7QrJMPLiA9bt7UGLnshkN5I63nwT0AhNSkr4gZin7y8pgy6zVkUiT+4n9Ya5LiHTH6ZN8gpcXNWr1ALyssRmlh8SRWSZb6xB5NfkQAasc97HY/f5PCO8pyuVm9s7tNqHORgebRPmGZ+zOL6mhRr8giXlLNDY2WfD/1cEDNntpDVousGNrDpQw3Ceq3yKgqafuhxcPN/6ORgWqU0s10pWyU+2EdAMeCZiA2e24+sOFSPYN48NaGGJjPvsnFuCB5zujVF6Q8rCOoWcOT2aJzoEfwJTm/fMM+fleccHqis9Aid6kqIvrEglB7zqVQVYpTd/HX+cxZbotkjUUIFl/GL4dprr+mrH619erihNkvuPIvHvMAz1S2JMo3ft6r41Rs40y+fcoP70JPuUF6/f7DU156YazFb4pK7b3Y6fbTTfrDDQWL/9ziPLTOLZgFqQo6vMqzz3RGkW+QoGnZS5CyPKAzHr3Idg4O+FxZB3bGPIGKx8HjyMR2lzK9HTLcuYTZ5AeFcHjE/qgppLGCz49NS3UEeH1dclCBVotXRNN2x8PiwqmlVUqK9mBBFoIlK9vARl3Um0j21s7spbZ97Ztw1EjCgZvFGStnw3xIrj8zaI0yOciynG2zm44JwnNLcGZ6GV9cCqP4WY0nanNnXsTo1WmXELtsiZHGkFKeaIpiwLqfL8xnem+u+ZaVI6QqR1S6e0yolByIP8HWDXwJcrxc5Gk/3bD3r7j4g27S0uJPkFnYLRNSG5ImnCFAICdFm5kENZJ
 dMLB5Fp7
 5jty7712eifBpz05BeU3MUz68U3hsoH56Tyjy3oo/4o2AOnH6/9P4Q/0rMDTtqMfOWVM4q59BTb8s9r6lJJT44FmuZ9z1zrCY413hYdoHmdemZwRXzr7okL80lGZKj8z9sYm52XBY+YyHKH/GKT3pYczMuLaBycbyEcf9hQd4GXIhzr/8lkQQQ/A8fn8/bZ0zW1NUZSu0+9libJ3kst4ytQ13ZVXtjJ/U1K9+80OC1j1S6rGwIU+q8nylYHpbBkGUvvSTViOZ2D8oPmIBPghX12UiNPhSFQ1Yst/FYS0IqSELe4OM1SGhzceu/64IVYrwtLH2q64M4vI0O0Bj9TwHg4/v208D/4fMHpbs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 08:27, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in folio_migrate_mapping().

We usually avoid talking about "patches".

In __folio_migrate_mapping(), the rcu read lock ...

> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>   mm/migrate.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 5169f9717f606..8bcd588c083ca 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>   		struct lruvec *old_lruvec, *new_lruvec;
>   		struct mem_cgroup *memcg;
>   
> +		rcu_read_lock();
>   		memcg = folio_memcg(folio);

In general, LGTM

I wonder, though, whether we should embed that in the ABI.

Like "lock RCU and get the memcg" in one operation, to the "return memcg 
and unock rcu" in another operation.

Something like "start / end" semantics.

--
Cheers

David

