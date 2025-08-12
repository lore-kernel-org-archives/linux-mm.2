Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59897CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 03:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965B58E00BB; Mon, 11 Aug 2025 23:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916148E0045; Mon, 11 Aug 2025 23:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B9C8E00BB; Mon, 11 Aug 2025 23:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FFAA8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:14:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 268F3135BD6
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:14:05 +0000 (UTC)
X-FDA: 83766636450.07.F667761
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92F39100006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:14:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=EGhk7LN3;
	spf=pass (imf05.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754968442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkTlVKfVYuPJQlHKCQwVV7GZENK2bWR3hvuKtvF5yEs=;
	b=QYpzZ1DWEI3XK4F+hs+hsdbj7lIlpNTAErnQZfLCNFFQZC3M654UgTODdLxhY3bN/08wL7
	ti99AuM6SKX+y1YFYe3GKHS530MpbiDcuH4Oug+9oySmSOBbwASXqIRz9dzpEk7VpgK1fr
	iKlY0rVPUAEpxI8Z5K17vDYxJ3kqOPQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=EGhk7LN3;
	spf=pass (imf05.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754968442; a=rsa-sha256;
	cv=none;
	b=y+jI4kDWJ0SZ/8WDfWcNGdssDrbrVaWOjH9y+G99fHBhh5Obb2u2WIIWzMlkuRmV+wtN6T
	f8WJitZXMeZuF/hYIiUdfOkbqohY/mQXWTARN0lD8pxFPmGZMqLVwKZsGxCHTeegD452Kg
	N6vm9NIT9TcVmv2B7QCP9hzblIju2pU=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BFmw1o021854
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:14:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DkTlVKfVYuPJQlHKCQwVV7GZENK2bWR3hvuKtvF5yEs=; b=EGhk7LN32ZDrwh6P
	UV8aqdgbKK7imYPRTgBdB6tQRbTjbG8wzebZP7AlDFSG7mY55osvOf46uqGiyJY0
	5/HoW3d0OQXRuLz3NqzhPK4VdWTBbFAy2C82Ip2VwL+J8ixvM0zcbvGt4qs0wrXq
	frLA2anr7exqejzk1sdYBshe7vHYoODba2oUyiKV6uyK1CCfpYl9S97769D8aNE/
	Lk/aORziYMad6JF4crv0cCuIgtcmmfY+T0h6BBRyOxlBl5tBJPNnpiRZXpajqcof
	7YwhCAtlaGTsip439xt/4zs7ER4q1V5NiOha3lm5FSK5vJ3UHKBXsJ+VnRIibhYZ
	Pvb7Wg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48dxj46k9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:14:01 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-32187814ef6so3108800a91.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 20:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754968440; x=1755573240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DkTlVKfVYuPJQlHKCQwVV7GZENK2bWR3hvuKtvF5yEs=;
        b=EQjn3/6coCOiUqIAoUVgvPqSdiBMfbuJTsgguk/1Ey27/A60wFxLyagzzijUM8oxR+
         iXHX8u1QQQvGXHLVuuL60Eyo5n315Lp7OZdbHbzNRnxLAazTvdGNkfTLHwbAVtm3jcHH
         Ui+Olw2+1/sTpGj56nrA9m3i/nUmQo9ejcigO1k4h0VxF93EhU+hZxNmfIaIPTetWW1z
         ho9KuuVrIzg6Tf3mw2vjg0FuaIPCytbyaveCoh/5uQq1+dWZGRKnNiwqHiI3nKzIsyu7
         iShS9IiAWLZmiQedON/VwOy5BfO3jzgHrYz9qS6WIu8luzBWXpQXfpmzLcjJquXbcIMC
         uHfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNnMt5Jz/bLWQsfuNxE6fKvfSa1Su3tMV6oSHK+SBhUQcbrKx5+/NPQjIMtM9ox5Jr2rc89EF49A==@kvack.org
X-Gm-Message-State: AOJu0YycyoG4F27b3AJwKZsn0aj6OaOQAOHyJ+M6XvaLqJu+NmYzL71c
	gw70+B6A8WBZ8wUlQyaCkzWwRWmKR4ggb0IvVXHfHImmmXKe5yy3BOMsO5C/Zrap00ZAXC0IFJU
	b8UoX7H+wyuz5FRyK/uy/e3e/i6kMW2PtptttUlG5rF32pDbWFwU1FITRfecMv1vg+ripZ/02EA
	rixeePBeaZheP/5fFSIinKzgRmZ/Dp
X-Gm-Gg: ASbGnctROz7CGUmEnSb7zpDvBCn2Stj0DtpgEDtQ6CgIPyLwf5nvCAHF/h5L2OGf6Yn
	U9HUfH9zGNFbHxS+SNhM1EHfkuy83RgzeJl25sYJ9yk57hWnyDwU7AsCNo4OztJmWOi3lzdlL9B
	p+nitAjsGtwH410AL3eTkapg==
X-Received: by 2002:a17:90b:2e49:b0:31f:d0:95bc with SMTP id 98e67ed59e1d1-32183c4585dmr18544866a91.25.1754968440117;
        Mon, 11 Aug 2025 20:14:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUiK6dnsViZo/ONR7KmYw+KPZQS6TalkPG/etm+Je1f0NInLqS9jT8UOECE9oao7uSShvDjBNgBEF+aFsCkEc=
X-Received: by 2002:a17:90b:2e49:b0:31f:d0:95bc with SMTP id
 98e67ed59e1d1-32183c4585dmr18544838a91.25.1754968439660; Mon, 11 Aug 2025
 20:13:59 -0700 (PDT)
MIME-Version: 1.0
References: <aJmjXABrInqumY1-@kernel.org> <20250811140246.3264034-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20250811140246.3264034-1-joshua.hahnjy@gmail.com>
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Date: Tue, 12 Aug 2025 08:43:48 +0530
X-Gm-Features: Ac12FXwsrjZcINNlzWI6lgdmeiQy0GqtD8W4UPHL3OIWUnCskvWeVE_f-N5opUE
Message-ID: <CALzOmR1BoVs4LGaygpE-fiKsRztCh4_tsESyFTT5qiHtup5E7w@mail.gmail.com>
Subject: Re: [PATCH v2] mm/numa_memblks: Use pr_debug instead of printk(KERN_DEBUG)
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDAyNyBTYWx0ZWRfX2ccS38lOGjhA
 4gIqklqXg7IZ0vBZT3Ircxyk8AeeKQHrvpFACG3Kfoq79sruBnBpFwIBJJE7rtk0Uw7v0WTgA0y
 epNP0n1Pwyeivk1URDFrmlplvKuEeEE3/onlXOtw8RvQO0B9k+tp67uH0BOtK7JW/ME/LsaizjW
 2GCEm7DOsTj0nU4TRgwP8MIyveePdCzmxwStqUYG5shE5UX7fI4hw8kNxAgmTfKTsoSP64cGdhh
 Yj8NUNNJ6MFXXtSvc7bYXBFU8rMbfCWVCrnJwOzvRahJmaJOzl6jQbXPiWtXriR6tiBpMgR9H0H
 JJ8hnOaNYHTtcsHszypxVS1wn2MaX6GvMNV/DuTzPr6uA6VTGFjFpeRTsAVoBXuZy7PSYqFyg7g
 JDx9s4Ft
X-Authority-Analysis: v=2.4 cv=fvDcZE4f c=1 sm=1 tr=0 ts=689ab179 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=NEAV23lmAAAA:8 a=pGLkceISAAAA:8
 a=Xl4m31Bx6Sv-n4gzfLwA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: BT3qq2taJScKkN5kYAtArIWc4MAZpG6m
X-Proofpoint-GUID: BT3qq2taJScKkN5kYAtArIWc4MAZpG6m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 clxscore=1015 phishscore=0 bulkscore=0 impostorscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508090027
X-Rspamd-Queue-Id: 92F39100006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9qbknhd3w8xp9pxjc4rf8az33d189yda
X-HE-Tag: 1754968442-346477
X-HE-Meta: U2FsdGVkX18rPkOz/t3MMpvNyi8BkYKNNZFY+RBtAJxR7oieFDKRbJv2aQSPeqUYd7tCL96ZpKY0TrSW4vluQqBcQ//lKjeJiiUJ/eWezvtp1OrLj86h3JGiKrMJmbwWh22pTyYDv2vNu2uEdHQbju0tsi0WNJn71NbynC0ScZcBhLLCFowvkYi0J+Y7++T9aAXbQ5AMSlDUytblhAb+5+WiEdLH4/h8vDKGvgHBsy56T9Bvjv6KFYlfsf1h16ZiAGYHuTD12niwyF9U1GZCeuFdrY1N8lzwjTuGGOiKn/6lV8fdTGzIE5f5L+OrlP0PKSI8ON+IqttVB14Qdxxv0D3ACmKBPlTd/POPT53wgr+uIgE5NVyyL097gBAcXOe7PJjJLfuSNoGd2huHsRVhe9l29HA/wHzJecgZmeSnfdCRYyfCLISYqKDRNjs2X1FQSJ2Fv9s4h5APnAbryvQygZtKvwqqp0MorPuFXZx2px/Gifl1GAotxGdvzp4isUI9vjffT5/VCbuECcnp0NneeSyLWHcn3dTeIDD6orlW++VpnEVe5Y84VzcpLbY/FLMU5RzLB9Oap3cVNJrpJBukfS5a8sS0yVTwq7gnE+5EIV4ks+x/SwaLGNtU+BGlUphubcns5Za8BC8+Y4QNP+rNllFc6FK2Mukwa7ZjVPxSd50wH7MqemPzcWRuZCO6QEAjXaXYfQUM/RHsfXsA6JGGKNOcbW5eUz8z8F2egVXiVWOUrkUfa17o5mpyc7VkS2jI0/B1T2HQdlKSvqeDOZpUKP3u393r/hbT8/85dKz6TJYCM0EvUjDfc6nP5y2a9fZrr+Vs+ek6fFzMlOO/kBFX2tKrpyBkfN0TY/JFsxaPYqf5K1hY6NhE+7JUarJThREsJX6N7awrbB658AdYfArDIF/x8JXRwMaI3g/jFA+bojYmpbEgv9beZhf73qB0dylqvr27F0ouzN47SP0ajTs
 NQs6O+q0
 BUtuq947gFJzKeWEOuO0APQQIopJ4tmphOQG06CWiD8+wZ7HBy7QD6PgMPhY4jSAa7Z6qP7r/isk56TZNf/h+ndTrF+xXCRtXioGcns6TLI0fdpmKlx7Mq9hS1LiN8Zrtn8hrK4gb72JLH4nFvEH70gkB04Q0SiWeq5wFQGFOqKKBrk8n22sSBYQioFgqufggCy5+yqQgyXkSgTt2zFwDP0fhlYRGZ2vfHhnbZ8lYa2Ih63d5lbfEVdd+jsqLKQOiYHbyJv3oGfD3dXanRqu2AdLbX21B9U5hS6JPoL+HngrFMZWV0fnycanYNhRLZgabb/VvK3ww7E+8zjjoyygJ6Rbnvydnog/gJ+qLUavG7gi571JM2/JWQq3pAhRbpxakp+Xz6OF5iFImr2IuwDmjuhRPAlq9RayulQAisN5/FSBT5Uz9z82Ibnn/YCTRrpj6HA3ZfvR772xX0MTvI6Gwsyuj89L24oTW/MNVQjbdEUyrK0U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 7:33=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.co=
m> wrote:
>
> On Mon, 11 Aug 2025 11:01:32 +0300 Mike Rapoport <rppt@kernel.org> wrote:
>
> > On Mon, Aug 11, 2025 at 12:13:54PM +0530, pratyush.brahma@oss.qualcomm.=
com wrote:
> > > From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > >
> > > Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...)=
 to
> > > align with the consistent `pr_*` API usage within the file.
> > >
> > > Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > > Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > > ---
> > > Changes in v2:
> > > - Removed printk header as suggested by Joshua.
> > > - Link to v1: https://lore.kernel.org/r/20250808-numa-dbg-v1-1-2ddd1e=
c634aa@oss.qualcomm.com
> > > ---
> > >  mm/numa_memblks.c | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > >
> > > diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> > > index 541a99c4071a67e5b0ef66f4136dee268a880003..ed6fcfca057ab4c9a8aa2=
6cd1929551b4ded4a5b 100644
> > > --- a/mm/numa_memblks.c
> > > +++ b/mm/numa_memblks.c
> > > @@ -2,7 +2,6 @@
> > >
> > >  #include <linux/array_size.h>
> > >  #include <linux/sort.h>
> > > -#include <linux/printk.h>
> >
> > Please don't, pr_debug is defined there.
>
> Hello Mike, you're totally right, sorry about the incorrect feedback.
> For some reason I completely missed this dependency when reviewing.
> Joshua

While the current patch compiles fine as some other header includes printk,
I see sense in Mike's suggestion to keep the printk header. I'll
revert to my original patch
in the next iteration. Joshua, would you be okay with me keeping your R-by =
tag
in the original implementation?
>
> Sent using hkml (https://github.com/sjp38/hackermail)

Thanks and Regards
Pratyush

