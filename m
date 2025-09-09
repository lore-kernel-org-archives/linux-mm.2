Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34762CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 18:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B068E0005; Tue,  9 Sep 2025 14:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A478E0003; Tue,  9 Sep 2025 14:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2016B8E0005; Tue,  9 Sep 2025 14:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC32B8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:01:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84F471A06A5
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:01:33 +0000 (UTC)
X-FDA: 83870479266.08.90EFE4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7551E40015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:01:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A7gUZ61G;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757440891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZ+1i1bo4qA8+U5TMP3wVFdi2KOO2xz6YdiT64bcBWk=;
	b=U5WNcwQybI+Hh2vhtippMoMif2yzyb01MKZNFJbOPE+oJICn/+jVHGNDbDoKCEGe+XwKpb
	zZjZKHJnxfhvMsKlIdMhiYamg0ElgC97nPCpyrDcnuhceQLxVd7YWTf5Y31UlIV3I8mQNB
	YyuzWhv60NLzT1ou1KzoLHJHLvJqqRE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A7gUZ61G;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757440891; a=rsa-sha256;
	cv=none;
	b=ws8foRIuFcaiWZ0MSGUJIiKrdySCowxSi8yL9uTXMVPLyeJ8zKjxvfe+MAeKmpWdxbX6fj
	jabYANEsKTiQaIqY5I4iJmnU7UuoLhCcy6ff5aExLSWm78w04MQtSssOuWtqJG+Ib5MEDq
	G8pnkJOW0/vZ8OcjiyVMp5Oma5KsdYw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DC5F44D41
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D80C116B1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757440890;
	bh=5ilK8ia7UPhfVMvyxiXK2/ObZT0rv1xyPRWOvrYgFLg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=A7gUZ61GSZHU6YDGEoeo6YaMEpuViXK5JJnpfKsLC3OdC/7OsNL1VMEFWk7WUc6nR
	 8xXTYol0G1LFeXmksDKOTVh2icvAU2FJTUdyJlbbG0y+/CZYE3LlMHlCk/4H+ZJphv
	 HDkMq0ck8Md86nJaZSdKg4n8ONb5a6hhU/KNQmQy6GcCyp/V7dwziUS95LTYo2E22c
	 YQGuiLlKALHda9ECCXEllwsWZ6u9aV1KdnP+z1d+A/uW71NpEKf6fB/RvUiEeZuvuB
	 V5dD9qONFZlZbDBJgxJuI5LDQdYn9w4i7pz+0xbSwYlC1CJOvlURSG5/lBccebrShG
	 kM81WQmbKjqFg==
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45de2856648so9305e9.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 11:01:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXfqrrPz+ZUlyOOPNOiuv1+41y63e+eYSdoDXY56hxgYz9UinqPLQoFobmkZ8sCYTlB9bwrm5L0mQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/8HyFuz0Z9gGO6uflI1sS4SNRUq8uD+TTwnr0rmRPPNQgDjU1
	dOpeLmOV31a+rBxQwlLLgxKAV/nuDGywUPNVXHoGacyLUyQ24smDTTxHuVcbuSr/WeYDitx4u7w
	g8Kiffvec2EDjrGOiUS1uNAPJCrkOhRGbEay48o3M
X-Google-Smtp-Source: AGHT+IEHiqW6W81fKTiUrSgccv+699732yqAFTxOHwHdOHXueJL7aAAseuYOZ6okifCTYPp/jMJ7ubGR/z4jzyU8EOo=
X-Received: by 2002:a05:600c:33a9:b0:45d:f51c:193 with SMTP id
 5b1f17b1804b1-45df758d891mr14615e9.7.1757440888599; Tue, 09 Sep 2025 11:01:28
 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <CAMgjq7Ca6zOozixPot3j5FP_6A8h=DFc7yjHKp2Lg+qu7gNwMA@mail.gmail.com>
 <CAGsJ_4xiTteQECtUNBo+eC9uu8R3CgVT2rpvGCGdFqc3psSnWQ@mail.gmail.com> <CAF8kJuM4BEeHnkhw5bSM6ap23paChMBZtqCY6ksie+8EghYb8g@mail.gmail.com>
In-Reply-To: <CAF8kJuM4BEeHnkhw5bSM6ap23paChMBZtqCY6ksie+8EghYb8g@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 9 Sep 2025 11:01:16 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNJEchVPWQhbKqePA7NBJsznVEzhfp1D-bxsC64aFfttA@mail.gmail.com>
X-Gm-Features: AS18NWChhVMZpbE3ggz7fev2b5EP2VFRMFP1IX5t70ZHFiaCFFddAwgtajoPUoU
Message-ID: <CAF8kJuNJEchVPWQhbKqePA7NBJsznVEzhfp1D-bxsC64aFfttA@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Chen Yu <yu.c.chen@intel.com>, 
	Hao Jia <jiahao1@lixiang.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, Oleg Nesterov <oleg@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Fushuai Wang <wangfushuai@baidu.com>, 
	"open list:MEMORY MANAGEMENT - OOM KILLER" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 56pz5bfdzdkaixhfsk3wr8abzpdh8nzk
X-Rspam-User: 
X-Rspamd-Queue-Id: 7551E40015
X-Rspamd-Server: rspam04
X-HE-Tag: 1757440891-440955
X-HE-Meta: U2FsdGVkX184UfszMMI5uHI5AxZ3q5dVcYIDLUCYoecxy0odA+AMZJIRbCkbwC+KIzV3Y1vTU5VUw0SCjler9xtH0QqatP1Cccd6QcjWBKqGiZgqgyOC64J2tkH/gyWQJJruyLzhwjPeIkmatHGHDzXqlXzre6twU3Ra9vX9DAJvCI2egCi3969gzplVPNct7KsGKtMEAhUETxVbwX7jLla6BVhd7ZSuHngrzDfdXHV/jjFTVe1nrd0+C0W0uhXaz6lR1gpSs5LbRlNUzXRwf8f4hmcQkoROMPr2W7iRXXwYYz9QCQDAx30Xcgk9S4/aNyntcyOzHw5qQO7SUY4pZ9ayIQcBxe74tfNKZXvD1yo8v4zE4qtdXS0AmAN1i+wwzSO3ev7oe7FMvoPOvcXwZqWwHSz/1O/0KTUe8xgok+oBGJec44IxYetBKFT0ydMTZqCEWxoGJ39mZddGw1AC2mj4GpUINcwl7sbzjOf2bcZJK050qvdCapbARJnwdXTsSn97/vUYEUPKmOC6rkL7iyjN8Tj3USjoG351lY22SeGYWhYNapWefFjKcq3okHVN9CxQ4HHpxWIPCOBQVJVgMmUpVubmuBs63vA4NOp3e9tuceYrAxtBmc2X1Z+lPfZ4bLThlD5KVWFKldDnCimdsrdDp4M0pbHmv4icQmtPK9AEvCOjMSM9LpcnQd2P/RPGDc8z9HpLAZRBQRBTAmhpZnD65kavIKkyswFwz9agYkL7tsIOQKZSHxBynOLgulJT+EkJ8fsT1X0FsGPOTMhHPTMkyLxns3/Qm5w0l2umwiguTQl7Ss14MW8hqACluRHDbPLQbaZO5YtPDdoLPtO6lIpQeOuqDIxDqmoxFXgIQKNZofGM7U0Zo2pRJl+Jbk+Zof7Eqfd6uVO6cVdL3WeunUT+u4chdPqmooy7HzfKW+C58Ap86i7tlHXcvtjoceRZO0LsCEGlH+oeAqlAxYa
 Zt591B6p
 6KFa6sgASSLL27nd0FzdDOLdKA3G9/EvEZZOoDbQCmg7Fta2lS3jJROKELerp74NkEqWB3/W1V4IJrDaDT68aECun4IW/z5NfH418FWdOhA7dddyvWdCYVfIhka+tqQytWVQ1qjr+CUBXA1qibWWbUmzywMHtwk3Jd4cMT9JinuXkhD3woCPVzqghaOwGK7XaFCxxm5diXym3Pkshcmpc3tFI4SMLTxK77i+soR+iHDTAmWiWB+TJY8ZdQgiyGpTXWT6K2vcpgUKvLd0Z10aEukCYRRYviOF06DoOz13+39lXIYXbCWp8SAylkRly3utFCBduwhPi0XHf1YBJGZY3sbxJkUMKvqcDZROv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 9:15=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Sep 9, 2025 at 2:24=E2=80=AFAM Barry Song <21cnbao@gmail.com> wro=
te:
> > I feel the cover letter does not clearly describe where the bottleneck
> > occurs or where the performance gains originate. To be honest, even
> > the versions submitted last year did not present the bottleneck clearly=
.
> >
> > For example, is this due to lock contention (in which case we would
> > need performance data to see how much CPU time is spent waiting for
> > locks), or simply because we can simultaneously zap present and
> > non-present PTEs?
>
> I have done some long tail analysis of the zswap page fault a while
> back, before zswap converting to xarray. For the zswap page fault, in
> the long tail a good chunk is a bath free swap slot. The breakdown
> inside  shows a huge chunk is the clear_shadow() followed by
> memsw_uncharge(). I will post the link to the breakdown image once it
> is available.

Here is a graph, high level breakdown shows the batch free swap slot
contribute to the long tail:
https://services.google.com/fh/files/misc/zswap-breakdown.png

The detail breakdown inside bath free swap slots:
https://services.google.com/fh/files/misc/zswap-breakdown-detail.png

Those data are on pretty old data, before zswap uses the xarray.

Now the batch freeing the swap entries is gone. I am wondering if the
new kernel shows any bottleneck for Lei's zram test case.

Hi Lei, Please report back on your new findings. In this case, with
removal of swap slot cache, the performance profile will likely be
very different. Let me know if you have difficulties running the
latest kernel on your test bench.

Chris

