Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60648C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0539C8E0180; Tue, 12 Aug 2025 13:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BBC8E0168; Tue, 12 Aug 2025 13:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA9E8E0180; Tue, 12 Aug 2025 13:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D69C68E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:35:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2AC6B593F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:35:48 +0000 (UTC)
X-FDA: 83768807976.09.7806A6C
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id D78A21C0006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:35:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gDtldLWy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755020146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QqRiRc8S5UuRZr109N2LH3VeQOZ0mfRe2blg1ehQPc=;
	b=X8G23e+yZHgY7PplrcLoco6em7UP0hCkiHksusk5RvEJjUcSq6iv3cmphc/LtYsAa2PARC
	0WX8xCrbv29gqaWdoGTIH+mOCanD0vmogv1SdRff2+3uaDs1IMjqx0dkHEM7DynofuGy7P
	R9KG1iANaoojC/fUZOlFxN0UB7nHRV8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gDtldLWy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755020146; a=rsa-sha256;
	cv=none;
	b=rNX5xHlrrNm4uEqCKU91LbfW7QPM/YDqiQQPDo/Qe2hOclJe5c7O5qhl1/yLEt+MVTqJYS
	DBezB61Myku6Z0ttLmuMUgiC4iDZKxY7s5XJSqCwpc+sQk1aqTbuTspPboXzktJIKo8sMu
	Mw7yh2s16DiHHqL5S4vJiNKcDYHIrpk=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-74264d1832eso7177376b3a.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755020146; x=1755624946; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3QqRiRc8S5UuRZr109N2LH3VeQOZ0mfRe2blg1ehQPc=;
        b=gDtldLWyACpZg5A2qkgZ/B3NEjq0vxx3EYuihKBUHfbZNUDKfB/VF1xb8LzIi5MaKI
         Xdvpm4WY2IH1L4g0zk5C4V0X2vnelhbmOtpIWtYuU37sEzbx/4Tw40mTpwRXGdsTCioi
         wFGnmUzvfX05Tccz1MQ6aRxThwokM/jUNweo1z8j3G6r3Ue4EcGmingkcn9/ep8xMq24
         zmgfEZ5KbzTKw9ksjBvW/nnBrPptWq0++GFp3oe0Vropjt3thgqiyTv93J3xiCkJ0CAQ
         ghxFY281VqistiCXbnRFmMV9sdxDJg3oog5CmM/XghU2mms0R9crMmPK5xvPxZNFCU5P
         79BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755020146; x=1755624946;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QqRiRc8S5UuRZr109N2LH3VeQOZ0mfRe2blg1ehQPc=;
        b=FrD7W9CT2lKl4Q5xIMC1vYY1cH3zCG+aB3ITmBDj+i9hTQA4GCMZKTLSlE76bv1OGw
         r0HxYxgrg/U5/Fd0YJ6gOcjOc//MgzPF2AH2eRLB4DsBVMfSLYxjFl9/lGjp2rNxHew/
         yT1hRhHWBG38IiiZ8E2sgZ4WKyjsG9klyvKfvYhw50WGq0oXvaqb/ryw2D601l2s1jbQ
         M0vxgM3MYys7CP05em8cgZq7jFmws5QYJ+wwVPt5bmScukmPvRgchpXY1fUBifvVzGVH
         aR9Dc3Ia/acEtoA/yMhzTIB7BLKZkd7z0mKCAaN2pQrAjkhEMWT/gFJWcU8bOJLIems6
         qaBQ==
X-Forwarded-Encrypted: i=1; AJvYcCV56tCduVMFQHwjgvu9C9F+Y+7XQMRWNS2V7RS8S1KLb6dhg2f/Zn0PbjUfFUBRCQMj2e2E4K6N8w==@kvack.org
X-Gm-Message-State: AOJu0YwIB/0k+F8m7pMqq3o7RYjDh3ixzbBkTWPWZ2Iumm+vlp7N4l9c
	536pkSAVtf+9YuLSvsWXh5umNZAtQzvwesCBFpuOm1hUrnH746FRfNr2
X-Gm-Gg: ASbGncvfhcdPDYzpUc1Ipw4bzPc8M7OVBit3G+wrbkkdC/jBtUZwRYhrTtMDMpkhD3r
	DbixUAsOFKMW41LQF4kXGqAH2nsahXB3sKbq/FPycKXzJzGF2iS000X75fTGcTlJ/odOqDmBxBI
	wkUBPXRgS3YIKMqlBBxpwluA1V8e3Y8niW9EPaVjILhcxdEx41XCI3FFxaWEYydGoSfkcH/ALWQ
	kkeNNvuhg82u45GJDiZJtPduNnMYWvIdZrwl7dkkBRXpMTEKF6BYM911wAqUvtDkEO985ILsDqk
	X74xGy6Y3NRr6pb+qDNiaD+U/VBqLpLYMKP2tSCneAJG4B4zPgXaSe9eD10XTP79rMxjHrKowIW
	M5kZ8L1490kHxEMnu/QdLSl+CxjAaFPzLSbAbPIFDZkaFGK2f24j1tg==
X-Google-Smtp-Source: AGHT+IEOQGwikHmdxCwnSLSNmqiAKdWaAmIlOvX98dKTEa3j/V/1mLnNx7izZ8MziWVIRtrOO5jPPA==
X-Received: by 2002:a05:6a00:a17:b0:740:b5f9:287b with SMTP id d2e1a72fcca58-76e20c9a0f3mr83634b3a.1.1755020145514;
        Tue, 12 Aug 2025 10:35:45 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bd9795200sm28297220b3a.114.2025.08.12.10.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 10:35:45 -0700 (PDT)
Date: Tue, 12 Aug 2025 10:35:41 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] mm: remove redundant __GFP_NOWARN
Message-ID: <aJt7bYkhuRBrIO_S@fedora>
References: <20250812135225.274316-1-rongqianfeng@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812135225.274316-1-rongqianfeng@vivo.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D78A21C0006
X-Stat-Signature: cezzjn9m9ai5x34kyp3n5knc4zpaazu8
X-Rspam-User: 
X-HE-Tag: 1755020146-851508
X-HE-Meta: U2FsdGVkX1/nKh4Ur/vm5+ltTTDvGxexiKb9029BsEeGcL6wCwiO5hr7LLrX5DhvfOSKn13aiAkAwZr7qe0mZ5+HIdQj3VL74gWs2mp0tDYDzwDb0sx4G+HIvIgtGJVLKS657GnslIdQaIjp2HEULsBb913CpofZPMRzs8XZEFQaZHeug5dL5IjYeBe4ezry3MtQEz18FtkLcWoP74Bm71tZlgK2Q2OKX/JaB4dLS7AI7pmk9Xujb4s5vFHiRuV+sIJ+Xk6jfFcZJNQs+EqfZkMmqUwzInQQqXvx5Pz6/xPCO7oESM+mH1Tn3vr6xJij9lxv2KIM4UeA+NkfPTj11pTlr9ISkoZj/x8Q77nnxRq7l3PGdp0r+RcQ/F7MxEZdqteuF8VeywZ/BC18diDlQfHgwO6Xe1uUmEyKAh637bD2k7/mSguK6959qw/jQeWOGDC5Lu1SLkxRpKjgPPuCYbUGDITF9VRfmfSa5c7jnBNQEDr6rl7kbmF4OzmMIod6L3G1HdUgKGx0HUrIFAtIuAXaoHes+xv8M8ZrwYrW6M2iE3oIsSi69Fc7IJc6ZeYIfPjgO4QAj74aI7aGQrvOlLPIQ/OgkQmRcYVPyaFYGhgisZczRcQvvPuDfdSfwcHs7yHXybVV1jLpTG0+fi4iLe0h848vEKJCbop6m/ay1LA8V3hhAxKlc5kYdz0JoXXdGDijgaFNurnIapEyWNQxwhvnBDYyuPbg7WiGqSW9P4YqsYF+Vw6UChPpAV+j6CrPNi7gsiJxow998ghFJ1x79uB3ArzoxA7Utp82RS6A9mXecorJO4IAdMvVk7ozq4EPOJWlWkNLCH+AhrI4m6Gti1ES82hwpEyNMo7LNPKNoBTnRahF7WnTB4mloQyM+MFUUSOTnSGHSiDGFxpSu7t8LGCgD1awzpkeBboPkLCzPOMOl7AFBSPgYJty5pp6y1OnRoVVv55itPCeMG4Hzpj
 RzbeSUbg
 7iNwUtBuwwe+UJ906dDgMIOzfhpGzguUPRdYrMuGN2sjn5LNJjfs5yhFssDpqF3fKDzQKN83ZNK8HSPcHluZDLrujMiMu2kdnSiAsA+DYqMGR+jsDgUtNPyUK26uGzWy3nNvDclf9yQN3VFQkm5nAav1qIzneJv6ZS5YULcuMYP8MuGxP2NPlvYuuoJpszIwGEmStupSiBprnkMp4m0jQ7OM7Sw+pJm8b9kKUvp4CmDj8AWwgkOAySxkjOKOdu0Ptu1LwZjgX7Qp2xrKkUU1i+kkQ60bMf7GUO5D3vLXi6Xv+Tx0Dk6JHr+qhiWAmm5KaLiMOX5dCrgnitezAydVLt99D+c6iJ8E5u7nZg9wM1QpDtor1LSbwCSh0iLsfBY0C1rRpPC5bTxaZIOTnByfxi2Fxf10uheAxhf56Z3wsJF3XoCBbVsXBeZu1BAcfPik0lDz/5KSDSNtq/dCLO7Yig2vmYyYRUUsdejTSiCzD3IIcBbgqRVq0QTBbSXhDsThqyh39r9UOWGPiwMprdpcHV+vOXi3ahirM/8icUpH5ZfbP3bogYcicXk/W8CO1j2ht5fX3MiMKnqcWqlA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 09:52:25PM +0800, Qianfeng Rong wrote:
> Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
> GFP_NOWAIT implicitly include __GFP_NOWARN.
> 
> Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
> `GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
> redundant flags across subsystems.
> 
> No functional changes.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

