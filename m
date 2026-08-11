Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0AA7C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82BB6B00A7; Tue, 11 Aug 2026 13:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32F16B00A9; Tue, 11 Aug 2026 13:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49BB6B00AA; Tue, 11 Aug 2026 13:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A75F16B00A7
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:01:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40D8AA015A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:01:37 +0000 (UTC)
X-FDA: 85089605034.27.E0ADCFB
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id AACD51C000B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:01:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="L/fRhkV3";
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786467692;
	b=tiI6SKqfAdbZFQn7sVgmQUYfgp6lHpGY4oZ+JOEp1arrYJX2ftigCfV1s/7ZX2xgkjeqyE
	FyrTZC5552E7H9uyFcWK3q1B+yNo8bBbTSsH9Tt/YvzjU20C2vU81C0xA4EonLBcS9E7m2
	w+aBN0mMqP+pjZ8D48QZMZbW49fahVc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="L/fRhkV3";
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786467692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvvwdmlhQN6SCdBOGflAFbjpJPXCG4Pqa4APAhlzpLg=;
	b=zuSWV8UPgMV1KAK8YWPwKY3p8799D2GQrAsrnF0rRJpSdl6MAZt/cYWWJBPUnnE81OtViP
	AEmv1CMZwi8bM2Zon4rUriOemryLNzVTFiRjjKEZZu8febXRmF9tvGUVsaWaKsYT+6D3Y6
	oPEhQoGqTiyefQMIr8Yg03nivspEoR0=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-caf45fc5202so2842237a12.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786467691; x=1787072491; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wvvwdmlhQN6SCdBOGflAFbjpJPXCG4Pqa4APAhlzpLg=;
        b=L/fRhkV31LQVrIjh6gxVpVJQq/nOq1T/08Zv9kVBurKbKzcek3Rf0fqQbuUDme+05+
         tO9wc/Q1EuNHiwr/MN6CV68oCWQIA+4uTDBTuK7RIgzN9TTf/ErQKMtqJHCYk6CR71sR
         Dn8RhTCz6Ns1BpcYdHwRQjQbmCMFuZOcmlGJLVpVw13MbKVuljDcznoin/ygMjGHtcDZ
         NIeSuXwG4im99AuX+2lr+yX/sjrkMOLayQ/vwXUfPLSeJSAtI9v3ozx/j3zu4fW8MVzk
         8FQZk75v3bt5wAKRAZMPLIxZYr8y+p7ouwWw4qZr7MHO4t253dnokos80lg2uxBHYehp
         K4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786467691; x=1787072491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wvvwdmlhQN6SCdBOGflAFbjpJPXCG4Pqa4APAhlzpLg=;
        b=riu2QmAe0tUkIE2Vp7Py33WWlfEwcedum3qL2Z02hH6VUwJH2y/yHkRwWgetiMO67/
         PQNn1hai6P/VE/PIsXtBH7bWYSEMvGtMYy0KXqMuLlZzVAH6/O3C4e2/kquAdWcCykBp
         +mC9r0iib+V4TruXSVOWVAHdGwqyC9ztNM/d1DV6W9kyg+5fBouW8Zkzt5jQrrqPHtcV
         OLnjoBFJW4/WT8TIq607Ou6xFkdOxYOWTFA736FyXEgCjAzTtVrFX9Iv9GsiCvMg3HbU
         +oXwNpmDOevel7WwLnQkH4amOYdIRTy4LY9+9P/n0fDFIQ+R535/HfuuQvUnrZikZPHI
         LduA==
X-Forwarded-Encrypted: i=1; AHgh+Rpunj84IBe74YeEpJ+Jl9upYKmdbReqZSCbz5McMhay50k6zdq6zlTKLG44U4eJ4lrl4skMQtLPng==@kvack.org
X-Gm-Message-State: AOJu0YwNoeiUK8tlgUm6ww3WJ73u8Dz5+qUeBzqxt/jC1lSBqhM6Wfes
	omMrOGF22tcMxV5lcNdGFM8GXo91WWEpOd5asowln6zG9WhmOJH1eiz9
X-Gm-Gg: AR+sD13Y6llbUHcTqBcXmcZmw/NYwxWRR4N5MF9mFo4quohZ47jbWhQED+vjM/yDXxg
	lOviPACDqnx+8kJMjbjA+/IugRGOB/lGWPQQ67mlfwjWmWyfhfn/LqMGuSHKxWdzFM+apA46GVR
	LGJQM8O/MjvZEDy38xsrZyQZQRX3KU+D+yhPYVY5BCBVrLBn2I3CrTGMZPtDIBzdrLe+uLKLIXK
	2qhoQ4t5b9OAljM93ohyNbDXJrNIRVAobtKEEHtw5DnWmIsT/56dJdAYeo6YWA4gCSVgGQlNeNT
	uCIjHOMZiN6qIQRXEkAHUF4ZNl3Os7RLoF07FRocuKv/9kbKAvDJiWub6Gx0/PzrttGJcuP4x4K
	z/0itc00mSOiMEsXu+kuU6YrCbbP7qOnHSmd43tgkEVpzelv7zgGfGFIqxfPazeQs6vGsB7YFrO
	v0V4CwM9cd8a+J9UpGISZ4alIS9zMYn/xyuy6DX1I6i1VBXC6VGl8yqdz79BoRjN8=
X-Received: by 2002:a05:6a20:430b:b0:3cc:1dcc:b079 with SMTP id adf61e73a8af0-3cc37db71a8mr1669990637.19.1786467691257;
        Tue, 11 Aug 2026 10:01:31 -0700 (PDT)
Received: from celestia ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf6d726f1sm1912651eec.26.2026.08.11.10.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 10:01:30 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/3] docs/mm/damon/design: accurate semantics of nr_snapshots
Date: Wed, 12 Aug 2026 01:01:39 +0800
Message-ID: <20260811170139.32342-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811134634.4407-1-sj@kernel.org>
References: <20260811134634.4407-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AACD51C000B
X-Stat-Signature: oppeaxusmh6u4mkxg1t95u3u3caubwmd
X-HE-Tag: 1786467692-47035
X-HE-Meta: U2FsdGVkX18JPORzowpRbv2IBfeoWCaItbux9iysVk39J1GujqGvF9OuZdBfCoNupbHAEDyh62ieSklOpjRkbDMUyhJ8nZPUkFxUZwyZ46zS9VX6S99EBCCxbz4/BtGfECV2V17wCTLaKTumCVBrwDxHnzdBUFtAQt+jfOHx3LRFM3wyiFBZsOoewI5Qn2fN5XIPPIxAXjRc8flJho1mc2xbRQmSozBG8p2DtpGR9coQA9tuKJlOwexZ/C1O0hTonaGuBtu6EVny6J5DzJ+VZyGYNEyWXdp//9dU8f3D9eSIXuUyf44MOnujTHnonIgmOXa9+Gj0k1grY8LAEYPQQ66psLbXUgvBK+rcNgQbZj/mF6asOGcQMiGPgaRQdjDr3el4Gmf/gH/FzlwuyUW8MZRnK6lS1dgMOKJxwzdpOF5xzOpxWRpezjOErn+qwCtzKHR06NF5kz+DORWWqA+HuyOD7BUFNwAOe+GN4xuaV1Xs8GRmUy5fcJtUZshK12fhsM0QWKFevSFPEIHQaQBaiaC/G+NSH3tQotN7evDmAPa9dSMYpGrsXeSpydMXKPPWTz+5VBauPFkQKy7Ejda3N3zQP5xadu3wjRKo9SQOQiyJHgjGUd4nAsv1rGh5KcO0PJD78aikjIaaCm4/eR2t6Eev2RsNhwSdzRP83UDvsa+NFqL1pK0QGhwTqlyR4MiCvkVQH5fRToSYpHesQllfH8ocC4ZKkab+I4lZsuLCmKYY1m8yLzq/0oOVtWtvNh5mHbO19Hi8nw9/rqfFXjDG5A6YaY+VTlD1JkBjKQz+zN2iEmc6ej8fanjyfDNpwIGe7Ihm4rL5pisq2wavXGgJ3zJjXt4pqXS2hwKFxjwdmhoQKCgvlOG/0Rf0EzM2CgpbERvGqHohD3zZHTYycxP5UvQaSalAR3onF2ETbNX2h/mr+FKURpmdnl62Ez7IRGgerjQXJ8TXMJQzjRuS0Hw
 s8mUKzgU
 hIlRJ9LIhLNlAtg98vfKTja0WrL3agl5nGbiw0ImODclSxkKvk4kySuu6umuTDd8F2J4Zi+gVblPNuX430LX52X2KX9o75JbKNVJbTAp4Cdu18sX71d0fP/OFcWQuev9g4+A0gNQN6cISm8TQE6cwSP1O8hSUVYYrEW5Nxgn75D71BSCh3n0hiN/PAfBiDoKeOOpKtKY89EWHMrITHGpqEla+sobFmIuIHKZjV+okBIXcaI9vYhPgcWbmLv5dL5/nuhJIxTWq2Kz90Gf29qiwrJcgpG1kKIjWWt65XG3dbuVDgyj4M+L64w0Xgz8F4iCfm46NUgkTn9l5Sm86Stb8IpBOWZHEf4h9aRoytFVdjuvjPX2At+p6wWZ7nMQlZpcmaSUHN5EKVwId+bmhHHhb7KdGEpkap83WW7JZ6MOwkk9bAcXUDEU63rbifGWZ6YtS6GpGN0DzN5rSIPpGMwTYjoEZREgB+xnhCiyZFhbuPpExcZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 06:46:33 -0700 SJ Park <sj@kernel.org> wrote:

> On Tue, 11 Aug 2026 18:18:39 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Change "tried to be applied" -> "tried to be completely applied" to
> > maintain consistency between the documentation and the code.
> 
> It feels bit confusing to me.  The completion in this context is for "trial",
> not "application".  For example, someone might wrongly think the number could
> be incremented even if a scheme was "tried" to be completely "applied" to the
> snapshot, but failed due to a quota.
> 
> What about "completely tried to be applied"?

Thank you for your clarification.

"Tried to be __completely applied__" means that even if only a portion
is tried, it will still increase. "__Completely tried__ to be applied"
means that it will only increase if it is fully tried.  Right?

I will change this in next revision.

Best regards,
Rui Yan

