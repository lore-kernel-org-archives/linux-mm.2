Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAB8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738F76B00CA; Tue,  7 Jul 2026 23:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710B46B00CC; Tue,  7 Jul 2026 23:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9416B00CD; Tue,  7 Jul 2026 23:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 261A96B00CA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85D71C3E3B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:50 +0000 (UTC)
X-FDA: 84964134780.17.4477ABE
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id D19EA160005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gDK/tQhl";
	spf=pass (imf08.hostedemail.com: domain of 3879NagoKCAQnxlsyklxsrksskpi.gsqpmry1-qqozego.svk@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3879NagoKCAQnxlsyklxsrksskpi.gsqpmry1-qqozego.svk@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3qWnf+WjIw/N9fJ5EFWCJtG7j5Nn0VVg7E9Z8ZhI7s=;
	b=arF5+JEsNtKp28hv3s9v/ZVe+hTiv9c6FVK42NGkSk1e+1sWSHnLJJLPkupMOOGVK10I4P
	+Ujt/TP7ndz9idRa5LhdPerzjsStftROA7jAitaa1zlrMeWvaqQ9oDGPVUiClk07ZRn9BK
	vH9N25b0I+zn/neRwUDcmyBX7y6RJhI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gDK/tQhl";
	spf=pass (imf08.hostedemail.com: domain of 3879NagoKCAQnxlsyklxsrksskpi.gsqpmry1-qqozego.svk@flex--jthoughton.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3879NagoKCAQnxlsyklxsrksskpi.gsqpmry1-qqozego.svk@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480308;
	b=z9bd0NzSm+bLSuvmamLpDkJU6ZlpKw/I45mTwlmT6vGHT8ZPMtnTKXiEkVDKinTaxknKe7
	Vlv6KPTPW4Y7LU+G/ubkFXroS7QZAvYsTQzyk1xcuKJN3vbHvyHTCqeQyu/YRjUFzoWoIn
	gmj9NqIdC8Z6DiyrM42eFHHKfqC1Xd4=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ccea73f81bso4133955ad.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480308; x=1784085108; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i3qWnf+WjIw/N9fJ5EFWCJtG7j5Nn0VVg7E9Z8ZhI7s=;
        b=gDK/tQhlY8oRHHCienFlXDdFdYcG6ehckH47EONKIChiB1JAeAlM1qFVbkKmJ6Bv6U
         dwSFcjn4MNuD/udjj9Dj/8HAsZgfNpvi4e7dRUZhEf3+PntRGNNU78h/8KT6tPEuVpas
         PUyO6kqvX8EVlEQHKWb6wwvahBYgYCuuOt4/GzsO3896kS+3215/DOwuxazluujB4RG3
         9K8giwIdKujLCmccMwG4QOXv0/dW3Rz2UqBXQqWHKIrwPFPT5FykDwdKTAvwdtk1tqGg
         457+v1B9aLzCJ/7KhJBMv8X3iRCWIC26LQww3mqNVP0jfKx51MoSfw9tX5gGldo29kOR
         LW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480308; x=1784085108;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i3qWnf+WjIw/N9fJ5EFWCJtG7j5Nn0VVg7E9Z8ZhI7s=;
        b=ANVrbegmFNzdbbtl610PuAqMRI48+Bn5bvQL5CpsVhPXQb0J8UpaNhC1bEoUY+PgbB
         iy9/si9xwDiQXcDMu9/aQa2fujEJeUAidd0s1lRvGNVzyZfUa7fLHWhtpfryGO580y5Q
         deTByqHSVahj3bbTDNmeZxVBWpZjGmz/jqgMa7cxf18yS/lyGK+9+uWH7b+n9nhdyNtA
         7YhjxP+9s9FIA2wSLJch5naVocsjPRnQnYPQMaMPZV4wim8Z5GIr1u+An7CMRm3GGmlx
         9dMwZtuYrDeD2IWXdRQ0BbjvaZHFcypqYd/3cYNyqOjifIIyB3TfGlVV/0JQ6axcL+Jo
         TeJw==
X-Forwarded-Encrypted: i=1; AHgh+Rr9S63nfawVAlByyv9x5nGxzRQxWZhw6hwb2e5ww6rfXblpMKCIVTKi+sAVcdtKTXDdcJD7EMi7tw==@kvack.org
X-Gm-Message-State: AOJu0YzPWP5xl+wrbaQrxiIhpKRFwoaNzSHsAn4vAyqFzGMtILavp5zn
	OeglTu33hT7U2UuICs/VOWxxXVwAZAOG0d6C/UA3Md5MlRlve6zQdGfDwrmDQ2Wcdg4WmYmW5eN
	aIIkiEhxEuSuJrL02DUPMiQ==
X-Received: from plhy17.prod.google.com ([2002:a17:902:d651:b0:2cc:c554:a93e])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce0b:b0:2ca:d7a3:371f with SMTP id d9443c01a7336-2ccea45e5e5mr6630235ad.22.1783480307457;
 Tue, 07 Jul 2026 20:11:47 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:26 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-17-jthoughton@google.com>
Subject: [PATCH 16/18] arm64: Allow "optional" CPU features to be required sometimes
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D19EA160005
X-Stat-Signature: xgn41ugwoqojgcow155fh8tmeqahyqr7
X-HE-Tag: 1783480308-104003
X-HE-Meta: U2FsdGVkX18sue2tWmfkRGBjwyr4vq/dOYLMkqjHIyblYz6jkhfxpZ5Km4OTVSd0CKs5JMj51Oc+aCVEyjBJHcvHcgIJHs8FeN92ZhqTTdwS5bJN3hMNkhWQqL81cgJ2/d/YEmHS1SRWXw4RybrHSnBaR356F6l4IAX7OpWBOfxGjK9lgt+r7Sw/gZCVX+Tr1Cc0fzwd/IkhoBqTN1ui5w9nyOAbQsyDOCQbso8lSSRzyLX7sJx8QjTcIqvRLHZuhdETJYsWACJgnbrbReCNiQgrzsBJ6UwgRKQ3IR0TngwlWW+B8RMiBvRqud7rLSd7FwYpZcN0+lN8VS2mAOyf9p2eWW9NChIRMk9xtZeSrevuCBC0xA40gsFXqNM84+G9dXZ+iWs4mjUNzJWu+vUZ/FDH32o8qG6UgxyxWsDGzZ6wllydH9RiAvO7sSaZQHPUcckTynaj5D0Md4j83T8iiB1kDnTSe8G1tw3juAUHN+Bc93tSqz9095q3aR7PrhkkYw9HNcXCWItKbmMg1Na29tKp//8d9OZz8IJP7SU4Vr3Ae1TBP5qTdwETJSWIWReh/VLah0IYpOF4D86FM+coZrKY4wnq9XqKVrECtbYYhPe0IiHV6SJZYliuqW7iTYYANZAour9iZ8C3+2MYlAf1G+HPTUSmqvv+ufpPepQIzmGW61UEIRZOIPpZH9elu3f4ICizVCX/fJEeatP8GG4pvo6H8b977Jz94bYs+7We8dZdmuw9iOW21Src1OXydkvsmgpoq3MDgCsxPg/172/rgrmxU14yb6ufmQ9ijkidO9dqW8Ne0fiXARAlULaaGixaoNH2VIKQMQmsWaQkKVEt2IVAeZdQOjM860zAVC3PN3rFj4KDNoYPYF8A8lIkNsz2dH/Ba7pO7spQ+XPKqIKlInfPTbqQybCluLchxewuRckGjSp6O68puoXJx87pPR3732P7ND6B/CQrfIw7bcc
 wk2eIWff
 7qbNF3ltyjYFYmpioVluc+hkEORJAn6izBs/+lXemECNSZgdiOlvrQHJjSl0ERTplKP8CDA2KYcgOSNGKS7xCYKb+bS4ifuOBJNIHqzA1tGFul8VJpb6hBfp6/IhZewc8lPA2wlEzq25nGtncnQv1+16mOyv4obGsH/A6igdOHmzZEPKE1VKC+KYI+hKykQ+rwF7OpzrdAWHDfh4szTiw3vd+55Kf4eTCb2ulL9Qazx/14XhzTuFZUvuMnsxUTNTZHB2fCeNOHYZTjc2H2YUBI5acDELjdsB6jBQDdB0b6doV+E+3If4v7T3/itxgSn48MZMGID80VMyvzCwnerU6A0cQgDLzSysVqg55UjQFq4oCBWMQkyJhPTglDK6jbbhTzxwcoPSGCAcoHbBRZj/Yl6pm/dC594qMwQmbwK+L4ZIV04/V0Kq/In0IGGTnYYkatG7D4S7Jjl1ZV7rxx0rMWxN9uhVObMSNawIcEU9cor11M/pGBsdFP2Jo0/8sMe3ESc8WZ7pm0W4PtKpBWce61DE3cpKWeatDzz5NbkkfCYkP5kzRgHrrDFjarSmjsFok/iQFT2R2SGYFv9pyQ4nA9LVb6mYgO4t05Ag/DIGu2Tw9wCM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HugeTLB vmemmap optimization feature should be optional if HVO is
not in fact in use. Otherwise, on systems where the boot CPUs support
HVO (HW AF) but the late CPUs do not, simply compiling with HVO support
will prevent late-onlining.

It is desirable to always compile in support for HVO without regressing
late-onlining of CPUs on systems where HVO is not in use at run-time.

If HVO is in fact in use at late-online time, HVO must have a way to
prevent such incompatible CPUs from being onlined.

Add the late_cpu_enable() callback to provide this "sometimes required"
functionality.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/cpufeature.h | 8 ++++++++
 arch/arm64/kernel/cpufeature.c      | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a62c284962cf..d1504804f2be 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -367,6 +367,14 @@ struct arm64_cpu_capabilities {
 	 * routine must check it before taking any action.
 	 */
 	void (*cpu_enable)(const struct arm64_cpu_capabilities *cap);
+	/*
+	 * In rare cases, capabilities are *sometimes* optional for late CPUs.
+	 * This callback allows a capability to prevent onlining of
+	 * incompatible CPUs when the capability is in fact required.
+	 *
+	 * Returns true iff onlining the CPU is permitted.
+	 */
+	bool (*late_cpu_enable)(const struct arm64_cpu_capabilities *cap);
 	union {
 		struct {	/* To be used for erratum handling only */
 			struct midr_range midr_range;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c13433316e80..7e2c134f3b55 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3684,6 +3684,14 @@ static void verify_local_cpu_caps(u16 scope_mask)
 			 */
 			if (!cpu_has_cap && !cpucap_late_cpu_optional(caps))
 				break;
+
+			/*
+			 * Some optional features may in fact be required due
+			 * to particular runtime conditions.
+			 */
+			if (caps->late_cpu_enable && !caps->late_cpu_enable(caps))
+				break;
+
 			/*
 			 * We have to issue cpu_enable() irrespective of
 			 * whether the CPU has it or not, as it is enabeld
-- 
2.55.0.795.g602f6c329a-goog


