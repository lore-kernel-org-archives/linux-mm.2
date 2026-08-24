Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D40C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBCA6B0088; Mon, 24 Aug 2026 04:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3376B0095; Mon, 24 Aug 2026 04:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1AE6B0099; Mon, 24 Aug 2026 04:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8D026B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:59:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DF00A04BB
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:40 +0000 (UTC)
X-FDA: 85135564920.12.3DAADCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1633100005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nSOSNJ/x";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787561978;
	b=D/am2b/mxxYcei36OHvU07j7Hr7K0GZn/b3W4WcDFGJTxB4Hugmnncinllm75pKI/sBIjD
	UP5hG6MK4fRY2GRr9wbnP+mQPoXRmUNh4kY6cBXV/mxY/z3rrh+K4zH/hLnI1H2aThf7CG
	1/d8HBvBG/3OQwxjVmwIC2oPHybZh08=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nSOSNJ/x";
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787561978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MtFZbBvhVgSrrQ2FEoKn7ps4231x+9DOOXmcLhgSNU=;
	b=S1vQ9RwPU7KdwHK3ivPxRX6mE62SPi7li15OuoYa3ftTdysmODSytecNddV1b/T2SV76Mi
	d0RpCkw5TZOMSgJLJEtS7g9XFdCh38hUlphJkYGE8l8CaXzeAThKt5/KW5mf6OZvOCL8sQ
	f04r+GCkkJvVT8f4UmaOPv9DwR8jpFg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EE186011F;
	Mon, 24 Aug 2026 08:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84EC1F000E9;
	Mon, 24 Aug 2026 08:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787561978;
	bh=7MtFZbBvhVgSrrQ2FEoKn7ps4231x+9DOOXmcLhgSNU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=nSOSNJ/xv294pkPFVCN+Bs2dwSmln5GM8DE55jno5trBcls0LH6NtrNn8nPVOOhhi
	 K7JQL9IASwEPcuK08soF7+zTiS40VD+vbsiVBz0AFhZS34+nfxth1ulthZgVgZutcC
	 8EIt+rhQBLK180mgEzLi3xCGieNDEl65Nftpm+mn45KyGqiaAVpG8Pd3r5ZHshJNJX
	 oi0BWwLTZw0LIxcJ91lpO+Orbl1KleHlEJ1idy7bvIw6jIL502ojrw9UB3yOdPvX7w
	 Zjmy3uDpU8lbhxcDbhoemaNhz7ZRhmtJZaozM6ctl9RasMKho6JpE+6VzRcAl289Hw
	 1dTCwVmRT6y5A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 05/17] mm/sparse-vmemmap: support section-based
 vmemmap accounting
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260819095140.17252-6-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
 <20260819095140.17252-6-songmuchun@bytedance.com>
Date: Mon, 24 Aug 2026 11:59:27 +0300
Message-Id: <178756196749.3606540.5168294628731455207.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: C1633100005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hsrc57r9iknk96hzbtzzooywg7zfiw1w
X-HE-Tag: 1787561978-846721
X-HE-Meta: U2FsdGVkX1/IpFA3QHSoh5ncdsYHqRk5p3sGBIczOe1GxHpBAd3eqAb4cAYOhHWzQVMaU9gV40qtc4HZf0FIi69riptU0Bj6/Oo4QXVFihVhbDHU0tNZYT/A2S8POkHofJy5JGQYcsypMGWAWHG2t+OUMdT8OnyreU9ZYruGuWs2Jy8azR/ha7/EnLgfSb38ovtEgF9mEPRcMGPVH9V7l834Akk3J3HZTMRuHZjz+zNUomIcP+1CN1embw4EQsmsCgZomu+SxmIeL/RZLURcufEVJXAPafZl6BsiVTupdpBAkSrrmkQlVK8S3pTayUDhWDCIPY5TbRFSOj/7/jVaASJr44qAh5ycYG0Dsxb9b5mBpwmdLxuWDbThKDpxOFzkKdVbv3uKzlwubPlf3EzlcZQswcsMazmlJnPkE3Ovys8nRCiEBC7NlAHTCsDkf4wttHz8HhCpXQ4XmkzSydbnaRAoc1aprplu10TWZd1rkLbRyACUP8pDlj+ipg+6EQ+TOv8co2FSV2YWtbKrI0Bho7g3xUJuFhq0JPcoCQOIItj4/cCkp/6kWlhc3hZItCB4ECb/ltXOL2txDStM+FHAkdO9bvKx48+Zf1uBPoIDIhsFfXr/+ebBkDmtEAkG7cfNZphlc3DvoxnNzYAj9fQZ1NFpOcr64GIZwFiuCaEaYIZ8DgNaRnMzAVnYBHz+C6OdtvmenrIjM3ag04UZFF4nYigahTp2pvxiUD7e5rae+dyPRfs8SEh327Ev5AXaM7Z1w3TBwEVOwOrkHY0ekD4OfLeMQAjwR/d/8OmlVX3R9DKmcVW+HICkk4jcbHYU4bR3bvFyxF1PWWlq0A7VNq0MnWgHaZZ/oUzKJTer8woyI4a4sj0/FTOkjAgAmMrRaJUPHUn0xIL2eoEP14b6yyn9DLhMX5+eyWwOclraG6srEOOrCq1FTVHmiqkY80PdaJXwoU6KqhacYoeHr21pxpl
 52U2sGil
 SfNw2O/z9aqvuL5Lg24o5VlI8C+WJlVoB3DmvFTH7oBCmgWvmPcI/uGZoWHUdDhH86/p3xlqy0cUWKVwkmnLmFGM8OzYda3rRNdSuCchcGBW9xak5TrlbWmDGceJ+SMWi41w7PO2NxdfkoYf7o7ITIo5s1LQmyDG30Nhl/EEFBtuBNhabZoYHsYuN5ikD2+U4CA2b2hPQgk4o2a/EPAEXzR8XxQZMX4LJqUIrKsyWmbtdlIw3HJ1vwg6Mhz3eJ5x2PmMAM3ylUCnofqGeODVXE3S28GTlc1CvkkF85Xt0B+nahw9btGeJhceu1BFVugiLkdVCabtsF/jmXaI8WkA+d3vcIjz56bwDF75DnLuUsLCY7ic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Aug 2026 17:51:27 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> section_nr_vmemmap_pages() can account ordinary sections and DAX sections,
> but section-based vmemmap optimization keeps its compound order in struct
> mem_section and retains a different number of vmemmap pages.
> 
> Teach section_nr_vmemmap_pages() to recognize section-based optimized
> sections and calculate their vmemmap page count from the section order
> and the HVO retained page count.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


