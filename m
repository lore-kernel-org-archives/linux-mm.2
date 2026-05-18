Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2F27CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DFEC6B008C; Mon, 18 May 2026 05:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7E56B0092; Mon, 18 May 2026 05:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF0E6B0093; Mon, 18 May 2026 05:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE3736B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:09:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81695C2B39
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:09:41 +0000 (UTC)
X-FDA: 84779967762.05.0BD4B6E
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9309E1C000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:09:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fhC0Bct5;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779095379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSkb2dZhXWUDFcAf8XBLBz88v/zr+2Lt6xaVCyn8T4s=;
	b=EvgPix94PRhVc6PeVFYGqMqYEJLkST0p1/AcrkwUhK4zA2cClhimmX/gab/CS/HB+WM8SK
	5zpTU200jRjnGoabOQg41AOzZLd4OGgNYPt7lpc2xVcXTvobCi8j1F5FLBZsnD2D7hWk7c
	G6DSWsZV3o1XBcdGrW8DjwS6cvefFjw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779095379; a=rsa-sha256;
	cv=none;
	b=YQZ/+L9u8KuvMiOjuJWtZ9EkR8b3WjVzouY+kXStnwStTyS92lKj+yFIK/zVvgbzSM0YAQ
	yfh2aRgdMtLShWygv8t0K5DmyUYCAxUxHvrEHekH0d/JuCarUi7/B1I8o+9Ye4p2vtx9Pu
	QEOqeO9z6YhEDWy3rUGPigJHV6PD+0g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fhC0Bct5;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48d102471a4so15840925e9.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 02:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779095378; x=1779700178; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PSkb2dZhXWUDFcAf8XBLBz88v/zr+2Lt6xaVCyn8T4s=;
        b=fhC0Bct5miGTg05kqGAtafeU6dmk0osKJMLzzGbmIGbsOn9jnUxjfYdB3oV4TDKBrn
         HkmlZtdT3fBivzxcuSyx4UEydJEQGgXJquhlZw0cptAuSpruR87w5kSZPH8DjoH3vxEH
         1NnzhQqfUg8PYRvSIhhp78wfDuoCPUf0IRlRyRpNN7AvaVoXsrq0qrzCnL03TEJ6W6kD
         xprhRsI2bc0jDmtZL+R7SiIRt6EGsQCQ6AHJT1ohiBZ0cvkxrBvoBJcK9g8Gq0iMEa9N
         jZC20tynEf0pjCii+moD6mw99CJRtguvGnp0uZanS7OEjzQw/jcO8mN1yITT111EXmme
         B8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779095378; x=1779700178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PSkb2dZhXWUDFcAf8XBLBz88v/zr+2Lt6xaVCyn8T4s=;
        b=LAmVIFCK4FAzewdMNu7l+5MNv52qowcWAuekQhgN+dhz+L2vZM9d3OOYSmOFpsZ6EX
         ddz0kkW7NxBX+Sut8K+xHz79D4fhGN1a4xWbIuf2+hqzt96fkE1lwzTUKwPdctIy/w/K
         i8+xumcJ8ukiX/kdxO6qaNw9PuJXgU7mjn5L8iogi/De+jK9cIUqZEVTz2AZN1OMjp+j
         /WPTV23VBZsIjofM4pd+aE3sc5gC5lPT4XU/v5oCqdHXEDJ6/DjgvJZoS0ui5RekU7tT
         lhVUYca23rI+7xEV/sKhw/ksLPCy953kzX623seltuxg/Lb4+R8jritjq0Unfr9YH1HF
         GrJQ==
X-Forwarded-Encrypted: i=1; AFNElJ8A24NTgI2CUvG71M3/17GM3nzYx8/+XJwEhaDNDr4B9OB/p/rQPyfJItxrcowK3niPD/j6n81X5g==@kvack.org
X-Gm-Message-State: AOJu0YyD5y9ErTle+SwsvsB9hXYPMGKiZpE5VEEIs+y3hb2Ri8MkMBRA
	fC+xjlQkF2JXIXo6eJC0SDH8ol7BVFvNo/4ozQI51KR6y9VfIIROoXm9
X-Gm-Gg: Acq92OEZX9vDPcSMMrf8rTv+ENvKGro9TWY3PpJTPB/r3g/VmpRtApGk96trCmFtYs5
	I3VVTlL39mqpr4ZcqFhNCkhEGqe/uN61CXPQdoYs3QJyd36rC2UZLWLZOzKpZFMIh2+B2xgKG2a
	Hpy13HZId02u9mie3Xm1D0qr49gsi5w9Sconcf2nlHUnmL3Kyx+VJAkQmbXWIgZSDgCCBbG/2Au
	Em+bg1b8a1FnGeOZv5veiI6ZBvbQJsZgBDgjIRvO7Y5vSQHbXIghXvb2viy01WPpmgar193+sr+
	FdPaVFSETb5Wy30jVAK6aQfvQXRx8TQTf5E3ovCpLc7mDNuUL/bCfQcHfv+WHctbSONl0Prd3eO
	7IJI4kMxS752lWj4JMRwCUlsEC95hXo+11oswevcu1DKZriMDjMZ3C9CCk6DLQOe5FoQUqZdXCt
	zA21ZVyqVJghASy3sZMz0UkE/LJrMQ3AJE+1uqrJFzEsClv6v0qO35B2idgWSqRat5
X-Received: by 2002:a05:600c:34ce:b0:48a:592c:e63d with SMTP id 5b1f17b1804b1-48fe60d7832mr233907695e9.14.1779095377620;
        Mon, 18 May 2026 02:09:37 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48feb00bbe4sm78272355e9.12.2026.05.18.02.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 02:09:37 -0700 (PDT)
Date: Mon, 18 May 2026 10:09:33 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Yury Norov <ynorov@nvidia.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yury
 Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Andy Shevchenko <andriy.shevchenko@intel.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: add bytes_to_page_end() helper
Message-ID: <20260518100933.6bfe5b8f@pumpkin>
In-Reply-To: <agnehRPd6SeoO9ie@yury>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
	<20260517123428.1181981-5-thorsten.blum@linux.dev>
	<agnehRPd6SeoO9ie@yury>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9309E1C000A
X-Rspam-User: 
X-Stat-Signature: yqdpy4bjd8nxbk34pp15y84mwp3wirmm
X-HE-Tag: 1779095379-531587
X-HE-Meta: U2FsdGVkX193DJGJSgTpYCjviUo8IswZL4GbENeZfVux9wbZnkqY7rxUDO+wl+BjtO3Fg7LGFsxsHYJPn97UTItI8lauXYTHdkeiHtgzI+D37kWcNjm2x0BPWpu2AS74v6fC41TrudSLWMKp61hZZA/hdsq4AL2NtuiQw55e/il85g/3Mdv2p4zzfeLzSeOF91uKzYLszgh1iUgphZJ5gw5anAVKWbD4ZuMGJG7i48W/ruOHCPvmdU6sKOdn6uhP+MjolGY5lXI9YclVXXoyC2QWxSDlT1bxOyxaH+Q5XEjaVweTLZJ2traWLJGqNvgWyP+DCRciVUP88+KuJwx2bQsQvS6DQ6AcBjT6odoWdNzw7PyBXcXBWmDi4qgpAHpYx9qI4AHRhMeHRSuV5d3idnHAm4mELMxOu7Tag6W6ZJld60Hls+ycMInxrbiYMmaoJCdMqULF2OauZp5+WFxy8rEeBdhVmDXAAoFtEpYpon63ft/ySbvHWcqUBUsWtY/mHB2fo13IYWmmtRBHRwGO3wZUlS6apQvXa4OBfM01u8T0QlLNfwIAx446ut3vwXaIs80AZpMdEjYGqJU6KaHh7CyslspO1/aHeTFALI6yM6GcMS3AcOxcR1N/NpNXiYELHG60mCqSqLosZYCzcIpb9JiZAwjfQhyxLPokrAwBEKdNdJyzK9SetSG9J5D5yMjIzf06UneMRGxrkWVVkgCARKttdiMWz3ypIglP5hzjy1KRHPZoQBkwlO4CtcHIOeZl4AgOZF5VWNlFe8gjuS8RuQX6DPc999nnpIe8WkSFaCpV4cofdf9K3WaHGQgpCoi6/vQZx+ZtpaWfJ0TOgIkebJYaBDUq0atVWUYIqVMb2+9lI9lSk3KIQw56fR9zkeVTIO4yZFBoOO7XyrM3fXSG2O1hGWmin4pAT4IaVDi1W3bjhWTtDqk6fRoJhvBBE+AUGexBEeLoe20b7pyeRgr
 jb898MsR
 YunZE7Xb8WvAYkN80gQm87gEC0exW+ql/eXNvdCDLeMPGHxHkYp21w18fXkErj8SLLKKKgyulPPHCdwXodIL6qH7Fc6b+55VHfb371/o518PwplzYFUUezsckGhpdkft+2R15WpVxM6l7Szy+weDC55hXr4YgGb+rCuj+gVjaZWAnpWhnZQjY7MHDL73k7C/6Sc0cy3ZH48hli0VWM1WUy+uiNM32zCmV9djUU3rBAtTmCdtXz5emWHBpFqTwlsNTQG3UUbKNBTU/IqtLQDiTlHNeCi5EiTxGDq1ZnVqZKz7w/ooNEdWGZgrUvZVTwyhNvz+PHxU69bkfBuQFJ+uzpxgjYs+nZMoJ6R8MFCax1t374KrYMO2KQak4+E4eN9WSQh5NhzNPtgiZpLxBb1N3aIAg1gdnvReg90EDT9+V429babpAoKOXbx/e0WsivkWQ8Hs9cnOOQUxHMwqGtMY+6+/UP6Jar0JKhqNnTzpuQlqUNZKdCoWoQaXDPK9kHZa5Iwc7FWQCfaBLP+xtAGfYFxm4N/KdT7ufBIVscdyxBANEUe50/AnkC6FrEp3NhCJqgeVEDySt4GJNOC7S3Ip/O5tqitV0pqMEul8amW9ivfMW8Gg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 May 2026 11:28:05 -0400
Yury Norov <ynorov@nvidia.com> wrote:

> On Sun, May 17, 2026 at 02:34:30PM +0200, Thorsten Blum wrote:
> > Add bytes_to_page_end() for the common PAGE_SIZE - offset_in_page()
> > calculation.
> > 
> > Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > ---
> >  include/linux/page_helpers.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/linux/page_helpers.h b/include/linux/page_helpers.h
> > index 102a4f3c3868..981731faa1fc 100644
> > --- a/include/linux/page_helpers.h
> > +++ b/include/linux/page_helpers.h
> > @@ -6,5 +6,6 @@
> >  #include <asm/page.h>
> >  
> >  #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
> > +#define bytes_to_page_end(p)	(PAGE_SIZE - offset_in_page(p))
> >  
> >  #endif /* _LINUX_PAGE_HELPERS_H */  
> 
> I've got a series for this
> 
> https://lore.kernel.org/all/20260303182845.250bb2de@kernel.org/
> 
> The feedback is surprisingly negative. Please add people from that
> thread. Maybe you'll be more successful convincing them.

I don't think you need a another new header.
There is already vdso/page.h which is where PAGE_MASK comes from.

-- David

> 
> Thanks,
> Yury
> 


