Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19317C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 21:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29E26B0088; Sat, 26 Sep 2026 17:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2F16B008A; Sat, 26 Sep 2026 17:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC20F6B008C; Sat, 26 Sep 2026 17:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A21FF6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 17:07:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A7B71A08FF
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:07:25 +0000 (UTC)
X-FDA: 85257149250.26.4AB7030
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 451A240009
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:07:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HvUggQ9F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790456843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpSCnKLdDqOi9AdxZc7ZAonemUZupk1aEtdY90Xtb6I=;
	b=iLEDxczYGdTHzBBY9oKrOnrXE5ildpiqIemlzOaTWwMrx4BI8W2kEDvXR9727E5zqevxdC
	dS+qXoz5VL/1dA2Md55R8IGYjgnicvISB/zVoznBwNsm5W0sEdDBYlkGUtmG9E60SJfRxb
	BG5Ib/9Z/BMbadrnmcim1RfuReT+UuA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HvUggQ9F;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790456843;
	b=HoeWHhseP4gv7XlZa1QlrLkAsJtKpoq2hvZ9u5ceWkBwrAvD4kJiPkb3zwMkkgZBcWX9CH
	gXVMjeGwZc2C5NY9PIwC6oYlcl0IMWGkaQ5BIJ1eRXnFAY54Spnh5iTSk1DxK3YEyrk5z4
	uGPHk3ygXz+7vDH7D4J6spFCVIFFUEY=
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-86b90133ae8so933991b3a.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790456842; x=1791061642; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bpSCnKLdDqOi9AdxZc7ZAonemUZupk1aEtdY90Xtb6I=;
        b=HvUggQ9FfFjWXu77AgnOzsWBNhhb1+7wV0pJEplfN752ulPgRnsck8Gv1NwtObxmLg
         aDweNcMs/i2kv60kqMb5HwWGo6OONKBKURQ1x8dzbr1sBvRwUr8cWOa16tFj+DAkh7A2
         NVewZVkbBmRYNy0TAcahgMVoilr2BS84MdsBAb/pxcwMPPaetBgMp0LMdtURCXvs8EY6
         CmSuiRjrLMaSm3FdoLaQ1YkCtz+W6ifI5UMmH8cW8L5fQ/KMJ4VceUWqTireP9FpnoOX
         pa3CMBr9+tMhv/4FoDn9A4vcuqJXjAfTd5KrMc98+E671Lf+F480wulgyg+lxuaYY5Ts
         A5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790456842; x=1791061642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bpSCnKLdDqOi9AdxZc7ZAonemUZupk1aEtdY90Xtb6I=;
        b=mJzFGzIpasOCL/UnzrKPsK0iSegBIhygwqJZK/8C1LK+CTWgRjS0FzX4FE2MdZmyGX
         TWAMNC/2VR1LN7FeAMo4zBLkXVLhsU+L0V2WiXniNAzAhC522xbWQZL1cnTDFdnPUgl6
         vke5I3oUhOgOn9kxRLZMzaxqxkOJEPrrZS72gdyYJeBA4FjBZqM+J67niZo3Im48Q/Gk
         u0MBHWKxHr5wxDtkqSKqkHmBKyJ/fr8X7fyLTdNdLGUSQdRxRC4b+xeGIREeNbmp534N
         h0kUIMIxNAWuV4uHVNN0VlFuoFASFPfgQUryeFwuUmXj5gvEXQKSdlcFz/5TyLX4ka5T
         w8sw==
X-Forwarded-Encrypted: i=1; AKwUvBzS5m2R8HXcN3SULIXtQsAWN6pTZYVpbJOwUbT1Eib2LVmJHYk2HYJ7MNnZ7vZ8maxQqL8Ycb7Z4Q==@kvack.org
X-Gm-Message-State: AFuF++l+1GQurDaAq+kCIqXf/dL4V8RhGGQJMNXY86gDulqZj45ufTSf
	lktZ6f9nTYrwLBSLcF4hfPpKzuYdKR2TXYO7nszSPyDrzOrKd00UzzDR
X-Gm-Gg: AYBFou0GcE05z0OAnR1G6G5aDe1Zm9mop/a+bFVlWrLsyEK+qHgcs+/2FjJSTWiQz8G
	sIX4p9egCPrHsgP6TRopI1NHiUpY0S9Q8i1NqE32SY3ZF4JrKzh8keHDWE4wjfy1POLmf8TK2wf
	NVWGtVyo/318FmwxHCknChyvTk8X7sKYdklHNTbUbCg7mM61tD2ejmVAkrCIpVR/sqvJxbxQQTq
	AZ7B34yb0LcuXK70usL0VqIKVNiT4xCPuYr6+UBYYSGHbkYfzOVRV64hMF+fPAeffyAJjz/6+ux
	YVMztXY3+X5m1EZtc8BdL4ZfEDSPKt+QmL8z6itwZf2R28skdm9NaWW5ZxTXQcWDkojjRHbgp2P
	JzIZ08I/n32+Bh+vNq5QVaKsOfGpl2R9MMgrRNkoQmpt6iHhfTJMzbIm6pJIG+C1scRBTAPhXNo
	6j9zQUqJ2C2Wu86o7ma9rNYUSCKofb7JgrWr9/uJsuGewmxxaxmuyHxgwqzbjxNqIp6OdtrRho
X-Received: by 2002:a05:6a00:2988:b0:87c:f67f:f7d3 with SMTP id d2e1a72fcca58-87e95b5ec2dmr7070362b3a.0.1790456841899;
        Sat, 26 Sep 2026 14:07:21 -0700 (PDT)
Received: from celestia ([2402:1980:867:387a:70b:38f1:a1dd:9303])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87ff54fa206sm2380979b3a.0.2026.09.26.14.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 14:07:21 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Sun, 27 Sep 2026 05:07:09 +0800
Message-ID: <20260926210737.8837-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925090239.47821-1-sj@kernel.org>
References: <20260925090239.47821-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ge6sftyp1twsfc7as13pjmh88rmwuxfp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 451A240009
X-HE-Tag: 1790456843-784232
X-HE-Meta: U2FsdGVkX19tcVz0xwxs9d4DltqBx6OMjB6nDpytrhvbvFTrUqJw4JbW0iCRKADgb9WoqU+D7x0432sm2+QeeWhkm8xB33J6EdpbQdxk22ATgzyygb7lP0KbMoYD4DLY/lrSjd/VrU+BxfLarcsSoWVTB6RxPtrLUs0EcUzzleMaou3A0lIkpmoUlB9Jeu5WqPSo+WQe+bJeuEFBQBI2BjC33FcMs9sIJGJCmWMm5BsxPaErkGpxl4FepXUORNe+noriD3aMss7iqHg4zchALb7AyDYK4qL74m9ETicesjUIlGGRVWh/ac9JDNmmi3vJi9usRZWxBN3COqlwGO6gMXbtCddTrRak3MF7AFIFDmtMWLK5xDwRsOhnFrVi0x+NqVW9+aB8ectKb4yZBD4xI2CwLHdoyhx2B4X2FeWpfARobOUYzaX3iSboTfz/WBRpX9CL/p1RHR3yPewvfH3R4E+X/RYz7Ic/g4SoONi7QHQsaXJTJheX2Cl+pWBtHRB1mFPhCgEhZSKIz+BzVEj+yUdt5etm5cSb+4gOCdvXm72fFxinvTuCtKd/30Eqw+SX5gMYhTe02mxtWXL4yeiIcW7APkmEdqZCu1zgTedt0noBJOBXq+SUNEDZbzykYzNG1FWfy6AnwTLUN4srJCUeE+PhW4PKvpeV2TwHPBSXxbPWmmfRzz9obze2OGZnSadcmT81n7Gojj9RO6HHhpj2FflmVS1RsjbBMwZ1ZQddFfi6Tw5cvrYLAZNF/Z7vRBTOi/o5P+4biakjvdMQN5vx6BFIVoRXrlaOGskXUD2peqlKo2UpqBqbdbhQWwmFgL/JFZneCxsY3KOIdUva447cTfdChTM9KotE6aGhjQfDYGIgojBPN0Dgf+x6jcLQuYzLFwCrbNMFSOw7NldL8ue2VTgMLaMD+ROzIfaHYyqyXYFWgQ1A0ZMTGFnJqYNhnWDISmDFL/+R1etLBd+ILAX
 U3CIOpbq
 gG0HuRNu0JLsLl9JnzmkLzid6G3FWl0BKB6d3ZyZEnrrzKiWlwSp62bsMbjIVNnc1QyCe9F8KjDClH9XDfnJgKXCixdDdzPNSHl/gZvyuVZ5IOcp5D/RbY3/daMkqAoYZllAmS3Qfr7tdBbUWB9MmHV1DH0yCa9d0eOcozJWjqgXnOB6VKu819NeZHRtr60VJFch02o0vL/ws6xvDRjbFcAuWNyBMq1XS2E8ulBo3xw28QAMdAGrASiy8aR83eWnniMGQIl84Re+LPaLr3MM2/YTKQP1ho2NNQA+IYExezLgc6MIn46faeulsZWhSnoHrXh4FrEhG+fTxImUog+duyIsTP0cL4Squ/+Nduc/j4yIo/OZDJnfiGlG1FnaFwJTA3otzdNgJK6qhU9rfbW3fWBg1eznht6RhcFa9aqhs252GuIyXfzJpgue8lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Sep 2026 02:02:38 -0700 SJ Park <sj@kernel.org> wrote:

> On Fri, 25 Sep 2026 12:53:35 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Commit 50585192bc2e ("mm/damon/schemes: skip already charged targets and
> > regions") introduced a minor issue that causes the last region to be
> > skipped before it is processed.
> > 
> > Example:
> > 
> >     1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
> >     2. Quota is configured to process only 100 bytes per window.
> >     3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
> >        addr}_from is saved at (Target, 100).
> >     4. Window 2: The loop reaches R2.  Because R2 is
> >        damon_last_region(t), the old code unconditionally returns true,
> >        skipping R2 entirely and resetting the charge_{target,addr}_from.
> > 
> >     Result: R2 is permanently skipped even though it has never been
> >     processed.
> > 
> > Add a test to prevent this regression in the future.
> 
> The bug is fixed by commit b3723b596b54 ("mm/damon/core: fix unconditionally
> skip last region"), which is merged into the mainline for 7.3-rc5.  Could you
> update the commit message to mention the fix, rather than the original bug?
> The fix commit already has a quite good description of the bug, so I don't
> think we need to duplicate it here.
> 
> Other than that, looks good to me.

Okay, I will change the commit message in the next revision.

    Commit b3723b596b54 ("mm/damon/core: fix unconditionally skip last
    region") fixed a minor bug.

    Add a KUnit test case to cover this behavior and prevent regressions
    in the future.

[...]

Best regards,
Rui Yan

