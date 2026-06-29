Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 730ADC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C056B00CA; Mon, 29 Jun 2026 09:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415C46B00CE; Mon, 29 Jun 2026 09:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DDB86B00CF; Mon, 29 Jun 2026 09:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F17E76B00CA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87047A05DB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:21 +0000 (UTC)
X-FDA: 84932976282.12.5C06C04
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf26.hostedemail.com (Postfix) with ESMTP id 25063140008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:07:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yG6p70fb;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738439;
	b=UmZf54PM2wTYuzAiN1n8Q6XnsRVX8+zXyqoFdjkfGjAq+L86H5gXdkviazuOJSMcwmKFXj
	TRp8UGgIKukyQP+WHeTs8RsQ9m7FzdL4g8rbZ/nHg89SPyYRJLhIeRHXDXWM0R4oLZ0UC2
	CI4/9twRqB8KzDxcym7RfASg5HQ7rdY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HN8NjJ+zPKxTzXRyOxLcgICqxKoEbhiQjfmIJCpQt1s=;
	b=dUPnHCSFbOhpnllWA2aEfzJWk8kvFF+XCxhYnNWQYflFbX8Kk3B7/c8uexlHVYfWitxrkc
	g/jLoK2WuOKHr3S/Ea41kKnTo5Tc519ZyEJ+3+VEMfYNwhEI3vWNjZWyUUIfOKv2h7No+q
	hX7MTMpBUgRribZBu2FVPVrk2Mp0YzQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yG6p70fb;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HN8NjJ+zPKxTzXRyOxLcgICqxKoEbhiQjfmIJCpQt1s=;
	b=yG6p70fbS+t+40LRAhtdos24Tp7YdOS8O4575ps1QgQmd+XMA94tknGINg+rwCcEXU7M0fUUq
	stWm1xP0dr61A2lxGHwkPAp/7Db8W5kfoXIJDdhr0sqlNNN4ycGIUw0baVaLMcu3nG8+tF+oY2W
	Y6DzgmZwznzlgd8SeWdkRO8=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gpmXw6HRYz1K9BT;
	Mon, 29 Jun 2026 20:58:08 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F6E140580;
	Mon, 29 Jun 2026 21:07:16 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 29 Jun
 2026 21:07:11 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <oleg@redhat.com>, <richard.henderson@linaro.org>, <mattst88@gmail.com>,
	<linmag7@gmail.com>, <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <kees@kernel.org>, <guoren@kernel.org>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <geert@linux-m68k.org>,
	<tsbogend@alpha.franken.de>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<hca@linux.ibm.com>, <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
	<borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
	<ysato@users.sourceforge.jp>, <dalias@libc.org>,
	<glaubitz@physik.fu-berlin.de>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<luto@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <chris@zankel.net>,
	<jcmvbkbc@gmail.com>, <peterz@infradead.org>, <wad@chromium.org>,
	<ruanjinjie@huawei.com>, <thuth@redhat.com>, <mark.rutland@arm.com>,
	<ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>, <linusw@kernel.org>,
	<yeoreum.yun@arm.com>, <song@kernel.org>, <james.morse@arm.com>,
	<anshuman.khandual@arm.com>, <broonie@kernel.org>, <liqiang01@kylinos.cn>,
	<pengcan@kylinos.cn>, <ryan.roberts@arm.com>, <yangtiezhu@loongson.cn>,
	<sshegde@linux.ibm.com>, <mchauras@linux.ibm.com>, <austin.kim@lge.com>,
	<jchrist@linux.ibm.com>, <arnd@arndb.de>, <thomas.weissschuh@linutronix.de>,
	<sohil.mehta@intel.com>, <andrew.cooper3@citrix.com>, <jgross@suse.com>,
	<kas@kernel.org>, <x86@kernel.org>, <linux-alpha@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-csky@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linux-m68k@lists.linux-m68k.org>,
	<linux-mips@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
	<linux-um@lists.infradead.org>
Subject: [PATCH v16 09/18] arm64: syscall: Rework the syscall exit path in el0_svc_common()
Date: Mon, 29 Jun 2026 21:06:07 +0800
Message-ID: <20260629130616.642022-10-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260629130616.642022-1-ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25063140008
X-Stat-Signature: ucw31pyff8x1cmapa3gmudbgczutsx81
X-HE-Tag: 1782738438-889772
X-HE-Meta: U2FsdGVkX1+JjJdC2JPv/2dBgkd8wngf2qrBfjY2CeNUcEasIxNv8fXKNTOL0FskrJmZY/RcCCRGQOxTa6mUlIKuouQ3vtEVyUbMtYahpezJM76zO76v5yoKtXwRjv4lZbYA1/felc89EeK4EaoHRV9xDTRNA6+e5R2O4q2VJbIVsNpxDrkSOX/vWsW8HOAykyZBXSAtfTPsmqms1aNvZeOvYMMUitpdJuG5cQy/lUs05HZGE/3OtqVW2Kj0L+5sAn1TRwx7XkbuGDkuKsurR0U5/7AUcQVvasD1I0f5mRUebgJ0CnhuYDFH2f2dC+2gqFhKo2qpSYkyNL6/6C3pLrVnzQXmac+tJFXh/7qO37hvqzuOt9brR/bLNnNujHPspgXYTkHCq8BsX95U0OfYa1c5xGzHeSHi9GgwEZAcsYERTQZ9t7LWZfHsRO0hvSzEeyxrKPmN7e6Iy7LFDzEmtUGuy8bpz2t92gLG82yR/G7yuyLqPelFs8aly3hhWl0Ui3QfLZBb7N7VcKJA+a8ziBmLMOB8V4ojIuq80A3eh1B5Xva7hGwoVpLVC0EDYSXLS2PsNytZQMDUI+Ci4l+6xdNmCsC9Dd8MFFBIWUiQsx0FslMnqeL3lhrbCUhbAJ3LN1NXWgzw6yn/obGFnNBQcSY7A7Vlo9sLq0Gr70BMhw546W7SmvWLENQoxC4Zqz+EiXj4KSWumjBEMnZBOSyioETyaRdXpH2EP/FSu6hasStAPHUOEPHczI+21By4mwUtXxKvQQYtvzsGFVCQBX9YQ3ip4RI/udQ6IZ8fkMDeby462g8kYCgcL/3k4iFnV6oQLZwtoN7EkowQbCtoAdogaiEIRjChBfzCRoEXwT85DoxXQ9/OA81DxzNYcEIhBPKskK1ZEwDEatJYU561/l7hWt5lHTBS4pdcuU4pOuVIip9c3osiInyp6mEqK9J41BBaDcapZ/d4b5OMyL3InXL
 Y78Ulcbj
 gP2vDW7JfUcXLtxw604GHKtMUAuUvnpu9oabekT0/oi9E7hS775qKiYH1m1lB0+wvkaI7oSn1JREN/TK6u0pZeILfu2xvBZ7bwVd1bNQ+u75d/clbeU/66SBlDFtNJxpJyY6cLMlIQ7NsqO0olsgSnLFd0gYrAM+qyWqW4K/MRc+s2hX0gV169icfY76EZtGBI9VXpM34aBaU+W+84WxTp13TIzBtmgbZQDH0Oh4JE8PVptIBL4+Ibr2lCzMZ54v1ljGCRws3GRdTpcHEDLJZp8Mf+ekJdyuRku3hJZkeNZrU35cN1x5qVSkePXXgQNajMaMpsm2Vgb/IoE/I00oG+VMaSAf0f0DhzpK7QnHTj/q0wUv1UQJS7UKI/0J31kqpcoPK1M/2ztPSRX6gB9sbhrwTH5GYRSViwCE5fGCfxwhrcrA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for moving arm64 over to the generic entry code,
restructure the fast-path syscall exit sequence within el0_svc_common().

Invert the nested conditional flags check so that when syscall work is
pending or single-stepping is active, the corresponding exit work can be
dispatched directly from within the fast-path bailout block. This clarifies
the separation between the fast and slow exit paths, facilitating a cleaner
transition to the generic entry state machine in subsequent patches.

No functional changes.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/syscall.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 43ffb74162c5..f6e9aa132b09 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -127,8 +127,11 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	 */
 	if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
 		flags = read_thread_flags();
-		if (!has_syscall_work(flags) && !(flags & _TIF_SINGLESTEP))
-			return;
+		if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP) {
+			flags = read_thread_flags();
+			syscall_exit_work(regs, flags);
+		}
+		return;
 	}
 
 trace_exit:
-- 
2.34.1


