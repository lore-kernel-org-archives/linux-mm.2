Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD564D7495D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 07:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7897A6B0088; Fri, 19 Dec 2025 02:43:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736036B0089; Fri, 19 Dec 2025 02:43:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634926B008A; Fri, 19 Dec 2025 02:43:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 513D46B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:43:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF26358B67
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:43:02 +0000 (UTC)
X-FDA: 84235429404.17.3820FE3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf16.hostedemail.com (Postfix) with ESMTP id D93E5180002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:42:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=QYFdxmOP;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf16.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766130181; a=rsa-sha256;
	cv=none;
	b=obm5ETzPYJXCM3OUQtoFGTDW5yDNsT+STM5W6m80Q1DZ6GjCmiyMalchT16hnmAMMVPeB+
	XCHJ7DrZU0mcmeHSWIPOfG7yIMHwJ2N5ZZBlb2nb4yyFcdXx4Nscb9uzeug6+59c9k8N0A
	TkqZmj3YyorzIhjK+DJ8m9nYp3wGLKw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=QYFdxmOP;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf16.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766130181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jvs0EDui5lz1TF1uIZ9gkaF5c3Y2j5uvMrhkKCIxrF4=;
	b=Zq6STnhPG9EOjV9CiriV1ndXlCuiCzQecO/Q7rn+NEKOjBPfOEDpkhvsu79c7ucLv0bK4g
	3NUP3dwAP+Ww4KAQp/fMr9iiLVzQjTHBZWfWj8XuA/EsA5In4MLWoOvcYuilJCYB38HbgG
	WcD7yQtWeF0S/mOqia9F6UeTi8Wgt+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=jv
	s0EDui5lz1TF1uIZ9gkaF5c3Y2j5uvMrhkKCIxrF4=; b=QYFdxmOPtqBtGlbebb
	tiqFeZS9ANembrIFaEHwG1AJYxzPrqOFIlsFPoHMP6m0uZLd9IzixCnDHu1cyL1E
	kP8beb4vkVfuZSaYgM15xKKuCZUxyfCIdQla4lZo5Ubwr52Qrk+qkF8QfLjsIdra
	gIRE1QGtn3/TTEqf5QhBaE4eY=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgA3BJbqAUVpKFv+Hw--.120S2;
	Fri, 19 Dec 2025 15:42:37 +0800 (CST)
From: ranxiaokai627@163.com
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	elver@google.com,
	andreyknvl@gmail.com,
	=osalvador@suse.de
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH] mm/page_owner: fix memory leak in page_owner_stack_fops->release()
Date: Fri, 19 Dec 2025 07:42:32 +0000
Message-ID: <20251219074232.136482-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgA3BJbqAUVpKFv+Hw--.120S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFy3uw47tr1UWry8tw48tFb_yoWfuFcE9w
	429rykCr4Yy39xZ348uan3Xr42y34DCr9YyF1qgFW7ta48tayfXrn2vwsxJr1DXr4UKr43
	Krn3ZF15Jw1fWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRtuc_UUUUUU==
X-Originating-IP: [111.9.14.217]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7g4nc2lFAe48GAAA3T
X-Rspamd-Queue-Id: D93E5180002
X-Rspamd-Server: rspam03
X-Stat-Signature: aaf45gcx34t6x16kswraa3mh658dcdtq
X-Rspam-User: 
X-HE-Tag: 1766130179-771719
X-HE-Meta: U2FsdGVkX18TBsp7GjDhocwV+Ebn2LO+TVfcQye0Sdz5UErFwbOCA6LmYhK+962ghhLsOorAtub3e536aUz/8vNUfzu/l8aFBZ/cZW6IikpGL8ccknvmKT2CV9gzPz+1/0Tfpbsa53SxEjiAfWEGGf3nzI3hBFpkC29h0VavITP7xXA3M6ucBymWFYOE+lkJH9SxMcNF4My3WeHcnu+2xBt096RtcxNOffFCKIWK3ZVSN9PVJC9gioT+R05yfgt9//GCJ4ATXq2rGJ/gmGa8jV90LffFgKFVyMT4guHB6gQOJOjBj8W6FG4CrdoCvp/6SONazrsAh2cWmWMJjUiqkwItoqpjykUUKXEYYZa4/H1OzRCAaZ5eLwEBRiJ1H/oygejmdQYAJZjMeIQeNzq+592Xt8OjueqKG+Y6M64Bm+rSuXseIcar2QEtUuIIkUFl8/bf2LmpZW/ApNY/BO/GtbOZI0fnJCElDD88c3vmnZoIzNqTM0MDHmBPNZE/ldPnqTdyh8C/eu1FnD9tVI/GfQo93HPNE7JNXxPcOZlMjgoZjvsii/OqJl3kFQFulZfD10CKctI7sxPEGlG+nK2iTgGWzaWq0nrubL7vrgnrONQWnLpMuj6xyhFR43VYUvGTejS/Rh0edzZWagiG2m7dh8TiSUtcTYWuLoPLvCiYMaKWyUnWVMElB+BhZltHUF+6TIuReVS97q356MphgXbapiJ/riTOTLuMyMENYOmsanLXR14oe7GNLdcbV3hkolpAnDeGRc0kYnc/Fog+UhXmjePeOd8EmILzUH7vbFWP8ncbI6u7qxHXB9VCQazJ3ii6GKevUcB7o4agQ9h71gTY7EdIUGveZGkKa4EcMfQw91OvbtK5f8gaaIN4phxy+t0tTIQOQ9lvDKx6CFfzOV4nzy3XftAMK/kvBmd+pAYNzqfVO7O4nGuzx960cSwl/W2QLJK1aKGsKXK/ZxT5VeJ
 CKjtinRK
 HpOdCuAf/vxCK1GDzwYfY+CyWrWYD36iD1ELSGm3qWyExZVv5kqIIJK5AxRA06uMzq47v5yqytJac4OUalCDrxd+IagrajYW1ztpFA2NWG7ENPiD6g9NnI5Nwb3qeq+uDndga/OKLsw0vxxT/3IjZLbZQJuMg6tngrhrF7jVxsuKyN+Zt94kxtxwz9N3pG9mEitzk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

The page_owner_stack_fops->open() callback invokes seq_open_private(),
therefore its corresponding ->release() callback must call seq_release_private().
Otherwise it will cause a memory leak of struct stack_print_ctx.

Fixes: 765973a098037 ("mm,page_owner: display all stacks and their count")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 27d19f01009c..b6a394a130ec 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -952,7 +952,7 @@ static const struct file_operations page_owner_stack_fops = {
 	.open		= page_owner_stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_private,
 };
 
 static int page_owner_threshold_get(void *data, u64 *val)
-- 
2.25.1


