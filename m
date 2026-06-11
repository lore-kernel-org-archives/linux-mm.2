Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C86BCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1496B0099; Thu, 11 Jun 2026 05:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8ED6B009B; Thu, 11 Jun 2026 05:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5BD6B009D; Thu, 11 Jun 2026 05:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B04A56B0099
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:50:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 765C3A053B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:50:41 +0000 (UTC)
X-FDA: 84867162282.05.EC235CF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0212A1C0003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:50:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZaTrMu8m;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781171439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2AjvXPjIQ9ysfVHC0LLu+0IzCvg+oy+OgHJtnOXBPLg=;
	b=Rd5EzY5uLqjiHLPMop4RTt4V0rRpw/mKDAxAUf3iD/qRqhus0PjrSoZe3YHWtspDG9PJ79
	FogXw3JwzcyzJezRk5/XRNFIcWzpRi3qCd6oLtkiZ058v/gMXFzwgrFq+jzDuPhOtXcZY4
	YtJak2zBCcO5nIjpysYWpY/vCc1tlBQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZaTrMu8m;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781171439;
	b=6tHN8gwzfMFbnVO78RCHp7G7difijdPa9fUr1npRMF2b47YhtEsrn9IefeolpAgLhngRmU
	ZejJJ0eNzquFwBnncbswAJslsvDhXdrr4FgGSUl3RCPLyAbAcx1U8YJ7HsLCaedG1TY8VR
	LOEDWxx6mi/M2Frw51qu1je+DXkNwR8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB5BA1E5E;
	Thu, 11 Jun 2026 02:50:32 -0700 (PDT)
Received: from [10.174.41.206] (unknown [10.174.41.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 723DF3F99C;
	Thu, 11 Jun 2026 02:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781171437; bh=giW2ha6I059T0G+qHAhzVhjSsPjt0+qNu14U4xR5Kok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZaTrMu8mAWfzsBKisoH3fnQkGfn0yNj/TxIkV+zx2PNNtyQQXWrVHo0eThpQs16p4
	 VZaQ43d6LxXNzSq/wlTpvMWRbR3Tpjk7i1y9adDunaSF+7+4u2qsv34+d3e3SBuTCS
	 jjxnQdSKzFNLvwdBFzq8OxGGg5ZmRV/TISIw9O6A=
Message-ID: <d41a24c1-592e-495f-8adf-dd538b769904@arm.com>
Date: Thu, 11 Jun 2026 15:20:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 1/3] lib/vsprintf: Add support for pgtable entries
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Petr Mladek
 <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Andy Whitcroft <apw@canonical.com>
References: <20260610111339.2465922-1-usama.arif@linux.dev>
 <919d334b-16a3-4412-82f4-b4cd6a35be0d@arm.com>
 <aiphHAkLnG_L2kY2@ashevche-desk.local>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aiphHAkLnG_L2kY2@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0212A1C0003
X-Stat-Signature: c713p3w4oizt1hwko14jbs9ucjucyzp8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781171438-205992
X-HE-Meta: U2FsdGVkX1/MiJTeBj80fai3RddLKdriRVNpkhBiZy+vYgTH0BPKqkSCFn8Seg2DdfXB24po/kBy90MWM08bal/e4PiEbTu9cMaOthzuRvffXE4AuTAmxlpM9spNScvdXcR7FsFYV1tiOXlUxa6hrgzl9Xersv9f7U8yl9Hd6zaiokfciPyuEx+hm5ybMZ2iwBgHxol6f6C7lG0IU1CbZ/SCKOXMl579TB0Rzdu/1gAqt4830Kl5r5DRs3swOkDvwg9Cq1wQv31nG1zfUCn2Pm3f5MIYSWIm/zqDhxB7N65oKsaG5ThWw2h5hMMXaNRAj+thlQi+Jkl+nIMwSjTVnc6gnMfp6MEzex0+BjuAO9fHOzGUrSQYjH9Z/3wygRC5/hJNkSDigg9CCxy/umIMZ3D9ti/2AE7DuHC1SJFQUnYlMMFPRLT/GYb/jRCxjj92g4p/zmZKMmPkfCo0NFZal7XnLm0xThYf8KcCiIORwBLl7h30dnyV0e6mNXkgRnJZLSKUW2awEs25FzI9Ccm6JSfxjYU7+2eipZ3xL64thyZ9O5G/D1yrpDoZeuniw01KemFzgeCvkfuBh4RajWeTnKdNSEpSy3PXnUv/JqB1QlYoAX3vp4xUrAQ2aoXVqyIwT86Cvd+eTmJDnM7+K+wlWeN5BYgZF5Q0/ylgyV00Cj57JxnhsrjfCZ2YMTmdq7E8KSe7S7jFxmxGwvX8avT+fI1VgKNVjc3xu7e8Uo8gAqKJf9chY6sDke/erPdn6YR8VHKEItWIYztn3uJhKJ8fghaeS8MElw7gMmlBQ2l8JHmwZrdiwvgZBrj4RhbSGcV8yAuV5wGEMZ8wh2HZX4bJh87EoR63Cc9EldU5wlgcpfmuCgfoLDHCNroR7ujH+r/aEUWlw0naQ4c+cIjGwKRLaZvaFss3FjUlAl+E3tUPvRgbyQtRj34JtqiiaL9LfoRFxXDOZMX6Xge5pNzEGgG
 2/FvKFK2
 NNgJ0cO89cBMJ7dNGcNz+hVJVMWH51k9GXfuI+Wed/j7/3QjYe6kai0w0nNGrhLBvf+Ty0+o1lh46VymhzF0xq+DP8mFJpdmFxLc3mvMBI3v41YdkVqrOTwnDD0u+Q18xrpMAnmAfONz7KJUk16Y6wdvlW2xfdAdKmyW8nrGT+Z/k68q0FELkdE0shVqKJ/+3r1xJAvApgxu2t8fIA4IlGUBBwSPmdSsrvRXg7QIGv6wIjeAm4mLUMjawMgZe0NXDKLdwVYUUiCetSCQw6z9MisYnabbIIagLK8Cm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/06/26 12:47 PM, Andy Shevchenko wrote:
> On Thu, Jun 11, 2026 at 10:45:01AM +0530, Anshuman Khandual wrote:
>> On 10/06/26 4:43 PM, Usama Arif wrote:
>>> On Wed, 10 Jun 2026 05:35:43 +0100 Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
> ...
> 
>>>> +		static_assert(sizeof(pte_t) == 4 ||
>>>> +			      sizeof(pte_t) == 8,
>>>> +			      "pte_t size must be 4 or 8 bytes");
> 
> Besides occupying too many lines, why are these static asserts hidden here and
> not declared in the global space? More wide Q is why they are needed at all?

Sure, will move these static_assert just above pxd_pointer()
These asserts ensure

- Platforms have either 32 bit or 64 bit pgtable descriptors
- special_hex_number() can be used to print such descriptors


