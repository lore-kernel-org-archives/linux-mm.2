Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03680FF494B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 06:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED7F6B0095; Mon, 30 Mar 2026 02:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5306B0096; Mon, 30 Mar 2026 02:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC8C6B0098; Mon, 30 Mar 2026 02:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4ECF26B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:21:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC65413B962
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:21:50 +0000 (UTC)
X-FDA: 84601733580.02.C970F79
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3ED5DA0007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:21:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=elxkLYuP;
	spf=none (imf15.hostedemail.com: domain of BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774851709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikemLe1zJJg1roIqdakqClvPR+37mkaCzRu/wDT4rzQ=;
	b=Ma4C+hVPf+gNrytta30AXyhU/dEecmCQGVlcVkoijTEuiVGXzahvgp1jfI7xzX0vadCuxF
	wMdywwaHBy+KB3oKkFGKjpRi327uNvwr9Tc8wenhP5hfapZWl6SSVwVYq0lEfMdW3S59ei
	xpL+IU7bc0zXuOkZgbGKENwKhX0ejQs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774851709; a=rsa-sha256;
	cv=none;
	b=Ch3Q0KCNkA+lBnu3QAbGh20I6x3QF7aOxTgHLx54U01PTSCCWlOZsoC0I6aVz4Y8oZn9CM
	9DbO2hTrsn8KEYoEV9+7VCLiOJt+/chN0DV/9s5+gCbgLy3k+Ic1EtNS4rvmbuTTHWNOsN
	4iHGYeY3MTnZTXD5k3B2cxz/zpwRD9I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=elxkLYuP;
	spf=none (imf15.hostedemail.com: domain of BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ikemLe1zJJg1roIqdakqClvPR+37mkaCzRu/wDT4rzQ=; b=elxkLYuPUP0/9y92deAIxIghOT
	wrXdPCgeUD6pmYGV6mTV/InNce7Lu46Q4OWeUzXKRJ7CkR20hKtCRrYK+Xrp5AUz7frigA4AEWdd2
	RlZUD+mTw+gztJxBKXOsjaQ20haw9PJJD8Wn/xcXB24csKOt6B9Ir3UwppQ3KG+Am5tP+bugl3mlW
	PN3E3rW7hRJktNfyAvtJu5lHqTDC6nhXLaVqZ/KBVmdIBLBENR/cmQv22tUSjitB6pEWY2sK1j9fN
	XGwyZ1ycoIaZQlRtV8OuwOMz02KMcXK+QGOSZYLytLTTJ/VwuehEbIoHsLnEIv04Fa26oK676hi9m
	AFH22JoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w760Q-0000000Ag5T-22Zq;
	Mon, 30 Mar 2026 06:21:46 +0000
Date: Sun, 29 Mar 2026 23:21:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: mpenttil@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Marco Pagani <marpagan@redhat.com>
Subject: Re: [PATCH v7 5/6] mm: add new testcase for the migrate on fault case
Message-ID: <acoWems-CNYT3cwo@infradead.org>
References: <20260330043017.251808-1-mpenttil@redhat.com>
 <20260330043017.251808-6-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260330043017.251808-6-mpenttil@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 3ED5DA0007
X-Stat-Signature: ozf7xdprg5ah7boh6kqnhgaqqp7q633r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774851709-825449
X-HE-Meta: U2FsdGVkX18Dizgl8RIL86+OQV+Qv9vz8wvmCLgIQ7EyMkbHTRSewF0Fj6YgAR4B/SuuIapw4fwbaEBHB0XYnCmmoZ6kAsfs7lENmZjjHYU4iREqK/eIziXkupHwVNlkhjOb4Xr/6KWWEWQ+uLJ50xJsg17vAAwAXP8qsRtruDHv9Ozia68MxPFNt24GuYjDXKgrLIHOzCiQvMqrnWQ9i7tlRexxPWWgkGjTACLXpoKI2pPOfsyZBECvvPrCHNZP50N0Uu/YwPSsU0l16KON8uuT/Y6zaok0B+Szq09O8Ye74QXfhvPG88k/ByPTToqBD8defj3sHkK5YBd511k6F/yG+2F6n4gsPNpzLgbKmA7GInxf+Bd6GwVEZ2769JbgA7fcqwUnnU5iTKwZ/tVMwKPchNtqzW8IsiupxAYwuehOz/VQ0tGRU6rP442lrZnxBeHcTTbWTUlCvQuk2ikwFEEMVu2Yyz3eGc7HFTmj7iwy6M2GSoOhM77m+Go+McM/1EKdnOyMHB6F6GRuFlL2rXowpffMcuFAetMMhFlFzAlPuPGyAlsPfprbf8Sczm2Uo57YAb8Nfb8bINjKM2vuLZjb5hi8mFn6FlmbNl3UpPJtE8iejqvhZVyNiWbXt00GOE3xeKqlI46eI8ndluxrJZDuEHf8rjeBDDriaFPfy276U+aMVU7oJggQmyKPePomSRPjeoH3FHxI5DVH3llbyQ0da+fBj1nCy5S2xKuJfiH2hK6HCIXwuAr8gwFlXPIJcjKNNvh01h2IEtOSg2UYZOcBxKOHqpPAt0ky/go1Tsps9TQkf75lf2jtC1lQqSj9voxHsWlTEOS7H5yNBMbNixH9bDYu8f6tExiqJ83Xoka5CDl2mAn1HUVRlMV1M50KkEudF0CVEVh2PymY1NH6lAJQgu9z+Vb+GQu+lx2irJce9YHm82uLcm+Eof3ZNv05q2Sv0yFQK0sdJWMMSQ3
 o7OVCTfP
 VLZymi1aBKrt9r68Kz8te2Z3dN+sIDRuyY4i2ODMzznY00ou316ZfQPC37cvnhZ9SVLr547Q4s/U0tQAXulQqPSg2NTdun/QSi5sfaO90v5pwv04kJ0vSuulC8buOw7MBm/blwVNJiLMMKwBQcEbj/3i43Uz2HUAiGy55hoycdexFdlRA9CWXvmNKxpU4uzRlpLHkJDX1s91lSlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 07:30:16AM +0300, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>

This seems to lack a commit message.

Also where is the real user of your changes?  It seems like only this
test case consumes it currently and you actually add dead code?


