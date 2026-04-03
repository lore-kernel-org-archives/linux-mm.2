Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16274E8536F
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 14:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FAEC6B008A; Fri,  3 Apr 2026 10:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D746B008C; Fri,  3 Apr 2026 10:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED056B0092; Fri,  3 Apr 2026 10:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA666B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:13:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3F20B89E4
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:13:16 +0000 (UTC)
X-FDA: 84617436792.02.DF5D107
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 93ADE4000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:13:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b67ilBQA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775225594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2OXmkPnk3xdLi6S85WCOSMj2pCVYR8dHaWwnDoveRE=;
	b=D8Y+Z/4OV7N41WjsS+lfC/s1+GPKQO3nMyTtjwKkFbrFZ0Zazm5arBefJDk+yyKgqqInRb
	HwfJIcQFuGq2JTxuGmHISNkQ5R/vKZVnYQ65EjiKkpAvms3EM5G2wVuk3I48F0TrgWFPVw
	c1f9TGO7Ue7967f3v322hVzErlt3c2I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775225594; a=rsa-sha256;
	cv=none;
	b=dSWZ9pRC97GmyyDGOEJ1O4gW9kjg7XSR3qprURBRl6dp/xHQOkQOF2k6pNpHQxlTHQkARi
	i/I2r+S9oUtgc2J4O46+Yc9OcGdlraiEBDPzEC3JqCtoWBmZsKIAQcwiS2hrbGLzwx6Iub
	BJnoyIUMxmNPHne+Mc8gtMu6MsmDs/M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b67ilBQA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775225593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2OXmkPnk3xdLi6S85WCOSMj2pCVYR8dHaWwnDoveRE=;
	b=b67ilBQA2mbKb6VMEn0/ElqdHpfHxNVGR+zyV7YzteOJ+cjfpQvGg93RCZKe5Ydv+E2C/8
	Fi9aBRwQYXsscc55yVfjZAqPhG5wr37c6fO/rin/KwfZUKoLhbV8+1xmZDlOPQ74jOSUgM
	hg5py0UT1V5QozIPeW5TlM7oOziHRC8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-XhbxgI50NNKdiCuza9TV6Q-1; Fri, 03 Apr 2026 10:13:13 -0400
X-MC-Unique: XhbxgI50NNKdiCuza9TV6Q-1
X-Mimecast-MFC-AGG-ID: XhbxgI50NNKdiCuza9TV6Q_1775225592
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-89cd03be011so44949556d6.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 07:13:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775225592; x=1775830392;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=F2OXmkPnk3xdLi6S85WCOSMj2pCVYR8dHaWwnDoveRE=;
        b=DtdV2PS00YQxqr9j5csd+NNZ3MGtmT7bmpmutDWBOiX9dKpsMzGe9K8B4L4rCz9aGe
         5E5SwF8kDwcmEw0/x4OzSv9TnOY2Q12vcEN7fXRZdwdCCAKN7jOSkeaQSYNrmsOCSxnF
         Sk1P3Qw+MYeAnJE/VzIwFpynxV4PVltrNQDS22/Xx26OkdRL3SrWov2wqR5K/2K/a6HV
         fZzvZVvbAX+OLkGgEhk278HMHkHfFKurMB7l096YRu6MwitgBIPODSEQA5bfoeQDQ740
         9+cGUbUPMUdWVFegflv2bfHSANpS4Pqoa7l+vKFGq4s8fImruFWRCXFe9Dh101pSwQzY
         ITHw==
X-Forwarded-Encrypted: i=1; AJvYcCWI6b0VznmA8p2y8c3j2Tze488QAW2iSPJXKLNujuANBeqZHCHBcW65DU+6jui8ClQLosnQjX0UIA==@kvack.org
X-Gm-Message-State: AOJu0YyJSgJf6yNMKhMyEK7lItdVoLuR9PVl0mgH2nf3VfJHW3VQToHR
	6o2uu2uinrtFBMFxKJBUP6FOxqfQRTHNApNx1MeSJFLxV4zmOd9cY4r0u3puUHbqIjVajVR3MEu
	MrhoYKC+oRXarSHg18XCqr8/p3H4GU+lMJxInvuUMCsoi3GTCQtnJ
X-Gm-Gg: AeBDiet3dYX/zB4aB5c2Z4DJ7KF5wRrAO54IZGzSvHYHmoAe37OeESxwVrF1RfEEvYn
	/V48GXuI5hdWGiSXpeb6UevPGxSVX4qs2J3+AmSOFTSnlhX80ShliTaqnNY7LAmKQgK5U7gVvtJ
	JWI1xTkGyYZJdWOARL6FMxLiIt8xN0OaMxBJzS+3rTpv7S6z3u5VkHuY8VeuqLrZEy5SIMhw1AS
	RWnM41fdqeb1rSY/na++nmhFKBPR+flryz4MoTWDJdbi76L9Bmu7oWUDFE+rpIpO73xIgp85R5/
	KqapCkB3oM5HsoS0gIEXLRDqBh7P9vDo+jMSb/FGLrzzPVG8OUyBT2WbL5JOj4P4wmjw9YdmhDU
	BLJejXhkyn4kytAg3WBfxJWJwdOb+3BGCmxvd9v6fQRN2CTO/f/I9gaYQd/XRYu8=
X-Received: by 2002:a05:6214:76d:b0:89f:123c:4d9c with SMTP id 6a1803df08f44-8a7025b7636mr47917366d6.18.1775225592260;
        Fri, 03 Apr 2026 07:13:12 -0700 (PDT)
X-Received: by 2002:a05:6214:76d:b0:89f:123c:4d9c with SMTP id 6a1803df08f44-8a7025b7636mr47916446d6.18.1775225591562;
        Fri, 03 Apr 2026 07:13:11 -0700 (PDT)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a593330a98sm50147126d6.2.2026.04.03.07.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 07:13:11 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 03 Apr 2026 10:08:35 -0400
Subject: [PATCH RFC 1/2] mm/memcontrol: add page-level charge/uncharge
 functions
MIME-Version: 1.0
Message-Id: <20260403-cgroup-dmem-memcg-double-charge-v1-1-c371d155de2a@redhat.com>
References: <20260403-cgroup-dmem-memcg-double-charge-v1-0-c371d155de2a@redhat.com>
In-Reply-To: <20260403-cgroup-dmem-memcg-double-charge-v1-0-c371d155de2a@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
 Dave Airlie <airlied@gmail.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.2
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WdMFgVsosS04hnCJaL5mAgkgQxkj-Qc84427S4MWWhQ_1775225592
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 93ADE4000A
X-Stat-Signature: 5w5r35wnkgz5pkbum3z83537qgf7xmc7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775225594-269324
X-HE-Meta: U2FsdGVkX1+9kOD49eTY4HrqZvrnGqWLskddKAPZdqovPlk6vsP8zITnAR46jEF1l5Dq7k+bbU/1tQRtDhqCoHRWu1xq2LTqLTjwCe9IZ+4TSOIZEL/lrXTvXX1xRisMR9z9zGkgOOujrYt6y6pRmq+OIYEqvZ1JL0puDvcXnyr+evhxE9uSRzIXcgbhCl8+bFYkCqrxgzny63KJm4gG5TzA97OlVbPWJyA7oZM5a56YxT0Ul0Hpnb7SxBjKwttmfBjmkyPCrNdvaAM/TGrJxBNhss/DNwULcarXLfEpz+VEh2QQNHXvMXZvJmr9yHQ1RLFEROXpkbl8a0oqJGH6Kx1ANjTdIRdTnnrzs0RfSOjA9uRBU6AvkEDzhOLEFcJDQ0UZZJE+DFWpd/D6ItWQzT3sbVmrN6T/3Zjd1UNNqVyC1X4nnwojQrSHVn25vu71IWm5GXTPEg4PCQGwb2jp0YKMTq0X0IiauU0xL9P8ZHpi3Y8zNlSaZVINrLngQHH1n01A8kQK50yeyYfvzXhFymn57+40pyvYjoGzg5Dnj9/jO6e3uFm7Nrrqmw+SEtpGGJD5KPC1fLbVbzdmEoeSw5I0YZpKfy2Wm/R0/YVeLjky0ZiLdr3Fc87NipKQBa+eybX/MBfPIVCROSQHpe2oevYeJSFIYgVeXFEjGqMmkJuWm/pH5I4SvZoDIoJP469tfTt3PJ5JrYHHEgol9dQqf5KwFA9DHmm2xbVeH0HE9OcQ0wTjeiDwg8DtY3xoIQzXqCWSR2h0Clkn7MsIfgTiMwy4we8QTcgEMqOqAfqBJlSR9o48nQg/8B662omERqzGyn73fRqrdumXoBlXJCB/M0p40SjF/NMpcXTB3tOTW0s53coSxr1qSnbqZkwq8A14laUz9QoeieR4XkFLyT44JqBaCUPBQOhQTIG//KflJCeXGTKCIW5UdBtDl5ob9W66KLYmPcAZtPXeBLZo3sG
 DiaMHvGy
 4izN5HpGikrpC9XQnFvDK08F9iYMzg2fXgdg3vpQxSa8HS/r3pKbzZbh+LI1GMXbseB7/rLJAfYBPkzH5ng515uQEVMYLqFFbo4nXXOx7EqwCvtf6I5To4268nzw/+b92lX+lZdVQONckz+NIu2+Z+cEm5/P8FHENCWbZAjn2vorNsH0NZqowmykJvsHfb0hr/GrgJ50+OE1lJd4g7k9zbMHv6MpSj4inOdeYWVdEjeFVzql07lW+1bZMdobsXn+0NLpZRb+O54RfjOmHolVKq19W5eXKIFyPx85/03LVH87Z2hfIHfFXxb+aifm1tK707//Ema4VSPEMXtgd88d0kbjsRvSY6CxY5GLxtRhAB6ClyRMyrFLjTRFNH6KoJClAOej5ayJF8AGnSrcVCxAjEH14Pqnh1Qar+39EWlhAxanZ5auxS79ixyLUnjh5jtxtSpeGHvcvSxb6YcZbm66fe6NWrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose functions to charge/uncharge memcg with a number of pages instead
of a folio.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 include/linux/memcontrol.h |  4 ++++
 mm/memcontrol.c            | 24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 70b685a85bf4cd0e830c9c0253e4d48f75957fe4..32f03890f13e06551fc910515eb478597c1235d8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -642,6 +642,8 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
 
+int mem_cgroup_try_charge_pages(struct mem_cgroup *memcg, gfp_t gfp_mask,
+				unsigned int nr_pages);
 /**
  * mem_cgroup_charge - Charge a newly allocated folio to a cgroup.
  * @folio: Folio to charge.
@@ -692,6 +694,8 @@ static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 	__mem_cgroup_uncharge_folios(folios);
 }
 
+void mem_cgroup_uncharge_pages(struct mem_cgroup *memcg, unsigned int nr_pages);
+
 void mem_cgroup_replace_folio(struct folio *old, struct folio *new);
 void mem_cgroup_migrate(struct folio *old, struct folio *new);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 772bac21d15584ce495cba6ad2eebfa7f693677f..49ed069a2dafd5d26d77e6737dffe7e64ba5118c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4764,6 +4764,24 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 	return ret;
 }
 
+/**
+ * mem_cgroup_try_charge_pages - charge pages to a memory cgroup
+ * @memcg: memory cgroup to charge
+ * @gfp_mask: reclaim mode
+ * @nr_pages: number of pages to charge
+ *
+ * Try to charge @nr_pages to @memcg through try_charge_memcg.
+ *
+ * Returns 0 on success, an error code on failure.
+ */
+int mem_cgroup_try_charge_pages(struct mem_cgroup *memcg, gfp_t gfp_mask,
+				unsigned int nr_pages)
+{
+	return try_charge(memcg, gfp_mask, nr_pages);
+}
+EXPORT_SYMBOL_GPL(mem_cgroup_try_charge_pages);
+
+
 /**
  * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
  * @folio: folio being charged
@@ -4948,6 +4966,12 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 		uncharge_batch(&ug);
 }
 
+void mem_cgroup_uncharge_pages(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	memcg_uncharge(memcg, nr_pages);
+}
+EXPORT_SYMBOL_GPL(mem_cgroup_uncharge_pages);
+
 /**
  * mem_cgroup_replace_folio - Charge a folio's replacement.
  * @old: Currently circulating folio.

-- 
2.52.0


