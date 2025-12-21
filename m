Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A422FE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CF86B00A4; Sun, 21 Dec 2025 04:17:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D07996B00A5; Sun, 21 Dec 2025 04:17:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34B06B00A6; Sun, 21 Dec 2025 04:17:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B09446B00A4
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:17:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4231860535
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:17:20 +0000 (UTC)
X-FDA: 84242924640.26.F3B78CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 704DA4000C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:17:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nEWtcsSM;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766308638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjn3kLfoI9xdb0JWVuRAlrWbcIA98vVRZn+LB447YGQ=;
	b=Nri0r9ZObcN6UpcnYJc8wB7fanNus4f9+vw+AOcGw6o/OHDMpbhqNn2fStOZOQSm2fTk9v
	yDqkCH3eGwdiQqqpD1NEk3hORsUg7Hcvv23M9hVLZWXbO96WKOYg6wLJ1ZYaUsyn20bosm
	oUlGHBvCNFeQx2c+Sq48AvOV2GAxML8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766308638; a=rsa-sha256;
	cv=none;
	b=jHJEnXCTDWfuKBevPjXh6N/zLHlYpdPOUHywdf2Be6IKAKquhUZ+cFuz3oCzReauuJRq9U
	N+cV2KHxz7L/urnSJP34biJjSyD6VeGo0OrKbiuVIoGMB4Ade7nbNZW5f9Ixd+n3Gv0ywp
	SuPkw7AcHqZeI04zfFoRYPUJByeeDvw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nEWtcsSM;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E9AB43558;
	Sun, 21 Dec 2025 09:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04EEC4CEFB;
	Sun, 21 Dec 2025 09:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766308637;
	bh=4eUA6zMGUNJWxe38oDOSWKwnrNVk4Nx/VqQvXb9wl/k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nEWtcsSMv3X8IEXCQ8ilT++XBsGdu99zZSG4GQRMRicqoAG6z7D4s6Sjcs2zUs3Gi
	 MnOPLHswFOUldvFzErPD/etpuQLMhf2/vK/MCoP+HH8USOFpWUxMmUZDE+Hp9J8AIN
	 XUF+AUjgp1z3J7udB81iSZwKamO0vXN24lvP37+viWs33PipIh9TX4YCM+6RAvnEUO
	 mhITa188sLjIon2/QrFf6fH/KWGXOddMJ/7xOQJRQ8wVMEXEEkaAad7A5SJdrJ3Fhf
	 WZBk4EVYR3+do0mkL5Ns2xDjdTsgxUTQbFgg7vIqmzq1CyJUAWsfgLHfZkVWnriwiQ
	 wF4vF/1jj41GA==
Message-ID: <970fa015-9ec8-4903-8e2f-f3e847d550d1@kernel.org>
Date: Sun, 21 Dec 2025 10:17:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm/charge_reserved_hugetlb: fix
 hugetlbfs mount size for large hugepages
To: Li Wang <liwang@redhat.com>, akpm@linux-foundation.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Waiman Long <longman@redhat.com>
References: <20251221085810.3163919-1-liwang@redhat.com>
 <20251221085810.3163919-4-liwang@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251221085810.3163919-4-liwang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r1uia9yob6gwjzkxqfeaa4ie44dyqn73
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 704DA4000C
X-Rspam-User: 
X-HE-Tag: 1766308638-728780
X-HE-Meta: U2FsdGVkX1/IO6yhOcOFE/rAthflIUVXvkoHucY9ZKslO0GGIm7f3aZWNqiUEMpyP5aIqBkPjJo+JMGwJpGo+llRZI8A/4ZJtWGvZmIwahp9kXHv53qYB6fW90uBu1ZEQYCLPg9Tv70EPQl9nY5nL0mzYGy9uS5omtJFUYUilnYgJWChogvi7hvYMqYfvZ6fcX2MotDpi1ZUc/Ch8M92cryZKbZxOMBzc/rzqmpyG9hex2eTWOImZmEMD659NuOFE8bno3amJzbQq5H2aph0Qyu51FsEXmJM+TXUOWDB8ksNA+4NFSWldL2s29iAAWYefIepjauFGdkZZ4JE2ZWSGS8pKXn34DlMGdom490tLlGwXHL3Zj0zgEbRKUtu7OuUpRqcPGquxASQJnYxSNgAEvrmYvFR8ZmU1wfdk6Ll5VI7JGEMk1RQxRKUJxNK5m3Dklht4vgmkNCRS21exsZ1SMYx4uHjdYkr50XU5B93Z39TJ9wenu0aVwShNsjBAmnHbJHwx+2i3fOKaqL7KzE5vm9Oi76dLn5/7/Mc0uB1GbvNVkqCr874KCojuvFSScMK4FV5K1bdnP2aPVO2320cwAAS4a3U2Gr/0hWFJ02x6/qkWJ4HpRes4JlaFYZdoNLrFG87uavIDJxKR7xZ3txOxpMMOymcMM1bCn8cKw3Q2IOItJMLsqfHBpnaIyU4jPse+NsSVWhrwhhEOEYnpFJpWaj+lYqRGhEBocXbNSbdd2yxwB/odneDxgvZC09yFNGQbijKcHbZKw13xg17AB9QoXrDAhqbddct4pvxJiVzFXqRqzy60yJuqfJK5nD4/S2WbiVRhyf1xM3OFaMnaNYMX4dHoEZFPjWkc4DmaHlxtONDjFGv0tT4B8p3cfF7jEIOyc/2nM1lA+u8qb5f6sd9JO3Xf45DfpnauIU/x+n4UwBAzUKLYYacKIS9AWRxHsKn21KL5rwtQmDozWa1AGO
 4PCI7ESc
 rlOrbNQvNYV9B7RcOSu+v/RdVfqENcS69pNr2KkukC5W+6zsyOpyWX3hXn6bYm2bK1HUOa6wOG4Rj16uGLcCSGBwCnT3VAgLEpE0GJsU1kiAIdF1mCM7kcj4cphcfCinFiW3lE75fcpU1EAf5BtGtGfI28a9mQyHYH9BUcwEIkmHum6Sei5gHRuQNsJRewWPETzSXT403h7V2glpJmWu2JJ4qyAQvVF4NdaQX0uO4iqffVavWpocozthgM+b+0fta5LlGsaB21AWTqpwXIzMITJUM1ApNwZAEmmmjevExi8lECeFb1mtbsZYg1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 09:58, Li Wang wrote:
> charge_reserved_hugetlb.sh mounts a hugetlbfs instance at /mnt/huge with
> a fixed size of 256M. On systems with large base hugepages (e.g. 512MB),
> this is smaller than a single hugepage, so the hugetlbfs mount ends up
> with effectively zero capacity (often visible as size=0 in mount output).
> 
> As a result, write_to_hugetlbfs fails with ENOMEM and the test can hang
> waiting for progress.

I'm curious, what's the history of using "256MB" in the first place (or 
specifying any size?).

-- 
Cheers

David

