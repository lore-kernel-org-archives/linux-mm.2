Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9CA3C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F916B00B6; Wed, 22 Jul 2026 17:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0806B00B8; Wed, 22 Jul 2026 17:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8196B00B9; Wed, 22 Jul 2026 17:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8CB36B00B6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:44:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44545A0E19
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:58 +0000 (UTC)
X-FDA: 85017743076.22.9FEF954
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4957D8000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NBTbHNCH;
	spf=pass (imf02.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784756696;
	b=q+xfo41SKKHU7SarSYu0nj2rHkyIJsUv6aYYiQ1gG0an/Er0bGZf8+xGjAiKTqQrOfxAjd
	eK9KaR2OEyqSVvdYrvCWXmikf6S0qDh5g3ft6De2otmWs7/vvIU80GIdHixvaNqgHN85tI
	EljaAEkS2QNfhxrHoOylgNE/0zeUcwo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NBTbHNCH;
	spf=pass (imf02.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784756696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVIK4CTS2ebWqFuX16f+6TzH9lK4l3CZHr+WHLsMqrs=;
	b=Lb58aljPX/N5AE6gx77JwIjGY/eb6L7gzOCSJZ0UcxxFe1k/z7vyCLWVJbvpf5yDUeCX1p
	/iQeoIlc46C2sj2ad4AafTGtA3MBS4Slm+MPojt2r4P1WUj5/GIVB1PC2D+2pI7PSb4yzw
	3rzyOUJVIYOMode0Qr1YDgu7Uz0iGPI=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84874b52eabso12804479b3a.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756695; x=1785361495; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WVIK4CTS2ebWqFuX16f+6TzH9lK4l3CZHr+WHLsMqrs=;
        b=NBTbHNCHzsASdA0D9TCHlKoLQta5Mk6CJOwdwKlSTzSZLGcHBt0XhhWrdrZTSBmrGX
         EUK4N1cO2/qrSkbMcT+WDZqQEw7ApdzI5inidlOv4cbSQBBqzeFJrXeUUh9x5P1hXUzd
         QJ4PReTcJC6fvXWDNOYQ/Q/v3BkCuXXBwTogHUw6hlS5Bncz/ImU3v4FFyIAKrEgWwmW
         22J+Nr2INcISjP2P522igrTMjAn9eoXwqG45al0dE0jjpi4x1FXwAIyMZZI/M3wFTKbP
         uruBZVXF/zeI9zzud/eUNcEtMlo7wKyNzoLi1dUSJIagqYbLPhMcNnfjvSxOe/fHX3VL
         kQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756695; x=1785361495;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WVIK4CTS2ebWqFuX16f+6TzH9lK4l3CZHr+WHLsMqrs=;
        b=No41sXDUAnHOFXrkrpyPPUORKE/tYS6dyzOO7CV2VQvlDKGylds8LgvTDSL3wz2YPM
         S06Pa+5aWKQYMoiG7eKx8QvRraMAJGGk0JPSzcf/dcdC5Zswy6yYXP617SMVq1Yli2O4
         dSbLM6HakfF1P52G6PlXgVH169T7FwchTB1r5pi/hPS0R92gjjph6vFn5yeUUPFpZkvY
         wii8nnoBa33xyCCVIyKbiF/mQvInut5pGzC9nA6ZphFYg9nJSSK/ATjAxb6VuFpH5peD
         OKkwloG1X6lAqrFx21aRsWCCtpOEKszixCQ0ML7IuL4KuQTwIUcNlLeaKgcBiPdr/zKB
         3yTQ==
X-Gm-Message-State: AOJu0Yw0DHqYRcu1qvcphYjlOODs38fmbnQ6aynFzpcwVkXwSfHW4rde
	Jmslo+2uG02b27jzduPFZvrFXSCzQsTfYWH22ZqALWEGHL4uIcs/J42X
X-Gm-Gg: AR+sD12DKPoF4fNQbzqNNlS75WexUubqKd/05BSnBzbDNXlQbslgkP8hoa/AuZnnjSB
	sD1yPHN81Ulqx2WQBqe7+30G/R38y5Kslno4Mzju4Uiwr64wNYv5wRcarQQOKR71L170vgkIto+
	+8zk0sOswgpfb32zrKmqLMyLfpNW/JyhZwpZcJvtI1OooxkNPE4R520mWnbtuzCkvlUnXfAnwI3
	SvBWoywsS1rEaOd4ukaLeJAAR1S4h68LJVTrlpBGGBC0r3yJBakiDsHsO7M1NZQKxqFUE0zvUfE
	wXBY7BeG9Ym4FR+zwbLXVNWoY3oo3NvgA46KCOcaL90GLYdsnliKhcQceTG4v8j+TVBi3OAB7KT
	otXDr3+bwOPmsgDsAtj6N3/+0eq1wE/0DAyvHIgW+EPyKLOalzE7MMPI09bvq91C5DbDS+OHyJQ
	110c4sdIElbIBgEfyK6AS3/5Qm/z9IqieDKB/ZUdQaV4Jup2sM
X-Received: by 2002:a05:6a00:852:b0:848:46ea:bbe7 with SMTP id d2e1a72fcca58-84e2bc6b5d6mr673956b3a.19.1784756695183;
        Wed, 22 Jul 2026 14:44:55 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:54 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:27 -0700
Subject: [PATCH v10 5/8] drm/nouveau: Use
 hmm_range_fault_unlocked_timeout() for SVM faults
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-5-606464dd601a@gmail.com>
References: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
In-Reply-To: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>, 
 Oded Gabbay <ogabbay@kernel.org>, skinsburskii@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=2163;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=KaVy0LDD2WZ56zIlG4jDVljfxrz2j27JL0AnOSACkpk=;
 b=uKgRFxKY7gMhEFoK0hHnwQl6N8UsouNcazo70jIAxend3BGPO0koGFjjGoE03g3KTWZd66DI6
 5tAsc5/qbDAAjPQ/pjqrtB3km5I7U9rctkdARaqcdzu58Lj+SzHd5bT
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Stat-Signature: aqsh9tr87kbgg33ozs7oitsqbymq68dd
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4957D8000C
X-Rspam-User: 
X-HE-Tag: 1784756696-967836
X-HE-Meta: U2FsdGVkX1/pu6XmFscb/xs2SkRLHQo/ydBH+sCCuXs+LWGpIZV0v3D0uGzTEivmK6R14k+V6lSMalxh6E00fHn6I9oClvcmx3FncvatyjpGnkBhWOPghlZYBa66aXcTppRwJ6LBJ+Rw7kiv7r6ET+yUX/yFjVESYkbfgZ4/lmBASGX3mcv7bwI0g8YpM0RpBQ9V70b3pWxi2OMlDudFkP2CXKUSzGqOzLo+A+KMPcQOVqv/KxVtXNX6Rdb/LEgy208H1H2QooDSpyB3l5wIt/Htb5R/ZCxADH6g76OlX9wQxehW5klhKHrPHh8XC/KzrqWJBJZ4i79IMdbOlCeUmR4wSquhGisTiBkhaHv7Nbt0/8ULs8zwQpslszKMx8dwzwnFtbmJyyXuBYPkm3/LW1iqWCMF8FhShdKgzZX5oDwCF2OLfGuOC4kzQodqIxIEMqGXvL89rfKyqHa9BXdmQEK6FUWFMwYIHpi0poFcjvIjY1bUZS51K04EPHz2xlQZkWR/09ZNaxKDTtKJKo9e2IofOeiMLIynV5pTxDEDWo3/FfEnvJ2mQS3qOln6kk/LrQmE+qGO20C90CUeabCK90ONCebnIR0RPEluKKUOsrNjb2gMDyjEzXtZ2rAIB07msbA8yGhkqoQn25nGe+PqyKQVgLg4Vw7ViPMMhHI0Xb8pX0WtPwFYRmCzijDiDQ0QwKybXuw9AELRfSIp5ZrV7AOIKFqxrQ6zDvxUPAOro6M9nJFp8mwu4xN3f3nJWhlEjootwOijrO9Il167gaXM9m7YaLBsZpGWPJRTPi3P8E/bOP1BFxY93SfCxUp6CLH6If+sgj8r8pdS/IU3Lx0cPkJ+gyvnDQVv9/DfGoM3IDJ62Ca3k3Vm/T02PkxknuO22Uup1cvAE9iXi3NJxQpNxZ/cjCxmlHXwC+4jiy4+AiycBuvYlA3B+kO7pVLc2rarNq3aMBngjsgibTa7RyS
 Jf/0b9qu
 H/W2E8LBX8vlF2IjjVobDzMCMlVo6fJ30qLuQaELUMmC2uQopcWmX6S2oGjQIzCQ54h5wZkiRg3Lt/1ShCFyxMaZHwh8wRhl4eHYi5S08kmSKV7ZxTnD9yBphdI5VlMUpPN/R86qDcTA8LAQTJXpZgHK6Ur80YVEKROrYpIkHasaHYj/lkIVbputMItE186++Uma3gzN3gMqLElvAHmFaUWL6ESFxuHP70fYj3NzOp9s99Bro5jZhOyOz5p4GYUsSdSA/Ycf357bXmfnsEtVRBg3IU4PV9gSquRohpAVELGuYBd7ivKYLrzk7kyj7Rd04UMV5tiY8m7hlM5bnncjOeInHJcMvbNotwCD+KWPGwfiGeuFJTcK5pn/+/CGZ3/V53nmQA1moXZO+xFcSVjBRMm08BGneqg4qWJMk1sXJ1c9gTq2hi8ib+NFgccrF5Zdc77lvZn+SFhgvdDiUsN3p6NNg1+HY1Y8N3JCHnwczVtKD3YIE+QAfgMuYqfDn2hUgZloXqif4BtWJpI0JfTjwp1EJFc+bKO3pQitUvLNn2Ms2lgwfDyqeC5kU2uUMojBycgZZnwJ6KAdkBEkb0G/Y7Y1JAh8+rTaPwzbe0SHwts8Fyj4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nouveau_range_fault() takes mmap_read_lock() only to call
hmm_range_fault(). It also keeps a single HMM_RANGE_DEFAULT_TIMEOUT
deadline across both HMM -EBUSY retries and post-fault
mmu_interval_read_retry() retries.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes range->notifier_seq for its internal retries.
Nouveau keeps its existing absolute deadline in the outer loop and passes
the remaining jiffies to the helper for each fault attempt, so retries
caused by mmu_interval_read_retry() do not reset the overall retry budget.

Nouveau still validates the interval notifier sequence while holding
svmm->mutex before programming the GPU mapping.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index dcc92131488e..58735446d783 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -678,20 +678,22 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 	range.end = notifier->notifier.interval_tree.last + 1;
 
 	while (true) {
-		if (time_after(jiffies, timeout)) {
+		long remaining = timeout - jiffies;
+
+		/*
+		 * The HMM timeout only bounds retries while HMM is walking and
+		 * faulting the range. This fault is handled by a kernel worker,
+		 * so fatal signals from the faulting process cannot stop an
+		 * endless stream of invalidations here.
+		 */
+		if (time_after_eq(jiffies, timeout)) {
 			ret = -EBUSY;
 			goto out;
 		}
 
-		range.notifier_seq = mmu_interval_read_begin(range.notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(&range);
-		mmap_read_unlock(mm);
-		if (ret) {
-			if (ret == -EBUSY)
-				continue;
+		ret = hmm_range_fault_unlocked_timeout(&range, remaining);
+		if (ret)
 			goto out;
-		}
 
 		mutex_lock(&svmm->mutex);
 		if (mmu_interval_read_retry(range.notifier,

-- 
2.43.0


