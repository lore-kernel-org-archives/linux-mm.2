Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA4A60A6C24
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XrZQnn4C
Received: by kanga.kvack.org (Postfix)
	id 851E66B05D9; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803766B05DA; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718C16B05DB; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51B0A6B05D9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E17971C1C65
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:08 +0000 (UTC)
X-FDA: 85390509456.04.01B8CFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 37C1018000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XrZQnn4C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6b6oFi/epwMKMYOCvMcLX5SixjsFrg88HIyGcM89GbU=;
	b=o8MJZGA3g9yGiJCV8Lv9zF+CFma/bSf4jYCodGpdx6qI5NA3VyNi9zzVWO2yCzIypndOQu
	XDKnNIJmzU6+gyDQ3trsuL21Q3NSDsyb0NvM8IuUPKh9jnCED+2DASkfKQY8B5ANBy8lSq
	52nkU2ekTINNPlmm6Khb3JQOW8eT898=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XrZQnn4C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632087;
	b=i/4nnZuyiLRXZjKpax6XepxfPnThBS4Ajp+tb+XeYuXjCsxsxpayHIOoDr0L2vYzANPDP6
	4t3eyABuRcjr38sJ2LpDeUGO8Zbko+Nd0lU3sFRqkpMi60loVaQ36crl0JLkfRctLYkG+Y
	B9tarTZKCUzMxuBfr4WFbswsdE3idCE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 882CC413AD;
	Mon,  2 Nov 2026 15:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A241F00A2A;
	Mon,  2 Nov 2026 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632086;
	bh=6b6oFi/epwMKMYOCvMcLX5SixjsFrg88HIyGcM89GbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrZQnn4CsywSn7qcJI5WSFd6QsTFCkiSXKgVSrtcHW7w3BEPDx2Ei2g0dIeCyp/ho
	 IELSsBOsA8xgkDWQFCYeCfw/LMll3OC63RXdWKfROfoZiFSISwpziClYJ6Aw3p/2+S
	 WbH8KnZWq21CEEu9lwvPaL3X1rm/odickrCYAjwXWggL7LQ2G4l+gVJSU+aagHAnHf
	 fS+e+YShp6GqAAMioEpvJMbOOkjDMCL5lJU/cfxkdiUbSHkjm1yKeXDESlp0fJMfht
	 iSG23szz+J/DgIdXs8WA/oxAW9kQJfVI1Asn/Vq8H4BGIaKmQGVpSeIQwRK4sFO8y6
	 RCpEUe885QO8w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SJ Park <sj@kernel.org>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shubhang Kaushik <sh@gentwo.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/9] mm/damon/ops-common: align MMU notifier range when clearing PMD young bit
Date: Mon,  2 Nov 2026 07:07:50 -0800
Message-ID: <20261102150757.93058-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102150757.93058-1-sj@kernel.org>
References: <20261102150757.93058-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 37C1018000C
X-Stat-Signature: patgo31p4t79qygtnsrccdi66k78o6ex
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632087-362989
X-HE-Meta: U2FsdGVkX18k9rTed9FJSHOsBHvmN5QHz+JOmGd9LFDH/TQwKxEOwTcbtavV1pQZgxTCqZDopLl5TfkrZ5J+VJZKR8eRBKJpf2lBq9CTiKPUc9nsA6IzwYAYodcSqD9jVwaMF6ij7iaxtLkSbKm6g850wqX87aReXEOe7Yw+Ow0HqP+d4pIlJe4BcjlR/9x+lK/4PzoB/rSigzkTnI4oXb8Q+CyxvobuUSM7C70af0Z/jxI58E8RenmdHbG2esV8bBt3+ALP8i0HQn/m+HR1UnhflYWTF4bIiChHnZqkdG5GsLpjLNdf8tTs2v8Rwr6q/4Z1dl7oe1Fg3bj0iX73wRwyKn6WTo1xQU89vSibIV/R/3zTYbRGxYLjzxH5Zswe+uQeChsj1OnUOmNgQHr+wfa1tfGLKzWTnECvfUg3Vy3G/4JOW2A4FaqTc1WJUhvXsxnAATZexXzR05UVXO9DpoJrz57MPH0Bg4Q3AbKnjL0WTGjItTfpI7GV3IlQGujFh/iqKPu0KZ+2/R9PrrF69EHX/Fm3lcJmBLewvYG6OlLtrzSMuezz2fzRtCLi+rFf6CILa4YACFh8Nih3gZlEihr10YufPWChBPZCyGuWbcIwgaHYz45y2UMP2X1zPqxddzP913y+DykoyVnRBU6IxQHydke4Pq+mMeTr5z381kmGImvQxbkxBcD4eusm9N75Ys93N0N2wKb15cDm2ZtAXwT5aJMfBbyDiBG+hKJN1qAOxxgDKPBidxz0/kTV1nQtcxUm33CNxmIP4WhtAV584ef99//jRLUSRxeb/Ms08RmZ8WkcCuf+sz0Hm7Lh6jndL1znqd6HF1APUfJju8/n9SEMBimJNcS+hDB7u4fFTgM8XBnJBgQPp71mgUHt2srreaLc+MsFPHryymY7QWpxc60t9VBruyy4bbYA5QkoSeQttkBsmv8hx/JaoxnOOdQx7FfRmwuAcR9MYSG3UhU
 31mV0k+q
 g/4CskShWwr33oSXWrdUczbQkAqxqNfXZKh/KEBRGrodOzRFoMEmTqvKQeLkRLcIq9TD8aMHAtL9C9TzyGG6SMIRK3m0AyxZej9LuKV/wpvCr5wMnXl5t2kG0sHj5CiXBnq1acDSkziYS/dd4LwwFYh6SAkL1jBUSxfLH+Oy1q9lXYMnaShT3eNoUPvtLM17zIZMHS+AQe2RS0/BHWG9F6Kkn8dauB+kmJOZ33FKiIGv2p9T/0tzbDNiv3KCu2gceUpmJ9WFBovk6H4AlBGVKNXeNek5/Ib6UN3RagWA+fXhsthvj2Am1iwY0zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

damon_pmdp_mkold() clears the young bit of a PMD but notifies
[addr, addr + HPAGE_PMD_SIZE), where addr can be an unaligned sampling
address. This can miss part of the sampled huge page and age secondary
mappings in the next one.

Align addr to HPAGE_PMD_MASK so both operations cover the same huge page.

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Cc: Shubhang Kaushik (Ampere) <sh@gentwo.org>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/r/20261021-damon-align-pte-young-notifier-v1-1-d0365ac45b66@gentwo.org/
- Drop Link: tag.
- Collect R-b: from SJ.
- Update subject prefix.
- Rebase to latest mm-new.

 mm/damon/ops-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index f88c6fd189fca..b9571f53e538c 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -102,6 +102,8 @@ void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr
 	bool young = false;
 	unsigned long pfn;
 
+	addr &= HPAGE_PMD_MASK;
+
 	if (likely(pmd_present(pmdval)))
 		pfn = pmd_pfn(pmdval);
 	else
-- 
2.47.3

