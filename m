Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D033B606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j2dtf538
Received: by kanga.kvack.org (Postfix)
	id E39816B0623; Tue, 24 Nov 2026 03:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8596B0625; Tue, 24 Nov 2026 03:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D276F6B0626; Tue, 24 Nov 2026 03:06:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABBC26B0623
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:06:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 298ED80AD1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:06:46 +0000 (UTC)
X-FDA: 85469281212.09.0397124
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6637F180008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:06:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j2dtf538;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795507604;
	b=VVrTi0RwZyi8TDIXVp4iEN37kcabCdQr9oLS//GtI83RjiuWDzr4+5Iku0441AXn+r/+1m
	2D+pEOVYIN1wr8H1KKncpoWWxir9vqxbqiRUQiLRqiwKyj5aZ/B7ucipyX9pGvq2NOVyN2
	ERhPaPupannv4uGAttR274H9y8PSYnk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795507604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2bCC99C+lk6cByNStvrWaJYTderaexjScUT1eLFyyY=;
	b=OffYWhWMcfULDb8agI/yE1g/b/cIW+BaiCuITNfmNzXp6U3wOfGpDF5jCvCxM1OPIyqP6R
	E0009JUk3kLIcRG9GrUsGigZSA29DtXZdaj/JcUewMh0TYwCX4kr1BMB4Concfbj3a6Qvh
	C9KGpGUGY7K44bSp0pFY7zYXlhrj3zA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j2dtf538;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D658561FE6;
	Tue, 24 Nov 2026 08:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBF61F000C4;
	Tue, 24 Nov 2026 08:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795507603;
	bh=f2bCC99C+lk6cByNStvrWaJYTderaexjScUT1eLFyyY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=j2dtf538ZvQbD48tnYzf92OiepBTDnl995jnLselJRCMx8WemJcdvFtomDfJ1z0yZ
	 towmIc+IctwpQclWmW2tFVyxCL0aow67UZrwIl1TL87HckdxbQGoQ0BhgPGctaiqyx
	 BXGEKByAHORiZO8Cy7zeSW/OmNr90AOirBojH6lwYHW9TRA8yHdGxg9Vbzo2zfxwsh
	 d6rHe4/7ya0WiiHhdWxOjVmFAkZMyelH5Qs/wz2uxob05X1UjoUr0WghHcbaDtg5k7
	 xnGR5WxHpiH5hcni6EuOoPGrC3IBmJwZvxe42RNTVmUaVSd+CfNIQ/XzHfCsbdUeyA
	 lUAb9FExiCO3A==
From: David Hildenbrand <david@kernel.org>
To: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Samridh <samridh@modal.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261123-samridh-shmem-send-v3-1-afc6a40bc187@modal.com>
References: <20261123-samridh-shmem-send-v3-1-afc6a40bc187@modal.com>
Subject: Re: [PATCH v3] mm/shmem: avoid zeroing new folios twice with
 init_on_alloc=1
Message-Id: <179550760133.6617.5807645850229041647.b4-ty@b4>
Date: Tue, 24 Nov 2026 09:06:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ig49o65pasunodwzjguhb4rm45zi8kac
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6637F180008
X-Rspam-User:
X-HE-Tag: 1795507604-333334
X-HE-Meta: U2FsdGVkX19HL2fyfbVYkpaJ4fZJ4w1UAdHF02GeWS7NY0rX2GIHgsj7qpQiBEgnJ3vkQiit/4KV/BmFrFLkCZy+htqKGVByM8pNrXBaVM+kLbyl2JELc36Amyp6hHiGFxjCu+sdC8D6gPYUCa1g8oaQDV8CDZjblWg8+pXQ1a2G1BF0nZHVx4T45NJ4M/1oeoIgumoyig5kASn3SOTPoKBbhDtZoTIZbovMGjOPu94KPrErOYnXOIg/tDtCIAOEurgM27shikKzN+8W3MpGkWFC0jJOfBwcA1H8yPaWc6tHWx59avv/fYMh7Qo2Q9S5kkpsFHMadA3Y2XXrICnE3x9LyVBgh94zbZOnXU/5mqleMvq1S2BcQBGllBxVpkwMxNfQqO5FMJzwOApSykGDfQwwl1Ai96dHPrZXTTs8TLVCr1TiSzUg43c/CnT4JZ5RqAG4aJWX5I+qNSjiY1y1iyJpfaz5BI6PoEjWgpvKPmej2Ird5vxjMuz1LCcwT1eLywkHKdO2zQyzdOWSjZHMFbGBt6xpbBEK79jZZEDpkuLwFsi/cB+gicZfG6/1r3YxSVPHNxeeRgUoAFB3JupToFj1nNP01IQyw5du8ANvOTyWPAyM8tZsKJGJbTkPxQRcWja4tTrA5Vn1iyyKCXE5q/z/iUWdFeOISi6oEu7etvKaEcFwTFJovgsP2clP3SGiJzkMzQcbdG6MdTAzHpUeZ9/fOuqBBXDK+8ljtoPlujDAczBGQwRlLOq1geQmRqO9p8FRZ/eH7kkp3xGC5cLckrs6q2lu/FLDvbului1Eozlr5iUHlNJPcsO5SUBF3xtMTcNelZfxkgm9JLMqDc07zdET36CoXg1FjaSmEwW8wj707bFsqoM3nVonD1cmkq7eGACLfjLKNDB9vEREESWkyXpBpBdR8n4ErSpjJIA0z0xmgPDx6cI4PrkzJkdd+9N4yX4TtybNmIT5tREmTkJ
 ulo25cV1
 V+dmvYIREzjBGL8xaHvgT7SaQauMuh1eIMWxgrR4j3VFBm4bB+aWL6/s3r3hgmSauP9y7bojNPMOHGulF3aRRziJt9XdWBaJoIgJIi7XxlJau/7eIBwWqzUTgAoTXA20S2Cz4CgQDdNC6cIwcmOKJKXc+yfDbhosO1eikxglG/NjeTfMJfR3Wk4gQWvWtDzH3MNYis7x+YUg2XjpxczRvpVWGagpT3ohLEtBeZUG6fKPtIaKXdDrvPwKB1RQIsuWd5o4VjwjqHUeGHqhsqL7P2j6Yq3iLnWf3341JCQq6JI6WS6M4cyMtGE4qpYXYEaZNtuFFCyRty0s9K1imzXkuZSMiAcDhRDQWCdNIbwXbghP2p4XSJ4lLFIO9FwPGf8rGgfc0Zrd+s//RIVEsNQ0Jree0Q+nyPH3WZq0MPxCxOD+kxlheiS9oB18KXH+yGEm6hnIfMSGgq4FqPT3Ola8Fw03vfEABV6oFgLHG3ZnaOoqPibQDpBiqg24bEBmrbcCmKqNM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 19:54:44 +0000, Samridh wrote:
> shmem_get_folio_gfp() clears a new folio before marking it uptodate.
> With init_on_alloc=1 the page allocator has already zeroed it, so the
> folio ends up being zeroed twice.
> 
> Skip the clear for a folio that was just allocated when
> user_alloc_needs_zeroing() says it is not needed, like anonymous memory
> does. Folios that are already in the page cache but not uptodate, such
> as those left by fallocate(), are still cleared, and so is every folio
> on CPUs with cache aliasing.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: shmem-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/shmem: avoid zeroing new folios twice with init_on_alloc=1
      https://git.kernel.org/mm/core/c/845e96bb

-- 
Cheers,

David


