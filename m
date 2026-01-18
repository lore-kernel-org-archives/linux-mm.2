Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EE8ACA5FE9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 00:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09BC6B0089; Sat, 17 Jan 2026 19:46:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1196B008A; Sat, 17 Jan 2026 19:46:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED726B008C; Sat, 17 Jan 2026 19:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0EF6B0089
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 19:46:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20E67D1D89
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:46:15 +0000 (UTC)
X-FDA: 84343243110.04.0E8D69C
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 646F480004
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:46:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sdCeKnJJ;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768697173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l47ZvY/hwfvNnl4jWoQ7pv1llIdAqhn4iZv/kumEeH8=;
	b=bzpQrPqfagXGhLmVcHsNRoooEfqZwQjFYkqfHZ1OLAmBjMnU90HPju5b3SnaY8x8cB91Ds
	s4Ygoj7BjsIRRa+0cXLpRlPjcvEY5qZ0kPqduX0CIXY/n7zKJVtnnJFqolNfaYhjtP5QvN
	zGyCkaYDiZRj5HXcW9KsvkqOGRUCSPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768697173; a=rsa-sha256;
	cv=none;
	b=aSya7AiGOnIGaHvqzhOUe6pP13bD4gMsYBl1jlKni44ZDDcJf4wcAwirdHJU//MQFzWMOg
	678fmrGEH10xyd7yKkGjI3BipUw/ZP736BxibHfJML2ya1839C2BHZb2CZKdtfUvB5WkT5
	nK00GKj2fpITxGSrtTOcAGwYTOnIR8o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sdCeKnJJ;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sat, 17 Jan 2026 16:46:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768697171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l47ZvY/hwfvNnl4jWoQ7pv1llIdAqhn4iZv/kumEeH8=;
	b=sdCeKnJJvkgZFYFRMSdpNBNmk71Maj3t2PEoh9kra/jMVAbvFmJrYTWCL//s/aS35q+Fli
	YztFVArxSxj4F/GEh/tIuAJcxqsJvH1Ka5aC+kPn2CpyF8B/nWBduZoFPErZMybYizwyGa
	eGUKlzcKVc0qKohqoudSvIMpHhkA3iY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 24/30] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
Message-ID: <y2ffln6h57xb6rx6nf56wbd7uafhdswlvivjzuydzckplg3s4z@lyoihmhamwb5>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <0252f9acc29d4b1e9b8252dc003aff065c8ac1f6.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0252f9acc29d4b1e9b8252dc003aff065c8ac1f6.1768389889.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 646F480004
X-Rspam-User: 
X-Stat-Signature: 7ojtjrprot65itm6g6jzue51wdhrk35w
X-HE-Tag: 1768697173-914449
X-HE-Meta: U2FsdGVkX1+37wT3lozH72IGcDizO91JabpQPAL3aiv4SPGJ7H4Y2BSbdabuVIGQysMOE7imztvV8g6dEpQ3JWZpScJHYVKKEykVYdv0jR2UzVwQ+KRV6R8wX20LVshFManHEbDUczAqOZXl3rfvC+zZHl6awbML/YpHEnoOxy0G9HJWfo8Zis9rLVwh2xQIWQ8B/J4WT7Efap2UQrZXWC7rmdnB5zzYad69PMr/wn63lALaiUG/FEMDZkA1D33J5gZHdyUWk1kN4yybmKWLj0X87X4d/+xuGV85Mrlo+ZqebZWvSn3YxwVgpV8kPNVLEZBkG/3Z8nHCKLMfLZXdLdVrXzNjnhoJuDWHYb1zb49QtEBJsKeVezwh/uZMF0RF//VCC0skeqTw677SBvO7tQMeEEoBVBSTkQIkPyiSs2tXPbRuzeLYaFfEPRmrcSuvRqz0UG6ee9NdR3i+a/NuxGTAo2dDTrnkIGc/6olaZlISeaxocmVe0zbkf5bAIcv6AY/uK/Arvq+ogAWiLtFXGq3qoup0sg12wTADeOhmYWf5ZRiD36jiFYuIDsUB1bHVjHtCsMzZJlmoKQyn7jhTzTvU5rwHLYJrzMKfwl4qyDPKCa7CNcVL5fXqF5j+rqCsbnXAQi60s8OKQhWmmZhSFOjqxzM8vvLMIcuvyg+wOakaQYTisUEnTsuIo8rc+I/FKnABtZjKcRW5HgRTLuThin4kni58hMKHlpY+xhG5hJfJmcpRIPwlMnPOM7y87sMRPkFaI4As5S4RpXi2V3p5by39ma4b3LrOKSnv51LJw4h3dzUcwBJP6/vvBpB0yoRE2D9EnQbrM1Uuh/1gU4GJhctbU7Bcn4v3773H1rEAbziGl0j0dWTKbLc1skifdtyN6fH0XYws2TlvhW3wAzSywkofFzFtYQWT22IGnSDQ2Z/wa5yI1jNZnd2NWZQ0uPQucthQJ3L1HkLnOEHeqmR
 pp2imkwu
 CGatttNJfDUmFnIIzF4kD4N3fd1STJ15l7dn2u3EuLuCBA/r6jtIruWP27NioiC++c7RbBc6fUU8uKLTUUm1TIXlukWEypLjun2r10qMnYS+RtmHV8C9uAoDdkyP+W1f5eIwxYqcJVleihXyxhW52vRI14vETe4i4s2Syy1uRKwTiOC293jx9YSaNm7aj7rBE9Ghd24TqzjJ2qzMV6+fdAT+XUndQcNBG8z3rofYrntIngTZUw4MGuloZC8e20m7ERCbGtZt8Q26g/Z91n4Ld/79gD5U8dgOToguX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:32:51PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> The following diagram illustrates how to ensure the safety of the folio
> lruvec lock when LRU folios undergo reparenting.
> 
> In the folio_lruvec_lock(folio) function:
> ```
>     rcu_read_lock();
> retry:
>     lruvec = folio_lruvec(folio);
>     /* There is a possibility of folio reparenting at this point. */
>     spin_lock(&lruvec->lru_lock);
>     if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
>         /*
>          * The wrong lruvec lock was acquired, and a retry is required.
>          * This is because the folio resides on the parent memcg lruvec
>          * list.
>          */
>         spin_unlock(&lruvec->lru_lock);
>         goto retry;
>     }
> 
>     /* Reaching here indicates that folio_memcg() is stable. */
> ```
> 
> In the memcg_reparent_objcgs(memcg) function:
> ```
>     spin_lock(&lruvec->lru_lock);
>     spin_lock(&lruvec_parent->lru_lock);
>     /* Transfer folios from the lruvec list to the parent's. */
>     spin_unlock(&lruvec_parent->lru_lock);
>     spin_unlock(&lruvec->lru_lock);
> ```
> 
> After acquiring the lruvec lock, it is necessary to verify whether
> the folio has been reparented. If reparenting has occurred, the new
> lruvec lock must be reacquired. During the LRU folio reparenting
> process, the lruvec lock will also be acquired (this will be
> implemented in a subsequent patch). Therefore, folio_memcg() remains
> unchanged while the lruvec lock is held.
> 
> Given that lruvec_memcg(lruvec) is always equal to folio_memcg(folio)
> after the lruvec lock is acquired, the lruvec_memcg_debug() check is
> redundant. Hence, it is removed.
> 
> This patch serves as a preparation for the reparenting of LRU folios.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

