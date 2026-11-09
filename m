Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04192606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NOZ0F7Sz
Received: by kanga.kvack.org (Postfix)
	id 108796B05B1; Mon,  9 Nov 2026 04:13:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9FF6B05B2; Mon,  9 Nov 2026 04:13:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB206B05B3; Mon,  9 Nov 2026 04:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC3616B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:13:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F1551205E0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:13:43 +0000 (UTC)
X-FDA: 85415017926.05.543C763
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B749F1C000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:13:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NOZ0F7Sz;
	spf=pass (imf21.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794215621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WewbPdXloQFzq7PxEEzYBZGym0dDSEfWIKjsTFPTFGk=;
	b=oYAkUo5+ehca1KQxSzf2PiW9lYp9zPIvNUgn+YLMrU3bjwvhhwdTO8aTeOgbf8+sz3wVjm
	F6gLrrCCFTYW1tO+tIJCJ/UmSsQR0Q0fw47HhFJ6kRCPMq+M7V0zqfukzVDGR6m5BAnGCb
	O5/JdMIVX8Eud9+5bnhnv6JbfD6UEuI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794215621;
	b=rSuVGAaMC5HJ2AXYDqEEenL9iEqSHAHjfAVZ0xXDb9FnQDpxro+BQTUkwl5nWKTxKUs4K2
	wYFLAbbMne9KWonMX7j186SsC44y3YgplGtt53LuqYzKn1erdWdL4jZ9ivggpCj0W14HwF
	dbm0gQyXF33r9mvidgLk+h3JsgMyOmE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NOZ0F7Sz;
	spf=pass (imf21.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BD7962C5C;
	Mon,  9 Nov 2026 09:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4C11F0089F;
	Mon,  9 Nov 2026 09:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794215621;
	bh=WewbPdXloQFzq7PxEEzYBZGym0dDSEfWIKjsTFPTFGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NOZ0F7SzJk9PfMsNlARgiXEIR4TN3eLHPymrOqc17Hg6gYCSHgCMTY/siLKpUXLwG
	 PtGySWokir2nJ9/OVyTHpDcO+k9ORd0fyT3OIqzPu0euhsC2ZQ2J9CtU6gSLMhSmtR
	 hw+Qc3i2ZwYGwqb8FVZVjff2b+oppBMgQCCCTp4diDqXgm2arWMlEMKtnVVoyZf2Us
	 JXTUMKaDfCaVQ4WDEz93/9xvApuY2WP3EwoI/fGfzyiuljc09UCPzcPb07u2eHAIU2
	 fv6kzYaUAXJ5Bz0wagLvKx9UU2UWRNL+lN1x6988/PDE51tdD4eG9pRfxsXpHteHL7
	 dxAdg6g89FK4g==
Date: Mon, 9 Nov 2026 10:13:33 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] x86/mm: Tear down the direct map when memory hot add
 fails
Message-ID: <avGOvSHAJtzeUr3A@localhost.localdomain>
References: <au_l5MRyDbYfsUVe@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au_l5MRyDbYfsUVe@chrisdown.name>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B749F1C000E
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7mr5s7equxd18r4x55ux76ercde337yr
X-Rspam-User: 
X-HE-Tag: 1794215621-725793
X-HE-Meta: U2FsdGVkX18V4bM8HNYRKuZFLPIItu1Fr899/iFjbDHyOTtSywXNqg131TphCC2YPjDfuhPVTQY4iN00DjGI7wWXQXUebnam4CsHCOZYWg4wC7XAPBsfoV6mreJQMYSsQNwcGSET9xmJiPLKzJzaXUyBxhAj7PEMIKn/2ROJ+DAykgJgVqxAy/1HESeR9a6ETvhjpXPvUn29zGq1YFmkEb4I2V3ukswjAUYsBA9bW9aw/ZVIWUO/YY48utWecb9+806WPNQ5rt5Q3eyNAJO2mF7BufGv5EVR9JP3vuuym4DXhmFS07Ampw7whZHr/I3J/KfpSDDSP3hpqppFxNFoczMs10LUIeOe/7xsmYK29marzGo9rLsVE1nqz8ysdu/U5E63ejz34Jsfk1T+aBXkF1rADZttL4cuhHplkYMDT63uL51ANTOkRQjPq1qPo/12YgCDzpbLjz95aIEK4tHlE8N+XX7midzHetutyQQfbTkH/8hQQtHG4oO4fTaajBcY3JbO+jCBvrYovX6Z0ORYX2vfdN8KsjTMzoBhhNmYX7EemNvNuett3wNTl+x6i1Te8xu7u+211vkDm4/aANNh8K+RVrSouxg9NrLtk76EyLnapHtQyMC+8U7ZdoJxTnXdD+OMAeDmxgIEHf0hx3eTxsrcaDvfEnCdhl78r6YqNTXyVrqgad/aNj4/cSjGasz+Cb00qPDK2hz9EyGblMfHqgO1Md3g6JalcTiXMpFfuunJIO8ohZMp8sTXkwLB0/TPNIQW4gC5K0gedWakpiqGeqnH69RY6IAWbWzNbBt7i0kjryASJ+dF8FxsieOuALkaej0/ghQwmxyirnwKtyK1TyGskTE0YUsOeLSngh7t/FFoxa76642azkdT524q/iZChDv99KWo0uzseHNurt5DYImpY301nGE8TVM+zJwMtNytkz0BS0ToKltdo7QGFI5Ux3ZhTMlXYszki+ci3UI
 06gJblrb
 tnijbG2poLPOKC4nHyWdeB60CoRd0+nuDmwXAHkVLHmpu5/lF2fIv0+XQ1/m6ICkmedKU0sqtFjryFIXJ/c9IPf7ANlC0Pk/ZS14DQ3KC6j1XnuHZlRSvPR5Vcy4NaiZjg2+cyEuyTTWs4YXeQF1s4C/JjHN/Q0vfZbDZKUTv/VWRieBv9g88R0IGSocas++7YihgNIC4AA5IES5257IkXdnGoNHgBEzJA6DAe/IWNiRxi2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 07:00:52PM -0800, Chris Down wrote:
> arch_add_memory() sets up the direct map before calling add_pages().
> If add_pages() fails, the range stays mapped and any page tables
> allocated for it are leaked. A later hot add can reuse the stale
> mapping.
> 
> Remove the direct mapping on failure.
> 
> Fixes: 45e0b78b0532 ("[PATCH] hot-add-mem x86_64: use CONFIG_MEMORY_HOTPLUG_RESERVE")
> Signed-off-by: Chris Down <chris@chrisdown.name>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>


-- 
Oscar Salvador
SUSE Labs

