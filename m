Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BA7E88D8D
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 09:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDDB06B0005; Sat,  4 Apr 2026 05:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E1E6B0089; Sat,  4 Apr 2026 05:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA40E6B008A; Sat,  4 Apr 2026 05:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC9596B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 05:09:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46E2314078B
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 09:09:30 +0000 (UTC)
X-FDA: 84620300100.25.62EF50A
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6999580008
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 09:09:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PGbOOlK7;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775293768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SX1j2jpOZX0PU8n9tvbFhEKNcKUBE7L3QlUnR0eBVu0=;
	b=xivquqffG0T+5n7JH0oU1NzprMcWu9k1aQXqN5UrzrzjxRcIUFSHr597S9cL7iY7Fe9dQ4
	GZtKAew2GmG4lSibm2vFuX6tOWic1ZRBy+x+RbXdvuSu6KHvQleSlQl/oUMcVZjndZ/8RP
	FQS6z5iL/TjQfrXKtobrtdRW9QV1VUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775293768; a=rsa-sha256;
	cv=none;
	b=FxBJdbxYmUMgYgF/Lth7baD2RRthpXGSE4vmeR0UsWLvoyqLBvMN/5MGmeugcXp5Y5eP0Z
	0DifeBT+ny8voFrCrvM2iuUhIGA1XqcXxDK8i5Qdx4IEo0zqM8okU5f8Z1HF8Ie/rZDZbK
	whBwe9c094CFFmpZoZ42oYe2MG7XLUA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PGbOOlK7;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c76c067bc51so911741a12.0
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 02:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775293767; x=1775898567; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SX1j2jpOZX0PU8n9tvbFhEKNcKUBE7L3QlUnR0eBVu0=;
        b=PGbOOlK7TUEklFmNxxWyiTbeALuCjLHLP8DQhD08BFMV2mTLCTcBOQXKuGOTG5hslP
         1KHI+Ge8i0Xayc6EDq0lSGADmrT54QpehSoDO6g46fY2iEaHvfgMU8V6BKwV9JpH8BPF
         IsuYB88Oes15FyVEYAYaQWPyQWC5UT6UdugFGhRnqGF9DB1yMmjVvDOpcM9x081H/C9R
         ZopOS6ah5/B4F2AxgjmDjjByS48t0Zu7ZvR4VP1Q/r9ZIFIu+op3b4Gwimq4M4BUzFFC
         TQpiSlwCybYiEpW1+cHcffZ92szrS0tpGEpo0sD5eOAhaTF+m+P2eucPalMnpeIHkO3W
         1pyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775293767; x=1775898567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SX1j2jpOZX0PU8n9tvbFhEKNcKUBE7L3QlUnR0eBVu0=;
        b=nA+tTiQwOYLC5d6UmrmowEYhokM9hCLPG3jPm1ntWxmfAvoleceyMGHtLaaQnFXg0/
         m3wt4HFeFOrloqiBnyxskqg/GAeATdCFy0BPHQInr+PEe1o+iF/BW0vxPWFsUVl1kbRQ
         Ooz9jkphf+KZ55jNbQVPeOAeK7G9oen6GfsoHRZhCeN5IJi0xjHfashnl+bxTtBnjAKv
         wbHlI5surTq1ciAJfn0joUOSW7sdB9CtovJsN9szt8Jr3VdlxNSmV2wEFAK3SyKgUWgA
         BWf3mgJhxZiAkQeVn0bdUoSdX56gmOinboo1XOLlu4cscJjOtwxfiFEcCnIkvf4Icf8t
         mRcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSDTXO9dlKbh2p2roTatPhRXE2nL7NlKuF91DZHkj8qHYOefHQsRbDut0gAS0unJcNf/ToL1gNUw==@kvack.org
X-Gm-Message-State: AOJu0YwxpUBLyoxTJXv/5FD2f2VLmU4xmWFhiXdnb5mLwTxsMRs9nPi6
	IID0ZgklxKh6V8y3Vlb27+CE9JtK41TDxzOfxoiaCkq/UPl1W98yBncO5pJYzg==
X-Gm-Gg: AeBDieu6hV3clLOdRkmD2/8aRfqfUgJsr2G8r8v/gQbGBDn78NX0kg/zZt4KvtTjQbY
	jXczLR0QvdHVhsReb+CN7vV8BMHN5utXHckJsBHvTYuGli18sG4lJJCTaH5wpi7lQTPQRZFwNpr
	qJTBwm7ni3B8xDJv94WlFJ3/oe9QsxtJnlwyXlBfETgL0rwIzxmqneOKK4x43ZLEQaVLSqazIEz
	xc77PkkaHuwU/dHyrhXnlpoKccBTxfEt9tCgHwoLt22rI2SQOrD+k8NAFv+iyRsPSWgkM49yiOF
	HX78Wi9BUhIE1HKh+u3E4XfnO05fgb3p8vEfqbY7gvPoCU98jNm4+iPczSqqwr2Eh9lSpa2d99Y
	xg3GfZJeJwZLPrCnLPg1hijYFic6Gom32fGOjzh4OjLXWEP7D/bXq96Hh/vBtdVxjGPEHQdwCHc
	u/aE+upcXt/MtBCn5PGn0LYPcvWy7UUUymtW2S+XNpYLyv2PYLsqU=
X-Received: by 2002:a05:6a00:1bc8:b0:81f:4529:83a7 with SMTP id d2e1a72fcca58-82d0da47b1fmr5129179b3a.15.1775293767146;
        Sat, 04 Apr 2026 02:09:27 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b2694csm8185779b3a.2.2026.04.04.02.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 02:09:26 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Sat,  4 Apr 2026 17:09:27 +0800
Message-ID: <20260404090927.6055-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403155530.64647-1-sj@kernel.org>
References: <20260403155530.64647-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6999580008
X-Stat-Signature: 5fi39bdb398t6acm35tit35zt1w3g3wo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775293768-844984
X-HE-Meta: U2FsdGVkX1+hu31DCHsBLJjgvSB38yRHUDmmLWLKgzeg97V4nqNHAe5tzegMyb5IHbehzuVJyPISdkiYjF+C+QC0uCJxgHeNzFrItykUBA7g2KUEj9yw/WaEmuw1qxKFRfRnTeH4rI/3sV3FR/clS8RK3Z+Ep6t9Df0v3WtWme45QhjxG8n/1Juum5q7um10D2EvIdNXQlYiERpf1DYZtgvNLuYmcOuxsDDraH7i0jL7lIc9eyxPZneCZWcwwuHuQcOWlLRuT7b3TzLkwin3LW/UeqoCKiZcK+PIdf2evOcxMFHrBmP3BLchgVX1Km8Y9Zjiak2n1tIJrCKPIxI3dc0D6fAdlxZHP//HQhE7qVrPyOCJEyi6FpGBwXcmVKEGV7Nz4GxszPaViv2++saKeN6kj9m7/oXAOI8SH1A24dADa4xDWEnmFDHvyyfkGhWkCrqkOsQC8XgFlYSNoFR9EJQ/TAWZ00USy8bwrmXAFN0nmAS+kN0KX5OKeGzYF2WdjrodR4iOdAK1ylZbHT0mHSEFv7BSxnixk7uEzYFbGb6AvHHZsFCQ1/gt8YIjyTtR9ghnRtRxEuyvb/uGBknOcLewt3yBIYzNjbd1MbF/TmpyTItw1q4Spo2Ma9lnOLuB4DJCIHoewD5xb34smBN7j97hP50LJMng4RPAXLZo7m6CwFOnCsbISTGFLVQCbT1+8eEpwrUk0BcEBTsiMx31nh1TwHb43XxLCi2SnIoEwTukBqC6duBFry0em7j9aLJDkYY1jBgWLeGvC6L5gqP+qGZLanq0jdeSHlrh4gxurhWEySQ7np1krwShPqeVgbseVFHLX1yN+wC7YyGiHT5u1cwiZEjhUuRrAMpTy4EZIoyVHWkO4AWy0sZhybCG6u1vV0FPWAKuWHB9jE/SU0ulR2kvxwB05PQuz86hCEDHo18WqeOg6beA4ta6jsRukz+lh49mKAfljpT2mzjyA+C
 BRspGHq8
 BBaL4p48LKOe44cjCzKV1VPDrIwq5QzcEuXeoHOW9bqJnxD62NjhEM7W9C63XEBPzdmz5qWPymvu+OEmvzqX/KMqTXx8NL00VefZ86KO+yzP70VcM1rhPyl4x2e9lWVoL3dTaxCQBvCSLShzMKXBzOR3UmrD3pNo0Sj0W4kcGBBjhknWiMZ4rPivt1t9R1oHesWH/JMFpwUi/+gX8wGKt8p8pO4RV0z05HXmYccRckFMj1X3Up1kp7PJ9C+HXdKS9GWsQtC64hM1SRa7Y1x1Wq55jHIzB9SZgm723X0DE9HBn5Djcg6GIzWHdL7l4t8eVJqgZd+mW8Z/8qVrjWen5ybygUMkX5jiOMQ+/uUcpJJjUIZ3UinUteObJPFY85SbLRVwwihDgIkDULA7moc4ZDR1Ewl2PAb3uA6f8azdFBtYdw/RjqMr2nkwGtM3nSUh5JTl0BHKpaf7SBcD0wYIdZvNTUQfZoHdRZDVnqFihWI0Kysg8/Z6NCpcniw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Apr 2026 08:55:29 -0700 SeongJae Park <sj@kernel.org> wrote:

> I recently learned not everyone is interested [1] in sashiko review.  So when
> I sharing sashiko review, I now try to drop recipients who are not necessarily
> interested in the review.  My choices at the moment is the author of the patch,
> maintainers of the subsystem, and the mailing lists of the subsystem.
> 
> So if I was sharing this review, I would dropped stable@ and yanquanmin1@ from
> the Cc list.
> 
> Please consider doing similar when you share sashiko review.
> 
> Everyone including myself is learning how to use sashiko well, so it could be
> confusing.  Sorry about that.  I'm planning to make a guideline for sashiko
> review usage in DAMON subsystem, and update hkml to embed it, hoping that to
> help reducing some of the confusion.

Thank you for the guidance, I will keep this in mind for future Sashiko
review forwards.

> Anyway, seems sashiko found no blockers for this patch.

And thank you very much for reviewing the review! :>

Best regards,
Rui Yan

