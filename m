Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A7FCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3352A6B00D9; Mon, 11 May 2026 05:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FEE6B00DB; Mon, 11 May 2026 05:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1526B00D9; Mon, 11 May 2026 05:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5A466B00D9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:02:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0287120680
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:26 +0000 (UTC)
X-FDA: 84754547892.02.7362DED
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E800180009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PoCU8OzY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fUlUSKNr;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=p2LY0gDu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=j9c2qRiB;
	spf=pass (imf16.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWWQDm25jLJiRbtKOd/fbqnKTLV1LaC9qSn9EBz6Y9Q=;
	b=FrBXyRGoyfkoyQfW4mmouefQ9KsVfL50jTzxghN8pJ9GMvFoMdjHc0EL9N8W7iexPLWipT
	13SH53t7W0XbR3wFvAcxMgvYQn6bAh84cJSLw5Z7dXTQ5VibI8XHAmSksl/wS8A71C2c5K
	1LxgikGnEtyv78m/KDVMxXOKcGqxqUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490144; a=rsa-sha256;
	cv=none;
	b=zgaC7RmWmEGc5zly+YgvMFvttNy9sR3XItwWIEND2TJwu2y952CLHN1j6UplRhyQYygJw+
	Rjs53pVX2JctMh2wDz20aRbcT16VeRK0XZ6ls3Wi7IEkRWH0tjcmnvm6kM1bd29aIpdSmK
	GNvmtx5Oj0cJDlRZREobKtJ5avGm2YE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PoCU8OzY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fUlUSKNr;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=p2LY0gDu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=j9c2qRiB;
	spf=pass (imf16.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 13B0B67EAE;
	Mon, 11 May 2026 09:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778490143; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWWQDm25jLJiRbtKOd/fbqnKTLV1LaC9qSn9EBz6Y9Q=;
	b=PoCU8OzYFqlNgawABXNYSMy2qaLFjPCaRy4eT8EnHHuFjtDcpxE9NI7RUT2WOffeY0mnd8
	BHFo2W48VCESmk6fMtFtNBmtqd2kt2pw8olUsyreeGGLzn7+94TCZB72wQarXlWCa/fL/x
	Jo9VpIR/YSVJadRJdfVtW2JeQd9Nac4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778490143;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWWQDm25jLJiRbtKOd/fbqnKTLV1LaC9qSn9EBz6Y9Q=;
	b=fUlUSKNrKwGJEiVngq+DDIB6Ntk1eRbZ2+Y5VNKG3wyRIsgukmHOf/qjlIqV+ymbrVo+XH
	b+iZsQX46Cvy4FCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778490142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWWQDm25jLJiRbtKOd/fbqnKTLV1LaC9qSn9EBz6Y9Q=;
	b=p2LY0gDuJVtgja3TPdczNQezQQLva3OYEpxP3EVpoqqIzJfhcvkOtlBtOPjp3gtJrP0hsE
	GjwyThofqFBvdxwxoPqJdh8FH99aDq03gCCYfNLBknOkfOIYdh63rrIk+9qGmbbxOw15MR
	oevWaNtGlOU7J6kN8PTWbjA5+r4npfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778490142;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FWWQDm25jLJiRbtKOd/fbqnKTLV1LaC9qSn9EBz6Y9Q=;
	b=j9c2qRiBQ6fZl2gTsEXipcDU866IrbfW//42tU5HoZPaZF57OlQ36BO3YebxqTW02oshGe
	OA0tMuLh+UnI1gCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93B11593A3;
	Mon, 11 May 2026 09:02:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4XpbIB2bAWpkEwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 11 May 2026 09:02:21 +0000
Date: Mon, 11 May 2026 11:02:19 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	muchun.song@linux.dev, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory_hotplug: Factor out altmap freeing checks
Message-ID: <agGbG3pWN_qvPWqS@localhost.localdomain>
References: <20260511084307.1827127-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511084307.1827127-1-songmuchun@bytedance.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E800180009
X-Rspam-User: 
X-Stat-Signature: nusunybggfnr9mpaig7tr5yc7xxa5p69
X-HE-Tag: 1778490144-29579
X-HE-Meta: U2FsdGVkX1+Af7b03xdFsQ9We0H15pxyRB/eXfccjm04SJi3+bfbuKEJOLuBSx2kT351M466cOQ85jKCcSySn3+AqPRasMFvE9UenKZBhgo/0Xf7b8p+VMCSt7DoYFh2sWCbAYHeSJEEy88uoiT3JK9Y3QANqCucEaW6Xh4jX6Uj08GbQv8qrtzGDEsUDbEIfMbc1mt18FOVIZRXaSykAAz6xNNaqYH+L0pMoH9h1ZpgK6YAPx98XNeUz8NhDp1PMRKk1Pzj5+SrWOm4DSj1qNUqnqsJEM+FsvDizNeAjQfLMs10jKKT5ujXCZDmYx+5QL/HvGYT7++7jXeRPXohEokOlcybN0/sDmke3uBx25mYFC6DsGLzHLRXl4qhjA1F6AlnU3/y7oxFFFC5bzo4rchCvp3tCJPx7MAI4rMn29+x6WnWkww7qmSeAGbkjcQyuOR89+dVlMNH62SAnxqWSmqCk3ArIBqml9nVqLdkpjXX+Zfp+j6AE0ANj6K86rNkZmVqpaT6r7tyVzJ2gW7+FHg+q3hHl62zxZMxy2ga1ucAiocMp3OmIpSNmD08vnf757/J0apbjCLVjzFbXUUxnJ687OUYae2Uih0sA5WbbqNAMGfSWaZ392tID0Lrf4SQKAa0P4XULlqvSWiAZ0ID8IavL2BFpy69tFEk4BVktza+f+44lu5V7w7n0D7ojtKOgffWPcrZyH8t9DYeo2CKcI9Uzgz6sEVOx7orPGgsIG/+yBZAqloyj8fFcJWgrL2UbwH7ruhaxqNCzNJ7AuhZVes3kyS4R3SCFtXIfyXlw4wc1ce08QGfWwPClwOIAvykBgSPRjwjzEiLcV2HIKOb0ej702TqVdKx4WmDhaaYZRuK1CmAxbuaMb+THXTIUE586REHenOufuermDwEV/cR860EMAgAuKfEXIJKqdx1Ep9fDTYfSu0vY7GGLmuRJL3h8PvpXWHGV/jHXW9FvHG
 N67tRd/q
 5ypgOONo2u3LDHEiioQBHoqlUhEH3ofUArjZXPqdSMOEkB3FrXTjMrRoJz/HmYlJORL4m/rY6swS9qyJ1cUlfvqj1Tf73FcKkc3/Xy7+IDXMKePLo5qy0xBZjYtnIczimclXC9fnhQVS5qXU7Q3UejvAVAaD62MteeKCruvIvES1rCIjl5vLegeq2zsaseykFzh2tjfTLrkkMcV8nGgYP/OxR3xJvUA9IInzt0BZN+y4mx/XqHT/0iznkZiCIhMMHbiqfIcqdXY3hkkGrIXyrMSVS7jEovyD79MnR3KxDK9kp9E7CEh51jGB3tsEItRUT2sJgVwRoBTjfYmSNZMibgktZsGwoBAsgwHs4E5bn/1tcg0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:43:07PM +0800, Muchun Song wrote:
> Use a small helper to centralize altmap freeing after verifying that all
> vmemmap pages were released. This keeps the check consistent between the
> normal teardown path and the memory hotplug error paths.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

