Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9DA1606A336
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=jgqsZvXA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kfYSjtFj;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=jgqsZvXA;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kfYSjtFj
Received: by kanga.kvack.org (Postfix)
	id 05FC96B00EF; Sun, 15 Nov 2026 17:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0105B6B05BB; Sun, 15 Nov 2026 17:04:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68A66B05BC; Sun, 15 Nov 2026 17:04:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C76BF6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:04:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 496C214084C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:04:59 +0000 (UTC)
X-FDA: 85438734318.15.50F070B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1B0A8C0008
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:04:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jgqsZvXA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kfYSjtFj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jgqsZvXA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kfYSjtFj;
	spf=pass (imf22.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794780297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUYxq7sCuPQGxi589AvNCc1rPmpCBz76vLmdvKJICFs=;
	b=Or3PZcGDc4y6rWp3XWQJKe0ohlelErdZIL4ovgoBHl+2GTZJyl5PTdzGsFn3jvMngiLK/k
	LNjSZCqJa4o+5BsMOYLzwv2LCDgtrTVd3O+51c3LCqkl5bycR8uKDNqsEl8+4omKFkCebj
	8dm2uwUkpmYD0Dzo0hHdTfbPaR9VyWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794780297;
	b=MU8Z9GeeiLVzKdNk4M/FYEiL1TcQBT4HWvXS/KSxyDCazI/1bcmGzlH9JBOESA1XZDO+nb
	LNVZXyBJ7RDQ3iczY8c+YgcGl708sDBaGf9Xi89VPGS0t7fQtu8v2eBrLGlLel902qW6QO
	4aXLFXq7I/fvBdFqlWox6UxC/udAkSI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jgqsZvXA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kfYSjtFj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jgqsZvXA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kfYSjtFj;
	spf=pass (imf22.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B11851F449;
	Sun, 15 Nov 2026 22:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUYxq7sCuPQGxi589AvNCc1rPmpCBz76vLmdvKJICFs=;
	b=jgqsZvXAQv3sa3ZKlAOT1DBrXfR53fZtdjR5VWrSHuB5csGHYm4IdRMdCXDLXwfrHFz7Nk
	x3SavfnF4aLjII/x9VKOdyQ31FSXdXLX6btCjycj4QVAv9EsS9pY3vH6gqBBcLp/uzz5DF
	S0w6w8b8/rsc7kCDFGgOimgz6K1zr8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUYxq7sCuPQGxi589AvNCc1rPmpCBz76vLmdvKJICFs=;
	b=kfYSjtFjQVHLxnSdfm48vtiiUnf91Rk+0jfqMhKDSMiofz2Mp+y0l41sq3BcrY1v4jgmO9
	nj9NC00Byc9jHIDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUYxq7sCuPQGxi589AvNCc1rPmpCBz76vLmdvKJICFs=;
	b=jgqsZvXAQv3sa3ZKlAOT1DBrXfR53fZtdjR5VWrSHuB5csGHYm4IdRMdCXDLXwfrHFz7Nk
	x3SavfnF4aLjII/x9VKOdyQ31FSXdXLX6btCjycj4QVAv9EsS9pY3vH6gqBBcLp/uzz5DF
	S0w6w8b8/rsc7kCDFGgOimgz6K1zr8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUYxq7sCuPQGxi589AvNCc1rPmpCBz76vLmdvKJICFs=;
	b=kfYSjtFjQVHLxnSdfm48vtiiUnf91Rk+0jfqMhKDSMiofz2Mp+y0l41sq3BcrY1v4jgmO9
	nj9NC00Byc9jHIDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A80FF134F4;
	Sun, 15 Nov 2026 22:04:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8Vt2HoYs+mrodAAAD6G6ig
	(envelope-from <clopez@suse.de>); Sun, 15 Nov 2026 22:04:54 +0000
Message-ID: <eabeee00-1ed9-4740-b7b6-6b5be5496766@suse.de>
Date: Sun, 15 Nov 2026 23:04:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] KVM: don't zap secondary MMU on permission upgrade
To: "David Hildenbrand (Arm)" <david@kernel.org>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
References: <20261112142039.907090-2-clopez@suse.de>
 <2ff19317-8da9-4014-be04-27fc218b8eea@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
In-Reply-To: <2ff19317-8da9-4014-be04-27fc218b8eea@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B0A8C0008
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: spbw875q55nqhk5r3gbwygewrtrek157
X-Rspam-User: 
X-HE-Tag: 1794780297-979011
X-HE-Meta: U2FsdGVkX19qFejkSukaVTuqo0w5oKeoYQyf/eA0LOvx+nDPcQXh79EhlZd2W6GSd5SGOljyPk/0/s0vN5tGHjr+fPcWX2Y7+uIx6oCctAy/WxJuJnZEWFVwwzMUMUr3xytW/yBRCUFQKNfy3D4fA5tuNdXmwS6lW7y3JBSwznNUtNLoUWHJ6NYtqW5MCJi/FSAGc2aw848FHXMSpXmANcbKY9J+lMsy3tmlmSRucWqcBtk8pQSPlkDOH5cm8lwLlPwe4pEBKK5F6X1R2xwPmApMN0GsrgMq2SV8VsmQOOCg2Hi3z8SxSldD5qJYnEzJ6XPrzJyBqIKvr2vKLjj4DITiEMfNfyzK+pPkZgOGpqhlnDSlioWWpVI0+MPnwtrD5oCawkyHmKajfnM53IxEx1l/NGlYGIiMJnr3DnuFvnqtXqQHNUnEilf3D6CrYfmgU8kF/yHcUY/oAfNkAF6q1yNVlGY2UPkXCoepjcX3QfktSIKQFXkn2BqnToTCYkCb2UTutj2TN35A99BoVSRb4JKkl6jelMkwAY/rwHHyPskY4W/Pdv0hMB++3dl94OO0+7xdz0qj+d4D58rMIMEHYtHrfpEJxbSqt3JyKV3vnWj3XvLDqa3NmRPiN3CXxnsrqcfqz7RTKGPsS8EXYvei93Mu0aSjmfW6XLzLVZdlYsaKmkklxBAuOvK4Bhz4+nanerlpRasYgrC5ftKdEh/g5kf89IzJFXjoDbAPc7aamu1oAS8BTEeIs+cOQ8Ux/2736kQG2pcSNbQP+SiaE3Hcij4W/dzWElXIwV0koeqa/k/BfN7k52Zxhix2EbYMmc8+keTyJ1PA8lT0zdTRODHsFLrvQEEwjCrIBBult/xAsUjOj9qW/wtnHH/VaN2AKAe9Fxcw14DGxiu2/JpWxUkiN+McLFv/nsQnpMJMu6tLKLSpDkf/XJKkRQHysb2j1HxhPwsSGBTsfWi0BSfInK+
 NmMHY2zd
 fer/LosG+eC5jGlmg1pW9JrG9vjUJBNrP/VHv818GSf/JZJreA61uxh/8F2X8qqCjFdmXLMCdyKoFZQfWCM9msC3E839waryiD2aGcHSI9BSLsGh8uitfuHbCzguNA65oYhsMicZWUTWGUb+LVuV+d3/VEW0mkVRicy0NmjK9KQCnpeDHWq9rB4jD7CB1AdZwPIFCBi20/PBJOAZAxdk+XqHePFzu/O8dzPpSLtGHYQxzGEHUukJuanL7WUQzU3YZM5fyHIIGZy98W57tNgqogqPwaI2Mv5W3lG6IqFVd3/iyGt7KmpEbOBYUFGpzUN93wK2aK8SGcnvB1Vk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 8:00 PM, David Hildenbrand (Arm) wrote:
>> Series overview
>> ===============
>>
>> Patches 1-4 fix cases where change_protection() needlessly makes or
>> leaves entries read-only, so that the next write to them faults. They
>> only affect performance and can be picked up independently.
> 
> We generally don't add performance improvements without clear motivation and
> data to back it up.

Right, this is on me for not explaining the dependency better in the
cover letter and the commit messages. Patches 1-4 are required for the
new notifier flag to be correct. I'll explain this better.

> MM is currently busy with more important stuff, so best to keep your changes to
> a bare minimum.

I had not seen your "Firefighting mode" email earlier this week, sorry.

