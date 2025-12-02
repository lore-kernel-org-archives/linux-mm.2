Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C379CD116F1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 03:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B6D6B0026; Mon,  1 Dec 2025 22:12:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143B56B0027; Mon,  1 Dec 2025 22:12:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FE56B002A; Mon,  1 Dec 2025 22:12:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB4886B0026
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 22:12:58 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D63D1404B9
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 03:12:56 +0000 (UTC)
X-FDA: 84173059152.02.984AF7B
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7BC8A1C000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 03:12:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764645174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=9omkPitbANQq9OizkUTZdjE9eczT9JD2GPqMK5rOCjk=;
	b=qRKU0FbKocnIl5AyYX3fGovuluGoWNOqZeQrSBlEtqE+DdPYluIm+A9+lqZtaw0WttaFyn
	ls2QiWNNh/J2vr0Ju1wDBtKQyTLZpz/mZ0qrqVpjfVkTX3//4rrmRP/UmNlX/jxKvxDpwX
	kEuDyeJX+qhy1t4qDWEdG6HibiynYsI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764645174; a=rsa-sha256;
	cv=none;
	b=tR22GFh3/uP53yaQ1JDnMtwwmcHsy+B1u1ME1Jh8T9veHQR8ADvwEnFblBhF8OyTsgF5fb
	JiE/cF12427jE0NPV9YhAve74l4FOFVS4aLhTz5FEbiSmmE90RWTlWtMjnbWw9cebbyN/U
	/Qd4xtt5J7VH5Wm1+F7Ms09PA/y9mzY=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dL5R12YDxzKHLxw
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:11:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9E50B1A09E4
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:12:44 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgBHb5wgWS5pxEM0AQ--.41565S2;
	Tue, 02 Dec 2025 11:12:44 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	jackmanb@google.com,
	ziy@nvidia.com
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	lujialin4@huawei.com,
	chenridong@huawei.com
Subject: [PATCH -next] cgroup: switch to css_is_online() helper
Date: Tue,  2 Dec 2025 02:57:47 +0000
Message-Id: <20251202025747.1658159-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHb5wgWS5pxEM0AQ--.41565S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAr1kKw1DXr4rJry7ZF1xGrg_yoW5ZryxpF
	s7Ga47Ka1UAF13GFZ5Ka4q934Svan3GayYk3y8X347Zr13t34Yq3y093W5tFy8tF1akryS
	qFs0yry8Cw4jyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8
	ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU0s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BC8A1C000E
X-Rspamd-Server: rspam11
X-Stat-Signature: zecso4hi7b7i4qhya7qfdh18j9mjeazu
X-HE-Tag: 1764645170-754016
X-HE-Meta: U2FsdGVkX1/pc+HPgdoVQCP+tEjYugrscDm8VlSpMcVjr8x20tKD6UbGUxjTkmEeAtW04rFN05PDDrhw+xKqokt3G1cXvNFQ8t3/ysO3Jx51alMBgO+DUDTMYJvxTbqjXRKqT2bsGGsIvgMFRlyp3aRfmTOfrRykKbr9OwLbBw7kcz+U7Ad9ppWJMeSyfG2jzqsUXe27qc6N3SwTSsXybWeU+8OtQtjZ7dgEa6TdFB4fNDiYtJoNOk96AnzmQTcKvslLpt2w4VqSqcCKBqsv137rUcz7aOwzO6lJqCj0p8xXB91qRebN6ZZ+phZyXtqdrSbFiRboEteE/emfMc4yCrCB2ouaIts/Y+NgtJm/kKeOqxUOgf/0evyyaXGziiJf3LKaQeRCUyprCw+e78flHUK0pdhFhOFPjkYoEaQKbWQ4adfsHtyx5syLEPW80pY2Um3ojwFdLtAhq0xtTahXEpuCJak9+xQ/vNcmWHZwJpe6FIVh+otKSuOULEECR1OFLoZ49HAE3RAY49kTzqKSAX3g+0DGD2UEqqSDEFuD74z8Lpv8Z8CrTIM/Ng8GJj2zDQELkvQVfS6CYdB/xxc8B/dFw7/1ojru+zXujc6qumd5RSkk4ti+pjIocGvUASb/y+v47yzcxL5Hg1FgTqCouRvsekxW7g1oSXSsBFqLxqNhsInN5j4touTSpWRB8v/sauPfAWjBrP5sqFdhb5mYOe1ynbPFhmtaHXBEV45+YdVjEv7KLBzZi4KCGnqm4zi9E149Ejn0TRSwrE1iQDz0mWdlIbQuPSV3qEKly+GZF09v3kf9PMNKfVlq0Fi2RHlgCJAnfkhaiypvkoXmYF1X2R1llh+0mcfmlKQ6IGP0aAESIcID2nh/roP5mRjUioSakaB5nJRbnL5R2lSNCvoTvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

Use the new css_is_online() helper that has been introduced to check css
online state, instead of testing the CSS_ONLINE flag directly. This
improves readability and centralizes the state check logic.

No functional changes intended.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 fs/fs-writeback.c          | 2 +-
 include/linux/memcontrol.h | 2 +-
 kernel/cgroup/cgroup.c     | 4 ++--
 mm/memcontrol.c            | 2 +-
 mm/page_owner.c            | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6800886c4d10..5dd6e89a6d29 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -981,7 +981,7 @@ void wbc_account_cgroup_owner(struct writeback_control *wbc, struct folio *folio
 
 	css = mem_cgroup_css_from_folio(folio);
 	/* dead cgroups shouldn't contribute to inode ownership arbitration */
-	if (!(css->flags & CSS_ONLINE))
+	if (!css_is_online(css))
 		return;
 
 	id = css->id;
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..6a48398a1f4e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -893,7 +893,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return true;
-	return !!(memcg->css.flags & CSS_ONLINE);
+	return css_is_online(&memcg->css);
 }
 
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1e4033d05c29..ad0a35721dff 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4939,7 +4939,7 @@ bool css_has_online_children(struct cgroup_subsys_state *css)
 
 	rcu_read_lock();
 	css_for_each_child(child, css) {
-		if (child->flags & CSS_ONLINE) {
+		if (css_is_online(child)) {
 			ret = true;
 			break;
 		}
@@ -5744,7 +5744,7 @@ static void offline_css(struct cgroup_subsys_state *css)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	if (!(css->flags & CSS_ONLINE))
+	if (!css_is_online(css))
 		return;
 
 	if (ss->css_offline)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index be810c1fbfc3..e2e49f4ec9e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -281,7 +281,7 @@ ino_t page_cgroup_ino(struct page *page)
 	/* page_folio() is racy here, but the entire function is racy anyway */
 	memcg = folio_memcg_check(page_folio(page));
 
-	while (memcg && !(memcg->css.flags & CSS_ONLINE))
+	while (memcg && !css_is_online(&memcg->css))
 		memcg = parent_mem_cgroup(memcg);
 	if (memcg)
 		ino = cgroup_ino(memcg->css.cgroup);
diff --git a/mm/page_owner.c b/mm/page_owner.c
index a70245684206..27d19f01009c 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -530,7 +530,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	if (!memcg)
 		goto out_unlock;
 
-	online = (memcg->css.flags & CSS_ONLINE);
+	online = css_is_online(&memcg->css);
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-- 
2.34.1


