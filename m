Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C97DAD31A2B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 08:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2E8B6B0088; Wed, 14 Jan 2026 03:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A816B008C; Wed, 14 Jan 2026 03:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5E16B0088; Wed, 14 Jan 2026 03:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78E4C6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:52:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F80A1BB69
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:39 +0000 (UTC)
X-FDA: 84329953638.09.8010187
Received: from mail-qt1-f193.google.com (mail-qt1-f193.google.com [209.85.160.193])
	by imf17.hostedemail.com (Postfix) with ESMTP id 750CC4000C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:52:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fCu17YZv;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.193 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768380757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HDpE5wtoJCiMhRN5zrFeLb7soUJCKnfGA3SqaObqP6g=;
	b=j5Hqb/JTPZYW0mKJBc9wSq0j6Nik5nO8VWGPw9b6ojo2W8dexjxUY0MaQ/AeWZL/FeCEaF
	ZHcgw4CrZjhVWg82Ruh4HatyQWZrC6vDHRZNzQkr29SRz4UKFzvMpSEH5mDK/eBRhkg6B/
	22hrW6zqWs4HZtgA7PhnzM2iZ7A89Fc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fCu17YZv;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.193 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768380757; a=rsa-sha256;
	cv=none;
	b=c16yy3GruXx/b+CcGJYp1wdDDFBYlaV/r7dymrT9wL5EZRL/iLIxjw2DJfsE8g/arHcMTN
	+HPM/bKubDtGgcBJ918fPSi3ldV2e36D6bgTk6VL6Q3vEFXwjYfDXlL5sru7IweZ9SXnYl
	9zzaVkAq/MyEvcJUSNy4Lo0pYgNywJI=
Received: by mail-qt1-f193.google.com with SMTP id d75a77b69052e-4f1899960f0so92446651cf.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380756; x=1768985556; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HDpE5wtoJCiMhRN5zrFeLb7soUJCKnfGA3SqaObqP6g=;
        b=fCu17YZvyAPjxWjMsxeAulVQg+6+37ZoO+xKQqvu228jKWMX2m7A3guY+M+/MpcxoB
         NUMmwEOl9ZROLEKCqYUTZuNq1pY332nObTec6leavycIopdS7HdanjRh4cv0AE2LEeYm
         56U5XwVYLDDOtAOr/iMmUIPfV2ASUYftXw+GOL4ndnpwV6wfXvOIEWkbizikrWIL8yfP
         p9mXGyL+JZv7DCqf6YQQGUrx/8/uGsqtR48a6Z/2PZbAo1xsgs54MUFIDl4CPEXEKM21
         abHb+cGE19wqcMZjK1E5vGod5xnIpjyfsbgLeIWzU8jt7IVA3tqfmoIqRQEO30bgeJwL
         l8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380756; x=1768985556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HDpE5wtoJCiMhRN5zrFeLb7soUJCKnfGA3SqaObqP6g=;
        b=j/pEGpcglJsDuIUS2QR5LH0tYmOcOsew23topYP6lDiLa6pezHHH1rUbldtv5rLrVb
         jkCA0/0QL1obS1Gv+JUMfoET7ryKCLpsFKEeOLLFmAuzsVVhGgwlNRN3Gp1bp+VwP53K
         ZJ7nfd9j+2jjj0Jm4U72tgdyVqkj6Edzb49cVilDTwVPHsR3t8QM1PA7xbmG9cOXgfEJ
         08Gh/Wv/T0JuVIkC4d2PpP04KPptXKpgFl2Y/BnUlAjCvtD9bFvEkv5dORkIej9oZGEV
         UwflGPn1iWSaljMySABAs186VrMSdfOPO3YHCty9Q28WhsiRV6og8v1gWazjT0+mqJX/
         SCvg==
X-Gm-Message-State: AOJu0YzBMNmv9JO/TARq0DFz/y3e8YIwuNTmsnBwEcUX/P882S3Mq7bW
	7VjAn+wKf/JG7NHBatonLRILxqctTlCo4K6wvpxOplUXKHUSogU+9iKMr2LHFXDh9OF9R875oYL
	5GMWqnXTTZQ==
X-Gm-Gg: AY/fxX5DcPLhZjULDm48aUotAqtQxyuUXY2pISm7f33qIhWXR6fI0qZJ07xWFfuAo0X
	kk2fhbQqzlDhi0L3OUwrQ/x5PmjFZzlvpGU8NxdBGUnzpUo205XDWA4sB/22+kmCkWLGxza1nag
	zFfxTc3NUUqrSq+/HKZkC6V1OPysB1VhP6a1ogEJv/QI61YsfKHgyD7a15jeWTehRPr6unGheRm
	f86JenV8uoBMgm5kAA4uZvYoO3eRTkjcc6WXyh+6ouVK0cnGbheIal/t4YICiD3B9I0bUYQm59u
	iI2ZONIwYRBpHqBrFwj5sANyE42YY6G85Fq9r/K+2WjB1cY/jpAO1nmsW/GtyoGKj2P/90X75pK
	SJMogfpO/e85vg4GRUIx5fqVY32Xoye7pMGS09PfAP4DADkstUQSQSrzXpmjnDLIGBFtTu1Nxcc
	Fr3ob10E/jn3pnuzjVC+27TUOmqSCuDriTetwbFF5u9k084eZIVi2r+yJsLlmhZcBQqGq7En5Zt
	Vp9XMfvcifvOg==
X-Received: by 2002:a05:622a:18a9:b0:4f1:ac9c:9388 with SMTP id d75a77b69052e-50148125e71mr26783181cf.0.1768380756171;
        Wed, 14 Jan 2026 00:52:36 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:35 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH 1/8] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Wed, 14 Jan 2026 03:51:53 -0500
Message-ID: <20260114085201.3222597-2-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 750CC4000C
X-Stat-Signature: ssajckdyyqdn8wsn5sxrjagmod5cou1n
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768380757-748237
X-HE-Meta: U2FsdGVkX18UUBYMIdY/pO3rGhxfa0AWLgNCJVJ5G5sEaX5idOh7EaJoVXhPD80xCUArMDU3C7HTPHeBjoyKx33+SOxUUxyNUmISmvYKVyJqL8fPMeaMXRwnNN/yPcmDUfdIaXVLYDGWzXClikXWZp0kRQBijrY4Vww/ok7kOmXZknwyYXR5K1fIsj/8sLwwWw4PupZIXrR4RNkR0Z0NPbfJEg6bXq3Wub/1uWeqHuEnHJVW7534i0pT0OSoypXlxLEFVIz98IMHFiUuFDtzmLA1c/AOtW0RKcsFtntUac6vJf43m2oPS2P1LUHcEIuB9IkKgJ/Er9xu1B5skoQaiy5rKN8XMKuTf7JoUNdyGPJKrpOm4Yuid7Lkgelc6bouAGXvqSzMV9NLXWhZBckn1r5HDUaesrf7TqHw+0sTzcZcH42tTk7pNGUyAA9/hHTzfXjDqhSP73bdSrzYe9SZPgIP3eQxnQ9qaGPZwbH2P+MOM12o7QK0Ziy7LTvXTWM5bt54BbCjFwMfVW0m88IOF4+ilj3if1EuvDaMa2lpJTcrBMb2GAL3MSRRg9XMMV2dubgy57CGKau+t53vy5HjbG+sCbQn9jIhfyG5RktE3EAK1UlHqZAmlkMWZEER2L67Rfom082e25iVKvvXSDg1AYLFZ547UG4MVt+VpRLcQ5UM1CKdi3gTP74mMMGZ7rOIlMCJpPycYsjRd6ZRDKPXW7SeN1ILzxWCmvkHwKff3xlOMf6nPzqGwicSnAv7kAdJBZXgQuHTwZByqcgbjppaaGcY+NvidINGVisLmgW+vh50SH5la/arsGVopDpl9Eoi7RpvJREhOUPMf3ypiZc6ilTGe6JkyppPoljOYP7jtYgM5ADwAzXPaMaNnwr+YKa6HUVut0quTL0gLFAZptAdByYhvBm8yXvxQmMILqY3/+VRUAHsemXgjXlnVapzSXZ5yo2W1iSJTc2y3G51Gnd
 yeuT+Zqm
 XIB8wfVSaqAu2rQaFKuo+QRi7EcD2DOyPyQ8ekoW8zvJxriZBXHGM3kytBr9v0qDddM0BwDIL1JJGONQZD7aIncZaC7hyYw7lm5LUCzDFxbG61F7SLzAdpZnjJx/oX1n0qJo4hsESrcl1hX4xVcyMXKJTiCzpw9pRT+xFZkMh2B8OjDomErKRAWutfkvJi7Mm7hZM+Xx8f1ZLlIh3dQET63ev3LHm5Vq3ykC75GcWzZ6oS4lEKJchklKEPsmaW7WjhS8i76R9w8IGAgMFaIcyFWVYtUlny1apm8AhTL9HsdwwFIjvEXn9e3zsyq0v3gQZPPxXKkFqmZG0AVaolyGYciowLHWaNsDPnmYE7d9sRWwV0a3upd7XDw7fK2GZ+2QPskc/v+KnPYgBOPxQhlvhi9qsbbA8R+RnWSIsV6wFpOypavY/gPrDRtuSmu2tZE1W6WSg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.
This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable. No functional change.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 389989a28abe..5718556121f0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	int *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1578,8 +1580,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
+		int online_type = mhp_get_default_online_type();
+
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
+	}
 
 	return ret;
 error:
-- 
2.52.0


