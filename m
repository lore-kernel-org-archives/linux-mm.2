Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0243606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QS0kLU7m
Received: by kanga.kvack.org (Postfix)
	id DB8B76B05E2; Sat, 14 Nov 2026 02:21:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69B56B05E3; Sat, 14 Nov 2026 02:21:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58DA6B05E4; Sat, 14 Nov 2026 02:21:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A91946B05E2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:21:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36382160375
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:21:46 +0000 (UTC)
X-FDA: 85432879812.13.C0AAA40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98897140005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:21:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=QS0kLU7m;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640904;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SySnQWEZZt0ZJcY0gD5OVrDsND9/1T98niGZwR/wiT4=;
	b=OlXo6raGZr1JiBuCf0Ji6l8FKhTIzWO+N0zex++lfME40Yrp4CLAkrrdRGJ+HK5sEH3bUy
	Vtt4sgRgKBK20LfXiE21vc8MwdlK/IRgYEomzNRdDtiy9vBSTjjBaJEuQO2hU4wyzNVnXa
	KQDjB3ELtoXvpLZ7aAwQ6KOUc0Vizwg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640904;
	b=XDLmiA8Swq25RIPjx952Bm7/wfm3v4QG3E8S3hpHnQRU3irm76o8fn20ib0xPeEsbZjEcJ
	bHGLt9+M+o4fYwxji3onhaAEgA9dEt1YKLpKH9bhFDrd+wGEb9zCqkz7XdSgUTTfvluulp
	NZrdRoSuScfywQDjZ02FpCwKthkDpLQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=QS0kLU7m;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11C6F60E01;
	Sat, 14 Nov 2026 07:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3015F1F000C4;
	Sat, 14 Nov 2026 07:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794640903;
	bh=SySnQWEZZt0ZJcY0gD5OVrDsND9/1T98niGZwR/wiT4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QS0kLU7mA8nNQkh1mioJKyLHUOPwA4e3Jbn/FDXu8YM/vbOIvnClPO/kYBq3DaEPU
	 To6lyW4Bodv/ef+5WC8o/CDKIJ3pHAvzh2zEBZlJZbChJGwAG/LgfxTjc8o935qFb2
	 skhSmpPaYX1NTyHPmPhSEKm9WdyII5LpDWl7BbEcefknr+mzW3BkXbx4qdkmIitUMh
	 +0U0WctafQuOZlgsj5kFtrcQCCNChTjBAC/V0Y/paSOCGm93hiUKwfj17txlZCiPS6
	 cQyFBcxkfxHv5wEIYjr9wEGF/rxi/8LisMNs71oq6Wx2dGyriH/Tn0hEFRzJfxsgiw
	 RgiKmZAVtUk6w==
Message-ID: <sashiko-outbox-214261@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/22] mm/khugepaged: restrict collapse to common memory
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, linux-serial@vger.kernel.org, damon@lists.linux.dev, linux-cxl@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, johan@kernel.org, jirislaby@kernel.org, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk, pavel@kernel.org, lenb@kernel.org, hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, xu.xin@linux.dev, chengming.zhou@linux.dev, joshua
 .hahnjy@
 gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
In-Reply-To: <20261114070959.3490008-11-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-11-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 07:21:40 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 98897140005
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7bc3u7ei4afqt1ngk1y675upftyo7bfy
X-Rspam-User: 
X-HE-Tag: 1794640904-295364
X-HE-Meta: U2FsdGVkX1+CgIItX4lMM/I7/x+fejlnVBPsANoKz6KX8Rlx2thNND1bbJnmiLSpOQ/npVBSgYqOyt1YURCOUyMxXsBh1p3ct9O2fPxIlYE7umlbqAnB7tWBcXKFv3NGUbu3CoZ6XoIKAMlJ57Mp7kICAqhDg9d7j2Q9LVAgVRifqjri0ksLzzytZ7xx0jiN/PZ8fpWgINybyaAZh+EezJSA/zG5luqmQ/18q3tglkbu1QqG/KDqyLEx7BXmMP2LIIFO6KNVQSN/4dl1P2nNLuItVsZQ/eW/Qtv+eJzXQ9VErZmtUC25CTHf4HtFjh5MudYQiMDYasDS9bAlldobxojKdOy4WHJ9zvItbKgD5YJxUWzkojaOemhesZdcaHEeZwv3Zb4955nKIYKaoqy/j24ZU7KMXpoHm3y4Rv1g734KmaLQligsIicIhUrPkzS2bVaVSJA4DWTB9jX6ORSAKkGv7GYTSZcxZruDUTocz5QKvEQr4vXQEDj9XcByOyiQlSQ2CZvUthfPkRDm5Locj78Td7MxTxPPlD7OOAxeV3jX3WLN8vc9f2yrdmGJ4w8/o+54j5c+R2VgPtH2/l1s2KxgxB85EtF/cBVX7i2Tev+kbijJ7+GwQUtFkW3S1scyRHE2LNi5HmgL35sFOxjJnWOKUpzLumeswCUc8ReSp4CIbrD29ygc3ViwzZlf/yW7lnavgxYrxQ8J7JoS/unctYuqQfISVOSCtCsqmcWx2czUd/080DOGskhwrRqTrC+7nzWGCGOBR8QvUXE348HoLsNdpXr6rewpuI62r3tNridSj8sa2JXmwq1USZvgPp4bpry7OVd76SMWz8b3VWdNBUWQqi5k7l5wsN51il0/xiWSIGa9pwpAguDG4980e7hUemQYrHQZ6c/Hz+qYYsq/P5A//9rRJU68ieNtb5lGY77+MiU3f47gM5anYMgnisQUmc+pUnFyqnPOapUjMuQ
 zsuDpEbR
 7woEqi5CR0I9DPMhhJp0IlCLCfsjPjGlcVBl9C5CnbSM+OIM41bNKEjD+0qJUjJImzraCjZaHcDjN/gnUDYTepcQXgbacbh921+PPv35vh2bP1cWpKZqCSi8LF976Uvz8JIu90EM7F1m+nc4i/Rm5QBzJAWVx5fRUkNakjabFrs6wCvIQ5smpcsX8m/QLtdaXS0AfSSUbFVhXfqpj4vkySHWIPgT/knL8Vha6NZjxoMmLPcqv98oV/EpVPua6KHmgc1ujjALc79r7U32PF8oFMRr0WrKIqmgatKY0V/7m7b09rKcTWQbMlUAFJqPGf281vu1VpOqBI6r0CmDHSoimXC1umt+9Nsa0jW9kWNwD8cZmrD7Gf96pGfFsaJnX1qN0A2RO5OQX0jlh53kJiVvwR2qmtJ/2wS1RO6DS+yIcIAqbdkTQ3PPAH10vkYBHO7q3taxI8cwWrhRX2MuC1r9GPxmytn+oPcs5vFRe//AdLfbuB0IOej6ZjSKQf6rb5Y7TLs3OTw+eqf/Q+/MZ2sYSKG/oW3uSmFGOY7gzoh046FWA36fYIry6Ky7y2fI2lcqs5qrBBKw/og20AnsR5/tCEZzh+dJiLhwueJrUaD1Z8sHhLvz3NVtX2V1iRbBAbIKZ2GD4chrm3nMw+U6j4zsjUc8P5MUNH7yX2s3mSvM/jeXX54ZSrD9/ukz2Lm4PSg6I4hkd0gfab+kU6v7i6LDrIQryjfk5umFQP53WBLCipwvDJ/5zGhVo9ZIb8UAGZ+LRLZgavOjsbLbFJvMlUkkxlkRFw/ezwQmQU2KT
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
- [Medium] mm/khugepaged: missing folio_is_common_memory() check in
  collapse_file()
--

commit 5cdd71b37e4c9e4d2c7bf61d7c51d7ba89a07fb5
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/khugepaged: restrict collapse to common memory

This commit replaces the zone_device checks in anonymous THP scan and
isolation paths with page_is_common_memory() and adds a
folio_is_common_memory() check to collapse_scan_file().

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4bbe319ef86fa..b4bd29f25c145 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c

[ ... ]

> @@ -2741,6 +2741,12 @@ static enum scan_result collapse_scan_file(struct =
mm_struct *mm,
>  			break;
>  		}
> =20
> +		if (unlikely(!folio_is_common_memory(folio))) {
> +			result =3D SCAN_PAGE_NULL;
> +			failed_pfn =3D folio_pfn(folio);
> +			folio_put(folio);
> +			break;
> +		}
>  		node =3D folio_nid(folio);
>  		if (collapse_scan_abort(node, cc)) {
>  			result =3D SCAN_SCAN_ABORT;

[Severity: Medium]
Should collapse_file() also check folio_is_common_memory(folio) after
locking each folio, matching __collapse_huge_page_isolate()?

collapse_scan_file() drops its folio reference on each iteration and
skips missing page-cache indices and swapped-out shmem entries, and
collapse_single_pmd() drops mmap_read_lock() before calling
collapse_pmd() -> collapse_file().  Folios that are faulted into holes,
migrated, or instantiated by shmem_get_folio() or
page_cache_sync_readahead() on a node outside N_MEMORY_COMMON after the
pre-scan will still be isolated and collapsed by collapse_file().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114070959.3490=
008-1-gourry@gourry.net?part=3D10

