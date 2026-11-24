Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB34606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W4Z3pRyA
Received: by kanga.kvack.org (Postfix)
	id 5F59F6B0827; Tue, 24 Nov 2026 13:27:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5F36B0829; Tue, 24 Nov 2026 13:27:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BE46B082A; Tue, 24 Nov 2026 13:27:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0B66B0827
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:27:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B014C40CCC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:27:47 +0000 (UTC)
X-FDA: 85470846174.10.6372C7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 112521C0005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:27:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4Z3pRyA;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795544866;
	b=Y9q4wWgvpbCTuH0oQ4OYRO6LWbAj0AZ6eeeLLJo1GaGP2u4/8ujDo/5Mmqsz1KZ0bPmlyQ
	5Y13sst31WLnvSMdpkHef/1hTPdGGynza3XnYa+flA0EFiR9abopgg1u99HYa7XjreX3tX
	g+qKUGf+apLRYzwvXQ6956SIkFMN2H0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795544866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NnSt+5MgSPrSh5hGTfh0N0vas814GEFyC4NmY/aZJQ=;
	b=7q7mC/9Z6u1a9ZA4kwUPYnOc+vW1io0sbAmQHrCQOyAg/9GrHmsPcCYLGCJ8zN9amaR3S9
	wFZxDNQ0RK4z3g5m8ymTn6PdyokcrQV/JZHY7Flf2gDHiLX+Cy2yubwaYl0IDyaj4Z8dBf
	GmehlM8tu53tPT2qLLWeSYcrdpQleOM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4Z3pRyA;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC7AD40996;
	Tue, 24 Nov 2026 18:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03821F000C6;
	Tue, 24 Nov 2026 18:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795544864;
	bh=6NnSt+5MgSPrSh5hGTfh0N0vas814GEFyC4NmY/aZJQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=W4Z3pRyAGAKenXsQ8RQhpNCCOYrOv8BxiWZ059qbalZp3zlzhDwlm97UbaFSmAHN8
	 cIUGceHwJ1I8J2bG6ficooY7fcSULumr8ZT+4oA4Xk0HQ2X1OLlFzKdbT5ModoUdcb
	 muxJWnfO555Leiz/emOtvnNZ8mSa583PNA2az5/S0f6UKPJYbPUpYHhlXuXccWorVQ
	 4M8ACH0rHD1+bhGKupIPBXO3Ph/EOdB6V87sOT32aPLDFF8cXff16GFwwXCeYohO1F
	 qOG3oTB5sP4VUHB1TPAZwAyjsD+z/Ep0NHeBmIkrw2GdhUpmhWq+tNrR6o58PekVw2
	 xIzQ6Vq4JkXvw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Andrew Morton <akpm@linux-foundation.org>,
  kexec@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memfd_luo: don't use memfd_pin_folios()
In-Reply-To: <awXQ-sYNkY-TALqE@kernel.org> (Mike Rapoport's message of "Tue,
	24 Nov 2026 20:01:30 +0200")
References: <20261123130115.4021199-1-pratyush@kernel.org>
	<179546369651.425130.14155931836758567682.b4-review@b4>
	<2vxzo6bez3hs.fsf@kernel.org> <awWx1YnA0PcB2RaB@kernel.org>
	<2vxztsl6xj59.fsf@kernel.org> <awXQ-sYNkY-TALqE@kernel.org>
Date: Tue, 24 Nov 2026 18:27:41 +0000
Message-ID: <2vxzpkvuxexu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ho3d4r54jwajc57x74wkwyjs93c9xuda
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 112521C0005
X-HE-Tag: 1795544865-245072
X-HE-Meta: U2FsdGVkX19SpXI8jyWW8goSEUS0zxHTheSZDAtI66vLrdmQSA1w3rasIf+LNx6GnGL1l6n0yCGTvKIh86gWpyGA7WgHrudcD3LHHeQxbVyPxVNt4sM7KhzeEtQGC2LMQJNpj0v4Z7Zjqq0h7xw1l77sRQsS3om0MNXIipGhGI7CwlcpFoIi5OVcDcSN9F1G2LwT4x27+fMD/6uHM9mX+2DCgNlxSrKPRCxHrm/fgmCXIX50prQDkbI8p0CjkkAkhwmZOnTDSG7FjM/XjLix/yFV/oVgQ7p8ekRPN1hQFLA0GYeUE8zcMuktRCmq61VGlyENLva86+gWdgA4wXcpUSWEouNeiBMZwLAiRkop0Onyy6maw2lboYaW/f8HRyW5ZntOEeguytK1QNNWxoEgQOCE7Z4mMeP2immvlObfe3cqKZTveFTRcU10AYqpcFRfy8ftGCu2znxX1D+rpTpgG40RCz0k6OKvOjTRa8BKun3i8KMTpten/zzV+nvaZP8Lcr+jEaLZJlSNnE253Y7jXqbidktxdW8US/OF+OmF78Pg8LoPidvaf5hFGWERCtixnFBwfDD/zSOzhYD9XkvdmSwLf9F0r6sXLgtiBfgcgY4RjHoJxvtSNF44auy01p1N0zGzKUuVlH4rKk2aQLnQ//A66AOfnrMG7vMMpao2cTEbTazMowWz3YEu9a5uK4xGta5akVUevjBaGKI6GBsztF+E8E/6jC9U6H5ttUR7+IcTgLsvYU6vbszAHeGzmAQs7D7a14yYAbWRQrAdGLsP9LrsBWlxLMpoDFx6ZuNn7Q86pYHZ8MqBY4xxQd3aSVDLc8p6bSGAAWQvGJu6n/iUEMSyyWUDgAlKBSIzLP97y0fNpbC5/jU5BZKEc2+6vKLHjvj7vErkd+cRFZS9Te3GgyEU42Hh+pxpz+xKY1ZGbN3gR+lUJ3Vq5ZEFmSa2fou8RRKatSZ6zhl1gUt4pC0
 6KAkEZnO
 0BDqInGsg1ae1PpdlCKRpj2ga9heKBFfshL5Qeap6wdwMe5CrMqbxnrnW0aZZyHDIsdClKHIZiR8tjuEzspBLR/DaSQ5r7NJ9fnCFF9KZCoPo4ofxRY2Wj1Ejpc+GgqW5XAS/Ym4zW4Jw4yfVKhSuXRgIyxQmgUN/q1eGryY1X7oUI5sxwiQQnO2pO5aiulg37P/cpCXBLFOJSO8QmMEcWCJE0j7YJDDDQ+3WJE7ngQh824sm+BiEvCusvtJq/fb6VlsWHkX748RxOWmgNXD3iv2VYXQoBeU+eY1p1QLHUUp0ssicnfvOutefHvfLCZBKvc4wYjhTFmATPgI/Qe7O5tBhgWZrHg9aVj2dR+dfHdZVlUEHJ0apBv0mkqXAJ8+XDUcXMMLJ3r+iycmqaMahLxyCaHFAtdXv8krGRJ07smRiqy9MwwJ03pQQtKAtwMqQz6AWDF5HPEzl6UEItAgvvBoFD79sWHELUO60jOak2l1m8LY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24 2026, Mike Rapoport wrote:

> On Tue, Nov 24, 2026 at 04:56:50PM +0000, Pratyush Yadav wrote:
>> On Tue, Nov 24 2026, Mike Rapoport wrote:
>> 
>> > On Tue, Nov 24, 2026 at 02:51:59PM +0000, Pratyush Yadav wrote:
>> >> On Mon, Nov 23 2026, Mike Rapoport wrote:
>> [...]
>> > v2 was better I think, but it still had that
>> >
>> > 		if (err == -EBUSY && ++busy_retries < MEMFD_LUO_MIGRATE_RETRIES)
>> > 			continue;
>> > 		if (err)
>> > 			return err;
>> >
>> > which I don't really like.
>> >
>> > I came up with a variant below that IMHO makes things more explicit:
>> >
>> > static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
>> > 			       struct folio **foliop)
>> > {
>> > 	int err, retries = 0;
>> > 	struct folio *folio;
>> >
>> > 	for (;;) {
>> > 		if (retries > MEMFD_LUO_MIGRATE_RETRIES)
>> > 			return -EBUSY;
>> >
>> > 		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
>> > 		if (err)
>> > 			return err;
>> >
>> > 		if (likely(folio_is_longterm_pinnable(folio)))
>> > 			break;
>> >
>> > 		folio_unlock(folio);
>> > 		err = memfd_luo_migrate_folio(folio);
>> > 		if (err) {
>> > 			if (err != -EBUSY)
>> > 				return err;
>> > 			retries++;
>> > 		}
>> > 	}
>> 
>> This has a super theoretical corner case where the migration can
>> succeed, then the folio can migrate back to CMA by the time we do
>> shmem_get_folio(). So we can loop infinitely.
>
> Oops :)
>  
>> I think the if (retries > MEMFD_LUO_MIGRATE_RETRIES) should be after the
>> folio_is_longterm_pinnable() check and retries should increment after
>
> Maybe after folio_unlock() then?

Right. Sounds good.

>
>> every migration, not only failed ones.
>> 
>> Apart from that, your variant looks nicer.
>> 
>> Does that sound good?
[...]

-- 
Regards,
Pratyush Yadav

