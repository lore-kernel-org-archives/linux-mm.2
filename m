Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A5BC4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 20:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CAE6B00A6; Wed, 22 Jul 2026 16:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3D2E6B00A7; Wed, 22 Jul 2026 16:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07E06B00AA; Wed, 22 Jul 2026 16:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA3D6B00A6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:29:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D4131202BD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:29:47 +0000 (UTC)
X-FDA: 85017553614.30.1D0DA7B
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf31.hostedemail.com (Postfix) with ESMTP id CB60620009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:29:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b="mW/pv4H7";
	spf=pass (imf31.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784752185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZenVVn2FbCkGx5eN7DH3cc/7/vouTK11eR/A2iTBKg=;
	b=SZ+veIGMfXaptd9eqF41zuGodEO+FB6rvO+mh5G1YGuaYDCeHuMV39BqUFS/S185LiR/Oq
	mhwYqgWDAwD+Voj3Ksed3AaBkwnXnPJWH53N6eObH7qjs5RNCq2HScRXGtv57gxdV519bK
	dJt0OWpSalDDWLe6zRdCv3R8fENTQvs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b="mW/pv4H7";
	spf=pass (imf31.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784752185;
	b=bntEYLiIoPKqmXE1oVGr99rxfRqExEJAWwySqD53yB9DECrD9Pbf/HWj0rAePKGGp/vWl2
	ONahWth9FXEPqV9xb/8qRQ9Ig45N+m/B8y6m0HFctGE5geH5ZxK3fU8aNMDaCcbv2xBcaC
	by4K+h08hbwiIdP/3bZ9MWeFnXr5kgA=
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 66MKSjqC1278121
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 22 Jul 2026 13:28:45 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 66MKSjqC1278121
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026062701; t=1784752128;
	bh=HZenVVn2FbCkGx5eN7DH3cc/7/vouTK11eR/A2iTBKg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=mW/pv4H7D68XMTeHNm3fkahmI1TOoQEIJW+FwVE9P9RGRCZMU1yzbf00780LWbIf5
	 lMWCsDDWgkZ3mQzVdUbc+FUFxB7JHa3IfHG5IbCuO8SZA6RTlV+u0eNfDswjtkOwJJ
	 Y2hRrVSp1jdcROOVerDK5arOVeJfRBuUCw2mWnH5UEIVqM4Sfocn/bTEIR/tUd1smD
	 Zaxm0lLCm7G7q63HYdxg5RWgzqqc51+h+OCNW7g0YR4tmW0S5bxHte7PAw5QRC4Ie0
	 FNPgy+3wnQSj+WodmlD6kmUH+2AJq2gPFIl3XR7z52JBDBgAbc8SIQ4cGUTO4UriAI
	 ZJk0nTNhjK4sQ==
Date: Wed, 22 Jul 2026 13:28:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Dave Hansen <dave.hansen@intel.com>, Yeoreum Yun <yeoreum.yun@arm.com>
CC: Russell King <linux@armlinux.org.uk>, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>,
        Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
        Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Stafford Horne <shorne@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-openrisc@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_RFC_v2_14/20=5D_x86=3A_mm=3A_skip_pud_setup?=
 =?US-ASCII?Q?_when_using_generic_compile-time_folded_pagetable?=
User-Agent: K-9 Mail for Android
In-Reply-To: <3620750c-54d7-45a0-b067-bc813dd3cd9b@intel.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com> <20260722-dummy_ptxp3-v2-14-d9e4bad31e0a@arm.com> <0ea931f1-4801-4d32-b6ce-4787a8d3daa9@intel.com> <amD7ab_KuJPdBQBh@e129823.arm.com> <6f5060a7-0a64-49fc-81a3-ae88729ef794@intel.com> <amElnEbvRTjv2hyU@e129823.arm.com> <3620750c-54d7-45a0-b067-bc813dd3cd9b@intel.com>
Message-ID: <1064CF47-9371-4D9C-B2AD-1457CA41CDB2@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CB60620009
X-Rspamd-Server: rspam01
X-Stat-Signature: z8nfsohgw7wd5q7tz6idipe7stbbtzku
X-HE-Tag: 1784752184-148210
X-HE-Meta: U2FsdGVkX19pOIOpus/jc3abSow5Ob0HnCV7NZwe38iXdDdKMHYQIXwqN1JqInevH25QGYzF2tp0v+AP47JaLq2O4ypcjC1fO3vTuKPKiA4MqA2v1KYa/jLLVuLIC7tJ4jkwZPbTXWt6npofQoCBFZE8FtTtabdWT4Pt4iHn+IZ/En33ZOWsoxUTkcgL/XfDAMxFsLK208hIsLVvb++DI0WyzBWG5VrXAwlRljtCJOsLM8JppKW7t5KouHd8uNTgoXCVNgjZWz0qHUoI1P0B6NN3XlbyGTXaunoIApNTBLbU9TNz86LYpTcwSl+ePVCq5DrQn6W3wekYsJ8k6RCZpbZkN8HbhooXOZ3VA8+lHFS2MWD/yzNHk5qRmPbOWUs3e31znUL2WbU1smAsbKltZeRuUkTc/ZD4vcrZ548i7vPw2pU/GklXAkNwvfKPGcK7f8lQ293FEkSM6abYwXBWr69lXL3WYRrv4C1ZCqEK9IYzEuqiZyJRxI7xbdNAbPBU0Dxs1E0dCj0eSKrkj1uMM+DgKD9mD63w5EAt1NsxRDAhDhOlyJNUSPh1LZnPfqo3pMpjPIMEWNxyukZ6aFCal+bzv7WcCqKFsOJEcnhSIHEpoHJknygwNg7Yzt3s+fEfwOV839I3moxrT1cfouvtoLLdaE9rjLrKyLJK8qTkm3VBxaPi2sBhFYPNTTHPPqX+SpBtwuoyozQ6jBElIzJzXvh4dR+FNCo2oJJ776Fy2uzHsWNW+Oii27OelcVvk5xYgtj0Ba8puDgWf9BDL1nRKFU5CGFVwTJkYSXdmpARXrxxOJGU8AulakcMhczs9ELkbR5GTK0COTZGcBDEgsOjKVyv4T9IJpcq6qwWyJ5qXef+xHT8qAB2bNyOf/Qdt4JpniM4DczYtDdCuPnRtayCAYIpYIA3NOLJE85ft6f9DTx92Me4pnMQqIKGF5YDUtupRZrzORd9zLx2TDxUG6C
 +8Z9x7LX
 EFAqFCAZ/frAcSWc1ZF4+shDnBJY5XMkTVS8GpBnEnWZzIbJviqh+u4TcLLFmraxV8X5vFpoVlvmu1oKL6IIJPt0xST7tU+2gblmAVBn6CsAxYRwK3JgwOGDHe/Z7CwOTcvHAF7aV7DHmG09g9mCI8Vs7Jp+JaNH5Q8leISUwFmBhJ5rcbH0Jr0olAIf8V+vx1mS3golIN/HICGUMhLTJGC6rCMuDOy1A8hjmWT4iAg1/bWPjsNM1TPzSL2T8pN3dj4bVfwO6x/LZIOZ/dlY5jAz38PiW9hmpIu5n7CB2Rdo7tlfp6tEtKkcEDQCQJb2huzQZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On July 22, 2026 1:22:04 PM PDT, Dave Hansen <dave=2Ehansen@intel=2Ecom> wr=
ote:
>On 7/22/26 13:18, Yeoreum Yun wrote:
>> Sorry=2E But do you mean check with cpu_feature_enabled() not with
>> boot_cpu_has()?
>> IIRC, the boot_cpu_has() doesn't use the DISABLE_MASK_BIT_SET() but
>> uses REQUIRED_MASK_BIT_SET() and I don't expect it wouldn't make
>> an optimisation to constant check which is contrast to DISABLE_MASK_BIT=
_SET()=2E
>
>Ahh, yes=2E I forgot about that nuance! Moving to cpu_feature_enabled()
>would be great!

It is supposed to=2E That's the point of the required mask=2E

