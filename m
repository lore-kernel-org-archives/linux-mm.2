Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B30CF46139
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609CC6B0005; Mon, 23 Mar 2026 11:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BAF06B0088; Mon, 23 Mar 2026 11:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9DC6B0092; Mon, 23 Mar 2026 11:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35B2A6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:36:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C871B8CEAA
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:36:45 +0000 (UTC)
X-FDA: 84577730370.14.82E24F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4953340008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:36:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LPveT9Ur;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774280204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KF/3WXwKkyZDcM6v2/IqidgBEDdB/FQUwBEeFYEQC1Y=;
	b=cmtSFkT4sFLTlHt3ovIldBjSakMhp7js84EagJ14t4MmrUrpoCyLyC/Lln4uRfwkC92bCy
	eu8Xe+6Y8XDYoSo9LRbiR68ZQeRwH7C2WcQpBpZf87bsOFLTrpprThoGBJz7SJgNZpD5SM
	+kU9EAwGeMb+3roPpcfVZBXIgvdDgDA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LPveT9Ur;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774280204; a=rsa-sha256;
	cv=none;
	b=cSGnNN3wAevB9U7XEPt91dgX2VgUKJ1uNQLHfcPzwf+Aw5jQL5GQD2Ug8kNwY/thaxSoH+
	IdEn5mIBwjyX6t9hEmZMHRpykIO0FC+CgOJpGE2DEBAAVPTM6VBGb2mZ5g8gcuUCBbqcw6
	gbJMT4Kj1PB4zfCR+h5H6a8SlM9W1Fs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E4B860120;
	Mon, 23 Mar 2026 15:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38000C2BCB0;
	Mon, 23 Mar 2026 15:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774280203;
	bh=U+7vQ++CbmfinVjKRCq0Y3zDBCJ/+CEzbIObg4EPX94=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LPveT9Urjc+4UqwcaRKXpV17zr+i0qK81azdCcjVVBiIx68P16OWM9paBN442M+/2
	 uyT8wUCsI5IEcHRy7cKXB6Y1CCFt6f7X5rqD4BQ6cN+Ij7Ivek0qAgUL+r5OnBAvVC
	 etTdz8A8A+IEL2GzlS4aCzbl3XK9bosQWEaBkYgtdWvA2SZcPtmIqZdciCmtylxEPr
	 0OMALem7aPonf7ix1cfmgvs4lNifKCqiLfWOnozn9XybHhYwBCbAui6geisnTnJapR
	 EEsk8kbbjCN17eYnpyouUjgGLpzcYO70CF/D1+Z5/T6RnRElVPrjYowPxfGzq/GM37
	 rRybXyPTTuZPw==
Message-ID: <a6f19c86-4c6a-48c8-9dc6-26f66bb6dd88@kernel.org>
Date: Mon, 23 Mar 2026 16:36:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: rename PAGE_ migration flags to FOLIO_MF_
To: Matthew Wilcox <willy@infradead.org>, Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260323141935.389232-3-shivankg@amd.com>
 <acFSTlF0epHIrA5v@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acFSTlF0epHIrA5v@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4953340008
X-Stat-Signature: gj6o5sbaqufohq9rab5dbtecrrstazk6
X-Rspam-User: 
X-HE-Tag: 1774280204-975262
X-HE-Meta: U2FsdGVkX1/PCCFJagliC1otwRt88MQj7icWl8mU2gl5J6Zu0880JEeJqzl0TdliBiY7vQ4IcgSRNHsjd6nD2cX0S57OgG4gF1bURFIZwxmUWqdd3Y63Gg6Bf5ARnZssTY3m2h/WjZ86FQiH9MLxHqyBERBsU4PXuoVobb7h6bkEa7AGDisp97uR0BaU1HOsa8ljh+YC/PUYJfOByLzmmj/XgV8kvNpMlup5z1I3bMQ6FiaQlpnXxrtuy3jKEOTpE37UcJLfblrCbnsQEnYVb4WgUms8Ak/Q769RapHMcS+FO3YIKcMDsJR73Z9ftpEJC1/PveYD5RXZVGV9JG53zrlkzmRPIefzg8lhDrGUkOC1hgVJP+9K9LOQjr1ZlivQy7DW8o1f14M/oHg/+R2qHd13MlrYM15F73r/jnNZfatVy7Ll4buraFr/1+jwUH0SRwjbrkIvMXGmLn074kiOxbtBBi3XGug8XXV9vP/vAqIH3N8D9F/dPq/Vz9R+oBiWllIR/mqLLXhZR/2CJbWgoPsYeAajUnYrAkjTkAQiG6cv1m/OYLhrbZkdlGCIhGvhZgiuNJglwjM2MstaZXSqE2ydnFpbuX5mxx8vFvBJudDsOy7Rur2PWa5gRZktWxMT4ZgC+Ajq9FJcdz77BfEbnMXtJMf/32OV4r52QZU1FnsMwnaTIQCZFxGTm89Nv00Vrk8dnNh+Ryr2AL32EOjDdmD2fCulJi7YnSB7yY9y9o5M2QyIYpcNStHdGvsJA89DZml5bTTxnwYstKpZYjC80uQr3uyztZIrEgR3mMjbjkBjT1HdLeIpgjdG71yGQP4gsfqkwvY4xttdY1mbVkMxCw1Xe1Rt4O75fF/zCGiVpgB6tcYSSqWRBxGxepg5Z2wg9RQC3RLzhAop+ET2tqHms3kiMaqcOwfdQKU98fHxH+0bf/vx3j9mPdR/qoCDZsqAaWH7iO67+Oroek8CcW4
 ySH7ZmB0
 uuET9y8Kdqkk6w7f+bJJJ7mdcDAmuxmJkhxLrj4LkLtuyyeVEHqgVhX0vmxsMO8rTWkn+S8Jx6L8jURc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 15:46, Matthew Wilcox wrote:
> On Mon, Mar 23, 2026 at 02:19:37PM +0000, Shivank Garg wrote:
>> +++ b/mm/migrate.c
>> @@ -1135,26 +1135,26 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>>   * This is safe because nobody is using it except us.
>>   */
>>  enum {
>> -	PAGE_WAS_MAPPED = BIT(0),
>> -	PAGE_WAS_MLOCKED = BIT(1),
>> -	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
>> +	FOLIO_MF_WAS_MAPPED = BIT(0),
>> +	FOLIO_MF_WAS_MLOCKED = BIT(1),
>> +	FOLIO_MF_OLD_STATES = FOLIO_MF_WAS_MAPPED | FOLIO_MF_WAS_MLOCKED,
> 
> what does 'MF' stand for?  i mean, presumably not the pop culture
> meaning of MF ...

Migration FLag

> 
>>  	locked = true;
>>  	if (folio_test_mlocked(src))
>> -		old_page_state |= PAGE_WAS_MLOCKED;
>> +		old_folio_state |= FOLIO_MF_WAS_MLOCKED;
> 
> I mean, this doesn't make sense any more.  PAGE_WAS_MLOCKED is a
> sentence that means something.  FOLIO_MF_WAS_MLOCKED doesn't ... unless
> you imagine Samuel L Jackson saying it ...

:)

PAGE_WAS_MLOCKED was suboptimal given that the names overlap with things
like PAGE_SHARED or even PAGE_IS_PRESENT.

So using some prefix to indicate that these flag belong logically
together makes sense. Even if it's not a beautiful sentence.

FOLIO_MIGRATION_* could be done, but "FOLIO_MIGRATION_WAS_MLOCKED" is
also does not make sense. FOLIO_MIGRATION_FLAG_* is mouthful.

-- 
Cheers,

David

