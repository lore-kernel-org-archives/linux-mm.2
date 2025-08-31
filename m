Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 883C0CA0FFE
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 01:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4DF28E0003; Sat, 30 Aug 2025 21:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C257D8E0001; Sat, 30 Aug 2025 21:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62BC8E0003; Sat, 30 Aug 2025 21:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A15C08E0001
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 21:49:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E9F81402EF
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:49:44 +0000 (UTC)
X-FDA: 83835371088.07.BE36645
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC29840008
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:49:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SN5qq5iZ;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756604982; a=rsa-sha256;
	cv=none;
	b=xdg7Exk4JEfHTXSEcQX6aMvsjqVchsJTKPrOXE4W9ncvoxuBCpbi7ddDum+wkcMniZMLOE
	eu6rsqUSVVhnGugs1zjPEilzgPPDgm627/vWvSnFwwTDNDLbRrukrpO0wh+2kUexEmESbb
	Gf2zsYcULM2VrhVg1blJVHDAO0o1tt8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SN5qq5iZ;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756604982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31VnAyapDpQQI+9YcKDIbsUSiZBFeZITTH0aqjqPoIk=;
	b=SVICL0OXvlx/QraWq0HGZz0D3BDiUSyelgi/u5XECNYQeDi+PHZOl7d86Xt1mJPcx9sp6x
	YMSEvbQAZS5TrOt48dY+DdJvyK9hJ2bbmuyN52Z/AGXO7AAdUQDHaadsxkVQTZrFGymEmR
	LaJov9SeZn49S7cBQZk6IOZoUsrEtWc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A590E44BDD;
	Sun, 31 Aug 2025 01:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16588C4CEEB;
	Sun, 31 Aug 2025 01:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756604981;
	bh=VoenFyvbohpUvKigw6ID2nFxRK7fJ77AkbwwQZiefYc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SN5qq5iZGhL8d6JW+tDzB7sLsQgImyZlSEgfpbTAufAVhtcS9bkeRaOHsF3+N6WIb
	 9r8hyd0HFAY0wagAa1iTzGvx06N4NMZgkf7gEMMgGxpQp8K8o4UkY1BlNEoDuathSN
	 ufql9NV+PtwWjX5VDtdfAB2e1sWySzeB0p9emUKQ=
Date: Sat, 30 Aug 2025 18:49:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, david@redhat.com,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 05/12] mm/oom_kill: add `const` to pointer parameter
Message-Id: <20250830184940.5d83cdda762c849cf74d9dcc@linux-foundation.org>
In-Reply-To: <CAKPOu+9MBokh6z2o8=GKwTeU61Ce8Pbs7zjTSxo9=d+vKCYZWw@mail.gmail.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
	<20250829183159.2223948-6-max.kellermann@ionos.com>
	<aLIxs1cFhneGU5D9@fedora>
	<CAKPOu+9MBokh6z2o8=GKwTeU61Ce8Pbs7zjTSxo9=d+vKCYZWw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC29840008
X-Stat-Signature: pkuxs4mqia76a1jcjsn57pgaqpsoosyw
X-Rspam-User: 
X-HE-Tag: 1756604982-583253
X-HE-Meta: U2FsdGVkX1/2ilPMBATppUAmkJi+9Aq8K6eNkmSY08Jvep6VFXo7O9Qfj6Iuntmm/TG23rQ1ktcnDnWMDLb6amImyg/jCYU3W7MdpjefmY0+MCAuOkBORKFRrTy3npFSQHdxE+J2BFQ5bAYBt6PKXxL1NhKwrwnhYPAUWPlNB8KZruRZzo2XyjdJV7MR60abWbqe5VigTB41Hc+yuPUVOYfjrs3QnrvjNCjvynlT38dYV1SJ2wwAUoeOQaqaD0YpzeMYQMi8BUkgp3dhOr4EH2oMki5pP8FIIyaB7BYdYO9onFDJnPlnO1Ut0I4ck8t/9kC/0An0Ro8+xHyAYI4tTJku4PuG3bLrQIpwtAZjdkkc/I92+HnieMWYPa4+Owi4G30ugmpbtuJJeHHV7WHsGcy2QtnEDnHCURQAgv1UTXkGC359ha2Tg+Kb77huWK+wN7Ql9HiVmeNi+bWV3WA7BJFSnxt8ez9CcU5scQDnjw/jTGaqcKxprr2eWV9CVbWbtHGGEY489fMb+nPQYbDWlToVrUy1Cq5Soa6otV82thbE05dk6JOJ89GeCOLJKHX9PzIzS3UCt+q746HNtd/b00UYcw8sQQNzKtKqGZiaGDIrrefUZMsYlIvjYaoKeQKjX9vwC6lEv5E3FM2XRI/kdfdNanWvNAk6ZiOV8OXPY8ofGX15rkZf/293JkMyTnyXpYuRWsw38Pb9nuKOViZzrHjbDU114YOcPPMd0ctxKiP7IqUS8H1Ky2hQ4gEucKDJmjzB258ey+yWuQsXTnoxxG47mWpefEnRg/NwKuz9TmoiWKcBUVxyNMZrPxULvLKEYCdIdGzEy7CUCEjRIbePFBafvEbPo6R2/NyYe0g2h9Usv+gVNdvH8cUOS7DQ87y7tfhVYh3eu3CMdZvNAjNAc0fO3wb8/eQ0ccSni9N471D2fhTt+UVLgYHH/8rVhIyAhAv2WkFhNATHt9cHw+k
 ydXrE9oH
 pXZ+VIuMkuT9s0q4cljbhg5hEyBoLeRQHE4QEyT5TF6GPjRHjDHNmhd3eWZwVYCdB72G3EvvgrkUm1X279oT6vNDcaZcGDgkSR6xjZLLi9vlGbnU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 Aug 2025 08:26:07 +0200 Max Kellermann <max.kellermann@ionos.com> wrote:

> On Sat, Aug 30, 2025 at 1:03 AM Vishal Moola (Oracle)
> <vishal.moola@gmail.com> wrote:
> > > -extern bool process_shares_mm(struct task_struct *p, struct mm_struct *mm);
> > > +extern bool process_shares_mm(struct task_struct *p, const struct mm_struct *mm);
> >
> > Nowadays we're dropping the extern keyword.
> 
> I can do that - is it acceptable to do that in the same patch?

The culture is "ooh ooh ooh, you can't do two things in the same
patch".  My culture is well, gee, it's simple and obvious and makes the
kernel better, so I think we can handle it.


