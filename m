Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A99C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4012C6B0088; Fri, 10 Jul 2026 08:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B20C6B008C; Fri, 10 Jul 2026 08:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A17B6B0092; Fri, 10 Jul 2026 08:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC8F6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:15:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87DFC40144
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:15:10 +0000 (UTC)
X-FDA: 84972761580.27.928DEEE
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4DD1312000E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:15:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=Hl28D4Jy;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of daniel@0x0f.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=daniel@0x0f.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783685708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NSF9C7wUF75t6WkNCETBYi+2NyVN+aPspNLqRNlAJLM=;
	b=uF2f5yRsvZ/OjbKRj0zffQSpvVm2ny3fkTSY6Q4MXd60hGYNQMMMhms3JRsVFHAmEblqRz
	S6JpHadfz8qBiKXhyVv5N9GiasgxFV322jky7nRP5i/h0JfFE7PZYs/ZPH8G/tq7cNHydK
	RM/+F9ySTeWjTwQTriBTWM58wZwlC58=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=thingy.jp header.s=google header.b=Hl28D4Jy;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of daniel@0x0f.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=daniel@0x0f.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783685708;
	b=BGBZPcCl8ADMUPujIIUCCsqK/8nFX36x0R8ahGgYFMsYuV3M8Mf7pa5HPKQQllzMcUw1u+
	P7C596fv3U/rvRWLmSJS1treusKAKopRxHIDgVFPtADIkom96vDfQIRaCnKjrV7C3hdrdl
	Kymd/KA7T1qUhvF27Mz1Ho9TRbGAT6s=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84847482584so592148b3a.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thingy.jp; s=google; t=1783685707; x=1784290507; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NSF9C7wUF75t6WkNCETBYi+2NyVN+aPspNLqRNlAJLM=;
        b=Hl28D4Jy1XkqkPrv3rdFBgcL/k06rahh6h9VGyUz7FbFnYdX5/+LfzL3nN8BeIt5u8
         AHpwS+WWynDReh9gr0k2YioQi2dMTpxOv4I+9nThSgSCQRdoM+oOjzUL4czpJBOtwdtK
         JrHpsaSi32HQYB+ae+JU/vEd1uf+wpxZdEumM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783685707; x=1784290507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NSF9C7wUF75t6WkNCETBYi+2NyVN+aPspNLqRNlAJLM=;
        b=SebYqY9zxA75bijmLKbDmDiHt3l3weVQiiZgg5ZD6TwaLekJvbfPuoZBF1zKyrdWFL
         NT6izUKpieJQRLZSEKNj/Oh4EB7htDbp1CyOg4RS2Rrc3GaZh7LSZR9uKBxuVrN3vOts
         zQYjGnVgD0hO0OxlXhGm7EjYDfFBckhPn8YrqBPv6CTRHo2Fz+yxGPLX8NpkvO4ODQ5M
         96Il0JyTfe2AELJtawEzkzBYu3uUVXBaIn+pxTzsr5log4IyEek9KbigE1uCESBzwg3M
         2Oad0QJOL0Bru8zZk4bGnqkkqiSIHKmXzCRiKngBKSUJpQVxRPiJcvnXJkBCpc0zug3N
         EE1Q==
X-Forwarded-Encrypted: i=1; AHgh+RqcA9xn54+2czwlt6znLj5XhStZd+39wJVe0BQB4G4WbfML8DEOWmKe7gqlIY4S7WgDLP9VI9zZzA==@kvack.org
X-Gm-Message-State: AOJu0Yy5+5v8ZqQV0hPhuiWO2gfkIwH2cH8IL2mgBMrTN0sXKGPBaLGv
	dhjAGWIPenlAJPNK1wOraqmpRJRaBAwK3FGd52CVLZ+ECTmmPlenjJ+HZIKkSrgnKno=
X-Gm-Gg: AfdE7cl2jkakKorLRelXysGYkxIrSjkbW3lgWnq6Ex6Wp9PGvQ25LiS38dCh1MVSM8E
	N1TEGT2xnFaZysfqbmlfdKTm0qDXixDK09l3HFJUdfNngh0lIsx340ngUwS52oK2FQ4K42JtMyi
	ql7p/91ipnztEg2lVwv3yNxlVUQ9lllUPBPkd9KtkMoOUI3uoiy1towkSN/cwtKIxcOCw24lsdr
	JPw3LOIDaPvve7jgw+/n0IajtW4zyrL+GLKIgRp/MqTAqzPgmRgOHKZl2ECcwayDrzu5hHjiwvi
	FFX+r1oAdFG6X605VjsFcPpyskoqLwlc6E99QKpT1oiAc2kTAD63sXvuHg2UsaDDTNhs5+85ItK
	2dQEfgt4t91SWc50F+pbKEV/W2L/cTtZ99k6hCYMHB6UtoDXSjy79Jicrt/EXCPb0gATa0o5IzB
	rL+xXrTAQoJhS94yYRCtkbTEGdaQ==
X-Received: by 2002:a05:6a00:218f:b0:848:2ef5:50d9 with SMTP id d2e1a72fcca58-84870ba48d2mr2707433b3a.33.1783685706911;
        Fri, 10 Jul 2026 05:15:06 -0700 (PDT)
Received: from kinako.work.home.arpa ([2400:4162:2428:2ffe:a973:53e4:1a28:8545])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-848593a591asm2600405b3a.26.2026.07.10.05.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 05:15:05 -0700 (PDT)
From: Daniel Palmer <daniel@thingy.jp>
To: kees@kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Daniel Palmer <daniel@thingy.jp>
Subject: [PATCH] binfmt_elf_fdpic: reject PT_LOAD segments with p_filesz > p_memsz
Date: Fri, 10 Jul 2026 21:14:43 +0900
Message-ID: <20260710121443.1059549-1-daniel@thingy.jp>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4DD1312000E
X-Stat-Signature: n4y8idhq4ozarsdifqz1akyxj79isa3i
X-HE-Tag: 1783685708-99450
X-HE-Meta: U2FsdGVkX1973MiNOVprzkUzBJiTY3q2egsIUgD47dVBR/kDgBIb+qWck1P3t8HrAQdh3wwH2tKtLKJKqmQ26b2YAm6yERm7y+tPaTusT0O1GljX4Ww3gNbcgSCFveGFa87aaBYrlNdRNVbh5d0GPBJ5cuN+3ggHsgv15k9h1q37XAhRV8X2+z/NvaDUPxtPxB4NkVRZqnuP/nggrpr50g96dXpdxUdtzjDjsHT9JyIYxkUAf5W4gMVhohJTi90zrTEA/hWdJaJUNwCxMDj5FgfcgNXsj9mMBEZdJOqyhrYDakr3wTZEdXO1nmbuZdoB6rk6c1+Z7u6ZJxZVWEZZLtTFRrF6jskhGXIh/AXW3eTGI/NqTfZjl75WiWvy6BtYUxQLhi8dYzseSuRJLCDOgnqp5kHiZvFfP9QbAge4iZuOKcsoDJ/tii7+VWRo7V1Z3/Pu1ZVp03BYpfENUC7hhzW/T01ijwQsN8QYPJPB2IV1Dc7Ib8gTNDCvNtMI2pHYu1X+8e7RvyvBS5Nn4/65bm97P9wmcH1cxb4zvzSL19gCtKahylu5QC3vX1wvyQiEfyYBWqlN851ON44Cv/IFiYik4QB89hwbF67con6qr0eZQIdmY1lj84ZHSww0C9bzq/KekFX9clGjDn3xAU4ZV05tKYRZKb8+VO9jXA2GUrtVBTBSxiRUsKlih9eGxUtbX/hCu4sdcgqdBND5T7k0yjApW5iptTXkBr+eYyM8+YwPTuJ78KvlRqv1Dbxv4HvObGg61IXYSY+N7Y7IlVOGthIOnWk/OvjCtYsKKXsyVFUlOvjHZKCEbe1H7NQf5DR+gJ0aAMgsebouRYWJN1LLLSQ+yBSImm/Misv1EpzzwimSggxKKCzx9JJ4lkFwgapGNfpRtnXWumTZ0futVKKikQvYRf9FZoFsss09MU82d6cO2fGkkiLFIHY0evsa8Ff7HSE6WzybiT7OvtjIvvX
 1aYpBvhN
 rtZ1UzRdKFek1w2H2h6ZUZMgtFsWKIOqARIAtCwEr1XflcbIWiyYDNMYcMFwB1N/Pmyg5rnb9tDRHR1tQd1KHz+P7uCXfcW/qR5gv4p7WB0WldbeYpGugjvy3c07UZVOwK+crUkgqInE22AGrOhcRJIgu9t+uuuHXWvaXC5wP2Kw9xOnL17Fwdw40TZEG6xLrl8qQ2LwVXuA+kkIcFTVJjHYzCYSMvZasH8RJiUb3mACRx9hrCiH1OC9+gayzqe9+Xp8DdwYHRvCtmnIXrKLfqXNIt74DEGjDLB0pP3kVglaur8e64zR5Dpi+sZ0p+ok+sTsZykI1lCxQBfTqSLx5dXToREbQvrdvrlYNPTZs4s/9eU6xxXwPzFONlFJNWvRSmZ80ewL1yYg9rTzqhXn+NkRIb1SIT46rkw5M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both fdpic loaders assume every PT_LOAD segment satisfies
p_filesz <= p_memsz, but this is never validated after the program
headers are read.

A malformed ELF with p_filesz > p_memsz misbehaves in both paths:

  - elf_fdpic_map_file_constdisp_on_uclinux() sizes its single
    anonymous mapping from p_memsz, then read_code()s p_filesz bytes
    into each segment, overrunning the reserved space.

  - elf_fdpic_map_file_by_direct_mmap() computes
    excess = p_memsz - p_filesz as an unsigned value, which underflows
    and drives an oversized anonymous mapping / clear_user().

Validate the invariant once in elf_fdpic_fetch_phdrs(), which is the
common path for both the executable and the interpreter, so every
loader is covered. Do it in a dedicated loop rather than the existing
stack-size loop, which breaks early on PT_GNU_STACK and could skip
later PT_LOAD segments.

Link: https://github.com/fifteenhex/fdpicloaderbug_20260710 # reproducer
Assisted-by: Claude:claude-fable-5 # Discovery of bug, review/rework of patch, reproducer
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daniel Palmer <daniel@thingy.jp>
---
Backstory:

When I got access to fable again I thought I'd let it
recheck all of the nommu related files to see if there were any
horrible bugs.

This is 1 of about 3 bugs that seem legit.

fable did most of the hard work here so I'm not going to claim
to have found this bug. I wrote an initial patch and fable told
me to put the check in a different place to cover another issue
and rewrote the commit message. It knows best. :)

I have checked in my m68k nommu environment that this bug is
valid and allows a bad ELF to corrupt memory using a reproducer
fable helped create. Link is in the commit message. I also checked
this fixes blocks a bad ELF from loading.

 fs/binfmt_elf_fdpic.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 7e3108489c83..69aa0e04543b 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -157,6 +157,22 @@ static int elf_fdpic_fetch_phdrs(struct elf_fdpic_params *params,
 	if (unlikely(retval != size))
 		return retval < 0 ? retval : -ENOEXEC;
 
+	/* reject any PT_LOAD segment that claims to hold more data in the file
+	 * than it reserves in memory; the loaders below assume
+	 * p_filesz <= p_memsz and overrun/underflow their size arithmetic
+	 * otherwise
+	 */
+	phdr = params->phdrs;
+	for (loop = 0; loop < params->hdr.e_phnum; loop++, phdr++) {
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		if (phdr->p_filesz > phdr->p_memsz) {
+			kdebug("Bad segment %d: p_filesz > p_memsz", loop);
+			return -ENOEXEC;
+		}
+	}
+
 	/* determine stack size for this binary */
 	phdr = params->phdrs;
 	for (loop = 0; loop < params->hdr.e_phnum; loop++, phdr++) {
-- 
2.53.0


