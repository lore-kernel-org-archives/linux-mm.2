Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E0AC531FC
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 03:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2898B6B008C; Fri, 24 Jul 2026 23:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260CF6B0092; Fri, 24 Jul 2026 23:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177DB6B0095; Fri, 24 Jul 2026 23:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5F5B6B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 23:06:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23BD3A0248
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:06:54 +0000 (UTC)
X-FDA: 85025811948.02.44FBF0F
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 41B76140007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:06:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Fv4PN83b;
	spf=pass (imf23.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784948812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLJlH9DpdpaoJklRpcIyyrBfGmkZOGQunYAJgLV0ybA=;
	b=09XVL0vMTg55i2pN+Ss/tUQPu6fOxQ4R0OycE1K0JYY8neP6vg/w8PZ3aPG3ifd+WQ02M3
	n5w2sfOkIXZMnSlR3bGSrLWBnoHNu7LcaGj9cty8flPDn8MVXwSX+izlO7Wf7wA+wjrmgz
	aVbKGYEH8gQlyIll3WcVpwsfmVRCfIE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784948812;
	b=vmbODaX818nrQHQrcYlsnKwBLPMQID6yyr7AtGHw7KX2DOOwUBbYXwS5nL5eeOFNlN5K9j
	lr04i0pZBb8V8JX7xe2xMMrD5i/ep0tKa2o9POP1krboxmGmKlYfeT364OQn414orZPVt2
	PO7NqrViDkSi5DXHpRSfc6ygbBvi830=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Fv4PN83b;
	spf=pass (imf23.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c15a5b265so126941cf.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:06:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784948811; cv=none;
        d=google.com; s=arc-20260327;
        b=ZmWIXdNYc3LAVbj8XkVet76t1k2BhlSyRO+LS3m/fXFEJ9mVHok6u8F5WjtzGiXRhb
         zty+NyNQ0MFKTLjWP1iwCz3fJp4f3bdM4ZcgjY2kkTAzWljFCG8g7bJlQmkKSfAFT99N
         AJ+NevhG7q8feM4H1Jxb85pwYMCslQoFPpdnKEa7kD0pThvinBUAg+QmSvxxEvdn8aBO
         dUNYv0F8xNZ/1TMimxmXZ7hQVrWz8jVE/5y/4b9Ymr35HeqGgX2rlooA2Bt1vnq57Jan
         U7bgo/6TuiGqFjKL8K8F9wnRcpvLgx7AE8Xg1572eYi49UoI3GPh0u7hnGfEaBrwZ7xD
         6CqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YLJlH9DpdpaoJklRpcIyyrBfGmkZOGQunYAJgLV0ybA=;
        fh=sZkujwqPrtqwQAhrk6/L1I7SmfXHCCVIDpd/v0CvXWA=;
        b=gGtp2yTfg9qwdsXW3c/n8DIJvHQL7RMxeKr4w+nyqtsNpnyQwkAnlsLDb2WPIrCat6
         H9J9dqJslbEd9WPVcXr4eSbt3dyDutdnrPjeSNzEGmjkmuukjxZ9XP2DNYgWS/o7Mytj
         WVkaYoJywnBqCGczRier61RkftsEwODhpRdLuiYGtero6AJWwrGgzi0/xurRwB/0rUSZ
         wEKtzw7twCozeZspJK16xKr7MZLyabzSN4QHkLz635Ni5AtLz984juoPnkhorVwZjpmK
         L9/qvQD7k4/rlXD8Ts7JECxDAHDdGVtkmOyBRcbcWkNMgAZzcyMLTJNyyuT87k7jDfnZ
         okwA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784948811; x=1785553611; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YLJlH9DpdpaoJklRpcIyyrBfGmkZOGQunYAJgLV0ybA=;
        b=Fv4PN83biyVt/2CItviDqyniMHVj/7ryVEQ9rY+kmO0j30SBwBzIo3rHuMweRFvxsK
         Xj5GJoyChqZQWyWNW5JlUO34n3lLZeBbnO8F7snftYZ35biSF/FTYTLodbbCuXmfMe0I
         pmAQ29TAvQWPVMVoNnJl4jdElAIWBEYKoX5iYD7uG8qSJABZGQLt6leFP+YF3F8Opbci
         pVj1iNMXJetZC2eM5Q2BN8N/e5QOi4VnDjb3MJo5Dwh9hHAb0n6PptheGUtPfw9OZwVR
         rG1bHZed1IbSDPo1ztrp0tv8fRDlY+xjmFE7v0R1TymjOFuCMfT706WGVThObANBIgka
         YJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784948811; x=1785553611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YLJlH9DpdpaoJklRpcIyyrBfGmkZOGQunYAJgLV0ybA=;
        b=XE4iillh0Ajsmv3R1HmCOqUZpHz/uTEMo55a3xj7FlgZT3lpQdOEEeINugauRI/mBm
         zHIQG38YYi+vl1hTufROBTXYWSIYXC7yR7rtat2KdWVZkUdM6ou5P1uf9+XyzixWWZZi
         TyZEOgpBt/KAcVlbKduHzu+NDfsBNlibsWqvxgNhCyjm9HYByAw+mlEJnp6GbVuHcaT1
         YM+JNcmf+xlFzi0o2B5YFzG7pOy8mHr52AB3hCrTVtv00G4Rsb7yp2G8Gpy/ORD53pbY
         zAxZItY1XTzf3O3t+xEk0QhCQCgZMUZe5xSJWG+i0phntuNA1OdYBGt9cKkJL5+G6tmF
         tHnA==
X-Forwarded-Encrypted: i=1; AHgh+Rpmsexo6YvwrQ8Tt0f/Zt8mNwD3aPRSfcjq4SUo9AlwZeNOWE6utwYZv28sv6ZK1ge0GGeXVYUv7A==@kvack.org
X-Gm-Message-State: AOJu0YxXJxdkP9FpL7gj7TDGAcO1llvBhP3VcD+p/KOKxUoooGM+Hz++
	IgznUPs+FYeUe5Ihd3fN98s5a/G9+LhOV7+DowwKgU/jUizuKKVPZ9jrFmscVz1xVCgctG+tM9G
	D1/uZflAZjOCwwmM/g04R+Ml8uvs23PKB2b0qIXPN
X-Gm-Gg: AR+sD11mj9++Pbi4+WHsTEMGDxpbUH+4727wAm9QGL/BVDznmrf2t20AKggolNNgmEL
	sweNdzyZqwb9DU9ht4pGXK+gB7IIaiyzCZAt8MAJ5K//xQxwDTmn5pfpZQZEaugTzH2m67nF7gQ
	QM+ZEi/uedHJAqTSesQB7ymjIXCjxuTD3yZnylzleo8Zfdtqxvc2CSEXRxyOuw6wrdckciqqknG
	LwDLbbE0x/cVm2k7SaMe45/+yJWxkCWzou3rjo455SJQhbbNLJyRViy+45GuwVPhVS0LQBZk9bx
	vvDVdj5+CKn6zT6IFLXzsYYORNDAhU2kUU2y1NG5
X-Received: by 2002:a05:622a:901c:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-529a76e10b3mr5515171cf.11.1784948810867; Fri, 24 Jul 2026
 20:06:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com> <20260705115045.eba41efda0c46121b1d10827@linux-foundation.org>
In-Reply-To: <20260705115045.eba41efda0c46121b1d10827@linux-foundation.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 24 Jul 2026 20:06:37 -0700
X-Gm-Features: AUfX_mxo3wNqrdSXGVuObfLaUMMNnMg2ggzGq9JXqSZBMXrG7BMLrL7bC7V7AaM
Message-ID: <CACw3F50hohk+6sYgW16AVugLXmqjMzvjZfuzi6mbPNJoyG5s_g@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org, 
	osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org, 
	osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	muchun.song@linux.dev, liam@infradead.org, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org, 
	shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 41B76140007
X-Stat-Signature: con4dxa1yc7gg1af4rmqza6hmsqb5yba
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784948812-623858
X-HE-Meta: U2FsdGVkX1/Xef+MPnvUZMIX/6sskKeP8JEvniCc00Axwmzwag1aUj07yG5X8HN/3w7PUd8ukYGE5g5XVBK8tQv6mLaXz1JZhx4x+XaKMEqG7+GAu25uQzbTy76robzS2hdcBeUFMJykYO9gIyz7v/Ey7MAU/M+Zd/fa/7Jlg2LqikFhPknnlR89iCrdiVat7I/V1almFCUqklikcjZLYT4UhMmEiuLN9RARzcwx2meeLQW6z0eZf1vUJU5lB0YwMh2KkJo87LQWCnv7Hv68/AZqGOqIfev2wR4oXRp0aktR657LKe9llToV5rIrHPMAoegclrPYFd3Kld1D61uEK5ehSf9JFcX5lYeuG5Chg/Yys0paTW/SEXdiHArmUINiQLVnq73tT9/JpQ4Ol6ziyDCv2VBuGC47hr0Dial8kAgteFtQXkmaHZdmJm50R68V2Sl+f1N4EqANoD8PPcGr/1HHR8K/Ihv5jfNQFGWp7g/AtNzJq9TFgbTyVM4o7TN2Tg7usvH40Lf6u1ThsEq2J1kPOVsDnV7KE4Q6AqCzNL/10IiRmgIn6xuPDS3k0JxRQYf2CfdXoPDAv0Dv0T9pY0QVBxdXX3GMTmhvh0LoWmYL7CI5Dx1BaYl5gZHHs6g289/JyleAWquNyhsV7URXgAtGzo6Aopdu/ZbML7N1YXCXHZuM6c4jI46MCHhQ4Kl+m1MxcFAMpllDLx884aZqHh/m2mUotJ6NxAkgY3OZ6ImijifK7torBu/AL/aEiSR6sHecb5R/7HloDOJGl8jkKRgmcKcFIYYnrFYZnGvJK07Z0BzUX3Qro2n3Enc9Xw/aaE1CtkmtrELYFtboX17U99ZrPgJNHQKz2k776aUZO8yDOC9NxAi7NFxHQa2FKgSQyawjKKbLLntSVl6r5NA5+j6wvPKumfwKu7jmuaSuQ1RFO7cqhGGhp9X0YEcaUz9AcahkzRHDAZ3+UdEM+6g
 9LdneERs
 ZDNrVc73ieRRFncjOqOYDsnqQRa4Wu8mAAaJutg8GnHHMmoK0C7EzyNRh8bPRv7CTY6Zyl3UFrW7wjBxwGFvozBcojUcAAT620E/w88cGSjEG22m1D4CPRo/3Djt1M5bbyGEHgYhx5xsam/GCYkEimGdygEJXN7ShL7g9cbmNvNfaHgJVr2jMvWjZ3OaJuPTgygztWQhzHNByXubOiz+BS6WB+fb3o68zk+84FSML0YSvCcf+/G2wVSpIoELIyUGQk7ttOiTHiLVDqqIdoL4nlIiAfwwhQ8SW6088f/OFkiYSJZcb6U68kDVCx80aZqgZ2YW5mh+aGlNm7P6c5Pj3WUU/ZrJ4F8sxRnfq5rh37C4gnwWg4aXJPf/2vuz5D6WBuKbjkWn+Pxw+F9f9FbXs3YHtaZRqW0lfgPjtk8VvW2VkyV3WB6B3SA4nZsewS6Nr3zdJ0z9ox8Rj4cuBS4DjwrHPDlqXQ8hP1kPhTNcz8r2JcxAwlZYtpN3Gaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 5, 2026 at 11:50=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sun,  5 Jul 2026 18:07:09 +0000 Jiaqi Yan <jiaqiyan@google.com> wrote:
>
> > At the end of dissolve_free_hugetlb_folio(), a free HugeTLB
> > folio becomes non-HugeTLB and is released to buddy allocator
> > as a high-order folio, e.g. a folio that contains 262144 pages
> > if the folio was a 1G HugeTLB hugepage.
> >
> > ...
> >
> > Introduce free_has_hwpoisoned() to only free the healthy pages
> > and exclude the HWPoison ones in the high-order folio.
> > free_has_hwpoisoned() happens at the end of free_pages_prepare(),
> > which already deals with both decomposing the original compound
> > page, updating page metadata like alloc tag and page owner.
> > It is also only applied when PG_has_hwpoisoned indicates folio
> > contains certain HWPoison page(s) for performance reason.
> > Its idea is to iterate through the sub-pages of the folio to
> > identify contiguous ranges of healthy pages. Instead of freeing
> > pages one by one, free_has_hwpoisoned() then re-use
> > free_prepared_contig_range() [11] to decompose healthy ranges into
> > the largest possible chunks of different orders. Every chunk is
> > freed via __free_frozen_pages().
>
> Thanks.  I'll await further reviewer input before taking any action
> with this series.
>
> AI review flags several possible issues, some of them pre-existing:
>
>         https://sashiko.dev/#/patchset/20260705180714.3708947-1-jiaqiyan@=
google.com
>
>

Thanks for the reminder, Andrew! Two of the issues reported by Sashiko
actually are relevant and real, and I just replied to the mailing list
with fixes.

I will soon reply to the reviews/comments from human.

