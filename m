Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA311CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 17:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F326B00F4; Mon, 11 May 2026 13:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA86E6B00F7; Mon, 11 May 2026 13:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C711B6B00F8; Mon, 11 May 2026 13:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B18B76B00F4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:09:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C6D0140183
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:09:08 +0000 (UTC)
X-FDA: 84755774376.28.B756432
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4686C1C0003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:09:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F3BF5iSl;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of gustavold@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=gustavold@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778519346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PoTJTh8yH+dfHf/ffCLrWvd3b1lXNOkP34ZrY3+mswY=;
	b=R3O7AQ/vaP4iMdXt/lQFM5Fbn/xpv8rhpwpLu0uOXwaFMd1/VSPk3i4BFYk75GN+cU3nqu
	oUB8SyoGBH2PufzzZaO+dgfXhBtvTg8B4IilDP2e5LJ7+tmDXJOEa/Z/JQs9431MwLJvZ6
	s43I34PZQbq9R03VmwFFL63S2CIO4CU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778519346; a=rsa-sha256;
	cv=pass;
	b=NIEjgpxtzxG9ySWluw2v/kwVpWPatC11GoT8bg93GMWJn2buJLotbZSiLaOhWWWtjwQHWn
	dmrqoKzkA6EX5VwYLe90JCtR8K40INk0f5voEakL5D6BJRt5HN+zZjliqkfGcWcxWmiNyD
	8W4j0L5VuH3nfoXZqtW5B3E1/oay12k=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F3BF5iSl;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of gustavold@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=gustavold@gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-66b0418ebe7so180592eaf.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 10:09:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778519345; cv=none;
        d=google.com; s=arc-20240605;
        b=L/2TN+TBB7JBatMWWaTI64I3WqytQYHyodF3SKuaamPSWwAqTsh3IjXhaROcjvUMz3
         Yz4AN3gGbpZWjoK8A2gNevfk3LsccousKSaVhPIv+uhmHQeYP67QnSPQogO+yxW9L1/U
         dSQpneF6ctPqtgIt2U3tgUHchG6DQGKBHpp/WxR2t8IftEKODmoDxKomjffhlaLSN4Ip
         a9HNzHJT84USpDxZhyA9EyLQiPm+1+ltRX16g071IP9LyYrsMz8QwD8OcygLWTokCR+T
         jaImTHkniOPMeH1jROYTV9DkuiVsSmh1CzLPx96Pn/Zzhy6y+VoROx/ygNPc75DqAi5y
         Zbtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PoTJTh8yH+dfHf/ffCLrWvd3b1lXNOkP34ZrY3+mswY=;
        fh=HIw2AdLo0sjoRWbwb9PK4uvOFLBdYv6Ei7s9usrp4ho=;
        b=PLk6bcckplxYv/1sREa6gyojJqu0BsAHrqmOjErUpD1TouYXyEJcO3Z5FkqS8AG/WS
         m/a5wTlTBqqM7qjG4cbvfhcQTGDKY9K4HIzDzybha8lulvrbR0Wih3mqtnl1xen51vSJ
         a9TA+HWLA/T6Xtcw4ZspNaIRLGgXLlItojpFB6zpB72jkjhdYA/S9AhTwvJyHnPSvur+
         wx3oLiEjTSOwYR7XcG5ceuc62jrUeoApZiF+Yi0DF90ReWn1AOn/d6lQv3HPJrvAAeL4
         zzg5GVmWgIoijT/ezJCMZbbQbB1X5R1FWI9g/57TMHfcef20knC+JTK3M4IJyQE+UEzp
         x66A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778519345; x=1779124145; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PoTJTh8yH+dfHf/ffCLrWvd3b1lXNOkP34ZrY3+mswY=;
        b=F3BF5iSlum9kGQoLlB3v8Uhnk5SauNuPPReg7duk8sOYnvOwwFlxcHl38AW3dPLgRT
         dpEqaurmEOiMvpv8xtcargnk4RdesAvfeqrPV/pU5P+JUyu5512Hcup/hN/TLrWXp3WG
         Ykq2H7wOj4q/j4QNg9pyMfwoezOYMKRq+Jd5dwmcdsHR4ZVzkzjIFOCGWPslyP8PHhXt
         W7PUJEvh/9QaSTzk9DkaeJ/wjs1NyZnQiMMyJDHZv9bR0F2QB79lDY6VGUJw7XYxHCTi
         P2SakKDSk6WRcsaQ5xB2eQzVvIcO7/yeT1Ahj/sszX6P1PHkm8/kuU9YnKNi3LOFXu0/
         1fkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778519345; x=1779124145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PoTJTh8yH+dfHf/ffCLrWvd3b1lXNOkP34ZrY3+mswY=;
        b=aZmhmDF3UWpJ5RRUDu07oRnsFWGyEPXsjBzIccy+N1NVkeLhuiQ69595Ct1YjAyORD
         f8D3DUJN8pnuDqEtlC9fLZzcz8gMpNTLht4I+AFKk9kF3ei/6O6tyX8qc42gmWB1b8OF
         4QXMF7zyAKKVKKGm7AcHLPKhjtUN3bwy0W2ISxCjSrYmorVLG3YWT1ldglEBxXieomWz
         s/pn/37fpQ+BZePsBQb2tFTcns2Sz1XbUUVCp3dz0N0yaAhIwsUiYb8CEyCSHwDaG1+u
         d1Ur2CZWk882N/sVYxaYsEWPWi/7EGo6kPLOL0D2J5tRDLhsbJaZDdoKooIIirXoZ9w2
         LRCQ==
X-Forwarded-Encrypted: i=1; AFNElJ/rDuhUeWTb5wdtNmjgNj60wScrOJZX7zdAJqZTv1ba2CPkPnOId4ZhhymodVloKte5QQ1V467K+g==@kvack.org
X-Gm-Message-State: AOJu0Yy757BjtrpL8OiwceKWjPHehyMVOnRsvhBxpMR1X+NGOr83+BLr
	OstRTXaMqovBViACocAgZg8eDvKBR5V8Peji3J3OJL3Yaz4VlhCXKA+0G4dkwpMMXlmvsnxtiy6
	m+vdxIYir9epUynwUhvxPX+gNDdf0R8g=
X-Gm-Gg: Acq92OFWTYNDVuLJnRlZVnv/uCiQ5JJvcAOnBvPEKCeyeR2H4IeF1D1jswWWXAm4Q+I
	Zqc4Q8QbUeTuyo/rrRNNJsODrudHO/K+T0srqJL/N6Gt39fxLN1CfH/P9nmPuhuX7e7K8Bif8Kn
	5G1TkeSb6jsoUCuS+cMvHH2IPAHk609ZBxJHHF9lbMyudHofTKD5mTVvJ6qnccK+CkI4eWJHq+h
	oTC+9FgouCsV0XFXFwppVE0GKgrmv9gydVzaD9kEQGVFU6tko2OUWAd74Y/9m1RtkRFR9o/jLBz
	FHdcTnHKfdYU0NNE8IVwOTFBI6IG/58jPQ==
X-Received: by 2002:a05:6808:1827:b0:467:53b0:b44d with SMTP id
 5614622812f47-4804518afd3mr9603396b6e.5.1778519345047; Mon, 11 May 2026
 10:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-rcu-pending-cbs-stats-v1-0-8f4eb3553bc9@gmail.com> <fd8b4470-930b-4688-b423-2e349f8c883f@nvidia.com>
In-Reply-To: <fd8b4470-930b-4688-b423-2e349f8c883f@nvidia.com>
From: Gustavo Luiz Duarte <gustavold@gmail.com>
Date: Mon, 11 May 2026 18:08:53 +0100
X-Gm-Features: AVHnY4J02EM-STLCD2MP6FVV-JQ0lvc4nk-VTjvEiKhgUyD-3ZL7OQ5Tc9N05vM
Message-ID: <CAGSyskW6T4cbX53gSRZSGeiTct9zHLBo9vsE9OH3Yw_sB1Frfg@mail.gmail.com>
Subject: Re: [PATCH RFC 0/2] rcu: Add debugfs interface for pending callback monitoring
To: Joel Fernandes <joelagnelf@nvidia.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Breno Leitao <leitao@debian.org>, rcu@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4686C1C0003
X-Stat-Signature: 4ne47sufyz3rcoe5gupqoisbzoqgwq73
X-Rspam-User: 
X-HE-Tag: 1778519346-811391
X-HE-Meta: U2FsdGVkX18wdd4kMWmg4FWFbAObe9wf6cV/EwKVnQtZVHUssMJlRYV2TC0dcFRf8SUVeuUlRfxAUq/t92msyOIsCyGoWvCnTaPKxyOYp8PYQo5jfMEa4B2c4jjRv7cUT2oDpiyn7jLCc18zlSAmJkUbK5grzei8jFZ48YO7mXoB3EJy+/waKFaTW7IMCLCrJ/M3Qd8kB0UhsvQG2ayRsaySfbT525SZogxRhPtoZS4IRTA4ZFne+gzA/iAbJuX3Hf9r6kX061WTUdjZ1ERdM+Z14DLtf1sIZFbwF97eou8a12G9fVWTSJ4BBHLpg9xeCk56iUOEmRDUJ3ZFbjgozWQpkdjFmMknn+p0lAiOOL0uVBGpn3YoHXq0yLhzMEk5xOzltSiv6ig00ke9dpGAb/pah3cuW30sEYfuRFTykJkfLhM1hYaJPbznzqMDwnlhG50bCxBw/ll58YbPhti5jLWusncBoYYa6gnq9pf9sHoLBR9yqQeqz9qScWz134FPDWRE2iZr/mzqsBj6N3q1VK2iqAWd5BOUyPdCYkIBNlKFGQF2kC0FNBL0dwzYPToRTImAhNpK8k3AChRJZ7yie8lc6mU1OKmugtzvpYOFiPjrFxRIPQOREtp8UrSqrwEC484g+X7WMK6Ls/mGYfQfX3pRYviPkkdvCK0Gf4UYCV/Cf4RDRO18M7UaSEDxKc5q3TZtGjf6e6Hc7zQaiK2ChIAox14BjsqWL3aEuj03qIn2jWVys5bRSt47aoBusP7LJY+ybXKUXnPLFj4bpdUxVMtn7bjacjVxBPcj1jrrDh5QSpI7HUyzO2IlW1izBuv2udnJy5ON4TeOefiB0fAc8olK9eqizPZJuvU9OXWDVFpO6canUqcD3ksn36hhJvp7jHpUJXOgVtuGVcxSNq0DbTnUbSJGWHUEsGvFtYxznPpf5OeXG/vyykI7PO3MIt9tX+xU9F94N71TfyJo5cb
 O62uqeuM
 qWxAiddzaV3+jDhNrcKlZ8hYuw//hXq/T7Mst884dB4xAQSUEAN0lbmpPLdhb8kGWFbgqbY/RKPqc4bxVJ4ttjb+y4Ugle4xNJBlfrvoeqVv923rTdpn5JKqXdvWa+DZRSp9jNjB8R4VnbPU5ziJYKq1V5/HaEbhQbUvQdRCtYyNHPvoqsbRKGgSJHr4RmmnOYLnPN1h9unNkZJh2NQ6h5+BgJbcy3G3rKh7rz5WijQkU55APMzcNgIjoyeVBln3jjv3maZzSA2bcvOHHmdNBZWLiOwcBfh4l2lJL1FdrwUu/Yi7c7IrMGEMS6lvDht3p/89iIFQMPGysoXWkLGvKwi2BPD3UIcQSobtuyioKk2tRW86fBRgbjypbpzdAXdx32i9QgbmVVSIVix+9aFbJtAKTijTarjNJ06vWWV5lT6eED3SD573Fs9mx+R7hl7eXlR6X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joel,

On Thu, May 7, 2026 at 7:59=E2=80=AFPM Joel Fernandes <joelagnelf@nvidia.co=
m> wrote:
>
>
>
> On 5/7/2026 1:37 PM, Gustavo Luiz Duarte wrote:
> > There is currently no easy way to monitor how many RCU callbacks are
> > pending system-wide. The existing trace points provide per-event data
> > but require active tracing, which makes them awkward for fleet-wide
> > monitoring. Knowing the depth and stage of pending callbacks helps
> > admins reason about RCU health, gives an indirect signal of memory
> > held back by RCU, and is useful when tuning RCU parameters.
> >
> > This series adds a debugfs file at:
> >
> >   /sys/kernel/debug/rcu/pending_cbs
> >
> > that reports per-CPU pending callback counts with a "total" row.
> >
> > Patch 1 introduces the file with per-CPU columns for each segcblist
> > segment (done, wait, next_ready, next) plus a "lazy" column.
> >
> > Patch 2 extends the file with a "kfree_rcu" column reporting objects
> > queued in the batched kfree_rcu()/kvfree_rcu() path
> > (CONFIG_KVFREE_RCU_BATCHED), which has its own per-CPU queues outside
> > the main segmented callback list.
> >
> > Signed-off-by: Gustavo Luiz Duarte <gustavold@gmail.com>
>
> You actually don't need debugfs for this. You can just use bpftrace and
> instrument trace_rcu_ (with other RCU tracing Kconfig options enabled?). =
I had
> something like that working sometime ago.

My initial attempt to do this using tracepoints was probing
trace_rcu_segcb_stats, but this would add significant overhead to
every callback enqueue/dequeue event which is too expensive for a
production environment. I played a bit more with bpftrace and managed
to get this working with an interval probe plus some __per_cpu_offset
pointer arithmetic (see below). It is not the most maintainable code
and has some race issues, but probably acceptable for us if you
believe having this information easily available doesn't add value for
other use cases.

If anyone is interested, here is what I came up with:

interval:s:5 {
    printf("=3D=3D=3D=3D=3D %s =3D=3D=3D=3D=3D\n", strftime("%H:%M:%S", nse=
cs));
    $rdp_base =3D kaddr("rcu_data");
    $krc_base =3D kaddr("krc");
    $offsets  =3D (uint64 *)kaddr("__per_cpu_offset");

    for ($cpu : 0..ncpus) {
        $rdp  =3D (struct rcu_data *)($rdp_base + $offsets[$cpu]);
        $krcp =3D (struct kfree_rcu_cpu *)($krc_base + $offsets[$cpu]);

        $kfree =3D $krcp->head_count.counter
               + $krcp->bulk_count[0].counter
               + $krcp->bulk_count[1].counter;

        printf("cpu: %d done: %ld wait: %ld nr: %ld next: %ld lazy:
%ld kfree: %d\n",
               $cpu,
               $rdp->cblist.seglen[0],
               $rdp->cblist.seglen[1],
               $rdp->cblist.seglen[2],
               $rdp->cblist.seglen[3],
               $rdp->lazy_len,
               $kfree);
    }
}

>
> Generally RCU doesn't add userspace interfaces randomly like that. I reme=
mber
> Paul ripped similar things out some time ago.

Debugfs is intentionally not a stable ABI, so the bar for adding
things useful for debugging and tuning seems lower than /proc or /sys
-- which is why I went with debugfs here.

