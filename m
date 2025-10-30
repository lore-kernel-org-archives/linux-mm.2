Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B058CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841EA8E01CF; Thu, 30 Oct 2025 10:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2008E007D; Thu, 30 Oct 2025 10:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707378E01CF; Thu, 30 Oct 2025 10:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEB38E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:31:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED3301A0190
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:31:26 +0000 (UTC)
X-FDA: 84055018572.23.F59A991
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 431E2C0002
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:31:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zmmw5/Dx";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761834685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QsWleHP806xnflmulM7FkIJpWtjvDdIRtTiZkzBuYCY=;
	b=BPbWdnKzhwNBpDg+u9jzpJH6VRI5vM7sHn/E3lcwVoOj6omx+7uEn9AV+mSogYrzyVNsE4
	Mbu9lcVaKFvqYZMf2KJysBcvk4RvJo03C54GwiN4gJxGxpwtFk7aYhd9ohkvMvs7nnkdYC
	fflBVBnNG/QsDswCCUzWVTSRFfN7RuI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zmmw5/Dx";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761834685; a=rsa-sha256;
	cv=none;
	b=kp14aSsHlL7erCV8JBEr5nUpIwOHELTXkK0w8vvi/lCWXznntcudDEb01J5M23s/+V+ojW
	N6hnLDvZZkGICNSoxjZF1iW5KJTVteu/31eA381tdUB0PIIg1KFJVR/UGDWV3kxorRfRdC
	89p0ehe0Qc6ZofvLkWrpCKA/4sOJDs4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64C2E62190;
	Thu, 30 Oct 2025 14:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BEAC4CEF8;
	Thu, 30 Oct 2025 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761834684;
	bh=wVeI2bnXMnl1w241QzL6qX0vCpn21BM863M6E2kLIP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zmmw5/DxF/Q7Hn3z5GWlK4KKI+8xA4rJZuQbGWiaovZxVH59927YB0QXzb74DAoRe
	 +ns92p7RyrWSP6aTuFeb37I6lJ5inAlGAvzQuDpibr6DDp+Ak8dLCt6vqtusQohnOv
	 YTxZLxLo20oI6dAhGO+tIz9P0jIcdBnHWmLhAWgoHarexv43JujzLGCai58myLDssS
	 my4arN+0SUr9abOWKzoD3lSV/7FTPxXb9PDSeGt5aYs4nlDlizX387iJGHMxGW+p1J
	 zukfGgVZ524yqGT6oad3PhLYHQKiPUIerTI7m+Nvp41d0d0I2gSDVqDz/0AlfMI1p5
	 FFv55IqYizoZQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH v2 1/2] mm/damon/stat: change last_refresh_jiffies to a global variable
Date: Thu, 30 Oct 2025 07:31:15 -0700
Message-ID: <20251030143116.46746-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030020746.967174-2-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r68sq4e7kt9hywk6io4en8ru7qmyp36e
X-Rspamd-Queue-Id: 431E2C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761834685-617598
X-HE-Meta: U2FsdGVkX18TwvXW0r0c66B8aqtmqaXInK6qxUk0pQjGL9uiHAzLHJbdxlfIDfhZNsMe7ZoBiy6rXSiylFfTYtXg0n0Jc+NWyjIBggkGn6aQNv/f2WiM50o/Zy5yvyH+n8uoKT8CDBMf7UeilRoK9TbGzclo8lWkaadNjDS1R4pUTSPAWzjTHY8iWLZpyAw39oTyeuM2KbNp4NWWC4FLQVOHA91vyGfXJnRWriS2w9l7P/+bko7U+mZUqpAlw0d7OrJvpda/X/Bkf6AX18Tpfz8rKm/fDrmY/uGOilwJAPMQPzjr+I3ve5LhQylx08w0XDzBDahtpP9tdJX1BsaI1KEA2kOQ6p8psjuI0+GLpy8bsBif81YeDp0gHIpHw7gqtXJSzHzeN5PPXZJucgID8WNAjhBl1TWkbDReWKAdWgBMVF7lMgQXraTs4pe4DQwS8hRArP90DLqqbtkAcuQuQ5gggyhlRNOm6uNywF1L1L5IQTb8vn5qxJWuP6mvdZ+aFkRA+onOK3KvayAnOZV3KT/LRfbLQrqdbIsW8iasKRmAkl7VpxuajcKfxZC6Wr33gpeCyW9HLYmcodf0F/vRAwAj4hDQOQCQbdvbSfourgPGtf/TUJU8lYCmpPnCe4GU0fMkN+iF7QRHWis/sXVHhgD980ETXT5Bx6XioAYjNykKipL1txUmD5Q7lrFoKzng1BqGTFRreKHIui1T6PVDllZ504whU9yFNl7w+6JGyzT4JUi6t17Dj/YPPO/70RpoLTirtCaLjHIddV4QG6TQrp4KPx2jr45V2N/+/Wxyi7OyJvHV0Gq5YGhXlFr3zekuS7msunj9xWabwRH6WBNwxzhGquNIUjIv9K2x5zOuXPn9gcLHvOEECLcV9v2878RPcyujQRjp0Xf3AlCz5QKItCuYquJk5ZKn0MpgGXbJ4XoQM+xBBoXWwy7JMB4JQ9/mgqg5l145RtzuZHIuusp
 HzWIbr/d
 u2oyn65adwqY20kuoSWtcHz7jQzIuNZ6LUKh1J53aNcENqP+R/Wv23Di0RIRfRZud9HddOxGG2nxupARXINu+zD6mMp7caYQ3nhiN4Ua5XKCA6AKlD7qruubHMJx+v6PzUpVSqExRqqMwsg6JKHMvIvkuc+OQMGIbum9hCgYgI/cuULLz4ej/4Ksofj9RmICEUzep7q7l19ACB5VlnUwXPRKFzf8rnnRi/fPcUZXzHvt1dV98Do7I4X/yPUdGyKXlpqqjDxPcurSj5KKIOCOo0duCSCp6T+8o2AegNzk6ai1UEzpxN3ckQ+1bg+6NFXCmSu3AeyItLTAoswBSlYbVzgOOE7aymyZg+uShwwTCLZGF4Ks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Oct 2025 10:07:45 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> In DAMON_STAT's damon_stat_damon_call_fn(), time_before_eq() is used to
> avoid unnecessarily frequent stat update.
> 
> On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
> jiffies wrap bugs appear earlier. However, this causes time_before_eq()
> in DAMON_STAT to unexpectedly return true during the first 5 minutes
> after boot on 32-bit systems (see [1] for more explanation, which fixes
> another jiffies-related issue before). As a result, DAMON_STAT does not
> update any monitoring results during that period, which becomes more
> confusing when DAMON_STAT_ENABLED_DEFAULT is enabled.
> 
> There is also an issue unrelated to the system’s word size[2]: if the
> user stops DAMON_STAT just after last_refresh_jiffies is updated and
> restarts it after 5 seconds or a longer delay, last_refresh_jiffies will
> retain an older value, causing time_before_eq() to return false and the
> update to happen earlier than expected.
> 
> Fix these issues by making last_refresh_jiffies a global variable and
> initializing it each time DAMON_STAT is started.
> 
> [1] https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
> [2] https://lore.kernel.org/all/20251028143250.50144-1-sj@kernel.org/

Thank you for finding and fixing these!

> 
> Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

