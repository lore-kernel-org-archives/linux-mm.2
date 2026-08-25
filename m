Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95EFEC61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B716B0092; Tue, 25 Aug 2026 12:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BB26B0095; Tue, 25 Aug 2026 12:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED176B0096; Tue, 25 Aug 2026 12:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5F66B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:26:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82AECC04A3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:26:47 +0000 (UTC)
X-FDA: 85140320454.19.C62BE3D
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id A2B91140005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:26:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HmApgmRu;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787675205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0fZPjbR+xEB7NjgLf/DwoW1nbxA9k8PLKOgb8wsBaA=;
	b=vvtut6p1xg0b0fhK0QDlHd1+0kib6R0jszj7YVPjveXw7hSd2eH6vs/FGVjOSgLjntWCBK
	PutuGJgZQtWSpqaCwsYU0VIU7AC/XVwklfT+45FYtqi4ZxvcyorFnl2twysnIMC2y6e2gO
	CA//MpTZzyRalez61JrgBvM8fjXSlLc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HmApgmRu;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787675205;
	b=V9QDjjEfkUz/FcLLE2nkz08C2x8cr/nDPRRblOqHUJPQ+xv7SnsoQakT/ZWqciUSsrR5TG
	f+I/brwRoYW1rPNk40ODjTo4NNwaI5qf9jHd9E6VvSaE9I9EYWo8XTCRZ45dgACPxwtbh8
	e+oX63Ql3rdke873N70nnFfoJOQTBDs=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c20e70a0962so768307366b.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787675204; x=1788280004; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k0fZPjbR+xEB7NjgLf/DwoW1nbxA9k8PLKOgb8wsBaA=;
        b=HmApgmRuuiRd1JubEPkbA2E6gLZ4e1LfReufF0zYbzaJ9DNYP68671geL5/vWqMCPQ
         laO0aYJncooNaBTzeJnGRzWW4MwJ1yo57uq1KYfLFPBFP2mI6LkHFeabAIMJDpRGKuym
         1xyiyaPkAWCSqC1Bc45eE1WoOPpDoP+jzvwCUCEPkJ1KcCXbXGc/Z+KL2bjpEDLgE9ig
         6FEnnO4h4LFW+8Ap/ue5wIXdwJj8qho4aVQNfdHz+6VQi+k/1D3HQs6G10eb+f67wGzP
         1adkMU4dcGZpgZn0scA2fQASKq54f/W/1CUsIDM0/UTO+h/wOxPgbQoxR6wpoo3UpSC3
         h1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787675204; x=1788280004;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k0fZPjbR+xEB7NjgLf/DwoW1nbxA9k8PLKOgb8wsBaA=;
        b=YxPfAasSq8AE1wTmRPaew4AuohAebUhWxXl2KSmJZg68IvBA3dZovdBSsu/hUpB2I/
         MgYtH45GqfXL0D3APMReqweLC7HYR1lOlEBqwvX86Ybv1puTWcs5sHlly0mUwbsmhdM3
         3Go8oTP6fn4GV0OR598apeM9SFbL/OyIG7D5V9d0ptTbaN3zFF0YxxkSZCjFhvmHNqmD
         VyOIXwALJGpH54xDw9wZeqakvwOuW6ROJ1fxuCSSbvPll2ddfrKPneTCYDkzC1f3iEIl
         fZRQjbdfHMs7aph81KEV3Ogyhl+TJfAaXDsaaRdQNSE+edl3wI+f0GD7u3a0jyemdNiq
         ZdOg==
X-Forwarded-Encrypted: i=1; AHgh+RpbBExLAyijPuNabCfMNWby7mapGuiLiYrFAHMUhghMUM50Ru2vUH0JESdwBLBD2c/nVXlThPgRLg==@kvack.org
X-Gm-Message-State: AFuF++mkOtJ8eHbdIBol34g8I1LaF+RR+bD2hrl9ylLj1REYaX3HK/Ro
	De4j/XxDiZwA7KY6LR9kC8cKFxiJX7gu2kIIzarqpFLyIHxJDoqIYEHRKmrxle61ENg=
X-Gm-Gg: AR+sD12fm4w+/EtVw1Ic2f7mC2eglU9GRSjrYh6SqpEvKyNdUygt7aMhC+DPFUpSKZM
	XiekCaH4D3sLi3p/pG6HGIIgXWRUJZ2Ct/+0SyPskjgbFiiZ2l3KMjZIgLFPxPceYU1KtPdwfCi
	fh/7WpTA5EOra3sZMnJznqXCpgTkHQP7JtZdXzZo3SX1L9nMbC8jFj7JwVNaIPgl9RXxRuMoV0B
	+pKvdd6qbZabMF2zXZYThqEvS5Wtfh71MMYOIIMILdnxZgyCfc3JjNCeM+PHhbJ5OCBnVNvEiXB
	AT7D3oJ4+3ehk8YK9fwfLHA/IuMD266GO/ctRqk8HTOtc+ojcRfo8BsPrpQhRnr91I/ospTPTYJ
	f1ApO0+JIRajQZHPLqzRIixZyVFDIXYzZv82NBBI+8iXbDjkt7jOgIfPahrFzrFHQz5LXk4znk8
	Hm0TqWHj4hep2yUtejOat+3OpbXRJZq8hzEZUPb/4vC00lPexLKzMbaI7ejy+8cTHb+07u38I=
X-Received: by 2002:a17:906:6a25:b0:c16:12ff:dc8d with SMTP id a640c23a62f3a-c246a69a22fmr4068886066b.14.1787675204061;
        Tue, 25 Aug 2026 09:26:44 -0700 (PDT)
Received: from localhost (109-81-80-32.rct.o2.cz. [109.81.80.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a9b2817sm30467766b.53.2026.08.25.09.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 09:26:43 -0700 (PDT)
Date: Tue, 25 Aug 2026 18:26:42 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Eric Chanudet <echanude@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao3CQicH0t-k95NA@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <5970a8d4-fe7c-4dde-bdc8-1c66bfb57f12@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5970a8d4-fe7c-4dde-bdc8-1c66bfb57f12@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2B91140005
X-Stat-Signature: i1hir9mwmcmt3n5y497p16peuh919pqn
X-Rspam-User: 
X-HE-Tag: 1787675205-461042
X-HE-Meta: U2FsdGVkX1+rMn+wbMv5v7vbAZsUzx2dcWsjhxNCVH/FwQi5qcUk7RgOtGt1frOMM5xE72IBaJ4YuCVKCSOxuFJ8b4FYZ2SYmBrjfQieXP7SqnG/G5tZoHHZ0+a5pAghpJPYCLFyCkBIDDjmin6Tv+P8PFdCQ+PhqsRzFjjFA36BBwEn/mCwHyNb3GOkI2jH0WU8RbwgqNxqaS3xBJC+oHOnulh1B8r8UHIYIMAW0bPoKl0z1pcSDFuY+FONojAEdRwkyuiUbiTmuWGBSvDGWcArWzsc/RPJdX7Fazx0ilJSW3cVjZ3UeDCLzNyDODu0OGc/oZ2APWWi28rG2wcZmW2ywquKF4s99yVIXVnu50amFnC9gcE/6OtRBYzaUxDA1/VrKMZiEOnxbIsSTa4aTLe2xtwgTkyS0drEKYk0VC7Nm2/wQaMaSvjFXzB2s9aB+zFJpZCAQ1F/+rR8FYEG80eL2cMobeoqi2+pnbZ7GtLBOvLoozpcd6vmFc0efwtUwUKj4u7TZmzC/WS/fAqyxTxmHHZehRiUKDgAm3sKZ6dOatI+u7V4aR6zztgw0/0P8sAGw7JM21q4LaiKVHKF/yA5S4oRnbIgGw4iIsdjGaidvsxWbZpJbw+DR9Q+Is58o762fWg4s4LHU0vLwsOT63Y5I4Ks0Tuhs10OHDkLVDEVwlf6dF2EWihbUPVdpE9AWLDDkERbvCh+gwYCS7I5WuiNRxuFZUpXnwXkPgjvO40czCQVxozP9FhrhAVSSw+EstVF+d2VfCKFV2D2JiiyTO7A5P8viHbqD0nORBxWe/XRGwZMpbytB/R1Zr1i6ILh0aDUz7SUFzos8aaeZz1Ua5zyLo/Q0caJPZ9fvnUosZDfis87+vrjNIviKV3MyJGOHhqCxxNIYgWgbJkggFjDyaln9AHsPLG+TFGg9JbXn7ORMqR3TJ5424YsWl7lUUXAWG3K74WkhrG2AQbTrYv
 l/qOEKwW
 giCZvjBXeoCmko4GEzLKVb/AL0GRhn+lCOuEM+6PkenIyRcqPYy5G2Klpu+aABgni0dyXPcUrFTZq6Xmb7ALSmFmaJQhjwMRY49jTeBa6/biwD5pynXPlJfQY+EIrFKT2TxuW2CMpGajNxPSIQCaAkQx5W8Yk1dMXZwSLArPkLSLQZUw+lroWXLbVfUjxdhs4pjmk0tFh207ZJmICfu8f9hveXU4hL4UAbJHEfz/ObnVs6bxpnhCUBhznzkgvrcAgu/C5L7Vx0WQYUXXQaXoGpiJwfmseoUQ3g14vKwo2xgugev3paKNZTbbDnNfAiW+lGQtd1GzDp62ZV0n03I35uK82LQtZ+HshwSnIQyqAS+zOU3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 25-08-26 17:45:56, David Hildenbrand wrote:
> On 8/25/26 16:47, Eric Chanudet wrote:
> > On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> >> On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> >>> CMA allocations are currently unaccounted for by cgroup memory
> >>> controllers. As system resources, they should fall under memcg, but CMA
> >>> areas partition the available space for different purposes and memcg
> >>> doesn't have a good representation for that.
> >>
> >> Which CMA usecases are covered by this work? It would be also great to
> >> spend more time describing usecases.
> > 
> > We would like to offer some usage guaranties to userspace processes
> > ending up doing allocations in CMA.
> 
> How does this e.g., relate to hugetlb allocating from CMA, to then charge to a
> hugetlb cgroup?
> 
> I always thought of CMA being a low-level allocation mechanism with various
> different use cases, and actually the higher-level users should decide how
> to/what to charge instead.

Exactly. There are many different users of CMA all with different
requirements. Then there is CMA reservations if an area is shared and
the overall memory consumption. That is why I am really not able to
wrap my head around this proposal.


-- 
Michal Hocko
SUSE Labs

