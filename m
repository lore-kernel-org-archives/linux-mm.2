Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E1CC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 13:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3550A6B0095; Fri,  8 Aug 2025 09:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32D006B0096; Fri,  8 Aug 2025 09:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B8D6B009A; Fri,  8 Aug 2025 09:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF1E6B0095
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:38:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9E5BB7CC1
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:38:12 +0000 (UTC)
X-FDA: 83753694024.05.AD44BA7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4EBFD100008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:38:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jLF+N0aw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CFsAjIL4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Wf9oqIf4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HmOZJJv8;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754660290; a=rsa-sha256;
	cv=none;
	b=3UyoYfboQpxz3q5SzApPLxBtUFfl1qbHMoGfYVjebVHFmVWWe1IEwg4CWZ6L3rNUAIRZE9
	abfaG213zxnogQ0QbQ4NpxJH0pcYRRCXnzDVIAxsL4cD/tzT8nF52hBE5HUD07svMKpspX
	L7DVNLMr/PMCpOrRyd7xUXd3t8j78m4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jLF+N0aw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CFsAjIL4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Wf9oqIf4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HmOZJJv8;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754660290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cf1tw1RRJzo2VbFxxZUkyEDgUrYDcKWwz8TA4er43A0=;
	b=c5OmgdvVscf7ZV7S36xBR+mtAuyuKHRxyLShfuC2U7ktZu7h6j8qI2f1TO86jy1RwmiwXP
	W36p6QLjaXp6b+64VKCGDgrE4YjRWtNBEv/OcdPuFwZBN2fBr1TsDsGotQu3DOPQG7JMmF
	o23chLfzB6qI9MzYbpcjJB3JH3Zs/1w=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 77BD55BDEE;
	Fri,  8 Aug 2025 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754660288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Cf1tw1RRJzo2VbFxxZUkyEDgUrYDcKWwz8TA4er43A0=;
	b=jLF+N0awpVsAV6SbqvZF2hrBhyyWoPSEb8cKKnjxIYZJk584zY5HG2mp3YeB8kE4mbWzY/
	cEBbHcWDPR+gNrNSvjx9nGANVDOmTZOdvaD7s9NMlGihOE6AMyThD2isID53gA/Rom2hkt
	HBtTZF1vt4IAojtVwGQTtpM1J4ZuyMQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754660288;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Cf1tw1RRJzo2VbFxxZUkyEDgUrYDcKWwz8TA4er43A0=;
	b=CFsAjIL43c2pVTHHzdlPa1ra72EBApokvtjBoAqwX4jQ4KpquAmf1ZwvBfQ3qbBFluoi9R
	0Y4kjGBPqJwtvzCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754660287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Cf1tw1RRJzo2VbFxxZUkyEDgUrYDcKWwz8TA4er43A0=;
	b=Wf9oqIf4rX0b4fPxCR/Y5Cu4kZh3o8CFQlRY9F+8kFJZZkPS4M8oMnEoWIKy73mZgcuhEk
	PGYieFJMl3lkrwIBiLDhi24AKA4gAgL1bAjPCxBas36yJZnIJwQA38J3UiBnRvW0YSx8Ir
	9zRJsLSpCFFnPXTfNtwQ+vhFizMOXEg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754660287;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Cf1tw1RRJzo2VbFxxZUkyEDgUrYDcKWwz8TA4er43A0=;
	b=HmOZJJv8MYRl5yvrO9mE/tL0w14AfPfT9HGHuKr9pR4kp4bgkfTgNvlUqLjhBFvh8Rbq4x
	WD5OJWSFdFzKS2Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 54C151392A;
	Fri,  8 Aug 2025 13:38:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e9BZFL/9lWgMJgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 08 Aug 2025 13:38:07 +0000
Message-ID: <c6240860-6e2e-41bf-8e9e-eebbd86ca9fc@suse.cz>
Date: Fri, 8 Aug 2025 15:38:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 1/3] mm/mremap: allow multi-VMA move when filesystem
 uses thp_get_unmapped_area
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
 <4f2542340c29c84d3d470b0c605e916b192f6c81.1754218667.git.lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <4f2542340c29c84d3d470b0c605e916b192f6c81.1754218667.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4EBFD100008
X-Stat-Signature: wr7ftu1s6sjpssa84zmfm5qan5fiqd66
X-HE-Tag: 1754660289-464570
X-HE-Meta: U2FsdGVkX1+JqPC/8XQdf5mvDNr2CfSmxHAEwZs2XrEXPqFIPMTe2rDZRvPu++DS/4l3cGjBOQhNG9dyoPd+Gqpb5nzjtET4S+QXfkZgfhe7lAO2/M4pM+dWmdWlndZjHzu9EFZvmY5Ej1F51OP0kQKyb9DVC1nHCnKM9MNv4IEZthxlJlAVLjLETQ7FIv0pTj/ECf4d9xH3r824rj2YshtKRh7QAFg9r38DSEi2wjrrq7mscyTXPi7qjcNucA9Ekbr1gRM84m220idzuZK4WK28ZVQvSM7Swefrfd4afe5Ro7/TuDAgVaB5Cm3cDC6l/4PkNK5NfFlgvUu+cAHxMtpHVQ1NM844n9HOOWXLhK8P1DPYWn68ObjXCUn1mZpm4hciATWTjREvlzsXSmArTD3kV76xIO67bb3ezV/N0sy3QSP3YWumAx2sfgfgBz8OjnbiQdCDHTXnZGguRF6IUJAELK8A8lmcYLenUzGtws7hz0f8kGs96v9XhOjwLXo9IdFHThq/zoJ7jfabE0GJy3sBDS+x/lvkygY95rNhy+IBXsB/g4j/Owew7MrMVDHK//2IZb00EiysIFY7/zy7ccVDIwxSaefKaj81tphHJ0P2jj9ToHmQfJBXcqRxuGFI15blCM+cRbaDfalTvwFc+OaFPIbo9p+Dtp7OltISske5w5/JuNL4VRjxyw88XwVG6lBAX16/INcWbSN6LkYtIx1hoa8QGUxaPYBb6Mgf8ZsVvYD5KSMUOEQsZlIIv/N5ZaRpC7rNPVx+VlSXn2dZ3XSNbiZ9SzyXsn4u+NNxffU79PdBQiCny6gfl6Fzl00XCfMd3mJU6ju34ZZQ33l20qrw4V1er/R4GeOxO4QOJw924wLvG97dfe4Hk7ZtmCD63iqm0ktIT7JYErI/b/A+C3JR/m8UDoaLoYYCAE3Ch6JzKca2kNbeEjDyNcPGDkDZDw+Piq8GzoogjJjgUDt
 Gcx7LzVq
 zD99Ho+krPm6OQH5kdEc4efzwLJ7QYmvX6SSBD0unkAvkCPipBlknyEQdK7eu+EkXLa5fuKBPYLLjnVDbla6eN7+U5b8lfYHeUnPVA93hrQo4j7EH3V0fcm7vun6MWrJ5s+/tqQB2yYNrpeA4pbpw3JcYULspy2aSDYFJlvnYieW0gjoiSxY3LjlLUIi9NS5u3iQQiiYKkJAirXFgBfZEpL6gcHYoSAr388OYAz3PDjpHOnhGUMCyblxLUfdt7Ol+WseijfvQaiCc+0F4FI1kvc4AWcuY5YDPNXlocWXOT8b98O7mtl8qxYot+MthsUCHWAFVDdi8PA8N79H8e1q1tm+JxqZ9twsQCZBK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/25 13:11, Lorenzo Stoakes wrote:
> We currently restrict multi-VMA move to avoid filesystems or drivers which
> provide a custom f_op->get_unmapped_area handler unless it is known to
> correctly handle MREMAP_FIXED.
> 
> We do this so we do not get unexpected result when moving from one area to
> another (for instance, if the handler would align things resulting in the
> moved VMAs having different gaps than the original mapping).
> 
> More and more filesystems are moving to using large folios, and typically
> do so (in part) by setting f_op->get_unmapped_area to
> thp_get_unmapped_area.
> 
> When mremap() invokes the file system's get_unmapped MREMAP_FIXED, it does
> so via get_unmapped_area(), called in vrm_set_new_addr(). In order to do
> so, it converts the MREMAP_FIXED flag to a MAP_FIXED flag and passes this
> to the unmapped area handler.
> 
> The __get_unmapped_area() function (called by get_unmapped_area()) in turn
> invokes the filesystem or driver's f_op->get_unmapped_area() handler.
> 
> Therefore this is a point at which thp_get_unmapped_area() may be called
> (also, this is the case for anonymous mappings where the size is huge page
> aligned).
> 
> thp_get_unmapped_area() calls thp_get_unmapped_area_vmflags() and
> __thp_get_unmapped_area() in turn (falling back to
> mm_get_unmapped_area_vm_flags() which is known to handle MAP_FIXED
> correctly).
> 
> The __thp_get_unmapped_area() function in turn does nothing to change the
> address hint, nor the MAP_FIXED flag, only adjusting alignment
> parameters. It hten calls mm_get_unmapped_area_vmflags(), and in turn
> arch-specific unmapped area functions, all of which honour MAP_FIXED
> correctly.
> 
> Therefore, we can safely add thp_get_unmapped_area to the known-good
> handlers.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


