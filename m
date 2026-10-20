Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B627606A332
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=RRJFNPT2
Received: by kanga.kvack.org (Postfix)
	id 571C26B04C6; Tue, 20 Oct 2026 09:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522726B04C8; Tue, 20 Oct 2026 09:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA8F6B04C9; Tue, 20 Oct 2026 09:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 120CB6B04C6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:13:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A2FA120185
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:13:08 +0000 (UTC)
X-FDA: 85343045256.27.EAEBA77
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F72B1A0009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:13:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RRJFNPT2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792501986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zm0NOGDk+3cS5Mg2C1v6yh0sZgFnVUEDDk4kvHgijW4=;
	b=2L7bL+/+dnsslcIHy8jSRu7tYy+E1Lx4WG8WNwux5rZJ4kLvkj1LklxkbnFpvo3pQ8gEwd
	sMp3IXoCz1mJdQfMbYw5VeEHtBr+csTGUeCHIuy9wPMbBX/GhYGxlib2CyDnfwMOVSUgRk
	6qOd6daSfB3my1I/uZI7Y7H2cWoDtcU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RRJFNPT2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792501986;
	b=c02iG2YMaZbEimdkRCbNg8jTnhNxmV3RWH5IMXbiTVEoCgPZrF1vwoc/OCjKlGGDW0TrbD
	HG8hJmqLO2KmZGk5npFPd7E6lmC3Nqr+BxYhyrMZhSmmn/Exsouc2s9bNcpB4E3oL2yrqb
	gl/pKtNwNGb686jE0cV2ZmKjxAzDtWU=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1e2957d7eso22824095e9.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:13:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792501985; cv=none;
        d=google.com; s=arc-20260327;
        b=RQRs2GbxEW6C0eSHS6n1mecwkd0n3o2zI0CDJej/oj6BmNFfa+6kOTmmE6nk4SVSvN
         EfseNuLDFAZ9z59/CsiSmoo9jMqaikaTu1ErKdhqfcH815t3OgluvMb13u/86MU25zSH
         mtanSEzNy/pu1d1JBcSCy+hiofGekF4Xv8xKBOKVw8ScqCrzbcDBkPd9TVB5YAkM9FgV
         DRQUcZRMaFhVx+VjMu1s8rWnm1B2Cn4e/0F9gkBgJiYs/jk4uvcZUdp2q5mUCpKsG41k
         0tpE/DrDc4YNflqboBowpG1/DMp511ukDVeoKLvLzpuMCHhu6KkplZTs8BWj/WbrYhvD
         oCBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zm0NOGDk+3cS5Mg2C1v6yh0sZgFnVUEDDk4kvHgijW4=;
        fh=zGW4ai1QPIGiQPhWoT8cI3OJH77AP30gQ6TsydWxWGg=;
        b=XGr9Zb+tDW9VqPOb/5ksL3tgqUz4H7DBKXa8hDrlPoMDzhX7useW9AJJzosZaoUDCC
         kdWNDdhioXva5iN0NQ0/zUYcJFZeZeUp9ZX6CL4XM7C0cVBWiLAGTEXetyzt30DrssGL
         6+9nMgpZZ4iOAR3/uO6xpaGwJqYdMwlvnThAS0USiHPJH3IuzG46H9y6X1PJktZwGm4i
         3YTLk/vlJFK7+XBsd/Q+qic2bV+dvZnmYoW/X7/zAQwjcgjAyCqxvRzZ4jVFtsLMN2nk
         U+6ckmH6vRMEj9edvQe3KkQxGSa3r8F/82FEa+RAg+VWX2JRLzqdd0l5EYBr7jL7WvM3
         w9kA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792501985; x=1793106785; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zm0NOGDk+3cS5Mg2C1v6yh0sZgFnVUEDDk4kvHgijW4=;
        b=RRJFNPT2DJuV5EXMH3a6DB5hQrcdGGAEuaTjd8pLfpmuksWnWj/BhcCt//c8AkkdfX
         FmX3OY4aRi2sdawjBcCfkyc8wDPqXSRHWUJIYE/c/UbeBSyzzttwzQxivXWY2b7Cd/7p
         0ua2oPibPyU8w/pejEkWaRfLy11AejUE5qwIybKseSbE9XfQCh8odwZdgukClMyoa2AO
         MSC9NflOhPJCnNXAMuypWZ3MaGpbsSwQ3F4JUO9oMXv6tVLXR/YmjfI/o3mQAeCL2/SV
         IH1AXhtgiHZgjmmm20r1MEvRH0Ma9DqOgyjnCur8d5u2mD1Ta24Rjv9YeH3qTWv6LBRi
         c2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792501985; x=1793106785;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zm0NOGDk+3cS5Mg2C1v6yh0sZgFnVUEDDk4kvHgijW4=;
        b=gJqYI4DIrTGSjqeAn58Is7qrazEaXEjI1ZmWY12ld1XoXCKvmEsVQt4eUZUwW4YGZd
         lNM4s9py7n5maklPCGE3JwP1REdlLEtshF7kixBMVEAgxg3vvMBrnLkeO4/8SPzc1CEj
         WCHhbJuzyd3zrsZ4XICi/qd6TspFmWj/wsCpMmCtQurjwkXRYQejD+AarFnCtTkaJye4
         avsLkvWfCTR2FEi8Y4JFL3zhqRHzBIXgD8uFBfp0+AjBwmz8djUkCsGOIX0t8wUSXnvo
         3rN0Vhug+2vhTRULoLpjlKdkLxWA9N9t5paIJ+La7TJpmXBxiFSTuAF70RMmFBlHgC+7
         a2xw==
X-Forwarded-Encrypted: i=1; AKwUvBwPJ9ON6pTCpTPby7mEOssaeaFcaFV5rj2916UYLQYh9JP/bXu2nbTwWjBEUvvJSCoZVrbGj5ZuPg==@kvack.org
X-Gm-Message-State: AFq9FYIwncPIBxuvU59lpq55mHOLSqeJC27QKwIFPy+3tb121JPJR6W1
	qrfdPhXFEThpt4bpC7ilmrh68wt2AUvAPd3s0diNCfEU2PXp6uEJoExybHA+oEed24Yc889wBly
	WXjzVkJZIuumON81lTIcb4m2N0SjY3vE=
X-Gm-Gg: AYBFou2UdtJN59/ag1Opk17PzhxF42xZoQgK7J3ifzJUexbxJio2po7d96RXslOKRt8
	lfEWwQelv06zKTk8ZGXx28K5jHiKevJC+UJAir0uUgH4fbVVMUDia66B+sqeBIAZ5XdZVUtlZIi
	1DAb+ZLSBzlYyJsIiOqD4plHIawSRQYaoEnj2Glu78McJExoScrnJu/NJuoake1RHO5JlxWLp37
	uh+MAl5itRmvGHEvAXN8DnpuH5ghyH2JWE1babin6ZIj40wVcs4Plynygv+VLAlarZh1Jt6D8HZ
	9riUePAaCXbG/RAabGREOiTnPL/Iv2TmObNrO2tbbVpN9YROQtrT5z5w9xSQ8vO0D4z+f9WYRnw
	//B6wHSw1/ZRdpte9e5TBTXapKmX+1UzUr3M9/F6BcZowT8uApqGr2hoQiIbjnwS5VE/pu1b5Qw
	cTxAZtPg==
X-Received: by 2002:a05:600c:8219:b0:4a0:108:3b48 with SMTP id
 5b1f17b1804b1-4a1d760746amr244503685e9.7.1792501984828; Tue, 20 Oct 2026
 06:13:04 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019160615.2348500-1-nphamcs@gmail.com> <atcRLYvKavedT6Hs@yjaykim-PowerEdge-T330>
In-Reply-To: <atcRLYvKavedT6Hs@yjaykim-PowerEdge-T330>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 20 Oct 2026 06:12:53 -0700
X-Gm-Features: AclHuK-KWlwJ6jupfQN2upeYH99aX1_31TwAq1vK8qUCAkH6OCtgeWVRSWcg6oQ
Message-ID: <CAKEwX=MRvzzd0Fn=UX+LcRo+K9wuqCWSB42NNn7rvZkZukRRrg@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: revalidate populated clusters before scanning
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9F72B1A0009
X-Stat-Signature: eftx9nktzdj9mbfpsekn5ppi56i86doc
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792501986-25791
X-HE-Meta: U2FsdGVkX1+0g1/BkSHpC/Dpxe4WysE+D9+IRdKz70sair7I5LJcuQ1iWnCN59XdfAOYTGVzG3fRhQtLvL/Bxba+L5t13l/T+FSmpB42jdciv97Rdn/UnYia5RCxwLHbrcWLGleeEMfcfgW3z6Y3vScrXL1LPi5VgBmSTatyKDkhSbqQ7UXsrjsCbrsNpu3aaA1rvgQw0dkCzKm/MOhj6GbtGjSdnZvlVizM6EdmY0oZkICVMmaxWfreGOUfdaK4sqMoQc+oogLc9c3/CmTvo4VLD+2AnTT0dv6KzNweZhuoeNQgywa74e1wqj8VFnKjrPH/C8YPdNJqebvH7Er3duauBqPx6TpaovtDhGu4QlIz30ocZEPhMTkziBAaMvQE44Yi8DrZAaJCA3ZoByF7Ty/YEJ7LO26ndFU+5puvX1Gs1Y9eIsN2zl4FcatJXOiUzypdq0DsgAswc1ZCttpBhaRthAciD4KfzlYOSLCN88Ok4rCSuvDrpI66LoMRRyyMpiRa1WcQOJIvdvQXU5jqn/DZs5knEozjDVRe6FUBbfydnxUcM+L2gtv1LhlWCmWdHBdskN3wpSpRJ7L/jnZCuWkB9Z0Ym68ApKyMDynl+6a6r0X4s1XKXf7zn5O0vREVsOeJOjBZmI/TGAeL81X0mAKoWlaxhwLY0641TsVm8xVr+UTCz1zYVhD89+cHTgsGrXELQq0OGWgHZWRQ/aFHYfwaIY8MvaPqge+TUvhPu5D5zB5ZgPk250yU76KKBNdQu4w9smsU25IrfY7ZNgxYr+JG90DmdlnSRQh4MmzLVSb445GCKnthnsckBalSOWxbXrtuImShtA0Hg121IrIBS+kXx5XB7S02MQX0ug8iDuY8mcVksn4CR4rf5jzXB/g5hmDEHudNwOuVHb9aQXjxE9qI1X1Gx0cDPjUAYbJBzxNkjru+sPbNwZBxVMxz5HbTSCTlbFeLj4jUVsL5IpM
 UWRO+q6X
 Sf9mWbTgtCEuTzbelcPam2jQcd7z9kxp+nSsI7lpiFBaAKc0r4kvoEs1EFp4IRi9a4+PvKJvVUclBgQSizLOlpt5l65T7r2m5BeJmxjPhHvkMRQxBowP/Lw1DTZl9OgufqDcW1lbUIi8jUVD9IfhrGSYlOppaw8BtpS3Icb2fULdE9XW6YuTT/SJMAeol8nXkq+oRfrXo/lIFYx1Vz92l3w9ZiugMEAhAhEt0WcRxQf0RK7XCWvnMjVNVNuIG8AWJC0loKdbcjHsWypLFk0EB59Bfjqe8i79/j+uV/bidURA/h/gOJ3xN1wmP5ss4Z3cACheQRFkuD1EFj139r3AfEfiU+mSS0Qs/uJ3pL0zrOhlkHWvlg+4PZTpOhg3uWFkZrRPVLFgwfrocCrtAXOAxTtbV+uWCy2JpzT5SVIJi/Jvfcjp/74g7eSXVuUmfqdByn4LV03RPj25eCzfPnh8nJcaaucT57IDgl4QKxCDTKZARzVz2+2OS8fE36A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:58=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> On Mon, Oct 19, 2026 at 09:06:15AM -0700, Nhat Pham wrote:
> > swap_cluster_populate() can publish a cluster's table with the cluster
> > lock dropped. A cached allocator can use and empty it before the
> > populating allocator reacquires the lock. The resumed scan can then
> > dereference a NULL table.
> >
> > For example, CPU1 can retain a cached cluster offset on an SSD with
> > per-page discard disabled:
> >
> >     CPU0                          CPU1
> >     ----                          ----
> >     swap_cluster_populate()
> >       swap_cluster_alloc_table() fails
> >       spin_unlock(&ci->lock)
> >       local_unlock(&percpu_swap_cluster.lock)
> >       swap_cluster_alloc_table()
> >         rcu_assign_pointer(ci->table, table)
> >                                   swap_alloc_fast()
> >                                   local_unlock(&percpu_swap_cluster.loc=
k)
> >                                   mem_cgroup_try_charge_swap() fails
> >                                   swap_cache_del_folio()
> >                                     __swap_cluster_free_entries()
> >                                       free_cluster()
> >                                         __free_cluster()
> >                                           swap_cluster_free_table()
> >                                             rcu_assign_pointer(..., NUL=
L)
> >       local_lock(&percpu_swap_cluster.lock)
> >       spin_lock(&ci->lock)
> >       return ci
> >     alloc_swap_scan_cluster()
> >       cluster_scan_range()
> >         __swap_table_get()
>
> Hello Nhat.
>
> Good catch!
>
> > Reject an unusable cluster under its lock before scanning it. Relocate
> > it only while its table is present.
> >
> > Fixes: cdd77f84d966 ("mm, swap: consolidate cluster allocation helpers"=
)
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> > ---
> >  mm/swapfile.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index c3288910b3e3..988b7316e0a1 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -981,7 +981,11 @@ static unsigned int alloc_swap_scan_cluster(struct=
 swap_info_struct *si,
> >       bool need_reclaim, ret, usable;
> >
> >       lockdep_assert_held(&ci->lock);
> > -     VM_WARN_ON(!cluster_is_usable(ci, order));
> > +     if (!cluster_is_usable(ci, order)) {
> > +             if (cluster_table_is_alloced(ci))
> > +                     relocate_cluster(si, ci);
> > +             goto out_unlock;
> > +     }
>
> If this patch is applied as bloew, does it prevent the issue described he=
re?
>
> https://lore.kernel.org/linux-mm/20260720071342.50742-2-shikemeng@huaweic=
loud.com/
> (This patch publishes cluster table after lock acquired.)
>
> This patch is chagned the way I suggested during review... :(

Ah I missed that patch series and your review! What happened to it?
Did we just never land it?

Looks like we are still doing neither Keming's approach (table
copying) nor your approach (publishing at the end of
swap_cluster_alloc_table()).

>
> As you pointed out, another context can free the table
> without alloc context knwoing this situation.
> I missed this situation.

Yeah I feel like it's still not safe with your approach...
swap_cluster_alloc_table() does not hold nor acquire cluster's lock.
Between its publishing of the table and the subsequent lock
acquisition in its caller (swap_cluster_populate()), someone can still
come in and free the table.

It's tricky. We do not have an explicit contract for the metadata's
lifetime, so it's a bit of reading the tea leaves for me...

I think this is the last gap, and it's rare enough, so this simple
check should suffice to cover the edgiest of the edge cases :) But who
knows :) If bugs re-surfaced again, I think we can spend a bit more
time ironcladding the lifetime of clusters/tables:

1. Allocate outside of lock context, but make swap_cluster_populate()
lock the cluster, check cluster's status, and only then publish the
table (and return with the cluster locked). Basically Keming's
approach.

2. Carefully enforce metadata's lifetime. Perhaps we can add a refcnt?
In addition to occupied slots holding cluster's refcnt, we can allow
for temporary holders. As long as we can acquire a refcnt, we know for
sure the metadata is not freed under us. This is my approach for the
old vswap patch series, but it's tricky, especially with caching in
the picture.

>
> IMHO, Publishing the table only after reacquiring the cluster lock, as Ke=
meng
> suggested, and rejecting an unusable cluster under the lock as in this
> patch both look correct to me!
>
> Reviewed-by: Youngjun Park <youngjun.park@lge.com>

Thanks for the review, Youngjun!

>

