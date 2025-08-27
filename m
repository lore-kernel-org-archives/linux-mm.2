Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D421CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 20:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0F18E000B; Wed, 27 Aug 2025 16:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850808E0001; Wed, 27 Aug 2025 16:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718018E000B; Wed, 27 Aug 2025 16:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3628E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:49:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E1531A0847
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:49:36 +0000 (UTC)
X-FDA: 83823728352.24.02A44E3
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 57BC740008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:49:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CNCtygKn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756327774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jL5nmh3ppB78QbIn88NC3T1+26pYSI02adD9xwWXt+A=;
	b=gzEtQH2qOx8mgkFuo3G/BR65+tGNcQhdZ9icvMbvIna2DerjlvQKELobSKSzYuNNZXw6ib
	HRg+Ug1UF192TXLW5xobhH50hGHC2zwL0dkpT8GGgLHQwmdfKsROb5HBf3EEUYnU0nowC5
	dHBGT5P7YH25k0fupZxQV7F1xttI220=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CNCtygKn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756327774; a=rsa-sha256;
	cv=none;
	b=kOj+65C7etxTjTRwe8wbZGwAk6J3eFbKRwU592rm/Mr1VfzCW5DQbYhSMqeQ8oeg1T2x+W
	rzG1WeGn/crpB/JhjQ1QHLJd8pai8uCW5ZfT26AFUKpzrtvkFQKzAzxvNokwbYnawBxdNU
	d22iDk66ZcXBBk/wLpUnJxz5D41Y6Xo=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71d6083cc69so2010447b3.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756327773; x=1756932573; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jL5nmh3ppB78QbIn88NC3T1+26pYSI02adD9xwWXt+A=;
        b=CNCtygKng1+rhGpLupJkcgXdjDYM99wbQy3dWwXs81qaNfvInQPkvcT2qukHo2Lykn
         rTZ9gOsJeuBoZFxBd8s/cOp+ADdXDLMKwHkvimvMuFhe5K6xquOsfgpDsehJYFiK8H7I
         akOqElcH++4w9Zm6fgk53NZYQJPr+KDvZ5YDRSR+3qmtbG3MaI9ZOYAVvIg2Dx+SzJB6
         D12EXAmD0j5Y1OuCCyaQgcMZDzOjOrhjb3mWILzTw9edXkX4PIV5X0m5kGA/bf7gzKKs
         1etW7d1JGBou4p1WNE4ODKee3AYR2BGqKWd1kzCC+Pwwq3jJcNOqHcaNJ3FOBlRbUdvO
         YbAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756327773; x=1756932573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jL5nmh3ppB78QbIn88NC3T1+26pYSI02adD9xwWXt+A=;
        b=XexXxFgTWTf98AmgqxgOdgKY/jp50JDm9CyENch2qFKF0GFlHPYpanxsH0sXivEEI2
         JG59zlUHVOkkg2I/zYP3zXqze6N+86yRio6FZ/Oas737jiDRUlfMxRz/ivupNX4H3J0G
         WD/q7x3KjhE33uG1lO7neBRTswIAtuZmzrh03yspiBAqzpE1ag8rZE0ZgSrw4Z6XYYX9
         f33BrnrfBn+xUl+Rs4Fs1oTvGJQ94qGvOEkRgb8NTB9+Nn3bacOBRDq+cB9SNOWQVHRq
         wncYPR3ii9oyxkcUNGn75hQ0k1L4tC9KglKBWkdvhTn1AXqkcen9x79DQ1O3mH+ZKprO
         MJQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuJ62bge7TucZPOAz1v1sMIjy7dZ33ql5St0VDZaOWU0kdRvwwaEOK1ajedupkYSawosTt0FyVkw==@kvack.org
X-Gm-Message-State: AOJu0Yyzr+wvxQIISiUtF1zJSWpgHXTqzjpMeimnI59paaoR06esWRcR
	uCWX0Uv+kMehRix2M+RRtEky+6a3zhnX9uj32zJilJIm4+fqLZ/Q8bFdefTuY1zYW8bY9O1TPdt
	PHhtOwOc/V5n2mBHwirsAK06AA+wg0arskQE7SnF6sg==
X-Gm-Gg: ASbGncvRE/TAmqi6RISQZAR37fgQNtHvUHLbN6xKgHJa7ENKLJs+/pasGHSvc5U+bEs
	UWEnQ+uy7JiZYLINWHbZKXxqPIaG8nXQFA16p05Jqmbh7tm19OFvRiIdZh5H3dBoim8KTRkEvcJ
	zOGnf+7BLBXzh9thQD245T/B6v67bdoFYam8FrOQeqw+90oIpdHmqdUpK6VmG288iURj8vYKu3K
	W6Zx3U5n9jCmik=
X-Google-Smtp-Source: AGHT+IErdZgRCjak1/43G3fss7a4blvCSHpFjkeSAzDtkW7++OZEHp6XaMKL3yuc2S41gwxWI7nwYUFv7tudGUczZNU=
X-Received: by 2002:a05:690c:64c8:b0:720:c20:dc29 with SMTP id
 00721157ae682-7200c20e1acmr142076817b3.51.1756327773245; Wed, 27 Aug 2025
 13:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250827181356.40971-1-sunjunchao@bytedance.com> <aK9VTIQDA8I2vvNi@slm.duckdns.org>
In-Reply-To: <aK9VTIQDA8I2vvNi@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Thu, 28 Aug 2025 04:49:22 +0800
X-Gm-Features: Ac12FXyckmPI8HU5FEqVYGnTf_NT6hjEd-E6J_bWqEanR5Qe3yKWLiMZ0Gc7fyo
Message-ID: <CAHSKhtcqDfQRf1PAVkkR1mfD7AicfFVELM+Y87vzTMZsjCzTWA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v3] memcg: Don't wait writeback completion
 when release memcg.
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, 
	muchun.song@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 57BC740008
X-Stat-Signature: gnqxp6nsuh18aqix1deyj1wdgfrugyr8
X-Rspam-User: 
X-HE-Tag: 1756327774-601468
X-HE-Meta: U2FsdGVkX1+aANYK2ZUN0vBK7VT/ZWWa51QsgPwZMriZog5FDaKWK9AtFy0zKgOnu4gi3fROK2m3J5QfasPVPwqEAxtiDKkUmXe/nEuj8cUEcuxqZot2SYkkAiV0yEklh88TXfyakOo6b8kDDebJBxXs6Tiy73V0u4hYQTSshgXHho0LFehV/fpzLm2CcclsEpWTSYOXkI60gTj04Uy6gI308Lso6ky3LfIBLchW3mWs9yMVtuIcVgojLFEnr7awrBc0YL05SSJ+A7HVsW3dFBQ6m4tc3GEI7d4tcvUs1QTb/21Ob3OD9GnbZ/Lcn3ET94MZwY7USvOwuc7xGe3Gsi0eJ4geHHLWRlWrmNEIFFgqAgo0t9anw/wIUcMd26YXkfSTdtPiJDPPapxux7miXqpZ6j0HwTl9omlXccjsM7Ae61CJh14za60LoTndrvpUEwd7YhGOsXa/nkAXuOISZ9O5FEBSFQTV2dJ5d5p+2Of0IwEBIt16vIxrBrCW1PfgSs+Lkk6au5ZZRxZAh8MgTECUvGPgfbfBkYxUvwXtKttcvFRNuPttBNtJCD0Nxuo9UFSy4wajDpn1mT6YiR9VxjcvRCPZV0hCL9t08f6uWf8t/jdYeAezhQJgUyLpqcTiqYImZx7HmrM2A2i32puvA2NGd/WZ0ZilyNByD+m5MdvJ8LpUaAc0Y5kDfSIk4QpP7bI78MT5HaQOzjNSPWunyEnp8LExTSdYRoQl4KHCik6/XGUeBec6a1x/X2sD/V773eMExn/zRwF7qnVRVIvetqbQwwe3pssHrOZhztUMcA9qNJzVFPdvZwsb5Si85F+JIv5fzhtLaQv0kyFs59d+eAHcQgMjS2TIaMgswkuxM47XJ7VyE/Va+TtzOZJSolj1xLQLK6BVH+xEP0b2QYgjlpyXL5+nPba/nQ+45m3nR22rE1QrAgOlWOfa7nMcFYQMRb39aNSrSh5l7jzuL8Z
 N2Gt/85h
 A+zyE6n98H1FbxgWJ5JUlArjN+vwZJQ4F4A1t6NVYBjyRdYrYE4gWi6BamJlMOMQOS38l6sFdy3zK0oEYKNXtG2brd4bXySgbgYDizsMWoI/12OcDVpTXwQBEEnjc+EG3e2ImrQ5gNPasVXMW9pyh38gi7xu1OQP1VRfknD0g6yf9DArII+450DhGN6ZhYMYXAc/A49lZ+0zqLsM+4DF+uPHeJqO2TVhRKxrY1wIKWX4pYwNpoXXenqHn9h5HCqCN8tlVs5r6PCmoE7YPsfkCvEK99lX+R7b8FCIi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Aug 28, 2025 at 2:58=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Thu, Aug 28, 2025 at 02:13:56AM +0800, Julian Sun wrote:
> > diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-d=
ev-defs.h
> > index 2ad261082bba..6c1ed286da6a 100644
> > --- a/include/linux/backing-dev-defs.h
> > +++ b/include/linux/backing-dev-defs.h
> > @@ -65,6 +65,13 @@ struct wb_completion {
> >       wait_queue_head_t       *waitq;
> >  };
> >
> > +static inline void wb_completion_init(struct wb_completion *done,
> > +                                                                      =
 struct wait_queue_head *waitq)
>
> Indentation.
>
> > +{
> > +     atomic_set(&done->cnt, 1);
> > +     done->waitq =3D waitq;
> > +}
> > +
> >  #define __WB_COMPLETION_INIT(_waitq) \
> >       (struct wb_completion){ .cnt =3D ATOMIC_INIT(1), .waitq =3D (_wai=
tq) }
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 785173aa0739..24e881ce4909 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -157,11 +157,17 @@ struct mem_cgroup_thresholds {
> >   */
> >  #define MEMCG_CGWB_FRN_CNT   4
> >
> > +struct cgwb_frn_wait {
> > +     struct wb_completion done;
> > +     struct wait_queue_entry wq_entry;
> > +};
> > +
> >  struct memcg_cgwb_frn {
> >       u64 bdi_id;                     /* bdi->id of the foreign inode *=
/
> >       int memcg_id;                   /* memcg->css.id of foreign inode=
 */
> >       u64 at;                         /* jiffies_64 at the time of dirt=
ying */
> > -     struct wb_completion done;      /* tracks in-flight foreign write=
backs */
> > +     struct wb_completion *done;     /* tracks in-flight foreign write=
backs */
> > +     struct cgwb_frn_wait *wait;     /* used to free resources when re=
lease memcg */
>
> Is ->done still needed? Can't it just do frn->wait.done?
>
> > +#ifdef CONFIG_CGROUP_WRITEBACK
> > +static int memcg_cgwb_waitq_callback_fn(struct wait_queue_entry *wq_en=
try, unsigned int mode,
> > +                                     int flags, void *key)
> > +{
> > +     struct cgwb_frn_wait *frn_wait =3D container_of(wq_entry,
> > +                                                   struct cgwb_frn_wai=
t, wq_entry);
> > +
> > +     list_del(&wq_entry->entry);
> > +     kfree(frn_wait);
> > +
> > +     return 0;
> > +}
> > +#endif
>
> Note that the above will be called for all queued waits when any one entr=
y
> triggers. It'd need to check whether done is zero before self-deleting an=
d
> freeing.

Ah, yeah, it does need to.  Have sent v4 to fix it, thanks :)
>
> > @@ -3912,8 +3938,18 @@ static void mem_cgroup_css_free(struct cgroup_su=
bsys_state *css)
> >       int __maybe_unused i;
> >
> >  #ifdef CONFIG_CGROUP_WRITEBACK
> > -     for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++)
> > -             wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> > +     for (i =3D 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> > +             struct memcg_cgwb_frn *frn =3D &memcg->cgwb_frn[i];
> > +
> > +             if (atomic_dec_and_test(&frn->done->cnt))
> > +                     kfree(frn->wait);
> > +             else
> > +                     /*
> > +                      * Not necessary to wait for wb completion which =
might cause task hung,
> > +                      * only used to free resources. See memcg_cgwb_wa=
itq_callback_fn().
> > +                      */
> > +                     __add_wait_queue_entry_tail(frn->done->waitq, &fr=
n->wait->wq_entry);
> > +     }
>
> And then, this can probably be simplified to sth like:
>
>         __add_wait_queue_entry_tail(...);
>         if (atomic_dec_and_test(&frn->done->dnt);
>                 wake_up_all(waitq);
>
> Thanks.
>
> --
> tejun



--=20
Julian Sun <sunjunchao@bytedance.com>

