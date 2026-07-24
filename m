Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D1CC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D4B6B008A; Fri, 24 Jul 2026 18:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEDD76B008C; Fri, 24 Jul 2026 18:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD686B00A7; Fri, 24 Jul 2026 18:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3BE66B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:07:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 279251601BF
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:07:23 +0000 (UTC)
X-FDA: 85025057166.05.86FF0F0
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 49518C0007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:07:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BKg5ohAw;
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wU5Q1P1K0Sn+giEIKHhvyXiMnp5Z1SqaRAMuahPIEyE=;
	b=lwsPCFf6rLQrBXuYNZfHvked1z6pTxP8oYKJ1qBGCjWV0JTvULz86uxTjvy2/2sr9KJcjQ
	em9590eGM8TmW0mDNRFdHnvB/tzw74WAQOrgvIbhmVDuz3WQgTywsJTGku2hDstazBuk9q
	ImI7H7ov/q3c36h5of0bBKYwVT2btAg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784930841;
	b=zQpbBlVDq1H9WVWP+UL62aBM8tsJY7tYu7athjBxRvx61wTOxc3m+c4If0ETCZJKqaUvrd
	/zGbG6VYsxj/qA9BZVEoSMJTAwCE9wMM+Zt93tvHdvxd0Qps9Ou2eTlmEQg+oQTz0W/Km5
	TCldGhLaCxk/2VgrRvekJm6Lx6TDgUI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BKg5ohAw;
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f7854678cso592974f8f.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:07:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784930840; cv=none;
        d=google.com; s=arc-20260327;
        b=ZBRyigQKol60sRt3O0At17XqMhzdVBuiV3QS4eYSpUyw/YFdwdD1FBz0JDZitl+fRp
         dVQJrGfyLsFSPqMCAopKn+OViYLAHGQgX8DXBqWFclGlllf3Q1P05vKL85AcMF3JW14S
         zCBrB34A9dVnk5v5rN+6icLUXsDPcA3j97+tzwarfKJH61h4F30rOSJjKzvGKnlqLHZS
         8XLoq/J4+Kbep8aQv9ajGg0dIElNGKPQFbHjtPE/UiamFhxjagZcX84hswuVmlnYihoS
         YDXrhGLzS1Fuf6GIUMktYr4UoqLQV5+z5CseqlVJcXTPKa2kmkqwb04AvFA2y9GtWM5b
         Y8Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wU5Q1P1K0Sn+giEIKHhvyXiMnp5Z1SqaRAMuahPIEyE=;
        fh=Tc/aLweBsa0xbbqVM6ol2N0BOMwFMr9HApctnn/RP6Q=;
        b=nAdARAzdxkW8N3Tz/cKy14vrmDUiSmZ+YAsXIjSsVhfY8JFCyQH4no826eb7/rt/dU
         f/RenMPIe8DyeGKJQiNlvpEv6EknT+Elkfq1PBxyWCAemMSCtxu8T6dKiqQaPlqF6esT
         F386tK1wbwQIIkfeeJOkbjKsBBmDTj3KJL8F2bzEIKL+dSG7DJ/vSejyYeT6MI3sSWWo
         JRAGvCS3Qed+boAATtagWiL6tITulW7MIXq+w5G6yr0DXVZIRjd77Fbq+87/+Tq+8rLm
         9WalPBgu4IpzUQXeZCRBT04AgaZpOg0L9aIkhVh7JOPo9JEFEvuR4cLZzhpfH7qze+vS
         tzyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930840; x=1785535640; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wU5Q1P1K0Sn+giEIKHhvyXiMnp5Z1SqaRAMuahPIEyE=;
        b=BKg5ohAwhOJcT4JGrBATqucEt8xMKcTO2/LbiKy2qqVPDf8ha0XcLa9c750iLaMofF
         iZVYx+MXaLg1JgP/kqW0TILhY/T0OB8+8JwlbCwEEsQk8Nz0PrxUUuQ/GG4GpeP+OHo3
         MOUpkQYkYZ309OU4dtCmueVN0nlmowG6s8YUEN4LTyuSiM9lu71Sn3bouuTIxRN/DFCs
         KnMd1lFw3WzEj1KNdHoC4B1O0/d0yuWfyt9u736dglNniKFYGE8pDeld2LE9A2pf39xJ
         IsDFARV9BSKntDgWU6MkTdhlFLuJcbzmfNxGPmX+X1CuKXVY4SBzsNKQ0lqHH8TNX5xU
         mqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930840; x=1785535640;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wU5Q1P1K0Sn+giEIKHhvyXiMnp5Z1SqaRAMuahPIEyE=;
        b=Y5uZv7nKrsJjNmpMSfX2X+1uO3vvLPfbLsNLLOp2gMuvB+HWjAnY+KTwREbZ/DmFYP
         7sf+3HnFng1ReS7OOvvH2BLaOWWjn8Fdj5SSB6O8DIg1ijF7e3b9p/8+IWx4g4kcRWU6
         o158Ut6JDZE0XVFsAK2Pvjri83DtKRctaT8urO6eXBMhys3z60FJbMkkg4+3kRX4gBN1
         Yl2B3yS4Nnnr8ZL9pmB45voXnjsxAbPfrLfw4eG+Dzu3nb+MocBDIhzmLARUOnfKEqdo
         0ojYqo5wuQODQ55MF4s9kNdbQglJGV3Nafw42MomEXYgw1qVQqv16EXtANnpe82kz5dD
         82bg==
X-Gm-Message-State: AOJu0YyVdZOWaTuKVFR0iGZO2S7tW0qnmSkn7SNLfagE7eK2Zv2pG8HR
	gaxiJQpV836Gk79JJ3w0GhsXm3RallQiwd+6LzzFsPVGZMi1H6InNp4UrqhnvYnAzHBjbBf/vCI
	/qpkQkJ4uY3j34JtN3vud5Orv0ltipAw=
X-Gm-Gg: AR+sD12e0q7TZqCx4wwzt+7KXuxJP3o4yomYaraX0z6aI0woyJpeNHml/j75bKexHbv
	9Gm/X7hQbhgLV1h5bxEdyAaSDIga5k75H/Ji/e1iwU6nDdIJ63F2AWWQJGWqPKZDPCz1eMTV1a1
	49nCIVS11BhOC6SAxDKjcvXmZmT2f+KmREePm0kZGa2zcG1Ckl2EEHondm4YnF6XoV3vfX23cJL
	m7BFAir2JB7t8wKXhNOcfRPCjGnpwi8uMJPJX3TaxQ+QaPl/1YguF61afzF2kUoOhitdUd2zHin
	79tEJqhg9zZEqASG/wbI9l4kuY6RjEOP3Z745jzi0xAfqbiRB3mbNdWKaHD4NeVFwLKbLCeLJsJ
	tSAO6MBxYmosI++RHN68jPTQ2
X-Received: by 2002:a5d:588d:0:b0:47f:9022:8530 with SMTP id
 ffacd0b85a97d-47f9feb3429mr29047f8f.53.1784930839429; Fri, 24 Jul 2026
 15:07:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
 <CAJnrk1b-5eQrPtug7i7n0h7=j0gaaGhihf3tbBZLfxz5fABUiw@mail.gmail.com>
 <CAMgjq7CmQjuOgeU5XOEwA532TB0=8U2aDXBz_prKVdFY0uyxWQ@mail.gmail.com>
 <CAJnrk1YqpLhsbC5m0vL-w3HG8dXGSPOH7Qq3-XAnJYTBdgN9qQ@mail.gmail.com> <CAMgjq7A=NB6qJL1WLu6b+EonLKnDjbFG20Fq6OM_Vq=798sDmQ@mail.gmail.com>
In-Reply-To: <CAMgjq7A=NB6qJL1WLu6b+EonLKnDjbFG20Fq6OM_Vq=798sDmQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 24 Jul 2026 15:07:07 -0700
X-Gm-Features: AUfX_myIBEQNvjQnywZKwgcUPr_Hqzmhc_uHAGI4pS_88gOAKqEl8BxJzWwm880
Message-ID: <CAJnrk1ZXB2Kt=3F3q8ksQqcyyjKUpzw-GNkzEZBCxkdNM7Mx_w@mail.gmail.com>
Subject: Re: [PATCH RFC 00/32] mm/mglru: MGLRU-FG and refault distance support
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, SeongJae Park <sj@kernel.org>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 49518C0007
X-Stat-Signature: 3m3a1iuqkxq3zrhjh6p3wmsu918kjiyi
X-Rspam-User: 
X-HE-Tag: 1784930841-483973
X-HE-Meta: U2FsdGVkX19cLYcFhglRBsWR4pu1enKRFVV2n/5vrET3u81utQBsxd97AJOi2MXm8Xvs5XTYO5vkg5E8Y6WiiqxpgLJb3QEDTWeGRAUThtG/3PhUtxicFsGGZeoE1uEsEAJ/WdbXcs8hRxf3x0OmoxOkk3Yn0ISaZrNFdzisIYGJartfd5Q3ikwy5UTYZcqWBcqN7kcwATWzTSRVvAqsrapJV10jPJFMn7za00vYVCPMA1a5F4JhTbgqyqvD0/8VONA1g9MmfhrGENDl2R2ePps0bwe9RGAFJbfQ4jv7SMMTcTI+VHR9dp8SuRoppLFihBDKq37/3/XA7/MzN0UwgZX28RcSMl6S2k2lY4ab9NHhnLcr4MWEEJClB5wxadk8WgdrRpXjoRKS+Ri3f1sCsKs6eF/OIz5Uw6sSXW0aDsaIhXPNnOReinSsO9KZZfqftkzx1qCOSYPevFtUOICW5xpFXsVh8T8Jyc50lbdTUylJzgwW4MrHThZZbK+eXuixEADPMuJQroTpuQCciCUWoRDAicmiaZrgN31YyMdAQTOnZZKtxiSjraw7JYqJP8fB89cxb81HL18JjDZSbtairQiseYqwuxvW46it5GltqQi3PaGexNRd9agmSKtrxIVtPYNPAeHr1K8JXP9UVaRjYILWiJnUhibnMFciMZ9/Oy0fthxGwSGZJyJ2lGmnC9aMI6bqybslJuZvVQ0f0+SJ1zeqG8H4JO/utXZwa9WHh4nzTVYKIzAYtkhNWUjNzE32W3qFFDySQokKorXKjj/sAl5dnTMfye2jazWUyLtYIHfzdNvZ65rIi/B420WL2053ZShRtFtWIBIYUJ0l8ukPiUex9bxXTxN4zGPKeH0fFq62V5x/0Y9a222nKpdOL+tNdwjC7cTDWSChm+wcPbC4UIY404eFs7SU3vp3bpo+36YbcwQLMj6X5sC6Zp988+iJZvthuHOk+DB9mN6SmpM
 wfCpwNRb
 Xq/oGPSo7IZAM1I86053N8lCazawneNvcSilOWd4csUvPPg6+1SCuHWCHU3y2kHV0mvm84NDLtSmICpwavDDRkWzfdd4WPXEadCvJtnCrqv07OmhMpxeN6LGrP8TJ8Zu9DNULkQANZpDx+C39EYhMFoTLJJZiMhmVgkl/xi1xTV1HyczdRMk68m14eQlA1Y3DXr67lFuK4bTZ/UWhFZerlVKZ+KPMCoiqJIszfM9HkssQdz/43+nsLNL7DgZDtWxV4yctp6WnVAIehqWhlhCC97SUswrF0xhYbroPpAGS8OrN3/wV/RXi8YluizfZi63echSR6iZmgoFUoJZxwjO6BiQ/EwXvsh7TRfqTBCOZRje+jxK9O9RdWnUJS4by21nM+sNBm72svwKc3WuhxoSWCIbkL1+3fevZIM4bcOPqi1PoBOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 1:38=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> Joanne Koong <joannelkoong@gmail.com> =E4=BA=8E 2026=E5=B9=B47=E6=9C=8823=
=E6=97=A5=E5=91=A8=E5=9B=9B 08:49=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Gotcha. Can I ask what speaks against having the flags unification
> > work ordered first, with the MGLRU-FG patches based on top of that and
> > submitted in parallel as a separate series? It seems like the two
> > could be reviewed upstream concurrently, and I think that would make
> > the MGLRU-FG series easier to review with it on top of the flags
> > cleanup, and freeing the two page flags seems like a sweet win on its
> > own :) Is your concern that the FG series would then be gated on the
> > flag series landing and you anticipate that the flag series would take
> > longer to land than the FG series?
>
> Hi,
>
> That's not how it works, though. Without the MGLRU-FG, it takes four
> bits for tracking the tier and these two flag bits have special
> meanings. After FG, only three bits are needed and these two original
> flag bits are just the lower two bits of a three-bit counter now. So,
> there is an advantage to rearranging them together and removing the
> single-bit (flag) operations to always use them as a whole. Before
> that, that conversion will actual make thing more ugly.

Hi Kairui,

That makes sense, thanks for the context.

>
> BTW will there be any feature change with your splitting plan? If
> there is no feature change, that should be easy to review.

There will be no behavior change with the splitting. It will only be
structural.

Thanks,
Joanne

