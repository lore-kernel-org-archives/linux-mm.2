Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D42AC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 08:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F82C6B0088; Sat, 11 Jul 2026 04:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB4C6B008A; Sat, 11 Jul 2026 04:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3988C6B008C; Sat, 11 Jul 2026 04:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 130126B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:14:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A5531A06C7
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:14:00 +0000 (UTC)
X-FDA: 84975782640.25.F149014
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EBABA10000A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:13:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FzsOqxB7;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783757639;
	b=tp5R07ujpAiNtgtuK5h4k65h//Hx16NEfJeDhjgO32n3hJPckF2xNWwdhjLAp34wSEcGUj
	fHNvD/F6hBuGIjlN1eTKDsNxOGT/DeKmTLvFd534dr9v3CVAvxVMlDVsJwUWIzCscu4U1k
	1trODZEe8EUL3EE5GKpkNM0hb8ko7y4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FzsOqxB7;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783757639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fL+OBgv9MiT2Y8LAZqP3EBv16Se8dNO3kHDIpd+tmoY=;
	b=OSP6hM3MEjwXyPwZ6qz3hvb2Fu8EinTcC3mkHEVAOu8gKf6vIYLx8YZKAfNBqqMXXRphxL
	vKFSz6OOwlJRxUMpu95zXX5rYKFRJor9VjLcLeXq3o3PRBAK4kKhXRcdbKdf8kiCOmQI5H
	ktgKaKTKivfPVM/M2meTA0mNxVoO0s0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B85AC405A2;
	Sat, 11 Jul 2026 08:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8901F000E9;
	Sat, 11 Jul 2026 08:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783757637;
	bh=fL+OBgv9MiT2Y8LAZqP3EBv16Se8dNO3kHDIpd+tmoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FzsOqxB7yjmk8r6CDB1CdPdVSUYM1meVTyG+V/ZCtyKyIxP8e+cqryo0Fr21Vhz3f
	 66ASdWOyx/Ehv096Cid8xYzpM1MdYGKW5fuzjrbhydwKrjLdjaqZDw9vHOM8JXFOfs
	 rUOUC/QVGHsS23/kpeM0sWl//ckJbBvai8EZtdI0+4DHZ+IG0zxx96PzUqIdqj698B
	 2dqdoTX2/qf7Ej4kKrxD7mipggBuyjgxRIeyg1015ogfpjPZnoEdMcgkn7A3tZovYc
	 trvndunLLmVIFkvPHKnMACJkgKn7DEYriLNwEC9kSWhUwV09GEOaDBA6/y86oy5VPK
	 gSCC9MZQaC7Sw==
Date: Sat, 11 Jul 2026 09:13:44 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com, aarcange@redhat.com, 
	shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com, kernel-team@meta.com, 
	sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH] userfaultfd: wait on source PMD during UFFDIO_MOVE
Message-ID: <alH7Hey7XRiL4dC0@lucifer>
References: <20260705131231.1499198-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705131231.1499198-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBABA10000A
X-Stat-Signature: ja1uedb4tbjkckeyxc8bi3rt8uiz8qem
X-HE-Tag: 1783757638-443390
X-HE-Meta: U2FsdGVkX19mGXK8XPAsZUvTQYhwEzYpTeii3/qjr6Ds5fZwtjwHz2I4R+ZUNJ6VgA+gQsDtylZ9Q1DlTNYq1VSl4wc5AgJJVHJQE980UxyrkuoD8FZGc5DW0S3PXsreyrOJvDj4Kwq5COslZLC1Iov/PrYjeeX/4dzwFPxmH/cFXrHuDB1GrHsGewOyDWoRC+tgJVblDqMIt4SMuxTBfa6zcLDGddSzNMGpu72tgy5monfyHYW9ypM55gIp1EsjeXpZMFk145+wnYUblcdHfAP6SPa1eoH1K85JWk5Hx2PNyDFY7LPR+qiWZ8SV/KhKcvM0VRMV451zP52bm7OdU8XRUiG+PUIVb3kDlaCHr42VCict9QOVwGLASBYkewM25i/wmsajOpgzA2+T6O1FnauJCaQN30hD76O0avgIfEDBYsYXGzskwRPr7Ttgc9+syKO8M5v+0Tp52Q98KnryItFdbm5PTsZDSUc8qyWIMK3NEXbONgwlRgtAtyJQ65hrvqRYqiv4pJiwpnraos2SH6MleKKxkVzoleXdIQhBUo3udr9fG2lOf2iiPmiSJk5w6yWGnmyY9kKibZNDxBeNkilFVpawodWsNXOF2IXadbs4BkBNgDr2shah3FFV5nv8//P1Jp5+ic1KVb/SkRdgC9LyK0kfNBpWrPNwsPrRfs1/1IwpSD77dD5OhzGaJTOmR3bLd/nrOrYqA4F3Cfl5nWHF7pFYlUR4zMCZ4EkrtXfV/uYfODflpkvu2fRk/m1tH3nDGWTnVEAKF8ITJTdihjsSpfTH9Lhu7HzrBElfFljhsHHjTlpeMf8VGsF0bV7cSB2tAaLUsi+tEhff4h5hiyugms5AsPz1JGDt9WEHS+f2svGRy2cdlcBsnXGPESuCKd8ll/ZJIu8owmVFFuJqDMJCMiH2+Q6MY4L5aUJa0288SWbnNA8MIvLjKGtHFeaZ2G0J17LSLhzEmdCX7AH
 H6RVXox2
 XLdvXfHoPkUDUDcxpiz6b0J7i7Snxfkuyow4caEEXwJjjuMrWvagFWymb07FXRzfmJcRsmPVHZMr8OJ22uk06okEUmARwnVuT774e9G/rVQjpFb9elL2DWJ7Q8rOiqUWoLrEFF2SpbyGFygFOsZcGsCtpsw0XFGgnYZUr+nuuc9qEOguqPm6zGCJ3c578qrZa8kAFO+++aTFtzaIyLl0eqsqU6pcg8CrleJh0Nat43JjRgqael0ByFBbnNxm3RKh7qlB2MvScBwVDqjHKyhshCKbCpVMIYrMHKZr2I7NGUTvV1O2LNsvadSBHsn8+6wZ2TH10sof43Hv5wlmRP1EjVoAzaSKk+1ibO2GNGOwy4apy+ZiZcuz0W3pLzDO5J6b3E0WZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 06:12:31AM -0700, Usama Arif wrote:
> move_pages_huge_pmd() snapshots src_pmdval under src_ptl, drops the lock,
> and, for migration entries, waits with pmd_migration_entry_wait().
>
> Passing &src_pmdval is wrong. pmd_migration_entry_wait() must lock and
> re-read the real page-table PMD; on split-PMD-lock kernels, a stack
> address also resolves to the wrong lock. softleaf_entry_wait_on_locked()
> then waits without a folio reference, which is safe only while serialized
> against migration-entry removal by the real PT lock.

Yikes!

>
> Pass src_pmd, matching __handle_mm_fault() and hmm_vma_walk_pmd().
>
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=8
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

LGTM so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bdd8635922f9..c0892cc533a9 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2775,7 +2775,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  	if (!pmd_trans_huge(src_pmdval)) {
>  		spin_unlock(src_ptl);
>  		if (pmd_is_migration_entry(src_pmdval)) {
> -			pmd_migration_entry_wait(mm, &src_pmdval);
> +			pmd_migration_entry_wait(mm, src_pmd);
>  			return -EAGAIN;
>  		}
>  		return -ENOENT;
> --
> 2.53.0-Meta
>

Cheers, Lorenzo

