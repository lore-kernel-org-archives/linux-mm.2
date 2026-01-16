Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19D4D4A609
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5712F6B0088; Fri, 16 Jan 2026 04:10:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B2B6B0089; Fri, 16 Jan 2026 04:10:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455DB6B008A; Fri, 16 Jan 2026 04:10:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 363D96B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:10:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCE971AE4FC
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:10:01 +0000 (UTC)
X-FDA: 84337255002.17.F1E53BE
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf06.hostedemail.com (Postfix) with ESMTP id DE79F180004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:09:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F8GUpDCW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768554600; a=rsa-sha256;
	cv=none;
	b=hi+IJmskAYBehamCPlYW6hN5ixMHiMS17ylPADHot2uJkQV2lbHPBjIue+RSfCXt5AJn0T
	CVHxF7/UaT4I1QCeK6dYCQd1lA99c9vkyAN4eEKsuM5b9ioFiuLqYrhUY574VvhB5OpxdG
	Td0X6i2TjYiq2rj0ACZSzHwugakov7U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F8GUpDCW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768554600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOxbiUxMN3dg7qxjpVPifAiw8BUqf62Vd3kADlML2Vk=;
	b=3mUcBLlCW0CjnqOBTYSJT5l8JFGQiEFi0cO93yqFtQQ2vrBvRKkx/e+zxfbKITmWJUZnPn
	ApJJYZ3mwYdpW4lPH0DWgQ9wX1FrmVtoXtOHxRwwPknRRXkOmxmpS9Z/X1zRJOX/+0c9lI
	i4vNmc5EFZEYqo0PWcSqWCB+jAs9FfM=
Date: Fri, 16 Jan 2026 17:09:31 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768554597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tOxbiUxMN3dg7qxjpVPifAiw8BUqf62Vd3kADlML2Vk=;
	b=F8GUpDCWN3+dQTwaOYHZ77yjO9ZKCiyJ5apZEmOuQ6UOZnuPK5hHURLb54dnXVx1w6XGMD
	RV33ZYE6kC99idOp/CXnk8OATtbj6RfeYFuiKjjC/JV59S3BXwxoPqeVEgc9+vCytklxMR
	fV/2ZdAD8FjCLVmar4eP6yjiQYBhRv0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Hao Li <haolee.swjtu@gmail.com>, 
	akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	tim.c.chen@intel.com, yu.c.chen@intel.com
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <n3xsvtgidf65f62x3mwgcoxnglflzozxpxjhtvawmvoljo3t6o@kahjwxud5aqf>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
 <aWi9nAbIkTfYFoMM@intel.com>
 <3foece42fc3wj3wgcnibi7cn2be73ancyjgrzdqfjeqvjtwkhj@lzqd572wfpvz>
 <aWoB0/RxDZeK6LU0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWoB0/RxDZeK6LU0@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE79F180004
X-Stat-Signature: sk1cbw1x9owemfmre7rih9odhrxxi361
X-Rspam-User: 
X-HE-Tag: 1768554599-851900
X-HE-Meta: U2FsdGVkX18UYSHwxALQLJ4IGOyJDw4gGAZxwm8vPM+Kej3UPMFg8CJGtoZPKMTan37qIFDetUBoGkDs4XPUaj7Xm/n90qGwieIlu7S1tuMF8WeSepHCnuBb6EZa5hgB0Bn5m4gN0TAv3dyZjuoI8Obz+e9gTEyy2/TmPzTQcrJEIFBFtPRl1lBmRbawceAKRfb8pUiSb8rlk8+Ybj2koQoCEvQ8jZE4GNUwzx3B4BLqLGH9SenGCXh5RYSsVrUWfoQDW6vZOHHhphFUesNVNl4GNbtWBkau1f9XJ/Rf13u2lphGo23a1H/O2iAnxw0EZt10eOK4Gc2g95Q21AbNH4k99zqN9p+PPX7mbIYqTMlSr48947gaefL0RjWC8jnqieh79TGN7oGGQQhdYCQQ4FpRTlJUapKBWnArppnkrDwapqXI0XmqKdDXIm30afo0+n/8F3DD0QBIX+YmwRoicycenwB1tYsN9ugSvYr0bPn0ot5/l+sr4ZHXB/UGzwN/k6wXY6jOUTp3piSoIhBcVU6tkOMcO+JNrKgHN427zUEEHW4WfI21ZFBHYWrHAjXOM758zG6DxaxAdt8eLWhlQFnQ0dUdarnxT2RcJsMJqZUZaUNte5Ag1Qs6D4jmip1BdjVgFrTFklLQp76WCxFIVg9ReOGUPfoMtNAPp7AH95mdNOR4AfG/Py0g7jS11gP4+mMWFaSahxsHuSDr71UKA02yeGb1ia6z0ASr4kuRIe5z9ASNlb7xYWOp1+dulsLYGSJaqymewRw1dEki5o9jOkrWl14Xbsjg1EluFz4WVHg4tcBSuhjjv7WiW0VOsg9kdOd+mU1HHEH1CmNH+bb5Ps1Mf0OnF5J+HGvdcLjWtZ+ZzIUH6SCIO03K7anQf8r4VF841mu/FL3LA9QiWiBN5euM7le9R8HdMcdlGPN/tUaWwiZyQFR60NbxHvYdbho9FvsPUEDr9MLktCFgIwj
 cN6pSVPt
 AW/fOC/F2UUcrkLV2Dw/Sq3W/trFJCXApE2Lmk1r9P60BYpFOoUc460ViUhUaATeRfv+xanbdsFJfd8N1WI5Rmd+lE+vcae4vkjPcj3mEJSW2BZpVT79ztFwAGl2eHf9aV/52orRxKYFFwNtaU8GSOzAwobV38y1KS7fe+AYyfM3iyei6eEeIPT0pZDbkU7o4slqB7qrdMlIMEuIMW/+S1qMNqCO/SclC88HTei5maUGjIq1ydTNyno2zHayq3XUDggNBGUlVq0TAf3KYyk7dBjJA2NWTsnt3fyjntfLJ+wRG2u5AkuvueA8QiqDQ6L/V/LawSUIGURGyoYQNYYEgksXgryO3wQuubMZQpDVWDYbUr3VBh1Q/Nj/h6ghmNUsTH3BeWX1at3FBVeY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 05:16:03PM +0800, Zhao Liu wrote:
> > I'd like to dig a bit deeper to confirm whether the "256 tasks" result is truly
> > a regression.
> 
> The "256" seems align closely with the NUMA topology on my machine, so
> I'm unsure how it will perform on other machines.

Got it. Thanks, in any case, I'll try to reproduce it first.
> 
> > Could you please share the original full report, or let me know
> > which test case under will-it-scale/ you used?
> 
> I mainly followed Suneeth's steps [*]:
> 
> 1) git clone https://github.com/antonblanchard/will-it-scale.git
> 2) git clone https://github.com/intel/lkp-tests.git
> 3) cd will-it-scale && git apply 
> lkp-tests/programs/will-it-scale/pkg/will-it-scale.patch
> 4) make
> 5) python3 runtest.py mmap2 25 process 0 0 1 8 64 128 192 256
> 
> [*]: https://lore.kernel.org/all/262c742f-dc0c-4adc-b23c-047cd3298a5e@amd.com/

Thanks!

> 
> Sine the raw perf.data files are too big to be blocked, if you need to
> see any specific part of the content, I can paste the info for you.
> 
> Regards,
> Zhao
> 

