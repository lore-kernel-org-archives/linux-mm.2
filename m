Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2971CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 23:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB5B8E0006; Fri, 12 Sep 2025 19:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1E68E0002; Fri, 12 Sep 2025 19:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30BC8E0006; Fri, 12 Sep 2025 19:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E24D98E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 19:06:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85D251DFAF9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:06:58 +0000 (UTC)
X-FDA: 83882135316.15.9C1CF41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED0ABC000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:06:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fQ2Eoclz;
	spf=pass (imf28.hostedemail.com: domain of deller@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=deller@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757718417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ml+EptLhjzVYi3CDkzUoNMp3ZkiB6hwp9fNLxf14CJg=;
	b=e9GFxJYD1u7tCUK3KfXm8aF5mfmCR4WWO17ImW1hW5Y9KjjLS+qD0ANNG3+ZdKJO28941U
	DiQxa7pLBFCMruE6BeefjKnSG+5ifKSaBBqX47w3DvK/qLUheK6YdnE0Ergbd4hvG5Yr3f
	ZzsOe4DJ+Y+30EpBaocRQuB5kucUwBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757718417; a=rsa-sha256;
	cv=none;
	b=TrElficwYmQtz/L0CYqzbmhZUXCQH9wBeYUXPOwtbCn3Psvs9LHSA6wAIcOepeR8twtEzR
	fo9D2ExueorrVqAv9pAYY7L3b5YsmZuwp6m7ymFt+KLUmzc3PqRKY+B3k7N3NOO/4dARVn
	xiD2Km4i5inMSrVcF5bXQyiV2mCdTVU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fQ2Eoclz;
	spf=pass (imf28.hostedemail.com: domain of deller@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=deller@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A9DD43B1B;
	Fri, 12 Sep 2025 23:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC7AC4CEF1;
	Fri, 12 Sep 2025 23:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757718415;
	bh=F3pBgbTa0bRUXPXmhmfpIhfIO30jxsVYPUgnnhy9Y18=;
	h=Date:From:To:Subject:From;
	b=fQ2Eoclz/+9dBGme9L3HXsCXZRZ8IfcA3TxKv8pbT8dWjxZOB3qIFtkaRkIXuMBmf
	 FH31OuWoycWblj5KrZS4ZXFJcyOlVfCpHecUJ87B9N+d5ZpP+a5Z4mcFHEpniNRDCA
	 V2Nk2UyZWgvcnHqcLoHU59CLZtnY42qkxMVoQ1zZozppVimX1aVUJAZ2V4rghglur8
	 +UwPapXLx2NUk2Rg8e5ZZNQWvQyj7tI+duK5MOHE4+y7c5xx6PKxe8LehQJ+YGtccA
	 fvHQFjQQ+7/N4lyd4euHA0WMpRbPVgVkvpOZEIcNIHQbfxLgarBJpMY5MSELkAk8QD
	 MoDy4ZDW8cdEg==
Date: Sat, 13 Sep 2025 01:06:51 +0200
From: Helge Deller <deller@kernel.org>
To: David Hildenbrand <david@redhat.com>,
	Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Memory Management List <linux-mm@kvack.org>,
	netdev@vger.kernel.org,
	Linux parisc List <linux-parisc@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
Message-ID: <aMSni79s6vCCVCFO@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED0ABC000C
X-Stat-Signature: cgekwn9oatcec97siqyyfkwdeqaa5gkf
X-Rspam-User: 
X-HE-Tag: 1757718416-916458
X-HE-Meta: U2FsdGVkX19tg4AqtYrXbwvy/NCAIrYLbppLvYeihrTZPWZ1aKpxhPh5wFBvxH9cOu6dpK318BcNWPsunjzolvY/lj/BVnDEUf0rVjsdPllxN2AJr8LV6MKUMrfV2MOxZ4PPySpKTVyaguuiZanW8jN3OcBdxmaUlTJQutMFO2B9EQ1+lUPHyV1P8+1Z/MDAEV2PIaX6AEgL8zJwnArIh51/upSmkh6DL6p2GoDPvEomnoIR/xQrT2XE6p/onIaTM49nhjQNq/QrfSf+F2yT7JcRY32HBRkymiYw2TW8lOEE/iQ/SthLHs6ii81hj6x/c3oIzwssdnk6d6aSuCS9oXQmGT3PuTSdgltzHwa7/majIgaQD1W+sjPDkVAblVQafiwJSgjw5Ev/3/jxqXlVQKjk72vpkarQNTHofo73csR/gMZFGnHfR/+L3M44ryh1R7yUL5eWVznDTThvgZspceH+SPfZS9XA+bgoC5Gz8spxTAYbmkOxKmlt0L+/PSSCa89jYmzQxm2BPlbuEupgy8ZWO+bqR2SMAIsU2HRB/RrK8h4mRlogNaa7Vs5zE0JFkDsVfLyN8jf5TppktEhJ3ZvhmOxgdRMnH/qQDRLFJrzdqO8FKvWm+khvODUZKrE+2tKE+B1qZ31tXxBuNFHQRRV+NbnkdhaoccWsfQigT5ud8o47VSa5ohrC/vX/1UibU0Qh1+WqG3BJHKyMJWxa8HhSYAL6fo6lwGHdvjbu2udA9VUxEuT8dumJhdBxFTaYDVQK3bJanLGzOGUzvca29TLYiqAwAlMqnpyg5kOPiaSmTT0gjRwlWMzflMKgCttZB5haEAmtMZAmh/Cw3cpZZRgpP+6uxSIDKQP7ZSkMTW3WSr+2NKFnlp9YLQqcgw0I/QlNeyshpMwGeTgreDa5egJF0RjWjMRlvNMsgfS4UF80+Dsfvj+RLyYODlZpsOkM6Ci0teCfogGIgHW6XIb
 PqoZMVKU
 Q28A3B7RYn72DwvulXbScfo+YkWwM0RMHZIWJ5QrvlUfBVHeBeaam+5nP+qAuUx/Owc7UrldnwEdHqHkp9g02mzxpqOuHRNZaGfckUAKl84BaTDP7GbSaZlJH+a786PhwgWTcutc7qzx316qa0HgP5jc1AgnYjxeUIoviQ6Ui87AjCCtQo2VnOneZvdJAw7Z7X9Ff4RCRe/CW/nqH3sXpJqR9FHN4ri9xbS0VFN1sVUbmzWq5fLdNt/bPRGnyoe844wamHa+4ts3FVqWwFpsfNsh64P0orj6h2G0Jd9ySzHPm10jn1miBECU5IEObRgoGNekqdP98nG0aR9uBHdqgujeyMpfELrCP6McUzn40bYcUrWpXNdIw3zFuQiiRLYCsjsgj8dsRsTty4U71Q1ZWMRkBoyxnvKVncHc8u/pkxZYByRNq4w57bcY1suUSw8wfxHd24hurlV2J9N/NUMbnsQDgFtFsrcUzGHWJrAFvFfk21B+lTT5AHNNhVdghEKvskV048u3rdFlOAfam7o/mWMU/A6/yXlp/HgFqpwd06G39xn8cqTthsJwkpaUcPTnrp/YI+ccXs+KrfisPzGeOu3XuiiHNRFNXCeq/BVhutX2U2sdkmJrFIHLFdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when
destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000007c on
32-bit platforms.

The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify page pool
pages, but the remaining bits are not sufficient to unambiguously identify
such pages any longer.

So page_pool_page_is_pp() now sometimes wrongly reports pages as page pool
pages and as such triggers a kernel BUG as it believes it found a page pool
leak.

There are patches upcoming where page_pool_page_is_pp() will not depend on
PP_MAGIC_MASK and instead use page flags to identify page pool pages. Until
those patches are merged, the easiest temporary fix is to disable the check
on 32-bit platforms.

Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Cc: netdev@vger.kernel.org
Cc: Linux parisc List <linux-parisc@vger.kernel.org>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Helge Deller <deller@gmx.de>
Link: https://www.spinics.net/lists/kernel/msg5849623.html
Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..f3822ae70a81 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4190,7 +4190,7 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
  */
 #define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
 
-#ifdef CONFIG_PAGE_POOL
+#if defined(CONFIG_PAGE_POOL) && defined(CONFIG_64BIT)
 static inline bool page_pool_page_is_pp(const struct page *page)
 {
 	treturn (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;

----- End forwarded message -----

