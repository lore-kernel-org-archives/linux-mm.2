Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2643BE6FE24
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 17:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724756B0005; Tue, 23 Dec 2025 12:59:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706376B0089; Tue, 23 Dec 2025 12:59:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608676B008A; Tue, 23 Dec 2025 12:59:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E10F6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:59:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDEAD1A0474
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:59:44 +0000 (UTC)
X-FDA: 84251498688.30.0A1A3D2
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id EC20E80008
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:59:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ds2muEf8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766512783; a=rsa-sha256;
	cv=none;
	b=vNIf1RdlCB7DtcURP/7AeY6ftwXf5soRLWOG5rL5MFZU++C3ZHCiTmgU/z9QNgjBFE7WzH
	HM64N14aVPLK/SvB4u/XHrXkMNH2u9vrGNBp2mY0ptyHMBfwb+xb0rRcQUpeJ+Ig0sk257
	QsM0fZTfbWDtg/p/zODz41h8dxmvfBk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ds2muEf8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766512783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R53CMKldL+ao84ivaoLDo0FHwHdm/f6bhgTHaidoDBg=;
	b=ZMHVjqyDeLm2TGuKKc1Wgi8MW7jEIjvDXZe2HqFN6AmX81HFya4yGreLm8A2J19SBdPHPK
	XmkWOT6lmp4pAqAk/ZZ7SnjPdZZG4GvSP2zX6HCDX24ZPvsB61h4SbmhHXwHrIJZScPhRP
	0QR8NGC8ZqoTOifaNbpJO4f69NXzGHQ=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64d80a47491so4095036a12.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766512781; x=1767117581; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R53CMKldL+ao84ivaoLDo0FHwHdm/f6bhgTHaidoDBg=;
        b=ds2muEf8C7GI3gwwtQu+nQT9LGiYJz9zNlFP37TtyLqxDp2mBRdl2xN/Libl0XMB2+
         3aJXK2lR5T6eZX+3NIAiFK6wN+39eeBJ8uXIM8TLtqMyXJKawU6IgB1a+e+mCjVAoJqk
         41cEtEOtkzSE/uNz422vDUE3efUmBrw6XM5k302aItGB2m02m0hBkPv6Tk3YdUkcKjiu
         EazQI0PZCdQQ3M3Xww+CwiIbTCuLFueaHFbibzNDKRFnqhEPa02ReLBsUCKZPgVgPndf
         YJti0uofwK6tON+LL61MDBylZLraMXtC0k3aOAwAW0wZI8UGQlIrd+9X+ncJ4rCC6rRP
         0riA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766512781; x=1767117581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R53CMKldL+ao84ivaoLDo0FHwHdm/f6bhgTHaidoDBg=;
        b=hWMadEkNmgS0njaOi9pfFk2ly7GmXKYEZ0iOMmIeXcJhGb4b9S/jaUyH/Sa6vOnKEL
         gfaZByZKuImAROxvATKKbMZHSot3co1SHDXNKhFcBdUdcARtZFXmez5i8nCXQcGb/DrS
         unv+Zzr9D0ykNiX8oY7Jx6NfhhMLrB4VdNm6zzZ8LDgVI6GCsNxiKh6lFNaV4U1aUd4g
         4dFuvIFQbck3Wt3xslBBW9id2nEGEokI6soOPoNXce3E2GXJAEbirRPOODRAW123rxW2
         0Dgyw+UVg3KXcq8jFl69Wf/eLxUJQWRMl4ychp3gJk+wE+dRVDNFr6WnIqEbpPTCCTza
         CrDA==
X-Forwarded-Encrypted: i=1; AJvYcCV3NYmMzXuAGNDZ/rpIrlD4QofW96443nOHGvbWgvVEvWul2UODeQiTrnUUO4n0VBr5WdoyqHxunw==@kvack.org
X-Gm-Message-State: AOJu0Yx6rID/Ec925d1Ufeo2u265M7YB4u+VY3UvEcWMJeLJARxnz5vJ
	gZVnNW8I4fR0r7GUjUwznRTygEQjwKv/vCrxaV1wEXJnHK0FjEazY8V0ZL6zwNM4DUv2Szdg2o4
	Gf8zMPKcDYFBr85ywhsS7dlhEEJBKe8qm2jaAFJvAOA==
X-Gm-Gg: AY/fxX5qoxobGw+sCCmSeSE5cEEnlDUfjV+32E38+zzI9AVtprkSVa02kLiOyd0d+5B
	DFDGfRtBm5l+M4ecDkEvf84AJjsUpz+pOBZxq8idjeAkVtjcZ53VHKv+tn04OB2ehQbKBJRWoRJ
	m78yPuKKhq87sRiNx9lxUngVMVdDJWIvVVMSSnyz2eIBv+N1oqFVcGvIBgWXW15icJugAqYq0ep
	iuaPNQIzpJpKalCEXOtV2IegrI5otEY+Hap6ccRMzmasP22m8rrg6INNDxKhRslceZZ6hKWoHS/
	9ZNGAve42Zwyui51u/r7ZH50qA==
X-Google-Smtp-Source: AGHT+IEIcVeNdEfJcm9VqUd+E8mWDB9V1hWp7w0giAMhCSKTNrPtcUlGUPRtf1huaKH0b5X5NkhBYKjrvd/UfQeEqC0=
X-Received: by 2002:a05:6402:13c9:b0:64d:1294:42e8 with SMTP id
 4fb4d7f45d1cf-64d12944806mr12214712a12.6.1766512781369; Tue, 23 Dec 2025
 09:59:41 -0800 (PST)
MIME-Version: 1.0
References: <20251206230222.853493-1-pratyush@kernel.org> <20251206230222.853493-2-pratyush@kernel.org>
In-Reply-To: <20251206230222.853493-2-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 23 Dec 2025 12:59:05 -0500
X-Gm-Features: AQt7F2r0cpQB_ObkQOTsEIIl1kaIhEMZ8gs8RNljcXCPywOe6jERbxst1hl_vY8
Message-ID: <CA+CK2bDvaGmfkCPCMWM6gPcd4FfUyD6e5yWE+kNcma1vT3Jw3g@mail.gmail.com>
Subject: Re: [RFC PATCH 01/10] kho: drop restriction on maximum page order
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC20E80008
X-Stat-Signature: q5mwarpu8n9dr3boscapxjixf77rf7dw
X-HE-Tag: 1766512782-236584
X-HE-Meta: U2FsdGVkX18umydBzVzrvG+UAIHZmehy8WV2706k2G7KK5L3nCjNsbfDz3OK2Rmsq/TDcW9B4KMu31TlQt0Um8qoxsMjeIIeQN7xH54bWnZshMReNeKPsboTvoEbIy9r7h1uHptJGImBpI6SVNtERU52PZhVQB7luG6/6K2ZsMu/KLs2jZWyGOQZdB1zj3dekqkVOnQCr1UQjx0iizkgAooTrwR7xkwcxI2nKp80hp8CFGuRLDZsUf6TWZqaAAA8hZG0waO35Sw+kRo8s27n+mJ4++QwSY1zLV19eVnIZ6RAHqqkLYdtyX4I5IQacpSx/tuRwj+LLiCvfWDZkAdMQZHiLQZ9kxS6QDwfpiT+H7ZrkFc1pRkjshd+w5bRKOprjD4BYZzH/gcJ9Dr8jb2AVMzFBMZrG/Xo4liLBz4qWYMm0uAybIfl4dLSePd/cruKTbr5FKyCN3r3Vb5mY8ETgy8pslh0hHXJvHbMlx78LsTcAGAXtw+ZzBDI44Cm9HFfUEOeSvf72QjSIS1XLFpG+UFfkfaV5chlrVyeUmepKn73+DlkslIK/2pYaZkWaUunJHGe+jkX+/+2XdgkKj7d4o4gYCnDDtXKiVUx/JbPDYpEhFQbZUj9UzttRYoE12UlPiz7yYgIwxNSuJyI/vF3Jl4vox/BXhwvN0z1fRym3Dr6wYHvcfc190T55YYNwRQytiMjLbfqBztyqGhFvjJvxAPB0gpCpAyYVAsllK/WppP+D6T3OStlPB5ZWaES6GtqGjprsDBy7DF+17RMrmpe6IOf+kkPpheknfG6ASTZfWXVZiGMO9pUJRB3HK4ox2DfKidT13pCfNjZ3VPvcu+TmpkU4XZPJcxmlCpYKJCnSQ5wXtkoOai8W89VVDOaVOStkSU5o4QBVuIh+idvr9IRJHI+zpzsGBzUb17bJeS++PO4/4TVfr10EzuvXxCcDpxbOdNpv6qph7CnrjYTCif
 O/ipgGMF
 9m3UP9jsc2eQN9AhjEuHZ5Zns9mI0AWzQjiHH1MqaMEx0uNyplXSqUMJdum9g5mm3caS8RVF/fd674H2gX3/x33PXMeDyn/evytED82YX1bDcvuPlkYJmQ9EuR75bq08Hv9/9mHklQYT5lNG4l25dltMJSdqHPLBY0Motk0oxhkfSCD8Da56qYCdTmcLvgtNn+B3/2rGDNrfEqc9e1TbXPhxWvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 6, 2025 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> KHO currently restricts the maximum order of a restored page to the
> maximum order supported by the buddy allocator. While this works fine
> for much of the data passed across kexec, it is possible to have pages
> larger than MAX_PAGE_ORDER.
>
> For one, it is possible to get a larger order when using
> kho_preserve_pages() if the number of pages is large enough, since it
> tries to combine multiple aligned 0-order preservations into one higher
> order preservation.
>
> For another, upcoming support for hugepages can have gigantic hugepages
> being preserved over KHO.
>
> There is no real reason for this limit. The KHO preservation machinery
> can handle any page order. Remove this artificial restriction on max
> page order.

Before removing this restriction, please also add a patch that makes
sure that the calculated order does not intermix memory from different
topologies.

I suspect we need something like this in kho_preserve_pages():

order =3D min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
/* Reduce order if the block spans across NUMA nodes. */
while (order > 0) {
   size_pfn =3D 1UL << order;
   if (pfn_to_nid(pfn) =3D=3D pfn_to_nid(pfn + size_pfn - 1))
     break;
   order--;
}

Pasha

