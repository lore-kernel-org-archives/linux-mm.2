Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5FFCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83738E0037; Wed, 20 Aug 2025 05:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5BA18E0009; Wed, 20 Aug 2025 05:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98298E0037; Wed, 20 Aug 2025 05:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92A978E0009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4402B1403F7
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:41 +0000 (UTC)
X-FDA: 83796557922.27.DF8D6FB
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 58D5D40003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ty5nONvq;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680859; a=rsa-sha256;
	cv=none;
	b=hYkIc9CZ99dZ5AchomFUSFs5+66QeuAs2OJuBR8wfa6/S2TlCeHj5XIvzGHfW226Zyf6Uj
	Um84tzydx+6ymOlyO4Qlw6jVm5vr5bXayIzNqFNwfZYjJrm4sfKMo2ZSLJJCND5QttdG9g
	HWZELha1nKVfApF3JOy3sKN/5qpbXUk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ty5nONvq;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzdqgUo48S+1eTljuJiSw1fVT7iNeD7IfBQzpt10nJg=;
	b=TrY8S/fAekTsUvNaBHZ8EwnrmleQmXP9E3k6yqAC0mvjmIZaZhtFR0lcGLCRGPYIamekJf
	IRGxT+I99nQg9oJa8QxHvziN2sadqLV5Kknk+KzGPTqX+1ZELuEAkQUjvZxRgI+hxPgY4+
	FFEkAyPAdyiluE6GiTUgVoM0u5NEa74=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680855; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=yzdqgUo48S+1eTljuJiSw1fVT7iNeD7IfBQzpt10nJg=;
	b=ty5nONvq900RRY9wraDoVI23Z3TgP4+UhHdnvMIIRkr29CTcoJv6OCxDApUbWqunmZmD995FjTy1IynjJiuxdVA0IXS2Mt/bYEte1igbwkyFSNVz/tJx+WWfpqZVYzkWXJawq9n/Ryjw0P+hVHPT2m3t9YBNDadpXR06XEp/Drs=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBYTxE_1755680853 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:34 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 01/11] mm: khugepaged: add khugepaged_max_ptes_none check in collapse_file()
Date: Wed, 20 Aug 2025 17:07:12 +0800
Message-ID: <aa2db6af6bb2124ef59ad5665951e47806c00a6e.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 58D5D40003
X-Stat-Signature: h7a1jmq981zgnnzatwcz38f766ii3nom
X-Rspam-User: 
X-HE-Tag: 1755680857-579820
X-HE-Meta: U2FsdGVkX18WN/PT/LdJL27hXuYhE+IU39HGcF/mIjgCwcLI/oSyeZSb7+uMJMrtN4rHlDUvmzcTwiruf3pcbbXD05j5F1toUsN2C4OdxTdPmixl5XTiih8J3+8OtG70XHKJOKZAXucnz3rlwL8BDzOszTqu1hZ/DpDwn8bEYegabpb5WuvI2NjAR5l29Qr3pUCS7zKzDUdL/dY4eAQHp0ZTre/VE6tIkN2sXh4ugA0h8+IC2PtW/93aZ9AH5I3Wn6PBANBnYHnJcij7LoCM7LD2uyb6ebpUw2GeRHBFi3xvXik80SEY/2CSYcFoSjZ5L57BVvqe8sxGhIiunOPEWCfCIcIadSQEK95X6xe5phKgaQzi+ICKpE/Tuy2ZPOnmkOKZovIfiHD5/IfgeGiOD87vPaRWDXUucfDHZDb4vZEpqgWOVGx34HXuRF35sVmEBjMeKhNr8sU7t8C3jl4f5EA0AdJF182rEBF2XItq9avzDA+kHhF9lmAW+MYla55BtD0M+0LWAjHaBFpLdEixcKjvH8Y9fAe6mj6lZZRmb+G7c4VYV/BXudcUihXxadkR3wTp4njazrqJDovQ1pKYZX5n89SDDLHgS+bwDM3Vu5KHgbzZVw1inJ/d+SHOtzZ7LEv8d9PHzwciOpilCMt6r+5KPNCa7UcqTC/t1H/cI+ewC3pf1EnMemFj9A8k2KL/sLX6kKweQfVduLiEsNCh4k/YSwn+cMHxZQoalShgDy1NyvB37c5VJQN29xdFuxlAVp5KJFq4nw5liLtpcC01ZvjOFSQlNwFLG0SjkHrIBjU/Mof5lGVwBB8wSoZVJYTD6RcAG3lO1FuqaVBJKkHTHvirjkCluZLanySsnrK8jUwkw67jzuKI8dA4Mufjzew7Cyzo916CR9ZO+vOhdFg6AXwVcEQu3RT9CiVo8QQkI8YTDuION0PVbffWCLjFAxapSqpjTMtmLGz1vsjCZqK
 yuw+6YeS
 IzWH53rKXICKyjMHIOK0dQAbrWEPjvHlx6tLU2TXEMEyWpjSoS9hS2B3hlMkkIRdyRWSOm5H1nhMbkItB0z8vnY9JsVVw0voMAnfzuujI19vaFrMR1aok+ZHT0YPCQEWOgcBtvi5ZaC+iqsfSpPKXNhqi3QOtYKGpcJIFCqI56Wr86LjmipNIdOe+bVFgbubWcs2Wut9cRH4nVIfNR01MvKJJjzS11THoBVG4Cck8jw0SLaVgVrSjbW0OHXxiNZsOwGHeBoUPIt7zJAugR+QYJ15g9Rtt5ulKmL0QDtv+ielF5g0iyVlVvlbnFIj1Q7v/9lN8XShHWKKbdSE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to the anonymous folios collapse, we should also check the 'khugepaged_max_ptes_none'
when trying to collapse shmem/file folios.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5a3386043f39..5d4493b77f3c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2125,6 +2125,13 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 					}
 				}
 				nr_none++;
+
+				if (cc->is_khugepaged && nr_none > khugepaged_max_ptes_none) {
+					result = SCAN_EXCEED_NONE_PTE;
+					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+					goto xa_locked;
+				}
+
 				index++;
 				continue;
 			}
-- 
2.43.5


