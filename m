Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71F49CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 22:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B418E0003; Fri, 19 Sep 2025 18:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73728E0001; Fri, 19 Sep 2025 18:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988758E0003; Fri, 19 Sep 2025 18:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8610F8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:02:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37A8E1DFF34
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 22:02:42 +0000 (UTC)
X-FDA: 83907374964.29.81F47E9
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 689E440005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 22:02:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jF6N+Zbm;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.170 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758319360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x5Id5wGB7dpkhFEI940l2CmgD/skMZmYSZKfxQIBh98=;
	b=SHwEbeiPU1ikO+vLqJaIKt6P8p07YfcJQBWedgD6j36e4kcwWl/qysWvA5tmzuDlHU1Lla
	2/wsmQuiH0tDbL2FL5tmdJiMq5PrGdzEpKuUSMKp1ddhuFucRCL6utnPoX4CIeyJVg7d84
	o2dE3LY0by1z1VgjsmXGnsUtK8uYH8M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jF6N+Zbm;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.170 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758319360; a=rsa-sha256;
	cv=none;
	b=hWouYdOWjkqezuYb8aNmGeQsM+ahhIFOiKk6qdGr6WuzC36EJzFOmPqEWE5wMXqdfCLDnG
	cpouUAEZi0HmI7Ur2E8fwLcPqbRxO0e/SJ1igPeDM1s6bEr37q7dCko2Mslp/Aj0b6DBBQ
	9IUUVt4yjLCCk/UwOc2IUO3YLkDDdWE=
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-4248a13fbe9so3464305ab.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758319359; x=1758924159; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5Id5wGB7dpkhFEI940l2CmgD/skMZmYSZKfxQIBh98=;
        b=jF6N+ZbmEsceyqZnCde6SIcyKa2BhXnVTBYaIjA3LENLs13cRFQl33Vhlre69CfFbt
         YTOHKZPNZY4jiR458c3usy1UggACyAaFTdBw3cPzmzwDUo3zW02vLhzJ8Qo4b877M4E9
         GgKE+g0TMdiNlmjsCxVAOBPZiH9wDnXV0AZlZ2z2mboYQM7Z4YGD/D5+4FSGaF6YU/2+
         hmZ05X5/cTnwHcGVvMfAxFEfe3L7fbR+LyQrmJRDiwWAnXBB3LPez+bMvs20YkIUAtLG
         /KzpKt3C49FbxBJ23ecOncV4Uy/W4V+O1/xgERbP975GJcownOtC8KxA6FmQ6/h2rveo
         be+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758319359; x=1758924159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x5Id5wGB7dpkhFEI940l2CmgD/skMZmYSZKfxQIBh98=;
        b=OksuKmlL/3Kfv+LXbSJ9oRB0GHm+C85M9j7k2wvLLFdDiy9BS0BjrM2rq5Rj1RqgZ9
         fNeOFzKWjgDJRagxK4jH8o9goAYimwvXV6oJ8rygOA+8BY/5wGgs1matEtXlYJygR7L6
         PzHff8VZYmxLpRMW1MD7rJv1ilBpxWupMOwf3MmKj/uUVye3+CmASeZylnpk2fGhbI+A
         QKcuF9GF3Wb3ZooQBE0A9lx6/xjzb9lCWuY/3/+5v4YdxYOqzsnGl6Q0Rp+DrzBewL94
         GJIRK4Dklt+wiqwQDoYmpVYTB6FsVnymCb2iMHjIJnbDhqQ675CmhrxMH+yh+VAN0XJP
         uodQ==
X-Gm-Message-State: AOJu0YzKTjxeQEKB+D61OcTo4mf1zqxLb/SVoEuVk71m1k3uQqwPEEo/
	3Arr/Q34rHM1b/Sm3RN0C7EHORorRmXGMawuZ3t0No0Ke8Y050rfjuhocHlR/baQNUBSjTVIS7z
	+vYbiEDEgMkysf4AUNRCasnkAYTcLQfQ=
X-Gm-Gg: ASbGnctGBHsFEioHLJzbLAZBg9ws1AfTMjCQTqLUmh3GgkBsW7MjJbgHj40o9e4rlzP
	O68xlZip0N6ryki21dpfAW9qA+Kpt5ZcQxT2q6vCsY54Dz9SAar3COMusBOhvpM57G+xdcY5NLJ
	3NkVuSxP00I8Yc/6Y9itSImywTXHPTtOMlwVS754iG7dSCKyPuIxDM8LL4QSy4Vyp4ch9oLR+S+
	eermwPnUhn0p+c4oQ==
X-Google-Smtp-Source: AGHT+IFM5GLBoUwaZWoQawNHl1XfRp1pfGc4zEljqu3MNF6RpQambzopKw5XcNw4vl8NYisjSrCRP7nZVEoIyXM443g=
X-Received: by 2002:a05:6e02:2284:b0:3f6:618f:6b2b with SMTP id
 e9e14a558f8ab-424819a5b2emr69998805ab.28.1758319359279; Fri, 19 Sep 2025
 15:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-7-ryncsn@gmail.com>
In-Reply-To: <20250916160100.31545-7-ryncsn@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 19 Sep 2025 15:02:28 -0700
X-Gm-Features: AS18NWATtLtk3Udf6AWX0hA3ISCJsnaM5uh9xfLOx1-KkSR03NT3XlEQmdbBzJg
Message-ID: <CAKEwX=Nnj63_VsNDtqAWuxQC-GHPQNbhSMbWk9za+PR-dhZkHA@mail.gmail.com>
Subject: Re: [PATCH v4 06/15] mm, swap: rename and move some swap cluster
 definition and helpers
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 689E440005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: kf35y69pdh6creje9r9bxgbt7agpfz8j
X-HE-Tag: 1758319360-842777
X-HE-Meta: U2FsdGVkX185ZyYkCG8RWpIfl47idkQMx6pdxW3ZA/ZhilYJYgqP8PblhW51FcR1RZghLxZJrMx1dJk94Vhb0qtxxnJi0mSSzJKJ2WqTkjRvPK28zIAdfq7weQGqdWPM4L/oCVJMVyN3CJ5kVNh0DYSNmICzfJSy+8rfBMHsONboOQ9QeJs8HwhONcXUuO0qoKrcj7qDOKavW7HglVsDepfvMwBH7kvfhSUUDspHHi3FSvEaEwAIUpuuaaGqwG3AjQc0JltKjb4vkVRceVLSK/2lHYhePTHyKRq1+DeX1jW5MV+W9yeqrN6gmj6kr0A5zAdha5e0j9fMosHDNpFaj70mq0Dp7tCTPNO+0uwWGPJsorn5VB+TC22DEScZVlQ6vWugwCoKLJrnOv1nln029rmQj4f/1knnW9m4G6H+FPFoujSSpkItCrrtm9IOKUuFXAizF2QfIO+UNODeComR7zekrLDGXTE+LxTtCWrq2/IDj3aIYeFcMHuV7JDCxBhUFpffEb7X5Kz1QEIDMXDERTGului9XeGBNImL3l1N59Ct5Tuir90uRVR48waQ8RpNDdTR+xjGRyXDPxENCUXRy+XhqadB9sYq02bQDj5NZkcxgHBWyBqJtpiglcSuGFS9uY7H765kmpZkyJH54pOd5W9i3LFbcEyEDYFZOW5CrefHwl+odUDGHKLfjTgofjG4SV+8Jssz55YpBiilW1zGyoHz3nX62Smf1B31hVA/z4BbH9B6jMBEW3Ojlxh9h4nrD4OB5lCikkUDyThvpahV16+e/JhKDmzaZ+zg0psfNVO4ptP89ILq6SXmEFwaOUc+f23bhWc1miCq4gTIC6UcbGEdhICN7pdrDpaJ5B2Ksx94O4IRuyw9w3T/Cs7V670gJCCJRUdrmb+w4IQQWRr7es3UjHu+Xyz2L6IJT+uwg0PDnrgJ9bd5duhEbTCwa4r5fPLxd2H9Zft79a4Af9A
 +BuksQfC
 nA2q1LjYuz1SLc3pGnuUpYk6P04sKvyXgGPsmlM/lYM9Ljb0ACszsB2LJOIAyYA7py0fYdEY0k0PQvFxcfjl6dOGBJNCn0P0Snpioi66taJGCs4OHH5vNcBVmLD+uVVuyFijy2eo8kZAf3CPpKgbh0stTpR49BSmOC92HKJeQpramgsoZjuGIEcvhxYvSg4a5KXl1nENaDwgpc1GcuTOueerJ6Ny9UhSJN+DFf12+etVLZgf4TOJqxXXUoxSKL+5ZOI1/OIbuC7kzwe3pz6+XECpQWKUxJ/mShg7TCnTJkdGprMTdj4Uq0H57/6y8eflEiNe1p+ysowDQENuUoYmBk8sqX+oWwCU6NjyUDKpxEvHPqAw0IMi7LUqfN2W7KGcb1nGaTw21pGZWpisSG7JEb9vzPGHoUHuqeB/b+lUxZ6YcFSPlnFeI0C7bMw4BwOuKk/ueIkn+18ccBJRZ7bkh/9HLcO1a6srqoqMP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 9:01=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> No feature change, move cluster related definitions and helpers to
> mm/swap.h, also tidy up and add a "swap_" prefix for cluster lock/unlock
> helpers, so they can be used outside of swap files. And while at it, add
> kerneldoc.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Chris Li <chrisl@kernel.org>
> Acked-by: David Hildenbrand <david@redhat.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

