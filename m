Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85DDCA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 22:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C00F8E0006; Tue,  2 Sep 2025 18:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197828E0001; Tue,  2 Sep 2025 18:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D50D8E0006; Tue,  2 Sep 2025 18:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EDD438E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 18:40:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98E7C1A03E8
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:40:47 +0000 (UTC)
X-FDA: 83845781334.20.CADB310
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BA1D418000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:40:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F4WV3TXS;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756852846; a=rsa-sha256;
	cv=none;
	b=Y4O7/iWDaDgtNT/dBYlc/buoUZTfvqfv9H4FMnvUAklsLd+NlGCxiCR2QDkUR0+6WMFb5k
	k8ksoXmYAN8q+Urr2RaH5YUhOWPUsw5gnAEZEv78MMa7AXzkm4dhU+hy0Br8yWnRXfGkd1
	KIdFFDixkxEw/4jfRkeLqiA/zQZy3Vk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F4WV3TXS;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756852846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLIzVFT/uyPXgr1OWQXgpxPUaaQ301GIaV5BIOr4BlY=;
	b=nwrcFPX9Yb/2EUsE4Ot1/JvFP5kuG4RqT4//PCKPu3kJqycl+LX/CWVIv3UDHjOTTE4POz
	NGg6W0D9MrZRPR4cEcyd9BfJZ3j9Ajkua0zIu+wub5ir7WAJVh+naSya8G0IP88IKVG7b0
	/SIWn+z5IZQVKHUiwLmCJ6xBBiIMBzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B33C43566;
	Tue,  2 Sep 2025 22:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF14C4CEED;
	Tue,  2 Sep 2025 22:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756852844;
	bh=aGIRsV9W7yRHkxZ5RFmGNXNNlqvBFtD/ngQ0qVv3OSg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=F4WV3TXSoWes6xFTKpw/mxjIT3/thiuBh6crUHxk7GOnw8fsvmxLTgHhU2tQKe8Fg
	 hd7vZJvdW6CFunsHRzmbsuA/CzqDeB2VdZECvfRlMKwfHOg55oLsXXT4Y/Hm3m0NqL
	 F5M69AfoRzwvYPpub50mQ0gWSm53We47+qwdvREA=
Date: Tue, 2 Sep 2025 15:40:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: david@redhat.com, joannelkoong@gmail.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, m.szyprowski@samsung.com,
 mszeredi@redhat.com, willy@infradead.org, syzkaller-bugs@googlegroups.com,
 Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: fix lockdep issues in writeback handling
Message-Id: <20250902154043.7214448ff3a9cb68c8d231d5@linux-foundation.org>
In-Reply-To: <20250902095250.1319807-1-nogikh@google.com>
References: <345d49d2-5b6b-4307-824b-5167db737ad2@redhat.com>
	<20250902095250.1319807-1-nogikh@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA1D418000D
X-Stat-Signature: iuwcq1so6zrcy5we6si3y8dpjktxycgo
X-Rspam-User: 
X-HE-Tag: 1756852845-963797
X-HE-Meta: U2FsdGVkX18D3Q8eft+5Upa2e+MaAmycMspB4QpJcILw1zOY1ZDB+8NwvMqumAefBcho6SIGCFMXPKTgzNMjFJWQpcjVRGDY6h2bs9i760DOBdvbixHclI2Nm+Mvu/PVhQgDZ3JG3bhWL4ohTMZDBX2ES/giAoY0jzEI9qr3mKxYNJeZFbnsz70m2ZAjQtKQDr/jXwuMH2o1b4y3u8ECWcY5+VGk3V4120ArCfookXKAbBt06dOqzXceTl0JF/h7L3FE7MfNG+eCRcNefYa4rtfj4C44PozaBNKpdzSuOPV6UFRgeIPmteUZrcafttYJ+QvyBYxE1/ucPriguQtD1v/Qwl6LMEg8/OrR7plgNJQfkfFsS9VElar49x6Y02+3MOy0YFDy2kvw0vGqQLKCfGsBsqnewaxIkVyOu+u6vDXLE76kCxI8HjkGHuAgEpwtIgihQZ+f72u0ksC2tqdva9zXt/G5EfosV02XBpI+Kkh7RXlJh6lXipaQegATgC8dfcXcsAMV63YvyB39R1IwVXclPxiSTFDqQs2bQUL+N5ti5+WJecjqqpy+9vojc7y+yjfV62A5D+CQ19kKt3ZNz2SlC1b3HD0wuY8EFo5CGaMw29FRVUk4OG23eOH2yXly+/FingXS/G5Vv2OEo2VIvpSKIxcOanRr48OfyhBXB4QCqp7U4AdMjiKU6iToLz3hE7gahlZwE9BEaH0xkvAROpsMOyy0SsXk5+azv2JGJNNy7FH0IsdV2ZT9S/z2zIXo2uiQwhd8LNATTGd0F24HC+AzHExkijAa7PN4jML8vkIHnh3mhWNkuLSNryCJaH+w4teJ0TnMmpYVWMoFPHoICiDwEX5IH12/quleiT9wx9xOXD8xzD/h1AdH8XP/GD7WTAci95677u6lL/I6dAVzqcVew+D5KZjtFrLRfrFmdid5+gsoy9qCLh5xq2hAfIgT41phreeFOaAj3yOwhEQ
 8BIwQ/TN
 cVvlPEXD/0FqG0T8D2Yg0m0N3F66mkBymI8In1nhKrK8S2GOpWwbS801hDhYnVfiqeCctbArl6BD2P6wGk5AukZ96qXbFyuKiQ0js8EXqUkot+E9Jf1bGCRlLesFdF3rFPpdm65PF26oSorG3O7wZZ2oXLh9djBFYc2tZRnrq4mqX96gHhjHGPBL+YaX73otbloPvQe9dniym7lRwbOawzjPDueGfbGBEOmy8y9V1YjkjmpkKOX/2YU+syjPQUw2jTya8zKykAwDtznu8VEDkD0LFKmFyZlJsews4SRxihZ2CFfZCxamCKqoz41P38uLg4GLPnH66Kc0T0UXTC56Q97VyLaJUzaLYYOQuUr9si7c6aaF2pLEyExXTTFYVgAA4OQvVQlxA/uj5vb55UB6YGYVGiv6U9r8+FFq4qS4JaMahm0UlfSnDhEfsbsCb/tYuz/rknFas5KydccO8ie4zjkbCAe1Is9uyNsO8/HOlge4yFTQ+rVpdcfVb6tIUI/86QcoR/AX0GILbJli+cqiff80rsw8OduOvY/66
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Sep 2025 11:52:50 +0200 Aleksandr Nogikh <nogikh@google.com> wrote:

> Hi,
> 
> When can the patch be expected to reach linux-next?
> Syzbot can't build/boot the tree for more than 12 days already :(

Please don't top-post - it messes things up so much.

There's nothing I can reasonably do about this - it's fixing an issue
that's coming in from Miklos's tree and perhaps he's offline.

Perhaps Stephen can directly add it to linux-next for a while?

From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH] mm: fix lockdep issues in writeback handling
Date: Tue, 26 Aug 2025 15:09:48 +0200
Sender: owner-linux-mm@kvack.org
X-Mailer: git-send-email 2.34.1

Commit 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT") removed
BDI_CAP_WRITEBACK_ACCT flag and refactored code that depend on it.
Unfortunately it also moved some variable intialization out of guarded
scope in writeback handling, what triggers a true lockdep warning. Fix
this by moving initialization to the proper place.

Fixes: 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 mm/page-writeback.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 99e80bdb3084..3887ac2e6475 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2984,7 +2984,7 @@ bool __folio_end_writeback(struct folio *folio)
 
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
-		struct bdi_writeback *wb = inode_to_wb(inode);
+		struct bdi_writeback *wb;
 		unsigned long flags;
 
 		xa_lock_irqsave(&mapping->i_pages, flags);
@@ -2992,6 +2992,7 @@ bool __folio_end_writeback(struct folio *folio)
 		__xa_clear_mark(&mapping->i_pages, folio_index(folio),
 					PAGECACHE_TAG_WRITEBACK);
 
+		wb = inode_to_wb(inode);
 		wb_stat_mod(wb, WB_WRITEBACK, -nr);
 		__wb_writeout_add(wb, nr);
 		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
@@ -3024,7 +3025,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 		struct inode *inode = mapping->host;
-		struct bdi_writeback *wb = inode_to_wb(inode);
+		struct bdi_writeback *wb;
 		unsigned long flags;
 		bool on_wblist;
 
@@ -3035,6 +3036,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 		on_wblist = mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
 
 		xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
+		wb = inode_to_wb(inode);
 		wb_stat_mod(wb, WB_WRITEBACK, nr);
 		if (!on_wblist) {
 			wb_inode_writeback_start(wb);
-- 
2.34.1



