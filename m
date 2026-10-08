Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4911CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF15E6B0092; Thu,  8 Oct 2026 03:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2606B0096; Thu,  8 Oct 2026 03:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90886B00A2; Thu,  8 Oct 2026 03:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1C956B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:41:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34A64404B1
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:41:19 +0000 (UTC)
X-FDA: 85298663478.30.51BE56E
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 65E754000A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:41:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V/saYvQs";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of shinnkka1@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=shinnkka1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791445277;
	b=MHrZyM1vp+PeAFzPOHjl+SJsee0v53s2gET1Zo3PMKxP5qJTWJZsY3vUhE61t8My80Oz86
	VIsIL1lMUGfSxY/sOa0dEvv5m5WekhEeAh9RKyt1k5ymvsO6rfWDh4Nv1E/avQL1/oAcL1
	Utz6Nw3shtbjxv6ijvrGeQtaZhuRSio=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V/saYvQs";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of shinnkka1@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=shinnkka1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791445277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awqJUJaCqrMD3ZNJk51KVYqwLY/lICB+bok90TEZ8y0=;
	b=L0+XsFnY1OxGkHhHG5l+ebZVwY9+OcnzrEPexz6vG5/aOYO7u5tpA5duz8MaSKfyL7a4ip
	SnJfmAEct0eZ1+Ul74JkFIOy2MyNDYnjLgnrBua0tSYHJJ2wKZbt9YoDXSuJg8I8eouDR0
	AWSrTg7MSEG26qT0bM/jUkMM5Znvou4=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ddb35cf9a4so996795ad.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 00:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791445276; x=1792050076; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=awqJUJaCqrMD3ZNJk51KVYqwLY/lICB+bok90TEZ8y0=;
        b=V/saYvQskia1AzJTUd1QrmL88nf4W0vOLhLKv4nsKaPhm0fZBTNibFQMgxxLd134ae
         O9bkBmsxjSszbEWuDqorGWR4hEyAApG4Z2NIrsBTRX9YKUy1nAPeUlRHafDjcuVJU5IL
         tVt+y4T38o3HGpQFztBSbamh1OQQvR3RCJBcsDPuH0E9SpkEKpdHRPlWac0Uia/7uyq0
         t4WmutZZPiGo/kxe2zPncX+kAyU5A4BpcY4fJtPqFPofF/U8qyVyOmWm01mFg1Zt3vSw
         LVto3l2I97QYg/oshy4lU662pfEeI5prt4uxnuGIhFWSB8wZWHTUZ/qYbn03M4QcxZyJ
         4i1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791445276; x=1792050076;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=awqJUJaCqrMD3ZNJk51KVYqwLY/lICB+bok90TEZ8y0=;
        b=M2G417Z/SGEht77bV5FlR96VCRYm+OyhXHOTOt2ccq8k2n3f78vk0UidVbu4TIR47G
         onQ4RNK7XSwu/5PAbr4wWI6VI21RkPnNHdAzTVILHpv4D9n5X59igKyVTByH7DvDZWQO
         7UIXZULntpBbmiADWUV5hng9VFSu6eENPNDins7mv34Ym5QLxlFEkGzhTtMgQFSGF9xx
         tOndXhz1pSPGn/XPjWpxY4BIRD4WpbaCM+lO4dpZRuAAOuOw8ZghwKMI6xbXfBmIZo+1
         7GzB9TDV1lIjUTnRpLrUDUkjeYzJEw+dfMKaw+CJ8uAR0XIO5z5IG1mz0YJmjmdzH8aP
         Ib0A==
X-Gm-Message-State: AFq9FYKs6rKzOM5sqTeiR0m+7O0gv2rAhFMoB7vzsUfJn1yfYSoVbuLe
	XX6Y7XigHOElzZNLuqhKvhCleTF1b3nHkIPSH3pi4uK0OBs2LPJRt2ie
X-Gm-Gg: AYBFou21Mm+ervieDEOvfyBlNfH0Mr8FErxZkf6XpjvFk0AkiyVclxIqry0w9DHBl98
	PvD7hW38QsSyyKw2f2XnBW3/dR717ENYGKi2s7hX+j/JKT42pQw2MdZydydEDmzJFK7DfxPRCIZ
	zNPsVMNanp13aIOofPkerkgE/Tch0I0DEtiYC+UT/6tcJYy3OEM7V0FYlGv/NQ17hGvNuTeN89F
	MRa/z2BtFcpw+YWp4p+29wWWnOMEGSXxNapzUf6tqS9D5qEpQHEgVNtG5vKDbYbrCCwYUf92A7k
	f4rUp/27fD2p9W+ez12RTnU5s8EAFaMiUotMtveZtnULL1y1+61aEw7f+5ktkoh6jcE19UxmTPD
	bpC0W0MoM4RuUe7K0XoM6ZNdOAxDfXAvyIPn3TSUtpcWk124b+WF17Whyv7DmtyR91qE2XvYQUB
	9AhQJ37rtkcasKY/QrPGS4MKrdxngZhmlDKBOt6zNvItw6Rj/CGnEVUzIY0FkeW4SlGSn0DluM
X-Received: by 2002:a17:903:244f:b0:2e2:d09f:d772 with SMTP id d9443c01a7336-2e7f4b3054amr24019215ad.0.1791445276129;
        Thu, 08 Oct 2026 00:41:16 -0700 (PDT)
Received: from [10.141.37.220] ([138.199.21.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046feacdsm20589545ad.18.2026.10.08.00.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 00:41:15 -0700 (PDT)
Message-ID: <5048a2c0-8e55-429f-bb1e-4b888a728579@gmail.com>
Date: Thu, 8 Oct 2026 15:41:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: Free any excess xarray nodes in clear_inode()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Rik van Riel <riel@surriel.com>, Zi Yan <ziy@nvidia.com>,
 Jinjiang Tu <tujinjiang@huawei.com>, Dave Jones <davej@codemonkey.org.uk>,
 stable@vger.kernel.org
References: <20260623192850.1595958-1-willy@infradead.org>
Content-Language: en-US
From: shinka <shinnkka1@gmail.com>
In-Reply-To: <20260623192850.1595958-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6pojrkgdx1fgipqp9h7yjt5y3smhfyo9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 65E754000A
X-HE-Tag: 1791445277-156223
X-HE-Meta: U2FsdGVkX1/eRp0KGLI71ZOF++QanCrh186VC1A8E+F85sSWiED/W3CeVS/Rr9iEYidFBKLFbxPBJCJRDP+SCP8UMRDmX2sf/gdr/b+Losi4s8Hy7ygqFQfip8mU/tWGrtLi9ZH8jcYuzLJMQRstvIVLjTGN3IQQNMiYEFljEkb+uQIyytEi/6niA0zpJBq42guYi7fPqC0Z3kt7YSwVguMoN5sWetZnucPXVPi6uUNDSSoCstV58Q8oB/lCx0YYwfvEBSESeho0ospu/XSeiHkDJxvPT/JuBlP7BXrY1Fuq8oIyRa4fctr5z47g8+1BsMB3P6aM+kE0XjzjFHM84OX24TOC5IgvqCZC+7zXEsFBYwB4L+gEh/MjpkhSKRXyf6y0rpezTOxMLZgP2kLHKmcpsuxVVFL9nfyazt/F2geYYlYN6QPmxnSivffIZgeKe9gCO6lW1hVL3AEx7WmVzasVv7NoAmdFq977t9XULGQcFUsa+kv01oMEkWkqALQGKHaw2FgAj1wETI0XrdsO4tcYcGMybqwn0GSeiXJUMsNV4wWvnI/9n202x/47BmGc273Gav2i+AkEazw+4zQQRAJfBOqsh2qAZqP1HZAprOJCv/sJBdY/Ip/CZE2RihII48r4c6VtfUx6qD/mgxUBThk2I7sfGsD/FZcd+r9bmPduLHig+0LfcDRauga01OvYuMBaR5z9D+QJF8bdWydCiZltYieRobwuNUPGgesh/eDq5cAnezFb2/SLFlIauLXughX4pfGF/waD30RS3e3RNIva4BFBNEr0mrKWPNOKkPZTiB5h4lkvyjTjUGjVwccGp07DLydgxF1V91mbTn1jKS8tLRAG4Th4Qpjl9dP1nphkcESWMkykNq7imjzlSwirgIUGRYPkmceEXonQ1SdER6+fKin0yfy8aX0zlHdPG7rbHZlv2myGTngFeintfDNLOyoIGAsxyMDN2IyGkTM
 QdQ3EfPM
 6bxYBuKImOqG/PtwQ81gB0CcoXElPHoU1I97fls9xqu9PqIxsgZ5qmjVXuWK5Jw8CIEBMnzUPBpqawiAGc3Yp7Doqg2eV8CiJ8vinXFWnNmsM9rka8KV/CkEDGqiOjqn/daB8tycDxBbjMHdsrCzSGZKzfmda07guFSTavGnKBh76vficusf1/H8MhLgK8deSW2mjAlZhlqwJAu8HCHxn6iesGadICEPNCIkl9mYgxGyTjOYYfu6mcnZuXRWvHPpYCI7q7h9XQaRTa3HyP2mTF5tLrqMfhvlWrvwVp4AuhitbETMqcbA/PNFx51vQh9F7EnWYIefH/Cq3+RqbbFF5cKj1NMfsx7BuBkuKOL++0jS4Fsw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> For many years we've had a hard to hit leak of xarray nodes.  Hugh
> documented it well in commit 786b31121a2c.  Recently people and
> syzbot have found ways to force it to happen with madvise.  Rather
> than fix the leaks where they happen, just call xa_destroy() which
> has the side-effect of cycling the i_pages lock.

Could this commit be considered for backporting to the supported stable
kernels?

Commit: ee3f01125010 ("fs: Free any excess xarray nodes in clear_inode()")

The xarray node leak fixed by this commit is present in older stable
kernels, and this fix should address the issue there as well.

Thanks,

Chen


