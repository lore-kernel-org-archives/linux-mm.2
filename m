Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FEBBC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 15:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148A66B007B; Wed,  5 Aug 2026 11:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FB76B008A; Wed,  5 Aug 2026 11:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00E306B0093; Wed,  5 Aug 2026 11:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7CB66B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:07:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56DA0A1F9A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:07:06 +0000 (UTC)
X-FDA: 85067543652.26.A1BD701
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 74F61A001B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:07:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qma34L0S;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785942424;
	b=FDjKS6j+fxKnw+g2zsa+SWHyDynT5TTZcjXdQa1tqW6t8AlXnt3yuXPVmJYJazwpxVoju7
	lQUwYlefUJ1ECJhnPA5QeHWM8dwewYZQF550ovy73Ia5VgkA9mQGoEpgOuJK9EPNtMu2MR
	I/afIAmYN+lk5myfSH4HSWJE1aqEE88=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qma34L0S;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785942424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/YT4MXPl1kef45GcZvhpcJYcM5/lbrRubDqqr+jOy48=;
	b=h1kqPlLMHXjABHmrdo5Kh0reg+srKDOMXLxKHVVcrnNl6/Tbzu0S+Ume3gpHEbRvFL0vWR
	7SX3zKeLJIzuF+PnDlcGvWBLrmAixjlc7ukbG889qB8ijSfhiL57fhuejP41jy1aQqaWjP
	79MFY4Ky8LyGyAU50gYSbboG8jmfTPU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4774041573;
	Wed,  5 Aug 2026 15:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A291F000E9;
	Wed,  5 Aug 2026 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785942423;
	bh=/YT4MXPl1kef45GcZvhpcJYcM5/lbrRubDqqr+jOy48=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qma34L0Sf1EbqViiEc9BpEqcYDsil75uU0natj2Wjl9KxgVL421AU/nJwuDH4araA
	 5JchMKFdZqys4t853oTkr5F2MRB1QL6QNxgtaq8rI9ggJd9sGOMvWqDu6nlij7N+7o
	 8hLg7AYxugc3gDHdCOwcSSycfZ97efGqvKpAvOuBQMT3qfKAYx6JJZJ6zdnRukvs3K
	 adorRubKFbD2oyg36emfAV6tesD9vj6B+8IWL3Bci4xKlJcerz8cJKe5wRV1f8rSIg
	 GuKf9q3xELWp8TfXwYg3lCB8wrTqbehlwBukNe3GE1PC60vIXw4m06tT033oS0a5Ec
	 z4Q8dl1lzZAjQ==
Message-ID: <00d6bdaf-aa2a-4c72-95e5-e2d0ea5131a7@kernel.org>
Date: Wed, 5 Aug 2026 17:06:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix incorrect flush address in direct page table reclaim
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, luto@kernel.org,
 linux-mm@kvack.org, luto@amacapital.net,
 Qi Zheng <zhengqi.arch@bytedance.com>, Liam Howlett
 <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
References: <20260804003708.49830-1-luto@kernel.org>
 <0adaae9e-7086-4213-811e-ba6e4181e145@kernel.org>
 <CAHk-=wiO8NDCyBYrDMpjh8zMKnzgD2XuPYo0nk4Hwgq44R_jKg@mail.gmail.com>
 <5130d601-84b4-49c5-a9f7-454d54a7412e@kernel.org>
 <CAHk-=wjDfNV9BfW0r8c7PG+hBtDothP-9OROcanTLKDtujmBfA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=wjDfNV9BfW0r8c7PG+hBtDothP-9OROcanTLKDtujmBfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 74F61A001B
X-Stat-Signature: eqt1gr6r9x9ogrggti9ugsonox1xcf8m
X-Rspam-User: 
X-HE-Tag: 1785942424-99498
X-HE-Meta: U2FsdGVkX18dfU/20qCSJLvWtkw0N10VhHhIMlyEt3jfElvc9ZN7YvyzGXQdHXcgT5ZbCTq1vFItbnckI7ojXoGtIuumkUmHYxWFEcXHFW5QjyfxBlEIxCmtep12dZUqp6wbN8wGgPJC1yV6V6qNpaJMfUUWbcQ+s8DgrdtJE6wVco4BEixm+OrGxJ6S+n42M/Y+UhTJsLSSaCJxLUpyXckncLJDbQZ/BkzDDd4wd3KCA0NbsRJsk9vamzqCqVwzoq2LvHXTcr7LUwsmx733+HxXUie+W60FbE0IRfZV6Kzr47hJcfrrFBHTq6hzBjLYDEFGHBX7rC6kYvuEuVdW072KnqnfUmO0i1YhfpBQDc761qPotspdMN2D10hwO51FQniNa5SLK4GVOoY0rtdnBqOig1lkV1lGImKdJBLSjHGnCqTf1i2Y4hj1CbhR03CdIsolE9LGMbxZ6kL6AkqZ47TrAAG7n50rOYm66G0XXz72Y8VlPLDBaI1scRkR0CYcyxFhik8QvGPEK1p14yuRDnJ93WK0T3OumC6/E6lD/WAxFDf2OoWoi0jklraCRSSoBcxfPEjp/n9xxwwexPjyQ4HY0NE3wFmnuMXL5F5+vshphr+3exreyXGnIPmoJeLKTnwvjAgRmg4HnvCd172VIDKD96Qqh3K8heKKAS4kviqKZhlvDnmXkr+ODQjRKZO+eIMseRQ7878XWwcp3uo30sBaAIScfrT2r20aOAKFGUPJ7DAFKTRycKXYJisEykzf42s9wnA/HuNtx36hPEo7XQ+sStv89iQxQV3ZRqADe4yxa6AKbh9mZT82xt2bIe3JJmEtosyKnHOOE6eUQpHy4aeRXLRBSkfPJJUg9IZeGanN4/KC+5ptp2i7ejbJvSfjAjyUaph+nxOyDBaJoGA6qcEyFHHDfCIkTB+ndeu3Omm5w4p0z45CEN4kaCUaxn64KFh9hzPqnwqKWuHsAjz
 yFzynNX8
 V+G3hxshY6tXGoIULSr9S124JZ0GXo79s4gsQK9k+lwfPpvVwTwG8FZYJwbd4JV7UdJ3m5Q+FrUiBrZh3MzkAHOOMvPpiRRIf+BRPz+q6uGj3s//upKFHZYxk75NH9DmrPy/ZwzV/XkHiavtS16rRMIorISZaTBCcULPr/qIWdwWwI1sBYt00qk2ITt+W/Omyf+ilFQkp3gIVoiPBNN23/rQGWpN2s3WxZ21wKh+XPwHgZjV2IyczDZlKjGnz47MPYOZOVBkAQOy6uKxCQj0nu3Hwxsr6+XspEvIaoZlSFu5z3lUHifihFqmO8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 17:02, Linus Torvalds wrote:
> On Tue, 4 Aug 2026 at 23:04, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> Can we get that fix into 7.2?
> 
> Applied to my tree - everybody seems to agree it's obviously the correct fix.

Thanks!

-- 
Cheers,

David

