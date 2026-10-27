Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3424F606A325
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIHfOMOJ
Received: by kanga.kvack.org (Postfix)
	id 127216B0633; Tue, 27 Oct 2026 04:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0DE6B0635; Tue, 27 Oct 2026 04:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C326B0636; Tue, 27 Oct 2026 04:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5C656B0633
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:46:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4258E80719
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:46:23 +0000 (UTC)
X-FDA: 85367774646.12.DEC32DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A2847120004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:46:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIHfOMOJ;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793090781;
	b=ML+fFAFlh2LJcyXRBYdRI/j91u5MLLLH1YrMsSGp4JS+iWzHyoMAmE2icuUITEVTeMYIuJ
	zZ7Giwawxwef3a91UVICt5Gb4QFSWM19dUPLt+j0gd8VH59L6xzGghnPkvs5sFKF6nLljl
	75I0NfvCrB/R3MpO5ZIn5vz3U5Nb7vg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIHfOMOJ;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793090781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/YAccCPR+QDBod9TtDEo8/GkjTX2DKJZMvCayiMInU=;
	b=zg43jNma7meZz3i3emzbhSizzusyl7WEBZU0f+5NwEqrRZyWe7kKpLyll5icMeWH6bjNkD
	U+Asakxutw3A+hH34jYKOjVmxtSfACuCPnuzFBduZ5JQqlBc0x+pjEBfYZhFXoAkjJ1J6j
	R14gExD+7K0wdyftjn6uailTS9xymyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EF5A60210;
	Tue, 27 Oct 2026 08:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3898B1F01825;
	Tue, 27 Oct 2026 08:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793090780;
	bh=x/YAccCPR+QDBod9TtDEo8/GkjTX2DKJZMvCayiMInU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MIHfOMOJNGtvK/bOljqxWLAHcLixYnsRYXCAHtUQcunjVDLnNyeo97KX3xAMoJr0Z
	 5SfJAbFdkjKREw+q9Mtl0ffuKASWKcn7N0F0BmgFbcVUy46FHcanqfHr21qQWcr5jW
	 pN5brAKAoAMh9KQ2wKajox7TxwfMs/QXMXRrm6/pCm731qJU0brAVO4+ppYe1VSs4W
	 QVZYWrlfndxZlKOun9t4YN97qlLu70ioNm4z4BQTX+PWQAgemaKean1qRUpkEbbfK2
	 Ylrgvy+1T3A3hOJGk4nx9jTZUzT20nRhHgy1MV+6HzvLQExySYnOpZQXYHoPDsoTcO
	 4j7djgWhTTvDQ==
Date: Tue, 27 Oct 2026 08:46:04 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 04/46] mm/memfd: make f_pos accesses atomic
Message-ID: <auBkxrOz882zhhZ5@gremlin>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A2847120004
X-Stat-Signature: ohqh798t3otqgwdr4gq4pai1j8sjmft6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793090781-220741
X-HE-Meta: U2FsdGVkX1/bp22t07H3RrRNdreJBzhwhygv+XaQcMqhXjCzAHLp/Hq39A1Vmp7d7Y0vOk7LoR87I2eYCGw7oNXajg2dwN3sEqTT/1i0swQsxHUHq/H/O7myadK5x445kypn2YYcqkQNc83Ewz5FoLhU8nX6VL2P+OM8sXsN4cfYQ8DkAfj6IUUJA6TA+0GuZtb7tzLer1zoVXugLmb34RAL9SG9aykffYPom9PNodcLZSgBgpEseoKX2N2yZysMRXpZEaj7aQAT/O/Z/+/qI9EwuO6GepvyylFcAEGUXeiVILj3ArnQOqYta1m3o89iHMlVXGRDq8OiOaehIkCDxz2Y5N0vSqb3z2CIJRwZwtV/VvA6Nc0rlGJhFamDX2fZ8UYsUsTJobyBW/0/wO3tEBoy3557i8zt4D19kJTugra48xqJdAsOaZMLr/7ES7pb3S+GZ5xBlQ/dUD60b454FYz5AItt1WWgTxqszkZkWHxPv0sqVXhbmSputbJsFJWGMWEWm/hjKggsesXFa1yS7gz5C1LtJ5CJIv/mWm4h80WiAQL1Vw2TL7SxWPiCK1l8f4XeQlILhWoy3x711jPoBFMPhQyu74kJRciNAODovot/5xhGC8Q+DCpBYonboBM2CAmifK0E5OrcvON3JJHlPjVqhiF5rxbu4LW9gohpjlnUXvKLI942Gmia8vy+XeejG6CmydaeI834xutlRaueZGnvBM6dlF9hlEKXZZ+hWzCiAwPbezDfTUzDg7ox+pxCZZZP1fslqY8yWD3dBth9wfwtLD+/7mARUaIhtBsHK04l9u/V+zx5QSIqgfSX/R3daxsZAj2342p3EimpLc2gucnIQzeoh4khDWLdl6r6YCgiJLTQO0/7uqscQocpCwn/NYOIufNYXq4DUMgpFD50en1yu6+DAQz/aH2tMokXTKebMKCeTFaV+YDONspnqY80mQCGGRl1qt7GWrs1x4o
 FDijYuWE
 n+Wq+YcemZks4sVipGQpwRWr5dloAz/VqgD77n7gQF5hPUXN7UbGJdYoU1fvOYwcTe/hJQEdYt6yn2OuR3L/Ttch8qQ22us2T51VSthdbxKlw2V48JKTEDwUvK45FyTrWCpzlq7UFKjCzuOA7me1LtE6dlDjCYXTDvSsE7hdmoRkqtndjA+DSFIB1X0KszlbJtIiLfbSr08gmoyOlCLFHY8mc6jlOgwrH60Ubz685mxiKm/JL7QSmexEM/MnBKPgyf//X3fQYTICx2dnu2KYnfXZr4chuPojaNoMeRNbouq7r8y50wjEBrbGyJlNWwKOh5LIk1hm4nYVITMKmnwfHEFQSREF3Qd1X+Ms3NDV5T7qUicqBT741Kx7cS0Psn+mvfzc2wki1a/rE4eiLSYTgSbLEu2AeMf6jJXU3HyziufB7EFyKWI1DPG0doA1KHkFRbvRtEFnmPGUPxUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:24AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
>
> Commit 9c225f2655e3 ("vfs: atomic f_pos accesses as per POSIX") made
> read(), write() and lseek() on a shared open file description of a regular
> file serialize on ->f_pos_lock.  The flag that asks for it,
> FMODE_ATOMIC_POS, is set in do_dentry_open().  A memfd is a regular file
> too, but its struct file comes from alloc_file_pseudo() and never passes
> through do_dentry_open(), so it does not get the flag:
>
>   CPU0                                CPU1
>   write(memfd, "a", 1)                write(memfd, "b", 1)
>     pos = file->f_pos  (= 0)
>                                         pos = file->f_pos  (= 0)
>     vfs_write(..., &pos)
>                                         vfs_write(..., &pos)
>     file->f_pos = pos  (= 1)
>                                         file->f_pos = pos  (= 1)
>
> One of the two bytes is overwritten.  Two threads writing 100000 bytes
> each, one at a time, to a memfd end up with a file that is far shorter than
> 200000 bytes, while the same program on a tmpfs file never loses a byte.
>
> Set the flag when the memfd is created.  As for any other regular file the
> lock is only taken if the file is reachable in more than one way, and
> nothing a memfd does in read or write waits for another operation on the
> same file.  This cannot be done for all alloc_file_pseudo() files: anon
> inode files such as eventfd are S_IFREG as well, and a blocked read holding
> ->f_pos_lock would lock out the write that is supposed to wake it.
>
> Fix generated by an LLM and sent by Josef Bacik in private.
>
> Fixes: 9183df25fe7b ("shm: add memfd_create() syscall")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: minor description tweaks ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memfd.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 7d2da23157003..6f5fbce74f21e 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -484,6 +484,8 @@ struct file *memfd_alloc_file(const char *name, unsigned int flags)
>  	}
>
>  	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
> +	/* a regular file like any other: POSIX.1-2008/SUSv4 Section XSI 2.9.7 */
> +	file->f_mode |= FMODE_ATOMIC_POS;
>  	file->f_flags |= O_LARGEFILE;
>
>  	if (flags & MFD_NOEXEC_SEAL) {
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

