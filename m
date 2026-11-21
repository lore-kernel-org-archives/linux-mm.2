Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F342606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 13:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eaF/2PZ1
Received: by kanga.kvack.org (Postfix)
	id 643AA6B00EF; Sat, 21 Nov 2026 08:47:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4AC6B05B0; Sat, 21 Nov 2026 08:47:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF566B05B1; Sat, 21 Nov 2026 08:47:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23EBD6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:47:57 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5265A7FB8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:47:56 +0000 (UTC)
X-FDA: 85459254552.07.2ECD7A5
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA83B20007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:47:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="eaF/2PZ1";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795268874;
	b=S9LUXLbl+KEd58OIqyi+LhpjSBwKblyn1OSuXA1Lim4YCCx0ZMEdDapRYJghq0crAsvfIO
	NbN71kQFpBUud9pPCboIzGhlFwi31IN03IiXwKkwj+boDV94AgVkcwFnAg2hxZDGZJpHsv
	VpIJrlCHQVlx5aUbRDyw2rGDB8HTBRM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795268874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IKkH8WnjWkTB0ovKbeuIbo+cf7tQbeYQTSiu4DDxRI=;
	b=6O01maw99Y4FBm3GN3+XMzY7qK+yMFDIqnsr/wS/nkJtiu7TUJprPXDr2Zh8oeEX9z21z7
	vPdSm4ghaMWtZFh0Gg6CCYC3zH5kh2PJ6VJdo03FFNoRl1rOs0ddi8mpmcjgrSJXhVY7uF
	YCN23rjaw+sqCdpgyL5zxg+gi2sREyg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="eaF/2PZ1";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb6057b333so7399855e9.3
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 05:47:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795268873; cv=none;
        d=google.com; s=arc-20260327;
        b=Kk66ZwXlC8oUvK33Gi/qdglkdi7v0eLmLzTq9KQV8NBG+HZLG30qoTaCM86lpo7ayX
         2MavprFFPbnFtMXKb1u76924dz9NLzTttLgVE/z9pVwFW/D+EtNppHpHUUnMb9wG777r
         eYrE3XUiJCRAOLu4IS5/HBFzLlMC8PpWBVPEJgAQkkUhnsFlJTNQejw62QNOgBcyo5gd
         klTlqpknHp0diAnpAxrl/RI4NzegK9kV1go5hxzH6wLmV3jnB4EyRoTZ5St/zG6S9+0s
         UKmkIBrkzmoQjCDx2W3uTtUYOoWQRa4NpvE0aWJq/d0d2MAKN4IKavmuCjJW3MvxQiUX
         9amQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6IKkH8WnjWkTB0ovKbeuIbo+cf7tQbeYQTSiu4DDxRI=;
        fh=BreUFRwPfo8in1YgxdNM3CEmyWeZ42beJhCpvJu1Uhg=;
        b=jBucBhJeMnVDnocHOZlZ9NvIWBCwVPrTqTrXUTyGmGLJgowkbG/5T3aZ7z36nKAmdQ
         EAWURRKfm9FnQEZkFBEkh58aCYBbKopYENSrbpI1zdamDZQ8oBTv3GIg2BqOEj87Vt+n
         yvs9bQ07x4FbHnOikYkMt46m7R0g/m3kc9cq8qnUERLoJqr7SEiZnJBGIVmiDRQ9HX3X
         hNT5ojac/WR91SIVeE1/kGtyKRF1OZ0suFfZJbs+N1PxAxqufw498P1fua7zyQoGIBie
         ITNh5/Dck9YqLs5nSNoHvyTfkgbcD9fcfayNDNr5bi3f/mLxd7y/IHMDQ4nqSKLyuL1y
         a3fw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795268873; x=1795873673; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6IKkH8WnjWkTB0ovKbeuIbo+cf7tQbeYQTSiu4DDxRI=;
        b=eaF/2PZ1hf3b8YSyuS5MRzf4/Y5enb3eEzRy2+0UkOzF2VfPK8e0Pb0cmmHkgHx3pU
         qd5sWpdqTlDUdDcZQzXqhR0hahmmZfiSpmcJcUyN8ffUevQv3nbMbOUn17Givj7AXKxJ
         rnJRXucw6cFwjMT5NXQF0V7xHJ3I45XPXVyO683nc7QVU4GcJObT2pno5u9OHfaz7v+3
         gEuixnTV7hMLrkltmGbdnBuRyDKzVcycQgWnwiNTSonF5yfq9Zlvz8yzyiYSrkKFAgWI
         1VGfIZTbHNnNLuhZsjq1ovcTQEHyRoELAv3lQahbYZLaXzG7CsL8gQe5nHi0nWZXGm9M
         BN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795268873; x=1795873673;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6IKkH8WnjWkTB0ovKbeuIbo+cf7tQbeYQTSiu4DDxRI=;
        b=mlWdKFx4f0osnQjCUwEnCT4lGzOGGvLhkFKFlWJCDUE62A2lrHuLnXwi2ho0rU+PEO
         n3EOVXBNK/REA7sSRoEXLRTr4FXz1Ovyq8Y1EcU6bN1QyeLOx7JSi+rKh3rJtorfVo+N
         kdAmwxnxXSkCqfAJNUTKw87m94VphCsTG2/kgWEZsmVh7u7WKYjPfmGjLasla+a6+39o
         JAMBZuFLobCeCUoDN98byKqUxfirvgM7cSGz7WYhs1USQYP3erinQWbE8AU6gdibUjrD
         dHBskaZMZc6fLpAYqK9DD1AKbwZjRf/961xzM96El51hJWF03pgWIgwv585snWxJSd3M
         gE5g==
X-Gm-Message-State: APuU4Z+GXR37o6+Hzj0eVXi2bD9oLquTLfjwpIt0boCYS3dGC0Qz0w/9
	7YvS/VodM5iO073nAvHJ+Gg3mAqqJRovYpLDeX03HvxehD4Tqy8FqDpUEWDhcSQqQ3PnzRyc4t2
	pRANcnaNxKODW04Um+/Ruf8gk3QwOQVU=
X-Gm-Gg: AZFdTZdWQmcrK/s486uD0hw40c7zGJuE0O8V9IUd6mP4E/hJbjd3axoim0s/hl6LclU
	f7hK1bg5n9pDyl+gDE77AbP1RZ3tINgbWTj4exYNY3JDB37FmRj8ZGtGE+LEPI9QkThzdqCsRav
	Qy6RdoYUIV5FkhobORDGn1xs+4AbHjArjwFHMLlAv1FnAiNCrT3NKwilO7Z2TTrlSI/+m83lRxZ
	WT00alLCYsgaFptZn4NSl8++f4YrEd081jzC423hB9QXlqHe3Ti31ZoQSibGzmUSkR8VW2AWCY4
	2cv1UcxMxIe1C5y/eCKsYTX/Pje9a2dnQvsQpU42Y+f5u9785CWScOIMrNq55cuQde5xGwlLCZ7
	YoVfZmCNYguZyiKjQJxIUo/d4uqNG101D+uP7TE/q/WyxBPOIHhvg5Nf1obeNWwE8VotPLCriiV
	9zehomT7qDpXFwZUZ6QHnGnGHYLKqTo7eYoQSfGe+sJ6Opy8fwfP/5
X-Received: by 2002:a05:600d:82d0:b0:4bb:818d:8d8f with SMTP id
 5b1f17b1804b1-4bb88818955mr156720995e9.23.1795268872399; Sat, 21 Nov 2026
 05:47:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-15-9eee2fe97a2d@tencent.com> <CAN_Opa8jGstV=s9S=c842XFJ_H8m5txc6eJDH2AF=KuJSHAe6Q@mail.gmail.com>
 <CAMgjq7C+7=k9f9HVtYn_VwB96TZAJ=D8cbMh0mV7wCsW3m0ZWA@mail.gmail.com>
 <CAN_Opa_+xnmx7JTYxSRyn+itcfJZqeZz2mgBjTTKF13UKqO8rQ@mail.gmail.com> <CAMgjq7B-_UwERJjZ4AH2KRwuOD8hKnJGxmQBFxw79NBe6XisrA@mail.gmail.com>
In-Reply-To: <CAMgjq7B-_UwERJjZ4AH2KRwuOD8hKnJGxmQBFxw79NBe6XisrA@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Sat, 21 Nov 2026 21:47:41 +0800
X-Gm-Features: Aa3M54rYbWX6IeJuuOZteLQ4YlTLPq5XyGhlg4HDWtreYdZ_b2wTgzVKAZXd9nU
Message-ID: <CAN_Opa_aieBpbMBctHQ3WzKU=JcKZjRw1FXKmCw1S-O_zB_S4A@mail.gmail.com>
Subject: Re: [PATCH v5 15/17] mm/mglru: folio LRU refs based active/inactive
 number accounting
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fukhaffoqysnhnap4uwbztmoy8frtmwi
X-Rspamd-Queue-Id: BA83B20007
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795268874-82964
X-HE-Meta: U2FsdGVkX1+8T73AcPKiQSzoIsn1v3mjFPEkN34p/jmFx9gIQVPPNXI4S8UgFuwxU8xJ0Re4N41XQcDlsZOH2zYQPiYr4OC4UZGZEXzXf0S0+5pJgInZFSLIhtzTlec0i5hSoRKWgYlZUcjVykNVhDoO8/Mgc3vzvV4N+1bugrSM5oVlBK630dIIHccJvLULoJWsCRiK7vpUm+yvLq9dppVZtvWLrfh5WwjhEpoCetZGeMbOvI6jOGd9sQ1pun6ZIFhPSObLV8wHwtHiQ6cvI1UKVct2Vsjvk6zhbW+0iyS3GTvYJkrm0xv1JPhurGix82BAwo4PmkOfeEHLGvIZ6F7GnSkSznoN5Em73C8E3qNvGhikazVx3RMVUv0D5X+YIGgygUcpceISFBn86o9d+Y+i0Ga7FSCyMrj44s6tT7PMWR94108wWBZPriWYQ5JjahGkNLjMXY65Zgk1/hJ6F7yMsmA+W4s0HtnzK6M3fTu407KWmLgtM7Kr2dcFUc0J/l3XFoQBE8ne4yzkSj9S5bsPdBCh1YfZYU9286eVa23uZiO/CyC/finBKYfLrQgmZDCVaepKLhfFDrPPFQ5fUPuYoXXA6WfxHpLOTMC3yMMnuiT9OHJAAAynyQza20tf7NA/Mw7u36Sd4F5KMuLyKBIrRCIqCI4rHcmbduvH1bNzjGdCPJjE4Zm6XP3ZPDeF6krwOuQDAKrF+hVFO+vfFJcYh7MMj6ngdGZtpMB4iOpq7+USB4+KeD6NvJ1wDQxxljBYlkusshZiFRJegeI5NJvMqKssia0YeXCTgYK9UupgN5fow9c1Fn9oi0PRhbwH+aj7dTAFROTfomZ19/f/QCXzFwkauL5it+DfxIEHQasTb0eN19UN9OXbMxb+C2nXE8itMUWtWjQyZ7PNodTH9n3Brr5OL2m6lOnNk/PGb5B67NNoNsiaCoffStYdb15Lz+wdq0GkLyqKp6qXt64
 whvX4BzT
 lgufvxedRoi7x70VkooKgLw6GUHq9irj+hpPIS6cQyEbGOMKWvq+/Gb9vQlhxDZkBA5PyRvZ2t/lX77EySlU5jGY8TuMA9uo4UByviKPSmpZFqkThAJGy3TVsvPJBPH7n3b2bDXSTI3mVA9lREGHMVt+H4d6pxIBhRLhAPH23DA9ucAVWv07vA7lWZmyS0MC0BdMuZ61EJ8w84ktuI1F75YWKPcZw5IAwn0sdQVLVMJW2lUwiVpKWtLHL1bf4ybWaOhu7+N4DEkEC53GbsqqCmUGU/1dNr3Q1hXyFWwkutcUoC1rRpO1aoGsjqnXM4YQNTE/EbhvkHYQCB0z5V9+Wcl+21QT98AXec2ISmuSgab2t+8rT19pZJ8dKU1Q1WCIsJ6lyB/yQ2vIOULKMVbvWqxlFqbbKO3weF4+rwIFlWQWe/WyC8kP1J2aPaCE0VD2OxYTQY5hpAtbWnE9IMgML4YzyHKEJ1VRzCY0oDq8d/nf64BFMobpzRux8neIR/HKPys3fH9K9fqXG8E0HURQoz/StTHO4iuUwrbzB6W3gh97KswhmJyGrBP0NpsEsk5BW2R30hapZSgFf6pqEQIHfHvwqrnqkzu//iCp78GD0ljbL37/AiVLpc+9llCu8waKpQZNYOTBCGCsiGi/kyFW1PH4ZIUqpvnGYOTrvib4JN5/wkgU3uha/pb6Gl4jbKKHbij5RgVchDAzt3pk4RGchEKYmYy13s3JRGRO6Nmi6b9EAqzRgklhH1eym6Yg+nrmzvgQDjvM/EzFI4ZbTSbVsF7+MW4fdQc+GMyF6Zp7UZmLCctTV+xqcgaYUXuk67V96KMTZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 2:59=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Nov 21, 2026 at 12:30=E2=80=AFAM KunWu Chan <kunwu.chan@gmail.com=
> wrote:
> >
> > On Fri, Nov 20, 2026 at 7:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > On Fri, Nov 20, 2026 at 5:30=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.=
com> wrote:
> > > >
> > > > On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
> > > > <devnull+kasong.tencent.com@kernel.org> wrote:
> > > > >
> > > > > From: Kairui Song <kasong@tencent.com>
> > > > >
> > > > > Currently the active/inactive LRU sizes exported through /proc/vm=
stat
> > > > > and memory.stat are derived from the generation window: folios in=
 the
> > > > > two newest generations are accounted as active, the rest as inact=
ive.
> > > > > This causes several problems:
> > > > >
> > > > > - Unmapped file folios can stay in older gens despite repeated us=
e,
> > > > >   so active files can be under-reported, unlike classical LRU.
> > > > >
> > > > > - The reading is jumpy: on aging, the second-newest gen, previous=
ly
> > > > >   active, becomes inactive all at once, causing a huge drop of ac=
tive
> > > > >   folios without any change in use.
> > > > >
> > > > > - The reading is reversed on swapless machines. When swapping is
> > > > >   disabled or unavailable, MGLRU ages anon by moving the gens dir=
ectly
> > > > >   without walking or touching any folio, to reduce the overhead. =
So
> > > > >   inactive anon folios can suddenly count as active, or vice vers=
a,
> > > > >   despite no change in their hotness.
> > > > >
> > > > > With frequency guided promotion, hotness is already tracked per f=
olio by
> > > > > its referenced count, so we can do folio level accounting instead=
: a
> > > > > folio is active once its refs reach LRU_REFS_ACTIVATED (currently
> > > > > LRU_REFS_PROTECTED).
> > > > >
> > > > > On reaching this threshold, folios are accounted to the active pa=
rt.
> > > > > On forced per-folio aging or PID protection, refs are capped at
> > > > > LRU_REFS_WORKINGSET, dropping active folios to the inactive part.
> > > > > Note that on swapless machines anon refs are not reset by aging (=
the
> > > > > shortcut skips the per-folio walk), but the counts no longer osci=
llate
> > > > > as the generation indices wrap.
> > > > >
> > > > > The accounting is now per folio and lruvec independent, so no siz=
e
> > > > > adjustment is needed when reparenting a dying memcg: the hierarch=
ical
> > > > > stats keep the counts in the parent automatically.
> > > > >
> > > > > folio_migrate_lru_refs() also gains off-LRU VM_WARN_ON_ONCE check=
s and
> > > > > __folio_set_lru_refs() warns when the folio is still on an LRU li=
st.
> > > > >
> > > > > The latter uses lru_get_gen_flags(), so that helper now has to mo=
ve out of
> > > > > the CONFIG_LRU_GEN block and is built with the option off, where
> > > > > LRU_GEN_WIDTH is 0 and LRU_GEN_MASK is zero.  Keep the decoded va=
lue in
> > > > > int so the subtraction of the one-off encoding cannot fold to ULO=
NG_MAX
> > > > > before it happens: that is -Woverflow, and fatal with CONFIG_WERR=
OR.
> > > > >
> > > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > > ---
> > > > >  Documentation/admin-guide/mm/multigen_lru.rst |   4 +-
> > > > >  include/linux/mm_inline.h                     | 118 +++++++-----=
--
> > > > >  include/linux/mmzone.h                        |  23 ++-
> > > > >  mm/folio.c                                    |  39 +----
> > > > >  mm/madvise.c                                  |   2 +-
> > > > >  mm/vmscan.c                                   | 218 ++++++++++++=
+++++---------
> > > > >  mm/workingset.c                               |   2 +-
> > > > >  7 files changed, 230 insertions(+), 176 deletions(-)
> > > > >
> > > > > diff --git a/Documentation/admin-guide/mm/multigen_lru.rst b/Docu=
mentation/admin-guide/mm/multigen_lru.rst
> > > > > index 9cb54b4ff5d9..808d2e97b3f3 100644
> > > > > --- a/Documentation/admin-guide/mm/multigen_lru.rst
> > > > > +++ b/Documentation/admin-guide/mm/multigen_lru.rst
> > > > > @@ -149,8 +149,8 @@ generations less than or equal to ``min_gen_n=
r``.
> > > > >      ``- memcg_id node_id min_gen_nr [swappiness [nr_to_reclaim]]=
``
> > > > >
> > > > >  ``min_gen_nr`` should be less than ``max_gen_nr-1``, since
> > > > > -``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged (equivale=
nt to
> > > > > -the active list) and therefore cannot be evicted. ``swappiness``
> > > > > +``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged and there=
fore
> > > > > +cannot be evicted. ``swappiness``
> > > > >  overrides the default value in ``/proc/sys/vm/swappiness`` and t=
he valid
> > > > >  range is [0-200, max], with max being exclusively used for the r=
eclamation
> > > > >  of anonymous memory. ``nr_to_reclaim`` limits the number of page=
s to evict.
> > > > > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.=
h
> > > > > index 14aab2b1ed08..77f514143266 100644
> > > > > --- a/include/linux/mm_inline.h
> > > > > +++ b/include/linux/mm_inline.h
> > > > > @@ -105,6 +105,22 @@ static __always_inline enum lru_list folio_l=
ru_list(const struct folio *folio)
> > > > >         return lru;
> > > > >  }
> > > > >
> > > > > +/**
> > > > > + * lru_get_gen_flags - Return the LRU generation number from fol=
io flags.
> > > > > + * @flags: folio flags
> > > > > + *
> > > > > + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive.=
 Returns
> > > > > + * -1 if the flags indicate the folio is off the list (e.g., iso=
lated).
> > > > > + */
> > > > > +static inline int lru_get_gen_flags(unsigned long flags)
> > > > > +{
> > > > > +       int gen =3D (int)((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF=
);
> > > > > +
> > > > > +       /* The gen is stored offset by one, so zero means off-lis=
t */
> > > > > +       VM_WARN_ON_ONCE(gen > MAX_NR_GENS);
> > > > > +       return gen - 1;
> > > > > +}
> > > > > +
> > > > >  #ifdef CONFIG_LRU_GEN
> > > > >
> > > > >  static inline bool lru_gen_switching(void)
> > > > > @@ -168,22 +184,6 @@ static inline void lru_set_gen_flags(unsigne=
d long *flags, int gen)
> > > > >         *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> > > > >  }
> > > > >
> > > > > -/**
> > > > > - * lru_get_gen_flags - Return the LRU generation number from fol=
io flags.
> > > > > - * @flags: folio flags
> > > > > - *
> > > > > - * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive.=
 Returns
> > > > > - * -1 if the flags indicate the folio is off the list (e.g., iso=
lated).
> > > > > - */
> > > > > -static inline int lru_get_gen_flags(unsigned long flags)
> > > > > -{
> > > > > -       int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1=
;
> > > > > -
> > > > > -       /* Exclude the legal -1 from the unsigned MAX_NR_GENS com=
parison */
> > > > > -       VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);
> > > > > -       return gen;
> > > > > -}
> > > > > -
> > > > >  static inline int folio_lru_gen(const struct folio *folio)
> > > > >  {
> > > > >         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(fol=
io, 0)));
> > > > > @@ -247,12 +247,21 @@ static inline bool lru_refs_is_workingset(u=
nsigned int refs)
> > > > >         return refs >=3D LRU_REFS_WORKINGSET;
> > > > >  }
> > > > >
> > > > > -static inline void folio_set_lru_refs(struct folio *folio, unsig=
ned int refs)
> > > > > +/**
> > > > > + * __folio_set_lru_refs - Set a folio's LRU refs.
> > > > > + * @folio: the folio
> > > > > + * @refs: the new referenced count (0 .. LRU_REFS_MAX)
> > > > > + *
> > > > > + * Set the folio's LRU refs.  The folio must be off the LRU list=
 (e.g.,
> > > > > + * isolated), or use folio_inc_lru_refs or folio_reset_lru_refs =
instead.
> > > > > + */
> > > > > +static inline void __folio_set_lru_refs(struct folio *folio, uns=
igned int refs)
> > > > >  {
> > > > >         unsigned long new_flags, old_flags =3D READ_ONCE(*folio_f=
lags(folio, 0));
> > > > >
> > > > >         do {
> > > > >                 new_flags =3D old_flags;
> > > > > +               VM_WARN_ON_ONCE(lru_get_gen_flags(old_flags) !=3D=
 -1);
> > > > >                 lru_set_refs_flags(&new_flags, refs);
> > > > >                 if (new_flags =3D=3D old_flags)
> > > > >                         break;
> > > > > @@ -261,12 +270,18 @@ static inline void folio_set_lru_refs(struc=
t folio *folio, unsigned int refs)
> > > > >
> > > > >  #ifdef CONFIG_LRU_GEN
> > > > >  void folio_inc_lru_refs(struct folio *folio, unsigned int flags)=
;
> > > > > +bool folio_reset_lru_refs(struct folio *folio);
> > > > >  #else
> > > > >  static inline void folio_inc_lru_refs(struct folio *folio, unsig=
ned int flags)
> > > > >  {
> > > > >         /* Should not be called with !CONFIG_LRU_GEN */
> > > > >         WARN_ON_ONCE(1);
> > > > >  }
> > > > > +
> > > > > +static inline bool folio_reset_lru_refs(struct folio *folio)
> > > > > +{
> > > > > +       return false;
> > > > > +}
> > > > >  #endif
> > > > >
> > > > >  /**
> > > > > @@ -280,10 +295,18 @@ static inline void folio_inc_lru_refs(struc=
t folio *folio, unsigned int flags)
> > > > >   */
> > > > >  static inline void folio_migrate_lru_refs(struct folio *new, con=
st struct folio *old)
> > > > >  {
> > > > > -       folio_set_lru_refs(new, folio_lru_refs(old));
> > > > > +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(old), old);
> > > > > +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(new), new);
> > > > > +       __folio_set_lru_refs(new, folio_lru_refs(old));
> > > > >  }
> > > > >
> > > > >  #ifdef CONFIG_LRU_GEN
> > > > > +static inline bool lru_refs_is_active(unsigned int refs)
> > > > > +{
> > > > > +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> > > > > +       return refs >=3D LRU_REFS_ACTIVATED;
> > > > > +}
> > > > > +
> > > > >  static inline bool lru_gen_is_old(struct lruvec *lruvec, int typ=
e, int gen)
> > > > >  {
> > > > >         unsigned long min_seq =3D READ_ONCE(lruvec->lrugen.min_se=
q[type]);
> > > > > @@ -294,23 +317,12 @@ static inline bool lru_gen_is_old(struct lr=
uvec *lruvec, int type, int gen)
> > > > >                gen =3D=3D lru_gen_from_seq(min_seq + 1);
> > > > >  }
> > > > >
> > > > > -static inline bool lru_gen_is_active(const struct lruvec *lruvec=
, int gen)
> > > > > -{
> > > > > -       unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_se=
q);
> > > > > -
> > > > > -       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS);
> > > > > -
> > > > > -       /* see the comment on MIN_NR_GENS */
> > > > > -       return gen =3D=3D lru_gen_from_seq(max_seq) || gen =3D=3D=
 lru_gen_from_seq(max_seq - 1);
> > > > > -}
> > > > > -
> > > > >  static inline void lru_gen_update_size(struct lruvec *lruvec, st=
ruct folio *folio,
> > > > >                                        int old_gen, int new_gen)
> > > > >  {
> > > > >         int type =3D folio_is_file_lru(folio);
> > > > >         int zone =3D folio_zonenum(folio);
> > > > >         int delta =3D folio_nr_pages(folio);
> > > > > -       enum lru_list lru =3D type * LRU_INACTIVE_FILE;
> > > > >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > > > >
> > > > >         VM_WARN_ON_ONCE(old_gen !=3D -1 && old_gen >=3D MAX_NR_GE=
NS);
> > > > > @@ -321,19 +333,6 @@ static inline void lru_gen_update_size(struc=
t lruvec *lruvec, struct folio *foli
> > > > >                 atomic_long_sub(delta, &lrugen->nr_pages[old_gen]=
[type][zone]);
> > > > >         if (new_gen >=3D 0)
> > > > >                 atomic_long_add(delta, &lrugen->nr_pages[new_gen]=
[type][zone]);
> > > > > -
> > > > > -       /* return now if not a promotion */
> > > > > -       if (old_gen < 0 || new_gen < 0)
> > > > > -               return;
> > > > > -
> > > > > -       /* promotion */
> > > > > -       if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_act=
ive(lruvec, new_gen)) {
> > > > > -               __update_lru_size(lruvec, lru, zone, -delta);
> > > > > -               __update_lru_size(lruvec, lru + LRU_ACTIVE, zone,=
 delta);
> > > > > -       }
> > > > > -
> > > > > -       /* demotion requires isolation, e.g., lru_deactivate_fn()=
 */
> > > > > -       VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) && !lr=
u_gen_is_active(lruvec, new_gen));
> > > > >  }
> > > > >
> > > > >  static inline unsigned long lru_gen_folio_seq(const struct lruve=
c *lruvec,
> > > > > @@ -376,7 +375,8 @@ static inline bool __lru_gen_add_folio(struct=
 lruvec *lruvec, struct folio *foli
> > > > >  {
> > > > >         unsigned long seq;
> > > > >         unsigned long flags;
> > > > > -       int gen =3D folio_lru_gen(folio);
> > > > > +       unsigned int refs;
> > > > > +       int gen;
> > > > >         int type =3D folio_is_file_lru(folio);
> > > > >         int zone =3D folio_zonenum(folio);
> > > > >         int delta =3D folio_nr_pages(folio);
> > > > > @@ -384,7 +384,7 @@ static inline bool __lru_gen_add_folio(struct=
 lruvec *lruvec, struct folio *foli
> > > > >         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > > > >
> > > > >         BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) !=3D MAX_NR_GENS);
> > > > > -       VM_WARN_ON_ONCE_FOLIO(gen !=3D -1, folio);
> > > > > +       VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) !=3D -1, folio=
);
> > > > >
> > > > >         if (folio_test_unevictable(folio) || !lrugen->enabled)
> > > > >                 return false;
> > > > > @@ -395,10 +395,12 @@ static inline bool __lru_gen_add_folio(stru=
ct lruvec *lruvec, struct folio *foli
> > > > >         gen =3D lru_gen_from_seq(seq);
> > > > >         flags =3D (gen + 1UL) << LRU_GEN_PGOFF;
> > > > >         /* see the comment on MIN_NR_GENS about PG_active */
> > > > > -       set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(P=
G_active), flags);
> > > > > +       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MA=
SK | BIT(PG_active), flags);
> > > > > +       /* use the refs from the atomic snapshot to avoid raced u=
pdate */
> > > > > +       refs =3D lru_get_refs_flags(flags);
> > > > >
> > > > >         lru_gen_update_size(lruvec, folio, -1, gen);
> > > > > -       if (lru_gen_is_active(lruvec, gen))
> > > > > +       if (lru_refs_is_active(refs))
> > > > >                 lru +=3D LRU_ACTIVE;
> > > > >         __update_lru_size(lruvec, lru, zone, delta);
> > > > >
> > > > > @@ -425,24 +427,33 @@ static inline bool lru_gen_add_rejected_fol=
io(struct lruvec *lruvec, struct foli
> > > > >  static inline bool lru_gen_del_folio(struct lruvec *lruvec, stru=
ct folio *folio, bool reclaiming)
> > > > >  {
> > > > >         unsigned long flags;
> > > > > -       int gen =3D folio_lru_gen(folio);
> > > > > +       unsigned int refs;
> > > > > +       int gen;
> > > > >         int zone =3D folio_zonenum(folio);
> > > > >         int delta =3D folio_nr_pages(folio);
> > > > >         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INAC=
TIVE_FILE;
> > > > > +       unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_se=
q);
> > > > >
> > > > > +       /* Keep LRU_REFS_FLAGS: refs carry access history across =
isolation */
> > > > > +       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MA=
SK, 0);
> > > > > +       gen =3D lru_get_gen_flags(flags);
> > > > > +       refs =3D lru_get_refs_flags(flags);
> > > > >         if (gen < 0)
> > > > >                 return false;
> > > > >
> > > > >         VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
> > > > >         VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), foli=
o);
> > > > >
> > > > > -       /* for folio_migrate_flags() */
> > > > > -       flags =3D !reclaiming && lru_gen_is_active(lruvec, gen) ?=
 BIT(PG_active) : 0;
> > > > > -       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MA=
SK, flags);
> > > > > -       gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> > > > > +       /*
> > > > > +        * See the comment in lru_gen_folio_seq.  For migration, =
compaction,
> > > > > +        * or any other isolation of a hot folio, try best to ret=
ain its gen
> > > > > +        * info. Ideally we would keep the full gen info.
> > > > > +        */
> > > > > +       if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_=
NR_GENS)
> > > > > +               folio_set_active(folio);
> > > > >
> > > > >         lru_gen_update_size(lruvec, folio, gen, -1);
> > > > > -       if (lru_gen_is_active(lruvec, gen))
> > > > > +       if (lru_refs_is_active(refs))
> > > > >                 lru +=3D LRU_ACTIVE;
> > > > >         __update_lru_size(lruvec, lru, zone, -delta);
> > > > >         list_del(&folio->lru);
> > > > > @@ -499,6 +510,7 @@ static __always_inline void folio_inc_lru_ref=
s_fast(struct folio *folio)
> > > > >                 return;
> > > > >         }
> > > > >
> > > > > +       BUILD_BUG_ON(LRU_REFS_REFERENCED >=3D LRU_REFS_ACTIVATED)=
;
> > > > >         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> > > > >         do {
> > > > >                 if (lru_get_refs_flags(old_flags))
> > > > > @@ -534,7 +546,7 @@ static inline bool folio_check_lru_refs(const=
 struct folio *folio)
> > > > >  static inline void folio_clear_lru_refs(struct folio *folio)
> > > > >  {
> > > > >         if (lru_gen_enabled())
> > > > > -               folio_set_lru_refs(folio, 0);
> > > > > +               folio_reset_lru_refs(folio);
> > > > >         else
> > > > >                 folio_clear_referenced(folio);
> > > > >  }
> > > >
> > > > Can clear_refs race with disabling MGLRU? Once the static key is
> > > > off, it can drop refs from 3 to 2 on a folio still on a gen list.
> > > > The drain then subtracts it from inactive, though it was counted
> > > > as active.
> > >
> > > Thanks for the very careful review!
> > >
> > > I think we are fine, folio_reset_lru_refs checks gen >=3D 0 before
> > > touching things, gen >=3D 0 means the folio is manged by MGLRU, right=
?
> > > The worst could happen is we clear PG_workingset for CLRU, which
> > > really doesn't matter, one metric off by one folio for a very short
> > > period and self healing, not a measurable thing even if you do that o=
n
> > > purpose.
> >
> > Thanks, Kairui. The refs-based accounting makes sense to me.
> >
> > I meant the else branch in folio_clear_lru_refs(). The static key
> > can already be off while the folio is still on a gen list. If
> > clear_refs drops refs from 3 to 2 there, where do we subtract
> > those pages from the active count?
>
> Oh, that's a very good catch! I think we can do this (only changing
> the refs reset parts, a few other part need similar adaptation too,
> check gen <=3D 0 instead of lru_gen_enabled()):
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index a2442e49aca2..a97fa6b3b140 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -556,16 +556,14 @@ static inline bool folio_check_lru_refs(const
> struct folio *folio)
>  static inline void folio_clear_lru_refs(struct folio *folio)
>  {
> -    if (lru_gen_enabled())
> +    if (folio_lru_refs(folio))
>          folio_reset_lru_refs(folio);
> -    else
> -        folio_clear_referenced(folio);
>  }
>
>  /*
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4576a7a369e3..3c21463039da 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -965,7 +965,7 @@ void folio_inc_lru_refs(struct folio *folio,
> unsigned int flags)
>   */
>  bool folio_reset_lru_refs(struct folio *folio)
>  {
>      int type, gen;
>      unsigned long seq, new_flags, old_flags;
>      long nr_pages =3D folio_nr_pages(folio);
> @@ -980,7 +980,15 @@ bool folio_reset_lru_refs(struct folio *folio)
>          gen =3D lru_get_gen_flags(old_flags);
>          if (!refs)
>              break;
> -        lru_set_refs_flags(&new_flags, 0);
> +        if (gen < 0)
> +            refs =3D refs & ~LRU_REFS_REFERENCED;
> +        else
> +            refs =3D 0;
> +        lru_set_refs_flags(&new_flags, new_refs);
>      } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags))=
;
>
>      if (gen >=3D 0) {
>
> ---
>
> In general we can check gen < 0 instead of lru_gen_enabled for a
> stable refs manipulation. Switching is a very rare thing, and I hope
> we can just delete that sometime later. Thanks for catching this!

Thanks, Kairui. Checking gen in the CAS loop covers the race I had
in mind. We just need to keep the old refs for accounting and still
clear PG_referenced with CONFIG_LRU_GEN=3Dn.

Feel free to add my tag to 06/17 and 16/17, and to 15/17 with
those two details fixed.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

