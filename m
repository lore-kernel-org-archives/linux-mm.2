Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0093D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9C16B0005; Mon,  8 Dec 2025 04:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA9B6B0007; Mon,  8 Dec 2025 04:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B716B0008; Mon,  8 Dec 2025 04:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 023C56B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:10:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BF3F13BF86
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:10:17 +0000 (UTC)
X-FDA: 84195732474.25.0C43DFB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3FB74A0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:10:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qbFQo5VB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q1xhIigm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qbFQo5VB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q1xhIigm;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765185015; a=rsa-sha256;
	cv=none;
	b=UWxqm8RO7B5/2+p9leF+vsL5+BzgboTomacoQwaGe5p9+/9CJBvZy/H1fUIQPUpkRl/qDF
	OZ4m0KerHsToBXJab4JioRMu6v/4NXZ8d9bYbERPcFo+CHeOmP2wdUE7K6OwlzKNIsOLAQ
	LmR0m0CqkUJPDury3zOhd0vyCFoacrM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qbFQo5VB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q1xhIigm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qbFQo5VB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q1xhIigm;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765185015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3C5jOe1fBLhDSskapJBKq38cWJCsbg+0IkowPX/JG8=;
	b=4sv73nr30rp7fWi8x7Tpu6nokijKAhN4du/q4SXwoUOgdLxFPAGked9zFENIY7idwUM1tk
	OofTwVVSIQ/minbuKh3suI/NCYT6dXDFWt7fm60Zg9WUjq6vqIkDtucltA22P4UJg8/trl
	p/lHjYLYht7JlMmJj4b6lw+MEtOx8wY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 93DB433850;
	Mon,  8 Dec 2025 09:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765185013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=r3C5jOe1fBLhDSskapJBKq38cWJCsbg+0IkowPX/JG8=;
	b=qbFQo5VB0Iul7UVh2ZyZuyOxVM5KlTpv4skLywclN0SxSnke7ngeM66KO4zA2TxcJlq7wD
	WVR9H6El58W5byQHKEvr6xJrXO8d2rGbKazD0ZsB46ohpoVpFdY5Z36F9+zJOHRxTBpvvj
	cNxw8dNv89Dpc/DI+HekMKd0W/wcDx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765185013;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=r3C5jOe1fBLhDSskapJBKq38cWJCsbg+0IkowPX/JG8=;
	b=q1xhIigmYLviznowQZOuwEJsrEMdUqD5Y5HMelkhRZdg1vTOExqbFO+9e26NAG98oGxHSs
	bnpMEjeOAdGyJuBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765185013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=r3C5jOe1fBLhDSskapJBKq38cWJCsbg+0IkowPX/JG8=;
	b=qbFQo5VB0Iul7UVh2ZyZuyOxVM5KlTpv4skLywclN0SxSnke7ngeM66KO4zA2TxcJlq7wD
	WVR9H6El58W5byQHKEvr6xJrXO8d2rGbKazD0ZsB46ohpoVpFdY5Z36F9+zJOHRxTBpvvj
	cNxw8dNv89Dpc/DI+HekMKd0W/wcDx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765185013;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=r3C5jOe1fBLhDSskapJBKq38cWJCsbg+0IkowPX/JG8=;
	b=q1xhIigmYLviznowQZOuwEJsrEMdUqD5Y5HMelkhRZdg1vTOExqbFO+9e26NAG98oGxHSs
	bnpMEjeOAdGyJuBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 284B03EA63;
	Mon,  8 Dec 2025 09:10:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eDCHCfWVNmk2CgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 08 Dec 2025 09:10:13 +0000
Message-ID: <b9f0889c-597a-4a6c-8d32-606e948f7916@suse.cz>
Date: Mon, 8 Dec 2025 10:10:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/13] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Content-Language: en-US
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@kernel.org" <david@kernel.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
 "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com"
 <riel@surriel.com>, "baohua@kernel.org" <baohua@kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jgross@suse.com" <jgross@suse.com>,
 "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "prsampat@amd.com" <prsampat@amd.com>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
 "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
 "jmattson@google.com" <jmattson@google.com>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "vannapurve@google.com" <vannapurve@google.com>,
 "jackmanb@google.com" <jackmanb@google.com>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 "Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
 <xmarcalx@amazon.co.uk>
References: <20251205165743.9341-1-kalyazin@amazon.com>
 <20251205165743.9341-5-kalyazin@amazon.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251205165743.9341-5-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3FB74A0008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: ztcqymw3x3kegwf9omx5hpea9ekg9jcw
X-HE-Tag: 1765185014-928769
X-HE-Meta: U2FsdGVkX192DonFD2CqJFZKsGHAqRN71jvB8NhLwP+P7cCGWbZF1/iDZCEr8bbJ3Vuqo8oWZqaUKqYzDTP1w34WE+LwC+IdmvnlA0r03vNpxbU6H0PuGB1JZPuNqLw2GnKCbwN6jz4EY//tDrMBCVVPtkXfDj4yTFYrGC9de4BhaOFBO3ZLz4QVpDb6v4SP0uT6OfbbPnrQ0D2sD53VB2aba/L2dBYdU7ioyGMoO9DJ53MavAfoUlWJzH2Wr83D43c78qIQxHrVOKAsxTBbqe0KJeItj+zoXlBI2r0RlObzQEhP+IgY4lmheQEeCjNWjf9XsuJ4evzrcTDgIKLwPGsx5+27hrExCOEbEYYPn90B7qRDbQOs1Z3dBNdz2h7Hdo22dx52J9UQEeEfCFP7V2utGOqZzleYmFy3mRSiTN1LA1hEGc+s2UJRoUzu9I5rRQeGiTwYxpUMhCU7hqhW6cWj+EMUbl2h2zt/nw1HexGcRX5hwB0x1LzySdZ6ClB3/Qz2Qll2cVC7io20wJTBdLzqrO88UCb3q0jTBjkg6H2dYS5VpG67NNo3eXu+MmlKhTByI+BcTYNMXNHX3NUbhRtWSZwQluZt9UgiYaj+4Pz5KscF12txZeC82oby2a3iXg+cf5igu5R3vaiOb25DgDW5mw34MEAz/SFJtnym4YDKMiKDIf5cFvlBwP0A5c/e5C3HK5qir44Tn3bB0KCwfFQue4+S38OsBu9diTfQgEoBOYJ7HfX+6MKR1MAJpllcAd4znJi2nsn6PIdSaVtEQWsqzKnk/N2M9bnSFv5bZSdzAQxbWfFoPhtWSv6rB4L2hwHbVrcUlLqGOZAJdDrMzKoqnkEANoPc/+O+Zg6mWwgqZQRzPqvihNSTq/EoynpKepsAXiAc6aLo27C3bJKpXpkIb+kR7NlIwuTJFKUsiPbAGsbVltvbl7vqeyNnGD9e99P4sEjUWMof+dvf5uh
 lBdQ8oKJ
 up5L3fo6S6lmydtPf3xWlHElnyZchhPRtnStzPPeCQeo1nzqb3zIunuI0JbTksQr6gFUqRTNjkzBP1ju4PHYKAXbFW1gGUuvzyE7kgOGa6DzbhNW1iHF0Qts4mjJT2ndbp9ZeahQAvWEU/YyK+rG9EwxfRSo6MZPQPigHzX5P/cJBhR0VTI/AJKbCI/dfxeaJ7WBG9AqVtBulki3yejhmfUd06jKGu/+NNX3RFsB6ZM4VCTqYUABw3JlXhJlRV5VoY46tv3DHrOj19HZQqQDO3MrKL5ELlkMhI8VLPOxL2c4auW05jAXY1RwOOhRKOyXoLcjVFjXo58KZaJ6j9UzvZ9UGrLuiCJszMt04bVqCM4QhbU1HP4DjwrZ/Y7ZzMzOkD9mxLJ+ez/MPyeCY1wDhcrRID6eCwyIuw8pI+y0fI/vdOVH4SkGImeyohFKQlf1i2Bmd7+gbK00rZQHPLWtzj7J8dlz+Wy0GYxch6XXyINGu0OYNv41HtHDsiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/5/25 17:58, Kalyazin, Nikita wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
> 
> Add a no-op stub for kvm_arch_gmem_invalidate if
> CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=n. This allows defining
> kvm_gmem_free_folio without ifdef-ery, which allows more cleanly using
> guest_memfd's free_folio callback for non-arch-invalidation related
> code.
> 
> Acked-by: David Hildenbrand (Red Hat)" <david@kernel.org
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>


