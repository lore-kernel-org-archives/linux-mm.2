Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32490606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=pKp1mOHB
Received: by kanga.kvack.org (Postfix)
	id 41B426B00EF; Fri, 20 Nov 2026 06:06:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC356B05B0; Fri, 20 Nov 2026 06:06:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1EE6B05B1; Fri, 20 Nov 2026 06:06:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5896B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:06:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 963F21C480F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:05:59 +0000 (UTC)
X-FDA: 85455217638.20.D693AFD
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 83B0D80005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:05:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pKp1mOHB;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf30.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795172755;
	b=l+eUGBhGw328BB6QG3khtGaSWZM98ZYBGMzZxN1vCq4iuUjw2f0tNr8llH9pkWFDTQ+GZ8
	TxJ6d+BUep7ROOxxtr1iUHgxU2sUY8KcYUKfJY615mni25tTybv47t6utWWzMylqJpmLz/
	wsxUr+Jc3Dd+lfrS+X/KcD5GbDGtkRg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795172755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TtFuIhwgLpPs0ea7HaHQTWE6q+4yCc9ueOWd48K9Uz4=;
	b=cFnuy5wiubBmgh5iR9kiG8BqlSKedNX/XQt+bFZ+X81XB5WIlzxOZ/yv5n+UsROEQR4p5a
	o1Ac1y6O+A2XEB4JFo0XbrJVWdN4sfI1kawYWRMGpw65w9G8tJfB7v2yeH3KQEUs3CKrjU
	B/9iYLdYItzTWeeGVUaNo3l7izpTtNs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=pKp1mOHB;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf30.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Tt
	FuIhwgLpPs0ea7HaHQTWE6q+4yCc9ueOWd48K9Uz4=; b=pKp1mOHBD9Pcw/cvWa
	I+cUQs+xX07LPn1aI3fJG1xin8ZmjwGXQeQnyE3tV6RD+6eHEeKekKGjmHPi1k+v
	CG2G5J7Mw9N5AIKvjqD90psoVafdcUlyr/28Wqdi0ReRDxMHQA553j3d6RQ7cC5X
	hhiWg3aev0oahXkIosGxa4bf4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3z1yGKQBrer4iJg--.45709S2;
	Fri, 20 Nov 2026 19:05:43 +0800 (CST)
From: Xuewen Wang <wangxuewen_ky@163.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH] mm: shrinker: stop counting when the seq buffer overflows
Date: Fri, 20 Nov 2026 19:05:38 +0800
Message-Id: <20261120110538.3256962-1-wangxuewen_ky@163.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3z1yGKQBrer4iJg--.45709S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFWrCFWxZFyUKF48Cr1DAwb_yoW8ZFWUpF
	s5K3yUta1DZw1xZrsaya18XFy3Aa4FyrW5WFnYqrW3Jr4rXr1Sq34rG3WYgF48C3s5G34j
	qr1Y9FyUGF1kZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jJTmfUUUUU=
X-CM-SenderInfo: pzdqw5pxhzv0xbn1qiywtou0bp/xtbC8AdGL2sAKYd0GwAA30
X-Rspam-User:
X-Stat-Signature: y6gq87b4ttnf1p9n9bw7x1cxey7goz53
X-Rspamd-Queue-Id: 83B0D80005
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795172752-895843
X-HE-Meta: U2FsdGVkX19qJPpK5MKW8ro+we0gC4bG9rDcDakPYdheqvg4HEr7DYuYjAZ6lsBNZnkeRxSIUOI1rHeBuLRnSbiu6u5pgDM+Y0fgZXICQEZ4sKgp/V9f/SBqCQhsfHqKjduYqSxlTmA1ZadopTtPE0GXC3MWCECaskxE5Jvq2DsBoLp+kVoSw0bbcE0VcN9diymprQACdDadcgILrc3LNbIoMNkcm0S0ONUkYY5VpGAXS5BBdsXlc891lXPb9RmxMExqecxouWMbSAER1i0bSCTo4sl+kd7bUlh1DRog1IEhnBOmwpSH4FGx4NNzFB7QoLJG8IOUevMo6mC4isbeJnlYuGeldswdhhFFP5tqMSqJtxJzApCALadKqOq2/DnmNca+vOWPVG/WTu75ZO4dkSwRpYDCMeKp+wNIqRcipP7z8UFepskEQZlaj6ajFcXTwxaWkLim9wjvbAw9QkPI9rj4hJhOdiDFF6rRaQIVbTW8US86VgTPkgUcwpow9lwHuTFJL9tF6PA5O5dVZ9Ir70GRMT7AlBLyHEQZPBFApgIbSa63Ni8TjIOiMqDRmHDkJzzNPeHlDt5WqSqxgepeItubbyDV2yO2B78n7wBVHLnjKwSskSToz04b0lUazV+jKlcMZWwAitqSV5+JPzMMn6YyVC3z1+inEEKvJloUZAi7IJ6oXvJdKr6VbnU6UP5QPF6ZK0Yx36jRumG9Dp0Qh0plU90GOMMZnCpEnka0ScpAINUMleyd5RrR0VDCkfF+KyFFKbQQi1PHBj9pZojLmbA2Q4DfBihKaK0PI+7jcNMAzgRTvSx8jMRcpMzYEBBEI9qdqyOI2//dqTyRyO464f4UdSczcozzS9pVl6swlSu8CzDpfSrBuWn9IJaFjHwGtMICc+/ujJwhTiwSe+IP1BOVxOAtkeHMNiIUt0aYV+uYzoya+4CyDZr6DnX9SA+g3jHVWQdJvlKx4yhGklx
 cg04LJ7e
 LeMdkt1KDzpd/alwMPGEGL6bzsqFlsHU+5/SkNlW/jDQzORJW82nSmhuJ95A656XPlfoMezrwCnxzXbtTRJ/zlT8dmi9rW/P5YrSvbCrPb1JEmKrzKHRbNDEG5hZHHJNlIAuGhf9cWDuLN8cLSbcTmhUWB5at/dET+N9UcH+OTaCsqriwkJmBCQTek94SRJtjMxZEXzTedutbqg+IhOskX+p3e55JKBWIvEbPyabMchp0LQ73w+GCMKOTqu9n8WGXxIbl4EsMDWxJJJo5a9YJdKAOF6EDlzeg1Cv2J1LhMUHt2MC8IV6g277m2bRIiCCMQKKwEMMs8Jt5+oDiXoWmoywY+nrNIVI414v1IkRiSjemEd9wKvPHOtY9b8ElkN/qjCXJ+sAjy4ifuPi2ABx5qNn6iqjEb+g7u8OPyoo99eQJ8Nt8xG78Kn51TrT7Cx3Ys64EMPPx/PkZHg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xuewen Wang <wangxuewen@kylinos.cn>

The shrinker debugfs count file uses single_open(), so all memcg rows
belong to one seq_file record. When the buffer overflows, seq_file grows
it and retries the entire record. Queries for subsequent memcgs in
an overflowing pass cannot contribute to the final output.

Stop the traversal once seq_has_overflowed() is true, using the existing
mem_cgroup_iter_break() path to release the current memcg reference.
Leave the overflow state intact and return zero so seq_file can retry.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
In a single-node KVM guest with 1024 cgroups each caching 16 ordinary
files on ext4, the 8865-byte output required three show attempts. Count
callbacks fell from 3075 to 2472 (19.6%). With probes disabled, six fresh
guests per variant each performed 101 full reads. The median of guest
medians fell from 128.2 us to 112.2 us (12.4%, about 16 us per read).
Small and sparse outputs had unchanged callback counts. Complete output,
small reads and seek-to-zero rereads matched; concurrent memcg deletion
and signal interruption checks also passed.

The successful pass still traverses the full list. Early exit skips
count queries for subsequent memcgs in overflowing passes.

When overflow coincides with a pending signal, the original code can
return -EINTR in the current pass. With early exit, seq_file attempts to
grow the buffer first. The retry can return -EINTR, or buffer allocation
can fail first with -ENOMEM.

 mm/shrinker_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index cafb566301326..3022d103b0b1e 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -74,7 +74,7 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
 			seq_putc(m, '\n');
 		}
 
-		if (!memcg_aware) {
+		if (!memcg_aware || seq_has_overflowed(m)) {
 			mem_cgroup_iter_break(NULL, memcg);
 			break;
 		}
-- 
2.53.0


