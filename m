Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14369C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E637E6B008A; Thu, 27 Aug 2026 07:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14496B008C; Thu, 27 Aug 2026 07:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D065E6B0092; Thu, 27 Aug 2026 07:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A90846B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:46:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB7C3A3444
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:46:23 +0000 (UTC)
X-FDA: 85146871446.23.871898E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE65018000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:46:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JZ66o5yM;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787831181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/7HEinzHyrUIuuAvpR8eRudqoAYvO5vyA5jKxjS7tE=;
	b=yYbNdwwigVpLzjo1xokfsgg9bLJJwnLI39oy5ggwQqCh7CGti3vPIlWOa6waScC6OWLXra
	bxkb/BuTZwaENwigWEoDcDaMm7AuJM5xl1r/2BXrwk/Fnh3knjlATEa8Bxc70gdrZ14+JH
	t6stmgRk4ZSZu1v1w2Z7e95eaAheL9Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787831181;
	b=8DqWblqmLTrED2Qvde+qLQdigYwqsvz9mgaWHJukdvGbYzYRev5DnjSjhXsAjWAka+07lB
	08HpNHVKKlWvAss3bTdabbJ8ZbVnWoriCR8h/9X1FrzOcPpUQNolx4g6tPlbTZYNOrTdgK
	o6uY3FJsh7zh5oBmJWZdP/VxbifqXtE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JZ66o5yM;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E694600D2;
	Thu, 27 Aug 2026 11:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358AD1F00A3A;
	Thu, 27 Aug 2026 11:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787831181;
	bh=1/7HEinzHyrUIuuAvpR8eRudqoAYvO5vyA5jKxjS7tE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JZ66o5yME1fjHkUhC8qyz3sJULn9QQmg4RUyDcyFvh5pQRmok0C1YQ2TuafZPYPQb
	 JWtbSwj4EQcV51NBvZRQW4UaZNiXn9lWpvDHZLjKh7T2xZPXofeQXoFchR0+5HQR59
	 lODhga6ZhTFbhqSME9fa5hrdNVNodGgcgZRD9KaoCFaelL6Ygd5zyV/7W/kQjmV9a4
	 6IuLKGLuL+PKL/Xl4IW5Mlvok9cFkeuNgO9Wplhk9UpCuL4ltOzSP1UW9U1ScH2SVd
	 A8RE70x7XNEVhOIIhajJxdCFAiFO6dQpzNtZvyPDUtSxXTN0xzKMp8lmAxM+UP93w7
	 dGNnUznYtORaw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0D84C1980047;
	Thu, 27 Aug 2026 07:46:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 27 Aug 2026 07:46:17 -0400
X-ME-Sender: <xms:giOQajxrB74n8M4jds9AgIgRcXpZU72wEnOkHc67ccNPTLLr8QeOrQ>
    <xme:giOQavD3npuGe4nFyz4WZJ-qUfIAY-EgCq22IPkgUII8ZyzGBtOwUV9G0iQGDgzOG
    RehAd8N5LIKhvMjiVwxkNL-m2X-UTvHQKMnBSxB4NzfddAx7cqQmY0K>
X-ME-Received: <xmr:giOQatEdIKGZu4wUeRJvPxwf9xdQrGV7tpsNpfxfdTl_3NKnq4cP7GW7iEs>
X-ME-Proxy-Cause: dmFkZTFEkFs1SlQDQdGfvtSAc9WTtr25v16L9+AoTBfiYB5jwPukem/FqOc9aBgzJGVE8s
    XWYu6XtTF1TiqpkLYgBAEZedvE5yRMka2V0KyqpQK759rDery0ZQGWPcpvUce4YOjJdxaU
    mkTf/h8DzsCePJPfrcIYp7xj1rVZw3sfyseBqC2/BQ8R8iSKLxuJs+tBOg/r6anSmnpAGj
    suewUpL2Xs5LkLCTflIiNIekfKUet6doHLg1kVgwEnuEEpGtXoDy4Uu5Xw+aUuWpdhdYH1
    6O/Lvfm5/orsfos/smODRowOFflASWqZjIPkmpZbyHf+P2lnRwkJw4sifLopkuetjJjFkr
    X2dMrF2eJyqCwxQIzQ5IGiUwcFQge78u2cyfBqZkCWT5CcNVB2b34WWwQ0URExW4hkV1aQ
    VMa18lLChoRZqk8ZtIAQiEsxhoTbabQnXk5nEsISNP8YF0fHGnI+tuvYx2zGzPDTq2YWfF
    QBTdbxsbws8PYjblh48P7bR4oI+zvDgBhC8d6yjVSSg3TjuYD8biX1DTIPSj2w6fItuZ4/
    iyaktA3Yvce6MXL9T9alUvd3Vj+A5RoIHjbfYs/vMt1U0WVNM6EK1igwNxqOvJ1t2DoL3n
    87zY9T+sIyKV1SZpj/n2fUbPx49BE0ULFZXet8EkBdfquu52KsyYYAZPxiXA
X-ME-Proxy: <xmx:giOQas2OLdJ4vCHLOR8jMhfVr2tyw-CQpxDt2Q7fGMGmRKCgA0zTYA>
    <xmx:giOQasabqX5COZwurOKIaF9PlBhW-FRP14X3Lw1NmJ_AQ9xRNM6qew>
    <xmx:giOQakxILQStI4fYkHh5khjicZk8rS5SP1n_fgq3iqBHDEhyTFtZJg>
    <xmx:giOQal1cjolE8KhzFiTwWpP7I85s2j-ZZ-zVksXlMlSqFxI_yZZhKg>
    <xmx:giOQav3y6duKlH4MJy6mMMXvnUw52ihIcPMaYjTGDnlxNYNKGufQVsIk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 07:46:09 -0400 (EDT)
Date: Thu, 27 Aug 2026 12:46:08 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 	Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, 	Binbin Wu <binbin.wu@linux.intel.com>,
 Christian Brauner <brauner@kernel.org>, 	Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>,
 	Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@kernel.org>, 	JP Kobryn <jp.kobryn@linux.dev>,
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 	Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>,
 	Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 	Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 	Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>,
 	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
 Minchan Kim <minchan@kernel.org>, 	Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 	Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 	Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
 Zach O'Keefe <zokeefe@google.com>, 	Zi Yan <ziy@nvidia.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/25] mm/fbatch: lru bit set, no extra ref, while folio
 on per-cpu fbatch
Message-ID: <apAaWsWPV9QEeVwn@thinkstation>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <e0887417-85a7-453e-e733-561dc11db08f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0887417-85a7-453e-e733-561dc11db08f@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE65018000C
X-Stat-Signature: r3hdoufc5wcr47w3mt6nm1sedcqzptbo
X-HE-Tag: 1787831181-61049
X-HE-Meta: U2FsdGVkX19Aqsljfs8uJngrfjwkgEqQqEWrmrZxngXxv1ixHVhrUmEC/hj4Lul20Tlaw864X1cvkv36ibnjyT2ox2zJ/KO5opbJLnLdAm+SQGJrUEPuKrcbVHTXQzgVQKaWpO2Q7TTPwaeUOREy+zzN9oOYhdls3vbf3hBbvSZXCbRWtBGTQRfuiyzSRx1hMj74P76inePwazW5JVwZNmrBXz5pdJcY35Zxbw+hBIo0JAfoAxL7Z7LmsEFlre7Xb4m4llw+KxyVDBSefC71eW8iW0E3k+XVQHpuYSJOfVhAPsat5pKn16qc3CGNCOLLAVXwofXHjqE6Zmx7tOg2/js2wsy9jO8TjmZBgk8FUEH6f+kHI4fqTn8I+xgGKvSlf2SSQy4soEfy4egt4R2RfMwMrMOxVr874uIHTDxcbSMJYQ6lJEYuQDlHfvGVVmBYBDVzBqrt29ER8+sabUX23bKASfsuPUngYca+9uUDaVQvAvr4e/n7PHAym3STBrJc6r7N38BOjMB6cqVDHTESVgy9R5jcSvZFBinoBNbqWCZ+hJka2iwvq9WBxYcTg4oCvrI/97ccjb+XG19E0CEUzjF13h+J9V6tKJfL6e3JtwDgK9XeA2bN7jABbP9rxivokzHac1WXa/42tcBJXj3cIw9e6rNExA1XwuIQd40nZqJ1n6u+rplI9EnUZyQVSMzy+cUqYbqXk5r8yfaOk/s0MiZ7xWeodfamHDJ6FFYcqvRKoNKswImUm8ipUL0F5200+M/dkuualehITB2tGsvv6ZQFoMvZotsnKVugelWkYIg+PkQhdH2dyWcWXlK9/DdgEV4xIcrm0Erh3TLWESQT1KvounE2nMBcfI+ctFVaN28JysV33D19+p3OHk+MZnl55R0uA19qc6u5uRdcPA9Bqx7lqK+rnsmRnXfdfpnglulh2ReEVbAwVUyobIiGdvr+n1bf0BdFvYcRFVJgswu
 4Dk8l5nS
 s1AWiYFl68BIg8hPgawya1yz4Lo5zuBSEvJYGDl0+m2fSzZjfclGVmLX/Yvu7KC0DS+ajuup0IIlR5sSp1huxOwO+6pV1ICKGvne3Visr//tHgYSLnk0Yu4Y5B7vRJSepWEIrgG2l06d6fimoCBGnUWPBSumPlYolIraMHzxIw1i19p1miXITrrpDgkMnMEq+TunKcRSuISsSK72AOWvipzfbmGd73fn+/rEkEtgXY00qLJCJ2o+DG35P29gDbakJR4KC/ANAg/TtRjB3w6HH8d/bQakxlBY82L/7mPWHdb/x1PawzDC9kOlwJsZiaoPW62xJZ1uDmwBt66T/is1Sj8IbxHkkNAmPwEPk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 07:01:20AM -0700, Hugh Dickins wrote:
> Treat folios on a per-cpu fbatch as if they were already on the lruvec:
> with PG_lru set, without holding an extra reference. This will enable
> the removal of most lru_add_drain() and lru_add_drain_all() calls soon.
> 
> Recognize such a folio by 0x02 set in the folio->lru.next pointer by
> folio_add_lru().

Hm. pfmemalloc (__GFP_MEMALLOC) thingy already claims the bit. Is it
safe because such memory is never on LRU?

Are pfmemalloc and PG_lru mutually exclusive?

Do we want to be explicit about this? Like, folio/page_is_pfmemalloc()
shouldn't return true for PG_lru folios/pages or something.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

