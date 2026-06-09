Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D582FCD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BDB6B0098; Tue,  9 Jun 2026 10:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36136B0099; Tue,  9 Jun 2026 10:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4B466B009D; Tue,  9 Jun 2026 10:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1F306B0098
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:38:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72D408FE2D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:38:36 +0000 (UTC)
X-FDA: 84860630232.04.25C75A2
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 865014000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:38:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZeId1x5E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ptWu2hzkQ1kCjnXDRGNBo5UqedD/Jo7SZZDSrDj9pAA=;
	b=0Nwu9Awmsp2eXezj+C6Xw+rz9kUsS5EP35NQb5TtQ3DzySjL5wlpe119DiwBBIGQglaz2k
	NKHrecbphzNi+ksQapH+MeNkh1eFU3/OX96uXZGCw6g8VQWGoNwQbIztLhMvWzPOpwWPhf
	YA1iFZalmXy9rz1XPKumwAlZmBs0tjI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZeId1x5E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015914;
	b=im9fahtv5gUAVchOfuuXj2MAp3QkU0wNtXirfPy4QYq+VPt5ZmLQ1XaK5sc/NkscNfGLIQ
	qqHr7zsgXJfEanOyl5TD4D9lXEdE+gcFFV2SDW+lBhiQdMHjVz5MeqCeJwoXXhSCtU0bRz
	e/ejEYhAT6hnJrqW6YlgWBarrT/2ijk=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-36ba9f46338so531981a91.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 07:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781015913; x=1781620713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ptWu2hzkQ1kCjnXDRGNBo5UqedD/Jo7SZZDSrDj9pAA=;
        b=ZeId1x5EjVffWimGUF7ord4uM7T0fgDF/gBpL/HM4BRj1vmlMmdr1tE+UHIRzebZWP
         R8grR78q5FGDG7BXvsEDJi0MJMcIv/7lsO7bzjmSg/s7qdxFJeyylTWVV8DFagXcLfMF
         jF3OLZtZpjolmI50LwGrrJq5K6OknWRXbjCPAEQcPhjjH7tQ6eqKyOqH/UCSrtE54/ct
         77Z+LAmf9hyLFu9TGy7S5n0aQPE2yihjIcmJt85X9h3QuTbavgTKnVinL0/0dxkGitUv
         NT9bg+NtgQ3/8WEc3rmrgT2a6F1R/AAZMVn7NNEKeMFKjLFVDifXCaiFSsEg02HMAeOG
         rZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781015913; x=1781620713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptWu2hzkQ1kCjnXDRGNBo5UqedD/Jo7SZZDSrDj9pAA=;
        b=RrP6kUenvqdiMrOl7XuXBsQQUW6Q4n++deX8K/S+N3A5uPglcNtLHNJ4MkbZOl2GvL
         VelhEWYyfSVF5/Fc2V5bOHdiQcJNLbW239e0x+2YruEhwue1IR+gUF/0Q3SL8Gvvpu/2
         W/Hzoa+L33cmYvCcVERmghzm+VRBOgtCKYTKgP4ppQS8CS/qqyctyFuJ5hBI3ZsTtnIK
         V/0TQnZLwmgfbOoKMvJLs4VKiZcMHK1M7BESMdbvUaryEVatOVfEzMcZQIr/yJDw0dX/
         /f4l3c0EnuzpzIPWRiT0Y4KbifzNDxYDEg+ZDaEZll2W+Jxz7uOc4fAxkhC7pVqPiC74
         KxXg==
X-Forwarded-Encrypted: i=1; AFNElJ8Q8o0zYFsaZu75eR0wwjW/vSsNt7xYyd5+8vfkb18ydmbhVUowqyyODy6EHaFY70dAJAQjKzREZg==@kvack.org
X-Gm-Message-State: AOJu0YxTHb17R8GWfqV2fLODErHAgB/e8Th8Zi0lRuzdnFgrUKJBMB3p
	LM/6xJlNbDaD+1UJUT1M6q2/s+qxMaFZnfl7fcy2B2Yn7RivwbAQ9zQT
X-Gm-Gg: Acq92OG/4tX3Av/ZYlZ2k/0QCRwQMl9bjGzkrvXoNhMxE3P5SLiuIWY8/Ywhag/bkUR
	SKPq+ZEgNDQ86OevsgXWxCoXoaj+c7Gt2etu/SqSWbXtylLUFv3BuKtXBnbClg7rGEfrTMji15O
	52gctN9R9qp6LC2BL4/5HLS3bf+IbbhsKXAYALZSzOpmID8lPDiyHqJwR0Injrap+pdZL0lWmH6
	DM8QWkG+behaMfYCS7JizVsQNYRNex8T8K1LiNlTKr4D3C7EtXkVBc0I1ZA2hlgXTlslDKtslKd
	zAN7kYPQZsqoTLjhZbqDJlv5dnv2wvaXVTPOcMudNkxUUIr1NDpCGI+pRwbXRmI8DOd9SiWvS+5
	7Q2MHT7eaqsfdXkPdI39NV6gl29fFqogpPIe3hpkhjbJW2sWPZ0lVsAiIPq7nuXUI9L98EYHLOC
	lGbF6u8DpoMXKzrMYKZKFHIijxaZHwGI8yP/c2xk60RKDIC4iYnDB6XfTdPCcdGDx6zLmmzTg4z
	DXUGIPoIbaGmsK2Zm8ve6NAMdDr9j4ADU4=
X-Received: by 2002:a17:90b:4d06:b0:36b:9323:c726 with SMTP id 98e67ed59e1d1-370f0963a47mr10191618a91.4.1781015912704;
        Tue, 09 Jun 2026 07:38:32 -0700 (PDT)
Received: from o6.lan ([188.253.112.242])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df0b315esm17939677a12.26.2026.06.09.07.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 07:38:31 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v2 0/3] make persistent huge zero folio read-only
Date: Tue,  9 Jun 2026 22:37:58 +0800
Message-ID: <20260609143801.7917-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 865014000C
X-Stat-Signature: 3iqcuk3w3zeuumh4k4yw5fmgpxxbi31y
X-HE-Tag: 1781015914-618684
X-HE-Meta: U2FsdGVkX1+paI3M5bnhhyLJFir9ZFxOltvX7qEwSqPQsA7sqWxMEsRUwIBWe6ZI03bEz6nhCQr9jDFSlVCx3KgOkAkfRCw7DP7zK+LOC287VwLzh4Ile9qnPeOHEWI9YeskWHnE8Ev/GSgntXiv+SnmcuOnoZCDqZcXDJU6MdoNdcfR2rUd6L3DMEkyeZBaIDHKMlKDRYoyy+glRsdskasfYjewtoZ/jN0MfsMfyOqMaZC1U8zVfC7+trPZUu4dkqdtMyNFot9CrfuZKuoR73kjkoEAMH67qA3/3exSCqbwjZ2EGSDeAjYOXl4BaVX4my8TK06KL8WFE3uJ8YVi/RCsj1KSzlqB0KzYsVN7LBnkuZwNOjs7vjcjbhqT5vaZorQQU3PVxvTAlVuGtijAJc85qgJxbu7r3olifzm5otUziI4MyL6s4mqQK4fso1Tzmp84q7oDAYxkHvlXiuJqruQik2Cv1p5ISqeegUMlGv4kB+3kxmfx6wK75wH8zyiZn26FbAziqLm5c0guSgIW/haM5v+OYXJQKtg7pSr2E1ObPZsf8CCsPm/FrW3aAOQryN/R/WqEmZLG1Y+P2B3eqMCLyN1AnXFn9EZif6PnbzIafz0wIRa6T1dJPkRFmE1ZS90I+IN9SKbKmyBhQFMxUMNCym14gRflvWxlzNkYjCdKj9jyUEaMS56RCtEMoPkziwyF568ruJprBeYREWvWR0YS1a3B9jlKOc16UDiG9+kAKhpvNR6OsWFekRcNJXzVnyYEzkIPeTWcUKK7Bnt4njQpwNDedMrbvHOhJivHriXdHRCFgv2uSvfv/uZ+K1z4QvMm2Z8UmVOGH7cmBVX41kUPwyj7+1buvL5ZwJB4J+w8MFkUg4gV8Bw8JNcIY1pTEPoUnjlnzA4xx6SfLmG8jQ8imyQP51xTk2utkQ8F50ZuDNe2obbm9ntwzROeuIbiSiCZ/DIb25vVwLMWAxK
 R5ArINfZ
 va0Q25uxhW1IMI1p3zbZvywS2nCYWfUrmpsqCDdducWSmQi825G4YkU6Jbmepa+EdRaRfQGyV4CLQRhy0Yjg6JXmA2fA6VjQ1vv5HrI4bj0CcKFFhULGvJUvA+jC8AFJCMQnS+2dRuYNldXddfBPHAFJ2LOwJuxLaItleN7tKFAP0lXygbCYNYoptgZuY5ghrFXD4LN0phaNJbjuBrUOU85tpTghm69M4xcrwvkYIJpTJtRl4AUlSXKsSsk2XerpT4V0gUc16nUTzCeXEt4UrW1v24KDSDgM/OoTI+glIpfol6Ri5Rf9YbEdAOJvw9BIgH4TKmP0z+KxLQpw70oOPoKUs42IIfXIUdlrI8gHzLYEUAfxDmAYVlVppJ54I3ls/t33wiYrIcFv07tyVqlypYELkVbSSYMz9oLLxv61/m6CrAb5oTwjd6UIdk1HZFS4Qpwxyj0lMfMkmk4rur+UXYhWgefNOQnOM2LLKn/Z+ZeKDd2vpt8gLgHKihg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series makes the persistent huge zero folio read-only in the direct
map where the architecture can support it.

The motivation comes from Jann Horn's read-only zero page work[1] and the
follow-up discussion[2] with Yang Shi. As Jann pointed out, the kernel has
had bugs, including security bugs, where pages taken with read-only
semantics were later written to. For the huge zero folio, making the direct
map read-only turns such writes into faults instead of silently corrupting
shared zero contents.

Patch 1 adds a generic arch_make_pages_readonly() hook and uses it after
the persistent huge zero folio is allocated. Patches 2 and 3 implement the
hook for arm64 and x86.

If the hook is not implemented, or the architecture cannot safely update
the mapping, the existing writable mapping is left in place.

[1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
[2] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/

RFC v1 -> RFC v2:
- Patch #01: Drop the READONLY_HUGE_ZERO_FOLIO Kconfig option
  (per Dave, thanks!).
- Patch #01: Replace the huge-zero-folio-specific hook with a generic
  page-range hook (per David, thanks!)
- Patch #02 and #03: Update the arm64 and x86 implementations for the new
  hook.
- https://lore.kernel.org/linux-mm/20260527035607.14919-1-xueyuan.chen21@gmail.com/

Xueyuan Chen (3):
  mm/huge_memory: make persistent huge zero folio read-only
  arm64/mm: make pages read-only in the linear map
  x86/mm: make pages read-only in the direct map

 arch/arm64/mm/pageattr.c | 13 +++++++++++++
 arch/x86/mm/init.c       |  9 +++++++++
 include/linux/mm.h       |  2 ++
 mm/huge_memory.c         | 13 ++++++++++++-
 4 files changed, 36 insertions(+), 1 deletion(-)

-- 
2.47.3


