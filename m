Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91363C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB216B00A0; Mon,  7 Sep 2026 08:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3716B00A4; Mon,  7 Sep 2026 08:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB9E6B00A6; Mon,  7 Sep 2026 08:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF1F6B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:59:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A6A312015A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:59:49 +0000 (UTC)
X-FDA: 85186973298.15.2C91C48
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf27.hostedemail.com (Postfix) with ESMTP id 12C0A40002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:59:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b G1F3G7";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=IayrZM0F;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785987;
	b=dShRNnGe4havY3XuqjUlpNwS6ABwwE1meputrlK0lKWA5DtJpcHv8OHRZjhqJlkgblASRU
	8JYjvxDPaMqNZN9pgM7wrx6ydZG1dkhYcgWS8yXsFaq0PGJgkrZJb5z+L/ipYclQORolgo
	OnhXHkM1WR6aPDsbYc5cEhK8ah5sRls=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b G1F3G7";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=IayrZM0F;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYDGB/RXWunUBHizdGiMziv4O2zhbYW2jWaEbKuOHsI=;
	b=czHN230kqzeCiKeCt9hA1KWTXshor2mbbMhJBwzPZUr7UDW88eJklx/ID7Yvlonh1mYJ9H
	ePy6o/Lnmt0UTwM0Zd6lEENvHP38oJ1Q4KrGk5JMCG5+uDbz7q1DbGrGYVthU0YzQeDOo7
	XyJHTA6YVVSQxDccDFQ5kZda4/RjB68=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 633F41380054;
	Mon,  7 Sep 2026 08:59:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 07 Sep 2026 08:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788785986; x=
	1788793186; bh=lYDGB/RXWunUBHizdGiMziv4O2zhbYW2jWaEbKuOHsI=; b=b
	G1F3G79iC03Ct6JwvcO+c5TCzquytWTPpldQGzzb3BrMw3yKtHS03Y49D3tCbhhE
	yhBa95NKaEoz9uAijnkv1y/zgutADJBIg8iBi+EBLjaQqYRzGVhWegX5L8QdxqPE
	5NhrT1sxjgSyHujPJdg+mJpJs4GYODMgNaenjrRFL0c+XdM/MBXrWG9+Mvlx9Pmp
	OoObvnqUD1h38zBA6gjYLeRqwGQHQrbiHvFJjHmpwYHE/DaeMwcAdoFZ/iLPP4IN
	uRFQc6L2zX3w6DFK2DxjAD8F5/jOs1QEiQ8rdGt3a6vbiHmKhp6hWw/Jh+fRiQZX
	Id9NzriDuk4ES9VUGSLqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788785986; x=1788793186; bh=lYDGB/RXWunUBHizdGiMziv4O2zhbYW2jWa
	EbKuOHsI=; b=IayrZM0FqNCpp7HFPd7Ovd70efH1vXDuTyb4BuTqXMndLQVFYiO
	Rm43PEw5vcxHL8byV6kOe4FZF8b2ZL/Bu/Pxk/ZFx2Z854UkGanu+YebEQ6y5NFX
	/6oCrEhl9qIf69LVNABM4Z8NnI657ihA8pvyKJrJISUtxi2mmkd3fMK+JWG+ajGZ
	3k+YVD3VxuAzrYEwVCFgmMBnZTCwypwrPRbwUI18P6ANHY00k+kyagOH9uFDrcBu
	pcXcAo+Br7LjIghJGgOL3SVfEgbJKNbXVc8V43kZwHD1kW5fWFAkJTXwjW926MFv
	o+NWxrlWOqi2K/TbrYXt7bM8ExAgUpwNF8w==
X-ME-Sender: <xms:QbWeatZoN5cL5KI_BtpTGntigHz0Ugcb6QzkLKV6fcYkLbbhtv7-yw>
    <xme:QbWeatashrvgTrojrqEtRF96HwS50lAJl4nrXP2BEAl98FEQUKZ1mnnKaMC48exYl
    SbnMMLQRGIKAN5z49gZsHZWD90GIvCcSLhhttd0dMP50d7R_zTJ5bMl>
X-ME-Received: <xmr:QbWeapruxHftV97YXljez7WSiuCOEM_KXSC9n9N4JHpWzHQjS-tsU7zex0I>
X-ME-Proxy-Cause: dmFkZTE/RyyJEHpH/xeKsN4XNBiUmGFM48RXSJCmmPUQ993cXAA4f4cCG2jBf4pg29mZZH
    T0r5B8dg0Dgu/wTg3OkNeKKPGFjIPrnT+MxaTt+8JtQRA42zTbyuy6nvryU5phm5fb7if/
    z4Wbe/ItURKbRrCxTBW72oofYLTVqcjT+80q6k9+Mq+e2HmMOB7x7rGOcl+QvJIGaHfcn6
    bVTQrWtvCBDnpBojICyjPD/5jOkMukeqbAaxJ8Wicr9D+j+A0z1NtJx39x4bQFcjxdrDIJ
    YU1+rDhx99mj0WMR+3CjWZPMSKi3uW9hcvcF6FVFP+f/sCGSJy8pp4S0me+2cvoQSw44ky
    KZMB7bjnQkGZmvAr928a4dgg0aB2Bp/gcycSjNt7fDIMjbomTTe0f26+r67PDOeOL8bR5e
    PFPwiapu00b1fFRij9so+5V+/TLFms3zeeWD5ln9qxQX7UvD+joArJiZ4wwm29xa2JUHT6
    q9eeZqsygeA42u0Y+ogLcjyAos13BOO8I8JADXNpIMJy5WYMu3T3pDbzDtupDuoO/NFZ0E
    6A0t8bzPVeuLuW85BMr49/F5OazgMuHDrN8QMptNFdvfcZBMGUgClGmKC/KU6dHpsy5EPr
    joPL+Y8gAC4Y9wOGnaFkpCO3C3XPjvoNy1yaVVSezyY3ZwayIZYc4OS4HS0Q
X-ME-Proxy: <xmx:QbWeailDfJP8gGeUlK9_5ekuwXlnmH-Gie1kPnAicPACaBy5pojlhg>
    <xmx:QbWearWK0qk44MiQJ1sRqt49J60_pHycK9_DnalTR6-1v5ZiwIT3bQ>
    <xmx:QbWeapQ7OAETFED8c77bY9SX04yprCcbrQL_Z6AO_Tbn-3sQ0eYpJQ>
    <xmx:QbWeaoloQZT4G3otJX8A33K7IjAuRjlkK0avTjegMoErcCXgS5lfPg>
    <xmx:QrWeaj4fqco_THgKMBs-0rzUYSbsMisBGtFVVJ5uiDL4x77Ik8ZHK3Yb>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Sep 2026 08:59:44 -0400 (EDT)
Date: Mon, 7 Sep 2026 13:59:43 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 08/19] selftests/mm: add folio-order check for address
 ranges
Message-ID: <ap60vvh09oqrQZ_T@thinkstation>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-9-kirill@shutemov.name>
 <aoQxLVg3IsTuA9NE@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoQxLVg3IsTuA9NE@lucifer>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 12C0A40002
X-Stat-Signature: nxc33jg6corx7pxmkh6swgp3wwr31c7m
X-Rspam-User: 
X-HE-Tag: 1788785986-966153
X-HE-Meta: U2FsdGVkX1/wD+ciBra65S1c2TRX+q0cnbKRjxP8rZm3agBna4ITG8ExJD8T21EDieO3i0tAGf9Zdql/kKhqgeYbwqqPp0SObwEegkRTnUK3KDxUUE5syHkYykNTKcjzr6pZj9VcRUZFKA4H5TnxKM6n9LYWqWj6zgVZgLK9xU9ctcCGI6O0YP+akg/RYlqQG1L/uW9b/cIwobAuyl5f6pZEC7ORQnEkmTPdF/kUV8xjfo7w38bU0XfrlfgGMD377LA4FetuNOeS+z8XflcU/GVyxnxs0K1W4QxP+79c7IZ5kHscgfP7SNRGKKGoHiGYtX3UlGVa+oxunRfSkC3L6SINk87+BM0mro1OAi0sts1TeqJ2jOqddajUJkGm1AVRODVNqe5czeFVYsP8wmBGdQeDWIJBK6LSs4HLKx8YdMx1QIh6AAO/2jGJoW7ZEV8mBMROrGxGKEHddLOSdqb8SOhusq3lsu65v/8K9awI1tOO3ZlrZWjNDW4gPSdWgxR8BsJnZIRu/vYSg2j8ynTRbv5dLP9KXySJErm5o0NbEJHtYx6AN5XT2Si4EyyhrhQRY4ui50c0xSNbjnMlvgXOsOgxOCZ3MMSyGHvWquASK+HqSTPCM0abspZ8gVBefmWn/vYPT23/edZLmhpQtAbO/JScCCrxWPa0ryU25TyPQlbyRh9OofUTYDKxNbE1tzQ//pvdqirzQDClSHGrTXCNsZl5a2OTLCkQttsWha24nwIkCUnwSL04072rHu63dZQ53nA0QaNlEED25L+kv+ccTuwQlrDcPxN2TjLpnDrdGFddpc9X7H1O2kXCDAhDe8WBwt6XUKRBft+JL1Tu4p0h4L95HZ6FHDNYvQn8G4pEzrlCdzAwi0OIQD8+XW/ftV8AE5YiANxh6NRMtEKWUOCKbOIaVIRhpoAzdHsJfRrCralOsDqpQ3GmzySrr+HiFS8rzeRkye+vc3U6LNt75gL
 K812ZtSB
 Glxr9053p2K9oxt319Iuw4ds6bj1BBYUHP2LCgaJ8Hsyi4gHtBRSLNFc4N8HArJgHYK09I7u7sOni3Cgpn4qVAee3pw66bvAMkCtWkeoVemXVF9P02m41+6LLqbDcdwCFIWU4pCIzGDvoeb1/p4H1u/eoUVYo4+BacKs674QgGDmN0fsTxYX+lNEbdPnnQs0jliFxBAcEDand55wdeCbkH6ub6NCcxyt3t6Fic2PW7dwhaCnQiTAvGF/3ZFUqBAxGTvQ3uOhEANbYFyUUPKWkieUPHQ41pbPaCaL0wIofkpei8irgM62V0ujvhH9CWbzIIaA5SuXnweNu4v6g3YXYfOGVt/MzG5/Sb+7yt1FLW50FQ7npCey4GD9P818hnKvDCPevDZdtYnTXmdPaBeHFf2pPg6sac/2ueqLzcAbmKQxNawtTiiWIcBnfdg/eicOCWaHg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 11:25:27AM +0100, Lorenzo Stoakes (ARM) wrote:
> > +bool is_range_backed_by_folio_orders(char *start, size_t len, int order,
> 
> is_range_mthp_backed() seems a lot clearer?
> 

I would rather keep the order in the name.

The helper checks that the range is backed by folios of exactly the
order the caller names, and the mTHP cases call it three times per check
at three different orders to tell them apart -- reporting an order-7
folio as order-6 is a bug.

It is also called with order 0, which is not an mTHP.

Going with is_range_backed_by_order() in v5.

Everything else here taken as suggested, and the comment made kdoc.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

