Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA83C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5266B009F; Tue, 14 Jul 2026 16:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AACD36B00A0; Tue, 14 Jul 2026 16:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EA86B00A1; Tue, 14 Jul 2026 16:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7776B009F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:13:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9D2C140473
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:13:35 +0000 (UTC)
X-FDA: 84988482390.28.075EDDF
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1F0C8140009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:13:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ERc5N2iq;
	spf=pass (imf26.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784060014;
	b=nC/VsF5xRqN1rYAJCOa6yOb7rrgJMGmvHgmF5X84L34zRgqC6/0aqpby1x6xbPpfgCIW0T
	c8ULtbaKONtcQLH/DVvvauwicRjs2wNaKD8J8Xv//COFHPsF/HFkOdk/FZQrb6OgabJELk
	M4FdWcek1lGjuFRGM5TOJNlAC2+9w3A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ERc5N2iq;
	spf=pass (imf26.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784060014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vc1a4EA+CKVDZWmxoam2W7gn+VW7+IE4FDUnuymM6t4=;
	b=s+jbj8CqiS4CUgXfeZSlXZp+7GPrxxfWrF7VVDdNIkh+O8ZSksDrimAQyeuhSsuaWIGNDy
	byj8sp8fYph4Gjv6MMOUQu01e7oIifMPHpTnhbwHdHg/Xb37o5E29YrW6tyhHxoanR1AWB
	9jISEgo6T/qN7Pi0xUjXHWPgmiDNyGE=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84536ecfc5bso1230656b3a.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784060013; x=1784664813; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Vc1a4EA+CKVDZWmxoam2W7gn+VW7+IE4FDUnuymM6t4=;
        b=ERc5N2iqCK8WW6+o2bmve8Pdbizz8XfKtjTteTZJKKQR75YoVrA7ssEqwpiAlHqgGp
         ZC7jA5vBpHbJbbZlhIXQ7jxo7vUlkd9izn1RY8N3fX7nyF/KBGbzOr5SV6PItyVr2pmM
         mVAt10Z/eQKNTN4bGt839V3RjAQE1pdX27/F/Q0+uTVWReWNVU0QiLZkZKpBkM8yoof1
         qInMQ9BfUclFCMeL5daqOOYZ/2nAvmIVcJo+D2qB04hDB2Moy+GDitv4xn7/O+FvXFrR
         ODdrRHm6PApbykg7yLN1kp/CjsH3xQ7cQ5kWF2mC4Xb75oU0lEe31nPkvIpmKh/fGMjI
         QkOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784060013; x=1784664813;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vc1a4EA+CKVDZWmxoam2W7gn+VW7+IE4FDUnuymM6t4=;
        b=WhM5VulYKMCUG4c6W/I+wVa6uBaYLMZSqwIyRbrS3EZyngLRAi9BxEcAIbMyBTKRK8
         sxuUhntipGCQWnEICB1FHZo5QVn4CCrP0MhXVnqP9Rt97jQP0iMRpozQ7iM1xe4cll14
         DMuq5iIC+agdGzzWd62AIonZFsEkr1qle35fN7eatU565aPns4yHWp8maoGG5DLP9pCH
         myJs4h2ZE9eEbyaYkr+7HUNh/MCv31dKPTRN7nK6zgMpscdJvt2rj9SPkhXdR6UP7z8B
         g5y9abaLTUTeaUFod2jVeJKxxup7IphKHZy9OJ1eFEGluWnU+XZ313HtF6DsJz6gSk88
         kNSg==
X-Forwarded-Encrypted: i=1; AHgh+RrFgS01uvXtRb//RW8pW3DsWQ9dbWIX7tgMBVWa+a2UNVHkxPm404rRxL5tAbTYrvhEXEA/F1UE/w==@kvack.org
X-Gm-Message-State: AOJu0YwxxCO0Liq/7uNrYaiiT3e+EXJaOITxgs2tqWx+ftFrtK5wLIl2
	SmbXWDuH1Bi/+nzeI8kMZEsXUSHJblgSGORONj+qY40jK1sBbr15acEH
X-Gm-Gg: AfdE7cl+4EJtt4ptMo+NU8B00hIqysZsAhA6LVFqY/o9tdWmycRrl5j3+fLuSRNb1d0
	EATTQgOFZVsCxf6NJ2aoJ6b7d2cWjZJSfqB/5AUBuhoAyHe6aHIWaM/g6tWxj/+gNLQZ62/edc9
	028Z71idpQgE8RfuT5loX5TfEo7Ix1OXUwwktpvpaDrtYVF/y4IGYXttuP1lobntjkomE9Ra7VD
	IwDCpyX7y4kcQx7XxrPzKnjzInFkP9xwG6jeu17mDO8z3igkrqEm/LxLVG6ySudjMlhlbCJyYnH
	KWddaPvD1FU3RCbDVi8W93OhgBlX2Oe8Ytj6xl6718lXcjqywzgmQnygySQ8FayDHlbATrDc7vP
	0A6DHu2sk1t/RI2GDHhD/5qVVlIwn5nega4lIQcrAYTU0GwCfZczVOFJlu/36ibXyd/ap+5BNlL
	RLYuaJMPw/LGGvgdq5h9N5tu/qzE4X2HV1BEbsJyvCdOP9kczAB/SFmvvfFQ8=
X-Received: by 2002:a05:6a00:2341:b0:848:2f84:f429 with SMTP id d2e1a72fcca58-84a6738a72fmr16414b3a.66.1784060012852;
        Tue, 14 Jul 2026 13:13:32 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f6bf5ecsm1974797b3a.29.2026.07.14.13.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 13:13:32 -0700 (PDT)
Subject: [PATCH 1/4] fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for
 mmap lock-drop support
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
Date: Tue, 14 Jul 2026 13:13:31 -0700
Message-ID: <178406001098.1082778.7615814555318834246.stgit@skinsburskii>
In-Reply-To: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
References: <178405975214.1082778.5193079941156341151.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F0C8140009
X-Stat-Signature: 4jdpi7me4jwjo7yd9bd333k5amywiuck
X-HE-Tag: 1784060013-583890
X-HE-Meta: U2FsdGVkX19H/o4PIsScRZv+PrLYMJnzH4GJCA2mNCKANukJxToAIi81/UqIWg25uNc7ndOiYmQiMFtNB1VGf/DLffCPKOCUBHyG0fO+qOgq7S8JX949HlR/XQkzDKnGfVkCndmU0F6r0gsU6CfDiU6sFdMLMkdK4uQZhXMVjzJzu41DwhTnDm+OCziH6/N0YFR66blKastM2HooPQDrqIHXkLXUG6tenKoMVu86vxPD16iykyde0+l0NRp/DKluSR3s0KuUJbxH+6DQITBSfQmPd1Ha0jQfX5UY9sONjj75jxNPdr7zVc6i10PX+bH3bPJ0BODOdFTz2Ei0zOxDyqSg5xSaPo6Gefy7En6KxUSEoBLh94wXUFHMY85a0L8dz3k5DwKvo164kzKqfaG4hPrZeNJ6cFXvkJag0jNhiph4xoSaytrXDLsDaxqZ6Ivsky9bJq1K3fjNXbCM0oNXp4pmbLtvCAZaj1On/jfnkL46OlZDIM+WE8MqC2RfShQgvmOtAiyBUB2/ZaTSwvHuUThvVHJ/VGzenFFzrcfaZ/gT0FQn8A3Q1fdV1+euP/+0W5VwDkjVN2iHHkbn0jefaeGpYxeB05oh/gUb4XZJ2PXwaLVmc9uD29Zz4MCTsSlQ+BZeR/I7d6OI4h0jzz3qgGTsar+4WE77Jj72t4iPJSRrqfZptEGtal1zDV6spF1kwKVhUJZ78CHTVRvKYKXDjgXq7qIhASWH7tc2WGGiS6dVF2ndUNdxvsKDu/MNu/gzXW636SX5TXyeaBrnlu/5HVLCB3ZZJMpH3DQaikNzIq1qDZPt4yMB87aupBEhyjHnFUO2sJ6YqcUuqH9uIaZmX/TQ8cbdpe7B6EvXKs3MIjHQBouHZGf6E/HtY3een+umg1dyUdJ2s2u0jrHBkqMCetN05gfpMFKsux6F9N5B8/PKd06zuoI/lQW0k4wgkZHzAjV7ea5mFc9Vv8LG1Hc
 hT1N95+J
 ugP7CSjs3YE7D6LhbtOf2Uuwb26eCpmCMWyvyIg3Z0t8LvqAANvg/nZzDK32ILjzDuWZvS78ug8hXbVx5dA4BaqRDUbnjbwxgWbDHjx+coHFSPFp7Xyo6L5A2TRVUQ+VRh7Wq+/9czcYss0wFysBQB8ngBu9I9/8d5uACDhcuJakPQmvfU3xMe+v4oVc0fRl6qynpkA6TYbfLHczisp/DgjeH0yW4m7B3T2SXB3s8KYTv3eQXIByUnx9nibTeGDGIo7RzXEr/fjia+HwpqbOZEAa9tdBA6DbUF4LzFhjwVL/1qU5hUxcia5PaCZtNCtOXlhmMPOjUAknqcBitHKd+qm8Sa56w1T5F+BnXIVOdhm9yW01IkyXEhiRHq1d9u5O7WlHXyggDdSpSBZ3ghI/Non6OVuatnXuFX3E5a+KtRz3pYjP7wUMMcYqhdpVKWc8cSNDkHcXtGRdJplBL9pTxXkaIOVJBlJeoBDpdPImz68xp6Z7bxn5kPjYIgtnrMeW5m/LVp83akmA2XGvFtbYIWDYVKxT4E3moqNJRh6bUZ9BoUeuW6Wzz6c12rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hmm_range_fault_unlocked_timeout() example checks for a concurrent
mmu_interval_notifier invalidation after the HMM fault has succeeded.
The sequence number used for that check is stored in range->notifier_seq
by hmm_range_fault_unlocked_timeout(), so the retry check should use the
same notifier stored in range as well.

Update the example to pass range.notifier to mmu_interval_read_retry(),
and spell out that the retry check uses the notifier and sequence number
stored in range by the HMM fault helper. This makes the relationship
between the HMM walk and the later invalidation check explicit.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 Documentation/mm/hmm.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
index 5c88d2cf0818..fc1b8dc19825 100644
--- a/Documentation/mm/hmm.rst
+++ b/Documentation/mm/hmm.rst
@@ -206,7 +206,7 @@ The usage pattern is::
           goto out_put;
 
       take_lock(driver->update);
-      if (mmu_interval_read_retry(&interval_sub, range.notifier_seq)) {
+      if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
           release_lock(driver->update);
           goto again;
       }
@@ -225,7 +225,8 @@ The usage pattern is::
 The driver->update lock is the same lock that the driver takes inside its
 invalidate() callback. That lock must be held before calling
 mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
-update.
+update. The retry check must use the same notifier and sequence number stored
+in ``range`` by ``hmm_range_fault_unlocked_timeout()``.
 
 Holding the mmap lock across HMM faults
 =======================================



