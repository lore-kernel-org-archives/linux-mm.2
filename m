Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31CAFCD3427
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 08:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214B56B0005; Sun,  3 May 2026 04:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9F46B008A; Sun,  3 May 2026 04:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128986B008C; Sun,  3 May 2026 04:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 01C1C6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 04:35:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 802E3160580
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:35:54 +0000 (UTC)
X-FDA: 84725450628.07.102DF64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C5D7C180002
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:35:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fvwzkggE;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777797352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=10tAPnHW+07Yc2Oq5wgb6DK+ST+oedK6c09LZoEgMPM=;
	b=FYD+UuVGoLIde4qkp/qi6beAnOb+zu7pMIUefkhud1R7Bti/KRSKBxvbeosMZHLlXQ9a8t
	9dMiFe9ra2I7zn0S18q5Ep/is54ettuOIFdjm0/d0MniKPxMrq73accr/mTiVh7GTgi+Mf
	rWMsGUBxElLPBnPMGuZTIF7JJ0DRsj4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fvwzkggE;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777797352; a=rsa-sha256;
	cv=none;
	b=knEkqnU2+JSjxZsI1Q1jOIFnL3wI8goLxI3/kxchIUbr7ESI5T/BnuGAMQvzgzd93Rj0wu
	+eQ+C1OlOs/ar/XVgr2uSNc7O0q1QX0yEFvzVOLDeVFQ9pZHmb9t7xQBrfIKxcUH3akR45
	FSEjVWf3aVheKybmCW0SEjsnUbliBtQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 960CD41778;
	Sun,  3 May 2026 08:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F1EC2BCB4;
	Sun,  3 May 2026 08:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777797351;
	bh=CQA0q4d/sPX+XpwN6jnCb4MOBbxEEG38vddO7y9raXk=;
	h=Date:From:Subject:To:Cc:From;
	b=fvwzkggE90FCeW7mB2IyZ+HT2cf2S+XUV5nHyMnXVrDyiUr8xGRIL4mqDSHkWECu5
	 PHXsE6C+YIvi46kY8Gqad+lvW3qEHa79rEJ0lo4M1V1qOcmf23v+pnqOlFxKY8rwhe
	 Tj4YMTUmtCFoUU6Io/xWEaIO3qOXbzU04A6zvUt2rIyoWXUxA95zJfHYTyjoT6VcPp
	 DeCz37IrH8+GJZCVqh5KG5HslpHyZ0kZIiQhvQ+uqj5Zg+1cse4hkZtm4OSRFXXBBj
	 t0Z+NZ9/e9nV98nzsRBLoX0Q2JQKDdCAbJWr17LRESWeROJRSv5kD0+0sqBPFm+Tuz
	 t2uUug+zShWyQ==
Message-ID: <38238703-4460-4a57-8d00-5e390fd2d4b5@kernel.org>
Date: Sun, 3 May 2026 10:35:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab fixes for 7.1-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C5D7C180002
X-Rspamd-Server: rspam06
X-Stat-Signature: 1mhwhi4dih7546aina13zef115zxqaat
X-HE-Tag: 1777797352-730037
X-HE-Meta: U2FsdGVkX18Oq2XsA7a1vdV4n9iSVQHlfAmb9J70AfzeITWGygVMRdmsVBu9/2zcFN0ZPafKsWh8jzWMZJXaHAdPRnkxFsVVykyIfAkRPhw54VV7sNYqhS9rFawya+hTsryNrhHM26IxufwyfTElP/vpbaJWxK9try++W3667CJYsgVTY6XjmzsbYOSvxV18qhdbsOFji3V71wsbviWC6al0+I/vAt9YfFB68dII+H3/ohnc1skhZzt402fBwtQpMu2+r7u5JtTrlxcp/Sjnd/Ohpf+wJn9OhXviqFClAwzaOxTEtQRMiF0vCDukveBZfOcv1VJvGs7aoq/nf5z5BpI7l1uSpArh/Hshzu0jVELh8nK9ViQrP/NvNN80BYATu06PQU/bqHaBqAz7Ie7FVF4zGXP0DHuMo2wKynrlQTY6lsACvkqshF/Nn71qR0cfXegbPetpGRK5Ai9UWAJs3p2+7FxVTQCtKyNbxX8K0HYrnqGR5wUh/KwMK1mPhFzxMAmWHGgPObOaaWc07QWj2jTAuEZrAce147w6sbqRoD9WI6wybP+FZsoLCtzsUEgMq3Vaz/mkBMXwbWaBhbvvzZFeUSAFLtVxgs2NIv44BxjHm0bZcBGq3VVmMHP+OFnm0pNp06mvQ0VotZo/ggS9F8Vo6SeN6LkmI5oy0UDhxB4gIeYbZIOAEDFScaD3vSYyz8LdyBMmQ3NKk26+dw2maRZsPXfOUy2bk9qTDY0xBzIRBXwFbsenhjE/o7TuLGROhBhcDTcx+Y7wplp4LtwKVutJd/CE9SHyy0ZEI5y4DVCwhHMEoiZfkHnQ4mK+SmCse8wPJTClv86V8HhBE5xMpKeWoZsoIRD57Ojy/eVkVh5HFWWvkJrjjn4P6V0Shxp+kK7qG4LcNUAGzdS0XwQcAkZHsIDfUf3v8PfuHUu2++AX6ApiDPHTblVhfH5N77nNBq1QU0ZHlFWeUG4RG+h
 3kNgbFzl
 aFG71K+JsyMyuFOUHm2CYs6XoidXJ7+eToRAm12suMJiM1e+jmHWpW5vlFsHPW/cY6JUiKvjRg9aVGPZactCcQpaS2bG86pbfYgbUXLoPmZJ3YFr0qzD6CxOM863yLSlvmuZxR5BdG+9Uoz8DQKiFaGDGSol8oXMRl3LRRVJOtwEKkdKUrGefkDJh4hcMyyYCqadKwyoYiaQMexi7d5+hzn7bHizkf6dE6KQtScjixo/BQ42ILSQWeNWiPHghFVT24Ea0GY/N+Fhjq/gunn1XgGhaNyo3IourlvANCfPEcMg3LzTgsS8UVZKeTDqrwQ/6Zcy7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1-rc1

Thanks,
Vlastimil

======================================

- Stable fixes for CONFIG_SMP=n where _nolock() allocations in NMI both at
  kmalloc and page allocator levels are not properly protected by the
  spin_trylock() semantics on !SMP. (Harry Yoo)

----------------------------------------------------------------
The following changes since commit 082a6d03a2d685a83a332666b500ad3966349588:

  slub: fix data loss and overflow in krealloc() (2026-04-17 11:07:48 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.1-rc1

for you to fetch changes up to 5b31044e649e3e54c2caef135c09b371c2fbcd08:

  mm/slab: return NULL early from kmalloc_nolock() in NMI on UP (2026-04-27 09:14:36 +0200)

----------------------------------------------------------------
slab fixes for 7.1-rc1

----------------------------------------------------------------
Harry Yoo (Oracle) (2):
      mm/page_alloc: return NULL early from alloc_frozen_pages_nolock() in NMI on UP
      mm/slab: return NULL early from kmalloc_nolock() in NMI on UP

 mm/page_alloc.c | 5 +++++
 mm/slub.c       | 4 ++++
 2 files changed, 9 insertions(+)

