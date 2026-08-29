Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E345FC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 18:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD516B0088; Sat, 29 Aug 2026 14:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DBD6B008A; Sat, 29 Aug 2026 14:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C506B008C; Sat, 29 Aug 2026 14:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79C786B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:02:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 062FA140185
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:02:55 +0000 (UTC)
X-FDA: 85155077910.15.CBF237A
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40C80C000E
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:02:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=crserw6D;
	spf=pass (imf10.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788026573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i87P69rcYkzXTWHP14+OyA7oFnzKvLPVHE4Ngy0a/UI=;
	b=NlBiH9ZPrqOl7o3qGFfQGhfU9em7ST0ut231fLg4ef1IWci6Ov5/PlUEPxquCFfyrbou/J
	McijPibg1cNwu/d20P9KNN1O6CSawH98S3LiONv0vQhatBl+YJitAdoqvgoABWE0Xlrues
	LuNmO2sQuecxIqQ5NzEIasG5uyl0NhM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788026573;
	b=7HRqF4IAVcPR6gKnJGmu74DswQgGs0B4pzRK0AHnmUQe4a1sSvXJsvUr4cv58jQadBrqXp
	kqyM6CVByfuIygpnCb86enqHRFMsXdbzbTM4GkJyV4hVSq5DusvPnoWKBxrYtdZbKVWbQ0
	Qz533JuhWT7bA8uWrS5UDywh1MfaOdE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=crserw6D;
	spf=pass (imf10.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-398c1101c1bso209983a91.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788026572; x=1788631372; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i87P69rcYkzXTWHP14+OyA7oFnzKvLPVHE4Ngy0a/UI=;
        b=crserw6D2zeItwzjuIFpBN4sIrxJfq5iCaxmeCLjWCZHn6uWx+/Uyx9rGfS8X+DxJB
         YQ1Ep2WqX3fbIqGeJr+gJTWzt1ZSVrO+YnLLtLw9BcBaUJitJ+BFCiTrDulJoM+uEVIG
         YYiqtPKPRW0KCqQOrGiGzoRVn4/5UamXNPet2Vb5CeTFarBoqaOR3EDsOu0JdNYxfTUC
         IeqrrVhCdGFhO3j5rRjSdE8y729kXKjbbWM8FpI/2/aeOc0/vSQO0gDcFOFeTAFMrKs5
         mnRraPBtu7adn5FIOdcq8WdCe6DXUofJYG/fHO06/c16MRRc9jzP2PURRWjEQ5Qbib9n
         lZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788026572; x=1788631372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i87P69rcYkzXTWHP14+OyA7oFnzKvLPVHE4Ngy0a/UI=;
        b=G0zA4e5p9mYbYxwNReT9mTEnPTjSfwSFZlRJUVpe6VXB8+yiA50p8C/zDyEn9UlG49
         rh29Y0QIMS4DgKOA3vtMrR7FxpkL7RjT+ixzsr6g3W71QTMHpLLtI9c1E4ze4bksOLv9
         YvDdXjIxmSHWn0wL60FjB2bGDamlfFL53m2zHxMIGWvec7PqCqaTS5ILsluXt3ex2U11
         /kog+YrljcdHYA+vF+9RBZFRAEz03qmqCAl2GwFA6XYhFfIYEHly5UdqVCVbTS6ubeMP
         exJB8TXmcdNSSgd2nmhH7sQd5TwAF7HHbl/Lw2GdEl/Mouf4HV7Aon2z6bEqY0ZtsuPu
         T4GQ==
X-Forwarded-Encrypted: i=1; AKwUvBwAaAnoIBjf0WT5lex6u8UKeYGOjLG8HYbr0EGv4VjfsgPqpvqmnk+hEk4n/U7aJEcHuoFnL7mGNQ==@kvack.org
X-Gm-Message-State: AFuF++lWhe07U2bJKz3dE/Nsty8G1+TAmjO920PyMXIIt6EvvhXXAoAB
	OYwlREJAr9HcjmrMtG0gmkgG17wX+LzRlmKAklhCX0zA20Dy/8PcHsaj
X-Gm-Gg: AYBFou3AHSxreur4JxUC6UfdjQZHLpO6IHcUhROjoXHEt3ZAb4fGvtVxNmGhIWwZ/iK
	vjIRyaKENB1YR7HowCALkfAcQyUjI/UDfYEY/cH+7cqHHFYVpHq2Y7+8onrxsY7ywh16Nd+W8jc
	HrcAgZqS57JkQFFQkvY++2nWaUVh0PeE5wsEgaRL4DxzIWCbdwr59gRjJBOLIw1b8Uqc//Y0Qbe
	HwdL6RToC8L4866qNNjOa8oyZlyM53otwQrjAOvJ89edxlkdet/zkrRFESWHwLzeUIdlK2igZkN
	MMN+xyfhW8So/E6HmhM3Duq0U8efx5UXbvYazyR8LlqTEiWx+dTFhSufJ9AWpy+Ed6/Er0iA3g4
	l5kyHtEwzUVQ+DQpNZMweM7HZv/hCF22qjVtIGEEvaZxOYEzJqiDUEJobd2ePQMHQMbBb34C/Gg
	q4AIkJ6/HCpAFszDHPKtl8UJF/1sk6JE50kS+KFz9EeA9zdmHY3cXrEFySJ1UTmOWE3i2uH/mJS
	I1IOuFsgnL27R7D+Y7Vg5NwOXq6dwv814VMwq/oj5g=
X-Received: by 2002:a17:90b:3d91:b0:38f:18f9:785 with SMTP id 98e67ed59e1d1-396d0f016bcmr27981938a91.8.1788026571891;
        Sat, 29 Aug 2026 11:02:51 -0700 (PDT)
Received: from fedora ([177.21.143.191])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0de4de3sm23619917c88.12.2026.08.29.11.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 11:02:51 -0700 (PDT)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: willy@infradead.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	riel@surriel.com,
	rppt@kernel.org,
	surenb@google.com,
	syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com,
	trintaeoitogc@gmail.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: fix the race on huge alloc failed
Date: Sat, 29 Aug 2026 15:02:34 -0300
Message-ID: <20260829180234.435064-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <apL8kdB0j561wl5G@casper.infradead.org>
References: <apL8kdB0j561wl5G@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40C80C000E
X-Stat-Signature: bdzc5qfpwja18318mou81r3ir7ezh6fq
X-HE-Tag: 1788026573-159593
X-HE-Meta: U2FsdGVkX1/ZsTiputJHcJaYniC1EQI3KrV+aeSnH97C7uL3zRTtlCBGEjJ1AN6NTRpmaUaz87eQyOMMV1VXODHnv4+cR8rHlcS5bSQMiUMPUfMZQu415bw69HiCe61RHEAuzP3KaTxDqE2FxybqIKPPBSGa74smq7hHfiHLe+nWKZvboanGXZvR+wzXLxK5Lt2DGL81cQ5WQBqezI/g1pIF7Rz9CFny8wwRnI3y0gqh2k59HOvP76EfNo/f+1WbmgB5IERgsTuN42F1q6lskleFRc5NLH9llePR2akuOykeAuhdpzroZDr8dsm44AJXmoSAIGwyoC6P2kGE1pN33N4CHKsPR3+ecswUHxTEpUwdZIXCHtv5mHSvbZzefJYsQgn3Eod6d54cEuj+Mosk+jQK2KBfAXCpn1ZH0u+IVHpUk7kJgJurI3qaGUNorMjpvoe3Cg9H5YSaP2P1VMvS+vaxYko/9YPc4dQgC+aDI0sAPVhvwheQ79W8BkHTr95Pf4fbTufSYh/DB0Gdu9wqzrO5oi/oI/1BZV1ua3AUXIP3UCCFYTEO9/c7GHyrAQjP/bO7liTtcAsbrINSqegV1ohID9Ik43OuX9x386k2O0qO6AFzAPnetugt3sPD6/AgW1lAaZpXzNb+6hcsA98v33nndvvvo8cq11Wjohe/v/5eoSaZpOFAwtPn3yA3SuRKuMVpcshvBcazlVmallmmkCFhq6/cFiY392ivRL9Q9SfnkXmR5Ih7J6fFfd4EIIPdLkCt+arWB4vwme1RheofVnlLG2u6LtIVnt+rtXvTT3AzEgqg9+PPu5UgZqQvyXaVO7oL9bmVsJvTlIz1lsr/WsiT9MJg1NJeasS8zU2Pb4fEtAwr/kULOxRV+RCAzmBLQVto1OXuVi5NbOgZCOE7l8W1I9l0bxxaKybJ3qrVA5LVDosj+0MhlaEMJRvhFraiG551gLHQt1YigNS7aOG
 1Id/xry4
 L1Y+c5k1hKrLGUQ8bIQUbuimGCoe+LMbn8i02D4YI73f9k4HDLFKQ3PEO7koAzSvQH6CH37bctjgAyR4tcZFiObTbjUNbY2tQzFLJ9VrWbsZPGGj18CNvvbJmpKaIGdpQYj2TimJJ9QI3TDlQe9tCzLzj5o12QqB3nDX/uvjDW+i+Pgw7ReB807MP+Ur3/AILmS/dRpHxlfQQkLYNqZNaNot26nTlOGsdVijWHpFU0B8Z8V5ZBdCapknIqFDp0uh7AZmgqBJK3Is6/fg2Nv03IJ2esXk91Zuuu5F79oHyCVBuyN427nihrhO6O4gMVE1XP6EhyGoPgXHgWHCnuNqdNsHx1f0xrrWK//zoc9YP11TtxrGAMYtUSOwjAk7BCY2aXeyWE9GusaET5GYk80J4E8wRKF3DRxkBrPlUKgA9+wUP9lOrpVmzRSvEBRmAtGLS3ZiDmmh2+2BqY/sjiTUYFh2Ct3QH2HyAjRM6HNdMHYYP6cxjKJ0u2jHLVY/Bc8DENsvF0TIiL7FQMadK+g/Onb/8qI9wWhBU/iBZxm+3oVlvMNtNDwxQc8Hxrzil5qT8YI8VCkWU3UlPe0X93w9+BoBuoIp/hpSGZN0C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> wrotes:
>> Fixes: 164b06f238b9 ("mm: call wp_page_copy() under the VMA lock")
>
> what makes you think this is the right commit for fixes?
Maybe I would should analyzed this better. I only seed the commit that introduce
this function (and consequently this reader)

>> The race occurs because the reader (__vmf_anon_prepare()) checks
>> `vma->anon->vma` without holding the mmap_lock and withou the
>> READ_ONCE() macro. Since the writer (__anon_vma_prepare()) is holding the
>> mmap_lock and updating the pointer, it creates a data race as the two
>> access are not properly synchronized.
>
> also this explanation is bogus.  i don't have time to fix it right now.
Hmm... I would like to say that the reader (__vmf_anon_prepare) access the same
data that the writer (__anon_vma_prepare()), lead to a race condition problem.

When the huge page alloc failed, the asm_exc_page_fault interrupt is fired but
on the same time the procces that was trying to alloc the huge page, try handle
to this failed too..

How READ_ONCE() and WRITE_ONCE() is atomic, the race problem can be resolved.

Thanks,
Guilherme

