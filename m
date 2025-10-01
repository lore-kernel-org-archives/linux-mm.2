Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED9DCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 10:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5118E0008; Wed,  1 Oct 2025 06:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC188E0002; Wed,  1 Oct 2025 06:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1B58E0008; Wed,  1 Oct 2025 06:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8EB78E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:06:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FBC25BF21
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:06:49 +0000 (UTC)
X-FDA: 83949116538.08.9AE29DF
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8DDE4C000C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:06:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CQZQoUDL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759313207; a=rsa-sha256;
	cv=none;
	b=RYuwTprNlBLTeLK8Rfs7WYpvkOUTXV+XsQujBd3YQSB7FImU8TPZtei532GWf0qqOFpJVb
	hjKy/5QisE/+rJlyNYTc4Axs+yD6ImQ3ZtzJ6cYtwIia+RNWC1MUmhH7ziNkiP0IkzFxnr
	9z1E+0paNB/oHzZZ+g/tCt5L6k1agd8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CQZQoUDL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759313207;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbDcfF/tWRYRAvRnclyW01Dt986wLv4qAlsrqnAXbAc=;
	b=1hmqXch1sjqgXfUWznv3ILe6z12v2sETbAU1Drs4jZCep9y+qeXKUvZwFh/VY/Ylk5XWYf
	/kLfJgrWv6zGYECD3AFD456OQPcYXH8gyKc6g7AvtBxND2F2RE+ISrdUkD2z/MDGe9AnKX
	W41tWvlpnm8CXYIjM/SmfHJkcWxGxgg=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-631787faf35so14033368a12.3
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 03:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759313206; x=1759918006; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EbDcfF/tWRYRAvRnclyW01Dt986wLv4qAlsrqnAXbAc=;
        b=CQZQoUDLAO/C2w3DjNRFbd9D1qqFPMoFzNDZ0p9fH1MWw4Yp1yZYIpe/bECOvHLoep
         7sMTGL9LvpufrXAs3Ow3tgtfKX24CNAxLVig9AmtNV8b1wlOz8KJXjLAAPJx8+eaQ5nG
         lzw/DLQs2/vR2RgVmg1v5IuTDolxsO5E39pBgBcoC3VS7w00UH280Rt6jBmvZMRLO6Sh
         uEWzNDJuRf5ZzlG/dblyMzv6m/t6nWSqVp1PLtaaeD0duVWI9nTlDP3cZBReYXY8wfBC
         k8ESPImTzw/ksQasf/HDweXVZdPvEl6O3+mZoylGCZgI37wvfAzEKd9CVa8Vb7iotJYH
         Ekkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759313206; x=1759918006;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EbDcfF/tWRYRAvRnclyW01Dt986wLv4qAlsrqnAXbAc=;
        b=ldVZPBK81OpiXTM787gI8I9Iftrrd82EY7Ji8sWzm07ANBjyRKcLvK3vjotN0i8Scg
         vmRQv833m2V9yihfJnzV/E7jtW2ZT2aVfuXhFf0o3S9IYlB431jpaU9J4aYl3V3bBLE2
         3xLdNt3ojB4AhvHuxjPfM4c6qBNVkEOjYz2tFMccRCaP9+h3a/oxcUWzOm/SELDHAdXM
         MVyjQKltM1+fQh7mqZ8ZtayR8eSje6uLcAEZolxzJ8iTy9Vm/ddOgm3s9yUY6gnDzd0k
         l+CJCOVJ66pzMWftArw3+Ramv8LX3NKGz5B9n2IwLnIP0M54A1Xnc8iwc6MVcDyfaiuX
         PNxQ==
X-Gm-Message-State: AOJu0YxaM5OEx61YzP0Ogv2hGrO9Ig3QNHEphNa1YbrgeyHWLQCUuLkd
	Q4AYR0rMwSTON5Yu68NmPtKU6OJ9L9KTK7ETEjvYWLAJ4i8AiVPPCviP
X-Gm-Gg: ASbGncsBtKPEiFxDZ8l6NCAcnABRYQTrLknOYqBbNtVYC4Jj/IWGrLquuOeTNwcz8e1
	AMn+czGXEVrqliQqqy6fSiN/TTfS6WqgrzR6lJERaUF0mj/NYZEKA5AaVk6DNDMP1ZWO0Qa7Mgm
	jOrtGGMpPEiW++EvA+6lY1e4T2luBSVKOUXGnYkbQUXAZZdj83N5orL5w+hJoXxLgaPow3qwNFy
	QWuepBFCbFNL2yhj/A2OOz7TrkSACQcAO/lY/lZ/XmRyKl1d2jbyCyt7K2mN9R0fn1vCFrc/64v
	HjjUz1919ODP6ldXwOhvZuz+GguRgRDbHa0A+7UBuVbtiEvwFMMt/sz+GNCGluFHv/MPEwHjLzc
	yAhjYUE3mxp5rN+GH7Mlo9Ink6DHi5aXU1oTrV2czm/RIDauALg==
X-Google-Smtp-Source: AGHT+IGrELtWLU6PTGhg3W2iwc3fKSBGaVmLRs+pgMuO0Eh+bXb/OHBCIhInrKG21q3n+g69bj+6ZQ==
X-Received: by 2002:a05:6402:280a:b0:634:ce70:7c5 with SMTP id 4fb4d7f45d1cf-63678ca6454mr3279676a12.17.1759313205885;
        Wed, 01 Oct 2025 03:06:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a3629cb2sm11304707a12.11.2025.10.01.03.06.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 03:06:45 -0700 (PDT)
Date: Wed, 1 Oct 2025 10:06:44 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/thp: Drop follow_devmap_pmd() default stub
Message-ID: <20251001100644.rkdaojjer52tcudi@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250929104643.1100421-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929104643.1100421-1-anshuman.khandual@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8DDE4C000C
X-Stat-Signature: 44ciuear9zemfpqsftgxixnwdn3mg9ck
X-Rspam-User: 
X-HE-Tag: 1759313207-257569
X-HE-Meta: U2FsdGVkX1/2P9q8WGA8CH0D029aRVBWv4Qx5VWD52NXR90GpngjRwquSBc5zxmro3KjJdmqOiEDQtsBtwtKhbuv/i4OxeOJbkXUbtQnWHlpKe9SpdSklunWEj8qqtSrYvIvgBHEIUxnTrElm1cz1U04ykw98J6s1p+PhWagvFFy5EMEhdxd1mXVBr/cb1/uxL+lpgqlR6yvFfGWkyRIe+fQTpCLB0xSHB9CKq5Y3YNiK8tS/H66cdxyuhgJGNXDamDkY82k/xVfn7m34cNRaXZ+uEVJbUX2pyAcT/z5JU6w8Gkhtdh8pE/lkeLOnofCiDLbDty6EG2/hrMybXHF8eZK3QpWmWlQGs00b8WvVxniqY/VFe6YZEBjdYql8T4rT4oHI7mV92fwPLDu5arkjC4vftqspHnvtQ/XMjVkKqULtnd1i7+hLRJFVqfXM3vTkVRJTmzuSATbUZ13VGn7rf97fOg5GdJp9P78qspJO96/xE68FkBXNb5ERP5WmULmSw7DXGQO4RbT/yiVY50eRq7u8zviiWAS0PY79BCCfwmuNiSjrVUeIqaQDKiaJwpcSqoos0OdasLzxBYpRHwjUWrYNJuKQibc61sOfeGBGMIXgO64jN2yTcHOF3oTolqWPyKq6lCIsJZNLzL7bRNES22APsP7ueJUDm9iQUcRKGrkuPt2PscR8yy/SdCgeBwYcc/Jz5R9c5QGqmErCo9LnEPvvobfkYCvGwAiFkjo60QMDWlLFbxv2qzDaB3LKF9w5NZ5S2X2dU3IsLRYzt00cz2+KpYPj6L8q4NJZQvQ0wu+Ja+fXCIQinbW7inh/yqC85cXTB1IrGQksOK050FStKjueQmG0XIGC7Mf9LkRkKIvVCQNxUD4wN5HTvIu8BcVoYeWrTmyqsNp4BACWnrsaXNtCIDHm2mtnfwypRlONHvbxrA0AmiNN7I1DhTcrT5nZonoSeLhRKtPZaa+4Ka
 OW3142o7
 3DUQLtFbqsQWFYG9bwoM8mZ6p5vVcXVMs5A6gCIhw4AQxmrUWz7dAimwdRYA/tep6aQwbgrol3zEs9ht0UbgxAsnzFHUn0C62GTVZXV+GzmgYeTA+nZ2vNWSe5LiSn8AWu0PrBEtEMel775PQ4RUOlclUn4B9O6H62FlXlPbxQB1pmp6YfCP1nandoeOz9sJPhawFK2vZBRxzmxQ0O5lzbhbcmruH3qb9qjlkfmd9/Hn28GrS0z10Mpo/SwqUUplEk9jI+mYlyIFTeTJegRXB6YIAvs6PveT8n6EmhYew7wQvNHRwH5Mh43PheJ+wTpzZZTMQG1taKEDg0S4YMN/2UH/pihIP1GUH1dmqU7L3pSyObvF2Gl6iOu0fs6PPGgh6aLWRjJjsmDWXHc0Tw4A2rJ3E9pdVfF3vy4nMgzxMfDROxt/h1fu3sDq1b2DGrJV3K35HqPQJ25Elf2vWuhq6yChl7uOtHlH0TcxZUZoLLZhbCMJSIRDW9vswWA06dIdDwA/hIrhXykumFhN9Z0s/5YKkmDDwbfHvrVjg9CITB9qVP2dBR26T2huDHS5ly9j22vuFw7bmxop8C/FQK8yiYM4sAaCaQ74D3ACtXObcTj+BqX+ycYeSoahg3p8L+rRS8KuGJF3J65E1KpmK5pGOfmqeioSJ0l8GUwdVV8x8waFvZbKX9H8k88dAE1LvrIoQCt0gxUFqRRACehtll/6z9JU40H4XTEXMqcy9BfNlR6BTeEY2OaA+B/DEv37gWwMD4TM5o2deiiHmEkCFaphP0K131HN+809g7t7ZulnGGcP4/JJGC0QB8p9+cLG/lawSmuqvQNAch4wGj/VX5Gjajw6T3wqBh2/0CseHj+uSFTJzttwj7mWeAK8HvzhDtCDYvrUAUwhkHmAuJS8aOp3LHucA+kSS9DhZW8MVVdngknzdSD3hEPci+d7k2DPDb1G8KxW2sfRF0zOHPXfhEeV6lfVaLJMb
 uglIZUux
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 11:46:43AM +0100, Anshuman Khandual wrote:
>follow_devmap_pmd() has already been dropped by the commit fd2825b0760a
>("mm/gup: remove pXX_devmap usage from get_user_pages()"). The fallback
>stub in the header which is now redundant, can be dropped off as well.
>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: David Hildenbrand <david@redhat.com>
>Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Cc: Zi Yan <ziy@nvidia.com>
>Cc: linux-mm@kvack.org
>Cc: linux-kernel@vger.kernel.org
>Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

