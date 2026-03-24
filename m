Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3655F54AC6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01A966B0005; Tue, 24 Mar 2026 10:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DE96B0088; Tue, 24 Mar 2026 10:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23286B0089; Tue, 24 Mar 2026 10:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2FC16B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:38:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C22F1A0158
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:38:13 +0000 (UTC)
X-FDA: 84581211666.29.DDBCB05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 17EC8C000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:38:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qIMNEe8j;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774363092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/i4Wh/1HJH8YsAfPieMc+KWkq/wh5T7GIhFy4oXV3g=;
	b=1qupz3AU46SYy7u+3gOokXQ01ek/ute2n9bovYBs3LwgR2Rei63lw3FEpc1kyI/MCCVwiU
	R1k1VVZuIwqUI4XkagMO/6B34iswqU1SFwEW7fYfLPBrwsO2Occvbmhsgt+8oyZkqp6Lfy
	I1WbbUIhwrPv+OfX1gNHGyl/iyERV+A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qIMNEe8j;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774363092; a=rsa-sha256;
	cv=none;
	b=Zq+ROJ+7auLBkxP2bIcz/w2gLdyOoKDeKCz0vYOxCowdAW2STc3vk6S0rwehQ1YJh7mrhG
	C6fkJ2JK1ka7H4day0+C4UFHTNHYdA+f/rs7Rg3uC4FRfYisaoAImnB54J/+NK/Ru8MgcV
	q/UvRaLGtX2fGTJzM4Dx79ouHJVB6tU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5648760103;
	Tue, 24 Mar 2026 14:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6B0C19424;
	Tue, 24 Mar 2026 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774363091;
	bh=e5f6jgo0dBEyQUURQKSWrpDzBd0JxDsZ01SMVL8k3SU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qIMNEe8jc/gh4IeEeHB78CDBRX8uly5TJ7AQbfM/aTBCdNlUClXSmZ3DGj32XYiJq
	 w3bJ+ggFkIa6py50tYHZOmCtQhawWtrsj76/eDZGqNTS2E6DEDw7zok6+dGEPnugh1
	 rN0pTjYTfRuusdcmWnyo9rBjiDrJMXTlzi6iUnqi2UkrzVyRfQZmP9Akgci7mz3F+g
	 QuGR7o1Khy+ZyGWNS8jwo3oNlwx2iL889bycIRnXzH46HhBhKml65awhc9OfKZRYcU
	 c9A/SwhXZceArl/7YVlb4KEf7T2vzd4jdb/0Re/Fh6+vKY2naQlBbaFBfS5NTPAKfw
	 5GaQjW2N9rzXA==
Message-ID: <89b0e46e-693f-454e-ac74-6e396183c5c6@kernel.org>
Date: Tue, 24 Mar 2026 15:38:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/21] mm: have mmap_action_complete() handle the rmap
 lock and unmap
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <8d1ee8ebd3542d006a47e8382fb80cf5b57ecf10.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <8d1ee8ebd3542d006a47e8382fb80cf5b57ecf10.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: tzpsnnuz9him13kwgoyf4ux9oeqf49au
X-Rspamd-Queue-Id: 17EC8C000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1774363091-477659
X-HE-Meta: U2FsdGVkX1+Vl0FWMiX5QKNSOVVv35wDvTxyc705L/luS7SNtTvlJtITdaKCiR4cpt4s9AQZ0Krn2gk2O7fANfqFs7AP7Emj8WMOFDUAZW02L3+na5RNzIFkEgq7n7JhNckl7iyn4OMUg496dNHPIV72sWijJ5EWl7jX6TMxEV2fxYwbsDdU4Xd3ZoO1hHiptZY4C73Z82YqS0Un3Rbja8qz6mxt4uQ/L/7VGrmp5wzMuwk/p9HEXEHqvV2xl5j8/+PQqD/hjbo9d0N/VckS7domRRnzX/p011LNk8QA7owuKiThVtu+GI0v41uJnuKREf69kRCqq+QqMihwHWK0uX7Gus3sYLYnifzvbOkAytqBh3TLeT/C+gIuFZexY+Ke7/k7Yggx4/3BxJtkZ/W5NuupkYoWb7Dd+IDy8kSbJAuctR5qSduUKnOLd8+++AQpG+MdXY+K5UkxDmsSFZOiCpiICaNJFYEtbRmmaGLlBfm/1EIpkDRzqG/M3zvwd4e5yrHaGdKNk18KKXwQ22wGQCQBwPmZT8G2fjyYMs9rKSZLiQkQjrE31Gk7P0usn4Fc7WHLXihvpCDdQDf8qAgj04IzekSyn8eAWYDcPAPkPhW0uW22lWYtRSJ9AThdsW77h7kHuMsPWpvYQnaGNWkgx+5zMUGqEb5scRsZSjQvRu0mizqp0oudV50THAS/TZpRNO8AgpyB72Kq2xksy33hkDGAEs0hJPerxIx+wVYDNlxXVTVb53aVDjKL7or6zWHotvqsQ8MxATByiujPFnkuA7JK7u1mghOd3pyD6unOeJGfkqX91DIWmWBE+Dxo71O3bQcNffrc64q/XTerPC1OmWnor+FHQfYj+K2HQMbqPTAKbLQpTZ6ZXFh2toIgs0IrYmsq3TFh3q3pzNWouzBzA6N1iioMg/dR5becuUhS9H+J/X/R9ilCoep6xlTblIuupds1QNGZHVpkoqCkKqs
 +Mf7kdhe
 gY4Wyp4C6BtCaSzu/bptT+pTWsetEbxsrLKyoQ3e+oK1PE2KQK5boQ5o+UrkhTHCN7i5jXgVyU3at2XY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Rather than have the callers handle this both the rmap lock release and
> unmapping the VMA on error, handle it within the mmap_action_complete()
> logic where it makes sense to, being careful not to unlock twice.
> 
> This simplifies the logic and makes it harder to make mistake with this,
> while retaining correct behaviour with regard to avoiding deadlocks.
> 
> Also replace the call_action_complete() function with a direct invocation
> of mmap_action_complete() as the abstraction is no longer required.
> 
> Also update the VMA tests to reflect this change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Nice simplification.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


