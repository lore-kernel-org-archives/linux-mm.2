Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A7FCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806E76B00A4; Thu, 27 Nov 2025 12:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DEA76B00A5; Thu, 27 Nov 2025 12:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C166B00A6; Thu, 27 Nov 2025 12:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61B3C6B00A4
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:47:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 377411A0269
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:47:50 +0000 (UTC)
X-FDA: 84157119900.10.D324EEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7EFA2C000B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:47:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iEQQhc+t;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764265668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9G5ZlW0/cGN3971UvKKz/UaFZ3iUO/gAgERGRLzt0w=;
	b=v7Iy8ojvWokej3cahhX/vSrCu7K8mnqLTmqmVI5vnD1C+bR/0nzrcmz3hhrtzeiWww0EeO
	Zj4Ix1cY9h+grCXLUbpARUHOUw98IO/0hX6qQQL5kBUj84Z/BG6hIiVOoquf4mnn9g5Nja
	hL3q+xlSIiIvmDJkX4OymQqNBxVclYw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iEQQhc+t;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764265668; a=rsa-sha256;
	cv=none;
	b=vdhaDC8SsPFsIYk3nv3aZAJpuMUL5PrSipMXl7z2uTgDedYWcg/5yWc5WUY1We172TElCH
	kbGDFlgydRYaIcFR/ZgIvgz0K2ayLgBdET33uSEzndh7Uf+YaYifct9UxvQF5zKGvvD4fc
	h9q1AsKllzegnGq98ozOP6ndAkaevX4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD99F60242;
	Thu, 27 Nov 2025 17:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BA4C4CEF8;
	Thu, 27 Nov 2025 17:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764265667;
	bh=Mlj7IZZ9H7pQFN5atJKwwNiI0cnR56p2vYQ4LsbFBWg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iEQQhc+ttHIHJkNB4yomtmyZLO6gdTFX5PHlESo0TWPWQL5MlnAywIoAm1AvBiW/5
	 nrB+DeAsOtyZPTc/P2z5EmWv6f4s9q9xTRzwyPn5V/xzzWFwxMzlrHThBl8AUy8ICg
	 9ZrBpeodUN5Q6lvikvYgjXz3KzIHK3eoiv8A6LXSMSl7HWJqvzOkTJQB7M60mpnosl
	 DYWSlcTeWY/75NXidb/E0FWSvZ/AsC6BhYZBodRJJi9JU+NWOQl5appR4AQ3DePDII
	 EI4DFC0FWXGhMp6Jhe07jPc/d9LGLcY1XSCmbC9JIngzm2WjeHo45t7mTu4YBHJbcs
	 MyQiKQ7x3LlsQ==
Message-ID: <c2597d43-d909-4259-bb5b-9294e4069385@kernel.org>
Date: Thu, 27 Nov 2025 18:47:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/22] mm: Allow page table accessors to be
 non-idempotent
To: Ryan Roberts <ryan.roberts@arm.com>,
 Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-9-samuel.holland@sifive.com>
 <fbfef7fc-4030-462b-b514-498eea6620aa@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <fbfef7fc-4030-462b-b514-498eea6620aa@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7EFA2C000B
X-Stat-Signature: q7uon7sbaak6cpbuur59tbkywfithwzk
X-Rspam-User: 
X-HE-Tag: 1764265668-938150
X-HE-Meta: U2FsdGVkX1/0UC0/WkeKRyfzJTF1s/BXAYZp77PS291HH+SVYMLaXscQKRjYZSNVZSPfdBoneNi8XfN0ZOHEPKf673+sEU5uzMBVLFn3ZUImAbJ0/SIhr2o2bSIGELpDPJi2X5X2Q1r1899UvezzUMvaaApTAfkl/fKud+pMbmqDfuI7SCFkH1zyGF9cN4yyIgVtiubceb9yYyGPjiktztdIIUIqgqSIUEEP/WvTg2bQ058+ubWuoPGdBi354wv06/ohJS6RUILvJ9Hq4wmYSlH4I03tZEtWTanuIWcbqaR8vaxIug4VYwUavqIPyRMcNulepq8T0tGCcNewlP4d1SjOOxfTP8slLpty8brF4GOQjC6yD5TsPTmqHLfJQfIi1CcuJ59JHTrOO6mcoMZcInjN+NpERzM69NpEyPxTMMM0AHjeUTc+fTlNhKg3I1U8lPN8pHLdyIly9qX2y/CXXfTmWSmcqJdIbY35IBJzHeZ8ihQOtwxH/wSg42WUNmRdYNz6AU7kRo+gaVzkeO8mZNY3PY0jgyGOtcAyLQKPh85jNo4yIxLkoH+G+DDXJPMbgat9ueyLON+4afSRZ9XhptLmUvwWbNGgTnuhNGHq4vh3r7Y1vTqkQRGOzKB3UNsylQF/vHZEWxv3o9i+5Sktn9DLHMd/0CR5AL8nr3D7Yb82sw1GmPzLu9JzZ8sa98ZEuqajv8RNQ3JMscbx2zjzbltCDB0nvC6lQco3A8lE5E3CWJS3K9Cw2IKbMsW309+ypxlwEziiJXufp63wwfneHph/4re9y9RVDtX8BavqyPfft0R71kVALwJz9mZUyWVDeiW/ANi/pRehkEdj+TkD0c4CYtoyB1rkJtMTJf6mu9m/hSKAsR32SsxK7NwoFmctBWEjr7RIGb8sbOuhJNnIJ1N442dL7SeuAfaOdnLnc8gdcAXD+x0t+vqYmZXpxvwnN1mwPRicj0MU4+PbvUk
 lI2+Ch76
 V0X1HkCmuYwZTSte28KRH2ngEgjXgPg1tYc5Z+pVho5TLpW5RzzJk+eHjY6RXexUPPIoHHqedGO8GMlsEPSvNVvaACJItz8QKqrLbqVeV8oc1IUHd1UJmuq8m7DpRa9Pr2kBD7PiucXblV84fZVCZ4NalB0nnCtFKm3DVEa6MQhXMXdFHNdGXv7OvRqQGushGgykAqWmdeH+qY4ffJKdoSWWtL3PM6sK8sVR4+kLFeeSxci4bz7XLrSV8oFMrIYNRpkRvtTMqSgRrB3yZeThw8mIHVPtm8KcE5UmXp1c2zdL+QW0M5x75Hk1vcyvB+2PLWaWOEozvKS6931q/8cbDPzh6jY13Fc2QPmEs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 17:57, Ryan Roberts wrote:
> On 13/11/2025 01:45, Samuel Holland wrote:
>> Currently, some functions such as pte_offset_map() are passed both
>> pointers to hardware page tables, and pointers to previously-read PMD
>> entries on the stack. To ensure correctness in the first case, these
>> functions must use the page table accessor function (pmdp_get()) to
>> dereference the supplied pointer. However, this means pmdp_get() is
>> called twice in the second case. This double call must be avoided if
>> pmdp_get() applies some non-idempotent transformation to the value.
>>
>> Avoid the double transformation by calling set_pmd() on the stack
>> variables where necessary to keep set_pmd()/pmdp_get() calls balanced.
> 
> I don't think this is a good solution.

Agreed,

	set_pmd(&pmd, pmd);

is rather horrible.

-- 
Cheers

David

