Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D016C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1EF36B00DD; Fri, 10 Jul 2026 17:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7DB6B00DF; Fri, 10 Jul 2026 17:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9996A6B00E0; Fri, 10 Jul 2026 17:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6866B00DD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:27:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF2A0140598
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:17 +0000 (UTC)
X-FDA: 84974152914.17.5E8146A
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1AC0C4000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lf0Q3dzc;
	spf=pass (imf27.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718836;
	b=HMD2Q8mrtW09ILx7z7973x7alJYcOpyTIO0yErAWQeSFZM4LIo271F0ky7ePesubvTiOXi
	Z3V+Qs7cFQ/Ea/nVbPAl/6QAWDOlpku9wf2OCmeUvsmc6eRyj7yb3yX+uz2qM2kHlvaEJm
	6a/3khVj6WVdhVN+hIS+j1xF01envvY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lf0Q3dzc;
	spf=pass (imf27.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsZ1Rl/n/xZapvBLsULQnfYoRJnC5F850v9mJm5328I=;
	b=fdVRUpCQr9cbD1hdFKCr9QkgoC42HQP+KlX6O70yQbvic8HKCCY82IGt+1s0r6ZrrzW3op
	AQHjeAUAvP+oAlYy3oGNIbtMxsJZ7a80NSmHuB0x0jacr+spwDQTnr7W/UyS80iL4u9Ol2
	BiESqB3fSlRmtsMSQSOHjY668l9bmvE=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84864b41100so1194762b3a.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783718835; x=1784323635; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SsZ1Rl/n/xZapvBLsULQnfYoRJnC5F850v9mJm5328I=;
        b=Lf0Q3dzczMXjTgPOv2Oaj4jyM+0CnujnQbXYKmd8sa+iRFbhMOjuEkspDv5x+cBY0M
         wGlzv9qo27k0ehbLlxRNOYESfwQ53byeppJTXdYxd/1ZIRUZu7el7OC0BVjRq0dmNtNB
         /tgvDv3qAm7zJMVDhXuEltLKCw2/943fGAPZJ4KbkxqH3Z3+PSV4K/YLNZ80BD3NmD5n
         Yt6IUG7exMPgwnIa9kdRa7HqkkGyKp2apqaEC45LMTH1y0XeQZ+ol8YpdzficW4BG7fC
         kIaRi18JclMRdYhZM/cOmyEq5myWOQc/9gOTwaDAv8/HqBcR8IxpiA74Cht0nPv2QpA9
         LLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718835; x=1784323635;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SsZ1Rl/n/xZapvBLsULQnfYoRJnC5F850v9mJm5328I=;
        b=MsUBJ5+MaUFgq9yoxs/DD4+2q5UYYILXec9xVpJ8HF+umNZs6yWwYxIT6N+Qz6iLDM
         oD6+fDWPmEbUVcwqkhKlQ6eHUG/eTsTELVALKGsIiUsKLvhrrTkdKBMjLpIrOHCYBA0x
         lXCoCT/0lQSx5g4RGJd4RMfEiIVjbr5zNRbRE9mfTaBDcwBI92hsHsDSW/I1oG3/yubd
         QqMNTRaCJD8cRhqgMQeWgXfJkuZLVAf89NlY6S5eUuicOb8GT9NTLo/G4rIhgatJ53iJ
         joXp1sx/pGlVMGrb/RiFW+43V3bxKmWHBQMGkn5Aa8ZOZ14U84dR2BjY/ldmPQgTdk/S
         xHGg==
X-Forwarded-Encrypted: i=1; AHgh+Rp8PKagiTlm6HE09j/aXQeAS3DmAhbB7VD7ttQSWxHpNDAX4103LUNHRhr+quwO9w2ae84IWp6vCA==@kvack.org
X-Gm-Message-State: AOJu0Yx/I/5vzuVQNlgDsl1vhNnCdgce/WZC0laKchxeywAImWQhAYJU
	HL7IBhRW5fJr2KNQ9BIOHSWP6co9Cl4OKva2Nhd+uZloCKdiaqPg+RyI
X-Gm-Gg: AfdE7cmlugxtAZ/K0D+owexVZa9e6Z0PJ5momawRNRyRFpIl6L6eaqOIkNome4UIc7Y
	LE/m+n5w2uuVTRZGvBaJTy8dDAQQOu7eu9sb+a0jKrZ9S3eGHxP3gJHW0SzPDv1qhemnEI9XMDN
	PhaeCLt+HGgrM55dRVI0HEOUsDzfsiJW+gVLS7WMUUy3UB0BHPQHzvkZicR01YVwg1XFnvkeRyN
	z/kSw1nj4Em7AfYddepCdyKkRGFfdCrfUO2JKEdX08yxAPUXkcyX1q4KvFdQoF0qZtTAltUiQBe
	6wQnkgj6Ukgs3DjDisBaGpIUiq4iWsycyRt9LO+hlix0gg7kcr2uR83XH3TvyHbYnXO3hAo7b2z
	/eQd3LJ3dgUzP0d9Dbks9noOJ9znFUtNdRp82UKWzElqRUfan0skdktd88oBTdRJOepIFIoOSzC
	C8bp0xxaOa4KmlQ11kzVBP0ANX0u0TlocqEChmb7yMgMApqPFSiO/uqjpBTKhllkHGWXozsA==
X-Received: by 2002:a05:6a00:3397:b0:848:2f84:737 with SMTP id d2e1a72fcca58-8488990b261mr583131b3a.74.1783718835015;
        Fri, 10 Jul 2026 14:27:15 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84870d76ce7sm1801076b3a.55.2026.07.10.14.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:27:14 -0700 (PDT)
Subject: [PATCH v8 7/8] accel/amdxdna: Use hmm_range_fault_unlocked_timeout()
 for range population
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Fri, 10 Jul 2026 14:27:12 -0700
Message-ID: <178371883276.900500.12789147320642521200.stgit@skinsburskii>
In-Reply-To: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1AC0C4000A
X-Stat-Signature: hfrpd9gpzu7k7s15fwhhh9jaj7uryyp8
X-HE-Tag: 1783718835-955931
X-HE-Meta: U2FsdGVkX1+ZxPBBhkmhJensQpZvEeY0CDZFTJO2WShj0COzy4FlJk1EZrxGMEBj5VcM0lQPSV/WWP2BKOM0CybxC7gf74uiblI9Ups5qTgzsVZjQk2g3PQlIDbKr/jGiaowHxFxbpvzr7WzpkOUFt41riRbVOk0Z7xz8qhac4s8gBKBlwATdutM0hN1JC0biwbVza1XzYCXFjdDpjNWBYgOs8Pni/vHRjvQjB7XsMlvZ3aKRqbsGknwJMZyknPR/9f9hxbaZr4G1NIxSiEsfPYYSMS8Xdjf6rHucdn1OxEDXhNsdHGpPpXLO2A5P1HbgZU0GULFxVR8e9GvLSFK4BqU2yWF2bXftWZzZ/fjqLcwQUQZcVDeubucosiywCw42LlrK45u3FxrzQNT+DBIDb/ZLAQz29NxfZqdECA+xT/u4OqNHTcEq+aJjRiQM7e1BgttLxFd3eFD++MT1yacoN++EbOwBhatHc3o3D+vPTFWm8S+OOHX3DxVM/qpfU7a/AztCJxv4m345BXIvKuHMXT9CGL8M24IuZvn6MQlfGP/Rs5NpMJD+naTEWV/vZeCp6oAK6ab7dLcwJb0BX+nvtHEBbr7F0u7GyCYf3E5HmUgy5tLSoqKHFM3eHS+TQiGuLj4hA+9b3XPp9+Unu8RXXkc0gdnX6PWfbfxLNTp71vvy0MDHP1TIq6iAZpitonz25o97dP/ASWsOyd+F/FZ9kwHOoVqfOr6nNJX/MRrlCPKtR5Jdi9xVt7+5G7kBjXGXiak/DOE9Jv13lL1Coi7AFOuc9S20b9NUNFYWClpu4uWdcQZeaaoRHF6z//koW7N1zoue+sYk2HX1WoXVI1nx5wEw+wYcejUw+ddnNG4UhUw+vKou4dfW1Qz+lizLrLdRU/jO55Vdo3h/gS4y4XggFuwHezBFUjANCxyO4hgZ0yYO8u+O6UmGNIXsLu0z+7nBsbvSDaJXF21mLiLhYD
 dV7aBSLZ
 SaTa6CmSUnew4ZFPiuIMJJK9Q8kUXIXFPQlZbert8ZCwFmUx3z7ty9UID4REQPosLjuwAvRazBqKLJJO18kL59Zx1ctxg7uKaWVTZ5IqJ77e3zl/8XyAAY+vg+5AuQKWhAu/zxQiLAOzNukuSUWmeqC3xf8G/DyQnM66OL41eIhNhTuUsXFZEzFq/fhs7jkcVEFsX+mbfYSDkkmSp5e8lmn3k0O88TGrgvSwzzqGAdSrKctgKbTLnQjHSvpDmU+NQFVcMO5ojzbL6ciPKcSPNaHJs+zJW2mjiPBf8CdmJAPpxFbh8qeuP1TILd6Bul7uMl0EBpHZFuMxXeJnhmEhBMlVqvoVrdIsQlitAQKAcfUay2/AVplxKCt9B7dKdqnHFOOkKM5bu/O6urp+bgC27j+aKoVyf5c45GreipnjB85TiBCMpk6J1+64R4TTUl2g0AxyRHGKZDHR0cUMzrVIFfAF/bXNXK1dbhVEieOkGZjvyg5iAjij0zZ7goDGSVJ+7reFormPiIi/H9pA8uHF4AAsCnRT88waywZezk/piWCvslOZOF9XjFh8EXp+ood6w1+bcqpHs+huNQlY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

aie2_populate_range() takes mmap_read_lock() only around hmm_range_fault().
It keeps a single HMM_RANGE_DEFAULT_TIMEOUT deadline for the populate pass
and retries -EBUSY until that deadline expires.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes mapp->range.notifier_seq for its internal
retries. Pass the remaining jiffies from the existing deadline to HMM,
while preserving the driver's existing outer loop for interval invalidation
retries and for selecting the next invalid mapping.

Keep returning -ETIME when the retry budget expires, matching the driver's
existing timeout error convention.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/accel/amdxdna/aie2_ctx.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 54486960cbf5..a16b8d7deaea 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -1061,22 +1061,11 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 		return -EFAULT;
 	}
 
-	mapp->range.notifier_seq = mmu_interval_read_begin(&mapp->notifier);
-	mmap_read_lock(mm);
-	ret = hmm_range_fault(&mapp->range);
-	mmap_read_unlock(mm);
+	ret = hmm_range_fault_unlocked_timeout(&mapp->range,
+			max_t(long, timeout - jiffies, 1));
 	if (ret) {
-		if (time_after(jiffies, timeout)) {
+		if (ret == -EBUSY)
 			ret = -ETIME;
-			goto put_mm;
-		}
-
-		if (ret == -EBUSY) {
-			amdxdna_umap_put(mapp);
-			mmput(mm);
-			goto again;
-		}
-
 		goto put_mm;
 	}
 



