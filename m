Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B0F8C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8118A6B0093; Thu, 30 Jul 2026 04:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2466B0095; Thu, 30 Jul 2026 04:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7866B0096; Thu, 30 Jul 2026 04:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2F56B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:09:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7B3AC08B0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:09:58 +0000 (UTC)
X-FDA: 85044719676.11.E1536DC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 77FBD80004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:09:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rkL1tRhS;
	spf=none (imf30.hostedemail.com: domain of BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785398996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=mrdTWDDP+zO1OqQHGI5pmP0sI0md65D3HkwggiDo4oEO70YRBGogdG2Ucj2Ewvltgkbr3E
	9jK8Fr126I09iWdjDtIzi28+BZVP/oYc//SGqOLhluxlW33Kv2rE/IHe0apRCXFxrvthN5
	hKJtNmmNQvBZBwCFeR7ha8/A45I/Aoc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785398996;
	b=0T+vsqoLLqUhVbKc/HFagwm+mRS0SbyKqL9R9Qzbn/Yr+Pb3qpXftJrfg+Z2G1oal6lfeN
	XQVl024xSo9iVt8ug3pawP1gBacMpSmmmLli1eJS3NNKP7Lj9/VGS2iobApv7cmUE6EY94
	EuUs4s7+lHyMwf4OSyoEslo+YL6UO/M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rkL1tRhS;
	spf=none (imf30.hostedemail.com: domain of BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+5608c610d26bcec1a9db+8376+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rkL1tRhS589w27c03L/iKFIwI6
	bqAiqJcPrEbMpmjf9mx6+CvlgQvTU7eNHKmDx7/wlelA2aMnY8/8omcMw6NRIoGpPw9yluYMaWmBN
	gBQmZo4FEWUVM9sCigArBsZzj5O1Ys+LgIue0QQbekfW9lsELlNvSIjfdSlafd5L0K887M6qDXsYd
	YAntas6Ph1jM5eshuVoUY5F6RN5+iZq22oRLze+XlmEA6LmbzOFHuhYWSmAMINSckDRz8WhBpTWVQ
	evwpgZxaopjIniNiZnKWafNb4lNSo9TExbynz/nLC974xLOZxkorcKDOvNy+9N04pYkuuIkkTIg9x
	rV53T/kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpLpp-00000009oaK-0q6X;
	Thu, 30 Jul 2026 08:09:45 +0000
Date: Thu, 30 Jul 2026 01:09:45 -0700
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
Subject: Re: [PATCH v7 2/5] block: add task-context bio completion
 infrastructure
Message-ID: <amsGyU2clNRBDYdz@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 77FBD80004
X-Stat-Signature: jz1fesocfrpn176kanw1ug1kwydb6i56
X-Rspam-User: 
X-HE-Tag: 1785398996-77976
X-HE-Meta: U2FsdGVkX1/o6Qzg4/NYh/cgrZ6ZtDsdEDGPY+s1S0rl4MzL+KeYBtXI11P3TJ/EjsDV4pho1j2wg/hOrCzQlwh2VsGEFTzRHv3+6o1AemKwlfWqduxB+XTcHyT5ThEFwiymSJdGsD1XwRgoe4BGupUzZQD3btkW0arXpzdlkUYtX/m/5N9/boQT8RupPks7GOThCZpLRl667rUGu5EyRfZO3A5wIE1ie4cEhRxryk4ejG/MJ73gXvvw8+gVvfQTCJsDetOLprt/6B63mdckP0GpVD3EZ3jC4oMclcCNW2Z8MYRaXQlbehEECAAJyp4gkkmuH3rp6urhAmCYPNsnDlgYO0m7s+oNFit5VT/YgmIJMJ3ejJZsbziQO/JjUiDf97xazATtkqKzJpA5EfxLnEM1T73lqeQ8LqSerNvqr3mDb7Uo+pQwLT+xuUgyl3HLT35O8ZXNEoK0dQaK0Hiu3taPA+4PS5kYN3AQLy91t9JQa1TLmGdeygO4f+zZrqk1R7UUkARp4fwzzcFmCeNntLQJ8ZQZQykCmt4Qbki8K2OuVEul+EJQbk6DzOAaVbMoJBV6zM8G7BzxpVO0S+wIkPa7jmnxxDOVRw0WTsPLVlVGXR0gRTmJhEM+mDfltcfH76Iqkvm7gTPscrCWL85PQUP7biuCSxuFDqEwJ1KM7ymU3iDoL9b/XWtzubpJLxRb6GI7j6gHe67eNz8Aj99+j24ou41tjSGDWXSN4DAETm4y/IG8Nggz0tUQP7S/A3TLm8lGkiGo3SV9j7CrvbsCHyfPnDAKZQ47SuFNpKRT4jmDmcU6TT/geaiqU5lPrXrdz9+TNVT3oJXgIhWlA3iMtOArG4oKUycvp2uNsq8+8Vv5KzYa+ydQMQVBMYitwwsJA4NFds1ta20kG2iOw7fL6ujBc6QdW9bZPIRb7aubivlABawNNWxqzYA3lDuZZNbWuFC32xfrR0F4bpl55xL
 Rv5dADgZ
 Xiiqr/yAbQAdkXRmP20O6jwTWvAG9kixTiy1ml0WtWri8N5phCcaZQF2dSzIG4ZE1cvVVWzybaR7jEnuQVy1XICTOATsfd0m3sE4YviZrQVqZ7jeK+9Q4A5tDI1slqcCBDK/0GSPrUcXR73WFQGdEbdr9yBbUwgISKv8DksHFkFRdKy5fPjjtBXAP2kQLzYD6NcSKXP7Ubr0KJOZgGLmSKPU/FCOxeydUOK2hYGQWwMTBmeALvmVJnT0iZKR8GvLgYmUdP7J+NCC0+AAbkW2bUudNT45lRjfc5gGWFF8b3Y85iFgGP4JEgZtp5I+WD8BRnVQ2GH65psCBIcxSAhqrjy1DJUZeTVPonwZuHt2IOeRvfMOzHSikZFrFLsarZili/w0poRS2JBCTe/1lDLN6yJCLgCBDWD+46WKWP83sfCUT/RH3Wd4wBGO8GPM6yY9tz1yahu2kHTPDrzJGOOUtfEmYdILKrrVO9J53pun6YBQhIBJ2fQARkgkJXdW6WyiSu8Kv+kX1SKqOvbAmjgqgJ+n1gyzfhhivsIDh9w+QBOuc0uWQ4JXhB+Nhyj1Qmt1n9fF20GHfx0AaXJmL7KJ3DAIP4ZItI7TY3f2z6lPIO/s74y7/SoIhjNZTsGPwxUEvnaidb/aWrvfTbDj7c8An1PLKjdt/rhtyO9XlVyH6kanfGjgL+NMBJNJ7QbfQ6bE52YWAhF3bnOVqj2Vkp6Val9sj+GAPszwYtvl+blACD4Qozmz39sYuJ6nubw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


