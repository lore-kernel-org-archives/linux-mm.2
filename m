Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3737610BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9782C6B0098; Fri, 27 Mar 2026 02:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A936B009B; Fri, 27 Mar 2026 02:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802CC6B0099; Fri, 27 Mar 2026 02:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 721F96B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:21:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CC66C45D1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:21:04 +0000 (UTC)
X-FDA: 84590845248.03.6E9D732
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2210940007;
	Fri, 27 Mar 2026 06:21:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2vOZpQFU;
	spf=none (imf12.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592462; a=rsa-sha256;
	cv=none;
	b=NoNfrtmS/wg12FmKGjMc8hQJlLfyY2TUVNZgjeBYtfQVM9nGQlt9QOUAvjZqvuk1yYoOoe
	/jzm56IOluzugxX/Odr7cgTZoJbolzSYsamAwidRh9q5u3AMEI402RQPAqri2JqTVYNyKw
	Wikg4XF0qd5CcajPcxFpWMTH6PKgHUQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=7V+XO+fTPbSPIENjbT9ej13LRQp9pp5w8k6VkMWx5dZbajAhJQI6tygR9XYuk6VcP/AV/b
	91MDOYZV63VJtydSIewVhjoV6k3jw8s3gxIdFBWBw+3uP/lJ19qngeV4gUSDVAXptyfrjC
	lgv9e9nAYU+a3cmgtGN24tE3YAEBxJE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2vOZpQFU;
	spf=none (imf12.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2vOZpQFUuSoArLjW4+mjRcL+Po
	chyLRQuQQhiS4vg1Of0vLCRkf9KCHmt/31RjLTHnykdPbw39omN5VvPdoxKcGFYUi7W0s5mvxDbet
	RtKHfIGvwiVaslG4XnyGA7zLTvXFEWpXnWbBTRSzqMu85iQk5CkVlNMMn0lijpA5Iku/0ews52zFF
	oLCFUpKqZfNfRav5w1AYpCD2+jXXnt8wC5UWox6msg0JnsIfQavFpouPFiqGQZQi3CkfP5snFkFII
	DPAUvzcWlyFpOV2w2St8Jy7goJ4cetH38EXYLPmLuKs1PEkhYK2m3Eu8gvpGbi4IMt3IAzHhn+EbS
	MsqMhQQA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60Yz-00000006mZV-3eGt;
	Fri, 27 Mar 2026 06:20:57 +0000
Date: Thu, 26 Mar 2026 23:20:57 -0700
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
Subject: Re: [PATCH 08/42] fs: Remove inode lock from __generic_file_fsync()
Message-ID: <acYhyT_2B5n1dqDn@infradead.org>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-50-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326095354.16340-50-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2210940007
X-Stat-Signature: mbbwrwn46j7jzw9s51tzraxrkx7noo1o
X-HE-Tag: 1774592461-914547
X-HE-Meta: U2FsdGVkX19C9nFEQSEKf9slDiCryLJy4yiSxjlhGAPw9dlhkPzLeFkguePaOw9sQjN15FSjNJOgmeXm4MPqdJEZjTNs5U72HKuj5UPmSzxJOHSJ6r+i31PfBWSvVHJwlEIkOhykIU1NkT18uoDP8SiLqP5Kp+Vkkbl+DkslPssTga21KX3qz9xJP/37WMVjnNSv6nsZ7SN0qF7vb3eoB/j/iSfsCKkx1072wlLAblmzbFdnxCgXsXPG/LleeItZb2Ghnxj7KhwkMAQiOwvGMtL4Qd44aN1Hd7AsT4MmjgsCvq/nV8yuVoGTvKBf4SFd23qr2udpvG0Q3xZ0dIY4gd1VuwkDx1I5aqGvZcKnwuhu9UGIhEZtrYUK7FWDzJJP7lGt2FaguCPXtukBGYl4ZXxPW6T1TXXYrzzd972TmG5lmyka7uOtv80cp9Z9Fz5izq7vcmThFfHH/ehbAmAIjXhpHrJk1u6MSUc19JLuZjhzc0wHaAWG6DLzNNuVEfUzeLqeLDHpZDRcbV4MwHLNJGroQNlbiOzYhhpIIXAfmfA1WdSFKes6BusCBUoZdQJEDggOc09EF0wHNgpQZ0TUIjwEgvcrQW8c+6dRRYrH3XfzaBzECP/C3jGzw7UI3gKImCYdiDj353eYM0Vgx0gwSXL3V05oUzXATXVpUAwWWlNSzGhTr3tJEoD9yeOSE0vFW/tBTjfW7jtYE/bFcwydyx418rDgcFOL3vmmmAlXR0VtAZLqhK5PMDdQEp9SDdblkLiU6+HkgWmSXMRVV1mP2D6ImAZ1xUNRIrCWh2qnbAGX9+dc79Q60qc9CDNTOt7KdrZoV0Dta4Tfv+Xb2DZ5ZXNwhWfh+hP0Xq171Dub0mHHKCE1yJIAI0yrncIRFxBBUWo/3avIKUYuAcck9BO8EvQe5vIRMuZykJWUMFbCN6HEvP3VnqQG/SfmG1kG3x2MWylez+tTQMwHvR0pKeK
 khQQl66Q
 HuYyiOfDZKr6ROfSvQmHLA8PvWEazIhvFcOEFI0w3j2+J6k5GxwrVNnV3T2kPNBgMYkT1AxY2ZK2cqdEhN0wu2dYrGANjOPmQwBHaa7Z/B8jgsAi8jMhdhcIUqjXa9defAEUvl5Adpw3AW5ihXd3dNMbOobBcFbdMx7crKzByTFoudZIa4G9++yZrQiQYJQYLLQtj4hKAXzVeb4XHHBkHhr2nVD1quNndhWTKIZvlg3R8gch0ca96YPhT92k1dxX/wGZ8RSNkJ2FCJ0xTrlX5C6mij/5ZpoyRWosGo0EoLpyaMos8bBfSoid2NModHjzSxpJmCIkDFqKfYvUmV17FoegrKJhJcw4Yfn6GPTWVUIZL9IxiZbPWKG9vpf/kwdOOvi5vskzsjLmAHkQO4lrX0JUyJh2Xc2k7k8fMBxTuIHzpdlf0v904HPREGewoYT9Ozp2RH5wHFlokKphB3JCuKOZqtJYnU/+D0qwV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


