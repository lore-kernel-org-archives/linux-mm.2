Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3785E7BD85
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 10:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F246B0005; Mon, 16 Feb 2026 05:06:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D3066B0088; Mon, 16 Feb 2026 05:06:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE066B0089; Mon, 16 Feb 2026 05:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 056706B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 05:06:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B79213C1C5
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:06:07 +0000 (UTC)
X-FDA: 84449889174.19.9DE8E4D
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id BE96318000E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:06:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jU5GlL5V;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771236365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lA3OEEP90dY108YV/hs7UutfJeQZLnf5b9cwdqh33lU=;
	b=p6TnfaAAxrRU6Ej9FmpVDckW77FgXDHUIVGmq+SUVn4zn2We+B90g8Nj7rmLITma7AT6qD
	DYGmIy6yPqkcLkHS5yJofMkQc+g8hW1EHaAeh4yWindJtNpQHzHwV4BtxjKmlAEX3Sqlt1
	MsJChYu8hjI7PX+3svqS4ZPdjtzeWCk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jU5GlL5V;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771236365; a=rsa-sha256;
	cv=none;
	b=W0TRI1CUQRUZq8FCgMsk55692IBLXHYeVfO0kfd6ea0m/6BlO4W/xi/PSa0qaisJgL2tVf
	5xGvWnRWUxe+WleSHT29rt8kNpwIjoL/zHmrHDG6VdTllV9dXtpf4721INNSJgEow7X87J
	EFxg9qSp2oLVXVwKhGQ5aRMcu+9VvCQ=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso2466894b3a.2
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 02:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1771236364; x=1771841164; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lA3OEEP90dY108YV/hs7UutfJeQZLnf5b9cwdqh33lU=;
        b=jU5GlL5VHPbZZFB4ZpIs2W08Hv998nrEarL950Av82wR935XivCXASoOgm4PPgZD0k
         vJSa5AdbhNKF71fti1PA/GDyPfHdizwn8n0hVYZK3BwkteJzoY7lbMXSNYyfSzu3n+TR
         NVce0Zm8B55GqbYFrYTCNWuz4NRRSOqnvUl8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771236364; x=1771841164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lA3OEEP90dY108YV/hs7UutfJeQZLnf5b9cwdqh33lU=;
        b=txlCl0BiulEMzb8Y4qzfXvdyCya1uxu5SgTMjPxAa8wCTprWC8xn097R1qe2R709eB
         Brgtavv9YdYNlyzoqMSlMvKFTVSAkgmWstzldk+0w4jaUrv/dsx/zCq66WV0pONvz/g0
         82LILb6pdVLz/tsHVbobXfRsTRv7BL/i7c7MDHgAR/I6U4Z+tiX9qQCZj3VHiZz9apvp
         yPnwTwEDU0OFbiNKB67XJu4JxN9Y45W+JHbrXuosxPYn7cYts6KNqo/hEcAqJgu9PEAj
         6nGepXStCtyaWlOVyZaVot3Dz2IS2qykUgAX0c5VrzljtMNK3fKeohyO70T134lDRo9i
         BlkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgw7Re5qV8ABE561Ssc01p1bZrpbsb8+iQQojWmng7OuX+SfuQfn/Bq3EPy646LOzsnMubvKi1rA==@kvack.org
X-Gm-Message-State: AOJu0YwWcDVozPpeS6rkDcDQsECIGNS9GF0vUlZB5G4YMH3+stc4ojCD
	y6okw24bu8c7xJeruWc4zt7YbQoqP5WnRm9C2OHT74moHjCQUBF162wrlKX7XLQhHQ==
X-Gm-Gg: AZuq6aIgBY4+lzpkNN9kIKUSvqbt8+ANMc5zTGO3YmVS30EI4mNCYsGfg2VCXfRXzr8
	zln1u27OVmxbw2FSGbGzNMMI9eQSsTEedVxsanvhC45WGZ5/mpaqnyaVH0lbIHHtoCNSCPPxi3l
	t3iY9DjcPrQdhms6mtq9jbOIMlAzhv6v15bBK5kQMvADCCh4/fFJJ6aWauJ3k1P65IqLHE7+qLR
	gwkxsGT7gji/RtcQs4hRq4lROL4SyEJn37NticqGPeI0MPijsi0i82lS5WSeTXeYEmJbIAbmAPy
	epGrJhH3ieDzDKqJ3QoJ2G3sWOuLELP4zfOoumW1O9nu+SvGMCuX2HXcShKs7/FVEszmmL9zJI1
	pRHdy3qcDwtNyHf8DAD2HBjMVhvmX8otirt0MjOXAk5KrwJ6D10IlvkTN1VU7myxxgYff3O2UIO
	JpAlKC/fOtlj/2Hz40ey/DnsdDK1yuZSAyRHsKS9HViya3YuvB9EK01HUhcSNSUwo=
X-Received: by 2002:a05:6a00:a205:b0:81e:e5e9:9aa7 with SMTP id d2e1a72fcca58-824c612c419mr9427274b3a.52.1771236364426;
        Mon, 16 Feb 2026 02:06:04 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:16a9:1c52:52a1:18af])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a409e6sm9933774b3a.18.2026.02.16.02.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 02:06:03 -0800 (PST)
Date: Mon, 16 Feb 2026 19:05:59 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
Message-ID: <pwsx46mfwebugunergbaqxmm4fuoacnndjvexi7ukoyznxuy7x@ml4tjdxgf4ac>
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
 <jftqdosilzfkd4ku6pjuevkvuwmhlqtua62jwsmmgdfcseitb4@gopt2xzqhyrk>
 <3571cf8b-9fb3-41b2-a402-a8537ee2c399@kernel.org>
 <r6m6vdhbqada6i3gugtnj3lytjrkyiretihwebwci423vwslcr@ysrgdqvvno6b>
 <16ce9ce2-8081-482c-a6ea-0932ebd081f1@kernel.org>
 <56345542-544a-48e4-b127-49a850deee9b@linux.dev>
 <5dc7d3a2-a358-481d-9352-d8356d3343c2@kernel.org>
 <jfj7y2xpqqnpzvttyd7uotavxk2geabdqbwwsdr3akmcz2cioh@5h7nelhexzyf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jfj7y2xpqqnpzvttyd7uotavxk2geabdqbwwsdr3akmcz2cioh@5h7nelhexzyf>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE96318000E
X-Stat-Signature: nhu9cib9g119gomfpr1opf7ibka78ius
X-Rspam-User: 
X-HE-Tag: 1771236365-21811
X-HE-Meta: U2FsdGVkX1+g6367cxEPbKn1aRkuyI9Op3DYoSuvfGRjXBO60VDNoRJvQG57asg1MFqX+QhWUxl96icT3zMYPhu+3d0YxDw7fDziVEcvJH3mp8FUU6W5d/NdQB0fYjN9A7lcafGU/02BGWwcYgbjptxT5rgBcWsU+D7EjecdB8jFFnXxedXcLB55uBDty2srqplktaa5fBd05aQC6B2CMy1ZLsxvohaRqcgWc9eaayGYmUN+0b1IBNnXdhwl5mR24fCZiYeS44VGZpsrmbJUybtvaBB0rwaNQ31o6rRdc750jqcwe0/G7m6XteeNOkUivbnZDhBg6UNLbOSrA5cOCz5ZznSKeBemh6RxTGpvdIfPw1ZoPDYzIgh6qSKdLjV0Nfrqnp4dU9lQm0bjNHhG9QbVXWK8T27ycGv/1rCZrL8sSmLnh6Q3FfmX9qGUY0zxbbJhhf/792H4KOCfFDecLBe9dHqHDenqnNH7PcGQDulOv1YXE0bephxZ7Xd24LdttNaagoCGF0N9/UkqFUCErZ+1h2JCMA34nwUzCEURxobiKBOrq05woeW5sw16bmbiamllj09/6MmokKUw/ZKOumqdlUMiJcz3T1zuX+rE6sf/UByyNmo1ogu24CrCIcBJxOkApicDkKtDJQTxX2Ym9RA7M8DC3zFZ3oj0/IWpwiNsKyDxdN3h4l+gSaJgWHl+MWe54LKQr4Gvqs0f2JU9hi9aBa84f7gL8d08YsPApTJs0AZwi2DL5QMCCJ1Cnr5Tk2MbIlWDS6uBm7s7eBCiWlVEh1VrdLzVBIS/lb83eYWMSzLXBDuYRNFtybmS7+aEE350TlvVZayrizpqxPrjiXs1riKI9HWRqk94XE/YYxCxnHsA3Ol5vnIr+kE9QhxXcxL4ZmH8DldTkrUCkD6FhwVDnBHefw8BMn85bVYczvQXNPDIYKVHSe4FicHuWPMhSv63PlF8UU50MR6GuaS
 wXrlf7TP
 ccAmnPaWLXYz5WvhV2jmmuyxMULtPwGAVeSVuhulUkSgAje8Tpfiw7TLEBs9jA3K0Jnp+jTCEMNerNMKYByGm5EZWOjbfsQyB2JNyqj9Am9JoKqqpDf6SGQJIfE3UNUmeKra9v4WtHEGUNbrbP/nNwZ4LiDf8wtrPgVFXEetY8C3GKQp/SmbqJ7yibq2SlAARbvekC2vKKbBoTfvRLybHD30/IN7oljs8puFbXB4Z5HdpF8x+CsPGICbclYjjCAapNdzb+sFeEujxTrDAr5kEJAarXY97CNk3Qnym6bmxP5TOjTEk64ObJcPHcG/sC0ORz+OsqFug74e62a8+/8r97KICYBi5v+0Nf2x1cF7MXDQ0RzU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/16 18:50), Sergey Senozhatsky wrote:
> On (26/02/16 10:24), David Hildenbrand (Arm) wrote:
> > > Maybe we also need check points inside these loops to bail out early?
> > 
> > I'd only do that if we have evidence that it's actually helpful.
> > 
> > @Sergey, with which base page size are you running (4k vs. 16k vs 64k)? I
> > assume your report is on aarch64, correct?
> 
> I had reports from a 2 CPU Intel n50 device, with 4096 PAGE_SIZE.
> I'm trying to repro on that device now (by running suspend/resume
		      ^^^ on a similar device, not exactly the same.
So I guess I wouldn't rule out the possibility of a h/w issue.

