Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C69A9F8A149
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A096B009E; Thu, 16 Apr 2026 05:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2E26B00A0; Thu, 16 Apr 2026 05:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8996B00A2; Thu, 16 Apr 2026 05:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBE096B009E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:18:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F6DA8C44F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:18:40 +0000 (UTC)
X-FDA: 84663868800.12.FC65449
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 637B810000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:18:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A99cJbAw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776331118; a=rsa-sha256;
	cv=none;
	b=4P18hnwYe/8NKXZbnqmbPP5mQ6AU1KarZHWKOpflXt4C25pJqjQ/qlZNoXAZ/gTvbHJs1z
	VS6+i5SnkW8290WYHEsPOXSjTs0rknMx5v3+PmYa1INOWzB/qByDhLlADj8T4AN7SqOax9
	6D/xyMs1erGUSP7atmTVjvQEp22pmsA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A99cJbAw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776331118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37LIe+aq3xvfVtxHkUR8aWgYefKXUCUB4SdKrNcPMP4=;
	b=QSD8Q5v9p+iUqaSDQwetCX4PSVAbFGc/I2vC06Dom161Dvs6dqBWH3X+DXiocygK6bCMBT
	nxNp4sdVPRFNbEHtI6nrJhWLnfNFJ/u9kNwAOfQiEw0zDA3ZXJE+zyjDQWmAfBksG8rpG4
	1urMEpfjxunZrg6bN2pzcp8U3NKC0ek=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6552240614
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F17C2BCAF
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776331117;
	bh=37LIe+aq3xvfVtxHkUR8aWgYefKXUCUB4SdKrNcPMP4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=A99cJbAwjVY62xh3PvHdrzNrMmF8lCSYOvTDZI8M2zx1H4FJVoIbJvGvZSGcKtC82
	 C7QtifEjd0oDLxFhw8vx2uGpgDBFhUxqu9lhdfsP66rEZZkTjz5sSvpg+iRUtfKjl+
	 he5MdcPXNdr6cSFbLcf0fERsMsCNph18hqmCKaVeR1jt6aiC0mkAARkMYKWPug5wbV
	 rsiawI9eWdY/NUK48zEG99dw2eUyCGVRZ74uEz1OyZp6rcn1q8P69f+hTii6Xg/tsB
	 0/bGPXBpwY5cTnw4OYFG//wfpPDY+KF6PMH6QswRymv4gN8K0r4qL567XpJAc/YHLi
	 Yye7RqlEqw6lg==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8d7e7f48499so760151685a.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:18:37 -0700 (PDT)
X-Gm-Message-State: AOJu0YyZe5lZEQps3+/VXhwOYpc8jKZqSOKQW3sNzHubBTIO9GE+m40C
	TVmUAT+u9HTnM2KgrGqj+ucMphZ1e7dN981wiAXvHPOhSLbJxsklJBNFj/P8XVlq7VLzcCmZJ3R
	6AbHf3XOHc8Nhi57rMWVeZ+E8DoySrTg=
X-Received: by 2002:a05:620a:d85:b0:8cf:e152:592d with SMTP id
 af79cd13be357-8ddcdae4eb7mr3857193085a.21.1776331116597; Thu, 16 Apr 2026
 02:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com> <20260413-mglru-reclaim-v5-9-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-9-8eaeacbddc44@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 16 Apr 2026 17:18:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xMw2hGHE+zySxS7nHzu08XGZEGm2PER7EPuvM9ficY+Q@mail.gmail.com>
X-Gm-Features: AQROBzD1HZBDOBK7eKDOiRnzA3d41LsFOqPsOUKmFLbZ5S9bghKH22Kvn9McKfg
Message-ID: <CAGsJ_4xMw2hGHE+zySxS7nHzu08XGZEGm2PER7EPuvM9ficY+Q@mail.gmail.com>
Subject: Re: [PATCH v5 09/14] mm/mglru: use the common routine for
 dirty/writeback reactivation
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
X-Rspamd-Server: rspam10
X-Stat-Signature: 9qzop7kmo9os5gkh1fkt4ye4m7d1nik4
X-Rspam-User: 
X-Rspamd-Queue-Id: 637B810000B
X-HE-Tag: 1776331118-489808
X-HE-Meta: U2FsdGVkX1+kxwmHudOJyAEYvM4b/TBZZx1iMVRpx4F2YTpvH2thHIZx3BSWBEo8SjG1LRA5/hBwlNH4egVAu1E7LAijOL65GgEFC0JW7CfbQdDYdaMOfw2Z/+am9NlDCADapMqim1iUR6ad22fJFki5XqDpWvV+1nyX2UJ3F3YwrmsoqU70VYWSRLM7oZvecEsMOLptnmDUmNYBOOibajridsNXl3S5aVBQwExg/k/JOLkLNv4lXomOYz+m0jaBxRVUTgyRUf1sZ6VcKgYqBNPO3Ho+odEk41NDW4hoB4ikmmdagNtxQgfMIWkf/4IablIWv5T6E7HIXyG0Tugj7WZO3NzA6cHfqep8Q0c/jQXVHJGaanmiZP0xa8Fha5YOFzzaq5OygKYrzZLfilqb/ljqzhLiyg2rtbVvLOVn7ciFWgbYZDZ1K0stqYKKQBc9eYHpqKa1sbRkLRMAUGN7haR/SgDaWPcGRXI4AlaiaJ/VONF4hV26ahADGax6eJmmqbbiUmzd+kAwiOVBc9rCqaBzdMDvp9XYspqAQeOjCXYNW8BdEBr10xDcFH7qAN2Vnspu+zwQs3prB3YF7eKIx4QEVM9eBhzz6G3TW6bQzQM17vD4lXVQdJ7/oqO7zNnvxUTQTEsjZJSp9NAh5N6+DZ35b4+nFwq6PuusR0b18YNwEzarPgIgpn4Du5PV5d5Ezjamb31sN2SS93pjNc0D2oX/nZAgsFrkgC3vhHL2VkXpw9IXu1gRH3I9Bs2zVU3f90nkU6sd3YBTqXqJ6TB5q3X6yYCezRzbhquAWnBkOmibmqNhDJ+7IXPzcPnDVooo4SVn6kdVu7eA3tGY4p5BPWy7zV9M0xGKY0pc9sfOb5umNcV519j1Urce8QeyM6FDtdQFRyP+nHLbNBGnjjCjxGxEfrQANA8Q2czBs6PNaGgjp8U0yGEqHSINwZEfL0Gq1jVBUP2TftW+Hz1lD/l
 GlK8R9uM
 zzyGV/fKRxCFOpLN/AVdymddyyNDp72LPtjo3XKVEfqsY8CeXYZpQ4CsT4MX5ION+8lCcGnYfHZLYdRoQAkam8IsMjm3I0/KFgkLhesGC9T1hGx4vVQU/eXl/LrsGl5+EI4ngZ3An55PF8xC5YC3ogkF55cHB1A45QFrVHO2g3b7NE23zeq7Xb3QBKDH3QOdi/2Daqp6pXD4dypXh5rX35DSgvnEGv4WMOWkotT7p38Z3rUOE7SKEoHhM8SkN/cHwMn1E/FxVOi6OocfVzVr/XaR/MAcYBZp70EM1a0Nx7qmSTP9L1sQgl3fVWrjW0GD+l0KSBp2N+7Ks+sNagsBs0TJI5aM9bwcC3Bc1Lu999g2tGhUKHw3xq18QEd4zQVbF9EJxdiGOxQpLd/jHjlsK9pu7aPENvzT47QEVhNZ+XZ+wlEY=
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
> Currently MGLRU will move the dirty writeback folios to the second
> oldest gen instead of reactivate them like the classical LRU. This
> might help to reduce the LRU contention as it skipped the isolation.
> But as a result we will see these folios at the LRU tail more frequently
> leading to inefficient reclaim.
>
> Besides, the dirty / writeback check after isolation in
> shrink_folio_list is more accurate and covers more cases. So instead,
> just drop the special handling for dirty writeback, use the common
> routine and re-activate it like the classical LRU.
>
> This should in theory improve the scan efficiency. These folios will be
> rotated back to LRU tail once writeback is done so there is no risk of
> hotness inversion. And now each reclaim loop will have a higher
> success rate. This also prepares for unifying the writeback and
> throttling mechanism with classical LRU, we keep these folios far from
> tail so detecting the tail batch will have a similar pattern with
> classical LRU.
>
> The micro optimization that avoids LRU contention by skipping the
> isolation is gone, which should be fine. Compared to IO and writeback
> cost, the isolation overhead is trivial.
>
> And using the common routine also keeps the folio's referenced bits
> (tier bits), which could improve metrics in the long term. Also no
> more need to clean reclaim bit as the common routine will make use
> of it.
>
> Note the common routine updates a few throttling and writeback counters,
> which are not used, and never have been for the MGLRU case. We will
> start making use of these in later commits.
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

I like the move to the common path, activating the folio and
relying on folio rotation afterwards. The original MGLRU code
seems over-designed and may hurt performance. It seems to
overthink things.

Reviewed-by: Barry Song <baohua@kernel.org>

