Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19365CD13DF
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 14:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749788E0013; Wed, 12 Nov 2025 09:54:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7203F8E0011; Wed, 12 Nov 2025 09:54:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636968E0013; Wed, 12 Nov 2025 09:54:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7AB8E0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:54:33 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0270BC0534
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:54:32 +0000 (UTC)
X-FDA: 84102251226.24.F4ECE05
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 27A28140007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:54:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YvdtGNn1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762959271; a=rsa-sha256;
	cv=none;
	b=a5f86vCIOLH/22joH0SudFXh0r1EdZobwBiaohzx5wagQHqVyH2S7KDoeiq5jerrslGXd7
	aAw634ndsBb/vimfTL4sv3bSI8Om2yWgkTLgHqWsTzRBut9G5woPfK6MxWo+o31fvzfCVl
	NtnMYA5C9DtAw4IYR7e031ng5Z0H6L8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YvdtGNn1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762959271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Es4V2hOvKRdpsw6YS8mXJmboFpSdQNT35YFD/0aY9uo=;
	b=okQIMhK9k0vygFLUj9Qe6Fi22WNGYZ/V3BszPTd3aRtV3md87FDaOQvhb+xBLsCV4ECSH8
	al0Wi2uPMugPTAIoo0x1UuACQLLWYDrnqsIWY3q/kkiRsBVyupb2B8XqRXf1J3vfm8kGBq
	Ck3q45QzqZDzgkZMi6YVrnAPxAAI33o=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-787df0d729dso9911557b3.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762959270; x=1763564070; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Es4V2hOvKRdpsw6YS8mXJmboFpSdQNT35YFD/0aY9uo=;
        b=YvdtGNn1irpaVT2m6htgigFQ1BTDfP8Fw4BcwOe/LzLDCCN+6Wx9BaQ555PS8IGohc
         MBrdj5ExLUhzp2IEkHFsi3H2VEpJXIZ0a9rgpTosMbMgHyQBQIjrSkB3FjumT6/ZwVDE
         QDGLASevZ3V0flF3goya+AHdo53iNYmxybQu2644JY1K8pmrXqstZuuNVw2ua4uM5JfR
         dAU2YE+Jj/PxA/SFYAm1myNOzZkO0GclXaNegkYMTHeTyi3cv8hiZdZ6OqlOCQdcsgjh
         eJIeVAjhmTuYYSlniIOXDVhUR5clb6ymOqfK5i7wBkv/QjnA08UzWn38rzBZuDwJ4URU
         ONcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762959270; x=1763564070;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Es4V2hOvKRdpsw6YS8mXJmboFpSdQNT35YFD/0aY9uo=;
        b=lRgzTtWg7IqpgJfY0V0hCcDhIpj+ZDrc+5dhBFXgicixMPy85QmaM/fPX2VL18m/Tr
         5Zb971yS/BSdkw9cudni7V14hmojum6aIjzGS88IC3Q26aVnU7UquUNqWs15fjAGSl0M
         CmS2J8DphbBjUCOLX9Zk5RzPnfAnPfx3YxzzD+b+iHfZrHP3a8tZoozU2A/ctXlbZYMY
         YMK1rblnPYviQxCrnEObjyob2zG3CXGCaOyfY8GwPnbarTrmmEKbWGUMQrM76BY+93IJ
         ksfkZ+0J3STOFe3C6Jd46Cbqs1rrl0n87f+vHNwoP1DwMTtMqNTSNlOonbNEoZzLptr1
         gG/g==
X-Forwarded-Encrypted: i=1; AJvYcCU6UZab8U3RJGmVQwy7+YB8liZkT698ZyWGYNrt3zUfpIsBm8rFCZ11qVqxoztD3pVtdzlUNoEtqA==@kvack.org
X-Gm-Message-State: AOJu0YxD06rXW8yz6NR7inI7VjyPzsR1wZFDOic0iZ6Wu9jkbm+Cix1V
	HBL+tSMmpwXtIcIGotcs0rDNjNEW5AaOOb9zehwX2KQIJtaj/wKQ46+9UYLCMg6EuDzPV6rhaO3
	6LmPHa+T3OIK9uO/pobqAtDnw8qLowLU=
X-Gm-Gg: ASbGncs/3nkDFxqRNh4hK1BpCWFp/9a1FuEoUzkJO/3KNRnpps70CBFPAPG/g/t2iXW
	N3/vTenecGEzmmpT6RM6Uwi2q+g6w1WTg2XmCnsDX5gcz2C6eyXglFbzqeyt6gkAUPshKXGk3cx
	rVdrum4c9xD29vYYcNw1Om+h7szTZ8oaLstjIni+yDDtw0x580rYh247MUfwygzu6/oSi7TS+jY
	LvIgpa58MgvmbGd+F//1xzoBDwAZt6wFpdaWC3mBBuZKYs+vtPUcyZ/Ouofd5quEXNvLh6CHLPf
	k72AgcgFPUC3RP5zew==
X-Google-Smtp-Source: AGHT+IGi+EK7jmVM3fBQOR5lG3p0ZTX5BLAC4TwPf9ia+SY4+ie0fgyFcvb1NjwLS80NIvosDD5TOEpY9arGzvvmcpA=
X-Received: by 2002:a05:690c:d93:b0:787:fec5:7072 with SMTP id
 00721157ae682-788136e4a20mr24513187b3.57.1762959270077; Wed, 12 Nov 2025
 06:54:30 -0800 (PST)
MIME-Version: 1.0
References: <20251112031631.2315651-1-kartikey406@gmail.com>
 <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com> <aRRPvn4DYAhuGtq3@localhost.localdomain>
 <6a63dbb8-58f7-4511-8090-18a58c3206d8@kernel.org> <aRR2AV7_R20i4qi8@localhost.localdomain>
 <CADhLXY6keq6+0NY_=xiugguHNFGpFGc07ePWbiTTFU3qO534rg@mail.gmail.com>
In-Reply-To: <CADhLXY6keq6+0NY_=xiugguHNFGpFGc07ePWbiTTFU3qO534rg@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 12 Nov 2025 20:24:18 +0530
X-Gm-Features: AWmQ_bn-PDgYdvD5rofMqW1rSZWchWejM-yP2xGtKnv7KqOlVNyGvEzFiahTHr4
Message-ID: <CADhLXY5Hr-w07b+8Ji-ByfC1WbmAd+2UQHHWqdAEVeYr=FTrBQ@mail.gmail.com>
Subject: Re: [PATCH] mm/memfd: clear hugetlb pages on allocation
To: Oscar Salvador <osalvador@suse.de>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 27A28140007
X-Rspamd-Server: rspam07
X-Stat-Signature: f5squ4y9mgezqz4sy4u9b4nsfyiydxpa
X-Rspam-User: 
X-HE-Tag: 1762959271-432550
X-HE-Meta: U2FsdGVkX18LKPJ76MT3TU1GfHpBBQG+EE+RG0p4uEbT9G5iHWvN43ReCnYuqAxw0TnjMJVOeALx9LGalF2xP6NPk0N70GjrubbzCKUcktn27QhfVv08FwqB6uP65E3tFHjGQWZ+SsoCee9dJmz2j4DgyfgXSormz5xGoVdFmY3F5lWkdr+2FKDAMO2JllPyzvieZ8qG+slBl4wKzAwUE+ebvJoi/h5wP5Y5kyIJiP03gazk4TjeR91L8o4Sepo4reWzg62F5bgV68QrE0ZnEaYgEPLCBccV72zjyk0Fqo9AXZ6ENmRHPn8JIoVCX5WXvjDKoiylzVXHO5PhHw82S/xZw1276c2j0SZvCyu4XZMwwluemYrho4QTV2ckHNgmW1HNkYknQ9wYsIRAWCglW20RAkMy272vYwwSN3OSkLQGH0f1pBwD+eMOEgR8xFVo/K3WKP52R2f4twrNBYb78rgyORnudjnNYanUQ0eihiMrnjA/aOs2tUQ/sKVXy22kJpS+6BpPk2bnnpx7TFEHekDjNGorPHfGEHUhVvWM1jOXI4CtiMm3OFIH9GSbC7R9eLbKajA9kWYPjOAdIthDD8lCt+RodU3VaF6wcrcqHS6ksfz7+WqrbTI5Cq3kyJIiBrViCIHaGfyj41ZjR9KuUwrMKR736GuWpG9T6gfNSmNGay3o6zyGixO0TeORD9ZmCu/VTRMkL44Y/8i+sIUG4O+COnkr0zPIE+bUa/g+KpPRNE9TlJ2DraZrONo7ct/iLSTawbyAFtv1PoDtG3NwQhtBAYG9I7qEVTvwI2RunCz/1JFPMc0wmn8wB1+kCCknjXGW4klogD2m28y/7ARY0HgfK7tS+Xh3WCKH9QwO+YQtFZQW0bRdZVJasvplQ0BGgnnMMPpqFxOPXNs24DI6sOz+RAtZu/Ru+5tc2mqc3SCth3gnCtejYnnoQZpbV9rCntV8P2tDiVVPW2G9UgD
 EvQTGK0Z
 xWGul7eAVrg70+ybMkoox7mnXbUHxkhnrm7iARUHlRZc0CVuduVEtch1PLRgcHud3gAhu7GVZ3vln18wI9pD64/yPls/A6Cj1p5uZE21CCY6EqiiY34Efc3UGAVL/XBWUcFQRksO7H6QGiVxZffq5G/uc1iSAfGKzO610RtE+V7YiLX47uAjboZa53xHWEMB6hXvs3nScwqU+3EYBJmbQkHtrM2Mf+qkEcJMYExrexS/HqxS6NJpMBc8Ujg36MfWuOsbwvp6Hxzc/+prJMXpXngYUJeRAa/942/o/a/gvXhLV0BYEHidIWWmLFev88UKWOZbOyjteU+VskWNSuYDRSiS/xPc3aVdg8LqG6rtAoV+euQna2a60AMnhfeYoe/usiDO+1RrGlmGdk/Ix7rxKrrsLKCv3k6hwv+835msql5RCrBESX4AG5kue8praTPWxkWtdXMlociQYP+I2S7jvAdeFMBTy1DcMljVGr0G2rq8dKd72EUjtsdJ58tEhPBpztavfJ8Jd3WDWked5Io6V2Wg/4Me0pNeA5EwRIRe443k9TUI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v2 sent: https://lore.kernel.org/all/20251112145034.2320452-1-kartikey406@gmail.com/T/

Changes in v2: -
 - Used folio_zero_user() as suggested by Oscar and David -
 - Added folio_mark_uptodate() -
 - Added proper hugetlb_fault_mutex locking

Thanks for the reviews!

