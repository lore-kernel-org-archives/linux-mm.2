Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7947DE8783D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 14:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F4E6B0098; Tue,  3 Feb 2026 09:45:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2836B0099; Tue,  3 Feb 2026 09:45:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5936B009F; Tue,  3 Feb 2026 09:45:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78A846B0098
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:45:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1781E13B157
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:45:02 +0000 (UTC)
X-FDA: 84403417644.13.B3CC1C4
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 10C6A1A0002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:44:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=R80ZUupK;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf19.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.49 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770129900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hs7V6SWbek2ZeyeUQeiTszpmbvycBMvjXv7GzQyLNVk=;
	b=Cvd2ww6Dgblv2LxdK+8ILpr/Djxe6TUf1cOJzOysh/YACmb6gwdioR8DlqL97aTdFW+n0Z
	D+GzdwjBMcm4AzFQl5qoMKvGMu1YJ/0+TKb8pGTZTGr2TEcxI9Re00simcdZDI/V2lkqwT
	CUTyPNMgdbp9ej6ZsiVMmWcKr7YfZ9g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770129900; a=rsa-sha256;
	cv=none;
	b=0zO3VCvHz8PVh0K6qkhy+QmYGssxDvdJTtoBdjQWDIFl72lz3FPQ9fHNyA5juHAnYuRD4c
	a5bx33EsKrhFvnWIvmYOdUf/Fo2AvvBMynLdeQWVnRYZPOOfvRbLSG4nzVnX0iX1utLr5d
	zWJjIep+00nNrtsV4QWoIqFIs8rv8/o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=R80ZUupK;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf19.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.49 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806dffc64cso44139515e9.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 06:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770129898; x=1770734698; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hs7V6SWbek2ZeyeUQeiTszpmbvycBMvjXv7GzQyLNVk=;
        b=R80ZUupKrTXvOYTJR/0m3x4FffKoCy0rH4yu31AO8w3IeHm0TujDVYbiMYqVvh3NsD
         cBE32/G905eAsfZ8+9lSSRrYUfN/nsm2Lwf8SLSPt/x8mBOuwoBYiqd3PY1V1Dqj7LEb
         ucS/nZQk6/fpdxbpzAmPVw6kD2n1cfcFR5G+6Rp5Or8LzQba9HLfNoha6to/5k5H85nV
         ruSF0fk5wwdGmr9Wk5CkQqKYxCHSBczWL/iqQZvlzKJ1bibLrmVyu5CIPvFZldh6xezb
         8wkKv3XkmAzJIMjm+bZ6TW//iuMI7dtuLRHcJ25tKJtSBZtaIOWbjczb8unRoyYWx4Mz
         NNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770129898; x=1770734698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hs7V6SWbek2ZeyeUQeiTszpmbvycBMvjXv7GzQyLNVk=;
        b=Bs9FeJKJ+l5KE4IU0wBU9Hi/+XwQBpAGUbdxygc8VbS6hdCVjcuKyMokccmK+AzJdK
         hSlEMVNnXDM+dCr3kEGUN++m7U+uV1xMg2rLaKRgmQOx2z235zoebcY88cP9U8XQnZCt
         u3VY5gyINBcCh5NaQmJVv+PwV9LAj3il3IITPmfIVdS9UUfLrXtteGlaT2cgu9I8xXpV
         ysaCT/MyNLoVCYn0kkQE2MV5x49bw+XiMPc1kqf4IMTEfV4xoRmvDz9/6Mzbw3h7Prt0
         iO+FtuwXfasVttXaIqYv2LW4uJ1sFizH9/ahRnHtaD5oj64geRbPbe5REsLZ0M9TOE3r
         iQdA==
X-Forwarded-Encrypted: i=1; AJvYcCXWNeEOrvg3GY5TsvBkwbpa8k41McwpxHikUrYKILXPfBl2LNoaOVxxrtGL+U0rl0yZ1pCQIRjIxw==@kvack.org
X-Gm-Message-State: AOJu0Yz1ZTjE4MyJYvUcJ3zd6vLkUGvAmSsqvfWmMDpamRT2YTlWR7ng
	JQj1l8H0uO0BmmzXHTkvKoVgO69jFkMkHKSkcPuhy1aw/kpbrLPz5ysuoLz63c9KuWk=
X-Gm-Gg: AZuq6aLaodry7XQf4o/1mesqMU4aMODydoOSISjoBxzCDsr5TGUf0olIpqS78zAwEwE
	f8dTNOKdJMfI9L6IVIHYoHgSEHM2lHqpOBmhTeZHtjVFCMo3pIg/urn703sidm0St+SHwhLJ5tQ
	kQ5XwgAEEmO3boT5+FU/KpcgTB4U9r78befTSWfYjtCHGVuIokpEPgtr2FXPKWybxh85HlpF/1w
	wFPntGubqQL3ZizPR6BGNinwqqHrVRBS8RzaYd7mtS5zDCMJwOKVaoaBIBR7tBIHtkXfDF/n/MY
	Q6WGR6KWew1K1HXZPjyum8bAmLO9i0ZdBUFndgqDUV/MHmiZc59u7HaKajwLOaNodSflxnNeIIH
	wPIyg+oBFXHCrwCRQbenjsEGcn+nOa5b5rKiFR9+GLW4QauUusT4k9wtU2rmHxfPSv+lJ+bJFD2
	e18F+/L+97UrFfBj6G
X-Received: by 2002:a05:600c:818f:b0:480:49ce:42cc with SMTP id 5b1f17b1804b1-482db45f4b7mr193577785e9.9.1770129898159;
        Tue, 03 Feb 2026 06:44:58 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-482e04ed4d2sm121274235e9.7.2026.02.03.06.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 06:44:57 -0800 (PST)
Date: Tue, 3 Feb 2026 17:44:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: oe-kbuild@lists.linux.dev, Alistair Popple <apopple@nvidia.com>,
	lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: lib/test_hmm.c:932 dmirror_migrate_to_system() error:
 uninitialized symbol 'ret'.
Message-ID: <aYIJ5qttFNmL_Roq@stanley.mountain>
References: <202601152125.McLpiKxS-lkp@intel.com>
 <ba7dea85-4bd4-42f7-be04-c23afff5b34b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba7dea85-4bd4-42f7-be04-c23afff5b34b@nvidia.com>
X-Rspamd-Queue-Id: 10C6A1A0002
X-Stat-Signature: a4amm4e41gib883bjd78kjnsuj4ptogb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770129899-887098
X-HE-Meta: U2FsdGVkX1/pEAlNjcfBSS/md2uoHWNV8yLkXD7RP2EVn3vgkYl1dfL7rxYmFRhsIAkDNlgbXfH/Cn2uzSjRMBruCzIlo5v/AA2Xpc2T/2fQHUJ3sEo2zYoKTh30CQaqXojN4x4w/1KlyZ1vfsNhgA8S59x0BnldzIzcuD1GtHUmfWC8vHgrK4ThWobCiXMBN5oZLjFKTbYtmIjLD6hyoKUgxH84fbX7ChxZ7VCMinwNvL5psz3QWNhPaSfPh3U0SNPTlVTDtEyH4hH5Tyc31hRL1UDrwKEWmK691cpcbo36wUMak7vLLdywX25ywqMTl4+9sBnEIaN6REksxSN1Gs5Bi1jL3dmzxoGCZRG0504+6nQ/D2aoTz+iRUqn3ZltGO7IGVuMYJLhifgT3Yv/TqO6vFaLvQHOqo9IzhAuwBHMN3flPPLfOqz45VAmBarqJxmS1MwbDd1atddLvnei0OISSo3pPJOH/TgFv+juNNcwFD8TZrOU3s5uSuBKD6KO/gUo99tcKWw6qK9HtrFQ3jdmX5vVq4nZjFFUjo2SsxnMR2IkfKoUDqBROIOe+p2rTkTckphPAKNgfLJC1wYbmU3V23FhXjFZvuzQhsDPw3HDmQIygQrg/fg6AcJC8sPKSuRCtSw788bG4D1M9xjCzXBnYKSg+qrmMCBeoUL/j/MzRXiGFJK5YqbiyhzqhJeRLdVIdjAbAzhzycxEhs2MnV/2k6wLcOfGdeuFoYyXzv0Y1adIsMokZPP+pTIDybWlKvrGK24/4P3ElokZgoCFFQi6nOPz/u7BQy4q5zumV1c8+OhHZTef1FUty+UaSpbW+tD3CqIIm98e6VArzBuZqRrflJm6YdU6eIhIo9SQe6k9GMM3Lf07ILQlbCWGe5mRSpaJHQp4COdzzJjUMjXKHPhD7G+SFHvnhFzWrKNMJisrPF5mangEh+XZqwhhEUrbxkIcDQn4l7s3RIm9Yva
 vF2uGPZJ
 +848Hi4Z1Q60VURd2y8ynOe9BgEUsX/kvNDDPSEv0maeqVV4E2LL+Ef/xyqkaYv34c4eKmPN1IY4PohnKi5+ZSqHEKdp5mEadbctpsm12hmEnnooKoc+/Gls/PNGkk7RaljTuBijzL8cNWbdMXjxhvjXgEAdoTWks1MBPC+xyquyIdDhyhPm1LOTnc5ob20enkdhHRPpHz2T5EtZztKdDWHhel8U+CDORdzQ0YhoRgmMwy272QdmSC/1Z7lUob/UarnHEtPgu+NICipgY/tB9jOgFu798wqK8UWXQpHbGJQ+CHrJ8LNWv4RDeHOs5EiSUNcGMIHYaBf58OnLiHK2MednTVoX6/Gg04GJTFrhBdr8Psa0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 09:34:40PM +1100, Balbir Singh wrote:
> > 4c2e0f764eb4444 Alex Sierra     2022-07-15  928  out:
> > 4c2e0f764eb4444 Alex Sierra     2022-07-15  929  	mmap_read_unlock(mm);
> > 4c2e0f764eb4444 Alex Sierra     2022-07-15  930  	mmput(mm);
> > 4c2e0f764eb4444 Alex Sierra     2022-07-15  931  
> > 4c2e0f764eb4444 Alex Sierra     2022-07-15 @932  	return ret;
> > 4c2e0f764eb4444 Alex Sierra     2022-07-15  933  }
> > 
> 
> The code looks older than the current top of master? The smatch warning is still valid though. I was wondering
> did smatch get new heuristics to catch this?

Sorry, I can't explain what happened here.  I had seen the warning before
years ago and not reported it.  :(  I don't know why the zero-day bot is
only complaining now though, or why it blames that specific commit.

regards,
dan carpenter

