Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E9E606A330
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ctOH3hn0
Received: by kanga.kvack.org (Postfix)
	id 4EFCB6B00EF; Tue, 10 Nov 2026 19:05:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0666B05B0; Tue, 10 Nov 2026 19:05:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8D86B05B1; Tue, 10 Nov 2026 19:05:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15C706B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:05:25 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08956401C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:05:24 +0000 (UTC)
X-FDA: 85420893768.26.F90146D
Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7C4AA1C000F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:05:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ctOH3hn0;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794355522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXPGOnD2xoKZFTFfUqDx4bSUVEQWrQ7xV1CJ8oeKg+8=;
	b=xXxL0y02RF9MmrSRsFf13LubKuTQZwLjwaIdK/A3SV05iPqOjibG2PFv9UDGoujgHGlu70
	0fcVZN2NbtpgMVrpH590whB22zXpJ8gyYF6OeIBiEqi2aqK0pKfTqPZZ6usOP1EtDRYJUj
	irYp05UNIg+RrNyHooeEvOA7huHs1Mg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794355522;
	b=0MJm6MBAkhZ1Lxo9dL8gPRZbVtFGtskLbNnt5Gmb6D4A3r9mWarTxA9QBEcHLVrnRQjTn5
	brcDI9lEjqwNTGLg6Gj1zV2mDvlKwL5mwV98evUMIYCu8NsgAx71VUZbUj5g/664NGpinJ
	AwlM6JFWQcvohMjoNyTkv6oJtv+4F4c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ctOH3hn0;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lxTQMWQoOBuUMzQsVGk0y2VzRKADUwBbP6Tg7Ined9Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794355518; v=1; x=1794960318;
 b=ctOH3hn0PUbQLLpTbGcEA4wf9tdSFP6RIfOn0jurA7nMbS+cK+K0q1rriYMpzp4JRkVNmbB4
 jtay3mH6UZPP1Rwd30+tN/SOVBzlvdlmFDVoiSFADLF/2swukYOleRAPemwaD/bysqvxpcj7xAJ
 Igi9SVRZA1aOHX/ta5Xur8x0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fcc7bf95561a02ce;
	Wed, 11 Nov 2026 00:05:16 +0000
X-Mizu-Trace-ID: fcc7bf95561a02ce
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 16:05:14 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Noah Feldt <noah@feldt.systems>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] mm/memcg: list_del corruption on memcg LRU on
 7.2.11 despite bf4ade7dbd76 (single NUMA node machines)
Message-ID: <avOxF0yKfZ0Wv1gb@linux.dev>
References: <20261110132853.71228-1-noah@feldt.systems>
 <avOsiy7kGWpehKJn@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avOsiy7kGWpehKJn@linux.dev>
X-Rspamd-Server: rspam06
X-Stat-Signature: biap8uk8euqfd5x6abwa58b93g98mf93
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7C4AA1C000F
X-Rspam-User: 
X-HE-Tag: 1794355519-319851
X-HE-Meta: U2FsdGVkX1+KHpY9NFbafTdIOcuHp62ZVkxmbMXL1qRmweMXeIXSxBNcrO/bsZKusxqARKMlpmYXyE2/T5pvG0Rf+QV5+RszJz6QYB8JWEq5JA4qpdfuizePaeQovETh8SyiXEEis4Dh3+Tf34xEMkg5jCzwu2kMi1vc0p7tv29X1ZJ5dfI18VtHn5BMzGCj2fvPQ58ur7CIUBfIF0B3IsieZKC/xKVEl1jIeGkJDvMpOeS6UKjfwueBzOujRJMgsWYNF6KMnINGJ+xqWj4s4qIc3smFZiiqwXxYceQBdWEMtPgIVnom8Qxsxb1KmW5TM9HsO8TIlynv345orGCmy9Lq3KSfE8V9Wy4ULdJi4ikmev0EwXAhdNPqt4D3aDXBjT9AfaV2EruQGgkUJjvUM7lW0hqAXj701DBxOEGNwR+Rr8PMOv5b6qrY2/UCuIqlAZ0NR9G/uOUGZijdGKAu48c8jerljJBysY/rY7sle7TpPPwZYNlh+6RKLxhLEFKgmiHFlPh9S6sACLjjOYATl9JTmrJxCjcamCCufE0dIKV2MZVimVo/B/LFQcJyGaX/2XQXyaQJH173ljVVrUfSlSl7ZDBoawu9+cM2Nljgeiz+NXnoXaAZslahyC5IMklMJ0Yhx0CTzPO4zRFii7Uln7ePX9myEkZHH6B0O2rc01LSEiUM2RikVj0i1hXhEY9bvJQobpdzAFmILrSbN5c9QtKG/S5zhiqaNDKZIk8pgydtz0acU0dqxh33onVNSieRCJPuYix1GMl1kDQban1TxxHcy6I5O4qALa1Lu1OWn+aFZXqI9f7ywxT5OshqG/DoXiWt3ISos2G8l71SYU6Hvzg7hKEUo+Gaob6INbT8rDDXMy0TnVp5FqhrDSjQTHKVKkuyhNQMC/bKdZRhpEeEbm1bHke9kMCj/gx9oq0XeOKyy2/3qd6Ut6Vphq5ntpcLt3ucrU6J5/u6rShE+uw
 Oa9qCx2/
 U9higLuL2jqOrwETtgA3QFF35sroOu8ImrJyTR9hwcraF1Llh4KpM5yipDI8SLl4mlp8bzhMPNze7xXtNlWmPaYUb4cfB6QOc56TIOQi/jdHM33H/Ur3YESo7rrkaWayJ2Gi0MOLN+o4V/1S8PX91O8yWUALV6kwjmjRsh1Abex3FHjQccdqZXjGRh3lbk+6XvqnAQmnFAfYMlLb3ruFZIy9e0rcvO4nBgo62Ffd0qwNetKl5A+NHTeazTPS/7h3nMTZQv4MN51RPlkdwyObfLlsh5PDGkOUEYS8yuDh6wOlFatk1fc4Ut6QU0wHlDdEQgpxN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 03:46:07PM -0800, Shakeel Butt wrote:
> Hi Noah, thanks for the report. Can you please first test without MGLRU and see
> if you are still seeing crashes?
> 

Never mind, I think I have a reproducer and the fix. I will post it soon.

