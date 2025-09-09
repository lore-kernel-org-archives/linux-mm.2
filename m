Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58F7CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 23:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392D38E000F; Tue,  9 Sep 2025 19:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3435C8E0001; Tue,  9 Sep 2025 19:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259B68E000F; Tue,  9 Sep 2025 19:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 104638E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:53:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A659111A5D1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:53:39 +0000 (UTC)
X-FDA: 83871366558.05.24C03B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1764B18000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:53:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MxdR69z8;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757462018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4spRcZl8/bQUSowkXU4Sq8LSJ1RIoSjsj56RsW/LkU0=;
	b=nHejTTMQT+C9sucWMkR/6kFE5USz/7ahi/XYpWyk8hldm70pPQPqSpZLt0Alr5G5neG16O
	6YP/xLh/82z53PPKGSU6E3UsrL4HcBxHpWY2wNMkepvHg/UeqXp45tM5SHh06XcVq/pqWN
	q1G/J6VLHizQd9UPj8QTVq80wGKjSKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757462018; a=rsa-sha256;
	cv=none;
	b=MINXJKy5GZw0TYH31uCNXP+3ve06WeVfHdj4ZprWcSQy9dDKPaVQkQAHQ3sgJb2RwFO8BW
	dFC3gLWgItBrAeTdyNlPQHB3Db9kVu+dg8rw7CNSXQek3Z7tN86mE/uqHPHQAvA6nOUJ+z
	riQJGayBUx6Rw7H6H5UK7BLr6WIfuA8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MxdR69z8;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ABE1601F8;
	Tue,  9 Sep 2025 23:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEADC4CEF4;
	Tue,  9 Sep 2025 23:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757462017;
	bh=TL+mPDulX7ZhVXLQTVuVDyD7XiM47hN+hxaHhpZDWIw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MxdR69z8T2UdS64FQ0ef5nyIc35+yEWFvt6Dloh9Zrs7OjsDpjMx9BA1tex8blA8N
	 9ZO2lBXbfg34iDvDboAwvDDrOYKIvjb5SOWlJAswsYNUUjz30W/Yv24Sc5HNZhKo1E
	 11DCUAvqsSRloZ5VnBDVEinT5bciOOl0jyUfFM58=
Date: Tue, 9 Sep 2025 16:53:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brian Norris <briannorris@chromium.org>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] mm: vm_event_item: Explicit #include for THREAD_SIZE
Message-Id: <20250909165336.c9505e477461fd5e41e6cfe4@linux-foundation.org>
In-Reply-To: <20250909201419.827638-1-briannorris@chromium.org>
References: <20250909201419.827638-1-briannorris@chromium.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zsg347q9yburt1ubj5p1th633bqwty4j
X-Rspam-User: 
X-Rspamd-Queue-Id: 1764B18000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757462017-114382
X-HE-Meta: U2FsdGVkX1+wKgXOriXgSVo8kdjnnK1ZENy/HHd0Pj6iIHDKtbhYfT3t1a7kMHA0E6N7vZCrBpE8CcmCHRNykZCf4mYAZldioWuU67+kA2xtLJiFcEv1nOBkPxMF/OZxr9Eq121aCxnmjz9pbzHpNK2wdJqUQR1iMCh6PpzRgG5CUo+l/Bo597Fr/FMONstjYveSEoj+vSjyT2oq021Zgewc6P+mdicjPRLUyNb70bhm9MMCGT9fjKqcjE1U46NoBxilbNpSAgoDcMKOWSzoxpYcL5PyaJt+mQEqy8pI9dPRfu9UjO3nmBC55Q3l7b8uAcTII+MNvAuU5PrnFRiioFi9uH9ywlGINl56MudsWI68fqRyDpXZDxAt1tm7POBSVgMPJH/L0H0pq5Dj/fjlpC3pfolzezUUTP0hT6ISGYGDsvd/IuZFZLUon+y6SNYElB/pPj498+x65kOSsqaO0THo9adAlR0p1ucxq+wY0Fy6kt7Rde38uqQCp1d69LSe8rtq6A2tArTu0q4ZFE6IJdR2oJR6eBPQb4QNbCv/T5/5k3qhFN+Yy3W8NySFGFRiBI1sxcQnADo2JYqi/I+tH614LiT1Z6dCGReGA8KRZT/wZA4WBgeZouWvVeZLtPQhdtksa5KjUItCuqfoSfLpwVei6tdF/rMXPAG0YBL0phdfjKEVlgOOYKds56D0y1n2rC6a648CYsUUtiCDk5J2+/knOdxKGrTJTdzlP3As3AMegmgp+Kw3HnyYQZ23p5hrcJsUdlT4tv5/d0Fhsdk44SRNwvHU+fNwtSkvjDC2NBkqq2macoxg6T6sukrl5kf6skTk/YAjObLdZYS4Pl1t4kSijBEUISWgDLTmikGM32VEaC1rEkfL8JoMl8rp7hIJic6tCBIlYI+TShiorNFS7e1o7Tccnnm+MmSPpRTQ46jIuvoD2T9tupAPZTK/r9MMqub4t6aa9oJwoPlKUYe
 RcWOSfEI
 c15HmbKv5VE/Euj6Ps5eh8D3oJdp2yPXVIZA+A2/LG3Q3L5GsUZQEwzzkoMxsfBOiIYsmOna5lNS9nhgV0S8EmcA0/TfMPCvrP3pXozZjC/VwFVd60u4kOhTcpJjZ2OM5oOGEgKnS0joJ7QHP3O/W/nTLjlQLf4hlnqMDdz4P/OtMZSEdouobWm2vneL38NuAYnHorFFqCvRo9l57mruGlXU/lr+HPZu1SdkaYcj4gUck53LZRLTVGF+UY3dn7FFb36cnbP/T/cWUpiqxGkjIynIOsysD6faUX6qnRWO7Tozr5KcrJS7ddTW4/Epd5K0wUmmOCuBnaOmAIygIA1hNgTl9SIyib7Hptr20
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  9 Sep 2025 13:13:57 -0700 Brian Norris <briannorris@chromium.org> wrote:

> This header uses THREAD_SIZE, which is provided by the thread_info.h
> header but is not included in this header. Depending on the #include
> ordering in other files, this can produce preprocessor errors.
> 
> ...
>
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -2,6 +2,8 @@
>  #ifndef VM_EVENT_ITEM_H_INCLUDED
>  #define VM_EVENT_ITEM_H_INCLUDED
>  
> +#include <linux/thread_info.h>
> +
>  #ifdef CONFIG_ZONE_DMA
>  #define DMA_ZONE(xx) xx##_DMA,
>  #else

Is there a known configuraion which triggers this, or was this from
inspection?

