Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FA8CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A3E8E00B0; Thu, 18 Sep 2025 01:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1C68E0093; Thu, 18 Sep 2025 01:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F388E00B0; Thu, 18 Sep 2025 01:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 01BE38E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:04:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC0281A07A9
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:04:41 +0000 (UTC)
X-FDA: 83901180762.06.D4B6B3F
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id D2BEE180007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:04:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf16.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758171880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=i69tc5LqSYutpnPuXybPetu7m39RGyNdoIoy0x78ep0=;
	b=0leQAp1vbEty2NRVwVmfCfkhGq1OUWxUD5cUb2BiJkxSxlzWTiPhQIwFrJ4ktD3HCkjwmP
	Cd9Pl1WN7eKw30Gw7bCEXNzXVboTwvsUwMncSczrqTf2aj3e+MYSZlpziDMdMTV3iHiVUP
	nTI8d7bMpM+QgmJKfEk5dpAxhzP4N4k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf16.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758171880; a=rsa-sha256;
	cv=none;
	b=4ufUoGhFSLh3MxCyYTCnztCJGKLuuwUotaq3TjxyI9VYsaWKU+oWIb2qQ1TjzYsXjzVzqZ
	yj5/ibLKfYXFotxw+atMSkhznkOSuSm61/eMKmvpW+jNIxTNYj7ED8SYXQgY/ZY/C2iOqW
	68/yzyJvYxGTGLGkPP1RdviuIn+HbRM=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3ecdf2b1751so217596f8f.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:04:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758171878; x=1758776678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i69tc5LqSYutpnPuXybPetu7m39RGyNdoIoy0x78ep0=;
        b=Zx9GQscos1TDm/vivhE0aauno/8JePF9UZz3jbV8VcaTRQqCDvu93XW0W02fYb3HeW
         9JGICMz58VvdEjH6f/pQd89T3mAM0gfyGqrX1m7yv+UdGoDqZAmrbYjbzcQYJKOf6ISB
         87TcO10t07zHYlUQeEs4MMEp5KgWzgVyXlTyvf4pC3vQUHPKGf8s0bWaIhgO8FGYM4Iu
         l+0zS93CKpt8WCy0Va91ifnua32H7guQHg5365GbRBneeuKfTbb5zVrcYWHWtltqAhlp
         88r6cCmjVslFg/IE8eK7ATR3gGkMpcKDwzN+iHbWXDRQqq3QHRqzesdWi79i6Jtn6UH1
         6hqg==
X-Forwarded-Encrypted: i=1; AJvYcCV1yX8KWHxbsiR31YYyH7G5TTTvCaG+q92AngUBbnIdvfny0Ojt492JflykA8C9rqHTmwiS1ZYYmA==@kvack.org
X-Gm-Message-State: AOJu0Yz+fk0R013PBvSU+dxjli1nBlnk00jCYWSLcJqDFbyIUEdGYDwo
	pW7y+EuvwEj7X08tQ/tZbeiOtEB7AGmpti0xk2xObKA/n5YbQqDRccqQ
X-Gm-Gg: ASbGncsziZRpQMTaesNjdbgBabVt8BoeniaCkjhhUFnn/odoz4PLkm5i8a3+GzevZxR
	xfvUJfmPuMN74vq1lWG3c5H6sfV3q/wGhZCd/TZAHSnU3bGlMtkEbHA745R8Ao1WZEZoEw5cY+9
	P3yKYIqdIFI5cfQL1+2S0f/1yGYiUgJBojeCPPxC5tDrgUlG84rlhSvpbyyghElHc9axAGUJNdp
	l4xpZm6ULM1kTc5iItLd2wMfX8dgATQi90ENtOJ1ceuVb1vryQJ+kSd8y4CTP4PSVSzKPNq5QVb
	PecKl7rNN5Dp/kS4IGUBN8W5PfckNdGyQpg0r528O0Jf8jrB10N7jCTMesniKekdwWuPbCCTcZ8
	qxOi86xYZQWhTSjU/2H3JL0No000=
X-Google-Smtp-Source: AGHT+IEipy1WMSokuL4yZS5rUn1njehy5C0LCE/S735hhPYb3oucQvGSCGf8/4wxTRJ70cZWL/yrcg==
X-Received: by 2002:a5d:5f91:0:b0:3dc:1473:18bd with SMTP id ffacd0b85a97d-3ecdf9be76fmr4130913f8f.3.1758171878179;
        Wed, 17 Sep 2025 22:04:38 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407aebsm1994409f8f.14.2025.09.17.22.04.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Sep 2025 22:04:37 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	kirill@shutemov.name,
	hughd@google.com,
	mpenttil@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-new v2 0/2] mm/khugepaged: optimize collapse candidate detection
Date: Thu, 18 Sep 2025 13:04:29 +0800
Message-ID: <20250918050431.36855-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z7y1aeehb169zp1ffgmz3f4pm5mna56m
X-Rspam-User: 
X-Rspamd-Queue-Id: D2BEE180007
X-Rspamd-Server: rspam04
X-HE-Tag: 1758171879-173527
X-HE-Meta: U2FsdGVkX1+kM8UJE0fh7y6rOTNLZXxShvs4A/nUhYY/5pPGfzoug1YksqEUbDOxttYovdRtiTh2tqq7LPdmE/MblTPOWzt3dYhiDRMsBiSUwkCXBC9SPBtu51PIXS1HFP1XUeks6CkZvQnH9/xzNpDqB/My9iS23k73VIM4NZSwTrG0MlHJTOjCe1NjZICJufsee2LLInxhWswFt14ZcdgRcM/6nLL2QktKyA+TEwr7x5Y7/2V9FQk3QwPeBwPvFVsbu98BNH+trHhb6UsLpnhCd+Iu0Kg41dzAClgjqJBPiyn3T4zOFRiQ6LgJYrHQLdLj4zb3geCNwOuqudI1WGAnUeFNOfQCw5TCK6EDZ44rnalZWVUb0YBelBkmrBtkbyaTIXRrTUSju7hnqk7+QRHWaSOjDEzk3jD5KOwFEh7/otBRyEUCN1FCvdZ7o9TQVxc39TIsjSStrrh95wDhLsrKmNN67V/UnTy7T5Lt3GP0DKIvyoEqhpzhbDrbxZFT7QGS3Y3p9olfbQ5hRtNEEgg4YRJFGmxVrbtIWueQesAeitQwg67oP5dHf+uFtTt5rIRbsMheJnUmCPTIjoJnVfnAi4EdyidNShDdZn5lMdPQuEiGOvd0W2ZWp6xganvufBw89Tz+oYAzHzi9i8XxQSpzdnUC4TIXB/OJCjJaw8Jt8CcWA46iT2nHtjidLi4k60ekDouWqlCNj+M1u4c90fYwSRYa46Iay4vLtg/FAMTuJta6juWWKkm/a3mojmQaa1RgZTqSIF0KuMkZbuZSXHh53i4KmRGazp3RtlWLil/Rh3O4Tv5LypkcELNS7eSlZfa6xHjo7ruP+B99H1gvYJ4HLDvccxIxPiyZvY5ZIYqc923BVE/8W+V4r/lWNwlTbmMTlt1V+XLdQFqUBJ2btUMYgwXJlxAsNgfvV4v+FOUB8CeimwZjybvl7txRf1v9rLyAkkGAzsoCWBFG6uf
 Oi4XIbEW
 xcxWoYQTGdTTG6qsPNmrQQTUn+tWYmOx7zAtDhTu5Fbu0DAFDHoZXPIpHC74tH5bYKKw/Rx6FQ70hmdymP2DP3kI75wLkBWUU3Tyhq22FmAKHGrtfnJjYq6WT9NXhxWKJtVtjrQtm7z3DDv+jnN+T1FqjEvDXOlmPSgHMw/EJvJwhrFBjmfQUP58RLFPqXAnlXpk/QfZDczyV3w7UwPxWu3ZB9cLZqATbeiYFR7Pz8f/Ewj0gCrCpSwHiQuUdJkxbLibmAJKW538GvNgwzp8Tp+JjonT0QIGYP/0axMR1YAWlnmzb/oiAA3tA00y+EU5IFvnTja0AXyc2IS81miJC+TcURVGq4903SFX2VsEpObdt1KBw1OUrX/1qPk2PNBetgk8yUq3jem1+AfSdIAZiVk8ly7oHDXOnB4YP6UDU/HRWgytP+4auwpX4yZ+/WckJWckp1E+pZCIIP25MCJFha138gCYQrFY722vs945s/erc55YBwOHJRUfXjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series improves the THP scanner by teaching it to detect unsuitable
collapse candidates, such as guard PTEs, earlier in the scan to avoid
wasted work.

Thanks,
Lance

---
v1 -> v2:
 - #01 Dropped patch that skipped mlocked VMAs from THP collapse, per
       discussion. Thanks a lot to Hugh, Kiryl, Lorenzo, Dev and Mika!
 - #02 Pick RB from Lorenzo - thanks!
       Update the changelog (per Lorenzo)
       Pick AB from David - thanks!
 - #03 Reuse SCAN_PTE_NON_PRESENT for guard PTEs (per Lorenzo)
 - https://lore.kernel.org/linux-mm/20250914143547.27687-1-lance.yang@linux.dev

Lance Yang (2):
  mm: make is_guard_pte_marker() available for hugepage collapse
  mm/khugepaged: abort collapse scan on guard PTEs

 include/linux/swapops.h |  6 ++++++
 mm/khugepaged.c         | 10 ++++++++++
 mm/madvise.c            |  6 ------
 3 files changed, 16 insertions(+), 6 deletions(-)

-- 
2.49.0


