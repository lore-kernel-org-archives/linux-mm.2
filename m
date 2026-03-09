Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED701FCA16A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 17:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2958B6B0005; Mon,  9 Mar 2026 13:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A396B0089; Mon,  9 Mar 2026 13:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176176B008A; Mon,  9 Mar 2026 13:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07A4A6B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:54:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FEF71402CF
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:54:26 +0000 (UTC)
X-FDA: 84527274132.29.4E2AFD8
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id B686DC000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:54:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lOWDr/v9";
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773078864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lfgX4em38pbhc6TYJlG7GYrzpl0a5OWL9SJYa4uhDY=;
	b=rAnWn6O0mSm0KSW6ZOeSPPVQV8Pc+0DYrZy5fZWU0I7/hA21ACrIZ9YbButqAHqjX7jl5b
	hBBuB7v2KR+CbbQA2ocvib79JRasegEUer+FBXd7r2HPNHTB+tdml+IXE12NInvZl5ZAr6
	seuXiWYf/XDU+Bl+uVr/m60TyCiRl44=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lOWDr/v9";
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773078864; a=rsa-sha256;
	cv=none;
	b=BuECruBNfue1yRraRLiT/56EOok/Y+P40XTGaCq1IuweEdl9MEOwtdM/FqmBKyzqSPZQLL
	TnKcofCB4PubkPX8SpWtAB1EdA1cwcgbW3WXuL2tBPBR7lOsPw52AzPSsIm6wBNlW7S+7K
	mcqDBKxnes9oBldpEKrSWgF/Fe1L2is=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cd847b4b23so156405585a.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 10:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773078864; x=1773683664; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9lfgX4em38pbhc6TYJlG7GYrzpl0a5OWL9SJYa4uhDY=;
        b=lOWDr/v9XeKCi7R//UmRYUJ+6IZsHJVkeUAIwJ3ZDYSvgN0gTurjrrDv+LCFC8vN6D
         17kkMw/fLiAEwfY8N8ngEgF3Op9cLfX0jm/2i8G/ufVsblke/DMEENOriNmJDV425VEf
         eCjE4qm7dCBQAwZD0fW1J9LIpTQcUQaJ6nGzk8D2bPHT9dp86KGwA+YXWAur74vzjZf0
         miYVEtnq4sqSY92G9RodQuLamu+Fqgk28VJb08QFosj+L81Z31l1WaiN9Njt38nnqOq2
         Ah6FTFb2sGCm7/5IKrhoW9XS6DPIVDbpjWfh54+RzMnA3VBESU/q91Yh/xNwi9+gLo2K
         YsSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773078864; x=1773683664;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9lfgX4em38pbhc6TYJlG7GYrzpl0a5OWL9SJYa4uhDY=;
        b=Onhe4g92RX0tYfIITiM/XjYMWmx2ffT7UDbb9Smsvcjcj/X5X8+faXnec05WdGQVqX
         7jW6ExdbpjmqoZbksF4Sg7GPqeMP7tnlh8T4IbzwKlg9VbjMEywkcCgDy6/ezlUMmFRf
         hfmaS0BWY3mKdVUsUdGHO+eWlgf1hDxgcb9qV4N38JqmjAFJct+px+rSF92A6IgMMOEi
         r8IlptopANKcdGYeFjqju5qfHTapmRpvumzj2hu4IaYJRb2w8T7hHMFjs9w8dGy0YVpr
         ZrF+RnnHeQDWhIjToN7ErgtoP0KVeWzZeXkYNSTQMyGf+Cfn1sv/JIJUw5GB0VDlp0xr
         vqTg==
X-Forwarded-Encrypted: i=1; AJvYcCWIgDOTcUkYIeB/qPy3ElIyAjfvyS1/qzaWeVVGfDXZvZ3ZD3b7x5Zm45CJCGR+8M6GK3kRK6CHlw==@kvack.org
X-Gm-Message-State: AOJu0Yzmd/OBGjF5BGEfDZKp8Sb0G2qlDeKN2CKCDpkFRWspc+BZUlpw
	2bpKCOycBt7136raBe700Zto4Cekg7bqoNFXU6B1ZiXke3vFLIzqq2Nj0hWrk7ATApo=
X-Gm-Gg: ATEYQzwEndIrpYXGKONSLlIjvpA7NGeT/EtLPj4gjWRpQUZvkca7ouNKHTz6TbKS0sG
	u9kywZhSDEqKv6DBpFC7ZIoCt6Ql1TdieoWdnR0Ay0UMaN/Ux1yOE9eRgja6lm1ILY3PitoE+Ex
	g7NPzFlq+S01r74y7l/jVEFSJyBNBrcQOyxT6UxM6m81LH6tB0yWBf6i8HywDnwRM54bN4KcFNN
	kDV7A9OaIyyBlh1l/vd6RkBzCKbnI0Ou19jEOH+w2sQaNm303GFmjV3WB6EtnMuvCpwMisogUUn
	AOiBeUtyZg5E4xkajcrwoWbJtEZULAQBlMCn8EoofSaqUConRBoYn0G6WZb5hU+E1mnhWI7GQWc
	+z8AA4aH3Ylizqy8OP3Aal6kFb+XE0uj/QjX+X+1zYnDKCSQLLqkJdoqkB3FwfXUW8N19UAYSxK
	5wLknXlyMs5dAqNJNacQuxU4f3rlBAxMBssi9jzbApXmus8HkckfRqorrnQ9b04L8XgW3DQHAzV
	nm0ZPpdAA==
X-Received: by 2002:a05:620a:700a:b0:8b2:ea5a:4149 with SMTP id af79cd13be357-8cd6d4d544bmr1554684285a.65.1773078863734;
        Mon, 09 Mar 2026 10:54:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd6f4878bbsm718502285a.4.2026.03.09.10.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 10:54:23 -0700 (PDT)
Date: Mon, 9 Mar 2026 13:54:20 -0400
From: Gregory Price <gourry@gourry.net>
To: Shivank Garg <shivankg@amd.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
	vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
	weixugc@google.com, dan.j.williams@intel.com, rientjes@google.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com,
	hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com,
	riel@surriel.com, shakeel.butt@linux.dev, stalexan@redhat.com,
	tj@kernel.org, nifan.cxl@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mike Day <michael.day@amd.com>
Subject: Re: [RFC PATCH v4 4/6] mm/migrate: add copy offload registration
 infrastructure
Message-ID: <aa8JTMda9oafjzcf@gourry-fedora-PF4VCD3F>
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-12-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309120725.308854-12-shivankg@amd.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B686DC000B
X-Stat-Signature: g38c9qt1kf6chyb1dwznes7cab776ffp
X-Rspam-User: 
X-HE-Tag: 1773078864-988576
X-HE-Meta: U2FsdGVkX18oOkZep5FI1xLtXYneuadVondpHhcLlQaXhvlBIa6HywPh6eqzN4q9GTFkenpfYKne3/GBzaCqvmKPcMZLR2+cax1LsifhUoXRFQ+coplbx6/6TkHiasdvGzyd32UuoRZdmQ4+5/tCDMzybIWDPoMywmdDxTcjatH69bZGK884b37JUZJnvdUr15LohNtqGNa0qpnzKp2NHaGZ6S6gNC6tW4u3hOQkPdA5E9pt7kpZYGBrVMYLJsI2woP0Ww/x/n38SBUY6UwwueTiBkA+tVnExMO6wrrPXdnyOdgAdmN7DJP9PQwRqr9E85z+664Jp9KGdDlxcfOxdIgoNMc1iTyA8AeFYhoyd8tlaSfIg/Umy15zccgllZ4wJc+KSGJwldyOaWEu9RD5DOJKgkz5NetHCXf9b93vUSnAKOwnpdTxfC3lXHQAoYjs8xlb79+SapA3cXRemRADdOiZnkbw3Lmc+usyIeOLbYtIctrZP1jiVV7aDQFRsStbbQ0EkuLEiqDF30pZ0WSbYrM1Usa2o7vykyAFbUT6W8QqLIZ1YNmcrwe2MgGEw1R3g+xVrvi4RoxYgZ+0ub4zHBhZfx3LK1AfmkJSwwaKKC+nScP7AlKUdhz0h1cTRPiO7/fJQ52KgxkAm4qYUEH2yBU+f6ugCirzNAbOKBs8vilzwiy+XRKKApB/Zj36YUcCHPg3LoAIsQoPlv8vt0x6JlKDpLt+S9Z6a5nmZYXOUirThwQPDuFp1dyac0v/VR4IfuwdSAYbz7nxbut0Win7BpUmBKyf6iDAghQTfyWBXQSCQOvaPUvArad1+8VYvpxBmWTvXR6tCQ6CBN1bFBSZTb2deikTSuBQ5tquMNzXcwPK4+NJMSgEBzNscOdgzfiG386z5g+nPizHO4PB3VRgixjZ/smT4jrdedsfUIZ+hEcRcuA5u8psKCMQCRrsUCU4sMkx7RtTQagfxkuj8gR
 0D8rx8Fu
 gMettfTB7+G/u0oHIjlpXP47aNlr2F2VvSMjJlFNXLpqeuPPvV+vVWJ4Oq+rk7xmu0XCUP/dFvonn+NCOjxD/PyOQd3ULDJrgzzQlz5P9ULG3CJ+pqMVpcKreeqAt9vNUJxl1zioCohNNXFcpPiXvgzIWi7w8w58MCzMvd4wOmfaM3Gp0Yajv5Kp7khvzlQJ/wxifdDGnHTUiRGz+v7rTWpbH656UThO+sAvkzCoLfZIcxudqh59KHiqYv+yYHFLooeYc8UO4emvNdl059ymfm+L668kU9yRteFPa+81zZBPmgbQTKd6wuYK4a56qSg+y45CvW6pWAvwZl1Q2+qV/DNE5rlha7HUyE2H/vhzlRRKPaIpVLQGIgibAfrXdw63QguetbU3RbVSkx4hD/nNhahZjQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 12:07:29PM +0000, Shivank Garg wrote:
... snip ... 
> 
> Only one migrator can be active a time. A second registration returns
> -EBUSY, and only the active migrator can stop itself. The static_call
> dispatch is under SRCU so synchronize_srcu() in stop path guarantees
> no in-flight copy before the module reference is dropped.
> 
... snip ...

> @@ -1820,11 +1833,18 @@ static int migrate_pages_batch(struct list_head *from,
>  
> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
> +	/* Check if the offload driver wants to batch for this reason */
> +	if (static_branch_unlikely(&migrate_offload_enabled))
> +		do_batch = static_call(migrate_should_batch)(reason);
> +#endif
> +

should the migrate_should_batch call also be done under srcu?

In theory it's an incredibly small window, but there is a race window.

~Gregory

