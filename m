Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF42CCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 17:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5AB6B0088; Sat, 17 Oct 2026 13:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186466B008A; Sat, 17 Oct 2026 13:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075026B008C; Sat, 17 Oct 2026 13:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D865C6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 13:31:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78112A7CC0
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:31:15 +0000 (UTC)
X-FDA: 85332809310.22.D7C159B
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79821C000A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:31:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lp8N6QZy;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792258273;
	b=fh13njCNToCkI5+Of1XmmMzmbDyu8BJdxMBzEdFCdeHow3Zz1Be3AYxgxD+WjQQyBAX01T
	p+OrWmCNoWR25QOQcbIENzA7Cic1LqbZkIW4KybNoV7s6WFJfN1MJ0muyC8yYmnvtZo7ak
	Fv/ByYRzEpjZZilVOHgG5ST6w9uCuRU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lp8N6QZy;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792258273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=746x5o1XAfb2RKvAoprpp2XG5c9g1cO4ICwQpVICiVk=;
	b=HknUuRD6i2EqBqUZvMy63cY7Zj0FVFU48u0OIinzk8/Npe8XgleJZLaFLgHyScA3VUr1Aj
	+iT0UC5fiaSTmTpIADolC6gskS5M7mheil2nxmcpqTYVG1h7RF+n1pjsHlvhhk5QMmTXB4
	fhRCHQ7ni0v7essVnf3o/EmO9u0FCoA=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso406676f8f.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792258272; x=1792863072; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=746x5o1XAfb2RKvAoprpp2XG5c9g1cO4ICwQpVICiVk=;
        b=Lp8N6QZyxVsTM9D5GNKOnMVzWmPCJU61O/ySlJFNR0aORoiscpwpMhcM8VBP4Tao56
         wqpd7qr4cbFmUF2UV9+1nAcCYuP3vvudGvDTgoCSXZSI7P5CnF5uJO9MkF7zXgN25L7p
         ENSTmM/O1N23djssc8gq/fpzKJ068HwXP1PPs3TzQGMpgsOpjNiF08ViOX74+hcH4Kjz
         DcAJbsrcrC/BO0p7u1hb182V3BWotLTh2hgfu/jQGzQIqDRUtlTPEfR2mDAedkBU6Mvk
         TeC1FArp+D7o1MqCeBdfwudceNYY6Gh4HB5pdh+PTdPJ80wXaWXWBQt7bkIV94I8CPsT
         3h1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792258272; x=1792863072;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=746x5o1XAfb2RKvAoprpp2XG5c9g1cO4ICwQpVICiVk=;
        b=gCrfWtq1vOKyAnXR5ETG1M3SkpUW1jifwRCv4eJD2+tn8UZaCIbpahq2U6OBnbtlc/
         ibuLNH1EyjEWUSKvKmjuhz06CU4h9rAyEdxmfwcsjc0uaPs5MUkXY9adh1ufMCYNh+1I
         1SREh8bMlNIPUXWNEK2DXu/mQ5W/CksZYZxhpuB5VtPxGpYAKtgVFhnPkRIjdBi+RCsn
         7dC0V08KBjYOZVwq1/dlku6lip4jEuFbarSCGjTbACmUVg/IHO65kQRIzC110Vjo8eZr
         bgpPoX7HdJYcryB6YBvgIGgJXipUx9Qrrex9PEbevq/1f/u+S9+UpKidEcIjRnk3Qhom
         UHyQ==
X-Gm-Message-State: AFq9FYKJclKuNDQgr/H6V6oDkFcCofiZwLWnMkCEJ+hP9VJ7M5knt4p0
	JynzROlVDINQ6X3/DWHb1dRhsl/vZxXVUGs5rUpLvDPtTMHF7bBgyhUJ
X-Gm-Gg: AYBFou2vw4p2Vt9HMb5C8+3P/QhnWOgCKdNjM5NmHM79ZmTqf6vDVG0zBbr41ZJJPhP
	G7l1iB2XiJwKUxlFhRaXMdpppW5pkJUnDM1yFLsp0xxDMTbAi9ecv6dBxc73zukHiLqt8B+YoHp
	/6rPNQWwwhCsQ9WyW2XzBQaAm/9qLwUqHkmeTT1eb/EWg5AIZmdnbwaW0Ic0caMIurCDXZdN+iD
	0m0nSI5bWAc4SWlSoi4jQKroW5lvhqMpPZFovdFOFsXZ+2BEsg00ZERSz81LjM5WAMaNp1S9P2X
	CZoWmBMT3E7KrZdsio/vzSNLr8S0xdjpR+81IlSBOKDu4vFojohNDOp/qR9l7wEQZo0QS308LNN
	KSqe5IXcPHFaP49vdW4EB4dieByRhfnM4k9Lo2rw3ZzUcAKqNqoQY6Uj1Y9QpVp5TN5aX+gpl/S
	Xyt71yrMyZaSF3b2PDdAcdDPv9PnSfOFFyCmKGK7j8kMVOheR4aagJv2AhTagPDsUWMqWFUsYf/
	ntP
X-Received: by 2002:a05:6000:2313:b0:48e:b8f:f7d9 with SMTP id ffacd0b85a97d-48e0b8ff983mr3535275f8f.6.1792258271710;
        Sat, 17 Oct 2026 10:31:11 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd5008e7sm12164710f8f.43.2026.10.17.10.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 10:31:11 -0700 (PDT)
Message-ID: <d9182d0d-408b-4ba8-b3af-173ea397f0d0@gmail.com>
Date: Sat, 17 Oct 2026 19:31:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: hugetlb: add explicit page size to hugetlb_cma
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
 <fd905db7e48354ad139cc68b66fe776cd7f2dd8c.1792136742.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <fd905db7e48354ad139cc68b66fe776cd7f2dd8c.1792136742.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 79821C000A
X-Rspam-User: 
X-Stat-Signature: 3jcnytgzsmrw4kwsumjbp1tezwieosnx
X-HE-Tag: 1792258273-449344
X-HE-Meta: U2FsdGVkX1/e0CN4RFN7413dOOfY73QKRsbOWgwilUChBz703qs26KfOozdr4eA55llZjqWNQLAoNWD+r8EiKiSnwgRh/pSFVcJ7ljIrq1A8TZ+cw9iqI7RBz8PqMZMRqtJLtnmNE1d1Kp3ioELqNHR2mona1TXlPNN6Lc7BrwD9jmJBZaB+cNf0O1V3+0TI8G85CfddQ5kL4i6xn9D2a4KFSLzUdenL9IAy6ooLyWmxJ+Y925RZFl6KLDpbZJg4CAk11rWvvV8KuAHnBd/QML6w80m6r2CeoBQbFe3Ys1i46g8g1ItUzPXLhlYUbrk6h65quVMrV0MNuV6Egxiah0iDXWkp7VMZ+LBLZrnk9ojY/Jf7OOOEI/V5J9QkrrmBi0MiJO9XtE+P717IWzFrmopAxCfD3ivw/Yog1OPjflyHIHYyYEFQd9Ns+uJJPWVhTuKtBL6JB3bDqG2qxl+L7qEklV7Nl+bWMSPu5qoChhK4JCWyX2WygolUDFuChSw1LnA9u3SHb7CDrMEn8Kz18FLpszOpZvvnNn2S6Mz0jqylfXGw6ro0wPLyUiCmNy1SFOy8u9nfWE6FELcPcLCN6J8iyGDx/goRb0+bL6kHq93omfnTApi+JS8WgdlS31jhHHzpkDY8C9/SH6CV8m35+aDHxq3LJNtyoAiRS5LMiFgmZvImt/eTeQM/rw7z7Km18+QYv5PnWQRg/LK3fHRbzFJ+bwGnoGjFxP4ve0Dh5vRANDsqYzSwWhTxbUmUWAIQyi0RJRpwa4iShgBJP3Owm2X65G+PokgD3u7W5jVt/RGY7Lep+UQYJjoUIHkNwMcOaWeb7MyjQWcLj5e0vv/fIemlGbs85b0tNmAqow9qQjl3zJ3tIIQMKcE/3GxWZK82oYwEOFHlpZ8a4KIXeua56vIrlZGYLqLimxBfxb3DOVerB7LPRguPmdQmFqla8QFfUaMUzRnZN7o0DHoyTC+
 bszuAIky
 b+IRCrUZKIhv6g3O2xHszuKpP3Dhi7NYJ+Vzz1IqIqR+PO0wNLPnSsEUBNiShmzMR4W8laCZW+Gf9QWZKRs7aNn4oxAwrsV/zGbXg4etY0X41Pf5K58OvRDPDiNbmx21zqTORKO5MUk4WLiIwJzbs43IhCcO6ffWBXufcyJstVOTap4WxdAzS2nu3EJ0AGWq6VYi0tPrJ8AV1ID73tFcmKkmGFIiNao/Qqjf0RZOg4c2YPkjpNIxNfS0o+3nIyoUtoskUbFLrc7ieP3Ac91ISxnctFMAzGkzHIJhbvDIZOwyO4qFhDNq5Jg89GSfcgCLrfa4MBR/U1XBPQBeWPMSEs5+D4UwQoRty3GaVyF8GvxbFMgcJzhMQuDU06KSEEeJDp29CCJHGQJw0ZIeOaFi0WlEGsddJNcgzwyuNLK+uZiOuh0sGktn9Rn9mjZoKN36uRVm8YMgvqWt5Ll5uCe4QYubNGtwYuJOSg2PBWSdlo2WPRux4a8T5Vffwv7T0tS8jhCFxELSm6HjQI3W/eIlH4I2uQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 12:07 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Accept an optional @<page-size> suffix for hugetlb_cma. Initially accept
> only the architecture's existing CMA page size. Preserve the behavior of
> unsuffixed arguments and the existing hugepagesz/hugepages options.
> 
> Validate the suffix before applying the existing capacity, percentage and
> node-list parser.
> 
> Save the arguments during early parsing and process them at reservation
> time, after architecture-specific page-size information has been
> initialized.
> 
> Assisted-by: LLM
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

this LGTM so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

