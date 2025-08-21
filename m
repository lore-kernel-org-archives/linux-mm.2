Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD91CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49618E0037; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCEA38E003C; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C05D8E003C; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 756528E0037
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25E49117DA7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:17 +0000 (UTC)
X-FDA: 83801851434.03.07EBB37
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf14.hostedemail.com (Postfix) with ESMTP id 199A210000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1755806894; a=rsa-sha256;
	cv=pass;
	b=OhMhaW7amo3EmwTYHNZM62mplwqupWI7wb37KWyt3NFYSVGqy96cxdZcv9n68RSg2nx0JD
	DiHroqoq/0RqFpJej5/CJO/U2DQXJMdA/fc++nrN+e28dqomHfPlQrd/smlXfu13W+t3hL
	hOflOdO4kBu4ntTfONhtUVK1/WaCXEg=
ARC-Authentication-Results: i=3;
	imf14.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaRFM4K4Pg6WYlxhcM2k1BGbQ/DW6XfjnDsCttbmjXY=;
	b=cJZVDVNoFu3hTDKoPehHxfB0NO3d/FOQgBygv/Ucevkdz/hYaqPdNdf3UxM3ROjkdhkKz8
	iRkE0k6QcVcEtpn6/jNV5hM6QRuTrS9mbikxWVdH2j6e1Dy1Z0Qi9Gu4qL+QWkevR1JH23
	9ZhN6AewSftrbh8gbKVzl/wp0Pp4XLE=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A373EB9DF7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:13 +0000 (UTC)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 743CC140389
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:13 +0000 (UTC)
X-FDA: 83801851266.17.68307F1
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf28.hostedemail.com (Postfix) with ESMTP id E80EDC0014
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:10 +0000 (UTC)
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755806890; a=rsa-sha256;
	cv=pass;
	b=R+GA75AlM/7EI3LvCI81XbVChvGbS84GUb+cX/VZTJ3f6F3TRUOx1GZdcBMcXWXO4cpc2P
	GHloC+AaOotcwLIl2ADN35uB1LyNM7gycTeU1vRvLS82UTUZ/euBmIVMe0T/+pW3bOQuy/
	0i/VsDFwUTwaRa4DClXpq2cJYVi1feg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaRFM4K4Pg6WYlxhcM2k1BGbQ/DW6XfjnDsCttbmjXY=;
	b=4N3PjmhBhB+/ZrhUJNEmNm1pmAUHih2tIOPZaVtuIdbtFKMv/b4fPIH4FMOakuCLcAw//v
	JdLLyrDYVYg6wmg+6AM8FkOfttgoUIDKDZN8vC5zTttb2ZoIXc7CbjW6GbMSey6AgStnba
	iZDrGzGVcGhh/Nwdg2SlpHHX2yVNZq8=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7280B140542
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:10 +0000 (UTC)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4761A116ECC
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:10 +0000 (UTC)
X-FDA: 83801851140.02.BAF3D91
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id B733C40013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:06 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaRFM4K4Pg6WYlxhcM2k1BGbQ/DW6XfjnDsCttbmjXY=;
	b=BqoMVQDw4eflDduJZ8g/sYm/kFnTM18D78CFEjQ+PG8q3kuCoqz1aTqvyh/qptxGFklj5O
	FYI+69pDaX8S6auBNYfMpYm5X4aFYdX+bXwoA0etUxDbJZ2IJ3ER0LZ7xyYl58Q1j+rgbR
	vJkUnAKgzS94orvkZJ0AA3HNah5Ichk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806888; a=rsa-sha256;
	cv=none;
	b=nx1cEmI1KREUyat0uhgrFYNmeKwQmIr1SqCUqO9cApv5q9vH/jTecb1XcvpWB2GE19PnJI
	+q9S2E1wTolL60TPR7r9NURXxvgVqkxv4EjUUpTjorFObJaZIvgCOlzIu1+hNtUjflmxks
	z8RtlwZ5XyawEbu2h370hXQGJ1bXg5w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=it6Taxzs;
	spf=pass (imf04.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jaRFM4K4Pg6WYlxhcM2k1BGbQ/DW6XfjnDsCttbmjXY=;
	b=it6TaxzsJDPMXPDc1E/08ppOd/mm4UqEyNn7OobTDnjuTG68zMYCaT1ItHMXombXlTaUW4
	0k+SpBN4z03dxvQXdDHmpZF3c4eWynJlOgc2Tgq6l8eEe7OZd3c+ZY1CQxuf3gStboAA8p
	wMXehN8uJAhyhaeHztYxjF/1igORJTU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-4PMp5W0ROgmLKiubjiadkQ-1; Thu, 21 Aug 2025 16:08:04 -0400
X-MC-Unique: 4PMp5W0ROgmLKiubjiadkQ-1
X-Mimecast-MFC-AGG-ID: 4PMp5W0ROgmLKiubjiadkQ_1755806883
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9e4157303so922700f8f.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806883; x=1756411683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jaRFM4K4Pg6WYlxhcM2k1BGbQ/DW6XfjnDsCttbmjXY=;
        b=XJvg2Vg2khLRhJf8E4tyFGnHYMuIO6vVgXVo2EzcI6z3XBoy0o1FXBI+OtGmxBUg8A
         HnaMWB5JHk3hv/ag/wD7erzt6ZX/XCj+95rBzCysK9JTiDiybzsqkNv0oUkweDKpI6Qd
         0yW/uuyYSEIMSbZwdB5dy19sCZZqaENFQkQPM4NDJ7CC83rRdEqU8XKNBqkc37XYY4pc
         DdXJCuexHBbugdpXcUliQjsr0qlQXpnhZ6szEUmgK1LIFZELdZLlYU+sltLzGv/pe1A1
         7Rmm16X2lGXRhPcoLkQGgtMXvyMVOwWGyZTP8dP+/q7hWxhYAObk7qzmmBZY214hyCo8
         J8pg==
X-Forwarded-Encrypted: i=1; AJvYcCUVM/5oZhCytY2SeP+0VJ+7ZIO8/q1me08NqY3MXBMVF4YikS0o22XkT5v7/T7h0RKJyVzIlAA/YQ==@kvack.org
X-Gm-Message-State: AOJu0YzTAsNiSYrTtwHrYS0SmjvnZYzabTcf1zHxK6DO8NifZYQOKXfi
	PI2ySRs4yt8FJ3z3MIBJIXtOenHiH0eULDqVbpJ+L8tDdKVzRCqpoFH4wnWPQ2/K7WL2OaIPCaR
	uXi7SMN4g9CBTMf4ebWh6YxQZWtwpI0xRhaL/YhlRH2Yw5315Yj9s
X-Gm-Gg: ASbGnctd/kec4Dg2LxwWVMa+7FC7c4RqxdNgd5sOZ64vUm4x1rQYOVehRqIilKtwTJh
	oIFZXmngTAg3srEx5KVhmSG2f5n78GbEwIAlwpDBD+B9udkmd4x35M7o7GE1+qTe9C9uTvZsZTD
	WsJZzvtOv+F8+6IACNlqbwZIr6LG946maDAHkdCdf9SsRBgW1jN6wJdYmr6XwFqQ//1LmSuIgaa
	w5KhENZyMnpVFAf1pNfCBfBnDoBqMN+aIwoaKqVna/AU4ys3Sra/bK3iP3w0pwn6JbNHKFkURHY
	trHrvT5rfLgjcY7B2AUYFq6qpO3/yjqWr/Iz5BGzRhg2u0MEsLgf/tta67sVM/E1pk9ur+wkY0O
	iJAdTKhBTGfiSx/N0PMp8Bg==
X-Received: by 2002:a05:6000:2012:b0:3b7:dd87:d741 with SMTP id ffacd0b85a97d-3c5dcc095c3mr196210f8f.42.1755806882819;
        Thu, 21 Aug 2025 13:08:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiRO9AsztHDXjXXwtKcCswXKV/HQQvQjujQOlltIgK9F5s1Ca8ikdDYrX2bvCVEtKZoFK6NA==
X-Received: by 2002:a05:6000:2012:b0:3b7:dd87:d741 with SMTP id ffacd0b85a97d-3c5dcc095c3mr196155f8f.42.1755806882316;
        Thu, 21 Aug 2025 13:08:02 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e0b299sm8957945e9.22.2025.08.21.13.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:01 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 20/35] mips: mm: convert __flush_dcache_pages() to __flush_dcache_folio_pages()
Date: Thu, 21 Aug 2025 22:06:46 +0200
Message-ID: <20250821200701.1329277-21-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zD8t2KORx4fEaBoeCMN4L3jl3MaYa_EdQlC0DXIOeJc_1755806883
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-HE-Meta: U2FsdGVkX182udw0kZOYZQ4pNijUa+JKCk3RgHRY0wNpLfzxrATesM1hW9XciBPzp7WJ2huTtFNkTf9orikLFkNDTInoXfap3b5j31tykiNVMTB5BEWzjEg2ZHaF2eMihxY0MepDrc57WXXCr6lw34FmI5pwNNYEPq6i/G+0qviVj8wqIZ49LeH3eSIPydHBXJzMTZat6O3VeuQXkEBfeY+WMe+9iQHH6eQc/e6PsvEu0+E7FrqjNRYth/ETQ8MFw9q/Fj4h17sxTe+qtptZUVleUDSn4PXOYCXqO8L5PyNHSGnckWm/EFEJB9YBwtPF505Yu0TZnAa5ZFxU3wyUrscdgJoavg6eci4nUH91Wy6v5Vmozfa+8R3TJqYN6Xd8c7RfdDlFvTI6wGjIeIHoD1nXxoeiPPLxqTRAVOuOiYufsiwbXvjYNrHtydCUMcab/G6b5T9GjrZgg3qHr9XoPscS3R39AO4rOzwrC/BPKfQpNkeqKjFbeAtLQ9mdUR918jRW+foL4mMgxZUMK9o+4nfEwfszALSCJ4Na0/6pTSpMC8YC060s9uSCIRnmquHQOt6t2R4eH1G270AEf5rCUtOyJri2dkS0uRPl+rAzlT/1540E8f62QnFJZOWUdcbuJ+rVWGZ3SuT1iqQv9niffwfcl5d+D/xJJFK/H8ujHNGmJ3KKrQAxFuyQFnJ36JBtrv9NTSptPFAYtI+K3NKUKb/S8WChn2/L4adkBa8PJnMRx+Tbk6gpPQkNKVQCexYdfTlD7Ib2I3KE1RGkoXHw2S9eNzIsljjXnT1vFPX2ypycfqJbIEZFmSbeguFm5FWWy+pHZ9UgknB79i9tfja4a5sh+f1rUCyo7LwgduU6t3NRgvoz3fGPvQnnTilpv+1FgFSTxp2J8sGdI+BXTARNbODzfyWkOeINFyopBcGZP4srlitU92xflg2Rnu933QtzR5FE7T4OeOuDYDoXInp
 ZtIw6qlS
 cKeBzYke0URdKCbOBIkBoxGZ+57XfbsoTz4vNbk2aguli5GnZBHxpSS3z/XwadY5i2xj3qhbyK7QqW+RQIZ+t4SMeWBZejSlt890FUIzC2zK5LIrzKguY/X24Vatu57WDe1AE7lKyRWFAr+5HX7YCtfR9psK5BZXY6tsAZhPHEtuMAeo5SELy3qWV9NWFM3V3Xm+wHnLOGXiGc6l2WUEvKah3P+mG6WT+NWrXQMTWLvD6TGJ48Y/lJawIBpq1gXXeTAd6PUMXLttOuXGT86fNwIqWy6VSzhH9bhlJ78jMSpkjnURP2TsncIGuPhy0NfFEGIzakJnDfqgU09TmQAHPU2AaltEgBKyz0ZtDfGfl7hGoAfmuZqjYYQRprGDb3HoioquQuWttM3KvgFIatg89G/4msxslJfZq+q6+PJFCILN1uHap35DON9Jwdf21oC6l0SM7xa3YU/5rLJxz/25SCySeSzdavTZBLYv+jf/a9bBX+RQxQOwkgqyYmfFIvUaH6Xjym/k2aF2K2UJLy/Ns9R8IKItEvT7fTPA25W1Y1iw342nHU99vhiZM2w==
X-HE-Tag-Orig: 1755806886-277115
X-HE-Meta: U2FsdGVkX197MICQRVSB/99zAQ/6CrfV+Uizw1zijsRhIzW+e+f4mn+mVMcmzA7UrAbu9zaPcpgRDVLtmnCBGUjBTdRTk9E6oKWKcUOkxd1si6HLbtbMQM2cJyUaUMl3n68Ur/sM9DNf1+qdAZaimTqdt9EoaezJsb/bQE1FhIor2pDoDNBXz/TqpAanD4jtwLIj21u9JKLQDJc4zeqSWdJpSh7E7TlwHYF+UY6csTktgImFDumnx9zsZAwNNAmbFJHsmREvaVmLk8dfJkczNF36E3QSnDYLT3EhKiZlZY0u0WjjeJhqUmU4okOSSuWdu3CbBT2X4T2E8Jadm0nyVxbme73B/pD5zYiGlSVifg42r5OR7plE05fzv469cDyO6p5GLH1h5mrMEN1dWzxdpvATyT5ZXvs2F9nfwugmnVXTIlIv8+raunUgZxgzgw8QK9gcjW6kyK0/0QNwb9JLpdBRdZaWZLsY+p+mGFDfduFKW8kIENd03km2iwUgOU0+S633RRXuXrusPabegsccm2BLtHwHM6xzs81xOV2w3LHe3PnZTEKEeZ/OVpkaUEJU3gB/AiqyoZ8BEpIgGDSTArJRtxVuNabblDrCXQc5foRGeqzNbkIBq+FVzbk4QWYAtFc3tS/DcukJqB8bNQl3erewLWx4kxLs+w0UWbN2zJsaBKKwQa12GyVbALZNAAS7qmhWayhimUIoel4hPTdoxIgGLEiDkbKKyqwaMQxtKiLrpvkxh2JyrLGWh2o32kvND07xl2kVUyIu0dgsCJXSK7V4ylGr9hyNjt05Pw3vGFos3Lfp1mMwc5o/MOk2mrHbmq8euxFjOJIat23dxlU73arMOcHO/zQD5i0/62ye/l1bsCTlIS6QqvsUDK7G2m5mULlBiJaoTCZ5k3LbCP9MbaD4hJ5p62OEYDy0HXFVDu+TP8Hbq976H871Mp4TBg7pQ39oUMZOUegxfFvPbFn
 /UG0v1Q1
 lEz/Q7dWY4Rm961Z3lPlHEbFpPxRbuvnAV67/vv9khw8lFAwoQwvl4TaQBdbs8wYMP3REDT0rjmVCLAwLDnJhbHMXgNk7cB6Fo0gqC4U280LCFyGidG+rMMEaXmiBpgEWGSYmQ2Vz5Io7u86nV1ih/FV9rXhiBGFYrV5eWvR5AqzKePpypiA46/jJosNGLka5LUYcCkfXx5DIeBmIRDN7lvnEp50xLGqXIWeKyB/tUAkEWoQAq/IJBiogJNi4/NYDKj3OeaPATmEUnG/cs17ril7GbmI8OI3iy2XJzfdtzwF5ImX/ahEvGjMUqpD3LILu4qrE8JCXxPLdhVE2wq4Tfvr/6hndpxKkrmm1oebNjeAwaGGpImMCzYgS14BTVlh3p8kol8A2Y4wGwAOnO7VBU5Qqy2kOSLxlqcUmRB4LKUgbJYQ=
X-HE-Tag-Orig: 1755806890-59679
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Stat-Signature: debomegc6ykwbhffz3ixijoazhhj6o91
X-Rspamd-Queue-Id: 199A210000D
X-HE-Tag: 1755806893-748579
X-HE-Meta: U2FsdGVkX1+RW8317Pz7aE6Yiada4FKdGL/SJeAZlA268L7b0CMsDbYthgt9KVkwlo9/uIQu2OoW9tzW1BM6gYjOlj/anLovolDnq7UcvJn69+XxSP5wyrfvhdFVxRT5QW3+HWOE98qHorYlr0IAQZR/WZm04xNqajeEVZJT+Z2n+GNqWVH0tIEarkf/DXMtv2XET2sSUnFIn/vHlz/kxg2tGC3/19kqJk8LN9pA5fuNx7YmcaNXB/PmsEb9Sjx/cYupWqW9sPBbOkaO6lD2oetEG61N9S1Po2bjGon3gnfR+0x/2AvRwDTnB1IX77+OBV0XGh1LjU5NBFXDfI34+pieOJFesjUnF1/35GihKdCepM2umdzrtYQkdapwFI0G242jUIhVeGBlIOKncjjZn3VVr6DLoVYIIm7peshG0BdUJq2vxweg4iGkHi2yKQ0PBwmPhAHZQ6FhIfInNQjAjE68u+Tu6vbxf1RJ8MfWMt55d875RZnZXSyfEQAlutRB4ZKqSoz8VMznH7v3v9ZWoyWaK0AvGzJyvEU0eU4pekhaqzVInGBfNquAW5ZzMEK9G+rjoBNPSJkqbRKkj7PY+94HiVFolGfD9o8vHfQaFyRfNp4VoxtKQHY5oLvT0nRlfJoXaGR1ry3fmBXq28m1qQf5h4wCiE06KgyeHEuL8BBs7kC6afTQrPudgonVSCQlyGcqJchqd6G3qko6CuZtHLTfnAg6uQLYYvag05pB0PDrf18NQ+CohUCsOlit5LnLUWoh+sv5YyQtoXa3d+el7w3/IdyaG8HzDhk4aOHrND474sYJSlpcJSlm+SehXUWNqU1nWewMuKesE7F2PoWK/nVxfW4uxH765CqEx2SG7eFTfoHZcusSrD7ulAxiYVu5AhDSIx4NtdppWyOLf3btfI8LIhbjDFv8Las69rkJiL32jiRsTH0K4NxWJWYgUyuj3SBp9ydmvAdmGBv3y1f
 mjjqwMfO
 /EtUIskUv7Vr59hd8reOcDX+YTFdtEKpI0FzrVCjDlgLUaO++uZuJFbSRZkRIzb92p7/fuckf9yahdJoUNkkXWUtfUO6i4zML9IifWQ+0PnaT2SS4GUIcZygoQ73QH63q9rgh9drb0t0wgc2/uJpZgVwRL942UdqafKy7eZsvw3QE1aMwMpEEp/sq1AURCZ1Mp6hq4jvwKSe24uUN5fjimTvwtJyi3LxzB7ECn6rDsQv1G6PSLMFwTe7yVrO+HTl/sHbALVpN7hZxnh+wdKtZnMjbLTmtngc/DoNWZDl6R+NScieMNVuF4/S0TRSyy9KdRSuT/ZiAo4s/qdPg/tmSGLFvF78YzQEaohaoF3LZ4xsYHmRKdJ1niYZtD3tyQWcC5s5e3exdqCgkJssy4X+bmaaY9ARVBJ7WgJiF05IyyPvfHmw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's make it clearer that we are operating within a single folio by
providing both the folio and the page.

This implies that for flush_dcache_folio() we'll now avoid one more
page->folio lookup, and that we can safely drop the "nth_page" usage.

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/mips/include/asm/cacheflush.h | 11 +++++++----
 arch/mips/mm/cache.c               |  8 ++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
index 1f14132b3fc98..8a2de28936e07 100644
--- a/arch/mips/include/asm/cacheflush.h
+++ b/arch/mips/include/asm/cacheflush.h
@@ -50,13 +50,14 @@ extern void (*flush_cache_mm)(struct mm_struct *mm);
 extern void (*flush_cache_range)(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end);
 extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
-extern void __flush_dcache_pages(struct page *page, unsigned int nr);
+extern void __flush_dcache_folio_pages(struct folio *folio, struct page *page, unsigned int nr);
 
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 static inline void flush_dcache_folio(struct folio *folio)
 {
 	if (cpu_has_dc_aliases)
-		__flush_dcache_pages(&folio->page, folio_nr_pages(folio));
+		__flush_dcache_folio_pages(folio, folio_page(folio, 0),
+					   folio_nr_pages(folio));
 	else if (!cpu_has_ic_fills_f_dc)
 		folio_set_dcache_dirty(folio);
 }
@@ -64,10 +65,12 @@ static inline void flush_dcache_folio(struct folio *folio)
 
 static inline void flush_dcache_page(struct page *page)
 {
+	struct folio *folio = page_folio(page);
+
 	if (cpu_has_dc_aliases)
-		__flush_dcache_pages(page, 1);
+		__flush_dcache_folio_pages(folio, page, folio_nr_pages(folio));
 	else if (!cpu_has_ic_fills_f_dc)
-		folio_set_dcache_dirty(page_folio(page));
+		folio_set_dcache_dirty(folio);
 }
 
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
index bf9a37c60e9f0..e3b4224c9a406 100644
--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -99,9 +99,9 @@ SYSCALL_DEFINE3(cacheflush, unsigned long, addr, unsigned long, bytes,
 	return 0;
 }
 
-void __flush_dcache_pages(struct page *page, unsigned int nr)
+void __flush_dcache_folio_pages(struct folio *folio, struct page *page,
+		unsigned int nr)
 {
-	struct folio *folio = page_folio(page);
 	struct address_space *mapping = folio_flush_mapping(folio);
 	unsigned long addr;
 	unsigned int i;
@@ -117,12 +117,12 @@ void __flush_dcache_pages(struct page *page, unsigned int nr)
 	 * get faulted into the tlb (and thus flushed) anyways.
 	 */
 	for (i = 0; i < nr; i++) {
-		addr = (unsigned long)kmap_local_page(nth_page(page, i));
+		addr = (unsigned long)kmap_local_page(page + i);
 		flush_data_cache_page(addr);
 		kunmap_local((void *)addr);
 	}
 }
-EXPORT_SYMBOL(__flush_dcache_pages);
+EXPORT_SYMBOL(__flush_dcache_folio_pages);
 
 void __flush_anon_page(struct page *page, unsigned long vmaddr)
 {
-- 
2.50.1




