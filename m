Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FADCCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 06:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670678E0005; Wed, 12 Nov 2025 01:58:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648A18E0002; Wed, 12 Nov 2025 01:58:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586328E0005; Wed, 12 Nov 2025 01:58:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43D288E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:58:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDFC1C03BC
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:58:05 +0000 (UTC)
X-FDA: 84101050530.06.415B743
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf28.hostedemail.com (Postfix) with ESMTP id 23E07C0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:58:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=zqDfEvlK;
	spf=pass (imf28.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762930683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aI1DtojJ3uIlfMHHyo3gbCN97mQw0Es8Q9FMf59dQ/0=;
	b=MKQmPEu03PlVBJJNlCGUBH6jTLNA09TZWUfbe9bIXtfY82/BMvps7sVL5hvBtIUwfrzgCs
	Q0nmAgJdvFvd+Zq2mPks9Qm1vQH0EiEclU3z+CnHcbin+pZ+TqSUAwJfdABEuwqpyB/au2
	JU9EMSIvkmfVhb1qc+baCmBolgnW00s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=zqDfEvlK;
	spf=pass (imf28.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762930683; a=rsa-sha256;
	cv=none;
	b=oxlKQ7UpF1thvhGxIUuzvaMlfeuNmgSMyJjnwy87KQ8UIwj/ERzB4kY8o6P7SAm5zEhUlN
	+4SBsleFf8kw7XBB/dibOJxPrZNOOkkorYK+41/P5CEI3GDHhIHyz3KqrHKLoQJQP764gm
	CzUAl0p1weGIeK4CYv9+vXanjCfsr6c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1762930666;
	bh=aI1DtojJ3uIlfMHHyo3gbCN97mQw0Es8Q9FMf59dQ/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqDfEvlKJLREFssF4uw1yyzPn5zb4JamydPusG1CNaLj8LFC35mGLW7oZmqnG2g+Y
	 N/U4WuHfjH8HG7itM5LLbRo5RSZS//0hLaFw8bADTuEbdMmr7EWOmtfEmgdr8OXsS8
	 ATU2W3HvLhdxxeLRNM/n/LtLVY3xHnz16LeI8ev4=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id E6C29EB1; Wed, 12 Nov 2025 14:57:44 +0800
X-QQ-mid: xmsmtpt1762930664t3r16dqsu
Message-ID: <tencent_17B2F3A0BCCBAFD3AE942235EE98F1595707@qq.com>
X-QQ-XMAILINFO: N7qqMxIPUfzlejnxzQ6ythel/a3Tm6mb1P8jrwVKo9It+HgpxUwJ7p6FhD9GwW
	 6sBlZtFDtxdbIzunrvVRbintL1eAuUABZFf0n53X22tNuayQs9oQxTDv2W/AK/DqtfSHBbNrPo4Y
	 6iIhsknA5vUgM+gsCHBaIS/vhyfq7Pg5KVbi60NeM8hgYDrswKYGAb3G8G1DJcEEDn/RbACj/49h
	 ahWpe8BBeN5mxSXnNmOHInBw+1agxhJ9kxWyroctg9a7s4e1NG1Eba3fF3G2jg9c6J5ygMJxvc6L
	 CpxtoRng7XOMwMjELhQqWlntGmfGXsb6Qnxt8tyHvYuIPRA+z4/btPyyASqe009XJqCGXPUe1lhX
	 K4+hzj3JZqHdaD62ZSP2uUuP7jqksebAO2TdEm1ogqkUuKHNSBhIeTjpKleanyLp36y3nZMKWbbl
	 GCbE7GiGeZTtkNL8CFJD1B2ZZhtGSQWYIj/AaLnQnmu+v/lgjUTKBUGUwKfIRMt3ERFUpggU5wYq
	 HY765VN84IXnzkSpL9nrXooj4uc5Ii56oNPhQzmIX7jkajnI9BMpIfxRUixAGCY5bAXUbTFh2DPq
	 bXLjZeSDOYkUunhZz/191z2XPgIeGvyJcG/sGtdoPS1GlQvLz/8bjQV/MKTBS0+UPg1aOMudWthG
	 tiHPrq2dwEC3XbRMxLcj6sCMOLyU+aSKgTVOP/GQFaahImw768ahfc/tbTnUBFdgwOYJpLw+JcXe
	 yKEPn9og42iS5B4GXJylvMjvt1jBkW9tFPBZjCJBab9RH2Oyyy+69/sI1cJozfWaM77sh7GQ82Cr
	 htbvbHmUT26eD5W8HTVtSgE1xDZN1lL2qqmShYao3CRQnt+0id80CpFpR8b4FpwQ19tIa3GfFkNR
	 odsT3BvrYGN8uvaIFmBqExAR+FG4EEsQFUUMXYUSAY/Cyhwh0nFoBIk0ZK7SA2uCQLuhOYazcGc+
	 ZDNOa+ipxNAu1XEaXtGj1VwR1k3WsAa2t5FiEh2XHhwPzuXeKI5OQ1y0W1KC1fVZGqbr2sztBLLO
	 ggSopnFNvrKVCJj2/wcuhybO16fLU=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liumartin@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Date: Wed, 12 Nov 2025 14:57:44 +0800
X-OQ-MSGID: <20251112065744.3293306-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <htycvrcqbnkk7ldhpaqxesy7uhz3lssymwqm7nzkhyhnid3krm@mfju626njxvb>
References: <htycvrcqbnkk7ldhpaqxesy7uhz3lssymwqm7nzkhyhnid3krm@mfju626njxvb>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 23E07C0003
X-Stat-Signature: n966b1npimfq5ngof4jbm6hdys8yr3kq
X-Rspam-User: 
X-HE-Tag: 1762930681-678513
X-HE-Meta: U2FsdGVkX19VYoDeX1s2ClLAnAYX3G+hb4mY3oyoNkM7ERn/0GMnNiD1IbtxuPjXiWSmYiSFwK2bADmU3KbePDmzGyWz83OQwz+qy9tirNWSX0shGLfmV75CY5mX18jSCYIChkyV+IxVNCXYVeVAPNW5Af8bVmJbjkm5xjJBXEz8gpSuH0sDC7jAzavpkzzT+GfzGkUffwXRgSkgxjTlk6GbT2jDFVpMVpL7JvEvdHXC7yNtK2QtJpoO3Nj/rvAPBOqwnKBaFPyfBcdsQ7ltxAm3npMAnMAltQehcJM7D2mfHDKdqT5Fw9lVZHRoQZ/iV2wnMkN4nyt6bMEe48ET3ghQa0LGawtI2HqyAWxUSHBu51LSblOtWmNxHqhq+BLiYaVjU2gUxefg2PBx/hxsbOvgAJwPjHP0oKmiag7u0Cn2I54XJGiN5Hid6MsrIr+Nlz0JaZUFJNPDLAVQgPBRkiS/mz5D1rYg9mEmzvVDONewz0XZVWlc+4Rg2oQyC3TN9LHkusMzAQTCqQzO6DvR3cWFcHZ3dXFtKZuut0TOX8P5opzn1XnKh4pbSsRMEd74Y+f9VByigpNVYoYsyf14Po3IVttKt0v6sHgV9trw5zpSx5zxnVfa1mXVPBTmDBe2F1E6vac8OxysSoM8BOagRSjmFqJ+rRNd7gFP74G6iFgNySiD9djitTz4h82w5Bz6jH9r0AUcPldm+b2lMmmR5pCAphDQ3ikT/1MSdJwFmuBtjILvD+AF6mmLom3Ui+m8sgA61ta/A/16IKIwKS0hgzok7RpH6GSX7xd0FVC6QhutSUI9lJj9FnkqkKzZgAsFYkhWLIDpEn+bt4DJgr0m/KutugygL3v4kIUPa6N9F0OUU04FQD55le+CRan3o42/wWY2uwVlJ0AdBajhvcebKrpc8G0yry3UfeH4x4wUIvRiaFmWFQWeChFKxF7YkyJe2+SqYj33RybFEGHwS3T
 1floQUJc
 1JWsYqltirfPAnETG7azL2Y2RRQ3kFZed4v3NmSgudyw5hVJEl2ubFLL+dg/IRw6ApFXrI9XrQUuFCLsUPNbEGWHCGHfJFGqPnWo7rGa3BcHr0eJtCxob54NUxmw71mXbIegJOsAPCpF1WWSVenF45D5nAZNOxSm4CscbeLNyrlAfpir98mC+HyYxUdgoNcpYSoVoJJDl3u30vx9GnXrvCMOqQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025 14:16:20 +0900, Sergey Senozhatsky wrote:
> The thing that I'm curious about is why does it help for flash storage?
> It's not a spinning disk, where seek times dominate the IO time.

1. For flash-based storage devices such as UFS and NVMe, the Command Queue
mechanism is implemented. Submitting multiple random write requests can
fully utilize the bandwidth of their buses.

2. When we submit consecutive pages separately instead of submitting them
continuously together, the write amplification problem is more likely to
occur. This is because there is an LBA (Logical Block Addressing) table in UFS.

3. Sequential writing has lower requirements for the bus bandwidth.

> My next question is: what problem do you solve with this?  I mean,
> do you use it production (somewhere).  If so, do you have a rough
> number of how many MiBs you writeback and how often, and what's the
> performance impact of this patch.  Again, if you use it in production.

We haven't deployed this commit in the product yet. We're now deploying
it on mobile phones running the Android system. Our ideas are as follows:

1. When an app switches to the background, use process_madvise to swap out
the app's anonymous pages to zram. When the system is idle, cache the app
to the external UFS through the writeback interface.

2. When the system memory is tight and the IO load is low, use the IO load to
improve the memory release speed.

On Wed, 12 Nov 2025 14:18:01 +0900, Sergey Senozhatsky wrote:
> Why do you do this do-while loop here?

When there are no free zram_wb_request structures in the req_pool,
zram_writeback_next_request will return NULL. In this case, you need
to retry once to obtain a zram_wb_request.


