Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94445D2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 12:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672CD6B0005; Sun,  7 Dec 2025 07:16:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624366B0006; Sun,  7 Dec 2025 07:16:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512EE6B0008; Sun,  7 Dec 2025 07:16:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 427126B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:16:06 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA95C896C6
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:16:05 +0000 (UTC)
X-FDA: 84192571890.10.DDA8E5F
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id EE35D1A000F
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:16:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fUGovo+S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765109764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QT4cc6ryECaLEhMTXcgpX95Fpt+0IiUEEALeoLDPVjE=;
	b=gdHnEBQUiKR/jKMF0ZyYKFdUVroDSpYi/o0WSz4vGJQX7bydzsbNoFZDOGCXQg8CnsANHJ
	YuRYKwtQ3gG+wZISwnzeTeGpmdJKkjHthUnlnh2hhjnVeGheNb9jmFZefy9Ax0TqTGHVgV
	DQQUSiYJu09XfqpA94R6QmpNycv4Sss=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fUGovo+S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765109764; a=rsa-sha256;
	cv=none;
	b=KO2gwxYcTDRrOK4tZbh6QHe8qP3FPddghJ8McEUiuDdByzr84uoBBsyP0JAjiTG4puJ3vK
	gTzXCE+fj2I5k1V3t80PmZsADw1YyaG2Qu3LcdGI0Erc6x1R/dPXVlxlm23IQdeZgwFxoG
	HYABYsQV8UpeotWe8mHrm5tR3+tZ0fg=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso43433085e9.3
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 04:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765109762; x=1765714562; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QT4cc6ryECaLEhMTXcgpX95Fpt+0IiUEEALeoLDPVjE=;
        b=fUGovo+SNqWPYix9UjGrWZPkCiVi7c+32vvT8hGbQZUEyKoZP4FdXZQ8j4pguNkXJb
         FcV3jrKAw8am5kTjcwxMdR9rWW8FoeJiwyYXq+6hlMryl0ux/ve/X4XACDIHdDVrC6DT
         DKQx7yxZMkXEU4pYfgqHWIed7kEVBt155GfmelF3xe1KrpeI1FRZD05HgknUQsbHfugs
         jpb/9M7kumip+Q6Cihf5USO8Tb56oNHgs94TMDuhMWXbBdtzOEez7/070A33VbmU5PaT
         k+bALzI5H6DQmbGjhOFGIM6kW7RCccAH4ugH44Ag4ruqK0bIkecXZcmucTnxqo+ph81L
         qRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765109762; x=1765714562;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QT4cc6ryECaLEhMTXcgpX95Fpt+0IiUEEALeoLDPVjE=;
        b=X00AObSaZXfCounkMU/3O9f7BP3n13CQKrv6tDqJzKiO7cf5xD5MkFpeVbTrRe4Zpm
         QSfBsAwy7pI1RUJgdBNB7DeIUFBFSULMZEHMEgjuBMLLCNOtsVrWHJM5IsLlEhEAeJ9Z
         UW6zTeFMcrH96YDeAQHJ+X3t71GxrzjeuNGfD+7NlPCkgxdShzVLk1sed9/n/vzG+Ecw
         kTmlBZNgAvirlYCfzmBbWmzPl+pN0gwrtvSgx9ae7llsgrL0c9+hhU9ZplT7olgzRJin
         FkAvB1gz2GdBy2siIctMMDj/UYb9YyMux54jCTQTSF7PvoV3E/4ZDsv73i8pJKvUUquC
         WirA==
X-Forwarded-Encrypted: i=1; AJvYcCUxhgJTxhziw9idAmFnih4aWX6XGbTmGfFkI1kT5m+5BHVR6cgKsfMoPB5qZQCh7/bLiePr6DWsoQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3YP3AuvJA1Eofg1mxYsIOzRJYM0v4jTxv/ULOaxxapzltUXaQ
	D36eE+KakV1bJyUNu/3VUKLV41PSotmSSUSn4aBEK8MoLATqmqGMOuO2
X-Gm-Gg: ASbGncv6FO1osp3jNxpenNQHwyo55issI/sMgqH0cr9bmmlgMKJUeejwdeDt+2i3yQz
	uHVhsKZtL+gzj8K5FENv+o4gPeril0ab57OVSoRuZIS9C0OoWxmBEgm0Rfv4dokoz4OoIuFjUu4
	m3bBC1mx+oSl0xg3xf1t/URqW4d+G0uS1dH8PlXEpl2cm/cUE89rD63HWIOVkou0RC8LSBtH5wq
	Fnu/GpVRc1S87evXCI+k0cueGWhojogj2MP2p42Cv8iemZU3z+L70nbBX/A6kQta8CHZ4sVNNgy
	/1d3peuDvlsqc53FI0kkGBtwy/f85Rql/z9VJMdFhnKXd8xsvdwKldJhegACZbMsGf824u2rmnD
	c3jC34M+y3WjXJqOZJp6pcfmWOhzzYARRHZghIVlFZ0rH29sPgf3yJbY88FXUmB5RLdrm3wSR63
	VRTPQn3MzCxs/cg6HKUvtnSHDTnOrC3gI=
X-Google-Smtp-Source: AGHT+IHC8ivIALeWoT4SzaWmpNaTZ5behrXBR6LHuS1Z2YNL9+AnBuHGkZlkWoEmSgwayqVBsaaMLw==
X-Received: by 2002:a05:600c:524a:b0:477:9b35:3e36 with SMTP id 5b1f17b1804b1-47939df1419mr40530125e9.2.1765109761978;
        Sun, 07 Dec 2025 04:16:01 -0800 (PST)
Received: from smtpclient.apple ([212.59.70.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479311e707asm181916185e9.10.2025.12.07.04.15.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Dec 2025 04:16:00 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v1 4/4] mm/hugetlb: fix excessive IPI broadcasts when
 unsharing PMD tables using mmu_gather
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20251205213558.2980480-5-david@kernel.org>
Date: Sun, 7 Dec 2025 14:15:47 +0200
Cc: linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org,
 linux-mm@kvack.org,
 Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>,
 Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0914A8DB-447C-4E62-B151-62E5E4E99749@gmail.com>
References: <20251205213558.2980480-1-david@kernel.org>
 <20251205213558.2980480-5-david@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
X-Mailer: Apple Mail (2.3864.200.81.1.6)
X-Rspam-User: 
X-Stat-Signature: to65uctre3f7i7oucqtwt48otjomixs6
X-Rspamd-Queue-Id: EE35D1A000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1765109763-189866
X-HE-Meta: U2FsdGVkX1+qv+hB9+8ghQLxdYpkM1+irEFM88LG/wgp+YrRjxNLdOrM2D5U1YYuTkWOTTeIhd1BtWQS9nTHod9R7PmD06KNFKDKSgjWDNSaa7ERhW76+pHk9QmolOtxMoKIxs82qpWpI+qk1+//ac+98neln476Zf8ah0w0Gs6EV0Kd/excxuhqBhvYgwPhBSpOjw4WBRl2DqDxo3ICZyIKknHbBVfqtsugnRRFQOYeo0nafo54hSqcaYATCZUHBYuDSBQLB5m/PClCZ68zGU63qRZpWlBWDEyl5ME9ozbXwZqhSl69RDuynzUsv6q55WX+zn1JHB63DqsxOmXYLe7tnv3ibHrEw7X0919FtKSGv60AOFgbnmU0qy1ZnWwTNJa+2ww+zM85DT/0f9YIpj6mBpjjS/4DknJhFA88DaawRVYgAtkLLG9b4ITZWs7isH+x3jHpCAfOsDl3mynyVEVWuPqRtKffWjtgOEZcX5vwqk8dio1fw8soL8G8VjgEAQYv+3MlhADly7sXGymCdIrzj8aqZVeaaTphM3mLkqxvvL0eAHhJtVP4EHqbeuBxIgoAtoFO34LP4JfsaSfLZhNrNgPmCiqQQuydjKAGBpNaFqrRc8NiciX97rKJU7Il9weR7fSIG1BWFFdXyjI850/TG+6Lp9BChW/PGVYt2CwFr97vn745TQuDKU4VAWMJm3mhEnJWsCUBAZK20uyd31DO0QJJwNWfJ5YAe5Rm9PVoCKO2yotl/FjqRlGp1N/H7Xn6oeCt5OYfbGxcPmKY0o2B6UnPNUkRXkf+SzvCe3rss71uZVmnQJjDx192P3iewI38eWwYByMJIeohDEyy2TBiBOqnkpHo1bypiHvlrmXcVK0TejsBgNrL820KxyVuM1sIXpMyxbf1tjpn2uycUbnxJOO+RYlmdz61HXgK8U6/7UUoZAiSh/eSmL3oUg9mwBMUJ8vaEqbNmlWuWcw
 iZALyihu
 ljRTudEqX/lyvMbfPbBgvR5O8wyYaNKDrkNEeVfGIryu6lOZlURfKcq7HK6XfFek5GsXYAspph8hMzCVlk2Fru69WCL8S6WuvG+1BtEo1N/XLWjD6rJ6QYxqswn8yznpYF7Rg/UeJy8gVapQhKxiZjvHJR0LidI1ltU2SBbGw473DvUl8pILmPfnTyeyAGOQFWp9p51vijUyORbiiNeSJqZCLoJeXs8+cJSsLrpZOyv3/+lXhlcy1PBR4BrCABJ0B55IVO7vNbdREcCwx3lKP3fGGxbgOpsFi3qxj4sjGumEAWslsMTIzNuBRCRGPvgDXF6A+T87ii0DyNiMUPPkTS9k5p2MmP2XMdVNzwo3/GEDa6lH+sAdj7SnYGH7AnjfIlg90+nEjpzqHgIyscnIxeflBuZUbMjkN2J4MVnW8f7K+gHo46i91byOEGTfVfHU1c6SU+Egk6HGPUL0JS/EsOWgdKn8fdIeEcgkJxOdPFWlWr12kDwag+5/sjMpw7XSHF2Bp95VbdlL18GabtelpAloVlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> On 5 Dec 2025, at 23:35, David Hildenbrand (Red Hat) =
<david@kernel.org> wrote:
>=20
> @@ -400,6 +411,7 @@ static inline void __tlb_reset_range(struct =
mmu_gather *tlb)
> 	tlb->cleared_pmds =3D 0;
> 	tlb->cleared_puds =3D 0;
> 	tlb->cleared_p4ds =3D 0;
> +	tlb->unshared_tables =3D 0;
> 	/*
> 	 * Do not reset mmu_gather::vma_* fields here, we do not
> 	 * call into tlb_start_vma() again to set them if there is an

I understand you don=E2=80=99t want to initialize fully_unshared_tables =
here, but
tlb_gather_mmu() needs to happen somewhere. So you probably want it to
take place in tlb_gather_mmu(), no?


