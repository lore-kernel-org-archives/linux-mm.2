Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA26D2ECF8
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E38A6B0327; Mon, 19 Jan 2026 18:03:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4976B0329; Mon, 19 Jan 2026 18:03:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE076B032A; Mon, 19 Jan 2026 18:03:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2D36B0327
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:03:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1551583F2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:35 +0000 (UTC)
X-FDA: 84350241990.02.0EFFF5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 42D3F14000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JOFQQSl3;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8d+2/D1teZCo60BpmpOBq7MFQaV2ftPntom0fj9RHA=;
	b=FWLsTULBtQbF2rOtvkzpXv3yk1TpRW7lK9v/SdM3n5ZKrJDj9SsDdfeHc6wCsUZSZlo+eb
	9Kp2p3GdRd7/DQggp+V3nKe471Q+C5fGRal7Ijp2B7qCuHVMAY7HSdLXPFDAOkkOCXw5GV
	G9lH4b78DhN9OT7xzV8hJdMSctx8gnI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JOFQQSl3;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863814; a=rsa-sha256;
	cv=none;
	b=nycOO+1Lek+UEOeg9TcEMct+O+CZlsklFP0RNayJUR2rfHrXofHHPfy25qQQtgbrwZEm+G
	78sIiAlAyLAXN4AxoA5vBmAzsTyOHFsiB9t+jIMlfvp8iT2vReTjJ7jJyKe+4H6TGDoWpu
	FC+cpaauhtdecwl8TdqfOXGHz/jOfNA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BEA5860151;
	Mon, 19 Jan 2026 23:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE3BC116C6;
	Mon, 19 Jan 2026 23:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863813;
	bh=93bCC0t6vSff2vK8TVOF8nE3nZ/IKYJWWQ5I2pcLHSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOFQQSl3AQjJzyLdOYrRwc0dbiFxoJf/oza6XFRsomdnnGo9O/OX5gzccdwhSVAzd
	 eUUGHNU9pBbhGaBYhz2UG4QleWsuFA3IfyZYp0y+Pogp9exSIRdeujhZTKkfU4uTQp
	 wXYzgkMwBOWrX0vUSyhU35NIc97JkVBhLG+862uizkAT4HLinjE2jSbCewl/b5RZAT
	 ZekWMFOYRgBb/iN0UioxgVJC8SV5NUVf7KktwPqhiTpLShfkv98cBCzBgcYFo3gFH1
	 5alKNgx5IzaY2+JIomSSnEU1ASOeg+eBrlVyrnfV0w/vnhLfhzhnh2LoTMpUr28Dcg
	 RqL1z5c7xZa0w==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 16/24] mm/balloon_compaction: assert that the balloon_pages_lock is held
Date: Tue, 20 Jan 2026 00:01:24 +0100
Message-ID: <20260119230133.3551867-17-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: i98jhuuqzw8up1qicnwcnguhxfufks7p
X-Rspamd-Queue-Id: 42D3F14000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768863814-19781
X-HE-Meta: U2FsdGVkX19hBM06l0T79rx23/vPA0sWUJ6hDVpf536UD6vT/hqTb5c8A+wFOfRHC6srX3by35C/sz5Glu5Ifj9W9CYB7wdI66/8lIH8fdpCHHdasoSvKSa+HB6bnuD4y4T/Y4nDPEuuLopcWTbudWyXlhf8io/DacFhctKk0ypO3SwraWvc4O40MZ7YAjwNex0KvlZznbPB6eVgnG/eifNPpnJHGlzgVllhE8uIg4fu7IZ64qzy9t+1gmzkae4EelsOFi6HLN34S7+5Q0CyLtpzm3R6hCgePXhjzJwG4NS1lLV0LYhTvACWmbDZBH/MZ199YCoJpqJIevxMeqkoluIkPO8eYhnWEwARp0O67GlDJT6BSpXfjVaGNoVLWW3Zlf28enn1HQu3cFJPFNOEICtSjwuEm4wI/7BYgm6brZUGNoC4cRT3uvCDPqAlLDwNPdv/XqjNfc3g2e4WD/zbecsnjjF7/V3eIN/22J6nmj+zw6Bd7V/ehuqz6V8Rj6IHag/h6SvE77I44DKulrqeTQBO6YFTWNGBYky0vikH/cfMk0//tHc01o67F0fWNmerAUmhHe6ptlBzmSMt5ZSr2Mu32U3S/DefYvKOuIfDMqlaC2rYVHATjEvy8SlMscNykidoDUHDPNazVP007Sg+mSwxakblwJABJaH0SxqLlz/Uq/c/lM3MAzsQ1O44wuSild1d+EzjxkIMP+YW1w+8uB2+9uKd3HjZBlvGqTwIZe3C4TrVuA5c997KKUfAeWCqzOIFkhQetfIleXKA1qsLG/kC2Zu9/DBKhawDWBKt/x0KfXRZrpN1ZxJAShk05MS0D3Ch9Q5MaA8DmZX4/iW67QPFnuEqMfWI5hYYmaIw9oSh76USlDlMiUiDx39HTxvYMQ03nea/Fjsc3HOqxI+7PxKVVRIF6CetD4PpcQqiZI1T85mYhPQ+5waQhnMe3H+A2BdplNFJfQB92Ih4LeY
 dsoTLctG
 14BXD9v2uzxrfvjfV8BrnXTMsyr2tYc/0nqRP0nGFInw9wl67af+yATzJTw/Ra9m+/u1BvKhlvUxCidALIyt+S44cynFfYjrLEOvoyiEk2ZoenoRGXhKCFQ7qCwybEPwqaZjvamX/vncEGlHWsvuYbdPk6MLkZ0YDa6DYBZ9cXQA2Ci4xVhcxoq3dD3EWiXu0I5zeplDH5hf8oPCSxTEZowQMX2QB3GdGWqLWTkigdJ129okyJvFubtUIkvEJp1Onz6IPBiU7jUvNRxMGZ6iPjy1myS18fyzSdmBzzVEzCHKKFYN/9iQOqYzA9NCGLIn6+51/Nc24ebLDhG0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's add some sanity checks for holding the balloon_pages_lock when
we're effectively inflating/deflating a page.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/balloon_compaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index e0a4b481c3eda..bb2e5ec2cab36 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -33,6 +33,7 @@ static struct balloon_dev_info *balloon_page_device(struct page *page)
 static void balloon_page_insert(struct balloon_dev_info *balloon,
 				       struct page *page)
 {
+	lockdep_assert_held(&balloon_pages_lock);
 	__SetPageOffline(page);
 	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
 		SetPageMovableOps(page);
@@ -50,6 +51,7 @@ static void balloon_page_insert(struct balloon_dev_info *balloon,
  */
 static void balloon_page_finalize(struct page *page)
 {
+	lockdep_assert_held(&balloon_pages_lock);
 	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
 		set_page_private(page, 0);
 	/* PageOffline is sticky until the page is freed to the buddy. */
-- 
2.52.0


