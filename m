Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D80FAC531D0
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 02:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7301E6B007B; Sat, 25 Jul 2026 22:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7088F6B0088; Sat, 25 Jul 2026 22:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647696B008A; Sat, 25 Jul 2026 22:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 370AB6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 22:32:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 805C7C03A3
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 02:31:59 +0000 (UTC)
X-FDA: 85029352758.21.6E5FD11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7C70840009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 02:31:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0S7xinMg;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785033117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6+XXUR5lBU9DHLuveWr4u6xO1b7eTisGaSLWHvXZb0=;
	b=pOH0/v3lJ8MpZFlSv1e3uoF1s8vFJk0KX1XA45pj/rJyHBBL/e/6Uu27CLegtLR2BVNtv1
	jqNkJxNM6FjUW4h++7Ib+mOaR6QRgWMTvPxQJpel67TTdDrzbisglkLNySaS6xps5lDlk/
	zntLbb8oW3h4tQlZP7JuxmKUTmfHCSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785033117;
	b=5NPNic6C7fafSS3ZdyNS9z48zxot+m4cDbw/FGp+o206C5QnXuhaVE+9C7XjsBOVttO7OX
	gaYlRYSLRUO4+H0OVra2VuM21cSdqJStKPG//PytSfY2T4Oq+JAIl8gMSxMnRSd4NSui4f
	Op9U5ta9HdySV2J4xBN2eibeT/H3XD0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0S7xinMg;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E356B60008;
	Sun, 26 Jul 2026 02:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A72E1F000E9;
	Sun, 26 Jul 2026 02:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785033116;
	bh=f6+XXUR5lBU9DHLuveWr4u6xO1b7eTisGaSLWHvXZb0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0S7xinMgsoPuxz/eqN+Uerpodx94PS6f9Ur0SDwyuEqY3yqoiypP6tFjfFw/UlNrY
	 XtM6H+Q+RmeH3ufA6fzqpdSwYc2y30rS4+gbyhwFC/hxMxVP+lkDyJdT09B05cnW+h
	 VxWrEwxlSv2B8cQJwxkkBVdoL0lwbF3G0fZCxY8k=
Date: Sat, 25 Jul 2026 19:31:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Stanislav Kinsburskii
 <skinsburskii@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487
Message-Id: <20260725193155.0e03a382d76a99485ca05cdd@linux-foundation.org>
In-Reply-To: <202607251512.KMStVfrY-lkp@intel.com>
References: <202607251512.KMStVfrY-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C70840009
X-Stat-Signature: wad6hzojigg9zzn33bt4jc5614uwsrhi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785033117-852426
X-HE-Meta: U2FsdGVkX19mLWdddFF8Jk62+og0WMC+4/Pxgj2VLMNzLZ8kgccrB74ASHLbo4rXMoivMBAqh5vGrTjPkwjV5BupnvthIEo6O//2Qdj1uKHFt2eKGz9f4S+ZFx5Ky8ufyINm92XZFD/05dDO4bzzWGPK+RsMUw1O67jsx18BNJKmuCnQLu7iigvYkh4OPFaIWSMMoRsyx+2xasFAsFMh54uk8lPG/+EUyRnWnvZacWi+uPCGLcBUwJkKa7fGPZP6E7jClC02vEnEit8rUDI1znSwJT+mRAen1FQyXnFYZ8SUOzwIHq25EBj80IvHyUb9EX0DXnlsRb7Ffc7NeyjVcamWsqhzU/k0HQ8xNSiKVEgP+E9cW41LWAuUTNTrqaHEydILzRuaryyA5FKv/trhbnhM5WUP7JG6kPXlWPPXjdbiEMf1jusYf9nwHOHKR7L2SP4cyzDA4ZvBmct1YODBPWZFiLAG8BV/PbA5NohmXzpoc6MZQjffzM06dnzZdm5/r5joZFvzXh58CSQjIpTAXLfPGNyxFB3KNEod1lacim1f4ItCO6W9IeXglSLGp6zGpmEYbNz9pXxY7VpUL+wF1xdzDH/61lIVyIi/OViGbvTR0IziVsdWNpj8lKhW8cRh1XEDZQgpKgOnreBrqbx0LZvpqU3sUIXoY7wS9THtmOjk0s2Ld/OrGsGewhC9BcITZOe3AWFD3xGqOOC18vM2BzegJLvAuzhtOC6vBa+Qn/1RzSOoesWeHHR8bM3Ta6xQGaNyZDs2xmecKglZPj1bufuQy2sK1AEadIUfzpaxvecvF7v+9CWOGdbMplm4P1Bo7+7g/2L6fhclI2lko7dh9BQ/8hCeXc/lp1TevGs45oB3rxqSodj7X46xe7C1nu4dTx1o6ksmvAwNdZSX6Gq5mAF4EBbfCU1lS8QgRUXWGqHCwLhErFfcJYHwprtdyFjMNWn3j8WngcBtHMd2gPy
 tl7N2Lkj
 DuEA64OzP8nd2YVR9kZdUrxr9bwoXrneVJRJuqzgdnnNIj+lyOPLgmwho/lKrP8QoBWQyEfFVI6pBXrK0lHJC22M162IxYq30XonMXM7EeySFwcZjBiG7NmPBVtRT9M8M9sFkkf7zrck0sY0AdADkmuGl5RxhN9EJoo7NusZb1CNgYS4gjLH92nvqtLJT2k8VXYbFjhKDSq3nYzyqUJwRnT6MH/NEM3VNPP0AxNYsPgtn14ccDDibBd2NJTO9fx2iQ53wt9rtkp7Eq32FvZa0VXj7PSjmg5aZJd4z3b/s0AsE6fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Thanks.  A few head-scratchers for hmm people, please:

On Sat, 25 Jul 2026 15:11:38 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Unverified Warning (likely false positive, kindly check if interested):
> 
>     https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
>     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> 
>     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
>     mm/vmpressure.c:123 vmpressure() warn: check likely/unlikely parentheses
> 
> Warning ids grouped by kconfigs:
> 
> recent_errors
> |-- microblaze-randconfig-r072-20260725
> |   `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

With this microblaze config on current mainline I hit

mm/hmm.c:804:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
  804 |                         mmu_interval_read_begin(range->notifier);

And after adding the hmm changes from mm-unstable I also hit

mm/hmm.c:805:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
  805 |                         mmu_interval_read_begin(range->notifier);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
      |                         mmu_interval_check_retry

Both of which can be fixed with

--- a/include/linux/mmu_notifier.h~a
+++ a/include/linux/mmu_notifier.h
@@ -576,6 +576,19 @@ static inline void _mmu_notifier_range_i
 	_mmu_notifier_range_init(range, start, end)
 
 static inline bool
+mmu_interval_check_retry(struct mmu_interval_notifier *interval_sub,
+			 unsigned long seq)
+{
+	return true;
+}
+
+static inline unsigned long
+mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
+{
+	return 0;
+}
+
+static inline bool
 mmu_notifier_range_blockable(const struct mmu_notifier_range *range)
 {
 	return true;

But I do wonder whether we should be compiling hmm at all if
CONFIG_MMU_NOTIFIER=n?


And your hmm_do_fault() warning seems legit:

	if (hmm_vma_walk->locked)
		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;

...
			*hmm_vma_walk->locked = false;

and the blame seems to lie with Stanislav's "mm/hmm: add
hmm_range_fault_unlocked_timeout() for mmap lock-drop support".



