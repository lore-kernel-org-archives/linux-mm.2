Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A776C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09C86B009F; Wed,  5 Aug 2026 21:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1466B009E; Wed,  5 Aug 2026 21:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0BFA6B00A1; Wed,  5 Aug 2026 21:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52F8E6B009E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:11:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B510A2269
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:11:54 +0000 (UTC)
X-FDA: 85069067748.27.490A23D
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf15.hostedemail.com (Postfix) with ESMTP id A3FAFA0006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:11:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uK9RwYpP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3V99zagcKCEAl0guecuiqqing.eqonkpwz-oomxcem.qti@flex--jyescas.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3V99zagcKCEAl0guecuiqqing.eqonkpwz-oomxcem.qti@flex--jyescas.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHXuMtbWju/rmVGPj2ANhVgDVgcL2e8ZMo4e+wRd2rA=;
	b=2ucNePUWpcx+0sHOEVkWcQvPrTwrqPsnKcNX03opCiafWYKWZdDUVY6N/MAYAz8+m9wNzw
	Zd8XlnCqKsE8FX63p2q31LAEa9cZ59OqLDan7Qds1Q13ZrTSp1J8Ds1kWCXiqAErQOtvYG
	BqjAmBjj95EPD0drXSFkr+4bDCXEb2Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uK9RwYpP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3V99zagcKCEAl0guecuiqqing.eqonkpwz-oomxcem.qti@flex--jyescas.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3V99zagcKCEAl0guecuiqqing.eqonkpwz-oomxcem.qti@flex--jyescas.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978712;
	b=NYMYoKGREfmQOq/aeyOPAIift6uaTRbU4r6IhsuqfqP8yft95CPQAsjj23I/jVXFYn7IRG
	fLsvv00HLZO98BkysBp/vP8QovUXAJByPO014lIZ4CZ4iq6m1f5H0m2x+83f+9WWTUGVg5
	ROz2+NSuhijNqNW44EzLLjXBXzVMbpY=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cab041eced3so2380158a12.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978711; x=1786583511; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MHXuMtbWju/rmVGPj2ANhVgDVgcL2e8ZMo4e+wRd2rA=;
        b=uK9RwYpPZq3Z4xKlNOms055EAbL0FZTsWC3VMMeqXwzmHUAmCOfZuxZTBDZV83b2KL
         VHt9zrRjZSb5d+aB2u9CuHRKSAnts2K8M3kU3R9/fj5nfnWTXI5VT13epZsdSVqwEolX
         S5aXzJTmp82Nx4YXCkk9JgE3+9R9ji3eIIy4+0Fb7/Z7YMItMgrjUOJNSpywYEo88PoJ
         i3q1NttC4CoAUEfKiC2jv4zJUKXijjhvBQWYPh6G1IBZyCnEXHSIGkoCdDfYDBPzwNFb
         HeTE3N1GPl7jR5J446gKUP1ypY+X2Wn6sQnEu7i41BG5Ffc7vhibpRbGRYH+AnTAFSGN
         FEuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978711; x=1786583511;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MHXuMtbWju/rmVGPj2ANhVgDVgcL2e8ZMo4e+wRd2rA=;
        b=bYBVPCOTmrghmbjGnidqd+yQU1MeLfj0oypjFUiZJa+jqxg42ZoeZVxXQNNrZmEZhX
         neMaxekTrZz8VYVpWOQ39cX71u+r/y6sVo2V4HoFSxFNGYYzdQub76ZUZVl9fPUJhuhu
         raGYn3co5gaDGQVt7gOCMLN4IxiHvRdsVEqkz/bHR57pGyyw1bjNfG6qB9BAAkIdUecg
         mm1kQgYqxKV61hjUQhs1V/4CsJlzpjsksFSEC8OWwSrtfN3DkXGbfH5rqWVsq23kn9AH
         vdlYUsFyNSBQFuGs3cUfyUgWPNR7XBoSZKx0RDw9+cD1BvjoxTAtDttH4ZTnx+PSx2qt
         5uwA==
X-Forwarded-Encrypted: i=1; AHgh+RoecO/FVFG3LhD33MVK0mnfteVmbrJPevY3OQExcO/A+DmuhCP0RjJgQ3f0wYvld3k1/Rmgu+1cCg==@kvack.org
X-Gm-Message-State: AOJu0YyLh3FUpq6wr9sykqLwPEn0Jv9ktE9XkHGLAGO3K2osfJ6bKyzE
	/aWTBhBQXnTTbaIedcJGchAnV1/Wf9X7jyxOOc2GU/6CYrmcSysHQUEWuPMUmSRH+LqASFhIqtW
	nHNgV1IACIg==
X-Received: from dyaw6-n2.prod.google.com ([2002:a05:693c:4146:20b0:30f:c4be:bef4])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:164a:b0:3c3:a08d:5b44
 with SMTP id adf61e73a8af0-3cb85ef9234mr13893240637.23.1785978711382; Wed, 05
 Aug 2026 18:11:51 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:04 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-4-jyescas@google.com>
Subject: [RFC PATCH v2 03/16] mm: Define the caches for the structs req_alloc
 and page_alloc
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3FAFA0006
X-Stat-Signature: h4xcdnpauc6pop5iuf1gudx3qa38n6aj
X-Rspam-User: 
X-HE-Tag: 1785978712-680007
X-HE-Meta: U2FsdGVkX18Lmb1veiKUGFBuFrG1oLuXhuvwPfndcPEbdOJNNJ0hGoKYHk+RybPKbLGE5DkIS/iaJufU6opWaaovZnm3n0mFhuTiFGGjZtRFFM+oG/pnSJSLEQTRZkST3qj4f2O6g3IR5YD1RlIH7sbIYo70lpXDWzQr6G1+8K3/95vcls+GcABE9ulvrb/5W+TkKgi/3gkLQllN2Nd2yTr3t6tdc2+c8rogZ+evKzTrZSGc7o3uEPExdWUQP/5cUwVQMTbhfrZv8LCcvFR2l4u8cFN+jcMeEWwfy6o6PiDxALA2vmyob4hIhcxHHw1JEvWXpQDNCPItTrJPhVCTMAJV+aT0Qa6+m7xEBOee/SqBRUIdEyfnRP036nUvvC4Ka+C9s+gj5M5CM78DwcgZiRyM9KSDSYV2Dd8cqNMzXEw+6PR3/wsPPnjybjtCvZqrOB16M8G1aVY94cS/hdVQdXB94qkQrbhllcB+mtHgt9sRUngurmGG/yTei84PxPhK8cT1aJTnyrL7L+t/xvKid/DccybCE3Mw39mfFP063XnwtBITIfP+xVgheVs73y7qLSKVdPTB1jeChhzIQPYmyFC7P2902LcvM1HB94PAGAPWoR0iGgdiB/9vxDF4Q8QFtjWCOdEz6n99p1UEzf/R+LA37zECN/TSrSacVWlcZVOKzDhnLKEbogUz7u+9lGkWFzVwmYqoP2tMAJZNHPT3HK1Yr3C5hCo2QFBih3trtJ9/JReg0Nd1GNIgAsKyAyHACjoIsa1KuV6GFRiDZGtL8vYAIttOlpE9ibEq5MVp9aRCBOJsKhVleFzvef9EMXgWG9EudUxgCwLZCtvIDiItSsm5SaGaEijWrslhMoncP61UMzd/w8cU4VVtoD4zI/zVmD4dHaaRXlX1pox0ITVnpCrlLvGLcmtGLqcpPIjE7y0tsks9P0tdm2AbHzVEe6vr6rwcGAL0AO1HvSv8hlu
 sh7BrbV8
 BabHg0JIXlCNb3061bGCN3+RUj9wznUdRW9w0xvypWSt2IioR/7ZyWnLSulcvy3N+xooOZccRyALhPjECyGO4iDs+YTXCeUIDCJJXFzjg4NBmkErNjazA+bRzopQnV0lkuQnzoA2jWKO0FvQZ2UNuAPR6BXZBIG7Q3Sev4xWQmGWMr8ORrb/qSBQz50nL+Bdgd/aDYK9nwX9X0I9kfiYQ2TyEs9ZBpfxk883YUxOhK2QU0cBkkLZ6z1TmhRRfJbmUfnQJ1pNpj/3dWhCmB5QDJAQsfOlu/QOgxULhgmUoX99mhV4dmIKhgscTT+RgWmkFPsvLNguunlU2u0zj1stF1fPbnitvjqlybd6BTVz4FO3ySJypwmkDBMUKATqImsbaoWWsU+2aL520rW3fN+wLkHPMcCZhg8HccJ4xesRxh/vwK3iV2TQxLTedfBxtU9abQXSOfkPGjHLUZtCs+GFGO/lD8nobKOAX3/te259vunWc2xZ4NolETmaOcJaHLS5Gw+XEVLghdC06LTVjw4wjapHeIgTwzsU245z1e+zrBad5EF9Tmnrl3BdfsBtUkvQ+JqrDdDHq4P3IyUcV/7hoIqimFAZIt8JUblS8S/tiRn5ojO72V1aChkBRPfBg7l2flEQniQ0H5D/6ZaecZqWFOeL7itJeQHFLI5BOvE3mi527rXqIwAADYa58zfqRLkrTgfjlBE7RfBNs4uc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change defines and initializes the caches for the structs req_alloc
and page_alloc.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Use static for the kmem_cache variables.
	- Use \n for the pr_err messages.

 mm/page_alloc_hogger.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index caeb2e5e8579..175f479c487b 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -85,9 +85,12 @@
 
 #include <linux/errno.h>
 #include <linux/debugfs.h>
+#include <linux/gfp.h>
+#include <linux/gfp_types.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/printk.h>
+#include <linux/slab.h>
 
 static struct dentry *mmdir;
 
@@ -119,20 +122,55 @@ struct page_alloc {
 	struct dentry *alloc_dentry;
 };
 
+static struct kmem_cache *req_alloc_cache;
+static struct kmem_cache *page_alloc_cache;
+
 static int __init page_alloc_hogger_debugfs_init(void)
 {
+	int ret;
+
+	req_alloc_cache = kmem_cache_create(
+		"req_alloc_cache", sizeof(struct req_alloc), 0,
+		SLAB_HWCACHE_ALIGN, NULL);
+	if (!req_alloc_cache) {
+		pr_err("The req_alloc_cache couldn't be created\n");
+		ret = -ENOMEM;
+		goto error_exit;
+	}
+
+	page_alloc_cache = kmem_cache_create(
+		"page_alloc_cache", sizeof(struct page_alloc), 0,
+		SLAB_HWCACHE_ALIGN, NULL);
+	if (!page_alloc_cache) {
+		pr_err("The page_alloc_cache couldn't be created\n");
+		ret = -ENOMEM;
+		goto clean_req_alloc_cache;
+	}
+
 	mmdir = debugfs_create_dir("mm", NULL);
 	if (IS_ERR(mmdir)) {
 		pr_err("Unable to create mm directory\n");
-		return PTR_ERR(mmdir);
+		ret = PTR_ERR(mmdir);
+		goto clean_page_alloc_cache;
 	}
 
 	return 0;
+
+clean_page_alloc_cache:
+	kmem_cache_destroy(page_alloc_cache);
+
+clean_req_alloc_cache:
+	kmem_cache_destroy(req_alloc_cache);
+
+error_exit:
+	return ret;
 }
 
 static void __exit page_alloc_hogger_debugfs_exit(void)
 {
 	debugfs_remove_recursive(mmdir);
+	kmem_cache_destroy(req_alloc_cache);
+	kmem_cache_destroy(page_alloc_cache);
 }
 
 module_init(page_alloc_hogger_debugfs_init);
-- 
2.55.0.629.g250fe7f194-goog


