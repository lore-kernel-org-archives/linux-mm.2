Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50A1DCD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 11:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87746B0005; Sat, 30 May 2026 07:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E380E6B0088; Sat, 30 May 2026 07:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26906B008A; Sat, 30 May 2026 07:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2B396B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 07:28:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4953A40315
	for <linux-mm@kvack.org>; Sat, 30 May 2026 11:28:27 +0000 (UTC)
X-FDA: 84823863054.16.C9DC6CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48028C0009
	for <linux-mm@kvack.org>; Sat, 30 May 2026 11:28:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDIWChJZ;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780140505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sq2iLDCXi6pDren51u1cQUzgAX9nwmLUuBb8+qFvt4c=;
	b=T1KuQuuBMZxw3o9Uhmta+dv6I5DSLoiNW7eYGjeMKzJIYVM09RceROCktU/6BkaM/myLQO
	gbEJpYbWKj3Gn9/ejPgZnBrbZ4FHHw5qSjcVTORbKpImlnc8Jzc/M1pVrynMxz4nae6l34
	9EA+IFUnjJ8k2svtWsSGzlrhjgj25/Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780140505; a=rsa-sha256;
	cv=none;
	b=v9e84nQKBsajetdeF0SLRAEYZf4O18vV+YqnJ5a0goBg75PNwOg1sHRtsgPHHJNOdsRHY8
	2zF2vyl2dL86AMoQ6ES7dwx8zh3E98D1wOpfhJM9SPpoWAGTRuqhT6EaYWSL2nsmacwN43
	o8gV5k1j6DMZAO7qdAKTC3RJZeVh7Xg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDIWChJZ;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40D4A44117
	for <linux-mm@kvack.org>; Sat, 30 May 2026 11:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240C31F0089A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 11:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780140504;
	bh=sq2iLDCXi6pDren51u1cQUzgAX9nwmLUuBb8+qFvt4c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JDIWChJZ5HBvxKRLY86aQ4mCtPB3mchD3+6j9CO4V3Zfldriy00F20T5l3/KrTzEY
	 4iR2RT0/j4sFVS1dQZ/Kbkfjh+fEolP841WKNsjUJFg8pH7aW7wVjF2094d8vdd0yT
	 HfLx9I2ayMHn6z3e0AlbCQldDW0lN2gN+c90HvIUP+7aJ7IsKwQGIOKBSeqTjRsoBI
	 ko7ERB7kigumw4pkHRSD43tDFRqmRP5JBD5hbwk+j2P9SMScEXjdbJq2rCbpw0pIli
	 7OftayBRqrL6XlN3WhscSpvzvxc1T1f7oK8QNIhax3GHkFLgbDcsu2J8qGGruoUQ+p
	 p14DeXvsONWtg==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8c9166b26b4so171046186d6.0
        for <linux-mm@kvack.org>; Sat, 30 May 2026 04:28:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ96HNOpbHyOMn2YP3D/PNltPYI9k4WTWa80j95ma4vbokbId08djFyEFbb/Ab+6+YPCjMrHObFNYg==@kvack.org
X-Gm-Message-State: AOJu0Yz3cuXECQ/Dleqd29xVnfpdTW9qAz+ndQT/W2Y2aTRJh8FFYHSQ
	dSPXfyxuZ4JuUEYCBVfQx7CxaJhD4CebWXiTDdPECb15IvD0i9p1scLnlz03+buy1F+xWZnIlZh
	Zx+onVV7g8bu99HgFsVRdH+wJLiT8hSY=
X-Received: by 2002:a05:620a:45aa:b0:914:c246:ac9d with SMTP id
 af79cd13be357-9153d9f76eamr544656885a.28.1780140503550; Sat, 30 May 2026
 04:28:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260527110147.17815-1-tao.wangtao@honor.com> <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com> <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <87qzmu2r0t.fsf@trenco.lwn.net> <ahmzXSN_sQYmq2Jp@lucifer>
In-Reply-To: <ahmzXSN_sQYmq2Jp@lucifer>
From: Barry Song <baohua@kernel.org>
Date: Sat, 30 May 2026 19:28:12 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yDek3neUQ_Le8nWr1XA7YrqZDKXZJX+u5f9kvv9=d0vQ@mail.gmail.com>
X-Gm-Features: AVHnY4LYmPGlt-SyUQzP7ovTfzzfgSTVLh1_UKbg7JbyXYbDT08n9Dn5EUIKOuU
Message-ID: <CAGsJ_4yDek3neUQ_Le8nWr1XA7YrqZDKXZJX+u5f9kvv9=d0vQ@mail.gmail.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma creation
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, wangtao <tao.wangtao@honor.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "harry@kernel.org" <harry@kernel.org>, 
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>, 
	wangzicheng <wangzicheng@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: wm7spefxeyomoun366acef5gp7fxfq86
X-Rspamd-Queue-Id: 48028C0009
X-Rspam-User: 
X-HE-Tag: 1780140505-173436
X-HE-Meta: U2FsdGVkX198B19aBuJ2XxIN0Ly7wyxBqQH2r9Mfpm45Acp3Gy03Px0pCqWfB6p26FSroQ8SIYW/hqRRRNsA1Wx89D32/rHIRBBA/zS/WhvfGVZsy63Sl1kYvRnZXjHuRGOfzunj34mN7pS+e+3nGLORMQpKU2qNQeGbypmpiR3iOa2Ch2e4yd6VRvSd5MFHJBV8MGuINuSD/DSYFHCWrYP06G7efIjQXat7XtuXXWuaYyyc9spPNPgMiXnOo/XDW/GC7KOLGAen852stP7Zrlx436pIP4rg0IsAVoHA26fVOIVhavmFbJoWdQV9/VIeynE2umxVBNSukRRfB8pIL7X15TC0htYMpfE/GEP06amB3dBKKQ92KwCnlOApL8tiIj+j8bNxIgIgt1OMSXbXXlJCJuuTEWKTSe0RHPM6EWJqHi7Ohr8ubtCdNnSTw+Z5KJlhlXV9ltsCFiXUfsc+PYLC3IjAX5Eqx+eQ/62Ns6pHiBVc8feGsKsd0JUNtWstCF0JYphZmsrcfZt8C/uUBkah4RAy7BP+V23MRNiK1SjJ1i+nm0YLi3Zd/dKKvxWJmaSP8LfXwucNKdLUYOkBo8wHsa9J/QsawD97YVx/yANuTJZckBJ1kOHZambO21Z/hp58179ET01h6jOO46PZZW8guV/ndAtgb/rm0yTOS0tRMRGhSWSyf8zIsqK+cL81wGmsr3tBibhF3W0GmttV2eOXdFEcyJKzk7U781+0QGKi1uWlnhtQ8ygMF07wRFFBijz22+GMAS3aGuSEgqQgbzc+Fa46QHAC5Dt9BDe30BJ+J4KxmX/bq0XRUBBdBpaxgyNEWNsEPOFT4gIp3nZYXEnfz08yj4ZD7wyQxZbrKoZsBGR5ZfX+O/aiYV5ak15oDgRTPn5G5GpxOF+RvXsJfpuFaTfC4Pj6KOsz8sahi60RnZycsZ+wt5z6B/7k8cRGqvLZei46iMVcvddCNC6
 DJKKA/x/
 gWK8Cng5PhyDB1YhhqVjPQp1tB3vGntcmIbX6ykf/I0LrGejzGcXWjGGS26EV/f+BV8+YmU6RQ+seZujrDgv1LyGP3dFy/7m+vsOjC4ALjL5Cvy7A8aDsA4CAEwo2HnR+CAbVRel5ulL0aYOg2lRTB6sgwnK4Iie8pkt7gMeMCBFGy1LUXAqjKKcNfXPLcwwhhpFSa0jpodyFPUJ8DH/9T1XCQvdCL9qxedpVpFu4rYawxWDYEjm2yndJUYpqODWzKqgGVJfvdIrxBYncEtSfGD6OsVkTjsMHTw+1yv76JGV6ewCE76fIjpFzAWXtzoP9fG5F6hXQDWx9Qdq9baLVIi97ExBGSZnKhQumYmxVcXnRkea3FRfRH0X/BkFW7bNKYzFRqT/ehnNnWpuG53KskAZhZUGC/KyqtkO3ApiX7KobyngcSXbCTp/ad5wajnSr0fbKP/k11B9Qy9hr1VgIswejMCBvbVcxnwhHzv5OkpJRC997TccuHsY4Pa0wBq7T+9DAw1Ye4lcMdP7CRco4ZCLGuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 11:40=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> w=
rote:
>
> On Fri, May 29, 2026 at 09:07:30AM -0600, Jonathan Corbet wrote:
> > Barry Song <baohua@kernel.org> writes:
> >
> > > After coming back from Zagreb, I kept trying to find one or
> > > two full days to read Lorenzo's code and slides carefully and
> > > write a blog about them. Unfortunately, I have been completely
> > > busy with other work. Sigh... we always seem to have too many
> > > non-upstream tasks.
> > >
> > > If possible, I'd really appreciate it if you could take a
> > > deep dive into it and write a detailed blog post. I'd be
> > > very eager to read it and better understand the overall design.
> > > Otherwise, I'll try to find some time next week or later to
> > > go through it myself.
> >
> > It's still somewhat superficial, but in case it's helpful:
> >
> >   https://lwn.net/Articles/1072378/
> >
>
> I found it to be great as usual :)

+1
Thanks very much, Jon. That's really helpful.

>
> > jon
>
> Cheers, Lorenzo

Best Regards
Barry

