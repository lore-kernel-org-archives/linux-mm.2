Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3216CAC5BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 02:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6368E0007; Sat, 27 Sep 2025 22:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66B58E0001; Sat, 27 Sep 2025 22:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55CF8E0007; Sat, 27 Sep 2025 22:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2A9C8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 22:14:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8EC811DFFDC
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:14:18 +0000 (UTC)
X-FDA: 83937039396.05.3DFFEB7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6C86A14000B
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:14:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U8sNe1ax;
	spf=pass (imf26.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759025656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwDr3PouvP/EeDq2K4EHSkDIu+fg6YmrhdjsgwEyJh4=;
	b=qQ7fTcKny4cKKkInz5ptzpaZBV0rGOf8yGzYWCASkLxMSWq8U4j8nTize0cm329KryKXbG
	DBMartAYqxJrBeuFLoY/KsuuOs4lf0M8MLzkODuGf/GYhXdmz7QiZqF2boELqtSwV+PYEJ
	6QFs0c2dU9DtFuHtP9DsL51GhbCYt7k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759025656; a=rsa-sha256;
	cv=none;
	b=uf163SQHRGJBZuoejGwDAoJ3nt6BEFI2qMrAIkip1+zQ5IG2xhsBRcrAxzjAeXX8UDE22D
	kJ2lxsdFlfkdPtsrDnqv2cUqU7YflSIybR1tVAhP8+aBJI+sFYaSJf1GyHhe8i9OF+EjZo
	yQK982oYcgqiDy6Bm7AZNLDOQ5Tsnb8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U8sNe1ax;
	spf=pass (imf26.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759025655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bwDr3PouvP/EeDq2K4EHSkDIu+fg6YmrhdjsgwEyJh4=;
	b=U8sNe1axXOXEeEILiV7KOCnesK/kzCBpUNx1Fm0HEMyXJuoPHz8tp4kqisSY40V1LEC9d9
	3TpFbfgj0K8mrDb/Z3CkhydDwKxlWlxyoLumXIKvjer0b27QtxgL/3J5GbfhjM+GhJ5Mdf
	zb8Yr+7igf0dvlAqLjola5AC0AY0ztI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-344-8bPjHn8APVeOhiWxnx4G3w-1; Sat,
 27 Sep 2025 22:14:12 -0400
X-MC-Unique: 8bPjHn8APVeOhiWxnx4G3w-1
X-Mimecast-MFC-AGG-ID: 8bPjHn8APVeOhiWxnx4G3w_1759025651
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29E0B1800366;
	Sun, 28 Sep 2025 02:14:10 +0000 (UTC)
Received: from localhost (unknown [10.72.112.162])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5C931956056;
	Sun, 28 Sep 2025 02:14:07 +0000 (UTC)
Date: Sun, 28 Sep 2025 10:14:03 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	YoungJun Park <youngjun.park@lge.com>
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNiZ68Cv/XytUNHY@fedora>
References: <20250924091746.146461-1-bhe@redhat.com>
 <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
 <aNShH7WWxuBEvIuh@MiWiFi-R3L-srv>
 <CACePvbU485gPMEvBeK2CN4Ept-zS3ZYXfcVC8Fbk83saX_2dzQ@mail.gmail.com>
 <aNaxvEiMgh+EqGjt@fedora>
 <CACePvbUusk1D_=bTuzB_brDNgpgmbbKUxr1fXD-EExGp=A_=dw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbUusk1D_=bTuzB_brDNgpgmbbKUxr1fXD-EExGp=A_=dw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I-qULwOJIeSe35ggakax8h3Bs0hdz4NnK_5Rj8fCgbc_1759025651
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C86A14000B
X-Stat-Signature: d8yd45gwp7em7bck1aoesztw5h5xeiok
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759025656-417529
X-HE-Meta: U2FsdGVkX1/eR3aZEJ9svi5pIQVRwD3YHH+SztMQ5kyDAQRZhvarNQeWVTC9i/oAIHh9ep/e3sD4zy8YpNm7+y6KFRsAb4jua00zLVidbFPuN+bbxZH8rdL+eqRL0qqxvCIqgpUSzfX5hod1CjhyAy0C3tdTtqkwP304vny+cAsTCpgm1d1a/BIS18O+0eS6E/UP6f6xC+qKsXxHuWUXxhPJCwdkLJno34739RROf/xh46ZZCOrK+CZLERS60JOn3SH8Vw62qsu4ClNq+ybUtsvwiYxy2bWqy9g66y0M7bOx2LqAa0qExvfwdvfWOKGozu7jiKultJhmo6Cuerl5o0T+D95a07T+apAAZCBVUDjB1p68073Ex+obwBJLoW0mrXkgEOVi1lel9kLa41HU67Un4EY+jRH0NuRWC4OcTgv/DGiCcIcT5uLDcSzybc60N/zEGGm84cTzrLwAfUvjtkpb31HNeopp67sD2QQKM1yplQsAo4wqRu2XidZG7d4UfJFxQJ2hEYeXXXJ7Ji7cv37oZWxYR8W7soTErxUaQLFf5hPlWKJNjGvmqEDeZJUFxt9Mw3ZOoCjhyGaRLlPdbowJJX/FkdD2/dEJgJ1QSzNFVnVo3KE5IfbY+xrj59MpZ68AzqLejNmKdq/wLiZ316AmPs52JU3v8XxuHwY/2fNKWdXYWPyGgAy5aJGL/7B7R292TTsl5y88hTMSb7o0JwQUCjgOqvkymSEA6OZm9fE+j50RyfuxggkTThCE6WBD1lrrws2e2bAi/DUpf5yjUyTSP8xk7C4sb5xcnr6WljlTBfSvKKYhj5izRyp5YNcT3F/inIYxinLhX1QNKYw+px8YTQjpgOSgAaVE3KTEIOIG88qixdccuGAbfJ/+/o/+0acynm3aSxBLaEvVv7HCfnoW1iwfGXFy8kl/FG4VTiNpOwo67oz9X7V1Hu4rBgo8+xcR7SKJUlLsCKOTHrQ
 FZF7WTXJ
 EeAnEjtxmK7WhZsCytDD+ZrAIW5zSU3s9Tz4n/ieu9VjDLtc6NZALTHaR35TI507lSethan9Ph2AsFxf3qXVyzX677qtGZwUSQD/GKh7pBugxkiG00tSNExdEeuFUjUdXC+85qCxJdabfx3W+EsNHSff6nlqug9Q2NhUj+mu/FOo8UWYHJRphT5GzsvWoxP2L3pApCeUybBoqXzHWWXzAlqwrSMbQ8yIHoytp57ZO31yOEpR9+d2v82s2NctGi72SssVzHrHuOR3P0A5wcXf7ZiKlnUOjZt3MnsSudfEo+KaDgzi0ZIlwT8nBS2P9fpyqluh2gqKWnFlm4vSqXmbuLKxPt5EwPEUXtzWlhzK1zaqNrr0sjxaURuiTAkNR7ERBb4+Exs5wgLSOH6YGIyIBe/jYIm53CxpLe4BEGTp3F8mCHpF/b2X+ErODAkgPIaAa/uwEHhmCk/6c/Lc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/26/25 at 09:46pm, Chris Li wrote:
> On Fri, Sep 26, 2025 at 8:31 AM Baoquan He <bhe@redhat.com> wrote:
> > On 09/25/25 at 11:25am, Chris Li wrote:
> > > Just curious, is setting to "-1" matches to kernel behavior before
> > > a2468cc9bfdf, if not what is the behavior before a2468cc9bfdf.
> >
> > It should be like below. It's not a real output, I made the data to show
> > what it looks like.
> >
> > # swapon
> > NAME       TYPE      SIZE  USED PRIO
> > /dev/zram0 partition  16G 15.8G   -1
> > /dev/zram1 partition  16G    0B   -2
> > /dev/zram2 partition  16G    0B   -3
> > /dev/zram3 partition  16G    0B   -4
> >
> > I just apply this patch and set the priority to emulate the kerel
> > behavirour before a2468cc9bfdf. In kernel before a2468cc9bfdf, it sets
> > priority to swap device from -1 downwards. There's only one
> > swap_avail_head plist for all CPUs. The behaviour is very much like below:
> >
> > [root@hp-dl385g10-03 ~]# swapon
> > NAME       TYPE      SIZE  USED PRIO
> > /dev/zram0 partition  16G    0B    0
> > /dev/zram1 partition  16G    0B    1
> > /dev/zram2 partition  16G    0B    2
> > /dev/zram3 partition  16G 14.3G    3
> 
> I see, in that case it is not a simple revert. It is revert plus a
> change to make the default to use round robin. I suggest you split the
> patch into two parts, one is the conceptual clean revert, back to the
> pre a2468cc9bfdf without behavior change. Then the second one is
> changed to the round robin. That will make your behavior change more
> obvious.

Make senses, I will make v3 to split it.

> 
> I suspect that even pre a2468cc9bfdf, the round robin might outperform
> per node priority already. Which means there exists a much simpler
> solution all alone. Even though I am curious, I am not demanding the
> answer from you. Your test data against the latest kernel, which shows
> great performance improvement is good enough. We don't have to test
> that really old kernel.

Yeah, I agree. Just nobody realize it then.


