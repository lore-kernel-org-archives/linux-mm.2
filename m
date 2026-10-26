Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA11606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=o0BKoQCE;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Kz0s54/5
Received: by kanga.kvack.org (Postfix)
	id 924186B05B1; Mon, 26 Oct 2026 11:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4FB6B05B3; Mon, 26 Oct 2026 11:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B8B6B05B4; Mon, 26 Oct 2026 11:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0D56B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:52:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1F971C40EE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:52:17 +0000 (UTC)
X-FDA: 85365219114.14.5C98584
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf27.hostedemail.com (Postfix) with ESMTP id A1C6F40007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:52:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="o 0BKoQC";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Kz0s54/5";
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793029935;
	b=TlV4ecTHwRDEqfaQepxMhdxi5A4PM75WCxeNQFWnCj5wf4rzgKGA4WG2AKLD0eqXJDqLPn
	vPUpsw6Pp60acbdZP/k6RpORD//un6P0mxpPgA1T6tlb+XBD8ZUh/DJOF+nhXVOIkMBEDG
	dOYCIGEW1SX0cDcpw9vRBD+WSpOucf8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="o 0BKoQC";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Kz0s54/5";
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793029935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPgBc4xaMzIFqQc4IC3B48/bd19HMe5+87bnM/Zq9yc=;
	b=A6gCKAOMkj3cLzM7XKXmza2gzmmfz7h0GExH1nyx+iWWUg/4ftjS0DgcURnXjPQ2xYpx45
	zxG9DAg8zW8BNRq8nhWNe8oXxuqaegLUtN6aGuZ2a2j2epL8LL3EEWyr0dKiyi6KJsCqEr
	u8wcazGiSqEspvcoH4f/ZbIpGDUvL4A=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 49C4613801EF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:52:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 26 Oct 2026 11:52:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793029934; x=
	1793037134; bh=CPgBc4xaMzIFqQc4IC3B48/bd19HMe5+87bnM/Zq9yc=; b=o
	0BKoQCEo3nSrcyVCxtJP1KJxl/yw5aVebOquu+la35y5fz9jh9W0wIbsccWPZOtw
	lPv0PfFhRS36jmErd0kS3aCFrWXSr6hBe03n1budn0uiDaaykqK2f/fDwglTEM0t
	PwRTOZut60Q9SQoxlkepYalWady5fZJfrJlIjjlj/ouTkGyII3DFnbBLlyiSIgvV
	HHQgPvG5QWRfaHVffWOinWQo4RxSsggAVN06fL9rqytCyZKaVtvisskLTe6pRuZU
	qcGSazzOT/ln+dhx15bgJEhjQlIkGf0AuMAgwSAlVOy34OCMk1Wg6x87uYKnqG5c
	x7vr6szoyhJTqwIVnvqvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793029934; x=1793037134; bh=CPgBc4xaMzIFqQc4IC3B48/bd19HMe5+87b
	nM/Zq9yc=; b=Kz0s54/5iJjqL/Hh3p2OtVE9uLiC6AN79waFcNg2he6mabZvfnm
	n0XWxAimat+vJBiSn8Jmd3iLewQGdKw47wOJnPMQDOdSKl/xZ15jrFiCga3kHtfL
	M6gAB6obdV0GQEymXG0DOWwQhKGTeNNAuPSqWN78l1t4UbPSAIJWNnwkiJJQ4YTr
	tIBJTJTkj9DwvnS19J2+X0k9gt3dbElymBO/yct7zQlUPVlLMAo706mTvH2cOUwO
	jmuESzMcfXZ1yXG1biavNgJK7DU4hfnaioqEiCZ1ifmblUbrCkMy3YXTK/JkGVlH
	erWJcKTsyKCkg2+QATFWk/r4KG4nH6Soaww==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793029934; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:MZ6m+TiddOzzM0gBrjKaFGknpR8RjFRbT+6lQL+VoslV0ut
	LutfH/lY6NtYiPKGaLMzxnXnUje4yYgexoU+DZaGBg9HHCERxf7D383GY2IdH3WA
	JI0L8I/j8z6ZvR3aU14CdxVjvZlCmCe5dBRLdXfHWsbG0bsSCbASlyAcm5Un/DAa
	sp4agPGIphKra88coRhyvCjUYdyNMHW2WPsp6g+7uOJlERXC9NxV/b6iDzBCZVvw
	auK1RV4NcLUUaf2BT45zae0hTADuVTgcQy8MqH/9U+4zVcx6XwpjyHbGu8kF9X4Q
	8P47mnVvUrdDKEvyReti6xa+o+fMTcPDbH6h0Dw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:TSptQC+uPMW58EhXC2TW+E5AzwHwIj0iAaNeMtqyI1A=:5YQRYL/pXslXA49efxXcFJfhlbdrgkaeNfpXN03LNGc=;
X-ME-Sender: <xms:K3ffahXllY81gQANBHMWb7ApPzS4XFdgRPGgmQsQBZqVrOI-rfCLvA>
    <xme:K3ffaoS4f-N2KBXy0sO2JKuIUYhwMZ9jSMURIQtPmKJaFiuHdBHnUX2StJGa_IL5L
    8A0YepPvhed_5e-_CoeEJI8vqWAoNyRTn1Ki4XBNBlLzi4HYd5E7io>
X-ME-Received: <xmr:K3ffann2o7DU9q1N8a1-EiSkbdymdeOHlv95OV7smwUBwfgkxPDQN5Osb3Y>
X-ME-Proxy-Cause: dmFkZTEkSluo7FEz7n1qY7QYOfbn0owFYeZY5oOq3jGyfhvPnNpVEknLvAeGR1+iGM3syA
    9KIyaf94wEd0nEJHg2+khnrAfvqxgujFfy94I/ENHCdc0906l3qTkFhAemCDZZtRoxQBpm
    ISOWhrDqbIIdQD/XOE0Efd3BZFKX5jwo5O5BVQet0MVPWPwjx/89wQFabKcqsb87E2zGhQ
    AhHs9zIIZ+GdDFr2ga3NpUuXWeHL9qnhJdz8bu55mbEWD3a9HPXRp+Z1vqFAzmuJVpG86o
    jDvHzSpOLflmtoY1U6+79dpdUBqHq75y5KpZ9OM97P7mgyK/gICBKBi13o7qY++ND5OLLr
    YZTLwIugW9gTdbWrpRzW1DUeaLESRpM8rozbGIb7htDEohjfWM6G0235tRBvr5Lq4T46p6
    Hy1JiSS0d+flJ3EyLB1tHFF6xqKs4XcGDrliXW8nyDab27YUhPkoMSrRX0Q28XOlGmGwKk
    qhM8mFIJrU5PxpeECU37qyJkils1hwny+zsf1IpG52mzKP1ds/hxmicboQ7qzWJxQ8S3+0
    Pv4PtDi3sLD+barIJSVFqqNfykQ7mAowqBqY6pOX02pWMz74t/xkVx+6Bx4Ok7znZcyAV+
    GJ2hnpW15TnIYQHZYc3bCOWkqiZotgTDwAtJEqKb1lbgbzxXsZhL1SoYbGuA
X-ME-Proxy: <xmx:K3ffak_F0cERTHmcQXmxXAI7UweRjo5_rxdsq5rs3fPxmQdpTENHJQ>
    <xmx:LHffavWFQzi_x4edbTi0is-2e57xE3DOZA6BYkc4e8CjvbhJ8LLUBA>
    <xmx:LHffauT4MRVbf9U50mVFfA6bl6K-ealI_VMKfGYJUT-sh9uJVp8T6w>
    <xmx:LHffav0lwvfFc7HeGCdTdI6O7GaLWe95hMP8ont6HY_mJQ1JZHKKfw>
    <xmx:LnffaozOOq9MK8xz-qfmkdgz7WlkK1yxG60yntUXhVC7MpPc-gw5b-C0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 11:52:10 -0400 (EDT)
Date: Mon, 26 Oct 2026 15:52:09 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 04/16] mm/shmem: honour F_SEAL_EXEC when an ACL is set
Message-ID: <at93HVbtV34eDnOM@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-4-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-4-703206d5fa0c@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A1C6F40007
X-Stat-Signature: qsx5khyk46ehwu9h3ztugxrehyhx138k
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793029935-501452
X-HE-Meta: U2FsdGVkX1//AgDJWiwbyDK5C2pJ3Fpvpbs/m3G4T2ggRcsZw0XsM0f5la99T2ev5KzSdkoC8GVgsrSwp+l0nGX46Y5pWZf6x95oj/xjhj72CaezlajgyAoDIYCVwphzGehCxOcVfWHwPBwVyY0qEMS60qp4U+XDJ0F0+z9CsHX+54ZJ7i2OfGDa7AEGLVqiJQ/gJ17tw0i+4rzWRC5HpZiysZcrN2b9ygHdb0Y6q78YEeKy//dW3mI7BIcfGUOM74eVu9fVQDP0DmqbFTebG39YeASfESYDuGCy90yVUVVG5uGoMzeTbwxmb5+7Ee4pr9AQIV+MwSPcpziDupFtxOkymv2i2V9S+A78Vk1vL0hoOG1vTF8E8r/PIRmC6dPCKTzVjAsfjn/xq5Evb4rLR1RrutqK5E6o3SQ6XPYl0TAwSb2PH0Uk+Ydv8CyKtjgI7BI8thOrokdZuSTQeqFV4WYBWnNmFvxiqxrbuflcUY+Yt5yIdLJ8FPMfwO+TO2olAwuxkDRDK0S7W9Btfp4dlnaHiDmzTcZUhsL+55/ShLHmNu8FO3SiAMMiXweswK3/VlEXR5qL34VtBZEe6ktbWwh7YaHujT7qScNOwM9VNNj19Mhnt4m/QZ+VXo3hmFlybOR/SCvWi899HMwfokcFqk8ScPSoTuJ3ctKqv4zBAB1h7uIFi1g0pR4c0AzqkKuaMwlD4+VyxZ/pA+C2ZshW+m0J80R2f2R5+IVcCuwDI5DWnSzSCAHfRrcpfbn+KkFWKMkX5aMWmdJctTyPNX2b3HqLvRBmg+Dz2jcshmFa5drPjwHIzUv+TFZQXkKwZxkhbMOU++ZUpTn1ngcXCQuEGanyQ9Ygayphai1Xwq6Ox2j+ct9cIPIVKf0BmDYtdajjZ8pdkVcGWdDasi98JQhL6aoMphP1tih0LQEyIq5ABxC/yty8BIjHaLQ5/6IOKP5U9Rr3FULaRKPPJz9Bo9w
 R0HV3rcE
 TP3UAd0mmgQ11ckvZ/Jam2kay2Gz+Bmf8ZzSxAuIJXipoT2roAlmgiTuAQ+VIk3nCJG7RApGA+d24Q/Hs9ts49N5aTgR3Fcl5hxIGfqMoS4291IupCxAOOx2EtFFxdHS778YTe2J60ZKPiPce1bowg9NHQMpK7DxSDrHEcGhVUKfg+Rkb9fzr6etCkIGMASgFOmMuvs+CP/omMZpob0bkHLFcH432CpoCeEk1Y+UY5PWMoe8HmEhkjSZIqM4wI4l4Grl41KorFgYBhQKjvtvpurOVfcjYd/gMm/1jl3fHcjoOz96mw+GtItx5/TzedFz9kTdEhVW9PDUhK3UMC0Gk4BeO1qzujSeWqlzI2rkLrb01FerMkBmJYAguIIz+EWDAt+/TnJaJMHcOLPn6g4CaPGM8rgEDOLBxhQTFzYmBJScaPEjkiS5KIe47Skk8c67xyjXUEOgqO4DndAcNC9kE3lR6up3+Z2EIXBSOK6ZK4MbXfmGx0USyXzqCrPKEnmN9LHmyHOM2WefQwROyspQIzHV45f0gYFFv57QE2TeZaNLHX1O8TXrdQ3f/nuxxW2gAPHTL0v09zUNK4EXYLNxFEwXs0YCGpphQ5aXBY3BUfSQjuaPAO+N6xCcp/aXyvBzNBfpbwXzFrI9LwtNelc6wniMn3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:37AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> The owner of a memfd sealed with F_SEAL_EXEC can still change its
> execute bits by setting a POSIX access ACL. With CONFIG_TMPFS_POSIX_ACL,
> this lets an unprivileged owner make a non-executable memfd executable,
> bypassing vm.memfd_noexec=2.
> 
> simple_set_acl() updates i_mode directly, bypassing the seal check in
> shmem_setattr(). Add shmem_set_acl() to check the resulting mode. Share
> the F_SEAL_EXEC check with shmem_setattr() using memfd_check_seals_mode()
> in include/linux/memfd.h.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: use common helper; simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

