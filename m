Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9DAC55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 10:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398BA6B007B; Sun,  2 Aug 2026 06:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349F66B0088; Sun,  2 Aug 2026 06:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239B26B008A; Sun,  2 Aug 2026 06:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF04C6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 06:20:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E840C047F
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 10:20:29 +0000 (UTC)
X-FDA: 85055934978.22.06FA709
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2ABC6C0007
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 10:20:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=iZwnkVSo;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="B DnxRYH";
	spf=pass (imf28.hostedemail.com: domain of contact@jaseg.de designates 202.12.124.136 as permitted sender) smtp.mailfrom=contact@jaseg.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785666027;
	b=0eVz2ce6nAjchNM2ZsdzvgqJ0emlNk1cCaK+fhXzlgFhXSQgbIzJ/l1mlBPedyNBWWKArb
	K1WN8qTcllbiCrTB9tXbT9grQOwqNikHWhpNa8K8arAN8X6e7z58Yg2yEwtMIJdsVViBOu
	1moC75E0h+2yBSUo74mut5PXqUgUDmY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=iZwnkVSo;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="B DnxRYH";
	spf=pass (imf28.hostedemail.com: domain of contact@jaseg.de designates 202.12.124.136 as permitted sender) smtp.mailfrom=contact@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785666027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWXStCMoW6WCbh77+QZYpryjqAzaULEhXUbNrcfh4rw=;
	b=c4hJS2e+MwXFsr/Wh/sPGtsETcbXAVYngxfehK9ClnqSTt2eHhsI4MqdNXWBgoscuFNkKR
	UFxVgAHM/UjWg0XWBcwGdbfPbtmqiuFQLejfGkI5n1s8EnotYr1U9meDhYjlisybJCja0X
	ilsijz+YzdELTC4zQ653eYUEoQvwjV0=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id C146E1300093;
	Sun,  2 Aug 2026 06:20:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sun, 02 Aug 2026 06:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1785666025;
	 x=1785673225; bh=UWXStCMoW6WCbh77+QZYpryjqAzaULEhXUbNrcfh4rw=; b=
	iZwnkVSosBHNE8xpbW2/uRGeqmvdP7MUygil9KGnZUB9Xa9IDAA3U9JSiOogjVZW
	1tt40D75cLDZGnVWkY/D1TQ9ySN8s8gC0Kt4wucww+TjSW92baCAn0jWAFnOseqf
	665uGt8+/SISS2/7yCCSd4HUubsKgeQScQ9rwmFmHx/mir4+2gm/5YcCAmvxHtuh
	4RQl0CiwQCX7bpzunx+GL0QyNagk1fHODyy6Lit3UYDOE2hsEGfw09C78ob6jmzi
	H5e4opGZuvhLa4uVttC4T19BCT9ek1z/vd8/8VDDMQgBVzk4XjZxDzDCQULOnhwg
	Mz1ZckZsqogahodGV4DnzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1785666025; x=
	1785673225; bh=UWXStCMoW6WCbh77+QZYpryjqAzaULEhXUbNrcfh4rw=; b=B
	DnxRYHiYO7+nhj2tcTfTdom1aUBnsbDb6AsS19aAl8kFmxkJFcG9td2FJSvD39Ov
	FVS1gE5m9WqCd5JeQOy0Om5Je52Ch9bb1CLMvR/OHjJJIeTXIbxSQASWE/DyqhI9
	8wG9ABtJE/f4e9LyB8f37qM5dMQutALMBkK6YWd1r0rUNdfaRIJZ4CctmbHWt88u
	0P9Wgj9tmgzhDorOx5ORgUByFzJDmgq9/iAQYp69Xf7YPeAQUZE+kJ1fGlI4kUVJ
	fN379P1wnb8s8FMuviiW7LXoVQ8xol/W6lHsdcYOySxxE+cT9COWm6GMQp4BE+ik
	SbTHY5w24nMvleifrql1w==
X-ME-Sender: <xms:6BlvauWuSlb2vA2ojV38iW8G58GBzSEiPw8bC2jhukWRngUmvDPRKw>
    <xme:6BlvamtkrADkPVjhXoiU00XKp0dJCvTdBxzmBQUXLXuS6uIvo5kqOOcyMkg_xXbW-
    GpZWa_tTmVxNkdmqVqGSS0ROk9T0d9UuLB23MFnGyO4sgWtwwDZ>
X-ME-Received: <xmr:6BlvauMvjbDStu_vTDXfjJnxpxBHJLHiN0DbxdfoYoS-y_wwcEeywDcWljp7KkFROVrcEIq_m0YFLptS6UIzHOM>
X-ME-Proxy-Cause: dmFkZTGkWVqRDKxcHXed4G2Im/dKcKeNjOvDOtoNYff23UD3/wEy+brhhk2RbqYNFArYft
    yxG2GBFuo/j13wt08UgFKzWNJHXB1MYtyl0OJ+p3c+LmNt9xDuYa0828krvA9AU4dW3MVc
    Z5n9mgmxq8A45aZYLVP40RS7oHZFHK4FWE7Hl0BBpELs6vISpMoZS716y4r/pXgHw7dGVE
    HtZba2b+c323q/EucToLYsxPoAnfhDRiAWZPJ7sHTC70DdV/mF+iHA3pcAliftaH98HxlF
    dWAU7NICZgRrE7g1GmWLChsHoNRsXBqeNgzRXezEKkEnCA25hSbCTGx1gy57PKPdifSkM2
    1+ciZ2GlZM3GF80LlZuK77cxGBAdgbTWk8lgzFXdVtOY2danDcL3KQC3YDVBYv+d46w1le
    kGqPJu6c2rOE4768YKbMvJs+9Jg+FP+SBbO1ftDchUC2tp7rAam/eBslVM9sjgVmzu0hC1
    1IUP9pcqlFQ6gF2IZSlnI9D6R+BByUpikFCkdDbaQQmNibFVbiC/AEi09VwXv7+gdrH1CT
    aE0mQD3qPQ+8j840mFjrWAmHsPz8NG7CivCMwnImvW95JZUIwrUtLboE28YsF76BJGmPeY
    mGIb/QFKZI6gXrQsBHX/uuM35J6LeeDUpZn8B7mofvk3AJFfMows3UuAjWFA
X-ME-Proxy: <xmx:6Blvaurww5cxUbuXjvHc-NXLfEZZhhcv-ak2IEiADLlMH6SivIkRWQ>
    <xmx:6BlvaouAlqlGvoFhSUugZLwmA1jy3sUUn0WT_H6Y5-aX9y0cU9AKkA>
    <xmx:6BlvauiSJND0xIkfHxP_JkZ4QPVNk_JsDHQCPGPvYm-1237I_qjUAA>
    <xmx:6Blvas1Z2x02fdspsIPFFjRYIlBl41Sv55VojK-VZw7_z07Q1H-f2Q>
    <xmx:6RlvavMS61OqS3oEGaKid47bE1XwBqD-7dwbctrl5oElNq6wolknVEnH>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 06:20:20 -0400 (EDT)
Message-ID: <e9523b5a-6623-49ea-9ba3-cddae1a9ce7e@jaseg.de>
Date: Sun, 2 Aug 2026 12:20:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] CRASH_ZEROIZE: Wipe secrets before kdump
To: Dave Young <ruirui.yang@linux.dev>, Baoquan He <baoquan.he@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>,
 Coiby Xu <coxu@redhat.com>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 keyrings@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 Tao Liu <ltao@redhat.com>
References: <20260731154608.153258-1-linux@jaseg.de>
 <am38qk60mpVFuJRi@MiWiFi-R3L-srv>
 <74625f78-15ea-439f-b9f0-939d2976fa7f@jaseg.de>
 <79610b53-5201-4af3-913a-0c4dcbb6f9d6@linux.dev>
Content-Language: en-US
From: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <contact@jaseg.de>
In-Reply-To: <79610b53-5201-4af3-913a-0c4dcbb6f9d6@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8quhfj96ffbyhs53r7bcosozo9phbb4b
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2ABC6C0007
X-Rspam-User: 
X-HE-Tag: 1785666027-324498
X-HE-Meta: U2FsdGVkX18CMWTpXwUGPnbv9wuvorn9n2hPyis1B9S17ugrYy2szcU/XE4xEi7uBy8qEVojaNRQ9W1S1MdsXjNDkwjfXjXn3CFPUO6DI8qgZNX0SF3C7bGdmInrrOxjwGt22EAlqezAwJOoNj9H6Ew9yi+iEWbQpp8lRZH5Hf9BpEzJ9VibJujX+oe3uTXW8qFlaluNz7YM26m1QSsRYiKNJMChMJmc2JknkVcRfYdIWzzcRfXVB+vJjAcewZKTtKdZ/5AXQKyixzHoZB/s8ZLJra9OyDDbM0r4ZdE6gdfe0KJMLcARLXF50lwlRIqyf2iSBCr0VzqgTxtr1f4AIGarUScOgEJHFP8GVLJ6wRpTLvMRCg6KWPT73FggDonhDzwuRXkkT7HPaST6NbSD+HjFmdtta++ast7+PNNzlEsqgTjMsc76hpiMDzKLdk+ey0KiQHEbFXrXgm5dGzP2AQ+KbRqPhPZ6ScGAOJQ1tyYRuJgO7aQih2g/8Jdjr/3ZpSm23cxQ3Yt1iUoxRRjxvgER0xaW7iAnWr9BRUDrCR/iJSTWylJhZyahFm7d1CmVUTc3YUmst5lUiK0NRgpD3jU6PXzCqfTC12HxcNO3nZrmSdWLR/B67G3rw5r0bM4cXeXWS6no6uExeYXWkHv0EbPdYmqznRljt5tOEcmQ1hVxhUj1jmL/zd0y+puTNuxI984SyELEeoXEdcqqFcbjKNbtO/9vRRVXHGqItnxHxQQY+M1IDurBqR5JOu8McF8BR5jG8nAMGxp99mMf4lC4ZbsWZdV3x0r7fY4EiOuc1TGd4Vvi2WMsejnMkBFWpdoELfxsf3VWIMD1QJ52WMaiL81xClHgNc2vgptJchHIyO8HqJ0XJMQQWdvCD9z/f1oNmnTCohJE1FjZo0POzk+2LZSIuRqb4zBPGxER/xjDW8XRO67/HRVdoidIgQTTtL46tJR8LjUC/s+nn5IXn+F
 aEpPxTYU
 jZwKgME9G+LFQGvi04SwaqBXa/Ha3ewhe58P8NCh8GZ1G11pfiP7/3IEOhtEudFnLY9BKjlc/jasapdqvx+IHp+uGUWOTRO3fGvDzdK6CMEo9epRuZUtBgDVniiiBVa7ReAlMi5DqaI/aX+KCFXtzjCezKPq/6oT/r4fLlz2gjUOmoQGCaFjxpurT+Rp4+9sp9Odtj+B8jtZNe8mbzpgjh6V+zGL4Ncp0vsF5kgfdE+pQs60tlGnpK7JXTwhUlCq0iSlcxUUUfpZFBhty+oR9GyqYmPHmVa3W3PPXWB6qkYN03tR4UC/RFSwavS8ZrLtJhyi6TTsXy1nieDem2lWQTSyVoSEiNRlvqrRlLU1uUXA4CSqiVYIt4b1nL/JJ4CCL79gsZwXrOFRo3jeFVPF627jrsz8VV8HFlNcCKogkuQPLzaGBsi4YI4jlMOQeNVoFbi0W/DiP/zAONgNo2WvcWG3u0GLIDPQ5tNGM5rVlD0IIPHy+j8CL7BknvilBM4xmSMPm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/26 07:08, Dave Young wrote:
> On 8/2/26 12:31 AM, Jan Sebastian Götte wrote:
>> On 8/1/26 16:03, Baoquan He wrote:
>>> Note that we usually dont' want to run a lot of work after panic and
>>> before jumping into kdump kernel.
>>
>> I understand. For this reason, I think it's best to keep this default-off. As-is, the notifier list call is timed and on the (slow) ARM64 target I'm using, it takes about 3-5 ms to run. I took the "try lock, skip if locked" approach to keep the risk of this code crashing during panic minimal. In my application, the kdump payload is code that then does a full wipe, taking a couple hundred milliseconds.
> 
> Not only about the time used, the panicked kernel is not reliable, any more extra logic can make it even not reliable, any pre-kdump extra logic is not a good idea unless it is a must to ensure kdump working.
> 
> Cleaning up secret data can be done with makedumpfile + eppic scripts (see the manual of makedumpfile), or it is even possible to do so in kdump kernel with Tao Liu's improvments for makedumpfile previously  (I don't know the status, probably dropped for the time being, but it is possible, cced him).

Thank you for the pointer!

There's two scenarios worth considering. First, in the standard scenario 
where you enable this option, then drop into a standard kdump kernel, I 
don't think it makes a big difference *when* you do this cleanup since 
someone is going to have to dereference these pointers. IMHO a good 
reason to do it in the old kernel is that there, the code knows about 
the layout of all the data structures. To retroactively do this in the 
kdump kernel is much more complicated, since there you have to 
reconstruct the structure layouts from symbols or hardcoded struct 
layouts, and you have to keep this symbol/layout information perfectly 
in sync with the running kernel.

The second scenario is what I'm working on here: I'm not using a normal 
kdump kernel, but instead a custom payload that wipes all RAM from start 
to end. This payload will wipe all these keys too, but my critical 
concern is speed: On the embedded SoCs I'm targeting, the full memory 
wipe takes too long (hundreds of ms) for an HSM application, so I want 
to do a targeted wipe of just the keys first. The old kernel I think is 
the natural place to do this. Adding to that, in my scenario the most 
likely trigger of a panic is not something like memory corruption, but a 
trigger of the system's tamper alarms, which would leave the old kernel 
relatively stable during panic.

I can imagine several possible mitigations for the stability concerns 
beyond the default off config option:

* Since the wipe handlers are all really simple, it would be possible to 
manually guard every memory access there to ensure they can't fail and 
that they don't write to sensitive areas like the dump kernel or the 
remaining panic'ing stack. Doing that would only rely on information 
(more or less intact stack pointer, kdump kernel area boundaries) that 
would be necessary for kdump to succeed anyway.

* And/Or I could extend the patchset to include a mechanism similar to 
that in Bradley Morgan's patchset that catches segfaults during wipe, 
and then skips the handler causing the fault.

* A last option would be to have the alive kernel prepare some kind of 
"wipe this first" structure in its memory during normal operation that 
the dump kernel then can pick up to do the actual dirty work. I disfavor 
that since it adds double bookkeeping to a lot of places, some of which 
could be performance critical.

I've also picked up that I should remove the timing logic since that 
could cause instability.

Thanks,
Jan Sebastian

