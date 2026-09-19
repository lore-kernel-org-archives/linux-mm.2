Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE8CCC982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 12:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A826B0088; Sat, 19 Sep 2026 08:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BAF16B008A; Sat, 19 Sep 2026 08:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0BE6B008C; Sat, 19 Sep 2026 08:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1BC6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 08:39:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99E3E1A0265
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 12:39:32 +0000 (UTC)
X-FDA: 85230467784.23.E6C0A58
Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5EDA3100005
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 12:39:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qOfDw3Bl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qOfDw3Bl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789821570;
	b=U8cs/lgi7Oxj0+H4KhbRbPEKg9Hxx/21yZ1s7hfENlFR9/6eEiC+0ed09FZxSOpoK5P3Ij
	6klAqZRHLrnBMGYIDbHCtsZS7V++krMZFMKNoU6lofwP/lZ0AWYKP1GEuBaSvSvnVJe+uQ
	FtqmuCaLAtT8tXpSAL8kkj53xxWD8NI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789821570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lEnKTVyqvnpIU14X83dXIMsyBpiTIl1E4onBc6x/F4=;
	b=zblLFamRLLaU/km22Ki+eWfuytkXEZim87FUX7o84hCGXxBItAJPp6A8GkmHuIFuLFYYaM
	M5vNc0o7n2KeGrT0vdN1W4bieB+A7NR6Pc9MUzHRQNNHkwgPFlofQ2u4UtJnJgNmEnGDEj
	i2O7JX6VCTPGOJnL+9W1FSHBmLt11vc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=63TAU/20trh3z6ZWmLlRWwzB6HR6yfQpshRqu4iyzzs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789821568; v=1; x=1790426368;
 b=qOfDw3BlczAkXfz2mWdfl+FxMdP/P7ZIPxFaZaK4WoVPnecQV5RrQx/g+8weJunVvfeonNJJ
 uQlzmJxL6PV8UEblrpMB3HtcKsXkQcMqXvPPmfuFise2RtUpDmss56ValftnitEhYs53DjLCoNZ
 dHZF7bM8ZAGsM0Q62endyb7o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 39ea79bec7641d4d;
	Sat, 19 Sep 2026 12:39:18 +0000
X-Mizu-Trace-ID: 39ea79bec7641d4d
X-Migadu-Flow: FLOW_OUT
Message-ID: <f38bce8f-ee47-40aa-a215-e2e605d17c91@linux.dev>
Date: Sat, 19 Sep 2026 20:39:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] Docs/mm/damon/design: clarify bp is basis point
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260917142210.90829-1-sj@kernel.org>
 <20260917142210.90829-11-sj@kernel.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260917142210.90829-11-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EDA3100005
X-Stat-Signature: dscpes3ezfkzgcg6zeepj8bd9ij339q5
X-Rspamd-Server: rspam01
X-HE-Tag: 1789821570-174414
X-HE-Meta: U2FsdGVkX1/wonPl1AR/VdJjflS481CigkoJiFl3fY9dtoehmkJLkdXxA20zVQnUkh8D+6HeCqUAEQBv1VrEbfpjFHM66gHEL7XtGQFeWYbaM9H7zU7trMyb7YItD5o+jOex1w8SqBUzyHq7GhRkC2WLsc3rXN3DCDeZ1Td6+eBSp3yRM9aHgikckwPFyA4fe6JM3tNbvWAPPH0lyw/sGt7M5XRLEEVohNc/oc6Oi/JBexZID55LFdUp4TrkshoGWb0IJ4QRN0K4PYOpsGDkbpAveernhhHmoS3WHxXhV44N+7uDaDP/qHKlTCd9KvJ3xcPv/aZbJF0v9QIWA74+geKRgXiNjgVkEqRTCISm23UoKY/Y/OUCweDKqOgolmN8DxBGZjoAqw3ZT+RD8QZ5pEoYRIfY3VuRM8e05I+t8g0FhncF9HBUM/JMyiNFsCATwYiBkClL0cDPopDeOTItFCf4THkgWsO8T6+cpY/R9fgyf4aMtsmpj8SZQx58RhaDnmi+ZMDJv1zLKgqjPSBVsdiv9VTe2YWFQCwwS1ty4mZzxCh9oNDFwSITZgCIgrc+QDF1RgmbhO9LG5H9Pjnyl9WWRhABgcb2c+kR6DAb9Ho7RPsVd6S6NHdc1rgCVYTOZqjTGxhQ2dCi60L5WfWxEM8Joa0tiJx0V2m5zTSsfpriAAanpKDqiUWCan6ivadCaORwYuVgBtoxCAv3VuCjnowT/hFIHNyWYJhxY0WL0rbMI6Q8x5ClyOVyj2tovz7awFM5l57ZgpIJ8Gn3cslKnj8jX3F6oEXZAZsafNIhJA410x83DuyWcwkVVqcKRYeO79IBzFJlmZ6ii1UEKS3wWc3aZYpyk/dUqkf+qkTS8p3swk6aFsSHMx7XyW2kKFNkRvm6TAyiYDhGSNPAFSeBVTDYMGpOUDY+pVRtbOuiqaYwElSBYEYdFEjLFVAleWqfzlzLoQ8CWkt6kldltrl
 +U65fWdN
 SKblSXrcbhAw+T1bleGoRU9cCy/YlJppIk/8MhL0u5HTpYIMSBPJhj1g2yRi7zu/zEnI25PWXIDpnECRk5PDmcjU0sH8yjOZSN2xMpp8LqGyhTwexT3xha/SpFx7u81Vk8cek83LIjMXSYGIq2IqVPvEkXJTqmJJqXI8JXpqAm8SpMlW/DUt8v5C5JgFm6rzb/McBHRxYZvcttIhRi/0MeKvAhXRIJN27ij0DwJrD65KrLfF2Z9U0YVSgBQg0JgWyVHLHB4VGDxnSKSLW1eGoblZB0R0i8/mJmCG6BAQwaMH3UxAnBUJzDcRxFRzZDP1BO/QBncEMvyFx7fA86zVQI6a7DyubbQ7PaIZDnmOcDvMIJfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 10:22 PM, SJ Park wrote:
> DAMON design document uses "bp" for "basis point" in multiple places.
> Because it is not clearly mentioned, it is difficult to understand what
> "bp" stands for.  Add the clarification.

Exactly ;-)  I had such confusion when I was reading the doc.

> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Closes: https://lore.kernel.org/107dc6ba-697e-4b25-ba3e-8ce2499cac9a@infradead.org
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: SJ Park <sj@kernel.org>

Acked-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks,
Zenghui

