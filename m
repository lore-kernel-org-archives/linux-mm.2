Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD68CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 05:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A786B008A; Thu,  4 Jun 2026 01:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B536B008C; Thu,  4 Jun 2026 01:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860F46B0092; Thu,  4 Jun 2026 01:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74C8D6B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:53:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1467040505
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:53:27 +0000 (UTC)
X-FDA: 84841162854.28.B66119E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0310E180006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:53:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D1a37+sI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780552405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=j0tJrvPG5j4W541NDyjuYhXgvJ/KNn4DD8KwVnnKfO0=;
	b=qKu5d8kIsPWDmVZknXSAq4sdAYRektCn81Mr9n36q2nPDo6XW0mCEWuamhVCxrtXwWPtdz
	Qq2V6xdO6hE/vn8faxjudZwx18DRkfnlLZtv+lJhWor1qXCW4ip0kj9OQPZ0HOVRGU3dKp
	IGmkaQyODL2BZjfgSqFFIi9Dlh8QELQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D1a37+sI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780552405;
	b=2qJfF07L2/sU06Dkq+91YC9+EtEmYzqKpiyjZM+5ynbY7aBZCf3Ig+7JoyFDvpgrL/uJhl
	O65KoMgQne6ifGQBG/ok0XgJxtKX67jX0HKp1dR+nz33bGhNoHljWYxpU8LQ16i586KQ59
	SOgN2qKjFw558JWULwG14aLNMvXjjQo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D59DD302F;
	Wed,  3 Jun 2026 22:53:18 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3FB453F632;
	Wed,  3 Jun 2026 22:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780552403; bh=EEYF8O7AEUhjF+sbv704hFcrFcRtIyD5CazH5tKQkzY=;
	h=From:To:Cc:Subject:Date:From;
	b=D1a37+sIbot7rEMsl+X7Bzskf3G5TgA/GAw/D7RevEV0fp8qxIkJ2B/uhYSoMm5ar
	 aDtSYl6v07F611Ilnq4KyRnscxl0KPU8m7l2eHqyeEFZH/SeT/Hx7H6mM8GFLlrNnO
	 Hu1p38L1w2w5Hzzx4Ptv6FeP2BFRzlCEmJq9P+bQ=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	david@kernel.org,
	shuah@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kselftest@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v3 0/2] mm/hmm: A fix and a selftest
Date: Thu,  4 Jun 2026 05:53:04 +0000
Message-ID: <20260604055308.1947679-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0310E180006
X-Rspam-User: 
X-Stat-Signature: ja3ajm4zo1tognnfepxn5wmx74gy1tqo
X-Rspamd-Server: rspam09
X-HE-Tag: 1780552404-168155
X-HE-Meta: U2FsdGVkX1+nRJpj4zNcJ702WnSCKuhhY/4VQZOkpXS154YmKoW5zK4J7h9ibyEXKEP6/Y3/RFQZ2WHOAa8zg33OvwjC03IBvOXeUFs5Y9Hv/l0zUh6G8IXixGCl7x3z5xesikytCgVdn44OQ4JcswE3wnX3hWLMQK7di2GwQwXqWsqFlr8eo8o5iBi6/do2uMiEzyxCa8h39A23S449h6w6vj3MadSpzp09QNT29VUxNqNLa0sOwuPQY9KJXTYKtZP83QZ4rvctAK95wdj9cgdedw7Vv5lomjsAko39rxirjps499ZIoH7+SFwQw9/32SBrPlPAfwMyqwIPs8x+lMMPclY9QCmZfX/LOl3Le7wwInu5gIbK16Kj13yj1tTbWjWd8MgrHY2aKVC4MDmV4PF02aidqvyH1iKot8pwlGmxo4Jcn9yXFquxG+OYgax6uC0CPs631xvuctGSLDCudFc3Hap9WI0MBosZuVS36F6dwTWn09zEvnXv6proyNFG+tQFq088M1F6o0OJCkyRW4q3vQ4oq+m28P9vCItaSlQo+CbAE17YXSVrO5/u2GBN4+fRMs6hqZInLXRwvdYbWmLauIrlhS6QVJsQEVBadf6+TCVLw6Vn2i8+lIyTWPHZCjbskl1yznTFRJmJpXYli7wYAM9bwPRNau3U0fw2A3ZkzSuzSKPMpABQ20iAs04WacTx80obSZsoB1Xaz2UsSudOdQrCJTs5GFtWAeW+Ms8N791QIH1DI4eK/WPsHSS9Y2b+5c+1cwtd0h7uK+wcE38CBpYEr9+jcOBf9a9K3jGLG+RrYoOObvEGEjd+YOqb5365n9buPxTxvyIoANLvDD+opHyojxJm/JCoB1Viw3V+yrgqEUd21fRvPwMUZ4HZGzJ2YoMf8K6DcnKjO2ZTfnh0FKtfB9AAHEASTVD9HquB3tMu/k54jRDWJMa/06RKviSe7xLnC+abT5VMLJX
 ZFr9KQj7
 cVOqz4V3DAdjMh7Zc4h3RRulAtDclMm/Ftg62WiTZZtadfv4BACDgRX3z+/wIv9s8rmF1+phE7RCPIT+t/fmAnY40TynAYIEZdrNrrVQG3Qc479HuooMAIcZn/mLsX1UEEC66DsisIMSJro+WycFJIP2gGa5D3bI/gKwyaxZmRoFeDYkorYVo4JQGRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 fixes a stale warning present from the time when only migration
softleaf entries were supported at the PMD level.

Patch 2 adds some code into hmm-tests.c which exercises the pagemap path
for PMD device-private entries.

---
Applies on mm-unstable (d17fe8a046a2).

v2->v3:
 - Use MADV_COLLAPSE, use PAGEMAP_PRESENT

v1->v2:
 - Add test

Dev Jain (2):
  fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
  selftests/mm/hmm-tests: test pagemap reads of PMD device-private
    entries

 fs/proc/task_mmu.c                     |  1 -
 tools/testing/selftests/mm/hmm-tests.c | 34 ++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 3 deletions(-)

-- 
2.43.0


