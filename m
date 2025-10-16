Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60667CCD19A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 14:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF2A8E0003; Thu, 16 Oct 2025 10:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496F38E0002; Thu, 16 Oct 2025 10:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3D68E0003; Thu, 16 Oct 2025 10:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D28B8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:02:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C41E3B8939
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:02:34 +0000 (UTC)
X-FDA: 84004142628.27.BCA6185
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2FAA32003A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:02:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fkSWMqHi;
	spf=pass (imf03.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760623352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=olaNr81UT3i0XgE7r39ZIOMvOjEJR62WYdjIOT7ahzU=;
	b=TeHd2/mqc0NLTloFpUBc7WwJPFS++zPrY8T5/+Q33HutTvO2vvmUzrn06NtO6nsh2j9auy
	V3oXZMNnfolR/UgacKolbaMZQFV2kx5Ivk+G5vL+NR6xpcbFekspPBDVqsGFtmyHETIt1T
	+PIOsZmNvQNIa8rsu7ecCwx3t4DBA9U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fkSWMqHi;
	spf=pass (imf03.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760623352; a=rsa-sha256;
	cv=none;
	b=rdZ2hhhMaKH2s39mQrkAPwE5PZeyosqQmUyID4v18ieW0t4eIGIUwunjOYYu5bc7imGN/z
	XAc4CN6ylvwXMv+k3H1CR5Ys9w57H7fSolTAzUlAbyaYCcRdLlKsq+mEZ3s+8zMPhQXFEM
	Zrb/Zc3eEU0INrF3qUWW2xF4H6XKDYU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=olaNr81UT3i0XgE7r39ZIOMvOjEJR62WYdjIOT7ahzU=;
	b=fkSWMqHiDBDAH7Mt9zDgehSnE9WBou3iEPzz+XFM/xtmJrLnN65EzekUOZXGZzOkITDZzkEGt
	QxdoquzGoWQBuVv3tz2+BY0gy04kXzEDqwT36tOboaep4za9bN0CtwFKBm+kjPEtiRPsdoORVQ4
	A15p9HG/dvEEFtIzqObSjgQ=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cnV4n3sHrzKm5G;
	Thu, 16 Oct 2025 22:02:01 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 709011A0188;
	Thu, 16 Oct 2025 22:02:22 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 16 Oct 2025 22:02:21 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
CC: <will@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, <xieyuanbin1@huawei.com>
Subject: [PATCH RESEND] mm/memory-failure: not select MEMORY_ISOLATION
Date: Thu, 16 Oct 2025 22:02:18 +0800
Message-ID: <20251016140218.15579-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Stat-Signature: w6wcfub66p65mssr34tq1t3u3zjjs9ws
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2FAA32003A
X-HE-Tag: 1760623351-580391
X-HE-Meta: U2FsdGVkX1/zRGG6NQQZ6Qs1dEP18/P59O9gDq+lohSt+Lcxyn0wn0VAJfCEheDant+ufwQc5p8+LGhHwAaWzfKYbFCsp6DjFQqoOgD+yIfn7d0S6r0H7d5LReU92tS1aUrmmgoZs+tc4UQ11wKCMhG/ad5IiriAd7t6FmhxQ4ocSl1WdHBTPQUmK4C4lVhQEp7FrD0lhS7kl6B8HmSVlTw+ZqC4XPAVKF8EwPDM3Hiurkokt0FEM8O7OEhTR78w0GIUCIxtVdS9PshlgTBXKhuIDXwmxKG21yyfHksBT+f3qqLGSUJPTnpkvHE42Nbr86TYl5BLWGI6myHg56wAPdVRs9O25KwHPtq1FECU2r74XHLb81lvGHaZISM/CXh/tLL2DTZaAbo3q1wTx5ekZPt0j2aa0USTil4FqEsOqzZ3pg91A88cUlcrRAvNlKD9xxjBA4aew87QXFRuPuqQ5nxi8uizcjdPAfH4+Q2kyR5tDVYnf2Cg0P1v9SAwoyVqnDHca99pnPkv+kp9Ci+BvjetYi2BvPLWaETqfYUkbXlcC5brmhIPBMPrvKmoKaywJUtP2yHf04WmlcTFhMvn5kuo85lRRuHmcWQHu+JUkT2yazU0A3RFhmXwK7e8LDbUzLKeeO5iO7smpDFIp2iQZGN4s3VjjzHKKabUvlp4CbRR9Xd2qOxc4CaPJJm+diS99MpkOKkWWTCB3WD3xiqlHnv0Rx7MQsRrze8vkOrgpSfgjwPt/HDhcOLyGwe1geH5RdemUeGwEb8ccc4F9UlCdReYFqwGm9cHYKDQW9BdQObXpi+U/4n4khM5fWtC9hclDLXMkqCGzsp7WkSKjZcmQuxb4meXlgfDgStBI2qqFM2u5uQM2lHuOfHVwBl7SaDWvmMDavzs/3LcR3fhj4m/EnH/O+CEHr8rAKTzq9+XeUlxjdcvy4yhHpjZZoQbTxmYRQGHbSpO1WeUhFdUtjw
 lVl/kcg3
 yvNYYAZXwOh58tN3GrgkQlugVbBkfv4mhWkGkUQpyKfScEr/smIz4ZpHPD8tzQOTN6pLZynvl08Gpmn4ZKlyn1Oqhbbf5Tpf1XVIpUkowhErRShg5LUBRAwvB70ovQDanVG9l+dkby3UO8S78hUk6UYL19S0wvWwUJkAEmJAK+J2OLiCFoW/7ZVQZ9NC9NSJ5g3sd4EX1LiXy/c46Sg/rAAVYAs5wGrLXSXOjpo+9sGIBIopJINYk+hlAio6OOGuOksVYBwXqWOxnOIhLUcBFniH+FuYyGZ+6iWs2xqrl40iRxfMNqDH8k2Jl4hbHXyHwUoY8beiQSyVl0RGr89oGYxrZsygpcd4gmvrcYHgTIaRtaGOrtUrj2q5Jmkehjp6x8YFAn6wRh//2VSGLRzwUbTZdew8ZeuP16D5TquWIb1PyTCDAvrm5Ve5LVOuPqXIUaOaN6f4nF+BxTL5HqrOAjw4ny5Ioo6esVq+BtzfMnqx9cGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We added that "select MEMORY_ISOLATION" in commit ee6f509c3274 ("mm:
factor out memory isolate functions").
However, in commit add05cecef80 ("mm: soft-offline: don't free target
page in successful page migration") we remove the need for it,
where we removed the calls to set_migratetype_isolate() etc.

What CONFIG_MEMORY_FAILURE soft-offline support wants is migrate_pages()
support. But that comes with CONFIG_MIGRATION.
And isolate_folio_to_list() has nothing to do with CONFIG_MEMORY_ISOLATION.

Therefore, we can remove "select MEMORY_ISOLATION" of MEMORY_FAILURE.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
---
 mm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 034a1662d8c1..0e26f4fc8717 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -742,21 +742,20 @@ config DEFAULT_MMAP_MIN_ADDR
 	  This value can be changed after boot using the
 	  /proc/sys/vm/mmap_min_addr tunable.
 
 config ARCH_SUPPORTS_MEMORY_FAILURE
 	bool
 
 config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
-	select MEMORY_ISOLATION
 	select RAS
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
 	  even when some of its memory has uncorrected errors. This requires
 	  special hardware support and typically ECC memory.
 
 config HWPOISON_INJECT
 	tristate "HWPoison pages injector"
 	depends on MEMORY_FAILURE && DEBUG_KERNEL && PROC_FS
-- 
2.48.1


