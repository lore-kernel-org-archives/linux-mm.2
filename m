Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43261606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 13:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYYDVKoD
Received: by kanga.kvack.org (Postfix)
	id 5168F6B00EF; Sun,  1 Nov 2026 08:33:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1B46B05B1; Sun,  1 Nov 2026 08:33:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 367A36B05B2; Sun,  1 Nov 2026 08:33:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13D446B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:33:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C6F81C450E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:33:27 +0000 (UTC)
X-FDA: 85386642054.10.F3AC2B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DFFC8C0004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:33:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYYDVKoD;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793540006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neLWtSceMYlxYsjXzdJ9arOYUSJDsCqTRHZbfoxyj3Q=;
	b=XQWT9lVdX0hJo71FdMJ2P6+6d4fevxT0DGEaxzo4IqEW7vqAbrpbyIJyhFuA7Vij8wqgRN
	ndmXEKT2rFgxrHRx2VF/bNZZDzlzPAsoHGD/taES52MyWmavf7pY2HTyrES+fN8jrAfUtH
	f4DwIg1gRTG6dN5e4AWKctKC4ye6rTU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793540006;
	b=ZDgQ4rlrwNEz4PQkD6T44mOOZD9AOVvdo5re3TapZcOA1WZSUVZ9Z4mkyvxQXF9fmWBFS5
	2ATJTb3wLub1JBpCfmu8CziCSnxxV1iFLW59Xyqw4El0r/9Z/Ix89O7TcEn84YLjgwKPjE
	XmqLh6Zb8SHQI1O7BkBOyC7uAWSXpiQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYYDVKoD;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD0EA42BB7;
	Sun,  1 Nov 2026 13:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B836B1F000C1;
	Sun,  1 Nov 2026 13:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793540004;
	bh=neLWtSceMYlxYsjXzdJ9arOYUSJDsCqTRHZbfoxyj3Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=AYYDVKoDRJv3WOKI2s3gA9ET9FOf86cYW2f9/a+SmZbaPnZTSGJpPraTfOsKS5dI9
	 udjzMc0Mv3xwBW4MdlPa/yVahM3ZuMq4XW6y0MEhzstCx1w0ZJuJpW6IiLPz6XJbxa
	 hQmDNEeSGMH4ggIaUT2z0JgxTlQ24Wc2tSPEwvhUsl7EyZWhieeTKOHaaA/AigUGSp
	 K+LUmZDOiOjMEe7z+jEsAmpqSxK+JqTaebB5Z39bexKieFL8FfGUzs1kS67vXax3Lj
	 nmPzQNXxmQFJbrg2b9r1WwH6VF31NR/QVVc/2zTfm7qZI3+Z2maylHRbXIeGhoYv7k
	 /bP5aFkJKUdkg==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Samiullah Khawaja <skhawaja@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Andy Lutomirski <luto@amacapital.net>, 
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261031203540.2282507-1-skhawaja@google.com>
References: <20261031203540.2282507-1-skhawaja@google.com>
Subject: Re: [PATCH] mm/gup: check folio->mapping under folio lock in
 memfd_pin_folios()
Message-Id: <179354000144.6438.8171913734635387726.b4-ty@b4>
Date: Sun, 01 Nov 2026 14:33:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFFC8C0004
X-Stat-Signature: o9cqc9zp64bortr5dcfx3453sexbr6i6
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793540005-441091
X-HE-Meta: U2FsdGVkX1/3IBFKbp8escp8o+EvGaXfZxgRa42c19WIWrr18wCHeqsPgUy4ISeHzpFwkhnr6X9ab6YUuzyEvnBwwHdI1/FW8ZnuBWiEDE1FekHVejeW2RyLSFYs1CSUuZyukTu7h33bcyt0VvCqGou8+mtcyZxg8AdYRBsNri+7Uc1XGNAh1aFSRAnWXm/QKPOGEMkjewoY8i3kpNEJP8Og0rC2wm/jrUY3U4VmWYz0OEV3h+8Bwo1Yb35XjcoDHmoePFf7LNsYGpY1m2RzUJoCh7ny0g6sYOqmwWKap2BsfMFYJqo9MrrTaPeKXjJw5PbhFCJhTBJJUrfVDlHLw+P9JoO01CWkf0ekumICEzrXuENQkioscguv3UtN7ANCF+40EKMZOcJrOWa7TngJju8q4pl25aTXEl2KIQJI5HMtPQYTUDrozv5CaonOuXhqhh8GGiCwL8Y6BkBNgp3KPzzjFjSwlWI6Zq9kSdnQ+qyz9ClUt9S8pdhaN0JZv0YJXbkyz8ynLom2Z37kcaSXLLxfA+IL7Nn6ZyrnNnTiwgx7bn0GAkB8ANlIfCyPfa7SfZCPGitSH2TAkgyPK4Nm+Popz/bnkC2jHYO3A1SVKM+7HwEXKbuTfBCc5oPRX+ii1IcYt1/l/70tGK5+5fy96lDXK4HtQFieVLaXIZVejKg9Fzx0cAgYAPd5ml8VXQWsjg3ghSG2pTkgEv2rcr5pUW6tLx1nhPPR/XxjP6ABOahB8MJkE6akwRyZqxfE0pL7BWBnoxY53EUSA/Cke30jmAfd2p3mWObiiSVI6pMZS3VN+ty1w8FaIPyNfkPvchC4cFmB7lldXt4t0ePlKcmrcV+zTQBLSeqAQPeM/811EChqE3LGTeouV6UpsKOJlLPc9INMSOMuiPSJQY2Y/qh0EoQkJ3SEc1Ms1/hj08zpxbJcIgyiS4F3F9HTwCOXtzQRb8i6TrumjkyEF1ojHk7
 zm91WHvQ
 2XT2rumtu2hYJB5Qq5l23s3AfR+Ov8Wzj5+tWgJqme773tpu9N53KRch49CE77DZm8IoC9JCZQpZL1ZsB9uzpSsWFchn0x8aGRpptv9PFtqyQ4bKK0uVqbRuEEfWy3DbcfIFsCxsYNfKmFgoN3gl6H9EIzxlYofjQNGpW7x7sixR1nWNSw1yr3YVB/zqf6bNcGVbvO7AhJFV7e7LlfXBY0mPlKGFfp1yCvdygCZt6qLTYz3rFqsnQd2HocBDurPul5S7SqQR0C+uTLjDhgSoHVUlreIIlw1OxhV20
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 20:35:40 +0000, Samiullah Khawaja wrote:
> memfd_pin_folios() pins folios from the page cache without taking the
> folio lock. So khugepaged or MADV_COLLAPSE can replace the folio after
> its refcount check while memfd_pin_folios() still pins the old folio,
> and the caller ends up with a folio that is no longer part of the memfd.
> 
> Lock the folio and recheck folio->mapping before pinning it, like other
> page cache users do. If the folio was removed, retry the folio lookup
> from the index that was removed.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/gup: check folio->mapping under folio lock in memfd_pin_folios()
      https://git.kernel.org/mm/core/c/10b2920f

-- 
Cheers,

David


