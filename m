Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84DACCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 06:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E196B0093; Fri,  2 Oct 2026 02:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315936B0095; Fri,  2 Oct 2026 02:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E246B0096; Fri,  2 Oct 2026 02:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF1206B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 02:08:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F5391605FF
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:08:58 +0000 (UTC)
X-FDA: 85276657956.27.B93A2F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id AD7FE180003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:08:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k0n9BCZe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790921336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agu/VYOjK7kNVTsVW73qyg7EU19zxMLH1H7KJB1gnL4=;
	b=seKpS4XPEF1QafQQAWGEiONvFOhDOcaz333rKU8BhfD9rn4856qWt58amp7DU0N6V0l41H
	rbTkJZs6bYR+GdZpMMcLIf7lzpbLeYngdMniOT/REC/p1KmKPQgfLr5H9S7nqvun15IMXa
	rbM+e+nJF2j7t+5oInzBxtarUGEBSvQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k0n9BCZe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790921336;
	b=pLzcP1X9y8SX8L/VDF+VhkviiC8Kj9mOlKglXl55eOikhQDulZVbYQYzwDStTb9aRMK6UJ
	AjZ1DkmVMdgCjinUHRdeX4DQut6dM/0m07rlm4NQ3piTmbXZ87iMN8znByNPlCeLkBBGIC
	ivWJwB0Jm7kWTpMBtNQmB97k/XlPDsk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECD706021E;
	Fri,  2 Oct 2026 06:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A121F000FF;
	Fri,  2 Oct 2026 06:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790921335;
	bh=agu/VYOjK7kNVTsVW73qyg7EU19zxMLH1H7KJB1gnL4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k0n9BCZe437AIaCN19WoBh6UpkVlB2OxIuvSMocblVpda5vLUmTgjqGfsI2ij+gc9
	 p+tACWkGa+lgasOyQy9dpA5rbxE+OcN8wJrMmPyYIkS3O37Yhy3rb/w+HGeOVJM/ft
	 GVV7seGQ6yEQrb+r51pcfaI9C8bc/TAJuL3eNo12qZzYKc+B7nW3p+BieXJcWK3hZu
	 +JCjVCQJPTpKp55e6dCyPb0Lbcg0/hp0hB3+CuNLPMFUZl+/KZxrNUJRGDUWc26FIk
	 66aOBLsMXaUrnXxfL14PiUHqIEkBT95W/7polM1nzak6lzT0iCGcHpX5nGMJxg6HWq
	 vcK3+mBQ/Z1WQ==
Message-ID: <a65f4431-d225-4535-b921-00319ceeb2a2@kernel.org>
Date: Fri, 2 Oct 2026 08:08:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
To: Hajime Tazaki <thehajime@gmail.com>, johannes@sipsolutions.net
Cc: ljs@kernel.org, linux-mm@kvack.org, liam@infradead.org, rbm@suse.com,
 akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev,
 liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, broonie@kernel.org,
 mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org,
 geert@linux-m68k.org, daniel@thingy.jp
References: <20260929235711.2287931-1-thehajime@gmail.com>
 <20260929235711.2287931-2-thehajime@gmail.com>
 <bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org> <ar4br2vW7yZGd3gt@gremlin>
 <94759bed23f00d2044005e36be6f72f297e092f0.camel@sipsolutions.net>
 <m2se2o3jyc.wl-thehajime@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <m2se2o3jyc.wl-thehajime@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rregaiqjy86u41adcamg7tjaaaz3zpb7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD7FE180003
X-HE-Tag: 1790921336-363860
X-HE-Meta: U2FsdGVkX18nwS6AZAdLKS21UxScOvDpTrWhUqAfhZ7IwQADf0zPZF8PnfhJilXguTyH3zUcHc5TS9eJhB2EjKE1s5wzpT/u+c6Wl+vINASVeSv27ZlKgZ8ovhfFFG2NljxLPANAX/UN7Ng+sY9E/Zq0LfmLIc3aBVd9/dKUPhK3hqNpck6D61xw7xHl93BWX6IIx0d0r/mhrsch9cF58q4I2YQFvSBM8hYWFmvT/GTjlbpjxsjUkeL3WzFDQ/VeUBj2RCxMwcxKjafkIVbTDnd2212wJYbzPFFPvxdP1rMIlwGLpsKGXSEDMa3ojOTk5PVKCdIigsTr8tNiviQySREG4wlE8WuvaGkPtDToGSwmuw0Rm4UrHjsD8KDPGd1wlZ6ObFgS7gAci+Cie11aRSLI0dDDjwoL/6RRE/hToqf0VNlSQSM378d8ZYLXT9LOkVjW9st44OZ3aVfC4zvYofD4IroJ5mdHZ4sLA+fy0lPrpSFGUjpxOcldKhdWmz3SZcy+IZW7AQjb9o2vyGsa7qnNwr6UD7weipilYAx+mWDRrZcdlWSNiEbgQFy7XJMKfidzpdWeAU1C5JhYetfmgpDtPZQRNzfZlFqiI/tSb2ZBNmKm2k9peraLsvrNhOBVRtKig7TSkaRMWJG6QOV9lrFMBKOrLoQ4B5tceSWWhfebZmOzDHa1euSA+iwe1EBBU4pRf9dxxZOKGkEeqKayOnDx9XCl6VqWf6VVW16HlAo2OmyoJo37L25Kj5ZdZQACU6sFXo7axTdZqxDrguDd/8AKSdPVuSGFYZYQja8hypWw0stQEM5TOIRfDMlW6tEp65ODgdrzW06JE+JM+eMQBRV59bGRsoE2lldaqirrEoLUE4I0nATBwoyJesyUZoWJtSOFKW85eXqgHH4ooyj/qgll3Tl1IhBi5ZNN2CJZqNH5MFmXbV8om4/HnJkjrCTryyv1bWpReRwpWbHJFqW
 +r5nND37
 TpIotfTtHnXVBXoNf6r8UzTln/TlQKFarKgxhGqYTybuEVGgCl4O05ri2Lgggkimxgg916NuVkPeWbx4VSbJh1GjzNQ47u+xh3FopuF8Wp2pl1viOoV41hXcgiH0fstJVaerQeYkTzUt3mFfDuuVhiwiptD2txDYb5A+76AUJ9uDoEBac13clSXl9+rsGTecZsSsD41YAma3Xo2lg8nvq26yierxpLB9ovbxoNkjCYI7KyErknNH+lkXpww9Mugne79GD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 04:38, Hajime Tazaki wrote:
> 
> David, Lorenzo, Johannes,
> 
> thanks for the comments and inputs.
> 
> On Thu, 01 Oct 2026 19:01:45 +0900,
> Johannes Berg wrote:
>>>
>>> I thought maybe uname could help but our LLM overlords tell me no.
>>
>> Hajime originally wanted uname to indicate it, but that caused
>> regressions elsewhere, so we dropped that commit. I guess we could put
>> _something_ back?
> 
> systemd uses uname information and our (old) patch changing the format
> triggered the regression.  thus, we dropped it.
> 
>>> It pointed at something though.
>>>
>>> In fs/proc/meminfo.c:
>>>
>>> #ifndef CONFIG_MMU
>>> 	show_val_kb(m, "MmapCopy:       ",
>>> 		    (unsigned long)atomic_long_read(&mmap_pages_allocated));
>>> #endif
>>>
>>> So MmapCopy in /proc/meminfo tells us definitively, weirdly enough.
>>
>> Hyrum's law and all that, but I guess it's not highly likely to (want
>> to) change :)
> 
> a runtime detection is nice.
> 
> scanning /proc/meminfo might be useful. although it requires to mount
> procfs (we can actually skip procfs mount as it is optional) so, this
> is not 100% portable.
> 
> checking ENOSYS like syscall(SYS_mprotect) might be useful but I
> wasn't sure if this is always the case of NOMMU or not.
> 

I assume there are plenty of other mechanisms. Like testing if fork isn't allowed.

> My original attempt was to use include/generated/autoconf.h; with that
> we can omit environmental variable or command argument of NOMMU=1,
> but gave up with handling standalone build/test case which might miss
> the generated file (and complicate the patch only for the NOMMU
> detection).
> 
> So, specifying NOMMU=1 is my previous, though dirty, conclusion.
Let's avoid making it harder on users by doing some runtime detection.

-- 
Cheers,

David

