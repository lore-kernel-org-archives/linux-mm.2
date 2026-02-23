Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE4EEA4FCE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1206B008C; Mon, 23 Feb 2026 10:02:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B61D6B0098; Mon, 23 Feb 2026 10:02:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1A26B008C; Mon, 23 Feb 2026 10:02:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2ACF16B008C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:02:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47C13C104E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:02:38 +0000 (UTC)
X-FDA: 84476037996.06.F20A150
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 561E680027
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:02:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QIURQUyI;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771858956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghG8qmEThMaE8eplIbNQocnDJznDcsD/X7rOwcgRZdU=;
	b=DAhl0quLt5NhBsZSAHmJLkdp5Autq1RfbnZcy2lr0t6ovEdZ1TT7cRpLuY72aQOhspj9Ch
	iJRH91Isr/0dtRHmKNhUoztuxf70ZYNiU6NuZPqb2iLvnucQfFE0qpkEDilVDh/CHwO5al
	Aj0gZWIDy9SPZoA2zYp2lsUUYtcSu0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771858956; a=rsa-sha256;
	cv=none;
	b=TZFFNQuxL747Zr/AyWKFWTuj03gUect291Abro+WYjsKTcirkVXwbncNEAcpqtBNq3Tn8I
	j0pMk/hqM/mIuhF9EiBEBeZOrUSDdTcGbs4Tct87ufe08hDhg9SctKFAWNrba3PoM6c0RO
	U387AK3PbIU70cBxdR5Lh6AoLdPeS24=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QIURQUyI;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89577f866d6so56455996d6.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771858955; x=1772463755; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ghG8qmEThMaE8eplIbNQocnDJznDcsD/X7rOwcgRZdU=;
        b=QIURQUyIo0dmcog0aHNrZr3+FDJfe8X+zxPsgtX/Og7Er+jHzJa8OH20s/izZH7A+I
         s/qbcI5HYMp08pHpQw6OtAqIC+kKWX/Cm4Hv5nt1KI8FUEg5v2GF/ntZG+RcvI0I/TT7
         sfBIaZ+3F3zNij6I72joe/0Rhg+kN4EUM9gP+ETLvwI7yZp9hDCGin31f/0yhB0RCA89
         NOM5zJ+4jLmE0AGVWyL11wyqUtQxQBbobhUEpJBWTfcbVUi6CJ1BbH6Ubu87LUxZk+10
         vLNzvBhcNFyjjf61vtQKp0IIi4m9yvA1cohDiB4II6Rl67zrEwj78ZQYQiLi3qe7vK68
         ttXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771858955; x=1772463755;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ghG8qmEThMaE8eplIbNQocnDJznDcsD/X7rOwcgRZdU=;
        b=uj+xbcwjzjZBPkWtKzbtMMM/f9V9ngv5IIftES3TdpShZX+N6RZ2ShnZCQs+cr0Au/
         lgpBpYtkfS9tfXvyexhly5/PnHIrAALX79ZQqHQXUEuEbHH2yhnuj0YuZ/ixH2TOJvu7
         7+LyKZY3S4nRM9e1mbEG+wQyQ0N5iMlRroidGSSgu8dBhaggMetB3C/XWWobTpCmTxFF
         J2Sl3iSxu1kSfX2MFWr3LC/kWgmq9E4LG4kBTyzvvb4AM/c7pKO25ldenefc1f8Yrsaq
         Yqzz5aZGmVy+lzC2ymKMga3Ah4CmBkbiADKfjKXTNpq5rmiuWdmWvOrM19+s93h69z4u
         VAxQ==
X-Forwarded-Encrypted: i=1; AJvYcCX64HPFTqTDHxBZoNfFbfT8yX07NdW38QVjJR+QmgpxY2RXTrFxDbs24qd4o7VaPeTun2toFLA4/Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2PgPEYmN+sAt+xdVVJkPVtym5omkiHpJPtkCxBvESrhklYGIt
	6czfKpbzOBzbgwNfyDYhU4b92BlAztTNsdDmz8l3xX9brlkqrYdTjQydaldpqpqXHIDF385g6F/
	wuGC2
X-Gm-Gg: ATEYQzxTAhQjjrmvUkYGlRQ5Q8kWF31P+jbO2w6oV37EbfgUjILo4SAe2KPcRBfbRun
	ADCS4gNoqFnYQo6zEEAO0+qZdP5wnNLPdlZ6EOtWIfDtRBskEtRA3M+/nmej2/4x5crZxMdydbc
	tuiVtaLhXxIAIc8/llN3x7+5kcLwx3cV2fIqQs7EwVDPSzmzO5CP/ufYj34NVK4LWEeSvvjbjvN
	OqVxhrSDnyHSqvr6Li3WzAPDSkRjZe8DUQFqM3BShpqm0HhTtaC2Urgi2XGY9GitPRRi+OZ1ugW
	L6Vaxz7YmAFIeVrWw/0WVRgFgbruq9w4NOlC+sYf2OYCIaL0XXCe5dLlAqbh+7gKQYADI2gs/Us
	pxFfN1XbZN8OFqox5zreR8hldclaarSCcGq97AR2bMpXdYesw0Cm5vZUMz3sgkCNlIyDJAONp32
	O+pvVrS9JyQc+jjBh2z9XBEZVTO76NiwBfuL5l4AiSqTWxqfXyAMYKm4JYB6/5aMID6l4WL+18E
	HVbGH7IwJa0hQrVR7Mb
X-Received: by 2002:ad4:5d46:0:b0:894:73dc:a7f6 with SMTP id 6a1803df08f44-89965acd626mr202346166d6.2.1771858955076;
        Mon, 23 Feb 2026 07:02:35 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997c6bba49sm78730156d6.15.2026.02.23.07.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 07:02:34 -0800 (PST)
Date: Mon, 23 Feb 2026 10:02:30 -0500
From: Gregory Price <gourry@gourry.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aZxsBifRchLn2m42@gourry-fedora-PF4VCD3F>
References: <20260129144043.231636-1-bharata@amd.com>
 <a8d1efd6-2ca4-4f1d-9c0a-c8aa17732ee9@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8d1efd6-2ca4-4f1d-9c0a-c8aa17732ee9@amd.com>
X-Rspamd-Queue-Id: 561E680027
X-Stat-Signature: 1htygq7663u159up77ks8uwn8j69u6er
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771858956-370788
X-HE-Meta: U2FsdGVkX19WQKer/7Dh6aOjYqX902TOyix669GrHYUyJe7guUgRiu1qUok19+7WrljzI5sKo/cx83dlo0wfw46C8nrwkl8SmZnxHwIW3mvZTESYY+X38K4Y1wVcq2iLFvKqUHJkwrTi/JPxJg0XmypLmOmNOJ5rz2YZvPo2Aioc91CE2aV481WNGQvhgFvU6QBqIzwlnYukv29bUIkdBwAud0dVJKrrgvGZ+kK4l6KG+47B/4o+zbHp+0UicnDUWvgVUE30wMUAxYM6I5o13uIvT+Orbnj07YNibgl5ZR/U4+jdV4Q0PKvJQXhs1T+TV+3ykYg7+bvW8nQIJC2OxvA8UJpLytwpUem1dfu9gccB5aqtMN+WrqFr1ENCkiEWb0oS53YBxmMNQsaHRQyBEFwYdQ5zirb6QJr84s2po7EF5n0VYstciusQnL9k3Tf3BGUAM/9Vw6ritJ5oIe2YnT/syc2bazOk/6PumkiFRS8nfEnZtWQhERQV3Hgr6+GANOwl7VRQfyFrZ0exSJa9iX2yOmbbiDwiLPq44NeSt6jJhVi/pQfI+EfjmD+FrgDecMprOQS8gN6r66+BbQLs+R4n6GhCHM7kx0WfEO12fZHDtFGtDCLziB74Rkjt9NAAA4CTDDC4kumJkGB2qCb5Uhgt1QbJiXWhuGcveVYOkUZO/UaHoHG/wGwDT8WmmjBI8y50Wy8nhBqvMjQ42cJplwWZNyljwZPazeT5Bf7juoEneTyl7DB9LlUsRvx8vhSjOGhLIsQlhjHwFuV8gaXUllF9ef8gZ49w5R1j3HAOV8xS9Gi0bvRfncmLPC4LYpn9zC7i/Dykd2buvY/3i2oHQKgmd49pOODOh/sQhwkFRPT6kA0JPO4nR9Pr7UlTE/x/iCoD4gvMQxpBY9eyQAjl9xTJWsdorMeJGkeKz2+rdc0HJ+Alm5/mxzU0P0wcY26169tWQNlzazosWsLg3U5
 o6/upwhF
 ObFgH7Wh7DjxBcVjV28oK8CLb0D0I4LaMjAbnYuUa0tXw8IUu2OtPKXwrjIi8JHq9scn2L0+VMWHnbEi5xsRT7pAoVooXLVgPNGp3KKW0YHskVvOYkejFwUtsEaCKi8MMhoZ2JnHsDTeBoqxjbgytmKcNVFAQRRlUEnu0KD0LxLPfJfsyPejLrDzN5C0/4Bh5EYTh6Th9G2l3jWLktBB6gcvxsNXMoiBfUJ01QO1ny5BPPzLlF7OF/CJGdkOdAxe06j63K9AYChCCvFqFg5hxOqwt8gNoBlJKa6AUzyFJE8gHkCP/ZM3ZwHT3vbrAf022EZilg7DMkc7Ig4O6f/uNnciPHo6Bn0iVIWVWrp5ZZmDJDq4Vic0PwbOtYoBBh7I6CNZBGX2RVG3uttrlHvFZaFRK7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 07:57:39PM +0530, Bharata B Rao wrote:
> 
> Time in seconds - Lower is better
> Mop/s total - Higher is better
> =====================================================================================
>                         Base            Base            pghot-default
> pghot-precise
>                         NUMAB0          NUMAB2          NUMAB2          NUMAB2
> =====================================================================================
> Time in seconds         7349.86         4422.50         6219.71         4113.56
> Mop/s total             53247.66        88493.630       62923.030       95139.810
> 
> pgpromote_success       0               42181834        248503390       41955718
> pgpromote_candidate     0               0               577086192       0
> pgpromote_candidate_nrl 0               42181834        29410329        41956171
> pgdemote_kswapd         0               0               216489010       0
> numa_pte_updates        0               42252749        607470975       42037882
> numa_hint_faults        0               42183772        606540729       41968150
> =====================================================================================
> 
> - In the base case, the benchmark numbers improve significantly due to hot page
>   promotion.
> - Though the benchmark runs for hundreds of minutes, the pages get promoted
>   within the first few mins.
> - pghot-precise is able to match the base case numbers.
> - The benchmark suffers in pghot-default case due to promotion being limited
>   to the default NID (0) only. This leads to excessive PTE updates, hint faults,
>   demotion and promotion churn.

Wow, this really seems to justify the extra memory usage.

Is it possible for you to change pghot-default to move the page to a
random (or round-robin) node on the top tier instead of NID(0) by default?

At least then pghot-default would be correct 1/N % of the time (in theory).
I'd be curious to see how close it gets to NUMAB2 with that.

~Gregory

