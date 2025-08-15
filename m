Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5C7CA0EE0
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 04:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7180390020C; Fri, 15 Aug 2025 00:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9198E0002; Fri, 15 Aug 2025 00:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FBB90020C; Fri, 15 Aug 2025 00:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 398E08E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 00:43:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AEDD5BBB32
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:43:04 +0000 (UTC)
X-FDA: 83777747088.09.B5F236C
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id C60D2100007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:43:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ISMAWoVQ;
	spf=pass (imf14.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755232982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3R7e/mODk8uXckZ5NZ5/I3y0JpUqVHIYps8pPNWoCs=;
	b=JKY1KhXGSsPYU/r0d0a8jW3X0rqeFPHsX1Iop0yRdsiZGxeT3njpDfrsXUYUIN+lJ4rINq
	i2XRk+L9zEBHq5yWve5ofa7ejkuN7+6hlFIiEh+qx+V/UHf0TUKVZCp8gDg0kQLgv+k54/
	tQTW6ZGMHQB1sQl4/GJdvnjy5iMLxjE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ISMAWoVQ;
	spf=pass (imf14.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755232982; a=rsa-sha256;
	cv=none;
	b=NIPwmF5cnHkj01sigCU1UIvh3hISlCtPjm+h9a8iRGLH1YfVIQ9ou6ilKdukP04mYQgr8b
	EBVyhBYUTQqGz4pn9tL9JnvsL6OJnPuhk9XPpfyw+EEyY7U+tvdh6rV6aVFDl+QMZunqKo
	5WfNaj5X+RWE7lGasLkUjnr15idjSKs=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45a1b066b5eso7698915e9.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755232981; x=1755837781; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3R7e/mODk8uXckZ5NZ5/I3y0JpUqVHIYps8pPNWoCs=;
        b=ISMAWoVQwIZiZ5IvXshFVIYJIuP3FtG4I000MvhSfmw5DUo+gB14FLmBa6J3VOV9lZ
         HV6aiKvpPIG17mOJo2F8wBMuq8//xhgUF3WK3wEB95ImdOadqnNpiw+eMmrVnibypEXG
         esrEwcSmluxA22ppOx6miA6b/Loln9G6IHknGK+Z4Vs7bRBWBc85gdF8oCbbsyCQNs4R
         0oq6SnJem6If5IDosh5r/aqDqLP0GR+u9aXQ1FGq9mvtgsRiA5vW9G/eFrEqFNP+Airu
         6g5VIzfKFpnlbO01cBpkw03+jDn7VGcW7IB9SPWa4NNo07Pg3j6yIGI3yXq4o8rwtwx3
         fRPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755232981; x=1755837781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j3R7e/mODk8uXckZ5NZ5/I3y0JpUqVHIYps8pPNWoCs=;
        b=r48gM2QI8FRjQAHKgsr9cAGpWONw4Beu/I6/zvizXHu179qnF57GQGAZaY4NVoxDDh
         3Q3GpR162v6pijUvZvEcQhS2Z/zKe+NTOe+/Zr+8AvJaO+qRJtwWis0RyVGjJy/3KOPY
         aE5pFvLdgPSQ9u4NpKBteR/Dd8Btd5vn37WPAYZht1F4n3btjijGD51zK0pG5NA3aW/Z
         Yj9FaEhUgRBnMUkYLB7VmDFoe3AnvZDWRALrj04v4nQ/ixilphoMJ0ZxBmxZH+wdRn91
         y2UV/nOHWvYtM55PvM5DsT3incqfO/JjElrihNCPNB+UXtBt4edL/8B8uXkm60yRkpmt
         /Zpg==
X-Forwarded-Encrypted: i=1; AJvYcCWywVf3ooSKSLmg9DqUr6FTM/U0aAvsJ+4xaG/KUivLnpPdHQBJsIF4qgAz4P9YLt/NYLZJTtZbKw==@kvack.org
X-Gm-Message-State: AOJu0Yx91IFDUnhdKMlhwAbPutvHcB084MW+XoRmhZN7KWJEdtqm48+U
	lL4O41fpx340mVBs5K1xjaY0zrXY6iCZeIB8v9vDIwmR/QtCRXFiOSsaIvAuLeudZjl1GVw4tA3
	xBEKCx+43/pPlAr5mZIy9VgCKwEWvRjk=
X-Gm-Gg: ASbGnctecxQ7FBCkPONupASN7+3p46dEzWe2/weqDu3/rPhelW+sC6itggvG6HLEO0A
	DtERnVsNnLL0jMIxd+BGJGEvcR7RTrDDIqKDaJXi++PrwrZlzQjFQznLWOivp7IIvqUrmfCMSao
	QaQCnBuhdzKGjxNtZDe7vl0CMOTwSY21mM3SeuykAjiFa8o+0tGNIWyJ5KOsiAYQJ+k2uogsgqF
	u8o+yK9
X-Google-Smtp-Source: AGHT+IHUEFiZR9LZSygwnTYlHEBGpTIo0u+l0gJJ74GZGqWA8Urxqb7v7zb3aW8D4/IFFp3XGkfgVY5+R22siTJ+vZw=
X-Received: by 2002:a05:6000:4022:b0:3b7:899c:e87c with SMTP id
 ffacd0b85a97d-3bb6636cd4dmr361412f8f.2.1755232980929; Thu, 14 Aug 2025
 21:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250729-kasan-tsbrcu-noquarantine-test-v2-1-d16bd99309c9@google.com>
 <CA+fCnZeuewqXSW0ZKCMkL-Cv-0vV6HthJ_sbUFR9ZDU6PmzT-g@mail.gmail.com> <CAG48ez0OnAPbnm73a+22mpBjvGHKFGqYAA8z+XocZEHXJCcQiQ@mail.gmail.com>
In-Reply-To: <CAG48ez0OnAPbnm73a+22mpBjvGHKFGqYAA8z+XocZEHXJCcQiQ@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 15 Aug 2025 06:42:50 +0200
X-Gm-Features: Ac12FXzBCNI4JKiPn_2WUKTuherdT8IB-yvUU_GUQLdNyBF0zRHg-bm_iV4Kkkc
Message-ID: <CA+fCnZcYBCfPA5ObUEWq9iJnXFMw95GKHFZaaZPr84GUtbVNnw@mail.gmail.com>
Subject: Re: [PATCH v2] kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
To: Jann Horn <jannh@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x48ig9bw6d8nrxfej3pj8hfndcsxogbb
X-Rspam-User: 
X-Rspamd-Queue-Id: C60D2100007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755232982-795734
X-HE-Meta: U2FsdGVkX1/5/hxl5DRInaBsyIR85pcWc2qAY508X5EulCYxdi+JYSdCbxCAq7PljO6ruy1NS4D/6KxbJHCe1j/UK5VObkOW1jh3CBBM0AhcEnaUt+mTxRcOreaeS82Oei9Y5kXyc8aWOP9LzlM95pWD9LA67cBHZLuD+KXY8o8yFZaq9kbmCPczeB65ofstnwTo66ARqtKxhSEE6q5ZMXViw7CYpbQbuT47rppK03T2lSNGCbvZZSX1hSn+PjlDgCnxBljTm2Y8oFXlN9tadQ801a4KWe8wjuNmlZpp559KtAb9CFa9Vh72pMSBBs07tHWEouuoORNf4DIM3GCwf+Q68Xv5Y2csMA19nfdVMGj03/8M/+p95yop97i/dJLPDCpW7llikWtHZ6b6QWVpBCjbDrPnQyi/lFgxjn1y9IWLXpQwYDutNXpE5uxzWJRuOr+tl1NU47MyLm4j7HDUJL5zGFYhrwin2MHn1P1v0Hqlz9Cpy7TEk10mg4a+vZEkeWovXxuGcl2pi8B88uuQpHKvTE99Nwg2bcpiHMXCzSrLz6c8gjDymS/LS8JbA1ItjUAyQ4BEQ6ASGJf0CxlLrTyPZrqhKBg7tqRCjD7+lVT0zPae50q+pGYmdhiFfWjspvDH0mgOGW9yNSH1W2e5qg+Q1rreEsRBfr4vc9j3oHySTBScn3PdSlQfNWe/LwxmmRxdoiWT/hTwH/8ghWOGybSOq5YZqP0aAsgUPx+KBcaPqrLPdlRq0Led3XXZ1KKijrzuw0hE2CYqJ4zgyvJ7Fz9VYh0WmRW8EKCPQQTzpzS4K4tFHJbkgOJeuAdXtuYn6fvGQnX/AIEequjciCB4AT/hZHWUxpVKcewNyBrs4eaIvfhG8k4kItu+joUQph+rH/OguM55Y2cBDp/xUeDF0PcIL5v3VEe7KcD2puXjvZa8DyKao5+y0sVPdMyQYPzDkRGejfjCakaJmGa08dR
 YgRU7GPx
 ztcLLOvg/9YPlBxZU9NwE1H5HVYAUWUxHdTmhtZLzXDGtDDFhLtEwsJWyAINmR+ItOJS6pzhkmLFuSHt0YsyrfaLhEMGMmzKrvJDu46xINnUxQH2vPssG/u70bRSD0nssPvkZID3/mA5c99VSdEbgGPAhGthWhdGucAoR/4s93KpV1iGT0djAznA3mAfRRy7RM6SZLsKeok8xHs+Aq44s/+iofY4nWbLlWky5t/83XOT22MJRKfwVhPy8SNV40pWXphDmxixmYKb3f9gap/c69mn14O878ywGln8+av4BPzJrNuxPX3EHtb2QNOG3PkGjISZ/5BavGgn0/nTocSLOo7smbyccMcDFrX+kJlOi1u0R1ru4QLG8QmhnUD6y1boWk2dBD6Nw+nRxWT5aN7FAG97pRcSiT/NEN00FvmYTJhkAt5PzV7DbqsAs8ry53tYLagir/F5NFCSJG37Ms8kzlRDMkDeMSUXsSNiAgPGUU/TRV4b7/xcwenr9zA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 5:05=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> > I think this might fail for the HW_TAGS mode? The location will be
> > reused, but the tag will be different.
>
> No, it's a SLAB_TYPESAFE_BY_RCU cache, so the tag can't really be
> different. poison_slab_object() will bail out, and assign_tag() will
> reuse the already-assigned tag.

Ah, right!

