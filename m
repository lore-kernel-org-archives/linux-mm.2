Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB11606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 06:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=GWkO9RfJ
Received: by kanga.kvack.org (Postfix)
	id 5F9586B05B1; Tue, 17 Nov 2026 01:00:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CFF66B05B2; Tue, 17 Nov 2026 01:00:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6A66B05B3; Tue, 17 Nov 2026 01:00:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21BEA6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:00:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F4A01A035C
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:00:21 +0000 (UTC)
X-FDA: 85443561042.19.352995B
Received: from outbound.qs.icloud.com (qs-2001i-snip4-3.eps.apple.com [57.103.87.86])
	by imf21.hostedemail.com (Postfix) with ESMTP id CD6AB1C0007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:00:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=GWkO9RfJ;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf21.hostedemail.com: domain of m.harisawan@icloud.com designates 57.103.87.86 as permitted sender) smtp.mailfrom=m.harisawan@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794895219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ie9TBnSRuFvJfRJMkw1HwmXycVla5fkFGDRxPOE8hzA=;
	b=Wue3/gOO71Q4r3dD3Wzr6mZRjBjnNrrksOWpX7hEEDsVJpm7zvoRXdWLoP6Jcktqs6qLZB
	X/098axJjHv8Sothx3aRgWcpul/0eIfM4+y86gBjtlZkGMUVkxJADHxROTNtQqdK6LTsg/
	T3FT3ss3NA/FcZ4tr3EQJjxLyLqtTwU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=GWkO9RfJ;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf21.hostedemail.com: domain of m.harisawan@icloud.com designates 57.103.87.86 as permitted sender) smtp.mailfrom=m.harisawan@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794895219;
	b=Fu+v0y3OOq68DyXwu/XEuGAV8ZCVYanMClX9sSFIt38p68dCgzyUUVvp0ESdjuAWjD6UNG
	Koey3N5zcUCYgjfZShAF9trf/3czCLy/iiUqsGWM3VxOCwH9vsywXWuczuzXl5CDEyE9Bt
	4n/kQuC8YxvPbym33H3ZiPvRqhEfAP8=
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-10-percent-1 (Postfix) with ESMTPS id A1F893000167;
	Tue, 17 Nov 2026 06:00:16 +0000 (UTC)
X-ICL-RepId: 01a1e817-7fcd-7a89-85d9-392adaaf6cf8
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1794895218; x=1826431218; bh=Ie9TBnSRuFvJfRJMkw1HwmXycVla5fkFGDRxPOE8hzA=; h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:x-icloud-hme; b=GWkO9RfJ06BxOFbckch+rN0PvcRS7UM49skD1gP4LwkJuboXqZMbM+DO5NvYf63Os145IC5Pm2Q1M6Obtn5bjebe9eaxTp4nXHqk3sJyPXEtwpIkLtqYvF3KF5Ub9Yh7QP7NhYbtw3iYWnBRDv12li+zxZgPyw88LoFrdoc2B0RACT0sDHLWhxhw2Kp53VWRDX9bUa599itTxHffnmb/V0aZvW4YUBfHl8hOgMTs7Ln8a3BbNcb2TpUziGLGzU3/CIltT/1tDplQ+kLcIbaXuCpc8ykcQDfsNrV9NV2nzQZM/c6vj4JHRJKWvyjKET9MODNt3R/sIvhZDa/JGj0ERQ==
Received: from [100.126.217.91] (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-10-percent-1 (Postfix) with ESMTPSA id CD5CA300014E;
	Tue, 17 Nov 2026 06:00:08 +0000 (UTC)
From: Muhammad Haris Awan <m.harisawan@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Liam R. Howlett <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: [PATCH] fork: mark memcpy() in dup_mm() with data_race()
Date: Tue, 17 Nov 2026 10:59:56 +0500
Message-ID: <179489519663.1444496.15875846661591982934@icloud.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Proofpoint-ORIG-GUID: pUoMMQlIZVsQSMrjSPyAHBRwL_I-Pivh
X-Proofpoint-GUID: pUoMMQlIZVsQSMrjSPyAHBRwL_I-Pivh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDAyMyBTYWx0ZWRfX0DXmc8aPZLSQ
 W/B287taoyiHNjHkANbxhoqigOb7QJ/fLGALDAxlXNFRxmu5/qhRwfmTTtwGGrPjVFBKOtP1AoI
 Z3WG5+Rq4RxJ2TxOvdIt5bJFy6QnqSNN+fst9DqIZNh7kPqzHtziKjTBvFpObG23wyQ7HyIr1pn
 ZXYRNwt9weBnOHhYz6p3XlTxv3FO469PqW5iopOqXMaaZJAmFWmLpEe60863J+PwnyvCI+otvLg
 lJeRvwLRJCRnp6YBexNE9Gy9oQOMRPioRy8nogkF6S5ss+wd11iDv3hSjnQA/b+GS5UHWwIc+an
 HTVZ7O+tzFs3NGsD87lw7bugVF7NmKPU1CE+mG6/m2iDM5IJ4BEECP+qgbyzuo=
X-Authority-Info-Out: v=2.4 cv=SqCdKfO0 c=1 sm=1 tr=0 ts=6afbed72
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=x7bEGLp0ZPQA:10 a=2kFROKt5_e8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=v3ZZPjhaAAAA:8 a=9Li-14qwQSEJLBuQiiEA:9
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-JNJ: AAAAAAABC4lDjXeSrz98vWgaoTEW+CwIyC+MyrLWESSPjxuu4r3QE30jwIJqyeP3MNpABI
 jVClgbqV6hPK3i6zLsApEOdWWRbOTS47n9CaJimHBzh2nDwlnU5Hd4EYl2mVL8BwAcuzua
 F9i4czwAApAET2NCKe0Amr8sHE3kW/SyZMTUsPoq1X5Xq38S1lsH0E6mcKl22NKZcQm603
 Xq14eQbSdVV70mB8doJ3V6vdsFWSiT6mnYGZqHRJNrf1ltVC8NlyWSiiJEgG7FzN7LDqAW
 gmfOQLJ2IzJu6WgGZ19Y9DXO+Qr3APJBBUgbIeeMhZaADNZAT+lhtISJY8KTHRu6Khr+SO
 U3k+9n1U41NXq66N8qF7DnDYfBi2ig1dzqAGREqd8wFS+Qw6gdxrGAOIIPBdaShqPrURD4
 /NHIZRQSwn6pH4qiVzPrxtMKMSXAukjzhSOb+WijqpwxJ7+Hh4OJaq5felEY3GxcPDYzam
 PGD6JINiRUSm4BI40QKm25E8Tplm4LfBy7+ir5u4y5bP1fL/iDuGfDM47KoOiHTy4PTRhA
 pjy80ExTrMQsKcXIJEUdg0QFGi9xSwoo+13DfQruWnHMQnumS/G59pgXI8QTJSetSe/2er
 liauSbszJryBI60/bdwNysLNOkXPYhTI1t7sTL19ulMWPTeiOK+UhgtF4EblYhkviO908U
 //Y1D/+Zm+oFGVeSGopGv241sZ1Z7raS9VOmm1tgfLI0XOqL9pFPhek2Wa2w3ckOyf7M+o
 xwFbAGXPVCdJS/4HSCBIawqTnck6fTf24XA+HoMyn23rObNEzTltGWoCkWL0axg7e97Cgf
 UGKlo7QTgBm2YuJN1zR7Th4UBMFSiZ6OSQLQUM4G1Vgp78aM2BSDMPocBZMWI18q4pwSSi
 WPFg+O2YGptYiCxd+7KiAii1EZTV6r7y+A4Yf0wX9cQtu+JNtgTKva9GU3pSJUSoaYl0Gr
 3R/Q+16OeWgBsHhe5LLixDsAFy5zIEmNQ7M1o47Vgq4B8E6mrFuXTAEQZ+JCj0hq2lLZ/g
 djYxEZ8P+kmfJnw5CsYlJGxA8xC0JZrW+6Okrn8In+r3IsNJvf17aKrIQu185RuzPDuqiH
 Ee77fUEHXtXfF4TLREdgVolD2/gSZbUAkgUzhx1MKqx1Kurb+HYZZPK+V22zXaV/PRzw8f
 GtGT3yJo6NCdSOtfDNmwh69z7Zv4e7FmsI/D+rblY9dAYuY+cDQ3hnRA583ZcR1WFXqnP/
 EUPswHmeMLH/ireMq8FZ1ukdxf0rXowNhdTyT2+KXvZSzWEVCsS2AgmsDx/npCnHmxaQSE
 wdHR/4oiSSY0DeoJMzdp8vZyaK5Mw2whiLbG+gD3OKdRe8Ya0BAXRNXWcuEGv0zOz9xwyM
 JWKD9zHv05DKtaLv/Fkunof8eDtUf35SuhJQZmR2JdsQFwuRGZaV0vcZPEsmu4wgbxBSAF
 +0K/Je/odGPfxD7xyqcAlz4B5W8espUMVax2BphV/7myDdb8bJE4Ixa2m4xiV4GNI=
X-Stat-Signature: 6c3699tc9w6dig51cnbxkirk3daj6wtd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD6AB1C0007
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794895219-561305
X-HE-Meta: U2FsdGVkX19bHqTowr4tYnWuHMEZV4kY4VSQ9isoyicZJOK/VMmMMHXpDzCgoO1E7AEo0dIyGmPcMVwilOwjVF+Bb2IVGSPYzOKMa0lRbB+1k43EKwjiMaduGWq4zs5cooMQyi7KTcW3fhkIcWZGvon6M76SMu86joPjaXYstYiUZwuMmZmSipRldFPdRQv2vuU55tw2ZgCEdGAVtsRCwG4gi3S8GPcIpfitboTBKpy0aq7yEhdKF9r8X6hCR0rsHSiVok5/WanGG73zpIIyxlxznN8wvs+9vogHdxtPM1XMC7z7QwpbkN9bAh4v+7G+6vgb7tJyS2FfgqACeyhG2dKoUqnTE1VQgCu2prMkjFs8cEuRNISqoWtXlmT7FGBps7NgbdpaLh5eff+fTmVrQB8pv09lTIAk9a6I3iHT/Lokh798SrxgTH6PRhS69XNQjS0cJ0UIF+9eCjO9gSHU8R/DXIxbiALwvsGwVsf/AgeP0z+Cgv1ytDrDIRMCjEAUOC8yGXunwzZ+22Q1aybAglQH7V17XCoQOEl4XCkHDGIiwcqsX8A8xx56jTftqEIyOwbHTrt8uWqqZlD/a83+c4mv5JIwySadP/UmtCKT1rRgWxWBGCYu9k3RUi4oaSpAoMHNMisnZKR1XAgmVyBnLAY4hXhzsstRv0bp7WdakKk9z5OiUMXuIgoDk1WGOTBPP1BejuYkA1/R4FCuQvRb8EHqAlGFIWXoG5rVWntFYeXNtscdTEmP8Q1NwVjHC01ofGCGRsy+YB9pPaYpB7oPdXnzGyszG3cDDODEo4GwTdm62r9exTOqDKegP3mW98Nrj0q8QYygGnb1SpawlAjlQK8A7Q+TdJKLcMZ3gvyB/ARtn664wE3KDOhAmHGGJJh2h0UwyBPHskei1sIJ2oXVTMCGISDOKSJau6iDcJ9eVx9JyB8CuV0TaTwcHG7UEWb0MobU7gm+lwOCgHCfC1C
 8nOA5PFp
 R431lfwinR1p6FkE48/o0JQbwidP+gGaQf7lj6FE4DMQEM3DOlKWIXCuzDt1SOeXw5b5Tbcljz+3xtD4RO/RcTyYsi9kYvgSAP7P3OhoNR31xv/beyIRdBrYzhkvnU6WqjVNroGLniBy1DJ8csm98xwRLUc7a+GAF3nsuMX4LqeNTqCOLBoAz+QV7I/rwR3HLyF8HGomPo2zZE9hgKbAmNgE1PAHlSo/nN1SXQe/s2QvYl9W9wqKWPEerhFrYR1wt18JVhwfOTRgKF66pRHvqsmONltS9K/SW+PFwkqiLN2VDiGK6HHtMfXkPgXUxypeCMltM8EFQgaf+hP8Mqlfmw9KKgvwfWoSicO6ED0QILa8YveezEsD+VRlumTmyw2LPE4v7kMbvf68uYFd5wkmOljjVVWZl0Bl8w08v111L7osftj3UD1hg10IMZYWSPI+uksRCWy0LUt+O4yUED60rjwz7RAJTwLo84kJbWhQ+utxESOHA0CvCDNh4Wk/N9wLadCQvyo4YtxhyhOTDmzQ5DEHq7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KCSAN reported a data race between dup_mm() copying oldmm via
memcpy(mm, oldmm, sizeof(*mm)) and lru_gen_del_mm() modifying
oldmm->lru_gen.list when an adjacent mm_struct on the shared
mm_list->fifo is removed under mm_list->lock.

oldmm->lru_gen and oldmm->mmlist are protected by mm_list->lock /
mmlist_lock (or updated locklessly via lru_gen_use_mm()), not
oldmm->mmap_lock. Because struct mm_struct uses __randomize_layout and
mm_init() immediately reinitializes these fields on the new mm, wrap
the memcpy() in data_race(), matching dup_vma() in mm/vma_init.c.

Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Reported-by: syzbot+c6e1b1b32ff2fc3b7d60@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c6e1b1b32ff2fc3b7d60
Signed-off-by: Muhammad Haris Awan <m.harisawan@icloud.com>
---
 kernel/fork.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d5..14ac9a070 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1539,7 +1539,12 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
 		goto fail_uprobe;
 	}
 
-	memcpy(mm, oldmm, sizeof(*mm));
+	/*
+	 * oldmm->lru_gen and oldmm->mmlist may be modified concurrently under
+	 * mm_list->lock / mmlist_lock or locklessly via lru_gen_use_mm(),
+	 * and mm_init() will immediately reinitialize them.
+	 */
+	data_race(memcpy(mm, oldmm, sizeof(*mm)));
 
 	if (!mm_init(mm, tsk)) {
 		mmap_write_unlock(oldmm);
-- 
2.56.0


