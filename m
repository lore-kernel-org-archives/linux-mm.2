Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7781BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719E46B0093; Tue,  8 Sep 2026 11:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0AB6B0096; Tue,  8 Sep 2026 11:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609746B0098; Tue,  8 Sep 2026 11:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB006B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:09:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D28021606C5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:09:48 +0000 (UTC)
X-FDA: 85190929656.13.AB06219
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1E701140008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:09:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880187;
	b=PPkwSOdJ2isrEc9Vkl0wZtQqQ+ifjHdOc92MTpARPXgZugHEeCuojchXCOTt0LUBqrA8Gq
	gx8crvEtFNhNtDyxoKlJPecN6CMf1dtXZcFatN7ZJRZFFK+iKtBzBHiJH8c21VUB35vSuC
	YYy/wyJ3Ph6azR2uNvPzOdFme6NFNzA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L+oL//l4ZzKK5zQ6gZn1SMHKlUsh5HmKVk5qloQ+E2A=;
	b=WC4LpnSssR1YB/0xKCcM6pNubHqKN+RDDt4n3gIUnbI5AmI4pnjjyBqLiP/CYRki0gzNyv
	JoJ59AOb5R6TIt4h4fEgdWxxQXjRXBTiOYH/1DTMqh6MyEsGKpf1Vl5cEsYAS3T5OSvN9p
	mn021IFsoTUS76r0ddWXvq/Sg/ta4mU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 856B8601FD;
	Tue,  8 Sep 2026 15:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4878E1F00A3E;
	Tue,  8 Sep 2026 15:09:34 +0000 (UTC)
Message-ID: <d3955215-120b-4acd-a27f-825aed0e3bb1@kernel.org>
Date: Tue, 8 Sep 2026 17:09:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/14] perf/ring_buffer: stop using PG_private as AUX
 page high-order marker
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-2-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-2-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E701140008
X-Stat-Signature: 93tpgm3n553gys4b8e4yt5sqcsb7on53
X-Rspamd-Server: rspam01
X-HE-Tag: 1788880186-951188
X-HE-Meta: U2FsdGVkX18+6+aNErV+kjweOunoWo2gIHjiUEz7fKytPf+WmYVW7kE84cG56GeMvtoZ9blx9rSvr/ehwUSyaEmgy2ER9LDCAJ3uGrJL2HQxDiMgkEjmkoqcwpEo6ITNJzBpY2YNsLz9AW9bBbnXmhGe9l+axunikGcmAF/IiuHW07LLQ/JQvcufGv4EsofFd6KwW5LLDAFPf62j1wS5LXNaZdUPUVxv7Do2af4nvshW9MFE3cKxxi+w/VDV4nQaGCNUOs81kGOERnGGhgEr2E+Ix9NNLjjDk+LgmF4+42A2yBRLw5NCK9hvPO+6UkUpea4Dcua/4aQUiNYqxdOb+9mBb6Ksbr4Pb1MVb4/xMR9PDwb9sxfqxeVELeKqJqOjPD0wV0vjsDD56QDKnElWocuU+MWIG7BeyzuuZ3FX4PTDLOOOpZvApLN9H7XinOo6P6Et5z+TtHutj6inewFZR3bP+1Ma/RV+g2sp03WW+ZC8Bo67DmxYmB2Yjxw6XSHOsimk7DCpZcg4DKOy1jHAxbidzrxk89NgVZO3AttWeWat69/x+kZoeW/vQrpCknp4ExsoiM9YGgV3HPStfgebt2UjmvOyCn27sB7m7+/CFg+dqTSKYHYvl2YErLCu+vQyOKADDJxFQ4cR4J4DbnoKanWp/MbcnsPdPttA6HhFyzW3s/SxUN7efIjTxAc03Q2kYORhU0ZdsD7wr4L0hScQlg8NezHo+LrSt1EeVxb4jl3SY+zKAPSSf/s7dqBzxPDwzZJMuowZCMvpQQ5LjL0ntXOJ98xdO8EjdGrBs6ab9D1Qp5MkMA5XKTyXxaqD5+l6rF+5iVpi83jBIKg4E9N7xtFTLSmkG2rpYeKfSs47eHrUsJzNflvK98ZULFFVOZHTeam+thSE3YI8o12W4bPSBL04P4DgKVpAkmAlj4JsyCojNSKzL5p6pOb5QqCll0uYidjxUeVZOFc5wAUeCGW
 weFe27I0
 1nPPaTscpkjy8Z7NK6wYToPCPuHaoKdki9zMVnKMEbC+rBggj1tYddldNMC3yW17MP0KN6faz7x1mSFY/LUmCf9z4/3WUW1ptcJpD2iwCEkDkiKWZ1poR7NilCA6PoMREfAuuz+9LyACtb+OolkrMQvyYuGGEB6q/UU3muu52uZRd0xiVbJZly4EnAHqozmsvkPPtK1MyJeWPY80v9VfTR+aiMnxo3fjY4LaUEXx9rYMhH7qNBcEAsRTaOD4sVCRCcG9BYb0buLnBlSmlzgBlW0tiqQY7xLKUv3nkvrzHPopiJoToSwiZGwyWenO4CPgkTJzQ4frYPTVe50K36DepKbpyzlDHNjxPPVZm9xQ/LIeX7dGgEqPY6aKhbzdJjESGKVo/oa5JTN4V1Sh1EtgC4BODZp88xVQVHoWa5dMefHO1iyM2Rxd81SDDyObRxSi1O4a4WQBVLnnK0Yc7aDemohqh5bq3O//RcCzcH8TNAAES6y1Txt0M7iQvSfpYMWtUr3TOxVShSOsavpCi7plyAMSjakLu++kujjlhYGAKWinpxVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> A high-order AUX page sets PG_private on its first page and stores the
> order in first_page->private. Stop using PG_private and check
> first_page->private for AUX page order only in the ring buffer and its
> users. This is fine because page->private is 0 for order-0 AUX pages,
> matching the page order.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> To: Peter Zijlstra <peterz@infradead.org>
> To: Ingo Molnar <mingo@redhat.com>
> To: Arnaldo Carvalho de Melo <acme@kernel.org>
> To: Namhyung Kim <namhyung@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> To: Borislav Petkov <bp@alien8.de>
> To: Dave Hansen <dave.hansen@linux.intel.com>
> To: x86@kernel.org
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Ian Rogers <irogers@google.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: James Clark <james.clark@linaro.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

I recall having almost the exact same patch lying around at some point, so LGTM :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

