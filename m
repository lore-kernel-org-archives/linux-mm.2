Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4825F483D7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106B86B0099; Mon, 23 Mar 2026 14:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DEB66B009B; Mon, 23 Mar 2026 14:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36646B009E; Mon, 23 Mar 2026 14:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E09376B0099
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:19:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FC46C3BF1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:19:39 +0000 (UTC)
X-FDA: 84578140878.22.2F06984
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 869FF8000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:19:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=InJYzyA0;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of avagin@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=avagin@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774289977; a=rsa-sha256;
	cv=pass;
	b=1/NKZSWp1MisjxyFIVZexS4W2IEK0qa/FaU6KRRUaPeidAaTCDs+82vq69XfNOuUrXsfX/
	i6IlvguDJ0KBtF4aZ5OPLHgJMKczTyA0NW50OtK08sxaQZMZ7N3zbH1jWueipuljoUKnr/
	HwW6H20+GbY/b5E3UIoYmDaKrlyyILg=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=InJYzyA0;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of avagin@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=avagin@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774289977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpME3hoPAsp8yjWyK8G0DnmZShEC8d8jtzVq9X3h7nk=;
	b=n4TNfP0th3ZpzsWeXDdVRnThvTRBZX67RR51vXRuG1/W0F/PYum55nwpKCYUK+lhysQxJe
	JzDUhGCExSQXniO3GAD2kWaCvLqzzyx4SqckgQ37adt0+ny8LB3LdDtGKHuraEpW3gsOaq
	S015fLR8nJENrK4sytYVfYa6uX56zQ8=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50b6c45781aso118421cf.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:19:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774289976; cv=none;
        d=google.com; s=arc-20240605;
        b=K5QzBzlU99VMuNOS5HK4RCAFSK0/QqimLnBzaYx0YyqUTtRgx3RInbztiSQuuCkjMz
         JVeEsveAOAneBhNda/TH5La96vmM+LU96QyYUyCgJOhgVj+GGmjSKDkrCJfGXy6JZmRV
         mC1cvczp+I1WYnMjXQ6DlYr5nvSsk3CHsJX+4kOAVZpoiRIwtQ7S97C68o5r9hUMfqiA
         AhH1fhx1JZhAewpsTDy4skJEJn3C2L0sgasribksjfQ3eDDqe//XCbsVxeyA4KU9e7qa
         2oifZ4rJ/73fgmy7Pc92RRnMRoSpjQjiWV4vhHQEpK3Mj0SuEUFuNuJ5nBvm8mYW8D6m
         GOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rpME3hoPAsp8yjWyK8G0DnmZShEC8d8jtzVq9X3h7nk=;
        fh=z5XKuuZR9GyHpB/ihBO29qUFxsoRN7Fm/AE22qQvTK0=;
        b=M2iR1sOc5Hyj0EHr9HSMIlJhWF5K7cWjNXrB5qK2mp4/SCXfAhqkUNVwTWnUWSxZCQ
         Q3SIQkgYEUjnuAlw72MXPTN2VFpgklHHAb6NpnUsy+fXFrhILAL7hPS8UFqtWvmQIm56
         nMdgmkUYdZ3hw+CctEezlS3PAX5rxmDdSE7uPXwPMLLTB2Oi3+WWfAhnZU45iiviNMK2
         UEuL6h+NdcIosOjNZt5Jp6PbJFTVE9Ikp+dKlHiysN3liTI13EX84TdqXKtgNO6RFURx
         E2sRGXMx+MkEHMr7LX5wSVRCkXY2tRHrp0C2DTF3fPlp1BMYSBCbc2tjTMSxCmkacFla
         yB0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774289976; x=1774894776; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpME3hoPAsp8yjWyK8G0DnmZShEC8d8jtzVq9X3h7nk=;
        b=InJYzyA0LIZ1d0fLFm3xGHj9QH1xyQJrmB7heKzWNTknnSS/z026Dp79u5gI0EPATz
         uR3ecrmdvfToTrfZtK/kH31DwJ5w1QbZsGINEjn6cNl1E5gx/YYoeKe9Yk/9pgNk7wpd
         j/AEttXeYS2/VGGcnheeXBh/qsZL6Os695Zq5GHNxa5hODcWUtVYwf7MwFW1i0GEa4VK
         Z3wP4Qcbtmcn6L9NQoSmI4nS1PleCcaKXCLMgDRqQDiJ7S1ykDk1UzMjzym91aagqfdA
         CeTrc3yD6gBFBOpNShqvkjhoYMzn4cWb5anKtZzGuFxlZG5Rytc+Hb+t3pqI79hiuWsf
         yldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774289976; x=1774894776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rpME3hoPAsp8yjWyK8G0DnmZShEC8d8jtzVq9X3h7nk=;
        b=qsNL/98WN0QFKqWhAx/du0ETMevT3Ll3xD7teyJM3rETgJAHhUPUZ+IUyi6joHazuJ
         DckCZOT2KsGl0eZAyAhc4Z4klpcRMdfBznDq6RvrPkeO0jxAySloIwRl96GFWcYb6bI5
         BuGLJr8/ju87Tnh2SOJnf0Z/e+8JgIjaAuC+s0spPp9wyn7LqtuGXsFxMBH3WHyrmxq+
         hYA+78Ly7CSVadaOYpZ4oHa5Abwu54DZByBGCxEfnu6Avq0n9cEjXI5tkdiFHbveYBTE
         baAXiIQ4xcNuNYY5wz/aC31WO3p1lNbP8g8kyKNbZ+DgXk30DpLL6GcMLwjesVG5qqrm
         Kg6w==
X-Forwarded-Encrypted: i=1; AJvYcCUu/44a4Cfs+vqHO29cuP/D7/fFMxVfyBaBCILt8XJj2LKRtB6V0f4Mu/jfd8DI7mRzTr5vk3vr/g==@kvack.org
X-Gm-Message-State: AOJu0YxTN2x1w3jjRNYSqLu/D9pJlDJpx/R+t/QGaREnhYIixGQdagV9
	z3mc0sHDA3ydfL6I1gBAFkFmZTgO7a4ZeZ5gbZMr3wKI6PtlYbjdWw7CHNfXQx/rkS7AAp9N3Mh
	uQK7nkYJkzfVy5AaAaF2e33uPWZ4u/fm8uWV3p95B
X-Gm-Gg: ATEYQzy8ghYIjI+tfE4IHQ/AhxnyZKcd3OkzvIvix91zi1vSF2CYY9vEglC3G6QZh1k
	NQ4VprqQffURXbHrrRgX0/x6ojmHRvRl9EhrxoEbvsNp6J3d/dQrTtf9adMLndllf9liJUtb55G
	U2E9oukNW7VO4Xq7kYJhzfxVITIh1OkMpeGTx6jAQxMHFqLQ5aqD7zF5aKIru10jWmgc+TuXvCx
	Z52hVWFL/Iv4Cf7d3ifE5+C5holmkZ7DVwmnBCB/tZFRZO1KMvUGJg7MHsQP0DTXUINPUwmXgrY
	M2lS91U=
X-Received: by 2002:a05:622a:a6c7:b0:509:1d4b:f86f with SMTP id
 d75a77b69052e-50b6fc209e3mr1241661cf.14.1774289975825; Mon, 23 Mar 2026
 11:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260217180108.1420024-1-avagin@google.com> <CGME20260320091528eucas1p14a64767f916b556d30cfa00bfd320ace@eucas1p1.samsung.com>
 <20260217180108.1420024-3-avagin@google.com> <aec9c36d-d67a-4b61-9950-57b95afedf75@samsung.com>
In-Reply-To: <aec9c36d-d67a-4b61-9950-57b95afedf75@samsung.com>
From: Andrei Vagin <avagin@google.com>
Date: Mon, 23 Mar 2026 11:19:24 -0700
X-Gm-Features: AQROBzAhvewwaxO75KtHSJHA6EI49ZdtMgsJux-PiYZ7CKyEB4qJVMgkX7DDUX4
Message-ID: <CAEWA0a7s86fO_gezFRWGjXh5i0-=XAuo+7pqqf3CdWRX3kBwGg@mail.gmail.com>
Subject: Re: [PATCH 2/4] exec: inherit HWCAPs from the parent process
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9uy1jxisperjswxfe7namkoxzjn8w7g6
X-Rspamd-Queue-Id: 869FF8000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774289977-932752
X-HE-Meta: U2FsdGVkX18XuHGfKpYI9hpC0UJ5Mc4TNdOW0EJeebsApT5xj/mmXiHdxcsBgdBQ16UoLbF5hjW6d2UCtRiyQI/6W2nUXcOdjBWKF+aAWcJEit1sWutpf2WMDMk/26+mzkZmAMy/BPXjYMhPGSoKhaOFLRTj/AF33nMV2rakB4uNpRezIAoJfGwxKO0BI9KEPrVp+4BoSR7PyGFpQTsXgFG2nI5aGb9jxysPlyIfRSBGe0C4IhTb8lQlVD7o5F/WprLjZtjLcIZKJDrtKxWiZHnavuaJqHUILlHLkJHcv28WPHTcbnzbWr4ylwx42dgBzuWDMsYikhNECFCWfCfd+JuUBkmXYpTWr6xjhscLtVCKSdETdTLNxS93nD9Kd8b8PQE8jIXz33AXR7dPuv/o7qqi+G6jeT9+oYvpbrWQieurZGmv1pJPikjvaZEkzwOZl1UElMmhi7rvIZz0ft+DPDWgOQrLuxPzWAxeyAXsXnFalYGmXHvawbhYCRwd/uRS5WFwGirAop+VCqyc4/O0BVX3s2X2IVFzkTWlJeSR5gJ7jQ4y2Jwrj9FL/bNVV4GFFbqWJw3N5g6bz+g453k5BOjdyRKMjkymWzdJWrzwioLSUSpBL76FB3vOeri4xnPwCrGnH8NtmnyWioK9xTp3u9BMZqBRwC77e4HkB68pYnBdqcf2KMPuExxJ5IvNfrbDCpBBncAf6lk1jGxuFLqLZwAOKaPchRca5F/KO1ONiSQ6ACj1MstGH66ZBc9XLqPuQSndQhC6HhOTVLSkX/b6Hhh7BaBuWWys8hVFoYvoCqSnMsfeJnoucCrrKyp/T4idcHu5indtUiG7imKSSLKRN68fD0fdi2mgHWlTnP94Na7U9bhdpsCfzbzly7QYe/5VTDc7lJJ9cXVEGanoIxYcrFFGeLW0M/47GvvvIlhZoXwSQ1zn7iWkHfbFYL+SQ3Mt7WXLLg+04jkONsCLZEI
 2v40HI4E
 /4QDIJGue4HyadGGiplI3fBEwfy6qdwjg8q2s4w8rB3V3FaOLY7WTZ2Uw453RqvSyNvfweb91C16IsteUM7a388qmrCpkpwCzJMgJ/HLFStffIs9tt/kPjSjFi/5uutQDlyGEP5jjh2I0KmFhUjGI290lpDjCGPYJDE0RYbXEgAjXPE1RlPl9Qi6B5fH5aSw98ZeMW/kbBmO1U3Ph1TSrR0OYdJvk9hBswUG9jPj8wzsxtj40d/DrsljyRJESY+HkVJhB82Tm6nZXbPbcLHpKTmGOkOXMa5xnTGFVGzPlfkCji1HTl+AoAS7U8tpUeu4AhUTyM8gWrwXknDVZeLMCIbdTP2E9WW70c3Vi9g67qxqGUMx63YvMGnIKLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 2:15=E2=80=AFAM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Hi,
>
> On 17.02.2026 19:01, Andrei Vagin wrote:
> > Introduces a mechanism to inherit hardware capabilities (AT_HWCAP,
> > AT_HWCAP2, etc.) from a parent process when they have been modified via
> > prctl.
> >
> > To support C/R operations (snapshots, live migration) in heterogeneous
> > clusters, we must ensure that processes utilize CPU features available
> > on all potential target nodes. To solve this, we need to advertise a
> > common feature set across the cluster.
> >
> > This patch adds a new mm flag MMF_USER_HWCAP, which is set when the
> > auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV).  Whe=
n
> > execve() is called, if the current process has MMF_USER_HWCAP set, the
> > HWCAP values are extracted from the current auxiliary vector and stored
> > in the linux_binprm structure. These values are then used to populate
> > the auxiliary vector of the new process, effectively inheriting the
> > hardware capabilities.
> >
> > The inherited HWCAPs are masked with the hardware capabilities supporte=
d
> > by the current kernel to ensure that we don't report more features than
> > actually supported. This is important to avoid unexpected behavior,
> > especially for processes with additional privileges.
> >
> > Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.i=
o>
> > Signed-off-by: Andrei Vagin <avagin@google.com>
>
> This patch landed in yesterday's linux-next as commit ac8c259ce0d5
> ("exec: inherit HWCAPs from the parent process"). In my tests I found
> that it causes regression on my Khadas VIM3L board, which is based
> on Amlogic Meson SM1 (S905D3) SoC
> (arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dts). Running init
> process fails after this patch:
>
> Freeing unused kernel memory: 13696K
> Run /sbin/init as init process
> Kernel panic - not syncing: Attempted to kill init! exitcode=3D0x00000004
> CPU: 1 UID: 0 PID: 1 Comm: init Not tainted 7.0.0-rc4-next-20260319
> #12369 PREEMPT
> Hardware name: Khadas VIM3L (DT)
>
> What is probably important here, this board (for some internal,
> historical reasons) uses armv7l rootfs, but other boards used in my
> tests, based on different SoCs, also use such rootfs and boot fine with
> yesterday's linux-next. Reverting ac8c259ce0d5 commit (together with
> 0ea77bbf3b98 due to dependencies) on top of next-20260319 fixes this issu=
e.


Hi Marek.

Thank you for the report. I=E2=80=99ve sent a new version of this series he=
re:
https://patchew.org/linux/20260323175340.3361311-1-avagin@google.com/.
The reported issue should be fixed in this version. Could you please
give it a try?

Thanks,
Andrei

