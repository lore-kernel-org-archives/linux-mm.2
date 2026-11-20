Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83D6C60A2620
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Dy2k39+V
Received: by kanga.kvack.org (Postfix)
	id 8444F6B05B0; Fri, 20 Nov 2026 14:05:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5396B05B1; Fri, 20 Nov 2026 14:05:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710806B05B3; Fri, 20 Nov 2026 14:05:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A52C6B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:05:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3F791C2177
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:05:29 +0000 (UTC)
X-FDA: 85456425978.25.A2E341E
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id C070418000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:05:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Dy2k39+V;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.51 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795201527;
	b=zGsNMJv6EvlklwXQuFFc2C04khVFi4LBDuiSz+J69A/LHnbHYTofDYEiJNJm5p5M9QoFku
	6ku9qtFmEelWkHLy/vlbUdfqe4LwWVKvK2oWbA7cHAPS4bRBAlb01suG6tujC/il2LPguy
	J2WqsL74a3OgQO7Ip7j2ttnNea67PaM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795201527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2bBvR1QxOsCaUt0RYJzY4W8RFF0dAdEhClCcOQk3Dk=;
	b=diLPw1EVQHvc37ZuHeuOpBW1iDKjYd2NwvLubas1PHerdqoa7GLC6QFhEwclfig1aiyRwZ
	9VBi5Hi1d0buaQsY4UPPti2Wxb3+psQ5ZGhBsJeLklR0h7ZG5SCA0xAAjG/8O73hWAaMOw
	yhkQqiZc3KawGCVjDF2xWmMfYHRXz3o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Dy2k39+V;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.51 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-91e8a05ec5aso16685826d6.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795201527; x=1795806327; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X2bBvR1QxOsCaUt0RYJzY4W8RFF0dAdEhClCcOQk3Dk=;
        b=Dy2k39+V1QP6rA4tbFjOcdAuIv371D/4dpxXx05K8L1kuoTSqKvyCsq327mw8WBfLK
         BcA9JnqKAalDyPKbIR36WwcbNbCvknawDB0FeM6QBwSYXH2q385uDp8oOFc65KHOpYvk
         BDNjdz8LbUjujV4agWvK7WTPnLlk4y7XP7j/53A11u0S89ZOjWVzrkKaTT5SymBICvP8
         IVciO7gwc0rv625Spqnpu4rGBRl6vJxfn8ljE8A9dL5fFIhX20X69KzNwblUys00ipJW
         HXbk5UKStM4IZ7Tvjc6VkzaVbwMJK1o72ZIKQsAksgwe+BMpjFRPNyLi8Wd0AhFNBAK1
         RrTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795201527; x=1795806327;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X2bBvR1QxOsCaUt0RYJzY4W8RFF0dAdEhClCcOQk3Dk=;
        b=0eu/WnoQD/me47oqVRPo5ruxoC9u1a98SoBgY8XdMN3PgSWtrI58OIWYwg4MRlgdlJ
         nmOEXxI8ugNchVfOjRw0ZQS1Bp31FmHgZUFeNUppBV5wAUsOw84GM9OOkVuzaqDfVYvJ
         9g8jMhg2heKejk3tUr8tg8jnmCa4sobqLfIcIXhwF/XSB8+QlvB/78/5LYKzaL1zJUT8
         e5axIbddh0VpTdSK0/zW7eU4vi6YmgYNOo2CdPr2aHIEJUKUwhpQglONui7c+AbFZ1Ka
         17eOzriBDS5qwJCoKg5hkgzWNA//qrdPDxd3HjRTpbDwY1AFmcWSEkSC77HUNgrsGO8o
         sTcw==
X-Forwarded-Encrypted: i=1; AL+hErHerTxSyZYbjlwPgdaWQZC0NfumD1DcEe+4did39/bgg+rDCJDjyHsY0asQ59FpJvJesdE5wvU24w==@kvack.org
X-Gm-Message-State: APuU4Z8iwYQGun5pcAjga0QLOI6Ux9xEnnM2ujLbrHBUnYEGZhb7Tj6e
	yBmA9SU7SPsF0TyzhSkApymVkrY6JyKh19MsqB/gmvLEuFy+GDS91jn4QGsn9+bMKqs=
X-Gm-Gg: AZFdTZfuwJVg4B11EiE8sHqZaTQWHiceHSwpUw3vqMw+ZX34DhSSunh+RbAZcX7Z6gf
	0DySZR9pYDmJZagNSg6Bhx917scLPFngYnptRjUUwpRsJpU3O+voS4fJWE4tx4ymZ94qqODHAhO
	XEsP57MIttTWTVeAKfto1MURBIXxWrFqePCAp8zbis5QKW1F9g01VV7xtPdtFGHWoAs1EQoNdyA
	ICEpcXICYJSG5pDfhTjEqzghVT5MbCCR6PQhnSh0SGHpL8iFF0hL6b9+fsM7luzO4YZmCtENDNm
	2JWO0sNiNuxMVQhOggqbneBhMGYfdA673E62a+ebGT7bBJHkv+sRhBgQGmAoBnvnv8GBfHLMUc1
	nb8GtIsLQeJJEFEM7ihfBsYEAYLhXzfkNhSc2I7n+uHlrFSj64JB/KWSFZ2NSR+APAiXUzcbyl6
	q2hoGsU+MRhHMu3bQq8+XD71S3BpT6rzpXXJxL4kzK1IJjh5qwo4NWVFk25/igvRoCAwKCY6jx9
	TCR/dYvyxJccuotrV0N3YMi72VWVz+wkqWMgXeumXERnxzh1YjJxLSVNbn93XCby2Vbqvz9NS2C
	jR9aiOJRmUiTit07fPzRM4euKXmi
X-Received: by 2002:a05:6214:acf:b0:921:231f:b614 with SMTP id 6a1803df08f44-92134b5bac0mr71317106d6.39.1795201526852;
        Fri, 20 Nov 2026 11:05:26 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134bf848dsm32999036d6.44.2026.11.20.11.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 11:05:26 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xUTvJ-00000004nGK-2Csw;
	Fri, 20 Nov 2026 15:05:25 -0400
Date: Fri, 20 Nov 2026 15:05:25 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	will@kernel.org, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH V3 00/14] arm64/mm: Enable 128 bit page table entries
Message-ID: <20261120190525.GC1133597@ziepe.ca>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C070418000C
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: nocchdktuxzb3iwpwuxsfz5dza7x4sox
X-Rspam-User:
X-HE-Tag: 1795201527-23164
X-HE-Meta: U2FsdGVkX19PEovfAxU/PAf6b8RJ/Y2gX0KY9AM6ws6ii/a2ocATZ7lbsqwZ6e3FM/+2+HNqJ66EdbNi0KDcM0WVE0fHhIpIXK0EfaMGcCwFecFsqtANxnNHDpwAe+SFBqbpB78hK659CArn9g3zGZ5gwUUrHlbSP8J04ch9WnxV0TwmZGYb72O9JxvA2JmYVtxEuc9ckWahIn/bDJQxf3XAS1nHd6HQ9gDJ4cOOmHcQTfkPTnAFba9gYX+LQ913sKfAiouop0HP/G3TA62KeqB6vFSCiWgsCf5l9MY6zaRQHQXEVunXkWv+CsL6PtF9EZIIhf4JQCQ1PkQOyZzuM4JngX6EFZUhHeJ3uUwsUonFAtpl8BkTXjy1WSPjN+JIz+8Y5K32SzspMjBAIWg1iv6vi0Cl7RNLtKCzDAiqV3a/tUZmhAtGLksrPTQlQ6PViUrns8PYpRuR1H4GG4GSXm2KZ24NH7ZzwoCRxVBUKtmLcYulfCWJvFXSrVv8dn+js06tIxBWda0X6a69HEUawoJYGo3GjqkfPuoBu2w4eFbRZ+DLFAzzWc4v6cX68EJ0ajDcTbBbRB/nrrJZ9AeXP02p+QV9BtCOUMX2Gb5Jio8VNFLixYTU32iFLxm5urDQhjwj1wlZZdZvTdsAGLi3aiYz5L6cl41nSH9QFB/ge4+ddf6JnlDqIdVlbzkigskoeo0if1dlgLdXy2V4OW9TW24ULuXvmSU2TyD+a21A7H3tVzAkZVVjT+/QxW4oXe8A7EFXhLL7N4/zgdpahCkjojzBtRpqYhWE6PKzS872+dmIJQTQAYTwUo2jyvCOtIIpgxf/Qq75GAzaBQSo5fNqYv+frOGdESr449m0tLM0P2Ii11hCicg56JuZ7VzxOY0PSDg1DrTsTvfp3BASVEPStjDlYm2ZdYWN5eRLf7AmIDSgfv34cFAp4LjawtWoEayTFm1hDvvE7oheXBU4oqz
 4hd00StW
 ie+W3XhhY9tjYsbHlcGun88Emzt+Z2QsmpIUSfRYIl3Htlm4HH2nrmB7YAwOkJ7eEY+JTpSKe3inxuOjZp1bOEYFpVsyxlVUAuTjNWKFNZkwnvOr4Y5hFWC1HdNGDv6FE4fQsaXX7Qpkflmza6UkNpVb5Uos7QqFfYzWhFKLJR7jWzRGtYwnPKIrwUEIg4hnR50etHFPq2rK9LiW6RygFCnn2GoAei0bP5m5opSghPxG97pw5GTmz5Si2FLSahckvRpG7COy2yo9dPmsQ73CadvcEoh6yHUM8O6KqLVr+GSH9ZPOZmTSGwpJFV2YQH2EAeRv2gnsVBBozNxKLUFaRrTpth2QvFSFPDWexDODLmDRLuK6JAgljAmE0uKhhEOjr2ZckKqgiT5kqu0ptJ+iDRiYixUUNL45yV5f37h2mPDnEb8k8eqLY8AZc/Mq0rIn1Ib/fFlbEwoNKbRH7cf30J6vV8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 12:35:59PM +0530, Anshuman Khandual wrote:
> FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
> translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
> arm64 platforms with FEAT_D128 enabled will now have two different memory
> translation systems i.e VMSAv8-64 and VMSAv9-128.

Please don't forget to update arm_smmu_sva_supported()

Jason

