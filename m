Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518B9CD1297
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 19:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDF88E0003; Sun,  9 Nov 2025 14:11:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5A78E0002; Sun,  9 Nov 2025 14:11:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB798E0003; Sun,  9 Nov 2025 14:11:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 688548E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:11:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EA1812D5FC
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:11:14 +0000 (UTC)
X-FDA: 84092011668.26.8BCEE5E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 885B218001A
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:11:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Sjj8Tmj8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AIf/Vc1e";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Sjj8Tmj8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AIf/Vc1e";
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762715472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qX9lJAeqWuZ+tZhf9D+6OWeGPK1zBp473L1ubEGFTno=;
	b=lQm8zpcOVwUgEGc81y0PEBt/jsFuPrzNLF90pzkqoY9u2Hx/I7X2nx7fTwyqpfIpBI248F
	OG/v+UUIzDrIcPmpRtpL7SgydVlpsOCrAmPygAnTNO9+sKeZ97bSdg6tKus5QVE7TNQv2g
	2LZGUHS+hngjYyvraDC3PhNnP4OtWoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762715472; a=rsa-sha256;
	cv=none;
	b=KuQP41tIjFeBhXfdIesZL0jatYYoljYejQh63FZmP9d9N3n+mKfA8scCPMW2GkpMOgdmKN
	k/kXbElBpk5KYRFa51iy1wbuis3YjwcOuEBxnOJm0z9i/WMlLuJey4IWNDS3pZqQ9XlMGX
	YEfiShk24GRJrE5ZE3noC3sDF8AFe3I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Sjj8Tmj8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AIf/Vc1e";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Sjj8Tmj8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AIf/Vc1e";
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C304622B75;
	Sun,  9 Nov 2025 19:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762715469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qX9lJAeqWuZ+tZhf9D+6OWeGPK1zBp473L1ubEGFTno=;
	b=Sjj8Tmj8te78EcciPx4vbEFIaaUYrlCsTNtCM7lpeMmq/UkH9LUMD2IRGUDK5ViIZx/qrw
	OhU6yjzIi49h2Mzz8VvDLXRxNDdz6PGRzytxL5Oek0QzdHqPtVJqcfNuRG1V4+ALGrJ4NU
	tBjY+5hv1ruMaxKOiNSTkoSvfbIjZdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762715469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qX9lJAeqWuZ+tZhf9D+6OWeGPK1zBp473L1ubEGFTno=;
	b=AIf/Vc1eF+LE48PBOj4Ivn9c86r5GC6pqubLqgzOfWXwF20vYgoBaETOO08B/RcdT9CkXl
	wI1aG0oFTDdHS0CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762715469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qX9lJAeqWuZ+tZhf9D+6OWeGPK1zBp473L1ubEGFTno=;
	b=Sjj8Tmj8te78EcciPx4vbEFIaaUYrlCsTNtCM7lpeMmq/UkH9LUMD2IRGUDK5ViIZx/qrw
	OhU6yjzIi49h2Mzz8VvDLXRxNDdz6PGRzytxL5Oek0QzdHqPtVJqcfNuRG1V4+ALGrJ4NU
	tBjY+5hv1ruMaxKOiNSTkoSvfbIjZdY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762715469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qX9lJAeqWuZ+tZhf9D+6OWeGPK1zBp473L1ubEGFTno=;
	b=AIf/Vc1eF+LE48PBOj4Ivn9c86r5GC6pqubLqgzOfWXwF20vYgoBaETOO08B/RcdT9CkXl
	wI1aG0oFTDdHS0CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F9D7140AC;
	Sun,  9 Nov 2025 19:11:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RoarJU3nEGlMWAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sun, 09 Nov 2025 19:11:09 +0000
Message-ID: <a7034e0c-a2ab-425a-8472-ef0a87a17681@suse.cz>
Date: Sun, 9 Nov 2025 20:11:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftest/mm: fix pointer comparison in mremap_test
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
 <fc051006-5cb2-49e1-bb27-7839837439cd@kernel.org> <aQyOZ6eYng-IjxS_@fedora>
 <6e07949b-d86f-46d8-a68c-9717cfb26084@kernel.org>
 <20251107160855.58891ac6df6854a3b608185f@linux-foundation.org>
 <aRA6lEQmmrvmj2DX@kernel.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aRA6lEQmmrvmj2DX@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 885B218001A
X-Stat-Signature: okttx3nf6ex8mmo1tqh5o7hr9nh4kgmy
X-HE-Tag: 1762715471-217201
X-HE-Meta: U2FsdGVkX18YH4en6/lxKHccLm43FwfrZ/90IdjJuCgsdQ9ttO+X5gryHzWIG+2nXrk9ZNjAPKwgUwOZgwHKuo5dMnbJhNfzK56Xz12hhCxA5FtThOFRMU8Lg50Fe3OBwUbSG2/EjSXUbDcsgf8q4BSyZ55Hy1F92gj92EBg+F7hph3vOyAWuoDT3fbUk6Q+6wbgdMHPdkwNsz26e6qIGC2FkjaXIM0ch3nvYrwzroPJC4in2YB0tjE1mJCuR0EoObgU1iFfViLdsUtsgWAbkOW6Zx2bik4FgTr/KB67sGSO4edPfCZj/ozau+Dc/r/4DqNsqLk58q/484AmOh6gPJ1njRFtwcCxervXFssWesk8s2Hc1lu9vmCrE70dpptWSPHwjP4c/6Z0BSB3OBwZvh2iu/10fcsh22OwAKuoIJDxri6F9sUERzC6KJT8h2BOAs8Qot9Oxc3KFjyhkcfIyuK3wF1juJl+OHREnyWLdHdt0TxdJXchRG+qj7R8ZXeu2/fpr3do8qncSqp0s2MTwr21SD5FY7kkMQ1Ib8HTE0MUPC0cs21gIlDEREBXbJ5lKM9j4a2Czrvi8hXmuFk6J2p2mOxPRVMqOgCxOw4kA9oZvlg0fV8JRVOOrIe0lg3eQoyNfxtUTXZ4w+y/gQDr0zmmQOCDSUAg0oS31hk6ygEejH+lwQesVkVJOIlYr7PmD//adH4+3rrf7DqxjcaWJ6wdsrYtm8Bvfd1VrOr/+l85KKTcuRfnOp93TRmq81HJikUGplQn+J4proSrDnUbrfJam80eiZPU+Q5SD4lZ5zzJDcTiBxLxOn4nVmkooodpT00S1tRGns6OK5wENS5wmZ9901dIHIDQ3jp1s9ARjwbyASSRLT4qmg8TxIgTJnXqlR6JJyrcHOVI8fMvv/z8gczNHJX74yJ9RkTz9A9GV6ed6AJWcuFB+m/YTaUIB5QXX0QWLqMN+YG0IFa1AMm
 4JZc8/Ln
 8ToVrLsMudfRmfVdFW+5XnH1he+0otSgoN6aWQ5lsJFi1MdKvbIOgktCWc49MC7EeF8cJ8o9gO1DNmViOsPuKHHn9HHnDnI74t7MzarXrJ5EAdqNQ1NLn3Z/8OM/g3UqScCfDC+sefdhX3YjG0/UxUSGjfQRASnUExlN4sJjNKJfVDSXA3ds23gQlUUGrKHnXKNazniRukMOC23P+SIUzvCLnAeiJKCpx13okFE7RLJ53hbj3gX/s9ct6n1FvUvqASrfEYq94LM3xn7Iaw04yb0kiMMo4ETujJLIIXpTg2Ut7hZd8+cRewXDYBzl2FU4F/X75VOy3E3A54dHq1VRZgBZURnYEkTWD43x+iNsxWMB6A9ziGETqNKYWfWxI1ddv3GilY5vBtZD30QSerUTxX3tEBvKWd++srC6yCVFc8n7CMvI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/9/25 07:54, Mike Rapoport wrote:
> (added Nathan for clang advice)
> 
> On Fri, Nov 07, 2025 at 04:08:55PM -0800, Andrew Morton wrote:
>> On Fri, 7 Nov 2025 10:27:27 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
>> 
>> > On 06.11.25 13:02, Ankit Khushwaha wrote:
>> > > On Thu, Nov 06, 2025 at 12:18:57PM +0100, David Hildenbrand (Red Hat) wrote:
>> > >> On 06.11.25 11:49, Ankit Khushwaha wrote:
>> > >>> Pointer arthemitic with 'void * addr' and 'unsigned long long dest_alignment'
>> > >>> triggers following warning:
>> > >>>
>> > >>> mremap_test.c:1035:31: warning: pointer comparison always evaluates to
>> > >>> false [-Wtautological-compare]
>> > >>>    1035 |                 if (addr + c.dest_alignment < addr) {
>> > >>>         |                                             ^
>> > >>>
>> > >>> typecasting 'addr' to 'unsigned long long' to fix pointer comparison.
>> > >>
>> > >> With which compiler are you seeing this?
>> > > 
>> > > Hi David,
>> > > 
>> > > clang version 20.1.8 (Fedora 20.1.8-4.fc42) raised this warning.
>> > > 
>> > > To reproduce:
>> > > 	make -C tools/testing/selftests/mm CC=clang
>> > 
>> > Thanks, and thanks to Lorenzo for the details.
>> > 
>> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> 
>> I must say, applying this would be an unhappy life event.
>> 
>> 	if (void* + ulong < void*)
>> 
>> makes perfect sense in a world which permits void* arithmetic (ie,
>> ours).  So what the heck is clang doing??

My (not very informed) guess would be something about undefined behavior
because pointer arithmetic is strictly speaking only valid within an array,
so void* + ulong is also still in the same array, and thus can't become
smaller by an overflow, because overflow can't happen if we're still within
the same valid array...

But I don't know if this strictness is only applied to the warning itself or
to the actual compilation too (does it eliminate everything as dead code then?)

>> If we do
>> 
>> 	void *addr2 = addr + c.dest_alignment;
>> 	if (addr2 < addr)
>> 		...
>> 
>> then which statement warns, and why?

As the answer was that nothing warns, I'd think it just isn't able to warn
if it's no longer part of the same statement. Whether it also means it's not
eliminated as dead code anymore, dunno.


