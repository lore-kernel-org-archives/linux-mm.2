Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E17606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 00:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F14o7V9N
Received: by kanga.kvack.org (Postfix)
	id CE4EC6B05B4; Fri, 27 Nov 2026 19:10:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC086B05B6; Fri, 27 Nov 2026 19:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9D36B05B7; Fri, 27 Nov 2026 19:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9189E6B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:10:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DDE2C0579
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:10:53 +0000 (UTC)
X-FDA: 85482597186.19.73B66BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3385E20010
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:10:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F14o7V9N;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795824651;
	b=186/MPtd3WKmhzL7GWHjUSMfD7VTH+9Lc07/aX+hHbYX0FZY50e9A+A5IKaRLoyjueNSVf
	Q+pR37Os2mkuKHPmp/joEeDGMAat33pa8Qu8gUMD22TEIdFeRvF+8I2QyQRGO5cT664JIi
	vUEgruPW7I8vozRcqPOTSxYGdSKPr0E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795824651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BvyT47FdIKjERUDRzZ5b+QRgsVWY90UprMU9CgmekA=;
	b=pBQM8bwIh0dTm4C39VA3F/TJLX9rf7ZZxhYvd31XFG5HXWH6AzeRwG95Xi7l2UvF9Eu+u+
	e+p8LOzq5VGeKS7tVGbv0OQoZcQTNhKDdao5X993kYm3rFYLAeGQj8FfYyL73uHQqQbPdO
	7l9j/NC71oYws9JZ8BT1/MwCkf0H+84=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F14o7V9N;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 08787446B4;
	Sat, 28 Nov 2026 00:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4551F00893;
	Sat, 28 Nov 2026 00:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795824649;
	bh=1BvyT47FdIKjERUDRzZ5b+QRgsVWY90UprMU9CgmekA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=F14o7V9Nw6o7HYM1FszfHwlRlHBtV2pppcFVBHzE4956/TBu5xhX0iFpuf7n5xIyO
	 zPgeTOOE8frCjqkNoJrgaWyAfldXk9gW13yrvEZ4jb0m7F7Tx66MqTpqkL+Ve8dr46
	 GuHWn4emN7tvgbe7LybIs8LjNZeYV/iYeENFaTyg=
Date: Fri, 27 Nov 2026 16:10:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yifan Feng <evanfengff@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Greg Thelen
 <gthelen@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: reset the memory policy on remount with
 mpol=default
Message-Id: <20261127161049.aa45a628196a82f90021b0f0@linux-foundation.org>
In-Reply-To: <20261127230015.30733-1-evanfengff@gmail.com>
References: <20261127230015.30733-1-evanfengff@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3385E20010
X-Stat-Signature: bwwry7zpw7uexaa5gg877odwhxu19gkt
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795824651-635226
X-HE-Meta: U2FsdGVkX19jQEh5vSC/fHDIZ2na+17wPVlelGgqa0/WAiuXEYIiXMYakwL1WPnKabMkzord/vK7G72za0tF38vrrGvmUbqveKefA3io+XIAjD41JNkB+g23AD3I/k6VTWuXyEa0zpL1dKnHkmISFx6mp7l0WoFEw024OBHXv12unkn5ChNEg9ujfeShNEyejbiXS5UFvva969WPsP/jTdnrrWGn+4Woi2uQF/Veye/vyuCm0yeI4K212DZcNibi+nZOUvWMbwJGU7jBk6nRvB9FeuaACzwC2DdRKmbgdTuaqLx88/0DbXPtT+9Zp9wp5seoyWGRHcBScacuPhfDBW+dyJgcjdmsCLXu8gZUbGWvOuJIoF/eq8EKyGBj0l4TQ/1BBQFhitHxam2YSky7QfJlG8K1oV8y6mSy/tZTwyByPacskRui+sI99Vxa+XhtrxR96JC7kpZPguTftWiLbZr6clIijwgbO4YFtDK8TQPsC8l/9wuUVe3NuvA+kTftGKlhvGQEuMSpAqdWjrtJRwc+bqh+wVoTel5tnXGRGGv22pfIQvxMjDxLmSVVIhBM9cVyxO5UdkhUk3mC3ByfIgnphRSCAuwuLwFw/Dus1fq0TxAS151e5PjMaPK4tX37rx4Ks87MAWU+nJAFB26bmbCSRZIxugQOURA2oE6ISFJox28370fbaQx+iZ9AFWpPDGMdjyZiWCT1s6CLrrPsdyC7XLtse6O0DwZstFFu2lQfP0dW/08dp8Psl5vP+UjCnzM/Oqy9kJ5+bT2zWzThrr44m+ppBdLU6JxOMMscXMw81c7/QOzN/R/sS87CnrAZK/Gdj27roZUQr28oDUK5Nabp6fNB0vKmQjH/ZjwuGDjeH1Oi2JDw/6zzY0ffg0SVhaW4QVyPgbqJWVDf+csqAD9GKFEGEf9MQZy2V0zaXmUIhWh1v3Rqo07Cd79NAzAJON+0ecZQ3MqjyREkWpj
 6zwxALw8
 Z4JLVOdIjD0q7fuWsn5vwiZBlyk0APJZxQpQ3MZwgGZhMZaBssP6lk3t3fnB2XmQH8g+HiciZ4AC0qcfcwe84tx62Ab6FoTAGzI6m89S0T4rHU6prfUgKIIy3mlpMJnry9cXn1b6d9h11vOW8DFk1RnIjACPRf0HLkPeSrTXT1pJ941BlQJL+m9NXZSj98yYat05LKfJdqTiiL2Ov9m+7ZRXIVYfzI5ChUZ57qpQcvzclVQjd37QtZ1GuV+b4vNFTwZvlh5iueTLmLPlnS0qWhdSYurAc1lMsVKUTlArHneEHchP+eaJFj606RAs497UHUp+zhCZtcH1eLZcnT3vvGnB4f6TgwxLH2LHExdPlD7zXBr+GghzvuM9i4pHec9frBi53WdM/Uw4ZswjORQ5gvdjuC7u5n8czDReCIqZ3ZH44zkaL8xGNTuEdrcdgTpiktEZ4OLpPFcWAuWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 27 Nov 2026 15:00:15 -0800 Yifan Feng <evanfengff@gmail.com> wrote:

> mpol_parse_str() returns a NULL policy for "default", and
> shmem_reconfigure() takes a NULL ctx->mpol to mean that no mpol option
> was given.  So a remount with mpol=default succeeds but keeps the old
> policy:
> 
>   # mount -t tmpfs -o mpol=bind:1 none /mnt
>   # mount -o remount,mpol=default /mnt
>   # grep /mnt /proc/mounts
>   none /mnt tmpfs rw,relatime,mpol=bind:1 0 0
> 
> Record that an mpol option was parsed, and replace the policy whenever
> one was.

Oh.

So aiui, remounting with mpol=default "succeeds", but new file
policies still get the old mempolicy instead of using the "process
allocation policy"?

hp2:/usr/src/mm> egrep -r "mempolicy|mpol" tools/testing/selftests/mm
tools/testing/selftests/mm/mkdirty.c:#include <linux/mempolicy.h>
hp2:/usr/src/mm> 

Oh.

> Fixes: 5f00110f7273 ("tmpfs: fix use-after-free of mempolicy object")

+cc:stable.  Thanks.

