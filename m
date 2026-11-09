Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E89E606D808
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LsCCK+Ye
Received: by kanga.kvack.org (Postfix)
	id 5977F6B05B9; Mon,  9 Nov 2026 05:35:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EDB6B05BA; Mon,  9 Nov 2026 05:35:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC496B05BB; Mon,  9 Nov 2026 05:35:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24D196B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:35:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A426C1A0625
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:35:07 +0000 (UTC)
X-FDA: 85415223054.23.CFA901F
Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	by imf27.hostedemail.com (Postfix) with ESMTP id 95FA140006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:35:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LsCCK+Ye;
	spf=pass (imf27.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794220506;
	b=1BZ0a15G2GGmMIeUMa1XnzQKnGKIpIq4L1m7jxjd/aRoAnFUXFZSdvDlpEgTVcmQXrXVU+
	TJedTtk6LPLDZdy7H9oLksnpjWEjF6lVqw5PyVGWvN9lg+VlcnSBzLVYZJlZN4sGUIIioi
	hKkYJcYcQCSK6OweGLbKQSsYUxYFIcc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LsCCK+Ye;
	spf=pass (imf27.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794220506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DsGtn4KFPLGuAk1q5B2pREh+sGKflm9tEnT1EFIbPjA=;
	b=xZbwV1tzwxmWR9x3QsIcaj7fFTOPvtaAEUk5Ka+s+3Sao6wTJ8gyumZYMqrQ+4V5TtUZBN
	Th+ccHWqT8k9Ykv7q0fNhdCy2ln1qg6K5Myw7LSNMGCm+I4XW6EUsjItGI1L70Zmwdt/kT
	QJw0LAybn7IzrAHz6O4VgEszu81oSNk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bCU29ep+uwz6VaIaH7VVMUYbRv38UnA4EsVYxT/9pjs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794220504; v=1; x=1794825304;
 b=LsCCK+YeiL7Ml+HbL21XCdTjqFj5x9+iCSUBFlkzlrluAahWpau7tAgMULaETmvvtrlZlbvf
 WCsveD3qUjSdIZ0yTKnteI14Zbj66IspTGnOG3N9agJKcXJK4NFahMp01PkGqGBxHEKywDuRXF5
 yFHshJQh1OBTwaXxbP4jUfxk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 29236d32ff73c5e8;
	Mon, 09 Nov 2026 10:35:04 +0000
X-Mizu-Trace-ID: 29236d32ff73c5e8
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Mon, 09 Nov 2026 05:34:13 -0500
Subject: [PATCH v2 3/3] mm/filemap: extend VM_SEQ_READ readahead below
 descending faults
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-bug-mm-mmap-readahead-descending-v2-3-abac52890a9c@linux.dev>
References: <20261109-bug-mm-mmap-readahead-descending-v2-0-abac52890a9c@linux.dev>
In-Reply-To: <20261109-bug-mm-mmap-readahead-descending-v2-0-abac52890a9c@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Vishal Moola <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0
X-Stat-Signature: xrhguxo1gjjgidssc8cd6ig8d9gsdy9w
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95FA140006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794220505-463494
X-HE-Meta: U2FsdGVkX1/qArdayGk70mHErFCOMpxiVXn/CKXokGJf5V/0SNWLaJxX0si1vdUN3OUacGSul7UW5FxXM5ZOAXVAFvRzEvZ/P0OyiFxZJ031jo4flLbZUuxDG5sMaezNVTU21OtPCK7Y7KivlEzr35yIQg/wz8+SPvul3ilHpLjq0+kg44T3Wh/DUJv9P/o2JzuYqrQnSKRLH7tmVy4s6/5sB3RSBn2KYSHwt+mR1G5uIN1lH4bsula6yIqzkas0HsfLNnZ1VpIu125D6DEd+lX6MWwUbgYXB5rVTYs9uRRINvPg0x/EMVTnP11La+fluNL3uJi+XYvPO371PPxNLX/qIWlBKQvVtkD+meZhUvlKB+G780AH0jfta8Bm7rP0zxM7TrhNPUjWT2QW58eZOcJkkZ5J9W6m9IPXC3PF4ehJzHJDwKSL6Q5msqTModtkk5V1FD9btACa6+OD/yMQ1qSAZ9nw+XcHwN5sL+lXKN8X8HaovOwJhAvq770JNmD2mRGRUmuVUosfnanr7diheQt9zQ3j8XPcJ4aIdJ3NSqgBfw63y1xHP8F6wJYqmmVbqipwB9vW0P866uZS1vmW7QiVKGggwjy0YhgdyakbqOHrpScmSMbul01CMaQ2vLn8kC937TakIqc63xKtAWjI39UaEQN23f819xYnsy2y1FJjrTrQraXPWJt/YDUKBTDSMD0QNYE41zaNzu4xHy+xKfP842bCem5XuuFHq/pPXHAnTpnIxBD5AFFVzGWvrdDaw5ywgbWzU3MnPhFYXKjQ/2XOsj5McshnGaaGtlzls8GzERBXhMqDf8Z+IOqQKkcp2iv2niaUTrJyQoSPHSKoUSw+ETVzkRxVRlvQ3LP4SUWY8Hl4esOL/MHDwwqKGGdz9Ba9pvV9guFTG8DD+ziqCsf5D6JOXn0jkKsPLCEh13DZq5whVmtbSnM9XJXLX5JeVpse3EUEwlpgGNSieBb
 VW3U3v/9
 6UGZC5Qwtbr5QtTiztJ2P2ALckjaHstsiWO8sUSpcrApIuDLRPmRa2hcXB7SoNWKl05PbVWWqpuDQmvrqyYRQ4WZAB3p4X6GNT2IRAF4JXTaOE4JSPIfx0GNZHNNesatEi+tJgHCE3ibO/VWnqiO0XZMMUuenZ8R4G6cpcD0+kE6uJCPe6u0cJm8Wf+xQROf9Qf5Ws0e5I86YcVWIlaji0ON4aIDmnpCDo0gE5gE+IMF2mGnR2eomtJGv/oB1v+sNdeQ6YCSL8SE/+iTuP0428tEz4zNW9+quvmLvvQ7tRZubEggXCZyC/B9Cf7Ct1Q5GcXrQcdCibeTJh6B69IxRfRGk3AN4nritaZOkhx7zgDO8ioI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a VM_SEQ_READ mapping, a synchronous fault reads ahead from the
faulting page towards higher offsets through page_cache_sync_ra().

A reader that moves towards lower offsets, such as memmove() copying
backwards out of a mapping, finds the pages above the fault already
cached, so each of its faults reads a single new page.
page_cache_sync_ra() also looks for a stream only below the fault and
takes it for a small random read.

When the page above the fault is already cached, read the window of
ra_pages that ends at the faulting page instead, without a readahead
mark. Reading one byte from each page of a 2 GiB file, last page first,
in a MADV_SEQUENTIAL mapping with a cold page cache, read_ahead_kb 8192:

                   before       after
  time            50.92 s      0.96 s
  major faults     524289         258

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 mm/filemap.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index e445279cc561f..be587f8d0e8e6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3405,7 +3405,19 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 
 		if (vm_flags & VM_SEQ_READ) {
 			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-			page_cache_sync_ra(&ractl, ra->ra_pages);
+			if (!filemap_descending(mapping, vmf->pgoff, 1)) {
+				page_cache_sync_ra(&ractl, ra->ra_pages);
+				return fpin;
+			}
+			/* Read the window that ends at the faulting page */
+			ra->start = vmf->pgoff + 1 -
+				    min_t(unsigned long, ra->ra_pages,
+					  vmf->pgoff + 1);
+			ra->size = vmf->pgoff + 1 - ra->start;
+			ra->async_size = 0;
+			ra->order = 0;
+			ractl._index = ra->start;
+			page_cache_ra_order(&ractl, ra);
 			return fpin;
 		}
 	}

-- 
2.43.0


