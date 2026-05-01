Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3453CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25AA56B0093; Fri,  1 May 2026 15:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B726B0099; Fri,  1 May 2026 15:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FB0B6B009D; Fri,  1 May 2026 15:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3FD26B0093
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:41:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 865CB12020B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:41:11 +0000 (UTC)
X-FDA: 84719869542.22.A891548
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id AC0711C000E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:41:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="H/dV1+EM";
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777664469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3ohsQwunLh0oRvCQKo/XzvPj23Mypr6B13nOEceHgg=;
	b=ElSJL1FTz6e4N0NL/U8yIFqL8QQcCFGg2NpxbrIsN5XVpWcK2AqnzuRuxQnlIor9a5wAmR
	d5+tAyjG5Zp1Fz1mXbS3jxhFDmt0tOWFggNp3xd3CHaTUVR3Pm0bXqu4Pse1iuQ+ROYzDt
	IIxeTm4bPw0Z7dEeFYHdpVKdxDXFHAw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="H/dV1+EM";
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777664469; a=rsa-sha256;
	cv=none;
	b=rGv4L1ooQa8uhfD/WHAXlAPEq/ZgGGcQwZXBye66/NiQd5DESqPtgxjs9fxP72iMWiTWit
	CkFzm0nKMUUzzWrWfFxZV3fww/8VezO/3UTgeJX4haACmuRRgUm0Fo0oiIlrvebHdah47a
	l32ATVI9LEHv6uU8+B1Rybmo0P/Y0nU=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50d876329bbso18328921cf.2
        for <linux-mm@kvack.org>; Fri, 01 May 2026 12:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777664468; x=1778269268; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s3ohsQwunLh0oRvCQKo/XzvPj23Mypr6B13nOEceHgg=;
        b=H/dV1+EM63LGmxB4kT2TgS4qtGDNKmxY0A5Suobg0LSkx82te/cHaCgKJY+h7eIqu1
         q1/1X/fhLvYnSTHlb20Q4osDu8rUkFQBcQme0GLKet4SnhzkRklEfoF70ZNEvvGv9vjf
         fBjQfop2cJMLAiVyYpYuPz2YYBVKaBeipxMo57cnudKLm0rWvGTlInV44fD9VnoV5fLc
         HmRyhAblH3WxnEUcjS0G5//Jwjy6cso5nt+mNLTV0/ByJLBAboMYYJZwYWiiZnGaAvZc
         a7DQd06V3nD5IjeR5S3RuqZwRQH+cKiz08NkgsJkl6xcY8u/F3kq7iyfXYL1UTMHGe2S
         QWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777664468; x=1778269268;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s3ohsQwunLh0oRvCQKo/XzvPj23Mypr6B13nOEceHgg=;
        b=q3JyyKKXA2zjJKod7sslyep6s8oAFgg9T4YqtaiyN2NzHqGNML4Pe5OQsxix5J+p1t
         gXhhYTBDzjxtxemNOehAcRUnGI7tGoEbhSfNHBCXf/AomLy1JWMSaLqqM2Qh3cLovLvV
         yZLfOo0VyGxQxCLFddBnBWrMaVXIvxyxADyjefV6fUdhm9dfuAE99iB6fE5n7mSmgVZJ
         zhXzoxvIVoPGG5s7R89xu8tJtI/n2ci2exvn4IwueOhSTmsuq3i4soa1njpvVGVtgEai
         zxwzaiNnNEt35tgKYWKLaas9jGh9TxMT777UmvY3UmAB6liw18cp2MirPvsXTYr2wlo5
         Nxow==
X-Forwarded-Encrypted: i=1; AFNElJ8323lKUn+s+QaASfILfIjHPaIMuu2VZM7h5rAWCGoDK4UXw9wY+7mujpx1ZYKhTNIBzAjHvQVfpw==@kvack.org
X-Gm-Message-State: AOJu0YyZ0+BBs9ILwDyj42cL8b9ubDoEtcTu+ci0SvSYvROgXET9Lm+V
	Xv4H5YiaoLbSQC/r8sT433Jz5ZNGY/tf9GZVcDGEguxeklHqXVbrh6hKvkaBz1pXGtU=
X-Gm-Gg: AeBDieuoogArPmCh/BbeslQc+44zHu/WVLVt7MaWbfqTpFAjmcJ+b/8NfJLutUM99v1
	WYSr6jO2dk4qD1PDsh/adu/IqtplQ1MaO4IEcZ3C5KHUMRDTizW1TGisX3UuQRIehHe9J3/N69l
	RmyC/4jVgL6FKztTwFXkznGMASHTvyljhN5UgpWhWdIT4TL7pWA4W1J2Y3N65p+7+iycijMQBxx
	dotgms4qDXkFWJVxLnPNFINhjhGWSIieEOr+uL5kSVBET9i8G9viSmP0HZDx/fPtIv770Pquebr
	0E8n9vJAgyzfjgjsv0j+iqI5EUQ1oaVQIbXGIs7B+RvQipyDQs4vnx73fobNIdrq4zaARkMiRWR
	M+54HvQyzkVd5Miv6Hv2NHzx46FKrqkmp2gdI+87u30/NOXFFdIc7tC/d28O7zQz5dCfSY2ws/t
	gd480OZ8REFzP9piFu2QZzGJtwHZ7Qg0hBGMBAHKxqDaEB4d37e1BvnoXLqE2s7A==
X-Received: by 2002:a05:622a:a15:b0:50d:ab9d:33bc with SMTP id d75a77b69052e-5104bdf30camr10097081cf.8.1777664463815;
        Fri, 01 May 2026 12:41:03 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040b8174csm25964391cf.25.2026.05.01.12.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 12:41:03 -0700 (PDT)
Date: Fri, 1 May 2026 19:41:02 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Carlier <devnexen@gmail.com>
Cc: akpm@linux-foundation.org, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memfd_luo: document preservation of file seals
Message-ID: <afUBwC3oPTHdI84y@plex>
References: <20260423125648.152113-1-devnexen@gmail.com>
 <20260423125648.152113-2-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423125648.152113-2-devnexen@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC0711C000E
X-Stat-Signature: ctxdtp7hb7hmr79wh9fi39go7xj3kcsj
X-HE-Tag: 1777664469-403496
X-HE-Meta: U2FsdGVkX1/OA0qVbOLuZ0Tka8DRDIe1OjjN3OkeamxBobphoJdNf2zBIg0Sq0HQXalazRTB/lYmB5SMym4hBc/U+pJi0aSX2FuI3BEOa9kDYcoGZV/aYVVDCAeB/dK/qcC+Z3PsrAf/ibuoKHpoIAPP4YVz+dQkmr2Yn/2R8kLrDVW/qXSBFrFZytUZ6C35uBqo47STtJ9hfcdR8GJtxAYmj9QLW1iFKiJZ5Lw+QIirdpWcAZfARamsjRnqtsZSOBReGq19czmET3qaAQ/skxQSEnmltTcgxgF2vL98r8RbPRXh//WrNJAQS2PL3j/C73McvTuix2B3m7cqHX8SiZ2ECUZx3+zX1F4qE6etJfErGxSF8xwl3dQByKum21y8NOtrpomk2tPw7YQzkVzE5Jkkro/2HInXFxg7tTV3XNRgIpBE559DZzd5TLeHyRObRkBNS7cmhsy47hdpTFlhTgs9B74zC5oOfvGESOPIOuoVxjkgxboDRWrpMBtBI4LT77cWjZfylcG4ifZipHGomW7a2xPtqtctvUx3mVtgaK4P0JAqukaZgXuHdTrcJYP7UGRbaDU5Usy0YvHbSpWu31T6tR0u/XuxrnBztlsM/f3kTL5JyMfGBVrEg9mZRAVbhdv79JZknjSeVD6clVFwHyztzcJR0jWpPx9zHZ3Rgg32H0eDMPZsJqajQgrvSVN6IWZ579V7JFsVWHNt08/x1D6KRYMNhlNCDLK0w4dOI8CrNMhhJm6RxYgCnSHsoiWNR8HYmiuW++wyuvtmE3C8mu1cSe/LwQPWcH7wCH0raW9iahHII3dA3axiOPsiHmgxaZ2o9XRKXsiKW0dmQu1mLiPF7SVG7krb6VS0AKEvmR/ezYMhKMIGBEnPCo2WFCo/0x+0kG4gb6wNsbzYUXSjPtOyd+cdi0BjbExnhKMfeFs3nzfXgwU47iY9VTiiL9nXqOsbf+z4y36ipRVzisH
 wyu8h+lg
 g4dGyEdS2c38hRxtqwM8ofgjReV7MrTmZMGzz/ONwfC9wFULiLJChAePZsQ6QwqPmJRNgK1iTHeBo8jfJmfBJkHy7UKJu/iGXMEYg6OGU9u6Hou2RW6shCbAEuXetFtlHUg0dbw1LoojZKb5sYZeK3nOzfmvaxaRlPX6vjNXPNZqlFKvZ0WkKnFPzCLkR/3VWioTCzTqxZudQu8LaswiygzZAV1mmLUDtUzaoHKm/HigX5llK/xHg6kPnEO2SBZyOLythRvwMMa7qUBWNhpIiTTXneLk3ma+78Tu44eVEDac1k8PUiHh8ePRtWpLm5qXxAWb9+p0QOfZxiZ/09mEqRCRPIlAgPqJ301seFQ7zCMFLYDY5sQBvu9zYNPOw7EHi8og2kBdd8LMaYMv5YvyFEC7LD5nmk3W5/EwruBK7omei3QDmFLvW7cTqGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-23 13:56, David Carlier wrote:
> Commit 8a552d68a86e ("mm: memfd_luo: preserve file seals") started
> preserving file seals across live update and restoring them via
> memfd_add_seals() on retrieve, but the DOC header was not updated and
> still listed seals under "Non-Preserved Properties" as being unsealed
> on restore.
> 
> Move the Seals entry to the "Preserved Properties" section and describe
> the actual behavior, including the MEMFD_LUO_ALL_SEALS restriction that
> both preserve and retrieve enforce.
> 
> Fixes: 8a552d68a86e ("mm: memfd_luo: preserve file seals")
> Signed-off-by: David Carlier <devnexen@gmail.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

