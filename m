Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03986F99C63
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 21:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9746B0148; Fri, 17 Apr 2026 17:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1F26B0149; Fri, 17 Apr 2026 17:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE3D6B014A; Fri, 17 Apr 2026 17:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 201A56B0148
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:04:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1F041A031A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:04:43 +0000 (UTC)
X-FDA: 84669276846.25.C3C234C
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id DFA4280013
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:04:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Q/j1X4uF";
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776459882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIFmiMDTeP/Oqc+nqvJkfeXsIdepM88Xx6p9HfnIkCU=;
	b=GOxycKPYVSE+L7iG6MssupCSV7VIF+RJ5GzX1kZY5VcvI+5H9SvQT7yHFrO2YQuIxVdXue
	xfyH096u/DUBUDRfW+RWkhR6XMMXXre7azj3nE6kiSHhsmvCfr/4gDmkzF0iYVzrI0oi0N
	qq5m4GLm0Ep+wylj02AP/aEp+1W4Wk4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776459882; a=rsa-sha256;
	cv=none;
	b=xahunfBOkbM+nsIyt1F/5v/DiUzaQ+PLGvvEvsx5RVcRGwPbX2YunSR1WdfuIGVWzCp9Kn
	7wICXialY26HCGXK0sNoM1b64CTYxDP3/fFo9Emdn/knQHCQRm1ZFuS9jEvwo8TXu0RQZn
	REPtPsoi+cVLN9Z5fKUGrwuw68EfPqQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Q/j1X4uF";
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cb20bcff5aso101407985a.3
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776459881; x=1777064681; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QIFmiMDTeP/Oqc+nqvJkfeXsIdepM88Xx6p9HfnIkCU=;
        b=Q/j1X4uFWg+t7LnzWAlwFgI/WfwgncuxsAWxq8yAsQLrIE2pCGhnD1chtHJNGHCCNd
         LCJhMAsGBWYX7lNLRLuFDxTNp92qGiN4yrk7A25dPFWnccKCXJJWz9ERSBQKSSh9TEpu
         ocVFlygzbfqt5o56wqditCkXSVfy4CQ3VYrSSli1nawRCDxJv/pndmqb0HH5tSiDp+ie
         oxZYxlRRPkckV/OVqEMJM25PMLx0+IIcVXB4vzQSMyM+lrmK6Mnup8K/8QgEx578GNCd
         GeoBuG63H4pL7MSHO2pFkZH44gT4+khb1Ri32aVnWzCJR/ZbiNnq56+oFtHInUZj4d/2
         ZKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776459881; x=1777064681;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QIFmiMDTeP/Oqc+nqvJkfeXsIdepM88Xx6p9HfnIkCU=;
        b=m9wxTHZz71kKWBfV4pc61IS/z0JhCqk/3WV7Ua3hUgPT9unFr3hCQnr+Y5DOD5NArz
         naGaWhR9+P3ebghQNzj0TXodhR84VaO1clHrySp9HjDb0j4P/7Jl3ylDTP8DahjenghX
         ABTAQJpAP2OdoImvSqB4JFFN7g6dcF1X1lL/gKGEuCl02QwmNn8dZAoS9/EONXfNcNBB
         sL/w50Rxqqtzayl7gvrWZ9zJbCcWacIxuJTZOLHjw1Evr25C7QuAIiA0+EohETn44kMs
         2rPcsyMKkuDZxGIx3TtAS38Ujy9Q5z4r92qcWUFouOGX5B2LSyYAYk25w3GVmRqeQprM
         MPtw==
X-Forwarded-Encrypted: i=1; AFNElJ/LDELZCWpk2mD+FAVAcsht+d8z7q0oWX+bA2zJBCag0cgjbK6KeYn7qF94u7UNw6kce6471QUpQA==@kvack.org
X-Gm-Message-State: AOJu0YyvfEu3ExhCDVL0RItP6wc+p9/osmPaTytQC+jvigcqAy/iVeg7
	JU8RT2s9h60oyOEZ/d043rdH3hHJnuQ4nv/doHfjFjibtlYhr9l7wfA7AiRtPeGbweY=
X-Gm-Gg: AeBDievciTw6HHl00obbAiU/VlH+F2A/v8T4DJOY2Bzt4Zlp2Y5HNOAE9ftn3M3/Lr+
	gVU83iPIvFAPnup+JIcJCu6JYXu1f7ZVlAUo8rrMQ4d62x3ADku9GH5rxGk62S2KvhJvEkcvd2+
	b6s4+u6Wu+dQgZQva9cbjwFh+ZPrU+TRHYPQEzfVhdErtaCNHIMaTVuar8Wz3LsVPoHaYzrWuzM
	QVK44igFVYH0iEbTiQMowGjoTB68rOkFwjBi29Roa+bWAF+U9y3pNDNc5FPRoHJq01dBwsp2ptr
	VW6yRPxOJsUfYG+y6WbO+Bnh0/68tDYgT/BmDH3e+LVXTlfHQti8x3bFIAc6N57aa/rzXjLafV4
	bVEWwzaFD5nmfFF+roIz8y2EsI+mi5CP6bVU00q2P//bhEObD0sEesCzp4xiA0uFOeZd2J+i8Jb
	zR1OoLy83iQt9dWCasOd9im5DPagE5P12BMS4SfweGcgOmoIl7BAY2NdoOTsq2
X-Received: by 2002:a05:620a:4513:b0:8cd:9665:9eff with SMTP id af79cd13be357-8e78f730674mr667672085a.21.1776459880758;
        Fri, 17 Apr 2026 14:04:40 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d69ad48asm189183185a.19.2026.04.17.14.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 14:04:40 -0700 (PDT)
Date: Fri, 17 Apr 2026 21:04:38 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <qwxxff3i65vsnzyaklovxp6ldc26ni6wnrfd2mne7oktdybqan@35hjg7obfrf5>
References: <20260417205810.1831923-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417205810.1831923-1-luca.boccassi@gmail.com>
X-Rspamd-Queue-Id: DFA4280013
X-Rspamd-Server: rspam07
X-Stat-Signature: 88xiipdmr915a8346m4xpsqie56rxsfg
X-Rspam-User: 
X-HE-Tag: 1776459881-155431
X-HE-Meta: U2FsdGVkX19ByuG13/iSetRZGKIdkMwyZLbzyFo573/Lw4oTeMJLoEwUL2uCuKY0SdGlBZwMcauQhUcR38amvLYUyqiqLmLae+Z0cLKhhC7sXKCi3k4Gk14NiV8YDUflnGyrMN3oHbG5w63viOJ7vu6+5hSqnEa9aVzOvyni2zIQoPF6G928D89HCYEmlHFD99HNrSTHqi9fisbr7n6ynuZlP2znukmAopkUtiB/OE84TkpkitiMQzQ33STEJes6K3v1hQ+Tsm95p8ymjb6A6alneyKa/E202R4dKF2uP1zIIhPrguo0xaVVGPzhDFF9argUwctOsWSAPFVXoDeCfsMLSrqstFKI8XcZ7mdF1wvTNCCOpgKYQaQanbPTA6BHkmU87y3VVd8v3OFJJwkFH5NzNxY4hi1s/prCERrPnVZkBNBbGMISmy1ERdHPhgnWz8mjzWlBi5rY0nyuAZUeAsJcZ2WZfymynL2uouizHvDnHfoYOSnD+G0FnHv3K+PhWDKR9t8fN1sb58UfElcZGaTphdvGsjp/PF2/HUh11btm89mHofgpVo5m7ZaSlrpzuUlRB6p8TkCFS7emGGq+xBSBWeUP7t8j8qVbWnbqRM1YL9mjGkI7RUzGdOQ9lQTewi68Vm4+Ph27spvJt9eTHZzVi/ZtyQ8GIcCFli3LshdKHhAyACholtBJXDE639xQZ0mZvJyDQNDOc0QeQYY+V2X+kelc4kdo8Ju3IlTNphmhtXg7t7iL9Zhepe1QCcb2llYReOPCkCSF58P29sDGYSoSMSQHHdVFkYLC0RMJk34Ldqove+XE7Nu7D4MKJUfeYSMFG00IpNrww2k+K+e7Wkwd4IiowBqgJpw5V6DFeym/+vLa8saBqsyLfVUxriGanULRKCCyJ6XsRwGkeaYBVuLI+tVeWuvQ6AfdId1b30w08pwGL5BBv1eIhJw0lOaEipbR9iD0ZBF7rnHsEbw
 ZYGOc0R+
 Wj9/lzoiZQXnaihPZjGyf4CDWTXIlZVf0p3kTorLCcUQfaK8Dw01nFgV48vVZ1fDJSZIkvm2QYgfaZU5r7stRN1SVN0pjzCfyofG1s6/tOGwX9GLwQ5QGEmfyq8ZFalRlpT1wAKWVUrjV/MpxlpQ/ayjDVnoMKmLvn2VGWajSZVHu5EaPjEEVx8FsUIAp4coi2/KuqXKat2R6AWF5TxIeRRAAqMtX2RO9CuxXBzx6L60Ysy3NRxEu2V+roMchHu5GxWgtb9UgZDtGDaHBckPcESygKm5LJocVMJBuz1DLkyCVdYDdmTFwLN8+aSndxHbUpUciu+qn/QunkYi6yvpDnK2G6IhYMkfJa8m+5BRL/Kp7KdGORnDSwzvy5X9uLQCT9QLqwTb/MVI+HxitJBs+ArRAq2ZsA7sz30hatvKKP4Zygf5iUoVwp2+jrjIff/3wT1A9/czhc8M8onwcuhN+TvvxysHsYXuDefR/O5IpaRn7mv43L9gzLbG+kMyX0d32SwPQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-17 21:57, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> In userspace when managing LUO sessions we want to be able to identify
> a FD as a LUO session, in order to be able to do the special handling
> that they require in order to function as intended on kexec.
> 
> Currently this requires scraping procfs and doing string matching on
> the prefix of the dname, which is not an ideal interface.
> 
> Add a singleton inode type with a magic value, so that we can
> programmatically identify a fd as a LUO session via fstat().
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

