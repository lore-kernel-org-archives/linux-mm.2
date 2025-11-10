Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF90CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 07:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195C78E000E; Mon, 10 Nov 2025 02:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 147538E0002; Mon, 10 Nov 2025 02:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C5E8E000E; Mon, 10 Nov 2025 02:16:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3FC28E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 02:16:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 867F01A0C6B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:16:40 +0000 (UTC)
X-FDA: 84093839760.13.D8A4A1C
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 14F501C0005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:16:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=w2KCAMDr;
	spf=pass (imf20.hostedemail.com: domain of ywen.chen@foxmail.com designates 43.163.128.50 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762758998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+GcoBuG4sDAppZpZNOB0iYZLKRwCsUHdJqQLyG40Sw=;
	b=CYe8NFiQlSEMwj2ZC3+tHVOjo2YygUYEZsFcYrnsRZK7WkQnUbw8Xk+gtqo05OY2umU3rY
	4bud9ATYgLhRIfoal7sPlUKOsIkHpXAZEZlyxv9DDY11c66g3QLCSvalW70g4x+vefD0AF
	EzwS33J+yLHd1/FXuyjlyjqNVOf9PSA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762758998; a=rsa-sha256;
	cv=none;
	b=UpkRSi8I6RVitzNuiVXwsTebvDMYqZuv07cdR7eek27AMvK8kn9EtjJIX/Y7i5WBaMdPKM
	RcumEGcp1ozFzdqFg1WUzaSA9bBSiFoXXSAjY51Y6o/0h1FDy+DR8PALMPL7CBxKxwJHTw
	n/Wi/h61C2NPsBp5TVcXk6VafOcWdqg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=w2KCAMDr;
	spf=pass (imf20.hostedemail.com: domain of ywen.chen@foxmail.com designates 43.163.128.50 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1762758984;
	bh=O+GcoBuG4sDAppZpZNOB0iYZLKRwCsUHdJqQLyG40Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2KCAMDrAkcuCHe6iFy9YYqAgB+d7oghoEG4eMOXHzUDqA+jYMRwkSC/6pNH/GWre
	 HjWx1jstY2hnLCxJL26tiBr1dE1LSaXEJSs2dx/YyDLtwdB2ifBlde29njb3KexFhC
	 eWeUFCqcKJ+cF54kxDtIIe0kfTaH7oq2ySVl31Gs=
Received: from meizu-Precision-3660.meizu.com ([112.91.84.72])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id 41615009; Mon, 10 Nov 2025 15:16:22 +0800
X-QQ-mid: xmsmtpt1762758982t3wlzjwxl
Message-ID: <tencent_B2DC37E3A2AED0E7F179365FCB5D82455B08@qq.com>
X-QQ-XMAILINFO: ODP7Xsg997RQr1tAclBgOGM/U7NL7XxgpApi56eeDQMLH6mACPF9+xJzDItxEU
	 bhFds5HLQVv1zXCSY/MXQn7hoMuNRXT4+fyHKCypwmmYuqt3FvL8fsu5XDikieG0A8xTcAyuJXoZ
	 Qje7ZAX5BSg1SZCWZK3TamPLZxZ0dh82K4UFMXlEXpCG2UptW2QoJr/MvfigCNEMbe0BD1zZWBeS
	 GQBUSt7ulOjfzEPvjIrzJoZvgDSqnlnMFmqc+MlXcQe616eQP7nXBxgnwUua2oz7SS4VBwkwbOTR
	 2tWM04BFF4FU6Seeh1z/2dwvhLXQi7ZAkriuunP/lYl5ejP5UcCktNS7MbrF//1aLcfw6HQNPaLN
	 B2J/XXFndnX432B/YgslOtnk+IQFeNccGX48qvXS+VtuibB5uz+NNjE3gtArwgryv1MznNAvxHhj
	 14HJld/DHRtzKmQupCI2e5ecJMGqf8+FAO4ZZobM5kmI7YbCyaVJv4XGxiJWF0z8U5DB0NP+Wkse
	 jKWSquF/n21Fb0X3RmKOEDsMCgoVbXcC/yoBifa2vlEMdNkUNbQgQechQz1derzE7lKVkgLQzsKU
	 xtWbgzbLmilhVasyBDLeTFx8XqcHiMW2uL6E6LLoWzQcGouSqZ3IykqFX9pPeI7EKa/Mu4DX/dx1
	 nUwIdG738w1JNWCsWMvXT4fD7BcH+u1k6JO6WZiK18YjoqZL3ULPxsNhuOeiglmdxQ355CduQsrX
	 bwDN621x29Wf2W4l7rUpAC3pa02RANpshNY/ILPdfbpfj7bz8CPrNTXi52SBvePSbnLjQfWxOvSx
	 yvgR0Q/MJWOjWrnJo/+aBzXvjSVbgRAR0qUFngqLa94anzWI4YsnC7JHxlh7A9NmW8U5EXyg0O9W
	 SIaq5W1WDS/qLFO/yDgH/MFAljC823hPWGU3aiHEInOQhwRp4dFu6EXPmGUEFRmf+yM3T+HqT/jM
	 QGSHiJad5XLfRo+/3vP2f7Bh0rO/Z2GIG6Shb+7x9a+A3aCPeWNdFyLKRFJR4E2fjw9XUB8nIaAO
	 8iB8AhmL7i6+7u8X/SCjvxIjYnqBgqeAwPqqlUloKC3gr/sW92
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
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
Date: Mon, 10 Nov 2025 15:16:21 +0800
X-OQ-MSGID: <20251110071621.2943297-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <yv2ktkwwu3hadzkw6wb4inqzihndfpwb42svuu25ngmn6eb7c4@hclvcrnsmvvk>
References: <yv2ktkwwu3hadzkw6wb4inqzihndfpwb42svuu25ngmn6eb7c4@hclvcrnsmvvk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14F501C0005
X-Stat-Signature: auurciugheycpsz4pz75uctjb8hiz1yf
X-Rspam-User: 
X-HE-Tag: 1762758997-346076
X-HE-Meta: U2FsdGVkX19h9MqiTM3Brhy5NwizeHXOZNSc46xZTD81mRFp4/KfYOUCFVP7fD/bcrLtH08foL+iprjiFsyQ/Fq5l53RxloJsK7AJVGaFdERzXslT6c1quxGCVxvVt6Lr8c2PEDdBWowI7x3bYDdm35xT0v9Em7bUvKvVPUSW5lIBMrHAh4WHMGFE+e/ISNil73u4DUagCcEubYU7ojXQox7r4CAqsMo/BQ5loOtArllSjZrUhis6b+V0lrmBVwOAoiQQonyFmO37A6/1JSlymycdw06s/UXQmtGuaNzM/Wl6GjL6K7nu2mvKVQsWEbQTZp9xVGFh0Sk0hRx5AP41xvB8UMF8PEJa40obZeVPGiu78A+oBl0QDliRtfkxxJCXXiB9Hd380+mFtaVkKE7QDzs95Kf1jjPQTCntelJivgF6NhhnALPJZ6DF6vxXl1XOr31lsUsCtAblWxMLPmKhufFVjozzpeTUEW+U01/muiqEKUum08S4m0ZSuv2vnYyOErb1gxAfV2gYiPPQT8xo18k1/i8e+yS4LNhgvvbPtOfTiPl39OVDBh13ouqTCd9AetkbrqwdjhYyauUn1yb5jgsqHUWI3Wdoqm6L9JEzUVqlvnWC5fOYl8TqIF4inzDnq5I59vP88aLBaPJzE4gOFU+IByn8GzHXRyp8cqXPlPB7TTAGTRFCbohIswkRBj0K4A88q5jvGMhyMo2l17EtUjxjMJY1AU84qb0DLy8D+9ZsUb/sMmjp6xuwY8EcyTpVKo5uB5yK3Th69gTJt4rjncSuUNVfcXUckGJeagpknRt+5N2Bn4nicG5/GiuyZttht5RQGBRbraLMw5BBIT0+L7qVOROVkHkOzz634Xa8hsaQhbLU+j85zDEbkGYsoTeF4O3/qNZSNU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Nov 2025 13:49:26 +0900, Sergey Senozhatsky wrote:
> As a side note:
> You almost never do sequential writes to the backing device. The
> thing is, e.g. when zram is used as swap, page faults happen randomly
> and free up (slot-free) random page-size chunks (so random bits in
> zram->bitmap become clear), which then get overwritten (zram simply
> picks the first available bit from zram->bitmap) during next writeback.
> There is nothing sequential about that, in systems with sufficiently
> large uptime and sufficiently frequent writeback/readback events
> writeback bitmap becomes sparse, which results in random IO, so your
> test tests an ideal case that almost never happens in practice.

Thank you very much for your reply.
As you mentioned, the current test data was measured under the condition
that all writes were sequential writes. In a normal user environment,
there are a large number of random writes. However, the multiple
concurrent submissions implemented in this submission still have performance
advantages for storage devices. I artificially created the worst - case
scenario (all writes are random writes) with the following code:

for (int i = 0; i < nr_pages; i++)
    alloc_block_bdev(zram);

for (int i = 0; i < nr_pages; i += 2)
    free_block_bdev(zram, i);

On the physical machine, the measured data is as follows:
before modification:
real	0m0.624s
user	0m0.000s
sys	0m0.347s

real	0m0.663s
user	0m0.001s
sys	0m0.354s

real	0m0.635s
user	0m0.000s
sys	0m0.335s

after modification:
real	0m0.340s
user	0m0.000s
sys	0m0.239s

real	0m0.326s
user	0m0.000s
sys	0m0.230s

real	0m0.313s
user	0m0.000s
sys	0m0.223s

The test script is as follows:
# mknod /dev/loop45 b 7 45
# losetup /dev/loop45 ./zram_writeback.img
# echo "/dev/loop45" > /sys/block/zram0/backing_dev
# echo "1024000000" > /sys/block/zram0/disksize
# dd if=/dev/random of=/dev/zram0
# time echo "page_indexes=1-100000" > /sys/block/zram0/writeback

Thank you again for your reply.


