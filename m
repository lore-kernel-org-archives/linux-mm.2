Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96F5606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YqGzCa8Q
Received: by kanga.kvack.org (Postfix)
	id DEEA36B0793; Tue, 24 Nov 2026 10:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77856B0795; Tue, 24 Nov 2026 10:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3FE36B0796; Tue, 24 Nov 2026 10:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3916B0793
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:56:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45BE7A8A53
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:56:53 +0000 (UTC)
X-FDA: 85470465906.19.53B4F99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 91948100003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:56:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YqGzCa8Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795535811;
	b=rmclW1r5FIIPWa7KzlHDXAmOUvC107hv24ryTgpjsVMDs4oJCAfE0Dz/ezL4H0HawDdDRc
	ImJjkNutPgzPMVO8LXXhDmCmXttygd5HAOIsKPItgz0XTUgQRMT1gVzfUybRyfHLS0L2gD
	EFJgMmxA+4yW3TVK/aPXooY37EvzQms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795535811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6r3s+BqLdhqdRRzKh2nC27WkeQWODtjIQNAEONMLSQ=;
	b=A5n+nUx00y6WjV849vp2POFftdxqyNf3DDGNEXQBI8ZOI8wXAnv+/oiK5Hj7gLAEtySxtX
	OICKgA6SdKDnhAsw9NUdFbdWjRmJYJzEnkYa984Q8T2U3MmImRP192rG1UOms9a/GfPSdV
	2xfCc7IhFF9dXz/dNBZxpnILDG0Jjjg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YqGzCa8Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 792CA6277C;
	Tue, 24 Nov 2026 15:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E731F00A19;
	Tue, 24 Nov 2026 15:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795535810;
	bh=k6r3s+BqLdhqdRRzKh2nC27WkeQWODtjIQNAEONMLSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YqGzCa8QL0NVqlP2obsuHAelk4S6MZNKNwnM1WkANuOvgUnuT+eZGV9RJ2XEjkz7K
	 FvRTkrcmhoQQ5uVUVRxayEYsnRH8ekuotj988EOVhVQoYZzNeJ/1Tdg+J1neSGzbDH
	 QrkXsgGaZYCsUr56aGQ4nxmmBr4SV32321hTRXgJDckTPmjRxd7wLfSET3J41QNpEi
	 ke6DXkEgzjAYwwSnG2tS1aFSP1PjJj8/KRFmLzx6Y0d/LstYiVIOX+IUvFeEbby8zm
	 BQaQOOBgsrVv/9cnK1HcPTqe7+/KkPPsaolk3FE5lKQp1YWRGr4/TYN45JZ7wbHDx3
	 3oGNJDxgPn4Gg==
Date: Tue, 24 Nov 2026 15:56:40 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
Message-ID: <awWxsn2c1xR_JiEs@gremlin>
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
 <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net>
 <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
X-Stat-Signature: iy8ztxhkq9qhk7uhmemzds8ka6nert16
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 91948100003
X-Rspamd-Server: rspam03
X-HE-Tag: 1795535811-33165
X-HE-Meta: U2FsdGVkX1+s1bRm2Ce6jyNS4tZTD2518oqQq84p7TCCiLBZ/ns+Va+VFy75rGZEzKvHZx4cNibU5NmXk2ox443Hxo71AqlJOG7lsMUu6SeHQEVF3bkJVxRuHiaWlq7kEyP/fAVNT2vaqcdeT+ObH/pPo9Avi9a6VTcLjorDOe3zG6yN7JREyYauZ1N/WcVYSkP1m4woM3ABPNLST0EQX3UeLYKJtOoXnN1Rt/dUdu1Fum+HuZ7CD5BWLYYKKOVd0CnZHFe/opmx0cqHAVbwMBG6T6xRneTXMHnrOmZU+mVf+PXVO5Tj5DZIPyKso9V7PkbWNtBdNWlz3dfdv04cFRqIauVue6aTed1+6S8mAlvIWQtJaTHotBXCJq7f2URhjyshL4KTU6sUU4IiXULO3D0Kn0cGAJuCaJYo6DLuvqfRYc3ldHgXqmJ8a+ChG6JW4Ol+MuW76CPA4o8GPkINgTr0YB4a5OmScGCdgbzfEKfym+nkKusxhScKRTV6z1wjZq81EWJvjwCDURZRJRMOFbpNI0XDNi+PkaDfxPvX+qQsyc4N9VrwY6xkQWRc7zCrNW4OfF83BhJrYw42TdosuMlH1dOHErwTG5RCQjr3QUHn3JDtLxDK+Pv2fDU0mb0AxdmdzDH+HIzAbbq0g9CMNevgHejZ2i/EJDyK475zYgjpl1ph7XznsW/BiFIrHWIlOUqrIU1QR82njBegNVXpi0TqRBZooyAoLjv4AzXOfkNCFkaahI6m+Lz2bHf7VpVsddXP1yPqEFsgRTYRHAif5FwlOspvmjI3qKpUwBEGhD/LqkaW1frelXGDfeo1AyThzKOeBMkdyKjzH4GIMvzf7KrYbAr4jUMW0HqetnVwP/RJl+ICp5NJcVfnlDpL/u5IBTCEbjpwyeY70qvackVweOjh3h8MyIRwAaJ2Z5C7ZHJEAQP3khMiS/CdgdAjvOdGv70zXpI7HWGcgVcfpuv
 V7EZEi3e
 EW21MBR8bFlObNmd6vU8srfkeVWHW/CjLSkkNJwhaYpu6vU1f+e2DRHRm9cM8m2TI3Nikou4l0xXQFHYNJMFSTCsfKGSkef7Na8r/T2XPjpAalL9zQ6IPqIdEhql4ztZP2MZbYlHi9QmoCmZywhYWdNNtm2ScCASYvMbWjctQZgSIVgs2Kvvh7ZAWNp+o2u/8xQPhW4KOOkrLKTGHSdEXmp5hD+HxT+QYo3cdst6SqCUcEFz/l/mP2CfTacet+cCu3yoTkX/Gx6iow5lU6nryU3nFoKmx5qyoYd18A7WpI65T5nrZemQCe7wtcf2tVgeshhExwLK0PsRV/70nz98rTKrUMUc2dqHp9ZeErcBf3axOZ1JB4i8VzEELtrLupUetvc6JTEx2zaKxt7fCTm4j8UYXd0Vf6eMV+jJbuZvDHA7wr4m6P10bVQrB93wkg0iWhsddtd4YBmurM9UUlxq89oVSoGCvc8b+C1nGPTvzmeVsSjyhCrYLpfZ7xZ+j8JmxkofKB/HATy28cJVqCP+nqJYo/eh0/7LOhtwNzQLOiMcmAbA5ldg/efXKOT6szU+cAoy9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 07:46:04AM -0800, Suren Baghdasaryan wrote:
> On Tue, Nov 24, 2026 at 5:04 AM Pedro Falcato <pfalcato@suse.de> wrote:
> > Is there any particular reason for unlocking the RCU comment last? after the mmdrop_async().
>
> Yeah, I think moving the RCU unlocking was unnecessary (unlock as soon
> as possible is in general advisable) and we could just remove the
> comment. Both versions however seem correct to me.

For simplicity. 'The operation is done under an RCU lock' :)

I alluded above, but intent is to revert 0b16f8bed19c which I _think_ is
fine. And at that point it actively simplifies.

The operations done there are only done in a rare scenario (VMA recycled) and
now the extra bits done under RCU there are really quite small so I think fine.

I will follow up on that later.

> > Acked-by: Pedro Falcato <pfalcato@suse.de>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks x2!

>
> >
> > --
> > Pedro

--
Cheers, Lorenzo

