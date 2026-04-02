Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A9FCC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C81A6B0089; Thu,  2 Apr 2026 02:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69FC46B008C; Thu,  2 Apr 2026 02:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DCDC6B0092; Thu,  2 Apr 2026 02:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F39C6B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:50:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D343BC1E79
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:50:07 +0000 (UTC)
X-FDA: 84612691254.27.2456998
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf18.hostedemail.com (Postfix) with ESMTP id 169931C0006
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:50:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=TyHgTqD6;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf18.hostedemail.com: domain of 18810879172@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=18810879172@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775112606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ryckpoj2p07O17MrN6+Z1FqKRc8sECG5cLDBxT2Wjhw=;
	b=yP3zLOcz9ffX1FofJ3Hv/zZ6IKnO1+BBJrPpvxUYpTaCP7INTILmuN/FoDEPMM3HpqRc1m
	eNODdeTaVrVy5XHSKzWydhIalZGpfBQuOep5bYoBKYmLEw4+ID9I72ZK/QyBFeRrZBo3Ac
	7BFfpWUk9FW4Ex0zb3CdxmxMB9W2fkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775112606; a=rsa-sha256;
	cv=none;
	b=MAUIUHy6G6NTQBKC7tecKJ0jOHOZCB3J6I3YFETAX3CgfvivAJSPGfWeu3Z0b8PDeVueW7
	GUiRr95gnU7bVjeHISgTFMzvAgvnBdBTjiZjFdgZRsKw9eKH9O8PMSbnVUsdiuo9OLr4//
	PIJj2R6lWVz++N/e1xoszS/PAkd7R3M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=TyHgTqD6;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf18.hostedemail.com: domain of 18810879172@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=18810879172@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ry
	ckpoj2p07O17MrN6+Z1FqKRc8sECG5cLDBxT2Wjhw=; b=TyHgTqD6RORaxAsiWv
	TXl/+vsveXADsfbcSs5a3iGjzZpHh7kLAb49ITf/NMqyGBPWF9TnO7y4lDCx/wb4
	4qnWDhxMWPeJggMaYzECBWh8Wi8dLcb/wDuxwBw+HcTI3eLpyx6qyJYkV2Hg9LGt
	ZnDrzhNWgZsm/Jnjh3KE0sX+4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDXqB6VEc5pJMmHCw--.5843S2;
	Thu, 02 Apr 2026 14:49:58 +0800 (CST)
From: wangxuewen <18810879172@163.com>
To: linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: [PATCH v1] mm/memory-failure: replace magic number 3 with GET_PAGE_MAX_RETRY_NUM
Date: Thu,  2 Apr 2026 14:49:46 +0800
Message-Id: <20260402064946.1124250-1-18810879172@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXqB6VEc5pJMmHCw--.5843S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr1xtr1xKFykJr48Aw17GFg_yoWfXrc_WF
	4rt3929F1YyF9a9rsrCanxt3WYv34kCF43WFn2qr9rtFykAwnrCr4vkr17Aw18Xrs09F1a
	9ryDXr98Cr4xCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1HGQPUUUUU==
X-Originating-IP: [210.12.40.82]
X-CM-SenderInfo: rprymiyqyxmiixs6il2tof0z/xtbCzhZ3bWnOEZZW8AAA3E
X-Rspamd-Queue-Id: 169931C0006
X-Stat-Signature: j8hompe5nq9549oaqui5qu4jmpgosgh3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775112603-468971
X-HE-Meta: U2FsdGVkX18HFNXKHj0WQX4T4DistRR8aOODn1IQHnPd2VAX2PDrtlTWQUYY6kmw4go4dpEjaxU2EURqGWCRon5+SdEddLD3ahzpV3DOP8e2cmGGQPVzT3xvn0+gnFX9eAhyhOf2yExhiH8qcCZhAQUTRbYydTS8rP7VvZKvz8J9mIaqxQ6TrUDLw3UAqhCsFFuM7Ayxe6YCiMhnNB8v1VJagjyRrGzuj/YROzKR4QABZDlCyrkEKMcWEpO+gysQ2fqkYpo6APU69f8xRfwnW43G19WIkws58dkWwrJkSlgqBB6aTZg8HshkQvFiP4yzMCMNEWH0PZCB1VXVO0uDCDLX7pI/IF13K6MAypYYKc6xJkZQha9YO9IXS60XJQ3qbGis4MoIfwZADoiWp6HjQQO5qBOstZLJfOirsdYK8OoWtfx4G2Jn21eo8VIhyrs2M3+BqQP7EaLLXOOeMf1pVv8aJKdRp6ARHfamSBkfNMY0BDvzkOHG5wkSn0hpE4WZhuYaLM9kZ34ZDh1SEsFgH1iTvvi8P14tcIgGLkxyrHee5z7UxM77IQvd8sP6OVN9rVn9KJZMOiGYE1SNEQyOVOUIZxHeDIb+9H9RcVKpTCspA8mEWG2IaHeWGT21wxpzcyjtKo5s3GpwN/A3+rm+3TurPqkIClz634ReWcHuzr+tu0Aryfe5u/dpIYIMsVdGRrRPINjPo8eWq3BpVY0kUgQnk81g5ztq1VrnkVMu2gzaMXW+4QE+8yfQ9tktPa6CUNEswyS8se5vN41UH2kwzxyACZ7qS6jrjG0MjXCcxHejUfFONYoHMKmE7nCsT2gM4QYQIlS9UtKrf8E/Z6Z5sDTh7xQAOQpGebTR7W3RUNZVdVUsDLGUlIgloNKzTCqPwFRTBAyDDCrosVrnK+ld6ICSHzMxabWMny6oihe5hw8w8gZ95MyiYCu55A3MYRJk6MeLGiHVtxJe4Es+J9d
 rXXsclbm
 RG0JlXeTCZoByoZfIo016JUIeTlCi4h4qBlfUmwSRzzOYQxGN2dmM1ONXwkAtNK7ysl+rSRB9o+BCz343q/KkuB2Dwm5HyUUUOn8s9D9PKMry8aoqvFS0fTjoa6biXCRPH5W5ePNF/JHS2tqondUZjLUbD0Cg5KMHWWLK6TXbJ7QtXAsofvIStsl9diZ63R/WjocI02mm0wQMX8RJLTqNJTWFm2OeV687jsznpwK6QvTomXLKETGsdRO5looezJ7Q+DFJezspNSG4rsQhiBPyqxf5dWwWHkKg0mJs5Y8dQk1manlj5NvXtkZnZXiF4cOXjOONiuQBNx+cI09Thr382BHCyHer/oNfggobeQR1TmY2Z+ItnHYGiN2ay/xHN9Wgxe9WZOow2VwmY6GpNMzlgXyrUkl7BvHIfncn1OYk7Fu16zImCp6U2pNJO59itnP9lbXmbIRv2WxNaIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: wangxuewen <wangxuewen@kylinos.cn>

Replace the hardcoded magic number 3 in get_any_page() with the
existing GET_PAGE_MAX_RETRY_NUM macro for code consistency and
maintainability.

This change has no functional impact, only improves code readability
and unifies the retry limit configuration.

Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
---
 mm/memory-failure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..e5a6b1353d9e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1418,7 +1418,7 @@ static int get_any_page(struct page *p, unsigned long flags)
 			 * We raced with (possibly temporary) unhandlable
 			 * page, retry.
 			 */
-			if (pass++ < 3) {
+			if (pass++ < GET_PAGE_MAX_RETRY_NUM) {
 				shake_page(p);
 				goto try_again;
 			}
-- 
2.25.1


