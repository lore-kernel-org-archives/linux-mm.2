Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DDCDCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E47C8E011A; Tue, 26 Aug 2025 22:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BBEA8E0105; Tue, 26 Aug 2025 22:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AADC8E011A; Tue, 26 Aug 2025 22:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 377A18E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:38:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF7F084750
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:38:18 +0000 (UTC)
X-FDA: 83820978276.24.A2BB94F
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0212040003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:38:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4LgK3cmf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756262297; a=rsa-sha256;
	cv=none;
	b=3OqlsG1fzNN0zKZkai2FFeNgykdvCGe4ks37WcXuqujHWqLY3xcsA6/jKQuZv7/b/4QmGj
	NNHbrVek37O3Rgz/+9LUnZV1xbexrdLdWT2rxq5KvXfrO64HdA35/mHXoGeke1AvNxtBSn
	IIcaGPTF3Oz9mr6rgxXJZndNYNoJanM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4LgK3cmf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756262297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wxJCGpIeokObW2E4VfhvhJc7jVk8a0u10rPoZD+5Yc=;
	b=cL9E/rGZV4j4DM5GGb8NfQ72/HFAKLzEL2NXsF8r5HbDSat43t116FrD775oxhccsXNy+m
	zaG6i1pjaO9DuE1LMG+P4b1HnYfWBHNHSo3ynh0swy4+T4gOXSxkJmvEk/wjJk6TgTvSTL
	CUHpundSEqJ2SsFMiA2pO/6RMZRPshk=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b2f497c230so21441cf.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756262296; x=1756867096; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5wxJCGpIeokObW2E4VfhvhJc7jVk8a0u10rPoZD+5Yc=;
        b=4LgK3cmfIspo+bhKVPlPJGykFiC20AZD3sIWwGsgC1mj2iwyX2gW21Ws8stJwjbbGY
         wQlogVA4yjNqoqfmYKoiHh3MJJDZIgLLKKG9lnZ6Pt16R3FzqWZBRJC6rH4I9JBRQ+qq
         qqktP6gTOl9HXP6qfZB2mgnf9K/k7NltcwtQgPAqF2SS0eSZAX6OigsazPBk0c30sC+b
         xPcH/aq8FONEtzxF6TTr06hhEI+m2i8Xg1K0PNd3QdDFpIiaIA8/e1X+pxFmXOHjZ1iG
         2nM0hPZ/g+vE4d2FeCBDaJKajITCRsnCezNLOHcQNO4XbqcPam/y81SVUwx8fPx0HUPI
         xrMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756262296; x=1756867096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5wxJCGpIeokObW2E4VfhvhJc7jVk8a0u10rPoZD+5Yc=;
        b=YVfWorej7+07XeWCNW+yICoL9P7DAZ59jm1N65KGF2mQ43mIaFoKY564m7c+cAvQlA
         nRq/rP1amDMNPbfCGswO9AUM8wKPXEfRVqBSGj2pfDgpye1s9AXxST3ml3cs6y5P3xcI
         zrhBqW5I5EQfSNRFE5L1TjV34qTrMQrw2gHUcbYrVOzUPWPQzYuWDpqZCT4R4rct1lED
         YqOwQXpXDRbB+gxK8qa/Bc01gUqDUpXn5qz0aQ1UYy8uDKgCKmwHvi/Td+uJzzg828t2
         VtBI25aBiHmzq3YYT0pVnToB5vdU3wdM0DRW+IwhXUYgBswHjLdjx7s8/sIbJ9MeWaPR
         ABTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVllcn45DH6I89yV9sGVrllbcA1KhxA1P3gy2B7kNOOlbAvzzeleQ19oGc2QIplN46rU0pQL1FQsA==@kvack.org
X-Gm-Message-State: AOJu0Yx/1oYd1Tehwu+RDSqHx4UEemVexgTAwjzUrWFvZMeUslFST3ZF
	qHTyMuaEkVDRqNkGj4tzBsklOngN8rd4HoHHqs5zLHsAv3WZzpWlxcDknWa17PYMF1LyV3/fevZ
	zHPGWBlfX9uN0HluJUDFhrnfi852QERlu7vzX2RnJ
X-Gm-Gg: ASbGncs/meHuZoUqgAvui9nZSF4HWz7F/XN1/drw1PliIUDlZb384qIDaPIJFemJTc8
	fbiuATqkiy5qdNGAHtcH2CMI4ldAeN8Fy+puQNptwg5bWviOUdER5x7av7wUmkaPpAXy96RrMWn
	INLmppLdk5uc3HJ9A3Ord3lAbQWqydMuoS2H7cbEchLl0lOcWSdBGPP4ejWY1b44mk84k0CpDW7
	VvY6S9lAd9z
X-Google-Smtp-Source: AGHT+IHkXZk/TosAVwTj41F6DTvN5Ue1gIpGD5Bd+VRvHsa7ptTA61c4W57PBx0gyetDnfjQBN0szf7LJNkOGJNQTr0=
X-Received: by 2002:ac8:5dd1:0:b0:4b1:1ba4:208 with SMTP id
 d75a77b69052e-4b2e1d2adcbmr9920991cf.12.1756262295493; Tue, 26 Aug 2025
 19:38:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755190013.git.pyyjason@gmail.com> <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com> <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com>
In-Reply-To: <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 26 Aug 2025 19:38:03 -0700
X-Gm-Features: Ac12FXzR8HgXh88Fj0tWSjUnqZsqYDqw6O3AKBz5yz6NGnFo6aufDqeqpkJm6Y0
Message-ID: <CAJuCfpHJMSd16j3ANrtJGVfLieHdeO_Epq=U9OKty3TV362ckQ@mail.gmail.com>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sourav Panda <souravpanda@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0212040003
X-Stat-Signature: zd1653xmirz19daww3bda5nzyfrn8dy7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756262296-523929
X-HE-Meta: U2FsdGVkX195qq4nVh2Fr4tH2ABWIiF0xhEZNZBXTwlqlYcR9Y63uXswu6L6lDT7znIqqXIFXxssjaOQnPFt8gweNv1LhRu//oMYsxnDBoAfBOrcNtP1lH6+EIRE1xqTZR60FyZH9FHc2FTTxpKNvCW3Wpv84ALv+IQA6ctu/O7Y9gpPyiArTIhg710FGuauuX10yGmNYlVhod4kRtcvo4TTH+z2C3RV9+/rYFFsslKs5UWR3BA66rcHu7IsF8Fck7gD2+iyj2s1OROxCmLUNp5CB1KGrtbm+jn60pv3jTo6d56hrsBhgTwIDIk3jvxkXbgmkIPxzu/KrJ+DTmkJJ+0yUpLLml9iSDt2/WdHd/h0xpOb3db7b8jqacJq54wKlqQhSgZTSKGSSkKIW1Mvf6PpzOpT0yOGLEyrdznXOH86ycCrt6oWxphgw1cj4dlxhXc96hiyvWhqU/45SMOyhzNfzVZ2J5dKZ505E969+GzRhvHd9VOJtexVXXZBsBr/3wxqd5vJxxJtK8K2/ymtRqFToZWatj/RBNz1O8QlW8KBArBtJ49CQdbmAy2BOZRAI8cnjTORPFtqa5ErhJ5KTImMKStt2dBWCJOXC2zv1wkN5Orz7Xw5EXglcSGxp7KqKdLVUwD8BTPkXa8Twc45V6POYWGBMSynCdtqAzg00m9rQ8RvjRo/85bOSzXiR7VXcybhcunRlewfE4HUf4iZ1nleKNY5ynlx+sohE0NJbXo3Us2ikAclPJvvYbO3WBSYUyg0oYz6vyW7wM9fZGzgM6rdMfaNYaXMKfKMu4ULRRLnilIwRKpByq1ZtHxdwQAJx5Y/uLvtElOa7G7lSs5eOH3HD4zIhkIYrOWFjSxYaHLppf/VD71ho5ys61WHcq7MwNdCniveVMfeumHDfyZxeztdaLJs9Z8rYEp3eeoPvzmi+G3KXmTNByA3ptmA1KWxpWNyQsEkWIiBxtGlQB6
 qHkwtk5m
 Sfk4+8UtP7iyFzz+FFgoxitlCCQNiCzc4e9nu9Wfp0P4Rou0vxHDKcCRyRu9W2Iyf5T2fLtis21/gP4BOEJVvrDNMXOacrd5q1tXwqwTAVqqfChd7M92qUBqDRoEaGUati9cM8Fqi2lav/7iJvFF7JmseKPpaKC8j22KBu5Zg3MSrxUf8+OYBLaAjcvNppuAhYnA1MkoZdMwElBFydfl7LkL1WOVs3eit5cy+7LRMheyp3s69nIJKmmy1AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 7:06=E2=80=AFAM Yueyang Pan <pyyjason@gmail.com> wr=
ote:
>
> On Thu, Aug 21, 2025 at 12:53:03PM -0700, Shakeel Butt wrote:
> > On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> > > On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > > > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > > > Right now in the oom_kill_process if the oom is because of the cg=
roup
> > > > > limit, we won't get memory allocation infomation. In some cases, =
we
> > > > > can have a large cgroup workload running which dominates the mach=
ine.
> > > > > The reason using cgroup is to leave some resource for system. Whe=
n this
> > > > > cgroup is killed, we would also like to have some memory allocati=
on
> > > > > information for the whole server as well. This is reason behind t=
his
> > > > > mini change. Is it an acceptable thing to do? Will it be too much
> > > > > information for people? I am happy with any suggestions!
> > > >
> > > > For a single patch, it is better to have all the context in the pat=
ch
> > > > and there is no need for cover letter.
> > >
> > > Thanks for your suggestion Shakeel! I will change this in the next ve=
rsion.
> > >
> > > >
> > > > What exact information you want on the memcg oom that will be helpf=
ul
> > > > for the users in general? You mentioned memory allocation informati=
on,
> > > > can you please elaborate a bit more.
> > > >
> > >
> > > As in my reply to Suren, I was thinking the system-wide memory usage =
info
> > > provided by show_free_pages and memory allocation profiling info can =
help
> > > us debug cgoom by comparing them with historical data. What is your t=
ake on
> > > this?
> > >
> >
> > I am not really sure about show_free_areas(). More specifically how the
> > historical data diff will be useful for a memcg oom. If you have a
> > concrete example, please give one. For memory allocation profiling, is
>
> Sorry for my late reply. I have been trying hard to think about a use cas=
e.
> One specific case I can think about is when there is no workload stacking=
,
> when one job is running solely on the machine. For example, memory alloca=
tion
> profiling can tell the memory usage of the network driver, which can make
> cg allocates memory harder and eventually leads to cgoom. Without this
> information, it would be hard to reason about what is happening in the ke=
rnel
> given increased oom number.
>
> show_free_areas() will give a summary of different types of memory which
> can possibably lead to increased cgoom in my previous case. Then one look=
s
> deeper via the memory allocation profiling as an entrypoint to debug.
>
> Does this make sense to you?

I think if we had per-memcg memory profiling that would make sense.
Counters would reflect only allocations made by the processes from
that memcg and you could easily identify the allocation that caused
memcg to oom. But dumping system-wide profiling information at
memcg-oom time I think would not help you with this task. It will be
polluted with allocations from other memcgs, so likely won't help much
(unless there is some obvious leak or you know that a specific
allocation is done only by a process from your memcg and no other
process).

>
> > it possible to filter for the given memcg? Do we save memcg information
> > in the memory allocation profiling?
>
> Thanks
> Pan

