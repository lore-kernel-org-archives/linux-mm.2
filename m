Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 669A7CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 06:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915236B0005; Tue, 19 May 2026 02:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C41D6B0088; Tue, 19 May 2026 02:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAB36B008C; Tue, 19 May 2026 02:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6EA6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:31:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCD31A0215
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:31:02 +0000 (UTC)
X-FDA: 84783196764.09.29FD463
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8DBB720007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:31:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=p7RIf+wu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779172261; a=rsa-sha256;
	cv=none;
	b=G8AxOPeF/IpK9Q2pjxDzvsYTmJAaWm81jXCQeUmEdTNupC8IW/61F+vLDvWSTKeP+99Q8y
	559GIcJNEPByA3xGh+hiJS6p0tPypmHP54DjvPUM/huiis+/XtGdPcaY/y9uxWZw6lqa0d
	QXibm5s+LT+AvFC+BxGPNJCY1YO4pGE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=p7RIf+wu;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779172261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o442OFNieQFEVCinEvTPBo7eMkvdIOERcYprSD5XRYw=;
	b=SLcxnOQObP8gXz1j6p1aPvoZs2XiHbDHL6UAIuk6JEA99StSNKw7Jw+QZ2WVPZNlS6Ue4S
	8vbul8l0pZ6bIicQzPG1a0vhe+hda7LkzpYcWgOeTwBtflvBK+vNocnYMncJHX7DK0mJh9
	duCNajipPNzDgKYoggfIpC7lfFWIowE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o442OFNieQFEVCinEvTPBo7eMkvdIOERcYprSD5XRYw=; b=p7RIf+wueBqLPdztGUgb7RzH4b
	Yn0SWdg8huTYp3WkD4up/KIGERt4TQABFBfEdtuAuxT72p9hPDm6zYG8dbdePInV0Kq7koXKRkTS5
	elpvWZuG6eMLq6Nb7Y8vdJZ14iRVNlJnm7hUn1jlIZxdhhbhSn4J2ChRcinuurcWl8oM01D5uRttV
	KJkYj+2hOVyjpt2xSo9RCy1jzZ/evHg1NrNb56XDc+TbT2Hk9FJaaKLV4T9C88QoU5VwXCn3eGSOC
	Hb5ysQS9vJxBHl1XhRh3m5i4iv5D54280tIptgrKIMRzVjQhPbGuhkn2XDH07tuuaKW/72jPcjeKq
	Mjwv+hCA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPDye-00000000LbM-3ApS;
	Tue, 19 May 2026 06:30:52 +0000
Date: Mon, 18 May 2026 23:30:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org
Subject: Re: [RFC PATCH 1/2] mm: swap: add SWAP_FLAG_SKIP_ZERO_CHECK to skip
 zero-filled page check
Message-ID: <agwDnPXJSDIjGkpC@infradead.org>
References: <20260518073455.2495934-1-youngjun.park@lge.com>
 <20260518073455.2495934-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518073455.2495934-2-youngjun.park@lge.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 34w9u7qfhq8pe51j51mognqpxf7r7wnd
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DBB720007
X-Rspamd-Server: rspam07
X-HE-Tag: 1779172260-556148
X-HE-Meta: U2FsdGVkX1+WzahKoWWv/tVn0kOTFPMQGVreXDgms+x4zrOsFepNDXOwsFzHDsM/xhejAKD4irkPj4ciAjxqTfYSLpuBFFGg4vzcBFBhbLOMWOaiw5+PqtFNU6Ys6PdVIVaBGBwu38Dgzd8pL6gvy2mdzu6LWccThj5/5vq0gcSj1KJj0k2q0jYmeCWkaIIRogEeYFDUkHjy+JX0aR/jSPM02oJebC8ZAkG7V5OwgsojvxBT8lXVglHNoazSeSznDiA9y8rWffJxxmkEZdzgPzDtkxhZa0Q8N/xUCzf4daOOGmbRA2DVmZ/ym778JUvlsWLuxsSF8x0XKXLpr81NZ6RY36vYsWrUHmGTHdZCPWXJVa5OsIDj7yKv/PVRP9FC/wAQh2q8xKImNHGWXFaUS2qxX+EdsJeBwNQNjUgb7nrcXHIofnwQCj4EfybxC0LDvQMaI+vkuyODGEUvISAkpkVKukr/KQZQUIkedHd+A+YYyASrBXZ1FI245ReS8iES6GM7VEuiLgWUcGmEMBBgYrIa6qFd2L7gfUpf/sI2hSiR52sf8zj2S8ggndfZ/EXQuSs1TyzcHNnoVWSX87Pwk+m/3uh47ySroRqbekA3PpjMb8DsHdbN4yYdCPeABzvaNJMiYVSQPIgbMsSvVl655Le110L02XIogTMU+e7SrW/aR/Sqt6WlF1+6RBLQYsXIaxBzw+t4KHRYYlD8xCnyUvTpDGApH4oeyesFSBGaEpNLWpvQtAd5YiARpU7VJxW2TDr32t6iUjHaweewcucXjb847ccoARhEMVkOqHvfLkU9Tbv/0U3EhJMKKCZxe9LymZQYk03VdPcEdva9jayzKTDSWdo2p56ylHPQxqgb1RWb7ecf1zgHfjCX4vEh8q6xen9XgT3EmWvrL+HKjoYvIPpmsBDs+hsqwsLD99U1lAZi0NFn5cfIvNqMbNXVLqb3DkavmQj5y5LyzkPx6aE
 GfwCtifj
 gQitA44F3da6cBYY2uf3y/suC0W6Lu/v7rJzJZ0uZ3iEULK7zDccd75MHjQih/G12F8v/DsveGpafKzfE0oHIjnzeACLXr06yvuEzmN4RYwuFdYxxvzWdutawojx8mZasoAHj85aPlXKR/Zc8LL258ud9z+FVXCqXjuR1eM+tGaiiSAqoVsun6qPwolAX8mxMyJkK0hqPK8bfokyR4kUrQZLNlTTJH7QRSFphU41bFtI/pCz4zMO19g6T4ttXvN5de6FTyY426dt4GN2XaWDh9fJqY8NctbltAhRk5LcWSLy3gWjhuIyf7tY+RyoiZHMmxTNpNTwgHTZ/mrd7N5YS01+ivaqhkHv6FOV8qdqc+LsFmMs31Okvad5FL7OgXbCL1/4jzeiLku0ooRzb7RDF3XfS5O/6ZPx5aJAojpTRzSEc8iovylYSF1LEbjrt1nTXjJmnkHARO9p6GCWvVdpDvCZEtMSfPreoXdyHs1OmBjLU84OftkDQxvVYp0AJf7F2fAFElWZCumOgA/1aAeWuoPBIqGn4mI+I3DTUDuNt+dC3qng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nothing in this patch ever sets the new flag.  And I'd rather not
add new weird bdev hooks for zram when we really need to consolidate
the compressed swap logic in the core swap code.


