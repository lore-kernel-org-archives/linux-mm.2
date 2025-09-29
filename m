Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB81CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76BCC8E0027; Mon, 29 Sep 2025 03:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C418E0002; Mon, 29 Sep 2025 03:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3A68E0027; Mon, 29 Sep 2025 03:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5A38E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:30:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFD3A1DE76E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:30:38 +0000 (UTC)
X-FDA: 83941465356.16.A58E0E3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5CF59C0007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:30:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BkvYITie;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YGkrDeXE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SNSLGGAW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R1v9Sb5k;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759131036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivinBsRltrvjUvAHlfXzBwXeEkNCvnM2QUHS0Pud2rI=;
	b=SKeneJMgDM0yVxxc05zOdSVnvHuUnr1FSlqrQT3OlkUzAbqPPqdZfDnoaKELwNHlMMSDMG
	UjpwJizrA+ofPbHjOYH00dqhroNfIOnYbsSkISllCPPB2pDukluirRmuEbYes3EbFCvAYw
	WFFtwXvxqZcYWfC4Ko31RMVw2EtKLtE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759131036; a=rsa-sha256;
	cv=none;
	b=zuKxdzJiK7cwNa+tQzY/Qp/0dp2f8wPnL4J+Ct7j2d0GlAg/ABkA3hhf39At5MxqWLEprP
	mtuPRN/n98ZwKyVq/ffT5FEsUuLxIgXR42eNoo1QOk7B7NtZ7evaPaEOCmWl4Nj64jWmTk
	4F0NG7rOy6zAqWSc5pXoQ9WMvysmPdQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BkvYITie;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YGkrDeXE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SNSLGGAW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R1v9Sb5k;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 40F092FA26;
	Mon, 29 Sep 2025 07:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759131032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ivinBsRltrvjUvAHlfXzBwXeEkNCvnM2QUHS0Pud2rI=;
	b=BkvYITiejp/KTvqq8OaoMcNss7s+sSMOTeu0xhYGmzzWoGPLKJn4eh4uEaOnAbY+ACrowT
	oVcE8O5HcIN/uwyVfx7slhbC/qU//PgfAwLuC6XwoHYl24I9rzTGRzqbOeebK2SFUWjC00
	yolZK8MO1vFs1SgWVBWp/ohREXCBtIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759131032;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ivinBsRltrvjUvAHlfXzBwXeEkNCvnM2QUHS0Pud2rI=;
	b=YGkrDeXEg91wpN7KQGKAaW5vO6kucY/BDkCoDw7pTe110Mrcq8E028kw9ppdAoMaKMJLFl
	AAQRkInYzF6icSBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759131031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ivinBsRltrvjUvAHlfXzBwXeEkNCvnM2QUHS0Pud2rI=;
	b=SNSLGGAWN8MYg1X6dHwaRj7S9N85CLFH91L3qRaVbIJ2ykqnKr3QGKZcl6nuWML0DZ+Cu9
	PjjbcrkIYpHx9H9IHMidfcwbiUKdCjqbfR3KSpMDjrJkP1AG0Nh7hU0TPX/wF5n4ZEFEt/
	eiux/hZk62Mxrw7ExNTUQp23/BAmUuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759131031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ivinBsRltrvjUvAHlfXzBwXeEkNCvnM2QUHS0Pud2rI=;
	b=R1v9Sb5k4RHKMcYp3Gxdhi6aNphndmKrCe6poouH127P/iVmO96mIFKJqWy3/Le01aAKOM
	YyZMCjVom9FFMdBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2923113782;
	Mon, 29 Sep 2025 07:30:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yIy+CZc12mgCHgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 29 Sep 2025 07:30:31 +0000
Message-ID: <e8735d27-2917-402a-86fa-7446b1acbfcc@suse.cz>
Date: Mon, 29 Sep 2025 09:30:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/23] maple_tree: Prefilled sheaf conversion and
 testing
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-21-ca3099d8352c@suse.cz>
 <CAJuCfpGBg7xO6-swzvk3vLhMxO+F=C6udEiNmAAC6LEA7vA9=Q@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpGBg7xO6-swzvk3vLhMxO+F=C6udEiNmAAC6LEA7vA9=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5CF59C0007
X-Stat-Signature: 5tt4u1q1xyhmyx96nteqzoj5mzs9e4hu
X-Rspam-User: 
X-HE-Tag: 1759131036-828495
X-HE-Meta: U2FsdGVkX19p5MGAlkgp2Xx5mbnizv+NKArHkeJxvmO/pFUFWw7BrY1zzJGHFDSETtBoi6iLoDOpFD8SUBt9AV0VDO/4kE0j30Ugyf29uaHpr336L0dn2O/9O/Nr3v+Huk9E3a4sN9Fz+zwt98Fg6Od5vScJoFEMUDG8zfHZngvXjviS5fj87PD5xLayJV919T6IWWd5JNkNDj6DPUGHhzqBlyJmR0OEeLBAzPpy0tB5ewSBhlaSbuhI2hqM2nE4+LBEYtiTUHNmLpd8AROwa3tyeOGp0qmb+vhpwaPZGHs/P7OZMTzkPMB5h/JKDdc3QJFTlvAcXvgsbOnxfpZ5okG+yIIOyzi3EsNm4RrgKvHQ+nqJbun49SplSVJrnq5DNr04rYDbg4LPGLyVO62iv51aJpQdR+DEmlPxZdU1qLMroe0smmBaAFJlE0JIEAYgYd8bgnTgLWKRCi9fQYNIn2AVpV159SkYmiiYbyJz3XCxLbiV5RbvgiovMO1hA4WApfnv9qAjPwRe3tzz1GM8jUqJ6IfVGx2YTfDZAGeAJg6rQqAgXDTNGfXo2mVp0gXebY9mYQR6Y6fj7KZOuGAf1pp297Sw/W+OgNYDHX7rt5/UkYS8KyPmT8Li2ZiigwTgqD6caD1Keu8rXFYMi5z7cyscf5wHkd+twKR9BXUfmen+3eaiCVb6f80d9HeBelKCRTivF6zxLKNWCHMLqNeeNDDSLV0rPr9Eb2yYW2mPTMnFesu5pMn3xbBmcnWExKEe0ZX1mHE4CKUJUu/9NvUAuAmtVGfjVhDU+lW83PmKYKevdhCZ/WRO/gXGZCqcwB6HgJSjuGnpvwzm7sivcXpenfu7G/+StPmg4igBzv9xIJQjaHBTfaA6cvSLQ0U7ixgsJTJM/oQB3OmvWSq8oJTQENB9jVBKZESQZgIf5eQC0YHa6YMIXPCR43jcD9zE0SbVHgMqnizYtp06PbvPMUQ
 3+Orf/mA
 G91E2Ly7EVtyRD7uQm5rmIxG16x5qaEwYXpNUk9vxcQPuenlE+CeyvszXeiTcsH7x0sJDlIliHZnYDOc76a6yZ2osCabWFFtHUsWLOJ164W6LgxxaQe3mw5ZfsWmE/Ck/DFS1k14smxvm+SLzvwlAxgtXJjtVh5hDEMmG1BOnUSP+p7GlX8J0A44x7siPOxBKm+2HlX5uRGTHD9IYrhbAjOYBfC+bOHmF3UyNNz5Kq9KF52zHFJzSmyXhNiJsOYpSqFaQ8+skFBznxUp14A6m+IiZ+hjxz3WNr4zxffW3+9y5hxKDlPRw2xY5sdGVczALiZsuOCqL6RyP44GLbRGA1RTGDVOpwX4hTY3hMc/B7ViOVjLQJkPbWc+Uww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/25 03:08, Suren Baghdasaryan wrote:
> On Wed, Sep 10, 2025 at 1:01 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>
>> Use prefilled sheaves instead of bulk allocations. This should speed up
>> the allocations and the return path of unused allocations.
>>
>> Remove the push and pop of nodes from the maple state as this is now
>> handled by the slab layer with sheaves.
>>
>> Testing has been removed as necessary since the features of the tree
>> have been reduced.
>>
>> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Couple nits but otherwise looks great!
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
>> ---
>>  include/linux/maple_tree.h       |   6 +-
>>  lib/maple_tree.c                 | 326 ++++++---------------------
>>  tools/testing/radix-tree/maple.c | 461 ++-------------------------------------
>>  tools/testing/shared/linux.c     |   5 +-
>>  4 files changed, 88 insertions(+), 710 deletions(-)
>>
>> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
>> index bafe143b1f783202e27b32567fffee4149e8e266..166fd67e00d882b1e6de1f80c1b590bba7497cd3 100644
>> --- a/include/linux/maple_tree.h
>> +++ b/include/linux/maple_tree.h
>> @@ -442,7 +442,8 @@ struct ma_state {
>>         struct maple_enode *node;       /* The node containing this entry */
>>         unsigned long min;              /* The minimum index of this node - implied pivot min */
>>         unsigned long max;              /* The maximum index of this node - implied pivot max */
>> -       struct maple_alloc *alloc;      /* Allocated nodes for this operation */
>> +       struct slab_sheaf *sheaf;       /* Allocated nodes for this operation */
>> +       unsigned long node_request;
> 
> No comment for this poor fella?

adding: /* The number of nodes to allocate for this operation */


