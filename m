Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5122CAC5A5
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 15:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2998E0005; Sat, 20 Sep 2025 11:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAAC88E0001; Sat, 20 Sep 2025 11:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8598E0005; Sat, 20 Sep 2025 11:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE0638E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 11:54:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 720D2140142
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 15:54:49 +0000 (UTC)
X-FDA: 83910076698.26.E797C68
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9009E80004
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 15:54:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NBzPkJUw;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758383687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmL4fKaZHfu9Rove6sJqAWTVy87f5w83yGb6oPzqQsA=;
	b=tptUNLggx3TIpBOj7w7O5h7R4tIhszV0UscF+001NH24sSVYzZOuKmP/D6kqujuN7yG10a
	2qJaYJ9TkutTg7cx3NQ02aWSJ5WdEqTZDVPVKaFSWLz/nuuY0M1Ko85HXJsYtyKQb7aEZw
	COMsEYJP5fcuUzjg07Bh/hACIhEgqBw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NBzPkJUw;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758383687; a=rsa-sha256;
	cv=none;
	b=v3uXyKHshlESIIjRuIRcv4ZUgMk1yFXzxK6qKPkLUercMquugYkaA/wLAHpYzTARPqdy2N
	vQfDpBQaFRjWDK1FPvBfFVcjG1qOWesDYYbvVgyheYe4eqc1YZyO8PHQsZbMINT8A3/6ln
	tdDBzkJejU96Yrwm29XZ4lQw+xJB4AY=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3f0ae439b56so1128380f8f.3
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758383686; x=1758988486; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OmL4fKaZHfu9Rove6sJqAWTVy87f5w83yGb6oPzqQsA=;
        b=NBzPkJUw+VAfICbKWVnTcwLGkIJtQfV084/Nwv5VtC4A60J8uQ4V7jkIWolTHLDtg+
         732eU9OTVnktHuAuq7hfkEm72K/xki6yrpSekYfrVG73YpvHbRYMx0X5wKhxcJ+mFjx6
         ZboUFBnchREqV0QGpCFc3A4OVfuqIOqu5JrFIuU4pLy2TbB5NM3xXb3yqcveoSUc31hs
         vQI9+MlwSQYY4/B+TwRVpNBzGyhi9K+cmdYE46BWBaNoTUU10LF5sj0hCdoyR34Vha2V
         GJsxLofG7UV0LKX5Vv67bLQ+D0n/VPOkRpO9zemDdr6SDDhVzMGhIe4X4velRZUz0Sev
         +3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758383686; x=1758988486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OmL4fKaZHfu9Rove6sJqAWTVy87f5w83yGb6oPzqQsA=;
        b=NUX5HjjGI69lkUM9aqgtGwfGYnHsL2v4fcGSX+TVJJjEtPHT6a67dXHgdHUtIW8+88
         pq8BaM/ftsr5ECmny44wsythmoZ7xYUmCdlax1/l+9ROEtjg6oe70W4FpYO3xl/OtAwW
         e4EJ4tCetQi7f8891mYnHmL499hZGWuSmSiYamrBn5Y8LkApRbTRaMnVY0q2JZPpWcnh
         cNgK5v4oSQSAeyEBBSrdhtdJCOgCzbP7MCVWF0i3s7vSGkH+zFqSIYFBaaLjotLB3ibi
         6al3crseD7B2NciYJeN4OEgfi3z7rx8rfnHsbJtg3JsS0LI9+zjddEMiOXH6F0Ulex3T
         Gn9A==
X-Forwarded-Encrypted: i=1; AJvYcCUuy0n9CpYnv1xwxdE9xlgUp9SrxSN5M+TDpSN83uARNJ0uVIebzPa3VqL4/VvEbHEyJs1y/Q8YlA==@kvack.org
X-Gm-Message-State: AOJu0YzbRe8p+gaSe7dKwEgt7VP3bqIKOlo47TluDimj2QjO+OlKgmrf
	ypQCbmfmjNKxTEkQ3Qu80THXbh+WSmHLqnE/ppCyQ5yNwU6KWmSH7faLezVYqOXqLuQWqfUzIDn
	vDZbVjxviBOV1ltvQ5jb4GHt+COzOUHQ=
X-Gm-Gg: ASbGncuLsUxd18FBbZ9hcrUQlbj+RQJBibVLEhP+XUfQ9GPowO2Fyx6TuUEnaOJmQgL
	u9JgQ034Uv7uqVgG0s109tAa+iPlwB7+4dBQjzB1Ez7zMGBcxgFXCLtG0qzYMiUKktRTYXu721s
	YW8Vm1G7TnlDOzQ5nlgQaVeRsgVWCJcS5WaIn9AgR8s9W/yp7oozbjaDitg6XXRD2lVoksGXXox
	ZTPO9GjE3h9cHfb7coIb63pKMaE4U3xqpP3
X-Google-Smtp-Source: AGHT+IGfSRPp5unU0ikqgKe6L71mc7gqY7OrcTaOXCxInbx+GrRtbs1vqbP9ZDrhOUBg5/YKgmUImu9rrpRpu5dArLE=
X-Received: by 2002:a05:6000:1789:b0:3ee:154e:4f9 with SMTP id
 ffacd0b85a97d-3ee7d0c8af1mr7055134f8f.20.1758383685795; Sat, 20 Sep 2025
 08:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd>
 <CAADnVQK_wvu-KBgF6dNq=F5qNk-ons-w3UenJNaew6h9qTBpGw@mail.gmail.com> <eba3aiglp2hmj65sd4vsmav26o45orrlog2ifexd44yovygcdg@43wfk6dbgqda>
In-Reply-To: <eba3aiglp2hmj65sd4vsmav26o45orrlog2ifexd44yovygcdg@43wfk6dbgqda>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sat, 20 Sep 2025 08:54:34 -0700
X-Gm-Features: AS18NWC4-3QCvE4i9hUGZd-7Pyusy_D5tB_ZRka07Www2wvdZZcy7N-fgfJJ47M
Message-ID: <CAADnVQJF-JodmrfqJzwfpaK1wjmo6-4_R-cdUfu9ZFN52zxEsA@mail.gmail.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Peilin Ye <yepeilin@google.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Meta kernel team <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9009E80004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: u9i8oucbie49kak7ia8x61muyqhb8ehf
X-HE-Tag: 1758383687-892077
X-HE-Meta: U2FsdGVkX1/c6lncGKj9Zhvry42RscLcRZSHg6f+my8TILc7w8ko9fOHrsroOzkhL1GeQFdhhzBlibUHoj3BtjY7sosW2RM45gZpzbDK9+Kk+hrl7OW/yG3atRy5xfenTTQBcvO0q0qM7ZmF3WjGdB0FqeMyKLRoGCh7tY838XswZdtHeG3PFfZPzSKOhKQn3KB6Ra11zNOMUZ2qZ6kucelhB6ayuOYIET3OuyQdx+eFMHyyeyhMf9LqomNVd9+0Bh+zAoI+JtGR4LQ2lfVOaXgHuRJq1KCybrZPfHcjK2FCVxv0w4xkOe3ZQP5P4FND3fFRIOIPmVjvYcD1JxR20ZIkieIVOxKafGlsDB60trn4cLkqZ7pnB0RaCTLoRc/03zUTtmsnN/RO07RMvRA7QeKAulSxXBW2cLwqBrEdpwvNLWhB3blRZ3EMSn+wIpQWx+1HgxetK9gOKGD+Q53w5fRL9JbM/JBR10Ym7hCNFk6gDZ70xyPUSCgUUbZg0tTajm1j6/PF1FWkBUCJzbpOrTP9dh9iiKpxleM7EnkDs7Co5De2JOwZLVFzQIZ008zlJOlQrDuhth88aVNfu2DtXUgrFbnrBX9DwaAtVQVFQJSuiJwJYHlbcpx1KB2ZNgQ9wr4PNg/EjTy2PnGDVbrqpI5sn6Yl7anwhg+amPpFzFCd0nYXLwoMurxRUJ3iVUFGSYPlendHbpryL/JDUcbLk4EEku6I/JlIcRvcW1kifJrHLJeNTnWUdtc317pq4mkAUsQwocv61Z2XCiNUamcKL8GMw0r2osUBISNTDhbys7sAtsyo566010shIuq1rYxnxTCwKLprZHN8ZfZmFAtA/g2O7McSmDO5vM3DYN4cWJ4CmXJxDZBY0Bl9UmvhQVG8Xru7r6SEsyb7PUc7fscyd0hBT1nDHwZwCt+Cj+1KL3ciASxDvf9BsT7Al/sae8EQxKYqhVEAMjhKcTHg8P8
 9nantZ99
 4AJefB0gHRSMxL4QMj3wL8+ZhNNZ6D/7NFQWKUO0yVelo4J5P/QWANXFEs/wWmpBHGnBFp5y+8ZcycFVP+N9VftgKFz8TZlQcajkceWDqSLTE2QeZkDPvTps1ybx/hNK5aqf6M4U1zOB4G4i2sE/k/C7BTST0Hd4oVTIoInMVbkYKqrUWU3A+W1NiNX8UaNdNlYyAESZgvUuozWSboxtN9DqsRjHrFaM/taEQMym04U5711Bgj2Fcd7oW3ytShTGmurA28WjEe+q6S3ob5UwwoHPb+OpXwFQHHuDXU5+5+dCStOFP3sJ0gYoiRqOrifWFpF3mu5gUbdNkMFoklptdPI7dPpqRNoNDH4RUAzI58F2vn6BOmK1C9+3CVE7uYGIXWjWLbcDea/DBSGXx7oVPbknnWdtiuMyCT0TzzXqlTH2m7lG9gB40HiJhOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 9:31=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Sep 19, 2025 at 07:47:57PM -0700, Alexei Starovoitov wrote:
> > On Thu, Sep 18, 2025 at 7:49=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> [...]
> > > +
> > > +static DEFINE_PER_CPU(struct defer_memcg_events, postpone_events) =
=3D {
> > > +       .memcg_llist =3D LLIST_HEAD_INIT(memcg_llist),
> > > +       .work =3D IRQ_WORK_INIT(process_deferred_events),
> > > +};
> >
> > Why all these per cpu stuff ? I don't understand what it helps with.
> > To have max_events per-cpu?
> > Just one global llist and irq_work will do just fine.
> > and global max_events too.
>
> Right, global llist and irq_work will work but max_events has to be
> per-memcg. In addition we will need llist_node per-memcg and I think we
> will need to do a similar cmpxchg trick I did in css_rstat_updated() to
> eliminate the potential race of llist_node of a given memcg i.e.
> multiple CPUs trying to add llist_node of a memcg to the global llist.

ohh. that cmpxchg is quite unusual. Never seen anything like that.
I'm not convinced it's correct either.
I would replace that with traditional:
if (!atomic_xchg(&c->enqueued, 1))
   if (llist_add(&c->llnode, &global_llist))
     irq_work_queue(&global_irq_work);

and use traditional dequeue:

nodes =3D llist_del_all(&global_llist);
for_each(nodes) {
  memcg_memory_event(c, MEMCG_MAX);
  atomic_set(&c->enqueued, 0);
}

since llist_del_first_init() is slower.

max_events still looks unnecessary to me.

> This can work but I am still debating if this additional complexity is
> worth it as compared to the original patch where we skip
> cgroup_file_notify() for !allow_spinning condition.

I would skip it too. deferral doesn't seem necessary.

