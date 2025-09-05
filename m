Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92242CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 06:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D443E8E0002; Fri,  5 Sep 2025 02:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4BC8E0001; Fri,  5 Sep 2025 02:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD548E0002; Fri,  5 Sep 2025 02:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A916F8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:58:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51985140578
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:58:06 +0000 (UTC)
X-FDA: 83854292172.22.2B40028
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 243B9C000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:58:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y8z22so3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0IzuDVqN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y8z22so3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0IzuDVqN;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757055484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvK9ixWwRei4oCEeYPKW9uWdDzojNqzJFZHBSy8S3W0=;
	b=oLqjyytGPxxIq1Av5iPhja9JxTkPyJLozwcSDfThyqLiv2nS+Tu+XI6ivj844ENpVG2RAm
	2l1MbAvSI6vSzXTjEAW5IjSAzZy6fbRgjnfIVbKP25Y4pBe2dEeLazHd9E8EmUIwLNG6QO
	dbwmYBDRfHaasiu1wAAF4GTz1mbgcOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757055484; a=rsa-sha256;
	cv=none;
	b=lXdNuOoXzEhtqxG7QYHyqrNBrVOMEZKBAK6khGivQzDQoeIoB6hhbGG6OBwCc4KoAudqph
	35Z6aO5p+LpDQEL32qmzYwd3LkeWSbbY0MiD5AAuEWCZbGaFFQukSLAzFsNrz9srSicD6y
	dgRhI73U4uNU232c9CmFsqiq2INvEuo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y8z22so3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0IzuDVqN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y8z22so3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0IzuDVqN;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C60F76F71;
	Fri,  5 Sep 2025 06:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757055481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TvK9ixWwRei4oCEeYPKW9uWdDzojNqzJFZHBSy8S3W0=;
	b=y8z22so3t/LCPlVSsXuM4LY9tNaUh5bXHnsvWbMk+++SMpnxNiV0jh2PkM2xRdiMVVgWRM
	fjhdyHbrnbswMmoOgZvWmod1KYfcJ/MLcbWyfDyK3ch+XjDanm19thfdhk7SjBnIhZ15qi
	7C+UfHVOwxuAdwpPrQnvCMGXZgFz1ao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757055481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TvK9ixWwRei4oCEeYPKW9uWdDzojNqzJFZHBSy8S3W0=;
	b=0IzuDVqN9K4MgCv9kAMVpxGhM7rgfTOsV+giY2sHFmdIG9TPjv/zYxUsoJDU0jsQkdE0FW
	3nwow3eMQLvoKpAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757055481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TvK9ixWwRei4oCEeYPKW9uWdDzojNqzJFZHBSy8S3W0=;
	b=y8z22so3t/LCPlVSsXuM4LY9tNaUh5bXHnsvWbMk+++SMpnxNiV0jh2PkM2xRdiMVVgWRM
	fjhdyHbrnbswMmoOgZvWmod1KYfcJ/MLcbWyfDyK3ch+XjDanm19thfdhk7SjBnIhZ15qi
	7C+UfHVOwxuAdwpPrQnvCMGXZgFz1ao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757055481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TvK9ixWwRei4oCEeYPKW9uWdDzojNqzJFZHBSy8S3W0=;
	b=0IzuDVqN9K4MgCv9kAMVpxGhM7rgfTOsV+giY2sHFmdIG9TPjv/zYxUsoJDU0jsQkdE0FW
	3nwow3eMQLvoKpAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB2CE139B9;
	Fri,  5 Sep 2025 06:58:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Rh+/OPiJumggfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 05 Sep 2025 06:58:00 +0000
Message-ID: <c0b9d34e-1a21-4a97-b898-c33f7c8b49dd@suse.cz>
Date: Fri, 5 Sep 2025 08:58:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] rust: zpool: add abstraction for zpool drivers
To: Vitaly Wool <vitaly.wool@konsulko.se>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: rust-for-linux <rust-for-linux@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250826124454.GA1502@cmpxchg.org>
 <CB3E7E9C-2192-4C60-B79A-932AD6CB005A@konsulko.se>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CB3E7E9C-2192-4C60-B79A-932AD6CB005A@konsulko.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 243B9C000D
X-Stat-Signature: 4j76qf7w5dhxj9fqkytz8numw4w5sedt
X-Rspam-User: 
X-HE-Tag: 1757055482-968963
X-HE-Meta: U2FsdGVkX18SEYWjqlKicKnmg8Gq15598yw9bWAypzu9kszj/4AwNrEpqY9QXDBgwf+GaL8ZvOwqWfUzuiadfGpkvUe2BphhFy6Ge9Ik2GSdg0XhM9MsGoNarSn+iC3JFWuM65E9oDe/gnbsGzmf/olFiPKgPbEYWGF/iLAJW4uyZNYBOIh65Ss+JqShVMdonxbMAl8ysVyMJ1EVBuZl2PzLsanqvLE//rmG+7v31q8RXexb1j2nQBGgvOriLdKrLlOZx2eVayYel7Z7KP6xPM+cqlrYrdLbWQMJe7EpxyUb8TldcI1Xkqx/01Q0ZfpaQT76GhPSFjGJS4oi2xnb/6x+KSe2lXPRa6A6GL9FGykogjV3vpiRzAtDdESnxE8SU7Dfep9TKM/SSnG3dmC0PYsJVcHDUJjZ4pFTdaGyCpZzO9/GwaIfuobRyFbEp1MDiHRjY6YRVELpZ3d5LnH5yW5BSw8y0NJoU6VB2tW0XmpYGSAuyFb/P55ydS2F4JqE/vd2QiZa3Ew5bo20tlO7BHz3wUDQ/UbRNFfy+rHnbvyM50hRkdANh8QITXkKaufF3t9dg27T+RRa7OYDdp2HQj+FDOuAFbvcTvW1YDYXtTZPmaygrHZ02CWakGyiuCmHA038MkR9XkbgEzMr079vYJeR8nisWETmQmQ7DMmTbNBMK4amDZ6twjr+KZQEP2/P4ZILLQeHlIVgDnL9RtPDP0GiKussm6uJTTJoM7envxsU07mjLGSswVq5n9eo4L/xvJ1YqGJhBT0QczDZlc74uOv7Bo64A8ZxIhUf6fMdcseNdCC7/bmgHBVm9Ujfb8gOXjqs92XVPitx1lAtK0wUBg2oVeS1e/zAgphcwrhnQrimUUVjVLRTjQNFxZH8r2jkkzAUMSNjXkO9RywgYwoEqkH6IIhGAZ2kirDqaoJIZMkrrAmGPJD63shitQrNhW24GRzFaMCBhZ/iKEhzuSM
 fL99dS4b
 k5xLamtbgKIgd3SmGV9cT1Tt0x6hPRZe2EyK1ZUwYaoJfUgXKLnULELnIE/KD1dG5dQu0i+bLOXimuKHFhW/Igv7kUIo2v7TCj0LAQ+mtMFrutmSwXwLmYjmIkCJyoKliqjDbuYR1X1B8JhlyWOgmgJYBJu82QYtMF0IH8viFa0uoRF2Q1tRBVwv5trC71x6jYXIwdvvz/78y+68lNlxFWCU/j7blJsEdMlzNn33W3k+0UoQw6ZXGLJOOeR4HXef7nxsxOozqxyITdFcPAA4X8fbHCGmxI6OJaIJRTz4HD1V99SwSq74SvwVxzO1F2Y6hOga6u3hipio/ZKV7weBM2khCIUbk5WEFJfLlZuW0BaOIHP7WvxWPoY+NTM5WYjFPKteX8WHVIQs8vYK1PWNsFc71sbhyukOZqwriDEZyK17KVj+sFl13msHO5WINUrfhrRLN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/25 16:56, Vitaly Wool wrote:
> 
> 
>> On Aug 26, 2025, at 2:44 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> 
>> On Sat, Aug 23, 2025 at 03:04:19PM +0200, Vitaly Wool wrote:
>>> Zpool is a common frontend for memory storage pool implementations.
>>> These pools are typically used to store compressed memory objects,
>>> e. g. for Zswap, the lightweight compressed cache for swap pages.
>>> 
>>> This patch provides the interface to use Zpool in Rust kernel code,
>>> thus enabling Rust implementations of Zpool allocators for Zswap.
>> 
>> The zpool indirection is on its way out.
>> 
>> When you submitted an alternate allocator backend recently, the
>> resounding feedback from the zswap maintainers was that improvements
>> should happen to zsmalloc incrementally. It is a lot of code and has a
>> lot of features that go beyond allocation strategy. We do not want to
>> fork it and fragment this space again with niche, incomplete backends.
>> 
>> It's frustrating that you not only ignored this, but then went ahead
>> and made other people invest their time and effort into this as well.
>> 
> 
> I don’t think we have a consensus on that.
> 
> And zblock is, after some additional improvements, just better than
> zsmalloc in all meaningful aspects, let alone the simplicity. It is fas
> easier to implement in Rust than zsmalloc, too. Besides, zram is a good
> candidate to be rewritten in Rust as well and after that is done, zblock

If your target is zram (not zswap) then I don't understand why insist on the
zpool layer, as zram refused to adopt it in the first place?

> will be even safer and faster. So while not being “incomplete", it’s
> zsmalloc that is becoming a niche backend moving forward, and I would
> argue that it could make more sense to eventually obsolete *it* rather
> than the zpool API.
> 
> ~Vitaly


