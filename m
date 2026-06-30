Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF7EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B76F6B00A9; Tue, 30 Jun 2026 17:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767266B00AC; Tue, 30 Jun 2026 17:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F8B6B00A9; Tue, 30 Jun 2026 17:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 287DB6B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:18:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95C26120139
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:54 +0000 (UTC)
X-FDA: 84937843788.07.E86789A
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id D055D1A0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=prcf1tIa;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854332;
	b=gu8I5IL/zYrE5H1jFtDSRTiikxEl66G/q/buJ9O6LRYEE9vt1BpzyhlyjFW4xHDcWefuW1
	7YVRPN/T3tOga9d8r42k6lV+pyryVCAUqbtI89YBRnkkGJ3WlsZEJG1yzX6APQWG4AUNaP
	udRxlmAYr71/QJT1Etu09PY/kOS80Pg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lel2Y3CZmRG0qaIuB9j1lDgS4wpuSucao3lSJ/Gln9c=;
	b=3CF2J6rfjfvLLebZccsUeWcTcNzviGD0wWu5XNw2f5mfY9dFagAfmL+OOtY4FNdAYE2FAJ
	jrhZu58ScVybWpkgTXuuOsHQcSAZO969av/afBC5MyNsNPOKEvVYo3IA33DyJKj5CkuAST
	5cOSZfaYY0QCte7tdrRdG0cBZ7xkTQE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=prcf1tIa;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92c7a0a7059so331980185a.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854332; x=1783459132; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lel2Y3CZmRG0qaIuB9j1lDgS4wpuSucao3lSJ/Gln9c=;
        b=prcf1tIavznSQJGBl0BxD0zKUy66N2Z8DrurDm8iVOAcHV3c0G1inO3e6ZNoqxvgcq
         RN840MosbBTuaBCwi8BIqak+P+q9KrlWpMiLHrRZRJVRg5htzlgdTUy8JZG3t/hqgnWK
         nRWfQeuHyUJFtzO17VRCMBFxF+AbaPryC/S82s5wXMuzqwnyjsKo/3ft83BNDIB11AZ2
         OZJp1qEzcHS4Q3bzlKizp8LhaD1ORen9I4XjDtvktC49kpqgCLPvRSbx/fdUIkeAH6V3
         wf8G9TsvHfwJ5UvDS+TOzE1iEuAfPfGfboC8lXn+x6spSpKuPAaqg6eZRaQbN3rX3kpK
         W1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854332; x=1783459132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lel2Y3CZmRG0qaIuB9j1lDgS4wpuSucao3lSJ/Gln9c=;
        b=bWUA2z8ttvuN1JBNmQ8Gwp2k/AJkHIlGGpoNgKIjeAX3oM9mtJvOwK+bTGWW8ZggiK
         TgKHNLJKMBpw9QF3k1ZRR5xCfd1FTMajJ0KS0F6ycCgeNqLfC7xNRzo0MwlqVaepWcOO
         8LBWz3sLvS//mQ0JaxwVl1oVtTUMjPrObjL2zvCHRAhFrReh4FnMD5NAPIjmdyL5I+CB
         i9mByB0f8KI/oMUqlkeNrlcS8jXGlP3fRfaK0LlcDtG2MxQiQ9aZcAYBzxbCsthbqufM
         G23JUZMCNP9Um+FNBHOPeLJsVjPkI+lL4SWXPWKNgKo8Xmh5y5kyoppvPV/Ox8hsWS3V
         3VkQ==
X-Gm-Message-State: AOJu0YzlhM3j0Pru7GPI3L5bRLRWrYmy684KQnFYkHClgo+yuRSwiqIt
	oZrr5mfNAGua+hlHRTOo5v63edmlIy6E2iZLXDIPQMI/N3253nET43rHKyNOwkoMzwWrQ4PTw2n
	chXed
X-Gm-Gg: AfdE7cnVWF1dWlejXcSywXtt3DZDVpArBtV+P82PRiSG889w7dp4BFbm/5Fvs7bMeoZ
	unuwA63hatv66uEx817nn+r1Jk++Ae5xoHKhJTHiTFHIFjT4xssvj910/IEHJYm/fYT0lvaFlRB
	Ef694jjrffm3sbsHYIqlKhtzUV46VxV6H5PgWBgFNE8hR8FDq8LHgxrH7YHuDkPTfw1g7LvqjJo
	lYmTH28s3KnP8gALLtCXAy7eRGbLerFHmDKafh8IAMEb3OdrbooLN0ZiKHU+yNcGSGXbxOJXzq3
	hmjnIn2OUguwJIPPjsTIQQ4Yb93SYRanUYVSJ81gUxqxW7eaMTgv1vcPAH9zbxkk3c2wT8sJA6E
	/lbwm/mivSGbPxfrfJ9QSXKO7ThENhOfeFaC3UbjSeykfY1+Skb52OH2k1X+ATf9G7nAnvutnLN
	cG+9g2J7JEYaFlD3vq5/RPau06M1tIYTBeKVd2XPUS0Ht2LwGzUppBG79LAV4Hp2USnaE4pLriZ
	A==
X-Received: by 2002:a05:620a:a190:20b0:92e:6e55:cc66 with SMTP id af79cd13be357-92e6e55e500mr269113785a.47.1782854331991;
        Tue, 30 Jun 2026 14:18:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:51 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
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
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 02/10] mm/memory_hotplug: add mhp_online_type_to_str() and export string helpers
Date: Tue, 30 Jun 2026 17:18:34 -0400
Message-ID: <20260630211842.2252800-3-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D055D1A0009
X-Rspam-User: 
X-Stat-Signature: o3ggut38f7edkn9xxkne8b1bu5y8cekw
X-HE-Tag: 1782854332-31992
X-HE-Meta: U2FsdGVkX19gb9TRZr+/BO4Vl08k/AgkfaXJ2IKTayB1gtKrpkNwZFmcWtr3rmAQ60FHRZy6wnK+5EGspicYMuS3V11HHdWo4zCkd6KTeHPmkR4ptZvInzfuny+839q4WTyUO9Hpi6b1aBoN9V1VXWrfO+3NDiecPafcajkxXxpoMFby8eioNQHXSm9cPDaaBW1J/xhewiiZ/8ms0Vwo94nqgGhWE1SlkhQRl2nh7EPQfpEvqMv/nS6xZ+XbYeJqM1WF7ZquC9FlNLkIvOsaExWbTVjNlZp2irJ9ou7Rj+YfKuB22mvFcrGujfQO8TbjUDl7dXQbXMwCSvXlqKM+ujC3YK4R2aGPew8/gmSsRKoNdEDY0Rqxb1ZNWBRr7tFRH2H3hmPisznmky5RKKUPMwgSs6S3SUtN2jb7vLrfUjHNNSnh6UVewOEA3Bz7LB9oNO1zBRrnAkyk3MYoJXpgXyhA5FIk+XZBKkB9IyYzjeMB0eCV+XdF7Zjo8mMSMQGlEDNtmPJ1pnYGCysXU/ASNamiGcSevBKr1EMG8xR0TjWjd35pSXjfnRihW200Dj/qX7UF68uaDCNP8QAEi7WxwVTS0znnVPDhK9EN2qpjSObXYNNTRZj976sWuiy55ybi1KuuBM1pmacKPtgo8ih6LHr0qnpGnkcBMg5yYrj0HxcvgcsEAWeBHrOFQIorsshFctp9bhy/45+XfBgIpvjOgoOceBo1dGtu6qmn472xiG35UBzH0VTZ43+nQVo1tTH6SzDW9wgQoME10XG28+asUSmQ3Waj3EjFGsTw7BnvRqHemYRMdM8io4WLmLQT+jMsxnS5+mkeyv+ieNl8jTAJqc65uVGG1Y5tSyd3wsxx0gb89QUVhCXbyE1JITc739On1bqi//bCfUMJYzJvI2Emkikb5uyP7GZHG6XcINDW9Hrt3lxJSmKA5PS47d0QI9VNiajai6glJJ0ChVdNSV2
 n0Z1/bh3
 IG0BRdrljLSv9zVrPkH2IRAKLScZEoHolTYB6ytcHjO0xTQ3lJiDaSuOHXSImzozB8WSVO/90GqL65joVXP2TXBWW6hBzli7N9Gr3kHB83ZinMKZXSExB+3ZATOYtYf54s6efQS9s/EUFbRx8L1Iar+dh4r11qWaP0MdjJOKxopHhmP0huNnANlgpSA2Y/AFOA1bHfayPirrIvSaBM40L8jFFqAxkJrlJcjH2V3Ue7fZYo34nPdonAySJqKCsQPsceMJX5aijWBKloZ3P+fjeiYJeN09Y/75OSLIXRrFwrIuJRJzs1KXA/thbTOBcW8yZKRwQzs1Wu6dpw53r98Gv1/L8+5imc0j9nkZU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add mhp_online_type_to_str() as the inverse of mhp_online_type_from_str(),
and export both so a driver can render and parse the memory online type
through its own sysfs interface.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/memory.c          | 9 +++++++++
 include/linux/memory_hotplug.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index b318344426fa..3a2f69d3af7b 100644
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
index 7c9d66729c60..5d4b628c4a1f 100644
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


