Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9650F606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IdgWz5xe
Received: by kanga.kvack.org (Postfix)
	id A9CB36B05B5; Mon,  9 Nov 2026 20:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A745D6B05B6; Mon,  9 Nov 2026 20:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990736B05B7; Mon,  9 Nov 2026 20:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 747EF6B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:37:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CCDDA08C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:37:01 +0000 (UTC)
X-FDA: 85417495842.07.3E4655B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6F310140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:36:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IdgWz5xe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794274619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQbRhh+GNMjRVzFPOt1jBxmudTlDGq1Egh6Ph41W0P0=;
	b=VJP7orPt9RD8f4h57BLgKHd44xcHoDAtTgYaw+rKsfzF1vwlDaWCGh3QjbKT3TckCjQSyM
	m1JW3yl59Vzow3utIju5lWXzvMZtnq9DZ1ZOdMdgv44ZUV4CgDJiZkwiXck7RnRm+8WeeY
	X4vUwgPi67J+vCDKZuweiO13+tHn5ow=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IdgWz5xe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794274619;
	b=EyX07Uvbt1pMnSlKE5IMvy1M6dFCiGeNiGCwN5pgJwgOfrDRXmJob6HIC8AgC8NcaH05DG
	ThnMFDHMFHkYATE6LWmzrhFeLcyctzncWcwJs0MIO3TDBAIVX3zXZjYuuua0Pk5NHa0iBo
	ohGP4nFNK5ocaXbvtQjlNVHTmE/6vy4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9664C457F7;
	Tue, 10 Nov 2026 01:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39361F0089F;
	Tue, 10 Nov 2026 01:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794274618;
	bh=FQbRhh+GNMjRVzFPOt1jBxmudTlDGq1Egh6Ph41W0P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdgWz5xedYv0YMzMAFuy66/+S83z3FE0Dopuxd0yDm+NTsqKhiKQRrT2Iyhyf9FOS
	 IQNvv6LvKWjp2fVyXYh9WxeZfa9QhpqPgbi5CPDJAhxHlxjnIlaTAVBdz9kWULYzLh
	 1FpcFNA1E7gtETP3GwlG0xXNu6Voow6ibUrA6QH513mn561bxqdioIewr9F95134FL
	 xMGi6uvfZAf7MOiKcgDmkRG+IeFWoLMcnjzBF7ufW4KlGxHI6S13L/ub/aPm97JKjj
	 DOtbFFahPUAY2FGgEZTZNMVc9T+ftiPr7HzihEJ/Dg/ANInaKFINuNL38/RsZGc74O
	 eKn0ygDXQ0x1g==
From: SJ Park <sj@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zhen Ni <zhen.ni@easystack.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] tools/mm: add page_owner_filter to .gitignore
Date: Mon,  9 Nov 2026 17:36:50 -0800
Message-ID: <20261110013651.107001-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109110139.216653-1-sarthak.sharma@arm.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F310140003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pwgtm54e8efgaroznpc6x8uq8udf5oo6
X-HE-Tag: 1794274619-915086
X-HE-Meta: U2FsdGVkX1+Dp9KUjsMZ0qei9c19A79qArx1f3aRDya7NU71IN0sEZrt5CzduHtXI9YC/aDku+5OVkSDFJ6qgQeSltL4Urtz9xy5zv3mwaWnd9YUtZidgGyWyfFVgfR7SNRZs0ALRZBfKm51b7HEe8x4i7jrDcaJ/GbVCtSYlPcDrfeI8SQFePeGZTFc8dyl/rCeOcEvgKKpAiOV2MFUGjpnJCSahq/w9wj9GC5aWKyFed4uHLCrwUMqAh0M1fLxOAuheCcpmGgw92eblPoCi3qQv9aeY1CvDaV84B6fRT5UrI4KPUNFyjc/yiuaN5nl8evuuU4mR7hjpBskSBOY7hE91tP3hH834AeR3kF1Lhg8raXyv+YtKlt3N/uNnWFVF40op5WXdmPzeeeCUwLlxB3vi8WUsrRIDxKCR+vq6p0bSCFJlN+1KttVgLQCt6Y9yFDbWXJhXJtTTyGS+uM4E2CdcYPtLXTbIErW9yD6IQjnNDlYS7pSgauAPfADYv+PD1lHvpEHVNnOFH6R6w4Ex7IsElYZJw9mVVjQJgjxCMXVk92XQ4+4OTNoBxM8x908Jen+fh5YXrYyeVE8CuInxk8LNmCdUhBDt7V8HKhw4/fpDurJy7WSPbY2XprO9BvD9ZxFMpUJpH6rbaRTOEz4rqB63nOv46uRPCHn6btbpZ6pcB7FbQy9QnlyKIZ7Wig56YgCjICgb2si8U62Bvxh0FXR9WlIsUJvroMnZ7uwt+OUNuWbWmZmZekYiHrcCwgyrCsyffj12hcOghQn3QPELS4pW/VmfX9aiM0/BrpNobHXK7eAjDEpltHb5Ui6iaFmE6EGeHyOmd2aF+iw/mKpwLdq0BEdBq79zlw3L4QYh/tN1rT6Gor8bGSfLqk1PRKXxdOXVRGqQFl1uGeo7va3KqwQ2LLXRvSH8rxgaLRYaRJHfJ7sfUs19x2DvUFwGo7Wv/mp46gpszk0dLpYyrE
 tVdkoKOo
 B+dwCk3f6MIwZ0Tu62qdVS7BFlvdjS0wrY6CZoviQUgP6pqjjC6uR4YEm3fLYJqdq3BWqqXgi2ZReut+RM3CuYcebBR++RMqsQHsBRDt/98DQ2EA1v6BhHWGKb4tURBjD7PdpMPML0A+rlGRlRRnK5s5H2RVDJxJwgkxKMWdNhtSn2yqZb99P8rCfvq3SXhSVd9hc3VSTytqMVHmOXfLMa5G+qxGv5ejyiVO+59dqU91JZqJZgFq+JRlLTYNhMODbz7Qg9GE1tDEmSJlZTJBuUPg4Vv4Vl4imJy4JmeVp9Zm5vkBp+NU/ej6HwEAfrU6voz1Tf4UrX/Fv3Istvoa87o21ODfZzbtC+Tyc2zMRjphMxIjqoPuILoRjlwwe/J7RC1PlDEX/lJqCSRBV+NgCUX671OsjsEiYPBZ5lBHegMZVsaZ8He2fB8oFGwN1Yc8Aaz3CpJiIhKDVGdfDB6rtljkadNaLZusFt8/QNKqMelZAeQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Sarthak,


I found you forgot Cc-ing below people who are recommended by
get_maintainer.pl.  I Cc-ed them.

- David Hildenbrand <david@kernel.org>
- Lorenzo Stoakes <ljs@kernel.org>
- "Liam R. Howlett" <liam@infradead.org>
- Vlastimil Babka <vbabka@kernel.org>
- Mike Rapoport <rppt@kernel.org>
- Suren Baghdasaryan <surenb@google.com>
- Michal Hocko <mhocko@suse.com>

On Mon,  9 Nov 2026 16:31:39 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:

> Add the missing page_owner_filter to .gitignore in
> tools/mm.

Makes sense to me.

> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

