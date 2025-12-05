Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29AAAD374B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82CE16B0317; Fri,  5 Dec 2025 18:18:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804F96B0319; Fri,  5 Dec 2025 18:18:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6099F6B031A; Fri,  5 Dec 2025 18:18:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4BE6B0317
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:18:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19577C036B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:18:05 +0000 (UTC)
X-FDA: 84186982530.27.B197965
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 765C8A0015
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:18:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=hWRsVDh8;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764976683; a=rsa-sha256;
	cv=none;
	b=ogkAcpxtF8lFU2tD+N/I9yNylKDgqaUQGYhQRCz/cFaS/HlWC0Ge48HoEuNc9uu/naZ1Y1
	c4vgi3XgCnQi+waPCn3BIwykgqTsvTL182JRuNwqt3uMQr3eS9ZiLjqpM/yhEzsp/Vlp5z
	1rFvQVSsZVL3U29KijnOqN0R9MdtOE8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=hWRsVDh8;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764976683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m86uI6zdc31l9i8DWlMxNqeujbcKifkCUIGcK+zMg4=;
	b=rflREc0HPjJOg5aso4tXWkBo1jUMqVt9rZwK9f23QbDL91cUHSGbqZ2EDT+Tj74sFnfVdt
	W03udlfHnK1iUgawvips5VPLZ0qPyAm6vPX273li2FFEg8jhRrsf+Cr761GwRpSvvwKOd9
	T0Nn2SNPs48rN++UO5HFQtUFtl0vlls=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5m86uI6zdc31l9i8DWlMxNqeujbcKifkCUIGcK+zMg4=; b=hWRsVDh8tHiVgbUP0WgUSUIE54
	3mH+wH+c0mTMavD4noFY+F0LqtExnfdrJx6JDaRMlsM6CC9Nz/LuACLvJ1zYG0GWch1f19PdDXbQa
	a8A2W/Mkg8KLmuDPFiO5QRF+K1nf3GW+IC1pGUyo7ip3rSA7n5H0aQODPsh/etu/8RhWDQOh8lLdQ
	nTLaae9I9wl6E1MV1R+RiwK8NO1wNKkKJPBllifhC8t6gLlC3C1vMjUpDtAwSYPUDRP2OYPnP6hm8
	YjmgTu6pBLapclrJcmv1J2jh2YPi7a7Wm4000qq2gA/WhJYQqlPUA2GfEpE8LDAMwf3akeA9mkzSu
	2uhSUkNQ==;
Received: from 186-249-144-101.shared.desktop.com.br ([186.249.144.101] helo=t470)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vRf3i-009H1j-Vc; Sat, 06 Dec 2025 00:17:55 +0100
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH RFC 7/9] mm/page_owner: add debugfs file 'swap_page_owner'
Date: Fri,  5 Dec 2025 20:17:19 -0300
Message-ID: <20251205231721.104505-8-mfo@igalia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205231721.104505-1-mfo@igalia.com>
References: <20251205231721.104505-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 765C8A0015
X-Stat-Signature: rqixk5ugc39k3z4r66zdmfhxxsgw556b
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764976683-772124
X-HE-Meta: U2FsdGVkX19nz5f13EJ9bw7wW+GFVXSxOSNb1MSxfcf2c45JqlYc+13pdb4GvEiuLq30PgWHbZR3F7ZAzg+yWa9E1CXw43VWDsup/fL2XWz4CZI/o0QV0SH0pvvKV0vhbrrA5m06H19bc3VVDe1gKhdt+GPl4/MdHS5MOxN39bEam2Psp0R+K6LnWxnQq+fAUySSaQlzNrjMeqzJo0qKCBGEydD5CS2T0vJGIPHR9o/jGeZNQt1LLC2/gpn/8GARqN0vIjdpDpABLC6ZVB4V1KegvfaeTTLPoKgUwuGrA2og9+PM73vE4Ru7DkjyfbKpkyI3ioqqplnUfEs1gPP9eX12LxOb2L2hqUsQWmbZgT+0rIQH28x5AHNdXj/VftOBONn+eyL554uTfA5E732AghgzkiINOXvXm/r/AB1dP0sY81Xnz66ZUeyfD6yUoJWiczpuAuOnR1DIuZjGDfnjccAl8wG+jueVwtnH7pLaV1zi/Kg4gSk+QpRYozhGwmD6wyYLq4qRDsIni6+pnwHRCOauci8qHhGYXEFzFLoehAvQBdaeATMttm7ORxkBmITutGmZB30R77xEinUdUGvXa9dG5D5EDHccqQdBekq6z9inJywjQdediluBmd8Thy2b9vhDjJ7WKgAUD/zgNMe6W32+98gGNpEQHHHxjaUxlEURb97qpHngVvPU/zgGyVHR9MyHqLmlXM0nu1rwHTqLwcWkyW0P/bvuIcSC/6GRIs7Gehlod6jXsMTkTJ4CzQ188uG4UQGHIjsld5Lao/GrYDdSqVojcDIU7eGbIbIeU+L9rhBm5Y13qkS4QuDEBthtkqFvAxN6VZGpk3MOFwqMvuE2qy2Y+G8K7GfyLWtL3s4mvbxFpZo4KXadypVsE8F5q5WO1uNy2HvMk8R9QtQ5BfSuG09BGUPjUeqoalU5SQZh0BQPIuzzPquLoK45tfk2ZjYx71f/RqvmOGI48kf
 pzvdvYdo
 BXvBBsCURrHqPaBqCyEaMTFoNCV+IrcAQS+CbgiPZEGrIBD79U+k8Xeymky/hgbcj/qB7gOtcKMwBbp78bv1SvLpTT45nS9ILp3SjhD79Pa5CXxeS80IzjIuE82RHKdYJx3QDOIJWRSgXwZ+DTpEHKC2tubpbCgaQq5/kppuBD5kHwyFTPUDo8PT8zcs333VDnpsEStvMzen2whoXyir5XNsQD4fXL/vYRJ+p6nmqr3PrZ95jjjpfBvLfbnXsXKrHV0e8t+G0CWMVRxLv3EftsPSe08JV+F7ttEINaymzSOATuTI7j4WaP+CqgMseRONaQdy3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add debugfs file /sys/kernel/debug/swap_page_owner to report the allocation
stack traces for pages in swap space (i.e., dump the XArray).

Now, it is possible to list the allocation stack traces both for pages in
memory and swap space, via /sys/kernel/debug/{page_owner,swap_page_owner}.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 589aa1d7b9b6..e014eb7caf56 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -1103,6 +1103,77 @@ static const struct file_operations page_owner_fops = {
 	.llseek		= lseek_page_owner,
 };
 
+#ifdef CONFIG_SWAP_PAGE_OWNER
+static ssize_t print_swap_page_owner(char __user *buf, size_t count,
+				     swp_entry_t entry,
+				     struct swap_page_owner *spo)
+{
+	int ret;
+	char *kbuf;
+
+	count = min_t(size_t, count, PAGE_SIZE);
+	kbuf = kmalloc(count, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	ret = scnprintf(kbuf, count,
+			"Page allocated via pid %d, tgid %d (%s), ts %llu ns\n",
+			spo->pid, spo->tgid, spo->comm, spo->ts_nsec);
+
+	ret += scnprintf(kbuf + ret, count - ret,
+			 "SWP entry 0x%lx\n", entry.val);
+
+	ret += stack_depot_snprint(spo->handle, kbuf + ret, count - ret, 0);
+	if (ret >= count)
+		goto err;
+
+	ret += snprintf(kbuf + ret, count - ret, "\n");
+	if (ret >= count)
+		goto err;
+
+	if (copy_to_user(buf, kbuf, ret))
+		ret = -EFAULT;
+
+	kfree(kbuf);
+	return ret;
+
+err:
+	kfree(kbuf);
+	return -ENOMEM;
+}
+
+static ssize_t read_swap_page_owner(struct file *file, char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	swp_entry_t entry = { .val = *ppos };
+	void *spo;
+	XA_STATE(xa_state, &swap_page_owners, entry.val);
+
+	if (!static_branch_unlikely(&swap_page_owner_inited))
+		return -EINVAL;
+
+	xa_lock(&swap_page_owners);
+	xas_for_each(&xa_state, spo, ULONG_MAX) {
+
+		/* Resume after current index. */
+		entry.val = xa_state.xa_index;
+		*ppos = entry.val + 1;
+
+		xa_unlock(&swap_page_owners);
+		return print_swap_page_owner(buf, count, entry,
+					     (struct swap_page_owner *) spo);
+	}
+	xa_unlock(&swap_page_owners);
+
+	return 0;
+}
+
+static const struct file_operations swap_page_owner_fops = {
+	.read		= read_swap_page_owner,
+	.llseek		= lseek_page_owner,
+};
+#endif
+
 static void *stack_start(struct seq_file *m, loff_t *ppos)
 {
 	struct stack *stack;
@@ -1247,6 +1318,10 @@ static int __init pageowner_init(void)
 			    &page_owner_stack_fops);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
 			    &page_owner_threshold_fops);
+#ifdef CONFIG_SWAP_PAGE_OWNER
+	debugfs_create_file("swap_page_owner", 0400, NULL, NULL,
+			    &swap_page_owner_fops);
+#endif
 	return 0;
 }
 late_initcall(pageowner_init)
-- 
2.51.0


