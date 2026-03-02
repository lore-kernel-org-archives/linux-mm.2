Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E67C2EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1114D6B010F; Mon,  2 Mar 2026 15:55:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB7D6B0152; Mon,  2 Mar 2026 15:55:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2916B0165; Mon,  2 Mar 2026 15:55:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC0EB6B010F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:55:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A8FC5835D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:55:10 +0000 (UTC)
X-FDA: 84502327980.07.820F17A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0F97D100002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:55:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Sd6H/1WG";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHrlw0PcLViufFES6Xd/jb5KXM21C02t99KMvlBYE+Y=;
	b=vbgepOQ0n/tpGHNEMQsFj7UuS0KZgGfBq8SMIxaihNZM17SfBlk+nK1WR3lAMZy7tnxScK
	6b26wAnr6mwHcyI7b+EiI5m4LRzB1LHGCJQFU9t9llqXaekS/hZDt2vwt4vRrSr0506B4W
	nkRHE346XspuRYuEITRNBwzctI/hK8U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484908; a=rsa-sha256;
	cv=none;
	b=2Aa7rGLj9v9l3HmrF6YhZ0H74gpjN2579z+XMMIkUKW5kpxy4tVUG67cqsQF+G4KZAkIq4
	DX/ugP4IKOBuI3cxdNj8lpsX8QWcHC8w9GfF9+SELWq6sgfShRPcs1EFtTEjVPe+dVgiU0
	YKkaiSKSPyGSXSdabEmOv3h1AYtFngU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Sd6H/1WG";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772484909; x=1804020909;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mHrlw0PcLViufFES6Xd/jb5KXM21C02t99KMvlBYE+Y=;
  b=Sd6H/1WGWaJOG3DljqsEjvPnuKQv1NTMASoa1niK5pEpO0l2UFXlwcI+
   vRDkyUUhZGHJo3LKHsuMQOGUS7lzYF/b/061ojJ9/g8xZ1mOe65hM+FoF
   6wL7P0dsFIN3SXAx36d57klWuXDxLGmuId+/r7P9WWlIDqavlbMXOE2ig
   0iJ30J3YS3FwaypVWjbq+eXB2ZOQyvdgQLyz9VUDMw01tBnJbModl8IFR
   l6dIFdTgBqiBLO0A0imRETnbf2VOntSD9Z7hWESnTWukN5mD5neVobReK
   IUHSm6+wfGm/ZWOgIQSeHGCEhUkKwK6O6aKBVswDdddysdxyvIAm/2786
   w==;
X-CSE-ConnectionGUID: 1rGLMcaBS1e+00/mxVGw3w==
X-CSE-MsgGUID: d8ULfZuZT2mA2xZygYFogA==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="77118750"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="77118750"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 12:55:07 -0800
X-CSE-ConnectionGUID: fataE48BTPepdKi/wT/yCQ==
X-CSE-MsgGUID: yfhONvVwSDGNMsg+ANggDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="214185040"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.108.103]) ([10.125.108.103])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 12:55:06 -0800
Message-ID: <c85f864e-7784-4ba4-9fae-e957b6305d92@intel.com>
Date: Mon, 2 Mar 2026 12:55:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/4] Convert x86/mm/pat to generic page table apis
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, akpm@linux-foundation.org,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
 <aaH5Z5HTC5GyJ6sT@fedora> <2fe139df-1764-40e5-983d-48d7f97c2e39@intel.com>
 <aaI6Vq-uyJ6F4P7u@fedora> <bf7d3f8b-8cd0-420b-b418-8b45bcfbcfcc@intel.com>
 <aaXyqZpenNthBTq4@fedora>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aaXyqZpenNthBTq4@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0F97D100002
X-Stat-Signature: gwkx19xaroutwrsbu4mzhyc5kf15erqk
X-Rspam-User: 
X-HE-Tag: 1772484907-110675
X-HE-Meta: U2FsdGVkX189yb8+34HtC4byMBPxT34rgw5XSVoN7oJy15dIKVeDJ/S2JWy+sjrYXQTI87KhT8yOblzqfuCP7bAhjDQfG/KzUPCEMa2ntl7WW4LCBtoi1gdz8fM49STUGqtDQm/fbDe+rHNtRh3bdtg0uDFMMB95gxvhJo5+UHy2ItOq2ElRl8CQ0YTjTK0USe3r/qCA6hJX/GzHXwXRO2uIetlaBbuqbBy/fQMuchCO499AY6/bmBJxtlYLO3e2FEY/s4bXfrqxweJGQGLpVmn46ppIObOtkC7XgTXD92Lm3QG2t2I5/6E2hxGSotjP7++5UPzM8IxVxmtDCv0vt383/1B6f+Y7mA+7/O0K1WDoEFHNNy9Clyy649cnQii5b0VcUDwVgmWp6Jo/XnaeiCSwYqkyBIIN4B1dgCrvmhoO77GX1jxnt3ZkaFH8wi1krrr/aG10RHZ3Wv2d+EzIvOmt+FMXCZpNql5uad/MN0lUwl0nM95YPv7n7uw9mPoajTaPTGA5g4weU/PkMUFK+TvlSvjwPV4EmTs7NEmhUY9USMcggesg73jUx0xsNuJA6niyoPENxqeEVhVk03ELqOtH7AgZ0x/GNBg3R0rlGkH7DrRSm71l8rKKIa3Bxra76cr/pPGnrj/vbCUvLSVG0pHiKr9O77zKhiCml5Z/ivfSOGZPwYKUB5MLHCSXzKwuAJl23xyjq18t7P6Ar9kLARp5K0Oi6ZooVzuhZbmTQ3jFMQR9ytbyFirsXb3O9RR3FaMhyv3eNQrCVzV0V7Rr1hRrUIbjw/OmDYxvoScjd63Fub9/dhA2QD7jYuhzKa7m3naoY5reHu7dn58gVfHz7cRGxbw0/MwEmAQkjV5gtYCb+dc126XeO1bqQnigXnNv3Iqy+yOvbAFKkuULDJByos6AKm/+6u5k60NTLJQPsI5FBjB+GZBe7+jBYPZFnYcPou5m/gLcclRrPxI19OZ
 rlfUOpAu
 +Up0RofDc7IuUldhpgJ+XhZ/cpK4jIZkhdzWm5HkEC5y2eB925wJ42xtRoNb5za1GF+PUwqWljm/yd2QpoohKeg27SACC27nm4D8VJVN0ayKJPhvRuyH633eNyxvNLFxWsTEpHYe8Cb9uq6XF+oCDWh1MLf4HPccHJdBNn1/v6T7q9CPuWShNlDRn/T6ETeRmyN1YFD06hKLrYnRhtSAalm4691O5sNPz2HY6MbnzcPllWjsHYN/U36PjG+mutX/w/KgOiopGPA0IDsLaMT0ui0FIPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 12:27, Vishal Moola (Oracle) wrote:
>> I was actually kinda hoping you'd be able to actively go out and find
>> some reviewers other than the maintainers.
> I'd appreciate if you could give me more guidance on this. Who am I
> supposed to go, if not the people from ./get_maintainers? I don't know
> the x86 folks, I interact more with mm.

Hi Vishal,

I personally look at 'git blame' or 'git log' manually and see who's
been mucking around in the file recently. get_maintainers.pl does _some_
of that, but I think it mostly looks at others who modified the sames
lines you did. That can be a bit too restrictive.

It also couldn't hurt to take a quick look at lore for who's been
patching the files that you are, or commenting in threads.

The more of that which you can manage to do this now is less of it that
I have to do later. Any effort in the area would be much appreciated!

Oh, and if you have a friendly LLM, it doesn't hurt to dump your patches
in there and ask it. Couldn't hurt.

