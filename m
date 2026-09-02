Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F3D9C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF806B008A; Wed,  2 Sep 2026 02:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5911B6B008C; Wed,  2 Sep 2026 02:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457AE6B0092; Wed,  2 Sep 2026 02:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 235596B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:45:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5456140703
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:45:34 +0000 (UTC)
X-FDA: 85167886188.26.C8DA994
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id E736D180003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:45:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CSJvqTUs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788331532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A1Ijfwz6wl79jsZ8nek7Aw8mUO11NOUio6A8OmunRuU=;
	b=UOHH7KDthXI3Cd1e8dr6lUnxjNWeHls3r2SrPQddYjrVdPJYDA9hFi777AeKN+2oPjRpi+
	Z5l6JW+3NhRA2o0IqHf9aCuqnwllS8TuvnBgx0uff1QRDSX49h/Y8RB/TIwbzkJvuffom/
	cK0+qpcVE372PRsV5f1Xv2n3+svy8wI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CSJvqTUs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788331532;
	b=1kWFknMl5Y0v/gsKkKBdiarDxf1zM/AzVZhRfFBUUdsaFqlDiBEJG7MONPzpLu+hhqkv5F
	f9o+Nwoe17VYfMVgR6dau9WuKcvefmpEtDMFFeiS+0HT3x3JbWPfO69Szc7BfRY9pxLVLK
	FpOgGrID8aJEBGaUGytiXGDvM6/yvyM=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d032846c95so7838315ad.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 23:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788331531; x=1788936331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=A1Ijfwz6wl79jsZ8nek7Aw8mUO11NOUio6A8OmunRuU=;
        b=CSJvqTUs2ycq/JjYN7XaYf+GZV9b9BAJFcLf5w/zuqLK4kCodjbO++Kd0Ldjq5jxCu
         mIGb2Uee2oflNmPdQdGkTAYwMjkVsPGJmcXnjdaMf7jCrNYJANvES7WQuLwl0G5wEymQ
         K3iegoNC3AOiNIL12swh5trtwZdidMap0cOzHT2UHBZ+FV2CJMxnmBADPmSRXEGypAmG
         49oAyWhRtzmecSWpZY99reR4AwUCJFGaIrZJFLFQj3OS50GJne39P97h7Q8RWF/gEAJF
         IGLXTAHebifqtajZoxVSBZuRM8OPvWZDxCHjdT/ue+dwUTpd1Nf+67imZb0SqZr+1bpY
         zjVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788331531; x=1788936331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A1Ijfwz6wl79jsZ8nek7Aw8mUO11NOUio6A8OmunRuU=;
        b=QkfXVHDuEBY4AKeV71YZvUNlhkdZkwunEN2LispMcrWkzSYkMPoERmUor/8cpF9iRQ
         91mPJKWrgSpITK4kAvG0vDqzqI5JdCxukdK7CQZ3m9uEXhHb6H4/ui8K1Jp9VFinvVg7
         V3d9rka7QX9bTDgTZlUuYqvjpquIKhjrlrjTrPqfCq7rnKIk+yT1rb4pRaqZnsUo+gOm
         vEUO/gtu6rwHtuctHX4tD5ANWRzwrCQjVRS2X0k3HWUW5RzYJcJgefQ10K7Q+XTZFtMO
         xteYQgVFeQVg1RhJpYg0cHXfcBltafO9DhoeXcoWSUn27fFvEb6LNYRiTXLA7aLRda0q
         TRNQ==
X-Forwarded-Encrypted: i=1; AKwUvBwSK4lAS6spNCZPrkn0TNxGCTDNM8CcOSLoCwrz9tSA0/24vVcQNekpiws7owH/yP4LfaF2XJN9Qw==@kvack.org
X-Gm-Message-State: AFuF++lOLViNE2kb6ynBPh1eMJyp/MW+Dziat+hhXo4eqWaZYxcJ84lO
	SEI76RV7KwPiuNGfJPRml0HUOY97wxxxDStif22RE+iU3IRs/LQOGQb1
X-Gm-Gg: AYBFou00ZWLIZAHWYHkITdebeyEwgzaM6jBchmG6YVVkJI7df+2H/l0Jko5JvCIQBhf
	PKMycMycBY0PYjbaWudJvosBJ/OHOQEKgR+0aWeLevkHaDR2oOxOzIEZwPDTiNjGf6zqXAuuyFP
	o6MTD439Ru8zJQyprPl/oSTMCKaUfM8flSYRgHK2Mn05EhHts9kAXPnQOeDITjGr/ZxOmFghMcp
	DWsZWWMv5y2TyTaK1IhAfIvHcRQCmGLbRREmDo1+TiYNV/kiLizmW4arjtH/9U+QdBLYetintjl
	HuLuB/d/MUarPDoE8CMnpoJtyeyZiYE4Smr5hShmYZnDdlL97sIRIJE5pFrl/dFTDKFn2/kfP0x
	VsHy4edHXvU6tOt+2xNrmJOG0Dii2WzNSl2omeVpuiSjz1w8N9aZ5FLxff9YkZ8aGfWQF0K3HEu
	CkQfqJttgS6XHyjfLi4VvZcIxtveT9iLJlb3CqRAcFO9fs7OvZZE5HGKSB5en4m/OHMhoLORCRZ
	s3VCNfp/RCRaOy+
X-Received: by 2002:a17:90b:4a8e:b0:38e:4114:d8c7 with SMTP id 98e67ed59e1d1-39aedcfc81bmr3925777a91.0.1788331531419;
        Tue, 01 Sep 2026 23:45:31 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bd1b395sm11051480a91.1.2026.09.01.23.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 23:45:30 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Meijing Zhao <zhaomeijing@lixiang.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wandun Chen <chenwandun@lixiang.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] mm: trace: decode architecture-specific VMA flags
Date: Wed,  2 Sep 2026 14:45:07 +0800
Message-Id: <cover.1788330432.git.zhaomeijing@lixiang.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dm547db98u4s7caxwwk6zcc5p6sw9iuf
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E736D180003
X-Rspam-User: 
X-HE-Tag: 1788331532-439234
X-HE-Meta: U2FsdGVkX19r0v04KYE33sgc09CybzqDYPTXv5grKEV8KFPDSuXL4c2V0uISX9eZkZ2YLo6ATdf4rNSR3ijRutZc9bUH1uCUUr8LtJX4DVOy7b4TdwhpR5fUNWZk/Pi+/VEdGe3gYi2mz4CX3iJIxZRPxYP8imnrSJrAgIbLNbUAB5MCx/sh6OgClDsLj9LFLKUi0C5Yyc4NfxLLm/JEzYRa12cjgVSLRSx/dusIY1W0WI6a8pXP8b8uU3EJql8KtT56G8AhT2AElujqvCXDhw9CEUeMkYKggi1H+4x5IU8yry27ndcJjUnKefoPCEVONBgaCvxDCnB5yGl/J96RH7atfo+7L2O4JoSfj9rIB9rTWRjDHpWNdrK0o1rlwjI5bxO6EI1OLhkEou/J083WCzLCBnrd479YZ5fd7O5vZiBTFnYbYJYRL73qxwC1wy86UxlIVU08UBjO+KqgVUbD29POQoE1ptDw3sFnFzfliSmvae2SzV/7UiiVofBu4RrVvcqSBEoyqcXUXUgDnCzIhApE24sHDnZJbu4rBEaFVRh6MEJFLZZrd6lBAsWEnHBMQnpmuPjIQ9K6F0dQI0CQL7vVu4X2B2bKJqNatSYHKXDt0JKaCfzl1Mc8/Cf+6TjX+X7o0o/N7wDtgbuf1EKQzdPNdEbj4XmZHv9VwKwVNwl3ynvxNCjExoCxBTXEUbefod7kWsg9wV5LNn0ybpY5C5YRMSPgFjhz5bV2+eRQKlnuRfW3U1GV7psFTY/beDxyRIkAU45ya9c3pDCnnD51JVM0MdbBhZxCFaN/xFqnP6kz3q2P3oJbFG24w+0cXbzdkPJMGvzotd10/kIwYDoD6xODLkOcdZpKU5D9xQJC9N8GBn8doilK20l06EPyS3gH38grmeGngSuW3SPEpeodhPySmu5CYJvQG+h9v8U/pD21mBbUokhYVEVbGJI1YY/9m8AUNobt6jhltopjdtb
 tIEuqpqq
 IE9BHqbX7Av8rfyZdNtdeoGq6CsbrCTrWmvv+7sNCSmUOD3R7vdVaTPQH7fjKWzAgcWXlJd31gcuyPYMRynAt5V8H7JsJM2zLrNoixQ1lJIRASrMx8dW0eTW2/sd978N0TgpxisRfXPe8pYuNodR880bY7Y/5bSnrwpiJSOAgSkPjJFjPZcipuJ2k9Oo0FplY90go5CvMNIVnAF3YJI4ggARGRC4E+7uLL/x/n1xElhEuzUk1CeKqesUcrc3Gx/cuHfLCgZKGC5/Eu2w9DU3bNOhGLJAw82G49ZNSg06iYkKMBqodaMWu7taWCNgwq/y4oCzqYwo9pQG4bm3ZnBE+TzJ0nQDyCNHlExDFEzn9v2Dc7HPV8eLiiAWEBpbw6YSTWAPM0s7aFMuWetHFMt3fS75kE05PakyzZoqBB9geWr0vOlivRGH/sdt8lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

show_vma_flags(), which is used by VMA tracepoints and %pGv, names
generic VM_* bits but does not fully decode architecture-specific flag
positions.  As a result, trace output and VMA dumps can show a generic
"arch_1" name or a raw hexadecimal value instead of the meaning assigned
by the target architecture.

This series adds symbolic names for the arm64 and sparc64 meanings of
VM_ARCH_1, arm64 MTE flags, user shadow stack flags, and protection-key
encoding bits under their corresponding configuration guards.

Changes in v2:
- Rebase onto v7.3-rc1.
- Fix the patch 1 changelog: "bti" and "adi" are descriptive trace
  names, but do not match the two-character smaps mnemonics.
- Cc Lorenzo Stoakes.

Meijing Zhao (3):
  mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
  mm: trace: decode MTE and shadow stack VMA flags
  mm: trace: name protection key encoding bits

 include/trace/events/mmflags.h | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

-- 
2.25.1

