Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74856FB5173
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 00:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39116B0088; Mon,  6 Apr 2026 20:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9EB6B0089; Mon,  6 Apr 2026 20:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8616B008A; Mon,  6 Apr 2026 20:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C24F6B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 20:50:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03F49598A5
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:50:34 +0000 (UTC)
X-FDA: 84629929230.17.FB52FE9
Received: from crocodile.elm.relay.mailchannels.net (crocodile.elm.relay.mailchannels.net [23.83.212.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 680B312000E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:50:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=mv1Cg4rr;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=softfail (imf29.hostedemail.com: 23.83.212.45 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775523032; a=rsa-sha256;
	cv=pass;
	b=8e8llArCd9fhB6AnJK3DfnvUw0equwJePniKgCAzIyHftOSbSZ9DabqkmflGxsMHCj7Dyy
	iJmMptIwYAZsx82rxNT134g7vgFF8DulSnUhp41L8byzAbiOXjaZPIwSxWfQ2pFD88alZu
	AHG9hvahvQFAY1zQ+SK6wfxuO99NM5U=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=mv1Cg4rr;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=softfail (imf29.hostedemail.com: 23.83.212.45 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMwxCUdDzcCtqZxPCuLtLzFRvDztipo2RCcHqTcTHXY=;
	b=244WdNlPy+8os2E5LEmg3ELuIy52FF9YLdDZKflQ8Nc4HrDSmw3Yy66cZphXdAfbeQ4P0Z
	0loU1Z1DH5CYz6nn9UYH/+wHuScFhuJRGjdcB5cCEn+JunqSj/RT68qoqiJbT4fslyArCK
	Gvv2b6r2XxIOzoHCJsDNMldBsfC9Gak=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C60C37E2FB9;
	Tue, 07 Apr 2026 00:50:30 +0000 (UTC)
Received: from pdx1-sub0-mail-a247.dreamhost.com (trex-green-6.trex.outbound.svc.cluster.local [100.118.167.109])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 5656D7E2FE6;
	Tue, 07 Apr 2026 00:50:30 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1775523030;
	b=PQ8g6XBGhZ3w8GyAzZxmtZDDF8PRma6cYXOwYdQ1IXTE60d7reRM30s5WLPy+SyoWuoEA2
	OXktNd2OKP0/azrdNfbZYnbijPeqA53TMuG/6XKtLSmWyyAuz4z97WE64KamvHOC0S0g/k
	Y+NzGdsHa/Tp8l85MzMIEOVuoL5xJhEBgJUCyC7K4aN2Q+3oCw4O95y2ILtL+Y6ETuMZl5
	ETgMcOhLk+ebgdiQk9wxu8szouKShR7XegUHkmPMnKwazj+/zm1GuXfCyNqTabOI60zMxI
	lju02TVt2n0OGLAWeDqTavsgxa7t42KLuuDhjsO5X6V2Rn5nXstkw+wLSMRlfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1775523030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMwxCUdDzcCtqZxPCuLtLzFRvDztipo2RCcHqTcTHXY=;
	b=A7QBoKdFgJgD6nuljAjde7LQCjT6y/o4QFt+4Qo7FUmaUcjblJOBetMcWpO8lMJZfB7Wi+
	ENkAYNmYhWozJfRMlftCEUG6SLH0lxljHws/KbGvlG0t8+xCWaz7VmWUDEhQ0pmYejZWiQ
	hTEoOTrmHFoDgpcchs4Vh6UaaLgycCPFOX5xSiC0DtGeK+c3HW43RloeCfJfIfbZoR7j4W
	+mqACVNEw2lkTzGDWUlH2JdxU35T7mPhbjWoQe6phJCwbmpsuVNJqOr3tjVeDPNZ4SHdzp
	FroUHCdnJ96iC8pvCOPbtf/W1b+O+ZB4rdhFEomffKssda8htW5HgcjEm3f8jw==
ARC-Authentication-Results: i=1;
	rspamd-7d86dcc447-zkbxw;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Cooperative-Relation: 7a2bd04419e8d27e_1775523030651_2650626807
X-MC-Loop-Signature: 1775523030651:4205056266
X-MC-Ingress-Time: 1775523030651
Received: from pdx1-sub0-mail-a247.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.118.167.109 (trex/7.1.5);
	Tue, 07 Apr 2026 00:50:30 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a247.dreamhost.com (Postfix) with ESMTPSA id 4fqSKd484Wz106F;
	Mon,  6 Apr 2026 17:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1775523030;
	bh=cMwxCUdDzcCtqZxPCuLtLzFRvDztipo2RCcHqTcTHXY=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=mv1Cg4rr3UA6eaGve5YgvG77w4ObAXvFsTim2FNTd9d8Gbzgy4wB6+r6kLbfSXn8Y
	 EcKmcQvmIANOGQl2dekmu76q4jfs3F9s+Ad99W/odWYAafHnaKGlULG65Lm5BEdGjw
	 UHB0iLDE86uWB+iKmySfhCCHC6RyptXweYrd1MQ7x6NtnqsW1kRnbaAT3sVtBOLaWv
	 XuTF53MdQZj5JigOcH4K4GAnKc5m3WaBhxvIy8zqG5AHZJzPhdsdpvLX0Zpe3MJ/YF
	 9PJUAhRo3ph6CNQv/vu1CtLqX4CAYiJAQYisog9w553GsEQdeHF0+CqQKP7bh897vH
	 fQUVajMRWapAA==
Date: Mon, 6 Apr 2026 17:50:26 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/mprotect: special-case small folios when
 applying write permissions
Message-ID: <20260407005026.ytf7ed4bk2ljyflx@offworld>
Mail-Followup-To: Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260402141628.3367596-1-pfalcato@suse.de>
 <20260402141628.3367596-3-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260402141628.3367596-3-pfalcato@suse.de>
User-Agent: NeoMutt/20220429
X-Stat-Signature: yecaahhkcwt9ssmmtdez7icskhfyqe4n
X-Rspamd-Queue-Id: 680B312000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775523032-157557
X-HE-Meta: U2FsdGVkX1+C5qKODvlGkbzK0SLgoP2Rm405VFfUSLIH+Ld+Hih9ULz4vt+27pDaL0SjmCuGp3LazLNaxBlAxuHrIorUmZwl8vWMmWpYnRImaQJ2lY5Iez0u7X8qoufRGnJgWX5aAb4HHEZYcmY1oOJMVoMoLhokf5ProHbBvPj55TMO0fLatKNHNV4ZGzJlz+BJfr0WECBCRr+iTdG8/gYl7qWKBKqg4aQirGpri7HGrDC/101K/vHoI8Ekv9BJ8+9LV/yYKWdfOKtOf2kXefwYsGSf1ZbcbnSq3Vh1dHEDqckAoSLwpnoQltHTqKfehYS729b6+f2pPqOOTEOJWDP8NN7THyxR/8FFtV0iVw7GdrSb6NKcrq9WUSve8QplAjJYEB4KqQPImZ2hd+miHOPa9ilAzqRWF91i7hDIq7D/Nz0ggTak1gXtOV+0dNSG2FyepjaQvk46E9pO8YQNNPwcauyJZJDlbJCRjW6PdDoh+vSqiXvW9BB1gk0wfNpRLpz9vCuMWPku9iQPJ9PL+wqJUzUEfbXvWBexN5m/PUvgQTMChi6ksSd+SEQXa3NGx4u9793GVGmgb54ArE0YpVVSbiv+YFY4b145ky6qhu4RttvU51mJ6OUr/fDKNQYZJrQ9mtMIortlUtpTRpzPYzWsaqWWFZKchbpmtRkx38wYhw53ebH0q7abC9axT/x/pBDcBQBOI3rXPCrguNyQtWPHSZ9FsZmMpoAryQxPVaEHn4N0WIZ8hMiPhRhNfrQKUIEDb63devC1w/jWUYp7LHiQZXkN8iktM9r6Mp8QR5UZacRvmPEPAFA2bC9Rb05kWyqzRvHv2D5WEKxUlzyPVYAMUV3mb0p9m2JbX6T+qjrfP8V+68XQE7yxtAJdYv+X6e6ZoNA4+v1f+ZYGvdoLgBP1S5OnIiO2wUOhtkpGJxS9Eo8CdPBiMYvV8dECXh9UE26owQ3FKW17hl7Im7J
 7QYhWJPn
 5NKmZy+9Q6vxjQ8oAHCT7cmBghnpXrWHKYlK+C0XC8qJaw6SNHCY1OesRvQM3N3rTEVczwypNpPuSjXpZE/8Aru/zHxiHl13Q/vA81HAEGE84+OHKONbrfnzfvpmciPjEnkG64zm+7q2m3nsvP0Zb9bN8t5SXeDU5pSV2MbLQPc8Xlyaj/FPVwEdymHH5bTh87R0HMF/KO7sq+q931HmWeHPL4tl5yhK0CQINxDl60qBcdDuFoS+2/n3Zuvj96V8OjglTTkeN6JkdlLR5D4VjrSfkWMox4XamjiaDUeeE+gNyySwlTdfrmO5S/+xtR7f8Fyup
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Apr 2026, Pedro Falcato wrote:

>@@ -334,34 +371,20 @@ static long change_pte_range(struct mmu_gather *tlb,
>
> 			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
>
>-			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
>-			ptent = pte_modify(oldpte, newprot);
>-
>-			if (uffd_wp)
>-				ptent = pte_mkuffd_wp(ptent);
>-			else if (uffd_wp_resolve)
>-				ptent = pte_clear_uffd_wp(ptent);
>-
> 			/*
>-			 * In some writable, shared mappings, we might want
>-			 * to catch actual write access -- see
>-			 * vma_wants_writenotify().
>-			 *
>-			 * In all writable, private mappings, we have to
>-			 * properly handle COW.
>-			 *
>-			 * In both cases, we can sometimes still change PTEs
>-			 * writable and avoid the write-fault handler, for
>-			 * example, if a PTE is already dirty and no other
>-			 * COW or special handling is required.
>+			 * Optimize for the small-folio common case by
>+			 * special-casing it here. Compiler constant propagation
>+			 * plus copious amounts of __always_inline does wonders.
> 			 */
>-			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
>-			     !pte_write(ptent))
>-				set_write_prot_commit_flush_ptes(vma, folio, page,
>-				addr, pte, oldpte, ptent, nr_ptes, tlb);
>-			else
>-				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
>-					nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
>+			if (likely(nr_ptes == 1)) {

Are there any numbers for this optimization? While I am all for optimizing the common
case, it seems unfair to penalize the uncommon one here. Why is nr_ptes > 1 such an
exotic use case (specially today)? ie: How does this change affect the program in
b9bf6c2872c ("mm: refactor MM_CP_PROT_NUMA skipping case into new function"),
which is a series for optimizing large folio cases.

Thanks,
Davidlohr

>+				change_present_ptes(tlb, vma, addr, pte, 1,
>+					end, newprot, folio, page, cp_flags);
>+			} else {
>+				change_present_ptes(tlb, vma, addr, pte,
>+					nr_ptes, end, newprot, folio, page,
>+					cp_flags);
>+			}
>+
> 			pages += nr_ptes;
> 		} else if (pte_none(oldpte)) {
> 			/*
>-- 
>2.53.0
>
>

