Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9F9606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=L0jrfObr
Received: by kanga.kvack.org (Postfix)
	id 150496B05B1; Mon, 23 Nov 2026 13:13:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102066B05B2; Mon, 23 Nov 2026 13:13:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31ED6B05B3; Mon, 23 Nov 2026 13:13:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D01C76B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:13:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5452D160963
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:13:44 +0000 (UTC)
X-FDA: 85467181968.11.8E0B162
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D788180014
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:13:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=L0jrfObr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795457622;
	b=OcXwbpEMnaTQANDmiVav40g2vCcz0nGrl6MGRpY3Snq5C1Sx9uFgQVHAalT7OjzekwrEfq
	OOQRMPDZD1mzTEvbgptyMTS1AXJrKokO4TniOrevC/iDrpwft2+giy31BOH4XxLaNXY8PP
	4H7uizK/0SpekQcjEOXkjbwHoTn9KGM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795457622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JF9DK5BWLD1MHzXf1P6k3Cfpg7JcJUIjQB9CILaEZzU=;
	b=djyQdstoqErNLNMYFe36IAdjpd0CcCusMavnOGpSwfPP57hH8wds/jG/acyERUiqH66UGN
	/p7GniXP27KxoEJHbw0lVingkv6qI3D7sIJRUcNQf/TdXmZ4yCFFL0G6/D+MRL+rJwHfpF
	K6fkv0vctabYksul+CJaaHmZsLKUnXk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=L0jrfObr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b6b22be970so1364688b3a.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795457621; x=1796062421; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JF9DK5BWLD1MHzXf1P6k3Cfpg7JcJUIjQB9CILaEZzU=;
        b=L0jrfObri5q8Ssn8HvtZ6n3/wvggi9AbEHjViGVqhfvuYLuYdRBIgImjullIezx5Bk
         Deoxao1LkCNd2XvL1aaFk5KtTHb8NeoFiIZc3w9M4g0G3QDOqavgsEy0FPOzKdr7gi+N
         9yvZUQiV/RvrkjtRfunVJnMmF3R3Wz0MqzI+GaiWdAuo9UaNUQAV/1zVhkQH1qndfPLm
         vstQktylT/0lUog6QvjCY7JbcC0SrFe8ptHodOlI94k5XpUvityrMMXX+2Sf8x/3QQbk
         sWr3tFt+EploIQFmrcsLKEAMJdcCfq+Jfit7aQRaxvRBRe4LSeDrREOSvDQxHf2l56Fc
         1AWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795457621; x=1796062421;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JF9DK5BWLD1MHzXf1P6k3Cfpg7JcJUIjQB9CILaEZzU=;
        b=KttX+xb2UibyN7wHxIQfPlKqlorQb2YlMVhPa/hNVJl9fzXK96XeJl0gDkghObwIAI
         QgSHoCYxO33p6b955l53HoaGiTJjb5gXQzBRRwGJWgYsyEv6i8/Obt18bLDUnlXxRGpV
         3j1k2XDgq8n+ELBGKFZofs7dbttXDXXKR2o+bV8bCt8ZqFnO/D+e1w3gwH/Tp5sWV0QE
         55BffREGQDxqt9YTE96fXmpOEbVC5hFy82MEog+i//TDkrhwskMBlb3W/1c5AVZeyHXd
         1+yyoCyVcPMwE90A2p0UWbwJZzWeefStfkgcA82Pk/JzZDGycPW6XSiCkJT9h8mVxl4U
         rphQ==
X-Forwarded-Encrypted: i=1; AL+hErGFKV0E05NP9RcTurtqfkIfIP7zUI6Z5KuS8NP6Ohm6RicX5+Z9eKpoZVovAFaK18ksAwn8FeMJWA==@kvack.org
X-Gm-Message-State: APuU4Z+j7YJl5mnbJePuPETbX05jFLQpk+Kd1uQW4O3Zyz1yKHV/tSTS
	KKN40M36zS4gGpBL7Rtvyn0TK4Ok9bjiI/EyA7f7k0eWXT9g6uF3GBn77WM5Iu9wDhcTqUtNo64
	uXpwmt7Vm
X-Gm-Gg: AZFdTZePtQKeEZyYE7pBYVYEh6oqDOVxP1tX7Gi9CuCFnUnq6ZgEtkHOdeilsgdzVYc
	EsrT3rHlBnTQ77SlJS7V57R/iKrDYOAnVXY32qt5CO+a0i+ceGjcGrdNZDVFypI3pcTataxPdsQ
	+8uzCBzn5rLrbcvgqAcJVUjOwwcdrGsugHT5ChWU7XHF0IlHN7E0CTegKBFDDUzdC7b599dhbCf
	ktFA+UNuvNMq8QGLiU7GOf1r1PNuvq/6FmWrGe68Hec3xsxfCo9/qLvDtaRtu7dFu96Kv93LVDa
	EH1Fwyvv6Eja7V6ZxLLuctaYbPflPKDw5f8vwUZe3TvJZhGYGquaebwnFvhMLIBlb1TPcnIaBvo
	ufJQgAzTcxdnr+owWzV/v5P7Iz9Ub4CX1ccHqLfCbKU0lTDM9boBcoStrVSBvFK1rG39RN+gW5q
	p0vesumS65CtcKsppw0ypjce1pUhdZPy1CSZYhn6Oa8F/JBzU3HTT1goX87koSNNmeNNPhgCa1g
	6F6zZouAJUMkYlLXBvAKNqFErFgyYdQhKiCwS+K6n0DgVRM6nDsSwS5Oy0zhlOhrf40FemfY8K4
	WZzxzUDmqzsEVhQw5aJnU5rwALYkFnlm7So6CudzV2dynt8HBjGi6N2VDPAL0EVu
X-Received: by 2002:a05:6a00:9084:b0:89e:9c7e:fd56 with SMTP id d2e1a72fcca58-8c87c768251mr11001006b3a.33.1795457620349;
        Mon, 23 Nov 2026 10:13:40 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285c263sm5956386b3a.11.2026.11.23.10.13.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 10:13:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 10:13:37 -0800
Message-Id: <DN2SLUVNO0L5.3NUHFPC0J7QTG@google.com>
Cc: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-mm@kvack.org>, "Alexander Graf" <graf@amazon.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Christian Brauner" <brauner@kernel.org>, "David Hildenbrand"
 <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport"
 <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>,
 "Shuah Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
Subject: Re: [PATCH v4 07/19] liveupdate: Add helpers to track the files
 that LUO manages
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-8-dmatlack@google.com>
 <2vxzbj7j3ga2.fsf@kernel.org>
In-Reply-To: <2vxzbj7j3ga2.fsf@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D788180014
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: h657j63x7y46xyfadxp9sex7m7c1w5x6
X-HE-Tag: 1795457622-347336
X-HE-Meta: U2FsdGVkX19fDgiJ0nAVzP7uDMZDLSlSfjc+Pm+frzgRH289apkvQRBwGWXu30hv3veVwjCElOYBvG7U2dSqcTyNyGmmoIIe4C8IVoosQsFg8Z2GHIn+tu/ho/6yQ82348E+j9M2qpLcKdYiOg3fXX52l84Cg3iubAp86GJ3inmMikI4zl6+HC2OIkyWopDIz5bGV7IlAJV8kEzkiFnsxsruiu9yQMnuPU9m+Uw1ov6IZcblMlTPwh79iBMq3OiVHTe/gRVfbY80rVsN1B+xZdcM47JMWhaXeOStL0CDDTdyMC0PodwGsowVwTAphPYy8toCrmtXn/9GVzQb5CqrKN9tsA93Qw5kJKbA1UnF3sKhPxsd7hpDYQf5ZTQN5NkAvx6rQ7nWdP0/RI65ShfzVg0zge4hv1MtP3QQBCQWG/1S5w3UsGHUeO6OJLeNYsS5FUJIOvNSkyaf//glEHyR385DNPvAI0QYjlqzeGt5nrhE+RsO7KFhXoAtq0f8HzHm/uPoWdC3fw+UvJjbXP3Fk3SyQtKotC0FSQZirs5C858VK3ZuKTgVgNeRAi/ubnX3iPcr2yHQtIBf6TuM+Us8k4qDGHTfsSyH02ZNeR4BinhYqzjAq7HLvfOSyfDMMqFd1kYLiFkc4vCKtjXzmM4/r/VYZfKo2VQ+DttkPCnPvxUY3ggO80ugB1VQC6uO1YcyypLmpkrLp3o6rDQ1AyUzwcRWg3p9oQp6cu4a4bTnqRsRCj3MFN6oFej6PqwHutZ0YonIdvwpOuX+m+Q/+avS5AiLoIsW2LXOyjnNNI76GEvJ5NrVpy5/+eO5ImXJCj6NxSUaY3/2fDBEzG+ljR5iLl5CshxnAFWWTC1qA3atiAEvbnWYu6pC+3yr8n2b1uc1ohKBYzTdH5DT2wjJ0hKM/fTorPsqop3lwMPpUwGVs4PChkkH3aWnauZxupuqTHduT+pNQ1IjRI5fyjpXaRH
 o0v3/fYK
 3UYbLgOSfHsVxBqm54UcI9+gh3txROdor7t/WiemzNpADxaVNvQhNyiq9bo+9MsZODMCjC9OD/m5NQ44JZHfsMpxINLNqrWwPTBS1WcXLJd/hQ8HDdAqCghM4LlAcePIwureoI7t20lczYWr36jtviTbca1ao9JEvnRS4wSBCTrmHUloOOS+XSCtKW5G1CpKNfIx3XFQUgp8Cs+LRJcIfMF/Hxykkr9IiFDDCwMhZ4Wb8LSIopMw00lvwhZT5IQEJM1Gp0QneF7Rywh+j6MCmpIqOQzqeyg4LR24YtkK2s0C9oUKGjyVr69/rlAhKZwfnJJ1oNobZGuHD3rJe+EoLl5vy7OoUI+yYEnb+MJfEyYh4/DSUmUctoYij++JEUGRRHfNlTjgFxPOdtx+kXM3rGaKjNNlhOEOR966pRmwKS1SzUZO9/+CwJ8w96kiKDz0k9d2o4/jOglIB7+paUCbNfhdPuiszQlfk+fEFo60rnvWwkbbAm9b/WA4rsTwPy37n3Zc2WHJs5J3Y31tdFqSdMjYHqmkh9Wlq0QyZ7X5BpygoYNsS1BZIiPrF7xoCAQsORbrg/z989yOvEeSZKx4JzXDZJx7QAEf7qpuYjGh12mS97+jgkMXwZtiodA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 20, 2026 at 3:15 AM PST, Pratyush Yadav wrote:
> On Wed, Nov 11 2026, David Matlack wrote:
>> @@ -788,8 +797,7 @@ int luo_file_finish(struct luo_file_set *file_set)
>>  		luo_file_finish_one(file_set, luo_file);
>> =20
>>  		if (luo_file->file) {
>> -			xa_erase(&luo_preserved_files,
>> -				 luo_get_id(luo_file->fh, luo_file->file));
>> +			luo_untrack_file(luo_file->fh, luo_file->file);
>
> This looks dangerous.
>
> Since the previous patch set luo_file->file when xa_insert() failed,
> this will trigger in a failed retrieve. Except, the file was never
> tracked to begin with.
>
> While I don't see anything that actually breaks because of this today,
> I think it is a bug in the making.
>
> I think the below is a bit better. Although this change probably makes
> more sense in the previous patch, since that introduced the problem.
> This patch should just replace the xa_erase() with luo_untrack_file().
>
> 	if (luo_file->file)
> 		fput(luo_file->file);
>
> 	if (luo_file->retrieve_status > 0)
> 		luo_untrack_file(luo_file->fh, luo_file->file);

Good catch, I'll fix this in the previous patch in v5.

(But luo_untrack_file() needs to be called before fput() in case the
latter drops the last reference.)

So:

	if (luo_file->retrieve_status > 0)
		luo_untrack_file(luo_file->fh, luo_file->file);

	if (luo_file->file)
		fput(luo_file->file);

