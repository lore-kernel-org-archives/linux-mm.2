Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66273CDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF4F6B00AA; Wed, 24 Jun 2026 10:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A3B6B00AC; Wed, 24 Jun 2026 10:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78F66B00AD; Wed, 24 Jun 2026 10:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA4B06B00AA
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:58:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C860C1A25
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:04 +0000 (UTC)
X-FDA: 84915111288.30.F2564C5
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4051418000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:58:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="QTplfu/E";
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313082;
	b=dINzUiUYK4rdH811y7ZKRaM1e3APXNX551lxQTOjTDdxWrPwMUSOTZvXFCYwDJ74UN9cbY
	uTA61KjIZdI5hwdKwPpcnYAe8IEC+C437nJxu3qC4zb6cXUZNpaJdrCZVh8OtNplLoFSga
	90fIKW8obQlAKkFLbaoHdVEXf4Zvq4g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zb2DpzIiqwLq7NyM2oLUvxWd/WuB3n7pHvXvXxwOytE=;
	b=CBms6XtZSfuDBwqHKtBj6725ZzvHsJXhe7PZu8c+ZahByVeoYZ/ueYx0eiQHKN/WKhtjhC
	xEsR0B3uobd6mXEqafBa/ybPiS7ht6dH5ifzGFPd0D7I0r1nxTF6KYvR4uDrZa5ZZ9BgiH
	vg8yZRztqWw6Uts/o4W7tdDb4WEnNUs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="QTplfu/E";
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5177945a22eso7806901cf.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313081; x=1782917881; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zb2DpzIiqwLq7NyM2oLUvxWd/WuB3n7pHvXvXxwOytE=;
        b=QTplfu/EL7+CuZn+1oc7t7mZ1H4AD8XbMBE6eLOifvSgtrhgf9RLdMRNc2oyqk+D2S
         +R03Wv3bGD4I2R2+HNvrnPp0mJAT0dE4ijwGG2nm7Hu1poCWVFhB3tMoiJngepowS4Ei
         7fgsbMPcKA5RcP33SImjV/deNyW9Wf3ygq2i1dxUt3ZxQVmlMx1+VZOGRMXex3ia+WF2
         EmFG09lVXpwjDmJRGJW2Vhwm9LAtIwJEpb+NCtmtWhW5kIevLuLjnSa96cnS8Nboz913
         lQGBEnhSkDwiDOlw6rHqInh3CS6x/fPBqUg3yM1K132Ni/j+EUyCATSgMyOvYX0mXk/m
         iraQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313081; x=1782917881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zb2DpzIiqwLq7NyM2oLUvxWd/WuB3n7pHvXvXxwOytE=;
        b=CmF/ffusJth+7/S0A1s71o3vWqEfgq+ttbZ9nrxZwQvAq8fcsyTxg1U/v5iWjSiq3f
         6tfeVqBYalJRxB5hW264YlPFmOyjoF5miKuOBHcRj/6llKfEqUlTGeMgZn8sU/yzCsOn
         DBnSoLzSksnHf4vbRVunJxnHDUv4f9+dM+bLc7JrVD0maqPOy+Nof638Jmm4Do6uIS+z
         g6xe/F8k92OXLX5ht/QdWQxkyzeUKJFOaMU5BH2a0G8Tsy5lf6VKTgxF0lTvb70sRwUk
         X5/g7enQzMxK7AmkU81sWZlwLH4yt+o/DCwNSLz67twVXBqPPq5yKgjNAqBxScZHCfHT
         dC0Q==
X-Gm-Message-State: AOJu0YyPSyw63w1vQmJsy6YUHOPbl9165xRw/KhsNcktwF5SbFwQleqa
	E/FJpkSw1Sdb80zotYYkqdyVHbeUrKffCRk9YRw7r/CgD31ibSq11mp4bUtdyxg3yKxy7tZ/4jU
	5G25e
X-Gm-Gg: AfdE7ckolj/Ftul+df/mF5kXFQYVoHQaKvqCIW2T8qHtQwKGZJDzqxlJipoA2YpKj0B
	9sMx9G+7TUKTOU2qFcP85xrrtJqqGvss1R3KXzjqnW0HfVJ0OV5vFJWe4bppnxV/d3bnIwtVWOz
	sw2z/eRaLx1Jo0lngvVAcKvnl5b08HsrrqlqMin61Qr0gW90h2uOpaAX6IMfwZm0zrv4YcR/OX4
	vp6RDh81zovCv5p+aFUH4qAPG4Tfq29ozNs6Tls17BtLFykvba6oQ6Q60dlgTO9WCyjJj7kN1g7
	JRyopvXM1eEr6+HYtMNeDrIl+DSq8+0TuoiLZhla6UmephF0bAOCgs8V3gfakF4+9OG6w2UGyD4
	hSNWb6jzwv5c+ZBk15iSW/h3bhEfG9odB9hCK+ylp6sURAQ9psaKk9oMAOKOOgNlTMXEVzEjTf+
	Exa7+kY008WfLPbHnhnOZZxSGW3lCtwOWmVIc1SZ7ct1Oa/C/nwt191FfK9tjDSrNvrJlDgXJ3G
	g==
X-Received: by 2002:a05:622a:130f:b0:517:675f:3eff with SMTP id d75a77b69052e-51a61d30f45mr54054471cf.10.1782313081085;
        Wed, 24 Jun 2026 07:58:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:58:00 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
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
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v5 3/9] mm/memory_hotplug: export mhp_get_default_online_type
Date: Wed, 24 Jun 2026 10:57:38 -0400
Message-ID: <20260624145744.3532049-4-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gftywodx9dsqfty475x4y313xxg6gaiq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4051418000C
X-HE-Tag: 1782313082-916485
X-HE-Meta: U2FsdGVkX18LwSyzA/CoIZpXpN5xnAnF6stg1ttRUUds42YexTnby/ZFawOq63cfghslcWHJGrLSIWfZpjfbtrUmo/vMN63Ss5FJPSRgSPAw/+J95iiMI61/zv2T5jEq4C1iHZ3853nmIRi/hI6rNvopQ/O0rzxu3zRLei3oART5g04CsQS3n48Oiolfp46wHZ+muqa1LWYCuNFSta7CiHL/fSPNHOXjmtvUm00N5+97K5vbT1Th8LojuPrjClI6OfwuxpuUwFBcJ3xYZLEp+kA7uB0yzAH8jtKtdbyzKHqMnUP5/Pep4o1LF2r4c7qw7G1q6rasC97tYd9n3BTM2As+AbzrZj0eqknl4221e3HZurVGYe5x7O+CeXtbeA5vXcqmroXbDLiQCK43m6J7sAoX4ioGtce8LulHEa3xKpuUW9xDHE7N+kAB6lc93fapL6VYU49LF53Bef5CC+nuJPOXNjpOuuR09XFOpX58uD/Zhtc+35ByVcemamTgKQGGoZ3AatRxWhHNPiJm5ySkgJH6A5F6KyPPQxc6LGAg7P4eKrAgeGr8+Omivj7RIEm8KHhC5CMkhzDp1V/jc9oUtbi0ajHDV9Uh9/QcGLloZeotwuTScB0UhXmlrg2JUVAM8sD3vT106rP/iJQUfDtro8jwQEhk7N0Inz7Sesty4pAWy1PVfZt5leOPwmJH83qhiv0NGurhmC3zVLzIbnD5lXs9YPv6b6bLhPXg5FvUTHWPl472xe3hmNayeETA4Krxb1XdNPEJSBKbdNZoH0fI1Te6cb3AUDzdHu/cu6kIF292y584dnaZ6R+taxZbsq21uReOspX8wG3OTXNRl58/I06HlmHlj4z0RWEHFVyrBUOVfk9LhEf0JPNeM3i+wC0An8HvlyhjUBLPoLamsh+Mi4AgrZT6reVT/47Pc6iikIPLixIIb3JS18kgkJDKlBYT3U7h1MdW1Ay8TBnowSL
 QkT3dOHH
 Mgo8njCz/lp2tSR9DYqTOjQ7T7oV16olXKQ/pZEwXcrMgS9jGkwMBBPUUEqdYMD35l7PGygAI1GygK8ghjpw+ihyEYpJwAWibfbSUumddzUBVGv4zN/AdbGk6qTPaHXZQqW0R1Cg43i/Qy0CpCLLw/SZ/075G8/ZQgWIFbuqduYowSXGsQFlY3XDB70e7xOjCjuSewHs1x/DamivQ97ybKd7Ipb/zYiWZxkRcor1XPbTmB6B0ZWl0js/Uvy9hRNdQIqIKzPea3JyT95wHMpaBHbQjlKpwHObeBmVv8+C4Fv0rUwTFyzax721T0j3dUSxrOTpVVkcx/6Z+btEegy7MJpWUn9flipVo18mLSRIj+iNgU0qxU21W2Nm2FQ==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memory_hotplug.h | 2 ++
 mm/memory_hotplug.c            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7c9d66729c60..f059025f8f8b 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -316,6 +316,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+#else
+static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6833208cc17c..494257054095 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ enum mmop mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(enum mmop online_type)
 {
-- 
2.54.0


