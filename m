Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05AAEC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D99F16B0096; Wed, 23 Sep 2026 12:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6FD46B0098; Wed, 23 Sep 2026 12:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD976B0099; Wed, 23 Sep 2026 12:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB78C6B0096
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:33:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2E5D16087F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:33:22 +0000 (UTC)
X-FDA: 85245572244.10.6E2A438
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf14.hostedemail.com (Postfix) with ESMTP id 050D6100009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:33:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m8H3qOXO;
	spf=pass (imf14.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790181201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMSEiPc5+o34xNJdJ/12oIWCPCor4YVV3MLKdTKKMrI=;
	b=Zz+KD64H3Iw9MpkVCCom7Qr/ynVvLuzk/RaLIx2X6E93e3vcME9mtUWGortTcFo7oBvoJN
	Tyymwc/pAgof3CtCNqCuuNRlkjBoWp6bpPQO8aidDitJnfUzTbFn/m/MFU08/VipZgZhcb
	Be4kxVI4gJYCzaHQQ0L8xi3RAl9nb34=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790181201;
	b=x+fBPDVEoGv7bQKL2Ki9T+t8O4TOCjnSp9Fc06UJLa4G0AsG2X3YyvgTBvU35YuIXnp1SZ
	MAu2reYO+Ncs2qUvKhYJsxlBuquHKcg0RFyesfGHI4YMMccU5su66vTC+xdmGVZ4NpVhVG
	zyLkz+6GzH5OPgYJsdpSMW+fkrYAzEM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m8H3qOXO;
	spf=pass (imf14.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6598dd44so5941395e9.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790181199; x=1790785999; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MMSEiPc5+o34xNJdJ/12oIWCPCor4YVV3MLKdTKKMrI=;
        b=m8H3qOXOWVjUyACCxMFaQSTDrpZPiLNC4ogN3pEJ+n497/dBWdCoMjDprxhFri9bgb
         yvvHHYGwseX7TVwnAbCcFp8N9e5FMcy6eb38ca5HBCEVc/cV7hAFfrX0O8yvg5FRHGf2
         G0X0Sxx9rTN1xja9HMuEDRYP30mKSiY9V9adc2b6MxjKiHj2pkkNywSXUjcGRR6ovcoJ
         cE+VcoPe3FHpKM58RaCVYCWbMMstOs8pvSzK17CmUJyeWqQN2PpG5znJok8aY/+lJYqm
         uMeVdzBQW9RR+AeT20c331Qw6oLNHy2ZnfBx9z+YSx4S+BfdapuBUv7J0XmGImIGnbV/
         2teA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790181199; x=1790785999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MMSEiPc5+o34xNJdJ/12oIWCPCor4YVV3MLKdTKKMrI=;
        b=ATumXiUopzEI1PMWyEhBdcPGcPwo1EEr4rb9vRnakGMn/AMndr08glfOroBNHhGR1F
         N83F7i8BPZ6oLA06nLf+KPFRO+Nrf6Fwn3CzwWYvOhKXXtltVwyt4246vd/l1fdT0yam
         y+K4S9lNhMTPR02l50wXtHZiatx0ZUoNm0NPt3w2uevcO6Qnp1E0VtWCmhXgnXFHWA7g
         xGPTZx0GgmwO0GPXmDbXVPrsx0aNsZ8A/mvFtajdbJU+J/lDBv7ZuRSHUrbRb3Ojmk/0
         oV6ZuqiZxKkzJ9Fzif4xcV0iY4XJt26xgCVWtdmKfVi1N4vJ5Stq0UFQNU7yptnYtHgC
         5n5Q==
X-Forwarded-Encrypted: i=1; AKwUvBxyMKvyIVj9VoFODtsNDq4y9DA82y4gMAY4nALLnUa9nkT5yvnc5IwloPlZQAJH2wfOulbpmgECjQ==@kvack.org
X-Gm-Message-State: AFuF++n4Zmujguu0DZJ9xFXyPkDjOXJcb/0q34wPmvaom8L3tsdCWVW4
	HOPx+tHzCKHaJ9JkPQQn/7Rrtz1h13T78waErW1J9ZTu4GGOGhwS6NYx
X-Gm-Gg: AYBFou0OrpuOOBex7M6gdE8YF0lIGTeVWgIcYRldGp9DUNT51e6DzLf7TSpiXEGOZco
	D/f10yZow5GRcTN0JgJCHmTKywpwLhL2su8Gho+/jVEu+d1oHiXxBGbZ2xyp9BjObZdnXPwpBwZ
	nH6jOlMeW6nwbDdr2B+8vRlqk7xN+2iIosfI2ksTgeED+rueD1TTn5fJXSR+uY4jGpuJfuRjTgK
	iDXKHgTOBjHyF+gCUFjTcFzKWid9BlOGjksvmroRrRtrovRBSCq3qaZUnwWMqlmo1Wb+eySQs8u
	vHijL9SN409ei9//tHpzVNV2EvcMWw+i/nFpKEBxaVSVxuVnXy1S1kcfONQtcaO4xLOAl1h5v/5
	u+hl5G/EEsulq2PwR8rLleTFiMy75JYt0er3VHEsSPxNO7fKFTbw27kfTPGvEy7P1DIaal7Y+DR
	PZLpJSLXTjpzX7HEShMHbb4D4PTvHm0ehRgpgIHmaG1FHohwZMFxLfLdrhXJ8Wm98Dngcam8XgE
	FDc1tYP1rs14HagzKPsEg6BvfgBG0UXnM2L5z301NJAe/uChgalyFZoV1bZG6lrT7GFsSM=
X-Received: by 2002:a05:600c:1d29:b0:49c:cee2:a508 with SMTP id 5b1f17b1804b1-49fdf12f7a8mr57065555e9.16.1790181199387;
        Wed, 23 Sep 2026 09:33:19 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdf9691e2sm78673275e9.1.2026.09.23.09.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 09:33:18 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Toshi Kani <toshi.kani@hpe.com>,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm: avoid a reclaiming allocation in pud_free_pmd_page()
Date: Wed, 23 Sep 2026 21:33:15 +0500
Message-ID: <20260923163315.275046-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916062222.27347-1-mikhail.v.gavrilov@gmail.com>
References: <20260916062222.27347-1-mikhail.v.gavrilov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 050D6100009
X-Stat-Signature: k494r6eor94ia9whhy8gmboyxsuowdtn
X-Rspam-User: 
X-HE-Tag: 1790181200-503749
X-HE-Meta: U2FsdGVkX19QFCj7F91IsqXY12Vu93ytq98su/mHXUbEr1SK/edczFTz612Gz2iDIr2CbPHPvP0NbxlqUzFw5Neklfq4aGqEAoSnIm2ehLa/bJYbqS3j6xOoX5CWWkA/m7yCQayIyd8FF9YyQrvQKE98GKbRNCLqp0ygpitdNU3TWBXiup8gCxBRJt2MJB7kWYDQTq16G26wFAW133EXr6Clu+V76H5A0did3KVEcRAZIMxUYSCBIpOBv+/khj5JyJLYdwwo4DusCPJnlfTQQe+RXK+WiKb3VGg50TzMFfgqsxiBZeKSpX0C9OkWbEERVbrkteIfOViDnRNM0thZTvbL2pULkLrq4dsYzIOJXrqcFdL9O6/vpvo1EZJ7qNlC1c6loZBAkMF4voynX1mFDMBj/Q0q1ICXmjX2gzXp4N9Ap0XaXACrxYFzrpp9CWz044EJo4CxRAbNHw2F1gdn4c07up+iDYRqM1NPzjbxwmBH4UnkyaeoSNzCXlJowU1jS4c3HaH6TSBMcYj3RMF9B73p3cwjKhOb548xyvh6ygwC7MjhNyjty3+WM71IsQFwVnpXGfaETUOpTShb+SKavtx2jDn1s3z/EWRn6Q5sWcj3f0kaFFcKGmd9lUBjGylXeMjntthaw3NGmoc40N231mmtyuE6WtVOPKLqT+qvI2EiSCVK/wPFD7TZaZkoMpqfLJf2OcnXJ5/7imwps+WgjZyKDEq8cxWBTyqYO24yjM4H2fX2+OJdUG4M+cMbFNfefomIiQopFHTn6/wYEBbnFH6qOcW6RftjvXJeeRKWGenVJK4vG/YFBphTfAsEkJhEzzmQ9iUGoKjyYZzt/crJY4MNxEAIsAbjspD4ovRYCeB5VI+iddpwQ0p/bO3Zd2yLt/zoiHw0tRFZh69u6kGyU4Ox5Msg8iXfp/2mBTEjZWCqgqKcS7fPHNCvTQE9oNaVGtBl1RBHFsXTav+9ZbB
 CDNp7bxw
 OJKkgoGtfCQTyXhyWrwTnbhKJCUWAfPWxCT3rfFDMHlwGAu/ZcuzqLa9d74d4pYhGnV8QE+snRKaM33hCDx0S6KUcjC61+tLI4j1Fr8dbyWahRZYaWcBZrlqj/OIVSZ75GexbUsCAy6IJM4bWbNpKDGhSAhgSrlGbV9siV+EGmkyIJHAhExqY7LX8JEt2kDEf+jMGt0brmkKDb98XG/RJiaFedFRz0ar+EZJaf21LT6ogab8lEZdzkeDKlbWuVJvLXNrBFIrDi34BUKrhNu0bDZ+0YYCqmlaKb1B/zGx8vjDrxVsl/7qh55B1zsZ4GxZdcUgEkBCDrWKkOz/6op6dy3OFWRQyUAwRzdpoRn15mFR2UcBYaN1KZB4Qomyv6CcMgVMHGQwh3/BDim3kHxleX0Cet/GeBy6/Qb+Ucj8h8oR08mB6UxINdRYKuk0gc+iuflgK3ZoLjtGiNMcKFVmHt1/ocUdzjhxmacvydc96UPaN7h7hpmKJPimS8YPb/WVtsK/fmTYFQuxe25GTvJiUeCdYKS6J4qnEXxlFnAmKTgWhiD0TxEvNlmVbVUtzYrxPKOqQeznhLuM9/L9K92kI+8CDFiab4IJPCXd0UIljCi8GNVSLw54kORqggJh3BNh80euK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The lock cycle this patch breaks has meanwhile reached released stable
kernels: d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on
attribute changes to avoid UAF") went out in 7.2.7 and 6.18.53 on
Sep 21. Both trees already carry 26444eb71465 ("mm/vmalloc: acquire
init_mm lock on huge vmap to avoid ptdump UAF"), and pud_free_pmd_page()
there still allocates with GFP_KERNEL under the init_mm lock, so the
cycle quoted in the patch exists there too, not only in 7.3-rc.

The patch still applies cleanly to current mainline and next-20260922,
and the reproducer below the scissors of the original mail works
unchanged.

Dave, could this go in through x86/urgent for 7.3? Lorenzo, since the
rule it applies comes from your series, a review from you would help.
If either of you would rather fix it differently, I am happy to respin.

-- 
Thanks,
Mikhail

