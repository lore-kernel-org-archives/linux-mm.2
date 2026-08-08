Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5234AC5AD2B
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 09:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC25E6B00AE; Sat,  8 Aug 2026 05:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32BE6B00AF; Sat,  8 Aug 2026 05:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA026B00B0; Sat,  8 Aug 2026 05:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8B7B6B00AE
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:40:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 965781402F9
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:40:20 +0000 (UTC)
X-FDA: 85077606600.29.B3CDC49
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf09.hostedemail.com (Postfix) with ESMTP id 029C014000C
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:40:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Oo3tU8Ay;
	spf=pass (imf09.hostedemail.com: domain of sh_def@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786182018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUMOOEBQX+6lir6ARl1Glb8AZ5ih0WCL/+4lwXJl+Vo=;
	b=TbZh8867CZABz5gZKv5ZkRUuYkFC+TElf2DOTl1RrmpkWzb53OQ//jwzC2TUwsKq2d3/0K
	4EZaO25b3TBrPrKeGMtPtMihqsnWw6mOaz6B2/R4fW/UY+iMIl7EgFvAmyE1OxrMA9x/R1
	+FgN/fQ5NfoyQKlIeNOY6q+OdELe0ws=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786182018;
	b=lHiy0mVMoYACmsfg9/UPBxmn2qSui/WuqyjvI8nOxRabxHX41MW4cE3ph1/TiKcwQsmLuG
	zCUDSbt0k7soSFmfwqiZWNxrGxRPn6T8bLSP7MXA/j6YvulEvN9WQm/zzG86/Qg5zewsHA
	C2MHOJnUJFVL+6tqecz9gr9yKELyYN0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Oo3tU8Ay;
	spf=pass (imf09.hostedemail.com: domain of sh_def@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=VU
	MOOEBQX+6lir6ARl1Glb8AZ5ih0WCL/+4lwXJl+Vo=; b=Oo3tU8AyMnXEomyka8
	r6FmDIHXVz0qz87Sd6P1Aqhe2Fc/zwaqmn2NjlKptlmUcOS59EblX23BOe0NHIfV
	SbdSEZdY7mPpNxnKRGoCfHHuIGFKg+TbmB5GNkSMiauqZsYm9jiqL+NlyHuZrGfT
	g7T/Bv1/wvXxjqtsOMJDDDCRQ=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wC3DONb+XZq2dtFMg--.6252S2;
	Sat, 08 Aug 2026 17:39:40 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: akpm@linux-foundation.org
Cc: andreyknvl@gmail.com,
	dvyukov@google.com,
	glider@google.com,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	qiang1.zhang@intel.com,
	ryabinin.a.a@gmail.com,
	sh_def@163.com,
	stable@vger.kernel.org,
	vincenzo.frascino@arm.com
Subject: Re: [PATCH v2] kasan: fix cache shrink race with CPU hotplug
Date: Sat,  8 Aug 2026 17:38:05 +0800
Message-ID: <20260808093803.3138988-3-sh_def@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260808003921.fdb0df9ee4417b38f15e8c68@linux-foundation.org>
References: <20260808003921.fdb0df9ee4417b38f15e8c68@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3DONb+XZq2dtFMg--.6252S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr1kJrWxXF4UKF4UKF45KFg_yoWfWrb_Z3
	48CFZ3KrZxXF1Dta10yryUJFZ0gayFv342q34UJanrAryYqF95GF4kWrnIgFZxKrZ3JasY
	yr1YqrZ7G3sFgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUj2Q6DUUUUU==
X-Originating-IP: [183.192.100.171]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbCwh3NLWp2+V24IAAA3f
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 81p5sx8pyqz6y3b3s1b8rws5tcnraw61
X-Rspamd-Queue-Id: 029C014000C
X-HE-Tag: 1786182016-375928
X-HE-Meta: U2FsdGVkX19ic3aG5V20AnfYoDEL/Hba8PO+PCxi1biU64Pa0gtwY7yjfYQ/EwjpMCw7CQNjf7lHqrLMEkXi7KExcr9QiUmsNl4/paB61iNF3amLczRnW4ZjySdtoRE6HTnI4UNXNv5O71+q8rspDdWttqHHsad13i9CAZvCZ5JJ0aWwL1T26RBrk/dOrUpzmY6y9Ua2htIA678rVCZmeGYS0tcdUdAJHEfn/ZXfo/TUCdXlP5TtH2M87iDZayfRz6R7MCXsJJtRjomanQYGzPXVmr6HIn7qvs85gJZ+r7J/05Pq7t9bbmvbs6tJ5aJgnb6KEfCiX4up+feW2wlypHoA1Gyo3iaCTRWKycKFFDz+hA4pf8BFS0PwC/oF6y3EbpIAZVVp3k1iG1GH/YsG5PpzMu7ty3J2xrRWXu/NE9pKsc2jBBKaF0m6Wyy+/a5t9asXH5KD8cuEV+JuaZIBFXp3C/IPP8YqyAemXbdXM8L+0Q7I2/XapmVh+cKqK6z98pa4waA10yBoQEw/WST7DIJO2jcUNiiGVH616kEmA2vV67bqUOIxdyKMsuZ4+bbJ0kkAeooedBm2SuWmBGlfKcknA+y3w2hcCG9kV/Q17/D/B0HJrJwplLM4WMrgJO3hPK4owBBBluv34vBiDPn716ptDREmBlKVCe4XlhGpSTo3SDIOEziNGvrfOV0wTveh5UU46TYijr2nOgMwdCUZch4glsYkCZ0rYXx9syzZc7oK7J5q/lzvf4Yj6LnlMjY+2PGxanGmFuRCumtr6AqVlM+ACo0RMb0kPRxZkAH0EZEqU7HNEktzZqEiEPMmgbmFwvqUw1UXh32J5LFxznVcE+0ZuxP/w1nRVxKYZutbKtbE0XyzBPdFhsZQP4TSPmoyzSGxLnkV3aJcL3zOmeuhxbwSeoyvprw9bdKIcknhK3QJwJAvH3JenIT9HfOlhMRKNQWXpz9+kifWRZMeOVA
 8PXzBZMX
 AkQ+JXJpA9V9IxEqcBey+PEbpnRCKqi5iHvcf9ktqtf0S6SFGHSEbaGN1NMZXsFoXaYBbJQG3UgJFW3w6APdSfcZGpPG4O6JKFyes4/qSSZFhOlYPX8lbsEMl/UXr6ZGZXfj0monv/W5SlGN1u/GZgKBQmxel+R/S11cwqWqh6huFsrY29+RduYgPYWnZh3wtQj1qXJFRmyF4cRTSlRZroLhPtDEC8EZjgFWkIdWtIurDVoPgoG7Kdtw2Z/n4VNv1eYQ88mNFDrToYGkjKvgc1VRn/fUMaaDzEJDvXXDdoN7yuoCtIg1nB/+0XliHx/0se+zUuUjwZkq9QT1mvhKrQ9jv8kUZUcebHLs7MB62NfoylwKzSndLZC7773Kp/vVw5reed21XeH/HcgelvkHyy88C3nhetXe716CePFF9u/kj3skNQ5vjY7PoURyvag/HqkrLOUfN2q4A82Y5T3lyFFrq+TYHBUshnSRYjOH57jVdJ5gsguBzDbL2vJhGL+ZfdMqrvUQ1bcWVMhew5cx6Xzo9zKcNWnmOoqh5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Andrew,

On Sat, Aug 08, 2026 at 12:39:21AM -0700, Andrew Morton wrote:
> AI review suggests that there's a pre-existing quarantine_size
> accounting flaw later in this function:
>
> 	https://sashiko.dev/#/patchset/20260808031459.3032812-1-sh_def@163.com
>
> If true, I'm surprised this hasn't yet been reported.

I'll take a closer look at this. If it turns out to be a real issue,
I'll send a separate patch since it's pre-existing and unrelated to the
hotplug race fix.

> Also, I'd like to see a need_resched() wrapping that expensive
>
> 		/* Scanning whole quarantine can take a while. */
> 		raw_spin_unlock_irqrestore(&quarantine_lock, flags);
> 		cond_resched();
> 		raw_spin_lock_irqsave(&quarantine_lock, flags);

Good point, that makes sense. Would you prefer that I fold this into a
v3 of this patch, or send it as a separate follow-up patch?

Thanks,
Hui


