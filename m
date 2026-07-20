Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34B58C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 16:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5A66B0088; Mon, 20 Jul 2026 12:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56966B008A; Mon, 20 Jul 2026 12:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47016B008C; Mon, 20 Jul 2026 12:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4E496B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:57:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 320084021C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:57:17 +0000 (UTC)
X-FDA: 85009760514.10.F62C5FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9B95B40006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:57:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D+0rOHtL;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784566635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgRqdur5Aq89BYIHBKmsVqb4F2JYjXW5a2Hi291ynfM=;
	b=OaMk2VRD9k2PHVu4c7PPwIPOSbH9DxioaACxFJpcrrj2Q/z34xPhzaB/VSydYTmNN3OyXV
	78d3Uresl9hoMY7g44WvHWZd3riQHB19nHQ2VSRzJEXHXvYFWw9fwNC0xaywJq7vndByU7
	aPszSOvV2x8+AFBjEbz/aXD+h44veV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784566635;
	b=PnhL8L0nViuIlq7UnGccKYL7fDV8vQ4kBhHQfuXaDUKsAsmH1Gy18Y3uFwwS1g6npyZqUT
	KWsbzemk7VeE/xSSekK3n0/Fw1e5pnHo1btxUFhU55xGdt1QJiPkeMdncNlzhhnLd4k1t3
	bEqwagAtsSFo60DPgCKNA92c1ZrC2hQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D+0rOHtL;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20B74600AD;
	Mon, 20 Jul 2026 16:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE211F000E9;
	Mon, 20 Jul 2026 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784566634;
	bh=FgRqdur5Aq89BYIHBKmsVqb4F2JYjXW5a2Hi291ynfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D+0rOHtLblFwv1vQAqZ8n4q2BZoYC269f3Dj57lfrIBGErTNJD/ZYF25Y3WWqLxGq
	 4WTUIQlDQYafI6HXCPO9JiU/4HGyisqChLYoQJ77S8gvVANMOZ4b3wIFn0ataNuU5U
	 RfUJcexBOxRvNQDvHjnu6mJPEh4j5US50wR8aAVlxvGhwOaHsvPPvhjmYNmJCmmSn3
	 //zVqCHibaaafUmFIkS127+nNOOWV9s+QAK1sQnL/vYWkcQGU2/1bHPY8WNj3cC87y
	 9x7zj/NMEU1g/vZy10JPPqjaFLijBgzW1JF7WXsIN0mHSZOruoXt7GRSj/RarAIGpS
	 UlyhA5WZmxRww==
Date: Mon, 20 Jul 2026 17:56:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 01/15] mm/vma: introduce VMA virtual page offset field
 and add helpers
Message-ID: <al5Surm6fPIl4LNA@lucifer>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
 <20260720-b4-scalable-cow-virt-pgoff-v2-1-2d549757a76f@kernel.org>
 <al5CPpc7XpRX7Vbt@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al5CPpc7XpRX7Vbt@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 9B95B40006
X-Stat-Signature: wmzi1o93553wacj36is8xgcdztsack9w
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784566635-493715
X-HE-Meta: U2FsdGVkX1+HOX8T00KWGe9Mm46QmHLOzpMw6Rr+/h4nd4sWN9ViZl99HhvvQG6gjhyC+UuywgD4CtbCoJZJAJ4jsR8/st6TWf6pr2LPbzz2DdT64Nvt/pmaaWtIb18G9z1ev9i/429XeBOsRDOCcuLSuu8yq9KEYhRO0Gv0p+SwUHUp9gqe1n54ASS2rZdLBlHX2bGaTZRUNPGeV+adG2746rprqyRymdTlbixNOnKpUXY+8d+mzBPULW81oezEsqSOM4WGwacyhuDepo4nnKRgXjsR0YvXeGB/kf6vlDHZNdzm95C2DgfkZOUh8o2e9RhWK13Tca0/Gw0A4/B7dxvgvox/tlCP2VFpgTFvrrbP5ChzPySWCLd2W7AJ0TSu0Ck4xW0sc4eWeCKYgZZEPydfXEPfQmhoN83rgFHgwjFrEGLXpXleH5O4rqHweyBulQhi5b16OqCJkxbiP8RAV3IWXlst//Vlw6OJvW+Sc2kEejKJFaqaWWCSq2/Bjseyd1DeZY+lsUPI0QuTA1ui2SBd45hbOXmly6CBvqYQNU/V6o1ng9SJdwNprzLym8yBpWoA2Ut/BsKnCW/zvI2gyqWaHMZ6ASI/c9NqcO3ezBlcYxAieBk8v6aFCGMecaXPH7WgbG2GyLPmYXrN+5C1Kas6HbeXXnwA4XoajIk6TLe2kJOcWbHP3TkpM4InPjyUWxrQze3/QXVmf8LccUTbUH5azrilt9YRBIX29ilG06Sy5RNhVv69BQ/l2YZaGecy/4XV1/aZXzhnlqtweEi8d3iDrQhDz1whHtJqwR8SY8v8rggUUxcGmqSNJqybxM67ZJMBmOBxxoBbvQX5R2H6M5aIczj0wm4rT/52XgA+vRp+JYpFT2SfHlhJI5Oz8/RirfTj6dZT9yI4w2siklkV+HrATq2pcTXhpvx+7MMsiknmAORrdsTLnthoGQSylSBAWRknF5Eyuj7lB/6nOTM
 MWFEq6Ie
 8E3E5IUpzRX/lQLQ1PvaDaYjX8Dk4od+VjWOx3B2++3Sh45n7X75fTrNS9mG9VN9U03f2+jnVqce1rXstbWkU2jRaN8ox/SiAaHDXfQxU8IOxcguQVXDjitouEzXvMPS8Zb3seMhkuLCH86viOkoQCYS3qTxd+oseGYDIvuEFuL1dR85qHpKdrdV1gqv0pn4A9Wpp83val+k3yRVME1E7mqH1potGKCm2210r71ZzHsV2miXyuyWKtTSTVs0kpB7hBr5u6Jv33SjPBs0ceMnuczlr9tP9LcneQJNl2KbuSM+41e9YMmdN6jTtKbMX0Jtf6TPk29odpinYOSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 11:49:00AM -0400, Gregory Price wrote:
> On Mon, Jul 20, 2026 at 03:38:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > The virtual page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT if
> > they are unfaulted or were not remapped, otherwise it is equal to this
> > value at the point of first fault.
> >
>
> The latter half of this description is a bit confusing.
>
> Why would the value differ from (vma->vm_start >> PAGE_SHIFT)?
> (because it's file backed?

Because the VMA gets remapped.

If it's remapped when it's unfaulted, then virtual page offset gets updated, if
it's faulted then not.

That's because when faulted folios may reference the original offset :)

Scalable CoW will likely change this but that's a forthcoming series of many
series :P

>
> It sounds like this value can change in response to an event, which
> makes me thing a reader could see two values across two calls?

Remapping :) and no a reader cannot (locking etc. :P)

>
> Apologies if i'm fundamentally misunderstanding something.

No that's a sign that probably I'm not being clear enough! Can try to clarify on
next respin.

>
> ~Gregory

Cheers, Lorenzo

