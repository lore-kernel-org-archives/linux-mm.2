Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E3ACA5FE3
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6381A6B0088; Fri,  2 Oct 2026 08:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E91E6B0095; Fri,  2 Oct 2026 08:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C98C6B0096; Fri,  2 Oct 2026 08:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2807F6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:12:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A84651A06F8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:12:45 +0000 (UTC)
X-FDA: 85277574690.19.7FD7144
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2343A100009
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:12:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c4yl8biB;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790943164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nX94dzJL8Kj3ESX88e5wjImNlNtcKNqoM+7SGcE8uW0=;
	b=4sZSopnLi0DNOs3bytIq2C8N0rDfAC0DmgR81/6RUpJd/SmW9AMc+z9f8FzjhqhBmVIfdV
	N/o4ikPhZ8e1DTS7cbyJ91RWoqvQtvXqUK1iYSeXS7ONvh51fC/irqnI5HQim6V1h5NTQN
	AksjwqstJA729cW0b+QYLKdTbs6mA8g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c4yl8biB;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790943164;
	b=Egz9Y3lvPCoc39xo3Wqdhv+4T5dfr79eiclSvFQ1OCj7WG32OHORAaHlsEH6Vz8CtzBR6V
	o2bT8sTLyyuV6w1g4K+VeNeM5d9Xq4f4/9fcFSA0fZ1wveEqjNe/0kldvWHtwqKXXBS+y/
	FpG+wTHiIINwYdtL+D3t1FIHe1f5JCU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E40A60A8E;
	Fri,  2 Oct 2026 12:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7891F000FF;
	Fri,  2 Oct 2026 12:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790943162;
	bh=nX94dzJL8Kj3ESX88e5wjImNlNtcKNqoM+7SGcE8uW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c4yl8biBSZCOSz8O02PAfeH7eOGxEphl+j5zx68yHK0rGgywavDJhETeCqFXtb525
	 drYTuH322sqP8NPQ5ZewzHTnVOIMhBthJu+BRfYK/9P82Fewt1qESLmLaBje/QXlbU
	 DwFWnhrzPDhC7iHk2BYxuuux04WkpQ1QaA4z1giCRe1/CYf+j/udPDx9BpMRBgE+zE
	 0Pp4Nr8nepmdcGz6T4V/ZJP/q0Yksmr01oznoU9EHFYDe+Pybk4DVG6cBSpehyP9Up
	 XaZfWzb0H55uTLR1CMcTUrzHQC2okp7EhDFf3/godjZFN6JSYYuusCC9eACzBjmltf
	 QSU/lT7DTm+dw==
Date: Fri, 2 Oct 2026 13:12:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Paul Moore <paul@paul-moore.com>, Leon Romanovsky <leon@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jaroslav Kysela <perex@perex.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Thomas Gleixner <tglx@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Eduard Zingerman <eddyz87@gmail.com>, Zi Yan <ziy@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Namhyung Kim <namhyung@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, x86@kernel.org, 
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, 
	"Martin K. Petersen" <mkp@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Simona Vetter <simona@ffwll.ch>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Sebastian Reichel <sre@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Helge Deller <deller@gmx.de>, 
	Mark Rutland <mark.rutland@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Nhat Pham <nphamcs@gmail.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Maxime Ripard <mripard@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Arnd Bergmann <arnd@arndb.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Paul Walmsley <pjw@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Vasily Gorbik <gor@linux.ibm.com>, Baoquan He <baoquan.he@linux.dev>, 
	Andreas Larsson <andreas@gaisler.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Gregory Price <gourry@gourry.net>, Rakie Kim <rakie.kim@sk.com>, 
	Christian Brauner <brauner@kernel.org>, Alistair Popple <apopple@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-doc@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Brost <matthew.brost@intel.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Byungchul Park <byungchul@sk.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Xu Xin <xu.xin@linux.dev>, Chris Li <chrisl@kernel.org>, 
	linux-usb@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, Yuanchu Xie <yuanchu@google.com>, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Wei Xu <weixugc@google.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-sound@vger.kernel.org
Subject: Re: [PATCH v3 10/40] drivers/usb/mon: update to use mmap_prepare +
 map kernel pages
Message-ID: <ar-e6Njx2MHiGs7G@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-10-4583d8a23bca@kernel.org>
 <90811f7b-1751-49cb-bf0b-3d5ee7f10e45@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90811f7b-1751-49cb-bf0b-3d5ee7f10e45@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2343A100009
X-Stat-Signature: rojah6hhxwh54nq1i9bat9w66bfzpd79
X-Rspam-User: 
X-HE-Tag: 1790943163-263256
X-HE-Meta: U2FsdGVkX19yOb4aoUEEfi3db8ApnGDemteE8Qv8qxEQmGq956T/+Lfny78UWYxwNOQuRIdJn/fRGCxtKcoFxVqecCAcGLXsw1s1bkVekLTZfNNsBT1eknJfQtZ9Tk8Hj15PUgPr8zve5e4OkSl4MZxZ1lWXhpBFR9l+CjOVjUzVUMjsVZqokvz6dpSXchG7TEX/5E38+WXqBSw8zlA/yek5I95AfSmhja/AzZ3lRKiod8hGsiqEbv4WWYAKnIxkzyH5/6/g0phV/FaUnWJJRnae/04YyawatJ8Vnm4/kuHikVueZv0tf88/Wpx1zootiq1CUhv7BvRHJAdJr+EoDX5uESEdotrniHTq5touB0VdD4TPW/Kgsa4ct7xJlA6KXzMyFZThBZ7hqd8XFAqJQFWuS92wa6FDkGZnosd66hkJ5hFALnEldqb4yDMzamA0r0XIk2YvWfc9mtn11YdBPYOgRuRLrrrg2cew5sVbitTZe2uAH7lCh+hGNPi0/zmRWtmaEMi6V9MSybDMft25BZSzJmAE8mmi6AySIQA21HReVsxL9MHz60hFqk/aap8j9p4zZINVeVJfJuo8YppIR1a9T7TL3XjA7dWk1rQO3SFgrpPZ3M0JNJv/r4/wymyXYPhuGR4XJ5opNn8SrCZqMWkHVPdDR3go+pUev2j8ema7yul8FNegsQMAcwtCSrkLg87FDeGKm/V7ZzXqHS7xFa20ZPT1y0Z4M3xIbzKCrfNL0pZUy61gx2rjRS0OQWYO483cJ7cwtw6d+dgD13bTTFXrNTD53TX7bXxsacUpGU7Ir2GACK4/H+mHswvOD2898lS4mabi3frQLURcaom75VvOEmfl7DQOoL22XIpGRoZh2cQP3gP3OszyV427Xc6MJpNLLIjdokY/e9+yZDonyBxIc1G+SAtJKvdgm+iGou0J0PQ48j3M5v1PIHpMmGtSbMLO88vYpaX6xmgsaT7
 4aUKjPEp
 wEC+00HFwj6zBLUwmtFocyMuo8SnHtAzoHEKC/GE792V0gW+4+qPmelrLPbxinfhx4VJ47mQpK+tqCrKntEBcrfsjqa9pEkBevhuh7WpT5DSZza5lEWr2hszV5PcAJpzQ4rq1yauG1Cc2NeKb1jImT6kPdK8P0o+pQgAdDOAZ77vW2yjHuAM0d31Phjla8Nky38mjZ+yKoK8k57vwwKjfZZxWUGDgSj0HUUMwdE7UNXBd7Srs7wVTVPDBq3T4aBltRtZY8vVgDIF3llx1FVzXU7YoVd80FaXbAaaib2PziPfqexs9zbck9AuYywmK9PK3N7avFCWDPVxDwMHZVJ3Y0eQix4cqPM2dJb1nsfL3ZUaDpuFrUOH8IcUv/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 05:55:56PM +0800, Lance Yang wrote:
>
>
> On 2026/9/18 00:22, Lorenzo Stoakes (ARM) wrote:
> [...]
> > +static int mon_bin_discontig_init(void *vm_private_data, void **private)
> > +{
> > +	struct mon_reader_bin *rp = vm_private_data;
> > +
> > +	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
> > +	__mon_bin_vma_open(rp);
>
> Em ... If Coda uses a usbmon container and the first page insertion fails
> (e.g. -ENOMEM when allocating a page table) after mon_bin_discontig_init(),
> where is mmap_active decremented?
>
> mmap_action_finish() returns the error when is_compat is true, and
> mmap_file() then replaces vm_ops with dummy ops.
>
> Am i missing something?

No, indeed, the contract isn't honoured in the compat path.

It can't actually happen in practice - the compat layer is only ever
accessed from a stacked filesystem and those only stack on regular files.

But I should probably update this to be strictly correct regardless to be
consistent with the non-compat path.

Let me see if that looks sensible and rejig for v4, thanks! :)

>
> > +	return 0;
> > +}
>
> Cheers, Lance
>
> [...]

--
Cheers, Lorenzo

