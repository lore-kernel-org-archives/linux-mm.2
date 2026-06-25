Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F5C0CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3E76B00B1; Thu, 25 Jun 2026 08:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3816B00B6; Thu, 25 Jun 2026 08:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB586B00B8; Thu, 25 Jun 2026 08:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 348A96B00B1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:12:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA6C61205F1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:12:04 +0000 (UTC)
X-FDA: 84918321768.12.1094C8F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id E9446C0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:12:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CRXNOXrV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+469c0735132da6312b2c+8341+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+469c0735132da6312b2c+8341+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782389522;
	b=pHS4db6Ruysvufzz2qTCTlAh3xDM3cEFDxeRn5LQr1B7IJwTqvrBr/mHHSj0OvTRHRrIQI
	HgyB2pDzn+Ih9T1h6/7tneXDSXbgIwt6UL4i+lGBhfa18ZBmQj9+DA/onH/QjqYbUwNlK5
	GErtDsQFjRJVe8zOXpKL8fqOf68q0Rc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782389522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HliYnva+5KN1E+V4bq3PVoEHb8bbV3JhWLB6Y70JEp4=;
	b=cYgHCJc5LeqRYWLDCaGzu/ZdDWRdNIGZ5w+g1RS+epaZ6MppVWaQNuuotbjpkfW1nJRDFi
	mDF+mHyPvSH77mF+PCCdAuanXA7ST0oxqc0f06FwLeSaVYOYyvHn19UbIFuPyEUEXKoHFz
	DcWGOBsQpcy+U/gJjSQybLDM3bkWXd4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CRXNOXrV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+469c0735132da6312b2c+8341+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+469c0735132da6312b2c+8341+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=HliYnva+5KN1E+V4bq3PVoEHb8bbV3JhWLB6Y70JEp4=; b=CRXNOXrV9IbbHk009wQGE7S2Zc
	63ozwRQpJek7txIp03qIs+/lptFXVmZRQV+QouHmJ/QXoL9wBwN7XjpcHbbtemwqtWlbn8B6K1bBx
	r1gUNMTrfaVAHMesutX96zlS2RsIJ5PLfE4Rvx3FAR0d655ALcZHKku8mc3zbNNmaTKpbwXakTdg1
	nBHOwBaggaeQzwtuyTwr5czwLSjbtI111M6oEpJYxH+YjgmDsTS8cazxmXRwkoeIPGsUgX0qr+mjf
	BEk8QDwwtmIxEs6/ai3Lkzl7M1H1pvXFe0N7EdsxAFbF6mVh14At8eLm+8PQsvE4bk+Au5pTMUzqv
	2+2DySuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wciw2-00000009AIS-2CXF;
	Thu, 25 Jun 2026 12:11:58 +0000
Date: Thu, 25 Jun 2026 05:11:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: hch@infradead.org, ritesh.list@gmail.com, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, david@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	rppt@kernel.org, stable@vger.kernel.org, vbabka@kernel.org,
	vbabka@suse.com, willy@infradead.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <aj0bDijqj1-Bjxq1@infradead.org>
References: <ajvc7fSDngyx0X5j@infradead.org>
 <20260625091039.24501-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260625091039.24501-1-dipiets@amazon.it>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9446C0002
X-Stat-Signature: ckpo38mx9u5im6drx749pdseojc7pumf
X-HE-Tag: 1782389521-278245
X-HE-Meta: U2FsdGVkX19Ir6YQXTLcPsnLvp4SzJGh6rQ8T6TpnQmOrXF1R+IneAzesbBAORKGG6Vn61J6e9Qmh6jorkfSwNffIYV6TFbmJeLwcUiyXvvkTsTSOLNdPNpkU2P9YkQMVQby/GunMr2GQ+25IKXHV6ApRhEaMpMGKn2pURisrznsT48qwoy4q9xPVVYtr0wSnONLxvvhjNFIcFejPLFQLmrdziiCmrUOpJjjVkBHoqRxvH8+nW8IvCpfg/RyhQYy5ZtPG6hpw4KFnKAd21CvFmKS+6/DRz0olnlFlghvcW6xlD9z01IPt/7DAQBangCXR/0e1eAWZjISoH2xOnNSsV+o9K/PyyAtnaueUbWVZMl9Ros0iVGkjUiZBMlI+ZlDzZ5FcfDP4l1Fje4wQcx0kjhyVvZPToxl4YG7GyafvG28U7JQZD/2cytmIMFHy53zgVhD+WvPYPqa0gd0TJPANZYedstksR94fI0ysFcz9sOzryIWPswZho6NSOIllifZMH8UwIrJ32JYieVqGGL/tVNE0VFfdCpFmqJ2p7ixT2RlPCBJ7lkgrddCbZ3oPVQyfwzUk8uOTShOA5XfsumcL7kJcmLdPiNdc36XHn3FBd9SMY4W3G5Fzqds5MgwgeCs0rNOYLyKwjwcqQjm4k42BrAlLlcUd/5J68d35uODqydQ3d2e20yluK/dhJn8Kc+wPgu6+jPLFp1/10hAB0IKzyv1UNnX3Vv+0UtLKOYvKZAoZVnGYYCO8khnb8a+Ne44SafDAG+VfPJHZfGsr8gbPK6x2M8SXZXfBycJQNIrCngdWqNEx1kB5i9e92/24X3DZrf//GlKcfHy6gs0u2ttLOUIOxbodyfEW6l59LlWxx2h4S1ecoiyj2n4rcgWA0u+218+ADV+z0Iu1XhrMr+SPBJcAiRCHn2txa9mCXMHGfCK/DFMGDB3ZeNbC4mvFHi4x+gYM3DNeL5+qKvMguq
 QyFNmCx4
 32Gh9jSiABkZ14L49L/LJ4876P33OjWk7i+IqmOzi0Khqvc1q9v3YyzSMrPGFIG1MVB106/k4qf5qeJ7B5U8Qir5TwjswEr/W4oON8L46LK9y7MHAfow5fnfw7TccBASHIVQ/UsE9rArhEZkGQq3+tyPvVGnarjtH+1nc0pA+hOWsbY//MiQ0eVEdljQqCEDgjk7vIgQI+ZDF4MHOxzvrVxGzbOb40orVgHc9I7BsdUqFqqSpH9ENJtIrszXfRtptC95q9m/gAJT0SPIBWeHwtDqWZoONvu9VdeIuZnQgHMeHd2nnRBeAN5RfJOWfC0FEcS3s9LeR/Yqr5fTxJ2X5JOlHJH1tePxVMfUlgJ4cla4LJosnztFe4IIVbfVxTP1Yc3zgxdYqyL3gcod4NyxSCgWSBgJwjGImq7EiGU/G+VIIefZTG7Tjk36UaOexG+LMRDjSnpRUchTAkskvGaSyECIv3A0BVYmMxESaSg+OYg1BNne562Mswx5QdH4SMCnFoOBxKC3Ra3e1knzNo8KCttV2zS7NtCPIJ7rXw7610IpYEltyY6I+YJdCNaGA3gZc8ngX5fwXb3got6Wp8bSsl17AakMPMv4gnQkc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 09:10:37AM +0000, Salvatore Dipietro wrote:
> Yes — all the patches in the result table are shared within this thread:
> 
> v1 (original, iomap caller): The original PATCH 1/1 in this series
> Ritesh's suggestion (mm/filemap.c): Shared in Ritesh's reply on May 3rd [1]
> Matthew's suggestion (mm/filemap.c): Shared in Matthew's reply on April 4th [2]
> kcompactd background (mm/page_alloc.c): Shared in my reply on May 6th [3]

The page_alloc.c change definitively seems like the right thing to do from
the high-level POV.  It would also be nice to find a way to centralize
the logic for which flags to set in a central place as we have quite a
few other places that want to allocate large folios optimistically.


