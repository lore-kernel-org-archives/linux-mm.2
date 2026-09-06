Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87BDDC624DB
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 01:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287996B00AF; Sat,  5 Sep 2026 21:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237536B00B8; Sat,  5 Sep 2026 21:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129906B00C2; Sat,  5 Sep 2026 21:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4FB86B00AF
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 21:42:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AA141A0428
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:42:33 +0000 (UTC)
X-FDA: 85181637786.29.9C356F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 99FA420002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:42:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d9otqxcd;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788658951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AYMvAp78dVD5vLMe+eK825AGZ5A0V/aakGb0r5iBD8=;
	b=HkgwcESRh2PKNcFdBoxyNqroNPdkfl4hZHnvIeFPOE5tg+vu/yYCA069pg6OH0xfFCiKaW
	zRrLMLELVvfs6YP4ewEZhP9O11oZXcfWfelxt2Ddyl3/jsj0A1Yucfr68cx/fN9Kvp/qW9
	Y706UHztexQsI7JmuL904T27GKoCvXE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788658951;
	b=YkJ7ndu9NORj4OqStQXm2pnSpJuF15WWViuwQQplmV5ONIV7jRxKqYHefAf4Y2aMHs0wJI
	cZgJ0vkL61rUTenR5TSTydS3u4LaBuOhVSwvjQ0Vm1+kDAcTJ3dOco47pEcsNIOtv8Iigk
	9opP+ws6KpSvM9C7Rj2wkUh5aVCsXMg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d9otqxcd;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9E5F60D7B;
	Sun,  6 Sep 2026 01:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F288F1F00A3A;
	Sun,  6 Sep 2026 01:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788658950;
	bh=/AYMvAp78dVD5vLMe+eK825AGZ5A0V/aakGb0r5iBD8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d9otqxcd7zj7hxwsR7h9z2fXV+XdoihBpmslDHd0s4xCWUN1nwpYbP6klTajWyeY8
	 8w+ufiaU8aIE8EqK3x4dEuUmX7zmiB/PaoxQh+7SI8o2wyvRAzjJaGcC+dLNbn7q+1
	 6FrDVJ5D6Lc3kW9cUm6S3KRt2N1DjTCTMaIoKtGM=
Date: Sat, 5 Sep 2026 18:42:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hui Zhu" <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: workingset: use lruvec_page_state_local() to
 count lru pages
Message-Id: <20260905184229.8f7f30cf10638e7dc8224467@linux-foundation.org>
In-Reply-To: <2ec3a7f73e85ee5f5739c9dc2e58e9a0e2091925.1788514750.git.zhuhui@kylinos.cn>
References: <cover.1788514750.git.zhuhui@kylinos.cn>
	<2ec3a7f73e85ee5f5739c9dc2e58e9a0e2091925.1788514750.git.zhuhui@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 99FA420002
X-Stat-Signature: 5x65puk51b3rqzc1c17adyjybup43a4x
X-HE-Tag: 1788658951-730920
X-HE-Meta: U2FsdGVkX1/ZUDT+i5pbv1cPH64jVpJZU6Aam+yV7s+cLVQKopwEMZJ7YkNPles8T9Hb6qM9+RxMOul29rLiP4gJCXY/Wg/u4fRtfuFzFkBL0vIwF3PLhvqvDuFWGTrCZwVmB20NJaxYm2iUgd9M9Gf/4sEJ0xXr0Ibt8zcO6GuW5ixd1nH4TNHApv6J9eXbplPR7lLtKe5/m3pQZIO9yzroH44M/Xkqa1b17rVyXs4TyAY3BRvsYBf1uqhg5ASuMvPA+8hj2/LugnzQPC4511EItGHZ52SDIxfKCEs29xMIAI6ondwSiwyb7DkXCtGodZuEjWUvL9P4GHvMc67wu9UozQdYebw0sn9UwYvL5HnihJNpryUVUWh/1m0sfKEJMbCZGc4LdF0uxq0gdrgjSLjntIxObRCXem1U0/HT3AfZfmluBRdWAd3BlTDAfZxKRKhJkTZmIzs+WADI4fgxgalapkzYBTYqk4Imr/8kI5CFqp2hckI23QQn3pKzs3hxYz0mlkIm4fR3pGu4ky31JQRXzldY+67ld8iuZjbKC3E2iQC1/rmZGhbCenJdAe1w4ZDvAfOmSuU/2afYt1BIWLmc9tlE3xYYyCvlVSdkD344hKMQdY/EaymAFU33q+yACV/2LXDB0GBQCiCyD31aFzAMfaO546KU0SkpGvkOTm5kT9Ip4uQsu34DJrgfVqOuH3hL273YrlMC+AyfGnBNyv8USq4hM41Irpmi180e7JlAYXtHb1fCVOshrBK4DItOD44rpOubuDilpPTE0X7egB30cb7G0ZioqPMTE+L/D2+wzANpZ1YaJb+MOP/RhgsJcGh7pGDynuEC20DwPbsG22qAVbxXGJ03RzXmto1EscNY0e16x7MGDkXwXTb4lvwDJsKek59ME26d+zSwhkxdTDVTDF5KCS/WSU9OmW+LXlydfTAF5mk7ZZgGmvh8RJXULAqJOuMQwlLleKNTBNO
 TkwHISxr
 UZhIFHWzbYTzBAVshriEAWGajSuqddYQvnHuBnevvnjpRulIOiPtyMPYLBqZV1H8IPuTUqSaFO8rG+I3jAFUKvsmDLgfu0czP3HdWE1/m063V2wb/QYwXFJT2tvnMUVZgeixeQd00OSUtK1nM8RlOp4gllSdQsfF2ZpbfHwBfmPSyI33RaQYeo9k+kp+mc+EvkeQ+rKy14rWuZygFiD8cTP6okRxChn80MOtOQemxyQRiW2A2dH1VdRnKXNHWKyu/yCGdBz9/lHdJR7GMUJuwqbOUw0MjNY1Ua/u52HH60/Y8qsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 17:45:55 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
> which only the classic LRU paths maintain.  MGLRU accounts its pages
> through __update_lru_size(), which skips that array, so with MGLRU on the
> four evictable LRU lists are always seen as empty.  The shadow node budget
> (pages >> 3) then collapses to slab plus unevictable pages, and the
> workingset shadow shrinker reclaims eviction tokens almost as fast as they
> are created, losing thrashing protection.
> 
> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
> race this re-exposes on cgroup v2 is closed by the follow-up patch that
> redirects dying-memcg stat updates for all hierarchies.

The follow-up patch is "mm: memcg: skip the RCU lock when the memcg is
not dying"?  But that's an optimization so I'm confused.

If we're re-exposing a race, the fix for that race should have the same
Fixes: and cc:stable as the commit which did the reexposure?

It isn't clear why any of these patches is cc:stable.  The overall
effect is a tiny performance improvement?  Very clear descriptions of
end-user effects are always helpful.

So at this time I'll schedule the whole series for 7.4-rc1.  If there's
some reason why some/all of these should be backported then please lmk.


