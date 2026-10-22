Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F71606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=HskMovkQ
Received: by kanga.kvack.org (Postfix)
	id C0A866B0852; Wed, 21 Oct 2026 22:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA286B0854; Wed, 21 Oct 2026 22:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0836B0855; Wed, 21 Oct 2026 22:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA6D6B0852
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:45:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F0F61A058F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:45:21 +0000 (UTC)
X-FDA: 85348720842.30.ABBF67C
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 46F641C0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:45:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=HskMovkQ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792637119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gR6R2AHc7gBb5wkqmemqR+xmiUCYbQP36zxK6dFbSqw=;
	b=PaH5raQjZZ/+HcO8MSPrbqAtOmdQAmlwsLtmmk8QyCMuEmY6LFjjM8LCuXfi+6azTyazrZ
	TT2QcdyBZSDoOd8AUcCSHPgeq7vnpthM0R9lYZ3RTT9kUOl3NsomMeDhNjlLmcG2qYopne
	1k758j6Ov3o9ydc46PTxnyMaC2F4vqA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=HskMovkQ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792637119;
	b=uXzNVc6zc+xlN1C/5lurqETSwtqIQp3vYAU0vdSWYvLlT4G62RELzsccDrEjHNXJG7+Eme
	leHdyHwuybmQAcZqS3prR3zagUYkaIjOO9XIbK7YuIadGu6LbjAL622LC4hBqRUXlfFzCT
	mEv5CDGQv5qdDkGxDTPGhE9OowMjoXo=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36681e85e87so2888185eec.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792637118; x=1793241918; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gR6R2AHc7gBb5wkqmemqR+xmiUCYbQP36zxK6dFbSqw=;
        b=HskMovkQ6K8x1nesJzgT/6zfrjAJyEcfGrB+knZOPKVhFXEQCgH4KbX5FOxU0F5E/b
         rV6mHbxCeWjZRxWNgwVn57UlOi3G3DHKQlThR3YfF3vmS/JkGGYL2NxZ1q6xfaSEAjcd
         yCJG6a/XtnFJkFWg3Y7TJO+hj17NYGQkBmRT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792637118; x=1793241918;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gR6R2AHc7gBb5wkqmemqR+xmiUCYbQP36zxK6dFbSqw=;
        b=e9oFZJ2xarM/IMUW0RvLmISu7MkoICkPoexNvU9GCXtqtyLCiri57WAcprQZs34SQA
         YN0LkUR+hyo6KeE3YCGFoj0OB875BLOXdQ8CWxL/BESPdf/by8mhh+rWLJMm4XbjJgHS
         U6eRNt9lWwFPsyXLJIXOBWvX1m3EM3Y033l1+BhRvms2dP+owdMWfiYp38jLxSgX8uWQ
         FpfhWNNZiT+HWPR6KnxkQzCH2UGDxGxOTdTUDB6KCHKJ7m+AQnfCc4vJXJYFsMAn8vcs
         2nuLHRpFIpmelkXwhCoSIW1cx1cK+KVSPDna/6yxlfIjrvoCv/xLqGKmoOwe5hWX3bwp
         d39A==
X-Forwarded-Encrypted: i=1; AKwUvBz4e/clmKv10f4jc5sxlTiv9jcpn4sPOQelokDqxk9iPHvMC9xf6tBTiZlhgj72+J4FSqOLjhZ5Aw==@kvack.org
X-Gm-Message-State: AFq9FYIPQ6Ip8aeL4Eq/nPSJNWTV04sFNugAefqnFEmg8JAI6ngdn67H
	idL4/BmEj87IjSPMXV+wmil60aBuX2mbc/CDwdE+WmNsZ2ytLdtl/U3VhFzfouYB/g==
X-Gm-Gg: AYBFou3MwKuLb7GojaQ53k0ecxaxVbkys8l9w7atKnV+5KaS4jLrXEWRtMCgx1/rtSA
	pESvDbq+AQANGeIEG32UzqUV3hkNSUm89/+vJ7W76HPs56W1EXWR3gdJhpZ26Hje+cx0GuGT/x1
	QBmjFr3yiM6NCwRnH8R0lLao5aPtM7SlvN3T8aPotNVc8YnWUCgd7E3fl3Ln3JRG1FPAI2NSQDd
	YMC9BPe9uFj7U2Dxivu2nNnfq3yKeVBHR9nLMhF+9jAP8Kz9UcQD6i7HrE6zcNC6cnsgB4iSOlA
	4R6UOYMN+VsU3kpDCufkwdDhsSsTxLY430FgAL23d9PawcuitWjTvDY0NPFZE4SQyxhN1gr25Zi
	CCiiPX956rmY2DHJ/KaHDl6d2b5XpWCAEwpm36s+BHvuib34CIrwBBzf0RMaKv24CGQ80zpdwHW
	dRvy6hqkghWh/kxowfLwbdhH8lEd403cBA9HnOCt/ZtNaGDUmyZv0E1q7/pBu0GQCULRvnOBQIE
	l6vPq8vPD3t4WvfXsfKG6FlKOlaXo80N9zkc0VOR0I9qCedGFIiIgEaQ5ZnVSXiJqb4OlgDG2hX
	UUJdDQvvP5O9QgLOOO/j
X-Received: by 2002:a05:7300:d0a:b0:361:7ab9:479d with SMTP id 5a478bee46e88-3674e8400femr7484266eec.27.1792637118082;
        Wed, 21 Oct 2026 19:45:18 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:5145:5add:2df6:4671])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367412b24e3sm10388672eec.19.2026.10.21.19.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:45:16 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:45:12 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Martin Leitner-Ankerl <martin.ankerl@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] seqlz: a compressor for zram, between lz4 and zstd
Message-ID: <atl35k5lvs34BIej@google.com>
References: <CAAFOosa2WLf--T17cujJu5CUsN12NNjgTitOvno2LY7jAr1gfw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFOosa2WLf--T17cujJu5CUsN12NNjgTitOvno2LY7jAr1gfw@mail.gmail.com>
X-Rspamd-Queue-Id: 46F641C0009
X-Stat-Signature: m77xsjgphnw47zorp1ghkhfi9rceygr4
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792637119-594399
X-HE-Meta: U2FsdGVkX1900CxLKBRbgcjZ+YwCRCc4Az6cRGxE/aYJgkUWop+7RRKjxnmuDVViP+mZA9ZPe5IjxrLpvGK99J/rnqIsOG8jFPyWDFZDSGsOruVO+K4QYq1XCgsGOZI9o3fGlS2P2TyXTDbejJJJ1CcaLu0qEXD1wpipRe0nIRfxsDqB/KhoKI78TpV3guPbB1CJl3+HkvwqSDoFEgvcSpMON8pa+e7xpU+KeKEVyqPEF8pfCVUVsv+KpLL3RvYcceCpUFQF/YgGeIs1vGYmttvkZQT1EHOXki2IQsfyhDOnlx9qn/Du/5cxp2B5PJkpms0Sd8w+2UzD4HB8Iroi328H0oAVsycr+DIxwpKSP/HGWFQmQ7/qeIns4VKXSq7dQ0yUXTS4O8oNrXBINqutOwasBn08a2HQ8AHB/27Tb3PnjNXC7PWvxLpnBn3FWryZdJ85q+/Xy69pkOSNexGcKiNvW5ot0LkIsHjDMViUPBzxmNqABUV6nUQCBp3jnFBySbk1SRJtP6HhO+YQkq8ON35souyfNZc6tp900t+hKCpP/f+SPosnRCb25cpbpF4AzBqV66kjd9Jx4GGTyc79DSYunvmPbuNnsALDefeslDH8Q81obgZWgfor7mqgosyGyOydSBZ+kCtLPv3A+Is/JPf7co+tTBei47sEoGMr5/QVmshoH+hqnq56VAzJDvQnLHS2CSpRY7XnhUJarxee77dx3aqwsND/Ws+xxBjjKsCB3CQLIhwPbh7HOpjOOxtxYdLQo/3Pu97ymowBrSHHDJf6lwqiMzjUXySkdNX2xmHiluo+5WhStc4vQ9rkRGLCYixhmybJqVnkBVnL/9O+6DFWdsxLIWK7IxOZu3CRP67+sE/WSpLoVlIiSmKJat5QyDV3p3Qd/SAfS23pJekxg6qWfNGImO+D/8eRlZOU2V+tqGJynFr6hL5hNrrghPBBcqEmTYHdsIWUvYyLdVk
 0u760oUN
 tOSUTPte7N865pH2K9Hg5d1/hMZFDeivBeljZ0VAItHSB9g/iE75j4UfdLprFHwB2+4JV//Z7DN6HtHKqYEBxe5jrUQvRKclda8gp2cjOMxvasEAAn2jxZv3NdLc1c6Wb5R4IpmilwwkFeouj4HvFDOEfItZvzhj6Ic70F/d8jvGkX/nXosvyp66yzPKRngjONIgGgoKMiA+YMEuiColHXO2WYkKXf8hle8o80ynVyHjtTua4UXE7qTrVqc7XFfsNSSPa/2Y1nufJkA0jlSpU06ARhB6MiAJs+UQsTYvhF3lGUJYO95gmaOzIoyuwYHMr2J61TuhaEcN081idAhmy0Ww+gWAbbNfWzEb7Bwrzbc4N7+anUUBAn5vAqDCanl1I9cfd0KluAZ2jYV3d45Px8yfnV6xMqVyKrZruA8VQTWR2w2f1cR8Qlat53eWUZZ5JCrGWFOb7z106K7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, sorry for the delay.

On (26/10/09 16:21), Martin Leitner-Ankerl wrote:
> Hi Sergey, Minchan,
> 
> I wrote a compressor only for zram's pages, as a personal project of
> mine. Before I send patches I'd like to know if you would consider a new
> algorithm for zram at all. Much of the code was written with an AI
> coding assistant, with me deciding the design and checking the results.

If this lands in lib/ (like the rest of compression libraries) then
sure we can use it in zram (we are currently not on a path to acomp).
But if the plan is to have it as zram's "private" comrpessor, then
I'm afraid I'm not equipped to make a decision on that.

