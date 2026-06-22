Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BC4CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 09:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955FF6B0088; Mon, 22 Jun 2026 05:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF0E6B008A; Mon, 22 Jun 2026 05:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7786B008C; Mon, 22 Jun 2026 05:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4516B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:39:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8EFEA05C6
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:39:06 +0000 (UTC)
X-FDA: 84907049892.30.B4AA1FE
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf16.hostedemail.com (Postfix) with ESMTP id A588B180003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:39:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pLnmtRWU;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782121145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Rxxvp13V2SH4mlEC0Z4qvpzzqaS2fGtDOQumXfcfk8=;
	b=qXYPYgXgtMGZa+JSxH3LKs4vJhDw70NgVfFlEk82r2Z0V1Abgx2MoCz/+iTnlJuxrUFUA4
	yyavabFxpZtISdI2AGch1krHK4HIfpwVJ/+xSH2T2tNucORqX4U4afSL/mhhKIonmXgyFP
	CRYExl6YNwyFZa88kx2Ax9FRE2ZfF+w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pLnmtRWU;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782121145;
	b=Bkf6681wLHGg5lsWgfqAEiy9xnHCrSKI2/6ZQySgWnGJ2RUNAlYuYggmXfVh5F8kiosZ+N
	FI6MrvQqCLP03oQe6YxcksnhgCG6BZ9Y53jcsRGIxrB7h6O6kzll92OiFVrcd34cmGMsvl
	mL0yBkxYeeakuz1wS3T3E4yK986EH90=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6Rxxvp13V2SH4mlEC0Z4qvpzzqaS2fGtDOQumXfcfk8=;
	b=pLnmtRWU9Ab4gV7e9VdlLIDWpLseDnNPDiEB52zjh1ma2D5Ejk8JNbpbbCYT9W4NmWWXuGLsX
	y4VCwTnvNZvq1Jsp5bFyuj8za2mMNpBP7+OZ9n+MQhag7YT1FwnW2dt5E4HQtJYod1dDjhGNsBV
	b3eySE/P02x235SH2ezylrY=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gkNH301CjzKm6k;
	Mon, 22 Jun 2026 17:30:54 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 13D7440539;
	Mon, 22 Jun 2026 17:38:59 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 22 Jun
 2026 17:38:58 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
	<svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH] fs/proc: fix KPF_KSM reported for all anonymous pages
Date: Mon, 22 Jun 2026 17:15:39 +0800
Message-ID: <20260622091539.836531-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A588B180003
X-Stat-Signature: 9wfzaci6dtoj3i94xi8djy5wn7egnyqa
X-Rspam-User: 
X-HE-Tag: 1782121143-312706
X-HE-Meta: U2FsdGVkX1+3mUM8hVJMhA+QMWRrToGi1Rl41N5bm7tnBxDweWQDEbc/3uZpcy/e3JQ8lddAcwc1NHwxzdaS/fhkQVvxVmYE9MOM9wT3drB2leo/M8U+p8XNaWdFYdWyhuhXTBsNIYShd+DbJvRDTImKY1/TUG5uADvwOK9/nhC8V4irPqkP5fol79c07ZWGCQBSNkD9+buWqc72MxCr9nFigzNcLKf9CZbxa+Qf4LmZFeFy8nOaO9mkMrPjDuScTLGiSg3Q63v5kRHQxalwK8ZV2/H/DqAQzRR/XR0UZ+WFSf+10v//5EoDQhtobU3YsXY18k+DUWyDBAbWAALmbGopK+cnKOBkzVAYbcBqyTfk3XvvcI11qYScrSPl5b9aZkfGEHKIc+zwvK8gADpih33EdNXfPHludSocoHlfJ/V4ST/3UTJkru02i8cbcpwd9t7WEuZx0Y2/5FOSnzE57b4Z/24Y96fCOevvFuIu3usaIKAfHiOoryh1BXrClNntX1Ols6nq29ziav+xnyJITMy/lXG66xjC8MQc3LlmwdNcwWxj0aOAVqCni1IWEJruWYvlVAxeZDBytbdDIk3Zvk/5N5nJPuRDKR1MqE++mX/SJ1ElLbvGTwuVpSmBNuYLtNeFT5OauwzI/LdNtLnC53CRDnktDmQkKynSIzGSSa79ka7DcBIzF0E0u4dk2LS9IlH1EUHeZiCCVhNRcNk2f3kX9D9UzTrT5DLuGQZhlTnaN+UCLuTY37udYjLL49ZrbkrjtOkYOBnk0yUaMchm60qaat44s1hoYCYgnzubcz8xbZtcmabYXUdC1zlERxOqiCwaee9JbVerMSTwdjVphZ9VKubuilj09pvUqnz5CsQC9l9NRm0ldl2Fly9ScwIl9lXBygWHp/IhxTb0fjb3jY2JLWm9kzYyoNqhmwNdamuW46g3rk2xEmf3yiXo3a6fjbF8LrH6CbUNMwt3geS
 EVYz7wgy
 qfYW9jYkhACLUE5997PRa/YSnLzZp16PlYKDLqorG7cRNcSYp50sCvNii47dGdLnEwNzbP9skd7vOr+Df0y2O9wTKff3Oa27NTpVqOkyV85xxqoidbA53VG1Ftz7FkiwQ+l8/YGG/tHfMIn2QmhPph6CvbUWCGNFcy6dJZ2QCX11VymL5msUYqlzurn10jogwVj2Ko3at88YuMgV/eFuTLpBeywmRLAMIIJsz3miaR1tgCD8mSOpzYro9VYiL+f0KTu9/SOMxnsJ+UjjVWKWvlC/ZTHFu/O8i0ijztdjiDzhFJIf6cTrTEs9QX7P2ow8DDlggH3kknVH2lG/kuLZLHOw0xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
when KSM is not in use. As a result, tools misclassify all anonymous pages
as KSM merged.

In stable_page_flags(), if the page is anonymous, then use (mapping &
FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
(mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.

To fix it, use FOLIO_MAPPING_ANON_KSM instead.

Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 fs/proc/page.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..cef8ded97610 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page *page)
 		u |= 1 << KPF_MMAP;
 	if (is_anon) {
 		u |= 1 << KPF_ANON;
-		if (mapping & FOLIO_MAPPING_KSM)
+		if (mapping & FOLIO_MAPPING_ANON_KSM)
 			u |= 1 << KPF_KSM;
 	}
 
-- 
2.43.0


