Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B5DDCA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 21:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC07E6B008A; Mon, 28 Sep 2026 17:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49806B0092; Mon, 28 Sep 2026 17:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F456B0093; Mon, 28 Sep 2026 17:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7964C6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:49:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0DAD140353
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:49:05 +0000 (UTC)
X-FDA: 85264511850.04.EB4742C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3B881160004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:49:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=feAestUu;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790632144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3WIlg48jq+OdGmyFTLD0q+UgVG01A/J3xfyeSMGXSDw=;
	b=0xu/V/FHdIZPaNUETEe3cBp5LcjhzQZg9J++uDTFHz+2VAJNxidZ2yKJl5IAy66EIQmnhw
	B8yqyWuVaeFbmCyYZcTACxT0H5YOcu9wMFs7o2tqUkOyr6+oTzMybfTttJ5pJQUMQf97cH
	Ff45tK56rtpBlWCc5F7s6CfpTIND8yc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=feAestUu;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790632144;
	b=sogRrTlkVwi0lwJSCHaSJMYwEtPBxpmc7rpfSJhC/0rBIFzh06HXnmJCsulWz/pYCfy2xr
	lpnRZZRSHT9oDtQXXqfpalp5TkPwaHVCybXQ2ECvhwSRpj7u1mRAw6Vwt+WO3EZoW8TlXV
	WQUG2VhFJ6GSaDS0poWcMZX8IthT8Zk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51D6360216;
	Mon, 28 Sep 2026 21:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC331F000FF;
	Mon, 28 Sep 2026 21:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632143;
	bh=3WIlg48jq+OdGmyFTLD0q+UgVG01A/J3xfyeSMGXSDw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=feAestUulsqsuBSPGIlO2VX//eoNiX6ebVnMrzOQrXC75XaMaoleISH7l/f/opQWS
	 QyQ459/S4JGQ3RVgtFsXV3jfjtlNz/3L6ancyAJo3rjmIY4c88NqNg04H3na4WNZes
	 fycVDEgUJtOlEWNKO3tSDXJ4ZMptbzGbPlhHp4Zg=
Date: Mon, 28 Sep 2026 14:49:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
 ziy@nvidia.com, bfoster@redhat.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
Subject: Re: [PATCH v5 0/4] mm/truncate: fix data loss when truncating
 straddling large folios
Message-Id: <20260928144901.83cc90357c9a488e94fd6785@linux-foundation.org>
In-Reply-To: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B881160004
X-Stat-Signature: akiqrgh8ujnzr9jc88y4xcnigphycc8o
X-HE-Tag: 1790632144-952831
X-HE-Meta: U2FsdGVkX1+7rMTNk9wqWUnontOFx88QK+e6FKx8HS4YmvqCn25xHI+Q2DACdubzMYZiSQEmPXJSGsK94D5v1yJS5j2XYXoHIklgvQj5i2mtDoLSBOYgqopMrqQwaPQpRtiK7lCrnAGaJqk4uPmMfltVq9DzfUKZQwW/pKsFjX5SWbBO4RLIb9aPWWz/TxXXkB7gprxBwJ4Gxkc4u2/ThJaXY5i8CSL+juYeFPPnW+31pLWxOOh9HmiCrHHZENlPxWg44LkBoA5Tc3up5vynshanO8eA57kb9V3E9RUgz5F+blly+YIcZrfaugG5mwfdB79A+dn9KY846MZoZ/y7JYUlm6Vbr/pi/WvUA/it7JvrI9IGPVtE7ncm6VtzO0q2yAzKDWRoQIZGDHxPTE8bgtubP0+/2abQBXHFcccLXnM1kOwARG1CTUSHf1sBB8Nhwn6FB86WOhjTEfhuYHzWDt7F63pNTmHXTKe2loPXxSeWrULO3AGEFgSjrLwXiuasYbOXsiM7gVJ+xbHNR8gXDmlqTEXs59nTcpF4L1Tqkk0bJZXq9IGB8jEo8GAZeEqgehuSDPIHKIlTpQJVy+zkuBNZNF1i1u5yREPksFv+3LWAr95iIddTVs8E14UaD56T1XZX7vSSU+Id/B/qEUbpH7XKbtWWTlbUFOkHK7G/CSFTZYW4bue1kNk4DiLx1TU6EPT8a/RVqoJiA8/9g2FmRTXZGhWmQLlyqIyVj4JL0jvOXvS3N7UaXbGXXdSCJgGxKEyL8Q/7/fYY0X+SKqXMwqiEeVs7PQIUBEAyPR7748J2UTPkHCzJySFL6dBgHTtx9BiuOlpTfDjNTPewZ3KzsZaYnZmPr3nKWs5GbIvjhI4EGV9gjLzvlQ+B247+ABJuaZNQ9TnUGPejG2648auW/pc+JeRgm93S267Mx1EiFTJCi3abXcGdS6xWI7H9yEgqpERcgB927qwjb7TS2j+
 Pq6PLs8l
 0c7TbhNmgqX12gesIpptsjxoWWq28X/dLNrVQ/pjSHcVEkLXgaCMjMNBsKgMYpju3xQCrBORyYcsBY3RmdbftfzaZz8ddX2sdukELyh/65B5zcITJrSyLJiLircZHXatiEtIqYid0ippi18FJk+n296zKM9Ckj2jkvKjhiDFM8OL+bnLK1kNM7peXynYdeVNa/oz7rOJTVOvb7yOAJuoIa9CJQm7uE0mlybx7cXUkXvcT8J0hheu/As7MUUDO49wmBHAfYgjXUpxA1Nga0jcMDo2D0qdGVVNl6cZeqdzOK0df0xE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 20:08:29 +0800 Zhang Yi <yi.zhang@huaweicloud.com> wrote:

> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Hello,
> 
> This is the fifth version fixing data loss when truncating straddling
> large folios caught on the upcomming ext4 + iomap buffered I/O
> conversion.

Thanks.

> When truncate_inode_pages_range() punches a hole or truncates a file,
> truncate_inode_partial_folio() splits a large folio so that the caller
> can drop the in-range sub-folios while keeping the out-of-range tail
> intact.  This series fixes three distinct problems in that path that
> can each lose the valid out-of-range tail of a straddling folio, plus a
> follow-up that clarifies the return value semantics.
> 
> Patch 01 aligns the truncation boundaries inwards to the mapping minimum
> folio order in truncate_inode_pages_range().  With a non-zero min_order,
> folio_split() stops at min_order instead of order 0, so a boundary
> computed at page granularity can land inside a min-order-aligned
> sub-folio and the truncate loop drops that whole chunk, valid tail
> included, causing data loss.
> 
> Patch 02 looks the end-edge straddler up by its page index through
> __filemap_get_folio() in truncate_inode_partial_folio().  After the
> first split the straddler is unlocked and only transiently ref'd in the
> page cache, so the page pointer derived from the original folio can be
> freed and reallocated as a different folio in the same mapping, and the
> mapping check cannot catch it, which may cause incorrect splitting and
> potential data loss.
> 
> Patch 03 reworks the contract between truncate_inode_partial_folio() and
> its callers.  If the second split of the straddler fails, the function
> reported success unconditionally, and the leftover incorrect end
> position could cause the truncate loop to drop that valid tail.  After
> rework, it tells the caller the exact page range safe to discard via new
> pstart/pend out-parameters, so the truncate loop never touches a
> straddling folio that still holds valid out-of-range data.
> 
> Patch 04 clarifies the return value semantics to "at least one split
> succeeded", which is all the shmem caller needs to decide whether to
> reset its scan loop.
> 
> The second patch fixes a pre-existing race issue that is reachable
> today, so it is Cc'd to stable.  Patches 01 and 03 require a dirty large
> folio that carries no filesystem private data, so they are not reachable
> on current filesystems.  They were found while developing the upcoming
> ext4 iomap buffered I/O path. [1]

Can you confirm that [2/4] will work correctly when backported into
-stable kernels?  That is has no dependency on the other three?



