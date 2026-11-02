Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7168D60A5BC5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F3MOk01i
Received: by kanga.kvack.org (Postfix)
	id 93F206B05B2; Mon,  2 Nov 2026 03:31:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8916B05B4; Mon,  2 Nov 2026 03:31:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7ED6B05B5; Mon,  2 Nov 2026 03:31:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 564976B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:31:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3DBE40A6E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:31:47 +0000 (UTC)
X-FDA: 85389510654.30.A832E09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3481740008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:31:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F3MOk01i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793608306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwdGIJr7nc1SBRz4+tZnRkYunWQnOiReP0aUH266V2M=;
	b=G9JvwrCK3ZsfkmRYRokzTzsJpXSJ8X4154FQ5o8LVoAEVqzuANjE3ilQzJhlFimSRZXnre
	7W3ly6lDM812goQk8CN9aWy/GmQn9yGnrzL+74FE72jAOZTQuOaOYdjBYNaC7PKaSdXZgm
	XUrD6azsaQ+53wO+Tu2eAf148CPPSgI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F3MOk01i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793608306;
	b=CYkbvrugRP01KEFS0DowV6ig+eCsLyElP127JArbIL3wkzbw5GYXZHKGW8JNDZ6hJQrCdU
	eNcrEBChjK2rtTXWKuZkCso+cKKCrqhdExWOGBssabpX8yebSCW4B97SSNwJhnDm0u+VHp
	F2ad3mWJWioxtCO6ezC/8Ybln0i5yCo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62318402C6;
	Mon,  2 Nov 2026 08:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020C81F0157D;
	Mon,  2 Nov 2026 08:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793608305;
	bh=BwdGIJr7nc1SBRz4+tZnRkYunWQnOiReP0aUH266V2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3MOk01ibjv4ZiEyxo2w0IpriTMhVSlrszdHH7m4AmbY/AE6uXL2JohzLZkCjV2Rn
	 deB66Ak+wVZ941a/Ihdd5dfQ3SQOpH3V1ykbGFVdyLwZHVAxqJsiDeck5+cb3wx+oI
	 jJ+7x19ZGOL9Sphy7qONBS+WOzfxxZtHuUoa6BT4bycqa/xg5wTLDRsKjQsQrBpJ8E
	 NgYjY3IUz+Je0L15LB2E2OXA0Gig5b36LCEX/V8DL1MajOzpdR2rPBZ3WIUJkSrWce
	 l9NMNBb8vlxOvjEMUe6uFYnW7jMvFmUCAJ7dF+scPaiSV32SsGVGdbmYszggQwFkLA
	 v+CjwqRJO+MsA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH] arch_numa: remove setup_node_data()
Date: Mon,  2 Nov 2026 10:31:27 +0200
Message-ID: <179360819348.1332963.10620651236937996230.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014152803.740376-1-ekffu200098@gmail.com>
References: <20261014152803.740376-1-ekffu200098@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3481740008
X-Stat-Signature: 9npjiekeqppgu4e1p74yjpwm6k8y1tuk
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793608306-991060
X-HE-Meta: U2FsdGVkX1/1h9bQXA8jBR68/un7EP5oUF6Hl4F7uPMXoB9GnhTG9Qct5fa1fix41gvQCIL2KFVcVcLcim3Imxckg/V+3CzRsF4kbmGgs/MtXQQcvFUUtJj12LPaET8lIXZOYWVQe+P2zNr3MtU7mR+uv2qdEzOPGAetv/y47XcAVU8NrZLw5Xic3utAi30Kwbj5FWKU6FsYXHpmu1KPZoSWX0Ah90RC3WAY1zu97XERqrtwToAmqmRkc5mGf1/tp2Gkm4zGNeivd9ZeolHZtCcDMQgwr1WL8x2JhCQCRzQ4VAehKLpwRGHIwBuzT3b/JZhJSvgX6wwewO4mGeLai4Z9U7pqo2jPOsZi9TlKRo7AyZieDDwHgc4SaRP+EWZaYRXrVQFWD3RHQc92351zaevYgiPJ4bkWm791hde/dZl4FkuhmsEa7KZ8JTq2z95KzowDS2eTXhb5XAf7Mccl0WeUPxAUDCtCruwU4k9DsKNMUA9cYXrY6USoUPZ9Ksg1LwmYsF5s2zt2XZkvpOuTt/Ix3JHEg7pGPK4bhmL9B/uiMx2fjQrXMhLuzkmURNk04HA4/ettDM0WBz7gFeWpHNRj1iIeXAeF5ZZ1RSPiM7zg7NBGmnp0cn6x7NXjUODVqwOnXaBsFwh8eUZuBF/EcklY/aGrvy0TuYQ9yHOdgJuSXbmG+69aZcFSJdJHfj722diFwMSpDsOlkYV2YkA9lQrc5iDqJmBy4J6Tfuew4Ha2WDjAA1MRRxm7/5zMnJF1mhWlI1JlxQCGlYk6QXejhxGgKYksAIGHRJimA42RroZPNTI4jWA8E0/5Wt5DXAX+crvBbWDBqJs4UUyrdei4bbK1IprvHCDL7gR1ylE+vS5soviFPMfGMPeUz9PR3Ta+cRxNNtoZSjDD10Fh2jvnf4KEgbabNY1sPTmukyQYy3sF02dFk8yk0n0hqz81Fii8ZSrwgGojaMIGA1Bmb35
 pgYg3D+b
 k1ltZ60c0PYM7Y/WC3lBn+OXU6T0ws8VfvkVRRi7q2x1T45dDUGWoMGV5GMzsqzd04djrPLTLax5amqJHK1VNldQqTY1SmO+cnEaMS5KkSvpZmhYMkYD9q0qTcPQwPcEHp9yLelR7d9HjrDadfzgHujhWJ++lIxItPiuGeTXXkH4VkQsx1c+0PYsuEXWktZa+Oa3nhgjrU3BM+2dr8QOjjyNWi25WclSu9nY07tv02zU2TIZLVgml/vGtZliRquTpHaCNTDqFEDYcisv0ovTRm8NofzHPey0hJZd1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 15 Oct 2026 00:28:01 +0900, Sang-Heon Jeon wrote:
> setup_node_data() sets node_id, node_start_pfn and node_spanned_pages
> of the node data it allocates. free_area_init_node() sets these fields
> again in mm_core_init_early(), and nothing reads them in between.
> 
> So remove setup_node_data() and call alloc_node_data() directly. Also
> remove the log for memoryless nodes, because free_area_init_node()
> prints the same information.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/1] arch_numa: remove setup_node_data()
      commit: 067dac36cef09331f79c1c5d21e4fd9473676fc1

tree: https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock
branch: for-next

--
Sincerely yours,
Mike.


