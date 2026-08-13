Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA0BC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8951E6B0522; Thu, 13 Aug 2026 11:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845F46B0523; Thu, 13 Aug 2026 11:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C4E6B0524; Thu, 13 Aug 2026 11:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B64D6B0522
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:08:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEAF31401B6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:08:04 +0000 (UTC)
X-FDA: 85096576488.22.2D0EC06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1F1B4180008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:08:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OvQcKO32;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786633683;
	b=7hfQy8R0fg+GeUWjUtU4cDdKieKTx4jBvTOQFKYgsWibvFK75+f4SdIioMNykKosXXyPdm
	JKgTWgFYRyxqWkA45lZkWeDJpCvPTCdi4uoLJAl0jtPD3CJ0efNufpFkPVrXVnIWcC9Q/i
	1WHJf0IHkSDd1Y3jgVvn+/A63SAU+VQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OvQcKO32;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786633683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gK6DwwQyRxxtNH/mIa8gsX3rT0/0H+8bKrZeyn+zATw=;
	b=JtooY2JTgJtxpERHhpxBJYcEZhgZlo8cu6DUHXzdVBf53GakjoEBPo3ld54QoYS9G5yu6H
	9oCjpaYJPQHrRX9o3kEhos9GZGWxPR+183Ch9Io7ljzsxTE5hm9JUgnftZiPkH1+xUbRLW
	nJ5VdanJWgsPb4FP0KPo7HUmpCFXyN0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A501160A5D;
	Thu, 13 Aug 2026 15:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F34D1F000E9;
	Thu, 13 Aug 2026 15:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786633682;
	bh=gK6DwwQyRxxtNH/mIa8gsX3rT0/0H+8bKrZeyn+zATw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OvQcKO32Z34EbBDZ7Fmm6iJqwa8JrzLpYamuED4Ikir1Pw7RlZVOSfq5IJkOI5ECk
	 tKv7ErghU4m6GMZ4UEv5wSWNr1ZNIEbrPMhPR1f1OADutH9q0SJqOvcGQgRKTZzuM8
	 gsH4RDVb+EQ2ANGYB6x6VTeAshDoGy0D3cwKNcs4hdkILLULAZeao7G6JpR2tVilK5
	 tYCAWTaaq+91ijjcI4C/aN2jrl56giBrfuRwbfCGxRyiZej+PMPI/elszx5ggQhNzW
	 J4mMAYl7T2drPQwR0MHquB6X3kMk7e+A+9YxmEtPY4y2ilpSbN03ebo4QT2Q712dES
	 SYi8olOhLB1Og==
Date: Thu, 13 Aug 2026 16:07:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jiri Slaby <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>, 
	Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Pedro Falcato <pfalcato@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Steffen Dirkwinkel <lists@steffen.cc>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>, 
	Vishal Moola <vishal.moola@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, syzbot@syzkaller.appspotmail.com, 
	x86@kernel.org
Subject: Re: [PATCH v2 0/5] x86/mm/pat: CPA fixes
Message-ID: <an3dkOKWdajK09KN@lucifer>
References: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
 <9cfaa5d1-83b4-4b88-bf3a-05d2e074cadf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cfaa5d1-83b4-4b88-bf3a-05d2e074cadf@amd.com>
X-Rspamd-Queue-Id: 1F1B4180008
X-Rspam-User: 
X-Stat-Signature: k6og641gqy53wytw6efzujz8xb13h5jx
X-Rspamd-Server: rspam06
X-HE-Tag: 1786633682-399332
X-HE-Meta: U2FsdGVkX1/N7fIFNNangk72RoUCyJef0ymoXv9npu14RzGQW9B6+4ShSW0y4mYHkX5R9AMMHZn962NSWLgj9v+DOdCHnHqI+hejYegxYY8c3TdQbBZPMuil6FKPiXeslSYL1lFtFqCaYk5OytRRf6vBpI0s/hMZYRlzUvkdYP/JqbIZd//SyNME8vE5YHEb1QebKpE1zvP0/vUOffEqp2PZXwk+r7uHF/bGUs3ri+qs23DqoX/+E9dRg/W5F9RqWsJFUcl5WvDR1yM77BN7HFMpOX2hm7gsafTLHmITpXV/iJlsQ1QpLAa0PI6JzWUQ8hmWRbXZsIHeU2bDnwiBuohbewqMqOJ7L6E+ksbVfmcoDMrPOljn5wMnAfndsLFGeZzV/+Xum+RR5SdOpiFLHfW/BCnu630oPJoZm6fXGs9Y08Xf+Vu2I60Zvs8B0ncLaYRMV4IgUnQccDeZbUfmx0/L/mMylgacV57kbgvA+2DF84p2zhFBUOlKFgc/bCYhTOqPcjQ1c3UFt9Eb13KfzJvq25LTSb2bZo2XXgYMss9X/oc8uydwfurWyrqgY5UGx2P+yxZ1LgF9CPh/sfiy1UnCKmg26wXPeuwe1hEp/MZyZrfO7BzenAsTKLpoH2YE/gLMOxz9SYhKPsoNA94VTFJo2WY4WWr/bNOb7/tVizhnaqN08gMrL2CYXKBQrHjJFw9KK2RZBxQ1fsuSJsVFd4AhIvDlSdXVS4zGra7nTVXfuVfL/S06exmv9KX+zOxejeqAWbO+AoCCQNwEzjcvDnUIYWY+FhpqUwL7Gn6Ob1IbupguHYQj3j8yTWN9axQr49By+pPffcRH8cF3KrLkBzgopK4W/P7c5SR2Iwttre7YlccV274/bFAHQScf+RjJGi2rEOJvuoaxL29TTZaDcdEmthohaRD92ubKA5t136zjLZr4Laa27ThvESBMngxHI1xnpsdWLeDJdHjURux
 14TaHogd
 CNJaCYEeQ35vbXoaNjQPoXPfY2fxVFC69+IyreSTgkH2soZGCbXXmQqgFfYQfC3m/3ra/MQQUo0TXkk009IXJxrHQ6SdaGiph6B1s08mi1s3Q9akZAJLL2v5E0rs0tFI2TWetFvf3GbUG0BGqm9M1laLE6eof7Dh6kFjXc1Mwiu0yBdpv2OURiHeFw43g3xMg567WQaypDWNmpnVZxDLLLSD67EGE+5Wg+JM3MvFB6s/txNTUbUZqfW6AvOoztENOgFUBFvs6YbocKrjEqQ9AE+R4mjOwE/IcGJIw2DjgwdFp9+dIkB13Xr2fjd4DTxzjSJl6FjKKy2f3c3sQr5IvCMWaDSQ+Gm6R1lj0kpKF8esUad4IGteedhKbtQyjNm86zYtF3K2Sz05brKCUd8OpbV6jbCsL+IvddIkvh0nOFMaJKrDRF7/pvUzpLUqkGTvcfzl1QhQSmmRS+xM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 08:35:21PM +0530, Nikunj A. Dadhania wrote:
>
> Tested v2 on a 512-guest concurrent boot harness across 200 iterations
> with no splats. Both crash signatures reported in [1] are no longer seen.
>
> Tested-by: Nikunj A Dadhania <nikunj@amd.com>

Thanks so much for the testing!

And all credit to Pedro for reporting and contributing the key commit that
resolves this issue :)

>
> Regards,
> Nikunj
>
> [1] https://lore.kernel.org/all/20260812063316.21371-1-nikunj@amd.com/
>
> > v1: https://patch.msgid.link/20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org
> >
> > ---
> > Lorenzo Stoakes (ARM) (3):
> >       x86/mm/pat: acquire init_mm write lock on collapse to avoid UAF
> >       x86/mm/pat: acquire init_mm read lock on attribute change to avoid UAF
> >       x86/mm/pat: allocate split page tables as kernel page tables
> >
> > Mike Rapoport (Microsoft) (1):
> >       x86/mm/pat: fix effective RW computation in lookup_address_in_pgd_attr()
> >
> > Pedro Falcato (1):
> >       x86/alternative: exclude text poking against change_page_attr()
> >
> >  arch/x86/kernel/alternative.c | 39 ++++++++++++++++++++++++---
> >  arch/x86/mm/pat/set_memory.c  | 61 +++++++++++++++++++++++++++++++------------
> >  include/linux/mmap_lock.h     |  2 ++
> >  3 files changed, 83 insertions(+), 19 deletions(-)
> > ---
> > base-commit: 7da514d819a0afb148634aac92b3d190f34947c3
> > change-id: 20260727-cpa-fixes-d3c73c075672
> >
> > --
> > Sincerely yours,
> > Mike.
> >
>

--
Cheers, Lorenzo

