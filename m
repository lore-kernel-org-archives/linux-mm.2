Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B659AC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D6D6B0095; Tue, 14 Jul 2026 10:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A226B0096; Tue, 14 Jul 2026 10:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A976B0098; Tue, 14 Jul 2026 10:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 821826B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:01:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DAB01A03FE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:01:29 +0000 (UTC)
X-FDA: 84987544698.09.923B5A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 811481C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:01:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M+JcNMVV;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QRQ/R6IhyCOalIrS8ASQJa7G5ZabRey9LTdrVciopCs=;
	b=6Vn1SJaOaJBnsP/rXOt9VlU2eSiFdXKr7IhLBK5w8MmTUqCT8VHWMpyCnIR+hBEG3zwAl3
	Y3YthkL+qrqvmPMwwwUYZjHpMZSW6aoCv3hH8NeHqjqTUHBUDxsr4aUiVACmEGn8X3/GB5
	Zg5Gk8IJSibALda/e4dypoBm06ro82g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M+JcNMVV;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037687;
	b=59QZM7ycbGoawAQXRqUtwczI/sL2NEEHxWeHxpLPll2P9NtIPjnvAU9bANz1JgyFWfshRO
	B3cmEoQzyf/UueOZNKQYkQIhSKGeeQC0QP9Vdx85gpwZfRpu2Vu4lGILSA7VFVFLLsqmOK
	jlZdrDFCERlaM0zJFae47njha5sNN44=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCB3660103;
	Tue, 14 Jul 2026 14:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272E41F000E9;
	Tue, 14 Jul 2026 14:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037686;
	bh=QRQ/R6IhyCOalIrS8ASQJa7G5ZabRey9LTdrVciopCs=;
	h=From:To:Cc:Subject:Date;
	b=M+JcNMVV9CDgT0gPBIPVPQSA27IJL/gRBnZAOPTX1WydwcRhmGm7WHkJ+0D2Da0Kb
	 VsFEwHsYZBFvPHqSiZwuu5jB3yxU3xf0i88j8ksfrRuxJJcdSEQ2YnqNfLZGEYwsli
	 wxb6yIDiox1plPbqZwCpcUmzzxSksbVCCQfRkG83JP0ME+ys8v5Lqxy4si2ws1L+sF
	 rDpjKU3XhM5bR5kp+XGi8OQNWTsNdMoRzvrXKVo4dGgPKqp+hX97+wl3G2ZcMYM1lb
	 0u8cVMT42gYYMQHLstUqNdW4T61VCoZ+Jr8BJvRSJmB1paB7OdGnxqbV1KVe4ekiFK
	 xGhcU/6ZOQVMg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v2 0/4] Docs/ABI/damon: sysfs ABI document fixes and additions
Date: Tue, 14 Jul 2026 07:01:12 -0700
Message-ID: <20260714140117.94147-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aufdp8ah563f1x7a9t1r7ejxzj7u4wfr
X-Rspamd-Queue-Id: 811481C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784037687-127411
X-HE-Meta: U2FsdGVkX1+AxLWxcEJcg/rUmJa4TYxQT6Ollc7ZVCkoQc/DTINO45fhmoShFRtFP6GmIZYgJCr/80xGEzshYD7wcpnk0VGiXXn/pMrdw8kyS3i2X7IxL3OdSzyEXyRlRhqntkxPqLbEodOo7qXm/ri2OQ2gsewehOD55x6jLGNE+ksK8O/oq246gpeobrLZGRstxXckVC0MqP8tMtzAfH4hANgev3uy+9p/9ihnsr0eMqVFdAnxOXzGFMju3LW8EyJJWovYIixC/rsusGC6Z6FMpJB7spk1u4clm1TOxz8FoHVpQiQhTGKmyKMButMc8Xnj0ad7wrOLnneJfINnZTRygT6TTFP6OPgy6BR/5KzynqCBWGVIrN70rrSPowhxb3qmgGejP9DZFp8gC8PHAHm8uckxyOK52We5/R3QqLYHwCOALth3HKpJxWJAZCFq0JBGlSYOe7lLt2gy3tP7yJv+Yr1r6lzoceq+z1MAHNAF0hokQsnz8TupT7xgQmykhgjqZm1wQALH7jirDCAGz8LmyeISqbFQURLHhb0NmcqfERnLSIgQOGL2aTWhXKPYvo3wi+jeTcA4b0YVdU8WTEFoLsfA2bOgig9hLT2aM9WkFnfcJ1WFWlWMQEBRU2Qlny898a+8kiOaoe4ezAxAmVV4qLayEm0ccTFsGnPLla+VH8UYrtxs43+udwlQLA26pkdfG1Ir154Ypf4j9hPQWYvX/DrBNXSD4/W9oqXzz2PiztPdLOqg1WWFXc2WlKvwEk9uBGjDTTzHqgO2ilgpQxl7cPeoCNKecq9s9qDQXfazPWOgcIsk3yoR4HT+qoIzbmgOcIok+qX7tRZWkPLGz9RBNSNmbsXd9s3OunH/Hz1f1mVUlwCht5G5PiZDMQA3PEFIY6P79WW7KH/f18Zsu9ml6N/GOmOVQeremDy+yrurg7+BhDRaTi4tSWaSNexVp6AbpTtUHFdEXywSiKe
 Lpc0pEKa
 tCQWH2BgKTbckTaw5EpEO4EG474WcjWxT+Jiks5xK8vqEnxz2d51LcC9OIJVFU7xjC6gxy30kZYVvZxXBO28RJRt+HxpJdr+UGHwL9WETxJZbT9+yLqrZPzQRD51ZwEr+FE88np4iKQTbD3+2IQgvTJdCStPMdvoTd0Qa2cXz/1BjGUd8nWvOcB7ShDCSQfEEKlIR9XsQ+7eSekdbLB+d4JINrbc1i1OUKoLgKo2isff0TjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes typos and fills in missing entries in the DAMON
sysfs ABI document (Documentation/ABI/testing/sysfs-kernel-mm-damon).

Patch 1 fixes a path typo, "intrvals_goal" -> "intervals_goal", in
four What: entries; the documented path points to a non-existent
directory, so it is Cc'ed to stable.

Patch 2 fixes two further typos ("WDate:", "manimum").

Patches 3 and 4 add ABI entries that exist in the kernel and are
already described in usage.rst but are missing from the canonical ABI
document: the 'update_tuned_intervals' state command (patch 3) and the
'tried_regions/<R>/probes/<P>/hits' file (patch 4).

Changes from v1
- v1: https://lore.kernel.org/20260710044737.561102-1-husong@kylinos.cn
- Rebase to latest mm-new.

Song Hu (4):
  Docs/ABI/damon: fix typo in intervals_goal sysfs path
  Docs/ABI/damon: fix typos
  Docs/ABI/damon: document update_tuned_intervals state command
  Docs/ABI/damon: document tried_regions probe hits

 .../ABI/testing/sysfs-kernel-mm-damon         | 29 ++++++++++++++-----
 1 file changed, 22 insertions(+), 7 deletions(-)


base-commit: 4c3e511167ba60f3934a530fa5675143a09eb909
-- 
2.47.3

