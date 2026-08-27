Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB92C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA3A6B0095; Thu, 27 Aug 2026 12:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390FD6B0096; Thu, 27 Aug 2026 12:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2539B6B0098; Thu, 27 Aug 2026 12:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00B0A6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:59:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84049A0D64
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:59:19 +0000 (UTC)
X-FDA: 85147660038.26.B743B60
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 56ED5100003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:59:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=He9Lep+I;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787849957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5T+UVRvHTqXXOze9HatcC2azQ28k3mYQ8S0a+CsmrJc=;
	b=KCd6SDwipvaIYOed0/YsESJY8sAkNF2mqFigYkuCCK8Rdg6ATlJU6PBp2nOk8dNbD8JGJc
	Zu7gwP32u98IIMNG/oZJm5D//ncNl+Zxl6Y+DwKaQqV3fL9kOmqZKot9DYO0YkPD6Dw/ZF
	olBuKDsOKpcV4HustwW5quKBKqDWlT4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=He9Lep+I;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787849957;
	b=FWaO1v2eyFrRQSKQcLK74ChGRD0xU/wf0yDp4qLF6n9Hfoo5cQI8bKu5tlS4c3ZHsX+iF9
	eGNsT4ASE5pfsCqGaJFuGwxjpBwUabsiJu9M9n2EAQvlRODFfvSO3eAczS2BLGcYRR9Rk9
	A3D0d82PMBSM2PLgo+nSE3z9C/C7370=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-66d1447e2b1so36531d50.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787849956; x=1788454756; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5T+UVRvHTqXXOze9HatcC2azQ28k3mYQ8S0a+CsmrJc=;
        b=He9Lep+I/5UvCyzctI8C4EOFO9Rl3BQ3qL0mnrGlTIzEE3Xwx0OkYycnneVGB+MDSP
         TKl68jgQJW4HKZtVG0G1xPMOKoMx0cVDXQ2U2UhOvfZQ2bhcuY7n6+ZzHbZS+RSJBh/g
         7fHimBI7aUYyxcUVDYpTVvDU3NwFgBO9fvVvjjR63ZgaXixmzPS8jDXRUAgEAw7SeMPi
         irF/m/jq/TGI94z8M0wPALmTt7pGGGAhBzDI6P2vECk/aTOZOXtg1akHvXBk5d38B2RX
         f+LPbg6rG/ELc0QKVbBGbpGYkog6I4r2c401Lfqg/oWNo9F1ofDUpCj3lAlehmTjuMNZ
         GpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787849956; x=1788454756;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5T+UVRvHTqXXOze9HatcC2azQ28k3mYQ8S0a+CsmrJc=;
        b=rFhxN5EMiXHFg9Chxd9/hAojhta0IYX2ezEDwLOpF1EEQIT7GyOEf1ZdAsZyf0UdAw
         oRRYVvQgiH0/FQpWJERYgCfuEvC7JyARsPyN+/xmlmSKoDNmVfZkxktYx+8GskJLP0Z0
         nn/y5rvHcgsJzHeyEyTHzlbi3eHOuaYj+TNmFwDkIkWMtmHoeFBR2j/6xCuvtjyWwOLG
         opMrD5s3C9h+mr6Z5Z9RD/QFwiDkdk8wP87VOb14B+7wNlgq/QR17Z7i0D1Wga35+rT7
         Rx/lyyvwb+bq32saq2oDONH3qjZcrGclSmilqShacWFMnYgWKXs6wBwSDMtHhGpazePW
         ZZCw==
X-Forwarded-Encrypted: i=1; AHgh+Rq+PAVDb6p4RS5vX27FvvY61rGfxNunnNKirNj7Vbc+OCFuHrO5pH2XBpvPg4JkiTyqf2HdNMDjJg==@kvack.org
X-Gm-Message-State: AFuF++li4Yfhb6l1TqVWvGpiae/NaUqT2QwL+8L9eggKbyM14uHYflwj
	5FX0UrwXvJpFYmreR0N9QUa8CPdpg3lAdZKmaJQZ9Gklz9GRdCUwVDrFbtsqMVp6zzM=
X-Gm-Gg: AR+sD12WIUYQE/gb7H51IPe6g37ln0XIwX8RKWSO18vjOxjbond14sIByeE3OYBBN3N
	N37f6pPkEnKb35X0EvTX1zmehOc40pgEsNu7ZYDMHjIRS20lqIpkvtJb01EwOa3hW/KRKXBqeQ0
	u4ARln5e1BVCbX/Omdx3SDkild1KBMO8qW67BHz7zCYzjYZu9JeI496WO/mL/FxnhdIo0oNMDGO
	rwadHtKRlqyZgfuAaaCFbyT9dpmmwMkpB8TsN9BIc1CRngVmRDNyd8iaB8Wiu30wBHrmir9u9PK
	7dnnZzncjs/dMNDM8DJ+rrhMf+qZiqS0+PwniERcctmtDlYVTwJZr2qgG4WlXFhUaAt2DPi8fO6
	v10/hu1gkdYW6/v/3IOmK6JQXl8HmBnzv2hFtXGC0qeAVW7WBOaN3TEb4XCs2UNHkMKbUhOhspL
	P5O8uiQCsWDQMJ/GpFOBm/aoxeHCro8vPYmR+tUyK92nyyAaUEDuM94W6ydd3x7ZdoxkL9cFI=
X-Received: by 2002:a05:690e:2509:b0:66d:28c1:4db6 with SMTP id 956f58d0204a3-66e4b914e01mr228373d50.23.1787849956251;
        Thu, 27 Aug 2026 09:59:16 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24787e65sm3299110d50.20.2026.08.27.09.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 09:59:15 -0700 (PDT)
Date: Thu, 27 Aug 2026 12:59:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	usama.arif@linux.dev, lance.yang@linux.dev, ziy@nvidia.com,
	hughd@google.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
	liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
	ryan.roberts@arm.com, balbirs@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH 2/5] mm/huge_memory: dequeue the deferred split after the
 split freeze
Message-ID: <20260827165914.GD3004@cmpxchg.org>
References: <20260826162101.1314941-1-kirill@shutemov.name>
 <20260826162101.1314941-3-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826162101.1314941-3-kirill@shutemov.name>
X-Stat-Signature: ab5q3aoeewidc41x4h7ud69sh9yubmmk
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 56ED5100003
X-Rspam-User: 
X-HE-Tag: 1787849957-906516
X-HE-Meta: U2FsdGVkX192S+YV60A3Q9WUcgEFzDDSo9fga8uHjjVRy2YifxoxwIV1X4qZOEzQ5tn2WayOczXACroLaFlwsU4uxRV/BGsGErC6HVbZZAPwpNnmKb94ewN6wdWPLhriWJH/H6PShi3NkRRXzD71Z5hDk0hG/8anrK0bzT9wb9GfUXbSWpo+KOIDshNI+tlx4gCgt7viO5em54ROwu2p/wb7ZRM2zByODkmbdp9UQ+tvbNN1u44+pXs5g0l4dsKwFIvpRN3TwSIf4TFBvyUKZloALnRZpZEV8SiCyIBKMoyLSSf47Wwp5TlHYflhr4S6XhIK6dIoSEQOmQvKdhVzy6cgQljHoqL6KXdG1a7tba/oIqtEy//mw7buQa/i+iSF95gzoUH0P+fjvuFKNZyBabWzZn6YdZkQnSSbm8W5Gm2NoUD0oQlk6flMo1Ywyu8Q3B7Orlfc28k2geKztpfdkNp94MtrrfRotuzbUsEvC2fylko6DZM5MINKKtB3hJA6bFAJnnggbWbFIOaQFq2rPO2Rp8V0ceA5F6fYBcDOGpbFG5GsO0j7iknsxMWZpAPHcxznc8p9N01+3SDI41jbBb1OZ8ojpQ7jJiSqwYPSpwOE2nxwc8EPge3dqpyhyxxrJpedEG4H5eU/tO21CdUHnz/wE6IoR7C9rD6sGANi+w6u5qbBs6IP2QFlHYptMooQz3o6T58/TUhdRItY2pJaEUM5tgy2Hq8WZFC2Y2XH19qT52qWxHcPGgP8/pGvunl9bJhr+LJr/2dKgIu+wPbWOW93kWE3/AAQ/w9VBXUGm0Ph+BTxLsqLEq5id+hinQfpUJwoT0BgHhImeeEzGoKPfijShNaislumbHpl5k5Ush89allNqOqQNL6i6ddgqAM1n4uf3facjAZkva6IEuKX+0SZoAaw2gf2ijJZY/03LtD6OKMKnZ9yJsjIEUcQ2nqdw5e5cOh6VoFs3aEy6ig
 bITInEKZ
 dNNcc2/WtKPddk/NpYeDrRO+PCXlDQH9U43Eoq2CTRMYE5B2+D07KZEJqQFch7YkDC9FTeUGIOJ5CvERP/k/U7sBCPwQuG9tFF19YyJAE12LHKDKqvymgC3Ud6TnfBo0VnXEO2H3k/7rqMkwo4eM430oZf9NNJQiu9wNQ3qtnW4oRZXtwsy5RC07sYbGrf9eXvIdS86r+1pMho1jBIJA9DeMFiSViwgdMzE9266w2D7RhkWLjtm8YEeO4z49HXD0QWKUC4JCfYooFEt3Gi2yJL5mcGyODcK+65X+DTlgSxx1y7vDkikyMqYwlhfGBtqaPh89m9FBl/m5jH77cpj0Q4aRaCFyHa+FBs0EWA7zrvPOki+qIq9i299FMyImcDPVfBUxU5ivBg+zIIxv4iPTjaNhfbRPXObkr4jOlXZ5qUAOaPUUD79dn1+LGZAUOvBUIICpqXP1YNWM67ThTKO6jGhgrdB409N/MqVc77E2GKG0Kusrqf0/AH+ow454nllgAUjCRCJOgAtPwsj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 05:20:58PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __folio_freeze_and_split_unmapped() takes the deferred split list_lru lock
> across the freeze. It is only there to stop deferred_split_scan() from
> touching the folio under split.
> 
> With deferred_split_isolate() fixed, the workaround can be dropped.
> 
> Unqueue the folio after folio_ref_freeze(), the way
> __folio_migrate_mapping() does: folio_unqueue_deferred_split() needs a
> zero refcount and a memcg still set, and both hold there.
> 
> If the split is called from deferred_split_scan(), the unqueue is a
> no-op -- the folio is already removed from the list. But
> PG_partially_mapped is still set, so it has to be cleared here or
> MTHP_STAT_NR_ANON_PARTIALLY_MAPPED never comes back down.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Infinitely better!

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

