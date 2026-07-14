Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E536AC44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4896B00A4; Tue, 14 Jul 2026 16:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB6B6B00A5; Tue, 14 Jul 2026 16:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96D46B00A6; Tue, 14 Jul 2026 16:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1E076B00A4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:13:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C507A05BF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:13:51 +0000 (UTC)
X-FDA: 84988483062.02.83C72B5
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4543C40004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:13:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="J4wbf/Ym";
	spf=pass (imf12.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784060029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d214MLGyf83e1Jqi9SjyzgCBFipAoJ9SSnt0shamnDY=;
	b=vg+Aq3Js8S/E39daVehIHRFT11ZsIenPthJlbb74RB6SjIBlCIGAgqbN+0Yfp4gGSTfKJN
	iJsEYhhuXkzuKZhvuGdKx3PCj65jKUtzDF0Q7Kx5bJ/WZoY4ATJS59N4M1D53DnlHaiRL8
	oHfW9XM97Kop2k19iWbmGJXIY8Ik+OM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="J4wbf/Ym";
	spf=pass (imf12.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784060029;
	b=KnZcDURy8yPEi9iUHvh7clUJmtyV4c01+OiYNIWyoc9vaJLYNhMyAOJ/2qXigFYKIGNpCC
	b8LLzrQyBjslABfHY2uho/K5lGDolvQ7GQvoRuVNVW7RBPJPYGC+fB8gwo0v/cEAlmpbIH
	tcdrtulNRPYIG86kzAAI3ftjvEF98YM=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cc73e322dbso56087165ad.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784060028; x=1784664828; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=d214MLGyf83e1Jqi9SjyzgCBFipAoJ9SSnt0shamnDY=;
        b=J4wbf/YmgzE/gFUDgPKMOMe/+QJ/Z8pyt+xDgOR4XHPvufnuyJ/rUzKJXmTnBWghaJ
         DJ2yy0a0Gd5M6xe5ejogl6jjeOiSg4x3nHb+FXSW1M/W1P19ISK4UNFv8nQVT7A/OECD
         ANrNit8/oJqcyzLU0u7FVCAsqLMVg3KPt7sZNu+QOZ79LylQrfjmfwTSNonHfbopO3fi
         w9eWf3n5rjIIR4gYgXnAmTJserb1d8lSvU7a7j2cEN5MhTdcyMJ4BWz0UTnyjB+v6c1F
         MN7PJEu5ccN+iNCyiTA+Hbns/jJLlxo/OVqRPfXIDI6vI412M1+d3Ifv4n3IBwEGhGew
         HW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784060028; x=1784664828;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d214MLGyf83e1Jqi9SjyzgCBFipAoJ9SSnt0shamnDY=;
        b=CiCYTCfs2sk2WE7D6fEppsOWRTQO/l8UdCeufWoz/C/NbsYseUSlAYNcDqSpYh/F5m
         9aWJgpIiaWNi6xBsFYyqy88+69/KNCEFYx970RSk5cp5/m3KJJCtX6lrp/OJ0yFKREEu
         XSvQv32LJ/7iGLqRLPYbSkToqOn5kYpOiB+rpnggOi/3635gaTlcZCYLm0A2RUVx8HDf
         fbgP5In59ABVU8NSSeI6tYxyhAY35uKceMCA/uDrqa0TToMe8GSy6Sh+gw8pPqTFWBfO
         9stVKbAgJs+ENpA9yQHs/Ku+TtcbQgJXoxvX5TSoJgmj1I87teHswoB7oNJIrOJRUh/V
         Q3/g==
X-Forwarded-Encrypted: i=1; AHgh+RrqGxqrVMjzGTW82LGP0vWxVOSjwpg3g42kH4EkLtAUip8zu111TkLagYjdYUBZB+SbI+64zJhUuA==@kvack.org
X-Gm-Message-State: AOJu0Yy4VO7DYVNkQxGmCvelzSkjTs6/YDlhBQggceREv7xNH1zsE+Ia
	3b6d/nlDDljI0b1p0AlpKTU+Q5WWd3uh7sJ/lG2UrTjWjnRRSUcjTAs5
X-Gm-Gg: AfdE7cmGAb3Net1igiAMSd21BlqsYYWFaFXMe/qD+uNON8mxjJ9gegyIT2/TKiERaWh
	rKvDBySXIyi59YyVgPCSZX1IBklMc15L6FeF2hPUdY2AvKo4iS1ry/EHxVGuWeoiuGcqqNxpE1l
	qOulZNYSrC4oePJ0NivcaMdVNNIO7+JeDJCcM1YrInAutSN9uKRBEkaH7pw3iJuKf0hI6nPkr44
	D5wOs/q3YQtTBYGyHIGRl+WFxdP8kiawqXq/NfveheBSmTgIa++mSmsV8tptAYfEWZtdNdiH8VV
	HBww5yrU9QC9Cm769h+Ax85l9Y8g4Hd5Vtkl3K2JdDoxLyWiGNopY0p0ObOQlL7JzEkly2MgKwG
	pods2SVRcS6yu41l41zA0LMGwALvwhxZX1sF85vcUTwDGFG1e/8dPVOAFDgy8zrZIiR29kidm2x
	szSXcf2mw3Y2F1jdGyzTb2pntxBY0r2LHYKK3ly+urhCbyYG40E1x0fnxMu0w=
X-Received: by 2002:a17:902:d591:b0:2ca:c68:c554 with SMTP id d9443c01a7336-2ce9f15d1f6mr140607525ad.38.1784060028032;
        Tue, 14 Jul 2026 13:13:48 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d3d45csm120844995ad.62.2026.07.14.13.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 13:13:47 -0700 (PDT)
Subject: [PATCH 3/4] fixup! accel/amdxdna: use
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
Date: Tue, 14 Jul 2026 13:13:46 -0700
Message-ID: <178406002613.1082778.11295976907808029605.stgit@skinsburskii>
In-Reply-To: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
References: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4543C40004
X-Stat-Signature: z6rwzjk4p3bmw7yqcgwwh5qimqfxsuuz
X-HE-Tag: 1784060029-736348
X-HE-Meta: U2FsdGVkX1/rswvF+0cTcugtHqQrSy/d/gZKsXpN6TvbkrrVoWRITkt4gD/OiSb+mrvb0oQ9HfnUiR94CEPNNonfRKi23fLgbyneUdx3ObQk4F1DKvzbCXjmX45d+C8rzxJE4NTUr2DrGewQPFK3iLD2f6xIsCn3kLzRl3bZUc6tiqIcqm9ehH9leGKfS5uQweQa4GJYhHXBKzq4FrVURsZ71f6cRcab8qyWflkiaACpgozwBN0LpN1FM4KQfJmswps1XfS+3BtNPISMZ6OqH11w/oPmQXl8vjvPHvqvJU6YlcoIve1woRpASYxRpjyMPDZA7k23VOwU/cr1lewpyJNSrxD3Up0Wd/pJBvpOpNEJ2+HzTS39ZvewGLQNT/h0WJ/1LrHZDbH9c7Ynph/YN+hEZ1Mb7av8eHeMdKfvRUJepbGWUBTBSB7NHxdoup2zVCZksotCcUDZlwLD2CQL9YI0Kt9aIh70aXVuBN7FP/KoW6S1akqRXoYGCYOVZT/EIhyY6izd9XyX+dewP5cQ/CW1CNirCh/h8fnc2i/v69XXVT5N9k/ZRPBhon6tFnqdDhJrXtOazTolJrCWZ9tWvyo+PjEs5QH6U+lodyY4Qwllaqqz2V8CGvB1Nwx8Q3rLFDhwOdf2zM4A4MrPZrmjUnbek3jzBMMnnqQJo2Pp46DNH+XcFiTmPUibXxTRZoSXFxEfXMyqrVfNK8hMWROLNaME+scTXjN3lGBx/OAwzhm4maNhXL8OdM48Z0t2NWpN0saVU5uN7c6bDsRHi3BTRcbap35h73R4nZmVWFyrweAfKvRrUVTMHmxo2Bh9EKoLn2aBCid896AjnEx1wWBWnXIa/9ZrpuoYqjkmN31fsZBnaN6eIfiDyEs3+w32VK61ONHciKhBPLiMAOXKHKQo57QdsVAaI8LEqkBUQqnCOYglIvnJDazRRCV2W5s3QAkscmdSzRXt3/OCtdxqzdF
 3M40695z
 EI0rctkPBgZrwz/NzsLGb67iHA8K8XBBadqAJ7FBIzWF8GMa7F9F5oEXf6jwpbUiuEhtF6Pl/FHXAXnkHHju7zmq67stqnS0cLE3GkriLipK9zrwYLEDDrwpBZ06k4VjXfLKYlfCk9Y/Sco4IJHE4ZJe7dEDJc5iI7ClbdavuC0NMtiJsnruy4yPnluxUHhrc/2zo6idBwPYZcH5PHQ9JEoJZYavK+Jl2A3ibJOj/PoGEl0n4feUN/G4dkKXvmll7Cp2DzX9OPpY+Wt+7WgJgmOH26CfvhR8ZyNoFONIxi+jNk95UANGjGOuYVenfUMuc/IqNvbNZL7WL5pv4y/WnC0tAlldrqJw5bGjog15PtcMhbqn+Ebtn72pbhLA0vulOF92mDml6yeAvADAAdPougoAa7/LHaDwihQvYxgu5YNNUKbWy2yEtUMKi1FbcblqEMV4u+uVCwAXvfLcweki5Chn3Uw3qA/Q0XIl5Md5Rko7yX581xsX99GzuMfogx5uXu03x1bqk0DTP1RfZOJ5VaFHVpisEWVGR40+hgVO+rGRJdC8Ilr/6n+ChFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nouveau_range_fault() now uses hmm_range_fault_unlocked_timeout() for
the HMM fault path. The timeout passed to that helper is meant to bound
HMM's internal mmu-notifier retry loop, not the whole nouveau retry loop
around mmu_interval_read_retry().

Pass the full relative HMM_RANGE_DEFAULT_TIMEOUT value to
hmm_range_fault_unlocked_timeout() on each attempt, and retry from the
nouveau-side mmu_interval_read_retry() check with a fresh HMM retry
budget. This lets HMM continue when it has made progress, while still
preserving a timeout for repeated notifier invalidation retries inside
one HMM fault attempt.

This also removes the open-coded absolute deadline and remaining-time
calculation from nouveau_range_fault().

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



