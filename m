Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD3CCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A5C8E0005; Fri,  3 Oct 2025 13:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3CE8E0016; Fri,  3 Oct 2025 13:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B818B8E0005; Fri,  3 Oct 2025 13:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0098E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:32:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FC6E88015
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:32:50 +0000 (UTC)
X-FDA: 83957498100.01.7AF4147
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B2AE8000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:32:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uvI5VZ7E;
	spf=pass (imf02.hostedemail.com: domain of 3vwjgaAgKCJ4QKMQR8D8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3vwjgaAgKCJ4QKMQR8D8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759512768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSJf223vDYvCAejMgpz8FoiY2GVLX/OUVEV8AW8P3rE=;
	b=dmM++kINgXOPplwtUfeNfF5ysZvVYUj0iEvc1SqsDl8ZAnMr/1DB9gyzx8W7XBs38oy9q+
	XF+idR3/4QqPGpEXC61AkE4bfmtjiexjNlzy5OxiTbzDgsM4uInb3DqWP2yFydQrOfQIe7
	azT9ULejanyDHhZJ0/MyoQibOFLdwJQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759512768; a=rsa-sha256;
	cv=none;
	b=OAcMlFrkMklDmC4/LdUDCrIa0Cppbcz7Rudq6trw0E65Vx1zlz5XNq9OpizNHMdHx5eif+
	OkbkvBb5fd/gLbw5tF/uqRAtWCGISFqT8vx4H4swIXFaxtQg3TR+D7I7luRt9k5elDXD0p
	9uskmul4fT3MPE1woCNXN3ByxZ69EJQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uvI5VZ7E;
	spf=pass (imf02.hostedemail.com: domain of 3vwjgaAgKCJ4QKMQR8D8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3vwjgaAgKCJ4QKMQR8D8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e44b9779eso10258745e9.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 10:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759512767; x=1760117567; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MSJf223vDYvCAejMgpz8FoiY2GVLX/OUVEV8AW8P3rE=;
        b=uvI5VZ7Es1kG2Oatt4zcr1p0aYoVxHAgQ4+GlpPCPD5rZzCsNsBo5vQ6el3bJz4XJu
         obkZ9tadsDFjBNjnQiZT69iqWBN3ao7LdIJJcerj6qakEcMdWr5SbS+gTbViUGVh/rtP
         Ie/Q+UYHEn9lTMnbRo2Iq8IIVuiuba5zIbscvkcsQ9U0+9pxfTc5esKvs/BfCPcYNQ/0
         gTqQFW2DsXPXld+FjxKhvhd3Ehq6Pg4Rh0Mdabht0/YuMCDtXqBOS079rxcIEtgoBnOc
         W2H7tMLyVLAuS3GZtO9kRe0W97fdaLCGjvlnCghl818EkeUltpQmRC0xZU50J0iaEZmJ
         XpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759512767; x=1760117567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MSJf223vDYvCAejMgpz8FoiY2GVLX/OUVEV8AW8P3rE=;
        b=MaL1TLsswd+5SNBF8IDYyP0kuLGNrE+EdNb3BgwsQwQ0TGhungkHFZvqjUeWo7rWIn
         duz10KV8PaDXqogaq4yO4/q0f5Z3ijXLDJWpYTgx/WojmenTM8UDJwnvnqmiMOWee8bD
         lVsjjvdNB1MGvU8IbEWg7M77ucEe5hWV9aAPrv+5/UIm+RJUgDPrEQ/Jd3NR7HwxZAGs
         Rl37BZQQ4tBZ6WukIIk46/SCCpluKuPfQHfuaOCKJS0H5mppcUr7opVrr4mNmGKwzVfN
         uZ9oaEz6g0zUF4CreuBepABNY6q2V+db7R0/PivaCmXQm7LSI0ndqdm2MKAOVWMOAlUj
         hI+g==
X-Gm-Message-State: AOJu0YyIs5bKub6FOZNDAyyuaDWeWnmztkZDXmdeNAA71WkiemeVAO+J
	7707HMbb11zgtV22JvNiA/kWwX4DS3atSHWogrbUTLtuE/Iw1nIWz67bmUtDkQTjewDE2UaZ1kJ
	jcw2717orY9O4CNBx7Xh4FJPLPNK7oUR6q2KoGDwasEZz3iWpUIchzfrOIvu5sEamGeNkNo0baT
	m1uM6gsPvu4D2XWKAVJFiAIN4stI4qIudzaeLtCA+6GQ==
X-Google-Smtp-Source: AGHT+IEWfYLAMSMP+OGgRaTAc1dXj7/wh5+WqknFdRddjMd1FN58CkXD5Dr6K3xA5OvV0fh2LeDAOUQkcNX7zw==
X-Received: from wmna4.prod.google.com ([2002:a05:600c:684:b0:46d:6939:1b46])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:37c9:b0:46e:4341:7302 with SMTP id 5b1f17b1804b1-46e71155b8cmr26105425e9.34.1759512767276;
 Fri, 03 Oct 2025 10:32:47 -0700 (PDT)
Date: Fri,  3 Oct 2025 17:32:27 +0000
In-Reply-To: <20251003173229.1533640-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251003173229.1533640-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003173229.1533640-3-smostafa@google.com>
Subject: [RFC PATCH 2/4] drivers/iommu: Add calls for iommu debug
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yixopupgrgwbjaina57mofj94uxinbn9
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B2AE8000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1759512768-341952
X-HE-Meta: U2FsdGVkX1/WdxtLopfD9p1W8NWcMpWdyOcqnHXGFnJZnTwNDWuTuo8TcQqiCyYiKkHsLTDFeIvIvZE2wn8iM8zi9wEqEhJXdxr47DsnzWDbxBGxMQm9jzL0t+bMBYUplcofUEy6tVnvNNepaqWz4kxrpTHlRF1D0P98d5q3lh1e5kMX7YhTvYAzj6/T0m9vKDb5yS7jHbNZau0vzBw18Vys8OhZ02JqCgVdfzTzHU1vGY/M0Kh10tsMq1PpJxH/Osk19GnOTvdr8mC8nHPZoGceglCRsxN9ZhQAzyJWznQcAKve5JzUvF2xwoBR42nzOcMiJuogk61a7uWVgBq8U9F2sb+mKEhctb4jQ/5doc9oLgat6PBee8DboK80kXguJuQqYR/GosaU6j+fBusRIwIFt1EwJaE96TZy1VpcZ+KwtmLqbFF0ikyw0gvFA6b0TDdAzxAZ3kSA1MDhoYcxZF2cG2fPGH7F25tCxhk2/RElzSw2Vuou6lmz1B+ZpRoy/PDp+FK9OgSf/oSzDzLuKhmWZC6uYixlLNjp+NkDvkJYsDi9lQGDtgerOC6EH5T+XSxGTELFAqM7TksXZLUdlv17rkHzcIEzFVvRKMVnn8LEqKboZEkMTfe8bAQ4P+uxovjWgzKFZ9lJwig8nQ7woH3vpFhcXZxAL3F6PD2Tyvu4MWRthzD0fqZCS6N2d3S4+b32i3tkJQsXAuCPmw+5QJzRLG6hl59fNfHghC4QiwDMGomWECAbdAq7MnMj3LuSESujKzTZThjn66vC5YIVXgfxn3QRTLb4RlSQHaNX9VQVONAp1+1E6RIwWZG7lVHKP+KaGRbHI3vk95JWGeRwdnSBJyc8S84RWcelr/1UyN1GQ6vmzYynvQWSUOPzz32eugXMB697AbsBV0+I6mP8/Uy5Zu8iw2kReQFxM4DMQV/VMFfCdsyb4vBJJ2Z0SdKkeXGXxc5UoVtQjpnhOQv
 bUD2iH7l
 3yBqTlmyNoyphKmT8Xv9/ixUbI03m0EPuDw5LGJtrrUlr0WFamxVNeR+bQhXYTzAdSiEg8myTh0sX9yWMChP5NVJh0lMkMR6EfcL/boSAm1ChAU3aCMKYuW88xsrhZFYg/w6+DUzOBphiMnsNzp1j68o8dMlQS956+I12JJ5xd0qvi0DKTrWihQ0X5k3sKgUI3JCLKNOUw0Lbd/iGaPxuQ5RJj8hosWWjaF0/BHc0f2GG1ahDq0A/v7cSX5RmHF2N06VCDzBTmLOrV8JogNQOXcLkzX3brBrYaR9511N96Hp3CKfal3LqfdWZ33B4X4vRcMoUntgv6sLSeoHeL9YO8m+U0gATOn1Iw92O+cwUcDgFZYrT5aaS0Gr+EhFyndY12DQBvwqVz52cygfdBX44XZMndtaN2Cpd4e7FLXGYSs2+dEKl2/X8aFJlqdlMCB78TiUoyLuygHLrqeHTGzTKuVUm6CmLnQLNcEs/FWIQ1midVL01xR8a+d7mcSR8waEc/f8BrxWjkW5X862R2e8W/Ae9kLxE1+rsOiXT/3OoNXqM3WOufKGoZve4qN8Nexf4fMiAjMUS3JqPCL1mAd4CnPI46UjZO4jxY3xyWVpsJhi2wVj6/S4IwMcGPfsLOznjzIVbOCYEb3LGiPBo3KJVTNeeHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
- iommu_debug_init: Enable the debug mode if configured by the user.
- iommu_debug_map: Track iommu pages mapped, using physical address.
- iommu_debug_unmap: Track iommu pages unmapped, using IO virtual
  address.
- iommu_debug_remap: Track iommu pages, already mapped using IOVA.

We have to do the unmap/remap as once pages are unmapped we lose the
information of the physical address.
This is racy, but the API is racy by construction as it uses refcounts
and doesn't attempt to lock/synchronize with the IOMMU API as that will
be costly, meaning that possibility of false negative exists.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug.c | 23 +++++++++++++++++++++++
 drivers/iommu/iommu.c       | 21 +++++++++++++++++++--
 include/linux/iommu-debug.h |  6 ++++++
 3 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu-debug.c b/drivers/iommu/iommu-debug.c
index 297a35137b38..607f1fcf2235 100644
--- a/drivers/iommu/iommu-debug.c
+++ b/drivers/iommu/iommu-debug.c
@@ -5,11 +5,13 @@
  * IOMMU API santaizers and debug
  */
 #include <linux/atomic.h>
+#include <linux/iommu.h>
 #include <linux/iommu-debug.h>
 #include <linux/kernel.h>
 #include <linux/page_ext.h>
 
 static bool needed;
+static DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
 
 struct iommu_debug_metadate {
 	atomic_t ref;
@@ -25,6 +27,27 @@ struct page_ext_operations page_iommu_debug_ops = {
 	.need = need_iommu_debug,
 };
 
+void iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
+{
+}
+
+void iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
+{
+}
+
+void iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size)
+{
+}
+
+void iommu_debug_init(void)
+{
+	if (!needed)
+		return;
+
+	pr_info("iommu: Debugging page allocations, expect overhead or disable iommu.debug_pagealloc");
+	static_branch_enable(&iommu_debug_initialized);
+}
+
 static int __init iommu_debug_pagealloc(char *str)
 {
 	return kstrtobool(str, &needed);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 060ebe330ee1..56c89636a33c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/host1x_context_bus.h>
 #include <linux/iommu.h>
+#include <linux/iommu-debug.h>
 #include <linux/iommufd.h>
 #include <linux/idr.h>
 #include <linux/err.h>
@@ -231,6 +232,9 @@ static int __init iommu_subsys_init(void)
 	if (!nb)
 		return -ENOMEM;
 
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+	iommu_debug_init();
+#endif
 	for (int i = 0; i < ARRAY_SIZE(iommu_buses); i++) {
 		nb[i].notifier_call = iommu_bus_notifier;
 		bus_register_notifier(iommu_buses[i], &nb[i]);
@@ -2518,10 +2522,14 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 	}
 
 	/* unroll mapping in case something went wrong */
-	if (ret)
+	if (ret) {
 		iommu_unmap(domain, orig_iova, orig_size - size);
-	else
+	} else {
 		trace_map(orig_iova, orig_paddr, orig_size);
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+		iommu_debug_map(domain, orig_paddr, orig_size);
+#endif
+	}
 
 	return ret;
 }
@@ -2583,6 +2591,10 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 
 	pr_debug("unmap this: iova 0x%lx size 0x%zx\n", iova, size);
 
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+	iommu_debug_unmap(domain, iova, size);
+#endif
+
 	/*
 	 * Keep iterating until we either unmap 'size' bytes (or more)
 	 * or we hit an area that isn't mapped.
@@ -2602,6 +2614,11 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 		unmapped += unmapped_page;
 	}
 
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+	if (unmapped < size)
+		iommu_debug_remap(domain, iova, size - unmapped);
+#endif
+
 	trace_unmap(orig_iova, size, unmapped);
 	return unmapped;
 }
diff --git a/include/linux/iommu-debug.h b/include/linux/iommu-debug.h
index a9c11855c4ed..8d3ea661660f 100644
--- a/include/linux/iommu-debug.h
+++ b/include/linux/iommu-debug.h
@@ -11,6 +11,12 @@
 #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
 
 extern struct page_ext_operations page_iommu_debug_ops;
+struct iommu_domain;
+
+void iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size);
+void iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size);
+void iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size);
+void iommu_debug_init(void);
 
 #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
 
-- 
2.51.0.618.g983fd99d29-goog


