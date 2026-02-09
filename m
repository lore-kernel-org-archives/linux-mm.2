Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C42E7E0CA
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 11:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F95E6B0005; Mon,  9 Feb 2026 06:17:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7276B0088; Mon,  9 Feb 2026 06:17:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788F36B0089; Mon,  9 Feb 2026 06:17:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66B046B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:17:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC4621B333B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:17:40 +0000 (UTC)
X-FDA: 84424667880.23.5CF7B69
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 76E6A4000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:17:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QNYPF32C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r4sVteLd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QNYPF32C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r4sVteLd;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770635858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QB/fUURelZzUZfFiB8QGjtTaUX+WAHkV6R8O7qOlYHw=;
	b=w1qXOHTxzV/x2kWhL/ate8At7wTq/TehxszU5eQYNuDfT51F7tQvkBmdrBQq3gSr7RqjOk
	B4qnWXsHz0/tKL3MqBGQ64ECkcbQPY8bhQZPJYzKSFLSExoRuBPylrQ5o6iZXUfMLG4Gy+
	6M1SqmTTAXI6sbRThQ69ZIifUtHqo7I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770635858; a=rsa-sha256;
	cv=none;
	b=M0kX64a15GQ28LZR34Nf5xwKNoQDSGNOV+eBGPdtqCHpNp+BirHwlClkJbseImjs4qZ0gG
	LvYiBY8etLGam/ZvhOtJeh8gnMLVTmlT7YxYPcG0lo3v9tgOnsHlGK6OYdbHVAOZc/Jvw8
	p6KrqUPll7659K9jDD6fwy657nBKGyU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QNYPF32C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r4sVteLd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QNYPF32C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r4sVteLd;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AD5663E6F2;
	Mon,  9 Feb 2026 11:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770635856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QB/fUURelZzUZfFiB8QGjtTaUX+WAHkV6R8O7qOlYHw=;
	b=QNYPF32CVU0OzgZCNLTj246JqlAS8kCBCLx9oMW8y41mEp49y2hjtVXvr4EEK0j7Agh2vv
	F6ZiYAGc1GFq70027TyUSksnprXr7WD8KpVosPT1Y3i4fWebYBu3sr6cJyTHw3OoCdzN/r
	i4bkZfNKV5pkqxKYudH7QPOm6LeowNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770635856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QB/fUURelZzUZfFiB8QGjtTaUX+WAHkV6R8O7qOlYHw=;
	b=r4sVteLdTIpcPwua2xbaIrarFALi14shcRUGkIayo3Y2PpQxcE+zFZVwQnY2yNsV5Fd9X5
	6jILeWOXM7m1wTDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770635856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QB/fUURelZzUZfFiB8QGjtTaUX+WAHkV6R8O7qOlYHw=;
	b=QNYPF32CVU0OzgZCNLTj246JqlAS8kCBCLx9oMW8y41mEp49y2hjtVXvr4EEK0j7Agh2vv
	F6ZiYAGc1GFq70027TyUSksnprXr7WD8KpVosPT1Y3i4fWebYBu3sr6cJyTHw3OoCdzN/r
	i4bkZfNKV5pkqxKYudH7QPOm6LeowNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770635856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QB/fUURelZzUZfFiB8QGjtTaUX+WAHkV6R8O7qOlYHw=;
	b=r4sVteLdTIpcPwua2xbaIrarFALi14shcRUGkIayo3Y2PpQxcE+zFZVwQnY2yNsV5Fd9X5
	6jILeWOXM7m1wTDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A98B3EA63;
	Mon,  9 Feb 2026 11:17:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sRqUHVDCiWnTKwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 09 Feb 2026 11:17:36 +0000
Message-ID: <a38fb457-c0e8-4089-a31a-ac59d06a796f@suse.cz>
Date: Mon, 9 Feb 2026 12:17:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <51f96b31-fb59-4cda-9d33-e3cebc45686b@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <51f96b31-fb59-4cda-9d33-e3cebc45686b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 76E6A4000D
X-Stat-Signature: haxfwc59sx8ugbtggxg6szpxeuj7wfzw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770635858-824008
X-HE-Meta: U2FsdGVkX19Ar0PJLAm14bwHVf+44ME1ANIdk7+RUfXPTJfAKxYbLGF4mYXMg9JiSwvOcKZShLCzZSVXHSnzCmcMV0ic75yqRYxML9DievSzcqnfqToQTH0+UeQ3PSSw7Isa40zjvfuooa3Dy5g5UDgtk1RBTQeAwb7zIa6OVgfViACWrLuz3eq2nua4xt3yoCx9NrXjUNEyHV2OEj2wRPOlQzlc7+cZLbwSu/Fc4I8YQo7rQLNsfrxuZUGt3frNUTf1U3/+/X7ATaFSUSfQQQeqYdpSag1RUmiEfK1A0qvtJtiYigURUNcBi9389eZWAuu521B1Jbb2cH6Xh6yxAGoCaRTW6wOFUFXc2Klqss2lMZ9lQsU9OFkwdOrwzJRyNzhurP1GJxxn6Iy4J0f2KlIBNcA2aQDtWEit3Tk0Zdl0ZUM6YJPAwH0jQEojj9uT4zk5G0tsvt/LQTxdoNJ+qs8j/zxAMyHQN0XH4Xr1eMF9H02Msb5+Aod3gbTjRncta9k10/VRSdRBoO56jLQgFkc/EfVvgOqJiM+OozYh5DU2kK3Kx+OAWiPsQDIqOlq5XiPEVlcg10dgG4veNi61w//C/hN19vmzvCMN4MlbJk+k0SUWDFvkLM8qe/qEeUHFy67hI/4A0d6LTpJlu3rzdf7UkzzF+CRnfFCZ4hKZ26ewTlDquZ6d8HF809Zns73tVt6pySj/g6jAbDxm3vehokj3c0rHbTY/iLCBWZLrnBUzHIQen7sVPAURazRkaJM4mganFHKcLXQ40aNDzEY7ViL5Px6dyvsGApgSYfQkJKV4i0fRNqGwbmHeLSg7NQdhc6ODHxZff1WrLWm5087CdDN0zHbAbUQ+FBo2sw9BLXo6amZOr6MxW2FwlEPSa00WYepVbmNpWCnXsw183wnWgnQu5lFjDYO7UQSrr8kgZwCID7qKFQJzG8cPHAf9F9+O7c6bvr0iwylnBYKsr+J
 npbwKZig
 /4QxKVLokcrLwiiF0/dbz9tIdacotTFGzVioMQ7gKsI1sZgEebwFGEdsBcS691eh4gPBNdsawRi6F/szHg6cIMQdElLJ7SJKer/Xq4BApD47ckKXuhR2cKdZ2yGbI8wNmwYVO2J+PGZr+HMzvmeJBIwKhHRcYLwyOvDNHxj60lyPI79rib9Dw3ZfSgXCb3ClUjPJkhCrnNXqIrebsQ6Ki+EOcNtl0S55ARQtj2tSa+sNJpN1piuVMjzQcUhCdMwaYVnHc9DSUgu9Fi7SeLe8GIu52osrP9QwYarDM5Fbq0bFT6f+jf5PkB5nrHJkCb1+xSyZ8uyYdL5OJ36uerAIdza8ZZHyzFB4XFvBGtZXLB4BT9niQiPYogWsKexOw3gveMMREDXsn2ZH9BLs+u3fI0vdcq54DAyWzFYidSHdoeqp5DB4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/7/26 23:08, David Hildenbrand (Arm) wrote:
>> 
>> -               /*
>> -                * page->private should not be set in tail pages. Fix up 
>> and warn once
>> -                * if private is unexpectedly set.
>> -                */
>> -               if (unlikely(new_folio->private)) {
>> -                       VM_WARN_ON_ONCE_PAGE(true, new_head);
>> -                       new_folio->private = NULL;
>> -               }
> 
> BTW, I wonder whether we should bring that check back for non-device folios.

If the rule is now that when upon freeing in free_pages_prepare() we clear
private in the head page and not tail pages (where we expect the owner of
the page to do it), maybe that check for tail pages should be done in the
is_check_pages_enabled() part of free_pages_prepare().

Or should the check be also in the split path because somebody can set a
tail private between allocation and split? (and not just inherit it from a
previous allocation that didn't clear it?).

