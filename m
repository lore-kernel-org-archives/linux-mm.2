Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B51EEC1120
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C54166B0005; Mon, 23 Feb 2026 14:32:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7756B0089; Mon, 23 Feb 2026 14:32:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9236B008A; Mon, 23 Feb 2026 14:32:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 954B26B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:32:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29D2688D5B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:32:46 +0000 (UTC)
X-FDA: 84476718732.16.A0B0B80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4C777180003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:32:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pX58LaGJ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771875164; a=rsa-sha256;
	cv=none;
	b=l3/84oZ0VA+RG31tvHvxjGPtm8FueenkDCecW49D2/HwC7JRdXbmVgrj6ZykDfx2SIXZlo
	Ar7ut7ByMuY4zbA/BNCDCb+DDlq7LQ3rbcVubvfZVvhrR8G26LXcLO4BC5dNgQXcGrfTiO
	JzUORklKeNg9B592hQw+8NuT0E3TiYg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pX58LaGJ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771875164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4HfFL3tlCzazS/ZUush5kMugmg9y+8qJ25jJbQMp80=;
	b=bhCaTh43k3J8oTQ1oBCmp439qMXC5S2ijsOHFcFP8srmItMoDNbujJbKw2xaiYXIiTpr/N
	p6g2Wm2nTPReXy4yfbns6MJ4r4cdSf4rF5lF9LCWiA9H7wWutj+TbYFbEPp3MTjsj8IYbI
	Q5kWmvBaqOYsiu61jfF+rqIld/X18aU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92CA260123;
	Mon, 23 Feb 2026 19:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1771AC116C6;
	Mon, 23 Feb 2026 19:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771875163;
	bh=AKjC73ZzhO2Cw8rIy39+iAnm5xnoxvOK6IN1Fx4kp+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pX58LaGJiNo4oPkgO7P266+UDOIbdFCLvtF1Ak+cdkZcV98xkMMHwq3S3G16ESuPH
	 dxixWT/2udHEy4HB/eCKI6Tcga6YzzEc99lE0y3C0SXq05By0Sp02EsNp5gsvRcTrP
	 WBFVtPlHWbJwRPeKS1LVvlNf7SpghFS2C7+JC8fQLQj5rFkiymcCEeQMHoOX5eH4cr
	 69pFQd4V3NtTJvt8AX3Xbp7Utumi+O7Nke3XJd2Mt8V+jIIrd2Y0vlr+qrKbmXV/n4
	 mbTmUOf3VRy/b2v1pZHeLTLewp6ImQ2AB/dLu1tN7JG0DYjuN2jCKFk8FN4y5eTtUa
	 3KZMT+lCZs/4A==
Message-ID: <9a972701-00b4-440d-8bc2-24b8dc469843@kernel.org>
Date: Mon, 23 Feb 2026 20:32:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
To: Matthew Wilcox <willy@infradead.org>
Cc: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-9-kas@kernel.org>
 <aZJTLwV2SaaKu1k_@casper.infradead.org>
 <ec4a9a1e-8c08-4879-a787-3b9e0bc38160@kernel.org>
 <aZyZ2-7Xr-zUnInC@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZyZ2-7Xr-zUnInC@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4C777180003
X-Stat-Signature: zhi6f9ponmjb9mbwnqoindeprxy1kdp9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771875164-865348
X-HE-Meta: U2FsdGVkX1/Bmv1N/qrzzHFkBwd4IuG8QPD/pwB4eQWwugbUKOOvJ/B0imnd969Hfo9WaU35gnzw6i2Rjn7FHFJwbN0sTkMRLScDzG20apY1ISWY9fNvbzG6RJwncda3l+F8IDgM/L9i4U4uFrTKBlHahuwX6naOfVP2oVgs+0n1IIf256RfZt1YiIl7+Twn8Eukj/0DnOZM+gMQjTqx6SWg6D2JRwrjucIMGOhVsHZ0qxOYM23Zyab8W8cRjGX8clTlFVZ0nWbcRUbPpot6TY7qkANuIpvTV+dIy7ytZ8+WOPJbCHiJLbIjVz+A0B5fzRddsgp5hEYB7jnyhldPgRozXrrYi02F9siNssbKBYBCvGwUG/9han1v5OqXdIP/6ULnpI7tO1coJhstwZ8bMahb8EWOE4tsgy8tB4xo50NdpX+XMHd45Zlvrp8EIrxBouGzNYN9Ma/Csjjs+n6zdbxFvtl7mm+BlNoV2Nwlzpcl/iriY8N6B8V3vrWhlaJjMjMAr2sM9+8mnMQZG0MKQBz+GJhC+J3LAEW1GC6+6nyhiK7WzDSXdnyJrZZVj/kvSyzlTUPBnrXZTCwtsdmPGqRaocRafJL4ziLrQzfqKkkZNg19Va9UW+eLdWcCGDJCB6mLIx0zsRc1j02PVudMc3bHK0aQofXvyhMP9DhSaiXZ0ojOxdT6b8qyTA8OVI3+2s0oFgdPvQwN/O6usBFJdNKfbeQREvDCY6CfkAtAscmY/OScRDK2h5qxIDpufDpjSBFBxEW14Oxd8h+RjiVwUtvZVWYt5q0OPFYot9cF23PB/36+H7cneU1xa50I/PD4jHX3Wcqk88D7AvVl5x3NAjnAAxl8fzOjf0Vr1q5ysRZZQcyMmb31rHrtIKGM0JxkZ69zQGQS9p1jnaZ4iUoxQgE89vVyRgclSzX3OZ4XBVwc5giSR2idHCrWXFebI8hKQyxfLW9ESxCPT17GH/K
 6rgaf/eu
 Cy/7CD8yL20rClTFKyM+VTzbi3wIww5YmRTZaCsBACzCL4rp3Mhw2tpq0ZQsfuvoGLIkCGBdWmN8Cyobd6E4JpaYzx3jcpC8lDp3/9zHxnpoGiisT0LXdLaXa2W1I9flNSaH5JiIeSdNSzP2nUfr8uOmtIlpcrMfIMPL2r7XCOpSWHM7IZxbMVvRpBLgxgHmbtgqbWHf3vg36AZEpPxTMxiwSrwVJzLWZLZKfPiiUgRFyfKN8qzuyDzpcObiiuWKA3qy98IjOLPJofO2lNZQwYedFzfbv7nMjL3vHHpiTQb2Dobqlwu2e24lrWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 19:18, Matthew Wilcox wrote:
> On Mon, Feb 16, 2026 at 10:06:57AM +0100, David Hildenbrand (Arm) wrote:
>> On 2/16/26 00:13, Matthew Wilcox wrote:
>>>
>>> You're right that different pages in the same folio can have different
>>> zone number.  But does it matter ... or to put it another way, why is
>>> returning the zone number of the head page the correct way to resolve
>>> this?
>>
>> How can a folio cross zones?
> 
> I thought 1GB pages in hugetlb could cross zones?  Maybe that used to be
> true and isn't any more, or maybe it was never true and I was just
> confused.

I recall that 1G folios could end up in ZONE_MOVABLE (comment in
page_is_unmovable()), but my memory is fuzzy when it comes to crossing
zones (ZONE_NORMAL -> ZONE_MOVABLE).

Freeing+reinitializing the vmemmap for HVO with such folios would
already be problematic I suppose: we would silently switch the zone for
some of these pages.

When freeing such (boottime) hugetlb folios to the buddy, we use
free_frozen_pages(). In there we lookup the zone once.

Likely also problematic :)

-- 
Cheers,

David

