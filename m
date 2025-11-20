Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75668CF6497
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 01:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2BA86B008A; Wed, 19 Nov 2025 20:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB54F6B008C; Wed, 19 Nov 2025 20:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB216B0095; Wed, 19 Nov 2025 20:18:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8A1E6B008A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:18:54 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6392F84E4E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:18:54 +0000 (UTC)
X-FDA: 84129226188.04.276FEFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B651BC000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:18:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k1zlCzpb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763601532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3oyM318uH5S1Nn1ZG/gh0i4UmP1BvYgaynzgkilEmmU=;
	b=5KTqPX/oyDOpzo/9hMBGdTomlrfx7buSwFwBMwNYrnMtLI3sSK4uvi0vCI3TiTQ12I5a9p
	yiOGqjKrJzuRCxWxYKlxXbwC+41255eVqhS0ZEbuu4dseEoBWb0SoOUo4ksJC1KRALjhe2
	ysVYG6dn8lLNwZIsMNL+LdBqK+bgdoM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763601532; a=rsa-sha256;
	cv=none;
	b=bhHcoXvKdWmWyaIWRQ0cfUrv0oqZZVZEVcCaRBEn0DGac/MhZINvh87aSehVsZZCzQ1nD4
	7qhbh9tPmHo3NDCvk7rcMLKWvis1HNuIGcP64O+Q9KZBWn+PMTZmyO8BlcQBWtFIjIWgw+
	/LZ/sKBmJ2GjyL0pnL6vn5VrCCMPFpw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k1zlCzpb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 99AAB42D75;
	Thu, 20 Nov 2025 01:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D20EC4CEF5;
	Thu, 20 Nov 2025 01:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763601531;
	bh=O7zgRWKMoo8FQsJbNJswAKghVra7cYWb26LJqJOXoU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1zlCzpb7taE9BcvNT/M+eEUDk0sbpOVM3BhGG2zAqUd54Jh01nR78Zel6pPSVjir
	 F8qHnn6slUVPotwcSq6Q/t1Yt1Fe0ItQu6h9TDjowr9Rh4diy7t7SN8GzWwDPXm/10
	 MS7KTcgz5/U0KEr5B0eLnlQmE9eq/AeIfxoYI0OgG6VIMqjWCG7kU2r0EbXTn2FTrD
	 BFrun0KNQCmSl6TP5402DRyByH0AZDv8WNYa+r3XQBOSYuJVGZb9M8NYScbCR0q0tH
	 sFiKAxq7nCznFFSiznA4bcxBlrUoAByViTpYFOfsaXy7RWhsmZ5P3ycTKGJ8wIAGj7
	 iwkJ9YeyEDD9g==
From: SeongJae Park <sj@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	SeongJae Park <sj@kerneel.org>
Subject: Re: [PATCH] test_kho: always print restore status
Date: Wed, 19 Nov 2025 17:18:48 -0800
Message-ID: <20251120011849.74672-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251118181046.23321-1-pratyush@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ifa5rdmtj5tsngupkguqmhcofyabkcnm
X-Rspam-User: 
X-Rspamd-Queue-Id: B651BC000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763601532-942447
X-HE-Meta: U2FsdGVkX18couV17PN86QZsolH6DnooNhfydUXhQ1RSOFmkxqTKiZSkQSxU3vF7fyXccwveOmOhbLvzhyrKvA2v1YHrPpIzmDsURl5KLiFjuAjyLmlAEsvuayul0Ao+gbfS0FnyQwX36OXpjwVG1SVCzHvJzQ+0z4LBimDf94F0N3FTSURcNxrx5rKwP2sSguTavGiF93UUaj0m7krVwiLuZlcwBDsvafHzHuPN7+faNO8z/t1v0hGFtz4SPV3WpPHn7+uDHIKy0Dbyd7vcITFBIEH8OlFfurcKEhQZ0Jm2mmxZl29hNXdsbchXWRfaErM+sYQCFgTwhnnPq51Wy7ZgW00C/0jr3MJOmNdOsMe/jPb64GntLHDlAMKGoYPbDGQCdCYflUvtKqkORTMNdf4od18arWay+VT4D8zGGibt+QMMXde6grKgLf4te2LX3bAAS0ArJhn1tGyw1rL8TsuGIVPnSWb6l4XhdudT5xKODOtP0OKXvwD/kwbAjTk3lsZHqMDPJtob3+uGIZ2P+g+rr2+daOl0UdNgQouysCeodHxZ8R68VKYfByYJvyW7gRXgom0JJcIoGPQKtl+OGMWciCBj7zjEg56cOLI5K7+FA35Qn6m08kkc4UINg6Y8HQfw8E4xxYa9Le+g5QuiNk+cda+BU74BKvpvWWOGg9e86AEN9L9saZOZ+lS+wD3N9GLdrWt/HoNOzhj0HaaE27IQcj+3sAynE7ak8iHPOQuidRzT/TCHqkWij9XIiVaPH4El2HLC8QJ8l2rhaqMc/p6Oj4fIZ10giDfdm1OI7ukm35IbQGQFBV+I0lcMZhtRXcVhphbE551inylbBNzcKZdA9El90K/JYUyGsjF4TbjoAbNdCI5ozAZQrJUIb5s4OeC8GeShuY/b8eeIY8fusX3Zmn8nGZxnTfpVcVSr2mCemFPBIas278Wu1FoXBb1K2hjKv3yAg+mlKwgzITd
 aRxr1fe8
 lIeTCOAyB/bxm+pygxmRR9LULeoutNbA2TkqMpaojJQx4fxj20CAWbsBPBWiTfGvowfznXz0y+xprPCUk6ndeRqGBlwjDhJ1CtaJs28razUjPRQzovGW1o8Z8Z9ELWxufrDt8gkxNETk51zAYRHFodgipGcGHouuH3aeemjTZCJBH24l1qA+JCNVCuiJk8dirU8Ve3rER4OBtaLwbMiUTMrm8QlDAJYlSVDHUO34MnUWi6C+07Iwdyfrjgy3RJagfN51Xoclx3fiS1oA7JbkqmF4KDjyufGCJsTPhccYVTYrhb6kvG1HmEgHxeCJf9PgDih37jqIslGoDKLHutH7jhMKRSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 19:10:45 +0100 Pratyush Yadav <pratyush@kernel.org> wrote:

> Currently the KHO test only prints a message on success, and remains
> silent on failure. This makes it difficult to notice a failing test. A
> failing test is usually more interesting than a successful one.
> 
> Always print the test status after attempting restore.
> 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Acked-by: SeongJae Park <sj@kerneel.org>


Thanks,
SJ

[...]

