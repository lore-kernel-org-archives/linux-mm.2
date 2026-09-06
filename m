Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5409C79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 05:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DAA66B00CD; Sun,  6 Sep 2026 01:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C216B00CE; Sun,  6 Sep 2026 01:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079FF6B00CF; Sun,  6 Sep 2026 01:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D543B6B00CD
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:04:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65D6112044C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:04:37 +0000 (UTC)
X-FDA: 85182146994.03.3818A62
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9763216000D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:04:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bcUxjZ9Q;
	spf=pass (imf08.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788671075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SozSqp/P84pK5ttbmbx/yerpxYYU16syxX8QCf2wgzM=;
	b=oFVL4V/R/pI063HDPPXhIa/3ehlzxikMk6N3pb1X4cdrzYsxbtPn6sGTDS87DUAC+NuIj8
	4ult16kw2vgeJMEm2TKSZCfwzc+V0oCZsD+MQlUJeK30D5ch/649MVnMbtEWJGDMbpZ95H
	7Z+GYazaX3GJt8AvnSv0nAPlJ4BWZQo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788671075;
	b=BMx30eAjXfSJHSftHddQhzG3T7z7dyn1aT7QgkTskdA9dLsSnDytninifd08pRB7kXQvJx
	EwM3eU1FDTYkSZJIJjT/RGJ6XQsNTT4ZXA70lbDg9OrmUgNg2MN6XyYRjoVjNVIBfw3jdZ
	tVApMhpAaW/RQzFuHdUvwb560LP6q+k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bcUxjZ9Q;
	spf=pass (imf08.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d71ae3455aso32219055ad.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 22:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788671074; x=1789275874; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SozSqp/P84pK5ttbmbx/yerpxYYU16syxX8QCf2wgzM=;
        b=bcUxjZ9QxU4naAswgUdFJ8Q0RLbI+hUN3sPpQebsb/Cvi3fAf4lcyDxoJKjJ5yV51t
         8SNbsfabs/jhtnbgFJS440me3O2SgpZh24pETp4+7fJk+GGH6PWJzy2+rd3wqbQvsbXc
         FgXLUvyFrzpiB3Xr0kRkhu/P3zPwQ0MiPhm62ab1PBnmQqdUgboOE2bP1fwGe7Vk10/k
         0ANY4EpIijrzpY27D8n2s/1JMtlnJytdu2vkKM0jLrsWuvHPk/WBxELggpsMJaMeGpbo
         DGh5q4WroCt7MZtPMXtuAhkMMjTToIAYSZovLtBCz2z1TUjMabqtxgf7pnblj6NzXFEY
         n6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788671074; x=1789275874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SozSqp/P84pK5ttbmbx/yerpxYYU16syxX8QCf2wgzM=;
        b=pIu9/zjXbJDZEwdxaAwMzsY6Cgm1EBF8vx/Ysc3U1j8E9yPjelKsjqAsu6fMg/v41x
         L3xGIJ2D4i70fwI/s25uOR7C7LOlXCiWW2xHhV9iiGyQwpUHKiuyvSG9PSycOG2EnOo6
         SrhHbo7GI+NlyIjnAcc7qBH8PuHNrDDzYrCRGCU1Chmqo62gXx03BdgfV2OFruFVr5vu
         VqbTy4blaiCsGh6fQa8bL0pDOX0+0R2b6TTcFpLEZvt1DDaeF+voUU0VxRnREPh76Uco
         S+vNOmlgRYooy0guJRfpnFH8QFEjfrJAzDbgdZO4mCuCyaR5WVXJLX1fVVMudnq+NiAf
         XfqA==
X-Forwarded-Encrypted: i=1; AKwUvBw6//hNuDYnpoj0NWNobxCBuRpazzWGg9YgF14LemDg7QEL4E41ZCz2xMC4W5HDMKE5tDAX+ag/4w==@kvack.org
X-Gm-Message-State: AFuF++k+f9leS25tnV0iKsfYONGNCbk/hOAWZNY7YWcLDwmw+TaSZJu3
	QPcOifT5AAJdKD8n/nIRwaLKHvi51QFBpRZP8Qeb7V1jSq3f1wv77cUq
X-Gm-Gg: AYBFou2j7d+GwNpIP8ZoJqzE65Ux5IXslK8PgTpJvy3VJ13ftuUr8hCZlN+x5loAqmP
	74BoR9/OOnIWSYPeD9RN62/f+JD6EpWchhShniR0DRanZOAkSUooymStT49v+pke/U+cJdMu2GL
	3lC10e54cTKp8d74aJbGDST+PbB6ip1/Bn27mVnlRsXnlK1Kck/bHHOazcNmJ9LR/NKlE3B96lW
	5RoPYHisGr5IsX60IRqwAy+TvEtJix7NaiMg2k38XCykblfGPCa4UQcI+cGGwLXdV6NzE7n8hq+
	hTXHRVIrBSZvqAWmHJ+BgV4WEBTUiPVFNWEohVpCnj7o/sSMBiGD40Gf9CTPP+XcnHKbLSKoa4o
	B73oar8FcUwJoeKFHDxnjAADgCsFMQf/x2AjN2Xt/p1DIQ8MDkF1cc4sD7o9SX+p0xq6ylVAsEJ
	q6TzqK0mhSCf2QF4B/6s3TVO5ylZGeLVwE1gy3n9kFHFnNVQXh/vJ3QCRvxcKBOmYUuqJI8O1ZT
	YXxHw==
X-Received: by 2002:a17:903:124e:b0:2d9:4baf:f1a7 with SMTP id d9443c01a7336-2db1287a543mr210656715ad.19.1788671074409;
        Sat, 05 Sep 2026 22:04:34 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1483de0asm28106155ad.11.2026.09.05.22.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 22:04:33 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: baohua@kernel.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
Date: Sun,  6 Sep 2026 13:04:11 +0800
Message-Id: <20260906050411.405850-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAGsJ_4wC78QDTrETC0WpnouN=8aF8ae6Yxgb+oKiOP3A76ATLg@mail.gmail.com>
References: <CAGsJ_4wC78QDTrETC0WpnouN=8aF8ae6Yxgb+oKiOP3A76ATLg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9763216000D
X-Stat-Signature: ryoa6os4z494rbwkmz4rk3iz93cm4oqt
X-HE-Tag: 1788671075-453374
X-HE-Meta: U2FsdGVkX1+WyetNIsUGT+S0y5OQKJ/o6oLaqm5fWrYY9FgBfS0v2yrkcDVbbODfn5qjnzQVxe1z8JSeMhJQ/+AA+6s/gYuT+Uvj+xG7O2Rm66tIF4ZUBJlrS9UaGM2gMiqz3f41FRD8koZLAg8hnBVW6WjlE1yLdiLDojiqkUVQ2wRHFosAiEcnGd365NLd5MTNMxkhzS9aB52UklHMsf2Xg4MBEaX1M63ZTS0jN4UYuHW8RLpthRBrwi13hLwVkqWcETS7tOfKAwGYU60HnQK/TQM41ksGe4T29oSSPN+pZ6skMwUJoXcUjLsFiBnxl50RoBiRJen4IoGWr4b5/DIMAIb0Cg4yAIqEjCNm9r2o3FQFGeSu7DIIJo4xo52t5AlZs9sSF5JJS/aSqg/vKPIMjXRnBMe8y3KFraLoOiz9fjHP8ZBp0aFJv6lbrY8sDZqf8ZzEZ5dxyv7jCWruX1l8UGLj2HXAfKYhES5S/gCzrc/+MGHu4EoGUbSMK+CUkuBVijKdhbDCl9V/Ql+LDHjq88N0loeDU9T2mAkXGr67740An30RveYDqfjcyDUmZLJfwu3E6250198l1/aX2xwdop0dGA11ldNTu+VGKs8FpwPXUouA/cIOjPTu0tGljubSXJUbDzYD2+mAoNeK7r5MBkw/JhVzkbPUhivEUUXvdCVlJH6XSS7+fD2Adgs3fJjdHh82smwflXV5zas3nXDXTmB8H2XbTUD4bdTWDLvdjFeV9wiU2F9iwfa/WP6D84dVfs1iilgGYdRrXLTGV9bVZA4nXoQBJARg5YmPc/yU3C/rpDElLK4UiiKQTfYPOyqg0v/yTv6JKtUvZHvKLqvyWo+WV4ffiSPK/IsdiUJNGDL1CE2NIz/idILDo5B5f/r9tVTuJGZVXrdQ/UklgPtOsNtpkt4DKPF9M2YJahmP5zqEE0gnZu1kMt6OrtaIwoJ+lBcdNTPviBRjPAC
 BKX3PoNV
 D7/o+R6nzAaerPoY0QZiDFMHSrh+NQ2Bx8qzhYmyIHBAmFU2r7UFpwc8wGPrcOaoh+81qqhmgA56DXsZNOfJIdgMxRzUbhvCosToflnRZodWtTXTGkqmPdBU2jvKZA4XI4tFjpIkwAN+yrqz1lTicc6WMeFu8knYw2sdyv1IstEs3DzGHvgOUm5IQHdUCbpLZa9sSIA5/6pGAa8yZmS7klVIZVbJ19hB/EUsL5dAScHIGyuAtNFr/nmnlF1FceFdLeKJg0zl0pLOqqtJqHL8befosv6yZRs6yLdHKhgqcwPq8FYH3cEFCRNaTgWr8gYqaPW2l4xnyNUjaKWBGRtQQdeTsGyQMQgyGldznkePUsgfznD+eFgaz9I9boX562indVijgKGU4bJI9J8S0leaopskWEAAMIb+IF8Ro
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Barry.

On Sun, Sep 6, 2026 at 12:53 PM Barry Song <baohua@kernel.org> wrote:
>
> I notice this only fixes the active/inactive LRU case. To address the
> MGLRU case, it seems we may need a more fundamental change.
>
> I'm fine with starting by fixing the active/inactive LRU case first.
> However, could we mention in the changelog that this patch only
> addresses the active/inactive LRU case, and that fixing the MGLRU case
> is on the TODO list?

You're right - MGLRU decides anon vs file scanning in its own path
(get_type_to_scan()/isolate_folios()) and does not go through this
can_reclaim_anon_pages() check for normal reclaim, so it is not covered
here. I'll note in the changelog that this patch only addresses the
active/inactive LRU case and that the MGLRU case is left as a TODO.

> > -               if (get_nr_swap_pages() > 0)
> > +               if (get_nr_swap_pages() > 0 &&
> > +                   !reclaimable_anon_is_low(memcg, nid, sc))
>
> Can we also update the comment above accordingly?
>
> /*
>  * For non-memcg reclaim, do we have space on any swap device?
>  * For GFP_NOIO, do we also have sufficient swapcache anon folios
>  * to reclaim?
>  */

Will do in v3.

> > -               if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
> > +               if (mem_cgroup_get_nr_swap_pages(memcg) > 0 &&
> > +                   !reclaimable_anon_is_low(memcg, nid, sc))
>
> Do we also need to update the comment?
>
> /*
>  * Is the memcg above its swap limit, and does it have enough
>  * swapcache anon folios to reclaim for GFP_NOIO?
>  */

Yes, updated both comments in v3.

Thanks,
Bo

