Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FF4606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eHrUB3jR
Received: by kanga.kvack.org (Postfix)
	id 71FC76B075D; Tue, 27 Oct 2026 09:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CFFC6B075F; Tue, 27 Oct 2026 09:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2C96B0760; Tue, 27 Oct 2026 09:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBF76B075D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:59:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB99F12094F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:59:09 +0000 (UTC)
X-FDA: 85368562818.24.CE82732
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E2A7F1C000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:59:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHrUB3jR;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k81WR/qvDcIxasabpW38Pkoc1U6DpN2apgQSlcIEcSk=;
	b=EjmtwqZJBKF/24qxWxa/77iIzaHx0DfIVzfzWGdcIQIKhfo1F/an4ej5fLwkTc8ZA44Il8
	SdGRXTCjqZRlWQRoneIGNTGscCEv9XR8F+bQyoTO6aGrzgWMgHi++P80PC9iFEPCBvooP+
	6juoeSHGcYS6MUy7IvV8hgZWUnBMc5c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHrUB3jR;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109548;
	b=I84X4dbuQXTRpWOvQSju59fOx9CHm9WR9xCKX3yWp7Cx+KI9HG8iCBWtUXWV75gYb0DJ41
	2kbTh6ZK1zFqgP9RhDA0kHKtdeGVA90XBsF3YqwWYKkWV3AI+qS18sHLF0LhkCV4YWA1A8
	I/qWwci69+jy5pw9K8pTCH3Trxe2VNU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FFB940B92;
	Tue, 27 Oct 2026 13:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4991F01828;
	Tue, 27 Oct 2026 13:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793109547;
	bh=k81WR/qvDcIxasabpW38Pkoc1U6DpN2apgQSlcIEcSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eHrUB3jRVGTT5gVd5LhwYjTDJh48kysHjX4M3oar92rSyGEuBUI06wp8/1WyJtRvu
	 MFVNxZiXKv2iMe78Aa+x82OYyF1ICYo6Qc59eGq9QH24bjDczxEyPR9rQYv8tIa8P+
	 1whqTApXHR/S/f4Njb2QikgChQOGQUYdKrifwa8mNYP6KMS/OrDn9NzawHSOEjx36E
	 w2VFvv7ojoUDS5H7JHfZ/H+/bn0sSbJkRYfVMhSQDmgfOHTS38ml++OzkxwhYu26VY
	 uw5thE/0fH52aDlFhf5UAz1g07/UZbcai0NnortUnR6DiY7y1GgcxBECPKc7wQ6L6P
	 muQ7yiZ6QDfxw==
Message-ID: <b47ec526-78b7-440f-a034-0a4d5137b549@kernel.org>
Date: Tue, 27 Oct 2026 14:58:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in
 collapse_file()
To: Pedro Falcato <pfalcato@suse.de>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, jack@suse.cz,
 djwong@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 hch@lst.de, ngocthang2710.1999@gmail.com,
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20261026152013.10511-1-lance.yang@linux.dev>
 <321017a4-58cb-4178-8ff2-055a9bbb28b6@kernel.org>
 <auCg6dXegweUB5m0@pedro-suse.tail5790ac.ts.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auCg6dXegweUB5m0@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2A7F1C000D
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: sxkpn9gn5zo1orh8x9tquh5t1bzekoxa
X-HE-Tag: 1793109547-191529
X-HE-Meta: U2FsdGVkX18Vq3F7PVIG+315SOagqPGbEcgahPIiZIL75AM11aAxL6IqjTdDsvOIRGOl3SyHmvofE00FvDfcyX6QD9lAPkVbtrKww9H0FBrP014LnB8PNZXtQ2AsUYzhlb8Np1kJNN6ruKHrzZUdPWyFQlWCKZYS1A7FQwz2/v+Aozy/X17sz2UKUHsgUFM+/D5FkmJYPOnqRuAZ0WzLl7ocheLCsh1kAwRQxTjG6kALdLOpCpq6V9QGHeFhWAW0a3TVJ3x9msLuu5lN7XhF2JwxsmTlBq26rbPMYms/WFaZG5vnj6MYyU4AB08IFTbv5uPMXFly5DqVXkzytWFS37exY3VIIbaTOSooVzTlJ2GcikcCCj6HXb+2ZH1qxTG3RkQ0T0cDkrYeSwBRRnUTtCG+Vfw9/LiD6uOCpcc6bEW4x9xfw7AU3/LXvuILvLRVTG3t9YrQEqtdFMFQSpWvl8o+QxDg1DRQ6ZgtKL0E8tqU5pDDoNSbFBs0dePf7+sqqYDzvm3KBT9YOkrh8lxFuhG2pfe159u/2L+bFhzkh3Xl3msMCFzbxSafO7nUeU1sLSDb85b5Xpm7689YkVb6w6g1L03lEWaznGyvgagnpIssMgZ10FyVJXxBkfOASpLa14kl96hfmdlpFOum4Dr4i9UpQJgi8bxo0+1Z0vj5MRhtlr03Z84Y02a3IO127KE1AgcbwHcnvSDBsxNfCJwt/Yqf5ss4v2QBsUJlefiC2wjyqlDBAIChQzIv1jjWjNybxjtNMDsDi5qsEVm6PFD0207X/P5MOs7GbeqdiS6Vt2sH6r4O/Wt50yQRPLlQkvdlfFnKwJ17UUJPNrCVAIqnNIff+BQKhzrPXMQPmmNFUUN5Y7Qrw8UAVFnhfhGOxj7llADoOadQVjjpAE0OPMhA340JCGA0fcT2k6N97LGPVY5vm/pdbn10uCtdFHBVihfZlBS7GfdRFskL0EQNIad
 1Ibp8Lv8
 pHXycnZ8Gnacuq2sLumrdesw+m/YSNebqReLd2eAh3pIaaL3mr9594SqwA698UdnxIV6OY981x2wSjAIZ5EmVGeq4068KYGwxuIoVjlpDUonAoLCgFvup6wzfg9xgqG3H6LhiB/BCzlzgI6/8QXE1wIi6qGcEWtzjITJGhx0QETYttKo12oZq+6nvPita5EIEViTbPzjH9h4UhMAB8CA4VUmmWKdIwnKmq0aPlLYMiZefdKra54WcGAOMFhTT+vTZ9h6vzYyxv/iPkrtkLekhPTArGpnDVPOm7j0Nxc3awtmmTemutbcVYzdmeSmtjXybAYmmGCISTwuuaOfeM/4VxY6Os+QLeV1sS56W9aP9mC2lfTkhiAk9EFNEXP3ulJZ6ONM5MZXvybAVP0ZcdI9KoM8D1gwGPqp25yy3dMN/rrcdYQ0V2bqmzLi+oYytNlrtVhgV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 14:05, Pedro Falcato wrote:
> On Tue, Oct 27, 2026 at 12:06:05PM +0100, David Hildenbrand (Arm) wrote:
>> On 10/26/26 16:20, Lance Yang wrote:
>>> collapse_file() can call page_cache_sync_readahead() while still holding
>>> source folios locked. If truncate holds mapping->invalidate_lock
>>> exclusively and waits for one of those folios, readahead waits for
>>> invalidate_lock and neither side can make progress.
>>>
>>> We need to release those folio locks before starting readahead. On a page
>>> cache miss, roll back first, populate the collapse range, and retry once.
>>> Doing readahead after rollback avoids an extra pass when all folios are
>>> already present. If another miss occurs on retry, give up rather than keep
>>> retrying while truncate or reclaim removes folios.
>>
>> Makes sense. So we simply try readahead on all folios.
>>
>> Any reason we don't simply add a second loop after the first loop where we don't
>> take the folio locks and do the swapin/readahead dance, then a second loop where
>> we do all the other stuff?
> 
> I'm not sure I understand. You want to nest two loops? Or do you want a loop
> upfront? I don't think we want a loop upfont. That's slow and involves
> starting/waiting for IO. Fallback logic makes more sense IMO.

I'd have an earlier loop where we focus on filling holes, and grabbing folios
then in the second loop only from the pagecache + trylocking them.

That would make the second easier to the eye.

collapse_scan() file could just indicate if there are any holes and whether
looping makes sense at all. It already does a scan.

So you could just skip the loop when there is no reason to readahead at all.

This function is pretty horrible and the retry logic doesn't quite improve the
situation.

But no strong opinion for this fix as long as we clean it up properly later.

(looking forward to reworks)

-- 
Cheers,

David

