Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 385FF10A3D8E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8141B6B00B8; Thu, 26 Mar 2026 08:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4B66B00BA; Thu, 26 Mar 2026 08:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DAFD6B00BB; Thu, 26 Mar 2026 08:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2456B00B8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:43:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02E28140C83
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:43:02 +0000 (UTC)
X-FDA: 84588179046.26.C4CC92D
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1904B8000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:43:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k9ccN9pN;
	spf=pass (imf02.hostedemail.com: domain of naup96721@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=naup96721@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJs5QJBGG1FM2VvPdTH5F9RsetpEkS8GbS1JPRoYtms=;
	b=GokSUhwnNXxXFXZVY1TWXRUZ3kSINmIXEMApMIAM7BSfMZQTPcm3LJ0wY3YOkA41Av62vt
	nzQQ3bn0JPMGnrFoAM3pvhBbUr551pO10IofBAqUzU6ZQ4TsNB+vZvOpr3HdLL2nixon6m
	3GWCJ/lxGgVySN+2hZdQ6Ovk+ccs0Ks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528981; a=rsa-sha256;
	cv=none;
	b=JWk2e3g8UD7pDxwUsgbI1IsopqlnKcg/WLH06mo+GXkhT/lzGQpP395LF9qW1vctOv+Deg
	we8bOJoWP5T7VP/9RDQ3zlYDGXYpNhb2nSfW51pT+a6cXkobKzcDSNWQ9I3psATtJ4mqlg
	IiU2KyoFz99UdBKhv/BLKpCmcpcsdn4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k9ccN9pN;
	spf=pass (imf02.hostedemail.com: domain of naup96721@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=naup96721@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c70ea5e9e9dso449811a12.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774528980; x=1775133780; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kJs5QJBGG1FM2VvPdTH5F9RsetpEkS8GbS1JPRoYtms=;
        b=k9ccN9pNrkmFb3jpJSQNgIf+2DcKzyjQ7e9bTE7Qj14xkTguOtuV0ongBPbBLkIKuq
         3ozKy/K2a3ROpODapy98XiY9mGg17GWYIjW//xsBoQUpFkjd8udi6rWHr1qPn4wN0lb+
         8g3eEBBGNpVogqeiGo/7hR8XHCwX5ljlZ6qTR9DJ5/AaH602Li4TuaCUSR3hXaVfjg+I
         oE+Eqa+K3M0NJ/UHpj7Yf78bcsXZIltzxHqnPL0GNQOKxNHaJHC37AqSsRJ+2ul0Q3pH
         gSDPSs+u9f8K/mblD6T+R7SAnH0XOo2+7Jyp7BqhM0TewfZ5bJH5DjVTrZzyxTQg1nds
         Zkow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774528980; x=1775133780;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kJs5QJBGG1FM2VvPdTH5F9RsetpEkS8GbS1JPRoYtms=;
        b=RssIq0UCrOe0zGC3ubvW3YuMg4IOgIyrKuutb0o5w/zlg3uCWtQYth1FnaIExjNWMH
         2SF0t96Q2aWDh67a01ZoJjtT1YVfk1lFM6wWwgsAfAufM7eaMCfz9YI/sNr69n/3da5u
         T5ySbLDHiV7Su0C/rCKvqyF7MI0UhprLiBPVkLO4FoReukG8kE4HoX8tQtHEhAoY2HBQ
         sx6tY+vgoMugatbVQTM42doboxyI9JmjHS9MGYlpRgb2ewX37pSimcAFoKRdAU1/joB1
         5XVcPYOiCKgBU7JufiQePwnL24eDbfobeAQx1EuYpEOHhJegT8e/zApAPfyQKIupDxMg
         XR0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXCHB08B6/ZYkzjzftuWkJZLO2cRSXKhQpm+t4Hfr9+PhaN1IMkDnjtU9GiFIAii6QXLLFqZipgeA==@kvack.org
X-Gm-Message-State: AOJu0YxOg9KAWi4KHpO1mH7ZfXbRlhQQwQc5sJ0mWrM2pRXnzxGLl/aR
	EMRIhrSm9E9ql0XhXVHdDv1dQXD/0Bo4BkGCseCyiEM5EUYfbFYKNBGu6niDOIUVtTc=
X-Gm-Gg: ATEYQzzs86JBCEYFWllcGs9843etqp23oBMnKUAYiIaWXe/BIy1iVtR9guph3G7Wu46
	04xWGvCbft5fCZFwzFbBSRNpELOogcOrdLrfjMw98UECPW7jsvuiw8wGBcHCdOfIRIwXy1eqVs4
	d+j0cemrvUcjMxmyZFFfnofOutcOnNvGvew0e8pnsEVfENRFCXp8H53B19lxNBhrVe7qA+ckep4
	A5YnTxwpioqDE4jFile3ZDuSCBbQWgAJ5eTTV1wfK+xI5e2I4gGT+XrFfAZfguBl0DawApiVVp9
	3UiOH9cDEiNXYMShbDFe8+rXJ9BCpndPIfDJn+lpdt268typgWhx0Tl/WLDoO7WwHUgLi0Yo91j
	hpaZrAFNoK/AxMDVYfEPcclMrHdvGZOROuUzo8tLlGSWWaUYQuBWvCjvRUamnAF5jra5y23JuDd
	oJffd96STnxUPcixTJAA8wdjLsYbj8ka8f+e7/B7qNvKDoHgWwVlMIfFOSX0UavhhegeH6GVddJ
	IZ73YI0yRfk8mk=
X-Received: by 2002:a17:903:2f4f:b0:2b0:7509:1b25 with SMTP id d9443c01a7336-2b0b0ac1de5mr87112115ad.37.1774528979694;
        Thu, 26 Mar 2026 05:42:59 -0700 (PDT)
Received: from naup-virtual-machine (111-246-111-57.dynamic-ip.hinet.net. [111.246.111.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc881bacsm28941455ad.46.2026.03.26.05.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 05:42:59 -0700 (PDT)
Date: Thu, 26 Mar 2026 20:42:55 +0800
From: Hao-Yu Yang <naup96721@gmail.com>
To: Eric Dumazet <edumazet@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, mingo@redhat.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
Message-ID: <acUpzzUMMN32WriG@naup-virtual-machine>
References: <20260313124756.52461-1-naup96721@gmail.com>
 <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
 <87fr5pgp5x.ffs@tglx>
 <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
 <c892e7ce-473d-41e5-aa99-b95e0366c3fd@kernel.org>
 <20260325151445.GH3738010@noisy.programming.kicks-ass.net>
 <CANn89iLnJv9_HRV1vuURFM5uVA-y4SqBsBRD24kSJe7UmBtXSQ@mail.gmail.com>
 <20260325152206.GH3738786@noisy.programming.kicks-ass.net>
 <CANn89i+cJ+BOs_swGU4vHbKPHVV+vqmHjaSywUxDzBu=nXfmtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+cJ+BOs_swGU4vHbKPHVV+vqmHjaSywUxDzBu=nXfmtQ@mail.gmail.com>
X-Rspamd-Queue-Id: 1904B8000E
X-Stat-Signature: kiyxorf749b3xuyjacapy7mboapm99a9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774528980-87335
X-HE-Meta: U2FsdGVkX1+z/s5c18Aso3fMTbKhHpic6hRldNhooh+5oWFYu0oNQTMJQOzD4jjW9Yb2aDJCXnK94Q1kLPpVhDfOouRTL7CSmkMGZr60OEyB33plGaacHjwmfcYKt13i+PyokhYrECElW/VS2UF4O7A06Un205yns5E9IK8UrENQVBgDIkNWYLXdAAVoFPFfvUy8y4L9npIW0hg35uh+s1tK+0bHeZc4ZNueJUUdC+9wE7YL2XnO88oHR6ZNiwjOo6c+fxuLAGPfSj+uFtW3qtaIvCit+EixEun26kphTSsaWxEVDHE+M8y10tL6kyM4QHunpIfvXOdyz+U8XlHixr7JEbSoPebOJRKZk72P3p3SpyeGDcQhM7QObT9omMITTmS9PQf3gsAUkVZgAIqPBDrIlsrp/fX2n4AAv98FKnxMFctb5HC1Hi7+Askjcy+CTIcoM5GJNHcsc8t1U93v3+a1yeA8UeUMX/LZfj22wRkEt6+PfXW8f3Sp6qbi4L1Ofpxz3DzsN6uz7YbABy+dmq1MDlpkvdX+pqOhQovbxMuRg6GLi9xeL1/zIribxnZPiunV6p5dblyZHJ3hD6aqezAXhaw6xFnwn1jNd7B3sUrzD0OFbM0/4tg0FrmvQmbLtzlfrOoI/UuHRIh7PORHWiAdZaVUdN5HucLFO79+QxR8mztx34CjiUGKhNiwWMVpUbFLVwZ2zYY4g5aShXy1XtLq/GwnaOJ+DOzX+moXDpJlpb9/QWXmkNqZFvjjEtGHkww0bQ8jTqCTjiXQ8GVVdysJComImjGwaXwa5TudyzzWhhJ16cl5fM87H8avG8O4Bw8MXm/gUwKAJg3ev5sScUEOjl7vZfvxiR1AkO4f2BbbA3IE624cY5CFhiPDGqFj96+HITv52IA9NULigEno13IsCAQexfHQRDqOVvA17KQAub608gRnA8CJN3DIinH0+YPmpjqzYquxrTPQjrM
 eXSHbOrd
 DIUls5pkjufsryJlosA9N5IjQee3w/u2igkASsAaTt0NVO7KReXAEtUI4ZLNvrDEQz53SrdzHWcwQdV0JKf4etOKdjnXtW9nCcwqkEJeFJpdVj37fjvaOiq/tt6CamlfVkjlld9YZmBPxrz6r7hNMho3EBeO07fxFdiyrMu8stAqtGVViSlBZc6wCBNsFCrlR0+92aBMNA10c+uVv9zsQmkCXHuUq5Vwv4oJSfkeUEnJ+CQ1IfrODU6EYSC+PSlMwc2rYwVHjbRaCrGwMjtr3u5tSOsM000MTpGW95y3k/Xfp94s5pe5VxbY4TfKn5FC0FY7qvNOmgBxMueagrb2DwIRdaSGpKpn8mI7+M8cBeJ99f2nM434MaRNMY3iS+IOutbQ2usx81nVTZIIGJMAMM+QjWVi8hGxB7UJXRQWXhl7n5wTdbJPO9l9xJel8cLs//+rWBqXcRReVprPndPoug6vI1xE1FDG9bOyAtM6QQgKRJ2IyxvBXori4ugthhPmAXktxUujyJVEse0GpRqSWs2CsJq7OA0j9m6Ydh8tvCMJrGS9RpbUdMsooADHg8DUpLDNtYqAHcXsDv3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I need to send patch v3? If i need how i need to change about this patch?

On Wed, Mar 25, 2026 at 08:25:29AM -0700, Eric Dumazet wrote:
> On Wed, Mar 25, 2026 at 8:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Fair enough. Like so then..
> >
> > --- a/kernel/futex/core.c
> > +++ b/kernel/futex/core.c
> > @@ -342,7 +342,7 @@ static int __futex_key_to_node(struct mm
> >         if (!vma)
> >                 return FUTEX_NO_NODE;
> >
> > -       mpol = vma_policy(vma);
> > +       mpol = READ_ONCE(vma->vm_policy);
> >         if (!mpol)
> >                 return FUTEX_NO_NODE;
> >
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1026,7 +1026,7 @@ static int vma_replace_policy(struct vm_
> >         }
> >
> >         old = vma->vm_policy;
> > -       vma->vm_policy = new; /* protected by mmap_lock */
> > +       WRITE_ONCE(vma->vm_policy, new); /* protected by mmap_lock */
> >         mpol_put(old);
> >
> >         return 0;
> 
> LGTM, thanks !
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

