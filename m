Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA8EE66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF036B0088; Sun, 21 Dec 2025 22:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2585D6B0089; Sun, 21 Dec 2025 22:07:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15AD66B008A; Sun, 21 Dec 2025 22:07:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0612F6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:07:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEEC613BC36
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:07:20 +0000 (UTC)
X-FDA: 84245621040.08.E297286
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf27.hostedemail.com (Postfix) with ESMTP id DD5914000F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:07:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B15iFUZJ;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766372839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEE1jBzrmlvkQWClZ4+qffIDz+w5zNzcaWqsicnW3I4=;
	b=2Q5lPsdPK2m9kr4Q6AFFM5cAIfvB/VFJyuP/iw5cSUZN/LEuHLWSxRkIfcVN9HjC0MHLij
	WlrvoP0Efj5fhhu1+cYYNC7JkGRK/dnUCpwItgWNaxVRYwa936Hxvu6V0ZN40BMeOMUlcE
	3fVF+Le3krI/B3qxQ/uy50ZFWJtnrzY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B15iFUZJ;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766372839; a=rsa-sha256;
	cv=none;
	b=rdfvx16J0tTtpD93QZsvdlpO/XsNQMF14lYMdhdw7J48L0STbHrqGQqZ6CppuWfiVFpo77
	xcfGaB0DNqcf7CbYybhcTcQRU7NwEzVwnz0T9uYnw4G0vMuAOxxF06Vf3M3RNbbdeARUY4
	bltXt6iugzpHyqDvKwkXhSRRNWEC7AE=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766372832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aEE1jBzrmlvkQWClZ4+qffIDz+w5zNzcaWqsicnW3I4=;
	b=B15iFUZJWScExC482xi1XlEuT0OQj+0zKUqUR7tidCAJYKbqbpZoZY6J4yltMWcQ7ZJzzH
	WM6EELoGUVx1rtRrMdPVgeeiM8jtROLTmuLJ3U9Uh2jB1aetinKLYBlGe0H/2h5JJf/uqi
	tQY26FgPXjrIFNsFU1RHwPOnR6z4eDY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 05/14] mm: Move set/clear_compound_head() next to
 compound_head()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-6-kas@kernel.org>
Date: Mon, 22 Dec 2025 11:06:28 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <16EC6E4A-5CC2-477D-9C33-524BDBB49228@linux.dev>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-6-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: gk44jstz73gmfdtzjscemaosr43r111b
X-Rspam-User: 
X-Rspamd-Queue-Id: DD5914000F
X-HE-Tag: 1766372838-125468
X-HE-Meta: U2FsdGVkX1/KUQ8AjhaDc4yuohjst00SGcEFf79rX+gaqVz57bAbn/y3GS9knLUlh0+aP1AIgGCcygP2BHHwQTAShvbdH/7kEjJmVzwX4G9qgPMjcik8nb2J4hiKIbryGSZD6ryyp+iQ108/EfIdyFBee+GRuk9wRzj5a3dbQXZ4gTaTQPgaTiQ7EjD6ymrVzLodJsOMnwkd2Z81ZXzspxHlj4R+9KqwXsx7hVy8VzGi0eDuLyL4H1nN/qZv1HtJxDYcdunfuwNhwVTQa1ULCWSqMMsGYiErQvtVa4xvBjzidgjVN1XtIEovrXbfeyRgdVVH7qSMlR/f8Cnv038oOIVU8S8UbQOejh8ySGMtVgQgk/JcUslI2eioV09pwfBBZG293KlYCiwud986kXGl4r8/r3jfjOHvdO+JjYuOOx5pLJjHKMLiQX2JLFn7RDihADEV968388eEphD6ZD9Ldqn1IzyaIClKC4smLu9VVEZLGzblBegxLCmYrU4U4qpyLKwegu3ao61FwGP45cpN21YDZP1Nm8pOe/qLIH/BrNl5XxP8GATK1zFN4tW1+P/KvAlwJ5jDyTGJbqXKQW31lZHr4A0s5yhbkc5daQ4COS5d5J80LrpbkaAyIpvYE5Ry9IuMNFHphYeQisr7TtL/UEIEkaazuLkk14KA5GF6q847qKIU3LVtxxP1B906HA3BYju/+CegOrv0zwWox9B6fNwcn6bt801TME5zmNM9+B1476XrrvBrDmiHNV/jXcToF0UwaRMRRaFD4UIO31jpjLKmyWKWb8WNn7gjSBZfgiw2tLLaIvuPhP0hX9KF6UsCHTz9avF8R5fmvgkihLVDk5UY5PKT8GuMTBZic8Z9kWAiWcXp37/jRX3FYPk/V6hmlE0mK8OWR5F1cnBLz9XwLmrFxTlIfu+N4pqwzQY1NzYWKoVcxbymaQFN8lcjwlEY7UL7CNycZoAYDGEvQ9j
 jr/4q0dg
 Xrb0YTXGxYpo0ID+v2B3CMsJObCKTppCBzbr0zSxY9mwVvjWyaQTlFP7cNXg4UGDfcC4Zz7Aok3v5oojfQOkAuO2bS+ve6mMQ102GN2OvdQXA3as6P+4G1OSAQ5fE76e1CkshSw8KUN62/lIgo2+geQkb7WKnY9Z6TEXAKuoDWyjqluZ0G3jfHJV0pi/WXx/3DU8hl2Ay+u32Oj7ihgi1JBsn+ECQQZBFvTGHV6gRTe/EpILo9lmbcWtS1O2In5PdZT+vlGvbE8oCCAxozM123onVVmhjfDizCsLmQCJU2A0CSrSbKoKlCljCvjlWSO6MZrfuBuc2wwiUmeHAy0OO4/rwDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 18, 2025, at 23:09, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> Move set_compound_head() and clear_compound_head() to be adjacent to the
> compound_head() function in page-flags.h.
> 
> These functions encode and decode the same compound_info field, so
> keeping them together makes it easier to verify their logic is
> consistent, especially when the encoding changes.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


