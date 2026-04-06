Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91B05E9D828
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 00:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC4A6B0088; Sun,  5 Apr 2026 20:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D106B0089; Sun,  5 Apr 2026 20:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C266B008A; Sun,  5 Apr 2026 20:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 577A16B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 20:20:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93967B65B4
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 00:20:30 +0000 (UTC)
X-FDA: 84626224620.15.FB32C3D
Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	by imf24.hostedemail.com (Postfix) with ESMTP id A08C8180004
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 00:20:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QVyChbFA;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775434828; a=rsa-sha256;
	cv=pass;
	b=EZY3MxEss+UXt3KekyzVRgUvMTvMMHQHaeZ8yasmxFC6vQ1l1t2+x+eJUwgnJCRzk4iz/X
	7L2Ah4s7fWGS7p9Y8rAWwDIMj5ysPgkptf49tQAYs38ovjb586TW892B7tfsZuXWVE/y62
	EqfYv2JHGnXWQHBQ8iKLaWUKhqRAqaI=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QVyChbFA;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775434828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OA8Fi+9OlJxfgdRXqcqY7SnyfOEw5ihy8ZJDjJD2zZY=;
	b=qv2ggXUyCz5dk9naTtkYEMIw9DNv3AgJl+zJnLpEvoRb5ZrHJt845wBzOkGRxmKPCYpfn5
	tOK3MRClN3aicDZH2hsNK+DREClJkjX/9qZiKaCs2r8V4xp3WnRcmuSuuevrigtpgrLd0/
	CQ0iOxXI5sTrtCiMmd6xitJDmlhnQ3M=
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-12732165d1eso4698169c88.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 17:20:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775434827; cv=none;
        d=google.com; s=arc-20240605;
        b=RCZ/fH0JNaGGk06D9roMWj4TpzMMqdA1nlKZeLU61qeP6zr2ABMtGH5TbbXRXGgrET
         SP47gxb4XdWhgQFwV2iKcWL5zUUEBh2k4In5oJLkNNj1gzGBslhc+wiMEHazSRkEIwe7
         +G8g3l+FE9hgbx5pc1Pmwu1i0O3EhRVVBWm4reCdVI8igx6ehGbjRtU0ftHLbPApv+aj
         CuU0tS/k65ZId/Dmmlhov8iyNMSHDt/xsjnB9sJPYkVfZ+jkZJha2EpKWeQofG1OIXM2
         +Z7kzLcg/9Gaf7vhA08TD011T713Wuny9uN9p8UoVUfnXpQauq195lH4gzxVSNwShuSQ
         DJbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OA8Fi+9OlJxfgdRXqcqY7SnyfOEw5ihy8ZJDjJD2zZY=;
        fh=tB95l0t4cG/E1YlDrPQyVpT5x++lIpTIBENW8c+Eb0g=;
        b=KwZ4d1PYzPi5iUM0Tteb1zFeRRhGnFuvimAYp0q7QCnpxgjrxVF+vQS/rKM3DwcYkq
         4MSV8sEaXEFSyJtwldNB84Tfjm4qH9gszrzKx9bGqizDp9CufnMgyXRVFxTnZewoHwr6
         Rt6Xp3I3ZPBQlkSGeP0t/HApgKbyM4cI0pql28CwQx1M9lwmImF2jr1Qkwt9d91UYa2s
         k845kgzERpmly8SLF8U2bg8Bj8YIrqV5gV3zcDtdJSTCmpC+AiuKJtm13eJVPdoQsXxc
         cPltWa6NK5K0nV7ppCKgK6DTg0eljr02YPjW0QyNLb56c1oaGGqUa15nWj2hPDsMNwzd
         PjEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775434827; x=1776039627; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OA8Fi+9OlJxfgdRXqcqY7SnyfOEw5ihy8ZJDjJD2zZY=;
        b=QVyChbFATgUtx1FLWuJXAMyC3NqRMa9qmGNK4uNlNtblhQC4xg9LPIEmASxXdh3epL
         7OCxnoTJWzXm9WEdgYD+QXkTRwpl6wY7a677TJoyfchkQ+DuBrMjDkFzrEgB2exAqQyf
         a+t585rzhRyvZvJ4kOSXQqmiBMRRjbEYTZUS+P3YSUFbTwNqY+9rZyhzbRgxaHmdKqGT
         rEm/ecx6TL/+qegAx8ZXiExXLnCUkSdMOkLH+0i/cV5VYJ7FZ1fTQgMpdBZTl4qB/uMC
         OgPOfRQoh1LEDLNzCxkGWmKdDZkV0SA6hPFBrEBLC8No2iTva9KtWE6c1dxVlJ914tOZ
         SGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775434827; x=1776039627;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OA8Fi+9OlJxfgdRXqcqY7SnyfOEw5ihy8ZJDjJD2zZY=;
        b=NhH/inblDJjCajSgm9bldt4ndDQj/ldvbLNg0fYu8mpfjVcRtKUGOmc3kVuouHcU9o
         Cf2ElOloDoKndbwRQA7AFhqC+4AhU8IhkQNEmHM29CFv5UWwaKkgXpLLHGvkv8knnoSc
         Ofr1zm3OH3PHhuyffLBuCr+uxlqw5/VI4EwX3Qvr8x/5oLabyY261Hwr2HtbvELWDgzb
         o73VdlnF+LdSOSTznj6PvVWq7CvW/+0Sjir6rl6diqBBRvblMtlaXYMWiYtjUzC/TEMJ
         aFrpzFfNnFXj+HYNIJ9OQ+P7nezFbAg8g3lDuMpmSFzoA9c/XtdhTn7Ewibw4ffOVN0k
         TE3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVPMnArK7/HRgfrUBscBu2y/z7rgg1Ynu0WA648yMuIfYe+TlY2pVWAQtO0MV5ZTCDjAKPF1M/6Iw==@kvack.org
X-Gm-Message-State: AOJu0YyMOFAyxgzSxxhXskoHQfV8ESDHf4SPYYIhJVAzZpGtJBaO/U9h
	UOZWAOe5ZGTDJOpu0rGqOwyhywRqSt1rprOsqHyhXgWHB2oJ48ev1l9FxmhKz90Xf3Lppa3vLII
	My6yeFVI5iQkWF39GF7+MgD26ZyekwA==
X-Gm-Gg: AeBDies6xiiWmMKIu2qLYB8ddXN8Mja1LU+rWIMi1DbhaRZdK8sRb8ySP+VbCM8/jSB
	4//g6s08G2+OSFI9omoULM1s2ojHAiq01h/OyFi/W+Rmu0bTC8dAi+beqbwcW3OA4j+nYng8zWd
	zfhejxhrHkLkW473KdCjR5uWKhwbkTwUmnj4JjElauoYbjP4x7ZQ0iP69hG+6Y/Znnn/4BOldEY
	Ppc8OkBmn7LH6bQd1l2tmJwkviGrLs6v7ZG7NpLOx4Wg8SqZNt1e93NNyIl764rY6OYWYWdlkMx
	3Dxk2VDpb1hD83NsA1vwJIcsC3zRENBrS/NydMQT
X-Received: by 2002:a05:7022:6713:b0:12b:ec15:69d3 with SMTP id
 a92af1059eb24-12bfb74944dmr4310086c88.19.1775434826335; Sun, 05 Apr 2026
 17:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260405184247.2690-1-ravis.opensrc@gmail.com> <20260405225104.76350-1-sj@kernel.org>
In-Reply-To: <20260405225104.76350-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sun, 5 Apr 2026 17:20:15 -0700
X-Gm-Features: AQROBzCWVpdEY0WBMi7IBXTwiTJnSWTMEGwi4Tb25j1mBUP3F3FjPzxVowT81aw
Message-ID: <CALa+Y16UKvw3tL1GraUhkef2durBd8a+p8R8m7p3GtPyC-pvKA@mail.gmail.com>
Subject: Re: [PATCH v6 0/1] mm/damon: add node_eligible_mem_bp and
 node_ineligible_mem_bp goal metrics
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: multipart/alternative; boundary="000000000000254bd1064ebfa23b"
X-Rspamd-Queue-Id: A08C8180004
X-Stat-Signature: 9ofnarph9a78ottu3hxt9gy19ynkuoc8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775434828-9165
X-HE-Meta: U2FsdGVkX19DnkFQXFS/xjKXEkErcnjc7b2MYnux29UJUNDx5wvSIEHajiLzYwT+8L/LW3auvGtULirt3ho71GqfpZV5xuk7As0D8YKzwMeQWgQCPNGSMIP4ZEZaC0MPLcurcJjB1nKDv1vEx4ffOoSBV7tyvhPh5fxxlSWJG0Ir8/PyzWFMyvgJtM/x37WtTsytWFujfXFwwcSZsCB21yFYR9Q7YZ410XkzBqdZuK56iRn7xE4mHK+Hv4znxA+b5fMc+fdutL7w6mGhqWlcRJ9z1IdgxWtHKDlDhDauty90qhwM15TgrDX+i7i56gEkO0wZUJTuRthlEIojhtZyYuhYF5ca6SXUfxuOrkoYE6fDl1xDJBuOMU0im0nBosiI+al13EGcOLihQja97ZNZWCM6/H+yVfirkW3/7CuR3/Ck2Px8mDsYLDA+l7oByogIDOu8YJDFhCOUBBQ2/ChhXBBztiokDXWjYegs1RvncbMeA6au+nXTEm9ltzx8TE1n90LzR+SZG1wRd7a79q90qYLgN2hMFWBlhyXGH62QBo2MVSPympucjP03+z/89G85ybnY8kmSiktqjmvBoUzC9wCsA1y3G0EKE5JEPn84vVl5uV5zrwhanZwZcqEvNlaO5XAHNSeGxzkBc2tfeXZe1yCp0FBZ/q6kumrwduH75WowXd/fO1WJ1Ifwrk9/vCr30RfwMrdC2vR5cXZPyj2oJSUP6ie8yBUTB1817abxZSLhtOROan9JVj5BgIHgbJSxqCO2Lmm4mAfsm1rXtksgQt/w8yVNlTIBxy1WxTL6KNieY1p7fBkv0isAZZloLmsxsFt8IPIKpKI9iL8h/x8YOrQbCoT5PRryCKAj+q2bqNFMvvP0vjh1YLiL5nyw6kOj+ezSFW9HH7b3m9O0dDoSlczhKIvRfK0XuxjssZawefeHcAteuzhC1m9nfKy8G7h3zWdJEuXBQ2NHkgSqVeG
 viAAbEZM
 u5SJgQn4Vxj0kXJPdJXEi9iYUN0GlEYYVulTVWq3tpXF7nC6JtDQgvVg278fLn0NFduWihK91LIwSwJEQLItlDUMmH1cZ9wl92u+RHqp+g9Q6C3GiXUDcmHFCVjuK2yUMiSsCwEAVcJ8D9XMbAXY3z6Dp6lnpksav1ebB/UcUaX2M44U9ytJN8/Y7nVegFNeQnjdEjmv/dkChmKIDbZIw1pCc+LMpqHPHc7tA1iTeHndhADhuAS/8LSd51RE8HdY+ouyTMRM8cyyR0HjyylUcMeOCSaDZIhhSv/9D7fl3FIrVHMCS1LLYGga09L2nTFMg8bTmIWKdAKg7NxVo1KwGuFn7/WVMD7ZWYlZojvDhLIHz9dzEAoJFBujoNa+iD+/rJ1PAUyC1/e5gq3urxceC3z9V13PxR9PKrCb4Ps1Wi9UWkgrYO3cNH2UtLdfzPUGiQGy6YJZ5M5vgFRKWQPPXimpKOyLQ/mZ0xSusVoyDUwH9OxvmoIxpQdwqsMX5re9PO0ETD8bt5LQztMzFPpJb/UW8uMYFVmOMh5GwCCUM6JxIVq6ehv7lRPkn250mIKx0VvlkUmQE1IuLS8T2+ImSTQdJGVfHKtVkd2sGCktA3zzN0is6vHrEhiFK5Cs0W3UkWeLAqUVkPJOu8bX2ffouZOWrW4VMMxSu0/TAfp0IMclWbck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000254bd1064ebfa23b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi SJ,

I will address your comments and the feedback from sashiko's review in the
next version of the patch.

Regarding the cover letter, I originally included it to provide context on
the general methodology. However, I agree that it is unnecessary for a
single patch. I will move the relevant content to the commit message and
drop the cover letter in the next iteration.

Thanks,
Ravi Jonnalagadda

On Sun, Apr 5, 2026 at 3:51=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:

> Hello Ravi,
>
> On Sun,  5 Apr 2026 11:42:46 -0700 Ravi Jonnalagadda <
> ravis.opensrc@gmail.com> wrote:
>
> > Changes since v5:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> https://lore.kernel.org/linux-mm/20260404012215.1539-1-ravis.opensrc@gmai=
l.com/
> >
> > - Rebased onto mm-new instead of damon/next for sashiko review
>
> Thank you for doing this.  sashiko was able to review and find some good
> points.  I shared the full review with my opinions as a reply to the patc=
h
> 1.
> Please check and reply.
>
> > - Removed Reported-by/Closes tags per maintainer feedback (not needed
> >   for bugs found before merge)
> >
> > Changes since v4:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> https://lore.kernel.org/linux-mm/20260320190453.1430-1-ravis.opensrc@gmai=
l.com/
> >
> > - Fixed commit message description for DAMOS_QUOTA_NODE_INELIGIBLE_MEM_=
BP
> >   per review feedback
> > - Added clarifying comment for ops-common.h include (for
> damon_get_folio())
> > - Fixed build error when CONFIG_DAMON_PADDR is disabled by adding
> >   #ifdef CONFIG_DAMON_PADDR guards around functions using
> damon_get_folio()
> > - Dropped RFC tag per maintainer feedback
> >
> > This patch is based on top of mm-new.
> >
> > Background and Motivation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > In heterogeneous memory systems, controlling memory distribution across
> > NUMA nodes is essential for performance optimization. This patch enable=
s
> > system-wide page distribution with target-state goals such as "maintain
> > 30% of scheme-eligible memory on CXL" using PA-mode DAMON schemes.
> >
> > What These Metrics Measure
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >
> > node_eligible_mem_bp:
> >     scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000
> >
> > node_ineligible_mem_bp:
> >     (total - scheme_eligible_bytes_on_node) / total * 10000
> >
> > These metrics are complementary: eligible_bp + ineligible_bp =3D 10000 =
bp.
>
> As I mentioned on sashiko review, I now think node_ineligible_mem_bp is a
> confusing name, and thinking a new name, maybe
> node_eligible_mem_bp_complement
> is better.  Let's further discuss on sashiko review reply thread.
>
> >
> > Two-Scheme Setup for Hot Page Distribution
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 7:3
> > ratio:
> >
> >     PUSH scheme: migrate_hot from node 0 -> node 1
> >       goal: node_ineligible_mem_bp, nid=3D0, target=3D3000
> >       "Move hot pages from DRAM to CXL if more than 70% of hot data is
> >        in DRAM"
> >
> >     PULL scheme: migrate_hot from node 1 -> node 0
> >       goal: node_eligible_mem_bp, nid=3D0, target=3D7000
> >       "Move hot pages from CXL to DRAM if less than 70% of hot data is
> >        in DRAM"
> >
> > The complementary goals create a feedback loop that converges to the
> > target distribution.
> >
> > Testing Results
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Functionally tested on a two-node heterogeneous memory system with DRAM
> > (node 0) and CXL memory (node 1). A PUSH+PULL scheme configuration usin=
g
> > migrate_hot actions was used to reach a target hot memory ratio between
> > the two tiers. Testing used the TEMPORAL goal tuner available in
> > damon/next and mm-unstable.
> >
> > With the TEMPORAL tuner, the system converges quickly to the target
> > distribution. The tuner drives esz to maximum when under goal and to
> > zero once the goal is met, forming a simple on/off feedback loop that
> > stabilizes at the desired ratio.
> >
> > With the CONSIST tuner, the scheme still converges but more slowly, as
> > it migrates and then throttles itself based on quota feedback. The time
> > to reach the goal varies depending on workload intensity.
> >
> > Note: These metrics work with both TEMPORAL and CONSIST goal tuners.
> >
> > Ravi Jonnalagadda (1):
> >   mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal
> >     metrics
> >
> >  include/linux/damon.h    |   6 ++
> >  mm/damon/core.c          | 188 ++++++++++++++++++++++++++++++++++++---
> >  mm/damon/sysfs-schemes.c |  12 +++
> >  3 files changed, 192 insertions(+), 14 deletions(-)
>
> Btw, having a cover letter for single patch looks odd.  Why don't you add
> this
> cover letter to the patch's commit message?
>
>
> Thanks,
> SJ
>
> [...]
>

--000000000000254bd1064ebfa23b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi SJ,<br><br>I will address your comments and the feedba=
ck from sashiko&#39;s review in the next version of the patch.<br><br>Regar=
ding the cover letter, I originally included it to provide context on the g=
eneral methodology. However, I agree that it is unnecessary for a single pa=
tch. I will move the relevant content to the commit message and drop the co=
ver letter in the next iteration.<br><br>Thanks,<br>Ravi Jonnalagadda<div><=
br></div><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" =
class=3D"gmail_attr">On Sun, Apr 5, 2026 at 3:51=E2=80=AFPM SeongJae Park &=
lt;<a href=3D"mailto:sj@kernel.org">sj@kernel.org</a>&gt; wrote:<br></div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft:1px solid rgb(204,204,204);padding-left:1ex">Hello Ravi,<br>
<br>
On Sun,=C2=A0 5 Apr 2026 11:42:46 -0700 Ravi Jonnalagadda &lt;<a href=3D"ma=
ilto:ravis.opensrc@gmail.com" target=3D"_blank">ravis.opensrc@gmail.com</a>=
&gt; wrote:<br>
<br>
&gt; Changes since v5:<br>
&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; <a href=3D"https://lore.kernel.org/linux-mm/20260404012215.1539-1-ravi=
s.opensrc@gmail.com/" rel=3D"noreferrer" target=3D"_blank">https://lore.ker=
nel.org/linux-mm/20260404012215.1539-1-ravis.opensrc@gmail.com/</a><br>
&gt; <br>
&gt; - Rebased onto mm-new instead of damon/next for sashiko review<br>
<br>
Thank you for doing this.=C2=A0 sashiko was able to review and find some go=
od<br>
points.=C2=A0 I shared the full review with my opinions as a reply to the p=
atch 1.<br>
Please check and reply.<br>
<br>
&gt; - Removed Reported-by/Closes tags per maintainer feedback (not needed<=
br>
&gt;=C2=A0 =C2=A0for bugs found before merge)<br>
&gt; <br>
&gt; Changes since v4:<br>
&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; <a href=3D"https://lore.kernel.org/linux-mm/20260320190453.1430-1-ravi=
s.opensrc@gmail.com/" rel=3D"noreferrer" target=3D"_blank">https://lore.ker=
nel.org/linux-mm/20260320190453.1430-1-ravis.opensrc@gmail.com/</a><br>
&gt; <br>
&gt; - Fixed commit message description for DAMOS_QUOTA_NODE_INELIGIBLE_MEM=
_BP<br>
&gt;=C2=A0 =C2=A0per review feedback<br>
&gt; - Added clarifying comment for ops-common.h include (for damon_get_fol=
io())<br>
&gt; - Fixed build error when CONFIG_DAMON_PADDR is disabled by adding<br>
&gt;=C2=A0 =C2=A0#ifdef CONFIG_DAMON_PADDR guards around functions using da=
mon_get_folio()<br>
&gt; - Dropped RFC tag per maintainer feedback<br>
&gt; <br>
&gt; This patch is based on top of mm-new.<br>
&gt; <br>
&gt; Background and Motivation<br>
&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D<br>
&gt; <br>
&gt; In heterogeneous memory systems, controlling memory distribution acros=
s<br>
&gt; NUMA nodes is essential for performance optimization. This patch enabl=
es<br>
&gt; system-wide page distribution with target-state goals such as &quot;ma=
intain<br>
&gt; 30% of scheme-eligible memory on CXL&quot; using PA-mode DAMON schemes=
.<br>
&gt; <br>
&gt; What These Metrics Measure<br>
&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D<br>
&gt; <br>
&gt; node_eligible_mem_bp:<br>
&gt;=C2=A0 =C2=A0 =C2=A0scheme_eligible_bytes_on_node / total_scheme_eligib=
le_bytes * 10000<br>
&gt; <br>
&gt; node_ineligible_mem_bp:<br>
&gt;=C2=A0 =C2=A0 =C2=A0(total - scheme_eligible_bytes_on_node) / total * 1=
0000<br>
&gt; <br>
&gt; These metrics are complementary: eligible_bp + ineligible_bp =3D 10000=
 bp.<br>
<br>
As I mentioned on sashiko review, I now think node_ineligible_mem_bp is a<b=
r>
confusing name, and thinking a new name, maybe node_eligible_mem_bp_complem=
ent<br>
is better.=C2=A0 Let&#39;s further discuss on sashiko review reply thread.<=
br>
<br>
&gt; <br>
&gt; Two-Scheme Setup for Hot Page Distribution<br>
&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; <br>
&gt; For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 7:3<=
br>
&gt; ratio:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0PUSH scheme: migrate_hot from node 0 -&gt; node 1<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0goal: node_ineligible_mem_bp, nid=3D0, targe=
t=3D3000<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;Move hot pages from DRAM to CXL if mor=
e than 70% of hot data is<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 in DRAM&quot;<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0PULL scheme: migrate_hot from node 1 -&gt; node 0<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0goal: node_eligible_mem_bp, nid=3D0, target=
=3D7000<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;Move hot pages from CXL to DRAM if les=
s than 70% of hot data is<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 in DRAM&quot;<br>
&gt; <br>
&gt; The complementary goals create a feedback loop that converges to the<b=
r>
&gt; target distribution.<br>
&gt; <br>
&gt; Testing Results<br>
&gt; =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
&gt; <br>
&gt; Functionally tested on a two-node heterogeneous memory system with DRA=
M<br>
&gt; (node 0) and CXL memory (node 1). A PUSH+PULL scheme configuration usi=
ng<br>
&gt; migrate_hot actions was used to reach a target hot memory ratio betwee=
n<br>
&gt; the two tiers. Testing used the TEMPORAL goal tuner available in<br>
&gt; damon/next and mm-unstable.<br>
&gt; <br>
&gt; With the TEMPORAL tuner, the system converges quickly to the target<br=
>
&gt; distribution. The tuner drives esz to maximum when under goal and to<b=
r>
&gt; zero once the goal is met, forming a simple on/off feedback loop that<=
br>
&gt; stabilizes at the desired ratio.<br>
&gt; <br>
&gt; With the CONSIST tuner, the scheme still converges but more slowly, as=
<br>
&gt; it migrates and then throttles itself based on quota feedback. The tim=
e<br>
&gt; to reach the goal varies depending on workload intensity.<br>
&gt; <br>
&gt; Note: These metrics work with both TEMPORAL and CONSIST goal tuners.<b=
r>
&gt; <br>
&gt; Ravi Jonnalagadda (1):<br>
&gt;=C2=A0 =C2=A0mm/damon: add node_eligible_mem_bp and node_ineligible_mem=
_bp goal<br>
&gt;=C2=A0 =C2=A0 =C2=A0metrics<br>
&gt; <br>
&gt;=C2=A0 include/linux/damon.h=C2=A0 =C2=A0 |=C2=A0 =C2=A06 ++<br>
&gt;=C2=A0 mm/damon/core.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 188 ++++++++=
++++++++++++++++++++++++++++---<br>
&gt;=C2=A0 mm/damon/sysfs-schemes.c |=C2=A0 12 +++<br>
&gt;=C2=A0 3 files changed, 192 insertions(+), 14 deletions(-)<br>
<br>
Btw, having a cover letter for single patch looks odd.=C2=A0 Why don&#39;t =
you add this<br>
cover letter to the patch&#39;s commit message?<br>
<br>
<br>
Thanks,<br>
SJ<br>
<br>
[...]<br>
</blockquote></div></div>

--000000000000254bd1064ebfa23b--

