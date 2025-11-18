Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B911ACED63B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 13:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4ED6B000D; Tue, 18 Nov 2025 08:19:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0276F6B0095; Tue, 18 Nov 2025 08:19:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F696B00A1; Tue, 18 Nov 2025 08:19:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D52C56B0093
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:19:58 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6AD4E1A0514
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:19:58 +0000 (UTC)
X-FDA: 84123785676.14.30B3A64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id CC0B48000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:19:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hV0NNWcz;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763471996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TprChO0f6bKa/OkInckoXb38IeGLCxVtCRhDnKcSsvg=;
	b=ofGz6f6ApsodZJ4EAujXXKXsghqjx6Jv2h/naptRjKMAf7aTX+yUsXfuK3tUFpGN1Cdx48
	SZgsTZEUzgcJPZX3DFNf+EugAXoLxYLHJGTj8P4FM3D5SOURhFnzfkofrwtugm4URCN1cy
	wdDb3OqNTBEiyzUQj69t71Jt4gVAIfQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hV0NNWcz;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763471996; a=rsa-sha256;
	cv=none;
	b=AZXFXgCLTHTfMK8HXbz28q2C+FWHtp62tT8WeOmtpsI8oU4UmQiaehuZvpvnLUQoMX1UYl
	jgjrQh5WGiJ/aRqPmAqkG3IFhrKdGaPWqqc3TC3LBlHBMq07D6+CR6qE29LPV+c87Y7BY5
	IHTMbU9zbViNuEpdLLmQ7rgNVAkHubE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 115D260194;
	Tue, 18 Nov 2025 13:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61BCC116B1;
	Tue, 18 Nov 2025 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763471995;
	bh=xEfBSU/j2FGHLktRs1aJpVOnTyEUSa7gj3GAPsupGvQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=hV0NNWczFRQTiTZisfgnxT6TTqxqtFrXjsbKyb/0jDkDe2CrpBvZ/G2YqiqGlBI73
	 R4nzPN9VYeC/GXv7mcuEy/aD8p3BqFLyJP0Wp38xjy/VF2tuBQ196NHv3yELc6DNAA
	 wxBNAGkleKSIxy4uCkWPWnfh63pe4dskhjxYuQQrRxt6dzcA/yAO6cAYO6bcae5Sx1
	 4x3W6yvi8ew5rSru0nUcozzx1O6R5QI68W9WqQlPMyktTnruNnWGFFM/3afmir6ohQ
	 tTvgMSpyOzhGJfSD452gMmMLUV94nA1bhEUDFYTdB8eSuCpk/d2tM7D2RyFxb4dtG1
	 cz6tdOvb1RJQA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  akpm@linux-foundation.org,  bhe@redhat.com,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 04/13] kho: Verify deserialization status and fix FDT
 alignment access
In-Reply-To: <aRhJk_Glv2pX2dRo@kernel.org> (Mike Rapoport's message of "Sat,
	15 Nov 2025 11:36:19 +0200")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-5-pasha.tatashin@soleen.com>
	<mafs0tsyw7e0a.fsf@kernel.org> <aRhJk_Glv2pX2dRo@kernel.org>
Date: Tue, 18 Nov 2025 14:19:50 +0100
Message-ID: <mafs0qztv4gw9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CC0B48000D
X-Stat-Signature: 8z6phd6h6b1xcs35bniwh57191pedcbx
X-Rspam-User: 
X-HE-Tag: 1763471996-934649
X-HE-Meta: U2FsdGVkX1+LTLXbD1mwqbgNDVY3OjXtFxuLQ2B2XVbg/VgXjvfVNBDbWdun7VQvdA+ADOkZUjJsbNit9M3RtphSCsigjMJuJG0ph/JVog9MVZDrbeTtMEAH5sWyitZQknNxktpLdt7h6ZZUO4C34WzqsuePbk4FXJtJC9wRBtTHNDxkS6O99Z9RkfGoUPJLlSMKFXMHSVfeuat+n5DpLPMolCuFbBU9+qhwfvsjimb22SRFPkEzuXOZDaOnRx8bMZo2MbZtESWmAnh7ySQsnkYNpw5ACDoyMkCDnDL8UqVIoINoidOqQ4fmwNSUsex9jY9vtkxEkYpHo+gfOQ0TqXywcAdKXL6CWtLO+gBWwbuNkmEN0+u4Eo7qTUhlCO7KMi5pe/h+DhVLN9hoeY6lrqLlO8IvUrucs2E4BlPNDoaYYMwygmLWrmy+jjNHw9quznrd3TSz3gzi1oy2+JouZ2hRj5pOctSfgJcKOIDkcNIfRCKq4GsPu8sJH+6ILDS+s7YgVJux2Z9oDglYilF6aSvl+zZFAudauod0CFXzsLKOzn2aCdml2m7lqYlLn08aUCJq3cgmt8yGoTPuEYatcf3EnVGHk7+8a20LpACnBDgmg8eyNaTlNzsQV2ZYXq0m+5OsbCeiFQtJHMF5tZEvRB+ntMhzslmnTjWQWrGKViG6eMHHJx1uMR8rtjKeOmUqQoiBw5L0m/pk4ofYZzcVrtvmUdNs6O5LjBJudNO4X0u2pCVxxwwyl2B0n9U/Kff9VEJUeJBVMy76KHvtFvCA98GZEzY66eGJXAhFjyewnM8+6h/g0qNkjk4nH4Ee2E6SL42acT6yMf1GBZA+ZjZZ6IEy3kpEXaiATYp+U+FbcBGYUbLrYyAx8YeQP0aT7LFZTnmof1yz4SsQ9Mxvmj/xuTo6K9JRkd8c9Re4BZQ/cf8sfI76Gw490VCz/SA4RIxgWU6tZuXuzWT0AF9pFhK
 TJkgizVO
 k9+e6QbR7VIhakPIRr4Q/bPt3QK91uUme99FUvLF6hjw2yQiwgD9MFOg70AI4mFATQ+1qVWZXKA+RT494i5qADrO6c63HUcTypGfLGfuccB8KytcJGa4AtQ6keXZfuK+Kx4HAegEtJYNKl5AsbI2nm46dsjKOiDhH11r6FDPvvTzgFooXBSiamFOOo7cdc8drdn4F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15 2025, Mike Rapoport wrote:

> On Fri, Nov 14, 2025 at 05:52:37PM +0100, Pratyush Yadav wrote:
>> On Fri, Nov 14 2025, Pasha Tatashin wrote:
>> 
>> > @@ -1377,16 +1387,12 @@ static void __init kho_release_scratch(void)
>> >  
>> >  void __init kho_memory_init(void)
>> >  {
>> > -	struct folio *folio;
>> > -
>> >  	if (kho_in.scratch_phys) {
>> >  		kho_scratch = phys_to_virt(kho_in.scratch_phys);
>> >  		kho_release_scratch();
>> >  
>> > -		kho_mem_deserialize(kho_get_fdt());
>> > -		folio = kho_restore_folio(kho_in.fdt_phys);
>> > -		if (!folio)
>> > -			pr_warn("failed to restore folio for KHO fdt\n");
>> > +		if (!kho_mem_deserialize(kho_get_fdt()))
>> > +			kho_in.fdt_phys = 0;
>> 
>> The folio restore does serve a purpose: it accounts for that folio in
>> the system's total memory. See the call to adjust_managed_page_count()
>> in kho_restore_page(). In practice, I don't think it makes much of a
>> difference, but I don't see why not.
>
> This page is never freed, so adding it to zone managed pages or keeping it
> reserved does not change anything.

In practice, sure. I still don't see a good reason to _not_ initialize
the page properly. It's not like it costs us much in terms of
performance or code complexity.

Since kho_restore_folio() makes sure the folio was _actually_ preserved
from KHO, you have a safety check against previous kernel having a bug
and not preserving the FDT properly. And I get that the FDT has already
been used by this point, but at least you would have some known point to
catch this.

[...]

-- 
Regards,
Pratyush Yadav

