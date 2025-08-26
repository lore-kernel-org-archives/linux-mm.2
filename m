Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0900CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 10:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80758E00C6; Tue, 26 Aug 2025 06:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58278E00A8; Tue, 26 Aug 2025 06:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D46498E00C6; Tue, 26 Aug 2025 06:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF04B8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:49:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 976611A075F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:49:49 +0000 (UTC)
X-FDA: 83818588098.03.0FC8993
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1B32D80006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:49:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JgdPK+EK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3ePJ/LJK";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JgdPK+EK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3ePJ/LJK";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756205387; a=rsa-sha256;
	cv=none;
	b=XMq4VwabmXCq5FWwkESD8HVpx798VHRPyeLfwM0FEX9R4+/SR3sM2UNkMtTVxSc3fSbYFE
	KvXfPsyb0tty1ljWJGN8l+cHuAelbMZN1o7DIsUjQese/4y8Z/M3DzagCvEZP2d7Yk/Uiw
	0edr7cJnGgBttyklpFp93Ycps35/MdU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JgdPK+EK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3ePJ/LJK";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JgdPK+EK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3ePJ/LJK";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756205387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VzPVov0TH5MYgKnHIHfwqYpF+JbNqVHYJQtIE+j183E=;
	b=tKT8Czykoo1mT14zUmeqTT5DICX3GYQqazb1OFYgAVlZcnfdjuGNkqzj9PtCBIDRsG37LE
	6b2nPOzyqDuvOOAWb+tAdnYnKn57UG4KWkduU4WI6rRZS8gN12zam9YmQ5TPhJDfyF6jkv
	ozoDPQ1WKqXF5NtBtjpkH2Gi2qAtyYY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 955BF211EA;
	Tue, 26 Aug 2025 10:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756205385; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VzPVov0TH5MYgKnHIHfwqYpF+JbNqVHYJQtIE+j183E=;
	b=JgdPK+EKxPhCth3IgfD8bUZDoD3i2rRtFSHpSCYXqSo/zTNQyp0xD80yh5jp4AJXBrXjJ7
	RDvHZ7cOwrk8lt84mtJDf0Jrd00sElcL0aX5Gflr6FkEE0l5+szkeYSchNSTVsh4wLd3Kc
	HUlqRpJt9V28OjmrKKnEGZ9L9yqO068=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756205385;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VzPVov0TH5MYgKnHIHfwqYpF+JbNqVHYJQtIE+j183E=;
	b=3ePJ/LJKSTzyJGkXCkzD1WCDjuzkytCDAaqDyV91yH45P/gaGFXSUtX/bw0di0Y5wUTZYn
	45syQMorxmok2yAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756205385; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VzPVov0TH5MYgKnHIHfwqYpF+JbNqVHYJQtIE+j183E=;
	b=JgdPK+EKxPhCth3IgfD8bUZDoD3i2rRtFSHpSCYXqSo/zTNQyp0xD80yh5jp4AJXBrXjJ7
	RDvHZ7cOwrk8lt84mtJDf0Jrd00sElcL0aX5Gflr6FkEE0l5+szkeYSchNSTVsh4wLd3Kc
	HUlqRpJt9V28OjmrKKnEGZ9L9yqO068=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756205385;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VzPVov0TH5MYgKnHIHfwqYpF+JbNqVHYJQtIE+j183E=;
	b=3ePJ/LJKSTzyJGkXCkzD1WCDjuzkytCDAaqDyV91yH45P/gaGFXSUtX/bw0di0Y5wUTZYn
	45syQMorxmok2yAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D60013A31;
	Tue, 26 Aug 2025 10:49:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AnRKHkmRrWiyewAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 26 Aug 2025 10:49:45 +0000
Message-ID: <8a1455d2-3e5a-40e1-bfd2-455ab7fe1eef@suse.cz>
Date: Tue, 26 Aug 2025 12:49:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/14] mm, slab: allow NUMA restricted allocations to
 use percpu sheaves
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-10-b792cd830f5d@suse.cz>
 <aKwISYm2MO-zftfv@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aKwISYm2MO-zftfv@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1B32D80006
X-Stat-Signature: hemsg5remyonted5nsbpsbqfsnpfb88r
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756205386-865674
X-HE-Meta: U2FsdGVkX18hbnYUgGMXKDUBhAA6E2zZGkEOKNhhlrO+XzJr7Suud2iO1xv0fuMJEWXjryWyzKCZ3QdE2Vkf91IMU+zNsZe/obj/C27zvWYFgkYwWnkAXYnCWlojxCtv83xV+YqmKOfQM0Cibr+Q5UhHziQ/eO4zmlr7fEpJ5CBkGuFM23ATOAAS9e+Wvm5yBGlSxDD78zgWi+mem1GNLGpjyUDAMLl7WoeabMMfBo/u1gb31WWT6XEG33boF8r3N9O9lsMrSmUYRGKyqkPclm1zZOrB/CuWr6QkkdI8vOp3BSR6HNDJ1bQTx9Qru+Pa/RJdymR24ZR1Gr7MMqd8XcOEQ/d5fIMx3PBE7/ut0T2tXYUvTDufVjJSBroXGCo4GPss7XOb5nBshfYNSbOyo1GrfIa/Hbszjwx01OCPtDRbw3GPlcGcA05tnmDqv/yoTbCRRHlHMQ/8jlA7TTUGNsFY2hDG61CJalNlhimkX19Ug8KuBXif9+IxxJhqdC8czYUH/1WFJJ526qksfnQ2RhStLRdHs2VE6jGpDU1AZCfz48dDgG1F6JvCdgHKYDS1mL7xD6+g6g43jCvbYC7i3u41fDQwtggw4KHP1QFP8ZsY9kqSG0uRLnS73Jl8hRHh1z5bQy43ioTsb/VtUp0J1PZiI4p6QPmmIeiHX+96ODqf/J4HayPtnEVappNzyjRZDKsYqcnyxL5qPu+QtJ3VXq9Dfp2NvIkGjlhV1gecNiwACN1ax97ZHav/NkgJDVUCvxnQJj+oSwV2qhYFFW+ienHGdD/RRvQa8PKGjOXtEp0VO836GKgd0IX4uVX/e3QCHbF6RFGbqcecPtTz/oWoIRFDM+NCEuXFHgFRwU9UgxFtprxJX1oCQDv+hRquJzQLJOeAtcx4+pUcO1v6iKFuY+k+LO6Qos3JsXDanNMRT/twAOh/2eSPiTZNDqfkn6O3jG/MTrS9IxhzxZaXy+J
 S124S+1/
 ruovwtYnEC5NGpK5fI2VlNVqvTUvHe9klGZCTNQ455uMEl9xjqI/IxA6oAnXn2eJCwX2B0RN8e7VL10D4/tu6rAa4dkl/40p+W7iWOQGKUEL4xP1iULHmoFZF3OryziCBj12oMZPwYNPWALUiOvcJG7Ghkto9rKFP56JCpsYjrn9GUeZa8u/tRvQ0b4fjYJBj389HNBh4G22kZb+MoY5mu+nL83c+W8cd7YSYCmk6v7fmZVW1dtlM+yllAmKhCVyjJmd4+/A7TDorA94pHEKpUL33DDlxsE8aau/Jm13LCv/KjoAWYl1+5+0Vca6dNFwY+cp8mu6m77KdVrdIe7Tf2cdZTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/25 08:52, Harry Yoo wrote:
> On Wed, Jul 23, 2025 at 03:34:43PM +0200, Vlastimil Babka wrote:
>> Currently allocations asking for a specific node explicitly or via
>> mempolicy in strict_numa node bypass percpu sheaves. Since sheaves
>> contain mostly local objects, we can try allocating from them if the
>> local node happens to be the requested node or allowed by the mempolicy.
>> If we find the object from percpu sheaves is not from the expected node,
>> we skip the sheaves - this should be rare.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 
> With or without ifdeffery suggested by Suren
> (or probably IS_ENABLED(CONFIG_NUMA) && node != NUMA_NO_NODE?),
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks both, I've extracted IS_ENABLED(CONFIG_NUMA) && node != NUMA_NO_NODE)
to a local bool variable.


