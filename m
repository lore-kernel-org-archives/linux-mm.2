Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE3A9EE20B6
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 16:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093276B008A; Fri,  6 Feb 2026 11:32:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06BA66B0092; Fri,  6 Feb 2026 11:32:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF8F6B0093; Fri,  6 Feb 2026 11:32:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA9916B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:32:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8928FD5941
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:32:16 +0000 (UTC)
X-FDA: 84414574272.08.DA77D80
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3885D40018
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:32:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NF1WsPK3;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770395533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zudsOAj0AfzZbqg1Lmjm4tJJgjoNQsiYFBqGBNU0cc8=;
	b=0uD3ZS2pRmHQfBhHgLVziNIHZhV4ngGLQ5QsOvSRo0qFKGRcvW+babXMFFHD8m4ZiGTAFL
	cLKiT3QPHuwitw2/MSg9FNKP9A/IksnTXcCyXzDnb6PZC5o+OxrU5UeqGgXJtuzgTBqd8e
	X4mJgqYthzfUCqj2OaR/E41RvNFnNE0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NF1WsPK3;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770395533; a=rsa-sha256;
	cv=none;
	b=dkGOKaX1ndzM4c1yPa1BGz5799/vFyu1RwTMTDGlIWv5+pj45t5M/pMjz++cQvnj7QAhc8
	krrqTmr9uJF+fz1W1+bqCfosh+QMQlY1VDHs4vFEnSEAd9gpBHP94ZGpV4zbXdQjmC9bU7
	VNuZRE5ocf1Ju+cPn2GVbrtGdD+rPPQ=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-89545bd3324so4460406d6.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 08:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770395532; x=1771000332; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zudsOAj0AfzZbqg1Lmjm4tJJgjoNQsiYFBqGBNU0cc8=;
        b=NF1WsPK3IDfdUe+rh4/TIvKYTSflcjA0qt0oq/uUmiY+0lo8bnXl+X6J+nrUxfskqz
         rd6MfnuQ4R0Cby3S87Mmf9WU7W7+EHtHFXKyCeL54+mxpifP27hpi0UE+aUthp+vItAz
         hVhd1m+ayQqisspK+MGYN980Cooos8b3SRNge9HgwHTxrwHqIHN/OlaR7eIye24reOEH
         tj/xlj/MjY4NS6GZWNuQmMt0uvLoEAFPvyoeQlW5OuIC/FhEeRp8gx+Gk8M5skxt373N
         fXNUPzqw4gE+M4i1+NPRf+zxLXaqaJ0Bd9KbdjYSlD7U8V80nAyoWfyeAbgyLUFCzGnH
         6D1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770395532; x=1771000332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zudsOAj0AfzZbqg1Lmjm4tJJgjoNQsiYFBqGBNU0cc8=;
        b=NJyM+lIIRwTIz1WcILBZGApUaZ8howLGXMEmJQyDoYcqlCOcH187M/ZuCh608eoxvD
         dP+Gr6dvQOt/ggWgciLpoWSlD5yCoyaCpYCDma5nbaP2P9ZV8+zvbZM4uFab1QfRndsC
         LV5zBZLNFl2QvymKSRQILcAPWQRvNAqo7zeRVnDpSv/gVHfS1cywsa6hMkM2MDW8re4+
         xVDVqU95RQLZRgx9xkD+Tjbv59A7PtujZYT+eduU07ccgNMejUX7HGSHFFCS7x8CH5Pv
         3DOwpH6jZjWZidPa2KcSRXKZP3+6YWCkJY/36+ElWHPyAWEjJR9ybV+fehrQGz9Uh8/y
         10AA==
X-Forwarded-Encrypted: i=1; AJvYcCVcSOXu+b6/uJ8UX52mIujqA7AI725yD9pK1N+zMHjwoFEZA1H4K7wKfPUtNREPhmHD06+IpkqlKg==@kvack.org
X-Gm-Message-State: AOJu0YxTyyEZLwiIt3fC+bT0ZCrvC0waHVDDYn/cZm+Rme5h6T9h6SWJ
	MKOJoRskJLNXy2XFh0nIPdxW70yAVJ/BCGRkzvM6TKarXb17z1jf9cn54qOKwyp9Ycw=
X-Gm-Gg: AZuq6aJ24/cL2Grm4gNVEnibP64KftwPCs5bZfT7tLlAUZFUo+ijZ5wc3UmRX2yElbF
	eh0dhA3FtONr6JnBFlzXQpBx03v1aCye5QLri/xPNDJhEbkKFtd5o9TL3KruFqot/4NU7wxyI+7
	Eb8WA3JVDRrX8Jbic5KrtL6PqbU+fgchklgbCTqY9OjVNt/KI/3vCRWqZ/nGlRzgh5Fg3i5BeNB
	6NYb1czw4ZLuHOjaOuhCTTDrQUTN8DVP8Z9YSGWVT5tMnsePG63SHR8NiS0Znrb8ANdgTrwmkpL
	1wnFioQdZhfDUo0T1FsWyUSoeiPLqJUEtd+NUpzDk3QK34XV/wzYpzKPxNB1iouIE8+h3N76RnW
	4zidlgM6Zw2NZcFR4wYM+LmKRGH6NnNwLPSOKwPy00lUKrlcNGnUsO0KZTHh+a2SsOvwWA1yTyk
	HgNamnVUKnJX57VA3V4a/auxxiUjPvruP+lOK2Gn+FnkBt9MKxgWG3Z4hQt6bYhamAfHTKqA==
X-Received: by 2002:a05:6214:2522:b0:882:4c83:af43 with SMTP id 6a1803df08f44-8953c86f554mr44159066d6.42.1770395532119;
        Fri, 06 Feb 2026 08:32:12 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8953bf37b9asm21134616d6.9.2026.02.06.08.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 08:32:11 -0800 (PST)
Date: Fri, 6 Feb 2026 11:32:09 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cui Chao <cuichao1753@phytium.com.cn>, dan.j.williams@intel.com,
	Mike Rapoport <rppt@kernel.org>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, qemu-devel@nongnu.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-ID: <aYYXif7IPXnXZPnn@gourry-fedora-PF4VCD3F>
References: <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
 <aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
 <a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
 <20260205145842.efb90572a902ae4c481e6ef6@linux-foundation.org>
 <aYUjf0OrD8f_bJCy@gourry-fedora-PF4VCD3F>
 <20260206110305.00001fbb@huawei.com>
 <aYXtHa4Y2y_5xgcS@gourry-fedora-PF4VCD3F>
 <20260206150941.000028ae@huawei.com>
 <aYYOZ1TK5dpX_h_Q@gourry-fedora-PF4VCD3F>
 <20260206162644.000050fe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206162644.000050fe@huawei.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3885D40018
X-Stat-Signature: eg76hbp9dxf7maj5c3mx8f7ckhsaumzh
X-Rspam-User: 
X-HE-Tag: 1770395533-684155
X-HE-Meta: U2FsdGVkX1+d13sOp07IrMTiLlOYJuR0JepT0aOi5NinEJH9OmsPlnBO13iKO5APgw+RfiIdIhxn0rpHzK7PeVmwCgdWkSe9w5IXu9yBL4f2oCaNaN8TIyMiUA0j8rLtTD3jioHbjKAzNhA6TXUSyDX9W/fdpahPRIeMtXm/6bKXr4Pc85lPVU75BrfdC8KTyZR81cpaDnyGkCnyV9+GTsRkosnS3/dniby8J47TEe0B2cSh0Zq3Fn80zPNkOdV+8rCHei7ZXYWnALIt/ni4I18X7clvY/ZXI/3sp0md1MPbnSVQKJBsms2dc7on0ZTaoRMluS5oeI0vZZgfh2TA5l5Xe3qwRMOGl/8vMtSEffHpu3JhItYRcokMQ8o3nzRC3Vu4YbmpLeNz5v135Xppfv5MgI2zfmuQ2SNeptXRW8iCtPY7sXQlwECjfgKOPEvMoPLrCl9xgIwq6bd9u3jSe87RgWceT2es5KOmDLjX+sbuq80yPuFGHLdG9awmoguzdefJjyRoAljDZ7yYBuZhYr+KRbTJs8EA2wzFKsoVkThCYWXkv9I+MuNYdUd/SROelSUx3GjuJ8ippvkAH7nYXpu3nCfIbaW6pL8NiCQikq1WF+BlxW45Lm38AJO5sr61DxNZgR6gj7vwjnWpsUuyMHAg9OoAfZm6Z93CxGxsn9OqNTKJV2+1dzU7al1UrYGZiWFTMQU/Nf3ArCxo8Qe+h0OMhhYrgfGdgqLFufKNLZuGeK1yR+QWVGgDj3hzNoL8wfPEGcO4hQYGusUZMCcsBfYZnZp13v5uyd6qGz9sE7xCurFu23Yq/JbVd5/WF9FMpZK4Y7G0xMlydxEoPrN72JkJb41XAKo6W6zfk/aqiRssRWPf7+fxi1cAfahEHO6UoUc8CaOZjwrM9jeBvu5wVIWj4AeZCQ4+G4BCV+TUTF6m7HtLeaI4B4O2aVr58/BrvZW5sTLBAK53dWAnjNj
 c/PbV+s6
 zUSNwqgduz2UvaFBClQNAFM68HsaxdSHlaX+fajPgRc1zeYMBFunj0sP4+wvAepvsgM+fppOm+ufC9+LXLakYMcxWP36wVf6wqK6R6X/Ks/vcloMAFbIGTQeu7PdYT0EDLMOvBlj1CZsYhvMqUnZE4Oxc41f3u484eeUF/mjK1cIIjWdkfGb4Z/hdOP9rXhZaeKjCV5TXg4Sn8z3qPM5sCmOJPRyeVif8PCnHDd+bxMcGwUsla8MlrF+99RpZbqe3cbneNoxQ2Pde/SSjshS67Wa5hX0sQXbT9oCdzpyb8kTIgbtxJH+z4lAxZSzpHqiTNYa7zirMz+r/RKTrGlcBAERaj0EdI7F+UneVfe2/DULybgMY9AOsFxSPEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 04:26:44PM +0000, Jonathan Cameron wrote:
> > 
> > This should fall out cleanly.
> > 
> > The additional nodes won't be associated with anything, but could be
> > used for hotplug - I imagine.
> > 
> 
> That aligns with what I was thinking as a first solution to allowing this
> to be more dynamic.   We can get clever later if this doesn't prove sufficient.
> 

I can get this out pretty quickly, hopefully sometime next week.

I had a long talk with Dan about this topic previously, and I'm not sure
how we get more dynamic than this to be honest.  nr_possible_nodes is
*definitely* expected to be immutable after __init all over the kernel,
it's used to allocate a memory.

Surface area is very large here.

~Gregory

