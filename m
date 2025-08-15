Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF9FCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 19:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA5F6B0104; Fri, 15 Aug 2025 15:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C10F8E020B; Fri, 15 Aug 2025 15:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6646B010A; Fri, 15 Aug 2025 15:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39B8B6B0104
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:49:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDBD31A027F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:49:58 +0000 (UTC)
X-FDA: 83780032476.02.43C9375
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id E63F91A0006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:49:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="WEEe/z8S";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755287397; a=rsa-sha256;
	cv=none;
	b=QjhsCMBsJEEOGg940hh+Ht76205lYSNEKeWHHvFKPPxboZ9odprYW4zo3f3Xilfk6kN8K9
	PTRY4+YoxzEJ/YnTK5ZwhHQ+sca6rciWbM2VTYkxV6jyoR+vwv15ds/1/iZrxgG85Sar/G
	jF5DZElmwd9iudUzMwrmJbB29/GDse4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="WEEe/z8S";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755287397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UInFe0pIryJwKpyf9V2qNNpiLrOP8TGk1w7yYzwDAIg=;
	b=ufl+AGtg3I8nCzAkRVCFpdfJ13ZS8uTd14fJE/X/l9vmJwzh2us0YiN+m4f3hpGB88XUny
	MwJ9rLzs4rGulJnGW3ncCGK1ozzQM2BhPoyatOzPOITlDyqmznYfflm0CgRK+SK/d+aRrT
	Cz4ipiJMhdfOZb18LpZtws69+DQ1uM4=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-617ff2c8e5dso2743a12.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755287395; x=1755892195; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UInFe0pIryJwKpyf9V2qNNpiLrOP8TGk1w7yYzwDAIg=;
        b=WEEe/z8SpL2JsDLN+ZmLRSLjs+eZpIZihi5Hr0XVfsauIMzxC53l583YfkeyXgNrdk
         Wi0CKpD8xO2IcmlZ9Qyn277DUYgQ1J/HAlysG1kWheNBuLwO0aI+Q5kZCRKlA4mi4jx7
         meHYKhgQhwHheanNYCElNBalXanYmLaPs3K8mO9hg39+ykSnbZsxWP+GfqE6Ji9ZPsYp
         ddeqboOVAwZi54GCNAj2/sspy7xOZbMLPWfNceEonZkzlmWZujZ3nwJ5vIQJH3YlJtBR
         YsQr/NHMK6yKrEo8t7zLPfpGB2BdRzv9cJgdyZs2uCr+JKH7fFE9Nyx5pWJoe1kOIbcm
         w3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755287395; x=1755892195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UInFe0pIryJwKpyf9V2qNNpiLrOP8TGk1w7yYzwDAIg=;
        b=KpZMfEBONkIDqIGGZOgoSBA52lOY5R67TgBTBfOmGAUYcxi4uN7o++fWuMZofAuvuG
         W/o4mFxD1L8GKh2QLd/DEPKDT62Pi3fsZ7AUExhoqbtcr8ul8GbS2NKhstLoMpC+SPBg
         fVThmbhpzq0IWvpkWhZwEkU/o9XsrVk3TaFyJLshSgg+00doqJyDfqy3Zjsx4o2YitzR
         dl5QulcT2dfpBaNcbfg+nhFhewx4/5aKMjjIth+I5JDvsdz+VpLGWTyoHtCPvLNVKCxb
         A/4ktzGbKcTNVARCVcdSLB9NAAHSI/9tS5V2R965ilJwxTbAmdm4mKYkWRenTkTMwiXf
         GGYg==
X-Forwarded-Encrypted: i=1; AJvYcCXjrtj9wbsgt01QU8j5gwFm2hnaFDV79cWo2O8+vUL6TAAAqTwVAubM5imbDxuDK50DSzJpBaHsGw==@kvack.org
X-Gm-Message-State: AOJu0YzCaCuk/3gA2OWyY7cxpIQ6wc1FmGtYMlciy0MQW/+Qru1dOKEV
	6Ft0yuaBpaUY1lZ2t0b+9/kylbETeucElILfT3GGWuBUdec+K7w8M+/0P/8t0XEfp9den1UwCa5
	6OzcOwWy4qGKEFwGi94bFrGYhzRhzUWBCRFXFTruw
X-Gm-Gg: ASbGnctmO4q2yd75Ki+rcEc2FcgJc2KBC2yvgV4ZZQUlIuxKIt3MsLUTW0dQFMm7oSq
	XdDzbEhnfFHCH21uyQmByySOUO0L/SpHC4h6zUFSjT1+mJG5kULJEOfck/jt7yLpY3xcQKNT3dJ
	zd5LXqLpF+cZft7J8iJrIeMkmwgdIU2ds3Qouzu0ilSI2YjBtKpVKwWIQoZw+vQtq+X91ndA+Gi
	lSTYhHxTh3ihAo5zIJaB/zJ0+OyFi8v6/sjJmZE+ZYaPJFJ7gk=
X-Google-Smtp-Source: AGHT+IHxNrlmqZyfYciekU5+d6eaqXM/ov0XqdYnqaC7l+XCzctcBfE4hDpP9zRtYdE4JO88lGZIuEq3KOi95OCNsHA=
X-Received: by 2002:a05:6402:46d4:b0:618:4ac1:e6a3 with SMTP id
 4fb4d7f45d1cf-619908d90c5mr16582a12.4.1755287395136; Fri, 15 Aug 2025
 12:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
In-Reply-To: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 15 Aug 2025 21:49:19 +0200
X-Gm-Features: Ac12FXyQ0zkghdneNsoye3kR5up2ZVBa3nbGq4Ss6rrLOyrAGrNk9qowXO2sZ80
Message-ID: <CAG48ez2FCsKNNaKa5Y0xBJTdtzptoCxM_+XNNg=bUMgoLDyC3Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Remove XA_ZERO from error recovery of
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Pedro Falcato <pfalcato@suse.de>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, kasong@tencent.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E63F91A0006
X-Stat-Signature: nr7x4uxho5m4p4yp5ggu69xyh18bsk9j
X-HE-Tag: 1755287396-507130
X-HE-Meta: U2FsdGVkX18ONBDKgfyHnKJvjQIvW1uUIah8tz80zYoTNz2n45Ze720DAt7OUEZdJ1bqvrYonLiv2pIyM+081Ng6ro6H/9DacIKKYkv+Jt2MQML9LG1N3KtGOGEwqRnmFlCNei4jwzYCwOYkbqVRA75Y8jocwj9DFDsXuLpt5/Gqwu3DbktUVp4VsObsa0W0VIKeME0myffCdOVN8AJj16Rzm7KPW+01Bm47DjReLpo4PAnBxS4Dk62kmO1bN6OLM+UHpjqnSUhanS1HmhT01qRcb+Cbp1ZefmgUbmEKfwCtMx77CTsgS4R3wi6+pk+YldNrhKAFKGzjgnlXsUks/3jplQu4mtAkBWl4+zLlGuX1IaR58oJv3s88l/bzTIx8UdbJfPsWMGDIYKWL7RP5OUoDp/87eq16jHJEOOoNyxcREzdR8ifYvkCWRcNCNqHL+Qy7U8LR8q/mv16zmNJBUQ2YiGQ68sN9M0xT6a6IZv+eaP1Szot0qn+gcvIXZNaFTPnHMdznYvG4+j2lpEa2fdnH1orlWj1HAL1I39jQUdm/z2++ufhZLaBQNFtXDiH5AKae3ERBjY84wpUIayS4Ysaoko1Mz2vKUgva52sU0PpAk/zDgXtd8u2I0ETKekacvHpta/Dx/283FIGQYaOeXsdYpMUhVH/DyvtrHsDq2tpmOd9//iobZ5nIxn7DT4pS7kvNW4HBO8/7/3Wdm5UX5V0BjGMfGhDE7bbWrZVJyV7bLiQ48FLj5qxJBUU8Hr6TBOJdZPmsDVWD9Bk3JxLQHmLr72tqcDMNzYT7fEQ4T4H8GmldmJFtH3It8PP6EcSpZoB6Yvl/roy3iophunGclWV+U7c7gIN1Sw2PtVFDgiXZXnelzHqTLf0mE2N3yyK1lRgV5nJqXjCfxBu9/koNXgMwlRSRUvVaDRZm0ROchIpLT33AAACcGyHpAfdYfz2iQv5+5kbBW983W6HMMqi
 GHv7Fnxn
 zJ3DIAVxpA1V/leJUII0yDWz8QXEhADQmemltBPhdo0HKH2eDLc2610MyGqjE/T2weC3M+DUWwxu10yKtkCvU8XA9foVWT8nccSftWXBvocBw+ub4xmfXQJbFK7IIsMV3ReJlfcwin5sthpj4blj5RFRnKvhBz1jFkmfWfae2bvOwQHdYlfMSBT83kkkrWYhgZMy0LVpALLoM9kp4+hnzh+Sg+rv95dKzY5lDyuzEz1nImIWn1ky2wGy2mA9NjjvwapgRDnEFnsXO7VQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 9:10=E2=80=AFPM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
> Before you read on, please take a moment to acknowledge that David
> Hildenbrand asked for this, so I'm blaming mostly him :)
>
> It is possible that the dup_mmap() call fails on allocating or setting
> up a vma after the maple tree of the oldmm is copied.  Today, that
> failure point is marked by inserting an XA_ZERO entry over the failure
> point so that the exact location does not need to be communicated
> through to exit_mmap().

Overall: Yes please, I'm in favor of getting rid of that XA_ZERO special ca=
se.

> However, a race exists in the tear down process because the dup_mmap()
> drops the mmap lock before exit_mmap() can remove the partially set up
> vma tree.  This means that other tasks may get to the mm tree and find
> the invalid vma pointer (since it's an XA_ZERO entry), even though the
> mm is marked as MMF_OOM_SKIP and MMF_UNSTABLE.
>
> To remove the race fully, the tree must be cleaned up before dropping
> the lock.  This is accomplished by extracting the vma cleanup in
> exit_mmap() and changing the required functions to pass through the vma
> search limit.

It really seems to me like, instead of tearing down the whole tree on
this failure path, we should be able to remove those entries in the
cloned vma tree that haven't been copied yet and then proceed as
normal. I understand that this is complicated because of maple tree
weirdness; but can't we somehow fix the wr_rebalance case to not
allocate more memory when reducing the number of tree nodes?
Surely there's some way to do that. A really stupid suggestion: As
long as wr_rebalance is guaranteed to not increase the number of
nodes, we could make do with a global-mutex-protected system-global
preallocation of significantly less than 64 maple tree nodes, right?
We could even use that in RCU mode, as long as we are willing to take
a synchronize_rcu() penalty on this "we really want to wipe some tree
elements" slowpath.

It feels like we're adding more and more weird contortions caused by
the kinda bizarre "you can't reliably remove tree elements" property
of maple trees, and I really feel like that complexity should be
pushed down into the maple tree implementation instead.

