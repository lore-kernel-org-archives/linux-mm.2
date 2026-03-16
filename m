Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EC15F53D75
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81CCB6B031C; Mon, 16 Mar 2026 12:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD6A6B031E; Mon, 16 Mar 2026 12:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E77C6B031F; Mon, 16 Mar 2026 12:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6F06B031C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:49:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE4901B75B4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:49:23 +0000 (UTC)
X-FDA: 84552511806.06.F64D9E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8F1D14000D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:49:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S18YUcU7;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773679762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WakfSAFgJsfsw3SLQ4DCbStO+7KVn/ukqGWzev0uLAI=;
	b=fA5WuitRP8DNy8b/Ru8ublySOGL+zPN8/jYT3Gmq+e+T6J5YDqgaZ45eWzThM/clCgsGft
	2ZJiSCcQTDYFOkP9mu5a5IRNVc7/OEj5ouoTl9O68TNchUO7sBk6R8VpIcZLjA+C10oJRQ
	9+OOHqCTjWDStj0mCTmfKfi02PDi06I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S18YUcU7;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773679762; a=rsa-sha256;
	cv=none;
	b=fkoeY1sikTwprID13sryq4udA1DAfffVYVnjbSqYVuxek43BDqffmo8X1Uv04V8HRlwd+q
	NaF56mk3VoT9yHzmBV+vHE2lMSrKpaSZh1HJwmK30RnuVNk8W9pbuufZCjHBKQ0FtBRbLa
	jTO4+WuBQ5LKUpF73Ved1g887bfsLDU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11E624376E;
	Mon, 16 Mar 2026 16:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB465C19421;
	Mon, 16 Mar 2026 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773679760;
	bh=uk1xHHKJArXOa0D/n6OA2egxALwqJwTNCh5fudHqvn8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S18YUcU7zj5dwedocu26adSAA6wCoD342MiDux8Lqox9E5YEW7px8XzMPZp3l/GG2
	 X33FV25AdFzEz9i8jaHd1X8c5XpHUxaZjGA9Zv/wuFs2gDGu/nV/KA+76Ac3D3AyrH
	 A9iiph3Q3pTq2hmxvlXuP7RB0tm2DDiDaO+iLDXr9H/arruE4C+HDHB2PNVGllDs2S
	 /IoWz8Kdo8wG0x7VrpPDsKDlQiSspFfZm6qMVD6jbHD2bgbR8g1sHxgtniRnTWPsJv
	 8jwOMtYleOb+cWDLHvCGbsP9ly6WhoA1uWte8qt1uQQqdytuSnqZ3l4Slx/aUFe5rt
	 za9JXBprOuoZw==
Message-ID: <3ac4a544-53bd-42e7-8191-ae9f79aad5e9@kernel.org>
Date: Mon, 16 Mar 2026 17:49:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 11/18] x86/vdso: Undefine
 CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for vdso32
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-12-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227194302.274384-12-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E8F1D14000D
X-Stat-Signature: r3n63e6d7q35obtr433y8fndoxfqosmc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773679761-129083
X-HE-Meta: U2FsdGVkX19ao/VpYBJPVlVg+L1b+uvQb5U/Paoo/EEs46XhCuDJbK1DqN4/6vD6xR8x2IBfi52X2te3XLVf1AUbymE3LEdRYIT3Iy65spryxfIDEMKbdctXuY6yqn+ZjFTZbXWdUTxfHpMMSccH+oayuawyl5/eLirrU5KK0VnDZLuWPz0f1ylgMmTaALlZ7JFPi2Du4LI+emCgf7PjlnId5IUlTtoTlluYIKA4YEZNlQ0L3Yn5o4QpJZQQ57/bT2u1xzC3c7F4SWU3V9+U3MRvvtOioCZi2vpU3LAg1ZVhYjdaDluCAwgSgR04AT8YMDGLDPrWiBwAF2vdT47fFwjxxluGPj2qZFanQB3v7q2k2wbwsQPXgmFPQDFyTvm4d3EQbQyzy8LjcASd6Xg5+V6tVff9ax+8gJ9idCa2Wcttor7h0rk58jUwxItoY1PQ378GDmaJzsZxKWsvznCWsPYBTG3YS9FD6mruH/yNAhPnciRuGIODsws18l92PFX3J9kdyuk3qGxbGGWr7cAVow6NY+u5prH+mLq0QTVSN2S2t+4OnaAFcF54FaajCxLX7yn0elfYWtELm46F8KLTdiaDnT9NZJoI2X+wTZyD/debH7JhUEIcOJslZxIuBK4QfiBCLtu73F1jLQN1cXYr2qHK/W1BeZkuQTKnr+WYSXndp1UhVOtmR7NjLJ2dsQr8U/9ZTrU+CSbRLCgPpFnnxqHIriZt0lq5eEbDlP40kExtJLjV/e5oOEwpfHR0CGt2F+mxOQPx4XjpmUIpJqnXFglfMLBfZTaOXob77hhlVUC2Uic8WCW8hlpDGhY7TEcVWGl5mZ9dyjzcRpHQJW76M4Y2jTIfJoWGhoEHb8Li6Il5HgtAHIsBiNBAjmk5mDA1IX733QmbGeQSHcuU41b26Xq2ds4jNGoJHzrJ0dGnKJ5MLbToSpRGlr6lz5UV8d/gHnP4q6UKHgZd7u35Zre
 p2vU+2E6
 6m1EbUkpdKmTLSD8wVxPn2fVlI/uyfvATiTNe+RxpiePWbyFcpAgmb0xQJDgSNhxONGMAIV//gheEo7cGL7RCKJsw5v4t/vVC4CK2JsA8eiBsettWk2SRuWjGWolMkTDcCa3OIMaTfLumHkkRopqqnOH9q6BkuJY2u6LYw3PMzcft9PwFN4o6fqWLmg+5wREdR4YYUGHCym0S94b5owwIoO1NwhhuTd2c+k+IwBijM1wQT2kJK6Byn2bJtThrmLmM1OglaJjCgP+AzpnxBzf21ceKA+h22VKn/yymt+Y09B/VAgWSTR4yY55X1UKJDY+4stPR4E9JKKGnkXI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 20:42, Kiryl Shutsemau (Meta) wrote:
> The 32-bit VDSO build on x86_64 uses fake_32bit_build.h to undefine
> various kernel configuration options that are not suitable for the
> VDSO context or may cause build issues when including kernel headers.
> 
> Undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP in fake_32bit_build.h to
> prepare for change in  HugeTLB Vmemmap Optimization.
> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  arch/x86/entry/vdso/vdso32/fake_32bit_build.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
> index db1b15f686e3..bc3e549795c3 100644
> --- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
> +++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
> @@ -11,6 +11,7 @@
>  #undef CONFIG_PGTABLE_LEVELS
>  #undef CONFIG_ILLEGAL_POINTER_VALUE
>  #undef CONFIG_SPARSEMEM_VMEMMAP
> +#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>  #undef CONFIG_NR_CPUS
>  #undef CONFIG_PARAVIRT_XXL
>  

Pain as always :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

