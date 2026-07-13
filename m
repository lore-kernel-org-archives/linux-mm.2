Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8517C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCAE96B0141; Mon, 13 Jul 2026 12:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B7B6B0143; Mon, 13 Jul 2026 12:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C443E6B0144; Mon, 13 Jul 2026 12:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2BA46B0141
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:37:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FE48168BB7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:08:32 +0000 (UTC)
X-FDA: 84983933664.22.5036330
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6B1516000D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:08:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IEcGRUQm;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5D70PgPOpXCYze4+Z72DPv3iGsJRzVh17hn0cbIFj6E=;
	b=qssz6lBpHnzWB3QF19mnN1d94ob9TsS3nuwkKP3Ekt2uxx1qPUYVJ+iZRUs1hSXngTQsY4
	8JySpUMUgNSZR0TpZFU8vu2mECD4LFY4VVDWr646euTTdW2Ikzzg7m0TccL9HGKoO1QuOp
	YEshH8oEYD+jgISrqovwv/vleLDeqJE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951710;
	b=biR9u36xQ+WVZS3nxg9lXPg1zf92aV5ZvzrmAgyDUZPO7RLS6iZ7ejqjUNQjMY+JowOfdq
	PXqYhLdeH7fA6oA3RV1ajjKw8HFebzXxHdwAubM9lHPT9SdaORPojwM/7TnKKYqkj9fvQQ
	4+v4enaYDxiRUgziMVyw6dmTNrreXU8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IEcGRUQm;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 659076013A;
	Mon, 13 Jul 2026 14:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F931F00A3A;
	Mon, 13 Jul 2026 14:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783951710;
	bh=5D70PgPOpXCYze4+Z72DPv3iGsJRzVh17hn0cbIFj6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IEcGRUQmq/j2oZwL8Kf6eWI82YyVPYbNH14/2FzJeoTFePEit3iAhoG4ugytrOWrR
	 ezVl9VkrgoNuCquhjp2caRSyWFKyvEA4Avoby4m52bd/FgGA7ty7D9RJhdpUUyPzTF
	 1X9WJm/iSqoa3qwgcFma1zhTzZJ4XR2pSNCFH/uGOlr4rgClyC4tp/iEiGbxNBIqXj
	 bbbRBKZZ8Cr2oXnnM8Pr6nAKVuv2FQuQ72Mi+/qjRLearyyBnI4huUQdyifm5sNC78
	 i8TBAdjsJQ3WQef2klxC2+c+KcDEgROBsMslT0iy3f5f1+TUc59vzSF7QS+j4XoiFY
	 NFVQrR8/FtVEQ==
Date: Mon, 13 Jul 2026 17:08:19 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Carlier <devnexen@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	stable@vger.kernel.org,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/2] mm: fix UAF caused by race between ptdump and vmap
 pgtable freeing
Message-ID: <alTxUwrkzEx-FEOP@kernel.org>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <8e320b30-9658-4e9f-ac4c-f99dcf855944@arm.com>
 <alNQccqtx5-QApup@lucifer>
 <alTOCtzQh9RMfWbc@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alTOCtzQh9RMfWbc@willie-the-truck>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D6B1516000D
X-Stat-Signature: 3cbsmt3djhs1pksoq6f3ct3b6ajby4wb
X-HE-Tag: 1783951710-748905
X-HE-Meta: U2FsdGVkX1//6bcfZtmn0xPw5ITxo+ZIoXZH0+CR7R2CGYXEB8X0t1c9VFHhbdPBRsJzsEWwOv33MOqbQqvXb/NR//FmtXuZy1rQB+gYnOEmPOgYnNInpzvARHYKIrpvr3d1WAqHQTf5skK9ADlbrfOceD+1z2C3eBV73/AVK60mKqDmPedd/+46vHtBhZb4JpKwyljAJRzqzCnlQrzc4wPO9InGeFHBCb4ae03ZyFZ+eKBKsT1V5ucuRRgOaxAMSzjnj7SgEwcVAlzkXDolMZJxez9Y+SNekU0TEynv8ZEdJa3j0FL1lLi2ouV1/h+w4e3DcKpNw7E/GL1eXKrP29RFuxD1rV9eCAMgvD+nV/QoNEimelO+dZ7MMcIWB+UtYsfCF9WS+xz757P0BpwIdJuGToJiKmZjXBBTxbJ3iAwy1rjXfTTfiTla+mch2d/J91pV2i6QNTnHc+7JMkJSbpyEEiscdt9i8KoRBulgNGE28NLErt+EEU1Xv6otovEf4Fvak+N4lbyk1CRmAsc869hZYkT0b6zm2NMKMYH9orDT0+IRechJqNX2yQUxxKEeVsofxIaBrCIfMRqGhpeDTP4w9oLeC82MAybihGb9bLUPrlrJDC8vvrrch8uHhuONslSN4y0lJxAGKtZ8gY/mxE31bYpXoQ3Gg4iXxAM8Ab5RgIPi5PGFyZuQXLlvEtno0VNKy+PKwGyPFGhfqkvpAczD4IawF++SpjFIQcQBQnsrEg17lPJgRo0Zi9mup2nftvVtNUyoX3dj47g77PvXReHYJwgBkoCUxPNlsb2Y6gFHWxY6vwwlsbwZsBlc5ZBwTlzojN/RjPZCe3wFzZtSU8pS8AR+A5NNLXxWDNvL/+XHQhK8oLq7CgLjxaCK6deYpsBnBkl0OiZilat/KFyiuEb4S8VBEXieaOzkMl/lahzu39jJ5rNpfDIiG/v+Kz0tlXrYIQvcI8RMjjHcU8Y
 lsEyYJ9J
 rdzI7ktBHTX6s+Z+Ekg2pOT5l84aallfASMa1ZgbvWYHGoCfphH2WDcDNc1TbGzsFyag9PGyOlQcL7tX3GPnHmJsGDolxnPq2QwCU/9X9Q0cSLeqKJoIiRbeMCZOfV0qVG8uwPe9L5uGpq+luJ/kPHleEqrAmNY8iOr5NuLiPrQtWEkjFUzERk4k5ftnQpCJbz7gyl8XRhueeD4UbAGt1QPrF9nKLtWqpN7aUcRyybuRFo18K7D7L05lWVajIDhWwtjpcL/lxezp6T4ZJtpMIRXBW/xcXjq77GzEdDTpQPDg7BuZ5pfpayEtOb4sidcSivD4nq/UcwZGzk5vH9hWvyec4yqgAWrbvSRUMFy476RMCSqXLGVUQS4tECL2Cx6QIMHcKEYwnVHGqDFIs3egIbMCp9EcQoOGS0J3rOmH94M66psZPKulRc7ZTu6CCeHFS1+6Jj3cDNifnrxZUALHYt55vYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 12:37:46PM +0100, Will Deacon wrote:
> On Sun, Jul 12, 2026 at 09:46:46AM +0100, Lorenzo Stoakes wrote:
> > On Sun, Jul 12, 2026 at 12:50:08PM +0530, Dev Jain wrote:
> > > Will Deacon had pushed back on a similar approach:
> > > https://lore.kernel.org/all/20250530123527.GA30463@willie-the-truck/
> > >
> > > Although now when I read back that thread, it feels more so like my
> > > incompetency to convince :) because:
> > 
> > No haha not so, I think more like this stuff is fiddly.
> 
> Yup, not disputing that this is hard to get right.
> 
> Conceptually, adding locking purely to deal with a vanishingly rare,
> debug reader does turn my head but I'm _far_ less concerned about it if
> it's done in the core code, as is the case here. x86 needs it and we're
> recently running into related locking issues with the set_memory_*()
> APIs if we want to collapse the page-table on arm64 [1]. If the overhead
> is flagged as an issue, we can see if it's worth generalising the static
> key trick that the second patch reverts but I definitely wouldn't start
> from that position.

I'd say it's worth generalizing the set_memory APIs ;-)

Since it's de-facto machinery for manipulation of the kernel page tables it
makes sense to have a common code for page table walks with hooks to
architectures for checking/setting/clearing protection bits.

Coincidentally, I'm working on a POC that lifts x86's CPA into mm/ with
the intention to later use it on other architectures.

> Will
> 
> [1] https://lore.kernel.org/linux-arm-kernel/799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com/

-- 
Sincerely yours,
Mike.

