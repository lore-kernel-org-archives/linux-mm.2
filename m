Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EE0510ED67C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8BB6B0098; Fri, 27 Mar 2026 10:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB02C6B0099; Fri, 27 Mar 2026 10:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6096B009B; Fri, 27 Mar 2026 10:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD8C46B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:00:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25D291B95B8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:00:41 +0000 (UTC)
X-FDA: 84592003482.20.82048C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3FC1780005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:00:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ta7rAW3S;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774620039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z64rF88nkaL02D0xpYt41g4Jy+G/MCPHaIKDOuqTL/k=;
	b=cYhn/uxaQ52MzDMy7mnQbawG6pJOAe4PVvA4QCKqev/eTQK/xN7QLw552z/I1FuosVKZu2
	OazeIefGIbfzpNYiLp8yefuEZCucWYfLhqRsJsxbgKw6MYqfKQfTHHYwABHJjxZncAtwT9
	MC7LwbX/chC8oZQ838mOgr5T5eFT7+M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774620039; a=rsa-sha256;
	cv=none;
	b=aYy2sV966zkWx8CDT3TUO1OJrXBdE6V65v/Rvmcw964e+ITQlqkliXH+xoHcmI3R3hmRM7
	5qD6NyZ6uXT3y5NdlwplEgIrLUwxlqeWcRzdY1mC28H/DKTSlkpeEuVcEjh9jVQRfKJ4PC
	ELWyW8Jvit8ioEUYrhS+tWhfkphHHlU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ta7rAW3S;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 32E0B43BA5;
	Fri, 27 Mar 2026 14:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BECC19423;
	Fri, 27 Mar 2026 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620038;
	bh=/unA2rMv7zJScTAFCck5yVo7oEcK/p9cQsKiJOFmMDw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ta7rAW3St1r5Ta+mqH+8E/F44wq1jFofriTxgkIBtEHEKzBdoeF7s5dYhDWC0gxfK
	 MhC120MTchYIgtM/zFUCPYoCchxQ/woQf9RUzHrCjzYEzocZagCoPqQowIYC3gUvMM
	 BISc3e5TQuVeSGr4XyFwiU0dlvqA4YW7TT/liydeHG2Cz+D/SJ0NrMbFZeSmZwLPxM
	 Ot9JwugK/+SnnsGF9RaTWmpf09/WCbapmLMA8nGMGuCKr6Jf3jh9I6sxkIiWStaP64
	 L1+uPPvuolinerWe/egh3yHME0c7LDUvlAljMTzJA3jTKkdc0VVp+I8n56senwsiP/
	 L7QgdTV3RndhQ==
Message-ID: <abae6b28-cd67-4efb-bf4e-d9e33182a38e@kernel.org>
Date: Fri, 27 Mar 2026 15:00:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/10] fs: remove nr_thps from struct address_space
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-5-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260327014255.2058916-5-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3FC1780005
X-Stat-Signature: gxjm89br8grmh4ubx5n8aawn4efokdxt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774620038-293261
X-HE-Meta: U2FsdGVkX19Mzlyoa9E4WYU+FngmHtRjnAKSIakovzXXb7Ut8804CSKRO8T+Dpt3jJ5LHdlB+z3/G9NHy6cVeaFbAFfHJksmQ9VNZVFa5v1fYW1qnv3PIdXMr0lTIVEihQD+8k5obaz/EGs1WCXz9pDk3OGETvrU6xSUdaYrk0oAhGuMQ2sze4RfBrePCkGpOCA+NQFdibW6Bp4jK8+nul6CjXkK/fv7XhMI5bS+XG3UquWNcjTU2jQRbtruBlNm3QI294yyOit6f81gDYq5Pq48mtt/Xh4+SfHzUpahzkpGUHgXjieq3s5skyBrr2jOTiCO2tVDPZhPCWfZzpASfDHz3/38V5SabXhReRWnJclaQ1Ny0Dg2vGlaMPPw1q7ZkgcTPK02SoW/DeKcGs5IN3u7dHb+ZQYDkI+GKp45gcL4BBS4f7IXE8ld07kbY/QkYZf4tW5FxkZDphvlm7C9hWvWgJZkhf+Yt/DruxwJ7YHlTWthGuZdEmXQm9PcPD5+JQqxawLtrCPaB1c8y2FbygYDiamWFNOtWDqyKlFV45/ovUte8UZKXwNF2TiTHUebvS/t3rav82zNZ4wXJcizQLyLdytu0Qd3KExTl5r1gk3nv/tetK1nqKvohFlVL/Jk1PQGjm79fKA9isOQShq69D8nJAYSkZs4A0wmMgc9o8pNh1VAZ6BcUpePHwyF6XiYFXPPb86VXHbx3s/PcJZQsD8Qmce/851Ew7mKgCoztLIwqAFsOukgTHK9NRXh4zAGNZsnCrvYphpP6l6f6qNIiCtwNRWUqKLFcfgtzZda49ibSOe69RjbZe2znsH9ITp/fAaBcnZChTa4FkaqDUOpNSXrFDEmNINNrZcnzG36AKEHxUqRi28ScRDRGYvNZVgxAYCt4TYT84krFMaZCaytJ9XQUeG2wyWHw2G2yExHuSqxB0z8q3ErH2aaT168FqKv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 02:42, Zi Yan wrote:
> filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
> is no longer needed. Remove it.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

