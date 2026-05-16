Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 198C7CD4F21
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 09:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A4F6B0088; Sat, 16 May 2026 05:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB846B008A; Sat, 16 May 2026 05:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0696B008C; Sat, 16 May 2026 05:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE0E6B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 05:19:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DED2F1C020B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 09:19:57 +0000 (UTC)
X-FDA: 84772736034.18.254E851
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C9D16100006
	for <linux-mm@kvack.org>; Sat, 16 May 2026 09:19:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M1z72bao;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778923196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1PUbCxyJOX//Tw7UPj9+qUEfRYerN3gCn9IPzsOw7c=;
	b=CtQWr1rLHy5ZzEvLcEqqqtpyCAPZ7JtnX84OuqkuLSdbzRe1G1I3Yx92PgXkZegA3E15VE
	4E7D1o4WGKWeMrgyowECl+cWZ1HEpXljs/BZi3Xuxa+ARA1zjoyNmmHWIn1jbBytaiJc5t
	jE2I/jbhKSHp//JQkjxA7+WL7abd7Uw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M1z72bao;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778923196; a=rsa-sha256;
	cv=none;
	b=kN3cnh0P+FAcS327WXOJHhm1ZpO0L7Zq6+5zvKjIeY2MhX9QOwUI/oEATRcjVPQpX9SS1V
	/XqME2rwTcnm1qLG7PMfPbiZ7rmbHU5KmzHcJcrIKLhQGvIZODtuhi9UAoMduY+EtvtJie
	MullNyE7hEuYZUDy8eNdLrtylIAZxkE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6452B445DE
	for <linux-mm@kvack.org>; Sat, 16 May 2026 09:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBA7C32782
	for <linux-mm@kvack.org>; Sat, 16 May 2026 09:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778923194;
	bh=G1PUbCxyJOX//Tw7UPj9+qUEfRYerN3gCn9IPzsOw7c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=M1z72baoLmGJAEKOKqQZ86umfRZIzE/a/XGjsuyC2B4C2wlE1QHhtr/w78SZurUcj
	 weHzRq8Qt//48z9bq7n7N7fFaDfSiTsphqENDn1/PUflv232kYu2CRgg8j9ClFq93b
	 msqTPrTtdkX8k+U6G4aTsX4cXywWFSetkX0oSxWR+RmO+NSY4LOAAUtxDeFPzGxF6E
	 fcRtbK64rUgnF5X+E0teg3M33P+tvkBXmpgqd1T8S9R00XEJPVgzMzrLnyWYyKZ/Q1
	 8R7raGUJN6mb6Qa4oFUGszn5/fGQs04AsGgPMZgDV6zlzRsdAdzTjr89YwHXmbRvH5
	 RoJtjjey6r67A==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-90ea08cc5ceso162359785a.2
        for <linux-mm@kvack.org>; Sat, 16 May 2026 02:19:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+av028BXup5aWJI/+ye9LUYZATrstva/w1xphgzhURpu1ATPP+Qwz3zS8ePU0ahRN6qBPhqo01jA==@kvack.org
X-Gm-Message-State: AOJu0Yzo9ul47dqwwpZRQDcxeanFYn+8XKK/U/7ltgC2AYI6qMCwQ/Ho
	1G/LN6YdHc9HAlLVV7Q8tIpAwkHC+Xo8HiWDtfGqnW0w485+xG9W4OJmkf9FMGYvcu+7yKdPlFE
	jsOCN/hJ18veugdPivCOWDbIXcdDvILw=
X-Received: by 2002:a05:620a:4487:b0:912:c631:d797 with SMTP id
 af79cd13be357-912c631d977mr618156185a.60.1778923192922; Sat, 16 May 2026
 02:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com> <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com> <CABdmKX3DhejYBis9htLDnzPrG7vuF3R3URLVNEbnyd61SSsx=g@mail.gmail.com>
In-Reply-To: <CABdmKX3DhejYBis9htLDnzPrG7vuF3R3URLVNEbnyd61SSsx=g@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 16 May 2026 17:19:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zyecY6E-=Tm4_couT7uoM9LMcFdTMUPkZAjj4zUKE-dQ@mail.gmail.com>
X-Gm-Features: AVHnY4Lfp6d8-xrGLNMN2A36VEAHbeTkf6FHYhVfd3tCidoD4YpDVmS9DpWsPFQ
Message-ID: <CAGsJ_4zyecY6E-=Tm4_couT7uoM9LMcFdTMUPkZAjj4zUKE-dQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Re: [PATCH RFC 2/5] dma-heap: charge dma-buf
 memory via explicit memcg
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Albert Esteve <aesteve@redhat.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9D16100006
X-Stat-Signature: 9z5gyphp57sezcidsgge7b9e14g865p8
X-HE-Tag: 1778923195-697087
X-HE-Meta: U2FsdGVkX1/Hzv9dvzezAFL6THiijaIs+rCvwUyCIzx9ryF0xmndqDe2LSF819hp0cFQg9O9x7hXe2ip6carSEK7RTKkkac3pYB3W9O7WT19I1vFtoe1mXDsIEBY7cfTqzalKNOOY5KBE5kieD0KNppotq5Ro09I4FNYitlULlX45cCxsmYEhT2wooUvyHlrpqWbvB4k1k3zGVjnSc19aQDu0A0e5SgYbPW8WLCHqSvl2gB8cXHSXcfAA6M/JEt57DRYn688cqemshLU34LwVtquFMcfESDHMdxT1deitOGNw0YJGT7pGU36tvBHw/fA/94zU9/ZHPgGt0sd4WQqiCTEcaJ0bw+SQo3bKG8cQSgoouUvzzb7VDtHdtkPXg0sWgNrfLlNiewdtP+urxsKttXMk5SZOzEfbRGylbo8ZPFELab3vEvAvmA690NmvZqanu2NpD6lrfOSLJRpQOymZJu6nKw2Wsxx5Vo5r3YMTk5k0WXxqSFIYmOyFYyMd82bQ5PBR3QH6pfowlrsg2MjL0s3cjgkcQTIqi/x2Mv/d1qwMS0sGVpBD+Bniz3JrBCt6vlS4LPWl7872N95cfp+1/GHjgIAwpIV6AuMKglI6kCfGQSI9mjVTvWw5xmppM73qzdOW4lbs4VFIYxHCILtvG9xZJAtczybuJbZG7shfSWxCJrQh7DtMRcD/0iUHytGIiyg0RawkiLD6EfOG/I0OqwwMGbfrmU1QwNM7zpL0PbwURaxC1n5YezLeoPDOfhM4GsTjW7+wPS82WyV6rgAwo4OyqhWNga5R6TglSHc+vtQPzB1O++50DJVQkEniDpaHvwgnTZQs79Mm2+8jwQkgdPCfMr+ehZjlB006aqt0s2A4k2YEJPJ+q8Mf0NxU2wwxbFvQgKptJEGZe1sEg9rzQBkw98NXq/jIaS17zHKwtsS/KoRXhHvYbPP5tkjKOn6hd7UWuhS7JnXya5POLB
 +C++lWEN
 EgGJT1YiP5kUi970Ko1S/w5ojb0yuRMDyrTJ4HIGC6Olaqfw/hGDxD13rAeOfcqR1EmNKXTOs+z+ZPIkenOTO5CucLLTxmDJ9zwsdJ02bUH8rEmVQDouoATy+taaCX4+DMd5GqheoOKHXhkgZPgvokAkqs5dJy3O2ADJT2UViU1vCE8MnHyJhCKXIDTz16pvtTT+iONZXDbRGoSqtDBF3w+tpOUo4nQ9kN6kVtFUEKx+VaW1PYgj64pIV7r06rCISrNS3gC/WwQyJI3RwQ0LCGnQvLRUaw5TCqaEjT7X2OcW8RTZE0LlzOjwuvtzhxo2OmhWKyFsF5bokb5QHbq/I/OgHTM7mPrjx+1NHBJfmQv8TCchw6CTrAa40hgutynrm/zYa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 12:35=E2=80=AFAM T.J. Mercier <tjmercier@google.com=
> wrote:
[...]
> > > I have a question about this part. Albert I guess you are interested
> > > only in accounting dmabuf-heap allocations, or do you expect to add
> > > __GFP_ACCOUNT or mem_cgroup_charge_dmabuf calls to other
> > > non-dmabuf-heap exporters?
> >
> > We're scoping this to dma-buf heaps for now. CMA heaps and the dmem
> > controller are on the radar for follow-up/parallel work (there will be
> > dragons and will surely need discussion). For DRM and V4L2 the
> > long-term intent is migration to heaps, which would make direct
> > accounting on those paths unnecessary.
>
> Ah I see. GEM buffers exported to dmabufs are what I had in mind. I
> guess this would only leave the odd non-DRM driver with the need to
> add their own accounting calls, which I don't expect would be a big
> problem.
>

sounds like we still have a long way to go to correctly account for
various v4l2, drm, GEM, CMA, etc. In patch 1, the charging is done in
dma_buf_export(), so I guess it covers all dma-buf types except
dma_heap, but the problem is that it has no remote charging support at
all?

> > udmabufs are already
> > memcg-charged, so adding a separate MEMCG_DMABUF would double count.
> > Are there any other exporters you had in mind that would benefit from
> > this approach?
> >

Thanks
Barry

