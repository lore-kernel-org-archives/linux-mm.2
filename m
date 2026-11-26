Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81227606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 07:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fadt6nw5
Received: by kanga.kvack.org (Postfix)
	id 1E8236B05B0; Thu, 26 Nov 2026 02:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197D26B05B1; Thu, 26 Nov 2026 02:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE496B05B2; Thu, 26 Nov 2026 02:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF0446B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:52:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64CFCA8BFB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:52:15 +0000 (UTC)
X-FDA: 85476502230.03.EB244D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8E4F180003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:52:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fadt6nw5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795679533;
	b=zpCIkwdyk+z5Uj+r/MHznHA/3L9P1lH8uhqtoqDgie7nRiG145ATDCyaFW69M8DYw0JNCn
	DhCPkWp1HNC5UFtQjXa0VsbDg4zUqqeT/RyeHfz3PftnheMhQwHp+GpvcOFNo6g80C/xXm
	4vRw5MTSoauCOaqSQp6Zz2u+iUWFQfY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795679533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjgDRX59u2rhrH/aBYJ1iEOZp9hLuFc1LePhclHXlTc=;
	b=iwgYgUaFElaZHGPFqpApYiL+iUrqfX9kIWzCSLcQb95HgknoJb97Nijv/ujeLVls4FsGOY
	BNfHmW780yY/XHHueXgSQeLkIn9YkuBDT8NPTY3qo1yBv7ZnpfMIthLXev7vYxQXf1tl6A
	8iV3YVgKFnhlo9J8ENMaFiluFSXY118=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fadt6nw5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10DDB60F3E;
	Thu, 26 Nov 2026 07:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1875D1F000CA;
	Thu, 26 Nov 2026 07:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795679532;
	bh=sjgDRX59u2rhrH/aBYJ1iEOZp9hLuFc1LePhclHXlTc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=fadt6nw5f9NwgOoSQr2Y2gIX72DaChYa9vbQkh82kHAorFqTVRcmtU8m/Tn9PCOM5
	 vQE2vWQ8ZmNE7u1ZQIyRLTarwXLI77JJ1MO+hA2x0YtQ4MUhgQuFa++CeOLaQgsHRR
	 mFs7oQPPhIcfc5e7r7mJaXLl5+3Y2Wf8moaxjjqeBjF8Aa5Qm8iTFqXLeK0ASeBQv0
	 oA/tU3UHb+mQxBnYUs2FzOjwGlHZgtMBJl6NEIuGMjIkJ023VmWJOxWzaxumMywRwV
	 hpZBEgo9bieA5T6j999O3EEcF4cA4q5p+87Mu1c5Xy6Xm8yUTCSZossQkYPpBIaGC0
	 s/cgt2h+cCKxw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: phasta@kernel.org, Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, Daniel Almeida
 <daniel.almeida@collabora.com>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>, Matthew Wilcox
 <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Hao Li
 <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Daniel Gomez
 <da.gomez@samsung.com>, "Mukesh Kumar Chaurasiya (IBM)"
 <mkchauras@gmail.com>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v6 00/12] rust: xarray: add entry API with preloading
In-Reply-To: <a6110f748b76b8773e0b5c9cb449a3bed0b19f36.camel@mailbox.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
 <a6110f748b76b8773e0b5c9cb449a3bed0b19f36.camel@mailbox.org>
Date: Thu, 26 Nov 2026 08:51:57 +0100
Message-ID: <875wxkuj1e.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C8E4F180003
X-Rspam-User:
X-Stat-Signature: px7x7c7iyf7p8itmmp7rhcf8q6kwpn1h
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795679533-149261
X-HE-Meta: U2FsdGVkX18iV2aOTXsd7HEn33m/3vVTno4zD/yXMp8ROM/5IB3ghdhqgdMY4SNzHJcjDJK5OeKMyBUqh87O9X9hfQENr8YTOQuQUcNKFnuE+QSXMMMG+wigxECeEtrL/rNgA8niaFTA7TCHLN7+jmf4RShtn+7LJ+E/lCERM4VR2t3+wMh9FyDFCDJZ1scNXX1PSic9f9ZG83Q7GW7krm7w0vKMlELkkEDcHWxgwQCDafbxrzmYkFwMEHiy+X6wZTu0lBWWDLfvBld6S22WIVDRuGpx4ula/AitWx9DthHz/cZGvo6Yybw45zdGkT8k3hZXUjd1spAu01worT4m5uwSZNsIqiqvlII44fqUZ26CVJ2FKaTqxh0GGvkU4o+AwwP+emF6mfnm6V/RLoleyIYDG1iE5NH2dMOI4WUmD9QvfQq1CaP2QWUVzAJnZPtsPXQuAQfcsZlM4b4bQB/3fmxP9977JOFoPaAr3AHJagCzxunNPZTWlFrxDPtjir9QZoZzeyj3em2Gn/TJlSn8FFCQ0HKYFB2crrejQOeHGpSDK1l1ZLNREv5j0lnYmk31jZ3F5UYfylc+JP0IlJd1aUuQvW8cW2zzZoNd/uOI7aTRUCTdWm3mmCggOvgMxoNRz8VDYQVWRo467yGRRC+J0N3h7sn+3tPc3d19TcDNjlLM1FDvK7+MB1d3Wln7vu3GzVf+tE/uMCeWT9Zr4UfSuiDT+qaODHeaz+fIOJTj/vxbfd1JPtNVRRFWUaCKI9ZAvq0125XNeSm2y8t/sumxgv8/I8KhOH/udVrDow1Ee3U38hzpALCR7NbzS6IUWCl91zEhiafqpE66Wq9DaDvq6+q1xQAx2N8BUOcwlCekSweXSRXzZRFaHm/w2sGU1XbZLeorQUjMog1/8QidEKY2nqq217/uyBImjqrU5/XCMQVlJgo3tRU+5zoQ9DFlhhtnWd4Qr13Q9/nJAN9alAd
 VRJqn2KX
 vWj7gwjM30OGqRNvXOOmd0gZptABA8fK4VVUj3sXElT9QN1eEgLx6gNEsOhij2g/vkJfbrB4ufBdPUVMdcPWFHy3B9at3zVvdiDxHT48HdYqwFn1vrIDoQzV9T2OGEHlnXAWpBDYraZAHU/JGXJTJUczrVBc6Je4OnOxjJ/LoWqbNjb44Hj7LRCjaD4HH2XpPTc4tqsoJakhzJ9h2GjngAzxKfNwyjNx6vuJjPMa8t1U9NVOkF9LrNfOZZTvV1hnnaCfSiFCMU3MygQ3sM2xalEXpGPcMhshAm6AeDigN2lwGJ1etNvr79C3t5NG2FsmeNB1oxRniEOuuT9q7OyS5AcbXY+yCud1KPhzPJaou4GY+VIU8gh8fFXDRKyxiAQiLFbSY3Occf+Dd5sIWscG/n7WBYYQSW27zgpTIzRdiOIEMC84F9nV5EmaymKkUKY5jHER2gpKqrax988zEaT1+6cexFZNhSONVDx53PkzGJzOqti3oDarqkzgCmGOvJYsSTnj7R9PG3pOWimWciA6kdXtgAghnLprTKdG2G1jFrPXBXwfbMOxBTdYQxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Philipp Stanner <phasta@mailbox.org> writes:

> On Fri, 2026-11-20 at 14:10 +0100, Andreas Hindborg wrote:
>> =C2=A0- Patches 8-9 add support for sheaf-based object caches.
>>=20
>> =C2=A0- Patch 10 enables sheaf support for the xarray kmem_cache.
>>=20
>> =C2=A0- Patch 11 adds preloading to the new entry API.
>
> Sorry for my ignorance, I was out of the loop here. What's actually the
> purpose of this series? What's your user, and what is it going to do?

As by the cover letter

  The feature additions in this series are dependencies for the rust null
  block driver, most of which is still downstream.

Specifically, we are inserting to into the XArray while holding a
`SpinLock` [1]. If the path of the inserted key has not yet been
allocated, the XArray must acquire some memory to build the path.

Best regards,
Andreas Hindborg


[1] https://github.com/metaspace/linux/blob/9c0fceca4feed5f1056f55abe9c7c70=
731402776/drivers/block/rnull/disk_storage.rs#L185


