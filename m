Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFBECAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 12:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE928E0007; Thu, 25 Sep 2025 08:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D61B8E0001; Thu, 25 Sep 2025 08:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413108E0007; Thu, 25 Sep 2025 08:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3338E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:27:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9BDED118871
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:27:13 +0000 (UTC)
X-FDA: 83927697546.30.99E226D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0B1FE4000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:27:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LgSmC1iM;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758803232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pv61tD4P8aN8G99P4hprmtnCocCmXPeRvv+dvhxOQIE=;
	b=cOr7bqejIkT66E3pe8hb5UJd4t8wod4hNytf2ZWMdjzkfpGg8xh7NNHYAgCgcGZcp8k3RN
	6KVzPZrkMXQ99+YWhsrgI5A3AJEdSOyS8/68Hyt9ZLUM///wBM7NGn4MimKxAMU31ivS1f
	FIHIpen6ZZ+pXXdkJMFfMcrbUwb3P3k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758803232; a=rsa-sha256;
	cv=none;
	b=b+La5ElHwe0R0ujFirR71tjnQ+DmOddqi0kO9/1gwc5dDAWMyulHii+mbjlC6na25Wt4c8
	CEhF2OdFBmMYCHxO+WJWkuJ3e++muvblyJFLIIlcQlnQ/SYU0Di1UVwWSretGjbDmOmKwh
	AVdDkrVlk/+3/0PCnmMbHOsDujkrBuw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LgSmC1iM;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A90060532;
	Thu, 25 Sep 2025 12:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC7EC4CEF0;
	Thu, 25 Sep 2025 12:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758803231;
	bh=TGWxGUpcHpB3h2qtjo8FUCjA58tEH0rqxhAVZjG2Njs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LgSmC1iMmZkyqek98Zpj5gcQK7t8yjVTTPof1tyA11bQLdEY78iNcCpjGdTONyJLF
	 /KPFfdm5h1o3qH5DVQhdcINnsIx1iovkZHJH5syKKIxx2UmSAZB/k5N47BfWnabakg
	 QxcN32NUMwElacrAn4TvYui9oc4//gAXhQl3il/eIzh1gxx0qVXsRu1JKJjGeVhvM4
	 KGSMrULRtssQDuHOcuzL7s7jWWOru4Si0qZvOWhJSuWY4z2o6XeBc8euWU3aGhlD1G
	 pvk95ACwwE7iwDQgNblwJ1vpBg1fGXSi493citgCfqgFLfupa0mLqMoDOnzGTsA6MS
	 Aadu/bJnhvQwA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Jason Miu <jasonmiu@google.com>,  Alexander Graf <graf@amazon.com>,
  Andrew Morton <akpm@linux-foundation.org>,  Baoquan He <bhe@redhat.com>,
  Changyuan Lyu <changyuanl@google.com>,  David Matlack
 <dmatlack@google.com>,  David Rientjes <rientjes@google.com>,  Jason
 Gunthorpe <jgg@nvidia.com>,  Joel Granados <joel.granados@kernel.org>,
  Marcos Paulo de Souza <mpdesouza@suse.com>,  Mario Limonciello
 <mario.limonciello@amd.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Petr Mladek <pmladek@suse.com>,  "Rafael J . Wysocki"
 <rafael.j.wysocki@intel.com>,  Steven Chen <chenste@linux.microsoft.com>,
  Yan Zhao <yan.y.zhao@intel.com>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [RFC v1 0/4] Make KHO Stateless
In-Reply-To: <aNUJIsElr5L5uxNv@kernel.org> (Mike Rapoport's message of "Thu,
	25 Sep 2025 12:19:30 +0300")
References: <20250917025019.1585041-1-jasonmiu@google.com>
	<aNUJIsElr5L5uxNv@kernel.org>
Date: Thu, 25 Sep 2025 14:27:06 +0200
Message-ID: <mafs05xd6d8f9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B1FE4000E
X-Stat-Signature: 8nmwia1oskytydd9tuuaiik1w61hau7i
X-Rspam-User: 
X-HE-Tag: 1758803231-639535
X-HE-Meta: U2FsdGVkX1+ovgSqPh7b7ElCiW3t/yi4XVrlOtbx42/FPI0OrB8BSqnOVHq34DQWbvjebBgWPhaGFojnqnvr6GrV3aFmKqr/8p9jjmjKBvcEXs9rp97P77FtcSoRHMWhm5vrDdsrcJ/YyseozYSaVDvsnlf8+yYbsWyBIy4UlunbLIjUXMwTw5Aucj7a0ivc/xVpONnBOBSRoNnNMKLPb0cEHYPpUVFE50H7Euq3qa9HsTzTWbOnQL2Y5Cm6FrTTuxxybR82JrvQ8MswFZHWgP/LzqPDsm4YhNpaTtz/xsJJPhxqowh8wqeW/HrKLS1x1CO0aT9epjwQizDZRIpxH5RB/UzvzQL7TKqW3UH+lU7DwjLGbazR7KOO3YQ2H3lv4ahM0+f5Qcsv+7gbD7YVt0Pd8Kd47Nq+wXutZ6KZ3bNP+aBL7evx9cUMfjIlN/ME5RePfUhrxmpAxrK4JHVqVFjjXCC7YhaTGRHECBfsb8y8y9rOWLTthTTyhi+itInaweZ5KYAcNf23ibht4pCy3xncWuxE718RHKKYmcghXPo63XisikbNeFXNNdn/NA66DBB/zGsMa61FYDRjKnk567LB9Wddd4kOY2I8uFKhdVg8sDk3OOyyS/nd72ZaWnbpnI+JwPpc1VIVKWKDpL74IYS7EpG2EpH9XLIJYPoln4sk4GXeAu5XscmwAh/H/UiOsye0o3oy+jJNSgV2UAlbbgNc8euTH3gk2dZpcNW2CjO2ZcHrXP5/RS1C/rRuN6s10OaCL8qpAbjaJVarqxro2vLiYIuZc8vmLxmZf6bNMadvezH1qNn0PxgHMcm1X6xiNixB3vVpkp51NGeFFOTcuNrsf/vdxrVsnCBGemdTK0Ji9SvDBEFt3TQOOEM7Uy1Az9RewhnBnUZ4VWmUaaqeiguNw4gUXMbRpDQhxSvqBNSSk3GMIkfgvC5vGkMwiqvBdBh6B9A/nhcWBcHVxkH
 t+gKaaQh
 Jl7xzNe0wX9Mnn0sj15Gp7LTPfeTGmmNhl/hlNRWcYXicANIiWjBVNShcjEt03EsztAGaxkANZ42i3o0XlDzAxMrm9UcNpQsTDdb9wnwOPSFzUE0GN4VHFQZsE+644SkeX9NH9mMge7gFMIIsS5QIuYGtDsNRkughHyrFyeak7hXsfV4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25 2025, Mike Rapoport wrote:

> Hi Jason,
>
> On Tue, Sep 16, 2025 at 07:50:15PM -0700, Jason Miu wrote:
>> This series transitions KHO from an xarray-based metadata tracking
>> system with serialization to using page table like data structures
>> that can be passed directly to the next kernel.
>> 
>> The key motivations for this change are to:
>> - Eliminate the need for data serialization before kexec.
>> - Remove the former KHO state machine by deprecating the finalize
>>   and abort states.
>> - Pass preservation metadata more directly to the next kernel via the FDT.
>
> If we pass the preservation metadata directly between the kernels, it means
> that any change to that data structure will break compatibility between the
> new and old kernels. With serialization this is less severe because a more
> recent kernel can relatively easy have backward compatible deserialization.
>
> I'm all for removing KHO state machine, but that does not necessarily mean
> we must remove the serialization of memory persistence metadata?

I think the tables should be treated as the final serialized data
structure, and should get all the same properties that other KHO
serialization formats have like stable binary format, versioning, etc.

It just so happens that the table format lends itself very well to being
serialized on-the-go. When a page is marked as preserved during normal
operation, it is very simple to just allocate all the intermediate
levels and mark the page as reserved. There is no further processing
needed to "serialize" it -- like we need to do with the bitmaps today.

So I don't really see why we should introduce an intermediate processing
step when it is easy to just directly build the serialized data
structure during normal operation.

>
> For example, we can do the serialization at kernel_kexec() time and if we
> want to avoid memory allocations there we might preallocate pages for
> khoser_mem_chunk's as amount of bitmaps grow.
>
> It also would be interesting to see how much time is saved if we remove the
> serialization.

-- 
Regards,
Pratyush Yadav

