Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58417CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7283B6B0099; Mon, 28 Sep 2026 13:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9E06B009E; Mon, 28 Sep 2026 13:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F07C6B009F; Mon, 28 Sep 2026 13:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37D746B0099
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:27:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BF9F1C22D7
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:27:54 +0000 (UTC)
X-FDA: 85263853668.14.6580D52
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 56B0510000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:27:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="W5ZR3y/U";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oCI6kHOT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XzOmBuHn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rixRATj3;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guBIp/MekqgsDqeDd2Xw/zLYREGmvAdkTYR9qnoypqI=;
	b=Stb/7WtiLAqTT2mbGTNz0WHn2vz+6O3l1TdCJ3MQujvVKuLCX6KH1/pp8HkIlBLG6YwjD+
	u+K5s2VLLNAr9z8rELNLSNLUKMgKY0n2AjefrzEATy4UBgf72q7/i9q1AcP4CXpUqV2/oB
	mQtj0+1pKDi3wuwJPkmxfVT/fqJ2fwk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="W5ZR3y/U";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oCI6kHOT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XzOmBuHn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rixRATj3;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616472;
	b=aXzPZVhPrFFSYbkqpS/56+poJenE6gQScc0Xx7wK7VTSb3DmLgfNc/8F/b3JKV4XOYcMlf
	9aph6Dsu+cLsgCwt2wk0fUt0G3JGGbNQKK/zmBu1QUv6Ec/xkfGzFB0FKKkRK/y7pCQWTT
	tVgB6LmL/huDHNzRrL+rjxFlkuxGxEk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 875281F395;
	Mon, 28 Sep 2026 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790616466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=guBIp/MekqgsDqeDd2Xw/zLYREGmvAdkTYR9qnoypqI=;
	b=W5ZR3y/UdcRpQS0PZCZkghVkuVElx097d0aBev8USfGNMFEOF1irnZ3mpys7Jpy+ua6u46
	fFiwPlP1+UmFrv1VNWUFtrmJEZe+DUm9Z0mtWEy+Ro0PFpACmPpEjaZ76lifgX3MqDgSbM
	j0aAALaaVB1Bb7UPeijkYMSosi+06Vs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790616466;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=guBIp/MekqgsDqeDd2Xw/zLYREGmvAdkTYR9qnoypqI=;
	b=oCI6kHOTjkdfX5dInGF9/hhrbb52rZEnpDE/YdrUihhwn2jmvkDZhCvK22BTpmyrJgyCc2
	nhA8BGCzFI7ie7BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790616462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=guBIp/MekqgsDqeDd2Xw/zLYREGmvAdkTYR9qnoypqI=;
	b=XzOmBuHnz1Ot5O5sEILn+MWugqpyAKKA/PCh+EhcwYncrpZBRTmTLjZC5OQgF/1Ev3/Gso
	+/PeGzxhdsQ2KG3N4y/CBO2u98VcOxUU70gWnUDbvR6kCt25UO5W3EZ+KnQrfX6zwMDTVB
	R7x6Ugt8TMIJYoLCqBYnZfs8JfefT5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790616462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=guBIp/MekqgsDqeDd2Xw/zLYREGmvAdkTYR9qnoypqI=;
	b=rixRATj3Rna+JImNWmorIAkHsvgLdkUUJALiBEPJGYOCI0ojzzukqp+GnrKpBOBDwJuYu8
	Y3WUojCV7JVeMmCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D0DA1133F1;
	Mon, 28 Sep 2026 17:27:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nfsNJoyjumpmOQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 28 Sep 2026 17:27:40 +0000
Date: Mon, 28 Sep 2026 18:27:39 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, 
	akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev, david@kernel.org, 
	liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, ljs@kernel.org, 
	broonie@kernel.org, mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, 
	surenb@google.com, vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v3 1/3] selftests: kselftest: avoid cd - in runner
Message-ID: <arqi6iwLDDBlk6Tm@pedro-suse.tail5790ac.ts.net>
References: <20260926010819.604346-1-thehajime@gmail.com>
 <20260926010819.604346-2-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926010819.604346-2-thehajime@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 56B0510000D
X-Rspam-User: 
X-Stat-Signature: 8zz5i85fky8zhru759y8ha9cu9fmfqt1
X-HE-Tag: 1790616472-123705
X-HE-Meta: U2FsdGVkX1/SYTsI9/uLCP604D/akg3DyaFy9tCfjAo7RW6beSYTXsf6X5IZ9QMTNr7220LdkFhqOzc9YQmvMLcXCD1O9eLAIooYpmZewujy7rbYPSrtVAP+69jQ6BsFO+VO4SyLg0ZR2TdvHlqH5FGrfu6igpqLBDV89cO36b3sgYuYEHo+uDfyt5vVBYfaLKjhivdLqAboosRh6yV1vBbtZbIbd3LinKAAI8W1fr5xV4+45JIKSywLKvBCwnmmx3Ro7Qx+xEh12cctkPP2M/1vxv6D0RmuDNg+/A1LlCc/JWntf2lRMrQxuKGNOtLAe60UbCOepRMO1c/Ikx26AbWZpG5s0fXIqL3Mai1yxlQ6HW4jU/Rm22a/wZK7ZBfQRbQZ9PxTUBQ3Z5rz1FEHuVl3RWO+lfWsEkOdymRl+gMqv55Z4LHa/C4YVsd8RvPGLOal52l6w3q8FZ+TRzto7vp2hyEKkRFSGKO8UbalONsx6xy+5Q9h8s/KBQz37kZxwPMSClq5PSzlXY3a7OoiuJOgbEMqpBlwoQK7MkXYwoZozBtDOejY1ONZUc6f27TWLX9Qg6LxUb4m2jsi7G6xIiwrbL7WoNq6lSvRK/+hoiLhI1MIxaqWjXMBss0XPsmdfqkNkTHpthsoIoo0FEvvx9aNgDyWsKO60lGMujydwxHc611BQ/ZP8Dnv2OI/r09RjOoMWBSNmPBQn3eT+gHLgQDCvEfSeAuQIgGgMFsIWU4a1p21fE7Onfofj+9HbjwRCesJCYEJlm+11cOL2J3gARj9XW9/3MEyIfIPtYeW7Q+fKoXM8V/Gy0YFR4Cb6gTNPNl+O/EiBF9whZ3t8XCbTfgGLwNYJVPz/Pk+t0WWWSXjp0/ldh1+BmJnbZM9h1EL3Czhta+jwYczNp7JTLIeblSdrLZ8meqxLNmdrdGHsNSQ/PLakt2aKQ6jSkRgiU4X31AAKW6jrclCJN1r/ru
 pMmOAUZE
 Ok5xZpl7v6klQcjm503uWJsF5goYMZMpMH5fi4ZvHS+uyW8XFwlbw3uFWgIFYGchzP7l/WIaaDJY8kTw952OOCwymhvfgNiPdtOh58XCw+VvzAj4Sq1fqfnWT7oe5k4s5n/+gxLpvvtgtnypMPRHYCiwh34ffyDuFLqp5r2IfPHul8AJur8+TlJXONIz5NeUWn/z60CGstIO1IV5d2fM3sdvkG4PjZS5kKT/wR7CgKBl/col6bTmREqDpDOh4UBYBWKATCP7qqIoFU+CsGMCPnY9Q+c0XNuLpStmp9IjrFV/ZoWnlci0kt4txsA2fuovlwRWEnQk6Zn1VOvGbZG3MdnpcVr5EADb1UmooBcp+T65VdSlgBQOWMoUZ9gx4FI2SSxVUWZbX8z1/vffPxGQig+eOunDmSzpL4EVbIqjLRZmOmnl1LJn3pKGQknEv0tchnuu98Jujn4Q0dTwHp81BVhzFWadPleMVLBQ9deW3tGMTEisD/8bo/yq1LS4/89OdKFo2LqszV858hJFf1HUiirk8JP+F6zozh6PkLyheH15Sj7V8E4eCJ2DWvl19fJvOEoNMsDMb2RMmc1NlQPzhZJjZO9qCTnL1EUgJFPsdiWs6pXSfwAZaKSVse0o7Anju4lDF6aSMrdF0rssyrRBTYsKnXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 10:08:17AM +0900, Hajime Tazaki wrote:
> The kselftest runner currently uses `cd -` to restore its working
> directory after running a test.
> 
> This is not supported by the minimal BusyBox hush shell used by some
> NOMMU targets. Store the original directory explicitly and restore it
> with a quoted path instead.
> 
> This also avoids printing the directory change performed by `cd -` and
> handles paths containing whitespace correctly.
> 
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: "Ricardo B. Marliere" <rbm@suse.com>
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-mm@kvack.org
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

NACK.

https://pubs.opengroup.org/onlinepubs/009695099/utilities/cd.html

-
When a hyphen is used as the operand, this shall be equivalent to the command:
cd "$OLDPWD" && pwd

which changes to the previous working directory and then writes its name.


If you're running selftests on !POSIX compliant shells, that's a
you-issue. Fix the shell, or use something decent.


-- 
Pedro

