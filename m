Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02AC8C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 16:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E671A6B037F; Sat, 15 Aug 2026 12:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18416B07DD; Sat, 15 Aug 2026 12:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57976B07DF; Sat, 15 Aug 2026 12:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF3046B037F
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 12:06:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 380244042F
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 16:06:04 +0000 (UTC)
X-FDA: 85103980248.14.8A844D8
Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6A5E6180009
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 16:06:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=CcePYo4R;
	spf=pass (imf24.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786809962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=5WQm4FOrSKWLlpnxV/luviAmOHGf4ebZ2NYMpvK6LrU=;
	b=Lrsi4eHhCKB42/So/0q19HHxtPpYfWrnnGsQ3dfBxhMCojeD/0Lx2Pl8uKlGSVWbCBvETJ
	xsPqf3U8mI5QKTrDxOG9DU87LcN8eoEJQOT6235wePuxugevvjNAUF6trL03yZst6YP3Km
	8KyhTdu2FbuaUmeNSI1xuESfveaa8q0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=CcePYo4R;
	spf=pass (imf24.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786809962;
	b=J4V8NvyHDvVe/j12hjd5WBgDYqtPYAMH4QxVLN/TxHruXE/82aOea4MfDAasVuEpSv0rVf
	uZVi6Zb7JPckK77Y4Rw7JwKdOUX0JhcQ6/1bTUHOCAlrQTnsmJ7t7t4lqFxg6MlgWZOYqo
	od1UV3qPvSh4g97vjugAHCPMQj0T5vU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786809960;
	bh=5WQm4FOrSKWLlpnxV/luviAmOHGf4ebZ2NYMpvK6LrU=;
	h=Date:From:To:CC:Subject:In-Reply-To:From;
	b=CcePYo4RSbzzdbeEAv7fwt9PVJLoZVRTCNV37C7615ZhE8ZQbjvvTGcR10vdpStJM
	 d2i0ajFa3ztqTRcLTYQguz/2w9H2xHWuHgpIwYT6ZGTuceJ4O4OxZdeUD+eVeypMWv
	 GD+aHVsPkx7LhECOXmJrcUS5XIkUOW2CWYwq25Nk=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4hMkV06bzlz10s3;
	Sat, 15 Aug 2026 16:06:00 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4hMkV03P6Vz10qy;
	Sat, 15 Aug 2026 16:06:00 +0000 (UTC)
Date: Sat, 15 Aug 2026 17:05:59 +0100
From: Bradley Morgan <include@grrlz.net>
To: joel.granados@kernel.org
CC: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com,
 kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 shijianlin11@foxmail.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com
Subject: Re: [PATCH v2 4/4] sysctl: Add 0013 to test partially updated vectors
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-4-9df50d26e477@kernel.org>
Message-ID: <1EF80864-F479-44F2-8CD7-28383515F483@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pwiq733n5uzwtqhquiuxh3z31t5eafnh
X-Rspamd-Queue-Id: 6A5E6180009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786809962-517674
X-HE-Meta: U2FsdGVkX1+QUgjfgOV/vQn/OdeMzzQQPvmCD0k+gFCadyV8pZdPc0xH221T3VF4o0J16aQTAaOXv0F0x+fZHFd9HNVDE+Z/HehnWhXw6Jd6VGXhYbPUuuK2w/VHXaz9aMMpQvFn0+1dqsrQV8M2cvkdcv/0EAm9WNzsxoaB8ZWvi5l4pGh+shKsGHjvbrmV85yU67KzMwAlGMlhl9fBAFR6LAHCa2NcWOvlXQfMHzYHUqMPfTPm9S9QzO3uP9osvUc7oiP8IH74L9DKHTd5ixa/fsoMWSBFri6JCejB0BhU+ER8OT7/UrLwxHP4Fp/rEVfLfQM3wcEHHU97BsFDrJfnwE+GK79EQ73TLI4AYuls50gIVNyzbBWJHR6gq7K34OiNHAXzpJsQ6JWnq3fDplIDBhqQ4sSKMp4k+zP1KBN4/D3N4gtbKXU2hrItNxlORx5cZtyX6yvX5in+P0uo10RXqVF7Ov44i9bf4Iecl/CWRtSe8RkUibfQ3Sy4aS4TNQWDup47cw8QKzYbx07JrBYzdXUIzcdtCP4z/0S6DIFAak67P0F2r7Wc2gAm7EexeeyXT72Pf8INg+dosj8OTKgzr4DTGtfyPY+F1B7vA2vwXE64p1QaUw+9FF9F/yUUF7lFyQX+Pf6S8u9LKLOAkNKc8oDxRzan5fUIGOitcrkanvwE8K2vCvlw7xNZsSa9pOuvGqYiOWZjsTEw/QhuNvtJ4E+Z6zENefDlpmQTiYDq0cyBbdGNFZUr58yHdUpKbuX1GyA4AgyQyXtJrKPsjSSsgYvKJyOe1tfZ56oy5ge5hTXRYdK6yN2+9q9xKnkVp4Ako+r0q43XV+MrKKMbqn/4CQBamIra6BvVxrrPNft/WB58lElIlbtpBFZBbYAxDtoKyVTXR0VG/wE/7qM4Xm6R3CPQHJFfIPTnKuG1Mq752oSrL7EyH0WpLADXlr41Z0d61HPqcTeU9eXMYBU
 MNLxS+Xm
 +syk5kYNSfk/cYaYEkVY/ndpQwJa5+hOGC8hPT5hrf8UALYBC8MwZdDzwj3ZLUUYKabKSnhJWZpPNA+xrK+9X4Q3DKYj4a8sZYP/8IFDRQFwpql9g99q823m+H+mVDj1XfIF29IDofD7UDvnUSQiN+uobIWBfxcCeN3CyApt+gK0c5afbLKRWgrgIIDCiULeU8qRRRAt6JAHKgj3MyuNNWgs7CUGIKCFP3Q0/2Gtp1GU/BmOV9ARRF7cWawmyT5udtj1Sj4KAITXTS9ESQ8x9Tjyh1FJwiukGmTPPVRaSD/9aZdDaqcLzwy1YzxajQmW1B40YidIEiXaQLwozWE8SqnKc6uyeQeEmlPBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test covers the parse error, the out of range value and the
first value failing. That's the right coverage.

The shellcheck disable should say why. The test functions are only
called through the dispatch string, so shellcheck thinks they are
unreachable.

run_int_array_no_partial_update() uses spaces for its comment lines
while the code uses tabs.

reset_vals() has no case for int_0003, so sysctl_test_0013 calls it
for nothing. Drop the call or add a case for int_0003.

Nits aside, the test does what it should:

Reviewed-by: Bradley Morgan <include@grrlz.net>
Thanks!

