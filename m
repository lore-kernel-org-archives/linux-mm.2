Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78186CA0EE9
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 18:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09EB46B02C5; Sat, 16 Aug 2025 14:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FA76B02CA; Sat, 16 Aug 2025 14:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32AA6B02CC; Sat, 16 Aug 2025 14:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD1176B02C5
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:31:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AAFB1DD80A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 18:31:45 +0000 (UTC)
X-FDA: 83783464170.23.48A7290
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id E367540008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 18:31:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a67ON98K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="kiip+/on";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bKVvBBTY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f93zNYiR;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755369103; a=rsa-sha256;
	cv=none;
	b=3j/u2V+X1aVhv7QBTqqpR/n8zK5DuAwZpE0ei1T/jwUF4UqGKzM9dX7CzIj/FovuGO+2MC
	W4U2IgMhPsFSJv5+Y1sBQX3ZxutgkovlEwAA+Mld4qV1YcRwny3phIE771utr+n2EMVOcR
	FLqaPpFazkSnaY2O0jCH77aVn19FgWY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a67ON98K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="kiip+/on";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bKVvBBTY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f93zNYiR;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755369103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZ3PzzQW4uU5pO1+Nv8StLCU9Y2RLWdIj4dVek3lkDI=;
	b=WGaKkYApw0skvFFdj/osrlljQNJZ40le3aPE8mP49TNljN4TeEVsY61ZjUJPYAnZ5X4p1Q
	9QIyVwnyZ3H6RLZiJPyiEAUTBJQT5k9li1ybMmeKlcisNX6+63wLSEiyBuQbhMFEfzn+0+
	YlJt0ZpUl9Abl86cbW9S/nla4RaX1ZQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F0613218A2;
	Sat, 16 Aug 2025 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1755369101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZ3PzzQW4uU5pO1+Nv8StLCU9Y2RLWdIj4dVek3lkDI=;
	b=a67ON98KsieZnR/spc10Co8TpfbvY3xcYpL8D2IEq/J1Gyl+7pejh9tT6uPZLa8zA30bKW
	GAnBLDQZW1WWFtCPhNJCKERpc/zSWDdIjpdD+LvMUeKWmfLEYzoWV2DuwDzmNSlctd+Yc3
	oLUzEHam25aon1K7Ry2NmftuNCvMdvQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1755369101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZ3PzzQW4uU5pO1+Nv8StLCU9Y2RLWdIj4dVek3lkDI=;
	b=kiip+/on8sp6CwHWeBqziZ4ozj58C4JBiB/8t7IZn2JxYTGXh6BpG0z7cUW2A0Ua8djjWc
	wj7AW7OtMvc0M1Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1755369100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZ3PzzQW4uU5pO1+Nv8StLCU9Y2RLWdIj4dVek3lkDI=;
	b=bKVvBBTYYLXnsNrbclQiGjxZ3ubzGm9CanfHWACJkm7FavAwLfUMFpl8Ew3rYSc1HwWvl4
	laEm0Q6xqT15DLksm0Va/baEjWoPVOez0gXvnJIhjmkyo3gepp5mEyP44XYWg440X4QC5K
	Lli6ht6CzzwXAj9cU8tnnwzCUbSBWe0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1755369100;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZ3PzzQW4uU5pO1+Nv8StLCU9Y2RLWdIj4dVek3lkDI=;
	b=f93zNYiR2qbUNvmFmi3gy8tpI5JmBwwIPaCI2QFZnL3PZ+PCGoBGzToZigb3ypIj1yvGTG
	WL/pYKM1BwMiP7BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 72EAA13432;
	Sat, 16 Aug 2025 18:31:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LqE2GozOoGgqCAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sat, 16 Aug 2025 18:31:40 +0000
Message-ID: <22666e86-2523-4136-94e6-0de126fcec1e@suse.cz>
Date: Sat, 16 Aug 2025 20:33:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/14] SLUB percpu sheaves
From: Vlastimil Babka <vbabka@suse.cz>
To: Sudarsan Mahendran <sudarsanm@google.com>,
 Harry Yoo <harry.yoo@oracle.com>
Cc: Liam.Howlett@oracle.com, cl@gentwo.org, howlett@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 maple-tree@lists.infradead.org, rcu@vger.kernel.org, rientjes@google.com,
 roman.gushchin@linux.dev, surenb@google.com, urezki@gmail.com,
 Greg Thelen <gthelen@google.com>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250815225259.3012455-2-sudarsanm@google.com> <aKA7180s0HdLfOKc@harry>
 <CAA9mObAiQbAYvzhW---VoqDA6Zsb152p5ePMvbco0xgwyvaB2Q@mail.gmail.com>
 <498fc518-d78a-43a4-9196-507891e9b844@suse.cz>
Content-Language: en-US
In-Reply-To: <498fc518-d78a-43a4-9196-507891e9b844@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E367540008
X-Stat-Signature: symnq8t7nudkruu9ep3ucpb4t45ht1ox
X-HE-Tag: 1755369102-760345
X-HE-Meta: U2FsdGVkX18yub47NbqYAroXcwrpQuecOV4C+Fs8egWu1aR8B6kwzVhnm0+hnpsvOB3ilVElXyesREn8Ww0xql9zUAeJ3QYssqNsEVRAVZilCb2Up5CH+ZYJaaB0YrwNj6jJW8k6/xsGi8apzwFJrNpAUtUDD+OuMoXZWJvqr3MPTHcHoaXHxKYCF+Tu2duBsg8UX323oP741Bo8c7LUZR4lnuMg2K2sgIILGD5RjV5h01CNQ92YcwLmAcIq5VUElApX0NSN6vB+5BiB9/EkAlnWigv8UQIzuwgDLhDzH2tJuxiuRs5J8Y3GCgC7mZZu/ZKmXFHi0InC/4+YbmylqJejLjfiMvQkTYQvGWVHl5dI/yXbTir/+XtwUa+Bnp8l/LqIfXl9PJ+Ufx4LdKoR8HxEpL+jV/5OLcuefe3FtWjEHBCKMpn8g19zSrfddX13dCfMMMaYYjG1F0Ecd1K8VXXKwtRQ3W3zhJloHswBhA6xKz8zsIseBnlocgxe6z1owgm/dNbVWE1PM2MwdvAgklFjh8fH3vKjT0Y+qF+9TgwCbuS9dSGnT3tzKNAXcAlq1tTka6g/CUKc8W6GilE68XG9AzjuZDpObQPq7woxcv5PPciUU/5UMp3qL7zMwjvqaL4LJHKDpjT3E0D63NPHmg49HF1Qns73bkcN2Dlp0K9VXeuDBiR5Lzsde9FGkf2NuipLF/hzEtXq4UjkvVRY8s4Rwm3tm1tln3bAkg2fGriqutOqaTY0ZVAbfSgwi9AzLMbn4P9Pd48tBmprJhIaqvN5HY5W8lVDO3D3D4ILiedmyy+2htvv0ELAK8sRRBggTPN9N9Yl3Z6q8kbIk0IufMajh3yg2p6u1Hb/YEOHCahuBc4F9QGLLltCn0KBqmgFSrrbXk329UmpGH+5umlvXsS8BdwoJRdSVRnjTIMKEoM6f+OIk5Ni0SHCzYQ/O15ZgwzrcCqbvsJRVnvLrqa
 hIqc5I/N
 EvFmf3+fXtye3uAGbO+G3Re0bAmqLGcxbVQLtdvruU0H6wiKhYrU4e53vTIHSvBrpyqxDOwT+gI4Mu7lknL2Cc3xX5yV1UBJXaMlZXmFJ2O62vhGiJ5INI3MuaknmxfURPWuAkFfQm9mKB/2nqTSjXl08dgs2HaUjtYqvyX8OSoJZ4LdJQ80guDNLiyHLJ3zwdXS4OuxxQhdCQYZ2yiw5ekT1sANcuTsWiAPm+qxn0GXAbG21gfFLFM8CSgtmTWhi6dPx1bvBFnpack64JT0DMa6N6QdOQ+al2PZvcVfjKBZJGvmjHVyff+uo/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/16/25 8:31 PM, Vlastimil Babka wrote:
>>
>> I assume somehow the free_to_pcs_bulk() fallback case is taken, thus
>> calling __kmem_cache_free_bulk(), which calls free_to_pcs_bulk() ad nauseam.
> Could it be a rebase gone wrong? Mine to 6.17-rc1 is here (but untested)
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/

This branch specifically
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/slub-percpu-sheaves

