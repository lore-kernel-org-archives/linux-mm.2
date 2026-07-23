Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4D6C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 20:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BAC76B0092; Thu, 23 Jul 2026 16:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591BB6B0095; Thu, 23 Jul 2026 16:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A82D6B0096; Thu, 23 Jul 2026 16:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2506B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:29:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3C51160182
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:29:28 +0000 (UTC)
X-FDA: 85021181616.24.60DA1AD
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf07.hostedemail.com (Postfix) with ESMTP id 13B5C40005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:29:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=remhri9D;
	spf=pass (imf07.hostedemail.com: domain of 3pXliaggKCHwxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3pXliaggKCHwxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784838567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=a2KNuiqZLV3X87jdwCQu+pUu3Q/Kmj/vy5AMT72i4f0=;
	b=AVVBGACYDVd4df02B0/IMZpadgVfdDKIkyQgWhIBezSLaHrrDeLu41YUSLYEz9Q0SGipYf
	fGQR6ocm6NcpQhbOvV0KYqPOfYEOaiDFL9VesqRHWugRqwUf28q3gwkFL/uPfMxZhVDebZ
	1hqlhga+ptBVi9KGW1+G+TtRd1AIh1k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=remhri9D;
	spf=pass (imf07.hostedemail.com: domain of 3pXliaggKCHwxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3pXliaggKCHwxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784838567;
	b=3uYEc3yRdn2hQjhnT70ovJv8HuColEQ04jAtOk7Q/8NMld25/rzAT2MinC1eGSf3f7mXJ0
	BpIZUFjAvO/OylsXkJRAxb4IaVb1j9BWay1J2FGuiTnW4mTUt3BT8lS8VrjXLSHSq/eBKg
	z2M6d7VHec1Qe6+0A3zAu/ZtVn2gt3g=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3811279d51aso1775107a91.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784838566; x=1785443366; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a2KNuiqZLV3X87jdwCQu+pUu3Q/Kmj/vy5AMT72i4f0=;
        b=remhri9D0GiiQj8zV1chroh/QfUJWLQto4UiG7m7gyMIQytYC4qWs09Pfuf2hVPq/Y
         ead1EOza/ZXL7t4BuELFvcoQng9TDO18v1bqRXk+oZfnLIF9KOuj4HrsEqemJ8uCy46k
         JiMtIrYnVmTMNwzVSAxj9uY+zJu02InQiMtYwDKJE0CTbhxBnwBmuyMmNSSlp/yNuX7n
         fWsP7gHJrcaJlsvUmyu8MACEVb5t8Qeug1cZ3wBWf9V1kS1yj+QFU1KUkWnuFYY9XdFF
         Ceh4OtpoGsxfB0EifQLfYt52uNJg8Ts+8L5iMrRe9RQH8QlxEqcpAe/c9Fi71vQg22Ug
         4q/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838566; x=1785443366;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a2KNuiqZLV3X87jdwCQu+pUu3Q/Kmj/vy5AMT72i4f0=;
        b=FE7kvrbj1K6OwP3wM4JRpZRsdQLd3k0Zt+b39lbsfnTFa1V9fXgQV+D5HaiklFyol4
         cU2eKFqUOriJLn8vR6uxHFTQ0zV0dv1tCwCqs1KLINXebLb7sbKfKGdxkflgrcQ8tzxv
         usGLvq9+fF4KExtxhg1rhQuRTWb84VLOA4F6/BDYuYDinP5N/u+uhTInXc0sqb5RwMNp
         PK91YeqcEbcZLvZiuFSPh4aZ2ZnQWf4sut7VISBmZm6PCfYZzoKOFTz9w+sh0Mr90/Js
         Pw53UVYoKdBG72ax9vc8EIm2WzwOFqCxOA9fBhtcMTalqHXktKHWYgoOpyUafSLVTuA3
         H8sQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp9u5Nlx2RkK2gDlGjJ3qXT7hKDBsjDeYNLnhS1IGXkJlYbaxN7uBduKV0m2Yed0XX8dfI+UfyUZg==@kvack.org
X-Gm-Message-State: AOJu0YxAVLJ8IECclIGwntY2gBSUj49jmtPsfTuXWRov410C5d3RM472
	kg09lLJhiIQKwIrLrO0XjkTv1DdhkC+ydEuIaBYZjftyokv0IPmDDdYrLJR6RuRPFhCm/PedtJu
	xBvHgqJklkpHXyA==
X-Received: from pjbmh15.prod.google.com ([2002:a17:90b:4acf:b0:38e:ba48:b0cc])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:134d:b0:37f:9ce1:cda4 with SMTP id 98e67ed59e1d1-38ec6650501mr4883813a91.26.1784838565570;
 Thu, 23 Jul 2026 13:29:25 -0700 (PDT)
Date: Thu, 23 Jul 2026 20:29:11 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723202912.1467112-1-skhawaja@google.com>
Subject: [PATCH v2 0/1] liveupdate: Add internal APIs for file preservation
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 13B5C40005
X-Stat-Signature: xbj4njnejsw8tngs5q31ix6kj31twfs7
X-HE-Tag: 1784838566-176814
X-HE-Meta: U2FsdGVkX18JB3tIYDHNsj5D/d7ilz7Bbg/HODkPwCiQ1ckh5GLpo0MlnJ7InsG0jsH+KSfqdRa4JtjVA/On20Izs/rPZH8mimYSzq3AKx/Pz/n9Ahmgj5OufBFuelMqKY3ZI1wMzFfkEhppZPmcliFnQRY+lEk8JVNdJgUfnscn4+FvJWMcI+v/oTV02UtSygffU7wAzlai12NkFmHZqRpfGQUoPwkFqEfqBQqThkB/UF5ov6u8iPYK8Gobie+xuHPl3Vz2WTKObC5Z4jBUcaUWZwg/DIbpIx7oGqatzad4lXoaS6sKV/wkmr3j8qT+3a6pFmUZW4MfiL+WfuQLcgfhNtsoSXiVo1Zkar5XtVlCXfHJPl27VRTgxmuCB7G750hEoaUO4XNTY/nNbuhIWnJcF2gfJlT4dXHpjLpWH4k4xgSwcDCO3Lw5T5OG0OgOEelOQ0oBh9S2zTYU0moVp1sTBoBk5lbRoS86jfIbQhQ69kJXVbQV7vfAmigV+avlc8hK2KNTJfl8mq9Y7nV1SZ5opz+j0ryl+6thI+Pd2TqknYUOc60gmjzkePkmhFRo4r+oxMRpltGcjQ3YjAt3SerIMXxnYMFOg/JYbQh8QJVZLGFLHrwQ9e8vjGU9l+G/3aigqBR1h3Xo2Jia3NDFS3EHefXzyQ92TJHRhgVW8HbpmioAHd+WDryvmbVahALbRuBlb4aglIjRsCgcNkX/lms308sUCXnQekeEFBTNGMVvvaNR/Vb5JPN8bYgG7XL2D8SNGg6bN4s1oxl1zAuUpFh8494Cu5VKV5851fbtxwgWyHc0yIruvf9Y9jmuGcslGPG0JTJ+rOTbr2fY61KqM+9YSqRCFUu5N9rWEs6mbwH7TfxKNw4V6Ek8lTQkj1cpF3IZsGaSQ73fPQkNFTx+kefeKW4G8RDFQsNEruRwYp0UEHXAENACKvrv9HpdyjoI/5kcUYgWE3KjttVZLfv
 jElYHwBt
 6sLuVDObAVu9z6JanLRoMNUDJakbomGww+xVq/q3zGTizWGfAnzbbay7qDMBLj2rDEobJ9CoD6OU9Gkh8JiWWjfHAB17ytXiF+6BaS10duiWDvjFeyQHo3WdnjSteYc1Do31NkVJdoQFP5bhx2of/5NshFy0TKzNEGNTlWOxcBbB+PGLicupYwq8OKU8JQ/HiVxGU979ram3ueDORdQxo2M/1oUsnqp9cdMQa15BheYMdCKSBwi3odSveELEpF94kMuK/00eluQAvvfqx7gpARl/uC3ueBBoAL3bbWGEjKf5xoCP4+9+M/03jrDccIl8c/hGCtwJ5cngzCGGgAWI4O+xjaiUDSGveN/PfmNE+kN6xufr5GFwmvTCILq3Q69iq6vADq4fz7sH2ZvXPNVQDzXntpOZW49jKp97cT60WFGC/aWtEMim8xpYztVxrwHDmEhdSm1Zw/gMnK+i6fKR93IS8iOG+LRcoO1QO4uq9MI6hJOaJ3zcFXwnZxNEOjYEN3uruJ2kI4YSPx0XC2F5fsiBP+0DQwLv+aDKgzMalQbTFtU+ueO9Xo4YBi6pZdNzPz4gQN7PnB8QLpme9VUOu3uNyeiIURval/Bna+DCOH8aAbH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Live update orchestrator file handlers depend on the preservation of
other files. To make sure that the dependency is preserved, the file
handlers needs to fetch the preservation token of the preserved
dependency. Similarly during restore, a file handler wants to fetch the
restored file of the dependency.

There are two known usecases of this,

- VFIO-Cdev preservation requires the preservation of iommufd. This is
  required by the IOMMU preservation series:
  https://lore.kernel.org/all/20260427175633.1978233-1-skhawaja@google.com/
- guest_memfd preservation requires the preservation of kvmfd. This is
  required by the guest_memfd preservation series:
  https://lore.kernel.org/all/20ae20f9d1a198b289444ebb4c824314cbba1bcf.1780676742.git.tarunsahu@google.com/

This patch was being sent as part of the IOMMU preservation series, but
now it is being sent separately.

Note that LUO File Handlers may resolve the dependencies during
preserve() as freeze() is very late and past the point of no return.
Also FH might have preservation requirements on dependencies due to
immutability, security and performance reasons.

v2:
- rebased on liveupdate/next to resolve conflicts
- Added a note about resolution of dependencies based on offline
  discussion with Pasha and David.

Pasha Tatashin (1):
  liveupdate: luo_file: Add internal APIs for file preservation

 include/linux/liveupdate.h       | 22 ++++++++++
 kernel/liveupdate/luo_file.c     | 69 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h | 17 ++++++++
 3 files changed, 108 insertions(+)


base-commit: cecfb90c5f2cc0622b363c2291b69d6cad272897
-- 
2.55.0.229.g6434b31f56-goog


