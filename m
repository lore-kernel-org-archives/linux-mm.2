Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE609CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3DEF8E001C; Tue, 11 Nov 2025 13:52:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7E48E001B; Tue, 11 Nov 2025 13:52:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04508E001C; Tue, 11 Nov 2025 13:52:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3A6A8E001B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:52:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2F17160152
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:52:04 +0000 (UTC)
X-FDA: 84099220968.30.E10502C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 220CF1A0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:52:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hJaY3/c4";
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762887123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/d8zCUQbZaRJGUvUbaOUB68Dj5a+tv8u4HUw+7Y4SuI=;
	b=05orI3nwhWm7tC7ldLuv/X3sc8hzRTV7uBw0nOh+uui/VS4GAur5MCc4pRZIfy24kc2lRn
	l2wm+v/vEbRjdbTOHcb9a+O5U/RQAQYY1YyzokeMOItsmL3fip+BK1XdNBXtdysrNh1Tkf
	l3L8dsZFGGUq9Yn0tvv9oSo6BSWHko8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hJaY3/c4";
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762887123; a=rsa-sha256;
	cv=none;
	b=L+vUjYf5NK8gQJvl7zxo4GnnVLd9Zw7+LowmVmtYizs9Jx2u4MVExKVP8m5LjGJbTOM8zC
	k6vAScQqn/XDROnNCpeBie4foRmXH+Jq+6yna1OzuctKZA4/c9VpFK9H/AAM3SmavWbEJl
	wxczUj4p91dgoCuptjKvSRHjP9VGAfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 199EF43F21;
	Tue, 11 Nov 2025 18:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDF5C2BC86;
	Tue, 11 Nov 2025 18:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762887121;
	bh=wKqIegUi0DiJka0SaYsAR82k/GO5oanlw/ZrqT+rYI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hJaY3/c4Hz0IicNy9MoLgjQ72hFd73LWM4TMqP63GTIdB5LtGou1hjNDUDGl+e7zD
	 AT6j1WygoT+efMp5+V2fSzW03Cm+yUOQUbt42/hpdA2H4tZckgvVxWisb1xdKNSWal
	 f/bPa+DZO92VdcbG49H/eXwNxeehNe6TnMde639i1q9Un8Jq0i+x5usTEbtkDlYX/S
	 Pb1PB14S2v+U/XSQt8C6/C+niFgrViOBm/icjKuwBROUgkWHgCALRlB6UybWi9e4GJ
	 fXObnVEmiXEAFwUpr/hOzM6bwlPNmfXhiDxOGdi/z40pF6S6E/XfkVvN4u02zuI/yo
	 mkVtoSvrX+DQA==
Date: Tue, 11 Nov 2025 08:52:00 -1000
From: Tejun Heo <tj@kernel.org>
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: mkoutny@suse.com, akpm@linux-foundation.org, cgroups@vger.kernel.org,
	corbet@lwn.net, hannes@cmpxchg.org, jack@suse.cz,
	joel.granados@kernel.org, kyle.meyer@hpe.com, lance.yang@linux.dev,
	laoar.shao@gmail.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	mclapinski@google.com, mhocko@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
Message-ID: <aROF0BXEJtCM7c12@slm.duckdns.org>
References: <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
 <20251111061343.71045-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111061343.71045-1-leon.huangfu@shopee.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 220CF1A0003
X-Stat-Signature: n3mx7bqjota17jxp9noaoexumzdzc6ho
X-Rspam-User: 
X-HE-Tag: 1762887122-765161
X-HE-Meta: U2FsdGVkX19k6G0MvnUuWPdwQyAfUE7zo1JdW1eMY8j8BLtXSJ4JFSkagAtEaf0fsMIO1LKXQ3wG9oJDEOCxE2gVc6JUv4CkPA6hPDGQ0HwcDJ52QoiJtbjwgISFW6RgUKWYC6lE+PYsP88a1SFP57OSSowlNnyNSXvrMZRjVGgJbqU8UC5dBsmA2BYXLIuLOTLGuNnLcN4OHnXk/As573x/QpsmDf7Ad3WhOqV9EMOc1VcR1noUw9i9bAYuwMCPnYA8AZeEXXRRyOrnU7Ez2l403+r9eNuliv70SNRklw2+EG0BLFVZH8CdKA/a2MWMThUBztzrdAj0IOAGg7igeSAv81YxSkezp8+8G1aDZScBd7FuFd5RmKJB4ZPLrhhNr6aujlXZ508Pke6MM7wsIUBzVE7QxBoT0UJ8Y8odl88bsAkBPQKxq2MZwn6Ulk1YpXFDwTBsOIpInujS1DDzvnEvGU3Z7jKb17I7YeC3o39HFfM3nt9et4CJB6ejk387GtrcAfgd6oFu3ivxAOnq0gRFQCONsZqYY9kvm8hKpr4HfUAbcJDRA1wD6KEFK4ITCRE9zGEczC/Qiu6jympRfW5DURvUJpiGG8fpzuJsmXMoyKikXmDYio2l3aKg92xOWOee/xwUBPEYjn6wq1nT01LXprQIo4s99eAoAzB16AFuZHf8MeGW2cqjbgIVXEs5u425a2Cc/Wru2OsGTHfJ/hLnlV+jgNxzFJlK5Ig354NyKhppC8/3ftI3/AysZOi60bVYhZy/d0HA82nRPWTNAo9wbTeTEcDnHsGg6Rw13c4H4tJPF3W20OJbdVCgnOosFcN24knZ2QjAumUIS96vI+3SDS5+JQnlLVM3yto/HLxEf6CU+wYp/6jTfHnnvFf/M5M5Q+oHj1YbAa0H8apLIPoVGQl46QEroFZoZqMeRK+yOJ/5tnBaKxgYT/uSRNtyU85aVGIBxVu6zzVTU4z
 hqMQgXFX
 lgLyBkVcGZQXG/rIHcVjF8vHZZSDyRzqLWy967QGK1+5CsxECo1RezTncR8RIj5rQ7jQ1Zb5GiTTwcYjDqC9NYEYrDYFAAvLz3XakWYh8wTjMHxtzFOn/cxiMn/2cJwKKKtwK5k6KREtbIVLHlUzbB0jxcFPHFnUJStnt49BKljwrVDb4qUTda01CN7d2n/Ar6gI4qxICNbWp+jVvDFHcnqPHGU0YPAu6gHAdTNklvB/6MvkhkhUYQQYdCcMGLJTUiTLhkY/+cMKk19egsLuowEsfSHL87cTjgoc3jllRWMgOmtYZ+6rHSatjFHt78+Dr3yi9EnkSU9zFOPg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 02:13:42PM +0800, Leon Huang Fu wrote:
> We are going to run kernels on 224/256 cores machines, and the flush threshold
> is 16384 on a 256-core machine. That means we will have stale statistics often,
> and we will need a way to improve the stats accuracy.

The thing is that these machines are already common and going to be more and
more common. These are cases that aren't all that special, so I really hope
this could be solved in a more generic manner.

Thanks.

-- 
tejun

