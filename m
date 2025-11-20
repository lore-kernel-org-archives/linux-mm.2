Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37512CF8575
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955DA6B0099; Thu, 20 Nov 2025 04:25:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D386B009B; Thu, 20 Nov 2025 04:25:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86AE86B009D; Thu, 20 Nov 2025 04:25:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 762706B0099
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:25:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C6191A0817
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:25:40 +0000 (UTC)
X-FDA: 84130452840.30.DAA786E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A31408001B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:25:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FNK9vddX;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3p8qOthpWydgOBX1TRi7q4Y/4ZncxHSSHMGH189+eH8=;
	b=WWCxfhMf3saR9K+vM9QwgQ0OhaEXKGd0NJeBJ9rV65uQLj5nZRsx1FFnP0Mpgh7UBwjViF
	ghImUeXQsxAykeX0GIE7OdWlLhtHRMBj64fjd1w9EXfSU67pRo57UYhXF8ekQ9FcjGMKj7
	6CQBVBcWiROgHi++Nu3G5uVHG6g5nmU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FNK9vddX;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630738; a=rsa-sha256;
	cv=none;
	b=8I4Idt98VSKu5hNwoJFpDvqcn0g1L/aV3v8ltMf5Y2U4lxgESgPc2h02figqwIAZ9N+MjB
	Yo1rwUCBWsy14N4yoYdNb6o1kA/W3LirXbEIhFmGQHBbplNN/EpIzUU1gNlDbyLQMJjKVH
	EM11mRRTL+iZJD5sJGlRcGX98uNJjBA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 319CF60149;
	Thu, 20 Nov 2025 09:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109C2C4CEF1;
	Thu, 20 Nov 2025 09:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630737;
	bh=evjGnIEpXhARTPmoO/cs1I6ssBqa6z251Ea4MgH+LQ8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=FNK9vddXtCXrTVzMyiR2HxiHbuMADQ+WlZBq9mC2fCoJRg4vxHKB00hiwoIdlap7D
	 ncqc3fjzIGcBOTVaFUQrnXwJG24cD9mYLD/RvqVcnaucDRl0dDIPHmv1Rs9C0IwqVw
	 s7+c3N4FOk1KTTX99A9jjZwC3qHcvY5iLBrgEQPOsGxXrk1mtM0jfm/6JDLI5Qi6+z
	 /TZt7Ev5zh9kGnqUhkWRjoBdf1vgO6jiUHQe+HwET90FCgxYwHcvztM1shPH/HhBc+
	 V/XfajD1W9gE/o5+4CzWKlvEzdm98ZirchTgFzeZIbuFPJ86z0jfXVil2Tzx9gkcLq
	 bzCkwzRc9QBYQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Mike
 Rapoport <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  stable@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add test_kho to KHO's entry
In-Reply-To: <2025111944-bullpen-slinging-dcdc@gregkh> (Greg KH's message of
	"Wed, 19 Nov 2025 17:02:49 +0100")
References: <20251118182416.70660-1-pratyush@kernel.org>
	<2025111944-tracing-unwieldy-1769@gregkh> <mafs0wm3m2f1h.fsf@kernel.org>
	<2025111944-bullpen-slinging-dcdc@gregkh>
Date: Thu, 20 Nov 2025 10:25:34 +0100
Message-ID: <mafs0ms4h2gz5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A31408001B
X-Stat-Signature: 4em1u9jg1kodnm37zkks85fnwn9ha4xi
X-Rspam-User: 
X-HE-Tag: 1763630738-239004
X-HE-Meta: U2FsdGVkX183QLV2UA5UEUYXumjT661O0LO1ofA+ayr2UT7eVZ4deEBz9FGCyTTSm7wMvPuYXRNMrSEQe2wtvlJX0NkTkbIiDG2ri8zEIu0F8536twRGmpUxlIVE/AndA+zQS8+ssXJzqlaMsTZYN75q8hPoeXPY9akigrolVWOdh7ftXtlSrWfzr/hy00IJNcIBwsVEV4qolqNbHBu8SZDJB4e5Ow0co4ZciojWti64Yx/FR++mfw0CeDeq+bGot+t3oNt3as3YqE7HDA6lAV/XBCEmyzRGCPDCV9xrJ/DV+FCeXTknFco8LykSEzPof9h0ZPoAgwKZesO0Vrkeg1Cd7fKOZ6aQJygxcznevTDhLRfgxIlJxqyEYs9PH8kWINsSyj5+rMXU5VBoFhZM28C06QbP6sdp6fzLYh8sutpuH+dvkaX4hSkxzQPvFNqH1DSwzKeVTviJmuRQkLHx/rxFjZ5uzc9JeVuhVAZD8KzdP+IazY8CHC4RAUgyGPlI2GrCIp53PqOHziQSKfOaVVgkpM8FRl/bD/PHZMMOZ6SeGunxs4TU1lpnTZset05z0L+kjR4ymTN9sJhmpQBP2mFC+rqAtTvyq7KaqHoqBTLGjXxHMr3qhySH5YdK1o2BnFTC+19coUandT0EhfgPt8Fkry7KZjzYCRLXnNsUQPPPF9HD01wjtIn1eDACdGlXfqmehHBZbjeRjnPOHFKy2ODzJZNpFrBRX/B8uDhV3uf/G4CruPbjedfERphqyub7bGdQrUE0+WcIQ9uVBPlyZ0RPIRxT60mDlilcdT9XSo3O7gSM7ByN/ArloXJLpUcH4LsZSbLFYVcrb6m7LkJjlQLJjV7frqPx00LJ6yv3FEzNnPo03q5218lV/BSZyDmG8WrxK2fRoccJBXyy7VMByir3uI/XtEcEWZEL2fnS2v65P0G8GmvM4grDZGQ1ZWxYGxiDQHfLRTV/tzwXlOF
 44F1E0Ys
 G4ujhmMozq8O9dbJidV6ap8z2l7iFZb/e5uWj+oH9x0DBCvZRy8qr8w2xiWBfAOMBqadpb+NO6lnKC776axvO0vCut3I7eJezZeC3mJMhr1xmtf9sMW62Fqfohwy/iNzqqMf90ehYeyQPd6gBKtD/OzJMn4AtUx84KfK9bwUpqnYbLx3YVJ54Qgg9n4tfgMM+r+hO0qL2+3uRYtH+EJAuIY+wJaHpiBZbNfQmxZdKOrT1Ov8X4UyVVwqTEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19 2025, Greg KH wrote:

> On Wed, Nov 19, 2025 at 04:55:06PM +0100, Pratyush Yadav wrote:
>> On Wed, Nov 19 2025, Greg KH wrote:
>> 
>> > On Tue, Nov 18, 2025 at 07:24:15PM +0100, Pratyush Yadav wrote:
>> >> Commit b753522bed0b7 ("kho: add test for kexec handover") introduced the
>> >> KHO test but missed adding it to KHO's MAINTAINERS entry. Add it so the
>> >> KHO maintainers can get patches for its test.
>> >> 
>> >> Cc: stable@vger.kernel.org
>> >
>> > Why is this a patch for stable trees?
>> 
>> If someone finds a problem with this test in a stable kernel, they will
>> know who to contact.
>
> Contacting developers/maintainers should always be done on the latest
> kernel release, not on older stable kernels as fixes need to ALWAYS be
> done on Linus's tree first.
>
> Please don't force us to attempt to keep MAINTAINERS changes in sync in
> stable kernel trees, that way lies madness and even more patches that
> you would be forcing me to handle :)

Okay, my bad. Feel free to ignore this patch then. And I will keep that
in mind the next time around.

Andrew, can you please drop the "Cc: stable@vger.kernel.org" when you
apply?

-- 
Regards,
Pratyush Yadav

