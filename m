Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EACE7606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=t64olPTY
Received: by kanga.kvack.org (Postfix)
	id 0276D6B05B3; Thu, 12 Nov 2026 06:39:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A6F6B05B7; Thu, 12 Nov 2026 06:39:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE46D6B05B8; Thu, 12 Nov 2026 06:39:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C14E36B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:39:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 584F14046E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:39:55 +0000 (UTC)
X-FDA: 85426272750.04.2E2BC51
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 68607120008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:39:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t64olPTY;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794483593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YL9vPLbC3ZW14DvANU3hpZtkl64GE6Cg8WE0isE/rfA=;
	b=mpTZsTmz2shp4Cww6qkmrumubQcXWl97lZ7OONDxZLY2HTqmzYPI833hxdlQVCKUWE5mYr
	cX929P7zuxnjxSPYKWiyLDP6HbSe58ICQZmpvO/xpHXLIwGFRQEOSgF4rb4j9QyFKOlnJ3
	pSewv1anmq0pm8Z0qWGKibCz3yASnJg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794483593;
	b=K57NQGkzQTI3p+Xh9+rMSHaZO7CJ0m6Gyj9QppyJafzEkBx9A8MLuh1drK0y4XZCHltapA
	J9WL3gO0gF2odRDZHTqk6Dum4e63wTL+7Ybjh5WiwjobW6iC+XVl6mzVKxeV14WqZzTQFP
	8KWI2lee8hpoEd4HGuMT/MRVb7kSlZ0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t64olPTY;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 680D81576;
	Thu, 12 Nov 2026 03:39:49 -0800 (PST)
Received: from [10.57.59.183] (unknown [10.57.59.183])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E85A3F632;
	Thu, 12 Nov 2026 03:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794483592; bh=ZqrSL8M+EK26zZlTilw3+OBU1RXFJn7OmIH1wj8UGK8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t64olPTYqsoQruagzwJOaBesAbiAuLSWj19fX/8b7GkaY+T0lCZpZaJDwCz7A9L7V
	 +fqxsw7u8kA5Dpjlo5v6OChVIthmr7+a0bvXzVahIPw5GvhtMB39qoCGMRCkXDT77T
	 iTNyJwWtn5UF4h3ugfYVxBZJaw1lYK9xBCS4ekKo=
Message-ID: <4fab7e04-c429-4a35-9945-57eea8c97144@arm.com>
Date: Thu, 12 Nov 2026 12:39:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 22/22] mm: Add basic tests for
 kpkeys_hardened_pgtables
To: Mark Brown <broonie@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Ard Biesheuvel <ardb+git@google.com>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-22-aa6c4d9603bc@arm.com>
 <2d13fbb7-b5b4-446e-8709-5b43349ff19a@sirena.org.uk>
 <9e59fd71-97e7-422c-a7dd-bc23c6e6a852@arm.com>
 <717cccfe-81d6-4e09-a466-5361ae27776f@sirena.org.uk>
 <0b29393f-bb84-4df1-a699-f7afcb50f2e8@arm.com>
 <9deffbb1-75fd-407e-90cc-59bf4c2fa1a6@sirena.org.uk>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <9deffbb1-75fd-407e-90cc-59bf4c2fa1a6@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3fuscjmbzmk9j9z3jmqd6xtr13o6krtn
X-Rspamd-Queue-Id: 68607120008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794483593-694567
X-HE-Meta: U2FsdGVkX1/mrQRSdLGAe5QN8btjwijFlXiW9p/U//gXkUfbFuGU6UmIO5/h8qa3p6oiUObvbWXDj2crROBCWueRPV04s7/+kwVR1kf+q+fuO+hodsDLIeAKQSYT9laa9UjeQda+yshoxC3iZqdrZD+3lmnLvrQDs8IGPHdHSj65dlvtWEOVKUXD7ISuxnDTXTGV1PBH8xH3cdgExlflHCxQ95BBTrT40vc6IrcCoqEiIaBi2CSjEXxR2Awe1VDorlpEvb/oyAYk1KiT9NyXzmyrSOVc/E6KQgwGDLc34XoZFFhCyu6oSAkUQkB5knJF8ySpnR6ryX2LStxffzEUam1w3R5m6AiY3TQo84AFxH18hil55z+Lyh78bs4FO0cmZmyKbhcEhgFQsLW4/wTc/9eC4Ap51TJP3gRJtJQ8/wpbrpIyUWw8H6to77T33ky5MnJnmDM8i8bnSXxbf6RwxDY6tzjVuvZjrFdX+oGQT3lgyI9jp6E1I2y6lP1fHEF1LevUSXTQc163SxHuSRSxkAsyxADGN8qRlOfnHBRmCTH+a+0F5Bkjb2levIdOB/pWMeTBhsIiW+ujN5wJPemh7zPc4kAp7hFPrhwYZqbavDwl962bNUv4O6/CjwXSrZhSaj32GUtUdpx5IMetAsIcqY/o6NRhlzbagVjTNhTUXUkJvBRjq+bJzS//HJCTikHqUouQ1NOEGB3LTU66KaOWi9ZvduB1+umn1tvhHbuocx9VL7Rzdv615WoCqdnENcf5BWi2Zj2MZQcVXOUSPKuSJIcOYFhDDWx46e316pCOOsErWB1TwMeQI/H4KVb7vdhZ1O7vvzRWaAnxYZ2omSUnfl0Q3S3Ll3OnU8hiyMso69ac9ICpFc1BVIsXdoGxcOxRg3J6x1q1eZA9qntgFdsTKqUV8fSb+K8oSnPdW6DIv2V2PQTGIJkB/QryFkojVMx5nRlmwBi7UIi1MACKptH
 3O8fBN84
 k2FcXDtz6J6eZ4Zg3b6kPh5aJupDFFPl9hD4ksbseMt+52149Wiyy+EBSF5LdhRhwqDCaH75o5f7ha/I5q5ZnRX8EbzGty/xj1ndvVWmbnZCrgdQm7D/lSNv3rSa0S+VM5HV891FwRk6pVhSX+XFni8XOsTPtxVnWnEDkPa6tAPuw3Xs24xehCqag7bO1EttVREH8tsDDUdHEwBeo++BStAQUzD5yr4Bj+948gf9wgN1BK+snEuaeROAX56qFahei5puwNJNJJ9LWo2UC8YbAa6MhirfZpklM3HGC71Er2M9bIF44HbSJrK0OR5wEjLDd+blvFuBO0OQTIfGGHZUjMEu59ayqN2LDaEmykIoj4tPZtz19ZrlN2LQ+6D8sYb8/zcwu8xYOj/ghC60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/2026 17:15, Mark Brown wrote:
>>> Yes, or something like that - unfortunately KUnit checks to see if the
>>> config options appear in the configuration so something that vanishes on
>>> other architectures causes issues.
>> Alright, I guess there's not much we can do then, short of creating
>> arch-specific fragments.
> Or my suggestion below, or come up with some generic option that could
> always be there and would in turn select hardening things.  There's
> probably a case for having something given that the hardening features
> will tend to catch some kinds of test error but that feels more config
> fragment like.  Another idea would be to teach KUnit about the idea that
> it should try turning on some config options but not worry if they're
> not selected.
>
>>> Perhaps the default for the config
>>> option ought to depend on KUNIT_ALL_TESTS?
>> Not sure I'm following, the config already has default KUNIT_ALL_TESTS?
> The config for the test does, but KPKEYS_HARDENED_PGTABLES which the
> test depends on does not so unless the underlying defconfig turns that
> on the test won't be enabled.  I was suggesting also adding a default
> for testing.

Ah got it. It doesn't look like there's a precedent for KUNIT_ALL_TESTS
having that kind of side effect though.

A separate fragment for hardening options where KUnit ignores options
not getting selected seems like a reasonable approach.

- Kevin

