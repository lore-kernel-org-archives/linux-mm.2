Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1364ACD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 00:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D16C6B0088; Thu, 30 Apr 2026 20:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A95B6B008A; Thu, 30 Apr 2026 20:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0981C6B008C; Thu, 30 Apr 2026 20:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F02956B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:19:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94757C1792
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:19:20 +0000 (UTC)
X-FDA: 84716941680.21.5D5C33E
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6CAAC14000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:19:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mWX1EvUg;
	spf=pass (imf09.hostedemail.com: domain of jyescas@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jyescas@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777594758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcrMuHQymGKNU24w6OYLAiRKT6CRWMFS1fRqV3obnek=;
	b=f2p+hURvDr1V7QBAcfnmP2o5MvAHQMq7hGbFVlS7CH9ggCxRZ+rMWik6eB2delXxe92+Xh
	uskxyh8yKbW+pR/0gpNVcFsBO+oITmF7UD25ZCj5aVUFGaq+VIwn6sZb7T/MxA2HLJ+ALY
	V8n2+eM24p/Y2O2PdyjsuIy7WQH34TQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mWX1EvUg;
	spf=pass (imf09.hostedemail.com: domain of jyescas@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jyescas@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777594758; a=rsa-sha256;
	cv=pass;
	b=KwJcG5QCEqKvmLaglcwkCSfu6T1S5yGo9Y+A/DkxNnzIMQyURxdVvbbP2AUNEaaODa5QT+
	v5bGDi3zZl0oTYhpfWbAt82X3HTKlaUMsmvB80SvlAa9achPjKr6Yt83g0XVBXL4whmLOT
	th2SY9MduD/q+Ls+RVVz0jNfmuceafM=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so27465e9.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:19:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777594757; cv=none;
        d=google.com; s=arc-20240605;
        b=kL8zBZhXJFTcq/WacrqzOXOgrCkIy/w2jxZGOjXLfpcdiSvZrYDMVqSi8p8OLg7aeF
         Pw3NAxl4mkLfDis/CKQn1IvbXaWpDGBo259x/heyt/Q3rYHnBh4EeXpjXRLjJUQ+RQXP
         I4Gf2z2Q+XvFj4n6jJL+PGzeqTgq/uOzC4/Tv9W4oQ0A4EsmHttKW7tuJP5QY2dlEmsX
         cnWj7AG1ZEi+Ll1+U8Ht3To4MoG90h6ujm66KdLsVPwfD8pz7Q9S/nCd+4AhOmKgazSZ
         57+7IMfthkoAOmuIymALczKSTQNJmXqd+k7jSiak2PwT3hhr3UGmaTy/sv7nnTDnhN2U
         MCuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mcrMuHQymGKNU24w6OYLAiRKT6CRWMFS1fRqV3obnek=;
        fh=WMRIoQUHrHvYw1qn1Zs42bt8Qu1J+pPriXPOEGgl458=;
        b=EGfeJT+qnfISXhr5uRIfrFuMhl0Qk2g34i7BeazAaE8vWqwQACeKiMiv9a76fU66jC
         QgCD67J1Wkwrm6iuUaDkdmOcuInMPo6JpXKHBrWRIxNx80BnvdNw+itZN4B27H6c8L/v
         LOLpMMLGiUxhCZwjS4NopLi0IUlWv0mAtS401Wl5NVeYqQ83Q5IJLPCFXFk1JS+p5lm+
         aDv4hUwKvtL+2Z9hBLxqOUWy29qNneQhzoWjKlStqS0WXJa++d3zzAD+txuYsAFZ0kRi
         wpT85Ra4SuU4j5ZEeWCRSv8K7VDUg8Dd18H+qBnO5/e69OL0kA7TmzL0p4CL+phO9j+r
         Hxxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777594757; x=1778199557; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcrMuHQymGKNU24w6OYLAiRKT6CRWMFS1fRqV3obnek=;
        b=mWX1EvUg+9tToXK6/wi7rMgbnnRQkIBxucjZkbDWVOcXw/ouocxDclTHLohjimCtyP
         beRfUtSVw6HauhCuku2Yd/MxtWpLZ5sKPZYPxwShAzTeoc6vSZhnZz0fc00WeN1r4rIr
         QGSGMP/qLAOu/aQtHeiORbY+HHxbZsLSnvCSpcD4yQ0GZRPV9Jp3nnJXGKRszIsVUkMq
         gBBD1pcMZY/f4sU1SdaDs8macWg7Bst4I5BBgj8TBqhOzaRGHeg1LS8djskVWJY7MxRv
         H9rsZRERkAx7K1KDR0MkDGbjlb7MzmfKy1pEX7hyn5Fm4eKojm96ewiUorDqYbpCCvcG
         Z/sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777594757; x=1778199557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mcrMuHQymGKNU24w6OYLAiRKT6CRWMFS1fRqV3obnek=;
        b=aKA8O0EjzhnVZt6yAOqWLdjTNVL7JI8ispt0CwGzcHE1ONrbAmlW7wNVfwykAkYf5P
         tD2jKKbTf1+hdY7C9MWkO6AZuYliCvgI2921fVIu7SyTQjuzMcIgTUuTES5H/5cnxTCR
         83TjuhRj5f9n3n+YMWfLqtL3Hosw+9/4FtyZBf/iH//8kVD2GVAOmVjKHFcW0GpUjB1d
         e6zOaIq3tmw21/ug+FoJ70loN2b3zNEL6aM/dVv5qjYkCXXI0nsh0LUjqaMUWXyDY4wG
         swCwP/XliUg0PdEq6hybd/Jy37JG9Zlt1s3O1hC2fQ8NeT1EGs6ih8hNjP/XiaUNjDFu
         bV8Q==
X-Forwarded-Encrypted: i=1; AFNElJ/6BDM9GcEItN/cTgzHTr2tQ7qRIyT3UBD6Ag1prPupnsdM3fT9LnDUkdXYfuI07ERnpNIs0py9MA==@kvack.org
X-Gm-Message-State: AOJu0YzssjOarSlrmmmEvCOtcN3qX+PZa9q66gNYkVPzU+eARORYey9C
	lsNBP1+HDnYqmJkNev2v5oceb8QMS1zTB5jJP0XlFhIrMx4NATLGv/b8dNC78hwCoeTZczf5FFK
	epVX8Cll23pVdHe+kbPJ4Y74i0Ogq4qHPYctzdx29
X-Gm-Gg: AeBDieszzWg4Yx5akrwSUZp7GRVVRdmpicUKz3tK9ITCAYPuUc32WQmGk7o5R0qvDBm
	ARk/9JSn04w1Y/OVB6ihWwizOqVjPLQOhIVNd9Tm2xDNYX2kpJzFuDLEGcRMOE4a25a1u4pst7p
	N+Y1eGscA8rE3uyyCX2H8XvqyRSlBAT/l817f6lpvmm9AGHQYvkfJRsJJV/fSf/qSHyc2nBNacD
	N8O8s0VHWQNDBYTfrtGiwafxHPqvQqpiQSnfdXqvtCMZGxlrl6I1mS4AvNVehQrf5UWmSDAynVI
	lKerhiodi2rGLZ0WN8brirzo9Fl9tPrZYT+fpCDcafVDsaJw+OpRLAQiGM8=
X-Received: by 2002:a05:600c:4447:b0:48a:5d55:c194 with SMTP id
 5b1f17b1804b1-48a8f62d964mr273975e9.7.1777594756531; Thu, 30 Apr 2026
 17:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
 <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org> <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
 <5c6e3c1a-bae3-4997-b02e-135374d1d6f8@kernel.org> <CAJDx_rgYXWNC=0_QZDmMpuZU8aZqRU8OeMBqXT1jjzrpK=BWeQ@mail.gmail.com>
 <e63e0ab9-75bd-4a7f-9400-a8f87c80d1f0@kernel.org> <CAJDx_rjk-5pp5Z884bnTBss19Xk0msEayR=GAMG2wWCk+WOZ=A@mail.gmail.com>
 <aa8e148f-252f-4d81-89db-b1702d9b6888@kernel.org> <CAJDx_rjgyi-L-1j2kpi1NeKj+Huynd6ZFqJDmYqN8i8L3KyBfw@mail.gmail.com>
 <60cd723d-82f0-410a-9a7b-c4d75a5c94e4@kernel.org>
In-Reply-To: <60cd723d-82f0-410a-9a7b-c4d75a5c94e4@kernel.org>
From: Juan Yescas <jyescas@google.com>
Date: Thu, 30 Apr 2026 17:19:05 -0700
X-Gm-Features: AVHnY4KJ6vAN566Tbx2z71soLT9CiuQaEtYT68Xh1xn3IweGCgREJJH1cKZseKA
Message-ID: <CAJDx_rj-zuesuhrHROrEx0JK=wx+=89DN7Qd-sMWtxUrJ3mdCw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via debugfs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	android-mm <android-mm@google.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6CAAC14000A
X-Stat-Signature: t4pys47ik9dub7rd9ief639izzqzbkjr
X-HE-Tag: 1777594758-37032
X-HE-Meta: U2FsdGVkX1/9KIhXdomhvGCUlICwU1q7Xc+AZMr29ns/OzxefneC3Ea9ohPbHwhnCa9N9cmDlUqf2J79uECzuTwvxotY+OF5Nane1MBI/wPON575T8uMqma2ldUj4/EFg3oS2zXXn0A1uurbVeJLwagCzZQ2862HvUgzCtNZSZ1iCqfECOSlz+zOzsu+UBeGfSd44Qq3sXDY7zRbiqxc5p8PDrZM9vpoYF97ex4fD9x0v1+iZnUlQv7u9sxcEx2lrvGz+50+SjzaIwHSv44GP/FeIiPponwGLDSS29sni5GOeMjkb8hl+Xs3bzAV3lVC58GVP+1HgG81Jr7vW3kYaqL4u8VKAxhJSU/2UF+lml/oyrjjfN268JdnX8pgPIwJnab1EnyC5WiZPglemPQqcacKO33Su4GxSh7Lc0r9QwhQCK2JEOe/D/kiPpfxqOKOp00RrRqqZwvu/Gv540wR7rpKgNrsKqjr2Xzaz5pG8IklX4shfwkxnW+gmkU1F68yYt/5m6wsgP5MSoTODe1DDlwr49sSt6b73XMSi9NEoWk1BGT85kxJvTm/NHBZUnUu9wvBpWgxbtgsgSRyxNo/9o4euR0Dpk5i1rYXBWpfsh/J+IgzK1sv04C2MVZMynnkBNz3RNdbmPK8ZzPnQQ4H2BnRGOMDREnoIR0G6tMT7KH7nmZLSI3M93nX4bcdr8zwVIDZz9ab1Nhah/jyGyXdmL0qiNj7IK41iovjMHuuSLYfV32TpdjuISdXfn/e/UW7fY7VjBWnqce2I0KceR5OjBPUs8+2c8J/2LD/k24t19Zg3SojwYpTnZhUJha6CMab7fe0BPdfR3SZBS6Zk/IVJ7oPSZh/mMabsyyg57QnowpwXT+hj8gjmkroZDyBhWSe85bdrLse8mvbSWMHWwmFaUbh/3JmkYj7QMRG89AR3GaxW5rLF564R2cs/iLn6ZUgNeR6fdbtZRq765SMYLV
 8R+X727M
 uiKzJLEffoGCDdUIFkvo+ebj5ryYvn7pg3A6LKY0WKr7jZKPAv0nk+g+e0AcKu9N29shKoOkqpTulWTtywjSNfhURh8qGlmf5kB6xfWXi9R8ewzoZj1YC9xDWXRHWtdBgdYJF1MxO/cOu7Tk/gReh+LJ/G0hazSrNFY7lMQY7bzvqPLP9XYmCWR8/81tYl0cO5iFEjx6MG8bCuN8st4NhJ3xaar+p8P2c3wt9PhohBc6Zn2B+wtOey5epK2XU8BmGZjecewEYzGC++74Rhn06qiUjYmfp52FBteoX/Q5xnwhXiFkendAzw1vCtHiuHmu3POQ4uf1oN7VcwZfjBSNsBFINiSxjsSp5l/Ck
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 5:34=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> >> So maybe you really want a debug mechanism to migrate a (movable) user
> >> space page into a CMA area?
> >>
> > One intent of this driver is to debug CMA issues (pinned MOVABLE pages)=
. This
> > The driver will allow easy reproduction of the case you just
> > mentioned. For example,
> > I will allocate most of the MOVABLE pages and then trigger a CMA
> > allocation, that might trigger a migration.
> >
> > However, the driver's main goal is to put the system into low-memory co=
nditions.
> > so we can reproduce OOO, kswad, lmkd issues seeing in the devices.
>
> (Late reply ...)
>
Thanks David

> But there are other ways to trigger low-memory conditions, no?
>
That is right. However, in the user space we can mostly allocate
MOVABLE memory. If we want
to allocate CMA, we need a driver that makes that request or uses dmabufs.

> So I think the real missing piece you are looking for is getting a movabl=
e
> userspace page allocated on CMA memory, to then try allocating from CMA t=
o see
> if migration works.
>
> And you can do a bunch of things to make CMA's life has hard as possible.
> O_DIRECT the userspace page, trigger low-memory conditions etc.
>
I'll look into that too and see which one actually works better.

Thanks again for your suggestions :)

> --
> Cheers,
>
> David

