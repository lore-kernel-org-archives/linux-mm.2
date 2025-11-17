Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F59ECEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B6D8E0003; Mon, 17 Nov 2025 13:41:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BFB8E0002; Mon, 17 Nov 2025 13:41:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761FA8E0003; Mon, 17 Nov 2025 13:41:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 605238E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:41:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F00AC13A0C5
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:41:48 +0000 (UTC)
X-FDA: 84120967896.10.0B630B8
Received: from mail-244127.protonmail.ch (mail-244127.protonmail.ch [109.224.244.127])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3A51B40014
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:41:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=JhmaQYtS;
	spf=pass (imf11.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.127 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763404907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drgz0EubZvWbKD4XfDQItOg+MBM3cOXzoADsisa0KIg=;
	b=bF34KKWaL0o9Oy/oTp7PTgGm95YQLOQtc4K+yTH2Kl10ccUPVQ8vBYClBv57PAtqeSRcyW
	yaQElPKMZWHz9AObzEayEo6YnguAUnrfucYaUivAWw2faKWEKwkZW6CP0rutC4Pp+5YcX+
	pP7PZ3x8fCcJ2LpIaGPtsIkzpXTfqUU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=JhmaQYtS;
	spf=pass (imf11.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.127 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763404907; a=rsa-sha256;
	cv=none;
	b=fAHApTojXtUPvo6AoH1XBeMKkQ3EWeThZtViAcw6qmG61RVXLx8QoEBLP+APoJ3oZQXrkk
	eSzbvL8LS0PeA1ShvyD2HYnq7ajXnb5faletG4Q7CxdXYTXFuYGMWMkeVb+F8a1plDHvMz
	IHgVXg/OI0lnH6YeyESXBXxP2m60YmI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763404903; x=1763664103;
	bh=drgz0EubZvWbKD4XfDQItOg+MBM3cOXzoADsisa0KIg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=JhmaQYtSykcyb/YbPWw44tSyjxwvQu5qj9ANFfDbmQQdN+t4wYrSeoPU5wr8awv7w
	 Nv4+HeHNbI3AYKkBPALDXGd5ua+5005HNaPxAJX8zjyFtD4Bx8B3sNgDDBKPYZWuNR
	 FgB1Gsw62xTc05ImjhbBcT4QlABgPkgxdGDAvgUqxcsa9ajoSzvQkkJViTm7A06PKT
	 dz01/x1F8V82geoUmNU9B033ePiTpKpoT+jMsYrUhpoMOl6yknZtWVEU53UOHxjmLk
	 eDRaMMJ3onhXZSMX+uzVZ2fETutWrQC2UQnuYO5bJ7DY+KapcpkkD/6AI0HVHWxo6q
	 5jsrnA85HeUWQ==
Date: Mon, 17 Nov 2025 18:41:35 +0000
To: Alexander Potapenko <glider@google.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org,
	Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 06/18] x86/kasan: Add arch specific kasan functions
Message-ID: <6nifmxti2xfbnrdtxbosojfw52sofc7zkyjcbcyeawz5lt372f@h6ksdfqddk4z>
In-Reply-To: <CAG_fn=XFXFAvKS2+bc66FR+gw7rfSybETAOBUR_vneaVdF5F9A@mail.gmail.com>
References: <cover.1761763681.git.m.wieczorretman@pm.me> <5be986faa12ed1176889c3ba25852c42674305f4.1761763681.git.m.wieczorretman@pm.me> <CAG_fn=XFXFAvKS2+bc66FR+gw7rfSybETAOBUR_vneaVdF5F9A@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 24219ab0aedf934d23c98a54e0e420cc21587fb9
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A51B40014
X-Stat-Signature: 6fo18awdphwx3dwtttcs18s9wws5xyqy
X-Rspam-User: 
X-HE-Tag: 1763404906-71583
X-HE-Meta: U2FsdGVkX18rQV8uNgSAXl57zaNrGCsgTMsFJNErcxBwlIO2I+m7FAZPLdX93mr/z/rvfLxbMD4bUsEoeU5IPId6BzIo5enGZEi5TSmtMcmKAQMLik8o+zQIMj0Bn2LBlacsDPlSEuSVQmbv+VJzT7Wt/d9FgrN6lOh0hm0ScRokJLw2gr6MteyQl94j+bGZ6CcCPZVUvR8QXbOxTNLKlt+PqdC+nSLJBqBBlIsG+jxxLsLESrYZ3NVxxF46dUj5rxwa9iiPUpFQY8t+v3VS1b7CQwK2+c348UAYRi5Y7qvLVKHdtzg8CxmX8RmxcJFF7My/ZVfFlFT7jqmwDiPI/lin7IzExUOHZR4dtSVlMpMQK2lTeDgzSvTdAOcef8Bs4k/XexbRWPQdaDlnj8Jt4B1FQR9wy2Ve+KbCq6rif2XqJUZadtgIQb3ldTfPrOwMW52WJ7eylE2QAvdJx/5tMZennvJljSNhRa7P0IzsgKNwYRNhzFyqZZofmR+NFygBGEZM8C7YxB6ZzZmU9ymvsy+jyv+g+j70hPJ5+r2ndbAboZKar1HiIzDTHlAu5gBjjfDATwIkZCJiC3NDVyUPJe2zhTzwxJwXu/Qy3x4ALNdgrNcg76HRuIR9NK/1JRuTSfS8o9tA9wnSyKqBS88I3exPIMB7cltslvnw83OLBVpdwwP2DIWCxO6RZfE2qWDKRqCj9Q+oKHd+x2x2JL0BDeVZ2UAvP3L4VWawjKPWAnk8PA6AZfm7y+l7k3bjxQ2FknJf5jmABO3722A/TWKY54mHcdH2zFanUjSzIOL3VjxmJ3+iTQstw1Vmztc2sVqyolY1lNAQr9B/H3gTxRru4aJL14TzC0DRbdI4/qmBJ2bo9AuIkEjN0Ouku9ubgIA6I6BJjqYIvbevJTMRwVlZEffder+4TCpVJeqK8YI+PZ13FzSLAL4Apc58p52pxeCjRAvUfww+HxZSJqA6Wmc
 +AZs7joa
 gbwo1Q/6moPwFVC7QRnnK3hTyxeyaFJb6WasUujh345aD6OlyKSDFw4K8+J3n9lWe0yJNhXHOFcwBUTsdV1leiSnOVgqvIRoiSaEeiWScuqAhXrlXIDnzK9Udt6FNGNns9/+pOwsrVnmzy4JApxjnMY9wrjal9NwzLRQsRglxzF0j0hXJVa1kU56x+xgdbQCqFKiTJ9qT6v+87tDR18j/DEeaOhO0C2EfPsIgKsGXdMtafrOTEBqSlXOUGXudAzmojshy+4o7ac1b8K4XvzjaJNVFQE+CGKo4e6b83Y4LczhYnqnrCrmAlwWSIM3ibrngPTY1/yfKn9LlZDf6JdLaBMpaeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-11 at 10:31:13 +0100, Alexander Potapenko wrote:
>> +#ifdef CONFIG_64BIT
>> +static inline void *__tag_set(const void *__addr, u8 tag)
>> +{
>> +       u64 addr =3D (u64)__addr;
>> +
>> +       addr &=3D ~__tag_shifted(KASAN_TAG_MASK);
>
>KASAN_TAG_MASK is only defined in Patch 07, does this patch compile?

Seems I forgot to remove it from patch 7. It's originally defined
in the mmzone.h file and looked cleaner there according to Andrey.

Thanks for noticing it's still in patch 7, I'll get rid of it.


