Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52CCCC6B24
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E276B008A; Wed, 14 Oct 2026 03:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC526B008C; Wed, 14 Oct 2026 03:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7D76B0092; Wed, 14 Oct 2026 03:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84D306B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:04:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0319640448
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:04:44 +0000 (UTC)
X-FDA: 85320344130.29.86609F3
Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	by imf10.hostedemail.com (Postfix) with ESMTP id E3C28C0008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:04:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H+FGwyaD;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791961483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MclQwzFF3RoZllbWYTU9RhFo8pPDiEy5eQBv/tG7tI=;
	b=QJKBhAPpG9Gpm4u1zNpKSsS8V6QD+I4GPFnH1AUOnCfPDWOvnPk0oqqzhVSUXYp0teIURB
	APTdV1Zd6PvEfkFc2/jjIuzbvZ+jgY0Yqk6GVCnpjKPnzr+pHB67+4SZSYwboR/H11oKzM
	BWKfm5fGj1R6nno184fNIuC3ZJfPRfY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791961483;
	b=dTUITnYZkEoRgqibGWJLXvzS5FbOlWc9dFrRJyQiTfeanj+1brQ8muirrFb6OcJM9il5Zp
	ijTO+dlUIzoE9Z8bLrJpU0eRZVrOF7ciRBJQAHf8Yo1wRSn8HleARwWcYDR03ialJF5YQO
	06matK/HQl4q2jkEHfghPNZrdk/9Vxo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H+FGwyaD;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=a8IVuRQyar4rCZ1VnViGaDLpXC0Aw1KqpIOSXik/RRU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791961481; v=1; x=1792566281;
 b=H+FGwyaDNIKzF+jdFvOzYNS7JR9+rXkt2D5nwa4r5hjM3vfWtfG5HZgZP+uE5Yh8xATlCCol
 X66hZtsTw18VZ4bjVswkas/3FweJlB4V+wNsFe8RY39FY3+PHcJtZj4Wk3MbSm2DCrulfe2GHdY
 PwoIBAmgZJ8PMwVfTcBBTHyo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4460845ac86d30e9;
	Wed, 14 Oct 2026 07:04:41 +0000
X-Mizu-Trace-ID: 4460845ac86d30e9
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Wed, 14 Oct 2026 15:04:28 +0800
Subject: [PATCH 1/3] tools/mm: fix memcg info retrieval in
 show_page_info.py
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-show_page_info-v1-1-7a68aee0114a@linux.dev>
References: <20261014-show_page_info-v1-0-7a68aee0114a@linux.dev>
In-Reply-To: <20261014-show_page_info-v1-0-7a68aee0114a@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.17-dev-39d60
X-Rspamd-Queue-Id: E3C28C0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: c75q1eu8j18x59q79ajwcqh9n1qt59n4
X-HE-Tag: 1791961482-887672
X-HE-Meta: U2FsdGVkX19cFtbDh9w39u5eZONQLFRLjgmAVCtuunEbBE83e4BnHlToBIfqLxYJqDMv53+m67iiyTdwIS1+fgPXYla04YCOySND6NRboN/lSsB+pVBXH3OHUczj9xfWygT69fSwz5kJ9pcsIPMmRNmg3fmKTvW2C/ZyopAIRKQLQ5Ui0+Or+RpgMlv0zAe7eJSTSL4afY3hWZ/2Ib8mYk23SMoPUjXCzyixYxLzc9cLbsy2gGHdOBCUshDRRIPOm48bvnDxl4dZW0eZ8n5AYvSx2WQ1+6covy0W/DCQtmzfgvXVsPq+BwMDesMAY7eL/HSFKEUeFpUvUTWYFTHlkeX9khdtVzCs69NhsHlf7b6UE7qzJdukEMPvbNhWx3qB246ZLtX2CKTsWnRu2RZMQXBITK6QLPHJ5+oDee0WORbS1WkwaRE3KpB833q1MlaXiqyWz0kWPcchVoIrODlsY8sH8+oJxANSSkLdkHNqeF1q+T2RQVyZNMYrBOlvcui9dlZTFCq9QX9DFTUCLQpshW/Nlj0DCS5U4ZzIP5t5ONioPH9bpCl97/L3l+zqqiisueSntLGLD8Yoxo/4jdmFDAStJ4rt5u6fVWFxhO9HA8ESlHdmZlc6BHGtK31Hd0UEfufWslBdcYNHprqOWkUqRrAppG2UkHEgf31FMcjWH+Jbp0CCUe4lsvpm8pPmoygefPz1Nw1UXWR4+HqFJ/7nm2Jg2xfpHcA2JFCMp67PGp5HXH034i49MmVLS0tNMaMf8gYHalB42bwI34YZZaesoRjl62sWZ8bybYYieAdlF0nJkOQ+Cz2+27IIlrFYNkHn8lGEfle+kLT6VXWFEswnpjZe1ME6TOsR3bXfjxFSDm6YCVo8mNkDa+IiLgYG6Sx0U8uePZ2xwqx73+loBdbLjsvMksQKCeByfvvbFhWWFs1tY78DWFNvUz9vpZuUmbSNgYnAq8ZGAE3sIOwFb9W
 NZrQ7hG4
 WiP+qJwLjwof1gWvALmRMTk5fEHsINcamdHU+EFi0dpNKdwvE1jg9fLfht2xytYeDALl/cjuGP9U07ERepJHiH40a7P3Z9Kb2vqGma/tH18Q2ZJurGBn6wiRBQFrQkGVpWyVU+AU81GS5tybvWSb4JjZ1hncIQRI+E2pKeeKpk73fXxbEJ/H6ZHnSKDo1Ze41lLxK+PP1RtvEtmaoPPljsitbfaVg4V/0l7nSkZwBhIszMJziuMze7DaNDOpHOZC119xffa7MWQtZ6JFKsk4vQjK6jANUHBLf4geH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Fix obj_cgroup type casting and slabobj_ext field name compatibility.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/show_page_info.py | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/mm/show_page_info.py b/tools/mm/show_page_info.py
index c46d8ea283d7..9cfb5cac05a3 100644
--- a/tools/mm/show_page_info.py
+++ b/tools/mm/show_page_info.py
@@ -53,17 +53,18 @@ def get_memcg_info(page):
     """Retrieve memory cgroup information for a page."""
     try:
         MEMCG_DATA_OBJEXTS = prog.constant("MEMCG_DATA_OBJEXTS").value_()
-        MEMCG_DATA_KMEM = prog.constant("MEMCG_DATA_KMEM").value_()
         mask = prog.constant('__NR_MEMCG_DATA_FLAGS').value_() - 1
         memcg_data = page.memcg_data.read_()
         if memcg_data & MEMCG_DATA_OBJEXTS:
             slabobj_ext = cast("struct slabobj_ext *", memcg_data & ~mask)
-            memcg = slabobj_ext.objcg.memcg.value_()
-        elif memcg_data & MEMCG_DATA_KMEM:
-            objcg = cast("struct obj_cgroup *", memcg_data & ~mask)
-            memcg = objcg.memcg.value_()
+            try:
+                objcg = slabobj_ext._objcg
+            except AttributeError:
+                objcg = slabobj_ext.objcg
+            memcg = objcg.memcg
         else:
-            memcg = cast("struct mem_cgroup *", memcg_data & ~mask)
+            objcg = Object(prog, "struct obj_cgroup *", memcg_data & ~mask)
+            memcg = objcg.memcg
 
         if memcg.value_() == 0:
             return "none", "/sys/fs/cgroup/memory/"

-- 
2.43.0


