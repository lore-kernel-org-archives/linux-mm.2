Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E026B606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 19:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bglyxXwZ
Received: by kanga.kvack.org (Postfix)
	id A6CD76B05B1; Tue, 10 Nov 2026 14:09:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D836B05B2; Tue, 10 Nov 2026 14:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C226B05B3; Tue, 10 Nov 2026 14:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3B16B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:09:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 125BB140A1C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:09:26 +0000 (UTC)
X-FDA: 85420147932.14.EEA6FED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E115A0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:09:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bglyxXwZ;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794337764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+WHa4Tx0FQeM/03RDwXEAIwHC3edRmTKXzFoRa1jD8=;
	b=Fv0MlKNjiC03XL7HZVnRH1dCBjN/0cSyN8iifAeaARxAKWzsz03xxlmtTuZAnJfE68Cf89
	60rYE4FTy4u4QNL01wjYGfrMueOfvTZ1HyNbUO6ZRHzyDLRlIujQB61OVzk+1N4lqeeKAc
	QBPUZzRDs5W1pv+AxPFnPj2jbPMABUo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794337764;
	b=i66vxFptGuVmLos7ZC1WNCwni4gw5EI3552WL0xfcpGXoH7daBZeIfglkVw6TUW2P8kKu9
	WNmSJ00sI3+WWXuDZeAxVn+OhCyT7wWnOS79LFigUDaliHrx08CpBZqcSR5zPERt1XOj24
	zUlVxJu0UKCZ5J13qlLR4sGRw8fu9RY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bglyxXwZ;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59B5C43E78
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CED11F008A4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337763;
	bh=W+WHa4Tx0FQeM/03RDwXEAIwHC3edRmTKXzFoRa1jD8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bglyxXwZhyuRgmFOeALSHNg3i9G+F+dEGWc+WpFP+/s37zzIxn5NO9E9jL+3R63Bm
	 kC1t66ugxjCC+DGJdyggcyEpur2diPQ2cj/2niEY3bXp18Xyde4N4SgtjypFHg07RX
	 nNt9IB1Pyo5UXtnxiwwuo/pGQaooKaOqZl+S5l9vCcBYowdJ7i8choGB0ABE8fDRAO
	 IDslbNOGPosKnbAT3VDamaJEjrl/9QWADByJR3PXYNI1smQYdKt4aqNCQDtxHZdAjz
	 RdhLsM6qzgydo3C6wdZv5aCI5+0Dxakipha9SAanffrY51SlJjsoX6VnWKJFlLWFHE
	 bP6lWSDmVlV+w==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93e515769d3so234712685a.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:09:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHvBpmxJm2HLp+fUffyIYomODtI7gkZ1RlEhQsEnlbLXBAAe1aowL1s5BNxmJ95ZmZA2opsycEy8g==@kvack.org
X-Gm-Message-State: APuU4Z9YXTdSKubYFTGDhgYmRPGPQeHaofWOsjhViDn9lbpIppefY7nO
	lspIkz+Cso+uf0rxpZzOG4q8cx/tNSy+fkQQbGQbzognomgzEwzG39/CAA7w+YuURm5frOioSEl
	taOhNAJpVthXodbRRGVN43KagwCk1f3Y=
X-Received: by 2002:a05:620a:2984:b0:93f:623a:adfe with SMTP id
 af79cd13be357-9479f326c45mr594443385a.58.1794337762570; Tue, 10 Nov 2026
 11:09:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 11 Nov 2026 03:09:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wPJ_QtogRWti7S_w2pLjp5OtiO_yMK3xPDUsbKb7vcpQ@mail.gmail.com>
X-Gm-Features: AclHuK-DC-lJkNatH4VO2rw16n-NSlpOLDxaxjxsORriFsDN1xlQXsk_TPJhSYE
Message-ID: <CAGsJ_4wPJ_QtogRWti7S_w2pLjp5OtiO_yMK3xPDUsbKb7vcpQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Danilo Krummrich <dakr@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: iy9otp1gy6unfbwrdnrdmr35yca7t1yd
X-Rspamd-Queue-Id: 1E115A0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794337763-540104
X-HE-Meta: U2FsdGVkX18lY9R8l7p1BOMLA8bYVEj5gn61wBXrsq+ICwBWgL9PZG+hj1B8uzAsBqwDarNn5tfFHy1BP6syojCCk6p76nhynEdnljNOj4FpCrrWn1BH262jDIWLHpScxf0P4jEO27GnqVDPEEv+lI8vCnBPA+mTuNmTPNI/yQngDYIfr/z1h2hCnWXwPYmQchlkKxy+aoM/UUj/bTmFB5Wdcg62JaPQTZiGvD8Ok43jfFBVeE+VjCyxTbwC6GSlxPzEpqmy80HeViLh7io4TDmaC1BUoNcVNZNE8VG9+/LbrA3GS3lg2IGxcuXe+hyAHPcdRHT5kj+hYOgxx/5JJbkT7l0ayhBFoVukIH+wpDvrz8++c9mNFO8tdVY0b+hOUMfX1VPg+8Brvzj5CEnYlUvUQ6wZv4a4baRqfK9OkTs5EZQkcfsrFl4wwkH0BfyexI2gMTMPrTDFV8KuwH0RdAyrbzVas8CVkHuanFL7RTmDnuyoRLed7G6/t5ula/AwTfcPhN9ZakU2nseXE/xqmlkPuCIcaW//8k3bwwE13KSdtb/v94rHzAj0E+v9EVTqGCR1gpsVfKumvrujf/Y3xqLDT1uRFmObn+Mk2Zo43hyggnQdVl11sq2xJJhrd0Gj3QDG3BnEfB63YJwlDf8MWbIp1lItMYehjoriqE+ErfokRDOts/HEjZ+XouKLmlfgAmlvMSWPOM76EGciX7Ssv1NZDtqwwrQE6groYJ8rGt0zHcRBmMuYj4OMzmjaaQL0AvWOnLGZo51H0yZedwMZ/3gQh6+PT/o14EcyZpcqsRrX1qTPglZpC8fzsfbg77qaPo4/+DVWysN/VZpZEIROjUWQb+/igaMTg7tR+S5lkDbtnw7OJSxr3lR/52UHynJMw7l8bLIly0coUS2gT5Rw5KkI9z7UzbBYcGPT0j9RpnQljvL8aU6piucNqYb8VElqgbGh6J6ttox103tBx9y
 /rRZKpcB
 adOFJJ8L55urH0iSNweEh7tgAJjE9LtTbbuFTOo5kRRD0H8WoZxI2D81r4jExe/GdrTvfhODfHtR6qpxYyWak5EtZh6Bb8mVXnuwrjnFox7l2nAdazmiKDPmkI6/r1bbOsoRpRpXKFyXdUSK9pEH+2h8q1wDdh9OGhx0IuQhTJeoCV1RFmStvK+dbVr6uMmcbiU8W1Gxu4tv8ByivgfaRYmbhRZwGT03HP7BT8LjrLw2iLVTsDC377aMqZOIWUF71ci554nuPBllvmqEzFeIsfz6vGkgzRqoAk3/fYe0dc++5Jj4GmK1L8vGBxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 8:03=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> Given the current throughput in the kernel resulting from AI-generated
> series, I unfortunately lack the bandwidth to generally be able to offer
> review except in those areas I maintain.
>
> I have separated the patches into areas maintained by David, Andrew, and
> Alice + Danilo, so each can take the patches relevant to the subsystems,
> for convenience.
>
> Apologies for doing this, but given the current trends I'd like to do
> something to make my inbox a little more manageable :)
>
> Also add a CREDITS entry for THP, as, since Zi's rightful and well-earned
> appointment as co-maintainer there, I have no fear of needing to step in
> there, and so would like to record my time in that role.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Lorenzo Stoakes (ARM) (4):
>       MAINTAINERS: Remove myself from MM core reviewership
>       MAINTAINERS: Remove myself from MM misc, reclaim reviewership
>       MAINTAINERS: Remove myself from MM rust reviewerships
>       CREDITS: add entry for THP maintenance
>

Thanks so much for all your hard work across so many areas,
especially in THP/mTHP.

Acked-by: Barry Song <baohua@kernel.org>

>  CREDITS     | 6 ++++++
>  MAINTAINERS | 5 -----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> ---
> base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
> change-id: 20261110-drop-reviewerships-264c745b11b5
>
> Cheers,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

Thanks,
Barry

