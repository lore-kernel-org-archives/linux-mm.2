Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0908CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 19:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D58E6B0005; Tue, 12 May 2026 15:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086546B008A; Tue, 12 May 2026 15:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7226B0092; Tue, 12 May 2026 15:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA2816B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:58:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B7B31C13ED
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:58:37 +0000 (UTC)
X-FDA: 84759830274.21.106DD2D
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7BE47180008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:58:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XE1oYz7g;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778615915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m6NJ/GUzSXfukEznvlNg7F/rj3o2Ed2/fJnLfv3lGI=;
	b=KROj9AUeOvFwWFmkyUkuQqGrRw4W7r7G7LbzrRecfYnqVvJlB7LVRzQpZa3x59vYuOxvox
	+BQ26ntSW1ly04aQ4hOhfcGh2fBPKwAUHZHwVXqN1rDTZXm3zikEmgR8pNZ9+9iH9WuO0Y
	rWJBIltI7V+8+Xc34Uz8koswQ69XUIw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XE1oYz7g;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778615915; a=rsa-sha256;
	cv=pass;
	b=po4D4KsIew5CRqlOUBa5VZ3N1T0eSCZoVVqqzF2bZyVL3INrqo/UI8TXEX7mf1HgC70GdM
	IJfwTmmWRvbPktBphkr2Weaxq9avnzzF2xMSj+WIDX1118nFD4j+U2DBOy0Ymh7S3eFXVk
	2Wimagg5xxlpysbpkXZ1IVrYVhHz/MU=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso305a12.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 12:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778615914; cv=none;
        d=google.com; s=arc-20240605;
        b=BfreuecFGsYTl837BAoXjROxys4dHyP3Ff8SH0ppkdtm+NK443YOQA0NLGcTMqvA+U
         gAzY51l9VSoRC233KSYg34jvOcPZRZJAoEoy5i2YHVj8kzGAEjTiw31rTUvLKak9BUP3
         oa0debg2Y64vNVi4FMiCDfiIE+In41MWabhEABqerrmVIxXIAJGa1vAEdo91MGZ2ZZA6
         TW1RQPKBgi0FXbixA44haktvCFUeXyyNgOQ93y7l4S+XnICCtovh360OVj0OkmzQ0TJQ
         CulvBaLuwVcyDVNbhfxJsv6HbbzT5J1AL95PvT/+WIwHnWWNSBpOQxldx21sjPiNeGGY
         FqZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5m6NJ/GUzSXfukEznvlNg7F/rj3o2Ed2/fJnLfv3lGI=;
        fh=jqFfk94LFvcLe1VBV/xzCDFMuYnMCwpsIvmVZtNO80A=;
        b=hjZ5Au4sPpJUQCrfSh1c8s3gaUBjZkOzS8CZmgSBGRb3NZSfg/rwWPids0ufgF/PBu
         78WNDhmnVWRPPNx/1lP1n7lbEuB27vwWyNfJrQ/XglE4gfH6DjUZerh0TDYYulxDaJNj
         1kmYkbgEqX2jzkrw6hDQs0eX+ghWHx+85l4hccB23DZRjmjhtS/h7NKempHxGI/mzToB
         S7RguQekt8DWgyEJP1RKQ/ai6fMMz/jQfU8JKEISojcTJRrnOKIdR2cOagbX8vJVVxT1
         5N0zbjGqXXL/fCOw0u6K/0VeyxhCaOSXZOSbwLz22B9dyE3g5a41Xc9HN8BrUBh+L4wJ
         jxYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778615914; x=1779220714; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5m6NJ/GUzSXfukEznvlNg7F/rj3o2Ed2/fJnLfv3lGI=;
        b=XE1oYz7gN5udL6XS36grd7wmYEGZcOJ8F4L2FSryiU3a10m/EO4/uhCqmxx/9GkMRf
         pFnD78v4MiquTXwk+h3T/kU593sRQfGylfMdOKl50Si8F/FbKJ/zqkbm5Hb5Yg7TUwpc
         6Co66/7gzF2dcYNFcMOjAN+98y88zRDxL7KEjuOH6fihmOqY5prmRhk55kl9lN+XFM6Q
         TfhaZvfI1Ie15+E9BcgUDLqY50Ug4HpdZjPS59SHg5qQeONwExz/R6UbnE/9vdetk0z4
         0yXprhIYuv6U6Tn65KBP2Ym8ORKR1qY2wmN/FIikSMBSeoRFiCZMoGdTRDfMiuj/DigD
         kPow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778615914; x=1779220714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5m6NJ/GUzSXfukEznvlNg7F/rj3o2Ed2/fJnLfv3lGI=;
        b=iu9V1O503kKpQYqp/M6pMefPinnC5E4DxEiiZBF627r3VaNL2Jdn8nRMEgh9tUekes
         ethVL/Wa3UwtXCEsnlbg7Y17zzFtW3c/lT91O1T8lCGMRmPGDjwc7RzTJlbkrKYztVuH
         Vbdzj5MGw9/QqqP6sHz46BP9OPVpcTs6Y2IME+PYHPUFLQpU6ZnjOUo4dbNr6/Z1w7Ot
         LQ3pZAV5LhRVZYPAz9Adt+k3UionUZj6a2GpyQV6LS97B8IY8DYSE+VIbuKv6zAF2znO
         PVa5W/brhsk803QH+iJwYacMkfGLumMV7GPvGQ3T2PkpBuzSYk0Lpi8hx7eLIwJaKXlu
         3qgA==
X-Forwarded-Encrypted: i=1; AFNElJ8/tGoWQa7mMIq9Nkx5tqqDZlgvTAvQmwuSX+PwQAA56/8h8obC0T4hUd5BZhHfJQKpDbhJmtE+gw==@kvack.org
X-Gm-Message-State: AOJu0Yxt/Yhiq0QedUKkqAJKRIqa8VZKIrirgC2mTQArMUe7rJ7gLlc4
	5TIUGNwEHlMMqeG/D6COO7g8VGQZil6Dfs39DHfIYn0BG7yNiXTP/emwqLjPBNgmyxAEcOn31Bv
	dMVL92Zno+LrtWc5fSmskQsB0wwBt1I3/cGHgadKD
X-Gm-Gg: Acq92OG5muFdqd7qakA9j+Dy+VnWBl+wJ0sIgvmfEWcrUGtBt3Um+lZvzFOR9Raz9QR
	O/9KRYZyGUs4TtqJDW3qVD4bY6HknRk6kjoAruTNjIupGZwz9VkyNOJUKN+aZNRNbsoQmHXzrJS
	0w6kOiKnnf4eH/akyNozq/v4wILzAAdrvTjevUQv9bIGE1R3JKz6FZ9vZ4/bYopxyy6LQTLDglK
	AvWfqj8OJvIkE2D6EBamDtrZa6Ji6ml/AzJRDhoVGA+1cc0hLP4PB0dpqeOtsoFP08jTrAMAiwU
	pT48l+O9xRqi4ggqBVw3jcJwBl8uxDh9QrdAAXjx/oByKHKG
X-Received: by 2002:aa7:d987:0:b0:670:2007:668c with SMTP id
 4fb4d7f45d1cf-682143aeccfmr17629a12.4.1778615913243; Tue, 12 May 2026
 12:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com> <9bff01a8-eb97-4d09-81a4-f4dbf9b59b73@linux.dev>
In-Reply-To: <9bff01a8-eb97-4d09-81a4-f4dbf9b59b73@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 12 May 2026 12:58:18 -0700
X-Gm-Features: AVHnY4K4mgRxMzZXs9TbGliBXSUNhj5QutdOEj_iYOol2xOCgNXTxL2QFRb81Ko
Message-ID: <CAJuCfpE9_Njy7Tm4DnNin9HEVoqqfKzTRgxYkEEyzm+OCc49sw@mail.gmail.com>
Subject: Re: [PATCH 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
To: Hao Ge <hao.ge@linux.dev>
Cc: Abhishek Bapat <abhishekbapat@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7ytwtb8i7oxg4tfrexor88znsbdicrnc
X-Rspamd-Queue-Id: 7BE47180008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778615915-4902
X-HE-Meta: U2FsdGVkX1/KGyPO1lpHOPsA2bO9ry24YN5ppjG9z2QEanzSbuzD839HGawibV558toty+1vALdKSnwecfmYuwCkTrxWmIYCYBlmFRL6GNCBGijwVNPCnlj8fKfWdaWLQtAKZgbfflTdfNP6BVPcRDkHusAS6W5Q7mOAvEBfe+KAD6SMrzuWuCBm/AxzBFfPdbQOgk5+vYFWp4SyDjzpI4WDm9TdffC8HgFQLRul3CjAtpykwG0gQ6ifwSZfDTL4LQMBbmkJ5qWYumFud3VtEvTuk62C+Ip1gLOj6+XYip1UxGAGo9UqcXzsRM/l6bIsLSKQkldNPp2qjHdhgB27dadPOjll1e9mrFeZYX29InNMSXtu8A9ZbyGnKlORs774ERcpcMtXpX3mSZnGppR/uI0Je5oq3+gVNslhCYmEl9RwDOA4NVcGvwN5OnSvd3gxi7FsYyLV/5rAr/IbV/wc1/lRMfo3VWb2J2a+cZUVAGyDVUPdidoeWIpwNm8bqcCybG8AVAm95ysmjDawrFNxUUP60jzOXzxogTthd2L0tanzImGI1nd1t5845M8jpdviApNtrXLxh2573ODh9lZwz7dWW5vKCJPBGWCFKMG3GoraeNKJNcFeMEd/bBwSx0Vzi5hrrkHHbzoMaiUTE/ko3UzanP5H00dsDyAz5mGuKwNA/9XRSX4oGACkIgneqaUHnw9fPHfQtVf02tET+Ze7RMW2BBdZRLpQq0/HEGHlqK3G6ZUMl5Z9/fUKo4v0GWSI3Jhb4KkpMouu8W1bcw0WtOWyG9L9jpOmY4L8RRR80dpHwIY8UgbMnVqBA22dkXpvAN7om3JUcrAcTbrqEnwbEtx3O5wxusshp++OSOMsfRt4VeuHzEL8aMPJqxP09zmWe9MUEw1broLqZ4V/UKnVRSETsspaOvHpkdKfxyYh2HLyeUYMKY2Hk4MP7Je+bIGP9TcZiHsxSGe29ksvy2L
 hoMB0+Ae
 ZytKfndACRu7TX7wAk/zLvOZKfFYXYA5L2Zfhxpg1SqI/ozAS6jlPtH8R1EMtiWjveDSRQZSvRt3YCOFH/RUaG80qbFFyOryM1nJpDXtelf+ST8kAdzHM3rEReYAKGPLL5zT3nc1Gfura42FMp58iF1yW6zAQL77fktFMRLHaRylO1XZomPAlBsemqZA0553TrZM+O4YsarmODwG43Xm4dSMx2GhXfHwxDr8DLavWffuZ6YqBVQLh9oNoRwQipLkqWU/3ydPfXv5w9XU2fNKRRoCk9SO9iHXukOegOcQqviZxZipMLFbg4pbetxW4Bg751o9jzNKt8qcleHdTGwnQqgtT2YzNEsOlrL9Kfc1DX/xWBDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 6, 2026 at 1:45=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek and Suren
>
>
> On 2026/5/5 07:36, Abhishek Bapat wrote:
> > Currently, memory allocation profiling data is primarily exposed throug=
h
> > /proc/allocinfo. While useful for manual inspection, this text-based
> > interface poses challenges for production monitoring and large-scale
> > analysis:
> >
> > 1. Userspace must parse large amounts of text to extract specific
> > fields.
> > 2. To find specific tags, userspace must read the entire dataset,
> > requiring many context switches and high data copying.
> > 3. The kernel currently aggregates per-CPU counters for every allocatio=
n
> > size, even those the user intends to filter out immediately.
> >
> > This series introduces a new IOCTL-based binary interface for allocinfo
> > that supports kernel-side filtering. By allowing the user to specify a
> > filter mask, we significantly reduce the work performed in-kernel and
> > the amount of data transferred to userspace.
> >
> > Performance measurements were conducted on an Intel Xeon Platinum 8481C
> > (224 CPUs) with caches dropped before each run.
> >
> > The IOCTL mechanism shows a ~20x performance improvement for
> > filtered queries. The kernel avoids the expensive per-CPU counter
> > aggregation (alloc_tag_read) for any tags that fail the initial string
> > or location filters.
> >
> > Scenario 1: Specific File Filtering (arch/x86/events/rapl.c)
> > 1. Traditional (cat /proc/allocinfo | grep): 22ms (sys)
> > 2. IOCTL Interface: 1ms (sys)
> >
> > Scenario 2: Compound Filtering (Filename + Size)
> > 1. Traditional: (cat ... | grep | awk): 21ms (sys)
> > 2. IOCTL Interface: 1ms (sys)
> >
> > Scenario 3: Size-Based Filtering (min_size =3D 1MB)
> > 1. Traditional: (cat ... | awk): 21ms (sys)
> > 2. IOCTL Interface: 14ms (sys)
>
> What a coincidence! I was just about to send an email to Suren
>
> asking about plans for upstreaming a filtering tool for /proc/allocinfo,
>
> and then I came across this patchset.
>
> I have been following and using memory allocation profiling since
>
> it was first introduced. It has been very helpful for our memory
>
> analysis by providing clear visibility into allocation data. However,
>
> we have always wanted a tool to efficiently filter this data to get
>
> exactly what we need, so I previously developed a userspace tool [1]
>
> to help with that.
>
> [1] https://lore.kernel.org/all/20250106112103.25401-1-hao.ge@linux.dev/
>
> So this patchset provides efficient filtering of allocinfo data via ioctl=
.
>
> Would the next step be to develop a general-purpose tool under
>
> tools/mm that leverages these ioctls instead of parsing /proc/allocinfo
> text output?

Hi Hao,
Sorry for the delay, I was travelling for LSFMM and missed a bunch of email=
s.
Yes, we are planning to upstream alloctop tool
(https://android-review.googlesource.com/c/platform/system/memory/libmeminf=
o/+/3431860)
and now with ioctl support it becomes more relevant. Once this
patchset is merged, we will prepare the tool and post the patch.
Thanks,
Suren.


>
> Thanks
>
> Best Regards
>
> Hao
>
> > Abhishek Bapat (5):
> >    alloc_tag: add ioctl filters to /proc/allocinfo
> >    alloc_tag: add size-based filtering to ioctl
> >    alloc_tag: add accuracy based filtering to ioctl
> >    kselftest: alloc_tag: add kselftest for ioctl interface
> >    kselftest: alloc_tag: extend the allocinfo ioctl kselftest
> >
> > Suren Baghdasaryan (1):
> >    alloc_tag: add ioctl to /proc/allocinfo
> >
> >   .../userspace-api/ioctl/ioctl-number.rst      |   2 +
> >   include/linux/codetag.h                       |   1 +
> >   include/uapi/linux/alloc_tag.h                |  87 +++
> >   lib/alloc_tag.c                               | 249 ++++++++-
> >   lib/codetag.c                                 |  11 +
> >   tools/testing/selftests/alloc_tag/Makefile    |   9 +
> >   .../alloc_tag/allocinfo_ioctl_test.c          | 508 +++++++++++++++++=
+
> >   7 files changed, 865 insertions(+), 2 deletions(-)
> >   create mode 100644 include/uapi/linux/alloc_tag.h
> >   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
> >   create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_=
test.c
> >

