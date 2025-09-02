Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C79CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 18:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8D58E0002; Tue,  2 Sep 2025 14:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771A48E0001; Tue,  2 Sep 2025 14:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639FD8E0002; Tue,  2 Sep 2025 14:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DAC68E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:59:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDFC185197
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 18:59:38 +0000 (UTC)
X-FDA: 83845224036.28.FF338EC
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3A0EB140006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 18:59:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="n+nfXo/5";
	spf=pass (imf09.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756839577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PO6uBrgZrvwvFD9Y2iG++L1mUkkDAtsEspEBPhAeKaA=;
	b=IJPmTNEJHmALOL9YmB82ijulyHuklJpvxvXpOqDSzmLekTCXeQlihMiDBRSXNNsqTx8XP3
	rmKq1J2E1Mex5EWNtvQph6Z78mNeBXEXTZwDZE2wtu+WQ/UX2S1M7eNudaAMuQw7Hf1gyH
	rTFPgA37hQXlgpimghjPLVymMP80tSo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="n+nfXo/5";
	spf=pass (imf09.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756839577; a=rsa-sha256;
	cv=none;
	b=qIQlcJz4V72XH4m9Jhj9XbO90aTVWK3qHs68XnhX8oxVteKqi6DwEpKKixe69mcIm8kER1
	XkATE7pQWdECN6uIqL2KWlIHspbRKXpYub01Xrv7YHlxrUav/yF2mvgPp3clL3ay9EaHq7
	LFLu3nN0HK6E1ixQLS6LQ+D+3CMKBB0=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61ed395ba46so3186a12.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 11:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756839575; x=1757444375; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PO6uBrgZrvwvFD9Y2iG++L1mUkkDAtsEspEBPhAeKaA=;
        b=n+nfXo/5F9EAJHcv7/BqxCRVdkdjLH5INC0KXU2U8oBAbDIjtg142Lsb+sqFtW7ydX
         J/AdRG4hAZpc0eeXoDAubsVndSsJq4+0PkrX1UHRijso+/UPse2sc2o0ME6WvgG3gi6x
         U0T49W1sge+cbt3PaseurZXEoS7S8JBaTQ1TtPGQW1GKwzyyw88vYiHQNxIXFtiuOXnu
         TV2yo6YcZB6sFAu2UGeUJ7S9sgmyM+OT5HeCz0kMC0Eds5TzwccYhHTXXu5qJzK9ZdnB
         POvCx0cu1Ho8V8JZiKu1gnlNAYzEoxS6WG1F0LxX9xxJIbA+DWypA6JgFi4PzlWX4Sxu
         kujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756839575; x=1757444375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PO6uBrgZrvwvFD9Y2iG++L1mUkkDAtsEspEBPhAeKaA=;
        b=bKsXtFGS58mikgMgimNCtvHHE7dBqV2AP7TVGWTrAztbR2Nh8LuYg/p+YJxHHkkiVe
         xFsLm0lR3jB+rOlz2Bqs7DMkBLifIjj2YvA+axXKWZQ39SzJ3x8kDCB6vAvPEKGvd2Vm
         60Ncpxd87PrIBbEEzBkHMCG1L5kdAL+9WC5OZuz+82A/sWTpZsyRhg4AAUXBg022rJZg
         k+KQncsrw41/GVvX7gf54e+XnML8WpFtrj78HTHzgX7HQz8XnLtv1ilMvSrgLtq7psXx
         z7X78kVTDbAD23RyNSDSu4XfJLIcD/1tdam7jot7JovMr5RIs5GZkgHTtyKY6h14ABNU
         ko3A==
X-Forwarded-Encrypted: i=1; AJvYcCVAEy0u6MtqQAkm+u7x6M1x0Hea3V+XbKqX732Cj9f7Knt1Qj/HIzOaF765zSssnId3MJOiXiKyWA==@kvack.org
X-Gm-Message-State: AOJu0Yz+Y2kcQ/sphsnGsJ77Ejs+TdROasXyRbWrulpszH3OY/OBZ1fL
	hjd5d99XAKtTG8B5DTigm0pW1I7FPJTgLb6SCC1nJUMdBH3xCuvDWSZjZL2DR91ALA0MVhCydF6
	qH2GB6HBCWJbESgKvJP5PRPo3OOmo+3W7BY4UyJAw
X-Gm-Gg: ASbGnctfx7NqgqPzZv0+oyHxkh8xKys/vWGcQt6y8XLjB+4Z0WDuESxt3Y3yB+UwWYX
	pGaiFxGtyAY3k2QK9cAOZAjPe1uIF81Jjsf07ljEHqmzgQlrCT22tkH8FOBFAMDqTu4G7IbmhLs
	eETq4u8YHKSPrX3wzSKRgS4Qgq9x+vSoYJfy+eU+C/A484+yX+xf0AtMNiG/+KYMWUrOsiYgKcz
	fPuDzX/SanQPdXhxA86833WZF3LwajMdSJC4a6gR1N+
X-Google-Smtp-Source: AGHT+IFjfqil45P3xLPeX6vA2o1kgdJcuyVtGZnjUPClXaZBLSK1c50QtoACsnaFusJcVUUuKEVNu0qgZ5/GvOSAzPo=
X-Received: by 2002:a05:6402:2397:b0:61c:1dbc:67a with SMTP id
 4fb4d7f45d1cf-61d21f059e4mr215637a12.3.1756839575381; Tue, 02 Sep 2025
 11:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com> <a0350dd8-748b-41d5-899e-1505bd2b2e80@lucifer.local>
 <CA+EESO73TRAcMWeo_aXkLM+0rT5nt1cxyvf+Ye3Xp9kqxL5=6Q@mail.gmail.com>
 <f5cb68a7-19eb-40aa-95f7-51fd004a3f8e@redhat.com> <e6b12ef9-1808-45a3-9d64-5c7fd1904b5b@lucifer.local>
In-Reply-To: <e6b12ef9-1808-45a3-9d64-5c7fd1904b5b@lucifer.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Tue, 2 Sep 2025 11:59:23 -0700
X-Gm-Features: Ac12FXyu_JdCq7fD2tQ0dRu3q6Is8GLBBBqLQORpRzSbl-I9vnpCRz2PF9AzEko
Message-ID: <CA+EESO5FnraOUV=CzcD6t_e086pC7rDZuVv4w2ng==7KacA=Pg@mail.gmail.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>, Barry Song <21cnbao@gmail.com>, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A0EB140006
X-Stat-Signature: s747ouc8j4oze45kfb9hqzezk59isj7z
X-Rspam-User: 
X-HE-Tag: 1756839576-670268
X-HE-Meta: U2FsdGVkX189LP/X/E9lZ9O9FM9eygU49Y39EJ9+Oo8jOnaVyktOw2hwn3MUVuivXI7g2/qyBd/RhrJcmJnYQfS4K6XVtyS+FMfMjk7+xfTVbe+74I65Z2XNNoYZ6s+SYfCZNQcp62Jrp16qAd7wCKdyAbzY0ujXMbYzAEa/Hynti/Mh+fZnjkfZeITJwZGLJFlRa6vBLsmgOTL9rzJ7JOpvMy809CfAlM9F3tayZI19/a8a0JZzvwvshC4qhFhpp4b64Taeub+GBKY3+nl/1UrlCJO85vdU+sxIZP0EIWznJ1dy+6IDUYAKiOOwaI51m5PIo1qfn7Y4DBBgGZD57NpFl2eDMXvB1VOe1mDpdY19BwTQxXknQL5Thl0nPndIe7afyDGSLhpAqtH41CompQ/cfPOZbBIdKR8OZNSBvrhzGQJz3U0ZkTZaBZXr6Tl85FEJIPOq5qf1bmACLfsgATPQXpQtDzx9SGXocp/NEDhXzOM1B9MQvOD1dHzImg++OycOTa9Inxay4bQaXhaCHFdHb/OPPL1WntKbvTmmGjqSjiFXC0OkmLSh4BmBVQtYRrjRaTYURy3fLGwFhtIJStPVt76J1narbtkmE1o7yIdcgCYliHjTdFuEuqjbgtg6v3PcWtLGC8LksUaet6SWi0/OaCEXV91XMQrvyCUiX/5JQkjpyQwYBwc+rRaO82PLPqMU77Bk7hfAzMNHnSTwnuk2Q01DgAj12uu+TUpGY2zHwuu+Ohv1yu/NbxU8SLOsRDGgLWbKhgyhhvILCBQoYlq2Z1tspqo9psNw+nDZGKzJophlyBvhy5Gm548TUIMzGMcXWzTIzVqj1gyz2wup7acUHGPVpiNV+Q4f8mFLLaoejDUxFz6Xd5/xfWKlJAj/8oEdJf8UMvvl5zHK/K9pkCdG7dP1kLeDuhv+cVoYzf1VSokukA7XEhPFcmEyBWBEUlFunTDriPU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 2:04=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Aug 29, 2025 at 10:42:45AM +0200, David Hildenbrand wrote:
> > > >
> > > > I do wonder if we can identify this case and handle things differen=
tly.
> > > >
> > > > Perhaps even saying 'try and get the rmap lock, but if there's "too=
 much"
> > > > contention, grab the folio lock.
> > >
> > > Can you please elaborate what you mean? Where do you mean we can
> > > possibly do something like this?
> > >
> > > UFFD move only works on PageAnonExclusive folios. So, would it help
> > > (in terms of avoiding contention) if we were to change the condition:
> >
> > I think we shouldn't be using PAE here. Once could consider using
> > folio_maybe_mapped_shared(), and assume contention on the folio lock if=
 it
> > is maybe mapped shared.
>
> Interesting!
>
> >
> > But the real question is with whom we would be contending for the folio
> > lock.
> >
> > Is it really other processes mapping that folio? I'm not so sure.
>
> Yeah, I might go off and do some research myself on this, actually. Nail =
down
> wehre this might actually happen.
>
> Generally I'm softening on this and maybe we're good with the proposed ch=
ange.
>
> But still want to be super careful here... :)
>
Anxiously waiting for your assessment. Fingers crossed :)
> >
> > --
> > Cheers
> >
> > David / dhildenb
> >
>
> Cheers, Lorenzo

