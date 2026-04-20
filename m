Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35288F5A8AA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 18:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1676B0088; Mon, 20 Apr 2026 14:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8926A6B0089; Mon, 20 Apr 2026 14:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0186B008A; Mon, 20 Apr 2026 14:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7018F6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:45:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2781B1B90EF
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:45:02 +0000 (UTC)
X-FDA: 84679811244.21.B7766EE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7BDBF180013
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:45:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gyQvP9NQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776710700; a=rsa-sha256;
	cv=none;
	b=U52yrZNQCbLa31KjI7Fa6WMHGrCxR0c7fyIoCZQkIWu7ZtYqE0KdDFtmO690LQM/JUYi0Q
	osxtE1cEUz4H8iZvqDUtmE3K/MFqnWp2GTm3bAhdsUdNjWD0WD5IQgolp1yJYA+d6ObipK
	U6EnHP8Wiq3cmvzTwUOUp+dp1bWIMwM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gyQvP9NQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776710700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCWzvfTkfoysVZruaWLzaWr+SFpVpTuSMaDm2I0ptYw=;
	b=6C/pVg+ZHGgqqbK0BSzECclAbIxR5QBhA8ycr7FBtxcKc/ek6v20Le81Ro+JTyhO+L5G5M
	NKZpx69nEFfPE+Wse5PoHxhetszGnfzIBpFzpcyAO+SD3Gp7qSupBcZrKdOXJ6P1aPSznK
	FOHRqdt7CqY4enyK/YdK9zvorYxnfKc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CCWzvfTkfoysVZruaWLzaWr+SFpVpTuSMaDm2I0ptYw=; b=gyQvP9NQH4r6dXlwTYIg3EdmZG
	PEZFOWUYAt0Yi1FDtRoC6fLhs7KC9jT0IdU9WwtKOqpKvxq6MWVRZmVDtLoL9KJpHU795TFi6V4Pc
	YIwSLARetSg1gvYxziTCA1HAFg9flSkUpKxt0hkWL2zrnHu1JV+wvoQEax4u/IV1NLSg5NMBZkva5
	gWa95Slf9k/7R0ytd9rTl2PPZNUZik4QWaNTOW64DO4N7DOVq5dP6HL4jmhlgU1zWHLpc8rqumFEB
	T35bPhhRL0G7AjuOg9HT2GQ++O0RmYRoiRR0q5v+EZmG7jjXfTMg5QKsZu+7/XT1bQ8f4Sx5TxYBS
	YLrHcfJA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wEtcA-00000008sWu-39DB;
	Mon, 20 Apr 2026 18:44:58 +0000
Date: Mon, 20 Apr 2026 19:44:58 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: ritesh.list@gmail.com, abuehaze@amazon.de, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <aeZ0Kp8dBqjsyWki@casper.infradead.org>
References: <ldenszsy.ritesh.list@gmail.com>
 <20260420163328.22104-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420163328.22104-1-dipiets@amazon.it>
X-Rspamd-Queue-Id: 7BDBF180013
X-Rspamd-Server: rspam12
X-Stat-Signature: xsk4d5oth1jxjri87kr18jx4gir1jwbw
X-Rspam-User: 
X-HE-Tag: 1776710700-776429
X-HE-Meta: U2FsdGVkX186+ZcvSwZnptyvUIFVxgrbP453c180L6IrhlU/0en9wyGha/CkI7HRhKOA8r+OQL57Xy6eT0DLiBQUa39coMEKAzUz0XGGKOY7/fu3HcaWx5LdU+EKxXyah0IBs9HCmq7ppnsL1FAubBoeaI5wSRuo6PO6E/bckb//UasI7DYDXbrwrXrvO0wNmkyS747qa+VwCt2ONmq3feZ7SuFuPfFA6zQN8v05hAinPpd0aT8CxHB+f5/SM3YL5/aBmObBCAfEe++W0npMYDnvzTmOa76WIZioZ0VYA3/FzAV8r4XSwdhFcGy2tTfnnMyfwxS7u6o+Cb786pZfnGzND7YX/mhiG7LbuKggWvxyRdl41gSXWMtA4Cioj9FtnQgCDsjHmsa3imOQPl9fCbFy2bEt6Lb0k6J6UgNk0dn5PQHrCDatlW9mWztw44g1em+bxTqJR/ZWdj8NzPSyNd6enmsDvBIqt/r3qqez4vPwFTFMNCtqwTdeRgNbBKVSsbInIumYX2qJS4mehbqAfybY8WEzQiDNSnZjbCpyg0mDTEluwBKH/tsgF4nbFeuTAKkVGFNhRr8Xkd6U3E0XURZgrwxAeB3NsPuqKjTzbYn9DL6YP9JI4kh7c2aheQDITzQ8HAwFbMriiXIdbxl7srmF5x9IZL4B7KhCRmOS/epDsaInEIqNqxZzUDAE8trcrWM1UTzxzgx0BGC3X+4u/qjU9GIpAMO8IFhgK1pnHqkcxbB2b/gMjRYFVV0JwUfjFnwQ8gr+TiIsxreAG0oMq/+PA9FtezHTuheDsuEf0/ERu6fnz2WlqEUz9ZolDiXgyxr8xmyzvRENjyybxzfVF1sUy9kfYhCpAyffdpfSrTCh6gu1el6IO0O+8Kk6ECbhabWxlmOVESe4KtEPInLNCjH++KlOGC6YDv4e0KapwbUEImZunNZzqAGqg1h13yCOjZjQCMN1R1/g/1mqJfQ
 UyWkEyKk
 HFLxblaUCc7scWetXNqjlBQ84hEfQ7tDEOewKWqTO4ta2R1Fj71uLhKV4JlVierinT6lP36D5pezUeYAM5rG4/5O2kzCWh0D6Jlbp+Go+3O8+lZjroeg6mny+sm6sTZyWUEPo5Qjm7oOslVHsUp8Amp4i9F77zcSevL92krJYaHXe6oIafu2sFuCewMxb1EE00lzpBIEUOzxXUlJHNmPIzKDT8iUCIYspMfyud2of7Ebip5X1Gwl7hkrQS7naKJ0qNBVR5nr3HSjVTD5d51OrYjyx7EwHTzrDDXdSJ2pCbAYc2Cgvy/rxJHFOB+8hIHE8JKvFI8sFsRs7an3/YnQU7wjITiLYrKjNFHwNhjc7p12t0wg/9f/7P3O7OL2oKGD80Y0M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 04:33:28PM +0000, Salvatore Dipietro wrote:
> I have submitted a v2 of the patch based on Ritesh's suggestion.
> https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u

... but without linking back to this thread, so nobody who was exposed
to that thread for the first time knows about this one.  That's poor form.

