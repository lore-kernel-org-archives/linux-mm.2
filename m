Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB20C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 05:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707916B0093; Mon, 10 Aug 2026 01:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8C36B0095; Mon, 10 Aug 2026 01:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7166B0096; Mon, 10 Aug 2026 01:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34E586B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:44:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B486F12068D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:44:02 +0000 (UTC)
X-FDA: 85084268724.08.65C5891
Received: from out-189.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf12.hostedemail.com (Postfix) with ESMTP id B32B240002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:44:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GWzAyzsx;
	spf=pass (imf12.hostedemail.com: domain of hongfu.li@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786340641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SO9O2x/1heZGfWI79kiI1MjVfL/S/CCSC4z28A4xhNE=;
	b=X47q0zAEMi/fXhjPKkcQzjRjL9JMiKBLSX/q3960xgLCXvBEvH9aKzPKCg+seAMFHNTWAB
	/O/xj74GEZ67dYtV8oRrKJY2DWAPxFHNhoOLnGNbsxqqEyUN+u+lgjlTuUQ/ngBZ8qcSpu
	w6pEAGS262xufQGBk3XN9AK6tFqeFqE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GWzAyzsx;
	spf=pass (imf12.hostedemail.com: domain of hongfu.li@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786340641;
	b=H+L1q2/V7k5TKHGARmGX68NCqLU+Zr0yoectgbSVFRa3s+7zeoJrYMOOc9A93muN4jDk1q
	jsBqy+oo83aVLpD5YY8k/tp7gXSf4q4Ip6DaovPQBbXndweKWpbHz0NqtNiucQ9tDlTbgW
	ZA06CiWYRZ/zRkMSE/FoFEv6iZO5+Q0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786340638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SO9O2x/1heZGfWI79kiI1MjVfL/S/CCSC4z28A4xhNE=;
	b=GWzAyzsxnA9O25inhOpor2MP5uPSYRS5xoFbf5Pgh/SBVcrR+On+egCA10gZzUj06LvIpq
	lNsWL8qGLK0RBRJCGBq0vMLTJKBviMQ+3NDBSk+XHzjkK7DAyC907W1eT6QgfJ/DBZ4qL3
	uSWhFGPuS/W9cufF3rm8Pv0MfPEIpLU=
From: Hongfu Li <hongfu.li@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	hongfu.li@linux.dev,
	lance.yang@linux.dev,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	nico.pache@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com
Subject: Re: [PATCH] selftests/mm: fix read_file() return value check
Date: Mon, 10 Aug 2026 13:43:00 +0800
Message-ID: <20260810054300.82437-1-hongfu.li@linux.dev>
In-Reply-To: <43b5db93-1c1b-436e-a8fa-d89582e31894@kernel.org>
References: <43b5db93-1c1b-436e-a8fa-d89582e31894@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B32B240002
X-Stat-Signature: 3sm7tfky6wwp4mxgc3dqi7yajcw9qnai
X-HE-Tag: 1786340640-626545
X-HE-Meta: U2FsdGVkX19PEWZCwyUIO9JU8N2dQ15tx89u4F1/2p4WdVVMxw/IZsKQbV3ft0Ytw0s5zugv0D97JaX/X9pJBOZW33eejA0YNNwZSpAMx3VRjw4BIcJGSoaW3tnQB64KqVdGEn1Y0obi79ruLWlO6rPS8HQy6xX4nyO1LHLqhPsFh3y9VLdIJZwn70sCd2qqYUcEbeZqnm48SnxxW76yRfPp58fxWnpR+XNCBK/ayyKE6gqEnLfpAsB2yFxu7PVkRSmpvuVEMu1mBSq2yqV5CjX8qYyP7ngHrZUB3gYD/F3Ubv0S/bRW6offpE5SKPUfqBjDJFADb8D56VhKhUS0j9HoTE0I1AjDsRsbgbxJufOQv8AoB/nlU31xkGbsn1+JmZkjoLprEXbvPH9iBgJ9HanfKcvAB0B0wpCw52PuVh0rq80Suxxe6f+rmi7TNQUb6Uq2Fx0czFFFUojo0/igko4KrR2/ADeUf7YvYUoZeJ0r4xvG4nFGZG1iB+40nqbpKS83kixcUbIJx8pXVn8mbjpgUyRNTID9KdW/dBBcTnd5pg8MPZVfkTmH7QkZ6rl9tM5KflyIk+f+mpBR+tvfdODLPtlUiFOHeNgbWD9JCb+Epy1SkSsbzK0IDgLgjbcu6+b5Mutf4bItY+XkspOkDJROqWjxl6kVRVIn6tqRfx5gvAcWoUBgMOyHmjK+bz4sIW5LU1+dxgiLJOTi6Whxq7mu6NQ6WGjkZw6SBsDPJ4FYTHlA39cuOGZp3DwFvcVtRRTqjW4T1rck0Rc8YQefNNtzP25oYHIZm40kkfB5Sd9GHCP72ZFB+fHttvDd1utX/0WxKigkF9Pf8DteTuH4n2WUfM9R4WLJb+pyE7RhLJN0g1B6M4ZCq+3/BJ5k5xZsumY+z2XGt0Y0Lnp9XnM9LGtyOFQwGL+W1aQAxYFwi7zIyE7wi14JXxMQz5vdbAkvoTtZOmmL8H8TjlQlkds
 r/GymkaH
 z37SKAKC0Cd1IA+dTFn7D0FNZOFY4HCw8rXz9mZZ7jUMK6lfA7Zm3f1FixptKBPigbLyp5JayRdg0C7UD1BajP6pJqQwH6Exqb4PeAoaUfgMWoqEt5rByUUkoFvqZrd9fpbeDiKtws9e3HGRM0Pbj370nax4RA44ThKsAh4abHdc/93ci6ZljJjavbz9Uz7m/JiBxY2pE5A70jZWoY+McRjwD1kk1UndCEGQl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index ef1ea11981a7..2697d50d07f4 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -755,7 +755,7 @@ unsigned long read_num(const char *path)
> >  {
> >  	char buf[21];
> >  
> > -	if (read_file(path, buf, sizeof(buf)) < 0)
> > +	if (!read_file(path, buf, sizeof(buf)))
> >  		ksft_exit_fail_perror("read_file()");
> >  
> >  	return strtoul(buf, NULL, 10);
> 
> 
> Yeah, that looks correct. Do we have Fixes: tags?
> 
> I think it was already wrong in read_num() in
> 
> 
> commit e0c13f9761df8f97cf5e81495d12ecbc4075684a
> Author: Kiryl Shutsemau <kas@kernel.org>
> Date:   Wed Jun 3 16:00:06 2020 -0700
> 
>     khugepaged: add self test
> 
> 
> where we had
> 
> +       ret = read_file(path, buf, sizeof(buf));
> +       if (ret < 0) {
> +               perror("read_file(read_num)");
> +               exit(EXIT_FAILURE);
> +       }
> 
> 
> So likely
> 
> Fixes: e0c13f9761df ("khugepaged: add self test")
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thank you for the review and tracking down the original commit.
I will include the Fixes tag you mentioned in the next patch revision.

Best regards,
Hongfu

