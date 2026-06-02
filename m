Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 467A2CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A94B06B03B2; Tue,  2 Jun 2026 09:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6CDB6B03B3; Tue,  2 Jun 2026 09:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AAD66B03C6; Tue,  2 Jun 2026 09:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A48C6B03B2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:18:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D1421C0FD4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:18:36 +0000 (UTC)
X-FDA: 84835027032.10.A279C4D
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 398CCA0010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:18:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=asefViHh;
	spf=pass (imf25.hostedemail.com: domain of linuxoid@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=linuxoid@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780406314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gi0nkd00qoOiTXwyNBhW7SD2eFbz6g/U1mZvPVWCOeM=;
	b=CHK8swm1IOcFowz5Aq4We4xuMUiWmCQk7/GC/3bIBAANa7G42k+Uv3Viw3mvCezlmsD6kO
	LgKYbVHxZP/jqDKOPDxt4tcdhCd67OVgdF+wXl/m8V5QeI27GucQCNmQWW5CautlxlFdim
	F95rgF5MEd3ofIHFJOdlbXnAhdFXeKw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=asefViHh;
	spf=pass (imf25.hostedemail.com: domain of linuxoid@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=linuxoid@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780406314;
	b=IP6n3Za9NWOrkffjD6PwNnNedfgQI2LbDMlno2uD4TYKtqrdawM35oRjA4QAeaLxutY/hJ
	B4Hooh61TFuVMQ+Fha5qiwr+I9DPy7D9uevhpGp0r0t4Ae6kBrVKidMR9b5jdaCN4z+8dT
	EVG93Z2F9pRS0mY5IAR4ddUwYB3xvHg=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5aa68cd8dd3so2455952e87.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 06:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780406312; x=1781011112; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gi0nkd00qoOiTXwyNBhW7SD2eFbz6g/U1mZvPVWCOeM=;
        b=asefViHhPI1JHS885ucJr5ggdmdo8gM0xz0a7msw/ryNZEbIdHQN2I7K8EkRzdtrOC
         27jIJSr0emi/ghlHStuvBaOUbB/Qbc0VdS6tpYFqFnFcHkSDEsJX54USyPYhcgLPcWzd
         YwGp6R2ehrPA3y75iJHRNfipNW+t24dUScJNGpImlift4jTcFQJT/Aw0cnRkeRmeveyq
         6eB2FaI3yjeuDiDzbdQGFYj92veDcxDWZFP32axek2rCI8u115sIR+ZkLnWNboh0FrnU
         SjsM0RgtPocjdyRMlFNPJiZg1RIJvwGR9drB3UWLnUPqrESiu+IIdwjYu26D7WgwgIGl
         ZsfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780406312; x=1781011112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gi0nkd00qoOiTXwyNBhW7SD2eFbz6g/U1mZvPVWCOeM=;
        b=COk++U6U1EXk74n5/CNz05VCeYZicM8pt8hsKG/5mbmZ0WrQsycPNHMy/bYOYRsssa
         5nfjP0yuig714k6bz/6CZG+6+p+tIqif2kGoZrqXq1MyTJ6VeZ/ZoCKOangmy4NgwAIV
         V/rhlhcCMhH6GZAFVPcfe9xfSdOFJfeAQ4MZmgTZXE7s4R9n43zbZ/7pdZwYM38F5+1S
         HrKn55oVUJTlcdNeFJde91zrZEJKiYskbCyFJd4tee12G6B+SWkeAmn9+jqiKLcQgCPH
         lkYPYvS+LxfzspD9onzAPJ4bdxmfwDi0pJPDFGqMz30hpPgHTf2bovYZurnrLl512t/3
         OnSQ==
X-Forwarded-Encrypted: i=1; AFNElJ9qHdwtwzEFl856xYXqTwufo1WDNyPVr7dUUz0g/pA+YvEWnRS1SNOjkjYGgoK3v43ILye3HVyKTQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2bF+jG0QC/b2X1njKpuH28O4pA5hOCQEwfjaKOQr0/SzXuDl3
	iVXQpuofY7tfuLBN9GC4mBgEUoaTZl0Ij2Xm4wNmB5cBQp6cVmBYzt2izkHsspZm3hmPeA==
X-Gm-Gg: Acq92OG8t4mNipu6nZxyBQ4/EOBOhSnm6fhHRYsj9kc4Ad3f/OvYuxywKEV2Q/zRWwg
	hz905C3Z91ay8AzmK00JtF5CVvT37A5utK3CyNWoAReDagsEJIEZvdEsZqCLPYJATm2rqFZSdco
	PSNnAnq7kA3e9ihC1cB0kjrKdcq/tzUgFQD+9IV4y4cq/EUcr8w2tg8af7ybLkXcOs/lpZnQTO/
	poj7BbzMcP5ZefdOghdbnES4M/W07oJWEQ4tWt4f1KkS9+WVkO6GmkzHwUw69/ZWloYKjvNVl1R
	YH0SV2fP49GXOsdge0jBP9hHB3BErFDFc462h/EeLIWJS+huQ/gQbiujWrZd5g/0EGrhKyyv1CU
	ziTBKxYEO/BW4cdTydvvDA3IchIPwdm2ANaU4RSpRVeQzGCTSgnnhSAQ3b0GSAvbZ6dptVeda1M
	vPQxtbO93Y51PeNQ+Cksd1QN07YyiLmxVMqKF5cYZsOA==
X-Received: by 2002:a5d:50ce:0:b0:44a:2cb3:b633 with SMTP id ffacd0b85a97d-45ef6b18708mr24074083f8f.12.1780405939786;
        Tue, 02 Jun 2026 06:12:19 -0700 (PDT)
Received: from x1.tail0e71db.ts.net ([46.140.7.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34c3081sm33234665f8f.15.2026.06.02.06.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 06:12:19 -0700 (PDT)
From: Ruslan Valiyev <linuxoid@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxoid@gmail.com
Subject: [PATCH 1/2] selftests/damon/_damon_sysfs: support kdamond refresh_ms
Date: Tue,  2 Jun 2026 15:12:16 +0200
Message-ID: <20260602131217.2210912-2-linuxoid@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260602131217.2210912-1-linuxoid@gmail.com>
References: <20260602131217.2210912-1-linuxoid@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 398CCA0010
X-Stat-Signature: j68jx418pj7f3z4k9yaki8w9bkzy5dk1
X-Rspam-User: 
X-HE-Tag: 1780406313-801341
X-HE-Meta: U2FsdGVkX188hhNKiaf0YZPcNweHA14FXm9MR78IiRD5Tw++9BNUPc/71kOo3AC7s5YTv5Kqx2MrAgrElMuCchVmuTaZksxK1nKtCc8dzKLzuPj+v2hIUHIgvDRuzOtAuoxpx3EcFYICIsfJ7Bhisq36T+U+R7oRodmX3j68uvJn4Tel2GkXQP8ehu64kDoWuQa7AZxwpO+z01TfZprG9oWJO19dv+SNU3oLgQ02/onsYhQH2EU3YxJVRVDzbgys86b2BmnDN6N4+IcZDEQ7X4Ry7uFIot07mU/1aj610Bwdcu5IRaORtJa7GgJxMj299rKZ4nAuBRb8eLbVH4p2Vt0A0CErEgAaMRmut7N86wkJbJERUnKxJMIkrzB+1NNzO7dGsO10lo/OP4XX416hkMy1l+5o1+2V5XjMuRvbw6oWEcyC5LswZSYpyjBgIZHdvccIUVqh1Wv/SQ0ZCJpaj57ecVRpEbrs7QrwE+NRJ6mpV4K28dG9NO5iiXwtclgq2d4snHgSHEDesAU5BPEmlnd//rcB2S0PIdGkQ7iZf2muHvVqds04RYpBYfTIgCBj//SkHocHytkA14A1XkdrnWAnGDnZOxTlr5CPO+mssAksP1mpWvQ+ZhSiJZ74Xj9++x/3AV6d4bM5oZp6nJ6qbSVuDN9Zia85ZvJmporvJ5MVlsooIk8V2GikDRK5FMZkBecoylI8mmASgK0B2Gr5NSyPKSfTzY8EdtharuVoyDfU7LElJfQaHvsSsf25CzuCGcF+/XekvaYkAdQOQo7NhlFHJmmcrgqnAcAoio9Bwpl/xyp3ApsNXtbZIL3UDSrF1ogzjAT0C0g7PE+P7nHWTiNbIbuflfjYbbrrnlHKw+jBPsd7UOByeflIF/hH+ccltsBIZ5eKePjygt8AWS4QpTiQfyL6dxKF7M7FcJnZpyON5DRx5B3PXHmnWia5eOZK2omEIYgJSfRhvx89fF0
 sbDDDRD7
 2grirxf+L9/n2tHCZaFbUg94MZACg5Nc96UG+I61h4atr/aAS/AtZ4y9eVSZp2Llwx/xRLPok4EiiSukdgI8gfzMuoR8/GDe+xMsTXXEJMkmzxHtsl/nsqyQTzAr7DRf8Q++EtSDaPHMrMczSYTe3ATTWUQI9If2Cdadn6H71+K801c082lxEH2QuPNRSvovfTeTjGEouRFBypEiVXhR6DtcndhTAXAY5Az3mCU80mNGLq6hlFsBeaU1v+YLTLGReD6vFJZrt8rCHWZJvN61hcCqV2rLMr8lio27SW7i3zB8CesF9x5W4TSKtqpCFZGBHiws/lJM7f6EZynpKrHX9zJdtfvNJVUlHe72l2nWYNbqBBzEJFaN3f25umMV9UN4BvJkxM9fNS68b6anH/PPIFRKWKVUF/oxcnbU349716Paga0oyV5s+NsdnUS8950OdkMfA828LfE7YShg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Kdamond class has no way to set the kdamond-level 'refresh_ms' sysfs
file, which makes DAMON periodically update the read-only sysfs files
(DAMOS stats, tuned monitoring intervals and the kdamond pid) on its own.

Add a 'refresh_ms' parameter to Kdamond.  When it is set (including to
zero, to disable the periodic update), write it before turning the
kdamond on, so tests can exercise the auto-update behavior.  Leaving it
unset keeps the previous behavior of not touching the file, so callers
running against kernels without the feature are unaffected.

Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 2b4df655d9fd0..1a498c78a4149 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -667,12 +667,14 @@ class DamonCtx:
 class Kdamond:
     state = None
     pid = None
+    refresh_ms = None
     contexts = None
     idx = None      # index of this kdamond between siblings
     kdamonds = None # parent
 
-    def __init__(self, contexts=[]):
+    def __init__(self, contexts=[], refresh_ms=None):
         self.contexts = contexts
+        self.refresh_ms = refresh_ms
         for idx, context in enumerate(self.contexts):
             context.idx = idx
             context.kdamond = self
@@ -695,6 +697,11 @@ class Kdamond:
             err = context.stage()
             if err is not None:
                 return err
+        if self.refresh_ms is not None:
+            err = write_file(os.path.join(self.sysfs_dir(), 'refresh_ms'),
+                             '%d' % self.refresh_ms)
+            if err is not None:
+                return err
         err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
         if err is not None:
             return err
-- 
2.43.0


