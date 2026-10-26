Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF87606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pXorOy6U
Received: by kanga.kvack.org (Postfix)
	id EF6C46B05B0; Mon, 26 Oct 2026 04:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7AB6B05B1; Mon, 26 Oct 2026 04:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97326B05B2; Mon, 26 Oct 2026 04:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B99206B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:55:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6ED6C067F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:55:28 +0000 (UTC)
X-FDA: 85364168736.06.9D8EC6B
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id C420740002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:55:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pXorOy6U;
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793004926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uWmG7opjqY1CLT2aRtMPjlXwAFlsI+vF8Hp0fkUZZI=;
	b=Hqrn09opV7rXq9FNktJ8MqvmypcySEXBo0VmdiYV7zHNgwZ+lMK1IGAuaNO4N0UEAYW2q2
	xo2EhohQj7tUTYMgIWj6VYxnhYiEdOAhdhvHOvk57dX/HfCsPm3wwybpZUYw/yJYgvN3Fe
	nTfgjZVZ3Fm4SVBssYFjC2bPe9QMxKo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pXorOy6U;
	spf=pass (imf12.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793004926;
	b=ARknkmtftAeJ2p1IkyaVjydDbhTtxNrsxpmHuNaO+8fDeUE8B3KSc+J5gyhVdqfvnmBcPi
	af/cUSHEkNNVQaWABXZMJ832dGoJ1NZQ82TQZaPwwAW21Xf+GRhGlSetjwlb3CZ2TWKoFF
	V9zlr/WeGt1UCq1Xld1BU73ptaobvSg=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48dee593f18so2004865f8f.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793004925; x=1793609725; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7uWmG7opjqY1CLT2aRtMPjlXwAFlsI+vF8Hp0fkUZZI=;
        b=pXorOy6UfTmxG0uQGyzFxME5rqiM7RPrxc5LNpZJKUlJIvbwo6zZkPzVgvniaJSOJx
         oXE4gPHsWRFDctfVgD/r0zyNvtRajsnDoUInlMDmm8cZPeyqEoKc0BJ1gQA5VteJ89Df
         W41ok7v2wHaC127r5nZtlXeLWSogIGfZqebWrsOTsRjvIqlMWZlGA3AXoRpHUG8mcH/X
         wZTVuF5gsMPoZ9k1K+XkgQTe4U5P48JtrsGYTIQlWNDIeeSBaW5aJamCriJPXq9yX5hS
         FYryfSYQu7Bt+qGqrnH2ZNDt90sCyz7PR7I0Uw9yNuLy9Hq8BlZXdkaidvLINBbpBvo0
         +KZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793004925; x=1793609725;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7uWmG7opjqY1CLT2aRtMPjlXwAFlsI+vF8Hp0fkUZZI=;
        b=T65GuHFg/Jw63NXeXgg/XFC4cvM4Y/tAL3jeCe6X+rKKNxg54+zCs6twvYosikjWVs
         ByPybsbu8a5A7CilolQuCiZSJRw6MlwuQDKNzlQSnf1jzKJZxKfCWvdCwxHgmL+SgrBK
         z8bOk+fDt0ZdD3HZKiGQviuA0+CSjuY7frNu7SK3t4boafyTOtZWCBT2MmOj9vwaoNSv
         Kqmx+ximS0+SU+2RrQOHKcR4Lgze5EdRAg9AWqllx0THu+KJeqYWtSXqbJP5w2ayfWel
         BcPsA63azdr4IApdkFk0YxIquzDr8jpurt5g1WxmbOUJ5YbRHqCH+pwr2CfUdmdwD5Xt
         GULg==
X-Gm-Message-State: AFq9FYIPJyAMCsx1I+DI8uWQn218KeST2UYHGxfzRKvA7Knh3oXdMDXm
	nRY5OVxB4XziqAnSzGnmIgWEzBd6Xc/b3XXRrUlx+mm39VM4rFq3JphO
X-Gm-Gg: AYBFou3Oux/brbLgfIbWo1TgE2ErEId6jLTHdjhDUuKmAvpeSWKR0MhBaBP+F7TT614
	kmLpBy1fTxi58dJQUuQMQEXq+QKEzB7yC3nEwAePmPfbpjap6AX7HTPA2cKY1V0a39aMIC/K0DR
	OvT/XnZa3061tlF8xHvhrebZ9hoCviQzfXetPR8nIwnK8hzdq0uIUWbRF8hoRlivjHK+X/2oDao
	0m6IHu+6JGjwBcq0j5K4WLX/QAmuy5PpWIu6IWA9ARBHX19WlpGjYI7hmS+ikjtfCWJUpItwjpz
	ipHsMoGxCsbcglwhP4rCdo4dn2lqG7GEmN39U3eO88zoaNOCo4yIXjp8SN88YKw/5HHjDVwiwxb
	1uBiqdE9Iopd6xlLsuHo1awzfCPi5Fsv83HGz6VPJzh88IXNUuupC7o3hlYwtqzM8iXLREkGAPy
	qP8kO34zY1K+YZGdH9KylbU4rX1hPDefFIDvMcmZ6Qu4blBR6LgIhr06ovY7gx8E7xSmwn1Muxm
	AO6/D5U0MOuGDVV6KvJNYXr7dT+wl7inx9C+uIvlLej3NDFgzJAjGh8WgGhtNi+WD8XRKe5
X-Received: by 2002:a05:6000:4908:b0:48d:cb76:548f with SMTP id ffacd0b85a97d-48e3eb92448mr11162750f8f.38.1793004925077;
        Mon, 26 Oct 2026 01:55:25 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd37f4sm17884912f8f.44.2026.10.26.01.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 01:55:24 -0700 (PDT)
Message-ID: <f2dfd241-a664-46b7-881d-13c3b974b557@gmail.com>
Date: Mon, 26 Oct 2026 09:55:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
To: Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C420740002
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4htenkhtcuod3oyh5i394wsiah3jccxr
X-HE-Tag: 1793004926-790847
X-HE-Meta: U2FsdGVkX19UKefFmYtHBliz+Q/Z/wYOhWNuQFDzQue4b5pFmshMXJf8onvtl5nZWZ+nlnADgusyuyJCbhUdSxs2d/eS46fgwcFHubSarDc2v1803RQyPKiW5oFk6kthxWk92LPFMJIC6VosdQxogQmKqniDYONNJIsxrm/Q2mwFkypGI6S6oYBpaBrJw9PjNJF3MGJaU0tcTKSRW7UG63ct5e/3wr37TWf1W1XxbYwHCqKqLN6WIahKyJdVoHYyjnGKgVXDNx2CUu+HNs2NxsZ4cMkW/hSXbZ3TzZ3C+c9vD2HEgEVZ4/HeTmScONmCBajdCi2jsA+14UnsRyLxNNQvkTrB8TiwAuvj1dWYIqtyCIi7aSNfXOeIV5i2qR/cE0q9NU9L0l+GUlE/S0NX0fVDmqwN2tBgI4dhLg5x4Ld24BelnPc5LPV7O7cSxJmZX2Da5uhesVF00GbyGk4krAYYtxvD9gXxunXBjCKYZHyKHVv1UcBKWFimRyMHT23f/sW1pCrYbSkb+8Y4/o0ZOgjZtwNYNUjEXA8Q/1OO7kp9cJVn8ItmSdzgEYREAJNZpy+w412dwGGu6tBRJUh9Jn3xr5tyHeWeXhkxsuDQpZbhJdzOHxFEWukHRgNdOTDYqcQQn9FlrBZvFqYgdQftixEYkwrzLS65Gl3T8oJYi53juA0Jx6I0av08LkJxKNf/fL4X2YOSGdYrPsBDQzi3Ezuai6I8thXfm7CfYSDmVkm7FFRXQWu4XWiTjjFHZNW4ztP8+Oo6tykPcWPu9J9iWoHbcLZWsr83tpbKLMrscIuuL9E4JaRchhCktgV4HRmIBEApCIdFHTX46i2kyOZHIJTdircXnwvS72bmtP8HptfRma6qAss+C0kLfRxZR3PU+bRqCILWxgDPnj+79wEZFL/Z+49gSK9ETlECxdcHkBaNfTX5YGa9PvWHT9Sm42izTMFaxOs8WAYI7d2E4mB
 dpCcBjKC
 KmmF9mZ+zpW9LrP0Vt9yWSWzVAW2b70r5UHdGulKf1tKwocwWQ6ihtAVTOsL9RsZt2i/NW1AC3fId98lC7ELn5smbYXqQNo4jF3QCwwYrC1zhqBCr4BwptCACKH4jcEZ4+uhOY3D1J9XtYsisffZN/JVQio00XjIrINwcVbZhR8bZ9ssaOtaatWbaPoGbdeaYFo7fr6vogWyVQ5TucdsDNGtxXLeI9l74IeKaMDAPW6ddaggO9urQeCWmgO10pcvk4OKvp2QHqMAS0T2wfozPtRadLZyu87RDntr/zk0oPkc8b1sCzWbO9TbJlOjorvFwZcDy5+06wG+s2xwQadju8tLCgfktUqvYVDZoqGT+2N2vm1wBuoYJBfwZlK13sQ1Nt6ssX+WngvKsMCLrA6IXKkrgqcJ7JrRuzg3mrZohFKFKqP7PoKB+7I6T2glt4qJeqpwLT0W8mqELRmcW70D8qGC8TrpIyOmwEtPDtuYN1m7a/YL/mkozJIwfVM8ukN7Kr71r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 3:04 AM, Zi Yan wrote:
> After disassociation, rdma_umap_fault() returns the shared zero page from
> ->fault for VMAs without VM_WRITE and VM_MAYWRITE. Such VMAs come from
> rdma_user_mmap_io() in drivers that clear VM_MAYWRITE and they are shared
> VM_PFNMAP. A page returned from ->fault is mapped as a normal page and goes
> through rmap code. Two issues:

[snip]

the code LGTM so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

