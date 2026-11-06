Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1802606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=kawekjpF
Received: by kanga.kvack.org (Postfix)
	id 1E0AE6B05B7; Fri,  6 Nov 2026 10:48:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6B96B05B8; Fri,  6 Nov 2026 10:48:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE706B05BA; Fri,  6 Nov 2026 10:48:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E718C6B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:48:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D1D2120CD7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:48:53 +0000 (UTC)
X-FDA: 85405127346.03.F800AFA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 53E644000B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:48:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=kawekjpF;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793980131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYP5TleIEch3VLAIP9Ft5HxHg1kcwlIJDfJyqYRyetQ=;
	b=HKIP67gbFy4obOupW/0W9TvB4TCYRZUkeNMt91URpJloqxFdlJSTPxH74RVHE7DUW5f2tM
	s00x3FTPJiE+ptou0vTEDlETfO7Zzf7kGHphH4yv356HW6BKEHugDUg+7lczGVFP6949Dx
	hLEQ2OJHcdWsXeGmgz6OtigeUyrOQlc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793980131;
	b=5qeqiPN8NSUNK8Oh0cnUAEV6BARb7DKMBVNy/psNtgR74eeYbgUsM/U/LV+gPsQ1Sjqbw+
	bsRlc15HHDLxikBGT58guE2vfbnOIrT68LJ2DIbJ0hTDLhkqrrCBB7l+5b5LAZaAq3EeSJ
	SXgaDjoR/Xqq+anxTZ4/kku7coMRNag=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=kawekjpF;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tYP5TleIEch3VLAIP9Ft5HxHg1kcwlIJDfJyqYRyetQ=; b=kawekjpFkeEGdTL/oDhrDnFvls
	K1D01E+FexEpQanMibxBalmMtyOvnUTJ+UVQ8QxUMrKmFHlioowyeYzLKNbVsfgIp7VObIcFExEpf
	vqYossnW/QB+XhOiQZEppddiMVHXWse+H6IqywSELZUSdLbBdVk4mDFaLTGnjY6c1zXFYdGRZviu1
	a1JRUdlohP6HrX1J+E2nkajmSx1GeiVHJV/RkCNrWDiGtvZFHB+MgKikLbDD8f/s+7y4Wh1Uqfyl8
	3xiLyWiCoerUT2LoIv1B8UEwXKqw9UuoY2k0ksG4hzsmmN4H47F7SWp6jznWjd8iBPUPCXWoA9lv+
	luXUpRbA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPMBA-009OCi-2T;
	Fri, 06 Nov 2026 15:48:37 +0000
Date: Fri, 6 Nov 2026 07:48:30 -0800
From: Breno Leitao <leitao@debian.org>
To: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Julian Sun <sunjunchao@bytedance.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/4] writeback: name the bdi in the slow writeback report
Message-ID: <au32skMUJvDOSsgb@gmail.com>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-2-bf0c3b9023a5@debian.org>
 <n7s5cijjaiso6mhaqolsmfkyyfk7wkb4l4o2cnxqadjfllik7b@hh6u4v5f6t2t>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n7s5cijjaiso6mhaqolsmfkyyfk7wkb4l4o2cnxqadjfllik7b@hh6u4v5f6t2t>
X-Debian-User: leitao
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: pu5yskdn87r7u7rju59ruxmgtsrmg5a4
X-Rspamd-Queue-Id: 53E644000B
X-Rspam-User: 
X-HE-Tag: 1793980131-342912
X-HE-Meta: U2FsdGVkX1/Lvajg9UGa+AsaAJd/sHxwjnVccfqEafxSugYtiHWyRUCsPjq39ug1t16D35y9icQ+kokS3ctnrmGQ48pVBlU8GJ/7taTk5G/G9lRHiGQXgByn02exCmwSaAnkD/9W9/dUiYmSZ1gK8P4kHpercXOmCdLIvfpFxIdGQv7kzxCnoiX/DsWR9i9YYxIzYKtd+lGtucl3/rvZFHI1LBb91ANpDi242z/mxCrm4f4pqo3piaGRvjrkreh7RRz7IIXhXz5xHklf4IjZe3PzJ3KbofAVnCi9Qx4pVcgVi6C7V7JWooyLwedve31e1g6yVfdCJkHOvG03306B5nzXzDBOpGi5NNMmmzeigwEXDlfawQmLjucbVAmiFfHGHd2Mc/EvtYYvq43qDdYhtUkVMBvWhGcb0nUd0loqLI2tSOEOnejqE29WCBeRNh8rn0gN81PglDRVariuf/1nheXC97JdTbqdCYsHeOy7L0sLxc+E5FKIrrFjbjUGOMU/wudJNp1qEcP1cDy7bbBKYQP3Jt1ccZ+5nU8Ipofolf7xImatKXBGl1pxBBTlXbFLMjdgKT0kTOl0lgqdeeh6ZEuYXDp4Qjn9fijtYNdkVjAh4SpffzmSjsmzPzyNWUcdgkC43YZz18dhEVLZdSJVmOJSmf2HpNgSDOtuDkZNS2DSj/uCzGLPtjfHfE7uNz0v1kW6rDzkEPLnFKGDTsRORNk4NCAUwlQToA2CdMCpY5pGFMKI2lYB2HFjyHud83X3H9JmaZmeXcniXrtntHE+ZyNvuFoRIr36+dL5mFixRs5D3M2RPl0u+hcoBCHZ4whzQDl7lfDUJTgfM4db0TS1T34IehCPgt0OrljWK26Ytat2+R1cqLsLyoG/bCoyZiNyR6UQixZVhe+yy6IGccdhPXDJE+8HvqIVXhEkNWXr9YV7S7fwzvdi1TKHt8/rWFWqJUCsarpHGHXUfDvhal0
 Oxt+i1Ih
 d9HN0Sx/pCB22p/m/bryDCCn5gdrElU7YEIYiX62n61DnWzw5uTlGAGtxO5mqYK4FQfYeMYXWF8s62C4SWLqtEyiTey4Xk4oobE76Qwcu/FqyJIgrUnncVv0WYrGKVWwGzb4WIN5Z7xJifLx65HQykPkyIR3Z0PrhNRSm2x5fxfHdfIMeQnXM9hU4/QR20Hsy8dHRwrdeVssI4D1KD/mhf8GnOkGMocmbUnY2SThUldcTgy75v6fIqh/Eglk6WllbZMeb1r1HPhYq1dvuXzHKAfI1UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 03:27:49PM +0100, Jan Kara wrote:
> On Fri 06-11-26 04:26:32, Breno Leitao wrote:
> > The slow writeback report names the waiting task and how long it has
> > waited, but not what it is waiting on. On a machine with several
> > filesystems there is no way to tell which device is slow.
> > 
> > Pass the bdi to wb_wait_for_completion() and print its name on a second
> > line, together with the number of work items still outstanding. A sync
> > issues one work item per cgroup wb with dirty inodes, so the count also
> > shows whether a single cgroup is holding up the others.
> > 
> > wb_wait_for_completion() took the bdi until commit 5b9cce4c7eb0
> > ("writeback: Generalize and expose wb_completion") made it usable for
> > the memcg foreign flushes. memcg tracks those by bdi id only and passes
> > NULL, which bdi_dev_name() prints as "(unknown)".
> > 
> > The first line does not change, so anything matching on it keeps
> > working. A sync on a throttled null_blk device now reports:
> > 
> >   INFO: The task sync:180 has been waiting for writeback completion for more than 28 seconds.
> >         bdi 252:0, work items left: 1
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Dunno, I'd put everything on one line. Otherwise things can get interleaved
> by other messages. Kernel messages are not really an ABI, we can change
> them...

Ack!

I will get them in a single line and respin,

--breno

