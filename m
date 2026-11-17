Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0ED4606A336
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fNQgkSHv
Received: by kanga.kvack.org (Postfix)
	id A4C3A6B05D1; Tue, 17 Nov 2026 18:15:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25BA6B05D2; Tue, 17 Nov 2026 18:15:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4B96B05D3; Tue, 17 Nov 2026 18:15:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5E86B05D1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:15:04 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E82A71405CC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:15:03 +0000 (UTC)
X-FDA: 85446168486.06.9FCED2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 49C7714000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:15:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNQgkSHv;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957302;
	b=sIb3RnlzNO5vGU5LFNrUuowp1cTdkYjFn4TBW9WHQsHomRH9ih3EXe+JwhjeZ3dCpXsnHb
	qBfUjGz9jW7tB7+p1K39uIHsZNh/0uuENJC7tIHhKWF0pCgkSkioXiv7Kuqm5sqxmVb/VY
	pUuCJjjHWkrc8hfkm4ILFvWzfaba2V4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	b=ZEPToG1ViyNgXK2Oe1Wu5ugwfTzhy3BdxAkpg7pzxczUaboJvWKErWJ6fwrfj7ULCjeNF/
	/emlN03qASKxjX66Bcd9hEiSnHFuCtPGsjVTOKUa4ZlB6Qebs1+Rzyi51TCwgyTn4Oy21w
	5NDZDcAvZ9qnD+UOg7CQEnUSOc9noXQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNQgkSHv;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id B9DB961DB2;
	Tue, 17 Nov 2026 23:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AF1E11F000CF;
	Tue, 17 Nov 2026 23:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957301;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNQgkSHv1jzPUwUT8AmMKSYEji9oZi4HIMBMb5IcRcs5Y4gvlDtPgP0FmolN9UTBM
	 blVnkOtiPmDGJ2f+Af1BvrSe9U1xok4hMhRBcUNQUYzgUEdUTzogqFqVMbTZ7JiVGG
	 xoxqn5pC64vdPAR5ElsuRgPjFUnZGyg7fLJIz3hRTWqSAeSnsWQXL8S53jrGe83/Ny
	 s/I0RykmvZA/8ZqQJ29vAy+wjl4MuJq6DPoPd/ogJc50wCI8k8IM9tUEsm8RlQYhfu
	 8M8mFQK20cuhDgVuifAi7KTPKtKIfX1Bb1nLranRC5+rKjIkniUkVkEIMm14iI5TKy
	 HKmMwislFi4/Q==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 13/13] MAINTAINERS: Add entry for ROOT NAMESPACE
Date: Wed, 18 Nov 2026 01:13:52 +0200
Message-ID: <20261117231352.3816603-14-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49C7714000B
X-Rspam-User:
X-Stat-Signature: cw73ng7gqmsbnexty1meh5asecx9f49u
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794957302-147409
X-HE-Meta: U2FsdGVkX19vKMxKth6/uFVaAsYUXCUUrW5eIjbE3J9yN/+HcpUFHG0QKlNkAtdoOzkJZcSO9U+AZkGChduD0nhG8yAI6WBVdbKmo3i/bZ9mwznB1TEMBFX6LLD6uIZgHrvDXbCclISgrWP1kAKavcCxs11Gs3PrfnJ65sDXbqjX2oSEalR9vXFX3uDwxv1harcOQ+Chb6mU5AyTtIabvy9USZySfx597qJOKBfhlIWt8X4Yl0rEvfzIfeHjjE0HLfKFJfguul51myPR9/5S/6x8KDSesaeDVmbAa1b5FgorI1jxd0+dUHuMNrqZud+SsxINRhaRsLgrKh+jMJsPJnYclXJng5l7fjgtsGLxZml9ZgbPi40Yg0JFF5alq9CHVWiyVIAyHXx3q+hr66RTHnxLQKKDGvfnQLnyXh4tDuW7rLnBIecbtPpzoDXgukvyAT/KSMC5riuXeAaLVltuV8nkbmrdrhNyPkMM07w28SPN6jIus3qLaALnL4ktjjDp5gCoBP1hbikfUvoupSeffs77XwfmMIGY0hWpqElnWEfIzetGoOKj/D9JWCUbrjLJ1TfFr4peyARwOrwW2VG8Vke1JRR5eU0AnbPW2imx2YPscXgwV4pwsiTzqsWEr/ZZkP6NaE7orqqO86TJaAbp35h+SKTMsanaH+VhTuPMrlgya8vWGnwUpwpFwzj9vgIOUns8u/O/19bmhko4XYMDqoAwJ16lCdtf9ct1zHPJN0NP7IUXiDrxEd9Tz9h9Xk+v6TD2RGzZ0u0a+LncCV4JM7hNOkVsAJ8R5L9mNGV0EpJnWI21qrEt0z5XFW2+NomjRtjQls3LAXuL1uZYdKpSy/p0Obs8H3OVV2VomA7h8nckwQQgS5zsAwUQth7BhQZ8vUjeMznNz68exGa5vNymk+xBNktGenyuQgtR2yVMf3JbidP+GQZAucLAMSTINTxc+cRKUp1nv0kW1S8RP98
 s+j6Otah
 bxTGVV9c3V2GQV2uk8CcsnAAH6mM3FSZWXn62Ob7wfp2cCjBFPE4W6Z2/bC//gq7MmQ2+w8qRLfVn4WZ6V1kmhAz6S+ANUFZduzVkIZoM2+e4i86/U+FPc61dgslYzaGwmahZ9ONiI/WDvsaaCiH84rMSUBKMU604w7sDL/l5UoAqEKDXK8YGXOjlkKR8D/E6WmG+4GniuSFTqmoC28pzC95RtqxXZu80wGViZ7SdTfMSaRbSps2OjRWYNmeZzjMQKLt1PXRLXYcH8lXoh1Eg5NvRafMcCmzFWBEZXbc680QGmgN6ydjvfh/PKUGVAYqQqzJ0vIIeN9aTEsrwIQdT6+mKEWGyST7wTWCA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Record maintainership and mailing list routing for the root namespace
subsystem across its uAPI headers, core implementation, documentation,
and selftests.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cbce21ba45a..072be5ec7fd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24533,6 +24533,17 @@ F:	include/linux/mfd/rohm-bd96802.h
 F:	include/linux/mfd/rohm-generic.h
 F:	include/linux/mfd/rohm-shared.h
 
+ROOT NAMESPACE
+M:	David Howells <dhowells@redhat.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	Documentation/userspace-api/rootns.rst
+F:	include/linux/rootns.h
+F:	include/uapi/linux/rootns.h
+F:	kernel/rootns.c
+F:	tools/testing/selftests/rootns/
+
 ROTATION DRIVER FOR ALLWINNER A83T
 M:	Jernej Skrabec <jernej.skrabec@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
2.47.3


