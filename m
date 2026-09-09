Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF87C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639926B008C; Wed,  9 Sep 2026 14:01:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611176B0093; Wed,  9 Sep 2026 14:01:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528B46B0096; Wed,  9 Sep 2026 14:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21E376B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:01:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 814601402D2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:01:49 +0000 (UTC)
X-FDA: 85194991938.03.20F3E86
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8FC1A10000F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:01:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=Z+r9foF6;
	spf=pass (imf14.hostedemail.com: domain of josef@toxicpanda.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788976907;
	b=uxI1XlnChxJE8zxEgt9fNCrfbtzZNjWR6+lq23JYJO+H5nVDd6D7CQHkwvZNtWgFdpQvml
	/+UMr03lCvCV2qgaTvWYBRaWDmvytaGxjEKzE8nQJIWQRn+6g1++/I9LM2mg5gxnyQJ2R5
	CuRs6OTvXqPCYA7J+xeXs2BFYKZex+w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=Z+r9foF6;
	spf=pass (imf14.hostedemail.com: domain of josef@toxicpanda.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788976907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ViCBkdbLW7JdXmtrQtir0eAwLk4ivWB6Xk+gL7SNqv4=;
	b=L0oC/Z7tL0A+nKI1BDVZbyiytthPjMzqtPAg3bpA85VpTLCXDuByd8OioSq65WwT0Vdc66
	BMQ56azev2R3D7/BplR6QWRLcksBs3FIGgVKLRkHO/6nS6M1BM8HwPcodbLGPIlXOAcZHB
	j4FjAGMBBwLBZqozxohCgR+Z2TfhDBY=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910ca6023so45151285a.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 11:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1788976906; x=1789581706; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ViCBkdbLW7JdXmtrQtir0eAwLk4ivWB6Xk+gL7SNqv4=;
        b=Z+r9foF6cOOoEZvqTdiHaPofM91UyuM/jXX8MHXeyPzqNyfJpwFm/BCHlT6jueA25y
         3PBI5JwQQiEVGzpyMcEtW9tcMM1Rd/c10DZT470aK5bd1oHCxnj58uHCOdho7OQ5M6fa
         d4kn0N30MSzgMhYDh1wPt/5AIzcwX/sS4sHREmm/CJAz/2qGK7eSifHxjh3C5w8pqPcJ
         +kOO2fo3oRMbqFNvS4HK2i4nCeMhFG6ieu4BHNa9p4NXT2HaXsfWZTkjVegqFcM2+e0W
         fHdEvhub1jeqbO1tJT37Avn4d3pSq9Mz4YvRXX1kKY4HBe160evmdnlZ9cxBJiRat8Vg
         QgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976906; x=1789581706;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ViCBkdbLW7JdXmtrQtir0eAwLk4ivWB6Xk+gL7SNqv4=;
        b=b3UHq1GIqWp8C0hTK4j2/4aKe0jDKlF0AW+ic8eOIxauZZA5X38BXDTy+vzbdyjznG
         Y7wArTF3YtnY9uCl4sb7rGnlG0v6/JqTUKz4IZ/mFgO8JIuEMuAtbxpGvLpNnX4dx1ll
         pnKODaGQ5FH97GrSYIkvnD64TcwL52nU+nbi1PV7fmipiRC8xFZ1bsuzDAwbZqpOmdVU
         X1qjiGXFcL3+nPZd2Sg/Fq29DAWIyTleIPSQNa3ZuCn4j1VkkQJIvcaj+z5fBNeiSXEf
         L31P66tcb20r0g7RbOWCPCEENeZj/oBz7EQxWTW67j/GuCr+sgsw2ILO0r+sQSpVoM0u
         V8Cw==
X-Forwarded-Encrypted: i=1; AKwUvByIsM/lFVFjmbfIP2OTyzprTsNYTszgbYEE+lXbmIaqBAShjH2cHl/N2A2pjH4EON+zteZ6k6XsTA==@kvack.org
X-Gm-Message-State: AFuF++kjID+VsafauGwGkoRUO5m2T876inF2c3AUtD5WjEJiYHf2Zcaa
	peC/bFEvi8e9V4gAwTKLRnXBwlwENbtJdifFiDQtFtZtw5HzqLbA26tBMdQL49YwrXw=
X-Gm-Gg: AYBFou1byfJsjVd7ADvx+Gz1puu/0Au+WaK3U2fdc6eGCX1YIq0T7hf9tCAX5Ilg0/t
	tcwxGs6ry+eZ/U3vqC59R1XnN1u9XhJYzhi7K/xokaxL4/vTqeqFfg34r+lTf7Q89H7Wwk0zdD2
	NAL8hbjy9tjKuI2EMtzWdSf4i+WLjvyReNUseVgzb6220gvbBFRT+mww6xM9eEoDazUY8NhowcJ
	aw/EVJJz8rT51pzY/VZjv8l6av4CsZHX8HZpZHFjkFvJyJ2a4WqJUXh4bDttjNeJSvtuZflXyWl
	Msgwd4ejmhP28w8G8TsYpEEwB8RvV7+KfW/LLV/1L9IMWTfr6Y6xilEujTIObkaTrjRh05BzUML
	Iq6/zVNhs/aY55tB73tfhRRfvUmXrGOSFHlG27GOM2Q6DxTvD5PUtwoKbvFndJqE2zVmtcfRoQ+
	LM8VH6eqG+K0iVuiVXEyJLSomDCXZLiFu8xCkanPYxqNRXZC8aSBwNpVpnsJi3rkfp9RYmKow/z
	wPUKvAfrFogCOxERyRcw668tzw7TLzStyVzXzaO3W61QsXB2OJUrR6T
X-Received: by 2002:a05:620a:3941:b0:92e:4927:2002 with SMTP id af79cd13be357-939d4a8ebb0mr452910285a.39.1788976906226;
        Wed, 09 Sep 2026 11:01:46 -0700 (PDT)
Received: from toxicpanda.com (ec2-34-228-114-98.compute-1.amazonaws.com. [34.228.114.98])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9398c498610sm1295435685a.43.2026.09.09.11.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 11:01:45 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 09 Sep 2026 18:01:07 +0000
Subject: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb
 drain pass
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
X-B4-Tracking: v=1; b=H4sIAOKeoWoC/yWMTQ6CMBBGr0Jm7SRtISZ4FeNiWgaoxqozRUkId
 7fV5ft+3gbKElnh1Gwg/I4aH6mAPTQQZkoTYxwKgzPuaHrTY5g+HjPpTVHCgi/FzrWdLeXYsoX
 yewqPcf05z5c/6+KvHHIV1YUnZfRCKcw1upNmFtj3L1UhlqWOAAAA
X-Change-ID: 20260909-cgwb-tasks-rcu-qs-42341609f3e1
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
 Tejun Heo <tj@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Dennis Zhou <dennis@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8FC1A10000F
X-Stat-Signature: uo3mh1xrt71ma7ck5dewuen13gx9q4or
X-HE-Tag: 1788976907-221536
X-HE-Meta: U2FsdGVkX196PnbB9sBup5TPNWsH1b4+dB/aJ6k/BtffpasJFtgaN7u0Z3Ez/0uCgITarb0VGMjrzPNuYo21dzAWiRrrxK9I1DcU6jrYTEOaUPRYvKd+xX5sRl69zshVI4o1/PqisXiZ/2ka889+NPdUNozkVo4VB2Fw7/sJvktq4Kmar6g9+WBQkmOghmiO0hiGYXbCZPC8b4MV+qKYk0ufbhSPhg9BtluPB9TsYTRwWhIQjbry2/AZnNhSyRs9Miahs1Z3PzI1fOEWHT6gXqlIHqbfmQKpOgmZHQCYaxAgxmh6CQqoFDw+fpRDvVBYXSw/wVzioozLxZTSU2IKMyVfYqdk1gSXVx6I/2Hr758ZgHqPhVGXzGYFSo95m1t8kszRNs4TwIj32Qa4xoqTihetwqYaa8Crci8D37tw+2wS+RrMpnIJcDhqsdwG3jhp6CVVjy8era6i8FTRLS7Jx/3ngmMXpaQmnN2a5DXhT1QbUHxiBInRzJkeQHjhPvi8/mVZzzZlP1sbZQviJJ9Am1Pu0WMvaTOPy2iCpZQ1VAiQ9Sfz4yyRvitl29B5qal6DeIW9bF3IReU8XoVMlLKTO86WYhfSdunLjXlp5lWKaZQqPweZaqKGraCFTUoxNo+DEIM5oA4asmydJiY9A1svqo/5l2toN4otfcPB1MTErkXapR/Md4W7RCAiJ5X+hVA3UN6AZixUlSz/FzPBa7iF6NpEQSdKKMw6ewkfYPobyj6A3OfI5/LKU/Ypuyg8BIaIGVjZ7mTCqFpow2bhyu2Cay7Cr2eApHyRSlaVU8G5PlcdkmvrWkTfItCpM+06qKQE8/++lnXpkFEUuRy3DPv2HkQebpRAgRF76sfFwF8SEMiMBt8dY401xDmgzbhenhgsMDei4KiTV8fcLM8G3e8qc3rZZ5CiX2dxbjHqvu3HpLOSR77QI5GmLPSMl9SeduuMxk4kmLNr+De1U5QeBd
 IX/LUfKV
 InsUfTqK1XpJCr2a2AqG0xYlJtv1jlYl3Mg9Ihze8ojB7YCwUxrWU41BGZGeTlhIRmGqeau8ZJMvscRzg3Bbx3eCqffsh0zXia4zSzYIyacHR9XWvAs523kruloEu01eq4dOg7+2dBoTDcF9APEAgZhiod4PFwHb4rXtPqGS/Gg97R+jx0qIikRyLk7+Iig20+YU3Ro9JTdRhxXMUsE7uKPlcsi+2cgXP3O8TdiyGcgcDfjxgbXxClMKvu3Bjsvk3xycPH/sRfn91/pcv+WTvWE8sf+wUZwCtgYDf4ZDz5RNTYaE0Wgwebv4BKjZ7gYNluRddihwrLv2f33aIQPdTm/K3qWtmeY0xIs/OHB9GJ2auBszWCkfE7eNqBIVFXAbX0gXUgXNTbTP4Kb43vaoCShXN6eyL2SBYzmby5Xd8It6nJdZyt5pGPUu2ghJgh3WqJosI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cleanup_offline_cgwbs_workfn() drains a dying cgwb by calling
cleanup_offline_cgwb() until it returns false, with a cond_resched()
between passes.  On a CONFIG_PREEMPTION kernel that cond_resched() does
nothing: _cond_resched() is a plain "return 0", and under
PREEMPT_DYNAMIC the full and lazy modes disable it.  Since commit
7dadeaa6e851 ("sched: Further restrict the preemption modes") those are
the only two models on the architectures with PREEMPT_LAZY support,
arm64 and x86 among them, so the drain loop never reports a Tasks-RCU
quiescent state.

A worker draining a cgwb with millions of attached inodes runs for
minutes.  On a 6.18 arm64 host in lazy mode the cgwb worker drained one
dying cgroup's writeback domain for over 11 minutes.  A BPF program
unlink (bpf_trampoline_unlink_prog -> bpf_trampoline_update ->
unregister_ftrace_direct -> ftrace_shutdown -> synchronize_rcu_tasks())
waited on that grace period while holding the trampoline mutex, 42
tasks queued behind it in D state, and the hung task detector fired at
614 s and panicked the host.  Any BPF or ftrace detach during a long
drain inherits the drain's length.

Fix this by calling cond_resched_tasks_rcu_qs() so we do not stall out
anybody who calls sycnrhonize_rcu_tasks().  We put this in a do { } while
loop because if we have many small cgroups cleanup_offline_cgwb() will
return false and we will never call cond_resched_tasks_rcu_qs(), creating
the same problem.

Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/9d444098-7c03-4163-af12-bd0a79a51443@paulmck-laptop/
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/backing-dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index cecbcf9060a6..18e999053bae 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -910,8 +910,9 @@ static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
 			continue;
 
 		spin_unlock_irq(&cgwb_lock);
-		while (cleanup_offline_cgwb(wb))
-			cond_resched();
+		do {
+			cond_resched_tasks_rcu_qs();
+		} while (cleanup_offline_cgwb(wb));
 		spin_lock_irq(&cgwb_lock);
 
 		wb_put(wb);

---
base-commit: 893e11787f78e43b534e252249ac3fff4d1333f8
change-id: 20260909-cgwb-tasks-rcu-qs-42341609f3e1

Best regards,
--  
Josef Bacik <josef@toxicpanda.com>


