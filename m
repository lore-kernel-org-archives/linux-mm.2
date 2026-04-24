Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8732AFED3E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA8F6B008A; Fri, 24 Apr 2026 11:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C926B6B00A0; Fri, 24 Apr 2026 11:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8396B00A4; Fri, 24 Apr 2026 11:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB67E6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:19:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 690DA1201E7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:19:10 +0000 (UTC)
X-FDA: 84693807660.03.2749D92
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2774640007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:19:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bmPFuXtc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2TojRZYU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bmPFuXtc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2TojRZYU;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777043948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiZWwL1oO7W6rcVWiGLDctlVSpHEDUggXUoQ7EfcP0E=;
	b=y6MXDTmvzgOeYPM1TUSIl7/GvysWXeLm/IHmBLNCOhFGVSLBn7SdXxwCslxrN34IP5eWcE
	E9+ngHOHo9ArVMX63E60UgEvF5b2yP6Pvadz8HqpQKN38rmG575sBKVq8wKMHAffDpgIUM
	IPkYRMopMLrgWtWlseKLmgT8clfYfZI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bmPFuXtc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2TojRZYU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bmPFuXtc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2TojRZYU;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777043948; a=rsa-sha256;
	cv=none;
	b=haE8aY/E9yFWANdBcgPupJyU1NlBSdecTvev77QuZA28D7yWa66SmEN3+RNogZJ5uFdbK0
	soN8/9+3rBuTeRZ9CmnhkmrHsSDOfBI9CjV+dP/M/Kk2RUEgnp0N+YL7EgJHoTIuZusEsQ
	VKp8xg73F80BenJA+9nyJi3ozRb7PXM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6DF965BD80;
	Fri, 24 Apr 2026 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777043946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QiZWwL1oO7W6rcVWiGLDctlVSpHEDUggXUoQ7EfcP0E=;
	b=bmPFuXtcCqnqa1B5gP1hYOlaIYxkRFPEZUaqTp+b7KfJBbxp7OpdfTnozi8F80VX25E7MB
	Z5YfHOpQddE7xoyBLI/khAsE4XpERsHnsgik7DYqetw+0/c2g0AWleh1fSVMxFwssSaB9G
	Pio0/Cl9bFMMwYIShIhEWi/NA2amznU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777043946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QiZWwL1oO7W6rcVWiGLDctlVSpHEDUggXUoQ7EfcP0E=;
	b=2TojRZYUIeyLOzo3YVulHhiikfR1XLAvh9NMksMD3t1uUOE4FL2c88s3ipHn67t/5re3Gv
	CwfwPHcRV5PpkADw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777043946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QiZWwL1oO7W6rcVWiGLDctlVSpHEDUggXUoQ7EfcP0E=;
	b=bmPFuXtcCqnqa1B5gP1hYOlaIYxkRFPEZUaqTp+b7KfJBbxp7OpdfTnozi8F80VX25E7MB
	Z5YfHOpQddE7xoyBLI/khAsE4XpERsHnsgik7DYqetw+0/c2g0AWleh1fSVMxFwssSaB9G
	Pio0/Cl9bFMMwYIShIhEWi/NA2amznU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777043946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QiZWwL1oO7W6rcVWiGLDctlVSpHEDUggXUoQ7EfcP0E=;
	b=2TojRZYUIeyLOzo3YVulHhiikfR1XLAvh9NMksMD3t1uUOE4FL2c88s3ipHn67t/5re3Gv
	CwfwPHcRV5PpkADw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 51C14593A4;
	Fri, 24 Apr 2026 15:19:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WzyWEOmJ62lqJgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Apr 2026 15:19:05 +0000
Date: Fri, 24 Apr 2026 16:19:03 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, wangzicheng <wangzicheng@honor.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Matthew Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
Message-ID: <w5ekxean6g6eph4427frzclgzu5hrd7kqres3ronlqpvqtsusb@kfdagnk2xqif>
References: <20260418120233.7162-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418120233.7162-1-baohua@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: gnk191ee8b7infa9c8p3ynipkkzgxgxn
X-Rspamd-Queue-Id: 2774640007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777043947-881078
X-HE-Meta: U2FsdGVkX1/tKCdo8/CdBtWEvJ7RWbBeVI6/xMo7WSkqTqvxs6pMlVXgWORproER4HwHkM89UDrjhXddVFrBmmLrNRu1nI2pQrSsii1nTiv/grdpOTx8w5xvI3IuTbpD3GDYjqzSeaVGR3d4sNNThjPiHlr6G+gmnyYOZJP9hiKy6tCmbvT6/ewx1V7ZKStsIPY2FIfDUW+RvHVrUQhObUD0Ao1K3f5tS4GeM3zR6Ykp7r7cR2gGVhQslUm0psrRHvM9O87FI5p23LkQnf6VeDvfJC7mvdmD4DOCs89KIeEFK6PXwzkknjtrXtmZ2NwBQ5gsgquC/IVpj+yXyYLWcNuggoJGrABJopwKJyihYyLDpA+wwpGlA5ZDCGeGnc1/GyO1TBQFiJpJ8GQnDiiESvn39yX+4jDPP21FHur8xMdTMgAxqBfVfNznXkcRIBcG+JSCcHhXwlgbaxqNXHCwkYo9UI2/S0/F1C4ZWb+5PaB68ylZtqq1ra96QNNIt+R6iZa50M/CL+bB/N2hcHl2taoocRKN4XTzh/L4da3WkHab7yjzKZW9ztNxOtOpMOuOtf943/GWkA0BdE91LX0WPT1JIZf0SCg/rJjRD0T9QXrrB5tV4yUx8Nog0vaRUuYbwFAc/ZBTZUcKnJu2J52aTNfc7pfYxJud+Oj4xONuxHqnIfEb7c9GOj13bSygIcTEAfSJJFEowRIeglSlmP+jXRtHOQsmOyQQppvFWcmBqXtFHIoShxN1RJ1ZAIkJUPWkHivpiHzG7noyB7yVJlA0Zrq+XqU+bYa1qbg1DxgAXlEVZHBithbTSidwyek+XAza0VaEQ6Bqlqx3nAyBSm3f5KAdO12+i7j03zdZJCUiHwK0ikRA+DkjgSjMi0SRrgVhrPMlsQ2dLM4qf6a7854XdaviohXrpn7/97wOaCtsu9+dgUXMAiqAFs1/JL73H9J6wiS1QOzoSyA4vX5xIGI
 mhkAtse5
 3N+fVk3GKy2PReV1CU9xkmDjfX2hEjwqXBjbeYS2IOYF8+3tGjTodnqlTYdfnTrT4R7o8WAIwtJ7R3cEd7KesgfHuFxt05fCWuFpU/fZ5uTTHj2HiHt4/DKhEGxyoWV6daJoi9UIkHm9m5Vz5qB5z0LadWCmLMfUwSKU8CIbggViqMQhRXFsfk2pwv2VWX7M1vhnosm4z0rL0hTac+ky3soycww+YEtGQfopUq2hTV4qcjuITuJFIIYA9HC87aj/Hk6/A5sHeN/nTMvNg47uPxucWPgBEoVfpdzmo0I7rq0R9EdT25QRGR//FhHb4pLbiKeCkuiDBlDdIJlAsvj6eyQQL8yZoTjtcwVyLa+cLXAxEz/wBIlm6Te7v5vorXssv6S2q3VFEdHuzfPm7oZE67lM5mHzI4YKDs6VBoibAsBTnyOoZs3ZaqnC1hGsXCM7dSiY3frG5f4CuKU/CGayDqBMeFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 08:02:33PM +0800, Barry Song (Xiaomi) wrote:
> MGLRU gives high priority to folios mapped in page tables.
> As a result, folio_set_active() is invoked for all folios
> read during page faults. In practice, however, readahead
> can bring in many folios that are never accessed via page
> tables.
> 
> A previous attempt by Lei Liu proposed introducing a separate
> LRU for readahead[1] to make readahead pages easier to reclaim,
> but that approach is likely over-engineered.

Why does this even need to be kept? I'm not sure it makes sense
to even mark readahead folios as referenced.

I'd suggest folios should only be marked referenced (or even active, whatever)
when they're mapped. Anything else is a bit random and is hoping you are
eventually going to map them in the future (which is not true for, for example,
anything in an ELF file that may be readahead but not mapped, like debug info,
symbol tables, section headers, relocation tables, etc etc)


-- 
Pedro

