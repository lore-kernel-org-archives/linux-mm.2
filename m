Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86EECAC5B9
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048DC8E000E; Thu, 25 Sep 2025 14:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019C28E0001; Thu, 25 Sep 2025 14:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98948E000E; Thu, 25 Sep 2025 14:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9A328E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:17:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E0501A049C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:17:35 +0000 (UTC)
X-FDA: 83928580470.19.9048F23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id F2C5D80010
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:17:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=snnSx2Jo;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758824254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gi061uodDnbkHKcEerrRz7vvbkrog0br/og1NSExwNI=;
	b=WmYOtZhzq04K5OVFObY2bo4whGGOmnn43wahH+aeMwFd2yUuf+Nc2+KtMqT3XgNVQY6+yu
	Avy1BnDH3wulQSAEbkIHWS6lX0r/woA3hWTioZ9G8K7rZA2XKEp4ekGbTvH0rL8a0ISIrn
	9X03IqeEf2E4M2f2ibHhsqsI44rEwO8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=snnSx2Jo;
	spf=pass (imf02.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758824254; a=rsa-sha256;
	cv=none;
	b=3Rn52vaKXU8YSXgi1RywNHfOZv3DPir6DaB9QaABJxFs8zjQk3sN+3GQGKrLsMg/6PNF7g
	ICw4kzBxBFe+2+bzXfPu7AQT/ozZ0PJAnc7DzwtAGbGV28n7qrJwFhnw5UYgEryzSVDrCK
	/jOrNz/gHyTshlaH2Ww1Iu02EMU6q5w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CA2E611E3;
	Thu, 25 Sep 2025 18:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F635C4CEF0;
	Thu, 25 Sep 2025 18:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758824252;
	bh=vplUSjg+R+HU5CjzMqQFgUqhUMUeCAKMeinKHcOnjpc=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To:From;
	b=snnSx2JoG2IMBMWuBuo4PaawWerSZyp3dENX1M7wJ/+jZc/ei+/XX8wlr+waqZlKb
	 R/87WQ7tlZqfNw0lxyMTm26eFFnyKPV/kf45PjT5+uugertGzUgkUXrauEHDIv584e
	 VFADaX0sCXb11+G+QAPM7z9L4Mm2QYKKcLtuQFCbpdPXP1wOX7+j5HpoSHkEinTi4+
	 2v42bc7xs1bfqJnmGjNZDym5CiEQliz0jnzSDbWxIndVjQqV/tO4AdG4zeWUZw8RWY
	 3sjCJiI2Sf96/nihtSkC4t+E+AIi+vuPyq6hswpW6UpbFppBZO+XEqHiWi65YLESnf
	 NLagdblxfDkOA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Sep 2025 20:17:27 +0200
Message-Id: <DD235SX4QVBU.246L6UKUWBNB5@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH] rust: slab: add basic slab module
Cc: "Elijah Wright" <git@elijahs.space>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, "Uladzislau Rezki" <urezki@gmail.com>,
 <linux-mm@kvack.org>
To: "Elijah" <me@elijahs.space>
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <73d7d53f-439b-44a9-98ca-0b1c8fbc1661@elijahs.space>
 <DD22FI7F2ZHT.32SL8PXFZZHV3@kernel.org>
 <6e9c820f-070b-409e-ac25-af96b8b962c6@elijahs.space>
 <DD234804U7YK.3S2MBUJSFHF8J@kernel.org>
In-Reply-To: <DD234804U7YK.3S2MBUJSFHF8J@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F2C5D80010
X-Stat-Signature: qd4q8zfz9zxmjz9iin7xciqbnkhbpysb
X-HE-Tag: 1758824253-53197
X-HE-Meta: U2FsdGVkX19rWiBtVm3O+6/KlL4h19bHRgR8KbUoQxdTg7prJsGLvPrzyWgE5Iq5lzP3ZMYMRjukne3at2/VA7chFcrTepr9BmkhReblr18EmrysTxbxDJxs2FhFLCMxrR2oqhR6qj+rvGqrseUqhdZrEmlmpEyGrzf7kdI6NafjmozXw4qQeft9d48AvCJsbeV8xp74T0xQ7FMDFmTSjrRfShtcqbTy45mKjDOpbt1WeTLLp9f5zxuKpq8PB2x5SD7BNsm08YuH49gfKmsaLvV6qsnAw6cBPQ/Gsur5e+HZ3uAqyWCdK2/LUgCbdG2WTbuc8eJBEzFgGDld3VLNOhiHAZQPsCi0298aEM2GkzeeVd8bPlwB2Srb3I6/9JukxpzqJsQ0eVpXZkThbibDvNmM4pc1fwVB095lsAzq2JELWZxVouav6TW9Vwa9FhSwlydYrEKfmih5Uq2AFEWBqX0YUAJLHz5VZUPXgP3yi7/WOqItmtaydB5ETQrNj3ScwKFJzg974x44dxny736ecPD93JEj8Y+BjvkWky3xHHs08qtI4o+g+nZA7ALobPqJhAh22I++me/Tqn/S1WMSHD2hI6wEzrRvEHiYuFTtP92uEltOiQQY41EKwAGh+gm6PTmF8ZPaOh71afWcyxn4bvxS3pz4zhnuJ4l73DXw6St1uIS0aceA7GJDw6AOpAMtEtVB0Ks5vKt8uWTMkVQd+9Mv+n78wIg3qSa/+vWyn+3JlRrnwIUhBTIGxfJuktn0CHCuK6eIx3kUzE2aA1N3jpJE4CELZeacYiKpiMt2k5WEsga2jdTdsZrcnFL0AiLxEhBtjZRtzdY8KVG2qiNXyTkpB1VgYaUovLl+aX5FMr98mIZ139xcBLyR/74pWd7VU1WyrEkYKjLdne92pvUCb9xCf74xFxmwG0xRLP3TGMADg4Ve7Bn1YVVnNOc4dV9XRPbsQtWStk25lSF3iKa
 gDKfX5YZ
 i2xmiiG6JgWuYiaxzeqzhdg6uzrWLq0OHVlu71seq5cbCuPvnczyjjhNeyaiX0P9i/pzJIty88wMwjOM4XuDeFu+bFQMD5hM0MDIRu2tITRUG5VTP9Ez61rtgy0eS0qHSBx4srXuimwXiO/2GxLXRQqZHrdSVp0lEDARhb9rQ8c86RejczIa0g/MwFeEBijIezmFSPDCZt5MYLHSzhauegxKNDV9wCpunCSIRqTkV5t0Bd5SjghU+i5C7PseK76RDbdyhfw/HMwuxCBYUkb05ybuVGclBQ4kCLoD0tAcC69rGVDgY6mVjGDF8KqqXGqbp44Yl5QvnK5CbkZS7tGvIAhK+bi4uPiNP5m2b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 25, 2025 at 8:15 PM CEST, Danilo Krummrich wrote:
> On Thu Sep 25, 2025 at 8:05 PM CEST, Elijah wrote:
>> On 9/25/2025 10:43 AM, Danilo Krummrich wrote:
>>
>>  > Anyways, I'd also like to hear some more opinions, especially=20
>> regarding (4), as
>>  > mentioned.
>>
>> ok I just looked it over. I think (4) isn't really viable, the cache=20
>> pointer storage overhead is probably too much (in addition to some=20
>> complex issues).
>
> Probably, given that kmemcache is meant to be used when we have a lot of =
(small)
> allocations.
>
> However, I'd like to hear from the MM folks, if there may be options in t=
he
> existing infrastructure, or if it's really a dead end.
>
> What are the other complex issues you are referring to?
>
>> I don't really like having a macro (so (3) basically)=20
>> and I think there are issues with non-static caches, I don't know=20
>> specifically though. obviously (1) doesn't work. (2) is exactly what I=
=20
>> was thinking specifically for rbtree. IMO the only useful options are=20
>> (2) and (3). I would say maybe implement (2) first and if you want=20
>> macro-generated ZST allocators they can wrap whatever that Box ends up=
=20
>> being.
>
> I'm not sold on duplicating the Box code just yet. What issues are you re=
ferring
> to?

Also, if we argue that (4) has a problem with scalability, then (2) has the
problem as well.

