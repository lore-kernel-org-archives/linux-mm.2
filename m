Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE426C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5AC6B00B3; Tue, 21 Jul 2026 05:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6886B00B6; Tue, 21 Jul 2026 05:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E786B00B8; Tue, 21 Jul 2026 05:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4F736B00B3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:06:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4920F1A0434
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:06:20 +0000 (UTC)
X-FDA: 85012202520.09.A3B48A1
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf25.hostedemail.com (Postfix) with ESMTP id 36983A0013
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:06:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784624777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=QEWk5v+C8X/YQvliiY7KDSrRhicWkbRwaDrr/N2mxUQ=;
	b=EBMrg8822Q8yghTHs7lQQsLWfR4YQ6RJZ4SciqkPiqV0RZo85r8YZAam7kIAF/hIV4rHpq
	mn2tbgp20sV2Zm9vFDTdch0atWuYlShJ0fXcSgMdhjiMqLI2cpba34bC9L2Q5vw9ecl6TF
	ke34lNjY8xceijOHbROu0DqYoiujHAI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784624777;
	b=fzu9M5W4sDDElGfvFyWJSB2EnOndpt8S8r/wNlOW/cC0aQXOilKdkyoxzjtnRZoHYZBlew
	0qQRFM33WI720ODHd/JPQzNltHIzjvj8BY06NSRBjC4dQcP2XfQoWAqqGRdjVBtoJfcRwd
	eO/qVICYlSp6KiwBV7rey6I5YeIDDec=
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8DxeeuANl9qHpMFAA--.21602S3;
	Tue, 21 Jul 2026 17:06:09 +0800 (CST)
Received: from linux.localdomain (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJBxb8d_Nl9qdssTAA--.39236S2;
	Tue, 21 Jul 2026 17:06:07 +0800 (CST)
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH v2 0/2] Fix and optimize LoongArch module loading
Date: Tue, 21 Jul 2026 17:06:04 +0800
Message-ID: <20260721090606.8982-1-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxb8d_Nl9qdssTAA--.39236S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29K
	BjDU0xBIdaVrnRJUUUBEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26c
	xKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vE
	j48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44
	I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2
	jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20x
	vY0x0EwIxGrwCF54CYxVAaw2AFwI0_Jrv_JF1l4c8EcI0Ec7CjxVAaw2AFwI0_JF0_Jw1l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UMpBfUUUUU=
X-Rspam-User: 
X-Rspamd-Queue-Id: 36983A0013
X-Rspamd-Server: rspam01
X-Stat-Signature: cetorsxiszw3kahmj5fr6mfh4szqhm7u
X-HE-Tag: 1784624773-598631
X-HE-Meta: U2FsdGVkX18LGx1b1yjnanFzvDs/9AYhqmND99Zcp3u5gJCRyVRTcNd7nCebtKhfNWRPuoGT0fynRuQj9CFnVngH4Wx2JHl6EOAemISOVCwkHzO5QUNmTtY42r+yIohtM/kUmOjszWLtHYXxKwisur9SODd1/m8kQ4/lwc+gOrf55WRsJKiE1kUYp91lkzWJXPpWTfdsusyohqeDMgiJkK0TZ4cky26M38DgiJ8keLQxWnrhybyG2++zFAzQBaJkGeMD3efDx0iG4PnQgL9akFNpl6pWFDOU48vE4fGvF/keO8HBZUmlWlOHhujUkXY6O/F45BC8nI8En+p8c79COVxji+AQRxpNdmtvdCrK0xj6hV04L+M9LrmR8Y8cNS+bmTLp9fidzYfFyrXp+/pnsPxaLinBxYHKMFviD1o86mtT64ZBQ09TFrF+/Slbt4rn0dAk2GY6fjrl1bJqDJY0bPfqIwy8vEkzur6KsDklklQa4xye1dUyJqhQgEZlHAmkX6xKyoSr31+PJivZzi1vqQb+WhNfuVmOYJkriDVXFyEPCwQcLQ35391F0dKserbVFwiOUUzMKJJhM5O0jLmkPE2UYPQy5up6lJlup+4aAiMjGrI5l2FXeer7kaO5QC/ktVabEO8KUIuzfmbA+KzqvGmHjrWa1Atn9MBlUpoPIrDhNIyIGQVt4/sPFtD63o/t4CYxAaBBJDc/oIXMvMZ3PWOY19uvxYdFYfz3teokyQGQAmT5ZceY3yn16BT2L2BjxaOXyFEk3/TAfkKepdoGPoX5VGo+vF3XkGqda1qiU/ySWImANMCt2WhSdFjUESuzsTZv3jLCzA5NskcUXyTGOtkbDVs1NBTxSgFBhHu8yYPys9ojSdKzK34s5ryzoFtv5U0q8fAvujCWzJ6ALQqkMoXH3xU30af/QzQsTJTZhclT+tlCUdOTVTp68pXLQGmT3hgEyTYc+JRZTZs039a
 3v6f/5Yf
 x8yix
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix "execmem: unable to allocate memory" failures and optimize
apply_relocate_add() to improve module loading efficiency.

v2:
  -- Drop the size/align/caller print patch for mm/execmem.
  -- Update the commit message for the 2GB space expansion patch.
  -- Add a new patch to skip address pairing for non-exec sections.

Tiezhu Yang (2):
  LoongArch: Expand module virtual address space to 2GB
  LoongArch: Skip address pairing for non-exec sections

 arch/loongarch/include/asm/pgtable.h | 2 +-
 arch/loongarch/kernel/module.c       | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.42.0


