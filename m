Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48EA606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VyKVdbNh
Received: by kanga.kvack.org (Postfix)
	id F32A06B079D; Tue, 24 Nov 2026 11:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09D26B079F; Tue, 24 Nov 2026 11:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E472F6B07A0; Tue, 24 Nov 2026 11:01:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1D8D6B079D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:01:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A6C0140C59
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:01:36 +0000 (UTC)
X-FDA: 85470477792.25.BD84C0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0ADEC2000F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:01:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VyKVdbNh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795536093;
	b=dnTkWmUAQrW/LicjcNERZ/c1/XnxnMQXR3B4AaxTkTvOmCUumZtcSCoGXFqRpO+ECFk1i5
	z+ucsv63aGIj1EjMNE+UUYFu60IrCML7UYfCrKrBDNHFE1ePSy280CKNLaFR+hN/Fo9wr9
	3MxfkosvxElulCRoP3GlclPEP4FJf+U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795536093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=q9AzOcx7lT/GAxuFckU0BqUnqN5Gf6MdjD8AIDI3n7g=;
	b=K9wQ7IvbjGjA9PYaPHTfgrFqr5Sj2lrxmRKJTpdFIir7ovg7SDaceWNAunxLa69m3DubTC
	Ou8YrSIAYl/pHZNk9LNV//CDDYgxD5Aos1aCBACb29KDO17pijEc5eQpNE3uSTkkGfk4Y+
	Uz9Va7IW4sYS+86AhZkXRPr+0irqYgM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VyKVdbNh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEAE640A62;
	Tue, 24 Nov 2026 16:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEC31F000C6;
	Tue, 24 Nov 2026 16:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795536091;
	bh=q9AzOcx7lT/GAxuFckU0BqUnqN5Gf6MdjD8AIDI3n7g=;
	h=From:To:Cc:Subject:Date;
	b=VyKVdbNhhNwvY2U4T2D2HYlO9FeOrSAMOP7NjSY3IrbQntMzm6T+dbybYTGx7ypXk
	 4dsrslN9SyjdilOwkCNyJ2RCjmzOLD3EInnSHJNZwPi4XfOpvLO6TGpDi2xJqhzFGX
	 Ay7K9jIKM5abcBUIv4JRAxeQ3yfuJw+9X9tWsfQrlEYRywpCZ/wYokMOyp1y6pCrMt
	 Dgwy1S8FQIXk/lCcr8ehMcK/e6ncqN6pA6JLTmBjcuT3Ue20/RoGLGqFNB365nvlBA
	 vB0wv5xyLi0cEFXRO8Jqm7lANlFV8vzZPDlyutxmtC1xsjmFQbTaxEfTecgEvGfTbb
	 kLD8UKERnHgwQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-new 0/4] mm/damon: update documents for mm-next onboarding
Date: Tue, 24 Nov 2026 08:01:18 -0800
Message-ID: <20261124160124.93482-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0ADEC2000F
X-Stat-Signature: b1gtqtnhjnpkba8h8ao9m18jdqipsa5z
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795536092-689919
X-HE-Meta: U2FsdGVkX1/CkWW9iuK/VDsKAmiUjqQLyjxps5eBoV+BC0Mq4J9elM0ObTh5fQvsmFyUj+kh7G1NzornShsKyUvE4BNnYiaRaWLkrbM8NO/QAsE9POPqQr7lADCzuj0Ll0yn1uwk4RlAVfrYrSd4aJWz/xRrf+96ZQ+yMR9G0f/eHPxHS0W5+VcQnX3RrqSXf8X2FuLFEQwakpQvTzyJYN2ml5wISBS42eiyxXOeBUmvRLmvtlAlmsGIAc2QwcJ0jXNoGmFaGqlJc4PGuwPEIqzI/WtlxlcIQZKTj9EM6Y42MNGzmU/B4mwFnd4H+bPbBImuyscoNjPma2swtIRBO+mh6jFkaJDj6bTb9jPwvY1H2pCObaavffnDtAoVrR3trkbsJVsF3htMtMCJ/PcooSgjXp8rnT7Q1DCcLGIGRmJZZF1LNfUjp+ETy+8uLIEOS0JzEdGEv9qQveZC9Anz+SQMX+IqD4w42YcaYyc8q3cdO6Eo4PSTlG8sAIv+LxVOTvO8xqHzkociuu/7Kni+NLGn86+a7QUw9O0WNJRp50CfPvYcYE6zyMBTi9GgUC148Kgpa/X8tcQRu/S2RRfj+o3E4tIFblOzQCu0A1UHt2JoH69MD9COhlm2qaNZbSI+bJpk1mwh2hF4SiAbaX40LV7XxrY2ZJNcc0j+R/CwiKUWJeTKmB6NcOZOBC2n3NmeUb/L+/5xWnVK9Mvv1QEWMQNyl47FAuRHPs+dc4mEDoPfNOvdgCZlee8BmwSdqJun5BJfleaAFEr4YF6X41E1LZJV7mJC2WFY2XxWRjh2c71+InvFjBP/gfhRW7rOinZT8goenJSGmv7YsiCZXTPU6ghI/8FPVXsd9muH9G5wynEJgF+aa9AcCT5I4BOZJcL2B+GOrV4aNlrJbdgHCK98UdbcBE6asVtZt71FNn0Ax7tjczqp3jGs7vRkQQLAgvBCv6QVJjZlS6pukT6Uhcp
 3Wy3h8Mt
 DoxZMq/98ey7qEkFGl+TkIH3HF4HBfnvrGJ1DmnFMod5W0iDbMf3N75/zX55AoPUEBXIpcC+K5uC7ERqW7zEDGEen8kr8lHpbB6jYyMAUxrDwRPJHMwDjHiuBMRmGuIAZKCajgcUMM0KTTRJPqpeaNN0Hvngj3QHzV3rxifCUkM41+nogCD+pRI3Gds1eaNNTffBfgNXbsWcLolZkz5Rb9UbUIB1WJ/ww5Nrx9QjOp8DlO6IQNoWOMykp5wA8z7IGVbth1ofPNbxarAHvpl6Ekgeyp0OFZE2Qv4o4ubrd2ZnfzlRrUe5hJ3q6VCwh28MUUMzqyo0Rz2zMNn53xhmV9bmAqZkmagOKisjGXNUM+JcdJtY2dIu+5lzhc5cxJW5qJ8dWZycyPDZkmd9xaDGKZ9gKyTeZUIgN2gbEac/ntBlvBgdU6HoiePehykTndFXJGIHhAG1qk49THmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Right after the 7.5-rc1 release, DAMON will onboard the mm-next
transition [1].  The major change is that it will use mm/damon.git [2]
and mm/linux.git [3] instead of sj/linux.git [4] and akpm/mm.git [5].

Update MAINTAINERS file to capture the change, via patch 1.  Further
update DAMON maintainer-profile document for the change, step by step,
via patches 2-4.

[1] https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mm/damon.git/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/mm/linux.git/
[4] https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git/
[4] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/

Changes from RFC
- RFC: https://lore.kernel.org/20261121193331.108587-1-sj@kernel.org
- Update patch 2 commit message for DAMON section name update.
- Rebase to the latest mm-new.

Huge thanks to Andrew for his tremendous mm.git works that raised DAMON
up to the current state.

SJ Park (4):
  MAINTAINERS: change DAMON SCM tree to mm/damon.git
  Docs/mm/damon/maintainer-profile: use damon.git for patch baselines
  Docs/mm/damon/maintainer-profile: drop 'SCM Trees' section
  Docs/mm/damon/maintainer-profile: update key cycle dates for damon.git

 Documentation/mm/damon/maintainer-profile.rst | 57 ++++++++++---------
 MAINTAINERS                                   | 36 ++++++------
 2 files changed, 46 insertions(+), 47 deletions(-)


base-commit: 39902b38a4f121b7b3c847622585858cc8070c97
-- 
2.47.3

