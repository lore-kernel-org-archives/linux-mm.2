Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFD0CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349DF6B0005; Fri, 12 Sep 2025 04:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321E86B0007; Fri, 12 Sep 2025 04:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E6D6B0008; Fri, 12 Sep 2025 04:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 150C36B0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:26:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C04AC11AB76
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:26:55 +0000 (UTC)
X-FDA: 83879917590.26.190F034
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	by imf27.hostedemail.com (Postfix) with ESMTP id 695B64000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:26:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=yHTIEh+d;
	spf=pass (imf27.hostedemail.com: domain of 920484857@qq.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=920484857@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757665614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JVgWk74aBBUGYWnw57FKGQnctHzfE1dwx1v7FRI4+1Y=;
	b=u99cIWrKDlIvlSnP7d8GjmpS3avytLWCtbXaE68wPWjf6Bm457FVXIwqXjVyU7yIrO+7fk
	1YJDoi28VEeLTLrhNaqk0tOeDnYEWtnuL4GDBjHIeVXhbiV/iBmH8012PUxhkgMDArHifn
	AXDdhOcOyHPj4s5tqxBv38BGF3STvmA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757665614; a=rsa-sha256;
	cv=none;
	b=WZX9TCND4MPkRj9pNzuKu/7iqpMHAbDzcbehEDaXg1pTgty9hNJLhGNibvi4dMipueCGZh
	bXuGybr26CA5jWb2Jhi+ItjNt5N3roYFAFDCP7nL+JzhaFs8pjeLuEMKIPRIa+K2e68eKk
	JHZmJWM77BSdHNXSNDFQwfcThR4SuVU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=yHTIEh+d;
	spf=pass (imf27.hostedemail.com: domain of 920484857@qq.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=920484857@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1757665604; bh=JVgWk74aBBUGYWnw57FKGQnctHzfE1dwx1v7FRI4+1Y=;
	h=From:To:Cc:Subject:Date;
	b=yHTIEh+dSymEi7EeFMcXQmx6jRAukWcOyjyrxq1k0AkgAnTGt2AZEQLLN/JEQ+0sy
	 +PzakKno3mcypMmbALI0Bv8Wzc384Wb1tkSA4b+5LWPbHyrDHUGnHMsXCFfpPvkPio
	 mN+XSFr7dmtEQ2Bc9kc9uCdnlK9MD+nmtJJUL4Qk=
Received: from localhost.localdomain ([116.128.244.171])
	by newxmesmtplogicsvrszc41-0.qq.com (NewEsmtp) with SMTP
	id 51B0D4B1; Fri, 12 Sep 2025 16:20:27 +0800
X-QQ-mid: xmsmtpt1757665227t70xqaoi3
Message-ID: <tencent_CA0C296180B9D75FF6A53D6B4F2130888D05@qq.com>
X-QQ-XMAILINFO: NT7uTz3cNku257dThSuBFAkPHkFum1Rm9XBseMDLCOsSn/PNI1w45UQUGtF7Xb
	 T00lUeew2Bf+q/NyH0p136uiOwfMnMcMZpAYPPjheSIqCNbJfji0gxv8tIRhD+ndfpaQAfj46QFX
	 4+eiW2PCNeWcd24bjWeiflDnemVd6kCAWIV4y5augakdR0tYc38FXLuDnKdmDYbV5INPytMPYy/P
	 NvWZHFLMpswJErOxzQiHa/iKzdyFWiBz8cQUoGwliBQnWvwK3NA/wL6yE5jGkK2nFofYjM21rFe3
	 FWAhLb7Rh7Qbtc++9O0vpdSg+FkGZgtt6CI5jNtydfEbg/NjVh+5MTl5WhyA0GEL3cSiMG5/7ikD
	 ZUM7m+yUt+X2OVuhncw0CuIZC3MU5zJV6HndcWwzs9p2o55JdaROT84bEh26NLqgIlO84iuImjRD
	 9n2iumD01ZYeHZlVVsU9bst6KVmxUK9SUQEvG7uZ/lqjPRarwY0vNfKnSx3egNBHmdJbG1cL4cfA
	 bLT2QiaJVIaCGbHQNUGfqiSYNZfp0lsxANin+S8v3E0woU0Iba4mvuwBaEepRcC7pId6xT/zh/z3
	 fNUxIUjbh9m4N6ZtVQ3l4m6X6MvKJyP3Xm3SlQCmYbuihDTjQBDjss9IGoOb+EZ62JlCaF/PNE2m
	 keYLH9IFf8HHRLasu8Ia5I0Bu4k1xkqdt+rf6JAHAhO/r2+4mHX5ePffTxH5LO+jupkD1sYqU7lE
	 WQCNUk7suUP6/Ze62nZsiBZgWQpBVGlbPVlYKkeyqo1jprIZrbEBEcojsDMxxTGqMVVL6pYCoTXd
	 LtJar++UEaB+HCl9F7ECqUPBQ+m3pAFwA14K/QQHhxVnNVaJXLAiZZRBA0TcC0XdPN1wHQIJk9H2
	 1IhHUxZADchnogZMFFZ3WHNOiBYzxKvLJyL4cpfqCTVoJ8BORy5dLG9DCWik6dj9TY/soQK9ojnV
	 gq+l+LRZxCZwQMZFtipD+eKUnxJcFg3pBmQk7loSBbz4BV7dKwZX5+Mu/icJ51TnTB1mEjw03iU8
	 DnKoh/TMFS6+2GVqfyDosZPc73Y/vcivOjbFNZm13iBsSnZUum6l0PsB+aKr8=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Haofeng Li <920484857@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Haofeng Li <13266079573@163.com>,
	Haofeng Li <lihaofeng@kylinos.cn>
Subject: [PATCH] mm: transhuge-stress: fix potential memory leak on realloc failure
Date: Fri, 12 Sep 2025 16:20:24 +0800
X-OQ-MSGID: <20250912082024.1952510-1-920484857@qq.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 695B64000A
X-Stat-Signature: o67jwerffr88u8hkdzw8r9hs6f6szeip
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757665613-63754
X-HE-Meta: U2FsdGVkX19pyo7eRPoozdMct8YXbQ5xOShILKbD0nkVjkvy9JkBgOqIFwe+gz4bXHaghn9jnfAFGn++r/98E/Z/PA74jjD28szGhX1yTgO9+ixNjvU75/wsayjMYmTIFFyRPAHGPwgtZ3NM2pRkxUtnaIua/cw1/JtAEUH1cWDxZG9s4p5917OYraBnkS70Em4YLd57dIQWjb3jqGghTKZsajpSTbO3TQwKUztYfqButu9hZT//sX2AUUXTJJ6xF3JTQwwbX4sCKfUhdDrGoW0nsLPLlgzKZtJFZyQ7HFk9BUDbXQwoYk399SFMhWT4ibn60D6HtHmYTDvEL84+Mpis8Ubv2k5kkQ264d2qWSa4sn5SshxOJn16Jvx00Ip6QHuwsdoDG/DbIOwR4FLRcfYCj5ewDuKdnCok0xPyFQOdgl7Xwx7VrPWr+40y/Yx/l0T7xqJLrLhmp+i3cQNZ6G5E3mBgjhzMNOhjCk39COHE+oI2H+SEGU3aLFEiLKM3O5jnTn/atEouBygZnefjaMZq3AfVn+pXPYWxejbIM+mS1z6m9abVgs8kF2QPstM/NjulwBHgMXM25zpsxbkHOgWiW9y6QZNRPHzAXZEVf35ninJqpWdzGYULgOwI12XscReitCpUKeZKEwvne1oguOTiO1PsZreYGNhj2JQ7j4BsQ5hfjVn7f6GSTXK/2sWJ8AA9rudS3RB0dfxxLoz2ESEygmHKv39Yu8lgCByeCjUGbQE4LAkPQydntK+I29AWHDW9RWE67iolLpR3mi3YKj6QRmqX+uEIo+x1bg9qrrzJBg/m6wE5KJdqbC+KcSpfuA2R4hm0XFt+9g2h1i6LN1bmLaerPPdlufkHBsKVVlLq20XCTtMx2SHpiALuYMUdUhuXPliXQXWUWQ5hlXk23z+o/lefBrft
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Haofeng Li <lihaofeng@kylinos.cn>

When realloc() fails in transhuge-stress test, the original code
exits immediately without freeing the previously allocated memory,
causing a memory leak. This patch introduces a temporary pointer
to hold the realloc result, ensuring proper cleanup by freeing
the original map before exiting on allocation failure.

Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
---
 tools/testing/selftests/mm/transhuge-stress.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
index 68201192e37c..cbe86c5b8de0 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -30,7 +30,7 @@ int main(int argc, char **argv)
 	int i = 0;
 	char *name = NULL;
 	double s;
-	uint8_t *map;
+	uint8_t *map, *map_tmp;
 	size_t map_len;
 	int pagemap_fd;
 	int duration = 0;
@@ -107,9 +107,12 @@ int main(int argc, char **argv)
 
 				nr_succeed++;
 				if (idx >= map_len) {
-					map = realloc(map, idx + 1);
-					if (!map)
+					map_tmp = realloc(map, idx + 1);
+					if (!map_tmp) {
+						free(map);
 						ksft_exit_fail_msg("map realloc\n");
+					}
+					map = map_tmp;
 					memset(map + map_len, 0, idx + 1 - map_len);
 					map_len = idx + 1;
 				}
-- 
2.25.1


