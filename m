Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351C6606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZ6enJrj
Received: by kanga.kvack.org (Postfix)
	id 450F06B05B1; Wed, 28 Oct 2026 13:13:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401BD6B05B3; Wed, 28 Oct 2026 13:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA0E6B05B4; Wed, 28 Oct 2026 13:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4C16B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:13:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CA291A0195
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:13:25 +0000 (UTC)
X-FDA: 85372681170.28.50FA258
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C89B7100003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:13:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BZ6enJrj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793207603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vktowsTsOQhJmqiWYNIb0aPqBLNSbNahOroQ81vALNQ=;
	b=KNSJZ5fWd3HsnuepdBJTO1szK/VDgxBtSxa7J08wgL5bZjIqd7BJq8RBsEQATJQEH4BCtO
	k2KvuV/qp17wq/Jhc+gJF1TWvAd4f04cV1B6OmB+CU+cXUwM8vIrn2W80DguNx4ukJt20i
	btZ1ztcX+npMC+hSld/F9maUK1w0yrQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BZ6enJrj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793207603;
	b=wm5WY4fe06v2IFUEF6ktGcns085xWQ2CADhsdlHGopi5KKavbw73b0MWrYRWVID85vI3HU
	hZuaEjyGc3D836F5B9FfVpMCo3p7GfbDUH993O04+/kT7EvTxv2CiKrr55MIVS/nayIkEb
	JJ4ILN4W0tQIt+xeHoEvnSTFZZJX2Gs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A6F242CBD;
	Wed, 28 Oct 2026 17:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E631F031E0;
	Wed, 28 Oct 2026 17:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793207602;
	bh=vktowsTsOQhJmqiWYNIb0aPqBLNSbNahOroQ81vALNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BZ6enJrj2fR+WiaobREMK06Ol4IBWooQRDlbbDCkO1gNP7+G2R9/lsOOs2AhduaH8
	 IcGiH6/qAIxcfuSrwBdneQYRZt+W8ihxfi/bu8MIRkDPSGPjLv1CElqLHZjheiMzWZ
	 DH0T5HoxcIR4+yigsaET5t4ctAredW023hZHdikTpcSGKdBksnJ3GuslAURAOE73r0
	 OFDzAYx+euSlpwhkJz6vzjSi4qGr9oAaq/5t/Y26Gl7SwP46yh6RZXFHOGQCNEJN9I
	 lo7RodJkVz/gLSXqyhniNMQsfTsQPbnnv/5roVKerewBTdFEwzrN4Aepm6Xp3XPTM4
	 cnbju0zmHk6eA==
Date: Wed, 28 Oct 2026 19:13:06 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	kas@kernel.org, kexec@lists.infradead.org,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com,
	riel@surriel.com, harry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 4/7] mm/memblock: add a reserved-region flag for
 poisoned frames
Message-ID: <auItIsZRsh_Pwrti@kernel.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-4-f304255147da@debian.org>
 <ato62palTbNjLwN7@kernel.org>
 <524ee7d9-790d-48b6-8613-841da042c32a@kernel.org>
 <auH6WT5zR1RM1lpA@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auH6WT5zR1RM1lpA@gmail.com>
X-Rspamd-Queue-Id: C89B7100003
X-Stat-Signature: 8bxeqyu9twjozwxk8i6hxz4rxy1ggyt3
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793207603-481954
X-HE-Meta: U2FsdGVkX1+EmeL/jZG2Sw0Qvn69KmwP76mAOZKZZ9jul2Cn5l6gT8/p6ALrS/Rk6Xo9SYoaTL5QxH9BiKdPDHEI+wIJzC9Cfck/nYAKCoCEY08Dd9e28TFtOcLf3m64hM2+K2UfOLJeMYS6N+8Id93ZVYDNLRlBEj4yxNs8QCB9Zbqlf4P1TahCcjhJPiWHz2W3CiHhjw3ylClvrkVr0rP0+ihOy0/5UyEZfMG3/8IaTJT2oUAcdiXh4x4ZsVWWIzzXH+0HDDxKidhkcS87/36Uh469kmKoO4Qhf+lNgQzfEfUsgl2+I3Wb6VOunm2IwW9QrgXxR1rdL706W83UMf7MlziU8Xs9pVZknjcOrmp+SE31wyygzQuCRnoD9bdxoeZliV4Gup86MdMiBVtTiWJS+W62KiM1VjXP4HQ+qkhu4mm8Hne1BPf4gfLfQcUvaUegKvF+fKe22uW/WRZjfUpTq03cl8E2nKi64tWkfcvxevSCWpo/apJUAboi72GnErfQZ92SPW4OYcSk1K1bAe3+7rEiP+rp4347QK4YjReidKcrAKtuPLVZhIHV87V1JkcNQB7vR1zpsXrgc9lCTE8fN/CX67QABFHdcIpCM8XpjCSKGDZRZEox5adveMtrigAWJcS9nHyV/jVwdvrjUQfMDmeqIhmfFG2/sO7zY/qEym7N1aU2+SVhOZCgQMSYcxvErX4MEiH+9Ie7L8ljNFqJRwYnQd+EBhTBEmwO/lQpsWH7Ie7hGH1hh52Zgruz4+Z8W179Jf+wf2vur4OFjhZNRxLtzIJ6YW3feEkrP6dwkvWYzh2XJN2LCiVUtHDJVwcClXe3opw2z+ynwkcZf/tLrZ3itH1XGgUzARw4feBA/YLQjwE2bGyCdvMUR1T3V8BLyq/5hDl5qA0tpC0DACH/b4LTYHD2eri0bSU+B166il5iNPpAn9dF49T94QqPSw98TWBknAiZ1EoCRbg
 iZYQchlh
 I9SUJLBYyMfKbEXhHhMqOavfYM/TmxQM3/w5R/ERxRV7OU6ic/+O07CW8H9zTqj3m/fc09IREs2BeJ3atoiEIVB160ag27D2jYVMvhhlw6XrlSJS6rppgG5M8aJTOs1OCIcNl+Wf1Nj4BWHN6qo+JFVq+exbcGqPskoeUI1YgvMsX7miA/QNgMConFggeZ5n6OlW16OTSDJBlC1z3xmDyF6+oT3851FGEN6dmShPv9VbJgKNXFpONQp85s1Uxw75YaJOqhEmKJK1SC0M+mvAzd/kOWDfbbgYav619f4Qo0Z321LQ1SAV6G10q8v/JZ89k9Y5VeEcFEVadvls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 06:49:18AM -0700, Breno Leitao wrote:
> On Wed, Oct 28, 2026 at 09:39:42AM +0100, David Hildenbrand (Arm) wrote:
> > On 10/22/26 18:33, Mike Rapoport wrote:
> > > Hi Breno,
> > > 
> > > On Fri, Oct 16, 2026 at 05:15:44AM -0700, Breno Leitao wrote:
> > >> memblock allocates from and frees to buddy whatever is not reserved, and
> > >> knows nothing about frames an earlier kernel found hardware-poisoned.
> > >> Such a frame can back the memmap, a page table or a percpu area before
> > >> any hwpoison code runs, and otherwise reaches the buddy allocator like
> > >> any other free frame.
> > >>
> > >> Add MEMBLOCK_RSRV_HWPOISON for a reserved range holding those frames.
> > > 
> > > How much this would fragment memblock.reserved?
> > > 
> > > memblock is not very scalable, to say the least, and each new flag
> > > increases the size of memblock arrays which obviously hurts performance.
> > 
> > I assume that if you have too many regions there, you have different problems
> > than scalability problems.

Not different, the problems are additive :)

> > We should cut out larger chunks, and if they are all over your address space you
> > should scrap that machine.
> 
> Ack, that is what the 2M unit does. A DRAM row fault shows up as many 4K
> pages but lands in one or two units, and adjacent units share one
> memblock.reserved region.
> 
> Mike, on the statistics you asked for: across the Meta hosts that logged
> a hard memory failure in the last 28 days, these are the
> memblock.reserved regions each host would need:
> 
>              p50   p90   p99
>      x86      1     4    41
>      arm64    1     5    27

Thanks!
A new flag is fine by me.

I'm still trying to parse what your LLM wrote in the commit messages before
sending the tags ;-)
 
> Thanks,
> --breno

-- 
Sincerely yours,
Mike.

