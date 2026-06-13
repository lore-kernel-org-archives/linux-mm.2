Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88FFCCD8CA8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 09:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33BFC6B0005; Sat, 13 Jun 2026 05:41:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED0C6B008A; Sat, 13 Jun 2026 05:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC446B008C; Sat, 13 Jun 2026 05:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 082A06B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:41:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 904C14038E
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 09:41:17 +0000 (UTC)
X-FDA: 84874396194.28.A65627C
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 98653C0004
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 09:41:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xXkESVPd;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781343676;
	b=2XL2ZIGJ+g/U9l2C7sobyIzaBZ9dRt+dn2YaXasB5M4vihAHC23dNtHr79k9ww5yJk/TML
	6DHrq98T/s5gpH3qDdxnqQUGOXekw1ta2tIGyxaUD9s1z8UX4R04y2I8SG0D1Pu+ac+/Ms
	4wQj6xhXLTcUY6JCgnWECFmcTdvpwvE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xXkESVPd;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781343676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9vhqsq5bfyaKJuEZ7vSS3uuF/Bho5vCtA+nLHPqRKk=;
	b=w5NgFa1iKaLTkn4yvyvjRKCBBt7Ux0N9tbJ22IuSnxGgvzBtAT6xE9t+vKF+F53ZYL8PRF
	g3EueQtJFWUemdFx5kbUjkm1k2U2WbXDFr2smCTknGloaGFJSekSUM8wJ8GBTAqhnGRJ+G
	mB7abQ7O2U9wWH0ZRb/E7Z9/qsR45QU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781343672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l9vhqsq5bfyaKJuEZ7vSS3uuF/Bho5vCtA+nLHPqRKk=;
	b=xXkESVPdFyKZZn6C6OJvt76RiV1y8lHsEnjZCUElMzdTuxcFSOe0ID2yshvdAt4hMuwZD/
	OtQnP1QlUKPZCKDgiBflT8ns5FKe0FLIA3se3BymbIYVxyDXabziEg3S1PGukLAfdShziI
	wz+HIRFPtXuGXkjpMldu70s0gWPY33Y=
From: Lance Yang <lance.yang@linux.dev>
To: willy@infradead.org
Cc: akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	hyc.lee@gmail.com,
	usama.arif@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 3/6] ntfs: Use zero_user_segment() in handle_bounds_compressed_page()
Date: Sat, 13 Jun 2026 17:41:03 +0800
Message-Id: <20260613094103.14051-1-lance.yang@linux.dev>
In-Reply-To: <20260608210618.3437216-4-willy@infradead.org>
References: <20260608210618.3437216-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 98653C0004
X-Rspam-User: 
X-Stat-Signature: nikzqd17jj79g9izxhxef17f1brw5k1d
X-HE-Tag: 1781343675-353260
X-HE-Meta: U2FsdGVkX18A4LJxFA7wjW3qLnC7AEcHArRnBHlTZ7AoEzak0vTSMTouHlAMgIG0daB9kT2xPqRfg4xpKVBEh2pby+6JDdTGgRIkD1+R+yGJpOfC5hukSzQv7A+3PrIZf3v9Zf1MvLmio6BMaj7pMutnnaMsVUZLaWYqjt4J4RwL2ANBykLW8FFpjkFqqya7opF1lecgdk0ieIGQvZQnOwua5R4z7LZN58GoDR+PRBlP6mz6AVgz8IkFEaDWX85YKLydjWTjRF355dRwa0qNXFpWLSkMU2VcBiPQHH67odPnQ01JEhtN70dSzjHyhzBe1S6hhV9sqNWqBbOMl51+oGxaIHsL0I+TM9cH+VXuFli3tyAPVl6nWY6/XNZj97+kSBl4o8dcNIo6ASIBu8CrkMJv0HxNrxCaTQEvip/BC0rYE145jpxmmNNQnkN7fpbxP/j9Zfqqte0TKCbUDF1HcT8lrZTDwCbtM9Nrn+lqhXL3GGj6ODbvyLIaLbRYWI0dlamnLfAQh3NlnWpWW2fZLzdCMshj/GTSyhqfsz/6eby+M4ODFcNDOwvCSNpkqx/Z/VN1nEnt3jBTnCGVMjx6dPA77+h0sPTrTl1f+7q5PVbvki/nK5xJOV4c9JIERHr/FGmSOethyoQ7Ozh6IhSr41tz7hoonA3Q8iCIUrHUCX7bX+0vPmtZZbGIYeUmaMYZv/SDLvte5ZitcldbS7n3iOv5qA4dTMXkcV7NntcwWfaLdMSI2C7zg8b9kDnJ5Yymtyoh+DRQdoWq5YeOARfAKAIdA9OrRAiXhqfBaltueyTaT4+iqXU7Lr8jvjE1NjDKFJE6fEYEoeH1v5QowzsiPbS0Bs9nJjs8YVT9ijo4btVuMVy7OYCgFzMQgykwQA+h1EFhbeL14PtbUXv2YXQokHSacRu08CSaNV+SMdGFIctc5pACbkGRDaPPW9p6NQptqdtRPWKA8cK+W5Rd5Ky
 yQB8+vz5
 ybCe1sG/Ffc+4ruSB9GS/4ro44z2OBEhue2viyKx5JkTKbomaod+lyk6iQUbbc4/FmvP9R/30rNU4jz56JKAONVP3HUyZlQCu5Bk6PI06/G97LrKdhv0V//8fVqbp+DwfxtQxwewCQGaX+3Ol5k70EFBPBX856lZv8xtgXp9yvXXL+esNQVMU74PFuaAUaEYmAg3K8mDJVHeV+eZe+vo3RLR0/Xc6yc/hp2nPpvYojjHD9y7VfJQPYqDsez88JlgzuEQCPoMj/3rpKnokubhSILuDAtuCFEQzHqRs+OX6FEVUH233qaiZQ2twToue77TOmzeN+LbSmE5kRCtMim7S3mYm8hT68OMVcn0Jp0EC+oOAtcj3KQXnagqoWe7bx6WVg6aWEUjFNwBfx8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jun 08, 2026 at 10:06:13PM +0100, Matthew Wilcox (Oracle) wrote:
>This fixes handle_bounds_compressed_page() on highmem memory
>as page_address() does not work on memory which has been kmap_local(),
>only on kmap() memory.
>
>Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>---
> fs/ntfs/compress.c | 18 ++++++++----------
> 1 file changed, 8 insertions(+), 10 deletions(-)
>
>diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c

Just a thought.

This file still seems to have a few more page_address() users where the
kmap_local_page() return value is not used.

Should the rest of them be cleaned up in this series too?

Cheers, Lance

