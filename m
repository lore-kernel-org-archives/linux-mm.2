Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E28C2C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE626B008A; Fri, 11 Sep 2026 10:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97A16B008C; Fri, 11 Sep 2026 10:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88966B0093; Fri, 11 Sep 2026 10:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79DF56B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:08:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E055C027F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:08:21 +0000 (UTC)
X-FDA: 85201661202.06.4C4734A
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id B9C5D40004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:08:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nNQRXcww;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789135699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZjLf6+iZ0PXye5aRZ/dUkHiadjJGzqPf0A0418Uc0K8=;
	b=6dOH4Nby33SiWCh1HD0OVRkrMTSXvqIcdjn7/5CEGKQZOtmbH3gS0atKJ3j9j8fhUmTbQo
	yZZpVzljFiBMpoIoVCsCJl3+PP92wr59jmR/D2NRG70pwr8iCyPnfHyWDd1oC18xmYZRVP
	QqGtwjZyEeZTTBi5LRsAMtLN8Hp+SuM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nNQRXcww;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789135699;
	b=Ro3eUbXj/UhaOilqaIk7fqnDMfhkotWmqHKJfzd75MmfLSFgzfxFfQO9++Dy6uEbMh6VP4
	0QrmcB1Sa2ouYmvKG9MaDq4EVZ1rnACfyhgEzalfma1S+j/0tJSFL8FG/OZrpgyGhb07Xw
	2txy//K2SNv4nSFVjvjMe4EVMJCAh6Y=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7f4e729368fso1063291a34.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789135699; x=1789740499; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZjLf6+iZ0PXye5aRZ/dUkHiadjJGzqPf0A0418Uc0K8=;
        b=nNQRXcwwjoZZIiqbE4ncyShIQ4TXrxWm7ecr7N35aEiEOn/IIGXeNUoO/+VrLTnTqQ
         rmef4CCUC0ehJ9FDjJtOo8djsbyQbJjE0TuVkK1NES+nE7VAtW/GyqlmgdqIadbEkn9O
         32Om72sEesf1UJ+lqiPG8BwO6e2PkEagVhbunLiDTMHaTIcpkGP4pwhK8yOSBCV4+iWO
         F7l+TRz/mEwberC9gxV4OUeGWdV8Ooz2iU9FvnlTDu8mcslbl/1qjgjOjUqLsCcCH+Av
         UOMb2UYaFRFxRZh+5NFfS6uCkGV/1TjEiyW7smZuN/fkccDGEA+5UOgQ3i87wwNXXLp2
         fbvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789135699; x=1789740499;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZjLf6+iZ0PXye5aRZ/dUkHiadjJGzqPf0A0418Uc0K8=;
        b=VLVC5oDqhxgdoILfr2u0ZcM25mefIGqXgJ76xPeXEtKTdB9Dz6Tk4H2Lfs8gbpJ0Qv
         KytD8m7NbxHxltXZ96SWqcb6W5ZMGQZ5vPRwnVyfD57dGc3PjxoGPOMSs4ihNxpurRNe
         gfU6pgkisk16mkwE+nelj3dBOkm+mDt6CI2IgW5Tw34Jrjh8GFJX2fQFPE0694zTIkZO
         CE731YCPFI1AXaowOqMku9R7zdMmnMU6GiWJlzO9xNMBsgG+WN8MfhNKz0Yhop76+SFL
         KF16w9UDkh2pZm59m6BwfJrMtN5OuBK+5IIr02AcASd6u5zODJZTEspY0Je/vFzHq8Ml
         4RlQ==
X-Forwarded-Encrypted: i=1; AKwUvBwcyv8QzH03ZVJWvQJWi5vAKxM9RT0qCsM3xTjkfp5ZKtyizhjPUFIinsR2tOdU/c4r9OmDBXoMCg==@kvack.org
X-Gm-Message-State: AFuF++nNhgaBKJk1CJcLSFoiITc8X81j8yeLj04vEjzxhY/JGu97W1s0
	+sW9Y7S/qZ7HAPVNe9lfJ4ZojaTJGW0+cQj/sZ77uhI+D7c62btwTw26
X-Gm-Gg: AYBFou1R8pwWpF64H5aYS7UbF7CfNJbRKI+wBQxmG3m/JNMd99vRaOKyKgS74R+OMa2
	CVUJDhl02LPlf1VP6Tt0xBu9Dn6dWgAuiuL5r3pPZh4OziM6FGipM7Sx+MZW7Mxc+4v8/j/GFaM
	ha54QyIPmYmdGiCXGTNrulB/0DXhF7COInM5Ljh27LMJRtj5+7LQNr2t7zvhZA8gyX3ym3k7arV
	c0IjaokgtbPgODa27CfpxnLsnVd6Y5GnKFt/Xl6hPc1vj5EGlIosCsLZxto3ZBdrUk/90OtIV/L
	1oqkPGj2r/QHz5xfw2gNErhtsxu//UvntueGmJoFq6arS6JpHG98r2yq2OpcjD9PqGOTpnh6syp
	BVyltROzhVWtRdfS0Qz387jOaIdBNoTs3Ha6zuLv0yiRtu6azLadOjnI2UjTiCpdvKBoaUopbTH
	/gxStvpqKSiq5qwv7W5NvQASfg0J4rwmbQ6ZzeJNHahMT+qfrei/pK3EkCqz/vkIZkefyH0RMyq
	8WMCbgYKfFmdXNLVKTgR9DKrMm2YA==
X-Received: by 2002:a05:6830:6af8:b0:7f8:9fba:2cd8 with SMTP id 46e09a7af769-803ff332991mr3304795a34.9.1789135698444;
        Fri, 11 Sep 2026 07:08:18 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:47::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-803f5adf69csm2520486a34.7.2026.09.11.07.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:08:17 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Hongxiang Lou <louhongxiang@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	fvdl@google.com,
	jthoughton@google.com,
	rientjes@google.com,
	vannapurve@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ackerley Tng <ackerleytng@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: hugetlb: Track used_hpages when getting/putting pages from subpool
Date: Fri, 11 Sep 2026 07:08:14 -0700
Message-ID: <20260911140816.3236725-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260909-hugetlb-subpool-always-track-used-v2-1-30c5d83b572a@google.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B9C5D40004
X-Stat-Signature: i36j4gz1aih9e8q3ucke5fjs8wx7detu
X-Rspam-User: 
X-HE-Tag: 1789135699-300862
X-HE-Meta: U2FsdGVkX1++3tmSpcQJvmgVaO+h02KIMVkB4hoLmit+Sj5lGQsLZ79wgd0mw1vG+kXL+ZgA+rBpRQ3cy6mc2MaNRheUOln69srnshlvGk7Y8lVTbB8byxLSZA0cfLbb/Y8eGm3DnkyrxzBPzYFTIjUcLo4wBSV8ne1bKKyflvkJLQpMcdc9BhEuRgK19bLNMrD3tidw/5S48xgydp7huUhN/vr62RxY7e56KLEuVhTdlUg5sPane9lj2ro+luhE/HkDYjqteEsTIseemA+7W+sFyWAechqlkklKmyJtj4Ga2gd5yh4ZvpAXfFJ+Gu5jgy/6GSfwpqfuyRQRWP/UFXFC8MBk0j9n2xRxhsS/12m3NfjIFG6yN5igiflhVTIELr4WD47YiT9Ekak3+vIyELappIKRr1+sZ6+8b9NdkSRfN8/U+BrK0GherlgiKFKwMsayTZeqWF0Y6jEtOEZM17Hzx3n3ikeIu4Mv6JC/PaONlqhUp9i03e2cc1qh++P5JOxrnJf7lvyu+nw7YSIOsn9VYRnvWf4fuT0tD04dPCYQtzy4I+my8JDCCatqvdLEz3Gzhp5GiF2rNraUQW2MItXtH8G+3MlzmYvwde+4rOwlD4jNP5zpgoXTbDOXeixBGMcZFFDdPd4BB5GFrq0Z61jLgAUeZSN4ebeQrDwyL1/scK7a9wUP2HEdZiIEv6lzKk2I7tYtsNITrWtB7AnYq8QYyo8rPQqb4e5/Cc1XNqTvXxrmwHgSU9M5bnTxm36rdyxYM9hXH/RKcsPAsp0mL/BiTwMk8MLR3GrJYw+FSpWJkhCu+uIrKdxny/nERfEgYjrJ1QCDgbZiImdmPqHBAjnvFkQKrIuTOXThZ1+6kTIPDLqrgL0LfOJZP15ep201EdJwUl6hN2ulyMlGLwTISi+ReuS79t+VBGjpzD/qsKjKwPn1NfZXnhSCxvxJvJ7ft/GiHbllf3ptpKXbwBs
 c5O9pulA
 Qqzfyr4O66mCEMl3LxiT1am+AO1M7TQ2eMvMogvTMO+Rw5dN/YyavmhGUoGIgU2k07J3WXtpTTiaF3nOb4TzxhZ+5w7i6pMuWXxDquxkpXXGjEk+bYuHgz090JblOF1GTY0sqQfXFrfgkM6NFAhn8JMizWWwrFXwY2Jhf5oaSaO2isDcSLhk7vOiLaebRyumxoGOrm9P8TgY4PmhTkNdb+GLj/i3Pf7Ph8NkWZihGoU+QZFOjimImb8P1QV+vGclaHn86VbcztEx2Db7iC9gVqZgb93NC0pQL7bZZbd8qylZVn9v05j+6SyC5Sr9/6X8hS2A274tKKcpBx0iScbcTVKficCwi4JD8XQiEBG+VDKwJ/W0HwE+Bl42s5JRutjWcRldUqjs3NixN1qNnsHkrIk1cU4uDqa1NTH5Nc2uFuTv3HlSjDY5BL6SPMpBI9x3LicmFDpfDGJlvtOukLKJizHxr8PwtXaROYai89fDY/pyTPlgP70r+zfitHdTnr6wMvlqNn/s0GmyTcf8yin8cJ3FH+Mulrlzlur4rT3BmKOGtQ9jdzkPWczI/90Aema3eQT+rQItAwlF1NM1wFmwLlASPc7knkzTyshKrY9r9fwbBnGV9Mv/1Pf/r4szZsEPm1yWTc0IfyK0IrzvwveJe/eNbARdcA2hDlNmULJfqSu6J5YZ3vlkMHf4FFoUEtKXkfyeRnW+Os3zmYfQeIvEK4DDULc6CqXlnWMdVPvy/EMvuz1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 09 Sep 2026 14:49:26 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> From: Ackerley Tng <ackerleytng@google.com>
Hi Ackerley,

Thank you for working on this fix / simplification! 

> HugeTLB subpools currently only track used_hpages when the user
> configures a size limit.
> 
> This is buggy since when there are existing allocations from the
> subpool that would have satisfied the minimum reservations,
> hugepage_subpool_put_pages() will still restore a reservation to the
> subpool. See below for an example of a false reservation.

I'm not sure if I see the false reservation example, could I be
missing something here : -)

> In addition, the subpool is considered free prematurely, is freed, and
> this ends up causing a use-after-free.

That doesn't sound like a fun time!!

> The fix is to always track used_hpages within subpools, which is also
> beneficial in general because with that information, reservation
> tracking is also fully managed within hugepage_subpool_put_pages().

This is an increditly reasonable approach and I really like how we can
get rid of a lot of the if (spool->max_hpages) ... special casing.
Having different conditions for checking whether a subpool was / wasn't
free was also a bit strange to me as well...

> The subpool always knows how many pages were allocated through it. Every
> page allocated through the subpool increments used_hpages, regardless of
> whether a reservation was taken from it.
> 
> Conceptually, now, every allocation involving a subpool uses a page from
> the subpool, which must be returned to the subpool. Every page taken from
> the subpool tries to use a subpool reservation. Restoring a page to the
> subpool reservations only if the page was taken from subpool
> reservations. (If used_hpages >= min_hpages, the page must have not have
> been taken from the reservations.)
> 
> Always tracking used_hpages provides the subpool with information of both
> used and reserved counts to make the correct decision for both max_size and
> min_size correctly.
> 
> With used_hpages always tracked, subpool_is_free() can be simplified, such
> that the subpool can be declared free if there are no more pages in use.

Awesome!

> Also update the
> 
> + Documentation for used_hpages in the subpool struct, since it no longer
>   matters whether the used pages count against the maximum.
> + Docstring for hugepage_subpool_{get,put}_pages
> + Documentation to use active voice, and remove some details in favor of
>   having details documented in the docstring
> 
> Also update statfs reporting. Previously, if max_hpages is negative,
> used_hpages is static at 0, so returning max_hpages - used_hpages returns
> -1 and is always correct. Now, if the subpool doesn't have a maximum
> requested size, indicate no limit for free pages (-1). If it does have a
> maximum size, report the difference between the requested size and the
> number of used pages. This difference is always positive, because if the
> mount does have a maximum size, hugepage_subpool_get_pages() ensures that
> the subpool usage never exceeds the maximum.

> Fixes: 1c5ecae3a93fa ("hugetlbfs: add minimum size accounting to subpools")
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Cc: stable@vger.kernel.org

Feel free to add my:
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> ---
>  Documentation/mm/hugetlbfs_reserv.rst              | 17 +----
>  .../translations/zh_CN/mm/hugetlbfs_reserv.rst     | 11 +---
>  fs/hugetlbfs/inode.c                               |  8 ++-
>  include/linux/hugetlb.h                            |  4 +-
>  mm/hugetlb.c                                       | 73 +++++++++++++---------
>  5 files changed, 55 insertions(+), 58 deletions(-)
> 
> diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
> index a49115db18c76..d244583fdcbc3 100644
> --- a/Documentation/mm/hugetlbfs_reserv.rst
> +++ b/Documentation/mm/hugetlbfs_reserv.rst
> @@ -314,21 +314,8 @@ huge pages.  If they can not be reserved, the mount fails.
>  The routines hugepage_subpool_get/put_pages() are called when pages are
>  obtained from or released back to a subpool.  They perform all subpool
>  accounting, and track any reservations associated with the subpool.
> -hugepage_subpool_get/put_pages are passed the number of huge pages by which
> -to adjust the subpool 'used page' count (down for get, up for put).  Normally,
> -they return the same value that was passed or an error if not enough pages
> -exist in the subpool.
> -
> -However, if reserves are associated with the subpool a return value less
> -than the passed value may be returned.  This return value indicates the
> -number of additional global pool adjustments which must be made.  For example,
> -suppose a subpool contains 3 reserved huge pages and someone asks for 5.
> -The 3 reserved pages associated with the subpool can be used to satisfy part
> -of the request.  But, 2 pages must be obtained from the global pools.  To
> -relay this information to the caller, the value 2 is returned.  The caller
> -is then responsible for attempting to obtain the additional two pages from
> -the global pools.
> -
> +hugepage_subpool_get/put_pages() use the number of huge pages passed to adjust
> +the subpool 'used page' count.
>  
>  COW and Reservations
>  ====================
> diff --git a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst b/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> index 20947f8bd0654..ae1f1f31477fc 100644
> --- a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> +++ b/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
> @@ -246,15 +246,8 @@ hugepage_subpool的min_hpages字段中被跟踪。在挂载时，hugetlb_acct_me
>  被调用以预留指定数量的巨页。如果它们不能被预留，挂载就会失败。
>  
>  当从子池中获取或释放页面时，会调用hugepage_subpool_get/put_pages()函数。
> -hugepage_subpool_get/put_pages被传递给巨页数量，以此来调整子池的 “已用页面” 计数
> -（get为下降，put为上升）。通常情况下，如果子池中没有足够的页面，它们会返回与传递的相同的值或
> -一个错误。
> -
> -然而，如果预留与子池相关联，可能会返回一个小于传递值的返回值。这个返回值表示必须进行的额外全局
> -池调整的数量。例如，假设一个子池包含3个预留的巨页，有人要求5个。与子池相关的3个预留页可以用来
> -满足部分请求。但是，必须从全局池中获得2个页面。为了向调用者转达这一信息，将返回值2。然后，调用
> -者要负责从全局池中获取另外两个页面。
> -
> +它们负责所有子池的统计核算，并跟踪与子池相关联的预留。
> +hugepage_subpool_get/put_pages()函数使用传入的巨页数量来调整子池的“已用页面”计数。
>  
>  COW和预留
>  ==========
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 7611a8470ea26..5113f743f6fc7 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -1109,8 +1109,12 @@ static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  
>  			spin_lock_irq(&sbinfo->spool->lock);
>  			buf->f_blocks = sbinfo->spool->max_hpages;
> -			free_pages = sbinfo->spool->max_hpages
> -				- sbinfo->spool->used_hpages;
> +			if (sbinfo->spool->max_hpages == -1) {
> +				free_pages = -1;
> +			} else {
> +				free_pages = sbinfo->spool->max_hpages -
> +					     sbinfo->spool->used_hpages;
> +			}
>  			buf->f_bavail = buf->f_bfree = free_pages;
>  			spin_unlock_irq(&sbinfo->spool->lock);
>  			buf->f_files = sbinfo->max_inodes;
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 16c4c4caa126c..4551ff3023640 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -39,8 +39,8 @@ struct hugepage_subpool {
>  	spinlock_t lock;
>  	long count;
>  	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
> -	long used_hpages;	/* Used count against maximum, includes */
> -				/* both allocated and reserved pages. */
> +	long used_hpages;	/* Used page count, includes both */
> +				/* allocated and reserved pages. */
>  	struct hstate *hstate;
>  	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
>  	long rsv_hpages;	/* Pages reserved against global pool to */
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4f6f58bf3db6c..e72e22f887478 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -130,12 +130,8 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
>  {
>  	if (spool->count)
>  		return false;
> -	if (spool->max_hpages != -1)
> -		return spool->used_hpages == 0;
> -	if (spool->min_hpages != -1)
> -		return spool->rsv_hpages == spool->min_hpages;
>  
> -	return true;
> +	return spool->used_hpages == 0;
>  }
>  
>  static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
> @@ -193,13 +189,18 @@ void hugepage_put_subpool(struct hugepage_subpool *spool)
>  	unlock_or_release_subpool(spool, flags);
>  }
>  
> -/*
> - * Subpool accounting for allocating and reserving pages.
> - * Return -ENOMEM if there are not enough resources to satisfy the
> - * request.  Otherwise, return the number of pages by which the
> - * global pools must be adjusted (upward).  The returned value may
> - * only be different than the passed value (delta) in the case where
> - * a subpool minimum size must be maintained.
> +/**
> + * hugepage_subpool_get_pages - Get pages from a subpool
> + * @spool: pointer to subpool structure (may be NULL)
> + * @delta: number of pages to allocate or reserve
> + *
> + * Check and update subpool page usage counts when allocating or
> + * reserving @delta hugepages.
> + *
> + * Context: Takes spool->lock using spin_lock_irq().
> + * Return: Non-negative number of reservations that cannot be
> + *         satisfied by the subpool, or -ENOMEM if the subpool maximum
> + *         limit would be exceeded.
>   */
>  static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
>  				      long delta)
> @@ -211,15 +212,14 @@ static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
>  
>  	spin_lock_irq(&spool->lock);
>  
> -	if (spool->max_hpages != -1) {		/* maximum size accounting */
> -		if ((spool->used_hpages + delta) <= spool->max_hpages)
> -			spool->used_hpages += delta;
> -		else {
> -			ret = -ENOMEM;
> -			goto unlock_ret;
> -		}
> +	if (spool->max_hpages != -1 &&
> +	    spool->used_hpages + delta > spool->max_hpages) {
> +		ret = -ENOMEM;
> +		goto unlock_ret;
>  	}
>  
> +	spool->used_hpages += delta;
> +
>  	/* minimum size accounting */
>  	if (spool->min_hpages != -1 && spool->rsv_hpages) {
>  		if (delta > spool->rsv_hpages) {
> @@ -240,11 +240,19 @@ static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
>  	return ret;
>  }
>  
> -/*
> - * Subpool accounting for freeing and unreserving pages.
> - * Return the number of global page reservations that must be dropped.
> - * The return value may only be different than the passed value (delta)
> - * in the case where a subpool minimum size must be maintained.
> +/**
> + * hugepage_subpool_put_pages - Release pages back to a subpool
> + * @spool: pointer to subpool structure (may be NULL)
> + * @delta: number of pages to free or unreserve
> + *
> + * Check and update subpool page usage counts when freeing or
> + * unreserving @delta hugepages.
> + *
> + * Context: Takes spool->lock using spin_lock_irqsave(). May release
> + *          and free @spool if its usage count and references reach
> + *          zero.
> + * Return: Non-negative number of reservations that the subpool cannot
> + *         absorb.
>   */
>  static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
>  				       long delta)
> @@ -257,19 +265,24 @@ static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
>  
>  	spin_lock_irqsave(&spool->lock, flags);
>  
> -	if (spool->max_hpages != -1)		/* maximum size accounting */
> -		spool->used_hpages -= delta;
> +	spool->used_hpages -= delta;
>  
>  	 /* minimum size accounting */
>  	if (spool->min_hpages != -1 && spool->used_hpages < spool->min_hpages) {
> -		if (spool->rsv_hpages + delta <= spool->min_hpages)
> 
> +		/*
> +		 * limit is the maximum number of reservations that
> +		 * can be restored to this subpool.
> +		 */
> +		long limit = spool->min_hpages - spool->used_hpages;
> +
> +		if (spool->rsv_hpages + delta <= limit)
>  			ret = 0;
>  		else
> -			ret = spool->rsv_hpages + delta - spool->min_hpages;
> +			ret = spool->rsv_hpages + delta - limit;
>  
>  		spool->rsv_hpages += delta;
> -		if (spool->rsv_hpages > spool->min_hpages)
> -			spool->rsv_hpages = spool->min_hpages;
> +		if (spool->rsv_hpages > limit)
> +			spool->rsv_hpages = limit;
>  	}
>  
>  	/*
> 
> -- 
> 2.55.0.1007.g17ff1f9808-goog

