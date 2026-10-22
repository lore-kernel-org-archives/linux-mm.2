Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A42F606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 04:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=RojoLMOq
Received: by kanga.kvack.org (Postfix)
	id A44826B0297; Thu, 22 Oct 2026 00:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5866B0298; Thu, 22 Oct 2026 00:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4B46B029B; Thu, 22 Oct 2026 00:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 637856B0297
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:17:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDAB11A071F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:17:15 +0000 (UTC)
X-FDA: 85348952430.20.7394FE4
Received: from mail-yx2-f5.google.com (mail-yx2-f5.google.com [74.125.224.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2212440005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:17:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RojoLMOq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792642634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Q1fp46m+qK2xLV1/Qc8OaB9RamwK6SIGSSLtC20+zk=;
	b=jjvnjHOyymo2dsZSULLjzNVz9i3yfzcuPotypdia5dIxo6CZaHSsKL1TUN0fPrQKM7sX6E
	UY9ZutgOeGQWLDq7CZt5rl1vtOtiDNeUabgDFC2u0puyuiFS8Do1NmhhSoexfDyRBHkfvR
	Ll5pxO85BZ0mqf8dpEWOkQmp2/ue1IE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RojoLMOq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792642634;
	b=8YcuwYQRm5k07Gj6fLLYzaPp7q3yEzyXPf2Zw5jxWaYkfuwKLRcfW4XBs21UYA6GPbcsIL
	PLC7s+p4W/hs7akBo9zuDLRYWP6I6ruoI5PNXkln9ddQRx/ka9JRQXEfa7qh4UYteDL4ZY
	iupC46Vdt5SmecsN+yEAneCe2Xed3ao=
Received: by mail-yx2-f5.google.com with SMTP id 956f58d0204a3-679b519c952so493492d50.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792642633; x=1793247433; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1Q1fp46m+qK2xLV1/Qc8OaB9RamwK6SIGSSLtC20+zk=;
        b=RojoLMOq/XyFXV5GKfqdRKT4ephRcvFzzUO80ut+L+M31xGSi2Uq42mBU4bVUWBv6Q
         uqoK+L68teSK5ZZS7qPPaL5E0TBv7n2GB17GY+MHZNasRF5iJEtuHjWdiTDFPdciN/Vo
         zr96twR7P7E9ltZyjKIFOAg8pVX6QU19wS45U8QCqpdo8C77ZT4mmQTyDEg/Io3PBdvo
         HA8nZCimjacRjQ5oyTqW0QLw6zVZB+v2vtnLvSYgVtuUYyijG0WcEHn3kpNSOJI5Lyd3
         cgOM6LM/2FYPXXS5HPOx8MOdpNnqHbw3XdqDtF8eobwzBY0x0GvPXr2KWoWndEbbUJ2g
         ZnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792642633; x=1793247433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1Q1fp46m+qK2xLV1/Qc8OaB9RamwK6SIGSSLtC20+zk=;
        b=myVsPphcKOb8gdgyhXUTwpoPB95lXplAu0m32vjhGkLTHThPXHMI6rquyHP78P+PoR
         PCYMB6DdjJ6TSx4pMGUrblYNQU25Lg27P0qrOFqTTEuMWrw71KvbBUJJzSWOBhngfbAk
         GFWXmirdapnveGhNDiVG0Zeqqdcoz/aHqYAnlHzpnNj2BIW9KBQ4QrlZWvZUpiidDCXX
         I9b871bl2lESPbfFBRiR1hLPh+jhjXnBHMsb4ggiuVvEXH1iZITx6oBWClfkalS9wfaG
         M7b5WWRDo3IcYFJ4oLY2ZHhik0YoYCN9v/e7BD4ktX6BQO3dj7M0j2+DMBTs2+vTaMPK
         W3iw==
X-Forwarded-Encrypted: i=1; AKwUvBw3silewdQ7V6CI7DT4uxqBqWB/b3iDnvGmjgCxsvNKjIZ6fT8b5aVawRcQtVi9RIgSMgdxNHKKUA==@kvack.org
X-Gm-Message-State: AFq9FYKzc1RtKGvN8E2Wy0FkBxNhKhStBoOaLyAZY0a728l5BDHqgDBI
	0zuHxV3wSqcml0+ankA4h63u5+bC1BAHvlL2JDHF2lOaQWIa2hjUDkY=
X-Gm-Gg: AYBFou0xhb1nl97qfXbkEbuwnfaduq2pW3kFP5jP6vBNwq4x9KJQAPrPQuOSL9onerP
	4NQ+pFxEjeu5k6Yzvd4tGUc+Z7a9UR+r4Gq4zwdRi9mrJUyfzLHSTZREwXrEDrGFeRZltxH0Qkn
	7fpHb5qICrWM7uRQ4fgHE6iQOMx+JORKIROLcq0Z9mn11iUcOfYVUQArm14iXFzUCcgcPu8mnf6
	vPYt/mUZ21wMGVvD0EfYT1RTAzYRBOdWS0jjz3QBWKk2StM1SmkN5jGgVMXQWytVv6WW9bhPXa5
	N/RHzTcZQOmzbOR5YOJHGvSs/9+jomN3A+fJpdWtyGWMsNZGQQku8DhE0KnejMrYXFMPlwPgZMw
	LaLSgwP0vo6nKlp2zrkh9fzhwUTsQjvZq8nktCBIO1EIJQHxIH04HZ0GKCH2kRW8JZ/T1xPJJl0
	7nIYlPqq0iUziy0ktECohPdF2JwiJacj1Y5LUO1e4t1etsQ1ftmXmOonGZDLWHsJuTDyeYIvjoP
	I6jjIIBTPoNmk541P5Qe9q1d0IcDqypcdoaxgm6znAF3tdyYpQQC9J5j075aMYq5pcsLHvVpGcH
	/KDb1MwdqWzjU84z49lzmY0=
X-Received: by 2002:a05:690c:c511:b0:8b0:a7d5:8595 with SMTP id 00721157ae682-8b133fbf240mr21699977b3.51.1792642633190;
        Wed, 21 Oct 2026 21:17:13 -0700 (PDT)
Received: from localhost.localdomain ([2600:1700:4577:1050:cde2:63f1:eb1b:b344])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b13019e289sm21329957b3.44.2026.10.21.21.17.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 21:17:12 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org
Cc: corbet@lwn.net,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	sashiko-bot@kernel.org,
	skhan@linuxfoundation.org,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Wed, 21 Oct 2026 21:17:08 -0700
Message-ID: <20261022041708.2690-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261018200808.379209-1-sj@kernel.org>
References: <20261018200808.379209-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2212440005
X-Stat-Signature: d4mat35j7yqyo91u44gwrp7kixhihz4b
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792642633-328894
X-HE-Meta: U2FsdGVkX1+hXZ7hbTJqbY/OLI2ynW8yc+SNzUgGmaEP8Ksp7F3b0vLISdGUYvCOs1nUotq/89j9VkMuy0iJRdsUW8xc7QbLwnpcTKtfhUWbcD8q4ZxqHASG/hff4y0PlHx6+HYuVtccItQZ2Xxny6PzGebEK/BtryUQDiN3QTrZYBn2sfdkEvARq9ZLVeVyDA65R4avkgioeHey98cl+mavwmysSIQYDOAfsUGlFPWOcn4WD20zJtyvWsClhUoF7Ob8EdvV9tZiCHEuiBiYBzhO+e4+hDxUZmurt+L8/dtEwW7r7QT2f/vthjv8bVmpvRqik2PbsyY8hYKKhTYjUYJ41wuGjjLp1/SqGXiZhDCrmcySlufpFvldDFarfMrs6EEOqKhb+Jgj+OK5lwl11IU1xB1TwBmCzeWXuzIvpXNl5yOe1BrRmGmBqENRbrmRtHMv3ts7X9V0VeXu7ozBurWPjPpD8WAfw4zVrKJ29FqRMK3nvljm1sHbnBEZtBBRM7Z9FUr1wfVLxXJmJ0QTRd48PC5Bl1sCy/j9Pd0PtjFd4XN/PfDVYHVtcDfdJgoVsKEwFbOTiLHMJPUsMB9Vulojm3B7VInU00iuwozqAQyv6pBszwXRpcRZi3a/EnlUB9w94RhkUac3wPOiI+G/mSWX9JN9SwYHbFkoQgdBGZi9qxJTzd93p5to3QDMG3S4M+0u16d4wpMPUjdfdIt11waKP0OLPqkg5JQni++M2ccdvSkJgcEvzgMXSm5BlCB8jitHed/kMaVlpRsKd7nl10HtdLBsPhpmj/DORc0dJkMakzSg8T4OV1tXcgW0DRwfeKNFiP2mtVxiduMIuoUDgHDRydDqwQbKDmrHb2rclTK5Rrq36roETVGPbCcU1oxTEUCilCAnQjWEZ2hmqRpV1Bchc/sp2x7nDmU1rwk/J4jHL+I44C8Eij21he3FywmFMPS1xQ+wUJDQr1kT0RE
 JNJQiUrC
 yFiz5Vs1aJath+GB8xcRcJUxXfkAqS0yw7Hqh1DAgfODsHra9sXnm2XkKwefNBV99vKHeN3tYnqVjfqXtLBjoQQw5tLTHjFSDGRk9rmxpvJkzxeo1LqXFKqVTBJkNp0PFlP8clIo4kDB+8nxpLrC/fHX37a2e9PgdUvmjE3zWdKJAc9fuprECgonV5prj7S9469wlMPhOWFEUvFrUzxR7KXi9R4ZBr/P+SnJ8HaQrKpexugdpKPNEvbDcuhwzAANA4GT+stEzQ9BtlEgu/yEDMAFtFLRLpQmJtbZYMbLquApDbqt52Oy30NkMgD8aAUH/YO6SC7vgM5Bzhatzrr7khUy+xuk7DBmE7Xbw6diPlPACOPRgAwbgzQCT1wBH17aUtKNv72M8KVdRN+M8LvioD+08/nU9+5TpgZF56vPmXSBf7Ddd3IJNTa5/inrTpxyfTbuEnzstXyU/RKxaYO7Vgl0cPwSucUxxo9+iGkq00YwIoOYwAtIbPCdVX+beSZgdBGusICaCXyeFqUR+RZFfD77Gog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sun, 18 Oct 2026 13:08:07 -0700 SJ Park <sj@kernel.org> wrote:

> Good question.  damon_report_attr() will save the register contents and pid
> into report, too.  And the probe in kdamond context will decode the instruction
> and get the memory address.  For physical address, it will also do the page
> table walk of the process of the pid.

I measured what the samples carry, to see how far decode would go.

On AMD, cpu-cycles:p is IBS Op, and its memory-op samples carry a
hardware data address.  On Intel (Granite Rapids), cycles samples carry
no data address at all; the PEBS memory events
(MEM_INST_RETIRED.ALL_LOADS/ALL_STORES) do.

Share of samples with an address inside the 2 GiB test buffer (random
loads and stores; perf record -d; one run per event):

  Xeon 6960P   cycles:p / cycles:pp / :ppp     0 %
  Xeon 6960P   mem_inst_retired.*:pp          100 %
  EPYC 9555P   cycles:p, cycles:pp, ibs_op//  ~21 % of all samples
                                              (the memory-op ones)

How often the saved AX holds the target address when AX is the base
register (perf record -d --intr-regs=AX; store to (%rax) vs
pointer-chase load mov (%rax), %rax):

  Xeon 6960P   store loop 100 %    pointer-chase loop 0 %
  EPYC 9555P   store loop   0 %    pointer-chase loop 0 %

PEBS saves registers just after the instruction retires, so a load that
overwrites its base register defeats decode.  IBS saves no general
registers (perf reports the registers at the NMI), so decode is not
reliable on AMD.  Decode in kdamond must also survive exec, munmap, exit
and pid reuse.  These are synthetic loops chosen to separate the cases;
how often real code hits the failing case is not measured.

For the physical address, taking it at sample time, while the task is
current, avoids walking a page table that may have changed by the time
kdamond runs.  IBS supplies it when valid; on Intel the producer can
call perf_prepare_sample() in the overflow NMI to do the walk.

So the suggestion is for the first report type to use the PMU-captured
address and load/store flag (AMD cpu-cycles:p; on Intel, the PEBS
memory events, which moves them into milestone 2).  Your call, of
course.

Thanks,
Ravi

