Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D36C982F0
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD376B009F; Mon, 21 Sep 2026 15:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985716B00A0; Mon, 21 Sep 2026 15:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2486B00A1; Mon, 21 Sep 2026 15:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 677E26B009F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:59:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE4A91C2096
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:58 +0000 (UTC)
X-FDA: 85238835276.15.9844A02
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3E1DB1A0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DYkDwyFx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020797;
	b=bC4e9DarwJdriepZLXzQpYzF76sNIbzmCLGK+ZeFprHhzuaBKHfG+lSVHR6MK06s9uPNPY
	VQjHOKC+HHqggiybX9T80YSzBNLVxwyodTepxe2UcX+9HB/ci1GF0HCxYMvzJiTdCndg4Y
	b60QgsQrttcvHNm18mIl6T/nN1Z6wy8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DYkDwyFx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEg+imKpv2AywlAvn/f88uirl1wkSJAtwjFAVjacduQ=;
	b=CwZscBfvt4oxlUNY4UATDg0Sw3HSNEM9uPmD/Dp94RSK6mKk4ZImpRUMDXijlFDhoGfkSE
	DSeCFu1xX+FvWPZe19Evi1WfE2BDavgIzah51SfYyIgxu+l2jfq0i2JYfLuade6byYRfnv
	MvZCVzW9TlMruRaHtQrXrtMyqGyqgk0=
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469d20963so2214279b3a.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790020796; x=1790625596; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oEg+imKpv2AywlAvn/f88uirl1wkSJAtwjFAVjacduQ=;
        b=DYkDwyFxwV0sAoUF+JsKiwPhSSOowYoOont4//+AHbKf37ouqrcd0tu777tNts9Cns
         gkmojnxQWP4qRW4kw8adcqkZTkFvSzeZcrvNdq1JsmjTskgslm1W887HC/KbYadRWZQY
         2WbywEdeh7Y3F0QrGd8peSRvkT+jrs5ZEiOvWAw5umBTmcJAmP+nrW6ch2rQJnSj8mbr
         SpbjlBMIWBJvNcfLO/6RmVCyxmbrvELTiZZphBWLBzuXhE1w7ogCu5QdWoX+lOs16R3h
         5pmORYNZkHIfW9UQ323bzbYWaA6v+eH/ts6mkGUxFX+5m0wDl4MPCXGvw8sOyDq3iku9
         4phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790020796; x=1790625596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oEg+imKpv2AywlAvn/f88uirl1wkSJAtwjFAVjacduQ=;
        b=yMMAi4/WeGLnEDUIPeiIpI3A+g6mCTY3SuS0OxHDBLGp8xX1NMhyVSmBu/TDyhIlcD
         7XjPsQR/ioTyN2UkcVrQyRL7BsNHzjzH0pz+97xcjXVBJwCaGO7aFlsvR2pLn0+HFPri
         eM4KrovDUaOzJkYhc6uY9yY0U5PPWrYm0MQHv6q+n2dUmznX+Ilt4fb5fAK5NVgV9OcD
         W8uGCvNADEYvyGXVq/BYfwYlIJQpLzen8qmehNsoJyohzaAvIOmdbZjEFFhII6lIZvt/
         QyLKvFm96JJKLpaIuAE7vfGEQhjwoUGXe3dRrAtdCyS9pbiEYZD9aFeVP3ENgc2hJ2+O
         PGrA==
X-Forwarded-Encrypted: i=1; AKwUvBx5tnbP064XPccLzB+zuASvuSwwuUWI9FIFw+aImg/u3sKSVSKp22wE4YR2/Yp5gosVIuAmplcyBw==@kvack.org
X-Gm-Message-State: AFuF++kFdwlmZRtOuBF60dXvV+lassLdVG3ieUvGzpNIK7aN0w7AJtob
	uDFWRPsTrZ22vc8710LAop/I+zlZF1TvfNxwMmPjqPnPaFL2u47H3PtX
X-Gm-Gg: AYBFou2uYJoNCYEc5kTRJgv8V2vaRzJhC3fTl5o5zwc4UgLwBB5xDMDUb1NQHzyxVhO
	a2SeJwf0BFqj9hrh0wXmbKxQX8LbvIpSllMtRcniB+kT4A1bb6EhYAnbrLijSKNxGR0Zv7Pb0ok
	AzH607I+DrfR4afZsbN/z2L58A+2vlpc4RJqtNnyme4cjI73VT9bDQnBlOGfIgR/eTOQZlS6WEy
	/U+k+SZJPBujUTfq2C2gW7SYWyugAkW6SR5uDfmb9XdEnRef6pBkiJWanxlJL3jG/u4rYV88iIm
	HP2m/hXpLTc232oGUu9QBI+rvO5uJ7Wfd19u5iU3YJYnyqPpLE9jA013CVGkcj0CLXFP76mOaVK
	th4rC0rcToe69pYMPTt19PuUC27kpdt7TsB19cbghxjgkyRyDCo7cpURGKr6ETNgWKoJfL0TT+Z
	Rk6icyEg88YRXaSAHH9l0l/3grj6IarQBztwe2t+awiVLPIQBxoyMb8UVwOJoySKnXqhkYE6Mew
	5kj9M2HsyU96pRCq4DM07Aoryn9oLKBEv7KiJEDReo5WMeEVaUrxDtAzdfkl5a/7z2C5vleji0m
	N4Tf7uFwA/YiWsIrPawuJ+GedA==
X-Received: by 2002:a05:6a00:2e26:b0:847:99bb:b6d0 with SMTP id d2e1a72fcca58-874dcbf2693mr16386785b3a.15.1790020795965;
        Mon, 21 Sep 2026 12:59:55 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-198-121.dynamic-ip.hinet.net. [36.232.198.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87bf7aa8635sm18010b3a.25.2026.09.21.12.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 12:59:55 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/memory: reuse the whole exclusive large folio on a write fault
Date: Tue, 22 Sep 2026 03:59:49 +0800
Message-ID: <20260921195950.629-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <arEkcIb7JQFd4zzI@gremlin>
References: <arEkcIb7JQFd4zzI@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3E1DB1A0006
X-Stat-Signature: tbko3aoj879fpaq5xaou6um7cidgy8jt
X-HE-Tag: 1790020797-50973
X-HE-Meta: U2FsdGVkX1+YL9C/dsTZUNu9Cg1ft1jgbG8TstFoUa0oir1/F8vTQAoThq2hQyAvT03vKlORw+nPTmrxv+qDB0MsyqqQWbKqB6pxkaC9tTo/ENkb9YR3nIrAdlmHKn8G4iRHowix1AOMQan1SCHIc+dlWwJsY10njl8zaRk9Ktqp+jzrxO2EQ1l9DfVWOsQ7xFPug0YzqahQbWqsXWg2G5eMpYoxQofRkHAJ8G+eKT8nkFHBznrIR3ruZqieATk5Kq6Qe25+1YCSOqWxw82RdbscnuoYYho4exIgIeeQauNuJM34A2oZm6/Idki3I6OZRq6PA7MXxKfJyojiMqXYyZybaNJ6AqMa9l/giRX040JVN8x8GBFwYnStMhChFfsHiR8/dmu+thohfoJC6Adj+iCXHI4+wKjoqQyI98TLNlzMObqloP1MZfSGMKuihWzuuJBnWh/lK07lPxRIXnkCjW9mU2Z6/y2/tBj+A20EWQ5GhaTAxkcBLRhgr2ZgO+GE85THnt0Hh6RMhvY7jALfHk3NGm9cLZLhNNltBcFWMai8lRleOxafYkaRaaCZEIPFtnY0wREJTddChUq2oH+QPkQQk/FCX0qqegx5Zid08qCEsXqsWEiS3/isHQgDY8zwQ/xQ8Y/fbYPY+COmBZWvl5GGwAADHBeCF2sZv9OB9exSc/QQVWgfcDULT3OnjMthe2tV4TBaMd47YibbF6Wyz33mYIfz19PnsnnTwdt1YqjI6JaCrJw2N3eNMwVJwbBzdt//IPrREAklW/Ez/2uFC3uuhWF3q6Chhk+U9Jo5ccfbbnoyw70T83Xi3DR3BGqtd9ThAkHOwpslCqrsINYqqkBdfPnyjy8n76K21xQMCeRsSKzxwTfAViV9J4OKGFzZHcjScS6f9RpaIqrA8Q6zqYaMUKT8dvzlbeXaFzH8JcBRrqCeiBsZ2FsSc6XMaLanOmesFLPUrZ74VjOQ8Of
 H9h1rWCJ
 ynmT5eQYtTQFy5V9CKKX1B7e1JbzRRGTX3vDP1+4Juh3CEzsMgMoov4sKYkiXe7fkWq+ZVrjylAnG3P+t5y+OAmIG03NnqctPVD42KPuW6UycsxWezJheKvvJVwyI7Jlq7GoozjbKYvyFHnA+TVIB3hBqw+RSQq/iCo8pRk2Il3zsZ2cqmremRbiOm32hFdaY3/Bnh+Tetaz74KdGjyw/STKy9zu9TzA6vTvmCH7WuRgskMQu53mAN6JxoXVMcrx5756FcG5gQwJR5ScZ9buJx6L9xca0P9D4aJKbpBv4To63MdnHcIfr32fI0ZZWznGIrd3zpho3NDzfCR2O7EFy9+r3pclaF40Rk0khv01FGwb70iv7EMQ/XyfJZIv1WUhJnc2xCpo/ihCyrBqqxvU3YQaWC6cckvfzcVKGAR1JQgYkeFlOySt65pzreQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 13:36:20 +0100, Lorenzo Stoakes (ARM) wrote:
> Also, and I am struggling to believe I'm having to say this, don't
> completely ignore feedback you've already received which told you about
> multiple process fails?
>
> https://lore.kernel.org/all/aq1CjdaPUg_Fos0t@gremlin/

I'm sorry.  I'll go back and read the process documentation properly
from the start before I send anything else.  Really sorry for the
trouble.

