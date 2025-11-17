Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC6DCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16928E0018; Mon, 17 Nov 2025 10:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6AC8E0002; Mon, 17 Nov 2025 10:20:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E4A8E0018; Mon, 17 Nov 2025 10:20:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFDA58E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:20:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D52A1DF0BE
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:20:02 +0000 (UTC)
X-FDA: 84120459444.24.EDB9DB7
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 79BB0A0017
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:20:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LPr7Ku9H;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=bgeffon@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763392800; a=rsa-sha256;
	cv=none;
	b=EtMxXIjp6uie2Xd1PiMAVrah2V42vuFRTBwTr6+0pia6V47Oq/wsei0l2Bsv2GFL9jyICh
	p3D2lUZIcXnkW9zWs4Xxtaai5FTKezF/XQTdVPQ6NWG1AXy2H3/Aju32yyGWvu1Apa1Epl
	QtOrRm6JGMiS/weq+Z5TKrgFvqy8/+U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LPr7Ku9H;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=bgeffon@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763392800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJ7egRaDVNMSInh9i7/SneIXMiAUZjbeT4p3WDUmNAc=;
	b=wwLHU2rkLyh5vCkx/ctoAXJT1lJpqvnFsOuZTiPJKJQr9gUceHiVq/6i1+Zvd7stHLmTM+
	Bae3HdeGRFsggTIHit9Tzp1eAhapVcv41n4V6nlR/K59Hecr6tLZ+L+ByJJHHAYY6QYB+A
	sMeR28gnhD5SElA9/4AwXFE6Q9aS46U=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29852dafa7dso357705ad.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 07:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763392799; x=1763997599; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aJ7egRaDVNMSInh9i7/SneIXMiAUZjbeT4p3WDUmNAc=;
        b=LPr7Ku9HcvgN7YfXAOLXhz6pIkChwCDd0XhWY10Puq5HTC8m4i655DrsqPkl7gTGJv
         +3K0J8/jxjlqNFmwcS0tIe82NGMWEi1gmZ4h7ozD3S+1j/NtdxU8rk2DNd0YvN/njpls
         2f5XuXqaSgKo4MM55A7XEqYvLcs2O20mhIIv+Y90l5RHa0VUlKx7jIJEN8iTcy+ZRKRU
         C3Xdh0TSP73INX4xG8OZk7H/etMS7FPbVWd0CYKgZQFZz+0oqvAVj4ZybRG4lHJTpAtw
         v+pkd362SqdKV5puXbVdcyekoyJltrgJDOkXK951rgkn5hi99p2aPhCvPVdi7F6dsmOG
         LpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763392799; x=1763997599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aJ7egRaDVNMSInh9i7/SneIXMiAUZjbeT4p3WDUmNAc=;
        b=B3wXocLuNo22u7ufa71QDJwdZj4X0O09mWBjH3vo3CgX2yn3pskN0ycMTWOraHuAp4
         7DDJn4bmCPCTZ2aba+lsYSxs6M34V86PWpmkp9bnIPUoMvnQ8yP5Vqdmxu1zYa55F8dy
         YQAL8URVGhfdyzaG3vXNPDhmoEMpWZNApHY2zTMziq1SRDGk0lLORhGlN2otOTKSPq2S
         w/pENlqP3SVxHN3GVmZG09Cl9isR3rNPZD6gYFdyxMFf/Nclu7Y7sFVpyj4Hm/lGHePV
         Zot+9lURkyej+6YdQwk3PPVT8ox71YUNGyJ10MId/CIdiSUPRDn+WokwMeyakB/S50d/
         wgiA==
X-Forwarded-Encrypted: i=1; AJvYcCWZQEc6sFZPBeAL5abQYMhagVMGbOBcu8NqlH/QWjZESaj+/thrCpYwxuVi0iqBmjFmMmDUEm1mcg==@kvack.org
X-Gm-Message-State: AOJu0YwhiRzvrqs7gjN5YNx8s3xGmsAi+zBLtniK4hh9kuuvYIhYYH3q
	v2Gulr2SN6fMFnLsCdhAWY61G/RNe5UZ2Th9gVpkGogQWt5GkIZOT1qCFLYLIdVw5CPjxuI8rz8
	V2Aj79W8svRTGv/lwxU8lXZ1hauRhpG5XptS4f1Zp
X-Gm-Gg: ASbGncuVzPrrQOo+Gu+zC01PPIthaFUun72ifOTqkq61med6ilfa/AZlyzQugIOt2ms
	Nqwu0a2yi/mp/Qx9FF6J2jaCQolWeh6HZs2sLSivYmV87X3L9ZLbXMJLTtTyFpeurfBtwa5ay++
	U5BsUPY2fyGXe8sMfHssR8YTSCrrMBSN5dvVzC5i4jvXeieRBynKA81T7TBKpSX+Q7gGXO0JRnp
	84fIOyGVtdM6QFCM5C+i25t+QvzKZxAC39BmaBiN0yVPj+YSL9snAqUvDXY29/tZKQJGwhgXB1+
	jQJFsgkkq0LN4Ex/RywhFq/5VBHV8jtSX3qACK6NUCrqIemiS0Zv1YE=
X-Google-Smtp-Source: AGHT+IFmPbwHa2zdBPFZu54nsAiHmjGzULvhKyvC/0mCK6Fve2sI66TMcNqWFEno0cy2V8XtILG9bMhNxBzcDPxJXoA=
X-Received: by 2002:a17:902:d4cd:b0:294:f745:fe7b with SMTP id
 d9443c01a7336-299f4a3eafemr75ad.6.1763392798956; Mon, 17 Nov 2025 07:19:58
 -0800 (PST)
MIME-Version: 1.0
References: <20251115023447.495417-1-senozhatsky@chromium.org> <20251115023447.495417-2-senozhatsky@chromium.org>
In-Reply-To: <20251115023447.495417-2-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Mon, 17 Nov 2025 10:19:22 -0500
X-Gm-Features: AWmQ_blDTLoax8uxJhl4MtvN07CDRxv9gzuW7M7HtQx4zJ9mZPC5heCRHsy0Xws
Message-ID: <CADyq12zxzi+t727B5sm5z-z3SmRQyMDOmr_tTG1GaMVh6VTWbw@mail.gmail.com>
Subject: Re: [PATCHv3 1/4] zram: introduce writeback bio batching support
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 79BB0A0017
X-Stat-Signature: 67qbje3ww5aiz3usq7aea6upxftuypcf
X-HE-Tag: 1763392800-396226
X-HE-Meta: U2FsdGVkX1/8OMR5UnTDJqLkYojGdypVU5p2S+bSJZ5IlWCZorTESUuYSaWGn09AM8B34Zsm/uFPym6tnnvDCyHk/YdhuL70edTkCA8q95H4LizvLYdasyLdU4SQPHhgDmvc64BZkPZZKkbkq4LkVo1jGVO+7r1Wv4GBe0T6UXtjfWuToY1T5WrO7Xq0gW8uoHw9tDmRH8PY0vBQG6GVFzMV51ayf5dshoK3Z99qgfCWoAQsdC+l6y57nFp77iE1f5m2HS+ch17+3ELXe9m8KMjC/UAts8v0cDgkRMb9yhVfrlJdjPBIk4B1EcOmP00CLiPH0o47phUVFJTu+J/QV4z+uEmJVMn9Ar1MRigfzf/xlrxLJY2G/nTBruWghtIJnxCFyNRqESyDnnXZRAG5OoXEiw6iUmiSFvcXyx92dudrI5RHfRTy3g61NWeEmECC71GmA17GfMkuUYuFLDlvSNWQ6yyaxWUInlYMxCgL82JlJwIKcvIxqTbEMreKJ5mHZv8H/H+GCnCtEBa+wOciDaiBCwaoAF/Sx4PSy+xD+Q4D3bCQ9bZVbiwLN26kb8pmMR+WeH/Mg4c+6MNlD7Xpx0+kq6tjGIHHcz7bIkQXskrahV3TITusICo+1347FfbAA90fXYQzwG++OLpJ/ywtnNtet53SpZrsG00DPmoYqnQNkGgu4QC6qXSQCnSWdkePkoBmqvdIirdVKmMTcYZuRPbR8opxleeLMrjgCVIs/bWTT1jodRLWOF3A25TH78Q2AtzZUAzHXAWyfRzD0EKRKXZD3Q2UD67SXMjZ30kXZ1S+ylwq96YGe2j0VFOonhPacayOwJvJh1CaNmwvpJqM3IlN8KxgwmQgj+mDxuox2iKr+cJiKH97vfrC7vThB6AHHg+UCykhfQJDKTEJ2pQsY2fXVbZYVl9h65+ZOh3e0btrk6LF8JSWE9rnaABJBNsythUlih54BHICXwStDzk
 FrpKgOXr
 4fr+cUhMW3GPaYTRc0R6/oYYPKqArzPcr+5KDmUii/DCIuUp05Re+jalaP8koTez+qW29vVjaxYhzba+Od4ciy4WQZLq7L+XHF63yUJ6Bjk/csO3Gdfd6AJurIdAu97veueTqysJWlPtyqguJhkTlQqRmYPa66jSO2bFr3bSb1mM8DJg2QL2yxIot7ARPSgFq3Zb5lj89b0ZXCDqJbHRbOxYA7+SSxlaXlBM40lfQe5uLLXk+XDSHQ3kMkpDchlfzLccwEcc/h+HVG2/bBKrspTsY5Mmz0bLjaY+1cIQa67WyLtVs8smg0Wo2t6U0hiXR3hhLI+HydrD97JVYZEEFMD7m8ecmozJ1cIhb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 9:35=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> From: Yuwen Chen <ywen.chen@foxmail.com>
>
> Currently, zram writeback supports only a single bio writeback
> operation, waiting for bio completion before post-processing
> next pp-slot.  This works, in general, but has certain throughput
> limitations.  Implement batched (multiple) bio writeback support
> to take advantage of parallel requests processing and better
> requests scheduling.
>
> For the time being the writeback batch size (maximum number of
> in-flight bio requests) is set to 32 for all devices.  A follow
> up patch adds a writeback_batch_size device attribute, so the
> batch size becomes run-time configurable.
>
> Please refer to [1] and [2] for benchmarks.
>
> [1] https://lore.kernel.org/linux-block/tencent_B2DC37E3A2AED0E7F179365FC=
B5D82455B08@qq.com
> [2] https://lore.kernel.org/linux-block/tencent_0FBBFC8AE0B97BC63B5D47CE1=
FF2BABFDA09@qq.com
>
> [senozhatsky: significantly reworked the initial patch so that the
> approach and implementation resemble current zram post-processing
> code]
>
> Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Co-developed-by: Richard Chang <richardycc@google.com>
> Suggested-by: Minchan Kim <minchan@google.com>
> ---
>  drivers/block/zram/zram_drv.c | 343 +++++++++++++++++++++++++++-------
>  1 file changed, 277 insertions(+), 66 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index a43074657531..84e72c3bb280 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -500,6 +500,24 @@ static ssize_t idle_store(struct device *dev,
>  }
>
>  #ifdef CONFIG_ZRAM_WRITEBACK
> +struct zram_wb_ctl {
> +       struct list_head idle_reqs;
> +       struct list_head inflight_reqs;
> +
> +       atomic_t num_inflight;
> +       struct completion done;
> +};
> +
> +struct zram_wb_req {
> +       unsigned long blk_idx;
> +       struct page *page;
> +       struct zram_pp_slot *pps;
> +       struct bio_vec bio_vec;
> +       struct bio bio;
> +
> +       struct list_head entry;
> +};
> +
>  static ssize_t writeback_limit_enable_store(struct device *dev,
>                 struct device_attribute *attr, const char *buf, size_t le=
n)
>  {
> @@ -734,20 +752,207 @@ static void read_from_bdev_async(struct zram *zram=
, struct page *page,
>         submit_bio(bio);
>  }
>
> -static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *c=
tl)
> +static void release_wb_req(struct zram_wb_req *req)
> +{
> +       __free_page(req->page);
> +       kfree(req);
> +}
> +
> +static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
> +{
> +       /* We should never have inflight requests at this point */
> +       WARN_ON(!list_empty(&wb_ctl->inflight_reqs));
> +
> +       while (!list_empty(&wb_ctl->idle_reqs)) {
> +               struct zram_wb_req *req;
> +
> +               req =3D list_first_entry(&wb_ctl->idle_reqs,
> +                                      struct zram_wb_req, entry);
> +               list_del(&req->entry);
> +               release_wb_req(req);
> +       }
> +
> +       kfree(wb_ctl);
> +}
> +
> +/* XXX: should be a per-device sysfs attr */
> +#define ZRAM_WB_REQ_CNT 32
> +
> +static struct zram_wb_ctl *init_wb_ctl(void)
> +{
> +       struct zram_wb_ctl *wb_ctl;
> +       int i;
> +
> +       wb_ctl =3D kmalloc(sizeof(*wb_ctl), GFP_KERNEL);
> +       if (!wb_ctl)
> +               return NULL;
> +
> +       INIT_LIST_HEAD(&wb_ctl->idle_reqs);
> +       INIT_LIST_HEAD(&wb_ctl->inflight_reqs);
> +       atomic_set(&wb_ctl->num_inflight, 0);
> +       init_completion(&wb_ctl->done);
> +
> +       for (i =3D 0; i < ZRAM_WB_REQ_CNT; i++) {
> +               struct zram_wb_req *req;
> +
> +               /*
> +                * This is fatal condition only if we couldn't allocate
> +                * any requests at all.  Otherwise we just work with the
> +                * requests that we have successfully allocated, so that
> +                * writeback can still proceed, even if there is only one
> +                * request on the idle list.
> +                */
> +               req =3D kzalloc(sizeof(*req), GFP_KERNEL | __GFP_NOWARN);
> +               if (!req)
> +                       break;
> +
> +               req->page =3D alloc_page(GFP_KERNEL | __GFP_NOWARN);
> +               if (!req->page) {
> +                       kfree(req);
> +                       break;
> +               }
> +
> +               list_add(&req->entry, &wb_ctl->idle_reqs);
> +       }
> +
> +       /* We couldn't allocate any requests, so writeabck is not possibl=
e */
> +       if (list_empty(&wb_ctl->idle_reqs))
> +               goto release_wb_ctl;
> +
> +       return wb_ctl;
> +
> +release_wb_ctl:
> +       release_wb_ctl(wb_ctl);
> +       return NULL;
> +}
> +
> +static void zram_account_writeback_rollback(struct zram *zram)
>  {
> +       spin_lock(&zram->wb_limit_lock);
> +       if (zram->wb_limit_enable)
> +               zram->bd_wb_limit +=3D  1UL << (PAGE_SHIFT - 12);
> +       spin_unlock(&zram->wb_limit_lock);
> +}
> +
> +static void zram_account_writeback_submit(struct zram *zram)
> +{
> +       spin_lock(&zram->wb_limit_lock);
> +       if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
> +               zram->bd_wb_limit -=3D  1UL << (PAGE_SHIFT - 12);
> +       spin_unlock(&zram->wb_limit_lock);
> +}
> +
> +static int zram_writeback_complete(struct zram *zram, struct zram_wb_req=
 *req)
> +{
> +       u32 index;
> +       int err;
> +
> +       index =3D req->pps->index;
> +       release_pp_slot(zram, req->pps);
> +       req->pps =3D NULL;
> +
> +       err =3D blk_status_to_errno(req->bio.bi_status);
> +       if (err) {
> +               /*
> +                * Failed wb requests should not be accounted in wb_limit
> +                * (if enabled).
> +                */
> +               zram_account_writeback_rollback(zram);
> +               return err;
> +       }
> +
> +       atomic64_inc(&zram->stats.bd_writes);
> +       zram_slot_lock(zram, index);
> +       /*
> +        * We release slot lock during writeback so slot can change under=
 us:
> +        * slot_free() or slot_free() and zram_write_page(). In both case=
s
> +        * slot loses ZRAM_PP_SLOT flag. No concurrent post-processing ca=
n
> +        * set ZRAM_PP_SLOT on such slots until current post-processing
> +        * finishes.
> +        */
> +       if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
> +               goto out;
> +
> +       zram_free_page(zram, index);
> +       zram_set_flag(zram, index, ZRAM_WB);
> +       zram_set_handle(zram, index, req->blk_idx);
> +       atomic64_inc(&zram->stats.pages_stored);
> +
> +out:
> +       zram_slot_unlock(zram, index);
> +       return 0;
> +}
> +
> +static void zram_writeback_endio(struct bio *bio)
> +{
> +       struct zram_wb_ctl *wb_ctl =3D bio->bi_private;
> +
> +       if (atomic_dec_return(&wb_ctl->num_inflight) =3D=3D 0)
> +               complete(&wb_ctl->done);
> +}
> +
> +static void zram_submit_wb_request(struct zram *zram,
> +                                  struct zram_wb_ctl *wb_ctl,
> +                                  struct zram_wb_req *req)
> +{
> +       /*
> +        * wb_limit (if enabled) should be adjusted before submission,
> +        * so that we don't over-submit.
> +        */
> +       zram_account_writeback_submit(zram);
> +       atomic_inc(&wb_ctl->num_inflight);
> +       list_add_tail(&req->entry, &wb_ctl->inflight_reqs);
> +       submit_bio(&req->bio);
> +}
> +
> +static struct zram_wb_req *select_idle_req(struct zram_wb_ctl *wb_ctl)
> +{
> +       struct zram_wb_req *req;
> +
> +       req =3D list_first_entry_or_null(&wb_ctl->idle_reqs,
> +                                      struct zram_wb_req, entry);
> +       if (req)
> +               list_del(&req->entry);
> +       return req;
> +}
> +
> +static int zram_wb_wait_for_completion(struct zram *zram,
> +                                      struct zram_wb_ctl *wb_ctl)
> +{
> +       int ret =3D 0;
> +
> +       if (atomic_read(&wb_ctl->num_inflight))
> +               wait_for_completion_io(&wb_ctl->done);
> +
> +       reinit_completion(&wb_ctl->done);
> +       while (!list_empty(&wb_ctl->inflight_reqs)) {
> +               struct zram_wb_req *req;
> +               int err;
> +
> +               req =3D list_first_entry(&wb_ctl->inflight_reqs,
> +                                      struct zram_wb_req, entry);
> +               list_move(&req->entry, &wb_ctl->idle_reqs);
> +
> +               err =3D zram_writeback_complete(zram, req);
> +               if (err)
> +                       ret =3D err;
> +       }
> +
> +       return ret;
> +}
> +
> +static int zram_writeback_slots(struct zram *zram,
> +                               struct zram_pp_ctl *ctl,
> +                               struct zram_wb_ctl *wb_ctl)
> +{
> +       struct zram_wb_req *req =3D NULL;
>         unsigned long blk_idx =3D 0;
> -       struct page *page =3D NULL;
>         struct zram_pp_slot *pps;
> -       struct bio_vec bio_vec;
> -       struct bio bio;
> +       struct blk_plug io_plug;
>         int ret =3D 0, err;
> -       u32 index;
> -
> -       page =3D alloc_page(GFP_KERNEL);
> -       if (!page)
> -               return -ENOMEM;
> +       u32 index =3D 0;
>
> +       blk_start_plug(&io_plug);
>         while ((pps =3D select_pp_slot(ctl))) {
>                 spin_lock(&zram->wb_limit_lock);
>                 if (zram->wb_limit_enable && !zram->bd_wb_limit) {
> @@ -757,6 +962,26 @@ static int zram_writeback_slots(struct zram *zram, s=
truct zram_pp_ctl *ctl)
>                 }
>                 spin_unlock(&zram->wb_limit_lock);
>
> +               while (!req) {
> +                       req =3D select_idle_req(wb_ctl);
> +                       if (req)
> +                               break;
> +
> +                       blk_finish_plug(&io_plug);
> +                       err =3D zram_wb_wait_for_completion(zram, wb_ctl)=
;
> +                       blk_start_plug(&io_plug);
> +                       /*
> +                        * BIO errors are not fatal, we continue and simp=
ly
> +                        * attempt to writeback the remaining objects (pa=
ges).
> +                        * At the same time we need to signal user-space =
that
> +                        * some writes (at least one, but also could be a=
ll of
> +                        * them) were not successful and we do so by retu=
rning
> +                        * the most recent BIO error.
> +                        */
> +                       if (err)
> +                               ret =3D err;
> +               }
> +
>                 if (!blk_idx) {
>                         blk_idx =3D alloc_block_bdev(zram);
>                         if (!blk_idx) {
> @@ -765,7 +990,6 @@ static int zram_writeback_slots(struct zram *zram, st=
ruct zram_pp_ctl *ctl)
>                         }
>                 }
>
> -               index =3D pps->index;
>                 zram_slot_lock(zram, index);
>                 /*
>                  * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, =
so
> @@ -775,67 +999,46 @@ static int zram_writeback_slots(struct zram *zram, =
struct zram_pp_ctl *ctl)
>                  */
>                 if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
>                         goto next;
> -               if (zram_read_from_zspool(zram, page, index))
> +               if (zram_read_from_zspool(zram, req->page, index))
>                         goto next;
>                 zram_slot_unlock(zram, index);
>
> -               bio_init(&bio, zram->bdev, &bio_vec, 1,
> -                        REQ_OP_WRITE | REQ_SYNC);
> -               bio.bi_iter.bi_sector =3D blk_idx * (PAGE_SIZE >> 9);
> -               __bio_add_page(&bio, page, PAGE_SIZE, 0);
> -
>                 /*
> -                * XXX: A single page IO would be inefficient for write
> -                * but it would be not bad as starter.
> +                * From now on pp-slot is owned by the req, remove it fro=
m
> +                * its pp bucket.
>                  */
> -               err =3D submit_bio_wait(&bio);
> -               if (err) {
> -                       release_pp_slot(zram, pps);
> -                       /*
> -                        * BIO errors are not fatal, we continue and simp=
ly
> -                        * attempt to writeback the remaining objects (pa=
ges).
> -                        * At the same time we need to signal user-space =
that
> -                        * some writes (at least one, but also could be a=
ll of
> -                        * them) were not successful and we do so by retu=
rning
> -                        * the most recent BIO error.
> -                        */
> -                       ret =3D err;
> -                       continue;
> -               }
> +               list_del_init(&pps->entry);
>
> -               atomic64_inc(&zram->stats.bd_writes);
> -               zram_slot_lock(zram, index);
> -               /*
> -                * Same as above, we release slot lock during writeback s=
o
> -                * slot can change under us: slot_free() or slot_free() a=
nd
> -                * reallocation (zram_write_page()). In both cases slot l=
oses
> -                * ZRAM_PP_SLOT flag. No concurrent post-processing can s=
et
> -                * ZRAM_PP_SLOT on such slots until current post-processi=
ng
> -                * finishes.
> -                */
> -               if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
> -                       goto next;
> +               req->blk_idx =3D blk_idx;
> +               req->pps =3D pps;
> +               bio_init(&req->bio, zram->bdev, &req->bio_vec, 1, REQ_OP_=
WRITE);
> +               req->bio.bi_iter.bi_sector =3D req->blk_idx * (PAGE_SIZE =
>> 9);
> +               req->bio.bi_end_io =3D zram_writeback_endio;
> +               req->bio.bi_private =3D wb_ctl;
> +               __bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);

Out of curiosity, why are we doing 1 page per bio? Why are we not
adding BIO_MAX_VECS before submitting? And then, why are we not
chaining? Do the block layer maintainers have thoughts?

>
> -               zram_free_page(zram, index);
> -               zram_set_flag(zram, index, ZRAM_WB);
> -               zram_set_handle(zram, index, blk_idx);
> +               zram_submit_wb_request(zram, wb_ctl, req);
>                 blk_idx =3D 0;
> -               atomic64_inc(&zram->stats.pages_stored);
> -               spin_lock(&zram->wb_limit_lock);
> -               if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
> -                       zram->bd_wb_limit -=3D  1UL << (PAGE_SHIFT - 12);
> -               spin_unlock(&zram->wb_limit_lock);
> +               req =3D NULL;
> +               continue;
> +
>  next:
>                 zram_slot_unlock(zram, index);
>                 release_pp_slot(zram, pps);
> -
>                 cond_resched();
>         }
>
> -       if (blk_idx)
> -               free_block_bdev(zram, blk_idx);
> -       if (page)
> -               __free_page(page);
> +       /*
> +        * Selected idle req, but never submitted it due to some error or
> +        * wb limit.
> +        */
> +       if (req)
> +               release_wb_req(req);
> +
> +       blk_finish_plug(&io_plug);
> +       err =3D zram_wb_wait_for_completion(zram, wb_ctl);
> +       if (err)
> +               ret =3D err;
>
>         return ret;
>  }
> @@ -948,7 +1151,8 @@ static ssize_t writeback_store(struct device *dev,
>         struct zram *zram =3D dev_to_zram(dev);
>         u64 nr_pages =3D zram->disksize >> PAGE_SHIFT;
>         unsigned long lo =3D 0, hi =3D nr_pages;
> -       struct zram_pp_ctl *ctl =3D NULL;
> +       struct zram_pp_ctl *pp_ctl =3D NULL;
> +       struct zram_wb_ctl *wb_ctl =3D NULL;
>         char *args, *param, *val;
>         ssize_t ret =3D len;
>         int err, mode =3D 0;
> @@ -970,8 +1174,14 @@ static ssize_t writeback_store(struct device *dev,
>                 goto release_init_lock;
>         }
>
> -       ctl =3D init_pp_ctl();
> -       if (!ctl) {
> +       pp_ctl =3D init_pp_ctl();
> +       if (!pp_ctl) {
> +               ret =3D -ENOMEM;
> +               goto release_init_lock;
> +       }
> +
> +       wb_ctl =3D init_wb_ctl();
> +       if (!wb_ctl) {
>                 ret =3D -ENOMEM;
>                 goto release_init_lock;
>         }
> @@ -1000,7 +1210,7 @@ static ssize_t writeback_store(struct device *dev,
>                                 goto release_init_lock;
>                         }
>
> -                       scan_slots_for_writeback(zram, mode, lo, hi, ctl)=
;
> +                       scan_slots_for_writeback(zram, mode, lo, hi, pp_c=
tl);
>                         break;
>                 }
>
> @@ -1011,7 +1221,7 @@ static ssize_t writeback_store(struct device *dev,
>                                 goto release_init_lock;
>                         }
>
> -                       scan_slots_for_writeback(zram, mode, lo, hi, ctl)=
;
> +                       scan_slots_for_writeback(zram, mode, lo, hi, pp_c=
tl);
>                         break;
>                 }
>
> @@ -1022,7 +1232,7 @@ static ssize_t writeback_store(struct device *dev,
>                                 goto release_init_lock;
>                         }
>
> -                       scan_slots_for_writeback(zram, mode, lo, hi, ctl)=
;
> +                       scan_slots_for_writeback(zram, mode, lo, hi, pp_c=
tl);
>                         continue;
>                 }
>
> @@ -1033,17 +1243,18 @@ static ssize_t writeback_store(struct device *dev=
,
>                                 goto release_init_lock;
>                         }
>
> -                       scan_slots_for_writeback(zram, mode, lo, hi, ctl)=
;
> +                       scan_slots_for_writeback(zram, mode, lo, hi, pp_c=
tl);
>                         continue;
>                 }
>         }
>
> -       err =3D zram_writeback_slots(zram, ctl);
> +       err =3D zram_writeback_slots(zram, pp_ctl, wb_ctl);
>         if (err)
>                 ret =3D err;
>
>  release_init_lock:
> -       release_pp_ctl(zram, ctl);
> +       release_pp_ctl(zram, pp_ctl);
> +       release_wb_ctl(wb_ctl);
>         atomic_set(&zram->pp_in_progress, 0);
>         up_read(&zram->init_lock);
>
> --
> 2.52.0.rc1.455.g30608eb744-goog
>

