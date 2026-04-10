Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14333E99052
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 08:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551666B008A; Fri, 10 Apr 2026 04:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502266B008C; Fri, 10 Apr 2026 04:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418066B0092; Fri, 10 Apr 2026 04:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 310346B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:09:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A32A61B7686
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:09:37 +0000 (UTC)
X-FDA: 84641921994.04.0DB00EF
Received: from outbound.baidu.com (jpmx.baidu.com [119.63.196.201])
	by imf01.hostedemail.com (Postfix) with SMTP id 9D98E40003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:09:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=M9lzGUV2;
	spf=pass (imf01.hostedemail.com: domain of "prvs=md1554E09E79=lirongqing@baidu.com" designates 119.63.196.201 as permitted sender) smtp.mailfrom="prvs=md1554E09E79=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775808576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XVCGD+rFsf43XDlKVku2Aq26Sh7eivzVMrrFZLWXJH8=;
	b=gl0csqcBT2U12HCB+Gg9i1qb0ES88/7z6xigDRv/BBDvGbCokLiyX4K48IuGCSEUPN+/cA
	US4iIGydStN2UUwzRhSnWvuyluFCrVqo7FeIMH/0Edrz7z0QHvUFYociEa4zITU5IRqPP5
	v1GHBmbllumL7s0yGhe24kKqm/Mprp0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=M9lzGUV2;
	spf=pass (imf01.hostedemail.com: domain of "prvs=md1554E09E79=lirongqing@baidu.com" designates 119.63.196.201 as permitted sender) smtp.mailfrom="prvs=md1554E09E79=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775808576; a=rsa-sha256;
	cv=none;
	b=OqyK/9LZgT+A/mdv5Beq4aBDlME2r+o979wY7H/xvn+jz6eBsC7owJU27f3JJXsHV2zuVK
	pXqOkFhmMIqE9XamhN9wjZE5nv5Ajaewr9VOGNIhuSQ9xT3HfbDfI5qzLOx7wssu663LY2
	gpDdQeWuOXyFVOYx+FZ6UpvettsLSxc=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] fs/coredump: reduce redundant log noise in validate_coredump_safety
Date: Fri, 10 Apr 2026 04:09:18 -0400
Message-ID: <20260410080918.2319-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: bjhj-exc3.internal.baidu.com (172.31.3.13) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1775808568;
	bh=XVCGD+rFsf43XDlKVku2Aq26Sh7eivzVMrrFZLWXJH8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=M9lzGUV2YZ1Z8n2QSAqzb7KIxNdbNAMN5bPWJt+KbmoBKYFuaHYR2Ny33bLkG4HNk
	 Zl+YGiw2F5YW0+gvTv5NVz21oz92p9viw5+b1M+9lNl1pRo8poAFQKTT1Slo0M8nrf
	 76cUUexzG8Y9TSJVJS07x1HhTPF3T4yAeQxOx8v/tFJ7xdzTj1ECmznW9HfItChblg
	 mqjFI0SS5LBghD5PBtNyRjSHQTKuJa2Gs9v+EWx8Lar+klbS9YjNSqOGgcYJDaxY7q
	 L+e1oEHidp8Et9YJuQ+4kcx4xR6gP+V2Y64o+pdRuz8DyawjQ5uYc85A1TzdpAF5Ap
	 EtQEpsEpsixlQ==
X-Rspam-User: 
X-Stat-Signature: yjdz74dszqheonwrfepzm7neroe1u5iq
X-Rspamd-Queue-Id: 9D98E40003
X-Rspamd-Server: rspam09
X-HE-Tag: 1775808572-578116
X-HE-Meta: U2FsdGVkX18aJlmoGFp+57UGNiDJJIPd7dQcwRT+WwVHhthrNzgfHL4bUMM8+S1A//uLT93Cf6SQW04IOduoxV5Mz0el3viYscMCscoytY0MD/jToZzsNClFydIxu+DvSepFAPvoljqkSx9uRPjtFzWAlnoB4OI9lqFbTD4dI+VFxHYWwI9JdyFpeWce+JGkROdgL1CLPzlxJaVtecy/oFOqvzX7dOTgP1tzaeFWcxEO3OZ4ae/byIcHI7xatLBvnT8xUhE41BT/b1bu0DSVwt8Hh1T+XkvFjFFduS0lZD7wMVbhd8vwWPJmV/C9MdgyJersK5s84mmkb198fL9ePp3z90THSA5K90vdJ5qVxT7GS+rmTRiyErl9xpYYKfo//QeMJI+PkhWhw10hixjUGvkMsrh3n/M6w3sIUhKvuWGYaUt6kRb/dC6nBwq3QfxwPlaOtSM/LLABALuw3HqXVIxuC+HXVKYHVyyByx+vyB+a+QjPygrue6ATi5hosxHERWe1KheowgzZedOH5f6+A/uQrQ9scFTXnPUjAcuC/7r4g6wwkVdo9nC7X8BqCzclDGfjNDKwwMS+VcfPNKve/F6yTbpFYrVqecpDXCnbWbc3kpOw77VZlrsq2K0jKXyTs8ijWitLcKGNDmKSyF0DW+ZuZbEmB0dS259J3ZxUZDTkSTgDbzymaii+mItPnQ3q8BC36vT1zzChXLh6YJjLxTOHpsG0xlAXRrsHVuJv/e3TuY2NCPmB45AmMH+UPl0hns0SPbC2dXMhy/4Q3+vGOe6aSv97fmrp77xLKP0V6DSMdKyt3Oe7pO60eBzwBm1ZnHrsUeIQb16Ie3Io4CmwX2IrG4bcTTx9jIqv+lIj+CVRq5rUMTlGQd6e3xiHIABy0Jkc63bTRAm+Nr67UoUeDPrGXpjNIvro+CRkt9bvjFvmRens3oK6bT1dS4EYzXZUtjLJ081c22/5n/H3f6z
 VNvetZ8i
 wQbe0xffWGYTwiKpWSkOrZ11Cegeu/FeCPGBA0yJPiV/aVkW6lmPmQ71UEf1XMW7A15R5JT4gNZUoPwLc/S5F6c2OzZ46lRv4bLpUKbRKZ9IR2M4RHvQiBZ32FrxmgYb7xJTq9BHeWoadVE8FenDbfLIbzaKmkSQ70xcpmH8c/bKgv9H3DTV2SvEvNgLh6uXDpn2zZLRZ6UOi19Tj6RsBhngwuwQTSZzq4NSNgobIJoIrLs9tsC3Sh8weaXUDIAEhHv1F+uyusTTklGl8m9GC7jyZn/sf76jR1VEZIYpU9C+n072rjX+qbKnI3zKpcLZ3zsM0f2OTtk/89hkUARC2kQvWsdvt/1J6iAQmzusbmbcse8qElC8aWHmUYucaTed4HlfE4BPKqEZMp9LTKTabJ2NBLC3YUfLPu2Te51f3AN8zr7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

Currently, writing to 'core_pattern' or 'suid_dumpable' sysctl nodes
always triggers validate_coredump_safety(), even if the values have
not changed. This results in redundant warning messages in dmesg:

"Unsafe core_pattern used with fs.suid_dumpable=2..."

This patch optimizes the procfs handlers to only invoke the safety
validation when an actual change in the configuration is detected:

1. In proc_dostring_coredump(), compare the new core_pattern string
   with the existing one using strncmp().
2. In proc_dointvec_minmax_coredump(), check if the new suid_dumpable
   value differs from the previous one.

This keeps the kernel log clean from repetitive warnings when
re-applying the same sysctl settings.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 fs/coredump.c | 3 ++-
 fs/exec.c     | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 29df8aa..9b357d2 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1483,7 +1483,8 @@ static int proc_dostring_coredump(const struct ctl_table *table, int write,
 		return -EINVAL;
 	}
 
-	validate_coredump_safety();
+	if (strncmp(old_core_pattern, core_pattern, CORENAME_MAX_SIZE))
+		validate_coredump_safety();
 	return error;
 }
 
diff --git a/fs/exec.c b/fs/exec.c
index 9ea3a77..32b46e4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1975,9 +1975,11 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
 static int proc_dointvec_minmax_coredump(const struct ctl_table *table, int write,
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
-	int error = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	int error, old = READ_ONCE(suid_dumpable);
 
-	if (!error && write)
+	error = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (!error && write && (old != READ_ONCE(suid_dumpable)))
 		validate_coredump_safety();
 	return error;
 }
-- 
2.9.4


