Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37FE8E7DF11
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594106B00AA; Mon,  2 Feb 2026 12:20:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541506B00C6; Mon,  2 Feb 2026 12:20:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4408C6B00C7; Mon,  2 Feb 2026 12:20:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 336286B00AA
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:20:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04731139FF1
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:20:21 +0000 (UTC)
X-FDA: 84400180284.12.2EF87F4
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58898140003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:20:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lHHZP6xu;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770052820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1DQtxS8yrd/QjxinRXeBsrnGjaP26Y5jZZVyDCqTW9k=;
	b=BArLsqh31dEgsfBZErVllb3jU7p7vT2jZ0LlyF17jmmdZImNG5KJg1FSrswpG+qA9OIE4G
	JK4vHfztIu4cdhvIq/oVV4Lfr+Y6L2a8XCCK8A4tygwegGmvURIaksKAzQNfd2CNLHmFZh
	udTjnS1I47T1O63ty27/EAhDulvso9k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lHHZP6xu;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770052820; a=rsa-sha256;
	cv=none;
	b=Ver5ejRVl/aCBnmxEiVTAwwp/pfNkBjb8cqFfXXUbsOZ6SiZr/8hZcOZPjUlzmHu0pe+QQ
	rcHb7RirtFDLdCc80YziyRR4Sfzm0yg1FXMAphrSoGgyTrBZqh3MJ8UKmo9WMZWB2jnV0A
	qScjJtn3crc+lupaphIDqHZI2ltj/CQ=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-124afd03fd1so6882075c88.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770052819; x=1770657619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1DQtxS8yrd/QjxinRXeBsrnGjaP26Y5jZZVyDCqTW9k=;
        b=lHHZP6xuVQUtDoGxwLAbt8qJCe8QFg1uvw/NQFsoksUabJT0vmg3P0WYoiffd7dqCj
         UeVKmlvG+2ap4F3abZKpyKYZaSwXOBM13APJ3BW472k0yOnuTjB98JDUawx200fKryiJ
         axEypKgoj4Y2D9GgFPC0Ub2CukS0TQkwAHiwDpeoEGe7Ajo+5qIyYfGwSJ6xcWzJ3iju
         WSEaA8nUmVC2MRDIDIioeXUbcpbRTpM5W5Pbvo/SLNaxBHQ/Mq2+bhvwnrJL02eyUnd3
         l16wzmDZ9vD4zULBbs+DtdEMoTkBFd8HlWrcYB+VpqcS2g46bWTfk7gyn8dVMpjAffie
         uiYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770052819; x=1770657619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1DQtxS8yrd/QjxinRXeBsrnGjaP26Y5jZZVyDCqTW9k=;
        b=fLvlL9N7gOX7dO5bHgB2orkGq7q/CIoR/aTjH+LXb2eNwJ+Sbaz5cUp0T3npA8dgDc
         OcaLzafmOrk1EsgR1btTPJOK9Ooi5ExhH0s0tnwqlrQgzEFWO26tOU0lIShvo2rje3pO
         9AepKHUVu5Yab9anOMmv13j3Y+C1JWvOgXRe7JUh/Ksh17DIVTql2hLr8OLHk9YqjVOq
         cHe7NfpmSxG6SykMArKKOeL7+TkYdQLBnOfuM+Jbta0CW6VAwjDj+VNgs549G1a/aAdv
         j3igHMfFyIESr1imVvZrTfLvhVZfGqb4aVVhwGt8OOganqBuHKPr+G7tF3bUCkLlg/tM
         muwA==
X-Forwarded-Encrypted: i=1; AJvYcCVoIdrV244ZlWOZr7hwbYejU/0Y5AzBosO6WuUZ/1mfn3sFPJB8Pn6fptixFB2onRC52eE7wsVX4g==@kvack.org
X-Gm-Message-State: AOJu0YwcXVYg6xPATMSQc+4H2XNj7Cz7l0psDGBMeaju/f4MA1SgaWMn
	IssJLwmRTVnZixnMBLXZ778aeJp5gSbU7GDw2bgQwwXiZ8rq8sZWHw5Y
X-Gm-Gg: AZuq6aJkZu8C3G9AQ/JyLcYdX+/qBcfWRfdFVREjXblWnAUVM+eSDYSNcXRa3G4QwHr
	o4D8JjgPAr2keLaqaiOM6KIHL5uo3X4iF1INkoLYWCy8J86fkHl8g1VMKqejjNDnRhqER+Pm+e2
	7eCunsNgDSDkIZWbHaHa8PeWLtU7w6AajtImmqMUzJyJm2RsiIH/tq6qyYp2eIDPAOBmd8bcJ4t
	1QmJR8BF6c2Arc7rPgojoO2WLkPx4P2fDK9ehk0+XwGs3RiiDaSCNvgYerRnBz9nRj0PJ7Xuzwv
	8FVPF+f6/UKF5nNu1ZqTSZ0yBe8x21yOJuqdQxbRo3V0+XwS3AAhCU8CHJNnDAh1YckyFFQJzNB
	ABBvxFWIiOp1MCA2wKBeVD/hBHUFPTNyt8habjZwpAMcYv3VQ6tqPB6mwBipZxJbt6uDhLS+FtB
	Yr1zWCvt3+ctZ0esqJF6qEm8bCtfh7A0daS5KPNZ/lJaPRHdCBW9NYpJqSZI8UXB8jUWElkQ==
X-Received: by 2002:a05:7300:ad08:b0:2b0:4c5f:c05c with SMTP id 5a478bee46e88-2b7c862d9b9mr5359761eec.4.1770052818840;
        Mon, 02 Feb 2026 09:20:18 -0800 (PST)
Received: from fedora (104-57-70-139.lightspeed.sntcca.sbcglobal.net. [104.57.70.139])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2b7a1adef97sm20129902eec.29.2026.02.02.09.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 09:20:18 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v3 0/3] Convert 64-bit x86/mm/pat to ptdescs
Date: Mon,  2 Feb 2026 09:20:02 -0800
Message-ID: <20260202172005.683870-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 58898140003
X-Stat-Signature: 3uym3fxe3bfzw7ffh6zsifcjssujbw9t
X-Rspam-User: 
X-HE-Tag: 1770052820-438458
X-HE-Meta: U2FsdGVkX1/DGOKKW8DShmeN5jORnjNsSxKlOwrtcNPUffVd9+XdJqSne4xbRwZoaEq9ry/IbdKnlQRTpAgfUS9nfC7Fm+32ur6GWLMwWgQddt1NWll43M9tamYVEVGPL2uLdeuP7io5+i3PTvIQeh0mAGnrXzwH9ocFqKLOWFJ8JFV4fZLUygBPeIr5lwj2GMLakGCxAQ3dYJ757zfmwggOqfAPY1Jlx3eE2/ppZHlhMCaYpRXBhRuqRRWUPI4oxrX6CO1XB0lRnK15jphuwzdF2kLLcBsmzeH8cXu+XrOMFcYhKNuYYNCX6czj8fP4t/ZIkKaemsZWqsTf8lSO8/KAfQIdIMr/+dRojXebjImQeVCYKZCK9XwFsraEJqKPVmx0B6R3lw7G0YGoNX8JaCcL6IFiKquJ1gWFY4HS1meSKuyjGwpYPlnPC3vB2QGUxXXbdPbjKRlGsULJ+TNKXUqUel231aIKEOo2hHnsj51FXXZLxX4Y6reArB0RknlqiMP5HtFFEaO8K9YAIsSYvwtuthtZnNq9W7Q0ZYctXJWYTrW7MF3ygfHC28iuv8HY8Q6ygKtEYS/6GNHmaaJ0drZP2W1o+TLxS1u5ZgjGCjisK+ir5cmQFrSTwlZkIpQwx8nxrmpgnmOuchP7y8aIYhPvCDNwrQL8YGtELL5Bd9Y/ciMB/YNcp8vIZ8jrTgmwp92SOfESZgTbKlSdre4LktleM1Evk8SQwPeTscHCvW5A/0YqGpfxbwnx5ppU73szyLsnfytdMlYfRncVw5qkp4nxrYlkN41NVHlV8MnmSH+mVldsF7asXC5+hK0C58BEWT7QAvH23Hzq8gezn/Q/u7AfRwMQTi8BWRJXM4qKG19R2zWhX+T0BQBwP9T5nsLMxhDHfO8CiFmQvX2TyIWU6TV0+VoDs2/yL28wI5PyR8dGSVyeAXD3pVKvIBrfKGKwoy5sQPdeAXqzrQtAwC/
 49jDJZwD
 N9dxSoG3Dere5hwLJJ8nWJ1XZsTfh3pciByB5gruFaKZ3FTqqFhP82n0pqfAciAM6LC64/rV8GjntCPcEexbj9nJhuaNg/aJIKt6G6Td8OnXKluDZglnPSBpprQ3zy34V7ubmuO29Ohs5WIs9y2LzYF1PrwnlaBg9jnibnrlyR9sMEWva0Dk/IRzGZcLV1qJaYti9MfnxPGnXe/M/KatK9PBk+0+hYeOfFfK4QNHlaDqLOxfuGUB3DIrC+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

x86/mm/pat should be using ptdescs. One line has already been
converted to pagetable_free(), while the allocation sites use
get_free_pages(). This causes issues separately allocating ptdescs
from struct page.

These patches convert the allocation/free sites to use ptdescs. In
the short term, this helps enable Matthew's work to allocate frozen
pagetables[1]. And in the long term, this will help us cleanly split
ptdesc allocations from struct page.

The pgd_list should also be using ptdescs (for 32bit in this file). This
can be done in a different patchset since there's other users of pgd_list
that still need to be converted.

[1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
[2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/

------

I've also tested this on a tree that separately allocates ptdescs. That
didn't find any lingering alloc/free issues.

Based on current mm-new.

v3:
  - Move comment regarding 32-bit conversions into the cover letter
  - Correct the handling for the pagetable_alloc() error path

Vishal Moola (Oracle) (3):
  x86/mm/pat: Convert pte code to use ptdescs
  x86/mm/pat: Convert pmd code to use ptdescs
  x86/mm/pat: Convert split_large_page() to use ptdescs

 arch/x86/mm/pat/set_memory.c | 56 +++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 23 deletions(-)

-- 
2.52.0


