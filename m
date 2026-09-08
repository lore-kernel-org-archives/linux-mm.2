Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F33EFC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A4D6B008A; Tue,  8 Sep 2026 07:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1456B008C; Tue,  8 Sep 2026 07:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF73A6B0095; Tue,  8 Sep 2026 07:36:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C28A46B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:36:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 617331C260E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:36:40 +0000 (UTC)
X-FDA: 85190392560.15.1DF5BA3
Received: from out-2uec-a118.jellyfish.systems (out-2uec-a118.jellyfish.systems [63.250.43.118])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8C257160007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:36:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=KVK1psuK;
	spf=pass (imf08.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.118 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788867398;
	b=E7+37S5PHFNhG2vIkZ3WeaJtlqKChL7+lnfILqH+cUaMPpN2LozuY6qbtv1zaNu5cXqkbC
	FXJP3+CLh4eA9xB66DpVmdIslQQtIPjE+0hrZylCpcJrpGdUGea15PeVevkMM+Z/XzzqyW
	SJTOGI5Fe5aaKLIonY1cU4aamv3Iyb8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=KVK1psuK;
	spf=pass (imf08.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.118 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788867398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QlSwWDc62amt9B3uQFWbcOODm1fOh2cWYxYdZX6eVbU=;
	b=eMGN8W6ZiIMw6dwx9bx2B3rlA3dbR15KQ8nuzwAjiR2GIxRkM/3Nm7YNC/lZJY7Yss8/gu
	iQUCXS8S/yYexCvHg88vVnjWffoLgvU8ow/0ecQDtWkI/MlsDVpXFp5jFN/Dm0zLMtW3Wk
	CWBLwILo9YAvWZ2G2V1Zjj6SOjCt5aI=
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hfMMm0b0Yz8sWX;
	Tue, 08 Sep 2026 11:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788867383;
	bh=QlSwWDc62amt9B3uQFWbcOODm1fOh2cWYxYdZX6eVbU=;
	h=From:To:Cc:Subject:Date:From;
	b=KVK1psuKkTm5JSiyZwfShXS3KjXrf4eUw+Cmy7eQk1f6bWwsy2kReKZgw/oJhBIoi
	 vc2Bthk1LEDkGDJyHl8+8wnpGSbolDXimA45WrcFyqlLgCDWayobiVfNmMA+GDIJGC
	 tL8DvTfdnZRRlM2A+q9poTH2v+nAM58LqQgDdHcRHMXriYkldP1U3DQfnKGeJvQ66l
	 YWtiCqwFYxZZC8/u/crYtm+pVMd0541TwLtTseJbf+07YLnEgb0yEAZmd2QFjPu+dY
	 lCFOmnngRqP6yBZXKGytdERtHdKA4DqCvszTOxBcAZ9nTwNr8IH8S/24itaAWuqk/m
	 cr37kIf52nHEg==
From: Tianyi Chen <hi@tychen.cc>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsavitz@redhat.com,
	hi@tychen.cc
Subject: [PATCH v3 0/2] selftests/mm: Validate selections and scope memfd_secret setup
Date: Tue,  8 Sep 2026 19:36:08 +0800
Message-ID: <178886714088.169611.14957244271354428473.mm-cli-v3-0@tychen.cc>
X-Mailer: git-send-email 2.55.0
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C257160007
X-Stat-Signature: g75e9mbyrnwuf77u1z4ar5st7d5ioy15
X-HE-Tag: 1788867398-448387
X-HE-Meta: U2FsdGVkX1+17zolyCBbJmLO/XsZ0HZfSdkaMuzrnAOXE86Ou9mx5vVWuCXUe8GwPX9oA79ADCMOpZbA292d3DvC2/6Zc0PyNuBlJnR6GvFDOgFpxwLU8KpkCQLxuJxHZw0itHW8oJZVyahVZkiji77noEauqGhcLpSihoeiP/vRi7BkAeh9TFcqqls7gXm9Y3XmABCDCiYHYe/HrRHPanVeE+H1MjKaEWKpMSEdhzU+UyoQqpJg2CYRdUKWLitQ4zIML1OfEluiaq2kyP69AkaB3lQXAiC52YZIE31hPiXehYwQMbrfv1MFmm1H+vhe191GsxoUucyxX5gQC5JrpVg701GISyEHvIeKJBgzZetTBc9hjomDEq+0Jz1C2TZqY5y+yC6ctexlAUeO6Ld80Q6SPIgd684GrfLWOFPnOZimGQwdMu2UrRM5KtsQQ/r41efjPkSpAmvmEFQHO3pDZ41z/+6m9dd5aLiKUunFDRnAfW/9ImyypnXWLfRdpHe5rt4Q1I3urnCI7rYTAfXvIafGQGss6Q5lX+YEJCfBk163clJtRJlmo+rvoNVVX7xdvbnTT3q5bf0J5UiZ9gGsB4DAprY9k9+TQQbpiKWIqFe6p4iIrJ2q9qlUW5irfXzx1kPA8eekJgyKu8N8ltciocvCwZU3ZYH20p/GnNsbKTEkmJLZI+Pozn5POVbMeC2Mbd1J9hsfaLsuo9snBIUazc0i5mibFWw7DK8SeSCw2S+5L0WA/d/bJ3G3O27o4Njt++2KgDGwF4k3trZSBsX45JU6QgzxYjgWr7h2c3k8IqRyn0RxPdnZfa105kWInhH4HzKxBbSM7J2VU+gAP0ScvXTMuXXUdEWDxWSooOV+8gyuqjJMFo4vXSWXtNgmx2meKOpmiLB5aIQicQZ/ZciK9QpohxA+WtfYFQaDvBgUxXzrkb/s9Q4Cy+sQj1B4qk4AlpcZq3pwU3CF/AraX3B
 KL5SjGOO
 dctPkcewfQbKMIokiAItYFa4rVKJuhGbdZlZFy32QNRrUpqMBsUvqKTEuUkTCk7zzNbCNrkuMYaJ4aON7Ug/5E96Gg1qlQaC4OclYYa+XZW1F7fu3S47oKggXHMHvfn6OZ4+BpK/vnIxn/YSfgqP0Z03lDgbSob257FtyiNrAoxFz/PDqDipt52rCornJ6pnf+MW5YRrc5RNGFlSQDGpt+RAGECRUx5DlF74udG1YnbqcISxI3z2+WrotGNAChfeQZT+knWkPBawDeF30wUU3MTbmM7rsoeK/RY9XD00B76fFtRRyEKyJAO6B+Q8sG5DAp2ZbT74U5q7Cio0V/RD0+lMKKliSZmKJcveXYSnU+4H8BlIHcrkG7sRdlJLf6lOV2nN4Sb9leBo72JHavsFr2jFuE+nDFuClonI2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh can reach test setup after invalid options or category
selections. Its memfd_secret preparation can also change ptrace_scope
when that category was not selected.

Patch 1 rejects invalid selections before setup, using the category list
in usage(). Patch 2 gates memfd_secret preparation on category selection
and executable presence.

Changes in v3:
- Initialize VM_SELFTEST_ITEMS to "default" before getopts, as David
  suggested. Only -t changes the selection; the previous undocumented
  environment override is no longer used.
- Use Assisted-by: LLM in both patches.
- Add David's Acked-by to patch 2, whose code is unchanged from v2.
- Start a new thread for this version.

Validation:
- Bash syntax and whitespace checks passed.
- Nineteen isolated parser checks passed, including omitted/default
  selections, ignored environment values, invalid options/categories,
  missing/empty/whitespace arguments, multiple selections and help.
  These checks stop before test setup.
- The only code change from v2 is the initialization above. V2 passed
  focused mmap and memfd_secret runs in an x86-64 KVM guest; those VM runs
  were not repeated for this revision. The guest lacked Yama, so the
  ptrace_scope write condition was checked using a disposable file at the
  expected path, rather than testing Yama policy enforcement.

This is focused validation, not a run of the complete MM selftest suite.

v2: https://lore.kernel.org/r/178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc

Tianyi Chen (2):
  selftests/mm: Reject invalid test selections before running tests
  selftests/mm: Only prepare ptrace_scope when memfd_secret is selected

