Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 057AACD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 18:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3166B009E; Tue, 26 May 2026 14:30:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA036B00A0; Tue, 26 May 2026 14:30:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F71B6B00A1; Tue, 26 May 2026 14:30:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1186B009E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:30:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 07A431C16F0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:30:07 +0000 (UTC)
X-FDA: 84810410454.21.9B07FA7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 47DD4180005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:30:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="K/npMv4i";
	spf=pass (imf16.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779820205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3FRlLZpzWAQ+ivPb+ne/d7YqvU6Y39kZKobx/lLyB8=;
	b=iYliDflcPgTZTmW/6XPuR3GpvOW+NbaGUIsL/cc7yPT9RfBwHoNKOnwiBqCdS74T4LhouJ
	fG3cc+jhHTt/vQCfisQ2G0Qopr3kdkrNjgHQ1rujpYO0gNx0uaGOhICOSuiaP6KQTfvono
	9SuNRNLGzQPav/Dx0npuBiQJ4KxgOtM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="K/npMv4i";
	spf=pass (imf16.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779820205; a=rsa-sha256;
	cv=none;
	b=ryBj4WPQljp4oeWUIb10UBfaGP8o2pD7CjhkvOwzXByd+kv/3HHXyrSh6g/DLRjESelw1Q
	ZKFUhVDzyBvEUyJZyjA6Qs2d8BP1TKRlzDo2Ae+RIj5+Uxg0iND9L8NUo+4UNnwoFO//ff
	/2wt/pLHw/r1H9sMz+Raf2FXrRBpKJM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08D0F2936;
	Tue, 26 May 2026 11:29:59 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3E1B3F7B4;
	Tue, 26 May 2026 11:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779820204; bh=6vvHGcSi157N+oB7lexlZ4A6+hiMatNMYIGzRqF2drI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K/npMv4i2qW9g/9TU4YdmxeRtolv5aI+yYuxqrzCkqOAO0TfYmwr/9lGtagn5lDHy
	 kUb6WYJsmvaZyqjf/yYSt0EfWt0QBpXZkHpmhEWeMUAzJZg2fHl899jOyYpLoDya1L
	 fdhLirTeIBc/bG1S5sbIByG52ch1pvgV5xHx5sq8=
Date: Tue, 26 May 2026 19:29:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v12 02/15] kasan: arm64: x86: Make special tags arch
 specific
Message-ID: <ahXmpvVwV4wWLFxT@arm.com>
References: <cover.1774872838.git.m.wieczorretman@pm.me>
 <6080be7964fc726327186d5bf7979e16ddd282bb.1774872838.git.m.wieczorretman@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6080be7964fc726327186d5bf7979e16ddd282bb.1774872838.git.m.wieczorretman@pm.me>
X-Stat-Signature: yyi4mw5ikodasjrq795e6xmb4yj54xur
X-Rspamd-Queue-Id: 47DD4180005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779820205-690643
X-HE-Meta: U2FsdGVkX1+HdhFHWdSLhpsHTwAnN+srR5yA5UJvlUUsnxx4eJT81RBTeSj1UyKFLmlWsiTdbk0Rcv88du/KCApjCoAyA/0/1E/M3F/rLx4FvGEwH+yA4O8Guse2r4RNthNmGbh6tvj92lyKEB+FCPU6x/Y/9XAIHFmQUnvWhwqMGc6OVhVIV2Lo60B076+u1uhCuFv6fjCGLgFFaVTUIOSqKMKZMB2dgutiau3YX1FQZS6enbHkAjcbaqy4eSw+udQ7YDpLKpW9oPcAHlbaF6zyoGsF+may1L3/44PWbkfdxl8PdCOj9os2LhWa46cnPu4vubqeoIyeAJ62vpD2fTzqvBiBk/byQu431kQu5n2d7ahWO1keaMk+i3oiUAe0OfnqZcSG+08XTVkyL9Wd2zBZd5oyXBAFFqFgJXnIlCbvfAgWq3cDxz3gY/b2ok8hyYgglZ4iIzqI0FywHUzLe3cYV7KX3o3dC6UUB4VhfDl/j0z2cTBWh8y9MmD1X0S0DamZcfEmyotnRsDF9K4jW6FFbE3PIe6TyxwJTnATuobWMaH11jWFloy6j83nfne9kdw5lTKZy5PaT71pv4P9tl8CLxUFED9anjukvsguNxo0rNN+YGCUUrCyzXQRHTKbVARaFaGI3J+BDHXKIHsMdwQowduF5PF4miTuVfAvo4fUrzsDyyxOSZcPzTyjngFuvbXFLGlLfaa0aDA7294VdA2JkgD7zpdUjcu5VkH3P0iRG1lPkaoAp7GZwV3dQT+OO66ySCgSkVyDz11SAi/0AM6oWljqsAdkqaAGm/tJT32gEQYedh148Q9NPu+bwAXId4WDBh3swUAcbXhYp3j8Mpaw4HbYv0mUQRSA4p/mHRNzCGgPeFL4Mp6gzPZBsPy+7h2Rux6fyR0lHgVq038vJ90zFCyhfrs3PRRKUpOf4HM6OEca5hIe/Gxe0NXcgGPchnelWp8SsgJNBBcn2Nu
 rin+3ZBz
 qWQXDLOy9KabtWsWve4kdMX/BlviZlPUsXyEEEBvbP7UZy0lH5dfqk5h2J4zR44tw0TYNr7oyokGPQQ+WiS3Ea3YoV5omO1D91Nxw/g3EFJ+AmwChQcA/CE3Mq/VobKmpslsZpQ27mz4R3FKpQH73BxjsJ29oVOovPVG9HYLACwKcqXDdh9UD6tIQJsFXok/6kz/owpW/m81m17INOBxm4l7IZ5unIAMrEAlxsg+Goc5r2vyHkgFLlg2Hxu2SooSGEun28hLVHlzm6UDCldQTLV1p+yzMQQITM+rlBCiGLGHua8mnh6tLHCTrxCDpEaS8TVP0W1cpSvrXaNNLbe7Ho4thOW7aoA4SPb0E7xzbTyEtuXnIbySZsZab7vNqIrS5S2ebuS/y1W1hk1m7PYY3D9Ngklx6s7pLAlPpbAi0MerQ8DO8Y2kQaUQup/y5DX7cy4Mv/Q2ORunQiX5Mfg+liqFLHGLcowY1DDqaAgoPn4Zuw3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 02:33:16PM +0000, Maciej Wieczor-Retman wrote:
> From: Samuel Holland <samuel.holland@sifive.com>
> 
> KASAN's tag-based mode defines multiple special tag values. They're
> reserved for:
> - Native kernel value. On arm64 it's 0xFF and it causes an early return
>   in the tag checking function.
> - Invalid value. 0xFE marks an area as freed / unallocated. It's also
>   the value that is used to initialize regions of shadow memory.
> - Min and max values. 0xFD is the highest value that can be randomly
>   generated for a new tag. 0 is the minimal value with the exception of
>   arm64's hardware mode where it is equal to 0xF0.
> 
> Metadata macro is also defined:
> - Tag width equal to 8.
> 
> Tag-based mode on x86 is going to use 4 bit wide tags so all the above
> values need to be changed accordingly.
> 
> Make tag width and native kernel tag arch specific for x86 and arm64.
> 
> Base the invalid tag value and the max value on the native kernel tag
> since they follow the same pattern on both mentioned architectures.
> 
> Also generalize KASAN_SHADOW_INIT and 0xff used in various
> page_kasan_tag* helpers.
> 
> Give KASAN_TAG_MIN the default value of zero, and move the special value
> for hw_tags arm64 to its arch specific kasan-tags.h.
> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Acked-by: Will Deacon <will@kernel.org> (for the arm part)
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

