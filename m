Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C894ECD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39BE96B00AC; Thu, 28 May 2026 08:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373D96B00AE; Thu, 28 May 2026 08:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B11A6B00AF; Thu, 28 May 2026 08:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A88E6B00AC
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:47:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D778AC2427
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:47:45 +0000 (UTC)
X-FDA: 84816805290.04.35D81F4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3EF69C0003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:47:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Rpt0pUFA;
	spf=none (imf28.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=wtRCU9ksLk8mK4hQYdv5O7SFr4M8GdX/rfqnDkVT41Dta5RAsAvfssXjfhfUmIYUPdqxmE
	Jys9BWr/H5h015CDy2U4scLc4MgOdXR/s1gl5ggwospCSN1RpUYzDctCRwSp81O3BfPLh/
	GhXOjSb0VTqxdIvRM9zxfrW+lkKU5Fw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Rpt0pUFA;
	spf=none (imf28.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972464; a=rsa-sha256;
	cv=none;
	b=DDpo4eZGTX/a0B3O26sUnj9M1RN8UVQ1LJgw4MS8RPcFK/J9SpvCZCxNgElUJQdohqvzbX
	BYYNI+DCuwUq7j9CW+h16x/MDMNs/sfIytoCh477i63OY9MQBqOvH9yURf0czW+SOONdaw
	iqfM0+WSuhTtX0PNzvwEFIu6oB4c32o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Rpt0pUFAIa9nSS9CGU3dMqfeCD
	a8YQU/79H2ACOklJuXj3Kr08pgWJTpsUATRMMilHXk/G636/TgZxl0KEBgIiCQjzA7ChSl20tvool
	jAbbZ+flzyZwAm3cLqtxb2g3qH+QnXiXHy7wreQq28hjJaRaho2LGzdMvkb4Ef6leddHK7T7j2eHU
	rvI9o8evYJ5MBhuyGy4UN1akBx4npkn3nDNJ0mG90orlcjaicbduuN7jjT6dPuAJUAFuF/c5yEuzq
	DDp6RLQ6bup0ExTOSFen2ax3tUhDJs3O9Wo+7SWR4PvT5JKgxHZGfqwqBCHO2esd6govgamAvH+5m
	QFR7lv3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa9F-00000005jo6-3Cxr;
	Thu, 28 May 2026 12:47:41 +0000
Date: Thu, 28 May 2026 05:47:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	David Laight <david.laight.linux@gmail.com>,
	Li Nan <linan122@huawei.com>, Song Liu <song@kernel.org>,
	Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v4 1/2] xor: use kmalloc() in calibrate_xor_blocks()
Message-ID: <ahg5bR2IZma0pB9i@infradead.org>
References: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
 <20260528-lib-v4-1-4e3ad1277279@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-lib-v4-1-4e3ad1277279@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: dskoixqc4hxn88myqxr7bdpu59hbbxdi
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3EF69C0003
X-HE-Tag: 1779972464-431985
X-HE-Meta: U2FsdGVkX1/uYM2G9A6b9UZ8qr07dFhq0bWSkV/r9OYmxuMGUnFdQaWejmEVsXzUydeS8E/sAYi18iceVjsyKI7XKpzAIXxLlu3cYJ5jQI1o8tvig/FMDku5NuFgcQCDnGdVR4nPQK2luPmttkSC9rckZvkg0hIIOI+MQMpjNNSgVHl95uaYKT4bQqGt7hl1cOzT7fTUNnJYOfqdRU9TVHrzGUZlzOLvWtXoKMYRkyatOVY2pry/Go0pkatfbBxVrgLI3/5VlCoxsMaQSw06eNi1C5Ixs02WHh/qhHg2GdSyYXX0r7rJFt4arUBpaNS+vncj/jThL1sZ5hz4x9/PRe2+RQxNsmbUnFW+KcxiKH3bTnlgRyceJryJ1UDDmdbf8qXKeflYIk86Azt0alsW8daCNURyyHvWuq6G+kAfF9T8Qkt7/A9q4VW6EF9cqtMD04ERymNBh4pdFs7SMYspshCi73SJpsb/LdKY4CMKuCDJqbBJaiRFSxmrGqZj/FaTi2uLN9VxLfnHrTx+SSBvAGteVgilN3APVUIHOzImwNJIfWSXGaz0RSzBSmQWGXrsIC34gE7qOwhtgWUg/bv0uRZf7E8nHu8gqoyiLpTe0FXbMYJ0G5U6osFI6UoLii2DQXai84wOTSZPuPc7ODW7JQBJOLKvsWMIcKaTpt588sOoVKv1e+wM0zrNls3SZKXXFIeL0f6A5WSUvu6ABXpiYaEep3L2LryUW1P0ThBKynZQAIXLcd9z3Hj5va+zTqw099I/d9izXWDF4Cakvf2sNC+BkbUCg2JkoOCa2+f0dp/ksmGtnO2NP0nnj+TIVnBfPpFj0RniUTBdvncvua/fd+sX8qtmOEgbKhsgKKBA+O6GNOO7f6P6ZPtcsk0gD8BQMnmKXH+XYD2ZwxM338t0Ms1SiROjLe5iAXW13hKW4PYO9sA75ZFDdDHIh4sUA6mNpN2/76zufSHjnoyh2hG
 n53gYSqh
 OC7w1pPozdZHih4guhdiVSh+fISPyLyjJjVHTmnphaeLLwzLCR9J4lbKASO2CnjrXy34CXC0DcIE1dy5PJ55NIkETaiaTg+6OeXK8yx50oNB0UTCcovvKDjiPnqQmBmRDhwG7RE1Qjkw0Uac+YZ5yCL1WGrM/yFEUx6fP+x3hgWHfLNdh/djrqCNFZ2ZiNHlkjHQ6K0Lv/fo8wX2mf7QN9lxLcZhTS9pjYSZIZy8VItsqt14jgtG3KN8TUESAd3w8lDUVf7gCcjdgOP3D52XwIXzv9Z+1Z8I0SgdvObacN309tCqC1YQEv65+faicrKLpi1kJeMmzVFqdqBReoSoxSCjoXnf4FPDJuiYwxBS5HpXBokV96TIq2sIW5Q/+iBLWr2dZNS3ebg3Yv0nMWJEgvlER/yPRdI7nnlw74gezOTXb4TWftRLjhhhBOU4Rd+E6ph2AXIVsAR64L21XbK4NGt23lyHDGVc4YkIMXKbdeMrTmD65crnttYEWjGqFY7m+rzWqOeDS2xFSgqOgBZjn1y8nLX/WUm4M+mNXGcg9DXH/43VusSH8+iTSPsV+1wPfl8SZfHitBWpPh3B+Npuvq8Ul7d0k9Hjdiubl9CkkfkyRjrkCGomCzINqdTQMlz0+Sg6jDE9RjInY28rCsdpgOh09xFJNLg11hAwXAY4vUfnnM1vgaZAIdJGdZsqPcDR7kUZFImoT8d0S0a1iB9ZRZXaIIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


