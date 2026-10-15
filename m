Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A585CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AEAB6B0088; Thu, 15 Oct 2026 07:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15FD56B008A; Thu, 15 Oct 2026 07:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E226B008C; Thu, 15 Oct 2026 07:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE2EE6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:09:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B7CF80920
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:09:05 +0000 (UTC)
X-FDA: 85324588650.29.CA5C406
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C7543C000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:09:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2jp9z9R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792062543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bIfes0VmGz93Q/D7qKVAipk4bYqd8Rm8ZLiZKuFMUfw=;
	b=5Q7PHyn4nnO4P0keJXSMIXlW81vazorWONPX7UXJoCQFFGsBFRb6COeGekjeqZCktaO90f
	Ipd/yw2DkicXL94HUV5gqHUZONeHJwSVsj3498sWENABQ0WjFat9kOyQetjDJnDP72qaSl
	wrgATszMEmrxHZ/2A0BfrK0CeX7bcWg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2jp9z9R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792062543;
	b=XI2DDnqNNGvUyS/qrS3PN3d2UNInuZNeO5rmNpRbwjuYMi7M8waKjUFqwAP1TZqo7UWU6R
	Du7BY5mLHiJA6qxs5NtXTAHGlhJwH5Ts9kMuSjdKpMmYNoSgheESOvb0oYaP9780P8tFNL
	2CWZjhyWTAM241NwqBdZWLdBYhUBaNg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C5FB60232;
	Thu, 15 Oct 2026 11:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6491F000C4;
	Thu, 15 Oct 2026 11:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792062542;
	bh=bIfes0VmGz93Q/D7qKVAipk4bYqd8Rm8ZLiZKuFMUfw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=i2jp9z9RcjWmzfTFdI2o0RKgNd5lHBSExqJbfVUWMOO3Hqtg8Ocr3XnH8AjA1rE+8
	 4JOg3mOL71xU17oyCOVQS5D3nzPIUBu7SzLxVt96CbTNjdvz6IUMxyGYg8frUbyE62
	 Ms9bTFfLVQPNoq4JbZ9vTDdpJB8/5/biHLFU9tXDLucmpQc5I05+e4jZru9aTEpCn4
	 DjPR2z/M8mfvz1R/8ekpZy+0etF37VzorR8WK8iwKd0M7AftHzPSuvsJHmIJ0WEj3F
	 5AqSWH/YNaidOXVDE7d+knZY7phLDP9/OtWpltqn9ir8Xnwjns3+7I71a2hISoySxd
	 SICGxvBZK0p1g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Bing Jiao <bingjiao@google.com>
Subject: Re: [PATCH] kho: do not reserve empty per-node bootmem areas
In-Reply-To: <atCQqghin0KOyx63@kernel.org> (Mike Rapoport's message of "Thu,
	15 Oct 2026 11:36:58 +0300")
References: <20261014131547.259138-1-pratyush@kernel.org>
	<atCQqghin0KOyx63@kernel.org>
Date: Thu, 15 Oct 2026 13:08:59 +0200
Message-ID: <2vxz8q3zi5kk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: C7543C000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: aex4433bbkzj9or3g9k9mbtqi7h85jp5
X-HE-Tag: 1792062543-116616
X-HE-Meta: U2FsdGVkX1+A37MLneixtkwYVlugeTHsnuRotH1F8Qmm2NByj6MJB5FaxYVUPTGCXsOauw3L+hHRF0tBitEXy8BVXoI1APWSU30svYzdW/6zEt9T1M4jwYJkhwU4OVS3E0zjst6ooo1RZPr0hiE8EvqRVZhyvXweS74M8JzX4I9NdyGmW1CRPfUFSTnkR8BHiWO22wjzS3C+ADLlyZ+wtTGK+QIfL9JDVhRQnwjKhK6RgW/K8EMVxAED0FEkl5xcC5QjZ7Cq/3zBrZgpMSsBxrNOLIw4yAoHxJmFh3Mg23E1YfnlHCn4QMPsb2fJmvbbIL4d9iGzflppXHf9IVRGmL0w1BRfYxJiIcnNaYuHziknIbQofmHz7pPv5/KlifI2dXttIrz2XC9JCDRaiq6E5PB/G7vUUgK4tMim29+2ETC41B6DVzGnB5H2AY58GBYJ7TsRpGIPslffEU+t2ZfnQfIm4VpFrD9TZkGuB9KvU+2uSsG5qrgVAtDNZHMXTMT6EVSnyqR8rTavSJPwCng6VEoS8pJX15F89AS7+ctACAIsenzOy+FWjDL7ysgGrugy/lVRwuSwvPn7JcJhhnORKWQANag2uopvFl53WosJiAO+itgz8qPsEfPThS843A7ajCmrJPMU9Iyo2/4uCuPPIesPRTjeyUccjLdGxvX+bpih0H2EGenuv7h9F887b6FXhr1m3LFbDUYTH14w62XcsHMo5lWKS2h6T1SLS4/nLedeO+vMCkf1WeG6gJLjteIYpQ4X0PCF7A+dyu+OWy7YHNm8YQBmWsqb63xciddijCe4Kn0TULybCh1SIpCxFm1Z++sAyJZJoigyUJXj4Wn4ZJkhuIVB3D+62J+e9YyQy7lrRm2+2zxO+j95adAWWUvuvfogyPbu9BcIPmiiy1yIdbRb5vOGzTAMjwQa2Y8vG1H/n6Q3IJyzTCbyd5FpEBFh1s9Vqleymd0CCT73cjF
 Xk3Ws11g
 x+8V/eufFAlss9jhfxAvmvtPeZxR3AnrJyVMnfwgehpxBp6iNgK/FXrJU5nbSMUDmhsnO6e8w8YvGVDfTEr6QYEpe9ZKlhw4pmesjsw7f4sfbwihsJ6mDa7CQH3wsf014al+NnUm0IOBYbBnCkuatXwekB2kCh6z095Ie8JW7+w5ba2HCufeFYTEALYPg6Ifu/7KM5r8p4E/C1Whe9JIlN44ECoh357L3lQzzgMgxhJx/vyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15 2026, Mike Rapoport wrote:

> On Wed, Oct 14, 2026 at 03:15:44PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Some nodes do not allocate any early boot memory. An example is
>> hotpluggable nodes with movable_node enabled. So the scratch size for
>
>                           Let's use the new naming please ^ ;-)

Argh, muscle memory...

>
> I'll fix it up when applying.

Thanks!

>
>> them ends up being zero. Zero size allocations normally don't play well
>> with memblock. Memblock returns an address, but then doesn't actually
>> reserve anything. This address ends up being recorded in kho_bootmem
>> with a size of 0. In case of hotpluggable nodes with movable_nodes, the
>> allocation on the node actually fails because memblock refuses to
>> allocate there, and so KHO fails to initialize.
>> 
>> Skip bootmem reservation for such nodes entirely.
>> 
>> To keep the code more robust, avoid overloading kho_bootmem_cnt. use
>> max_nr_bootmem to store the size of kho_bootmem array. This ensures that
>> the location of kho_bootmem_cnt assignment does not affect the cleanup
>> paths.
[...]

-- 
Regards,
Pratyush Yadav

