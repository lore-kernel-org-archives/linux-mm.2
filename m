Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31BDC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66996B008C; Mon, 14 Sep 2026 12:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10FF6B0093; Mon, 14 Sep 2026 12:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01A16B0095; Mon, 14 Sep 2026 12:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 771036B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2293C01E9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:30:52 +0000 (UTC)
X-FDA: 85212906744.15.CC79FB9
Received: from mail-vs2-f43.google.com (mail-vs2-f43.google.com [74.125.227.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8BBE01C0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:30:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rJYHfa8d;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 74.125.227.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rJYHfa8d;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 74.125.227.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789403450;
	b=y7WqATBXWMXU23QOqFpMlSiBUvuscwuc8ckyNCzMq9SObhs5V8pcV3xDS7wo3hzCKvt0CY
	zN4qqjXeCHkA2WBStOz7uFn4NU1rAvP+5Uk2fD7PTe3ZjNm6rRv1aj2DE47y4hC1jfM+nB
	7PUcGSuHekoAXfBot2ZrbsicIoHK3ns=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789403450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSenOVdio0MTk3GC6131u10bA8proRI6SzfxE3M5VwI=;
	b=VcTnk3WTg9iVdE5mdLB48HOENXKc203l5G6OHRbP1zdwhGqAwZAkC2ClvWOiL1E/rFHaqv
	jfrDN54kDUoq5RmpPQIszlp9gPxnyD88AFq0iCN7UAvvTeJdcigktWgnEqKAB0GBun60yA
	mVRgny2drNZm4eGBtkT3DMF3SBeKAqM=
Received: by mail-vs2-f43.google.com with SMTP id ada2fe7eead31-7935ecb5d8fso616979137.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:30:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789403450; cv=none;
        d=google.com; s=arc-20260327;
        b=oxOy09S9rmlUXlxDm4xsu9hatXpnvHIHxBSv5NDv7BP4eoY0bQpqO27XJGcMoGlvQa
         SZ3WKpNrSHpZS2nKvzxbJtnIPcupdvlc18elUom1DHpznCWihBl6TvMzieDKC11KjqgB
         gR08kVmiBAFdbQrIAm5CpyLH8OlJJh1CtAs+JudqdfDVCH3SfIkwOtM/KsAo+2x52J3p
         bZwNZpUYK8mbjE4oG4zRibmiQTqKOgunvvnnT2xRmdK5Py7bwBq0XNlpPXig5HAhppYF
         YUcN4avhmqKkiUyXx2CTQ9efqtwQDoyEv1PRvgyhNCRFD+3bhJV1Y8Gt2WzI3myQO4t7
         0x5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=XSenOVdio0MTk3GC6131u10bA8proRI6SzfxE3M5VwI=;
        fh=ivz4uBP3Amh6ZrHiIaCITNGZ+lebPQsx0udQO8LvXEI=;
        b=OHW02qU6m3C0Kvs4NGhNIVSQZ3fNdIWjBCLdKIea6caKbU8qSjqfV3LF2CXUmSWEDu
         /FPPtgpbb2rJOmRTq6HY8n57P06Usk8JbnR47nafKK3yCG8JMg33Y+RQJYZppx7wiswF
         Jf4mXbSmFPphJFVmUlIV/ImS5u6KUoOcAVXNjJugkVH3WZS6YJJOMMXXz4aiLFHV6/7C
         XmbYC+vljon6xIga/C59X0dj/wQ269eoKOb6hOoCBqmVhSBpo7TYWrFUUoNz0pAFMJAr
         RaviJO7l+AutRpUw/nrPYwuUO22qtgz5fSZV7mAqdgTHL1bCGU2wllu7d+Vgh1BgzGhA
         auzA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789403450; x=1790008250; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XSenOVdio0MTk3GC6131u10bA8proRI6SzfxE3M5VwI=;
        b=rJYHfa8dZzo6qvOy32M2s1JV8xfSaeuklL2yCfs/YC6r8QruZ0DbKmnTwBlmvQU/9a
         JoQhavTUFx/puNp9Q6Edyj0IX4zpmH1z03KgLmj9gNHhMc3DaClaVN90+A7ttF4n2PDe
         46urdrl6rNrMGkDTX77vApIueZuPYRmqOg3UNjc8NCVmgBJV4W9ylct1vMzGl+Iq0BPu
         3X3b0vFXLMUKH7IEg8P2VBV0H3Okqmr9PmrlVAj+9I9DVE7Amt448Y4uTmc/u9K7pBZe
         Snna4tgNr9CO2aReCeKVqXcU79mn40RHCiDHAPVvwHOrzIfoNZZ2Zyl4Yp82ibuctjXZ
         wNpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789403450; x=1790008250;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XSenOVdio0MTk3GC6131u10bA8proRI6SzfxE3M5VwI=;
        b=Mg7q8ky0Nr9GsWOD8pR00Etz3Qtrw67KslpjHbAyfTgkvzmVT42Co3SXrwBlvcxJG1
         fawbKLRe+thUiqgqKU+hLHlvf8mGwJOgd5/1IczwkNT1OZVOx81xiw1tdxNtoKjxRyaO
         e4WtDpR3L80DH259N4gKTw3F5ueYh+17IsbIaGW4hjTybS3yZoE+I9taVl9YLoodfzK3
         7ZTSQeso7NBGlLLZvjZt/UO7FPAYSMxa+rXYzYCujcaBF6ui7IqzwXlS2OKiVJs+lcM2
         s1uKX7Vsp8+Bvr2lTeSSIWAgvLDHVCCs9Da3qg3j+cTkL0Yvs/cGovDn73Cm4mcuL3Bf
         fWCA==
X-Forwarded-Encrypted: i=1; AKwUvBw9TjYx+QHN5zJMkYDSiOdGHk8Y3VOPYLVR0YAhhv8IdfyM69G3iU2ht+K17sFf3zeP9JBdLzIIpw==@kvack.org
X-Gm-Message-State: AFuF++mxtxjJTmSep/s1OsW1yjqqHbEnG6tz5zOz/yw6AS+fPmy05wtr
	6tdQ7ikEOdUFtD1Zwx7kBxiymyf4iHTfLgVaACdwTUmuEbSEL4r3HnxuZdKtnsBqac2BsUa1yvk
	N7WUkgGHetdJ/tBMAUkZzNYAu8ffRAXQjtth8vZVO
X-Gm-Gg: AYBFou3KkdfI6y650FWAnmxopooi4GNRIlg7rXe24TYKkfU1+V480FOStAaXFFWCruS
	TdhBLwLhQbfInqJoLcjecUxhzX8SF7uvoZGuwmsejRd1ygseRPwb7K2/6DtTIqFWINY+D47g+xo
	OefLTcQzOmuBijhaq78Fc/9wjPq8xl5G7EO7YaQfr0kkX+YYbeOXxiEWv9BbXxxbUb5/JPbB27F
	ISbHvS6AzbvCWKCP9MUKKjKhplAgDEd+NTH4VlTZN7ssANsAEGJhlTTXgW6j/OtSAOaFn7a80ur
	R4l39T3sDJcz2sMfDAFBUnG9pxRx7DqztOauXlpJUVuvEg/sh9X4WzI3MY/4oxn5irbuuAjQ7Je
	8k+2xuxqzgHR9CnsIODci5A==
X-Received: by 2002:a05:6102:511f:b0:785:d308:cc0a with SMTP id
 ada2fe7eead31-79b5b2909fbmr3656947137.9.1789403448800; Mon, 14 Sep 2026
 09:30:48 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 09:30:47 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 09:30:47 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgEwbUXj5cVQq4A-U=AMOzP3S1mjnrOC79Li71wf-E+dDw@mail.gmail.com>
References: <20260909-hugetlb-subpool-always-track-used-v2-0-30c5d83b572a@google.com>
 <20260909155003.e6c2f4fe3c0bbee3b34578fd@linux-foundation.org> <CAEvNRgEwbUXj5cVQq4A-U=AMOzP3S1mjnrOC79Li71wf-E+dDw@mail.gmail.com>
MIME-Version: 1.0
Date: Mon, 14 Sep 2026 09:30:47 -0700
X-Gm-Features: AcwNN1XXPLdtIsXucpy4FdPGkhqMrtzwEGfBrz_XeIOSoKwnvb1TbO6LQoI4Y4A
Message-ID: <CAEvNRgHPGzfyr5Uuir2QoLqSNTkspkn3yJ5CTz7rAQmREe2Apw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 8BBE01C0002
X-Stat-Signature: nick7zufe3myi788afx35i95nw7n3dga
X-Rspamd-Server: rspam01
X-HE-Tag: 1789403450-425922
X-HE-Meta: U2FsdGVkX1+RW/A4hpnkpj9nX6WlLWAFT070mitsKCvuv2lNOKMMD9yfF/M5OgNDfDn14OfeMMvtRhRzOyvlRW+e3K3fNGbfXU+9fmGORbPb/TBtsJpPMEUsrlhVqXbb3faQONEfBu5q5CrdM+GnfO7I3Uf9n9gPWYYsljk3yms7G9OrZsQDLluMbC/48w/eHzhJYKXASFlgIFvB3+8p+t0+LJbr5pYvSBJWBUb7sJGizQwC87xK7kAo/MfvmFJmKjPBJ2dEBhYr4kerjRV5oQKoq0KsSYDrhRJu1gWp726rbb0M9MuaICeB3Bkbnuggj4hvhYepcy73oA0JKg4UTakzvYteo9h32SbblIiGVZAmJk9KdPaGNs2obzDfgVzwoQzy+EjzIhNMMLVtavdMMhCO6hlJmc9j8AyreCb6amyXjfo+PymCL31LH46QDHXYtczX4JsLBtSPGonq3foPvldVq23seu363wZEuP1qT/Y22x7Nrt0FbrJDJlFXh5S6bN3+B4Om4i0/vCSPXm0ZG70OtkNvSfJnKI1/1u9okK4yhTYdJvWcVomlBNhve3echJOSI2vm2EhQKOaYGwH0LqYVeTF+6U1YZuiK/0VuPlKBoRjbFoB4bN6A3NRKkPdbonJwpd6uP6t02y3ZtfIhze8qvYJJY/iSfAJyIWsI4ThJOnefnyJWQeEscWG71uU93x6ZW7Ni869m/PXXuObz/6pIpqJIT0MvsuD/cSlcPKJ3Wic0q8ZjYWYPrp9iuXr8zEzSieUGk/HEU8m54RFjYNL2pyZLKpQWN+nmB6ae3rECa4TZV30ay9k/nrQIJUMQch1B9LF3txvIlBN/U8mwoIiV2PWcPCl5r3rGQ8KNVVxODiKBwYeSe42MVVhO51CnVkBAuXd6hUZLoThFXAt5h0JxjERqJggchqVxjNQ1p+Ab6JbLkgvwQNcBBWiV9lGnzdHpC5kIUCtKVCBPrAa
 87MVKeXR
 d5Zw8RQ/XJikoqnBHDIEWhck1/Fo1KaxpISLIRm+AMJ88i9OLOc7yKIRXQXg6NUwyZIyJ+dWV7vy2Lij/6jVOf0qPX6IYPbVtvLhPPjYLl8Ita/1RUNi6tajSmARWOStHyRk6vwrhN15GlH9+saclfcQln7P0ZHDWz6nLjfhKOhR89g6yZvRSwKIeV7OhlqK54ouMFbX02PMSAWMxuuBDLRPHtTJpNKNjTHam8zMiKUn0ZOwf9jsmcwaqeDyPRFvuccm7InLQFyqwK8aJGj9FInTSyaZpG6l+wqrSZ1bGiwibCYTblU6wBLAQt77CjFoE0kE4uvBhV1Ee3eTdj2CM/VveyL49yZr+LhHeO476ZRza4srs7bzT11GKT0CdrEottOcjzUjxUtCL36296rIwb/v2s0pikbIkn6Trhkl+JzJox5z6HFrgOGmpgjdUv2AY/9ApKvGST2RViOMfP7hAHL6cvqy5QCuyqK/2OqJlwjSMQCXwVFPFm77AduWcnsmr2PnBuJpzdgCLgQgwej1no8vorq3fL68BDwcJRbO7eFosadzpnSKRs9WtFyKpe6ihxDLw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Andrew Morton <akpm@linux-foundation.org> writes:
>
>> On Wed, 09 Sep 2026 14:49:25 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:
>>
>>> HugeTLB subpools currently only track used_hpages when the user configures
>>> a size limit.
>>>
>>> This is buggy since when there are existing allocations from the subpool
>>> that would have satisfied the minimum reservations,
>>> hugepage_subpool_put_pages() will still restore a reservation to the
>>> subpool. See below for an example of a false reservation.
>
> "false reservation" should have read "false reservation
> restoration". Will fix in the next revision.
>
>>
>> That sounds annoying, although isn't clear how this affects end-users.
>>
>
> I'll also add this to next revision:
>
> hugepage_subpool_put_pages() falsely absorbing reservations (aka
> reservations being falsely restored to the subpool) means
> hugepage_subpool_put_pages() will return 0, and h->resv_huge_pages won't
> be decremented. The page(s) still being reserved in h->resv_huge_pages
> means fewer HugeTLB page(s) for use in the entire host.
>
>>> In addition, the subpool is considered free prematurely, is freed, and this
>>> ends up causing a use-after-free.
>>
>> That sounds alarming.
>>
>> Do you think it's best for us to submit [1-3] for -stable backporting?
>>
>> Is it feasible to come up with a set of small little fixes to get
>> -stable out of trouble and then to prepare broader updates for our
>> ongoing mainline development?
>
> Please see [1]. I don't think it'll be easy to come up with a complete
> set of small fixes to fix all the issues that are fixed here.
>

I'm hoping this will make it to 7.4 and it's 7.3-rc3 now, so I'll respin
perhaps tomorrow or so if people are ok with the suggestions on the 4
patches or if there are no objections!

>>
>> If it's "shut up Andrew you're always saying that" then OK, I can take
>> that :)
>
> [1] https://lore.kernel.org/all/CAEvNRgHbzY30n1hz2vv7BiBMMhci+NEv_ubP1LjQNmBuu6Kjgw@mail.gmail.com/

