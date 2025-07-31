Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB777C87FCB
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 02:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4699A6B007B; Wed, 30 Jul 2025 22:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A606B0088; Wed, 30 Jul 2025 22:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330A86B008A; Wed, 30 Jul 2025 22:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23E576B007B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:07:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA605BA581
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:07:52 +0000 (UTC)
X-FDA: 83722923984.08.5B19B14
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0B346C0005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:07:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="k/Z9/3Cb";
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753927671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNrPNeA3sPng1pEzthXqof5sqaTQASf+zQPWSy+n+b8=;
	b=RYM8HNm+hl8WqbgO4+oEjj1YqBsp5vQaV09lmRD2+yUg/jXIMgj+cMqL8NRwp4MmdndG9Y
	d4gqrbX5fmeDWtI4DV5zP1W4325WAwG3Lef/zTHXkqpduocHFClzAVNbn9C90BCcXrz/DB
	GZdXcURoEuxiKlIl7XN/y0LjQy7QkOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753927671; a=rsa-sha256;
	cv=none;
	b=SoZRCnrENVoky/u4S/lR1PuPto7EIXmVfT6JU0oFa+uCov7zS+nQe/VqYTWBSA5HNl4N0B
	Kvj83OWXwSHkRHeHLqnaA3D84Aq44Ql9OSvXPnVG7mjS4p0fwrfV+W89LRfhBLWdZ+Fhlj
	2Wiaw2qtG0WSUUi/PTMxxKyaQKCJqvU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="k/Z9/3Cb";
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-70744318bb3so4224796d6.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753927670; x=1754532470; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNrPNeA3sPng1pEzthXqof5sqaTQASf+zQPWSy+n+b8=;
        b=k/Z9/3Cb+SBGnJm6GQYRHGTaEPJafVQnHlkiaLYhr6hQS9lebAsXDjbC0BoJS7j1aq
         7nPA/dvRQ9Pwfhd9Qh2/bfe4owcNn1EZ9fi1DN04HMLYGB194lJC0Ihd/zGjvxrX/t6Y
         eJpxUMGUqaQfwFIyAUQikNINA0Hn1Kp97iRPsBF0hbW5zPY+jMeH4F5RHvcwlEsVo3Qb
         hx+6NhFwF8TeM8RxmyaUvrsmWrkbZIBtITxc6DS4DooQXCDXLugoQd7JO8nZm/zBCyRM
         nK9Vlrcf9SlxDZhuGJ7+U1yxmrJGVe7AOyqc7nYKekbiBS0j4lmJo9XPa9Jqlg2L1wzf
         Uwag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753927670; x=1754532470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GNrPNeA3sPng1pEzthXqof5sqaTQASf+zQPWSy+n+b8=;
        b=N/RbLaYPHTZ/bHEAzVjWHkLnNqhwEJNzYpZAPGuDOitebAw804JCrm38hq3Se0XuiZ
         EnsrLyosGmsBU+FxnCe0hVmbSOQAXWZkYIHvKnXq35b4yjyQdoYARgbpgJX4OrLFkHCC
         DgDXi5ezMISWHj+BOF1VTxiwqyiKhFZqE9yI1MFLu+N1uexrjCK6T7ZFq9qvUTC9zHd3
         iWaHl4dE4sjxNCySID+DbQr0JwIUXMIc60Md2e01R3Rqvym5PF4Q8xzzjP9yOwlygCnU
         JC3OYBX2FDX3AMubAjkxjhZeO1y4RTeUUlzkSUE5urgH1Vn6IImm9mWpGhNjlMyOh1NF
         ZUnA==
X-Forwarded-Encrypted: i=1; AJvYcCXH7v6N28giR5FnF35Y6PuGM+spP2/ldys9u7AS3RaK7dXagyw/63IRwQ+dV+sW8qkVBQSReLkUCQ==@kvack.org
X-Gm-Message-State: AOJu0YyOwWlAoW5/idl9tK1ut5TDwb8jYU2NAnN5ppUVhBEMvPVw877I
	ZbkMeCsVoPj0o8+74lcjjMjtZt3xm1jQMxf3DBrSxes3GSOiSrgfyTC0W/09PVlrnvLQPwdmP47
	5unJfuEtv5dcQ9ktiLInL9IhfdXy2ue8=
X-Gm-Gg: ASbGncstJB3NWpNeFf2MghDUW+P6f7SQ9KjPG5zMwPZX8JMd7DMzVmLNbMt74+eON9Z
	Ogb27QcCXkuiBPF1+hx7C+i9RW8eRhs3uPy2+0ldX6e7JNshKdVjMRyJQ3TMFD82of8E/84MEOt
	nIB7dj4N/voVqb/5eMb41PMSSDN9VivBbxUrm+FY/AOpW6CYDjknOIEmffKxgca/5Ik8Fwylipb
	SJZeg/mH4yBGO8zjb4=
X-Google-Smtp-Source: AGHT+IFl4zilJ+iq7LWpCHNLJ08uCPsTB0QyYd7euDvV41rgJzWYvXwal5T8QCY+T4E0b1bI9FEYFuWQnW9GmYI4VlM=
X-Received: by 2002:a05:6214:dae:b0:707:4023:6b8f with SMTP id
 6a1803df08f44-707670af0edmr91719236d6.28.1753927670016; Wed, 30 Jul 2025
 19:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250729091807.84310-1-laoar.shao@gmail.com> <08D7155B-84F0-4575-B192-96901CFE690A@nvidia.com>
 <CALOAHbDRBs8bdXB_LJjx-7gALOCLvmMxFD+c7MbHAiQ3htXawA@mail.gmail.com> <65e9ee9a-3b64-4efc-ade0-83990de7af91@redhat.com>
In-Reply-To: <65e9ee9a-3b64-4efc-ade0-83990de7af91@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 31 Jul 2025 10:07:13 +0800
X-Gm-Features: Ac12FXzKKcoL0KYZ3HOR5kQdoagfYyPfz1C1dwQkzN4KdSj9vlKo7adHNYovK5I
Message-ID: <CALOAHbCuFixOuTP=dUiHF2ki8PiBgU_W_JtL7qZUL7C3o1SH3g@mail.gmail.com>
Subject: Re: [RFC PATCH v4 0/4] mm, bpf: BPF based THP order selection
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0B346C0005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ska3nkf1nipwm7i4jateg41yj5stobw1
X-HE-Tag: 1753927670-198986
X-HE-Meta: U2FsdGVkX18bLrVlkHSKeniD3SF7ryadI5kUMQZsB+HkdZBtEgLgUdHLz7/IhFuP1/e2fi7jk0KEmbZlr3nHAnWXLPfAOa7RdGZFxwlBS4UH3IL46WzNBEOUDUwP3GVNTofrUBP4ex2TVLFKfWQrBSvKT/YGpIwRjS77Re2twV9YtOFNXIeyNi/M+xPKydOabKmZGgyFXWnNOqq4SVveO7qsc05eHK88JV7HKZ7YPTG+McK29jyn03lRgAyuLMyT1Vq4GKgeVZtKHopvYSi5daKPcEfpbZ2NYjeaLewBD4UXVuj9DI5JkDXXfZ1D11lj6NrFyEUJMe+VWNS17TpOnjLZTqDyMoQht8ON/kGtZJkQpJxxfVW1+V05hOjEe9LzZ8TgzUtFYhgTQ/AYpkUugJr/HS8ls+zKk6yVw8LTOjHWs4Nk9Op1kVXBvQSR5016IQewIWs1ss1n8SIsciLbmlP4DhI0q5hRFYytwyGSnBwvAnYHkZywOxG8bgVJM6w1BUcHGpkygX0iORGBs93GROUjpFVgBF51pFN9UI9S9YDmyLRzbYxA2hDE/VhfirRI8p9L/v3L5iy2Gb9oYQ7zWipalRXx1HXMjgn0e1ymnUP0YtTh3kUw05ymN1sL0tQUYrsZbz60cwjny2Uf62pGtupgeMcaYfGRuunoA7/xPEGz8OV6e5vBybAIHGRm/2dPOsBW0Gsw98mSYOxgNcn7Sq3NFdCLoB5cRNoc9OjF9EDT5SZvkYbT+qkyVQQVJFa4gR6FPOhMnM83VHQRRqFwsBSwcc8RkO1dYUxJk9r015RPgpm9UkWDyfstXLTlqc8HK9Ql4KN6GLhzWhGCjfcHwyFjt9qj+ZdOioDNXxX63P72SEcvOSTOJXe/28yKWngyKjSa0xugHCTd51nAKN9SnM85qBiuAuWjxOJKdHSnid3ZJrttZ0hliWp33aPJsvu8g/XSPXe2Ai8MubRw9iM
 afbGr14L
 rq4GahwmdfDznEdf+k6b1mMUeEBKf2brQh9dNM+SVz6TYgBaIYMKVbQkkU5Wkwq+0Gq7ICoQQv+rHWexkSaQsV/bzrdwgDewCRrpa/BbUrPeN7regZIDPKmosiLKu9pqm7lv32ZTUBtcctuRtp5XN4pTs+ekFLiG+8X7coBfnqY31q5OAvELw4n2s8ALCSE8buUMsKnwBEejLnXEQo/t4GoWGqXWAxqzlvHHGTEQ03nziptm4I97ASV0HBGG3gKg3xylULhA+Yv9WMcKKefvSrWiBW9fN/31tFNtwh4C0KxPzAaUsQovnX9z5Fe6iYbqg8m6fDDwCCoogOZf4CSjn/ADaLGf5dHaspH3Q0OejsRF6aaSsjEmTmkzPnzo/uVJlIPKBSzY0/SY3TdfhIvpYsZFzl8ZojgqoAllD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 5:58=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
>
> >
> > Yes, mm is sufficient for our use cases.
> > We've already deployed a variant of this patchset in our production
> > environment, and it has been performing well under our workloads.
> >
> >> Are you planning to extend the
> >> BFP interface to VMA in the future? Just curious.
> >
> > Our use cases don=E2=80=99t currently require the VMA.
> > We can add it later if a clear need arises.
>
> We should start immediately with a VMA-based approach as discussed
> previously.

Got it, I=E2=80=99ll update that.

--=20
Regards
Yafang

