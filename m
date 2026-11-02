Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C1F606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dB9WMfe8
Received: by kanga.kvack.org (Postfix)
	id 3E9526B05C2; Mon,  2 Nov 2026 05:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372A96B05C3; Mon,  2 Nov 2026 05:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2621C6B05C4; Mon,  2 Nov 2026 05:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F171D6B05C2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:19:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84036402CA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:07 +0000 (UTC)
X-FDA: 85389781134.02.ABD5F59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E7E1E4000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dB9WMfe8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8ZxaXME7Bo25b7JtSuwLQt4lbE7+wAcQiQGdsNPSzg=;
	b=drTsgmkJGl52q8oVNt1PQIGnSnNVrQwcnGPD00pLoM3MB27YPgI4PEf4LaQDaLiNGiOd3l
	h+sENmKrouFIIy2LfIa1FfJ9hdIGDyPEzQ8EpN9XxRwWfE+Jo/qmJrso2jMTacIlTgDsUy
	a1WJY2S8HhFwvxxbahOSNxt/I6lU+iE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dB9WMfe8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614746;
	b=ozvEcjMW75G+PKUDWGB+RIXrGIieVMM4jKme0c6ZrrydhDoS3IPb9C+/I9gmCDiSDF9jJX
	zgUBRBfQJcfpytY952bW5YKerdnGSV556JizvEAPnVJqBza+BpNjGVRWNFQZYCkbUZ7Awe
	P1zI4u6tRHCe1B5MoWxjBMbgL6VGU5s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AF86444F4;
	Mon,  2 Nov 2026 10:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65421F00A17;
	Mon,  2 Nov 2026 10:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614745;
	bh=a8ZxaXME7Bo25b7JtSuwLQt4lbE7+wAcQiQGdsNPSzg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=dB9WMfe86WuzsWLNIhLfLhFiI2gB/+s6SmyhN0CAvIfXFd7LcmuTtmqH40bTQanvn
	 1RDFlklIEI6gVL8kqPGOsMlxNzqA5fb404W9aA4h+Jvp9HGScx/faY3DvhQf2ECaq4
	 2uLwIwYKgsbbil9xGQ6ntRlX2MI1djgNxiTrUCI8il8IGo1UlUwdiUrWA4OAp8zIS8
	 TqIG4zhpCxyYobaAgROTkzMIfRikJc+q1k2+NMz5yqQ0rlz8v6hUKGB3PQmB9nqcXL
	 R10wr59jiL9dHZAXqzK10kmRXl0jqDfR4XM2SLejF9wAo+ZmuhUS80GXWZ6jR6cAig
	 khieferF5zMtg==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 10/12] mm: hugetlb_vmemmap: make vmemmap restoration
 folio-oriented
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-11-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-11-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471105.1337633.13890106172591126826.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E7E1E4000A
X-Stat-Signature: 4rdeawqhxbi3kp4h7tgxihded8hwqd4o
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793614745-303890
X-HE-Meta: U2FsdGVkX19JnnFJqNFczAcfWfI/P0eSOnoP4Y5IwfwGC3rJ8uL3a471iof29jFA7cWc6nUNwcaFis4g30IV8iah8K2CDFqJxb0ijdq08QpDEpbmDwtieZi4VqT4hljV+yLd3bxAGpG4e9HlC4kq6vTzyvTpp7Lnfp7TbhAijIxclR+eT8f15r4j2vjFgWDGUD3HH7XDTmDA+QZyF0ndcOBDRXZqYzyV7ntAgS7AroaR61yr7nHoJBFhoUzPdld4DWd6p2HFWlNrIos/Naee0S+76EilKeq1HBh86UPDjvHOeVMpzT6UJWl/sp/fijrbUdux2at0LxebF6SaANoWM5uofNWa61bO+lr6Wocr+gbwaMioAhXPYHgEv9qF4CBFaXf7J6Fe0lNRP6lA4w64twFu0wJDy104OXBmc0/07o7Yt0h7h0Nlylv5UfLxi/zqeWTjv8mewm4TF0QxzWB/357IHLIxzntJeEZ2JE45pGkYbOljYxUBgxRG/cps059usLZQyudIEzn2T+MgZKD6um6bdLlSBjrIjacz95yOTAucQrFwaxG9crvcGY2KMHxo2L9JsqGtJRP0Pea0r1Y2bIJaQJ6xG37vK+zL75/3NKhGBRDdHuE1Tr7Kq3zCbvwYxrchcxVb1tIVkqCqynFAD6q0OZfgYi3y3T1F4CZCchmruQ1so6SAA1PzJNkah0VGPtiR3SrLYQjhKgUokinObaPt6Tkak+V+fmC+z1Q8MBXBDo89Lju2QIEmHIc9n+h1ooWtsAkP773aVCSdo+uOQB044Tjgr/bUV7S+pIEi027QfhQZ22WbH/dZ7e2M+abi4X1TQDYcfj80qF0lvjYJeDiTHGFP2HtuZWKb1RoAndJuo9Kz5lb7GKGcdxyJqQWEmKnP5bp8Lx2Nmo6E1Mld58iRyW7+V2HLAPx2V2Xat+E3HyB/Ylzy87Z01+DGebF8at0LP4jgZgF+AmLCV79
 o7JSYfDJ
 i5Yw4r9r7GPZYlXmI7KRy0vAruM+AZ9wPA+NI4ZGDaK/HV6pUQyVj9pfwVNxoU8Zqt/fopgyZ3vu4WWBqLjh3BbykVcG4PE80l2k+M9flidsfbibf+KOKO5SGfONzTo7dmlCazeNubtk2WKQCRLH9BfgX9sMhzgYYqVXD5+8jsELn7DDSFF6eLL70XmpcYmyBHXw1dGtnLF1gX6zCHkiNafktEZGjZm6+yZYPXHm6FI5bpw/246Mpwr3go/4EDplLVZK8y9HEwVtASidDWO47MtEd435lzhTIKJS1pmQM7aM8oQQE6zPNfZwVrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 11:25:23 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Like optimization, vmemmap restoration operates on one folio at a time,
> but the current interface exposes a raw address range and requires the
> HugeTLB caller to prepare part of the operation.  This splits the common
> mechanism across layers and obscures its natural unit of work.
> 
> Make the folio the unit of vmemmap restoration and move the common
> mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
> eligibility and state in the caller and gives both directions of HVO
> consistent folio-level interfaces.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


