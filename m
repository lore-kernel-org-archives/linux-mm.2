Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7588AC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83CBF6B00AE; Fri, 18 Sep 2026 20:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED8A6B00AF; Fri, 18 Sep 2026 20:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690166B00B0; Fri, 18 Sep 2026 20:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 406FB6B00AE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0EB38015F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:08 +0000 (UTC)
X-FDA: 85228617096.03.7F19809
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf11.hostedemail.com (Postfix) with ESMTP id D5E8440004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b mRjiuX";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Uwkym9r6;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8IAR5vD5SCVxu0A7qSyVndGraz+I6DqEP+PM8vYqhw=;
	b=BJhBRzmCm8jBvyCKf84RpT0aO/kFU52GOzYZExKxROIeYnQVg78rq3E01dTFvZdG4378lV
	tKNsahdsrB7vgK6d6UgQ2ljgu0IZTRTwLvutVHNQ2RHWIKSCbOrFHNVdKt/8b8Pv1pGgVu
	r1imUSDo3PXqfrIwdTLzK+42dYBXOHE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777506;
	b=V8CdEsxh02mYQZ/YlWJqLaPFJJS7eqz8S1aeBQz0KyR52hvCF1Gytv1MNiL+W1Rx5Mf0lw
	1wNQkIl72obCtD2+lFLT0iOPDd4BJlGC08UsbfZCfOgzpbbldxBZVSJKKGYL0uo8Go0p/l
	axb4Td2JZtcdQz7Vs6g+QW1AzMZx/mg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b mRjiuX";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Uwkym9r6;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 745F014000FE;
	Fri, 18 Sep 2026 20:25:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 18 Sep 2026 20:25:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777506; x=
	1789863906; bh=O8IAR5vD5SCVxu0A7qSyVndGraz+I6DqEP+PM8vYqhw=; b=b
	mRjiuXtVkQEoqqZ5x10ZX0KiN0ZIkJBVsZOqKr3gZCMjKugrjhF7jhdtDD31ygAs
	fiZpvJuDVkg7XLTCgSDmZ0JUaSqxLsKX6p8g/6XLvvLsJjcvgljiaCPMFHoprXHC
	aMtJw0MqxTDEGCN5TLTBDddtVIEeJ0DcWsOkmSYgQzfD2Byx4j4jE3XOPgnuVVOB
	/Bh3u59fFWE3HdN7s13Gsf/GyUj2LLtCaghHeoVfK6jvz3JhhhqJkJXs4JxppDxe
	uicz6l8k1s/W5XjVEakg+mUgq0foZuFRN3XrFc9wgRqnLBqKFgj0gewgYoimokVP
	ta2wmnrWuFYWizEK1BRMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777506; x=1789863906; bh=O
	8IAR5vD5SCVxu0A7qSyVndGraz+I6DqEP+PM8vYqhw=; b=Uwkym9r6sk6LSf5y3
	1OIZVjTH5YY64arTcBH5+3mB39tDcNEfwn/QbCBM2vAlTNi5NPEgzwmRLPTLNb2z
	IEJBUGRHxKwUD0IEIzfWUOczDGcndI6qjXytwx0wgJpEc7PGcaZTdOhcddn2Q6I0
	nR3DF0LA1ksKWffVvaTrzWl3W09oF/RPmWu0BWO5+HDrQrXEfeKI4pi9SENAQ2Pm
	uLier1DZNO9lg0EEDS24T5EwXgGDH206Dl4Z4Mt09qB6qUrQ/AB/N6jb62PHLJWO
	GzkqgKq45gGbfFLY82a4s/yDkBbZQdfidBX5VYXjJCe+KiXlGI4jG10jrtiI8uYN
	UI6LQ==
X-ME-Sender: <xms:YtatajWGPGPvNYMsWwnZqdpXql6S-ilkY7eXzxVmFAvLSxVN4K-lSA>
    <xme:Ytataj9bebqGChIloQUzACXlVR4GiwhoB24xS4vy7yK_JLOhIT6Go_FZrFp1AqdvE
    LBcQhdhIkwn8su7K9XvZW1eKxJXoM_h718fOfLtBu7MM4LPJbymppGZ>
X-ME-Received: <xmr:YtatahnMflhhqITmRiIw_PoELrTEPTNvcGfcLxyS4UlyYlDLczxs3DI7eYE>
X-ME-Proxy-Cause: dmFkZTFyC+XeKYnZ766rqTYe4SsoatN0doBd7ADemiperjFlmE10ggdkgYpZeWmNOU4aBc
    lm02WEvCO2QGG+A0SGXMzCjVWjDSVCQ5WJ/xmSMbLZJLqVjt5aEnrGd0hUbHPJ/ejcqjFa
    xrmYY/YNxh9EpvRrTjNMqslNp6oZ1XKAjj0b9YUD/U+Umt4HJhNRFStrIx7jR3Gf+CAD8k
    /TwEvtSve0+WgA7utVqBt9LeXDUSIUkf7dn/1M9JWIyORT8Kp2cNKrwYutOzK/Z35sBm5S
    qWNICJAq9yYROUOkEgx1cQSYtjkPP2DMZwKGXS3JxTiE+xMdBmJUepOSBHs3/DvnVTIMfx
    L1imsBc7GKPy3QB909e6AYlrfJuc9CCvY/TvwvN4F5Vf1wSeUPBayPkIcewsfuXZ//CXkK
    d5MzgPYuC6cU1zvr0k0SVhh5xDRsAj55w2AIO4FC+DCXwaZqtxhIKXhyU6Vth+RIi1lt1t
    b/LmP9emsC9mVyKTP7veK7dUgrf5UuOrk+nN78P77e3vnH5A71G4tACFpN33j9Bq0+wy9P
    k4L2UX9tA2sDKLLbhGYnKBZ4Vo4fkZZfoKw6CW2vEY+Bjlq+tCE2PL2skC15yAqD6v+IV1
    W7217gqf/GHG4JK0cB1fGe5Elqk3Bcb3vKSm5tnwX8hqTxBqQan3Wp4AsW5A
X-ME-Proxy: <xmx:YtatamKOxV8YpfemJT0Gsc8i847sJRz_AecNndmApwat59Y2GezLKQ>
    <xmx:YtatavoUM81yuE_fc9ulr6U8ksXVO5hXeRwB9vwjsZXk6Q4JIoTSuQ>
    <xmx:YtatarTpH6qBHC_yCjLbSqTymYy_NHKC6Zyog3UX2N_hdNgMOA_CGg>
    <xmx:Ytataq7jb0nimO5J6uMWJOzYwJ0iygLPKAsSckrOewcs6c0WXTOI3Q>
    <xmx:YtatapPtkY_VquIALI4VI6eS11VOqPNjesAanB9TWxPLH5pF_VHzURH0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:05 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 04/19] selftests/mm: skip khugepaged page cache cases without a PMD folio
Date: Sat, 19 Sep 2026 01:24:34 +0100
Message-ID: <20260919002451.496763-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: myworbep956hqgpn3ahhoyfzrj1pe3g1
X-Rspamd-Queue-Id: D5E8440004
X-HE-Tag: 1789777506-139060
X-HE-Meta: U2FsdGVkX1+mdmqkWoFKVSmfmMtIrwDG6UeReSvT6uFnyrpFIqcEK91y/WgX2ZEKnB0K/sRBIrhiQkXP/2BWNZphckBbTVwkvsqxZjKcOgP3NCNGPws/v7hDmuRzeEaV36zsociwUGMtLIZ/JdIPDBjKUsmKWUbXYJEMBTVNugb6DZlk9p3mOoBxoGkaO6Ou46ORVxJ/faUnYCoKZD5ewoa9NQRk88nIlC+6TdzGNkFHE5oiVky9XdohSJMxo9m+N90MH5oLhAbzVJleyPw9ZmgjT3OkUl2wZbQOfXvDVg8ZqB9pCF35UYlQOmPBH3CJ306sL7ISaTHdZJ6R57qjp9ana3neFmwMuyPfk4JdL7J74tNryBB5sCPRpUHqgPd/PSYkXdbU5y5smsHMOTcKM3VfWX05cJlYYf5u4orUT89pWr6V1rCDRUc3EM3IvaaEgR79uyi7S3CNurDQrum94uy/twsHW8QLFh/qHc9E57jCSYfdT/H9hpPpMVa3FhmIQS2GJVAgTkIKu5QhvPRcJHnSth6WzdtqPTx6D80vaHnChb98UKROfsCO88D+hvyhQ4tLSHGaFj5JtDiSC+9iZuuB/WFqmZ20qi0blj4AujCt38kvP150trgWl7MYu/1zZ+f6jDJJkM1F2gNefbF0u8izFrJoDCDgNXMBNjtVQHUTkT/B291NVlnoEjpk4Nz8PMY5QZdN/3S/y/sF2J6YsNVjIL90/KNXqP4nxESl/QCFyPvM8gYaijmIjbL5aEUCVj5w1wxe9Pa0Q2lMHTDR46rvU+P3FpAYheanmT14GRwR2XqPXsPgyjlP6eSUSFze4c22Le06xrDg7MdJIa7+9MS9LeU4oMAFu8vVlEzHWsgWHTrJ00v0uVtp0upcQYqQrfefYttonh8OJs+VAom1YuGTHLoZ75YHg0+d7h2D2KzYSM9oPJ+4WQhOpgTvUz4Fo1Kl+XwDhwjvXSoe5iO
 yyxGjyQH
 QX4fLp5udukZtTpKzjorz6AXl5ShzGxdj0Gfs8DC447PK/JWlGlZbmv0slFOu+xsKhH3n8vxic7l1zmeTneP/p205wweW04j3cLI2augsaZS9nywgTpmo4vaFSacZWIzgd8b4yMv1pnqmXzuCcuNUc35WhltAt056W2OXtVOYniz8/B9bzCMDutn3UleZLe+brGkT41JCh77FgI2fNTSNw/Jo/4j+rMpLUdCxFz0WfgMocary2cIX0DFpVFTTM9aaZafoM404d23h7OMfkfEb2oZRSABEd3jSxWEjBLIGC/+fH/kIkWjxk75XC9ki92zorWoEDlfdO5nhH/SCILL5ftwZFPYXHP2moaLw0wlD+EqxV4xtdteeiZqWI4ZMoXxEjPnrTEqSQo2UBbjGEI4cciSvjbbMdh/5n9WzLEiUn989BAwUW78Q4svnXrptxym8RNzpor6+YsR5CakimgZfm1fAiCMZFlw/yqXYYLkaP6pK00xavVTSAHXYHY9CD9PgfsjNQmJRVCgnsbFkBvIL/oEp9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The page cache caps folio order at MAX_PAGECACHE_ORDER, which is below the
PMD order on arm64 with 64K pages, where a PMD is 512M.  A PMD-sized page
cache folio is impossible there, so the kernel refuses these collapses:
MADV_COLLAPSE answers -EINVAL and khugepaged passes over the range.  Four
shmem cases ask for a PMD-sized folio anyway, fail, and the run bails out
in the middle.

Skip the shmem and file mem types where the cap is below the PMD order.

The cap is not shmem-specific: it applies to every file folio.  Add
thp_file_supported_orders() to read the orders the page cache allows.

Anonymous collapse is unaffected: its orders are not capped this way.

Assisted-by: LLM
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/lib/mm/hugepage_settings.h        |  9 +++++++++
 tools/testing/selftests/mm/khugepaged.c | 19 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/tools/lib/mm/hugepage_settings.h b/tools/lib/mm/hugepage_settings.h
index 548e9d288d1d..94d9fc747f49 100644
--- a/tools/lib/mm/hugepage_settings.h
+++ b/tools/lib/mm/hugepage_settings.h
@@ -87,6 +87,15 @@ void thp_set_read_ahead_path(char *path);
 unsigned long thp_supported_orders(void);
 unsigned long thp_shmem_supported_orders(void);
 
+/*
+ * The per-order shmem_enabled attribute is created for the orders the page
+ * cache can hold, not just for shmem, so it answers for regular files too.
+ */
+static inline unsigned long thp_file_supported_orders(void)
+{
+	return thp_shmem_supported_orders();
+}
+
 bool thp_available(void);
 bool thp_is_enabled(void);
 
diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 189cc4fee18f..5318f3cfc0d0 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1358,6 +1358,25 @@ int main(int argc, char **argv)
 
 	setbuf(stdout, NULL);
 
+	/*
+	 * Without a PMD-order page cache folio the kernel refuses these
+	 * collapses, so there is nothing to test.
+	 */
+	if (!(thp_file_supported_orders() & (1UL << hpage_pmd_order))) {
+		if (shmem_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping shmem\n");
+			shmem_ops = NULL;
+		}
+		if (read_only_file_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping file\n");
+			read_only_file_ops = NULL;
+			read_write_file_read_ops = NULL;
+			read_write_file_write_ops = NULL;
+		}
+		if (!anon_ops && !shmem_ops && !read_only_file_ops)
+			ksft_exit_skip("No mem_type left to run\n");
+	}
+
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
-- 
2.54.0


