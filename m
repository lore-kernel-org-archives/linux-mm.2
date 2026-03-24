Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62AD5F532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A907F6B0095; Tue, 24 Mar 2026 01:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68DF6B0096; Tue, 24 Mar 2026 01:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E7F6B0098; Tue, 24 Mar 2026 01:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83A746B0095
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:43:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1854C13C9F8
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:43:05 +0000 (UTC)
X-FDA: 84579863130.18.9A28EB1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id A365B40005;
	Tue, 24 Mar 2026 05:43:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=x7DJ5eq0;
	spf=none (imf12.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774330983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=zJIWT2x8qImqJ1HgCWk3q6m1bI5LkzHtzMdjOBzHLSSq9JjKgSxV/9qWQnyLo/SaUpLzRG
	7tsjk5ZxGOtv0sZdeOF/4K8EuR3FF3Ph2GStdg11FPzNt65GPD8u6PjimTxJC1j8oj3YtN
	huQ6r6pTryzhiTfJzZQTudmsg/FOb58=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=x7DJ5eq0;
	spf=none (imf12.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774330983; a=rsa-sha256;
	cv=none;
	b=A4do/7U3jFIZwDsRIOo25sV6svHpjOflB5NAGY/dChpF29e3iZ2MIwK+cDxKFvHo3vk7Xf
	UCei/NOzHkK8+iuDZ0IZMo5E9cNDRv8nvrPnLrpAdbjz5Q1flXBxc0NwglCd0xPKMjRYcP
	tlMaMxO11yv6FWl4ViLBZlF2fYnvfuo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=x7DJ5eq06rtHXQQCUOHoCiMTKc
	vkKf6iF3kBVSHFqScyLXBo9FpF+vl07SpeBNouFBWNHkzg/gCT9CTAzo9WAnaj/5cp9WSDy4twNwf
	SljwX+/60rQduXd583rwnKE45ctlZqI4gHmAVn2LKxWmnjLWjcDXXQpu847L6L3ja9goR2jrd/9B+
	UeiDoPM6VMPcAapskLW4fdutOoeDyu6y13ER6Xkjn8X7Ub7wR4/fGOOyVEcEgkxTu59Mq//ifpfSO
	uRAvsI7+nBdM63BJiEE4x9XMc6LSEqnE8H/uKOtg5NEgmlyOPEfxVFOW4ZExMYZZnCQfAOoxtcF0m
	um2cGn3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uXZ-00000000bZq-1QtE;
	Tue, 24 Mar 2026 05:42:57 +0000
Date: Mon, 23 Mar 2026 22:42:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 22/41] hugetlbfs: Stop using i_private_data
Message-ID: <acIkYc8dtI1kTfY6@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-63-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-63-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: A365B40005
X-Stat-Signature: z1ix4xqi34d9bra8dbc7ehstyuxjibeu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774330982-713557
X-HE-Meta: U2FsdGVkX19L4ADU592qv6ghLqm3YZ6imxqcxc5deUBIynlFMxv9Dev8e7eH0KtGS+CX0dMFUxrS8gKSa+Ae/JXFGbsMNzcBlSjiHS8vRO58qkNShAVgPBOjQzAHb07g0Ma/kwRu1GNKJsugJuQnbr06Lm+hVUgNdehSA7EuZ2YRqVeckcD4u/YkOc3XtLLUjAu5lkBoWSZljFY9/pxchEFiyguRtqyYeGAofeCMy1d2MmPCVcBlrWuLEmu6ybccrt0NqI7ozytb3Nap0ouKNPypEv8zP61LumBh7aPuT/e6bu21kGmSCq9lUbvkvXVDOFJUFtJyiLOYofC0d6NzYRZw9G1mymJrQZ37CYr8B0a7g7AHzu8Fad9cMCFyJN9r9Xna+GWZVX6X+7HbkFGiYXCOU4O2s2LAX81jS/ps4eoPMoEOjNJ5j8UZ92PFrpwwc8mMnTRb8MOYQ6FF8FQFhuCD/x/X9WbnhvAmFm9Os6Uuqo7ANf87CWOEkUkiSixlIq5riGxiBFHSZVNvbpJcYAiNwuEjtV39RyATEvhMdD6SnJfbRzFgPh3ciTdhmygf1SNIXpOhJLAyGHFuxPWXbIRPp+k61M5aJtlSOmUqZTRd32cHbMB5SXDW212hgpThrauaWuBrDDGFDNdjWXNH2uSgqxiI/4pvhCrMCdxtXtmX7OBg995at8r9xKg6TjZZ/eHfFBUOGb2fU0Q5Ykuz14oKOjt82KTJPG9P/koCXnbrmaU83+QA51RbbtKPFr4yYWd6xh5e4QrW2Qgv7cJY4gnUwccodYv/zw91wZpffGGtfwqHMlTyfoOnynPNtR4wBpsjSTpy+oMMx7qW82/5hcHionuGD2hXusdJRb21zp/hQdQOhLhBzBXWSty+9tXjvnT7yfQbpdldrT1cqsJdkMTTmCKfLrxLMVk23GO5ki6TYefqpL+UVCrwUPIctSkiOWOX2MGaqFe4hd2nGAu
 t/1gSTJr
 1DE5RhE6nTNBcDiY6N/dWaDYeJBVBj6q6h8qOmrDGELNLa/sUkbl+GacyVZJ9YT0wdpWM3bkmuIzNsfu9F8K5izC1c8HIJSzXpLvgpm7KNAKBXhG4MVDc2KL8lDOlkaj/8AomwEV7N9r2xftN6LpT7nrC5EXAo/QgiNisocL0WFys1KQZeEKUoIqaoxU+5FJRObbAkExhS8AB5cGoKxE3aHUxxloXuoUABK+n8/rcRT3GKvMk4QiqlxQ0YoVIv3YbDyyUtX1F6kPowMwd49XU7W1RMV6kMRvT+4EIeeX5VHfOPGBkCi82odlofH2nIrGQPVTpKTqVn+FjoKUox0vMg1VYuyb7c1BQ16wG0gzOGCj8041kQpghIcRNxVzAZM/Gwg7iYtrFPkxSRAL63yLCY+Bh2JNNnH1wOIxwSy5lhAUwvbvya4PmkiZ4zMtPAD6OuIGgRC1CTYLhfqCySyb+88di3RSgxriiU6715mU6gkHUR/LHfd3G76nkB3QE8R+EYO7X1GVBsU3XRceZIgjTvRkApvRgLaTFgCnpVvwst0VLhS/oe+coIqyRyIk7dAZ6+dB0dU7CCRz1qlYFZzj+ByqhYxeOeSKffBbtA9bWlEXhimRUxa4t88nEgjKdhORHQ37wArkkaKhrT9y3NFneMav76YBzRiqL2OLmmPAEKdbSuuTMhQtMRufwBXY01pYrMNx1kHwrRlkg6rYmVY6RUYoVIIWMkVgiKwyadXUWDORD/baPS65A9a6yPa9Sm+dxayrFIzbWdTKb/KuO1pAzbCktnt819+VYaazkx0B9ECCgQflfYR1gZg48797h62Iso7X8bjgnTUxEFb8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

