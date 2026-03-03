Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52444EDEBEB
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949C16B0088; Tue,  3 Mar 2026 14:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7ED6B008A; Tue,  3 Mar 2026 14:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CCA06B0095; Tue,  3 Mar 2026 14:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A62F6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:48:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08885B8099
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:48:47 +0000 (UTC)
X-FDA: 84505789494.07.B973D37
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B88920002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:48:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CKbdBQeB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772567325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JqmBdm0fSjykfnPzULqjAwjvph/E4EHq0QDrGs2BKB0=;
	b=qpF8yV+q1g71yDni7uzUHwpveRVG1AGJvZ9+hcAjvpmU/vN63zXuB+XGy1IZlhmCWJf2nv
	rClVT4SwLlkJ7T70sndifuY1KlUG7Ifgz5b+HOOCUYDOcFbP4+Ta7pLcu/3B8YJzvRQ9+Z
	JZng98cqOaDLE+ATVEnWJdyD3zD3XpM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772567325; a=rsa-sha256;
	cv=none;
	b=l5ChfXflHZCqVoYFtJDsPWKed3hSDlcdzwb1TiWsSC9EFG8csOVh5ZCdkJlqCvLL3pj829
	0+FQeQjgCCNLQts3Ms54luOmeZcjSZphmNZTICEz1aKKumSSbQuQpxC0RTijLx4EdxzPHR
	p/3e9xHt8ntDAqRP/FeNqOK9ouAyzOA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CKbdBQeB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-127423bea4bso357230c88.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772567324; x=1773172124; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JqmBdm0fSjykfnPzULqjAwjvph/E4EHq0QDrGs2BKB0=;
        b=CKbdBQeB10h9ldnY2uoAV1NsdObFz9ya8zeyVU7qsf+K5/O/BRzKPpyITsFN86fip+
         3kAuKvq4j48Ao1ueLgJx9qnqnMTlYdVV/JI+2y88fSBI+8MK5QtHri5wTtnTN5VgCagg
         zXK3K/TYIXBZGLizYgRDIaLYBaoqF4GfV1cL6JAWfLnbLTRkuB6+Q41qHEk8mmbncDcR
         1n3WyGfyS8n/EbF1A5BjZbMX/tZ8x9kDBxZovwUPPX9IwBqoBpBPqD8q6/ktjhJvPojW
         hNIByKxWN+8iBjlHiSXX2A3IkYt55iyQvLJ/C0cm97f9HkB1xuJHhYv1LtFq82/6LnhU
         Q1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772567324; x=1773172124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JqmBdm0fSjykfnPzULqjAwjvph/E4EHq0QDrGs2BKB0=;
        b=jd7YxhttVnvV155t2OZs6JBYgcX6HyqACuy/V/oKILd+MvKWGUGVd35od9dlg2nEzh
         9LuwFuX1sgUe26x4jFqAz14qU1aCH2kalnbV74KsQ/RfC87/DvirhXAHPztqQmRd28FN
         Jb4QJZ57JZEqCZJmgegjex2TYsdDOV+sfR+bjYTPh3h6+AkDm+NWEW9QR5K7kHVi9hn5
         96mx+/fPVAL157tyXxhL6VyWBqSmMu1UoV79Uok8ZmKx75heGtxQhC/SWsd/WFcVR2s7
         sYM/CKPc77+/kTfH56Dl1EaVdiv0TReR4cXZeS4Hw5AJnoLt9J6x4XYq3AUpT/isvWIZ
         7nFQ==
X-Forwarded-Encrypted: i=1; AJvYcCW04Ruwnn7UTuoIR9W9a1AaZpRdYAHeXNjjAIx7gW1KupcY/zimGUUnwtUaQWNn0wvRr6JmRDJwBg==@kvack.org
X-Gm-Message-State: AOJu0YyoXLEFJXPBk/Rvgmqez7ibwQiLc3JAXTxOX9FSnPOw7GmIBmO5
	arKuunab0/kKTLbE/BwDaR+50B2Gsh8eMVDg4XwexWp5lA2kwD8FLBHL
X-Gm-Gg: ATEYQzwkX4FTDSpOsW9iHF3IWbyJ3Frq6N2HpYxx3hZS2fETKiy+f0jJqMMZxCLm6zi
	qqJjccBO2PUk1Yjssl5PpysgMxIm5ILT+EbFSF76r3MdDTNf86wPebHV09DSgwVnBRIHhLOeG2R
	V5dpIuc5qrnnJx8Rh6vxfOuRnJT1g+69+O23kLVvSGqjObqm9EjeoKO0yK3KwfQJ4Gxtwy+SswH
	yl/zucOjaO2usPAgNoVlaytQ9cqvlcDFtoL8BcoAKXUOAhN9d6Yn25BVnsiTKGj1kzzvwutZrh7
	If1Og+C7KnBC+3YcJaf2n2GjuE6yoW6IWZqe3hz1fd54eMTfsXWA0aw1sm3XP4J0ThmzYsDXf0x
	jdKOsKMh8InftYbPCk9Hb8yIJgw3WAAqer/pFAlJ9eX050ZHk+g3YTM+3omGOsLYtuGh/GfP4kJ
	Uetl6AfLkXgYpscuPccIyAEnkuQxbz2U5fz4b7w1ORZfzSMbXwt4HFJDKcSq5A3iotUTcfZPbCR
	SRcho+Vr/YN4Ug=
X-Received: by 2002:a05:7022:4181:b0:11b:9386:825c with SMTP id a92af1059eb24-1278fd3d84dmr7745036c88.41.1772567323375;
        Tue, 03 Mar 2026 11:48:43 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-1279e9950cesm9258748c88.7.2026.03.03.11.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:48:42 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RESEND PATCH v7 0/4] Convert x86/mm/pat to generic page table apis
Date: Tue,  3 Mar 2026 11:48:23 -0800
Message-ID: <20260303194828.1406905-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B88920002
X-Stat-Signature: hsteg3dg7hua6hc93spbjg1ch3xptggw
X-Rspam-User: 
X-HE-Tag: 1772567325-266971
X-HE-Meta: U2FsdGVkX1/nsjds0ljysxyzRI0lKr7ct51h+8KJgbsSiCiLQ3yBRSOo+cvX17PHhZ1/Q9r5S97O23iP+uGzshTidPfPXU9DOmzaqkLu5Sa4EMe7/Q1PV7S8ScUdRGGdHTyBPG+h6i/nkot/33Ub5vU4MlGKHdu9BAlRoWzWkaHxDeSEf8Fb1fWUBnMYAgXOrDUunkqxSpVvY+52uQDR+jW2gBJ8j3zLUNb+U7vqx+FF9tWq9Y8omFGQozoxYXSnYofEeVk03+zO4KbNkUbvTllsfT5n56M6BCxQ5rUC3lhj928pXUTqzrpQBPD/uhf3E32Fwgr9SOa/z775ODj5N07c2qsGgHcaBcNMKrdvvY/1Q452PfrxzaTNpk1ImmZQcx39mwaxsK711FoduFOzqEKlHjjR8zz7WkcKpYSzul8JalM+b1suFs8pIgvIwXBQHwQSE33acU2AFkspJ6iVqACfot8SmxsyaBetPw7XEoAzYCHp5K07FSpZ4zTKiq7s100hx8wTCtGWXvwCjPms/fCKf3DM3H3ACEXS/mIT3FTKJzcujKcAKEabVuYI/oU6vBzludR/zgA+TzMk5B3OxiLHA511JKAgnKcatef+h9sBlyO2wsTqpY0wyTHO5rOiFFo2oJ1gu42jmF7l2EKvRNFqrHQ4NDE+c9KsaKF5u7XGFZQgJXsPQ+owwnRhRWH2YlINMvQnEyZbgYrQtZRAV86UhTWHGm/QdaRyek2hpktLeRgI97X1DK4e2jz/0YiO6Pw2bjWqyLQEL6eBmCUYwbm2F4ys20LM5R3rB3S3oJr4U+V76wXpL+ATalw5+SnpUcwqeG44GyZBjOrDiEiSIpN5tTGM8JoFZd7RQlUk5f2fqEbRiyYEW7Vwde2ynzKg3xjB5KzFvWYAtm2pVJUnF/UXsdPVH5DiL1AwPwzLXCgCcBwOXC0wXPam0sGfk9FXxq29y8YVf1AlX4tKs2q
 FFw+Fb02
 qHtyC+X5ItpZ0Gurgh5+Hmhk96oY70oacpyTu71XEkuclYsmSGY3Jb2oQ3UG0NvyAOY1AtyHtjeY8/uPTgSyHLs+BuahNLieORHJL5+nmcb1kI18c5CJHZrL9QrfFnQdJNOEE8dAZPM2uvYDf6ugcV2qZifJe6FSYzV2nW/Oel87vw8V/417eaCRx3i9S1BtAQ27EhYJALKLWyg9svnYTZIJx58A94+ffzlIAVDhoeQXye9qjErnshSpOZWyXaub3v4sXTwuVNoNUHUbDxMR7lAXnTqQdG41Ox4XZSN8sGn8oAIpb1RtIaOfkVueg8I1UR7f6ZDkpvZiW1bqh4ODvA5U4pcw8kxAHj8EvDR/qGwmhxeVf4WQdUGnwXNoLZLttwX2WbsXXWP8ZHP3DHltNEpDq33+Kbf6i0HLQUCRIjXhqYynIK9kfdYpBpBZhOBMjPKcCZIgnEJVs2owcMVmZA0NoBcrEhzxJKjBl/yUmqnz8cUYwOw7J3eMRRXlJYXaCpxyICw/ZHMAcCMLCsiGNrTA8i1A1LrJqeoqTHUsIOoyWa9Ox66oOPi9TCvaA/cX1ciEt9lUk5bEqgl6IfTt+kG8qGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the get_free_pages() allocation sites in set_memory.c with the
appropriate generic pagetable APIs, since the file already calls
pagetable_free() and the mismatch prevents separate allocation of ptdescs
from struct page.

Use the generic pagetable APIs consistently for both allocation and
freeing to simplify and standardize the code.

Enable Matthew’s work to allocate frozen pagetables in the short term[1],
and prepare for a clean split of ptdesc allocations from struct page in
the long term[2].

[1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
[2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/

------

Based on current mm-new. Re-sending because the previous set was split
up for some reason.

v7:
  - Collect some Acks
  - Fix multi-line comment style to match the coding-style
  - Reword all messages using imperative voice (used an LLM for this)
  - CC all people found to have edited nearby lines (through git blame)

v6 link: 
https://lore.kernel.org/linux-mm/20260219020354.321088-1-vishal.moola@gmail.com/

Vishal Moola (Oracle) (4):
  x86/mm/pat: Convert pte code to use page table apis
  x86/mm/pat: Convert pmd code to use page table apis
  x86/mm/pat: Convert populate_pgd() to use page table apis
  x86/mm/pat: Convert split_large_page() to use ptdescs

 arch/x86/mm/pat/set_memory.c | 37 ++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

-- 
2.53.0


