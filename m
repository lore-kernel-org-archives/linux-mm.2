Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41322CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 14:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AFC28E0013; Fri, 10 Oct 2025 10:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760C68E0003; Fri, 10 Oct 2025 10:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676658E0013; Fri, 10 Oct 2025 10:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 508718E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:54:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0644158624
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:54:11 +0000 (UTC)
X-FDA: 83982499902.09.D265D1D
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 231C940018
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:54:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kNh2ac//";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760108049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DpdiimUJLGEL9YZv8OhwGPgsBnQcaD8Xj4apakBfn0=;
	b=DUZqSZkBc4pqqbQSeC0U3G+8N7UgvnnQ3GzDjrFTKPkKUO7pEt3BG2Jpwy6TyjrVi1UIK3
	I+0HnWS+XvP7mMxHS3cP9fKv+XD0BqW10hmYfoMNHcGeiufY1alCmndkgEJoMvGWO+iJmI
	sZBiewyI6np7xkyZ4wIlweJRavNwL6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760108049; a=rsa-sha256;
	cv=none;
	b=XyajAorvvRrWy1xC0aYX7K9WaIr0/2uicc3Co8d0PFvSnHqmsV+r5EkBs4se7LgHjcntvV
	STiW3dWs3Zg7163Tu8rH6nkPPJZUJjkhpwtboGBhGUNGjY2Xvilmu+Oue5wsqy9Xv3goB/
	ltfTa2nTmiZYp+lSvrLQXKOZocZpBh4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kNh2ac//";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4df3fabe9c2so377341cf.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760108048; x=1760712848; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0DpdiimUJLGEL9YZv8OhwGPgsBnQcaD8Xj4apakBfn0=;
        b=kNh2ac//jiSgZfL8Ps6+WKnMwPssD0odp8cmeoro9J4xRy/jMUtrQX/Hd0SJLceKEy
         yzjNp5ea5JSYS70zQy219cdUa5dK6/BmBH6Jwh1BwMLKXZGyO5BBlCHfDEXfJHdOc9jS
         eMNHBkSCQXjoOXrS7TaPCMceTdvHkRvpu4kiQckieJrSu3Sa4AqjMoTP9VqyQJLFHits
         c2rAM04aA7m02lfblMPR3grQwWa34w0a24JvglcTsZ5XDSUsvdeBXrFlv891k6ZOln+q
         pDdbJ5ie8a2ocUtWYe6PHDx3ebgJMB2reUgx8mWhzCKfK3eObrXBUTjn+vxXgSXPbUzr
         Lwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760108048; x=1760712848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0DpdiimUJLGEL9YZv8OhwGPgsBnQcaD8Xj4apakBfn0=;
        b=l1g24nXUJncDdPU8spWyaqCpQ/YdtfqS7U90MyHI5U3qaX/dP3hx3iXWmss4rpv8DR
         38HnpxXVappCmG9KYtHQZZOcohW9EI3I7hUsxhqu79F2OMUYOBLJ205mBCXVuzf/d/DL
         mGq58EFBygX2WG/cBPgagwZKlfwpXAK5o4bT8NDD/Mm/pg8mTugGsCJR6idJpzk6doTR
         /fVxID2A8qYviqZSgfuwALoEkdduykstI4F/acTP7O1UXHojkCYMgeRBskdLRRzdy7Be
         epsdHz3/BceFsNK2ddLIE5+9+hqeG6dw9jrvjG2gxIB5q/znzdPqm5xQP7OF/8tRHGNc
         2GAA==
X-Forwarded-Encrypted: i=1; AJvYcCXpbDYK43jSHd8enrxsm1AAxDYPk965ynWAYIG2qqC9KicJtRHyCdV0LXmABJGhKTtY4YCTkyUJ8w==@kvack.org
X-Gm-Message-State: AOJu0Yw+7VolQ7YSoBItxq6a4hmvZ//NR2VSteZYTlWTBBVNt4yUqUqS
	LwE4/IupWG2+tJMDehaAFxA7xg0Vhf2Nv+UDqMQ2idjZ5dENkaVKdFGrxqP2z4MApumHo0Cl/8k
	3D/MVX3XsJUEYKlbq4wpi7agdf5ksXS0NFzYZm1Wd
X-Gm-Gg: ASbGnctBpn6fMvyuQ5KvJYNy+8PNtXNmb9iScA9IFfagrCmkrRWrNX3ZUAAKGZXo3IQ
	0i7SgBHdXijJHxxkwe8KzWGJwLKUoeuutP+6a6Yo6qXAGJQd+4FNV44u/7GzTvhbyOM3T4jJhX7
	GvvKsTfam3RM9SPhyJAJciQZrkSholZM+AgCVCEcOqiwqSB7o/EAZRfg6MmictZAt83DFYhbEHu
	okKYGXnyA9LuuhUG5DLZEJF/WgmCX9K/1ndU+2E4WNJCfW57eap
X-Google-Smtp-Source: AGHT+IELG1HO5re9l71qV16AXiLCV5TxV3n/x4fv7b1UlE7oKp+shLXPJ4Ui15bl56g81Rjif4tTmM3A2oXDy0V1pv8=
X-Received: by 2002:a05:622a:50:b0:4d0:dff9:9518 with SMTP id
 d75a77b69052e-4e6eabcf616mr24839371cf.12.1760108047605; Fri, 10 Oct 2025
 07:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <20251010011951.2136980-1-surenb@google.com> <20251010011951.2136980-2-surenb@google.com>
 <aOhx9Zj1a6feN8wC@casper.infradead.org>
In-Reply-To: <aOhx9Zj1a6feN8wC@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 10 Oct 2025 07:53:56 -0700
X-Gm-Features: AS18NWBSQfAZ95bfn8zHE7YuLwgx02HxJfLsEBTBLUde_yaDHMul1ATmajxkrCY
Message-ID: <CAJuCfpH85Ns8_+JNG4HS6TnFMUN0si+mcLXxUxedhQh1c0CSEw@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm: implement cleancache
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com, 
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	hch@infradead.org, jack@suse.cz, m.szyprowski@samsung.com, 
	robin.murphy@arm.com, hannes@cmpxchg.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, minchan@kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 231C940018
X-Rspamd-Server: rspam02
X-Stat-Signature: 1k4kkupf9z3ej195jojdnr5dyaofg4xd
X-HE-Tag: 1760108048-391720
X-HE-Meta: U2FsdGVkX183pbL02Ufu8fZO1KK9h3fG/4RxJXx53vtuUVBJGuZH92cVwPJqjIR72C6jUYaXzd/gK94Fc+BxY7ccvJcbaDFBRuv8IaUtWMD7fEdHWLb3HIkzBDV9DQwdfJZ8GII3zkdiupUqieODmSzDmLYpaRFbdDHLnqjPvOEU3FaUG1aL/K8iqlSh/+W3+FN3fZxKlZ2HVel1XKqIXlbD+vTJxSkOdqfl89g2kaKpyIZGF30i/i9q8W0MaJ9UIoBkqPDy4d/DtFAPUdcOTIWQc5ZKfzqjS68Zh6i2U6tlfdQ7JbJtscWeCWCbBzdYQZBTGuy9xIws2sqDyiLP+IG1z+/uB2tUOUf8B0NP4A9unCX37hKTvTW3fXMLiZ3WQBfL2uvbe2uotj6lG6tGOQZ7zmSAM3GWhpfVf8IDj8rgXDkNqyyDAhQli1+tY45gFeOitldSxCtwcoiJRHqraNpWBJHYByc6pNMHCM/eW/aB/JdmRN3v51viEk/6feGClFcz9MHdRGsrUW49/49MQ1w3eGKyGJHEYhkB+LjjUZWATuHyzV7v0W8wy6hmTVaq9LsHU9xhYqAX2JKSOXa8p5lbNN/kJmDK5iXN2IQZlPVzX9St01iVIDCPtUP7z+q6qq9VaFL2u8mclaUcnMITSbQxcu+6RMmg2dZEmPS9+Cm1H1UV3M8HqINeA1tKf4OoGru18Q9aj98gHsibREP/yGBHYE0paLivaxNDcpPnIZOt4pJMOs65ThYJy1VolZOWVaPEOzPl6qFG5uj7wAvfBmYtg58luPKdMtaxfGYqcNAVkeYe1SLg0evINgeS8Gwepd1lQs8KGrVuK/U00aotiIxmOXT2Oun61m19+XkhRXStcoC+GwPV4ktpL6OVhYtmvchAhZkbKr6J/J4Fi6cesFLVExJIZdVHBoyognJ5f4RK0fe/+9rav+bT76+fU3zaPRpfWPU98Y0FvKe4RXu
 9xVi0oYg
 v/wChJSWiO25BovtginZS0swwzbTicySL7JG0i2uk4spl4qcJbZmxXiuobekQRUjc1EDA2u+AkKTZ3apAzFNkMSnw1tIWUVLMADF7M+10DTEaj/GiIthtnnkF3Wy/RD8S7ThawE/my8CYwEVEknfq+dRiEWd7LiS8V8dHbzswJPpgit8wyWGPJejAkFShRErfX3dhLPdpVoJxdt14/W+taJwcWT48AGGmzY9EIG46zwJGUnV53o14Twwgyl7sWwc0BnaR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 7:39=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Thu, Oct 09, 2025 at 06:19:44PM -0700, Suren Baghdasaryan wrote:
> > +     /*
> > +      * 99% of the time, we don't need to flush the cleancache on the =
bdev.
> > +      * But, for the strange corners, lets be cautious
> > +      */
> > +     cleancache_invalidate_inode(mapping, mapping->host);
>
> Why do we need to pass in both address_space and inode?

Ah, you mean why I don't use inode->i_mapping to get to its address
space? I think I can. I'll try, and unless something blows up, I'll
apply the change in the next version.

>
> > +/*
> > + * Backend API
> > + *
> > + * Cleancache does not touch page reference. Page refcount should be 1=
 when
> > + * page is placed or returned into cleancache and pages obtained from
> > + * cleancache will also have their refcount at 1.
>
> I don't like these references to page refcount.  Surely you mean folio
> refcount?

Yes, mea culpa :) Will fix.

>
> > +     help
> > +       Cleancache can be thought of as a page-granularity victim cache
> > +       for clean pages that the kernel's pageframe replacement algorit=
hm
> > +       (PFRA) would like to keep around, but can't since there isn't e=
nough
>
> PFRA seems to be an acronym you've just made up.  Why?

Inherited from the original cleancache documentation. Will remove.

>
> > +struct cleancache_inode {
> > +     struct inode *inode;
> > +     struct hlist_node hash;
> > +     refcount_t ref_count;
> > +     struct xarray folios; /* protected by folios.xa_lock */
>
> This is a pointless comment.  All xarrays are protected by their own
> xa_lock.

Ack.

>
> > +static DEFINE_IDR(fs_idr);
>
> No.  The IDR is deprecated.  Use an allocating XArray.

Ah, good to know. I'll change to xarray.

>
> > +/*
> > + * Folio attributes:
> > + *   folio->_mapcount - pool_id
> > + *   folio->mapping - ccinode reference or NULL if folio is unused
> > + *   folio->index - file offset
>
> No.  Don't reuse fields for something entirely different.  Put a
> properly named field in the union.

Ack.

>
> > +static void folio_attachment(struct folio *folio, struct cleancache_in=
ode **ccinode,
>
> Unnecessarily long line

Ack.

Thanks for the feedback, Matthew!

>

