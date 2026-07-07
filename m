Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC438C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838D86B009D; Tue,  7 Jul 2026 00:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2816B009E; Tue,  7 Jul 2026 00:53:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68CFC6B009F; Tue,  7 Jul 2026 00:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C25D6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:53:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1156A02D8
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:53:51 +0000 (UTC)
X-FDA: 84960763062.01.5B5AC0A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 02EE94000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:53:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=h+wiQnAo;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783400030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNkSEK+HvFWgew8qT2LZ9tewGZDZTkJj36P11icWQDk=;
	b=GhjYH9W0hwr9VLtKUTP+jweaWhFojC+4ZMn5ptmzLkSHzOBmi2B++jz4WvsTHLK6PI8iMl
	sso0ASS0YBRxkP0Z4KoTG6oYT03zpsBpMRCUIQnn6RTFuFmS721dnKUwVGZtx0zPJ93/Rb
	QNuGdUD/pxsJIHyccsMveAefsauSXNA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783400030;
	b=M6JA6fLqzUYMnFOtpjgMNc/VcBe6PsRfexDvRqry+QclFqDm4zUi+DlcJSS+nCyDBPio4e
	+nqQTNuFSlKrlB7qej5rYMmfsT97Aj7fe68l1FMokUK2Q9+G3TXN0d4/ovHjefl4KpRQh9
	levzci6hqcMEuq6rJzGXe/jcWiQsVhU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=h+wiQnAo;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZNkSEK+HvFWgew8qT2LZ9tewGZDZTkJj36P11icWQDk=; b=h+wiQnAoKkVAmJRB+OEo983N4G
	Y7JHUEujPz/FnemfTyAxC6zfmndkahUKnLNTjBudc43Z2pGlHX4UaG45S9wnaK3F1IAcUEaIGWLNZ
	njvHXsdJSlx7ucOnXQ1MKRyBg8F5j++MQIOv1ELZ9J3pB8HzRYTgv99GYyn+4Ik7Z9oFRlXhYTZDb
	TavglLsUNTX7yJMwwQVdCQypAcSUkNlx+jfI6t4An5UhcCS+CZC6ZrdQQbInxZXu27N+d1Hq5G8ZU
	ZoT3ucMukkSXnnEJ4voV9zYtasCIj8zrdYVlXIle8puDLZ1d4d7LMeRkIcQGfu9CZygqTtzgnVBtz
	8NIC+WRQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgxoX-0000000H94J-1ifE;
	Tue, 07 Jul 2026 04:53:45 +0000
Date: Tue, 7 Jul 2026 05:53:45 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, andriy.shevchenko@linux.intel.com,
	usama.arif@linux.dev, hughd@google.com,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Standardize printing for pgtable entries
Message-ID: <akyGWZCRbasIX_wY@casper.infradead.org>
References: <20260707041703.658021-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707041703.658021-1-anshuman.khandual@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 02EE94000A
X-Stat-Signature: ff3zmbuu6uerjsn8sdkp8kft8ht9g88x
X-HE-Tag: 1783400028-375489
X-HE-Meta: U2FsdGVkX18OoO3EhozOIjlP1AQoZkvSzzce4luriqbDIZ5BBe0vN7qJDr6x0NCgMft1HwWcsOwikfD+NXjZ46iqBsbelN620Bq9vjL5m4LNw45D6e4sCLzdEGDIMdIAo51etP7bNwrDTxCOWO9mPbVzhWs1y1UqNjEZ5sYxRy+Tkf4iqbPAEIGnfjUjhNrGVKqo3C5OCIQJXkZVn8t2nEpwGOKVXw+u3cvDkUHvHuHF5DDmByPOH3UmMjqdE4VkT5hmLqd6BtMyS5EnhK0J5WdmWFM4hTzfqHZK6mZZvPON4l6rkqsNGwg4shyOBkMp22ot2meOS0HCE0h5V752Fc2zLWFHF2DqE4yo7U0K5r6ixdF7LeL63hsqqWVELR6MOUIq2XSO9eMo7kOeUcDh+f3tydi/bTjArfIX1DQyxGYedyWE/BWCOdC4CkdSgtU4yLo9D35NOLNEtFAVquVt+xPTDj5hOeK2MjGDmk9I0OJRWXWk1/IpKB4ZJ1pb/p1Zr9P+PpmC2vlK/aYGxkf96CYj44Ngzc9NCm3a6pcXME5rq64I2fWrW770efti8vgJtYZ8+CXZaahK84cRi4LTTtDYe53UMjOWALDEIsTs4iLaHMCEx+NMeMhawB9VOoTHcPYOhsabe/hnqO9Qip5mfcmSZp85ZeVDjAI2KhNRJg4rL0an0aqjvd6jslSyO2+Ha9Q0SboXZtSiTcotGJ3oCWae6NFNXq7mTDw5swPUSNqxB14LYNMi2rvPbBcJj804U4HZB+98BoYb4MoVvlfgYitAh8XmhEQc4Gct16s8uLGax7xldD1Mc4x6sU8+SE3EP5C4sTB6X9+DRqFPaxCIxznj45xflgCYnetTXV/5CK2pPFoxsqNykrR95Eb6TcrytUU6DrJdm7WtxX8PCvV1UiyU5JWRb1PX7fTWNoq/39YAirW9AqY22Hm2bwkaBUiyto7rvkn8Gj6YwHyehrs
 gik5hEjb
 N+b9jA76zJ6KGxQacVpPMm4Cer903LJqojwtiKHJi134NyM3++mJPZw481lb6J+/EsCyxCYNcI47zYHgj5zpxhXMHBDGl2HwdxqWJNr0cYN/wA+/kkwcrZ61cDUS+C0kRI7245KpruPgpBGgVj3PbbfLNoHUVy9yoZneWO1Eswgruao9lwIZQx2FOhKaMQVCC3BlWqm3slKruKULykGHSeisd9+huGeZL6oolkZNLd73VJ3QbKOVOvVTmy9OcWie0qQfsnW+T2bIg7EI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 09:47:03AM +0530, Anshuman Khandual wrote:
>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
> -		pr_alert("pgd:%08llx\n", pgdv);
> +		pr_alert("pgd: %s\n", pgd_str);

I don't like the extra space being introduced after the colon.
It's normal practice to not do that.

But in general, this looks a lot better.

