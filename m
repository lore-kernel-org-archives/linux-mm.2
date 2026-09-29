Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A60CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5ED6B0088; Tue, 29 Sep 2026 09:02:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80806B008A; Tue, 29 Sep 2026 09:02:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47756B008C; Tue, 29 Sep 2026 09:02:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78C186B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:02:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5C911A04B8
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:02:09 +0000 (UTC)
X-FDA: 85266812778.20.3F8AC8C
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf27.hostedemail.com (Postfix) with ESMTP id B92204000E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:02:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=D0NnwpBx;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790686928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IH3o9e+vD8Px+iIdA7cBn3J/yVBD/sCiedYGk0wkQTE=;
	b=KAwMuTYKt+zDHZeXQlwVPhlL7P9TzzK/M/5jDMP0lTi7WaYzrkRwkAN0B1tdWXBaN7tLhM
	bhpJbRSw8axAavKTDXjhFhNPH0blmHxpSARMYlNVgVvb+8bTimgAALg9+yv5HXemEfcxBL
	aC9nMMQl37B1SbqZfpIL5ZtU5lvzw1Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=D0NnwpBx;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790686928;
	b=K5nN99dSV2mpSsknGcATkUCo9CZ9qJ5d59jGXDNmoku5DbUNAfGIExEVAEOEol0X+DFnlB
	x5U/S5VSSKEUhbU3l3aKoeQRGKh4hijJrYKab8xKDhSecvV0gevX+/8C0EhvTu4mkWZHVB
	DJnA4uzegCGXY+AtgerkV24iYheDi40=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IH3o9e+vD8Px+iIdA7cBn3J/yVBD/sCiedYGk0wkQTE=;
	b=D0NnwpBx5zTGe8VHlNO8c/QFIbn902yh15sAVzZTxzb8XlhLuTho8hCCofUfsw3B7KpRLY6um
	svb5EszooI6FJX2O/wnUXwctWb/Gyrfk8+n+Yuwlf4djI9aJfbi4ttPlUx3FruRnm5MikT/WXH6
	srtRmPfCc9xqSfu44COtnO4=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hvJ0v0kYqz1K96s;
	Tue, 29 Sep 2026 20:49:51 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 6862340561;
	Tue, 29 Sep 2026 21:02:00 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 29 Sep
 2026 21:01:59 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <serge@hallyn.com>, <kees@kernel.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <mingo@redhat.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <kprateek.nayak@amd.com>,
	<paul@paul-moore.com>, <jmorris@namei.org>, <shuah@kernel.org>,
	<oleg@redhat.com>, <brauner@kernel.org>, <alexjlzheng@tencent.com>,
	<jannh@google.com>, <jaime.saguillo@gmail.com>, <elver@google.com>,
	<blbllhy@gmail.com>, <bvanassche@acm.org>, <pjw@kernel.org>,
	<broonie@kernel.org>, <debug@rivosinc.com>, <tglx@kernel.org>,
	<aleksey.oladko@virtuozzo.com>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, <morgan@kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [RFC PATCH v2 1/3] capability: Move mk_kernel_cap() to header
Date: Tue, 29 Sep 2026 21:01:58 +0800
Message-ID: <20260929130200.1638343-2-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260929130200.1638343-1-ruanjinjie@huawei.com>
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Stat-Signature: h1geg9yuzi1oz4rruy9aqzq47fhb98jr
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B92204000E
X-HE-Tag: 1790686926-255102
X-HE-Meta: U2FsdGVkX1+Dr1lPLTy2zcSanDKeDtFiHINusVheHmoSGwKoQBhXYSJvjPN1+/OqeEaxjtA6r7uDCmFy/1YINva9fqZQPUM2P4/7kbVWQlBfiZsPJLRfRUqqWio04aFBOfNJ2Y5GUnZLPe/DB+bsQUbrjkOJ1MeRkUMfBTUJoCF/z+n9NtXKpxtJFLCZpkR2DPoTn5Sl0Tp/b+q3r14OIn2ILHkCpbnm1GXcprvam/vab9EC9h2QBmSjq/sY53PaKkWWxUGAWbCiM7jPr6lsQag/34HvC8clgk7fTNFotpfVA0+l/nRHSanT/wWOcovRrCMIpkNeikZ11yoRJhIyH9ufcsDlxi1wOwPNZYE1AwcUkZuQi1CqYw6aptgf9AdJ04xQGH21hL2ht5gqT3n15xjWGQoSW5hnc8go49zyNPoxJFgfY68IY+Y65rYr4MrQUh89wJIer2cLZcpwYGnXk+daWzI0MJEZe6uAUWSfjqWOnFNrfSzHczvXUfloAdF08wq0gpGXP6aWOVdTCiRKazC7y3ZUVSZB/Nxjt3zFYhii9lMohz3/L/kreXdnrybijvZC5KaaKGqcy72TQk8Q9vsaHn+cJv5jM5paqj7OSIDmJz7HkfoouoGytofjHNhstG92ClBaTeL2/oCReT6gNrmKu6DOj54soFVaSBCCc0agGt4Q8VXJkKRvrFHUb+Rv0yNQUv2lFAqZcqH1yLQPe6eS/fPHNyJT39e61rUsl0KeaW29zTVkK33KJwtMWT6nO0I9y66NoMGr9HlAE0etHPZu3ANnhTDgGvAnl3goRfoUJw4cDqDJHSbXO9L9+xjOd6uNl2An+yzq7Xw33HPqtwLKUnygJmRLcneN8wvFfo6L95Hb+qx/H2YbUQhT8dfMpHZlfSaEENbBihJgdFAs1f8CGpV/yCxgomqTrMOvPpLuSnv9DFjaBpR2afCHDGbJDogdVswXrLPUQj/9UyE
 W+PshtYh
 cGldhFwwXudFe9lVE0A+lz12XLQB9ctHgn4YKVPQvb8/sqE+jvX94I4EoUV8oEgCaACyeXUNQvL2MEOLNXKYkiiYDf3vc5hVeqmQC77qfGdUF4yhc5GUR2TYQGcFJ9B6yhw8xO3G2hFscdDwD4NpPXVsGaNPJOAKT7Vmqi7QSP2ff/v5Q4ZxpA7op0xd3oewfenrKJqMkxXUQcvYzBvEggl95r4o4sv88IR8O8N1cJh9MtkmRTFK6AFuYG+XF5tixLPluy9jJW7pazysTOBr2VMH/lB85TI2JezonzyO9T+yt6YwWSsUgEMLZr7oZUHlq+HLV3Yf6S1yBmfUmFp6KPqPZyk2BUPjtge1GWzPuE3yrB9EF3os4rkjJuRIqNfZAWd8acAmNJPa7z++CL0FVeawQ/brsoLpgwCbE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move mk_kernel_cap() from capability.c to the capability header file
so that it can be reused by other security modules.

No functional change.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 include/linux/capability.h | 5 +++++
 kernel/capability.c        | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index f8532d92fcad..7921a0b3b04a 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -114,6 +114,11 @@ static inline bool cap_issubset(const kernel_cap_t a, const kernel_cap_t set)
 	return !(a.val & ~set.val);
 }
 
+static inline kernel_cap_t mk_kernel_cap(u32 low, u32 high)
+{
+	return (kernel_cap_t) { (low | ((u64)high << 32)) & CAP_VALID_MASK };
+}
+
 /* Used to decide between falling back on the old suser() or fsuser(). */
 
 static inline kernel_cap_t cap_drop_fs_set(const kernel_cap_t a)
diff --git a/kernel/capability.c b/kernel/capability.c
index 90e6ab62f6db..0b8ec26ead0e 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -190,11 +190,6 @@ SYSCALL_DEFINE2(capget, cap_user_header_t, header, cap_user_data_t, dataptr)
 	return 0;
 }
 
-static kernel_cap_t mk_kernel_cap(u32 low, u32 high)
-{
-	return (kernel_cap_t) { (low | ((u64)high << 32)) & CAP_VALID_MASK };
-}
-
 /**
  * sys_capset - set capabilities for a process or (*) a group of processes
  * @header: pointer to struct that contains capability version and
-- 
2.34.1


