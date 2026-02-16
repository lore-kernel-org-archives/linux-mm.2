Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C02E81A52
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 17:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261056B0089; Mon, 16 Feb 2026 12:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7BD6B008A; Mon, 16 Feb 2026 12:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107C76B008C; Mon, 16 Feb 2026 12:10:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F27DB6B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:10:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBD9FC42FB
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:10:35 +0000 (UTC)
X-FDA: 84450958830.27.E2EB79D
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id BE5178000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:10:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Dlxamcj+;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771261833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ts+ToIC24od9T8pLPmtCu2HwoJ3ic92IWD8nk/aCwSQ=;
	b=UtqIXS4aObTt3O8V1MW8M4wXLtV0uft5G7+bpslF/oBMCcdcnoKVqpsd0uRmucPop0edCw
	cVB24GkyVqAuOGxUmlPFJoYkQ9gkBhUPAgyjP5iA2Z3tjlKuIcerY/S/BUA4Qqgmq/yYhr
	n1TbO1k9koeaT0ZjzZTZV2HptNdkQmg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Dlxamcj+;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771261833; a=rsa-sha256;
	cv=none;
	b=XcBvrZYOAdqe8Mv9pCH/O6P06OqpGHsEYJLaMXnw011X45ad5k6ZsxSvvhGf9cUdkP8Y6v
	TX5PmC0lUIvxRLI67Nj8OlRo0rko/fXSUg/nFbAwrrthr3yyezPUveRx+IxQ9lZYEid+yX
	35Z/JyyjEcw2dXAruTio1U1HacZb7bw=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-436356740e6so4057063f8f.2
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771261832; x=1771866632; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ts+ToIC24od9T8pLPmtCu2HwoJ3ic92IWD8nk/aCwSQ=;
        b=Dlxamcj+pPJ8sSy0x4kN8QCdHY5oa/N7O+g2sVtoKj2o3+KgOaVCzJJf4rU/NDh0KH
         yBNm3F0prS41Rrtbd9b2Ce6DNmhCPjZSHMd+OTDYR6ku/3VA03FW2x4dvYwJSw7xXrjT
         +YRyXZfpggENQGdhiRP5jCEkINXTJqTc1ris859yBgW03K8htLtsilzlfkIP5UKxHJ1u
         jD/qWNPKmEGr5KrE9sArYj4ka8X/n4VhaHqt0RUTk8e/UfRquk7zpZCNkKtmYEPvyoqK
         SGOXrsysdkwtuHROLivYYhCJxXYdF64iFO8GpAhRHBFlbZ4d/hn79w2QETrx7ln26cdg
         guAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771261832; x=1771866632;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ts+ToIC24od9T8pLPmtCu2HwoJ3ic92IWD8nk/aCwSQ=;
        b=P2A/CzIhXbAbeLYrij5G0aUxC11IpQ7D7fwrArZZkC+1J349SYeEKv+Mp08yvVYJzW
         I47bqkUuzkMTBMP4g9U9Xe/9rcev9QypfWoF2UM1HGpGueXWcIqLYiqefne/OEX2JxMQ
         sprOhLhftGMloXhipSmFFVUTkHWklvJR1q7VVzjwyE6zIjUnKNIb7GImtKv/9HdbDkf2
         kUU2SjysIzrMj8pC7bZk67M8nRUwwM98D505AMlzK32qVdkEAY8IA70JgaFHg9s/hSBH
         nse1ysQwAsw0EKnMGwshz2UCFS5ZaLCK9g7Lx3u5BlzEAKxc+7Tw0gAQa1KUP6XUlAgJ
         nnCA==
X-Forwarded-Encrypted: i=1; AJvYcCWbCM4ysGlE0JA1uYymBSdrA1H8A5jZkleYTMr4OqK+UiAZiuYPjBkZ9nhUMfbYaEJjuY7woi2pAA==@kvack.org
X-Gm-Message-State: AOJu0Yx/ouYs8yqQzoAAWqtnlP1F24mhBtFmfJXwfRt2YIWcU+Ig8xy6
	gWSmBQ635ucMGkxDqTRy0O9bCuqnNwr4itQ57qW/bRaJLDvoUuVw2Mr5DcFjnq8brDo=
X-Gm-Gg: AZuq6aJyRuoeM8sDZa8MN8dwSqpo0jZif178JX5qlQskpq0qeYmwogso1w/IOGckdPQ
	IdWFrUWXKTBh4MAuxzzMujpoGsEiPg+6IzBZbuQXfMmuBAvk+U5HklYEdBDO4/uxaAMQGqIiPA9
	1nsoEZaqr1jBFCMR2qozw9hmaveMOk6+stYR7txbmmgjSsvheY9gvhXjifdyJgvxqwEx4vKH37I
	d6WfxLrWXANV0k4PqCoqeQFg0l3n9EXBy21hIUsMrgUtIpUh2uhz+oFbDSerSZMM35MYiIDlBkt
	qJVSvFSU5S9UaB9iqdstOvIMI5VzKkVJQqS9DoBGuCiTHZW20yVnZOQFIyDFEzQtI7kDeK7rJiD
	IgVJ61vfjW52XOje8/DVCn7SwdpI6u56fCwPr+90RFJ/OatIRt9ZBkXz0fYOVPeUf4Zfcvwbgds
	/onRwe2BWRszDt48U+xknicXl+IpMy6f4WiDIQCiIXvFuq8fM=
X-Received: by 2002:a05:6000:288e:b0:435:ab34:93bb with SMTP id ffacd0b85a97d-4379db31b8emr15860523f8f.12.1771261832037;
        Mon, 16 Feb 2026 09:10:32 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796abc21dsm29818963f8f.20.2026.02.16.09.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 09:10:31 -0800 (PST)
Date: Mon, 16 Feb 2026 18:10:30 +0100
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZNPhm954AqQQ3Q3@tiehlicka>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation>
 <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
 <aZMEvl7WUKyxmgIh@thinkstation>
 <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
 <aZNI9mo34vs27DXz@tiehlicka>
 <b20695bb-227a-4e00-a36d-9fc389aa1ab6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b20695bb-227a-4e00-a36d-9fc389aa1ab6@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE5178000D
X-Stat-Signature: mig7869qasrci7mtwrqdzn44j4purf7a
X-Rspam-User: 
X-HE-Tag: 1771261833-427345
X-HE-Meta: U2FsdGVkX1/WrAQl0xF4ITBbATAKFB219JL2WFXrIRfiRnhmR3ek78kH/O1bgTCsO/v3fv2i69TxwWVmLGXoXY+gJHHfFZRh7BOpFrWx3Ld4PFJp+nQI3+C3o4saveWRAyzlVQFVoGogzZSKegV2e8wclobTZWpZwc8yoIKlgB/wtE2TBIMPQ71zQ5YGSwGCMpXgMtNYweTsB+hAuQ5SfHbcYTJgymP9Fw2m8uyxZdpMv2c+X1842jg1L/57tOelUV55KDn6jFZ3ukDa4cqh6BnN15lKTpxFR7M/pNGi0MNEfxCJ4eghjOwfM6FehN7bWzJLCDtom2VMFCNYaaUTKBe26InzsO35MqzplxWQr+a+1AWbIM+LjrKrb+Bs23aoeoLmKQMMCVjvmrDodP+wQoxNpxUnfM8ZwYYyHTwycdEp9gLwlEtu4keQUUn9UMe/X9FVyaSEDoaJUh5dh5gyqB6d/zuLoxKysWkZl/JDyQPRzqKuASaJSIusQUixwVV7IjADGQ+A2vZ+0muPohs9w61UncCnj2beE3abxA2Ac4KEuqpgN3w9+LEjnp+llHIala2phrzFHOL6TVWMNa8FR8Z4hzHkLCaznZYSh3oHfVJWNtwP/lV0r1KU6SZkNrqEhBil/FY5WyazfSYxJMPQJfrSg0aiuU33GAjqop3vwE6xX6FSSV4+SYXpgnTUHqSiRGu3Ng6yNyTCRylpeG7IsIyzkY6bKOhhicWbX8+fESaCSFG05vdtsVmnJuB3NoGdA7vEFhbRqm3GV4CD5YbAwHVcLuqFygdGdoJ/6bMh0hsq+jRrj5dildENH2sIrIBgslDCR/a32QIES1qYWyEjEP4FQhYnqXpwJChWm6aOB/ug/G0bTimZnxqdgXN//u8s2qYUy4KWbecTE7xrF80abV5IMU7ws+HyKpTlmwFSFdndEqcIUNIpTyZ43k5AMckG9p7LQlLfm6SajSDiBMC
 rPC+8rIK
 oaBCMkDv9HrcWx2OUQHL6N85HB+naOEEhFW0LkYLt3D1tAQIraRpIkkoJVhJTTNVscuZnaWoHSsNCMRnMnvvd8iZsSyY6+FCnoQ87ptF4/homTMKBbdam56ZxkswPTOe6wKPTBE9AM1vG7pAtFIaZmzxn+I9CJB8kYRmZN3wa0NV7WGQBFTpVEmMdsi4+ZYS0W6+tgeeJu8f8hJ3PSHXd6o+4cplpGq5hOFWPL9uHVOYtn+cJa+Sz8O2e9+aoNVtt91FKA9f5GRRr5pwxe+SwJOG6NYwcwYGxNjJC+E+WXFpztLghuRq1B7UNKpA+Bpezpo8P4e0Kn7kR6FK9nC1HinY7PiSpbBZUDLTLQZWqgGI6uulMKJT+1ZttQrc/xpRv7t8K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 17:56:12, David Hildenbrand wrote:
> On 2/16/26 17:42, Michal Hocko wrote:
> > On Mon 16-02-26 23:59:50, Wenchao Hao wrote:
> > > On Mon, Feb 16, 2026 at 7:58 PM Kiryl Shutsemau <kirill@shutemov.name> wrote:
> > > > 
> > > > 
> > > > One users want the stat and all users on the machine pay the price?
> > > > That's a poor trade off.
> > > > 
> > > > In general, smaps scales poorly. It collects a lot of stats and most of
> > > > them are ignored by user. We need something like statx(2) where user can
> > > > declare what he is interested in, so kernel won't waste cycles.
> > > > 
> > > 
> > > I initially considered two approaches:
> > > 
> > > First, exposing the needed information via smaps. This does incur some
> > > performance cost but is the simplest to implement. The new feature can be
> > > dynamically toggled via a command-line parameter. When disabled, the
> > > overhead is negligible—only a minor if check, which is insignificant compared
> > > to the full smaps cost.
> > 
> > You are comparing content of all anon pages, aren't you? Depending on
> > the content this can add a lot of overhead.
> > 
> > > Second, adding a new system call or extending madvise with a new command
> > > like MADV_GET_ZEROANON. Userspace tools can then use it to measure
> > > memory waste from zero-filled anonymous huge pages.
> > 
> > MADV_GET_ZEROPAGE would make more sense to me. But a more fundamental
> > question is whether this metric is really what you want long term.
> > Kernel can do all sorts of optimizations behind userspace back - e.g.
> > map shared zero page - so just learning that a process has a lot of
> > pages filled up with zeroes doesn't tell you all that much. Or does it?
> 
> If a sysadmin wants to see where THP hurt (zero-filled pages), surely
> MADV_GET_ZEROPAGE is the wrong (ugly) interface.

The question is whether sysadmin should really ask questions like that.
Without a deeper understanding of the workload the answer could be
misleading at best, no matter what interface is available.

If you know and understand the workload you already know that THP is not
a good fit and you do not need to ask about that. If you want to
understand whether your particular workload has a big internal
fragmentation due to THPs then MADV_GET_ZEROPAGE sounds like a
reasonable fit to me.

From a sysadmin POV you care about the overall memory consuption, right?
And for that I believe you need some sort of high level compression or
similar interface.

-- 
Michal Hocko
SUSE Labs

