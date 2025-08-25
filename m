Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8377ACA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 18:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87578E0065; Mon, 25 Aug 2025 14:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F0F8E0038; Mon, 25 Aug 2025 14:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B748B8E0065; Mon, 25 Aug 2025 14:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7C928E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:56:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3207AB9B89
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:56:31 +0000 (UTC)
X-FDA: 83816185782.18.4A698AF
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5DF0480013
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:56:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ldg//LPY";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756148189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SzWvzuyxc8U4uvXldf0h89Ad3AGqK7qQxNBiVSgzwvI=;
	b=hAJU/6LWKbKoVhZ0DgfAP5l3jxTic/5crrKHBFWhfamGZc8ypNz0CGnfGJBw3He4QopYwN
	hNdA7H8PypSh3PeD+ycIRbPPaCJV5KgCkaXjpNG9MS9wdC9z2fLbnWx64hV//AE4VnZUNB
	3qhPYmDu5lMr33x1HuCen45e+2wgx/s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ldg//LPY";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756148189; a=rsa-sha256;
	cv=none;
	b=B3uoFE143ITAvNY6+1zs292Y3Yz4PRwEwhUzmmj5aC8NkRDPo4jffu9hTpYn2T3iRYKA4e
	8CN1TZ1CO4YZaQiSaqMgV1xwa3Q/rD4OM8ZHw6w74gmhjlx/s0uwFGC5/u4siyam4kducL
	FzqHgjX062Gp21tspA056zd8kIzvlis=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-246ef40cf93so9161995ad.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756148188; x=1756752988; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SzWvzuyxc8U4uvXldf0h89Ad3AGqK7qQxNBiVSgzwvI=;
        b=ldg//LPYm8Kpzm4Va4Hmr4rx1GGp7scuoxhkcBAHu+GO9cbf5jziVdrGr74F44XJQ3
         pJZ9phJo9eKU545z5kG/7uoWP57/pYTqOr+Y4OdKnYWNszn5iLiTGtqxqEesgtIa5Gnc
         cb/suIPelu+vpeQK5C1JZ2t6bKH5dB6m0ZunqFz0dGMWLdEKbUeNuW1jabJHIbUdXyJ2
         k3dXme+rwIZzS/CimVcVeRnCKZ6E+LTIQpGPV2hdqMc2zTVnimcJaTVCmpqMJz8A7L5T
         CRZNbXU7HhljFCwDU7F9lZJzhpqPJHoUDRJpaJF4oaJvpdNg7MNIimV0Yb7LrHL6h5lF
         iVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756148188; x=1756752988;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SzWvzuyxc8U4uvXldf0h89Ad3AGqK7qQxNBiVSgzwvI=;
        b=R/Kaz9zNioRkMH4gbsCN/rkYSCLn0KL6y04QQkr0avbvB7r5f6ui+roa2IraP0IoV9
         ihc7B8w6mhQi6OiG251ibKT20n5LKN/hx56Vhj3jTJIzxSM2qXjySAiE2c2hwfVUZWJD
         RENxQikIKxZPbIQW+f8WHotpVfFxDu8LEfNtrhv58ZhPxN8O3h60RRkO9u2kwKSpUgl/
         btNdCtj1dOsFtzeTkSXXhkLzXk3FCT9n/9UQIM6GMuJFz0dA48TAjDKfkjSmdhINgKtw
         cbJMadt+TpKL60oIa10LsZ+COSJUtduqCgsRMpT6CSVJSrSmMskvJOu+pNjEeDz82Ybo
         zGrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSX7Mbel9lpaqG9wAQ+aNqEHwmE/vUptDH7ouWxo9UcL+8R5ynLSmuMaktV1x5hFtEwkyAziNmtA==@kvack.org
X-Gm-Message-State: AOJu0YwCr8xAGt9stx5vAtJPZODar7UBv4sjfsLFOyH95sWI/K7K8JpC
	ZC81mPj4o/duWzG82+n45WOMD9YnfUlcms+UWnXc8Y0pawxcuTkJR1QM
X-Gm-Gg: ASbGncspkgGGoM0ntBBp/sgr/F0oXfHwv+UPZwY2Av2BarJ9zoNJ4W0QpHpo1PXES9X
	znR4D+fNtPhdHB382f/+VzeCJilgd2fAvtwXqydZHH1hgwri4JLehfWiix61dr1fGnV81W8vmF7
	YNgOymG9GM428ygz+BvMecO4CyFDr2OD3NXU9r1oPyQxLfYVkZbbxNILWXJRYrpDfnz4kkrp7IY
	d5HiqxZGr8cOr901R8+UwZ8VKRJ+k48HD0sGX8ErBsbBcpVdDOPpwxA9/RIzi66EheS2wZWWPpk
	VNty91NRNC0zszkeP3BmLN8O1Wgq2xwT0S0b61QadDxCzz01wxztZ2MwRAPZQqE/vAeCb0wbO/a
	ZvEl9V+h3b8rixrTVDRG0rYlxSOnJjXgH64Prz9Pgblzq2tW71iel3g==
X-Google-Smtp-Source: AGHT+IEG4OBcUIgVaGYScnERea4gd27KbGi+YUxvReSc5dl9I62mBwZkPUyvO27QZ1ezponnV7Zs7g==
X-Received: by 2002:a17:902:ef0f:b0:244:214f:13b7 with SMTP id d9443c01a7336-2462efb04c7mr176883845ad.53.1756148188033;
        Mon, 25 Aug 2025 11:56:28 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466877a01fsm75637175ad.16.2025.08.25.11.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 11:56:27 -0700 (PDT)
Date: Mon, 25 Aug 2025 11:56:24 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: I Viswanath <viswanathiyyappan@gmail.com>
Cc: shuah@kernel.org, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] selftests/mm: use calloc instead of malloc in
 pagemap_ioctl.c
Message-ID: <aKyx2IKTLpaxjZnV@fedora>
References: <20250825170643.63174-1-viswanathiyyappan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825170643.63174-1-viswanathiyyappan@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5DF0480013
X-Stat-Signature: qysgiaszi795u6qfxgyg95drxeko7wka
X-Rspam-User: 
X-HE-Tag: 1756148189-791429
X-HE-Meta: U2FsdGVkX1/OPm/NqoQ4CEJZUhpp5ZBTdJNr/0UXcsVKAZ2yS3qN6jRm3yJ88ySVIfw4snQbZJUudRIhACREOP89PzpaaAi5A5EYvaLI8PfVICm95ONMe+kjwEvDEwS1fA6sKdeIznFcYZqSJb8z+KkAdYeDaiTVo+ziRI1DxjJ8KPnP2e8kkIrmyWIINFWyya7MSbYd1QwFy0glkt1OTcIEMFCxhzB7XJJmOFNJqCYqsoqa/xZLzXk3sGbB2uzTUGX3TZsrM49EQ7UOFMSQfmBbvW0dkeifUlL6/4VNpSLjuiH3NN9PULRQLwy2qn+PnjVb4FVRFBKCpCV/qiqa6PYSg8bDJtqT4bi+j1iV7dKbDeIsIH4hAnznEq5S+x7lt5ehLP6dMUgwmxd4r6vvbCHQNNu2RStGmgw3296IQzW2P1COafmwGrA/1siBbl+iOpFMD22kwUeE8ynzc/wjcg0oxddIupCxoWbjyWsdgdaKoFIe6zvjh/vPRS6p9cjXccuBJJgmx4RstPC3o1avHbRkoMx/Pg3AWfGdhP1WffVlMM2Kttr8ASt13mDpXlK6zVYlzh6UWicwZN926u9MsTj1nnNSZIsIt744iWH3OTkBYPOJiVY/25diRH6P6C9Qj9ZlQ8YYQkmqzop8TplQAvWLmKXU6MjrIIpJIAhAEGy0wSUTLlETnYB6XKLcTIS+yOwZX8ZmM/9X6Qi6PvXbJ11fGKvwFcU8cUS65Nam9mAMFeFKbY7ohQQMA0GJYz0OWSP/RSchSHNIinhUJPmFyLQQ+Aj+WeIVA8ZHM4m4st7fEpt/nqlR2iYYum644ZgG9WJeCBQnu42miKhEabVrWbSmcMHaBfc0UTgMWfQdeyXPb+blZ5IFjMBe9vmZ97R+PyZvfGqkgOkTvMxWuPydX/9spuHkKrakIppUev2TmGKjW6BwYg5AB9MO7IGri40WfFaLnjS4IozSBBUAspZ
 X94wLALF
 cHC9XW7fV/KLLvJlxnU677fDB4Yy5b57I8g6YuTiPg98K7UbEP5L0VP/EiVVtLhIj2uuVT7v1IADYAFObFxg0vyn7cG8DPyFWc4h0F7uWcu69bQ7DjjtCtY4n4Cz3dW69XSKiW2OzZkLeFLw6+uiExy78ChJGKURn3SGZKsRVpNevfiN62L3tivlnzB1I3qYOHGon21iJgimz74Nq1Y0jgXsQABGb4Qb2c6Xaqncxw7lToSH5HCFTV3WcDVdvu+GyNa303PfHLBlA8r75Ua4CIX2V2nWsnCrprARZpCbHhEYz55G8msd95Ul8j4jNAHYzb4MESuH0VuxJba0D7ZCAaFFGrTP+oX4+Z8bvQCROGrN2fOlm82cHlR+GAc2jy5tzFtiUWNQ+PKC0RQZvV22jRF4IFQmkfkkBMogKDdmA7U1kU2MwdGh4qCqRglqffZ8icvgfXH6g6egKJzH8A7TyIzuXUQF/g7KW8zf1MZ6/LMmtIn2gvC0kPU3vkeS8VWYQFsPnAlluwAyUDy1z6PlCD84HONv9WWwMjRIG49Y/7tgIfPfyoDsad7tPwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:36:43PM +0530, I Viswanath wrote:
> As per Documentation/process/deprecated.rst, dynamic size calculations
> should not be performed in memory allocator arguments due to possible
> overflows.
> 
> Replaced malloc with calloc to avoid open-ended arithmetic
> and prevent possible overflows.
> 
> Signed-off-by: I Viswanath <viswanathiyyappan@gmail.com>
> ---

LGTM.

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

