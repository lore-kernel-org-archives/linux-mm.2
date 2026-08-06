Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57C4C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE6F6B0095; Thu,  6 Aug 2026 10:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA53C6B0096; Thu,  6 Aug 2026 10:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1D36B0098; Thu,  6 Aug 2026 10:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D91E6B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:59:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C464C0782
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:59:47 +0000 (UTC)
X-FDA: 85071154014.24.0530269
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8333A40009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:59:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=SufsmgqI;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786028385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpaSVlP8u6Eid71P/qQX5dIH8P+evmO5hE0RAEwaHnU=;
	b=S2TsYW6XjuonD1GDZreY7tV4dcPa8IDYaNfAnrHv2Plkqwn9QUAyfPJKhBBtfxmGgirisH
	xyUyOHbo/3HSrMZYaINnrGH4hcextVkQaVtWqYK2qIN47uHwlOApYQZJaLlpMQ+ERVa7C3
	LKUm+9EFBhY9QbYqbHiqpkvi4jq1ebc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=SufsmgqI;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786028385;
	b=wfCWYvNleGAzPx8maPoe3Q5AimdFwfyoomoEhJXnHXoe0tDth/cGPBZ5WriLWVieR7/g2S
	N7kvyQnYWaGg+rwhqPXSWp/tusyZOppKW6Gzu22brUK788CGKgX3RdP3sE5/Yk/h28LggH
	SAHuzpmnXPuuRMypzgLtGVepmLK8YWw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HpaSVlP8u6Eid71P/qQX5dIH8P+evmO5hE0RAEwaHnU=; b=SufsmgqI764RRJwteT9oL3Drw0
	qswd/2rocMBe7UFvQpwBlNGHgbG5NvEq6ZkUyGGqxUW8Hsf9bIziGDlRHqVSShHMy0bec+kpWEUYg
	NGn3dslhLfHFI04xiGBz4phHYSay76I0irDAut5J5zg+0bgcgyuWC7ocLhnzcFwDawbA0Xdv1lhEh
	jQkNg13S7O+fZ4RGYIAue6tG4GTYVK85CCU5BNvZciVei7c9dVy3fb9aqyv1ZwZV5V7KWaM+W8eh7
	jHTXrMB1zyyict4nmV7MTx1g+1C5emG9Nva2wQ6cBrE8xkIq8eMAOUoTfKTKlQBkPKmFsSuIurmpx
	kIqITZXw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wrzZ3-00ElzJ-04;
	Thu, 06 Aug 2026 14:59:21 +0000
Date: Thu, 6 Aug 2026 07:59:14 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <anSg01PFfu7aaEJp@gmail.com>
References: <20260803-kexec_posioned-v3-1-83aa6ede0351@debian.org>
 <anH1JdVtiM9VoXMH@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anH1JdVtiM9VoXMH@thinkstation>
X-Debian-User: leitao
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8333A40009
X-Stat-Signature: o9mz5ojzar5ron5rzw6cfzzfrfy8reo8
X-Rspam-User: 
X-HE-Tag: 1786028385-972197
X-HE-Meta: U2FsdGVkX1+zBIzGggFGLMAAPUosJZdajg81JKQh4cElYhK/zEIJ3PsxbByH8N8uJiLZNKpeEA5D93N7ouricpCKONXwY/5SkzPlcuNXlKlc56rq6ECMk4CoJTfUoiOnKyvJljLMpHgCaas3IdSWc7diUVUnny5/PUpWcugD43UIymaSh1LS3KdoNAsH16GwHUUeoRcvFKc16oxKNBLnshtLKemQxl53xMg7ruAuMAZhwV9SrmJXlxhe/5BAZY5R5P3pjYvQXCr/U9Hv0ar76SOE9xyBJWxO6U+XHjpZs7MOXD03X67QvS9E2vfgr3bnN7KlSUl2Ux94Ta7W/DIOwoVCIKSMgwN4302zsLNttsoFqztCFvJ2EjqyoTVfHbIZHJpVOaqse+AIFWSo+vKRzI7GtOwU+5ksGoGYviEtOCDqgB6aPXpmc2n9xTYM2h5vTlscX3StJ6WtU+LAhL4DRbKm1CP5yGX9hJqvi4BKDUJ34O3NUyKGoqxzzD+aGMgjuwNp64EkJo6AJtqKKOzmr6ff1P35tyy4Ni84sburWQc//z9SuTakNYdUtQ3p36wLY2erNtqgO1mtpmGU4dfLzpTXzzEVDCZa25CwP+0jUfcXnWiAFrzZJk/6LhdEy0YuNieyq3fvC66XSmSV48BwshvEfTI/lGdjP7z24hSxWuVsV0Dr2pF6S+IibDGe6OMaCbTGZU39ONNU9gQ+sXZjt9p+EWuVA8igG83O86qknd343dJSNKcfHvrErLJh9OvTw1SnaMBKT7cRDezuIJpdqY9dIcJu/0VMt6EtMmi9OjDy83TDOcGM4WQzFY7lHC8Kx87AuwQuK/pj0LALSxBrxBNCbzStDnF89aBKx7NecjtjPTgzwgdRQh7ceYec5/T5b73KLFGLT4JyNmi3uMuwVGYBSdDNzXfnGaC9dop/K+NJvt/6vki5L7BwO64tMwsQEToAc6sBBfLoLKkEEYx
 nWNDmMYY
 5qyf98vOn247te417qU/yonXH3hGVCMytQ6ldICGbMJTK9Q+dgC5YBnYKWEL2SywDxf1IKZx18n82eUUIzxv+tW35esHhCSoVBsDhApvYjAk2czSPM/9OSo1A4Lv05Err8xyUjZdipmjFfektkF179tUN0MyWSkGVl9KJbELI6kbEXe1Es0TEa4y3Ghtxbcx5U/cR4UeI7g4ubY0SgkkFvgrcaOxMPV1/C+3whzOlOS3jie8uF6R4l0JYAwj52jQ4VYOb+9K+tqHtME2F/9YKntLMVrkLLDoZ2QC4WG4xHdPjbNFr7IyETG5+BDx3SUtpsNPDbqvzofiWBxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 03:36:47PM +0100, Kiryl Shutsemau wrote:
> On Mon, Aug 03, 2026 at 05:41:10AM -0700, Breno Leitao wrote:
> > @@ -504,6 +505,15 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
> >  			continue;
> >  		}
> >  
> > +		poison = range_last_hwpoison(temp_start, kbuf->memsz);
> > +		if (poison != PHYS_ADDR_MAX) {
> > +			/* we hit a poisoned page */
> > +			if (poison < kbuf->memsz)
> > +				return 0;
> > +			temp_start = poison - kbuf->memsz;
> > +			continue;
> > +		}
> > +
> 
> Hm. Don't we want range_first_hwpoison() for top-down walk? Otherwise
> the end of range would land on poison.

Sure, In this case would have both,  range_last_hwpoison() for
locate_mem_hole_bottom_up() and range_first_hwpoison() for
locate_mem_hole_top_down().

> > +	end_pfn = PHYS_PFN(start + size - 1);
> > +	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
> > +		struct page *page = pfn_to_online_page(pfn);
> > +
> > +		if (page && PageHWPoison(page))
> > +			poison = PFN_PHYS(pfn);
> 
> Oh... I think it will not work for hugetlb pages. It will give
> false-negative.
> 
> We cannot just set the bit hugetlb pages as we don't always have memory
> for tail page -- look at HugeTLB Vmemmap Optimization (HVO). Hugetlb
> uses a trick to encode poison page. See code that uses _hugetlb_hwpoison
> in struct folio.
> 
> I think we need special-case hugetlb here. (One more reminder why I hate
> HugeTLB).

Confirmed -- hugetlb_update_hwpoison() sets the flag on the folio and
keeps the bad subpages on the raw_hwp_list, so a per-pfn scan only sees
the head and misses the tails.

Let me add this special case for our beloved hugeTLB.

Thanks for the review,
--breno

