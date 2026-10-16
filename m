Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A7FCCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9787A6B0096; Fri, 16 Oct 2026 02:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FD86B0098; Fri, 16 Oct 2026 02:16:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E9A6B0099; Fri, 16 Oct 2026 02:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5BE6B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:16:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D565A02E7
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:41 +0000 (UTC)
X-FDA: 85327480602.17.C1D9A72
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8FCD6120007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tKPhks3d;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nw95ViH0murspGBeVdDuR7/ikIvvt0nVUNuA1BMwLqs=;
	b=s5p0OFeiP6HLyN8YlTCsL5ZaGlnzYdo/CBiVqWphF7urcAWMw+RojezAjVmkm6vLmI07oP
	Pji2j00W/cFXlfX/+3Kp9on84AGQDmtxN697Yizzj7mDH6g66m3OKAN1cNaEUEou6nalUl
	z2RIQHmvJFx+p9NOh6KEP1npwe+TrSo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792131399;
	b=plvTgNLXZ6q41tSmh6pBZr6p75K85shenx+mSNnWJ/I1gRDaUunAFcfpymXmP89w8mYNwd
	Ue44QjU/HohRzP/M3CrrSrsvz8f2jGCqygJEHPKTl5Ll7R1PUx9sU/ooKmyU8nQTUYGgLV
	uGQ1AZoKPyJssSDRtcUsROb7nA36YRs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tKPhks3d;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-88bd2b44f3aso3066180b3a.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:16:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792131398; cv=none;
        d=google.com; s=arc-20260327;
        b=nc8wPpk4052uH1KOFhBHj2sKMk48mDMLBo3pjAjVvXDxr0M/7Z/DoKSbviUZbvl+n4
         ngkE9Uf6JHntShIvgj9KV/CDVJxChopZo1kyrwBde9PTPidd06QZ8X2kVvvcWhduVhkg
         FfKpR8giekFTCyLalWXpfG2xN0ABDGLaQIZoRP2Q/GaKkRO74Uz4Ju8Bj6tJwZynkCf9
         wnzuuCRVtwsHrBejyBPwj2FMxpcXlOIQQ3DPUh0zptkjuXamWeNz7Yy6uohFaoqtKPhr
         upJtKyj/20k+/UMHnh1Gl9js6UYIEflMnqA+wtuMi9Yajb/t8mbYonVsid1KhD816gCo
         1H1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nw95ViH0murspGBeVdDuR7/ikIvvt0nVUNuA1BMwLqs=;
        fh=FDhno6SWazzoUY3gNTGMkNQO2IgvyU9Q5a15pAqlUM4=;
        b=R1cRwSjUQWbOqXpSuW1K24RfvL/rAYparryencDdzitH5mJnK37Jjo9mU8j9W6bvfl
         cKSNb0b8HdRPZbUO087gkvK1MC95QzI2Ui+A9yF8cYq6NJIM8lJ1wWS/nVPch3FiO7dq
         a8MIzNQViikHeAl/1VIabivS1QDJJeXsGnv6ioGTFSezYvHWbOUegq0tVIjpUvcTL9ua
         jwOYaCBoNRz7xZEnzAHi86AjaX/qqO6yfEKjId7/tT9P2TGv+P/QB5EedSLZAlviaHGe
         yfY7k0WDC9ICDUiLakgP+Ne8zKswalRz11PnIcj04/p0ZaVoJltGBFp1NKpaybKPadwg
         3m5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131398; x=1792736198; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Nw95ViH0murspGBeVdDuR7/ikIvvt0nVUNuA1BMwLqs=;
        b=tKPhks3dWVzuLN9lS3ts9mtlatL1joOLQjm35Oejpx56G0Py0tBYMXmb9uNUoFQAqB
         YLZUtE2HvPveKfqiovdS+b/KnoQ21QfcVCIXF9zFjuzRRYD2O+y2rfYR8gMAou+ptwrK
         IkwcmTdDO181Mn/AkNnPGjYqquNO4NvOaLz7SdkO4IsxDTS6yx5TArGTm5AGOdOVh3XH
         EeCb+TqcUxrTLZ72tQ7pAJ4Y2Fy3U50Nz/v/lQ+7uHydvXssv1LKt9khECPmAuXbuISw
         85o4ysSp2cACNMNjGqaKFKFZGrF3En1qO3tLBGgCyjEO1agKIPt+e5Btor4XAdLbmcrj
         0tgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131398; x=1792736198;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nw95ViH0murspGBeVdDuR7/ikIvvt0nVUNuA1BMwLqs=;
        b=fDIvv5Au5KLdmM4nTO8HQDjLYABKfRkdTPJhWM5wk2tVTxuNKBgJwYid+8veyfkeRs
         a+/wGja/VFgkHFAHe3CgLjeRnaNhB0fmjX5IGvnair2Fld+LtVnzztbU8Tc+VlaMYynR
         2qBzWJN58bQqrVWNfLUOhWtUFlyCREMDMIip8I0r0a8V9ej1unJ+67iIriK/CH3xnLVG
         a4RNmFMB60ltkVMKc8cbLh62MWQ3ogQ3LeQSgT7mWN+zkZZwmayAIMsKoweUNXaRTqm3
         dVB2waFWC/qZEvWczo435nqgwAF0ctnMyVJLkBfanh95/DVCzhuoblfvXrFiHCCkLqAb
         WJhQ==
X-Gm-Message-State: AFq9FYI/q7ZhfhjrNK4z17xe/AvPOztqLhTkNG2fpuHozBx253e3sksa
	4XVvI1/SJM1bWxSXJcsrFH+SiGMNCQMb/qNkSIZn5kEGjxPQkydlB+QR4DxwhTwxN+o7Duknl6b
	ZRRqWfZ1YbzilIN5g8nFyvaJFiRiXSDk=
X-Gm-Gg: AYBFou0OB6mudryCuzw8M66nn+1HEhXv0CeY+rVKgCh08gb693HUrf6EtC4P0+e1AQW
	9+XNIQxX5Lwet8HfWaxXQw56mNJ45zKMiFSacG1zX4Ln/bJ3uShL7Hr46OP3d/XNwaoWOfVXOHz
	u2h7Tz+qQB1a5TIJK3QEtvcoiFTsK5b3GGvooAZ4JZRP2apP91VA5JNI9u1h6fO8MVKN9kjEZPs
	M5MKlf22RMLWZxr6kM6b2tMjXOH72kn8zpEWm7M0hwK2JbAloak8w9YFRtiyQeBnU6PTe4613DN
	/OeofqyWSFj8tdSGIqVighOzRUKru5teOq9CZXcAPaKbkCFZE9boGYghwN623YlozHF3dOyoIBA
	1s3DeqWn42Wm0GgpjsHMgm19H99U/aVMzeoMwbmkSlj1LWwX8eOAe8nocCr2piFLDP44e6A==
X-Received: by 2002:a05:6a00:3d11:b0:88f:9fd9:3779 with SMTP id
 d2e1a72fcca58-897c65410bemr19217680b3a.19.1792131398279; Thu, 15 Oct 2026
 23:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com> <atEkfmRFgXJCbJuK@thinkstation>
In-Reply-To: <atEkfmRFgXJCbJuK@thinkstation>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 16 Oct 2026 14:15:59 +0800
X-Gm-Features: AclHuK9suf2MtgpJ8U-2R0dSol8SG-UyxjWNOAi7XM84G6vCwX9BAPJIIlEtxbI
Message-ID: <CAMgjq7A6Yom=dHDMXk+mpYm3dotgOaVRjPHgUsOryjJ1VjPC6Q@mail.gmail.com>
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
To: Harry Yoo <harry@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8FCD6120007
X-Rspam-User: 
X-Stat-Signature: bafics3x5nq8rmyy476mfk8qj9xrfg9u
X-HE-Tag: 1792131399-963546
X-HE-Meta: U2FsdGVkX1+jFf26dRpd3SBTp+XXU10Lrz7DxB3ujgImdGffx1Hou7nhrXTFyROd66JZiOLy2dfpCufhmKJkcC/HHqiDSAATXY6vRAltPHMSeVpk5Xgetc1hIB9kHhP7pVnELWG4+xaN5O9qfO7CPxfb9zzb8I6zVn9CIWp6uYi/cqA4RB8Ah9id33cG3ObBYZHqNw2dcfgomTgkkCth+HnrZnaSjaracj45NN+UiEfSIRxzdpTvnXyfOiBH4+F02gyXGR2iqZiVT+UbHXhFgOhxIlOTpamspIh3abSMGwieCSv3KxxQHRVL9Pj3obqWGpML3qauwuCnraL+hDcoKmRRXkO2appzcLaLgvGemKDikRnccoLOZCaoqJvYHSAmmT92yX+1+1bMldeQF3r0muF1lyvBqXZy4DNnPxM11YVyarWlQVkHMZXSw32BoIVrvgPqFINTSNYasyy09fgWgrmUYbUQL5px+AG2nR2Uk03V3vp8OfrJwmFNb5L6J4W/VYZF+lXPH7HFuoRBXqVU1EJAEnn3Jsu1YDBaClvfQAr8zKdabtjvXntv+br40X+U0VM6MoMffD/XQMYPoTmOWoHEjf0e8T6beiW+q/GuCcbtLhrU2dt0FxbOd6DCHIA4MQgKJHhh/G4ri5s/XzRUx0blNulnwiDk4fuW6NniKAKUkdgXL/KWXYgzRwNIcBdJbMXMk07oDL8Me292hppXMCTtEn2n6R0R9wBJqQ+pCYldkYI85+5XN4jka5EMeeqwSHLo+gLss8UlbL2DdHy/C3IP9K8F2wnnFSFKQreKmBFS4pgrfdEBxs223+N8fjFrCF1Q/Bi2HS8Pi1LvSOLUupf89FbXS9PSRcaW8AAowUk3BPGBplrMii00dJmzKwh2G3bLX8Xbu0sae6rBTqNbO8VP8Cetz4ZBygAE/3xNeM2DH2ucXTLQQ4NT5fmBckYOUj5WuTzykrLjO1lgVpz
 t9COdI3h
 +aQ87izwnxPlFf3nEKGr1q1JgsRA1SiVROq/PwPUispgfKC/MPzlSF7Z8Kxge5q6igsbrpBzWb/EzmG5y+tu9NEkujANdl/8zGsmwlRz/tp74v0+FY1QGbxAYfvS3RL8Zy/oAR1TAjo89qm6IypS1k9fhuvK8Z8PRM169qxmTqguUGjRGc0kX95+r8niN3QrAz9HBf3kVhxalNOJwTJxONQ+pe23GpyBKcR2bF+m6rDhjPpZDcRlTxrfkvVGj+Fq0hKI28nIEyn32g5VFofY+ZSPHwilr7XQI5L0OUf91zRuJSjb5MqySqIoHX5PpNvB/FvOiFMAuDmyIeIR6iyEcjy4jjKir8IVsSEZNy97NfxDFy4zuv8XrHiWSwAu/UawjsMGHGnZnjtKWPA1NOqE1gPCJlvPautlfiHfCq+YFF5LY7u5owYr8DDfOwJZpe2EMwRZMvfL47eleB0fIDJSoZKXpZwqVx3pKMlQPDsWDHcahgWJNwUdKo4slcaNyTWD8KT3UytwzUBKDq0avIEQSMRHIIf0PACKkTVTZmdpGA1euQxigb97GQop4hF7NNInkhKrcIbQdEtaQCh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 3:11=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote:
>
> On Fri, Oct 16, 2026 at 02:15:52AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Add a helper that resolves a stable lruvec for a folio under RCU
> > without taking the lruvec lock.  It takes a folio directly so the
> > lruvec lookup happens inside the RCU read-side critical section,
> > which a lruvec-based interface cannot guarantee.
> >
> > No functional change.
> >
> > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> This new helper is doing the the same thing as what
> get_non_dying_memcg_start/end() do.
>

Hi Harry, thanks for letting me know, I wasn't aware this helper
exists, this series started before the re-planting work, so I missed
it.

But it's a bit different though, get_non_dying_memcg_start assumes the
caller holds a reference to memcg, while folio_lruvec_live_get only
assumes the caller holds an reference to the folio.

I'll check if I can deduplicate it though.

