Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A22CC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8316B0092; Tue,  4 Aug 2026 11:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978796B0096; Tue,  4 Aug 2026 11:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F146B009D; Tue,  4 Aug 2026 11:36:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 642516B0092
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:36:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 038EA4018A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:36:12 +0000 (UTC)
X-FDA: 85063988226.15.37982FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D8C01C000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:36:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPcb9mrv;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785857771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LROdNJHis7fEqQDj/xQYIblbCNdRMuIDk82uS4/tPnU=;
	b=btstweFvWmjXVzfgTNjfW9lnkbI1YOhcgciT8HFAf2BXq120Ik7a/uS/jFUnq8g0dTCnnq
	Csgnls+KOxhBJFO0MHdKrDFAd92OQj58js4tQFELj8eRHKhJioCT70EepjM0aN4ZoqV5KJ
	tAEWAUVVv4oydq5m6kdWAbcbIziqKXw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785857771;
	b=k/FZBeS0FZX35bI1Day1S/WUu+KIFPNtwAYhOVmLeGMcRI87dtRMG/Kf6PFQigdzDw0qn6
	uv7/mDvyXuoCH9mgMGvB2N83zf2NL4/ebRVzyD4ZSt+WKeiDOR72K1Ira9MqPdR+oxnl+b
	c65SoWprZdv9h9Wc3UrnB3Th4ihY7ME=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPcb9mrv;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DC40412CE;
	Tue,  4 Aug 2026 15:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649881F000E9;
	Tue,  4 Aug 2026 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785857770;
	bh=LROdNJHis7fEqQDj/xQYIblbCNdRMuIDk82uS4/tPnU=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=UPcb9mrv7i37FYMvmlJE5STml8AaOU2toSGgMMJ19HfDV+qNDmEpZSEpUAX4uyzog
	 CdcTsJIyF/F/98d6Q8SK4j+nVaq82sXIiWSBolZS0GCScKsH0UfjKAUvSBABQgYT2O
	 yIP9xxhZVQG4t2mZB1lSWtGYnlcszN2FUGKMij1CWKUQTdw2gFM0oT1Kq2VdCseMkN
	 I5t+gdAdMuyMjRyTz6ldO+Qyiov9XtGXxKbdbZCE/toQvBD0h1/5JM+XXdr0vw88Dh
	 fLCqLhMEpz5QAtUl4D8QLfzjbf9qDA4voETEK1o4lo7QemrRFUcmx8pKXfIS7Ah25M
	 JuGLwBp0T00fg==
Message-ID: <88e636fe-3c29-4d8b-a752-d8b31c8181a2@kernel.org>
Date: Tue, 4 Aug 2026 17:36:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] mm/vmscan: add pgrotate_anon and pgrotate_file
 vmstat counters
Content-Language: en-US
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, hannes@cmpxchg.org, roman.gushchin@linux.dev,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, rientjes@google.com, kernel-team@meta.com
References: <20260727162550.2032-1-usama.arif@linux.dev>
 <20260727162550.2032-3-usama.arif@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260727162550.2032-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: j4wobkotbnfx1efooedt587xt1bc8ost
X-Rspamd-Queue-Id: 3D8C01C000C
X-HE-Tag: 1785857771-992326
X-HE-Meta: U2FsdGVkX19EWJWqKZqxkhggiNyXd7U/KjYUymZ8eeq1aeg16eu6enXV7Sju2tYNGiJkDcvtxyHdtpHor+UFoZ6oogKtwLdTmt2dKUNCmMsCI9pZPhFXmCt0efsgeD0Op9HqTwqLJShvlon/C3gGSk7r1zslLpFj9bB/3U+e7MJ8Xj5rTcLQyRadY+neEcIjFaFgDVDO7wKXHDyWFtD/VT41HzHMsMFqhnr4jBhUtYdPpCNpioMgq1CxDx+TatF2WNEm9fX7usn+eVWHsFfvfGNh36K1QRKemk4DQQ4lEipYQfrmxqnNAtFYDLbT7FBAg+eR3iSWf7+QMV2oBCQ+G1zAkefu97fOv/svBEfP7ALcPh5/wx6LTu3fvFIdWGeGYvGsmyFQEjmo9ft+EHC5Y3lvLmjUYjuJJ5NZkBLEw4Fov4Y5DznaRHIC9A+TYyYp3jsbCgthA0YmlipHuyzdtZBihnBU2AQNJEjfYWQRnbr5i2LgwOA/OQAFAUXVwtZwPA92BNsE8bOKNq+y+38DLJxoR9iOYSjAgq8xDk9TNc8aPqr2XaeblBiNh7PSoTZjwQGZaoXxUFXa3C+zZpDmt+NsNNr5awnW3BnCF8kJC5dmw24ybhEKEOI+9kDF79yeEAMSDd0/fxPkwGjUseYe0dOHasY4uvievydu2SWU6puOb7GVIDqjdiGUn81ePQVPhkI94BxwUxJNLC8/Qfe5S1GHDaLzUsKe+O60WkGGl0FL/ODpbXn/m60+krIlbcr8WLvQ94Vi1nseafSUfZp8AEtqLuF0f4ObzuxaMLFgBqBJ0LaGJaQZbDPB1OgdEKlyHM6IJG5N1uUEOMMG+olCpdraXC/E/7PshFaCBbp7uPtgaBpiXSofZfDetE5vupfhqxIXsZmzB+UD2VzxEU6xwCFIyr9QyKAaoKaGzoydDBFK6Jd/6eqqXhNfAzO+JRM2TnvQ0qXULiLYBoEvwKf
 9kamCue3
 JeiUbF4vqRIdjY2AF028ABsUIFWYFTi7YtMor9bGiUW4iplbe6L1yOmuKHdPHbDXH5dW5rX6GxuQM2QbdJfSCjjIR4kNeEDYukRMlthO9l//V0uufSp51R9QFvFDnvegqJKcS/jI14DA6Tmgf3jzfGLTxznciC0k8q1XvLzVLolQPKaZOW3nUG6CWO6fp26hQtnMm5eRnnuUwCUefeLR2xNBxksIgj+Uok1sdA1cWzuAyPQz2JNWKM2vdRebIjpjjPkrL+rk34WmRRtFtdJiHm5vhn59xKVA4zlO500U6SYW9704TQ9GA8cfHKCTcZ718CTL5z9ZGor+aFfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 18:23, Usama Arif wrote:
> Reclaim can spend substantial work on an LRU type without immediately
> reclaiming or demoting a corresponding amount of memory. Record this
> work in PGROTATE_ANON and PGROTATE_FILE.
> 
> For classic LRU reclaim:
> 
>   - Inactive-list reclaim adds nr_scanned - nr_reclaimed to the
>     corresponding anon/file counter when isolation succeeds.
>   - Active-list reclaim adds referenced executable file folios that
>     are retained on the active list to PGROTATE_FILE. Active anon
>     reclaim does not contribute this component.
> 
> For MGLRU, add the number of initially isolated pages that remain
> unreclaimed after both the initial and retry passes to the counter for
> the selected anon/file type.
> 
> These counters are distinct from the existing pgrotated vm event.
> pgrotated records an actual move to the inactive-list tail, primarily
> after reclaim-marked writeback completes or failed invalidation leaves
> a folio for accelerated reclaim. PGROTATE_ANON and PGROTATE_FILE
> measure reclaim cost and do not imply that a folio moved to an LRU tail.
> 
> A subsequent patch will consume these counters for anon/file scan
> balancing.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


