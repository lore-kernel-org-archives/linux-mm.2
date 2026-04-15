Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A13F428C2
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16CD6B0005; Wed, 15 Apr 2026 14:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7876B008C; Wed, 15 Apr 2026 14:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B67E6B0092; Wed, 15 Apr 2026 14:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE516B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:45:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 319AA1B832F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:45:09 +0000 (UTC)
X-FDA: 84661667538.16.BBD6F2A
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 310131C0013
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:45:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KD1E92st;
	spf=pass (imf21.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776278707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WupQx6W6/LXfROgbPlaGvE5ASqZyPH3jS54/5qrkZO4=;
	b=h06cHZ4gqIkZsdaqoCRYiVEeUhc4iogfP5A3IZq9UB0mL31NfsO6mmM4YKapAxh2aNzX5Y
	y/dK+T5aUlxTmMCeiSrKcCjsDlM/8UMmrYcBqMuycgG9yok2VjIfhmE1PLKj+UU6tIW+/Q
	xLQJthtmcOgejLGZUAVLnxcaSZ0Cj10=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KD1E92st;
	spf=pass (imf21.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776278707; a=rsa-sha256;
	cv=none;
	b=PNZ8YH8cKfGtyFnFHghdkO6J6+uy5sFLUJTPO0bEA2jwbRuiFRnXrQlQFy0dPelIab1KYY
	Yd4VTMhCkIPa2C7x91SU4R31/fEm8qFyjYnonRUObJ3IKHAeJQRNEgJwJvGaRUgfEsfTP6
	UWdYLJrVohqf9RnxgzN/bIiR/Lq2M4M=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82f344e880bso2513436b3a.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776278706; x=1776883506; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WupQx6W6/LXfROgbPlaGvE5ASqZyPH3jS54/5qrkZO4=;
        b=KD1E92stT05y7+dF5vW2piqFSItso4de+PPMG5sA2SnlPQ9lQFm2bVwDBg+gI4uebF
         M+piyLZ6yKZtdxSA/nEc7MZPNL5rKbEf9EJWEBTe304qIivzNy22Of2TcMzMrua3qBg4
         SqCPVuxVn7iTmAv4Y07QBICCA9sf9h7+3Vd++VL29TOoa7ftXAc0RfvF8ghLzNEquB+5
         PLjwPVXMOMyMTWsVMvz/2m4WySXvGbCm+bi7tpluuZ8DwX5K5ZAfP4IhWBTbNJSyM9/n
         Z+yD8ow6dUyBKWTN0z7iWaSy6feR/cwqPzPdlfvQGCFYBkFDGs8xe+/1AgBD4OWbrI7A
         Lnbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776278706; x=1776883506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WupQx6W6/LXfROgbPlaGvE5ASqZyPH3jS54/5qrkZO4=;
        b=TeQR6dDhL2rd7VbduMbiBhqvLPMr+H3idayKDkqas+E+zRDLYlzcRZABgGlb4xZLxu
         HVurrxvVRKa5RY9NV0Sw0U3zejr4LIaM9I0ziHoGH1PHJ44C7DpnskGxoSWTRZ7aEhAT
         WGJDZD8GAbjE8wAuxKgz4J3iGMsYTAOoSNzggsl6ms7jz+p+LwNJ2V8dO77aMvKIpSIS
         vQcH9QcEEhGmcdMfX3Zf2gf789Vwcem7oRIy0rbBXjmplQ3pq/4vlOOpHt4rsBN0XNs5
         pB8usjoTkMAE6vCcEV49uf5vEiBSgnQtsN0jDd1el+LoQlWmjp7m5ClZSf4CajZIqWDf
         BD2g==
X-Forwarded-Encrypted: i=1; AFNElJ/gTPmPMT9TkoCQiRs7sBqaEo4iFnQzuWJEZ0+Z2H/P/Ba8ylVx3eZIchrpHTfURARjk8N2NpSHBA==@kvack.org
X-Gm-Message-State: AOJu0YymMEgF2EXjkd+13i980tfGBA+1UqMXDzVcSo94bmdzNIGfjX6o
	lAU7zQb2ART/DEr2qz/Oghk6+DDLnF5Bne+U1lXejxv7BPRsGvuLEMQJ
X-Gm-Gg: AeBDies2bL5d/NwYx5UckmVBmzxo5hy93IUsGZLb0uX8xf8vKS0JEe/gO/OIUGMjeD2
	VtwSK8mpMWcmEYOtyfEb9t7BuDMskvRo9LX51ArnTlQ3IbmKhD9GLoODJknDdtXW2tvZ0AqalkM
	RAzRpo3Df4cXvg76U8ofoc2OFFd4Ep7m3pvF+hA5XpCfNoFiyxXfrjXq8z9ixp+6KHg560Mdush
	yEYsTVFZYHZ3eyKWEHySKDUUdWuxLEJipp0xHzPQHt7+RPOqUdvjPLzJFJxr/cknFBW+KIw/4pp
	7bxXnZdH2w5kCErHPfnVvnRTyIoAlPjqrhoKVhuPWnvlxPfjNU7SlpxFfuUjLyjYlkwzv1u3Nrf
	JMRBaggvzN23UIbWE73GDeY9DqrWPl8vhhrZ/ULbxKwTMMJkRV63RvR0VpG6JkVM4GyX4hgDneO
	efx0RSD7ht0S4uUOanZ4xlJmwfj1LqKeRYO4X6JR1E2TzdWpbn4Tc=
X-Received: by 2002:a05:6a00:2985:b0:827:4372:dd15 with SMTP id d2e1a72fcca58-82f0c2c2096mr22049833b3a.40.1776278705868;
        Wed, 15 Apr 2026 11:45:05 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f69ef0b79sm2380698b3a.36.2026.04.15.11.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 11:45:05 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Thu, 16 Apr 2026 02:45:12 +0800
Message-ID: <20260415184512.14026-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414003434.83697-1-sj@kernel.org>
References: <20260414003434.83697-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 310131C0013
X-Stat-Signature: qhpc8m9su3fcmt4aktre6gihhcsdsdts
X-Rspam-User: 
X-HE-Tag: 1776278706-133186
X-HE-Meta: U2FsdGVkX186tIkpWY6xoD76HeVg/571/JU2ov8J7d2fppXs2Fm/Ah3LMPMDO61reNAgeAYN3DfNuick84apAH2sepqc73/P+nOO8QxexbHJNz8lC2/5nqvaU9EP/rb0HAxHfqgzEAscGWN4jrb4NxicMTxdOiNq8Y+ugbnMHBr/CFnmcCWdbkrkWB8lpnbJeGaSU8sJtEuM9KfGrPjKicxm21KL7mMhWJEsOUcKE5zO1UaUHFROy5YUqnrywxShVaHT70A1o428mQd9suVkbEOEsbb+q11BTVIQJ4mjC6eMGGyKey0M2JqRB831MRD1UZwidozl2uq76NwnUSwVm3HAWVVoQyAHri5Xcc9Gp2/hp7CRuKVCKhDHWqUAjvLjlxej6SsXVxYnI5dYSZjnO1Nlod/DMYM1EomV+0TVRzcIn61iRJNJckJWBX/CyznZTJKIz+l3S9poGu8rz8PpbEIEnLKNA4tjYt/g3UTxHJAvRGLYPfVugJ5EBADGuEJgZiDpQdzUAlZreqwpX/RuAKv3liKi4iNaLb3e5LB7VdP3VXhU/XQmwg4d12VeZ306WaRYcUEMhp7tSAwPx02CCJRPeP7O3A/YOEwVs2j+dzav4f7whfAO6ezZK0e8emXeuPIpvNCfsoHjkNWKI9+Qma5fOWSvnesKgPm58vQ11UCLRSgoA/228TP5m8BbrVrfoVmqy2y5ePd6jTF2AziU+/n714TLidZGAueojDWzXPh3DWc/B+/jQ2ipa5W1f/0mxYLPLCH83195CiWW6UkMy6unkmU3AEVpc8HG8LZfm8AkSk2nkvfMlatXES3zyMU/BjkiZnTwjdgTL1s/GJ1wPh7tXJiC+jEF3cc/r7/vuVMbQH0/QC7lbhjhOYA6rq9ynspvTszKo6mZw2b/VqWy18j53JdAYioouLSfLxHRJb87YXluMrTphRzj8aQ1+uZx3zk4U5vMmuEu2fyguAj
 TUIKW6L6
 d6KsTCV7l3pRmPrsPVHNlNXfLQgMLOZ/+u5pMbuZUb+DYEs6n/stCc/WkI5tmkrTLL6PnFOSXuO4sntfnZN0BYOLJAl32fENamz/7BLP9j+0e2ijJlFOqTn6eHH59tAHo1J3riy4AjLqGDEfsV2OGEpjFWMGVFwwXYAORMaxCKiytbyj4d09XaNKBCxJpUT/ZfSxtO/Dc4b/WFLYNl+JgqgTZQm1gOHZVWWX/QhYdm1g1SHIieblBXH221eDiGmmbXUsr2hXs3tgY+F4AIC2Wb2pNX3O8mYTkm1lGGyIEYbZPfisoLWXjM4nQIthpRKE6mm8l6r2Okz6MFPGaDWth+/pxSEZS/GnY66yJTtH3gd9qL74HW1FJm+rmnsxI5nrbgZ0nbfUZhpFlsEk2glc7aPJ6Z9ZbJv0ZOfYoTE6+rGGq/nhP57jDSsSsH+kNqw7oAp7x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 17:34:34 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 13 Apr 2026 17:23:03 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Tue, 14 Apr 2026 02:52:47 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > Problem
> > > ========
> > 
> > Let's align the underline with the subject.  Also, let's add one blank line
> > after the underline.
> > 
> > > When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
> > > 'kdamond_pid' remains stale. This prevents user from restarting DAMON
> > > because both writing 'Y' and 'N' to 'enabled' will fail.
> > > 
> > > "Unexpected termination" here means the kdamond exits without any user
> > > request (e.g., not by writing 'N' to 'enabled').
> > 
> > Could you please further explain when such termination can happen?
> > 
> > > 
> > > User Impact
> > > ===========
> > > Once kdamond terminates this way, it cannot be restarted via sysfs
> > > because:
> > > 
> > > 1. DAMON_LRU_SORT/DAMON_RECLAIM is built into the kernel, so it cannot
> > >    be unloaded and reloaded at runtime.
> > 
> > I think this is quite obvious, so may better to be dropped.
> > 
> > > 2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
> > >    Writing 'Y' does nothing, as 'enabled' is already Y.
> > > 
> > > As a result, the only way to restore DAMON functionality is a full
> > > system reboot.
> > 
> > Thank you for clarifying the user impact.  I think this deserves Cc-ing
> > stable@.
> > 
> > I think 'Problem' and 'User Impact' can be unified into one section.
> > 
> > > 
> > > Solution
> > > ========
> > > damon_commit_ctx() sets 'maybe_corrupted=true' at the beginning and only
> > > sets it to false upon successful completion. When 'maybe_corrupted'
> > > remains true, kdamond will terminate eventually.
> > 
> > This seems better to be explained earlier, on the problem section.

Okay, this is my current commit message:

    Problem
    =======

    When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
    'kdamond_pid' remains stale. This prevents user from restarting DAMON
    because both writing 'Y' and 'N' to 'enabled' will fail.

    "Unexpected termination" here means the kdamond exits without any user
    request (e.g., not by writing 'N' to 'enabled'). This can happen when:
    - Internal error of kdamond.
    - Invalid parameters commit via 'commit_inputs' (e.g., addr_unit=3).

    The root cause is that damon_commit_ctx() sets 'maybe_corrupted=true' at
    the beginning and only sets it to false upon successful completion. When
    'maybe_corrupted' remains true, kdamond will terminate eventually.

    Once kdamond terminates this way, it cannot be restarted via sysfs
    because writing 'N' to 'enabled' fails (kdamond no longer exists) and
    writing 'Y' does nothing ('enabled' is already Y). As a result, the only
    way to restore DAMON functionality is a full system reboot.

    Solution
    ========

    The problem is that 'enable' parameter value is not trustworthy.
    Instead of relying on the 'enabled' variable, use damon_is_running(ctx)
    which reflects the true kdamond state.

> > [...]
> > So the problem is that 'enable' parameter value is not trustworthy, and this
> > series is trying to make it trustworthy.  I think it is bit complicated,
> > especially for stable@ fix.  What about simply using more trustworthy
> > information, e.g.,
> > 
> > '''
> > --- a/mm/damon/reclaim.c
> > +++ b/mm/damon/reclaim.c
> > @@ -390,7 +390,7 @@ MODULE_PARM_DESC(addr_unit,
> >  static int damon_reclaim_enabled_store(const char *val,
> >                 const struct kernel_param *kp)
> >  {
> > -       bool is_enabled = enabled;
> > +       bool is_enabled = false;
> >         bool enable;
> >         int err;
> > 
> > @@ -398,6 +398,9 @@ static int damon_reclaim_enabled_store(const char *val,
> >         if (err)
> >                 return err;
> > 
> > +       if (ctx)
> > +               is_enabled = damon_is_running(ctx);
> > +
> >         if (is_enabled == enable)
> >                 return 0;
> > 
> > '''

Thank you for the suggestion. I have tested this implementation and it
works expected. I agree that its complexity is much lower and more
suitable for a stable fix.

> > 
> > > 
> > > Changes from RFC-v1
> > > (https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com)
> > > - Remove RFC tag.
> > 
> > When dropping RFC tag, let's start from v1 again, from the next time.

Regarding the versioning, I have two questions:
1. Is version number inhritance only required when converting from
   non-RFC to an RFC?
2. Should my next version be tagged as v3 (since the current one is v2)?

> 
> Also, I just found the patches don't have Fixes: and Cc: stable@.  Could you
> please add those appripriately?

Regarding the Fixes: tags, I will include the following:
- Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
- Fixes: 059342d1dd4e ("mm/damon/reclaim: fix the timer always stays active")

Best regards,
Rui Yan

