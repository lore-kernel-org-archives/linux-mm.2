Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E0ACA5FEF
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 16:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78D196B008A; Sun,  4 Oct 2026 12:30:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E166B008C; Sun,  4 Oct 2026 12:30:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653DB6B0092; Sun,  4 Oct 2026 12:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45E786B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 12:30:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3CADE1A0B84
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 16:30:04 +0000 (UTC)
X-FDA: 85285480728.10.D14C8AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A85B2160009
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 16:30:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dH7NmgBy;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791131402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97WWKyNUowiVmaJRkjk0Al/JXN2jGgBELzTH1zbyjYQ=;
	b=68m8fJEABGxaaej3L45ifXOQTGcDzuABBeyw3ZscILiJS9x1u+P1P2zhi+DSH4RwtqfPwN
	OGeCXX6gv3gjq1YxscRfJ1JxbgtULT5r7ULxQW8bejkXvgkeaj6viPT74oB6c0YD5AeGMg
	aFjcYWP784eGWr6vilXJE4DigBLxD8c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dH7NmgBy;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791131402;
	b=Ty0mUGkPHUHP1qL7rMBFXC9TME6XyrXR9C/w8xYxiKipqAZE+aHokETdMTTU3wOxuCEWIw
	rN4SqJpcpEFcm8qCkBHTvON2YWqV2u5VpeclJ5FvfGsVKQ+quruRYCjjxGQTxTxPU26sDU
	D0pu5lIl6UFI4lt/igUd/OXRyuVBO3w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C53DD60120;
	Sun,  4 Oct 2026 16:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6B81F000FF;
	Sun,  4 Oct 2026 16:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791131401;
	bh=97WWKyNUowiVmaJRkjk0Al/JXN2jGgBELzTH1zbyjYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dH7NmgBycpzyrZSdve1C8Fk8TXpjSh7JeCqZ+8ihWJ/HuR3oxJqwF9Oq1hdERXVWE
	 vyCYzU1ATQKgtRC+7Mmx+PDQ7iclPH8vYwLkg+5EBtCYqof275CGpRJBFmLmFz5IGJ
	 a//2TC6E5ElJ0act+1CRfkrUcatD0l/qcrIRN0KVZOLAFCQy6lYZ6Sl6jyVcpN06G1
	 Brj3skB1mAqRz7rypA/HIhAdN942xNbqDo6GN5ZrOcGpKshYNBUvWhoRA+L4TYOYLo
	 Jz3Be2L/wOr5lJeVqc3yDyFtzgeDrRndW1x64TQJJNDhXKvDkYFn8TQtdsDQnLaSmw
	 ZU9rGYoJAp7hg==
From: Sasha Levin <sashal@kernel.org>
To: ljs@kernel.org,
	rppt@kernel.org,
	peterz@infradead.org
Cc: Sasha Levin <sashal@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	stable@vger.kernel.org,
	4ncienth@gmail.com,
	alexander.motin@truenas.com,
	caleb.stjohn@truenas.com,
	ameer.hamza@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while perf record runs
Date: Sun,  4 Oct 2026 12:29:39 -0400
Message-ID: <2026-10-04-1-daily-reply-0001-secretmem-requeue@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002175651.811343-1-ameer.hamza@truenas.com>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A85B2160009
X-Stat-Signature: 8zexdiwpkbdgu8kbbs1goz8h3bnm19b9
X-HE-Tag: 1791131402-240752
X-HE-Meta: U2FsdGVkX1+mliHQx9fDPBdpNhRC7Qy5t/2nTGvCA/qLIeBmkYbRRGx3AZzeEKzI4bnneFA8OtlOv7wMDFdW3DTNdjysxicX+0uzLbvj14DSN/WrPOh7nY1bij2bxjzenwXSEQFFtKfhVhg80VKLIt3jmodnopB+7TozSzLIUIvHE5cBfO6NZKF7p4UW3sCkpD99s87z1MyJt3vQc3/ds3oiBEHAhkK51tS6fkncJmr5UfSWyI1Qv3PMiUfRE1Mpj/zm01DYuGU1J8Ntn8OTtKtXG7qgPwZ70Z0YOoRGUyiWtcJ482E3xdtK4REN1EZNfTSveUjg1GZyI2DvB8SuRDu9HICmBe+HFMwLr9m/aRxkAnltn/hRIGifezOugsDmgPnImBxDGlgdUsLA3PK3V6iwbmxeaHvefcV+faV3IhVTaVV0/NtHRWnZBJ4E4Hbv0migUZIUbxV9LClKNbz5R4h0694Nat5ANH3JqZZb1uMIy0yP3TLuadoZm6xOCwNmZAXZ+sE9n+5i+utaRLgG6hk2DAvR5CNaIvPcd7+Znp2x272ODfyMfH9tKvcOVKJcpk5zSLm8l4oUqTuP736oWSR793q3gel6FO+CGqeq6Hre45H0Hk6cY+dCvEbNALokFF1xJBnC8fnKbkaVU63qDI0aZRgfqZKHgMZ8UP1o5KON8jis7O8+ZTN6g7zRW5a7z5pPV0FXlLrR1bLOc+bmPt/RI9FJbnWCCIgZmSFO0G8oU5wLFAHSP6vtY9L2ojJV36Aj11iNVEIKpGCz/TmU+JiexJtp1bdjEOBNWEQZEdKm16iCQll4WuxaZvUIwkxLlWoC3SoiMoaUfJWzeaGCkybVbXbi8a3Pf+w22r7mT7sb4rYJdlztFsrOxRFI2Q/o+SQUoWw9wjmOiC3w+az1aQJSqe99537sVIk0K7NymgpgXYtA0eSC8UCN1bca+7mcHlyYr1sKgQZwrXcOX11
 WHR0q0wE
 3I6Hhh5LBNx6dWF1gFvfhtaQVl8xhSzWQlLdE3Iac4kVssqyHNtkPEMTsGH5rmhhhXRw9RvZ/KFQK0iynXhaW4dGLssDap3rs1YCpcoXyJBPDKGjIQmka9FJ3NFAGt3pvQeiWwxDtCVo5qNTb/1sDTpCINmGsHSvT1XE06nWSnZhr/IbF8eaiA2sioN1J9G5WZzVIJP91pA1a55NUubA7U/+VuSmAxVTvRPHXkmnI9niRdzVnvUCWzKAP5nBbnEu5TPww58hsKHhQjKHBge4ZVkaPmKWlPmU+wJVbG5pwWl9J2SoZYOu5rsToUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Since commit 97d34aa65c29 ("mm/secretmem: properly account locked
> pages"), in v7.3-rc2 and the 6.18.52 and 7.2.5 backports, touching a
> memfd_secret() page for the first time fails with SIGBUS while the
> same user is running perf record, and read() into such a page fails
> with EFAULT.

Re-queued the secretmem accounting fix for 6.12, 6.6 and 6.1, per Lorenzo.
The perf fix will be needed on these trees once it lands.

-- 
Thanks,
Sasha

