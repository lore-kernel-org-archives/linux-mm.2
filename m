Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5941CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 05:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A8B8E0005; Mon,  8 Sep 2025 01:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1718E0001; Mon,  8 Sep 2025 01:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E478E0005; Mon,  8 Sep 2025 01:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A23878E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 01:49:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F5DD1A0977
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:49:01 +0000 (UTC)
X-FDA: 83865004482.17.E2D08B1
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8060C14000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:48:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N8faqxN5;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757310539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RoqFcoq4GIfiHOtzMW/QQ9khjq4YgpmVFRd8SsW0DUQ=;
	b=lMA5bHSGBIkYoO3sO33RS+tYF9pZ9cSJV4XwLMqZER08G+iloxZYSFEUvB6WexVKlZPzq7
	nTO41exiDALXOwzJxEsDN+Atcwjjn+ivWvOcmjBuFn3mIMKQtBJNCSivQx/+oaIYoaWMI1
	e18td0ryiYK3RXCGohhmEQVZyzaIdC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757310539; a=rsa-sha256;
	cv=none;
	b=34i2bN2+oQOpx1dqil4wjnfCCO3ImyvNVgiV33psFOH7MPJ1OI8/Oa+hfP0jQ1w2cVPNsp
	JVTpIwCRig9o5ySYmpKoF3QqiuH/t5mvEJuCUJmP3WWLwcouBWlwEWIRG5MMtjlJO7BNbc
	4BW9QSXHHiQtgd7M7sdi0EMpV8SysYE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N8faqxN5;
	spf=pass (imf26.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-772301f8a4cso5526613b3a.3
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 22:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757310538; x=1757915338; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RoqFcoq4GIfiHOtzMW/QQ9khjq4YgpmVFRd8SsW0DUQ=;
        b=N8faqxN5qg73jMZmTrUqyWA2QtM4vCYXPJkg1PkRNSCDLpJGfPYtIyC0aXKtqjdw0A
         G+bJ+neOJ9gKMgeVu7nv/KXmT3buTtkaI1st8B//a6Pa5iLoq9ktJZ5xu1gtfOWV1G8l
         wvQOJuxvFgm7AS4Eg4OtZpEQvHB6Xzw80BjbKSd0OCjfnFsrXkP5MxjbtJNl7NKWGy2O
         Fq6jkX45SaM3Oh82bZLYhMf9rgW7vmaZ2Sw7gA/qrg0hoy6m7oTBrUkTHybolgD8+QVW
         /b1p5nTFQ52SjIfDe2HD9uwOXjpMtrtRem0QCyBq17M/21lIAXAdoBoZwMSoMY1pvrxP
         c6dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757310538; x=1757915338;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RoqFcoq4GIfiHOtzMW/QQ9khjq4YgpmVFRd8SsW0DUQ=;
        b=qhFQrZz9+g4ia5PyX3+B74yhoWGhYW0dZobF9PIwAeLwmgpnhGBwH6Zfc1uMyLZlkp
         221PYQYtqsB9E+bk7StkffMkJM7BZAqPV8L4Z1vr7w2WL7tBflk28XdQ5coX9cETqScg
         n2eyqPX2L7pCFPjDuX4S+WYbazuIb847sV4oy27uVl/8qypGKqnG4nKlOGUiM1IHid8T
         3s56V5kqUTOluDOxBet73BVTLj5nFSsPXS/cP5YOa5EN4vVUA85Gb78D7gVxTTKi158v
         bOqBsnecxzS6CWcsBX2m192NfSTgl2lDJH3OWslVkrVjSBS1wGCCEviflnm4KtyVYYg+
         tUog==
X-Forwarded-Encrypted: i=1; AJvYcCU2Nz7MkZun9gKdrVZYNoHIp56vpST2CVAhrGaIz0VwZxJr7FGw1wcmudXLKXxKTWy1GbYqdL9liw==@kvack.org
X-Gm-Message-State: AOJu0YyJFI18QkJm1R+knf8tq+2drLn0PWo3kLGgZ+UQU75hbWfUVB1W
	DPjjmaNIDQV6htFknXH4GIkec9R8GV8egkSYBOVvfVG9pLm3WOASqfir
X-Gm-Gg: ASbGncsgaq+OLJ2u0s30trqUMy7nIpj+3p6sujuGXGpdGzYTRknhJ/dc/GeOc4G8Azj
	oxaG8NgeQzQrPTFgzBtUAIxR+NPZ7Hir812LowZyuLINMKzvZVpWoh4/01X5lgY9jA6eJVsxVl3
	E5ubo7LTJBBvcbpiPFcffVHDiXYR3gJy1Nf41vDYSrHE1635L370axJNBjWG/Su1OTWZZNKUKtR
	kgQ0q3g6EZGw2DsnPImYM7wQAvnYFrXa3z4k9ixnED2rfW57hkWmpjk0laE0eFOyZ4mrHymLl1K
	T8ev+bk9P3TcDKZWaK1E2WjXl8PkCwnMdFGFF5++hjzZIMK8iWVi/UhmMAo2lN1ktBRyigDOdem
	VDbVui5bU3aPXP7y/elNYRv2CtVMMEILsNbV51w==
X-Google-Smtp-Source: AGHT+IG1bacu1jG5J6SpRnQGjBP/OMKnF08uWVko2woVDz6D1n5Xfqa8XGMBxoTAk8FeDTYRaTzoLQ==
X-Received: by 2002:a05:6a00:1307:b0:772:2e09:bfcc with SMTP id d2e1a72fcca58-7742df2ee4cmr8310202b3a.30.1757310538216;
        Sun, 07 Sep 2025 22:48:58 -0700 (PDT)
Received: from localhost ([103.121.208.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77285bb2614sm13018142b3a.58.2025.09.07.22.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 22:48:57 -0700 (PDT)
Date: Mon, 8 Sep 2025 13:48:51 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/18] mm/ksw: add build system support
Message-ID: <aL5uQw2SQmHmCw-l@mdev>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-2-wangjinchao600@gmail.com>
 <aLlD2CDengxSl4fS@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLlD2CDengxSl4fS@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8060C14000D
X-Stat-Signature: y1zeufda98dx9zgdsoizpkcrpwc55y7c
X-HE-Tag: 1757310539-649474
X-HE-Meta: U2FsdGVkX1/kCJ8VSIZ9YZUQ5kjT+1ngYXVMahPAz8ebTPvpKZe6P8I4p6Lp9CUGVfG0Wn4mdVdb1sLVVv+xWI/9hUTQVluKcJ+BZBdYIYzlJ+sGHRSHTQlpJtuvtm9xzZGlL+Yn4C2iLz+nkEWnRzypVTaTi98S2rlgmrJ+M+2gky/bkZvxQaK+N4dcTJ/Za+g51nsx4E3NvkWlER9J+znJCxeaDS5SBlCeV1RmmEzwoiJwF4VVm4ucemBCsAP43jrCVxNO7mB6IeT5pBndiQwVTwDL00TLtoMqHsxHkXOuDYPQJpYGC/4fF+M7VK2y0hETMGJYREkDUI8x5AMlntrAmSRTSW4IN5BYnWg7CBvfKM9235LnT2vRjhS0TwG83Q2ZU8FowAPrkDF7gumznwEQ9+CQOIHOAiH6m6On0/48WCWhTqyaNhuLx87thKlGwhxOwwuxiEjrpv8GyL76lzitRLBuhQOmaFBaM3Y5hSWRDBPhX7G+B1T8mY5Ibl16iFzQEQDvkas7MGlGRqhcQ/ExiiZL7UlRrOo4/1XElI2AXWtj09l6+YFsIUe8h01ADxh5cD0NEOrUdTQNPIrri+mjomgIv3GCeoqniQC+r5QjIGY6h240QtL01glG4KLT/9slLEPNKLZlejGxGTzIJ7SXOlyI0UxbYsAPW1dAV4yXFVUXK3XYXvpcnKwp39QvRwSzCgAfdI6H16IcroAEtyghhgOh1BD0iW6m574/Izjt5617hqKz69Qu9zBnz68VgrAohSCQ/Pn9KmYmA0Bd7jge5lU2Y1U9CCgysvcqML4vVk0Xv1KkbiIzCVrYn040tOn3Q8vcPcCSFwU8vPnxfFFahl1J1PZakD75j+Eg4oebiG04JxHEcqvaHUAsPrykA5ECiSfqHYlz/vzBzHnQ0vOAu8E3BX1DXoqIOewT2CDtD/zlzZJTYtFJirjZ++fvbt1iaryXLJCxSuiJLnJ
 ywEKTmmP
 kTpe9GFzftTFgFlMlcQy4IwhI+07mULgb/VYmQIv7iUrWgHajSfPWpVMHITsDcsBMiNVZrKL0j2megk0O5YxAoYjZ8wczcC5xanraiZaISTB/2oeuRBITB3Rmkmryd5JVFAfVPYQ1GtBQ4+4TNL+bXHphjHV2ZmRnySZCoBoRmQxp3WlZezzocs9AmJIafmIt09v4uKM3wseGSrqcUlc/34EvwuGzbFUt3JwPgh+JVNJsGwgv3M5tGJoKzsNdbSGaUF5ESzd9wePXjn1zRTvToqCmcikocLL5363nZVbOv3asER9LBWFdbNMWzA1H+WinjaGNDx59qQ8l8a+DIGif4o4a/XDzpAAvu3K4NiFi3q74yBPiagtDN09CzsX4en5+HNnCv53ygePfP1keF3/jJX1OKavmD3WvDhAuR3B8OQaXXlSEo4Ykq/uZZNqL9OJI9BDs2seAkveYg6vhrbCzo9xj9VcOLxCtvF75QgHEFJUXFubZkteivE5LeiXN2sZAWT1U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 10:46:32AM +0300, Mike Rapoport wrote:
> On Thu, Sep 04, 2025 at 08:20:58AM +0800, Jinchao Wang wrote:
> > Add Kconfig and Makefile infrastructure for KStackWatch, a real-time tool
> > for debugging kernel stack corruption.
> 
> ...
> 
> > +static int __init kstackwatch_init(void)
> > +{
> > +	pr_info("KSW: module loaded\n");
> > +	pr_info("KSW: usage:\n");
> > +	pr_info("KSW: echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");
> 
> It feels like this belongs to Documentation/ rather than the kernel log.
Thanks for the feedback, I will add a document to replace these logs.
> 
> > +	return 0;
> > +}
> > +
> 
> -- 
> Sincerely yours,
> Mike.

