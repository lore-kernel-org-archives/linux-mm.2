Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA6F8CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415E78E0014; Wed, 22 Oct 2025 11:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED628E0003; Wed, 22 Oct 2025 11:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A378E0014; Wed, 22 Oct 2025 11:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20F788E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:31:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8E2A13BE50
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:31:34 +0000 (UTC)
X-FDA: 84026139708.26.7DDE787
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8743A1C0004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:31:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=C6ooStcu;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761147092; a=rsa-sha256;
	cv=none;
	b=1hRmqiDDoSeTcrMH5vJs8s3B6PURVcCJwRRmRGZj7VtKi3zYBFxb4WyjXKMJpLz63EXnDW
	6uf/iarlUxsMWOMMoFTgcKLmcqx/KaWNA9kczKRQLcv5wzNnG2IS2ud6f/LcphqJZQg/+9
	FL/7gmwoBRK1Pqp15jOQndLjWJur3Qc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=C6ooStcu;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761147092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7W+TKsiVoFH6YSztkZcDFcv21KuO/v7xKh45svbjJc=;
	b=FMWacODgqnC5sKgMDkzKddOZqr8eEJ3gxjdj+2xepPekE2fM7Wi8/nCfVf0tTn+Dm6+Ki5
	NV93eEHKKUqZYwsuGSsf1hebwJ2K4Ux27SdzSlBNw1HaG8x361wR4M6xmAT2VoYon6fB+f
	SwxnMYk3AvH8ns3KLfaVJZviiZG2RG4=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-63c4c346bd9so9168396a12.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761147090; x=1761751890; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o7W+TKsiVoFH6YSztkZcDFcv21KuO/v7xKh45svbjJc=;
        b=C6ooStcukk93uLUHMPoDWjx83AOkTfZH+ldeKxWtLCQIsFLZWLSRpAPIn8rqua43lu
         Kazu3pEgT3ks7CBezhtovQNiFZLsXIHOavnR5gXgboKB/dPMOE6CmO5pDhkZ0vRnC0L/
         fghF/n6REMgMyJ9dLkUeZ50Ulq0qrylnJzMFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761147090; x=1761751890;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o7W+TKsiVoFH6YSztkZcDFcv21KuO/v7xKh45svbjJc=;
        b=B7orvpRNyA3EJLsuIL+eG4iIKUYFjtm6s1DYFjzVRNKPnpZy9cL5uRm6FA8yV8X6GJ
         0OcRfAQ54KrYX4hM7BEv+yfClnVJ0T5otGZEoQIMt378OjfHajfUVj1kzI9AGkCcpyho
         rfVEMJfKCg7KmuBaPD9SpNYlP/ks69z6p3Gn/tu5Y1cPffWblp9LCp/IML+qx/aQKYNO
         vyHcdt4tg8WUrgiOFszcZ3jbkaut8RsLkjtFx/zqs2/BfQeTXL//KTEULCuU/cbh6In6
         qbN+XYZ5bngE3lVVNTxr4IHGMoG7GiR+xhOB33ZH8iRA27jLZNjnHPhBgSocGSknL6MF
         echg==
X-Forwarded-Encrypted: i=1; AJvYcCUj5CxqhFMdaIaDtTVHrLlzjxnuJtv87EYXqQVoTlND2H5obrh4z0W29mPPVt4W8mSFdQJpah/tVg==@kvack.org
X-Gm-Message-State: AOJu0YxwZTrAUS3dr4dsP8vJvB6ZwB/jYd8vjSB2TRbzaNf1nAk7T7JN
	JN+vnIq9ZuS5AwR4eFwD4jv3hZExKUU/yhQ2YuUCxu7mKxSCklW+BPvbFBB447uSsqV+7GcaJCp
	uB4C19Lg=
X-Gm-Gg: ASbGnctDO7tjK4iyxcVblYfB+MgcDgZHCHc75QbWIhiqkObk3xmYlTggfqxs0IyiDoW
	sol/eLuRIX/mNib/FcJaPMFQ3esLJEDfFTfAzABumbwDLKizLhknIkFiBKU1AFxto2rRYsHST15
	P9Bn3JoJBB23K8QiNYfsfgdATOrWxtupcQjDPRzf2DRhJBdocy/zQpnXGW9HVR3Aizi6KQEVpoU
	UWfp0GcwfldAmdsHmPn9Qe+I6M9v3QlAVrWINMQAtFRNguAHjxsmiZERNqoYXynXFf+1zNLPiSg
	XVMps7FPlgnQy/Sy6lkGA0przcQjIdITGXt4reyuv8TZ7cuClIYXDv3o35kxN72QeM9BPC+JMAw
	oFcQbxUKhqJI5ydFW/o+UUl3UKRt+5Q2oL8byIwDQqCVd9kqSL1edaUi2Ijh+050VJbAMJeJLsT
	0gq5sKzU8gjUeofIiaPmjUNuoLpe7zmjzqtlseJSlw4UVo6rkk5PG6XTKX/S0j
X-Google-Smtp-Source: AGHT+IGBHtnTBWiq0AAUsnGPNX3Uz2X4tMqNYDaBMaGwjwqfrdU1bF+HvnLHKKUO1IMhylnT60KeAg==
X-Received: by 2002:a05:6402:848:b0:639:c94f:93b9 with SMTP id 4fb4d7f45d1cf-63c1f6d4691mr19518240a12.33.1761147090430;
        Wed, 22 Oct 2025 08:31:30 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c48a928cesm12500485a12.7.2025.10.22.08.31.29
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 08:31:29 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b5b823b4f3dso1334670566b.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:31:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXO8UV6BK8/1SDCpht18luJxKhqgsKlQ/IPokFzOjeNW+x0qcZaCroF0SaRtKNjBqkNml67N7Tzhw==@kvack.org
X-Received: by 2002:a17:907:980f:b0:b3c:3c8e:189d with SMTP id
 a640c23a62f3a-b6474b37113mr2725824966b.32.1761147088921; Wed, 22 Oct 2025
 08:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <20251017141536.577466-1-kirill@shutemov.name> <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
 <44ubh4cybuwsb4b6na3m4h3yrjbweiso5pafzgf57a4wgzd235@pgl54elpqgxa>
 <aPgZthYaP7Flda0z@dread.disaster.area> <CAHk-=wjaR_v5Gc_SUGkiz39_hiRHb-AEChknoAu9BUrQRSznAw@mail.gmail.com>
 <aPiPG1-VDV7ZV2_F@dread.disaster.area>
In-Reply-To: <aPiPG1-VDV7ZV2_F@dread.disaster.area>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Oct 2025 05:31:12 -1000
X-Gmail-Original-Message-ID: <CAHk-=wjVOhYTtT9pjzAqXoXdinrV9+uiYfUyoQ5RFmTEvua-Jg@mail.gmail.com>
X-Gm-Features: AS18NWBLPYl4FSdSEwqLouztsANoG3qy-LQaVLkVbPvmlrLzgiJvczojC-Vgh9A
Message-ID: <CAHk-=wjVOhYTtT9pjzAqXoXdinrV9+uiYfUyoQ5RFmTEvua-Jg@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Dave Chinner <david@fromorbit.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8743A1C0004
X-Stat-Signature: g9jmsoz6d5ih8uw3anmomajwsydpsxjf
X-HE-Tag: 1761147092-757026
X-HE-Meta: U2FsdGVkX1+rd2lkR4Afxqpb/p0eU9ZonOQ44hle5NuwY39nMxCKaSzj2Xl1+F5RMTWtdpHqD/41d9xn+f4xAFuYWlw/QoJ+GUWTUCtM1xq4YowzJUGNr03RqlVbq6oHVysDexMbd0JmuZ4AvWsclpQyonjq/wJq6ePgw/bBAT7/P9goqHoQfUuj/ikDU43/BbPa3ETQcDgHN6ePwOwRo9ZqDxjUNIERclbVnc5mvFZYaqOMHrvks67ioiIx//MGkRxLm9bm/++7+3boGIcjlsevON0hlUOPTg4M7Py6JGVI3gCrtKEhf79l9zETkg3il9Bt1ARaxU6Xg3GVT0iJfUV1JtHtlFEY9ugXwaYPjtorhW2SEk/Xw12N0t5n6x5EJBR/sYNI9H22NBmjRFpUqSvlNNZ/v1sDO/9G4KKnY5rq8NrKz6hMQHhcfc0cjVC+q63Ov3ifVYY03yEs9ROk36RTxQUYqnYhmpQ3xw6O9+GEVXFWcejylFsB1N0P8yaodl0DPRJ5gM3QwHpHja/Z34PrvWNDd7GomaTh0kPTY0YYgXped/UVBBV81QvZROO4r3QEf4KI0s7twYT3AeMZ1ZWcWcOWCsOa1rfF6X7A+etuGj3fwa8orKN0/RMqHMdx3twJ1c/PTctCPA9e9PrysFYpxWBtjlRT8DuYMNn7AH8fspPsq1C4srmmY8PcITpLKLT+CSy4wiD39LpnpFbYQ7dXKqvZ5krml8YlOcoYOtv8SUnlofHJHQ+KoGCSp1p5Z83s744gUD1sxjZEAblHJfVTw+fk1vGAj6d6kBZpsBEp2OO0n3grWgk3c2lqpz910l5YJdll9AlS8q80YpRZJJKH/84Qf6dULzKp7yUxLMJX6hRU36X9LKaa+AuC2jcBB+4MGYWS6neDXhMNNkHIuk5lstFtyiHdO3U9fqDslsFhPwQ3CQbCmvl+v/z2rVsgyfWt/vDqT8AVaQzN8aW
 D5SVQBU5
 5GF+t7gbNH1nk0knNWIOcb1e0rUQMiqxCCk9q/+QEjGWawmpanv3f2RwTi3Oo6rcOe0Oz5TL86Qz1GEShhem/bTaA/dJ9uvA6drJoYmDAS84IYrlV1hEggy+EAcayo0aGs8+LWFRf7/tKQf5IteC5A8cCP+nDlLYVM5SnqRAA3IKbViERZbv1ZPnjfweJdVC6/Xi830Z2k8YYmDdGmKvxvC20ymw9AHl7k0f1QmJ7fBp+2XXJqk4p21RojPJp97hrkdxWZpona2vX2gR49urqJrc108M7GISUELCf1xDQf3EeVIZruvyQ9SwolgAvrPBgdYDCDM6MD9bYSBbFwRt57nNdqmeK8k8Sue0A9wRbBQoGHcn4RaCp5dgvdNRjxxQcmstVsr8upbN7cvF9I+gmakZ01mtyTuRW2wEEKrmcTjs1PQVNLV5expq5ETMjqCLBMcnpbe8JhSf5gBi3JPO3AxcfTdI3wGmLGswtHUCZgzfW8vf+KM4xqgWbS9AAvj0adeNEOWwzE4uZ2b6qNuo/9AfcgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 at 22:00, Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Oct 21, 2025 at 06:25:30PM -1000, Linus Torvalds wrote:
> >
> > The sequence number check should take care of anything like that. Do
> > you have any reason to believe it doesn't?
>
> Invalidation doing partial folio zeroing isn't covered by the page
> cache delete sequence number.

Correct - but neither is it covered by anything else in the *regular* read path.

So the sequence number protects against the same case that the
reference count protects against: hole punching removing the whole
page.

Partial page hole-punching will fundamentally show half-way things.

> > Yes, you can get the "before or after or between" behavior, but you
> > can get that with perfectly regular reads that take the refcount on
> > the page.
>
> Yes, and it is the "in between" behaviour that is the problem here.
>
> Hole punching (and all the other fallocate() operations) are
> supposed to be atomic w.r.t. user IO. i.e. you should see either the
> non-punched data or the punched data, never a mix of the two. A mix
> of the two is a transient data corruption event....

That "supposed" comes from documentation that has never been true and
as such is just a bedtime story.

And no, iI'd argue that it's not even documenting desirable behavior,
because that bedtime story has never been true because it's
prohibitively expensive.

In some cases the documentation may have been historically "more true"
than it is today just because the documentation was written so long
ago that people used a single lock for everything (not talking about
the Linux big kernel lock, but about old BSD model of "single inode
lock for all IO").

End result: you say it would be desirable, and that might be true in a
high-level way when you ignore other issues.

POSIX is full of these bedtime stories that depend on a simplified
version of the truth, where the simplifications means that the
documentation just approximates reality at a high level.

I think it would be much better to fix the documentation, but that's
generally out of our hands.

            Linus

