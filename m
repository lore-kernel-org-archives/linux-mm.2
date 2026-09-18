Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 240E6C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA4E6B0088; Fri, 18 Sep 2026 14:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A7A6B008A; Fri, 18 Sep 2026 14:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248F96B00AA; Fri, 18 Sep 2026 14:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07A766B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:08:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9109C1A0735
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:08:03 +0000 (UTC)
X-FDA: 85227666846.25.97F9735
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE53540007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:08:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nbpvHK4W;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789754881;
	b=Cdd3KFLo6VFkAnWfNUEl+mU1ZWw3whKUPOQ+or/TV8QVBUSk/M2KY9qlYOsb7Cl80piqIe
	LaZoYmqunZidPlNfKNNq1yP338QZULVJrvIbtMnlBvr3pgjH+jm0xa3wSKw3VF3Iz7M+Kp
	etg9UbdtUrtABqjGYwquWWRAmvMsys4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nbpvHK4W;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789754881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrQsHhy6u3WkbV5pxscEOWCkYhTAD9EPZK+ycsiqyqo=;
	b=C/mt9iH/mdH/CaSUJm9J01EK+C2lYQP/BhIaWALwajP8TTHCXzUjFfexDak1i6ij1fPs9L
	c2oE1ZQ6A7SDi3r2IO7UCkbxTQugCxEo9cXDzJnhK5aasjuw/mT84c5sgnlYas4735IERA
	N6Ei4EMt8JbTvGP/NSYRkxFNN4XuTPM=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d822dso7627815e9.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:08:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789754880; cv=none;
        d=google.com; s=arc-20260327;
        b=m2EEUb88gcs/CaQOvKwCMc6f1xHxpJyrDycesUYic8TaW7zfS9Giw5L37mNfpjkjG+
         kmYz8Pyd5MqQRHRrfEcbmYsUv1oeAGvgeIsB13rzA22a4Cu31xWD/tSBz56mJlyCzIbN
         7YoMBBlZS8g/2IvMgcBpRCgnqBlNHhesTUuDoYee4Do6L+jAU29F/vmfucLnjDk+7QDy
         mk1Ll+JNIOB1WZkWuCFiZVgJ4jh115sj3pf3s3l2z5sOIMrBjFEL1GIZR07wW42Levkl
         CvdxsUw/w6+qlK3RBSVm8KkqQhKvYXpLjK7JgcqeqOG7mo0Q8fyzFFuyBRGLVzYJZ0TP
         Nktw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yrQsHhy6u3WkbV5pxscEOWCkYhTAD9EPZK+ycsiqyqo=;
        fh=Mku5TSMXRT2R+rAT9VVy4aA5vRpquE1HQUuZQk8RgVc=;
        b=mJoISsSC2wGo5t2e4rPoLg5cZYQiVMYSlogd9SzbV65AQE2j3vmZUpKzUDm6wU+zu9
         UFBCWbcfiy00xYT9i5nqGpLixhrjx7mT6iIAxyIodWvvn9W/cZXqCwAOdEEViTzoR1m+
         TuC/ggGwIP/IgwEDlzHCT4oFc8H/gCsvic6lBeqzO9ouWZ2tTabvvK8OUDCEYso+sNui
         Knge8Hwc667mqkDS333L+1wyF6GcOvCkWnskTfgt6HBorz2OHqc3hLxEy/DdyYYVo6S3
         cJFvV0pchW/NCcfQEA8sobowkwBcSgS4odG/V5bdpsP8iJITe0IlCDeo7dhL/S8s1vBt
         YGag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754880; x=1790359680; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yrQsHhy6u3WkbV5pxscEOWCkYhTAD9EPZK+ycsiqyqo=;
        b=nbpvHK4Wa5czftozqRemBJiTnnXwavujzTujF7r35j0jY0LhkKwz7xgYsjlh8xl2n2
         06ZDFA6pApH4U/uq/QFXRkIUMgoYuZl7JLxGG01qpkHWlx+GbHAY3vNmJXjRuW4n+52B
         +PUE43NLJXZmqrX3B32C88Ztw6lWSJC/hQpSHJ2VUe0FUZB3rJJiKb4an7jYjJNLuiXM
         R5Uck6iaUjwvY6tNOXNbrVozboofKxihraw2ULOG2NytJ9ZkbRolB8zVHUgLneXe+5nX
         yXCXb3W3rjHkPfpgNILY1P2N9XwCOjMRYZ6j75jM7HBtvJVAN17NfnKqbdhR/aM7wSiD
         ijJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754880; x=1790359680;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yrQsHhy6u3WkbV5pxscEOWCkYhTAD9EPZK+ycsiqyqo=;
        b=eD9FjEEggDziOoVEf+pRllfL3SGz2GiaGOAMpEYYOOYTQ32BCEkYtldpgb3e5B0kw8
         3g6hIgu+cfgoMcBLX88CzJi0sfvbdx1yc1/hqLuv8EY/yVr3fks1CmqqEvravnPtMnCu
         +RWKTZDcv0n3A8paF7ezmIRctPpCM53mWtFAVXeOtRf+YJa840kfKdazV3pWqOHJuBlD
         A0ATbUvnUpK7qdICWmAZVhnrYiLVO/2rxtLtzZeSbksjDgRddDvJnuCSpqgIINRewehM
         FoGYysO3fIDd79P3HiFNtmUjwGkaZMbS1o/Q2o2KsOK+Q+0hTTyVfHpkjl0b5QgKzgzC
         sDyg==
X-Gm-Message-State: AFuF++kZlW50FtO5NIDm9U8bQKw1SW3GIHA0HqMNoJb/93TlYXy2nL7e
	LjXxCyi9vIBM73mvnJucNGoBUBRwekA7Q47gFOvzSjanSbfDJGIxCnP6hvCBbJ/qsJlqZMtIP9w
	NiNlglMAi0jgBnP1ZzDm2yztx7DiCOvw=
X-Gm-Gg: AYBFou2svMeJask09z0NWw4uI4EoJgejl/iWE8s63IlNZJnOGKqaApiUNuj8IZMIlto
	1xaU+irAr7VwEQ/jiQE12Xa9tXPhAKeqQzwpgurgjx3mIBx/0vbfRzUc5odhW+JRPQ3x+9W0pKO
	3Tk42XnBAUDwdvH7lLcJV03mHJZzCwhnpkpwoc6LXMsOhRzssj/s47LHgIECH6Y5pUpYsLEe75F
	KsMjQTDv4IbuM+6CJJeJ1VBw/vwUFFodldNxSuZo9KfCSIW7Xop1uVpIDL5s9Qg3RMphsO3TiWz
	ek0AWNSx4pQmTtIWjvWu95bRY/e1Z5vZQpRm95vEHrX6iu5sIV/5je0/S1YLghSQD9nng/ydlT1
	p/xzNttpi1RM=
X-Received: by 2002:a05:600c:c8f:b0:49e:6c9b:4e94 with SMTP id
 5b1f17b1804b1-49fc5743124mr44989645e9.28.1789754879842; Fri, 18 Sep 2026
 11:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <CAKEwX=PEEkYiNRaVhCuM4E6mxB9huPKfkDa4m62VMTzedg1oYw@mail.gmail.com>
In-Reply-To: <CAKEwX=PEEkYiNRaVhCuM4E6mxB9huPKfkDa4m62VMTzedg1oYw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 18 Sep 2026 11:07:48 -0700
X-Gm-Features: AcwNN1XGRA_fvsrUeEhqxwkqGz--tC36CQoczmeazWAt0rrZHU3NzipYJr2xKaU
Message-ID: <CAKEwX=N0FGDH=A9-j7uG6Pf3EqyGWkhqbqdpE7jG7owdzmyeLw@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AE53540007
X-Rspam-User: 
X-Stat-Signature: zxs95zh4a86uk8hrnjwnmh7ximqpguic
X-HE-Tag: 1789754881-173087
X-HE-Meta: U2FsdGVkX18wBzusQrHWCk+bqjARTQON+/lTsNORo33fjnCG+YemmV9eQvy2BUF4UwG7CHohiFYf67qFVAt+lge280auGLGs2z8V8ca3ssgO4eprnFXgRgnB0K+AfLGSD8Vn02NCSKRlnaSgFBAkbU5TBjiqp9QDN4Rgmm2w+stjIlmweOzSDG5+K9ioIPtoexkBbbhfV4lJjpP6vutMT+eNusU1DOhyS8+5rTTASHAGLtAEVIuY4dj7AqU6Cy9DUyrYJBH3X6k9HUJuGDDhxrO/oVc8ovf9v1WUdjaTmAJCjU3arYTiJeSityu9kMwjRWiVPmH9JpE/LsMQY15OiTVNvc1zjIzcct15Q1uFIkeeCQkP3BT9N/joTFJkeeQ3Usxzc0+BTRJ8BN3xwY5HE2kkJJ+ilziZ4SpmGAGi7hBZ1FMM/qdIUfuWwhbsntZ8wCuhZWgsYtnvkm7cwnmaPNO9OJascaHLhpBgNRbaInBQwsQrD1EQxkgzWx9Sv8UcIxd06hJsnAF9Ca7YZ3HBwKlZzkE+wm323f3VX/fK4VOEOrEaxabjoDT23LSU/BA4AeFoocxpT7K/YgJ8Qq2+FpVjyB4z39K9FhxSIdBiMiGuR9SLKMUgXOq2wz/+y0AY+DXOnBZog1eEeQu7AG+tT3Z2e2BaqR9p0wjpRtHxYhSorDiEC+TkQEl/PP4nURzvq0JNtbgTM6HJzZ2nX+zlYJ7JI5e+Y3AMSI7UWcCZG5IsP7UuifJwR1Bu0rzph5oGvcLQ5wvFqZrysPLVl4FXqlunDwMof9bLKHA4nsjbIffccwhcD78gaxhG0lGAa8n1zvX78Vlbdb+AfPOXLp34XMUJXX2eyP2MO1/Md9RAk/XULe0aZUVXnmaqHlipViZOovcCrwiBTyhriPWhKw4W00A+ULDOM5Wyr6mtrg++jZgpZ295R+t6JmIRdYRy3Jg4Pg5aMlO0vB9KuI9pkGY
 UhVH72u/
 JR7EdBcQddBVWCtEoyu1TphMhrDLfLrfWVMTWCTa5TTcicCZ/ck2tJqRQVdkaprkJ7g6h1EVrK1owez/RpGXZ8/X7Q7b9GPdb5a8/0aAokswask081fQ4tk2OYRK1SUmbizdPMwQUASqpxzkMcjy//6HHp87gsp+z68+L4IPAN2IbSrievosUV26DRna7JjvplwUYROtwh1qUBD8x4IJqIOJwKqfl1Ng6ZsS5KWfBsGr78iGAMDRvEf+HJaik5R60kx2bbEJGBFnhu1rZS0vOdCkQ8ejSZCeQ/kD0oHY51/TBTXwV5poc5kjG8gGWyZsRAi/GcKXkJ6wxcK7vn3Lmk5kxdNhP2VoRV7MLVto7cSU99BMiGn0aDRotfYBHtV2NLLfld0ke3fxLntCW7ghYHnIh2Pznb10SmgxFZJ4ITfq18mKkw9znW5127mXoJEEATZTpVP02Aq+U9KEgTiErdMd/OZ+XeNrczWgXm8QVxNyTpQ6J+rZtUpxydc0oFrgssvQDdeW1pTRAeDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 5:13=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Sep 16, 2026 at 3:19=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn>=
 wrote:
>
> Constraint liberates; liberty constrains.
>
> So let me flip it on its head. What if we keep the interface I already
> have, and use your data structure instead? I tried that too [2], and it
> was significantly easier, because it is just a data structure change,
> without having to accomodate for the full interface of swap device.

Here's an updated version of this proposal:

https://lore.kernel.org/all/20260918180241.3424851-12-nphamcs@gmail.com/

Per your earlier request, I also:

1. Moved the virtual_table inside struct swap_cluster_info (since the
virtual table is the only new field now), and deleted the new dynamic
cluster struct.

2. I skip the shrinking mechanism, but instead I dynamically freed the
virtual table to minimize metadata overhead of free clusters.

I have not run performance tests yet, but it has survived a couple of
simple stress test rounds that I threw at it so far.

If you think this is a good proposal, please pick it up and drive it.
The code is yours :)

