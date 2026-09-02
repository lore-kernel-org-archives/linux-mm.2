Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ACEBC61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3326B008A; Tue,  1 Sep 2026 20:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D306B008C; Tue,  1 Sep 2026 20:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AEA6B0092; Tue,  1 Sep 2026 20:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 536736B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:54:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D35521205A1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:54:13 +0000 (UTC)
X-FDA: 85167000786.12.B7C348C
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id DF84B20003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:54:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iTPFkk6W;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788310451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20kt/f1ijP4E5zyvH/913zv3ShRzKiUURu6289Mp9FU=;
	b=hfCotsH9n/m8f6qaRNeaZo2GSG5/I6p59621X2ta3pWGTz6nB/SHuu2Gx/z23QzsaZJZPL
	H6XY9xGe39c7bBGe3/s+xnycK9r4AjE9j2BMzgPLxx2Mh8DomXyKC3Z1N/UjgOSGXDNsd+
	EUvRSrHv79DHbEQq5j6HiLcvfWIul7U=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788310451;
	b=OexS8SWZ+v80h9M2uaq5n0MWUqu64e7NyOo8IHzAXR3otb1neegyHf4N6hxzOdaCIuApRT
	KNAH0myB10JmDT5Qddf5I3TAppTd8ZGrxR2CNCbQelY3/u7CrUbX7PGAU60afOC+jO9NHg
	KOog+IgK7t35cFL7ATGkp8bojL6DMnM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iTPFkk6W;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b4b037a2c1so373299e87.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 17:54:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788310450; cv=none;
        d=google.com; s=arc-20260327;
        b=Q5NqOiI0Dt6yCB3+ZFqbou64xsSG2tGhTUcrUxIxrqKWk7ldeeKab7usEp/y2TEltI
         VgGgcXwpWPxUWcELwvBXhJgq8F5FDqwt8nndQ774ZyXLJ8AYhDv6sXOTkzWEIbH37Mk4
         qSIjmUdNVTXTwxHmuP/NzjUFEpXQMd5W7E0g26nmyInYuDu5jrih4X/VOSb3EITG0Haj
         RDjWmKJMugHW5mGGw3q59tVMwkJ+kupRIr3D3IZ9JJH8WBKZz6Q1WZ4WOPsZv4MqvVFj
         LHtXyrJFUI8pK52qqaGHE5thtjU/ZGTn8FJza1CaKgEq3T9i+KmF5hNeVv3VufxNhxVm
         8xRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=20kt/f1ijP4E5zyvH/913zv3ShRzKiUURu6289Mp9FU=;
        fh=LqkD2HpTWMH1sPI+a/o7/Z8RZIhOXK1VICzczZlAml0=;
        b=qxz5EKF7TucXvL7l+DQNHuZTj/8NZ1xJzzrcU73BRJxTCTLhQlb4/a5sPK+lMPYvMr
         m8RBCE5Lpu+iIkhmYsjF78tQTJZlTBuMVxyWazfX+jvGQyBYgDNl+j0b4JSy3RnGPwVS
         xpQ4+ONCfUNphyaQet1mSlZf6hQPWT7alKcZ55NE9SQ/BWkay6ecVfCRROtacc+ENbrK
         amNJPHDtaphOSSOFqEos8hjdyr5XX3UI02p7yPT07zDHgLUULD+M6wCEH7zMGkwFoEKK
         PpbQqJIEJmiH74ap3WO9UKmi/KD0YIFrlUDhXe6PLvupGgkFknJ9l9fx8BycwGgEs9Jl
         Qw9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788310450; x=1788915250; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=20kt/f1ijP4E5zyvH/913zv3ShRzKiUURu6289Mp9FU=;
        b=iTPFkk6WdNxxk/IWwpo5fsnXPMq5aLWDbe7XoFbcKYR0tpAZBsFnckvpdPCz5oQXqN
         B24HBNdk/Y+divgF0vUJiZWr/F0y8rzprlIFc5RApld5i+YEohDOpC2WumjwE+dlnFot
         xAQY2WPZtBmepxze7taDyMroAp4pc7Tr1Bx1yBSnMyfatVoCDgNky5aZCX4A/iZhM5Qw
         T3r6YAsX4uuFOzU/U0omyxdkaPJA7KXa4ItKlNSxj06orgZrQmMarYvjLUGe5qgAJBBU
         Py47/rpOrrLhRgkbgp+idyNTXz9oofhTb88cklKIPp9MkGFHRlEr4Jtlx33vL6D9KSDd
         Nw6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788310450; x=1788915250;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=20kt/f1ijP4E5zyvH/913zv3ShRzKiUURu6289Mp9FU=;
        b=HB4oIiD1gL8narG+f/0l6rkA8FCzfsE6mrFrB71FOLLMTerFzwR52GB2r5Q58w4aBP
         NRCtV1DjO0t9z04XJnEgEWnEBsMmE9oYNXiHtSbLkUzgbdgG4vexW48yRIlK9aXVVkMY
         bbertLLz1vAZ7gbjOYPApRhFhGDpb4olis3iXhMYZdpWNbyevBj+keRLU3v/kfcxdfob
         fIFZHKcVy5+KWotlz/Sayv9bs3xpfFBiT6oGmtBMfn2MC0vwMp28uIv0xsG1toV8cVh0
         xTnvKdiFhQYRIcwbIUCSV+e5OSLELtsmU4WVPMSNTjZj3jkHUENgwhK6tXY+vW4npcdX
         5TBg==
X-Forwarded-Encrypted: i=1; AKwUvByyvZvtaWYYxKaRb6cp+dBH0JTeSXXP9ik+tU7IavGWQGtnV6U1wE5RmHNvU8zLvTFweqNveCCvQA==@kvack.org
X-Gm-Message-State: AFuF++na0aJglQ3QBY1mMYrB1iNyfkS0i3AHidaR6N1sEYfb8ta0d0tB
	gXXRD5PtTACUxSqH5Bwjer6ORE4EFJWiOyxk2A4/lzvIL7rGNXo2XvzxHQnv1zh9GhVOyjsNnfI
	W9/trItVFX9wFPUxL6YTtLzGPKVrIP6Q=
X-Gm-Gg: AYBFou05fCsY0N6UuNSQZ6VIAMQM8Cf4Of1z+NpEWOmRQ8r4M85G84UurTZmvYaHIX8
	qsKH5/vyFKewoxUQuaxWXGBrAyyE5zQDjMtYXT6SrEYXHozsS6vjQ7DQ6ILUUlRKItQu9kZqbCS
	gBoyit7zpzPlODubYjnMuycKfdVR7/TmWz0hSu6yFFs0hLQKROp+zkMVso2Aa+XMtPLRRJ6iz4o
	c5ZUwjP1dX/mX8AJgMcOvioEOe2irpgzHwvWt++wXDUSsIKwEC7y3aP66mes3iuxj30OUNGt41A
	Sq3M7rCVwlbOFDJA+GwZA9I1oEdNOYtTplaOqPFX9TzB/nkirKwC0FKweimUL3wHV5SaulKnwg=
	=
X-Received: by 2002:a05:6512:15a9:b0:5b6:4ae:5b7e with SMTP id
 2adb3069b0e04-5b6087d670dmr333682e87.28.1788310450047; Tue, 01 Sep 2026
 17:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <20260830114731.8322-2-wujianyue000@gmail.com>
 <20260901153852.GH3004@cmpxchg.org>
In-Reply-To: <20260901153852.GH3004@cmpxchg.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 2 Sep 2026 08:53:58 +0800
X-Gm-Features: AcwNN1WdsLO9CXMYEqOR_Ua7Tjqgcr9nM6DFjE7XoaqIlPyPKD-vrcyyMZ7-qdk
Message-ID: <CAJxJ_jh_iQfQzUTFgu6BxmZK+ddQG7sWdL_iFFyb6E2xka9+aQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/3] mm/zswap: release retired pools via
 queue_rcu_work() instead of synchronize_rcu()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF84B20003
X-Stat-Signature: 8yqtnt5est3ffchj3etm5o6xuqrdr4rq
X-Rspam-User: 
X-HE-Tag: 1788310451-845351
X-HE-Meta: U2FsdGVkX19ehaZvkjP4DumZatVWv300yHJj9UA08jgi96CcyRDozJfJ+joLet0UAzgT+nteAnv/fdAn5krf8IBaxRE//E7XTkdB43hRXSrFQcK8HdOS7aQgvdkv4cYoTlUnhHQ2eA88S6OzadU8cWpLDapmBvhw2gl6mogsQvffOIc8d6//QVLjch6M6jy7arVlZLBI7xskG2JhDQW8/6YZaiziP2BM+PWq9XIWwSBUDZ4AhhoA020/iDrpwJkQvDuBPQrq4cqKsbStjmj0TvQIQceZVxh5m567X2bJlvIi1lUl6pk6VxTq78t4lCkNXPc5o5AqDWOOwdAlYnE9aqCnB2iW6d7ls+29LgXQXMgfccD+s3LRARgiz3ZczjTrmZTD3kLQgHxNSVTT7UZ9IFPFBtOMgHzSpYc8GuO041VTd59AjKD4j4d6K2ZQ9bsA8oAdlbvEfnXI/cFaXPhDGgy+BNb5n4eyphD3yaiYlJH0EVaNWpdGg+FZ02p08+IThgaTXEoE41EQ8i/WCrSGqPrf6CRP4pa0292RnpJoEwOPgDsOPLup61eiw4VwUmHNKFks4eH18JtrdIXtKscQB6WfHAh7mQdrhF3F4n7I7OTHVu6eokxAKXpgcEo60O2AKemQTyKDrwfuwIhHkIXI+pWnQ9QOICudGbvfuEAPS7Wejq+pkIgcrUBwA28/IBbJ4SZ/7i+ET422ytI0MTA1a7llHAahP35viCRmSGZ9h9RqFKaHfBtzW5dYFxAJIwiJGGA1FNrHnS5S6Badk+xCxDhJAfp2SuOWJcDq18MGJTrTHVqk79FCwGqfDyC3zERu6xGudk9KSlebLUiE8gbZeE/BRxnFpw0POkOrMrORsrUi1Zl3a9k34UQE3foj37bpfSoM89WCDhJnMNym61qlh35y+7dXQqIPqK4x2H6q+M8gQy7iK6L2ykrnr6HL2OKKOXg9kEYuUVvbJAlWiQv
 VKDhCkl9
 FCx/Hcpjl2mgSckhRWcVSGpB+zzjCePcA9LkCiFfNXatAxVmf+zKchz7TacfTqUBMuQ16bIKuYsZAQ4H1GdOaxnzBzYXSQEF06HV60saoqPl2rhYHaY0VaUlkbzbmwDRlqpJeMgpS1718QtxlvO+9OVQJGBl2mg5jFQE+tVEIgsnhkkq0VSCUUAz8e+kqEClk0/YTGJZaECSDVRazHT+62WZv6S1a5L649M+cO0V0Uwq/fuRMelUyoIk6Zmb430EZ/mfboUxzfe/2UgI5s3lt8+3l7LHiRiR4NAkLZDeAnN6agiD9G7zACCnw2GefnCBr+YKYjiN4J+kiBsXyiXCXMOM9SCMkEwQXSHx+SkgaWBfCr6B9vffm0dhlh2oKOUavIMHetDNITPbq9kURnD6yOTgglKTLlivOk/tYy4UQYeTXm550CWcnAZUz7XwTRVCIICHQTDX6f+LX1WEtxbdOWCmyJ5NVr22mNAr16nCc8ZhJGXk/EdPQhtCg3RYiQiBBmHRC63O75Yy56XLpAEUZfsQZ4tkc3dgIKCA1QiUte8Ow+WiyNgJ2NVBAkC7HK8XL2DaL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 11:38=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Sun, Aug 30, 2026 at 07:47:29PM +0800, Jianyue Wu wrote:
> > When a pool's last reference is dropped, __zswap_pool_empty() removes i=
t
> > from the pool list and schedules __zswap_pool_release(), which calls
> > synchronize_rcu() to wait for readers before tearing the pool down.
> >
> > synchronize_rcu() is a synchronous, potentially long wait.  Replace it
> > with queue_rcu_work(): __zswap_pool_empty() hands the pool to
> > queue_rcu_work(), which waits for a grace period asynchronously and the=
n
> > runs __zswap_pool_release() from a worker for the sleepable teardown
> > (__zswap_pool_empty() can run in atomic context and must not block).
> > The grace-period guarantee is unchanged; the retirement path just no
> > longer blocks on it.
> >
> > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
>
> With "release_rwork",
>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks, I will use release_rwork instead.

Best regards,
Jianyue

