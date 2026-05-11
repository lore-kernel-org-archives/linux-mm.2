Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15639CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B29E6B0144; Mon, 11 May 2026 12:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A106B0147; Mon, 11 May 2026 12:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7046B0148; Mon, 11 May 2026 12:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 396A66B0144
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:36:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 062F81C0457
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:36:59 +0000 (UTC)
X-FDA: 84755693358.29.B3B8B63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 60358C000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:36:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CssK/dWw";
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BbjyzbhAEhjiOAv/+IPvRGFECEkoPFNDnzv8HEauCyo=;
	b=yrzbfBodRmxTm0PipbjdpJO04dEXafMtCi1jEqwS1gPk+rTlOYh3K8kb3Kq3js1EWUl3WD
	zYykKesyLZAu3fNWRWUuXjIkwEfvs5uYzC6c02jpW8/fAyxZJGPBwIhqdMZlFFWnSu4SW5
	4GSlQBkC0NmDLReOXndne/a3nfIOwUg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CssK/dWw";
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517417; a=rsa-sha256;
	cv=none;
	b=Sj2M6Gbh0E09MMmsJOv5Mz/9NmsuKSCUAiq3x4abyTMKBo/NJeJjCbi+pzb0fsPNwfsAsG
	FXWip2gUXa79C1QSaepnrQFACnzUlRMktUvd0+OM0ug+k7GJzOL8dxTYjhfmTOKij9+etO
	KVrNoZ5g+/sQJy86WM6gjTd6wqfwWI4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C4CB460103;
	Mon, 11 May 2026 16:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8450FC2BCB0;
	Mon, 11 May 2026 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517416;
	bh=liPuemz24Vdu+80R1AYC85Gv4AyR8Vh8AkBScYnpciU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CssK/dWwTimpC0aZZ9E7Ph0ahQ4YbAFQmTr+YCk9pB9grCLntPdvXVjuNkuHr4eWP
	 kR/KsrpwUC6c2NGFnw06WCYjYSN9MbkO8PRMIUtxb/KeC16cpNOdpHUdmiJsgC2TKj
	 K5LnaPhVF03y5S+x9JVfvBfBRXe9v4MtnZ41QwPJHTRNprNhXO5kY42pmXe0xJH7pa
	 l9bYGB0mzmZ1/dghLPz+7xXoNaFB9ZjK+csJnvKcKectbSoX9wYAGtTfT3oi9IALsq
	 x3jfpQetglC0Pdf+KR1MfbCZFvcN4v1rcQTGlaR46UBaeYH+BlTizT8xCAE9nExguH
	 pCdkBTN8HLh4A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] kho: add callback for table pages
In-Reply-To: <agHCbpn5Hn3XsEWH@kernel.org> (Mike Rapoport's message of "Mon,
	11 May 2026 14:50:06 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-5-pratyush@kernel.org>
	<agHCbpn5Hn3XsEWH@kernel.org>
Date: Mon, 11 May 2026 18:36:53 +0200
Message-ID: <2vxzv7ctc38a.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60358C000F
X-Rspam-User: 
X-Stat-Signature: gtu8nnjg9odciqr66myr1pyhrw8parmc
X-HE-Tag: 1778517417-302296
X-HE-Meta: U2FsdGVkX196mZToeXlGjAokzdBW8wuEMQiC3YJoA0d/UL7vBrPFRfn9HMQXdbobTCk4LMR/OqtsDDQtKpeoZFvWymZEiaZERh0SCeFT3Y8MV9W02Jx+F/kta3/Hd5nLX7Aq/vyQVSwAtKQ/9iL3V1U7klntbKaUXXv2wFYl3lE82QZUPV+JCDiKwE9k6+5H0oYjIqahGpQ3Lx1oQcmcRDDOBHnV9c21CJtn5O5n/x1ZVB4krbl0fw52qgEPs/Xt/swSigdYSp5HP/ECS+46qV2YZ/GxVfmoc9d/X5pejpL6DXPUEKVMno6ratHcyNt+nSz+yAOz+0yUKdKPYt68LN7DUIDVBWfPBo7mPUd2ZHPppTEa5t8eEamSd/DOdQEg2gMXUvuGmy2s9/f66GTWOF1uNrj2gLTUi4e4tts+JGUj0l8YZU8hSeirJE60/pN9K1h0TbABgOVLTGa87kE4Q6ZMYnEEGdj0Cl2LOKwkEPG68M4ia0b0/bKIBppTSR1X+PhbmzbkaLttPMVwTQzVDuY9Zy9wMBvfpqT7YcgYNiwJDdHFbN4JRm01m4GCGOj2+lHNv8AJ9Mddfhn1a4ZlnQenSoN9V/mQ2A23T/q5UIPGVUzvqTSx/mBUAk+1KARdbg6NQc0Quq6akDUu8EsNuDzKAxp/mJNio41XlyaeoYf/pwSTZ2d25BVCSWVvlZPUexvY51Q/4BVtf1TndsJGtil5X3LW2i0zNrKC6eWumuOBwB0cHrmMsKS/QJe5ehcO4rLm6YA62mbiCq+fz4gMnsz4rY8oSZo9ccQAfyhLfYkkgj8sc6oqFwGctkOZbNp6HNHZtKrT83tOza/BdH7MXAdddLA3wKmusWzrZRtrichQHfds9zCTugRP84E8Z7ZNOcHDvGY2RM3kABHsFkMtg1+giLrSCvqJwScGgFZ0yk04QJxZ6aFpY60ZUMvkKLKH8uOfX5hXEYzUT6Fk2sM
 hr1Lv/1Y
 FnWtbfhciJLUsT/zvQxm0yyU3+Xbfvv/PG+4WKTGg+cIXD1ji3kPGGwoQr2LrKRaMC6ZGmEZ1fYbbOv2bbgyi07Cwf1D9C3M/leEXuKiH/ViQuebE7YmJlq18LtXoQow1qfONlce4QxnMc3rTt0vKoSw0Iz0UGcV75fhK9krAfKu0vkKFnu00Wvyld1vomQprUrYf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11 2026, Mike Rapoport wrote:

> On Wed, Apr 29, 2026 at 03:39:06PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> The KHO memory preservation radix tree does not mark the table pages
>> themselves as scratch. This is done to avoid a circular dependency where
>> preserving a page can lead of allocating other preserved pages. This
>> means any walker looking for free ranges of memory outside of scratch
>> areas will ignore the table
>> 
>> Add a table callback that is invoked for each table page. The callback
>
> A sentence why a table callback helps would be nice here :)

The main reason is that a later patch will create a radix tree for short
use and will need to destroy it afterwards.

Will add that here.

>
>> is given the physical address of the table page.
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  include/linux/kho_radix_tree.h     |  3 +++
>>  kernel/liveupdate/kexec_handover.c | 12 ++++++++++++
>>  2 files changed, 15 insertions(+)
>> 
>> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
>> index 030da6399d28..fe7151d89361 100644
>> --- a/include/linux/kho_radix_tree.h
>> +++ b/include/linux/kho_radix_tree.h
>> @@ -37,12 +37,15 @@ struct kho_radix_tree {
>>  /**
>>   * struct kho_radix_walk_cb - Callbacks for KHO radix tree walk.
>>   * @key:      Called on each present key in the radix tree.
>> + * @table:    Called on each table of the radix tree itself. Receives the
>> + *            physical address of the page containing the table.
>>   *
>>   * For each callback, a return value of 0 continues the walk and a non-zero
>>   * return value is directly returned to the caller.
>>   */
>>  struct kho_radix_walk_cb {
>>  	int (*key)(unsigned long key);
>> +	int (*table)(phys_addr_t phys);
>
> Naming is hard ;-)

Yes :-/

>
>>  };
>>  

-- 
Regards,
Pratyush Yadav

