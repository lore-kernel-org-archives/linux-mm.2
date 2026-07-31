Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D5F2C55172
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0416B008C; Fri, 31 Jul 2026 17:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859786B0093; Fri, 31 Jul 2026 17:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721D66B0095; Fri, 31 Jul 2026 17:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6146B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:17:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42CDB120152
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:16:58 +0000 (UTC)
X-FDA: 85050331716.21.E09F945
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5DEC2180008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:16:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OBci7GZj;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785532616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dw5FzSdsS3SFIk5ZAsXddT96TfLTVBS7y/48MbCBqSI=;
	b=Hun4cF+xaYlXOjiTc5tSvoAv9i940vR5OGdibmd30el8jBlZL5qm9R3u4e7yTTdweeRveQ
	0k+wVPRyDrejuv827Inn9tdcimeYpMuHySyHRt2Pu8L9cW6ksvuXLqnn13QR8Nt71XNszI
	cgCbuVRRYTBckTEgup4nRNrRHjDTgRA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785532616;
	b=0Kg1WWcjNBY/mc/Xo6fdOtynW89gmkk3UIRck/CgTym6EJacwO1I1p0y+OxqyiFKFHvN7w
	IR6Rk8D0MEvptgElL5NyiyDruiUpwJkkJGHq+v2vDA45X07+wCOg0TGKYvbv648V3XqHFL
	LKCeAFuVCeGMihhVr/BvHQ22G/eXlZQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OBci7GZj;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE87B40718
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F761F00AC4
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785532614;
	bh=Dw5FzSdsS3SFIk5ZAsXddT96TfLTVBS7y/48MbCBqSI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OBci7GZjQ4qo/g5GfasBcwcLRAlvVfSHWoEo4ArECycugPeL7/WkIcRlvXhMSzqvT
	 PH24oKxVK1ZVeV1OdKrlb1PTN8rOwG/2/YQ68sZxsPQwRE3S8q9t4KxyYuXUd8oSHL
	 19f4evFn4yXsd1zqjxZTBsSpRYQ86cp9oCz469/IFsUntmeY1GpsfMzzDyxvH/1qN1
	 jcQXeMxxIAlASgCXXrSRk3eGBZNN2Tlg7F8PJgN9idxJeKk1BCG7fxAXnFZvYEnX5e
	 rwNkyJKJqUTkJAtvGsDwxhsUL9iImQUXdZmiLNcxAuBpZbwR3wNIxtGiKJiEaFOlMv
	 3vLZo9tapY+xw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c167bda216fso213980266b.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:16:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqg1kAlkdvjP0jaywEgVkoJkDuX5AzuzThSE+UMzVb3ExPjeW0VXj04TmyF28MPMDrzuZlItUGCgw==@kvack.org
X-Gm-Message-State: AOJu0YxIR4P+5SIqP2WMTZkG13Ml7LHdKsNGqu/vO/kVqyUMzeQTTHyn
	vYKv1TsRkHfrCRPhNJBeXwd9CAl3G6YPGuA3F2ZhTA+6KbQwiDcMlc9WSuvzQ5/pPo/m75m48hR
	tRHeEpUWcLQ5hGLR4cTLwgvCexBlZig8=
X-Received: by 2002:a17:907:9958:b0:c16:5855:659b with SMTP id
 a640c23a62f3a-c1fe83e0a88mr45299466b.57.1785532613644; Fri, 31 Jul 2026
 14:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260731053721.1412304-1-wfelipe@google.com>
In-Reply-To: <20260731053721.1412304-1-wfelipe@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 31 Jul 2026 14:16:41 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOdBoWuKCNmaVDB2ZtLJNwPR9O_oSsWr8qn3DML5bMRTA@mail.gmail.com>
X-Gm-Features: AUfX_mz-3y4gAMEch7woC294LkcQlav6zpSlPM0UAWQABZEqm_LYBuihMgAnmtw
Message-ID: <CAO9r8zOdBoWuKCNmaVDB2ZtLJNwPR9O_oSsWr8qn3DML5bMRTA@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: drop list_lru param from zswap_lru_add() and _del()
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5DEC2180008
X-Stat-Signature: mpxj138c7n9wbkcin3m1qbcxg836j9bw
X-HE-Tag: 1785532616-187560
X-HE-Meta: U2FsdGVkX1+PlXxnkN0XSxyTcpUjuiHGCF+nne5vhZDMdY+lHDVj+u2Nf9s9gEcEG8n61e3kJiYxc4CPaV4e9pnInHI7AKM6SOFepurszH0STQ6j8l9Yh7oPOx5Jm/KNmHI92uus0LHoa9xZBd796qEV5w8Xjg9qKAOwlPSjdpofulCZARD0yHOkPKDS9C5dfBo/cRqSuIcB9beHzooEnVu13ANz5NH8Pi78QMiSDIoSV+u0iS1IkURbr8+GKJYXRD0cG0SuNVpnW45u5AH2y0UPAY6p0zGu3Rh8Q3AviP0ciWK+1Kt3YNDjMpYtzhUZGiMJeHG8DvqKXRAafDoJgg+S7KS6+Ft6EHbeXMQ7NJTXNBb7di8Xi08xQrZypIUtkUKhpi7AN2SdMnw7XVQkz0Np6YO8ZNiXnGHUXIH13++oMVWcgox1VTk12VbXcNbgbj8NOcBW0hN20z86oWYT104DTTFITJdJKT+MDWNglh4mDbp9t8+4+DeoOFDnnOPdBQ7mnootrAd6E0XskxonijDQ3OO8a1TXBKBraTyJQaox8m1NtnOgyJm8e4lJhhhT6mWk2kFDLPj/wLOpVwDn5Eb/7eHtSag0+gCS8Dm6GIwRT5mdXyujN38fDG2Dz0aD++lx7qiAw4IJ5oN5GLef07tf328yL6usqTlPsqe9olmNeRYe/ef8g0BlH9edRZc7g6eJlL1uxFOIlJSKXjfn2PlOytVK1AcCw5lmjkvY779MJGI3JUOBK+xsaf78yaCzKaW/Y1AAn3OdrWaVjL6NaVHoxBde/8uG2jl8YVm9CPcUCfls+rwMIeUeHpZ3gIOTLsVrFyg4mE7J+PIMXnBoaa7U1NaVnCvgJ5ZjGnW7ZD3kCSJ4cxLuf1uluEf7xshNhYTHTNrCMsK7a1h7jtlOKxoRAQFSlwJ/ZTz/6HNucp6GO6QKUZNjh8uv6/z9BN7ijHkSRxCfcCnYDo5zkUH
 w/wKwDMx
 T6aYMPcoTZgwBjrpAii1whHH/jEW/tLIzypT9Z0GEpEDEg+Llj8NiO4PQU77B0ujsIOErPUKmyWKJYKqEKmdatl9/AFpbTKs7RJapnOfyvvEjqFrsgOfHYb4I0013tMkp1CgHvJVvLTIp7q+bqNLM87nICw0Bw0MPV7XEubUpGHMjZAIcY0Ff/RNWNfT2E6govTxpwVur5G3rp27tH+FKaHdZ97Y5iIwSn4yc9LnPEWoduXLjW1dqpGHzLIQ7x9qbJnKdZC43awe2CaGvWhonNmMGltOIL8ixXWoVCND9kBNoC283didUiyBRIes2ecKspHxVPIgwx3/qTi55v5A1Y+NjjDB5LsC6pfJrbYDDW9Apbz42W7ik+EcG8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:37=E2=80=AFPM Wilson Felipe Pereira
<wfelipe@google.com> wrote:
>
> Since zswap_lru_add() and zswap_lru_del() are only called with the global
> zswap_list_lru, remove the redundant list_lru argument and use
> zswap_list_lru directly.
>
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

