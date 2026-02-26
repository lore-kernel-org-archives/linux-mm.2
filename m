Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D001FD461F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 05:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B766B0089; Thu, 26 Feb 2026 00:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BBC6B008A; Thu, 26 Feb 2026 00:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C236B008C; Thu, 26 Feb 2026 00:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 626946B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:51:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C2B113BC92
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:51:44 +0000 (UTC)
X-FDA: 84485536128.16.8F4CF47
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 19402C0007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:51:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=REI3CRV0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772085102; a=rsa-sha256;
	cv=pass;
	b=l0Dyis+6TDmbtVRCJ3aByor36T6dJfE/hGohe9eGksjnJw3Tr8lKjAN5vOauylk662bRZf
	n5lqbYBEVp/zBP2E76RhJL9i5KAAutOiKthZym6FVuyb7gY6SSCM71OGrHf50fiP2Bqwzx
	9fH+VMCwmt8C3PH401Ma0CSPIvKxk/8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=REI3CRV0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772085102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8Q+KW2rDJPCWHs3PYeXAClDN6Adii2vmOozfmPLIaU=;
	b=UXVUx/4+SMqF4r9LVVWmoHiVMsqQOwKLyUQUyVFQLhRn75atIxyNQlV42/ucGMpohNN4QH
	yb9OMLCp4Gsi5ZPXWQvG8K7lYoBgwNau8JV488/gLYNiB1hTJZy1eB/xFSN0cyKUL4+TKm
	qIHHVKip7JdIXHrb5UCKE42NfYCADiM=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b9361c771e9so7899966b.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:51:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772085101; cv=none;
        d=google.com; s=arc-20240605;
        b=adOoL/SYuvHVADtD1VDEQj0wMHoD6Ye07EX9ni4Hglz9gr38S8EM5K9fg65LwcicVz
         zxnqf+iAMMo5CMWahMGf0FzVrr+kgtCXP5U116XJH2yBqhpw3gYg4rdDhZcWFY0FmSjm
         DrNZ/4n1IC1nxgFDBVe8y/ZwGxpzEqnpXML4urAuKKTkQ0nK+WSfDSWmTVdP1E6QY+ht
         X54D3HbAsOvBtD4NBWHwD7eSsQDEcJhc7dPZUPpJlYrwE/wQ29BirjOQIHLs5utYjWd1
         HP1qNM4J0Ww437R+xPG7ZPxZAj9k1ORaWIrA/g8sIbr90nhAB/nC3z9hw44ne2aqPTQT
         9cVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H8Q+KW2rDJPCWHs3PYeXAClDN6Adii2vmOozfmPLIaU=;
        fh=myt/CaMB0fcfjNAgK53m4R+mbWcjcDzXmcX+e5VV3LM=;
        b=hKxZCUJihbe4K9gv24VejhHb4T2Jrf9qQedx4nUrGogV8gOiK2asPiMG4m65jboYDW
         H8XYt9ubm+ZvHODZbV5zTeF1Cy2MQTJM0it/8r/PQGVdNCZl5Q8gLqV3czUQwcd5wK5B
         lgbzv9avxHC392FmQHbRmvvDmXFjoeCKS5BV32DMGqaRzhrE7JUIoY0cMkw47q1dN5yj
         E3QG7H0yps1aWwaw2Q8eTV8KgiVBnqs4mwbKFY0OcNWLSXmhhOfMBhLdIWSmrGde1aar
         0aK1QgmerbUHFGrHp0GcDx9u0lXZCMLJJVzpTpg2pjhqcVhKYwaFsFt80c4vYTPCkoPS
         mL4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772085101; x=1772689901; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H8Q+KW2rDJPCWHs3PYeXAClDN6Adii2vmOozfmPLIaU=;
        b=REI3CRV0oNDf5R3Ny45FgntPEOeAwQq0zszkz6KbOtiEv9MYpP2v3RGMgM/7dofnNN
         GJkRkONSjnExtzYEbKe3DW9m68fQtx3qkzogv+tkr637L3K3aaor8eYfRQsCMNF135AM
         1kZdhpyWCaUYE62QAOCdA2GOKrbwAXeePAF8sTBbG73SvUwfCJ9T7tbXO4QJSzy6P0Y8
         QYYcQN7BWCR60g4BwQW+yzo/TQuQlnLEdwyyyo+LfI28muwgSBEctczSNe/+IKAunN0W
         aIH5pj7CHKXYEoZD0eXfbWCjcOtmkK27Dh8G2AA/8qSm657pK4xqZGMMR5KFIz9xVQEn
         nY+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772085101; x=1772689901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H8Q+KW2rDJPCWHs3PYeXAClDN6Adii2vmOozfmPLIaU=;
        b=QYVLM3KBUdE4JvcwB27TnUQ2UVvrJowL2iolqlRpMOs9o94sSHSV98Uhapx1x3VlmC
         DJQPl1mdzGCk6udOv/KeQ5GNd+KkQSd2dE0OVHx/u99oza0RIkPmcjvQc528jS4rw31t
         79e0T/Qx3KLINSJGY7vDiA3IIXf3ovdx1jPJvnbbNL6m5dMnIqGF8b/3q3vXowwH1FI2
         cB7EKUbMe74UMvAellLBPFzyQy6kWlJdJGFUpjzFpfy7Val7g+DQp/XchHxatqGdplVi
         ZsRZ+LgsjuLEIbiiQm3w/dX0PJAf8ElhfrDmnYRxLlhVZ3qKBw4+uSarrsOZ3hvwXwEy
         FifA==
X-Forwarded-Encrypted: i=1; AJvYcCW85vkh6LxCVkTDxei1/vpJXTZkpwlVc6VN0YUFyfCDJTDbsR+HFtV63/EvJd3E1Q8iTNHxizqc8g==@kvack.org
X-Gm-Message-State: AOJu0YzAuXJdo2QUIDoyWIsC1nwf2UbelSz8B+xRxbj5acia80UxkD5x
	Kc3yuaS7W6xNDnKi7En1Cm/tLyz7XuSSjz6jSRex2zkN8AGrO3IoXiz4nLAPn3pgTGYwnIWe86m
	yWOfqKngqvvghRCrW3sLb30U0AYFItkg=
X-Gm-Gg: ATEYQzyi9GEgLj8egP27Eq8ORryvlyMgQPeY/pg7uBdFv1xeGQPoHvTRszL1IBXEvkO
	RYCkPV97/H3FEdSByjGF/sOA1qDIcAxHrj//aiw4hy3F1gUg6rqxshdm1+4+3Bho9ly8OUBQYUi
	3CwVEjBaLUijYbgaqRvoBEw8f3HigR628rwJBMdto7NE0Jw+HqSMO2RHoBpoE8ZozmpTNvyf8LZ
	WrcuoKSn+e4l8qFR/m8Cc+7ezIzH5upF4oWp2zOklBEHtMdvC772HD/ZXjNE3F8GtROBQbmVWM+
	/zgMHApi+OxNn0sgyqH/qv1fD0LrxM4AVMmdTYNs
X-Received: by 2002:a17:907:a0d:b0:b87:206a:a241 with SMTP id
 a640c23a62f3a-b935b4a04b1mr48924266b.11.1772085100329; Wed, 25 Feb 2026
 21:51:40 -0800 (PST)
MIME-Version: 1.0
References: <20260226010739.3773838-1-youngjun.park@lge.com>
In-Reply-To: <20260226010739.3773838-1-youngjun.park@lge.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 26 Feb 2026 13:51:04 +0800
X-Gm-Features: AaiRm51vObMcc3RqnWIp8bsa8pa8EMrLgbWXBvS7Inx13PdrgwwRWPVHsSXHj4Y
Message-ID: <CAMgjq7DT8CLYVpG4t=tg-xqm5A5YsTOV=YLnMjo2kdeJ2+g3JA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add myself as reviewer for SWAP
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qdgczay1kzgb7tozteczy8q9z5nha5kz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19402C0007
X-HE-Tag: 1772085101-897063
X-HE-Meta: U2FsdGVkX1/WPOF9hulK9L3T5dfcG77f/pu39eODdShcK6exyL8YoR5VBTnmd28ecTBe8NHmTCQd6HgVZQzgbBitAP4Npr3CIWWWLAEERZvapO2fahteAcv3AZPUESiOSEfNq1Hte1xNttxXHtOQxxHx7821PS/mIRE0h0/gb2xbzL0VzoGH0dSfB1KEvYYDCMlDtnDnCermfqJyeF7afJ3TWIC81UmrrekGidGa3He7PV8ddaKS2JEqWzIaLULGM8Q9x9voRfXvMbB/6EO9xtQ++cNB6nLxpmWmTyetJqSyrn1At69fyfQ6PtDNUYSICD/FgPO7Ec/0isVP8cZuPvaBBe1rz6ahWq47GWnPM/NDkfFQevQxb5mcpiIQBBVkdOBxtCAlhXuT55EQlyisT5ZCWlAA9U3yscJiw4x0RVkW8LEmUgM0TI459OVJ4471YDLsrY0gDvWHALmfW5v4B4qB7gx/Dtos9PAQbwuUe0qZEmV3/MYzPkeLWb+fZ0qbim1K/iLnQONmRn23lQY9RZN9RS28VYDZb8GItxb1ylOk8Kvghm3sqXyuFJ13lBLheZRqvmTu30Wg2NcInOo0Lg2MJ91wtUPDivBX466Xx6Mpbbt16s0cXShFncwiKK84VeJCfCqmbXoD1QsVQudkIIS8CZoQyZqRiwgIkRdI/cHMAI3cDXJWuvmddh79ePgC4OogP7Z4drGQMCaFHoAA4UDTZbaGdq0puLmvWHTS4Bbj6fw09rweJ5Us8d6KnBzDs2eOm+zOfQygfQMRxn+uoXJRkYWiMouPe8lusUrSbI/nYN4rN5S/efguqHBmJim1tOcGJJJTwnBLuzA5ShuthQexlag64pqvtldskLOKQ/lLTXLvIsacA/8KcBb2fMv4MqLPwPne0ltbfwW4LU/CMv6vMKaLIAcashDC+u1BG6w92MbqRuWBPLOXUb8AeHcVh75K4sUkVCl5qj7fdhg
 l2XvCMqs
 ot6y0IS+ZjszkCjda9Sa5OY8TIDXQ3aPrBg4zwJ7/hrg373WeVQ8UWmkWfqZTjqWiOhCkkPetaf2juSRpM3tlOnQO8/zHUhI46woBAFc9QQ7W+PSv73J/uZ2KBs+7BFeujSg8q47YdYYegwQmuUwVpxlSFh71SUeYM4K04WbmUCHVAaoDRUOM+BXFm5wSaRJIUEjJ5MKL8bM8NnTgdWodfETJGPZZe4AuGJmowHNv3s+aLw5aBuIPEggaAn7JeGGKMyXD1x6Zwb/tFZ803pLHdNG+bw/rKDyQC8n1VjMlqEq5APmBHAyGfW4qBVIOe+UjHQc/6X7SIZdSkWMEP37NqXyplsdqT0v/4A/ENxHTSv8S8796kyMebLMJI1G4o/2QgVUUANeRuG7u8lTFVxhSjjQLGZYElDtyiavshxAKminpAR3C7W16I99EE8DrMS6qXYQ8bB3hwe6ZmtZO6W4AEV45QgfRzlVx+EMXk9pN1uX0ZpZl1hmrXbBIZ/JJz2jf9wTpcY6Qxt+ndHKm1u2e8OX0c65jjuKEOzevaS/5i+YlTdvF4s5sFE9+wKBpH7nEXvcvIxADZELpLtLFp+JNWuRsBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 9:09=E2=80=AFAM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> Recently, I have been actively contributing to the swap subsystem through
> works such as swap-tier patches and flash friendly swap proposal. During =
this
> process, I have consistently reviewed swap table code, some other patches=
 and fixed several
> bugs.
>
> As I am already CC'd on many patches and maintaining active interest in
> ongoing developments, I would like to officially add myself as a reviewer=
.
> I am committed to contributing to the kernel community with greater
> responsibility.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e4572a36afd2..8fb7b70dfb47 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16913,6 +16913,7 @@ R:      Kemeng Shi <shikemeng@huaweicloud.com>
>  R:     Nhat Pham <nphamcs@gmail.com>
>  R:     Baoquan He <bhe@redhat.com>
>  R:     Barry Song <baohua@kernel.org>
> +R:     Youngjun Park <youngjun.park@lge.com>
>  L:     linux-mm@kvack.org
>  S:     Maintained
>  F:     Documentation/mm/swap-table.rst
> --
> 2.34.1

Youngjun has been very helpful on reviewing recent swap patches and
changes, and contributed a lot with fixes and ideas like tiering and
other proposals. I'm glad to have Youngjun help watching the swap
code!

Acked-by: Kairui Song <kasong@tencent.com>

