Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59564C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 15:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7D26B008A; Sun, 12 Jul 2026 11:45:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F926B008C; Sun, 12 Jul 2026 11:45:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A504C6B0092; Sun, 12 Jul 2026 11:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1496B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:45:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E21EE169E5C
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:21 +0000 (UTC)
X-FDA: 84980548842.24.DBA0BE7
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2973640007
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r8fMRM92;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783871120;
	b=oPxXjToALENSPzarDtRmnnpjwl2Q1RPm/oU6LVU/0MbOZVuvMZnoenNpNGG3k/iPwBTOk4
	29/E6dk98Bjg7+0xZHXiSDnhc9+PMevNoNE5Ed4awb2R42m4kKSPfvVrlAjLd+D1yEOk95
	x2B+BWeduzee+s41cb2x0KCCwx/6t1Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r8fMRM92;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783871120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1M/Y6Dv0V9NOM4+/puP8NWosRoeWXHurd+5rEoqGA8=;
	b=RM92Ra+JBQEoKw5KYnZ0eMQaA9QRAFYBBuzYj2c41wrRvd5PlfguG1GhrL1pMbGX01O3Jt
	U9WRUG4gEnNs4kwZG6ZrH+7wXXQ7vtUwrWt5Otck0mfsQUnkfmZTVJSYM6wPoC2QO4gpTV
	Qqw1rYUnzPCzjWfyxFcmXmgTlaYsVGs=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92edb12cdf2so132863385a.3
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871119; x=1784475919; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r1M/Y6Dv0V9NOM4+/puP8NWosRoeWXHurd+5rEoqGA8=;
        b=r8fMRM92tPugKXo3m09M3vfskTxIulRGJu1PasPBoUSC/izZyJbS5Uyz6XFRjKuz4c
         OvbTO9AbFulvX5WUcvBmJrpkTyMR4AJCCrVMionvZnUEO6P7Kf+wvglGLjj+zglRqkJt
         FWkur94lLpM2j2CnaroLZ6g7TpzqpEqsmsbkrw0aALVbMucyyiYmGOgDKERF9eS35n7u
         CpSdXcFgBOjzFEjJ1GcGOzTBjnE/dr88P+yoE1gp6gzTJd9c+WNGMLb1x5+SbY7/w79S
         S8wVZxjT8Ly0U/QszJQoSJ+cLVz7xPSRfocMVDjNrZtqVXm6E3kaEXMH4ej35jnatK5o
         N1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871119; x=1784475919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r1M/Y6Dv0V9NOM4+/puP8NWosRoeWXHurd+5rEoqGA8=;
        b=k47zo2zV2k2zOjlk/gKN4OtxPfjFeI9S5P8YJtUkx/9nFIH9Dq4c7UbXX6m/uojX3r
         4v805Aj9Sb57QDUWtDgYpRrQBqRhLlYd8JfvEUq/7qOtTj0fb7dXBZvt3OJCxkHiobkK
         Uh8rG3fUuPsnFzUyw4uqCemcQ3hGrsfBNUNLN2Oi8weZrIspTl/eWFElDS86MNzFAYyI
         0nqPJb4z/bzReWgyImd5oLsXvByO50FuueNC43yhcqPub5/G5fzZJc8fJa5ozJQ6vAcL
         fkkTMzp6zk2gcwjNBFFEuAd/6Xqg046zPxbQy5PjiPZ8xPTT5rwHxLAKWcyQg3QyH8mB
         R3Lw==
X-Gm-Message-State: AOJu0Yz0j6mXJZgCR1bGPsKncjH9GoGaK1dMdPa3l4MihgIRk+hHpCzx
	UyeZjLp/kiVMJdRafXBpkBNpohqM3O48gPXADi9g2+fGwMnbD+OKU2DwrmyoeWR4KvfgkNd/GE9
	lAC5h
X-Gm-Gg: AfdE7clHKVRyWLLDi9lsLNRdpwSL1KxhWSjxyp0WIIhgSyJCGUZBO5U1Xh5WUtClNdM
	0qPhHsnwZWseLhfyJfSlk+N31sfw8/j8hSwOzBsIjRzWUcpe98t/nWz2u1KbxywJT3ymOnbVNfZ
	DoJ3kKFhwjY7fWao3ZCoCI5kncd1/akxNX1khi3Z+b1juCtTwuuqV4bdfmJNFhyhAbqYYxY1hmW
	cLMtVVYLd16fp0oheNJwQODyIdWR2dQ4bSjpSIs0p94lvB601UwnFxXYasf4B+0+NLOy1wjEYj6
	VHiHqNutdE1nTIAhWHu7ij23n7bK1DfcWCnN7Jp0tJKANzBKkA1hv6Ax2WD22pjsxM0tqpzmlyM
	MpQ+L4t1AQX+W8T8JVzfTUR0qvABovadKDq4XhzqmCIsvElkl6ZB5f+4MJv+mlPUs8re1KeRags
	a1ZaZezhPw6mT3B4ccA1vr1Z139qFKE6ZJMAUxbfYO7veX2D3HJPppnfZyW1BAiwJENTdRR9XMx
	nIMfTvUBwq5
X-Received: by 2002:a05:620a:480c:b0:92e:6533:26eb with SMTP id af79cd13be357-92ef2bb48d0mr596324285a.6.1783871119197;
        Sun, 12 Jul 2026 08:45:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:18 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net
Subject: [PATCH v7 02/10] mm/memory_hotplug: add mhp_online_type_to_str() and export string helpers
Date: Sun, 12 Jul 2026 11:44:56 -0400
Message-ID: <20260712154505.3564379-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2973640007
X-Rspam-User: 
X-Stat-Signature: 9zaftgiyfr5osmb5jzjgpneqpjnxc55u
X-Rspamd-Server: rspam03
X-HE-Tag: 1783871120-129803
X-HE-Meta: U2FsdGVkX1/MyQteiqYsL/gXqIm2OTqmKkVtqZOScdPxvrrNYEcd/i2cr/9jTJNIBVI69kT+cc9dPFtJWYSWvFZ9GkTLic9KwOycxy4ri3R04QffTkGmLR2/i5AGQo8YPbUU9uZDCz3MSw8V5cdCUMCH/Pg7ZTT0KHBY4ylsg93hXcvBLBMRXIKPPgtB4DUFiwzWbAtyi1iISViCtMM9xiNRnfkRJyQ32QBll9VWPHF2mHOUNaQl4UbqXsPRBiebHCNXb9HdKNC1iGJmO9ozvFPohK4NY4e1WSu62g/hLwGDRQ/XPU6cczXdOErbCmC+G1dl0x2Icomm+tXNS6V/7Smn9p8nr+7gZRjoPRCjEbUP/mTbXmvUAlhGtjDBzQ94SSDtGQYnEJSyR3TJhKr/ZC08wN2H8V8YHYqcMc75Sxa7HsmwSfPh6KvsuZXLHvFmcv8lPSaiMBQ1Fr7/rby3x0revFk03I5V4+JKTunFMOZP/y65BxqS8+ezSKZv+RI4Lqz9k+GpAjkelcq2GllA/5B9CeF4h3M1uNno//TdY7RTC85PnJQKvCct7dAUK819ZZTlvuzOIWkw/BrVdE81zN7f9Sz/K5P+x/xgscYF1PLogF/4JONVLcKEneGimC6BIt5HUGBEm6gt9FJz4iPbGiG5z0HsQ2rMI/IbtpR9o9szoMtlPc3MzlN2KtKYw0M87rUV4QNZHoG1+e8Y42n7au3JXyBorBMw6uEv2q7pwVkeVo0VsWOyhb0UBJ+ZbXwoa3rzBBWMJedCJ+hFMkNEDRMCg1M14gBgvVwC40ziI/QfX40layF5aBzBdPO7wgFCmK2Klu963TkOXN5T9QKc36waKa2MgnkVEcXmz4Vh5z51ICh52Dx56/K7O9xDFy7c3mEXvb4fcazxoTMzTC4vUqwPUjpGpZg9QqMKYVF4+ptBcNBMhofPLW0LGSNeSWims0MMEyHLGN1uqG+Qku/
 NA0qm1BC
 K7NkaXRnJ72UHC41JUFhlSrks/ZqM3ZsRrWM8qV9iY5ulSVkNxPsn5h18Utgr8F2PC5xa7m+0jELZt/yndJ4Jj9MNDGu/P/hm8vIafrBNuApQTCL2+tyC2F8FWHtp/TuuQ7bsPNU8Hca+0fV6iINfRmRAdKPIoR4CvltdbtoehSQKfdVrWGE/rtL/W6Ctf9a0nSAWq8t3N/kEXsAbX4rziLdGj0oZvrdEHT9Mp6Pxjf7zYQhI8J1+CWcmhIiNJF6Y9p/lapgKNaYpF63ULs+66Jbg2kQ1mqZsJsR7I1ZHuM+okfVtiRx2j/QVZmHZTpoMipmf94TZQy+TTTNMgEV2MSZrLEScmAMNZmTymuYB6kNnoH3fn78d0sIbk6tK4YqtRaUHt3bcwVqrpnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add mhp_online_type_to_str() as the inverse of mhp_online_type_from_str(),
and export both so a driver can render and parse the memory online type
through its own sysfs interface.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/memory.c          | 9 +++++++++
 include/linux/memory_hotplug.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index bcfe2d9f4adbd..5eead3346f1e3 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -46,6 +46,15 @@ int mhp_online_type_from_str(const char *str)
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(mhp_online_type_from_str);
+
+const char *mhp_online_type_to_str(int online_type)
+{
+	if (online_type < 0 || online_type >= (int)ARRAY_SIZE(online_type_to_str))
+		return NULL;
+	return online_type_to_str[online_type];
+}
+EXPORT_SYMBOL_GPL(mhp_online_type_to_str);
 
 #define to_memory_block(dev) container_of(dev, struct memory_block, dev)
 
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index f04b915678dbd..8f6da2656f4e2 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -127,6 +127,7 @@ extern int arch_add_memory(int nid, u64 start, u64 size,
 extern u64 max_mem_size;
 
 extern int mhp_online_type_from_str(const char *str);
+const char *mhp_online_type_to_str(int online_type);
 
 /* If movable_node boot option specified */
 extern bool movable_node_enabled;
-- 
2.53.0-Meta


