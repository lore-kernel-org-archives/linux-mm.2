Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F64CC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D036B0127; Mon, 29 Jun 2026 11:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235066B013E; Mon, 29 Jun 2026 11:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1238A6B0140; Mon, 29 Jun 2026 11:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C99D16B013E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:05:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CF361A0196
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:05:46 +0000 (UTC)
X-FDA: 84933274692.09.1291025
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5FF8480007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:05:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hz38gn+o;
	spf=pass (imf30.hostedemail.com: domain of jackmanb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782745544;
	b=ds727YqtVL6XYw8Y6Ps4RZL8Sg4VOpLH3CvOCOwToNiFAY0mBaQD+WQ9dBiBzuqYnOmmNm
	Ur59TzJOlGXaKiesGQ/hlA72BKnEkPn9eTs5zIpC82ro72RLnvTeXI+kAd9rL2UZWiJmPG
	x4QFAiUjPScKUAbQlVdZtjQPESBXXrc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kx6sIxZoXItf1W4sk9dkNdIelPfiZanaIqph2jO5EzU=;
	b=T/elygOcHi+EfDA6bOe2N+JkvsaXupue0qvdk7n1FiGVeHj8HmTcAVxqMou64OFY3WYx+J
	LoRrnXauD0o78tuPCfx63ewGwzoHQQjUQ6rqVuwz8f+T+7UUb4/Zm2a7NcEKlV456WSi5t
	CbL/8uT6A5XixfZxLU3n86sgUU06O8g=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hz38gn+o;
	spf=pass (imf30.hostedemail.com: domain of jackmanb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=jackmanb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6981fefb9easo13161a12.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:05:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782745543; cv=none;
        d=google.com; s=arc-20260327;
        b=j1xTo3rX/APDRkPGoUELA0PD4xNZNiU6VEZLBvu1G3c3acGyUUDWFC21Zmb8geFmfz
         RxLyowX3nFj8SE+1lYOcxiz+3XzMx1hbqTOHlNIJLYCFz+nNuLMWtHoimvQRdKRV9Z9+
         LhSgw639japi67ofwySEY2Ivfsb/ZCWry9aO7rVSvTEqQ4yWx/m8BLxp1iPQ0cDIicfp
         Efr7J5Q20HPo7z4YEO1VCQ/9IlBTEHTXppu2RyAfQPLLzjmDQAxOt7diM2nn7q6a9/AI
         rK08kjO0WSz2DfHBWVXAzdRaZbdlH5+dn4Rv2Y+Z7fxr2TR4U7j1i7mCyu8w0FDrHkuz
         GnoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Kx6sIxZoXItf1W4sk9dkNdIelPfiZanaIqph2jO5EzU=;
        fh=CG7S/P68LTMvOBbWfZBGyKS2oEH2oRwtX9TYcg+7mQQ=;
        b=qknp0X33smFsbcjveYmePYjmjRuQvyxe5vri3znCVj9EbVXlKWIbmIeSVzlJdOZrKb
         GYeiS2gB4NO0cHfh6/uE2MRKUFBIcSBsW946+aMy+RaJA2vlLjrgCQUdMCm1lkO71AlJ
         /Pd0T+Y+rZSBEzSxruNHV63Qx7cnsoBOChovZAfU5qWpd8kGhG1p+a2QO9PJA764T0Yo
         a0KrACPsXSXTnDqz7B76C9YxJOBbpwJ6iXyjuUppBQed0e6t3vUg+wx5s42tQ6KRv7Ur
         8vRy8SbgdciO88LxviXrcJ5JhfISsM+OmDJBSmsFTpj34spk/HDxJsfAYCECwXcOkllB
         BAVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782745543; x=1783350343; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kx6sIxZoXItf1W4sk9dkNdIelPfiZanaIqph2jO5EzU=;
        b=Hz38gn+oe0+rQVUqmivntpYnOIGpJnxBtuk5OvLv/XfYdd+MO9jBL+01gYhuf75CNm
         lwkhbOHNwVCBe1ZN5vWPaCOWAyV0oLVJUil+ea+P5obJdk+aAKK5sh3MVq6vwcbR/fWf
         MxXsb/eAm9bqhiZJ/6+rnARQQCX511INWQA2l9UQxr+UnmDPvoWflFuJHpdlq/jsrGba
         PJTN7D0NmS35m2LQJ0cOP8QOd4f9cmwyYd9VwZMwQkMzLpxV013N+3HB+32CiD1tfZ9t
         EzYJHVwPOLXRyH7WHm2q8dRRm+wsmOBmU/IbU1kZYT6Zf3Kb2rTgV3gyzDBPprUshFUi
         cWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782745543; x=1783350343;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Kx6sIxZoXItf1W4sk9dkNdIelPfiZanaIqph2jO5EzU=;
        b=CYU6WRS6P1YvE89G9Aj8d1dxyyzAnF0JznjjzdUFHRBjzU2nPQCOrECxZA0B7F0gNi
         qeqjuD5h/KtPqnx1UwLTp5/VegWaLBRA7Ybwv5ACstertrYfWQoHWr6xXtawo2pTw0c+
         a3E95oeQmTYMxwYW9y241LHwo/HDybW0mukRswJD7yShWBOIVcti62AkX/mr8eRBb2Xq
         12kon6IE0zR/TLkj6b7+sJyCCIIchaqWqrFzO7a3bNm0o/weJBeSWts+FnieAC0rDz77
         ibIAibFXOQwH7wq/Nj7p5sHbP54jiCBNFC2r54tZlbJezwIa2gom2C9+7k4x9qbgj8yt
         9Lug==
X-Forwarded-Encrypted: i=1; AHgh+RoHPNgAzK5ui+x9hFFHQOWPP5mqM1L0lBhgZLciV0qBEleuNjbPQv3t2Gfbjo1Z+elFBm/YHOfH/Q==@kvack.org
X-Gm-Message-State: AOJu0Yyw0HHeJ48CIMIE4f4y4jVciwkOX0+KRnnqJswRMlvVsK6TifEs
	JoVD3AV8iblNhr/Bh+eORrbHFOqU3nNuddSpiF1vREnQU+AMKnX6X4fpBX1yVJnwsHAf7Qhit37
	iT9gGz1vdZbaiR/Wqt2aFM3sTfpot+ozVhEpWyCdK
X-Gm-Gg: AfdE7cldGoc8R95GYt6ZYESwT1MC7hQ7wnD62sb7scXzmoUiGxWOjZ3hsXg4+CoTaz0
	ySjHhUfSt4k1Ao9DpLBrvEZRdsEs/TYkhrlkFm/HrNCLjwsOynkBoxQReMUV4HX3+UYuAf3hT+O
	XlyYmR0laTcuW5+nvuv87d7mDA70mlBTDyPCsZIpj1NgqXD9n7JP4jiT1H128FHzGTWYq16l3ox
	Bdur88zGHNUIfQ8Z682SpyOsXaRIf8G6/E3Jtf7ol+RAP0qR9odOmRFljYAigbhd7UxFQ5fAw==
X-Received: by 2002:a05:6402:424c:10b0:68a:83c2:9c75 with SMTP id
 4fb4d7f45d1cf-698795f58f5mr2358a12.0.1782745542255; Mon, 29 Jun 2026 08:05:42
 -0700 (PDT)
MIME-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <akJ6Z2P8eMm1tc65@kernel.org> <CA+i-1C1CMgmPyqxT3dkLWVT34HqoPBi+0=GhF2rk2-wJSjSZng@mail.gmail.com>
In-Reply-To: <CA+i-1C1CMgmPyqxT3dkLWVT34HqoPBi+0=GhF2rk2-wJSjSZng@mail.gmail.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Mon, 29 Jun 2026 17:05:30 +0200
X-Gm-Features: AVVi8CfvejoTQU8KXVTesjH-swbBnnggwErReWWIPfe5O_Cbw4Rt2EVNnoBtZLE
Message-ID: <CA+i-1C10zQs8sGtQpR+jsPsQVCO+Y9VRXkgt9xikxgc2eCFWVQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/16] mm: Some cleanups for page allocator APIs
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Robin Holt <robinmholt@gmail.com>, Steve Wahl <steve.wahl@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dimitris Michailidis <dmichail@fungible.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5FF8480007
X-Stat-Signature: 3cbkm745jw1yc56d1umsmttkn5hnybgb
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782745544-270690
X-HE-Meta: U2FsdGVkX1/wfqAaEQs4mIedxEm0/L3OT93RUHzgUaMmaQd3A3+u9hi9r1wFKJKFiRlzyHu1tOoeL4DWpP4EBSasG4/GuKu4dIdyP4Q/F78GdMefMpFwGP5cVZotBCBYolxTnCqyZV1D6tbiMh9UKMRq+FrZn159mgLfnefglO7zWXuKUif1rDh2G6RXNQ0KKgbFxziHOMsH4Ym3zRbRqgnqwG70uzZiS6mh/jrnORHoYE6oMJ0VP1BX7dAA48AGzyXOaglGe+sxkFaCRgRioEvk8aI9+fF2xXy7d9JpRqfAgscTz7/2uKqECKkedCAnPxmWlq/S934t0oI9lirjc/k/U0T9eaIWljFUyqE3Ty+ywTvBqFnq45onAKMYLDvpLd1USrpGLgkW+mJzaPFiErQOJCvv/2LN2UpNGb0M6NmoPflKOB0+i413vgm+IDVZcskllwlulMa21VdlOo3nXRtMiSHCT/gAoYxeUce5he4KFNsHYZ0myaPkCjAiPNuuSWpxoNYwroGIDvyzq0p4LGrW1VARxfBxr7usxo2cqHJg+vHJqyDkb52um5nSWWG2aYtiCJr/K9WmJgMkwyDStR9WwBuJ9yQ9shvbHdxc40fLUoc7LJNJ7cfKX4TSzPNa5xKjzNPLgdcHSMiG/6x682UPvEvn0F0bCrG7Po/LDNXo3bIKvF6glBMkynrkwqOgVTl8pksiFV6Bv3fFxM9R+hXD8py49ZxY/TuajI/Z/DK8WATmoI/ACbleV2tQloK5VFHKtTdH6Oy3gNCsR0/MbbP69rtokOt/uWrDnMaP/bChlCpJrQasD519l0ElOtwV1gaNBnE8BJGMi2hGBbfh+YQ17M3lXT/rYCwBRatjr4YHQwzT9EAKLM7l+wUOhPYRxnYy+3mlu6xjcEdTct3QsAG/3ktMruM3htQKQGRTQ7butT8eTqcwsexqWYhZNi0ezJ1ZAo+rvoRlQrI3688
 KqzjODYi
 9yITYeHLAXSsXczPPpt18B32uG47GiZO9ylxisJpImEW922cI1lrpj5uIzsysiXMWEdHkSy9kIikFVTPTtYpUThsE8XIstLtWM1EiKEnqYmpxdsm26XxiHpyfkNp2OIEe1aTwDnsXiaFTRZq8gOcUo2BmtNwkPm9wbP9+mtBTR9LKnthI9IPET5mLduM3U1HogKN3oMGDdpRgzU+OfYw38wBstARsxqAdNDuIkx1HNEk0jRpfZttUflAlLgd32ckjcpX3wT9ylI1QwelanI7Dexv77IZ1HOA52+ZSk6XnJoP/Btq+4uSlVMp564JQQpuL73QppkYlrvwvak8DZld+jA1vqHjfNqPnR0ZAQyn2Kq46e63lFIavBim+q8RrqYbN5kKDJzFZ4L5rW+ZGHwF+upQtAT3aPVdeuilhMJtvDP7rnkO95dyzQMV+fFts5s9NlgCx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 at 16:30, Brendan Jackman <jackmanb@google.com> wrote:
>
> On Mon, 29 Jun 2026 at 16:00, Mike Rapoport <rppt@kernel.org> wrote:
> >
> > Hi Brendan,
> >
> > On Mon, Jun 29, 2026 at 01:11:49PM +0000, Brendan Jackman wrote:
> > >
> > > Some tweaks and cleanups for page allocator entrypoint and flags. This
> > > is motivated by preparation for __GFP_UNMAPPED [1] (which will probably
> > > become ALLOC_UNMAPPED in its next iteration), but all this is supposed
> > > to be an improvement to the codebase in its own right: unifying code
> > > paths, reducing API surface, and removing GFP flags.
> > >
> > > Tested:
> > >
> > > - KVM, mm, and BPF selftests in a QEMU VM
> > >
> > > - kunit.py on x86_64
> > >
> > > - For the ALLOC_NO_CODETAG bits I just booted a VM and read
> > >   /proc/allocinfo. I confirmed that if I remove ALLOC_NO_CODETAG, the
> > >   kernel crashes in early boot, so I was at least booting code that
> > >   depends on this logic.
> >
> > Heads up before the full kbuild report:
> >
> > CI has tested the following submission:
> > Status:     FAILURE
> > Name:       [v3,00/16] mm: Some cleanups for page allocator APIs
> > Patchwork:  https://patchwork.kernel.org/project/linux-mm/list/?series=1118244&state=*
> > Matrix:     https://github.com/linux-mm/linux-mm/actions/runs/28375636866
>
> Agh, thanks, I broke the build for CMA.
>
> I thought I had this covered in my local test scripts. I will fix that
> first then I'll send a fixup for the patch.

OK my scripts are indeed checking CMA, the issue is that I didn't
build with NUMA_BALANCING.

I guess Suren was right[0] and I really should build allmodconfig (at
least vmlinux) before sending patches. I was a bit skeptical that this
was an especially useful config to build, but now I realise it just
maximises coverage, even if it does so under a pretty arbitrary
configuration.

[0] https://lore.kernel.org/all/CAJuCfpHAMaK2sZYSgS750CvgksCKEfOmLzZasXdBup+CrS-3Pg@mail.gmail.com/

Here are the fixes:

diff --git i/mm/migrate.c w/mm/migrate.c
index d9b23909d716c..8e0a6fb3f6618 100644
--- i/mm/migrate.c
+++ w/mm/migrate.c
@@ -49,6 +49,7 @@
 #include <trace/events/migrate.h>

 #include "internal.h"
+#include "page_alloc.h"
 #include "swap.h"

 static const struct movable_operations *offline_movable_ops;
diff --git i/mm/page_reporting.c w/mm/page_reporting.c
index 7418f2e500bb4..c7325704c3202 100644
--- i/mm/page_reporting.c
+++ w/mm/page_reporting.c
@@ -8,6 +8,7 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>

+#include "page_alloc.h"
 #include "page_reporting.h"
 #include "internal.h"

diff --git i/mm/shuffle.c w/mm/shuffle.c
index fb1393b8b3a9d..82a2c7725a08a 100644
--- i/mm/shuffle.c
+++ w/mm/shuffle.c
@@ -7,6 +7,7 @@
 #include <linux/random.h>
 #include <linux/moduleparam.h>
 #include "internal.h"
+#include "page_alloc.h"
 #include "shuffle.h"

 DEFINE_STATIC_KEY_FALSE(page_alloc_shuffle_key);

