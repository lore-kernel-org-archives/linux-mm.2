Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB9A606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nTm7CQqg
Received: by kanga.kvack.org (Postfix)
	id B78766B0657; Fri, 13 Nov 2026 04:55:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49466B065A; Fri, 13 Nov 2026 04:55:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F846B065B; Fri, 13 Nov 2026 04:55:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 892B26B0657
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:55:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2702780164
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:55:03 +0000 (UTC)
X-FDA: 85429637286.09.435B1EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7938FC0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:55:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTm7CQqg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794563701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MbkTf9SgaS6JnGkuLQGav5/IuL/7zHaSNJGSKht4aR4=;
	b=LPaU0dY629kYu96F+/cXUYHI9EiBfbzVDGcvICasHclZT2yig8v7P1NjGnHipxA+jyVU7p
	4to0eP3c03m44EaRv4FKCCKq5GkAPIIluqRCacVxSIYA7brSVlA3d5IKkxLvccdklEuPDW
	YMfbYIMszXINPtovTY37w+UmGZoAORs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTm7CQqg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794563701;
	b=n3A/dEB+TRO9qKu3xq1Car996JGxCBlNz1sq6Y2/Hhh5YYRkfRmkCniriMn249UoO1CO/2
	JRVKSoqvurbkTR2wT9dlSVdnaE9YDn1OLG1LA9sW56oCPGOTa2rWpm/el+WFUXPTbeG0o9
	eolLecUexs5Qe2x57cHI8ufUBV9E7X4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9AE846501;
	Fri, 13 Nov 2026 09:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5D01F000C4;
	Fri, 13 Nov 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794563700;
	bh=MbkTf9SgaS6JnGkuLQGav5/IuL/7zHaSNJGSKht4aR4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nTm7CQqgUscC50x1W/0K6f6p5WjmeArjQ3CZ4rYnNtvJk+E6+UFqzsbtLOcYvxxh9
	 NSVXLyX+OkJEZfTAWfB0b0FPUFETUP6AKqNezfPxVTtfmWXryl6GbwEM5Dwg8zo1Ea
	 g1MMPQVuMWjOWdhxa6zb3R4Cxh7Zy5Vti2Pxt9XRXIABlaRVVYAmirTGN3DM0PT/Lp
	 j4oE47IhKuwUCKkWjP4OmGcu/JvHOWVNpo4iLw7/l2jdelrrq5KGQEYrtKWb9dg2MB
	 ykP47m6LDQEz7YbbciHItLFSXD6hq9xtVrlr1mDWvtAjwN/R45qUuYIfO9x/+/0ube
	 Q7BoHi7Ifj24g==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, 
 Shivank Garg <shivankg@amd.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261111-unused-sym-core-v2-0-3edc7fb8581f@amd.com>
References: <20261111-unused-sym-core-v2-0-3edc7fb8581f@amd.com>
Subject: Re: [PATCH v2 0/2] mm: remove unused vmstat and folio refcount
 helpers
Message-Id: <179456369702.3609.11370807693107108517.b4-ty@b4>
Date: Fri, 13 Nov 2026 10:54:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7938FC0005
X-Stat-Signature: an1bixce4pizj3x3mdjmnu8ycetknio3
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794563701-30586
X-HE-Meta: U2FsdGVkX19DPsc9V77dc9ErY3k3Sw2enJwgoQ4dvyYKQ8VkivNkSsCC8uSvjKIu6PHteIU3c6RjnC4l3p/92ANIa/yPQiWrvl1wofWKkaWfCRuFtrDw5uTLahSQv5Huoq/alBuEMXNx6N5MK925b90Mgy2Newh9uidfIjVklYdEgqcRlWJbbN0F8K9D2Vj0gDrhkvCCZOUhrTuiOgB4N+aqt5KGWfljjXL2RW3AftvhUmjvJDhr3FQCcJej/uQNcNWLTgpndnCOmMXIO+b1XUcQhL1lKIuYa1BZhhF12bkW+fZzMVpN5GODEeQZpDF3C2KsGHhWMWwHHOQovmro8k4zdPTPWDNllhXAx7QhHW3d4I3ldxfxxGvRNinP72aEzY8rw66LDGMb5DyiEIFPY6ZtyRhH+5M66ZsTLRlKg5/EW7seJ/oIksWpGj+Iuy4GQEtP0N32v9O/qhAC9+tO9bLXiveXqKzp5qmILhTSaHUXMBh5ruJPy/231iZ3OZKLf6bx+tGgn80QnrqowsnTQpyHw0/r5fT/aIrNI4/86HJkrh69gAhMWcw0EM5a0ojTzcIrGMLpbPea3M/pBcP2U9MDuWmiidhZTK/QOGYYTiG0fxKqvY4J81hKZJKCLPdn/67Qj2+B6obS98oDCA4Zg5Xr6axARhkyN91YsEfKHXzKuvDakJZekIWUJs5XbQ+GoXwq9Ku8d94dRaThsN7VDx/t4PCZZCuRpSsTrnYo3lVyl+orofxRTUZejbVwvqelVDPHmk5sxaZtqcq4/U83wS66JQh/LCM1lenI6FYyeO1mzdpZvkfFTXd2VZ+YJ/H4IZILuCA853NcjmRHNo+ImbmJw0VYElu5+vgWvGRtAdHseQ4hKl3N1HhRmqE/sRmJEFefl0qDd0Zq6qAy5wErDRxfLbR+f98JnP7rhsA9+tPi7/ztTjFubH+Ltza6P8eJg4NgbdTNi9QswH8N3YD
 PN6q4N7U
 E4k4X7Uq0pix7m1So7+3IrEY9GZL2MHrUGoEEAz2tbGYzobaabHLVGIn0A0ruseyhFtMVurrqVyGZYO+cLfSNzqD2/oQ+myzBDyrk5Xf0Vu36qCUBU6kzbNk3upeGIqXjH9ftLjlYPhEwBWn9Xm+BxyLa4Z8TBXtX3UQVwe6Tzb7OYLkmtFL+I7mkW/mWYQXw+NG+31e3fOyGtCP+liJExqkV3ajPlJOwgprsligkesvI4Vvcl71ZXKAO4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 03:34:32 +0000, Shivank Garg wrote:
> This series removes ten static inline helpers from
> include/linux/vmstat.h and include/linux/page_ref.h that have no users
> left anywhere in the tree.
> 
> I found them with the kunused scripts [1], which I wrote with LLM's help.
> The v1 cover letter [2] has more details on the scripts and how LLM was
> used.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm/vmstat: remove unused folio stat helpers
      https://git.kernel.org/mm/core/c/b5466234
[2/2] mm: remove unused folio refcount helpers
      https://git.kernel.org/mm/core/c/7b474ef2

-- 
Cheers,

David


