Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF28CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8B0900155; Thu, 14 Aug 2025 08:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C096900023; Thu, 14 Aug 2025 08:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D725900155; Thu, 14 Aug 2025 08:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D394900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:40:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2086F1DDA4A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:40:10 +0000 (UTC)
X-FDA: 83775320580.01.11E9570
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id C9B3C40003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:40:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IO2+X+fO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=verwky+j;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IO2+X+fO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=verwky+j;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755175208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wJyZnSiEeD2NkKQdbPdW3SaUij8cotXfvT/YrHlHLo=;
	b=rj/Z7XE8Xr6fZmco8Qh4i9VAMUuMeWNFx2RBTUEKnIIs4lTKXvV9qiBrqXVnqr3LcSa1Sw
	pwQ90c2Js8xOBBGwt86DPOxCjYajzc93OAijGGhez5XpPHeqvfO2WCCFBWNKBpmLWm3bUu
	Kjz4iTstauMbMH7l3v/vNjJKkyANK1s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IO2+X+fO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=verwky+j;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IO2+X+fO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=verwky+j;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755175208; a=rsa-sha256;
	cv=none;
	b=6ex2ghFjMMU5wR6z2QzHN8wRVmDCIhdoQ/1okoiiekjnsKw+T4dJ6hyrAifvsBkQzveJuZ
	z83bQ3tYSHHnukq88yBHilYt4XtrQ5VtcugFtIJLziXO1f8yeWYH1T+qs96PMjEwmHS0Mg
	p3/ZHVECxeNcwmEAhwGTWp9n4h4o1Uk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00BD821A33;
	Thu, 14 Aug 2025 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755175206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8wJyZnSiEeD2NkKQdbPdW3SaUij8cotXfvT/YrHlHLo=;
	b=IO2+X+fOpwHjsiR8WpWeIpfuO2AhSBB2229uKhqrR7ya+Ml+LdKM6tr6WH8eSL1yIE6BeX
	eDZkPk0nHd0wj3kSrdNvxCdKdjsllavt5VJT6E6WIhQU+J+iX5/ESgkzHqhn/gb1t6+1ej
	OyH/bx+/RwHEchhRrXIZbOkWaiMxsfM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755175206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8wJyZnSiEeD2NkKQdbPdW3SaUij8cotXfvT/YrHlHLo=;
	b=verwky+jL1qngsaV9F+rTlETM3ggKh3lxHqZNArRbaGbgUkvprGYy1mM8ENxiwz0X5zoj/
	M+WKkE58MDDe5YBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755175206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8wJyZnSiEeD2NkKQdbPdW3SaUij8cotXfvT/YrHlHLo=;
	b=IO2+X+fOpwHjsiR8WpWeIpfuO2AhSBB2229uKhqrR7ya+Ml+LdKM6tr6WH8eSL1yIE6BeX
	eDZkPk0nHd0wj3kSrdNvxCdKdjsllavt5VJT6E6WIhQU+J+iX5/ESgkzHqhn/gb1t6+1ej
	OyH/bx+/RwHEchhRrXIZbOkWaiMxsfM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755175206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8wJyZnSiEeD2NkKQdbPdW3SaUij8cotXfvT/YrHlHLo=;
	b=verwky+jL1qngsaV9F+rTlETM3ggKh3lxHqZNArRbaGbgUkvprGYy1mM8ENxiwz0X5zoj/
	M+WKkE58MDDe5YBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 478C11368C;
	Thu, 14 Aug 2025 12:40:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XslHDiXZnWgbWgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 14 Aug 2025 12:40:05 +0000
Date: Thu, 14 Aug 2025 13:40:03 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] testing/radix-tree/maple: hack around kfree_rcu not
 existing
Message-ID: <kq3y4okddkjpl3yk3ginadnynysukiuxx3wlxk63yhudeuidcc@pu5gysfsrgrb>
References: <20250814064927.27345-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814064927.27345-1-lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Stat-Signature: 49bug6iwz4zm94hgbxsmg5rscihfuo38
X-Rspam-User: 
X-Rspamd-Queue-Id: C9B3C40003
X-Rspamd-Server: rspam05
X-HE-Tag: 1755175207-205231
X-HE-Meta: U2FsdGVkX1+gDERAkU5VQ6FjR4IQFU2sLwHkmGnChaCRmRUVEA01H1SzQm/pHgd+3AF1oQtjOG2Fhx76nCt9t31hQVbJKqQVX4OGjj5pgZJ305un2OEosPiSQMgAQTTHeMrBymAaVssMe/9p9sxxrRTVHfZvgxKawb3U1QLp6yM5L9jGkLIRcZctQjIGGF8fglYmIOvLyZOyAEmU2uPL8z+6r0DwHXTLSMiF3LIeFLdWOZn2IsKZdy3uYzOG6Qa1G7QUJ9f6fHS7DAR0gzVVfwTpUTJUbDyPouHOU+LH9i5OZ0SbYCrBh0GXBBZsg7qON9KeZk5XykRoPRriFw0fJMOJv0FyvVTPvr8o23BbZ5agKhaLcaFVOTEGN17cT4yjW72bRiiodjHE6y47McJ4UqOv7JAnP6yhFsQJcyoEUkpYWUeaNc9bsuKcB3xEsyJMK2yOBGV1/bGhnDBNF1TiqDkziV2H4LPagSEP7tpQImqcEJgXOEQMKZEYwIwJPqS9QiGZPNdrj70kXhjjNp0zi5Brl3JoA7odfAlLK0gPAuXxqBFApGztC0BAVh0G0lpyTenSDGV9qmVxpE9NvhXAbzWKeceuPSlN+2Azam6UI9X8W5y8R3mF5I+nQk1tIsE9yzjvvxNoaLMWF8kPLV5R4pnbYIpSLhIfnWhm6hd8aNR5BL6HXfI1rBRXr2Dajc3qRYQ0+dnFm0t/N4pZ4S29sonzCAfSATpK7NyDiXTs7orCJuNwVGY5bfX9cfQLTchh6rcMv1WCkCnW1Nl/AFi16QHQwYzcT+jlLQBWL2m+EUBeVhuSeKv0sbPWVHUQ1dsq9jT3ARc7ul56CA0SYZYn9KpG3LNTcLK/uwB5NeckV9x+bqJLlGxfanloEvTW1EH4Xfz9mfh+/k+2ql0ixyM1O5X5M1jC6FXri51+Xl15M1oYZHeTyn3RCDswjjEP9+1XUmyvHDENzf0YWizmu1w
 hFc1k68D
 l6vYpjQJjVYHuiT6BvB4LY+JbkBBNioNQYPjAhF/wueIJK1GxCkSfor3fCDAZaw15WqXVsiacosa6HuglMwTZ9Mj8ryoy0zHafom5Y7iJC6AN4wZNixCG4t1e+Kf4bho/02APMqK9osuvAtDJyza7SQoPIObc03rCf8r3sR7r3fU0IucxhStj7VraWMHOXxhFRjcvfJDvsz5VifcUjiILxKb9fsDG4p9BrtQdGoE5btGSuzcIWc8COV1s3vxFoL9jlsnwGVVxJ5bI88ZlS+kRXPccywvOAzFCWD+oFob5GvSZmW7kbxGOZLBwPH8azAyDoL6b0/JWoaTJejhzjS4z5XLruokGvAeJzQmHBIjGwuCxHdeAbwmVaJpJoS71KWzpaaw24o8DLOXhW21bx6uGZCvpkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 07:49:27AM +0100, Lorenzo Stoakes wrote:
> From: Pedro Falcato <pfalcato@suse.de>
> 
> liburcu doesn't have kfree_rcu (or anything similar). Despite that, we can
> hack around it in a trivial fashion, by adding a wrapper.
> 
> This wrapper only works for maple_nodes, and not anything else (due to us
> not being able to know rcu_head offsets in any way), and thus we take
> advantage of the type checking to avoid future silent breakage.
> 
> This fixes the build for the VMA userland tests.
> 
> Additionally remove the existing implementation in maple.c, and have
> maple.c include the maple-shared.c header.
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
> 
> Andrew - please attribute this as Pedro's patch (Pedro - please mail to
> confirm), as this is simply an updated version of [0], pulled out to fix the
> VMA tests which remain broken.
>

ACK, this is fine. The future of the series is still unclear, so if this fixes
the build then all good from my end :)

-- 
Pedro

