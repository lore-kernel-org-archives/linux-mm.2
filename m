Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E603DCD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 20:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E7F6B0088; Sun,  3 May 2026 16:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF1A6B008A; Sun,  3 May 2026 16:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED956B008C; Sun,  3 May 2026 16:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD2B96B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:59:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFF76C2B98
	for <linux-mm@kvack.org>; Sun,  3 May 2026 20:59:04 +0000 (UTC)
X-FDA: 84727323408.03.88D51E2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC0134000A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 20:59:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1Xgup3U+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zmUgIm6m;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qKuTWOay;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FMOcnVxS;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777841943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jUR1uxvaSLZyWIoihP/wMTwTZLYZuSSduV3/xUI8fI=;
	b=DGXr1VOAc0ksRHMIGMcV3xxLNs2vSe/Aqp3JJeaxvyngkEwuD1HXFjH3VW/xPFIBhQRtZv
	ANxnYwIYpmt7egpTabO8f99P3nQxYotq/E5QFwEYfkEUfsNVG3dBaMb2dJcWnP6D3yfW9s
	eGqwe9FeoRULtq9bcrCGbH/V4bD+5h0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1Xgup3U+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zmUgIm6m;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qKuTWOay;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FMOcnVxS;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777841943; a=rsa-sha256;
	cv=none;
	b=SjTzyck+sVgoxWct43JFLUpO+hEBHuy9PMT6A2Sf2YeRgwnvEdl4UJ+SA4x23aRgMlvWaz
	axCBxKjEVkB5eHP8uMRhh13VMSQC2tp+B7LA8Uk0Q0vPJoFsvtFODraI6UVzom2O2E9IG7
	Y+gL4JpinGgHfkMwPhyW5SXH/vW7J6M=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EC2DB6AA93;
	Sun,  3 May 2026 20:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777841941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6jUR1uxvaSLZyWIoihP/wMTwTZLYZuSSduV3/xUI8fI=;
	b=1Xgup3U+L3WGHHzjDE44YWjLVEvHFE8HyjQf0n+wQhvavTo5Kxvq9hR1sYdR7Xk6uZYY2A
	tBVPWEBoIcV8C4BcnFkh2I04dQHZjHXcxq8M9jqS96bNn9uNev3+AVHYgOafhhD4fmLzXN
	zBdudaxNdPkv81sW57AgbnkobIQTAOo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777841941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6jUR1uxvaSLZyWIoihP/wMTwTZLYZuSSduV3/xUI8fI=;
	b=zmUgIm6mGUodhQcP01MGDrQkkjyxZRvXpbwKNXsrrqN1+SVe3peVm1MGOWVzH9eGo60jz/
	hVeXQAkDWm6u71AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777841939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6jUR1uxvaSLZyWIoihP/wMTwTZLYZuSSduV3/xUI8fI=;
	b=qKuTWOayyNixedJNQn7ODoi/QDBMwDvcrXceC07F19iNCiXEjjrwM0VOpKcM7gFxjwnLbl
	/VPjNE5TwMeKodjX3LuuGhu3/tZ5Du/9Bi1IeeR0I5cD9Ew79vJwhjaHl9PAPqRHGL3/vm
	Vunvin1Svkpyxf1LKrd8lKzRG4IXqXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777841939;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6jUR1uxvaSLZyWIoihP/wMTwTZLYZuSSduV3/xUI8fI=;
	b=FMOcnVxS9TytqwIJ3XWkpFUqBhpTwC/obhmXtI37EBVjz00gJTuNHETA/KU/mm/GLFmrFa
	cYuJOLGsvptK2wCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9AC43593A3;
	Sun,  3 May 2026 20:58:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zbnhHhO392nGKgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sun, 03 May 2026 20:58:59 +0000
Date: Sun, 3 May 2026 21:58:57 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mseal: use min/max in mseal_apply
Message-ID: <afe2k3jhDIXchVeE@pedro-suse>
References: <20260503115915.18680-3-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260503115915.18680-3-thorsten.blum@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: CC0134000A
X-Rspamd-Server: rspam06
X-Stat-Signature: r3x3bb97rx1bexrjy8y4e9jn6txcngbm
X-HE-Tag: 1777841942-893302
X-HE-Meta: U2FsdGVkX18DyT2oBWkfmDAuhnVdol1/EGfuSmmAM96gZ2KkMDuPEwmPiQ/QagXdJln3lvwV8kC74FLn/d8AQYk6hNLIVqUYMVLNTgCEppe1S2pio4cKbOjf1EAC6EKCDiFoleVNZvW7bUiLeJfbAP/ignpOSy/VHrasgZZfJefe9JENJuW7mruqtVqvLk12M5JX/YGcgyURQ4MCVLGYiIJSy/uMa/So3qWgMXM9CPAzqyk7XviqsQC2FiHC4EJmlONMsSohrrwOkZIW2ZYaEGjQ5iVxyr5ClitBKVWkUbPa1ENKrcWqdBSOjGz9635OJEhGDMn/l1dv6Xni/+QBUsXuLpST/95O3/y+l6MLcNHnF+891CvEQ9TZ/13A27oPSC5IDOa2xYCZVUoEginVsrRSwlIMP/BX9vyb1l6xajSONxGlsal63UdSS64SfdTsYvagVThTMuehnkqqq9rO/GExjDlcUdRREkcsq+dQNfVjz9Q01jYC04FA/7TrQWZp/QhvfJO3fK4f8YCreyZ0pDowxiRJd51vJIBjdk6bT11TYn1mshyvSa+XfMPme8vSlkKRUQcl5U3yXW0vp625WO4diyVt+iS6oevodfVTr4rHpnmJ497JTBN256x2ndZYiRvtjK5S+V/PagVsnqE47clF2jwV5QpFeV4iM0JdhEJvIMA/IykCBxwBn49gLPmvRPSy5EBiMuy3gsDyoJN913QBylZtUc1Be9m0s0vzzgZdu2bk2WK2eqcAvqAzXtLwralPQwrS5t3OM5nVvdGK06VcyoVR9Wudb1a6YaoWNUYyEOCixnSIrg6h9UL/VgZjW8zqpy1GzqUAf4btZYAqy/s34866LcEbT1yb4rifwGHj9k/L6c7gSJ6fzAMHQLiJNwrPQST+QG70OmH3HtuG4iU9Q58qQfKAbGTAr5Gup6h5LMLdbP+3YaD0aWOeWJ62OzsXe6AHa1mqYz9SCit
 5vYTQocU
 KHoRD82x6IVwMV8gc8AX9ocdxbuhETlayH+hyhpP6tFYks/V+bqBIXA1PRU6uej4f4l1TwteuzQ+YthZyDrwl2zgDLa0KPnfY8mm7kGQ5rWn0iZaPJ4msq8h6sFSu3w+HqAp1NAvJLFmLpRby6jezfldT6N4MMHPztxwvcDaMi9QGuDIcCGKRRipIDCNBKJNJZSnKJk6RJcc46YTkGLeCowojv2trdA2YNQUvyQAWM/XSzFxQSDDQJgljlDpU2Rqml6bYCELJ3XdcxWhEY+I+re5diWwNWTW+OeEtf/JlAjwXNte/Yr6hF7y3+37HXTDOkYFjYbTG8cHs9pt2Tah/q5LdW0+fBEUhi5uw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03, 2026 at 01:59:16PM +0200, Thorsten Blum wrote:
> Use the type-checked min()/max() macros instead of MIN()/MAX(), which
> are supposed to be used "for obvious constants only".

Gotta love these macros... FYI this isn't the only wrong usage in the kernel.

> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

