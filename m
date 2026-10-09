Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CC5CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977FA6B009E; Fri,  9 Oct 2026 10:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9500C6B009F; Fri,  9 Oct 2026 10:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E036B00A0; Fri,  9 Oct 2026 10:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9326B009E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:28:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7FFAA040E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:28:36 +0000 (UTC)
X-FDA: 85303318632.22.DD4D72D
Received: from sender6-op-o11.zoho.com (sender6-op-o11.zoho.com [165.173.180.11])
	by imf01.hostedemail.com (Postfix) with ESMTP id EB7F140008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:28:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Ud2kTanL;
	spf=pass (imf01.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791556115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIa/8inlxu6owg1iy8GQek7mIHexIT52zxxTW0xBXtY=;
	b=VkklkumsXH/4CCdCmAHmlJjRVGbAjO75s/o4wdnZ561qP66/i1x8VWYXO8PXjk8euNRMd7
	4mQKNBPbpx+jdl2xP9ByZVUdkP7BtSzhLG1SpPaLPzEffKjMyK+f2a0VTY1SkLKKsO10lQ
	KRACrPv0+ESvHD2SEeqdVj0WjdxuoQM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791556115;
	b=lfNvjnL217KLme/MXIkrsYipYJWqnJSUf9WaybsNojL4YginnLYy8QY8efDua88iVCctxE
	galJQYi/EzKZn12oQs6OElJEz+xPn/oORBWe1U0GuRIguLRb+SVIprqcQOezt+/htFIO9J
	fRTLc8ZCCoeoj9LrIcXcpphsbv/NBvw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Ud2kTanL;
	spf=pass (imf01.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1791556100; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ieJhTY1/fVTNNenBOIQaRrSR1EtiO7w/SD+0eL9tYE6G3zIU2cdAZDef6XnH3cXW0ypI/8LRRD9qSudw6LI1S2pvOX8rwrt/KHM9nKYtfZ00SEqBJhJ6jT6xa3aVSEpUufbjDgdWcnqa1kqcjcI9ULMY7bOReNknEGiyKopkdtc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791556100; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WIa/8inlxu6owg1iy8GQek7mIHexIT52zxxTW0xBXtY=; 
	b=dZ5t4WDrpV3N4ENvaSkR0mSZUmLbQ9FcQBhNlXTUogb1nZ+E37dHPCyz+OPmzEH2r5tfi9JMO40jwnhpmnbCp1LnB4L8H3CRLAwfRJEgjSiRNftKTgNv0AfKjWF8RPavTe3CNY3h8aix8xOkc7BBL3tUfd/KYnMDKD+Gf1d0EPs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791556100;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=WIa/8inlxu6owg1iy8GQek7mIHexIT52zxxTW0xBXtY=;
	b=Ud2kTanLnTn70V47psbhImXgfgyN+noPAVAOTSEYigdMG9RoQ/2kaJFJBuR0yroO
	9MBibrhidvG2R90atM8CMRh1Hmi5+8qUWoT3YNOBuFaVQB6qKx4IvwrdQ3eR6DxqgSb
	FsI4TobHjlrFuqxzo0qg0aF+oFw896Y7eGzlJufg=
Received: by smtp.zohomail.com with SMTPS id 1791556094666375.33121900586843;
	Fri, 9 Oct 2026 07:28:14 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3 05/11] drm/tyr: add user and MCU VM specifications
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260929-tyr-ioctls-v3-5-26955fb111d5@kylinos.cn>
Date: Fri, 9 Oct 2026 11:27:55 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
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
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>,
 rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 driver-core@lists.linux.dev,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <76CE11D7-94E6-4352-B2CC-F20DDDB451F6@collabora.com>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
 <20260929-tyr-ioctls-v3-5-26955fb111d5@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EB7F140008
X-Stat-Signature: isegwz4xabzkjba6315a1gs57wynigyc
X-HE-Tag: 1791556114-543143
X-HE-Meta: U2FsdGVkX1+OcqHBj7DAnVWne4R60WTvQ751fdSBx6tAK3xtLtvGkxa37N45X3bZDSsyKncZbecf1Sg0XgDwn8GJdVsvk0EORrLroAQ7Y/RqNF5H9BeNDaM3EsSQyMnxjfWOAq8SCPdvRhJtYPMXdpTmpwZkgyTGPGoo5t3zCp7w75rQJLIRHC60v5QzgY5mPC+wSfHoVu2VuYfKUupNj9GJPh6JUyFbrBOMiM3IgjKdxXaJXs0S7a4pbbMXuCUOZUuwedtkH0hgVglyuD2xH/Es54h42onVtJlg1ZYiL7y7OzucmOljpUha8AONNh6UDfUhtoT6f+vFIXlXklpYgx/FjrAPk8mYI/t7MdDf1qivb7efE/32qPL2AmDhElsygJntyJHALqwtt4pFthdfnMIyH0USy8UQh4f/q1fORq8OIubt69s2+ZL8UKuKL8DS93/ApDmg9qIKhPL8bsS2kljfYjk3byx+gPEiO1mh9l1eAh/5BxQ5UaxxlUu0iY5iw8y0LeOu64c2xxpEZ02ND5z5tHXLfXG4YeIIvWw6JqpGDq33sn8cBd+QLEU3kTDIfnoKAv7tvlxmcMLl3FEK+SUhPAByWh6JKsHstMoVLRWNP1bRy2hhw6QioUmVfKVXW4urU5lPR9oUbDuk/oXAfLG6Xccm2tTTkIS5xLGJ1/iEhrzA2vE8y/kvHJumtP8ewJtqCLljVRfzv6Zpi1/hSFIl0oInAhGLGiSa9wJYZ6Ou0JTsOm4VtHJBdcYLUMRgM4sqr/3UuawndMA3Kn9NnKSGJPUhEkuwvtGFoQiEBNCIw0dB/KvXDV2/9g4IFXb+897/f+jcyxH75aysTxrjlBIK8cxf1FpooDzlL7vs4GCdK6wtK1lT6i9YomDVBwZCptt5gYjyXinXHizWmwjGWa0B7TXcdD6jh3YvycC71WlvkcecZVK8i9GJkwtL8RExt17DhI731UjwCX3eNEq
 /rwRys/Z
 tjfhLQ4VvKxUiQVwJQjModPjx0sEj1JzunVf8SgYiwyhGZtvYp6GAenq4t9oaHqAS9JeBXwOwfTCCUyOd4TnQn9NFWPAM6QaDpEOAFSXNm7DPegpIJbUnhQL0iqpA8tDYcR+vfUu3llGWCivYItEd9ho97BQTC0uE/8PlVcx/9KpHJfkFE/cVcW8SOSW93/1pa8EwzONx9Yh+Z7Y8eAHQere0dsp6/YpO0jkkEImx1GUhQO6d0CVCIR2fP1aX9F5SpK/fa9d2yviTb9Isr90M0EvB9PFpVd/wcKpG+aPJ6hePunxcHCtRt2ZYl4qY9W4zLxWbWhOI245VxG2Ryhi93GP5wYOwCtC4elMj3fSrDFhl6Vc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +    pub(crate) fn new_for_user(
>         dev: &'drm Device<Bound>,
>         ddev: &TyrDrmDevice,
>         mmu: ArcBorrow<'_, Mmu<'drm>>,
>         gpu_info: &GpuInfo,
> +        user_va: UserVaRequest,
> +    ) -> Result<Arc<Vm<'drm>>> {
> +        let mmu_features =3D =
MMU_FEATURES::from_raw(gpu_info.mmu_features);
> +        let va_bits =3D mmu_features.va_bits().get();
> +        let range =3D 0..(1u64 << va_bits);
> +
> +        let layout =3D VmLayout::compute(range.clone(), =
user_va).inspect_err(|_| {
> +            dev_err!(
> +                dev,
> +                "Failed to split GPU VA range {:#x}..{:#x} into user =
and kernel regions\n",
> +                range.start,
> +                range.end
> +            );

This should probably be dev_dbg.

=E2=80=94 Daniel=

