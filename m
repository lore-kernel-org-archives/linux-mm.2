Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F546C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E3A6B008C; Tue,  8 Sep 2026 11:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8986B0096; Tue,  8 Sep 2026 11:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990C16B0098; Tue,  8 Sep 2026 11:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 767256B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:13:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21F87160697
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:13:47 +0000 (UTC)
X-FDA: 85190939694.17.ABF7A4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 241EF20002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:13:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wR7AK51Koj2790EHQh5BWXLd+m/EBti1XNrlyU06RwQ=;
	b=eNGB8XPvrGlikjzcnOZKqGwFfCzldhIp+lrK7ohH+XNVYTU3Tk6630RP47HpfGtwSzVXPe
	nFVgSBpOJ9185fn6Q331UUkSS1DRSMaZ0skHREISnfgSOFjClWYwb3gZ9JAVy1x2I7QcKA
	b8eSCjcctRKLOAP4Mk81RhM6JOD7ixU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880425;
	b=3qpgVnpfzanFHxYBswLpQhICvWvXknoAXU3I77nHbYGCi2alY3ta9/jnT+H39TwR/dPXV2
	i/HPwlxjuUT9VHE7vVKsBV2uFaxr2C7Uy0tIO7PjvSCYNR9C4JO334hwnlV2Pte4sut3NP
	oHDYJe3a7hyLKaFx02/WhqX2Wur6HMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4299341312;
	Tue,  8 Sep 2026 15:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33981F00A3E;
	Tue,  8 Sep 2026 15:13:42 +0000 (UTC)
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 148E5198003A;
	Tue,  8 Sep 2026 11:13:36 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 08 Sep 2026 11:13:40 -0400
X-ME-Sender: <xms:HyagamyqoJnb88x48ecjkqXIGmM6yEPbqcGAYIx6iVL5eDsaFQ3LXg>
    <xme:HyagajG8MXmdDl842GDAgIOTSD2UmzbGyztgBLHHurHcZuZAVYUq6Q8bQZKacXeb-
    eOA9dEa4-_4bWGajdhDWV1wzzrppGYA3mJ0NsJmpPMvxMpO20tiBw0o>
X-ME-Received: <xmr:Hyagam5nteqcoy7k3LNYIAwEhcE8zbEcVBK266qlXyk6xispleaxc2_Ic0I>
X-ME-Proxy-Cause: dmFkZTESaxOuzeIzUb7pYu/ajwm5NhNWJYdY2isfBcty34gtQ6Pwe+s4eEC1fJrhTAlDdO
    FjHnzt6qt8+lAGUIIoPiYqmucaikse38hNpvmfclkQ80xpW1bz1B30mB0R/gPss+tUZhCD
    dhlSJbVDLxGJlVWEFFoHyV57MZKVealYI5QxIkjMaKYg9eaVh6DWitRUuM5e0wRcG0OHeG
    zj34sza7Zd3kMEhvxdadwjuKuw8pk1EJDD/ELYCgoQxtsBMhKj7FU0km8PGhMhBTCGdNen
    Yj8GNb/r0sex81mZbbJKFkA/4KEG++Z2tEyS42TvV65pyKzDLV5wGiwZtsazgv+shkl0Ez
    vD1666cLVIAatJJTiVDaGSSplaVseKmtZxnqOWv+WihLIXEAddihbrJoOQw8MWuXcIkms1
    vwgmqr4l7mJwVBNt4D3VrLoZftcH7pD5Vxb9ZbUrzN06dTd9rc2RtjQZlWWYwVD1qntiSX
    WpxgwU/E9i3kZNx2brxAFOwvYigokqVdWF624PLRY7W8YlsMhGaBNo6zRrdWXwPI1rA0wi
    fAHQQe875AGKOTamckeSDNCBjTIE99/cwvgvqKHrjsCA3y96T5D8kSc0hREhJYaFzKxcPS
    ftzg4B7ziesyDeXJRLDKkDSPxL36vszm6QxrTgnHI/lsRtTz0gp4GsJy672Q
X-ME-Proxy: <xmx:HyagaiUKGxmPD6t5weSMBzxOf6-h11xtoqJ321MFpRui5xu7zQW3pQ>
    <xmx:HyagajJx8XhYdV-4vcrM4l5NrRks7bXuSu3SekOy98rBAuy5kdbQ2g>
    <xmx:HyagaiQPf5dRCXNmY0V2nmS699ezPx_74Wcfwc19n51-2IAgK8lNVA>
    <xmx:HyagamD6V60CMTJcpSLgMb0mBXzAOHC3_qHoVoLsY6vXfRX4PIDprg>
    <xmx:Hyagao_SsIhbBnUnFa4Tg9b8SRmV-MvY5AWx9WynStj1LITq2diUMZrp>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 11:13:34 -0400 (EDT)
Date: Tue, 8 Sep 2026 16:13:33 +0100
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
Subject: Re: [PATCH v4 08/17] mm/huge_memory: move unmap and remap into the
 split helpers
Message-ID: <aqAmD9C1Y31F6ByT@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-8-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-8-b532a3f20e71@tencent.com>
X-Rspam-User: 
X-Stat-Signature: upw6wa641bwyuiuate5chcsdy16ugi1o
X-Rspamd-Queue-Id: 241EF20002
X-Rspamd-Server: rspam07
X-HE-Tag: 1788880424-369272
X-HE-Meta: U2FsdGVkX1/6FKq3Umffi5Jre412Ij1mAI5S7FDoC2Kx2qU3/mR10u/6VsU+icZeQ+a/MKtiLlQSm3aZ77++LSFEJLvMDyZnskgxUVwF5ZRuqlBFo5OyaT0JKs6wOqBVeYi1IrpZUnxQMd0hn3IFx2AQYu2K9uxs9MvlVhzO+OriQ/sQCsdBNUzkg5ciBR25nCcCqYYjbORYHeAxfJqjW3FvuclCCBxkfoMJyTkb3qqdkNL7Nxe8wR3mbUE1jXZM5REmxMOQmujYnyqe0SweQ2TtyzOafxdhIRijC9Q9TE7C4LDhQ4rgS/fBqQl5kmvHvFwLMybQOKzKwO5HNCQgckBTGVyqENaTx5gQltzsXdZRsDwFbB35p1qdNVuB6gprREQ4hkZmeFkpcc/T06RJYgm0OMbuujFssSNPuEXARtUDuZy1EApzaAFoMxl5hj26kzPKKKeIyhoQj8nrASdpq9FgoIVnIsQq0czjk507gMBWBkArqFlWwljKC4u7FMn8Jw65Ds0pxbRB6h3B16B9qoypr2Kdt9Ohd5cGYiUBRMAP8QhAOG3lMWIotcmgTjMn+uj6mbiDM1mI3TpU2C3T1ajdxJl5aj8iGc6acucXzV+0GHNKXKkqz+rGAsNeL1mDkR1hPxlkeBgesaOpkS6uYsdljcs2VFI3wzoLwruQVTSjp9BKYMZwvB5rKsIBhLnBqw6qrQfL/ZixNs3cVb2O6MEc16QKdvFNbQlPWTZUM7nBvL7FsbflAJPpHwLNlwsD5T79xz7tNz4Bg+BaFh2xEhTWdFkEh5ed06si3L7cwVo5b3qhQJlIWzdJ754RSqSN/iAV8uCtzBeM9YmfQq9Bm8nckOPwN0Ztr72h85L5H15oWy8Yziy025yNRmlfkBDEzC1M8DE38OlGBFxrFSAG5NJmuuWimzQVg3lnntsMdVPyDQt2j1Cd0Vo2re2nJMjws0VmEQYefOB9kFEzYfb
 bOAKBMG9
 /exYnjptBie1NVLRw+mMPOTYw+arjoUtXn4PnrUN4G1JZ7faxLCTxqVug0BW6QYDUxpJmOvrS2Nf3VnBJilCwSNhgdyn5npSfRg+F9qnKkKjWtZTZ1WqVNkaU1Dexv0NMMFTyU9SJKiCmQ22oHcWWk3XUel7oIke+zCNW19VR5RhT3x+BBgDSdIl+cjA5ROXlm7czxW7b7SSaOWU+Ae9Cn9yUalJO7MwiV6A8gtL9tm638n9MYezsrDGqb4dNbeyvY3HyCa3DbfRqmTXFzegashv+LGNBggQGApLVqaHKrpBzYgIUoNGoG0R5WDlNspgdtW2rRCsNcH3hT65AWZFpUZdhmWTSvIFz6029
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:12AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> To prepare for further cleanup, move the unmap/remap handling from
> __folio_split() into the split helpers.  Only anon folios need to
> be remapped, so remap_page() is now only called for anon splits and
> the anon check in remap_page() is redundant and can be removed.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

