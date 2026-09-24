Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 383A2C98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 11:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0976B0088; Thu, 24 Sep 2026 07:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072C36B008A; Thu, 24 Sep 2026 07:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2566B008C; Thu, 24 Sep 2026 07:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6E9C6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:32:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CCE9160327
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:32:34 +0000 (UTC)
X-FDA: 85248443028.24.3FA45C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9772140009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:32:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XSoPi3ry;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790249552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQj9D8x4oEPB7huvIPsbaucEe6zKoS2sjeEUT0tAQCI=;
	b=mN4Ty3OVWxyLWQ+95a/AGNcCcZCbwafLUM1NrEsfBG1v1cqIYqAEqhXQpRQvPKqUWfrHYk
	vMxI3ayBBaFJ/wIe14xZ73asl1TLM0TehR8O0niESUnQql0ofi1znR0uZp+rbw4J44AT9A
	l5++9oLRdHLQoou9t87w8sGINTpTWqA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XSoPi3ry;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790249552;
	b=DEFCU+rItLPs/FrYjQ6jNEIRV/K5UoOk5btQvuj27FznYbOTCyoZFBhkQleWlj8hA6p5qU
	4s3bgh+oOkphaa1I1BgNHkW8g8C+DKynT8WlWaiqCp7nHVRDI0FS8Y6jaxaqgf8LeD8pTP
	GFzT4H3Mc/cXPXQIBOYw51x2f6jWHC8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE484601DE;
	Thu, 24 Sep 2026 11:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D2E1F000FF;
	Thu, 24 Sep 2026 11:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790249551;
	bh=cQj9D8x4oEPB7huvIPsbaucEe6zKoS2sjeEUT0tAQCI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XSoPi3ryBulL5yHm+JAZdpDmXLrr9wQ1M3T1ZlEhgWVgsGlYKjxFDZBFvYCZ7nsOT
	 H3ipKCg+yeX9+ER9/1OEaMf9qS9tIzofbR2CD6T+XXzQ+VbD+JE/uTMJA4+7/wTXhC
	 Wii4PSEJUEfEq4j3cwHX4HkKmklrqUyTAEJKTVAmAifjnzRkTbU0IKQWdOOkZ093eD
	 hcAcNtr8uO4q89+C3cs0DaJ2k6Vhjz4ceLsgzs73AEDX96WEYw70NA2dn35QgyvHS7
	 Y27tHYQhwBsJMr9Y38I9JakIxF6rICjFL1qvNuC3vzo/IRLtVWmr8Tjw6sbFh5+Etl
	 7YwYR8c534qAw==
Message-ID: <e459d3c9-ad60-47bb-8b02-bed3819e8067@kernel.org>
Date: Thu, 24 Sep 2026 13:32:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] selftests/mm: exercise MADV_COLD and MADV_PAGEOUT
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 jannh@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-2-gourry@gourry.net> <arPgwegm8XgbEUrO@gremlin>
 <arPjwPwVxdvdR5S0@gourry-fedora-PF4VCD3F> <arPl6UhNDbwds4uR@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arPl6UhNDbwds4uR@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q5ob53o3aii8aqfyfijhyp9irg9kudta
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9772140009
X-HE-Tag: 1790249552-829547
X-HE-Meta: U2FsdGVkX18KAQ/At0eRTQaukTHhGzTCDFtlq7e90GHWYK/Skr/tXOO1yueI5vn3GyIk+cUVXdraRKDV2GGGZL98X+CUca9JIH7RZDlW4lhr5xHGIrW+f+L2IIbtWzC0tKHFoOZMF7/z5q8nc1wFErgtq/dVSiLHlZnDoXkaBEOLUOd/32jW/zmadxs21FNeek/9Aq3OHu4D4AtMtMknilwrDoqJ5H4SGoiFcaJr77jBrZInTt6gFZp2dtmB9ll11yU63V/eEa4608ZDW5bWhD7qmj6RATYjpg9C/D81RXibJjLtCQ+DIf1VYF9J9JUsEE00jpfF7VNUuTCF6pyGZzWbDZnCLv7VxQb4jhXCqsUdyMY8rpZLmQtZFkqlqsPDTPK4Yz+o6i3Nnh8Nqo3GdxQEL27/oR8k2vpmISZOYpJ5rKIhvs6r5SphXQ36/zOBehy6aCA+PW7gLvNoRuV5fuFq9DRngEyKhtcLaae01s9PQeYF/vahbVd4UQFrtjkUqtnTNKidz6ov/WoFNUR0P7xE1XRr553P09pPQQDARSaVsB5bO34+8j0iJhtPVABwkWwi/sAtBpm44FWmQTKTjvkyVI9sWYCmpi23v62Blvq2zxllcFl81JGICKuRb6Wxiccq6BoKo1yGNpkqxjZZnPHfg3ij02xQmJywNW3VIzwu++O36ch5F1W8JJH7UMHLxIA5BKxSPX3SoTZBuCpXpWj1rkgcrZYL2LH3PmC53vdSqCs2GKlCGNgH+Gc1ddnCFx3dgglSFXLmDmx9tT9PnBRbYtS4I0DqJR1lra/3S8opP7isCODsa6j2M6OLNqGYFXoieJeWA/rNf9KfMA2APvLviXybW8/73pfJ27VdFJ5LqV8boq395at2AajZK2epvIXLcezsJyBZ3jLCFfEiuW/4ZkgrRnEnqt1LSXwN5G0+WKf2Y5agRvrO/UQUcPLXGZQs+vjkS7Pt1n3UAdk
 O2Ge/tnx
 GDZ7+8Ie6OjNktgZhVzVMfgqZzIcS1tqgr78mZneXzxHZXYWHBdlKBYchEL6XMogyGOUJQvnklZZTo63zNpG976CviA1Bmomg/GF6OCV6yOLjW1Q1+FNFV1DzQABvZ+X7wfAlo7enXIrGC2N4vy4u9ULxBRrnTeAjKeilDDZcNPmeruspgVhB5ePJlYmx+SlfAdC9wS/pE5uI2oTmbGO6N7OthJNAT+guYteHIUHfn+vO8rnSNyZcNpa+mJsodSOf/RfO4afg6Dk0MB0slbIQH424gyIaOAHd6Lb+Gcsa9jrhQSAsjEmjLcZmDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 16:46, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 23, 2026 at 10:44:17AM -0400, Gregory Price wrote:
>> On Wed, Sep 23, 2026 at 03:26:05PM +0100, Lorenzo Stoakes (ARM) wrote:
>>>
>>> I think in general we want to avoid putting stress tests as part of the
>>> selftests in general? Or at least if they might take a long time to run or
>>> excessive memory usage, etc.
>>>
>>> Though that might be benchmarks, as we have the THP stress tests so maybe it's
>>> OK?
>>>
>>>
>>> In any case I really do think this should be split out into smaller parts, this
>>> is a _gigantic_ change :)
>>>
>>
>> Absolutely, but alas my poor email hosting throttles me if i send too
>> many emails - and sending a 38-part series where the important part is
>> the endpoint of the refactor moreso than the individual tests...
>> instant 24-hour timeout.
>>
>> I'm working on a solution.  Need better hosting.
> 
> Thanks! But yeah damn indeed you do! :)
> 
> Though larger series can scare people off so maybe better to send the tests
> separately?

In any case, we have to break this down into reviewable pieces. We neglected
selftests for too long.

... and there are some schlopped tests in there that we really shouldn't have as
they are way too special and hard to maintain.

Like this monstrosity:

+/*
+ * A folio faulted on another CPU can remain in that CPU's pending LRU batch.
+ * MADV_COLD drains only the calling CPU and must safely skip the non-LRU
+ * folio without changing the mapping.
+ */
+static void test_madvise_cold_remote_lru_batch(void)
+{

-- 
Cheers,

David

