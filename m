Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA63BCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 17:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CA256B0088; Fri, 19 Jun 2026 13:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AFD6B008A; Fri, 19 Jun 2026 13:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B886B008C; Fri, 19 Jun 2026 13:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 314496B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:52:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95DC21404E5
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:52:22 +0000 (UTC)
X-FDA: 84897406524.01.6F5C13D
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id A3A9F100010
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:52:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fXDrVjpw;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781891540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBweOLOoLT8l8WaW95dDGRcZkdKMtkyDzvzVE/JdPhA=;
	b=62+pr3S2LGCdEtUQCGI1HfzvoIqYmdJAEJ6efk28RXeuxPaY66mvDTae57KIPbiAGt4Pvz
	hV0OS28uO0ZTghJs618UlGdeDPAZgVnlJhnAPK9S46M6TLhrwGTW00oQ8vrhrERuusVU+a
	DUx+cVGtpXfW/RC0+aCUc7/Pd5sJu+M=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fXDrVjpw;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781891540;
	b=df9T0nVjb2E86Z0HKKjGXRU56/PDasQaZw1yhgrzku120SfsQvgDQMkFFAnr9CU1hNX18A
	iJ3yOGfPsSBvW5FRnOSIGZKg4cqPuV/yaPcYcFprGSFb8LT+TstpDMQIG/E0rarN4Cxi2J
	HDeoQ4AjzhEr+EERwrG3xqdfGx7UvnI=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-519ed52bcc6so239011cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:52:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781891540; cv=none;
        d=google.com; s=arc-20260327;
        b=hsZjdpimN8vXubmhdwFcK8QnR75s0jwIA2tHjt6I+sp8OaAFSlKkQvRI1SLTf7ryzD
         qcKvtCzxK5BdXEDqEy0xGMs7TvpwVVafGZzPb6mZz+ayRXG91Ju5wF+KdH977QxFZgOM
         QnAw2z673JqhazKi8WALKujaqnQJOJB2fOOnoLi3+H2dgLLUO3ZXtZ4y92ZddL2JethF
         rzv1v/ps6FEDBKHLypqGy9v5SSwh/bRR4vmTi8yqV8izlwomn+hlw43WYZg2FVwrv6ed
         wADOgnbgMR+C2vOqkShrPoAcne3GIm6CMFxC+JgX6r0kMmBvMO4T7QhrhGGUQmDi3edL
         Ly6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FBweOLOoLT8l8WaW95dDGRcZkdKMtkyDzvzVE/JdPhA=;
        fh=e6o+pCwfgV6DDIGUyxYGdsU17nCx6FU/diLPH7QUhTk=;
        b=SvRKgkFUm4uAOWkCzmKC1erW7hk3aSSKIxiONDcr3OJTw+q+uVJGSHCiT7JgneOh8R
         Orf1iXcWuMu3h7HL9RtkA0Om8DiKiXeVluOeXfL8Z77tT59l+LBfjG3M/u6/mID+h0hR
         tL6cwursZ4To2prNZ79zshI4SwpALIOw59raqqbATWqrTLNkLJsYYgfNKm0IeNBHuXBZ
         hxSmFhuh0nmUCdRcod3PUfWgipoVpMiZ/+dCAK6dFRGcWrjCReu9gtPcmKccXEm34KqT
         2ZvAdYAAn2RfiRmzePDuCjOv3FABMDb5eII6I9YbZ2kfkERzmA16hp/3NhdGyjAS/jCn
         7jJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781891540; x=1782496340; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FBweOLOoLT8l8WaW95dDGRcZkdKMtkyDzvzVE/JdPhA=;
        b=fXDrVjpwMhXD0zX1tzDQlw6oI6waxahX8IXbmouQHJUTCKxmKJTV9BBWLW5XFs9yWn
         Sja6KIm9QuOdZmSAZs5Dktpoh4Lk+BzCvysvg7qVRE5J7wy1rw5tw1PLibQVpZCv2hTn
         Un3K+yhyEOCUt15dJKvVPwz7gnh/ef4MykYrJaPMxy+LSPLd0/DSebclN1iqm1JVR8CU
         KSVBQ73dFSRV/FrSxE98GXs5TkKQlSHi2Fj22wto9e+aTBOr+hW1gCNws9QMjj1So1gG
         Qu3tc9M40sWWH5qwo9ATX5zXyBRXZC9XjD32BrG0v+2sTzWEMBeAh4HQZhJc580r0F8y
         HX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781891540; x=1782496340;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBweOLOoLT8l8WaW95dDGRcZkdKMtkyDzvzVE/JdPhA=;
        b=gE/qLlgzlvlb11tegIv4DetcZ7mHHAzZc82opx49XgHwxhkPlQp3I4wVCd0N2x/IEh
         VR85nusHImZ1vMUNoWLbToheHV5v3vckdQ4UQ//CMyKE9FSarnxn5Ks9xP/BbioV4kva
         gXple4xGL8PZyRfyKPIe9fDME3wv6MFFv+9kpNounkdacA+TMsivjGjjRnDCdkHwN4MP
         SA5lqNl5YCIgd3Z9u9rm4E+n5WJGpwR0HXOwtkh8c8qbBjSIB0KF+8hLaUhfg20HR70e
         BQq2fLYKoQ8WWPTrXCqT2SmfPdLGRs0nItghgm0lh3tdp9O9sAz+WQ8FGLvBihnop9S9
         GS3A==
X-Forwarded-Encrypted: i=1; AFNElJ9hD84v4lyROwECPKz+t2VwXrdbg+jONBuL7jeIE9pHoxYL5Zat8XL/lirlL5iA+tveyI9DFDIROA==@kvack.org
X-Gm-Message-State: AOJu0Yyfg8Y70ggu0TfdhnrQFB3v0ovdnQvzlLYGsEgBkwgHAZWOtgd9
	r+0jnDep8WbOJZmDBfgWIbufHDaaYvYewXw+AXVi9f9W6bhXM/STYkiH+Fd7YuERgONnbQo2w+Q
	5PUDP9MUVkeDxDXwUq8R9HB6NbIW79143GraJ7yNn
X-Gm-Gg: AfdE7ckKSqaJDv5wclwn83UOsanEK1fUWSkAsAe82KUdieE2wCmg1N1nPJwveL+JenL
	CUSsM6Uc9/gNkffGlYLZ3Zj7srIgIkKqooZoB701TD6umbEY5ipGUH1VOgCk9oXFaRLYSLXmNke
	2Jc4vCaU1SxemSAAi1H22gfgnaZuPqIwx/k8XUAlzDreDbB9+9gB/UzYXCe3wWdt2HVUqngoaCP
	xb39dQMqb+/YhnDm/clCdn6Rf+0BpB/F/Vg+3DH/rZ6I44kT/L3cNz9UCc/NTPFwOv1FQE=
X-Received: by 2002:a05:622a:146:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-519e892438fmr8708101cf.5.1781891539149; Fri, 19 Jun 2026
 10:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260619112852.104213-1-ljs@kernel.org> <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
 <ajVz1nhMn2JwucMY@casper.infradead.org> <ajV0TbwEyaKMzoa6@lucifer>
 <ajV49Fyogfa6aIjy@pedro-suse> <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
 <ajWAYBXHJniJAO4u@casper.infradead.org>
In-Reply-To: <ajWAYBXHJniJAO4u@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 19 Jun 2026 10:52:07 -0700
X-Gm-Features: AVVi8CfZj4z6nJKviyUfEHJ8xHkdW818jy0j9_ZxSUxk4x_AfiipzYtYvyZt1sA
Message-ID: <CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead to
 VMA boundaries"
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Frederick Mayle <fmayle@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3A9F100010
X-Stat-Signature: 9y63aaczg6i1ku33bbji73ogkcaib9we
X-HE-Tag: 1781891540-186747
X-HE-Meta: U2FsdGVkX1/FoHPT/rsH8HT4wN6bM/1ROyRh5yKYRp+AbcmPSKchcInjjcYL3yQaOLL/1q+NLURN285eMu7ko4jwBLIwV8Gi13yrj2Wh+XsjRKgvYVP21/q6c1Enxvz/Vy9VHaQjAdlpyczLykTeRVmkAREfTJRL2M/X4GzRFnN34mZ057nONx0CWG7NsZen+hgMMiLGWWj/KnMNea7RhCIIfuCNA8zA/BI5v/2ERHy36DwisUoDIQ+AIsnktQVC6/+vqcF4hKstfwwqzK2VzfN08kUErn+ceyPzvFopgsKLxmsNhTxisO9rUN1IhRghnnOjP9OUWh5aiQR+4a7xt3dT0jQcY3Vz03+hKoZpL7l5r/OK39xR8TL7ceub+oBVkKRxmu6YKaSMbvQBBCJ8Fg0K5I3R7ChU0dBHTz0/5Gse2BPX43yIfSzjUHY/KrKai/yDbCW0rbDhdJYWWs9v1AjZzREuyGFAprAwMvjGTLsPkKSJcQLtWsrSgzwHvvl1++VIZPJhfq/gpjb+ygc7NoNYnD+IoifzLyRIx3J/D6q3vUN0mD9A/gAMrOqPK1FuRmsRigUywieBjit215V3Db1J7GsC0HfEmnOaSte6LgAsz3hek+LFXsptPDHyiJfFI/BfAm+YtCKOVsYz/gNcKfi+UzfLLXzKAwqIp3ZgwZuiH84ME9UNBya3ENeho9eoBA3hNy7p3pjF65I38LKVEqoL7RU6XmWOjOq+yiV/wqqUdA3dgBt1+OxCwbsuLerNBvIwevfA13i/3Vx3H8WZgI5YbtDhvJB73kF4+6tX21GxtYaudKpMJIBwsLUmdC+rGc9tXYI5rEYpIJFJwdXMMMTpu1fiugtHTPoTZfrpMQ2PdnaA/bmxnxkPs7IZ9IXdngaO+i2q01L+o9BHt11KlbnxYTxQUKXuny0iV6MJK9nV9yUfGYvGKn56wQCuta0zkAWBCmZ/5WCwwrVH0u3
 U3a7II9v
 +vThFUqGkSKLXJdxoNN+W2gDuZ9cPBi91JdhYiCNjFWikOnFYsBDZgYfDNj3m74iogeDwBJMCG7bEUcX3HU1TKnMAOMkFuS2PjcUhjutVVbdiT2Yx9SgAaP5lN/8+Qy/fOb2RHw8H38GmlElyG9ue++VwmL8IDMxC5B6g2IqUVAU/7B9SAbtAx8wmtPk+cisHSxdY86S5a2raCtJUCHkK9pjfznIS2jE+jR/vrMdo3qILgUGgj8IskhpVO+hWgp4nh9GdxQDR60f9AJ3l++R2Yq9Z2JUZaEpNc7MuFo8WYHegPc5yoM+mLav04sA+biBPz3nijADPtxkI/vd3wXk4j+rvuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 10:46=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Fri, Jun 19, 2026 at 10:43:06AM -0700, Suren Baghdasaryan wrote:
> > > Yeah, the mmap usage on SVT-AV1 is a little suspicious, but I guess t=
he
> > > pattern may come up time and time again for people doing chunked mmap
> > > reads. I think we need to take a closer look at this change.
> >
> > Frame-by-frame mmapping for a streaming workoad is quite questionable
> > IMHO and I don't think we should be optimizing or encouraging such
> > usage, but I understand the reasoning for the revert.
>
> If userspace is properly tuned, it doesn't need automatic readahead
> at all; it can disable it and issue manual readaheads.  The point of
> automatic readahead is to cope with userspace which is doing stupid
> things like calling read() for a single byte at a time.
>
> Could it have better defaults?  Maybe!  It's worth a try.  But those
> attempts need to have a very low bar for reversion when it turns out
> they affect other workloads.

That what I meant in the last part of my reply :)

But in general, I think that benchmark measuring "how many frames per
second a CPU can encode" should be revised so it doesn't depend on
file prefetching mechanisms. Otherwise it's measuring something else.

