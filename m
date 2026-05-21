Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26722CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D64D6B00A5; Thu, 21 May 2026 03:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887FE6B00A6; Thu, 21 May 2026 03:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7250C6B00A7; Thu, 21 May 2026 03:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56A1B6B00A5
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:18:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FA4C120570
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:18:25 +0000 (UTC)
X-FDA: 84790573770.02.F255BA0
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8454B1C0009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:18:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=QDgkMVRC;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779347903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0ERgf6l48k7n+RO+vxMZwZ2/ZJGp5WzvOOMr4YqH/g=;
	b=Ti3DmaQ2K+zFWrzEb0xSSLxTGV/GWplhldTiV+QmHHO54s4o7fCEzdR3wTDA0oCbMhUh3Q
	eeN7CAEMHvAy5ygoC3uMGETLj44oXR7qDuOB1cX4EeLyqFcNUk6IweY3PMIuqEj/7XA5hD
	dMOptLbcPOnSaqRa9JALw7VBpWHHcVA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779347903; a=rsa-sha256;
	cv=none;
	b=1ybrGceesZCUrfjm6igQZE7Yzf/SC8zlWpI1SrvGTiys5xRQ0QMXPjbJmDrr8sUR7evxqq
	pD/pXPf3TMXjOd1tiubl5Z4vulcn/B1H5J6T+gA/Zpj1mHkpIL3hBZXvrr3LqFFm6AcRHR
	3Wi1xevLYmjDxY0r5Y/qJbCgghEMm7Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=QDgkMVRC;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 99B23D0933;
	Thu, 21 May 2026 07:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779347901;
	bh=H0ERgf6l48k7n+RO+vxMZwZ2/ZJGp5WzvOOMr4YqH/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDgkMVRC6D/FPdZ5WacGD82YKZlOl29ltsen1a2bEaz+6Ll9g1Sos7hVApnDdCCg8
	 SyASYXwzIEunoEHTG+aOlGAEee0EXIDdnPQQM/OejdZ7z5I2e9QmfvI0kyCVyCHeBB
	 l7KLHqPTrAcIosRjOtUm0GtePnWbPgIeAreHbj0g=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 4/4] cleanup: Remove NULL check from unconditional guards
Date: Thu, 21 May 2026 07:18:04 +0000
Message-ID: <b9080cd6d4e9f8e9529a74cf8922f6f54bdd2145.1779286416.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779286416.git.d@ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8454B1C0009
X-Stat-Signature: towy8setkowyydobpj1nod5dm7cxsbi3
X-Rspamd-Server: rspam06
X-HE-Tag: 1779347903-685051
X-HE-Meta: U2FsdGVkX19wACoGhv4epSqH0bQwHUFi/5QjpGkybEI40UM0zLYzSkIiqGh9FWBoDLzly0R72IWWKopilA3Eeihk+9nYSpxKzRgdoJWfd5osd6yw8SkUUkp1++pHImukOxKUljdQd2iPN835NpJ/daIr7MZ3tIOAWJb6GDSh4rnUd+35GRfyfAwUjsNxNG396bTEYP6oHxE3PYKrl654aAyvnt1JDaNpMJJWfy6YfHQ2DrjxadX1c5YWjNRE7Y3EtZ+nkjMy1xD7aSAoGh2HQChtMCdOR9IwV1405OtGDJaAc59Mc/CLCtKtPQZxosHoGB9R+hyS75V2NBHHe+SDIzXd6656P1ux2isKNmYln8nRU+skCok6YAa/0ENLmnLwDgbgH/1T6/tPBti5r8X66lIzMWIjML1ZHpv16UI227ggA92KClMU2UaKogBX/ons6NZySBHwCZspxZ5OuS0SQtzIYJZWwsoR8tXd7fvN2pWr7Nxomn7jwfEm1Wu5JfY1QFFujkCTgIi3U1A09Ik7djO/kMTxGAPZ8BFwWQQBu9ZKSSswtCETf2EaTblysH/MiQ0KzP3mH7uO9c7hCrO+LeBWafApX6U0YxB7mZ3QwSDysqc7HjHwh4kHw0H3puMAmudZ0gVEhJJ5fG6ghXXFA+bLToIchsEDNPKKOz95XlTp+BwJKUqCDhjWbSqwqXcYRR/KoPxPLg9nxTobHIgTweMbebWraUpmsZhqw+Jki5XSp/9+Ptw730xclOC0vqSIXuwNcUZqQG32hNpkQ9slJoEnlxMna1Pvhz79h4jABn+44Ct2sguRXT73j22O5aoEiq/8RUmA5OhQIt6YtRGl6X7ntb2koT2DNqPSxzWuKzgqKD7qCL3a/l5ytPmMkB+MYRIpsxR6tjrH1g9O1C2rTacESVzXpAZED5lV9qrHAR5Y3IJcighKgvxidpJ9ypJkplUvh2fx092IoQPEV2v
 QySEVKwb
 RTKvhfvX0STvVZ6me/siq4tDmAs4SHZIUvZV1m6CrrtUjFlCLa3xLKzHEMJNYQwNf9gEnBzIDIQm3Ufyq0I2g8I0nD3pE5/5T18aDALl3oSXbIPk7rtJrMb6PsyAo9Y++jNjPGz89kQN+ZuI00kUXDppnqjw1nsLAHn5fWPV/8rd/Ec5NWTPfmZoN3cPQhoAGK71iREohTm0MBG0oIZbjsRSdTWXZIlPhech5iZcqPXu1vazQsFIm6coPFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unconditional guard destructors check whether the lock pointer is
NULL before unlocking. This check is dead code because unconditional
guards guarantee a non-NULL lock pointer at destructor time.

DEFINE_GUARD() runs the lock operation unconditionally in the
constructor. If the pointer were NULL, the lock operation (e.g.
mutex_lock(NULL)) would crash before the constructor returns. The
destructor never runs with a NULL pointer. All DEFINE_GUARD() users
dereference the pointer in their lock. Verified by auditing every
instance found by: git grep -n -A 1 'DEFINE_GUARD('. The only exception
is xe_pm_runtime_release_only, whose constructor is a noop, but it has
no callers.

__DEFINE_UNLOCK_GUARD() has only a few usages outside of
include/linux/cleanup.h: tty_port_tty (NULL-checks in its tty_kref_put()
call), irqdesc_lock (fixed earlier) and two guards in
kernel/sched/sched.h (dereference the pointer unconditionally in their
lock constructors).

DEFINE_LOCK_GUARD_1() sets .lock from its argument and runs the lock
operation in the constructor. Same reasoning applies. All
DEFINE_LOCK_GUARD_1() users dereference the pointer in their lock. Also,
verified by auditing every match of: git grep -n 'DEFINE_LOCK_GUARD_1('.

DEFINE_LOCK_GUARD_0() hardcodes .lock = (void *)1 in the constructor,
so it is never NULL by construction.

Conditional (_try) variants: DEFINE_GUARD_COND() and
DEFINE_LOCK_GUARD_1_COND() use EXTEND_CLASS_COND(), whose wrapper
destructor returns early when the lock was not acquired, before reaching
the base destructor since commit 2deccd5c862a ("cleanup: Optimize
guards"):

    if (_cond) return; class_##_name##_destructor(_T);

As compiled by GCC-11 with defconfig on top of the locking/core:

    Total: Before=23889980, After=23834334, chg -0.23%

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/cleanup.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 8f8d588b5595..1f6d1a97617a 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -398,7 +398,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
 
 #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
 	static __always_inline __nonnull() _type class_##_name##_constructor(_type _T); \
-	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
+	DEFINE_CLASS(_name, _type, _unlock, ({ _lock; _T; }), _type _T); \
 	DEFINE_CLASS_IS_GUARD(_name)
 
 #define DEFINE_GUARD_COND_4(_name, _ext, _lock, _cond) \
@@ -492,7 +492,7 @@ typedef struct {							\
 static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
 	__no_context_analysis						\
 {									\
-	if (_T->lock) { _unlock; }					\
+	_unlock;							\
 }									\
 									\
 __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
-- 
2.53.0-Meta


