Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94806CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085E66B00AF; Mon, 11 May 2026 08:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D986B00C9; Mon, 11 May 2026 08:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5696B00CB; Mon, 11 May 2026 08:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8F336B00AF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:14:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 835841C05F8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:14:42 +0000 (UTC)
X-FDA: 84755032404.29.4A35228
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5DFD3100003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:14:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JK6iUU0q;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MMegOG1C;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=S5RbwMsW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pfImO4AD;
	spf=pass (imf05.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778501680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8IczejHyQKAFVK8A9X7vhcds+BgOyppvdPBbfzrGGY=;
	b=JZtY/ShIkCWoEXxMiWs/u/wDwBZZxEEf/slQCIRSy5Cqu7XOkM70Nnifp8TQ08X+dPtVxO
	gdhKIhHzNZsyd+Fw3BJgTp8FFwpkzs6lwK8IOOfIUyP2fMKd/OhHLGBpIKraENmhNL2e9I
	/Twcfd70iLP8uHlyUaR1lJGwn298auM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778501680; a=rsa-sha256;
	cv=none;
	b=P5csUM7qHorLrkqmHeKVqgHFpoWdttXXYs09X5TFKeQIwFmbL/gTHZf3TcSD0N3KyDntOB
	g5nsWgvtzcYFom6skKYFHexcvb6uWjnnjU58YkvkNG8yTkk2yrJ2iGN7KPgo716VNCpZwU
	JDE/m3BRdkbsGlxnp3sX7GKuylx3dms=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JK6iUU0q;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MMegOG1C;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=S5RbwMsW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pfImO4AD;
	spf=pass (imf05.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CEE4E5CCDF;
	Mon, 11 May 2026 12:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778501678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x8IczejHyQKAFVK8A9X7vhcds+BgOyppvdPBbfzrGGY=;
	b=JK6iUU0q0sMdEqJt04pZHXwse66yK7PJOPbgUOy8E67voS3luLWD6PrxBG6lnlAm4t+W6g
	UhibCarKVYbRhYtQyJO613JN+fejq3RtoOfroeNrmXN70tJ8j1IzX49EeBwg+Yx2T6Zy4O
	Jf7Khg5BVoLiPolqmSXl2KWKurNngNE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778501678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x8IczejHyQKAFVK8A9X7vhcds+BgOyppvdPBbfzrGGY=;
	b=MMegOG1CXsA9nfXDrhRmL9bY/Bvl7Tr1axzxeEUuLR8hp9syPkxcTDwrFoBXiVLdGXYBIp
	qzdWQ9lWy8sPhdCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778501674; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x8IczejHyQKAFVK8A9X7vhcds+BgOyppvdPBbfzrGGY=;
	b=S5RbwMsWScSOdtxjxNiBO/7HRnqI7O+pX/OEYmZqjNcK8WRxmle7zycXWlSBSh66JvsFj5
	aHm2Jd6pm7lpVz2fSiNxeooEbWaxEbZiT4bCOo59+QU5tkVQLGqKDrubL8qntEKRLwHb+z
	OpdICmm5Gd45lbQUU0SCPt96ZZ4raT0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778501674;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x8IczejHyQKAFVK8A9X7vhcds+BgOyppvdPBbfzrGGY=;
	b=pfImO4ADJMGt0V0+pOCb1eYPBVG7wc3nr5az6clLRhLUsgeGczZC9t48G94gk1yzfVFYv2
	fQz+tXUe7vpzaSDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C0E70593A3;
	Mon, 11 May 2026 12:14:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j2n4LCnIAWoWWQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 11 May 2026 12:14:33 +0000
Date: Mon, 11 May 2026 14:14:32 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, linux-mm@kvack.org,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH] drivers/base/memory: make memory block get/put explicit
Message-ID: <agHIKJtoZgKl9k3c@localhost.localdomain>
References: <20260511111800.2181785-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511111800.2181785-1-songmuchun@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5DFD3100003
X-Stat-Signature: cchrhbiofwbchmetrugrf5it9hnb9hgx
X-Rspam-User: 
X-HE-Tag: 1778501680-865337
X-HE-Meta: U2FsdGVkX19iBQw0lsTeXoG8UvuF5wLBR6+98jZAVKkEbXQzE7gvtmohE8xk9Wz1hGXGLcHb63FrNw1BDy036ThNaOXsew4FgPNgHoMT8HtTB92kcOBocxfXqrgyIZdbE4xdnrmu5X/t5D/T7WOxbtLbaoGs0390JJ0/Fu/9DG9oCnDynFDekrS4jP1uzNZ6I6lmhllWZ1jVonsz+IyKm/aNUId6piyEAcTk3J3VhTt5+mh/N6zLlRbmtuL/bAHz4i+FvNYanYu3FnVIZO3iS9SSQtEJ/Q7I/tYm3CHmcfCq9BEaGQ4g19/9tXTRgiMnXzsVestisCZSa8TxaBzj/bQXgFQKyE+JFGVqub5m+/I0TgYpdtfAICdD0wvoJ1bTrGcyoHc5Fw59rDYX9ObjytkVdUmNmXuQSteSdIQPKC1hQ4nrC8TKTYSUxz5+VNFMmm31fDT6PNAayz71O2DEUHCWxdq+r3fFWQL+AoPpqHOrZOZ/33Wo0liZ26Lgh8cm0ueciKCDEJ5KAmhCgwCmKySA4kJVE5S/+UX+6yRAbnL99lmGbqo0VggxH27g9CkNxSYNYJ0J29wFk4UiFJK8A0JaUBiGW9KmrB0Eqlqr7whFNhTseEYsursQKoEKkj+gAs6h+aLPUNYBP5RzFK7PrLSLU0EZah5aQsK5NYCyo/y/9QVz1tM9TnokYkYl138ER7XwP1n4k3H21jlq0sgf8UivhLpS6CcGK7K4kFVGV4KW3y1Vi6hjK4f0QQf2dHQ7/BwM9VXzrs6pgxzf2FkihjCDLpoB3+ePlQbiMFITvcG0CpufIFnkrNd2jCipybOZEfsr7aIeXxqvCMUU+sDTaP7GyOSBvsXiheYyql3fF+5RWL6BR/9WvwCbmMwcd+pxnD9GglZ+LvNpE7Z5g6m3x1X9jY7bkrpR2VDYM9GPm0QMXfm9WJkwZFdOEiiIPB+32EA9TMfVPMJPI3ErMmn
 s399sS/F
 1ApafQIEEWh4ZuHSoSVdRSBu2Hhfd4bFBHbAhpc6iR6p9F2pkOarmTL0HCzDT/mAHO+QsxjQ8W7kJzC7kj7M/Ovpiljkw9+30ScY5DVlLyrW06r7gElTx+Yd8nXquEX4MmDqUBhhkvFaaaFlgPAZCieCXujmjMdvV5Nr8yOuyOP2Ipl3fGESivTnWdpa3zKJRe8+8XrkosgVYvKQxcgF3Sr9YT4L2qWPBEElbUj3LF59l3IAQHNVRVlUwePzXiSpjSajHq6rPFvxlnZVGAKTnpxgNlotGMKqvQ01F3yot8Nhg4NJexJYJ8Epkrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 07:18:00PM +0800, Muchun Song wrote:
> Rename the memory block lookup helper to make the acquired reference
> explicit, add memory_block_put() to wrap put_device(), and collapse the
> redundant section-number wrapper into a single block-id based lookup
> interface.
> 
> This makes it clearer to callers that a successful lookup holds a
> reference that must be dropped, reducing the chance of forgetting the
> matching put and leaking the memory block device reference.
> 
> Link: https://lore.kernel.org/linux-mm/7887915D-E598-42B3-9AFE-BFFBACE8DE2D@linux.dev/#t
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

Thanks, it looks more solid to me!
 

-- 
Oscar Salvador
SUSE Labs

