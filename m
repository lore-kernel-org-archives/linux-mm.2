Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D8C2FAD3F0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0E96B0005; Wed, 22 Apr 2026 22:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71E96B008A; Wed, 22 Apr 2026 22:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61836B008C; Wed, 22 Apr 2026 22:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93E046B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:43:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 235C040251
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:43:44 +0000 (UTC)
X-FDA: 84688275168.01.8CFDED4
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf19.hostedemail.com (Postfix) with ESMTP id 588931A0015
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:43:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dbVPz/70";
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776912222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMukq5Ux3ezv5Tyfl0FoaOXQcgnvMJcY/OsebFof9qE=;
	b=aoMSql2gC+Jhq7OOZ9lB/TB29v0/k0LZTYGF5DzM9Anj4l/bksvDe1XnWmY3UNGAQomvJ3
	69iW3xReYciTgPAoUAa5cW1wOMMWMlyVyT503j6mCeAlW3N9okdcFbUJXVU+YEfiZXCvNj
	KzZ97+aZhpIjpoCHY0JyU5wCvNhI6qc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dbVPz/70";
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776912222; a=rsa-sha256;
	cv=none;
	b=x2WpvfaHHC7asRpvNU2GQqc3wr4BohatVL1DHJQjItALn29WBw49iDTuAAAsc2sT78LpKk
	+OOxrRA1ut4ikIsE4bbitY4zdkgu7mDwXsjdZ47XwT+hBjcUTIJ5Ghxez6uyt5JDYs/PPP
	jJw5f6RuPwz/KhhIlivkYnDYfKEONFk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776912219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMukq5Ux3ezv5Tyfl0FoaOXQcgnvMJcY/OsebFof9qE=;
	b=dbVPz/70tYHnFMXxFY25JlFErOfD2J4+flnFzZWIC+GFQLAapotxsFxlAWVXDzN/3tqSgp
	7ZkBqd9Q4CRT3BAfi8roSgJ3+PwfRM3RTMma7KOb7LXwjYwl89WkYLG6UjTE0BMSSNEtUh
	o25vpDGVCfCldSri1nd6fxpGOgDUlW8=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v3 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu, 23 Apr 2026 10:43:24 +0800
Message-Id: <20260423024324.51588-1-lance.yang@linux.dev>
In-Reply-To: <20260418024429.4055056-2-ziy@nvidia.com>
References: <20260418024429.4055056-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 588931A0015
X-Stat-Signature: b1ec5qomxz9nunzej3huxzyf1mfuhyne
X-Rspam-User: 
X-HE-Tag: 1776912222-698035
X-HE-Meta: U2FsdGVkX180tIUTbBTaMq06rNsmCWtclHR4r9ic1RmrXzu+gI4KUWyrhu0Tpw5H3gnOrDixeo0R3uUN/Cic7lh6ijXWh/rcPKfALdMeXmdet2UCRtFni/zBACEMuCOmq5NLULG8Tooir/JW4vPc6JKKxuofbZcXykKvHEecrbPTQtQudeI0xbwmEUP/KOQB54GbjTDlNwFrTd06wfJ4OlhVTYImpvggTYWQBFAU2Wq+KfJt+Tm20jbnKczJdYZRAGBao+tQTUkOjzr6NMtHn22rHjRj5V2embWpYQLCHTjLabuLJhqMaCO2v5ZL6Tp1Alf1haKiy3R/DyCYmR+G7E8NcBSPqHuPmE0Mk4nNq183/Q4eS2x4CLGPsmagSyJxkP/WrRA100K6/QeFnJOwFStN18bJNpph9sNAxHm9lcD9lHaVMgwRel7kjmsQpqXGXGSLB+pPVmzGj7PKIJlKsZvLxciTTCrjBV7iJECWoaH1Ug4qQE98KfvY7L24rCU+PTPW4XnLnBmiW4yUiZCZnNxNnlpN4PjUH3nrJuRZ0vnaln90yzcgoIrGo2owmIqNJwH86Lwwxsni+opaNXyy8nbCl266LhZB36zQmMlN9r4mDjb2XcG+Z0mch1BWrqvnMEXZVAZD8hSoCYXdWXXkLN8eN7N3nE4SiuTtVJRtNEGxczZEIq5DvpVZAINL5kRiWcpUM05aS/95wGvWGN/gpaiq1gh0QLfLw2dAcmXm12rfDvhXTKeB3l5198ulS7wbYwrZWy0kL5TVy1QaQM5WnoyEpIa0S3v7hM2/oGFi/YzrdjH8cBUECk/oCNLSn943JGldKd5a0iLREca7cE87G7u/uhgLreV1JVbIgOn9A14n15lPVGNSbqqC9h2Y9jVoBbasBkGjAKHD7NuIS+WnEf5pG6S5Vm65U4OAmpeVFjXEXu5CflO3uqelwYXL0zsLuptzhgtiHILVXmqB6Qx
 SeIPo8yO
 0Q257023pCoZnlz4Sz9ZT8xM1/NsdiVVDpwTyQDlDyiKObe95rJqsYl6cYKWovIiIJCY7VGVLmr9VlTDZtT2C4IJBxslSdj0Oi3K2uJgMlt5HAvuVID4PzKliC+QEbRfJdL5b0523Vy78SfyZvVVHmIO1uSsHCdiDvSco2zlds3ff2ADzRM/8LvsOecu3YNXLufQlWjKyucOtgaZirFXt1KtfpdQL6gwJ8M8J/w4zoj7ZpTJx8LvhlC3L9Om0vgKW60DSrTCduxNg/9DjOQ52B+RUs0Z49/4UIu7GK4drj1ovNk1DxIBnbUq/mAPDvpwn8x70Ztfn06RUjgiWAoAjNuThCLErbzfPHAGairQyHW0QMYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Apr 17, 2026 at 10:44:18PM -0400, Zi Yan wrote:
>collapse_file() requires FSes supporting large folio with at least
>PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>
>While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>
>Add a helper function mapping_pmd_thp_support() for FSes supporting large
>folio with at least PMD_ORDER.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> include/linux/pagemap.h | 10 ++++++++++
> mm/khugepaged.c         |  5 +++--
> 2 files changed, 13 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>index ec442af3f886..c3cb1ec982cd 100644
>--- a/include/linux/pagemap.h
>+++ b/include/linux/pagemap.h
>@@ -524,6 +524,16 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
> 	return mapping_max_folio_order(mapping) > 0;
> }
> 
>+static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
>+{
>+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>+	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
>+			"Anonymous mapping always supports PMD THP");

Nit: afraid not, at least when running on architectures without PMD leaf
entries ...

Maybe better to say this helper is only meaningful for pagecache-backed
mappings. Anonymous mappings should not reach here.

>+
>+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
>+}
>+
>+
> /* Return the maximum folio size for this pagecache mapping, in bytes. */
> static inline size_t mapping_max_folio_size(const struct address_space *mapping)
> {
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index b8452dbdb043..3eb5d982d3d3 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 	int nr_none = 0;
> 	bool is_shmem = shmem_file(file);
> 
>-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>+	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
>+	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_thp_support(mapping));

With [1], can we drop !is_shmem here as well? shmem would then always
call mapping_set_large_folios(inode->i_mapping):

---8<---
diff --git a/mm/shmem.c b/mm/shmem.c
index 4ecefe02881d..dafbea53b22d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3087,10 +3087,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
 	cache_no_acl(inode);
 	if (sbinfo->noswap)
 		mapping_set_unevictable(inode->i_mapping);
-
-	/* Don't consider 'deny' for emergencies and 'force' for testing */
-	if (sbinfo->huge)
-		mapping_set_large_folios(inode->i_mapping);
+	mapping_set_large_folios(inode->i_mapping);
 
 	switch (mode & S_IFMT) {
 	default:
--

But we can do that in a follow-up, once the revert lands :)

[1] https://lore.kernel.org/linux-mm/b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com/

