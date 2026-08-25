Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB2DC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EEE86B00AA; Tue, 25 Aug 2026 10:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F3E6B00AD; Tue, 25 Aug 2026 10:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DDD86B00B4; Tue, 25 Aug 2026 10:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6908F6B00AA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:59:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7DF0160449
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:59:57 +0000 (UTC)
X-FDA: 85140101634.20.B6087A7
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id E45DC8000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:59:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=I5ARymHc;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787669996;
	b=tzrDOtbqFaGtLdoP+xFd/jPW71etC52MOK7gysUgx4MaCLj1UZ3yyxtxkA8oQeKgCacWJS
	I07QQs9t2V+wHl0zxwZfyE9JYiQvaT6bBX/iGw/WNBPHEAbwz61fBFb0kIWyRNGloi0amd
	SJUcZa4zAMOceN0T59ylXAZ9S5ZoCYQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=I5ARymHc;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787669996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06QgDRd3KsQRNkIC849obH3kyg/ANunDmHU+Cwu/Xpo=;
	b=JWCwquZvIri1TP57QoAEl048bVJX0cDEywsZNT5op5r+bY0u8+ZAdu04fCPUjUELxrzc1a
	ci3NJrOZfw2t9gQPQB7NhnOkCcZI2ACrxMUW1yh4HE8znKE0kYpPgW12l4CbdEGcPhkjJu
	7IDwp04QAX2gEQ6dqtVT9hQ/7/fl1B4=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c167aa9500dso746765166b.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787669994; x=1788274794; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=06QgDRd3KsQRNkIC849obH3kyg/ANunDmHU+Cwu/Xpo=;
        b=I5ARymHcrdaVVQvA+2URE0KaCg0cxwAeSWxM6c7WC/pkXgvfchQigLsVdgRc2GFT6E
         tnhbqLhOKd+JElrTv8bNy8CmoAgPm9RckTjL26MBeHvU1IlPJSOK2fa0WVKZS6VFg4uy
         MqjNwwpA1NbfqJFa/0OUfsqboeoXzaCMVszphi2TNwuCsNvu8cvb5btZB9VZDgrw5Ppy
         cpQveGhjZ1lza7ztLfxiGdpQDyYzCR/yHM5WsfXvLukoDclbfoNCfEX2zw7sSB4d0U2w
         LWidTp6A7oV0sPE7ohsBHTLN7j9UK2urgU9Ss8YgFb1MtiMeh5Zt6yqb2VyOA/FfNOCY
         rCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787669994; x=1788274794;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=06QgDRd3KsQRNkIC849obH3kyg/ANunDmHU+Cwu/Xpo=;
        b=rHBJd9v0MGw3aI/0KrOfu5vcB7xhE5+2BPUfthY92eRHCXT9SnETxobw0bIg5W5Lzx
         yR1wg4i+H8Snj/Ww67zHtlRqddv0I/8OxfgcLXsmC4B9iUbxvJZA1W6L2WE9TemSs/5r
         AmNujchR8pahkQ52tK0ydzG1PJmrre1jh5xLNzM2Ci6TrjSE2ZuK1XT+WDmcWmvDZx8A
         S3CNYgsaLo1GBIcAOKic79Sdw645DtNDNY6uP4Ke8Df0ULAW8wqP/RKt7UusG4fGJGIy
         GlG+0uPjtz+Kc90FTLV7EAGjKJP20m3/jRkCYa6U5Ety0z+m5HlR5EcpaN3xMAQotmLQ
         TzNA==
X-Forwarded-Encrypted: i=1; AHgh+RqJ9I8Ic32qHKsjqR62lCgujOizQBBQHvuq9cA9DtTEYQ8XYyM7c1H9nllJSoy9zUIcTVKT+cz/cw==@kvack.org
X-Gm-Message-State: AFuF++kY63o5Mm2LnOfQm4Emf5WZtm16wjkJELiIkvqCLiugf2atsdIF
	J86TcGL1kaRmsANDJFYA/s23MZJr9LYSChrvnh02Hrm0euIsgYayYi2/R67n0gzwe9Q=
X-Gm-Gg: AR+sD13icixpqLxt4EuESjm2I6osyry6vDu559+9RMciwTApcdS3/6DaMZ6xHWv2T00
	+eVWZxnBCxZanChpR/wY096oROxySb1s9iIBWJwFfWP1YL0hhZBcS5L11fb/guG0zwt/WwcoZ26
	vsFuWgFT5++hEkcrTAsej1vnagfNZiA3Yp6gNQyRrOGqZohbhC/hBKAznN1l7tcGZde6qxrIWR/
	GjVXkhURFB8HZBLhkRghsNgcFTCBWpG5cWOczrycCbMyrgv/pCo9UsIY3WgCu13fa3MbvRqMw5z
	deKRGm9lOVm3U5DsZ/lI4zODHFWcj5/Av2ARRBVcMgUy+TVkmhXqkUAvrPdR9fxZ1VltC6mDTiZ
	YA8cbzQarSaaGlzKSb/Rb3U77VMSpNiS/gTyolbasfk9psv+Xe7gR7eafXyYx7FPREEyF+u294l
	7Ox/l6bS+Ow3uymxNNfeqxpfIDLgNSxi4fP9TTeUicFH9eDWIXsMdYYFYs4dwsKs2J6pgi2lE=
X-Received: by 2002:a17:907:b048:20b0:c20:1c9c:b36f with SMTP id a640c23a62f3a-c246a4b154amr2894042866b.8.1787669994328;
        Tue, 25 Aug 2026 07:59:54 -0700 (PDT)
Received: from localhost (109-81-80-32.rct.o2.cz. [109.81.80.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606a905sm2134790566b.13.2026.08.25.07.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 07:59:53 -0700 (PDT)
Date: Tue, 25 Aug 2026 16:59:52 +0200
From: Michal Hocko <mhocko@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao2t6HP-Zt5KDg30@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E45DC8000A
X-Stat-Signature: xjfxnji3ckjoidd148pykx4y7n9mqqn4
X-Rspam-User: 
X-HE-Tag: 1787669995-964602
X-HE-Meta: U2FsdGVkX192myc9HlhOuQhL6mWu/GBPnc6SXlJITxNwmneCMyZpYysqeHmbPVGcjaUz6pemEkEWTYs84/ixspMc4Xx+prycI0uG07pRswXRxieN8NnNsQDpwo5N5F0ag0yRhCqSjud9tpOs75psPfUy3kJKuG0N8kgKjO+CFMlqulYk/6lo1tB6JHuaVdN1BFOysgsoBz9a8RRrUmEGFTsudEYccybZQYzF/4tqZGTTFdovUGAwmrOSU+yDL5nuCS8pxDv8Mx1H8iMo0p0GP4uqV4XNLFx7vxssk0Q6gXbi8ppAqU4Kekv6+cQZQt4nVgWnOWSwh9a+70VE2x7ZPlDK75Jc1rLZAb0w2f1sDT3yUdty58MrJhaRowsnRunvVWyPM6FMgUH/KPIEhg1pA1015MylY1ncrAC3sN12kIFWj/1Q+IQdPRHITnTpwzxBfHV6HAL12mUfgtOBs34D6sZrIjgJcHlEXCxPHrax1vxf8fDXt1x/ekeMnTfk326nZCbX/O/QmfdDcXOVtus0Kt/fRA5/hiLJG1Z/7njf8ru3koKcD6czYc9bPnR7n4HaQjVu4RLIiGdVpBQXlr/kUwOXOBvchS9ybDhLn+QATdqw0m1i9rbPWHT1TIPRexx27FWlSbdokAB/vOCymcSx21AN9fnAPAoyOJzYIL5cIrfQHNpS+x0KbtR4IDQXK7w311bOoLxyurj1VHf1yJ+cE5MSJwwOqHfcxL0T+Lrs+Z+lTWz26NiNKgrGcrzSi2d76IxNTzyCQtQPUEQeJMcWtuhLLFB6yPyW3DRUrF2Iv/gnUxMlhJENtLIBI5OMRjrPs57QzCWyrHLeajBwdpDnAOgMtHMW83iycvhbzEL8MC9DC5wNjurM4yi//n2+0CpEVbKPAZ+gfWnXwEY/qfGgQxTkxIYt2UDJlBWCPavj9skumA4Dz2BcSd0n8abyaW3Qjck1WMWgPkwKoOfB5CZ
 a14YAs5F
 E6ClZ6y7JdEp4gJ5HNnF1JtfsTDdDQzjwJcT/8ljbPdNHfFqywhN05tjoh/JIA+/wy4A/lD1BFHaLHzvLQd2hVC3qclS8bAY9RSEtjDFXLcImqZRQ5NEuAsqmj6nod9v8AaaropEDBQjMpPN6zLtR2pMCZQqw8M99XMZSgCT2m+4qwf6xoBR0N5oOgZ7ioKPMsp/2qnuDc7nNr2ylIDeHXqq9JUeWOxdPO8sHT50jSaYg25TwZRND8ahrMNF0IM/6jmOGL48qgunPK48zK6nO++cCO4lryo8aRuy3Lrjrnbs78IPUUtrOA+048SjUslNlQxvmTSOEoVNZK08dav/yq2yV/V2TRGSaNi5mF2edfihwkG5cgnUbllb8lI485d7Kv5ZJULQGHUpsrMxoMza+9NRP+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 25-08-26 10:47:53, Eric Chanudet wrote:
> On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> > On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > > CMA allocations are currently unaccounted for by cgroup memory
> > > controllers. As system resources, they should fall under memcg, but CMA
> > > areas partition the available space for different purposes and memcg
> > > doesn't have a good representation for that.
> > 
> > Which CMA usecases are covered by this work? It would be also great to
> > spend more time describing usecases.
> 
> We would like to offer some usage guaranties to userspace processes
> ending up doing allocations in CMA.
> 
> For example, a shared CMA area is described in device-tree for an ARM64
> platforms. Userspace components could then, for example, allocate from
> it through the dmabuf heap, or a device or framework-specific ioctl for
> that matter, to use the buffer with sensors. The dtb may have other CMA
> areas described additionally that may or may not be used by that
> component. In this context, we would like the ability to limit one of
> the userspace component to over-allocate and choke the other(s).

How exactly is this supposed to work? How is the CMA access controled
and opted in for accounting. What happens when memcg limits are hit. And
many more details, please.

> memcg
> looked like a good fit to achieve this, albeit handling the areas, so a
> cgroup has a quota in a given CMA resource.

Please expand more on why do you think this fits into the memcg model.
AFAIU we are talking about a unreclaimable memory and reservations of
CMA areas.

> This trails from an earlier post where we tried doing this using
> dmem[1], but I was unable to reconcile the requirement for memcg
> accounting[2] since from dmem I didn't have memory objects to charge nor
> the guaranty there was one. Given CMA is always system memory, it looked
> like a better fit to try something without dmem.
> 
> Best,
> 
> [1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/
> [2] https://lore.kernel.org/all/ahB7pCu_G4vuswc0@linux.dev/
> 
> > -- 
> > Michal Hocko
> > SUSE Labs
> > 
> 
> -- 
> Eric Chanudet

-- 
Michal Hocko
SUSE Labs

