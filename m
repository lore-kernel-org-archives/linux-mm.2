Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2387606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 18:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=JXFLkRpV
Received: by kanga.kvack.org (Postfix)
	id EB8566B0BC7; Fri, 23 Oct 2026 14:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41AD6B0BC8; Fri, 23 Oct 2026 14:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0AE56B0BC9; Fri, 23 Oct 2026 14:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67C576B0BC7
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:13:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8B03160204
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:13:10 +0000 (UTC)
X-FDA: 85354687740.30.79B5F5A
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 18340160006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:13:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=cs.unc.edu header.s=google header.b=JXFLkRpV;
	dmarc=pass (policy=quarantine) header.from=cs.unc.edu;
	spf=pass (imf08.hostedemail.com: domain of hengyul@cs.unc.edu designates 74.125.224.51 as permitted sender) smtp.mailfrom=hengyul@cs.unc.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792779189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4FoCKLxbV8UZ17k7ny+PDZ4wC8nV8QJxctUdFkqIFLA=;
	b=GHhfn2ZQS3Ko6+r+Vf+Flo4CtNhGYH7Q5p0H+iTBsSa70gWEA+66j+NFChQOGP+sZBSY7V
	o697GB2P0PIjPXW1inaJIP06E+8FNfx44j0+tysz/CWScdI4TtJNlQCAwI8N/pnuflOIUt
	S2p15jGX/fP5UXiQjwlxOFdJbKAP5c8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=cs.unc.edu header.s=google header.b=JXFLkRpV;
	dmarc=pass (policy=quarantine) header.from=cs.unc.edu;
	spf=pass (imf08.hostedemail.com: domain of hengyul@cs.unc.edu designates 74.125.224.51 as permitted sender) smtp.mailfrom=hengyul@cs.unc.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792779189;
	b=rRwdjB1e4J5z3slJvR/dYFdw18z/qIrdwcDl/SYMZyVy4pbzIf36YDQOBfe/tNNgC3Cp6F
	bomPu1U1p4kew3gzinhOKaYjCTVUl8/HZDFo3SwUXB5v+QG0ZfiDq5vxamLsZAL7tRO0in
	3mTictExs2485TIV7j43tvD6ZOOBBnE=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-679965fb848so1224155d50.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1792779188; x=1793383988; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4FoCKLxbV8UZ17k7ny+PDZ4wC8nV8QJxctUdFkqIFLA=;
        b=JXFLkRpVmTPz+vKySpKeK4nvB69Kzu5aFa+Z2bgvU5m6u/1vmTMWhmU9CMDrTRNuBU
         4RY2ZhrGFZQPGReNLGHo1wdJs4KvOfr7VJmBe/84DScbuBVzpXxPuVyEsxZBCxd6w4QT
         fuHSF1Z+GH57iKX5sUzEo7GmoHqt4Ifo5CiNgqDBvjmbPS8kqQ4jN1A2PlqweSQhGurP
         8tMR17Xrgy33/Na4wgRz2/+S+2PjMUmi9CMNa1WcfPcm8pe6UVvKnkUiedqRlS+kD4t6
         2M/tfJ1cEperFDeZ/Pf1ilsH1lW3D/lAK83PbLiV6a280DpAIphDsA4d220E5Pozbvxm
         6hAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792779188; x=1793383988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4FoCKLxbV8UZ17k7ny+PDZ4wC8nV8QJxctUdFkqIFLA=;
        b=r8HPU+t/Fk4011xubfxrGiqUR6NRFrOCQWBULQ0ZWJR+ydHY1vhKxY0z4MBTBV1Vyo
         XbbNlcPQBpsC/kcyUxVidGCQWL4IyF8cq5bKbUEMtl7IzaoaMdoZAWo8U1WXvQsfwEmx
         CIWw83H121MpN/JzYxyb1Ms7GN9ZIZrQ6b32KUNF7vBNGlk4H1igSGP3QUTY57DjoqIv
         wWbxubicz2ip4SroZ3chTT8GLpL/YNnc+KAMq2mF01WCOr6cl6qYYwqu8PdBr9lub3jb
         k22FdN5sbxSL/vtYanBz9WiubVVBnB0loT8lk9gWTpjqdkzUUB1I4eh/3KpQCgR+pi5B
         n5lw==
X-Forwarded-Encrypted: i=1; AKwUvBxfIwXLmzTDJsmjxE0dKSfe0fm7icKd9tfaZE9GHhcWSFbEg5qPpID6pbvrcywzDM2ulhzTYQxlEA==@kvack.org
X-Gm-Message-State: AFq9FYJbDSfzqp/kCLS97Vs1bey3EwK1bgs1Au1bvwjoYhDqtcCR2TdJ
	gedpvE8UTOJttdDSY3c0dXb0T5S3oGuWMpbUtvf+QtZL1xbNx6BdlY3jHkB7InU7Eg==
X-Gm-Gg: AYBFou0nWHGkYsJmY4SSLY1/JTML4WJ/v3AQ/uFf6vlsCxEeLwHVZxXDC5g85L/g5//
	daDnmPne1gktCiWqVrG0n0P+G0UibEQ0h0WtolYtl0sgkc6LZmtHE4mVQ5iRcPP8XGTN+IV3Nea
	2ugUL+71qASxpJnyhIf16Q/l4B8BkM2TDcmzu/vj8vKRHkfjLlUBB1V5A7MjPh9lCRLyTdx3cqT
	SJC3qnQus+Wltdk5e2zdWcZfHWwefMuMCFBPHWAmTMudak20XBYuSn4JLIq39ZltEvpsLY3sIrE
	mywzaX4XDc4Han3fnU5bKeWeWSc96HAz4xTTAdylnWC7AgqJCKckYjH+O4+ZtdqpNUscN52BozH
	kbh5kxgIQoX+55IVrE0C16u1PYsPdASxFdaSNH2B6B7BGoCMWb+TnpT4bHtiaOa/oOEVmCiQAXG
	YnONaAmWKm+MkGOuddg4SzpbUHZtHbRHjPh0Bz3dqixHWXye7mmZAf/ioo4/fDblC1s7RKU4Xfm
	gA5f00ccL6TAYvWO9BlDLMkcTU34UflXJ14aNbAQm4nMw1jZYhMXueo4otvqQDThHsM/AhoEfxH
	xx2Xc+B3k9riSuqVV7pkRE4=
X-Received: by 2002:a05:690e:43c6:b0:676:8cc2:bee5 with SMTP id 956f58d0204a3-67a35c97da1mr1062555d50.85.1792779187892;
        Fri, 23 Oct 2026 11:13:07 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a4263bed4sm341889d50.0.2026.10.23.11.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 11:13:07 -0700 (PDT)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	usama.anjum@arm.com,
	avagin@gmail.com,
	mirq-linux@rere.qmqm.pl,
	arnd@arndb.de,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls
Date: Fri, 23 Oct 2026 14:13:00 -0400
Message-ID: <20261023181300.3366487-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18340160006
X-Stat-Signature: 659mf38eyk89n4hxwyc3jur9a97dyfxz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792779188-673596
X-HE-Meta: U2FsdGVkX194c3mAw5eO4b3wISSHM8AEZTHdAT4GHuY0hzqWaAv9mHBcja8/2+LQcUGHatPTB9yz8HvKELFWKaAd2nTSHrDhSN2Daut3PoVNKtKcPrG/V05Tm1VfPpgiQxP+lXgr1qnISzdDNTLP4/U8bTXqMx25OCjNJnJtHcZGJPQxMRVw43BYJZ7n9T5YEn1eiWhLY0mF9UMuWyuwyxNtpmUWQfvyhCK9TfthFtnzr+s1thIxNyl+dYDQZbtv0jIYJPYHwoX1UDgdcHwfUMqMIJgyijccua/gfEDjYaJ/EqTABy8fih4GyatLvJ2rnWCV5PXeUC3OI7II8fmUyAo+/5UZXgTk5yJ12vYKid4vgx0IqWcLb7F3zrl1IhU0NSUY7Atp18NcfxMqtIAyAEeoF/2SAn8+t6pWuc3aTcn4JHbRWxg4p1aaHTlsHJcT1SNGRQrGP+xMPdvmIL915IYEDOmVBA0EkBSO+d8pWMxo3Q/tEm1X3OYHyNmUh7PUrV9Jl+vkOYIFswlj9btMyGurN62wzlx0qn+kk8daroAbMxkX5PZfdnXafEkoHmlz03Qb7gUpktpgE30xpNxpf1YfWVNYijHoWjYcbwUuDjpwFfziwyUUlQszopz3Yo1rQ2FvhSRbNlnh+dnc3X1sGHNKl5McqTe/PFKdNcphVzB+cCwrdvFezxsryhtO4wXu8reyCqudfYpsXzXigeKUwAmYSh5QhyyuTp3wP2Xw/+lYspHwMEaTti6I7rvBzGim5GaRfXKexXeVDsswjLdruimIPSfDll1A5LMGS4BkgNhPtsGZiDl8a9LdNAqNYWw4UrU7gkCEG1SP4ouwbinYbkuLGZT7qst+McjrvhrFeigOpDvQ+uZVovNgRkEFkrMs3E3cAuexr5SRWnNjJXHO6LNTDaElmHl+5LyBuV8FA2RP3shcwNhqvcqyneEL5PvITyOJrV1BFmDwTbYYiof
 vfkr20hk
 XL3ed8nRMeq706r/O/aarI3LaInJzn+5KzdjgiEukF3WKiDz38kzUNQaCZH35tMS9SGVimYSI/g2AUvUt/IGmoaS14o1aiCTeuhe0NXeFD45d3A0u9JZNYvPElJFeANPqKzelgQhtTo4pq1zBso5EizWDjWTbx/dv/T0QO3WpOUbDafMP8xBma36bxKrX8veTMXVuMUEmgjIQ5A78fP5svH4Fdfq2CxasAPIR1OpsD31Slno4N08gR4mwsa8rWQhDuSm8pcwrirX+RI/jfrKsLvN0Fs8OpzkPv2BsxhZPYUSjWKC+Hk9ZMFZ4TGJrOAt59/u3VDf7aj94NKHFe0RdexGxbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and
optionally clear info about PTEs") made do_pagemap_cmd() the ioctl
handler of /proc/<pid>/pagemap.

However, do_pagemap_cmd() returns -EINVAL for every command other than
PAGEMAP_SCAN. Before that commit, pagemap had no ioctl handler, and
the VFS returned -ENOTTY for these commands. As of now, they fail with
EINVAL, so tcgetattr() and isatty() on pagemap report EINVAL instead
of ENOTTY.

The issue can be reproduced with a simple C program:

    #include <fcntl.h>
    #include <stdio.h>
    #include <termios.h>

    int main(void)
    {
            struct termios t;
            int fd = open("/proc/self/pagemap", O_RDONLY);

            if (tcgetattr(fd, &t) < 0)
                    perror("tcgetattr");
            return 0;
    }

Before that commit, the result is:

    tcgetattr: Inappropriate ioctl for device

After that commit, the result is:

    tcgetattr: Invalid argument

This patch will return -ENOIOCTLCMD for unknown commands, as
procfs_procmap_ioctl() in the same file does, so that the VFS turns it
into -ENOTTY.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
Unknown commands should fail with ENOTTY: Documentation/driver-api/
ioctl.rst says so and calls -EINVAL wrong, and POSIX requires
tcgetattr() to fail with ENOTTY on a file that is not a terminal.

I found no user space that relies on EINVAL here: Wine and the mm and
kvm selftests only use PAGEMAP_SCAN on pagemap, whose results do not
change, and CRIU and LTP only read the file.

 fs/proc/task_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5c54aebe2118..92b275dc0d59 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3307,7 +3307,7 @@ static long do_pagemap_cmd(struct file *file, unsigned int cmd,
 		return do_pagemap_scan(mm, arg);
 
 	default:
-		return -EINVAL;
+		return -ENOIOCTLCMD;
 	}
 }
 

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.53.0


