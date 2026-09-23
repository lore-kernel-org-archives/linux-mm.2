Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F09C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4496D6B0093; Wed, 23 Sep 2026 17:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC726B0098; Wed, 23 Sep 2026 17:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC3E6B0099; Wed, 23 Sep 2026 17:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2EC46B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:27:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 873F21A012F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:27:27 +0000 (UTC)
X-FDA: 85246313334.25.371C6CB
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf01.hostedemail.com (Postfix) with ESMTP id B2C6940009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:27:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=p+p50XSt;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790198845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcUop+HZQcR1eSCakcCGo/nA+544kosGhnj83z0mc1s=;
	b=j0UkBuCh1gvFJFrPXoxvCzXc8W5pyqVniXqIodxPKxXmADV+IIz4vExD09y0FbMAug0Hag
	bBRMFPnQlCBtA1M0IMLbTybndIqL6I7gWfZALZ+I9yD1KC8sUhSVqMkupk9Dzh2F1f0Yra
	VLkVqQlrqJKx4aecXd1Ew+xYImXD89I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=p+p50XSt;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790198845;
	b=YMP/LgV0si5ltKsnypHjclNq6Xj/e8fKv6xgh7Ocf+mQKkQXYOTZKLJqRDCN9ar4scXeNE
	q3l6HiXMH/qzriHvLMrz/Lddutb4NlOroc5TEEANEfeckNcpXbxMx4I8MLEq4fGMnP6LWi
	GTPnU+3q/5zW0WEHTHPQg4MpJi4NrJI=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb766bfd8so12323881cf.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790198845; x=1790803645; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PcUop+HZQcR1eSCakcCGo/nA+544kosGhnj83z0mc1s=;
        b=p+p50XSt0kakjOJkqsTnrGMb2bVEDApDEJJ+MDSDZd6FhJER+alLksVgFcq4VoKl9A
         V2AiAbapzfA7NVq0B0hV6PSyvf2outwGXaS14Zh3jc06JtavsirW94bI29urh87JWgjG
         vuSBF6qOWKfIEfTcdnmB9gjC0fC6pYtYGF70ubMIPHLBW7QInycI5uUltFi6eZy4647a
         TzJ18sSvnJRuL4XAvr/adX6KP+LN4n2M2W3+z5jFpKLkh4ihPN6yzlXYQyqDDA36Bij+
         Eixjo+mDE5IF3qHLB8F1phJllGWWnM52gF/Ll7EyHLRxcVzACD4Y1wio2Bp4C+sscGPk
         BjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790198845; x=1790803645;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PcUop+HZQcR1eSCakcCGo/nA+544kosGhnj83z0mc1s=;
        b=zfioglQqE0oef0v60ssUA4Ceii4I9hxfgrDVojLQiq6oo1bfh+sBRGowaqajYPKIzC
         Sed1i7bCQnIheC+2c+AgY1n/PD8/o54kc5B1TiKxOC9Qn15AD/th7BsB0YqTFDsOTtFa
         7vqXJXt7/giK/S2NZ6hNvATcSSOhb/KwJz8zdtdO/Lf7gR57SJZyTTJH0P+R8h/KZZAW
         uy1JnouoPAuMLIg5yjSDOJz8cLM+19Kc/MAuWpnTarIv9B+uIqP8VZpSHRbwR1a43hbU
         G7ajb3RMAV/Vx+FjCJs9nxzR5MBtkqBEWf5/L8/I/s2ionRGD0aOosvdf4Oj87CPe9/x
         +6jw==
X-Forwarded-Encrypted: i=1; AKwUvBzgN1AoXA+L6aiAbCe6tQTFdrUyT2423rxr1yzkUWQ39SfAxbOflABsVViWf29jDtE0p2fz+gCKCw==@kvack.org
X-Gm-Message-State: AFuF++kZRz1Fjjrsvsl+j2Kq8/ANUX4oTbRpvucDNBVaUVUOEp0+I6EO
	XdKjadvZQaMdciYNUkyiz3pEJRLv2hD2/bhxoVlFkvoCZSyHbHvw/kG0isfD/C4aad4=
X-Gm-Gg: AYBFou3owFl9hU8E+xQXB7m8lmZ9GoBsxktx/y0PdpE5BayTAUEITPzt6rgwsrec68O
	DCfNeibrUR/Y24oBSJYtxr4TFIQETJdLyVpNqhiALLFOaU5N/OKe/eIqwSOhqP6mQiXLsj+t1bN
	hbZLoxEVvdBBQiTZc9HKKd8W5OznoaPw7hq7AZig1Xxyuh6bqcOXGhGENJw/wzyPbFJ5Qs7+Gl7
	gSsb+Bo88DgWUzvSYSNBXJiXetjgBLtlbetqVJvy7D8JnN9bmyaczpYLtHPjm+NcXvIYapNNVFb
	RCfTL47Ino1AYZXBu23AVQdr3VpLdTuLB0u367XFShQwOSeUpDqdX04dOxOKO8BFhQCskGYZP52
	DHt77CRdKzX9UJ4Du9ux7LlM1UvdjkCyxD+jf4B1xajf10Y3ZY8XZ5pRERFB35RP0GuHKhN5sFD
	fM60BxI3SakYJMdxy3FDQPOWboSt96DuCr6XDFx7BdEzIn4y0QhTo4hY01ma8zT9m9Tu1lrphgW
	t2WwTHqYENxIGBK4Mv8WQfN3phJX2Xhi4A9Cez/ABEluizoQiY08Non
X-Received: by 2002:a05:620a:1724:b0:939:9b1c:ea4c with SMTP id af79cd13be357-93c3470cfd4mr78173685a.28.1790198843910;
        Wed, 23 Sep 2026 14:27:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9141e27b5c3sm3228816d6.30.2026.09.23.14.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:27:23 -0700 (PDT)
Date: Wed, 23 Sep 2026 17:27:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Park Tae-sun <ts930@dgu.ac.kr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: fix mlock2 errno handling and false PASS
 on ENOSYS
Message-ID: <arRD62HaBCs4Svcz@gourry-fedora-PF4VCD3F>
References: <20260923-selftests-mm-mlock2-fix-v1-1-750b627854c6@dgu.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923-selftests-mm-mlock2-fix-v1-1-750b627854c6@dgu.ac.kr>
X-Rspam-User: 
X-Stat-Signature: qxs5mq97gk5tfpnazia7nf655digf3hp
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B2C6940009
X-HE-Tag: 1790198845-199199
X-HE-Meta: U2FsdGVkX1+a/dupFQJtNWp6PNvCSQr1qqg6RIUeqtLcj4s0H7KJvV8QWibUOzrUK3O/+mFs3DB7VPQf1kY5au/hEC+pJyze40ZwaXhYjQGK8EwYUIyIqNI4TIMtGJfeUDIiEdOm0g0blybfo4b3vlB8kGBnywZh9BJ45isPF0vapV8fGsM1J0AQQNTeNtGlu3zUtX+L6UFk3uEfxchaXRpzlqrPVNdMOY6pUyB3IKZ+fZLNsTfF5EoeCQ/Rx4YYgtebLDEt1WVX5ajgGxQwMahrg3eGFnvygc5KH1WgOXWY9LapwRGOHgHg6kyej5+2l8queZiUd/ujggU36sPdR7fijsrr4f76hkL66jlP8MfdhKwFPSl5LTfgaSkdTWIo6rZly7xnhcUxIe/YRrYpReu2/dX+5iJpGTja0FYTUAx+2xek30hWr3seqlOk+6Lo3wJ4oTQT2Sjy/7ORIyIAYN3UwwqxaNWedEwuh1HoCsHUoNKPY7eAjyEZrcg7jmlsiLqodyLxWO1Uxaf3ulBcoFW31oUd9nFH7XBc7ZNrlgT5dxzizXo/zMKuAmrp+i7GNubx2C4tDuBAXQegEnjbP5M+sah6gT91u5gt2jj39WI8B+PeX9xfa6q5QYC+EyH/+3MopfcbZa4Oqkq/D1yvRH67iZ2YZp0H51aAQFeKvFS4QU22xLHH0dgsg8lDSQA/pdnBw+RZku7/okUqCm0peDRHATkenUJYk/Uf03au2NHbaPGHJ1z/1B4mka5t3grkGIrm2di+RCPyLUdzW/doGXbH3+nEwu7UW4xOuTO+TS5i991ZrMPhroZZVoJvl3vLtrao2yV4eEDQ9VCOUt9oG/7r4I+FJpToSalQVKJW5CGwOPO+n3LVCEkOggrxOFWbYO3BC1LcooIC4v4ZZOJ7RzceIFNHvI5SGfKM3ZC3ZQ84Ei4QdBkz8qS1NJwAdKUR61qMXvYx2uvjruxxgR8
 3OKSAo7w
 osp5wtBjtPN4WehftNpv+KJEzL23Fe44hbwIxGvuU42qLCE3p8R8veocwSCm8tDnJvVf259uIl4Jv76rQ2BiLVIdH3q2VzBoLlwKozhk0d8Sokl2f6ZgygWGswNZSr8p5quGxd1T9w4CxdQAWZebOHRkKoGYIqkmEO35LxiWIn7Qxz+KcHnmsrNQ6cOBCdQ0+LRCTIyAh6PasfpnfNq0kh7Y+2bT2vCOZfSFBZVSJRvLS9xM/QARkhOgZWLnYQcQJrKt1KS+OIlXn6emMvG7C1lXlibMhZQ8ypds3Td5vwOzrW/EEutG22dz9fZsoHs38A8wMQDpwyJFbonO1/dWRga53W+5rOGePxN2SWgeP6HM8vowDItob+2dccYdynr6h4Q24
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 06:26:48PM +0900, Park Tae-sun wrote:
> While inspecting selftests/mm syscall wrappers, I noticed that mlock2_()
> in mlock2.h handles the syscall return value differently from other
> wrappers:
> 
>     int ret = syscall(__NR_mlock2, start, len, flags);
>     if (ret) {
>         errno = ret;
>         return -1;
>     }
> 
> Commit 1ddae9d67ee1 ("selftests/mm/mlock: print error on failure")
> introduced this intending to make mlock2_() behave like libc by setting
> errno and returning -1. However, glibc syscall(2) already returns -1 on
> failure and sets positive errno. Assigning "errno = ret;" overwrites
> errno with -1.
> 
> To verify this, mlock2 was disabled in the kernel (via sys_ni_syscall) to
> return -ENOSYS. Testing revealed two interrelated defects:
> 
> 1. In the unmodified test, mlock2_() clobbered errno to -1. The check
>    "if (ret && errno == ENOSYS)" in main() was bypassed, resulting in an
>    immediate crash in the first test:
> 
>        ~ # ./mlock2-tests
>        TAP version 13
>        1..15
>        Bail out! mlock2(0): Unknown error -1
>        # Planned tests != run tests (15 != 0)
>        # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>        (exit code: 1 - FAIL)
> 
> 2. After restoring mlock2_() to directly return syscall(), errno correctly
>    retained ENOSYS (38), entering the ENOSYS check in main(). However, it
>    then called ksft_finished():
> 
>        ~ # ./mlock2-tests
>        TAP version 13
>        # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>        ~ # echo $?
>        0
> 
>    Because ksft_set_plan() had not been called yet (ksft_plan == 0) and
>    zero tests ran (ksft_pass == 0), ksft_finished() evaluated 0 == 0 as
>    success and exited with KSFT_PASS (code 0) without any TAP skip header.
> 
> Fix both issues by:
> 1. Returning the syscall() result directly in mlock2_() so that errno is
>    preserved.
> 2. Calling ksft_exit_skip() on ENOSYS so unsupported kernels report a TAP
>    skip ("1..0 # SKIP ...") and exit with KSFT_SKIP (code 4).
> 
> Verification on the mlock2-disabled kernel:
> 
>     ~ # ./mlock2-tests
>     TAP version 13
>     1..0 # SKIP mlock2() syscall is not supported
>     ~ # echo $?
>     4
> 
> Re-enabling mlock2 in the kernel confirmed all 15 tests pass cleanly:
> 
>     ~ # ./mlock2-tests
>     TAP version 13
>     1..15
>     ok 1 test_mlock_lock: Locked
>     ...
>     ok 15 test_mlockall_future_droppable: droppable memory not locked
>     # Totals: pass:15 fail:0 xfail:0 xpass:0 skip:0 error:0
>     ~ # echo $?
>     0
> 
> Fixes: 1ddae9d67ee1 ("selftests/mm/mlock: print error on failure")
> Fixes: 65c89684896d ("selftests/mm: mlock2-tests: conform test to TAP format output")
> Signed-off-by: Park Tae-sun <ts930@dgu.ac.kr>


Reviewed-by: Gregory Price <gourry@gourry.net>


