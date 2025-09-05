Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 790DCCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B75E36B0010; Fri,  5 Sep 2025 05:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D7C6B0011; Fri,  5 Sep 2025 05:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63736B0012; Fri,  5 Sep 2025 05:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 941486B0010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:00:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53458140614
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:00:37 +0000 (UTC)
X-FDA: 83854600914.23.F7EA97A
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5364040010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:00:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gDRfa76k;
	spf=pass (imf27.hostedemail.com: domain of pmladek@suse.com designates 209.85.218.67 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757062835; a=rsa-sha256;
	cv=none;
	b=BEPpeNMFB1mxQqboQCve2PQkKC1Udl1SBT7LybtL/KvtpB0l71W4z/RW3XjD40NmTViOPZ
	TrXPAPbjxJGODXgsa2NmV1YTwt1LnCnlXG2QXEFaYSZ84nTL2EnCzWSVT9Yax6crOpf9C0
	31GkGjE7BU7ieBJT1epP3RBeMiLcH8A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gDRfa76k;
	spf=pass (imf27.hostedemail.com: domain of pmladek@suse.com designates 209.85.218.67 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757062835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FRg7joCYkF/X8y74ghdzGdbt4nbhue7w8XGA2c25pI=;
	b=xjkePAHfrtklZNXPPStoJFZ+Smvjojip4k01Kedt1w6KcPZOeozRmoiZe3I43m6X4w+STE
	Rp8tp6/iVMxS0PRP4QR/rxIECnZr/OEnAhLNFVw/l2E2sHROSsHV36RbPIpHVX9zc12tYR
	vxSigbCtyjYshgXK1Dj5fhxfaiYif0Q=
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-afcb7ace3baso352668966b.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757062834; x=1757667634; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4FRg7joCYkF/X8y74ghdzGdbt4nbhue7w8XGA2c25pI=;
        b=gDRfa76koa3eKwtPg2oMgI9yKIjskiZ1Kl+Rv5NWPO21Rb7/V93EoXodDNfdiRAzJ/
         YSqxPxYdUViK3U705oZag9Xml5AdZ0/GfNm5Jnrtua0tSJmLmbm1GZC1E5Zagvs2QnAa
         i5CptJ85mslVT7qOdz7x+mgiIJJgUsp58IL0ZokT/6UwBRKhy/WsTkk7gBODYPwuX+RG
         tzp8krPUG9vCTkbI2yn3nb476Qiav7BQEvyizWiAxOWa023JyuX9nGd5A7o6zrJiOnQX
         1H70GCfIyhCNWX/3G5DRmIdlPD8Vuz60Xszbklv4lIv14F9EJtfL22uHyYpTYrqk4nSf
         b9/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757062834; x=1757667634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4FRg7joCYkF/X8y74ghdzGdbt4nbhue7w8XGA2c25pI=;
        b=RA4U55GETSonXa484QwEH0wL+2bYzNGcukmGy4kSBPBFllyBqOoLJGbtynPW27K6ia
         DtjXVIy7PKnM6c0NSEyKr/n57aBNCeDAHVdIp4ui95FpjrXbENc6yiw9IfinEDdBwVjJ
         1PcL0uyW2jxb8umyRpHJnjZHEEqgaIqYVkBLJDnjxSqj+7ugMjW4C3KGDrzRSqOjP2BA
         0YmmjfNU5VssPhJltxRQ2amtVv5FXr8FdfSvTClmIAt6X6BLU40CPGigvXCBN4VZ5oUs
         wIl/aNd8JPryK94m26iDKwRAkXXhBgnaaiwyOo1eQFNfgkgFjSVFECEuKjU1sv84vWDE
         E8xA==
X-Forwarded-Encrypted: i=1; AJvYcCU0zsvtFhLf+0g+r/cNCsXYLKegwhx5X2uDwErRp39FFXQJ16Agk4uZMeHKfWMLI3+MbFTuf+94sw==@kvack.org
X-Gm-Message-State: AOJu0Yzau4SX7Ws6Fd0Qe1m+xQtGBbgfIaycVxvLM1AS3fTqY/+P8fQ4
	7dbkShLzAXrTBeh4Pe1EGtZ2qY7oXq+7wkjyeEHkDhuE2XrtFxkkWSLDAOun4668ySA=
X-Gm-Gg: ASbGnctpv8Xc8HBIR2GdFiPBg26UKIbc677C9DHOLTtz+MT8rtGS4RRbc20uC7hPEA+
	pg5UYDBWLmRK4BChR44eOwIQK3T/h47VJX9ypNGWwoKPE3bkdWGaLby+hmX8YgYgXrLeBnH7ykt
	YbQbqH6OXWSj5NbSISU+ffUJPhN7Dadd9ip2los+QJLf6+UdamoBE6IsaZ5uT+Lk7Zhc6tvF1Ju
	9wcGKKUi4lGs9Y1aTmD8oJ0MraxmK7nClGqN5dr9ZpyRBQVRNK275JEsYT3A8Apj+CKUhGhnj01
	GlKeX3VnwkvufxlsUqlSKLDEiYQKRxIP1fY2aLzZr4bnEpGF8d/x01okxgqHIdXIyBYmjfLxBo6
	awIRBd2rfmcb6a7uSsvwUnsRGJLUqsJ7jMx2U
X-Google-Smtp-Source: AGHT+IHUVhAkcDAy7EJgYnS55QC4yl879/t4RSjjun3yuZ1GOCFoX9tdSjD17TfA4gqevjwi0t3hfg==
X-Received: by 2002:a17:906:e285:b0:b04:d8e:3297 with SMTP id a640c23a62f3a-b040d8e3373mr1885893966b.15.1757062833624;
        Fri, 05 Sep 2025 02:00:33 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc1c7dfesm16225764a12.7.2025.09.05.02.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:00:33 -0700 (PDT)
Date: Fri, 5 Sep 2025 11:00:31 +0200
From: Petr Mladek <pmladek@suse.com>
To: kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 6141/6355] kernel/panic.c:70:6: sparse:
 sparse: symbol 'panic_this_cpu_backtrace_printed' was not declared. Should
 it be static?
Message-ID: <aLqmrytz-w3eNSzH@pathway.suse.cz>
References: <202509050048.FMpVvh1u-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202509050048.FMpVvh1u-lkp@intel.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5364040010
X-Stat-Signature: dqaaawq7htbnuh9bw639uyej1t615wir
X-Rspam-User: 
X-HE-Tag: 1757062835-876252
X-HE-Meta: U2FsdGVkX18qOMdY9x0lxnYf5dw+U9sPF89VAcoKNVhUprcY4Ma/rrz57lvn7Pb8bRkFK0YzlEpiGR9GCsA7sV4y2MpN6d7cutysBdkU6J4BVsc7ETUvgOdbBwJhPExuy65Arv+ZOG3qXJDiU+3C5fMyIEdqNxLtvlVWJI+04zn7OI7/5dbLdqGMzw/eMCMA4judlg5mpCIlmwVRwhPzJQrYy+fyLHvRhy2WGxhvkcFEtN/Iu7pK1LlJ1Xn2mpcnqlNUibfIKN/lJ9afJVXHpEsvFPJxas6X/XX2wz5i6nsBnux+U0bgFassJg0XsEXjWh01kTvxyI/rMvmbdH5EBZiALRvz2V5wcGcIgUNqticRgqZhm1pfCpM1G4HudgVSWJmxyTxBzknckekyYyNB67fnxiHQzn/UjQXu2KPZreE3TWgZaxBkEBLCflRfIfd1eClM/0y+Z9IfecQtHI02emjaBj22SDl7nPH1B/SuL2mJxcdt0SWvK4XeTT+crsePt3hxgHhEtJ4LmUJcM/qXjH0Vr5LERMBRSJfg+8kf1+sm6fdjlYVys+e2ObT7Irq1qXkUYHIcvyTd17gUZ8kaj0JETjXDsXaISVOPXF3xfav1eQCA1xs1WwSTv+mSKK129oIM7KNA5zcMdxWFzpHzPcYCSWDiGbXEfwF4PUi3vH7g1CMQLMEb5YkNj07AjlFyjsA1cmT0DzfXi8n+F62MLrPMoV3iIr9E1Mysvz5nJY9l9C9jQzHbmUFk0HX8xtViaNErtV8Q+T1Oy4o68DIqgCGEmrTOLlkISezOoC8vImp16xkKLXU12GyhY4ksKT8/5fyu/drIrRsJxi52J8S0IEmCgYvAMKQgzpxc+q3Bc7pMW+1b5D1BbssUBOPGNyzXCWql7UEdR150GDZlviqrZgbFh+4A5acHnmilMrbBBtCME5mKlXpVcnzrpFVkv3Hdi9b2O0iz/pFPrgYBlre
 3Vi8aE2V
 FsKj8jZNsRx6QR6lP+202kpvhM8YMaMXVPxcIXwib4VwwgbvGZoaYnSONS4N59bNhRC5c9nEnp8cSOskAb/82rUxpXhxT97fG6RND4uUFE44DBpM4io8T+T6wzSzed98m+P6JLVWMupD6vY2JTdnBY3NjVXD1pn+71J/a1YFa49K+pYVHkWTU0eLjnkUG6WUXFpDgkyLLw0WIdoQPjMIAHTg9t50APMRct436l7aKlrkiLBb5Odgl9WkYk0dviL5uRkT7VzmV6Hv/Xea5M6QDUb2PgKp2WDm2lyAjgvuq6D9rBFMrKN2u0EnJfRHCQ8jpfi7Lu1n7/laUhxGxNmOG2dQ1D+Me6yH3vvJEq5MlNygOVL7O8YfkHfyqmSV4hRWCylHuJI4EXF59xZxXS7n/npWfWnUrcyzCSqwLiTQBx62YpDxgjuG0CQZKjF1mIAMN53lMFR2C9YJqzw0tumN0Et389Oz3nlWCgB4Jy8UBQSUWrLa7KyX/kvPN3xvyRk0d/Cyp73f9q0doOQqzbqaNa0EuVz3lltns4EPjVMY/UEbMALPU4I6nEmZvXEpVooXgGX0n9osdFhkVhzk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 2025-09-05 00:50:11, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   4ac65880ebca1b68495bd8704263b26c050ac010
> commit: 28ec7e0d834d81ef8abeb6a6c1376f1fb26f1510 [6141/6355] panic: remove redundant panic-cpu backtrace
> config: i386-randconfig-r132-20250904 (https://download.01.org/0day-ci/archive/20250905/202509050048.FMpVvh1u-lkp@intel.com/config)
> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250905/202509050048.FMpVvh1u-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509050048.FMpVvh1u-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> kernel/panic.c:70:6: sparse: sparse: symbol 'panic_this_cpu_backtrace_printed' was not declared. Should it be static?
> 
> vim +/panic_this_cpu_backtrace_printed +70 kernel/panic.c
> 
>     68	
>     69	bool panic_triggering_all_cpu_backtrace;
>   > 70	bool panic_this_cpu_backtrace_printed;
>     71	

I see that Andrew has already fixed this.
Thanks a lot him for doing it.

Best Regards,
Petr

