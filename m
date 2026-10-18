Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0BACCCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 16:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972866B0088; Sun, 18 Oct 2026 12:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922AD6B008C; Sun, 18 Oct 2026 12:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839316B0095; Sun, 18 Oct 2026 12:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63CDF6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:23:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED9121A0562
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 16:23:39 +0000 (UTC)
X-FDA: 85336267758.26.B356041
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5003140008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 16:23:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P6pSUoE0;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792340618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkvCnZp3GqJK4bIvD1zVQOPN0TOHqm9DCWSAjzxS07o=;
	b=w3+mZgKMsQFaEurFYzI+OA0OnKEGZFV8dOa3+mrGtz5du8kQJ08Xai7HyS30AnLnfRAajU
	sCVoFJwC6ar4cgEAwDHxN4SfUZ099TQExtUNVad4v5n6lQ4d4Dh7jVHitP4YreBZu65t0L
	eOSfyb3KOsWXnYrlJhFvJk7E1y/LQPY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792340618;
	b=As4vmOaW2AIYAQbLUzRpryariajySH3x33L+9ZyhHrnC+JGyDQvuij0wI9A6sWSuFApqGa
	zMsSNg6kr7HmNgSkT0Ol2pTieQZT1Myy0ZDXkhrfusHq6ED7ljonivDgxOn+eqELNDFHl8
	tobTx2ZFEzgSxc9vC3HeIorfupZkVNc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P6pSUoE0;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 318DC4095D;
	Sun, 18 Oct 2026 16:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40A31F000C4;
	Sun, 18 Oct 2026 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792340617;
	bh=PkvCnZp3GqJK4bIvD1zVQOPN0TOHqm9DCWSAjzxS07o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6pSUoE0uF9R61EmmdJ/FHRrRUP+N3n8/JOStw3k3xMxktDAZ9yjDt6raMWvnFs5r
	 uTBxSI4ODXNjzZWV+iMaAY5Eo8+aNEsYoWI9w4fR2/Mx742HJQvD88czJXIG0UJtsh
	 E4N8qevijiTh2YnwIrS1lvZ8QSi6b+vRnZ4QDROCVGvM61VF+F9VPLf/CzITV4Tf71
	 YMYMWbfXe7eYuGr/tZ7sJJHWKWr4My4sbUy0KPpN89fyQTXNuaOfwYCjuEsQtHIqYm
	 vvEI3gAzUDGrzJ1FDtwWyABA2tdZQz2OtJZcNmI8+E8YWx3n9joQ4Y206uVsHG1INU
	 Ifk14sum/ay8g==
From: SJ Park <sj@kernel.org>
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/damon/sysfs.py: stop obsolete_target shells hanging the test
Date: Sun, 18 Oct 2026 09:23:29 -0700
Message-ID: <20261018162330.107844-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018020415.35567-1-jaeyeon.lee.dev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5003140008
X-Rspamd-Server: rspam08
X-Stat-Signature: iiogeuums35oir745hkz4o15w54u4wuo
X-HE-Tag: 1792340618-648652
X-HE-Meta: U2FsdGVkX1/t0s9euuuo+E9HnNDRqE30WT/aeZjrc6Mpq5lRwNMfhA+H4Wn8i2VKjiAknpyTnggGPHpBffwK1u9NSsAYgXUtB8bRQWWbe0t8dHrv4XLMCPsDtIxNat9MOzV1bSVNQoFv17qcEY0SYLorph2r3rukKc/hEt0vb0fANX7bb/WD0lIv4yqHfYwrKrJcer8LT9CCd8ZyiTiERSGGn8eIWCS9inSZ03lfD6hiBkwedeuhshZf4l54NY5GHUUthFUs4wTBi4buA+45TVdt7kGXTxWo+YwB03EHvBQWNifXqTQE+KH6HWThGhspLi6CuBF72oz8adN0ZrfUURQ08m99vkx/BBHieAjZtM9Vot4jfvuUqWkNEAvMsGqtkzYcMtR6l10jNyUXHg3VgHYLn7D6QMqmkSCs4ZBroe+Gx+uU079KgdZLxgRrxo1waIe1qnBtE/8hmIfGmfIRfewGV1awT8Vk0rOl7FDv048sPFhGa5I5OtMZ7pCeGsO0/jveCvnvFmONoSWaRdeXF8K2xJjq2R36A+BofDtMYitJObD5vPraugbics9tEOACjxKElX7PN6VkxzI+0AtG1XCo45bb/lD1AifmjXYS/+TUkZhclwgyREofEmGksHjpdl5du/e5b8xAN5BmEEMiErJB0bp48gSYptbaagEOugaEy8G1+XK46xsPguWNCZJ1R5XkDLCQpLKBWQatfK3nIjk6qS6SWhNDwZ/k9Ttbe1y4HAgdsFNFhgnpv84vD7HP8OKy8JPaGaMav7kZOszjtlDLkGxcikvw1uokz4ak7DB2vgnqTS1PlojMnQs4ZgLKLRaeigUofylqPCJDilBx6w5kV/+hfyB8IxFa1pzlZk678tTUp4Khhwa1d97/KeD0GyVarAyYQW+osk4hW6a+aXEpIRtMmD2b0l4pilKhj6QPsZWCtIjm4J6rYFHkCYmSXyNXMsSLwvifyZmdTP/
 o+HLuZbc
 3O9GBT7OLXxNGIZZqHnNPGdlvGtXRQ8FZriQWeoAoVGYYMxJy8PzjZd2Mlk9wYiK5qzinzkfQbFHQF0E8RANG1pb2Skn78Mc4iWoSXn1Jh9ehIDRyypYE1pUX32/mTRTZaO1OZ0gHLuZd3NLjb99hCCgmsJaobO0a2rz2+fQSnm7clz9pwiRfPGcT9doc7XzsY5ekiOoNSPULtaKHdJhNGSKFAclM/VAkaT1zzcQseX3ozQaS+DbMGA702FRz3QNWTUP9lMPd+ghB0RpQgXCcfHDIyxZoswSlwMWlQNGoT5rKSV7QUFfJFkgiO++hRxupnxZMaNaJ0n5IdUtZdmzYIpjB2Y9cQVLTsYbF+jMTVLs0AkmdEVVpK9dDAEXJzvq5avwoGiU5Sd0pxPgU0faEIcQ8Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 18 Oct 2026 04:04:15 +0200 Jaeyeon Lee <jaeyeon.lee.dev@gmail.com> wrote:

> The obsolete_target test spawns three 'sh' processes as monitoring
> targets.  The processes inherit stdin from the test.  When the test is
> run via 'make run_tests' from an interactive terminal, the kselftest
> runner executes it under 'timeout', which puts it in a background
> process group.  The 'sh' processes then try to read the terminal, so
> the kernel sends SIGTTIN to the whole process group.  This stops the
> 'sh' processes, and also the child the test has just forked to spawn
> the next 'sh', before it can run 'sh'.  The test then waits on that
> child forever, until the kselftest runner kills it after 45 seconds.
> The test passes when run directly.
> 
> Fix this by passing stdin=subprocess.PIPE when spawning the processes.
> The processes then read from a pipe that never receives input, so they
> stay alive and idle as the test expects.

Thank you for finding and fixing the bug!

> 
> Assisted-by: LLM
> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree.  We are now quite close to next
merge window.  It may better to focus on making mm.git more stabilized and
therefore ready for the next merge window, rather than adding more changes that
are not really urgent.  I understand this series is not really urgent.  Hence,
Andrew might not add this patch until next -rc1 release.  In the case, I will
request adding this to mm.git after next -rc1 release.  So, no action from your
side is needed for now.  Let me know if you think this is really  urgent.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

