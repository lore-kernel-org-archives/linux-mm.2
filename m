Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F53AC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09DA6B00AC; Fri, 17 Jul 2026 12:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0196B00AF; Fri, 17 Jul 2026 12:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCF966B00AE; Fri, 17 Jul 2026 12:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C08A6B00AC
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:07:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC02E1A013C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:41:56 +0000 (UTC)
X-FDA: 84998381832.14.AA14A90
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id 046BC180004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:41:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NSGEpiHW;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784295714;
	b=046YXd+fzXlrSiXuX9ClVkQRV1HxbjCsngL9d/gc3ZKHa+QR6kA2HreElkGFIx7eJpPswk
	WCfbRWxKDgPh/kMfS+jp9QDlXa62l0j99xnetW+bt9r8pqI99dBC6OsswELI8EYMjHftUh
	rejpX3Ro30J9aMR+hQxDJlt6H6NG4uo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NSGEpiHW;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784295714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lWoWlVhnB6G+LRv5bvUXknZdx1osEhHjQQOBTavsAc=;
	b=am6f62BAypCR5tXQx1TNS/UXC+G20Spt2j3+CwDPjSEIXxBNl4RQSHMMDjzRzZeeN2kE4v
	6egARn74sM0lARisd23Dx/DbBV4cUPKjO3RjXw6SYVevHAb4zucKXwaIW+N8N5/8tONlRb
	kamDjz4g8Jkfd7oh0T67lc3od6PP3Y4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784295714; x=1815831714;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fvevDhSjCFC8kOKsqBUeK57DQVf+jkuNY18oFfhjsC0=;
  b=NSGEpiHWYRSixIXMOKUprwL/sJmlYODJyJg/AHrEFmsQ1vNDDJuRB3Vi
   oI4aSmQYEo29xjqER/UpieVCFv7+JmURM/1LNIq6nbx/CuK4ZVEgwvyT6
   ndCDPJaBaAPEOQ9KpOr3O9//aaERsM44rLbNHgHqythNd3m6ITbZH8yO/
   xNcUsP19G/f8GXk4qn7Xz8xBVa8aYVmd5ERflZDQAO7IHyw0OSofiFDVk
   fJuFHQK/hHRrLtJK5wT3cjOJAazlbsWiFrj0AyxFUEbibmeuFZmmaiQ7x
   SF2k+JAlROt8YAlvyQmzfGfCgIHgbin/fZEkS9L4H/tnRfZvEZ7m/VMUp
   Q==;
X-CSE-ConnectionGUID: 727YJW0jTj6ZSpR9e7updw==
X-CSE-MsgGUID: CXQB1fN8RWS+WPW2SsQhsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="96331107"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="96331107"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 06:41:51 -0700
X-CSE-ConnectionGUID: zmsr/XXlSMiHB3gpsQltYA==
X-CSE-MsgGUID: uZivZiVFRHejmuDfy07QKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="260602622"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.66]) ([10.125.109.66])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 06:41:51 -0700
Message-ID: <91f3486b-3b85-4b43-b099-0a5325643352@intel.com>
Date: Fri, 17 Jul 2026 06:41:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/13] mm/kwatch: dynamic hardware watchpoints for
 hunting memory corruption
To: Jinchao Wang <wangjinchao600@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin"
 <hpa@zytor.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Matthew Wilcox <willy@infradead.org>, Alan Stern
 <stern@rowland.harvard.edu>, Randy Dunlap <rdunlap@infradead.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260717125023.1895892-1-wangjinchao600@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260717125023.1895892-1-wangjinchao600@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 046BC180004
X-Stat-Signature: 935oiz5848ewih4iarny99u5dos9mtcn
X-HE-Tag: 1784295713-576217
X-HE-Meta: U2FsdGVkX181c3z3KNZDO0uzPyQb0CJDy+QFz40PbjpxJd4y7cD8MhAvRrG/gkKY41N21djIygACahsOAEv6EMdUfaC1UuFR3Gp8Y5nMMqVIIHqjpwQmJBqEIHKmqPxu6WlKIuXKeS8JLLFzBf4kH0+0fkBMchXA+CIQ1ZTxU7NylVSjbeoS/0aY2rOhn97JzteR+438lZBCAwKmPsmK44Eb+VW55qFkXwS+zpSHuLGnif9WE41arpIEsijodg8d2mVXCdSOyS2OUXvGvyJs86RGXdQdRK6CK1hA+9zJRXAtsfjGuZppJfUaCsNaFo03UYCRcR+MEnGjud6o+K9Rk0rwGxdjXUgroK+Is4j5n3JxoaGQMUTc4w3zq5uR4VwstSkddSMBkROxFCs1YD32xEVuPw6VzbWbzOhCJ1uqRRfRHMc2z78J9O+4aSqybAJF2D8iZcuroz7oufNQrHme/vpw9PGODFRz3ZN0ycoUaOZWInpNCr70tsKDCetpIA+71xVb6K/fR+oLP0B+TEFDwrYI6vHDtUJZsUB81uikjmnf9SQ5kOgcKTebH8D+K5mxv9Hea3YZXR84P5Lf0S2UZxSqSP/cEQGQzT8V/qe9GLRmQVN8KGx7VCUm/aaYBiLrT7kOhPKkvdLujE2EyQo/TQ6p1/mTlPupiXRuRdGpymV0n99dhOm52+CPmWCCM7YHR4T3ATooRCPQwgvy63R86EO0Z0w0kcc3Jx07QrDG2m7uiRqJHMc66RR4GqXfJlc4mh+ACb22YA/8tYNMA7jqq0KiObf9zu4OMTqXkhHGZY2pFZSJe1SB7E40/RSW8hYuMCVXUKzbXtB2QdkPP+/ub+NbxY3GwlKzTjLybO8YcRY/HUa+IhUNAL7rpk5400AuNB3bG/kb5mo926pv3ZVl3gyHr4easg82cvIW5Nny3rKXnjcroJfXGq3ycpnyRAqoWmeT8BMpvuvbVMuJNF+
 pW0ZeCxf
 KGhuOMxo+FeA8gdnUkV5caC95dR5VSf6x4DZPQX9BQ74MV6oGwP/ebftp57c8clA0lTRpOWH0stcYD+PItM7jHn35kBQhu0iBldPssZ9PRVyPZpZRmeHkIOAdTv0xnpaybYzJrULcwoe9sfJcO2EnnFuepOFt6Enxrmj1f3oUseyrIxGjplZLPgNIC8mMrtIhNtvVaYinodHsmek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/17/26 05:50, Jinchao Wang wrote:
>  24 files changed, 2115 insertions(+), 63 deletions(-)
Reading this, I wonder how many kernel debugging features we need. I
don't even think we have a centralized list of them. They all just live
in their own silos.

This one really seems like a super specialized tool. It has to be
enabled at compile time and specifically aimed at a specific function.

Maybe this should live off on the side for a while. If folks end up
actually needing it, they can point their friendly LLM over to its tree.

