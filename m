Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B38FDD3EE8A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26FC26B02A1; Thu, 22 Jan 2026 11:26:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2474C6B02A2; Thu, 22 Jan 2026 11:26:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F666B02A3; Thu, 22 Jan 2026 11:26:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F28736B02A1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:26:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FBA5B8724
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:26:18 +0000 (UTC)
X-FDA: 84360127236.29.AA06538
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id F3195140007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:26:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jJKKItUR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Dk8Q9Jze;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kL36N72O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=13PF3AMW;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769099176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhAO6JRvDmgniWiT+4x4JmaEjz5+uH6dH2x0bAyzNW4=;
	b=ZDP1LqGzeTeHLjlNL/HhvU4MsvHXI0mITyzy9/wsc/yPYAcONYE0v4iv8Y7madZIVgRuOu
	8enGMRZYaTgTUIo7jPOWwXt7YBsfdHvNMskcPROEVp8tnqpdfOd3KVFZHkQXNkRDpIQsG0
	3dm3Yd89mSqcbDvq/AEII8DdQLX46Fw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jJKKItUR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Dk8Q9Jze;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kL36N72O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=13PF3AMW;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769099176; a=rsa-sha256;
	cv=none;
	b=Rwd6i0Mfp5abB6I7ySeF4mdoex9eVCU+B0zkih8LztUcB2zqQlzD3WSslxkHZKstnKyAJP
	z+ildeOZJRjWx8Hig8VvAQVwSbTyLZp5euMSVe80gl8+KcwmzyVGYSwAL4iYG6YJcmoIN4
	vn1I5xN3cGmED7J3bqqFQnXCS+OIKJI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EBE4E336C9;
	Thu, 22 Jan 2026 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769099174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lhAO6JRvDmgniWiT+4x4JmaEjz5+uH6dH2x0bAyzNW4=;
	b=jJKKItURmgece1TxMBzVqICRtrRaWH4bi9sSOMofdpKEjOrjkVp8MXMVFr9OzM/QNzpUFM
	k5u/7PLc9Pk3Pehw4W+9if9HoohZ1lirvQkgNq4DK24WmAj2Tzifkw+3FyLxox9r6cI7z2
	FfJ+9ZXGTgWv011ow1Obuk5qKt6af0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769099174;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lhAO6JRvDmgniWiT+4x4JmaEjz5+uH6dH2x0bAyzNW4=;
	b=Dk8Q9JzeQ0XFx0pcsQB7lolqcDY2bg1bzejIy8RSXnW2uUkGiwKuI61z8TXoV1QOQam/9m
	H0Rx1FEP/PUrymAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769099173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lhAO6JRvDmgniWiT+4x4JmaEjz5+uH6dH2x0bAyzNW4=;
	b=kL36N72Oet36756J/1vuwz8owAMhV2/prKIPiGTIMGjIBvPEfcAbdgipiQa6unAz1i11TP
	LPabOQS0CUykRzuqlY4q6F3IJigWRPCS1JdqZ+MV6q/7AdpZIjl8/4yEKgnyhj5FbFQT+p
	WGks+SY5bmLAEuFz5X6phqSl+jMY+lg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769099173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lhAO6JRvDmgniWiT+4x4JmaEjz5+uH6dH2x0bAyzNW4=;
	b=13PF3AMWNDe+efLmUcgmWXxsv/urwyiwIm3npK6io0t1DBmpQl02NiYvPGaUIiMYV2ml+7
	3c+CaNIrkPP9sKAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF7A913533;
	Thu, 22 Jan 2026 16:26:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pxqAKaVPcmkoGwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 16:26:13 +0000
Message-ID: <6c8b63cc-d357-4e70-89d4-07afd004bc83@suse.cz>
Date: Thu, 22 Jan 2026 17:26:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 01/10] mm/vma: rename VMA_LOCK_OFFSET to
 VM_REFCNT_EXCLUDE_READERS_FLAG
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <f637c1a5c9ea237aab598bd8885df48e21497635.1769086312.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <f637c1a5c9ea237aab598bd8885df48e21497635.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: F3195140007
X-Rspamd-Server: rspam07
X-Stat-Signature: 4h1kzemoouqpueq7cqhoi51871ohz1m4
X-HE-Tag: 1769099175-664687
X-HE-Meta: U2FsdGVkX18MJDszw/IhFSNRUWE7gP69pyP4HBCCGXezTZ84OZskpZRudZte8yeKCbAczKSOnQgnDpjEGACTRh9QiwUUT0qVsX9TJ3K/vSNasdX0X9xJDd3fai80PQ04t6fTo5265gUytedbuOr6dNtvu2OT8OG0CQRBH1DoSt3dK3cTgKzQ2YiWgYnG8iD7xjXzfT1uJzUvxR15Yy5tppnt2JFSvpx68ALC6PKsoUVQ4dvt4hwyHPhprECnUR5d5ZOO1ne+de44GNIIwOyF0lyTxW2j4Kky3e6mP7VwFvMkr1MBuAOlc7YKURttItkk3WUVdt7PVntzEcr4qdoxo9kRtpCBMzAq0a1/46HaIWChCJmHs/JJ27llVdAJdXm2i/BzA1Ovyy9udchXXMMH4cM/BZ8znOHMM4BnThMQTv4YpI21JXnN8fM9YYYDIg/lpPBdBkDTv/7tkPOoxD2uGIO+uvMwjDLVwy2deT8nXHXU3SVpYvPVj7rBTkN0y5QrmJ+b+UfW7F3oKJfh3+LEvs+2KAk2HREwhswGfE3jcI0bMnfqMplKN/WcAOasPxQaBxekJpoKYNNU+3LD7RdNfZDcuW1XvPwotXniDPiDZ7Wtfobv7kN/5BNggWbYyOWNsUi9jEZvcbPjmej9tBcYa1m2jzZJwyT0MmEMV9r+GdbuP18EVdtoTotcPVOmt9C9cXo/ROoPBcjpE246PrmkjmIW3NJm8G7RhU+4+Unoqacwg5UthetrEF7Sl21111g6XMzoSftiZJ4VmSEydJEzetsIAelKYjVS/koN0sFyal7FWEM1xXpDg+F2PuM2kWWIUlNMZ+rHw8kUtWaX4awNpDt2srv0Rhd8qGsPZ3PlnADiZOhTsw/xtOJ8xNiKKlgHoWHtovld2QqU9A0FE39IF+ye3lNs0lwuwycdiMQ460nI6A7bjvhFl7a2t7wmS/CEmOCg9a4rP1/cpLxaGXt
 y5opPgPQ
 ixTTFTMdqd5xBSEJLyc/lwzyEO2KqsO/KdTcUSYGZ4XWj4x6g+SiFFpZVbuGQvKCfJVdlVzwO6qk2tlyEYPMduLljl/UCb5Jj6GcC86TXCmJsJEqeO906/FWbELV3isjDy410NlmTV0oCl9+UFgdmhGp+1mD9XBYTZVPU7TcvSkcNZ8ydPv644Ngr8TXFVsVJElzfmNXhq3WIJUfaed47Z7GXmpF9g43bsmmqzpEpBfnodqlpsGt4tr/uImTuRp8tmtcShd1aXW1GUgmaW7GQiNz9HSb+xGqjAe097TVLcBWul83qBRuk8gQF0LR5xGN5cT/DmlVDdzYrfyGLV1zE20Le0pnpFIZCvGKptY/UWrXrt/+NDuhu5EJ2DJW5jHiqRQSKQB3q1zcT2GrHggz59yHp8cHwymF9wak7gUSRcwvDmx4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 14:01, Lorenzo Stoakes wrote:
> The VMA_LOCK_OFFSET value encodes a flag which vma->vm_refcnt is set to in
> order to indicate that a VMA is in the process of having VMA read-locks
> excluded in __vma_enter_locked() (that is, first checking if there are any
> VMA read locks held, and if there are, waiting on them to be released).
> 
> This happens when a VMA write lock is being established, or a VMA is being
> marked detached and discovers that the VMA reference count is elevated due
> to read-locks temporarily elevating the reference count only to discover a
> VMA write lock is in place.
> 
> The naming does not convey any of this, so rename VMA_LOCK_OFFSET to
> VM_REFCNT_EXCLUDE_READERS_FLAG (with a sensible new prefix to differentiate
> from the newly introduced VMA_*_BIT flags).
> 
> Also rename VMA_REF_LIMIT to VM_REFCNT_LIMIT to make this consistent also.
> 
> Update comments to reflect this.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

git grep tells me VMA_LOCK_OFFSET is still used in
tools/testing/vma/vma_internal.h but I guess it doesn't break the tests?


