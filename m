Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A6FC88E6E
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082546B0088; Mon, 14 Sep 2026 11:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033736B0093; Mon, 14 Sep 2026 11:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E674A6B0095; Mon, 14 Sep 2026 11:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7E986B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:56:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8EE6A407E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:56:54 +0000 (UTC)
X-FDA: 85212821148.16.CDF94F9
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id A5D1D40010
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:56:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hadUXRcJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789401412;
	b=tNpzcEdGcWE5PTmk70LWcgZ57tVKVkfCrBzDDJ8n1xTcCuX7ETAGMd8E1go7glhWNovimC
	bkXiAM2KC+nbwIdNUbvYDhAHTV4o6N47sgK8kVCi60qicuRZduQ6wUwjsFfLgFmxiNML+B
	eLb5H3zuvwJjczVPfwodE4xVLieSFnE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hadUXRcJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789401412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfklUHIPWaWmrp2t1aYWGciesvwPpwkoe+iBPGV/Vsc=;
	b=1lu3AinAiLgUDf0b7xN5781ZYAlyh82zI4O3aIXCmPm+uhsRl3s1WwQByhAJx9C8UhzhBk
	ndpGq8D3SOAhkYaFltEJ2vyUBZJq/sn2vOJyF2xv8m73K93Mx/CQKF0x32ajjr3q7N9kHa
	NHZFoQtiGuiLA5qbbPMYeQsKWWZGpPY=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5c7c25d9f6fso3283645e0c.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:56:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789401412; cv=none;
        d=google.com; s=arc-20260327;
        b=pQ1iWEJFKbdGqeQdJCBq5Nv7PMUMEs33cORhEFiN0EGglt3WdG8/Io9MVs3Y0MUYhA
         P40WSKfQi+JKH0gJOyS38x81JjZ4VeNOI+SMUq8nnMzhSUtz+HFbvKaGpYt7vieI3HC8
         dyy/6bZOt0oGkrqxsEwSrdnDKvF7AwAl5xxXzkuXkxy+FTo1WaL+IsDrrjorNGpNhQtM
         gwEYzKFK42blyNgvEusr0t3QQMAGeM682isYBP5GWNMyEMXd/lrhPOOXTgN4KpZ/HSUs
         CztFQdGY5OpdlR5idCMM63QnFh4t6a6rIwW4t8ai30xO5ibVcG7tE+cZkGneTZzKw813
         UYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=LfklUHIPWaWmrp2t1aYWGciesvwPpwkoe+iBPGV/Vsc=;
        fh=g4aO/GPAewsITO3YXX6PIi4GE5kLmktX5T4rZzP/DE8=;
        b=GXoY3lhWMi4iPf9G8QnR8WhfxrtGRyiIhU9cAP7tUyJqla4qnUh7IUrelOJfJOhyJ9
         TjWrUssXSLTrpGe9MBvoL+rqWQMZA/+kmtqnuqtzMpbL7q8gTJkvWKzMl2AugRyCDBam
         8W+9hi0GrZnFdAKp5j8OxcA+hYWXg4ZWK2MZrCbPFF6/R9HT8krRKuv/xSTpqqpCf/wC
         s7k5Pf/aFqBeOpOlIGvOqWYgH+HmBoETpnFUj0bDjKwamUt8vx1y0oGjZjyUEnWtI0G4
         bkTR150SkkgYpGZBmVZ6vta5s4lZDVgQVvYuvdX6tTXP9EKgE9dxZ5bhRh20BTEU1Ypk
         8OnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789401412; x=1790006212; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LfklUHIPWaWmrp2t1aYWGciesvwPpwkoe+iBPGV/Vsc=;
        b=hadUXRcJzY4Zx/SqRabVLKSDTK1X2hNu91i+6/GiKHAmXVuz0X8YY/EKgVIKeCZ81V
         VcGeMu/B9qP+MU4hjWGxeod16Xkp2mI8nfrVi8ToSGahC1LxGOLl9ou6PghKPgu7Qmej
         NFhBgqKqHUjf9/cOmJCE4wEHKnZ/WXLzYh1+VZKmv7+9SGbjjps/2C7mXd05LmLXRoss
         rVluewOVOT6KWQFeAYMyaXmK1b/KE0VRzF8rkh91MeUyqa8YypZOjcBVr7YZtpSHECpN
         Sjqf5lCx/asUjBBVqsmwoqUMwjizruhPYNcTmDlAg0ZCxU6c5Mbv3DtihNu1OPySC3ld
         Dn/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789401412; x=1790006212;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LfklUHIPWaWmrp2t1aYWGciesvwPpwkoe+iBPGV/Vsc=;
        b=JJUM27ySqOJv+wF6XX1A/UK3sR3/8E047EhWf2E7ql2kbbzyR5mnNRwZFLR+otAVrB
         OtSukwQzNWcuuCv1U8ArdSRgKyd/whN9MChgthHJWavnwwBdrI0XCDvMMMRr2ldsFSHA
         ue2GYgi+VkKjuyFIt0DnkcqJtL6LwkGrnfxHfN6bz4TpvUNyAQ7zTeU1IomCt5nYPMm1
         P9Yunv0jbSbcVqFGmA0BMJThAWvyN1/rxyzaZfJRuaFYjGb2G5gBX2SQ22Da8Hio1rzd
         ZtZNv52oX8yGR+v7JfpAhoR3Cor4cl8ks3XQpcC7zQWCs4+v00PpH0Bfy5ElGoZpsv1e
         5kCw==
X-Forwarded-Encrypted: i=1; AKwUvBwhlEH3q4i+uoAS7d4H97sJ8w71C9O8mx6OTXvwl2GGdYkSii2yw8bwU6QBJQ9K8lFSeXX9FG4SPg==@kvack.org
X-Gm-Message-State: AFuF++krQnJuM/AznhgORNNY/1B5Aoi/73Fa9wH8kk6rCSy7h8BSag/5
	hMDXmA6YG9JLpxV1FXkUyKWiJMlUeaq5kGmEd/db/bv7+/dWBXChlCUBSet/rVLr42XAWUUlclU
	Y/lPHiPdQKMEPiATZrbNFgon1mY2nOV2WGwa6oK3L
X-Gm-Gg: AYBFou3CkwaUPRLNvTrg9HPnPIy6qumGwlAyV1/2Ia/4NV8NVFb59WDLK7dMwQO6QS3
	9uAAm0KHmvTMc+poh4FdOoUld6OJAOPtvsRRobKd/AEjckwctZbx5eTi5K4o2RY/TDHpwoj0n+5
	TzJaeQ9LKeIo4jiv3j9HdxcRNLTZvK9/AV8Esl7DI3AZR6eiiVI34iPNDOcGDM/bwXsVkI8pYHe
	HSNxtoUdwafVnQW80eQ+6Q2lX8LW6JumeaklK8gJQ/fWLassqU09sTEGFyoZWZRX4LGgV+5nTAB
	/zOpXAXZwCEjKq5FpSLIsI3j0dk+QWismR6OSm3F1lkHnMem6kmH8ITcnweeKLj2TsNPc+/dh1x
	ek6OTSpRUQA==
X-Received: by 2002:a05:6122:4b8c:b0:5c6:64ac:d6f3 with SMTP id
 71dfb90a1353d-5c981d3a2b4mr3488872e0c.3.1789401389359; Mon, 14 Sep 2026
 08:56:29 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 08:56:28 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 08:56:28 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260909155003.e6c2f4fe3c0bbee3b34578fd@linux-foundation.org>
References: <20260909-hugetlb-subpool-always-track-used-v2-0-30c5d83b572a@google.com>
 <20260909155003.e6c2f4fe3c0bbee3b34578fd@linux-foundation.org>
MIME-Version: 1.0
Date: Mon, 14 Sep 2026 08:56:28 -0700
X-Gm-Features: AcwNN1VbtSw2suRdJEPwwVSKB7yg54T9kxDFDisYSP9Jtt5N7Dkjunh5FrFt35g
Message-ID: <CAEvNRgEwbUXj5cVQq4A-U=AMOzP3S1mjnrOC79Li71wf-E+dDw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Fix HugeTLB subpool used_hpages tracking
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
	Yanteng Si <si.yanteng@linux.dev>, fvdl@google.com, jthoughton@google.com, 
	rientjes@google.com, vannapurve@google.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A5D1D40010
X-Stat-Signature: ytj44ejpapuybr65dajtg7jngeik34o7
X-HE-Tag: 1789401412-873246
X-HE-Meta: U2FsdGVkX1+yNVRW26X9mXnF9g7noP27cYvqKh3MI59+2XvZiZYKr4e61NeVbBRI+xSF8hfGZAQBrjDt3yi+C+8GAmNZ3pdSMxu/QlsSmepyvA1brTo5AENmPuJVOGHFT0X4DxeJxJvsaiPmul1lvj/QiCAQOnaE26sDhYjna9qB8zFdBUsDJY7tcCGF0pIR32fEIdOB86c5Hvom5ILkqZPKtay/HOUac2cw9uW73pSGsuzLG3ZyF64ynNYp23Z6rUCUnjFXLIBano163cdqgT+7vPJeO+lWfK83HW+SRu7+tHwWYER5Ap2ct9qVP5yvK5LtqcX3hsuTdyKYAW4LeRipUEXha7WvIzBYBDVyvW8nrhdA+zV93RqCbi5qb1bL58BIbSzHe0VrW7DrSmhp5EDxGEsB9peSksKd2ZENvkiG9JN4bK1V5n5F3ArBQDrmUi+tg1+v1C6F1xikO7iOqRQpEGEwcTQLt3OqgHFd9FLonV4fLbmLXYbObFshn0dAdRuJb6LinWLPRGBnFJvNJVSw0l2khrbIa56Kow7JDflNKqB06fE3sZ+2fvxm/1eAdiIEFqbzUrCZWz10GHVOWbXNXLO/2k1MBJ2+hgysgh2jou86No+QMkZ6trEKuCNOg3fULNVoWY83hTk5K+LhDW8UTtwmRZUmoqp3bKLoTYlnIWqyhYyO2VV6/TMbq85YVrb3WMOaN8ojn673Wix4aqIKZnFGS6UwHc1McTdCSvzV1blxbkfmVt9pGBaNH7j+kAEhoOOpYpqZ7TRhkqRDyARIe19JvGdrhIGETQxOTr7iAIQQSmTOegOAaXeNCKkh365EmYjMfEFjLgRoQ1Y7zDtzDK/m3O6dDIeUWxscvbGk48avEWgLPK8BePazwCFX2YB+pMgh9ZRPw/gxIepfw1AsrAsrIdzThkhKdCwxXwtUZEHkpgv5cP53WgWEKKk941ANtsI6/NvbAUnX0Kb
 NWCGptcz
 zUfTlZIsEreh+3MFNgAheJ6pWBn2cyit7X6PFIO1oOfIVResXr8a/LFMzE3Uq4IXZ3YI21O8dnPm1BICpxMhaKodTSxdbmNI7tllHbMt8WRbBS3ZkRigvy1+fQDEUnmu6uKYyLgFTZ4C+13EbBRa78iXwqvG/3gs33os3Pw0IzQ6H3YcuYaN+WhSSzYVX7v+0T8XfUKQo63mHJ+NONYFXaUGZs+XTX+BXtWkOwZeufEbs9UJ8Nh6MAa+vyuxMzuTbtXzAxfJiS6d4zW5R/5q6RBXQzthpz7L4Th3kNXSkFoXdNTJoamWCJSMzNYl+KePEBNR53ESUeOLjzeB4t511qq2lxzIK1kuQWcZ62ubvFlVNoY6w0g3QwUvkyJCJe3oC0TI+mIjqUzhDUbrFFEcHSStVNQqYbtl5Nwvyy5jRMc4eJHAkxt9NW5y72g5MgLwxZAP5HfvF8TmGADKyu4hzNurDgRB3irnHJjd2C1UfwElce8edF+eE7T/lVM6z/aTpLC2bfKovWMwQRuM8bvQhZnlBAkOhNHa/FoMjLEvTAGhrlLbWa+OFF9afa87u3EK9fo60mz3zTJOAJXgGG95T+hI1ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 09 Sep 2026 14:49:25 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:
>
>> HugeTLB subpools currently only track used_hpages when the user configures
>> a size limit.
>>
>> This is buggy since when there are existing allocations from the subpool
>> that would have satisfied the minimum reservations,
>> hugepage_subpool_put_pages() will still restore a reservation to the
>> subpool. See below for an example of a false reservation.

"false reservation" should have read "false reservation
restoration". Will fix in the next revision.

>
> That sounds annoying, although isn't clear how this affects end-users.
>

I'll also add this to next revision:

hugepage_subpool_put_pages() falsely absorbing reservations (aka
reservations being falsely restored to the subpool) means
hugepage_subpool_put_pages() will return 0, and h->resv_huge_pages won't
be decremented. The page(s) still being reserved in h->resv_huge_pages
means fewer HugeTLB page(s) for use in the entire host.

>> In addition, the subpool is considered free prematurely, is freed, and this
>> ends up causing a use-after-free.
>
> That sounds alarming.
>
> Do you think it's best for us to submit [1-3] for -stable backporting?
>
> Is it feasible to come up with a set of small little fixes to get
> -stable out of trouble and then to prepare broader updates for our
> ongoing mainline development?

Please see [1]. I don't think it'll be easy to come up with a complete
set of small fixes to fix all the issues that are fixed here.

>
> If it's "shut up Andrew you're always saying that" then OK, I can take
> that :)

[1] https://lore.kernel.org/all/CAEvNRgHbzY30n1hz2vv7BiBMMhci+NEv_ubP1LjQNmBuu6Kjgw@mail.gmail.com/

