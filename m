Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCA2606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QdmHtrDo
Received: by kanga.kvack.org (Postfix)
	id 7178F6B05BC; Wed, 18 Nov 2026 16:29:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8546B05E8; Wed, 18 Nov 2026 16:29:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9FA6B05E9; Wed, 18 Nov 2026 16:29:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5696B05BC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:29:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFB5D1403F4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:29:32 +0000 (UTC)
X-FDA: 85449531384.17.D328FCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1C95740003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:29:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QdmHtrDo;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795037371;
	b=5mGbtn1DvvRYTQudAQBvM+ONwSE0gM3NbueVSk1orTU2nJcbngUEHBwma5yNIGiBz5QCb4
	FkLzmIz4uNn5NtM7+6Uj5zvrUL8JLpTShBdn5MURs/xGoBfCuNEL8f0vtsIwFmGq+5Tzk/
	+fmMddef4VfUloxz7vfXcFCYU1dTilI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795037371;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDd6kQMiQ/fbUgeU7+jjKuq8JRpf7TlSBpFKWDVXLzs=;
	b=ZOeOQt38mwfYInj99OHu3g+0TS6Wfl5gGkpIebRM+qxX60BBvfmqbXzUJ10ZgbJRrHV+Ol
	Gx7yxM/EzQz3YR02M3D9t02yFmcdoEt1j+g38iHNTcWENJ5MIZL+k38Sxx9/3dfxwJsQOi
	7J9pWZM//zybGJkv68iolp41ig/4/HU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QdmHtrDo;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E643471DC;
	Wed, 18 Nov 2026 21:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E3A1F000C4;
	Wed, 18 Nov 2026 21:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795037370;
	bh=pDd6kQMiQ/fbUgeU7+jjKuq8JRpf7TlSBpFKWDVXLzs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QdmHtrDoX2PP3leUa2Bp/73mnyQb9l/q102FSOYmDz728P0nVzXV/ACL5vUHezaLD
	 Sx7/DURzJ0iHZ9Hn0xciVNDPhGkcVZCLEiUSWFlQCEwkC7ctLiAZnczdAlcYKlMFF4
	 RGXrn64Iub3NIBhMjDzbIjV7WXr0lK8uS29gc/Iadp8TFBayBAzCj+CiO5yyO8Z8YN
	 bZZ/161INj3g5CB4E7vi/AqtLTVCDAv4uSOsFgpi9Vf4JV4hLQTSAuKanoVKppFSxf
	 pAwIU7cwGdq07bh+EvItjIEQdbloAVvu4q+meRXCXxTr58JnKRMNsgwE2bMLCltPcm
	 3RwnCOd04XF6g==
Message-ID: <sashiko-outbox-221996@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 15/17] mm/mglru: folio LRU refs based active/inactive
 number accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kairui Song" <kasong@tencent.com>, linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Qi Zheng" <qi.zheng@linux.dev>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Chris
 Li" <chrisl@kernel.org>, "Baoquan He" <baoquan.he@linux.dev>, "Nico Pache" <nico.pache@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Barry Song" <baohua@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Nhat Pham" <nphamcs@gmail.com>, "Youngjun
 Park" <youngjun.park@lge.com>, "Zi Yan" <ziy@nvidia.com>, "Gregory Price" <gourry@gourry.net>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Hugh
 Dickins" <hughd@google.com>, "SJ Park" <sj@kernel.org>, "David Rientjes" <rientjes@google.com>, "Yu
 Zhao" <yuzhao@google.com>, "Vernon Yang" <vernon2gm@gmail.com>, "Zicheng
 Wang" <wangzicheng@honor.com>, "Chen Ridong" <chenridong@xiaomi.com>, "Tal
 Zussman" <tz2294@columbia.edu>, "Kairui Song" <ryncsn@gmail.com>, "Xiang
 Liu" <liuxiang.277@bytedance.com>, "Ehab Ababneh" <ehab.ababneh@intel.com>, "Zhao
 Zhenzhuo" <zhaozhengzhuo@uniontech.com>, "Lian Wang" <lianux.mm@gmail.com>, "Joanne
 Koong" <joannelkoong@gmail.com>, "Kunwu Chan" <kunwu.chan@gmail.com>, "Hui
 Zhu" <hui.zhu@linux.dev>, damon@lists.linux.dev, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <20261119-mglru-fg-v5-15-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-15-9eee2fe97a2d@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 21:29:27 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C95740003
X-Rspam-User:
X-Stat-Signature: wipwq7uuon1tu6c7hkh68uo8xcrrtrrd
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795037370-13051
X-HE-Meta: U2FsdGVkX187SO5H7d+864yMyGzscY1GUGqOwVSPFzYDHenw9vrGwtUGDu17KP1s3A4hIvAKrtS/8VB5G9PfMs6vYcggPIAv/5W+8Qw8QwgtmV3DVK7VGr531GEENtgMm+VFn9YrEzCte8PQd5E6M7JZ7RoQCD677QhQAp0Md4nwSbyOHyf9i3WCyAxYFBUIDjh4ijlwg+2UKXMYau7EJnJrZL4ZXI4hZwMwtYbQ+KaD/b7RVkkR74mzuKv2Erp+GFs9y6rzBcAri1ZEypFuY4WfqVv8QNYFZ0OarH8fnLG2nz7V/qYFQHpmHDY4/pfZuCRYud4861w7enTuquqsHCRtx0lK/0NxoH8j0i6tUBqBdpkwfuGnAo3R917dS78YUnpB+AUKqS8+ZVrVLPyU1kbrnfBEsZEgODOkcwoC9UqA2y13GTsIR3MN5NCT1PHWCcV8d+Jk50TXur6m97mj2YTbO5xBFB5dVoHe8N/WdBvCiNTRao8NQdXSv72z5kJL5qoFaaw+kKtG35m9Of4tjHUsf0iABqFyYn9HXvobOx/ckve3YD5GjtoJV6vAYI9XGtDiamDENUnny7ubvyiwI4l6LlOYeEe7VcQ/rlphz/WO88PkLNk6KehbrOMVrMDYA/kwiiAYqtsNyxoedk12ppxKIumceK5eDxdrQt+jSaAdDDKjwv2J6rI1UKuT3V9x8NP9sZXpu28RfDsnwUYmKqKKbmp4TM/GkPeH+IQwE8iAjOYlC2Z4es7EglVudP10XXiWHm9ickdwXBuGEv/z32vf2lLMpI8Yve1q2gxl2KhCOWONHsDB4FW//bjWgqs1TYtmbhpkt449Xj2BP15egDiIA4BR2NBUqrtCv8VLrEoGcjUI6Mui3K7o8g+sp3EmHCAcy/a9ax5Nv8fvoZX9QsCf8aH0+iYATM0aaagJa362gRVSmNzAnXm85cASR2y8on9RORzzilTf8cknc5b
 uooI6qSz
 WsidyDa9F20NakeDNcJPjiUKeF8PUZ9rCRR3DtrC8h8L3NMJFRKi/Qu51NUnlm9WoYqoRPNy0v8Rl8dy/62bCHvals6KI4LZ+aM4eypbeX/TxD9DbAEMyHj/hNBmCrqHcWq3bowz13KrgerVJLq2jUrPFeD3aXXmFzJGzSoRSJ2crHT3uLcIbmMQuf2IX4rcY1YPK2t32KyQGa2zbDFFA90z/M5AyeROObWztoW/6nFttP+Wm2hiHmntRueuEXRHWgiule/Jq6kAmJ71zKDKh0e/Jfv8rYeoOFK4KM6S3Uq8ZWjJOCBZy7CK5V0uWWkfF07DdYrZ8UTi5e8pw0jk/Eu/hIKDfINqza6QCzKCRmnNM0kM3CSPJ3QiyE7Gnq0tfnbuGf+hQaPSUJITqiNkT6BeS5b9XPvlSXcOzmhlYefETd35wVgbkd7rymAGO282kTr3eAYisjNDSAT23SYdtiBUQtOunXSXUu6YZ3f3TDYW32d0Gcf80u7a3BVZlVbjgalFpfTrbw1ObkPNcUdCy16ghaap0VctcU1U48aKT2sVq555Wp4ljAZWIL3xXBV0/mjuBEDHfOBN2BMZ3CNpKHQPiQmVkRq/Hu9mfWTTAvhU2BAjAauNyafqR6+PcOMAHX7xegjUCohDCKumpnYNZSXjUzzizmpGaEaLGLEfcXPrXSXyJtquwtwJwIHlgAHSmJOFmxSuyODpf/eSOZl7P3vy0nRZ7bXAMWgpyX2iB1rXXtqZEMRUtJRZzE8E5Zv9e0lTd5cK5T6yfY6VW108aYSjkF/45rS8gARquaS8bjpYZt+bs0isVlmCb3rnTU/2K/a1saLSfgDb03ZuSrMNvvdJErlzviGs0brjr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/mglru: raw folio_clear_referenced() in lru_deactivate()
  paths
--

commit b8ed2e873fb1f3b844c7ba1fec4ae00c0c04fb88
Author: Kairui Song <kasong@tencent.com>

mm/mglru: folio LRU refs based active/inactive number accounting

This commit switches MGLRU active/inactive LRU size accounting from
generation-window tracking to per-folio reference count thresholds
(LRU_REFS_ACTIVATED).

> diff --git a/mm/folio.c b/mm/folio.c
> index 06c9cde834f76..3b5ae5b516504 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c

[ ... ]

> @@ -552,10 +523,12 @@ static void lru_lazyfree(struct lruvec *lruvec, str=
uct folio *folio)
>  	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
>  		return;
> =20
> -	lru_gen_clear_refs(folio);
>  	lruvec_del_folio(lruvec, folio);
>  	folio_clear_active(folio);
> -	folio_clear_referenced(folio);
> +	if (lru_gen_enabled())
> +		__folio_set_lru_refs(folio, 0);
> +	else
> +		folio_clear_referenced(folio);

[Severity: Medium]
Should lru_deactivate_file() and lru_deactivate() also call
__folio_set_lru_refs(folio, 0) when lru_gen_enabled() is true, like
lru_lazyfree() does here?

Although deactivate_file_folio() and folio_deactivate() call
folio_reset_lru_refs(folio) before queuing the folio into the per-CPU
batch, the folio stays on the LRU list until the batch drains, so
concurrent accesses can increment its refs count in the meantime.  When
the batch drains, lru_deactivate_file() and lru_deactivate() still call
raw folio_clear_referenced(folio):

mm/folio.c:lru_deactivate() {
	...
	lruvec_del_folio(lruvec, folio);
	folio_clear_active(folio);
	folio_clear_referenced(folio);
	lruvec_add_folio(lruvec, folio);
	...
}

Under MGLRU, folio_clear_referenced() clears only bit 0 (PG_referenced) of
the multi-bit refs counter, leaving PG_workingset and LRU_REFS_MASK set.
If the folio was accessed at least twice while queued in the batch,
lruvec_add_folio() sees the surviving upper refs bits and fails to place
the folio in the oldest generation (or re-adds it as active if refs
reached >=3D 4).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-mglru-fg-v=
5-0-9eee2fe97a2d@tencent.com?part=3D15

