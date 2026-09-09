Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13668C79FB8
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 08:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C256B0092; Wed,  9 Sep 2026 04:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0656C6B0096; Wed,  9 Sep 2026 04:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBDC76B0098; Wed,  9 Sep 2026 04:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3B666B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:32:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D8B64014C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:32:22 +0000 (UTC)
X-FDA: 85193556924.17.AD271EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 33620A0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:32:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mpRVrNuC;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788942740;
	b=B/M+t/xOn1yBwewnLK/+Wh2WqvMhvdeqCW+7FBj68z5+yLKDOFj/rh+3HFuzT2R3+YwBaI
	Fc2IK0MeO3StmmBwswQ2asSLLGVxYB9BBEHRpFZYDrIadW0TPXZzWPcriu+0AoDm7jx0l7
	D7JD01NfAhsgPRz31cJrJwWrs7Syr54=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mpRVrNuC;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788942740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQb5JmxZ0Qe6CqSOm8aU31RKgc13uigRQat4ijgMv5g=;
	b=QiIKEe4QMhDEaYqzl0yAj+CyhWdO4c7+Q/b6xI0zdBYT+NSqTTbCIebuibeGMlTvNKtRZX
	oDfLiPH6aafdLy6yx9JmOPIQCxvTK2mRmMDUHbMc2VUux1KtKjAMSJm7g0s1ZVsDKOibQm
	o9QML1/HKUW8d1guUz3irYxlX1hc5kc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B894D6022A;
	Wed,  9 Sep 2026 08:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F5E1F00A3A;
	Wed,  9 Sep 2026 08:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788942739;
	bh=gQb5JmxZ0Qe6CqSOm8aU31RKgc13uigRQat4ijgMv5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mpRVrNuCbiYPGBCXwIl2Uck00ne1+/3Q/Fv77IEuqy37gWNELOXyO7MJgYppLb9mg
	 jq4HEj2qp61rmCuPGx9F1DCsDvzjR4RCQptO/5nRmDMNnyNz29I/2bpt1NhENdbi1P
	 2o1z3zZF8+rFKXtQT918yG6wN1OjE6kNUnQhLn8ijp6j9Bny9GlJxme8rjO6Jn0h9+
	 rRZ0i70LSRCJYbEsp62gfc+8Xc3C39F6Gf4En6htyzi3e2DFufaBlfyOXzdqICuX5f
	 NSOGKNB6xKIXCULSUa1+bZ2DMO9iLU9hlMIJBAHnPAn6H39VxpgxK2OsDYIRfiBDwz
	 xGcsLHxA2rsng==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 04A9F198003A;
	Wed,  9 Sep 2026 04:32:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 09 Sep 2026 04:32:16 -0400
X-ME-Sender: <xms:ixmhapBAkuku58ph4ImY5x8HTVPR-a-GHKAjHxGYs6i6BiyvN3qKJA>
    <xme:ixmhaoUBIzF2-XTqz7Q7XsZGfUlu1qp45g0XksgG4xE2nvHasOECB1sdiTsl2pO5l
    5GTTpQq5vkhAHq3zb82uLYnekB3t8N4-_vt0SV7VfMF4kFYptJbgQJR>
X-ME-Received: <xmr:ixmhajJkKcLS2mz5yC2nM9WoVWg0BrBys96tr8i4aSAb0w6YWN2RHC2QFDU>
X-ME-Proxy-Cause: dmFkZTEa2vldEggdEtHpw8yPdhwCuH7pRJBb9RsrLsD2yFmnjIBvi4LSmi1+fPsBQuYbj4
    E1kgGLriuiXtzGGyPjxHIE8WkxV1amP5nSmc2hlMfnzYczx1VVzSWXfiUb+MMAUCaO+wBf
    kngiaudPMNXdGDaTdWhzYha/rQRzY7G7hO2gKWvcmIITfUr++w+fz7Ts74FLZQ8G5PnsFA
    o6nqU0hohLcc80EVsNQJj162+Ryg1GuJrSdu4MyDXdV2qNQM69VAIDJTKqQoGIjeVRiPkA
    XPvShuHApELamEYQhCPs8BdUdTtGsNF9ExW2oaDo4YBPLv7N6gCGtu/4QY5C3a/ra8BZBq
    PHQW4ZN0AD8FCgPiZ6uvULlKEm26eTIuOD29lLn40JxD5TZGyOPSZBPeRjPoR0RPZgqNSG
    GASc8/TMxhnUJht36f5AV8dZHmgy25t+BdhiVQcGMYiu8LzO4p0TO1D0DCsbGeSwwcOt/s
    leuAPDN+XeIxUwVRn/+JeqHi+vyV1ztJxLkeVNwnCPklvWVhKh99UE/l5DaslnlbpdT3Bk
    HJugQYWSiF90Eo2xUFb4h/6nDLcUBxMjXNnFf1plkeU8WH5SAW/UOtaN/Pt/TppS5AniQj
    ceYi5Jw4bc8XDT2qofLQV0N8qAgtvzT3d9E96PCd4VLuH9L/s5yreuo1oozg
X-ME-Proxy: <xmx:ixmhapnBRQeKBI6JefPUyoGVKdLmRUfd0mee4Z6wkbE_kF5KZhx_GQ>
    <xmx:ixmhapbF4_h0SWwvVgvjBuFYcMTM0Y4EnmGfPv0xqI8cl9xP0E4SfQ>
    <xmx:ixmharjVrk24Ly5lce_-Ir_xpNjsbaLymW8W_sU2dY5NnSp-mDd6gw>
    <xmx:ixmhamR_iJQgddaEJeo83whkibJKXPIzgBVxT4Su9buLDfaZxIPKyA>
    <xmx:ixmhakMNi6fJ72wgmOz3jhfeJDxhBWXrW3IrYidVt2TZmtZd34Op3lN4>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 04:32:10 -0400 (EDT)
Date: Wed, 9 Sep 2026 09:32:09 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Shivam Kalra <shivamkalra98@zohomail.in>, 
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v4 17/17] mm/huge_memory: drop the redundant mapping
 argument of __split_frozen_folio
Message-ID: <aqEZd-M4x9lmyMqy@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-17-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-17-b532a3f20e71@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33620A0003
X-Stat-Signature: msuyb1kzueec7i5b19eajewsjy3eshde
X-HE-Tag: 1788942740-25387
X-HE-Meta: U2FsdGVkX18fRd3SGQI4vi56jJOJaQ0nUsUUV5U16EeNmTkAQV9k1fJ9ySvpqqJBkOVgDW0BHk7sh0f3F/irERYh9enf0FS/E9Z50k1iqL7d4mRD7pEvSI+90D5y6Foaf8CMqsTZnp9Tf44ucryBPTu+GbisLhmxDrrrYtRfRJaFJYFZO43tB/ZNRP+95Ga6/niQ4OVdiMjkDgzH+ArUtn6JcSioCueO+n3oRHzVFLYxMPQDCVbco+apNlyiHM+PAhc3/L6BVxvdzy+mrUvY7gzs/RNNJjeqdFSuCQyto9dfdDgSwaZ9+TarrEn+tFsBFio40r36qwNSd0OBQHdl51SSbEzJ/lw79WpimUD8X9ixMiZpV6ZJzxkvd827c3TzmldfKlWyv+yrkq3a3C5UiTqB8eEBUpxM/PQIJBGn4/3guIfsbzpSRa4VfGGpQGNR+10QnowR9G6WTugfXbd/OWInXA5efIQ9JJ5dKuK65tjF1oAephHR3+qwgb52z53GIvQm/e5BGbV367zn6SHGc0sUKIpDpbG0cwVEhadkrOeVFENRJbR3wNN4at6HAsqPxg3l3MN4SwR9Q8LNZiDhdtwx3Tnxx0IoY+F6gWMjdiQYqQ0ZGp5CIN7pKOEmZhbBfrLvSFMfPYsShS3GBw/Uyuw/86pi10B7DE39IcpdHkRVUwXV2KAjGfBfLYuA//+T1/13ID4jMJoIZp28UiU9o76uDRi5KkNl1N8ZgOLQ01prs0t5eXSLr9I82f0Z7mVgi08igaYX5lp+5LnwisMwh+XVKAsgzfsSa+AkNy5nKO9gLTFNXsk+K0deRNJ0CecGc4fZyhKNnfkStnbdKbtiJYX9t1XuvOPTtJ0RA++OdM1uhvizi67C14uk5OdGZbk4ZGkbGCgGIwmz+wZERGggrgYXCEnnLC9pqSHzdOsCTF6PYNGIJDB0QSwK3mqM56CORsAQS/alnd28aajeArq
 Y7Lj4fhw
 Ol5wWW0wsdtqqRzcpXiYYnoJggaMbmCMRLBPz6EURdDhartq1AYNwH87nJq4B6xPYYOadcH3jTeQLFCDsVaTJFQlMgRzaW5TsMlNHR7gSgSykwEd0ORweHqkOE+ytTVvXmWwA3uPbM3Lefj1QTgp8KhXQz6xCU/U4DczC4nWtisHTQSB36DNE2PgvBq9fd8USXP7Mm4V5kStuykW1P8tcjuAA7k2VAr2sYJoZfi3UqHlNAY826+5vr3862MOTH7HLQOobSnboP4iEQexi3YmODCwNMi5SPdHvhaBaXwTjc7vRhJ98rrZ7qSY6d8Hy+LENMWmK2VqzrG6saydritRRo+LGZzTLCuU3zm0Q63vxGXkhoqdEfzxeWpYceN1277ve37DbD0hsFk9lGA/fcXQps1eURE3R9bD6X4vf6Pk2mnDl0TLFbErworvs7tD9RhlMjS2fg9o8dCuZ7T8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:21AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The mapping parameter only served as a non-NULL check to detect
> whether page cache entries need updating.  The xa_state pointer
> conveys exactly the same information: the anon split helper passes
> NULL and the file split helper passes &xas, which is non-NULL iff
> the folio is in the page cache.
> 
> Use the xas pointer instead and drop the parameter, along with its
> kerneldoc entry.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

