Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF76C9830A
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 22:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB9D6B0005; Fri, 16 Jan 2026 17:48:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369306B0088; Fri, 16 Jan 2026 17:48:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275286B0089; Fri, 16 Jan 2026 17:48:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14E026B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:48:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 238881AE40A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:48:03 +0000 (UTC)
X-FDA: 84339316446.13.B8E7AD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A6BAC4000B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:48:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fpii7T5h;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768603681; a=rsa-sha256;
	cv=none;
	b=hVd7c+mx8C99SaTahMA+xv1lrel+V0xUCmQ6u45vd1dVsvFeMd6KUymmQcyxeHr5N95p9j
	biK2nhjXnGbGGpXxgczDcUZKU4yfvK9xlMnIOH2MfWkmDvylOfp17zSpurDQrVEyO6lsxg
	tmqN7lR3G/9ZK/zNos3QbkKTjgUwJhM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fpii7T5h;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768603681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TXtSuX1K/hji55HYyn3PAD/hgRjTQhAkbVhjGLnKzNk=;
	b=Y6BakB0QC6M6BaB5jyJwRzomUJujCdowAb6ILOgUhXvqTNQp+9jR6iBeXEq604aLaQMNtc
	lFMK185H9ZlTh86hPZ12UL/DFKSyp0O12bzTUvCldPMv55wVpV1k9X+O42lq/OOg5KtJUh
	vJNk1UCguyylHrai1f1Bg78tn77r7Vw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1094E60160
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBEDC116C6;
	Fri, 16 Jan 2026 22:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768603680;
	bh=Y1fgslvUFGv7FFMMxCuMeKzRLD1x+G0p7+kfTN3IfXM=;
	h=From:To:Cc:Subject:Date:From;
	b=fpii7T5hayCWs0pysxiBoH/iS//50XKk8pkwZJCe8ne1rJaRGKqDmnGFwq7QLEwDf
	 bddwlakbSJUPQK5sXmD970nQLqrMwGuwRE4KkvwTjep2AjQQ3QgDTiufVk76Kq9G3n
	 C/qAYglLGofQUBChwX+exBOe92JHFV1MbVr9KzTB3NkWQIjj+mg8k9JLrv5v8W8KU+
	 dQIIHB5ci5RzVBX5dlAgCZo1GzmBspVOURgenyygeKmWcCBOZ1ROtutxQLytVYhFS4
	 SuMxJ6nwQ0YxU2rSo7GBlu3hdnCLlBMIOItn0TRIx2sNx4YSpq+1nkCln6lTkS9CEL
	 tNI8FvKST4G3Q==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-01-19
Date: Fri, 16 Jan 2026 14:47:58 -0800
Message-ID: <20260116224759.40500-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A6BAC4000B
X-Stat-Signature: 4jjikk4dqowww8kyqszyhs7xm1cckfrd
X-Rspam-User: 
X-HE-Tag: 1768603681-968441
X-HE-Meta: U2FsdGVkX19oeFWZS5jDqeEJsAAqlg/atdpCwP/vZY61FieJUBHHD7w5qH1Ij1aagH8jZGPJTuTWm+15cNykjofIHQ43RV1IIW4DWo/CPgmKjqoLVDcw8+S7mz5IaGycrvLsoVowQKix+12LwvtsgUJ/2z0QVfM/+bE8h6jzJ3uKpCiyDpMqycBO9I55848flBmV7+g9FU4+5U1ya/vqVM7eKBWL2rW8CmNlNUksusSX5GChMbT4SP4Ns5joyX/SmYxwkZtrmhj6gV7a+vAyBbyMypwQqPxgRBHrBzq+43UkMJahacs9e0Py8+zT5CMEo+OFFPxZ6mhENW9KvTN3eYn2exawuJ45+dlZ36iBJodhor8ndUMYhOAcjgshRtM1V3b2D1elnDmGK9QEVCxP7XYAkfEhfsC8Xo8rCHaDm+HD6jhICg4s32X83vZiAzoSHcE3A3PcXPP11yeId36Nh9E358wRCjBsmh825Z9mXMxHNoPs8CsIfHF9NVPMFnPmSzwoa1HZ+66EGcBYqXPUUoP3kxAlIwmZWIAoAE/c/zq+HDRwkJAQLB8SZoH9ywBqyYDpgR+vIbVfr9a3tSyBTNrP5IGuvWRav4N3kvCrvy1ukjpO6mVQe4KtjPXeBzbefshybKILg97A69Jjg6dRBfsj938fdqGiyE+ddpSf91sE9yY/oIEPk75UI/5FoAnas/yEMk5lfC0+KAOF9WUaic1ACBiuC1kTg6cEBRPR86zy4CFz4v7tBeWTTpf4f9D5QD0Y1oV9h13OirrdVqKUN4g2DaBoVLMRkXRdHFIVCj1kLTnlipJ1sjCUfZssqv6pdC8lrfuihmzd89HC4K1SkSqtg5c6KRumO32UK2JdnE/dBzvlr1+IxrBwgt1HtHtm/p1eVlVfLz/sem31vcu8Sir13sfsyRNEkcRFCxr8QyfrmOz35tYuy0SfibPpngfyDVLO1fy2hfsX4K0JkwT
 XNP256Es
 1u3FZR+Vn3ku6s4lH9jmqg5sSDV/5v02hP08QRp5+M5SNxE+xI06zqhZZZI6JLSfJJv6U8uIOB5XYZ7Wg86JjdN4G38WlO9rR/KJ3NrNAEfkQLtacJgvXwYfG34wXOFfP6oyUUPx4Rvq+RbNoOiGEULWwfaJT9by2DlAIEggVRrqJVc6igGS47fN/l+PXItolCcft3QJs6B690yQMLgsMrqAvcxYSrizkBEWojTCySe+GqA/rj2gPjIIRv9R7m/RCtY0iRwhUUYGRMb9KAxpOA4Kg48GIlfVeIFn9gpyAEPJIO/J69aqk1FgW8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-01-19.

As usual, we have two time slots for meetings in the week.  The one for
wednesday is already reserved.

Next time slots including six virtual-only ones are as below.

2026-01-19 (Mon) 18:00 PT (not yet reserved)
2026-01-21 (Wed) 09:30 PT (reserved)
2026-02-02 (Mon) 18:00 PT (not yet reserved)
2026-02-04 (Wed) 09:30 PT (not yet reserved)
2026-02-16 (Mon) 18:00 PT (not yet reserved)
2026-02-18 (Wed) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t

You can also get the past and upcoming schedules via
https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing


Thanks,
SJ

