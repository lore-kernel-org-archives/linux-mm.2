Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C53C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 22:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38ABB6B0096; Tue, 14 Jul 2026 18:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33AA96B0098; Tue, 14 Jul 2026 18:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2514E6B0099; Tue, 14 Jul 2026 18:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB3606B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:21:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6085D1604A1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:21:47 +0000 (UTC)
X-FDA: 84988805454.22.B385266
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8829DC000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:21:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MDVe6QH0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784067705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6UyZtJMGWyTXwkf9Ut71gXKM+acqkuQS9WqdrHTITA=;
	b=JfXPZ9dt59b0R2kAkbRJDuQQxStQJGrDj8uMrZO+bcnDn1HwP/oQAqUeBklTUEohUfAsFz
	041PjbtEgJtWROgLu8EZdIuMOl8HCZc53K1tmKgZlolDSkJNWOe9COFsqFHY6kIrNLxO38
	38+JMzWXv12CiZDwzuUvxlnzVvAJrSE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MDVe6QH0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784067705;
	b=Mi41JXTLMfKUYlXA3zEI6IvwQ2GSo0r5+7/sSpGC/pTHAa3J7exsX8kqr27g+nxTGSbIqF
	lcU68LvjXkausD7rPpe2UlOA0+INNAmBHB8cirbMIPOnAHZo9covUiJfDcTO+FPawkUl2e
	GUc9r/H5oOWSjGnN2EYbj3cO8lP7MTc=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-848643382fcso5402544b3a.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784067704; x=1784672504; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=O6UyZtJMGWyTXwkf9Ut71gXKM+acqkuQS9WqdrHTITA=;
        b=MDVe6QH0zCRq/4s76U14F0JKKnJiDKkzNZZl57uae1wnS1bSW81pwEob6koM336sPs
         VNigJ47KzSh70eqTGt9xY1CsImqMVDclRSOXPwRqmETrYlmpBR12wG2n7xwZA0soKCkW
         pqtbzyv/b19VhsHpU9BMI3i5qx/Ai929yLKJvjwpTw4zvv2zuuknD6QYLtX9rCRMQGeN
         8YZRcYLwmI1rEnEMyAT0ki1cqMEnQkMNWkssPwpdghkpzRtyJ8/IHw6px783CrVAypri
         etWsByVmLydo1Er1XcAussNJA1OmXlrqe6qLdRdCNGP16yaoktUTvI1VK92CsCsm2BLK
         ZhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784067704; x=1784672504;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O6UyZtJMGWyTXwkf9Ut71gXKM+acqkuQS9WqdrHTITA=;
        b=rFnQAnnlIOOvKSSr3yFT3ZZD/ueyx00tjhNwWrPITyjinxIylQa3pRzTi67NA2rwFq
         erSa3BuZmlTRO5EyJJq7OLBAxzcHIWnWzfylHriywwXy1YooWVZRBgK2KGJhx0178403
         hKWS7koe18uRZnne65IWV+chffeSodlbvV3yHo1t6H4/0rfgSmBphl2mPnRlW2qWejb9
         knQj4p4FcWG/8j7EvvSvYGg03x5ZDYweM57fjhrxmG+HLVcAlxCemzfym0p94/RBHp4u
         YJZwPvFM8JV4ouRNT+JWY8I01qUBXO4hhmp5uqKXkKJRn7bEqGuE8rXy79vTsmfUzSBj
         vpig==
X-Forwarded-Encrypted: i=1; AHgh+RrwsewEeAF0yEHhnwKQiJsUi2xLhJHIA8Qi7JOIg1pRStAPYLxNY02mFmPqBgUuuu7BnPlf7IWw9w==@kvack.org
X-Gm-Message-State: AOJu0Yw5niPOzuolkm6fLAEuiiwLt2naimCkFXoUTv8NevwePwCM2sbb
	MVdnVt873uJ1RZ2DwH9eKQWY/G7njevMCp42JE5sDcqjIq9ZWZUVN0PL
X-Gm-Gg: AfdE7cm5fQl54e4UxjEi4bPvgtHbRIqoDNlrTx2trmC3lmTnc3lrnP0FijWfryWbb90
	RO4dKmGscioG2IlH6J9T3zc8Fq18GLrTjIVPXEzo25LtbZEmEcX3/O+wriGGjzovNRa79FsXc1q
	H3HIh6Cg0UWABkfoOJxojs96bki3mXD0Tv1feS5kc1DV4nQsbl56PrgseA0CrDpd87JhM15F2sF
	6oXcYt4zy8X13y3ihMENmQXh+9vs470DTdry1B9uk9aR94aEbXXidh7NGjnEIxP4r6rVkcnSGof
	dM9vmUnpBGqNViTQigiIxzalXUWtHsTvz2Gnikcy0kG4HXThUVUiDV66CpapSP12po+9LXgSZYI
	Z7+EJwWJjBFpsgcsGwf+m2b2f3ZwB04iD5fRPMtaojoPWpioho9+y7Ro1pQWpzZZCOkCyZy9EpB
	jH7XP6tmrVLqERUR7JIXT8rd5m8GV+1DRUBN4Ho1EgY90z1MsIGZ/xE07Eb54=
X-Received: by 2002:a05:6a00:1819:b0:848:4742:90a6 with SMTP id d2e1a72fcca58-84a5140d4b5mr4845081b3a.15.1784067704431;
        Tue, 14 Jul 2026 15:21:44 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4ff2ea4csm2010807b3a.23.2026.07.14.15.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 15:21:44 -0700 (PDT)
Subject: [PATCH v2 3/4] fixup! accel/amdxdna: use
 hmm_range_fault_unlocked_timeout() for range population
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, jgg@ziepe.ca,
 kees@kernel.org, leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com,
 ljs@kernel.org, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 14 Jul 2026 15:21:42 -0700
Message-ID: <178406770278.1106335.17232929459598625570.stgit@skinsburskii>
In-Reply-To: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8829DC000A
X-Stat-Signature: h8q5miqgiyi8351akw3thxxpz587jxxj
X-Rspam-User: 
X-HE-Tag: 1784067705-593470
X-HE-Meta: U2FsdGVkX1/sEXqg6YZMKsa2uLhWssU9JFzilPRnlQcAkD14M+bgT+YOGvOYSR7LJ1oQWDG1BTUZP2AN/EWSNKyrRl2vYMNKyIBc44AoJIQoIGL06KKzXpzQe6ZVvUrh5gn9f0gJPHYG6IbLGcw03kXkH1hRZ6dsByxsCMleJil71L0C85u7VyBDwEAS+VbGBHaKVlMKzlYEfSl8xslL5mTfRv8sm9tsjpHxyeGN/KXtIq1ZEP9rRS/ID8MfJ8Ab8CsF7JQJ8ru0rN5XwfRMyOcSQ7aySC/65rATGNd9/Q/CYhww7wtxnhA9rj93MS9wLYOhs+7PbZeRToxkK/2ew+ft0vTCwlptbSklUSUUaGlL/lh+yeDQVGdMbIHarSNy/waRFkWlJz2e3sHAVwW5kqJjqsF1sCMOXE0k5zRa2H2Q/uKjpc5fODW39tcNq8Kdxth0vOeSd51paYDo7wfvs8rKqX2vwieQyVMUhMiR8pJ6Sp/BPmyDRhECVWZW0PDUEFqXzB/RW0zJunvxUhzFctBfK7/Q0rhy+EUyuXx1ZYec7SezxEubAvnDnAslGbKwI/vbShgm8bI7BRzGAxpJ1yeitxF5kSVgFYlrwQXdhoBIfiyrbVQEtx6n8BixIPXvDfycuOhXSU9WhLLhSOVcdLigx0RZeegHlBCEMcfdPhkE342yk4loQN1r3TNJ5Z71RIqDPYRqWMekXpB9uT0E/ibPH3BoZAh2i2hEIahhxnuhZAZC5FYqN+DPuDoEhsRfxZDe/sfowUq1MofJT2/vdqR/3+jGxS/wDTqmShM4dhS9MPRdRpQ6XJ4V8+q3POeZebqLjp4fiCzwA1fieYJqd+JCgox/4UcTq5d7OFj1WYR7vE1EapgebUiLDl5HvASVve5bjkrU8DTYEP/ipM0C0GMDIkfYby+iKo13FBujwzvmU8Q5p+Pr+R3mKPnBGEXCvtkFLCQXuzc1oi7d94r
 2H/Beb7R
 eMJfqN78VZqZzH9+s5z/1xBf+IFYt6tz3J45uNIVwjnZiOYq2NijhcwgPqWOnrlATzh/EwXLGAGLxTqD/FSLOGRKJgIy8FYzrg+UHjREbNaun/DVD8SKvIUApBgLx9AhFTzKYardom5Hk/lHoDGKPoVtcBgMhWTlY771FTxfTIoBdiEK10MbYiYBOVsOHsn4+dyxO07B5g8NcIY8qqM732zHfnAMeaIP/5wvU7/CHqi9pbKuyPd0XelKoif7Y+YAErLQcVMzQJlMXCrLIqH50uXLQd0G21Ndmu93gqbSLep+AUDgay4jI/G3OfwSEZS7WT4iKs0a9MuukzuW5NzcRK9RcJC2+/cHNKF7FziHdG6ZZ94g5g++rR2lxk+qP4kyfhoATbLTJ1h6JymFJE2dwAH9Q6L6FO2EgDBP8LqRigtw/ztkQk6Hv8KZSKl1BFA/IT0PAjwebPNVY8Z85Nr15MeQlI4lUSMXgY2NGi/hjknMCviys5i2dmLep8ScxWXDudIex7+8hFl2gUzJD/jR34DyzcaLaEvvyLSUAgx0MFAAE5hxzxv7VVfKWuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

aie2_populate_range() now uses hmm_range_fault_unlocked_timeout() to let
HMM own mmap_lock acquisition and retry handling while populating an
invalid user mapping. The timeout passed to that helper is a relative
HMM retry budget, not an absolute deadline.

Pass HMM_RANGE_DEFAULT_TIMEOUT directly to the HMM helper instead of
computing the remaining time from a local absolute deadline. The broader
command submission path still keeps its existing timeout around repeated
range population attempts, while each HMM fault attempt receives a fresh
retry budget for HMM's internal mmu-notifier retries.

Keep the existing driver-visible timeout errno by translating -EBUSY
from hmm_range_fault_unlocked_timeout() to -ETIME on return.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/accel/amdxdna/aie2_ctx.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 548ba4315554..21f2817751f9 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -1037,7 +1037,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	bool found;
 	int ret;
 
-	timeout = jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 again:
 	found = false;
 	down_write(&xdna->notifier_lock);
@@ -1062,13 +1062,9 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 		return -EFAULT;
 	}
 
-	ret = hmm_range_fault_unlocked_timeout(&mapp->range,
-			max_t(long, timeout - jiffies, 1));
-	if (ret) {
-		if (ret == -EBUSY)
-			ret = -ETIME;
+	ret = hmm_range_fault_unlocked_timeout(&mapp->range, timeout);
+	if (ret)
 		goto put_mm;
-	}
 
 	down_write(&xdna->notifier_lock);
 	if (mmu_interval_read_retry(&mapp->notifier, mapp->range.notifier_seq)) {
@@ -1086,7 +1082,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 put_mm:
 	amdxdna_umap_put(mapp);
 	mmput(mm);
-	return ret;
+	return ret == -EBUSY ? -ETIME : ret;
 }
 
 int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job, u64 *seq)



