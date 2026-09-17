Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A757C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0139C6B0092; Thu, 17 Sep 2026 05:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F073B6B0093; Thu, 17 Sep 2026 05:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE2E6B0095; Thu, 17 Sep 2026 05:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9E866B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:01:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2BC4B802AE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:01:23 +0000 (UTC)
X-FDA: 85222660446.17.653F231
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 651EB120010
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:01:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hfAGs73F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789635681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=laqtueQ1A73xIegtMtRDwRGfwaKfJ/pA21DgwFlf3jE=;
	b=Kfjm1da0GRv2waBRXfeoFuYGpeoioJ4qzXN3E17ox0QFMtnNAPSIgStDXz8s/q0Wi4wbkb
	sbFJAxLvA12/yv+YB+72szqKxu/EX6PhXo5DPG9Y1LyU3MQwqzyRVCLOZj0xGXKjRsqrJU
	wjiZCvO52qXUzriUOwt8cOK13XaQoqw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789635681;
	b=qBtU7PeeNKDgXCfNhxvatT7r8IpJusAld8WbGsqtKCQ2wNh9xbzTDYpYdGPw12MDhNd0pR
	+WMbzb8GXEdtnocbv59gsTSErcJY1sZGnu6TlDrOBl5i8x/1n79RVWf26T9D/jCOonrjxN
	mk1SaOIZFUc/D0sRtCS9uDXAaY8DfHw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hfAGs73F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469d20963so382367b3a.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789635680; x=1790240480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=laqtueQ1A73xIegtMtRDwRGfwaKfJ/pA21DgwFlf3jE=;
        b=hfAGs73Fhtk4p9TzUjgYOXF7LQ+doJWmpIw3T3qtQLISMJUsKg0iFMz1ku/CHZw6AS
         xhz6964SSDybiH8kF0RWx9AtQyiyOZf405PUE2F/OvYSxjEy9H1lLZNJRBj36NEg86mN
         /QJ7S7tqfkNjnxcRv2wIsUzSjGJ9ilk6M8Bq0SzYYcTWatnwTCnESSunOwFEORvlw3jZ
         zPRFxDNBKDr+AOsdg6tACYUhiifDxMgqYPahUguSwaXLHUaNqYQSmCKmhUsWd+Y4egdr
         eZxUB3X5bbYR/YprILwxQpTep6nwHchX5zNACJ9jC8x7ZibOlA6q0rpVSAnb/N+kJdc5
         3mAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789635680; x=1790240480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=laqtueQ1A73xIegtMtRDwRGfwaKfJ/pA21DgwFlf3jE=;
        b=d6BtY6iuzkuv1dbxigmTs+o8cQKTaao0TMNUL+h1YRcWi0+w7+JzJ8vdhBKnBb8b1a
         jy8wevOCvcT674NxpQQkskEl/prBgRjVJs7vjO0ZnsmkeLxzmbG6X2W+Ywe+bb6TN/fp
         OcUu91iLBLgM5IjOZbvW6nTzrEEtVQ1D5gZEKyhZ/o+O6uKhXpbZiuoHpciam4Q/NIk9
         taDLmb7QwBlZ5m1IOzHBZXc54gf7NZoislW3fLi/JQ90KtSPxgODvH4efHUFm27DxLeL
         Z2Cwga6TauMDYAWwoZPwHafvUS/H382DzObxZ/R1bsf9p/j1HSorCYhrTYXCxghpARov
         swUA==
X-Forwarded-Encrypted: i=1; AKwUvBzUs0p0Cok+m9j+oBdIeqW4nM6nqz29d6lP0TdSg6KdqCZ0Hes7rEBQzTTosC+yFyYHTQmCdjk62A==@kvack.org
X-Gm-Message-State: AFuF++ktvk1AMy2YZyViqnZr2Sa75Zm17GRFE4ZfCm8ItKCfWkJ3yjXD
	m6NdNzjodBNjTj9WP+EscgKvYDOaPoMmIwaQtKOgwZpbrjnvsJwEbWw0
X-Gm-Gg: AYBFou1lejq848hRh1JIu162Obewy5DGbCbuGdBWo7JLYUOwIskgtviPKP9eRZNgt4e
	i2Pxr7/MlMZhlnXQ5/VYORz8e7g33oNn+X+g5Zqfy5fIRtaTdqyGP8RTH6acVW4gnW9Xz6cRGOF
	UUKMD1ln83/dIClia1J5IhssPHlUsXlP23HSzsAdk9F56m4M5Wo4SLCsRGHQ8+QsYhAqk++n6s0
	0y9gm3TI05Ul5xy/DLWVzz18apZGbXRYs1TUWQ22TDbj0BV32A/4HRmFfqwTh93x5kaA+h/3weN
	IHX7/OLaoVC8j2n52Hqgqi7icATAvj8IyhcKfsfb7Zhexa/cxuMRVNBu6tA1cTEx8R/2u5TJ6ac
	3CxCSTgOGS35SmVMZo3blQNpqYw5PJR9vV5sks/AMfaRGaaBxypIEroJSNFRKWmW3/7w7dwQymY
	3a//R0c0UTdlzyQp6QeTgTAV7lomgLOm/8ZJp1UlcueF1l3fyfrcj6zUvFJIbPbcyuaTXzXLyAA
	c8FbxrB0wxfucKA3uHGvcXLW25T7Co9L9B5zpGmQ40eJwoo04EZAOUVIt3QybLQx1KCzpaTg6wx
	5HknR98dAXOc4JjQc7W/+5mBTw==
X-Received: by 2002:a05:6a00:440a:b0:869:ffe4:47a3 with SMTP id d2e1a72fcca58-8723969271emr14424224b3a.20.1789635679950;
        Thu, 17 Sep 2026 02:01:19 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-230-153.dynamic-ip.hinet.net. [36.232.230.153])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-871febdd0e5sm2438675b3a.4.2026.09.17.02.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 02:01:19 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Aristeu Rozanski <aris@ruivo.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/gup: batch PTE-mapped large folios in gup_fast_pte_range()
Date: Thu, 17 Sep 2026 17:01:14 +0800
Message-ID: <20260917090114.611-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <e988b0e8-3ee9-45ed-9d34-7b73d86d9cfd@kernel.org>
References: <20260917083747.786-1-aa9736195201@gmail.com> <f8f6d553-d818-4cc6-a1a1-a9c9149a17e9@kernel.org> <e988b0e8-3ee9-45ed-9d34-7b73d86d9cfd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 651EB120010
X-Stat-Signature: zuygxbmmrmu77d47hjxxme9tymjsssbz
X-HE-Tag: 1789635681-448626
X-HE-Meta: U2FsdGVkX19oQQ/5RhLmdTSseOBFJu/RgHm1xuLpwxUTot4orrkb2UgSKiOVwpzrG5pA1AhyVksMqtW49NZgMMiCPshqZ9tAv9AxL4DO/u8YN2nnyd7Y8NLvg/lB20jXLtUPW6DAh0c7pTmug/Qqd/t7lw1rjhCISTpCH0FgB//VhF42oBUzqUEOxajOxOvYfEVao8L5XuopBge955fg82IJ0Kh0qDP4rhCaOItgFfdQmx1XbTLebdBwvadF3A+U05gobeMpVYeRsYWAjljmyqUb4OPCxmm/2gq9uUG9l4bzIWPdkSlteIUOvKgKZxnuJ4rvqR29BQEO1CcEsNZGM/jeOleBP5xZxM7kBJtKJsPFAxeqGr3tDaOv+089AVIg9WaUIw+pgjE0B2fR7mK+mJ5uiRZWGT4ipWHF51DZjyr1xH+1PbmfItKvsy1r7Z3BwqMs4rKuim3Aau+4oV2aK3wS3on+zzkUMxfGixtB/ACc4oxdmtrwP/BryicnIM9ISGkapgW4x2p0imNxNUd3wv14JrSdRm9So21P+sYF4nJhttvprH6y/s3VTm1rgqPxSqARHPZQvbQxd51tDXM4moKfFe1sUy0q21Y6ptopu8PTKDn+WNYX3/bOeCj25AcqxHry3Wy7ctkWZYcUjJJk5oDZnnhJDTP+x5IDn3ClsA9omdGnNrzo/vl//PQxVyWv3n5iir4QO3QR/jhoF4x3qFOdoL7d3PyB0DWvmAAcpnmOnhX55n/4YSdgFItsVhbL29BVM0G7vC8OPAImRwwPQuYV0eSN4eHu3PlG+nI7dKyqiMcXVSxIf8jKm1oM1p//aPUuclaGFLFA4Df7Ofufc87jYt3bj4qZHE3V0rfJcd+3gTpSexUmghovjAAjaNQNZMmJ19tX6wGbxm2UZi+boGTynM+fjGAQW9iG7h23ZAOjLR4BnWKxqfqcnM1+ry4QSwcdSbfKoztFRJV2ldx
 8U7X2I1r
 KOrYvbu3MCfWiFEQWpp3WSutFbuQ7d7zI5NxQuPwTEKwU4uGQweh617AGB+g1sCmV+ne3kNrdajUE/dj9xqGREsM3jPAljhOqxWHmpbkbUOWmTuRvB9Gf0kyT+OOoFBshcoO0D88Oi38zPR0dZoExm3+w6sdnZDp11J2o5C0Wqx+u30m6NeOjGcNiDRSvvcxZ5dHUGGWle8F740DWMk+x4B9iOFni93NwdXq4CuZ71JeI1U7YC0zC/4qwUm6e5DK4A/y7IFIjcv1U+/bF5EzNabO0eruaoUs3XPOPoXkv0sm6WhZTHgeFqHTPUuO12zGnKYPZO6XsV0VZctKwAP76a8VHZAT8hno60xh1YjfkzbP12CI9/EArBkYKur6lp+JIo+SfZbA7rMe8CZ1KwRdaQoLeLQElzMtm3s11qEsgcM483A3iwJnoQs7vYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 10:43:22 +0200, David Hildenbrand (Arm) wrote:
> Ah, no, Rik looked at GUP not GUP-fast. So I'll have a look but it will take a
> while.

Thanks.

One note for whenever you get to it: the patch is against mainline, and
the last hunk has a two-line context conflict with Aristeu's
gup_fast_*() cleanup in mm-everything (pages[nr_pages++] there).  I
have the same change on top of mm-everything-2026-09-15-07-39 if that
base is preferable, and can post FPB_LOCKLESS as a separate first patch
if a two-patch series is easier to review.

Yuan-Hao Hsu

