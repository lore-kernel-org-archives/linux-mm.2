Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC78BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4EEF6B00B0; Tue, 30 Jun 2026 21:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26DC6B00B2; Tue, 30 Jun 2026 21:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17AC6B00B5; Tue, 30 Jun 2026 21:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62D306B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:26:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7A678B780
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:26:56 +0000 (UTC)
X-FDA: 84938468832.05.DA687E8
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id EE2EB1C0002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:26:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sDwIr64T;
	spf=pass (imf21.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782869214;
	b=xLhhaj5G5eOE8SMz+E/Bgu14S8e5X14Hct3DrR47yoduv6ITIN/lT03O4zPytrzSgV8z+d
	OqIhAOaxU0RxqYAtPvydg8rWya/tnwRpobIkvp9yy9NqC9JXqZA9KzvOVDlleGicDk/LRc
	+RwBtoq57ttIOULLQ6pqZWOidege550=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782869214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nn44OXfsXbSy/YGYXvazJT7BtR910hPGEJFfOKFr6fI=;
	b=gKlFflKWvl53IM/GseXis92Heu0a2tJYHSNNR3MNJnB0k86W06HFRhUXylGKSrTaQiHrt0
	fKfFiyiX6aUCwFGrF4s16EWX0nC9K+hBGIT8CQAFVxRBg8gSPde1Q7r2a9ByY9guoaloHd
	KzbxRp9x7TB+QBo3uER7AWH3KQC9+WA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sDwIr64T;
	spf=pass (imf21.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aec201b582so83865e87.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:26:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782869213; cv=none;
        d=google.com; s=arc-20260327;
        b=o+p+gelll0rzKhefd2D39SDzy96KPK6qa9Astdia4UgXHR45LirUv4x4mhqCqPFFL/
         iimx3AOTsTPSgnmIbAd3kNkzoOurqKMpnZIQ6VP2H9lMzG1IAeQYFtAQ2ewO5aWk3OlX
         JudxEbKzMaD+/OGBuCdxDpycq4Dy2I2aN+D41nXHlCaxDVjqU4K/uXPYPADrWeRVo+1z
         Dgp8S1LNKokRQa5vrfx3FjmUVyof8yfWiquRNATekjJfhGGdBOluRjXZg2p2ZZzQ3XpF
         Xda4dNDGRzbfgO8UgDqDICnm32PE+6o+jZfG9lY4bwcNlp05Pn0/pKCao+33125At7Kw
         58fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nn44OXfsXbSy/YGYXvazJT7BtR910hPGEJFfOKFr6fI=;
        fh=65GlonRaVOSyqGKciDtTfOIazg3Ln8ESTs+0Be8l1pw=;
        b=o6j2pkqqdZx7k4AOjbaGUeT7Zi4IHf8guqdANy0CiH7jU97HQCiDGRX361HZcB3xNN
         hDwLBDmZO4/i29GptuKCwa8NM0L8QN5WUv6mYAX9gqlD9XVspYMvUKfvgyavy9zeFtC0
         JkZG1HBhk0+pDyDNgObvDU7Hi7TZU+fKotm2YAYmVX+Vb0TuyzTvj/5LnY8OU4G19ncA
         GMmqCY1RmqtEaJ4XMVABXVNs6JP+ojNR73AAQkkln/gBARcEyOMCjch0kV/LjpYVQuHF
         b6H7d19H9I2MlykAw2XOQtrjg9Ju8Rzggs47Af6+/vr6zX0kv1g82qtjz9BonZIWS0M2
         anhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782869213; x=1783474013; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nn44OXfsXbSy/YGYXvazJT7BtR910hPGEJFfOKFr6fI=;
        b=sDwIr64TJJFxYKUSAdQ1kV2U5YS8UkD4lz+DCktrBmiu6ymC56C30gVT06uVtzc7Vl
         aGeO83Gjge2o9zaDhsJhBW+7CuTKsRFVE3kyvJ/mlm9jSAfoGxkB7sl68JGBAnUEcoh+
         P0ig0ynHRdEViyy+ti3dgX3mKoEYHmYUUnbC4xIZnmqLVFjG+ceLAp5O6xnzpEhiN9vL
         5EfzaIN+43+ZdV5Buzp4mA8WuLERuQlHN0bTqAdN+tZjG4u91G/egnvVsMPcYRH0/HPe
         6UyS19KQ+DOIh0jSboxaa2Skb6nRL+MayuRudIk5IQkeLw1ogRYLBS8PDdRoZKMGj7jP
         Lg2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782869213; x=1783474013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nn44OXfsXbSy/YGYXvazJT7BtR910hPGEJFfOKFr6fI=;
        b=imFY/pXsRj+eXyp+neTN2UkBcRLmQyeuA1snYzGQpm6MTruFcep1zAGwTR7+ixT+HB
         qJl/c2UobUAN3kbZAhiM33dhzkhPZLngziMERhPn+H8jswuiafkwacxQ02CmVT5soJ3x
         4i+Xfa7/7OPDWzmoBLxk6N2Xra0sry1vnv/LWya2tAALp3zzzfJRO+0aYPWGwWmj3Pyy
         C+PRREzsaIf6jdI7r4UeQ0B5DnQrnWkp/lMivJ6yO0EZc+65ErM1YLm8unznIuthJC73
         GbWVXIDRg7yTYKzo162tKuDiCtEyQQiL7njHf2RTOMcqHGBoFuseanKla4UFMaI8BSlD
         XHAg==
X-Forwarded-Encrypted: i=1; AHgh+RobGx3bxz8ElHOTVQiTO5W4cdfYd6y9H/YkuuxmrwMHTmyczrqU2BzloUkCh8KaRtW8DEHOmAd2wQ==@kvack.org
X-Gm-Message-State: AOJu0YynU79j/a2foN8cdI4lY67rkIC6UefBI2ra3uzp1fc28a+lu2m7
	4ujPMm6+GeWBA7YK4pspIJBfmuebrG+LllE5oslyJ/GUWMSC9zCKAQOYb6kHePyl54uD3mbK26F
	/G7wG7bxD33AVpzBF9JjyFkzEn5ANJ04=
X-Gm-Gg: AfdE7cne8D5sc5FlZzoG7bKzS8eWdlQDfoAIquIlqgU9V0eT4GU4q00qlGs2q0gnWbw
	7XQE0sOxVTO4l05uiRReWrPL0n3WuhLpog9jMpqQU6zj8bfiux0zkjEcA9dfVQstS0yRwqbrJUW
	5SZTQf1Iv0i1LmtSLbsSbteq89nbjO1zeqrvZR8M90c+Qa/sL/JhxTVC36LWCTXorqPVA/AErRs
	txqSYTEKsOqGpUBoihlgDZvji1dX8e0H/vFsAD7PnZIMfcU4Ow/kuoBtmDZKqqi0aa2YX3b2vAT
	zx456CgdjAu6iThVl6hyVkIovmawlnTWcX4p
X-Received: by 2002:a19:ee1a:0:b0:5ae:b8cc:7090 with SMTP id
 2adb3069b0e04-5aec10ac84amr514208e87.17.1782869212973; Tue, 30 Jun 2026
 18:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
 <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-1-d4f648963382@gmail.com> <akPwKK22ahROxDqL@cmpxchg.org>
In-Reply-To: <akPwKK22ahROxDqL@cmpxchg.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 1 Jul 2026 09:26:40 +0800
X-Gm-Features: AVVi8Cdt8tgnGzZA_WeFA3JAUzVfHE9BvykEBi_G2elgToaz929JtXbx_b5q4WA
Message-ID: <CAJxJ_ji1JhqPnKoO+KdTREXnMpaOMzZ5VQUMcHS3yu2uF7g5Jw@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] mm/swap: colocate page-cluster sysctl with swap readahead
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EE2EB1C0002
X-Stat-Signature: pbqduwwmowmutu5rsrtoy8o7a6uzgw9i
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782869214-478767
X-HE-Meta: U2FsdGVkX18ZNvGdr8NIFdR1bpqG9GPcfnA9tKH6SPON0JGvs+SBxemfEWgBZtKtqCg7HyA2+NOFCrj2+HPETTo+8ZGa+SxzZY0bvFdlY8go5q722LmEGtvyAQPeQz+oizSXy1Owo1pONfOJygfeLi9fcDG34E90okfXltu5rTlT1eMXCJGuikp6OegY3iZgaM4IBYLSYOcDRfqX/CEvqiggAQmiXhdGtfzd36BM4NcWi9mKhebyUCU7GWqeHZfyReCzTGPTnLX+nQ8DzuZb/R2NlAiCzoEZSK5hdqi3B0jUKa2IOl/P/whOU05tZGZb3PQkpveuSpPK4yUq07egwEmVizFCP2TuZEt9sL6Cv/FzRzih7HjG02xHdQla16oUefVw+8ZPd1VdweUt0mkNItWxOyYHETuLm/5A7sfI1gupSuP1kTMq1QCbpD6WwhoL/2m9gWIgDdkx9/i+LfWePWXim845eA5H8Q28aX4bAa/f0OjBQzsqFS6kqSwzFYLfzdB+jxgeI10VIYrEf0vprCFyrIGg6zgpXExONX3VuuTQ2z+UUi21p83c+hWMlBQACyDnU1Z9cDNirh1qfFufoJ+a6qWUpwd5hTfY7HCpjHslaYKTK4+CW4nkGVcnytTFAuBvatyigVCB1Y2ryv921ptfjjnHFCEEiMB1bkyofCBmqnyG8hiXWFI01iMzg9hAjzBQynyMR/AQtUUywANVVVdTUGplJ6Aj4USp2qPGLhPuiXaOPKV0p9kWjejUCHlpP24H35Q4YBKgN58GjPLsjlpdKtPqgmyq2TDGuHd8gVGLd06S8k63rg0F+rcd2q7k8ADyrBHjKyH7umfWkNZev7dKM40TyJpLxJk4NYww6H5H748H/bnYZgmxPOVjmBGYjhhtVQBWKrw960rNkza0enbTLH7U3zIDQNo0y4V6b8PRwXbX/wmNZEX6iKiAv5oMqmwyIMO8AruSSTvgQPb
 /0OwDyDT
 gm2e6ZLuru/JpcxzYw38hKJ5ojb2cHCt9Kxyi1VhgodkLlbXVlNodxsKm+cvWEUhFtWMpHPT0UZHV/dqyxfGi2vZcqAbInFv9IFusiV5/GfLLwFCqddklljIBdH+88cxBGSbA+oj+GewUmudnF+g/ZNHPUoyhaYpA6OsKpWYiuJcSDg3HUD1oFWLCnv06rRnrwKxeratR9dDN3uVX0S5+ri2vvFKKEqDzhYMC5ebAPvMe2M8ruTUQOvFt4V9h0pHHb5+Kt03NqACvVyB/iOmt1ts92yrPfJVHVWn7kwe5Lhh+wH1kUul25dz8GDzeL3uuxwfoK5qIRtZQltUK8jLLPAkVeSig2XgjHmkzgbYactok8x9XzpkHCGY2pLneOsoN0Fvni9RhmHfFH/UKKVoencl1pAKzl7Zsd9673YBamJaurpzFjkiuLUROLqdzjzRy3tJiU8MAT64JDstYTxcazVWrTaw/1kEDrBauk8oZxSQyIK743upZEVjOjMOhYKIYATKDPKxYWFXS8TpxcPpOhlFCJDpEJVRBEYBopwksBwhTa10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026 at 12:34=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Wed, Jul 01, 2026 at 12:27:32AM +0800, Jianyue Wu wrote:
> > page_cluster and the vm.page-cluster sysctl are only used by swap-in
> > readahead in swap_state.c. Move them out of swap.c together with
> > swap_readahead_setup(), and make page_cluster static to that file.
> >
> > Rename swap_setup() while moving it as well. The helper is internal to
> > MM and now only sets up swap readahead defaults and its sysctl hook, so
> > the more specific name matches its reduced scope.
> >
> > swap_setup() previously lived in mm/swap.c, which is built
> > unconditionally, so the vm.page-cluster sysctl was registered also on
> > CONFIG_SWAP=3Dn kernels. swap_readahead_setup() is now a no-op stub whe=
n
> > CONFIG_SWAP is disabled, so vm.page-cluster is no longer registered
> > there. The knob only tunes swap-in readahead and had no effect without
> > swap.
> >
> > Suggested-by: Baoquan He <bhe@redhat.com>
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> Btw, I suggested this:
>
> https://lore.kernel.org/all/adUTC-7iyOAUlhR7@cmpxchg.org/

Hi Johannes,

Sorry I missed your Suggested-by tag on patch 1/3. Exactly, I moved
page_cluster and the vm.page-cluster sysctl into mm/swap_state.c
as you suggested.

I'll add it in v7.

Thanks for the review :)

