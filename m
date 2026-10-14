Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D6CCC6B2C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6ACA6B008A; Wed, 14 Oct 2026 16:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41F86B0096; Wed, 14 Oct 2026 16:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D575A6B0098; Wed, 14 Oct 2026 16:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8EB86B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:01:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56AC91C4138
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:01:43 +0000 (UTC)
X-FDA: 85322302086.26.137C933
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C7C4C40018
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:01:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6Jp0P7d;
	spf=pass (imf17.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792008101;
	b=OJbBA0LaSwJZvJPPaUP9dG4YXz+V/m84Kpr+8ZLbENVEJ6VM4gcgWX6aKAQtqq/pNTMT9s
	2XqBhjCDk+ujEhkvgEX12T2Cfl2+rtVwhu2ULs4grUfTNwn1cIYAxiGUZXBt3JAAfB7Wr/
	BpolvsecxSPSwZSQNOesPcHfroDV72A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6Jp0P7d;
	spf=pass (imf17.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792008101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xHHlyopUsx2ZZ5zS+a/fPHKhEpl8rzj7bO+W831Cj4Q=;
	b=QEk68uF3NFMn0HfCWfv2AUN18PNbJR+G22Zr8RYN8t7J3QvUc/6SJA905cZOf+JtGh7dLn
	GRdV8U+Es7L+D+smJ6OB183kAUwR3XH8IaKN51nQOyH4CsDF+yp2tRM6QJOMnAPy62oqaj
	T3nshOMf4qBTDTWJdk9BudmOiSFwl1w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47EEF6053E;
	Wed, 14 Oct 2026 20:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121031F000C5;
	Wed, 14 Oct 2026 20:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792008100;
	bh=xHHlyopUsx2ZZ5zS+a/fPHKhEpl8rzj7bO+W831Cj4Q=;
	h=From:To:Cc:Subject:Date;
	b=U6Jp0P7d+s7j0AypUUuvlsfW0sMaKORWDVNoSjJ1XW7R9swBT1Qo7EiTxk1hLy1bs
	 6A+Z3ulqP4xfnimkMeUS7qONXBiJ7SV9IhLX4bWazcOj9qiQHIPO29OZJqW3oB5PlN
	 aQvZJnK95lRXj4OnB2iwcmgTWvo+WDOjBzwtJOFIwksacTpUprbFKCwP85IR9bcsUl
	 mne+MiLo/pVWbjYEjTbhZ57a61bj+7aB7lJjpkdN5EcowNYE74ZTswtBkYbCOWjbar
	 HcnNs8qsqfVnUVic6nl6veQiEhufeU9ErBFR8hwKYyYdKU9Tu7ak9jMBigwf9pFFap
	 6o0Tk6AheAuvQ==
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Li Wang <li.wang@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: report the configuration check on stderr
Date: Wed, 14 Oct 2026 16:01:37 -0400
Message-ID: <20261014200137.1364121-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C7C4C40018
X-Rspam-User: 
X-Stat-Signature: e8padada5wt4x67mjrd4fdbupodeqfp3
X-HE-Tag: 1792008101-281228
X-HE-Meta: U2FsdGVkX1++8PGOBH4mCbqyo7bALL0+sA6W1gC2nWS2+vWGaWQGJ2faVg8eC9yXXQFmNHnGi056Le8ooFHf12ANAcv+Zvf+xVY+H9OnPsT5mELSpUQHeQfWBuEopby1G0xMiJyjXsQJafjy3kV11qXw+sWyTSGsRg6T1E1V/od7BDmoEKUEzeKCp5BeCuZlm8yg1twBTpxXqzPQQukKvHzJr7abvhy1ZPDFVy33do3+nxUGm+PUI45ZZ8yIPdioXyx3EirdrKgSw3FLb/7BwxeEdk8uo+Ybs+Tp/OVeOSU/5n+qZuJV85lIrNIW0IEhNN60cB9DpvL84gQ8NO1+f1NSWdle1XgN7gwjSJFoyREfhTHFDd33IGYOqc9hUmMbh+pIq5gXShOBpfz/CtlwnSR/lB56jer5fAdS2wCe+MthY21rzJH2mQngkskfjxsR+rdEblv+V0+Ufj4+lfe8jkZqgSFS2GlpudfctCil80lU3B78s93R2O+MvDecz+Jp5HmsDBCZhzMalvQWI/U4OtTwRskm2hL861RM0JYYlTITV7PeB3qP06Nv5vWVzL1Pn6tHW+/IZ4YrNcFGs04rwoW1QzKKq8uERyXnCtnhzZ54hG0pFbQ++nzLnm4fsS8w6NuEM6iE1fqH6mPRPQn3teBQOVb32d4bqhyY9qpQ6C7I2ii/T8VNeAUf+zUcKsvu50MBNQ3U1OiwN5QpEwVzD1zAlCGu80JSehCIodfFzkUr6TUAdUB2PFCXpzrnECSRj8EcmjEAJPO3W9bR/DEwg5He2jXlRYbd18Vt3cJqSFdeq4uTLZbmif6Se4c3pIuG+Ky2ssWgKBpl5jRRMfBoaaYkq3gESUjbC3PFJyQk9Y9jynAeAlkmDaH09CZDQW1k3UZibcjepV5hPka2aCJmFAKlpYUkfJ2ifCaVLbsp6fKOUgVcu0cGUVWDt4KdWhHVW6QBa/cYN2IW448JZZs
 5iuZHttK
 qmnLaApLvT2tYJISLePqGOw443PMbtNuQuotDet3SSERYuartF+gZZed6qhlzhlUjj0S0BP/VxYrxaCzZDRCuWouoCJu59pHNYVx1isiw2TOIphdxfxtJqMz+OP/rjs5JggVJK3+XQJuNe8L76AZ1dmug53zz2RttUJ9CltylGG5PVMxsyG6EjFlwMVroAvjXTuTfFNyA4jZT2uHP7h9gj75v08U2tefP1ysCWEEVvDUr8Os=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mm Makefile includes local_config.mk, which is generated by a rule
that announces itself with "CHK [config] local_config.mk" on standard
output, which make -s does not suppress. When make has to regenerate the
file while it reads the Makefile for emit_tests, for example on a fresh
tree or when the selftests are installed with make -B, the message
becomes part of the emit_tests output that the selftests install target
appends to kselftest-list.txt, so the runlist gains a line that is not a
test.

Print the message on standard error. With V=1 the message is empty and
only the redirection of an empty command remains.

Fixes: 04cf82a741e0 ("selftests/mm: suppress compiler error in liburing check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index beacc0f873049..0ea72e9979347 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -266,7 +266,7 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
 local_config.mk local_config.h_gen: check_config.sh
-	$(call msg,CHK,config,$@)
+	@{ $(patsubst @%,%,$(call msg,CHK,config,$@)) :; } >&2
 	$(Q)CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
 EXTRA_CLEAN += local_config.mk local_config.h_gen

base-commit: 4eb2586bd40db27d77cc5b724ca9386ed0c71d53
-- 
2.53.0


