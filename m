Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F9BC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2B36B0092; Tue,  8 Sep 2026 11:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863696B0093; Tue,  8 Sep 2026 11:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A776B0098; Tue,  8 Sep 2026 11:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52F186B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:20:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAEC1405A2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:20:37 +0000 (UTC)
X-FDA: 85190956914.12.4F184AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 103E080002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:20:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXLezJjO;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880836;
	b=twijua5hE+kUxp5tN780i5uMnEAKkCexrz3SGIjzHOVzT4IMrCUUEiP6eTy8wk2GJOe0dL
	eceGERVW6UR/dk0iO2wf9pO5mStxjoDhX8th9VJ4KSmAM20dymcV3z92RWuiFbIOCOh5i2
	UgFqRpdKJCoGUFErqz38o4+PtzALMZY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXLezJjO;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9GvPvkVH3GDsSf88CO+swazKNMR30SF4MGfbbOxMsg=;
	b=Aq/A3qgTBPF5Xkrcw5Hqj4kXtG6zgSVJ2hGd1KWvRR4a+H8c+Vz0VJEnjMtz3+nWkjFYli
	Aek73OeAQAGH/CQc5yG5HwLKR0OXtmRLVSpkpQ3H2bsMUK416YzrtnHDeB6iEuHTw0WarR
	qXXOkGlXc99L3fQUO8HB5aSBUbzj3Js=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98308601F6;
	Tue,  8 Sep 2026 15:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D051F00A3D;
	Tue,  8 Sep 2026 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788880835;
	bh=N9GvPvkVH3GDsSf88CO+swazKNMR30SF4MGfbbOxMsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fXLezJjOJZU2xOqaYilaey23hYGIg30QgBtFuUaHaP7rsIS9jTOQrC7xfGoyOYW2q
	 JDCfHViLuQSaYWnpNaa3VXnriaYTghhEmXlvfLiRIQpHFXHXM4BvsfUnLYON86H6/k
	 gNjDNmA5x2GfF3HurReH5TsX+VR8m5CFTH3LvU85WWfPut6+Mc+FkcF4vozlOV0Iyu
	 KmyF42nbnWEXvuhBSVrEIRbTfRg0+BTjLm0In4a8DH4oiQB8d1nOvsdrpBs3vUvfkU
	 Mzo3rgHyIMGmMgm50ycFzwhRlHbqSP9grEZ5yH+Vueb0rRqaPfWSHLxW1RUe1oUXb6
	 XfV3LH83L/MWg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 1DCD7198003A;
	Tue,  8 Sep 2026 11:20:28 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 08 Sep 2026 11:20:32 -0400
X-ME-Sender: <xms:uyegauxEEq-mne6_XVEOHQbgLXut_W967BtOls1pPJELKluGLma1Vg>
    <xme:uyegatVriC0Inyjjkxo4cvMO-pFVMof3RvZGXNY_Qfq5mqLgg-Z7iqUXfntBS5gY-
    BLsCDvNpCMrUJ-1UKvWmWlWrlagaYimWsNjZX1X0t8CkW1PpnT6-Ram>
X-ME-Received: <xmr:uyegauZrbwVW3dmj-XKNLRpkBwt668-SxqbPjoLn1ZbimgtNoA1DF_isq3s>
X-ME-Proxy-Cause: dmFkZTElbzIz+CfUVvzCuvF1pU8/u78Ji6LGJRtMTGPjQOKbznP2ORd8FuwUSaZKzrvUt9
    yZMYsil1uc/6jaD1bfzKeYKBJWZrme8oP22eTYcOGSdVZx7Aj0reqoh4grxRrpUNNK5VE/
    E71KQ66nC6B8eLozDhntnTWlIjOW4JG0cZt4DHeu5SvqbRZ/l/w48i4B/Afjmf6bmXeBtr
    z/X2dLovtapsaXGceUPw1fKwfRMr1WtS9KFTneXL2TeMr0kHg9giArdCsujpkyhilayw1L
    owjKVpVtYtB37YB0WzYJJL/sg/vVq3dAc4g7nJJ0fiVhJk2S4e9u/Hvq6YOb/X48ZK7bX4
    38v/CQuxP+hdhQBicshC0KO9n1LUDSKUhohpctYYBt3dZUFgwiOaszPe6d5LUBViFplI6U
    SzvUhiFxm8iSsF9bxvjprH6HLs9cskh1C2256A9edtwdUxoUzXnmYEyomhSV/7DYykFKXA
    rk/mGs0+ItGnb/RRrWi/YvuIAJGtWZIo7HkTwiz8H2G4YziOgoFfd0pLjGihNXHqq5gH0N
    TYjbo4MiSJEo/agStiyifBlfy/b5Ap7aKaDQwJ7UUFwPbhwLfeM58epJn8zoIK/n+hRXBX
    v+Sgf1iYJF6ulyJFMuBCpjGmi3mhIxrdiiP4FTmroJvwJyUC8QVrIgJJQJrg
X-ME-Proxy: <xmx:uyegan_Vsf3U4OQcfy9MMjFz-weNyJy4uZ6lxiDA1S_xgN1_tIeIMg>
    <xmx:uyegamItJS88MCop4rsksYAuBlRCpXxftt_ewD70Vw_dFXGQ0OyvKA>
    <xmx:uyegaitAJ1nHj5SjPxgCAoNvDgHdBLO7RCMQe6WJYblNmAtAh-ZqiQ>
    <xmx:uyegainl5yEV6Mp5zVrBjRWG6sM9CpBqwhPnFu_6md0M1JOG6ktyDg>
    <xmx:uyegaoGY3255JDybxHeTA0CgbpinxvUZAe4a9zTlKcpztoavoG6iYCSg>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 11:20:26 -0400 (EDT)
Date: Tue, 8 Sep 2026 16:20:25 +0100
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
Subject: Re: [PATCH v4 10/17] mm/huge_memory: move the racy refcount check
 into unmap_folio()
Message-ID: <aqAnXgXPFcP76y9o@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-10-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-10-b532a3f20e71@tencent.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 103E080002
X-Rspam-User: 
X-Stat-Signature: nhsuckffziafwmsdwzxoi9dt4knxr491
X-HE-Tag: 1788880835-439838
X-HE-Meta: U2FsdGVkX18AOTAcG1gNq4tFYjndVHCE8CiAcsIenhEarPJmvJLF46/tcHZMsZ/7cZK3+W1UHePj7/Jo9CZgI8moNAGkL0QKocJI+NhdQGro/kCn3mRqyIvOrowh+pPR8RB87BerQG8KgTlbmrWGzjj8mr4cwR7GJTZ1JPM9f4tVlkic2ZX9Z7CsyVQFT+MlDQBedHcyN24d9lqVxcbbLD14UHSEQODKxrBzekGIvZ8zMgWjexvjhnmKI3rmsqFeXGnBwiIOZcCzhADEHxDRfRCUuE56ugcbx1jw0x4bq47n3uKQ/MRdz/O0q6hl8+GKOk+ap+kyX5LF4xkNOjlSzUOvu8TInNgDzUdluDxjlNVHYaEo5rgNBUG3ZNgXxyJJ3L4Dj+b3p1U6rfRiMU7r0NtGlek92sp1zfYJQn4EpvAfsiUvHqGLX6LzkhmIGVeqiERZ33rrDIOoM3BiYfD/DYgADpz181RbV68ys/hGi+esNv8jTUcVKrqnE7uuUudi/C4NSXk0tTh5c6rwhgc2qkQ8MkYd6RPxueJpvKfl6YdEH6VyX/8hWMpiUiyP3Lwa82d46lxOwhyF9a6ZIxnPocHBeUB7uYpl96+kO7N45Uo3+lOeFJKwPwcQqPPb9XyfKnROU0c6s/6ys5MrVwqKNJNk/11hvQRaUmTWMoVHvbxfYGZsmDeTpLiJzRgJUjD5U/luoyzNGSsV4JHBOWlNb3CyfaZJ/fue4rFNjcj6xJS2x95H4215BpAxacTUj01eG8iQCBLZ7DnIPwcPs73b9qDM/26UBsWgGrfvjESRQm7Arq3Pd/nILJ/TXxrvhvqIAOM/mQviHWKuwlXXrOtyYj75Dg1ocDpOzO82ko1iwFHowvq1J7gLkjMJ6T+S+1B0rAZemON94Bkz4kzxeh90C80OhDeidL31QUdwcoVzUImsiuYEX9uWna3YhZkBzvQY+6/uE526M7T82pE9H9F
 hPQpia+B
 auPkxwPmEa7wvp/NW6n02Ym/Y91eMiH8OwYA+bTiiqNrRlfQOWqV3pesZacW3sgPn8ubQn8QHbLPvpu3K7W8L0Ld0T2p19AGmEDIiQ+Jm1mJTEfoq8u4dCEl1PnPGTwMtT6SGErZVbX/Dtg9ZbAXcGQlKIfvCX+92kdEVg9dQDKJ8QkVLAaWSGsxGBURDF/fOUPkuIzFgw/2qr9rf6eWYvsCYpidmCpNmCdg4g24gK6WhDqs817YoY8Ah73mDw4sGrHu9EQBRliWuY+qCs1AfGb7eK4Xv/q16Qax99NRmD1O43M3vTiwnxMu9uVluqf4nPxfZq/BHFRu27B0kNcXuq8HlQU7MhPtPLDrkbOTkwhiE7CjiOlwwHGpW3QZVKxP8YLbY1pcTXN8a+wQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:14AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The check only exists to avoid the expensive PMD-splitting unmap of a
> folio that cannot be split anyway.  Move it from __folio_split() into
> unmap_folio(), right before the PMD split, so both the anon and file
> split helpers get the early check without repeating it.
> 
> unmap_folio() now returns -EAGAIN if the check fails and the split
> helpers propagate the error.  folio_split_unmapped() drops its own
> copy of the check: it works on already unmapped folios and the
> definitive folio_ref_freeze() in __folio_freeze_split_anon() still
> catches unexpected references.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

