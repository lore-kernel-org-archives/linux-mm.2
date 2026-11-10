Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A297B60A2604
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=F4DEP+73
Received: by kanga.kvack.org (Postfix)
	id C0FFB6B00EF; Tue, 10 Nov 2026 11:00:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1136B05B1; Tue, 10 Nov 2026 11:00:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF336B05BA; Tue, 10 Nov 2026 11:00:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 835636B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:00:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1AE3CA0953
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:00:10 +0000 (UTC)
X-FDA: 85419670980.28.E9DA89F
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id B43C3140006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:00:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=F4DEP+73;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326408;
	b=3R4giCw6CyVY5KAgt6mf12MZhiyOO6QQyLAEICkRPWl8nD4m84O+1ssFE+Kfaq365GlPA8
	rdJZ60fSEn2IdFwaJP94Vwawr8J33VE/UMs1PjGqRTivxuLSJFpUdBXYiUomtn56UJ4P9I
	/tGRiuTErK4c2mbQ/9HE32MTXvZEM2k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoTpJiTFsgbbX5VQxcP/im2cD0EvpkANc1CUM3UG8ys=;
	b=yMCaMf4KrG4DZ6xe+HNMsWOV5PMx3DJB4ztK2ry9DvGzRBsKFto1e9aTaKzCLaEBcsYxFs
	RKPs2uVsHXZKaht3XJ7JV7DWlsnuArcXYjSECO/yejjBXKQ1StUrcQ3TNBOWZZ0KO94CRD
	AEAT4R2ESENI9uzzksPSO4lRVM5fo18=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=F4DEP+73;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c5059958d61so104590366b.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794326406; x=1794931206; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yoTpJiTFsgbbX5VQxcP/im2cD0EvpkANc1CUM3UG8ys=;
        b=F4DEP+73zkXT5AipMErwvRst0Byi1i06o+3taxEaWGhUV8AxMhEizthjjIAjp91zvI
         X+gDglFCZhrJNfK8OQDAy7xbhvKVMWjMPyxaHau5feppgZ8HThbhkDGzPj4gNPxwhxFQ
         EoMxphLdeUN/KusJs4N1SwIG3jFCxDiCZUHIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794326406; x=1794931206;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yoTpJiTFsgbbX5VQxcP/im2cD0EvpkANc1CUM3UG8ys=;
        b=LYWKlz0xWw3hI7+UjcI+aFYPzprEKGGa9+7qVKge4UR7JHKRuwSihEAq8I6BSpdn4l
         ImSoK3DZUzh8btKI65z+kVHfYRV1L0oNaSzhAu6d+Oq40aHcFy5avYaNNHk2GWxef9+v
         mX6JUDgdjAQlw1KiRLAYiEbtDBbafJuWEwWATen9qXKSDjHcDI2BWOWuY7bC6VXv7fKu
         QE9oaMjWHkzI/x1jgQ7zyCG8WUaUmtS/tPSl70brknIeBSa5YczxoQDQqzbSoXxHkUGZ
         VDpyS0+dRF/PM8QcSQKIa4kaRAz87OlcxztjTqjWn5vjS9k/O1ISde776ksYMqNhewGx
         F73w==
X-Forwarded-Encrypted: i=1; AL+hErEnjKeDc2c9WbEXOEICbjnJiAv3ODv1xPjENOtMh1b0rmVvQM7pUv9lVrTVA23g96Jwb1fQ5DIczQ==@kvack.org
X-Gm-Message-State: APuU4Z8Io7GKxdLIKLtlvxR9D0U3vdg4wz5Pu/y302ye9cOA4f+5NcXD
	PgTD/Qeh2HC0MpOhveWaIt5GDuugaycr7D1Vq33ZKziivhnSRb0RTEJ8ZVGr6Msud4GpTJZ78bc
	uqgH3pZP/bA==
X-Gm-Gg: AYBFou32F3jrAb5e907hXmZSei5enY4/e/f1lPJjoZ4ZA2IXqJ1hgRSDvVpdV/ryUzG
	3CyBgzC8maSt/p2G5m+VP1kY2ywbD7wiWehCmzwW5DM9zSLa4p+YrIwdJM+YmM1Xt08+CYXBxU6
	lMjUDXUvGLe6ttv3dy3m7avhi9OmuKjaoNDmXXdBhG4zGainr636dJZtzWs4pH1MjfxFhOmNFYG
	H65FjaU+L/cZ/Qnto5CnXbhgSlMOCHjQkRAkZTuIr+g6Iftgoc0iqTBGVm5bkrB0cR9xanZQXp2
	fVG48RfaqRlr61wKLC//udEoS8e+WaNsFtnWYKmwWpzcef9CevJUIwGR6zg9lMsmznv5y/Qje1J
	xOydKNLXrGMron8ngKT3PScluiwGCxRhkzOhBD9TYix19ZttBcSvtXQBfy+YLuAb855zbZlBgjM
	mri/4HG99wG9y0TuNYeaNgsuOR80uz2mS3yzVOZH9piqx3WkSyCUlVCpqWOHMHP7y46p+LfiDnv
	pU8zwSTj098X/gKl4yWgCWrMDUtjmFejrVaCrqkSeQLM+zj6TBoXQvzKfllqaTlNdkEJGaLE2TN
	sTfXvazNOtyiZpxHkPui5YJ+KzeVvrfqfNlv9yPlDnsYTgbkppc8yMb6EPjEwGeFOsK+qKgO+OQ
	GhB+dsu5u4MhlCQsXeseq6fH6
X-Received: by 2002:a17:906:9c93:b0:c42:6632:a369 with SMTP id a640c23a62f3a-c506337d6f8mr1460266b.21.1794326405806;
        Tue, 10 Nov 2026 08:00:05 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a3a621csm125891066b.12.2026.11.10.08.00.04
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 08:00:05 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b7245ab5e2so3212977a12.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:00:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErG77ts8X5coQNsFwAiCsL6cqsNXvmmOKu9mg08VdxXpAGww7dEWqLzyAXCjHae4gKUTDvpXSpgi+A==@kvack.org
X-Received: by 2002:a17:907:1b16:b0:c49:b6db:1 with SMTP id
 a640c23a62f3a-c50633ba346mr907966b.12.1794326403910; Tue, 10 Nov 2026
 08:00:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110145241.536019-1-kas@kernel.org>
In-Reply-To: <20261110145241.536019-1-kas@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Nov 2026 07:59:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgPq1g-kt_n4-crr0qs3rBNkat5OgLxLLeMjKirevRuSA@mail.gmail.com>
X-Gm-Features: AclHuK-OUBoi1ZcEDjO00AEWOGxItrkKuC6wgZXx5y_lLM7MJshUB6roN-XGzXI
Message-ID: <CAHk-=wgPq1g-kt_n4-crr0qs3rBNkat5OgLxLLeMjKirevRuSA@mail.gmail.com>
Subject: Re: [PATCH 0/4] splice: remove pipe buffer stealing
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amit Shah <amit@kernel.org>, Jan Kara <jack@suse.cz>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Bernd Schubert <bschubert@ddn.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B43C3140006
X-Rspamd-Server: rspam12
X-Stat-Signature: e1ypmufj1x4twr3iswzdf7pyedb93yhe
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794326407-420346
X-HE-Meta: U2FsdGVkX18b62tKxvT1k3lZ2XRcRRV1szF7WJ7HIYcnkuAFuYmeQlNonv4/ySVPvtE6p3PLOj5MU+GIV6MuABCII4vdZy/1Zwejaapoa1O5AGgvMA4P+vwyPwV/x+Wuj+GSO3g8YjFbRALP3WoRuD0nNPSUEFj/Tr0YabedaFEIYE4VCMxEF9VWaYcnYRR6r3CgP759RRiCyzFljCn2ySLEnZffdxxRSdJaAT1fAOl7Lq4BWbempdseMPhW5Eol3zi3VPjYp3Viv5ZgOsqJ8jShfsv6TEF3XkqDIVozy/ODGW8YWtOSer/G5+RHSoUpWNBiFkQaGbjz/oMP1RfPkXwgKVPPCf2kWSS4T9Kvm/TtMkuJT6oVnq0dr2C5heP2aWF5rwJx+9H4djSpG1nQEW7sMyAOaYr+Z7lG62JEpycTmaREvIEBXVjVKwdQiVZSaUWbhoo0c8rwe55TLtUCs221fHxUZ9MZMRkimwtJWUc6s2bIXtSGQuGUFnV2uCM9Va1XJDZtI5xViVBvtupynHPqOEZpm6sYUjwtijy8oQoDsPx44rmBSoavsQYQ3CSBVqjloP6QyXamIO/U+CQhCQuJ3DVFVmD3rTczNmLLr9MiHXMvOY8+OjoCnhrOcgGlqscYgh3WPtClFCvalepKfgtb7JMEGl/nSsedv4iS2EzC+NiqPnuE0nzqhl6mohxHBEtZsXU27JH2XWvzfFiXh/q2povwsXPPrTD5A63Z85/uqjyhK4l2SfiIyVYEiadwVrW3i2qJQSwSm3/2hbGSQiwjxCnNGWlHi/2Wf/O5OyCL+mU+dpKg/6ganWervxPCZs/2/v8kzSN2io0FWGkkbQE9BVHysoVHN3yYN6WmQeap7U5ejL5dV3ZXbrHs6x5MuQlcygVYNcvq4X+DmUr8NeyQL0xfMaapaU/ZUGzgFLgehBtBSoei7oZhac4LLkfXPdvfmMn4sETIHzBiDDa
 8X8czYPf
 tKCLficNv9FOs8dyOVNovRfKl0nsiMlCd6Z0PCAYDVxxPfgDlW1Zf8nifQcmo1kQ+h0IZ2DgxD94RYlwPp6fb/CVDBNf1gwvVeBbxMaP6hSvpCqOzqZ8+Mmfe0OqfYw2FPi50NCYW+jeTmwSjEkKF/DubzsuZT5tOlNEUTU4X7tu+ijHNAAx/rz6F0s0nwcnjepephMIwS24oK5Ei9CRmlncoZh9O7wseKPy/JQp00sLDHIVLGnZHMNyWUZVvineq+J3n9vooT3+gEOOdIJ2A1T1ilJiTZfXDGNZ6uSGiv8Ld2MsoYzD2jNjBZSZuFyEOm1UXeq1Fnn+hpr5cJarKvZ5WMtAa3uIf2PyKStS2x44iJB7J7kbc+ddTnJOOTNR3VfnJyvAp2j5LYoCI5OPigdANPk8SpBdQ55TPn9oTRgSLWnkaNj5Y1M4WEThzLSjpOV6mUCvnsXQP/8Avpnonm32XZ6+DhcmEnqpR8U6gLyzQ24a5ikz+RC52PZCQAG3445bB+mjBH6+i60Ksv1u4FOQaCCv/Gy1ecsKlXXIqpk4kXxA96n6lLA7JsVXOR+IV8HxFx2SEnwL+KeQt9vHQZni0/Uu6fFcRRUMF0MAx87SykzU6B/XgeWnrYHEaxKPch6Ql7y2hQiVlBRX+kPmInaHO44VETsHYd9FeGKcuHj24f7noQS0ue2YFNI1DQS5j9TaSmCmlcWUZ67Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 at 06:52, Kiryl Shutsemau (Meta) <kas@kernel.org> wrote:
>
>  11 files changed, 26 insertions(+), 360 deletions(-)

Ack. Lovely. I'm considering just taking this as-is now, rather than
delaying it. Comments?

               Linus

