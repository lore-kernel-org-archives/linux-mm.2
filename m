Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E86FD19511
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 01:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6BF6B0088; Mon, 26 Jan 2026 20:05:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84946B0089; Mon, 26 Jan 2026 20:05:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9909F6B008A; Mon, 26 Jan 2026 20:05:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 863D16B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:05:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 330868C8EC
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:05:18 +0000 (UTC)
X-FDA: 84375950316.26.54753E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 84DF41C0009
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:05:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CRClnG9C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769475916; a=rsa-sha256;
	cv=none;
	b=TN3VgTN5rbQ7RG8ah5u0nrXMIIIZLiHFLcPL9xBLSx1haBZOlar1++HK6GXPN8LgQxGUK9
	AbDgvoo7gcEYsMuGZR35bXulCiUidFrxXaH1mFFtifaUxEqJm3OiHvhM6B+0qWI/HsX/Cz
	rwF7u+3kudMPwexodl+fbjyhXIVC8eU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CRClnG9C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769475916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOj0BROxzwaog9zlQYEQ58p5a7z5Tp42pmT1p8vdl+E=;
	b=dNbB5+fOzx/qeo4ck/o75+Lk39aHiWRBI848kskR8ct8CUFa4d7TD6kRGtYDWOxq70J19R
	Wr3Az5FMTN8z89syK9VUnd7/336v04aRIsjImXsxRqyk/+heN2n105PBIutfzs9rnh4zw2
	xPk+1v1Iaa9duZuVyiSvvpGZBlkFK8w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69E7240303;
	Tue, 27 Jan 2026 01:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FBAC116C6;
	Tue, 27 Jan 2026 01:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769475915;
	bh=rO29DjrE0q+YajQotp2xI4GjU48ZmhPq+LJotmDhnhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRClnG9C2iGMauKAVmz+bwqCBlK0YFWPCW0O6LSl1hw7uE/YcZLy83W9jHGfoABne
	 tVt2RbgXgo7ZosUg00ExSgdp53C3QLQQ8Yn0vhvMazvAJzmXwN1M4+Wfl0h+kV/obn
	 o3Wub6w72ZKVT2jsVA22/5y9VuPFx4EFGZYALX3erSYx3ipB9XPWuU9zsG154OC00A
	 P9V69PGBT2EARBShjQog2PdqPo1lRV7sobyZiEga4MyiAU57T7CM6Clhp2eObpRdaQ
	 /HPjGZc4PlzI0fdhnh/WTz8B/SlErNnwp3WKAte8hbKYO9oet0g9Bb1m7fD0XqELrz
	 GB+RJRKd4nOTw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/cma: Replace snprintf with strscpy in cma_new_area
Date: Mon, 26 Jan 2026 17:05:10 -0800
Message-ID: <20260127010511.74604-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126165450.f83b1895deeda8e4332a57d3@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 84DF41C0009
X-Stat-Signature: kmeptskwfjsjqqu8azeeeic58muawdb1
X-HE-Tag: 1769475916-525878
X-HE-Meta: U2FsdGVkX186GPlhipV3zaY0fxwWQUtGLUYwLu15BrdXcrqjg3baUJWsId8MUVabcvRy+xODqzGKzM1YBGE0g0hj2VRX+n9ATGVBQuIDapmI/BFj6SPsUxC5/nhGUoWAGg5xQ3x3BZe7Czv9LdbCdhk+/5GgLu+KTcJyKgpBXG+tmY6Y+ioGRiC797lJZf8zjpPZUqgouQjGfYmToWWtY7ugligHWNyQAIqeLSuomaw/O6g15n5i/E6ljZAtN6I9t4am8+onmoBhrxXHmGqP1KTBQ6yB5Bb0pT3AkpoueWHm8tvqrys687yAlB+7MDzNfJBkwRh6CT2NwIKsM9foBjh/uXHCB2T7szOc9o/n/Wbaz4zEqh4iK/nq4pv1mgyypSWlEGmNe6dF09ds+D/LJyY8ruQkuEFxMKUl9BpVCNC0ZTVQIjGpx5s2yK4SsGJpcnBJQ1i8klr4LLJ7uVeVZaP/m/Xxgkbvlph3ZITmBc5Ij2HiZBwB0W/2HsM/3UYMqCmMGkoLaVxfbCPpnNde1ZajNfKFqJRxIaaLOcSv6mWPyA6sBEv7nWovRB9O7PBkLoQ0SNSDklPtJf2EhMtCSsGIlz8uQrEi+6VgyBeS2ps1d9D86FtOpLhmT8x/HlHgeUvQJGGnbLm1tKcskrivZJ0zFebTheswKS//hyBfOJ0ngrn5GNkE4xm1wxNgymkuxxPPQivtk9zLN47IauZ++mtoQKtEeTvQ3yq/ghK5glbKu50XzWIdvFtdZztAy62ydziPqB6UE9pxdpYfomykQTOwRmYAtUZq8/BJW4bHOd4X3tfbiTIhlzBBm/bkIklJSkEqHP1FuGDn/krd5w7q3tM3/sZuukxtK3Y0d34ZJWJwgHrRTZureQAkxAAgOGcpQEsWJZ+bBL16C6wfZ/RZj/J2wKy1iFho2PVW6uAdd3JYGnnqGH+zIO9gtaVS+BqFuZnTnLOAgyLx7ul9DAZ
 dk2W06H9
 xmuLHROxyUPkA+FoUr14Er+YzmT27ZbI78Ag5/jK3OIqyK1Ta3lVL6Vjr6gkY3o0fIQpVOLepeO/sVfAHmmgfW5+/nJjkaepWaSxhxya3OsbTwoUFgAY4xxoiWXQBanXxiJzHzH1eFzCx7cjjejS7xJZd2iA4h5CntyRyvOPaAb98uqVR6cIxgN79ZcNvJHxWzUvvIule40Z40C1pJDs/muGazGDVTYApNVFc5/Ze7UTjF99HR+uX1nuoTT2lSvPxMM7z0G4CY6GyuJxKkKUZWkseHNZfMZ8u05wd01pYqWhh2xn7gdLW7W12L82THcPFI5KkFiYH0yFDEFmapclf6rVQlGCcrKaZZdUwQGzXmutIEqyUx7EJYTtLvJ1u6cEaP4zj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 26 Jan 2026 16:54:50 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 26 Jan 2026 16:47:22 -0800 SeongJae Park <sj@kernel.org> wrote:
> 
> > > @@ -233,7 +234,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
> > >  	cma_area_count++;
> > >  
> > >  	if (name)
> > > -		snprintf(cma->name, CMA_MAX_NAME, "%s", name);
> > > +		strscpy(cma->name, name);
> > 
> > Any reason to drop CMA_MAX_NAME protection?  You can pass the size of
> > destination buffer as the third argument of strscpy().
> 
> strscpy() will now use sizeof(cma->name):
> 
> 	char name[CMA_MAX_NAME];

Ah, you're right.

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

