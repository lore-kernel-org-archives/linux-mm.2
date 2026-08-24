Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A12D6C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C506B00A2; Mon, 24 Aug 2026 12:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9E56B00A3; Mon, 24 Aug 2026 12:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D776B00A4; Mon, 24 Aug 2026 12:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5976B00A2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:06:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A8CD1C0A7F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:14 +0000 (UTC)
X-FDA: 85136639868.18.A1D5467
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7A48C20011
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dJsvLuXE;
	spf=pass (imf13.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787587572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHdnrOMTEMmVzp+pvECMhkQzT5sYapzKlQc+uABWu9k=;
	b=4y41UlZgFqMfC0odHWoo5cun8CmUZsSJgblgQp/2JKaESxWUH0yF76gcU+vOl+As4eOgOn
	Qw8JOB0aFY5QCVL3DU9Ern4F5fI4QQtu3zsl/jAFz282blv0b1qQ+NOhN7tu0AQDFoqoNs
	7lJN3DDf/oyf8QBCjXWEqnceJCAubgs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dJsvLuXE;
	spf=pass (imf13.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787587572;
	b=wMpddnIAenj851r8zf8VGVStaE1SKECc7cHLyUpDyAIWyudqnxjxyaEz71c/WoerbKZsGc
	Z7IDVxUqQEVt0HpO4e78T79JxsvnP0PNqiNZbPwZPrHdgf60/yPQO0hzX09QG3WKW6RLMk
	voNBus7XWH759RE+SllvYuQJMU/Ap0Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E38FB176C;
	Mon, 24 Aug 2026 09:06:07 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 885403F85F;
	Mon, 24 Aug 2026 09:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787587571; bh=Rwi4AzekxF8PcB6UHH8vOzSHeIKlfPuKVBoBNngyqjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJsvLuXExRZfSJVbv3K6HCiW3BR7TJXaVrPv1IYrS8GDrZipSySzPSoKX1sDg/TLi
	 rcgwUtzijkwFuJ82JRFRbQoUfk2VhTL8yreQOzRe8wWaiRJ4JRUZTANWfRepEescVY
	 U3NBHGGKRha8TpysreQuCpCiYPx/pdEPgbg4PJ+s=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)),
	linux-kernel@vger.kernel.org (open list),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 6/7] bpf: Skip setup for zero-length string kfunc operations
Date: Mon, 24 Aug 2026 17:04:52 +0100
Message-ID: <20260824160523.3907021-8-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260824160523.3907021-1-usama.anjum@arm.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s5f6ddgsxerjfnk4ntu1h78s177jibmc
X-Rspamd-Queue-Id: 7A48C20011
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787587572-132489
X-HE-Meta: U2FsdGVkX19dUt6TAJMxuU6qzAwYQJYRZxzV9VWkhlLWwMSaWmhe27ieBdXZmtiHwoGlGOA7y1BlVuKNLScKCT6j1nJtHMX0XVMIImPuYyuNIEzP4UVOhXv7OnQi+GNvN0yo5AgPatQvZuvediLRcjJSo6m3kPlAaVHivIdzBGhhRInPReVVllrM6VcEHA313OEFRL8seXxOaw9B/GRvwj1//dxY3gk9elemIN+2c+Hmpop6lLtpBF7E3PcpG/ieSwWAxyuiEbmBt2l1yyQjHdLv81rqiQczvNYtHOWlyUx2FeToDojefYpGI36iM5E1QzgzINMMQ1HYfYrzq3TXyhwk3BqKjhqczTqYnVOGk+4wvdKAOGY7zF/a0gd7kArLSRRWUKYxkrHWlIJdjKvKyXAtnXt6xcsGoFdg/qeHmv6exAU7vboVjNUU/TVzCw9hZ9wUuukQCh4C5UohZFVWaatYQPyPXj6pZEJVgGPppHEZLoD3yb58fzv94L/6DjXFuP3JG4MokGBk5Ot74CNfdymdjC8k7AnWScCnOQf0eeZbbvZOa0SUAuFIXJmPGkaRRmji9ItREQJ6ZPq2600+sErAV9kLRgk6qM9G53IsHCh1GcTlkWZ89qY/PEBEcjw9Z+dsijyn3dJmLaN5YjDJV2DOpTu4cP7spcILN8jK6N7udUq5zV7qYtrdBr75v6FeLpDhFG8oUBGRedvoFUxcxcNP4PLeAV0aYpLQm1FHxRfeMfz+SGNUguRO6aAMYD5d13KrEJU9lYY5DEVbQHe7rZGgqdHks1SFPgSaND+98IvJF1tr+PrwyNrV5jRaokBRKvL/RhIkGioXrwmVwbzDfqIp9zoD1iLc9gQX32kY9jNuC3dw0eKIpSQe92XOGGsgEEvIbjo2Pk061jK3vysHVUbyQ3FdA3BaO6Je4HrB8zeYzv/3gsS7matIuiajCKc5e7kSepKTfstw0hA5sZu
 zjo2yTUU
 JuJKM1pDhzfK3hCWFkPYwhNPZK10n1czPB9Ib3wEBzVOEr3z2aFUF+S7mOY+dPxoRZB/NoKvsyeupi+Xfkk5SV5wi0ddr8zITPwB1n0fsl1Bfi69zxG+/0kGv/AMZCGH9CD8VbbRvOsEBUtEEju59OF5BUNyxGT0JmVlr98WWNTsIF9zVWALGcPNPwU7lxKqo4jieKVx10NtPW6WALTFSxYZXmVwz3r284l0aGyf15vZbBTWdBBzoZ2YiJf4sDcfkgBMrEXrMwM5A/wWmCPbi6/IHbbjKqrwsi+/9TjeYoe/JO+nRN92WYnBvrJ/MljIr9gCzqm9LCPlM1ze/8wxKKPBfgaVU5ZG0AyOOnSLLQHVYNv0DOps7d9IzKOxapxkIGfSoLdK2Ll5EcpGs8/E0N/tOVElNOhdROoIj0tVRjwa9jmivOkyRa+k6Mg9ChDnqBikxzPGfRMStOTiBl2lwhXijcEPHwU/cGJqI+dpQ0Mt1/s1xUjWljHaQQZjftLujbg59lfyglnZXsJX4BzIWjh6iU4ax6lqdKGbzUQ7jtJl9rzSbUdmitjb7lQ3Xf1L9Pvmz6vo813Z08VhAEcQNJG5HQo3Y5X62Y/BbNyC8MEqDsoksL495wuWrj1ieWkFIJ470A5Z583O5/m2HwNX3Ls5GhDWWd5MJbhIcNWY0e/+PMp5n/URWLCmJTKOTv1n962MKifH89kK7CX2Jo9PLoMNtCwL7o/hYriqwvvKrXt7DtDqnjFBrxha7Wa5gjxno/F3MaMyyFOV1ph3ir9b+8Rc9qb+7V+EmU6uaug8lUSc9V3QdaLNcje+rIuoTJVJvagPRalDU+je1Pvk9ErLzlKy2FtiWJPcwddpZlmCtw0JjrxQZF3d4NXDsfBJ59Rl3/n132Nz9Ksbg49g/0A6hKXNVcDUPAD9DQ1ARNQB71VydOO7BaJw5esUYtZ967EkyVb13
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A zero limit is valid for several length-bounded BPF string operations.
Their loops perform no load in that case, but they still enter and leave a
page-fault-disabled region.

Return the existing empty result before changing page-fault state. Keep
address validation first so an invalid pointer continues to return
-ERANGE.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 kernel/bpf/helpers.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index b3cc5c8fc8756..3574a9a5721ec 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -3738,6 +3738,8 @@ static int __bpf_strncasecmp(const char *s1, const char *s2, bool ignore_case, s
 	    !copy_from_kernel_nofault_allowed(s2, 1)) {
 		return -ERANGE;
 	}
+	if (!len)
+		return 0;
 
 	guard(pagefault)();
 	for (i = 0; i < len && i < XATTR_SIZE_MAX; i++) {
@@ -3837,6 +3839,8 @@ __bpf_kfunc int bpf_strnchr(const char *s__ign, size_t count, char c)
 
 	if (!copy_from_kernel_nofault_allowed(s__ign, 1))
 		return -ERANGE;
+	if (!count)
+		return -ENOENT;
 
 	guard(pagefault)();
 	for (i = 0; i < count && i < XATTR_SIZE_MAX; i++) {
@@ -3956,6 +3960,8 @@ __bpf_kfunc int bpf_strnlen(const char *s__ign, size_t count)
 
 	if (!copy_from_kernel_nofault_allowed(s__ign, 1))
 		return -ERANGE;
+	if (!count)
+		return 0;
 
 	guard(pagefault)();
 	for (i = 0; i < count && i < XATTR_SIZE_MAX; i++) {
-- 
2.47.3


