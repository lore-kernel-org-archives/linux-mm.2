Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02239CD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C6F6B00A1; Tue,  9 Jun 2026 09:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3B16B00A2; Tue,  9 Jun 2026 09:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2F36B00A3; Tue,  9 Jun 2026 09:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3ACC56B00A1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:20:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0C42C20D0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:22 +0000 (UTC)
X-FDA: 84860433084.14.E052FBF
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1DB19A0011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AthuE1Hr;
	spf=pass (imf15.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781011221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jX8gUYszHwfQV68ROQgc9IwTeEh025uy+uGQInBFAe4=;
	b=xf0v1EaVqb+i++ongmyRD4HZpqw6TdSkO7NBeqk0OzIf+uE5bORHr+80+vPTZxm5JMXRI3
	4deasinE7bDHYK1UgCa9cx4zSrALunILB3uf9HgISvoJnFwQRdxJ7rMGa0xslhCPy/Z5SW
	Qp5y+19OGCEs90spSyeh4r5Zbu+dXAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781011221;
	b=EH5sKlBDvYz1mXPieZ+6nemRtqI6+MGpxHJMmaXh5tkpaxBsgu0evAyEdxmKQlrl6fupoD
	oyJPH2aw0qDHMuZoJWLtSIJ847FOD8iN3rcZgfTNgbh2wI8M96JFojn7rPJXEA9zf6fGbY
	IR4v9S304iYviuMspWeVUnYilfFK9jg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AthuE1Hr;
	spf=pass (imf15.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-30749947917so3905860eec.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 06:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781011220; x=1781616020; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jX8gUYszHwfQV68ROQgc9IwTeEh025uy+uGQInBFAe4=;
        b=AthuE1HrX7oMVo9PNEEWyfy7NMIxJprvrZtX2PTZ6G6nmf3kfYx7T6ZzuSnT24+Xhr
         Acog+YRCt43+CVI66RXBUqtVyMpjuFMoPO9ox6djfWmdmnJoKkuT0PcHsKsFXEyMxAnH
         hLD3Fb1Ahrig7XwAvlWetIhwgBMswgu2Non+WjeG68xmbnfO3lnot/ShIp7q0KLWjsAf
         EsDIMYEmXSFOAEpBb6YL9/C9zoMSOr8yJU6/lgm/lcEdwDRbb9iHrIptNxVhsel2q9bG
         tHxGsxsfkM66NjXHcECd/D+/OAzQAicZGxT/47JVK5txOo4JgEYzB1XdYHYxMuYeNAIH
         0NYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781011220; x=1781616020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jX8gUYszHwfQV68ROQgc9IwTeEh025uy+uGQInBFAe4=;
        b=EFog/MpEQhI8oh0kg/zE0JwiQP+eUpflwYOxHV7WoHsFbrbOR3yAo5mdXlDXoE4NF1
         EEbR2fF7FMkDe85TWPydxIRlLw0oD6Xts4PJ2Apr4DeBlzI36h3u52tgbEEVnjxK2hSk
         zzYoDCVPcUBvC3iotndqquxB7rzxSzcMq4RHiO48lFK9nFGJEs/U/qqCorEXBWfIaeAe
         0xRGFvqqeeC6QSyUOt2WbLW+PzLc1cqR7Pc0+TXxlyWtVTYCwgB5BNE6nAzTp6x81us/
         tLdclm/2BHt3Kdy9rSL0heoyy8YaBCfO1nnKsVxfKt9A57sL4AjgUDsGsqp4XyuNJF8s
         ZGyA==
X-Gm-Message-State: AOJu0YzxctUmNXABEehhJPdKFCu83dV8M2nQfDscOx1P6yNioKUY4bS2
	DsIN9JXTLdK7VQnvRykF6EmTp/EcuZ+CIUGlxHzwwj7EPBF2Mu6lia0gqQmURw==
X-Gm-Gg: Acq92OE36Bit5RRKpCcxGd85Y72PIFv32iY4ubZIDf8A0xsUl8gMMkGZHZl9TuS+ET9
	M4swctcrlTvvJ5kvPNeC2jKX8VNMcEPPhVd/nP096rV2Mu3/V1NAUDi5K00tOQM2DNWZF09ACPI
	UEKLtPxFD17T/pEF81N54FM3xMrd9d5hDh0jRRHxr8vS9ZT9wuLT3ZrrySxmRdSJgOfeD0GE/k2
	64VDOyKouTANNR1yiTMBSRl74rajz6aGkysF9H8YSm5OFSylvuTabSMZkkBA19uuRsX04jyvgwc
	NJwRt+ryhnYOJbnGbbRCOx7CQR669HhseCj9QW56N7tOzuIuUf3opKm4GlOplLUcLAbq5mIl8XS
	aH/2EMmbEd3x4Pc/Klq7fKfSEl6F7EHzGKl3wlDovZa+Ov2j78oU1+UhJU3u1RBSAP0oNjW7a6Y
	AVsk8xdXEfv2UzFcoC17sfjiSxkuGgG8T/8VSP2lgQF2sMEB7Mzsy6SWWyogbGCvM1GODV8e0=
X-Received: by 2002:a05:7301:1010:b0:304:2af3:5ffa with SMTP id 5a478bee46e88-3077b759566mr12644279eec.19.1781011219664;
        Tue, 09 Jun 2026 06:20:19 -0700 (PDT)
Received: from localhost.localdomain ([129.41.58.2])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db55f60sm27162467eec.6.2026.06.09.06.20.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Jun 2026 06:20:19 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC 4/4] powerpc: Kconfig: Enable THP_SWAP on Book3S64
Date: Tue,  9 Jun 2026 18:49:34 +0530
Message-ID: <2eed2ccf40bd017cc55459523bb18c110b907bbf.1781000840.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1781000840.git.ritesh.list@gmail.com>
References: <cover.1781000840.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1DB19A0011
X-Stat-Signature: wbnud6wkikmg9msqwyb7qu48cqiwfpr6
X-HE-Tag: 1781011220-72759
X-HE-Meta: U2FsdGVkX18JjW6bJLNViEGjtakW9SjPWGR2+KrPnkeUnMaSzHSrUHlF0He9vIjtXaaV6gH04zQsVdi5/2o2RBAepytvTdDI/BH6EYLB/yRmamsHqaNQfJ636c2/JbuPt+Z8m1//NM6OeH+TpuEJ6Dx/MlmxCl3TVhwHcNdzPLoqQSAYx6y3vmMR+2AIW5LjBmux9hQlFb+W5mtrUbEP8GSB6GRDE/4ORt0FSMWqrS5vZIOsj8AgxO9EenbVyUKkTeob6jyQ8EadXrH5kh2AWL28wqq3G52OfV+BGEk6uwFMR+RtdD0DMgvjqX/iUreaN1OkGpqwaJCaIRINuwsTBQ57ETlp8u3gaEguek4Cd7lzgRWlb7ehWXkr3lbKefdEcFM5J48ixZua5z2IyVPFld8uVbRwgnYgC2xqayEaCr70tiLIvkyo+DPnUY0WKvkTou7JUZMHyu4CDa+NqPdmsZxJVqIPwpgjU8oKSbgb7VkJ048wxI4+cUcGmVmEXRfV9L2WluP6jDCoFDbiYqi9crMFxUGRKq8WQGVaz96RaH/jVIM4Iqfw0tJMYor36Kl/Nvk6wtRIgf5vGGsYiu5/9K6Dr8lFUOjs1rTE6Z7camCt+1aoUajhLVtFi6BTL520B0yae6i2Dor9vur1RtiSZ/OXzGDjzrufJdpuskLW7Y8CRrdZqLkBtbTVQ8+0Ah6dooqc/5SN9oQbuO6ZpSxs/PU/aphjBG5jrneMA/kdhspg4ZDJhtkfaIh7ISZaocf1Z8G00WgJvMDurtacTu2AS19UlsDFvBWuOWwKmKrxQgNsusLz0NKveVV7uHawlahv5AI+qZy4veAtBwyVF1AAyBUhnHo7HqzfCbFpanfNS+7UMyU+MEHaO3hs4bYXF8Fz22A3elFCd29NCXmqoa5nuv2WuP7ZJdPixSbxGbRRDfkKSQtSiUTc4zfoXWTtQ4LO1E7uIl8WR9ylSDSJj1z
 1UK4fAwm
 kDEvrzUXhsFX8sM/hvrCiB5L6dJ65R82jqp7EQRs2nZxtiahNXPo0m4SnF6jhriWfQYHgmHMaPeZVJdsBec6ATDPx+Fn02kb/pKMEp0Mz9LBdrck9/YuBLEb7AcZZAdFYgIQyijDVi4CCSbZKHjhCfTdtsdAE9CBTM5ZE4shoM/vOhrfTEjzYEsZo4tlw/7sq5b3zurwU5k9EkF0LLd7a3ZNYAZs0iGNQ7QtJalO9x454vOPs9S31Z7qqQs4K4InMIasHizqOLY23MHLsKVEUBbl4lkdaLgF2xIIrOst0AoanSsZdk5NQil9ZaMT5dXidDZKeuyHisY+tBOB/T9T4iwePYSzfkVjPSP5CWIWFhNfDlyXI6vJ2t4ZqvRYTEZZuMlhm0JS8EOtuC8AbJ+SN+uJ2Ok+O4fPnM0YB3kwSf5elNwwerBtInf5mWgXC78pUpdPEiiKs73WSLWymd0yubJWccVx+wL0BkhyIQBGE25JTkuj8XN8CWR7LLtIMLnNY6amyQwNXnl8Sd6myBFTYe93s1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This enables THP_SWAP support for Book3S64.

The performance testing of this patch series on Book3S64 with zram has shown
around 40-50% improvement in case of Radix. We will be doing some performance
testing on Hash too and will soon update the results.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/platforms/Kconfig.cputype | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index bac02c83bb3e..48f74bd22343 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -113,6 +113,7 @@ config PPC_THP
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
        select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+       select ARCH_WANTS_THP_SWAP	if TRANSPARENT_HUGEPAGE

 choice
 	prompt "CPU selection"
--
2.39.5


