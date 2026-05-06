Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49562CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A786B0005; Wed,  6 May 2026 10:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C4126B0088; Wed,  6 May 2026 10:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58BF86B008C; Wed,  6 May 2026 10:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4430C6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:39:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E55D61C0179
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:39:01 +0000 (UTC)
X-FDA: 84737252082.17.AA3B37A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id 20281A0009
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:38:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IXGDlvEQ;
	spf=pass (imf15.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778078339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wtgFS0qzHMjcCdx96uO+vjwwSC+JZlHEyhKtxJCn1Q=;
	b=zLdaJjArJgg+BmH8z1YQLUFCmDlaL6T++kbunvchy/WroF9lqGxz7GYX55r6ImSGesShQO
	qLj9GO5KN6R/6DFQx1HdawT5tUCxQ8VzxvXYhq/gW2ap34xAhfDCulQxLgSJn/IHr9FC1D
	aRn4WGLjT3yviNIxMPrcV1WzYSdPi+c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IXGDlvEQ;
	spf=pass (imf15.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778078339; a=rsa-sha256;
	cv=none;
	b=OulqGETDSdK74a1f52DGPI+5ksOiPnVRYovj5W/wcUqxWh+wWW21S5wzaWmovTL7MKxQpV
	ONL3xl2Tq0tliutM37BkBK8wLH+ZQl063+ThdnCUtC4ED2KZ66PBpdNcbgZfrgiBFcWS0g
	yJ2MDcgG2U0CENYtueCKtfiRmPgnRj0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778078339; x=1809614339;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=3cyqpWM4hY2WHFw6kor77wf8w5w1B47aBYbK7oUub5M=;
  b=IXGDlvEQKJPDnqRwA5AoDysOuKIa4avhx18Ga6mfCtI9uHSAmjXC8P7W
   1CgUeJyjJI3PPEzsjpyZruJEWRjjtQeecXozEyl2mPOEIumNbkcFaM89H
   2ynYAmmfzX8NRDOYG69Kgpk6l/O/FzFNA3M0j2OLbgslDoIsWyvBQIfri
   rRNnmwpS1/ynO/pkL6YIkgqBhltDTJNZaeuw6KSuhuIp+/6xhY21gbKKl
   1QmHF9Wt1QANh67jzBncijGYSG5R0M4NyrpHDdId4zHxiNtKeYxsfvesq
   gvePxnEGqk1tKD1zoj+oc4IPG8kh5j1l8VT/MWIjpcSQp6Xduoy6jDiDj
   g==;
X-CSE-ConnectionGUID: BK7kFVz/TdKpDSKTJBjEew==
X-CSE-MsgGUID: f+o1XKYOTnqfgyM618HJPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="101685855"
X-IronPort-AV: E=Sophos;i="6.23,219,1770624000"; 
   d="scan'208";a="101685855"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 07:38:57 -0700
X-CSE-ConnectionGUID: MO97WVf1RiKlPmy703qAnA==
X-CSE-MsgGUID: +9Zcu98LQayImxZ/dfr1kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,219,1770624000"; 
   d="scan'208";a="236074423"
Received: from kniemiec-mobl1.ger.corp.intel.com (HELO [10.245.244.213]) ([10.245.244.213])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 07:38:52 -0700
Message-ID: <ab7836a9a776c73e96fd296ea8440ca075af5bad.camel@linux.intel.com>
Subject: Re: [PATCH v5 5/5] drm/xe: Make use of
 shrink_control::opportunistic_compaction hint
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 	dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner	
 <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett"	 <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Shakeel Butt	 <shakeel.butt@linux.dev>, Kairui Song
 <kasong@tencent.com>, Barry Song	 <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie	 <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, linux-mm@kvack.org, 	linux-kernel@vger.kernel.org
Date: Wed, 06 May 2026 16:38:48 +0200
In-Reply-To: <20260506033300.3534883-6-matthew.brost@intel.com>
References: <20260506033300.3534883-1-matthew.brost@intel.com>
	 <20260506033300.3534883-6-matthew.brost@intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20281A0009
X-Stat-Signature: cqzzzsuiqnh5t77zff3sytbqhgzicziw
X-HE-Tag: 1778078338-935721
X-HE-Meta: U2FsdGVkX1+yX/bEU3LA4S0AS8jUISnHmBLzoErkSCJhvv3lIdj/brXYvy9nQTnt/6wH4adBiqHpMQENZUmNSDUjAM6vK2FoedGTxtC9nEW/7SADZXCVTI7Gb2wfvGZlsVr3HrFIjMsdQOyXqBW9EOqwvNx6LjWpmYxi59zHju+UrS/KjsqpO7eJhdLu4TWe7/b31eYSvV6s+AXTYcI0/PrET1jC2omgI3EhM+YnYkvQasDhC/GqqU1WLplAMhuIaUj8WaT9lXvrrzty9MgZkIKdgR9MBXXS+0DDORCTCteMRqtKGLoEXCdAxCzjrwyOHJp4tsNNo3YdB9kozHyyOgyjGoyr51cb/HpmOSjcGkrYUShqnsTxTaZicHCE1C2IJXa64+29Eu2ccNLaTMy0YAnW681MnrVEOCKD6ba5n7yGHGzCsUe/zLFP+cB51HhuwAq+gASl45zTH+AuGDDLugk0fzDeo0j3aZl+OsD6InGSSGkSBvN/YncSr+67rH82JkaYteTABRJOOJOIjRk94MZGiW6Osc5BPqqocrnQqiLo1mLNt9OFArxBomAk3hmMJvIsTFIN7/yNA5tW20g25fCyEcvk1pUMcXQzt2oyfrv/eRDSfbxdLojvUjccpuTYy3kKtJ3+n+j5QT/qKPD+6tCws1bzIUD8REyHI/F7e2HrXwoXLTY8vp+1Gz/4JXm5WEfO5L7KuyNFZLTf6O5Pe+gSFsNaz4u9oeXYcrqw9rxNYIRGedVnzsUlK/42/1cqe/LJurdl8a0nFp/tuNLKgjcBdZCdHPc+ntw5VtmSV78Yn/T79GgjL7eMLrXoXzN9TRJkMza67irhTREyeGmP6LMXgD1+bFfGlF/9/aw09pZnIRt0mcteABeJFZrgYQGPxJPL4+jNXM/cgg34fVfSXjOf5QoH1VL2SAEJpfTaj68aKWh8HilzGAzbnygdVvkmjQPEPnmp3bvXBkwnqS9
 2+N4cpgf
 RXOER2k6BTGhG/g0GKHv+bi/n2aDvwCSA46QeU4JJV8pQaayhQvpATQHeHl73/K9HdavFT+wCDeIpuDWnm5iInj/MSlPbQaqNzouWpUICBqzsheUpc1fbud8q6lHAiaacWffSSxynyyvpnU6ifJ+XA3TK2GMJGd4hJK25Y4ZhG+wL8dt7HbfU2Uu3FS3wedYXXxYNdZvkQyYZzoQ3+qz6lABzoRK0z1zuvHd1sUMVRWnXU7T/lD8n0IIRnsPssBwB5pN9mv02xFvv70Z5NHBRLkOtqK+3mKm0npMu5MSakmsbSzD4DwPJR6YBaXZHCF7RiFrgKHlJvO930HWGXGc5CCxZN8Zp22YUy0I3+pWjQXWVwhaZ5DOrh+t/3LUrpaO31iDfdmjAzUN7JgGHH9f7UVuedMfgByG9Xv7wtidu1JFAy1EQWBMC3nKVD9Zp4HNcSlvBF8e/BBE3YfuD9HonSGrNwSVbrjtwwK48e+NCQTApYU401CuZ2j3QRVX5dWhHXtXjczrLBoisdNm/4Nzez81hHVer/WtOcNddnwxe6rsaeEEdpLJv2gzKTKtcdnzgXD2lHv43iyzUUx2XJa7jKHoFPCX5UN+Z6Ma1sf424VRo0Oi493AFqNH0nF/g3IvStx54WmEyZkY/Wfak/Uv30iZjGzCZ7nWV7GRYz0Vvd9s8fbBE3Uc5FO104h6buIlY1jXt0hrXUz+1J3u3zaVAWqg3VkpyNf0rG/ZP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-05-05 at 20:33 -0700, Matthew Brost wrote:
> Xe/TTM backup reclaim can be extremely expensive under fragmentation
> pressure as reclaim may migrate or destroy actively used GPU working
> sets despite the system still having substantial free memory
> available.
>=20
> Under high-order opportunistic reclaim, repeatedly backing up GPU
> memory can lead to reclaim/rebind ping-pong behavior where active GPU
> working sets are continuously torn down and reconstructed without
> materially improving allocation success.
>=20
> Use the new shrink_control::opportunistic_compaction hint to avoid Xe
> backup reclaim during fragmentation-driven high-order reclaim
> attempts.
> In this mode the shrinker skips advertising backup-backed reclaimable
> memory and avoids initiating backup operations entirely.
>=20
> Order-0 and non-opportunistic reclaim behavior remain unchanged, so
> Xe backup reclaim still participates normally during genuine memory
> pressure.
>=20
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>

Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>

> ---
> =C2=A0drivers/gpu/drm/xe/xe_shrinker.c | 20 +++++++++++++++++---
> =C2=A01 file changed, 17 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/xe/xe_shrinker.c
> b/drivers/gpu/drm/xe/xe_shrinker.c
> index 83374cd57660..4646b0f5b82b 100644
> --- a/drivers/gpu/drm/xe/xe_shrinker.c
> +++ b/drivers/gpu/drm/xe/xe_shrinker.c
> @@ -139,10 +139,17 @@ static unsigned long
> =C2=A0xe_shrinker_count(struct shrinker *shrink, struct shrink_control
> *sc)
> =C2=A0{
> =C2=A0	struct xe_shrinker *shrinker =3D to_xe_shrinker(shrink);
> -	unsigned long num_pages;
> +	unsigned long num_pages =3D 0;
> =C2=A0	bool can_backup =3D !!(sc->gfp_mask & __GFP_FS);
> =C2=A0
> -	num_pages =3D ttm_backup_bytes_avail() >> PAGE_SHIFT;
> +	/*
> +	 * Skip accounting backup-able pages when this is an
> opportunistic
> +	 * high-order pass: TTM backup work shrinks at native page
> granularity
> +	 * and is unlikely to produce the contiguous block the
> caller wants,
> +	 * so don't advertise it as reclaimable for this hint.
> +	 */
> +	if (!sc->order || !sc->opportunistic_compaction)
> +		num_pages =3D ttm_backup_bytes_avail() >> PAGE_SHIFT;
> =C2=A0	read_lock(&shrinker->lock);
> =C2=A0
> =C2=A0	if (can_backup)
> @@ -233,7 +240,14 @@ static unsigned long xe_shrinker_scan(struct
> shrinker *shrink, struct shrink_con
> =C2=A0	}
> =C2=A0
> =C2=A0	sc->nr_scanned =3D nr_scanned;
> -	if (nr_scanned >=3D nr_to_scan || !can_backup)
> +	/*
> +	 * Stop after the purge pass for opportunistic high-order
> reclaim:
> +	 * the subsequent backup/writeback pass works at native page
> order
> +	 * and is unlikely to free a contiguous high-order block, so
> doing
> +	 * it here would just churn working sets for no compaction
> benefit.
> +	 */
> +	if (nr_scanned >=3D nr_to_scan || !can_backup ||
> +	=C2=A0=C2=A0=C2=A0 (sc->order && sc->opportunistic_compaction))
> =C2=A0		goto out;
> =C2=A0
> =C2=A0	/* If we didn't wake before, try to do it now if needed. */

