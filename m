Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5800F8A145
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FB76B008A; Thu, 16 Apr 2026 05:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2169B6B008C; Thu, 16 Apr 2026 05:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153126B0092; Thu, 16 Apr 2026 05:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0570A6B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:05:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7F30E47CA
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:05:17 +0000 (UTC)
X-FDA: 84663835074.03.AB502A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D93DEA0002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:05:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LcWeFcnc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330316; a=rsa-sha256;
	cv=none;
	b=v2uZoQ6SEp1zq97BR3HHRjIGJGj4fxSKSAtrLwARh9xkfJS6VmBB/2Ga2IGgdjlq47fW9c
	ndVOcLowHO6dS/Xg7wCeet7kPLuyWCKJdNodSGTLDzFsve0op4YjPTX/Zq+ityuQ0/LhJQ
	gqfFs56+ic0FttAgx43ud3cAoF7ZFP4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LcWeFcnc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBDsRUuMGhTc1NAeKI+5vxXQ9iIujjveKnsUNxxcylM=;
	b=rq6x1YNxHq/Gx5rcfDXxjk1cV7dkcgVGGsOiV0zBx63+fIelnxoYpTGV6WpPZhVWyQhutm
	j9180I0fCxHNiNAdEOBKVIpmVsG5WKv0hi26W3MznZdIsS6DaW9LQBzjqxpMCIrPvu5B5X
	1Pk768dVXT8JSld+TTxU/vcvb6CIfR0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5C6A4426A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6596C2BCB6
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330314;
	bh=lBDsRUuMGhTc1NAeKI+5vxXQ9iIujjveKnsUNxxcylM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LcWeFcncx61U7p1+yKL5NpfL++JeYoYRjLhJiUyYhVpdqS/zABlrUxS8F8UKOhOh1
	 bHJX0oOpn7nd4740DYLgIUHUYYcNG8ZyLez5s4+MRvlYNV5hl5O0JROlQylzN2AxYk
	 PD1krnaY/lRRi+sDigUuwlupLH+S+/3yNmkKwp1wAyHUVR/vRuA1bUXw3N99HTbmXr
	 31lDmAlfodk6RSapYYyo1EkAQ+lP0G0goSMI7p6gkX/Ohv4taHdEPZNtyZ0LmPTIB+
	 Jmem8q+5sYhXobZbFyUODmS8TBkMIafPmsevZwb6o9sfyUMlce4p+LIlzxFfeWG26N
	 tUIe1LZNjp81w==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a08fa355a1so106635866d6.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:05:14 -0700 (PDT)
X-Gm-Message-State: AOJu0YxAS7yZY2GAh+EM62yoQuWLXiGKXM+FZrJr4mIs8yunqb8wC7y3
	PiEK42JF7+Otmjh7PWplDKf3ZXi7t4oMe0UhrDIgXPUZCC1rWxiKDYzT6ASIGEpS+TJW5pxhneC
	mOrkZqkqXo/TCULZHdxfHiZNuX5WhCIA=
X-Received: by 2002:ad4:5ece:0:b0:8ae:66cf:423d with SMTP id
 6a1803df08f44-8ae66cf4357mr127506276d6.18.1776330314058; Thu, 16 Apr 2026
 02:05:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com> <20260413-mglru-reclaim-v5-8-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-8-8eaeacbddc44@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 16 Apr 2026 17:05:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yG6OajifpBMJCsxLY30scoE0YEsrVSAP7WnhYsfE66XQ@mail.gmail.com>
X-Gm-Features: AQROBzASHcdgacejWAY7DLHYfWkOHcvbPhd6TD15rHsqXg1dPxd28jwuhtKK-dE
Message-ID: <CAGsJ_4yG6OajifpBMJCsxLY30scoE0YEsrVSAP7WnhYsfE66XQ@mail.gmail.com>
Subject: Re: [PATCH v5 08/14] mm/mglru: remove redundant swap constrained
 check upon isolation
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D93DEA0002
X-Rspamd-Server: rspam12
X-Stat-Signature: c1cqake88ahmnbao6g7td9apohat4i41
X-Rspam-User: 
X-HE-Tag: 1776330315-995353
X-HE-Meta: U2FsdGVkX18xEgkZALydC/Pps3yl8iE054bo3QgNJzJyS9K317414fpcH2I9tqf2Oyw9lmvWQPPCWzjbSdfq09lGEMTxxcCioeZea70wFiAYm3gI+X0oMA5ewbqzrIHOvbTmoI+h/G9BpqfwcBCdriISIJNj+RoDMaL+nhAjl6ZA51/MRZXKOUB7IljoFbueUNB+cVN9HbsqIwgqpB3e335esTql53GDyNHOSqvsO8R73IqoQUasFZTbfdwtEE6/z82bf7VkZqKNNBctKJ0rgZRZXzzEZhVSqBCWpbp8BE70EVChWuiye3x3i7Y1IaLQ0cF9hj3UbGTtRodZ7VFXyV2hoXW6nI9IjVtolYiCmNq8pFDHrcooYXo2s7Jt/UxI1WGtTbo1s/rYxrFY43qxaiObWN9Tk7/lIClvAH+yVmRZ/bbXRUxx86AkxgRPNsRzgAw6nfamU/PdtoRivzZynf4Pzsmt/TYzNr/GCB/2rWheMfZ6BzKseqKBaBo+vU4uxLFLDxYNiI3WlND+E9rlXatUE8+qN6xrTQZNSLAttjhc4PfRGkifJV6W1xtjm8PV120WrLHh6ret5gDXyjaaqVNzotT2piANKKZE0vSnMBdq5UaaqNrNGYioRZH2h0Gu4Hk+XjtdUFOVEsM/uEvAJw8GcJ74qjbHNmY38lXD849dMudKdwbpmmhI4gKH1fRg9ICDRbyOkw7Zkpyy0MDon1YdUgZjcD9yogftXyLphMqQz67zZ4NElIGpXSnTKLxeAFm5P+ub5viEAPW6WphVXKt16WDJPo+TdECEuL45yDXNSyt+zpvejGuQ+qdZKMewCx6BaoOYrddAmkuvDLf33VfKjW8DaIK5xK3iCExsjsWApLHPMhQImc5w3P0HJZKpi5a9XK70I3G8jfwYupqxS5hTBbmCKnE/8cckI4YIkpEYntdUWUKoso+LpZvm0mmJOUWA8ilKj2uU1nTRuHl
 vr/rXe8l
 6ZXImclb8j60+QINXvaPYdj5xNK1lZgWoWn/ove5FTETtzYyrMQc/pjg7lXdNhfUxGMfQ8hcBZ60GdahM0rLiqPxf2JlWcmYn7byipHiW4c7Uy9cTict8Trxcf2HmeoRBHc9EouE3xdaJ5SQRC/HwUalMwsZRVmL9izoe0KcFogYmsNcvu53ynVFfeynZxmcgTQDspXvRsurRjmy7tAx5xl/NJLVWoTn94bY6eQISEbguLKc2k6SQcKmjGw+zjWAtsH0qSixTxz2WXKnT8dN8n/HLTvIxyNdb7i5WKsYu6KkpHHSdA8VcrEWGlkj77ODifn6rHmMZyCw0Ji8laqat60y0oe19PKF75jzYWmuYUQISTjfRGIJ2QXMLLQpdEhVthpvJIwSsP0TOBWNgf9UFM0KVv1ysZLqtadEdrOHX36Dz9Dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 12:48=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Remove the swap-constrained early reject check upon isolation. This
> check is a micro optimization when swap IO is not allowed, so folios are
> rejected early. But it is redundant and overly broad since
> shrink_folio_list() already handles all these cases with proper
> granularity.
>
> Notably, this check wrongly rejected lazyfree folios, and it doesn't

It seems the original code somehow missed folio_test_swapbacked().

> cover all rejection cases. shrink_folio_list() uses may_enter_fs(),
> which distinguishes non-SWP_FS_OPS devices from filesystem-backed swap
> and does all the checks after folio is locked, so flags like swap cache
> are stable.
>
> This check also covers dirty file folios, which are not a problem now
> since sort_folio() already bumps dirty file folios to the next
> generation, but causes trouble for unifying dirty folio writeback
> handling.
>
> And there should be no performance impact from removing it. We may have
> lost a micro optimization, but unblocked lazyfree reclaim for NOIO
> contexts, which is not a common case in the first place.
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

