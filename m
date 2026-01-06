Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DEE9CEFCEC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882436B008A; Tue,  6 Jan 2026 13:40:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D5E6B0092; Tue,  6 Jan 2026 13:40:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F426B0093; Tue,  6 Jan 2026 13:40:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 611506B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:40:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 071541607F1
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:40:16 +0000 (UTC)
X-FDA: 84302404032.18.9F61919
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2629EA0015
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:40:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bACpOAMr;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767724814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7RLsnELxKTpYCw18WSM2EKoT0NbUqIQbS55fjmkm9A=;
	b=Y6sr2u454L60SkkcoE8ECpJVy3ArQTGB6TvFG8lYz53tfC9zODtLZo9uI1QtKmsRBGZ6HR
	eldUoZajLx0eHeaIqgQIdSs+R5hW3Pv3muXKiq27Yc8uJyC1GDMZbxitRuhbRScZNKhfbd
	kImg8Ee2hWcft//yumAT8TQ9SkuW2GQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bACpOAMr;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767724814; a=rsa-sha256;
	cv=none;
	b=OV3f8q665N4LZUHJcin7J/r+pwI1ohJLvRB5MjEpP9VZuG/3dbvJrPDi7Mg0X+3rCRWTgn
	Pyv2vsFjLbOVWota1OGmjAbDjwZt95664wqHnghOhcWj71kRqdSs0cAiOFsP2XT9Y3IHAH
	PljwGO5DasKLFAsp6Ajwot1AUUjPk8A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE251417A2;
	Tue,  6 Jan 2026 18:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AF1C116C6;
	Tue,  6 Jan 2026 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767724812;
	bh=JuwHakOpYpMvCGfqvDnVgRv8J5uE91JaqwMAzOrA6yM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bACpOAMrbUq/wRCabMMdWiZ5CGJf97djDVtqkPT5O9EE9oqzOR1pgJQ9SOl+VY03U
	 +8zdGBJ0Da2ZFvf8A6dyTHLtIGfGdnDL7h4ccV4M8RUHmtfsJabxPQ2SV5hctOWtLr
	 +2agB1XXt/MNQ3BpJakEfrtANJaauDQyTqDf8e/5PH9wKy6LNNt9h7K0bKfwfSrL8h
	 IbJAnVoP+qSFUQ3/EUN2eEx+JW5Om+Wc999Wu8kKV8Ouxxf07V24EPY1Ji+goR97Xe
	 66QxULwYV/wTaS/g3XgrxKKAsdaaMjga4uoMUPaUhtWm7ZC7hQXfZyzCWW5LBLqhBG
	 QKDVE3JsPcP+w==
Message-ID: <41467ff9-46f3-4937-ae96-3bde178a63af@kernel.org>
Date: Tue, 6 Jan 2026 19:40:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/testing/selftests: fix gup_longterm for unknown fs
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260106154547.214907-1-lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260106154547.214907-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2629EA0015
X-Stat-Signature: x5nkrti9qr5amatoh1wk1u7m9e86qwr8
X-HE-Tag: 1767724813-239845
X-HE-Meta: U2FsdGVkX1+R2j3CnVTW4BR+8XTf0ODh+rotg1+a3AuXtnZegBedHUyA+uwgboQ9St5rzWCIeK1Arbp2ZWx5JcQ9IKX/qy1evLqtqP39qXiSq0Jds+hmUqUfA84ybCfPluldkz+cPKOyctZM45RrR/5Pk4h4B6amRoLed8xTsK6miopc+mHNDjif9ETNnqtNtmAR5ShX6iy/5CZLPP2w0p2OAUFIqkNZ/55CTX+Ii84ggJHC+1uq8y8LYftYv0fhoChgFUFbTknHqMm5da8QhjWuNU1GInmsxxQMERfI29kUApdJW3JLveLejv0sJqHsUDpF644P+Mydh+GlmUUuIeSS6FhZBZJaqQLtVlQgqSz0kwYCkGs8SylhCgi4H7P1IktzMjXV9C8guE8fInkEZPB9ws02YiqGiYbp5ZRh1FkP3L2Mo0TZXWvJ+uy84J7JOKC6MyX35CLu2DP5uRM8bkrJ5kEGkIqC5Bs030htMDkpepDrjKrNNoqhlZP5UFzHNIbWROU2kdFCeLZKcr9x9gt5ahgQ6d3m7oNgwJ+Wqv+nqkwQIbzslAuydevhVSc9O/Fsmr6DPJ0hwa2yR0nbqxwWJOSfqvgx5SUW6lJZ1Jvq0Gnt0WfiXKRhU6eSCklhbwsm1ymToozlO/un05Cak3rQqFvT/rCHq1hNXqRtQj0XpT5N7Ik4Y/928GeZAOH8rwH+5hmijFEDtjA1BxY6xbl7SIrhYY6Ldsa06qrWmLKhflRc2ab8LMhbnw3Q5G27e8BstZzl7t162SmUIvdeo7OpSz+wcJIv2IymVX9FufgJtmZAXK8nA1itFXqiGABXALNY9rRLyj4iedZUm5Qt+sVW5zmKRClcjwvT4hv1oqIwPrpuZPZf+IG80Lcw9JsTgONXsg1ItM3Vnqh/CErMkPdPD1IeTkPeZE5UlilBc9n4n5H/Gx+ZGLTx1njBQGsei8xvvz4K+KW5+tyR1SZ
 icTLrioT
 3YnZtZpTmrNqvdd9dYqSBd4pajgOEuGI6NYeupG/U/To9/7kF4eWHjnmjTj2pojSNol5ilDilhXhTAvhaJczJi0Z2if8DV5d8qNRfcVZbBmtFG0rTREiEEY52INLw5BRmaZ3URJqhR+DK7kpDNMfKmKwvnhdBh3jHFGrUEGvAC0DoDAAucVx25fR2pGRCGD4soeSrfFcTEMztJblOvcfSuGfRvVzztHAYzwp2E/VzVFq2AzdTuWtzpBfiUbVd6JemzdPXJtyomUzgqnkocEC6+Zpv3t1Y5sBQKmFdpzsv5f2+8HocerrL54e8ki2DQ52dNg3DTBghbyM4QB2oGIi+yB4Abme3p8rdFDuh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 16:45, Lorenzo Stoakes wrote:
> Commit 66bce7afbaca ("selftests/mm: fix test result reporting in
> gup_longterm") introduced a small bug causing unknown filesystems to always
> result in a test failure.
> 
> This is because do_test() was updated to use a common reporting path, but
> this case appears to have been missed.
> 
> This is problematic for e.g. virtme-ng which uses an overlayfs file system,
> causing gup_longterm to appear to fail each time due to a test count
> mismatch:
> 
> 	# Planned tests != run tests (50 != 46)
> 	# Totals: pass:24 fail:0 xfail:0 xpass:0 skip:22 error:0
> 
> The fix is to simply change the return into a break.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 66bce7afbaca ("selftests/mm: fix test result reporting in gup_longterm")
> ---

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

