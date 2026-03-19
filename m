Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 613FE109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7126B0536; Thu, 19 Mar 2026 12:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87936B0538; Thu, 19 Mar 2026 12:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E6B6B0539; Thu, 19 Mar 2026 12:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 982666B0536
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:08:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D52F1B8137
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:26 +0000 (UTC)
X-FDA: 84563295012.15.50EDBC8
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 72E6DC0008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fWLfi9PJ;
	spf=pass (imf10.hostedemail.com: domain of 3dh-8aQgKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3dh-8aQgKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCR1+XiCejEoTZukOGzTXx300luMCdEPMVOduAGAhwQ=;
	b=shLfULMI0/1tJQkQ6M7k8e6gZhM0WlEot7xKm5xgYC/7jeycgDc6kThDuBzwDjfh6Ahlj/
	RvgCMSHu+Z/Ou5k6WW0FuCZz1bi7WzcBMmlDjCcoxRDRehAjIPZtdCpxCrajKXx1WJczr/
	mY9DLeX1E7A4EtSfnrKeHx/7z2rb4bc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fWLfi9PJ;
	spf=pass (imf10.hostedemail.com: domain of 3dh-8aQgKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3dh-8aQgKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936504; a=rsa-sha256;
	cv=none;
	b=Snywb7kmnna6KRbjz6FxZCYCiOnEJ/S4mgVuIDK7bCa+hBaAH8b+7/27VQkf0RZ1eo5BqW
	LdXDKYRhzrbPhzrQotLPQ2eXfscfzRibCwcDTzHeu7mxBeCTzqsBEKe4BBDdiTlizjfiBf
	nxIxBjNJDKREjDkMYe4ylajzmc8apQQ=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b3d3d2d22so651003f8f.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773936503; x=1774541303; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DCR1+XiCejEoTZukOGzTXx300luMCdEPMVOduAGAhwQ=;
        b=fWLfi9PJJJ4b1HmGXJ+0rmitnPmC+tbe+K48DU/IXlUjcjKJB84j6RDQyGL/BElTUl
         0OXQ7tidXMTK66t7lLyCPKz8XMl/L9C2ojSmWdZaJ2vz0Yqc+geSiSkpQLtI2bCrqRek
         Y1gX1IP72a6JH915K1oXeQZS0Tm6rnpX8O76LKdp1pn9PRBlGLF4N1/06wuPkfm3uDXE
         2CKi/FG+GiGYDvRMAU6Rms4VTP0MUE+2ortZkBFbYa8oPJVLvzEaw/+f8/T2VzHm6XOK
         4Pouj7AP0J/8/No1ZuTKSbDGc8e+e71iNqTmfUhvSoMhUXedgSbiGk2EUwMYR1EODUzT
         frbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773936503; x=1774541303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DCR1+XiCejEoTZukOGzTXx300luMCdEPMVOduAGAhwQ=;
        b=nXgs5xYTxub6Udr7vewjSQma4GBqkEmS9J8o7/x5q/dAoulZTNIfN6UHV8MjVLXDUW
         twtyZ0OaOgioe18YUM5xfB/8AtkBGcncZ4lCSXBtdOYvG6w0qrJtAXK83vs1Rxv69OQU
         FoTwbCqikW+xtjhXQ/5LwBMh/erRA4O4LEgDz4vws0C7y0IqImbm9halBy8J5LDgJiq3
         DU91rOk/yN4cpfh87RT4Erd3r3SWbN9t0B/6O1jfcFcIhrlUo1PvXWJ3q/L8tuMmxQB9
         6bup1Qtkhs3ho8bZCAoguA87kghoPJrp/EHnT5vRz3Lk/pltxdD1B6CzrXSNDMMHY6kA
         zetQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3eCtKb/govoRpB9i6XE9cxjaGHg5BtXDRRifYpzQ1rTahNbQ8uMcsPw+gmoaRqQN8+u19f8i/BQ==@kvack.org
X-Gm-Message-State: AOJu0YzmJbnK9lkiQNIYYLq0oDru+DLIn/6gG4B8B9tSP+t42OYCeVX9
	rRN3EHJm0NS7vFCJdnajq9LfMt61PFrQf4aT6EyYOWu50YEABEvC/sRGv1mcTwFUc4A4SOoYMzT
	Sgr+SdPK5AmvJ6Q==
X-Received: from wrwk6.prod.google.com ([2002:a5d:66c6:0:b0:43a:5b:6a87])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2011:b0:43b:4e13:221f with SMTP id ffacd0b85a97d-43b527cb037mr13781774f8f.47.1773936502714;
 Thu, 19 Mar 2026 09:08:22 -0700 (PDT)
Date: Thu, 19 Mar 2026 16:03:26 +0000
In-Reply-To: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
Mime-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260319-gfp64-v1-3-2c73b8d42b7f@google.com>
Subject: [PATCH 3/5] mm/kfence: Use special gfp_t format specifier
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 72E6DC0008
X-Rspamd-Server: rspam07
X-Stat-Signature: nwmegwxwye56xjcstrw76xsuqo9z4krb
X-Rspam-User: 
X-HE-Tag: 1773936504-209732
X-HE-Meta: U2FsdGVkX19wiyGwn13NCMAbuWcaobIAc8tZryGHnpy0j2zFTmH3G49s+JcmkMV0nXWQhtBpUCSePwP65ueUpMPi7OwezFPBOEzwp69i2gphHSx/X50qfr/6imlgGgfbrxse6j9fOKbny9DFCdx3Dg43kluYtqJocHgV0MH4tlMU9HeG1bOlweDZrr/UNZwDRL2/+IBDdH/DekNE9j9zmvhcLMoaN862yCp04eAC+c2aiVMl/Sad5vdnylbOcTFu7OO/xSKk3CK9kIiAR/bLKb31YR5qYeVysaOfQD7ZgHWjgqpmgjHYgwQ3/AdeRlgsIJiPVrvCF9BUUh5/aRtvspJzc0QXr58HpChvIAnoHvVirABZNRVfoZirxPJsEQrLQuBD8DsHVx2fYn950CdiIvnaMad4MH4w9CFQERlFPQ6m9MttLD/WmNxqXcQu6fYF5K+Ly3jOJ4PrRDgLQoGrUN8q9Wg5TQll4VyFKBgQYmC+XSCrDFY68c6wJP7gn09k0xIu+LRMHcTSF7zsrkHisdYeTEqGQvGssAYwAEIzlsifMWVAyAkABSB2QDQv4aF97oZETfu9rQaTCabOXKEhI/hvwpaECLoX3kq1c4d7LfVqm18pJx+Q/txewBChffuEIdUm/xAd5LGi0RggGHM6VFI3oKtf9OJfZhYHougT+3/TEd7je/ywE8B6MHA8NiieGp09gF+NGEYTLoqbE/0AK9SEy71J6JFzpe0dz3praCEjOtcLJ5GAHbeS9SPo1BEIf4WUlcboj9f1hf3g8yOw7TBO/npEJ7v1R8+o+ev2j8qpCiUrqptktzW2zHFBOvShndKn/agqKvN2tosup9ofs0g6EXCV56XEP7DIMt6BGuJdP3me/ac7UNymd7syXZ2NuaB7Gc6YgLD+Exet9rraNV6VmKKxNrfg6ux72xobc7JENXTqDWkIhCQLJSqf8kxxAEWTHGSzfjoQudiyFWD
 bBlwl60C
 NGZ1kFWxuSRUoVVXkZWsnuOd0pULiw/pEiHIrHSpJpTtPiMsgDULXzQUrZW9L1hKB5aVv7X4ycg8aEmZ8aP9s0k8BQlzMG2hoK0zMGJWBCm7voFZnliYK0KFuBmQrVOZTfeNjCyqdtbIXpPmz3E40m/fACqnE40l1YeRwInlDT93kpWJHZZTZabYzVfRvj9Sgwulv7NvYxIn2k8H2BBg6uR7at+L3r0yy/vcVvzDjMoUXvfzq5s2BFfob3vnO3j0VAO2dH5vUgs/RzwHvHMfr4c0BW4rLeKUwr/I+RQd5yNGAodOlDfl49qehuydcgksbs0/A/qBPq29qq0YGbg/G9fb7ydLtdP3SarlkZTOFRlYKkIblo9o2oqgSla1CEDn9Mpvjks29Zjic2tFaRa+pQaQU6gZn5rC4zOUvlu/LncTxIDUiwgnvB0xF2TzAvSolhdKLpoPcKN6xzpWByIEfY8lskA+qQByoIw5BEhNoWZIHqhyWP9Ai+be3PaOj7dIqGRYNMk3A0HoqT11UrPCZDYzQvi4QQK7pKl7Qzow1AWJR9p9XEKipcd0fWQ0dzDa5uvtHTAfT3EeLWy+f6wG/AJZwBWlLC6D/TSn4KVwXOfo07bE=
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


