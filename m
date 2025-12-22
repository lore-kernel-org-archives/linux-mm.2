Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E9ECE674B5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 15:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92F76B0005; Mon, 22 Dec 2025 10:00:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A412D6B0089; Mon, 22 Dec 2025 10:00:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977336B008A; Mon, 22 Dec 2025 10:00:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 803196B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:00:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0552B1401E8
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:00:36 +0000 (UTC)
X-FDA: 84247418514.03.505A742
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2BF8540024
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:00:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hTurnvBF;
	spf=pass (imf12.hostedemail.com: domain of 3EV1JaQUKCEIipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3EV1JaQUKCEIipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766415635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SLecpNCzVXawwP8cx0xrGTVH2kk35JOIvedfHtD8OOw=;
	b=Ell6ddgLk7JSMI6DaLQCMkGCoPT9N+EGBo/J1Q6FtdJqC/X0qk1iUQDy7ngkMrX1GSGboH
	Pk06rs4+Q6SxAbxHamCqNwIW1N5XZpPqjrAv/jWPSvLnEaXd8TsXttuqEu9n9nU6oxQVFp
	bwAMubFjOQPcGtsnc08e4JFz3KdwdEE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hTurnvBF;
	spf=pass (imf12.hostedemail.com: domain of 3EV1JaQUKCEIipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3EV1JaQUKCEIipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766415635; a=rsa-sha256;
	cv=none;
	b=6jnr9Io4HaPSNA0cKujw9b3vUqzhSIrvotP/yJWNtsw9kWKI8EIFajEGdfq6Gj77If+/Pu
	YD7olJ+xDCRqm35btVhntzfzUp1MnhkifWmViSUZET0IdlSjavupBjq6VFpPCTa4EhZ2sE
	iT4ZN0RrdwJ8fwasByyi/73y3o+z/BU=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so29729225e9.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766415633; x=1767020433; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SLecpNCzVXawwP8cx0xrGTVH2kk35JOIvedfHtD8OOw=;
        b=hTurnvBFeNQgQmpmaazZNF7AjLsiOfpkGog7NZpVblQS2cgZY5a5yD3vKmtr50R8Lc
         ZYAiP40SXamy0A4437QkCgrRbTlFjmfSJAhgUsaiE5n27JUYdUMHrYv9l+xe/QQ9QmRh
         5YESv6mjHTHTGsXzbfZ5tn0JxugQjC1xquXS/tgYTMhsbCiofCfx2XSwIS6BCXlDt0pd
         FHIFzlh60tayP8iFFK3ojXNytQdKzrGNMfChorGMmU82PQdAKK8VT7jQ0oJXiTaC2Lre
         0U1xVlMxczmZGNTidZffpiCYpXM1g1iDs8niZDx5hiDtu5ullqt0WGhMngCdwoUBWt8L
         eJeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766415633; x=1767020433;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SLecpNCzVXawwP8cx0xrGTVH2kk35JOIvedfHtD8OOw=;
        b=nujkyOrJr/NgJ9I++XpGcNTnFqqvcUayT6XQMG2gWzDWoi188nOzns8Ts1a1QFTcDO
         y+IVrWw5LNlHyL8OAyz86V9VnVPOiHswGAcMd8knqIBcinVUk+YIbkYuBa432MKmSRrQ
         iUuDPhY5GXCeK9ta+WzfdwCrbdfJLRLMSZh4v6IHGbLmbjnn+5Ibs5yjxJGsSXKLRyad
         byNyR22OLv5ylQBSayqqBaS1KPX37Ohlqapzpdus+E2QSdTpwE3IYBKDbBr49rY1262W
         ofj8cmhr529mTJh/ztCW+QMZyzNDRzLT0Q6K46e4uR4A7trZxPDPm6EVbcxhceEA35f4
         xCDg==
X-Forwarded-Encrypted: i=1; AJvYcCWyb6HZ7P1cmI0i0ktVqIeKbOXV2bjggoJbyFoFleBYuXE/+tj8QDka71okf8WthEJIp1tU5gqqQw==@kvack.org
X-Gm-Message-State: AOJu0YzLPbwRolSyhN54NdNW8vYDHoHe7ZTwBnrUxAlhr+xgfTky+mXl
	v7VxhC3douxDj4V292tTN2/ZtDDmbp8otU2zWIdcFwJDMRyHY/NwiVTCwwvleNmYzGqMnnBMFf9
	zuQ==
X-Google-Smtp-Source: AGHT+IGrVe5BwxTN1xBcqifymYkOlLo7MfVSee5M8PugpQUe7fIfSUpxJR3UYaitoT+KLjV38czMFVaTBA==
X-Received: from wmco23.prod.google.com ([2002:a05:600c:a317:b0:477:93dd:bbb1])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:46c4:b0:477:7bd2:693f
 with SMTP id 5b1f17b1804b1-47d1953b80bmr128913385e9.6.1766415633343; Mon, 22
 Dec 2025 07:00:33 -0800 (PST)
Date: Mon, 22 Dec 2025 16:00:06 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251222150018.1349672-1-elver@google.com>
Subject: [PATCH] docs: kernel-parameters: add kfence parameters
From: Marco Elver <elver@google.com>
To: elver@google.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Stat-Signature: ge7z4pz3tqruax66e1nf4wioqxqgh3pm
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BF8540024
X-HE-Tag: 1766415634-208827
X-HE-Meta: U2FsdGVkX1/o2z1yMhRJHgLFeFk8AbklnubQDsc1YZIQSozVyQxXcDl+FFcncoCYdPiSG1FB2NHIJapGchiRDU4x2PT3XAxCjQZJdtk7NaFvjCirKSttQkSFUB2crweuqGrBjhLItgGw9qHWsnvqwzkK4MwVgbLaeTApykl2y8qJ3klgdJ6MJXY8mpfh5JIA6GDA8Ll2DVIctdDXSRGSS6ZLljNDUp3Z+sEb4QvVu25+gGZq5BN7qjCYcyHrZlOhLUpXHyLohQuaCKbpbJddvy4od3+yF5e6D/vrrfNj0S++1csf5Zj/0Blgs34Rm1+XzlW6cSklbZ/6IVAg0s+UlDInIp1tazwlecsV3xHHDizPz+7rq6BB5CNw/b+olmqiAbE6ziHUf8DDPASb3aQbt1krKr3j2lU85FHp9MupVjPFy/nK6qZR+pbUrwLg1tw992DtuBc1p1QpkC0/TwB1a0iEWJav1uNnSJ7LUVNhPX5qaB2m0YGtT+AhdXlSJDpO3iKu7qcwOXk9Z9UN0oicHDrU+9gcDV3/pUiBnCS2ESSi6tEbU/1wSPdk42SSy1S9e1fp2IYKNEgLeW3s/sgX/l7PRMp10Qz89K5o99XlFvJ8aZpNZ1CYejt9otou165Ea2+VkLhVkerJdc7Uqt0F4g5AJZGO3z6GqL/f0dWeZaImGGwmHEME2j/qanpdv374wtRoc+ebCchdwSHZw8x3RjoC9MJsN6Q+nUmpXRzm/OENYHBpwYpQ9uyos4UdsNCnqogMJVhWyerSzNQPMfAyAb93rJWUPiw8m5F12Tbrvkh7WuUgZ6Rm+93xrO7B4eQIgmzTL8DbyVQUUpGUi4wbR1N+q7xJozbPfX+UxM+BMWWkzda3JIDbje7ytfmRFGgsTIcZywBcPKRuECGDWfPCPxOvvQwQ6r3joTK/rKT7E6ioumbstyEk9EbujYdInBpd3ErnOXGqVaFJmCvTJif
 GckRpj1T
 YEl2rqdu4rp5ddgyf1yo9CHqU/LiyNfKbqu8Y2OldzO/1fbwR+ypa43cpr/AojzWDdXorBxeaBmVzsDfWhqODpAUMIARJwSk87QrLYTczo3gRTUMCsIimhjkXPpzYrS0Ln/F4KasKF44/nPqqcvtax4V+cRIW55g2nfQdmqHTlGFpgQ9UiZ1I6c40UTH/1MLjN5EP9GkkxN/KQ8Vb3zzpdH3IXvOhi4yXx5wpQywVeTrJEcCzy3HAik+5XByTFygom6IZizLaJftRh7bY2nwdRHCJdYkG1+n73+AlxEZI8KtLHARMKLsrGYbq/r6n7WhUgqtV/Fh5rJiJUOSRP1MK9RIgN3f1yovNic/BtxbAOtxoZ1vkV6Akx1/qLKxQRrJVr2tjxkACyqEX8Kp9/5bAvDpKRjaV8rdS5xdn+zDhxBh6iC2zR2Fa20OP5P1o2SkgxrODMZFegiHvide5xFdZB4CnEQU/waaY+daclpDZu9HEBxE/xt3gU2GNdRkLuj9AQMoQYrlsD4B2SkD38sG4a1b5YU4VSv8b1bY3pAo3SphBj9Qhod0UMX70Y3SVQvP8KBHL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a brief summary for KFENCE's kernel command-line parameters in
admin-guide/kernel-parameters.

Signed-off-by: Marco Elver <elver@google.com>
---
 .../admin-guide/kernel-parameters.txt         | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a8d0afde7f85..1058f2a6d6a8 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2917,6 +2917,41 @@ Kernel parameters
 			for Movable pages.  "nn[KMGTPE]", "nn%", and "mirror"
 			are exclusive, so you cannot specify multiple forms.
 
+	kfence.burst=	[MM,KFENCE] The number of additional successive
+			allocations to be attempted through KFENCE for each
+			sample interval.
+			Format: <unsigned integer>
+			Default: 0
+
+	kfence.check_on_panic=
+			[MM,KFENCE] Whether to check all KFENCE-managed objects'
+			canaries on panic.
+			Format: <bool>
+			Default: false
+
+	kfence.deferrable=
+			[MM,KFENCE] Whether to use a deferrable timer to trigger
+			allocations. This avoids forcing CPU wake-ups if the
+			system is idle, at the risk of a less predictable
+			sample interval.
+			Format: <bool>
+			Default: CONFIG_KFENCE_DEFERRABLE
+
+	kfence.sample_interval=
+			[MM,KFENCE] KFENCE's sample interval in milliseconds.
+			Format: <unsigned integer>
+			 0 - Disable KFENCE.
+			>0 - Enabled KFENCE with given sample interval.
+			Default: CONFIG_KFENCE_SAMPLE_INTERVAL
+
+	kfence.skip_covered_thresh=
+			[MM,KFENCE] If pool utilization reaches this threshold
+			(pool usage%), KFENCE limits currently covered
+			allocations of the same source from further filling
+			up the pool.
+			Format: <unsigned integer>
+			Default: 75
+
 	kgdbdbgp=	[KGDB,HW,EARLY] kgdb over EHCI usb debug port.
 			Format: <Controller#>[,poll interval]
 			The controller # is the number of the ehci usb debug
-- 
2.52.0.322.g1dd061c0dc-goog

