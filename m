Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB96C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 15:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72786B0088; Wed, 26 Aug 2026 11:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49E96B008A; Wed, 26 Aug 2026 11:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960616B008C; Wed, 26 Aug 2026 11:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB036B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:22:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB0A0A23C2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:22:03 +0000 (UTC)
X-FDA: 85143786126.21.ACF77CF
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id C08A416000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:22:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S4jgkQBq;
	spf=pass (imf08.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787757721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=keuFsF67kg9NNd6vPGpbcOXT2Q3wwuaETpuXDlkHZRk=;
	b=I1DVzo93YsbRfV1zKIuFDxFyl99uvWn7rTT4RtJbSo6NXcIrtcmr0qnVQWWw+SFspmJ4p6
	2DPXYksL9hxgidukBQb7JMdIJC0mrHRkr8uEHA+2RjmBZ0jURUZrQCi5ZmeVt+kYs14m71
	dPRTOLZn0Of982w7DoemoeC083HFxkc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787757721;
	b=zXb2EYQTt8jQ34S8IGhCQZFPQWai62aDLB2Z+ycT86ko58PMXBDMnUVlINlYtT92spkUFX
	xvq2ywNJuv+A++Kt6Os3QSh7FzV0l9Dzq6P78DFKG3ICv7xMIjuuhPEkZ6+kJza9nB/iUS
	vNIm79bJkyaStVdcdqupeYHvlgoMSzw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S4jgkQBq;
	spf=pass (imf08.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b4aa47bc97so644825e87.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:22:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787757720; cv=none;
        d=google.com; s=arc-20260327;
        b=O+jEm8PBsmevi0epXyz+r/RL+YNh8u4vcL6l3UGqFZ2AShqSZxzNv9OKhrxM4YD4hP
         HgFbfFreKFonTHdRtO6kHrKwE9ALJsE3j5VFm1ImZscym/VgvP2U7UZTGlGeYV7FK2dY
         CsdOnC0VnDUSTZmrffKgQn7XV34WAp2kIQJ0teHqKqOqwYdK+IY0yHig+Y45ZPY19JVg
         DzryCJa0yoBODQs575P8IgG4FsE2GtRVQuW1uN4+mh0fS5pO6Jcr8kUSVKQm7QPK1SH0
         l3O5UR3XutKUNNKIBvjqdw2NPDLx+yD2dVEGSsQtYk/pPCRHj2YCJ7ae3zQ/9F7JuFr/
         YOWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=keuFsF67kg9NNd6vPGpbcOXT2Q3wwuaETpuXDlkHZRk=;
        fh=FlkeiFRyK1vri/slnRVsUoyHYgkDw1GEWr9Inoj8g/c=;
        b=UFbzEVkvUAFHa52EPw0VO8Yr7MNJ7S4A714CVYN5WvTz0ZSoYdWo4h0ASYLk8gwKEi
         xDlt930R49CXVpd72UKXOU2xzAt7wsdGJAukvq+4rfmhic5jrUTr0gqrEN9v6TMZM03d
         XlYlJoeIw3NxOjD84eSwAesMspKm7Kn3/3MbLvCtC53oGcQvThj9QvUXhbW2IpzX1KHk
         pduizIWjHQNDz1uF7vnkUzCXrIu9a7Ztk0u3eIH1PZr8pIdpCKvH60JoGugncA/rCd2Y
         uVjuINN29VVbSfu/KhU09lDBzgSewnyD+yJt0fZWo/cadyCS6VDpsWNgu95m8M1VhlFD
         6S1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787757720; x=1788362520; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=keuFsF67kg9NNd6vPGpbcOXT2Q3wwuaETpuXDlkHZRk=;
        b=S4jgkQBqa5HKA6h/yoylebHbmQChJcg2/1hJ7/0T2GfPSedFvraEYTDgWdIg+XjagA
         mkE8VmFaTk5ER6BNo0m1aJ2sArCZihKQFC3YW8rq/dzA9DyqFemeraBiyav5skvtzdaY
         yfkLpyYSx77qb0a+rQm85RnkjdmjgfQKhxb3kEonxNdFh7jpWpiHSfCmDLSXJyAwh967
         29hjlEDZnrFWXZ9qh0ZfykOssTF1AYEynj6RXcKnkC3XlXWd+M5eg8LUXU5aadO3qsjX
         BAkz3FZ5lOIi+EGnszVtCL589O0Jxc4R662ezQggl5lb4NvULV4BhXSKwWae+IM1znss
         U/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787757720; x=1788362520;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=keuFsF67kg9NNd6vPGpbcOXT2Q3wwuaETpuXDlkHZRk=;
        b=dAOzCVor5fiCOb7KoZy7vxqY1It8fpuS6Tyw+VPVaxm0OcCuWog5OGOEF1G8zcIvgV
         Vgk1DSjVE5fT7b2ug5rQpg64WtsOtpN+j+ADBhw91NdudIJwLwob7vGfCWHjM705la10
         v4YEAsBax7q/er5kjK68Lp+HcbP1BXlkC6friqozVE/+TZf6sbnehyEmvu1GZFxp5iux
         L1S5uxWGih1nKKKLFEvOJ9O2+sOWZJYp83Fv/HysjYnUsrHhv+nKOBTvPhzzeeoG9qxi
         YatY+3Oy9FIbOwvPbSTOZra6vqyDL1YfWL/OPgsca7B15l0m/bUDQweKg5tu0pzahUsG
         ed4w==
X-Forwarded-Encrypted: i=1; AHgh+RpSuaWxUn4FpnggRrL0FCR2JwvjK/j86ugEBhihlvlDoq0bSP2puevdfmk2/b4ps/uNlfjj41H94g==@kvack.org
X-Gm-Message-State: AFuF++kRzR9cpt0YAmSC1qYBWd3MSv9zWk+iq7Gq2PRTk71Sc4nHD+3f
	7d7fdIV0P4nvzfgSY/AiTK8wbOgxbnLAYZgdOkPpkPoknn5Mcz+zau14lGZyv+JDoO27M3GJWqd
	agXOJVak+gTZAaGuHRt3lnDUIMSEYEsI=
X-Gm-Gg: AR+sD12g4lG1A2l2zLHV+nmUTEIKmECLsYNSm9oN9OECXFYmEtNhsZ9k7Akhpm955xh
	o9NldLyzha8elvo7dgamWWu1tbf6fa1yGdP+UX3pBObASBMTNlMUGLueEki1gURbevWL3lkv232
	obBfmhulHw22C32CrHtBU6kQPSBcUolj7+QbdtuA9V1GqjWU+nfXc7M4aNHfX1Ra27+HTih1iZZ
	bsov2x6FYlHaPBElS7TIxaPK5lOWYDRV3eiJ29NC5LlmGToGyOgScR/nhHt1Nl0i7/mfLyM3t2J
	9ppBKsAdhf+Up0eryxpK86ENw3TVBHkjEjUUi+0Scx0617E5YB91RC6nAKnDc78IVg8DPf8CuzU
	=
X-Received: by 2002:a05:6512:6089:b0:5b4:5352:e2b5 with SMTP id
 2adb3069b0e04-5b4a90437c2mr2230005e87.15.1787757719575; Wed, 26 Aug 2026
 08:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
 <20260815-shrink_zswap_entry_0815_v2-v3-1-0171bd86a667@gmail.com> <CAO9r8zOGUKnyro5G7p8dnWchDKJ0KWobJSPv8aRw_R3QnjvS0w@mail.gmail.com>
In-Reply-To: <CAO9r8zOGUKnyro5G7p8dnWchDKJ0KWobJSPv8aRw_R3QnjvS0w@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 26 Aug 2026 23:21:47 +0800
X-Gm-Features: AcwNN1VNU1SolCqpSZfpskC5xY5O94jEhgtYqGj47VrZyJ04ZF8bPh8P4IjLdpg
Message-ID: <CAJxJ_jhU1+3qA_+RDs4wJRTrhNWQn6BpqD=f1WmW7NfGyi22Yg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/3] mm/zswap: release retired pools via call_rcu()
 instead of synchronize_rcu()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C08A416000A
X-Stat-Signature: iwydf575gpczyt996sr4icwpu7q7sg8c
X-HE-Tag: 1787757721-179084
X-HE-Meta: U2FsdGVkX1/v+2xlSOzUGRr4zh7Zr30zLDK2Jbxxaqfg9LKqXblueFLU2RO2/n2nAAk9PXLVEA238vg79qc8v+wWZTdvWn1x/sfPvqRYW5Opn7opFISSBlyp4VKKHbhr28nrKOGnOm5CccDZt7AjTjk6BvopJjtvCKZQpcHn4bCeIibKIZSqp3zdshH4HgfzvDuewmaG1yre2lVrXZve2ScfuES8xSszs5MQJBzSH3LlRqcEGOXc4pXyCdMNojL39zkudMnbN+ZYp4ceBYYK7/ASpWXa4TMF7edu4PHdJkvh2qpqD0bZ7KXoslnGfKyBJM/Eon6k0DDc07IKTcXBjmMfqL1U6/dy2cGjl19veGNs/K950IFsC8V+/t01Hxvw+EPxE4KxeWTEOuQCkMi9cR2LhBa8cGgCiLFq9DLCBPPIVR4fetdgfalywT3p2HYlHmHT7zaRTw63Mk4dcs/pBxeJe4HZP/bC6GxxKsGmPD3DMMJKYYSqWvK8UnJUEBBXu7+8q8UQB8eNuUO8XD96kxoet+aAlvLKFdHckxSCJzu0hH1wvLX8jr36dOWYajj/Oa+V2ag+X1Mz3iPaJAlq4NLX3kve+pYW1bSLOdGXTLitxcte8VlAxNhEW8Ayas4VXLLrbupaKMFq1dKdMsDLJHvHDQneSfqf82kowSEQeALrSMbDH0jberahMnCFtl+Z4UbRV+jwXr+AaxI54roatkicGQfsqVZunbDbJFiZj0dompGYQRXCTmGmKtdZzMs8Ht86lnMmXa6wxOyVy8r4vv9FY61NpPv2PPMPFCWqwqw/PpxKwnlZkyHcsk19EtscEviGmCyF8CHSjI81NARNWkgeQV+PzGEXFO0tNIaV2HMO4VgLWTebuNEYu533/OaKTuSjh+r2nhsJvVqJIQHWq6Lsq2Ly9jAMLa+dJfqa2b2c7M2Z0EzOnvA4pkfyiDy1tFcRBGyR2J5kc55UhD/
 CUuIURNF
 r8VqpKYo9XRsrs4DA76sPbSerinB3mAYiNvYDtBIYeo1PfefWbFZs9l7pYh7FMBRSMJe7bBTcAoEBLxHnDAfxFMBqXbas9aVEOvuB+AqH6qRHDde+5vlvZXkGHvuzPSWcbGhnufE7UsgN6zLKkuV3kbpNzMFl8BVmoMc7cHD7CPkzzW4uNXpP60J/ptihU1wRA5gdXKuiTJh8gaOvXtfZuZxJV3sFRvauutIbFQD/DXA8/yDf5BP15gaTpJ4LZdjPROjHPMGwNZpXt/BXjaXvf+HpyWVhCfUO+uwaiVcoaS20OJcn7/PQdPhGKYacqVIU5Jiv09y0kQFfUfDizOKGqznIBuNysKAW+7eJcFe1TNOswxJD0C92tEkfBsctQAFVwtfMrEA2YuEddXKmiRHF3CObhuhvXnUTMjXDBpLYL1s73XLLHBAOdDWS6fLF58poGzhXvQRO6QGHYTRCQvAkzURtzUMmqUDdlS7ZF9+8hx8FCG2h4oQpxufVbg54KIYgyu6D1F9kKCgBBF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 12:55=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Fri, Aug 14, 2026 at 11:54=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.c=
om> wrote:
> >
> > When a pool's last reference is dropped, __zswap_pool_empty() removes i=
t
> > from the pool list and schedules __zswap_pool_release(), which calls
> > synchronize_rcu() to wait for readers before tearing the pool down.
> >
> > synchronize_rcu() is a synchronous, potentially long wait.  Replace it
> > with an asynchronous call_rcu(): __zswap_pool_empty() now hands the poo=
l
> > to call_rcu(), and the RCU callback defers the sleepable teardown to th=
e
> > release worker (the callback itself runs in softirq context and must no=
t
> > block).  The grace-period guarantee is unchanged; the retirement path
> > just no longer blocks on it.
> >
> > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> > ---
> >  mm/zswap.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 37f34e406c8e..cc4243356e21 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -155,6 +155,7 @@ struct zswap_pool {
> >         struct crypto_acomp_ctx __percpu *acomp_ctx;
> >         struct percpu_ref ref;
> >         struct list_head list;
> > +       struct rcu_head rcu_head;
> >         struct work_struct release_work;
> >         struct hlist_node node;
> >         char tfm_name[CRYPTO_MAX_ALG_NAME];
> > @@ -382,8 +383,6 @@ static void __zswap_pool_release(struct work_struct=
 *work)
> >         struct zswap_pool *pool =3D container_of(work, typeof(*pool),
> >                                                 release_work);
> >
> > -       synchronize_rcu();
> > -
> >         /* nobody should have been able to get a ref... */
> >         WARN_ON(!percpu_ref_is_zero(&pool->ref));
> >         percpu_ref_exit(&pool->ref);
> > @@ -392,6 +391,20 @@ static void __zswap_pool_release(struct work_struc=
t *work)
> >         zswap_pool_destroy(pool);
> >  }
> >
> > +static void __zswap_pool_release_rcu(struct rcu_head *head)
> > +{
> > +       struct zswap_pool *pool =3D container_of(head, typeof(*pool), r=
cu_head);
> > +
> > +       /*
> > +        * The grace period has elapsed, so no RCU reader can still obs=
erve the
> > +        * pool through the list it was removed from in __zswap_pool_em=
pty().
> > +        * Hand off to a worker for the sleepable teardown, since this =
callback
> > +        * runs in softirq context.
> > +        */
>
> Oh I didn't realize that call_rcu() cannot be used with blocking
> callbacks, sorry about that. What about queue_rcu_work()? Seems like
> if we use that we can drop the intermediary callback?
Thanks, that's a good idea.  queue_rcu_work() is a better fit for this
pattern and avoids the extra callback, so I will switch to it in the next
version.

Best regards,
Jianyue

