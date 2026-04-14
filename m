Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B9BF9D0C9
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 13:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4816B0088; Tue, 14 Apr 2026 09:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674B06B008A; Tue, 14 Apr 2026 09:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5634D6B0092; Tue, 14 Apr 2026 09:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37FC86B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:04:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88CB2588A9
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:04:53 +0000 (UTC)
X-FDA: 84657181266.27.2D1F140
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3BB36140017
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:04:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GNzv+QNN;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776171891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B5ASkA7Nn7xJnrWaDwgTWKCL5Qaagce9AuQcJVX/rI8=;
	b=bRHHdUj1iCnZ4W489v/IDThQbGmWqttRl/+KgvvZ0Xy1xXyHx7nN8CkXSrCpiwQj7urBFM
	2hsn5w4rimK1uTOe/6WV2808XsGWa0jsp44V+KsOjyuWTjIidzoBnXgF2ewGmRlXcZaUtf
	0z387cRlik5/HUetARn9TLo1ToeUBAE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GNzv+QNN;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776171891; a=rsa-sha256;
	cv=pass;
	b=4QLGpa4VuFdomBiWIZxu6QtjEhXBdb1fpU4ZXa6yMsP6PmRkvhEY50fF/EsKBzKxPmjlr0
	D8RsPElICw8Uc+LH1ILTfd20MycST95YbY+gxwEXhxSbiYEG3tWTxAmeTiS1qR6aMEW8Ja
	Sg0EGCEyfuu4Tn4fZ/wn2RpzGRYycDQ=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-671ab90fc1fso2820438a12.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:04:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776171890; cv=none;
        d=google.com; s=arc-20240605;
        b=f/jOyCMX8a13WJqSVRd2tmrZEZ0EoET/bbPNPo06AUXSLk23CenWRYrqvc71ZDJVWm
         rrUmVAc06PfpD3XfSGYW3h10VQLWR5Tu9SiS9jrZYDC3Pvy+bu17yP+pH++WDRUZduCf
         cTt4lnkClkAGLvFRmcby/7OA+PZ5tuAtMJzS8SWOKadYMTQP4yNBjttzb8IEUOxsuZpO
         XnEQboxDfrp705iy1VLUk6eK1GNlJJlHb5NXXo/v760YPHd4nSnKURMyoXnSh1S7jeLg
         T4tUm2sqG7MhqRt4gb6P5nKQVtDSCA+NGjXiYKlvJ1xlRSPm4EO9O3x4ppolNGXki4Qs
         gY3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B5ASkA7Nn7xJnrWaDwgTWKCL5Qaagce9AuQcJVX/rI8=;
        fh=OQNidI2tAj/vHIb9gj97DKS/qOzUxjXB57ekdrFZHqg=;
        b=UQPyclJuEfV+QVCFq9ojjTZLjJCAqQGVHEspIt2KitiZZH3fC65LQil/hntBmkvIYm
         YrulXzDwJkTeLif76Rn8AO/y5+h3KCCtoPzy2A4eWnHuFdMHJo8BibiyiFtwlOGBtPrO
         HxZBgVL8Tzg69MXsiTi5BZ0gT+0Z3xImoGVSpBVjtr2V+ia+/7+QWxVcYC1o+OT6KnJJ
         S45n/oazu11j29JBh7E7vQ6/BObD+G09h+K5Auzq8/BLWiT76tNTXJz6udK0jZpyAXQn
         ZKzWOL2gMF4PXUbVvCB+h2LTxgKcUxi++ByMKnEioq8wmrQ2m7Qk25378RdSTzQ/IDwQ
         o00Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776171890; x=1776776690; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B5ASkA7Nn7xJnrWaDwgTWKCL5Qaagce9AuQcJVX/rI8=;
        b=GNzv+QNNc4/7wh7Uket5sfTuynWJ+7EK2mpj4Vtcvq53/H+ApidYdloxwbrgXWag9f
         J+6ocRXt2pZ8zY1moReHOWi7652BGpvGmD6/vM+gO47e8yMf/nKQcT9qePNaj1DB92U9
         tbkKOmbEWvCPDF2I/0dFX8g04EeiYW7Okwrcj9NWZthKCcatGbIWPO4g1HnQJxyPrMFQ
         btJBVECXONuE7wAngHHi2+3uELwLCsfTFsR1xnJGLaWv+gysvsuooXv/W3rHAH5CzKOU
         CarpNPLJ9ZEc9IuTriK8dHxPm8P1BCEafJNXkQzacRKo6PMgOrFb10YCI+/BRaqBUEB2
         E94w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776171890; x=1776776690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B5ASkA7Nn7xJnrWaDwgTWKCL5Qaagce9AuQcJVX/rI8=;
        b=iqKimJTIq+99+4r94XwwwZYTSJ9PIrCHGLX0t43sw0tT0QwjiANpba/Ym+9BYbp+wv
         LfsaUZHijw1YzYEQLbywH1kbt0RQh4ZjivvOpqxOW0792bAKf8fMvUsMhto9W04+pCkX
         DP0KbFrfsm9hybZI8NlUN+rus4bRywqNSOg492PqHDoEBqAr6StjCuHYAZ1vPXf6jZm6
         sMFPqWghFRhvs5vHWkW77K57Ltl9p5FKnHzCUuxqlZPqkDQO139sGgtr1NAeLrgq9tgJ
         siuuXprgj8ylXtstuzYqspSAhKOHV5KYLy+2fxJ0wJrORc8dqgUZuY3pnwMSXvt74udA
         djbQ==
X-Forwarded-Encrypted: i=1; AFNElJ8YBx3qQTdBN25viFK74rheSMwuueaza0ZiG+ToYPYFCTic78WvqW25bhhu2vNg9GxxSZX1AGK6dg==@kvack.org
X-Gm-Message-State: AOJu0YyaIVm6kCso+lYuWozUMolFQLV29s2Wr25aVyrTaeEXXvQ4MyAN
	M3HucvGr3yH80Nqu8CV0xhtWjqgfRyjYANAdLlE7kZzZu1cdaqXYUnxnAp6cMn+S3NwuG8kgaO7
	/cuvsQJRlPTy3pp/juynC08tXv8c0jPqEjnhmN+negg==
X-Gm-Gg: AeBDieuKiM7V1Lg8IckbfRac5JMPpjC46AtnWIxYhdAe3KgiB0VWjZSbZdhJUzZiwQC
	8dChoyTaqWIgpfYyiN+LeOleydJz//PGOnp0+74o16WtugML4q6NEeCxeKctUNE4dmdlzCtSuqE
	AgZQdEtyP8WrRLBnZ3hgB97tG6QxQkGL+3rB334zakA7d1bwkH5vpfrizIExpbhOKGGszU9QZxG
	eFzE227W3MKCEuG6+azBzznESpgIshExQU23rXr0jOEqgyC3yQPjdk9rts2RJ7lKA73kaSGg9pe
	678ha6dV3TS+qWtK2j2+yCUWL5PmkMTIJzVAfQ==
X-Received: by 2002:a05:6402:4410:b0:66e:68e1:fc18 with SMTP id
 4fb4d7f45d1cf-6707a47f88fmr8238343a12.23.1776171889504; Tue, 14 Apr 2026
 06:04:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260414121752.1912847-1-pratyush@kernel.org> <20260414121752.1912847-3-pratyush@kernel.org>
In-Reply-To: <20260414121752.1912847-3-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 14 Apr 2026 09:04:12 -0400
X-Gm-Features: AQROBzCKTkocxUqaZGO7GblX5QsCAxwNwtdtbLZl2LSOWRE9D7gkFi-Y8v40LZM
Message-ID: <CA+CK2bCgxsb2W3gJ0ZF+M2D+6jaUemP8HR90SKsHwGi5S5963g@mail.gmail.com>
Subject: Re: [PATCH 2/3] MAINTAINERS: drop include/linux/kho/abi/ from KHO
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6bcfrdjcciah4poanfd6uq5npi4mbu8a
X-Rspamd-Queue-Id: 3BB36140017
X-Rspamd-Server: rspam09
X-HE-Tag: 1776171890-851416
X-HE-Meta: U2FsdGVkX1/LyDUmpbTJo2oEPRCm5TeCUFiGIYCEKaydxQG63qEWb5+levGXBv20puExwW5q6w9Pt6hlvqqsqjvY+9r+artTY7gKfPQP4SReLXEEh0xhVmXyT+536IoY+KvLmT3sgQzdW8F64uUhDi+QZFL2xaXuHLV8JS90xc6wDS6+m6g2kTkySOgMjsDe3G82tVseAl10uKE+3Mm+BtCtFgZ7mfwsJWxL8HTqplfjpNgJT9uz8fciRWsLEOnmG9IoEXGqnf94SlSvzIhRIQYUSRT5sw73rc9tYkVsHPma9UEFUoE4G66VXcapgcD4/ELGVCbw76Oxvf08/UuFdYHHa8MrPG5y4rYJXSiDDNZR0McXY8rmdo6Yy0/antFuk8yw+kwCkSwh5QREDjIL+crrBZtp18D36gZ6pQwDfKuRh765RwIn5ASljjo5Ey3xOPZk44RiC3sq0h45O231OPn3KpsQ8nD0IFoh/5Ei15QAELwG/ivNRX+U8aaPmi7JBRKfBmbWItPgbMni1pQsVnfLSK/CYsTxlvt1TC/6lS3FW56or+PtNDqhCN/ttSvk0G2Cqfa/NHnJHfTgoVwUhpxBvG4iGGRU0ezOLKZwY5fRwOkXCZXxLpsQnv/vYYph0hUVQ+QKvI2EnHZUNwXU5sYFjIDcv/lPkKz1In3FHcjJU/3XTEkuWGOrlt10MEpRNgNuhYaDPWmPkDHewgHaIoQfrcOcYIT3KqFhuIrh14uhva2sRwMZgCPyScUeSaKBk/+j7HifnaY0QHgBRwSr3dHu4c7/Z0GkILFafbT/KyJ1Jvbc2+3aCenecrkQwSICTeQsxilBvOmZVe8H4Bz+eaoS52Yff5M6zkqK2r8zgaKo4cX1mlzLwk5O7xbPR5jiShvWGNIgafXhDjty9CdS2Ky6B8XuX/ZgQaLBiCxVGmEs71/Ck/xg+HtEBk1Tc5sHUG284j6XWCwqwZLoIOa
 XySkFdbv
 fhfZ6gwBFLPpYrIAC5oAbejPhH6MxQdLToMnVLe+zo6Mw7oflaN1RSkueCDLHQ74WO4S3CuXFMTsLQLMccFMJq+DkhKSEXOOfKTJ4LhfIF7ih0wi8XuUlPc4B9BAxwBM49ZsIjIuvhlmYpZY+jKCd65EGpkAoMq5ziS7itdMhTs7RqTohpkXDLFF/bpX4qOM5Q6TItJ7Q9j39Ug85Pc3RfaX/2kRqMwZeP9yISwGrwiM31kYHPm7QRKGw1ZqebYuFYS+Y8YE7g3C7mlHSdE6/3n2XaWuk2o9KssDbaGo5WyNYkTw8OMbfq7Y/q0eWotNEZByb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 8:18=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> The KHO entry already includes include/linux/kho. Listing its
> subdirectory is redundant.
>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 97820188a600..c1e2cefb4493 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14121,7 +14121,6 @@ F:      Documentation/admin-guide/mm/kho.rst
>  F:     Documentation/core-api/kho/*
>  F:     include/linux/kexec_handover.h
>  F:     include/linux/kho/
> -F:     include/linux/kho/abi/
>  F:     kernel/liveupdate/kexec_handover*
>  F:     lib/test_kho.c
>  F:     tools/testing/selftests/kho/
> --
> 2.54.0.rc0.605.g598a273b03-goog
>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

