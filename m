Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80405C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900606B0095; Mon, 14 Sep 2026 10:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1256B0098; Mon, 14 Sep 2026 10:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6996B0099; Mon, 14 Sep 2026 10:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BAFB6B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:06:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0F6A16017D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:06:28 +0000 (UTC)
X-FDA: 85212542856.28.73668E0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id E5C651C0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:06:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lxW4m4Ei;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789394787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhzylWg8LwOhDzlTewR/pVgfsNFs5SWULNMPjXMX4MY=;
	b=2ta0ei3Ktq+Ks62pkxkhEg/uI4mjOpvBr/0Vy8MOkbIa/nZ75ctB5mZuedXDvyLCzHBjgk
	iouvRfuN8wG1Jl9Jk0e6SuMUdvqgoHoq/+iaWzdqKDdPim5Mkb4PtSfhpMHo6Zltgiec/X
	wa0GmHMtDKRxEGuUvtA0neN0O4HEDy0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789394787;
	b=caKpmlZxugjhcB9lew34HRKwRoUPjX78UrsT3H8dEPCdaz2nLUjCDaQ7Y4/RVz2xw+PTSB
	y5F7fTRlKbLeEETXmy9xWYyV56BKv6KxwcYcfDdx5nMnCP+Zk5qh16v/N8yl835feI94Iq
	yEts9LcYuTARxKWc5jVreCudOicf0ss=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lxW4m4Ei;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 733C91570;
	Mon, 14 Sep 2026 07:06:22 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0ED323F86F;
	Mon, 14 Sep 2026 07:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789394786; bh=kEbhPZqdypUYH5zuM3CM3xRPQdHZ9jN8Yu7SKo3bj+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lxW4m4EivxqOzcC3wG8EsJ1ftz5SRskIH7wLNcW2DE+3sE8I/m6oAN1mCVJmH3B/p
	 oNmCAl8S9o/4X11xWRjGj1jaU2iaj7bnjDrgnlbD6dRJLr+QL9lbkQptMzaMySRmlm
	 BuYbFyQ+p/R3Y6CW+snj8mCVrhfLiaSJJRZFbu5s=
Date: Mon, 14 Sep 2026 15:06:20 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v3 3/3] kselftest: mm: introduce size_to_shift() helper
Message-ID: <aqf_XGKDq6jH6pJW@e129823.arm.com>
References: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
 <20260914-fix_hpage_macro-v3-3-c9a305a01d39@arm.com>
 <b88f4ec0-61a8-47b0-901a-d63db115936c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b88f4ec0-61a8-47b0-901a-d63db115936c@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5C651C0002
X-Stat-Signature: mfcco4pa11nh7qipzmoqrescihtyohnb
X-Rspam-User: 
X-HE-Tag: 1789394786-235998
X-HE-Meta: U2FsdGVkX1/fj1SeiuJHIwfTD79CMyPxWjEMWCf9mBsj6Lv/O1sJf4JH2GmrdsucZuKXoSDff6a9AqpREH4paSf6nq+FJHrYPqisKaZNdqFaOaEUfO8ztKIh93O4jQGrSMGjicnLfuXJYvmQVsimKBadpWHbnmCEkEIC9pVBNYnUaXZzyiSDjPj4WZfXNchSoG6JFZA+w7Z+Zjsos+Hyo23JGob7A7PoRAHY6xMLxffunct88W9iva1HIJp0VZ1X40bRGnjnoBt13YjCyYcL6n9YaVG6gpO5mvjKLmfhdEkqrybyezoocQN7NklipSo5e8goGKBiH2BIKtFzWKIontf7bOr1I1JvW9Y/zcbDzGfXpDUhu2iKnnHuGddKLLMF9KqCibRxx6r7xaLs/VGqCj42c8+TnI2vbWnrLbU9g99WYniD1O89HH+3vOQjH14N3Kl/1oCPjHVJsoFgyZYsb3u5VZitI3NyG7/RGDI/Pu5TnzBu4zqfflIiEojR1Da1qV5KrWJ0H4Q9WZnjheTWCIvSX+L8j1HZzWdtfSiotZXgmpqT7W1HTbgtNgrjJOdPt2iBye/opY3LqY9J5wah9Zj+zPPXB/n7WRdRENKhAbdWc1YY72wOcmEg3Qx3+RXRejEQk9qte/+9kCyqfYjc+lAL2YgUFRUo00TXanw6TV/XORzwOCG7GHSyMwjIdx0bvquTPn5lhMLOqXYRImKY9ypa+a7agi5LLm5ou6l+jjSYTF4KvM8EfISNWnoHfIyXSiAFHVLHWQxs0u8ur7Zt5rZ0VgV34WSIhuf0o3HoUssztX/lhRkC+PTf4i2zaQKaXXH8vc2tG8dD+kkIwGKS1TYQ/B3y2ID6zFK4FC8aGMl5NDM4k4ryD6gueMWo45E5L4Cb9Yj/Yo3DqKefbMn/tERvXzsBlkENhCViwezt5sR4O7CH4xqIQrMqVZjuokW1QE5Q/FPqK7qZ83w5W+B
 c9NmOgm2
 ABgEzaiVsVb+pui2H9s3wg9bpfI40i5u/rvEBLFhEdaC6hIfQPgQ3fwa4Zvfh+aPsTJDxpl3V8DXwu3BPsn5on8Zp2sIFDMo9tIE5xAqygxh90whK3RZCrMFx3EVUBzq6dE9rguH6Sf6niFm3v5B74rmNV9sKBDQ4Jo+kNXFH2Cjle/G7SuKGl0tNUKhsdIGT+MFa6phcsL3HGodeDGw9fxKQpBXho+kzvsn/kXDjDD+unUK/37myqtjLM7ChfZZKBzESpEyw4eU1pn13d2ncPfM8lBpJOU9CibAwsxw+TPl0zYiCQDrI7KzfZo2sycHqwPorZ2Pe8Is+hKZ3WuzwEx/mDCpvyqVOkBPO94GgLCDI3DI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 04:01:02PM +0200, David Hildenbrand (Arm) wrote:
> On 9/14/26 09:30, Yeoreum Yun wrote:
> > Introduce size_to_shift() for future users that need to
> > obtain shift of a huge-page which is other than pmd_psize().
> > 
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/vm_util.c | 10 +++++++++-
> >  tools/testing/selftests/mm/vm_util.h |  1 +
> >  2 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index fd1432dc6152..1fef1266429f 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -157,6 +157,14 @@ bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len)
> >  	return false;
> >  }
> >  
> > +uint64_t size_to_shift(uint64_t size)
> > +{
> > +	if (__builtin_popcountll(size) != 1)
> > +		return 0;
> > +
> > +	return ffsl(size) - 1;
> > +}
> 
> Could likely just be an inline helper?

Okay. If there is no comments on today, I'll post tomorrow with this.

-- 
Sincerely,
Yeoreum Yun

