Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A4EC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 08:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CFC6B007B; Wed, 22 Jul 2026 04:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D536B0088; Wed, 22 Jul 2026 04:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50C16B008A; Wed, 22 Jul 2026 04:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B76776B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:53:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28755A0C74
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:53:08 +0000 (UTC)
X-FDA: 85015798056.02.92D95C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8B4C5140004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:53:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jP7ZIN8U;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784710386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyOcgX/JrvPJwhP/amg6I0codmSgZ3HLCjB358pTvwo=;
	b=OFAuW3d4ZgWdwSlNHuJ7JWbcy51qRUf+CypRt2oE36LF33bujM+UxXC/a3wz5msSm2hrgS
	ubvasUe5qdMMDFS+5/2lIFsApLrT2jp01qs27iMXG4eEEwNYODpn0HSrGWFavSguIahW8n
	4zb3Fr2pcmOsjHvdFRF0SW5yfa+zup0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784710386;
	b=hdATuSzk7IzPeLPqohYXnQeVZdx66bE9GraLT7HZl+XkJPA4qdKPrMWXAly9wiFrh8QtbP
	HY8kWlmlzhr9iBLhNsFUMXEqWYs7tdlYKjnc5dVhDdQnxRuNxWDxClk/MCTYEIWb/s564Y
	B73/nL4aAU0EyJBuT1BW1yTaqguZdlU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jP7ZIN8U;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F33D1600DA;
	Wed, 22 Jul 2026 08:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AED1F000E9;
	Wed, 22 Jul 2026 08:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784710385;
	bh=GyOcgX/JrvPJwhP/amg6I0codmSgZ3HLCjB358pTvwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jP7ZIN8UgO/HUTXhWIEmVSbC76l0TGwpR2XciQHR88M0YJHCd2AMJ3dM1NBo9WmA4
	 0kwZ4wXq1d/1Mpi/9E+Gj8+85uQRwGHYjQo2d8bYh8pt/h/5J80x9Y7PvOjllk5qDS
	 q52n28K1yZXRPeQYij3nDdMQ3dMzbi6KarcgWIxjkf47y6mUcEZbnbnNMFoWbTYHNg
	 Yd1nNX3Gi8X8lUBD1M2v0N5FTev5NtHifPX7hJ2w4d+7BCZu1ffKu4qRWIMlZw8rTY
	 ufsqXqY1YZRm303pik/Aw6G4DGxuxg1t1AT1LD3YRnwe9XRfCvgb3h4qzwlQHxJnMo
	 CmkK6sdQU4mug==
Date: Wed, 22 Jul 2026 09:52:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: deepakraog <gaikwad.dcg@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm: vmpressure: scale sampling window with machine
 size
Message-ID: <amCEULry4nsM_Uqn@lucifer>
References: <20260715143646.15828-1-gaikwad.dcg@gmail.com>
 <amB6WXIEKEeKudOh@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amB6WXIEKEeKudOh@tiehlicka>
X-Stat-Signature: 8jn65xcthm7ipqiay59dqpgmpb3q487i
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B4C5140004
X-HE-Tag: 1784710386-27500
X-HE-Meta: U2FsdGVkX1/lrPxGnleea8pAgE42vxyTfyMeNAztvItejwfvNw0bJxo2eoT8zy2uWtxOWvYDrOGs7AWKzWOVcayj4ERt6iNLW17HmE1SEoTj33GjW+44YhOa9aUWBVNx6tNFChRP4qNaZ7nDJCGBSVt+yIyeLWrw7R4Mo9rnnv60UPjwv2kqhFdMT7FywPGtPu615S+njPrEE221Bo6ZNiVya7W8WfkRGoOLUh+WxNyLvixj4DY9zOzt1wgQbNY/ZabnhpRBr/AndsMIXk/8EEdxRGeuhGmw/FvNLF+8sAiOUkG/wTJJn30K8/Has5k51g5V3MqLXoPm47EvOHTUGxpEoxVLalAe2a6oOfXuZD/Xxci9opEq7h+ohFXfBEWJ3eORVS7gujIlLCpyqxr2x5idrErvNXpnYx6SPYEHlg2BUMdYkjCBudmST5wGlpuRYvgm6YrVrE0DupIqhiN7EmlAj9jCbAT5T4WvptM5HxSfAIib1d6vPu9feRJLOBMcNrIZ8BZgjWJDxSps2041WDML1Wy0CBiHjkvqmBCDKQT9lORzSh6NBnXb8Dor1qfWoHYcZz8b89UKj/jGeVEdpQik9UFozHOQxWuv1LDICUKYbqijsm2U5Et80IHVrO/0wjaWKnM5hwQqkzRICeWJtErEDOCJoD0v16pOnmTF+iY4hR5ClIyx7XWPRf72ZpvfcsKdU3OPa3Pv4LImaIhNQvhzX/BzcBcaJ4TUtIdqaqE/z3JPQlWCk1hHeohElFpG0h5g7lvH09huP4Ld72q2kfLo+PoDuqGkgQFb/skIojWHNgoNA9Z3JsELdXpZHOYm415bJA2/i0xlrdM0T0ia3SxoOpbKIuLj7LhzcATKyY4OKJcqVVAMBet2OeNzf/iWFJj8ElcfrBJ/djL7ZkGK4a9vMdDVLIoYxBBn3otKcqFF/uSZ1eKFhxRx7sFB00c5VlhKwOq/p7PmlgM610p
 WiPxFQK/
 jn1C3uJJoHFX2kRvf6M8a/+iTyY2HcmqPJ+KP6mM0RbNvoXebNJQUC+Bk9qgu9pxMK9dfMPvXkcFrdIYATYjTuYJ6JhbrfaA9/wwHma7LFxWuZQppCc99vuiR5zSx0mPXc4LrDz6YC1OGfXjGA6W2Ljipy05pyDpLWfDApPZ5pEZPt6cJYUqbDZxMq9NEE1jctjBj0DZQJS7CBZxIAwnO1+JUpcqfgP2vRE5/cjCVy3foW3+2FFmCZ9Un7sSDq0WEyCOoY07joaf84WGe173KF0EkmOtZydllvNmpNZghDQV/CzQGEs9mjG/jPstQSIlUTTMxxeAARJHAEDNTOatnlumJziwJi8TaRAu5lwOhzkvy0dayo2bhUJebDZ7zBeTsr69Nd2it3AdPA4oRCFmD16b+a+NSur2b/dphDznB8lMREi40l8rgEwq+2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 10:07:53AM +0200, Michal Hocko wrote:
> On Wed 15-07-26 20:06:41, deepakraog wrote:
> > The vmpressure window size was fixed at 512 pages (SWAP_CLUSTER_MAX * 16).
> > Scale it at boot from total memory and CPU count using the same fls-based
> > formula as vmstat per-zone thresholds, clamped between 128 and 2048 pages.
>
> This is not giving us any rationale why this is needed or desirable.

Agreed, the series are all somewhat corrupted here (seemingly some patches
missing + not sent to the same list of people, unrelated stuff in the same
series, etc.).

I replied to the v2 of this ([0]), in general this is essentially the same thing
submitted by a previous person ([1]), and Deepak acked that ([2]) and agreed
that this isn't worth pursuing.

Cheers, Lorenzo

[0]:https://lore.kernel.org/linux-mm/aljYxLusTzZkTfnH@lucifer/
[1]:https://lore.kernel.org/all/20260227221555.29969-1-mcq@disroot.org/
[2]:https://lore.kernel.org/all/20260716134938.42495-1-gaikwad.dcg@gmail.com/

>
> --
> Michal Hocko
> SUSE Labs

