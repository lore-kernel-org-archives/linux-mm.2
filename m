Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79AB6606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 07:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=B4BNyyeF
Received: by kanga.kvack.org (Postfix)
	id 6E2DD6B0614; Tue, 24 Nov 2026 02:49:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693616B0615; Tue, 24 Nov 2026 02:49:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582046B0616; Tue, 24 Nov 2026 02:49:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C33F6B0614
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:49:27 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABD771A0ABA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:49:26 +0000 (UTC)
X-FDA: 85469237532.04.C821B27
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id B543140003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:49:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=B4BNyyeF;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf04.hostedemail.com: domain of mingyu.he@shopee.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795506564;
	b=voSct3dzpcjPaTkcmuX2gxyP+Zoppmatnj6c++mUahqdyHqoXbjhC1Ect5ohQD8HqpmLlH
	AP7WZlDcweFGZTVNWxg8s9ASLb8EBfW3ekV0XfhutLmzZgatc3MHXHFe0T2L80ymlnhoMS
	Z2Cm44SQ3nbmZiUGXstzIDMLtigkKaM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795506564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0TL+yVGklLLhrdLGL0kexane9if3aUzjRd+iXnFC4k=;
	b=zQe/X0bTweo/oDkMlHyL7F3EQ6f1YFJKNihf/fXJNeypWcu+4hMULvvLNSmgdjLyNyMM+s
	ipOqmZ421zpYBfYuX1Wk/81zLjYt1R7RYXcI8BVGfD0xTyVybUPl8vtV1OWbu+bb0SWVPZ
	v/E9a+fClkZDLtPF2id0Hp09hBcnleE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=B4BNyyeF;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf04.hostedemail.com: domain of mingyu.he@shopee.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cddc597d062so2488406a12.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:49:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795506563; cv=none;
        d=google.com; s=arc-20260327;
        b=e1Or2pK21UM+r1PL8HGOYOWLo3RPuOuu4YPT/MbhmZ7oq8fgom6CD14W/1ntvAtg7L
         AUHpG4hWyy1imSl3tgo2FVYjf1G3XiZk2LnHTx0ids+FYjr5Os7FFEuumKV5q4WcWKwa
         a7pHzwP5hx2iV/j9JElqb9/lvIwESC9Di8MdIvY10G0uImjSvM5GawyR5Hwqsagq9TON
         YYTLxhxNtLk6Lq6aRnaPzWpgqkhWsz6OyPLjfUv2GlG6dmT7XBKd3V/57N1VzH1vMNxQ
         UqYQyRBTuG8r/XiHFS3Isf6/qhX6f9WOYuuNdkfaqVa4zfhSEGci8qtNi1Nfz67qvPYi
         57Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=n0TL+yVGklLLhrdLGL0kexane9if3aUzjRd+iXnFC4k=;
        fh=M1eASb9ev0J/r/OEaVAFlvZpXFqvt0zRU8eRQNtd4rw=;
        b=L3Q4VoFQAhcFI2bOJL/aETwl/RldfcdJHdJ6/Dh2oajGHOeWIX3C/DFuGqnCn9brX/
         AHuv+ehPDCCaI0jNkX7eHWxAbUFpyItcWW4Zu6+EaNpxiYfOXZwUApx+4iQv8ZjGpUEH
         PhCP1jcVBKjuxeXW/yx4dTdHCjh35ZQVFc1XVZfeeQ+dVhplVwnIzpCQAs6164f5wpI+
         yqdMLLu6frtm8eKUU4TDbaoyCFAmyKTgKyd/Sm3RzNi32ITUxzq97wBWeu6hcZEY3Or0
         iYauYYhjtCXo9BVsqcaV2zV9ExUSnrHr9fiODtH7NvebL+qiK2IRay9r2Kfo/dz9LsNF
         NRBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1795506563; x=1796111363; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n0TL+yVGklLLhrdLGL0kexane9if3aUzjRd+iXnFC4k=;
        b=B4BNyyeFBQtpc7VyLTN5ObO+iFbj+LCjprL2Dl25Iyz9Ix2kXLI638+M+iHMkHQ4BT
         OG/8CkLbhEFvrUoXP9/CkAT4zNEy/C67wSp1E+pTMVX2UccUM3AUOZJCH38WYczhN9fx
         9fauLQ7Kd4vThajVlP7Ovr5Bov4pR9fixOmnDrht74GflSqNAdUeEns7Pspsz0zq7HE6
         nx7DUQECu8XtcEBhdqL7QzrC47xM7RUKaI5245LdPVRsfug6bRl11HZ8UIXq36B+L0WV
         ZcDo1nPPU71e+f+K5AxPPecRduveRWYmNSZPr0RyUdNVJGr1XwUGpJiE9/yjP/IXbrpg
         6oAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795506563; x=1796111363;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n0TL+yVGklLLhrdLGL0kexane9if3aUzjRd+iXnFC4k=;
        b=21wKrslEqcmQvrZn0LKQ6MC2LqLoiHkpNo8OsAhRaKC2xz2YQnR8g09DKzw4E0ZI2W
         KrN90KvN9k9GLf+PIgNRvshGec24tRDJtob6ExInHfRIFmu6BPRAmDQ46GZiMTGC9IbE
         kzbp3rOO0NolBdzm+Ty7yiV0w0sSIE9hg+CQYKUoO7Oen/6oTQWo0GiDTxFrneSZAJjl
         j+oGtc6+HEstiwETVDbNVxa9IrYzFyrjN0lxdlGMEtMEI7cT3IWhaOg7E5pExezhjUID
         /zQbQN2VqSBqBHwRvDi3i2tm2ZLwXbI+Nsp3iu7cshpbUa6XNxmDl+O6XD9sJGSX9onM
         FRQA==
X-Forwarded-Encrypted: i=1; AL+hErHBmDHwSiFPMjFg2HGCKdC38suFg8j0F23/UvX6Pnvl72XUyLvErUSTvBTNRS765jNkCM39FzkGrw==@kvack.org
X-Gm-Message-State: APuU4Z99n3jyv/EYGfjy7aXBBV6GGTxdaudS9r6tpGqW5O+1Q2yeXtoi
	pJ62yYDk/jSwLFEg0yp+H/gQC5bHMYY5XW5/q08TGYHDdijbmWhHCzCkErM/mFiupypK1J2fXdr
	rxYO2kxSoYbCR32VH19egZo7GPGQssYtsCvNv8EtDYA==
X-Gm-Gg: AZFdTZdeg7/gIvHzt8GkLLCExFFTrNEyknAdnftU8MJ6kpBTwIxfYdztUt6eDWHkjYb
	jvQXSO8qBF65rKgcPPBvRGJJOQ1DABaEvv7erKGvRRmTrJTxMOREtdh0ZbYTrWwsNXHBBrzHnPN
	aKaMBhFatEzaVoZ892GOHP9TwWmp3vYiooEigsAGH44gzFnTTE82B2mXI9wol8PuJQLXcBMQHCz
	Qv4OFPkZR659qh2+21UgaukacboVXh1FaE/WmfwByGuHpLAVjY02gv/hgLy9uBat+LiMgMwiEYN
	S8v40bgfmWf+cxueVW+QPsAxqaXGwV/BSFk4iOz5TaUlrHWmvucGXWS+MYYnIJF27zLnh0Xswrc
	D2dvU25QMOPC5xFgR4QsWHCDIs6obBAE9mK/Z
X-Received: by 2002:a05:6a21:6104:b0:3de:456a:6e07 with SMTP id
 adf61e73a8af0-4014db601a8mr15842288637.46.1795506563336; Mon, 23 Nov 2026
 23:49:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112041348.66915-1-mingyu.he@shopee.com>
In-Reply-To: <20261112041348.66915-1-mingyu.he@shopee.com>
From: Mingyu He <mingyu.he@shopee.com>
Date: Tue, 24 Nov 2026 15:49:11 +0800
X-Gm-Features: Aa3M54ryVpMrYWVp8M6ME5vLlNPZfM6KixdhXQemQYg3UvT2_MftgFTVs9Eosq4
Message-ID: <CAAoBcuSen--oRubdaC3OPjmt4zCL2WDDU7-nbqPPReeMfvmyTg@mail.gmail.com>
Subject: Re: [PATCH v3] mm/bpf: Always flush memcg stats when explicitly requested
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: e8ktjq6d1zyisuauo76adm4geqgoutuq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B543140003
X-Rspam-User:
X-HE-Tag: 1795506564-651021
X-HE-Meta: U2FsdGVkX1/F/7gbUxWd/sAf4ONg6x5dHunisvNaEj4qmSztJT31MH7L4UViav0DfdKetGmue7LcCygowLYKy4wpFGz4obOmZJJw4U3nTHrHgLF/bHltohOeDLTTU680yf8VSNdXTSe9QRjJD0wCUqoXhrdXx8yiQXe/UVySTkZBcgj4mUqYihKCc/hwnr4pqJg/fklEKRHi5kfKFLSnDf2XzCQOCaR1o/Ocn0bEu9vtngxQlMdawgA2+F3kp4UelAQdnWTFSwtDyovwCFdnkbN1xFzyggGpqqwVALzu2kDIPwhN7QQ+cJpzLyxThjfcijtNjp5CWQbRgw97hCn08mElMtn4EDXXtD4ehOB+q0CKWNnYuo+GPll9b8ugRyBZjK3ZUD9rfBxk+BzneJJ88i2Oc5gORrhkNMhQOKJCm3ERDUHMaq7qFh6j3t3iCEqtMAefcCi7tcrBBpE/F5QWxEeA4IC8kIn+huu6/q/78x+ydC4+gahHTvAQCsuH7KnghSLhq2kop4UJxy/bVgSNd0MgLu9uSQnxLeQx2MmHiuDLVuzz68hT5KhvZWXta5okLCEbKGxas6nZ440yYhGbdJ0avU6dEaj7gd1qTsRGnIymJmMzjozG8ouydG9OTfWoIhed1xmtHdlL4539D4PRqsv2ommHUaD46m8AU+Drb+FNPEcyYxAnZi6iZ82oS0keTk2f+zXBTYj4tOppjNGRVJskumijONm3+RfZnqwfqoFTguwcGgPs4xAp/Kw6R+ke62rcFZlaNk14qL8lQ64CFl9raXFlYOM3PbOEKvL6EMwPFHsmVCS7pjU5uBVRsZU/1cnowX/WXlFfs3Y+cKhUXTQmYHFj5L+B/M3P2/a89rVIfASzXSHooSb9pAv8ta4ropnw9rW9tSe2gCXZa/MBp6h/gFsMDFhrHSAyjDAI2reqoleR72cRHRauMQtxJror0+F2N4/bZs661JGJ0B9
 DVLCRGQs
 cU+mWyPNncUj5Su6ak8CNiwFHOFw/1LU2fIG7cCYmsDS1jSnvStUqgb4jvVKksN1xblWtduqh3x3W4iCuTXzKS3XC7DvceX4yMEKGA9tpd0pKXraiEosZt8DpWizzpTWFz0R1zUGiFPcZ5o8F5rTsHWNOnUzAlG0kb+iGsTqQGj2UkoOG/Vm7FaU9/BkHeG8u8mdcUec313LtKc02dvDl6OASLSTaOMtvHyPxXZbBdQRggxuZr8WpGanYjgK7zh7WnEU5jVu2EaM5QuzlWGTwxTThTW9fiyguL7pMfu2CtARPH/A7RETEv+tW5lkROGTGQFy654wap0GPejm4VOW4yYMyq6mKi6AujLwdYWGNFxaKe35UGaUrMYmPL8KuXYhyWjlwSFF6zRv61NsabIojeGHOTTGEPuF9TmMTkWWenZHD53R7odhYsRuk/MlgszJVzYsWVZN9h1OjRInu1EeLwxDzQeY4U01yezoItenAtYSsXSiQ7vwXm4rasw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hi, gently pin this email, thanks!

