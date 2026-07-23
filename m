Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 830D8C4453A
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 02:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124DE6B00B4; Wed, 22 Jul 2026 22:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D67B6B00B5; Wed, 22 Jul 2026 22:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0EF6B00B6; Wed, 22 Jul 2026 22:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6AF86B00B4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:46:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 127A91C082E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:46:30 +0000 (UTC)
X-FDA: 85018502940.21.94902BA
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2864A140008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:46:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bw4fK9im;
	spf=pass (imf26.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784774788;
	b=ywNltIrBbAL8vIcCZDVOyayjI6xoKZBh3J88onIQ7NIe+Qkbi8/tIRwuqMWBKV7GlUN5t+
	Xq7sS4khik99es3g9oskVexbqg0hRUU3HlvwrqWef8j18E7p0bPDA17zcrqoVVKIXOgpEH
	dijQPv4y02ZtJT8LowdI34/3bh5419A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bw4fK9im;
	spf=pass (imf26.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784774788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Si8wKsJ7OZH8AFm088arDM3rFGkqQRF41Hdi0sqAHg=;
	b=VE+djwxv+alcD0kb/nyQxKqcXLT8QpWDpqUxf8hEUDsyjM7xjFtOOzldrITlRnWIX+TXQm
	+Alg7Hg9lVHPtsKRi4uHPdWl5lXX1Ly92R1krQqHc9CEUUZFxBDzmsftRgAauXHMp/bkVl
	N6zr0/GAnZF3a/Jdb//lPmdsJOzSWbY=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38e08baf860so153844a91.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784774787; x=1785379587; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Si8wKsJ7OZH8AFm088arDM3rFGkqQRF41Hdi0sqAHg=;
        b=bw4fK9imfcUy2AZUD7Xt5rE1u8NVBKfqMjbRH8K/ChKC/5Pl3srqczqyaKt2GtdLNh
         uUSj3ony0P+Nit6mBI5hPN+7LGs50/7MxgvI3un4YIkgtG2bkRrxQCU/Gsod2cWv8S5e
         GjUgXPK6LGUsrPZOsANHLihoXqIoAUMG6hP7QiCgk7BpIC0NnofZ7irzEWip/km8x+XT
         Y8OKQy8IvcVR9p0T7xF8Eh15p50ou6NMI0CCOq6sJEfy2Q2zmKPLIjvF6bjYhIt62rqK
         fNnBpzFzfuS/29yN96GhQV0k4MQEWUDAJO+GCOa1qqOr1jtJyB9TNiV0xKbTP85esUYR
         nZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784774787; x=1785379587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Si8wKsJ7OZH8AFm088arDM3rFGkqQRF41Hdi0sqAHg=;
        b=f7g2pYuR0HEGjkhU7doY3R9dKmNg6xMcTKaCZk/ad87sjts9wv9wLho0FwimfIx9UQ
         2pD01wl7f1BIuMd3ptxETI4JbhsmYQHjvN7MU8kcv3m8lI3k4YtiBDQICQ0NWgf3dM+4
         NZZt1WpVqBVDgb6/DHnkco3ZNKygeMFtY7QxYjGPTKewxvuof4hVh7/qcVmoxMCZLqVx
         VxCPKJ1ObK1T3RhqV1kVpB/l1Z9nqw9b7Iup0beQfUHT+B8r1bXXsynIBUZ5GW3CN3W3
         ultevTVZ/hMQEdnzJAGDELTdOeFX4Ext7wcp1Q1AV4ljRdU218Z7ovxGpkYj5epg8R+R
         ixDA==
X-Forwarded-Encrypted: i=1; AHgh+Rr7DdkT7L4NZhxsBW9mfgquaKoPHwPKSfH0cprOVp6mouMlW0wte7euVPm7b05yFwmoNqhtkT0sfw==@kvack.org
X-Gm-Message-State: AOJu0YxmQD71/xBT+sEdri5YNtY8/MbwifDroFZKxDnlVE0FxP9as5oe
	6/cc9/zIjR4znO/zRpBkCx1y+Yen8J+Z2tVaZYJyzhMx/cKBMbGXkMIg
X-Gm-Gg: AR+sD10eMiJpP6p258KGS7k1IenBmnz3pQzGRZUXDHZBU7auXSmdF2nwvPo2BypPM3u
	pWX7ly/nD9pWXHZ9ZhELW1Jol/wvx38hAKuxlxB1Mh77XOAWtMjQgommG+UuIvFYB/afVgx5P/t
	KoTtRtsiZtil+yaZ8VD3lARzsJyoKcC+nrnyq18L00l0cq8r8zc0BKA9f8WyOW2giSehj6dlU2x
	bH0X8GyUnIr+YFFBve2qs8QDwtmlDsr5jAytL4R2Qw9bK5hBFJQIeTOGSnInH1e9r365SMYgFzH
	yj8eFj5CGN255EN2tM5LnJB12kkvRhMZ6ChwhhYHm/UT0pb6R9uDAs/W8KSoPw824trwggyDCJ+
	fG90IOcdIOq7U57yLMKNWy60I6le2NEbPag/lSGknzn11FrhyqKml2WfhVoGuLbG8iAYp2WRIaf
	/LE/itpTHU3jmEN5wbaCk=
X-Received: by 2002:a17:90b:2ecd:b0:381:9028:5945 with SMTP id 98e67ed59e1d1-38ec64dc738mr1269231a91.14.1784774787060;
        Wed, 22 Jul 2026 19:46:27 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38ecab80efdsm114436a91.6.2026.07.22.19.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 19:46:26 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: oliver.sang@intel.com
Cc: jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	fmayle@google.com,
	kaleshsingh@google.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lkp@intel.com,
	oe-lkp@lists.linux.dev,
	surenb@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	zhangbo56 <zhangbo56@xiaomi.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5: pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Date: Thu, 23 Jul 2026 10:45:27 +0800
Message-Id: <20260723024527.2822383-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <202606181547.617a6967-lkp@intel.com>
References: <202606181547.617a6967-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2864A140008
X-Stat-Signature: t4tpakkj4dhuikc5yi9bbkgzyzjcy4u6
X-Rspam-User: 
X-HE-Tag: 1784774788-599851
X-HE-Meta: U2FsdGVkX19dzWjH6GlVT2PlUo3C1yAOUszDREyXnOcDaEIH5/OF9cDTY6XXiAF0UnReETbaqj3gCXPyI6wmKBSn5BGyge6M15y+EtRJFmmNMefL9hXynzaK7YKikTHoZEbYOmVNNTngXliD39Y8bo8bj6Py6Jph/ilLkIKhzI/GuSy+55IgrB+L8oY9yzsa1GEm1+dqu1b/6TdGRYHfSI6Rc5rMq0g2TvXTEkDg+SUwUyV6gtaHOAqI5+aQidgs/x19Zgb4NTGPPnbUIKQQPcaYhG4tQO0nPd2/qkFtcheCLujDTMWCwL0I4f8m1RFN469Tg6EzNFEh3ICACArIrTv+8tb8+rZk9D+A1taRTn1Q5Og67nGhFKRBLtLc4K8UWqz4fdA0mEwHC/krjXOkzgMtmp+w3w8y+VXwwAhqHXtYGNmuF6TxZcItKzdaF3JkA9yuh3GLOGub4nPJVd7XAhbIbOcC8yeX+P9Sj8AKT8S8PwW+254B93nSBKIv71kyG7GFBP07oiIMVDRLW8s2KvBZDRWIWdMqwHVBep7RwpVFPYb8lCBLvcaAAKJ9/G+6pvb/7HooJziXJvKYmVdzWgVyJPEKziKzPWY+L6hRu614w7qfCIyLpknrQQefmoYStXVMr/2mdABV8FOHFR+ZnUgkHQhOgS0LZMCeWFbaa7kbHm5HX/LA115hmKhwf4zKzZJxSFRAff7UxBsov2/z6GF8NmgK1xWpJynGyR71polGeEwkZWecr2/gag287FYKkkw0nM17JemDO+K6DYiKDq30U9JkzpC3HqqK1wTaYqA+eXCKBRQ+VgkowdCIENF+cRWhBnb77cku52DVxD4HpkuYO/oqUfq246CUSU2VK6E5hX/D1YlT/xL5BwKd/MSqo6rzi+Sr8R8Vr7LvCDzEYrLld6TsuRKhgjYvs0uX7cUSJDBmElEWqYhdHYcSFUaex2bz/ZYPz6gouFCwSil
 1Apw/QuQ
 DDWtTDDqpTOvodkaOlKM8T1yY405Mc/Is3tLN9CQZUMpzwgr6ihqDwjVE1KVmSeQaiMovbZOBh+WYcDYrwMoaoNsD7m5PQKtyI+uZk5MT+cpAAOvGWuwWxx+ndw6Hlgk6F+wMK8+LYZaZTj29beGub6896UohNJpF+GWgi6O/IgGfhN3zaNS+w37DeU27yr57uKtA75wnA64AkyPNR9XxSsOdeVkCIz3fkXwwpveki/aPRTQHGXDEeiTFbz6B2FbUeJjOADruYqy19oEYVfQr06JVnmu3kwt1ZcQJODJy14eK7zPuChvXh9gCbEn8OSOu79iChr+ozDAWTN/NXZammDOKZNsrpYdr0jTBr6YFE2W/19sFQOlPiVDhh9d1p1oPGUkd59301n4RVZCcMTfx+vNa32iTToMee/BNbJlU6E8pRZ3c8PAjZ9gdEeHwMZil7az7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: zhangbo56 <zhangbo56@xiaomi.com>

On Thu 18-06-26 16:00:42, kernel test robot wrote:
> kernel test robot noticed a 45.8% regression of
> pts.svt-av1.Preset13.Bosphorus4K.frames_per_second on:
>
> commit: 7b32f64bc512b40b268776c5ac4d354b325b3197
> ("mm: limit filemap_fault readahead to VMA boundaries")
>
>     169.95 +/- 6%     -45.8%      92.15 +/- 10%  pts.svt-av1.Preset13.Bosphorus4K.frames_per_second
>     220.57 +/- 3%    +870.9%       2141        pts.time.major_page_faults

Hi Oliver,

Could you help test if the below patch fixes the regression?

The 870% increase in major faults suggests that readahead is being cut
short too aggressively. The current approach unconditionally sets
_max_index on every fault, which likely prevents readahead from
prefetching ahead effectively for sequential access patterns.

The fix: only limit readahead when the fault is close to the VMA end --
if there are fewer pages remaining in the VMA than ra_pages, set
_max_index. Otherwise, do nothing.

For a 4MB VMA with ra_pages=32, only faults in the last 32 pages (128KB)
trigger the limit. The other 99.9% of faults see no change at all.

Similarly, only clamp the read-around start when the fault is near the
VMA beginning.

This applies on top of 7b32f64bc512 and can be applied with git am.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/filemap.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 97772a05a18e..9f1e1c9ea6df 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3313,8 +3313,11 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	vm_flags_t vm_flags = vmf->vma->vm_flags;
 	bool force_thp_readahead = false;
 	unsigned short mmap_miss;
+	unsigned long vma_end_pgoff = vmf->vma->vm_pgoff + vma_pages(vmf->vma);
+	unsigned long vma_pages_left = vma_end_pgoff - vmf->pgoff;
 
-	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
+	if (vma_pages_left < ra->ra_pages)
+		ractl._max_index = vma_end_pgoff - 1;
 
 	/* Use the readahead code, even if readahead is disabled */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
@@ -3398,7 +3401,8 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		 * mmap read-around
 		 */
 		ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
-		ra->start = max(ra->start, vmf->vma->vm_pgoff);
+		if (vmf->pgoff - vmf->vma->vm_pgoff < ra->ra_pages / 2)
+			ra->start = max(ra->start, vmf->vma->vm_pgoff);
 		ra->size = ra->ra_pages;
 		ra->async_size = ra->ra_pages / 4;
 		ra->order = 0;
@@ -3441,7 +3445,12 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	}
 
 	if (folio_test_readahead(folio)) {
-		ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
+		unsigned long vma_end_pgoff = vmf->vma->vm_pgoff +
+					     vma_pages(vmf->vma);
+		unsigned long vma_pages_left = vma_end_pgoff - vmf->pgoff;
+
+		if (vma_pages_left < ra->ra_pages)
+			ractl._max_index = vma_end_pgoff - 1;
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		page_cache_async_ra(&ractl, folio, ra->ra_pages);
 	}
-- 
2.34.1


