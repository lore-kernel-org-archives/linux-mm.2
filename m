Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D2DC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA05D6B008C; Thu, 30 Jul 2026 04:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78876B0092; Thu, 30 Jul 2026 04:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4156B0093; Thu, 30 Jul 2026 04:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96B036B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:06:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A50B2808DE
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:06:52 +0000 (UTC)
X-FDA: 85044711864.01.0BB524F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id E2ADD180008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:06:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=MpSKyd6b;
	spf=none (imf24.hostedemail.com: domain of BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785398811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=pR9V9muzW9EV68SOw5LNLFL7jZR4I/YunBNRKNrgiHSy8fcDODNglreHZ39y+jzbAynJ62
	spCpMwScrmMZTYzWbYgXIJngMqgVz9r+RFYCjvyXPrhHo5ZSKx3cG6JdW0/xAN8GmbaHEC
	jTzDAuTINsSR3GLO/HHpeTcWDsNYtFg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785398811;
	b=qo4ttzVP8fYJmI39Y29k7JWz/hytAZNR6O3vYo/UYaf+yda6bixA/r9sdy8OositcIlQrH
	3b4mzzbo6iM2cA8Px8/UgDyur/sdLyM1DRc4Tq/r1UyFUX+9V1wbSHiDDNhcLF2wSUY5UL
	47vZDBcZMZKP1E2TREMf+c9m11pCso8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=MpSKyd6b;
	spf=none (imf24.hostedemail.com: domain of BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MpSKyd6blI4PZs64kwm5+Qkg5P
	OAZ7P8IO4Dc6J2fsN8yU4R8qIwqHZnmMsR8WXrNUH/NvTBS8SXGx1onY1MKpZUNL3B7bhH4XdnS97
	g919bzj/aB+Vk+7R5gp3ae3L65moj5W4cV/wEM/b83V7c6IvGXd4nrEeWRt+4RnpQiWLFkbcY/5hH
	QUAXyR5kEwdu73XkqndRsA7x7zpahd4p/suJqHpFw61W7nvz6iRcMJue15/gaX669U5dOfVXXqWGX
	qaFvPuubpO8Rel8kEKXq/fNljPuIKsKxBxBuQ0sNKQp7WDw1jtLGSEV19c0nfya1Hnss6bVmSVdv8
	h/Pf1KCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpLmm-00000009njp-22pZ;
	Thu, 30 Jul 2026 08:06:36 +0000
Date: Thu, 30 Jul 2026 01:06:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hillf Danton <hdanton@sina.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH v7 1/5] block: introduce bio_in_atomic()
Message-ID: <amsGDOQZaCqQMBtm@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 9w758gt3343uxy8ak9ayc4f8do1gz7e7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E2ADD180008
X-HE-Tag: 1785398809-394227
X-HE-Meta: U2FsdGVkX1+OBNmz3lTXjOL+B+f5BWXHzjynXSPoLz28x4pQOr4xzIy48fV0AJk822KvenswDFU0UayUPIFKl24sN6fRQBbC6v7ELkgEqt5/ig1uCHLFxo8IJc8yZWrLN6f+leCNHGVj0rt7EEtzc79Ya9LsZO+wULf3+3otxVI1WrnlRreeeM/7+PmFDgXW7/23ur46zxAwClaq4h7AckDo4xbcVhWk166bWoeitOq+2y2K7H2SsnY3Ci9mC93yJE2WdBaLZNixML+RFXexH6RGbQXi+bWD5E1E14lFwtOq6IIkl33iTJkF3ekBwaurXIQbsAKpQwujMfZWSqMuQu4Ga7XTmCOSGQ0lGTa34ILbmx07IYx+vNdMZw8/9hM6vqpFlXnMy4V91EhCt99zlWqZFtzFPq+qtSI5pIY44cIO+u/qVFkMbYWuRzIauZo/2VVapvvObic7D+zpaZnbTi04Ey3pice+A3rok5NP5SI907UDHlKtAN13jwQpUJH/1QxnZs1z54GHoLya/0ScW6trh/Y52jZTMll9sabx4ejC118O6vIIR6TebpDGVxTPQkpeG7+nqGMur44fATEc+qzEXz870Swy5MwiWFnu8zVNmxRRRgwdiX7YRp6PqizEJC0oMjkz6E++NBtwPjRH+S82RgAv2tyVJw2/uMFkHzrZ71cB6Gm1hMBgS6PVAYiuYYp11N1MwzpEJi+T8IpT+C9jrag8Guwdkof2uk4Sry6Fm5LiLVLywBk6J43YI+O9+7QRx3UV/Ld9haBqtQ2gPwp27c+1MNm0MCPYKFJcm27CbjBsfB0FJqoNVtkj0l36pDGBrWUjINLxHEPWmQr3ZejNeqUALfP7LDC1eaH8cqrB7WBayy0ZK4fNE88bUGDFRxB56Kcg3yvolpV+x82jYTIh5jru/5YQsxWYushbN6UO6ws290yAx6UDlr3RgXMSwSLg7QI1hx3i8GKDGHd
 gXz5f/9X
 IXC2hUbrp1UKDzcxS8GhJWhDJxGiayX3RU39t/cYx7+7cSQ2C92vq98ij2uGdjsWxMj346Hv5VWw4hYS2v25hPa8Yw+mMlAg/hqQ8hKoYcMpVJBl+sFMaxGkC+rU8kHW5H7oFd5V/LyRWRxl16XjcbSXiZIoeo2to8Tr0VZJJa5rtWDHjrtZBWqrKEPfZCRHgzvoB6UkKiPUhG4sonLJ7xIiG+TJD/WMIQnyFUBb5tPpnsta2xS+/q3qLnhcQsHipJBsxhwqVBVzDD/DEoaKAL9M5KONGgawGZpFnadFdqsNMX5uRNjgQ6ysPLSJjJqZ8kN9Pat/xGcM49XGNeZT8N9z66jy8v+LYsC5rymwhr8KY+XJEbZNhVfUjqPZ+Ns2Y/W2iEywuwyTmhbGUq5GS4oJxkJ541u3asFfd9vIti93+Pso3Y0VN6KHbAKYmHhSPf06OxoCpbzdkqzlWFDo4otAvoOuzk/8o4IMKjO+U3kzxIIwrbmJiGFwFaw8o2GJKbZeZ+SwrC/4kSalgI5xz0qvQbKelkZEqwNGwdaQKADmCQcQ/K7WLq0MFpjRXlmDqVO1WTjH7ry+B/J1bRbV2ax37KYJVJeuxGvFUsNQuZAC9xa5oqitMT0mTdQoC4RbRY/+K9CuOcYxhysJDD2n9McxwUqttX4ZF0kl8+rFWy9fZISHOOLBUfdFajdb7gGLobuU75CjSMOWi2uOsfhLsVzJaSi0yNcw8sgdYDc5mwizO6voB5dE+wYCF+jX4WfE3PRxojq9im4dbm8ocC77GBA8qNbTfLqfNbtZ6X0OKZ0rVdI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


