Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A96606A329
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=gwaevzNT
Received: by kanga.kvack.org (Postfix)
	id 6458B6B05B4; Mon, 26 Oct 2026 14:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DD06B05B5; Mon, 26 Oct 2026 14:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533616B05B6; Mon, 26 Oct 2026 14:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33E126B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:02:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C84151A0760
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:02:08 +0000 (UTC)
X-FDA: 85365546336.30.2BDAEF7
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id C9DA9180009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:02:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gwaevzNT;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793037726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tE7RP4VYsHqrXApguz8sNdRczbXmH+5NrdAtgpflwuU=;
	b=ImY0I3WU1c2nDZZ6+eerGKRJbf48x2Oe9JFh/W106GpA1gvPVhemUnEb6J4Hjrq/4r3g2M
	FzbKxv0k7auPWekUOz6o3fUgDju0VQ3MaUVAvOm7V58q739BhaE4M+mi/vqd55wzMyzQ9l
	Og3ZoieqSCTBfc7COL+5a7JXXfP4UQY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gwaevzNT;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793037726;
	b=0gQHvXoMo3IovWE75YiyeRq50+eKvYRvKmA/44yLq83CD8tt1OG6Qj0TEFPJ2RcQC74h1t
	Qd4fRBNSlBznAbzSIxNYtj1DLO7w3p8lUUaR9tr8x92DAEcW1NjF2K2VR8ATfYQ4k5Y6Ww
	6Zl8udFgsml8ZfMsB1MnQDd3doARnOk=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a20d7a8984so3595e9.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793037725; cv=none;
        d=google.com; s=arc-20260327;
        b=mpaHGpi9NyEkULmgzHR682UVvPvXdyaPdhtiQTdFlH49lA3VlOU+0ejJ5XiKvRrWQq
         /0NZv6H2/tYOZAlJfHTQxQQsTHrKQI6sn3taDmR9kUNM3RPWWqCiR/v1SmB30BJf4feA
         e436Aw5LFhvMJV7Xa5wJJkyftP+yxUkuA7DkP1d6fmFGUDYE19aLnlOpLBY6HJiX8KSD
         rLwTBVOUHeGpC82w+S0kU5piZOkUW6OlgufujYAVBpqIuIV5O/q211Q/hauuTAflLBov
         OPK8nct9duHJ5+IDQAGsPak+V1HVxNf9xSvB0yQ+jEqAHNrYfEL8mtIFePcw4GjCVc0p
         iXUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tE7RP4VYsHqrXApguz8sNdRczbXmH+5NrdAtgpflwuU=;
        fh=0d4rqCF9vdGI5hltbls4wqqpSXvZmmKTX0HmX25oDTU=;
        b=OoBIBxr1x0DQPklcDXi1lpd/PHuUIZ7mX0FVnFch3JapA6HMHo2TSUsbIjp9dwCTBM
         3EYXm3IwuyjaanZGTuT5BSDMfwhHm/fqQCfSZ68Bu958UwQyt3pw8KGTye3y3sI117DW
         UT37JeKWWncuD47+GMg1Z3Bgg/rlYKWNuJWdtx2H7SNr/HcLJI+/qFaeTrxtWM8fLu1/
         8uoE47838PnM15TI3NyOiMYj132Ub1JDKhu664qKoRrEsaGbXz1fcubwnzlaK1SlwrYv
         5jppPMhFZ7caZgA/zCRq5bHHIzt6DOjGDrNTReXi7fj8mdqe+8qVdtaxzTVYZFJwlqlz
         GPCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793037725; x=1793642525; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tE7RP4VYsHqrXApguz8sNdRczbXmH+5NrdAtgpflwuU=;
        b=gwaevzNT3hcQtgnppCnuWr6arCkT8OGLscdaSJ3iecjACluINnjbNJXa/8CkUgzSjQ
         Ap2ApAtCu3I48bHKXtgFksgGVK4MzzqSnMjdW27Wi52vHYyxQfJY7mDglkSWH81A9dV9
         WH5IwjS9MAxpOnzDxMoROouCRMBWc1Vk1593mZkNwUrB/GQ+gl4DSok/Wk9D64pPABlr
         vLJnP2IQ7C/6XvhXiQ/CVKneQgiNP1PFz984ZvrQK12X6zBpaenWjHiP1XnDgqyfZfTp
         dPy56bCW7HV96+IrFhYpi/rR2DGHTN1uqz+KmB7Ox2mCDgOKavKOKCl1uejZUSlyLNqI
         ebGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793037725; x=1793642525;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tE7RP4VYsHqrXApguz8sNdRczbXmH+5NrdAtgpflwuU=;
        b=KcHm++eFFEuHTdLmIl/SThhWOIRqIuVYVZ2IRcF4YU2F/PFvvyzuWflE1DXs9FcCEa
         pqCI5CQAx7S2ZLC48GGFpEjgRUkD+7HLcpi1GsGjbXB/k4yXWebrqeqU2cHFsXSxSDCd
         hh+t/cD+r7fUKYDyndUBp5CPe4AD0euKCc6sT1MxJKgPfpcCcBFPYDvYBD49VtnMP/H8
         mCzx+6ubgFvZcxXPJS5aGBvW49u5Zi16o9u2w74Sq940VzBHoawJnOLC3TbJiu1bxNuQ
         diTTxSFKFHl6EKvZL78sjdTbyaiDowifF40px9PA7rz7rpclrZzd2AFgLMl8g3II7GEt
         5ZFA==
X-Forwarded-Encrypted: i=1; AKwUvByRPKaUpFdorbx03QRf5ra2kmtEhrwN3Vujdrulw4v3SG2WI+djyimRvoQdDb2CsYLNppdzH4kkYw==@kvack.org
X-Gm-Message-State: AFq9FYL4A32P4OyYcR4biZeUDuRcX5vsk/y5fXocG8OtApHsM8hSeObM
	+LwJgSIs4InHkQK2JGhUOQuSSCibpzi+Jt58PoRPHx1JWSKjM4Y0UuM+cOYy3oLzMLsuLwwrn+E
	Ia9z7dIuuf0pGIn8p8LPNeqX05Nevxg1kUtIbYdaW
X-Gm-Gg: AYBFou1+HWCYFNnoKjRGrUUykpsOUBTDKwv/I1RgjbjXB1nMnJGYeW1GAwPv4JZDLS4
	+98XYImMsh8pq+/BoRLcv7aZydIkcOh4LAMNV7PiWpVGuDbejCS2XEaPaAjAuD8NI22DyyhvrMa
	vLOeKn/xkAqZpw0LF3vMNEbg9aS32L9MRSCtCkWXeHILy1PaWV4PIOzROvaiEjXpch6vOgN5EiB
	Nj6ExvyoGznhIzq1OXuH+dM2g3ozsnpZDkzz9Bl7eBq4qL4SIOShw727Ioi3qqpFQn1/vwtmGIg
	FHexRxr5wuVn7Wd4xWl/3bTWoEU8Lb0rwk726DlbwJXbOUt44mXm9hUUgPHTBw2JJiO/ME2O+DB
	KOFh7Lc63z8VRnT8Rl0w46/UZNSu7QE33xzIGgT/9Yb0jUXki7QnLyW0H/s5p1o+Bg6z+am0fLD
	M+27NcFA1wrR6yvm912anYWw==
X-Received: by 2002:a05:600c:2295:b0:4a2:bd1:a80a with SMTP id
 5b1f17b1804b1-4a7d73b0af0mr46865e9.2.1793037724801; Mon, 26 Oct 2026 11:02:04
 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023222313.3979455-1-tjmercier@google.com> <at9U2HvyUP-iYOCt@tiehlicka>
In-Reply-To: <at9U2HvyUP-iYOCt@tiehlicka>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 26 Oct 2026 11:01:51 -0700
X-Gm-Features: AclHuK-fek2ms36qxSTQ8kH_qS9sI-bAShEDJFdyR3pRLqFaZUwSwPiYlTTU9KA
Message-ID: <CABdmKX1mLKEJNiecW+meJ=LB_Kb8-ieeWdZDd4T6rNR9gKuq_A@mail.gmail.com>
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
To: Michal Hocko <mhocko@suse.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C9DA9180009
X-Stat-Signature: scj4m39i959uagwjunbb74u5m3o96ute
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793037726-705355
X-HE-Meta: U2FsdGVkX18LHpgKjn8psSASu5NzXcIlyybwYrF7I/naureCnbvalStLlv9uNbcl4xjQFhDm56hbEKzMzITpP8qdkG3o51ZHqXfwea7BQTIxmblNsD62X9SYbNjmTX5F/+s5KyXJ1T0f1WlM3pmxoSZXqPjoZc9OndZ7kvXqKhiglgVBUXeL40n8vk4h/qIr2MIDq/kbjaokMbFgMwAUS+Q84xgk01/lWGHa86hANIF4elLgjb7KQy0zCXIl62dX2owbmi3+HzEhLNSZ0K3BL8+QFN1lU2xaFA8sJmbEm4AGMzMGbb9NHzo7Wqw/WHMkSB1lfNM2w6LxR24zOc+YZNK0Kj3KC8sYmPnjQlco8AplgVfSj3xV6O4ZBXC9WpjEZ6kPFbNMgigxFa1MA9mYClgMNYHtqhOZXGphOOqGNpnNVr/BmoQzjN+U8eO/cpnYuYMUkNOAmTCQUrvjGDlZKdrYWT/R1E53U0bB4Gr1xm+3ZHS73uyH5kKUy/RFgXjcc7X7AUaJE9cQSBSNVZasR0AodqkZuFQ5ksbYvE0z3ZmbRtov6GRmCrUfiTcLz0jr4Rdt31ySQf49ayQq9wrgmeMOpINDLVU+7u1vqFh3MU3M9Wgl6IdU7xsiE7M6GCPPEjEcOlJxYxRRjEzH2pJOb2dtHvIqvfA1Z3pVhxonR/a+DJTNj9z1CSUGi0h5KHRMtdB0Z7aIZEjD/87/OnX9XDtPnHzI6MoSpq76/9Xsqeeb9NMnJeJuJYF2/z/2aIWFhMI+vFZBK7dnhfnamxEw/eqYShv5t3YExJTmRrF/WkkihGdEZZj+YX0mO1DeMeckDunQEYGQZ80+bTs0/3gG4MZFIZvE3VIFvnxg2MlJWVW9SLUyUF1am1ymQVAM7xIpZGL2A9MeCm8SlUXVFhqTZ2STso2tRhV6T9Dd9r3Pm5saI8H/noeyDgZ0atQYheop50X1/Ge7aa/R2sDxCEG
 y0KYPutG
 k2qkShKQN8SwnTJt+RgBMxkyT1SluRu7VOQgdphMU2eY8DTG8pIBksObGTFtxYVACUPxc0RzD2ZUOXPShgvPIf5js2CR1RuvBfjjyv2afDpC8RWTbdFvBpK6AQP/z/GRUVv59HGov07HQtFLuMrw6RLY9jfPjoR95MxxnM9O9A0xp9/5n3nDZ4WnXJz9oMg10dHEswEBmFQdxkU+ljCmmPVGh01jssSW3zUiYa3nVtDBpdnyHeug3AmybGhfkH/wlYJYRct9O2nDn64p22HT720pFkC8SH4A6tc94jdeCgjpZdWGBSvfih7ZdBqCUBKFHMZXB5H2ygujhByioWZ3VPm8MdKukQcRTPQpNBDOItmRQu8A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 6:25=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Fri 23-10-26 15:23:13, T.J. Mercier wrote:
> [...]
> > ---
> >  mm/memcontrol.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index a05d9a8baa1b..84f4a8fd4d16 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struct *w=
ork)
> >       struct mem_cgroup *memcg;
> >
> >       memcg =3D container_of(work, struct mem_cgroup, high_work);
> > +     if (!css_tryget_online(&memcg->css))
> > +             return;
> >       reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
> > +     css_put(&memcg->css);
> >  }
>
> OK.
>
> >  static void high_irq_work_func(struct irq_work *work)
> > @@ -4463,6 +4466,8 @@ static void mem_cgroup_css_offline(struct cgroup_=
subsys_state *css)
> >
> >       page_counter_set_min(&memcg->memory, 0);
> >       page_counter_set_low(&memcg->memory, 0);
> > +     page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> > +     page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
> >
> >       zswap_memcg_offline_cleanup(memcg);
>
> Should we simply disable_work_sync when the memcg is going to be
> released instead (mem_cgroup_css_released)? That should both prevent
> the run reclaim_high during the memcg shut down and and also avoid
> plaing with limits to work around.

Hi Michal,

Unfortunately that won't work for shrink_many() ->
!mem_cgroup_tryget() -> lru_gen_release_memcg() which can occur before
mem_cgroup_css_released() runs. (mem_cgroup_css_released() happens
through the cgroup_release_wq.)

The high limit reset is also needed for targeting live ancestors above
the offlined child in try_charge_memcg(). Without the resets,
high_work is never attempted on them since it gets dropped when
attempted on the offlined child due to the first hunk, and
try_charge_memcg() breaks out of the loop.

Shakeel's remote charging patch
(https://lore.kernel.org/all/20261010210957.1350874-4-shakeel.butt@linux.de=
v/)
sends remote charges through high_work too, so without the resets
those would lose ancestor reclaim the same way. Before that patch not
performing the resets means reclaim_high() runs unnecesarily against
current's memcg (not the remote memcg above memory.high).

