Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11794C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D946B0098; Mon,  4 Aug 2025 05:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975116B0099; Mon,  4 Aug 2025 05:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B316B009A; Mon,  4 Aug 2025 05:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 789AB6B0098
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:15:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2633C1611C1
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:15:49 +0000 (UTC)
X-FDA: 83738517618.08.A162FC0
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 95BAF40005
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:15:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="Qo9K6/RH";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754298946; a=rsa-sha256;
	cv=none;
	b=VmtSms4hKmf3iulJUALVD89nbK30jN2goHM10G9Yj3VPBVSVf77nrZ9nabsP5AN28Fwwac
	7SrNBHyXXHRR8uGiGfFQFmjNKiqiOwp4LFZnrZ4dcTLAv4hGHCluPXGH2bM2wiamK4Big9
	vlYc8w/20X4iPxA8RdYvKFJJfdAJqyg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="Qo9K6/RH";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754298946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JjbB3Jm5B9RQihNCMKSK+B8I5hhLMbxQKcU07xlJc6o=;
	b=xiN3+wM6LomwpU3NT9uOQWJF0q+DBwuM3/05IfSKzv6DuebnAln9X7hmEwmrAPNMhKlNaF
	cl0XDDrCbhAmMys3MRlDmIyUnxje+hKmU1am2pbCHLTMOii4d2hivhHursJtXetCuNvZ3O
	UB5hJ6uVpTqFfk3O//lB8pMxre2LKJc=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5745Sdhn022488
	for <linux-mm@kvack.org>; Mon, 4 Aug 2025 05:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=JjbB
	3Jm5B9RQihNCMKSK+B8I5hhLMbxQKcU07xlJc6o=; b=Qo9K6/RHGpbdoHXEsTCC
	4lgHR38vJx6A/fYq+9r70zqU8KQ5BWR4s8qkP5owJN1Rzx2AGT81eNV7YmuXKB2Z
	NFkCuuDF/AuBdAnf6/d2LyWRtzjsvZVVUp1ukSItfRwYe2wWSqzJDUsUL3toXqj+
	xaS2jVayqJ2lMP1lZKJ+8bwaLcbKjwOXoYkQR1Wax3Zd7RTcAxMZrk1D0Ule9e8B
	6qf072uYGmDZ9kWtdbJ7vB7d0WV4iFeSuDhEKcm8wSdtCdSfUfwDaSxIDEkF9Mlp
	YNnsEgk5XoFKttCFX8i9vob5+gMVKBB4z24F3leGupjciyntk6mbnWqpJBsFDPA3
	LQ==
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 489fmnh6kf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:15:45 -0400 (EDT)
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-71838151744so54185247b3.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 02:15:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754298944; x=1754903744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JjbB3Jm5B9RQihNCMKSK+B8I5hhLMbxQKcU07xlJc6o=;
        b=wQ/bltld+mHotpZRb5S7RS5a5A640RItg/fX68IuL/YS+Dteh5PnQwBJ0oB+5Iv0eR
         RIWAuFBPHLlNUy9d8DqBXlJTAmFN+ynYwJ8ilj6RJZSEX8UBmbi8+nZTGGLAj9OqXO6H
         zsf5IW8QIfrknUuFqv1x2V+HawlMHEF/987zwg8a7MDu1ZYpDX18c6xNTGp3RcLTjkTU
         EnAybAt4TDXnXwp/4PU576Sm32eaTGaIpk42TUHeYZr8lXRP85FVytAM3niXytHK28d9
         MKvSu3g35OPR02GsonIyftADe/t+OHSFDS9WK3DPQWqClJd1hb6xkjjj0mgTH6phrmwu
         8Wqg==
X-Forwarded-Encrypted: i=1; AJvYcCXBf3rxR3/+ufQsE2akDpJnPBXsDjKt/b/N3hOzwQSs76ZkTLWIJ5Ydq9qU10/4AiiACgHA0EVeQQ==@kvack.org
X-Gm-Message-State: AOJu0Yz83TpuH1OZNIf6KxWKrGW7dqD00TWaIEmemzvfcV5a126IZv6A
	Y0g58HbULh1o4/R/2R4Apf71/yClfDifaDp1t4/lGCN6nGvveLUiapuKb+PWwmeddk31CEDvZV/
	Jkt0HRKERaBS1WC96AKP0sT62/D+U77QnDp7B6NHutPG8p48b7HG9QZKD2q3Ci1xN3fNRT++Acs
	yg72YzmLxHGBI8U4FuO7/5NDM=
X-Gm-Gg: ASbGncuIAFMMs06jl8FYhDand/ExSUVyu5C4lTbm1D3OZA3WStQ34yrCOrrT+aMkWen
	BCcho0PTU/YZmExZOBfeZz1reKLsSC2tSWkDCyxSn/2PG9Uns2PdvKRIy6bjZ4GXZx13Hk+ASwt
	iB0rtc6IMYQ9Nl6bKV4x9e
X-Received: by 2002:a05:690c:4609:b0:719:53fd:79aa with SMTP id 00721157ae682-71b7f84a212mr77213137b3.22.1754298943861;
        Mon, 04 Aug 2025 02:15:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+UZiZI74WScdHweh6AGanV37GHLhD9Nzf23TmEE2bGp8nqgrqm6GaV8J3VbW+KzNd4CNom3Wtj+ghqdeWtRM=
X-Received: by 2002:a05:690c:4609:b0:719:53fd:79aa with SMTP id
 00721157ae682-71b7f84a212mr77212667b3.22.1754298943210; Mon, 04 Aug 2025
 02:15:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250528-tlb-trace-fix-v1-0-2e94c58f450d@columbia.edu> <CAKha_srZTXfQkizBzvrdpWs6Txw2PSgRAqT6QC8gom=PaitYNg@mail.gmail.com>
In-Reply-To: <CAKha_srZTXfQkizBzvrdpWs6Txw2PSgRAqT6QC8gom=PaitYNg@mail.gmail.com>
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 4 Aug 2025 12:15:32 +0300
X-Gm-Features: Ac12FXwhQmrmOOkID7nOJYCapFm0MAKFQQ0J4rVnNl_CTjL5U175u7m4uf07P64
Message-ID: <CAKha_soQ7VUvHk7cz0SmX8_GYdWS3nrPm-e2NyU=AH1qXiKqgQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86, mm: minor tlb_flush tracepoint adjustments
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <liam.howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA0OSBTYWx0ZWRfX99X35Hs65guI
 n+8s1Eevieq/Ks2KnwgcL3h95PCB2He4AwGQfw+FqlSKXxUP1CI8/9t+8OXRvboJmVYeeo+F+9O
 H7BVqaSG39QDA3X5a8ambFet7BfM5UXsf4MvTja8n2yXTokNy8NSAHkjjCsLn98Yl8QPw0NiSi0
 fv7eaL34AYW8OVG7IqAgor+nckEWNMoLV1iN7CRrKvvgrpd6DLXEwk0p4nsg4LAyJ7FOu6FM2J9
 V8r8gN/M5VGVdhKoFxvhTGlMPUN+Om7Zfp3g/mg/um9OILt89pr6YwBHE0srCekk7YZ3a/QKfFc
 0UeF3WbDVhfklZ5RBFBY1LW2wECaH2RGGS8b+uUBJ3FDfLSnRF28iX7VyiA7QwnBj5IjkByanOW
 YabgjGYh
X-Proofpoint-ORIG-GUID: oU0sH0Oa8Duq2jGoW3-DRY9jD1t0RrOD
X-Proofpoint-GUID: oU0sH0Oa8Duq2jGoW3-DRY9jD1t0RrOD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_04,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 adultscore=0 mlxscore=0 bulkscore=10
 mlxlogscore=758 spamscore=0 lowpriorityscore=10 priorityscore=1501
 malwarescore=0 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2505280000 definitions=main-2508040049
X-Stat-Signature: yn1dm4pxqj6idyqacaei8zq7b6cmka5y
X-Rspam-User: 
X-Rspamd-Queue-Id: 95BAF40005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754298946-396445
X-HE-Meta: U2FsdGVkX192myLTrm+VVam6mC48H/eKzQnFGUEpHlFGjPJLD2VLlIrPLGBqSGLV+WUUBlRs5AWs47loWfzpozrhHFSA7rrF74e4G1yhUdkqeox9Jg8VErrh0u6r3ZwoUlRjc1AtWqV8DIWpziJw66j0kCQY9tIJjKCbpBCYkAtSyWvA2GU4OwqoXF5Zn/7A32NFOge7xtZoyAxsxPTgNNzwC8SNFH21vsmvOo4dC+/NUWq4V6uVvCAtkTh0HO3WYnDBwI0hxaBZvdUW3L3tEMael0PpLhxUfrhqRXeHStcExwJfenDWueeXTCS0huz1/ISlrurlSbhRSU+/AQzEeCdCfbtf4DAquxkGKeykobQrh29njJGWIj4gnfDY242h3hddGaK+ccRwvOPwK5yIUwq3bvW7RYDDKfaseKm5gvs3kmLPX3CqaslYqDYZGqI1QBKoYGUUZqHeoqIWQO7SIhXb8jYAmg3vr44tzyaX8sTIqQIMV1xWvuKcGEtYRRJhSB+tnq2jsgxmydNwCNCh5C2ovQVxNOzIBej4Tr8tifKYCbzaX+sPS1M5U+6GyogVdnyFYiQyCg/ML0IwLYNE2y7VnS1sXiw9NWyAoNdHcGt34dWiYw3+yL125IANQ22z7ZeLPx5ow1Ce9DtzWE0P8TDZMFjAMiCt4iJ0B00yUtrng5a56cLv9sxLAckTCHRKGVEpTdT8c+dfLF5tftc8ecbNXkmJVGh+2NCQHGEnaaPmHVlmIs/bb0eDRxD4EUr5a0fwPUfVVvcaX1VeIdpWW8yq4Nz2LC9QgkH8Ml6UcXwTrXvHiM30g5FSJvlQ6dII2v6sTzo1FMQUy9Q4L+epfiM7ico+ec6T+tdX2qMyqWQSIdTYPY0We38A978v+md5QePMXljmiOPwWtYnzjk+kpA3uaAfSQQKuU+szT+P7J5oMYvM1fSP7q7acOZVpo7jwoJWxijmNg6+2NgSQWE
 PE5+HqY8
 4KFjJ1tJafzduhh2WkV/1OgWWSZ6n17kSyIGS7XbtX+jCkhN0kNj5AmctWgozJki6iwg1Mrt0X1zp9WcqCUfcrLn+E7T/9XdW4b6Ae29qkygZovFoCLuB1PZIB1umNNezF638cFpKiZltlqiAdq4bu1KWfIuW3/mAldP3tptINlyaFvElW3cWvrX7CGJttNaQ7NuSEbCVPam25QvzfXwS12bC/qOBm7uXyNTOwU21XkZIklsoIZuxJsoL7uj6dpuULYBfUz9pE5XLvH4Sl4MKYt8gG8ZF0jg5DtXc5wR1VhboE/jJ95lI5VK6IhN7qo9ELyrBZHAH9OaXOgjBWwxrawg3Fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Tue, Jun 17, 2025 at 11:43=E2=80=AFPM Tal Zussman <tz2294@columbia.edu> =
wrote:
>
> On Wed, May 28, 2025 at 1:35=E2=80=AFAM Tal Zussman <tz2294@columbia.edu>=
 wrote:
> >
> > One minor fix and one minor cleanup related to the tlb_flush tracepoint=
.
> >
> > As an aside, include/trace/events/tlb.h isn't covered by MAINTAINERS,
> > along with other mm related files under include/trace/events/. Flagging
> > this since I see there's a recent effort to overhaul the mm MAINTAINERS
> > entries.
> >
> > It's been a while since I've submitted patches to the mailing list --
> > please let me know if anything looks off. Thanks!
>
> I don't see this series in any of the mm trees -- anything else that need=
s to be
> done to get this in?

Just wanted to follow up on this, as it seems like this series missed the
-mm branches for 6.17.

Thanks,
Tal

