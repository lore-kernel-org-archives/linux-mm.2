Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAAFBCCD1BC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553188E0005; Wed, 22 Oct 2025 11:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504488E0003; Wed, 22 Oct 2025 11:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A368E0005; Wed, 22 Oct 2025 11:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 318878E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:51:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFC7EC08D0
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:51:53 +0000 (UTC)
X-FDA: 84026190906.12.2520347
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id E4DE1160014
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:51:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yvMkhtgO;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761148312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgJzKa03GZx576mtvOE16DNtsuFs0o60bnNsCmFfVIY=;
	b=IqtQVON/AfVZw+HychdZnKMG6TvW78XSAmp0Vn85fFHG6eMMmwC2j1qHrCa/WNdu9JKP3v
	ub7apM0nV6uEayOMeXjmH/okqvLzgcMFZDhKkZhxPVTvO9jT52M8c5Iyyayhqmwruj06FF
	Jea+bHaXXWyaLmZzTfWHDJKrydbAoFk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yvMkhtgO;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761148312; a=rsa-sha256;
	cv=none;
	b=ljbJD4gJN2RNRgezhnGcqAWfLeK2TAvfEDfpxuMRkcOalbztnLpRtlfqyqVj5bv/OpDBzI
	YLKxt16OBBHNaWqfW7i5FIj/Hf1EdikUXSNl5oWzEpy83K6X3zOgkv4mm7dKuCF/4qdIb1
	7dJTyskGVJAgaBlkn8jdKg+n0/RcYcY=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-591ea9ccfc2so1693562e87.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761148310; x=1761753110; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgJzKa03GZx576mtvOE16DNtsuFs0o60bnNsCmFfVIY=;
        b=yvMkhtgOXtqOFa9saOeZcxWU+9uQXU/oNTKiBWVsWAtRZbr3ViNwCsj286KV0A+Dkd
         4Pw1v55+ocUcnyCF8PlPxCKQkwDdhyEmvMy5XQBzTGaTnHjDmPpW0nGB+tIefhmQKTy5
         a6g6eJL0nBUxQifbFZkQSGu9g5PkayQfDf6kkPdPIU9itC4Nms9XQVDIuQcZKDKKhyxb
         4PhD5Mbw24Tc5J/no+vxXjhdGoN8pGyoqnf7wSP+vLnTR2jNSaytzH8x0qZKGbLBJ6nh
         dh4zMqyCLU6alWXF8bV/zWKDM4Y6MOEaEtWYOyLABnogoJxrWHhTJ3l+4catZ5EjkOY+
         vZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761148310; x=1761753110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cgJzKa03GZx576mtvOE16DNtsuFs0o60bnNsCmFfVIY=;
        b=swLqDaenlNmcMJkJrgL7AcZBOgg5jDtGHiVayIcWolYzLyv//AnEfbfk5zvyGs421x
         NOCDgmHsQuIlWii0p/IoLSzuUtm78VqTitiCCERjuct1fZn6JfY4a0txo4pa69nlfEga
         tdX82Ml3pzX3F5pJXpNk/xpi8eyc7Z7D45gIAt1ncNggrhejy68Zp/C1qb8ap34YDjyd
         oNUm3NWsO9bw/iXiR53YHPK+JnYccpMpQvA1/HtC+nlxysfZie5HxRtCgac9gKwXbhgu
         YlSAbOZlX592Edf7Sl0y2fSxRUSMiz2m1TnhKx8clDLbUU8WzR1A5fsiuvmZD/z9+w+6
         /yFw==
X-Forwarded-Encrypted: i=1; AJvYcCVWxyRZlllQOtiWIdh/8sDhIVPgGCHBBmbLKkMqzjr0nWs016WcERMTpmJ/R1gnrsnjt+iQx88ArQ==@kvack.org
X-Gm-Message-State: AOJu0YxvtEj7sDT6jgf/kqHQpFBp5OTyvkpRZDmTJYx3CKdTYZZtH2QF
	HYoLfoY1+i9Rc05uAhgmJJiJQOlwpjwU1TM2SCzcEnOAjSiPHJ0cGyuIFpTlSqsBxzQHcIidaWg
	Qc78e99Mx2ER3L9W8PsQrGvIeghML9PqGIxHUHgl9
X-Gm-Gg: ASbGnctlQEpVfWvUwhdJN6+NuajWEGHe7SxTAQY/pyCRi5JdpwxiMJTIrDMgUBNBwz9
	kFFDbDcYitVS1YvHIOtc233U8w4dnLCaPSpgUdG5kpN5wq3QdEGaakLIWeRf1ecNNZ2St7jYSF/
	EzOqspYQPrVTYhByXKkR0ovG5zNueR8sSGMyH0cFtkN08llHxKMZdGmcodIuMpCcf45VU/IJHLw
	vDTUalP3WwE7ghgDzpYY4kdJULc8odv3BnkWG+MyEim03EM6L6QY35mrqweXX8j+hgzQgTEPV2t
	uOVUV0wslsLgixrD/i/2r+tHDogpGkFjoj3u
X-Google-Smtp-Source: AGHT+IGSSZ7EkpARJ1sowKr4CL1x11+h9n8s+EYH3Pd7Tyt3wlYGrWJ8L7t1Eu8PFP6//7mTYXclA5aYbFj49+berZ0=
X-Received: by 2002:a05:6512:3b93:b0:592:ee37:935f with SMTP id
 2adb3069b0e04-592ee379490mr907046e87.23.1761148309624; Wed, 22 Oct 2025
 08:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <20251020100306.2709352-1-jasonmiu@google.com> <20251020100306.2709352-2-jasonmiu@google.com>
In-Reply-To: <20251020100306.2709352-2-jasonmiu@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 22 Oct 2025 08:51:20 -0700
X-Gm-Features: AS18NWBmyjziaOJx6tw5QC8WegdDZjZcbgLt9Q6UtW6D8PSJyvC5fCPozboF9U8
Message-ID: <CALzav=eqwTdzFhZLi_mWWXGuDBRwWQdBxQrzr4tN28ag8Zr_8Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] kho: Adopt KHO radix tree data structures
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Vipin Sharma <vipinsh@google.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fufp7gnco7jt5fe7b6xkmea18ej7utj7
X-Rspamd-Queue-Id: E4DE1160014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761148311-727307
X-HE-Meta: U2FsdGVkX19n4VToR1IGso18NqDvgWC4Uwwmt8Pz5XClw0mL9jkHzoYzHvagDbGCsXq3swK9e1S/6a/gqb0VMHzp+rR8j+MwmC0zUzj77VcfrbCgNad8zlTIfZVQrbVbMvncjfLajg2HTtuRC+1co1G5z1kMvgHhqi8YhQenzu2cfuABhsyYoN6+osBC/eIwHSv5DD28MT2k6a3aMfz5WC0pQ7tUSVoiHUMTJiib3Mnmk5V7Nn23ji/6w6IUcM3ER9J/4gM5fry/Z5lFrcE0CjNrWWO8HJyBL730u9zBn8OGAyYUtHycWA54CE3Ga9D/zhawsy5m21Q/SkRtO/EaK+78ukBvG8+3/xGdFk5GFChX+v0VqTarXOLerlvnEMjWRj7B82bNzBmN4SAaVOyIMeqCulmjULESP8kjyLe07senQLpdJwgz2lIexXje9bAwxxOb1r032D6Q8wwqBzHm+FUmfxcPlejIu07Kk6Dggw+seUREH3On1cOri7o9BgZs3M2Uw6QnWUxKG36kLke4dOZSW0vQx83XlXi6G4rcTI04aR10Mlg6yv7oQr3AD/zauu2abc7NKQUUWaqEafIz1vzijVh3i5ZL79k4ZUbuKSFWZ4Qc9KuR29LmxfVbzx5h9Qr6LFD4xPdXxEHpwkaZIMV5yrnSzrkuKJzsBUq4ZcrxEi3afMyZ0bPfXdGZUI9NrYYqZqyALEaaaP8D9QKBRqjZ6hE2dDIkI3xdROCejGk2tS0kQZwCN0SQ+uUHB5uVMgfGLPL1gWCDmbNT04Gf/61ll5U4AkiLIXm0sLhaGLMLT7prqgJfQvrGIkPzeOc3G+G4xi0J+qytUEPc1r2H6jXsAMqpsDOARC0Iq6SdsA2/MvShsjkNVArpztmwYxDaLnxlK2gch44MZEGREGCO2AKkhPax98M3GMHw6L5cDvsdTTX9YtkAvY9s4GhaOyGJW33bdQg7LmZyGTAoDVR
 boUcwpoI
 09eEKKZX09s83lrwRwUdhVnB4rA4UdtHhb4i7IEGlsN3j9vP6FKoUe+2eWiJPe6QUV3JI3iSwY5Nd5ntCyvcpF1XefWSdkxHGeQv5g4faQLy6zmE33SOo8TneyLAjp8Vxw7fPJlYTMDTtWaWZxnIptaub+z/xKjxrBMjL8bUayQ8pkVVnfRGHiAkpNioZe7Vk3waOGF3Jt8ExihrPkJwWPb6ovcePkoWhLrarsItoejHmixBys1Jv4jV+MSp2q6VnqPvaFupc4Y4akvWkpm3RdVFEuAVpN7NLWTDQvWLBV2LhZRBiV3nfuCkYytvXh/mTkdP1az53iMcxdPBkdm6JDR67G1ynXTg9l/5PpRZrFx5hJSqebieXBPTaV1/yRam23V8HSM+WeBYe2Mg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 3:03=E2=80=AFAM Jason Miu <jasonmiu@google.com> wro=
te:
> diff --git a/include/linux/live_update/abi/kexec_handover.h b/include/lin=
ux/live_update/abi/kexec_handover.h
> new file mode 100644

The need for this directory also came up in Vipin's VFIO series [1],
so let's align on a directory we can all use.

Should we s/live_update/liveupdate/ to align with the file/directory
naming convention Pasha is using in LUO (no underscore)? [2]

Otherwise, LGTM.

[1] https://lore.kernel.org/kvm/20251018231126.GS3938986@ziepe.ca/
[2] https://lore.kernel.org/lkml/20250929010321.3462457-1-pasha.tatashin@so=
leen.com/

