Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DBF4FF885A
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C4A6B0005; Fri, 24 Apr 2026 17:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE116B008A; Fri, 24 Apr 2026 17:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBAD6B008C; Fri, 24 Apr 2026 17:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 686686B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:29:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05C3A4010A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:29:04 +0000 (UTC)
X-FDA: 84694739808.01.AE4663E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8210AA0002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:29:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/Uk8OT6";
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777066141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tXnAyR3M5cJTscCoBgY20NRui5GnKz1WT/QsmR6338=;
	b=Bx8x/WQaKIl+IkODr/bcLZhUvV58WFgawgvNBQd9X7V33Ka6rFMxEJUX9+W2TPsbN+6EJ2
	xwxUABKOxgdRuUJLfIHbkt4SUE+M1wJnM1bj3ZF14hazNRFQ/LCVVyJ/lL/Ak+Vqne1dRG
	GgfQPBBpfk4j4igTJwm3UphXCCGlhdY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/Uk8OT6";
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777066141; a=rsa-sha256;
	cv=none;
	b=V1prdQ+DDRkrN8nssfxtlt4081Epcpkii9ZFa247gHzz8r+WvhlWPLLd+gdoaWD2L08VLP
	Go5ngSuPcxJCB51KqtIsOPJmzNrHIsW7flu5N4782q4+ovHsOE+sfmlVVUFQEqR37RwK+g
	Mc4fe8lzUEbGQ4gKohjDXI6JRP1VXtw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777066140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/tXnAyR3M5cJTscCoBgY20NRui5GnKz1WT/QsmR6338=;
	b=X/Uk8OT6hIUowuz/rcEp5BXkGbV7tieFK3r5ubisZTVAwWZbSIejtrTvHV5MByUWfIoGqs
	vlg4Xx/suffMdAtctPEoiiBtZQt1cU1JppzjC5gXdm6Iaw1pMvdQRzdSr9B0nJXy4ebUYC
	psQ4Ti6/vNQpuIWYOwI+MZz+qiJE4As=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-R7McZTRUMK2-NkmUQ4tYxQ-1; Fri, 24 Apr 2026 17:28:59 -0400
X-MC-Unique: R7McZTRUMK2-NkmUQ4tYxQ-1
X-Mimecast-MFC-AGG-ID: R7McZTRUMK2-NkmUQ4tYxQ_1777066138
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a124b5672aso7134563e87.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:28:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777066138; x=1777670938;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/tXnAyR3M5cJTscCoBgY20NRui5GnKz1WT/QsmR6338=;
        b=BBome43+9eED/iMVmulXzl5bWt4riNsia8uFlKECzkzOnpwMweNX6w+MQ6csSjd6y3
         GXcZlszgBiTt2JghaxXVS7toe1+7IDYJaRHDQFRrJ3bJEz0+LXU8nASuwa3juv9LEHSm
         +zzheucrnXMKPA1sdllHJtGaWUvn0EJwR5JXI+IkQydAW1wOaLufZ2h8HSSQ4kETPUeF
         NKvDAWrlCFE/ae+adYqg3pZ1qhvBawxbCXLEB3Yy6OVlKA15d9qxHSlIeVGqs1UbFm38
         JgaKdMVlLrETuYSDJlERZ1csdWEiTY+15hyUMxsish42WLVc33aPGHgdsugJJrdq+vkX
         S0hw==
X-Forwarded-Encrypted: i=1; AFNElJ8r+i/SQgPHM7fETgHSNjfi9ywM85atOwHWwEJCX4NqjPz6LlQ+OBCWMRkcK0vS78Z5UHyw+R87JQ==@kvack.org
X-Gm-Message-State: AOJu0YwT/6+0AHpjqAs+YwqKJTACNQVW9lVBmug3O3B7DqBwou1SPSJU
	RD1c3rxeXxDWww/EuOM3Ru2ct4Q+VyWjabZxbmIn2nxz/1YVs07L2bXhaS98WIlVYl3UtFNMVpT
	jFE7ySgHfytuwCSqJs7tQ7S4GH9hbYXswnwOVjJRYM/Ny3hyiagw=
X-Gm-Gg: AeBDietdr2ujTjS+gXcV1luGShZFvcvkyUxrorGmlZzQWG1VoDJ4BFVcGxuC4yM4biX
	zu7aYHkUczSc9Co84MpgiF0/drq3krdAGAvV4tAet5ttOKlkJ2L21gv+lyiOwH4ctSsE/6gTgIQ
	0Qai8Y4qPFiFbTHDJHcjYJqwXw08w+lqDDsMGwa9IgxEYDqHf6c6mV04WGMLz1w5AunYvamWWWM
	rXQ2yhwm8xK0/tpPP3Yi6qItPZ7YOXpeBlPkDkUzxg7bjCNhLRRWacoZUK8QSIvnO1M432UfXzl
	vRyK/jkzBDriirVGGtcmIGU4U80hsRS4XJjmRIyZLyV4fQONmWC4XA7KgzBSmY8MYDYl9KOLjeN
	Z31UX7OhwCN64qGSSMch32uyPyVHQKGqsl2wF55UrRNXySPoE00kt26DkRA==
X-Received: by 2002:a05:6512:1189:b0:5a3:d1d0:543e with SMTP id 2adb3069b0e04-5a4172e876bmr12367590e87.36.1777066137916;
        Fri, 24 Apr 2026 14:28:57 -0700 (PDT)
X-Received: by 2002:a05:6512:1189:b0:5a3:d1d0:543e with SMTP id 2adb3069b0e04-5a4172e876bmr12367581e87.36.1777066137381;
        Fri, 24 Apr 2026 14:28:57 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4187e7ad0sm6197416e87.58.2026.04.24.14.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 14:28:52 -0700 (PDT)
Message-ID: <55de9b82-5a16-4d4f-8729-db7f2ccfa0eb@redhat.com>
Date: Sat, 25 Apr 2026 00:28:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] Migrate on fault for device pages
To: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260414041226.1539439-1-mpenttil@redhat.com>
 <20260424092336.7f8f5b0c00f4b46f9e0879d9@linux-foundation.org>
 <3faef07e-5093-4d9f-bb1f-e9a1f2dc6100@redhat.com>
 <aevfOMdaANt0lAUo@gsse-cloud1.jf.intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <aevfOMdaANt0lAUo@gsse-cloud1.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1wzVcPtk5l-p0QZ71ro1lFIAqSS2Q4DqMZqehR-odrU_1777066138
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8210AA0002
X-Rspamd-Server: rspam06
X-Stat-Signature: aqqsqbre7mco5kf7z43waszssjhuj974
X-HE-Tag: 1777066141-596522
X-HE-Meta: U2FsdGVkX18IQpdmwX8M5ZatAVCRu0jDzxcdPpW+w14eSydz/Z1GA1HOWlJURrnOM54pLwtG7fSzFiWvAt04Gf0DL+72xTp3dXuTtogvDx1ewe0Tdf+NCIw43zPxh0+p5SlrTVXD8PCE4owH4Ew/q5mWG0cCsmJN42HLpSxWlm3Abdyg93KAlCpbr3JViUJVukJ3FmZ3qjOlKY9AQN7lUiiTjShJpJ1ZzFn0Yuh9fKZ/K/wj2Sa/CNaqPa0j7nXQVFhOVCA5HnwQjv931SUr1nmlid7CSA4EvxAyJguaRMFF/iBuHpjeHRiaBOpvEjPGqZw86HBlnjDPo36DMY2kjCksGtotebqrrV8mZAdNIOPffh71EpkYo8k2+f2r7Npbv4cXEU+H5I8C3L4Kn0rxYhiyyub7Bof4RU4rEvCWIdDg+HpFdH5IAAiBcaUmKUsZvNQ71PE0XTcgg65TYzy+C0hsOudKqQgUmf1+YJe3zQzInJdQP5wFK4+R2YFLrhWS1sl6hiO2GTLSLDN6fx3CfoGYqXhz/GFNdzKhUNLZ5hpPAsxMbJz/WnoKhNQeyiEhXnCVlWY41LeGOrngH9pMEojGJPMXLEi7acVVM5c5a0HigQSodH5uxIffHwnidvGzlKVaKg2q9BXvZLhLTdutAdoEKhTm8F0TdGiMbb/asOk6WfGooWkOjbwf62H+pkjjrkjWbB1dQws1QEtRiMNxteM5FnKlCI9KgG7GqGND1QGOQhWRdG3+HUv2ldsDZ/1NGf8zDrosn3CILLLX9/FLeQfWVkJGo0GOX/5WU25VDGS2EFKoUBFYhLyT85ffoS297HkmQHC2Msoz1KVzuIwasJ871HeMuSOqPcH/LEqUWtsmk5e8DQXLCHSBS9rwm60HM5kIq8EvNXOEWKWexUUkymSG+WGKyO3duqA8jfTUQWrKxSWIUvTMWHKKhU8RWmR88i9w/NhjCrDux/JizkB
 HrkzvdSx
 oKViE3lhTgserGCrNncCkdIjU9f9bb1Ta3HBL50kRZ2hPJ9zfDcwQZ1Yter5ZgRdl8R8YEr3zybVc7FaaxreHpPxBeVoW1ruBZ4Jzt/ktbFD9I6mWo5WhSv8ZkzTdZ/mKVfKTmdk/RSECLTBblj4tz6CQx5855tiNWlK/7JEQBC1MUS1HuIhpmBaJwa+T8UeYQgMgy2O8NggBvwrh0GX+KBO04g9jcLYlz4vdVBt0OEEXYigbyy1VALsB5gaXV/h2MYuskMfEGkckkBwfaZtsYn6q4MPvvr3tCWkbZGOko3Opb9SV4kW2tfGTUmgPPU87x5qlUgP4Wx/JjPjIsCEyGcBjajoQudh8VKFl/+arkD8Wx1Gzs0Y5WvyEnS4lyAFoewEPYjEdK4VutVD9YrmT1RZsghwoMY6vc7jAaOHBTn9ewe6/AiwG+Od+tr926458JZXt29MfPkdISsx4DaGfaNO7Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/25/26 00:23, Matthew Brost wrote:

> On Fri, Apr 24, 2026 at 07:50:37PM +0300, Mika Penttilä wrote:
>> On 4/24/26 19:23, Andrew Morton wrote:
>>
>>> On Tue, 14 Apr 2026 07:12:21 +0300 mpenttil@redhat.com wrote:
>>>
>>>> From: Mika Penttilä <mpenttil@redhat.com>
>>>>
>>>> Currently, the way device page faulting and migration works
>>>> is not optimal, if you want to do both fault handling and
>>>> migration at once.
>>>>
>>>> Being able to migrate not present pages (or pages mapped with incorrect
>>>> permissions, eg. COW) to the GPU requires doing either of the
>>>> following sequences:
>>>>
>>>> ...
>>>>
>>> Via which tree would it be best to upstream this?
>>>
>>>>  include/linux/hmm.h                    |  19 +-
>>>>  include/linux/migrate.h                |  26 +-
>>>>  lib/test_hmm.c                         | 101 ++-
>>>>  lib/test_hmm_uapi.h                    |  19 +-
>>>>  mm/Kconfig                             |   2 +
>>>>  mm/hmm.c                               | 821 +++++++++++++++++++++++--
>>>>  mm/migrate_device.c                    | 589 +++---------------
>>>>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>>>>  8 files changed, 1053 insertions(+), 578 deletions(-)
>>> Looks like mm.git.
>>>
>>> It might be more useful to add it to a DRM tree if there's ongoing
>>> development against this.  But please no upstreaming without good
>>> review!
>>>
>>> Anyway, this is a bit dated and Sashiko AI review wasn't able to apply
>>> the patches.  Nor was it able to apply v7 or v6.  So please refresh,
>>> retest, resend?
>> It is against Linus tree v7.0, base-commit: 028ef9c96e96197026887c0f092424679298aae8,
>> but applies and passes hmm selftests on mm trees as is.
>>
>> I plan to do v9 refresh and maybe minor updates in week or so.
>>
> It might be good to send a version which applies to drm-tip to
> intel-xe@lists.freedesktop.org to trigger our CI too. I know tested an
> earlier rev and everything seemed to be working but another round of
> testing before merging is likely a good idea.
>
> Matt

Sure, will do that, thanks!

--Mika


