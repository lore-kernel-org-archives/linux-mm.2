Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3435C87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 14:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FC926B007B; Mon, 28 Jul 2025 10:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD0F6B008C; Mon, 28 Jul 2025 10:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BA06B0098; Mon, 28 Jul 2025 10:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 59E2B6B007B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:12:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D38E01A02BA
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:12:48 +0000 (UTC)
X-FDA: 83713864416.09.A21A653
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id DEE2420011
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:12:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3E8eFVwH;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753711967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eyO1Zh3JLq89LG2uKG9/+47hoHtzpYlBtMnkZyT0qW4=;
	b=jjfovNipwqHhnybV6dmqMci9JgL+BH8UmSKUxrp4xD8MO1OiK6Tw/v69lX5RfBVm25bBnA
	BkbsCd8r+7rQSoYHa9JiGBh4C6bsbr80fQ/KmQF9mf1DdgdB99sgMlZVzKdhz3xhJbwCXu
	piUlmpDED1OGJFOEF7rasDVwdV378Fg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753711967; a=rsa-sha256;
	cv=none;
	b=Jr4wO7ma94c468FUJSP6v4PJYkueqToEU0VdJ76Tip0qzUz1+Sv49WuVyVwaBgK+6ZCZCm
	0gUmBK+FEgS8QgPyE1Z/KthdWobT6L3tp9hgbPfWwGV6jbliV+ODQY2aa3+chOtEioAKy0
	bz1M8SLPrKYsk/12ViZWbeCRPQIbQEg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3E8eFVwH;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61543b05b7cso7441a12.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753711965; x=1754316765; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eyO1Zh3JLq89LG2uKG9/+47hoHtzpYlBtMnkZyT0qW4=;
        b=3E8eFVwHjhSg67bnl08UpeCxqEJiCSxYCx0uDWS+R1ehCE+MwEfxNMKcAtw6iQgEFj
         YEItF1KBxGHGjlsFE5YQ8FHhO/i/LczwE+4+NE6NCV88OvAmL+yDHrYqVye+J9c/gj9K
         uy1msSMNVnsTPPCra8pbHSbMBoJTmLgxr7m37DT2U9eVOHzNwflffiGSMFRM+Mxz1qIZ
         swR49i+nASBjwRhGMdauBlHEeuYOVMP6ktl9bwKBSqD1H+JrgYpnMjSSCxOX+1r8A6yt
         hmbrV8oy1Dd7lTnt1WUp3NqpVLHwPZEBGR7GdiPt0k4O/efpYUmxUZr0Cobu6iidQdXC
         p79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753711965; x=1754316765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eyO1Zh3JLq89LG2uKG9/+47hoHtzpYlBtMnkZyT0qW4=;
        b=GIVhe6uTygj6xC9u/7T9q9ApapI3NxiRzAwqOnhJYDOLJM1xWNyAJtFgSUPldngITG
         9pwcj6PyUkzNq7UYJxnKSi71hy/m6PHG9a7TDW07nTNkz2YsyArWhiL4A0F9R8rYeBgC
         TUuYvUgZNOaafDjvbPfjOwLOI28509S6wkvBXtriPlhd7p3Gm1slWleoG9I5coiGTlvN
         VUJOdhD7hG09Vt8XY9Gf1LVDSyaZ67rdEkS5/Nc0WSyhLUb5RxqUcxLhGLMTjQJ1/wt7
         uRYPnU4utUW5EXpc7dwLO3raVd9rsGGKqCQkX0G+qMiENOPR+gEuAr+pxZJ/FljNclrG
         +57g==
X-Forwarded-Encrypted: i=1; AJvYcCUF9ZDw4mi3JpflpXFZWJlo5bFWpL2Q0MVZgxXfvfWdJOpzYimgr6WEqYVmx7SqVeBcQ92W2NVxqA==@kvack.org
X-Gm-Message-State: AOJu0YxTkEuHWKIkOU5vScAWaQV+iTOHS8BVCFxj5FDXLwYm9kgItC1y
	Hjga4Lo5aAnikEMlXDvp3iESUjkmyO7jQ9mvH7fJgZ83+NMavB/3dsWvt811Y5OHE3pMACbkT5L
	MbQEUvR5tbXH2TlWhBpnMpZkS4fniGwUrD+oDxC+j
X-Gm-Gg: ASbGnctK0UDiX2qtrzujnnJS1NQlYzlVXdJ4Lf2nw+veREzCT0B1WcUcnn5Nudqvmzu
	yHF5TwixPfs1cl/WoqjZjJGzDPeMxwF+Y2LZjDXQAKajjMymbpR1/egy9CM9jkD5KGUa8DH+fs1
	xlcDu9crej/EWtjiW+gtjXkm75GmDOXUSVtrkdhKsGRpn0poR5voYO1A9r54h7fYkYdJm5swsMq
	xO1mC5lxyC2u4jZ5Pdcr5IIFOdOEoc7Cg==
X-Google-Smtp-Source: AGHT+IGqSyVPEeBd1/C92xR8Yk5cwA35fb1bP695SMItcVpEcxcrhb8x+oSwZU4glMUFyz5GmbVv9lfOnFDdUmso97U=
X-Received: by 2002:aa7:d793:0:b0:615:28c0:fac8 with SMTP id
 4fb4d7f45d1cf-61528c0fd99mr103964a12.4.1753711965037; Mon, 28 Jul 2025
 07:12:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250725-anonvma-uaf-debug-v2-1-bc3c7e5ba5b1@google.com> <aIb3In3G7XygrXNT@harry>
In-Reply-To: <aIb3In3G7XygrXNT@harry>
From: Jann Horn <jannh@google.com>
Date: Mon, 28 Jul 2025 16:12:08 +0200
X-Gm-Features: Ac12FXyCLEXjkKoQicke_OUqRIIitb9JxcenfQlHNDrm0vc-8LFcwy48OZbcVYg
Message-ID: <CAG48ez0sfeF73sBK0V2TiYMc=grhM5fA-673xXNeCqQMYo2dug@mail.gmail.com>
Subject: Re: [PATCH v2] mm/rmap: Add anon_vma lifetime debug check
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DEE2420011
X-Stat-Signature: 3y57deaj8r7ez9itzcm33om1kc3shxmn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753711966-264493
X-HE-Meta: U2FsdGVkX1+sez7KRk2lrt6CvilGgDV/8Y8AzaahA/w/EbY+A0gbUaQxiH/Egl/V1S+V+xAw4BHa9056JNFFy2aVL6zBoHxdTdkYm3GhJxPxEv25ePd5DtiEp8xirLYAry9ng5c3KJZ69u67lFt5g1C41Qqj3N1e0Df+E9uIea5A8fq4xy/LYI+sPN7Fl5rHdZKPFhlkz7aEuyXg1UUMMwdGHqgn6H2rTteP//1IExxg9+5bqoGSRnxixQoevSfIUxAj7CPr/2ejuXl2zaQjsy8/vHb+p8JdNhKNC0FJmboKWi69NfeiZetNFjxnrrdxuVRPT2hByxm9u9B8UHjPUJSRvH7/D5SB7N7AOv6HbtvWwEZRZnzW0wp1fElvo9/2fbnDTzopzhYTujiIktnI05M7DaHtloEwvfQdmAJED3QlOthTYDZ43xAJmcs+W7MPdLyam065XE1swGBLEGOnGcWgTZWWSQ8hCG7FpDVnlqg63VO1nNczj5zL6aTcjiiTGy9LDlqbY5XgpOgjTcnT06PlBl6pqEIwMGds2kIO5ic+vJYUFWo7kuvM3XbpHbxuFiZJyXVf4CXL8QMptehVK46hvYz22rPURQi+N1mmOHF7WjcOxYnp0tPadyIMthxnVuYpbGMq/0GAkHh1Gv4x8AcZQa1blvJJFC9FtZedShOJgbyX3EeyHpT3tyvagU6xNU0kyIhqKo3iwq1AQQ9KLuMYFg0s/BXVNxbQGZeSSuAVQBi4b8rDz/XzcLGIl2Q+iJSuMmKxthmUOQtMrRG6G0rIzGWimQw2f4iWxTlhQvNAwzlGb5pElR/0JF7D6I5ckPNkfZd1dc0XVoqWDC1o6azteTAhGYST8IK5Ees0zp+uXMo2fEkA2+Q/sJaRm5vwFyrylogXz1Tz39Xw5Awim4DD7vWwWeoiR1QeDSc3IXW88ghWBXAKbB2nnC4cy7VrOW16Yz5+kDXBltJTgoe
 XtJKXSZZ
 HcvYTLJGJHs6WnQyD7w2tyz1iTqcERc2MEcOB3sQP0mQy6OW2juTRY4vJL/laKcmQNOCoSOOqTnkBtyZkB++X9y3tV3+VC6hwmVnF+xsI9z/kDyoR1hiFEsspqSlpdLmYlz3MjTQbNIOZLuY8GLhfh90gnPFg7wPzcWivZXM6xcnWaZlVNQzuobyQs/7ZOgDN6wSmnoBecvtOnSEQSYX14rJFKPdgm2UM5+YA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 6:06=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
> On Fri, Jul 25, 2025 at 02:16:24PM +0200, Jann Horn wrote:
> > If an anon folio is mapped into userspace, its anon_vma must be alive,
> > otherwise rmap walks can hit UAF.
> >
> > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> > walks that seems to indicate that there can be pages with elevated mapc=
ount
> > whose anon_vma has already been freed, but I think we never figured out
> > what the cause is; and syzkaller only hit these UAFs when memory pressu=
re
> > randomly caused reclaim to rmap-walk the affected pages, so it of cours=
e
> > didn't manage to create a reproducer.
> >
> > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folio=
s to
> > hopefully catch such issues more reliably.
[...]
> Oops, I'm late to the party.
>
> A question; does it make sense to disable reuse of anon_vmas during
> anon_vma_clone() to increase chances of detecting this? (of course,
> for debugging-purpose only)

As Lorenzo said, I think making such a change would risk making it
impossible to hit some bugs in debug builds even though they can
happen in normal builds, which would be bad.

> Regardless of that:
> Acked-by: Harry Yoo <harry.yoo@oracle.com>

Thanks!

