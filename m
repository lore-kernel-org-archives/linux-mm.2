Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CBC2C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3258E6B00A5; Tue, 25 Aug 2026 10:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6266B00A7; Tue, 25 Aug 2026 10:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC006B00A9; Tue, 25 Aug 2026 10:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D639E6B00A5
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:07:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FA0A80420
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:07:41 +0000 (UTC)
X-FDA: 85139969922.27.09C6357
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 46E464000D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:07:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sRHiM1dK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A40bq1NKMzpbz5lol0Y+pOu2AxUSylcKXeFYq0SAZNE=;
	b=zxLao6gS59vpqHE9nbptPO6sEaV24Xe3yo5RQ9XozOXrTjQfYHmmRH0H5r+Up0o657ZFEQ
	PmRdIVwCKdWxIUQnCrTH+xX/NqcyMHSxexZTfGy0bDo8Y/ViTT8rW2MYIucSa+M8K6m4Rr
	JNNM7amtWTJbrW7pL6i6YOVY7regvYw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sRHiM1dK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787666859;
	b=QiJTHVI5UMRFiopzQxAPqo2+c3oCuX/kob47gNSj4ef+hRYDfVl8g/BAWB3NvdLZ7TMbm8
	WNd9wla3p26RSvsvz5QxOyxWX24+wJA1VRrgZRNBgX4rnsCV2ewoDVvYcY5LimxUI0qUl6
	sAm7Y1qP3doYIzQbYc8PNUzj9mczryo=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47db714766aso521844f8f.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:07:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787666858; cv=none;
        d=google.com; s=arc-20260327;
        b=GuHbkDzyz2i6KGYQrF1GAlKwak0ozH6/0G41iOn5tbqHvPoMa5sFfCmWqCnSmhCut2
         V1iJWed6ufr4hsgg8xEGB+wjLr6Yng++cmULdyGK+DhVkd3GdBob+s3XlHDUf601IbIq
         4XkXcK/rdCSb0t/HeEwCbYgv9WiCcw+U/XQ/z+l6FermApmZPqM9rQ4iGRTTV47z+qHv
         qria94R52/bFCH6hIA54/fHQFh8FEPmGN68Q+4sesT3OdZQAWlDbhsKw+FgeWfkM4ydF
         T72f8PPMZ7F2IdEgY3PNmMfdgCKq/+EiScLRtY0YL3c7Kn4G8Z6O2KFEIITTa4GxH0q7
         gRuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A40bq1NKMzpbz5lol0Y+pOu2AxUSylcKXeFYq0SAZNE=;
        fh=VfVGR/zz8Fqjwj53hn8t8EvYWlNX7OBgZbOhQCCBSt8=;
        b=Ay+wCtGk4++ykdXodzDgMK0H9CAnURmvGGuXwdWwYzfvh+ad1JD0IRUIZT/7ky46se
         HTV/5pxVHHLpKB9+Pllgw3qlw/y2cqIXmhF/YGpGoO5OGANNQTlF02XMaNYyLBmIq5DT
         n5JZnmYD/UMViOMQCAkUb0BwdMIBZXW4apJP0u6WvyDMx/TOJbjGciuj0XCuS47K4Q6e
         0FaRanBIGAd1eVRW/Q+gT4d06fesxO3UQ4/wVwSUg1hRTVyMoGgb4OYp7HIo0zrHKDmo
         NBCqbPL4bK0s+BkRj//0o9cZyvE5ktxYXq7uJ/me+FyL6owDQKlTL0ODSKYmJ2Dn2FaO
         JwtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787666858; x=1788271658; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A40bq1NKMzpbz5lol0Y+pOu2AxUSylcKXeFYq0SAZNE=;
        b=sRHiM1dK8xIIletfvZOmDZ87uHNUXRgKntnTZ6d1RE2CxXgbzk+xaENXRpWt1yOuOz
         6XQsOVrNlumnyCPtKPjpr6I9z2QfHpgm5c6rnEhkRjh8N8ptnlgUeqEIvcX2B6L/2E7n
         EMsbK9tBGV1eghEJlJMB90goVIUmAUYTOEE9PTga0jNZ+5XeFDRPgU8qV9+WK13IUsTI
         XhHGhFT8GzYllcUI6obitI0+vKwq+AS6O4dO/1n6336eA2ZyEnpdtF8T7hvwN0liFqli
         Di/KkA1+VcWQdlF+mvLQMq/6bcaGkgB33EYMBusiIVImd1bZj/QeZLkufBo6nxqtgrIG
         ONkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787666858; x=1788271658;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A40bq1NKMzpbz5lol0Y+pOu2AxUSylcKXeFYq0SAZNE=;
        b=RKVvKSZ8QItwcQyS511rl5b2ul2M8C6otaSObRmEdp8CDTnqLnYQHZ/QeF5xtXhSA4
         xZiBIVuTcKmEEoXZ0CxModpnIHLyhivifPmPeOHV+3CW+bqHupGWbPyIZC0qaGk1fu9H
         Z+Vlnwq4NCB2hink6vVlJ+GI7xtG2n1fygU9nEJt/x1ifcGlj5RErMfLsrv0iM5oqxmB
         JehlmyhS/8Zf9ArMjUdiylfOwe4085h3gj6e/cDb7PZnYGDg1akhjr2t82jfP9BC0Exq
         MUM10rKSi5PaSF8Cl03YQKbtsvZPuS3XVf/PqaNi3LB5lQ7XuoIvWf+En9gAW+yPFnKB
         ihrA==
X-Forwarded-Encrypted: i=1; AHgh+Rq66zyGKRTf8pafsgkrfPviGpe+nYdT+xkcPVTF03b4ttgoqzfqwujP4eOYSZ3PpTQU/5VCL70hvw==@kvack.org
X-Gm-Message-State: AFuF++mYQQ67tX1MQWPhcsB+gSp1OQFQc+v+EncHDWv3/m3reH7S6YAK
	L/JPiKvCMBMU8Yn5H1Ml/3i4DmyLbO9WcWeznca31Ow8HIaKw3s1w4ad8uJGGrdbKPjV0FhD3tw
	JNV3m5CeAhPNGRvP3ij5g5A1NowzT80k=
X-Gm-Gg: AR+sD10+1OlZJoobGEcyh/XCtNSPqkd6AfE7pWwXN0ljam1seUNAxLgOpqOcX9lEtrA
	/7D5rIuQ3krALn4yv+UX3gsODwpYZuk9l/jvPjOIeBA1cyhDPcaRuj2f7Km5T/fjzsU/j264Cb8
	Zo54tBHMyvDytGo4LpuQ73DRqv/ZZm6SKyg7AspZ2JTvxx59n/dyQ6cYliL91NN+arG9uYQrWWW
	JixhXvyvgg9tCDDgadQgvrTa1JJB8V8//Hh2eG0wxKXbuboXiQA6Id79i+OozoPXPczTn07UxOb
	mzMworsyew8vf4OcrFD5Yuc0oATuZ8Ifxt2V02+l2Lq/a/wAhGf4tpP70h3emI9MlpuSJiaIsRq
	qvCK1jv/R8Jo/UYFcyNrN
X-Received: by 2002:a05:6000:3106:b0:480:b3:aaf4 with SMTP id
 ffacd0b85a97d-482d993937fmr8620955f8f.4.1787666857237; Tue, 25 Aug 2026
 07:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260610232048.62930-1-shakeel.butt@linux.dev>
 <aoxKKXjs3o6jUanE@nickhuang> <041af2b5-9136-4027-b35a-72e5044c63ab@kernel.org>
 <ao2emWNMkthyVXn6@nickhuang> <8969b1c2-360b-4fd0-ab70-eb4a68365f50@kernel.org>
In-Reply-To: <8969b1c2-360b-4fd0-ab70-eb4a68365f50@kernel.org>
From: Nick Huang <sef1548@gmail.com>
Date: Tue, 25 Aug 2026 22:07:25 +0800
X-Gm-Features: AcwNN1UETsWAXQxt7Pfh73CA-2c02AWedsOU-um3XgS03nN4vktj3OkfCJVp3o8
Message-ID: <CABZAGRHe4vGMRqT3v82JXqMTg74bCL3LONgCfP8EUa7GPOA_QA@mail.gmail.com>
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in shrinker_debugfs_count_show()
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Zenghui Yu <zenghui.yu@linux.dev>, Nhat Pham <nphamcs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 1j1zessjfsmiksrwthqxdnfpmepti4dc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 46E464000D
X-HE-Tag: 1787666859-546777
X-HE-Meta: U2FsdGVkX1+Tr2eUE8nFiMX/lCTDmY0jLnMRVfN2V6CnhtCAWEnLhFZyvO+E98JnxkNC0KN2t+3KW8UROTNhJIcpYwmixK7n7YePnaE52ezYBpHFxI52lAt+86o9IV/ysywkME71eyp+kqqnAWe/qGUT9++/k1OQ/poT58ZrUD8Wsy5SvAoDOw9OpPdJa6AC9aiz5TkcnSQVO0lr4mA6ygNfgOVsoNSo6JpLlusyc1wmVneu4QPMFnadqCItPzuX+gdmxbuEkRA6Q0bkhDBCwN5qSMHuCGyLnF3rldDIzEKIVk84BqT7yOgs+30K2f+mjPgDtN1dcdMvPAofArvHl/btQ0s7PLERum47gqNbXCS9ks1IE/s1bNBUaWBuc8qlKUlN/fqksBKnIcs8XKdN/7mX5PuVLX7oKiV4T6HQc91F+e4clVKL2Uszx5aBCog6Q5HSgivgH9yLfwMaN4By2ghW9/iwe0SKhe5Bppv+xO6ewyjFBeIJDXgtv3sphi2HMA8iLVmRhUQ4FFB3MrD/PODiwSKksYF77Pb5kI2+Am1eWUTxuREVjuuN0vn8KNKjjSZb6ijG2LZh5XJF82xW8B5PILTkxf8/DO3+9ih416CPbCbO/3w95QUW5esUlFPNtj6iyOnZEpmDVSxqvteIUMy9a0DH2wcIEZ+Mp+0T1m9Zl2C+5cm2TYbBLwC94Z2lQuIRNVSKKlEb2Y5tOwtT4wTKAszI8Gaam0T1oo5jdZUlf7usnjvb3xetPuSmWEkyhwLAtyfP0imXPVPEnQPVo3v3ZQJ4LsS7r0gBr6TMQE1eULO1lefuXje4dUDvHn0MbAZQ/lLU9NFA/ZouHVCEbBmSECxnQlVZV16BjgkP5QkPt1EAmbl7fqdQwlcvVio+/8tjsmRmS3zVrK4wIvnf6q7gg93CfWNNabsN3jda4kpIMcL+hMb8CTfEGp15cYWsJFSQd4QrNRQERQiG47B
 A3PeEXyp
 GmIqbAXc+Zpu/lc6KmSuGQKWRbGqz4pvWakKG5uvCCCWJ66n/+DmJcT6yo4lEfueC5+c+9P0GduNfu6xBn4mL64eqGcSB/t9sivlXidnzocPImGHUC9XCdb42EbZd1Hc6xxZhO36nJHZgHp/G9BANa0mhNg+sXo4ZhXeIizdlu1nqdU4T4c2w5rCAbF6EmnG6cQ7iYypc1ciyM6jiq0W8BbbASrzOVq5LBus0oQM3N/f2HRu+gh22ilsTmfooA9HTb67o/wJtgXSXld7uTGoS8eQPJ3zWpCqjPBfFKwkE8EA8JUX7igfGFC51Z6zFLn3IGyRv3fTQ2wms9V7sxVI8fo7hDtWozoYblmEdnOi0S0OCDti86wAYSHiM3O8lzZiMtyEtZ9fvHux1uwYYXKWUyTRc4CFmPnqZjBu3gDolG1x6DfPa4GQFb48HtI8GFE9DnExX8w7+fEnUo4fzBLCqrd7iPbheGbZzXENKu9/tnx1O7VUjQ82kcSs8ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Krzysztof Kozlowski <krzk@kernel.org> =E6=96=BC 2026=E5=B9=B48=E6=9C=8825=
=E6=97=A5=E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=889:56=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> On 25/08/2026 15:54, Nick Huang wrote:
> > On Tue, Aug 25, 2026 at 08:12:09AM +0200, Krzysztof Kozlowski wrote:
> >> On 24/08/2026 15:42, Nick Huang wrote:
> >>> On Wed, Jun 10, 2026 at 04:20:48PM -0700, Shakeel Butt wrote:
> >>>> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> >>>> inside an RCU read-side critical section:
> >>>>
> >>>>   BUG: sleeping function called from invalid context at kernel/cgrou=
p/rstat.c:421
> >>>>   RCU nest depth: 1, expected: 0
> >>>>    css_rstat_flush
> >>>>    mem_cgroup_flush_stats
> >>>>    zswap_shrinker_count
> >>>>    shrinker_debugfs_count_show
> >>>>
> >>>> shrinker_debugfs_count_show() invokes the ->count_objects() callback
> >>>> under rcu_read_lock(). The zswap callback flushes memcg stats via
> >>>> css_rstat_flush(), which may sleep, so it must not run under RCU.
> >>>>
> >>>> The RCU lock is not needed here. mem_cgroup_iter() takes RCU interna=
lly
> >>>> and returns a memcg holding a css reference (dropped on the next
> >>>> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> >>>> without it. The shrinker is kept alive by the open debugfs file:
> >>>> shrinker_free() removes the debugfs entries via
> >>>> debugfs_remove_recursive(), which waits for in-flight readers to dra=
in,
> >>>> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handl=
er
> >>>> already invokes the sleeping ->scan_objects() callback with no RCU
> >>>> section.
> >>>>
> >>>> Drop the rcu_read_lock()/rcu_read_unlock().
> >>>>
> >>>> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for=
 memory shrinkers")
> >>>> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> >>>> Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b=
1c4d@linux.dev/
> >>>> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> >>>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> >>>> ---
> >>>>  mm/shrinker_debug.c | 4 ----
> >>>>  1 file changed, 4 deletions(-)
> >>>>
> >>>> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
> >>>> index affa64437302..cda4e86428c8 100644
> >>>> --- a/mm/shrinker_debug.c
> >>>> +++ b/mm/shrinker_debug.c
> >>>> @@ -57,8 +57,6 @@ static int shrinker_debugfs_count_show(struct seq_=
file *m, void *v)
> >>>>    if (!count_per_node)
> >>>>            return -ENOMEM;
> >>>>
> >>>> -  rcu_read_lock();
> >>>> -
> >>>>    memcg_aware =3D shrinker->flags & SHRINKER_MEMCG_AWARE;
> >>>>
> >>>>    memcg =3D mem_cgroup_iter(NULL, NULL, NULL);
> >>>> @@ -88,8 +86,6 @@ static int shrinker_debugfs_count_show(struct seq_=
file *m, void *v)
> >>>>            }
> >>>>    } while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)) !=3D NULL=
);
> >>>>
> >>>> -  rcu_read_unlock();
> >>>> -
> >>>>    kfree(count_per_node);
> >>>>    return ret;
> >>>>  }
> >>>> --
> >>>> 2.53.0-Meta
> >>>>
> >>> Reviewed-by: Nick Huang <sef1548@gmail.com>
> >>
> >> Sorry, but what exactly did you review here? In the past you were
> >> sending AI slop:
> >> https://lore.kernel.org/all/aeNGbNyPxJssnkbO@lucifer/
> >>
> >> Not even properly following the process.
> >> https://lore.kernel.org/all/20260724143408.175870-1-sef1548@gmail.com/
> >>
> >> https://lore.kernel.org/all/?q=3Df%3Asef1548%40gmail.com
> >>
> >> Why suddenly reviewing MM patches?
> >>
> >> Best regards,
> >> Krzysztof
> >
> > Hi Krzysztof
> >
> > I saw this patch on the mailing list and was interested in the RCU issu=
e, so I looked at the related code.
> > I checked that removing the outer RCU read-side critical section doesn'=
t break the memcg lifetime,
> > since mem_cgroup_iter() returns the memcg with a CSS reference held.
> > I should have explained what I checked instead of just adding a Reviewe=
d-by.
> > Thanks for pointing that out.
>
> After all the maintainers already provided a review...
>
> Best regards,
> Krzysztof
Hi Krzysztof
Sorry, I misread it and didn't realize that the maintainers had
already reviewed it.
Thanks for pointing that out, and thanks for taking the time to respond.
--=20
Regards,
Nick Huang

