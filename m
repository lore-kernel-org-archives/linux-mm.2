Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F94C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 08:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071076B008C; Fri,  1 Aug 2025 04:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021BC6B00A5; Fri,  1 Aug 2025 04:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53196B00AA; Fri,  1 Aug 2025 04:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D30096B008C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:04:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66B225EFCC
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:04:17 +0000 (UTC)
X-FDA: 83727450954.07.EBC961F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 078931C0003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:04:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1rEoBOK2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WwmNjGIC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=t0gvoKhh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K6dLrwhA;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754035455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oikzn63/fOVVD7UWS2dDPKH8nm8rUvD3FPtyYMZjfb8=;
	b=H8MbW8eeVrZZJbrRebpQ9OeT3ZsZZnwLc01pV0v/05AVm86NAtxX1ZAgfGG50WDWqRLPYJ
	xwg6MxQBMvrTv9HQ7cSJQSh8n0Iv5DRLQ+rYTBrRwKob6scSkvh1vVhbxv3wZq3JqOY+WK
	OumQU+4uU6scyjn1S9TCTauFjGWdtqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754035455; a=rsa-sha256;
	cv=none;
	b=QTvZaN6mCEa1RzoOJqn0QCoyYiJdPNXusnweJDXfiXQXHzhXxoyS58uDDyQJ/Nm7sR5AcR
	pgamlJbS8YUsUYziUANYTHESc2alAAZynvvbdEXUBpfEyDa4MTh2zwilXQJqaGSRiKwDcZ
	IOQjZHFZpTZZEcy2GjyeHDpIOBjY6N8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1rEoBOK2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WwmNjGIC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=t0gvoKhh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K6dLrwhA;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 18E6621B96;
	Fri,  1 Aug 2025 08:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754035453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Oikzn63/fOVVD7UWS2dDPKH8nm8rUvD3FPtyYMZjfb8=;
	b=1rEoBOK2yE4nkvM9dJGzn94RCfChMiGzD4B28cKj5EwQD6uLuCWowb7E3+XXlvhqLjoy/5
	43IWu8GZwkynIDXe8oktT4IKMO1FL4lfGjH5ZoeyB/tjYsj7rrt6/9QDFh+wKLUfL5nw66
	I+QNOhsk3/qnZAww0HD3TXaqT36Hubc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754035453;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Oikzn63/fOVVD7UWS2dDPKH8nm8rUvD3FPtyYMZjfb8=;
	b=WwmNjGICF96penYCdc7fFO5AQ3FjsrO7A9D3pBFdXlE7mVkt7ENCgMd10HqyjRP2MMYcXc
	m+mjYJkhtmxjTlDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754035452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Oikzn63/fOVVD7UWS2dDPKH8nm8rUvD3FPtyYMZjfb8=;
	b=t0gvoKhhw2+PMOdlN2cbT6VLZixfx8Kv/D8XtXtJry2IkIKMaG5wVZCVP1B7bn1MTtwACj
	No1Sz6SEqwVocaeeCJtcEGw3ucA7TocdvbG7uyU/poKcLZ4PAZjGQcM+daQc6EEHbJ4Jut
	Xsvo1AXJTBQ88ejtORnI2vao6NpiLag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754035452;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Oikzn63/fOVVD7UWS2dDPKH8nm8rUvD3FPtyYMZjfb8=;
	b=K6dLrwhAkNY2qFNBfRwkTJG/RYtDpcH2N1xEOphIPMhbb7sshD1hwhD+ec7x4fru7jJQBW
	TBfZrrE+Eg5pvKBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E840F138A5;
	Fri,  1 Aug 2025 08:04:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZAgwN/t0jGgBHwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 01 Aug 2025 08:04:11 +0000
Message-ID: <20baf9ac-9328-4110-97f1-91e9e76b8914@suse.cz>
Date: Fri, 1 Aug 2025 10:04:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/testing/vma: Fix function parameter declarations
 for GCC 8.3 compatibility
To: WangYuli <wangyuli@uniontech.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 niecheng1@uniontech.com, guanwentao@uniontech.com,
 Jun Zhan <zhanjun@uniontech.com>, linux-kbuild@vger.kernel.org
References: <EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com>
 <e7554f93-03e8-4315-acb7-a55312354485@lucifer.local>
 <CB890ABC56C2FA67+56b95783-ed70-4744-9fc5-f2d93ddf2c12@uniontech.com>
 <37b606a7-17c6-4865-a78a-ddde1bc15649@lucifer.local>
 <d31803bb-fb32-4a94-aa89-83b02757d650@suse.cz>
 <12cba6b8-6853-477d-aa6d-23180c2fec75@lucifer.local>
 <671CE9DD76801AE4+34f3e3b7-4684-4fe2-80a9-93de1dde9c31@uniontech.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <671CE9DD76801AE4+34f3e3b7-4684-4fe2-80a9-93de1dde9c31@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 078931C0003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: hijz3xzxeh9k45utdwt9sts3qd88973a
X-HE-Tag: 1754035454-978855
X-HE-Meta: U2FsdGVkX19hcIID1MfWK+dRwcheFqZzzD2A8M4j1uqriEIdRl4SFTfXZfyJv5SCSvnR/O+gtKmWA4xVrSghWbHyqU2ASV82nbCWUfdtfT8/6bSDPg4p7VuYVQtHEtjcbN7cV2Cdfkk9STFJAzM/Q8PotLgPl2NmroGkX/bQUJXVyTBqjwemNmJ2wlw25g0aYud90TJ3FSwP28sPILW7U+9CHcHtrE+KQM6zuUJhx+Pj+YIqswwcKgh7Q4psEGF6aqVuvwv4EJX6MUNSeGt2xahby1zvwVFLhtIRb2Zn2lAY4EwgsIl4R+UptDSPqvxpcFQQO4M/NcnLESILGzV4pkUyb7NGcBFX5K/VPo4LycLhMNg8l0wzT8JVzPa3XtEjZSj40KWMSl4A7m/arv1kvSohZxhH/pY+kI7mHgvDZYzw/e5uFFFMfFphrXtAhAlvKE16oufeyImXY4HsHP6RYxVvLe0RGoXjQKN6B4uSlRTHhAGZE72r19YBTo8PBvrdBOTW/LEWp5mluJwRk/f973jS2NkeVD4r5UNpZE2yBwBsXOWaRX235Qmp/r5Zbie0IeLvimp+E5VWVaI8SMHv+39MRTOhL9nv9+C66Va5HlrQTYSwmqR4S6rwKsgE6vqT/WPNyqEsAqUDrSEetBvyaAq529QgwMSRcPSwxD9FDiU8hZ+M4AQCc9m9Hh8fuyo7CMsjWySibQqwzz/g+4/h7C3rcU0e7iaqFRILo5o7/1y7zOhl+8mEtoZSB/lqobOd83+IJi7agtjxOJwl8XtCF5fvTSlm+nuJearuvoyXHB48eeavINUik8N3OTpUws+UMCA2lk1kZofTGy/Pre0wRccf0a6fKt8j8zlTZ800Z4gDhAT5GcqTQv6b385e2DP7RZ/qZIS/HuoY6w7/S7X5sG3tubNFRyoChA+tkkxvX5XOIXl0dXhXWojN1JDbbPmLvOevOYVEhpHOijsdavv
 0gC9Blkl
 cQLUo4WAbLFkgI9rBWinD1nlFPkNRnJnm4yH/1hTSzXKKaU6RNRfTXQPXz6UR49xKsr49XfEu1sC1ZzqWkKaY/fcTJ/Eov9FFE3Tolsz2vEJRa4do8nOYYJ5QE/xO+4PRD7GguE3zIiu8MtOL33KDKJPSAewPyuXPrSA4BbaLTcbGjqVSCss4dlmPk2V3dqJONH1q/ELyBe7Fdnfgh6pAUTfOaq8B3TY0uPmfQqEdecQyQdexmyE3uvNk4gIbOU87WVc9hItz1Z5cAXsTGDFh+df2Fme9xUKaPpiaYqugpsKNET3OgA0CiWnaNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 07:57, WangYuli wrote:
> Hi all,
> 
> On 2025/8/1 13:14, Lorenzo Stoakes wrote:
>> WangYuli - could you check? If it's as simple as this, feel free to send a patch
>> making this change.
>>
>> Thanks, Lorenzo
>>
> It's not that simple, of course... That didn't work.

Yeah seems I can reproduce it with gcc-7.5 and it doesn't work.

I think there is a difference with the other instances of omitted names
found by grep as Lorenzo suggested earlier - those seem to all be
declarations. But here in vma_internal.h they are (empty) static inline
definitions.

Seems like newer gcc versions got more lenient. Haven't found why, but seems
they want it to stay like this:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113825

But I don't know if there's a way to make older gcc's lenient too.

> I'll take another look.
> 
> Thanks,
> 


