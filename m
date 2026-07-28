Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB20C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 06:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC89B6B0095; Tue, 28 Jul 2026 02:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0226B0096; Tue, 28 Jul 2026 02:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD3F6B0098; Tue, 28 Jul 2026 02:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF456B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:19:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E6621C0069
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:19:16 +0000 (UTC)
X-FDA: 85037183112.29.5D9F47A
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf23.hostedemail.com (Postfix) with ESMTP id 98E4614000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:19:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=lGjcRvGe;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785219554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uMSlAg4H80uRnLlzygyMggmh5xo1htbT7Gs4J7Mu4X0=;
	b=QyGsvQH58fPc71a6Y9ukkf9uHKByH5aFsOtAQQ7L/KzSyLEjb0MSxBNuema/2QuWdrdopD
	pJhxOQKKwoMvPeTekBvxASYr2sw5sYKjboxeLn61NN9lOD42gUOQ1tCMfNeIe9gFRI5DNL
	BVoYJYeRit5NxRpYlP/wpZ/8dNsoiSw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=lGjcRvGe;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785219554;
	b=scHao/AjNrV3sdZaPg76AJPGI/4J6URG0lIMraXm6E1zMchAJnTkZNtP+TM0L0jFSo0xxk
	QGe0HyPwiJwcGFVEWjIl6mh+BFnjafIz2Na5PzHQ886tH0/3r7CH55pZE7/wl6vaZB0n5B
	/ovsTDU6ukw/CRqfL1uDDW+sbxC+WbM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785219548; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=uMSlAg4H80uRnLlzygyMggmh5xo1htbT7Gs4J7Mu4X0=;
 b=lGjcRvGeA4xjfWVtvy04vgeocGnG/m+Sng3Tr5trR4aV+URFh9SFcJc7/cJZGPWdXqs2S4
 1HTUiqPAyGB7YrdXylVieFBCk4V6mQsdgSi3Qp7dHAaMuD6+CXz53JsNBGjtBCbzEMHMNk
 8yV+YFtH+eHn8kkGM2qeoYOBxrDjvJbnAQZHa+uTVmUm8O59yPdXPsA+lcQbuTzITyNrWW
 dmOzgZTCHAWCLWM7AJzFYBMZT1lkeQSNRqdWJg2C3Ncb2audeaDBaZui4G28eZLb5wBAVg
 y1JnzgPS7JHEEy5Oan992vh2VxYRRLT+corWIERzo0PGBw9r2dNnkM2kyckKMg==
To: "Andrew Morton" <akpm@linux-foundation.org>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a6849da+627855+kvack.org+lizhe.67@bytedance.com>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <muchun.song@linux.dev>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260727135725.694139f5ecad67752b0985d0@linux-foundation.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v8 0/9] mm: optimize zone-device memmap initialization
Content-Transfer-Encoding: 7bit
References: <20260727123429.5673-1-lizhe.67@bytedance.com> <20260727135725.694139f5ecad67752b0985d0@linux-foundation.org>
Date: Tue, 28 Jul 2026 14:18:44 +0800
Message-Id: <4d71dc0f-dce0-4d69-80ca-bdd8047eb9da@bytedance.com>
Mime-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 98E4614000E
X-Rspamd-Server: rspam01
X-Stat-Signature: nfjc7b6y73zfupxayqei4oqsesrqip8k
X-HE-Tag: 1785219553-551417
X-HE-Meta: U2FsdGVkX1/ovf8WSzxflMJdC42quGNF+ZPuAei0bVj3dE7L0meJTW7C64eM4TNuiLGqb8sU1j5tLwx6b82iMgx7dqhrR/zxL2DnpdxoJLaMW6swz5Kcho3NoN5fj+lZpOt/Us/MdED3zf7An13zc2g51ZySdqCsW7yJ0b39Xv/vBKK+yy49qnnQprQdo2l7qBYkLxWDOx0+GdjFoBAeN9GYLkxdvpGJx4X/3lLEbPCFk/UY4qj1eNsT4kuvuUgdAvFxMP5a3ABqXMhpkai1naDqGlVMPrWmxvz0K+jGYWWuDAPutS5LthR3JIJ9QvsYoW5Wu8JwEwtmPFUZhJFL5Ee7sTa3Mict+ZU/YXOxqfHqZpR3dwevc606MZQ+QcmE4cVeHFO5/JRdsK5y2jn/KqDEWVz7zpvo/xeQdBXmHPklpfy23L9azupOYLTKIhJMxQCFWYakcG9Shw4YnD+6NjhDTssyVo7ojZ92jorObo0xevADHLeEkZobZeLsUF3wRav/GR0q69NPwi8C6yrTfggdusKo17ey2XR8Dw3cTMkg3Bhmumn3vUdZCuO4R9uKILp2mggDjUECCrg5xHbcEJpH8kOiYtHWVpiaU9Y4+OtwlQ/GTpNjd6DCx+EpsGUhHXmOQsM8ocsiPf2u9T0vu2AjUnszwdQIHvVa0M1MlqGSj0mykh2T2+0cOuH1VX/0Plr3/WRWshvTESe/A6ltJfuNn/aJ7LUTZSij6P3uFcjhKmrplb+T71khoNx9lSKLdiedqHZi2kEeLvD2pl9j33YW9QQV7eHJnBVZxh66cIZcdIWOGsLNC/iGInGBAKwkG1+YoIgct9Df6ccUsd/jHAn2v3fKtCRkdjr8OkEFZZSsWXJXH2x/0TEAw667seEuFTvphF2x9SZyIQf5073BANud7/2AD+3C600KSMji1U+oZq7/Vm8F8xto8sujNQlRmYqytY3zZS7mBvaF9/o
 PlckbEuu
 x++QdaNY+Ps1rw/5IQymqKjml8+v+eJjiBjv+2YtYWfBiUhtc038fhDH6h6hi+gcH5ejTF1ktOsfXLskYLH+k+PBbmR37N+SC7rs1UNAeLpo7BhGKyn2squAcslj0DB42iklxMzdDNG8lMAI8xiewzVymGID82MDpSPbGEnUlP39u2ESuHfBq1qBJaG5PEhg+YVgv/DZkKgneIy30AW/cKKLZq/Pi8M8gse3hYxgLjM4R6CtHcubDv5HpM37nuUyAr7grtUncE5WvjWrEftxxnoe909p42hl6jDZbQwJSQOWBgXcZHbnHaAuHIVeK/CHiZMEYK6xb0+tNgZM9fvsbc0KKIFQg/ZbUO8PUDnVWokWcbQwuOf85Me/D2P5QkpngAHp+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 4:57 AM, Andrew Morton wrote:
> On Mon, 27 Jul 2026 20:34:20 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:
>
>> memmap_init_zone_device() can take a noticeable amount of time when large
>> pmem namespaces are bound or rebound, because it initializes nearly
>> identical struct page descriptors one PFN at a time. This series reduces
>> that ZONE_DEVICE memmap initialization overhead by reusing prepared
>> struct page templates and, on x86, using memcpy_nontemporal() for the
>> template copy path.
> Thanks.
>
> Human review started out strong but petered out later in the series.
> This often happens.  I'd prefer to wait until it fills out further.
>
> AI review had things to say, as it often does:
> 	https://sashiko.dev/#/patchset/20260727123429.5673-1-lizhe.67@bytedance.com
Thanks for the review.

These comments seem to mostly cover the same memcpy_nontemporal(),
MOVNTI alignment, helper-level drain, and sanitizer/tracepoint tradeoff
topics that were discussed for v7.

The v8 changes keep the x86 non-temporal copy path unchanged, except for
making the generic memcpy_nontemporal() fallback a void function-like
macro. The remaining updates are clarifications in the cover letter and
commit messages.

So I do not plan further code changes for these comments at this point,
unless someone points out a problem in the previous discussion.

For the previous discussion, please see:
https://lore.kernel.org/all/20260722081800.90085-1-lizhe.67@bytedance.com/

Thanks,
Zhe

