Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F375EC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B381E6B01F5; Thu, 13 Aug 2026 04:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2696B01F9; Thu, 13 Aug 2026 04:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0FC6B01FB; Thu, 13 Aug 2026 04:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB926B01F5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:10:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF27BA057A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:10:18 +0000 (UTC)
X-FDA: 85095523716.08.5DFDF2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 231A240005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:10:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+TGWDUi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786608617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQuOOWriGxYT4oFqH8z4fbYfZZdj+iv9kKvwYZwsbbE=;
	b=Y13o8AUjm4kWVqHPCFpr/W0eJZds4EPgDgurztZ0eNRYteNhtEONO02kQvnsumJi+M2rT7
	Ny1GXxGwiVQGTietufD+a9W0u92izHHLQ0qEHv4+Q/iNOADZDEXGlQawhFqgnHUJS8HwEq
	dUPIjCJfBxVIKhGTHf9btcdNEOslFjE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+TGWDUi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786608617;
	b=3vFHJGxKHi00/0A3h1DoxKaigcbJrq1KAQSx9hvfPGivoB/jB10/6OSunuqfzp4wY0UO8/
	mNDM0PDc1h7TFB5fwCuhx8QD8DfiN7l2+IHphzmQFpiKB+3M5vR3xixV+Ylxv57qal69rp
	i/Z+kdkbkCea2HsKOdGlmhqkJUwaF1c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FA476011F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0A11F00A3D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786608616;
	bh=JQuOOWriGxYT4oFqH8z4fbYfZZdj+iv9kKvwYZwsbbE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A+TGWDUih9YLCojofH42AeGmBZSJ+a+i/A8UrmYGjAIcQKJaQ/wJBeCrqUbmw/tAY
	 QR140K2r9N0KZpX22Y0NdYUu79WiyK9DnMhQvGWzVVb4IV8EQknDhW9CW4dS05pTES
	 I4tsih3UYlIkoMBxSIQBbzWI2Bqay5pxZ1Sf0O9R7/fn1mYeCzxloU0FPaBPIOqLvu
	 x54puaOmR8boh6DaHfFDJ/Tjt+Cegs493qs0eqssUMxCh6RoaDeh0g1BnEAMUSvtKy
	 Xr5NWhFzv4X/aLOkpp32wnk8Gt1hu/yio8lAbwcCkKNd6iei4taWFkWlu9QsMdqjjf
	 cu/EAXPN+1PVg==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8f23e851626so11082676d6.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:10:16 -0700 (PDT)
X-Gm-Message-State: AOJu0YzupUbfPmWgUGfW/S097xOPYQdaZvCJ4SCrPiqwW61k41eJb6fa
	Iq1kUadc6ld/7z4b817syT2z7wYtBUnPyi5B0bTG/M3vfc9UI5ExyfIQd8Eaj+ycfQz6uwrVay0
	G4QKz34HoOOpD5ftCWNUwpHoFB3UqsNU=
X-Received: by 2002:ad4:5ca3:0:b0:907:c056:d63a with SMTP id
 6a1803df08f44-90a80bd254dmr34426166d6.20.1786608615391; Thu, 13 Aug 2026
 01:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com>
In-Reply-To: <20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 13 Aug 2026 16:10:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zSy2vXywpGbYFG=1OT2P63p570Zodf=148C2JbcH=AOw@mail.gmail.com>
X-Gm-Features: AUfX_mw4OiA1sD8AnUz4ruNKDwzRxKB7ghQGZaXPSwX5LwLadHsvtMJkkQmCfS0
Message-ID: <CAGsJ_4zSy2vXywpGbYFG=1OT2P63p570Zodf=148C2JbcH=AOw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: fix and remove redundant unevictable folio handling
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Oleksandr Natalenko <oleksandr@natalenko.name>, Suleiman Souhlal <suleiman@google.com>, 
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, Yu Zhao <yuzhao@google.com>, 
	Steven Barrett <steven@liquorix.net>, Brian Geffon <bgeffon@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Kairui Song <ryncsn@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8b99tcatnyypj187fizsoif8ydk955i7
X-Rspamd-Queue-Id: 231A240005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786608617-371677
X-HE-Meta: U2FsdGVkX185FRk0ybq52hFadDPSgGqvMtWOvfLmNW/XW7kwPfD3pr4B+8asbY+XBiT9NP+8MfickBdvfjjwOXp3c9c5X+4Xcy2iW9cAvGxzEDrwxzLQDoV9jVjyfTs3sRMJGo+QyXnkQdmeFi0JsobEPQJ+04GLzPmCFK2SCEVXSc1n07IXmY5CVfB0wI21SD85dVPY2G1ivXgUop3w+NMiayXZDN4cdGYB4xCIlvCO6zTsFaf4iznOiIDBJDYJ78XlGfBq4Z0upg3NXr5A2I+QYwUotzoxd2L8qKg8dI8VjVHuFsek9jxyCNz3HgWBnej4K9oK00xTCDyYfSxyBN1af0s6+SjoQp4gZp7q2xvnslmd6SwcTRCs2NOEa8GtDmaG11AQsM+EZ2ygWewdzerfXMLik1fvGUiKMpYaQMJVaYqQG1Qui497zuNQuSdON2pztVLnBJ8l6dS1NekCDIApjhd6FoDoD8XOiUUnECdxBt68XOJqNEUQwh8p3ts5XFm2x6GpmoF8A8vrL9i30+ZNRMhruwi4MUskqlfjhrXgwOg/a6rWd39tgQa2bp4mg2IxOblyFPgBdeYFl0O1pyeupP0buh7p67qywLXGYBUL/LQlWDrMGM6u+q/JzU++g323TrzGBLjBovEZhmvVpT+LeZPtNrq0KhtwDP/rsP1c49vMxyCIYJAb7O+Sv7M7DnVZj9FBNQeJFHMgN17jAQgozHvz0PK3ZMJGQQ9T5tFmRQJ7dnU0QP5nlYpRAQYjGVoIP8DgmJyCodaBPeoogThEOK/6kXaaErte3WcqsTUd/VWyu9n2Ed29zoZsOX4RwcT7oiBr1nA8qrJAcrx9zUaLvJg6/LcokKXtAN1dPCrE7xNJ/pNsZqp95pqh4LnEYNyPIMw4g57/nnnqFMkDlW1zIqU0PhCLjlx+uc/U628Le+6EJ89WsnUuL6DeVug8uhpncnQVDvJysA5iqza
 v4hRB2Xm
 0ZJKnv+xsgpRea0ldhsbNv3s6lbZHt2Dw0xZ4dJm65sqYqtaUsvdVy6AjlVPA4giD4LVDSUHY8LH9JJPa/g+wdYVu2biA8iSA5wKWR6oCInW+RfzkJ1OXgJoDcMTD4QhLPrBwUIleOXpqDmKRCtC+lOohSi34PrKfOGx3w8VAteRmzmIsuOZ9H5lLJ2Lin/B4/scIR6QuU991/ORx7MP3Kz3cKIRaoDzB1HRTM665/6qLodW+vJL9WIfCC7sEAkkrvzQnoV84F5Quyt8wJkFUvsQTAg/rRpoGJp+kqEACUvsQh+8Gg25NseZbFudMj72ewxzPQb3Ed5QL/s0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 8:22=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> sort_folio() has a shortcut for moving folios that are no longer
> evictable but are still sitting on a generation list.  However, this
> shortcut is buggy.  It does not follow the PG_lru usage convention,
> and it has a more serious issue.
>
> Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
> folio->lru can be reused to hold folio->mlock_count (see the comment in
> lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them,
> and every other place that turns a folio unevictable initialises
> mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
> __mlock_new_folio() set it to !!folio_test_mlocked(folio).
> sort_folio() sets nothing, and the lru_gen_del_folio() right above it
> may have already poisoned folio->lru via list_del(), so mlock_count
> ends up aliasing LIST_POISON2, which reads as 0x122, i.e. 290.  The
> result is user visible.  On munlock, __munlock_folio() decrements that
> bogus count, finds it still non-zero and bails out before clearing
> PG_mlocked, so the folio remains unevictable and the Mlocked
> accounting stays inflated until the folio is freed.
>
> The shortcut also touches the LRU flags in the wrong order.  It calls
> lru_gen_del_folio() while PG_lru is still set, so a concurrent
> folio_test_clear_lru() (e.g. compaction, folio_isolate_lru()) can
> succeed on a folio that has already been taken off the generation list,
> which may lead to unexpected behavior.
>
> So fix it by isolating them as common folios and letting the generic
> shrink path cull them. This matches the classical LRU behavior, and
> there should be no visible effect on the generic eviction or isolation
> behavior.
>
> There is no performance concern either, such a folio goes through this
> once, and then it is off the generation lists for good.
>
> Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

