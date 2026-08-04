Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2B37C55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 01:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B786B007B; Mon,  3 Aug 2026 21:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A429A6B0088; Mon,  3 Aug 2026 21:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958366B008A; Mon,  3 Aug 2026 21:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6926C6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:21:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 847D5A08AD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 01:21:41 +0000 (UTC)
X-FDA: 85061834802.03.CF4D528
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 83E8A1A0002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 01:21:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BVfzZxG7;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785806499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AguyGUwr4ziCw0A1INIvfSK+5JRD4S5eHUYfwjfXhZE=;
	b=Z5quJrZZYoSJ04jJEYBDP2WxZQ/lGIJWJgFTB4KSfCSHCDwLawuUjUjcd5cpM8X7V10NMg
	W3zDsRkQnHtrMJxWD2vv5jm8mcG/e+6PObI5GCKp4a/mY95tJNXLbqRu2mNjPM7e1fijRa
	S8vbW35jSj7gG5W5XTzHwHly+OUeRmg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BVfzZxG7;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785806499;
	b=pcqM23Imk0JU272QqYQMSw0JZwXAK2SqNVIyxIUYBKFYWgFyd/xLrp3UbzB3IhMvhKeRdT
	oj5gSPz40Mstqh3rCw5vcg2QADfmuZEl1u3yMOGkTFIypCXE4nApfpqMrPkh/5S2DXoMaF
	Y+A5R/xlB+c9xa10qnhcZHLWYA0vfjg=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-527e352a167so25902481cf.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 18:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785806498; x=1786411298; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AguyGUwr4ziCw0A1INIvfSK+5JRD4S5eHUYfwjfXhZE=;
        b=BVfzZxG7FDpyt0LjFoIfcx1EJSQBYOEOUWMN6X+rwXnQnu5ZsYPqzTzDU1Q9JiAGgk
         Cqqo3iCf/0iMF4dbhFi6kXTDkmG/qR91p3G9Uz+sU93+17rLl8yH+CtcDnARHoP/PJml
         RGVwy2feNEZuXRDyw5hD3a/UvmIlTjbhsaq4rq+U85VXr26vkr94QeEu9eoIrzfQcoPa
         HOBdH+PSUI8yoG4iqGeVDEPjd7Q45WD0I+lsxyJyWQkDisjmSP2Voeg2p37V7/rnyhzD
         LalOGgPxlcxbYwDUmsy8U1/O6RzM1pl4ZPTTcwVS2JLvRMsp+mK5ZJW5MD08K7awRZ2e
         pa9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785806498; x=1786411298;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AguyGUwr4ziCw0A1INIvfSK+5JRD4S5eHUYfwjfXhZE=;
        b=SU3a5P0Sq3bnMQ7UAOrKg6qxqXy+cPBJC8jUTgY2kjcjQF+DolV/3BHlfa556BIys1
         pF7FyZPqNAaA3mG4qdEfj++xeKy5H0DMZsOK0dppncY3s6HBbbh1JvtHtGnzAAb7wO3t
         F5EehPGGnLvC1u11lsVdefLn9g8kuobFqyTl97Lc1skermxb8IMoA/DQz8ONl/iPoccU
         x7/d0AkI9ieRm7fRnWxsnNwGye8bzBmyO/Lu+4IfY4zKF6X+4rB9JYmuGz/mD+wdvMEm
         Fy4LbWsAQKs26EXk00hSuarCuveYqprKHvmftt2IbxFh1jw13fcTFftosKNu+MO5kagw
         TV4A==
X-Gm-Message-State: AOJu0YyJCyfnflOfML9PCxMakr9hbO62gzDV+OKicevx4MEypsnt6Gsu
	VSYPsIpgRdEq/AWXzGET13CXgIZGkd8xOa5xYqM/dlCLLSB0ujHHQinksI5NL5LUzMQ=
X-Gm-Gg: AR+sD12Us2gUttMK+w7ZZhM77eRwJTKt4VwjUt3ELKcFB2vopZCvF1VkQcvQGcVAovx
	HGdShc6Vfv0KMMlAGE0OGoyd0KDitRvb7TLMh8ULxGJHzcoTe6XLV0avJKj3UlChpeo2S6qCgov
	/aweAz4lmM5VyBA71IY3ULhxZFd9XYGo2Zjwn14WQKcrCcL4mRhrtsHJEVSpzXQQLJcBQEDJmjf
	Ve2oOh9x/KqMmj3siYjKTz5EiYfzkEpr2aePGmfdYHPIr68F3yQ0zYf0Hg5Atc17XeY1v+yFbZL
	xs0fEgE/blswkazaBIp50OBiT/lmau0JBsqH+Z0vRbf+9vsQuHvil4DbruBD8bCGO0hq3P/eGHs
	VY5JXyhISGuxYmpa0Q3iQtUAGQnvEwd2twi8YMy9uYtcVlajVIoCHHv02ONqyEtDMswo8+REp2E
	av3oFm4GJ3VyujLkCfex5M+ufcV2zex6q7xK9dG7FbNFBzkjKobgQLGN7zBP8=
X-Received: by 2002:a05:622a:480b:b0:516:dbf6:f8e7 with SMTP id d75a77b69052e-52b56738372mr234910771cf.17.1785806498544;
        Mon, 03 Aug 2026 18:21:38 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4eb96ad0sm72483551cf.23.2026.08.03.18.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 18:21:37 -0700 (PDT)
Date: Mon, 3 Aug 2026 21:21:33 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
Message-ID: <anE-nSqyXcG1g5zQ@cmpxchg.org>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-12-4d8dad39dad6@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-12-4d8dad39dad6@tencent.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83E8A1A0002
X-Stat-Signature: 8tagmzekmtaxq4tkfs8g9wf3mz1xcfbc
X-Rspam-User: 
X-HE-Tag: 1785806499-614480
X-HE-Meta: U2FsdGVkX18D8DafDJr16CV8ozos9oLXzr9GkNqXUh64aeX+hRGd992srn7Ice3xYnxD6+UQzyWRNMdr7Idz1nSutjNJCjLvhniWNQAs65oghMXNKsMHKEdfo2bu7GhQprNgNOT0wnRuhcbGdQ3vWVK1YX5qxmYRFiu6UtF6ePJ5EGH8sdnNghfhir5msETKbNb8u2ZkDQP3X0F3qdB/9uKXFiWCv3rlQG4a9sS0MSTiC56Vy+FyOvbazkikjRhNWuawTuMfTOJWa2A5bdatmW+UDpThfzwptEQJwsY7tbMV9Lf/6i79hDd3bLUN7aBI1GgE3LQIy1q+4eqOg2c/fzNRret/9B5EL3+J5qDtxd67PRrsE91BGYI07Bx0hT7Lbt9d6mnO4s/FbYUsPJFuYUfa9pOjZQrUceXWUVTR4TMFWYghepVZhbJc+JtfFQkNRLOY/617fMjIVKXy7LLGJ1EmnYAUwYDndz7VJen/5mEUAcXloeMUUTPvNYIeBlw2aztSAjkiFtfG4JnBsIO4MdcXqKj7DPSaL/B9xb7NwbjRd9Lfcnr21x2+l2+s5TG0sl7MMNAsLAeWSamOhQo/71cK4r4h38aAuIfu1qlb+RGZvXWfyYgBG/Ajaeea8mdvdjaGpHq8dvwv1jzw34cymhhUwuHq4nE0xW9LkwSyTGdYZn5AnLtiOOsXQX5SHZOSg4e0cgyc6lqxobAtlrbuW7iGasKdNl+2iG2Stw8K2clCjHJ+oRxaqgmp3yNRyOeRjIzN7qVY8dMMyAjo8xV++Xq9LoMbdjKzthZaTVXRmzmZ27zy0mkNvslT/l1WqALqJGXaqbj0838JeszQpMzMwoCJPUBE8jpe62AV07dgozzqbyzbq51xUCsjskxsvNeVeIWxCWxn2i5rhCkcdfjvNnev0l9bHblnK1xcFYfiEDuJGLyrOBtP5DIhsyaiEXCVyG2CWWN2qLpoJEVlYeS
 ViOWYeBt
 tXOnvdH0Hxlud1kUAtZzV9Wu7/k09k3/5C5hkWh3BY4OnMjXTuXJ2JYmofsW2vZnupWm6JYA1AeQFSU6oNbVsSWzCo7rJAg28YaFh2aEPn0XyjoWpBW/iljRJafK6rUHaKSSMgj+cPfN2Tq7nSwDkC4SsfmVozhbCv2e4VyQH9YeWlxbj1tltts4kpJl5YryEAcOebt1peaxePUQAeWwpb1Pi3OcYWsnoXUlstOhXvaPP41LZYnhj59zWWxUDOkSxoQPWmCCjU5xoNLPohFsImRCVgNyH406F2b3esw66gsHOvC8Qm/zzmXyL0skZSjIovHt89kINz5ZXIRTbPYqlMO/CFyvPr16pjoQVklfmi6Zdx2JMrpHdHfG1UvxS8SHc70/hTaTvth7I+AjhHtAKC84ibg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 03:47:08AM +0800, Kairui Song via B4 Relay wrote:
> @@ -944,6 +944,22 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
>  	}
>  }
>  
> +static bool smap_check_folio_referenced(struct folio *folio)
> +{
> +	if (lru_gen_enabled())
> +		return folio_is_referenced(folio);
> +	else
> +		return folio_is_referenced_by_bit(folio);
> +}
> +
> +static void smap_clear_folio_referenced(struct folio *folio)
> +{
> +	if (lru_gen_enabled())
> +		folio_set_lru_refs(folio, 0);
> +	else
> +		folio_clear_referenced_by_bit(folio);
> +}

I don't really understand this and the preceding 2 patches.

What is the benefit of a "shared" ref/workingset state implementation
when you then still have separate APIs for querying & modifying?

Switching some these callers from folio_test_workingset() to
folio_is_workingset()? But both functions continue to exist?

Why not make versions of folio_test_workingset(),
folio_test_referenced(), folio_clear_referenced() etc. that do the
arbitration (bit ops on classic, refs ops on mglru) and leave callers
that are only interested in boolean states, like here, alone?

folio_test_anon(), folio_test_lazyfree(), folio_test_swapcache() -
there are many examples where they don't just test a raw bit but
assess more complex, composed state.

