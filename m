Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F423BC531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 00:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAA466B0092; Thu, 23 Jul 2026 20:18:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81A06B0095; Thu, 23 Jul 2026 20:18:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99E86B0096; Thu, 23 Jul 2026 20:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2D936B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:18:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B6701C00BC
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:18:46 +0000 (UTC)
X-FDA: 85021759452.11.CDFFC10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 734852000F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:18:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YQ2oKFMa;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784852324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksKhF11Mjp3pAX3V9fFcfkJV6jbLV5wiUOUzqBAJ9Ks=;
	b=eX+ElusfV2uroSFPa4cKjLIvansYVI4qVRQPlyqqGRZEaGu8TAGNpTai0tWB/CnTtphs9q
	YlbR0iVxF7vCay6twHh995Dnh+ia11LWpxS+CLc45JIVHnegu+RuhAd02kOFyZKT/JBi2r
	swhg4BstWEXb26lsJp4gOZiSkyOltlQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784852324;
	b=oR36plDHXwtfN0yUFp98CYRo1RIqZqAbRE37PDx1yynOSMTeX2GDbP2bztiW4Xoi4jdDan
	xI6JUDMkRlxFEQgKAHCne5SQUj11v4JUGZmc1Z8VQn677BEpwhwr9DhFNOrW/75VUaSkFu
	SElXjtTB3r6Kz7GkHbXSzEkL9ISlgTs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YQ2oKFMa;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E617408C8;
	Fri, 24 Jul 2026 00:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5E51F00A3A;
	Fri, 24 Jul 2026 00:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784852323;
	bh=ksKhF11Mjp3pAX3V9fFcfkJV6jbLV5wiUOUzqBAJ9Ks=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YQ2oKFMaekKQZl4Nk1U9Ex5cIo5T2H+e8fcFo3G+6BodGDTi4/TON4lXXcmkMVPAF
	 r+BIHJl7vM6fCnWMJo4CWKvfQxGvP7jYOI/ZsTINRHg487EJwXpPHkc9EljVM1WQfP
	 Mud3gUonr09DGV6wFoLW8HUdyvuDQHRHoKXPCRS8=
Date: Thu, 23 Jul 2026 17:18:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Zhongkun He
 <hezhongkun.hzk@bytedance.com>, Muchun Song <muchun.song@linux.dev>,
 Davidlohr Bueso <dave@stgolabs.net>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v3 0/4] mm/vmscan: fix swappiness=max and clean up
 per-node proactive reclaim
Message-Id: <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org>
In-Reply-To: <20260723045718.2052070-1-ridong.chen@linux.dev>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 734852000F
X-Stat-Signature: ptm3qqw8rxtzuj6t594bqfihwarp1q3j
X-HE-Tag: 1784852324-934388
X-HE-Meta: U2FsdGVkX1/GvHtwwmX9qEU2UOOkZI2XLvmyh5zQkV1/ky5AOKH/EydzJYmWkJf3ac+WcOv6EzmgNEhm1Ts1m9dTmB5asPXRM09ez+EBzjc+ILYPicYSnT8njWSoEfQ/6iZUFsZZkC4kugGhGsx+5yHzlUMfObhwLUAl2AcFk4p8cOXj+mlQNyIo8Nsm9cdjxQu0NkvnySoX7RVtzo4pg5S2ev4+uk2b809EPqlfDyM2YI8raMggJFKK09vLtb0svDThONHbiqRqy+z5Lkm7UmvwN9hhiPVDiN3bNDrGx/nfayTrj/6+x4fD198dhDVQ+euMd61t1Eno9s+ozHRb659FBH/n6oQ7Q7T8yuJXP/D62CrH/gIOYhlwdxd9y0gFvUeKqNuk7c6LK0EUPmVgINijJYux+bY8KR4H0bxruW4LOxMgL+xrpr1HmxSdmvDQqf3ru+TuAxiMsFnYgXxShyR0QjMkvNx1QWd8Q16K3o5rqY90+IXvDkWo/xZaWks6ODXEb4iVOpK+Vj1WD8TjrWofXN3QvrtdhlwSzVi8R/0ZCs/KJK3m5T+aovCFHDAm6VZR6E99VA9MJ09d2XXMb+b9gTN/a+13j2vNoSoR5C43UBdNUCn9OAG36xlS9iUsx3eI92msCApGg/aQQmrCzopm6SMXWGa7vUZhgqA31t3FjhrcnA+yo4qKnzjNfrzvUUM2BjXWbZYZJHYptm7VjqR/9MVHlFwBtNR/ThiqpQqztUTVKE9GELR5Q0lq2ujj/rC2zbMC+oZzTSXdYO8gLvlV6pC/ABFQa5JsArPI0QZGeGRygSpZ2ggEoWpZiQAi0mobkI7GsS0JxGbrpCoSLI/43c1ZRNxwp+vDmB6dC+UKakAcNNv4gz0vMzS6ruzXNPwwLNa7U5VNEzZdNBeaTEgJZDDiltI8gleSutePdxjSJqpVhzZ0SniTf10nvjdgKUyzIRIIbpjZ0JaRVLe
 NNTKPaYx
 yuQRnpwFypyDtnyzkh71Zakjc3EHHodlb1AxD26zFWGxzcQ7FITSVpP8RwAvNKrMGs4zLf/z2ZSkmkmpArIQwpVjFhcKO/XONqxKYjyqdmeTEZeGUnEHtD+FXZKrPIIw/p7xk0y379BkW0wY4Lqy4zpupaFMKQmdUpdj0GfNsZZ01FWQ+wx6xxPoZ3MFNDGTGJBPSvHI3DZwcCJ/xGstP0PHdwzuG/p+kJcnNTPNSrxvomNfOdnrn15qVnJLCF09uoQZNniHYqQtsvlqdRCzFuhXKuLyuoHSCOXHBGgeH/V04pRK2j6hFtZ28oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 12:57:14 +0800 Ridong <ridong.chen@linux.dev> wrote:

> Fixes and one cleanup.
> 
> Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
> sat after the "cannot reclaim anon" check, so when no anon was
> reclaimable the request fell back to SCAN_FILE and evicted page cache
> instead.
> 
> Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
> callers can no longer tell an invalid argument from a busy interface;
> propagate the real error code, matching the memcg path.
> 
> Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().
> 
> Patch 4 fixes the same "swappiness=max" issue for MGLRU.

Thanks.  AI review might have found several pre-existing issues which
might interest the maintainers.  Also a suggestion against your [4/4]:

	https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev

