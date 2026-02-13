Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0557EDF144
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 10:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2696B0005; Fri, 13 Feb 2026 05:20:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A99E6B0089; Fri, 13 Feb 2026 05:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F156B008A; Fri, 13 Feb 2026 05:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E68B26B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:20:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C69158E70
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:20:46 +0000 (UTC)
X-FDA: 84439039692.24.72FA905
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3E713160010
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:20:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S4ZmKQUW;
	spf=pass (imf08.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770978044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zuulf5kC8dVbyvKycXKA+/WFHNP1a1cf2S6fr25OXMk=;
	b=yUOKWQQ+TjfZJNj+vjN9E9EfMQ/rBslqmaMuovlwEOokBKNW+f95FedD36kwihQKyfocQS
	ajw+u+AC/QHmkx5nIumq6tqzM6Uk4GravjSsMhdrOREdF4AXpaACianvY8GdMiABdd4Em2
	Dcr2BJtQwGb8N+Go1VkFwsD+dEZAefM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770978044; a=rsa-sha256;
	cv=none;
	b=jqhb+LrlHPyo8QG+YWlHStZjpOyGUEa47yNzQx5xFflNlk8+HilW1j7DD12BH2vRtxrlkk
	Y1XmSc77KlnIW56LwVZ35C4HrlFY3+InfSZ3qD1/qKkZwURaUWx0OCF/eKPDIRTOPOHuOd
	nmZdYPEXikhi5GSsWYLCDUjECTpRWg8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S4ZmKQUW;
	spf=pass (imf08.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770978041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zuulf5kC8dVbyvKycXKA+/WFHNP1a1cf2S6fr25OXMk=;
	b=S4ZmKQUWfUTzcb+l80Q3gDvuoftWI4D3rknQ+3HONyVjmERdEHXtzqCTluwLI3lheRxLkB
	BedVdLXVMBk7HVoueNB1Pb9741D6IUfEDuJxSKHD9V+qk48Dxpa5sm7ZmzksF12vhQPDNA
	9IU6Q6YuTOt163xQnbmzPqV5XP0hI7c=
Date: Fri, 13 Feb 2026 11:20:36 +0100
MIME-Version: 1.0
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
Subject: [LSF/MM/BPF TOPIC] Buffered atomic writes
Cc: Andres Freund <andres@anarazel.de>, djwong@kernel.org,
 john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, jack@suse.cz, ojaswin@linux.ibm.com,
 Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
 Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
 tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
To: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3E713160010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u5i9d9nxqwws4fsnsoz5sky4qksjgfqe
X-HE-Tag: 1770978043-563668
X-HE-Meta: U2FsdGVkX1+SJEOt8eldML9apQvNvuKFkZYa/nv6+wQk0pzI4DwQ0G/H9bJumIk4854CDvVgrV1AlkycF6Szvo5JWhGLLGIWjjZPtIBoEfafNM5W0NlHhUEZjHH61BZfmXXshoBUXNiqROZMX4dIZlURa1G0+XIL5/cpyBN1TnsWC1VUwn2Wkn1RvPm/3XG1HcK3KgV9Z5Et7iGX6aoN686aUBwJQIj9q2IVrDsYaDUhLupYOuPUYSnoCdoIEvZPf6qyvXhcF7OiOodZfP6Qjya7c3xPL0wzvGQov+sJfxYL+rXjyXO8jRWKYy802dg/3SEuCrdcO/98ALGjs7VuPNl6HmGAziFNTzf99pI5eWnozx/t0csVbiTkVHGTQGfrHnWy+EBKrPNBXPnU7zmlLJ8DJSLw8OrBjqunOlPAuPsmhSRPXeZSRiE7PAISX1HDdhZEUm+KzD9P2XjSVeGkvBqXGP/ZaJBCwbdk6nMDDLDOksi5HeG29soUjhIZsXZAJ53i23qAhXGRo8od9MpXJQ/wYa7ntxP7TAW59P0VLi93tad9/ddcm0xv50f6pSigDQvWjxWdb1+bIw0sSTm5UsAmQQnYZZYtK+n7RVIwgre3VI1Ursdv2s0pzHb6UOMf/Rrp8afM5EtmNRm4EWrzwoOvamvTXNIQ7kY8MBb2cMF+6vj6m9xrriVHgynXgj+WZpi5zHHNnFseA+4Hw/+kO1b5aFrsR2HTzOHHip0s5ckrJ5Y8LKiXrm3FFJj39ZIfH824aI6QuGmCChdsTM3y1Wk20uDxv3E3A+grb8EtZhgmhI40JJeipkIcmrWN28Ns+guH0oAOT5UDNCc2EbBAygs+k/QYGKDk9hQgFK0+bmMotV/NrYKQP8HtqAhVSi0h5R/c8mYml0mC2AroOPFOZgBJB58lhVljOlwa9uaHBn7NVQcRHN8ZHG68e5NuUla6bIjfsxmWW1Wb8Biuyhz
 fToRJkus
 qfZVOMbbT92Z1RNS1rGokXkfs/1Vau8BpjliXIc6NBT0P1C1h8DpKOinw1OZQXtasTRk5C6oXaIN0qn9iJxEsgo2kr0mSV0vQUquK8e5e0HoAHXp47/WZOof3FLpZQb8jPRkHlzeggnNT3mjV01xSUMkTaTFZWr0TBubsLRLYacqetZ0PVWyONyfEZNO+dE1o2nz0fBhhABy0xp1NqZL407r/l7WUO2FOFrCb/vcNbAAVPv1yoa6Ti0cwe0P6GtndnekIIacCU8SgVudU8pP0bq2yQ4ht+d8wPPoGwPv5qu2SYRAMb3kkCe3UygGMoo8iasV/GMmxmkVeeeuyxjbDNOWA74KeXSuoK0zZbsZjeOFpOufBNxT8RTXdhUAz2s4XIOk+hq2VRJ40k97/Xg+yAGeONpbMuK3cTOf4mtfJJbzczP/5rRrFPbV4TkgeW91NmmJpiySaW1ufy2e+PLoq9CxY1wjS99iFlL73sUm7WJ4g0iPwbzxxp5/By96jzJVBv0CBjz/ZXzR+prnf1NoP2K1r9Qp69FfTeo/l+iVPAvisgEOjOSHa5uU+4dUcyDLq42sS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Atomic (untorn) writes for Direct I/O have successfully landed in kernel
for ext4 and XFS[1][2]. However, extending this support to Buffered I/O 
remains a contentious topic, with previous discussions often stalling 
due to concerns about complexity versus utility.

I would like to propose a session to discuss the concrete use cases for
buffered atomic writes and if possible, talk about the outstanding
architectural blockers blocking the current RFCs[3][4].

## Use Case:

A recurring objection to buffered atomics is the lack of a convincing 
use case, with the argument that databases should simply migrate to 
direct I/O. We have been working with PostgreSQL developer Andres 
Freund, who has highlighted a specific architectural requirement where 
buffered I/O remains preferable in certain scenarios.

While Postgres recently started to support direct I/O, optimal 
performance requires a large, statically configured user-space buffer 
pool. This becomes problematic when running many Postgres instances on 
the same hardware, a common deployment scenario. Statically partitioning 
RAM for direct I/O caches across many instances is inefficient compared 
to allowing the kernel page cache to dynamically balance memory pressure 
between instances.

The other use case is using postgres as part of a larger workload on one
instance. Using up enough memory for postgres' buffer pool to make DIO 
use viable is often not realistic, because some deployments require a 
lot of memory to cache database IO, while others need a lot of memory 
for non-database caching.

Enabling atomic writes for this buffered workload would allow Postgres 
to disable full-page writes [5]. For direct I/O, this has shown to 
reduce transaction variability; for buffered I/O, we expect similar 
gains, alongside decreased WAL bandwidth and storage costs for WAL 
archival. As a side note, for most workloads full page writes occupy  a 
significant portion of WAL volume.

Andres has agreed to attend LSFMM this year to discuss these requirements.

## Discussion:

We currently have RFCs posted by John Garry and Ojaswin Mujoo, and there
was a previous LSFMM proposal about untorn buffered writes from Ted Tso.
Based on the conversation/blockers we had before, the discussion at 
LSFMM should focus on the following blocking issues:

- Handling Short Writes under Memory Pressure[6]: A buffered atomic
   write might span page boundaries. If memory pressure causes a page
   fault or reclaim mid-copy, the write could be torn inside the page
   cache before it even reaches the filesystem.
     - The current RFC uses a "pinning" approach: pinning user pages and
       creating a BVEC to ensure the full copy can proceed atomically.
       This adds complexity to the write path.
     - Discussion: Is this acceptable? Should we consider alternatives,
       such as requiring userspace to mlock the I/O buffers before
       issuing the write to guarantee atomic copy in the page cache?

- Page Cache Model vs. Filesystem CoW: The current RFC introduces a
   PG_atomic page flag to track dirty pages requiring atomic writeback.
   This faced pushback due to page flags being a scarce resource[7].
   Furthermore, it was argued that atomic model does not fit the buffered
   I/O model because data sitting in the page cache is vulnerable to
   modification before writeback occurs, and writeback does not preserve
   application ordering[8].
     -  Dave Chinner has proposed leveraging the filesystem's CoW path
        where we always allocate new blocks for the atomic write (forced
        CoW). If the hardware supports it (e.g., NVMe atomic limits), the
        filesystem can optimize the writeback to use REQ_ATOMIC in place,
        avoiding the CoW overhead while maintaining the architectural
        separation.
     - Discussion: While the CoW approach fits XFS and other CoW
       filesystems well, it presents challenges for filesystems like ext4
       which lack CoW capabilities for data. Should this be a filesystem
       specific feature?

Comments or Curses, all are welcome.

--
Pankaj

[1] https://lwn.net/Articles/1009298/
[2] https://docs.kernel.org/6.17/filesystems/ext4/atomic_writes.html
[3] 
https://lore.kernel.org/linux-fsdevel/20240422143923.3927601-1-john.g.garry@oracle.com/
[4] https://lore.kernel.org/all/cover.1762945505.git.ojaswin@linux.ibm.com
[5] 
https://www.postgresql.org/docs/16/runtime-config-wal.html#GUC-FULL-PAGE-WRITES
[6] 
https://lore.kernel.org/linux-fsdevel/ZiZ8XGZz46D3PRKr@casper.infradead.org/
[7] 
https://lore.kernel.org/linux-fsdevel/aRSuH82gM-8BzPCU@casper.infradead.org/
[8] 
https://lore.kernel.org/linux-fsdevel/aRmHRk7FGD4nCT0s@dread.disaster.area/


