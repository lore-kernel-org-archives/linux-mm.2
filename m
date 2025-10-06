Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08850CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 12:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1E88E0005; Mon,  6 Oct 2025 08:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479C28E0002; Mon,  6 Oct 2025 08:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6228E0005; Mon,  6 Oct 2025 08:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB608E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:27:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C612D13B4D7
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:27:53 +0000 (UTC)
X-FDA: 83967616026.18.673D5E1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 903B81A0003
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:27:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=usqtrK+T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CcQacKOT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=usqtrK+T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CcQacKOT;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759753671; a=rsa-sha256;
	cv=none;
	b=GwqcptXvyN+qNrYZUkDbWhJsifCZnN1V6bPCOpdhJL/AV+HkeuOnHJjK31a2GWFdvNQqd2
	dEVcmPB92/LCm/c9FXW7o0OPflMNArFa/EQN2RhjrHNBxy7RuMoHcxR6/uEbXj59Xd+KN7
	Yj/UR9idpdWIfWJfv2YWCZLBLvD76t8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=usqtrK+T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CcQacKOT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=usqtrK+T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CcQacKOT;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759753671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/N8w/X5/6A+i1bNWZkBrJvAuFqWFqiVFijqUr8HYU8=;
	b=R3Up7/n9BunXit6ZBiPeeIsFrYTIn6KbXBYjQy20pzEAaF0bYTzpxLV3MaPlgtdkmS08H0
	QFwfvSV9VUP/n28gKPZOnn4NjxAY5iYRP9ivgpUK1lXfDDHB9u5cHy5tIpSIzH+xws9UX2
	1dB9gARCp1VQ6w2qgBSpi7mFC2iddUg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 22D401F45B;
	Mon,  6 Oct 2025 12:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759753670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W/N8w/X5/6A+i1bNWZkBrJvAuFqWFqiVFijqUr8HYU8=;
	b=usqtrK+TmjksJl2a/CxQ+wYENLyYyi5sf8CZiHKfYp7iWO/99o240xW3a6M3gEna9bsKcU
	KTyKOlqz/2ZHMF3xC+h3xY70NRL9K6RLuJTDH/44pGYgXws9j9XAEBQk0oAmvmAcNN4bzB
	is8AYuWk9YLWBCALmIuozIZqCMZj6EI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759753670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W/N8w/X5/6A+i1bNWZkBrJvAuFqWFqiVFijqUr8HYU8=;
	b=CcQacKOTPAw4+hTxz7jwmT4blyIjGwNgb3fH0Urxj3J20aSj35LkuIg78UqdBkA+9AygDE
	FGjxyd0730dUzIAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759753670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W/N8w/X5/6A+i1bNWZkBrJvAuFqWFqiVFijqUr8HYU8=;
	b=usqtrK+TmjksJl2a/CxQ+wYENLyYyi5sf8CZiHKfYp7iWO/99o240xW3a6M3gEna9bsKcU
	KTyKOlqz/2ZHMF3xC+h3xY70NRL9K6RLuJTDH/44pGYgXws9j9XAEBQk0oAmvmAcNN4bzB
	is8AYuWk9YLWBCALmIuozIZqCMZj6EI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759753670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W/N8w/X5/6A+i1bNWZkBrJvAuFqWFqiVFijqUr8HYU8=;
	b=CcQacKOTPAw4+hTxz7jwmT4blyIjGwNgb3fH0Urxj3J20aSj35LkuIg78UqdBkA+9AygDE
	FGjxyd0730dUzIAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6925E13995;
	Mon,  6 Oct 2025 12:27:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zA10FsW142g+dgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 06 Oct 2025 12:27:49 +0000
Date: Mon, 6 Oct 2025 14:27:47 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: muchun.song@linux.dev, david@redhat.com, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	broonie@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] hugetlbfs: skip PMD unsharing when shareable lock
 unavailable
Message-ID: <aOO1w3OMc7c563w3@localhost.localdomain>
References: <20251006075436.8417-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006075436.8417-1-kartikey406@gmail.com>
X-Rspam-User: 
X-Stat-Signature: bayhch6dppeppf3pu15kamnadebhsobg
X-Rspamd-Queue-Id: 903B81A0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1759753671-826864
X-HE-Meta: U2FsdGVkX18cpncQpXZnt083LctxyIpurBKj3cItGh+e8hiqrzqFGbpCgIRUJNzkyMc2h8cfJqfpaBhkTUqUqhCkVctSBtYJBFCXU//p/2YQ00irmg87JtW/5gzOb4/C1QSeJDiZnPiJekgY+h0OwsyE/Q5iCKdysXv10dab5vvRE0r9EkP/YQ9JT/+YeM3bOiydO6RN352PA/MNdU0Ml2hiJCsXkY6Sb6zxqmiq0UxEFIA9MkJ2OBivII6BW5lWSaC7MsDU3+FnRDGSgNXyRL45nfPUX8wVdrqHaKWecpIEYaPD4nvkFRx4gIaxm9AEhebh8rypTeODLtLFKBemSR30Flon2ho3mdrtTn0M5ghCZM+kHlcKzOeiMAxrJXaMj0RJRxXPgKoocXMy7HrRoFZXU0+TjBym31LrUaBVSKTF/c3QumjJ1gCcZXOrJaJZ0Tx7Z9tdWwPl0IpSuCjBJHavZgivboPKB0x4tf4orLT08e0Jk/WbCQKJq57Iax/rUx0TZpAVo3gp483FRuhioMn78g3tOHG3RCjFNx6rIuG/CVOybG2lZNdOT5TYNq6CaoxHLH6/ldKyEvjcj44R73NCrJ7iklw7MIbSK3hjejTHftSkp1IjWsYF9ho2GNA/HIJWBwCo6dCUSwPPAApkcOLBYiq52TsTcUImY4C1M/BbIFIO4c3jPS8nBP2Z9F0In9Z2tPrZNpj0bO+/lmz8wVivjr3AJPqAs+y+hy50MSvA3F28yfAFP1kNn/vQIeBZEQ4oFkf6BW0Lmr6p74GxN2d+yCKQg9qx8SlSb0pPTXzxiquU+tyvWIGucILTBHwkv87Cbf2lSdiMT4o+h65Bq5XkT5nc0bfT3nh45p7pKjhPeO8IIcw5vIS0ElDQEafZe43Z4Cvb6AM73xMI9+SN6wAC51TGTM9BotPly4mZCBuaq18c1MTVjX1AkklW2HRZj6Gp1KFB1AUUWbuipUt
 OKAK/SGk
 /SLTFOmOKXBGOzms1dmvMB4G9Oh2Nb233FVm5QKMf/jTVIBOvliK+v7vnMIUzQpL9i/qhKpt/9Onn8Olh9s4ioCcvHXhxCcXgAXjgmKyyQQm6EUZ/pns27cKv+ZPgkcjMRWOGJB63Z8PVtsRdjVjjG1/5K2q0hpekc6TRyOZ7D3I+PYvebV3Lvj7YBFGccysu9c/5VeMe+LRc3+EyAdhdwYWnQkGZSaj5d+Sc7f+fKQNiPSqtpg5Aup8fS6e40ea5zkoXgj68M4b7SG3VwK3+mvvomBV8x2iXN4J8xTnml2QuarpxUhwf+/GZdxyV/hdVa3PQuaOlbxKd5XC/m/APwaiXzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 01:24:36PM +0530, Deepanshu Kartikey wrote:
> Apologies for confusion. Please disregard this patch . As, it is creating a lot of confusion.
> I will create patch v4 with proper commit message and previous link

Hold on, let us try to avoid more traffic than necessary :-)?
I plan to have a look at this later today.


-- 
Oscar Salvador
SUSE Labs

