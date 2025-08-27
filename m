Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDDB9CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130E78E0132; Wed, 27 Aug 2025 05:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108628E0105; Wed, 27 Aug 2025 05:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39838E0132; Wed, 27 Aug 2025 05:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF20C8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:39:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63A2584A71
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:39:03 +0000 (UTC)
X-FDA: 83822038566.17.D5FBB50
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id E9B6840005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:39:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QGKvdeIB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756287541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDareXP0zA0Cp+JZgCavNWq3AWwIIJKps4a4WMg3dr8=;
	b=dAWlms9pp/LgWxKrNOGA02xGv5ASITRDK1EYPZTbl7LA+7bsIqPz11T8ubRzhMcmUpcUX4
	oGVjqJW9Vux5QRyisXZC7MbkaITCMhUw0FX++ky1kPFuCTcqnsFOqwdZBsd2qifQA7mm6W
	zVjsZswu+bmNqyo2ZIrrT07HltW8jqg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QGKvdeIB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756287541; a=rsa-sha256;
	cv=none;
	b=gC3Xi4edz3HxT+sgr0AaA4Fzs74Sc/c0SNfsWpldTdpRKrQKwc2WY8J9VWKFHLl/02OvDR
	QTCud47VXYd4bvqP4DA5+wF3wFKkDcSjUdib7jk2XUZY8vjyPJGbX0QEVG3gnovf7pdfdI
	FokQUn9dn8WQrIr83GRVokXPEI+gvP4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756287540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NDareXP0zA0Cp+JZgCavNWq3AWwIIJKps4a4WMg3dr8=;
	b=QGKvdeIBXqPBifyWuSEoQbrfshAuYaWAYFG0dKz0KXlZe5NMExg5EXcUF5V6ngDQRRDjg6
	ozu/6gtMIGaJNtLzRTcLF2JnTsOz/YmhON+RmH3sSzrQnQBu6c0C2aQ1uu+8cZx5BCgQLE
	G1EAPxHhiPvVyzlGBMuqxUetJP51yAE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-wn_f5H6ZOliOF7i_t2tYgw-1; Wed, 27 Aug 2025 05:38:58 -0400
X-MC-Unique: wn_f5H6ZOliOF7i_t2tYgw-1
X-Mimecast-MFC-AGG-ID: wn_f5H6ZOliOF7i_t2tYgw_1756287538
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4b2f78511e6so5754161cf.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756287538; x=1756892338;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NDareXP0zA0Cp+JZgCavNWq3AWwIIJKps4a4WMg3dr8=;
        b=OMYRHkzUIMtNOCAZzEDcCODeK/8kD0J3wv69bta0arANLJS3SCXQNoR2c2OQr3Uzxb
         lMpyMsZ+1r/GmYW6Sg7FTS/cN6V5GDS/0hHJsu23SWMr/0TBrV6uv1la2v8OnS7pC9VG
         X2dxzy5zcil2SK3DEClSJtgwNP9Y9xZYtXk7+4NaZQWqBPahVCcjWja0PiF5OxrMCcP9
         0d9gLC25R8a5+WIBCrbsHOcxwDAAaYIz59DSBS+ZFzvODnCfWghXuQwj6f6LI2hdbcuk
         QmqHyVViQfMHYdKcenPBT+ofQiXqHZX7NtQQ7BWAZk03gX5iOi2TJ3nKt154Vu1DntQ/
         KalQ==
X-Forwarded-Encrypted: i=1; AJvYcCURnOqcxrdGdABVSqOO79D/MPbZ7kE9thILNiO6VyNvLh+qF58SQFtQHXGA26GvDO4TCD4WZo6VGA==@kvack.org
X-Gm-Message-State: AOJu0YxBAexs4kOFM8H6CjEY6FRvQRm85gkSs/cGJWEwm9p3zFjwFLf4
	Gnoi0ymjKPcTDlBlwBrpR5ll2NbTRpTvndzu4ycRijLIGHvrFbIs+suQBS29dDIsK/9hQqtW9fQ
	zgWSMgAQ4hxkTFURMbivH8D7HPU4bp5BjFEsu0XxV4J6UpYHsGw9E
X-Gm-Gg: ASbGncvTaG6saMBOVBGZRm2TiUw2vPufiGQVZwQ6CuTq6p27eTo/awPcIu6xe0epqOd
	2rwWmd8rOJcPu5pgiJN5/Qrrtq3vxoaUHpHD+MWD4nYEJ3CHedv92GFuwEZdzg1BhyktosCC3wI
	HppMlohXV2xqgCJNKIPenafjUccblvVDk0Y+veZ67CM2sKwxq/N6nMtiSYx3nwkuEnXc2F2isQk
	gadDFQXU/ucLHEJlohZDOgdtDUFlIllxIZH5I5y9dGwdLDl73VPhZqh2U/fngI8C4B3d22jcbFk
	JtUpgnnhBJNNogoF/jTKa87ZXuV6VqTIDY+vFJSz3ApUlikIV7RtzR9PAYmqHg==
X-Received: by 2002:a05:622a:4116:b0:4b0:76a8:2d3b with SMTP id d75a77b69052e-4b2aab4b25dmr254349941cf.44.1756287538135;
        Wed, 27 Aug 2025 02:38:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPbbCdrZwwAN1B8VRcWZtqkCoaZcEbgpK0aDOziyitGNq7xIIbFIW1coG3LuFIn7qTi1Tmkw==
X-Received: by 2002:a05:622a:4116:b0:4b0:76a8:2d3b with SMTP id d75a77b69052e-4b2aab4b25dmr254349661cf.44.1756287537627;
        Wed, 27 Aug 2025 02:38:57 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8de5fdesm85480771cf.31.2025.08.27.02.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 02:38:57 -0700 (PDT)
Message-ID: <66dac672-88f8-4101-9a66-382cd3794756@redhat.com>
Date: Wed, 27 Aug 2025 11:38:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/swap: add BUG_ON(folio==NULL) to folios_put_refs()
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, shikemeng@huaweicloud.com,
 kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, chrisl@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250826231626.218675-1-max.kellermann@ionos.com>
 <20250826231626.218675-2-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250826231626.218675-2-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: os2QP6V2Vn-AZ6ypPXy1TwYuqIzA4cYA8LDdH1MiWf4_1756287538
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E9B6840005
X-Stat-Signature: cna7axp3mbpmcm7fiqugb59xo6emkk1f
X-Rspam-User: 
X-HE-Tag: 1756287540-691222
X-HE-Meta: U2FsdGVkX1915OewmJiX0yDHeP395vVSB/St/wwxIFZICtQBZnrDuz0AAUolpxxpCSYgnyvnulSN2I2HXso+KsKca7zxUCewLa3lFt7RDuUmgDPlga7Bl3cbgLFBn6FRFYfD7EMs00Ug5BW0XF8DJ966LpkrQb1Y3ssL9wiSMZVb0NCQ/IAY/a6FKG0VAd08Eekig5Z6sCA/+9GlkWQSiKbYtAkbIKodr3xxlJG1fJAR0sPdT80ZM6+gnaJ0IOpZB+R+xlJnm4cS0f2ZrSRe/MGUxI/jYRbv2O9b0DH/PtDL44ROgKqibwnTvZqyqRivUE9xeQtIl4pPztpFgvFWQDtExv7GX5bf4M9SsDqV7WYNt8g8NpVV2Up961luvwKbOoVbkH1Y1vy955NKgoAJq69IoVGR2uxBN9mpYaqS/GL6vmyv3AiBHmUBAwni3aUqZGmTf6zm6JduFS2vXWglnRuR3GanDUyjF7NpakAIzRH7arjY5+2sTCFItM67WV/1m7GYXVlasE6Mz9hvRPhB2rBgZva3h14hR0Q6zgNbpKG2Hjcrhtt5f8xjp5osznC39D9IiFzwLstMG/pNqM8wg8CBaNgNyXRfovyeNdLoaZumXeWuXAh7fWl7LTeTvIPnNRgXrVcVWaPvbZInCcM413VXbq/it2dI/SxYATiVOaAY7NKH0oLlH8uHKrCh/yQeUFXrjLZg8Zl98VNr0UVqUxoHajyu62OMyyxN8Epv+/MC2siMh3vSFCkVQmp/Nx/eB5RdBhJkCA0Rs2RHE8h2vZFVYDjLbL/NqbXCUcLOntpe8tteqi5BfzrIxbjDnL41DefxCg9aWwkoq2R4osuAEexrdVjykF1tpSzRgKgmIZpqKnOuwB/O4UzbCDzWSFdQafY5Lt0xhud/+q+IOq3aAWEAsmBKKKt9y+UIaeo7e6uGXXCAgJ4/qVP1eCEiZtRJ80IeOn4nFlUqMxubUn5
 MzIvGr3D
 P0fpgHH+T2A5UA78dCo1dhs5vnJDaSY7k8EEhDfqhCStEaNQBgzhsgQ22MxeKPhmSDcdcgOpKPQpZDrov3cTvpbI5VjOeaWTq7ovip8H0Ek3EuMS49z1eSn9Bltj3iy3ok/OOzn+Jbe8LhsAn0RBGA2l3KxyvqcCJ3YcxvIUw2MDiztphH3MrjjNBO4Dz2H4zdpUVsHOTiQvAwuxm36/EANs28z9UUp/mfGe2UExgApfhSybyjikSzlglb0bTRyrdnC+cm/3qL/Jgh8G0iG+l2F7BY5bEC7RR/IcskTXRMQurMC6uhY2/b0izVciAogIbwtN9XNaJ27f2SZJUkVbSao+oHA3R1dxBFBscaUpXdA6y864Xh1N31j+Wx0W7lTsIM4wmfyRHYbKFeOSby2RaZcdLu0bujqKImnQEOxM74Urqrr5jniRpyfsXjd4gcWpp3JuS9nAdVFZZEBIrMredmwNvh4H+EkUjatCnBedczbU+qgPUJuFCPvHrOV6DbpS62b2HotgrnOiP0QQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 01:16, Max Kellermann wrote:
> It is not legal to have NULL pointers in a folio_batch.
> 
> However, the Ceph code does exactly this, and a refactoring patch gone
> wrong has exposed this to folios_put_refs(), see
> https://lore.kernel.org/ceph-devel/aK4v548CId5GIKG1@swift.blarg.de/
> 
> I believe this should Oops instead of crashing due to NULL pointer
> reference (guarded by is_huge_zero_folio(), which may silently hide
> the bug).
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>   mm/swap.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 3632dd061beb..07ccda00e7ee 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -952,6 +952,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
>   	for (i = 0, j = 0; i < folios->nr; i++) {
>   		struct folio *folio = folios->folios[i];
>   		unsigned int nr_refs = refs ? refs[i] : 1;
> +		BUG_ON(folio == NULL);

We shouldn't be adding such checks into each and every function that 
expects a valid folio.

The is_huge_zero_folio() is special because it does not crash 
immediately when the function is abused.

So we don't want this (and in particular not a BUG_ON).

-- 
Cheers

David / dhildenb


