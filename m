Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE7CDCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324388E0012; Mon, 13 Oct 2025 04:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FBA38E0002; Mon, 13 Oct 2025 04:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239398E0013; Mon, 13 Oct 2025 04:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 160918E0012
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:01:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD088B7F98
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:01:08 +0000 (UTC)
X-FDA: 83992345416.09.9A63DE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E41CB40016
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:01:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pBDGm9z/";
	spf=pass (imf01.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342467; a=rsa-sha256;
	cv=none;
	b=w1z3xUE+3stmhBEx5araajcHZGwNasBTZFuQko6DfhOrV7z+B/V835X1zpzv5T5JjlGYdt
	XITgwBiW0Unv5rdgPjHvzLuEPZTIB9SHOkFO9PodIh0y3oLWvKqvH83DqfOWQOSieEQOBb
	4lerTqKAc+AAZ5c7Hn8k9VpOK/Xo/4Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pBDGm9z/";
	spf=pass (imf01.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYPIu0z382mARksqcX6oqCVuSxEra6cmqKYW6l9BkG0=;
	b=mh2h3wG/CaU9WUk0WbOfG+lc/VatksxdaL8QPsO2c2xQP4Y2q36z9qIPP6K+wRIYRmpuXP
	POqgmotcY9z1RHIbSMmiDJb9IH3UcEEz+Zy0DgP2BwhII6o+VH5xRp/RL9x/Co84NHPbWp
	Z6RmBuA7ieBsW44wkAUiwXebRLvNtk8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF549457EA;
	Mon, 13 Oct 2025 08:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFC6C4CEE7;
	Mon, 13 Oct 2025 08:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760342465;
	bh=noRWn+euEOloBgxNJ8dGn+WU7na1mnGeYcuQeFZBKcQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pBDGm9z/dvP+Dmxvki9hejV2S2ZVULKP9OcyfWsJmAwVMW/5h3Fo/Q0rTSY2/t8de
	 MsMyqaxTxNJRsYNM2uYjQmQXuKyYHnBeLQgVj7eqUqoeQ2BZvE2kLgY0ZF1TThX559
	 KjU63ZaEvxHmiAnfvVOHOLE1j1wh1PtMXDVNbJabzybEfpwQ84O3H3kktKYxV8w0E7
	 g0ps/rPrEpS18LVK9PIjswWPewYBEj3gP4I4k6qRxRNznVUTWmodK0qXJs9/TeW6GQ
	 g2yByYTih6aMzs+AniXcqoLXFAtm/8p1Hln96sK7ehRa5VP5QdfICnIaJb7vYUs1Yj
	 gvisoLlYoia+A==
Message-ID: <74593bac-929b-4496-80e0-43d0f54d6b4c@kernel.org>
Date: Mon, 13 Oct 2025 17:01:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_fdatawrite_kick_nr helper
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-7-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251013025808.4111128-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 3ggb14rp5rc877jwsauhbhisht98i14g
X-Rspamd-Queue-Id: E41CB40016
X-Rspamd-Server: rspam09
X-HE-Tag: 1760342466-355586
X-HE-Meta: U2FsdGVkX1/0zTBL2kUhSqiM9ysjJcIKpgMt5ZuQ3TarPM/PYIC3Y9DHgtwRABbSGHFAjgpzZMNaCg13N6Cwk2hbJBKsgcCdD1rmxPEOsG3MNxdZ68asa/ae1BzYluLHNJBa9D56gpy1n6DqBMRlzD7fES3KfQ+AZ9oqVP+r8caeaEHylK8UYY+uHcmlXBCsOVWx83nLkTwjeRyp0g+ReMka/TQ2BrF9NZ/toKKkbq1qcWbxrnPe5SD0bV1aEooJJjCONk8bDfvnMt3d8mzq2FJ/BWFWDi24Yh7ACc5sV6lcMq5egdmyAYNr4Jg12ATL/cgtuy9icgfCZlrH6o4rSTGxRTLhJGMPxXvpMo5g0V66WIjfBpd72qTrECHEROtM1WWsLsew+BWJXomMeTc91LjRZRJwXY7ULO8LQ41CRck8SlazwjezWUy2iTfbkhPcRSK2Wsztlm6Qfg2ZjZpcl33ZPMBxBGKEm8rRKHE3FvCzRMeoGegl6RVLyF3z2Vld2bJ5Vwgblb76NLBrfY1S82o2Jv6WwdzI99z6yYhyzsob3jUhKCtmgMobJZkOiXK4MZvGPZChte2oUA+o70aoiDSdyIEG8LP43MH2PdV3tn0EaCx72+h2LcJBus2JUbhux3tnEp8Qaws10abrE1PSjJerij36hEXRq/0/hMvqozl4oU//YRdhJXTb8p4tMcFg5sRS8jUvO8PbZRvSvJRrcme9VYA+QI0g3awgLhxt4B0wX2GaArzLRzeseaxSoEBl0GrqJPixutaFkfzT57lUDns/0TTUqTT9lMoFMDAkGZELs0kiPTYCTOm29Iqg6GlsKgVkJOwimWBb5GEvH1frNHKU9f2ox5vKDghAxVLj0HHvMWcuyxvpZA5Ho8CBw2zPigO526FNOLTn1QqPilJU8GH/n/gdZ/scKoKyx0F26Sl+e/kzRwQyXJyhAXuhunu2/byXCPWU5A2dwjpwubd
 C2Gu//eS
 BM4ddMmrxCSMv6WYSej28cUDcUnL4vKDw0DYzbjrrHwB6lLNthAJsJTzez3NaTpoDTTTcBQpWnjpLrugLtghYbgx9DefZOfKzpivEsCUUrPJZlO2OApp7s2dkAEq08fUO17xMxLzNBZ85zBkgj1sqLjxRWv/aUtuNJbmjbEyHVmXVRD+Agx94Vin+iqlhnDYxafXEjGJgWsJdbPsBoj0LtMI9Wsnh7UlA91w+KsNGPIycqiJoCae3KVMvzMKMm+ZmirW9tzFT8abRhClEua655fk1wFKDU1Q+dTB7m7WzjSMP0yf/lOpIlPNjIgt2t9r8DQfIN335uqRXWUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/13 11:58, Christoph Hellwig wrote:
> Abstract out the btrfs-specific behavior of kicking off I/O on a number
> of pages on an address_space into a well-defined helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

One nit below.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


> +/*
> + * Start writeback on @nr_to_write pages from @mapping.  No one but the existing
> + * btrfs caller should be using this.  Talk to linux-mm if you think adding a
> + * new caller is a good idea.
> + */
> +int filemap_fdatawrite_kick_nr(struct address_space *mapping, long *nr_to_write)

Not a huge fan of this name. Maybe filemap_fdatawrite_nrpages() ?


-- 
Damien Le Moal
Western Digital Research

