Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1947606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YA87xbDY
Received: by kanga.kvack.org (Postfix)
	id BA55D6B0829; Tue, 27 Oct 2026 12:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F256B082B; Tue, 27 Oct 2026 12:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E186B082C; Tue, 27 Oct 2026 12:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 811AB6B0829
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:14:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C49C140A5A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:14:45 +0000 (UTC)
X-FDA: 85368904530.12.F90D46A
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4922AC000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:14:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YA87xbDY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mh1RMsnqXeQn3jeCo8IP85tEqAtoIfacyuqQryaWR/c=;
	b=EpNTSskEzEytzq0/dgTxedGZKfBTlNRkPVUQDbeIH5CTh2kL3vkW7Pd15syurtPvlc3mTZ
	R0EYKxgQNZe9UGKB1Kc5vnrje4nW2HkpaBC9DQx8jGn16fSPkQExVaE133/2R2cFNVeD+p
	7lA4DM6vYDZWXPD1JiAgzvcFbD+kLiI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YA87xbDY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117683;
	b=ZwcMJ+lsjcaGockbfnoPTScFjt7cwwNZ6ySfAu8CrZevDErjKSN6koq/LI3CD9+spw48QS
	pORsrYrf+DR0M+Am/7IF59Yg5oMJPnc2rSotbjnsf0zOi0PFo5keZzDf5SGOsZC6MzbqHW
	NWWO4ldhpX7zsbuSQqXPgP6Z3m+Vz3c=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-89f639ba307so27962b3a.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117682; x=1793722482; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mh1RMsnqXeQn3jeCo8IP85tEqAtoIfacyuqQryaWR/c=;
        b=YA87xbDYTYMao41B1Z5uJAUojMfbz8dvEsZYdDvO7ydxmP5mUl2VRBrRy6xlQ9cfQf
         cYKG68VQ6V7YsxC+Q4VKTGNy5MKiqnEYiomGMR9YY9iAQWVYk7Cx+OQBb+f/QSk6LT51
         yBUTGUikgx+XP3j9nvgu8NxQohaPt9x/lq0CZrMCrX/gme7jhfKtiXAYL6p3Lf01mCEg
         q+qQ4CUb+QYIdpkj9wakhcCviRNmXo03hxRNxW4Mq97hsv5bJeJ9CUNnScCLtUNp/G2i
         oAhoXHjwZKxIe/hLr/gqCMg3BJyc41dE4cP32nHFWRhGOzpJapIJG1P5VueWhApvcOfg
         z5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117682; x=1793722482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mh1RMsnqXeQn3jeCo8IP85tEqAtoIfacyuqQryaWR/c=;
        b=cTqhMn3Ye1x/puNOxV4e+i+jzgQgJOViMVoqjw5P2Bw3MAmbtrmIxVm42lHKaHPPrC
         FLvsCEp/0LZtnpQ7hfV0uZb2+V+B2drFSybGk5N/TuBI+xYF/d61LHV5RYXWcTk5T8vt
         0mDQh0SHy793fQs7wC70xc/pr/SMqNErRxMR0we4y0600JzjZw6fn5lvo8fZTtgqG8uO
         gbDH9b2snJ1zW0coEeoPJ2LA0CnYJMl8W7qvJwwfDmAfDEzvo90ZujZm3YWyj6e4wbM7
         X64hZAj7SCoDxTfKx6MepnLb4P/w1YTczgFyFeRN+Iettl5JuGjkivTFJ8GTl22jeEsq
         E8lw==
X-Gm-Message-State: AFq9FYIrJ/JITQU8FpZiyFTpIVZ0ZJemztkANvQPBAEwMwJPQVW4QT8O
	WxOuSdonS6py87TMpCEfh1LVUL4Df4OdFHjA3+XUT6SD/OEiUZhVCOBN8yq/9Q==
X-Gm-Gg: AYBFou3+hbj/xZ4Qe9goSO8I7TDci82UvzM9LzcLvq7xhlXbk2moTlAdMP5lPNtF5uk
	T6sIRa5UETp/JhYPe4tyC7DVGr9PLGZ8KrxX6Gcy80Y3PbgqsHlpIM4za5tcvO0W4iJTItVLImI
	Q0UpF4Ney5itmc/iArCPCHQ47UQw0Khwyrz/mKRR1qvFXsuyLjpjFxBdiXZRmrH6600edf6EZtp
	MFWndcN3N/cNaZEsM25GQCMtgsmGoaagZuncA7gVHO1FamfPlVoCfHztzfqdCRzoAnS52hP67Nz
	oFa0E/mZOudbx3s7Rfkw2sF0wmegHDt9bEQ5umAkzy2i2lAoHVEU7mr8LiUyCkxJAqITT/JJ1vV
	b+69ZswNPtINhVcG8mKoI0BEq2HnMyO/AEflvx98TvkVfxk7JEOidw231yWVw82MU/xjo2x3i22
	GS/fBJORJVcELQCP4hXspc79sFyf1jBdq6QoBcfbe1pTHPwsBYrr5aPyzg8JXgcs7ZAmJzFAXEX
	PNHG0CZVW26QS4xZk0ISv7hved0PTVejScegkRuWG+Eiuc6YNfxvTBcxH9THA1N75nFi31kuv11
	1YR3WoJW2xblU5aywzRSBkDJNbpglIpe61wXIMXnrORf53t/ivjzp7l+U82e1IyLpi2+zg==
X-Received: by 2002:a05:6a21:1bc7:b0:3e2:9025:5c50 with SMTP id adf61e73a8af0-3e7bfa34054mr7840427637.24.1793117682133;
        Tue, 27 Oct 2026 09:14:42 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8cccbf9a3sm2976375a12.24.2026.10.27.09.14.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:14:41 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 18/18] mm/swap: redistribute queue readers after membership changes
Date: Wed, 28 Oct 2026 00:14:14 +0800
Message-ID: <fdfe5fac0d5b73f5b93424070bfcc8290d1c7902.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4922AC000E
X-Stat-Signature: nwggfn1sgecjwuc77dr46bk6m53be7sf
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793117683-755510
X-HE-Meta: U2FsdGVkX19ICVA9ELQpwUFdpnwjCUX0gpMd1iRyZS3HwcG9Nijgq8Ad0JuFUDKwRjKK15W/y72eubHAm/H8AMg0bVaVW6X1OpGBss9B9yRaUhRRgQXKxN8cyaLeXmMxmQR6WiwV4+6oxXCv6MTtQieYUkL07WP5N1MdxlyOH8/sXDHvsTPNRU8h3odEF7KjzJ/OYWuItkmzmKxVMBkKw2TI4SJf6KFsXOsoMUWFYm572j+ahSQRBbskhltPlVQtOh4aWC26UOojAV78LgY2C9jNs+6qTujaF3KY9QTf0Xr1q14TFuCLdNAcbMnaa9HUOZ21bSWeiB7DLkBUzP15kM8gU4UgNPttUzRWcH+t/PmCFUe/N2Iukn8try/aEL8GdBeRyRDrXin0wTfHw6GY2I55Mog4h41KTI8ti8Zz2yv4/bOURJUJBOzOuKOksFRRNvHWvNTt1tR6wz6+/hXxHUeaLv/e9Eyglb9SDEup9xw0Unm+f+yC1BwZlr2y/fIxuKj5XzC7nMJQDY3x23zIx3sxj1/QK94mveDEnEhza3bzXmpQRaqlziRY4CXuSY39OPMcFh7v7gP6Qrw9dFq0wqDvmC7wbOObxY3k+i3VDirQ/IQ1vdSeCPufq4WG0VTdnXtCpyaqAuShENeNccxGgR2tjGawMANE5OcFXWjOR9jcDr2RQzGz0fJ6Sk0HuACV0pXOVCuy3mTUx1d5I1ym73wRaaE+724o0/Lg5zqaif7bpcOZg5aEKpOSRZKtP3Oyy2zYxnM5XWbmC8h0WuQKUP9KPWlXmm4jNfsY3gBqo8RfDe7giaQRyVOg9C5IEXq7zM8GcWlVjx5uqhPJpK2FHLPBjZxsc4As7RJ2+MT8aNLREIj8/rtipOIOMSk19WDD/SjswzxjOMnr3cPtvyb7yEhEhLrhJtQMSleEE2vkSW6UpIbR1gwC1E9bd1dFQ27OtIlCsbVhrHz9i7VqAPm
 0oK7P/SA
 HFnHYZFJKselHfZzOTlWv2hdaZDsEcEdeDrzcrdURnVgqOpJtPuwHrjDyS52XZtitk4K5owvZrmv9KHrwn4x+PT1gTL+eyVMNiernxbkFhuSQglta3V0Oc8TkUcfbx3R/eS/ilzll+6A6C9veSbnR3IE3QFwR3wd2hypHX07g/umFnd6odnIOniMZ1LBq/wlup85D+MrzSlxDtL+ELt6eECb0L3XhAzMjXAbO/GvRgX75Iws79zitOGEQdz1oQp6QhIwGoOJiRHVdI32DH5J3c4HkB6riuaBCO4SIFU5MWvrvTObBA4rV+MxsjVLYwfmQ6gife2vggXH1H6uVX3zt5Ye5wPlbRrbmvdYlqf6U6OvB9qRCtZKb2m5wZTjQID3EyQi1dEHkUdh4JCfVq7vCD+gnuZ5Fi4Pu6/+VvuPzVzrQ5lyWD0dvs67gCR1jtu9vAh7+JhiB9Q20IlZ8Q8y58pk+YcysbQYcq/gXBriGdxzYGXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Adding a device to an existing priority ring reuses the per-CPU reader
storage. A ring that previously contained one device can therefore keep
every CPU at the old common starting offset after peers are added.
Deleting devices or rings can likewise leave offsets and quotas that
describe the previous membership.

Reset the valid per-CPU ring offsets and quotas after peer insertion and
every nonempty deletion. Run the initialization helper under the topology
writer, which excludes allocation walks, without allocating new reader
storage or adding selector hot-path work.

Use cpu-id modulo placement for a fresh best-effort rotation across all
valid rings. This does not move existing slots or guarantee strict balance
for every active CPU subset. Mask and availability transitions do not
trigger the topology reset.

Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9e90f815f99c..d659afb574b3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -496,6 +496,7 @@ add_to_ring:
 	spin_unlock(&swap_queue_update_lock);
 	memalloc_noreclaim_restore(noreclaim_flag);
 	kfree(old_ring);
+	swap_queue_reset_readers();
 	return 0;
 
 failed:
@@ -568,6 +569,8 @@ static void swap_queue_del(struct swap_info_struct *si)
 			swap_queue_install_readers(NULL, 0);
 	}
 	spin_unlock(&swap_queue_update_lock);
+	if (swap_queue_len)
+		swap_queue_reset_readers();
 
 	kfree(old_ring);
 	kfree(old_queue);

