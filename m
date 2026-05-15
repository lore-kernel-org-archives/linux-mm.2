Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE6DCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 06:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA826B009D; Fri, 15 May 2026 02:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1566B009F; Fri, 15 May 2026 02:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EE8A6B00A0; Fri, 15 May 2026 02:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED886B009D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:53:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDA03140897
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:53:37 +0000 (UTC)
X-FDA: 84768738474.26.1132D99
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2C7324000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:53:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="m3Lz3/86";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18810879172@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778828016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvjCRU2y4ISCFaOOdDxaT2ueAkSQA4MwBbEVRj3OcWk=;
	b=vMx2k8MZmjA7oNhymtIWg0k8stZ969MB0uftqdcyw60+XjdvxIoFrqlwkbKFeL2BKvzSs2
	mxR39bYaaD/XtZd0fYCj/agFRCX1cU4WqsYdx2iQkioyT2A6hPNdU0W3F27rUHg84/1Dmt
	HzjpzyMRrFLkKD95MrTBZG/I0TLD95E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778828016; a=rsa-sha256;
	cv=none;
	b=xwx+5dlrqtzuKqDEFwgr51FpyFb/J3rAKSmG69n8n1SiZ6lCR9iWoYQkbDrsL67xJGPkP2
	ka3cYY7Y4ofPUPLxiCD5d3Uspau3i6DHkDW7xuD0NIpjudhdP+u7Uuc6iiPU6a/JuvXIbL
	i6uF+SV9M2ov1NsXBrxzwZSZ3CG2eEc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="m3Lz3/86";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18810879172@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=jv
	jCRU2y4ISCFaOOdDxaT2ueAkSQA4MwBbEVRj3OcWk=; b=m3Lz3/86kfBF8SUenE
	3kB0QgmbbQPDv06ytjIP6SUWbajgXiZw4JK7321OkOKQRG3lxSAroluqm8kJeVOc
	YSiCX8HDVuLvysFbv9mom00ugFRsdYdwT9waQlEoAVZ3Uo1Ef3bqm9ilPjZgPiC6
	3J/OQwxzePsMqdhVXcAmHQyS0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wBXDpTnwgZqtc7KBQ--.2204S3;
	Fri, 15 May 2026 14:53:30 +0800 (CST)
From: wangxuewen <18810879172@163.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <18810879172@163.com>,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: [PATCH v1 1/3] tools/mm/slabinfo: Fix trace disable logic inversion
Date: Fri, 15 May 2026 14:53:23 +0800
Message-Id: <20260515065325.4009527-2-18810879172@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260515065325.4009527-1-18810879172@163.com>
References: <20260515065325.4009527-1-18810879172@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXDpTnwgZqtc7KBQ--.2204S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFy5tFW7XF4fAr15Cr4rKrg_yoW3XFb_GF
	yUtw129r95CrykKw1fGw4YqFsYgFsa9F48JF47GrW3tryUJwn8CF4v9wnFyFy5urZ0qF13
	Wwsavry5Gr43ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRHHq7UUUUUU==
X-Originating-IP: [39.156.73.13]
X-CM-SenderInfo: rprymiyqyxmiixs6il2tof0z/xtbC7woH-GoGwuptZQAA3S
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2C7324000D
X-Stat-Signature: t16oabt4m53kguat687ebchjn9811rsb
X-Rspam-User: 
X-HE-Tag: 1778828014-737394
X-HE-Meta: U2FsdGVkX185d9dM/2XWcCvkcHiN7UcKCC2BAV+aSUIICdCW8FU/j0F86LgtqVgwZQ/EMjMeH5dqgHtlbWGk+GD8sE1Z/+Sn/RiAhj3pfHHJj6R/ZGSOr9y4lva3jupuz/Izz5F8jnVqA4D+XtIeDaw4lYXgARs9LB7SQB+1Eo13S+aRxuTGGRC6GGbyMn5i5TqjqG68p4cz1KiNVXtlsQ55aiaBh6le93rDxBNoiRHvDyZ6w7ZX3lAd354lrsWt4+YIYAWA099aoNy5m/BfIXJlmprpLZNDG0b8sAUd4I7Emes5iZmNBM3ZIKeAvn3lTsb8WJvDNHg5Zx3sDAFMcWlFxWPwVmTg9rBJFgAbt+s9ws/v2JwyUeSvREaX66MLmKJ+xt3czf0fwbQN4eli5fWSCf0MkZkUYuN1T5unQj/sbsvJ/qfR52MNyp5lca49vbRmJxNqTzssh4n0A4ZTIBd5H6q2msfMkR38Q0V0Hnwvbxr7QcZ8x9MVZa/cU0H1xITZOoA4zQwlIc7/+8LsW+xN5eMtX1GSukGQWPcgx9hoGz4wlrA+g0kXbLX1PUwhjdTS75trAwyzbICeZTwbjHSiVEIMkbV3Ew2Zm3KhdVQB7Nep18LQSNPbUdr16cKwEbRuHxf1p0WC3g98TYovxH0IMArenTN279KseHNzlT34ZC4ybG2Uy4lvTLQb2ETPQYfgD8CFvS+MEMp+RK/xQ3rDkU1wOcgcjNktS7IaSMouEWz8vI/Y/R5CL48wQzEuam5EqHuIzFwNJZSmCOCsZVV4ZR0TPRU/AKbLXafIx99D36jBJM7TjnSawZ/vL6TWuoEq/iopM+XhijqYAiF0/6XODZ4tupKvSioaoiuqVME8kLb7a/uCUybIGSEeXU8xOart58LENh26sWCmMF573jabwyiwkUalCiz1HaGQ4pTgHmJj7irzC9H5PP4oqajk152jDm2QVauw0jIkl3X
 0se3cBU1
 e8UtFd9oVSVPqEIUMeV3kWDxb0p3NzXUBiFt3ae5XWKbqcAorDLpdxYorrxYtLoLkdkzT7Dp+RDNDrdwHQLKaxsAEdYinOC2ILKGQmsFnrjSO8mc4SP5+l+puYAjnni3koiwIEM2EPQM0r4OwcQfqa3iB7lPpK6gAfrZdbLFX8us6/6zBS/qwppi7s88UIdo1bqmLvG3gh6MlXjc7xzC0eLMJv8yxKKHfPy3Fuc625m7TpjhdO9gXKZO8cjC8RJ/wr7DnykY8buPnwTkUDML7D+gm//fw0hApVJXkWDHjMOFJz5ET9ksHMQaA0TJKtIXD3rB2CWxaX6HU95EVNEdllKHHrZnoBMGMn9ICRoHV3mmKeEOG39fTsO40S7PvxNCtfSikHomQpfuEVpXansqyF00rdTnisso6A94scWnfyU1EAr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The disable trace path in slab_debug() had a logic error where it would
set trace=1 instead of trace=0. This made trace functionality permanently
enabled once turned on for any slab cache.

Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
---
 tools/mm/slabinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 54c7265ab52d..39f7eae7eecd 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -798,7 +798,7 @@ static void slab_debug(struct slabinfo *s)
 			fprintf(stderr, "%s can only enable trace for one slab at a time\n", s->name);
 	}
 	if (!tracing && s->trace)
-		set_obj(s, "trace", 1);
+		set_obj(s, "trace", 0);
 }
 
 static void totals(void)
-- 
2.25.1


