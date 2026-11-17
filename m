Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39051606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OQchZGWj
Received: by kanga.kvack.org (Postfix)
	id 27EF16B05B2; Tue, 17 Nov 2026 05:12:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258196B05B3; Tue, 17 Nov 2026 05:12:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194AE6B05C8; Tue, 17 Nov 2026 05:12:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0F376B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:12:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D428BA7D42
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:12:47 +0000 (UTC)
X-FDA: 85444197174.07.E7743AF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id D81C11C0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:12:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OQchZGWj;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794910366;
	b=wSPqnr08FXHI3J+N21QsRG5qit53aUj/IIrcZIer2Apju/17w3SaPdHAz9Up0KoWHiqWKR
	ydA1PmRohn9ZEHiU+1DMoTlOTab37CYZqW3aGhyo6rMackaSz6chBx7S5Jqz9KLdmA7Nco
	X5O8ahvicueybHYa3YUPUswX8XyqVjg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794910366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3OLF8gB3qg7oq3Zq1DXdpp9l0JzH5utHq9bO6sDOHM=;
	b=vfd4vLwM6g2nbrtrk+YXnRFyVPpyKJo/NetlGAa1u3FjRxvesmyuZub8snjLLkU0X2Ln6g
	zpHH70i1K5LTQgaWmqZmDjeZNk6KDMy6PJ6mr7BInJKUMTdNht1d2SlyAe/rxlWGHzZFt6
	nR3RGtkNM6NaqChK1aNTsGOwcAd/IaQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OQchZGWj;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C53A5339;
	Tue, 17 Nov 2026 02:12:41 -0800 (PST)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADD5E3F763;
	Tue, 17 Nov 2026 02:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794910364; bh=ntG9brhhod790MDNwXy0CRXHhBdlremMwhEoGBmXYPE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OQchZGWj0BCNmNV5/FrS8pbBLF5MqnkhNpW94BFA5ILh7FEX1iX9QUkzo79s9Wkur
	 fJcbOndj1OL5aflbhuV97ZHblj5CCOG0CP+ppX3uRTYmcDLmlwSweZLzOagSku0mfg
	 6zL4kn76qhHdlCHjHmajIMQ8WZHY7ERskmTAUcZg=
Message-ID: <14defc31-66b6-4f00-bfa9-2457b8466f45@arm.com>
Date: Tue, 17 Nov 2026 15:42:38 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v2 00/12] improve mremap_test
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
 <avsmKAf4MRwGdpGI@gremlin>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <avsmKAf4MRwGdpGI@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D81C11C0002
X-Rspam-User:
X-Stat-Signature: 1jptnj5jy95fzhewxp5885p7hkzwoxuw
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794910365-416309
X-HE-Meta: U2FsdGVkX19iwfHIi47kf8EqzCuPJPV77MfxItvoX5Wq2csY+tJmbCExbv299yXB6ytmv8/6UThcPESWIHfuzQMGmy+QfZjxOAey/l7lpYcXYClB5jMOh8O0n08RaLZF/H3Ro8XsWBUThWoz/NZG2MFw9dTO4j1g90ELJT/7b8qBHbT2Ijg9MO2d2rKfJn6bQkB88uPRBX0bh8vybTHCYdHH+r4wtXEem7nBhfRFHlFnSqs1qztoyk7HbwUsJ0gwGxg1OLxbKlUaOzcRw1q2RQPk1+661oIDyz8su9YGb3L46hJGnWwRBZKm5uwGYaEGxF0c0RkLsSR117kQwc/iuVldk3nzZza/eZSdfiAAXOgB40u1pOBxxxq9aGGzHkOXwWcxm/tXDg3ICNO8VnjyOkKnRCCPdw4j7uAy8+DFdwQM2P6TTDWqNM0tRoEYHE8QNvtxDWv62/m6Ftm6mFZornRNNmEg1rCKDCqSy5AXQOF4N3S+mIdt77NjIRzkhagsPuR1RRyefSDuIhxGaEgR4scTzGfSORaV1Ml4lpQp0lJBhKglK2wqn0syA1eGoyjntlAIl8xhwU7KycTeDGycu6Eax+7eSbS2z79nrmKHyKX2lliLvyjuWyOAq4RimYrjhzYOW1fPyVa3ePSmP+NmJroSngRC7DH4PYJWiY1NP1zIo6sXJhC8KRd0bpe3wdmkTCJqjsl3A/p1KPWFFijiV+2yZ/xzzrV0EwF2Xanpb0cXoAESp/LNM7tRQfDWq1+Dhz2oWudkeAK0zNSCZ75qQflX5916HBsFXv+5pqCRUilKe1lRUON2elI8dArnRvCaoCCpl4z25e2E/uPXiM+erjLwzv4wJZzgFml6VOwfDOpdtAEanaPqqslfYY4S+R/q/KmfbPbj9DPiA5y3z0AvT3sBKjCqBwbn2/lJXHMDMuKoh+TxjDUfxL7hW5XuGeFTtlO5j/uCPxj+NzEvSt+
 jJsDWwPi
 qkdChyKzg7V42s0hMaD91zF9X/+9z/q/OP7Huvl5wmtTGTGF2ETR8TiFiFsIr624X13DOlS1hh4KZqrQjX+Q7U4aGUMIRdUzyKSORFXjPTO8vd1rCdEO8wiu9LHDOxXAIImmCD2Jg6pughxmABO2ICcvkG5qq3ZQ9pekRZlIF02fpbF8U0YfTHOX4RMauWUT4la5z9XwV/xqNn4yg3NOm2pTir975FqRKd5RA4mfscfL5ffrci6VGvbd84mp7Gwj+V186BAEP/d1Pqu9pzFpNHTHygIm1UFJpAPAwaAXDFCA01Rcvbv4bM+ovm03sgzxzl9FFOezQeF5/NcDx4attfUG8EVBgPQBrWVj5BxUsTNLC5n6SYRxhlP2CEoq4GKDQhORtSMNbre1zkENyGC+9I3ihSj0NTV7F/jXvbBvtEC0IGro22HtbELXIHt5qGenVPCNC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/16/26 9:21 PM, Lorenzo Stoakes (ARM) wrote:
> Hi Sarthak,
> 
> Sorry we're being slow on this one, right now mm is really inundated with stuff
> so we're in firefighting mode (see [0]), so I'm not sure if we'll have time to
> get back to this this cycle, will try to if I'm able to! :)

Yup, makes sense. I'd missed the firefighting mode email, thanks for
pointing :)

> 
> --
> Cheers, Lorenzo
> 
> [0]: https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/


