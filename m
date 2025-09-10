Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C401FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225558E0011; Wed, 10 Sep 2025 09:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9918E0003; Wed, 10 Sep 2025 09:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075098E0011; Wed, 10 Sep 2025 09:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC1628E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:10:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AED4011B03E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:10:24 +0000 (UTC)
X-FDA: 83873374368.24.988B8C1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8C4B640016
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:10:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="MSd/rdoj";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cWe8bxX7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="MSd/rdoj";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cWe8bxX7;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757509822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hwjqp0O6NkHQyzQDGVKaUnlGbWM+Yny9R70phZ0CHc=;
	b=Tn3RY+rPhf0sq3Y+c2GnPPeZBQdJusFT0LyIyyBdCrqEvc0ABxvXNqYYRY+acfdyHjrf7b
	vLIy3BtXiHd7YYp2KfeWKPixfRbCmRRrx+kQg7NTYnG/YGDw9qS4GP7qzG4DqzGL8AABPg
	rB5zWm2kpo6dLn2EryqlyYV3K4qXxUs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="MSd/rdoj";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cWe8bxX7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="MSd/rdoj";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cWe8bxX7;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757509822; a=rsa-sha256;
	cv=none;
	b=J3DM6vpFv5dm4HY0r++ZQrx+kLm1C+wxiJCQIaWsQm/6BMvJdzICuSp/3rVyUfTma9Y3mM
	/yqUPGtrLWYel3FxWT4ED9Pbt4cs9vWcajELBSDe8T2iZuiQEcnskIyfxsQl5rwzKhXzFO
	dHTzlYA94JqhoXVw4HA36ZbZcSdbraQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AF33220153;
	Wed, 10 Sep 2025 13:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757509820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4hwjqp0O6NkHQyzQDGVKaUnlGbWM+Yny9R70phZ0CHc=;
	b=MSd/rdojyUhqonn2szGh795WAtRe4vVpNUcM1fnZMfgvyPVY79146G1QvRfqPdYswafanr
	ocLkbzeHhmo8/AggLo+tS2LfOZ0bIzBxZFu+eUsft9IlYgGi0vvm2yNtKfCfsoKHzea8X+
	PQ4m2UUceKh/1roujql6Es+gOw6ZFm0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757509820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4hwjqp0O6NkHQyzQDGVKaUnlGbWM+Yny9R70phZ0CHc=;
	b=cWe8bxX7zPngm88WR4JbCxlYYPa8d9d6Y1GpDJdc0ajvH5TCe2wSp5jqOUrdX26xvqLYk0
	3kdxxMGi/rEEo6DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757509820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4hwjqp0O6NkHQyzQDGVKaUnlGbWM+Yny9R70phZ0CHc=;
	b=MSd/rdojyUhqonn2szGh795WAtRe4vVpNUcM1fnZMfgvyPVY79146G1QvRfqPdYswafanr
	ocLkbzeHhmo8/AggLo+tS2LfOZ0bIzBxZFu+eUsft9IlYgGi0vvm2yNtKfCfsoKHzea8X+
	PQ4m2UUceKh/1roujql6Es+gOw6ZFm0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757509820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4hwjqp0O6NkHQyzQDGVKaUnlGbWM+Yny9R70phZ0CHc=;
	b=cWe8bxX7zPngm88WR4JbCxlYYPa8d9d6Y1GpDJdc0ajvH5TCe2wSp5jqOUrdX26xvqLYk0
	3kdxxMGi/rEEo6DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8041013301;
	Wed, 10 Sep 2025 13:10:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pqsMHLt4wWjWCQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 10 Sep 2025 13:10:19 +0000
Date: Wed, 10 Sep 2025 14:10:17 +0100
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
Subject: Re: [PATCH v1 7/9] mm: Introduce unmap_desc struct to reduce
 function arguments
Message-ID: <ss4haln3wwk4gv62hhhdmx7tyog4dyd6auogvupm26idludj4k@abasio3iebze>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-8-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-8-Liam.Howlett@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8C4B640016
X-Stat-Signature: 5ybnuzt96m579r7zhxmon9149398j9j8
X-HE-Tag: 1757509822-890610
X-HE-Meta: U2FsdGVkX1+oBA7KxAwemdfgS5oNWJcORinD6YAE8+H0p7MNSCqwnhBGIMemQUxbD0b6wUhQ1hr1Ltc/ZERHk8QXeSGTSwgo2VyU6joW0uny75Wsqx0kpfcX4VdqPxpOqThk0sIKUDXVY7krZKeUbgw8vLSPsSvpl4MAoRgK/aw0ot/wwG1FYdxlrFr+UNyMApYqY/KoGc0Arpv9L2mEYmPde0ShFJ+9rjh6vvqAG8582c38TOry5rMXr/cmaNc+rSWbEj6ax2gfe8uYdRaqSMRCkrXfYR6tnaE+7TnJshzWzt2iy07oRy++5UBl4NaykrkoZNu1aUAJ2kT+Tg7s99gMtUTRP8qfy4aQb3wbQinqZQrrLc5xKN708wyCEAiKQMQl/EEwTIpEjBYbxDv6IrNOdR54CGEhbTH76PYk70s5mcUSos/qnmDwJ1zaAWHS3mmBEvutrnKwmW7TgSVle8TCUI6xnIqpeWCWT1ozSUY6sf/v5XxQEJOgj4Ja686PmP7sHUbgEVCKL3iE0ItziNOb9rdKUDrXzJzrYVjtFA0w78tWxTqR63lJzVN6qvmvPcmEdYJ8vLliVrwsTT5oVlo4GejdBxbLAWD+W2tIpinSVm6z6VhFFb5MVlXWeu1WmSSuA0xCroJ81RD0JKbcXuKrxV6t3Ibw0epkZ6/2AcFFkhhwkPgvQVvg2/OXnRLP0jgqPFwwaLs7fAlwmzgtNj878NZiCcKXRVM/gC1cwWkv/NcHNWrYl9rzg82AJO5mK4eKnvR2HPQmrlJuMk/GpuvsBH+1BUZknHfj9yK++ue0OGDB6qiKBiP2AiXhwSktdeQnGRFrQXDyYP/XO/FTaefcaCntDmD3DGZs3N5wZaAPKxLG49EaOZtilZ9qTuS1n6XWyYH90mboHq1Bw42UcDu01oiZf/gHmKUU4Joh4RCY4f5lBngEYz3cRAF5q9cJi+pEDm6cVBnybDaVrib
 jV8kV+vC
 EZX7kbnMbAeV0OvsWdxYTe2PkGE3YWlKoRXEu+WMAsaNRFak6fteFLKoobFPEt2ASlKL08wATF0tolrfz95tOSfR047VXDVnRWigvQLLFuUbtp6oLB4hLTxU8brbYsk3XQ/ZW5z6FGrRJjStJjZdLCD6xSNzmNBiQuzGVW1bCzlgFDWE/kZrmMgZvv1f5CRW0DUA1u5e1HSTVxlvHNBMGsLKCQhJpFZyg6H617IN3RMueMk4WKEqvEBUhXsYdoHLrtIso2yrgs86ybiokSlRK0b3CKbEYnqFgTm1pQQ3rQFAWXdVIRmKyHDiGuEqCDFXO6+1ThWn42/GlgZgZw0y1zYeEvt9A9o5CP2APisBIfC6CrXbTyaWhCSB1Dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:43PM -0400, Liam R. Howlett wrote:
> The unmap_region code uses a number of arguments that could use better
> documentation.  With the addition of a descriptor for unmap (called
> unmap_desc), the arguments can be more self-documenting and increase the
> descriptions within the declaration.
> 
> No functional change intended
> 
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Neat, new helper struct just dropped!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

