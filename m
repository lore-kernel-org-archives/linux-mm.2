Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8136EFD064E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B414E6B0089; Wed, 11 Mar 2026 04:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8E66B008A; Wed, 11 Mar 2026 04:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1736B008C; Wed, 11 Mar 2026 04:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79F456B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:09:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1BB161406F8
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:09:57 +0000 (UTC)
X-FDA: 84533058834.08.ADDF81E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3557220007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:09:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YLFscuv2;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773216595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlmBALjooZ0XsASQSjyH4mHZI9y8l1c4liikiV7dUtw=;
	b=qbpTxPqKcUX1O1GuhLNdvKS4viY5Ht/b0PINQTtTzQjVUTDucFriR2wp54rFZC7hzoZhfd
	isGndq8ZApBpLGtK8idJpXzKxZO3C4OJDUGUBz48KIZZ9JcPzdUEhs8LMR/8WjM7IpDgLC
	WdkZbKe2Zhwsv2xvGP96vWxrwymzji8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773216595; a=rsa-sha256;
	cv=none;
	b=OGyn61L3uJgfe2HJl6P7jSXwN11OiIYXR1RC4856TfNaO8Q575m1DRcD78VCrInGgqVEat
	SNc2w9Y+k5sBm908utqUCjZXH6bHZoaVP3f2T1jcgwPRMo4v6+XeRMlQfXU3Xk6dRDWcso
	bovtIehgrpkSkPVuJsDde8i7Vzq2fDk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YLFscuv2;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19321443F1;
	Wed, 11 Mar 2026 08:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF97C2BC9E;
	Wed, 11 Mar 2026 08:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773216593;
	bh=Ev+RupPFx3vFthuT0C4F0wFHzLiDXKrbll1RNkDERZo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YLFscuv28t6jNAc42r7OavZhQeZvSUNStqr4Q7RFSOURjF6F4a+qrM3dZ18dhGWkF
	 X3Q4wgVwkGzwZkdxpQkPksaXlYEI8vwMn3WBd/AVKeZc7kSwFZpu8HDj2NZbjH1jbC
	 WKOonDy7O7ApDlcBH0pscWiPe+jDN7F4/VFe/CzIqaHf99gDDkESZx8I6jSIUfK7mB
	 vG88BGnoCznJZICI1miWkoS/rI+HFCZyFlD9hIRhLm8jzSqpvneI9JCyoGKq0Purxu
	 R+xWoOWF3J7Vf2YLrhnt5/4zPBse4v00ORNEvkDANUHfMoFc/3iG9OcAInOkA21TE0
	 J0V3p3DYTNXtg==
Message-ID: <ffc64d94-d3c8-4a51-b6f5-9da9ff633856@kernel.org>
Date: Wed, 11 Mar 2026 09:09:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/16] mm/memory: simplify calculation in
 unmap_mapping_range_tree()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, "linux-mm @ kvack . org"
 <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>,
 Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-5-david@kernel.org>
 <6c6bf2d6-bc0f-4721-a57d-6b9c5f2a5c66@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6c6bf2d6-bc0f-4721-a57d-6b9c5f2a5c66@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fsjoesotw86x4sgnqt7wdzgphdqnm9zr
X-Rspamd-Queue-Id: 3557220007
X-Rspamd-Server: rspam03
X-HE-Tag: 1773216595-108813
X-HE-Meta: U2FsdGVkX199ZXsIOKVePH/pgZ/EWwAKLFjkUENoOJWdIdOfT+XQioYGPhmWMpYFwVPgSxTUlg6EFqivsdplKw/cPIAHUDjMjMiF5sCeRwHj+k0KiXrvPV9pQ9NY6fQyb9MjRaQ4A4Mwf6NLjfUePBz6OKslrKh2jl0CgUGBuQWr3bMx3Waz+nglUeqjtywTCSQ7dMNcTvkMOjY9oDbqdqNmNIDG0ehnXcPZMAlkQKua0JqapKNPy03aTF3cgaFBkwyP57t7HKTbQZZy9kNf8Wfrc9fNrwwhRnbqsoUf9Zjv/Ro5w27pF9upW3FyGSgvT3CBaMC0q1pH+zPJKP+vmsXyIb9pMqhdYFzMKX5PUEq2YzzrBh3N8gtp3INFzyUryGwjFvC1BVBUgSi7U3ufb06f6kMh1E6UUDq/28RJsMaMzH7X7mtuc3TTc+IoU4L0Z5PI7DzoRJ3il2HGiO2i9recuESJ9rYNmcjd68gkKlBz3SEHKo6B58ROqlaQQ8yNWlny0HbrrV/KxE6RcKrQ5BrBXV7RKLKJAqp+Oe/rYdiuE9FQqEiM/2t0l2YANsiQ+khHuvPJghiwvgru1QeWY2eIbYunZYu5ERMMpkuSZNLqvkZKeaCExblN2hxk3C75QN+lRpxn5uXi6BbpnxSId2tXcGHwAmRPriWgYr6aDj7erDbctNEg+PjLBlLZoIL3dF3ztaLMdvAIX+uq1I5OmkRIbi8O6+LqZbxNdjYRvJnrfhNNVWFzEfKKmRuwNI8Gd2TOsp+RxIHyQB/0F1xXjVvf+rCY30thyc9kIVuhfZmo+66cTTdSi+GqyQvP2BNI1MpxL9ULLRQFFkCCzvbJTXMuzT+kyNrUqDTuemAPMkZfpwJzkTK8R9D3kUmp1ZJX5rGDWCC/59my7LiN266pcLBbT1FXF5u/s/B6Ufgrcu5TDOM5uL8rCpbg+gbHm7+fUyuIPWkTCqRuNvPKTHj
 U41Kef8f
 3RpjNBketWukdRGbklsuh5ywmhfkksnCnc2S592ooAyjl6RAI+Ndd/y3Lbs+ApZ2+2x8eEUlK7sQkoXgc3r/T3dL+fIANIfpoz6zIsPmJ4CQvY7up0j1wTKCmDUJZKvav+sZtGyuGoNl1RhXx7MRlvIFCx4BsHDOOLRRbiRq5sECOdzb0LTNjm5aAuWTUROG0Z3mAd9Yjakzm5r0PU3HIA57XVf7EekddkGeCDyvxslghiKw5+6O7XIZPDEllxcycP5LS0T4hB/6jYLoFBYqqqOPK+2j0cdQFumSnVuFduP09Fp8D+HiKkK/IZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
>> -		start = ((zba - vba) << PAGE_SHIFT) + vma->vm_start;
>> -		size = (zea - zba + 1) << PAGE_SHIFT;
>> +		const pgoff_t start_idx = max(first_index, vma->vm_pgoff);
>> +		const pgoff_t end_idx = min(last_index, vma_last_pgoff(vma)) + 1;
> 
> I guess since 'end' is by-convention the +1 of last this is fine

Exactly, the calculation itself is not changed.

The +1 was previously hiding inside the "(zea - zba + 1)"

Thanks!

-- 
Cheers,

David

