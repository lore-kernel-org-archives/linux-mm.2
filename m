Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C66F1C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8BF6B008C; Thu, 17 Sep 2026 23:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98D56B0092; Thu, 17 Sep 2026 23:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60656B0095; Thu, 17 Sep 2026 23:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5E76B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:05:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4237120567
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:05:37 +0000 (UTC)
X-FDA: 85225392714.29.995F3FE
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id ECD861C0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:05:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZsWSAEOJ;
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789700735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oNy2HuXVWsVzCazMXbHxpcJNwqU+Nw1U6v/odAHiSA=;
	b=ganJIcCcA16tuEhLAMtqaqsPxB4eVLmRXvjjJcW/tFVsoxh+lp0tte0Cyzqh0zet7G5gwD
	uRfTHyx/rABx1n3/pT6jThYcbc/G601U+fSxiEvpMW7zqzwBphACzPCo/tsve2z15Y2RSV
	mW63vkpQt3tbcZE0s6PIf4c/WWpHSAI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789700736;
	b=u3SEe40bwONW6FWgijfxOxyfMhuNvDqLAFk0K5zRlGC4xWe8fTkoa9EsQs3ybNgwUzVIR7
	2nQULSb3zQI4DOuMuLDPLXpwb4c4i28Qe3Y5zpx+X8wxPkU2onJfgWW/eb0dTgLpyNo5/Z
	drLr0coMSJ71jkrTWC7mtnmPKTS1Vnk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZsWSAEOJ;
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-91235f46716so3272166d6.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:05:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789700735; cv=none;
        d=google.com; s=arc-20260327;
        b=FZ7pAtY4yHnT3hX0S0JwFG9K5lSDfbdBYS8ZX/OfuKzR/zAcGPF+nfzc4OyZVcVQuS
         y3HR7jYjAJRTejbC2RMq7zil5XDctGPNqU31QvL2KjB4xHdYNhdtYB8wqShDAGNFxvTT
         //Bp1VFfxYt9Nyb9C6Hez4d0FRhlghROQ3Cq+T8uIw8Qkd0X82blgJGaGRdh7FMQ0dgv
         AaqedGjl7WJ6YaUyVFfobPpkQBg/4aaVHZJuA5EAKKHieny6I38wKA8sKWAD9wcc13mx
         3jdk6eTzc1zxf58mn4SEzzjbu8ePD223o0yOwxBE2Q+5rxyAs+/7tLk2+GMN09rV7EIg
         F7pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=8oNy2HuXVWsVzCazMXbHxpcJNwqU+Nw1U6v/odAHiSA=;
        fh=kwlLQtCH4sXf6KoTy3mIVQrJ/lIhFbv/9dWEFU4nHD0=;
        b=HK8XLclqXY0nKsvLFBgXpuXmDBUKiR5/pjKqL6cH7jjnG0z1DD5EIIzmhGLJczPmUj
         GWczvEvyxFrFMxG7uNgzXucGp1PC7dzFRq19qGe8sPJWsf6YgjhfEM8YjGmPRJT8gEcE
         L5H5PdaiS+pxYp9KWvtlXneG+/UweWM2CNf6+5QLM09kVHLy/EFDZeuuzTv8gitLLM2d
         kFaPL+czWobIozFrdNNs8gId5tE54IKzRTZHqjj7erGaEoPB4UlbAF9hRvAviL3E9FGx
         QheeKnwMQbgqvLJFxUjy+jfwwFQhIwu9dqU1TTJJCdIspgBuOGxka5FcfvQ+Egrnmh/k
         2jig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789700735; x=1790305535; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8oNy2HuXVWsVzCazMXbHxpcJNwqU+Nw1U6v/odAHiSA=;
        b=ZsWSAEOJg04GaH+ltB4dD/KQWk54HUgzEqCutfPPayPDC+eAT74LAxHjWEf9ZInAgY
         uZC6aZSLoMm7bI/IvQYKGLhIio5Lr+qDo4L8JiX75qJISep5PXKF4wd7MM96I9dECDu3
         Gw5Kffea0KW+wzLK+7boVzgz8u0xYqQQrlASHuVL1tLRKqTS1jRoPWZl2c/NSUm5TA4F
         zv7ouWelmkyilQ3qUaV8Wj4L7IN5MJqey/FlEMNz/wmOQsroJTcvSMWTTpzqnVZY5PhB
         PnbZMyW2yrFOh0H8Y21/DupyNUpyvZvYK2Zr8QFlF2zp3cbZURbIvb/G1Gu2WKRatCvZ
         PtXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789700735; x=1790305535;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8oNy2HuXVWsVzCazMXbHxpcJNwqU+Nw1U6v/odAHiSA=;
        b=loZI3+UqMdYbKumxqo1Y1XcS17WzZs1UgTCBPp9nVYY82VwFYUI0SW1BZ9pY8eE1j9
         2XFfKwKzscWR4Vf6BHLJZsQBjiLymH3qxZeIhrF4yDZe7gqPYYzOZDeJUusOtqB5v+kT
         jFE+fefjPde7GxnoGfCPEk+Yoj29kFjGQgK7MrA87Rw67gkfoty8xKOPrjdFTNV7P6Cu
         5aATVPgvDvJ6hc+UAGVLkQ4pIJBWO7hYWfcerEJvFj9Paby4bbWgt7dSwKxK4WYJvkVj
         DDuUKVCfAbxUhBp1yMCr6XHBM9R67/Bf82lPs5pw7iQnK49cqzQASo/s5cTxetLhvNLc
         WkrQ==
X-Forwarded-Encrypted: i=1; AKwUvBwRlE7RD3Oxsbkmcv1POI6CWEC9aHa/OPVKwYRs2Re9RE+ypuo2bcr1tbRAQxZom7kdIDB/KHoKBA==@kvack.org
X-Gm-Message-State: AFuF++mT35IWBOEiKoKAdQiUPQEy+CbQxygu9mn5vRh2EVK5fT4OIiW7
	ZKNHSuOPDfqjhar6CBy91jMMPI7B6sgNJd8UqSIGltbounlV1lE7SFWNADQq1idgX+Dx3/6jJ1v
	+Jx6YiSQOhI/XX5t0GkzWHStFYzecpzc5WuKnaacD
X-Gm-Gg: AYBFou3TkA85AXvxVORlzWsE4h7l2vBLtb4uKa27EVXXEdkijZIuN9zhkGVY3qJ4Soy
	vmyQVoioGauN2pPZlL6tNg7Pdu+i6fPUhYD1+3wDyNLJ7YjWKjB1fkAV6eGH6C8lhR3vPOhbVUK
	60GoujmiyR3HEpt0B2rVyxsTW0AIdiyOC++S9q/njyWwQ7/7URQOuOsm2ETgjzB3edAEUoZlvo4
	povHTc5kQ4AMqryeGYJzYA9B4Wk8Gk86AvnTdwVssv9oTObRIN3xjHi7SmmzBmO/DQBvpEYvBmH
	udBOog6YshiIl5tJIFcOVvcuV61kGWXE0AJ6p0NNdv6fyvqYoMzAY5WYpP9UNyAHWdnCI5u26Mb
	J27yKAo15xw==
X-Received: by 2002:a05:6214:570f:b0:912:517b:911 with SMTP id
 6a1803df08f44-91254cd050emr18449906d6.48.1789700734463; Thu, 17 Sep 2026
 20:05:34 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Sep 2026 20:05:33 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Sep 2026 20:05:33 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
 <20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org>
MIME-Version: 1.0
Date: Thu, 17 Sep 2026 20:05:33 -0700
X-Gm-Features: AcwNN1VMr0mS5JSTeCSWpRPDQdqCHdO4zh_QkNZo0USni7iz5fls9MH4L-TCxPM
Message-ID: <CAEvNRgExZM4ixMfrF_FMw2CTn6JqRX8s=cy0_-x5ypLxvQQuMQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Fix HugeTLB subpool used_hpages tracking
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, Alex Shi <alexs@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
	Hongxiang Lou <louhongxiang@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, Naoya Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com, 
	jthoughton@google.com, rientjes@google.com, vannapurve@google.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ECD861C0002
X-Stat-Signature: 78ehqphegd7muk8hnirs7j99oy9kmksh
X-Rspam-User: 
X-HE-Tag: 1789700735-614575
X-HE-Meta: U2FsdGVkX1/crf57mFUpI6ZsQmYfn4PzBk69tmjllAJeTSj8L06HNUIL9DQ2pgXmUVltOr6toMtnA7LCZ9m+xI7G3/HfEiBBLTmfmxroXHJcF5ArwDqAD+naFGIY2suzXeelf4G92iZzUvpQMXDCY5tEMKX8A4p5n/IJkM7rfBaw45u6bcTKb77a/gWQkMNS+mAXlbGEwFJddVRwl9rNsIxl1qzxzOMj//ShANmL4fv2Dh10ebzSfqktlZi1MlzVL2RfZ4AS5kZGIrpOpQrVu6V8EGZuG6OylgqXpq863GVgAaVKYMT053qYSvGnDRfzDqGCxURB4sWgvaOQ6+BvL0yz/cHShO19+mKOMbo62zKtV/v8Ubh3kMXMfOYb3wgl0jrqC/z33+ZPlhpND7cuiHguQWIVYo6aYQc+SS1hhVB26oSPz6JU4f26bhaSMLkjHydMr6GzHdBKMs4PoMwe+LKBTm060r61TsUISxLgtnQ6ob/tomD7H3F53LPiwgEmxmP4h9whjdn2EyHmu/a6Iaa0YrHCgBXjiHtmKyLuc1Xu0KQUPUJxEtWsrr7l72KLW8Mqd35aBkcLAEc5BY3tsidYyYSGzq8vUOnlI5H//T4z18p6oKE6/vRY/Fx9tmyP1uGmjtqYxKHVMDRYI1RPdtOUmkJY9FgmSskQrGCp/gqS1h8nI+EgJBzGe2gYqMuXT+235efpoKiFuuBa5PJ3kLHPWbAb1ssJ3almZXE73oexcWzxMP7UuzrQw9x4we72oQUNU2d1Sl8vZ3knJg2QIdxNXoF7UfqipBbpP8NeQyKbOK60rlHdWIE3kYP87JFWBgA26ClN2uoYZnXyuaST7k6Zyzgynm4nqAc9tf1rkAf+8y+B5foJ50BXqcawQl3KNYVZnkn3TnRCjeHsginKKwFUAjZwbxy2RSG7X1rqUHcioWdJhzCYtcIwYw/6+RedjeYdw4rV1tVP2jKSGOr
 YUo1gYyF
 POYWgaeJBLNrHPKfi8xevJ9fQJV5/VSbhxlw/iQd0CmW4VX1OFWZuESF34FiqraG38o9TTKFeJEjRFMRSpKjObl5F1WQcgUiNpqh3nB16ONqPXdt+RAjQ7CdEG38hnKT7QLs0VYU0EbuaurqQdmOd8qQ+62xz7vwlHWqRvdUjF5auWeCOscX1RkqIHn8TxSiNOqLOuUlbdaN6au3/p4FYpOGjOrU1t1OMrU7iOeyLLmINoY4OmPuRTOvHA62EHo/Yf/6uTAAjRJ10qjEAuJn7nxCJOiov3ktMiMakXPFwsoM077tR3dyse2g9O7YuZR9l/P7fG7luO/h9GMW/OFVAeTc8wlugttj5qBrsB5wx/gzCt4NloiAKQRhXIzot56vypx17yQaED9wJj5aq36qyXUPqb/VoGAcvZNa/Hla5DNearARWwE5s79MurZjd3PZ9y4ftJa02vAXL3+UwEEsgdM1iHLb42OX5kziYJ+4xDJA0vzUS1CigVinwX43Jmqc1+rMk75LHm2texn3ksN2BmWnunm6BCaM07YT1Cqzrte2iPtHYvqnimuV3bO51JCn8nE+Ml+2UgLuv9z9QMw0LBj3OE3PW/FQJ3rkECZtnCpESlpwfmQWlak4TQkorb9F+JaDw2GqE/utptmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 16 Sep 2026 16:39:00 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:
>
>> HugeTLB subpools currently only track used pages (used_hpages) when a
>> maximum size limit (max_hpages) is configured on the mount.
>>
>> ...
>>
>> This series addresses three problem areas resulting from untracked usage
>> and asymmetric error handling:
>
> These are rather serious-sounding problems.
>
> I'm seeing Fixes: for 10-year-old patches, for one last year and one
> this year.  The fourth patch doesn't identify what to fix.
>
> So if downstream people (-stable maintainers, others) follow our
> recommendations, some kernels will get two of these patches, other
> kernel versions will get three and some lucky kernels might get all
> four.  Are you confident that the patches can be split apart in this
> fashion and still produce a good result?  After all, we're sending
> downstream some patch combinations which we didn't test.
>
> Also, can you speculate about why these things took so long to
> discover?
>

I wouldn't have noticed these if Sashiko didn't point out these
pre-existing issues while I was trying to refactor alloc_hugetlb_folio()
in the earlier patch series.

Here are my guesses:

> 1. False restoration and premature subpool freeing (Patch 1):
>     + Global reservations (resv_huge_pages) are not decremented when
>       reservations are released, depleting available huge pages host-wide.

This requires min_size to be requested and NOT max_size, and it needs
an awkward partial truncation of the file.

>     + On unmount, subpool_is_free() checks (rsv_hpages == min_hpages).
>       Because of the false reservation restoration, this evaluates to true,
>       freeing the subpool while folios are still active in the page cache
>       and causing a use-after-free when they are later released.
>       (See Patch 1 for a detailed step-by-step trace.)

Unmounting masks the issue, because when the subpool is freed,
spool->rsv_hpages gets returned to the global hstate, restoring the
global state. The use-after-free doesn't actually happen unless a folio
outlives the subpool (not common), since free_huge_folio() is the one
that uses after the subpool is freed.

> 2. Reservation rollback races and underflow (Patches 2 & 4):
>     + On hugetlb_acct_memory() failure in hugetlb_reserve_pages(), the
>       error path manually calculates rollbacks using local variables.
>       This is race-prone when concurrent threads interact with the
>       subpool, risking reservation leaks or counter underflows.

I didn't reproduce the race here that could mess up global state, and
races probably hid this. I guess the messing up could go both ways so
perhaps on a machine with heavy load, future races offset the old error?

>     + On region_add() failure, prematurely releasing global reservations
>       forces error cleanup to attempt fresh allocations that can fail
>       under memory pressure.

I didn't write a reproducer for this one, but it's an edge case (memory
pressure causing huge page allocations to fail) of an edge case (OOM on
trying to allocate an entry for the resv_map). It might occur together
if the host is completely out of memory, but I think in that case people
worry more about the system OOM than fixing a HugeTLB bug.

> 3. Subpool usage leak on allocation failure (Patch 3):
>     + In alloc_hugetlb_folio(), when folio allocation fails and
>       gbl_chg == 1, the cleanup path skips hugepage_subpool_put_pages(),
>       permanently leaking used_hpages.

This is a failure path, which probably isn't executed that often. The
reproducer created a very small mount and was specially written to
trigger this edge case.

Overall, I was also second guessing myself: perhaps it was never the
intent to manage reservations by tracking used_hpages throughout, but in
09a95e29cb30 ("mm/hugetlb: optimize minimum size (min_size) accounting")
Mike noted that min size accounting "does not take into account used
pages within the filesystem", and the patch added a check for
used_hpages. Based on that, and the _original_ code documentation below:

	long used_hpages;	/* Used count against maximum, includes */
				/* both allocated and reserved pages. */

I think the original intent was for used_hpages to track both allocated
and reserved pages, and patch 1 restores the original intent, and also
simplifies the logic in many places.

> Ho hum, complicated.  Let's at least slap a Fixes: on [4/4].  My
> trillion-dollar sidekick suggests a9e443086489 ("hugetlb: disable
> region_add file_region coalescing").
>

Your trillion-dollar sidekick got the right patch but the wrong hash :)

Fixes: 0db9d74ed884 ("hugetlb: disable region_add file_region coalescing")

I'll also reply to the last patch with the above. If there are no
further revisions required, could you please add the above tag in for
me?

> Our other little friend is talking to us:
> 	https://sashiko.dev/#/patchset/20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com
>
> I'd like to queue this up promptly because it fixes things.  But let's
> seek additional review input and argue with Sashiko before taking that
> step.

I'll copy Sashiko's comments onto this patch series in replies. :)

