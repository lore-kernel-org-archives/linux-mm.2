Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 964B2CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574C36B008A; Wed, 14 Oct 2026 14:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54CCE6B008C; Wed, 14 Oct 2026 14:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48DAA6B0092; Wed, 14 Oct 2026 14:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 261BF6B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:25:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9242160286
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:25:19 +0000 (UTC)
X-FDA: 85322059158.07.A20D386
Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5FB4C14000E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:25:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F4kcBsuu;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3M/uSDZUNAsK4QV0hkfFIltMe2EmnBaleyGH0K4QOxo=;
	b=sog5TZ3F+ojAixkjKREvNBmcUa6G6QcMp9xR/8wEvpkbRJECJCZuzqnq4mUUDvzm5ntiWS
	htX0aLKZLY7IQAx5rR1XRxTnC86Tm305alxQKz3a1K94iI35Q8puIH/p1MH5BkNL/Sme0X
	tTyIBuEQWywY8nO8lcK3vlwJ3BOGrp8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002317;
	b=QDcQ89kwznieoSKp5Uyw9L01oUkQ0KO/OqINa95OWvIBA6746xSvGXW8ju8woO6DVA8Sju
	CP10PuPGxKCdlisAdTf9KoqNdjL/+M2gOMo8Z6LL81oTrIkCw3KaLhhir1Vvik+hfjVWy4
	ZTmrwlf8ANIOkWBJ6Z5ynfn+8jdpysM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F4kcBsuu;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UfN8ZqWj05pIM5YKkJVUzL7gKRgIUqF/r9OZzNufKig=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792002315; v=1; x=1792607115;
 b=F4kcBsuuZ4W2n1x039ZBV9EnzhnMB3gyiDXb3jvdpUyNbRLpheLiv1SomPNIWWDEja4+Efu0
 48oGSOObRjNS6Y9Y2j+7GgcxcaXD+0jfFot1I4omtNNSDNJD9TAVClOaiIO74Z30blw2Ng/Ss+Y
 aFbNxIJsufp7nV6T7G64couM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6dbda3fc00612143;
	Wed, 14 Oct 2026 18:25:14 +0000
X-Mizu-Trace-ID: 6dbda3fc00612143
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 11:25:12 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
Message-ID: <as_I8DoRCYpnTXJg@linux.dev>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
X-Rspamd-Queue-Id: 5FB4C14000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5c989t5o1qqqxqgaeamckjoawcy6bd3a
X-HE-Tag: 1792002317-60523
X-HE-Meta: U2FsdGVkX1+sK7jbPnZnIpTXPTZa3M4so+83j1wY3Xw17oYfA+WrglchiO+HwZwFupxqXZWzj1/KLaZTTT2uj2v7+JInFav4LDnbks3iWW7lXXkfalRKrp0j+V8r5nkFLKknYI/1cIdVMFkds6h9SuD4rJyernM0GCBmSsGoD8QzsXSqGHt4XqjPnVkdOh3nc1V/p8tCQ825zhrox3xnH8GocvnBpJR1Mi6Lln5s36Mha0oIZfxtRNUODZSrplOfwu3NxBQCwXL0+lVmtpNehOzcqh6sF7llEIX4uSLuuTBPqvYX1NCnWiLc3HMOkta16yWV7G5Sih5YVV9RWLYHUUo93jNfsbwfNWnokjh31X2SEp3Xl9DJCat2O9KceNobvTy65SfaudGiDqC6njWi0pl0S9LsxWUBNXnqvTRiG4YSYAe1VRTZgQUntlF+RtXpfmizP6z5XvaDq8YIJKKmtAcZNGN2o3wx03GmzlIIY34GaTot1wUW6UF7GqrWfgy7eIMkfnVyZzU7d6t+ib7GExW/LSMa5CC7AVuAe9ICuyw7bR1FZV5PK1TlFL02Oqzn3JYU9wd+JukThlSPxOQhWOEW96bmQXL5PgadEOfGsnzSBwQ8ipCyvjUIHVc9+68HXHWEiJXE48wkjy3IqxbaE9KOvZQmw8UO9SUKVyP6q8oyTU8SIE0muMiImrNSq3eQcfHW3aHlftO4kbWXZdO9u0PeUxZT+tWhFNR0hhHYsq81OeKsqfEu9bt71U6eO51RRN8Mx8Xow9NaQ2k85cC4yApLdrTWooh4BxvhZ4AzO1VEAUel6Sg/Voq9IepFuuYyR4N+h2ItnzIjSTXslWep6lgGsKbu3UOFYNaox39VzsS00Wvc1hUgZ7dOLms7GN1uJGeQoG5ECKVZcLHK1Cxf1nVk2HN0WN93UROp3NyIDgYP5vcc790UEcm71GuGS2a8ueYhQ5/2+mIFEkHbfk6
 h8c+ozHj
 avp9gkI0eY+dUGzH/EISU4g/pLN7rgVSg7tYG1XejyqiQxGPKzKVfIcCIIx7iDA5E55ZooW07RnYkzJ/szNetu/4YPKhVEvMfIDturx5MDzgECufOHhmRq+1dofcdzENWXGuZz/YTcPOrQko9NK2NrxSg3FVkccMTPg3m5tLULH101DJhwhNdP13tl76IoojcNsES8ewzhjn3oFJv67dCX5zNBhN+UwCo4rpyh+DOGkcEtJqJYDR79q6Ii+6bErEIbN4nksOM2coV2rPirUJsIxVzz70CMrZuC6yrJlzzIc8VW/AhlAMk09tbto9IfhlpnicGaxsEUSYO/c/bzMItO6wBCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:08:20PM -0400, Tal Zussman wrote:
> The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
> switch to native NR_VMALLOC vmstat counter"). Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

