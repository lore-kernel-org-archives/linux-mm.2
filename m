Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DE3CA1013
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 07:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3CC98E0006; Sun,  7 Sep 2025 03:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7068E0001; Sun,  7 Sep 2025 03:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5348E0006; Sun,  7 Sep 2025 03:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C51F08E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 03:00:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 330A513BAD3
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:32 +0000 (UTC)
X-FDA: 83861555904.25.5FB6970
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 788064000A
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tPP7q2TC;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757228430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FyIIqegIx0wfHeURsTvCMPzANphZ+sLHWvGCD0oe4C4=;
	b=u7xzTRzQ/5UNPMQWFPf7iQHGdFBniNS6pxFQGhXjbdqev6+5qsGHi+uKXwktNjJutxHdrf
	Sj6FacJYpHMiyhbDeA83pn+CXuYoV1Sk7pgJzb2u9qKzgBHLAWPHVO1xYyPmJ0R3rMyrPt
	tuXBqdsKa5hU2mxuVvH8wPIuzB1Ge+w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tPP7q2TC;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757228430; a=rsa-sha256;
	cv=none;
	b=LQZBDcxz6SM4mFlgjzScqd5iv/7X92XTJbL7hzcY9qB+ky0QjQkATCGucReYtmg9O9IKoA
	h2c+KPwgLX4vCwJIMhX9HQ6V/mRR1jyPRaJAZ5uGUv4gOvI/vgxWAdXcpxPuXB2BUczNdX
	M1mhuLVz4wh3mSW48nVdibcGeXSFpUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31499419A3;
	Sun,  7 Sep 2025 07:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D33C4CEF0;
	Sun,  7 Sep 2025 07:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757228429;
	bh=lAKGsfnUG4rgDzqjzr2gwTb62JFdmQhbLIaqo8Ydwj8=;
	h=From:To:Cc:Subject:Date:From;
	b=tPP7q2TCiDeELr22eaA6eXoox6CcsBeYkx8QFMoB8UJ4AuPgNYvFWeuwsX8wJICmg
	 oWCGrjEjZjRjKZuK3FGmP/Jj1OrKgOtT3MJqJAlsKvBueRq4eJQ/rkaKQpy4kiE6Uw
	 TigcrvW8Ug8aFmYqWqMByd+PgVWpaH7UrsycyExB08ZpgOR0JMbHTAk58cMLpUZ3mQ
	 hdeMqT3veVF2EsYhb0sCcsBQXUrGD4NT1CqrqETcMtC3twDaXCL0lJWERop0i+3eLf
	 yH8jqwy27Lgok9hho+nTIQjPMH8YaI+tfGEyEyVVj8vcosp2vopYSg0O2v7RZqpz5z
	 YFi7pcicFIokg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] kho: add support for preserving vmalloc allocations
Date: Sun,  7 Sep 2025 10:00:17 +0300
Message-ID: <20250907070022.2177974-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 788064000A
X-Stat-Signature: j7z1yaw9zq9gc9tjezgsiccpk1rbr9xe
X-Rspam-User: 
X-HE-Tag: 1757228430-930404
X-HE-Meta: U2FsdGVkX1/l/q5UGbTHKUj36Pv9CnPhDzYIBR/JhjgYN4nUNbU6pqLp670WpF6dDusjw2eqF2Bm6J0KsP+vj4M7/17GfNZd5FWNiuhK9QBBfyMrhb9XdXh6QBAZRfuV7tCciKLkzw6sM/g+R3Pu51c5kTbVmFAirEmh96XxWw7PfQvroMrHXa074jAAaHf2OEq8+RUcaRD94XlCsw8zCcIY08mmzZwYJuQ1SxwxIABMhJOMa7S4RSQ1iFNpN0vl3EgLGU8EsTIC6J+ayAUY+X5n31nsATmc2WiHjuY1Z4UCRUeg8thAB/lMACRQMXSl8BDu10aF/iumsmLsMbcCqJLkGOLhrryTzxzTm9hM5oaCX2PdSuxE+obivQSDQ/E96h9di0XOfnVnnT+fCuHyMB04dCecV0fF8P76wiyRWItCP0oZ03xmMh2jKCgWa0KwiqQxdEr8RyTz2ukG6xrzIkq6hRCKGhj8I6iEf1+VH1g6Lk09cWqE/awmKLhqGeBlxtYUazHEjXB6Za9mH4i1qHoMuMKE6r1Ur4aMm+hJ9QadMcxFx/CXGxq8Upfl+gJOoHIUlct8I+iltuARj1pd/ZiHYkkIoTRBMgpCDqW9orrJpiLBJROjMAEuoyfr4Yj9R5OMI4kpw3zYT4M/BqhHBioSFzplazI9L51EnfRMHNTpoUSKsPGIRqXQQPCGuPqMFJHBdRGvIUX1i9f7I1WLxCA6X4bWHYVsNLh28djd5oJYu45wf+MB3tkyx3r7xzlr+R7X6LwiroF0a0JhULUBzKA2tgV6nqkrl2sJKv0og+5P0THEnL4ayx2E+BTUJzuap3vAXWN8yl70D0nb03D+4e2fE3wZBlic4wOE3idZ8l9MotAaK96qr33R+prae+pS5fZ3t73fErmok/lSdyv/ei2V+JM9uYn0s/YfKaLLwpMVQ0dg/SFItCD65fwgzDsYIDBQMteZ1waUFpkPBw/
 CQPQ2sQi
 Rz6l+gYUNxXzqfDtuT2uFxkOvIDaflQUpUxks+F2wj5bJqL7lk2Xjmw7IP3flRNwNlijYMl4qvAsJuKRlypc4hfWdDEMFIi1DsckzPwi/Wkye27q5oS2a1B48zYd8rCm7ghO9JcLuCWj8IGPgO6Nz0J1cPnC1g5osWQdrqQ65ITydDXLF60jZnUSvE0740lCgsIEu81ny9pExZxC2UN5FpSzJL/S2Bk/DPI41809YpOjm8+lD0D7ilwJolZ6IGlqiSKrXSsHFjkHD5I8w9She3yiTeAfaHpikW9XN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Following the discussion about preservation of memfd with LUO [1] these
patches add support for preserving vmalloc allocations.

Any KHO uses case presumes that there's a data structure that lists
physical addresses of preserved folios (and potentially some additional
metadata). Allowing vmalloc preservations with KHO allows scalable
preservation of such data structures.

For instance, instead of allocating array describing preserved folios in
the fdt, memfd preservation can use vmalloc:

        preserved_folios = vmalloc_array(nr_folios, sizeof(*preserved_folios));
        memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
        kho_preserve_vmalloc(preserved_folios, &folios_info);

[1] https://lore.kernel.org/all/20250807014442.3829950-30-pasha.tatashin@soleen.com

v2 changes:
* support preservation of vmalloc backed by large pages
* add check for supported vmalloc flags and preserve the flags to be
  able to identify incompatible preservations
* don't use kho_preserve_phys()
* add kernel-doc

v1: https://lore.kernel.org/all/20250903063018.3346652-1-rppt@kernel.org

Mike Rapoport (Microsoft) (2):
  kho: add support for preserving vmalloc allocations
  lib/test_kho: use kho_preserve_vmalloc instead of storing addresses in fdt

 include/linux/kexec_handover.h |  12 ++
 kernel/kexec_handover.c        | 200 +++++++++++++++++++++++++++++++++
 lib/test_kho.c                 |  30 +++--
 3 files changed, 235 insertions(+), 7 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.50.1


