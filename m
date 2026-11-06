Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F638606D80E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NoMaartx
Received: by kanga.kvack.org (Postfix)
	id 7F29C6B05BB; Fri,  6 Nov 2026 09:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C92C6B05BC; Fri,  6 Nov 2026 09:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7069D6B05BD; Fri,  6 Nov 2026 09:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54CCB6B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:00:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0F6BA8D4E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:00:23 +0000 (UTC)
X-FDA: 85404853926.23.6002661
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1A75040017
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:00:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NoMaartx;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMisgwf5ivCyneAXCg/69ag5tUf9sccmY26a8c7FNEM=;
	b=GG1b6Y8WnYgN99C7cGkM9UyFz6bhzUFNVbJZp8JTzWo8+0Wl5CamcfTdEqEOclCW9xVPks
	wDnV8DVlePmqp7mMiYOdc+tleL1T2Bf+hOb1YjMURLxEydIggd2SD5zaHL1bR3EywMfECt
	aP+yExqfOCUCVESnUCsIQ9a65cft0AI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973622;
	b=KaE8CzrbS7hxiljTbu8CPokuj70tmbw8vB2qvE2hEo8rlN8z7OsG35kLlF1/cSIXlFRMv+
	n4LMUhojlTn+bSoZcm6z1wXKMZNf0iP1p40dEi8gXx+SR3PAX3TsQv9cFSo1o9891PetUL
	OjcoVoBSmI38DCv0EIKlojg6nB4jL/M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NoMaartx;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9826D60D0B;
	Fri,  6 Nov 2026 14:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0DE1F0089F;
	Fri,  6 Nov 2026 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793973621;
	bh=MMisgwf5ivCyneAXCg/69ag5tUf9sccmY26a8c7FNEM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=NoMaartx2k1NoDKHbinjDj/PbXDYhvLBDoS7ThiZ6Zh8degSdrM/cbNrjWCvJFPXn
	 IJa6OLrwSv7WeMgzoB3AuW/FePKuMzJwKFHbXEdI+ZYAwQGc/8vmhnKnmMjWU6LJ9x
	 33ovPBGmrTbUtWQlZ8QAyW3GCySDsLz5acI0WwsJZ5luc2SvTKggPaXxOHYrDVTmU1
	 D0Syu1/RiDILFaoQPgpwI3BeakKZgA8HYUcIZbDXsO1DAvgiVgvpXqbRHAyOx0m8ju
	 kJuhvtjsTeuWAZga6LkTBCYXNU81R/1eVeG/45nAIROGbzedXUk1SOmtB8Ud+4XU9q
	 KBbQqwdFHF80w==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Qiliang Yuan <odys.yuan@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20261105-bug-mm-shmem-undo-batch-v2-1-ae5f89ced044@gmail.com>
References: <20261105-bug-mm-shmem-undo-batch-v2-1-ae5f89ced044@gmail.com>
Subject: Re: [PATCH v2] mm/shmem: remove truncated folios from the page
 cache in batches
Message-Id: <179397361569.3706.17727764242079446039.b4-ty@b4>
Date: Fri, 06 Nov 2026 15:00:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: qae5atnee4zzr6qktgzu8q48eqhhz7xj
X-Rspamd-Queue-Id: 1A75040017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793973621-665525
X-HE-Meta: U2FsdGVkX1/544KTkOGXQhVOWh7iu9NTWmDQHP8tgil8YU1coYYjmneqahT+PlnVU3d+5uZxP7BDPDOY6wJgM7BTCvDl0CruddQerX/757Ukk8YuvJjX5OdtFWjd8tR7glCpxppiQ9MG3AThH2f5VUAzRzW1y90rbMbJ0Wu/tx8QmNfEqj1QywjDJl8LmrZNJIegFw4p1GSLEu48dDE7w9Uc3qduff1cd1a7AI0WkgAUIoN8hSyRSUPHWF6bLK0XtkEf6he4pkhQc9HweKmgtrHJLH2TVl6cpPB/ljw5g/02nF8RQJce8jit6p766R3EOkNn46Q3kS89oTMao/I30fNK1nbY3L7Q5FVwIGO6YfFhKkcuNNp6f6IR63XCUk+LC0m/yaCB8CVnUmSXYPSiBthhMF2nZLxjZRsRdXVNBsX5AUGYmgI1AHMepRJ+mW6nvV06Hp6X2z9dBzTAxQiUbwny1AAcos6M7NvWJ/Ha8/oeT7kg4CTo657c4YFlhqXp5hrlgxYRfQ8Cvl4aCwAYMt5qTStDxr+MuP0I9yqYolzQVUtG135SzJiIVw/Gk2EOLEjmwMjLQqaLU9hoHO8F4r8JhNboeC5e/gMaGqfxB9gzclp5CfHimU0CEh6fsLFKGiE288OG9med5Ro6maa1AON9+HeDyLjUIX6ImWvNWFr98eAMCEObtsI+VVZreAwoRd0DLvD9yzQLg5KnFH5e/Eg1CeAopV+Wb+k6kxU15WxRZnIiRZOayExC5UwmebL0PtKATDUiYQKGlE3cUB9C0qxYYfOa4F/XG3z1xMKMK2ZP1ph11QwOxi3hRroek6Y+f5KxteNItK8+Atdr+m57cDFS/7E4/jqyknid1mIhinWhRLZAB4u7+zv4egifHoo3o44gFokLJOoP4jwn9ORg7blFt8/OIYraQqiXBIo/5GkqyE73u0GLtP36fWC3JjPvGY+AYDG2xI9EgC5Ghj+
 UM2u9kcr
 BFaWJyTRFwZRWPQ5cifiJvcTM20dD0tw2PCQm2JjLDWeTLmGQe5ktbuzcSCjfpzen/T4xxrzCPCHt7GI8970Bjlu81o/O7vvxlAnkS4Mbzb13pH5OV70mUzHg3JWmD2k5A/+TENguxNrmarixQhpVYcqgMYf1jbf6Qj2r20kT43oTjiLaPHlr/AXpyp1lkK3SGZFnxcQwsqMQ7U683vJmyhS/3qEPbahhsbYCv+RwvPWiG1xCDcXYXe8RtnOIrGGCru4YrsxM8k+IZXahot6nqYhv9fG+TkTwV/6MtfYYzgCqcMGmAZcPo385mydgKW2xkf4f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 07:32:11 -0500, Qiliang Yuan wrote:
> truncate_inode_pages_range() takes the folios it finds out of the page
> cache with delete_from_page_cache_batch(), which takes the inode's
> i_lock and the i_pages lock once for each batch of up to
> FOLIO_BATCH_SIZE folios.
> 
> shmem_undo_range() calls truncate_inode_folio() on each folio instead,
> so filemap_remove_folio() takes and drops both locks once per folio.
> Truncating, punching or freeing a tmpfs file or memfd made of small
> folios, such as a large /dev/shm segment, pays for that on every page.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: shmem-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/shmem: remove truncated folios from the page cache in batches
      https://git.kernel.org/mm/core/c/b97fbd54

-- 
Cheers,

David


