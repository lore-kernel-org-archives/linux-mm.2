Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45353D74951
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 05:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A993E6B008C; Fri, 19 Dec 2025 00:31:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59D76B0093; Fri, 19 Dec 2025 00:31:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F436B0095; Fri, 19 Dec 2025 00:31:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81C146B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:31:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 143CA89AF9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:31:52 +0000 (UTC)
X-FDA: 84235098864.02.B4BD4AA
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 33E701A000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:31:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gWk+I8cH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766122310; a=rsa-sha256;
	cv=none;
	b=eHHu1nWUfMAwtkbiVWaNwd8oqnC1L9YBfoF9mEcNPfK5SuGSjJ+c05qjm9uvaBzkHFN/df
	pckH+O/qCimBUy7CvsIFA9rpzn5+5JvaIPZqXsNRICenMnSV2jLDq16w2kEZuq2J4jsQ6U
	OFLkVwLyGFmu3MhBXlbgeD3XqUzxuWQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gWk+I8cH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766122310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ef5bAYbggpdzWATBS3DDgxGeWDdxgRcOfg5E28YFmKQ=;
	b=Eae0Hq8PYVijXxmvOlD5ifC18RmqT0zpmW6p2JTAQ68pFEwVbAvXkQlnUPo3esjJHkhB0P
	pFoaoZRavquUsibn2iarPc4hEatHczViT1WNpediv330Xy9uDg4rfIphS4yUWxlUQNweFD
	disRmw5/0rv58lVzs1vFb7fkkhNUbN8=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a102494058so12424485ad.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766122309; x=1766727109; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ef5bAYbggpdzWATBS3DDgxGeWDdxgRcOfg5E28YFmKQ=;
        b=gWk+I8cHWvcBgMD5qiCrnEzwdYiFgXV4JntYnqImux+rASgHwCtFFr69P7DyFmMiov
         GA0Jax8ntBYHcfor52CmKFTgwpUGBEtbWA0W28DNwgE4bzfOo8Yg9zB1MpahTpyu4qmB
         mEkFcN8sdayKOjTUmgg/enavYTvaE70RPrMcZn5NFvojZN+LuN9XfwYtBh3cwi0WcJ6G
         6Nljoo+mHcwmz/f5qku2n0pfB8bp4V3fs0GY8Yk6ycTGMUmx+5XPXCah8C9LJCH15kIq
         k+pS5ZkY509dpUBYJqEkjYjZ1BDlWKJa6MmMEXY3yPjBGxdDgiiv3ZdVaA8MyO3LcBd3
         EQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766122309; x=1766727109;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ef5bAYbggpdzWATBS3DDgxGeWDdxgRcOfg5E28YFmKQ=;
        b=feTgv6wLFSucRg806qEOESmbJ+Owh0qZ64O61Eop4wj7k0HyeSFiTD7y51pGVleXBN
         gcKYqeNe9aV32GbYpGE+IcDzKxnifTTYh137a+Wnh5UNzqxVt5GUE2uIBzQx9q1WcX2i
         KHOvap1ZrG08hCNzVsrk/HfreK2/a0zZPqnUF6nQhyWJdH00yYe4u/Kp4YAhfPMKWeLb
         bv66H8SpbsqdeIW2TBm2n6xTACZblVUpt8A+DvjGy9hsxrAlnwoGFEsQLlX2/2kJpEq1
         lRtIJmgZn/QmQ2Xma9dhcJA/XUfWYUSZpcXNBqTq1GCkJKZf9MS8mp9OxMoKiPhGOHXW
         PMRg==
X-Forwarded-Encrypted: i=1; AJvYcCXGEdTvlk2k4bGSdyhh/0FM6VmydYG7uLLECsxlacKiZV2lrp/ZhoWrnUvkViaILL50+RNp+rXekw==@kvack.org
X-Gm-Message-State: AOJu0YyY2PrB/0YkgBr1kugdrYVt5H8jMjKObqdcYovveJUGTsA6gvJ0
	6UW2EadeD8ZFkHrFMNuPrPrduCEc6Jy3HkrOlXqGDnPx0RXFNU92UdFA
X-Gm-Gg: AY/fxX4d1xhYmROXBD7/8URRKzhQR6lpU5cZ3IwKu7lrj7udIyqAcf9rRLMsyFgqosm
	TpUWwR/YbLeSsyCCGKIb1wghU3dCYjMWPDoNDvJyguphDyLGcsBRHU1estSd6ZFnqBGujSdFm4v
	PCfIqGJ6LfjSfNLAdU7xOmkOufPSp/FqbqqetJD91nQBqXyLiS1SDif+qR+ecfqtYA1jqVb2c6S
	ZdhKJ0WCWjfgfum81oPQZKYMvwY/rN/AjkSWazmMVmOJXIiEB6+AX4S33Nlq56OrtNJQOikEwWb
	sVTm+XJI9scJnStFgDZYoV/gMoI3937aI+XBxmumfZFMNL6mTLSrEqDoiHeORWu5NXod6HG5IF/
	7lwjGPwzS7opWVrvDfKpYQlzIrAuCjaefdKK+SMALfuPOsEarMcukA+nytj8Pf7ZhUjHYFVhGMa
	tdckZtI4vrkraDK078A49GovIv
X-Google-Smtp-Source: AGHT+IFJf2JrcQCGZRuHEdNRmHrOXC3ablG2D12Jis9aK9v/UB8uj2aXqDz+hbbpjVgz+70W4bT2fQ==
X-Received: by 2002:a17:902:f70d:b0:2a0:fb1c:144e with SMTP id d9443c01a7336-2a2caab67afmr59688475ad.7.1766122308985;
        Thu, 18 Dec 2025 21:31:48 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a19d8sm1033784b3a.42.2025.12.18.21.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 21:31:48 -0800 (PST)
Date: Fri, 19 Dec 2025 13:31:23 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 4/4] mm: khugepaged: set to next mm direct when mm has
 MMF_DISABLE_THP_COMPLETELY
Message-ID: <x52lkv3oltbaydzgoafl2rzxka6enio2nbdvv4cqy4iv4tpwkk@tmp7iydvfbdt>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-5-yanglincheng@kylinos.cn>
 <11025f1c-88d3-41a9-8290-21a9565e9bc3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11025f1c-88d3-41a9-8290-21a9565e9bc3@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 33E701A000C
X-Rspamd-Server: rspam10
X-Stat-Signature: k9qe5u61ron15h1inic4byjyz9g5wkao
X-HE-Tag: 1766122309-579741
X-HE-Meta: U2FsdGVkX1/fOb4qYoHsSgPW0HuIFkA7KA9Zm9fI1AiutxnAD0pUJePNhW6/YXqUYiZVoBRZhQ79eit0NUsWwahVv1DDXrAL/aSOciKkr2ic4wuEId8QyFg+rGd7xfCCUkPRSMOHvGUIPAdIYFJe5huBGXxOjCajJnHkXSFXhYwc8Vjalt1H7xtC7fOaoDuT5CWbgX49tBlK8oW8lp8AE7wyBsaFMIDi3CfnpUgFQJQLk3hevn7mdkdR+RBnHrnSf1yeFMst1CMpytLKdqGoSxCEmQ9qM+JeI8+6K6v9IeNlYnjjcv5VrpeXr5L8ItqicNbUAM4p+0JlqlUcw3rxyynRQAeQyXx5z3PVi5rSDHopVatOO4EntO2LoIS8Yg5LtbvEN6SGHZT+lMMhxZC4ot6BZdnUw/NMlJg1E8cMxmCCavzadHKQ034IXZKyvvfA1kvPDv4HjxYr/VvqKI5fWLzGx4gjEtBupF88TqWKXynBiYkK6u7ATqNHXMZrjUiGoRE7ZgKWYlVdxdosVufsEluGPUzc70ycnDE0m1MLJuY7BBxoBKo+F+FnLU5PnFyyo5YxILc2lVoVk/n8kXTThSmozaeEQ6Z7dyo4q90aPcjXjysINW28fIcQx3xoUTahzgVlFkOWdS0f+/rl4Kuo/I5BTGOTFxT0tp8r3DX5qJVytdG8knGGi9fuhjyoFJGSI0Ogf2ck6y+YkNouyel9vwmUFzw0L+16UIdZ6tKqCoFUda4mAooJqwsObfo8HGfy55c+eapGKkk3DQbxmBOV4nDf+VPdIH9coKk8dPXtli3vl35yeaAh2vSoBVAuAwR+NZXVMEIn3lzQQrSNF+gLhQRW3fwWoiPUlcxfYVH9I0k+oUDraGP/4XUMlwysvoFWT6Q2mZshT2NgL3HjQRIlGgcnCps10jxzhidvPVI2ccxy9lopCKxAxXMLYKz9jMrgFcHC1OE4hzdxhEfmu1n
 pMSBg4oq
 p9E6qtqDFngceO8jI6dphjV/psV/pIiqK+EEOcJHbjYf2X64I2l7FttjnBfmfbly2rX+yPOpurWVNCWiNKuf3sfkYBtYGhHAzYS3PTIXin+Uq0BKo2BH5xR9MfmQRIndkNy4b1vysvjPqr7xAAMRzlg25Q7nSjgF5m/IN7UxggbHz6AHK/etQrywbtHjrFZxVW8hfCyiaiynK1wf5F6X85k71HMPQWirvsZdG8UdtlkBervDJuTev5n6y86VXu57TdQpStqmBtMwctpnT7zOl+GsJxRfnS4bRKhA1FwyrE/1L8UAK/LH09BISu+8Gonif5KG7KkElA5wpKyAiW8VoHf7Z8/1BQWJs7IzYTjIND2B2CAzM2Cm/pTzKPMS4bcJW6nOGMB0z4mDuyOj5hfSPCUsrIxAlNhqi2iusGVTerRrPne2SvA3LCQgJ3HfLiUcW8hVqAu2zFXbtwEQO3jzj8CQIKqzSGcHzsRrZ1S+Ut4dcTLQtnWLLz9Bk77zj+haaca8PRabvsesRaafzn6E89DZAbew3CEIyDZN9SWbuAJDewB/w/mWbc9u4lyrWRf6lkxSR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 10:33:16AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/15/25 10:04, Vernon Yang wrote:
> > When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> > scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> > reduce redundant operation.
>
> That conceptually makes sense to me. How much does that safe in practice? Do
> you have some performance numbers for processes with rather large number of
> VMAs?

I also only came to this possibility through theoretical analysis and
haven't did any separate performance tests for this patch now.

If you have anything you'd like to test, please let me know, and I can
test the performance benefits.

> --
> Cheers
>
> David

--
Thanks,
Vernon

