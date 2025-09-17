Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A35D6CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E650E8E000B; Tue, 16 Sep 2025 23:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25178E0001; Tue, 16 Sep 2025 23:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B188E000B; Tue, 16 Sep 2025 23:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C14848E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:54:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 689B1C03A2
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:54:12 +0000 (UTC)
X-FDA: 83897374344.19.F8C180D
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8857714000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:54:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gjnrL0sj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758081250; a=rsa-sha256;
	cv=none;
	b=FP080pUBUZ2IkX94aH8Yy8unG+TzgNc2OTG7izDhisOOl9PIg2qIbeukPNHMocvUVQArjo
	YBmzZ9jBWMtTIi86UuUKlQryEV832S+0hqBRnLqi4moSYdNiIpnFY9Sj4bMU0x+cduXUuz
	GCGYCE64wm6rNUvCVyW/lRGeU9Ath9M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gjnrL0sj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758081250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0QwMkAAX/U3GVYuIcwJivoYCBq4VWe1sqX6AUImt4s=;
	b=gXPlJTFtbh2up5AVM9awDL8es1s29fy79m0gEywFDWN3Pe1nYyfjY16R7alVRDqrL9/Ff9
	GreJJJrjAIL1/Ht1dsToRRzDVPUk8ri7Yp7NigbIxIVAK3gzdu7rMPLf6dicBOKFktlumg
	S1T1kbOyUqJtPYtGWk8kMOeD/OGc2iE=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-62f1987d547so4247358a12.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758081249; x=1758686049; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0QwMkAAX/U3GVYuIcwJivoYCBq4VWe1sqX6AUImt4s=;
        b=gjnrL0sjMP0pe2rYsWNR9ksmh4S4l6eYEgnBUStIuAjugKYkR4r45QypwUvccDh1yP
         C2f2jjiDHNo3l4hYLus+XaYHjehwMtUmcbk1+4ox8WdPfzyO1hsI9yadBizLG0gfepBE
         SETnaqFT6uAQBxMFFVan0pKuJIVngHv5R6EXxWw9Ttsnv9WATOTWsiXzcPQyc5XBjpR9
         AzLWr++Hb0QvTpTMJ0ZWIYqwBQXNGaPKSrUSmITVJI1XR8ItzjvP09Oyg1o79ew0sRlb
         BrMHfh/cZEw/aLZTMKQz0eVIJgs4mtnAPp2ttPdUdSrfOL54pbZDSxoVmjHyZ8XCSnVC
         we0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758081249; x=1758686049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L0QwMkAAX/U3GVYuIcwJivoYCBq4VWe1sqX6AUImt4s=;
        b=UtsWVlI8nloU8jbhlrWDWjMS68DKoVL/r3/CIXpEFX8aUT08Qm4HJJ2B/p73pmWsnE
         Et+f9E9gf/CiiUrS6UxTkK4FF53TyjIIg6a6H8B/ohpltkH7slFMbBwzQOSm7gy9NIWB
         UYtuK8vhIgkPBGjhtWTwUrJSodML/nNjbI3DM6sNIb58b6AoVK0O2cAAbuSxAovdXQl9
         dWkdGuiSw5bExyO5vW4qIAfxKY6DIjGazAPLBw2+w4hH/Q5hQyKkiXUSElMGPypr95Wj
         jmy+5LQWGwC8eVvnAmWR79XHxPBaUgayLtx/zOQFuyxaitfrSKXiJJlCBmLU7OGr4o6I
         WzlQ==
X-Gm-Message-State: AOJu0YyEVU69bozq3FLxDvgLPCcmgt062VAgTGxqk579SqrFTLnCauYh
	m2s6wJDfk9LqHhTvLzf1+9VwrGIVwBGTNy+G49RWaaKvq2dEt96JYcsvmujxte7Oh3mxwCUH9Sk
	l9YzXYt40qSoexsSOV+QlKZ3y/jd4osQ=
X-Gm-Gg: ASbGnctPoazrmamecwT9+FuId2NkX/5VfBVISP6jymlmhJ1uAuYkRvSXYhUTkjT4Wpl
	EGV5iEfBL6N1MAXBBbtTePmaUD5nSPl6ubXxKFVdnb2c4TbuI2BFfXoJqCpACQjCPj/dT1gkOZF
	cslOmqp9AFOFhuHwXcq9irtTCq1Ljix3C3mwxGD6rlcP48Lw9REQ4Yk43xXGeyxYx3jt3mvEFuj
	JWgIWsT4X8=
X-Google-Smtp-Source: AGHT+IGhRbEhR4Oo2vBtn2h/CPfWnxXTyRl5ODWLuAjQjfM1dwrXBEVwTAXFoqpp4dj/i/oD+7ds9W6OZF+WhV/3FVI=
X-Received: by 2002:a05:6402:52c3:b0:61c:7090:c7de with SMTP id
 4fb4d7f45d1cf-62f84222764mr901341a12.13.1758081248924; Tue, 16 Sep 2025
 20:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <99f57a96-611a-b6be-fe00-3ac785154d1c@google.com>
In-Reply-To: <99f57a96-611a-b6be-fe00-3ac785154d1c@google.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 17 Sep 2025 11:53:32 +0800
X-Gm-Features: AS18NWDLbQi2oDznlq4BBqwefgqt9eAxrqURM48ErVF0viZ-1CzrWKG884E532I
Message-ID: <CAMgjq7Dx51gPWfE0eobNQBtMzUDwxuaZrrSDW=q2CsVqBamRZA@mail.gmail.com>
Subject: Re: [PATCH v4 00/15] mm, swap: introduce swap table as swap cache
 (phase I)
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8857714000C
X-Stat-Signature: b8ukfdhmnuriz3qjsrnpcey6fu5beaws
X-Rspam-User: 
X-HE-Tag: 1758081250-566811
X-HE-Meta: U2FsdGVkX1+a6J9ZHLSApWkj7tESpcDo3pLjINp6JwK5oe7qKWbFAklWts9Ko1ZKGqUlyD7yg9T2VcUeRQOtndsJlZpjrMZk3mfOmPsn0apNworTYsGU4AICk0GdUFLgbutksTXhgzemUQ/KxOYyr2WLyUngRtLw0ESt7NU7d65zGWCc176msUXgKotOkwgLZHhT6tiIBJWlfX/cyRBV66ksO/NfBF9BVheLFxaJ0oxzjvpfLTS4JEUF4d0N8ZGTdiL9Lz31CWJg+zglj500WM8BRJydbF8FZgZKWWQROriTItcEjqcB2+f9IKLlKr21KlG7Uy2EYijCrVjRh1pMMtO4zglZOoCa6AN+Euv+Z8zJ+u3Hm88qWKnNiv9Tj7kTiw4Mp52pbLfeFfdFAx8MapAJEFIFOEPd9i+45nHFNAFGY6JFr7d0jQktfSf7kzIC0IJElZbS3BXvN/QjVBva8pZqfUDpoNmlUpFnzmri27NUhwZBO3ADGK2sz+cJg4rg0/ElivBPd53gK6k2usJHSo+SmrqfdcF4dLbxjd+6UHCIQqAZ4dRA14kps+JMBh8BO+DibYs8hXqErJdqMqCWIxWWZdlsWHn/2V4bvB5u1nm5+sREDoFTd7kBDDrdiLZNVnIq8audAbs091A75Z8hn3alT6G+i+U9G+VO39UyaAmhgPNC6+gczwsb4FvvNyb3vWu9oO69xQcIAWJvTD9KOGJ0ymBhTkJfuk4skPheMp1HTcFhOTO7Eq78ZMTCQilwClGSL93j5UaEf0HAHpOHlZQk+kA8/ZAmc0cRFKtSsBYXGtC0XU2o7B1sxpNhn6Px1hUNK9pjlt02SkW9r/OC4UuBbsVcR0zcDrCPhNdAiQFtVdq16eayIqR8Qcgl8iassAGoYwG7b5FQyPhE18EZCWBzueLs3er5Vb7O2QpW8d6bT0f+vCSTBGCX2Y/a5Z2bTwUfSSfqE8veIiO09zU
 foZNLZcV
 RXWzahev5ryvQcw0RFQrgGl+SZ0iLmjOtV07qz2Z6kXkCRK/bP5nDAkXUWP4knc0DAegzmm8xG47WYmiRmxUgL7pNYPfrBd0+z8lQCLgVCwiqcyv3At28tAhTthXu9dw4rdb9iV8Z8SZgxrOFKpynWzDsIuwW9YMB6fZmTnhj+s8MetRuQestnohuqs2FikTawL2NC/WBSPHElxw2Qmr8Dd3n7wUHq6iB3h4iOqjO9j66g0Pwj/Tfbyj9nUQMbTgoU6mmeEsAogJJqriISPHeOAgr7/xDVsSVUjNBEIsP2aa7kS45SP3tLl894iSIPBPDNe56CAVFtdt34lg+hv/C3mJdv8AgjaU79QsXlvpOVAQioY8kZn9pOvYT9pq2nbeP96NrqFIXS3qGBwV46GeBwInLdLEPcDdmUd8/3Sh+uWPc1rk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 5:23=E2=80=AFAM Hugh Dickins <hughd@google.com> wro=
te:
>
> On Wed, 17 Sep 2025, Kairui Song wrote:
> > V4 changes:
> > - Patch 14: fix potential cluster leak when attemp a sleep allocation o=
f
> >   swap table: Just remove the logic that check and return the percpu
> >   cluster, it was trying to avoid fragmentation, which wasn't very
> >   successfully and may not work at all if there are multiple devices.
> >   The fragmentation is not a serious issue and given the chance of
> >   hitting that race is extremely low, let's just ignore that [ Chris Me=
son ].
>
> And in Patch 11 I can see that you've made an important fix to the
> !folio_ref_freeze() block in __folio_migrate_mapping(): there had been a
> swap_cluster_unlock(ci) which you've fixed to swap_cluster_unlock_irq(ci)=
:
> I was going to report that, with the WARNING and "BUG: sleeping function"=
s
> it caused, but you're ahead of me.

Oh thanks for pointing that out, I fixed that some time ago and forgot
to include it in the change log.

>
> Thanks also for fixing the shmem_replace_folio() locking and stats
> update, which I'd noticed too (but never hit): looks good now.
>
> Hugh
>
> > - Patch 8 & 9: move some changes from Patch 9 to Patch 8 to avoid build
> >   error, no code change. [ Baolin Wang ]
> > - Patch 9: Fix locking section issue, should protect the shmem statisti=
c
> >   update with spin lock irq. Also fix an warn on condition.
> > Link to V3:
> > - https://lore.kernel.org/linux-mm/20250910160833.3464-1-ryncsn@gmail.c=
om/

