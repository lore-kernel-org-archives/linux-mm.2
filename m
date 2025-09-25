Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85EACAC5BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1B58E000F; Thu, 25 Sep 2025 14:26:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA098E0001; Thu, 25 Sep 2025 14:26:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F220F8E000F; Thu, 25 Sep 2025 14:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE1718E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:26:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D6CBB99F5
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:26:16 +0000 (UTC)
X-FDA: 83928602352.19.6A299BC
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id B1F35140012
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:26:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EJg4Lege;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758824774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yh9nK5ND045N+FL5Ib8gPJReb2Q9R1K2+zjNC4yoXCc=;
	b=pl3jJrk72bIsZAliQDs++ecntvOglr4Yuogj1R769oU2FOQDIP+RMc9MjOMDnaB6WK7Mak
	Xpuqj/0NR2n7ZBPEP0IWVAeZ7liiazEHirnr6pkydP1z52+FrUK+hbOeinayKpMu6oSnYi
	D0uu09+cwf0Ev19oHhlORd1AkX8kqH4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EJg4Lege;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758824774; a=rsa-sha256;
	cv=none;
	b=wj6jQxpfoT/3FPTvtMHQdFwUU+4eJE+59MaF9Z9fOf/shJTCZwy/Vnftn73qJ6A+X6P/y6
	8sHxaX6JTGrFkKfWu4gK65Sbypuyuu7pyZ4S2ExkggJ0gyLWYOqWaGmrLUALYX1v2ZPPv4
	QKOkhjivMRBhwG73+VgDCWEZWLilWaI=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d5fb5e34cso16648807b3.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758824774; x=1759429574; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yh9nK5ND045N+FL5Ib8gPJReb2Q9R1K2+zjNC4yoXCc=;
        b=EJg4LegeWOUJeQyPllpTFq6/ASVtsXBUti1S+J2Zt+mF8aft7bvHNop2Tx7xoFzxcS
         8Uc/H7egPnMYApOvi6CFHrYHHQmtzHrxAd+yxNKLM1YUZRRz3nSXHu5p44p9jNiobWze
         O+bgeUo2VkdNRrSUuPLW4NdxIrJEGXj1WqHzxnq7Iq8D/nuzNYmz1m6L4Lvvg2LOMsnr
         E6vCvgqGapK8Hz7GwDY6x33ry3jAogqYZ0/RIh5GenOmqhLYdeKZD6f702A32Es7vaEf
         4+qzxDOdMYu+kryF3+8R4CLuMnmOGWP4B1OtcMTPKseelYpQm/erA0TEwT3EAPQYOb9k
         QMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758824774; x=1759429574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yh9nK5ND045N+FL5Ib8gPJReb2Q9R1K2+zjNC4yoXCc=;
        b=ARvJ9LYYVoiyIQ3g5Ses88NNvxlKkbx3Bh9AWq+ANd0oNrqneI/MtLoZ7BbQTVUryp
         ElWYMwqLieypp0k7Yo8ToiO33z03U4fIT6x4yPv2M3ktBv3rIirqBm+JmstjO1Nq9qpl
         iPD/po+hdEYiXrDhYoOBgIJwoFmTFZuG13I1VL05Kl4pvvZ/5Td4pfO3WjZzRp3WMlep
         XADaQiPbo6oty5rKUmP1z4W1ydxWGNvIUHEsXIutlz05VaJ7ucatqhCPszO+0h+CTsHN
         5mO+6/rwR5lRWMW4KurIBs00z/fgUYcZNnDYan0jOaMlg23xPzfS/Lt7+kADd+wEZWXv
         OgLA==
X-Forwarded-Encrypted: i=1; AJvYcCWJgpqfvTP08kDJLtiTiTrrG0Rpvqp5FuyhS5yDnAc7yXAV90VEWJAjup0mWWRt/XGmEs9YQBXYmQ==@kvack.org
X-Gm-Message-State: AOJu0YyXBb4v+kdLum/R0rJN1yS1On89bf/OjuXAUnS9tQEB8juSju/z
	0S5NO9Y4sNtiwjY9Cj0FsOsJ13jqScRl52zkdz3QkEuLg9j3uxl/FVNV
X-Gm-Gg: ASbGncsTL5LiHZAkEkc2PEsibaFzh9Rx0LeVIlbvnhh2a5530EbJefucO3V0EJk7PHx
	NkewV2YmRc2hkRScj0AbxwE2OnnVXUAop5gEpuH+dtNG/BKPZQXbiauErbwfeWnggUmuKtLwymX
	o1sruMEi3lD4IGAGfER5YPtN4fC9W34CFiYeTUZuqtIUQuTHHIow8f+ibWpPjXyiTI7DFHxuB3/
	Dcz4ru5D7wKbhB9OCibPYi/2WIE3ddxRrE5cHlkOHIvUQawn8qcJXVb1fzdnYmPKm8dD69SzrqT
	NcpIrcP6466kO+6zd7yYr/zNq2abiwEORHU6yWOrOlI1BJOSZmmvcPHIYB4cOylYJMGI4i6v37F
	UcMKS05fKDs0Ll4WTMp+fQgwUqWPLq24x3dUp1aDcddpejJxDLuIT9ZaVrYLyCZa4
X-Google-Smtp-Source: AGHT+IF0DpIz7DGH5ZqEIt1BcjbnMswoUnU7/ApjqSwRCj4bn3gIocs3R28KhC8dB6+XVJWY1ddxHA==
X-Received: by 2002:a05:690c:3702:b0:73c:7776:ce29 with SMTP id 00721157ae682-76553dd4e1amr32394917b3.10.1758824773525;
        Thu, 25 Sep 2025 11:26:13 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-765bb916b96sm6608427b3.5.2025.09.25.11.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 11:26:13 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/4] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
Date: Thu, 25 Sep 2025 11:26:06 -0700
Message-ID: <20250925182606.114616-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <fdb56260-8235-eb20-05cd-491fd512cec0@gentwo.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1F35140012
X-Stat-Signature: 9chrpn5f8i6g167nzsoufcnau1tcfo7q
X-HE-Tag: 1758824774-738856
X-HE-Meta: U2FsdGVkX186goyRiqJvioob+/n2+I2v6SXBvZfaoJpUoiOXhwLsjQXXLwf+iNfx4iXBvfB9LtMyONsR34p+wXRqYBRzM9u83dmdgdJ4Q7i0Npb9+ywDn0G11/EdvlY5Mk8jK0j7lDJDhWzFUayqqz6HTy7JEx6jVW3hhso3NzZYBCXZd2jMqnsYvpCNHLc+IyFiPrvUNKecWNY7PEmL/4QO2Ga4pHr0Kqcqsk5/2R9wfpP8rIlXq8JKwW1gMU/lcUadwtVwyhszSKtcVPx9hjIN+q8dc2GJfd3fnGOTXnmMWm0vEYyZxv0ElN+FmEXfOljymx9JiY2Et2c2V+XfxdiluoXCgk60DLW5Wfj6XM3bU0PtYRwjdSwcczNGmQjIx2tJRnhfeA37VgmvUFR9phcuyaZMZAdDfe5aFlHwQ0rs8w2SbIkMrETbEINHtkpSjnaoTLDwOMhoVKC7wUXtXbW7Ul9A/T10QvD70MkMDTI4k1ifzidrL9TnWpERaov+cYF24QXdY1OTmznGZK54LD+6m5mhketRFDfM7NW/4phe216yHwn3hQzzt5UpUKvZ8xxo1PyCl/XH2dpvI8ZzYJdutMG5WDYW3tGksCGTYdE+FbnhCprBYnMTP5Six00uQpaM7Lbc8abHt5ux1TCDS9z0paehhBK459VzWTo2WwDNxaJDratBbP03h/8HSGts9g8J+OKSS6INidMlvwDJE16Qzz8WS6MtiCcrqNZ5MwfJaA10mlPlSto2S7YLUQo1nwbjCRAZaGDR7fPgYTVrB2CZ9N68zy47bOdup0cecfsQurLkF1+KGaFDSgCsX1KKldHehLtktrVQ6S0EtF3AqgwcSq4Bt3jJwYSVQXe9WME+stqpXhRM+eXh6iluw+8dqhcq/jGgPtgP6Rni13Bh35GDL9X3ejXRuL59Q0bR7lQ7tQ3waPfZYmL+qFMnAAysyw710gWrvoSQ5jPcxhX
 FizrojDK
 LtF+S/7CwbhhSkLLUZAeXgpt5A+KlkUWNNRMpt8jBixISDW8n5x/Ut3LPxhVlGmV3u/jUL/pfOuRX7sK8qvGfURgopLBGrsCNoFNjjnap0mjmIfrfb4JoZwSAHUFXjGmw1RIK4UjIgPKSeMU3Vts75cc1/aS95djzR0iV+9k9jMpfnrFSarIRgdoCG0mQFF5taNhn0fAzCzClr7utiV1KuCFI0qo4TgormDnRwX9dWJrYnIbxJhI8h9IweJPhlBh4/KD79rqaNvEsy+T/XJ/s9Uegbi4+48tWh2CABi8BLobrw+j94/vskY8gRM835eGVXqGYQv1euP+wArkWBwnrOwp9bvKnWpWX4trqeLMO2KhBAfzpRQxU/aEJTbC5FYoDpj4ckIIY8KOAYVb/CU2QVYnPcIO6MeQWoth/JQAvoomoifx+9LL0Cmqr3i3Gmah23j6kSW2vt1AXi959szGXJFI4zNzdw7ALNJgbfljEdYjdlYt8OX335Kmal4nyESVduJzvUcltD6VWQUDBG5dXWdYbNzrw01z1d5XE82ZBGpWz8z6PohGtbpOF53ywsZOfaGtWqMW5NMVebHBJuIszXokG2nfva0guEmlxbRhsCvI8wwZVTK2X3PC+CVmhzqjAd0R1Qnornw7+4FI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sep 2025 15:51:58 -0700 (PDT) "Christoph Lameter (Ampere)" <cl@gentwo.org> wrote:

> On Wed, 24 Sep 2025, Joshua Hahn wrote:
> 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index d1d037f97c5f..77e7d9a5f149 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2561,10 +2561,10 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
> >   * Called from the vmstat counter updater to decay the PCP high.
> >   * Return whether there are addition works to do.
> >   */
> > -int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
> > +bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
> >  {
> >  	int high_min, to_drain, batch;
> > -	int todo = 0;
> > +	bool todo;
> 
> 	todo = false
> 
> is needed here.

Hello Christoph,

You're absolutely right, thank you for the catch! I'll fix this and send it
out in v3. Have a great day!
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)

