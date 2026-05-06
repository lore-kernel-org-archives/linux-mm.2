Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 263A3CD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 17:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2733B6B0005; Wed,  6 May 2026 13:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2243F6B0088; Wed,  6 May 2026 13:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13CE16B008C; Wed,  6 May 2026 13:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 030646B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:07:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34B148B9D9
	for <linux-mm@kvack.org>; Wed,  6 May 2026 17:07:57 +0000 (UTC)
X-FDA: 84737627394.10.AD3D9C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6C8D14000D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 17:07:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FAQouR/L";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778087275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0LrTCM1q5pRPs233Br9+vpmc8ij03vv4TyteHj0Org=;
	b=05Y5450OpoQI9SSPNU7IF+G33KeC46OCthXpvz2w1tKptq6EMDgeKNR7S8yR1ff6n8jNpv
	HwWnDfN+GzQLGe0JdlGTOaXR13hfQHjQ9kJn6AcxbXtFmY7LoXjyue7x6rIEm+P34KuFfj
	dbVg9M9X4aizAaGOFIYIvQApFTt9nQE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FAQouR/L";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778087275; a=rsa-sha256;
	cv=none;
	b=Ff3EQ4ryWduPa40znURuQ/Fv3V/5ynNxK+Sl9plBv78QoH8r637dNlT/5bQfHhOGj+FQbl
	sq9byICZb1kbbzU5MnjeeJhexmoGwvYBupV/JspKrnL/yxUjYz748T47BqJ7g51m1L2kJu
	ov2gkL8uxe/yrMg08nz2WuFR8juF9kE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D62FF6024D;
	Wed,  6 May 2026 17:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E615CC2BCB8;
	Wed,  6 May 2026 17:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778087274;
	bh=+0LrTCM1q5pRPs233Br9+vpmc8ij03vv4TyteHj0Org=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAQouR/LQsRBkeo+uk40wP1EPH2xlzx8AmIfyExgkguDNfpZN651Tl70YXHVUaoMe
	 OO9rehcTElIhWOZEgPz1MCk0sfL45tg8witfe4ouy0Qf4dvKB3fF4fQ5TrDAk6lesY
	 OBZvi0WEdF8Jqpv0FOGeFfry0tQB+hXNDbebpEV7f0R4XNHhD11WcoNpP5IRHLjVeI
	 /X+pKt3/v87TZTVkblyr5rH0gz7KhbceI6YmC0JNLSFhPVn3gkRKtdwpwkYyojj5nH
	 mp/LCZ1T+SXqrZwKTt604htee0Et+qoHnvOWp+3PwnK58RrDDfBI/3SmwB2EzYtkjv
	 MVtc9cLw35t7Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Data Access-aware Transparent Hugepages
Date: Wed,  6 May 2026 10:07:49 -0700
Message-ID: <20260506170750.10764-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260211050729.69719-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C8D14000D
X-Stat-Signature: kannpz5eh3g5amcqgmoi9fxcngfmm6yd
X-HE-Tag: 1778087275-696856
X-HE-Meta: U2FsdGVkX1/jll6lbxRfJJvHxNeGt2BgWZ/qbSxK6/e3kGnNcVGZVG5uE+hrmokH5rhRvTDZYWLQqA61MkJHhMLb3uivlIr/V9pOSwmdCw+fdmnd6m06Fn9KrBElAiW1/l2M8RRErWvQWxqVCVe23zybJRlpOpUfK0q2riSusMGspDQ0k/V9P+zoihcuicvtx7+hKQCjg/EjQTttPgG/pldttD6WZ6WIMywzagGR/fPVjs2NwitzTcBgqNszWaMsRgLDz/N/tix7RYgaLJe+6camFiBtqNTpEEw0lEjw8Ew+RM1tqoCTh2wi2YeEcgel8fsedI9rcvslyyCt8fjT3MPjw39NuDR8GjfpvQJiT3Dacx00lmNVdgXcYJhYJwYyYRvGJkGGRO/XgpekRnveOYx1EV23enYceqGqWsGphalYrLHcYg/tYFUyyZCf9QnKIa6LVdAbG1K0Jq2lHDy6WpKuR+fU7sLFoClSnHNrJmMh7GmYWfpM1PtP2iQeyx3KAn4XVZwQsN6NCVPpEtkdZkaLbW5qrQADJx5ftzGuMy+zpfLsZkdxPeCIEzlmiXML2CcoC6HAbnjg9Ut9N4wxV9ZHG8AaRHg1K6uEh2BMZvaSrHdWYoNIl4QYEZb9yTVRrMguGmwWKPKFqjiLfVoLZ2e1oHNhugNW7y+TdVZ37SW2Cw1z7hjl7ouGn5clk8n4TlYQKFUVjWO76hAQMARfvd0ehWt6E2+kzZb2yEm6rs0aVTmFOqn4/miLQHJVqhNuMjskm8BuINUUWcIj60dDkaW5SjRxPoDaqd1ZZ87zGYocPmOCE07EmfokFXNCq0BQIFA57Ci1gGx0Stp1bcvkHESro1nXkoiTPtQqYsoT0fHDXVQ7tZ0updiIUTzm3eH9JUUkdjFwkwzIS5XwPOGPFtWb9sfr9G+LoFjBAlopVpfGuu81StV+zi3sdX/tAwxwTzwsjpAYFpFj2rkEQZl
 rSxPZN3J
 sBQaxh7PpliHY63OO20MOuWLP+mcYZGgfn4k5vy9YRH4s6JltTMhQJZZ/s+ab7131MiHJA1SaVoyCGc7BWyMT3MHilIv/mvq4aPbMpQPawxKEXJRRpQG0GgRCqIi5qzYKQLAGyZB7bM1o1TQJjbDHKPdYiqMqG73g+YYO/ZUmaNKL8numZjbJyE9l3KA76U3Jx3QU9ZcNgNa5/orePlYj1rVIh7svgFa76BpFVHgro8Qa1s3DrlVCyp1d+dhU5KuSRGDQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


The slides for this topic is available at [1].

[1] https://lore.kernel.org/linux-mm/20260504070208.7106-1-sj@kernel.org/


Thanks,
SJ

[...]

