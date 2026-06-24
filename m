Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9448CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A066B008A; Wed, 24 Jun 2026 12:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11256B008C; Wed, 24 Jun 2026 12:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FB46B0092; Wed, 24 Jun 2026 12:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72B786B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:57:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0BC341C583E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:57:42 +0000 (UTC)
X-FDA: 84915412764.03.E4E105A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3A37912000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:57:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2EM5shB;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782320260;
	b=JeB6DP6f2LJ4tYd4pS7Hw9V6cO0/W8J8vhwwqRfBwcTYNoWtMnO0HsE7/hWufwaja/6fDn
	g00kBNDjAovkeRh1s1UJ+NqwF+LKtLuHE8MLDqbqgP5MYdvmectQR08d5Jhtwzvlkkv1or
	EWmX7hElwe8cfCMGifBYHAuosU3LnGc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782320260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pj+zfe+/Q0BE8fYRnsp9PT2NFlf9FSAYTLWiogZWvR4=;
	b=rTxsQ8rKG2OWWf2kJv1Hw78XD/t4EdMmRt2YMF6V9aX6oAkdKuW2e8RLIZ6EOJ/uh1Qqlu
	VCvqD67okpLZ24W94wCRQwVrNp1cLyEs4HGbmAwNw11qyH2xeiky65i/lnVVd41m61FWU6
	+LGcYNJeW20PHMUkEixPIcIvAuMGk38=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2EM5shB;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FEAC60018
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A111F000E9
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782320259;
	bh=Pj+zfe+/Q0BE8fYRnsp9PT2NFlf9FSAYTLWiogZWvR4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=h2EM5shBKdP3kHyvAcDlJcwpMMK7wevCutenACazD5lMtA7WiTsBSAdfwRfg2uO+W
	 A+UU/1/Oh502boIHFslmjDhIdw7ffNNktyq9NIgpoDhH/VcmkptIachTPSQPvRX05M
	 eFyaNMJ7lZoYWnmfURBMS2Hs1mHEiM2Oh/g4V3xLGOqe3zhAHvc+iUAZK55WMkf+5q
	 0eT/Bx6T3RFXMdf/GeRaNQNAECknJeqy9MqezDTyTUS0+v5d27ShNf94anTas16bn5
	 zPF5nAa7tv+PdhNHhbmkEW7T8U7vrxw/PbUe4mInTcA8Dc6hD6NMhqTOAnvPIAAo7y
	 muJ4A28LM0N4A==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c07a6527453so177010966b.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:57:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8IvWHbBE/xsR3VHfHpBnKbl+nPBjZpKphdmQ6F5NBoeg6eky82VkhhH6QUj3ktc/k2UCkXaNHYYg==@kvack.org
X-Gm-Message-State: AOJu0Yx1pZS20QeTuc9bHD9Sajyn7WvUJzQhVKFXrqoXsOYTeEjgmdMb
	8gXZXotLhwuXDQ+UZJ2AubU3unH0P1B0qvPim3Is9tjpaY4RR6uI2bLywMF9F9n0hYLwXk/xKr+
	oRkTSQAFDnABc3ni2rJA9WUbqikBWTyY=
X-Received: by 2002:a17:907:e110:b0:c11:f6cd:e120 with SMTP id
 a640c23a62f3a-c11f6cde17amr86990666b.25.1782320258297; Wed, 24 Jun 2026
 09:57:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-2-jiahao.kernel@gmail.com> <ajnB8IZrFZwbIr9P@google.com>
 <d0f05c35-457a-4b2c-6faa-7a83d4bdec01@gmail.com> <CAO9r8zMgaqP=n6rmhnMU+qhp1Www1Y5kdbLTLX1v=fj_ybHyiw@mail.gmail.com>
 <057ea303-4c27-1a6e-08de-cce26c699097@gmail.com>
In-Reply-To: <057ea303-4c27-1a6e-08de-cce26c699097@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 24 Jun 2026 09:57:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMmnYkXocZ9Fb9DL_rdAHt5xtT_FLMxJD1bHcM3B4wTFw@mail.gmail.com>
X-Gm-Features: AVVi8CdkRvxUn8N-b2cW1L0eOPe_x3eeQiW3Dp7mX95Wjv4nFh_2RObAbBdbFR0
Message-ID: <CAO9r8zMmnYkXocZ9Fb9DL_rdAHt5xtT_FLMxJD1bHcM3B4wTFw@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] mm/zswap: Extend shrink_memcg() writeback capability
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A37912000B
X-Stat-Signature: 8668hkdazj5oumr69jkmpponytta11nc
X-HE-Tag: 1782320260-200547
X-HE-Meta: U2FsdGVkX18PBl4Wv8ar7FDrn0BZMQAdYB+XChv754AbI+H2RycmTBXY/8eZUU7bwnMOxXay8ioVIUX+MbWsCiwc3w6ZXOiU+rEoMIXIv7/dvpm0QCFkuvkT9EDzWkG0QEPcpM6PJD89GzKDFtHDdx509vPiH519Kw8Oetdsav8v2/Z1su0nGKAOjy33bRsYULO1akp+/e/oVE361wbQ47fJt6P2g4DhhgJ0YV4DMePh0nThQiItz7F2uuuDjcO3c8vRhiGb4e9Eag7MztQ3uXdVwwxmwnpUvGRCbfo6/OOdX0F6FTgN3Aaltw27xj2lW11ruu78K/etMKud8m3aHbm5g/5s1Qy71QK77U1y0+NMISfp0PsHplSLDZrfXKaJR6k9A4OpB7Zud4F7MpkhPQckH5tTtu9l2OLV27ATiP2RCH6z2LtkfsqF3/zLJy9OfuMDL7VRDSUmcGZdkZudWOidY4Cn2d/246rcUpxcaJCyde6F6dlhEcod73RhKO/pJbMgIRKUbZDT3ciFm3RCg4yJ4ZVM8Cly6oD5ZTOXjxGiB+IDCKlWxrfnjML2/PVZnVbO2qvXaWzRdrED3SXwxSXFZS1CIBIRC8uRWteT3GaV1K0Vv9MxcAJKtYCG9QBlzyNrEi90Jks2Y/WdNjPh3DH/rdHZClLoCQ8znmNFdsgdzgYau4ktzLJpp6yJ5oIYNZevote3fwoNi9Yp5ejoKmLq1629zWjt0lrCeLI5afSiANd1Y+s/NVHBy42KKAUI8CoLH9qN9smLDVIfNdg3nzbu2Ul9hoYcOIYafRAHRRR1ouwOZ8T6LJnrXWyGF6Evy7fWtaZRQfRAjPxerkt8ZpxkocG/IBugr+9f3thHK/vGvFi/BwuffviZwygto3szwipkA4H/iZnxuTgJ+ZOUkAHVgoHz4Sme8Ra+tuz9B3W/QIB1W5HfxEEAqhXKe+FWyy+wf/b05oiGieTh/hD
 A5j1xZ6o
 hTlTrtoDElVXPr53L8O2Mmxuf2txxrPuCoXHeR5MDfvW3gBnYzk/A7T4Fk4954haS0FQQDfLgMRLpj+ZLwj4CrJtTgNpCwGDCPJU40L39zAvL/7C6zCYi+z9xu6Tc0E2ssPupREmD7PmKMbs5eI1o5hpMh5MCFIBYt/AnWWel/0EA04H/o1JL5nQVHYoOxicUOz1soE9LZb1lyM6FjOhtdVTbRzuNmFzz38NmfUj9t9q+Ib+ZIsZPzb3TUGZAeqNKc3Lx8mU+kfR1xDLViWS4uR1JcoRKgS4qMQeyLM5kjJnjfN+O5lkzHAc4o9ihLXw9mesx2nloFTAHH5XODe+jLHThmm1WDqPR3FjI2Wc4HU4oZxMk3Zm0Jj6BXj8ZhxoABtts2iUQzJgtg0+9JTiTfJXXZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> /*
>   * Scan up to @nr_to_scan pages across the per-node zswap LRUs of @memcg
>   * and write back the reclaimable ones.
>   *
>   * Since the second-chance algorithm rotates referenced entries to the
>   * LRU tail, the per-node scan is capped at the current LRU length so
>   * each entry is scanned at most once per call. It is up to the caller
>   * to handle retries, deciding whether to scan the next memcg to complete

Nit: "whether to scan another memcg to complete.."

>   * the full iteration, or to rescan the current memcg to drain its zswap
>   * entries.
>   *
>   * Return: The number of compressed bytes written back (>= 0), or -ENOENT
>   * if @memcg has writeback disabled, is a zombie cgroup, or has empty
>   * zswap LRUs.
>   */
> static long shrink_memcg(struct mem_cgroup *memcg, unsigned long nr_to_scan)
> {
>      struct zswap_shrink_walk_arg walk_arg = {
>          .bytes_written = 0,
>          .encountered_page_in_swapcache = false,
>      };
>      unsigned long nr_remaining = nr_to_scan;
>      int nid;
>
>      if (!mem_cgroup_zswap_writeback_enabled(memcg))
>          return -ENOENT;
>
>      /*
>       * Skip zombies because their LRUs are reparented and we would be
>       * reclaiming from the parent instead of the dead memcg.
>       */
>      if (memcg && !mem_cgroup_online(memcg))
>          return -ENOENT;
>
>      for_each_node_state(nid, N_NORMAL_MEMORY) {
>          unsigned long nr_to_walk;
>
>          /*
>           * Cap the walk at the current LRU length to ensure each entry is
>           * scanned at most once per call. Referenced entries are rotated
>           * to the tail for a second chance, and this bound prevents them
>           * from being revisited within a single call. Retries are left to
>           * the caller, which can choose to rescan the current memcg or
>           * move on to the next one.
>           */

Nit: Make this more concise since it's already explained above.

Otherwise this looks good to me, thank you!

>          nr_to_walk = min(nr_remaining,
>                   list_lru_count_one(&zswap_list_lru, nid, memcg));
>          if (!nr_to_walk)
>              continue;
>
>          nr_remaining -= nr_to_walk;
>          list_lru_walk_one(&zswap_list_lru, nid, memcg, &shrink_memcg_cb,
>                    &walk_arg, &nr_to_walk);
>          /* Return the unused share of the budget to the pool. */
>          nr_remaining += nr_to_walk;
>
>          if (!nr_remaining)
>              break;
>      }
>
>      /* Nothing was scanned: every LRU under @memcg was empty. */
>      if (nr_remaining == nr_to_scan)
>          return -ENOENT;
>
>      return walk_arg.bytes_written;
> }
>
>
> Thanks,
> Hao

