Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5460606A332
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ouOKBGiW;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MT6YexHp;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ouOKBGiW;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MT6YexHp
Received: by kanga.kvack.org (Postfix)
	id EBCD26B07DF; Tue, 24 Nov 2026 12:10:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D4F6B07E1; Tue, 24 Nov 2026 12:10:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84896B07E2; Tue, 24 Nov 2026 12:10:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B12A36B07DF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:10:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A6BAC0C46
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:10:28 +0000 (UTC)
X-FDA: 85470651336.07.6A25343
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id E6D802000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:10:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ouOKBGiW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MT6YexHp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ouOKBGiW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MT6YexHp;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540226;
	b=Yzj165o+a8avSE2o77QCVPDZwBsReIyGg+dxz/RCywiqu6oJZIgJIyamOqUNm45k1ujPn5
	gwUeL5afSNm5/fIUKqG04+pPzrRtbrUaL939xq6zU2GucRCPwrC9IbeTxxLf/wu/QRu0ab
	8SDT8nfCD/WeOK9LhqsjRmg/UU9/H8E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmiOZ9jE34SxzURKngNYElesZIMTc/ECsCU/qgrMmZ0=;
	b=3xKxcj9UZAQ2rkN5kXr72b4gU1vTRk2Y8IeSV1aFegeODUsOhtp3awmd7T6dxsVcjxGFF7
	OeW+A3W5JO8j1Ny8V+KKGgP9kiCSawiK4FAi8rEfW8hoJJPcZoQu9enG3nWnxFPOpm0wz9
	UGKtf5H4shXtEnhXQpKcCbcN4OjHkZA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ouOKBGiW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MT6YexHp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ouOKBGiW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MT6YexHp;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 58F5A220A3;
	Tue, 24 Nov 2026 17:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795540224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YmiOZ9jE34SxzURKngNYElesZIMTc/ECsCU/qgrMmZ0=;
	b=ouOKBGiW5ZoEhaJv4o7JA1xOX8qZNE6RBZA5oqIfW8Exk/9UZfsVnJdB0HjgWIpv00ZQr6
	7QJsQQULlqg8nKayzD5Pao1ThAHdSS9cCUCoIuDAQNg5mfznmyqmULx8JegzMzbxuGseQX
	y+U3RSrjOvkj8emujkw8G+nnuMN0L7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795540224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YmiOZ9jE34SxzURKngNYElesZIMTc/ECsCU/qgrMmZ0=;
	b=MT6YexHppHoEfuAuG45dEEkVYWpWK9NGB27mHQf8G8wdsJULHUFWOowrEBo80Er3JbQA5v
	P/vO79+zIQ5iHwCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795540224; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YmiOZ9jE34SxzURKngNYElesZIMTc/ECsCU/qgrMmZ0=;
	b=ouOKBGiW5ZoEhaJv4o7JA1xOX8qZNE6RBZA5oqIfW8Exk/9UZfsVnJdB0HjgWIpv00ZQr6
	7QJsQQULlqg8nKayzD5Pao1ThAHdSS9cCUCoIuDAQNg5mfznmyqmULx8JegzMzbxuGseQX
	y+U3RSrjOvkj8emujkw8G+nnuMN0L7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795540224;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YmiOZ9jE34SxzURKngNYElesZIMTc/ECsCU/qgrMmZ0=;
	b=MT6YexHppHoEfuAuG45dEEkVYWpWK9NGB27mHQf8G8wdsJULHUFWOowrEBo80Er3JbQA5v
	P/vO79+zIQ5iHwCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7F481339F;
	Tue, 24 Nov 2026 17:10:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0SH6KP7EBWsYVgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 24 Nov 2026 17:10:22 +0000
Date: Tue, 24 Nov 2026 17:10:21 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Dan Williams <dan.j.williams@intel.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Kirill Shutemov <kas@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"Naveen N Rao (AMD)" <naveen@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential
 guests
Message-ID: <awXBtrPSHfs51Y2f@pedro-suse.tail5790ac.ts.net>
References: <20261124160025.738362-2-nik.borisov@suse.com>
 <0dc6759e-ada2-461c-85de-809c170abd6a@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dc6759e-ada2-461c-85de-809c170abd6a@intel.com>
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Queue-Id: E6D802000E
X-Stat-Signature: zuihfmrkwbu6b4ihwiucf8expkhbk9zr
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795540225-594259
X-HE-Meta: U2FsdGVkX19QUA4SOLS/qRbVD5RERyTaZw/Mp5v4ztEoUJY7tn+LHa2hK3Ri6o5df6TE0411COFEiBkhYqjoBQz/1sqpChSfP4WBF1yS+52/JnXS5x4yGz1UboTbMkNZsyPFVeNDxVaQuL2O6zCF56d5UexAb1XtxQkQQcpSb4ePeDnyn719jjnqWUy5yi9iZ7mCKeb6h1SmngnaNqsDwJiLWSvsxVPRV42UlRGPdLQNhgQdX7XMqmSGqLfntZHiclv0reqqabBVB58+LgU6wRaQp5Mkab7ucN1rUs9wa+RyhTb+OvVBSipZioZla6dhXlLowc6UAWIBr0fp7E2FvoeR2eqzCfaahFJV38xiNQqp0y6/f7LtniejqdVmM2HSGNG8AWMEuaDnARC4Xrj6FCFkxdYIFSxdo/ahF3Qzr9IoCqbVgZMzPz8Hp4jd2ouWoCwgpenzHXz8SfJiH5o0vh42k0K9GXTtux9lB4wJ0/tn7Qj3ltnORwL+JdClDEnbxg+KlYGScTq3lPMHHMBSUIY3l7JdtrpwFeWfYouVdm09b6K3fVQqS6nArf+jFjLDHPjKhU7IXNQ+caojuzXcDSD0KyM49UlVkbtXBZbj3n40/7QGucESBWIUxwwzEZC93yjS/lU5b0eURyhg+FK7bMkjrR4ikm1rNh7ZDpUXS3CXCX8kKrZRSgQfPDL+bfKFrp4MszFsWRlTMwVRC4tlBMh6/uAczk2qfx3UiiO1MQF+QIrLRRhtUAivclue4C50/yBYtxwnd28Xsp6KjfWYXnfuwvZfZ2MOOR9IEyxphL6y9m94wwGJj/iqNDUr87CAo9J7ioGWZTITEm/ezzUoDzO/WrBd/lh1jiXY8jMVARgl4le3/uBzRvX7bnSgP1IvdGtQjfGHVCRj/Z/FgVV8/PrZn0JDOSUow1UxPvWULsud4c+JEfAWzklMxJX1YvOwnDiYvDRL6P5nXluFp2Z
 KTU1uSKV
 m5vQUCYpSi+AcwyUpNn8UkGTiZyhoVZtnOdeaJhExSYdOAz8etpGBe0nEvFIDL21zgE+70vefgH1WeHxfjDJFbAUotTMUTLEA1Fnat9Ok7jNY00ffIUFyoyxNrprV4fq8QsrSXJx57PebNJOyD5G5vgXie5eG+p9Y7euhwbvi54cuDXo1WnPw7TiSLKI6pUdCGM2mwUb7eIYjWGy/CjBugbgKfwIqC9Sez2yyQqmg9tGEi7wLbrg7VkfgySmsVDsfEwo5L+JKkx7ulkktA/i/oaEUx4t6cTS1LrbB4bM9FlzugvcPCqTqVr8tZYx4vReh1gFiVEvwpFhMxaiDBLXiKpgInqtLwSSxlnb2zJJlOq5kPFQMUeylbTWd1KxDDMGFPISG8UjKcX+5vqkZCn5i+JXnMU/zC7qiOfk+hb7acpjN/krM8yqX5Ndkqx2ho/jS9AKGCNJjLmhpeipTaqnJQHXA/v/CV+ZQGkZuffXe8jHQjW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Holy cow the CC list is stale.
Fixing some up.

On Tue, Nov 24, 2026 at 08:36:45AM -0800, Dave Hansen wrote:
> On 11/24/26 08:00, Nikolay Borisov wrote:
> > Resending this with the hope of either getting it accepted or
> > arriving at a consensus what exactly is missing so that I can take
> > it from there and eventually get something merged. As previously
> > mentioned this results in real problems for confidential guests both
> > on TDX as well as SEV-SNP.>
> >  arch/x86/Kconfig |  4 ++++
> >  mm/char-mem.c    | 10 ++++++++++
> >  2 files changed, 14 insertions(+)
> 
> I'm still OK with doing this.
> 
> But I didn't want to sneak an mm/ change in via the tip tree. Any mm
> acks or naks on this?

For what it's worth, I don't love this fix. Yes, it fixes issues in /dev/mem,
but it:
1) skips any other potential problem spots (I don't know which)
2) open-codes random CC checks in mm, which is kind-of regrettable

OTOH, it's unclear to me why that CC check is needed. If configs select
STRICT_DEVMEM and IO_STRICT_DEVMEM, shouldn't it Just Do The Right thing?
in iomem_is_exclusive, etc. If not, could the CC awareness sit there
instead?

/me doesn't know much about CC other than *if you touch something you shouldn't,
it goes boom*

-- 
Pedro

