Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 369C8CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 23:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D526B6B0088; Tue, 29 Sep 2026 19:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03A66B008A; Tue, 29 Sep 2026 19:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB606B008C; Tue, 29 Sep 2026 19:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0E76B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:41:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19121A0505
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:41:46 +0000 (UTC)
X-FDA: 85268424612.22.37FC7F7
Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 132901A0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:41:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M0U3zP3+;
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790725304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Xrgsv7RmptoTEWMbXsE4AaL7NQQ9ZRcJ/lLOBbn/ZM=;
	b=5E0fLDzw/qMMNz8ZhypvCc5mXLBFj6VDJB0yPMNtbqk5/GRZf9BHOw4CJNC59xbbo1z8/z
	1eLn2hY/beyC1eyH++Wa1lKYFig7FsyEkSGF5vbUF0VjfePADRbgOUKTAn6ftznOSgw5/K
	rTUShADgkObMNosGm3ZxsRRMk6sGIUo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790725304;
	b=wNepYO2re246JkM5Z5EnPJchphqAsA84dwzgTykBv0Yu4U5ylcLsRxVoxdRc/D03n4XjEj
	p1DuCO3qWK+IVDNkwPjGd0pyWSL8JqTmIm6jbiR4KFOAT4uYNLA3nYcvjezAMKYi22RJVz
	oLyheATLYy/WCYeJav0sGC0WTrZOyCw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M0U3zP3+;
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-914446005e8so37794946d6.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:41:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790725303; cv=none;
        d=google.com; s=arc-20260327;
        b=FClKi4515M1t240xoPTm6iSv1jNgeVRn8LHMPahf7adeCZJJZCaxC0oRut+HsyvDKk
         j5xN1KRbK/FP/l4xvNF+0rbKfKfd8c5ubgxRbUVM69ukwOq3QEbTMP4xUASnFzKXGUQN
         PnP7C8EYiWUdAsCH87U+IIfpbzDDDI1cenhy08ox/JaoJ+g/PEPVuDXNG6+ur0bpscKv
         PXdJUN+tPYNLNr0pMV3WocKdI1GWiJK6yxeLvxvjmr1SgdHpey/VzMrAyw09gt6K5cDN
         M3L6l0jwXrweC3V5D89hcldh45bZlSrM7c5ZisFaEa5M1VwMi52U2jcg/1yt4P1rXp20
         rYGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=+Xrgsv7RmptoTEWMbXsE4AaL7NQQ9ZRcJ/lLOBbn/ZM=;
        fh=GGQrcjWZPBDDaqh9VVc8eihNNMIVLvLlZWduy4ffaWQ=;
        b=N6pkdP8q8QmFgzkwlZheKcrOVqO6FyEr2u6bnwW0AWXm4WBfdjFHyUejpy+r6uKIxU
         cVBJQ2jDClkd/QJpJ6kADjV3tYkvSu6vC/n4rHBZ9/rbYaARF5MjU2gS1ULYX0gVGuCt
         AmERsD+b8M043XcZGyO8N8z2/nFUYOEf5WHYi8/4mTjtacBFS+25Xfl/IDGmL/PyQjgF
         YjY1NMGf//PRv1B06p5zWb/za2uBasOF57P+YJnFvhfGqXK0CyKMV6JUHYlUIUX3oaVj
         dr81HxKnB4wpW0oac3oXJ/axURcJpddr/ZRddXBtWeBBeyx48y61Am3430h1SXZ6xDhH
         vg9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790725303; x=1791330103; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+Xrgsv7RmptoTEWMbXsE4AaL7NQQ9ZRcJ/lLOBbn/ZM=;
        b=M0U3zP3+SWNHxuEmdL5WR6oaAOTeaCMGk9zYh6qUca+U32NlEOgLDmISl8R0rXueUd
         lSLxAEuMnPQenaDbBrw5ZDt2jSx5PvdIVJBm6jMZiVawJbsTrtiXomsqy0OPHWxOL9ks
         BJFxLXjanUNQj1d6zP0apUEj5zoWIdyLtOCu+iTFJpZqmOGpiD2x7w4YNBjbDfSMpQJq
         9PKRw17vlkZ/C3AmAQX/zCS4az/DaKkX8qF7JjjyaesHpaHn3UlvUu04w4IYV9x/yzNS
         OGbNob3bfzu7uU+XB73e5f65moysa5c0A/PrpeSfB5Xxt6KN5H8JyfW9vlebH4rjalGa
         Hrtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790725303; x=1791330103;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Xrgsv7RmptoTEWMbXsE4AaL7NQQ9ZRcJ/lLOBbn/ZM=;
        b=Gdq+fCk4JAcVMeQdvdCgAb0oNa2/YkSohqni00MW82/63oMDWaLsFyCaHNN0X53tux
         gd96rQ6lo1RAray6VYXHG1aT2HHCalduH6k33D2x53ZIR6lRfBmCRilRqvxwuqUa/XDv
         z7PyOWnupg0ky9LAuGujPfpTcHDmJzWhCMRsD4Ah/35xGRXRiIJN+uBCBdJUwpklvlJ7
         zJJwvOsntfmy/2HaZqS2UTJBu/Btk6yEBch2jz0REFuhoJjk8cI3aL9FuFeCQV+mnhJT
         889IOEuiN6K+rZsiJAKwUJDK3Jgq2DFYelhaYoalrdZ8yQKASnmfYI8L3h5Q5Xtkvvzv
         wwug==
X-Forwarded-Encrypted: i=1; AKwUvByhX7GPfzck5oqTwysXY4j+zYc8btdt8g30eGd59IN/IjR2+RlU1BGEkbJBLoGC7NKDVo/4/c97mw==@kvack.org
X-Gm-Message-State: AFuF++lrKnslz/nOuMdCoa9hoSmiXEUc9qc6Yor5V7IxdaRQpFBcUM2y
	1BC1U9ayNAHlzfjg9zGrrwFXjD+H9MFDFyN8lYDsP8DCEmD/6qA0CoKd/qezFr0vdL6XLev5i3t
	Xrj9Y+Uc48Bd9HCUiKfUzgFoKkvW5/buLdRqA68On
X-Gm-Gg: AYBFou2QCrGYTEdF/8P/9DddfuMLuFtZCz9gtBi4jGusXzYwtuHj2tDBGOR/enJcEeV
	6Ndnqo5GU6nWkEzLGTwD1UBTqNXgFO6RAS9GulXYUs7Uy13iaUweS9jqbgRj3eJn2VFxNmwzlx8
	HmRRj71L450dvxWMUHLx0wAUSqMnlhc4ik7iEmmfjCDK0nZ1s6NrCHLyaJ6dZGflk83lgZtCoXF
	uoHGPS4LcTmQpxbLYtx3OcLr3l8SD5INWEQiVvsNbVT8B8ohKmF3MHJhLdjBGufWRajN0ZfGFzx
	ZQ8dPmu7cg2jHBYx/4zOuarB32gX4Sfi5hV9K1CwEUVrTX4Jyk1hvt3PW/qSw90E8Obb92zUSiy
	rYT+bg3vPeehwp1V1Fgs6GyDLxxfoOOUOw6YUqG/z
X-Received: by 2002:a05:6214:3f86:b0:912:1f7a:3e96 with SMTP id
 6a1803df08f44-91799b6f1cbmr14363076d6.7.1790725302155; Tue, 29 Sep 2026
 16:41:42 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 29 Sep 2026 16:41:41 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 29 Sep 2026 16:41:41 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ecab388213245df81815e42246db3b13b2d43e2b.camel@infradead.org>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
 <d599627270c67a5334d2abced75d1d1711fb0af0.camel@infradead.org>
 <CAEvNRgGw_RjiGs_bbVnoRAvq49Qukm4h8XhkBd0DXxn1ZzLrQg@mail.gmail.com> <ecab388213245df81815e42246db3b13b2d43e2b.camel@infradead.org>
MIME-Version: 1.0
Date: Tue, 29 Sep 2026 16:41:41 -0700
X-Gm-Features: AclHuK-XLbcvCXV4wApQJel8RTlaN3ncBGEcJbP_UmWcTs4Jcx4bthsfg-DyB4A
Message-ID: <CAEvNRgEU47Xag6S4mJNxZCjEf9AetHO_kvMQ033Vaz4jpwcrcg@mail.gmail.com>
Subject: Re: [PATCH RFC 00/17] Allow guest_memfd to be created using a
 resource (pool) fd
To: David Woodhouse <dwmw2@infradead.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Shuah Khan <shuah@kernel.org>, vannapurve@google.com, erdemaktas@google.com, 
	jxgao@google.com, rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
	tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
	Gregory Price <gourry@gourry.net>, yan.y.zhao@intel.com, michael.roth@amd.com, 
	suzuki.poulose@arm.com, Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, aik@amd.com, 
	aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>, 
	Connor Williamson <connordw@amazon.co.uk>, Fred Griffoul <fgriffo@amazon.co.uk>
Cc: kernel-team@android.com, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 132901A0002
X-Stat-Signature: 6a4rr9zi8zh9q78nd6ugi45eups63fs3
X-HE-Tag: 1790725303-630654
X-HE-Meta: U2FsdGVkX19ATBxym05ESCXVOkbyXwjIKdGWWRAAb/w7UdHC10dvQ8xxCX6VrsH2nR2Obbm0vr1W9URyJi/Oqx8o64mkCFkZEbQfWfd1zYPSg65/zZVWMSTnrB9VbEjdHNBANVDpa/h1WqVwxWUT+BS2Cc1cL8cQlhMoiqWmzOFc8mLFQ4b1BSoRNPeATfaYFl4N9nxJdfxYdZAVF2YmNpgQXct7nMqPyo5kgUWTaIiRZa3VcrjInsGzUC+0CX4UefBBOSji7X1BXNjPjfnsHWzohePwLEA4czPS3D1DlXpSKvx0k7OMni0LgD2EWn2NRO0Md6mkjIEXYaCzqBqLDZIe+fPkCWFcdzuTbgqemlZDOG4AKKrggLy1Mr3s86eFYTO9E3eQu5TQnvs6WTED4CrzMPb9U0+fdvTx66Q/egaM7o3tq2mpEXdWFkuqrBEQxnRAnDSaY07jxIFzcuHoNhIxT33POjkPxjaz0FL5kq1FuSQgP+iJyQPeaIp/hLMDYVGe6VlH+hqgN4r/XghAn0LbRFuDWqPH9iur/1irzMKKZHPbBxCkcpQgxErO4+i6ueiJrSoM+DQWGyCcDE8N1D/os6eKvfU3Y54OY4jqt9q6yD0XhidSs2i61rPSG23hz1z6zFTARx2somcl1ZYtUn1GNXGGwjt0ly4RaioCMw6k9Yb5rdLJv9VDDOG7K5KZ9JflHazBJBrteSjL+pGTWab8WsYZGtGpcEDdZN9at9tmTDFkgDGrHc+moqvabtE6z3heDSv/Vp1d82L1OjV/DrRxlZKAy+wl15yoL05dWNpCYEY3fynu96ytjNpNtoMvXBKTm0yCnb6o+HV7lf7U7OE2bMUCFhkhbiuCy/Pum+MXaOT0g5H6qFfItUZC8FtnNEC8LvstH2X0ojFlPBdblGmmHWyNnxAxUP/v/QuX1mkMz9V7R+2EdDcOAOHvmFkq7AKi4xqXivTIjCbRKsn
 XAbLEp/U
 2CeIpjm8CGJgEmVAqF1J1PC2rsDFygwOMd555eqgZrgICHDoUwGjUDXxzRXDBZrfQ79n6YAOZoHszcRbbSsQMbYU5YTvTEyTf2Z6XvLbLb6vwPHfOoVRJW5SCLCgRISuAgnRHaKRoV9M5eqpRR1v6WtNvlTB8sF7ezBjeROks8K8BjEdrEuakuqSAu4zHTw4L/YHxO67sHn+YyFmH7eV0YpniB9Yhd7aLF/eO1NQELcgg3yAeZ475xnBrMwjFWsnQj7CZhHU2rwL9lFjURxy8hvN/jkrsQN4nBPcjQFAeo6dAa0ARGAuJtHa6tN8ebwExrpHJ+c5VYXK10j/teGm+8KN19rwOp8qvgGsEO2NW+ok6QQ6ZPesS7YAxZ3eiCGKCIiWo1CGY3tNUhlilBcVldTOQE16Hc29DiXDVMJ0c+4EDM+/J5tzKxw0PywxcZ0K5I3S7ntK9WmUhNSkG+9MJsdHd5INDuMcb362G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Woodhouse <dwmw2@infradead.org> writes:

> On Mon, 2026-09-28 at 15:59 -0700, Ackerley Tng wrote:
>> David Woodhouse <dwmw2@infradead.org> writes:
>>
>> > On Fri, 2026-09-25 at 17:50 -0700, Ackerley Tng via B4 Relay wrote:
>> > >
>> > > =3D=3D=3D What if my provider doesn't deal with pages?
>> > >
>> > > Frank and David Woodhouse [2] have use cases for providers that use
>> > > PFNs, and this is definitely something a generic interface must
>> > > support.
>> > >
>> > > Here are some options I can think of:
>> > >
>> > > 1. Don't define .alloc_folio(), instead define .alloc_pfn()
>> > > 2. Refactor .alloc_folio() to .alloc_pfn()
>> > >
>> > > Either way, I think guest_memfd should still be the primary manager =
of
>> > > the memory.
>> >
>> > Thanks for working on this.
>> >
>>
>> Thanks for the quick reply!
>>
>> > I'm not sure what you mean by 'primary manager' here but my use case i=
s
>>
>> Naming is hard! See comment on revocation below.
>>
>> > for the provider to be the ultimate arbiter of who owns which PFN, and
>> > revocation of the same. Think of it like a filesystem backed by
>> > external memory. Each guest's memory is a file, and a guest can
>> > *donate* specific pages of its memory to other guests (which in the
>>
>> Putting donation aside first - I don't have a good picture of how a
>> guest would tell the host that it's willing to share a page - can't
>> comment. Would love to find out more.
>>
>> > context of the *interface* only means that we need revocation).
>
> That's implementation-specific. Think of things like Nitro Enclaves
> where a guest 'donates' its memory back to the hypervisor to be used by
> another microvm. But that interface isn't the guest_memfd concern; as I
> said, in the context of the guest_memfd interface, there is only
> revocation: that page went away, whatever the reason.
>

Okay we're on the same page then. :) guest_memfd only needs to know that
the page went away, guest_memfd cannot say no.

>> Going with this revocation part, beginning with a more basic use case:
>> I'm thinking that the provider can notify guest_memfd that the page or
>> PFN is going away.
>
> Right. That part I have working in what I was posting.
> [5] https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=
=3Dee95ed5aaf06
>

That is similar to what I had in mind except the parameters, I was
thinking inode, offset, size.

kvm_gmem_invalidate_range() in your patch [5] does have a kvm_gmem
prefix, but it's really a direct call to tell KVM MMU to zap the gfn
range, guest_memfd doesn't get to update its own state.

>> guest_memfd cannot say no, but it does have to tell KVM to zap the page
>> from stage 2, and for CoCo it may need to do more stuff.
>>
>> The notification needs some pointer, so I was thinking that on .attach()
>> the provider would also note down which guest_memfd instance the
>> provider should notify.
>>
>> The notifier could tell guest_memfd that some (offset, size) is going
>> away, and breaking down mappings in the EPT/NPT should be something
>> guest_memfd tells KVM to do, I think. Are you thinking that the provider
>> would directly break the mappings down in the EPT/NPT?
>
> I think telling KVM is the right thing to do.
>

Glad to hear that :)

>> Does this notification mechanism work for you? IIUC regular DAX would
>> need it too, like if the device is unplugged for example.
>
> Sure. As long as it works and efficiently covers everyone's use cases,
> I'm not going to be overly opinionated a priori about *how* it works.
>
> All such bets are off once we see the code, of course :)
>
>> > Should I be trying to rework parts of my series to live on top of this=
?
>>
>> I hope to gather more feedback at LPC. It'd be nice to get early
>> feedback if you think it can work for you! The overall design still
>> needs feedback though, don't take this as the final direction.
>>
>> > Things I have working but which I don't see here include:
>> >
>>
>> This sounds like 4 or more different features! I think they do work with
>> this resource fd proposal.
>>
>> > =C2=A0=E2=80=A2 PFN support (which you mentioned).
>>
>> Yup, guest_memfd needs some way to track PFNs in addition to folios. I
>> think for tracking we can reference DAX, the part I haven't looked at is
>> how to let guest_memfd handle events. Like if there's memory failure on
>> a PFN, how do we let guest_memfd handle it?
>
> Telling the guest about correctable and uncorrectable errors, you mean?
> I would have thought that's up to the VMM, until the point where (see
> revocation)?
>

Informing the guest is definitely the userspace VMM's action to
take.

guest_memfd's role here is updating it's own tracking, and perhaps
splitting folios. When guest_memfd supports huge pages, one thing high
on the wishlist is to split the huge folio and zap only the page where
there was an error and not the huge page.

Advantage of splitting: If the failure happened in the last 4K, the
first 1G - 4K can continue to be used by the guest. If the guest never
touches the last 4K, it doesn't have to know about the failure at all.

>> guest_memfd needs to at least be notified, so that it can handle the KVM
>> stuff: zapping and special stuff for CoCo. Whether the provider or
>> guest_memfd gets to handle it first can be worked out :)
>>
>> > =C2=A0=E2=80=A2 IOMMUFD support via dma-buf.
>>
>> Is this about having guest_memfd work with dmabuf fds?
>
> It's about having the provider of memory (again, think of it as a daxfs
> if you will) able to tell *both* KVM and IOMMU which pages are where =E2=
=80=94
> and revoke them at will.
>
> The *implementation* involved dmabuf fds, and we already discussed
> which wraps which, on the first posting of my series. But maybe we'll
> conclude that the right answer is for IOMMUFD to recognise this
> guest_memfd 'provider' as a first-class citizen, and we won't need to
> masquerade as dmabuf?
>
>> Fuad also brought up that Android uses dmabuf as an interface for CMA
>> memory. [3] IIUC the dmabuf fd is mmap()ed, then the userspace address
>> is set up in a memslot for the guest. To make this CMA memory
>> CoCo-friendly, we want to use it with guest_memfd.
>>
>> Jason response was that guest_memfd should probably just directly get
>> memory from CMA [3].
>>
>> I'm not super familiar with CMA or dmabufs, would either have a suitable
>> "resource fd" to pass to guest_memfd like how HugeTLBfs has a mount fd?
>> The "resource fd" should ideally have no way to mmap or read/write the
>> memory directly.
>>
>> [3] https://lore.kernel.org/all/CA+EHjTxZ0N3Tfnid404B4tkb_E+Z8mODTHTgBPi=
F6=3DbwZp7Hjw@mail.gmail.com/
>
> I think where the memory comes *from* is an implementation detail for
> the provider. It provides a PFN (or folio, if you must). All else is
> not the business of KVM or IOMMUFD.
>

So we already have

  dmabuf --wraps--> CMA (and others)

We could have

  [a] guest_memfd --wraps--> dmabuf --wraps--> CMA

or

  [b] guest_memfd --wraps--> CMA

I agree guest_memfd shouldn't care where the PFN comes from, but this
does impact where the provider_ops code is implemented though.

If we go with [b], CMA needs to find a non-dmabuf way for userspace to
get some resource fd. If we go with [a], dmabuf folks need to support
this :)

>> Or is this about letting IOMMUFD get pages to map in IOMMU page tables
>> via an fd+offset instead of via mmap()-ed userspace addresses as in
>> IOMMU_IOAS_MAP_FILE, and that guest_memfd isn't a supported kind of fd
>> (yet)?
>>
>> I think guest_memfd should support IOMMU_IOAS_MAP_FILE. One use case is
>> Confidential IO [4], where SNP would need to have private memory
>> (guest_memfd) mapped in the IO page tables.
>
> Right, I think that's what I meant with 'first class citizen' above?
>

I agree, yes, I would like guest_memfd to be first class alongside other
memory providers.

>> The missing parts here are that guest_memfd and iommufd need to
>> cooperate for conversions (or some other coordination in userspace). If
>> private memory gets converted to shared, iommufd needs to know to remap
>> the pages as shared in the IO page tables.
>>
>> [4] https://lore.kernel.org/all/20260225075211.3353194-1-aik@amd.com/
>>
>> > =C2=A0=E2=80=A2 Revocation (which I've tested correctly breaks down la=
rge pages in
>> > =C2=A0=C2=A0 both EPT/NPT and IOMMU).
>>
>> See above.
>>

I missed considering breaking down huge pages (the folios). guest_memfd
will definitely need to cooperate with the provider to break down the
pages.

I'll need to prototype support with HugeTLBfs, probably after LPC. There
I'll need to split pages on conversion to shared and merge on conversion
to private.

I think you meant breaking down the mappings for the large pages in
stage 2? guest_memfd tells KVM to do that in one of the earlier
prototypes for guest_memfd HugeTLB pages.

>> > =C2=A0=E2=80=A2 AsyncPF support for pages requested by KVM.
>>
>> Is this kind of orthogonal? IIUC today KVM MMU handles the async-ness.
>> KVM MMU checks that the page is not there, then since async was
>> configured, KVM tells the guest to schedule in something else.
>>
>> guest_memfd doesn't have support for async #PFs now. I imagine it would
>> be something like KVM MMU firing off a kvm_gmem_get_pfn() request
>> asynchronously, and then guest_memfd gets the page or PFN and inserts it
>> in guest_memfd filemap, and then notifies KVM MMU?
>>
>> Within kvm_gmem_get_pfn(), guest_memfd should get the page or PFN from
>> the provider.
>>
>> I think it's orthogonal because guest_memfd could
>> have gotten a PAGE_SIZE page (existing functionality) or gotten a page
>> from the provider.
>
> Kind of, but I'm focusing on the guest_memfd provider interface, and
> that needs to support the asychronous mode: asked for a PFN for a given
> guest address, it returns -EAGAIN and then provides it later, and the
> guest gets the right asyncpf behaviour:
> https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff;h=3D8=
94dd0fcb34f

I thought the same .alloc_folio would be used, except for an async #PF
the entire kvm_gmem_get_folio(), which calls .alloc_folio() would be
done in some background thread, so the provider doesn't have to have a
different .alloc_folio_async().

If the provider does need to know, then the corresponding thing in this
series could be:

  struct guest_memfd_provider_operations {
	  void *(*attach)(struct file *resource_file);
	  void (*release)(void *provider);
	  struct folio *(*alloc_folio)(void *provider, pgoff_t index,
-				       struct mempolicy *mpol);
+				       struct mempolicy *mpol, bool nowait);
	  void (*invalidate_folio)(void *provider, struct folio *folio);
  };

something like that?

Either way I think it would have to be a later series after the first
one (for upstreaming).

