Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75FB6CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2B66B00D4; Tue, 26 May 2026 11:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72976B00D8; Tue, 26 May 2026 11:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9889B6B00D9; Tue, 26 May 2026 11:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86ED06B00D4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:08:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5510B161715
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:08:05 +0000 (UTC)
X-FDA: 84809901330.30.DB8B69E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62A23140011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:08:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=X0hCaH5O;
	dkim=pass header.d=suse.com header.s=susede1 header.b=mAHAXM8U;
	spf=pass (imf26.hostedemail.com: domain of jgross@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779808083; a=rsa-sha256;
	cv=none;
	b=igvaMmOMRf1sLdpGSsY5iDjH8HrUsP7vfYPRxLdAGDVlC1n/NtCGXdKobJQUqOfp0FfgXF
	9ntjmZsfSiAay26s+DNb7wERwOZeWxiEorSDZ19qXtYNa/a2N0O9VFvGquqE2CqLXlJuqi
	X1TYIxxMTYWB9EH8GYHlVo7k6tuiy+U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=X0hCaH5O;
	dkim=pass header.d=suse.com header.s=susede1 header.b=mAHAXM8U;
	spf=pass (imf26.hostedemail.com: domain of jgross@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779808083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yHeVRInwBdhPTyeUIDm80iXzexAaKjc6iJ7mRCvzf0o=;
	b=xi610PKVFwGQOSor39ao4QzUFHpFunHzOFnWRABUBrKuEhHKvEFQnndO2Nq4aafUqAzEFH
	J5JOCrO+wYnJbQlHyBKa3hF1R6EwsdYrWSaA02j1dVC/GUjEfC/ZKcDs3N20rX97qRhYxw
	qwbGjPVUU1GcuMuxMZ5tOAbLJRXBLiY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C673F75EE0;
	Tue, 26 May 2026 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779808082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yHeVRInwBdhPTyeUIDm80iXzexAaKjc6iJ7mRCvzf0o=;
	b=X0hCaH5Ou04bGdmMjYXA7Yqxh3MId+vNVUstba3gVRcIA6NAUvBiDiV4u4ukWBTJ2S8fp3
	m2ehEj3GKRUju2JgDxSEKJeiLovzeWykcBmopzGBkLtNoozneGCoBPWZUO6XGChOz5Ud+S
	+KJFFKXJG6hyXvKgCRwzQynUUt8+qkk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779808081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=yHeVRInwBdhPTyeUIDm80iXzexAaKjc6iJ7mRCvzf0o=;
	b=mAHAXM8Ueb0PCWr1RCbutCZZ08Xj5nRqwQhdLaSrM6zsJ2Mb3Iv4zOofJwXY71hi2F2Gs4
	sWCh8bDq4rd/fYAHkzUW1mO64zXFnilEpth71ndsfqpvE26qeA3jbJtDXb427q4/XcHR9a
	+Vmtr4/LRyq8Ntr92MIUzmQgIv46/gc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F41F75A280;
	Tue, 26 May 2026 15:08:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Nu2JOlC3FWqKVQAAD6G6ig
	(envelope-from <jgross@suse.com>); Tue, 26 May 2026 15:08:00 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev
Cc: Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH 0/5] x86/xen: Get rid of Xen private lazy MMU mode tracking
Date: Tue, 26 May 2026 17:05:09 +0200
Message-ID: <20260526150514.129330-1-jgross@suse.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 62A23140011
X-Rspamd-Server: rspam03
X-Stat-Signature: guh3fy5rq1y11ww8bhi8emxwskik8fj4
X-HE-Tag: 1779808083-908105
X-HE-Meta: U2FsdGVkX18tk55MUyGEgQnlb3k7N+TzCfKjGVAtc94yWUsHeltV35YyQQbOeuB6T/Cd44hiUgKIrOtmkLXQC8M/YlhcG5Z0Atwx4hDC8fcsv7m4mrRui8okDyP07qVKxX8NKB/FE/7Jo7mWRKO0M9Tvgjox1jiZ1j4cxcqevslWkym8kUC8Onf0U16KuU/HkaemwFeT7esYVe1bqmznIvMQzE11gxBb2MUcA4dXhuKUBL9Dn5L+gWGonjO2lZv8tbaW9OrHq0/Eik6NeiWWRuVFhHPR909ZsT1E0RN51i68bO1m77try9bOD+BcfF5MWk3KhgwlumQ/On7Pus2LowMC3suEjbqJ3/jA20He1kCarwJ9WFzZQaZJ8dXbs2L+7qxDHuCDpIk4c5sMI1iGwsebYjeXlznZW9FFkHiq7QX5WhhWieGOXrKf8dWHfNBl/gk+4rJhc5MKjQEqDQ8p0niI4sltG5YI6pyqF7tccqFA0cc/7ffJbpzBhyx7Rr48ljBxq/YcxV8x+4LMFRfc10AT+fMQlLxhVdlhLZOAvwEEA8CrdldAq4t1NNXeDTsSBV10R8JcjrYHWx76GGRHCPW4PqmmgsawE15AC/7QqNjBjMrgu0JYTrXEgTbGS/spAGnbqrtkAU7Zm0viPpWBiYHuvPDwhKIcXEX7vU2JUZB3VN1RUTTQZFnCoYIsHpsgK4R2+Vvk/CWJAo9+zRC/TMIUIRjWYEWNHGjQRRHoY4tJQURhE5mZyGUSfh5iarYPLH8KFNXvpRVB1ln9Vws+Kt5wcBr3J3AykuEHivv1dWx9xuwsW3eTSXpAIkuoBBdxr81S2S57YH9K+suUHdnO5TDPI0Xo+xNkqy1OdTk+GL/OtPcgWHYiXtnB7oOfMudVbB++eaLM0J/OrUrbXJTpMIeC6iRksj2A7UtoinQm5RiRocqeK4JkiM6YKvr0drIoC+lEKm+UcR2XmEJ4Gbi
 rYyd+Dei
 CAsqTuwTXJKVTyFPqs+UKqgONtckNDxLqVdKLGratfJO3nfiU6j6oEzq8x0c2s6dMlIi4yR4QSMJRUYO+1buG5rhbm72DIx+dKdmERDorl52UkcQRpHy/GFYkxnCv5uG92RjKfR74hbnR12vl5M8iNweXN4juKW8HrBedC6tDp4QevvFiPlK6k2BrTbhCW04yPgwIXi+9zmvT4aWye0behm70eqWR9DLd3uiK6tmequM04a91VXbUY/Vk2tPGizZ0+XcXm6lXHYOwBGyzlf7hGq5webNrr/0nf/JZZSavTr12LJw4JQev6Kj1yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With generic lazy MMU mode tracking being available, there is no real
need for having Xen PV specific code to track lazy MMU mode, too.

This makes it possible to drop two paravirt hooks.

Note that this series is based on my series "x86/xen: Do some Xen-PV
related cleanups" [1].

[1]: https://lore.kernel.org/lkml/20260522152114.77319-1-jgross@suse.com/

Juergen Gross (5):
  x86/xen: Drop lazy mode from trace entries
  x86/xen: Change interface of xen_mc_issue()
  mm: Refactor lazy_mmu_mode_pause() and lazy_mmu_mode_resume()
  x86/xen: Get rid of last XEN_LAZY_MMU uses
  x86/xen: Replace generic lazy tracking with cpu specific one

 arch/x86/include/asm/paravirt.h       |  9 ++--
 arch/x86/include/asm/paravirt_types.h | 11 +----
 arch/x86/include/asm/xen/hypervisor.h | 25 +---------
 arch/x86/kernel/paravirt.c            |  6 +--
 arch/x86/xen/enlighten_pv.c           | 30 +++++-------
 arch/x86/xen/mmu_pv.c                 | 66 +++++++++------------------
 arch/x86/xen/xen-ops.h                | 12 +++--
 include/linux/pgtable.h               | 56 ++++++++++++++++++-----
 include/trace/events/xen.h            | 33 ++++++++------
 9 files changed, 112 insertions(+), 136 deletions(-)

-- 
2.54.0


