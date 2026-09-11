Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E428FC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1C2B6B008A; Fri, 11 Sep 2026 12:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECBB26B008C; Fri, 11 Sep 2026 12:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2F96B0092; Fri, 11 Sep 2026 12:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB6A46B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:14:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 552931C08A4
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:14:32 +0000 (UTC)
X-FDA: 85201979184.02.2696955
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id BB6C91C0008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:14:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EU2O9FOA;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789143270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vo2Rt84flTHlrR53SeRzoexTdDxvQ6xCAHE0Squalo8=;
	b=sDw/NCTwDkI+Gt/AknTobGmOglmiLUkKGAWfwdCTdf/h2lbwKNsHQKjG5hv3Tb43rU3myW
	55OUlUkDCIcft+8SoLx2doM+nMELVUNbuqphRzGL6RPrCKNi/H/HXN8Fn258cz2J+e9V/H
	1ZpDUn5YF7yi3h8vbINMlwvRgYy/Rhw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EU2O9FOA;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789143270;
	b=eyQ9JrsJLRx1bYjgIXZZhgz7J630yZl/427aqWJXnabbjJhRIDv0OMhYs4xfXu9gUFAv7T
	b7C8YOMYiN2hDISLuoHiJcoqIpzy0xWPUJBF/SA3ZMnzMRtTx1N6c9489k+ObqZecrdgil
	hY8Y90+15/8iNr+8yv1CLgtX6/2NY4Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A063243C6E;
	Fri, 11 Sep 2026 16:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C99C1F000FF;
	Fri, 11 Sep 2026 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789143269;
	bh=Vo2Rt84flTHlrR53SeRzoexTdDxvQ6xCAHE0Squalo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EU2O9FOAB0RXReo+iSvWswTGe1awdFIAnYGnrXnGYnVSP2HyZEg4Z7HQCYGkECsik
	 AS0iKBwdmRG9VPYKOCMv29gdni4e3xzrC1bQnplAVcyt/C0C7L4+sjQYhD6RERV7SM
	 d0zByqGON1lPzs33WE6quZxD3QHwahYW5VDulos1TKKYOf/g7u2VLgM5JhyYUMaCTm
	 DGtvYjQUO+E8h1l7Mb5ZZdJSKoFHxQd8VMVh+p23fYYE+09w+l0tpWvFb9W9xeVX9D
	 ep14jnMRUI8QQoptrvLF+eQQ40O7nhzZIqddhcwpqTBPKTkF7Tnzx0pPITV0y2HOX/
	 VXNumPXB4syEg==
Date: Fri, 11 Sep 2026 17:14:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Tejun Heo <tj@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Dennis Zhou <dennis@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb
 drain pass
Message-ID: <aqQorKUtZgMGFHxa@gremlin>
References: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
 <aqQb_Jzl--8So9p_@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQb_Jzl--8So9p_@gremlin>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB6C91C0008
X-Stat-Signature: 7r9qyywonhxgxsiedsb5oj318yrjenkk
X-Rspam-User: 
X-HE-Tag: 1789143270-396027
X-HE-Meta: U2FsdGVkX1/boRGS24Hjq/4jVZ8mnylPwn8NlHgO1vX/GrcuHniUh6s5dssI4KPOi0C4h7vLE5xwO2GJ+k6n/l6zr+PJMzadxcojJTHMZad8AdR2taiOdbZqtXYafOmVpSauD6YyC/g3vOCTn8NHwCH2Pqg1yY3MkCqeJS8I63kj0T40E1CRi6+7Zh27tXKBS53+5Uh9jDCB2zNvutoxZcy/aCKprLm43Xg74iXEJYfZY+tOI8G+n8TXsjw7NYYK6MC3+sLrKqkg+oTg32T9oFhup8GBUu4cMPDrlfGR16uBsZBPSS26q9ja+IkuGwUF8MzeElw0bV5B1RxD1kUyR0d+K+2Jhr7nNqAx2L94X0SR4tzpzdmWo69gbiIVf+vh+HE+ouRwMAvgaEKkTIYspnjh0j1T26LiauTdLJmPrO389Ob6hoye9qdKcTYRmD+CG1/kbgywbZKolMVusLuSVgwgKBciHii1t8ucp64tKha8nsEEpiCG5TJyGhqjaG7KKGLcXLSGcOldSfwuQfTo1/IiivWmBk96UUwDWvH+UN/ZDVJydCBy0h9+rpJCPkKTiiBr4JQyiMPhs1ZizcCar0YTIT04mCNcXmnwzvSMc/E2p86WKZcwMdH+a1F4sGz59gzJJribeyVmUqOLnVj1x8j9eRZgBa63jjkzZsCDWmsD9mhw/ulzbY8aP/FWkt1L2f8WJjg9+CTLWeJBij5SBUzQ8b73/B3R2rxJYV9bAXRpc2S5j8utJRg5nHUywaK+VUxMjG4Sf4vbkQKjuVfU0JBKR5z7D1fChlSGwDVLWw/OOokvs6IOenTXrr/piwP1AWq6SCZVs+2yD1OtFz6accNY7pyrPIeVlH7IUk09Kw95/HmYvNRnlEomw8B1g0q/V3VvOoJP/FR/bitxgpsIFKRBVaT8U5WoN/dSCvGhmZlrjG6Ak2zwPDwPXJZlLByBvUf0eITkAJ/O9WmY/SO
 D3oSRMOp
 uzyJOUwv/FxyJ6qnkPfjPh6G/ACI2IMH120cjI4DTeFB8dJk45UcKeW85TWN22ZV7vkOQwAxxzryzcn25cKd0twAfXOkpHTjkCeygYfSZ/TOWXQe0PqQC8HxBtB2VYYu53ICHsmOhLqbrookoHVRn7D2ttzdifKXIfXBLwK+PByoqCGrEdky2vj0x8DxB7YNIvlXA5UCJybZms9ZOd5f4Mjg2za9P0uxn4KlINRyyjF4f9rqTr9QCHvqkQFIOmcUNsd5J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And of course neomutt managed to hide all the replies from me so I hadn't
realised it had been replied to :)

Anyway hopefully relatively in line with the assessment of others on the
thread...

--
Cheers, Lorenzo

