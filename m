Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EABACDE032
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960928E000A; Fri, 14 Nov 2025 03:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939528E0002; Fri, 14 Nov 2025 03:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874CF8E000A; Fri, 14 Nov 2025 03:30:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76F868E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:30:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0EF91A02B0
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:29:59 +0000 (UTC)
X-FDA: 84108539718.06.101BCA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3336640002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:29:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sDtifvHi;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763108998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEbw68WBXLx515Y3j2mnbSWwnN6JgwbGwowWGkzYcQY=;
	b=El2hq5BVDnoiE4YIMm5D63wuoFiJeY/1Exbc7usc5C/MHAiiVXAZ51uGnXE+xlM+nfdVlP
	jFfsRyPI4QsAkw1tNAvE8qx1sivdC3G1MF77gP4sWXGini9ANLJgN+xPfRXVX+d1c8EiK8
	Wbv0dhX6lvE6v/dpW2gf48wfwBHGJEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763108998; a=rsa-sha256;
	cv=none;
	b=bH7Jt8aZyZCSt/IZZrq8lWSYss5AEqfZAU6UkbrKHeExdPiDcePUHlzQL8z22QQve/Fo2R
	KmnPbPmH6A1Shjn4Yk7y0vMs7GOXqPncwzXEGHuW8fEUIyqfmutQfrVrf9PGtCgRhZC7ip
	72K9PgeG2uf67AAbFoF6ZQLkEET6O8E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sDtifvHi;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FEFC4421F;
	Fri, 14 Nov 2025 08:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54210C4CEF8;
	Fri, 14 Nov 2025 08:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763108997;
	bh=UMYYNNpZ5GR5sG0zLLPnTA5aiyC6fn01mRMVDGvSnmE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sDtifvHijRGM0EyOPu1rUe8yBQtBPa1jZ74qwhW5jEU7vIPFGtOR/TQ9qbrfCIK25
	 PY+uIAbZOtl1C67PN2tiSUax8+3tovE0zPQO/vKsKkjHz1WvndXq2NRIHxGKbXrtGG
	 PTGSa2PV6iJhVbxXY6AJaA60k3sIvHvhS1QvUHxILWqQ/rF1EQhDqreitAiRUcQ1nz
	 OsOEzmF5mxSo44xJcAJ6M83suR+Y8Cuf2el+aPa+ZMtoyn2YSy2b2KBx5+KAIhKLOj
	 bhiEvPMWbfTauZ+6yRLEsEXV9FZofqYtSm06182j/dNqc4+wy5490+XUaiBQ1BkUJF
	 jxhDr7KTxZWZA==
Message-ID: <38276135-44cb-4b27-b711-7d012e2908a8@kernel.org>
Date: Fri, 14 Nov 2025 09:29:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] gpu/drm/nouveau: fix return type in
 nouveau_dmem_migrate_to_ram()
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: kernel test robot <lkp@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251114012221.2634832-1-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114012221.2634832-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3336640002
X-Stat-Signature: gwuqaddo5hchkckdsfe91jo4k3w5ucik
X-HE-Tag: 1763108998-377489
X-HE-Meta: U2FsdGVkX1+5yB37DyDUNKDUFNQucnnMfuOXW2r4JQFGbnjUdKZqjwEJ1enD5kfsuq0hmIxcoBP8Y2/ua2i+wyJ7YyaKrNhqXCHyQNqe0GDZAubBlRdppetyHOXGXPOF/2xXbWJYny0yKN9A+CNhDYJGt/iQ3TtA3ImWjMYoBfB/qeTeix4ZPvsu/N2z8CbzyWlDwKfW9ZFKrlg3ah+FFJk6VzNdvkBQ2smYkqelhK3Nye65cYyHHTGH7qQFaXx3HTTRqDtYWW6Yl9+ZDh6uCYEx0S1hfbONxMN01f/voLFKrz8TYUcrejeK8MN8uEvxxl9yu9ZQ80vx1VgQYhDkAAo5V68ooMDvEgg6EwZUboJhXaOmMkjfyka8W6Mp+Zbp2mZ8Vi3/W2QrornWK2ucRL9tDwRhX5tOVxxDeYzm5HGludX/4W5A3RoSrOJloOxLLwMn3oIBefkgR4nDosFQ17goVdo6CwF77TsOCSVUFaTHr3W4c6Bi5VfvQ9RLe8yvyJKMDZ78n7y89ZYOHtBVEG3vQ0EXjb5mKd/6fQlKFohpHnRyekTMd8rvselIxX2UKLGFG1WpWEVqBy9FOm7N816ozMEJc6Hv0DPXLyRk1TuV1vLtec01E6EuLbWtKc2eKY+KDGdbSW3xkuWQeJWOcDMUJkrrxlEdwDJfDXzZIeTFPrsGxmQnjVg3ZmToRgmEA/ef41BvCvZoGMfQHhDDk0vXMmkKp8pm36AN+wF2gpzmI9xvKI/dOi8x1ameOL1kqc0ckSFIv0jHUoycTLkSU8QqCP2q7onIVKaL9DIJgPA6MR3P4+QcQO1ocBXZo3L6kcDZxn8Q9XGJVlId9zfgu3DXTkcRThkRvf3LbU6iMhVoBRrUr5NoegT/Y7q8+HW7xOyjjULuYgQ/4/GV9UK6OqrLMts7ewHT3GyPlAvDSVrdL0tk8zNDThjvUhcgxhzAy+ZiEMPOfJteVEsiHWo
 B9+JQLpi
 cQyyeDqpKVmMe8XP8n2bJBC2/7GGB6iVZvT8mpnaxgWOGH0rY3xhhn8VO0NF1p0f7a3Pkb9w13/biykvmX9eV8pJ0z95C2GUfVR7uRTOG+n0JRrNDGHT3XVUDrkoYfzgXFZhb2SSvtcCGDJiLdhlDNlZQXNYt++l+dxN8DWymhFEiLkN5xfdEnaQQu8jTaolK9g6vHsjmfecT0HwPZV15BVprB/YPNX9cYdxtmmoKke1C9S760MhtRhIGEpZRbT0/5MoG0L6TcAQ8X+If+itgQpkjFJDoFwVSxVMOwNjOD0HwKGr5SnRvOoGy45D3lDDeMtzg6c6u2b9shvdTOZ3giW3PxjWVI3QFjuoDrPw4ORl4SVr5ar+mgH6D7g/x6N7tEiPtLO0JpwqqKjOekfi3zv4Chg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 02:22, Balbir Singh wrote:
> ret of type vm_fault_t is reused to capture the return value of
> nouveau_dmem_copy_folio(), which returns an int. Use a new variable
> err to fix the issue. The issue is not new, prior to this the function
> called was called nouveau_dmem_copy_one() and ret was used to capture
> it's value.
> 
> The bug does not cause a real issue at runtime, the value is used
> as a boolean to check if nouveau_dmem_copy_folio() succeeded or failed.
> The different types should not impact the execution of the code at
> runtime.

Again, spell out that it is a sparse warning one way or the other and 
ideally paste the relevant part here,

Also, take a look at the definition of "bug", like at wikipedia

"In engineering, a bug is a design defect in an engineered system—such 
as software, computer hardware, electronics, circuitry or machinery—that 
causes an undesired result."

Talking about a bug when nothing is broken can be really misleading to 
people that watch out for CVEs etc.

-- 
Cheers

David

