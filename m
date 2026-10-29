Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2594606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JpAFqAMm
Received: by kanga.kvack.org (Postfix)
	id 78B3B6B05DA; Thu, 29 Oct 2026 11:51:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762E06B05DB; Thu, 29 Oct 2026 11:51:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 678006B05DE; Thu, 29 Oct 2026 11:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2685D6B05DA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:51:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C4FB14044A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:51:51 +0000 (UTC)
X-FDA: 85376104422.18.B1A8C83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CE1421C0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:51:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JpAFqAMm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793289109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqt04aVmWCFFMW5PhNUnGvgQrBeB0qH6TmYzshEFSoo=;
	b=I80L9jsjEUU9NMEsvqmfTrLL6cuOB59igBtk79UHepd0eXQ1YUXN8pH/Z4UwTP72gNATd+
	olrpN8vi6tp6Pkzm4c8WUvvOYywqnVANonQEwNBsGI7hEo48GB1GalwRo2/itG0WtPDgcj
	l+GCoAzLeKEIdCOVE3xDe/qlDbxvuWg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JpAFqAMm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793289109;
	b=23PpEUAPBOrUWFzqNhoXLwSA9ljmPaSEKikWAxamb11TeCsC4rdBBgGnNhzUMBALnFVQES
	hN3XZsQG4KCKrC3Sr8h+202h2m58NNzqEVMdErBYZGp5cUEj3LcTew6W4tDSgMKC+/UgVm
	tswicOjpbDcJAlhkyZErZh4YNcHB1fE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F6EF60207;
	Thu, 29 Oct 2026 15:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CAE1F01816;
	Thu, 29 Oct 2026 15:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793289108;
	bh=fqt04aVmWCFFMW5PhNUnGvgQrBeB0qH6TmYzshEFSoo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JpAFqAMmtKjz2YNA1PCteNNZKLQs6+Kbf3XFPbl5KJzUPOekANKjzlLumikEZG/GC
	 kyvzIS1lMX/dB23SwAo8ObKjij0MkZSGJXHCpJcSmMkD2ZiM/2zw/MgQt4V85bYnI4
	 EHP+FEgtUrKS3ncKCRvUu3BL2PDXOhefQr/vJTPEww0seLm7MLu+nYFvjr5pCgCFco
	 R/YA1jKSKnGcq8ioaXtqLJw2Mp3D4uGmEdW57c7J0G+y67HRe82W6JgCqNchkaVMuy
	 ItAIGB0PsekMUWRi+ZP9SkN6dQM3dYGNgqVRp/6lcGDi3ZqV0NxezVxQY22uZxlL5j
	 iN6uKrHV3gzbA==
Message-ID: <7efdc32c-9df4-40b2-84fa-1ad90196b861@kernel.org>
Date: Thu, 29 Oct 2026 16:51:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/8] mm/mmzone: read each zoneref slot once when
 filtering by nodemask
Content-Language: en-US
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 akpm@linux-foundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, mgorman@techsingularity.net,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20261028211930.3504634-1-gourry@gourry.net>
 <20261028211930.3504634-5-gourry@gourry.net>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261028211930.3504634-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CE1421C0002
X-Stat-Signature: uuf8a7yoh3bcq6ut9rit6tbzew1gsg7n
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793289109-776320
X-HE-Meta: U2FsdGVkX1+ssYP/q0cB9TZUXlGmoE8YYPZgi4sYWv9/omlocZ1g0gGL5d/vL4eawzYD3qvp2qjgxDFoMuEHSKUPM7JgFGJAEXchPyK8Iy8j9tkZYz5UFdfiBVc+NYtmXgXSqwKsOTr11dNloYx0iaR0tt/ZYLxr0zNejzXMdqkt4giMSoave/ywhuMV5/ead8plPiVFyf9A7KQMlMaJf9qhxfURyBgX6zTgB61j6w+3JjCOJv2kS7LtLdqUSDvHLsXcvbM17hhX/DowGKqZLRzH1Iejc7ooAWjQ8Stjuf1bO+IwZ4hZRpWykrRn+mztYh44J5d39v8pc65mMcfgM0We15rYgL+jzoktEzT9dfbv39QgFpzojwgr91LKsJ0gEqVjLI2OvKCcchKtKNFJEMJzHPTdxcsbBAQlKhB6XH3Q1uCc9zUkM/ds6mbbw+aKxkcUWQ7282L9TWlVobIXNUSYjR2F0Pcji1rR56r4req8z6urWN7FsQiXxkivZ8KjOQnfz/H6ll04F3ny1avxWn3HZZhM4F3sxARZK5D1w9RceIAvNlx+IeFucw27S+MCiN7OL4cRXrjH1jSfr9r2wV32n0/LtZgKXYj55Ul3t6LC1RgCmeRccCpIiPcVVr4KowB8NPmJ2dAiElmab54rBh933y/V/0RWX77uo5rktoIdrNTgqVnr0Shf3M9CNbmcH6PiZRNMgkMlk9Cg+9OLA8NrzYBTHsaHiUqEtACpBbWrf2AOfvETOa7G2Bj7zmLLaG1EwjhOGXOhxqqZ16K0yO9aSjQQDbtPuocTrrYj2ok4qDyDk/U6TQ+lL5y07qCDSvS/N1OzooItTI/SVBKvR7IT4rrgWfyVkx2A6HmwuyC9JTLsYHnjW641DBndva5kj79jfT3Yn++EGaRJXI/6HGIcgO8X3+JwQx8zGr5lv3HR510XZd6AeqXFtdqRCUL3RvwcBeTzSdNtGdtSu4B
 e2/f88Yr
 t0mrSagdI6ustV5LRD5gG209Lel5JYhY60im7mCUgXy9HhO87vbcU4WTvjEiAe6Lct8wAA+Ck64Eo809cf+P3gFvzil74vPLV5zncw40mSxUmNgcVYyiuhlo05Pq2+bciZfaePEjCMp+bKP43+n0x8U2EIAPPUsVg3aZAYuDsfYTROaBNIN5azubxxPT9qiJK2c8GA7KNLsNWD5WrhaG94ioHXGr3fVyXI6LC9Bud79KJibrruaSOyD9WAlQzVhVtVoB2YWVWpD9+l4r0UKLbYyEQvG2qMZBx6TT3DdsluKxAfwz3pEWnK65PS08bXHdvg/kQ+mo24iQpIKeYy4Zbe/hhCrHtGRC4ocdMiQo2XL4qswJH66bHmhsJxlS2X8C6Dj4+ZHDohWoO55QmO+WzuIqUx3Kp8qXrutKd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 22:19, Gregory Price (Meta) wrote:
> __next_zones_zonelist() tests a slot's zone for NULL, then reads the
> slot again to look up the zone's node. Offlining a zone's last block
> rebuilds the zonelists in place, so the second read can return the
> terminator:
> 
>   CPU 0                             CPU 1
>   __next_zones_zonelist(nodemask)
>     zonelist_zone(slot 1) = NORMAL
>                                     offline_pages()
>                                       build_all_zonelists()
>                                         [MOVABLE, NORMAL, NULL]
>                                         -> [NORMAL, NULL]
>     zref_in_nodemask(slot 1)
>       zone_to_nid(NULL)
> 
> Current GCC and clang merge the two reads, but nothing requires it.
> With mm/mmzone.o built with -fno-inline -fno-ipa-sra, holding a
> nodemask allocation between the reads while the node's last movable
> block goes offline oopses every time:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000060
>   RIP: 0010:zone_to_nid+0x0/0x10
>   Call Trace:
>    zref_in_nodemask+0x9/0x20
>    __next_zones_zonelist+0x23/0x70
>    prepare_alloc_pages.constprop.0+0x16c/0x190
>    __alloc_frozen_pages_noprof+0xaf/0x330
> 
> Read the slot once and test that zone. A NULL zone still ends the walk.
> 
> Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Oh, zonelist_node_idx() reads nid from the zone, it's not part of zoneref as
I thought. So it's the same after this patch, just with READ_ONCE().

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/mmzone.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mmzone.c b/mm/mmzone.c
> index 9cc9ef588580..009f1dd75dde 100644
> --- a/mm/mmzone.c
> +++ b/mm/mmzone.c
> @@ -43,13 +43,14 @@ struct zone *next_zone(struct zone *zone)
>  	return zone;
>  }
>  
> -static inline int zref_in_nodemask(struct zoneref *zref,
> -				   const nodemask_t *nodes)
> +/* A NULL zone terminates the zonelist, so it ends the search. */
> +static inline bool zone_in_nodemask(const struct zone *zone,
> +				    const nodemask_t *nodes)
>  {
>  #ifdef CONFIG_NUMA
> -	return node_isset(zonelist_node_idx(zref), *nodes);
> +	return !zone || node_isset(zone_to_nid(zone), *nodes);
>  #else
> -	return 1;
> +	return true;
>  #endif /* CONFIG_NUMA */
>  }
>  
> @@ -67,7 +68,7 @@ struct zoneref *__next_zones_zonelist(struct zoneref *z,
>  			z++;
>  	else
>  		while (zonelist_zone_idx(z) > highest_zoneidx ||
> -				(zonelist_zone(z) && !zref_in_nodemask(z, nodes)))
> +		       !zone_in_nodemask(READ_ONCE(z->zone), nodes))
>  			z++;
>  
>  	return z;


