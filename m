Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA67CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF3F8E0003; Fri, 29 Aug 2025 19:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6948E0001; Fri, 29 Aug 2025 19:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913CC8E0003; Fri, 29 Aug 2025 19:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80A7F8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:10:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D8E185A55
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:10:24 +0000 (UTC)
X-FDA: 83831340768.21.C317AEC
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 831CF1C0006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:10:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JOXnySR2;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756509022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLGuuVLvC0FYe6vAnZmrTVaRCP6gublbfzak+XpRncI=;
	b=VLpLkzMcsd/LLy6DgZ/tBsowBGmR4bnV+up9IYTReMzTsqDJp9oAetpEhhp90FzubiR6Rh
	RCGVRO9Z+2jgPZlXQjg9AnxmapBrG8Gh30xJDHp3EL5FtXTNHFJSvkzwNYPT/OvG8xFmT9
	NLAt91S2YGwkf9JDr7UFbDbeYkMedSE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JOXnySR2;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756509022; a=rsa-sha256;
	cv=none;
	b=DaE47qMS0e67fcDrQ5rziOTnxM2op2OCk5/h6b7dhrfCTmNLewaYzZESVuHFHl/E+3i4Op
	nJkx0OARh6/wuLSTmQvDSTccl12qVc69zkeFHIeYVXdKSxccq/zFAnNlPy5A32T2QW2rXW
	HOIXEDo/GaQwFaf56mww60kPpNDLHuw=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b4c72e4f1b6so1230146a12.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756509021; x=1757113821; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MLGuuVLvC0FYe6vAnZmrTVaRCP6gublbfzak+XpRncI=;
        b=JOXnySR2Ikm6sWGNwQ077WCnSovVKRs8tewg2hsgHn2Q0LyoN/MGDYih8+uZ2mcGFp
         eqr9IWENBLsyxtsdAUL/6ugWD/X2lAszuyTadZyYBMQusgI6m4jfU825LD7iEIwwHAah
         UnIFMkH56Z/p0OdvYt5dlJeapbO/L3S1lLcoltNMjUzcm7zrSiiMHjSpOI9frM9njosW
         CLGKb22GS50+RMVk7nGYhrM1IBaetQ0SV33bheHD5fT4lNZsSvRJl5nwXdBF0npNIadA
         NmaBdcMrYJNCcPqBl8YwnqKCkjsQfRG0Q7ns6oc1FsRS35DtSAuYglQy1oAxLAAu3qoj
         Amlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756509021; x=1757113821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLGuuVLvC0FYe6vAnZmrTVaRCP6gublbfzak+XpRncI=;
        b=Kcrjht1Mra1pCtV5pHoIpzXTgoSJddIzFSua2I/MrEhWYJDdsunyVHzu7Iv0YNzkI3
         OvWEAbfhxpppuAoZH6cryHLwDZrnrrv84W0aY7yyhSWJluixqqNxWercUD+b3XhY6QPV
         SLCjO0F1SQJubm5jW6g3BY/4hIKV0aE+uLDDBkJx0sEnCa+sk/WjT09qXeK8BMVx5Qpz
         Ne/29PXmWgbuUwtj3lbYiBptMrv2lBvu/RqqrgNc8chkO4ZroJmhRaXuhArL3VUPnYLN
         xORKpbtEoaX+PTVLi5Po8/DFZaNEO69An/2mZVGSZJbd30OLrvf7UKLKb1AdOI+Nxo4t
         cKjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwZUDaLeiZZxSQ5TszFiYX2WWnkZkKaJr/wBvUS6iZxn0STWSsL/dV/g3mVOhEvPO9iYWGaFhHMg==@kvack.org
X-Gm-Message-State: AOJu0YzZZL0n7P14AxjrhSaNJo+Mtkf2MGqtvO0momaRPVOc9nqFg3yE
	wXfhQNHTL867O6vghXOYP6QSRLANz+2N4vwwAQeZAEa4jdAvKDOOrf2T
X-Gm-Gg: ASbGncv+M+sH5qZ63TmwLia8oHGTZswyAMsL0KFFfyzvRpRnzu39mnE4iRFmBNWradR
	ztoQ4Uj2Naqw+FNzKwgaBw/KpaNWrobwhNTXqp6bc/RQWgkw4M3b3Uu1GuK0xleytbIupMYCL1f
	KjdCcDE0UJoI/nUturPRdZBoWpXSPkhK12dUomeMW3l6wB1N/+tFAItSWpJcLG9Mo+guwIsRT3j
	i2Rvz6FjyJgJkUvUietkEDpGw++hXiIqf+Iymk3iquW6rx/6qc4fxV+a/E4IzeBem3Ht6pc69i0
	MK1nAmIxcjphZNXGH4rMASGVDEf34PeWpeJVunDmlmp/mE+HJWgzXhbFAfJuOOQQn6GvOJL5vLb
	DdihiGgE7v9MaLCZsGBCqYsalpfuSQwuGTCbrO6GYSd2Xa5zkkOsHNQ==
X-Google-Smtp-Source: AGHT+IHQ7aGyKXT9USKBNqZpOtpxttgC5amNcPf5s75dLoJAaPCgE8cRDcRM97Ojq2iQCa0/7J2Tlg==
X-Received: by 2002:a17:902:ce89:b0:246:80ef:8808 with SMTP id d9443c01a7336-2493ee07085mr12422855ad.3.1756509021264;
        Fri, 29 Aug 2025 16:10:21 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249065b73f1sm34684345ad.133.2025.08.29.16.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:10:20 -0700 (PDT)
Date: Fri, 29 Aug 2025 16:10:17 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 06/12] mm/util: add `const` to several pointer parameters
Message-ID: <aLIzWR5IQr7D3wBa@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-7-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-7-max.kellermann@ionos.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 831CF1C0006
X-Stat-Signature: 438uqnj8bcdpsnskmx8fa3djhhj9amk7
X-Rspam-User: 
X-HE-Tag: 1756509022-100875
X-HE-Meta: U2FsdGVkX1+ygD2tx3EqPuuCopyDzgOXNUr+RI+kbpOUuq5qtOl16nHbQUdfnBh+9oG/JVWxM9zKxfQi1vFUy82CD3TC32w5kRg0ESAoaKih+fQRgBlGcpJcK3saJBhUsTAGknuppU+83vX+a7Ssio5cxDNniwuKcHLbOfItYhxH7VH5jq4Jvl2VlZmhQD+mG9ENIbQQTL181UE+IEk/ZLticzIbD2tUjtrBZVX4yS2FGBfnEak6y+Fa3O0WVWQHmYUVDeUhlCRuq0C52K+An1BAJN3jOogTTB87c4c/ouFYNsHqdZaWbK/eDQYaMkYW63aysrEssHuVS2UjwtDQU8k2taLceNk9XyiERskGB8GyTIPvZ0azKcLkD8+qIk1Clc1xhfD0ahFGFSnFHhA7nJ/yhrS2hSlj1QJnkvfsbAOd9LM8GWeK30+MtuJzeTyYK4f7m2sfhSi6pq5Zb+vja7ysth/VwgGo7mVWit1oYJOt1JCwiFxPnyNBuCI1xPeKwacdo1EISOGP/CVp1kSpDMAXtKuwv/uRMIA9tvDC39KlOeIFoPHPFiiftAzAufFjrzekl7yMBip+v3TOx6IMnEQpwFyE14vTded5mij4rs14C8ZsaOrRoJgCaNXqetBam06EhWwE0OOBluIC4ImHHEeYhwp3wSRp+EeNlE8ACaMMbRG/Y2eUKBb4Mf395T/3h40GTMmLYfCanAKc/MfalnStfjrdflJpYHqwM0XULk8Kj55P4UnE2m0dlxMbmX71gcnEHPWj5rtzthYF8mIYqOeBiiqrD8KiiqXWE98lslBfjWpkbt7F9wKwKaESktfR7V3J9yRHUXjcMSJ9SSFGf33pZIlkN+4DdrHFD6Z4zVR6HwBRlWGBdpXTxMjICJ7eH75c5ipAuecejpOGBZNNF79prjW85/tcwuiUE/CurlxjN8WBJeCB7MMmS0hNORnSvf1Yy9AnA8SVNKLvGlV
 pRdQF5ht
 s0H6EJ66Fg1A/zQOSBZcykkDTFtN+NUbI2W1R4wCndEontOlsC2nG9wGkidipXj4Z8Rc3Q+leeAXG2cd7QeVD35I7y94ENaWuR3JLgzzZIRXluyo1CSQ6HGLKZi032KQWgPjkJWMBEG/RL/Q9OHYIBFfqxlx1L65ceWn4xj8Gl4uaqbbsfcoRvIq/1ce2ET+Ezf6pBrDWMLhHgTCEOBm97W70I5xyhDqBsdsqHu9zaPU91hR+ohBYBTKFwjVi5jQ7EffIKjCuwEgOBcZtpMK9WyNw+XtWwMmcvGg3mXZzp2UWqs/4SdTqtUf6uV/dZC6YVeBCC0/r6UdBzzhCw4NH60jAAvbaW3+4nasQBI1q7Fw5EUP4GlkN53lrk23IkRj53qA3RNGe7L+/wMNxf29CgsCCJ3a+TuvEcVZgq5i1t/iFWjLatRd2rhCLrf7lIQ7x25fd3p7FnqX/rzwtRwjP39J4H0R+gc5EQFg4VVJQNZV7JXOFsNPHObR8BVkveSo+9cRfv2jYFx+0siBhGN6A0ot5NkEK7hy0jQnUz3Km6lZYwGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:31:53PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -549,7 +549,7 @@ static inline void filemap_nr_thps_dec(struct address_space *mapping)
>  #endif
>  }
>  
> -struct address_space *folio_mapping(struct folio *);
> +struct address_space *folio_mapping(const struct folio *);

Can we make this (const struct folio *folio) like below. Its more
readable imo.

With or without that change, feel free to add:
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

> +struct address_space *folio_mapping(const struct folio *folio)
>  {
>  	struct address_space *mapping;
>  

