Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B46AAD2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26396B033A; Mon, 19 Jan 2026 18:27:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD43D6B033D; Mon, 19 Jan 2026 18:27:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE09E6B033E; Mon, 19 Jan 2026 18:27:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAC9D6B033A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:27:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 516A258514
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:27:13 +0000 (UTC)
X-FDA: 84350301546.23.CAA6BF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7E4741C0006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:27:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xrBGHQue;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768865231; a=rsa-sha256;
	cv=none;
	b=OtrZO2Cqpvvgl/1Od75HRQa4G00UpU29pyjacF3rnLfQ67/U3RkRSEFuoYZ39S4Ty9MbCF
	W4D2klWvIQa7ujKwCQH4lUdl/BK9eiiTwWPXKTAT6ATxrdPiqa+NVny9oA5c6Z7yW4urJA
	ILiGcvtOIF62aAiVgFTk4TCgMgAwrtE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xrBGHQue;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768865231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSAlxfaOZZaZpPTPZXflnDLTIJcp6DGSu13bwZSbl6w=;
	b=H3sois8LjPLDB4lGhFr6NezqUN4+abTMHmNP895wFB22fRDqFcblaSOeNQqp2jL4CRdsK7
	yMlA6NJSLHf9JI4NzSO1PS4fthgOoCIxMA6Fr5+mCBPSETYahYpRBxKrn4DCmO1vXED+R3
	baXZWWmVpsLW48iwgVCHqqAmgRqxzGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E17C40DE8;
	Mon, 19 Jan 2026 23:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261DFC116C6;
	Mon, 19 Jan 2026 23:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768865230;
	bh=qA/8S2QM28lHfe8iWXS+dSTad4XAM1EUKu8s/MTOUFo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xrBGHQueZoDFvdTmOQPzEhyTnBkDlHnjYIq2aJDzDK8Pwpb4kNvE6OulLNIT2p6DQ
	 efJvqzcCQRWhmE4Pi9gqIp5GZ8/xrPAz4jvQUkI4vNLAmrXXEROBM1Ju2tCcPEk+CD
	 wf3hkXxUOTH0q5QPOaNvHpPmaNgx4zQZpaLafCIo=
Date: Mon, 19 Jan 2026 15:27:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Oscar Salvador <osalvador@suse.de>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas
 Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Jerrin Shaji George
 <jerrin.shaji-george@broadcom.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Zi Yan
 <ziy@nvidia.com>
Subject: Re: [PATCH v3 00/24] mm: balloon infrastructure cleanups
Message-Id: <20260119152708.0737b211a2167054cf6eb18c@linux-foundation.org>
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7E4741C0006
X-Rspamd-Server: rspam06
X-Stat-Signature: hbh38p89sbt5xpygydnu8hae94ue1n69
X-Rspam-User: 
X-HE-Tag: 1768865231-72914
X-HE-Meta: U2FsdGVkX18OAJOGBtxNa1HQWuhuqT63sg7WMLvz0DJvhZ67EjC35w82/9ms/H5OuQtNG3qDcB3x0yBn/ASJ7BmimrPJGY6ylJQ99ftnBhIVOPeghiBxNjRceetzXT6HuWV2NgA1eziBxgHcp4Ni1zf0fBrQNup/yk0mo705ke9Qx5kGoeYRYRWjrawhGsglATBs5waO0XJEH3Ahy7lbC0Vc3HTYIYQwqJ4hbVjJRuOB0hzMmBqxghAu/ogulYZd5CTYfEcOXKQ/fys6+gO0/L4Mkyt/6CHg2k9J0gYf88KK3Xfmib8g/lw+FaaQ/ZecOWw8qA7N8p045xN3s0STgMMhB5REO/NHxk5dOEYMEaHiyduNaqRbVPs3q1ngoVLyMjORtXZaiwLKYCJ9hiL5O+i8cJ3UyuQiNFVWRw6COhvRmvdyaqE5394cSgL+X1Gk+6cJICh78eHT/+jxNN0MrHChj9F0o/ZzLlOIqiOGyr9WmiaMa8sXinpIWWB1FNwTGlCcPDR/Bu0QceF+NdsrxGYSwD3P0YvhFdEIII+RZ/nmg1R1SQXcj8LGRst7Tn+9Z2vGX/dSR4xWadU+MamVK1OsQyKX+gMtyKDNgGtseSMltPXCIXd/XociZdktFFMnJVo+E7DOUIzzQDVwMDC6iF9U1sCen8qo1nw6pe0axDuPjdxJ7rkLKvNiDzuxnhI/LyMqoP/uy30iwHWRGx44QmcqVg7QrDrwbkAp5RPw8SmoyQCGOy1VyUGIwawV7LYv+aRLSRcAJZdamzRMeDWLBEKUZbLdlShFxdr8lj3eItiscNspMowCtorJGQGzy1uns5rEED4TrZ92XFHWKP1iEKMWvMWbpVuVanpyPXbJWwcMb1rYabUDlO95VLTNykWdxfM714zmyaE+5/mT/erwy2OqhsADUauvenLJZ7dwjkhpAjK0C6rC+pNKWoiEpuhU7DbXNDXsEI1FviTTRdS
 NF4ERKf4
 ius26z4EVJESW4kyHwNaUsbQDG0CF6Yi8oOxsm7LdMe0iasRj3Qp1T8PiRYGZJ4gpPC6jubBd6vkQToXFMFK1alkM/7VgBkZyszd3ShJe4Hr6gsqLTxBLz+rmTUsXPTwqlRIrRGXAM7oIINtKCDgM6ucmz/NlLpyeHHE7F69Ujh+gP0WaLF0TcDNa8aW7WfeWetvouK5TciGLzVDEijSgamzTonTLnLwQ7G0U3mjI/KJIDE8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 00:01:08 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> I started with wanting to remove the dependency of the balloon
> infrastructure on the page lock, but ended up performing various other
> cleanups, some of which I had on my todo list for years.
> 
> This series heavily cleans up and simplifies our balloon infrastructure,
> including our balloon page migration functionality.

Updated, thanks.

fwiw, below is how v3 altered mm.git:

--- a/include/linux/balloon.h~b
+++ a/include/linux/balloon.h
@@ -22,9 +22,9 @@
  *
  * As the page isolation scanning step a compaction thread does is a lockless
  * procedure (from a page standpoint), it might bring some racy situations while
- * performing balloon page compaction. In order to sort out these racy scenarios
- * and safely perform balloon's page compaction and migration we must, always,
- * ensure following these simple rules:
+ * performing balloon page migration. In order to sort out these racy scenarios
+ * and safely perform balloon's page migration we must, always, ensure following
+ * these simple rules:
  *
  *   i. Inflation/deflation must set/clear page->private under the
  *      balloon_pages_lock
@@ -47,8 +47,8 @@
  * Balloon device information descriptor.
  * This struct is used to allow the common balloon page migration interface
  * procedures to find the proper balloon device holding memory pages they'll
- * have to cope for page compaction / migration, as well as it serves the
- * balloon driver as a page book-keeper for its registered balloon devices.
+ * have to cope for page migration, as well as it serves the balloon driver as
+ * a page book-keeper for its registered balloon devices.
  */
 struct balloon_dev_info {
 	unsigned long isolated_pages;	/* # of isolated pages for migration */
--- a/mm/balloon.c~b
+++ a/mm/balloon.c
@@ -16,7 +16,7 @@
  */
 static DEFINE_SPINLOCK(balloon_pages_lock);
 
-static inline struct balloon_dev_info *balloon_page_device(struct page *page)
+static struct balloon_dev_info *balloon_page_device(struct page *page)
 {
 	return (struct balloon_dev_info *)page_private(page);
 }
@@ -29,7 +29,7 @@ static inline struct balloon_dev_info *b
  *
  * Caller must ensure the balloon_pages_lock is held.
  */
-static inline void balloon_page_insert(struct balloon_dev_info *balloon,
+static void balloon_page_insert(struct balloon_dev_info *balloon,
 				       struct page *page)
 {
 	lockdep_assert_held(&balloon_pages_lock);
@@ -48,7 +48,7 @@ static inline void balloon_page_insert(s
  *
  * Caller must ensure the balloon_pages_lock is held.
  */
-static inline void balloon_page_finalize(struct page *page)
+static void balloon_page_finalize(struct page *page)
 {
 	lockdep_assert_held(&balloon_pages_lock);
 	if (IS_ENABLED(CONFIG_BALLOON_MIGRATION))
@@ -262,7 +262,11 @@ static void balloon_page_putback(struct
 	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
 	unsigned long flags;
 
-	/* Isolated balloon pages cannot get deflated. */
+	/*
+	 * When we isolated the page, the page was still inflated in a balloon
+	 * device. As isolated balloon pages cannot get deflated, we still have
+	 * a balloon device here.
+	 */
 	if (WARN_ON_ONCE(!b_dev_info))
 		return;
 
@@ -279,18 +283,22 @@ static int balloon_page_migrate(struct p
 	unsigned long flags;
 	int rc;
 
-	/* Isolated balloon pages cannot get deflated. */
+	/*
+	 * When we isolated the page, the page was still inflated in a balloon
+	 * device. As isolated balloon pages cannot get deflated, we still have
+	 * a balloon device here.
+	 */
 	if (WARN_ON_ONCE(!b_dev_info))
 		return -EAGAIN;
 
 	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
-	switch (rc) {
-	case 0:
-		spin_lock_irqsave(&balloon_pages_lock, flags);
+	if (rc < 0 && rc != -ENOENT)
+		return rc;
 
+	spin_lock_irqsave(&balloon_pages_lock, flags);
+	if (!rc) {
 		/* Insert the new page into the balloon list. */
 		get_page(newpage);
-
 		balloon_page_insert(b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
 
@@ -303,18 +311,12 @@ static int balloon_page_migrate(struct p
 			adjust_managed_page_count(page, 1);
 			adjust_managed_page_count(newpage, -1);
 		}
-		break;
-	case -ENOENT:
-		spin_lock_irqsave(&balloon_pages_lock, flags);
-
+	} else {
 		/* Old page was deflated but new page not inflated. */
 		__count_vm_event(BALLOON_DEFLATE);
 
 		if (b_dev_info->adjust_managed_page_count)
 			adjust_managed_page_count(page, 1);
-		break;
-	default:
-		return rc;
 	}
 
 	b_dev_info->isolated_pages--;
_


