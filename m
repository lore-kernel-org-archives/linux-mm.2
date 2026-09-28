Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77E7CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 18:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F58B6B0088; Mon, 28 Sep 2026 14:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6406B008A; Mon, 28 Sep 2026 14:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8963B6B008C; Mon, 28 Sep 2026 14:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C67D6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 14:58:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBAB18030A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:58:48 +0000 (UTC)
X-FDA: 85264082736.17.E593E02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 07F8440004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:58:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nOYYg7oC;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790621927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQJlLat4qxj8pgDrowtyIAkoQQPKp9J5TEk8suVVKjQ=;
	b=4QBtYPH+FOVRdxUHBW6Ii+eyiVXz+Ud/PRiFDz+CEwo+Xv6rgL8vN8V1B3FQ9n1jowGC0B
	4zASvqUHX26g1tvHY/ntLStOCNdTTw1sQNHLmbkNSPabElBfI+f2cBnzCBMBUz13HOMtp9
	36ceXurGEp+MrM1LsF8N8vk1uRQbIn0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nOYYg7oC;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790621927;
	b=KLh+AteLM/4xUkjdx4RXbkX7ONbnxl6dYyLibNA+R2Qvb2SRw/VlRplFiGsJ+4pA3qi3bv
	V/HdDEcyakqFm3ODXUJWSzkw1h5l2G362AKScN9CNuqLZuyuFqa51db4pUlHfx4Xo1R7bQ
	mdD+heO6Xeon2/JP4iOz69jo6PBjZ4I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 037B941905;
	Mon, 28 Sep 2026 18:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8331F000FF;
	Mon, 28 Sep 2026 18:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790621925;
	bh=BQJlLat4qxj8pgDrowtyIAkoQQPKp9J5TEk8suVVKjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nOYYg7oCN+CEi6+HSLYl5pLYDPIkgl9oIzaKeRsIwnLQLz8gmq2Wlu8L8C67dnJeG
	 8Jqjug8DQ2jWcrnxQaDVIw6DTaQKfwBEz5XUeHMtQu+4oXvZNYq/hQmhg9GTUYuIaX
	 BDacpyX/6tMbFS4fZj3+80NIoy+Z1ibgbEcH6aPXMhaAGIYuRy/vAvhAZDbjQBVPe9
	 7bwsvipBELhLtcU85W+9CT0n5D9xfPhyUfHWMBbm0bGZocbd8ObHRV61EiYsQnAK5O
	 OCs1pBsYyjVxK8UZ3AoZWY14OtJ41S0GCn9WpAN4rU+kY6M4c63VqlKaID+AO+oIJZ
	 sntZfdjPV6lGA==
Message-ID: <9d4517d0-0e78-4eee-970e-0cac9d0a856f@kernel.org>
Date: Mon, 28 Sep 2026 20:58:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] CRASH_MEMACTION: describe pages to a kdump
 kernel (was: CRASH_WIPE_SECRETS)
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
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
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 "Liam R. Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
 Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <arqli0H0v5qPG22z@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arqli0H0v5qPG22z@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 07F8440004
X-Rspam-User: 
X-Stat-Signature: r14oqgsg6n993it7b4axzi679g31mzbq
X-HE-Tag: 1790621926-929621
X-HE-Meta: U2FsdGVkX1+CT7DyaoFwi+p7nA7z4Uorm/Gj+dBzlb3hwzhVlQHOYKkttcVWzD/K9rzRKQVMYfZI7aEsIblcQEhS+odzd5v6x8YGlWvLnmXZRYXNQzFyB8HqgRP/bv4n0RtSLM3HbofjMUn9DiVyHy4ZQOEiibJLEkrqkQUofn3MRerb0ymkJvIK4Pu2GepuGcZ1N/zRnVYCFYD6GFVYYe4URhzw716vTa+xbg6W4CbqTJA+qp/cKMzFwpuPOSNCcMuImkY/W/fkMGj6HMTdK6HFEjmdev2tyoTyyslAdS0Uk3iwZUAHwgx46RqcNS8tmxwIg6FSkaHrq2hw2/lVl35yJ1tu6wMrlqW3QPNgdZknOrM8uRsgBdDRRxfAMeQT2VX9HcKdvs/WDN5OFVUQUDQ3DnyOmp9F8Cc7mWQmwxqsuWYe44qKm38V6rTYHuG/v0QNK/YJYIXIwpcTaSCSH0pXM3tKQ+9Naw0yi1nvqVPa2qt0pn0C8Kzr14iO3xuDRoMj29wfHIY66p6FA8RgJcaAWc41Ph0+zUiBmj5Ro+YNz9ETRPRTKBG7w8o0aPYd/4KLLi3HF0QPNmF66k+xrTGUspqpfspWrotWvYyUJter9txB/ZZD5pi61Y927hSLCcUl1KoAGyN4hvjP4MUJ3+UaieKhOXCTW+2WX1G9MVauXeyw6VTJkyPUcfc1up7DGptTN8SSJMYmILS+Z9+3QeLV1Sgyu6ORxt9Fk9mmKUGx8h1ZIdtF9mOq3LBbSdZ46MYfVC1g+Z0t1tB9Me0xx2GIMRHq5G15QjQt5jmhXFbQuYgsh9xPkxD6brk34mX7jHbLPgRaWuzPpgCvTx1/zYpDz93c3Sx9+bfDnFe4SqVlfYmXgZuqoLgZQBaQwy3GJlczManuh0oz88BIIelHy87ymdQ0jy1ml9WaAsbghAcila1dLIkntWdmX7N/DlWzyPAqUaKLulJcv22Wwne
 YqH4K+yd
 TVmkmP0WeFiT34p16mGDjzcRw+7tC75jRwBsVJAAfL228rDvMHAp2zt33eTDScOHppEqPPDLdaaSVY4SYCZHxXFE/owF8ukp24ptOfYZfo+GQUhVH1kuHl2VFJI93uH1HWTuZG84Ws06uQitXPPwicUJffDNA8PbN+nyZCqEubRMTUV88/eRsKk20yTf1wTz5Cjby8vlYivVrekgRWHyufYPrASAFMCgWoAfiIW/qsB0fBHyXEn6vv1a/DiKEgS2f2V+W4fFgUGvYbkldESmy68ga4BQMoVivFIeWMaW9ACBR3vXrRrKswL/PFDghkwMZtYrDWR31lO1HPFV6rzjgx+z8BfeZGGeYUuHSqw3+QI90kHlQm45A/Xyg8ZHtx7jFPYSBXBh3XPXGBTS6XSWd7NiMgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 19:49, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 28, 2026 at 07:17:48PM +0200, Jan Sebastian Götte wrote:
>> I'm using linux on an embedded target in a Hardware Security Module-like
>> application. One requirement is that I want the system to be able to
>> quickly erase its memory when it detects physical tampering. I'm
>> approaching that by using kdump to load into a small payload that
>> instead of dumping RAM, erases RAM frmo start to end. However, writing
>> all of RAM, especially on an embedded target, is rather slow. For this
>> reason, I propose a new crash_memaction mechanism that lets the old
>> kernel indicate marked memory areas to the kdump kernel at page
>> granularity.
> 
> Sorry this all seems really invasive for what seems to be a very specific
> use case.
> 
> In general, with big changes like this, you should send the series as an
> RFC.
> 
> Please send any future revisions of this as an RFC.
> 
> The bar for a new VMA flag, a new madvise() flag, 

It's actually three new madvise modes. Way to invasive indeed. This won't fly.

-- 
Cheers,

David

