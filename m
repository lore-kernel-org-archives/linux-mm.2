Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C4BC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79BCD6B008C; Thu,  3 Sep 2026 09:10:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773406B0092; Thu,  3 Sep 2026 09:10:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0F16B0099; Thu,  3 Sep 2026 09:10:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7566B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:10:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBA73C053B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:10:01 +0000 (UTC)
X-FDA: 85172483802.18.E2FA6C6
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf21.hostedemail.com (Postfix) with ESMTP id A231F1C000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:09:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=ZiQX6yMA;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf21.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788441000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20L8H017f+X+nMpU/Ghy+Mvvvk1JGSQ75hVtn1pe7RI=;
	b=PW9lRBP2x7nmRAWJIAhwGjBZQ37oJi/YeCiIgyUaKT+So9eefnIM90r58h1incuL0SwfSs
	9gIJevbqcfBsLVSsTIIfB6+tm4Q4FXb3GGI94KlwpxKN69HV/fzvtjpq2wE9PFwaIEGFWC
	S+iASA+sD7LpxGbU047CmNZ6PUKvM/Q=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=ZiQX6yMA;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf21.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788441000;
	b=qbwDZNDxlgW9bR33/3UTjEAN3OuxLo5CB8vchqpxv0G8DxayuDRrRzaUxT+sv/De/sm06v
	5nMj9O6QhHhGoWeMijIFYGt9sNaQgwMzK84EoRxdTSKHJYfWUE+G9MEyLJwI8A7eZ1+EeK
	8y72vWmoMbqP1KZefdGzdJSpAkPfQ/I=
ARC-Seal: i=1; a=rsa-sha256; t=1788440987; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fuKgUs9b7JuOO7CEi3lcRc5gF6oqDW0UIPI4gapgwybnAgyJZia5P1bWcOitvwlihCpvmOYU/zxyOepuKq7jw/BpU9Wkj7NI3j+b7MrWtoCHX9GD72fwsWEvR3hLmwZ2xe3kn4x9YNFep4/8Q2jC83BXykndAIFKhKDkQhHGSwI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788440987; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=20L8H017f+X+nMpU/Ghy+Mvvvk1JGSQ75hVtn1pe7RI=; 
	b=blRLJLlkqMO9bRBVDrRu3eQhuoqGkilCKfYkRSPyoK9zPCDfbik0Sg7z0k+Vu+EFc9tfLZkRSd/q+Owd+fakraBfrWmlaU2TjPutjKcXvLz7hWCS04StbSHVm1tT+JB7CoTfkg673ORXJgUeTHIxnVPkZWPMsAJnIKpaKwbTtBw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788440987;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=20L8H017f+X+nMpU/Ghy+Mvvvk1JGSQ75hVtn1pe7RI=;
	b=ZiQX6yMACMu5Ymav6Tus7unvzhLHvJrc+PvXBSEeomEdR7IwoWypoXlaENBHUCYs
	QuvvoqfWauBzNFhWj4NoosOPHQ5/0Zefk0YLOZpIbeyfmqaYDn0cmmYhN9CTWW1abD1
	I917eV/xaDVUIxBBvh8GxIsGd6YpB7KPt5lkJuSQ=
Received: by mx.zohomail.com with SMTPS id 1788440984549371.17029183808177;
	Thu, 3 Sep 2026 06:09:44 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH 2/9] rust: mm: add `task_size` helper
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260902-tyr-ioctls-v1-2-e0fdbf8bd108@kylinos.cn>
Date: Thu, 3 Sep 2026 10:09:26 -0300
Cc: rust-for-linux@vger.kernel.org,
 Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lyude Paul <lyude@redhat.com>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E115BCEF-121E-4947-AB17-090C474E15FE@collabora.com>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-2-e0fdbf8bd108@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A231F1C000A
X-Stat-Signature: p4qf68bsbk1wytazih3hqzh57k7nygsp
X-Rspam-User: 
X-HE-Tag: 1788440999-633256
X-HE-Meta: U2FsdGVkX1+CfSG1IQSxVAN+9Mwol+FTjkTEaqhEBpWsfYo1Bqc1zRlBu9ZR59e94bg8cILTdGas8DrEPMSJu3UyPBMmJCHuv47sXDlg4E0EF3a/1PFSeMEFjTzq/nuZNE/aw0lD55qGTGiUpIXFlYpMGhQxhwCt2BAGjEPfIVl37fpcDOqOxIGF60J+/yHyqXaf8qMScvJaFvBwDp72Txzdax6EY/ZGffsCHzvC8+JbiNRpcmNhg6FFbWEY5xcQOkx/hjfBxlyWRhT+5eBM+Rks/npp50KxYRTvuLlbKws3a0Mx479SKT0DqCHxQg0AqsUpQ2heyryfPcktmkPoDvyqa3Yk1usnjo4fruSOao2VV37YkdA+WgBYD32bGqxTF99Se/a7s6O0uHJGIGThXxHaeHtWeG2S3b+TH/7FM5l2pYCfdoUxCK0RB2jB0fCbpkxfC77Xd2TEpDoZ7YQptA9/pUD/hmIbnaJ+jmsMuTI3lQbODpX+KELUxKyHelm2hEqlGMOXwbtnDgTm1JBvAlujy8b71Fhoxt4PpXJqPptAns2sS52loReYuAB3EmI7zuG/6kzWJZTRCXyyo/koZi0U3DyNvW/+ZxCaKrxk9WZ9dgmR+tcP7wHxuO0Sw+CdPyHZ0cbyhHdzIWvRr9DdLk3e1AeBaeRkvk8obPO7YG0KXdL6ZoRHBK3q6yHeHBKElR3SpJgT5xImDaiTR7SNnPmAoo5WEZ2oRFSyJ/0VM+rqtmJ9qv9j0V45WVaG+W0juCH1qshQM7+jv4+J+VQg2PCL4hwkypqSjVtxs4MpbeZglrDNuPvbP1nILGszxiDZaUZRZiUWMk2ctZuQGHiu5BjznzMaXtkBFEO6KppraliYs9o6JwO8dUV1VWO6QFGS2XumLU8CMV2Se5Vz6PkIxIPg/5uJEfoHKt+NLPxK3BxuTTOOLYkD3XA2ZZE9wzfbvRHZwN470Ay0XVn1ML1
 JDPreoQf
 hwYL1D2DezegNxjTtEIwevNmmTJiIjXxfLsupiTroDSiLjrh0XzJpmzpUCZ1kn9nPTQ8kl1ER09MAiiiHcwBcLVaqXXUhNF0ataMZwGitDkLqhl+f1NQG+ujvT8PJh5FYBb2jjoH+3tU0kw9v+bcBbfYxhNNM/uPKl1BExNMd9OLTgPkQVVn409Us/Frl7TNL1Sjh8n68zQAMtaIwOCUt153tlDEqQaccufdFs5KbWvaav4BOkhyRc+wNBhzorM8Afy6ZCXpyRX3zVvb+NFJ/V2sx3ML9hVwxQAKeGr6jn3Otr+ae+pno38DM29B/HBPiFylhS+j3QzhGlBTPQRPAGqU5PEfzkaGIDgUNY5iuTjcn/onliFtyebKJezwydjoQmEEmIAEImdF0whWPYUPB5dgW0VRhCu5Edx1em3iIEAAbToV98GLjEbeMIil2FlbfNhQGUhws71cK9Fa2kZWokdvrXgLxpc9N4bMa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 1 Sep 2026, at 13:09, Ke Sun via B4 Relay =
<devnull+sunke.kylinos.cn@kernel.org> wrote:
>=20
> From: Alvin Sun <alvin.sun@linux.dev>
>=20
> Expose the task's address space size. It is used by the Tyr driver
> for splitting a VM's GPU address space into user and kernel regions.
>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> rust/kernel/mm.rs | 7 +++++++
> 1 file changed, 7 insertions(+)
>=20
> diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> index 4764d7b68f2a7..d2dfbb7d43972 100644
> --- a/rust/kernel/mm.rs
> +++ b/rust/kernel/mm.rs
> @@ -149,6 +149,13 @@ pub fn mmget_not_zero(&self) -> =
Option<ARef<MmWithUser>> {
>             None
>         }
>     }
> +
> +    /// The size of the process virtual address space.
> +    #[inline]
> +    pub fn task_size(&self) -> usize {
> +        // SAFETY: `self.as_raw()` is a valid pointer to an =
`mm_struct` per the type invariants.
> +        unsafe { (*self.as_raw()).__bindgen_anon_1.task_size }
> +    }
> }
>=20
> // These methods require `mm_users` to be non-zero.
>=20
> --=20
> 2.43.0
>=20
>=20


Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>=

