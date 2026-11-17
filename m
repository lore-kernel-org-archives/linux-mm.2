Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4668E606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=akHKDD3X
Received: by kanga.kvack.org (Postfix)
	id 562AA6B05B0; Tue, 17 Nov 2026 04:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513C86B05B6; Tue, 17 Nov 2026 04:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402526B05B9; Tue, 17 Nov 2026 04:32:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFB36B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:32:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D54E1A0391
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:32:37 +0000 (UTC)
X-FDA: 85444095954.12.0EA72F0
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2FD4D1A0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:32:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=akHKDD3X;
	spf=pass (imf19.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794907956;
	b=SQ8FMTlajRnFDkxkTdUXx8Kjhp0Xp///bjCqemMCu9MvcOyDXtouxv5J8HxVRcvS+65MvY
	t0y3M57neEDqM2QP0Ob7jsZdNJjVkxFu9NZlImCNWhc+E9HHna4DXOO2sa9qhKmZHMVeyH
	MRuxEmCnNtiWS+R+ce7sLDXfbRvRGds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794907956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kXfjSX8A0sMCwSrc1NZ9DdCD8p1mIiqPqqCInt2hce0=;
	b=YZx46nl2kMtsc7sy89W89YjDkjItD2s1D3y7Iz5GJXg+l/zkprO9rf2VcCuzZefo7YuaHQ
	y0L0ipHwa6TaovhEMWSJL/9ZUgWj0G7fqdNvFz2OZGdf7TLEmuP9s7Yuv4LziJl0/zkxYO
	oBx/O79ZCqnHmD/DlpgPnMHa3jtdxKc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=akHKDD3X;
	spf=pass (imf19.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kXfjSX8A0sMCwSrc1NZ9DdCD8p1mIiqPqqCInt2hce0=;
	b=akHKDD3XFur+jgEm7qdeoTDQvtUIj3wMYu3N0UKMq91NlUGx2dBznwEFvtCsCCn9/iyCcX/A7
	pH8DowUtdDJ20EZLRab6ImOXhhKPaRGe0ZNw6+SGzwl3qr2It3xOXSGjJwU5d5Qg8V+C4WxjbM4
	EtkRZJz/82xI+rt0JH3IkVY=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4jTKJF1tByzRhT6;
	Tue, 17 Nov 2026 17:32:13 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id 398054057D;
	Tue, 17 Nov 2026 17:32:27 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 17:32:26 +0800
From: Long Wei <longwei27@huawei.com>
To: <rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<akpm@linux-foundation.org>
CC: <graf@amazon.com>, <leitao@debian.org>, <corbet@lwn.net>,
	<rdunlap@infradead.org>, <linux-mm@kvack.org>, <kexec@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH 0/2] kho: expose incoming sub-blob metadata instead of contents
Date: Tue, 17 Nov 2026 17:29:49 +0800
Message-ID: <20261117092951.4017931-1-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Rspamd-Queue-Id: 2FD4D1A0002
X-Rspam-User:
X-Stat-Signature: pub9fej4dd5t7dw349rwnj4dnanku6ds
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794907954-161703
X-HE-Meta: U2FsdGVkX1+4tu36+atFECR66PwaLw6THnsEl6Jzt4xMDqMd5PkuDG0Oi/mZFSK4V8LA5YuA00uOa6/lJ+5JSfYIg12r9vqPIcFILg6GYVhiOMF+4uRkYIlocgZc6Wxs3k+iSqdZXvVQ5fK+xCjbn24jFdvNpCWTBkpHrHKhFmozhSo4zjShuFh1p6Nln0QomyDYBZRR659FWHtGnbFv6b6P44NfONuXg5XFKThl0DnweDk7rovy3/OpJXsBAtwyyjGcO7AtFpkkzM57TwubC22E3imVtcHeQwf52BjPCg4psACUGAUwuTymXSWdT70298yp5rWOA3NSZiFWd4YwaZL/7D2w3mnkKngCoM2yzJQmlgIbbZ2vm1pUVPnITVgnkRI0Ip1aueAIAQdNl75Ap70rh1jDfkBz/yjvtMTF4LqzUjEn6GbYRL+4OEs/9Ynsyphue34niZLwxHLT6RaoZIjxRpx36ayw4le7Fb48kjiAqMs4zfWN/neLmBmpI0a4TC0gBbaOTYtDiWnvFJYig7utyDTJ7Upidjhwkz4xw3saKq9hEKMZGjbOgppOfVyZUSj0qGvBTfCu43//IrhygX5ZJ7ySC/RpC1F2eTx5MIKiwvBpBxPMXWahhf8r9J+K2N9mgqg5yqw9HckZZ/Ci0pQ5IUr80dwLjbq7ZbnkDlD24TS3xqPF9HD4rrx+HcE2vglazUTpn2OETX13YoJ2LaXm4alMmvCBKWGlZ3qAfMMOpYYDO8aF7tM/s8rlwsKtsHS1sonzC+wBvtVCjE232z0oBPLWIxvqL/P5m1Sq/O1+8FXqw5a81IJaRZ5vuPuDBQofuqziZbjtgvk6cR22r+/M63vidnHP8EsYcFfXmzNPHqfG98sspokVR4foYAioV1Yfo2Q/OeWPZuwvtzP+DetKOoPhE878MlLv8ZUimX5yeJnnJSmkjLXgh1Ffkzv73tZ2BexK/qJ12RoewMS
 H6Ff1Bf8
 /A2zEGjP21cLTtUPvmE+j6hJnrHZaYeM7mS7s8g9PvCPKzkqqpq3if/Jjlsg8eOgQi/Yh5zLP4uv7XuNYtU80/3cfRJ4LXAk4M+xv8+eyjLuGIpL5xVwnS8UuH0fX9kz9Yg7vLLfGnTBWN64Qsd6sQDggNX3rFQp0v8Dmori1wOK5dDYWXzMlnOiWD2jzQalPjtyMUzC8QunF4RvsdVByEbmIpe24EZoPHsdr0P8cJ1wwIxCmlZHhi9gr9XAsSZJvv1CFvX5Bsi3NbUbW6fNiHgwV/x4Auv10wy61+o17EuZmDyrRInYCw6ousPoNEwV9q/0YvkaC86bEQAMSMCYmOjWdl2wlj1KyZfHjxGkuMAl0Zk5NqNvhfEOA5ayvq4DqNMTZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Incoming sub-blob pages under kho/in/sub_fdts are owned by their consumers
and have independent lifetimes.  Consumers restore and free them at their own
initcall level, which is always earlier than kho_init() (fs_initcall) where
the debugfs view is built.  LUO, for example, frees its state in
early_initcall, so in/sub_fdts/LUO ends up pointing at a page that has
already been returned to the page allocator.  Reading the file then triggers
a KASAN use-after-free in _copy_to_user(), with the backing page already
marked page_type: f0(buddy).

KHO does not own these pages, so it cannot safely expose their contents at
any point.  Instead of trying to track which blobs are still alive, replace
the raw blob nodes with a read-only in/blobs file that reports the name,
physical address and size of every sub-blob referenced by the incoming FDT.
The FDT itself is reserved by KHO and remains available as in/fdt.

The first patch does the change, the second updates the documentation.

Long Wei (2):
  kho: expose incoming sub-blob metadata instead of contents
  docs: kho: describe the in/blobs debugfs file

 Documentation/admin-guide/mm/kho.rst       |  6 +--
 kernel/liveupdate/kexec_handover_debugfs.c | 83 +++++++++++++++---------------
 2 files changed, 45 insertions(+), 44 deletions(-)

-- 
2.43.0


