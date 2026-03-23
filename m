Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F33F483E7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0F466B008A; Mon, 23 Mar 2026 15:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0096B0093; Mon, 23 Mar 2026 15:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD60F6B0095; Mon, 23 Mar 2026 15:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC9E6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:41:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5493613BFA3
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:41:57 +0000 (UTC)
X-FDA: 84578348274.02.92720BD
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4574D1A0010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:41:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mwbcK/Fl";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774294915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhD/x6CWko7H2rTbKhY13VQ01meQMOQRBoD9zfMqn1I=;
	b=h6+vACvdZ1hsSwoeWaXN/QKOJbO/352e4kBcbYvI6qkGW0FozqPfvLThX19f5Rb2PLSXP7
	b8FX6eSuAj/bA4JdsOVUlQbnSTtnoMhAUs3FD2kpJFyE7U34I50eOgfg4V1FCvEtMTRKQC
	dOBqMwhRu8ZUWKhQSmrw109TgmIJfBs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774294915; a=rsa-sha256;
	cv=pass;
	b=dP2d24yJEzZ7QVVulIJOBmtk0mFq7RijbaRG6depXOEvatY+YWrtiWsU5rhUW3KbVbxsMh
	WeLqpfSAGZ+MZ9sX95vRGxLobDo2JzbT15lU6aTtRj0hQUxUvK+lWrXmU7Ua7wk50FhfBq
	baRBpNi2frYwtVt94gHof8nVLkx7I8w=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mwbcK/Fl";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-128b9b7e3edso7464737c88.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:41:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774294914; cv=none;
        d=google.com; s=arc-20240605;
        b=jY9FZzRg1DneHdldm3W6SL2MzPh+tHHlsCgz9r7p3bu5ci6TGGR/J/oHeu1drcildu
         VRsdis+u0E0ZEvtSbQmB2QFWVoz1zDDUsrEJo1zLTTfAw2Qrg/dtgINqMBQNdjb9WxGq
         91oXcAOdV0FF3i0Oz+EwBkm5NpkM/AQD980ezdxjOgexnONGXBKRNEaf1VPoDms5K7Je
         FNLCbRWMaAarMHIheQ14NVcB0P/f/ZdheAEssCPNJivCf+n2R7usrlKAIQVZZXq7Fk4c
         qUXz5GRWner0925YPxkyn5GvvT0wEnu+3JMIvvmMLyUey/98Vh30It0mCdrvFuRjEkxC
         tg0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VhD/x6CWko7H2rTbKhY13VQ01meQMOQRBoD9zfMqn1I=;
        fh=ZKJe09w5avp4zNW4dSxW3mLYzVoqqUotK4qpo80bmt8=;
        b=Y2qWhiSD1Y2Xis+hdkT53STsBN3Z71Aj/zPXZgqdjinYETc21MF0BXoPzMutHK5zOX
         KDCK1ifpKPEymXmJMXyBAxbJCuGjnwAG5h/0OMjGw7fqrtPL1aPiows8vjJwAfpGEsqB
         CtOZUSWk5t3X1QaSMUJh4hPz3atJyyrzp59WciMQme61sWBGrtbvSLWZocO6zpXwGCoc
         0sBEiXLpXMSxKRcZNlvPlVeLnuSrrfdt5w8IRumpy1VNAjw6rSBoF3WCqY3hHeLwi0Cn
         mi3JmQFmRP3zgCCzPNtoki5utghWKJ8Cd4xj7VrYInmIhXu9hac92SUANbJKNkne8+7Q
         jhCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774294914; x=1774899714; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VhD/x6CWko7H2rTbKhY13VQ01meQMOQRBoD9zfMqn1I=;
        b=mwbcK/FlhCT60WGi2f28R1U6R7Xu/QCDu0N4QLfag3p5yXGO1Zsh6Mq6Uzkp4OgaZV
         3JJRDXidQ9aao5idUpKDWhXYWCCSF9ad8Mp2biVysqlVWgWUDtPPrdB6VCfsmoTEK1pm
         nDcnPWcs507Z0nuXh/+T5IhiLWUv1bimw8Mg1iNEghMa5bMEcDEDxIBNp0f8NhRftQID
         qQPYc5HKQ932WErD7Iulhs8UeSypdY5YNr7A3U+fDgLDkKN+FdUmBuvswJiXLh9i1N34
         IJE7yMzD168UNPR4y8HVSVveMuMlAqTmOP5Gbkj3pxF6Z/G/GTH89ioJvJ+4JOfSoO2/
         1YGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774294914; x=1774899714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VhD/x6CWko7H2rTbKhY13VQ01meQMOQRBoD9zfMqn1I=;
        b=QyzTNbevpQudskvKWoLtYiKfeWALQoS7zCOKOc4L4hEYekyI/SKHuq5XPKoiplcCLH
         JqjFL+o/WP2sS3vv2kag++g9aR446vQZM+07QybqI+uBDHsNSezfa/yJjbvDvXv+jb0E
         yzLmiObDEYx6PTiM5+tX5eNkIzYVjcQ5vm6lLNkOUyLvy8rwEuUWn3dRYWbHlao/8ZIM
         iv84lJzaF4v/IdPuPpZgbC3TPusvmfqV0d0ozFDAM4Q/c9aSVM3d4Sw0XO2DvL8YGsDZ
         bM7dds6nYCmEg21LYkWoENnOcgpseRZ9qiYFs/Y+SO2zamQHz1OxxXv44fuaAUtgOj5L
         aMbA==
X-Forwarded-Encrypted: i=1; AJvYcCWVNC2P49p6VfYBLKfEmzXQWIDH6hEToN23cHVOFnbRc6vXlaOYwC+M0LgM53ulVbyMQCDc25/kTA==@kvack.org
X-Gm-Message-State: AOJu0YwTtSCrj2+OT2rvgn59oaAdqW0+YqUllGU5Wb313ftqsofD1n+B
	ClWUmtL/9LO43EKBIPV1F/VkaLxjCliTuPypnMKSvXKKnPqBGA5uK8dh8+iCoEdZzHTIANpthNO
	McH05hCTvTigECTCzvkf2lqHs3rCCWw==
X-Gm-Gg: ATEYQzwErx7yLEXwXpGFOJSXBRezSwcqAjYCVPc1HcLlMQgsf5+osfDdwJ+63/47THx
	K8KJuHJFBcNPTC9HQHehE78pVoFrF75FY5XHKyI7JryKoj8598AwI/cknQQxu9h5fUhD5M/b2gE
	piB32VTL2167Y1LzEF/02vOs22s18CWz5lW/xQktiHZpTIsLP5Qtko1PXfilU+J4CPS4ZL4U/+d
	XIJjRzzBVFPwbAjawNqY1djalPLAMvyp5W0Z5XmVjbej1k/kBK/QTO6WGxsXjL1hxYGAp+fTzH2
	P46XSGs=
X-Received: by 2002:a05:7022:eac8:b0:128:d39a:b124 with SMTP id
 a92af1059eb24-12a726d95a7mr6584836c88.19.1774294913893; Mon, 23 Mar 2026
 12:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260320190453.1430-2-ravis.opensrc@gmail.com> <20260321165425.84273-1-sj@kernel.org>
In-Reply-To: <20260321165425.84273-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 23 Mar 2026 12:41:42 -0700
X-Gm-Features: AaiRm50_X3MTqd7TbETXCV-fpp-iatrBJyNolNtz9qo9eeLJuyZ9kt7eVE9VXlM
Message-ID: <CALa+Y16i0f5D_ZTVcfVa1DgeZL1btvUJxjOvoyFEYNkT7K-grg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/1] mm/damon: add node_eligible_mem_bp and
 node_ineligible_mem_bp goal metrics
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4574D1A0010
X-Stat-Signature: w4brs5mjztztfofihap4kmcsyx8arb3n
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774294915-947026
X-HE-Meta: U2FsdGVkX18hQQNmogUL0ip3kc+qrKBE4Ho/57mim3hOowutUf8vq3wwiZiQhP5WKYWhHeN/WgAelvaI2Q7mUfKyT2jhC7CsveLy35CEHEWE32czkwcOnAgflE9vmYA0LgveSP3ulUzL3PtMHiKf0UTzpcRWiw1oMMH1PFiN6XtDz5y7DO5x+gq0wKIyk/6tgXhDIbKmq9sPA6DmxIEM7WoNhdVWxk9dQ3TRrYOCCwKlVd4JQp4TsJ2K5bSdzScJvzE9kr5xqmns3XqUb15kD8oliIElck2jtwJWTvf1lBX+zl7hPziVGbxWLuGjNhmEMxhT1mYIY4f1g4TM7eMwzUbKnSTf2D3xVRJRLuq12Q62q7ysbC8BACaEVpr8IqdXLz0JRBBbiytdIOE1bHMd6tvFGHiMrp6+8jTD1V3/UipExZKAcIgOUdlrmaGWBzT1bnEZY0zV7cYB9hhVmZ7W1EKj5BgGN7WHSNkpRwoma0LCEe4WxqMW0Z5QMG4SBh0yDTaTGnsTSSiQbeYol5+PXFv6Q4NKYl0NpmFtMj9JKU/5VS9s9Ehg9yorohtUAuSRJccxKuhOL7p2ob3NCkyDnBXT3OkIdSvx2fioxPTPmpN1i+vDAJOfoi7LhIGT3qaVj5XJr8fVE17Vyb9PX2N3HfF4G1wajlQRrKy2hi3cfL8szugIDjOC+jhrK0JaUqkXFacCdhHrsju0Y6NdICgV7kocrZ0V+aZKaTzKBKEkC5YRqE7l+681/Clk0mOxhJWjrpKen9sB3Ec6w4F4zt7XKVFAugFE6v8eq6vfOBtqFhkm2XGaD7HwEpbCQ0b+FRWOLt+IMbY6alAwZmxrSsgaFL4iSZjZj0PTqb+JRMISOKTjIIys1R0BwBdBVCnXezCGyHPsdnazU14PA6lGN0ana6ELkKj7ikEN0ji9IXYPExF2VrSgS+EovrxKuHuWruSL3BthZBjibStE5Pib2he
 Fgz397MA
 lTiL0rQzCugbTQrckudoiMv1CRNcsSJjy9CeUepp6YD4A3MhqEyTSJFBxyQzVljfvZBDCTQO7lxIZw4LZ6Vj15jr7rsW4XQamHvUUZRwhwvLgb5ni2Dc3Jotut2Ck8DwZXoejhawFtjqSbu9z5k/qkHriSIiqhZPSZYqS/s6uGMxuHQhHeko2xDaL/BJwkNkKOLwxLiU+YDffbzsU5Y5WKc9XgBSouZTYWobAzVeS+B3lkLSbjrslSY4Riy4ivPba/pZEcy9fJhmVT6gbHgfbfE/6s/COUW4bHHkOpqlX32c3tyOvc104avZChOmSrYSMXx942bAVFApJ33Eha9tJjfTh1VaZk3d0hhr8sE448m4hEisK0qS773+CmFhlaglfHi923cpt10+cxDnKDrwpVyhofaS8jWDDCPdy8rhRpxhsFi8ZF+y4QXCm0AIRqzfll6HG1xm/c69sAYoycCQGHNEAsdrKgN6Q6kfh9/9KbSKiZunprWt8/m+cI6ExJd8xWRO3JNknGJLBFKKTYqmgvC636X4ZyKW6oPmwW3QIMrtiiqewyDDGTAe4LKjMgMiT6x2Db+9WskSYEIy8T6kpMCgN3tYvPRePbRKtoK3R8hWGxZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 9:54=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Fri, 20 Mar 2026 12:04:53 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > Add new quota goal metrics for memory tiering that track scheme-eligibl=
e
> > memory distribution across NUMA nodes:
> >
> > - DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP: ratio of eligible memory on a node
> > - DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP: ratio of eligible memory NOT on
> >   a node
>
> The description for the second metric should be "ratio of ineligible memo=
ry on
> a node".
>

Got it. Will fix the commit message.

> >
> > These complementary metrics enable push-pull migration schemes that
> > maintain a target memory distribution across different NUMA nodes
> > representing different memory tiers, based on access patterns defined
> > by each scheme.
> >
> > The metrics iterate scheme-eligible regions and use damon_get_folio()
> > to determine NUMA node placement of each folio, calculating the ratio
> > of eligible memory on the specified node versus total eligible memory.
> >
> > Suggested-by: SeongJae Park <sj@kernel.org>
> > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> > ---
> >  include/linux/damon.h    |   6 ++
> >  mm/damon/core.c          | 158 ++++++++++++++++++++++++++++++++++++---
> >  mm/damon/sysfs-schemes.c |  12 +++
> >  3 files changed, 164 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > index b1d8fd88a0fc..490918804f85 100644
> > --- a/include/linux/damon.h
> > +++ b/include/linux/damon.h
> > @@ -193,6 +193,10 @@ enum damos_action {
> >   * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:  MemFree ratio of a node for a cgr=
oup.
> >   * @DAMOS_QUOTA_ACTIVE_MEM_BP:               Active to total LRU memor=
y ratio.
> >   * @DAMOS_QUOTA_INACTIVE_MEM_BP:     Inactive to total LRU memory rati=
o.
> > + * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:        Scheme-eligible memory ra=
tio of a
> > + *                                   node.
> > + * @DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:      Scheme-ineligible memory =
ratio of a
> > + *                                   node.
> >   * @NR_DAMOS_QUOTA_GOAL_METRICS:     Number of DAMOS quota goal metric=
s.
> >   *
> >   * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsup=
ported.
> > @@ -206,6 +210,8 @@ enum damos_quota_goal_metric {
> >       DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
> >       DAMOS_QUOTA_ACTIVE_MEM_BP,
> >       DAMOS_QUOTA_INACTIVE_MEM_BP,
> > +     DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> > +     DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
> >       NR_DAMOS_QUOTA_GOAL_METRICS,
> >  };
> >
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index b9e12865622c..3e0ac65e34a0 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -17,6 +17,8 @@
> >  #include <linux/string.h>
> >  #include <linux/string_choices.h>
> >
> > +#include "ops-common.h"
> > +
>
> I don't find a reason to include this, and I'd like to avoid including th=
at in
> core.c unless it is really necessary.  Could you please remove this?
>

The include was added because the implementation uses damon_get_folio() to
determine NUMA node placement of folios when iterating eligible regions.
Would you prefer that I move the damon_get_folio() declaration to
include/linux/damon.h, or would you suggest a different approach such as
adding an ops callback for the node calculation?

> Below looks all good for RFC level code to move on to the next stage (dro=
pping
> RFC tag). :)
>

Thank you, SJ! Will send v5 with fixes once I hear back on the above.

Best Regards,
Ravi.

>
> Thanks,
> SJ
>
> [...]

