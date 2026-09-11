Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F199DC88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63576B008A; Fri, 11 Sep 2026 07:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15526B008C; Fri, 11 Sep 2026 07:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A466B0093; Fri, 11 Sep 2026 07:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A194B6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:37:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90405A01D3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:37:40 +0000 (UTC)
X-FDA: 85201281480.09.8D80A88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9877BC000F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:37:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRQ0sIya;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789126658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DRHhpyoB1R8bQIC+7BlAFBsbvzgtyAVS++HtAjVYL4=;
	b=DlgLOrDY22DYKRwy8MwDj2qlE8lN8KLk3u4xvqpL/vwJuZbF4MaMQC9PSthazaD2P1+d2c
	imvtY7SVVJ2YsNjDD57U4i0iwQO29c4Qw7xPsdYWnCYIA69BOdAt1R6ErLEL2jbCekseBG
	VSj+yNTzJTAaFo0ZKqEjdPgiLO7RwI0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789126658;
	b=EClZilhk8VyQ3MIkwiVfVyFiystZUGW/YOHhOs+k1BNARWGGOvDVG3UkevNTMNRwMC9GNP
	b15xvL1O5zZzaMmuu8K9g/9KnNy1oNk5N1Jxom8ABlXX5veTfp08Q3z4qixM/lkcVpXDit
	Y1CCf6rImnKGI6RGTJ97jWRMuvzKUJI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRQ0sIya;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B32F343B08;
	Fri, 11 Sep 2026 11:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459981F00893;
	Fri, 11 Sep 2026 11:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789126657;
	bh=3DRHhpyoB1R8bQIC+7BlAFBsbvzgtyAVS++HtAjVYL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dRQ0sIyai34LCeHnUWuiUX1t1aC6QE1YU3xggfrUWoURLhWaDrFxX+AOJGLVqsLJS
	 xq73Ad2cJtyLLy2QW6SK/K8QxTKv4obi/jAZrCSU8WHAQiMGBKrdHf1jGERnxaqhQy
	 NvXKyiGOrrf/beRa6jMxVBKnO+CUav3iH4yG4gj97kwekJhmoKPLMOZsFgvtf0lDjT
	 2Eo6/KvtRL5PR9T6HMNbIAGGeN97AeNEZo6nq2CENA6ITyY+IHW60QQnnwUezgX05W
	 WzcP0QjAQi0f0i65uvfnGk7b+9gUYT9cKhIIj59jITbUEzyOmo4NOTFpr8WRYAxzo4
	 HiiDh1PRKeWVA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6D95B198004A;
	Fri, 11 Sep 2026 07:37:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 11 Sep 2026 07:37:34 -0400
X-ME-Sender: <xms:--ejarEH55EddnsXiqqcRZYvFjt_2oYqQsnxjvwIhTCga9GFzKtbPQ>
    <xme:--ejagFA-fRlKLNJernfVJTFceqhRqrzTJd5MVH6CDrbc2gRtVkW6UhEtJ--1_hHq
    KgjVPxqOF39OvAHLgQ6HA8aLIIedBKW2iFRdOK9SiKuMzPT3-pDbo5J>
X-ME-Received: <xmr:--ejartM___lAp6Hc-SIItsSd0eg__a6HbxBHGMsdjvj0RSqwd300d0Ih-c>
X-ME-Proxy-Cause: dmFkZTE/zAf8Eqs/ndUqLcBqL/f9LIcLkpHSzGya1sJptSh2JASXbVwHmEtK6miNJBR5q7
    vh/t9PwhueUdJg+9DdeHwWFuj4TfSez5bsVhyfghEUgUD7pRvoWwmNsIcr6ziBlTSI4iF2
    g0qkJKh9dwff3aqdXGbIVPM0m5uoKacb5qDThBFo+jf2kGnFzQw9RGXaoJy5KGBKFrbiN4
    AIpXWdxFUwZCt3l5EDA8+AAI9yrcLcIH9Np3Va50mr3n5OKd8GUfE5n2tz+vfEVbC+kZjs
    X9lXTLT6bSxmjga4JVt8544pBpiSA9YahEsFT+FdHzZw/uhe2zkTFeVk81jR5UO5TZ2Hqc
    s4Qb7gk/zAH/lm0QM2Xw9Q4mnBhYbRTSBLY5lGtsi0JjZ/m/78/wc+Kq/IDpUu3N87SVfH
    OitSbfjUIi+P5qO2PXO9hFId/VTzZNKxN6aA0S1zs0zCK4kMXV1LjO9HZ5gabMUSYxMY0J
    ETaYihn5jaqoF2mxMyFnxcPUIWj87jutHJRCe7ukgybgnUD5vp4FOLKfDwRjoZbhomoa8V
    Tg6CFWLVT2vAp2XOyU2bYrUp6FMkh1u14Q8giIMvmAZ1kZWDpvm74z6v9wmEzIPP5A333p
    eeaRutzQ2ihM8ECb2pzveLA+IjcRcZcPOI7vSusnuLJeRojP2X9Q1WLeFttg
X-ME-Proxy: <xmx:--ejajavmj7WCUkdMGkaHhYqiOLxncFt9yqq9HiTdFHUYxEApzSrvQ>
    <xmx:--ejalPJz4YLQU_tqADyw2S33awwp6r93XPGY0g-JbjBRtHP2G73MA>
    <xmx:--ejaotTUOnj2FgoV53VzBFX5n5YM-aG7SvGJvPHhas_JEzTrInviQ>
    <xmx:--ejatKjKz6--kuffZ9VGVE_h1wiVxkqfuRtq1WX011-ge2KuyGv_A>
    <xmx:_OejapkC-hTj6IIE3BBboypLtLMadSQzWcPSg4OtS4fPMoBQLSv4x1bz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 11 Sep 2026 07:37:31 -0400 (EDT)
Date: Fri, 11 Sep 2026 12:37:30 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, david@kernel.org, 
	ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: shmem: ignore sysfs configs for shmem forced collapse
Message-ID: <aqPmxRkJokRyVzdU@thinkstation>
References: <b1829ac0d3f38217f031854ff0f40abef614ac0d.1789098446.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1829ac0d3f38217f031854ff0f40abef614ac0d.1789098446.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9877BC000F
X-Stat-Signature: 33aerdmp5346hm516rnh6u5y5ztc9cjr
X-HE-Tag: 1789126658-357548
X-HE-Meta: U2FsdGVkX1+2uuTylqNF8m62wX4wBb+zc9xDUvuIbAeQJfq03N/zBAaaDn9ELDpxgwadrf0Boi+WRENFryBJGiPpesX7qVNKq1N7c0xz4yROvJPQUiKgaqyTTZYXHM/jxN+84xwHqcLdyFSvetR4b/K9lCwt2x170YLQ1XtE79jEngvMIyBDcw4hOnJ9tkFGAI8fr6ENhhzCeh2CBtTzP9D41Gn589HUx8ijgtJFsxYimpH0acht/NJteio5OoQjWafp7kRyTJknuglRoV9IPfXRU0qJIlcneCfi7jJab060M1C86m8JkGW66mZS6OOTq5jfY7dRg0CvC5/rhmQMsdywofRKFht4tl/XbQWF/Uafj9weeLvK/wBIxkbRjBaTWOJAErF4Ce2GSUmktQbvLTHvIGm8LnW7bi1UQ2RQAer4M4x9t6KtUiAZEFPeQv1FP0CoH3Hr5PKP+mpy5RrvYl4Iaf3VUXLuRau3Zr6PvOrSYY3E9Wfv6A9I+lsde466DrdJHG2NQx0IY+JOCZw/seuD7wZOTJo1VafcKLSqgHu9EVQNhHAk28Ue5OYRjtQNyMzahTZOci0H84X2Iy3bQPIZ3OlRZcGZSUMRuJV/ZZ1ZqRHYsPeC3Lk8TM2J/Chsp5r+gwIJevCG1q5qjoreo4lysk6su4P2kP6JwswmVPtkZe/cr1EXYicSCbmlRfBSjulsDMDf6/DwxrDSuW/zzubzoe1R5RePkJenpvl+X8Va7RAkMGaOyQrkXRHK//gBpatDkDwRvflV1NiLfghd3tPAW8Rv2cxaoR+ROan+ZbToUnW3afM4ydVF1bT7OLCHHpzitEDiNKQ8kXWprI6nhRcokGf/rpwsvCfmDozGWOn9OiHP9EPgZVU3OSezdXcngVVTRaBsGqEsS0osTtKLpt/l2+nmxfd/UDtUq4cbpBNorltRg6QlXot1Rl/e2EIqFc3xyMyMRCSn8CMN2kh
 3yFTVWjw
 SR5VEmRplirjsOK3fbNxb15sB3ODoCCuR85Mc3YNDodIssek99l+0Gr+FuxN5dovNs6IO+U0sFlJPK+ADca0ui5IW9kj+CRYy3pNT1+Eo8qxltPRmL13RTomuREGAACSLMn0zgVfhtNf50Iih9lGeyndbz2vcrimYOq60JlayMZMd4WfizJdS9+kE+1YGzeUxyC0MJ7+a3NaCAdElNclc0K6L9KPhez7mA+plad4ApFVlg7QSey+J8xVQWhkRCqxKACcvkQqRzwgy/MzpzWvMMabD+6kjmz5IWs/qWGmax9He5gklyQfi0PRKtkPGkCWhz/OKOsd4WhfNEqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:04:33PM +0800, Baolin Wang wrote:
> According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
> ignore any THP or mTHP interface settings.
> 
> However, after commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled()
> into shmem_allowable_huge_orders()"), performing MADV_COLLAPSE on shmem
> will depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
> (although that is the default), which can cause MADV_COLLAPSE to fail
> unexpectedly.
> 
> Fix this by returning the result of shmem_huge_global_enabled() directly
> when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignoring
> shmem THP/mTHP settings.
> 
> Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")

Hm. I don't think it is the right Fixes tag. "No functional changes" in
its commit message seems to be true.

This might be a better fit:

Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")

> Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks!

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

