Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A533CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA956B0005; Wed,  8 Jul 2026 10:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992E96B0088; Wed,  8 Jul 2026 10:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883656B0095; Wed,  8 Jul 2026 10:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 614856B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:40:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF259A0191
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:40:16 +0000 (UTC)
X-FDA: 84965869632.23.C53F35C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id C1DEC1A000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:40:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x6mCiXdN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8N9SpLHj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x6mCiXdN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8N9SpLHj;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783521614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IT6R9JdS1qWXaSJz8T2OAGJP2kCrD5Fj7NESw4gwF7U=;
	b=0hqRIu+3akwVOTGxPUcnDusGjR7qUomfiCOVeSsVSdkVh9hAAm802ZPpAIIJwlDOYmrQYI
	Udr2QhDHDbYlEU1IFZS7qG2HbvDKzxeD9WANWRHfc4m6O14rP4rCCo8I/11fg9OgaAq7q5
	xCxxWIdmuiM3JsVBF9ARfOSd1RIL1S0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x6mCiXdN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8N9SpLHj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x6mCiXdN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8N9SpLHj;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783521614;
	b=XvtiZoDp3TN8x6HUJODSRej0SSivUzSZNc5o5Py0pPZ4dqjxLIYBe7MPDmz7iZ/IIAnGd/
	vSp+8tjgpfnMLR5OiPDYm8aGOq2Vn9a0/f4bW52OUiiRanKsF0ftOvOpqubs03FF7o/zF0
	e7UI7BSpxgTB4YW2wocMHR3sGWbQLmk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0A2157590D;
	Wed,  8 Jul 2026 14:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783521612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IT6R9JdS1qWXaSJz8T2OAGJP2kCrD5Fj7NESw4gwF7U=;
	b=x6mCiXdNKicWFg2CWsB0PFahRQukGvEJqVl0pHyQO8vxsIq4rWrrJ0uTtGc3978stNW/tD
	QBGGLFNiFo+QM2KbLpRE2FjKeyWqKBIiXRa1qlnbqSDjGv7/YoP9m0ooYH8RZEu4nSIndW
	x6fDIgJoc+sEt7PKUCOrW1uQaZLASew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783521612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IT6R9JdS1qWXaSJz8T2OAGJP2kCrD5Fj7NESw4gwF7U=;
	b=8N9SpLHjhnDgpzT3KIggZCKa66Eeff4e1lNIH0LMvT/rVyhaaL6FBbW68MUOHw6ju+8Su6
	JMfdF9zbYgVyJeDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783521612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IT6R9JdS1qWXaSJz8T2OAGJP2kCrD5Fj7NESw4gwF7U=;
	b=x6mCiXdNKicWFg2CWsB0PFahRQukGvEJqVl0pHyQO8vxsIq4rWrrJ0uTtGc3978stNW/tD
	QBGGLFNiFo+QM2KbLpRE2FjKeyWqKBIiXRa1qlnbqSDjGv7/YoP9m0ooYH8RZEu4nSIndW
	x6fDIgJoc+sEt7PKUCOrW1uQaZLASew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783521612;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IT6R9JdS1qWXaSJz8T2OAGJP2kCrD5Fj7NESw4gwF7U=;
	b=8N9SpLHjhnDgpzT3KIggZCKa66Eeff4e1lNIH0LMvT/rVyhaaL6FBbW68MUOHw6ju+8Su6
	JMfdF9zbYgVyJeDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A099D779AE;
	Wed,  8 Jul 2026 14:40:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9OPdI0phTmqNDAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 08 Jul 2026 14:40:10 +0000
Date: Wed, 8 Jul 2026 15:40:08 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Gregg Leventhal <gleventhal@janestreet.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Song Liu <song@kernel.org>, 
	Eric Hagberg <ehagberg@janestreet.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
Message-ID: <ak5g9h3FuVn3bZ1G@pedro-suse>
References: <20260702165409.164568-1-pfalcato@suse.de>
 <akhYu66GmjyM8l6a@casper.infradead.org>
 <CAFN_u7HkJry=iFLbZ2vjzv5C=HnrptHfFJBLOqRq2m4LyhqV_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFN_u7HkJry=iFLbZ2vjzv5C=HnrptHfFJBLOqRq2m4LyhqV_w@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C1DEC1A000B
X-Stat-Signature: iuefccsuzunfeuy8uag6ymknhf1z38rf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783521613-49044
X-HE-Meta: U2FsdGVkX18/alPFi2Q0bFIk+IZoyLcfBekPRepSCdpYpl/r8b/wBRG5hcyDtQMBWbtXdzG2L7zolKvaHWBpKf1ImXteMqgOTGFV5lgaZbK1WErusePlQQkFVFMJ177orDnPSU04IggS4IGXQuoMX0KmBqxO85uMnrD26s+2uHKcze99qVmDt8U8//naBgCxshgLnFD20bMCvk/TS9lOBs8gQhmfSM64M2L1UC4XG6CK2yK5LQerOEGwZE3bYm7vMvbWEW+Hj+PfcNHRZzPZYp5k1lpLJb3xwAbLq9r+BG7BVPPxIEjRKMSc6VARbltfOI6zYXHp2nq0poALsypmQ1UMhQA/yOmAk6NLlR0/VgYNZnvRunf6C+/Zj+CWjzmLbT9k0cML8Ge0v6DFgesdjuPmqkIn9j8nGDhonlgkM1Zgy7TdE+76DpW6cHnsvoWCexo2lj+5PtdSJZSuZK8e9pfKPv6Y+ufsLDRKnIbQOgY7cmp5LOFQkK7G8bGcuvLhkAuq8h7uWJ2V7tWOOlbNTDKJsq/+xHI1Tsi70/iPEcqAkgjcHZL1hxbs6ppKaW5vicm8FltE+xMOcAM6jn/QwQG3XGh/HkmczOXGwvqNbGq2vdKSVMal9DArEhzbtxVF+/jxaUCMWcJlPc1fTh1u+sW6ZXinwHh8HCngga1O8ml+esZl4PGUrNhridGF2lMyWXHiwgKjYXMSIarwCXwlWTKSH6vpKWbu4EbQlZy8JU0JscrZYT9M4gvHUlEF+hxYqhRgWiOuJbrSyqBlVrMBtnY7jpdOaRFAuQApNZLDXhdDiAxmI7xygcAxUKB0PoKWopEfKjx1iIw8OIixq8Ha8LgKhuZmIfjx/jwFy0RfU18xhnCR/+ibHw/CgMfL1256L6U7TiWZFfgZiMHTkLr9jQHNYg+D5oC4qxtLEQ/A4d0512QQ7W5sHpHA5NRoiZwtY4NLvuZ+0mfmkyMeAUh
 qbAI5OxJ
 laD0T+5/4wzb7psfVd1T+ihqXCVuccQW6SGw2YSNOSGEGRlGOlDd3EFseY1eAVjSyOMHKxqmVjrC+TblQKOjI2EjCFKXNXFJIrNzYwTDuLwllEa+/o04gEqmPolHZ9wus1VFo0SY9e0cJ+IO8BBc2Gq0+c55WRzXi8v7I2rIAs4cpt0NUnWU9AazQhHOfwH2MWMCgr9lUg5mvclxhAqEykgqCGRLU90qbgUsVn0drv/3AvMIF9pxKXrsBXoNU4cnI/tVA4klNnKbpsVrTWytL+7JO61SkSSpTR7VPYTPoSkwK9mdiGm76YEUd78vYtIevK3FcSZNX0t/2Ju8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 10:05:43AM -0400, Gregg Leventhal wrote:
> Hi there, just checking on the next steps here.
> 
> @Pedro Falcato Are you currently working on this patch (mentioned
> above, re: holding invalidate lock), or are we perhaps stalled on
> something?

I was waiting for some actual tags from people, but given the comments and
no tags, I'll respin a v2 before sending to Greg KH.

-- 
Pedro

