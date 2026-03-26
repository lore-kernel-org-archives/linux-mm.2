Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CA110A3D8E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C646B00AF; Thu, 26 Mar 2026 08:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550906B00B2; Thu, 26 Mar 2026 08:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C4B6B00B3; Thu, 26 Mar 2026 08:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF156B00AF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:38:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D60F1140D09
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:38:42 +0000 (UTC)
X-FDA: 84588168084.19.0C77956
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0833840010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:38:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P7VplEfn;
	spf=pass (imf12.hostedemail.com: domain of 3YCfFaQgKCBk8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3YCfFaQgKCBk8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCR1+XiCejEoTZukOGzTXx300luMCdEPMVOduAGAhwQ=;
	b=wEfOkFmwRRjbCzzsulv2GCx7RUYY92qoWEAM7mymVZWX+hL3BAO/g+wZjV20N+xl38LkQm
	TVtadl9wEg8SK3kbAP/zvJl8BlJOHeMtvqaEDPhoqWDnpzozGR7kP5AVwxUS1zQUuAdvY2
	YMWRqbAoFgUjdjcmXMEQqUmoOKchZnU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P7VplEfn;
	spf=pass (imf12.hostedemail.com: domain of 3YCfFaQgKCBk8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3YCfFaQgKCBk8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528721; a=rsa-sha256;
	cv=none;
	b=omTfvWUSVf+6ouZrbsWqRQmIOX9Y9sOwIuxHF4Zkl48Txso8RUUjwRQlhrtLTZoxWBH4jj
	ZB0ePlXTjbtHEcO+yaQF2I7kA9CBKkeO9S3QhBNIASeDGj2BRMQr+Eb4BGKXk9wB920/Yr
	qij51lJYCeIqPxnLzSGnRW0ZZ+N5ngU=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-66a99cd81ceso1149241a12.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774528719; x=1775133519; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DCR1+XiCejEoTZukOGzTXx300luMCdEPMVOduAGAhwQ=;
        b=P7VplEfnjOAruTCOCRmgq5C1fvAFH8XsBDoIRzIPVhRoerRJtC1OlzzbEJG7EPXQNN
         dfhtmrgO7cY08+MwCwrhDegTWBSVzNvQQwTUBhbby5g6gcy1z035d/eFgYOF5lNE+0Wr
         C6a0+6RD8fuHqRvtECVVLaAToFjjiSaTK+SrL09FJjwr376W5c+mqyP9ekm6PE6CkFoz
         O/HbST9lQvwLSMwRAmvuCePC7uBLlQrnD9KRB5vC0K30itJxmJvbIVUVB+x4MxXo2cyu
         GyliKG6qJM7ijOL/ZhQzANfWj30uuyZmpl6NL5JMDQiGGS7QAc5TjthDiSZf+I3T+P6G
         EPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774528719; x=1775133519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DCR1+XiCejEoTZukOGzTXx300luMCdEPMVOduAGAhwQ=;
        b=ZlaW6JLQsw+6CA88lnMjROAJNsnGj+7hq3RqfonQeq2rWllyO5kwlbdw30sS6MVgjm
         5XwnFQnN4I/hcjkOxFqtyhwhG22W+WalypedChEqNSWQDEjCO8FhUsZggJqEkTTNHl0R
         7EkaLPr6JmjP+wdWxrmQOzRgUM2d09YEQUQCHTP1MMPRjpxuJVC2qBGwPUuBL6HfIpy+
         4Gcd/MeHhGCBt/3LKn5sLGIRwUZeQKbrKMkkqZgM4g4OgDLb2qieeAj2/I4AqExT4/oq
         P6cRhCZe2DLSzZaLLH8Yz4/MFBSZuhEI5oujWM1vpKI/NVcpStw5zd06D+4CcW3Ts2nl
         EjKA==
X-Forwarded-Encrypted: i=1; AJvYcCUFH24pHG2dwXWFaiFPvptGCtckkKaiO5Yq76DR4l751a7GIUsZgzOfCRyms2W8wB7PdmPMgxr4gA==@kvack.org
X-Gm-Message-State: AOJu0YwWBfD6J8w9w6EW1ve8jQUdGBGz4/trHq4e7F46WF4Mc43o+L0h
	iFN+chpp6P0p/S9UXVmFyKL48NJtH1XYjlU9xWNFe9rOr/5pv8jx3lbcwv75hSqRvyKmPoQ/Jmc
	ynS1zV5zZOc1ZIQ==
X-Received: from wmoo19.prod.google.com ([2002:a05:600d:113:b0:487:238e:327b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d1d:b0:486:ffa3:592 with SMTP id 5b1f17b1804b1-48716071b2amr111318865e9.24.1774528352832;
 Thu, 26 Mar 2026 05:32:32 -0700 (PDT)
Date: Thu, 26 Mar 2026 12:31:59 +0000
In-Reply-To: <20260326-gfp64-v2-0-d916021cecdf@google.com>
Mime-Version: 1.0
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260326-gfp64-v2-3-d916021cecdf@google.com>
Subject: [PATCH v2 3/4] mm/kfence: Use special gfp_t format specifier
From: Brendan Jackman <jackmanb@google.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Stanislaw Gruszka <stf_xl@wp.pl>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Allison Henderson <allison.henderson@oracle.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0833840010
X-Stat-Signature: r4bb3qydndudyo6kc17cayfox5r4ssud
X-Rspam-User: 
X-HE-Tag: 1774528720-715624
X-HE-Meta: U2FsdGVkX190Io3rUZzZdtEufcGSoV/w94Nzsr4AZTRDPPyf/bRpYfr0yxL1ODLwT6CuEOiwVnChmDTaSURLLnxMmgiA4BmcPMTOpnx1SCQ9vnvVbCnMD5U32/EGVsfgYiljsN92kzApj4riNGAW0esnc/xXCF/cEpDNjsbpOQnmtukyYNdKAr3N0IamktYAaHbhdDPFytbodjgIcD8p5v5ie0hVADvAkICdQeI272lpZZNctRkKcGUy7SDD/wvjeBjLZj0cekLFEQwlWag6aO5kvkN46CeVhqfCWcPN3RiWJnF9O71S2rL1uQCGiO70eS8YXZ+KyQaVJi5VSfISGxfjTS7UY76AuHLoNakMtViDFtF1cPVJzm5TBakIcAmHZByROq3XCEiTwFKddHhiP+UqeUvvDzMp6Z3t7nyePpvRQR7ymmFhghtuR9hiS8oj/MCY6eGGOS1q6XkguxTXPei+WuuYUazr40DDeuR0kMiO3EgpaBucB4yIdLmQFjEuhNMeJCCUc+1g/2qvkoYxC0e8uaBhfJRNXCxbB5qhQ9M5fDpNu6dmKaDxvsxsKCrrCBAEC3xC4hP3bOW9y15jtxLaFD+rrZm9ZH51ciVMuFSWJrg3VE8vC4GTLqH3bm8moisZCD/Y9h/JlMfancXg3dBbuLXy1wjexrYFKCcLuZrzY6om1H0/MPWF3Lra9s2MQual9Phwbm142RStnXei8gTCf36ZwYjdo2OnCO/Ki8CXz9ZNZPBc70wfb2XvB4TPV4mnAM0sLDelsTAlsqb9ZzjgdNIFIlX3BIVhEVqIfSgg+/zjtwdAWtvgbBre8s2bYSgKHw9N0xuUR3zfiB0v82XpnSb4lZ1lsCUl9QwJZ2dH9D+DD0GTZpYAEexgh1J5LFL/Vs09ZX2lelzk/Yp8eiGGX8KbgDvek2WMgV/G5rHP0ax78qwG6BQEpdzxxlvbrUjLHcVkmlHDGXnn5a0
 +rhZTKYJ
 CAyuc8eMtEEU5MnmFvroeVUvGw+TotrpFbYc0g7qbxjinaMDFKgjC8enQrNsY3ZreGrb29OPaEf4QnyAEfL0578XLCthyB6FlWkv52RASaaTxAjuyC0ZN1fdjeFrtZz6VUluQw2AvIl9A5jBsFMFZ34s3NmcRrYiA8bLchAZ1oAq+vJSJJGP26+GuLJQ5TosTQPiimfLsAXUi2EfLc2KnuEZYXcsryqT+5U17m8vVkYG3wAymUOs559zNOzrcof53cJ8sEAACUR/HjOf10qJ4C7+1kuAZA8ob2gZEeW+Amwfl5KeTzh7C1yCk8H/azsic1akKFjKOzMTVUqim30mNBMkTjnuBtb4bo+6sXeZry6Lk2Dzuo4kjZdWfQNZftDd5Kkt61VpxzUjMlg+9GzFE1/9PRv62OQcqcFySswKeLmFzMnqGlKrj9kEmdx61kUfYvkfIE+fGZ0PQ2VBnZyx+GjpSeS9nv6G0aAPqqaLLHM4J+EovWu5tk4ULpsm4zIS/OOD8HwV+ujHoCyZrk8OW4N66mteNkVJp4zp0OXfg7CqJwCT9DlLlzMYA5HQL2CCltZIW+VJOkUEU/WrSV9mWx9YLWvPpm94CTr5A/xxwfvEPRjIDsejgEFa/eY6xd695oHgSn2sjz1S9xT4pdnsNyIBXpC1ciGfh1p6mR0agwNoLuiizhaIzhl4IKI0AOBXIzUj6Qxft2Z7Cq2xgNGC3hvKmtIpLvFmwZFXtO9detptbsvbpX/NSKB6HWH6Zo7YFucIEiKcFySopcr3F9hWmhJRvy87refkb3Ww2mXnCeEj1iL4tIzgMc/sdy8Uc81jF6w/E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

%pGg produces nice readable output and decouples the format string from
the size of gfp_t.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/kfence/kfence_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 5725a367246d9..10424cd25e5a6 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -263,7 +263,7 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
 		break;
 	}
 
-	kunit_info(test, "%s: size=%zu, gfp=%x, policy=%s, cache=%i\n", __func__, size, gfp,
+	kunit_info(test, "%s: size=%zu, gfp=%pGg, policy=%s, cache=%i\n", __func__, size, &gfp,
 		   policy_name, !!test_cache);
 
 	/*

-- 
2.51.2


