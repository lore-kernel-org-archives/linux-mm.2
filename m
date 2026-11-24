Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18EFC606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N4dN2K+o
Received: by kanga.kvack.org (Postfix)
	id 080BE6B05D2; Mon, 23 Nov 2026 22:23:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0094C6B05D3; Mon, 23 Nov 2026 22:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11A76B05D4; Mon, 23 Nov 2026 22:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B42856B05D2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:23:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 279B71C4521
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:23:27 +0000 (UTC)
X-FDA: 85468567254.23.3091F44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 79C72180002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:23:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N4dN2K+o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795490605;
	b=Cp0/+7yuF5qHuS6qgjh71nPXAg7cEekB+QaEYZXOHcUiqrVK5sNilS5/EhFeP/ZcO+YaWR
	41gDXJg/pAPrpoHKEZWMdXvEjqgGaKAljmT7fhKPqv//c1hnSSghmoztQefjoJzYNrX47e
	on+APpZtJH6J0ZEK/wfyG8lvFjIUlBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795490605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2xYc13uIcoTxx1PIDsQUia73qmoO0NEeZoyYDssKHA=;
	b=TQAujFcs/fRQS0IEbdL4Iu6L0UDh8bMEhaPDDOzsQnhUqMAbzq2zo1UFYIl6qVRnTo1k1M
	dy6oZ6/tF1M3kd/oFcjoLGxwlIuaHRvUeiTF2C0sNm2LcofnDsWGgV58US9AKb+XmWJnTy
	DVMHERBAkCcY9877Ta8m9IEy3t9Y5fo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N4dN2K+o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE3DC44732;
	Tue, 24 Nov 2026 03:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538951F000CA;
	Tue, 24 Nov 2026 03:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795490604;
	bh=g2xYc13uIcoTxx1PIDsQUia73qmoO0NEeZoyYDssKHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4dN2K+oBMBLLRXtv/Nna9pSI/7QxrnjcmVbNUeHNe1OjRuXffrz3jgEekV6W/lje
	 wKqH5WTlXM9Iy7BDcSPIPLHxKzb/r3As+JnOObfHuwGwwVeemiccxNL+74pSRNtoUE
	 i149VYCLNhfx9V+lpjPJxudR/zmViitE0CdY2OQp4R6jy4wbE2Hg/GBRK5gxgWP+yh
	 /hvYUhc5AGcOwe1pqKc8ikHjCe9+9a/e++JCf3j1F6Y1+4tt/wGOPVaqF+vHewaAei
	 EDwmRBFylglsHeTsqEpnkRUFQ+OSxZ1hXdHBq0Kn8du+78+e3RfH80nisszaAAuus+
	 WNKQfW902mUqw==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Mon, 23 Nov 2026 19:23:15 -0800
Message-ID: <20261124032317.10738-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANOyQmFCkqfgQLda1EUADP2fVx_o6g+w8RuTAV5ugJ_sP3OkyA@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b6qkhmonz75qbk9xe8rrndqc5zw4hn17
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 79C72180002
X-Rspamd-Server: rspam03
X-HE-Tag: 1795490605-630444
X-HE-Meta: U2FsdGVkX18EMNrln8nK0HKJDUM3B2OjkQLU3PtEfk/U2idlx6l3XCuGsj2KpvLIQF6+wblPq49ar4m6fqsufRM95yOppuutIJqw+5xtVPUfCiCHVnlb7AWaf8bBk8KIz1L2cBHBgICO3XAMEb0HcszGrfy4/sAwudhEoKkONca2tjXuuGL4VVXKkL69dBoabjJAB3V7FE3ZhzNHzbOBGH6gV1z7qaTrFSxW+kt/uTHTBsss/RFdAJftGFG1Jus9MLkWHvvJxlBhGvQqDG/YMuPrWac0W+HmnIZP2Ws82C7MueHi5D9OOohDQR4GFqm6WzyBd80+FjPMQB7vJUQXKuTAw7/Bu5mjMhW38Uzy5ggtrp85N7LDdjS2O/hQwEh+f73lG79vY9Zj31eJWS2N2mQLqhkF0o+UUQHnaM2ud5o6dM2qZHuFHk4d8fv3Ir6RrBa11xxwAlmj3sPNoxSEHCnjQ8o4fq6kbK0Eu3hz1N0Gd184h4Xp5zyQqQX5RpgSgqG0VyE8vfRpiHckVmT590HVYuDw/u1b/gQI0n9cQoXHlqgeDFIZlpTAAcJ/FjnCEweRjfIHe5hOpMs18x0o72tGxtI6F/LpEjodza6/qo2xHUMb5aOAIs0c5hQHVCSjzjsA2CY2kv2olKK17EPbEbK5TU0t2/J/sRJsWdlusqAEoY7JaHtS6k7TCcnCLzSAq5GKsBhCiYZNSWkyOax0rYKpO3Nv4RYboJz7nl8KBAfF9mBaVg/+VE8+DKksK9JcJp87NIx3A9BWGTcczjbRN+JFS4BRnwPMxM1bIklLJFcG4gEHcyVUt+rT2t+xb6TyQ7p91cLgWff1Rm5CVQMXGami1uEvcMp80nyNgQwbeNHmBWJAb8qfpE8o9IvGO4ejylW4G99j/ziZFW117GJ2lvx+LugKQ7xilIk+4EuZ6SOxvj31/uf9ftfWd7Jqi2hz2AincTp6rbmCk5fuuxb
 rnyKnIdE
 3GIQzbgrjzG1QYhrDUXxAdyRO8Qdyk7KoPXmhkP5Nattv+/z2y5MVv1kRLE1OhuOk67WW/LZ/FiGVNRty9IfHsTn3IXAQ31LGJQIOrnEFQnPBn8g9btFYYhpYpW/mMqRKfEju2vGEmUXAxmo0LhWkv8iw0EA8V7w0Fyp/uJ+tHsMk0kVQIZHsH72vUJJPG7PpK1n4qRgrthHYeOTeoUEyYwpCOEKlWH0d5JQfMwtCZZgBBXs0/EzZtvDxAwxDBBxgiaJPROCGUy8t4sA36ZnM0pQX8j1/L5MpNu0j3r4s43ihNBGcXjdTIgWuBXjAZ3pcPCzYtWQnjfE0U4uMXVeA6XgEDQSh0O7WgJRfTwL1ttrk82Yo0BJbBy9/9jqfT6V8LZ+QEchdQ7UdqVJf+C1tIrYVNyulLNNQm/sTJfbQQFB4K0N6XsQju7Eh0IcnCH1UALYHvqe5r3MFQcIFC6AKxMFWsyMjlAqmimAt610hpcFiQm+mr3cbEInhkuVftExUw0hrPY6OwIYqCeVSl+KLJznJ5bT/ymVoe7zeTwaxz/+hw3erurb/UbGPKpcXMBcTiakrscCJnlmtbMk0t2lulugkivJo3uaSu5W9B/vWV6fhZTN5F9f21eUS/zrNKBcwAaCdX0wt2sdexyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 13:04:44 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> HI SJ,
> 
> On Tue, Nov 24, 2026 at 12:05 PM SJ Park <sj@kernel.org> wrote:
> aid if that will add something that we need to maintain long term,
> > without clear use case.  I think we could revisit after we get such realistic
> > use cases.
> 
> Sure. That makes sense :)

Thank you for confirming, Aveline.


Thanks,
SJ

[...]

