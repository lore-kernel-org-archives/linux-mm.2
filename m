Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8643D3B7D1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 17:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318A16B0006; Sat,  6 Dec 2025 12:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9126B0007; Sat,  6 Dec 2025 12:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8106B0008; Sat,  6 Dec 2025 12:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 092E86B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:27:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CBD2160603
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 17:27:35 +0000 (UTC)
X-FDA: 84189728070.18.9A10033
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8D26B20005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 17:27:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rnkpg+sN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765042053; a=rsa-sha256;
	cv=none;
	b=h3fkjrn49mRYxFJLdZBfALUFYURQSFBA1+JHRBmPVcD+iAIJyBs0OZ8LUhbn9S/GMRC0e2
	QCXN1la7V96m7uQllO7DriUrvH7SMeTElSaChZ2/x6MWNip0Y4s3FoDuM+Y6dwRe2bHYF2
	crxlnaA7qUC85vpiNxfivTsUJpRbbTI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rnkpg+sN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765042053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmQGd3zDeUvkc3bjqYOxYVmLWQzdJ41JEZjzXmjtqgA=;
	b=Rm6Pg5ZDtt5NdZMPdiPpfwLEVhl3TgWjVTF0LJLMTMUpCT06L8mb86qxAq8AHiJUN3gOXp
	yvcObKgmR9dfCi8JiAR4lnVUDX8jCow1Pzpov3p8dTZGIky9hqK4rjK800TyfDAU7dnXa+
	BIr4LxdqIEnvlN71u6nMB/1wfIsXad0=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4779cb0a33fso40582075e9.0
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 09:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765042052; x=1765646852; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qmQGd3zDeUvkc3bjqYOxYVmLWQzdJ41JEZjzXmjtqgA=;
        b=Rnkpg+sNS+29Xltvb12ULDuGw924m7af7b5xwgZ03i+6Jh6aTtGBKR46x+pwfFO0ui
         ipwn+dTdGi10AJwGAfeTpkuDaYGr/2tb62cd+jtOWAM5LRIR10iPQbh518ZOinegs4dD
         A+AI+sKiZ35SjCYVN9IRdmHDnTPFBDsJ6C1v5j2JQjk2XFpO7AsE/kEiI/RIjJG9s3jo
         3k7E/XgTPGmU85ZuK7tyHPbO2AZS4aj8Q5CA0FaV1lXdWvSDdWyMKqZvnxWAMQcok8f2
         ReK7HUPHS7m+EJOqVW3HNzTTrQGWdPAQXfz6MgVjnnwmpoVwW4QhXP1wqREzMO+Nb6/K
         7Xyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765042052; x=1765646852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qmQGd3zDeUvkc3bjqYOxYVmLWQzdJ41JEZjzXmjtqgA=;
        b=YH24k0zehHR8AZWl7cSx5IC32LYJZ2GEmtzHpgw9CenSdtJikMSmujlmGlL433UtkM
         AUtjCP0+5zverCs2AvS3OaYW/J47/Mm1O1lEb/j9OmsXrhV8Ou8z+WrowNrF/3M36nf0
         FT6nYs3FBphwSkAwmBd9q6cNAAJmnFTPJd4P2iHxlHl7zh/zC6v0I1k+ZrFIoVdDwbe9
         0B9jvh5mgogdarUcFSgP/RN8hrmtxZHD6LOtxMa80+rmktHKKnikIof1Wxy9+8+QtAN6
         O4opW7q+XmT02L89ZLQxED6bZLykBj/2AD/sEQttq9zC2AzSNJ/rvtqVXvBZEqJJ5EAz
         z1uQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNo8Dubz4pQd1QnGX+1vfu+QKoIqDuCmP/53ZbNtG58d7iTGx7i4l1PfhIJcmsY2uTzUBPA8D0tA==@kvack.org
X-Gm-Message-State: AOJu0YyI11eINH8kszAoMNjRsLmKBaF4vZslRqBPhRP+W6op2La59WSf
	5ENx4gvXKK7ClZo8/DX17+m5GOITEJRUDqqkmlOkmAQGvEW2whbISL53
X-Gm-Gg: ASbGnctwnbYwxpimYA4sfy1KW8fqCQZKnP9xW1lRXQuSYztqyiXKDbp/5/G/fHYTQwQ
	Bu8AOMSyDl+5HdLXaPNHpvyYJAMp+XnZuvTngCqqXOEiS6YH2nYFqRpMf6IvmqT92XPbAbeq27D
	6+FubXvijmeyLH7GHP9ifPZpYwbVpS7+HsIILP1Zk1jZVdd8u+te1+Sx9MHydXTG7MyAWmdSbah
	q2+lUWNFBAwE7LTaJpXYFNOsMQwQcRERr8Af1tx+iDx43ZL1NUBRjplXOTJBDkQDBTrJYYbl+YQ
	h79kYlQ0rPX2oveM95sgkBDyohjENwwuHPS8qdNNsKRemvvrwIVer2RNr50+JCQHDIDxc6d/w5M
	hBTSFuyBSa0CwrFi6lzCN3ZjzxrsCHkPMeSp5M7Muk74V3ji2dh6NPAkP6hNe5bJ0w7jO2IPAJE
	4wnrz9OU3jjzPX60h8arU02jAwP7TqKgzDIkkSjaQemIkRt6Md/WU5U8tETvf9wqMlKbKLBQIfB
	2+7VFwJ75Xr
X-Google-Smtp-Source: AGHT+IFRCRGZJPPDexdZldz97ECODKTffPkpF6pR6iCjdt4mOTDvN8wh64MBt4pDTPhFqma5Acsi9g==
X-Received: by 2002:a05:600c:4e4c:b0:471:21:554a with SMTP id 5b1f17b1804b1-47939dfa51amr28913365e9.13.1765042051767;
        Sat, 06 Dec 2025 09:27:31 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e750:1800:450:cba3:aec3:a1fd? ([2a02:6b6f:e750:1800:450:cba3:aec3:a1fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479311ece7asm145085065e9.12.2025.12.06.09.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Dec 2025 09:27:30 -0800 (PST)
Message-ID: <17002374-e135-46a5-9e4c-c317ac9823ae@gmail.com>
Date: Sat, 6 Dec 2025 17:27:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] mm: Drop fake head checks and fix a race condition
Content-Language: en-GB
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <20251205194351.1646318-8-kas@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20251205194351.1646318-8-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D26B20005
X-Stat-Signature: zdudywp1p7nhw6ntjrtbh49176ix5fpq
X-Rspam-User: 
X-HE-Tag: 1765042053-125260
X-HE-Meta: U2FsdGVkX1+ySND0N2MsYCItpnpybQdhCffWxjOCBpgMQ3gUXkLVnMEGx5vtMoiXwLYyGvdycdRDkoRzJnh6C79GUek3x/BnkREj0M/vNhhkzYUPPuq8NOSs9nXmR/IEotP7jWgXVpTNw2P17KtTTIOYlZfZ1RHdtevJel1/SCMHDh4CJrbJDJEtMbQdxSIilXfntiNNRmklN//yFiBJys2ntvdl5rgFJ67Yx4+oO/uWsOO41fcjJ6lgiui/J8lhD+7AodO25Nz9Ssf+MGyMJybW2v5omOrJRKSOnfKBbF2AwuM5Lubd/Y9r0h8d0iUHFSN3amA3q+agAHnvpavZC2yhU0wPKJwontk/l+ZZqFSeSbSbwIIZiIwMFiIEG7eyZ3MDCwGrd/HM2PSj3jjEFXb1X9SewNJjkUAKefNhgnsnmZUkdo3tc3y6zSFGnpQVZbbaf+Vv7+0/XCFVhlBSaAwuChdxR0+FGMYqS+maaLltCHQDbhGn8fnBjU2hVWERTMxUVGdjzu3ZqWFrtm5PLmh7knEr5IIszkNzs/ncU9lF6NhGkjY977kJD0HVeJDgJz82360K/SF6R1JDWADz9SwA4Hhk6cpMe2olxVM6Do3QIj9Ng91bMrUAGrQgb638g9O4K5z/S43ajhubVqmdX5b20RBv4bD1LQFGxWQOFYizQeZVQN9qUaA31hDlREMHD5T9tDrkQUuyM5CwrmwPVstIbG+aphTr9MGADH2KbwB85FaoQBr+BrxXgplm4Fzj/BsIPS7yMAMcjz8tQy9mFMFACXK/Jw9MQUg4OfVZkoQlXrYtpOr8XhhntAiEix49g1aoh4G0QKdw21m+AH/PpISoJ615xv2/5PnvL5xsLh1DoKGfVQyXIzzLgjUtpJ3aMjzbKRZkA87gORU6XnlpCTE8UQtvkWYUZaPp+1df6nAzTC2Aawvq9kKP1VY4UEe7KK/YBroBFLiMnMPvKR/
 KNnskir1
 pLwk2X2vdbyl9ftQ33Te9mpfPHEr0W3MXG/OWvkBApKHBe5geauhDOJh7COJw2mGaTy0WdoITM4qtndCZdyGU1u/roewxIpzLD50vfzvTYcBSEuP9G2U//kyrtARtbCnzNuAhWlsgkuEs+8QNQyggYvWKiLCqmcWnosULUVZsdnyvC42fKeUU1FMIatB8gaoH4TIvYgYEx+uoVSH9VuP7pdJN2WrH2QRqpw7WYSUpotjnBf3StrNVJZvND+J04PfzwXsCSTVEIrYliXEW8NDNkfVoXMOvh3UzzrZcUGtNhf6jhuwVLvwrGByinGvBUdoSEZGHjmtvVD8mb0SE8CozhDKV6YAWMlYPKwmv0nj6Lj1da4hH2FRRL50isBdmDy5NYLwDT2QvoEBaVws3RtM4MgmIvwd7aYKxrmch4y4730W0NroOFMi/qKVaqD1Xbb/nl+NZ9C4kn6JM+U8jBEM4aU6hWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/12/2025 19:43, Kiryl Shutsemau wrote:
> Fake heads are no longer in use, so checks for them should be removed.
> 
> It simplifies compound_head() and page_ref_add_unless() substantially.
> 

Would be good to mention in the commit message what the race condition is as
its there in the subject. Probably can copy some text from the cover letter.


