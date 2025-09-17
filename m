Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6190CCAC59F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 23:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31378E008A; Wed, 17 Sep 2025 19:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08BE8E006B; Wed, 17 Sep 2025 19:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945428E008A; Wed, 17 Sep 2025 19:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8449F8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:02:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E2135AAF8
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:02:36 +0000 (UTC)
X-FDA: 83900268312.10.A5DCFE9
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0F15240002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:02:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xAmtbcSr;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758150154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgqaaTpUUF1iWySwtTjmi51gf1ofnrMUlJLbXGuFg1Y=;
	b=TRTgoIpTZqqcKMtrRahe+d6VrM8HqSqFmGBb0SObRCk1WCW0RF92bdpjYITTfR2OAVTTSr
	uYTEfxQNkWJSMqypYOK0YAAHA3RFy4c52fsQp5TVN0NaqjztBnMDaHXV7udpIRq4GzK2g6
	h82yuaJIv62/yoMouI9NX6R41omYgso=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xAmtbcSr;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758150154; a=rsa-sha256;
	cv=none;
	b=SAHTkOVZDFVb3228lNHWudjH9KKcISVMZkcTbWj7MgBKrsR8xdxSdS0hGLTK6nHGwO2PZf
	hLOhQAbqp5qAQIUxwGhr6VIQC7WK6DnkO3RLiIeL2to+SdloXJvvAzWb/pQfnDLloHitTs
	mY1/TJXADguhVIrM3EMhkAilwapcbUM=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b796ff6d45so99201cf.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758150153; x=1758754953; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgqaaTpUUF1iWySwtTjmi51gf1ofnrMUlJLbXGuFg1Y=;
        b=xAmtbcSr6uArVUynVjGUwd/HRCENqCFoLs1lUcFhsJGKqIv17M5E/+wjcXBGMptWh4
         2DlCUa2ZNzwHUtewMNe/TeEsfXUR+EncVJAMy9JFma+Id6+3bH6WZ6fxUR8aTCIqIn2G
         G37dLkMgbbUVj0wGNFS7YKX3OtjzO+HwpjciYbTHFSJNndNOUdEolPo8NsHhN4xqx2Xm
         dpBQEzuitWCnpTLS5BORpIg7/R4bbHd9J86+3gdeEgQg5BV0EFQ/67PJrEHjBsZZeeIY
         b+W4b5e8a3T3RRjbeRcSsJIY/184Xan0SRLL5ZdPBdzR0zexosNHNm3hrAwA5LC3fGCS
         6jOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758150153; x=1758754953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pgqaaTpUUF1iWySwtTjmi51gf1ofnrMUlJLbXGuFg1Y=;
        b=TpNM6i20amdF9zIN24RSv5J+dHnxLnnds5+fKvIK+HWlM9dEdjK03T2KcgUH2bV94M
         eHnsjjX3WQhek5zZ6wx6/tenlW9OeaPzWYd8sevehuodJbI4FgZ9E9NS3VwSS4b5jEx7
         30SSilgdQ38mDSNViz5mio0G518/Mvps6/8VYX3T1Duc9PUOL4235M97iUgW6EH3YaY9
         gwn/We0O+JNTXsUcnkvPG5g0TfSjtIRQeHq4TcXfgkH2kjX6Xk0BXlRlePm8VA2OUg2u
         5M9ML217n1gzzclTVWCsHIG9TM4djNuhlJB1h3JPLu6uhXywIRsnUwXl0HrrTRjS7jTh
         v98g==
X-Forwarded-Encrypted: i=1; AJvYcCXq45A3FN1ck8o+7NJyAPRKJtmYkDPe8yEpyuOh3nHfMj/4frRe3cQnCTEIjo997tmPtlVXCVEtVg==@kvack.org
X-Gm-Message-State: AOJu0Yz9eN0HZkmeGBK4ghyhsLX3OZikCqxBJJBsQlZOjdAZkY3Pi3tw
	CJhs7X2Q8Dbf9vFBzKgWbADPKCZNguZ9CdY+ysF4TTUFqcTTV3o6FcFkx2EY6uR4ohbA9l1bu53
	Q0u2Boe3L7C5B7KQLOkPsmmr5fXPeHsglE1QlSSF6
X-Gm-Gg: ASbGncshiME6z6AhX0yvYTmo8FHQEae2+mKvqAoD/nDM54V2I2qs02eDii1S4Iq2p4g
	n/3wYJdXRuj7t1JPI0dqErY8271FHG83JZcBq5aKd62zMzeY/oM5hLnW0R0pRxmkrTkk3r+lSFX
	qOQ9f1UzgQGQ0f6Lc08Qq5aLa1keiZ9+xIo0LFt3SzboXjletBNSSPfppJgTQe+vMQbToY3xXUZ
	tonetV9LvFi7wlaMK4Hve/khhp0crM=
X-Google-Smtp-Source: AGHT+IHfNd/k82j9KQVELxfP/PHIbhVVGF3yc0CdD17H0HaS07rG6JkXznFxGYRKvVp7xhpstaqIEbhS5CNnvvGnMEY=
X-Received: by 2002:a05:622a:1998:b0:4b7:a2be:bc71 with SMTP id
 d75a77b69052e-4ba2e66f7c9mr8883171cf.9.1758150152768; Wed, 17 Sep 2025
 16:02:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com> <2d8eb571-6d76-4a9e-8d08-0da251a73f33@suse.cz>
 <CAJuCfpHXAhGZb1aOPyHOPiTWSwQJi570THqJQcjrVPf=4Dt3xQ@mail.gmail.com>
 <a8519bca-ae16-4642-84a1-4038b12e8bb0@gmail.com> <CAJuCfpFJabb02OK8Rj08d7WU_7AM674i=vsZxzfw7i7h-PGftQ@mail.gmail.com>
 <e5e3d96a-d0aa-4466-8303-5a7e8f96bbe5@gmail.com> <CAJuCfpEULVxMixDjrk_xg7+3+97dkcMmkDd++BaR17X4tDSs6Q@mail.gmail.com>
 <af62a2c2-3c01-408d-b694-aa7e95d23c18@suse.cz>
In-Reply-To: <af62a2c2-3c01-408d-b694-aa7e95d23c18@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Sep 2025 16:02:21 -0700
X-Gm-Features: AS18NWC5wZWoJ9h1q0dLcyZhaQxEfSzQ_NlOG7YOUGtZPGOPImgmHsFxTkhQl-o
Message-ID: <CAJuCfpFAt1jS49R5xR1MELd83oh7MN5GWd2hSMEj2SQVjyJxyQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Usama Arif <usamaarif642@gmail.com>, akpm@linux-foundation.org, 
	kent.overstreet@linux.dev, hannes@cmpxchg.org, rientjes@google.com, 
	roman.gushchin@linux.dev, harry.yoo@oracle.com, shakeel.butt@linux.dev, 
	00107082@163.com, pyyjason@gmail.com, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0F15240002
X-Stat-Signature: pm1k1qerm1kytzorep7ftm7f7y548s4d
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758150153-513648
X-HE-Meta: U2FsdGVkX1/CZGeEkoWZRL7YIaqAQs2IbazY4lYTZb4RRxrdjjUySlI0Pt585ksz8JbegT0f6fCVWWuU2ard6F8s5urMR5rTpHdDZ3f3uBnSBwV2oNLzZg/JMcMib/K0ApAZFWPg/Wfi2JCf9lvDsXAf9frYS69rScg+H5aH9cOqz3VIdSRRvlKFxd+atDXvO/MDoNy0lqDn/UDSe9LJAbm03wqn8c2Ley8lvx8s4ag7rWZ5gSdmpK6zZ0erMKDRiZdELdwAU9PFbG5XX7eQpt9Gdl8N9B3PIcJFvZK0H9/4HXypaSs9s1kRgypHDQKh+tzprHl+hRfgJhbLHKSK2eYarTI4Fo1SN7W/57Btd4F0d9GKrVDjPbmFONGp9zfpybcrfn8u7I7/013kenP/vkHUR7LF14iuEtRZRm/ippt6gYu7k/9GNXvbzM4ypOXX+sbEewI4NEwMQsKodMm/hWKVuTvMEkLfZf2Vb+YdL2nU5TzaffF5uzQFaCMjrBiBbwA8OOn924ELJf5AGM6G+/sbtrj5Ax5AUkENsXy6Qz4F+qlWMht1dtye2q1Gd+rYb/EvwokWODLDcTv2cWUu+K17r+CNPusx9EYiuRUmBr4EMSsc1MbREFbw4ITrVGTHVC7aJbUmrY/3Psiu8A4+RMBu/ASNNzn3g7/OQWzUhQNXiDHZdBB/z7+IkyhuGw8l7tGR9M8ZXZ0WLm9UoBKnPYI0UfBs4XbUHv2cQpCP4Vwryo+ceP0jU9AublCIbGWkY1sFa55+0bu9LLB62A/dnrA/mRux5MIBE17ByfQSfW4egyDxQTW9Ne6EcAehdAOke6h3PI/t+21ShjpyNsiACJXpQz69fNPpARdG6kGtg/wlJFQJvbA4kd5HfqmyfAJlKajy6tlTMoxr+Aej/1w4kwILJDZqfCFwPwH9vEAH3C3RfRV8PvanFQIwXZA9pp3woWBWPxSXKEotlJKZHJT
 2Nnh+Rp6
 BbLVhC2iinZy4zbSQ7BA5wjw31tIaGpdsb7QFTzJqAiWmQRjbo9QBJJ/12Csbjbyw2d8o6ah8zw6Pq66uICMj1FZ6N37w3dfBxK1KArBj/3v1rQm3IWBQVIKqdutRL7zNb8AJdX8ddkX/Oxs/7gJK18vqSk9chG2RxVlm0QayHqfuJzmUgaArnGyzp72z2UtEnBzRRaHKNruxK+p+LyKqxvrgEPnwuBEkIrefRylz83ve7CpGJqjslCzSitdmHmvOjVnNpjxn3WuYgyrSPutzmdF7vohWPBJwjEbi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:38=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 9/17/25 00:26, Suren Baghdasaryan wrote:
> > On Tue, Sep 16, 2025 at 9:52=E2=80=AFPM Usama Arif <usamaarif642@gmail.=
com> wrote:
> >
> > Hmm. Missing a large allocation and not knowing about it can be a probl=
em...
> > I'll start sketching a patch to see if tracking such a global counter
> > has any drawbacks and in the meantime I'm open to suggestions on how
> > to expose it to the userspace.
>
> Could it be made to look like an actual tag in the output?
> e.g. lib/alloc_tag.c:1234 func:untracked_slab_objects

Technically I think we can do that but it feels a bit hacky... I'll
keep this option in mind and wait for more suggestions. Thanks
Vlastimil!

>
> (probably some better name conveying it's uknown due to failure to alloca=
te
> objexts)
>
> Maybe even implemented in a way that it's not a specially crafted output =
line.
>
> > About concerns on the IOCTL interface, would it be more usable if we
> > get the alloctop [1] or a similar tool which can be used to easily
> > issue such commands into kernel/tools?
> >
> > [1] https://android-review.git.corp.google.com/c/platform/system/memory=
/libmeminfo/+/3431860
> >
> >>
>

