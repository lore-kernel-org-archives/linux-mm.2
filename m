Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22AD0606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WCkjd/cv
Received: by kanga.kvack.org (Postfix)
	id 39E1F6B00EF; Mon, 16 Nov 2026 10:37:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3763A6B05B0; Mon, 16 Nov 2026 10:37:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28C596B05B1; Mon, 16 Nov 2026 10:37:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F08806B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:37:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8555AA5C8B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:37:57 +0000 (UTC)
X-FDA: 85441387794.24.428FC9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9C801100007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:37:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WCkjd/cv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794843475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Kg1BTkbPhbW7t2hqGVjK+eEZuOKkvT0eB3BQcQW+Yo=;
	b=rivUT/d1b0AxtpcWgcsouZ8CTKVVh88IyCXFyjX9kwEpDIEwNR2XUCpA6kVndbmaP22dkf
	OB7sruJ4BDnW0np5PuGndTuBr1Y3KHbFyXio89gmPNYnoSeZM9V2Wlzx+E45dyFcrvzQj+
	VMk0C0Uh94ELoSKKXt0LcMB5vfjmMXI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WCkjd/cv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794843475;
	b=PPBtPS7rGJzukW6DmjbyVl154ANaxNWyqoVglR4JSyS0KkWr7NJ0N1yLQ4CfuShvBRbNof
	abYOKfLTf9LsWQVT5a1wmjj4H+HRkQqucQPUNYo56F2J12J2Woe1SHE71BcBIf3n908H3p
	HXV5HB3NK+wJZsoMLbe/45cPE1SvXFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3BF842499;
	Mon, 16 Nov 2026 15:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5DB1F000C4;
	Mon, 16 Nov 2026 15:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794843474;
	bh=8Kg1BTkbPhbW7t2hqGVjK+eEZuOKkvT0eB3BQcQW+Yo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WCkjd/cvoGB7Kfg/x7IWS14xXRAmgdVTzj5sNdUDFHcNDuZuc9PEzg05rarb8r26m
	 7Xam7VwHcDhKa8FcQzNtF4F4oO7OfgasCsEtPv1C96krpZMKfs/XnfUvY3dvmfnUUv
	 yfJFU1M43ZUItbA6ftE9FTp6ZVv+UOM2rfjFTtqpMItWX0qmHxks7EdRoFaNfIU7yH
	 koZS8EKlSVNGKBlieG6Cwhbu0UPnpCPxHsiYN0/Umk2qyZ/fnR3qcNWf50SzWH3yiA
	 A2Kv6r67/y25CdqeYqJIDzZVOd8jKVDhPBhSO6oNxOF0fsCYwVJl0W5pVfgCeHh4yF
	 sv+JvUw/1Pj7w==
Message-ID: <ffd280e5-5ccf-49b7-a138-791e2faa3f8b@kernel.org>
Date: Mon, 16 Nov 2026 16:37:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] mm: batch of (urgentish?) fixes in oomk,
 cachestat, dev-migrate, percpu
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
 Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C801100007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: sdg5yqaz53ropah9g4134hseqsx3ie9o
X-HE-Tag: 1794843475-462077
X-HE-Meta: U2FsdGVkX1/HwkjD6n58h58dtjiBuF49uTDkcJszTOShVl4PCvgEBCUcaI+/LmjIM/5eKztJ3chhPPY9zXZ1dCBQ5vAcvOr3taSWgu1k/5fB9R53eTsbc6QkKxACJxHgnIEQ3R8g4DVmCjAa/Riq0KfH/brOcVUl+Ac+TiGE4YmbPekTR5+EcshzJrJlOewwNATzt2zhov5QPza/L1qNXl/LQAkP5PCXB5tZ5T2q3LnTE0B7DoB+5PaVlRxt4IW6RUSrENvdoMFZn908iGT217OgOqJbn+uT75yBNqZkgxTTw9F+U2kD5LR1Du3/il2ACZ8Z8e084NN99OwYYQoDUuAtyJaYaNlFqMaCRRicNjkJRR4O4m/urDo5eMQYXJm30s2J1zgGe6MHOIvl+Z8y2Xg0BOyG+hx+oUIHzsp3tDgy2nFyXcRMcOxQcp/p6hNolFA+GOWvqbSEXLG38SZiX4kgNBPIEIuo8JbjL3GRDgR1TNZIodW8ERtSJjLZ7ngwc2+Fcj50lJAYeyUNJeuTMytT6WNyD4VZ4cyYo5nk1upQSoATQti7Iy6nnjQCnRaCeapDGaqalQwh2OdKPGTQrk67BdciliyYng3iaiqMXOyt9PnGk3mdfwXG2MTLSosoLfgQIx8OImtPppiFmhuP6IbvyG+8oV2rsaIaY2ZrcfnX8ah36pnbvuMj06eGdz3YmglaHQK4q23vjj/tMZSTUewWRr161h+kgY5tY1h+O6/U4+dJ2xcuIGXpUz/NnnChWv/mWJPU4TAoF74rsDkxeBxB1q9nOqlkebjGBddNk2hq0LhxGqKRpCRxWn2nI8ynB6xkwlxuhe9WbkoKN+jaz/endnARK9bweLp0RM2HlHkHPk4vJhIbNyKdcRbZhsbO0Fb4xYV3fTmR+yJxTmbV8aDfiTcmcOXBaC22SnkzQxXNmzKrR+Nqbxy0H/gbyVFkYt7GQu5VqVoayG/4X8W
 HfHj7pYG
 olk+XRp9uoROihvyctGTWodZM4MNev4FS29DlKCOYzxIbSql0felmn49D51vsvfv3qL8vCDOOfP3FpZHFSZC39xu/mApGJllo35B1MUxE1Z2mYRMMc5HUSvhxujOTUzmMww1/Fm7v5Bd2vdGG1G2Eu1EgGFrNzSv4BgiEyG/MwrSXEmiC3RAt/AE7av3CEoe/8oXj81mDXJICIj4Iv5hqS9f/9lCJCgBe9u4kuYeROP9+RGXBwbplXf053bdNcY6+E+pskwMex22oYbpcouX8Lp/rppUGlcL/EvlDYYpSEpMO9Ro2NKbLFacDj4E4CdXr2yRUcaSuGIXuP7SlH2CAOtwKP7Viq+ELUsEa4WUipFfvp2hBLqTsICDzBjCiGkUy9NTM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> A bunch of fixes for oomk, cachestat, device migration and the per-CPU
> allocator.
> 
> These patches were originally AI-generated, tamed into upstreamable state.
> 
> Some are more reworked than others. Those which needed a significant
> rethink are submitted as mine and marked as Reported-by the relevant
> original author, others are smaller edits which are annotated as such in
> the usual fashion.
> 
> Please check for correctness, sanity, and whether the cc: stable is
> warranted (I have not included it for 3 where it seemed unwarranted.)
> 

Once review is done, I will pick all migrate_device thingies, the other stuff
will go through Andrews' tree.

-- 
Cheers,

David

