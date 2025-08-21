Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E64CA0FE2
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D788F8E003F; Thu, 21 Aug 2025 16:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3D58E003D; Thu, 21 Aug 2025 16:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81908E003F; Thu, 21 Aug 2025 16:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4FD8E003D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6040F5930A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:27 +0000 (UTC)
X-FDA: 83801851854.15.F84F443
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD287100010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
	b=6Gv/xMWURBHv6sUh1zt/8v1vcXgEyJHJ3e8LIs4j1u4TwpmX03bLmQElxhm1e6tt8KnyPz
	mEgxT6tyKuRk9XqTtJLg4YSI/uWQ+fkS4O6EWxtob0262Yh9BoKL74Vt/GdSyjohHj30XG
	ixPT3aZMKCDVvrziNqsufg1zQjyoUoU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755806904; a=rsa-sha256;
	cv=pass;
	b=Q1RtFtg3B2HuZH1bkkBVcTlE6GysV4nIXEGzOr3/o/1VQ0Q+LTS6jwdEREopkQH5Lw8m+V
	O5EQnhRGxxzZVmddEfdtEdRl3ALm0iU+B/duzdk6QAff0qDkHZUvlYUAri5fyGoyCmLhJ+
	jkKp9GsrKsrSUHXea/80GkwFavkKlwA=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 519EE117F02
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:24 +0000 (UTC)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24E4E138C33
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:24 +0000 (UTC)
X-FDA: 83801851728.25.9259826
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9662840002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:21 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
	b=GdJqx/v+wcLr4ELtYmP17FaVQnS0ATi0F8AQMPeBlnrLBZFUgyQ6VDYLt3nDMue3nKJe4I
	+SfZ+q5F8TCRw1vPpk3oa/YwvkfYUxzExpzs/O836Hb4EzMEjSmSkjiELOAlUzaEzDb4OY
	SniQL8JtNJ//PGRfNSHKmYBkYWddVo4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VHXQnlag;
	spf=pass (imf17.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806901; a=rsa-sha256;
	cv=none;
	b=3AAGeX68nJjkGC3Q3xW83QPO2LVA2WdxlkFu9rWOuX7y0/alqoUKIbIhIXdjgnvRvpoaXd
	rx3UIV8je34xfpWLHS/yFVRmNXHsT2KOv7nmsySn+rAmqA2Tax5SwIEknC4Omyb4fLc6bx
	eYGLEvijRP4QHKWJUO30Np2LgeIf5hA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
	b=VHXQnlagpzamWqw2r6ysufuABBblpE5+d8b9qzHLlz7bzDoB+8N8sg3N7ATQPLlIwkZrKR
	cgW6U4E59jMI5TnXzVoMfwlsuhFBXmRY3L3nF9KEq6dhoYLGrqVEuVLadXdDj9CRS+Flu7
	o1gyKGC6di7fo0+9whgfjWohez+4aYA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-SQbzd99LO_e5p8NeySbI5w-1; Thu, 21 Aug 2025 16:08:18 -0400
X-MC-Unique: SQbzd99LO_e5p8NeySbI5w-1
X-Mimecast-MFC-AGG-ID: SQbzd99LO_e5p8NeySbI5w_1755806898
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b51411839so824315e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806897; x=1756411697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
        b=wn91kHVuS7HpQ910MNguHPleL+ixzdQvj3bA6DmhvnkuHS17Fni9rmH8JwfGaikn3q
         tsb0hLgxYivToWf0Dv+QmUeigN8D99o625hFiarHnwYGC1gOPVYx4IKOydwKdogvf7aN
         ClOqdkIEqU8jTvfRlsvsHrT8+L4ipOaAxusJ86q/WVDjbth6IBo+ilEqlmwHTTGG/PJq
         He99he7nwYJMBTVlujs2rJY18JDTRaYYx7c1Kcjz9xxXx/NH+luS/yu0oOrAbGBKrI+h
         KhBcLqYPagN3CvL5EuaxByfR2BWM0WBWbCKd39xnJlwi5BJ8IzOHQepXLg+Jyrm97dwn
         UT8g==
X-Forwarded-Encrypted: i=1; AJvYcCWi9Jl4iWozXRcRiSWiB5LGNoPRqEoW9Fst8o6OTeLO9H5bgFCkQOJaE5+9SotwpGuN6wsXnhFTFg==@kvack.org
X-Gm-Message-State: AOJu0Yz3tEGjzQD1ClDfdiA4OM9q9hmJlqyuhcB07lDGudOvkXc6YB3u
	DjI7ZZWu9UvQ6KPg68cBFuna3P5Wjf4sY82WK85+9YZqmEBxpkgXNyyq3HMOZ4hoKP31lKfuWBV
	cwiVjlj4tDSkmaPQOQxz3bPYLsI1cuhEYUpDben8a7wpJaWzeYsJ6
X-Gm-Gg: ASbGnctuPKh2PxroizMkgoEDCI+D2L2pZ9rl/jPaeyVLw+K2kwepGlN7JOcFbLv1lXO
	IFZKecYn7PzrE9OPaVZqDBFHzmePzh9sd+lRRJIZRAZ3vT2soDD4BWvVnU1Ecu28MKck9lsT0wt
	rvI0JD/BTaUQt6HtZ1KDkVRJJMLZub4Xd6kAuZqIGgwzgEib9/MXXRrzN+TwbEytqiVkBrNF9Ci
	+06JyQr37VwuUOZru7+OqzHlt9tgkUCLHRD6t4WsU/fzJorxGvepWcj1ibaEHQm1g/yq6wAqwPT
	uDm7VStnTvd/6/NHFo6xqufsLleH7hj3QjKf3LvgdO6vynXSKnXm5HLXwK351G4MgnEf/wUsVaH
	egW69ddrZXNT74kztxr2T8g==
X-Received: by 2002:a05:600c:470c:b0:456:285b:db29 with SMTP id 5b1f17b1804b1-45b517d416bmr2506155e9.29.1755806897470;
        Thu, 21 Aug 2025 13:08:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPdYXvWWhsiYzUao4v8GSpApokx2tOJxTxGWaryOs6bj53AmOc+7o5w7P2pIRGnKU6jzi+ow==
X-Received: by 2002:a05:600c:470c:b0:456:285b:db29 with SMTP id 5b1f17b1804b1-45b517d416bmr2505625e9.29.1755806896948;
        Thu, 21 Aug 2025 13:08:16 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a551sm8831035e9.19.2025.08.21.13.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:16 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
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
Subject: [PATCH RFC 25/35] drm/i915/gem: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:51 +0200
Message-ID: <20250821200701.1329277-26-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eKNDLaI9s-N50BLKBQzPMOPXZIml5i3y78Opi2YeOIE_1755806898
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-HE-Meta: U2FsdGVkX1/Hi7aQu7aglCzIU7KBZvKHFtF3m+ApCkwUd6KFQSJvrsemE/9fyrYknFFoEi9OHzxTg5SvJKBWFCU/mXtBLpk4hi/wXVKhTMFXAS+7JCeBQj5os9GAuQ8HS55bmvJFBusj6ifeiiZQlAEYayHaZD+tfRy0jd7QerPyHdc0XFIBejkS+UufHBLfSJyiwud4SXZYJD3f5te7xLnEGrb8VlG/XANl0HwDXG0L7i8gFkQ7PqXo2cgnr69Bw32yPukfyRvC5vw84x3D06dPsjjl54zvjyV5bpaHVz6X7zytaCSJXdK4rJDw/nIHshDN82swa9qj0FB7KT76pJKoIRd885ZKTyXHCk/x447OaC6eCoPrN8K9EY4aZr0JY5pyuQOivFApF8muYfOfa9+hZf1ydcNhadLb8gIzy3yMZaOvUOlrEBHJeq5dM5J1zlrVKrQ3PNrI1Rym4d0WatHGjHBQ2YhXR+JmZp/SgAJE+Qg7E/XrR0W8UDcLftlk5G3hcB4rByWnNIUU7Ni0v8692Db5kZw3Xa5eSMuzGXuEmv2mhN5bnZAZrdoc7LhKD5XUdVVQ8Ggc+h224mTBnHu7HsF9xU4p8W+C5H+tZiluLlmQRFWbB/BemkMKd/ic7SpUmZfybATlh7//+C0ihuJk3tQB/1YguhZ1DebbKLSlxlIPq4kF+xtqdJkUot73i6LX9uA/8YYnc+JY/9352clE1vojkBXs2jA+bLhqyKD4RsGizCY6xroIHioaPEHTxI9P+QZpH4lltzL0HrJ7A1Lb1RJ37PWIranJwIb2CMZcU9YHlsIfnTf8Qfss5HLoi1NhGSuTHAFlUgsRyhW7DEzPgJs2RUyrFSDup+tt51uDkTRaUY6rfvVIfxVs01Rlq9OqVC/vGtxzHHvPc7Id5Ogg9N3eiSeR8t6pmfhQmap6GCZslMhMReiTWceSzStnkuoySgfgPCCpX7Vto2n
 s6CaEI8c
 QEFwnxujn7s+5dCzdY/30Wg96wG6gAB6HgIFTv1tNWiraek0RLkO+p+SXUk33uV424hP10da2z0OcU6qbS/wrceEmvESkejvdjZvz+Bf9abVYVgSWK2hfWbfGSECmvk3WopNlRJ2tUdxyuu9QenLuA+ZOuu8JD+qS5TXleodz4EzHi6SmkMmhr8NjfZMkla6SwTFu6bqUJRwivihxSsbOHREAdPWz5JPc7w2coPkdwZqpNPdUzyff2bNPwDgX/ajub2GQqbDRAMbR5cYbuIMWj/xJhaNoCb265lYwhKfR16GVgwIo7kfdwFA/h5eCjHjmj0w3Vp946L1l9x/Pmo/4cT9H1xrZacTey31UF21THGl1aqEZqcqBMHyMiNQ6TgL7YRU75XRPsbKxvsfBG+pzoUQYXliyefxzn61gjFBn9wd4r+Boczo0wujs/pFALANYYevDjSmpC0LW8/NKGp1IYebeQ1i9NBknz6pCazlpNudxoKeZHMrnlkzAtK/Y16z1AuWlxsNPrm2jLHzosJZmgBdxrDLAmtfdclKQpfQQ59G4dmRFl4IpXdKcOHAPW8TbA2nFRdh6MvDFVsqcwNqBWa+PZH3K4K5RdaB8pUpv7/+68PXhoHjHE20i8WR5ryzUDwKG/iPCgiBF53+vqs9yPzcegQQ3y6CaVW1a
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD287100010
X-Stat-Signature: mufd7ih33iqjpd535yujgaf7ahocd6hd
X-Rspam-User: 
X-HE-Tag-Orig: 1755806901-439824
X-HE-Tag: 1755806904-830372
X-HE-Meta: U2FsdGVkX188ouwJcOKWxBhvyr2t2xO5MKm7BuY/erL8aJ7Zl/RQbP2MhaHVRF7+HoljcaEqTOCN7DcpQIcEqIXb9uPqAm5XFjD7JRufbhrL50WqzG6rgqRjyABgkBcfSMlgWzgxMlmnRRtVyB6X5f/VgOWfL+EoKzQdJP6PAV4Hq869rLTIc4t9Jgg5Nk6/tJC+KmE82i0ukSIfW5WHKoBL6cQxlDAkJtdLQ8wiNB4avJARCNTnCYbibg2c7D0W8I5yZkitjQkuuYDdUM7ZRFs/BGprPLZhWGKGLWtvsXk7L/bYdEdGiL3X7qlUtd2M422yil8CGHYy91i/UlQbMQb61nthO5FobcLJ6MCydtT8rFlPKS7RzbOsLmmH8TsWWuxGemGMSoVrFGHXxpag4Rkvi1BNsLee/k4T4T5LjkWMdEmftC3SwXY+gPwOWjvtO9CmXtveOWdKjGqnFOodMoSvxj8+WAKTXWYkCIeXujc/IHPmUbXgQ8mV9KAbd+q750fICzcFXndht2tgYSg5Crqp9NlpuytGxzdzRUtIYauE6cSEw0UMnvCkJuvTlZ1bRSFxyfjiCM1W354oi4pe3ARrodlR4hgk8NfSNyamRobJrJV0GFVDnO+yFDu+LdEBEY/if3kYH/OpSlbVd0XYVxCLX553K70vSQNioUYRuURnpiliZQLwZZHPnuLQMBntG/una7h6TPEYHZ/RkYM/gWNLiww3U69IsvD9y7welM9sYuGg7w5zWrXyeQe+IN1MLkY65JsF8sbUXViac61O2pm+FWg/r4U/ZdJQ6IirjaRHWYRhrAENgbyY0htBzq3Dn80BB4wm66GVwcra7P96NGFUq8gxmmCwUcNwJ2fmC3oQ69xxnStoQF36wdJk237b1EImWryWRLSiiDdO3Z277bHeROTHGG6ai1x3oBqz5eWAblXT8TokNiguKcn7W2xQHluT+R7mUgwwACmYmfk
 eypymGyu
 F3MLPEiLo5TIoD4P4bLjOdPAx48BzVmTGA2C3kuWEeO2ul2X5ZvU0bhYEf/smMGjjiaUh/SqCMo1AJHUL/5AnvSgXfO77cLF6NuAoaKo3QOS6IF1ZJx9RP2xBOavp3yUHZEWtFzr+KYIDCS+V462bOtQBGKVXXOoJRhB9giqedYC42q3HL9SEo8FwORUzPiihm/cKduZPHjIPha0ne3Kr0xSk/gIU4Oki27GRD22S0XtkqL+1mGPnk1v48NeZ1uVrjtpF0/ZRzLMMZ8s7moK/RTK/8M2TvSfXcVAxORXHiJ2c+LyLCM/Kzvo7Q2NVFsM0EM9wf/GWyZg/C8rNhoAen0xmcUlea9wwHa1LGK2qQzlBrLtCREY9EqTdnC8NzZrk12d8k1LbS7yTDs1dz70iv0lDFwXtN1wK6OYeHDptu7vtSfVDiSL9SQV1N7llr7CScO/CSw27TXkQyhBMyf1eI7evEbH5vSftle9x5cHeTQ3T7ov9xnlYyOIEoqaqX08PTqyQ7RGwVj/tx1N/QgkvPUQRiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index c16a57160b262..031d7acc16142 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i915_gem_object *obj, pgoff_t n)
 	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
 
 	sg = i915_gem_object_get_sg(obj, n, &offset);
-	return nth_page(sg_page(sg), offset);
+	return sg_page(sg) + offset;
 }
 
 /* Like i915_gem_object_get_page(), but mark the returned page dirty */
-- 
2.50.1



