Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B765F531C4
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09E16B0096; Mon, 13 Apr 2026 14:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A936B009B; Mon, 13 Apr 2026 14:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59626B009D; Mon, 13 Apr 2026 14:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9FC6B0096
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:51:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E5F1567C6
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:33 +0000 (UTC)
X-FDA: 84654426066.23.C960859
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 94EF240003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:51:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ap6a61D0;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8pD98uNJoq0iIfAL/ef2oCcGmXF7EEZvJYI/x8l5WNI=;
	b=HU16lxMLf4fLTn+3ykYixvoOVXF+N7Jrgk+VL7JMS/PfsBGSvye4xhewcFMWnAYgIi+sbI
	ZixwGlkU7NoVY1DSmnVLhQsI7SmX4vVuMEZ0iyBzUmoqnmAsBW8AHagn7siXl/S1jmVbWL
	p8z3sd2Qokrqd5+RtIJzJBJkPKhEsVE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ap6a61D0;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106291; a=rsa-sha256;
	cv=none;
	b=hzreErX8LU5KfS9BHXDFT9EMyOs6+Tt8AUkidxrGJEZUErMXGlWCnWoJE1KxJ31jxHhi0I
	dKrvm/CqbXDuruuYhnZRut73aZAcnYbfZFuSPUl/kkDjHspNCGW6MTEDv+8AtA3jE6RmNv
	hGijTO1UuMIGqtDlxtwiwiz8FPsxJDk=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8d424af6282so516156385a.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776106290; x=1776711090; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8pD98uNJoq0iIfAL/ef2oCcGmXF7EEZvJYI/x8l5WNI=;
        b=ap6a61D0pd0TXh+Dd7dP0Dd4pc4Z1mq8drsFO+232gR29+I6JvDB9I+wBXrEDwNqbz
         fC4pefwNo7JcEnbzCzN+QpjuUAlxtypkVgYQ4UcK/x4Ap80ooGK5QwNQxwVisPl3dCaZ
         yVfeTocLylN+Uu/WNS83SZMIuVvUYfOFqr5tTC0GG/llHb+VAgZsFsowHesvFTdWRWyM
         4E0E2U+v2+1QdNctn9ploOznTQDuyv3u5db/5RHAgdvSQuw9pZ28T5q8kRb5e03Korbm
         Swl29o6/hX6RJ1VdrDeW04zjtr4FaHhxXAITCIHclkehI6EM0IHusLMOa4mBR77jPjfr
         jG6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106290; x=1776711090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8pD98uNJoq0iIfAL/ef2oCcGmXF7EEZvJYI/x8l5WNI=;
        b=bm0l4AABtZ/0KyT6LafeIRKUwBE7R0CrakPxEJ8my24TNKmK/8lxz4P7GwhrJjUcXW
         7jzD40tRrDSdSI1bwXlXowZwxyCQWsJlqoUwL/QdS/KVBtfbOs55sZU1A6IXX9QI2tWm
         8oobgL1eqwrG/bUPO0EThd/F7qEA4qLOvv41jxAkjhK+fLWdqkEqM5dYkuuSHbWdJ26O
         SqwGvXE7xM/rBWSvZqtiT1orZfYcE700XUJywF+IgXQHvP4i6dMxRd0fWl3h88GZuTP9
         saF0Ew7H9rSwEnztNdKQMVATybTfru9oU3bkvYgayNTZ0v/ISc6BU28+Iv7fKXYbzUgH
         UrXg==
X-Forwarded-Encrypted: i=1; AFNElJ/GleI0I8pzVE3mbi9c5jCd5k69T1n0+blR5HmgXHJOrK2JNKvzoL9LSM/zWHM3PeAnpa5UVBcOSA==@kvack.org
X-Gm-Message-State: AOJu0Yz87JHdAJC3gL2FZ2Exk80hfd1F7PjM2J4V1pou+8YXH5MQ0ZCJ
	nQQ7rY+NQ345kNr3mDv1J+70Eo0Q0cwk4GjJIgQGudTRMnfSNzzOyOm35k0NdUCgJzA=
X-Gm-Gg: AeBDieuxRpAbY/pMk9LNB7WWqAiOWQe28JCP5dE5AJd1aQKvkiNihPD0WPPQnzOYwmQ
	yFwDujuOkAihoZjp1jDC/fMy2nJ6h3jgPjD9n6aQrA84H/38AlA/D1e0U6IiSGmF2j6MpKx2qlO
	kcAt7yIVOcam2VmXnJScIAvHCBExYHhADe4Yd0ZotrsfY3uzU+P+snHvf3k9X/kkR4CD2l+kfmr
	bsubW2jr7GSgbY7d+oByxVqWMSvwTeMe7E337knp3QCWeJIVvXcuPn8xo4uYYmGa+qOdSbycXHo
	MNcmcdVqxo/ut1MG0RVOqSdRTRIIUSmhb65UZB8gRiO4AugyuOqFshKQW2vydzW/SIbUqr0H1rH
	GYZMsIcPL0aOQJ6HrBZwvGTZ6yppw5VzcxEN/dUdlSrVeBC9CMmwg84KOZ5K1bXe60lS1OPlMKf
	jktKiN0Q0P9dFfN8YvLkNUkZeMBS9o1TYV46MbT0XwkpsfvZ2cBkQoujecOgqJPqBxKg==
X-Received: by 2002:a05:620a:2585:b0:8dd:7919:153d with SMTP id af79cd13be357-8ddcd1195c1mr2060705885a.7.1776106290475;
        Mon, 13 Apr 2026 11:51:30 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb6372790sm943206285a.12.2026.04.13.11.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:51:29 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 01/11] liveupdate: Safely print untrusted strings
Date: Mon, 13 Apr 2026 18:51:17 +0000
Message-ID: <20260413185127.128180-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413185127.128180-1-pasha.tatashin@soleen.com>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 94EF240003
X-Stat-Signature: yt859h7m5kysirwzi8cikdti945s6mau
X-Rspam-User: 
X-HE-Tag: 1776106291-322398
X-HE-Meta: U2FsdGVkX19x4t9Sd9rq4ETgKJXvY2TenWQ8lireKqGT9cx85tOIYw8QqAklsFKO6WfwBDtnUIrWpgxylbMK3HNyEzpGeRItjPa3e1mczzSulMqARFdMsb2Lzpwr7XuqCrOuput1Gk8AcFeTIj6KJDyR8SVeBnBfJH5DaRfBYJXgyro7Xb9XXJxp5AMu/cAMfowHypue5Sxmhag33bNQvaAAEApHD8SyPQ7ratO7ay1et6twGZ/1XFhCGiZrLpsVnjx2JQd/6X7YRQQ+Utf8sCWJ+9VviK5kPWM9aQD+dfFWve5Ip9rB91VzOGVYht4KxH1zi957PEB05PDG95+dFJ2Ep8q2S+PNIlkQcysuF2xH9Nu3VJ9LgQsfRgvnoCAboB+cvBSxt+vtKEcc6J9OCAcdKcaNW1QtlmRETtC3D86tC3K4RoBuaeZc/vTg/ROl99ZcVhlH/Q2qdtzAryxTJRMA1AhR7dN5G+3LCLGexYz156tTEKZWsYaZehZHwzPAQW/8kHjcBFWZXTA44vLPOuQtXpkG7U+8FePdPNCcdHVXilXh4TcEM64xNPI1VzZ6HWmiPUZhaVTJLqJY5k40QUNDKJAue5Y98Vto+AV4Jlv3FOgvOMWUeds+ynWnCZoOAfqXk5u8QqAVrewHMizKqunrJvwqtmtsOwLiRPvrniUZgcGBeaJGb8nPVnYfRn9mX68cd9ctZmmm99PxcTLStwT0YRreiVaugg3lGxMwB7MhaLkkLkdnWW24JHmc4P1235DZqbu1e7dUwza1ikSJZo5youytdH9te1OcNV9W5A+/+MQq7Qa4lJ1DpPXMrQII0PPABdkD4CpuJPhYh/GpqKalk0+nLIazR5WvAI86nYCxwOtW6t5LNbVcNA1xGUrez0in/1Qe45jVXVtmfB2nAYAMscWpTj9QzNMDn76oeo3iKqawJdAk5kMgfbL1Fnor67C8GUdUg2ca4OwpoCO
 yU0yRWSy
 IPb0fShEWafl/X69puyYVXGjVhuqEULmV1WLvOzwYgS0jbAxocl6dGbykS0wo4svtMes0qLBiAYX1esvNXPXCPSs72QiJf+Zrpq5uHi5kgpGhoAcX3g9AbU5jhgcoiDEzxRhfgWYhoiQ0ip2dd7B1Gam9erCcdi9OlHpdDIM5CD2zW6W3mIJ1hZc3BEGx3PF5l93UYbRchajeQQX6cKUAPxKFee6UjDqlbVBIbTSU4P7dvGa4jtGPeQdpaNCahzSKwRUI2Z8LXDelPyvsopZdV9xX53Imb0VVZsb4Ppy6+Yso5DjBeOYUQShnSHQNIoWjAcX1xRQk4/XXBNtH/KdSJxx2w68HbTmaaYWb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deserialized strings from KHO data (such as file handler compatible
strings and session names) are provided by the previous kernel and
might not be null-terminated if the data is corrupted.

When printing these strings in error messages, use the %.*s format
specifier with the maximum buffer size to prevent out-of-bounds reads
into adjacent kernel memory.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_file.c    | 3 ++-
 kernel/liveupdate/luo_session.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 09103cf81107..8fcf302c73b6 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -813,7 +813,8 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		}
 
 		if (!handler_found) {
-			pr_warn("No registered handler for compatible '%s'\n",
+			pr_warn("No registered handler for compatible '%.*s'\n",
+				(int)sizeof(file_ser[i].compatible),
 				file_ser[i].compatible);
 			return -ENOENT;
 		}
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 25ae704d7787..8c76dece679b 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -544,7 +544,8 @@ int luo_session_deserialize(void)
 
 		session = luo_session_alloc(sh->ser[i].name);
 		if (IS_ERR(session)) {
-			pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
+			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
+				(int)sizeof(sh->ser[i].name),
 				sh->ser[i].name, session);
 			return PTR_ERR(session);
 		}
-- 
2.43.0


