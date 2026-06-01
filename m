Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FEEDCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CAA26B04BA; Mon,  1 Jun 2026 16:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B626B04BB; Mon,  1 Jun 2026 16:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691376B04BC; Mon,  1 Jun 2026 16:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 569BC6B04BA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:15:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F29349184C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:15:27 +0000 (UTC)
X-FDA: 84832448694.03.A241C98
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 46F4AC000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:15:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=N4fFVqdp;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf28.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780344926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8NBTcO9HEOzTK8eQah5j9/dFbH36DIcHsxmT2YF1Qc=;
	b=qZu+C7GVNl3baGprenNFSfpMPNo5EYKtHTpcyFM7lfGEeSLz6/efN13TtCmI4uzS1QaDoh
	Vz+sSgzFTtWkNd54tGZ33qlwr07rGsWyntJxs8PgGxSpVSbtkrSn1tTCGpI8M16hQyfrPA
	8ua1ai1lKnc8ZJEsZcCi7qx+dzqEWhQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=N4fFVqdp;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf28.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780344926;
	b=uD19VyrI6msrX9SzrFRf6hqyPS3EBbjO9FxYHdh9GPKSUq/i3L6Uy7qnPYQUQF+sPlV4fV
	wmjQh6OPy5JqdnEfzvo4UaP1ahFUuc5c4F8myNZc0fN6C9hF2Xx1AL+vvTXOFbqhUokVL3
	ewGedP28lvdvIXnwKB0Z9+Gxpxpo7nA=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id C8C6B20B7167; Mon,  1 Jun 2026 13:15:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C8C6B20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1780344911;
	bh=i8NBTcO9HEOzTK8eQah5j9/dFbH36DIcHsxmT2YF1Qc=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=N4fFVqdpnNKdfAbjqncbFZwC2cL0SqneHkeBwmGFomr8pp0NRNUByLEUbqgl8CJ8N
	 vY6qbZwhRR9MwgL5+zUBwQimuhzzrZM/WE/HOOB8z/Dme678HYaDRiKwCDmVLKYqQV
	 OjG4scG03Yvz67ic0ko8L1MxjUf3zZKekJ1EavqM=
Received: from localhost (localhost [127.0.0.1])
	by linux.microsoft.com (Postfix) with ESMTP id C62FA307029C;
	Mon,  1 Jun 2026 13:15:11 -0700 (PDT)
Date: Mon, 1 Jun 2026 13:15:11 -0700 (PDT)
From: Jork Loeser <jloeser@linux.microsoft.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
cc: Mike Rapoport <rppt@kernel.org>, linux-hyperv@vger.kernel.org, 
    linux-mm@kvack.org, kexec@lists.infradead.org, 
    "K. Y. Srinivasan" <kys@microsoft.com>, 
    Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
    Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
    Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
    Jason Miu <jasonmiu@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Baoquan He <bhe@redhat.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
    Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
    "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
    Ran Xiaokai <ran.xiaokai@zte.com.cn>, 
    Justinien Bouron <jbouron@amazon.com>, 
    Sourabh Jain <sourabhjain@linux.ibm.com>, Pingfan Liu <piliu@redhat.com>, 
    "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
    Mario Limonciello <mario.limonciello@amd.com>, 
    linux-arm-kernel@lists.infradead.org, x86@kernel.org, 
    linux-kernel@vger.kernel.org, Michael Kelley <mhklinux@outlook.com>
Subject: Re: [RFC PATCH 00/20] mshv: enable kexec with Hyper-V donated pages
 and partitions
In-Reply-To: <ah2eBxaBnVs_1j5n@google.com>
Message-ID: <4172d271-21b4-346-924e-406baef179a1@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com> <ahxrc4pTvVU20RTX@kernel.org> <ah2eBxaBnVs_1j5n@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 46F4AC000F
X-Stat-Signature: haxw6xisdezz7u4m94tf7i8c4dat96q5
X-HE-Tag: 1780344926-417729
X-HE-Meta: U2FsdGVkX1+5kOgQ6Q2e+3QK9vZRkCdG89Lp6fBAqf5oI+zFKw5eeSiYcqK7a+ThgM+dDuBi6JZgiEQdWLnr7lLQBGb0lqbLhXaL/hVTbIuATmxlteYoytgwR9ReItaHUPLfXTu9tCj9rfXJn/mEoOJ8HmR/M2lPHDkdmWnI0uA+t4Oyfi2pgD1hf8+QDWr9sYF3Ql72bIqu5oBoSBOoZVHU7iMvpCzSRlqBlDN1+S6TopIpWEG9CK7vaCDGz1X9x/eGSOgVlleVoWg10A+97LSmcMnf7zYm9yShDbo+XqROTzt5rKWcxqk1kQwo4AZKpdpmxKzHIeS75j/3Vuss+wwEiK4frF8nVoMrx26KBT+ty3n6ACcf+NCwFHZjKfnteHfnH/ilmeRhf6hd+QbYN/qvcO1yUhp6WDhYNcZqIywngtvL+wfQnvYLBkqq6ukb1hKfNPAKuP9zl3/JjJb0kqYph3c64MAqE/lKNYGT/OeS11gaMma0LzgnK7HjN6b7EDtWxcRj/3aCAkhZxLg1akMzsDSmNlHUWsgcs/7wZwFVUaYb1ERkByqh043qAcYof5LYEz5ESfodK2oBlAHX0rq0yA7RKnp67vSBkgEJfEX8kGoWqkSnFk2U3+cDfQyPCJ068q3xQlFEQi8/dCLZ9VJj3t/rvh2ivl4GWTjebeNlUY9ZnqqU92eT+I/gUmfrrfbs+xYm/nT8N4CNhAykrnsFlzt19Hw9/IoOpd6ne6C86Dp19cKIlDUE58QxYd6XTpb7UAy0K3kTYlM/NhEV4oWLw1p92RaHdRc/TpvFqpG36/HU9Y9sdKhi3s+EHjQRgMe5ImYCV4Klyk1zeTz9K3qCsQ92n/jhogzzZlkpFqobfCXito/WNc07cXFe9i4rRP1yUci2nWle4FXR0SR0YrGzYux7mSluHxVmljdT+dC941qGP76ZiTSWPcPBJCz6YAB1dl0KnEQT+d/2HuE
 I6upsPmX
 SV5qiEs/ewzcIk7QG85thhBJpxhUjkdh0Oto/2o1HgE1u4XtMIZPpht/26l+yOcFxlpZKN/PKvwtgCxcPH4TXI3gtglSzT7RSys6qNfaUsbcbVI6D+bX+Wr7SkKvWC05n0LiQvj2I3pfXJROhtzWg3+V2N48wSF6fcGtENHMcOv+OAcYKnmUmMlc54hudfb17gB7afJhzXJ8wAtOciczjLqTN1ykRSFhafEFaWzr6fR+3NPKkLSFoUdTs8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Mon, 1 Jun 2026, Pasha Tatashin wrote:

> On 05-31 20:10, Mike Rapoport wrote:

>>>  - A freeze mechanism to lock the tree before serializing for kexec
>>>    (patch 13).
>>
>> There were a lot of effort to make KHO stateless and drop the requirement
>> for finalization/freeze.
>
> Yes, using KHO directly here is incorrect. The state machine is provided
> by LUO, so we should use LUO here. MSHV should provide a file that
> userspace adds to LUO, and all state machine management would be the
> same as for all other clients participating in LU.

The thing is, there is no file handle to rely on. Even once partitions are 
all removed, Hyper-V might hang onto pages (and won't return them even if 
asked). However, these pages very much must be excluded from Linux 
post-kexec, or the system will crash. We cannot rely on UM to ensure 
integrity of memory management.

Contrast that to standard LUO use: If you drop individual file handles, or 
even skip the LUO phase entirely, the worst that will happen is that the 
objects will be gone post-kexec. The MM itself will still be consistent. 
For MSHV & page donation, this is different.

(And yes, partition preservation will very much tie into LUO)

Best,
Jork


