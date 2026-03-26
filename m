Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AE910A88E6
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F306B0005; Thu, 26 Mar 2026 12:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366D26B0088; Thu, 26 Mar 2026 12:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27BEF6B008A; Thu, 26 Mar 2026 12:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13D2C6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:48:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2F28E1512
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:48:49 +0000 (UTC)
X-FDA: 84588798378.02.5EBB2EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D74420008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:48:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BRnLCIV1;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774543727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6SwAAGzJWdxOIniCe/OlfM5nSZmenfS+7rHRQGkUGr4=;
	b=b8J62zCVjP1byxwjjLI/uZChOzc0/nHJ676wLzfzKkA4lManQLuZM1Uqe+nWzqoF4uBUqm
	Rxqqe6Zuti2rPNQ1LDNqp+MGngtdneK3CjgdPGSrGsyCCrGpcgZ+CFyZXz2vlPsE1DvIlG
	C3KQ6zMOSHyfRzVlyRASWNCaSTQ7cbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774543727; a=rsa-sha256;
	cv=none;
	b=JaADC3csfQVNYM+M9o352OHlTkwAl14Pi9ZxAmD0Gxw3IGq5rUMW1aTDI0GpZmvxz1ZJdg
	AI/rPDTcSSSdGRGRdv9r+Qo20F30iCsH/LcUsd3qNKEecDhsG5x7zUchvdQpYGaUaBVOcR
	QySsp0BXV7XLW3zF6PO6EFHIbwbC87g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BRnLCIV1;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774543726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6SwAAGzJWdxOIniCe/OlfM5nSZmenfS+7rHRQGkUGr4=;
	b=BRnLCIV10rlXtMlBVNaCqx2VWdVLkwrvfOAHr2BTU8zHFYikMSpI5nk0qvQFbaa5+XVIVN
	V3o1FXGXwuKiI1i0LmM90Qyogo5chN+X1m2a8rVwRhsFDOTZMvD6SEvo8YcyufrtSJhdRO
	SkQrTZmY3PUY9Ko7G1ohA7C9YiSprB0=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-711-XdAywtMCPH6KH3ILqYPeYQ-1; Thu, 26 Mar 2026 12:48:41 -0400
X-MC-Unique: XdAywtMCPH6KH3ILqYPeYQ-1
X-Mimecast-MFC-AGG-ID: XdAywtMCPH6KH3ILqYPeYQ_1774543721
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-79868381229so68583967b3.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:48:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774543721; x=1775148521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6SwAAGzJWdxOIniCe/OlfM5nSZmenfS+7rHRQGkUGr4=;
        b=hTgAcguqZSQHEoP4WCKpvfwcXjclCv1vpGX4vzR1FOk/zI35OHnf42cJS7r/T03stA
         KT0rpuwjffpQMTtV8Ufj2pBhXpIjz+oblvpo88jtmcGtGrrfJosxDhd0oPKcbruLiS4O
         Lcj5fqRE6zadSKhWpUxy+Zt2/3sWGCk2rszEazQ7ZyB/ovtr2UxK9QCE7sWLYShbd0fU
         bItqQ1ZybbocwjMDNsu2bXvkX6DoNaNT5ls8SpKHMnFX4vIvsU5FSc3V57Cvlh53s8fR
         coHBPfMDGjSyjSlrFrpavDzfayPBugI+DIVTw6mfXY0PRJ1GKRxibBa1UfeXaZpHnpWX
         8xDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJRkeBkBp9+8K3yr81spGCVxWhpuT+/eVlIzXdbHzFo/ovj2oiREIv/x33wWcCwf9inF2PGRS/Ow==@kvack.org
X-Gm-Message-State: AOJu0Yz4515vgJWjBOsOLG/g7REZUf/ykbrSMUJ5cm15WWwrnzazHp/k
	hRWJog9i5K+yWldZ0UZJPbodcZeANssV6w/sPmzSudfRZRa5924vYb/aLDXd0ydiHjBLCAKjs0R
	knNiIRmi0hyMzifbzGZ9MOdnciVcUf/a3QkKVkYwQOA3oi3ethVVN8X0rJCDBl0za6f8f4eWz4c
	5+Q26HSBm/hJtvMHL8yeoy7ewOLeQ=
X-Gm-Gg: ATEYQzzJJqQ0Q/839Fj/ojxN0GU3ugnz353iAcT7/S5vQqFIctFWizYfyTcqYUamO/2
	qpz/zbKUp29WBbsJWxerzdYLBqXZaS8ivZfwSKHOiW12OYHqXY+wYENXPMK8K8lZx/7W2uibzHR
	4Vi/8DsDV9mvOtADYVFhsg62jvEQMqapoiwZa3wYeRLD8n6Fob0U5wxt8GX4iMHScN088WiatX3
	e0lZ6MO
X-Received: by 2002:a05:690e:1245:b0:64c:ec30:9dd8 with SMTP id 956f58d0204a3-64fee387c34mr1927773d50.47.1774543720898;
        Thu, 26 Mar 2026 09:48:40 -0700 (PDT)
X-Received: by 2002:a05:690e:1245:b0:64c:ec30:9dd8 with SMTP id
 956f58d0204a3-64fee387c34mr1927709d50.47.1774543720198; Thu, 26 Mar 2026
 09:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260325114022.444081-1-npache@redhat.com> <20260325172500.990e240d813a4b2db300e0e9@linux-foundation.org>
 <87tsu38aig.fsf@linux.dev>
In-Reply-To: <87tsu38aig.fsf@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Thu, 26 Mar 2026 10:48:13 -0600
X-Gm-Features: AQROBzA4heoPe2rVkoOhgRX-GB9ePm1ZRtz7UqmKBSR8dpRz_HYEXu9mVjzv09c
Message-ID: <CAA1CXcBqOVkUZa_UQh_niRp_GGUMZUSS-6CSwOWZkrpMT_MadA@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v4 0/5] mm: khugepaged cleanups and mTHP prerequisites
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, aarcange@redhat.com, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SHHh8kBXH4HmvL8Ygkjx-ml9wIEAxlUTaUcqLZo--Fs_1774543721
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: uooygu3fgyae9bgnjipxq14r7d8ue83y
X-Rspamd-Queue-Id: 6D74420008
X-Rspam-User: 
X-HE-Tag: 1774543727-733789
X-HE-Meta: U2FsdGVkX1/psSNujHVQmV2YYw7NpuKPvtyEPMD+SdFfsz3RUbYzET+Gk1S/3q2vLpdig1L1OFAKw7kdfD0418NkpPwMaMr+4K0mvm8R79uupR5CnwdxAOpJztEZvBAK61UpUi2piXNDu399FsweYiPBJ0u8T7KJji7ndKm3p28WEst7jQUUkO0weGSCTfvXSbSIslK6rbkBPEU1OWen52mP4DccBcmWJmQGpE1XplcgGoRaWbsv0Fo+qoTWzodIXtjF2rO/pYkJ+Jw5CE4BZzr+Ynj6sWHjEfliWxjUecpJStoUKXY5YT03BygvsrxYWcWwHzG2c4JnTct7GNbQp/5UoiS19d+SOylcvv23rM41jW1sQiXHxsd5N2Z6JlXNyJWhGInD29rNevjIKQe0/1sqVpjauBN8eIxZOIsNFl5/+AVopfeTZ+ZusEJGyQF4kmf/qLfM+Mh/jkk49CRVO+GBMZPlzfR3aVYHY2xGciELBWhKskO1CQaBFgy+P1/DgVSPkRSjQda15FqCpVPnnKnv37kK02yapFreJjl4dVMCE72ylBw0c8QSKx2ex3gX1URRI4KxZI9CItSKoP+GdsqbxljqEPrrRbixuS+7lSq6qG/ddxbC1xi/iWSxkfDM6onOXDmT9I57dvdTSXB93/sSoUNvxL6bf0zv1D66hL0E1diIpdj5iU9m3GyI9VpJ9KGJG9XwOmEtneNCHqF7qoVpE9G/vGOkkdWEg6Q1JssxLcKDhab0yzJDnBqPPF+YSidLlO9MxaWX2FM9PM2PPXlOkNLNq5EkKn6Ut2kgd44W1WxgqTQcAV54GGkAHT+PvC1cAVrxxV9o5oxaztaA0n9ihki3CS/xS0Az8z0kX2xoqxSy4ZeTNLl16g9mecYgrmeuP9VZ6HQuWdj91D+Pepo+uKtWKNHpkqwbauLDrKFpP3b3kpStnEgiHzNemfuYYyRKJLtETA215Yc81ac
 2Ib/uGL9
 SC89mAUbjirjfRfOyzxp6HZPyIln+zCzgEZBAQ01+gNN9UpAxIN3VEJpfmWP51Ryqx+F2XjKGS29GKwzn76XAzvPup8NH2AQDp7rKUeeAnR8EMJzbHVnlcxM9f71wen2wYTloPTxHLTnD7VoKh/Vi2hIEU6t15AgqoA7FfuImmxydWvGOvtzMjIFKEolJjCHzQqYYna6hlFY+2z/Bo8GFAefIpbEi0S7NXe/yFRs68ZUEgqzcnmZBLslOuu7it8XF0lp9jmzYVP55NbtNtcStznmzfU+4oMExC6+Fe891OxisWTO/dCAXpRxOw4xZuSJhzH3w4VQlkKKNEChnBjHbnX/TC7XIhxgcdNHMlTLrVFmPirb65X5femmJxt/mHaAwekr3zSmBLUg4qfR4MObor+wpAnCcfFjsyu9aGiNj6cStjVmTDmM3OmOk61fOk4ibPQ8iAXGJtdOjTC2INlm0aCNOF4fVPbUbH9TXLfXVLcO9piSGHNZ0gWHBaZqOCAck4YEo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 10:45=E2=80=AFPM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Andrew Morton <akpm@linux-foundation.org> writes:
>
> > On Wed, 25 Mar 2026 05:40:17 -0600 Nico Pache <npache@redhat.com> wrote=
:
> >
> >> MAINTAINER NOTE: This is based on mm-unstable with the coresponding
> >> patches reverted then reapplied.
> >
> > Unfortunately the update-in-place trick fooled AI review, which might
> > have been useful.  Oh well.  In retrospect we could have avoided that
> > by you asking me to drop v3 a couple of days before mailing out v4.
> >
> > otoh, this series *does* apply to the mm-stable branch.  Roman, I
> > though Sashiko is attempting that?
>
> It did, but for some reason it failed.
> You can actually see which trees/branches it tried under the Baseline
> section for each patchset. And yes, I need to improve it to log specific
> sha's, not only something like mm/mm-new. Now it's kinda hard to say why
> it failed.

I dont think this was Sashkio's fault; this doesn't apply cleanly to
anything other than mm-unstable with my patches first reverted. I
first tried an mm-stable base but my code is now dependent on some
code in mm-unstable. As Andrew noted, I should have requested that he
pull the patches from mm-unstable before resending them.

-- Nico

>


