Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B6BCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 12:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526C38E000B; Wed, 12 Nov 2025 07:22:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE908E0003; Wed, 12 Nov 2025 07:22:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4140C8E000B; Wed, 12 Nov 2025 07:22:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 308958E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:22:06 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D54731387DC
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:22:05 +0000 (UTC)
X-FDA: 84101867010.27.D9365A2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95AAD120004
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:22:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cnup7wtk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mu0YqMKX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cnup7wtk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mu0YqMKX;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762950123; a=rsa-sha256;
	cv=none;
	b=MdlNZxT9ObaLQQOVNxBDAcna1alcKoaDKGGBvgvaejcRWtjbOHU3d2ojcQERJlQ/2b28yB
	B8s68cJGu2s3BEXxFOAJA5mq3szTejIZ/t1e6nRAveKrXEEFcgL9JRyeeIbu9VmMV3hbd9
	DOxMEhqRzaOpVJaAZHnBCTnt7mhSNFI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cnup7wtk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mu0YqMKX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cnup7wtk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mu0YqMKX;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762950123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s69v8zoAN0yUt1yIjdhfQphZJ0vgfVVZ0Y5KUstYnWg=;
	b=Aj2jjqoBhPHtgkMaxDBflDmTsNMxcQ1MM9cQKQ9VTxZ9T/HkvPwz6LUJhxoGYc4il7e2FB
	3iLSMnQhgDN/DpFUJdT+R9OChEGWRr6MfFZzxZl7Zt3MAzyay5yT8i1txprc8T0GX8urPB
	j44X+IqsvZxyM+uutbvD2b0bSDJS+M4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4F18F1F44F;
	Wed, 12 Nov 2025 12:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762950122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s69v8zoAN0yUt1yIjdhfQphZJ0vgfVVZ0Y5KUstYnWg=;
	b=cnup7wtkyuFTfjctBj2SnO2Yq263YXGb0FM073MiLMhq/u3Hy6kbupI+n/x8nvNkQ/h/LG
	82ZtizLWsxX70RG6g40R/dEKRqJNe8kEh01CTZ5tN6TuKbHRv2QFvQih/Lt5Wn30BhAJgZ
	qeU+iNhgvEKjanwG5XFCMch8OgElKZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762950122;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s69v8zoAN0yUt1yIjdhfQphZJ0vgfVVZ0Y5KUstYnWg=;
	b=Mu0YqMKXdivi5GH6q6vNZcDfOAGWnGxhZAqRX3VBQflV+j3/4D3iLwc1O4+s9gcic+b4Eu
	Srv+m4PC4VeegoCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762950122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s69v8zoAN0yUt1yIjdhfQphZJ0vgfVVZ0Y5KUstYnWg=;
	b=cnup7wtkyuFTfjctBj2SnO2Yq263YXGb0FM073MiLMhq/u3Hy6kbupI+n/x8nvNkQ/h/LG
	82ZtizLWsxX70RG6g40R/dEKRqJNe8kEh01CTZ5tN6TuKbHRv2QFvQih/Lt5Wn30BhAJgZ
	qeU+iNhgvEKjanwG5XFCMch8OgElKZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762950122;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s69v8zoAN0yUt1yIjdhfQphZJ0vgfVVZ0Y5KUstYnWg=;
	b=Mu0YqMKXdivi5GH6q6vNZcDfOAGWnGxhZAqRX3VBQflV+j3/4D3iLwc1O4+s9gcic+b4Eu
	Srv+m4PC4VeegoCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C64B3EA61;
	Wed, 12 Nov 2025 12:22:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EvFtDup7FGkULwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 12 Nov 2025 12:22:02 +0000
Message-ID: <48e45106-f76a-421d-8f9c-645469076ad4@suse.cz>
Date: Wed, 12 Nov 2025 13:22:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mempool_alloc_bulk and various mempool improvements
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251111135300.752962-1-hch@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251111135300.752962-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 95AAD120004
X-Stat-Signature: xq6gmahw4kqiwn47n19w8euy75k1rrzr
X-HE-Tag: 1762950123-190713
X-HE-Meta: U2FsdGVkX19ecuiw/qzoscVcAqpn+OLghop9kVYON5rT80I1riSOjZv0AYmmgR6ohSnH/iKIn875MC77wzJbu8kSuHg4A/5UdsFoBPbKR2weskgfHArF2bcjexuExtK51G0oxF4IX+O+fvqliokfwQP6b5S3sdMo8511iGw5sKft392yhkISAmrVPl2dr48nBIZmScp+sSRKc1axOwip1oFGS5R6nmH7yMlbZ3UnlGEkJUSYHN+/giDtN30N57CCqA/bzVivj5FDBO3upxWRLFmXMYW94zCk70TnBEgKt+goG5JKLZtEpXXBI4ArSF585tJGw+YYu7t6Pp00bwfIgNlfI35GbDyxAqrN9NRzIVxVeJz2bkWQ06PoqtQKhjQQ5myuyIrnaRyTOjrYZsTZbKF4qEr5NW+V16BHhi38vlj4PJu4ZGY7EbPcPGNRJQPvG++AQXTpGwUWmIaolRCBWGoul0WH2SckVnT2DX9WUxN/qcGhgt6ChKZImuEd/HpI7Qt0/1oHH423lH20pp/VQvCzegy/mLchX8fQhKi1eXnhar8X/FWwvcN5nISJoQdZ8tHtyzTSgdEs89cu7x8c9rRqisXlH5X3GrD8G6aXkflMXurqsWhGLyo1YZ0QTc+VcplHcQs+DMj88arFnvHn1CjfEj9Zb3plo/GQ/02vQlbd6VtotbFjxWCIf9LXvn7mE+DgPXSqJrvkvFSZuJvoqdPyIX9UJNmHXEd8KcitgVEPjD+Ve/M8vS7m1MzXazHKuI0KvPgJqgK/Nv8epeoEYCY4huYxhUSwV+WE2Mzp+BnQwOCFQrREdkLuyntF2ckfmCrBSWeh+Aqn1X+HPNaLDBl2nfllisxtziwJ/A5U0bQOrZ8cXLqzDkoTLub8/EaTEhrWYsFHIgkRjuQ75DBRiUkZu5ZeBwh/lj7StS0/d63ZrDXcch23e4awUzCzyZ5jApyDlDP8qRrvy7RadkJ
 +/04iA8n
 lfqzKtfKglrVa78QcNUcNTrl0nKMknsv0dosHKyO9kPrV3uDLSwtlm4883991PI5ooRloCbZMW/3AKHLtL2BRbLVM8WGuWnq95/0++0/embI7piEIW01joP7d8OAyH/9/1twGSTUo0Dlz1p96lqelWDfqSfSg90kcNKlj5eQUc7I9FQttLn3KTrHzpEXi/qoj7c7/NxMCTI1GfyMv4IqrEBuu5cWsu83+ebi9PbwCs60GDZydSPG6IVEce9CjUrCdbQmVeiDWuZgVmiaKVJsLLgqYaE4WZmYOxUX3vdTPXTHA/UKnqOKNUsJ+/ifiiZhgDg+DxjqUtJAl4w9Dl4v6DAr2SNMCClc3XRGk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/25 14:52, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds a bulk version of mempool_alloc that makes allocating
> multiple objects deadlock safe.
> 
> The initial users is the blk-crypto-fallback code:
> 
>   https://lore.kernel.org/linux-block/20251031093517.1603379-1-hch@lst.de/
> 
> with which v1 was posted, but I also have a few other users in mind.

How do we handle this then once it's settled?

> Changes since v1:
>  - fix build for !CONFIG_FAULT_INJECTION
>  - improve the kerneldoc comments further
>  - refactor the code so that the mempool_alloc fastpath does not
>    have to deal with arrays
>  - don't support !__GFP_DIRECT_RECLAIM for bulk allocations
>  - do poll allocations even if not all elements are available
>  - s/elem/elems/
>  - use a separate failure injection know for the bulk allocator
> 
> diffstat:
>  include/linux/fault-inject.h |    8 -
>  include/linux/mempool.h      |    7 
>  mm/mempool.c                 |  341 ++++++++++++++++++++++++++++---------------
>  3 files changed, 240 insertions(+), 116 deletions(-)


