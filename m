Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F54CCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 12:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922488E014D; Wed, 27 Aug 2025 08:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA2A8E0147; Wed, 27 Aug 2025 08:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8103F8E014D; Wed, 27 Aug 2025 08:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D94E8E0147
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:50:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14759139E19
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:50:10 +0000 (UTC)
X-FDA: 83822520180.06.E00E7F5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF7161A0009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:50:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WLlgGSvQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xjMmKgE4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WLlgGSvQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xjMmKgE4;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756299008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v54dIouATmnuSJr9b8zCG6xfHOxa95s8DPKUADFVBJ4=;
	b=YQb3chm5CsLXLfSbf/v2om3N3j2m7Qkf8FOHlGX27ECYR7q4DgvrhLQYSpFBILPnjopFaF
	X+rfE0ZOz/A+isaQvTDTe2scfMvPX7TQ3Z8xGfo1Lxh04/uLA1/ZFm2jTLzTROZ6LA1yEt
	eWNV77NefZD6VzFokHKgwaINATnzBB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756299008; a=rsa-sha256;
	cv=none;
	b=PuYkQEQ+FeocOpq0cR0yJeLKH+HWfZz1rPXfTJ9d2uIcbfchIgSH3blyKTZjFtb/dKbD09
	uQuHVFAV25tt77FH4TVNAnDaJFf4C4/CRDu1Uhl81/a/xcH2L8mrB17dGeSNJihLo57aq8
	FGBBEFEb3S8Vt3OflxA/xAkQ/AuaxzQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WLlgGSvQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xjMmKgE4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WLlgGSvQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xjMmKgE4;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7ADD922158;
	Wed, 27 Aug 2025 12:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756299006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v54dIouATmnuSJr9b8zCG6xfHOxa95s8DPKUADFVBJ4=;
	b=WLlgGSvQdmBmSFqlypFXfova6OT68TCMH+3yNLF8/o7uBtjjqFEFw77UEAR6cfTwx2+l2B
	fViUzc2WvOhRBXNZXNWE5+k9fyxOtWTQa9k/b170NhVGylQcc6lBvP4MVuPm/RpiuIKD4T
	Q7dT4rjd4S8/EQBo6vzc2GdTYVNsAFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756299006;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v54dIouATmnuSJr9b8zCG6xfHOxa95s8DPKUADFVBJ4=;
	b=xjMmKgE4nXH8y5ipv+22VMpKZxMeY+3yqCPtIXHNUAnDRsMKXmV+u3GC3oqj1OYj6R6nxl
	86QWtd6KWULJpwBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756299006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v54dIouATmnuSJr9b8zCG6xfHOxa95s8DPKUADFVBJ4=;
	b=WLlgGSvQdmBmSFqlypFXfova6OT68TCMH+3yNLF8/o7uBtjjqFEFw77UEAR6cfTwx2+l2B
	fViUzc2WvOhRBXNZXNWE5+k9fyxOtWTQa9k/b170NhVGylQcc6lBvP4MVuPm/RpiuIKD4T
	Q7dT4rjd4S8/EQBo6vzc2GdTYVNsAFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756299006;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v54dIouATmnuSJr9b8zCG6xfHOxa95s8DPKUADFVBJ4=;
	b=xjMmKgE4nXH8y5ipv+22VMpKZxMeY+3yqCPtIXHNUAnDRsMKXmV+u3GC3oqj1OYj6R6nxl
	86QWtd6KWULJpwBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7E9113310;
	Wed, 27 Aug 2025 12:50:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MuuRMf3+rmjIWQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 27 Aug 2025 12:50:05 +0000
Date: Wed, 27 Aug 2025 13:50:09 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] tools: testing: Allow importing arch headers in
 shared.mk
Message-ID: <j2vfxy4sr6wmuovlynvljvmy6as7esevp57hyqkhofxnxnjldf@ul6befrh7eqy>
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-1-5d3a94ae670f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827-b4-vma-no-atomic-h-v1-1-5d3a94ae670f@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF7161A0009
X-Stat-Signature: esmyn1isfwjei5q4ys5akq9bge9sofcg
X-HE-Tag: 1756299007-831458
X-HE-Meta: U2FsdGVkX18A/IHZF6c2DAdeK1H2HX7+LpYjTOxmSxINkCFSFZavC1puMS1zJcpx2Ne6mCQTPSzdURoSy671qAYTNdtJA5ouMOSl4Z54yCJRjTIlI8ZAZ3fU5YbnQh/dbzLgC4M/tQPf2s1EtgBIG5Jzy/CipNvtjhVfGJW4o3JbTZnOaPRvoDXgv6YeIiNszmlCccyoB3liyr1fJzUBA0zKWBVEmiooBiwybFnm4QMF8zZGyiy5DOcK3gczGv5iz3kOEIzJOm8MJTqgazRV2Ghd4TRpEZzPDBx9MyUsritjFAbWCzlsfm8KSKyxlbxuSznqY1+N9u8+TO/VgMjyjhHhCM5ouEkryxy74sPG2szg2WMRbKexw8j2OBlbScXVPMiLr7ibOti/gg7J/RelIUOOAIeSAbCQDodulpBTwjjT3tKZN/a+++Qp3L33YdWT4n4ykmxTMV1A4l3fYGXI4jgmdXeISfHvFaSAXB60G9nPdl+duTX5kGuOVR4pJWF5osVOhP8J24y4QlpB+/DWa8EITPyWjVnV7C0phJ+er8iPzW3g+SCqZTy3QQWvwqdPxW94K7HGwedOpe+e0W0JEJjhp9+sxlr9ngDnT3cUkTDIxnirynmOdlVYHt5DmJ/zKHxGuTlo1Z/Bk8E0gG3l4BOxeY3f2wjRQeP43S4tZD1MH2l/8iZfaSwYTWdBLvbTfxJDfSkLEd4kxib8Zb34jzQ63DKDO1gxtPxNdlULmFB1y1iKb5Bs4UrH09V8GNEUBY8uxbb5QTB7i87diUKzF9r1lCjwWEjY2HQjHhxDWx7f3Fle9QDL9P9uwcTmgZHwbdx9gWdeaiTfdVnVqa0Wu9xFMliS0vOu43TSFymMK9DK1VZNqYBTshyYhU8jPOjdAWAmpzm6DoVsWXGO9H6tjrwIeooanEmd1DA+LenTxvNyaIEkia7eWvjDGJiI4qtkY03E6j+1ivOEFyWRr4z
 dpcPROK9
 O4UWZSw2F0+H9s2isJRGl4IgqY5/3bzDRCWHCOPHrW8PXFfMiAIpr1nfMK2YwAWBBp7l0GPqDLpePE4uvSAhC91g8frs0+Y2V8NFlIzo180E0gXqYONU/UaUHIX6ZLxhaVn51J3LgCTnli3bLDSwW2JBqxqPJiAtzOI81jSJvROBbfEGGEn2YmhhJqwB3o6wGV+LSbUI1D5k1LUtms91D+kkr6mP9e/Bvx8BFdj94PHiWG1xvKjYIv01+q4aEXUd4Ygz1IExPNZfMzvm9y7psJFE/0vllQ3xfs8HvM+amNNUW4cs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:04:41AM +0000, Brendan Jackman wrote:
> There is an arch/ tree under tools. This contains some useful stuff, to
> make that available, import the necessary Make helper file and then add
> it to the -I flags.
> 
> There still aren't that many headers so also just smush all of them into
> SHARED_DEPS instead of starting to do any header dependency hocus pocus.
>

I was a little confused as to why this patchset was safe, and - yeah - i missed
the arch/ under tools/.

There are asm-generic headers so hopefully those fully take care of !x86? Did
you check?

In any case:
Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

