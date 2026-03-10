Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39831EB106C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB126B00BB; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808FE6B00CB; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C7D6B00C3; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34C3D6B00C2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0288C1BC61
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:36 +0000 (UTC)
X-FDA: 84529998672.11.6B2B176
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf02.hostedemail.com (Postfix) with ESMTP id B4E0880002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=arIjqC+e;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf02.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRms2TNuhttZVO2eqUKVu4EHhty44FDK73pubUBpo0E=;
	b=747lA9cwCFxvLG3VioVUhvoxb5wZ5xaB6+FKvl0RggZlb1UKZACnb4N2HHQX3EvSt0DOTr
	JVeSCGCx5kOTan1IDw7KPyC+gUdSmmCZjIV+fH4Q7m0aeXYZu4q7RUPlMLSQSHu4PHaJp6
	2bZqgbJl5CQtpFVLTkI7aiyrMI9MV20=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=arIjqC+e;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf02.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143734; a=rsa-sha256;
	cv=none;
	b=moPHw1E3HdC4lUJWP7nULYO3zXmhbEESjI5N/E8uKwnhNkZFRNqMZRNKvKImGJdPiUsoA0
	NUDVuLFEDpNIW0M0zRsvQz2U5XAw0JPULb1+joOdbxkGDUHg3MrhUEvxL2FdfoDa0rVnt9
	UzGZdYcZEPf2XZoi3ei5IAofCUbRPaY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143729; bh=Zdu+cVQUurUlnC57nYv7WmkJa7Su1n9ZL+7ubRQiCbU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=arIjqC+eOW50ePPRI7IzTKWN2gbhB0tQ9WRbPXDZdH2y8Tl8MVJAS9gxKOCgGSNO1
	 MKRth9R9YTwOofMsTkyRe5Kz4PcjK/cLboke0inMKDssNbfSjXTkXB1/ZhuTMFSoly
	 YzXp7hvqApt2TDtbnjQwMPLewEHxBbUoVg9XuPpY=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b1-2367-7f0000032729-7f000001ca3e-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:29 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:29 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:24 +0100
Subject: [PATCH 58/61] arch/x86: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-58-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1972; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=Zdu+cVQUurUlnC57nYv7WmkJa7Su1n9ZL+7ubRQiCbU=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAabkCM/59lsV79Q3PWR22p56JLuGabUpuR4i
 qxQub+ly/qJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGmwAKCRA0LQZT0ays
 2xXOB/9ZPHi30qdJIkWySghqlR16lgaAoi3kyqOX8y681/67uYGL/oYTixO52tnBrjVPqGtMJMl
 /Q1KhfevGkVNYzFAfMrFBpAZag+UIgbv/BCAd+mAYMHmfUSOVrYD15iCyuV/mzNjhjHEufwESj4
 I0XaRrF8IjuTyxoOaAktjvNz5kPAQuNzEBmaZ3v2GCRGsUPgyn1rW2fNRbOhVzN0Q0ZlAeRhTj/
 Qq0svuNBXvGJBVWHLKzaFNv3dtadS6o0vkr1vZsO43v1j0qtJ5bmVxhOhChUZ8M0SvSfZzOtGDb
 woeHnmnHVjGmRuu20BTVhdN6fCN/9hgCBGPx0vI7/S13IInk
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143729-8448CE1F-1FDA919B/0/0
X-purgate-type: clean
X-purgate-size: 1974
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B4E0880002
X-Stat-Signature: umsgh3j1rwua39ixjrm85psiuuceybat
X-Rspam-User: 
X-HE-Tag: 1773143733-137053
X-HE-Meta: U2FsdGVkX19U1uichHO8qKcDdG5UxUttskUGIhHWAFyumpmisO1WkH+hbsdGTx2i9Xp/cj0IzGypCDyMJfRmXKrUGVHanXsJEP+QxrT0DqUIKSLmDQmOiXdDRiLYZQ6H/RuwAsZNLIoLbY/lAwQTDYXFwsHb/DHQA0ZkzYeCiAfgG/Vqo+nkLL0SdiBOzfQ9WZS3vMe0zPg2hKpEX4R4ZGrxPwq6BH426UIHXdXgn4ltllgZx1qTgAnktFPYS/3v9pqtHe76I0vyGCYSH+KIyxE2eO35wtNaXF53r5bEmF2cmUwobjE1ZXe/wkqCUi5/Di3cXrkPXhUsherr/Zj9PkRkCQ6aTyQK7kzc7YOqXIyB7pIds/wWcisYdy7reLdgF+/wrk5u2eGilU5ipVzd7mx+PhAMSTjZNa4b87bTdtKlRsoDMico89WPFH9sX+LocWCouK64SbgH8rFPsZoQX7NNCqq4H8xLyE018PsKqYBO5x/SNMmFhgJQTM2AIlwpLqbxixk6fvwIKGPuZgNcwbk36TZCG/8HiQqHAZ7aUVm8yNUnDsNz8ZOteOl0TmSbuWCgzvwds+4+zqsVOcwOSuGqT7oBwkIEiIbXLGSoe8druqZ73QxYeB6hMeBri9D0nhELSf9HePmriIo7hFx+7OoXEIqyczK19HenSvWTie9s0pV6NxFp1MaVM8t/AJP17ISDJZfTqIj0pf/+SXfiiZg8J65Hm9Z/fuu3GhDFdFFgS2IZI3AyUSi2TTxWjMWZFxOx/2tH2AhA2JEHQKUunefsg5AGc9oGqlUbnfXRzA22n9P+uynDnML5NP2/MC/N6crZcXK3tNiBH9R0T5B4z0U9gLzaJ4NStxeDT1G6fPjgp3ZAts/heWAqpcZxRDZ2ccyRvXbko7qY2AGi5NkbRav31Q2xZvn8M4ct3yrZ4o9e9rVH9Huvet4RkCSnrh1NmRkqPRa2bdEFZTqzSfl
 4pm0upk7
 wvlACVvaUt93freD1IsdKumLd2MHiBkpdRpHPq1ns38up/70ZFyNSkTus5OsFsl53vWC43F5+u7OvPaGzCVd8r1aK8+sEzt3J3T/k4BfZxnRI29CjpoSy9Zu0zKH/3nx1ERw/jMdMchnuj5s+lEumqvbk2MznJXp7d+whfP2NeWuK/d0OrJLJ4I/FeXjPLFdSxvsIen7D+oClv/NGRexGyJ/AHwm7igwLP7+f8aq/SlJ1q1JgpODPv0T2QgdnjqGz9hj8gV7X6xU2Za0wbvSXybS5Bq8vsUcOFG/AEUuk2Ql7PbrL6Zg4tErrq0sBJ+v6qWE0vg8HXETQiUwlrfxtGtVW4NiSY+k/fAVGpe0kEhnwONqcLISJoixsj88ZgqFhVlb5z4HHBxkvjC+3DNS9gRME6vxGfrFUYQnVcFdrl7ASY2UWcDK0oRqdwrlR/bkRsHtp6VQ8PJQpZDsTB+WwiIHKZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

IS_ERR_OR_NULL() already uses likely(!ptr) internally. checkpatch does
not like nesting it:
> WARNING: nested (un)?likely() calls, IS_ERR_OR_NULL already uses
> unlikely() internally
Remove the explicit use of likely().

Semantich change: Previously the code only printed the warning on error,
but not when the pointer was NULL. Now the warning is printed in both
cases!

Change found with coccinelle.

To: Thomas Gleixner <tglx@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: x86@kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 arch/x86/kernel/callthunks.c | 2 +-
 arch/x86/kernel/irq.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/callthunks.c b/arch/x86/kernel/callthunks.c
index e37728f7032277a99ffb0e6bb7dfa318660e56a0..6dc45838d8e439e117815b85e2840bb3a6688ed8 100644
--- a/arch/x86/kernel/callthunks.c
+++ b/arch/x86/kernel/callthunks.c
@@ -212,7 +212,7 @@ static __init_or_module void patch_call(void *addr, const struct core_text *ct)
 		return;
 
 	dest = call_get_dest(addr);
-	if (!dest || WARN_ON_ONCE(IS_ERR(dest)))
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(dest)))
 		return;
 
 	if (!is_coretext(ct, dest))
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index ec77be217eaf5f558fa73c2ff6cf1ab8953ee2f8..81963909066d72607f58d3e443a21a3b3e701a99 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -282,7 +282,7 @@ static __always_inline bool call_irq_handler(int vector, struct pt_regs *regs)
 {
 	struct irq_desc *desc = __this_cpu_read(vector_irq[vector]);
 
-	if (likely(!IS_ERR_OR_NULL(desc))) {
+	if (!IS_ERR_OR_NULL(desc)) {
 		handle_irq(desc, regs);
 		return true;
 	}

-- 
2.43.0


