Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B510C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DAD6B00E2; Wed,  2 Sep 2026 13:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0136B00E4; Wed,  2 Sep 2026 13:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0CA6B00E5; Wed,  2 Sep 2026 13:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAE376B00E2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:00:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DDDAA3D34
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:00:28 +0000 (UTC)
X-FDA: 85169435736.30.514FBC7
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 86B1C180012
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:00:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IUNQHS0X;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788368426;
	b=Cyk8/A+JFisxP7WZOl/RPb3HLXBKan35v6dxMpogiXNxFGd610SJ9rmmPnU2gw7lETba3y
	Li9zWVjNwTBRW9bOdNrvRXSqByR9u7gYBXJNB7DmXFKN9iON4gmEI0m4s/F2p9ExoFNBau
	mMVZl7laeIoVR0UMoy2YsAQlEs9kl1I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IUNQHS0X;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788368426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qwirF8YS4XS5WYBuAAukyT9KZnZ3AKCmccSFmPzUas=;
	b=2wFm7D+exzk+tfTUHTSRfVQPYTtTuQps6Td46jtLbV+XAf1wOo/Aqvu0A2QHvJRinISnns
	v2hahs9FMfY1wB1accCowqZjLOQYePVpI0Oa0XG4zgntSpSrl6zUl9j5zchzNK34OdzZiU
	5TcQ/aKUiSzZVUzy+iRb4UD/ry0ZWV4=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48436251906so1403142f8f.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 10:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788368425; x=1788973225; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2qwirF8YS4XS5WYBuAAukyT9KZnZ3AKCmccSFmPzUas=;
        b=IUNQHS0X2+la7TCgcQqmgyOItDHnuTFu1iLkvAFIVyDpVKkX81TdpYxQwfvpBmIDy3
         saqwWUPkscikJjWKXzzC1KwV/6fvoiBTbExU1uG5OdUH89vJaE3BXU/q1svTVAGjpk0O
         k+A/XsLwkIb2j3u87nBfKqdnn+uWOgZE9PKHkSnbH6SOVXoTtmSyff36FDS5yeE27R2d
         dcDVX/BnYMgCP0VdPDFDmoLxX6y7X6U2jJEZFvjUyODQqGBWcRNiKlEjfl2QTe0Qlq82
         eDBjPh0JLfVtsKKJEz7rUs+PeRYT8Bc+AXRy4Uln8A3T54Dy4CU9qAq29RjiM7UfDP/U
         8o2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788368425; x=1788973225;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2qwirF8YS4XS5WYBuAAukyT9KZnZ3AKCmccSFmPzUas=;
        b=rORxNmQmk5tQeXK+Ff1f9B5TQ7P4221537MDF6TBFv26KaMFEhAJCrBRYkOtE7S3sT
         tk3t7axmQ868+jz9CsRashqyhI0BczlVREj0GiJWBBOgxv9PBLrXXQyksrgBsIZwrnpN
         0RTa30e6rQ1wDkI9FabFoGxKuO4tnigJ7MrgOovke4IdW/Jb4ZAyjN143HKlUzUqI1D6
         WSeQBHyRLXwBaDHvCo3jNdc8b0yjVBjWVZDpj40IcYzwQkhQ7nasjU3kzwPz3I0aIFzV
         t0UAv/hdk4nsx826/rcsdWS1GimuR45y6bScI61iyj+WoAfGbplmIt+3jmepTYYkX9Ds
         FD/g==
X-Forwarded-Encrypted: i=1; AKwUvBzvkBnPrH+u4qZMXsR3bnw8/mO6dSTNCCiia7RMadpueLVn41kHkJdqncz2hSa1gP2DjNGEH84Hgg==@kvack.org
X-Gm-Message-State: AFuF++n/rM7XfYngTZAR36Dfhgm+0fW/8W3KLrqmZaqu84IQzUUDxfkr
	9UmeESuDBHxCOsglQ6nzfbh5139lCaO4LuxKogmFEXnxLK1RDpCqIevg
X-Gm-Gg: AYBFou0dF+JC1qYEzGne5jBTZWCSj61ODCWMVkuwE76DiVxzp0FnAo4lHsc39U3zqHn
	NmgZoUKP24L3gPNuYZ1qGL42e2YQH7PKNT94PbRBd7imxHsRL/rfSXZrC/Ji40SztvoK7Z7ab0i
	4XjPE221iUltG5WV0NM6NR4sErNA5Sti/iUd5hGA3MKx//5B5MHh1g71y0AvqRTcy5cO/LKEGbK
	Pg3656JJDNcXn3ugJskekWWG55D8q4mLqsvZgEDjk8k9E4BEh7atHd/p0CbWvzR7pTQF6MymRPl
	Z0oYq34pn25mz+Rf/uSZbQw49dgS1LTkSZ9v/OjVXOIEDQtzfwSTNakld3wwNre4B2g9Q6C775C
	jpqGz5oSnZCG1y2ywjXLukrLDYR3m9yWHotFepShZbrRvt7d3gZ1tGH62AIo1+ipBHDxAZ8iE3s
	G+JN0wgkum1eFfZVfJkPUB6bHlGl+lzkMelnDempHmGq2APG3bBWUt8fhnfECahyQL5Ny/C2RoB
	Hc3iv1u/0V2czQiKZczLkOJS01XY5zbPJMqjGB028pm88tO45uJJ8LISQ04bXKy5vgXBjWef5NA
	Nuy3kufZ3XMd6DsE0Pj5L7UdiUVU26rcJDU=
X-Received: by 2002:a5d:554c:0:b0:482:e6ec:4edb with SMTP id ffacd0b85a97d-48488f1b148mr8670058f8f.15.1788368421495;
        Wed, 02 Sep 2026 10:00:21 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-077-007-017-232.77.7.pool.telefonica.de. [77.7.17.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448ed2edfsm7345851f8f.23.2026.09.02.10.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 10:00:20 -0700 (PDT)
Date: Wed, 2 Sep 2026 18:58:22 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: hugetlb: fix BBM for mprotect() on contiguous PTEs
Message-ID: <aphUkaF4mXlxAuCm@gmail.com>
References: <20260901131823.15799-1-kmehltretter@gmail.com>
 <xwyaihtgvjonk4wqmllsnzkq2ch63bhfzmvh6353ds6tpjuaww@lmu7ltps4il5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xwyaihtgvjonk4wqmllsnzkq2ch63bhfzmvh6353ds6tpjuaww@lmu7ltps4il5>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 86B1C180012
X-Stat-Signature: aykdohja4m98r8zxpezm6zp145cdt5bn
X-HE-Tag: 1788368426-924410
X-HE-Meta: U2FsdGVkX18JeZaNVpAc63Jv7wfk+BEHk47gz9Po7q4ylBU6yTjZA8Apg6d+ddZ5TVQisY04fKk2U+wxX5TZiDIIMjmy/bNAfMo9kC33An+oxOhnvjf6NFqfhk5HS/ZCcYp3RTijS2K3GoBmDquuCm2bfFQryl/e///WP6pmLV7fml6U2H7CcVhBqXQnq/IyjgvZifG3QYdfqKY7cJWj/MfZ1RzFf/62l1m4jWtfzUb6l5QdN7W6O9bspGUczygEbzeP9tAaHsh16lpbyA/gay014lKfLc8opKFS4zhdci+CXUFLmfPCHvcDjrx5G6WkRprp3Zlqs1bl7qL8lzmgXhnliyLenYmODBwdbjvueM8vMfHUx22QwSZbpJ03EDT/kmStC4l13PPtGKYIo1JpZxPV5MuN8xXESTRjP7+unsxSYicQlT6CJBgRw+mQJKgR80HNSFYCvBK3l9V1deA+S8q6ga69wa9CLEVQ5kdpJt0eh+LogsR9oZgMxoqX8Sg1DjcnkRnzNgrY+pPTypz+ZtDkwX9VF5VseaoIbvygbFEGt/N4N2go+G6El4q2yyjsMAGHLY8F0bXS/8as01v9ZD9gNTiEZ3mMpP0zybIgWqorqc6CroPWBcpAzaZJ8MJam1TscWOHCcQJ6JSTNFIK2DJWzQM8qQgxX1uFu7LTMTT/JqMLSk7fxhhYoMK/VFmDEWptS7S8KXQKd5adqiUIVDMPWBpAWG8/K4wfkNQWKOM7SQAkN5qrZuDstj5izirTRlhnf3va7nyU+03Fl9hnodShpPYueP083SR1BnYsI6IENd0eMVLJ+78v0E9/I5p++Bc09FUGFrOfg/+7cvUfPdVOGkJFmPI39lffofJEJyWdqItHZgKQqUsOyokfh5fs+HO6J6hrOfDaahttn1EImkz5+pa8rWxfdIrVFRQUsOKNAlxnJ40d3tSW5/3r1qxwqR+W9OJgqEon2Q4ZbZ/
 f67kfVTZ
 Te0Up71xKaf/nmOm3PkhpWJv448wqyncu5hQnIW4ObldsmU76bYEgTCXrvesNg5WTCX0VAOWKZEG4lPmV2XSb/vBV6J6XjxjS3yGNUT+NQRsCk384kKD7JObVqqyIjhLIpPdPAFyAra+k6tNn5ebQwi/VJxhLhGaFt5kCx3SFlKyKI8zWD7i6RMBVp23pxD9YHYWGIMw2d34U88578L4U6YXJ9RrM+VRh0EpLrkcz8DGJPpyDAfrwCyT33Rt+dH9/XFC+YQWi3hoq6jEoZ4IO3aUIgYni4wPeAqNXhtii6G/N9eqm+mMgqmHzOsjMZrnamhw5zy37n9bdjV09J0TPiC7RIK4MIV/imAwwvj1I6T/UFYCaEcIXhmK+TonQs11xG8gEK5YSxBpKitcrfGYuATRdaHvbbSmc8OJ2kiY8l6FGaq08Z4CmEQNKZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 10:08:58AM +0100, Anshuman Khandual wrote:
> No user-visiable failure was reported even without this change ?
> Missing TLBI as seen in QEMU is the only clue here ?A

This came out of an experiment to add warnings for architectural
details that QEMU does not normally model. The checker tracks guest
page-table writes and TLBIs using a shadow TLB.

It reported 3072 contiguous PTE transitions without an intervening
TLBI on the unpatched kernel, none with this change, and none for the
already-flushed write-protect control. Together with the code history,
that was the basis for the patch.

As noted in the testing section, no user-visible failure was
reproduced. 

I also tested an unpatched kernel on a Raspberry Pi 400.

The Cortex-A72's L1 data-TLB refill ratio was approximately 1:16 for
the 64K hugetlb mapping versus a forced-4K control, indicating that it
amalgamated the 16 contiguous PTEs. A contended test still completed
85,396 full-range permission changes and about 2.8 billion reads
without a fault or data mismatch.

> But you have not seen any real TLB conflicts even on custom QEMU ?

No. QEMU does not model the stage-1 Contiguous hint as a combined TLB
entry. The added checker only logged the page-table/TLBI sequence, it
did not change translation behaviour or inject TLB conflicts.

Thanks,
Karl

