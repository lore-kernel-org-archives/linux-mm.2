Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 493D4CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 16:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEDEA6B0088; Wed,  7 Oct 2026 12:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E2C6B0092; Wed,  7 Oct 2026 12:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8D5C6B0095; Wed,  7 Oct 2026 12:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B13626B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 12:55:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B679F1602BB
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:55:04 +0000 (UTC)
X-FDA: 85296430128.06.4C9EF7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD0B320009
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:55:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NPb6JUbI;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791392102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feQbNDosn/G0wuU19MK7YPSXaXPT3Dkc2lbt5afIcIw=;
	b=RLs59NUS6N9X5vVZz+9BSko+qDNBf6ZZnHQOoeQNxSBTLQMaxthxkM+bTtAkeVw/CKf0kW
	wpS0kYplUF2K8LtNxXn6naOLDK0MZ8wMjkTeNdPGMWEjoG5PfTxu5tYCVMe+RQs+9g/71G
	Bl6L3PqnuX44Xk3XLo3KJlfqVKAyffM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NPb6JUbI;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791392102;
	b=ghigbotSIG1rnRnhyatETybhtBKOfbVoRbpXW+DttCRiXYvXf+3FqImHNBq9UFz/TJ25/N
	gfnKa1/iveGgnb3N2zxIbV6BvzERdKNedJgH4zxAo/Baca8rqexwEwIxGwbb351PGGHcn3
	EooL6196WfAcCU6eHjHEcgXTZoF/xBk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A120360A62
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566E71F00899
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791392101;
	bh=feQbNDosn/G0wuU19MK7YPSXaXPT3Dkc2lbt5afIcIw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NPb6JUbIkRztvv2mJsLvgFDiWS7hJQ6jonrR3KtPJFhTMA5kVcMkXErePIrQ/6Dlw
	 06CKkUAj16mQ2JJE+7d1zKSI8Pu4u2UIhKtOmkqX2MfbZzsQzmWShfgwvsnh/KJHN1
	 ALrHcM3D0LcmnRdtLiNrB4sglQqC0Dn0ZUwFZ4ieoNTYTb3CcgHg13Huu2sJRbC1rc
	 tjEY/HC6L3PRGgQlR/LXHkDQC24VfqmBiBSXaL3aC/YcuTVluRSIkwCtBLxEbRkNWZ
	 2LaEaeE4A6b7Y6/YrIuVj6uvvUQVKyakdsAN8jATRP9v2s4LyTGHZuqdXbaoV5cSWv
	 LG9BL5HfMeOww==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2e3846d1caso295800466b.0
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 09:55:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxbVEhIBIZG9v6m2yQRwTqSBUTLwy/Q1MXrJa1hTlZkwL9wRTbZQ9PDZuBATbBu3dD/WLhXvxzOXA==@kvack.org
X-Gm-Message-State: AFq9FYITx8DfpluUdAo5vs9M3bVYPAgVzuJbzBA58zDzTYAmPGsanBCQ
	ofgEGmouobi5fsrlTg435JHHAfelxekT9r8PBsJOZ4LvzpGsj70JxG3bDzgdTdeiwrmgQAu/tzQ
	p1PgThmyz/Dv6S2rQ2xlb0YHzXLJVUVE=
X-Received: by 2002:a17:907:c604:10b0:c31:82aa:dd60 with SMTP id
 a640c23a62f3a-c3182aae430mr164122266b.15.1791392099666; Wed, 07 Oct 2026
 09:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <CAKEwX=N28g4T8mqniB-e+e57ie9D3Koaeq-EmV-TEk-u41FBPA@mail.gmail.com>
In-Reply-To: <CAKEwX=N28g4T8mqniB-e+e57ie9D3Koaeq-EmV-TEk-u41FBPA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 7 Oct 2026 09:54:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMCp2wsePz0DLs0B3X=urXmE2tD9P8mm3r8omgRhAL9Ag@mail.gmail.com>
X-Gm-Features: AclHuK98dP9awLd-NBKuJA3ihGk1PaIzKHPWkhcUxdhHKgbZN_qVBJw0GCQiETI
Message-ID: <CAO9r8zMCp2wsePz0DLs0B3X=urXmE2tD9P8mm3r8omgRhAL9Ag@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DD0B320009
X-Stat-Signature: ozx8w8chnaj7fuygfq4qwxmjg7m7ze6h
X-HE-Tag: 1791392102-546979
X-HE-Meta: U2FsdGVkX1+2umEO2PlgzdRfOE75cqz8/iOHpocjCSegn7cUf0I6f/FX4+pZxfMf39t4DH2QWrUYnLGGLJbo0eu5ggM7UkySmIXallNPD/pRtlsYGMEwX4f/bHlOoNRL85ICb7xQPnpU7rQ6BmJJ8bfT1XXiU6VmnlD9ottYMbs9xJn6fsqXbyQEy20R0hS5izufqfJtj8P5/pLomkp67yvmHxpQGXsdQTRWIfc98XwDYgcH1N5GFnQOF6ovAb6cAVSInJGdK5SVIUsYj6lpSTQ7jYu+/M0f6NShqbhV6PNu5X8J5TOFey+8eHEipR46yJd9pCYKJ3jxjx4v9EHpaH84Zfk40iSZsoyS+fMPnR93hHuGqs6rTmJZdQ5D35aQsvCrIGtEMAbXoeW3NxszrKBzOBiL8YF3wXA8/IJ29IebjGBfmvToE1YSV9w2AWpVgB5PSkK1dWaN8G9XV3fdeM44RNvbI5SK1mYuouT2XU9tvRglTzgQTS+LY8nqyz29I2qTx5I/hd8tNzNuLRVIPIxR1U6Ed6oaWvLLDH9Rn1lLg5fraRq9sZUcwdDiy3Kjk2Vz/FncXYsdz9canEDdTOPAaZQr0rGVGUoGfdqW2zoYUChKOSbX9EyDofIyavL3OWNpvovWE24rB4hw/Dg9FLxbFe0cMmnzPj/hGkAHI4WG6cE716jEp6c9XZwJVl3NGVEO45B9gOycdZi5fTRR4fu+pCCkFis/Ga6USdfV8R1lGlOLZ7paCUR65KN91tt1JTUrLI8PnwuaBnr8rhI2n2rILDaPH073dCVEQGIWG0t0YoxThgcrinBnOvf7UwoVY64vffjGwlsn/GdWbAGlI1ZNPPI85Pus4b9a/IcLg/HzY4IH5000q2l4vxIlEUnc8NvVktDCoLkMODq3L/ThEb+MZ4M+K3fycZSF8XnbGWvJmbvXxO7sZNoz9Ax0H/ahy57AjT0vs2jHuOcG5i+
 JC0J5mP5
 +cPs7qjTLVcqWfoWAQd2EfMVdYJBDlyCcOCZyuf2J1XQjtXDlSgPRClb4eyII73RoYbl7lyoBM+0aH5Z09Fsg98q7oB2adZN+WGyDx/5R0MKo4omq4/S9FrUzeV3Di8RxB0N5a1vzcLpPJIGZFGC1Mauh+QeC6T8o/fB+sJLn8MpWZXGmMY0GZJgHPr+G723xPLURI6r79dBBs0NwUct6NUKjiQ7QCWbBqDgDtJonQeELYiSf5qzt7fRESyDvoZOlnvK9K8gJNvblT9/MA22hDG5cGaghsEM4xeDscBlUy+VnDaUhtqR+QYjn6MFwbkaiaroFRRAI26NeR+f1qKoChOn5mZBXk750Wf0AEZBDGSPeQ93L+FmvbJW8xmFnX+FgOkQa3u627HA+UzU4nnypRY1nKeOrQLsiPC+m4kCICv+lZLzmKtuww8g9fDKfuwgKK3HZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 7, 2026 at 9:47=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Mon, Oct 5, 2026 at 2:19=E2=80=AFPM David Hildenbrand (Arm) <david@ker=
nel.org> wrote:
> >
> > On 9/22/26 15:38, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com>=
 wrote:
> > >>
> > >> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org=
> wrote:
> > >>> No that time slot is too late for Asia developers. I don't think we
> > >>> should use that time slot for swap alignment.
> > >>>
> > >>> We should find a time slot more friendly to Asia.
> > >>
> > >> Any time slot would have that kind of problem. We're spread out acro=
ss
> > >> the globe.
> > >>
> > >> Let's just use a standardized time slot we have for MM alignment ses=
sions.
> > >
> > > There are more swap maintainers in Asia than in the US + Europe, at
> > > least based on the maintainer file. Please be more inclusive. If the
> > > alignment is done without key stakeholders, it miss the point.
> > >
> > > Sigh, we can't even align on a time slot.
> > >
> > > In that case, let's keep discussing on the mailing list. At least it
> > > is accessible to every one.
> >
> > Looking at the mailing list, that approach doesn't seem to work.
> >
> > Finding a time slot that makes US, Europe and Asia happy is ... tricky.
> >
> > 1 AM is certainly unpleasant.
> >
> > US vs. Asia is also tricky, but doable.
> >
> > China 8AM vs. US West Coast 5PM?
> >
> > China 9AM vs. US West Coast 6PM?
> >
> > (Europe is 2AM vs. 3AM, who besides me from Europe would join?)
>
> Thanks for suggesting the time slots, and for offering to stay up for it =
:)
>
> Either one is good for me. But there are folks in east coast who might
> wanna join (Johannes).
>
> Johannes, do you have a preference? How about the first one?
>
> And would next week work for everyone? Say on Wednesday?

I know I have been quiet, but please count me in. Next week works for
me, most days should be fine, and both time slots (although I
naturally prefer the former, and I believe others in the east coast
might do as well).

