Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E840DC87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 13:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C8C6B00A3; Sat,  9 Aug 2025 09:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D7B6B00A6; Sat,  9 Aug 2025 09:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F42D6B00A5; Sat,  9 Aug 2025 09:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9856B00A3
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 09:52:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31F15C01EC
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:21 +0000 (UTC)
X-FDA: 83757358482.05.06CCB40
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2866080004
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZKrliwjS;
	spf=none (imf30.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754747539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzhXbZvDmeo/1WDNoy58mHjHQWumR3NOSXN/96nqkwU=;
	b=tUIXgjsvwL7EdZECO+OnIkUxh6NM9nV6ssJTcaHeBwkp0dUTL0db1buvENlRUBbuqyw7Gu
	+2gTCdpmSgmmhZDHUYc6I1WQVQmIm/PAy7SzHrzcu6RXf8AltOSGUx297Ioop/BvI+ugtO
	OHsMj1fkHaCxmOlR5sgf7a+YZKjkVoc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZKrliwjS;
	spf=none (imf30.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754747539; a=rsa-sha256;
	cv=none;
	b=sjy1m8bnjD6s4tMXgeL+JRIII3rTS14CjNs1VsWwqqdVh9ugTgBA0ujaJCVyoTjuvtFAqH
	8EVQRzHnRkBapISB2uG+8K37WHpWSH/7430Wul/hKEpG3nySFLl68hngCMVlTsqziz2bAX
	8O58Ir+bJmTSgIcPSwcegREPcyFlhuc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754747539; x=1786283539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F1Va4a7oL3sStdI3GcwWNaFyPom4HkNAVRRrhM+iPZs=;
  b=ZKrliwjSMqhQXrECsMFuVhRW05yTv0n1j62GSsC31hnzIPF83h6fiHzK
   weDaZ1/MdIsFxHVVEFlztTPmgJG3oWvAxLQ1zCEubugYbV9Ifi2eMqlWs
   0TKsTw/9OmJmRD9nlM/aQo5B/Q7+VnjqXP8C3CPzgDMtYn+R9b8+dtvOW
   NsnP9EX2Sxa4L4lLBdCPSYilxVkGJxk6eyg/mfaXknlpQ7e/G5sEqECRa
   V3FWCWcJGxMfEC3/YSAul2qkqxQwQip3tHa9v/Z606nizFxlpzF08CBdZ
   vSGGnoYZx57Ls8Cz7wLdL65YVGUBXTbZo2QmojcwFJNyTqpUdzppS2X9E
   A==;
X-CSE-ConnectionGUID: pOL81dd0QZed8uBOxDdecQ==
X-CSE-MsgGUID: ZQzlq/GNTbuJa7RWIpwKUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="68153559"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68153559"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:19 -0700
X-CSE-ConnectionGUID: S6yn9jfERgeI3j+fOzlZuw==
X-CSE-MsgGUID: jliW7cJOStiKkBK0r/YuOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165903758"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.28])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:16 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/6] drm/gpusvm: Add drm_gpusvm_in_notifier_* helpers
Date: Sat,  9 Aug 2025 15:51:34 +0200
Message-ID: <20250809135137.259427-4-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2866080004
X-Rspamd-Server: rspam06
X-Stat-Signature: dkicymyxgoh95o8rsaruy6hkk9bjtkzt
X-HE-Tag: 1754747539-201263
X-HE-Meta: U2FsdGVkX19OgM9dHogqkx+t03QX89pywL4n/KbiRMBglNTCc/Z7Vq0FimBjOh+6LN0cGH0c8ukjrayhC2KBynez2zbhv7byBcdp1Mr8YQ9ZcLtDdA4bAS6UMGTP7ZYKo5h12939wL2WvYqH3ZhA2anEHQJ3SJgj/c1XBEiuFy8tXkhn9B7cXE+kbHQshNN5oIS7mc0Sk4/ueRgvAAe7IE3VojuNW7yCN3nEPNeUcWOaMO1Vb+GcD17TpVZZcl/3H7i6NUcbE5TI/BSGrEYiQqDCFX1yGw9elFFXuynnOsidqRQYEEPPH3hEEZ1ftUhPLZdWbYFVo1Lv/+lvkVpOY6E7c1z8W+APOc350RRF/Av4v9TPlG6dxAN71fqhLbOK9IRfsxJm0NT6OX8joMZCR+3ZURJR60NYhkJOdLBkllwgG/r0g2UKdh7ABy0HrH3z1m8oj2UIDHCLUKAWWDJc429yBOU7yxA8hbYkZz0cs6BlqGK8lAjr3vp6jfW2Z059QkeVKMr7WGDzz6aqRnFLm1T2AjH8TLS6NnS/Kq6KXIrAihnSK0mpqt9QGPYRxtPLwNIaJrSo3eAbHoVr2WwurJVwEjbZzDKev07z5r1kFEae+WIitLqZuyax71wRNuLy/NtBK3w1SQrtiwgKNg/yGTa1+WudTd7kiIDHKVMxtnTWNCun08AU/LRr2+5Yt7kHS6h48gihJNCxyDoBZ21Cfbdj3zk7YKnAA53tHu21G4tucEqoO2I90tSnax7uvJuQstHaRQHdO1pYLsC7jnx2NmFMQywZvuiv/ZH56CECRFpiwpc7Ggmyq6cn3jj89pY0QZjkrr+a6/BZ2bELdW202LRsI0yw0YIswfx+1+zp4LyzDFYpf6/DnnGDrG6jrikme5ESaJ4j0EHoWZxEOb5G+YZEYYXCNlGW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Abstract drm_gpusvm_in_notifier_lock/unlock with helpers. Intended usage
is a client side 2nd pass of a MMU notifier.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 include/drm/drm_gpusvm.h | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/drm/drm_gpusvm.h b/include/drm/drm_gpusvm.h
index 8b5e159857fc..4bdbe10685cf 100644
--- a/include/drm/drm_gpusvm.h
+++ b/include/drm/drm_gpusvm.h
@@ -313,7 +313,7 @@ void drm_gpusvm_range_set_unmapped(struct drm_gpusvm_range *range,
 #endif
 
 /**
- * drm_gpusvm_notifier_lock() - Lock GPU SVM notifier
+ * drm_gpusvm_notifier_lock() - Lock GPU SVM notifier, client side
  * @gpusvm__: Pointer to the GPU SVM structure.
  *
  * Abstract client usage GPU SVM notifier lock, take lock
@@ -322,7 +322,7 @@ void drm_gpusvm_range_set_unmapped(struct drm_gpusvm_range *range,
 	down_read(&(gpusvm__)->notifier_lock)
 
 /**
- * drm_gpusvm_notifier_unlock() - Unlock GPU SVM notifier
+ * drm_gpusvm_notifier_unlock() - Unlock GPU SVM notifier, client side
  * @gpusvm__: Pointer to the GPU SVM structure.
  *
  * Abstract client usage GPU SVM notifier lock, drop lock
@@ -330,6 +330,24 @@ void drm_gpusvm_range_set_unmapped(struct drm_gpusvm_range *range,
 #define drm_gpusvm_notifier_unlock(gpusvm__)	\
 	up_read(&(gpusvm__)->notifier_lock)
 
+/**
+ * drm_gpusvm_in_notifier_lock() - Lock GPU SVM notifier, in notifier
+ * @gpusvm__: Pointer to the GPU SVM structure.
+ *
+ * Abstract in notifier (2nd pass) usage GPU SVM notifier lock, take lock
+ */
+#define drm_gpusvm_in_notifier_lock(gpusvm__)	\
+	down_write(&(gpusvm__)->notifier_lock)
+
+/**
+ * drm_gpusvm_in_notifier_unlock() - Unlock GPU SVM notifier, in notifier
+ * @gpusvm__: Pointer to the GPU SVM structure.
+ *
+ * Abstract in notifier (2nd pass) GPU SVM notifier lock, drop lock
+ */
+#define drm_gpusvm_in_notifier_unlock(gpusvm__)	\
+	up_write(&(gpusvm__)->notifier_lock)
+
 /**
  * drm_gpusvm_range_start() - GPU SVM range start address
  * @range: Pointer to the GPU SVM range
-- 
2.50.1


