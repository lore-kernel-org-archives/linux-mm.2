Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26FE4CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651236B00C7; Wed, 27 May 2026 10:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602996B00C8; Wed, 27 May 2026 10:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518866B00C9; Wed, 27 May 2026 10:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4330C6B00C7
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1CBCC2097
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:13 +0000 (UTC)
X-FDA: 84813369186.24.5C9BE94
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE20B140016
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ESo5hzsH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TAYTp3YLYHc7rNj/43RIw8vpoUcMd82B06aT0BnHByQ=;
	b=J2A1wzADfkcBUosJ6dBxdqop5udjvG4BStjwTpdaBlIZa2kJaNkgQBUzGIcpG4FEe5ryfn
	8PjPMTf5+8UCz2KszDoMWelTJ5+LYnzwybsFRLpmNAuA/RieW2WcKL1rXAXIGnPT4Fil1T
	nvHQ/qE8v7DhJyBigXNTAgVcEi5IsMM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ESo5hzsH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890651; a=rsa-sha256;
	cv=none;
	b=frs+ix6wgAHlGTjCMen4BzZwyIkUpnBsVz9V1Rq2ILS/qQKTF3JCKL8VM8hA8V629jcJHb
	s0+Ex52qUBGtNdcBN1I5gqJkqHhT3b1PRTuS4xwdS35aZJJ7vTUMUEy04p2DVA/dPoitzs
	2cfJSpWKy9jZ+SNlJ9nPL+PvjsENOfc=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bcc9fdc959cso2055124866b.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890650; x=1780495450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TAYTp3YLYHc7rNj/43RIw8vpoUcMd82B06aT0BnHByQ=;
        b=ESo5hzsHhlycYNUuva1LuWD2eNjSQLOMwqOCTB0b6n6/Uk8jyzoA6Oj1x2RfEsL/Rb
         8tixxbOpM55Dvs2QKR+gsTxawnp9eRwsFBd4yjNWrHTuVkoYK//UiDkyCPMujzpA6Mvn
         WJyevNPstdQk0ReRuzCe5IP/kDSu6sWEYExAvD80EmRCECzM9Vw7vRW3JUp6EsfcOHJ4
         KTmE7je5n5z2UQQrcXxDeMWrgVkE+ddVOs7Tk0SqSMvcQbhV82czKuibWoKtvfATaA4Y
         xtiU0GKcV465BwkCYH/yMbREatuEaXtwmqby9VlTrsRpIwJ3tTvXIejZTozFW+IPfMFt
         L1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890650; x=1780495450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TAYTp3YLYHc7rNj/43RIw8vpoUcMd82B06aT0BnHByQ=;
        b=YWFgsn7dQFLAPdJuSgzwFno7PmHlnU7GSC1ZmmzHVO+r6e8c9hpbvlzd6/KxkK1cqT
         12s164OXrOHNEVKSheIJfyi5uvLvd+EBtZ9ETi8MOYUzLWxzT356Ex1v3rTUpDU16pCm
         8Rf0tFHNqup8xD/8Qyll/aphc6tE9H/ySGJdEQS1HaBR24by7KtVT5HlwW8l4+mXEVd2
         znr5ocpFi5ybPUsKlbD0mYZONcG05j7ZS2i51u8Vj9i/4MEI3bkQyy/Gt2X7oq0IWGr1
         8yfLJ/BOiTqQ+Z4mHYeegAydBbuHFb01pGSd4bhbVv3QxpfQUf7v3p+tHZ8mizwXTkIn
         pzGg==
X-Forwarded-Encrypted: i=1; AFNElJ+7vM/QENkKMZJJAQaSSRzjqo12MluFUqQq4rx/oDdrqtWZvPDcSrb03yCd1Cfc2eYyhJiVrhhPzQ==@kvack.org
X-Gm-Message-State: AOJu0YyjotGgOba5soOFTkpkMhFdEZliH4QecGsZ3jOnMdn0/tr9Kfm5
	pKRbJEGlg2KgYjTuLBDRDcAyAyqGBcSBGLi7Pw2hKu0sai0Zw1M+6baf
X-Gm-Gg: Acq92OHNlZ4pPl/lelDHvrAkay/swuBtK5xvuTqaTUvuSIT0gFG+A2Lz5BquPQVADzM
	M8MKJZZzIsdDMCMD4+eqjvv216OcnlU13LWGhbVVj7KiKVbq64brDuLaWevjTK6uAMbuZ/iTdit
	Kz7FMZRCBo96067JqzqWjnfcIueimVrMz5tTc6josttpGRoqVHz4aS8zU9WN2U12DzCtTXsHqEu
	eHq6jJzkFBwLhqm96O1llOIGLCrtQT5PfzsPjTLPOpkztBc1vgVZHXcig4veK8o8G65pDV7X8ci
	HuvlKxmdqJlDvm1IdiOFrHPvGmx0OBKF4ArTmRzcigAK122rzShwgWY4lD5cVHOzaYBH7YiYafq
	o+XFX5l8tlv4tJwoY2Go/7DIA7i3OTLlL0kcNMTzfsX4f9azykQR06YrI6/ipdp2au5aeWOE+05
	YP8SSwQKekOcXT5SPvlVDUImnFWcP50cYafy0V/5va8Fma4EvcmLHROxM57qenkBMV0Wa+OOKzo
	XjpBgniGqPe6xl6JNU2r4bfj9TLeXFMsQ==
X-Received: by 2002:a17:907:b5a3:b0:ba4:f501:cb8b with SMTP id a640c23a62f3a-bdd22f294a3mr1037575166b.16.1779890649230;
        Wed, 27 May 2026 07:04:09 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45edb558f52sm6693771f8f.14.2026.05.27.07.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:04:08 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 0/9] Convert x86 pgd_lists to ptdescs
Date: Wed, 27 May 2026 15:03:07 +0100
Message-ID: <20260527140316.294621-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE20B140016
X-Stat-Signature: eo8xam5gdrfn8d8954kjjetzcgdmh8ib
X-Rspam-User: 
X-HE-Tag: 1779890651-253917
X-HE-Meta: U2FsdGVkX18juO+hsHPeGqrYViVeUNBDhKzWl34mCYx1J8kVBRMueZzl9B44oNMpTC3mbUTumk3+lSmEX8qsBP3k8tXW+sYLp0bWsyHj0lKQdKKAdkgZl1JXQ9I1A1yEb2fOrbkeWIkgp2eRPxwb1PG8sWbq2ckZXLoLmCwiTu5fsuYOAhsMmtdag2nvaCZ7LootBdAymUsQVit3RAGt9FW429jPS8PxuI7BAjFcp72d9mPGBP/HCAFJqiViiNQ+Z9DQQLyvUd29nrPRze9You/OaXj08lGBFXQWYW4JTIgL9NPY1Qwy8xTwBZU8QtWhGoTn0q08ZlMzYqi3z3qwoT/Mso2S8DI67MVa1WSkvdeX121iQ/iNa8WKtvSGLX31pTXm0kwBYBjw1PcbrXOgkBz2ett4t4ajHn21oCzJyUWf7BzkBBiu4VqmEKSeE5izKXsqf6QvcD5a68fSIgSgEMO7y7SqjrFDabu8Wu06e6b2qYBdLaAxpkL2HTH4l1/BFWPuceeFYlkzM2RLj/UJ3Y5s3ePOCzQmw9tgUJi5Om5m6gOsY6i+fM5QcNq6xiegUIHdSqQbMTpCKgq856BAUyWrRrIZqJbEIfDQjGjfUj9lgu+tB+m6p99AaioUb8ryq7s1foKIi6XlyZnWrXd72V7TU3lMAJTClEqiDgmfbGwlbRne9YT7pktmEHTiewVkrHnKxZ01M9Mxb0j4xEFmvOU5XiMC4eel7OqpdRZM+0jrFAAheamae8+S7QTkffCI5G0z79IPHKQZOo1O2Au98SHygysYz1YTWgVplyIVIt+cJ9OlIVhxr1xbrA4RsFN31I5urrR3MiAYP/3Ribx1Leqwy7gxm+ZM13os4utHzwlqyAvf2q26XuKMCGRQG+LxZ+YSSDB+R3qJopbKxNCgKU9yCqIWOF8+83KHsIrbqfpM96dB4GXZ7WaB8wVcnOqh9kIlVSH9pOYQdBog1qC
 IH+aOmQZ
 Pi0gYVFa7uepEXjQjjjgdLafKuTk7Sp24rez4cD5gbeYClNNDmZbXlmt/EJNi0J3BjMvh0aOG92qxojn7C+RPGmD5KvTn0E6dG6DcG2Rf2XQUxuUSHqqYloAVDRPZkBLLZjDpfFJVnkF/e7fKrkpKZLlyWHQ2yWX8QKHBly4kp0VSW/0wN3JG7w+unF6eFTV2QnGRM2OOnMwFWArHbLz2O++dUZu0tkYStnXFewpgpczHbSLbGy5m1Tfjlsjwf+x1EdHtm8l0DWAzK9ILi8QJPxc81SCtzSmR/hY4Z8c9fLfiC4ey/WAe5ZwKdTyG+hsVsKOkAl4z3PWILjtLN9S4MJQb1x2wG/jBaTGCOFDPcd/1AD6syFXev5Ii/PylGCqTRbh05TSVESieOBIKdaL9zPijNRpkba+ZxyH+mi/0mksMP4rY+wFu8AylVQ48gsjN+q+7Nk59aYMhmb2MuHjZ3osbOK3wwVb9Yydyqd4+jeb5S59dmuA+xzRTP9DjHbeu21GW1UrBjcqqM3/wzjsItolo3p/qXoPaOR3WYgBqAQwgCvqFYWNJBcrTZkx3elh1cP6F3sMxu5a4A3COsdMzKbB9rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This continues the ptdesc conversions for x86[1]. This is a necessary step
in preparation for the separate allocation of ptdescs from struct page.
Once ptdescs are not wrappers, the pgd_list should be used to find our
ptdesc, not page.

In fact, after patch 4 we can successfully boot a 32-bit x86 kernel
that separately allocates ptdescs.

All of the patches are rather straightforward, I just kept them split up
for ease of review. There are no intended functional changes as ptdescs
are currently still wrappers around struct page.

[1] https://lore.kernel.org/linux-mm/20260211195233.368497-1-vishal.moola@gmail.com/

----------------

I've compiled and booted both 64 and 32 bit on a kernel with separately
allocated ptdescs. I ensured the codepaths were hit for all the changes
except Xen.

This applies cleanly to the tip bot. I'm thinking this can go through
Dave's mm.

Vishal Moola (9):
  x86/mm/pat: Use IS_ENABLED() instead of ifdef
  x86/mm/pat: Convert __set_pmd_pte() to ptdescs
  x86/mm/pat: Convert collapse_pmd_page() to ptdescs
  x86/mm: Convert arch_sync_kernel_mappings() to ptdescs
  x86/mm: Convert sync_global_pgds_l5() to ptdescs
  x86/mm: Convert sync_global_pgds_l4() to ptdescs
  x86/mm: Convert pgd_page_get_mm() to ptdescs
  x86/xen: Convert xen_mm_pin_all() to ptdescs
  x86/xen: Convert xen_mm_unpin_all() to ptdescs

 arch/x86/include/asm/pgtable.h       |  2 +-
 arch/x86/include/asm/pgtable_types.h |  2 +-
 arch/x86/mm/fault.c                  |  8 ++++----
 arch/x86/mm/init_64.c                | 16 ++++++++--------
 arch/x86/mm/pat/set_memory.c         | 17 ++++++++---------
 arch/x86/mm/pgtable.c                |  4 ++--
 arch/x86/xen/mmu_pv.c                | 22 +++++++++++-----------
 7 files changed, 35 insertions(+), 36 deletions(-)

-- 
2.54.0


