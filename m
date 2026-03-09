Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C66EF36E6
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 06:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90C996B0088; Mon,  9 Mar 2026 02:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA0F6B0089; Mon,  9 Mar 2026 02:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B986B008A; Mon,  9 Mar 2026 02:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69F716B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 02:43:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB6985A759
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 06:43:35 +0000 (UTC)
X-FDA: 84525583590.06.B19EA4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id F357240006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 06:43:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sMPHdWE5;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773038614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oee4XTRD36dMlnURuWN7DWeH3E5ai84Aeb4gTSpw6o=;
	b=e61AnKd3C+JTvbAq/Tx5FcGDORGl3Ovlg4QUCBqGPLVlg2kClWdp8D9ZnDRsmFOyZztgWR
	Rt6XECngCtnqLsoZdLLmu8VGtL8MUexo5AFgJyvprJPD7uuwfMG4ivEG4TQ8qfrUkVEZew
	7akX85nOnCfudW9sMcy3W6Jn0XIe9BY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sMPHdWE5;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773038614; a=rsa-sha256;
	cv=none;
	b=nHmLPf1P3bvrZTUPAsd4jmVMSmlQnAdgCtnpGGfvsG34wsSrzZfe33DTthuyPRCgIm0snm
	RQ9mKqahbXmladcv9T8mOc6A+hNb0aqktC91PH+kN5QlmTynOtFCFm2ZGiYaM2lbWTRvsW
	oy2iprJn35snLj+VtxFP19xsnkwjzmM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E852443335
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 06:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A05C4CEF7
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 06:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773038612;
	bh=Kd0fqfFX4RvUyiMDACbVyLY3TBDW007B4tQ5jKf2j4I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sMPHdWE5WkZSFYjJxVN7GaTjQP88iWcJQSSlFzuadDPUQQxKhkvW/RPoA9gjtubpc
	 FGS0F5KubKV4M0xZy10pq82vt7TZW6M87A+6ORc0lwiZfcIyomwpDaSDrncNLsVWb3
	 EipSgxlx36Mq1z0UwN4zcwmk6+WC+lMM2dZJVW+9jJ60TcliAf53kdc0Cpy9SUGq4R
	 8eovoXkOPM4VLOBsxwmqb1mJtId30jqk39Jj5Bw/H/SS25nJNRozgjQ5kt3VEmNKZD
	 BlPvhNqL8W/dvwknCdQ7OVVXbSkPJ1XwDbNkAv2aw1lhnEgV+uDSEIb0qOkwpWs8Xh
	 iQxxIlhX15r/w==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-64c9ebd1369so10136608d50.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 23:43:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXsNYeVIv7h9wW7VVFjXRDLObt3eZ65eYw2U/EY0lIIdVB9CbZMch0sTc3JLFkoReYmGB9fIpV0tQ==@kvack.org
X-Gm-Message-State: AOJu0YyJznJ38b9/dsb6iWPCSsqqWcdqMj5wI4NnRvIG+Ci7xakA4KtC
	HE6bNyR+tzTJTvxf8H2cIuosAVJKlj8ewQav1qdri5McXomAuIGogfJ3vn0FAGsT23TXgLrCV1G
	FCRB4pGJMq0/CxkgaIHq+sjAPj21kzAJJbMX7UKq4PA==
X-Received: by 2002:a05:690e:b4e:b0:64c:ed9e:2e05 with SMTP id
 956f58d0204a3-64d141016e0mr9704019d50.25.1773038612056; Sun, 08 Mar 2026
 23:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260306024608.1720991-1-youngjun.park@lge.com>
 <CACePvbXVvPp_a89UFztZo5nGawpFea9t=NRisf468VcxHgkX7A@mail.gmail.com> <aaqKJQeO8wLQL7Zn@yjaykim-PowerEdge-T330>
In-Reply-To: <aaqKJQeO8wLQL7Zn@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 8 Mar 2026 23:43:20 -0700
X-Gmail-Original-Message-ID: <CACePvbVp=9PM=LUdL=aq8G2Svy+v04pBnf3ygRY+xW3WEHNm9A@mail.gmail.com>
X-Gm-Features: AaiRm50l4FuBu88S4IZCYVq3PtusOGwnkdn1PQubplGv80j2zPfgBT3cIAgBGW8
Message-ID: <CACePvbVp=9PM=LUdL=aq8G2Svy+v04pBnf3ygRY+xW3WEHNm9A@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/swap, PM: hibernate: hold swap device reference
 across swap operation
To: YoungJun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, kasong@tencent.com, 
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: onf9q63bxi4ygcp3g7eotkfqbg68dqo3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: F357240006
X-HE-Tag: 1773038613-522308
X-HE-Meta: U2FsdGVkX1+UvR3+sAqJTFqmh9Eq9hpAqjbT9K5u0TweSUIOJz/fyJ9rnyBwwnpeRW3zyWqCMTcrC23md9RHNFlzAaPfAFgkKYszi9kV/CdMmqDdMz7t37mS5Ac0ObAtjGMwY2c/A9xXeup4LArkLKtawZUVGbbv+yx2dObVrdPgXNAJ0+Q+2kpOZmGbYpVleJXw3l61HEmz/fSxT15dfLBTyfR9ah2EJuZN/dv0Tdf0tzbjC7obsEQYK35EQakBdIjrapSM3MCw9Iar91L+dXgi0woJ9O7GpXah9BuYSBk6NNMxNrw03AVaUtBhi5oFFpctZ/q0d0aL26Kjm+Px46eCiJJGNao4ZLoiuJsdNZc1czVW/bV9fJyV+GhrP+wXUo8EPC/DYJRHnKnb9e/YpjiuuiHl8zioY9F43ipedqCzNm0TcENFQRcUlMP8dwQ2vQ/VMz6wjIkYTwNc9+PL0ABgFvgqX/8Mb6zKidHfkb1mb4/DUqaL9IjPm9UHI65rIgBObvIkIUBjDy0Q4Bo+rFigLKlmHpdQr4WvqzSjNrvPpBbAHvPzUVZHxxJ8xx1YzV3smwRAJIvCItzB8mAelc+S3bHCJw4YvsrFerczIw2WOc8XoR5mHVLMaWnv0gNcWLsuEgUeDWZbtZ+hgF02tQglr4RCcNirbYN4DVqiw166e797cTSkmVu3p9LplXK4c/Z8cbdgAXIsD+NR6wQlZbXPY/8Y/ETohG8b95mrdaDKySQq4IJBLBi2tFp5cu7MYKrXbfCe+DKNtZSniTPS3Jcg6OKXvGZrqQL8dwl5pSX94LeDQ1ehwbYb+noA0XbcDA56w25bnhVCb6GtmpuSCzdgCm0h5aMKizZ57FGyiq1y/05oK3/T1yWVT+E2mgnaF0ymJNXMyEsAMlmclsI6lXzn5nn2yCP1HHxjacaTdJd5rdmEb5tIcIfMgf5Wjn8mGLDMmx6H0af6U7NFlEP
 TpVyiMX4
 GEeivMXk8GcBWQmYAyCAznn0Xluy69JAZb45REErpk4Klv8AcBdwNTWFC3bnT+JH6ZzPG67o2RXE/ewJO+EzcdGVujxolh93IlGk31IHvo+a9B36dcNTMmOXN2qVex5AhGeDFaOfuHKtb+pm9CrNCGA6obqwp/T3t1SpcR/bbJcCEbHN+uBEzQzgGX500IWrhBQ4uTPC+W6Vi/FagX/EHB16QXgpVYZMgYsgnB5gzDYKChyxXREpGWvg3ZfZEzsrgl7kEp0wlEZYDduWP+FsBNRUDtYyMZwT4cSIY11JRlLS6TC3OmnBmBAQtRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 12:02=E2=80=AFAM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Thu, Mar 05, 2026 at 10:55:15PM -0800, Chris Li wrote:
> > On Thu, Mar 5, 2026 at 6:46=E2=80=AFPM Youngjun Park <youngjun.park@lge=
.com> wrote:
> > >
> > > Currently, in the uswsusp path, only the swap type value is retrieved=
 at
> > > lookup time without holding a reference. If swapoff races after the t=
ype
> > > is acquired, subsequent slot allocations operate on a stale swap devi=
ce.
> >
> > Just from you above description, I am not sure how the bug is actually
> > triggered yet. That sounds possible. I want more detail.
>
> To be honest, I am not deeply familiar with the snapshot code, which is w=
hy
> I submitted this as an RFC. However, I believe the race is theoretically
> possible and I was able to trigger it with a simple PoC user program.
>
> (not in-kernel swsusp as I think, cuz every user thread freezed
> before creating snapshot, only on uswsusp)
>
> The race occurs in `power/user.c`
>
> 1. snapshot_open() calls swap_type_of() to find the swap device.
> 2. We get the swap type, but hold no reference at this point.
> 3. [Race Window]: Another thread triggers swapoff() and swapon()
> 4. snapshot_ioctl(SNAPSHOT_ALLOC_SWAP_PAGE) is called.
>    -> The swap device is gone or the type ID is reused by another device =
or
>       swap device is missing.

Ah, I see. Thanks for the explanation.

> > Can you show me which code path triggered this bug?
> > e.g. Thread A wants to suspend, with this back trace call graph.
> > Then in this function foo() A grabs the swap device without holding a r=
eference.
> > Meanwhile, thread B is performing a swap off while A is at function foo=
().
> >
> > > Additionally, grabbing and releasing the swap device reference on eve=
ry
> > > slot allocation is inefficient across the entire hibernation swap pat=
h.
> >
> > If the swap entry is already allocated by the suspend code on that
> > swap device, the follow up allocation does not need to grab the
> > reference again because the swap device's swapped count will not drop
> > to zero until resume.
>
> You are right. Since the swap device is pinned once a swap entry is
> allocated, we could indeed rely on that pinning mechanism to ensure safet=
y
> for subsequent allocations (instead of doing get/put every time).
>
> However, relying on that pinning alone does not protect the window betwee=
n
> the initial lookup (step 1) and the *first* allocation.

Agree. That place needs fixing. We will make two patches.

Patch 1. Fix the swap off  racing between lookup and first allocation
on suspend.
swap_type_of() is very tricky for the device swap because of the
conditional lookup of the si->start_block matching the offset or not.
That make this patch very complex.

One idea to brainstorm:

So we can get the reference count on during snapshot_open(), after
checking "root_swap" still points to valid swsusp_resume_device.
Then we release the reference count on "root_swap" during snapshot_release(=
).

That might side step the complexity of  swap_type_of() doing the
si->start_block checking.

It should fix the bug you described here more simply.

> My proposal is to grab the reference at the lookup point to close this
> initial race.

That is my suggested patch 1.

> If we do that, I believe we can remove the per-slot
> get/put calls entirely, as the initial reference is sufficient to keep th=
e

I suggest that as the patch 2. It is an optimization to eliminate the
get/put pairs. It is optional. without it is fine in terms of
correctness. Might not worth the trouble for patch 2.

> device alive until the operation completes.
>
> Regarding the reference release strategy in this patch:
>
> 1. uswsusp: The reference is released when the snapshot device file
>    is closed(snapshot_release) and error paths.
> 2. not uswsusp`: I only added reference release in the error paths.

That part makes this patch complex and harder to review. Need to
carefully check whether we take the reference count or not.

>
> About 2.. I conclude that on a successful resume, the system state revert=
s to
> the snapshot point, making an explicit release unnecessary. However,
> I am not 100% certain if this holds true for the swap reference
> context.

That is the part I try to avoid: the very fragmented error condition
for reference counting.
Hopefully, with patch 1 idea we don't need that complexity.

>
> This part is the primary reason I submitted this as an RFC. I
> would appreciate it if you could review this part specifically to
> confirm whether my understanding is correct.

BTW, I can review the swap part,  we also need to get the
suspend/resume maintainer (Rafael?) to review the suspend aspect of
this change as well.

>
> > > Address these issues by holding the swap device reference from the po=
int
> > > the swap device is looked up, and releasing it once at each exit path=
.
> > > This ensures the device remains valid throughout the operation and
> > > removes the overhead of per-slot reference counting.
> >
> > I want to understand how to trigger the buggy code path first. It
> > might be obvious to you. It is not obvious to me yet.
>
> I hope the explanation above clarifies the trace. Please let me know if
> there are still parts that are not obvious, and I will explain further or
> investigate more.

Yes you did. Thank you.

Chris

