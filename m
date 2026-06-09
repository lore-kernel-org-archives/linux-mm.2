Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15253CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498356B0005; Tue,  9 Jun 2026 14:22:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4490E6B0088; Tue,  9 Jun 2026 14:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337D66B008A; Tue,  9 Jun 2026 14:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 220E66B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:22:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C52F1206FE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:22:30 +0000 (UTC)
X-FDA: 84861194460.11.826A692
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C832B1A000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:22:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iXvK1xwQ;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781029348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFTtvbP2Sp1fiHY7s9iXXbHLzrRLp2nhEH1gNK/PItM=;
	b=ovenfaMbjeQFW8KglropOu091iKKxo9K32Rjc1mvAUHGaLPrfYzeJQsE1reW3pB+qbgJmr
	W+1FURWdAZf704fKYcos9/+QjcB5NCf6qv5HCHDb6if4DhWxN8u/WI2+v9YFlXuZzBlBRP
	9WPoNY1bb83LOIQ9gFMSTijsoH9WVyI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iXvK1xwQ;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781029348;
	b=CE5FPuFWlHJe1ov1YDyi5WyhR9Ut0GSxM7MPLPdhJI5/HqiEhkjcvJbfpGshvaZlLsPZ6g
	j189I1VC/G0DU4Mv7E+TjG/7l8V/J2XdFdJ0l9H8TRjpHk72BqPFIV5AhCB6BIURB16TJt
	wEZSnpw2lNBsjEgnNNAjxfRwFVPVTOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 537C56024D;
	Tue,  9 Jun 2026 18:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22C51F00893;
	Tue,  9 Jun 2026 18:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781029348;
	bh=cFTtvbP2Sp1fiHY7s9iXXbHLzrRLp2nhEH1gNK/PItM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iXvK1xwQeG/DeqCC1tllTKg2SB9yf/3QZ3iJ8CwZx801jmHoZRjFWyoiNwt+tif7e
	 fmETAG9YKLrN+BlA5jdt1RyYSy5Rmts9v3yKep8aE/P6uwiQEY0HAXs3r5k5xTWxAd
	 cnmvU+1CwucMHtSK3poz4hZBj7gonlC/64awt2wBvWiaHXr0a7JZig/3TBXwWg4KzI
	 5bLf0rpPQpfw6TIFklfjqCsRYVjMeFJsXoeRwAlqcWw5YdloE+jilpnEMbrP51CDeT
	 b3zAlRPQHreaJSFk8BC9UOAmJTM0R1pbmeiiSrZRh6GEp7rnNy/BCU2YepJCXpFcnH
	 GdukEOQ7ZKkAw==
Message-ID: <06bcee07-5e56-4a82-95ff-2a8e75b7154d@kernel.org>
Date: Tue, 9 Jun 2026 20:22:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/9] dax/kmem: add sysfs interface for atomic hotplug
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, linux-cxl@vger.kernel.org,
 linux-kselftest@vger.kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com, Hannes Reinecke <hare@suse.de>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-9-gourry@gourry.net>
 <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>
 <aigy0ut410TItkgB@gourry-fedora-PF4VCD3F>
 <e6e7453a-d2af-4f1a-8930-5e5e5c5879cd@kernel.org>
 <aihZG8WKVSvA86mA@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aihZG8WKVSvA86mA@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C832B1A000E
X-Stat-Signature: e8yfaej5hyszm516szaezw4diaagsny9
X-Rspam-User: 
X-HE-Tag: 1781029348-647770
X-HE-Meta: U2FsdGVkX18DZ0Uxk77sehTaW3J41YAHYQZZEjoqLzBs58sBlh5pzR1ke7RqGofivabPdW8O/g5+KnfBOe4OEUWEEydFfJ1lSIMX/nWUC6pLnIDnNfuY4yy91GJJqS4m+yzD+EOTwEs+4n9Tnqz7xhevOqTb+B6I8noGi6mn/WO1TuAOg39OBqzWa8t+chXkSB9pOn8nmCfnLfkOy3sPJpix0s2DfzriuzvnSQjQ6apggjcI7wOt6Ev+bMkmN7FIfA/xj/UvywbRUKyLaleiR4z5AGLl3wXpHaLq2KGp08nTti/A2GqW7HDtlw0OliN+ZJymDnKy/2aTlm3Eo4KJ70vVwBBn72bTjEfAuzYvAQFBZbTlV7/EKAZWH8e1GGLUgG4w46SoVhAvvPLm1Ullz1gb5CYUnpWnog+WUvlT3N23mAUPTl+pzV7/ZZ5tJsVHJsOFdwq6x447rfe15E3g8KpGDpDXBrMybH6OLTocckB8DBMFG8YNEPkqu/lFK+xpECZ8tlcLugVYBWpSBV8hiwqkwf5qeNuTELAOlxMm6yKXsrfEZ5+KMVEdGns/D83Jx/4belVRbHPHFl1wGTxelvwCUuDHoaCtGzZ8rnjj7WWpbSkvDwDMATB6do4bLBWmAqJQfczGGdGdxTS/d0/QM/vYjqgoObbtwYz0gEkFUEJ+ghUChrqfxErRfXQAoZcT+sX2vmUBSEIDwy78ikqIs5fF2Ud+v7C93tApqTunlg3+ADALSS2KJsjj1zSbCoPw7KDvWMxUl4LKsIqvOGr7GoxdBXjm0UzqSi835JZk5Q/XQ00ZZxbWduPiqNE2eBa35HnsEr8ggHzsb94YIVyGd8m9TlzJaVjUcpjpCb16fcnYd06h+Jnw9OrWpzS9n+DysKiEbUPMqrzNDVzjai8zf7RnLpBYR8svznwZz0qokEhhaAp2rkwBUpdmM2wRj/LijIJ3LT8gRZws9zwFuH5
 jwEUs4ml
 CpsiKYlXpL1guAGy6Ar1o5MYaWBWEUiZKSKYjX3ipQTMA0Poj+xUBsKxqjCNXm3xaAnjF0odn4kVmEtvQ8uwEULH+aclu8S4bcHLMEX0MH284DYEZMfQ3qoXSwfsM6Y9SrQUfQAQA5s8kYJF1XM3Z/yHx+OH6xlC4Xs9vUFXOE+x/dWDe5fXKlmxMAelgEVz8p3Tpnsl9sRmVUMXcPybDtuNCryS/10Z8U9DJ89GkNspCUC7v+YbPvN0LvzkdTEJ5uN7X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 20:19, Gregory Price wrote:
> On Tue, Jun 09, 2026 at 08:11:42PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/9/26 17:35, Gregory Price wrote:
>>>
>>> In patch 6 response i point out adding MMOP_UNPLUGGED
>>>
>>> If we add MMOP_UNPLUGGED as a state that is only use by callers of
>>> memory hotplug to represent the current state - but not as a valid input
>>> to memory_hotplug.c - then we can simply this as you request.
>>>
>>> Although we'll need to add a couple lines to memoryN/state parsing code
>>> to disallow MMOP_UNPLUGGED as a valid input (otherwise you could
>>> permanently unplug memory without the ability to get it back... unless
>>> you want that?  Seems useless to me.)
>>
>> I would just special-case your KMEM-special value, and then branch off to the
>> core helpers?
>>
>> static int dax_kmem_parse_state(const char *buf)
>> {
>> 	if (sysfs_streq(buf, "unplugged"))
>> 		return DAX_KMEM_UNPLUGGED;
>> 	return mhp_online_type_from_str(...);
>> }
>>
>> So there is no need to add a value to MM core?
>>
> 
> Was going to propose this, but then I thought... well if CXL detactes
> itself from dax and does this same pattern, maybe MMOP_UNPLUGGED makes
> sense.
> 
> But i'll leave that for another day and do as you suggest.

Let me sleep over it :)

-- 
Cheers,

David

