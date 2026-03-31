Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A55B1061B26
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EFA16B008C; Tue, 31 Mar 2026 07:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0086B0095; Tue, 31 Mar 2026 07:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDC36B0098; Tue, 31 Mar 2026 07:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 521636B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:00:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DEC57BDA58
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:39 +0000 (UTC)
X-FDA: 84606064998.12.A9822AE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2A90A4000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="dE8Vf5J/"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774954838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Wu0kJ3LjwGuLqf+bqeED2XteHKyJ+UaquG4MqK1gvVI=;
	b=JEZq9T81oTcnfU3wxBbQvcY+iBLpdOtb5/P3cgge99CzMcLsloOT5N2/iwd434P2bdDpYQ
	S4b10dgTbcmDyvp7FvCgKNkzAFOIG2ERcCuHOr1o/DmXskfUeReWcKlT8RAaHuq6J0/76i
	gppCPJIkVJ7ITOlCvRTrH0n2g9Ij3T0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774954838; a=rsa-sha256;
	cv=none;
	b=ibiMQULww6JOnTsZTqaG/u9A79gfw1G5R/1MIsfQlLHY5GrixZO4MsYh7GYMGHsMD02hPT
	5er3dN+rqEoHrR/76iBOyM7kUY64Ep1e7V6THAWFIJfhYi0/Gfz6gvrH18RgMrJBwkgyey
	shhOoo+G9+Zj1bHZjLXBWkt9csv0uR4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="dE8Vf5J/";
	spf=none (imf07.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Wu0kJ3LjwGuLqf+bqeED2XteHKyJ+UaquG4MqK1gvVI=; b=dE8Vf5J/jzGvDZXHCRJIyYEgGW
	1Voqd4jaQzligfgS1kaKrv7d9d83URMonlKf5lxuG6vpRed//ziIZBdpZ0QJo+vRee1j3vIQ6mYnn
	CVo+pFhBZCKvpB3CSN6DKR6nl/91MuAXDuNBiRZzzqpW97k6OMjNtToIKcvYbCClMsjogS/1un99O
	GSR66fXod87bQwZyYiswaT0CaxiOrqzoLj5oAUM+bjCTS/6Zdew5Py0j0AcZMmpTuAPKSzmXHKu48
	4IYT1LkquEPCH3JqaDhJTwUY+Pm/H0+rgL701tap9v9ZrwSieWj+fHU3K++imtoPSFZya/b1jFMqG
	zkALpU0g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7Wph-002Aak-18;
	Tue, 31 Mar 2026 11:00:28 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/3] mm/memory-failure: add panic option for
 unrecoverable pages
Date: Tue, 31 Mar 2026 04:00:15 -0700
Message-Id: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAECpy2kC/23NQQ6CMBCF4as0s6amnSLFrryHIaaUEcZFIS0SD
 eHuBty6fMmf762QKTFlcGKFRAtnHiM4gYWAMPjYk+QOnABUWCmDRlII98lHDrKk0pq2Nqq2AQo
 BU6IHvw/r1vx2frVPCvMO7MXAeR7T5zhb9N79cxctlbTo9QW1xSqcrx217ONpTD0027Z9AXmrX
 TW1AAAA
X-Change-ID: 20260323-ecc_panic-4e473b83087c
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=2849; i=leitao@debian.org;
 h=from:subject:message-id; bh=sn2IERkVdmqkYaK3VQGqabhZXZZLU8A7HNEDL/Sd3Yc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpy6lIbUUGVPDcpq5XdqYwDox88VVcHc8/hPMCT
 lhhFrlCetSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCacupSAAKCRA1o5Of/Hh3
 bSV7D/92nypTo8+jqtG7m8Zq75YN1MnkGK6eCTjWfzAPtO2FypfXPExbZSflS5W7RE9p3JbuU6p
 jCGyUCirvqDlYHzoXdg3nIV5znSULHPcGM+2C66SwwjazNhfg03Uu89FGYiZhQ+XC7F8tIEj4yg
 fDwxfeEdBeWD4h4AN3pi1rg5/A6Yvv77+Pzi7vBXtap/7grY+k+Cpyg7X6+JuQV9zlfhFSta1VQ
 McC2Ta6+nbQd60Q6wTkLi3FfJeFVLoFtkPhDBLHd+l8kg13KbOk3CG4RGnWzYQQH6Kf7bR2SDum
 /6i8EivzRHsDS7DiuainJVIl3ZRg8NpC5ArDH4cnFxbMe8BG/hvEpm3MRe6U+vgoetkHEMIYwHP
 H1WPJEE0Gb2p2j0D+SVa2GQ9bO7sUOj+SX+/vg46DXKsGNrMYlS+sZ4ETUe/wsHnCv9VEaS43wF
 xHVbILz3kfADN3INX0P61VFR8aLkWFOa/e0YBw4lDFK94VHrP02WZFjBOc2syt6ROiNy9s+gSvx
 Ljkq0KF2g6s3z9iO0UxmbKgXtcDKLcnaE8Ln4blXngoStSh/SwaebLK0C1IEQn0KkXjt2nDBDr6
 1N4A7OvKjo44k+2E9ObeupZ+MXjTS/tdszmvTKQG/xiYMDS6P0RXjjnZMqcTp48QBEfQUJ8Fd03
 /99mRw0zKbL0ZpA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 2A90A4000B
X-Stat-Signature: od11ec9dkuc3xqdigj13eskbhoissnoj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774954837-265473
X-HE-Meta: U2FsdGVkX19cFOVhMWqNQwF7pBH2aQW0KqFyZboTSCzrlgOL0vhjzwm8hBUSpXpzZYOWyrZOoTZtcuLef5b4ddtqzawPatlDQ7K74nUZ1HQ9matr+Y/RSFEyZfEh3m4fZJSY8m7kCL2ZRvQg7LT0goFcJx2BRasfPK+DivkAas8p1cnr92WZ9V4w3IRbl0SNEga4MPSV2tj4pkckcIdowUY5kI+Lt1i7Eiir5xBliFrAqJJJ6cr6eQ1rlgHIJPqboR3CipM8R/WIIPgK8ZHcO2y8M9cvKxh+EqM3MCierdy+WaCg33yEgVM9zZzokTv8muJvBfnPdLOcFMvFCRqUMxd9KqvvzLIoLW2Qn1EJbrZDNxh55v3WbyMeODwDVhiE/D5jW0zipi0nu6khINPHT8QOk34VFvAL/UdeXpzrRCygetWdV6RB/l3qh9s6M1MI5cdZ13zYysCbgnDzmVT5lUDLl57Ao2HMkX/s+q7NV0r2CGdIdI7Gxq1gXvf7HRizm14snRpsqJVNFzU1BlOGz7YKaNssqWV013l0aKALMzFHoRLnDSA4IRZ7iP7dp9h5DMec/HKSpYc8YGKBcUTb8SSxOhJSGvYDMk45FAUZ8cPw0Nf1vHF3AaEYnjEjUwdMG5OVrqDtNu5tgKJSVkGOS1EyRFzdNM8fJqq6YZoeiR6/W+ycv4sKuCVTzdQPpFssDjx3qb1bBYpbqbVFVLLchLGS5ulvz7NsXkh+5/ypyD6FSbNt5c55uZ+3f/9YFaZKmyhVBnIYKN1YvOOmwqubi7Ttkom5O4jl+5SHJUZoQlCWjMLyoxD+PfuWHr7I5KDdcT9JXjS7re/Zg4INFmBVRga7qqJRHv7p5msAymysW/j5Wpdb7D+MLbjPMAaNTkFN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the memory failure handler encounters an in-use kernel page that it
cannot recover (slab, page tables, kernel stacks, vmalloc, etc.), it
currently logs the error as "Ignored" and continues operation.

This leaves corrupted data accessible to the kernel, which will inevitably
cause either silent data corruption or a delayed crash when the poisoned memory
is next accessed.

This is a common problem on large fleets. We frequently observe multi-bit ECC
errors hitting kernel slab pages, where memory_failure() fails to recover them
and the system crashes later at an unrelated code path, making root cause
analysis unnecessarily difficult.

Here is one specific example from production on an arm64 server: a multi-bit
ECC error hit a dentry cache slab page, memory_failure() failed to recover it
(slab pages are not supported by the hwpoison recovery mechanism), and 67
seconds later d_lookup() accessed the poisoned cache line causing a synchronous
external abort:

    [88690.479680] [Hardware Error]: error_type: 3, multi-bit ECC
    [88690.498473] Memory failure: 0x40272d: unhandlable page.
    [88690.498619] Memory failure: 0x40272d: recovery action for
                   get hwpoison page: Ignored
    ...
    [88757.847126] Internal error: synchronous external abort:
                   0000000096000410 [#1] SMP
    [88758.061075] pc : d_lookup+0x5c/0x220

This series adds a new sysctl vm.panic_on_unrecoverable_memory_failure
(default 0) that, when enabled, panics immediately on unrecoverable
memory failures. This provides a clean crash dump at the time of the
error, which is far more useful for diagnosis than a random crash later
at an unrelated code path.

This also categorizes reserved pages as MF_MSG_KERNEL, and panics on
unknown page types (MF_MSG_UNKNOWN), so all unrecoverable failure cases
are covered.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- Panic on MF_MSG_KERNEL, MF_MSG_KERNEL_HIGH_ORDER and MF_MSG_UNKNOWN
  instead of MF_MSG_GET_HWPOISON.
- Report MF_MSG_KERNEL for reserved pages when get_hwpoison_page() fails
  instead of MF_MSG_GET_HWPOISON.
- Link to v1: https://patch.msgid.link/20260323-ecc_panic-v1-0-72a1921726c5@debian.org

---
Breno Leitao (3):
      mm/memory-failure: report MF_MSG_KERNEL for reserved pages
      mm/memory-failure: add panic_on_unrecoverable_memory_failure sysctl
      Documentation: document panic_on_unrecoverable_memory_failure sysctl

 Documentation/admin-guide/sysctl/vm.rst | 27 +++++++++++++++++++++++++++
 mm/memory-failure.c                     | 22 +++++++++++++++++++++-
 2 files changed, 48 insertions(+), 1 deletion(-)
---
base-commit: c369299895a591d96745d6492d4888259b004a9e
change-id: 20260323-ecc_panic-4e473b83087c

Best regards,
--  
Breno Leitao <leitao@debian.org>


