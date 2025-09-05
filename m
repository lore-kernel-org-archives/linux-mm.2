Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC1ACA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377E78E000E; Fri,  5 Sep 2025 05:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34F4D8E0001; Fri,  5 Sep 2025 05:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E478E000E; Fri,  5 Sep 2025 05:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C51E8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:11:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0F0A1DEA0B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:11:24 +0000 (UTC)
X-FDA: 83854628088.19.5F8CC66
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id D30A580003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:11:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iN57ui3j;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LlGG8iiLjAgEhLCZ5aniw1KKqM9ZJMnfWAApeRI+6ec=;
	b=E6OSPA+hlpYgApsZuf4z6W2UnnzJS+C+duJvh/SW3On2SFp2qbjwoTNhFFqPhf7BRoiVz4
	S3akcLHajn9X6fcWBfShf5nxrOwmgaIA3NR2qibZtLSYseX+KGcqpFSA/i8aNYO9EPt5WU
	nCtUY3uYR8Tv/Cqfr9kt1GKxkZhKMZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063482; a=rsa-sha256;
	cv=none;
	b=U6IwRJhkTTMFO2/tAIZ8dmic25z+JkhXY3SLQvAgmrV97klaqWt4j7ayaC3JtKYEiS8ADl
	xKbQ6NX9HFZ0KzFydmBxA+VMHwMVyhsXK+UqxPM5hyK9DAEyNAh46nA6hzyjaDA3e2XHCV
	dlJVgO/P5AlAxm+DZqofmS3VCMhuxfk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iN57ui3j;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2445806e03cso25852985ad.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757063482; x=1757668282; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LlGG8iiLjAgEhLCZ5aniw1KKqM9ZJMnfWAApeRI+6ec=;
        b=iN57ui3jB8ibtxhVJhww+U7siAU1JAVs2e8Mu1I7ZjdjgYE2W3AdPlYxT9R9GhXZ8O
         M3HntPrK/82HonFJxOktrAKVCe6VDXgtE54KB7mZd1HDYi/y+ZL4s7AtLHPiCc3DpWvw
         /2zLOooq5cA0cRM8t8P6AfLTZ+WSzQXN4b8l0acf6B4pEij0kAM3M+bRaCwvOUck9wfD
         cQpptGLHn39TagIhThnOIiQvHr1l6jUK1QBPZva9+arBn4KMIpEKIAKziAaguwZ/Ax+F
         7z8x43Gjbp1Cc7/g7JyzDgfV3AeQywsGD06e1YWhv5hwID6N4YRXxjVirgM2iLNm63VQ
         Qdrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063482; x=1757668282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LlGG8iiLjAgEhLCZ5aniw1KKqM9ZJMnfWAApeRI+6ec=;
        b=AGtQpaIzKXB7PqNL2O0gv08K38EurNNxq64HZWK3VwmoQrR4ZfGoiiVnGztSLUsZDN
         lcptNF3l9IPgwsafhrrcy0OwtBCsTngHI3WKOC6lrWP4josuKT8pXRh+s3wf/3FbgAux
         xJyY2u3zQy2//zK6PSuZu4Ez5rCAY5oZgS+XZJH8m7zWvoOqJJHFCc5wd6aTojmbHavy
         /1AS+eZOyJXY3zacNNUcCeOqNxcUEW4CthiQRV5pYf1ntJEDpn44uSQ7i25V7U18g///
         aajOCPbLNfw4gpBc/+ND6R9GYLv0/wolmCkDWiOeDIu2Q2gf5gbqupG+LPviTE6zN0oI
         c4zw==
X-Forwarded-Encrypted: i=1; AJvYcCXsYztbEmCMjQvgudhXGusZLn/lzUhHlC80TkGNiZbZfus8VxtTosYwUeYWAW1cMXfodTslIcFpTQ==@kvack.org
X-Gm-Message-State: AOJu0YwoHQXozABZSvRuizF5AoWyOFI6tgtYzps/npr8l/vultBbAbi/
	s9GkwaRMheM58EiuirXtBc5JHS99tH0QDLlTL3eOrnDWynT/dP/7tdPf
X-Gm-Gg: ASbGncs0IWakifY586VC8c2UeByFTCccqWBW+5uPggGs7vtcdhwskuqFM4eHmntqA0G
	Vrt07iUMa5XWGtGKKlocTVEueJtCv5Rm/dPOpBV0WZvo2DBXBKT/QCSBEsIUa7K/Uayib1tgbJg
	C3rSbmD6YQ3IFLgHODthgg2DOW/IAzhAwYO1OJfgQ647pYm1nFuLZgZxD05ZhDQ1yEzR9RTOCmM
	iEYKSeWQZ+pWywDVqylGwiBAKJofft99HyqLKgPxtMNMaX2fr2DTWgP+eWEpB3xbBv3WU/dfkBY
	cnIRj62ODTOKwIEmiCbfLFSNoR6Ib34vnsYcSWZis9EzilFXhvM0Wuy7FiLoBUCy63GZ0LD/G/W
	uJK+XZn1ctel/rYR3Q2V2KBv1xmpXDavPMmlB093Wenks6HhvgxW6p12DWyt+SAEpKu9IEEeFju
	Xz5Q==
X-Google-Smtp-Source: AGHT+IE82S29cgshAHVDQSgk2SXvBJzbM4szgZ9lovhGnhK7RR2Eatj8DsSh0hxrXAeuoDMb6cbafg==
X-Received: by 2002:a17:903:3c45:b0:242:9be2:f67a with SMTP id d9443c01a7336-24944873f96mr300977675ad.11.1757063481583;
        Fri, 05 Sep 2025 02:11:21 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:32e7:81b8:8974:3701:d82:56ac])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2490648d67dsm209318045ad.108.2025.09.05.02.11.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 02:11:21 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: richard.weiyang@gmail.com
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	donettom@linux.ibm.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH] selftests/mm: refactore split_huge_page_test with kselftest_harness
Date: Fri,  5 Sep 2025 17:10:29 +0800
Message-Id: <20250905091029.81259-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250905032431.22179-1-richard.weiyang@gmail.com>
References: <20250905032431.22179-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D30A580003
X-Stat-Signature: xjmtdw7r16bqi391j7wp6i1zcrotzbaa
X-Rspam-User: 
X-HE-Tag: 1757063482-229023
X-HE-Meta: U2FsdGVkX1/0YWpOM/XRFA73OeqERW+VvccoTJrXxU4aScA4jp+WLHYww24umu40e7IXxkHI7L619Bv6hkP8vCg1/opcp+WliwZCe4o+EOVfua5VCN06QBoDz+OxU1zc1MI2IQnSiBounwn+/NcqlF4mZcA7vOu9fkxa4MPNefu2FSFA8NPsR7bKeUBE0MuMaKKPJjAP55oGmuATOwp0abW61qxUQk5tLhtfWyVssyjdCsk3zG8EiDO8ABnOr6bF/MXZydJ4Jk2NnYRBIaNXsF8jiBrKNijZD7ql0z7TmoGifB+pYzU6nJvdcjNs5WCcef6ezyVjKYVg44tLxmFwOWANLg/kMHzRoYAd7a6FpzbliEEmVnb1D7I4M284b5l/5AliOxkegWkvI0IdzsGTYyQ8zGksMnnUHHBv3+IKUO9Gej8GHoHZsabwov6ETPyVcmYeEZb6h7H78XsaxBaobi8sc+K2BnNJOtEKRIwCFmHIzJquhJTGtGe7fUkDgTLm3aiwgW9eQwruf7UzUU6NK89eUGTcq8eyBwJQ8PRB9T3XuE7BX5vb98Ld+iOC0lkiOSYjk7gqS/m3wLpVRpnkY+GDYCiTqqoomY8WkUe0v9fhm4Vbw6BkQLXE4LbYofvUcW9YlSuGuIwGSBVBEjTu/OyHralo5Cf/0d/AG5Jc8nNz/80GLOdNfoYGqngxvMjPtacEfLqiwsacvsKNNymeSaLeA3F9EaxhZP2YQzvUMtL3z/7nqI40+RxkN7GLJFz2SfptjrA43Oq6XCwNAhrDBtaIpzurBVrpyoRuFbiA0hgL34mf0rgs5uIyUbuFEhCKriHce5klM7o9wkL0+7rA+duDc24ugqn3v9CUm0DB1JEFcqBJ3tJ/tTdlrAUXi2UOQyXLxUZrBfh9EY8WBad4ADkMWO+DvkyaRfQhwVVxnADMctXZI0KK0UIBIgwqSPqjabKklUgi+hIe8YRbYNs
 65Kfn0JM
 EMtmHmZulN/54nEjmQcKJLKIsWl6PMkiqh0Kpg4IzwHCP/y9GbtQd0BUZN9cqyf6GsAbo5fAG9ebiFTMNQaCbe5bZG5J1fnktGTxUUaNcdUyDhj8U6iKNaK0UPhtfli2yhmSTDpC5VM3J4Qz43MgvUlPeEq2+VQzV1nqaeSgRA33Xi5O7r3m7wpciwphoT7kU6JYwHRvVAlMbC8zwkanR+AstBLqItFoB1AXDYoIpuqANcZMqnVx8tJIL/KTDUyjCM0tw50gjwz9cJLtc6oPF6BegDZNXEMAP/BcFdwaftl2Akz8pNibI1l6R9308jPpQ5GrZ5J5649+I/oFsx9N8XKAlAJzs9umTU2FWIPhXNzlqTZN9d5J9qzrvuScxr284gaNorHhujdIz/0YlVNOx3cGbyupjtZ7muror4x1bX0KTD8hQXu4tvfkO+8kknz63WLtWS6enosoWs3GSaXdRMgzhZwD+6y3voXxQMzZQHWlEjwy0gJD5s+KNvTvs+cAiqcGupC0EyRL2sD60RanxndklfDy4HY7gpV/eqM5AJafQdrJo7bJQqq2Q9pUCATfWbIuHRI+mNz5M1uY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Refactor split_huge_page_test with kselftest_harness, since there is a
> magic counting about valid tests.

> The idea is simple:

> For standalone test, put it into TEST().

> For tests iterating order/offset, define fixture and variant with
> order and offset. And skip it if order/offset is not valid.

> No functional change is expected.

Sounds good.

> -static void split_pmd_zero_pages(void)
> +TEST(split_pmd_zero_pages)
> {
>  	char *one_page;
> 	int nr_hpages = 4;
> 	size_t len = nr_hpages * pmd_pagesize;

nr_hpages and len appeared many times and 
david use nr_thps and thp_area_size rename it.
and maybe we can unify it and make it into FIXTURE and init.
 
> +	prepare_proc_fd();
> +
>  	one_page = allocate_zero_filled_hugepage(len);
>  	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
> -	ksft_test_result_pass("Split zero filled huge pages successful\n");
>  	free(one_page);
> +
> +	cleanup_proc_fd();
>  }
 


Best regards,
wang lian

