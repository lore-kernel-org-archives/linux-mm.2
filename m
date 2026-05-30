Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF61FCD6E52
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C8E6B00AD; Sat, 30 May 2026 18:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C9D6B00AE; Sat, 30 May 2026 18:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BCB6B00AF; Sat, 30 May 2026 18:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 212696B00AD
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:19:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B58F81C18DD
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:46 +0000 (UTC)
X-FDA: 84825504372.28.77AFCC1
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED6BBC0009
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fkdcqJ7g;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=087/smJrDH1Ri/FmSC9bbtTtLl+ESvDrae9U9V2wtSI=;
	b=6gpibSAS2W3oYkBqk6Yio9+r2n4K3c94zwopR4xqnidqq10+ZNgzhAYdIehv5UrbZGcN4o
	gyup1hfFWDKTVfzXUC+kOo2pDh3066isGb4KiJVf9dxneMNeNkMnW1WOYb1sKQGAA9RTN3
	C0mNWHdcvigO5YfG15eFtVMhuJEpmFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179585; a=rsa-sha256;
	cv=none;
	b=AysHivEL6GOBfpLJSteDCMYN0TUH4ljfeg2LYwBZse6u6YV93uxKz3RF6L/8XtV+fj7wVQ
	ToVvh85yIb1m1ionD07RQKkqkd8veJhRBVYNoRjW5H2mR7pASPnEYOBBjNfVJC/TOlG8k/
	VKZhO+K4ld+bgAssewci+Kw0+FecNcE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fkdcqJ7g;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-914ad42e617so1038385185a.2
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179584; x=1780784384; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=087/smJrDH1Ri/FmSC9bbtTtLl+ESvDrae9U9V2wtSI=;
        b=fkdcqJ7glcIoIqR16zfoCQKsPGK/cwGGLoKqkko/KC76UsVYpU3cehuajk+73n3Dea
         ArdygVeBp6U38qcdC675kxcTmIKfmf/c0mpolQ5LXWciTDVb062kZpPrusHDfUR/uVvi
         rD8u/dl2NcMZmoyjMPhGNFJqG2QcYWy8nhzdujmy8wlC7CiW6vm6q0Xg26kAYExTQpAt
         ysSu+HoDpPbqC3RmysHv2yOKL+ry6UsWziJrVPsnhYOoNPcIOeu3sinTTUa8rsoLdQdD
         kYoLe3f4hIs9UVxtjIH1m5fH17Ds7Tj/lMFCuDrP6XwIvaRAF8Koruali69F/7RuU/oR
         FKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179584; x=1780784384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=087/smJrDH1Ri/FmSC9bbtTtLl+ESvDrae9U9V2wtSI=;
        b=X23KqY1bZY6UR8rj7zk+licKn9n7bxOXHwwox4HUzYUuWfE2MnJVniwKbMXcK40FX8
         dRkq7JblIsGYUIXFR8ejoPHJdOtqoHySrAa31olcqIy+lUv2X54IxWyjjBJR73QfIdcE
         9gzTJj85z5x4ih9VSOFkkkVe7/xQ4X4M3HgJ39b3TzEfd1oivAFc6pptbebM+R6Avq65
         v4mkez6oBKbrgYedbjZP3rGqM1Uqn6lmj+GctNpfMP/f/m06sOS65phDSv2aJNXnJ/wj
         z9EKtrKqK4f886ud8RyJE/+aTBEAdlhU9KEx++WSQ413cu+CqVWIbmkphxSvX4h3Steo
         i1WQ==
X-Forwarded-Encrypted: i=1; AFNElJ9SKj5GzNw3Kio/uy990xwHOgG9tnJOFKFLVKT/FCS7teYZNl2Xr6bgoiYGsguRo/OomOHUNcTe6g==@kvack.org
X-Gm-Message-State: AOJu0YwRACFz/N1PNd/Yv3K1fSjR05Ad3yr0TUep7mF9Y7gVh3jDHLOv
	cjCxV5YaG+QO8K3wEuMtFDNJdWOiD78iieAZdShWmQmDSn2OCbwO/9gzcsiCJaOQg4g=
X-Gm-Gg: Acq92OGlzGG8vbIgS/gJLKZPNkMQGTgrV2YV0dlN1fmZMpiiW8HHO92OppRypZ1gpHU
	78KY+tYTqOcE1jH3huIG0TFKOiDdj52uj7JhMPOf3UgJ2TDcHTL4zQRUMFEYGIm/OSRwhHJffGd
	GH9UoWYblX0o44OcA+UIUiQ17I+hEmerz78BNeRAmJ5MUfynrgyxsRVdtX21kuJaYEJ8ppU8MVz
	dxIfynSbmIXMg6sXJi7MvnFECaUpi8jOk0StX2gke/nFiENX563GVdjfXdmlMiyIqPqiNPH64jK
	vd17MEW8zNYXaceSy3s75EPSLnd2dD6eZj9BYtLLJ+EGd6QYX8FIqAMZuOQOhMadBNWhYix9boK
	4RMRryyWrxYvpMJKNeQmv6xOidbrJajVQ/BrWM0hq+vtBjFsNWlDjd5EMoiy/b6vogB9trOH6mb
	NBWjjRMjajxkf8N8QYeAvu7m/EIuHek0+hgtMPUBBtAFlKaaxCy4j9illT3/SvSQ==
X-Received: by 2002:a05:620a:4053:b0:911:449d:98c0 with SMTP id af79cd13be357-9153d9cb08emr793370385a.7.1780179584086;
        Sat, 30 May 2026 15:19:44 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:19:42 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v4 01/13] liveupdate: change file_set->count type to u64 for type safety
Date: Sat, 30 May 2026 22:19:26 +0000
Message-ID: <20260530221938.115978-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ED6BBC0009
X-Stat-Signature: c7bb46qxay9proapwmmihyzi5w5dkm71
X-Rspamd-Server: rspam06
X-HE-Tag: 1780179584-441256
X-HE-Meta: U2FsdGVkX1+LNA+wM4UVAv59q4oZ3Qpjypdpi1/Cgv72R4cAfj9MnKx7qeD9ZyywTTuLWIZAFoGcCmjog6+R/tRzYhDcSGuoxC/hlHyyqfMzqHtQroMlnRgO+9P6br/CsaDGWIO9vKITlxond+07NjMvP3Db4fWFGNp3uOUr+/nwMXbW05eSzLzL2X1fbns/GGHMWWQDZ9hOCSwcFKEKQS8F0xhD4mwXtM1uHxxKU8eGKhOZDRrUM8m6hYU/njoXgHBfq8kUCGO8R2osH5ehNdqDasHM/XvIgBLlyGnVJ/oC+WHWGk22LTUspqoHh1egyzZHPVVkczoUE1DDB5W9scD1QLU+soFbJ77IPRQtlRt08QIfuGsjW9n0V5VkwzRwzwTC55tBA0D48vqsU1Ts76u1eJNuiZMztXLHoTpIuLGOlX+pWgndcnSpSjOJVwScKaH2kLVwMBbus/WtWRDk5fDriOwk+8LW72wiA88hHci0C1D9tOkKWCQ9it8Q5hjzXDA37iJgnl9IJiTjNf54/klSWTXUaELL0tR+VD/HsYk2bUoz1ttpEuq378xXFX9SA1I8NWhTMkWG3VappX5PYLucc5oLPpQO33wd+6+Mx1c4eS8lMHV5gUizXQRYeB90P5tgg59MdpARXKiL7oWp6zyAaYsnfuoRwhlHljaNmm3zazSVl4gGSFwKr4wXfH9XU/O1WFSFuvqw/rXl682XMbneKeVWs9PfaqPqkZqhb7EtkaGvgd8WZnFvWkCvgdDE8CflIfjQa7pG57WT+sc8uae7S3QB6c1IxIgZT8Srl0/Z+qZgri+MIXKxW9TRGwjouiGHfEs7olOvdM3LK4a2x2GZq2Mt979nNCM3HzbPHELGdgavvRqztXjlUsGPXlWttEs9o2vXtVAJE6J62pXSlXZvQIW3W+cCsp7SNwoqhSzeHGiazS6NA+5xHcOre9HD6aq00nT4u4MDfUHOpx5
 Uz00CGaX
 f07EsZs2B/E+uyxVRvdEN8aIji8otfxDGmKKClJNoxLrF4bG61fbjvaxyvISPFCR7mzmU/dDrSBZWMe/bE2o3hR+hSW2TLuaQYQSs4ltXYSr0TnL4lZfJoJsM5OkM9AbOQSty1XUzclv5NLhO06slrRHEasXr88omR1RRGOW0XLwfUj05sZgnELIfZrDW6n7H3TKm9Mo2LM5gBoqfUrut61xioiotVK4c6pdrZaMeLs1Da/cPrYsYx1X2fv6ViSoZtn3kV5pkFswqmH3loZ4aeZ6gTMQebIkLBSlGR8ur111mIanzg9L4pcvX4bWfaFO7ZEAoZok8HTicsw7/dapBmc0nqbMzQhBO6oJR9uJFkOW4+as5HaV/05IU6zjaTjYRz09k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This improves type safety and aligns the in-memory file_set->count with
the serialized count type. It avoids potential truncation or sign
conversion mismatch issues.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dd53d4a7277e..ae58206f14ac 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -52,7 +52,7 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
 struct luo_file_set {
 	struct list_head files_list;
 	struct luo_file_ser *files;
-	long count;
+	u64 count;
 };
 
 /**
-- 
2.53.0


