Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA88C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3405F6B00B3; Tue,  7 Jul 2026 15:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318176B00B5; Tue,  7 Jul 2026 15:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E596B00B6; Tue,  7 Jul 2026 15:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA2BC6B00B3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:50:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 427EF120578
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:50:49 +0000 (UTC)
X-FDA: 84963023418.09.071383C
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4DC73140005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:50:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WbLorvM/";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783453847;
	b=0UP5+wJPAE9ld/I1OFDff2XWqOisOFsAnKFn8wZhDQ6jtcmd+WdYK/F+Zmb+vAL4l6bDVw
	q/d9NlQX1rT+lZMqWRieM4cF18uTh1k1+k4hbgpfup384KzXI23hMSp601D4K7gifh1U93
	SvkZE+zNlTjoicaMPVsc/VdvW8L8yo8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WbLorvM/";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmUSr1wYRpo60Brmmb5jNV2lfpLacY5R+3P9/J/GOo8=;
	b=SaS70y5k8MbFO+rLq4CvpEF3P8s8sCcvi+rI0nSmK9/uwwYI0iBSD+xiYaAhvuyZ5/B5Ty
	RBq0g6MScZYf/4tUDY0qCvnIR5iYZnUCNv6hy8LEpRrnQfkCgLV59G5DzQF7dJ/0Nw7I4H
	qIcNHLG0JBkcu6ElOJq+zCRgj1s/XSE=
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-44ce4d7883bso2682538fac.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:50:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783453846; cv=none;
        d=google.com; s=arc-20260327;
        b=McvJsbLDhFWHgLUw6aCyBoS+s+HdK9j4zdZAJM6L21dqdh+A05l7pncKpuhzb3fOHi
         xQmEETP36cWGVOAh57Ubw1dk+i5dw9oeyp8s1zEzRtMytsD2WT6ZV0FE5xKbVMn3n6yD
         FFmfUF+wiyVpg31k8imbTnemwKn3fKMM2bmjNyEQqyjzj9iRmv6jqO3IpSixmMGJi1Li
         BDwZvciuIy3mnMfeNp6Fmk/REQjNnCuG8i6KsXENo2RUbX+p0N/fZrvoDnYvsNYBtqVX
         VPVXmpncalhyyImOBIWhhfaSQm5HyDrtH64Vdmrp4PMLAbBKOgYrbefww00Euo4HNYmc
         mouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=PmUSr1wYRpo60Brmmb5jNV2lfpLacY5R+3P9/J/GOo8=;
        fh=JhEaYERb5ysElJLx489RT9yDrxYxMdMJgEGyScd0t6E=;
        b=Jx+MGTiZ7D7PKMPpHkMoiRzIvWsvCzYGt51uExCMS0ZzoSAYs7PxHaRZ9mUFPXRSnX
         pcbCOZ380jeBfGuMOlGzzcb2yJ9h8218fJ6ooI2AdsbnFxEz30BY4JaMsJCy0QFy6I4T
         TWhTUyybwcZ80KISa9eITqS91HwN/1uEFTyBWcQPFYboL7Gd5OjT5S0LqY8FJvlTFfH7
         wnQ5/qyVouSH134j/l1uODbRhV1HB61NqcJE9xIr2nssoBbhfriLrMMqJVma2vlBJVNc
         z87xcMVFWtUllBjHiiYN2HUMer0nKoDS8Y6mN7vEvcyrDwirJaoJlle7B4HS0HQxIGFm
         5g6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783453846; x=1784058646; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PmUSr1wYRpo60Brmmb5jNV2lfpLacY5R+3P9/J/GOo8=;
        b=WbLorvM/bD4k9Jgyh0ioqyuVly0qLEvqsiH3/koWiKjq7MHUVPC5rMSGK9xXulECdS
         +4SJz9kuBlS3AH5Ssa4gH9ha/BFaS3BfhMfOGRddUl4iSnamJrkVQVL4WGe59IgsoU2T
         nthod8GViJBSmepIi3Kp2JIY5LDqQxuoigUh5RxQiLevmzZMrewL9FkK1tHinZFVVACl
         hhVvN3I/xgOO6cG5Ej3oGnpif7KIjk85E3bm1OUIurP4LQmYHUGt484g4DjidUvfvUeK
         Nhzo7TUa/j+elAaKCiM4oyknouyocWTviP0r7rG54UkU7ul3QSN2I5UzYKEPn7sbh6D1
         Usxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453846; x=1784058646;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PmUSr1wYRpo60Brmmb5jNV2lfpLacY5R+3P9/J/GOo8=;
        b=NqWsgxCmYgUze0EBX5OMXYRaSwMvdO0NheDVN0hW61q57s0EMaPORBpcjs7Zb5rTDo
         gVCONaxNDievLiPQ7k5qdmuIEuapqtwoAaQBP2WQr3hhzWoviY+QAkMhEnT168pAPgZn
         bw9ZExjIIZTWYkA73iRECy/qCkxoLmZ609jPUFO3/IySjCKs7YnXlsDOEuzLyvqPAlIb
         +ldPODsgmRclnZZtQzfrGJBrUxLzU4z66ztrUzQIOo6YeRTCWeJYIgZqDtJS5jHT9c+I
         N5Uu4veUIvAi1ySzpK0brsWUsrg5kukcq1fxuJAutFdV5jXzIdLKgEg66dkfqvCO607b
         N/iw==
X-Forwarded-Encrypted: i=1; AFNElJ92zJyQLXCChpgmL+6A+FUDLFt3DhYraNmbh8jRJgUEUbYJdH1ka+TOmeuHUtW1rhFQqx3KYQLp5Q==@kvack.org
X-Gm-Message-State: AOJu0YzaI78X8pRFTnnoJgobIWKNelTSpte9+ff7e9oXmLIi4FrUhtE5
	gaZtHRVC7hbWKoQ/qI6mYzb2VtMdCLqQzlEOKuge7h4IlnLelF4LavCsoIi1F75GOvkeB2uXYvj
	58F1YXmxdvswQuzDg4ngtFHQFIckXZEQ=
X-Gm-Gg: AfdE7cnpO3OH9ykQQc69K9eEAsuAsvUlvYU51HBhfVSTtr4x64tp2wIhzwBrOBWZK9j
	5bROySFsZlu8f0qQAASsemTM3Z74+mwdpeXANEwloKCDFOLHwxTpIGg3/Nxq2c0rocuZ3jYYvM8
	UUx4gT5bXgzBmes5at44ofl9tcyH3EQRXN2rOA0qV8HL0NeFklBhoo1Ph9uw2+cJitq8QNUqa+h
	DCjfryXV/SavvUZYjXWDdiEYLt1wnhkfiSkn19M4Kzun2T+068WxWq+Roc3hJ5OFjZyUsve
X-Received: by 2002:a05:6870:b9cb:b0:440:67b1:b59b with SMTP id
 586e51a60fabf-45105c4a060mr4226938fac.0.1783453846298; Tue, 07 Jul 2026
 12:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260706000338.362421-1-shijujose2008@gmail.com>
 <20260706000338.362421-2-shijujose2008@gmail.com> <akx2wqr3ULcmpCmc@hu-ashoraj-lv.qualcomm.com>
In-Reply-To: <akx2wqr3ULcmpCmc@hu-ashoraj-lv.qualcomm.com>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Tue, 7 Jul 2026 20:50:33 +0100
X-Gm-Features: AVVi8CduhFPz8K3CM7tEiRduR81TYS3zBRxtPUhaSo_8LaCXDPygoSDb_To1ml8
Message-ID: <CAG4KcR+FV5pR0-WF2jGu_EwGjrH-dDTuHvbbWwQ-835qvSbk-A@mail.gmail.com>
Subject: Re: [PATCH v21 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
To: Ashok Raj <ashok.raj@oss.qualcomm.com>
Cc: rafael@kernel.org, bp@alien8.de, akpm@linux-foundation.org, 
	rppt@kernel.org, dferguson@amperecomputing.com, linux-edac@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	tony.luck@intel.com, lenb@kernel.org, leo.duran@amd.com, 
	Yazen.Ghannam@amd.com, mchehab@kernel.org, jic23@kernel.org, 
	linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com, 
	Jon.Grimm@amd.com, dave.hansen@linux.intel.com, naoya.horiguchi@nec.com, 
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com, 
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com, 
	gthelen@google.com, wschwartz@amperecomputing.com, wbs@os.amperecomputing.com, 
	nifan.cxl@gmail.com, tanxiaofei@huawei.com, prime.zeng@hisilicon.com, 
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com, 
	wanghuiqiang@huawei.com
Content-Type: multipart/alternative; boundary="000000000000fb67ad06560ab423"
X-Rspamd-Queue-Id: 4DC73140005
X-Rspam-User: 
X-Stat-Signature: rmndmbaoktyhp3a5ocdyow9pgokb8i71
X-Rspamd-Server: rspam03
X-HE-Tag: 1783453847-791665
X-HE-Meta: U2FsdGVkX18pdvD9SowautXU+EXscx19TJVh2RU0bQPKmRX2cfTQH1PFqGCx3QDSTB57LFq1o4gVbVCRlk0uKs4BsTVFmfeeKQQLSnMSqimR5CsW38zp2jC5nCJ2mhltuy5EN9XufoXMw2edWP5zTReSdU32BTjNAoHnRFwKCkr5ErKK26kJLOIuorm/DQEi6h3HEqj1XSyGS0EuuR1bMYVQNyIjlnjww9/PI4TNVN+0EigvfN2n/ZqMZdXNgt0BkK8H3NDT2XTiPHLU69MxXJ/jGWtSVZpuO0i0e7OSC7lw2/V6HOlAhFJjuTwuaWFspsp5ryjxPdLsdON8BNlxxI4ioqTD2DH+bgB5q4LBiLz6bck7Z8YqI20PxeREYgRCfnGQC9ZNKb6fWhmgtrPI6QoQ9QHvVJkbfJNcClVLo40Rd+oS2Y9Z4/Oyvih8KwilkUKBEGa++JqSZgFDHsqoU4p74N3geBSBLEDYUYXGCljXlzDggstps5q1fOBdszzxlhJREFeKT4QuVZiUMjGXFUzofL62+QpNcStrCTalkK1TrBCCH5BC6EzRCUUJHr1y4h5z1iCRBeExge4lvGz2YHZmK6cH+FCJWbtaGIfzDODYnz8vuRKfaqWc8R1u5kACQGF7yPFe7X9EraGI0EL4B8ihgu9LIzU++dETCiv5WqzTsVkFC61yyzxVFKp3IA+UvLNvY3esbyYcNwExZtEEPbatEvuslTXwG0Dlu2qi36X4g3DXRXGjGSCjPnQa9K28Rjvda/4DKZpUcuAPJRhab5SZDW9fwedfKWMTjAb8iJKK2urBG3TMP20Q192SxPpht4bpdKPtveO6IhNH8viSSHu9lpyqxoRXxVr9kE6xdaPY0GuqmAfD/7JUnyylWDBr4oQNUZbW7cSv+rtMJ0IqTBR+2Car7MLVKwiJifhF/jHvSrqr5Hduo7v8d9xx4x7jSrc1KnAh6bV7F8c+vir
 ZeK6RJ5l
 jCzGwB1PV6ualcAkoD6o8Wy1C5U2d0HIHmMXOX11HzhtD8JIG4LN1TuINWqx66vtkvyj2eVA/eY4yqKtvbU/FS9UtfmyQzs2LVLj0jPDXAcAGGNNdaLC9jVqefnllLW82qW8Z8yXYyIwIhb/Pb94DM+L8FfJgPqi6Q+B7qHnEZQBFL9X6vk4fC9JdrM8V40LcyZWyp8Rx0gK4wS7JlLksoo/14tkB+qRssQad9rKBHmYRu72Dhfy+zoS5Pw7/kDK0qh/452P2q7l4OPUNktS+9p9aO3xBlkogIl7Lf8aoSjCk8g+I74dCX+NxtxI4lDgPo1zVGtHPzdAF9wFfstoUO1gZzz6VeoRmGAfGOyed9Km39/6i82gDwv1fslMQO79+la0qRsOqvqc795aMNFyN7qT44uOY9D237saLlFzfbOpxWcQIuollsCTrpd7REiWmQ3uVcHH4Y92S3vZpy4550IguY5Zea+Xa4CtEHkwZfF60f3aaihejhQOnsP/oh1ezsnyDbLdHOKBGHNRKv8yue91MxR13YWShaCMW1QyldMMgt53q8iAk6j73j+bFFxcdTjRNts5QwdO9fwZtNKW6xE5bkjRaCBPV5CapCrOXL2KLel0mr01NjpK6HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000fb67ad06560ab423
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ashok,

Thanks for looking into this and good catch.
I will incorporate this change in the next version.

Thanks,
Shiju


On Tue, Jul 7, 2026 at 4:47=E2=80=AFAM Ashok Raj <ashok.raj@oss.qualcomm.co=
m> wrote:

> Hi Shiju
>
> Thanks!
>
> On Mon, Jul 06, 2026 at 01:03:37AM +0100, shijujose2008@gmail.com wrote:
> > From: Shiju Jose <shijujose2008@gmail.com>
> >
>
> [snip]
>
> > +static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int
> pcc_id)
> > +{
> > +     struct pcc_mbox_chan *pcc_chan;
> > +     struct ras2_sspcc *sspcc;
> > +
> > +     if (pcc_id < 0)
> > +             return -EINVAL;
> > +
> > +     sspcc =3D ras2_sspcc_get(pcc_id);
> > +     if (sspcc) {
> > +             ras2_ctx->sspcc         =3D sspcc;
> > +             ras2_ctx->comm_addr     =3D sspcc->comm_addr;
> > +             ras2_ctx->dev           =3D
> > +                     sspcc->pcc_chan->mchan->mbox->dev;
> > +             ras2_ctx->pcc_lock      =3D &sspcc->pcc_lock;
> > +             return 0;
> > +     }
> > +
> > +     sspcc =3D kzalloc(sizeof(*sspcc), GFP_KERNEL);
> > +     if (!sspcc)
> > +             return -ENOMEM;
> > +
> > +     pcc_chan =3D pcc_mbox_request_channel(&sspcc->mbox_client, pcc_id=
);
> > +     if (IS_ERR(pcc_chan)) {
> > +             kfree(sspcc);
> > +             return PTR_ERR(pcc_chan);
> > +     }
> > +
> > +     if (!pcc_chan->shmem) {
> > +             pcc_mbox_free_channel(pcc_chan);
> > +             kfree(sspcc);
> > +             return -EINVAL;
> > +     }
> > +
> > +     sspcc->pcc_id           =3D pcc_id;
> > +     sspcc->pcc_chan         =3D pcc_chan;
> > +     sspcc->comm_addr        =3D pcc_chan->shmem;
> > +     if (pcc_chan->latency)
> > +             sspcc->deadline_us =3D PCC_NUM_RETRIES * pcc_chan->latenc=
y;
> > +     else
> > +             sspcc->deadline_us =3D PCC_NUM_RETRIES *
> PCC_CHNL_DEFAULT_LATENCY;
> > +     sspcc->pcc_mrtt         =3D pcc_chan->min_turnaround_time;
> > +     sspcc->pcc_mpar         =3D pcc_chan->max_access_rate;
> > +     sspcc->mbox_client.knows_txdone =3D true;
> > +
>
>   Probably a minor nit ..
>
>   sspcc is published on the global ras2_sspcc list (with a live kref)
>   via list_add() before sspcc->pcc_lock is initialized a few lines
>   later via mutex_init().
>
>   Once list_add() runs, ras2_sspcc_get() can find this sspcc and hand
>   out a pointer to it (kref_get_unless_zero() succeeds since kref_init()
>   already ran). A caller doing so before mutex_init() executes would
>   end up with ras2_ctx->pcc_lock pointing at an uninitialized mutex.
>
>   Currently harmless because the only caller, parse_ras2_table(), walks
>   PCC descriptors strictly sequentially, so no second
> register_pcc_channel()
>   call for the same pcc_id can land inside the window. But it's relying o=
n
>   that being true rather than the code enforcing it.
>
>   Should we initialize the mutex before publishing the object, e.g.:
>
>         mutex_init(&sspcc->pcc_lock);
>
> > +     kref_init(&sspcc->kref);
> > +
> > +     mutex_lock(&ras2_pcc_list_lock);
> > +     list_add(&sspcc->elem, &ras2_sspcc);
> > +     mutex_unlock(&ras2_pcc_list_lock);
> > +
> > +     ras2_ctx->sspcc         =3D sspcc;
> > +     ras2_ctx->comm_addr     =3D sspcc->comm_addr;
> > +     ras2_ctx->dev           =3D pcc_chan->mchan->mbox->dev;
> > +
>
> > +     mutex_init(&sspcc->pcc_lock); <---------------------
>
> > +     ras2_ctx->pcc_lock      =3D &sspcc->pcc_lock;
> > +
> > +     return 0;
> > +}
>
> Otherwise
>
> Reviewed-by: Ashok Raj <ashok.raj@oss.qualcomm.com>
>
> Cheers,
> Ashok
>

--000000000000fb67ad06560ab423
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Ashok,</div><div><br></div><div>Thanks for looking=
 into this and good catch.</div><div>I will incorporate this change in the =
next version. <br></div><div><br></div><div>Thanks,</div><div>Shiju</div><d=
iv><br></div></div><br><div class=3D"gmail_quote gmail_quote_container"><di=
v dir=3D"ltr" class=3D"gmail_attr">On Tue, Jul 7, 2026 at 4:47=E2=80=AFAM A=
shok Raj &lt;<a href=3D"mailto:ashok.raj@oss.qualcomm.com">ashok.raj@oss.qu=
alcomm.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">Hi Shiju<br>
<br>
Thanks!<br>
<br>
On Mon, Jul 06, 2026 at 01:03:37AM +0100, <a href=3D"mailto:shijujose2008@g=
mail.com" target=3D"_blank">shijujose2008@gmail.com</a> wrote:<br>
&gt; From: Shiju Jose &lt;<a href=3D"mailto:shijujose2008@gmail.com" target=
=3D"_blank">shijujose2008@gmail.com</a>&gt;<br>
&gt; <br>
<br>
[snip]<br>
<br>
&gt; +static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pc=
c_id)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct pcc_mbox_chan *pcc_chan;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct ras2_sspcc *sspcc;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (pcc_id &lt; 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sspcc =3D ras2_sspcc_get(pcc_id);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (sspcc) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ras2_ctx-&gt;sspcc=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D sspcc;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ras2_ctx-&gt;comm_add=
r=C2=A0 =C2=A0 =C2=A0=3D sspcc-&gt;comm_addr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ras2_ctx-&gt;dev=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0sspcc-&gt;pcc_chan-&gt;mchan-&gt;mbox-&gt;dev;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ras2_ctx-&gt;pcc_lock=
=C2=A0 =C2=A0 =C2=A0 =3D &amp;sspcc-&gt;pcc_lock;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sspcc =3D kzalloc(sizeof(*sspcc), GFP_KERNEL);<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!sspcc)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0pcc_chan =3D pcc_mbox_request_channel(&amp;sspcc-=
&gt;mbox_client, pcc_id);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (IS_ERR(pcc_chan)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(sspcc);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_ERR(pcc_ch=
an);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!pcc_chan-&gt;shmem) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pcc_mbox_free_channel=
(pcc_chan);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(sspcc);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sspcc-&gt;pcc_id=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0=3D pcc_id;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sspcc-&gt;pcc_chan=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D pcc_chan;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sspcc-&gt;comm_addr=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=3D pcc_chan-&gt;shmem;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (pcc_chan-&gt;latency)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sspcc-&gt;deadline_us=
 =3D PCC_NUM_RETRIES * pcc_chan-&gt;latency;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0else<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sspcc-&gt;deadline_us=
 =3D PCC_NUM_RETRIES * PCC_CHNL_DEFAULT_LATENCY;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sspcc-&gt;pcc_mrtt=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D pcc_chan-&gt;min_turnaround_time;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sspcc-&gt;pcc_mpar=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D pcc_chan-&gt;max_access_rate;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0sspcc-&gt;mbox_client.knows_txdone =3D true;<br>
&gt; +<br>
<br>
=C2=A0 Probably a minor nit .. <br>
<br>
=C2=A0 sspcc is published on the global ras2_sspcc list (with a live kref)<=
br>
=C2=A0 via list_add() before sspcc-&gt;pcc_lock is initialized a few lines<=
br>
=C2=A0 later via mutex_init().<br>
<br>
=C2=A0 Once list_add() runs, ras2_sspcc_get() can find this sspcc and hand<=
br>
=C2=A0 out a pointer to it (kref_get_unless_zero() succeeds since kref_init=
()<br>
=C2=A0 already ran). A caller doing so before mutex_init() executes would<b=
r>
=C2=A0 end up with ras2_ctx-&gt;pcc_lock pointing at an uninitialized mutex=
.<br>
<br>
=C2=A0 Currently harmless because the only caller, parse_ras2_table(), walk=
s<br>
=C2=A0 PCC descriptors strictly sequentially, so no second register_pcc_cha=
nnel()<br>
=C2=A0 call for the same pcc_id can land inside the window. But it&#39;s re=
lying on<br>
=C2=A0 that being true rather than the code enforcing it.<br>
<br>
=C2=A0 Should we initialize the mutex before publishing the object, e.g.:<b=
r>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_init(&amp;sspcc-&gt;pcc_lock);<br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0kref_init(&amp;sspcc-&gt;kref);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0mutex_lock(&amp;ras2_pcc_list_lock);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0list_add(&amp;sspcc-&gt;elem, &amp;ras2_sspcc);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0mutex_unlock(&amp;ras2_pcc_list_lock);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ras2_ctx-&gt;sspcc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D sspcc;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ras2_ctx-&gt;comm_addr=C2=A0 =C2=A0 =C2=A0=3D ssp=
cc-&gt;comm_addr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ras2_ctx-&gt;dev=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0=3D pcc_chan-&gt;mchan-&gt;mbox-&gt;dev;<br>
&gt; +<br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0mutex_init(&amp;sspcc-&gt;pcc_lock); &lt;--------=
-------------<br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ras2_ctx-&gt;pcc_lock=C2=A0 =C2=A0 =C2=A0 =3D &am=
p;sspcc-&gt;pcc_lock;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +}<br>
<br>
Otherwise <br>
<br>
Reviewed-by: Ashok Raj &lt;<a href=3D"mailto:ashok.raj@oss.qualcomm.com" ta=
rget=3D"_blank">ashok.raj@oss.qualcomm.com</a>&gt;<br>
<br>
Cheers,<br>
Ashok<br>
</blockquote></div>

--000000000000fb67ad06560ab423--

