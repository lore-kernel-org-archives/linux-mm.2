Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A580C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 19:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CE36B0095; Mon, 24 Aug 2026 15:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E386B0099; Mon, 24 Aug 2026 15:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20DBD6B009D; Mon, 24 Aug 2026 15:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 020286B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:59:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76B94A2DB6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:59:25 +0000 (UTC)
X-FDA: 85137227490.23.A44C8D9
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 65D93120003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:59:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MJtYT8o1;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787601563;
	b=7lLqL/vUgbPzhEA4/H6SkS7bt3NzZRzOyyVpXOF4xpgQsTKQP8TemCBh5mEvdLXjKjfm+K
	2erpd7HvQ3t/1MPoTsI3CROAS8tyrAeGEn50eUpxRYbxrpP8506P2Wd6UXXRwYNUxXgEtM
	wuDrqwZiX7hg9ex50n6cZRbhZDfgP3E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MJtYT8o1;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787601563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOiJInovljZCEmW5jxkHPX3bxzoPTur/8CMS8PTws9Q=;
	b=5toh5hYs5ejlMPlk0kSmvAA1hme/DV2WdvZXvvPNRt6xdwP5uLuAyzuB7lmUcgjA+1nj70
	FBFPC85cx3qXmtzLRs8EJwDNCe3/oJgHapodPucWBsITRXqPcMgs6FFKRue8att3OMqaHD
	s3lZxqJbnxCmUrf+Lk59z3XvAXyh+I8=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-526f963372aso28560601cf.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787601562; x=1788206362; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iOiJInovljZCEmW5jxkHPX3bxzoPTur/8CMS8PTws9Q=;
        b=MJtYT8o1ib4N2wqGmps37o5NNXxnyCIJXFaNPn7MgFgnoSOl41Eu9bYpuiOeuCBByH
         RdKOH49vWy3gUhD2k7x8kYkwLJr+ipb25ogLykKmFYJkAvYn2WN/8r5FvTQDmQgq6ioQ
         idoouWm3wa5nnvRvPo5PQG7zjrqE0jwjCQT1bp3nSVQ/Poq7Cm6ofMIyrvCZgRN6WoIY
         KAHYOsmDOOr3KcFncf4yrlENRLBuNaPOU9CT6PyqSCCk5f83QGeWJu98HhpK0wSJErxh
         3GhVLT6/xmEYYanK/gl3654ljSFwNmdcHkAJoHvexiuiIaBTtZL7EyezA9ppL++tkIif
         k6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601562; x=1788206362;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iOiJInovljZCEmW5jxkHPX3bxzoPTur/8CMS8PTws9Q=;
        b=a2BVKYhF03MEUqnqmsLvSCOhQ7/qpYn82U7pWoStuCCQ1qT6310k5phbzSq2KOTc39
         f7wl14a4o+XqxnMyODYFwYDW8fv0CtDX2PQIk6bbWj74YeTw+ko9vaIUXfvH6+/aJKkU
         1K1AxrVfVlcNOrCkCcEYeJCthXQlWHGQiReQvF3n3I76X1PQBqU6KFVbNajuyWlj7LZg
         YU8yccOiZTyJvdPlScKJqXFagZqHf/vp87WJjyTTSjQyLdEZtMKSDSpo+AnYn2keUMmf
         S2S5XNLoX6OwqcWIeWWHv4LsBfXvLedlf8cHvPs08QH0tFJMQcDoXewcmKO6jKuTTXST
         DxVA==
X-Forwarded-Encrypted: i=1; AHgh+RoOU5xUl2FIHgqqZC/l4oElySy3vWtFrRNsP37yABSj0U2kKPrb44Q6BY7FwSQ20qscunJoIr4vPg==@kvack.org
X-Gm-Message-State: AFuF++lj95FQBBo/zNPp82IPQGSDhF9gy2yFViLlmGH0YfmGbe7/4q6p
	2xUDA/k2o25aSva9/mpvKKxYCLnI2wVSCR548fszmcKEa1vj9wvJHFS8v5DjrVnhV24=
X-Gm-Gg: AR+sD10CvcUwMfrg4fYovzmueks65UuGVFOIC10Nfs7pV9y/b7UM03gWyPwRHSWbBdg
	ruC5/Op6fTXFN97kT3mHXl4zAXISXm2uK5FMEZByKvR5i5IFOZboj95wLH5wZPJXSXRoCwWfMai
	Zum3rQKvN04DtvwO3lK2zO24+9k68SkGcINUAaoilk8Y7x52uVvAHHW/cb7mDvYUj1Gwq36tr7i
	YYa6YlpHePRIETadi75ABzVRB7UQzgx0Ajge3JUlW5BLJfnAAVNugwvZyvEaAS0EPcJO463fYZv
	gDQghs76EhdRfUGbM1rEdIyQjs0vd2ZbZljPwb/zboLeSAf947fjUYL1ije1eRSfQoh4D2qESk3
	V1eNIpu2GcbkAentLqGcYG9Hqdxt/nKEmA6z7vINelb4Q/JDC0df7kALEa6jolJGcYbYdbFkzWu
	dwWafhQX3aSQspye26MptwPXukNg/W3od9B6PbV76BnlwZKpgfA9xFPrsIOKeC8e8p4OroOkM=
X-Received: by 2002:a05:622a:2587:b0:528:17d9:2d99 with SMTP id d75a77b69052e-52e09d05552mr217305401cf.43.1787601562286;
        Mon, 24 Aug 2026 12:59:22 -0700 (PDT)
Received: from localhost ([2600:382:8b2b:357c:c834:fad7:4274:2299])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e099ad287sm54058141cf.10.2026.08.24.12.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:59:21 -0700 (PDT)
Date: Mon, 24 Aug 2026 15:59:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Enlin Mu <enlin.mu@linux.dev>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, david@kernel.org,
	mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, enlin.mu@unisoc.com
Subject: Re: [PATCH v2] mm/vmscan: fix comment logic in balance_pgdat
Message-ID: <20260824195917.GB863036@cmpxchg.org>
References: <20260821064057.4081-1-enlin.mu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821064057.4081-1-enlin.mu@linux.dev>
X-Rspamd-Queue-Id: 65D93120003
X-Rspam-User: 
X-Stat-Signature: rojoc5fzoxgrjr1p41rqdrq6u8mh36xw
X-Rspamd-Server: rspam06
X-HE-Tag: 1787601563-16401
X-HE-Meta: U2FsdGVkX18jOdhGZbfZlnENmYsWXuBT5SHT8DqMkQwLAYeZLCznb6ggPG/dxpI8zlsFMUFPQyplu1GcYBJ5j5XEDwfN4kSLSu++hEtawIeSoYeqNMDumdmT0khzpJufwI391Ne6uI+/kx1OUNPNUR3ExmN/OS4jZnuNIwNE8DgGYjN8lF2rI161EdMN1KcH1mnfbxM2aYRzktN+OfO3BfH14HEMSWqiIohn23RdQTTZG9cMLhYnVjVOle2lV/lXCL6xPEBKd+yckUG6BpGFbzLaNLiv2VL+TIfS0ghvrjFOVd3MVyW82BkF05lSrToXxXTmZI/2SLrISfXIdM6ePm84ZrZFmQKs6I5UMfErPrOEV6UlFHpqsM8rMNr4ZPn28AYXnb6BxdjJGbeYX7e5NB1IFoTTLCTZoUNWn6ahKnjfUR/PFPL8+h/dHrK0hj+HrLjCt5E4pGzUshF5Pl0Ic9NCwbYakYFKygkY2Q1OVV5sPYfDxEVG4N9wbjR6La6i4XNvoA5sNgBEtTom0XoeVkvni0B8q1AOr8T0v6DE750v8/6zqAmuYlluvnMw9yJvQhzo29Qk4WIFjYr716H5KMsMHILqXOnSHjcby2d5TqkQtRHUfoOFWWY07fZWX7u7G0KGFeXzWxIoz9/aZAgII3bQUe+p38TrbjSoZIX4zvQLcoaUN4PcdDhLY25P9mhmNeWSvaOx0itl3oUwxWMhK2jMzoqmuNve086b5erC2flq0zFTJlxmHSRG3sTfpcSYcPKGUudWPQhzCk4bTVOxEGic3eiz8A19Qw1PSabrzrYvRa9y1xhxsK0aOVSojeaphvEa1ggvtIaNRLbcB43miaJJuWyYDue+h51aikL1HfAqOHZ9JhuYWOtqejQTfYpwUxhv0iJNh5jP/vc9IXGlWNwhC+gIpLplKgsYBPc8jqqJzuypBLkINqH5WFMifL1BBSQeFJ9gYFWQQg8JlsC
 iMP+VrF8
 tu8C6thl5tS/bPSaUoJ38xoMsn1grozhbnIm4n1xEoAlWbfUD4n/rORAoTI1c9OPVtcJaZpUAXjXWotKo8WBVupq+L6AwIH69rPfTO+1Y1dOaXuV+MLjDqShvnptSGpM8w51AuGiooPDm+ExCWMZmBoNgF3pR8kS7HsTt1y2qoWg8x+XSGjNkx+XWbyd03NFua7l7XbaFA9lIIGeP+8Ui4No+1icgjSGSbrz0DIwyGv7U5Sn05IJYKwQvK++hddymhkkNZNf9kIXnGnZLufhMF9OlLpyMgvGG0FwdHGaoKkO4MhPhNHQRBcDUSAPAC5i4hVcAn6cNgAevai3eLi60M3AUhho8QLZiR9841pG3Db1RaHGigEb3hxV15kjASbgR1HdKj8T4DUUNGpnc4m9vQuP/TACoFdOYBqhNNY+yS7cFTBEOTUQvptuj2C94PiHLCXDbhqlcksEh8Gy0Oo9HeMP3fTDJAeq3eGmdRAHB+cb9OR+cTtca+0/7Vym2lorE27ePdu2F1c7Db+KZc6yKKC2/VTk2yjFaY1nn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 02:40:57PM +0800, Enlin Mu wrote:
> In balance_pgdat(), when the low watermark is met, processes sleeping on
> pfmemalloc_wait are woken up because they are able to safely make forward
> progress.
> 
> However, the comment incorrectly states "they should not be able",
> which contradicts the actual code behavior. Fix this typo to accurately
> reflect the logic.
> 
> No functional changes are introduced.
> 
> Signed-off-by: Enlin Mu <enlin.mu@unisoc.com>
> Signed-off-by: Enlin Mu <enlin.mu@linux.dev>

Looks good, thanks for updating the patch.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

