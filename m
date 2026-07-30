Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1863C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6BB6B0095; Thu, 30 Jul 2026 02:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96226B0096; Thu, 30 Jul 2026 02:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5EB56B0098; Thu, 30 Jul 2026 02:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A92AC6B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30F37A163D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:59:05 +0000 (UTC)
X-FDA: 85044541050.10.CD69397
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7E41C1C0007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:59:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=hv0PcEo8;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785394742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aj3+ozneKRFxvyRKEW1x+foEkavllzfM2NqbtLKj8IA=;
	b=4E2W99g0DajTyGFagYuznw9t2MlZtMBUd9IODVHFlotYEDXUchD6Yix452t1O208hqHFz7
	aL9o70buU3b4pVwOByq+lr8PCOfZwKGaWAweMbYD8GbkKRkldEggPVY0dzPLVW4dy7//iE
	oGZsY7o5OmQE4dCFOBRVALTvDZjjIkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785394742;
	b=MFLeZ6tIAetb6aScxonuf8MGXJkMRY8RHggvNHtqll6/ATp1EPIdfMPmvOrSnrkU6xdGyr
	hyqCQEzk1Ck+ljtqe+WW8ZzQUPe/pHgcVIwFz/s3Q/tk19YysMGyIHjKCUd3leqQFTO/M7
	fxNvZ6oUcoqexL/mYEIkTMbUVpkMAN8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=hv0PcEo8;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6we5v1894443
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Aj3+
	ozneKRFxvyRKEW1x+foEkavllzfM2NqbtLKj8IA=; b=hv0PcEo8AAPDJ3qmRsyH
	3+KWRKhUuio5bu6v7AnsbOIMwgD7rZbWuZCbxPJ8NOtDT/6jnTzUMipJ0mF7QfZu
	3vHsZW0WXTeqgG2leuJy+YHuFK/7Aze+PS0kNPRJ77w6BASuAor/BNbvhZ+06gWE
	lwCff028FYqKbvLsbLBzqyFKUem7txf57ogPxPRAOr5qdW2T8loIUHnw0K1cQz09
	7P9wendgVQQF2uUVmf24BxrK1lwd44WBWwC/SjBvLCM7Ae8WAwMxAh2mgghG2Jea
	q0yZqxPC9eTBItVbYtNcMTqXiTV+yoGFDSs/zzZjapWZTUnHFT7gf1vSP1LKyFZq
	dA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqv948yb3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:00 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e4f946461so214619685a.2
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:58:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394739; x=1785999539;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Aj3+ozneKRFxvyRKEW1x+foEkavllzfM2NqbtLKj8IA=;
        b=mvzajG6SUK/i8445ork408AFXIC+07e+R8QHVmINfXoFO+OMBDQJ26XjUqrJ0sXk/W
         SLZWAEuEVtRf7XlHAq2sybQqWuOCuocRyTA8HaZxCy5btBdIpYBpzOVd/siAHL5vecA1
         fEuyWBNEcvqMLFfvQB1qNht+lqrqUd3hljrpT9vTfzj0caqwKFx0Plb/os4j79DgYjxt
         PDhGXO6/YbOTcnCUrZByLMaqSe+XKtIPShEqNzTR0tb5Rl0YV5ttIvHrK8ssai+7JmdY
         MFW+013VKshUVanQXmQP4LijjiAHnR3YrwqSM+FCbHBJ9VE+TME5eWsaxwHyCXr7jf4P
         XwIg==
X-Forwarded-Encrypted: i=1; AHgh+RrJebVlA4QPG3icGTIIE+8YqvHS7ro1iGhf9uKvd/CYmwarD7SiwRgN6ow6RRZeiPOf4ssronEACg==@kvack.org
X-Gm-Message-State: AOJu0YwYNbDlOG/z2e62jXd6s/rIVybWVyNWo9IstNHsfRsRbvvn90T6
	3fuuLMy1lprRuXeAwbaZX4R+/ej5stUCujEhr8pOm9y889ORiuk7ImkbLZFAV7BN6vHEoOCyMY2
	fVEd60cfS0zhgj6Cf16HUn2DCWUASyA8a2CyQk+trdOb+cz5P
X-Gm-Gg: AR+sD12TYV95oLK5HUbJIsJZ+Y45lZE+YlA5xFfcq1tW7TSl/wWF6Ot7jf7jR/Q0bTs
	ewAx63fjJvcQWrEqG5Cz8AWhd5PVNQum9uihI39Iz6ua8UDTdE998zPj8ANBSB73RHi26p2RFy8
	s0goX/kfqMfGEhvYoSGGqUwDywDx/S4YuiVQmNifqveqs2FdAszn8tVafKJ7k3hkWotivBAHjor
	uzY1GlZF0riLG4dobfWlZwFBwqdKkfPrgbq1ddUcDxLUm0RJs8i51eAkOKA9mPyb0jSfJWrAU1h
	B/W96xzzz49BCfsgQ/LFR0OmHg02wXH1H0YGo6neqUdSe4rRwNEjf8OhUdfUUFGGEmSbOdqf8qb
	UM0en7JqqDujogDWb6Zgy3ccJzMh+auJbcssDbNfUoKAljQ==
X-Received: by 2002:a05:620a:3709:b0:930:f852:6daf with SMTP id af79cd13be357-93487207b6emr145583085a.87.1785394739077;
        Wed, 29 Jul 2026 23:58:59 -0700 (PDT)
X-Received: by 2002:a05:620a:3709:b0:930:f852:6daf with SMTP id af79cd13be357-93487207b6emr145579585a.87.1785394738610;
        Wed, 29 Jul 2026 23:58:58 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:58:57 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:51 -0400
Subject: [PATCH v7 1/5] block: introduce bio_in_atomic()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=2716;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=hHCEZENfCfsEpOmC0wBfWJMFm3C20nG7DjOTxirSTUU=;
 b=0SI7Xl8K46e0uZlTQGRMH9PF2VforZ2ADnod5gEhiUnACnwVjnxh4x+kTnl1qD5D6oyl3rPbF
 pLBs0BjnLHtCNXNT9pp0MnVsyv5sMsoS/rOivi/TnyaG9EJUxZTJlIh
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX4zERItyYLpnR
 FqGkOi69kmLjhMlZ9VI30sG814/ZD5bUPAU2DCQxKCB0kfDW+JDHcfZVIHYDEyfQAFW/89Dz0Tz
 9DigReGDe9ADEpBaKM0NahYcpCJrxk8qwKOxTHO+5Jq3fdOAR5T3
X-Authority-Analysis: v=2.4 cv=d+HFDxjE c=1 sm=1 tr=0 ts=6a6af634 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=JfrnYn6hAAAA:8 a=i_Ns0s3d_2HFdJHkmwAA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: t9lM_xzbvTddYvtLzD0qQX06QzLRmLBp
X-Proofpoint-ORIG-GUID: t9lM_xzbvTddYvtLzD0qQX06QzLRmLBp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX6MBs7g0orUO2
 JPtNEe18sAViwU4uLQPssKPsHFr5YsF+Grtwpm1EmcIYKCl4fcKfmvahpN5OKjQigjsVbg9qBvn
 4FqCT2gUjjCBF2xj70qbEx3fATu6VqZKTbs3zuRPe6Apw1AmSeZQ9hGFLILOgl2IYseWLaesAOE
 cRnIXUfI+EkVeAv7J/a6lwM6inF6v4IDiQqKIL85nDToGwGfGQhAUTjSQxoTMJuO7KGofKj4rWu
 9oQ4VYaTwLErhFZrddH7WfQT7V2VSeBF92asRikGuo9C4LBLHYNmYKbgBvMBQ06fUdP09QZSxR4
 zPyc5ZHEDowKfHL7xyEOD9Wc3YcR/xeSJD7LXxVdyZoh6vSPKwB4kdqcWeqY+kjVhgnP7u82tc6
 WnrAU3MZavyzf82TP/3D1c5pvaVziUDxem5lV6NptvKnvikT3W0W3L7+l/ZJH82YQfbgt57GrFD
 VpVOygMCspk64C6/Z7g==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=10
 clxscore=1015 bulkscore=10 priorityscore=1501 malwarescore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E41C1C0007
X-Stat-Signature: cj8f5hhbg9mrxtitn1jd4dpi66arrhp6
X-HE-Tag: 1785394741-922649
X-HE-Meta: U2FsdGVkX1+IDp9ajVX/kfADXhuPRfYHkE3zJDNyJ3oWkXxSStLYF8uv8tNoIjTozBcxuHUjjyXk5NcQdsMzlPUXxet+A0IrMNlHZU5P2nvIwzhyeDT4grlRoxnSjd7WigcT18xYv2xk+gKI+KMnymKDDYu8Zii29dKA6IFgQQ9f8XVki0hoX9mqsa/UuLM0KqjkAH0VIal8GPWt2tyn4C/XvIE7HvnAknYTGgRfKV6Xk0xA3jv5SSRefi5A+wzv9XUf/3AL0+iLuhiGByCqGZQD1oIMOWQNcG85yIPxZU86Jd3SCKm+N3Oe83OeGRrMNZOcKq1h6IcypLxFG2zWicFzsaEB5JQN9YSFm/Lvuo4EpCJ2CKXiMlCJ6r0+UbsSbGp0ViiHtHX+YJ1pnU4mxEfJxpDshc2y3Jc3MHvTkNCHsJVjvMnKbCTWHIKDd5CdffVZfPTUv7iL3diXuLQrMVlbeBRFVkMgrBwesd92QJ6FMHVMa5SGATx115Q5DoYXcehaxI7UUHqn+snpBsJu2BEIT/BNv/1c2hnJtFb62hAOHw4L77U69WFh91Xgx3QkyYFBf9PFvzxr45uNGXnKECRsED3YbuAXxmgFYE4BVtWNOOYIgyNAWmnDE7qD+THOxVNR99rfdOzE9kw4hrj3605jw5PgrDGBrHQ9kf1de+KfkqiFqEghmVakeCsF5d4tA1Ziz6ro+ac5Bomduy4WYRl7662eSOm1N7j8a0oyJoKQ/gyE/sXt8p9F3Gyiw0m1RGCsE6q+vmvp6omy+O/WKwoap2ZqgZkmvhSIavRnF0c1G+P4NnbEfVfwBGuSf1bwPIY9k0djwoTpd9gvFa4pU9b8ROmxo55The4EN3gKTHaNtCEX8JaMOG2QsK/GfhFX/zim+8LtMleG3/WK0sYDcJrStaHIy5JHWrWko93oBSpsI5w95CTc4/dNlU9qO6JgD++e5hPmUt3AZkLGoEZ
 FWskp8xz
 W20R9K/geSYbYqWC4MsJUu2nVXv2h0ykHd6Yc3FdNaOifnuMTvjDSk6cpmDExTNC8S+yA3eVZAWlTLtOOTVA/EubKOZNHusE4Gczqk7dwQmdqGKfm/vVyaC9uNDQ0qM8OIYMVVWloDolAEwwCnFTZWprpnqlQWpD6P2qj7im8aqHnZ/6Bx7SdynG/wiELHkcI6i1nSPSvZCvcKxjc+CJBcxcSKSbQI4MWxqBCrVP+VI4BmU16WxCWiNZ0dXmgNonC/6K3kVnOL4yYyvhity+Yod2+81NEo6DLwHgii3q7dELzNPWSss8xZFKc+aXQQZPD6nreOKKi6bXswLlk4kdmhcG1+lWqeng4If0/tyNzJPzqfoZSu04mmJOL+5/ar914znXOGd00DIB8qZFHP6EMElrSZ/Nq6xoBW4jEEb80YJEq6X+ngqw5ZbFSSVw/25vjZi+cr/GGPwgmcPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the atomic context detection logic from erofs's z_erofs_in_atomic()
into the block layer as bio_in_atomic(). This helper returns true when
the current context is unsafe for sleeping bio completion handlers (e.g.,
hard/soft IRQ, preempt-disabled).

The logic was originally added to erofs in commit c99fab6e80b7 ("erofs:
fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC"). A
subsequent patch will use it in the block layer's bio completion
infrastructure, so move it to include/linux/bio.h where both subsystems
can share it.

Convert erofs to call the new bio_in_atomic() directly.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/erofs/zdata.c    | 11 +----------
 include/linux/bio.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 74520e910259..f796bb3ef53b 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1427,15 +1427,6 @@ static void z_erofs_decompressqueue_kthread_work(struct kthread_work *work)
 }
 #endif
 
-/* Use (kthread_)work in atomic contexts to minimize scheduling overhead */
-static inline bool z_erofs_in_atomic(void)
-{
-	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
-		return true;
-	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
-		return true;
-	return !preemptible();
-}
 
 static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 				       int bios)
@@ -1452,7 +1443,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
-	if (z_erofs_in_atomic()) {
+	if (bio_in_atomic()) {
 		/* See `sync_decompress` in sysfs-fs-erofs for more details */
 		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
 			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8f33f717b14f..62a983758e09 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -368,6 +368,21 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
 
 void submit_bio(struct bio *bio);
 
+/**
+ * bio_in_atomic - check if the current context is unsafe for bio completion
+ *
+ * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
+ * %false when a bio can be safely completed in the current context.
+ */
+static inline bool bio_in_atomic(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+		return true;
+	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+		return true;
+	return !preemptible();
+}
+
 extern void bio_endio(struct bio *);
 
 /**

-- 
2.39.5


