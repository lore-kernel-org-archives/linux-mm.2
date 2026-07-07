Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4DBC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83966B00B1; Tue,  7 Jul 2026 15:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5CED6B00B2; Tue,  7 Jul 2026 15:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71966B00B3; Tue,  7 Jul 2026 15:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD8F16B00B1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:47:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A15F1C8268
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:42 +0000 (UTC)
X-FDA: 84963015564.14.862671D
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5370F40003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:47:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lXPao/8U";
	spf=pass (imf11.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Fuhl2eREcU7wQkONDn3KjcEE0Ws3TgFkFsQfjplBps=;
	b=IIWBZe5aiFjjHaUJ74XOjsW2U16crpS26IQdHK3H0iGIR3lYQUv/0LJb3O1jBH8xSA2Sde
	Wu1y6HXXKmVbuUgxpaM2DLonMu9uFFgGyItp2SL9UJEuK4gzr957BaBwOPV5GSUPi3K8s8
	L4l9Pw0mLVOQcl+4I0lcOBcZn3U5pb8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lXPao/8U";
	spf=pass (imf11.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453660;
	b=2tDYPfx7hQc+LzWwoIZQGzfPXU5uqsPV82/ZPjY29Xy1BRrU/qhIGjp+5LXhM8LtTmK7UM
	GtzXAj0Xvm2guzBmzg7o/WsBKBF5mHRebRNHOKT8ISoYF71trMCtlIqCrIXA2NvEW9yenn
	Np6OUap9IA1QzflhzfdnGbNmxC5rScI=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cce6a0c9c3so417035ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453659; x=1784058459; darn=kvack.org;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+Fuhl2eREcU7wQkONDn3KjcEE0Ws3TgFkFsQfjplBps=;
        b=lXPao/8UAmSFuEmpQGkdLsbqas+c/pc+WlxVx3oJLmRnqNw9AuCai96axe0E8zWsGw
         9KCaJKUQxTzQrhneEGVdWKKfg0Z2ans9+sTZgapSW7kDu0sKhtfJgFIdFTiwXDzyLLs8
         uyWmus7vxTEUbojktxdJCwXKEzHgVNjn4rvKRfJeXT+WbIRMjQlE46A1qZFW7WtwvDTw
         woUSkiuwxvssdXVWC5r/aguKZg4iphwVnkAz/dJ1b0bk1N8n5WZm7q2yOwHZ9BjHn7eu
         gq3vJef/93tqpGHlsGJilVOTeizriLFEVBckcrYcHmLa4r5jO6KgRnik8N4GrvpDZg/Z
         Y/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453659; x=1784058459;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Fuhl2eREcU7wQkONDn3KjcEE0Ws3TgFkFsQfjplBps=;
        b=SLBtscH8HODTlS7fsR0oMGbRh6ns8yNX0AKabEWyj98AorOy7WKPJRKHG3Fl+wID1N
         A9rwUudnPukQ3gazyGnYOUeM5axTxDgcmKiU9T5V7+LFvFcmyZH8Gyr92ngRXmlySTVN
         O8QvNitKktVjHB9lcslbL9BAzNbbhY0/EmYTFlEL80lj7cN5C7eCeCQgfFHr4/+QL4NT
         1xnMtE0U8v3DBFxW20hsJIzQw7aQMbVidLTwGbm5HJb1+eLcBXOMxZJ4hKyFThWjUK81
         +vXatJqK+UTWbNsXzCARNIDXUFc1h2RB9IxUx4JN93wf7yzkAnSl6+nrpvDLvBSBeoks
         YFPQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro5TYq61cpcJPCqlPa31kG4CHwQanaQ/iZTphYoYjBaQx22SlXW1QdueYc3wSTPFnItLOx5cWuoig==@kvack.org
X-Gm-Message-State: AOJu0YwHpfe9Ie/wHtbsl4CRfNC/rz8GjNJm8TiT6tYg6BLi0qSsCDkN
	jT9x0ENZ3BWGyAcMZSas4p7JCUdNKVon9+UVDZUtPLHOqLlIsR3WfCBu
X-Gm-Gg: AfdE7clPjFYVfMR8FlBX+41wZ6yDpQ0vesZEz5jPEFkklNar9/jIJkXthvD/4UGPM2A
	/VyI0sulxGydUrqk0Jp8hSH9OY00FwIi5jTmVh0NDlv0+dzSWSHijxp70QmByMreoJjbGQycP1p
	xqxfwXE6qrXqdWoPK9o6DbZavjqwtmAf3c9EL2LT5r/xsFSqp/XQETV155/BTWeaiHsBvmdRG8o
	0Ay+WLBVEE+MaVpejKc1prt5lwiQUUALO0RnItibOuYPdcwcndPbo4Uw2AvkBFxsqtqKFDHPvSc
	ITs00CrW/35v31Df+lNQ1VmLIP6pJPoiba+Cl0aR7lMEwCTFkwsqelrcMfm97VwPK1pQHeDKik6
	eMUYaHpdNYYjqlTPvfyibyKIwTpRK4zbIX9wYy9Wrc7DDzONtviFYcraGk4es00FuqeHG4odMNf
	XEgq5ptYioX8YNDB83w+hFpy9u1XrYw5pGjaZudipe3wHG87BRSM4zUGlCJPc=
X-Received: by 2002:a17:902:f68f:b0:2c0:e5ee:f554 with SMTP id d9443c01a7336-2ccbe40ee4cmr72069895ad.8.1783453658644;
        Tue, 07 Jul 2026 12:47:38 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1ea7fsm17015165ad.38.2026.07.07.12.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:47:38 -0700 (PDT)
Subject: [PATCH v7 7/8] accel/amdxdna: Use hmm_range_fault_unlocked_timeout()
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
Date: Tue, 07 Jul 2026 12:47:36 -0700
Message-ID: <178345365679.660027.16671418103486907555.stgit@skinsburskii>
In-Reply-To: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zwsbcoz8esmq1xjtz3epefoky3g7okr3
X-Rspamd-Queue-Id: 5370F40003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783453660-788838
X-HE-Meta: U2FsdGVkX19Gl/wsGXmBqf1DY0IWXw9r9xVVkDPeyaD8nPkSpnCU7GKzk6mPgLtU9/O0JCFmPkznbzgUMycouyy8/24W84vpLvQYLbes/1R0XRmtrcgTV63aMLT6Fngx3IywPGf99a0JSKm7HJFFbbfko1DnMpgX0Xb5cTATq22vIkI2iSq8HslEqvQnQyD5mjJamjc+6VRNSQdh3RHWkFfdZ6ySZJUgOlGg5HVNqvHUJboVbCkyYUr1YH9HbQd3OtshhwuIt50aponpUbp46YXEEGdqhukxBM4OCKdihYsyfBGba8lwdy1jnfh/vRYwdHGE7q3DF4euv44Xy55KHSaV6u57+GM81b9Fra2mguLEL2WfDnEvjo8CR8lBDi4tTwacj/A3EZGEevexDaEuHETRyHv6xcuFP9MSesMQEE8PTxJnh8AgS2uXfU04Tb3wbprgwM7segfHCxdC+5BSqG+YxqQd6KWkNW36zP0gGga90nHShHS7GutFe1vt41+/0p5bOgVdl5WDWmF7f6EofZLCoUGUGNFXUMXrl0AtqdjTD4Uyf+fwTzH4sMWaScc2KjNXaxtcaf0DyCPeYW7xx1XeHqwymX770xbbxrNp+YYHSCBlgaRW0WTuJClxMoUk5gbaB64rMpuKelxSupF7pUDiIOp2CQAaiC6guafFl0t5/5lD/LEzz9ZjLHeOviFnl9E2mf67Fo+TLXWP6Yl26idkGG6ANIDcICk3bag306kYbKs1hGRcG6zpPiyqbCxW1jI6J9umeM0ddPptGjDjdEgYm+tNYu/SdSo+aR3R90/V1JFNulNAIMHGK8iNl40yLsOqFHCHUDhHANJ9w6hI4a2Tr9OBK9TFUuGlii71mCXvXVmEmjqox2RD3qLoSZAeGDD4RjyFJbx6BnBCWW1+yJuV7ICU712FJ2FqMc7MVJCxYWcyZS/9ZeSw3BQEoulJeIErXKRjmiIMxp7x109
 2AQyHv53
 +Ae/YEfF5laRTy9i+5H1aeQMnsuXmy8FPEPW2PBrQlvaKBb+IvHxialtfSrhg1QJFLHF3amfbhhtz83QwY5V6cBA3jHM7wnZP7PGQJeVNm7CCvaBO8plIssmVuYlJ4rax0LHMQGb1LHe+FryMDilUHoA3J5iq7asGLdPlp4sMP9XzProgKIJuSc87yR8v3w63gYVU+Rsg0p0MKvJQq7O/069k9Fi5LAecQKg3nKUjNUu2jkoq37CS0QV1k4WD0N2SEXqHBsnzSBRTS7COU8OeTh4akyFCJ0U09gtwoYkbZjf2Bo1xBEf9RIEFuzcKW8TYlhbC7L+7Vj7HxjeZnnyAM5NEfIrm3iYT4iuiyNwbgJhsjV+FI9ifo1SvlfxRhUWdtUQunkYW9RMXTAs5erFSUcNNsQp1hcputddyu6h8Q3QCxSgsuBfn0snMeW5kgeV3be0SgC/NmCS+a06dJtrnCZwuCOp20a77ynrm+rqpOuDI4iaUECGc6Vu2UG6OZfILvN/yP/VRSIoZ3xvSmqYj8WartvywIKPc+iKnY4OjZg80bWjxbWcqULOPAA==
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
---
 drivers/accel/amdxdna/aie2_ctx.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index e9fbd8c14364..412f812d7c2c 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -1031,22 +1031,11 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
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
 



