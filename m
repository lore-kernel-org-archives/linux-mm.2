Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696D6C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9346B0088; Thu,  6 Aug 2026 10:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663A66B0095; Thu,  6 Aug 2026 10:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52BA36B0096; Thu,  6 Aug 2026 10:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B60D6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:59:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D9111C14CA
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:59:39 +0000 (UTC)
X-FDA: 85071153678.08.AEEF5C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C738B40002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:59:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UdH/8crR";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786028377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAc/ixc4pB4rU1LFa+/tJWEikmUaJ8YfmcAssahKdXY=;
	b=B79LevntVhPoldKOQMeA+NuhXWbOGfKH+ukAgPrLcbWzQGyikbKsr5IH+ObluciAUFwVyt
	ooo3z+/zBBy0JIpTVFQGoyGRhksuUt0P2a5kc2oxnJDP7DDwoyRqjLylswibhFuPA7yYuH
	wDLr7BN0TQzHyIEQgYwR4A9XfHdGBt0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786028377;
	b=wXu9oxZY65Xy2ybP11dOYCyEPwIvW4+bgIG9GC+yRf4z+zhj9MNSXvZ4dmn7kHnwyo6PBm
	BziGcR+FddmcKW2ZOrcst7q2QSCPSAmAxSpcCaCjxjh0tVMTVJ2+/33qL1fhIGPe7Kq56F
	eFziIZ8zHP807hOmCN8vAXzIBixe1b0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UdH/8crR";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0ED294165C;
	Thu,  6 Aug 2026 14:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05E21F000E9;
	Thu,  6 Aug 2026 14:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786028376;
	bh=HAc/ixc4pB4rU1LFa+/tJWEikmUaJ8YfmcAssahKdXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UdH/8crR1zBkgdsKKbbyWfRIr93uQyaJXMfnN+YS5odvmmolZqutHTLd4lWy1mIwr
	 iHHT7PDxB4iAxe3D6/SP9hhVOJtxT4vv/P2bq/dbEyaWoNQlmDcfOwq+8LKMxA/aCW
	 6jEkn60LOxae7VFAQI9NsIemji1q8UKxK4OP2yrQQDRP51NYRms5yec9m/6iO6xJ8t
	 gsLQ4xrjJPcGwgI0tYeFeuhlnc4lj5Y3sSXF2SR7xuJo9fMwLjsAFeQY+x5jv4CpEO
	 nhM4VZzFJ0tBJ9ysQnPDuZiy3lIcX9d98s/2O7g2lkm0YFxDElGe3Y+0YGwDVoHeEG
	 X8BMUraYAFiaA==
Message-ID: <35bead51-e724-41ee-bea3-cb930c11869d@kernel.org>
Date: Thu, 6 Aug 2026 16:59:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org> <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
 <363d24da-7324-4ea6-addc-453ef468f1bb@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <363d24da-7324-4ea6-addc-453ef468f1bb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C738B40002
X-Stat-Signature: ek19h41kwyzf38dm7tcoy61ejzm7u4wb
X-Rspam-User: 
X-HE-Tag: 1786028377-311187
X-HE-Meta: U2FsdGVkX19SbBjZXlK1XI/T0ytY3oC/V3mRu7reeMYg7jjyCupVKCNz9+0J2rWYDiWONpvDz+vL7TtMLi0e+TeN1lst6eebtWiapkVbw6E9gvof3aDMMJzGIpNrfa5Z+dKTVgm6pK58V1CpeaHnbvOmUMqAsx9kgpOT2LQjInL6EQrvtvkHAV6+7oL09fKLq46jnSEsng9Jr9ptEsRXDejF8x8MHxSy3qM8Z5kYhK0UhDy1lz4KQCMmwUc0NQ092L6NXbqrDXTCA9XsowS8xhQ0BBmzoqthUnTQmpVS8XwxtbGZKzIyT0Dmtpg5mO89qjJi7M6dD/mXq2LfUrGK3a52bYAuYRelcBr4FJbypeu1JCg8PiVCIcSz8OelZGYso9XtIfWmDB1oADd9j0SRmZCvUg07YQZS7s/VQGiy254nZSaoRQYbWn1VnktIIaO2CKVd6utSSbSYhtf2D1Yfu30xEyCN7qjeKCJZ6H3r5MU0uKJdqyRwUoiGknVyIHBAkQrdkzm/9tUS/TTm0FEnL7Jj/tTomLlOlb3jOeIuxLJmbG5uMFZQrGM3cCs5pMukOTITWGRceEDYFLg3iCsZxb9QQj68psNxe5vyNEQ/GvPGs4HIKVC/MlXmUXJmMrv4JAmPSDaPTKiCXOP5tsfzyKOaLiiJXCOi0yxRr5rFjTcSIlOK0iSIJsyAHQ2kY1xIoz7f+1ePcNL6Jp/Ng11tGHsAoXYAbnrHHEUreXxeFbdPopA2qRjDEww2LRDob+zGuAsob0BsOjaiJ4e3L4tNXIOCcsTt89qOAtj9u9N9Pt73izZs+mPJlc3QtyIuy200deeSLHzZ2TH8Ww3jc88+0mDiIABbv0E+ezgHPlSPt1q0QBMvlrNswxUVv2QjWJ2KJPNW1j/4mCFoUvzyRfL6nA6i1r67Gu2s4YNz5HxnKavmi3n0TCdXsZol6L8YK3tzUKhL9sNAEmpQ6oCwANP
 b3v1n6Eq
 ba8aCcGVFFiqGxoFqjP8vM150YssBuDpXYWr4Ywg3h+rMQ17mv8JzxUKuUGCfwagMO2Rhi6YXpuvUqsFImUirYuZaiPoxU7HB0IZPHp6XJ1cEFKCdSsa7hZizeNH+gq8Q5i1+0495TNhvzAQLMH0iAmIt/kVm9MmfEsojjhT5GqsjgLcz3kV0HB83g4yuTgySvEj7wYDKyERRRlPT/yaxxscZVSke+fd9X8Nh6oLEJqtWk71fn33pZEFQ+3Jhb1BTC0KQFt+AJA1AUAamMfeHte1XujHKzOMbGpKz6J4nsPki0IvreDr2KgrGwy+8lqs5Is39xW7w0jZnPDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 16:53, Cédric Le Goater wrote:
> On 8/6/26 16:47, David Hildenbrand (Arm) wrote:
>> On 8/6/26 16:42, Cédric Le Goater wrote:
>>>
>>> There are quite a few of these in the code in fact.
>>>
>>>
>>> It's a one liner. Good enough to raise the discussion no ?
>>
>> Just to be clear: Unchecked AI slop in any form is making my life worse every
>> day.
>>
> 
> Point taken. This is not the case here. There is quite a lot of work
> behind this from several people on the analysis.
The problem is that any sign of slop makes one assume that possibly everything
is slop and you don't know what to even believe anymore. :)

-- 
Cheers,

David

