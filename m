Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B7EC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA2A6B00B0; Tue, 22 Sep 2026 11:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AAE96B00B1; Tue, 22 Sep 2026 11:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3728B6B00B2; Tue, 22 Sep 2026 11:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 107376B00B0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:43:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94D0212050D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:43:46 +0000 (UTC)
X-FDA: 85241818452.22.3E1ED37
Received: from mail-vs2-f43.google.com (mail-vs2-f43.google.com [74.125.227.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 79E8580002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:43:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cb5yhjV5;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.227.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091824;
	b=NApFg4H8566JUGU0C3Di/1BOKJtwQZG1P0I+kuK+bVhPTeHfvsLo1pMeiR40imTvfvel7O
	r2gU8W3aQzp601Yfol/pTGg8MVbzJmIbn96pP5x3/xKIctUoCuJcHyHOyO6bSgRQaAdKnj
	yurokb87x/8MWXvzzDL2M6BjdjXRWLI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cb5yhjV5;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.227.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hchzYvXQvWRzwu0eETo6eP63WqkiRtXrdlRjjzPyl40=;
	b=P5mmD8r7DkubMrLMgwy3zcuXCO9ckezHv99Gam9jc8Om4DIDpLAcUQLlApdgfMphdNZzNb
	IrpZytz8eq24gWD5i1iIAOQHL1NfYrg1/jOi3qHOl4WpZhl0WDw00bUZX3uB+Q2s7bj/aQ
	VEcA+gTy5YcZHnegtUVwydifusiNpFQ=
Received: by mail-vs2-f43.google.com with SMTP id ada2fe7eead31-785686d2764so914210137.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790091823; x=1790696623; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hchzYvXQvWRzwu0eETo6eP63WqkiRtXrdlRjjzPyl40=;
        b=cb5yhjV5DT5zbQulYUg7o6I98w/43gLbL3HPUcaXJUFb76Kpr1dbL6i2WjnjGhBXi/
         gBpeg7uDGh9AVLrb3BppTOdKO4DNaQLCrcANiFZbc6SMs0fh/jX/nZFyw1o8YM+ZU0uj
         2Ac0ICrRaa+a3g5KLXChq3KKbEO8PHe5ptFBNVekHpm+Okvj0m3pG9kmwZsvmo45QweZ
         rgDz1Nl+FqZNW7daTzFtFoDY/9USi9yOiEczD4+noatd2KKHXtblN9qnK7FFd0MOgk2R
         dYSqV6YFKZ/ha/BZ/9YI/O00fXkIDBpjYX6y7nTtTJ9NeNusjhWYPnPcHqpJhDDfHt4I
         ZIGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790091823; x=1790696623;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hchzYvXQvWRzwu0eETo6eP63WqkiRtXrdlRjjzPyl40=;
        b=gH8W0MG5qN1zA8UskemhczTBxWOY7oIklG5wZlb3Ns7EY8HtAtTbqoWqr4x6tZQGsn
         eHIO/92dMAfNksQQ2xhrzif5Rr5qAFaVTYYOvshqYGqU0yceCDQzzU7IaJZIKgXpHdU9
         5AmihNvPW4ycM8k1iE3boTiG4eyv4BF+q/cxErNe53Ce2YskZfjgpUjGhP85qeDDSy/J
         dJe3jbL8bBKfolOWcTDDdg/76nz2mpVTt1PWmlOOQC36zBys+KgSaeZQw48suuhDv1s2
         HVK/HJn87h9AxetPX9WqWAtrdFp92uShjJmJ4tVpDWDkpsTd7AiOJxsMbKfPeT/juOYj
         QNGg==
X-Forwarded-Encrypted: i=1; AKwUvBxh58jeSAQi9FyBHW9XwMEgELIml512kEZNYbaeu1fAblLayJEtyObMFIw+B5fXARph35s+p2FzQQ==@kvack.org
X-Gm-Message-State: AFuF++n1EiDMO/5VfdY3qtiPJmmBFcKKXMYelNqtSdE1EOfsvcMCIQGb
	QCd8eaLpM/3yPfqjev7P9d/WnJH2JYkueQ50kQUYuxDVtudQlgoSGK4lP8Q+7bmYbUs=
X-Gm-Gg: AYBFou10DmwR9E6V3jSUe4QUa2+joIif7ZWd1+GhBifaWLWzyx6WcrDl913vr/XPn0o
	YSY5tLHs3wLz/PgH+UG0HEx42m98lXz+I4PASlumTkqh9mc7bxeoIMR9vPZD+e6UNFEXQyUirUN
	gSTf05xvvHfMZ/sY+e/SJ3t3wpater/QZ+aZNQ2WI/692nRT2AnYSyDzcuKoQT6ronzRbIQGH65
	4WC215MQ2MEyg0gWK9yyIkygVToxZkNlfFq3LIyhjKjU9jK9+wp6hYkbzH6782ZJY1XcTPmpUP6
	YF6d7LUFG8vjKamS8vnQ3SlMIiokJCv3xsbAOVZC59UoX7sroWZuXB3J13FamshJoqPX4Ln6NXE
	YJcuP03Id1F9w/2BQJbrMkurFj9AuWmMbcOCR0A3UePNy/53YXxn4XrU8WLZA5FziXm1j9BR1hx
	qnAlyAJOH8XMpJ6H2+a0ZXZE9Cp07tdPmG/6IO3QEbxQVITL0uPOLSZey8D+M4LGmM1N74
X-Received: by 2002:a05:6102:81cb:b0:7a7:3485:3386 with SMTP id ada2fe7eead31-7a734854c44mr4067281137.24.1790091823401;
        Tue, 22 Sep 2026 08:43:43 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-914024f12c3sm19388516d6.36.2026.09.22.08.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:43:42 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:43:39 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arKiK06mfWTw9I9a@cmpxchg.org>
References: <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: p4yba81z3sz6pxdsrbffx5yg5tzqqzhh
X-Rspam-User: 
X-Rspamd-Queue-Id: 79E8580002
X-HE-Tag: 1790091824-221245
X-HE-Meta: U2FsdGVkX199PyYUwcaIvI8O4p+X1/ALBm5OHzW8uclx40SQozXFofAPLT6ItqAaFKGCXRPft8aTp6JH08YNKkuzIn6QBTDLdnODru/UJy3dL8KhN6caGLBa7Y8hdnHv8E0jG73UXY2ryGD6jr6pmlyNmLP/OdU+aNveW1cdd6OnZ6V3TKb53Y/VsYoQ2TzOla+P7mQXqkJfGT7XbYZDWHm1AY68tAk+zLzSYEynmq/Ouc5OdJNuNufzaUnTDlH5hHP+Go1SNBmsU/Is90edLsR9VwEXFMIAMCgLOGhD6Th3KzEtXtv+Zr2BVOd+QUkQKzR/nvUrv5n/AMauyk5gHG0NS+2CFOd9qOHFWzuOBQSBOUSqppyBb+0pz8vwmOJHtA0Cs3Rh/PH33za8Ug/ckGycTTr0GeeMGCqLbH9oRBk7Eh9K/F4WaXvLoSBvhmyjx4WlgaRuFMLOLm1B78wFWdIhEXOF+kKIlW4DRGTRxDQNhPvtQPRXf3HvyJilTgS2KrLwn/UxsALoAE04HkShVyrwH4zeDxuRbcQBe4PRWarV8/8d3ORybuu4AAA4yaIQEg/qYnGzJIlQKrFT86CQjKJZFDFJX25gfYEVtYRUBBJMRAZgHKds5nDYpmarMA+eTT3QYSpQlsQS3x8PRep+TJfolqcL/JkXnExtePy3DahL3nKx+O94I5evwD8jEL0NoKq1NrVGqB+AJaJ+V7d7cqh0W4UCT3iZ0OIZOle6FqBOCpukgI/zNvW7R0rem05aua3ha8XwUyXBgYbie6pNRlEKqS5duMMoy6Z5of0ttkSqI+g1BPioAOSAHbotMSbOgvR+uyXzFcHjWVf0AL/ZVjIOaGq1B+75sBNxkpUNcxuLC46qvQm/Hs3Kwp8maUzTyZlMOQ5psuBd0OCblUUjm/75JxBRWHna3TpMk3oZ/CtdhDTTmHeG3JsdR1TlllLmAwEKEgxmPxve765XBDP
 ttjyQAEu
 w/1rsEMKvBjgyf8thDOWnDcOZFXQcWAQnjpZngL6sFpVGCAiLI/KJIlcykFxa7yxzc5cx5Vuy2bIK5OVCtzQsPTJ20BbvC4/KWkw67fuJew4XAI5ugGt5Fn40R07960YJVRIYhbPV/jyhKHjPZO5RlZJpOQ86sc2tFyle+Z1u9kpftKDyRHaRxNgHCvyYSaBg6kMPt46ITQc2KsSmLGmaopoeqte6VPuRUuY6/ztqLvcUsK4HwYt0WHqEtm8EdXsOZrlUousN+SejiwTx1bsI6klA0oWEqzTrucJ+s7q2jtiBrDZwNK3xJ9+Of0/ZMIaW7kOAkJtDoPKOywBvM4xGs5siY2zDGzRH8XnuqG2C9pAxg2jIol2fxU4wGBsblVPn45p7S0AlsEvbBGdMpwpdUTbv7lQ0NBgVYUbK7svC1bcmCKprQ215v9so+j1PF55Vs8ez+NH8Azb7PAMOvqvoopBvlGLeRwmzSs3vITeCTNDNYAitd4Kf7wUSqK3BPqHgu/CE22jxCqcxku4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 05:23:31AM -1000, Chris Li wrote:
> In my experiment, 100% is already way above that bound, which is why
> I'm curious about your data point. How do you run and test your system
> at 100%? Please correct me if I am wrong, but it looks like you
> haven't.

You're conflating machine size with workingset residency.

Rik showed an example where the compressed set was twice as large as
the anon set, and it worked fine. And why is that surprising?

We know many applications have long tails of cold pages. Idle tmpfs
files and shmem segments. Things that get rarely used. memcache style
workloads have a small, hot index and a huge data segment with poor
access locality. Even if large parts of it are in compressed space
that's better than storage fetches.

Your "this will thrash after 7-10%" is an average based on common
workingsets that are actually hot. It doesn't mean there aren't cases
that benefit from much higher overcommit.

Why even get into this? Why even try to find some universal limit on
something that just costs memory anyway, when memory containment is
already a solved problem?

