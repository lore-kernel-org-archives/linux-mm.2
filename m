Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A63ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A5B6B008A; Wed, 20 May 2026 06:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4206B008C; Wed, 20 May 2026 06:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ABD06B0095; Wed, 20 May 2026 06:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06C4E6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:30:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB8E41606C2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:30:24 +0000 (UTC)
X-FDA: 84787428768.20.72A4D94
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id E12F7100018
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:30:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=CgrIDFsw;
	spf=pass (imf14.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779273022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JshG2Rkio5xP3P8RtvD6kIRCzkBOc2Y2DUQP7ru9HaA=;
	b=0ZXB32bA0FZsEG7DqT70Ndpy3R3+//kTk1WgH72/Y2NmQHCy7rkD9cWXY7Rcj05Q+Vbl1P
	CjJpZBh7BdDivjhSZTE9IycWKQiPdQhbLMWbOwBz60jQoBOl8x0CHUQAs6RtHly2Pm66S6
	lSdbUWmxwFuWByC05Vr5PBHATrU7v3E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779273022; a=rsa-sha256;
	cv=none;
	b=jRj19ob+aJ4DDD4om1zN3ESuCBfYefL8312v3yL43OMFIDgnwWwpy8mFgBajJziqLiMATQ
	kkOzAMtqZ6vvxKRZNlV5V1XLuzNz4hmLbHNnh/R8QpuYaxMrj5X64GJkM5Qq68gBvNJr6j
	BOST2yoxYH5PGN3x+V+VrwCA01vY5bc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=CgrIDFsw;
	spf=pass (imf14.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Js
	hG2Rkio5xP3P8RtvD6kIRCzkBOc2Y2DUQP7ru9HaA=; b=CgrIDFswdbzn8/6Ly/
	jTgzcJwAEfYKTPDAf2td30MqdJ3ksrhbm2g6Ak99rf9BpTB3dJlEuxpOejXOcXr1
	23nyGlqHW1RSof5RPeThlisanH5AbBfjUjkd+VVKHtmgd5r6S1Y+zX0cqZJhZa1T
	+tz1KHkj4tyDFiIzgS9ZiG7pk=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDHP1wDjQ1qJB6rCg--.37309S2;
	Wed, 20 May 2026 18:29:24 +0800 (CST)
From: ranxiaokai627@163.com
To: akpm@linux-foundation.org
Cc: baolin.wang@linux.alibaba.com,
	hughd@google.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Wed, 20 May 2026 10:29:22 +0000
Message-ID: <20260520102922.63737-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260518110816.79be9a7c71777c1876b0019d@linux-foundation.org>
References: <20260518110816.79be9a7c71777c1876b0019d@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHP1wDjQ1qJB6rCg--.37309S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFyUAF1rtFW5Jw1DZr47Arb_yoW3Grb_W3
	WUX3sYkr1DJw4kJF4kWF4jyrs7Gayktrn0qayIgrn8Was3X3s8XrZagr9ay3WrXFWxWFs8
	GFy5XrZIgasIqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRCxRDUUUUUU==
X-Originating-IP: [2409:8a62:10:5dc0:5054:ff:fe85:ffcf]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7QVCjmoNjQUqmQAA34
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E12F7100018
X-Stat-Signature: irtcp9om8g8k1c35icnit8e8wa8f3sho
X-Rspam-User: 
X-HE-Tag: 1779273021-482475
X-HE-Meta: U2FsdGVkX19cO3Bz071XLeJqNQQYnYt9oBBRX7kq5J2NrZGPz30aK/Vg2Rj2CvDh1qL66VpUOw7LrAqjmWycZ4oBEl8DEgAQZwwkLD0++1wZGjAqq9LisggvhXDkfmhlDS0b49rgC4LGqqCKkigOPnNvGCwr0SUp3xljenGJV9F8IDgbt4waeXO/8XzTudbQF0Y5iIhvTg3j7M1HKEWHtt+czdXMV/uo6tg3q/YYCp/MV764SGi4ShFp57+7PF0ZFOrNF9yUKLuPuF7mOjlXdRaFyYHR9+pvunnv6OheI1ZYnX1+IDsxg2qcrxqc3g739/iy8yzPKRidbyunO4RsrdUyJe8yRMC+jF3L+KX1r3sbA4UZ6sfIbnRkq7vPlnqcvFlRcJAONA5B6NNjYhNCqrI1tg+DgBOMZ3fiIlxPaYYTVuqwnhlMLcG9GFQuorGkkw01LsQSVZfPr9Sjy44fV8o4eJGVDH9aKXdd+KXCAWgTOuSvjjbbm7WFwTx8IFNRblRJ+dcnoWc5q1M/NKwnhTup165VOwIySznBLr+9IykV/mlhfTop1N7CGhRhOERBmYVgCkw87JLCFulJIXftwrJD1c4gH3E3xCZNcWKuBQjHzhYBzeZZs+NtWw7d+S00676pppfRYlHyxrFd8vZLQJmfVxE/3YrO/efC91i9RNFkXPt3znzjzgxggJHU4rpgBNfI12A21ipgWwZpyEGNaY0BuX8cqaWxeiiO6YvCIokS2swKld3rbFlPbKuJWcYng9U8RLF/6iJ2Qvx1M1dcAoEXqPl5qcmJ11T/Jc169vyh12ucDs2cY/EMj+rpqnWZ4M2aRGiJcn9uebQGFyEtZO8wNlGRC6oHag2D8J+RfHYtUP5UxM3c9E3VyEGg8G8oymwHyCiyalOrZ+FuO4vCZ0m69Alw2EGYK0vp11SRL6VvDxBYw74W2NBzJKnzPEzMbSo8N74jnYjsc+9uhJy
 wcbLHimU
 dbcJX7Rd2Oy5/LnEXsZSLr93d8bQOW3CqgsVBnkbtY152fh90n/+mRjR5l6c1w8/KAkGr9I4Hd2Xjnr4xCVA4b6CVbWjVS6e/97elG51W0hzweYB57s/ixhyfDhGHfmiUtuC1KEoz0yBG+zdCduv997aXAB3XEHE8RHhL2WsEMzdExB5VP1Z+AfRW0wZv+pJ2fDSPSFscwFs5qdGuqTqeYz1Ak02/GfvDaitTTq9hJlfFRYfQ8Z4JHkiusWPe0SzWLHr6gzUeOg7zDXxn8rUtGUQUIVR1JpFX9s5+zdb8NTCGlS1DLf/Eq3gD5yxfyGgbHdvbRo7+Xf/sOSFiSJ+Urz68mUkqVwTfyG98CQbtAzHnyh5JjFfkQM6I4ZmrVCHH8QndLO/XVxZD9jDJ/iWW3xUdT6zkeiniBbMIhvZS/VvzlBk+UvNde7oRZQDM3v62gq7N6w98BJIayD687yaXuFqMPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Thu, 14 May 2026 09:26:39 +0000 ranxiaokai627@163.com wrote:
>
>> Thanks for the detailed and thoughtful review! I'll fix this as 
>> suggested in the next version.
>
>AI review is asking about a couple of atomicity issues - please check it out?
>	https://sashiko.dev/#/patchset/20260513094508.50888-1-ranxiaokai627@163.com

The huge_shmem_orders_xxx global variables are of type unsigned long,
which is 32-bit even on 32-bit systems. There is no reason for the
store in __test_and_set_bit() to be split into two instructions,
so I do not think this introduces a torn write issue.

David also mentioned this optimization here: 
https://lore.kernel.org/all/4f2abf42-983f-4cc2-92f5-c81827e7b7e2@kernel.org/


