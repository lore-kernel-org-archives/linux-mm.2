Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29AAFCC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41DF36B0095; Tue, 13 Oct 2026 12:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5096B0099; Tue, 13 Oct 2026 12:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5A96B009B; Tue, 13 Oct 2026 12:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CFC76B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:48:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E95C120D65
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:48:12 +0000 (UTC)
X-FDA: 85318185624.02.15B0F45
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id BEC0980007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:48:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ryDunluF;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791910090;
	b=XR/edapZUSgyQ+WwImJ8NtXDceAsGwV6vWpFSXe7UggpkST4z7Xo+EQK60YCXAycWJUKYf
	3fztKXyK3/YTEDrOhoSTD9h0KBJrA5A4cdJO5gg+vDx9AAbGLIPdbYl3sAGbqQRn7SLzOp
	mMHEUAMxkmPznKBB0hSh8oICBv6RJFQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ryDunluF;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791910090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrdkhjVWS0paU+Qy/xA3FUiCVMdE6viTRALFdsJ0zOM=;
	b=Y8ynQAtt3Xc7VaKJ+X6vj/Xo5dA0xm/Q4TDdUEGSh+Lf0Do/OxyRnT23J8AYdfBoVCdySF
	hTPx6UZhZVsji+hfpT5WUhWZ1CChWQI8t1E3AEYjIVgHrMvdxdqt87EylnDLod/Rj9wxqc
	53URXk2VRZJDPijCpiizusWlV68iRPA=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5bced78b3dfso1955973e87.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791910089; x=1792514889; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JrdkhjVWS0paU+Qy/xA3FUiCVMdE6viTRALFdsJ0zOM=;
        b=ryDunluFoMuAwL6tMj7BpR3NY4N6RrNKjWAQSQ7mEd+jwUnuI+2M4xyph5m6HcbF49
         X1ToUP0mYFFxiRFTA1mUu9JUyQlosNbCT0YfogWocFYwOEs6o6gJho4K0GY0szHHb8NU
         0KInwqLYQnnVcqXqBoJ6w+qXC4JE2oZ4Kz7kmUHii5maHgqILn9i02r04ZAQwSeNU/YS
         j6xkwnGi+XPAeZAvwjYJbSIpTFA6Dk21jph5ICK1els5Rig4dFiqOlKrLsKOsl9prqp0
         1nIFuqc5pzxIDWeH02giZNqLYxWZmJZb351+CIxcRV7WbGXGO874mCiG32uA4ZzTFMPG
         UsOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791910089; x=1792514889;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JrdkhjVWS0paU+Qy/xA3FUiCVMdE6viTRALFdsJ0zOM=;
        b=f4tcZBnmRMrss3yZNgjTQmOCjs37Hid9nBy7hE3SWIJY+6eUlY2HpUCgD5mKa5zPZK
         Zi0sXRniO0AzZuDLhqMX81yHuM62TqCf81OWfbgemN69T8RJFQYMuI8gVm0Q8rCgfq+C
         gWibWMU72hd1gFLVvTj3jSVIKoD/W1kGdzM1+5Zpu40iF8aNIcVBMXcoBeNUbgMkw0io
         H3FsL99Bfgz9R/jS0lgUdFwzrlPpNshf9yBDukq4UGsOqfQwOKQLpkOK0910kYJALhwJ
         AVL/ReNS+x3YSY3lI15V9dIgDuNnmctNq5Osom4Yelf4ltYJ9SrxcNuayMcPbyExAJbf
         Kj1g==
X-Forwarded-Encrypted: i=1; AKwUvBzTNE52Sj0R3vaAJqKgw1JOYQLkCk9cYIlquTr2DO9hjmjksfBtcm4WaEZHVYBEHBwxYZb/b2znXw==@kvack.org
X-Gm-Message-State: AFq9FYJ5u9fhAyIPeaN3FJruNoGPyy2go7xRvTGoX6A9DLxwS+xTUZoy
	uzrqjtTZX/3M2SGfp6XvFcs85zWI9i8z5Xvaw9TENZdi+rgIWKZMCu3T
X-Gm-Gg: AYBFou1YhAnOdoO+45X8uFOV4gHF38ul35LKj8AlixY6Ncye1rxQn6NsQj+JqkEWSm5
	U6ZcaSWwRsX42gf5ezU0pARoxYmA/FTMa6c4IVbTfIfGH+r84mFUtuZZDnIl25HtjwW5fpqyNTC
	pbZTvvw980corK1J8kjN7aBlHEtTz+S6xPlyicawg1RwUj2Pj+U9+xHfYpZ/ouYeFTKGHMzlqmb
	z9aMXYiVUWpvhWqsy8vb1hXBH45pV6R8+7+DQ4PR21Xt9at1TFLTtBrnKgnGB6m2lRcfGG98uif
	6MgVFCFUZqTnSNGSm5QvFtO+ZkLRTJziLH737+19ivA6kGp3PIvpnSeF803CzI6Y/BvbOx9kJOf
	v2kxpZP0Aa/E7tysiDBck1sqG+Dhp625npw0Yl4TxaTOG8O9r/E27g48JasCdDa7yDmReFl10LA
	Jaaaw57bREHWcKA0wAY9PRYVSA7aqGEwRhwfqdF7/Y5hqJ7D6+eUzeo3pWIwt62WHj4ooJzHpha
	3ZaZ5wowfKfP0m7m5F8fOva
X-Received: by 2002:a05:6512:3d0c:b0:5b8:f309:f275 with SMTP id 2adb3069b0e04-5bcde8cea91mr4857257e87.58.1791910089239;
        Tue, 13 Oct 2026 09:48:09 -0700 (PDT)
Received: from pc636 (host-95-203-22-87.mobileonline.telia.com. [95.203.22.87])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a9c3cd2f24sm37276021fa.28.2026.10.13.09.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 09:48:08 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 13 Oct 2026 18:48:06 +0200
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>
Cc: Hao Ge <hao.ge@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 4/4] mm/percpu: stop unmapping the CPU that failed to
 map
Message-ID: <as5gxn6i2DD0iprj@pc636>
References: <20261009063619.112313-1-hao.ge@linux.dev>
 <20261009063619.112313-5-hao.ge@linux.dev>
 <CAJuCfpGEgTocqrdpOtkOfks-geU0vVMZudNEG5+XWi3sxQdymQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGEgTocqrdpOtkOfks-geU0vVMZudNEG5+XWi3sxQdymQ@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BEC0980007
X-Rspam-User: 
X-Stat-Signature: ahhj83mkiehbk3xye1w4i7iziooi4mdd
X-HE-Tag: 1791910090-311257
X-HE-Meta: U2FsdGVkX1+jVLV1fa5qqZN9BOkvdLtF55mFrBKsRiJvvK9mU4XOBn2ffbpAi1+cXpVA7Ypt3K+GfWamgfMxdH9BSkvKaz4163Mxo2aNSvjHPneEwvnSLOVTLPJ/Noctv9ZvsUCrOP53lhqAi3rnLm+Um0qiglxU7I/pI1mi7W3rWxiRyQKxLem4fVr2Nru+H3I/LWtQwexNPrUukOO7uxvJekXUR6P04c1p7hrPpgIBQKMv7aP2B/PRdbddKfNzasns6Mnox4BMz2VHpMzZBfkQSS18QOIDBJDzRDjYjNFhuQnAtGjgOzUYTAi5hFVOV/N5l7Y690pYnrbyMMs1RqYAK643oGjbE+KiW2reDme6Q9p7jFJ+M08yfiI5TSYL64xHby/7Ds0ihR7g6trGq1GaZCQzk7kOXQhARR+udvauUmPrF+3HzofIslGLpXHs0pTOjmC7PC+BqnQp5hjyNIfZfFSHE4U4qG+TaZC3/+8Luru4jRhmJXmUmQtpBqjCwIRuwsFpABbNsLOvHX1XW8lBy6zOcVicF8S+XwCjBdp4asWR/yuTZa+6MWkhxUV7D1mYFAFcRgcIoiFayfHbZXXY9BLxr59TlnaPAR+yZLK3B64LQ92CvmIAetlmkVzBTX/rE3nslCZWX9ykGYHcgIYfGHflMb14Ck10DI7H9ivCaWgMrUOIOXvGOP2rCrGYWFeWsOEBQf0liMhzSvQ02VtHT+KWEbRnUONBFJXjW670w7+3cz43vYt6L4/XHD+d3dl81OgCx5R+0fB7MG8O98rcz6SSGxmAIbS+kIFqYk6eH/pDsDhz5C6M7knlG4TWrlU8IQ792QRpX1mh94QHsqNTMCieItrKiBEKYPcfQ55YeHea4959vStOWxuq8yZRIJkH7lyzxiidKbBlgjqMFCe3cPjHDHm2jo8zqYdU7pZ88j3rR+MOvglrlqUGNGXr35Y+CE5u/roKw5FmjJ9
 9brBnnaT
 fxgTQ8bf0bvikhCIiOEkFkP4S0lbG6mXxxK/s2d7sHLRbPdLv/lDXwdDkdlYcVc4p9SXYugwkj68SQBZooiEZLefHBAIHSnC2bCTu8Ss9luaoyszjlft714YcMYRepf7kwHqCsCdQfwTWV23M2nAYO3EzqFBisipne6yxjnB727PtJSY22ZjIYm+jUAtKWxt2sjhy2YiySok5haZ1rJQFenoG7TFFbIrozfqdJFYeP7Vf0kiyCnketYg2EzR+9nF8w8cCXuARnaIU5Hu6Mhq3fub51AahpxwaTM78nVt07oUoo+tXVBPf2dNFGRuoN0rs8K8M/FOWrywfXP1SQESrHwUr+Ag4+jYb5BuDWZvAfianYkCwhAQI/HeLLW2/ZzSjLEXdgmDg+4END32gdk8xMGHJ+QSfBtgOknkpeKbWPc+Y/EuQ3ZCFlDva5s1+XkwtXAolZ3fVgubR2Q2za2jfcnASBglJK5S9pEKouqqnt554d4NvAZ/RFcS8/9pQ9mXCyu5EBn70mKnzzOpuJb2KZSu/ti1XPtiArkmfFqJx+o2Wy/GahkLmchZSTun3ZZpt7K4+YTt4svDwhe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 03:46:43PM +0400, Suren Baghdasaryan wrote:
> On Fri, Oct 9, 2026 at 10:36 AM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > __pcpu_map_pages() clears the PTEs it installed when it fails, so
> > pcpu_map_pages() only has to tear down the CPUs it mapped before
> > the failing one.
> >
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
> 
> > ---
> >  mm/percpu-vm.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> > index 509d8901835c..59d3a336a6bd 100644
> > --- a/mm/percpu-vm.c
> > +++ b/mm/percpu-vm.c
> > @@ -252,10 +252,11 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk, struct page **pages,
> >         return 0;
> >  err:
> >         for_each_possible_cpu(tcpu) {
> > -               __pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
> > -                                  page_end - page_start);
> > +               /* The failing CPU's partial mapping undoes itself */
> >                 if (tcpu == cpu)
> >                         break;
> > +               __pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
> > +                                  page_end - page_start);
> >         }
> >         pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
> >         return err;
> > --
> > 2.25.1
> >
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

