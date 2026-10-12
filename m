Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34915CA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 19:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085E16B0098; Mon, 12 Oct 2026 15:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036CC6B009E; Mon, 12 Oct 2026 15:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67BD6B00A6; Mon, 12 Oct 2026 15:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE35E6B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:06:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50BDBA94D0
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:06:05 +0000 (UTC)
X-FDA: 85314904290.28.C3576A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 90FC42000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:06:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJOwxP9F;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UVup6GJ/cJrIO5b7tQA3kWhFihBuF5irLWCeT7h/2o=;
	b=X1s5JR/TUBcGYDPjFD8Ql/a/W19cNnlPJYLkxlr2lAZFbkqqrXRH66OkzWwhoe8jDXQdMQ
	jtQNJXxm8KcRBahdDimy1FtzgpxnSvg8NquY0njOicY3jVFL702eHaF3Pyk/7UB878jgtV
	nM5yRUJ4eiNld8g+D+HcWrOAmdMujwk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831963;
	b=nfXlYcHTxDLmNYjKXbTFxDSKufO3LI39+16heeslujkH/03G14RICHlhQSrPO29uw9MCpe
	6y6yE7XvJ2JwDgTFOiasSxAKcguozvLHqwRTZvbX4CuscG5ApYeTIccaBTBYBZP+V18VW2
	T7LQVM8hcnppNQPYKOxjpwX8RKcBuv0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJOwxP9F;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1247160258;
	Mon, 12 Oct 2026 19:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318391F0089B;
	Mon, 12 Oct 2026 19:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791831962;
	bh=3UVup6GJ/cJrIO5b7tQA3kWhFihBuF5irLWCeT7h/2o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PJOwxP9FzjOl86X9NFuqd2aiJNaF8iCTgTaKo7xgxX/QyzJpD81FRZrQ00pX0Yzis
	 8ByDxuzFiszwHnWMP3tz+0nubZWpFI1oeVaqpqxnHmC47CJ6+1S0AImp1LLYYmyzjT
	 CLPWJnT/RezJM5RB7Fva+S8bFuY7p81o/NzmH8HgY6QrX2VLrCiy//wlwWfb0hIZYU
	 AGzjrCzNpXdd/lPFMVH7F1rIwxN4tF/gr/5bJKPG8gLEU3cOSlqaxr25EQ24ost70T
	 pWWkBNhxTGMGZiPZr/fvts45XsnbITMiRGugctO9i4k0V+PQLfoebUapAYLGO20aRh
	 IIh5SRg4L7ubw==
Message-ID: <c3c6f83d-380f-4a9b-a204-fd157ee77648@kernel.org>
Date: Mon, 12 Oct 2026 21:05:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
To: Rik van Riel <riel@surriel.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Aristeu Rozanski <aris@ruivo.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260917083747.786-1-aa9736195201@gmail.com>
 <7dd4ec994502233cdc09fe5c4369adc89168d738.camel@surriel.com>
 <20261010195202.689-1-aa9736195201@gmail.com>
 <ff62aeaeb5ced49640c959c047b2e9f320f5c10f.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ff62aeaeb5ced49640c959c047b2e9f320f5c10f.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90FC42000A
X-Rspam-User: 
X-Stat-Signature: wda5wr7ntzybmx97boc9unzjszjs7sgg
X-HE-Tag: 1791831963-991636
X-HE-Meta: U2FsdGVkX1+LZAqEBLNVbkaoUMVzJOKWTumq3G5dx9fkGBxjIL1OIQSh5qtL3AOm3hzYRFupIwejbG8i5O984b83xcAi1E+rua1WIqJ1tcPfP3jen5awU7hwe2a9LbMNjtlpwcjEkZZhy/NnIbsw23Xzy6vL/cIULzPOSdSexHSqGj6/E+2Dmf+PY9FsZDOkAhcdw3oTkN6WlV+mTum84mBdCVb4rPWPl6otAO3LxnLyGTaNks/cX3hkVBOwv62y8QSwXJUHTpXIC5a/QL5gqKwdjfIoESC9IQj8mjarn194pIYf5D7FJ352sPyzGvb9su2IUG3sZ5Aw0n/TG3tamTssZpSFHLvjJR0dfoH4SVqZOZZOkF389iAwvwZhJOtsZoEFG3CZpwB0XYvRzb/wJnCiwuLsOpQnOMAsNnSX4nTY5wDqDhFT1v4nERhdsJjYxroz+IVs69bl4l/IKpNGg6/h2LAioECY+l7FZTPlfYsI9+KS3ht6H3tguqpvjDHzCGIyOEqmji98rqY8nXsgpBluQvnQoXVkpbSmhfYrjPKcWbJgc1q+DV/PaOBdDhbPMoJlLvPHAoc6r25+uTAMo+gjIbxMDmm90FctHkDI4UOHqOIuh7y1JIxnt2jP5kQ889zMDz87yVGtuh8QI+tlukbfnW1V76yj5Hm4Ara3VkNhAAlGkdG9PDbvRhSai0SWy8tfPvNndcgc9bTlL5/n/a+pd6/Xft51dVCT11mqezGQLQhiU6klkt3KEp+Bx4+30y+tkmwaW9l6EKPVj4BqsWBFYBH3xXeA1w9tn0HUhm/e6ptj6g/Gs97wat3YNiZefEoi0wAr5WRUVY2DyZ8D+xGHwBPEtbt6ITuKxFitoqLz/qbvppjuK6geWuf7OVGp8Cr3gWRpaWFVS3srK0AIw+xE0IIFHw2IIUaz3FAOIuyaaKGjkZe3ar4dkqxbmx3x3aem4ZNYwqy9bKQ8j80
 jGhgwhrU
 atwr4KzDlz+boR28OAQOTYNBoA7MulzmX0ojMq3O83TkLGJpXkJ0xifeVoXKDTgSi9ESOgUvTN04njvnGJjN2fORgoQYSDr4lzlHdKBNcMMcYNDHuP480FkjzpYMd92CoNEDknDNNtLR1cmTwC7itUbExICBOH34zUrXh8d3D0z2lSe42LQ4gcxjFol83McE5Vb4bq6ctm1VzDKfeK+wG0JlqdePhDVP1M2ZXBTBqkWfmGjfIdphDUE40x4NS+ZWvTJmuhjGvHP+0ci+uPAxfP4m7lufWt8rsxDKPSCHJNy+yZCAsrU/kUA/SocaEa/MSPNl42Cd0q+1cZh6jYB/i8ppZ+0SQAG3xL4IUMJPYNy0Pd87xPFhgQ7jZMCsirY+S+QiRyJlErqLOUV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/26 19:58, Rik van Riel wrote:
> On Sun, 2026-10-11 at 03:52 +0800, Yuan-Hao Hsu wrote:
>> On Wed, 07 Oct 2026 06:47:06 -0400, Rik van Riel wrote:
>>> Since this is lockless, the PTEs could change under
>>> us between when we walk them in folio_pte_batch_flags()
>>> and the batched try_grab_folio().
>>>
>>> Is that race condition safe, or do we need to re-check
>>> afterward that:
>>> 1) the ptes still point at the same folio, and/or
>>> 2) the folio still spans the entire range, and was
>>>    not split before we grabbed the refcount?
>>
>> It is safe, because the batch only runs after the first page of the
>> run has gone through the unchanged per-page path: the folio reference
>> is already held (and for FOLL_PIN the _pincount already raised, with
>> the smp_mb__after_atomic() in try_grab_folio_fast()) before any of
>> the other ptes is read.
>>
>> 2) With that reference held the folio cannot be split:
> 
> You are right. The page tables can still be remapped
> to point at something else after gup_fast_pte_range()
> grabs a reference to the folio, but that can happen
> no matter what precautions we take inside gup_fast,
> because it can happen after gup_fast has returned.
> 
> I have no other concerns, so feel free to add my:
> 
> Reviewed-by: Rik van Riel <riel@surriel.com>

There are a bunch of things I don't like about this, including suspiciously LLM
-sloppy looking stuff like

+	if (!pte_write(pte)) {
+		for (i = 1; i < nr; i++) {
+			if (gup_must_unshare(NULL, flags, page + i))
+				break;
+		}
+		nr = i;
+	}

I'll find someone to polish this up.

-- 
Cheers,

David

