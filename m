Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1035CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41E18E002E; Mon,  1 Sep 2025 06:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E184F8E000B; Mon,  1 Sep 2025 06:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06FB8E002E; Mon,  1 Sep 2025 06:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE6BD8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:27:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BFF31A074E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:27:53 +0000 (UTC)
X-FDA: 83840305626.04.64BAA8D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3230D40003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:27:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="IpfU/kUv";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ARqhzOas;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="IpfU/kUv";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ARqhzOas;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756722471; a=rsa-sha256;
	cv=none;
	b=5Zka5JKBQ+BnN000nJzABoXcSfTRElXar1b1u3yNnVY7UlQPrdFvrZ4phByFJlqnWU+SRV
	b6sGV6lAXCh5ATi5rchh44bE0oN+NPYQfwy1iz2vLia99DF5ur1KUjg2bVZ/5Kq+M0WQbm
	0/Fjto0vOSVkoqU3Te++eQcJukAyEqo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="IpfU/kUv";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ARqhzOas;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="IpfU/kUv";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ARqhzOas;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756722471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOzfdji6Hay6gcG/mjTMJVGEun3YyTmzaRsVI4zhcss=;
	b=FG6tk5WvgWVmyog/3VVXy3vw+fbQCjcPb0Mb8eRtIE2WpPzW2QoGVNN18MmwEQ4V50McIC
	C5cA4nhYa6TkWJ7tlNIkJWwnTW06uLL0fhoA2gLPxHuKc0Uf5mLHylil0OcZFEx1QPLugp
	e/rdI3vMduUgZzhbsMIy6LIO/CSA4Ug=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A871721168;
	Mon,  1 Sep 2025 10:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756722469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hOzfdji6Hay6gcG/mjTMJVGEun3YyTmzaRsVI4zhcss=;
	b=IpfU/kUvhSPRlgrPK7wwStdsey2nyseRdIkhwHa16Tmv3fom00OXPdVxCnewLNvbPY95Y9
	EvNuHubIm5xwP934ENNJ+2IlHvyatUfPDQENlnqcxhQHxExx0/nNQ/LIRO3yoIqpM2cRzv
	BouG253QFy+8D8Gff4vnke0pUU8Nxbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756722469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hOzfdji6Hay6gcG/mjTMJVGEun3YyTmzaRsVI4zhcss=;
	b=ARqhzOasjwvPhDImt6/uQF5wr1ndTxc9HYDE0NWWwa7Kl05b6+th9BeUu/wECxyWToAudW
	nbFweD/dcFQDZSAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756722469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hOzfdji6Hay6gcG/mjTMJVGEun3YyTmzaRsVI4zhcss=;
	b=IpfU/kUvhSPRlgrPK7wwStdsey2nyseRdIkhwHa16Tmv3fom00OXPdVxCnewLNvbPY95Y9
	EvNuHubIm5xwP934ENNJ+2IlHvyatUfPDQENlnqcxhQHxExx0/nNQ/LIRO3yoIqpM2cRzv
	BouG253QFy+8D8Gff4vnke0pUU8Nxbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756722469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hOzfdji6Hay6gcG/mjTMJVGEun3YyTmzaRsVI4zhcss=;
	b=ARqhzOasjwvPhDImt6/uQF5wr1ndTxc9HYDE0NWWwa7Kl05b6+th9BeUu/wECxyWToAudW
	nbFweD/dcFQDZSAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B977136ED;
	Mon,  1 Sep 2025 10:27:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id baiDOiR1tWjcAQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 01 Sep 2025 10:27:48 +0000
Date: Mon, 1 Sep 2025 11:27:47 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] tools/include: Implement a couple of atomic_t ops
Message-ID: <tnbyxwmcwia3teewhqlpdjk7igsljfqcqbze2rbalzidccfndy@e3ybvfap4pbd>
References: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
 <20250828-b4-vma-no-atomic-h-v2-1-02d146a58ed2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-b4-vma-no-atomic-h-v2-1-02d146a58ed2@google.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3230D40003
X-Stat-Signature: wnxrpf6h9f6a8donuo78ce8pq513669f
X-HE-Tag: 1756722470-169193
X-HE-Meta: U2FsdGVkX18V0qXeWM0DWJzk/HdD38puAi0q1ug5KWXZFES64ueYpSc6fs+53On2172+d6FrYrfyOPZyuOZdBRn9Za3UX51BwXS5IM8kZ1YCpmybKEEXLttRrd4wP56flzdygK4i114UPIGtR7cJu9Uyj2inr2p5Ybb5PYUAPglByB3jrvKebvn6UaKFOjCNEswnaNb7mutVkK0DexWUC5eYPdU1GUR+GZgIwZa4jfwD6OzQGo1Z8ag1Omr0nNVuCttx9jrv9tUvOAtdDFjK2k3XmyCa5xE2+gGtLF3YoAqFHwJ+HVsT9U0alytNWdTGOKJS0bmhro2AMbAm6MTmatjnMAGSBNBk+GwFCX9AcHYxLbDW40UY6yOPH8PvbRNtxhQ4ORP/lzhwv6ZOo5hW0d3nqPdxHonCSXK3aQ+MhYY4QYASMkHYP+KHKr8tOSFJxwPNENa2ZGeXEUOdwJfcH5hbg/ICuYxZz9Mz6e+j5KIGGA0WUB8IRUxnI7mhS/d+g4VSuprc14EDAqCgV9auzDJNDlzh77cJgfs3ULcD2uMURQdCoIN/yxL4ze0s3wEVuEkTG1T31Wk/c/YZK9PX1TQq3UChNn5ftftK+JQ3zMCiCTH1SRfkiTgt6Havhbw0pU1z4KtbZJ9/W1IhFMV5kyUGIy/5y2CX08G8ZntxToSmYBtBG0UdykNY9DTlTdLUeQALw6oJ3XThS6swdq9p8UjWHStM/z9sncnjSjfr7S1HxAgW2Fo4jhdGk+Uszdlt1Anpmkr6hjYL1k/gMFDyt1EMsy/HoapseR1sxCF1rc1qWYZN7vB4Vk8FFzfX2rRPbps5WJcnDo5C3OXW0CK5+MgsAyHktHilorpl9Kf6Nh/gRypo9nwKIFHzvfpTThBWGULKlzrQvSweQECQGzl+blr1WYp6vlbOUQiPOJQODqpce2jdxDjB1B1QgBxAYVTOgU+mhe9xXTuRkgbRZmm
 PmX/v+1e
 o+gDeuUysEAvioBeTI+gL44fjLf+auLOW3JQoTwq3/G+5KLfls8IFG5kia+qHlGLAG+8AMV10lomZT94aYPcGj90i1F+yUAs+5SvfMy8w2CSXx9IYeSoATiZ02v5Rvo/HoDaC7vHjeCbgcEmNHrZaDViPE9AboeI1Zgf8Dp6f+3CjM/g7jLub/nWfwcUBv8Hj5aiH5cZmknnUmAOTtlG6JagV5UbjGk+jA5j419NrIKVXNacdyrr6aRBq8FNy/b8VUVpHeB3gxMzrg+/ohxD4AGX9Gnc0bbApwpMT4UplaJtoCeW74SdTx9n7jf/D70hzQkE4nYNhZ9qm8Orvo0pQObSu7QNtejC5HTTwwLuRBkT+Watri/AsnudpKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:27:58PM +0000, Brendan Jackman wrote:
> The VMA tests need an operation equivalent to
> atomic_inc_unless_negative() to implement a fake mapping_map_writable().
> Adding it will enable them to switch to the shared atomic headers and
> simplify that fake implementation.
> 
> In order to add that, also add atomic_try_cmpxchg() which can be used to
> implement it. This is copied from Documentation/atomic_t.txt. Then,
> implement atomic_inc_unless_negative() itself based on the
> raw_atomic_dec_unless_positive() in
> include/linux/atomic/atomic-arch-fallback.h.
> 
> There's no present need for a highly-optimised version of this (nor any
> reason to think this implementation is sub-optimal on x86) so just
> implement this with generic C, no x86-specifics.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

LGTM, thanks!

-- 
Pedro

