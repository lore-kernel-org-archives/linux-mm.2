Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15A960A2609
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KRbWh4Rt
Received: by kanga.kvack.org (Postfix)
	id C446D6B083F; Tue, 27 Oct 2026 12:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5496B0841; Tue, 27 Oct 2026 12:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BA46B0842; Tue, 27 Oct 2026 12:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94DF86B083F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:37:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 199DFA876F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:37:11 +0000 (UTC)
X-FDA: 85368961062.17.FBB9CBE
Received: from mail-dl2-f4.google.com (mail-dl2-f4.google.com [74.125.229.132])
	by imf27.hostedemail.com (Postfix) with ESMTP id 629874000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:37:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KRbWh4Rt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.132 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793119029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6W47LdRVzDR/azT+us/9EkPK5g/BEdP8gTOrXRV0SRo=;
	b=2PS/PUD3XVvPEqtH+s6+LqpMZpowBoga+rE5y7fMX9Vd426wCRessQtNUbSFNAXpISn3pj
	TFxe75+O9At8rPumjcDXZUP2FJiwfmBmE4jPToedG3BgRH62opj2eoHgaZr7HaLBu9S49W
	eGV69aF/WqK49R9ZPuWWm/HaGl6i89Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KRbWh4Rt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.132 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793119029;
	b=Z+x839KoUFvzkFFxWfz6wsTANiYN1+hh6tFHDQDfgFpbe8ENQvF9TTVdfc6+/LIw5M+VfN
	+endo0x86u6ZWGL32YSxC5MBzD4GO0bSsJA4bMVFIyZbpEpuSQgvn1KvQ4atFHV5zy0Wj7
	LgUJD5UAiufZgLlrpg3kyzAGu32gfrM=
Received: by mail-dl2-f4.google.com with SMTP id a92af1059eb24-1922a6f0d23so1520261c88.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793119028; x=1793723828; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6W47LdRVzDR/azT+us/9EkPK5g/BEdP8gTOrXRV0SRo=;
        b=KRbWh4RttLKAvhbh51UHo4jtJvKIa0URjklUrKI+3lnHzV5M9BNDYKjQbpx5hJyrpd
         yCcaTGhfKtyUWgSlcqWML5zbK0+NRyodSc78cb3SpcsLNFfHTc4d7McZMFl54lEp2n9k
         TKAOAwKRlqu3s/FhegdEQha7AmWXdR5YzM9X6PLd6q1IM9Gao3mdxM875ptYvD7hNwyp
         bWN/V6qCEmXP2DWNqt7dluRBi7UQ0iC9MbdLP3pIEuMx3qH2UTtFOOnSSLxLuVwBnS3i
         iC9NyCG5XdwPL3CNWZmVbZIpECxO2wNyR5XC2tuK4+8+55VapUaYGgFPh1M6H8/97flV
         aAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793119028; x=1793723828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6W47LdRVzDR/azT+us/9EkPK5g/BEdP8gTOrXRV0SRo=;
        b=F0UU8NQgyilwSphae3gdF9ZGksOIeuieQD6BTp2nREulfRba6XgPx3eMt13QEUdDq+
         HODf0NoAl5BIsWjwD3mCcIlXW4yERD7t70u+AAQWj7Qpr3evAPepl+Gip8GQOx5xsNLO
         etyjZ/ey4Gz/I095NWc5bz8Fzo0ynHZ4aV+MKJFkDNCWzwj8KCawD/S1E8VJQeLpv7fr
         4ki4D9ZKM1JTweX8e7mHovZW4ovrdFTDlROUJKDQfGdDL6DvlhuVRrWCw2HYhDmdek0H
         boGEgivITi+RPNQEo5+tcAFwWikVbXchHFNkJDeRgHRLaeEahKZwFVproUqxvn4CItWn
         uajA==
X-Forwarded-Encrypted: i=1; AKwUvBxYEDBGG7gGiQItVv4aUzIi/O9yCocsZRi79++/NzeeYkOS81IFmMZRFESYIJzB+yODjeQM8fIxIA==@kvack.org
X-Gm-Message-State: AFq9FYKwDO2xol/jlzjoO2A/1kIU4Js9LgXVfMIS7IhE/8ItqnkRx6UJ
	8hDnefbK4Z9LEMa6SjC6lUZJASD/1Y/iGSoQDnsuIYF2sKoLCDSHUnDL
X-Gm-Gg: AYBFou3V+tLqrh+ta6RdZVysvD2W8tgSlBojnPScbz9VuUd9Rjg1aqabnmHJTVvlLqT
	sjQcUj3iFmsZb1hWxqZO7NBNodt6AlBWLaMoyyRpnf3aeKjUTVBIDntkoAOP7KAXQvth9mHKc8x
	N7UYv3gIwwczMqHbFptn7fipgHunysnkiSy5nmZhXO/FV9j7gAHpVjEOJMBVNfD7sQRNetX0P9i
	6O+F6iU0270u5h2BKANe0zikGBXXslZIauBvKMkDCqxY6nHt4qUdLyiJxQabzGdG5BN+dkunRbs
	5rmsyqfQl5ASceF/6z2ewd8POkctzxATe2iHvbb+/F6uZYr0fObkgk23+B8J4QRY9VJi9wQ5vch
	UIWepyp49VAnsQGXRsBbKYpQ5WQytM3A42y/v0J4vva7X7EZboNBKUBR5u/u3AOlS59xnwh5yr5
	6o8bI33oDBZCRDM0+MH5Be9YZRiUe21xjevodoAtykO1gd0mtdTzWlIn7u7uyhu6zZxoX/SV2u4
	nSJpsoFaZO0j01rwsgiAES/+MDQCON/u8H6U5KwHHOEXSd5qka0Ul5xzr7wamqkypWM9hay2708
	rWqtzUuWEapVeOkTRkItTHkidPk/6VeYzVpsAjEagNKQmxSgBc9mDKJI
X-Received: by 2002:a05:701a:ca07:b0:14f:5cd:f286 with SMTP id a92af1059eb24-199373095e3mr16662744c88.34.1793119027895;
        Tue, 27 Oct 2026 09:37:07 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a21bc6cbsm33902579c88.16.2026.10.27.09.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 09:37:06 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	tim.c.chen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] shmem: clamp negative used-block samples in statfs
Date: Tue, 27 Oct 2026 16:36:53 +0000
Message-ID: <20261027163653.82661-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 629874000A
X-Stat-Signature: qfg3wu8b4af1hoay1ddbaz5jy9n85zpw
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793119029-326227
X-HE-Meta: U2FsdGVkX19XsZ6SDzkjW++SiU+XGkZALg5sCllQSYmfLIlH1VyrhjsS926u3WuchKw6q25wjd0x05JFeDMP9gpuX2NEBLgeMDVlCMaWZQT9vZl1hdChReGhQKAmWVZ2sWKtYorFYmUZXWV/wvT5Fx8Z90OZpVrQ1grulTBedzlwvkx8BCzYpYtt19mT2xoLheKSQUN40eKTzQMjUjhPdqN+NY2zdHHtbePbfsXKEsS50uqU0Wnbd1Om9XRTEQBb9MOz9jRCRFac3P+bwFsT2q6mpnnua62eGjTvj2bDZ8kLEcVsMclaLzMZ9npRANzaP0k7DLvnAxpQ3ltU859Fbx7o7q3aYNSk21dFhWhbF51MC2rldACKzQcrql/XRUMm405Bw7h/0Z1+vUkQGsqmMWbWV1QjnFLM4e0IWmQnGkG9FN8WUnZody89TkIc0VsoYTebZac04mhgG9qQRcyKLcb/bcr8ezY4uC5Tv/jW94NJr1WpU9qqcW8TZVD0KT5g2RhCvEF45iIBr9zTJVX69ggcSVFtpY3g2AZcfPuWn1TZK5xVJVzQo8in5mSqnFMrKap1XzSmAWlUkEa9mVKia8jc5AdxzzNHiTNmjflldYEM1C26W/g8EnKs4A6XLKk9ilet7FQPQfYPEBPZCF6SaUAX33Hoio9L/gWNa+TbBQE3oQmyJmvodNgLmKUI1iuq4uqEEMxcsDI7bD/a0R8hTmMyEVDs/BxnLgvcegkFdr0yFt12k3ko/RsoR4iIkd2xSYG0zVKKNxlCLRJBxe/qtA4zB/A+/5pIbl9aBmT1Wyxri3dvkEC/8Df8n1imiNF5/JYiupREtjdudHrJhuwvd0/qzpW/RJpQxAYUVQzq2JrqxvdiqIWxcfPgWHXzRkol2b4qNxIZyDFN4Sq0AAfS7BC0ZlwgbMZCwRCD/7+Y1xZTPr2SMwqVxKrsTYImruETEAqZzSHHGp9OdyTAaYA
 hd0NmLh7
 KR2nJ9a5635FsbF25oWWn8NaLRaZd+EeoCiSuNXNaPde1qMiX7mK55k+nnWU1G6StoFtpaigW0mNU9m2WcsTV5ecle5eJ9skVpKmsP4fZnXhWQYwlVUiN/B/+6/h/BDS7Sf0OJR24HukQWX/aN3Dp0MKnXM2ZRHAZoqT6AqxfJKfnP9XgaLZPaNqfTYtSbTPFYzCFHShVecih2tBbWj7J47jUS/Rtw/gYhsatwi493Fgxf9HWZYsEUo5K1D58EwPOnR/MNAqZuqbXSSC0OS0Fd+8Z/E+QYco/OWLUZ1B7Fza00q3nz6mvQWf80SQYBXfaUs9fwkL6cFDNPPAvXVpvag8POUeVdG5HQNKMJABmgKv8sIitb/5J4ZqcVH9YAp38PYp4AzylXIsXzgEd2OcIo/5zpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

percpu_counter_sum() holds the counter lock while scanning the per-CPU
values, but local updates can still proceed. Concurrent allocation and
freeing on different CPUs can therefore produce a negative sample even
though the number of used tmpfs blocks cannot be negative.

shmem_statfs() subtracts this sample from max_blocks, reporting more free
blocks than the filesystem's total. With a one-page file being written
and truncated on separate CPUs, GNU df reports negative used space, for
example 67108864 total bytes, -28672 used and 67137536 available.

Use percpu_counter_sum_positive() to clamp a negative sample to zero.
This retains the approximate accounting and does not change allocation
or limit enforcement.

Fixes: 7e496299d4d2 ("tmpfs: make tmpfs scalable with percpu_counter for used blocks")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d97fc32e7c94..092bb45a076c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4005,7 +4005,7 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 		buf->f_blocks = sbinfo->max_blocks;
 		buf->f_bavail =
 		buf->f_bfree  = sbinfo->max_blocks -
-				percpu_counter_sum(&sbinfo->used_blocks);
+				percpu_counter_sum_positive(&sbinfo->used_blocks);
 	}
 	if (sbinfo->max_inodes) {
 		buf->f_files = sbinfo->max_inodes;
-- 
2.43.0


