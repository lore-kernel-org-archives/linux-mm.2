Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 606A2C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B056B00E5; Tue,  4 Aug 2026 09:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709ED6B00E6; Tue,  4 Aug 2026 09:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9CE6B00E7; Tue,  4 Aug 2026 09:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3ABED6B00E5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:52:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 397D0140197
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:52:50 +0000 (UTC)
X-FDA: 85063727700.28.4099D75
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1F496140002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:52:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vgQvIYe3;
	spf=none (imf26.hostedemail.com: domain of BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785851568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBsBBxPlLeU2cDGjgyAGoHsbhtXXZRHRORcMTmjXjSA=;
	b=IeFXoTM87ylDau5gHTR3uxz4Xnz2AvnHZKtw1QAwLEJGwnAnkgoIlQw4orKr5O11kChHtj
	eaM3A0n2sInHh143Dt8qN5KmIr+M0/ypB/wBIlLb1uEIXoL3ykGFc7MbBZOEwpoAuviobv
	q2nZzAgQUBh8Tf6uygr9cN0HDPJlOOk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vgQvIYe3;
	spf=none (imf26.hostedemail.com: domain of BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785851568;
	b=ps2iJhBbtVG0KAlX10p77SJacqjunb7OHh56c4MUuRAp8pZ+jDPIbKbGteo92hdH49Ncem
	28RD0hxI3md5oNF21mC/RP5BLhRQz+aOk5q+nE1NVbQlfhsYAz6LaYFaZzxM7XCfD6ZIfm
	zCtHPtCdpeQjPN3OsVq3VQoce03v2j0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rBsBBxPlLeU2cDGjgyAGoHsbhtXXZRHRORcMTmjXjSA=; b=vgQvIYe3z6Ore65tumSqUuDxnz
	+U2H2hNH741oZbMvXYXrdJ6nFxBGS819Sba8ixGYZ86bHaYeBNqS4mIi2e5L91icAEHzArply0lSY
	1T5oHAy6EAKI1mILNM8gzTqrQipozzu0rmefbXRhGoJDOM2Nema5H0nlKoIl2iMK/2OItsRncvVxV
	lnCxuOu3MPBwaN2ygOvsedbuqS8hdzrFEEJWC3cdacqaLbyfIWDmeronLBKRY52QSscdA/f1T9vMt
	j4YgnerEAW7p5odqowDxwudELDdO4SFZbieE3qA0tsssf7hxotc3OB29J6MFhKLYB5KO4IrKTe47C
	9hAM9kGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrFZM-00000001yYA-1Tuc;
	Tue, 04 Aug 2026 13:52:36 +0000
Date: Tue, 4 Aug 2026 06:52:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Michal Hocko <mhocko@suse.com>, Sergio Lopez <slp@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	bcm-kernel-feedback-list@broadcom.com,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH RFT 1/3] mm: export variants of vmf_insert_pfn* for use
 with pfn_mkwrite()
Message-ID: <anHupGFkfWkE-cg_@infradead.org>
References: <20260731164341.1109827-1-pbonzini@redhat.com>
 <20260731164341.1109827-2-pbonzini@redhat.com>
 <bf97ed0d-571f-4c61-b761-5b45d435c4c2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf97ed0d-571f-4c61-b761-5b45d435c4c2@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F496140002
X-Stat-Signature: 7ibxbi4dqyjqabnuansdmrg9rndhnaj9
X-HE-Tag: 1785851565-43274
X-HE-Meta: U2FsdGVkX1+rHgYFUqGu3APQ5dZ9fTHXeVS+OzdaNH6NEbW6drqmhpx2wTCG64RaenhV+r3ANbhkytwylc2PUhJBNibQPccjSeImKJUGp6YRdyEnoH0PgpKjH9vXYwKEkGufOihqVwMS/01uC8yWAmwu1jwoY05fVaUqde82EXlFNRHtYq4OhjWX5VDQ71Qr6BK+ayYH367kkf9MaVekclaLhqlnI9yOGbROdxQwmdTwRRTDfL3uFXmmWC7RmC5c1p5192AoQ52+IJ/muB2eMPOHTo38JtrvingrSeVC7jpMIiTL4I+/usYb6Ufh/e/tT2pBifIQrL5lRfH9Ump4iAlwr38uZ6/KT08BbpM8eUrynYbyAkjrb5UaF064NOiaMncrpiafLUMF1LraSLbHx7g6JrAmQ1naNP6j1T6nfm/g+elngOPnlmHNtg1GWdK5N13BTf71ENVc5VbK6hLkZ6bwQlhGrlGS4u8eeHgAv1LhfaYjGCDg7qy/JGt+w5FoVJT41mfgS8hiNs4XoFkDPogs6+pALOIdyhpFSt7zAixA7rsCE7uNyrvJuEC05rQNHLEyDUsYm7FrVAdVHNFgUDxRSJ0VG/GybmoTFenk5vzN9fmtZv0sJnOSi/pA/tiGwUqVBb1Z6j5yvgmw99CWFQw4/4Dj3FpQg4g+l9p/7FlexhWNll6ntQAYNgggxcM+fxtd8gvUJCozR8i53uB8B0DvEMM6WEravIk8DRhY2QiiDEIOYId0WC+Xbw17aiiaHkmlrvgq+ktFnnsvpCc2fOIzRZcWESqgMMIZvNFVvpt/ISwYkSk4GzzWweegMUkXKaL5y+tAS3xTf/KbDBgNXgvXHYv+z3zdDlfw8KUzRf/1zWfSBNaGac+cv3zWIghg1FyWrhrle3GMQ4Wl7x7PaYhVSQzWaswGqFbBGRnvgPoY6UJ6FL0yMEdXkRcPF1QRshBMRCnwfcami3SsD6s
 dlZKAgoo
 Ed9yevfdav0MLzAchtQcPBZAs8H16IPHBzzJrf3By0/NTqnwkEBfGdJktjNVZD2buWBydMD5CPrvP24fqBOYQEJ+gyjwgWGOe5WS/k1scQML8pJH3pA6200WVuCj3Rns47114FckhbnEepYvzkKsqQDmbkwLO0BqjnC0F5Sa8LBDmglSH12oM7Q0zWKHtt9+5m1Y7PEku+hqds6rTYNV4i0O9IuuCvniGI4FjltRe/0KJmgS5aioIrRqqvQGz3lWXqObB9LF0ZKf25xOrGmp3ucvkMsNmbT0xQ86rkMSYhbmJDzrPhzZ22HDRVoioLsjcX6CQEptaa2HU0IWzQ34pR1JwFEIBxlRH9O9TUsTNMZTuD26iCdGrJGVCFgRm0rEkW/q755880ydkB+eXXbuk9mEWGmLD9vy4x1142CN+ZETiFFe4tZC3KxYscfboZMJoPR3UrrV0fpC+uQA7Ej1KwvPqnbszaYlbTSybIhAB6P7Mi31AtC0LCui5heyPUHyqZVbfkq+kODfrMRF1EoZR57hNsoJuV9LC7Ihh48fZvl5mVB7V8l/ZH2EAq0Q+ydGmOmfrHLdHuVv/Xdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 02:16:33PM +0200, David Hildenbrand (Arm) wrote:
> > +EXPORT_SYMBOL(__vmf_insert_pfn_prot);
> 
> If this becomes a dedicated symbol, why not GPL?

Yes, no way we'd not export low-level bits like this as non-GPL..


