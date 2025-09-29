Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32202CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759378E002B; Mon, 29 Sep 2025 03:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3028E0002; Mon, 29 Sep 2025 03:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AAA38E002B; Mon, 29 Sep 2025 03:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 425ED8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:40:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7A26861C3
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:40:02 +0000 (UTC)
X-FDA: 83941489044.03.8A00A33
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id B55971C000B
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:39:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d08bKf5K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8XqAyLhG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d08bKf5K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8XqAyLhG;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759131600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnuzYQyeI474K9J3eTWh0Tkb4PmD5Tuf9JSGvZpl+hs=;
	b=q5nk30J7p8PQQZDoeqokj7A6g5ks4t/yLo9HyI/sEL5+oFUA7jPOk/fBWlDFz/p6R7RFur
	wrq0iWNOg5JCQwUQc9PW9qlKRaDL7ql1A/7ryHZbRuQJUkTi3kJfbiF3BlvnZs+JAL/bVq
	hd/cse98T5O9DNm9wfQrAuNe8ncI3Bw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759131600; a=rsa-sha256;
	cv=none;
	b=DfSDF7D+IyBaG/kMiw1nfetIf4befxihVOx6IVC9Vp6SI2S36nGOS3IOz9FcuRXr26kEtP
	mMfXuluzSfdRmFMVoehX/sCGLMXeJwrt2AI9DojuoA0lZI8SH9YT4ON8yHmrP/LQRhC3NQ
	LIeURBrU9xV9gcRIs9gAYUCuK9ltTxk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d08bKf5K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8XqAyLhG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d08bKf5K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8XqAyLhG;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 992072FBAE;
	Mon, 29 Sep 2025 07:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759131597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CnuzYQyeI474K9J3eTWh0Tkb4PmD5Tuf9JSGvZpl+hs=;
	b=d08bKf5KA8e3u1m1+sDxSP0BIrxpGGIS/q1U/fAPf1zukM8r9uodTgZcA/kDqdwoWXObcQ
	p0iCnzQfxWW4B0DGm9Xl3Kd1XtG73kvWvDJ4dTOFHbLKWFQc+iN3iiZwlBK8WKXlopAq++
	tIIbbvXCHXEK0ft0v85/6/0nBehu7F8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759131597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CnuzYQyeI474K9J3eTWh0Tkb4PmD5Tuf9JSGvZpl+hs=;
	b=8XqAyLhG8KNXnho5VzRetB2eVKfU0TaYYjFX8zfUHsphTWaWqBjw7NX4Fa7FoDm7FEojVN
	FnIaemOTjBymETAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759131597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CnuzYQyeI474K9J3eTWh0Tkb4PmD5Tuf9JSGvZpl+hs=;
	b=d08bKf5KA8e3u1m1+sDxSP0BIrxpGGIS/q1U/fAPf1zukM8r9uodTgZcA/kDqdwoWXObcQ
	p0iCnzQfxWW4B0DGm9Xl3Kd1XtG73kvWvDJ4dTOFHbLKWFQc+iN3iiZwlBK8WKXlopAq++
	tIIbbvXCHXEK0ft0v85/6/0nBehu7F8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759131597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CnuzYQyeI474K9J3eTWh0Tkb4PmD5Tuf9JSGvZpl+hs=;
	b=8XqAyLhG8KNXnho5VzRetB2eVKfU0TaYYjFX8zfUHsphTWaWqBjw7NX4Fa7FoDm7FEojVN
	FnIaemOTjBymETAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B18B13782;
	Mon, 29 Sep 2025 07:39:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LYSyHc032mhaIQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 29 Sep 2025 07:39:57 +0000
Message-ID: <6b983596-e521-4714-8a5b-758da76eb1c7@suse.cz>
Date: Mon, 29 Sep 2025 09:39:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 22/23] maple_tree: Add single node allocation support
 to maple state
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
 <20250910-slub-percpu-caches-v8-22-ca3099d8352c@suse.cz>
 <CAJuCfpGhv15YLyAm7X63t5gT9hkw+6PK3GZbWmOTng+AG7rEsg@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpGhv15YLyAm7X63t5gT9hkw+6PK3GZbWmOTng+AG7rEsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uctic5arx6hy3ta81f4bw33crutt3j31
X-Rspam-User: 
X-Rspamd-Queue-Id: B55971C000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1759131599-416591
X-HE-Meta: U2FsdGVkX184uAKB21ufdd8TNVU9pSNwmXkQUR+T11IQfibu7LhKUtU6Yx8TtxWuZ9jsgzWfzzyvrb7zdgB8gu3ICLXR/DyfsJfeh62kr7+UF0yzrYeT9MFKYNB+o8JA2MNZZFMjQMDF2hgiMgldmRtTMlXNzTvcREYrcT2bEs0kKsUby23hVnBGnIJrzA3K+fx7bYVOdmEyKK4nDCjwnRiNLjYSoC5EGfRJaWFuLxo1XtCbK2kcqM0h5iobYBTUnxcD4eGEvm3zurW2MftuQYG0HJIbsVB1YjVewujxk1Zsh/Y3/oeaK2zLw0kQNTq5G/iKN3r5IvA3wSTVy6K9La5/C1yc4hGfILJmDramlJmgn8V6Dza1DaJY/6Ni9Gb21yfevb9RXqZ27uh/vl2tEqajv6rImNSFKxWOZVaDaWqPnsLBN52z3m1AL4wRA3/DNVy+BeajWt0NzXQkASPgwZE4WgQ5TXY/BGS+5hEXOBUioiQSHzmcDizl4iG4PSQcdT54mrH1sy6I9g+jGJkkD1j8LK5Ti+0IUk3E2oHzaK7i4iQntZ2KdTg4q66jckwtr631XBp8OnfOt0Q1Dmd9BpcMdM3SGvgChtlzlNdM2fED9Z3qn/IjpJfndwAflMjLC1NRMd9QvIhxcX5b9RsdmjH6IhR+Iat8lIvqVR1X5jfLy0H9UNEZVbxdw7YwgEBNtqwhqQMqUGGqH9RINPWXdSNqPQnPxs26tIIjZSOsJW8gah4oVb98qLomIff7YJ5pfyJmX0mxbqe1B3kzs3j0YqUQyzuKt6UTvKPtFO6KDgPUBIsRlH5CgV90uGjyIxGbH6v9+90S7q9RgpkHSMiuAD7ZBb4ABKkMrqt5fhg8QWXXGCkkXJOI9BiIRoP7L+2W+10mmKU1S54Wcpp1SpvUcb35a5q18sAgcc36f2s4kitAQclqsFZw4eQiF9qFjEe3XaojReGAlZj61qrQGrK
 lwkDfkCv
 6A094jFgekQ9Rdcti+NfNsxByX8LUHrib77FtP3cMWoNZE7rYFdXmqdWwXcrilLK6VSIUUzh3drw6L2x+Jp+lyyH9H6cdYj7/iU3TKVfElrl3p/aXtr6nIuuaSyv2ESD99xgPHjy6BGYac1RemE4BGJRj6SIlXYmAMshUIoIEPaZ1vWyShKIfnVwG2g2+R6I4IwYYLoc+6yEqeLDqLgp1xXRrJPiyurEJzuVyoWRFzZ2FGBJiUYgVx4C99rhv0Tn0HIv1u/MylJz9NMsf9a6hBRQc7sUB8I/TUR6SZN1F5TKTtpS5eVfStFJUtZMQYW4q4BAFC79t4gqf+rVTqgX6jukevOzFrErzAv2OkOrqxzs/fwY1LS7KrbvCpF0m/eZVhhoC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/25 03:17, Suren Baghdasaryan wrote:
> On Wed, Sep 10, 2025 at 1:01 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
>>
>> The fast path through a write will require replacing a single node in
>> the tree.  Using a sheaf (32 nodes) is too heavy for the fast path, so
>> special case the node store operation by just allocating one node in the
>> maple state.
>>
>> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  include/linux/maple_tree.h       |  4 +++-
>>  lib/maple_tree.c                 | 47 +++++++++++++++++++++++++++++++++++-----
>>  tools/testing/radix-tree/maple.c |  9 ++++++--
>>  3 files changed, 51 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
>> index 166fd67e00d882b1e6de1f80c1b590bba7497cd3..562a1e9e5132b5b1fa8f8402a7cadd8abb65e323 100644
>> --- a/include/linux/maple_tree.h
>> +++ b/include/linux/maple_tree.h
>> @@ -443,6 +443,7 @@ struct ma_state {
>>         unsigned long min;              /* The minimum index of this node - implied pivot min */
>>         unsigned long max;              /* The maximum index of this node - implied pivot max */
>>         struct slab_sheaf *sheaf;       /* Allocated nodes for this operation */
>> +       struct maple_node *alloc;       /* allocated nodes */

Replacing with: /* A single allocated node for fast path writes */

since I'm touching it anyway due to previous patch fixup.

>>
>> @@ -1093,9 +1100,34 @@ static inline struct maple_node *mas_pop_node(struct ma_state *mas)
>>   */
>>  static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
>>  {
>> -       if (unlikely(mas->sheaf)) {
>> -               unsigned long refill = mas->node_request;
>> +       if (!mas->node_request)
>> +               return;
>> +
>> +       if (mas->node_request == 1) {
>> +               if (mas->sheaf)
>> +                       goto use_sheaf;
> 
> Hmm, I don't get the above logic. One node is requested and instead of
> using possibly available mas->alloc, we jump to using mas->sheaf and
> freeing mas->alloc... That does not sound efficient. What am I
> missing?

I'm not changing it now due to merge window, only cosmetic changes and r-b
tags. Can leave it to a follow-up optimization.

