Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DE5E9A761
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8966B0005; Tue, 24 Mar 2026 06:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D146B0088; Tue, 24 Mar 2026 06:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39EF46B0089; Tue, 24 Mar 2026 06:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27B226B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:45:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BFAF1615A6
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:45:06 +0000 (UTC)
X-FDA: 84580624212.20.BD53D72
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3823FA0015
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:45:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774349104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=euahcLO/pPcU70dkMlwtdsC62SB+p1I63bIJcGs6b+U=;
	b=4J5nzryfZKw4vSTMJesrNc+RwwHDLWiOL9wgLbWRoW2vN+HtfK3ASrStI0zLVM2H8HDC5W
	4XpJJaF+TXWR41e2lAK7S7Z1bQv+drH92vW19/I7rwEoDEqMBlBm5n0johNhPgq2m5zWuZ
	wkiSkY7fxATYrIGuGuFN0gHXpFxBW8k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774349104; a=rsa-sha256;
	cv=none;
	b=Yx6gJSUXUA5IPCZbE6hMqIhiX/NZknEzDo7hh60Bu0nkwEfZvMbKSzzTJZrK4TLPjDRWch
	iHenWcZ+MJ28KolXbKUn0zGze1+/piZXcoe7/cc/hwv2/mm1KRHkBoL0wVTsFcFqnaxwAF
	gkTp9Io1/4qkjh2UN8mY//rVUGkZlic=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 72A614D1D9;
	Tue, 24 Mar 2026 10:45:02 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D08AA43DCA;
	Tue, 24 Mar 2026 10:45:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +z2OLy1rwmlTeQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 24 Mar 2026 10:45:01 +0000
Date: Tue, 24 Mar 2026 10:45:00 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mmap: add missing space after comma in vma_expand_up
 macro
Message-ID: <q54jdapewgwz6se6x4vwitkyrixfit4ultf4kogsc6tnwihzbl@l253p36tn4vp>
References: <20260324102909.26847-3-giorgitchankvetadze1997@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324102909.26847-3-giorgitchankvetadze1997@gmail.com>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 3823FA0015
X-Stat-Signature: 3gjbnpx8g3c8gezyxbfgm457p4bqngex
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774349103-854149
X-HE-Meta: U2FsdGVkX1/n7z/YbtbccaKzSUr6DQIAyow3oGnIJ5rFZQ1zDkSSN/2M0ftFzKRSashj3r+XL1KxtHbV026LWfCrnWIWCf/c+PxdsHGPEPSEIPpnE8YUiOwvq/4J2mjW2u6XolAJFsUzYKwLV3fgdLSV1cwZOlSVpSSYaZiYcVMBeBLR48YYhWxOMkbkorTMpQ7tuTN2rPvXPmALWBpWmmhLU40k80F1zzbUT291HyNe2jLYoj8CZDY5IBKmQTW4qQe/Tidcdj0W06zkEVLYgSnMvRQ3GZ7ZuTHTXg5DbWNKeuilhcp74br603e2lMR4rttgZ/y+7Ie/Gx3JcNHrymG2b6FaIUkYm73vOfUNY6tTCLIjmIQRhrRXxpMvBAFwN+RxDke2LbSxNVry6yml5TyXaL0hJR1TCXDyX/Ig0uekQlwQ04ccg5XxCmFTILyGhzqT8D9hltbH+e8aUYoPLxRlLSJoVKFdak21WyXX4WeQAqa7ivIG789AL/eBzWkKZ8lgqVDJH+duJaf8VGD2OjdSQoexQ73l/i87uica5izIiJhvvf8Onr9ACM780sXcz01itts8pWO5eGeh4vukD78TMPT0GeEaxQFMpkAcTsmMWdAb8svO3juS5xerAkwnFZfijEVeXWR9FMy8UzhBvxmoJZrCVsNPa8g45blskqoyNGQT211DTDSKmgORaAOjGixy1rQKvS061HvVTdUPFeay70VMMGCBVfozo3KDiVBCUGtTJFE36tRJZG4K7NbIHdB4lFjeOZfJbE4AdgrLzw85bt6NdWOFJLKPAH8UgRpuhSTUU8co4KWnUEr06uX10gm8Q6+pCvN9JkUMO4eY1yZ/w3GTxYe1ozvtcroYs1g7vqVsnxcQ7/7JhhQMpY78KCu+b7GZUghVOVPu+3byVG7Hv5ByNpuZWk/5mDDJ+hJkrZZkCQTQ547iIUsLPszWNAKVn6eilHBGPAV2rT3
 U6H69Fvy
 sUneuI7hnWYpvpTgRF+kSKzkPhDTerGXb5qUeEvHmYL0EyMFGy4rnTCQmN0/FJK2vr8VS+DJ3w4MWcYs/H6yJv8DW0NLMf3SW46dGSGmqpst3wXiX+VzXKQkel2S61mr4+ljr9qBb1BHDY1/7kid1s3Uq42lDTe3Rohy3ve+9nmAIUrNI+yJNcVFDP0WOBBl9ZDB+IFVWJ44K13dNzc2tHyA8R/v5LHrWmvHIlV4AZtLWfnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 02:29:11PM +0400, Giorgi Tchankvetadze wrote:
> Fix minor style inconsistency in macro parameter list to match
> kernel coding style.
> 
> No functional change.
> 
> Signed-off-by: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

I understand this is your first patch, so I will be lenient here. But note
that generally style touchups are only done if you're already touching
something in the area :)

-- 
Pedro

