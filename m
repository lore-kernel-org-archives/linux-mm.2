Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 296E8C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32ACB6B00A5; Tue, 15 Sep 2026 10:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB156B00A6; Tue, 15 Sep 2026 10:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6276B00A7; Tue, 15 Sep 2026 10:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB68F6B00A5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:35:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74714120446
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:35:37 +0000 (UTC)
X-FDA: 85216245114.02.6A9CEE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C419440007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:35:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VtKFlspQ;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhkTKZqSauRlzDBmuIch4WSDGbcfsJp9na+AzwvnNew=;
	b=SY5cjMz8S5aLWXTB1DRMn2QLnW5DsKsrJSq/4i1Q7Ev4qZEMRJOZy9zP34za38O3lkVeSh
	LcxgVIaiRwha4uyEpaLTCmysqqzxvVN7bSfNjzcWd98xJGPzuAAbVrbqtCHex8RDvLKl7n
	cMnKgroHB9jx1npD8kuzDc8XP4IYt4M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482935;
	b=7LIHb1WmeRKu8kt6YYCHqWgfULIYbnABafHj/mtWPvLmx0HVyXAuHJoBWjjqDgVQfkf5XF
	hyUrBE7aE7zudxY+tpXT5mdoDTKPmNMf/B1okq4pZJVakBa+hgNM/xD1zCcK6+JkOC3VOQ
	dy5J7IGT+w9JZQjGJXehkntEGCi7Mic=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VtKFlspQ;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43B0B600C8;
	Tue, 15 Sep 2026 14:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806681F000FF;
	Tue, 15 Sep 2026 14:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482935;
	bh=HhkTKZqSauRlzDBmuIch4WSDGbcfsJp9na+AzwvnNew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VtKFlspQzOv/Zif2Ow84xQkRnLY0nrqHqoynrLyvg5SIxf+bnjB9jvnYZlJFCKoHk
	 Fsvtg3M88EQ9y23RcTgrVdPVCC12nYfwrTuUPtF7T8/em/9zQkHdQ/95dP05TspWKr
	 wlJbsjBRL2Kjst/08D5KbDCRo3s86XhKAa/vOUrCH037W/omFf9HgCtaWZYqYpWYMl
	 uKKz66IuX3ETy+gTxW9l3SEAwkF8wt6lilp3aw3yD1ss5zU4+IsNIrAC1l7/o+T56X
	 Rlmf4Odr5SnNyIpzIyI9wkTJHAURu7kq0z029COy9SPWurwLO8XzjMUfs1HWzJdOGd
	 394I86ioQiGRQ==
Date: Tue, 15 Sep 2026 15:35:33 +0100
From: Harry Yoo <harry@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqlMiLMZ_6RBbtgE@thinkstation>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
 <aqKhgPKzRf0e22s3@gmail.com>
 <aqkIdVhoG2wwVBtb@gmail.com>
 <aqkyT0Ui9h5KWuzn@thinkstation>
 <aqk4NUnq92ftuUuJ@gmail.com>
 <aqlFnuIIECOyaweo@thinkstation>
 <aqlI264D-PxJzPWb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqlI264D-PxJzPWb@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C419440007
X-Stat-Signature: 3e54ztsy1587uxwq3tngjhdnspqy7xwn
X-Rspam-User: 
X-HE-Tag: 1789482935-161581
X-HE-Meta: U2FsdGVkX1/g/uIdcmSmf3xzyxWYbLIq+1Vg/pxCk8In5Y3/YGibWLHaGZMgGTuqfvwNBlNlM1u0TNn6tGvPLB5CaDPHjOTOkC+jPIP75r5737erQfwS+Aa5SWQLzXDRnM6enY2IMkrV1oPg93xBHYgi6no9GY+P78u1XOiqgMgDE/FynDTkzNn4wU8+Z+43y5TUVZLVWDfXe3uuEopQVOGcYwgjwVxZwwvz4/qRTQ0w0nlsjSjYavVbwgPLhZfyQc8LN9hS8NHTtCWNxDooiuNpl/3am0nZW8IHkob3r9tBaNIGce3LorDmmyWcqavVdqiTpJ5Y0UmUXK94Op48sOURggtevHre24jiEQ2oDrliNLdoarcC5PYd7HuezuWToQbCLofbovHQDjwVB+KqztC2A0zLqXB9TMi27YoLpZkebKlxRNPtpdbs5BJfUVci7fPKGMdImkMRj2spTs+az3qUEsUjol698j7G5SJxH8VarYbsknLRiG8WjD4rg0JbjTcdgLEbs1xHRTfcdEP0oG2+iZqMDoHY0aYy04iOqaWnZrBiUv8p+3PZDZmW8BSDEHCInraXNuH6tpsZ9FUj/qsebSAJNGVUkJRiXRjOxyDVY0IoUQGBGXY71JcIO09h0rB1x2kUshYb5TjOd697kNbFGxkJRtqG385kA0ugWm42zHQTne24OrU5bhMldWs0gH6kRee1BoVGUjItdmQZuNcn8ejCPV53hvsmSLzD2yQ2zqFJ9Pzv5vpntylLiK26xThPDiTgMXzEd4ADkOId1M6sHXJ37eUhXmlrj/3LehMukwkttTY1QTC65VJh6oLZ8xyvs4t1qhIbo9fTC0Z5sqp5xunJ+HcfdA6ApNyyXkICULPhDRdI1x1G8naVtFdfBLdb7koUIKElnhpf839Ev68UUSyqQgdqTVkdfkyQKQ7ayIpTXuhivtD63+Kl6AZ6j2ytcJYPnzfamMbKofu
 fSTzaaVL
 WbY+G8Cnpqbee3bZysVTWOg4dFZZ8clRu95/0tHDrINVhlRo9avflZ35zTuaz3GseHdFeQu8o+ZuFd7XQqRd7RwdgfWJciNleNOKHzLQmthp1uWDxg/9gHVAkuC0ExTAsN72fcg0KTRiRbq3Sr0neIO58RerBdGO1tfpAzFdmNJsAZZ0OFv3OWSaiHQXYcr77+t2u8ukPp5ZZaof3FLUtwlV7fr0MG4t9yHnKS/Q3BWrxEEhrubQS3DQ7UshboijfGz5QsghGeehVu2pqyp9A4AJpAKEslXuQ5aiB2hzEH3U86wjHvU/pVi8GdRsiVViZ2OgRajrcRNSMn0E7N8bWLOTs0x9KKjNLqBYm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 06:38:47AM -0700, Breno Leitao wrote:
> On Tue, Sep 15, 2026 at 02:31:38PM +0100, Harry Yoo wrote:
> > On Tue, Sep 15, 2026 at 05:39:44AM -0700, Breno Leitao wrote:
> > > > Also, I wonder if some architectures have a scattered set of pfn
> > > > ranges so that the span from the start pfn to the end pfn being much
> > > > larger than the actual physical memory size.
> > > >
> > > > If so it might make more sense to have a bitmap for each pfn range.
> > >
> > > Agreed, having a ->next in linux_efi_poisoned_memory is a good idea that
> > > we can lean on depending on whatever problem comes up down the road.
> > >
> > > Very good point — let's keep this linux_efi_poisoned_memory chain idea in
> > > mind for whenever we need to expand it.
> >
> > You mean 1) keeping the structure as-is for now (and expand later with
> > new EFI table version) or 2) adjusting the structure in the future
> > revision of this patchset?
> 
> I'd say option (1): keep the structure as it is for now, and only adjust
> it once/if we actually decide to implement the hot-add use case.
> 
> That's exactly why I added the "u32 version" field to
> struct linux_efi_poisoned_memory, so, it can be expanded later.

Ack.

> Version 1 (this patchset) covers the common, basic approach. If down the
> road someone sees value in extending it to other use cases (such as
> hot-plug), we can bump it to v2 and add a ->next field then.
> 
> What do you think?

That will work, no strong opinion here.

-- 
Cheers,
Harry / Hyeonggon

