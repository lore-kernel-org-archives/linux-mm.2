Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB36D3ABF5
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 04:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DBAA6B0350; Fri,  5 Dec 2025 23:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B38B6B0351; Fri,  5 Dec 2025 23:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0256B0352; Fri,  5 Dec 2025 23:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7B86B0350
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 433621603D6
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 04:17:29 +0000 (UTC)
X-FDA: 84187737018.12.E6CDA66
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6E151C0014
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 04:17:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fb1xsmdB;
	spf=pass (imf10.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764994647; a=rsa-sha256;
	cv=none;
	b=r38Vx08OUc57cJZRncJ343NCZFnUcXWx3Ejh5d0/Bct4P/hI4F17HkUBitKDsM9nK9Uhqs
	2vNXEEgNDB6jZW5RW5H6TPbLxji5gPa3+2B3g+d1n9Oyryb1IPXp9e4Xjo569c7cNisWfL
	Z1/EGiTkR3HVgvUiwwlYJ0kgV+Xc6Zc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fb1xsmdB;
	spf=pass (imf10.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764994647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCGqBpcBaXv11CyxxHq0NCH/Lzi9jNJrRnRrD7ZpxfE=;
	b=ZdwSMIT6sh5VCeeOzppXysAx8mdpGQT4BwfN1CyCqBMcQBgi7lpptM8KMrjx3BOAaSPfp5
	jlNSGIV1gfc0MMpyIXzJlhxT4tJShwcnd/gzV6RPUI7sQ2cj91DCIKPLMDBmwM9OfssVIR
	G3fKyJnjiayWQZHDzrhIMHPItO/omwY=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6433f99eb15so2559617d50.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 20:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764994646; x=1765599446; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gCGqBpcBaXv11CyxxHq0NCH/Lzi9jNJrRnRrD7ZpxfE=;
        b=Fb1xsmdBevO9R9riAsLin4IpnmYL85lONgDau1D9mRJIB1ciyxEohD05WjqWsqzH+b
         h62zmbrKwAvDDCsULoZgzVvyZ7LUqX0EZhzFHn7qSC1p9iZMmlFFBkSoPjLr4pKUwSc5
         +JrsGQUn9V6jXpxODEQdfIXl/8oXmcJFLcNdV3Mcg0fioLJYJYoT3FwB8Y7QxUniOeC8
         wMDoQxbzJoW7zecU0BYtik6HOF2oFEzZ1N1dUh+13MWLBuaMh8kfPi3MMhsYz6L3bqah
         HnnaB8cysJOhMqM92F0s7s/KnpD00HHecAEAIlRTh+jwc+5Fvr0T2keeXBRhsqHiw0ew
         DHzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764994646; x=1765599446;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCGqBpcBaXv11CyxxHq0NCH/Lzi9jNJrRnRrD7ZpxfE=;
        b=Tr+KRefVGyTXjC8Gjr184Jl4W3TmFzsbpT3k/9SrVNZYseBRl6RdxNeNx2bGT0g8fo
         Ys2RdaNmr0wD5Krhd4UJmj2tgY7BLPXrGAzVUYSL7qyUZKXbQzoIVTVCwNRT5jgbgWY1
         p3u6J3UxR+7rrLbJBVjEGRhnFANcsGARRq4Hlwnm7ggW8645QV3WK0N1sY5jiyXn3cKH
         n3v7P4H1COIYviwafUxE9zvgGxvypkk1g1NDdg/DuRy7amO0M7PYAh32bAVGevi68Yb3
         913Ug6naOSS95koz2mhp/rWdbEVDeJURRbGPUXdH6iegy5o8p0lByl6Qk8aVJMXFSyet
         omDA==
X-Forwarded-Encrypted: i=1; AJvYcCWHzF97Rpuehdp49asp+mbGBxcyqIp20gxnoJ8MsVf9Qy0hQlMtJnjbgTncaNoBckv/+ZY7ec3AAA==@kvack.org
X-Gm-Message-State: AOJu0Yy2fMFha5NtXBQq5sGWNv1UhwBfM0N96o35nQ6z7UCstK6GEOmU
	QamZVIgv8rzib7+g7BzETN7/+sgwTiBcBJuKxjYl1pZYW/l4ilsGUKioNkWBkqmCnVnU9WzXbEH
	N+v4z43I+3mM3tyQWvGfat060d1FlE3Q=
X-Gm-Gg: ASbGncsUlz/U2WLkXxSRF4uQ7t7fOdegS6ahPv+sMatB+WsN05drYUTZmvOAr9qnztW
	nzXJXG4lqppCdksrXl6WpoVdazeEMnYAWArw5gt8Pnq9kFT83SOo7t4401G3quxI6+vZczjBVRI
	7DUCu6/zNygFh+1B/hQj6f+nIxHlnDR3SxTRM61tBdlhlERODmg6TbAi1MHI5k27o3XeP/MqAOH
	1Wu/eylyQ5X8YevcY0qmsSmHygKVKbYYTePyFkg9cG+cJjtLmV9dgr9cikcUxwccnV7/tav
X-Google-Smtp-Source: AGHT+IG9/xl2G4VhMoTHl18YwbsrHUhUMHPjfhhJlIvvUrtycYH1yJ1ZnRNrFaa/+v46+WADeOT9m+FhNo77BNMtitY=
X-Received: by 2002:a05:690e:124c:b0:63f:a6da:4b3b with SMTP id
 956f58d0204a3-6444e74c6d5mr956904d50.14.1764994646353; Fri, 05 Dec 2025
 20:17:26 -0800 (PST)
MIME-Version: 1.0
References: <20251206011716.7185-1-rgbi3307@gmail.com> <20251206015010.47826-1-sj@kernel.org>
In-Reply-To: <20251206015010.47826-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Sat, 6 Dec 2025 13:17:15 +0900
X-Gm-Features: AQt7F2qsagOSR-iF20VCYZdpEZUQbABvnzlLKK-suACb2kbHTO0bBCSTeAWiK2w
Message-ID: <CAHOvCC78_ci_6dg=ctt5HjgZDn4bVmNZw-qfATvShnn_7qoMaA@mail.gmail.com>
Subject: Re: [PATCH v3] mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, lienze@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6E151C0014
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: ng73enhk9xgfuk1n66ey77ycnhrai1x9
X-HE-Tag: 1764994647-846460
X-HE-Meta: U2FsdGVkX1+ZDJKQMvmazYj+ZQlMBhCLpXGqaGxoJMEazpZ1ym8hArD0l8sf3Sam5Gga/DJK1/jjlm1fGQA5robNALxYwWf7eYaB9zaILuOB+m14JA9NZAWC7Dke3xaRuLZC6uAwSbr37OBEM+Hamw8PmN29BiY59gCK5WNlybpDeyTRMLQq/2Hq9SRz6JN8eO47PePpIK4UgSsWJoKT+olRxqHscUUlOZPodmFP8L7kRSY3K2yYJcynN1ZFkzTrNMXOXjoixr3SN7VxoUWkfPPpjE4Li5JmPhWFuKOv9V7TLqZ9OFRSgbtIq7OJqfA0x823WEAqkY/KnXtGtSCkGBEUTcCYZv7EXL1hLcztAbpJGMFQaQEOZE2JCeUwj6oT/DzjK8FTo8FnZ+77J8Y91zlGLFK2KmJUrMBxpR+Yx/5HBvoPJ5uH0mXeGE3et24bL5x+wA3uioZ9U9sNhpDPyo/MtQWQAqD6dx5DxlNRFr8JKfctJlMc5ecm5uY3GrVyTjA5M/dkBQpeGf0U1rPmhjdk7kmIhoGM1JATNG7JwUww3fxKMDwPpR2YcTmgKCzfhTa5YMNcXy8YZ+OVTe09ScT5l11C5LPyVy/Stj8e1UJRk5NsmiBeHx8/xaL1Ekfqld4lVszqj3qFbimyTUO8Ln0KZpLhYJ5P7WJMyz3WJCXqvQQELHsm3aSZBDHbRRVGcIAl44b0b+QroqBaI9xplmNwE500YfYVMxJp2U6cPBo9GXCQJHDws6XfI7mQwGeaswfv+GM1ECBE3esIR5/57+4IxyxEBy1oH8nEkDkET47j3La8qqR+TSXbfsFvZy8SqW+jsPmCKHYwnBcwPzuRiJZ2BhcgyausDxUxsLVaUUWjaCNnrn1kxJzZkvZB0ECWF8F3cyR7vTTfdMrIFKZhT6OlHMFbNnyZe1RMufv1eTYS1sWV8BOkxnGLBJJofNR8hidMzIDeDYwQ9n5sZFA
 m9DeoaB1
 1BXZYMYkTBl+DnKUuwDDJbS/PzxemYSK6t50K8Sj5bVzhQLicK5WsVBJ/2cs9ctS0wNN4/mL8W0Mb/jRNnf4KbIuBa/pe9Fsq2+CdTAr/jWPeE7laDQ+8tY57EbroZM4alqO37C5jcEUj5AG76Kh31HiGlhGE5M7nBjFuFVhNCbCo/JM3kAukpVaPcSSQV9dPsuHBk+23NQgNiz8APHJjB5qYTp0YpCLMNs7kSVU1HU74PCGgci4diBEKhoHPT2Wra0iPT90rFRSlIZ5lXGPdd8Q9Fp8iQJrOmdnplYT9Je0p3TH+VYWShTt+zgyM3s35Q2ISVFN9+xChfXvzB1yaZ7Rj4/3FbAa+U6vM22Nn3eoow4NzdFrl8PmSpscmtY4RTO1yXvgE+cWTQkU23SqR+tywHJ+HM5GQ9P5wRnQSNXstULs7CSdoi0Bc7m3d+WF3W9EX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 6 Dec 2025 at 10:50, SeongJae Park <sj@kernel.org> wrote:
>
> On Sat,  6 Dec 2025 10:17:13 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > The damon_stat_build_ctx() function sets the values of intervals_goal
> > structure members.  These values are applied to damon_ctx in
> > damon_set_attrs().  However, It is resetting the values that were already
> > applied previously to the same values.  I suggest removing this code as it
> > constitutes duplicate execution.
> >
> > Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
> > Reviewed-by: Enze Li <lienze@kylinos.cn>
>
> I show Enze did suggest changes [1] to v2 of this patch.  But I don't show Enze
> gave Reviewed-by: tag to the patch.  Am I missing something?

I added "Reviewed-by: Enze".
It is just minor commit message format suggestion.
Am I putting too much emphasis on this?
Should I delete "Reviewed-by: Enze"?

>
> [1] https://lore.kernel.org/875xal44lf.fsf@
>
> > Reviewed-by: SeongJae Park <sj@kernel.org>
>
>
> Thanks,
> SJ
>
> [...]

