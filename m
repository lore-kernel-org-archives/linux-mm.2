Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC30606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=U4jtH3uQ
Received: by kanga.kvack.org (Postfix)
	id 5F5F46B0BD8; Fri, 23 Oct 2026 15:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CBF56B0BDA; Fri, 23 Oct 2026 15:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1886B0BDB; Fri, 23 Oct 2026 15:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29D4F6B0BD8
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:48:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95DDC1401FE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:48:53 +0000 (UTC)
X-FDA: 85354928946.23.E822BAC
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2D57C0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:48:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U4jtH3uQ;
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792784931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jcX7+w+8vvOIu+l1j/b12ERTdZM/yIWf3ikT9C1KkwE=;
	b=6BHc+L+6kfTFZvkJkd3jGAOlV+hYG0ITeBbB9z7RVJFecfs6hvvBL/2yEKP6q1NTVXeoDH
	z7AvXP8IwvhGn6r6EQk6MiQjBrraw0Vm49C5S/JqpZYveQCF5Ae86PogfPWvgoiyCTXTxQ
	i1oFPKllZvPXoyTvW0UEJvQAT6otSAw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792784931;
	b=636csSHmn4rhhVKXR6JIpwK2ZRfesZcg+tArHzHbNAfKNtpfvp/BhUziC/46kfHDVReSfZ
	N5Gx45nvmnrFT+9qoTguaF3Rrj1FEbFbnxOLgFbifF8Te96XsWm+GVwVaYX8qIC1SM+ojm
	xZUCHiIituzPa1umT/I8CJMFo+JalJA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U4jtH3uQ;
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-3535a54c09bso1210224eec.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792784930; x=1793389730; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jcX7+w+8vvOIu+l1j/b12ERTdZM/yIWf3ikT9C1KkwE=;
        b=U4jtH3uQG2KHflz/6qjXkJm1ikeRBvTNVYNgdaQ7PlBetKFpQvbH5VF9Yv+oTC65cf
         XLoJnOexLft++e6R2+ORdVNyQpfRot9TRGIPi8jTLJBaXlexi4mcDtLSJ3DBM9b50MFB
         I2mSWlw2gi28A8PrnRhKYLcza3C9o/xdoOS0ah/K0JtJxNwPpchI2BQ/c8PTO5zFXHk5
         H1Z6jRq2ywB49FjUTPH65Cbt6wyBuK5HguWuRgCv+ZfUiXnQgbxWFeEyjycC04bAJsrV
         WkhJAXC1jmYxnBurV3o/NDRfrmL0wISNsBRDzmZpnLeViVVuZwQwQA+EPKKs9NG6iiU1
         6cvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792784930; x=1793389730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jcX7+w+8vvOIu+l1j/b12ERTdZM/yIWf3ikT9C1KkwE=;
        b=tEPE34Yi2apXDr2wuo/+EPtR5MjAm6LwFSZg1ji2qBONzkZdVgcQrMoIstD93kLxNd
         Y6nWFte278OmhUQ+H0f6YG2NklFCAq1Vdcp4hdZfWIRsvcq8RLaENFiOi1Knc3d2fAJM
         UyVhW80s7DtU9UEX0/HJpnt18ts5AaAMskh4DFiTaiwjk5vWaQIVaiVSknJiyfkX3Cza
         v7Q63ISfMukwelUP48cDA6jYpHV+N80md//C8MvGirTErpm8VkFoj5WVXqgfEw5NHsLi
         KlMz04dZsnvBV0XjnLCMVuPjlChhDbIIcz2zcxcxfeeIcz0+D77iki0JQkVr/si2gNvg
         xjww==
X-Forwarded-Encrypted: i=1; AKwUvBzk7sgjlZwNZY4UUoS/li1KEf49CV51R+EIbm7836A9pbnW5XPgDnW3tyZt4sCn4bexjRkj2sWLVg==@kvack.org
X-Gm-Message-State: AFq9FYIO+UvAJPODZ+CpiQmOJXj4QCTJvjJj7+uVrTDy3h0K8yL0ZmS1
	PnHJq+o8ir+n/r0gABYx+JyE4kmTHPdx8mMmt815sX9t2hgvjOAnifk=
X-Gm-Gg: AYBFou24FsaKU7KoS69gVQh1d4N40Db9GE5vRNh/+S5QeNYoXfNTe2l6WzLMK1nX95i
	iHzVbD49FPcRTLyzMEd7o3JNBz7jR9noFlXCEcordfTeGzZfKawl4VTj6+zA3elIAJl1JRblD7u
	WZZRqhwiiBam2C2rGR0+3M33YMF4KhMPN66k2WMJuYIm1ovmUikHcPyJkDDGMBcjIUJfzNP6Dxt
	eXW7vGopd+waXSlglOjxNeHFAOBHe8h4EYmGLXoNaCRf2qU8cTjyasrhPCvbcm2hJtMr3TyIQvX
	PluNFXw0kcJaWX16uv9N3XbVds2fIc+AZLBKYmDHvk9rkZ4hbko2jqUpw15kYAdax5mmipMVlcI
	FqoPAqQ5EIRxgr8hfmsT4SB9rqACP0uj3dh0hDoajChRGGIE1GTK7Ijy3FooL6+oSC4g9le6T/W
	dQbUDr63SRVkTll70I7rR5RJmw7YGIsAwBYTM6RfO0k84D2BnXbZn7VlppCWOx1Xze9ppp5zIC5
	X4iR8SPft0HCyw+qPTj7Al4G6n6z4XXbPCwMgMqpOWILYrXB8wEJBJkP9ZJ18FB7TnrIRQz3gWd
	5V8IRa5Zuo+e
X-Received: by 2002:a05:701b:4248:20b0:183:c7c1:879 with SMTP id a92af1059eb24-1992900a091mr110659c88.1.1792784930103;
        Fri, 23 Oct 2026 12:48:50 -0700 (PDT)
Received: from localhost.localdomain ([137.201.204.53])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19894d5a10csm657043c88.1.2026.10.23.12.48.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Oct 2026 12:48:49 -0700 (PDT)
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
Date: Fri, 23 Oct 2026 12:48:48 -0700
Message-ID: <20261023194848.2449-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261022053227.90608-1-sj@kernel.org>
References: <20261017195747.89961-1-sj@kernel.org> <sashiko-outbox-176355@kernel.org> <20261018200808.379209-1-sj@kernel.org> <20261022041708.2690-1-ravis.opensrc@gmail.com> <20261022053227.90608-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2D57C0003
X-Stat-Signature: k44ccokxjdhyrz3776gcraubff9madad
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792784931-249312
X-HE-Meta: U2FsdGVkX1/FSo18H54E5CguCvR0355Y+o2Wip78vjWayaa5zdBiffKqDr1/WMHj46LRtgsDZu0Ctsc+egR/0SRMmU+IMtI6B3+W8pUXo4Ozj2Ex1agtfS+fjktnlSvPQVa7ahTlbtbWcaw9MFgfGcEvesWjRfJJMouBCLdC5GgOA0nkMhRY9UAiJ9ImhA4lA0v9LplAT0ElC+cbMdFZhkGZkHK4guWX3pvvQ9036b07wTKvBcv3jJoFRSUv9xTlyJ3kphPYRWI6DzN2oJnDMsOVHerFg4ukSYKRzksKasX8/VYoR3MrG30Ytg0Wk7uFG1i1QmFsZXvDBqlsrJbb7Pl3B9ULvgkLcH8DxMBDJdesTpLuCjcu+czjP1OKJ5IcnI+LGDf9OEE3GMsHmMrUYdcFk9Y+bnvD61nAYUVCFXFeMW1AIcrThpXGEvaaq5EZ5OQ9GAG+OZekJsfvbuLU6UXhfFxT1FMD9/VcUOtI+VJmqX7qcLkOP+PWic6pA2hl8BdqgGBduJHQsohDrGlvtAgxF0qpIx61coEFAHGhjx/cWOgrJI5ZFO3Bit8erdLLEH0hf0EKRrsJJXpAxqL9ZTHnY2gqQTHfmnf35Py6z7s0Q6Y8fAohVR+DEWeBP/7YlmuDMGnST/X60rrm8nEdR+k6dvMDwPnO2MMFrRNpF4M0TKJEqQvTnmvsVhFfGKlVGw0FEJsdepxNsNbLt27LkcywaGZU+ljLy8DxmY7W6kjJ3r4VHbmc+iaWvgShlMD/LSc7gYWKOmYxy462ORcW/giV67sJcHYDh7LjFhumgKwIOMlB/jn70aCwk/BwpC9LwvuFEpJVsl9l5DjXp0AA5pnbJLPukZXthhnLITx4j9yZ/jjodhTF3cQOhSTIzlTCmAAeUcFTWgwmOHfzFZQ5DodVEIXOTxibvqHaPfCBGtF1zafxRyZMYIN+PXcC//NIWxZh0L2H50/clEHr+FM
 0skwO8sf
 8BuHVzga7mIrWs6zRuadal/i9UXnCXxhBRMWEnDGxKb5eZNis0E6odJXAdjAxZPLwap/6r+HR9cnVLxNbBGRT5rpdDTW14lg/RoK8i/dwV8kLyrrLOBYJ05cR6VkCHz1sWcwFjEPMy/SVfK89OLVKowmFT4nSBOndeO1+vkp9XIGXSCZ0jb1OwXuvtQpZl9KtshcTwzJydDvbWpeqNYxAt/nO2DdgWklGGES9N0uhB9IMDpHiXs4Qzwds+w6oSpT+5KjvbaUPwMKX53nNld8Qg9GoI+/myWaHUABER28MNX87iSoImgwhf7C5v3/kjopSNxPv2kP1NAzzK30/5eH0VbSqTpsO+EXJs06/3EA5AA56fHsphPxfhmbMKL7eePAnatEioL5lPeC5wKOXlBAprIXLQfFWUBm54Mu2kKLBk+EjiXMI2B0zaaZjGwGnx7/EU5FCP6lJY6Y9dKL2/U3gkmON7XAP+sJPYf8KJKzXtYFzyUkPHY4eIZFftpM5XNmDMGaH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Wed, 21 Oct 2026 22:32:26 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed, 21 Oct 2026 21:17:08 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
>
[...]
> > PEBS saves registers just after the instruction retires, so a load that
> > overwrites its base register defeats decode.  IBS saves no general
> > registers (perf reports the registers at the NMI), so decode is not
> > reliable on AMD.  Decode in kdamond must also survive exec, munmap, exit
> > and pid reuse.  These are synthetic loops chosen to separate the cases;
> > how often real code hits the failing case is not measured.
[...]
>
> Thank you for these testing, Ravi.  Unfortunately I'm still learning perf event
> and therefore not yet fully understanding these tests.  I will revisit after
> gaining more understanding.
>
> > So the suggestion is for the first report type to use the PMU-captured
> > address and load/store flag (AMD cpu-cycles:p; on Intel, the PEBS
> > memory events, which moves them into milestone 2).  Your call, of
> > course.
>
> Meanwhile, I will start with the current plan (capture register contents in NMI
> and decode in kdamond) if you don't have strong concern.

No strong concern.  Starting with decode makes sense, and VMs are a
good reason for it: in the KVM setups tried on Intel and AMD hosts, no
guest got a data address from the PMU, whereas every guest had a
software CPU clock (PERF_COUNT_SW_CPU_CLOCK) or basic hardware cycle
counter (PERF_COUNT_HW_CPU_CYCLES).

As quick background on why those earlier test tables brought up PEBS
and IBS: in perf_event, sampling CPU cycles has two modes, selected by
attr.precise_ip (the :p suffix in perf record):

  - Plain cycle or timer sampling (attr.precise_ip = 0, the default):
    a counter overflows and raises a normal interrupt/NMI.  The
    hardware does not record a data address; the handler just sees
    pt_regs where the CPU stopped between instructions.  Even though
    the interrupt lands a few instructions after the overflow ("skid"),
    regs->ip is the next instruction about to run and pt_regs holds
    its untouched input registers -- so decoding regs->ip gives the
    address it is about to access.

  - Hardware "precise" sampling (attr.precise_ip > 0, which routes to
    Intel PEBS or AMD IBS): the PMU hardware itself snapshots the
    instruction and, on supported events, the data address it touched.
    My earlier tables tested this mode.  Because PEBS records registers
    after the instruction retires (when a load into its own base
    register has already overwritten it) and IBS does not capture
    general registers, software decode breaks there -- which is fine,
    since in that mode you use the hardware-captured address instead
    (your Milestone 3).

So there is no need to revisit those earlier test tables for your
Milestone 2 prototype.

Two small tips for the prototype:

  - use PERF_COUNT_HW_CPU_CYCLES (or PERF_COUNT_SW_CPU_CLOCK in VMs
    without a virtual PMU) with the default attr.precise_ip = 0;
  - skip, and count, samples whose instruction does not access memory;
    in typical programs, only ~15-60% of cycle samples land on a load
    or store.

If you want to inspect what those samples look like from user space on
a program:

  R=AX,BX,CX,DX,SI,DI,BP,SP,IP,R8,R9,R10,R11,R12,R13,R14,R15
  perf record -c 2000003 -e cycles:u --intr-regs=$R -- <program>
  perf script -F ip,iregs,insn

(In a guest without hardware cycle counters, use -e cpu-clock:u
instead.)  Each sample shows the IP, the registers and the instruction
bytes to decode.

Thanks,
Ravi

