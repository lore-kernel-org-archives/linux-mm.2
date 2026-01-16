Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326B6D4A615
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983856B0088; Fri, 16 Jan 2026 04:08:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9068E6B0089; Fri, 16 Jan 2026 04:08:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE8C6B008A; Fri, 16 Jan 2026 04:08:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4A86B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:08:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB31213B473
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:08:57 +0000 (UTC)
X-FDA: 84337252314.08.3EC9AF6
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 099B940008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:08:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bgMF0Xyk;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of smostafa@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768554536; a=rsa-sha256;
	cv=pass;
	b=gIQ/bmfzIbspVzYmhXEseBcDAtDJEcGDD/H95N76VQBdBc9jH5wsfXwiwn3GHQDoUZ3CQk
	SRzUt8tKdzhZUWpS5IZagUE5E3+IkQDDfkk6xu8ksvqlxLzSeNe4S0EazUwws3Ocke870e
	eXu+BpjogUauhWn0icK67Zh3rN67Y8k=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bgMF0Xyk;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of smostafa@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768554536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RcimFNxoQuk1GUtLKJNj8zegx2jcra7sXFZBTJ6wuhQ=;
	b=20MNes+sBUq+ioZzCkCibMevUtkx6tRUNA2CmTcwF+Df4xIVlgcipcic60Jb7KgrKasZN4
	1z8+aQqctEDjewDf85/dm6c4wa2kouuKV2NwSa8WwUkIRVT8liqTaPodEgTVEFhuIqerje
	3UsSK3j0G2QCN4KP8rScRJKn+w/aCVU=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5014b5d8551so327811cf.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:08:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768554535; cv=none;
        d=google.com; s=arc-20240605;
        b=A2vk8+VROHh30mAbni6aHYQyHIcJ04+ks8ODYRwza/QBqp6adksK9j5O0HNFuI5D4U
         QNK3JUnceI96lAGP6GpM1EaEsD01BVzETUsbalHUDs/Ufa93GbJb3BbXGAcZK2BLUlaH
         rRm1h7G7kyof0Mk2oidVOr0Z9/6ZLUiXPyeo9QKcFPlHNkFA9qwBWvGF7zFVU/TfUUwC
         vJbmRsZ2n2WoGyPSyu4gEqRMG66X3Li44+6H7HBM5qszyJEEKqfK3GMSy4u243o3vi74
         wJOgBgXsg+YMCQ9NbBe/TRPDxYFGe7ywuW8tAV39PDshGbjUg+m83/Cv6LsaPSB0nlAM
         X9bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RcimFNxoQuk1GUtLKJNj8zegx2jcra7sXFZBTJ6wuhQ=;
        fh=p4j2kzS1EdXIq2Ml70yX5WC5oz6ta1lhPSKxZoFDECs=;
        b=LAPcw2psVhXduZsl4lWNGMSGdb4lvgAfCmWUDCsA+EP7KS0egHsgYw/t/S/pAnBr+G
         LaaygVYJUzT/amcR7mjQdrma9bLtimJByRyRhft9d+eg00HXEZRsBSYHAOS8I2ljxK6a
         KpmlStYxt7zzKefGXEEKSlTC/S10823YnF7Qi4vxi/rXvaH3jGtmriHiEY3u+28mSe5g
         xd0G7/b4p6EOvCs7K4/IbY41TmhoijSuBwQO67SYpeMkNpc12ssGYZDnVJEQwpXHKyYA
         W4bwMldF8jJyHZ4IGzOzOBLP4p4NrQiGYGlrx6AqaB47dHekU55W6KnKj1PSA9vlEkPZ
         AXDw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768554535; x=1769159335; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RcimFNxoQuk1GUtLKJNj8zegx2jcra7sXFZBTJ6wuhQ=;
        b=bgMF0XykKNKZpoV/cFEl13JYTZpLbJ5NnDgRUJ0+fd8ZwG93si6pRMl7+PL2cnv/Ah
         u1SNhS5ail6Pn8SbFToKb/GTBhk2wXtm6XB1uPTk4svUc3oUT3KHN3KrNKFbTLZ3S2ZA
         UsMUfZHP0OPgfENkBsb0gNCJOpinr7jIkoEYvEoOu8STGrlkwujZeGFL5+WHGQDDMH8w
         eHUNQAb29G/je4Zhni1Vw4mqID5LFr/vZjh7le0pjA2r0U4TIJtDJ0oBj7Q/tzOZvHGQ
         mzmx+j3NX3aO2T8ZWfBHa7H/QJMpoPCTe+qmcL+StZlPJRUISA/dCZpiKAsxWPJjHO7G
         uQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768554535; x=1769159335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RcimFNxoQuk1GUtLKJNj8zegx2jcra7sXFZBTJ6wuhQ=;
        b=YGNsdjko1X1yi5YatAMNgt0AWpjJcgB75wIwW1QKjUvA5EDvNQ/TZdfEQBZ7Fi8/ez
         MTquc7Z5UzvdWfj20RT21uddkzY8XvkZbqqrbYbfbzXrizxG8sZ9JHw8QtlejI3Lyhzh
         I+lcuHqXbL+2dckdALZB5iS3Ql32MZZKWrDe9iAoWooGf0dmDTTAKEubQv3aKeF3osD7
         GrxpJLQE4K6IJY+nasvBsWfqUSD57THNlR8njK33B5qviYIlAkcd9/+Ar4DKkbjYyrAK
         YZAXkAmqc37ANMle8S6lX5autVguXBwTINNOaePNNqzTwShGoQchRFmK1TMuzrEoK3id
         bKIQ==
X-Gm-Message-State: AOJu0YzumLmI+MHvfY1NSMfFpeK1t2vBxeDOwhtOaG8BTiB3dOtU0pAM
	eY3h8jh8d+wN3pGnzvYmMJR1uaUYGLUauKE+PVX4KEj/oCliQCVv9vudg9r5sGx8KOEAz8s7rF8
	raK+vNiRa6WrABZathio8XyVXHpGpSRXn8YyW5buJ
X-Gm-Gg: AY/fxX4PRudZxGrc/spLmig/CckmCM9JJGnIjeAYyR9zKGpjHwrSuzy14ompyZbPTha
	3DC7gEHySfarQrG2gE9/8vyvTWUrYbQjYzr0zqqjiuYYtKFGZe0B16H2UPiBszXr6Byo7cF2QBR
	ptLIoPQZrz+b9JO7tI/DY5VqQp5flpzo844CYLGMUax5MrFpKkNfSeBotIpAvpgv/H8Qv3oba/B
	1vWjUHbHLecFxF//wlQ7cnCudyx2H/FMXgMlUD0+9SKmaQDzpjU49vFAep4XfIm7vSM4Hg=
X-Received: by 2002:a05:622a:1aa0:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-502a2386e05mr553561cf.8.1768554534866; Fri, 16 Jan 2026
 01:08:54 -0800 (PST)
MIME-Version: 1.0
References: <20260114164322.787125-1-smostafa@google.com> <f3ab0156-3d7c-470d-9c1e-922195ea27af@linux.intel.com>
In-Reply-To: <f3ab0156-3d7c-470d-9c1e-922195ea27af@linux.intel.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Fri, 16 Jan 2026 09:08:42 +0000
X-Gm-Features: AZwV_QiM8_AWnP4if6nM9uRrMx7z-1pq157-8TMrLaAscPdc1UVyRJ2GSwTSnA8
Message-ID: <CAFgf54rVPaUgbouXWQkczCyFQvXkrei_x6FYY6n1X5NkSSwYfA@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com, 
	rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 099B940008
X-Stat-Signature: c7rqjkstoa9mpa8xa34efht4c48ixy3g
X-Rspam-User: 
X-HE-Tag: 1768554535-458901
X-HE-Meta: U2FsdGVkX1/9jFEaSSZDgji2KkhN7ruX1dUVjkWQ0LL14IPsTZav2iaEP47R4ruDF+xd4SREtwtAWpJoFkqGn4QMSLW+kLZQq7l5nKRYowXYYGk3OEsFay2ZN9CE4usBF+cUAbXqJGwY6OkeOwKcoAwOXzQ3SmRtqDBQ90kshnNePbe70DI9GBaULVpc7XMQLe56IgdpG1RNCgzJ6KfR03NUUNMwLFfRKni95BjI/gKOpjHkKPThCwxWeFgPITo0ozG0BTDu/P+uuHkJc6EgvumQ4Z++oNEO9VxSHuFtjMdxBlwmTRz328g7mlqxpaV0HGjVNQrNPBgF0Z9PjymbmDRLkN7yStFr1jB1wMRDsgi89kMN8zdiVx+jtv6QuPqZxJtiaPgmwOz1zLEDvWe3SLyAhCEwSftKXifBYJOMZUgt13cUP90CYs2nfq2AOW2aVRhQucFbfPCNyj9JxURwLSlww9FUZEYLEiVttYwBzRvVr4/FAIClKIs/cgBWRkmVVh5udptthj41clfgiqCIeKsQwkwNM8nuGN9CuWjOw9mXv8xQuonQbK0ypMClhhzJ5A/lUEWdih4IByolIkSp+IoHEtdKSPrJ8kCFgaTURfSaOyM/TY2xtCZ1NTq4q/42EDh8VodnbYVSc59g7WaAfxSeSDXtuoFF1/KRe8sdLJqeuY6FCPmN4J82udzCMBgIIM7fQDPTGhYPohUiAuj7dvrtuIfr7sEwZGBnrXNBk3mgjE5LBZuougBhYfsxmvHnR2RSsCVvcZ4JQV1GrflG8Czs6zLWjJCm+6A3u4YTE3Ljk233NrFWkznjq0ORz3sgu77P7Q9+fj+UWB1qiKhwlqkB3I5G3l9/Ra+oFoMOe8OgxJ3yVIiqyQ0I+BXJgn+e7lNlxT+VUGPZ3JFISm35QO1Bkr/DH2N0M9GA4EXejZ8jWAeqhCEh/0Fw6mm9saYvKgjIhiHBv0HDUwy7qWg
 p8R3tMRA
 jGEIkiZjUbNgF3+LQFPhLPF+HRXeXxqQ6LZ7yr7V0BUggTnvmLa/Z16hjd2d0JfGD/g1mZy4Ph3LIlOfXhRYeI0bV9fYXIW9she/FV65O1OcX7gjJSWpRb8PCGvyND1iDckJvpoIWbU2zWa5NiuDOsAS+N9ftyvj5ggrR22MoDrLqFyRvm1LIJYbeUdVCIgcW/TT38+XfpwURiDYZtDAeC33+96oeHAJAO7+n+a7QZZ0+uDBgyq9tAHfk0Zl97XaNQxMjMr4kL0HkVVSw9FbD40eVl/pAQHZ/58viTweJOnVrDraQzN7qIH0RypuU1V3/lxvZUarBD+3ye99KQA0fBH7CSzqolWxxME75
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000034, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry I was travelling all day yesterday. I see Jorg hasn't done the
pull request yet, so I was hoping we can still change it.
But I can send the fix separately also.

Thanks,
Mostafa



On Thu, Jan 15, 2026 at 6:15=E2=80=AFAM Baolu Lu <baolu.lu@linux.intel.com>=
 wrote:
>
> On 1/15/26 00:43, Mostafa Saleh wrote:
> > Changes in v7:
> > v6:https://lore.kernel.org/linux-iommu/20260109171805.901995-1-
> > smostafa@google.com/
> > - Add a new function page_ext_get_phys() and use it instead of
> >    pfn_valid() + phys_to_page().
> > - Drop R-bs on patch 4.
>
> This series has been applied. If you have any further fixups, it's
> better to submit them as follow-up patches.
>
> Thanks,
> baolu

