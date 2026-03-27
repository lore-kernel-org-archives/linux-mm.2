Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EBA210AB830
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DC0D6B0092; Fri, 27 Mar 2026 10:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C0C6B0095; Fri, 27 Mar 2026 10:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B376B0098; Fri, 27 Mar 2026 10:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 638926B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:23:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ADF0816111B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:23:19 +0000 (UTC)
X-FDA: 84592060518.10.76EAA17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 025CD4000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:23:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kGZyDgNi;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774621398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VaYRE3Q+xjrM6H7KB6ewa5te4zfd+FW4Yu7avUUrtIc=;
	b=beWlxp03HqP6Bb/+dQ0sA738JgMHhgVONhzbwEct0hswbPvP76GDF1tTi2Uqr0iQmyfe6J
	Vuj9TYjYydNmvIvWT+RHIT1HtiesO83AsMbGIgD+jDw1qnLWzVtt8ZOE9CynGe87ObZAai
	BtdrDV6gXborA42RoOGAqITUQWh7BFc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kGZyDgNi;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774621398; a=rsa-sha256;
	cv=none;
	b=naO+cqXHp2itcXyogYpmccqwngfwHOBO2n9fvmlVHAJDTNK5kiQXgxwl2jIuokxnZewWpk
	d9ZZ5vcZDlQHPdGoaLOQJjc4vsTbHWJ2vWLQZApQxYsTHCTdaPdEonP7W8l4JV3/8PJr7X
	fvSyyH1cIzaT+pCeMeQ+TSCDJsequOo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0286841762;
	Fri, 27 Mar 2026 14:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CFEC19423;
	Fri, 27 Mar 2026 14:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621396;
	bh=r7LKDcC5C+R3TFKnw7hncNSlu/84qsRHglhM4Cn1oA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kGZyDgNiexyUER/ZwAIJM0HynG/fCoHSrze6Ap9k93b+3jZ8G1j1JC0no7VH+tjWO
	 oDS/GWWKDWhCMDASGMyvyhBevKFLFQ8Lwgl3Lnz6NEndz+T/8MpbPkjmgbbEPutIPj
	 Qw8C4IF9MmEn7Knlcz12mJpiJvJYttmR6asGO9QFnCGtxcZoZ0CLgg6lasPMtnItFZ
	 773BHK7KlucGhygy3WB7sUNV7Hgq3+FfUPTDD0l3xBFToHousrSNtBNwNQxCDU5Zk1
	 b7gHujNH5RxA2UswwH5lW7XFqkY82vn8O13zvxIwWaelEqtjGbwswTwWZSHBd2qEPf
	 sfiXeTOCPn5Vg==
Date: Fri, 27 Mar 2026 14:23:09 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
Message-ID: <53cf6157-58b1-4539-a276-2486e8796c57@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
 <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
 <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>
X-Rspamd-Queue-Id: 025CD4000A
X-Stat-Signature: fxhadbyyg8sy4knmds3gqo8x7z5obs4k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774621397-948891
X-HE-Meta: U2FsdGVkX1/IMY9wgYF/RibqVNXYTVVMVp2YLxqEPPvyNvvmSN/ulOH4s8XXSv1rpn13BSNbol1tUMKdSFkEuSMMTuXrvaA6xs3ACA5rj/fyi4yykLpcTTx6F3NvQLIkccxgwyC9vs3AbzWXyLKluYYU+0U9sSNELu5KBfQ+vCQn4wBd+pW9YNVv5ZmxwXRIFiGWQcOVV1tps295kKW2RJ+SriiFsXv3tnYek/50t0pBwfEeqKv03MuOvJ8jmM2GRGVc0DII7bY11bcqAQ24WBP77pw+NJW9NnJsSepd4eWQUZMwGGXVvuikTmk2HlbjEIus2oCXu0k1XQxlRbJUz0DuL1L9FNS6LRKQTLzrkshCTpHy9wsXkxuMQY5l49bpOJy0E1nVWUt54RLqhAp4pMp846POdPa1zWzdJEEDLlXReZFvNV512CgWNvotFsKAa4+/PKVLs+Vkg/qOzadp+fkunt5Z0ySMPRBfhz4hdf4wADtj+K3Lssvgz42ha0ICe5YUoS7tsnu8OUDj+r3uFXUv34h3p+lolFpzkKd5h0+eG/LxXtB85ROIKEpTEvLuCrsQ4yQCDHNCtn1kZ00arrV8youUsesgpCaCcHQPLkESYqKeUYtNXgpBs7oMTJSJtDWmanqJmO268ETg0JjBjxAdUGHhvZvmBFfRw/L1If6/Sna7ogHx8WpUnSZvIfoz9wfT3U17WRBlgWSUkbnzJh5KjMEfOj/4qEF5VoUsFz74+gtY3vYQH5kOJp0R9JBsMK0sGP6/0iswrPjWN/AoVs8lUPUXNLCr1nYNVWlcxFdJsaRmcTvErFbrRsHuWBTvOgXwLR0u3T3d8cGYMFEtBBXRS06EIejSGvgrjLNuJs19Iql4dRHqjqYONpsh7IQHDVY+FK9AhZWgAbtysY5oIBF9aFXnFOFjfTxyV/ltCkEoTBoJANx3tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 02:58:12PM +0100, David Hildenbrand (Arm) wrote:
> On 3/27/26 13:23, Lorenzo Stoakes (Oracle) wrote:
> > On Thu, Mar 26, 2026 at 09:42:48PM -0400, Zi Yan wrote:
> >> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
> >> large folio support, so that read-only THPs created in these FSes are not
> >> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
> >> THPs only appear in a FS with large folio support and the supported orders
> >> include PMD_ORDRE.
> >
> > Typo: PMD_ORDRE -> PMD_ORDER
> >
> >>
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >
> > This looks obviously-correct since this stuff wouldn't have been invoked for
> > large folio file systems before + they already had to handle it separately, and
> > this function is only tied to CONFIG_READ_ONLY_THP_FOR_FS (+ a quick grep
> > suggests you didn't miss anything), so:
>
> There could now be a race between collapsing and the file getting opened
> r/w.
>
> Are we sure that all code can really deal with that?
>
> IOW, "they already had to handle it separately" -- is that true?
> khugepaged would have never collapse in writable files, so I wonder if
> all code paths are prepared for that.

OK I guess I overlooked a part of this code... :) see below.

This is fine and would be a no-op anyway

-       if (f->f_mode & FMODE_WRITE) {
-               /*
-                * Depends on full fence from get_write_access() to synchronize
-                * against collapse_file() regarding i_writecount and nr_thps
-                * updates. Ensures subsequent insertion of THPs into the page
-                * cache will fail.
-                */
-               if (filemap_nr_thps(inode->i_mapping)) {

But this:

-       if (!is_shmem) {
-               filemap_nr_thps_inc(mapping);
-               /*
-                * Paired with the fence in do_dentry_open() -> get_write_access()
-                * to ensure i_writecount is up to date and the update to nr_thps
-                * is visible. Ensures the page cache will be truncated if the
-                * file is opened writable.
-                */
-               smp_mb();

We can drop barrier

-               if (inode_is_open_for_write(mapping->host)) {
-                       result = SCAN_FAIL;

But this is a functional change!

Yup missed this.

-                       filemap_nr_thps_dec(mapping);
-               }
-       }

For below:

-       /*
-        * Undo the updates of filemap_nr_thps_inc for non-SHMEM
-        * file only. This undo is not needed unless failure is
-        * due to SCAN_COPY_MC.
-        */
-       if (!is_shmem && result == SCAN_COPY_MC) {
-               filemap_nr_thps_dec(mapping);
-               /*
-                * Paired with the fence in do_dentry_open() -> get_write_access()
-                * to ensure the update to nr_thps is visible.
-                */
-               smp_mb();
-       }

Here is probably fine to remove if barrier _only_ for nr_thps.

>
> --
> Cheers,
>
> David

Sorry Zi, R-b tag withdrawn... :( I missed that 1 functional change there.

Cheers, Lorenzo

