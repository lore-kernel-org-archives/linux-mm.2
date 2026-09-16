Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D8CC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191AB6B008C; Wed, 16 Sep 2026 04:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169956B0092; Wed, 16 Sep 2026 04:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057646B009D; Wed, 16 Sep 2026 04:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D35046B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:36:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E9B0C068D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:36:42 +0000 (UTC)
X-FDA: 85218969444.11.E1F363D
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id BB18380003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:36:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=k+Jj0nhB;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Ky/jym2qeoiedQ+4uP+uRv23sKBrOXkwKGv1IN5HSI=;
	b=bLU0vV7ZmWbaM3gk+EnOEID4hMOD1dDKrWnchjppA0IyqZHvl1XdJBPhpiy34pEZrYEbfd
	+dLC94r+Mihgj5ug5ew9AkX5TBYcEHLNtQfBguCHuF7Y1qmvbJAQVK4ZNF46sNNRhmnULl
	EVzYuE/WdU+z6EZCpVMfuSMzwH2+qUk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547800;
	b=eA49hiP9poJd4N7YpuLhapjYNmflC883vlvPG8tUYODMlcoAxA/uibuBwvWaIkLUtnfdvL
	FaVLJKb5rKfoQ2P7oCVG5YL49zX9S/Oz1T4vVVE39eAMxu0o6flZth9v5huCY9DUOyIBEk
	5OPtOY6x5i4Q7lqRiz9HUAqV0Caz03I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=k+Jj0nhB;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2db18fe459dso4081955ad.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789547798; x=1790152598; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Ky/jym2qeoiedQ+4uP+uRv23sKBrOXkwKGv1IN5HSI=;
        b=k+Jj0nhB6QFwQyzDc79M1ljFTTtI9G758mUBNnYYaJh0MZwbXbO8rf4uIBkBfc5GGv
         wuD3PpoM8Xek+HfUVFHDD/66wpNqdmbJ6lUuF2f7u85yR+6hVtJuTlwmwtv7C87ZpCLY
         xSDP5N2kg+MZ4J6mXquassQoRA3zLFHJCrwHpF2gxmcT1n8aPfJJtMzOLn5fgec2gPDg
         Z6dKGlRBSBwQDGhbIql1zNKWUBULrFvJLRzz3dYbdTz4KRkA4x5Ohy/mms629b8uF2N7
         Vc+5Qjh/7yN1vgsYCwGmv5acjqLRGLzOnWcQuVJn8SrE1333mOt/Fc7QYkd4RJURTPma
         d8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789547798; x=1790152598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/Ky/jym2qeoiedQ+4uP+uRv23sKBrOXkwKGv1IN5HSI=;
        b=oOICv54WTy30MD5Ft0gwM+VVJaqnGV/RztD+RTJRrIqg4EJTvDNLTU2JGXUV4Ty364
         8ydrKBbA8MfPvsUcJnh/yaK4voajV25hOXzRTnlog1M9fq9rtcQaDyqQFhUQY168YWdF
         /GC1FCmzVBGEFIBgWT/psexzoblwj41UT7VRfIOS99x2NLbHxk57M9yEbEVF89kzsIWF
         Ru85PBkORmu+WrJrMId12gSuNNxv3QFATeq1V06kEmQS0lFj4n/sYdVvOiYAiUbKVQrV
         Kr1u0L6sqb6EGoCS4eoRW9GNDB1XQXIH3+IfktVpDDzVgC4LARvfMrGVDLtXqOK7nJGb
         mzuw==
X-Gm-Message-State: AFuF++ldtVKqs0Jl/hq+0RaVAg0oRQU5wBQQ1+BODOa7Ku7mn9dAQ4sl
	P5hYE3YDQKLHGpX8Rz81k2vbyhv6Rx/ESSM7mMWXrgN7NRi3GY4WQXG0ilepHKEZHiI=
X-Gm-Gg: AYBFou1kZspoiIOVd35juOMeywrw+wDVM91p1rgZDL8l7OBt6kmSLyxTXxpys9DdsoD
	MEdDhTj5vNC4djBKxIyfPVU5wAVI6U0OGDj2aMfjL7ZNmNZlXt3KOE62GQT3CvuBAWaDHmsvifz
	52n5BYhVxHt/ZTlcPNcWjWaaRsyOiL7CE9Lrm4yWNCtD08X3SkOE+wBv5rihp73TS9fEibM7ptF
	OYPzNj6mlbMQvQBkYtbMC8RPw9Zc7U8nWcglMVhwNDmiTS5fhVCpeGyAP21yAb5t2pkYWg2D90S
	AMZ1vt7xhC3yZGdNvbzDaBOxUTPqPelEDfJtWFVD3RA+0SltfODLXyZcvtzTW0CNQI6SPsh0xcp
	BPGrfDu2ohlqZSaWIAxKMRwWIVbAGWm5WoOLovVr3hOqk6yX2is8W+kCmo3uKNgDt6qVtQW8inb
	xA9K8eKzKsq5vKxs1qs+ALvzoTL3ysWedaWzRKCff3GtK+8GJ74CJwjQduJhHUGhULCWhBEPqGh
	avw2BYnJ5Yeq+dmSeIY
X-Received: by 2002:a17:903:ac4:b0:2db:63cb:1b17 with SMTP id d9443c01a7336-2dd8e633554mr35455145ad.18.1789547797988;
        Wed, 16 Sep 2026 01:36:37 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89d9007csm7646915ad.5.2026.09.16.01.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:36:37 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] fixup! mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION
Date: Wed, 16 Sep 2026 16:36:27 +0800
Message-ID: <20260916083627.2145779-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-2-songmuchun@bytedance.com>
References: <20260916064341.1825793-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fdh4thh5wdkrpynakop5susz9jfuy6m1
X-Rspam-User: 
X-Rspamd-Queue-Id: BB18380003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789547799-252853
X-HE-Meta: U2FsdGVkX19mWKlIUY4FJNVWVIp2YzFU51Wh4WWEnBXOpzMqluoL7JO2JG6ml+LLE8Mc6aUPGkeeOM3b/PmBSe9PTrfWrvqr28UHWBjk9071hxz/jPfBhBOhkKFyJ44qXcqZCtkG7KShagIE2ScnCIk4LUxP7kT8av/UwN4VQn2DI63mDbvGhULdNr8G+KuC7yicPSzDzOc16nXGmfKt0CfBKHDRykYoj0MZ94efUli7VD49AwAkE9Nmxva9FWU7etx+nifr+yg0LvHYF2ltmB+iverOzQbWGZ08sQV6b8D1hz5fwJHHccxMTgT2R/6HpoKMQbWdgpkonjz6hky05B9n2j4e12kQpcV8RLB9Mik/TQ5DR4HgiKpThdXJmtL98Wp8V+A1D9U1sS6w5IdoCKorqD9ApZNPZ8zYsfMSYdVqfoZx/CxAmjZDrk9Y+GFttXBLNRqB7/TbDhGhgY1R2ebKWhikC9VL2Sb8FyfM9KYDQyI6+GuZU+nQuhhuTRfJcBZKt2kILMErLrgapFb2txR5xUc+CT2+1M583yMwFLOI6WfCahWpy5W4EYjXAkUBrQvFYjm8ehMjfmhxe7+yVcYuPE5Kd7csFWv0jugVQvC053X9jDEkpxwaydBNHMcnGv4ZClhUgX9ZJdrJnrL0GPhFsweY6fY/5TMx8jWGq7Y9MZhV+rBmHwgQw3pcU7muYBhOO3QLEoaCI2EKLU/RuJ1I5IDZf+DZh07aMU/tPAGFWxbLuzvkaBC/zPZP2h28cl9ZCYNWfIG8XFfPiunYRfBtqfayuBju5YgnjlwjyfGSpvZuunR0ia0/Mro7me7lG7Hd6LobwVopvtji/ZyPWfPZNWmtSd8ihEoidv12QgyYCkeFK5RPFxPY/hh6icQHUxEKu8lxD5thhH+ERwXUNf64XAp0HfyhxqpkdCEZAmxycBFzXaFRM1CtCoyMJvfeR3cI7alf0FJq4sojPCn
 thdUzR41
 f+E7w6Hjaol+LUbfT5ZTY2WSaiM4PpMmyHnf0E9pSuuqwrPm1Kc8OxcIXV9YOEkyT+ev1sPrPYxx0BPfEL0pnd0jHl5a8I67DdcowcaHwgR2pfGWCgDCDI2ucv+H92CMjRPhXf2bNcahz+D8bL4HDOZShHrYWejBFs/1EHxOKbY3Ya77vwfZE6jKrqTnFuKQZFmX6vLpncSBwHm1Z1q2YqTA79pCIyib97texIfNBMFI6+whWDtHd8F8NF0kerHYLbgTs0rACXun8Iq3Bzsh0kOrQNENWTZq5evkfVfvdMGu2zWiezBCF8eyO5AVCdHtSpnIOmpCnHo8o/tGC2hQ8Rcw8PoCDCSRU/0KcZfRRcix7DSEjQvWr60sKAPl1Vq+MDFe5hFwpQLDif30Grkh+oohcZ6EbDEcvet020bzQhcAJpK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The section-based vmemmap optimization infrastructure is guarded by
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it can also be used by
ZONE_DEVICE users that set dev_pagemap::vmemmap_shift. Introduce
CONFIG_VMEMMAP_OPTIMIZATION as a common config for the shared
infrastructure.

Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
ZONE_DEVICE when the architecture opts in to DAX vmemmap optimization,
and use it to guard the generic sparse-vmemmap state and helpers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Note: When folding this fix into
"mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION",
please use this commit message for the resulting patch.

v5:
- Select VMEMMAP_OPTIMIZATION from ZONE_DEVICE instead of DEV_DAX,
  covering all users of dev_pagemap::vmemmap_shift, reported by
  Sashiko.
- Drop the DEV_DAX dependency on ZONE_DEVICE added in v2, as it is
  no longer needed by this patch.

v4:
- Rename SPARSEMEM_VMEMMAP_OPTIMIZATION to VMEMMAP_OPTIMIZATION
  (suggested by Mike Rapoport)
- Collect Acked-by from Mike Rapoport

v2:
- Fix SPARSEMEM_VMEMMAP_OPTIMIZATION being selected without
  SPARSEMEM_VMEMMAP, reported by Sashiko.
- Add an explicit DEV_DAX dependency on ZONE_DEVICE
- Collect Acked-by from Qi Zheng
---
 drivers/dax/Kconfig | 2 --
 mm/Kconfig          | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index f50c6b32d826..602f9a0839a9 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -8,8 +8,6 @@ if DAX
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
-	depends on ZONE_DEVICE
-	select VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/mm/Kconfig b/mm/Kconfig
index 0fa2eb76e4f2..30170a936f1f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1224,6 +1224,7 @@ config ZONE_DMA32
 config ZONE_DEVICE
 	bool "Device memory (pmem, HMM, etc...) hotplug support"
 	depends on MEMORY_HOTREMOVE
+	select VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	select XARRAY_MULTI
 
 	help
-- 
2.54.0


