Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C51C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 09:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D01C8E0002; Tue, 22 Jul 2025 05:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380B88E0001; Tue, 22 Jul 2025 05:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F1F8E0002; Tue, 22 Jul 2025 05:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 158238E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:30:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D12AA1A02B9
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:30:21 +0000 (UTC)
X-FDA: 83691379842.03.B820E15
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 08ECB180012
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:30:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yyyAZXtL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753176620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJ3NUgk3lgCY61pzl+Ni6KBJ9PADbvzhkTcNBzb1Rl0=;
	b=G7WRw/C25gr49uijjv1hTFWteFe/guASIMSjC5OKxBbCLzWBR8gGWUDQuZR7l+X6BYUwi4
	y/TdoO00iJEgKlfmLmZWk68WZ65rPhI2aKEDGkAvwNxUkFi/US+IA/s7BtbCh9wDzrpdjn
	1VN1cjMbj9mZ6vZzvJ2pHP6z7Gk3Vw4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753176620; a=rsa-sha256;
	cv=none;
	b=TyKHA4qT7alLGsFPh/rMoTB/DXSnRhSg3iSbXTV17i0PZ1iq1P0zCgKoB1K4UR80uzIf33
	LD5axBrbATGaVtwW4CLeyqUYuSvS7hr4lNOFrdPKFWyMmBhMeLtHkzssJs7OaId549lA11
	iGMHw9jjDzNqItBKZrblH8QGLiNGgNM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yyyAZXtL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab86a29c98so276391cf.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753176619; x=1753781419; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ3NUgk3lgCY61pzl+Ni6KBJ9PADbvzhkTcNBzb1Rl0=;
        b=yyyAZXtLQiDHvQe74ZHt3wu1g5S31Q/yd2KfuErVnOleiFin9K0Tyy6ZsmSTS6f/m6
         19hk2W6g08efU1moTKnePRfl6jpTTvEHakNvZuOjTy4phqSQmgtlxqLyN4z8XU3Mf7r/
         AYef+EJyOzrnqTqx44/Rd2E6lv/z+Y+Ax0w9BCJNWEt8YaouQBIkjR3UtFLxXGRGvbvI
         XDG6cryORCNuSKvSoDDOyyF4gVgeLDi0vL1IxhRnMy1cSdYCipsDQuvBdBt2IihoxuEM
         Mhn5Tcc2wjgwBNSRqPJxU2Wf8Mnuot5a6K1BC60OT1jVleIF11A/Wbs3CmCSoIIyvcr0
         2avg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753176619; x=1753781419;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJ3NUgk3lgCY61pzl+Ni6KBJ9PADbvzhkTcNBzb1Rl0=;
        b=ujDEtnmoMJCsMJgsOOisAE287f8+oDj/Pu6o9nk1iGb7RBuwszESr0KTygmRH5vTIn
         ugUb46m7a3K2vn9JMxvspr9xNiEnviravVtRbgjNR++05tt54vVM6LIbwSUkLlvtqGBE
         I08lbGSzBSv6Tu96XLrxvFiijKxZIHUBUBC8JnfJ7fL8RB4tl1CtDk9Xo0odxeFdFBVe
         INWfYpPy31iIUxZPNZNE1A6zyJF0N3XBBuZXqBPYyNuEz+V0Mg9B82QeArCk6ROzXQbq
         poPvDIAuaXjZS7RQPCmsXv+lXKpSaOs7dbm9eeypjvD0bqGV77+0TAdMJkoiKB3fwHoh
         xHLA==
X-Forwarded-Encrypted: i=1; AJvYcCVs5hgTIFPkVaVnS66av9bTn65EQ8o0qbF9lbU3gs70VYOF42msuB3ohwbpJfwAEjNHaFnbeRK/0A==@kvack.org
X-Gm-Message-State: AOJu0YzgDlFb0ZJ3BlbWFbWUhitT5wjhLWv32h6a0LhuuyCRYfMivlCk
	i7Ph+R/sQ0+FtJyXLQdX1wrknxNbeeymFDpqyBwMJuiLxQvRZXSSRbpOPfZkv90J9iVp2k/Iz8I
	0t8Zw9qUUadvr3dLuCdOqdF4KnN9JmIafX0KKFMEf
X-Gm-Gg: ASbGncs0s2lBDI20GNwdWXUzK9gvMas9LZ5beSSk1X+orvewbRAEwkMKe75Zw+AeUyc
	8LBB+QiVd3iiE2Fh68yPoe30v9FcfiTHHb2VzKzFjchBCTc1xnsLuScs6cHDSuvKOU9E6PmyG3O
	Tf5ihEw+qK2c3cH2vQaqFu3NqVwpsjLt8nWm67AHrwqmMQyF4UJqfTRv/IX2EWURFasqATKD6Zz
	xvNmEzjqSoBCamn1kulpPE3slvBD1vkEBmR
X-Google-Smtp-Source: AGHT+IHbd/BHMQdknwRTeYIHxdE5noPZ3kOvGg+B20+8ARSixzBI5h5DcNA/xdxCHeDrHowFoGGJAOmBsTNjOtbFr6w=
X-Received: by 2002:ac8:5707:0:b0:4a9:d263:dbc5 with SMTP id
 d75a77b69052e-4ae5cdcbf2fmr3451501cf.20.1753176618461; Tue, 22 Jul 2025
 02:30:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com>
In-Reply-To: <aH552woocYo1ueiU@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 10:29:42 +0100
X-Gm-Features: Ac12FXz-lwaWaACHfhK57yuAA5YnGjuXlhFfMAwyHrdRb3Dv43qkJ8E0aH-WQ58
Message-ID: <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 08ECB180012
X-Stat-Signature: exakewkybtb1pzz8akbyzc7xnh1o7kwp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753176619-186940
X-HE-Meta: U2FsdGVkX19qGmSnqayJG1V06jIh4jHLYOTCoAtfKlJ8q+RTWsSMzJsYz1enEjzz1yVE2jkc61Y3KLoYpJe8qxJVSmBktuJJ2AaqxL8Dhup96bQgdj43zbs1sUpyK9LXNIfpufV7X6avCYb9OqJB4oVe9wJemv68bKm/y+5WQgkStIiyvvYkh8KD90tGWGcOYugAmeppdIcQkmFBukbwTtnZk0sc8vso6NqMoj/gdz+yVolGxF9+vAoZT31wpiwLjXwIj0rf0LvzPik4oOeyIVQ0kDwV/hU4MDS6cLQcSHOWOjJ67DvTUTLoqhqnGZ3mrar+7pdi6mFdNPXxMN4hYnOjmrNBQrD1i94aAw7MxoLGP0PrpLl2+qRO3FSVD8s+xLdZoXPydYfEdQn9qlA0nCXM+QQwtlGucybKFskR2cw8YkH2cDA8WDi/sNsecXSkWxBu+mkpNoc6CieckvGNe9vitTk4mM+b+BHBksG6YrXR+kc3OizyuH9sQSY+OP2B36bEfMCJOpn4MwTHJSH46+QdQYhRZWrnhDgy3VF1hJFRIeSFx2x3u2htOG/f3fiAIFufBjbcBS5fKyORWGibuVJn08x5isj/ZFPgUtSFtxjPo+6Dl8n82CaDAiwcufJSCX9v7L2pupJcgYpPk1ZsLwCgmT10zzUzqgCyY3iq6+CI2czt25V3KzLu5WqzGr9lgGxaIloU4EHVoEu/TJb2tnLkH/l+AWN24umBiALgJtWjsMaXNj/KTyIuWjH+5+aDnQFNw2sr9ZOEapwjJkWJHIgZSWJmDu/oUKL2c6MZDH1zu2MUbDdLYXi8rXbnz5r8F2LI8JCwkklxjSCIrMvrTRAT0nPa1lmzTK0UQJIrMQRHyk1SBszsig1Avvl48EOPtkaGHKsaJUN24eyxfmye/WkR30cgXkRE70mCtpgkopEiY3VOpbMUJCgC+lvntmW14klQ3VZ/VdoMx6NqJmW
 NkeTrRIE
 KhSrJ17BttJlR5bgYLRAZulTJ9NkrWQoCBYC4KiA07BAq8pusbNwIvl/c5dbB18yAkpd2r89O/rpRnMJ5icEPv8u44Up7soSXkmrax18dFsewm8W6GCGOGzFcLXUMqBsfmLHsUC8ByHPq2pSrPcfG8O+xh6J2urhoqw04xZHI++rrnK5VbQdtcXxeiFOak+Eg3AwFPdGnzkMC8K0kfHKRa9vCTvUmHzSCv1K0a6K0wNbK2+Ok8f9UIKUNgh9SMeX4Lw14XwGoli/Ur0BII0qT7Q02dx3tXK5ADSGafSegTfMjfy4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > cleaner resting state (see the diff stats).
> >
> > So just so that I am clear, applying the diff below to the appropriate
> > patches would address all the concerns that you have mentioned in this
> > email?
>
> Yes?  It should, I just don't want to pinky swear in case I botched something.

Other than this patch not applying, nah, I think it's all good ;P. I
guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
somewhere in a local tree of yours. There are quite a few conflicts
and I don't think it would build even if based on the right tree,
e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
rather an addition of an undeclared identifier.

That said, I think I understand what you mean, and I can apply the
spirit of this patch.

Stay tuned for v16.
/fuad

> But goofs aside, yes, if the end result looks like what was the below, I'm happy.
> Again, things might get ugly in the process, i.e. might be temporariliy gross,
> but that's ok (within reason).

