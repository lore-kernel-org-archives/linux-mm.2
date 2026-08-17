Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA77C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 03:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776486B0389; Sun, 16 Aug 2026 23:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727156B038A; Sun, 16 Aug 2026 23:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617A76B038B; Sun, 16 Aug 2026 23:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3118B6B0389
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:02:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A48001C18B2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:02:32 +0000 (UTC)
X-FDA: 85109263344.24.D81F2F9
Received: from mail-oa2-f1.google.com (mail-oa2-f1.google.com [74.125.231.65])
	by imf09.hostedemail.com (Postfix) with ESMTP id C246C140006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:02:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gCIpilCG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.231.65 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786935750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFXjg5lrQe04sAw6kzTV2oqnle1cBD+bX4fD4qmXihY=;
	b=L5YuxSV6QSaVnX8JC2GrE1e7SAE38So0890mnGasqvWcdS/zK6WBQSy7ANY7MWeaA3meqm
	5O+O+F9SAKkjuvpz9Vb7Zn3yE2oJgyEmZzvio+8lEPIL69a8vIPHYuyDCA+EPWsH9v9eYf
	Gu5kLJ5f24u/XMRjip1cCTA2fhH/0oQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gCIpilCG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.231.65 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786935750;
	b=xtPeeSYRG/VzLXiQz8zfVBQXkA0AqNTpesbvQj436PVfrm/1+8f/O7nD3QsNsXeSBLgD9k
	qcZ5QlEQ/HovgePGCXMTQvShinbh9EY5/U4nRsupxxOw+iACbg68xL8A2JsXnT0y1O68Ok
	xutnw18wjFNigQRp3yhrlmhfIKPG7GQ=
Received: by mail-oa2-f1.google.com with SMTP id 586e51a60fabf-44cf1835ec3so1186828fac.0
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 20:02:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786935750; cv=none;
        d=google.com; s=arc-20260327;
        b=WwcbWD+HYxfbxJwAr4/2MXsueXg98pRcSltCkfZkxJaFS6DDyL1R8ALgzpWWQP3eWg
         g4/eKcpEGDtxbIpkqet9lsdFimhsgsLc2fg/EBgwJWavM/08hJZAnxnJc9zVHDBB0fOl
         gK+iB7lsBZBDiR07lst7y2q3qDBJBuyQl2OQa7Xb0bnZ9ZucDA38tIM9gM6Q0XaIGOzw
         fZswDRFY9lOnOqu5tKrO1UHLhYpQ4qO518X6IaQ/KG2GoPhHGjrjl1+sVbcfYJKv7yjA
         IVP0z7cXv7KG+BnFD3wNKIUynuLoYSsTtwIKW4MfZIDgNp6sfIv4wjOUBhpYYd9UVegK
         7gag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UFXjg5lrQe04sAw6kzTV2oqnle1cBD+bX4fD4qmXihY=;
        fh=M3L3DIJyzePzSIvZpTVf2f4fxN38txCN3fGEzimIYyE=;
        b=nrfdwStMCEYV15PeQ9yx0+VVi2q43vvmApjo/1EGNRJQus49dsYUJdudhnIAiEsbzI
         G+3n9mMW76JnO4jfbaONYMu1B6lDqpRRacRXXPczSsvtHkz0oXLv0PtH4nqMNMHCgr8Z
         vOiAiK50sZBbNyNXTanHFJY2lTIifkUrBRNKlYHynXQD/C4ZYSi/D936kcZo12d7uSAt
         Q/Or0iNe54rwhhaAWeme72xYTayXHYKBxdzKxZFno1jhHGM25/MAp03SUN/BN67TzGh1
         yYOdzw3qjsuVr/8m8y/XvzE80PIjgLBnT6nWAL737kSSx3fF0jI4m3L49Gb0lSWOUwLc
         AXMg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786935750; x=1787540550; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UFXjg5lrQe04sAw6kzTV2oqnle1cBD+bX4fD4qmXihY=;
        b=gCIpilCGDuxYBfcVQYxbzYIqM5SY3A0smUQlSniv9HDIlKuxSNQ1S2ShzAB1ef4KTO
         JAd49gI23sj8VpAXdHMYA/ghJwH1xT5GH9P9mcST6FBou90LoN0cZg4e9tVGNPcsvuD2
         +bEzIFsgQxEt8uAjEXlza91BYfYdA20XQBcsdZjky3vj93M1DrdzFN9rTI3MRYUbGvnw
         cQp+ir38Td3IHdtZf5ZhNFNRs0mpBTEziaUPGLrynQx9olyygeVSMqh0KN+vAyyO179F
         kC2iC+u/t82gxFJmbNt6CoZ/m7giZEnp6trToO1PAUiKc8EgJ2Zakh76in34bnuYxmKE
         2MTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786935750; x=1787540550;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UFXjg5lrQe04sAw6kzTV2oqnle1cBD+bX4fD4qmXihY=;
        b=tVIQV7vdi+O4lOBxGuAaJsglPWD6J+NwPrgFPlA8i7hhRp1nuVyR+Qgl+rK1kjA+FF
         /7VhBa8w4+mMF/5xKl+pWDoLFp0nFNLCKvnQCrJ/3yH+S/JH8ZkS3HSGkRwZkLdOhMRU
         PMTBK+6sbkIr2yWWbZF7tDHTZX69mRzNcYSyuAtRTGpRAgHXQklHQvnFmanfTYBbxYHA
         zinSuEgZU/jO173UqC0LOZDLg1xvq8cHdrNTc9XtROsvRQI3NTN+gw6YmAbGGtgAvgOg
         xvYB/b4DSU4vm4/+SC5xPGfGOoWI1QDqt/wVx/1U9j/qSbrrP+uSQ2NWPBbJ0sF1b7y/
         nbvQ==
X-Gm-Message-State: AOJu0Yx2h5zoMETbtYNRJD1yrYjkDn7jMcO+zTrP7zeCOQ6czJVjIkIw
	6i4qbKDA+a4MnAyksNhYG0ddU9UeLTQ87K5yCxksSBR3FWFldw49pD5WzptE1rv6brlsZ8ydGse
	wNFko/Z9nUkm6J3dAC37mdRxKI5w9pkQ=
X-Gm-Gg: AR+sD12Azdpz/TpixIx1w7DJzb/1UhPArEoT/8qNZ3R/uiBaXhaRNucrzH7MgUI907B
	MnGHEHtMzUmQLFjsOdU/j96+TGPKjVcjiILSYpU+QzmvjajCz+aBeB9x5hAEa4RYRgiMhE776ML
	S3bJWP2FKyokoURCQvtsdpKswZVfoNYkfb3bZcYv1sBPYn2TxZQS1rb5t94MZAaX1MiyDHu9ox+
	IfU1Bm/+w4Ff/YP62r8k4GxPVOWlk3mHq7k/dVXap5/JzU6kHqEtvJsXFGsT3snDASiYfKG3ZAc
	5QcnGk8g9/5fFBjplDOk25AZB0jyGy7vOGWyO9quSLDoBg==
X-Received: by 2002:a05:6870:310d:b0:456:b32f:70c7 with SMTP id
 586e51a60fabf-45e91d0a049mr19641571fac.4.1786935749666; Sun, 16 Aug 2026
 20:02:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260814085300.399107-1-zhanghongru@xiaomi.com> <20260814115100.24a6be0cd0e672cc3c051f86@linux-foundation.org>
In-Reply-To: <20260814115100.24a6be0cd0e672cc3c051f86@linux-foundation.org>
From: Hongru Zhang <zhanghongru06@gmail.com>
Date: Mon, 17 Aug 2026 11:02:17 +0800
X-Gm-Features: AcwNN1UHsXZzwfFtZs-9In2z7heWgSJOWGCc08C9EhhI7-onz82FwcDnrUt80Ps
Message-ID: <CAF3qr_LC_UFcUtQrqnVvzD8LHD_YzCBcw4ndCxD28Wqs-F-kTA@mail.gmail.com>
Subject: Re: [RFC PATCH v5] mm: retry page faults once under the per-VMA lock
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, david@kernel.org, liam@infradead.org, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, baohua@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	vbabka@kernel.org, willy@infradead.org, zhanghongru@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C246C140006
X-Stat-Signature: a3axckigk9rob6yrnir5r9imgjt564ey
X-Rspam-User: 
X-HE-Tag: 1786935750-636189
X-HE-Meta: U2FsdGVkX18PIrBkW/8N+wRSezqj3cFq0jq3TnpIHtDW+WmKF1aM3Rj4UfKczmFSwf8nfeqVUd4dbDcJqgmn5UkmX0UoNLjpON+tD8iEExljZIjQogUN8YuxzxSfwZe6j8hL44fiuXGEje58mcCTyV2CA7ENmN+L2tb9YYUNnwYMBft0OTwDCFUZd18PT78jnza/OKDXW4fPDXmU4KSfctACiZmFUDizQZWpT8KUQnxg8e5DSSMQE3Eq7A6u50BuB5FDy2P/NspspJqy1U0zPUamZ3XuXzDnoSmRItfO7sgL1WOmBA7JInJUIjyTvGvU2XDwF5Glrbf32IOnykGuHpTBmTf0MCrKbkKQdsktfmyNQJHlHK5x2i+GI7LazIMRu1r87QKSimTSEHCKllgzh7t/cSn6AElQc3v9L7TgwFpDshXexLMWzmPvYUopCHdF1nS0Pl1tU2etEpXTrs8Lw8bDiUd4Hbz8HHxj3Tv/9fPO6CGuKErnKHCD02efhzFoDg1C7r5VLeXo46Zcxhv3CaDict3tcCM5nkF7mHvXowLZFAoEk2KyEYIGlkshO/EeYcKqWc5Ndedq1r7j8EmRkpUErYExoJw3hud1yWhL1Tv+Dpf/4DEkcswad9GKLyWt4LAfUFQAzI27RwMKkz+/59CznwZKKyBdE/xIaQ2nv4tZpm9gmPoVm0a6ZtPjmx7p/qPZ4q+kGGMG/PTHn7WyWyoE0C+J4dzfks1Gtoxr1PNIx2BKvmDeLh8lqaP9Uw9YJx1O9mcSiNm+u06uaq3EsZl7VYazeiHo0Wfsj1J1AMG0sKaZbbeEAnw+DMDlO2CzAQCTe2cOuw1QvL6TqvvXnbWnnETtyVaMuNsNme7ufHrpY8xVSCQT79wib4YpO4Clo1ISztttWlIQ0La1sdyrImmikQ1jlRFZjFRbPLpBJXGwAKxWwJFYGb5g0h2bUusdAcEhKRH2CF37XMxQgqh
 GKHLUL6H
 iE9L9cJFSowVJuhYm50UDy9NkPWLakwKY1x+XBBqtPaLUcrr38EoGzh2Yo/Q+M1KhbKlgjgZy6pttkv0E6W7XKA1glnGIbyGOny0XJB2YY54DJQC1MQkmP3gDbZ3EYs9Au6U5v5xDhmv76tw8zdlgiwkXERUBG45+M2BiCzfq+p/6LuGM/yCRXTfM8060EeyqdLbHPeC8qHM6tTeiHt62JW3w4j8nwQ9AIjRU0mdG/Pp3tp9d4CdCONorC6+0ROSc1Tyi3HiwhCWX7lOllM1f9xGRcnkEELkZIGj2BDVgbZA5YG05BmdfGDCa4fUgWbi5Ze2nypt2MtkoMbEivgEaT7pGrPMTl10pq7BnIHJfAbKO2pOqpmLqDT627Nd8PZX5c01LWpkXxgMVAJY2+mumlFz2Qtlnl0h21dcjGZqt89Hu1s/O5r2C3lk9KXw8b2fQkWfBx0BNC1zwRGPVrAr4nt1vP2WXMXPD0KlrvF06HICZbpxoyOkf6ztRIVaRJfiuvatr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 2:51=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 14 Aug 2026 16:53:00 +0800 Hongru Zhang <zhanghongru06@gmail.com>=
 wrote:
>
> > From: Hongru Zhang <zhanghongru@xiaomi.com>
> >
> > The per-VMA lock fault path falls back to mmap_lock on VM_FAULT_RETRY.
> > When mmap_lock is write-contended, the fallback can reduce page-fault
> > throughput.
> >
> > Add a single retry under the per-VMA lock in the arch fault handler
> > instead of adding a new VM_FAULT_* flag.
> >
> > ...
> >
> > Swap Throughput (higher is better):
> > +--------------+-------------+---------------------------+
> > | mmap writers |   Vanilla   |          Patched          |
> > +--------------+-------------+---------------------------+
> > |      0       | 17303.09 /s | 17899.48 /s       (+3.4%) |
> > +--------------+-------------+---------------------------+
> > |      4       | 12596.23 /s | 16095.20 /s      (+27.8%) |
> > +--------------+-------------+---------------------------+
> > |      8       |     0.58 /s | 15420.57 /s (+2658619.0%) |
> > +--------------+-------------+---------------------------+
>
> Well.
>
> > With increasing mmap_lock write pressure, Vanilla degrades sharply and
> > drops to near zero at eight writers. Patched kernel holds up much bette=
r.
>
> Thanks for working on this.
>
> Are you able to help us understand how much effect this change will
> have upon any real-world workloads?

Thanks for raising this.

I'll run some real-world workload tests and follow up with the results.

