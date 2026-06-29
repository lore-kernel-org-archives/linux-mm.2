Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CCB5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ACA26B0088; Mon, 29 Jun 2026 06:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883C56B008A; Mon, 29 Jun 2026 06:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9096B0092; Mon, 29 Jun 2026 06:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58B8E6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:00:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA1591C371C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:00:54 +0000 (UTC)
X-FDA: 84932506428.11.845C089
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 49A9810000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:00:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWielXC0;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782727253;
	b=Q6fnlwb/WZW18eqZmKATenkHiB58v0jvgRplHY2lD45eXz2DxQjyP3toOH5tl52UvOf5hI
	cGHE9rsZsk7vWt9/dbASgWjsjPhFP6RLZ1SNmQwXtSqlIDhnlNq3YXPXJJkrmHPOvG8Mj4
	r2t5GZcQrO/F54O5KSfEsyk9WKokVxM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782727253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kcUEP1IuN/ViafkBIS4hOeiZ1h/lYXLSXFhXyukIWQ=;
	b=eQp+h7r54NUEtVwQY5gCRdSDwr70dO29OTBdAcq/6LmG64jt0/i64OTk9e5v2CuOWoJtwg
	XqxYZzxbVwkC1Llw18K2O4X6mxLAHg448ip4PtieHyyW6rMROOh9f/Oio0O81Tk/R7uYft
	5VdLAEao0/C7vJ2CnB2pgyZcVmW6+0Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWielXC0;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D79A40949;
	Mon, 29 Jun 2026 10:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615801F000E9;
	Mon, 29 Jun 2026 10:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782727252;
	bh=0kcUEP1IuN/ViafkBIS4hOeiZ1h/lYXLSXFhXyukIWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XWielXC0MwtF16hpnVoUhHPpwhtm4ahSJyF02mjbivDCl1SooMN8MYVadargAdyEV
	 eFlr3/tJUdxAI0cdZjSdMLcL0Nd0EhuYCJR/aoHDa6BY9AtStRJeqG/vhfzYEzEDep
	 WgqlUTcAtavSi7Nzi/HdEM+JHreTOvDemCZPhWVE2nZG7wqiMzHhU3xqkoPZBSzoTu
	 xWj4azLCw1Kz4iv0G+rO/v8po9P1u7ND3AP7wp/4N+c1Y3cCaJPIi8z53z9BiQtzaL
	 8cdG3kI7DOcmMrnCc7zmaQWIVi3Biuj/Z4l8nOIXKMCRmzj8EnJtgcQkTgswavvgK6
	 T+qC1DNJl5IqQ==
Date: Mon, 29 Jun 2026 11:00:44 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, chengming.zhou@linux.dev, 
	hughd@google.com, wang.yaxin@zte.com.cn, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: KSM: performance optimizations for rmap_walk_ksm
Message-ID: <akJCGApJi1XCxCJ7@lucifer>
References: <20260629174111989hvHNpXBxy36GgPPhOoPi1@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629174111989hvHNpXBxy36GgPPhOoPi1@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 49A9810000B
X-Stat-Signature: 5cdnfbjj7rz366bkx3w5rpi6wrpof9f8
X-HE-Tag: 1782727253-995563
X-HE-Meta: U2FsdGVkX18QGsYTYp6KOsyPEyO6VnO9/h59HahtfrCYBkHhaKtDPLkHfpNjti2X9SuilW4GS3w7r7jh6TMzeNsYcpgN8Ip53gEtR79gyhw95lw5UynHd/fHEoMuTonWAfg+HjEWo5vIvx+lay4k32NTIzCkLver/1iot5GgI/jXQ+OkGybb082rNNok64unk0dPqi8gSe2M92/Iv9YlVxrgyxsIEdbsGeaqId0iM01tz1EgVkZvwSMH3jZg9bcAv/JNpllI3PjUaGJPN9FixoSi9n7T7x3Pmpu9fMLeBo3D8B5x3DB68zv5TrTvc9B7MJ1/jH3F5ll7/rO/av+NWOge422ckJCdt6gbwFxPkr8pg+hE3ZaGjkhqHAbOfMfDcJS3kkL7ESv/Xy31RyO0OqolhSxoyBZhDC1zaK6JYrcDOdhEAQ1PZd+QBawr/tTYXK68taJ6ZAD3lfgq4xJCKth7MT6pdGGejmQsn1PRXY+GcPVMHkY3qwHUbQei6dWapwYHMHnoOCLGAU/kxAdEBprzuEumSdD+tdPpdDNHbGR6zbMnCP9pxmWnaXLZ5pOe1kTzK8nrSuRG9loU3aCC5pH031j6ZMXriZOqNG1m4Pfj6JPXNCjmNy6XwUKrege5Mq8m+FaWoEg2trsbspugHNTuT039P23u7iwbQOR3HIen0F2iUZcNuBOv0j9qCIoiWuhH6wNTrGLkjQyk3s+yJKAvRj2a8mnB83hEOYRMZeIUDdDtxxSyTvf5kS9BA3ogr6Iw0tbBZk4f4whn8JpvNgfkUg0LcEX1ResXNgO6vnpz18LIH8Xj+EYTiD2tk/DptLb6/9mQBP0VgqC96XJoj/yMF3BkNney6AxKLw4gdG7zprcUpn70l/SN1P1+t9U9Tm/HGsw289ZbOLu2U5aiz88rdTzZ0ABNZjRwqvNEvx44ymuoeICrH9cuTe1IeshxXMPCOvuM1sXxi8zLaUA
 d8B5j7IW
 IgrhVENdwMjr8J5Z7vB6ZiNSouuu3wHBWZGMzRFwDlhjIjifrGSJHfibjp8hHbwYhyywJbzhDyfuhOoOyaFnnz3od+QOSuLBe1WnO1UGOhc4v5M5qllXNC1RvM7/au+jvlQXjn3QU2vdyGxeCs1wVQPc51I7onWOung7k1Lg+qwuFDZqUy2YORpzkGKmY+QXGKrULT5iiqenRYgZTAMxypZS2DJHeS1eYOE17AU6B3mIpe3JhYK/8OyRkZypF7AeHRPUV3u/9bVKahNF8W5cZZ2Hrw0CwpKDPYMLwhUAZerL8Zp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the detailed cover letter (will try to have a look through!), one
very small trivial thing - the cover letter is missing the [PATCH vXX 00/yy]
prefix :P

Cheers, Lorenzo

