Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B250ACF45D4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 02:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD39E6B0005; Mon, 12 Jan 2026 21:31:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C819A6B0088; Mon, 12 Jan 2026 21:31:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CA26B008A; Mon, 12 Jan 2026 21:31:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA0A76B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:31:21 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1925D1A1525
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:31:21 +0000 (UTC)
X-FDA: 84325363962.14.3221C8A
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2B55C100002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:31:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lD+I77vk;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768271479; a=rsa-sha256;
	cv=none;
	b=c33DSbt+G0P3HjVZENT2dlbKdWsRqQsyY+vyzD9bZ/0OsnyggSN6d1DaiplPHTXmRH4eKL
	49nRLaUnlB8ek8R3b1xpK5p2bI3xsH0JG5917mehkER9kV86yRtLC6gkTC663BcFiO4PJ7
	pgRIcRQC/XAjN4ATMnWjCuxgh8+pIZ4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lD+I77vk;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768271479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C93O5nOVDkkg2FxJmCyd4hhnDoz5R8BWkurFehIYVAY=;
	b=XBcBMG7FZ/yhNj/QMcmQmboq0cj28+6EUjWIJNjR+BhjddzlnVqpcNx/WBG7XEG192Nxe3
	H8ipoRG2l3TRltQL/SJgqLOz5MV0Tu1nBYy9R/IQWpkKJhhzJ96KytSzfIONa6TfsQmxAe
	k7Pa1cKId75Iu9XDKC3yPigegCnoU7c=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ffc5f35b54so53437271cf.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768271478; x=1768876278; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C93O5nOVDkkg2FxJmCyd4hhnDoz5R8BWkurFehIYVAY=;
        b=lD+I77vkzMY6bTP+bR1dJ8ShQ14H+d+m0Zj/wMQY0arrAGC7pMCHbVZk4gCjQsZL5s
         FAD44OxYXTU95BRFxbYGfbYAhHIOpUAylbTDydYnxR+0/TUNItrrY9QRKBaCb3KtX9II
         N2rh3TCAIzv3Jb1of6YCwdMImYDSWaF6WDth5ApsdUmIKBQDEGUJvxoHeUUu1/GSPwKe
         awwmPGq7BFfXmh/cb9zOoCdP4NhV2fL5HxlNppLWP0XL0+Ey7PDUKawKTKNLLoATFnz3
         2Q98X05gc1wpMa9+d4PWfqgEFuzEZaQSnO0Mn+4ANRlglGTi03IK6BDz1wIzVc2tMov+
         0ing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768271478; x=1768876278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C93O5nOVDkkg2FxJmCyd4hhnDoz5R8BWkurFehIYVAY=;
        b=gnFybTwxYKl1zu+d6GGnIpVFJwMnhq2oEhrOVulQeWdExFSKhU5UcxZYPdvFXXX3Hf
         lNY6p5ENIenFLDAambUc/qgmkqK0QQVsBK9pAbzU6c7pYPiujY1RqjaPLQvTvyia2FZU
         1G36S/4mGYNp7C2v43gpb/IiwYM6lAHU8ecs5+z6k7hAPe1RYEXoOwhxMp2/x+kpCTQY
         NxCC4dIY3AbqHkszXeZ1hTYArhqGiQaoNAAZFv4HLGSzVcN6KnPvYCOgUAJT7Ru3MFP2
         MW+0H4D5iS/trO16Km3tNx4MZn5mCc3UfOCT0nISfJWECn+U8XDjFh6C8CVSHsg7efnV
         WWwA==
X-Forwarded-Encrypted: i=1; AJvYcCWkTn82CUsQeZVLb0sr0x+v81+6EuH/slt6RrInRzLiZ8h686wL7mlj86G8+RUQWgAWRYTRUiSS6Q==@kvack.org
X-Gm-Message-State: AOJu0Yyh6EfvZiIFE+Z/7L85vUtrjRO5ofNFHKJJVedWc1n2aRSbOXBC
	IkzjseZT9WgQ6EKjiBdnYN5oKCmmzABQwAtflW3GXExavvCJ54DzSkjvvHOBiJpL+hQ=
X-Gm-Gg: AY/fxX62mO3z5q4n71uXXewFnqhiqb2d1otPiSSnp6TX1d3HVNX4ixObToYBPcaztk5
	M38kF/AdOhWx9A6UJ/JfdFTTKRadjQqW9o9gtevo4ZZUqGsdCjEzoFWUmBVKVwYKbrGzhaFxj58
	QxkA+nbUXQXVwOzFS0BJeE5TcjHDjooiKs6bYezoEFp5106jwOm/Y2De71jZt1OhLsA7/P/vc1Q
	Q0kW5vvRVVWse4bJQp4rtf9newRvi0BgQ8AV0Fde56UagjsmyyKGOxyW+G/OdWAsNy9KnkhTjwz
	NcG9ltNDp61dw2PWMsRUTD+36W0RVYx0HJfRssdgb2guTR4l1SoOMxXc24sBSFj37mkLeiKYarY
	0fjBos45oewSM63hSIHOTCMgZb7vvGiH+HjFBAFmdHB8tYBWnWbwLnCe6b3j3cm1VmL1jF8Hyl7
	96dVj0j2Mck3rpRCkjzzVBT2j9dpj9vkGJg2qHgP0SZh7Fb8A7h0flG2vFJknC90IdfnWljQ==
X-Google-Smtp-Source: AGHT+IHCPi4MK9/Ik3dfsfDzq1ju/aCSzOs8EU/3afAsNmDf9hjv1FD2hLSAdQvv7O4wE1FSIssF8Q==
X-Received: by 2002:a05:622a:4247:b0:4ff:8500:7881 with SMTP id d75a77b69052e-4ffb484a753mr234149851cf.15.1768271478154;
        Mon, 12 Jan 2026 18:31:18 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa926a9d9sm135952921cf.25.2026.01.12.18.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 18:31:17 -0800 (PST)
Date: Mon, 12 Jan 2026 21:30:43 -0500
From: Gregory Price <gourry@gourry.net>
To: dan.j.williams@intel.com
Cc: Balbir Singh <balbirs@nvidia.com>, Yury Norov <ynorov@nvidia.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com, longman@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 0/8] mm,numa: N_PRIVATE node isolation for
 device-managed memory
Message-ID: <aWWuU8xphCP_g6KI@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <6604d787-1744-4acf-80c0-e428fee1677e@nvidia.com>
 <aWUHAboKw28XepWr@gourry-fedora-PF4VCD3F>
 <aWUs8Fx2CG07F81e@yury>
 <696566a1e228d_2071810076@dwillia2-mobl4.notmuch>
 <e635e534-5aa6-485a-bd5c-7a0bc69f14f2@nvidia.com>
 <696571507b075_20718100d4@dwillia2-mobl4.notmuch>
 <966ce77a-c055-4ab8-9c40-d02de7b67895@nvidia.com>
 <aWWGZVsY84D7YNu1@gourry-fedora-PF4VCD3F>
 <69659d418650a_207181009a@dwillia2-mobl4.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69659d418650a_207181009a@dwillia2-mobl4.notmuch>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B55C100002
X-Stat-Signature: azi5n5xtd5b3wozadwmfqc8qxdqrssnt
X-Rspam-User: 
X-HE-Tag: 1768271479-124141
X-HE-Meta: U2FsdGVkX18175jl7UZAzsCJvNdc4OlJk3UjgyrP7NWgl7mHoCbC4LmLVHL0fNGgvRttMj+GKsBe9vAjnWFfyoxSOs3uqH0MJ1D8oe7rJPDzhnitq69vNJp2wOzb99uVjk8i+W7ME2rF/brf40oV+5gkBZdhmWiJFMPiGtNtt3m2P/M7f7fr9iCLGtvqMfk4CIUCIgoNq9C6ArN0PiuSbkyUgDJgcIkjam6MXN9wnTlL+inyQ+HBNX+k/ihyw+LecBD932JdTsHIa6YT7AGeRuPNz4be7KGqc3miOg2qUXCQlCYPrcQdw2Z94IwW76MkgWzg7Vyh3Si3sWgOP9KQJfCPXdh6sW3NLa/Ypu8JDMULfER9XEeJF6ubM+cyBxDE5Wt3Q5rYeAVZPxXEeImog29vrNrBYXsiJqfHXcFEMm4Uui3vA45ZP6pcZjt8Ilu1Es9yN3mcchmQe3vw0HOJEE0ZPBy1blfVlrdWeFB/TEvIP8IKFdv1NBgz+DOY8GUXEMA1QMIAFSl2u96FFXtKBeEayVfA0cgOTiLOb+XUkoHiGkdMlDaBZ24cqA/mAaiZqg74rPYpTxvOxLMedketM0FmqFXDlTm5EPDWpWvNF7Bryr6agttdElW/HYDKdl1nUSqpxV3W8tsY9dpoMTpddLpy7dbNM2e85/KNgu4jKFkkj826U2W6Vdt7Y4tzyzqfacOtnUkZ76Y75qTEK49rg4xwW0R9C4CwHWCNVEIxNJtoeA2Lo+nR5wwWht1Py2zR59j5pR/Dain9b3J0mO0YOposjKPWol2v0Q08IIjcHfb6l9f7fBXL3CI0wGPG47Cezc+DILnqBVz6+OKS3Gz34lZC5nJzgRQ5OHCconqFWVmHFOyxKdlunbdZIiRuzs586nm63CILOpYudTenuJzRhPJ89HCZngBNcd6USEJsTrIa6T2SJ1+RWlgFyNKXRuKHUzPHwKtru6Ruv6ROKKs
 TJ25p0rR
 GBp24EzfR8onK2KpvDNbks6msAn90YA3/CPEznbADu+drABX9ND28N3darWDMT3tw+9Ot+n+PqS4Rap48TKZW+gaTrikm+g1++gzoXRTtlUA5Mim0RA5GdPWR0JBDzo0kwOHdVbL9Ye0Zkc1yG30cvSh42zdAvftBrKKEfoyrS+pSVS7043lfAM0zbZc+QriLSFAi0YYWhvf/q8UCqsTVN5LrwjXgR4oQ8vUyaDcTrLDGeUEXwtnwvLVaU8jjlTxzFT0eUXoW3l861Vvc2umgnCbJuRpaJ+p0qHuDYdUHLH1/bqJ31XqeMj/EHCQrnA76NYv2MGMZE8DsfqpequzEn8IQyN0aM1azwynBLitCZcOKfguvLGfA+nceCVMEwi2QnY9A/A8OFGCj5JF9nT54O0ERuq2GhPRAfXq/CYB451s/k1GECrorNJy0AuPnvmjUmQ2gX7E7g+6ZKjuPZkt+8+VSmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 05:17:53PM -0800, dan.j.williams@intel.com wrote:
> 
> I think what Balbir is saying is that the _PUBLIC is implied and can be
> omitted. It is true that N_MEMORY[_PUBLIC] already indicates multi-zone
> support. So N_MEMORY_PRIVATE makes sense to me as something that it is
> distinct from N_{HIGH,NORMAL}_MEMORY which are subsets of N_MEMORY.
> Distinct to prompt "go read the documentation to figure out why this
> thing looks not like the others".

Ah, ack.  Will update for v4 once i give some thought to the compression
stuff and the cgroups notes.

I would love if the ZONE_DEVICE folks could also chime in on whether the
callback structures for pgmap and hmm might be re-usable here, but might
take a few more versions to get the attention of everyone.

~Gregory

