Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E76CD6E2CA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06046B0098; Thu, 18 Dec 2025 12:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0316B009D; Thu, 18 Dec 2025 12:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05CD6B009E; Thu, 18 Dec 2025 12:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB4446B0098
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:50:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DF4B1A02C1
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:50:25 +0000 (UTC)
X-FDA: 84233331210.19.A6503CE
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id A21D8C0002
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:50:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g6MkVkAw;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766080223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34kJXR8Z1l9xoA5XQbc7lSV8iSBzpyKM6gKf5HXGiIw=;
	b=ftEOTqBcM4dIEzkOTULwqe210+o4vhfIeCuy9CGEhzsMdtIvL0IH+CsqUrANW5jB1a53pv
	QOnlccUMLERUSA3H5m2kjKvoMPortYzKN00KJt8VcVs12oWkBQVv3SLyVdz6QAnl+uz2Kx
	y8VK658VWj7oN/IEcMV4yasysr/EMGQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g6MkVkAw;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766080223; a=rsa-sha256;
	cv=none;
	b=CnD/hq3aKiboJQfRZkti/wlYO/L2nd6KwSIiaN+zLFafqoNNulhD5vMfT6hQsf8Lyt3w9a
	QNxf/17BH4hq1dFNXxmWt+SDtcML6jwckambT12fjcUjWp924vDiCu65BdtlAXChbYPPT9
	MEWQXFhowOXnyDvnalgM6JkCugM3CPA=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64b8b5410a1so275336a12.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766080222; x=1766685022; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34kJXR8Z1l9xoA5XQbc7lSV8iSBzpyKM6gKf5HXGiIw=;
        b=g6MkVkAwh65+0Im4by6mC5aEVoWxaZClJd6NKtd8pgxpidaKTWQfuuRhTkzUOYQjnf
         U7UNj0ppN739cRz1C+io5j6ET0BojXV3WmStBMPWMZCZCVH2b/dZfWwDYOP3b9omUc5H
         2t6shiP5a64i6/bV1Ad9lj3aS3N21EAijw4RIIVvAwWW4fpx9x4tXCE4XA/iWUmQ4d98
         RPOW4zSXsAferDZgncENKflXpausSKsyXUngBFS+9Fw3RBtgY3ouHxj9Mvo+JBns2rxd
         Wa7T3rrh8ClIW9tHeN6LhXBDufEdp+K5l1QCsAml9nTy4puxiCi8OzCjGe4fPpCRt07/
         AtJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766080222; x=1766685022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=34kJXR8Z1l9xoA5XQbc7lSV8iSBzpyKM6gKf5HXGiIw=;
        b=krHdJfaBA+yxPDGTyH+ltMvFr7ooxYqUfBPFOU0WYKZU6LPJILCYaUqM6RkIra5gM1
         t/uJZ6Ju1QBU8fHHHtHvGWFzuGgbEQLTF3v/OWCZ1fK3RqxaH+4LwV2aoU7pUk8REn6H
         ncxeTF+nNe8gEreZxEQI4KxjjPWnJjhj3gO3Kph+67OypKRJioaGjGBwoxaw/qy+60k2
         O3klaO0LV9EdGBueeGQInN5TwCaxDRD4YGDFogY2qdg31x2sTyZZRei809xdt14vKQiG
         im/Gp9w4oXtJYP/gOCeJnkMK2m3zlX2ZGF+H/8HqKikS4a248SiMQ1/oBOu5kupJZj4A
         GD4A==
X-Gm-Message-State: AOJu0YwgkkaNSIPX3lZWPaSYS/wFMV/iKEWfC0iSMw55jVnKJfo2iG97
	+a5OP00ldyXahifrPv5r60hBYc+WLTqi7p7ttucpTWHj5SBBXWZnnM/JMYcmqI2bsVUffEmftp5
	iIXcRyumaviWFbdk2N5oqkQU3maMyY7SRXKHWievHWQ==
X-Gm-Gg: AY/fxX5ULntZDixCB6XmwnUoplv4oK5XNP8l1Br9EcMWxrHix/utSsvHrtquAhXK8G1
	PAXz11VaJaQAv7P/vOv9jSzr8Z5E6/WKpikxC+cYWTOHuj5MqE3fNZbEBZb58SdZAtQNTcMnWZ4
	IXy4wuL3IrtvYOxb0LD6TMEK2MSxNEezrnhX2ZZi97l+FpVYig1kJ8N1ls3sEBAXrxv5jWJDa2L
	VX5Dn6CsXVbHdd3Ji2RGUUC0f0+9Awa1NhkaP8/JnmM8UNy89WblpZ8wPNCwGRHc7wZzQqQVwD2
	p/W2LgJc0ihK60ZhyBFGBtXl
X-Google-Smtp-Source: AGHT+IENlmR0sc0Xb7DhLwn0Vq765F8OyXjE3fAqqAeGP9hcTJDm+HMWSnu0fNRLLx3SXw/1GBSLkwKC99ivJnubJVM=
X-Received: by 2002:a05:6402:34cf:b0:641:15d:6b97 with SMTP id
 4fb4d7f45d1cf-64b8e94713bmr224102a12.2.1766080222160; Thu, 18 Dec 2025
 09:50:22 -0800 (PST)
MIME-Version: 1.0
References: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
 <20251219-pgtable_check_v18rebase-v18-2-755bc151a50b@linux.ibm.com>
In-Reply-To: <20251219-pgtable_check_v18rebase-v18-2-755bc151a50b@linux.ibm.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 18 Dec 2025 12:49:45 -0500
X-Gm-Features: AQt7F2oazAcKk3yq-_8d8SYNXUmWrpPknuvuaCQSw2vGEhneFPgafk9uUlx-JHE
Message-ID: <CA+CK2bD2FdFdM+=tcvf6L2x-j=b4HnixUwf4irWp-eNwQUeFrg@mail.gmail.com>
Subject: Re: [PATCH v18 02/12] arm64/mm: Add addr parameter to __ptep_get_and_clear_anysz()
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Rohan McLure <rmclure@nvidia.com>, 
	Christophe Leroy <chleroy@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, x86@kernel.org, 
	Nicholas Miehlbradt <nicholas@linux.ibm.com>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, Srish Srinivasan <ssrish@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tai85mr865kk9pigaghuzwyc5o48k7ki
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A21D8C0002
X-HE-Tag: 1766080223-809315
X-HE-Meta: U2FsdGVkX186OpNicXcdh4f6p3J+u71vtHwRxMrhGQPOZeRyu5ysOcGDGr1IEj53XhFanoFPnw+dnUrJk2RICS2c97VyTqiulXGqTzYlT8vcNBMqfyqOd8lERqe49M/hbwEYmKW/9wUyTePGR9U62TToKLdZBzMq1qAUkv7IzoOSgqrCOzHVLZNNfB29ZOjLwPwirRA3AurXgslkAEZYsbeMiE5wSIJniJ2LcfZHwkzaNVAQDaUiDr/OwyyrIPLmMdZTy6qgt4fPpTsgvmYX5vSFhl2xXQbmaoO8jwzCAiahtzzgfGI665IuwG1Vec+Z1XHmNACvVm4bc0o8QHlePZIBwGE4lBsTd5j0pMNK+YHemE2JSZeUyGxdTJrakadvUpkaYW3qRHciaVbOd+RKsi7esWkQ7FZ5z/HjI2PoTjrdYbL2fc99zPDZZcaLkGC12YOhCybM3jnNKjQcNLJl7opKDMMs2m6lQRglug3ZkUleizBva+FLssz1DNVRWsKonYxoDFUc4WZY7gVknALV2L2AzW3bxkSh20anNLfjklxY+qp1aCsbNzmqo6YsxOqAs1CUQ577OipA79gYDD9ZrsV2eQ+LgDtIN7wpcqbnl4VE4zvyQ0IbYfdwIgRUmBiBk9vlUR3In4yjRuYg/dtPINw1HPKmM1QyS1ztmM6OjqN1qCI1x1+nZudyC0L8Cg2awXuMN0jdjhDawJDdiFkxVyUozgEUB5bd/58pOU9nERudSs0jYTLqbqReBr5qr49vZ2LkjFYh168kSrOs4iWVP18wXGKh0lF7RRqNS8/WDlvwPd4HRpoeBChVhrp3pROtup2CIlIR01rY9CS+1XCu8xHuOmSZ6GBeELuFDuPlDTrTD2zVccgruJ8aDZCh55jfEL/ypx37cs6wULmNUL7XbcxIUaBZ/85mbwGlm5bqr470hB9MVoMV+PlT2BqFhva+VwnZwLZGYlgSQpXHHL5
 M0EMEaBz
 r17vO5Sn6v74m7R0u8Z/sGZyhsMqqyGncEBar2u5kOl//yYKe/PyM7EgcM1G1+CtA9vqE6e19JvBrPp6sGxBQHTgcZkG1m+fSjcx3x5KcOiLcBGUXvEgWWgMZmHYUExXsCaNPY1IcBsREG6NI+BvVzQ1wWRRJR045+ylfjuXpUSe9nWQ/lANW5cSOfR34S3r+orB/dd3w6j1HrgPNuCSd9kfhlgcXBvZtbaJl9wMtaz0dTtf8Iyf/9wBl4gg9Pd13BLjx3Fm5lmy36MmsmX+IE75V2aaBnbcjlxM1MIivkbZ1txoQji5tfmLcX/B8dcaUWmo2uTESNbs5iQjWKUR+Efbre63p/abZnXwDo9jQMNik+19R6+pNdcV83yo1dY1O0wTGZ/IhTfLwY73hxIEXie/gWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 12:10=E2=80=AFPM Andrew Donnellan <ajd@linux.ibm.co=
m> wrote:
>
> To provide support for page table check on powerpc, we need to reinstate =
the
> address parameter in several functions, including
> page_table_check_{pte,pmd,pud}_clear().
>
> In preparation for this, add the addr parameter to arm64's
> __ptep_get_and_clear_anysz() and change its callsites accordingly.
>
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

