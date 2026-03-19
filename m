Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F4ED1088E5C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 00:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9675B6B0391; Wed, 18 Mar 2026 20:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918196B0392; Wed, 18 Mar 2026 20:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8071B6B0393; Wed, 18 Mar 2026 20:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4946B0391
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:56:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22B7D8AA92
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 00:56:50 +0000 (UTC)
X-FDA: 84560997780.27.0566C8A
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC070140005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 00:56:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PHbTMQ8z;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of jyescas@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773881808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOztz5HS7kfe0mJv/gYgM0otE4AvewQBLFhyRmLqVKA=;
	b=qoh+pHXGJNajgRRhF3JoNQ8UT5+Jc21BLBs6mAm3I5Puh12CYm+ymCJv+2afLFnFDi8YYo
	ocYRTzNiTUinOy7nhKMToZnLaeuvHxO+MLidh4SR8rf2Q5mzpPyCOLbyfbWwfiSFKDzf1K
	vu/R4/vIaptIcSnc+o56GhVpg5labO8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773881808; a=rsa-sha256;
	cv=pass;
	b=J0zbpTmj1NwZxNqy2LVgDKBcc75TFPsn6N9kPcCjQXgZFIvoGOJyFVNZsBmjdMUL0lFt64
	ZjZBuJQXgbHtnYfuDgnF+/B0cu66+5yTiUdnMj22z1fyMFO4Iv65WmO8V3dUmnbpgpnvVK
	1Vobo/DK/3bHiMf/6RQVtTcmXUBIOg4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PHbTMQ8z;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of jyescas@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4852ef20fe8so19125e9.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:56:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773881806; cv=none;
        d=google.com; s=arc-20240605;
        b=gRenFI8CUA+dpYanX9Cquhp0KqmujgRtpXDW0B/lyThVQ/voS1rZ03ON1rlYjfK6eO
         mz81Hk/ygMySXvvE10mc9bKlcWkvuVWR/E8BPE3J7GYZL/Sqchn2pdaI+Y5Im8ZhJ8O6
         xSA4+7tA13zLfnNEWIJUUEOBl/9O4qg1PKwQxwXB+4yg+hgfX233Yv2Q8pGL9vN7579J
         s7Xt6Sv/5JyFDqLMINLS81R/LLxNPP67a042H7xay++pDYpW5ijZOA9Ts0QSm7mo4LlS
         p7/lX1OBedjCXKKq9d9yqERsU4ze3gs6JjqsgCW/MQnK5P1PPQ37b1H+qLdhxXmh7Zfe
         CDRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SOztz5HS7kfe0mJv/gYgM0otE4AvewQBLFhyRmLqVKA=;
        fh=JH0eNDSO4kN8N2P4Sis2GkYSY8EiYX8Sav0jLpq9vAQ=;
        b=KNQuJmjYYrxN/NuSUssHRIkKvpHg7vyxO18Ct7WLDtldqSpoWlGqyuUagTSknfez3L
         IqBiaGFa5KR8J+/7vSf6yZHtKBg3xxzSNKIMLQwPvYxIkmXjsjXQt+R0v2pJOMLmGp+j
         rxaIwWjPhNLEHRsMURwUrpR6QH+RKFueC8VipxsTyZAzDH9ObBXKWf/Tckmgoh/6rROB
         Rkp08vbx+zGGEgVZPsIveiOzUfVjUJEKTvctnyqrmZbnmxGg84yA99UQ2CICMSNZeTO6
         P3LftIIKwFK+JQakFtJiGh6ks16D4kqjz6eRWv4oIqZWsHsF0d8ucezPAVOgkxNzXRSa
         56vg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773881806; x=1774486606; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOztz5HS7kfe0mJv/gYgM0otE4AvewQBLFhyRmLqVKA=;
        b=PHbTMQ8z9YELXDf2imdHPPHNCuj5ud3KVeN1hI6+TRJedU7XKj4cDJzZf/FZ0g026K
         PcRd2krQFyVPD4aPiskcTmI/fQdvgjpdfNvfeRckdN0gE0YON45UpLzlRTd2+571ohFf
         xx5QAHdXZPoMajYn1uC7NnQxJeaqj+Y/m2P4DlSM42U7Jm8n9wknJCq8QxZ3gXOGXdCf
         oJVQctaVJtEdZb/AQ/NpEii5JMMROsHf68hUqyYX38QtpN9axYafsCn5UvmwwLYd3Ouh
         sjTFD6V2SEUJ0e3Skgut+9KmkW0uQyWqD99za3MRTd5LoLiqHr2z6D8CV/cAbp/m+jIs
         Zyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773881806; x=1774486606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SOztz5HS7kfe0mJv/gYgM0otE4AvewQBLFhyRmLqVKA=;
        b=rwmvLv5aiHgP/lyUJVLSit2LNOYinpCJe5lpYqmNeX6cHLHz3zCgFarr/+HxA8bf5Q
         gdVKaA74h2ZA7/mj0MKV3AB4ITrc87iI6GGV43ABqdG73YiXv/z2uC0nIJrlVbEHgtdl
         Q0sqEAht1ireG9IVZXMO5x1sxoXrHKi07DTgurUIFER8S/sM1EeeKFwI2jA3/fqIl8/D
         nsvYQI+95TCCCvOcTZx/l/DFV3RVa77DjJswMx5NHtDCkrzlnjVtRfZS8G+p+bq6vg/w
         emU7cNqVqrv86Ik/zJwZbbjAPNkGyWUDYtFRjLu/d5Ttw/CGFUA2To0Va7jeXIi/X3Xn
         wQzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcmCQ8b4WSRGbNGxPis07uuiicgrXO4/T4nGsc12L0Rj3c/r4AKPgDKrQlPaLH96NW8/5jBZwzlQ==@kvack.org
X-Gm-Message-State: AOJu0YwDhsrTJNDcyqxPohk0KxBB7CIGQiTHOdIn7F4lVRLIdUzI0FbQ
	2iQASnJ49nUkC8C40oLnuPvDCLq8cgtXwVQkGts/GCCuw1nuqmXYz/79Lothh07MMAkz0ViKdjh
	sk5jJ9wmzDxkGHcxrOYw1YJzn0GCZPSJ4znDLszX3
X-Gm-Gg: ATEYQzxgaZSPzaSgd99CkdgF5K6P+fCr9tDQeo54TwNCB2FG3w7qUN0a4bJze0STaXL
	94CH8fkr/qvVRswnHU6FIiTWyaFOHZ3vVKX6OMgwpVAt7mRJ09UmbFgzc2FDsS0z83Z1cxk+xZ2
	8rzrJRVXxjNgpQWcsUN62C5hkUyY5jwwz8/iNMV2AzS1+/I7mguzTfCD24yNptb9rtIqSf3FAh/
	YgmBnzNmiDcRc9FIJCMrFpLbnrZK9LS4bBJnD/lGS+p/fOAP0PPldFofUWzg1GmhD1yseRWKWwv
	0Dag97Tt7KdprO+GfnCtVsSms+Ech9MmMuaSIhw=
X-Received: by 2002:a05:600d:111:b0:485:2ab4:c1f9 with SMTP id
 5b1f17b1804b1-486f8e8fcdemr284745e9.4.1773881805882; Wed, 18 Mar 2026
 17:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
 <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org>
In-Reply-To: <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org>
From: Juan Yescas <jyescas@google.com>
Date: Wed, 18 Mar 2026 17:56:34 -0700
X-Gm-Features: AaiRm50ujVQWqUuMIsLejks2TI27WTsDg48sdD7BDEqwNvEJ3jvKEAe7SLozDeg
Message-ID: <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via debugfs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	android-mm <android-mm@google.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: g1sxdo6giiz7nm5x5r4346zwi1gsx99m
X-Rspamd-Queue-Id: EC070140005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773881807-153819
X-HE-Meta: U2FsdGVkX19s/6c5SAIEEI7tyLQbUUu0Ims7fMQraj+afqhmMXyrSVST/JIP14RODL/Y9ymj9WZJU+H8OhcvadHRRCb1xBNsorMmLjjtn4UthH0gQVan/6lg7led5ubIu3VKL5V1A0l2fy9MsL4DIFMz+7fxjoLy3OO/gAzXpK5+kj+paW46RsiJrRSNDBLuWSAH6cHW89o+kzuVHgt4jYk1Mym4TXgYxyhiD1j8uiqrFOkndIkgu82yPzTqQpPnh2sg+q/YmPGrKNpj9Yy3+YWajcV5BxX2Z1Se0p6mXzXy6NmrwWTYLuMsfE2Anw4DkYCANS3D+wpbJtCo6vqZjI6zzKVJeH6JpxPbDpg2tziIC5oT5a6MtmbJSuNa+wNk+ALvoeEBp23nGd67dBNU/XMzXhQaLcDGN4mlSAH198vIzU6A6GjZVTZT2LNPs1DDfSivA/2iV1DubVJ5gLedCVd8rl63t4xu7hJcwv/LA0rbT6Otpgcth/XPW6dMqWELcKUE2M5kQuksuKZr0t011RWhA8j6uZDk3pZI9qqOoRDMNjW13ujkumBnaexboKAX1cI1r7Z2AkGyV7E8Ka3aZMfNcV2OuxNRItfI3z/wvJ+GQO1P7PN1/06TbS3J/9AIpadzVsveDLHwjrI5YkJkEGbb2ejkl/ISI7d+Flvqchh5pI0hnGRIHmnzADpQj/+79MItHVPyIUVEszR065l2VB0D6nvH7Zm/czK3dszfEPc4xle6TE3Khas5K/Uv/ONcbkQugdsrCkbpIUoHHdnRKSriJj7W1XU76TbWr3Q5Gy3wOJVqJGVH+lznI7Lo9hpPvIiVSjW9OYJo4nFjjMtJPaTrzWM1qMLiZYl6u9ilxfbcBdMw/CQGckqoQyhwBmwrqg65ZvpKeOOJNtCBJ2RffRQ/UYKGAlSy7YSJu31Cg8gM24kJdhjippxk1rU8fS8nGTViLrBwR9B+AcFDlG+
 HD4uU7QK
 oV2/m4yXFv6fr9aLVW/Kt6heDlC/SgTFTT1WYQkiG3VPDvi2iWS2Pu8aMO+m3tUgLYI1kIAwvt6I7gFv8aWrgXfLECTiJrktv9kV5zQIUt9ppr3CbedATEA+hpwN5CL4vemzG9N+IszEoT4V+qvaW0euAwl5rB50aYOPvN0cvx4l6+NLaDd1vKx5aFtDdVjXvrQ4Csh1nxLPsVGW3QbrsuR4kSCzYH/t2sWrBx8YprDAEJCFPRGOzB4O9WTJxzt/HEGfK1kQnxesgF58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks David for you comments,


On Mon, Mar 16, 2026 at 8:52=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/27/26 03:42, Juan Yescas wrote:
> > Hi LSF MM organizers
>
> Hi,
>
> I'm late ...
>
> >
> > I would like to propose a discussion on improving our ability to
> > reproduce complex memory allocation and reclaim scenarios, and solicit
> > feedback on a debugfs-based testing interface to help trigger these
> > edge cases.
> >
> > =3D=3D The Problem =3D=3D
> >
> > We frequently encounter complex memory management issues in the wild, i=
ncluding:
> >
> > - CMA allocation failures due to pinned MIGRATE_MOVABLE pages.
> > - Page migration and compaction failing during reclaim.
> > - Excessive reclaim loops triggered by specific workloads.
> > - OOM kills.
> >
> > Reproducing these specific memory states for debugging is currently
> > cumbersome. For instance, consuming most of the available
> > MIGRATE_MOVABLE memory, or forcing MIGRATE_UNMOVABLE allocations
> > specifically from Node 1 and Zone DMA directly from userspace,
> > requires writing custom kernel modules or relying on unreliable
> > userspace memory pressure tactics.
>
> I'm wondering whether an OOT module for this purpose would be sufficient?
>
> IOW, do we really have to have this in the upstream kernel, or could we
> have a public OOT module to perform these allocations?
>
> Then, there are no worries about API/Extensibility etc.
>
You=E2=80=99re right that going OOT would bypass the strict API stability a=
nd
extensibility requirements that come with being in-tree.

However, there are some symbols that we would need to be exported in
order for the module to compile.

> Or would you want to fire up this debugging on a production kernel? I
> would assume now.
>

Yes, that is actually one of our goals. We often encounter
"heisenbugs" that only manifest
under specific workloads and we want the ability to stress the memory subys=
tem.

For example, if we want to increase the unmovable allocations by 16 MiB,
a 4 KiB kernel, we can do

$ for i in {1..4} \
do  \
  echo 1 > /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Unmovab=
le/alloc
 \
done

And this is way more convenient than writing a test driver to make
only unmovable allocations.
The same apply for the other migrate types.

Having this driver upstream allows us to trigger these allocations
on-demand without the friction (or security risk) of
loading unsigned OOT modules into a locked-down device.

Thanks
Juan

> --
> Cheers,
>
> David

