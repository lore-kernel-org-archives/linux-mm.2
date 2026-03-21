Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FFF21094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 15:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4F0A6B00CA; Sat, 21 Mar 2026 11:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7486B00CC; Sat, 21 Mar 2026 11:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29E46B00CD; Sat, 21 Mar 2026 11:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87D0D6B00CA
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:04:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39CF2140601
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:19 +0000 (UTC)
X-FDA: 84570391038.28.55A3B21
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6E0A640014
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=l2C9VCwD;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774105457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aQsutcLH43Y9NxwFlNMe1GVmyWLzH9mSMGyjSQ6t5E=;
	b=CCHkFSLzuXT+mxAW70Db/RS8+WXgPHCWJmKAAiAp11g6ov5EmjzVrqi/z+uLdNcxRUBx9g
	eT01pMjxx87xBQbOnqYToTjbZOEXl1y7uD4Y1Olgb7ZIU/UMDfdx3/a7aWQo5r5pcLhXAA
	+rJkccGrPQk8B55J/MLllGDKd2s0niE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774105457; a=rsa-sha256;
	cv=none;
	b=reyto3KaOImMxpOIFZ1eFJcNNf0KXRtwT98ZruyOP/R/TePSNnZlJVEwtIy95dVm2S+cAv
	i5wUqiFor5jR3A1R33eM/dxdPwBlCaZfy5/aIwvMuESDHS3z8nNsF0MxsvPSkVWliy7bz5
	J1IGbyf70naG4Vci8kClxD/2M2Puxqo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=l2C9VCwD;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5ffabb1dfbaso1684852137.3
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105456; x=1774710256; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8aQsutcLH43Y9NxwFlNMe1GVmyWLzH9mSMGyjSQ6t5E=;
        b=l2C9VCwDghi8ERTuxfbdXZit/fCQJc7VlX8EnB5A+JmdnRGjG3wXAbmj13F6tW7njC
         FvFNE46sfkxttNs40eDAsGcWp30QxoH+dtNzJvIwosSGkY14n9tUthcgPVletoT4++mJ
         YhP6FTvkQ7FEJnn6aQ5c+dgekarNZfOqLj3EP9d54JwVo5eMQnUXg/N1w7e9GR7s6Ksm
         owmAsY+sC2hf/WyD6YREnuPj8YUbpXv7JN3WHvGX4Embjrt6WGzp8XRQvUENMJ6std1N
         HfaTfZdg5XprJ8YMi+luviJhzftNU9b63oN9cL0eZnGqRnscogHCY5sICCORGYifDPl8
         S+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105456; x=1774710256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8aQsutcLH43Y9NxwFlNMe1GVmyWLzH9mSMGyjSQ6t5E=;
        b=RXso9y3KtfLYEKyV8u/vIpvWqUIME4CENlnWRbk2tobR0QrMeUYkoV9/07ByPV2cRj
         ZaAdymxpcZUeWv6RjmSpTnOPMIH9lWcrzEZnalOVcB9GwyHAEf8sdPwCqo3ZTHVYDuGR
         3uArCO2gkwkZamwmFMJFcgTtAlzI/JJw0S/v64sfyLd9JTSNN1oNZC62VdkzdsbeKRF8
         FJ2lJclI1JMIqjrxRJ9zWp932PiBiNMoajvfNaNRse4aTZp4ZQz37353CGKx1DSJlpJe
         fm5UwKnsYUiOgYxFZFXsAixut0RGaZ3CECuKy+Xje2yWpsGksmx0r6kYXaTBKJOfv7yC
         xyjg==
X-Gm-Message-State: AOJu0YzGANack6YJeC63jnHHB+sfkMbgNcoi5XAQxbOd7v4j345D9olP
	CnjaqKkMDKiBfEStfIl4rkP8U3meeWhbj5dGZy/LsKx7FBno8XyVEbrmhvQafhd6rFcHF0oERwh
	WTGba
X-Gm-Gg: ATEYQzw+kcD1qv69W2q6bYhJj1v6OTXXDkOuQXt/iw/YBDmWOELrtlKk/JBb9BzUN8A
	XL4/Jp8sVtXUw+rFFc9pmYFMhclbHDVm95fRHLb5HXA1qDXjaD6WjIKI4J+a4vNHnr2OEoHX0IT
	Q010gHnispIbUOzO9eq19DVz7STHjfQs82NexlhDCsdNe3jkKVx2NySxYhHAyYLku8nqcHrWVIW
	xTLoMCZix2P2Il2hRF3I49XzT+d3XyyaO4n9UvuuC8zYXXCUk3CpoEk6NuqgeLcLKuokvq9Lcnt
	wZc/UVdJWfGNbubabXpEU4SfHpETL2N0B7qGbhKNU+KH6Zk5PhUCY3g0tuZ5mIWFao/uUqJLxUm
	2VH9VMF3D2ozzNzCpUXp4xwHZKzJP7DPZ7Wuifh3sh58UsKfFW1arhM0HMmdr1wvo9iPcH86qQt
	bNhI31CGTL840ZQaNdThESqrxUOvMKdndwnzVUlMBZzItG9WBtqZ1BA3LLbD0aaAVRvlkTOa4H2
	F+39YNGUkaa1cIlvKqfeCKGkA==
X-Received: by 2002:a05:6102:5a94:b0:5ff:fbe4:89c with SMTP id ada2fe7eead31-602aed31766mr3273670137.26.1774105456040;
        Sat, 21 Mar 2026 08:04:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:15 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 4/8] mm/memory_hotplug: export mhp_get_default_online_type
Date: Sat, 21 Mar 2026 11:04:00 -0400
Message-ID: <20260321150404.3288786-5-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7n935cpnyxxa4yfnkqcfc51gxip6moyx
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E0A640014
X-Rspamd-Server: rspam12
X-HE-Tag: 1774105457-36537
X-HE-Meta: U2FsdGVkX1+jykiEkDEZ58JPGzUKzQOBCsvTg3XTETA5j67db46f3C6l5GmFOdwsM7tnaOBoSRXN7oo6CT9MJfEsI9p6KnPVtxdd2F9jPtGGuxFdayHbTV/uvDx/BOf7aLpEhHGPyKjzMCAfqwfnX8k+IkMzWXuWJPjhE/IUfjGPfQzDIqQr9VVHohklNY0ELkfd3OjYXNIIsEiblppoAo4ErgIZVmJtyJKjr2rsyYeOw4RxVLHf+HcrndkyEqz8gw/Msvuz7bC6iVx5oEMBBt0iw1PJ6as0S63T4AINQtGBGFm5h8wPBJTQyGDd0i+US3Cgc/nPZaQqy8YWgEkc00qAqhhF+eyrE2Y0SvAdkm2D+YcXKLNJI8QtQ0k5TFNmmB9/c7DBn2BR8Ss2KMN7NFG4mWT7MGKGNP0tUY89mWIvCOiQuaY3zTqivU+iP/chck3D4w3yApWyJXYFLog3XGawrSKn5NXzGwP7yOD8uHjhWvKktxLMoEd7ScbGoWPeHOSFy6BrTgJZfNN65fqn9h43IgvBZV/+fzO0c4LDnMx3WkNRHpCJ5fzkyQ1bAZOt4aCr+fhDI3VfSi0N9EzDhSGgXJPscYPSqd06SnpW89kjrM0OFT0Dl6wPZOD79oIeohF+Jrlg4oF1dipgYgYXGq3oGd6hMyfZ+hGkkv/qHUKtQWBnuKqletv4bEfH9RCCtw25rtPK5M/IkAv1E9u0JZwrbBY7NeFhYlbM5XPsWdX+8UovxFvr2gCM2IIGCeTSbJI4I6Yd2wezHKkUEz7RpIkIe1qbRUmsFypB1mUnv9rte5n/b2/RJRfAuvOgzi7vFTXdRDq2/NMCLZKyeiaivNHmHkcuNz9aCljYnMA/pONRIyqXSc7dChhZUlOG2q1fUOfSgk+Ai00nN2Xl/V2Kd+TOwXtFhjuxq0JOYbVeQnR3nh9GW3kRov02+jIrr7aU0ATi+HD9SezhMBPt/AH
 2VHfaVb/
 N+VxSxayck8c0G5v5YV/RdaW94mofBDnzua6D2q/HXUGn/LQXfNLNwXsFq6mkcmcJpvs/pPyY1aMHB69lH4APxJykVQe8ocx7c1jLp89igmpxwHy1CxB138fVlkAiX7s8dKXtYZrzZ8stL4CczcE9c6iaVsAmZXDYL0SDYGAwAn9FXcQHSfLLG1fXxyNUDoLgvrGl4VFq7bz9Dqi9Md8fzt+1d6R/hWGQPImwBqlUYcXPG32r3D5/tSJDcwjoH8lXpUr9b9grLsOPDdObnDI+om4jMI5kBwKagSutGwtTiqSkgWl92eyXRJGpL779wsATUkLDxSK61zd7ZN1fcSpsN4BRZMerg56R4Vj0ZFVhetnWmc/BUe/oahVyeqkA58BkPc1+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
and the mhp_get_default_online_type function for hotplug use cases.

Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
the same driver code, and chose the dax_kmem path as the default driver
path - making it difficult to require hotplug as a predicate to building
the overall driver (it may break other non-hotplug use-cases).

Export mhp_get_default_online_type function to allow these drivers to
build when hotplug is disabled and still use the DAX use case.

In the built-out case we simply return MMOP_OFFLINE as it's
non-destructive.  The internal function can never return -1 either,
so we choose this to allow for defining the function with 'enum mmop'.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h | 29 +++++++++++++++++++++++++++++
 mm/memory_hotplug.c            |  1 +
 2 files changed, 30 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index e77ef3d7ff73..a8bcb36f93b8 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
 #include <linux/bug.h>
+#include <linux/errno.h>
 
 struct page;
 struct zone;
@@ -28,6 +29,27 @@ enum mmop {
 	MMOP_ONLINE_MOVABLE,
 };
 
+/**
+ * mmop_to_str - convert memory online type to string
+ * @online_type: the MMOP_* value to convert
+ *
+ * Returns a string representation of the memory online type,
+ * suitable for sysfs output (includes trailing newline).
+ */
+static inline const char *mmop_to_str(enum mmop online_type)
+{
+	switch (online_type) {
+	case MMOP_ONLINE:
+		return "online\n";
+	case MMOP_ONLINE_KERNEL:
+		return "online_kernel\n";
+	case MMOP_ONLINE_MOVABLE:
+		return "online_movable\n";
+	default:
+		return "offline\n";
+	}
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 struct page *pfn_to_online_page(unsigned long pfn);
 
@@ -221,6 +243,11 @@ static inline bool mhp_supports_memmap_on_memory(void)
 static inline void pgdat_kswapd_lock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_unlock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_lock_init(pg_data_t *pgdat) {}
+
+static inline int mhp_online_type_from_str(const char *str)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
 /*
@@ -316,6 +343,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+#else
+static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 282bf3d89613..af9a6cb5a2f9 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -240,6 +240,7 @@ enum mmop mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(enum mmop online_type)
 {
-- 
2.53.0


