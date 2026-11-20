Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F84606A337
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lJmGkPQN
Received: by kanga.kvack.org (Postfix)
	id D5AD66B05B5; Fri, 20 Nov 2026 01:52:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0CB76B05B6; Fri, 20 Nov 2026 01:52:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBDB6B05B7; Fri, 20 Nov 2026 01:52:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE9E6B05B5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:52:49 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A6661A0D20
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:52:49 +0000 (UTC)
X-FDA: 85454579658.23.51D54E2
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1FAAE2000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:52:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lJmGkPQN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795157567;
	b=Wr8gbzgKoF+V+uHXHHYEqeEVjAq2LGYHLvgZgYmQJ0jSspKRMAS5gJNTI1LSa2aHM0Y4kc
	0l6BiZqMF5FfYwq9UHmgXusoQ50+xdKGKFq/1Rl9PYNnu4ZX91t04+yBGOQCv52A9kpk9M
	2ND6AWi+9lU80qn/SMuvCHAd5o5MaBo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795157567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2X1sxbD16pOIjQDxmX5fcIE93gciH00EyIBtJDwIOc=;
	b=q8nBwQJ2l9/DHIBN7APdEZynZ75qox3OZrI2+XgDwF+BqVdPIgd8OPqm9B3Wcuy1Mv1XWb
	S4yo8wXLiY7eWAdPwWK7Sw+fRoEtqSwfFt3zPidL/6LrfGhAb7H/+G0iuqRszBFyWDAkbQ
	6Nf7phg1BilRH4DahhEXnXhCZUMkNss=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lJmGkPQN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so3825975e9.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:52:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795157566; cv=none;
        d=google.com; s=arc-20260327;
        b=MIuw4sN63yjJYtlgYRcv16xEh0z8CIyILYWXwtxI8tDPJA/yBm2T3iZQJ1jYvzStkj
         Xo+zLg5RQHZsJmPm4QDnquT5KI1v4GlwlPgL4+mn+g1rhEC0Ig/r4a4uhwspA6OpquG3
         uFuRDsVTomDmjuw7wT1fLFK9kSem45E1AUHOs+FZiosIft1UZZ3GJv3TrKQCffqNEzN0
         debL+nKzWPcBcZc4XJbpgn/uNWfDebS+md++t8lq6ldlJm41gUt686t0RTdcv7tTELzR
         Rsca4qX0djDLPx2gi1dEjFVqBQjAnu1HXWp21BuQwtDg36dfvfhZwwmlSpV21uiF66vL
         ZWiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F2X1sxbD16pOIjQDxmX5fcIE93gciH00EyIBtJDwIOc=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=Sfzomyw8XykoQqW+vWyy0uuoplqAwXxPcGieCYbRVBqrtfoZO/tPLQkaQoQHAZ7qNO
         FypiE6YdGcvDE0vHGDfGSC4IjxGo+3zfnhRPrOIupmxv41K7fF0eBI+9vQrYv228dnDN
         mQGwejAHQdGyRHa/nFPGqax2icAeCdpoWX2V21QFspP73pkHQw0q9mgLFskl+BoQSeUr
         lGTrreZqBJfQP8boW1zS4NPZ2j3Eh4chsUaEX78QhHTvYJyhz48pK00H1f2xO9ySzrqY
         teVgteZx4/DNLGLhyo1YGCdQww6Ls4dCmqMrvkFuVQyjVcmR4eAQdYLDPu3c4HC6daOQ
         trYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795157566; x=1795762366; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F2X1sxbD16pOIjQDxmX5fcIE93gciH00EyIBtJDwIOc=;
        b=lJmGkPQNHtWnMqX9bScEwUlLX55iNHhmwjz+T1Ct3L8euV/Ybri2qiw0otCNfP2Us2
         8f2+9OaUMMR72upx5A8W/ohVdTT03IaB1c72I4oVChOALyemH3PbgOZqCKUR53nPsK6M
         oXsesp8bSwD4fIzgXbsqnpZl38jmkjncbQBrKygF++4W0QJTh+cMI0U38IahfQv81Wn8
         yCHkT5jSw12O5idN5jZSSFQuS7jDSiBUOeYLkohKS312gEpMG4YIXtVBnlYoAG2XFATS
         /WOw3fMA1Tk/L3s62fsSO7VYzj94JxkgLmhNyDy8maD0ZTx7dJrM8MzrE9BzcnLzmX41
         sECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795157566; x=1795762366;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F2X1sxbD16pOIjQDxmX5fcIE93gciH00EyIBtJDwIOc=;
        b=Ui0REm2xtdSh1foMMaAYy0ZKSnbjoyfSN4Ypx6dLfm/wVkTmseZHi+1Je/HgqW/DU9
         pzqCx/AfMVhGavoQXc/km3hqD+jLoyR3jdF4BoSfOVUJ5bfP3dLguVFvGk0E2wm+BAzg
         VskRKpCR334pAbXC+DZKpxN+F4N44hVsQVa82mQPEOikW9Zg9Nbb60mpwXKUuP6mYhgH
         h5/b2Q/6rTdaOYgum+dGPytwppLaLWq2rtxRVyVH5TlI71sQN2bCi+SQHpJR0iqUFJHo
         QfUHfbOw4sJxjEAazxVwKSOsnmJIt40YG6NdWv2yBgOaxDRy6lDFdLKG9MZ5l0Jh7+gs
         ql6Q==
X-Gm-Message-State: APuU4Z8dpikouQCL6DoqqIbDRgsUIpQdY1dU+b9tSEFbzruiWcunPDzS
	EP72CkYwRlVviyV+5AyYeV1UKAvZ08/cnzXEyOgARI6WONNBbshxi0KouKRuhXwETwi/SoHvlvh
	zgrhf8qwkyoUGlnnGhzpW9b94DB2t0mw=
X-Gm-Gg: AYBFou1FjWRXORyEwP7FOwvzMjlYPsKjXruj6xYP32sJUCq8Ov/7pKWO2e99bsU4Cdv
	ycd/gR89Ug7Fq9YNETGwvHRNMWjmDWgmn8XmWtK2bhKpWIOigtZlxCaBwIiTh8k3JEZH1wh2LG7
	7p2FTAtHi0D862/vJKM5Nm1c+xCIrAo/UKLbALsy8a/Zt4ITWB+eFj+P2K+aDXHWmX/q3l3Y459
	FOwXDSSjPAjFU56fiul9schwVbX5FjwFPXkDc87N/IJxaVb/sqAGvQekhAIx1EZBZZkdu73vfwr
	1deNtHPASzTeL3e0BrxXBmrCGGc258tCMZ1puLWBw38HBMjh0Y3i+WUYv5yhBVT/ZHEUY/D/hlD
	Ci0Jb1xlH+0STpk5Y/CIBsuOghUxlQ9cOAy8zp0aVEru26e9viTuxJYQPbYlYkXg7Hg==
X-Received: by 2002:a05:600c:3b8a:b0:4ba:761:c0c5 with SMTP id
 5b1f17b1804b1-4bb8880f0e0mr43956385e9.5.1795157565119; Thu, 19 Nov 2026
 22:52:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 14:52:32 +0800
X-Gm-Features: AclHuK8u9ADIpuCbwIFublehlsAz2Sh82b8gcTYOiMH_psNdYRsQZkiWsXcTuLk
Message-ID: <CAN_Opa_h083WMGuehgFLYb=Rc+Kd3t3JdPiG2xkEw_+digwQyw@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] mm/memcg: add folio-based lruvec live helper
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: 1FAAE2000B
X-Stat-Signature: 98tzosa93r53annjeipkrp3xwtjupqyy
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795157566-344108
X-HE-Meta: U2FsdGVkX196SCqSHMkRyCPcRr60VJ+QNQzdPMS4n9hlAjzRPT/TZxaj7vXj3wLgOsxo4e79ZU7M0ClYNEMyQKlCTrP6/4UrAvUzl3FRlr3Qtni5AnxoMQYtv3jKob0zyQLaGn2KzR6B6aEvYP1Mf5Uv0VAk4D2L6F93jNMFREMJscyp9a/tcCzjYgqBv2lNMBuZ8Gj1pl+s5PznbkRGPgo8hbKLmwbvsKVndaZj5wlMneuj1j45qx74/GvfTZdAKTX5J+rfakNeUgLYf79xdNU8f33Tp/CywoaL4ajHSLCXukEDesKz0vzYy3WOhlxlaB1ttq7F+78ZtJ+1wGO5TPWoOdtJAcvYMCIpwkuyKIM0CK+HucLrIgy0vPq67wMYz5ZsJioCczu58Jplwrr65IV4PkNBdOnRS+wYd3dGHkjGUIlQle+PPzSpwNSt+tEQTMqLQhGFVzUmcBUcQXyHzKjZVW3lBF6vwuZcfplrd7Gg5vwUScBO68Vlc0Ydnwdw3bGqZT0RtNvftYBNXx9eB9GVYqqitInFSkSYGvZKAzJbMX+FHjG69BeEs5aPEoJsA3Qi+vWKO2n86mi5Be77QT8uon0oSbzb5N3PGIMvWY1bim8YZf2MduupXTRrFWJXNBYYiOq9zy+GHmBRflZYSsfyzar4eqofeC+CqY0HQRYK6+KM+TD9/2kOOdmX3d6mQMjoE+T0RPiByW+uxV0pxIK3pSxYWXcjb5isqcqorNlmrD2QK5FcGoilFI2BaKVDvyj8awNy4ihFN+JWteWTHm1oTiz44M4HYSfqn8OjPRc/DT90IRJXLs1cQrUPsLAM7zolK36tyzvY9+zoPXZRH1ezyLwaxjLjtP2hh+m4C5lJ4CcEmrsyHewJ6VGlC5vBjjOYpKHM56JPXIDpKSUOvHrccQFC5qg51McVAAV8Nl++CIvbmvIZqaAbLgL3INPfN7rkAzpva8YTCE6jBPG
 W8Pyxrrf
 VHEVxAaixcD39P2Ysvm12MGOlUQEjwNHW8zUHLnqxFTdsxW+arT+mhbDUJEAMgAMQyxmoDS+CDmKeq3+GTWiBNsn8KwJ0L62gDVLrm3lqBt3ayttzv2mhq4O3wo1t/F3rAWRTWBYo/vuBOIElar7iaOt5/XaVV8e1EIsJNklcTdyXAD2orhl2b6ebTn/BooQzEMYUVtwJeoIhRd0JW57YDqWeYZCEhcb6Od86rg1eBBkAVOraZIioHMD+EtxKPAfuYC0u0qpC2xQvDBs72rtV4z1haXSdbHjX5QBpTSnasnKEbK+wYhI9l8f2jc0sBmYG89iwiTEoqrji3Sz+H+Sf6jwFcSNKGwhGVFGjHoRMO1yPyLiv5noYemzy+5wYe1/ptWURpyj9C7GWhPphcyn6yg3QtBwSHJO7eKB8fS2Y5pyEoTf527K3GltOQMLMd13Iitgd536SNPF7xIDXWYNEUksxonulAewIKnepnN9h/HVhUFO01+NsMuW2qBYnRJjJr1BpMU7csZveAH1fG/8iJfnXVOoujqZYwUKVyCWsYiE4Vv7oyBGqRbmfqNZhUVWbWeS45Y8xoeI+2X38l4GPayPMl5nTVF6AqaUz09pfEKEFeQhgk15ArTNsMWBXjg3Otb445DCXndNKe9iAM/bmC2CDzyZuBYBHqcNSbx/YelMP6kYbpmWOr/gCDDDxmYUBHE+xjMdyf5R9J3Z84V35Kw0738Hfig2p4oatV/bRfbxPJi/SLPyDhIWZXs+ZSK1djRmRAL3wnnhKJ/NNZGURPPgmC3REZWBgQaD05v3phDp6thnlW6cszxLZPNHrT9DjGdNl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Add a helper that resolves a live lruvec for a folio under RCU
> without taking the lruvec lock.  It takes a folio directly so the
> lruvec lookup happens inside the RCU read-side critical section,
> which a lruvec-based interface cannot guarantee.  The first user is
> the lockless folio_inc_lru_refs() path later in the series.
>
> Factor the ancestor walk out of lruvec_live_lock_irq() into
> __lruvec_get_live(), so that both entry points share it, and spell
> out why the walk is enough while only the RCU read lock is held:
> reparenting of a memcg that starts dying waits for a grace period,
> so it cannot race with the caller until the lock is released.
>
> Move memcg_is_dying() up in memcontrol.h, next to the other memcg state
> predicates, and use it for the walk rather than repeating the open coded
> css_is_dying() test a few definitions away from where it is explained.
>
> No functional change for existing callers.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----=
------
>  1 file changed, 56 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 980358bc6f49..441a5d57e723 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
>         return !cgroup_subsys_enabled(memory_cgrp_subsys);
>  }
>
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> +{
> +       return memcg ? css_is_dying(&memcg->css) : false;
> +}
> +
>  static inline void mem_cgroup_protection(const struct mem_cgroup *root,
>                                          const struct mem_cgroup *memcg,
>                                          unsigned long *min,
> @@ -1349,6 +1354,11 @@ static inline bool mem_cgroup_online(struct mem_cg=
roup *memcg)
>         return true;
>  }
>
> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> +{
> +       return false;
> +}
> +
>  static inline
>  unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
>                 enum lru_list lru, int zone_idx)
> @@ -1510,28 +1520,41 @@ static inline void lruvec_lock_irq(struct lruvec =
*lruvec)
>         spin_lock_irq(&lruvec->lru_lock);
>  }
>
> -static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> +/*
> + * Reparenting moves a dying memcg's LRU state to its parent at any time=
,
> + * so anything added to that LRU afterwards would be lost.  This helper
> + * walks up to the nearest live ancestor while the caller must hold the
> + * RCU read lock: reparenting of a memcg that starts dying waits for a
> + * grace period, so it cannot race with the caller until the lock is
> + * released.
> + */
> +static inline struct lruvec *__lruvec_get_live(struct lruvec *lruvec)
>  {
>  #ifdef CONFIG_MEMCG
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>
> -       rcu_read_lock();
> -
>         /*
>          * The memcg can be NULL when the memory controller is disabled.
>          * Otherwise, the caller keeps the memcg owning @lruvec alive.
>          */
> -       while (unlikely(memcg && css_is_dying(&memcg->css))) {
> +       while (unlikely(memcg_is_dying(memcg))) {
>                 memcg =3D parent_mem_cgroup(memcg);
>                 lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>         }
> +#endif
> +       return lruvec;
> +}
>
> +static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> +       rcu_read_lock();
> +       lruvec =3D __lruvec_get_live(lruvec);
>         spin_lock_irq(&lruvec->lru_lock);
>  #else
>         lruvec_lock_irq(lruvec);
>  #endif
> -
>         return lruvec;
>  }
>
> @@ -1561,6 +1584,34 @@ static inline bool folio_matches_lruvec(const stru=
ct folio *folio,
>                lruvec_memcg(lruvec) =3D=3D folio_memcg(folio);
>  }
>
> +/**
> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> + * @folio: the folio
> + *
> + * Same as folio_lruvec(), except that a folio whose memcg is dying is
> + * accounted to the nearest live ancestor, which is where reparenting
> + * would put it anyway.
> + *
> + * Return: the live lruvec, with rcu_read_lock() held.  Pair it with
> + * folio_lruvec_live_put().
> + */
> +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
> +{
> +#ifdef CONFIG_MEMCG
> +       rcu_read_lock();
> +       return __lruvec_get_live(folio_lruvec(folio));
> +#else
> +       return folio_lruvec(folio);
> +#endif
> +}
> +
> +static inline void folio_lruvec_live_put(struct lruvec *lruvec)
> +{
> +#ifdef CONFIG_MEMCG
> +       rcu_read_unlock();
> +#endif
> +}
> +
>  /* Don't lock again iff page's lruvec locked */
>  static inline struct lruvec *folio_lruvec_relock_irq(const struct folio =
*folio,
>                 struct lruvec *locked_lruvec)
> @@ -1826,11 +1877,6 @@ void mem_cgroup_node_filter_allowed(struct mem_cgr=
oup *memcg, nodemask_t *mask);
>
>  void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
>
> -static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> -{
> -       return memcg ? css_is_dying(&memcg->css) : false;
> -}
> -
>  #else
>  static inline bool mem_cgroup_kmem_disabled(void)
>  {
> @@ -1901,11 +1947,6 @@ static inline void mem_cgroup_node_filter_allowed(=
struct mem_cgroup *memcg,
>  static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *m=
emcg)
>  {
>  }
> -
> -static inline bool memcg_is_dying(struct mem_cgroup *memcg)
> -{
> -       return false;
> -}
>  #endif /* CONFIG_MEMCG */
>
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_LRU_GEN)
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

