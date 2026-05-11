Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D2F8CD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD1C6B00AB; Mon, 11 May 2026 08:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6947F6B00C9; Mon, 11 May 2026 08:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D27E6B00CA; Mon, 11 May 2026 08:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6406B00AB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:07:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 178BDC25A1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:07:52 +0000 (UTC)
X-FDA: 84755015184.20.3A48E9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6C416180008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:07:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ibjbkZwF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778501270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whKehlyErx//MJZBNb+OJ0TXeLoZXHCzVwS/V503eQI=;
	b=HS3Jl8ngbpbOO5a09Yrf+LV69X/w/wK3GoF6nqeoP61ROgY+XVVu5vm0j6IzrYkDSfRNik
	zwtd+Dks7vkEVPKQLX+NuqWFMWAct9PfsRaK+TUwiY6vTXWSal4R9d9355wIvkMhlgvmJI
	3AXkh/aktS2n3t0PRBAsPPVhjg5fqGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778501270; a=rsa-sha256;
	cv=none;
	b=RkyS6J1hhmD9pO/lY04qupm53nArpfqqdK5Stt7TqNM6x2wzi5OoIxAeDbiWvi3lqE0aRl
	wW3ylj8agjURtVNNekyUZH0AHLh0ZnCCuGeClB8em0szjZ+tOV7ocVFmSvZgVQJucYSBv7
	8wdsgYu/sED2NYjHQYAeuVY1/hWCj2M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ibjbkZwF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7A0A60120;
	Mon, 11 May 2026 12:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A12C2BCB0;
	Mon, 11 May 2026 12:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778501269;
	bh=XJZrn11TDzQfh5nANwCT6M8kUFD6U0DGy379pNKKf8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ibjbkZwF2wXnJAldnE6kmyyqGGSID2Bc9jjAZ7CmPnbHIpPK9V5MhJnkkssrsla5M
	 TCEnI1WgfWvVs/1fjjPQ7XcqEoTa/hK5QEXzZpxjHsrfJdUtL80tdnk9GPBLcaNNUh
	 Dz1VrECQFTWep3M2pb7EfDNqTCG/s4CaVghUsLmw3JrSmqNDgUIPL5j7Lpyfp7m8YW
	 q6DoQtrE/id+udKogPXf4b1Yyf3etERPPuZRYII2z4tRvKYkHMhIVv2JaD3xRIUH9X
	 LytFu1InWXDWc50X86CajW1gTwTUSZ2HboiZXGVlEjmld61KcI4RsqaNjC9EwSIS/6
	 KIIoWzhQRPkuA==
Message-ID: <8354c3ee-85c0-4765-a114-20f350ae6e65@kernel.org>
Date: Mon, 11 May 2026 14:07:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] slab: fix kernel-docs for mm-api
To: Marco Elver <elver@google.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
 llvm@lists.linux.dev, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <20260424132427.2703076-1-elver@google.com>
 <20260424132427.2703076-2-elver@google.com>
 <9c321184-9080-4d5c-bd1a-a16cd0bbaed3@kernel.org>
 <CANpmjNN_=g31Eoa+w1NrFALfp1dDBi5oHEZdr_bA_48-tS2M=Q@mail.gmail.com>
 <afi0nQ84k1oz5RyH@elver.google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <afi0nQ84k1oz5RyH@elver.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C416180008
X-Stat-Signature: qmouae9kwf456twsq3wengyqd5yz1b9s
X-Rspam-User: 
X-HE-Tag: 1778501270-2825
X-HE-Meta: U2FsdGVkX19lyEI/I8KEhBLEsz3mVDghlbMl1cjuAcT6J8GolbKHt2MwFgKvZalc0kJLlvaBgwWje2R3NNI3Cff0+hHesD9Gyuayv5yGGc337dDdvq13d+h5NF3nlu8Go97GHMFgly9xLY6YgTImCdHrfgWdp6//ZprP/m3TsKuZ9OA0ejB/6MP3rQypD7xSYJ7vjtMtCqsbupcpKDfaE9SADUhL9C30fsmPOlsHYZkUjlJ5MEjZ1+uBWGZpRqge5lbVQ9KpugOzAQFH9SCXulmgmiFzYZjY08qO3f7s2R2u8jLPiP+E3lBe3MdemYVV33n6jExsHcTQKYg613NCJgOrZeVWudiQDi0orPJc6ouzXD6uDMAxgBqOAkDugDk2KWytiw11W2/k3cu0ON8qZr/jHsSLxbI6OC4131QMByDW5OXCW9wHwv9NsV7QCAxIPbS/UdJIZcEJ3jK51GpaaLJ2ByDlRtkdT/LAcch8UnkgZnh1l9bFb1AUgtRW/bunkYKEEADw2YL5y3ZRhEEvrFPxY+YWdVNcmxiatqEZJ3nIGcNcyX40b6Qe0F3MX6NmOG8EkNOn0+1NYF2xa6C8MUiXFP1E7c2emuNcFnB09ZU48N57KTnXabuezAks8w9H+x+0m6GH9sQD9XuTIzBp6k65A7K++2njVr/Renf5YdwQ9MAd9nafz0XQrXurMnUunRdm22FixhH/5LLmda4sVA6VAccy72OwpW64+OOa/50UbmXHNVsanb68YQQjBjFcp6riz7OYqqKGL/kzYcXTPoiR+H47xeksMTGBxLHmHKIdm1v0bmJZ7jZucIlGhPDFylo/uvJXh8O/lfonLCfmV+XNbgHSMjVHt+Q1pfnV2olOwPLaZv+gCUIZfSZQuj61CZz5XElHGbPtFLU2S2rvNS/E9/yHEXn8hqEqfxBC2qzUKBk1CYGZaWvcUv7nin1GbOJQLQIT8mwpoG2OOzT
 5kcIq7T5
 kuYpthdoBL/8UEnKeCDJ2keg9wOaUtYbYnXs6ERiooeZKfwxLUgESY+h5UypZu5YeDFScLzrQ1vAlASB9fnaUeUCkaof+5qfRtfri74V8DJE9qY7Wb0yxTmmElW/QUK5kpcgnDKyJFVPhNWnSAjx5y9kr7MusMnzhM+vnlMh7L3gQahq36rRpun7t7uoMDNjoVYhwSfLnjhDLqn40Hl8hHa4QATMltnO+9C+3FQ+ETrXV679ZE6xuGoQZ+l2KIQn6d5WaM7H3IWEbxwetlvonYPCza+kmVx33ZOALaQO6EA360wuLP4y98mxBGwekYsbphCLydp0KlbZ0Yst1dCo3sX5SsYpnwFVveYs2meR5YALMRGSCHOkDnTeUahWAFoZZnZ/lFdoSdUA844RobQBG7W2FE1fzJwvUbxwt8iTdeepmzFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/4/26 17:00, Marco Elver wrote:
> On Thu, Apr 30, 2026 at 03:59PM +0200, Marco Elver wrote:
>> On Thu, 30 Apr 2026 at 15:40, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>> >
>> > On 4/24/26 15:24, Marco Elver wrote:
>> > > The mm-api kernel-doc comments have been broken for a while, as many
>> > > documented symbols shifted from being direct function definitions to
>> > > macros wrapping _noprof implementations during the introduction of
>> > > allocation tagging (starting with commit 7bd230a26648 "mm/slab: enable
>> > > slab allocation tagging for kmalloc and friends").
>> > >
>> > > When the kernel-doc block remains above the internal implementation
>> > > function but uses the public API name, the documentation generator fails
>> > > to associate the documented symbol and generates warnings and fails to
>> > > emit the documentation.
>> > >
>> > > Fix this by:
>> > >
>> > > 1. Moving the kernel-doc comment blocks from slub.c to slab.h, placing
>> > >    them directly above the user-facing macros.
>> > >
>> > > 2. Converting the variadic macros for the documented APIs to use
>> > >    explicit arguments.
>> > >
>> > > No functional change intended.
>> > >
>> > > Signed-off-by: Marco Elver <elver@google.com>
>> >
>> > +Cc Jon
>> >
>> > I thought it was supposed to work because the kernel-doc scripts were at the
>> > time taught by commit 51a7bf0238c2 ("scripts/kernel-doc: drop "_noprof" on
>> > function prototypes") to handle _noprof. In the current form git grep finds:
>> >
>> > tools/lib/python/kdoc/kdoc_parser.py:        suffixes = [ '_noprof' ]
>> > tools/lib/python/kdoc/xforms_lists.py:        (KernRe("_noprof"), ""),
>> >
>> > Doesn't it work for you then?
>> 
>> Ah, I see. So it doesn't work anymore because we add the '_' prefix, too.
>> 
>> I guess the question is if we want to proliferate more kdoc parser
>> special cases, or just move the docs to the macros. The downside of
>> macros is that they lose the types in the displayed function
>> signature.
>> 
>> Preferences?
> 
> How about the below, i.e. adding type decls that only the kernel-doc
> parser sees? One complication is also DECL_KMALLOC_PARAMS, and adding
> kernel-doc parser hacks for that looks pretty awful, so this is a lot
> cleaner.

Looks like a good workaround to me, unless something gets confused by seeing
both the declaration and the define.


