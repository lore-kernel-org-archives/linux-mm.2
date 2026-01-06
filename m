Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 349EBCEFCE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F056B008A; Tue,  6 Jan 2026 13:50:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976E06B0092; Tue,  6 Jan 2026 13:50:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADC66B0093; Tue,  6 Jan 2026 13:50:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7E96B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:50:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B036BB82D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:50:43 +0000 (UTC)
X-FDA: 84302430366.20.4E7D9DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 76CA240008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:50:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uzgfWQKK;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767725441; a=rsa-sha256;
	cv=none;
	b=uBHjyj5RTPnI5Ssg6HDb6RcMIz1zqh4HFN6Ju9O7JC8zncqMp7ruYGfDcX4bMEpNmhbVpI
	ft6lcnvkxoJezVZABn/wirx0ONgcbhdeF6KdxMeCHk1C3i0VdPvFVCchSGwdGMb8GYeDbi
	RKnDeKGAvkda/h8C3UPxh5pOKE5OBMM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uzgfWQKK;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767725441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTtNNt2xXNL0oKCMnFPQkU9K7+oRtboKOvqeTSeyx9k=;
	b=muvVqw0h+9uq7N+ATTJeHWUWGTwSrruiJzpVMlxT3Q4WxwOpLCt74GxfI9/vEX4aQHY+ko
	r2QrOQuopHVmfxDqYNVYyYHViBdYK/yOB63craGbxWHaVRlpPgHWMNy5x/rlkY/ZtRoBZ1
	vYqzzp5LikEiJ8e7eL1oFN76smOPd4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65F0143E57;
	Tue,  6 Jan 2026 18:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF539C19422;
	Tue,  6 Jan 2026 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767725440;
	bh=BGJr4bLtW5UW/a277QKOKmHsnFt20Odg1H9gTtbyE1s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uzgfWQKKLTZB1dDYmXUoV0mbXXgbygdMa6q5F+JbPdi5wCqV/md1YPFhVTLmxdXWE
	 2ibS+rwuIr9LAPOSD0Q2ern1ti+UqhyzqBUy/LkEFSmDoeJvARo2crGd5UdY/cmmGx
	 kj9K0yvRMDC86cki2gcu5A8aKn+QXC71u83F6Bug=
Date: Tue, 6 Jan 2026 10:50:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, SeongJae Park <sj@kernel.org>, Meta kernel
 team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] memcg: separate private and public ID namespaces
Message-Id: <20260106105039.6f1cdcead82934422e755ac3@linux-foundation.org>
In-Reply-To: <aVzjN5z3w114fNB4@tiehlicka>
References: <20251225232116.294540-1-shakeel.butt@linux.dev>
	<aVzjN5z3w114fNB4@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 76CA240008
X-Stat-Signature: zzbgroxq1rpdjo1ctbcosegk5my9ic38
X-Rspam-User: 
X-HE-Tag: 1767725441-211217
X-HE-Meta: U2FsdGVkX18cDRgOLWTSfbuvTi0GmBRdouSn1wM9kUa6qTbL2WqUKigl+bqomVaj3MnlO7lUTlzc/ei8jUKf0yErnl6O+g7OfwuNm6keV2gbNe2muzy2mTBwxIx5YrGwvVyfDTAK4nBW23t9XxMxOFEbRrcOwPaQn0uFWroCigxGAVt1eA9lK+iGKuKrvvvZ4juIsLz0DihNlHQ4P6tT/7CTBHhe0GC4B6Hu9U+8B7+f7tN9Wsuw0yASU2ESbrCuftf9juNnT/sMBsDPySuI5/UkTllBZhHJtbRxxOvd0ZfeAOngUVTvvvJClX71zQjwwxP59VxWbQHWDNJhiQVAvtrQXBPb5r1OmCinPLja8gJgykqSxQ2kkLuX1zBxqqReeGIoLmr2yVF3ykl4BdkICqWfeuN8liqEENpozHnfL1x6Brw/TmrbNgbnfjd70XycUAyO2PSITDZQgN6wqcJdDrnEXQySdRn83G3RpztmP9U6FXLc/ZTnTbkbqbU7jmvcDwarJIO0iWIu7Mfpgk0uJzg4G7sDwne075Tzq7IRklKmMQG1CFEs98VtAi6wTjr843xZaBTDtuGkSSI9LNJyOKwgBllmCqVsN9ydYyr6FdZND8voGPGHE1Sx8gPMdKrNKpMg1nMlVKx2HjzDRz41e0Fnxz4U5rQunG/jhXjeP/fSpilkUzyMJwp0jeoGM7jxCglIsTAOtQWUAV0Z+aj/Rk1tEFGeGWTFvrCHkc4wpS5YaShAx4Q241TOYr+7ayl8u5tvHUVHpmsGMVucWvJfw7ZBWPyypAqMgL7ZdcnAm902HjMdAJjU6RoGnjy0Kb15/4FJWgIwN7OJx9EchNsyif4h2WQN8E73cdJCSwri7HjaUwi9q8bDadjAmxBZG87GPxye0r0N4s2u02JKlG0XYwx1DnyYy/kGkw7NTxaxjns9hLOv5GochniokNUVbLLG0n7nxYW5fJh3TisQFng
 Kqqp6Vef
 PBn3Ie4oxzElK344lztmpoS9NHfCoRxdkq/c6jY7zkoLjTzUGYvPsfCfsUgjo8FN1dhItTS1MgDung7qA+hOFARCYt6nCQb2hYg5U7b6wiBVNZwt6lBD+C9irU8WE3ZfHyXxKEF+89e93XYfckHNC94ZX/h9ISW692vjfiux1RSUTY4Lmx568JGABZIVGZTIfBToBmYG0E1f8mF18sh6rfCaoJGo2ayMqSQ76FOCdBuUjDoL0oYgf13DTCOL9w7rUBjNdtKoeyHJG86vnSZJjgf7DVuxdDIhaVCcRixJVuPqETJSd78XrkfNGfcB7WhLjTkqYpLpZB3w2+uc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 11:25:59 +0100 Michal Hocko <mhocko@suse.com> wrote:

> > Note: please apply this series after the patch at
> > https://lore.kernel.org/20251225002904.139543-1-shakeel.butt@linux.dev/

OK, that's in mm-hotfixes-unstable.

> Makes sense to me. Originally I was not supper happy about the private
> interface as this should be really private to memcg proper but then I
> have noticed the lru code needs this outside and dealing with that would
> be quite messy so an explicit name is probably better in the end.
> 
> Feel free to add
> Acked-by: Michal Hocko <mhocko@suse.com>

Great, thanks, I'll add it.  The series in somewhat old (Dec 25) but
nothing seems to have changed.


