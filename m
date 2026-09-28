Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A32CCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 457296B008A; Mon, 28 Sep 2026 15:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0F76B008C; Mon, 28 Sep 2026 15:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2823A6B0092; Mon, 28 Sep 2026 15:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB6B86B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:02:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC1B51A02D8
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:02:41 +0000 (UTC)
X-FDA: 85264092522.21.583535C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B95CC000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:02:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JpdScsI+;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790622160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTZRqeA3eh/91cOEVB9Z7b7RmqYVnV8/9o2vIx4X17c=;
	b=Cidbfu3eG5I1Tj6NQVQGJhNdY9JQkBWpC+nt9vtUE31phxO0YoS6kIIJ74DB+c3UZs3gAa
	jrXEzn1W4/V1IFAcGmlaux1GkOdpMElR6NT1XZ+xOMF2NkKEYLFWI6K40DaoYXBqcGeAfi
	Iqnf78xtBocGcjZxyilH9KEAcQ9Otjc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JpdScsI+;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790622160;
	b=uUyf+8oaNG7fWhNsd/AbNAM74OFSYKRmjkNJj7gHVElwgep4iNrTm4ivef3tiwq/biqfsg
	j22bGziVYjCOLPt/Z5Ul7g/DtHUGxrZ84HQK7ROhTVT/gZXEusbnifquXTjd9grlf5F2Zb
	Y64LCJTUN6wCMTDhsfUvrVWovA7Xz7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB8B5600D1;
	Mon, 28 Sep 2026 19:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263B61F000FF;
	Mon, 28 Sep 2026 19:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790622158;
	bh=vTZRqeA3eh/91cOEVB9Z7b7RmqYVnV8/9o2vIx4X17c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JpdScsI+6Qzm+N9kvlK8qVUWrOLKhvaCARl3eGaAFGaYO8jR3uleE7yaCCC2auyT3
	 jbZr+S2DpOD9UfDIEdqk6cBuN8esD48o0Gr0bbRqDa5fkW8kfvg3bc0OO4tZNii7iv
	 hCZnw+aYEBCML2hR563F9EUvHTG9YIPr8zh9JQIGynl/nYmoSEYCFmA30prsHWWp4o
	 ouiSZ/rTdzjzBicvJB2pHHx6risqXhJCsl//LUsmZ2yWFCPYtCei5xUflJxZAWNDrU
	 5hcJqUpuoB8o2R/tjhS4cb6OcUdgWl32Akkvgb7W7xFukQg2PHNhQGjorZFNvgDrDy
	 5AZH3hA8QW+cQ==
Message-ID: <7d4816f0-9c18-413f-9a7d-aaa003bf3135@kernel.org>
Date: Mon, 28 Sep 2026 21:02:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] CRASH_MEMACTION: describe pages to a kdump
 kernel (was: CRASH_WIPE_SECRETS)
To: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh@kernel.org>,
 Saravana Kannan <saravanak@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Mimi Zohar <zohar@linux.ibm.com>,
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2B95CC000B
X-Stat-Signature: khpz3ge1azqxcyury7ezsmn5mowuqoux
X-HE-Tag: 1790622159-112292
X-HE-Meta: U2FsdGVkX1+ewTTolggz4HYfuuLqpBzbP5THCUZsNRF1FsiTwp9bj/RMynkc5om8uPO8EcwnddXM82rdV/0ibE1Me+8HqRnArz+tASuG7c2W+EecdLMBcQC9PlpAL7WaOH1p7p7lArznL6TT9baNOa5EuIJk8C+YoKXAUpYor9FEnwkS1O0Hq8g6spnUqTozwVWNlRETvE/Wb1iUX4WRiZ106zxvMFNIT8GFoXk+0PV+JRbyWIpwdi0FyMKLMe+7aIokSaskWtpqaNDqhhM8HQCcudtnFpnK02ZvsNP34ozY0J/4IcZbF7p7vTtVK0PqRxLBjboj0MGHt0Bm/S5w+wB30yyfgVnSJ1Mo7CAateMoENux3y+QyoQhL+gA+N/rxmjPQsqFG/ZgP+U/TUYm36O0x+oDjuV8kvOhKu+5b6M7SdKl7Uze2xmixkbnBYN12BXoThOWEer4yRcGrhT2rB98vaKI1WT2RrfHzvwurT80S9PoMdN7yBjOf7y2d2+0+mlL29qRIeczeTj/nZ/7WttcN2pGqJqrUScW7qRvZ1GADNM6uWMgr4+kecBLysQc3ckOQ/NolloaCFE1vERwQ/w7ZIHV/iyk9NvmWL025fgDUQFSlIWmkiKaWmmj2NaEn+iaAhOqSvKYHD3XN3mMTSqRypftpLp8iaFzps0JqbWENBP92RY0sLGzamhNImb/MEMkTMpzlKl/0Dz0nUQhL4oBeofHV95RzNhdfFackrjpg/CJo+VhBtcJiIM28gt96amRT+cK7XWtDjq6PB/6ubnFHehX5lxi0RVGvrDpJmoiKdkxLgm7UMuteUtszoPHsxIIhpwq3EioSKif4hbJM3z77kFZ8HPtyypnGFF79xlKGzOwPOphNDWcDEA5W6vbFPPDoFMeXxQOCaojYOXHFGGYuiJam5KGWMYKt4mwGtC/EPgBZQPA+qGyJgVJDHTTkvQl/t2HHPCnhhfJeps
 R+IIdRIz
 A7EwQDd/d98fjPGsQxl6p50aDGR/Gn9Avv3LHZltikNYnPGU5PQyW9p8705whcum/kYEHQRVFODyx3nlTa47aaevPUIpvFFjhTQFQmc+n47LnjOjJUVOAucZbM0tsy76WqDre8R2uGdBtRBI9KkXbFbCk+T4XO8Hszj6lpWXR3Sbj8Q0N8buQF+6cgEB72revijutYP+FkO+gkiCQlN/8QeKAPeu7S0HBuv9+2zWhGMNua2NHqRkSyBQTlGV5AoqE/8eUkLQDRWTLbPsKhlCCg4KwJV2HQZUf41ED2+VocU93CNUUrPs49CmIzC6plZ4roBCG1/jpe8YNk0kARWRz4P4IIJoK/MUG6Wni1Vh+K6uYY5dZfhhCkkdR9J+TQM/bPkKVtlRr8w1hEz5dv9/c2vHCXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 19:17, Jan Sebastian Götte wrote:
> I'm using linux on an embedded target in a Hardware Security Module-like
> application. One requirement is that I want the system to be able to
> quickly erase its memory when it detects physical tampering. I'm
> approaching that by using kdump to load into a small payload that
> instead of dumping RAM, erases RAM frmo start to end. However, writing
> all of RAM, especially on an embedded target, is rather slow. For this
> reason, I propose a new crash_memaction mechanism that lets the old
> kernel indicate marked memory areas to the kdump kernel at page
> granularity.
> 
> I will be using this mechanism to indicate "secret" memory ranges for
> early wiping by my kdump payload. After discussion with Baoquan He early
> August, the patchset includes a second flag that can be used to indicate
> "cache" memory that the kdump kernel may want to skip when creating the
> dumpfile.
> 
> The record is a bitmap with one bit per page, allocated at boot. It
> reaches the kdump kernel as a PT_NOTE named MEMACTION. Marking is a
> lock-free atomic bitmap update with no allocation, so it is safe in any
> context.

This is all rather messy.

So, in general, kdump has access to the memmap, and it can figure out certain
things about pages to be dumped. That's what makedumpfile does.

It can identify user pages, kernel pages, etc. If you could identify relevant
pages through the memmap from the second kernel, you might be able to clean them.

I'd assume you could identify secretmem pages that way.

But all these madvise/mmap thingies are really not appropriate to reduce the
zeroing.

-- 
Cheers,

David

