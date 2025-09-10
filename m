Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14ECDCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725996B0008; Wed, 10 Sep 2025 08:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD326B000C; Wed, 10 Sep 2025 08:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612DF6B000D; Wed, 10 Sep 2025 08:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50ECD6B0008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:51:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1B8611AF48
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:51:54 +0000 (UTC)
X-FDA: 83873327748.15.1089978
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id B5E86140008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:51:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BEQjhRzB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rurJ8SqK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BEQjhRzB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rurJ8SqK;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757508713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIJwL+vMh5l3ck0ee05Ab56qH+FWN4NOst1+i0OxjGA=;
	b=etXjM8n0Y0GBWxpS0JJuFct5u7QbUczZ0C2g2t9XN7b+3k2KrnimrFmpGHUeF5tZCDPzEj
	9O+nhNEoaGlao7Gr0alk6SQNS8Uiz/NEOI3nXS578G7Raj0dRzl32dGB9CDSQhYSvEqD86
	GVaCDZ6PCdA/WpiRKHAU/3qIM1cEv9s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757508713; a=rsa-sha256;
	cv=none;
	b=DvW7sK+c0bGfMJv/8xQ5wPHgGVvyKFLGm6CwQ7nQhZYgxR1UvIGHaurgpkG15ygn9QSahw
	GMqfW+0XrNSg6rdmQLr9yRoz9/4J0v7WWDBy94Z5CFpsCoW5//OM4EwQ05l3r10lAckpLO
	04p3wfZ7HYvDEYJIdxF9wVl1cpkIUDM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BEQjhRzB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rurJ8SqK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BEQjhRzB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rurJ8SqK;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 34EB233BBC;
	Wed, 10 Sep 2025 12:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757508710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pIJwL+vMh5l3ck0ee05Ab56qH+FWN4NOst1+i0OxjGA=;
	b=BEQjhRzB9UOagEQUB1jwY8JPKwFHrsS2euVJogIqH05KzOX5/cmV+rY4+wMae0xbXyc4QG
	39MMw9gIo08ZwB1P+PaTxDrIwlHgZZaERSZpTqm9jPVEMoJ8M/PUffoAHTdYjwP4x0bIAQ
	AGBcMnWSc7TOeY1wr23u333rThoGv4U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757508710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pIJwL+vMh5l3ck0ee05Ab56qH+FWN4NOst1+i0OxjGA=;
	b=rurJ8SqKSm3tUtl+rSX7DnHzzed1vyieHCjaVK04+xrBTLhl0c+m6dlFRUvOyeuaX2XCBM
	ofdzq/mM26k8C/AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757508710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pIJwL+vMh5l3ck0ee05Ab56qH+FWN4NOst1+i0OxjGA=;
	b=BEQjhRzB9UOagEQUB1jwY8JPKwFHrsS2euVJogIqH05KzOX5/cmV+rY4+wMae0xbXyc4QG
	39MMw9gIo08ZwB1P+PaTxDrIwlHgZZaERSZpTqm9jPVEMoJ8M/PUffoAHTdYjwP4x0bIAQ
	AGBcMnWSc7TOeY1wr23u333rThoGv4U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757508710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pIJwL+vMh5l3ck0ee05Ab56qH+FWN4NOst1+i0OxjGA=;
	b=rurJ8SqKSm3tUtl+rSX7DnHzzed1vyieHCjaVK04+xrBTLhl0c+m6dlFRUvOyeuaX2XCBM
	ofdzq/mM26k8C/AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 047F813301;
	Wed, 10 Sep 2025 12:51:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IJTGOGR0wWgoAwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 10 Sep 2025 12:51:48 +0000
Date: Wed, 10 Sep 2025 13:51:47 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 1/9] mm/mmap: Move exit_mmap() trace point
Message-ID: <q6qlfs74tevbckjowf76y4fbfejr4ulyzrb4fkgq25qgebqnaf@colkcmdzt2bd>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-2-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-2-Liam.Howlett@oracle.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B5E86140008
X-Stat-Signature: rncguwxipb4cj6p5pwi99w4n1joyk6ip
X-Rspam-User: 
X-HE-Tag: 1757508712-305406
X-HE-Meta: U2FsdGVkX18auPYYTenQGgWsxPL8L8jCkfM60cfQskpNi9etTTil5xctzasplMGLhpQFVebeuW1FoySxAtRNre3zRc6Z+kPKpUSma6xWy7pZHdc+wOhNUJnwElU5O94rFiDWRiZvVnkerxlKowGUx+rCcv81unbxC3LhNiEXljLGdj4nNERXBlZfCjWJMzcL5YFmg9JDK5+UGuH9bbpZraRKQ2HLSGvyLxUjTChLNukgw/qi3Y7iejkTKN11a31OzPONoCN+Jv8frcDz7doOzped/WCxbMgLOQCv4CtF56HetceU5tKUqkm9wcc34qRxlQvABU9Dav6J22AYPYe032V3K4tjzz9PiwlegKfim2MPy4pdAcXOAgNNO2n7wuoeN+NQ0+kUIdz1M2LJOh6nXfCDtxmoEY0MCHmPIpiDsmFls/AUu45pJ7vUEZPKu8VAon4qzjQByO2pTBQpaDMObBNXZv8A2WQh1aJJFAA6Xyg3cjDOd5CA0Tg6lyrA90BqL3fAFYPuD42rpkVAgEOlOVE8UigNYRm9xGDhYOOKRR0WWXf5qCtfIzymgZaj1JE/2KjcCbZ/VM/mVQYsK0OKC4Ac6mUtJvjEuV4Hmyv6Y7QnZ+cWQoylyMLpprw8HqtjNN963fXLUuUMpYBtS/BLt7Hvl1Gnbk8Mcm5ueZrbD+6oNCDWEiPQzfNRURaW/Y4/84YXCutIS/BitfQ78rsmhUh6+fO1r7F5wQLRiv9C7ILpbpeYiOsTltjlx5DRjYWUu4qVs1EUIUUyQeNdMZiT0hZF4/SxoIMt4oQ826IX5IJjcyYmQtmrJ8LcijIuTyHCVrTY90egCFF6h3+WpKl6Taqwg8wI51DIXKgjy2B99VBtse+Hd/+8aLDmexi2nJ02EHjaGdj8o21F37f8jVze7k0hLipeAh9gC3fONO71j1nrEo5a/uQ53hT7taXPzpIoWWT+/4iRrjVPPRyDesQ
 9CoY29bA
 kzgip8VP+QhjyQt5U8CAmWxjJob++f7BQEpMjhwoI+zOPK5nSFv93enChGyoTFCtIq1eno7hQ9wUxJ0veRH5O71w95Ao0kyduvyqs4vkM/SLQXliWKkiFrzJkjH2X/sdrco6qK6tSwfhs6pStT/KZ3e4EiUhSxWo89aRJYzZW1iGDf1bMyS1zRcnMYOrVkU19Hal5NIeqDjvt5x6ZTlJ/EeUi9rWl9ySavclz65ZJWsItx/0AzA9o+NqrhJIGrr5paUY9CFAeNw4IuaiJBfAdxionOdEvah86gCXFJTQ3R8FLq9QwukRqUlUqzUjPAjEWpdbuEq7jr89O+pMeOgqGzkojkSsaAsN0GMYGX6y4Id82WVklzdG8TgQSdO2wsGlRt53u7U3GkYxFcOpzfajVqydlXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:37PM -0400, Liam R. Howlett wrote:
> Move the trace point later in the function so that it is not skipped in
> the event of a failed fork.
> 
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

