Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E96F6FD0653
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288AA6B0093; Wed, 11 Mar 2026 04:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C1A6B0096; Wed, 11 Mar 2026 04:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE896B0093; Wed, 11 Mar 2026 04:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA3A96B0093
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:21:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6787E1B881F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:21:11 +0000 (UTC)
X-FDA: 84533087142.06.9179635
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90F6FA000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:21:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cTf0RnmN;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773217269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAiwtRFwPzXQ4OfTrxFFusVMutEu4CCJxk1LHiPPWCs=;
	b=q6dQQYQmrCCmUKiGMfM24FYsHG/lukhAF8XAD+fAnmFcPl7oQLAO9ztHOC+62UmL3nlTzw
	sVI/Vltb4yUUNIDGT3VfHXzxEkSeq5+kePXDNLf4nMLzeK1QmEWQXkGoJyqmrLjf/4jeAN
	QJXX2M7GWXIpBOtYksGp9avVk7/lWgg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cTf0RnmN;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773217269; a=rsa-sha256;
	cv=none;
	b=ZAA1QZItWqN+iEgttFQDZZV4upXHp0c6f3uwfdUg6lCiu0wVJgaif5k+YXKvqFNF7tHf2X
	SDGJwxQLv4ekb0eu7XUdUshrbHOQQybZGGfjXmqI4hwGiA6p3htzTdm6eZG3mCxyZJy33A
	nGb5gYQKhUi7CQTeyUGZVoVnmJImFKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5376A44021;
	Wed, 11 Mar 2026 08:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA254C4CEF7;
	Wed, 11 Mar 2026 08:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773217268;
	bh=yoy2hHq0mlIZwc0kYZnvrnYvl8EpuwxGFzXVdSAUfiw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cTf0RnmNDiJr/UaiIX68oNKNUMmk3eM19LeszXExEX5Januo2/40zQJ3oD4JOmvzx
	 Q2n49GaHe97cnoonNB/JqiqpsNtHzHtLAbRLdZ6sYh863gpXifwvSx7D1dp/3sEvyZ
	 Cz19hxeRzhZi2oJc0Wnk73bnhQ7wwkYnI2D4U6uKEPrCI8z4dlK812Jb3PAW7M303a
	 WltTUBSwdhPNJlyqR7bREVbYU/2K/pT8iN+GLG9OQeR/gH5ZpF6uteOR+s/mrsI5qK
	 e+MW9EWzf5J2dJKuPFzc/B0cyPzhCcoIHrW0iFi+aZAA5GHI2ocqzHfiCCK5nJI5En
	 3rzrG7ue05B/Q==
Message-ID: <9cd2794a-63c6-4645-b42b-10412899865f@kernel.org>
Date: Wed, 11 Mar 2026 09:20:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 15/16] mm: rename zap_vma_ptes() to
 zap_special_vma_range()
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
 <20260227200848.114019-16-david@kernel.org>
 <c77c1bed-f04e-4f21-87d9-6c5da3f0ad69@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c77c1bed-f04e-4f21-87d9-6c5da3f0ad69@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9n7ykxeq4nni9zyb78zu874c94dzmsj5
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 90F6FA000D
X-HE-Tag: 1773217269-225811
X-HE-Meta: U2FsdGVkX1/6+XaPRNi0RBSqdJnUxgdiAh+0PM/4MjVO3NjrXGzVs4THt0KCRDNGWVWNdVCS5LI63Z5uPcfC0Kjx/fS/Uwqqbsqqlyb35/WwfwByuxpBv1ys9G8KQ7cUAMYmUe1zq2pkuOy3YbJ1gCIK1TqHuqzHX6m6Q9rFdmX/dtIKZ9dleAOgQKoylByr+/HuOzlYzZRX0AzI1NoHNy1aKXE9kj+e+KAEvWEZeheFKKgJGd6AHJk7y26TEyV40S+1UVp+tOEPYVKhWLK7D3fLMUXoKTYj16I+0XFJ8pLQWOBz8EX2+Gjz1AWwAUXoACKzcyNFH/ajHX5IDr8mT6puO9xPR8wwD4AMUiYUQEphxaTtD4yrW8dig2m+aC56QZAkIaUG7kuYCr/7UID5aRx4gFUbKYaOB0lOw470tlnbk5Bg2PEY66sWUodoQ/Dz4eRlBZuwrmeFJzU9C4FJXcGs+l6yTcnZRZGzZO4akL7mwgRPFwEN+aTBlXqfjrP9A0cRbt+FJMzFirnQaTjdXzdHZmjkeh3YsL9KnXkXZMGy0k7yMoulb8Dal3XrA18RekvwR2vTv/yRmViDHP+wOTCB8Qn6LXZ2BcsiHRxU/ndPGanEPHVT27ld7Q837Gl8BLUxPF1mPAj4FlIrDYnUdFjbyyWPG+8dL8jQYGXnfN8RAxQorDEFo2LNTcxrMmq8TL1Lg3C9+QERo20MNTqNlYwA2mJhcS1dZs5RAjHR5EqtUcPsaHDxRfseATCQRT8CLgQE0mGUJhCSZ3ztRT30wpRcr/A4MwERL58TNtpJd7ljSom/lS38x7TQNsE3GGXpUuNze5lg/ZLH4syzxOjFvnmBWLkVCnQxgw6j0bngQIlDZzFFEePj/FhrlPxCxH5JElQcw7NDusm4TwMqjdwXc8EYW87VFbrhPoR3nS24wki4bH2nEVkiDMWIkUGRA0aiLOGamQ12dj20JitjMRB
 g8H49CBS
 sErLsyw0N2UMbefCTRVaWuytDmc1shvEPv4b5QFjn4jAPPwph5zWV2Yt5spetnG7GifeMBrTJibGygwW9EaIWmEp7zTHQAmlBQS5FON3MR14t5n/+ByQW4294XrboFMPXDh6F1z8rUovFKzCqGBaCkFI7lrpQKYC1rlvv08ANAw86FuPKpD8C74t4PaEoZ1eR3kT5Of8iTQLV2Xy8JoJJ2qEfq+XsTXwxW/SALgAm9F1oUpd3vkbyC1Wo2kRvptkXscFajlkMLXvbKrN4RtaB7e2aTzHPsbF07IWeEam0ZWfRA/VcQnLEMT7VpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 13:41, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Feb 27, 2026 at 09:08:46PM +0100, David Hildenbrand (Arm) wrote:
>> zap_vma_ptes() is the only zapping function we export to modules.
>>
>> It's essentially a wrapper around zap_vma_range(), however, with some
>> safety checks:
>> * That the passed range fits fully into the VMA
>> * That it's only used for VM_PFNMAP
>>
>> We might want to support VM_MIXEDMAP soon as well, so use the
> 
> I think you should say we _are_ going to since patch 16/16 does that :)

Heh, had that patch separate first before I decided to support
VM_MIXEDMAP in the same series.

@Andrew, can you fix that up? Thanks!

"We will add support for VM_MIXEDMAP next, so ..."

-- 
Cheers,

David

