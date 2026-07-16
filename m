Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0771CC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64026B00F8; Thu, 16 Jul 2026 11:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3ABC6B012A; Thu, 16 Jul 2026 11:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51306B012B; Thu, 16 Jul 2026 11:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8FF46B00F8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:07:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F03F5120199
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:49:50 +0000 (UTC)
X-FDA: 84994772940.12.B197194
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0D08980005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:49:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QTSwPEhF;
	spf=pass (imf30.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209789;
	b=XifYyLX4dvvXXaHoj+ZovQ5tzMcMHNMfzX+4bFq2pisp3KBMPUHaCvyS6kBOITApqueHGR
	KAbimxY+nq/tByCgGTjD7LheHPgaNE9Bs8dzSJvfPci9lweqU+M6PL30gNKfh8/ewcvsDc
	LxGf4rLLxJ7eVJkT/FJptxvGkonLc3U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QTSwPEhF;
	spf=pass (imf30.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209789;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vScYG2QJnyI+tkgxpycMRmSCEQ8DczUpqBlvkLv6eJ0=;
	b=oLhTa1Aw1QvTwe4ECmgSbfnwIvQPLDXRVy9AGjRSAFWRyI9MMA3kBg1K8n/uewGlvrjqNG
	t0aGiZKWfjOafw1x7N+kPXXAv0+6vNI/4sqkZL9MAy+Dwdf4I4d5PLvohlWT3+1oDv/tDS
	SZEQnxf03b37T6RSMzgcudjIxdj9Pv8=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-383adaa461fso2393370a91.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 06:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784209788; x=1784814588; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vScYG2QJnyI+tkgxpycMRmSCEQ8DczUpqBlvkLv6eJ0=;
        b=QTSwPEhFfV48nf/9E0Zs+QCEisuuuKs7QvOcCwI95Lkgxfu16X6VVZTWe4u0EshUWW
         YCMOUFdmwkIDspzTxdFv0uuvcbul6/TeW4hYG9bZhRRVJx5st6uAXoSUmWqKK8s4D2kP
         2rNLxSGJ9EPUE/jK7QWugZrTyob45Y6SCNeEPLQ/U2Wky5EYTJGU9bjp/96IHOvy4UeR
         PhDG4EUHpYgWjfeYN2Rb9F5+wX5kisKGX1xNXlWj2do6JqtTnpQDQ9PuBpF4sSHyl/hE
         eD9ti+vPX4pJbambuWYQgkRyQQRLcBYuB3+Z4ctdbpz3HWK4x+kdk7v8JVsjam3624qZ
         5LTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784209788; x=1784814588;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vScYG2QJnyI+tkgxpycMRmSCEQ8DczUpqBlvkLv6eJ0=;
        b=gZ0EzD34LyzjqcZPSACDy4XDHE2VlqjiFDPzWLStKuHT6R32aEZ6eGErNFXIKO2QAT
         OuDpEHGC6jeJEsqyqzxSfUPWBjJaVpNG5B/uQrO4BsxjxQUmFFSNEQ2aWoeErT9ovpQ6
         HXnGQEOlY8RYBDIlxnuFEsh5sqvJhC5S/q2KLwqxIZXVR1mpKo06fMsLXV91atngYfxR
         YAo4XOyOoP4f2YYq0reDasK4vsYJFa7rXvQWNZPuGKtb4kzKX2vun/WoPD7bPMFCC9tU
         2ipVCV8Mee1MfydLZ5/bUyhLCwiWWv7ywL+9se6V/1L0T63Dy2Qj+fZluSLCEwAtPJg+
         OX/Q==
X-Forwarded-Encrypted: i=1; AHgh+RrnzkxGyqENclULPZBq/IkzJhSDiCfGDe/lYciTRXeRyBXnnhJ+Q2ldyV+c5wDM+mYYxNDKk141AQ==@kvack.org
X-Gm-Message-State: AOJu0YwFP8e4TVJWaj1PO0OFijNOi/1/0p1j2k/5c6wbYvQxvDLLycri
	OCcOqASSD8m/00RE3GdaqpYjnBx1rJ57OPn8G2jvpekZ6h7jCeK2zhxd
X-Gm-Gg: AfdE7clRb110dFU/kU8aLl2+U2TNBxzEjLZfu5DeX0bRo8Po7tJpfMQYVokc29obCSB
	bI+QhYJFjy9XrePxCYe10S24ddlFDiN53eJBCnE3zTH5AcDItJ9mOfjweVZCa7I8XiocCrE6w4W
	9qfutjGKZlZcDA5UL8kfWP9qLVEyt1/5bJQ12lhHf9/0+drhLP23v5scJomeoCBt2HeSJAOY8da
	iHdYrcd2PLxXatqINvbmDqGauHDLXQkJ2sgau0LPxcmpPbOVAi6n011UfTePnA0G5BZLbHkVE2C
	5A1wu5vHOqv1blKwTKbW3SBFb65oI03EdF7pve4kMerrw1D6QghNhLP2shL8O9sDLl+JCHZY9/C
	YEwFviTUGg2fjZtCweCNuLrZ5YwkuopLUdqRPxlgHbV3q6ud3pjdZUmqB1NOeM873YffoG65iUW
	s6h2Wc+2O68INw8bIGnumWDs1PV1vjIwfTfiEVk/ZLbFMRS7K8fe4=
X-Received: by 2002:a17:90b:5744:b0:37f:9cdf:f03c with SMTP id 98e67ed59e1d1-38dc7b8dd32mr18772730a91.31.1784209787718;
        Thu, 16 Jul 2026 06:49:47 -0700 (PDT)
Received: from localhost.localdomain ([2406:7400:90:2db1:9c31:f107:8086:4204])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6a5174sm12776550eec.15.2026.07.16.06.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:49:46 -0700 (PDT)
From: deepakroag <gaikwad.dcg@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] feat: scale vmpressure window with machine size
Date: Thu, 16 Jul 2026 19:19:38 +0530
Message-ID: <20260716134938.42495-1-gaikwad.dcg@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aljYxLusTzZkTfnH@lucifer>
References: <aljYxLusTzZkTfnH@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0D08980005
X-Stat-Signature: 6ahrmfy737rqqtsckhpt5xcswgi49i3z
X-HE-Tag: 1784209788-235501
X-HE-Meta: U2FsdGVkX1+HihgdH/RIGySr7zoeASmIkulPLpN/WH4tUENvpA2HgTXTREE+WMP802b8c2Ka8GxlwEvlREiPeraZsaPvFbBmBgVEjGJYfHaDUhPFIhtWrjMaVf1gscZM6k5PjN0yqamracg2bMvjY7yi2AJ4h9WqNoHMp5i2tHdD2SfS2fbqEOeqrrpGxjJf/kZwRaERtxaauGO8gQh4rTkhxB8hUtYvbvIpTQPB7ylDoTu6u1xMnsEVgTdCCduR5M7YWmfYOzHFAV/kp8kZu0NWbirTtMsMYAZ7yRaa+pJr+uDzjzKovwk1g9+9RTgfgRETpseRo739ACyWJSIW3mLc6tBBn0ZXjhV360z385sJXNESBUeeJET+Qd148DgG0/KgzPbhC880zQGX8AeK/HgMpXyqID924QdV+D+LI1RH4y4dw3kY3YcEL7x/uLcDldqODldLMULLlX4BYDt24f96zBEmen3FMI9DBdgH164MAGmt6/fTKr46h7SNhxDrjMDZhOH33GfpeHzR6JhMLDRp8IkHVzIOCPB90yU+tAJTqXlF8uIHnIp4VQI9rtJIC42YCns0Kl49CAMYMLB5euNGTFtVMKxTwh/wVo/cuYWgSlz+mevdzl38p117t7iKhYzJo2lV0p8JGJUpd0z2+FyiPXf49nKN1miuDto4cDoy/8TycuF5D2hJ7XY3aRwbNTfWKrqKTJc/DNa2A3bgzn1lB7fq9RLiWUTxPToqg+Jp6o95EZL61mP3/IsxZG97D1ufyCCIT93xhXc/3vEtIuI1cXqqViKsLO0RoN9SZ+FU9nA7FkZvVBCxASxk145Dd4YmyDhM+w1pFQTfWRAgbrLiqA5NXFaFrrfk5ED80WyzMVdXmWQ9rdMF59bEsc4BU1b1xktBfZoaOzcgMO6RhpkayYo7fPWYLVQfAzPFIj/uG5XS1+Oxc754JHmy8x8BqQ9sb+/k7nQZuYcn9PG
 HC41UPZ6
 e71CdnmpyIWn3T1NJaXHsfeDrdbTnnNighJBFOgnu3qs6v1Dz8vXVSlvaWP5NjcaA3OKpIILetZtE6U50tpMKUyEtp8OGisKcKuuNjOfwyji/+tlbPy22icC/67ihN0k69bRb5go5C/SpdgdD1tvNYSQUx1bhkgh1nX9GOgJLY03adXoB1LaEGBGL7JVJ3t/uQvzSa6A6eoWYEMHYWf4H7tLgz98031ZUOmJEAJfpBqTv4cD7YP7+d+rXGhV8Tpw0ZpwXgz/aIA556FONgN9UkkD5VYOuag6QZDsEMpAJrUD+n+sE2nfmwPzrFcEVBsxQncEsqXTGRUekL/65mRirrxZYXF0MpBccH5sY/VL3ISX2prEqSZ6BSuPr+AqveGciMcxSyRmghOxhSoEXICc8uf+ElWvJ5mLUDnQ1hmZWcllSgfOnJbhC54dyU6N+QV00Fviuh+hh5y2aghlzAf/cGh+6m6ZlEa3i0aCi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Thank you for the review. I withdraw the entire [PATCH v2 0/3] series.

You are right that the vmpressure change closely follows Benjamin Lee
McQueen's earlier rejected thread without proper attribution or an RFC.
That was a serious mistake on my part, and I am sorry for the confusion
and for wasting your time.

I will not resubmit the vmpressure or vrealloc changes. I also
understand that bundling unrelated mm, selftest, and vmalloc work in one
series, using non-kernel subject prefixes, and sending v2 without a
proper v1 review cycle were process errors on my side.

Going forward I will stick to small, original fixes, search lore before
proposing mm changes, and follow the normal RFC/review process for
anything touching vmpressure or vmalloc.

Thank you,
Deepak Rao Gaikwad

