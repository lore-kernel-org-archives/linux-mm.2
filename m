Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53508E93808
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 22:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05DDB6B009D; Sun, 12 Apr 2026 18:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007AA6B009E; Sun, 12 Apr 2026 18:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5EC66B009F; Sun, 12 Apr 2026 18:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE8E06B009D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:51:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94416160BE2
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:13 +0000 (UTC)
X-FDA: 84651401226.15.C46944A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 58CB4100007
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JKvOOO2F;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776034271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6fKfkMPTLST/NSxam2u+fhT/53Q+wPZCVCtdXXmORc=;
	b=VJMiE5B+I6p9f19XFIwDiB7M/awE9j52CW94JAg5bJF9w531Y43oJoW2BHQoryJrYFF+bD
	eWx22XwF7t+0fg/cm1Xtuq7MwB/PyZ3ie9Z5Wf4Z3a7oUbVaB7uBRYPj+kk66Uu0FlYYyt
	R9BMD7ps1VxuT0m7O42Zt1dQbqI7DiU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776034271; a=rsa-sha256;
	cv=none;
	b=B9DbgXqv4xnADhjbxggMaBQ9CFDfMnbp59uZX86QGpuR+33FsskyR2f/HUShdy11s06ly0
	qRbGf8ZV0ZUBFnY2Pn0BBOfvtFc693jCfuLXfSWKQIXbmNjg/TRhEI6EJBeCskvdU/RJLk
	hONzvY8Oghw/6A3x0GN1ijo61uQBq/w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JKvOOO2F;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776034270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i6fKfkMPTLST/NSxam2u+fhT/53Q+wPZCVCtdXXmORc=;
	b=JKvOOO2FODKaD35KKjGvvkmGo+tsAvpwbKnVM8o4HVn7PUJJaXlsB7KFg0Febl/J2C65X0
	2O6TPmr/pwv81YBNk2PNjD1j67PJ/C/8eU+DdczJ1+oHslQuj/jIHwg+D69wtDdccJFQuE
	ly3q1WCnJyR8s2lR6Tk7SCvMiavKYYY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-if1dYJaVPwGvZISK2GsVRg-1; Sun, 12 Apr 2026 18:51:09 -0400
X-MC-Unique: if1dYJaVPwGvZISK2GsVRg-1
X-Mimecast-MFC-AGG-ID: if1dYJaVPwGvZISK2GsVRg_1776034268
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d03065782so2219101f8f.0
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:51:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776034268; x=1776639068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i6fKfkMPTLST/NSxam2u+fhT/53Q+wPZCVCtdXXmORc=;
        b=kMq+4Q0kR1XwXS/5qHPOqBF2sg1RGQ0Ap4DffJwEGyvEJISfcia2tTtxbbBoXywWwZ
         t69EjTTX7izD/5WP2LlahiJ/ctKYx/Z3a6by+dXu6tO0DxJHyAv7PW0doJVDBglXfHY+
         7tbVX/Flbb8bBS0GriTjwluUZ89x0KqSmWW4ULyNBAE+m8pMlGGz/LoV7xdyDIoJKuuU
         /zNpVKyesc1xtzE2JiRWcJw8MSf+hrSRzD8tyk8WqJX7w56KvoDVmWvWRRHUPQnti2Y8
         PITaDZFSDqLm2zi/gDW6W26axwYWisQYdpLoZvMIIg52pajQPJSxlOw3fY71d7h6pUoH
         4wPA==
X-Forwarded-Encrypted: i=1; AFNElJ98FO+ciufbFVbEOwgPDV3t9L6MxfIpd2osDt7evxEoefyzpH4PEpwA9iiw1VcVKR1YRrkh7hRE+A==@kvack.org
X-Gm-Message-State: AOJu0YwJy0eBFT6vd1ByY8qSMxuF3yv70TjuVTSpVpZVfnkQII73+3mz
	YhwDnwuqHBY+o95eembSI0jCyAzsVZ6qZWkL9lcKaytDmVuVNdRncmzLtjoc1Ans4UeQuICpG3m
	+c/5AnBfbrjl4hef+0kFscDuPXBGhrBr0s49ZAEIKJLUYl5an/65o
X-Gm-Gg: AeBDievWxpW+KbNDAQ/Vi0/qGsUyNHnrJSu2ydLvb1lG+g27+cRfjoDxZ9jBIj63cPs
	hkTMNpp5Zfv22uUQ82uWa8MjbDw/P+7HVrTbBlO17A3lXgsZulHRN9zn8IT4bt2CrotVuquNt3s
	VMwPC84jk/tu2tXyRlrAvz4bSlmE/1fkOA7zdLH5vzE0RdPro+ixXqlDjmdr0EhIj+XIcOAtAO/
	biT2HVUYyoDXIwnHnFJ2R6Zl1vTswoLI1jyBuquHqSho0PrXAouYSKzGJE+4dI1VQ14+/urvTGT
	H3R8pLl3BcUx7bLt+5se11DoasqEI1BlfjctuRttDKmYwfVxllxybJAOQ5uxG9VMd4ZfzqwbSYf
	CVwAGMNWb8B0LPR6u0uEtxfgUpcCXfp7V7o5nZbdmUhM=
X-Received: by 2002:a05:6000:220b:b0:43c:fdd:ea96 with SMTP id ffacd0b85a97d-43d642b6e75mr15170215f8f.26.1776034268122;
        Sun, 12 Apr 2026 15:51:08 -0700 (PDT)
X-Received: by 2002:a05:6000:220b:b0:43c:fdd:ea96 with SMTP id ffacd0b85a97d-43d642b6e75mr15170178f8f.26.1776034267683;
        Sun, 12 Apr 2026 15:51:07 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d7794cce5sm4876502f8f.9.2026.04.12.15.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 15:51:07 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:51:05 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 8/9] mm: page_reporting: add flush parameter to trigger
 immediate reporting
Message-ID: <73acb39342827bfb09f5fd717a07c9a58e41ec91.1776033771.git.mst@redhat.com>
References: <cover.1776033471.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776033471.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7TnItlSXBS6OWaTMsRx5l2Soefy_O7eW5AIR_y1VKOQ_1776034268
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 58CB4100007
X-Stat-Signature: dp44ji9ho8yhxcmghp4fxekjuef8akdr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776034271-506534
X-HE-Meta: U2FsdGVkX18r/UEDYmGL6HVasYsxhqIBr8t5KEC62VzeYF5MxwfsipopKW3BgcZPbtRsNszgy/EUG++bn5VcIM1Rc1M5jpEd6PN/gPWUhBNo73LBZK2QmpYgX/4CiP28PpQbWfU5SsIVk3wQ5+UFdhcg3ie+zlPLxUZc2rZ22111Y8gSlKT9CROBWh1xQu0BIdfUacz1CN+YbZ9HrD9jS/UpmCr8q3xV2ApDUJNzeq/MNf/h8/mGlUOVokp2Mf92AICcpatEoiDianAZZqBgORnUf32m8CDzkWTgnW8hssROXHyr9KUBlMRnBC8VLwk2Ikwdlv6Ufa/8kQWN5vuH8hMxc53Yumv0bHt3XEioNN82UXk9Y8hWrmAS+8KmPuDmMnd4C5GatgVkhPdeltDUmfk4UnyUvuh4O6SZIcIR3nmJlhJ6jmAsmAkDD2sozddPrYly09YQ6bsJTY6nesjOLF5SS8qMfcjBmS8b6iE7CE2rrq2jiO3MT4dpTlulHcZtZ63U3VZSFDmEtCVPLzoiN4lLMPjvzQAM6gNe//un2xzEHNCXen34S7msyWqleH+aK9AgfTsTO0s9eJXXz3EjUoj3WVeh0y8jhZNndO2uMxnmylK9Uyvde/OELWv3rLevPo7iXfBXjstXsF3YsxhLa5x0n4ou0P91u4bm86MGbV7jh0So5aYj3oaWzQg64Kh3Kyc/INlw1JsD5S5EVvWQS4GCvlzSsk4hhsq77idSodc3TyH5IYO5hAWjRvnmiKvXprAMsFkDbkYYcPwRdl41ts3vBYcKdx6b9ZsnGrZ4XxXb7Zxp4Qu6PTFOUH89MaHM4MWHaOCmEBwPu1BLU4A/U4kIHxKf02UQpkc+ya911JeCqAEUQDTDIoqQnLSRo/Hi5HMKNCjAewJyV5VZpKyb77JzdKPTIuDNizdsxFKchpuh/JX9Rj5+3GT365SmnThaMfGK6FIi5L0GlTlpWs5
 wlidnfhe
 OyBm06m+G7JBcnlStp6NCrzZxebgyvuozIDdrFYaS/tXaD4ShhEvGPBAtWdhWUzvob4FfFuc3NQmB19IxlJfVRDxLmCyD1TuZPEOHhiMu29BdWNej8C9pvcUZvzrFikm69TbwecJ+/+1UHgvB4TRVApBJvyLDKTaC8cL9gvA11pULt1IA4fnYMBk9iOOcm5Iq0fT80CrsPulX92z9BEAt55KCmmhg0Fpr8W7uF4YStJs5P6Lx3Yv2oIdO18PqG3CgTrplSgjSelv0LDnLwt3E8WXota55RFldp1Nnm98GmHjCtB+v7CQsoUKmN2/USGEEGkjM+OvugaBB77Q5zX4yeteSEjt7s6TMinqwHawo0J6XNYMPV9RobZwTBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a write-only module parameter 'flush' that triggers an immediate
page reporting cycle.  Writing any value flushes pending work and
runs one cycle synchronously.

This is useful for testing and benchmarking the pre-zeroed page
optimization, where the reporting delay (2 seconds) makes it hard
to ensure pages are reported before measuring allocation performance.

  echo 1 > /sys/module/page_reporting/parameters/flush

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_reporting.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index cb24832bdf4e..e9a2186e4c48 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -351,6 +351,31 @@ static void page_reporting_process(struct work_struct *work)
 static DEFINE_MUTEX(page_reporting_mutex);
 DEFINE_STATIC_KEY_FALSE(page_reporting_enabled);
 
+static int page_reporting_flush_set(const char *val,
+				    const struct kernel_param *kp)
+{
+	struct page_reporting_dev_info *prdev;
+
+	mutex_lock(&page_reporting_mutex);
+	prdev = rcu_dereference_protected(pr_dev_info,
+				lockdep_is_held(&page_reporting_mutex));
+	if (prdev) {
+		flush_delayed_work(&prdev->work);
+		__page_reporting_request(prdev);
+		flush_delayed_work(&prdev->work);
+	}
+	mutex_unlock(&page_reporting_mutex);
+	return 0;
+}
+
+static const struct kernel_param_ops flush_ops = {
+	.set = page_reporting_flush_set,
+	.get = param_get_uint,
+};
+static unsigned int page_reporting_flush;
+module_param_cb(flush, &flush_ops, &page_reporting_flush, 0200);
+MODULE_PARM_DESC(flush, "Trigger immediate page reporting cycle");
+
 int page_reporting_register(struct page_reporting_dev_info *prdev)
 {
 	int err = 0;
-- 
MST


