Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9782D37E25
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D0576B00A3; Wed, 14 Jan 2026 08:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3476B00A5; Wed, 14 Jan 2026 08:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA016B00A7; Wed, 14 Jan 2026 08:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27AAE6B00A3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:07:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C841359276
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:07:10 +0000 (UTC)
X-FDA: 84330595020.27.67C5B5C
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id D90F620002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:07:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NEjx0P0Q;
	spf=pass (imf13.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768396029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSspBM8EaxGFzihjOax4j8BH2eLMLR9IBJtyij5U9Gc=;
	b=RI1Np4RB8CuT2hqIs1zcHt7GMFVFZrP9oo8KYKb3rU40/qzfZyxHWno9waLwGIerORvnEt
	dcHYQh8ppxkqKgZcNaxwLRLl9CvXZyYCjY3BcicNKAlzmuKgnonE+8eL4KG08916KBrFSL
	i7c7i/6cOdK1ZM4xSBg120Y/Z1+LEhQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NEjx0P0Q;
	spf=pass (imf13.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768396029; a=rsa-sha256;
	cv=none;
	b=BRzP7PfcqR/1eIpN6LbKz70JLAtFb+wycCQyeraQChitWGjQOv4ofwYhU0UoQQ+INnP9Uz
	bCxn9q4Otq2c1EVeNr/jMTJUMREdgr9Yiz7otNfgZ25rMDFuSe27ke64op30Q5EMlwrHbk
	ESuI9hzwdmO0k5f11ITuSecObMzF568=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64dfb22c7e4so1556863a12.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768396027; x=1769000827; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSspBM8EaxGFzihjOax4j8BH2eLMLR9IBJtyij5U9Gc=;
        b=NEjx0P0QDpPWC4pY7j5H4FtlIU9u/hxhCndChhYk/WawOXCJWAI0uhw1fmvXJSBSOU
         wE/ywvZ6rmvSrPQpcKJjHavUH5wroRO8riW1n/iJ6EAPytmdbp8vxSMSBnM+FYnO2DFl
         5gVgNZ4QKneSOkq+1Nc8Q9wIAL0cBNM7/TnM5wly1QF5Kqta/5CxSoKAXcqFG2xhUPlE
         gmaxNC+7Biq4rMt2pBw9p9AVGi9KoO856vtOaXNfCs0ZkXyUqvp/0i/JCEY7T0ou2ORv
         pAJpQXaxMMZwy69L8lAlNPljv/drd6wTqo/KKLanvItCvBNfsuhsjYoSfcJe1uCwydHj
         vefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768396027; x=1769000827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xSspBM8EaxGFzihjOax4j8BH2eLMLR9IBJtyij5U9Gc=;
        b=YQWN3MF++H7fwaQWvFeyBWoOPUOhi9m8JHPaqdaYJLxlwmcF++cYiC7xWWBgXVNG9J
         cyNWOkScuu0XDqcoDUwq6thHSLnOVwn1mrM5OJVVdEXZaUejQraC/h4ItIbEExkpG2ki
         ZxnmoMQ1T9MYtiNuHwC26qk1E2I1wl4J+a5ZwA3bEI5Pu8TnF4j4xlRNXsSwJM7aRLyq
         kNXlp9Ixxh2wRCHc9ngVX9gX/3Dxz+FQucoBm6bb81aYTfPNNlh8ST7D/+iSwXDihqZ5
         5LgTOd1ZQI04Lfm3z971hxE4ftcg2nBjjBGbpGhTrjzua8f6WC1banY+F/WI9gBUL4j6
         TfBA==
X-Forwarded-Encrypted: i=1; AJvYcCUL41c+H8HEjVp1TL7RVHxX4yMnmI00WHOS88aMXtVeFc7RMnKSvsoDHi752pd0B3v4v7NRF64zrQ==@kvack.org
X-Gm-Message-State: AOJu0YxsNHfgtiVJvWT3kZpGhpRR+8Jxutu8OzzLn7VfrKAu63JfQzDQ
	BdjT/EPxWsg767f9vpuzPbeY+hRNr3Mvd+FFFb2HyImscrluJ/Dvz5E4TMyBRmJLBiZmCynvhbX
	yVVQtfP/kGAQSy6ividjrn8hJrsZ5LvQ=
X-Gm-Gg: AY/fxX7eWZSmYZ2y3LPOxJc+KyiGG/QPUsQWrXl/oCeKcLw3ErtzfJUVFCjy2uzPz4E
	PfKB53TjRG7REfAzC9x3xaw7G+jslwSxddT22DYmXkT606YH7zF6a1bQr99qJNlfV+9uONaKGa/
	lEvI0kjdYs8z6GI202Sy1KMtO6BGd5yBpywpXV7PWrlvThUWeol9RuNi03BO/RwnyEba3xhcC7f
	uSqaO5CE8hrw1KwWNAcdB1XfSZnmQp/PX/2octyW3U/jZfYz9qiEOmn/lQfQE0CdIWLUJEeOwW6
	0nwmirgKeDPvefxwAdZtTmxPcw==
X-Received: by 2002:a17:906:31c7:b0:b87:113b:d63b with SMTP id
 a640c23a62f3a-b87359b6b66mr376283666b.27.1768396026693; Wed, 14 Jan 2026
 05:07:06 -0800 (PST)
MIME-Version: 1.0
References: <3d8398f1-0130-4d3b-ac54-d23877811747@kernel.org>
 <20260114113635.97621-1-lizhe.67@bytedance.com> <97413239-2bdc-456f-8511-65fb9f1e301c@kernel.org>
 <CAGudoHGb1w92gn89BBuMQOmvcVZkwvt8CK8hFtGg3xmHphmiEw@mail.gmail.com>
 <d9fbc00d-182b-4463-b718-73c2f0eef3a0@kernel.org> <1edfe356-8334-42d2-9d68-7c5bf21a01db@kernel.org>
In-Reply-To: <1edfe356-8334-42d2-9d68-7c5bf21a01db@kernel.org>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 14 Jan 2026 14:06:54 +0100
X-Gm-Features: AZwV_QgStGGgdGZJwipL8s0JB8braZ3cD-WwqXt2daeumLC2PI4hepcGAVk6Es4
Message-ID: <CAGudoHEyxsPnJ2M+LWkPEb94L2Xp0iqH6O==hCUZE1woLzZB0Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org, 
	ankur.a.arora@oracle.com, fvdl@google.com, joao.m.martins@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	muchun.song@linux.dev, osalvador@suse.de, raghavendra.kt@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D90F620002
X-Stat-Signature: kkx1u9nfokdiebz8au9p9q6iuobnxfes
X-HE-Tag: 1768396028-935141
X-HE-Meta: U2FsdGVkX19W/dh50hJ5yZ5BUL8XTrP6exvjC1e3hFrZX4pZOAZMO4yMyWMsR/jI2BhDnTEbf+x5zkfN8+Z5hKnL1wy6WdAeIgjMsSb7bC1Dif/K3AOCUUhuceHsbCJPFHoAut70kECbndPn+EsDq0w4mAQGhrwlRi8CYse+T7VCYTXJIeUNN6sP/hHUsDo+1+rayTUaEZztXM0XbDDixpeuD0FRThmp9IrbJnvmtCb+3//DJkOLdp9ZEtX+obC6HrJl9KevzM+TJi1mxqJQkVz4ERBDeUxDeBWjxCgG4NgsQ719s7TKM0B023P3g4ANJmXaGT+rbcqu70WHPkB0ZkdCX+K3unA1AHl1+11ogLXQ4vrO3e8/dW2up4kEPxXQuOwBOlGcDVdNlqzzT29MHe6/MrwxJAqHJZHqL74E1vcDTIT4v8iw+s2Mv1+kJMasDrwD3s/1N0Vz8dFZbHlbpS9FrFqNahs3TAHC4vUpfsZPg2GCQm7aciVsR8ID7Uta7HdiFU1rVKzOfULX+m0nTFVOigkFnXA6aJIT4/VlPTUdfeTyDE/96ia8ia0WGTs2IJXAZI8v928UM2z8wI8s7i+wyjnB4g5RXviPrW2+by3VaDcDdjEQmJ0avQ8qkVGRqEtq5AQ7Q+fJ6HSDcV6hLTeiQggOQCzrZmPmL74rSxzRrkisZP5cVivrvZZ3HYU61X2XCqrhwwukRuxh94olxDBzLg65rQhSMwEk2G0QHfcs5MRl8RONlXm0l4L4fiqlktf0QNSM1zT7KO9uBsC791NGINbMgXUTdsjkK82do/5DyhaRMhS5ykN9pXSu62pMFQMgQxCWToV3NNyHjAPAq6iL2TldqxizWQHJCnzj04Pl/exuWJhu6LfCQRht6Vj1vI7MyfzqqxpfwtV1onvXVUFlUPdS3F1AKSLd7C1wyMH0v8AyU2P6T3OjCpVxu3bLRa6Wxsy8T1OpNjp0KGK
 /gL0NpD0
 /V5SfdO6XW4vE4vqngyO105eFCeT+RKi/72BJYoVff5+wbeHVwMauVLag9fwPY9nAaCjJIAe3pvwZVBNrIvg3di/qcPgmvm3Mpbn+cENzUyYdEQaif7JdkbEEyr77uhp4HxRXc7jciblGp6xMeM8MxW0NE1ms/8idCMrLWMVAmKWYUw0MMABoirYDfPEcKWSmz9UXrlca4ETcTCOMEkp4U8yT+bcpxKgmTjVZlUXOLKW9dQbMVvKxTVTptR5q1BRQqumbOw8u5UejxNX+RnUnfm+7cWfK5AdVDFue2z7SrSy+1HZL2oHqt9TI3yqgE1bdT+Ffu8q6sIfSnU18elkAwULqSUhHtbgPkJHtITUI+Lobuv13Uvlw7jV88/7z0usZoqfV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 1:41=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 1/14/26 13:33, David Hildenbrand (Red Hat) wrote:
> > On 1/14/26 13:11, Mateusz Guzik wrote:
> >> On Wed, Jan 14, 2026 at 12:55=E2=80=AFPM David Hildenbrand (Red Hat)
> >> <david@kernel.org> wrote:
> >>> You said "I wonder if implementing hugepage pre-zeroing directly with=
in
> >>> the kernel would be a simpler and more direct way to accelerate VM
> >>> creation".
> >>>
> >>> And I agree. But to make that fly (no user space polling interface), =
I
> >>> was wondering whether we could do it like "init_on_free" and let whoe=
ver
> >>> frees a hugetlb folio just reinitialize it with 0.
> >>>
> >>> No kernel thread, no user space thread involved.
> >>>
> >>
> >> i don't see how this is supposed to address the stated problem of
> >> zeroing being incredibly expensive.
> >
> > The price of zeroing has to be paid somewhere.
> >

Of course.

I'm stating that with dedicated threads for zeroing, provided there is
some memory available along with cpu time, it can be paid while
nothing actively needs these pages.

> > Currently it's done at allocation time, we could move it to freeing tim=
e.
> >
> > That would make application startup faster and application shutdown slo=
wer.
> >
> > And we're aware that application shutdown can be expensive, which is wh=
y
> > e.g., QEMU implements an async shutdown operation, where the MM gets
> > torn down from another process.
>
> Also, just to mention it, assuming a VM is backed by a hugetlb file, the
> user space thread destroying that file (or parts of it by punshing holes
> and freeing hugetlb folios) would be paying that price.
>
> That could be done whenever there is a CPU to spare to perform some freei=
ng.
>
> But again, I think the main motivation here is "increase application
> startup", not optimize that the zeroing happens at specific points in
> time during system operation (e.g., when idle etc).
>

Framing this as "increase application startup" and merely shifting the
overhead to shutdown seems like gaming the problem statement to me.
The real problem is total real time spent on it while pages are
needed.

Support for background zeroing can give you more usable pages provided
it has the cpu + ram to do it. If it does not, you are in the worst
case in the same spot as with zeroing on free.

Let's take a look at some examples.

Say there are no free huge pages and you kill a vm + start a new one.
On top of that all CPUs are pegged as is. In this case total time is
the same for "zero on free" as it is for background zeroing.

Say the system is freshly booted and you start up a vm. There are no
pre-zeroed pages available so it suffers at start time no matter what.
However, with some support for background zeroing, the machinery could
respond to demand and do it in parallel in some capacity, shortening
the real time needed.

Say a little bit of real time passes and you start another vm. With
merely zeroing on free there are still no pre-zeroed pages available
so it again suffers the overhead. With background zeroing some of the
that memory would be already sorted out, speeding up said startup.

