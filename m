Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705FC606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZcEEBWLk
Received: by kanga.kvack.org (Postfix)
	id 888126B05B8; Wed, 28 Oct 2026 11:41:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837C46B05B9; Wed, 28 Oct 2026 11:41:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF8F6B05BA; Wed, 28 Oct 2026 11:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 423DD6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:41:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE20DA0142
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:41:05 +0000 (UTC)
X-FDA: 85372448490.29.D618837
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC85140006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:41:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZcEEBWLk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=kevinloughlin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35HLfcrc/AjiCKvsVtxqxuglfLVc60GMP3of72tM8d0=;
	b=kRJzBD6Hxw+svX3litiEX5eXiQ5m4CKGS6aft5r4/yaNSKduZs6HS4ZLHNvCHAgCwT4o6T
	x2Ba0k2XqoY1AOpY5YC3jJ8aU6lcfLoLirDorjQ10V/ZINiH+YDGFI7i7oN+NYaYxHmFDQ
	VzASO1rUjeHEbrlxr5lxvJjix7LslvY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZcEEBWLk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=kevinloughlin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793202063;
	b=4o6Dd/X7+DBQYd8XB0eSF5Q9RITosEjw1F/t87y1pwxNabl2qdPy2my4cNuBPiRT05HpSe
	kcSQUBWEHXClyNq2m6OYNuvx77qXiG5qskL6GfA50SqPrFax/t6l8ZTeGwjadMZj/TyTM+
	J9I+mCT0Q+9YL4eijjsNkFUPk98+ntM=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso172805866b.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:41:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793202062; cv=none;
        d=google.com; s=arc-20260327;
        b=Qs67y4Nob38WOBMyChDS+7j73v/LkTlcIbICIbAn55OrDqv+gGvUoCNgFQqWi31NZ6
         TpN4/Zyjxt/9h1Ou+9SX5KPJvO+xTvjkTePY+WbYduhc7ccgK0Q3zvNAX3DPV4Su4MBc
         lnEeG/F5DPG8fZViQyS7KVRSNKjUzb2pzw4FcPjEzc6uEeekZF3Ri+QfZHXvxrnd741x
         5Tzo/YsehiOOUbFWUXkXCXVK3QdMdRib2VC1dlzJuFm1eIZgWIclq4r7d7p60en4dxFI
         YxNpjy20M3k5wyvEf14K7I7zF2cbHccv1nmk1dsDGo5P5MtyWXI180TPU+KJMrDGM87r
         lNoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=35HLfcrc/AjiCKvsVtxqxuglfLVc60GMP3of72tM8d0=;
        fh=YVvMaxspBbsdSUnYapGScwGzQUJ5NMer4djryM53hsc=;
        b=nGa2CSj0/NUOKlrTeegAiX03L4ZLTkaKalLkXwoDzzKW7eXzfqBrbDSdvuQgAyQ1ZE
         fJFImTyTqSF6ZzueVXh1PHvBCvJfyCRM3oXh75PB0BrwkgQ3IfWXFglcsDvWMEYAM0PW
         DzV8zScqfROcM/HW1SoDPg7YE06dy2jHIpKjSqO+32SWd1/nzq5LsrrlugLcofRKTBQT
         wpe/6EE62c2heMGcQ3ngYEUt67d57Esx0RlyjMDI7hmPC73lMmWKETDqkSIUik3a5LCU
         DWznuDOuZzrwh0Shr5Em4m+gEBHMu9lHjeuzI64mIhkYHhANkblfs/CcOo8KauLOKmrH
         geeQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793202062; x=1793806862; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=35HLfcrc/AjiCKvsVtxqxuglfLVc60GMP3of72tM8d0=;
        b=ZcEEBWLkChi3u+ZzOepsHgZbRhAShJPlGVoKvIV8dVeL0dej79PgfZgQTUyRiizBsw
         QfmzrpZmGEnA7CpRXCq6T+tyPckLKAtHrDyCnbQ8PDGwJHWq8n8i6KzCMgM7XpBd+HTh
         5R4b/H1VsoQRfsT8Fc9jWYfdUrsE+l7pe6UQRQvp3vVDqyIMUPjl6Zt9GjsQXfEFhHit
         W83lF4QeLdvfp1Kir//5+OIrkTWHaW1ZuUg6gLXTGBWw6UWjrKgT/jStC5ktsBZ/50Ht
         HhvTQRF/SLqKdh0f0UvtMaOxJF6Fieyt5P2PRBvxFjSTPxRQQKtQvh6q8+pcJ4VTEuoz
         HpcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793202062; x=1793806862;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=35HLfcrc/AjiCKvsVtxqxuglfLVc60GMP3of72tM8d0=;
        b=d9fxVYIjquLEKotILkiD87api3J6Tap8lJ8RSDV6oRZ60Se1ZMUcuJ+GWyLaMVjP3a
         oR35JlrZsDgr7QIPwdJ8t6N2Fx6RwTxtI4u8ig0juqMiM1ZL4VIS5ylPri51hTpLCWno
         ycYxUwgBW0T3u8/YPyPGFeWA1DhkrNEfp7NP2nueZEFi+4YKxYY2x2JgoTpvX4yNG7q7
         BDVtXaMh9BR+GZL6kZqQxiWLA/LB9gNm11Qw/6GgIg0u546sKAQelOhlvlyl5V/rydaf
         VmgcICUjAcF33/mRfabC7nLwTIX7iCpmNdz5vCOJ9LkNNr9O48D0ryq1pr1LR3zDVr8U
         Yhug==
X-Forwarded-Encrypted: i=1; AKwUvBzlf43U3q5nJ+5dFwCqIIoCV7pxfjZpiQe2Hv7hWEkgOC3PNDpE3QA+zfpLGhzNmVPZHcN8G8oaJg==@kvack.org
X-Gm-Message-State: AFq9FYK8wn49qHe2iFn48vtb90TiQ9n8KCZdNNzGIOr4koyTyY2mOzRS
	sqlZyY8xEQSeDc+mh2xU+5dR/BO0gq7Mk616+Drq18yyRbk1DwjZX7mWqsY2bQ3STcXsrtfa2nf
	BIcP6yAyECdBnFddX8FT+uvPd9H+IfSGGgJ/LPWo/
X-Gm-Gg: AYBFou3csOB2nREuN1W5DO5VkuyTunz5UJ8vDKvle/QrWv13qkljxKcHH2hOFR9C2AD
	AUgpt7wIFHL0/8pa0KuVJTUZzcTvtHRE6IBlKivG89oFabYSq5y2XyuBeMIYT2sZwXJ9owzuRKy
	XACnXChBJMdbD83FkLHGZhOmFlJhUpKXD3XsocuYYjYm6AXmkU4fHLY/1JqbK9bBMMIjfXje3Df
	FC6mAIIZqaAIZncNfuxnZc/9AK+nZGmqb5u1sVHRwYVGRp3NiPccfp2opydngqC1EjvCY0fqebK
	SGI7fDOl/j/s0W/VH+LEl6Fyb7z1ZEHHVR+E5D3l52d1wCMt6peYf64pEast8WnbdkyTdMkkhzR
	izm5wqC28zp/RtIjzrwIMqqsEgD/d1NRrtZPYFTJ93Cv03bgnL7wXULS9Zthx1XyWAQ==
X-Received: by 2002:a17:907:3ccb:b0:c41:30be:4f82 with SMTP id
 a640c23a62f3a-c49bdf82147mr200595566b.39.1793202061724; Wed, 28 Oct 2026
 08:41:01 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027025616.1632690-11-kevinloughlin@google.com> <2976bc2d-2642-4448-9c1f-ec13e67e45d5@kernel.org>
In-Reply-To: <2976bc2d-2642-4448-9c1f-ec13e67e45d5@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 08:40:47 -0700
X-Gm-Features: AclHuK9oWsApJE-SwbWIqUTDRpRi_a-FG1r_BRCTB7JJ3QabTlKp_kjVIFg_bKo
Message-ID: <CAGdbjmLXhPkutP3yCNYghP_tkvHm2Sa+6aBHF1+9abaai-4bAw@mail.gmail.com>
Subject: Re: [PATCH 10/13] virtio_balloon: add higher-order page inflation
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>, virtualization@lists.linux.dev, 
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sidharth Telang <sidtelang@google.com>, 
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Jacky Li <jackyli@google.com>, 
	Steve Rutherford <srutherford@google.com>, David Skidmore <davidskidmore@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC85140006
X-Stat-Signature: ed7wpiy4j34n6dd5o3t59ys5btbxpjcx
X-Rspam-User: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793202063-520047
X-HE-Meta: U2FsdGVkX19ZVPRSOlpdi6hxV2RrOLivWygQFfcLpz2uWlWGZB4OcPCb4sb/3hoHmHBNGoF9VpR/ney075N3LIq0fIl6hcN9UZJwD1cnO6Ubtk7JgSB+RmGOx9ADyfJWdnfT5edaZskJZHrWlTV9luyvPAgvFuSQ0Wk+IYkceoS6SZMkzRuSYJj1VpN/W70DUqDnr9cKvBy9LCLeKqYM+NeM54MYo68nXq6lf4/MMwT/C3tTWL3amdjZJXZHrkePfasxwMj+zQ7zvfGhfwqfM4uwTj3Jqt0JSNYHgxwo4Rj/DERAavaTgu9uUPogw9NHDDOXj8bAlqiyjKvs54RMNh1kEhJms+RjTA4ZkBr6EfDCDUwxqZDiHKwo2z6rtdP0DtNQMAaejf07N7YMxq2CS/Gcp6fB6mCm4RJQQXi5C61JfmC8Q0u8sHhItS0F+I15O9NCLwQ6227tlA3jCrPbgwd5JMtwczjU8YI9p8gfDbfmChS/IAOCLvJ8IEuiWnRpn0fo8PX2VvmqADPgQFNlM7U+mLyK1HQ1RmE4qvYWy9tjAzyNBego/TYxpVfXGDyzXGQyIka2edcPVu016dhVACVxDerxMNflHt5FHZNNEYV/GGqDsknCeuSv9bYCoz9jy6ET//c4vPnz+UPq/U6ykSc/ym7Vom0sERNsyJxgbI57Q72LFcEDfcks775g7nMnqjsCnfnvCKGETFqKrU+9JBR5HMJyjqUn+EJvH7oawff1ll8P9RHS4HzKspqxp5k3Zkr68maK4SlU03v6x+vcLC10Jy1Ji/OqAgjEy2g/OtBoiDZMm7anfSKfvcF0F7c26OQ20eA3zjn0YUl33anfq+ld4d5pXzo2sw8IJ7uaI/f/yYfNvrBibUfrvuiwZucTvcWyqgr29hoEzMlqFpNETayDq6LUe07wjR6rmqXEF2oPUensxgdi3gHbLcHjVTFw5xWYXFaR6N/xPWIhfX4
 zepvhI3D
 XeIaFkcYB7bJ+4lnNCSv5h485AxnTuytpYZ2TZ4NbAmunbjYHtZU/yuo3Y/MPxIMHV1J8B4ANZt616QdgWXZFkZHH4LbpyL/iIS4s4XMnG7mKAimHuagGOsTFQ/pisqrktGHmJDgTffqQq7mI4ltU+8uFud3OdtULjcZnVkDXmo2xlzx5Rq9fiJu4k4O45ZspQPPcIyYACDIAHU8hxizlxioItZSEANj0KBXKsOZKTu9RbQp1EKH7zJDD3JfzS2vC9DtTUGt0/K1Ri6em46qSJK0V1icLPvX3HxdkwMS5nsFyVsvqeNSRgd8N2KM/RsXS5hBKrinA2lpLwRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 1:59=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/27/26 03:56, Kevin Loughlin wrote:
> > In confidential computing guests requiring page state transitions,
> > unaccepted memory tracking operates at the EFI unaccepted memory unit
> > granularity (typically 2MB / order 9 on x86). Inflating the balloon
> > with 4KB pages would prevent unaccepting the backing 2MB unit.
> >
> > Inflate balloon pages at unaccepted_memory_order() when
> > virtballoon_cc_needs_state_transition() is true, while retaining
> > order-0 allocations for non-CoCo guests and CoCo guests that do not
> > use unaccepted memory transitions. When a higher-order balloon page
> > spans more 4KB balloon PFNs than VIRTIO_BALLOON_ARRAY_PFNS_MAX (256),
> > transmit its PFNs to the host in VIRTIO_BALLOON_ARRAY_PFNS_MAX chunks.
> >
> > Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
>
> Sorry, not happening. There is no migration support for these (large) thi=
ngs,
> and there likely won't be any time soon.
>
> NAK

Yeah, you're right. Another great reason to abandon the
inflate/deflate aspect of this series beyond what Michael pointed out.
I will follow up on the cover letter RE: how doing so might provide a
path forward for the CoCo free page reporting by simplifying things.

