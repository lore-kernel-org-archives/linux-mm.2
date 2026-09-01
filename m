Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C54C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252D96B00CB; Tue,  1 Sep 2026 10:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A0F6B00D0; Tue,  1 Sep 2026 10:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1404E6B00D8; Tue,  1 Sep 2026 10:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E86426B00CB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:45:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 743F714041A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:45:02 +0000 (UTC)
X-FDA: 85165465644.09.B9C1BEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id DBCBC1C0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:45:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JbQsYQQT;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAIsm/HteRf3YKYFv2nKHjUIchlu3eaENoAxwWG8aEY=;
	b=Bz8YeinVM/5IpZ+HjN8u92NUffrOT5e3aWxWEBzV6qahaJXMTw+qvsr5mGGHrzOTsKUimJ
	YoD9PHmWGTfoT0dTyc5vKDD5RAipOQVNZFeJfaFgbUZqm+6Z1lIbbiPRvaSWbJIYglZKiC
	CwRYF5T/OWPPxhyi+3k+1vc/MoiCBN0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273900;
	b=HCUg7SWJ8vcU+vb0FocpAPWV2Id7QUAYPowP4tBAQpjwQ1Q69ToK7Oca7fgexyaWdYv+RH
	9DZICGy1YnXg7mMe8w4/weofJTZnyx+HewN4g5d17wMYmI+I4l/GtykTHjsMg/3sMKazqC
	hB66T1dkk6ZglaOY8GBCbJKfflrL7Uw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JbQsYQQT;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FDE6602C2;
	Tue,  1 Sep 2026 14:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D871F000E9;
	Tue,  1 Sep 2026 14:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788273899;
	bh=fAIsm/HteRf3YKYFv2nKHjUIchlu3eaENoAxwWG8aEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JbQsYQQTryTJccngjQ6sMGW5kFfCavhUFjLzV4MjqkHi+BCzDmSYL5sVMBrrEt8h6
	 ktgB1GV43LZv/WsX/Cvn1eGJsTE9h2i0ss//1pzBa8nQq1CuANiviKerSRkcVhQ368
	 rVsBLyMjr6sQfWasTsIczZFZPpDR0E3U3SjQOi98KqMhYvzEWFqzVAw9aN7vDSnLRS
	 pgLTqQXL/riVvYdkKcamGBovzkNxn9/95svzBrkDubdasz4HNTM3W9B/ZIb/xeIBIb
	 jut2js8skF45pnqjTJ/o6Vr4ukAjg6/C6XVq9xmOMilcFlaTnMQn19gUcg6KHB5gPx
	 PbkOK5Iq8sWoA==
Date: Tue, 1 Sep 2026 15:44:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hajime Tazaki <thehajime@gmail.com>, david@kernel.org, 
	linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, akpm@linux-foundation.org, 
	luto@amacapital.net, brendan.jackman@linux.dev, liuhangbin@gmail.com, corbet@lwn.net, 
	kees@kernel.org, broonie@kernel.org, mhocko@suse.com, rppt@kernel.org, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, wad@chromium.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, 
	geert@linux-m68k.org, daniel@thingy.jp
Subject: Re: [PATCH v2 0/2] support kselftest on nommu platform
Message-ID: <apbknMd-vv6jliZu@gremlin>
References: <20260825015945.141739-1-thehajime@gmail.com>
 <f2ac9432-4fea-4007-aab0-ad80597b284c@kernel.org>
 <ao2Tl9CLL7WjHYun@gremlin>
 <bb9a3add-4849-4928-8b6a-0afc0c73b112@kernel.org>
 <ao2l9Ao7BQI6uRKC@gremlin>
 <m2y0dsuf1d.wl-thehajime@gmail.com>
 <ao_541nBaa3SJS9F@gremlin>
 <m2v78wueir.wl-thehajime@gmail.com>
 <apAgQJ5p8LEDj1c5@gremlin>
 <40e95edb8dafd88fd13c3003c0e76df6a2f124d9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40e95edb8dafd88fd13c3003c0e76df6a2f124d9.camel@sipsolutions.net>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DBCBC1C0008
X-Stat-Signature: 61dn3qrp5ktc7qzruyaj8gqpio15p393
X-HE-Tag: 1788273900-981593
X-HE-Meta: U2FsdGVkX183w/iPEkDxHDltF5j0Pah4gu3sbKxPru6KjrqsYpKV4g94ovol+eg+plvh7RBgFB65McEw9aUY9wxEiLntiRnYzh7hrSqycZJZKCoH9w0ad2NrxffC+N8yfWY43Qwmkb/aUOi/ggqY/RDLkmznC9rA7Xs09ecKKXtV4S+VZJsJOn6mKnkqwz2IOluCK2qL7368y+kA1xutuuKFhHOv3UI+bubF/IFTaWIWESiMDJL+dGf1G2tidxqYNDqRI3hlqxJjJW78iPrtg7f6ZGywmmzVWTZVstRdb1NwpnyvDE9Da7nN/wd1kVOeeSg0gUYjjRmkbSw7LtDJed938PWgLxW93za6di3+Mwh8RGQps7t2i+4ZPiDr4gQAbpD5SQEnA1TljEQtRDQ+x8Hi8OyuL8V2LJ8UYKcZo/dBLBZgB5LE/w/d/msEYJHQ/li89BI6JKacfRM6cUJsUBXaWK2cfwf1U4MCdKsXupAPQZOgFL/2cAIRkle9lLAiT4XxTtoxathq11mNvFbxqHS3btr69xa2OtJFuExkl5N1S46Va//5scqRghHRHMlfzGxxZ/EkE0/kmgqZMAdSpCKIBMx7tWAwRJeXgWNfcXdsj1+4z3SfpSJkvHqjdS3/KFDSGGF2D5fGia+v+YvjCuisrCNqnlx3rRHSYEkOBt8d9j9qNF4AfacO6RsOHf/SYx1HF8zAQPfeqGZslmkp5Y82m5vG6fx75GXm+R3r9Zq+oHOJNzv1xXQwhTsrIEggL1GhOJ4l3/DDNUFwX0jEw+EYczHMYzwHQssFVmxkLzEQus8gKEHqsvT9IwipS7kcI7vumQjvpkCwTVxakmjg1QJ08rUxWeN0uncLOaMtP+HJ+xrwSX5l1E3Lvp1Jb6tSfEg0fpK6GCfoPaA/bphbBw1JpI9IAAIvejfQytKe4EzfXVsuj/3Df7UXHi8MGSHzA4TWfB3iYJAqW7SWN/T
 0HnDV7PR
 Kle3ighPKDb0s/r/HB/NK1ixihVqyHikSRdW1FB7zTfFB7up7p6wIR299LPX/1fA9TyBtfqozCM0yPVmVw9I3y4BVr7GWBEx78rnEPIVcVwZn1yth+bY9dfQPkJQXDPSDYUG6vszcXs26qh2GJnBeXnKDVSkwjhiWNu3UxIxzGDe1DkuHLP2m//SSjm9STLKuhbK95hfgolmUuIIcapV3WG/TKVt+TkhsOrFSYpwhPV/pWZ7/zvF88B2heIWCcC9wH0WCORell2aizv7lr59jYyrSgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 04:28:49PM +0200, Johannes Berg wrote:
> On Thu, 2026-08-27 at 12:32 +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > Ah ok cool, thanks! Is that headed to 7.3 or more like 7.4?
>
> Seems everyone was on vacation (I just got back) so I believe it missed
> 7.3 since -rc1 is just out.

Ah damn! But understood.

>
> I hope to have enough time in this development period to the merge
> window to figure out all of these things and get stuff merged - UM

Ah that'd  be great!

> wasn't on my priority list with all the (LLM) security(-ish) stuff going
> on in wireless.

Yeah entirely understandable, I think we're all being pummelled by AI
lately :)

>
> johannes

--
Cheers, Lorenzo

