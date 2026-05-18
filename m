Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A2BCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254456B0005; Mon, 18 May 2026 19:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202C06B0088; Mon, 18 May 2026 19:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118A16B008C; Mon, 18 May 2026 19:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3A486B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:00:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 959BE140AB8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:00:23 +0000 (UTC)
X-FDA: 84782061126.23.B86A86A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90A0618000C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:00:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GKBaQ9DW;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779145221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IdMsK7+qqBktFYOQdPjrszNAWNg59HWQ7/X9tF03+KA=;
	b=cY4Pes0fMo6bbmxXCGbcu6NWyCigcEZiv/9Hd5SwiMSgUmE4nWbbpf7z0jTlWcxUeFomZk
	hap/oXalLuuunZZcwVWTbUYPVM+9ceEp4881+hRPqaxESyuW8NKlvYtEIUnDIXN4y3Pbuz
	dNJPS1b+WaiXcaH+Gqjqu5aR8YCL77M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GKBaQ9DW;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779145221; a=rsa-sha256;
	cv=none;
	b=Z5XuylymX45kt/aW7LFMiDWbtGrM7PZJxkjC70Kx6EPBEXdx+a/5ezP0WnZcWcgAjMuQqG
	2FohA9RLpxNPsVnTfe4l32uUlVVoPUI3x1+5Jc4Wgrc/I9UfkL1n6tC4PHt/hn1gUDLNYP
	8Nggpy0gqdg1QV9okxjo8GeJ4+2zbws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FCD2445B5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6360DC2BCB7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779145220;
	bh=IdMsK7+qqBktFYOQdPjrszNAWNg59HWQ7/X9tF03+KA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GKBaQ9DWHDRe9+tG++ZPlIoQ4CugNvI5+ftXhfTi6txThm87onadLleybQl4vz+Fx
	 sv91RZTsVD3QK0BlRLPvGh7h1DhdF80k0Lok7aGRNy2DCOziFvTd98IBLPvVCl8feD
	 SSQcbGvHwkJ312D/2okkCTyEYk9E+ZwtFGmc1IKWyasVecqiBKSNe7CtdrP9kZoroC
	 15bohK+iE5wRBtNNUs3c52ZfMsZqNg8ZSZzeuYL4/R44GCKrcSK4BCI6CTHKf0nH0n
	 IMU+jccKSztoDoclFBGrt/8LSp8aFKReAOTI9T0eTq9oNQ176bY7MH0VEHiaSuhcon
	 GbWWlR1F98aGQ==
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-6314a0eefb1so773453137.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:00:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9nGOva3F0/6it9bS7hT5TSx666H32jiC/xupZmiWPakWrRRkSK5a81f5gCcFUDO92mooWkquRwQA==@kvack.org
X-Gm-Message-State: AOJu0YwJpQROzPNBFTIKiyASPXNzJrKb6YgXhp23gNch6h7WzeNGsU0L
	v3BAvxlaxvK3bxKPLnHhlFv2a9O9s91/GSt6rpCZQuKQRmv0nUfOIQHehxGzmeQLmW0uHUySzKp
	pCM3SYcpNFZ0s5kpfEnPmWsdHyNUrjws=
X-Received: by 2002:a05:6102:8649:10b0:65a:fcea:5a4 with SMTP id
 ada2fe7eead31-65afcea0ff6mr1668580137.4.1779145219252; Mon, 18 May 2026
 16:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com>
 <CABdmKX3DhejYBis9htLDnzPrG7vuF3R3URLVNEbnyd61SSsx=g@mail.gmail.com>
 <CAGsJ_4zyecY6E-=Tm4_couT7uoM9LMcFdTMUPkZAjj4zUKE-dQ@mail.gmail.com> <cb84c2ee-9de1-4565-b2e0-60984721228f@amd.com>
In-Reply-To: <cb84c2ee-9de1-4565-b2e0-60984721228f@amd.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 19 May 2026 07:00:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z121v4tK_3+j-hkD7HH0gH3w8tWD8nk0CwRhFE5T+4Og@mail.gmail.com>
X-Gm-Features: AVHnY4J-roggZZXq-3fecPrif-MI9m_xhdL-W3ahLsaa5t4gx3NgfHLdPTzAVis
Message-ID: <CAGsJ_4z121v4tK_3+j-hkD7HH0gH3w8tWD8nk0CwRhFE5T+4Og@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Re: [PATCH RFC 2/5] dma-heap: charge dma-buf
 memory via explicit memcg
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Christian Brauner <brauner@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri- <devel@lists.freedesktop.org>, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, mripard@kernel.org, echanude@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ku1jnk3cbu4bprwjshguo5jzu3nmkgn6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 90A0618000C
X-Rspam-User: 
X-HE-Tag: 1779145221-216642
X-HE-Meta: U2FsdGVkX1/c699UcxQyIplaY5U6l5NFk0Eh4o6ea9LW8UJugMHNI39KQU6XBCq7Ud9Fw1u0P2WPml4E1Qt6PsI1ta7CzkyR6az3BmxoGHQ7h7j1gO0P5ZX709YYwFUAb7pRlUFSipXoQ6slSm4HXQJIXNvm7P8d41KV/RQVA40lbneG/IAy08mRVi5EY6QjFGYKCtyLA83NwNKcgNMBuYD36NRRKtKcAzPF5BWYHK0qXbObN+JDcY7Xpwq91uQnOEtyXigC2kmamzBvKD7BWbslU3T8QeFuW6TTcC7B8p7zHCBm1WrRJcAvDjbVmx123Te6Ijh9RpastxIGQn91FU/m+OCJ6zRZKfNFBMf1APHdWjtYZvlfTeQDu4IGJYsvjzWkaf0gJdIdOzSee/zpW8rn7j61HW6gqAQtyxoEhzzkTXbQuTs+1NU/fMSZRfQ5hWck8mfmvYjckQTx5px701wUhtyroDOUwSN+rhzybbLPOaVp534yQ5VtQ2DESyPB8w0ulNc0XiP8Ha47vem1wbXoseA5VfhvImWtsEW1uJxSbr8ugbmLqyN6m+j447se9Ojz1umXwN0R91MAkL/tWpAQ+NTGb6oX8mor+bWGtNHZ2xMPcKBS3IQEfgxirm5tAsmf4WiUVl3anYtgqAnt+kuRX+kUScBYqoi5UZ6+X4mhAYw9m7aYjeLVHTi8B13l7hAYDu93aez37tB83nOWd//qzSzbLJ/XgWjkQAvQSPU7dLvA3mvezzm1JEWkkPAxSxVEVzifHx+LMZE2qYeSlgunI6RzQ4CIpOAuvZMsQ/3I8m15E9Uh9gpPnrIBNYIqMFA6GokQYRRNByLBIOWwGY6YwAuJ/3TNfUrJ3klvOJ7n1IbcQ9jcYqKTZQOgTiTil80gC0HtrijJ8Rsf8Med0OgNvmAKeL/zLGra3bnSIP5VtSchuqreU5e9GqsSfxCQ+6ePUKJ6d0ALmG1f24W
 XtA9QJ+P
 t1xpz5qa4IsCqur0JLOC5Q2D6ixb6bfvaWPhtMuC8GsLT8nZwO6FwDbxHiVf7lD8f2VByqKUBmx2LoWceeptXsLvQZMclmA1fuTIxxiCl04HAH/fjxtc8RJZO12exqQjEo6H68PtfD+GbrP5UFzLnVLR4fsqir52OuTT4a81gDp6aA1cOe2VxfW6xV8OPOSUxXytI24FJ4Fo01w+Wg60od6Y4Giqv1c0PC/BShCZUgJVboGngGxX2/dGdZPi2LCwGVx/8plFkWDBuIuFgg0dExeloM4XzO/hWjaBKp0d+gdUm7znGyRaN0SJ+CSpiRUkCBuWH6KEe5Kd0ZE8G/olmcYaj5aGOwniUU8MZk9JfhvlAw9HhuMZ9DuWXiQzqBoDUOLhvcG6JLKoerIeIXRlgx9KBbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 3:34=E2=80=AFPM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 5/16/26 11:19, Barry Song wrote:
> > On Thu, May 14, 2026 at 12:35=E2=80=AFAM T.J. Mercier <tjmercier@google=
.com> wrote:
> > [...]
> >>>> I have a question about this part. Albert I guess you are interested
> >>>> only in accounting dmabuf-heap allocations, or do you expect to add
> >>>> __GFP_ACCOUNT or mem_cgroup_charge_dmabuf calls to other
> >>>> non-dmabuf-heap exporters?
> >>>
> >>> We're scoping this to dma-buf heaps for now. CMA heaps and the dmem
> >>> controller are on the radar for follow-up/parallel work (there will b=
e
> >>> dragons and will surely need discussion). For DRM and V4L2 the
> >>> long-term intent is migration to heaps, which would make direct
> >>> accounting on those paths unnecessary.
> >>
> >> Ah I see. GEM buffers exported to dmabufs are what I had in mind. I
> >> guess this would only leave the odd non-DRM driver with the need to
> >> add their own accounting calls, which I don't expect would be a big
> >> problem.
> >>
> >
> > sounds like we still have a long way to go to correctly account for
> > various v4l2, drm, GEM, CMA, etc. In patch 1, the charging is done in
> > dma_buf_export(), so I guess it covers all dma-buf types except
> > dma_heap, but the problem is that it has no remote charging support at
> > all?
>
> No, just the other way around
>
> DMA-buf heaps can be handled here because we know that it is pure system =
memory and nothing special so memcg always applies.
>
> dma_buf_export() on the other hand handles tons of different use cases, r=
anging from buffer accounted to dmem, over special resources which aren't e=
ven memory all the way to buffers which can migrate from dmem to memcg and =
back during their lifetime.
>

Hi Christian,

Thanks very much for your explanation. So basically it seems that
dma_buf_export() is not the proper place to charge, since it may end up
mixing in non-system-memory accounting?

My question is also about the global view for both heap and non-heap cases.
After reading the discussion, I=E2=80=99ve tried to summarize it=E2=80=94pl=
ease let me know
if my understanding is correct.

for dma_heap, we have the ioctl DMA_HEAP_IOCTL_ALLOC, where users can pass =
a
remote pidfd or similar information to indicate where the dma-buf should be
charged, as in Albert's patchset.

For non-dma_heap dma-bufs, we don=E2=80=99t have an obvious userspace entry=
 point that
triggers the allocation. So we likely need other approaches. We could eithe=
r
move more drivers over to dma-heap, or introduce something like
DMA_BUF_IOCTL_XFER_CHARGE, as you are discussing, to let userspace explicit=
ly
declare a charge.

Best Regards
Barry

