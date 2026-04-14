Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C274F531DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69F46B0093; Tue, 14 Apr 2026 07:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42136B0095; Tue, 14 Apr 2026 07:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57C66B0096; Tue, 14 Apr 2026 07:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 946516B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:06:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49EDA1B7E75
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:06:38 +0000 (UTC)
X-FDA: 84656883276.04.ED9F3D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6C63640010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:06:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ewjzQJq5;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776164796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDF7nDDLFJnMbQaNy9ofsg/kpYlM/ftHbhfCx63XggQ=;
	b=c1SNOtuWiVFqVjbqCFQf5GeizIRhTyuYpi6v0HjFokNm4HfuwtJ5ckmVc4ss5NX0FR9OEh
	Vf+bQJzVNt/5evP9buhBrZcxxmKoQFTQvuBX+SZX/mr8e3xF3UzP6oMyLSeBZBqgXYBiLd
	Pg2Faf2Nwp2O3Xc5OZ9nO+j2/0egDMY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ewjzQJq5;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776164796; a=rsa-sha256;
	cv=none;
	b=Kd7XjDujeauMuMqQpM3irRdhxE0yoEEhlJ3nd+hCLBrFQiddsxP6Rkehn5TaDbW7BhrUii
	O7OBvW91eNVo8NV2L07zV5aqxw7CdjOIAp1GnPQdHad4nNPj/V+q5w3Yo2DJpUD+QL/kv4
	HOaY38nGoEkq/U1gqQZ8qwagDiAoRX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FD9344528;
	Tue, 14 Apr 2026 11:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C6BC2BCB5;
	Tue, 14 Apr 2026 11:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776164795;
	bh=JGfefa1DoJ22jqYhuRyjdbGP25GphmZWxYCWiDFEfVo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ewjzQJq5OTy5YsNSMVAMFmMgqOxtEFjCduZ91AkzvKD7QXqKPvhMpIVN0EDz60NAZ
	 6hopk3tIRtasgG1qKnjJMYd8L0YDHuJBhiijXLijs0C4Mh83rCLr649tXOcnQ16tka
	 30OHKmM5Jc36dZamTEy+vua7OHoiRMLzrt5FwLZa6PytQULW9icN8K5LPslr8wxs+X
	 /V1ynud0OC2GG0Bd04s5XU+xmvVTsjjiWG50vAcFQ57YwkAykR27sBWtIOm/JYN8se
	 6PExDjl68N1MB9A5X0WUv3bb/f4a4haUuHWt/Zs9sw8mU+rBFYxn65SBDjrdn/aNvs
	 I1LEObs+N48SA==
Message-ID: <f9e00b62-d798-4e9d-9474-d943b4634203@kernel.org>
Date: Tue, 14 Apr 2026 13:06:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 10/12] fs/btrfs: remove a comment referring to
 READ_ONLY_THP_FOR_FS
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-11-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413192030.3275825-11-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: e9sxmou834ypoppzedtfm3hswd8f58qh
X-Rspamd-Queue-Id: 6C63640010
X-Rspamd-Server: rspam09
X-HE-Tag: 1776164796-530145
X-HE-Meta: U2FsdGVkX1+HGsxerA+AMC5/9FyTWtzAP2Kg3c1hclO6uN2OQRHUCJdwyheRW2I/4gFUPocqX8nwAFcYUvP4cM0+bT3usyeVoh0S38UF951M22Si63kElZYsDUtXDf6rGd29Y081/hkdcPpKJa3gD674ymRQ2366XeCR9H+LPV/oe3MnBeHUFgYmE/WMcnJvNR89VGah0q71IefpkERTXbgm9fp78O/bvEAvF40UJsUn6URDwdlLtGmYnrpoV4b/A0XF6ayshH5FcymPv1rnDv53BfXMUz0KCrSX7xXkKOygP8/9nTNWmNYRGaWmBeGCIoSIr6jUjAsNvZL8H4Tz7dYoa5G5i3LlFtHXmq+if8rN3iXpcPo1Vx2Z4flsNS/z/X68LAO+4716AgpjaXq7Ere0FUugmtHON7PUJDKangbI6kjyaVNbX9idGHNtPH8x+eZ8SsrtAYfou/9BKgI0+q9pa7Pep8qD0Z3Nx93AE+ZrV0zxGUFLyj5C+jjqpi7Hm7+Z7QS6Kx7SlQqZuC5bO245luucH6IfGVOs6jkslmzYX8o3TFmTPeUTXlD77Bq61gmslNvniOaWrOSBjQEOE9scDJuYPGVwWjrAgF3TixboVjE95ObXNa/u0zfGxHJJoR87L1+mkmJ4XqKffCxPMtZlJut/jDTay2vlZTRwiP0XeogVcDVU4Co56xmrxBSKbGNNQnpGkF+XHVYGH+8XUbnVuGokzXXxZKf3FwKUvpIzGHyOlrNx/2+IHfe7vMoF3k2t+VAmgDnGhgUy4KqGHQfME0zYwuBsixabaylUrKsp53CiiurVRaemR/zp8+sZnWaRSRayEroYwXCpbejApetwjVn2o6o2UB/amHaZWOkNKjZSE2AynWp8F5Fw3PJE0ACTDtslnMBF/v6jUU/IQ8BzRgWEo/osP1h48boKUd88ycJGjInmDCxp6GWU5EAJoH1uwTOvgxZFoaYfxvf
 zkFipmMs
 BLrfaBVZQtEvo1TVs3oYI+MW4hDM0Fqs7EZ1EHk3bmOdT94szBG+uXx+NmlveSkhZSrZ2TGiPfF3csnjCsert0URFELcDDBBRyGp59N0Ldc+AiTon/C88ceC/P4SbjdaBTG2ZlMWCpW0TkTvvhowk8SBhNFp4ghH8v8Zfnlfh2QtFuVCD6pOlQqZBD5MGhsHSrpf0Bd1jHETPbYXB3Qh1hokNWj3viQTK0z7MCSPrImwwcPCKpqDr5Ucgr5hF3cwI5U0guZVumoFEnt8Evv5dmPhn3Lz2pW9Jnpc4KM/eHAzRqbM6JXDHfoHeRU7273yBvWc5tTTi9hlyMoDvdmUKbgPZQiWr0RocTIngy4DypHmjx8PSE+fKyvmCqPBSwoCGbI3KrjgXvsZy6Q+7rQzc9es4PZGDPU72iS6W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 21:20, Zi Yan wrote:
> READ_ONLY_THP_FOR_FS is no longer present, remove related comment.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/defrag.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index 7e2db5d3a4d4..a8d49d9ca981 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
>  		return folio;
>  
>  	/*
> -	 * Since we can defragment files opened read-only, we can encounter
> -	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
> -	 *
>  	 * The IO for such large folios is not fully tested, thus return
>  	 * an error to reject such folios unless it's an experimental build.
>  	 *

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

