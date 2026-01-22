Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F32D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE1D6B02F1; Thu, 22 Jan 2026 13:25:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9AA6B02F4; Thu, 22 Jan 2026 13:25:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B646B02F5; Thu, 22 Jan 2026 13:25:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49A7A6B02F1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:25:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1ABD8B99BF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:25:37 +0000 (UTC)
X-FDA: 84360427914.17.12F4F52
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5A379180002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:25:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=ooW1EZck;
	spf=pass (imf16.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZETjoYZbv6JfxnRbJWK8oZQNrR2Aq71AMGCJB3jsHA=;
	b=YjKIwOPN/xc0+Z4DmdXdx74rTzwj2VUWliDNPRrgHeps8qKWhwg4edqnz7fLLxKfygUtB9
	DIM2Hs/GLmiMp4oEi7dIqBIQlS3/8m5vRhuX1nSe8AGd56LL6V/nLlqgaUbRYBFO1CxqWA
	vN3RWa4AK4Gu641wGoGSFDwjaxQ6QJc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=ooW1EZck;
	spf=pass (imf16.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769106335; a=rsa-sha256;
	cv=none;
	b=sDMffhOMXKox0HWf4a6rOIJ9Sfzk3qUNDtOQ8LA23AjXoa2R4MGHIK7KRZGl04C+3UcvQ0
	gKLHL90FGM3P5nYOe+HPZlonK53kHNqC+iW7A2TuRZTiaDzoqcWet4+4/S0iH1rK7tWR7U
	tUZrsRNH4tsk23FZjhv0y6R5nRpYUTQ=
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [4.255.188.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2EA1620B7167;
	Thu, 22 Jan 2026 10:25:33 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2EA1620B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769106333;
	bh=jZETjoYZbv6JfxnRbJWK8oZQNrR2Aq71AMGCJB3jsHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooW1EZckW1rmHEyEmWmj+I5OXtJOTq7SP3vw5gZ9tKf1qeBy3T7a17mvPkT/kq4WS
	 nWhWHhcZeBBZxmNat4c75ZBC3ocwdxZx26hkYfofLccdXnJITbV+TMmC4ZzlWltGiI
	 ysp6/QTq3Xt/0p+L4oqnbTiU843AUsrVMGhbZGjA=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	rostedt@goodmis.org
Subject: [PATCH v5 0/3] mm: vmscan: add PID and cgroup ID to vmscan tracepoints
Date: Thu, 22 Jan 2026 10:25:07 -0800
Message-Id: <20260122182510.2126-1-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260115123809.2257-1-tballasi@linux.microsoft.com>
References: <20260115123809.2257-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 3dw3jtib4jsyazc9g9oaj8a47bdasz51
X-Rspamd-Queue-Id: 5A379180002
X-Rspam-User: 
X-HE-Tag: 1769106335-101440
X-HE-Meta: U2FsdGVkX19VjgkxDzkVhCyymzrb5uX0Wy4A2/eJq4/juLVl5nlmlEFujaYcY0U+4Ms2dXZUXzSxio0j/jFd9qAjYc//W/l8q4wrtz4X8M5cYvuSwb8Say4/pL0Lp2i/VT86lWOiaJxBGfnR9jzGQR6AI1QIvVTFMT/FfWEE5AfVpfhUPITabIylzHlB81w3ct36QdI2gEjsqQeHkvJMDAJrUZzrE/yvn0oX/EqNlu7z893208A+mFhPsF95pRQe+mpDWUKNZ65R/8FC+Pa+dHDY5nQerI+88YlXHaRodZmNNdlknGyNvt1HtfFdYD5hZcO+DSLT4nD0LiMXY4GtgVzSAKYaqR/OoJLk9kAyhDqG7poHsFmIn2bRF3rD6QfImYYfCrLnC4F+uANbjBH4EWt7vK9bDnG65wJqjmt/a0ir0ccW6gMlKVsaZ8DOM3tYwmHSP5hF0S4Vyj5j1JnItLXffRE98CqNmoAWUdjtqSlqAAHkUcOHgT46sW+7ggzi8oGgcKD/f5zp5VKSt1GjwKkWnOsgfn4cWRcAG7FP0vGDBR1uzWQxtlDLxfgcC0rC2RQca7ZVLvQQnwlenHCMkgHxT4jxlvl4tEG+vt44MeMYMJFMUw9YEYyWc4lt6a3VJGJtCK2iJjLtH1swVNCIQt9YSpBS67nE7R2iuozzZA2aDTwOeQTrZFA4/hfKvuHx/7LofWeJpKqRljphtuH4+lE3AjOkjTsPwVt/IA36sje+EfK6tQDK9R5FcUMKdkO54O2JnDn65ynLKY/4N5i/fGS4ADS9q85c50QDD9nRDPps1fNCoJo9k//XhTeXgm505W/5BKJJkkmj7OCsgZD/LBih3D0Z+cPIpdGUQ5ifVemJ8ym3J9EHiuaqgFqQBEt5/RuV1zIp84j0RmPyCoAoSa92NIWjZ0BrJPdIElGzy0DaYUi432Z2pl9TVJqy1TrQ6+ZyWl6wH9QXeo8VJvT
 QXR+HQnz
 JcGIc8ilDIxRUuA9lWLgNkLIHO+4Qo+5ETFryLl8tF71bTzRrXF5EDL97MH5UJNrrH31EzImCHf1T2FKtxb3gOTHPKAZqLSwkylFN3n2Rs+uyoWt42H3q29wS9j7C7QW2Bz88je/1zTdYO17uHmltXrtxBum5qkRlmgABDQo4R/xnbdOL2/BHwHkOvH0uMUqd4KZBMZ85NYBAeH995Kk1v56DJ66jxKUe7EOIDsnFJhA0kD0dOnfv6awl9Wce0LYXSC4vjueyqsXEv8UGq4aIY139RdgYOYFLdIwNi3ZaPqoEYvoXmS7KZW9Z3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v5:
- Fixed a small quirk that added extra +'s at (in-irq) warnings

Link to v4:
https://lore.kernel.org/linux-trace-kernel/20260115123809.2257-1-tballasi@linux.microsoft.com/

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Steven Rostedt (1):
  tracing: Add __event_in_*irq() helpers

Thomas Ballasi (2):
  mm: vmscan: add cgroup IDs to vmscan tracepoints
  mm: vmscan: add PIDs to vmscan tracepoints

 include/trace/events/vmscan.h              | 104 +++++++++++++--------
 include/trace/stages/stage3_trace_output.h |   8 ++
 include/trace/stages/stage7_class_define.h |  19 ++++
 mm/shrinker.c                              |   6 +-
 mm/vmscan.c                                |  17 ++--
 5 files changed, 106 insertions(+), 48 deletions(-)

-- 
2.33.8


