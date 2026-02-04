Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0047E9D40F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C71C6B0088; Wed,  4 Feb 2026 11:35:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591716B009F; Wed,  4 Feb 2026 11:35:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D4E6B00A0; Wed,  4 Feb 2026 11:35:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 389016B0088
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:35:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6DA8139E51
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:35:44 +0000 (UTC)
X-FDA: 84407325408.29.FCD9CB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1BB3E1C0009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:35:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=guHG9jw3;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770222943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqukMza7dSYTTXLzk04AsHFpdUBkgXn3PUctdJJKnuE=;
	b=CtMAH7wqdV9gWQ8lkiG5IB2BmWGxNxs+OdYKJHMzTvXfJ3SXGlr/BC65PHzYrFurd2X7Uk
	d4MHhguJaq7T4dX/zCVEKvPstE6k6f+qt2bpvWnz3Z5D68szWjpCwz67VDPAIGuHapHWqx
	jpUWLUQvIfU7u6MnQ/LOqcrPPpUmJ1U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=guHG9jw3;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770222943; a=rsa-sha256;
	cv=none;
	b=l6LSs3Rjj9Sb5VSz1QfBAJ5j0Ja9WEJBHoBfp9GNI6vDVozQuzv7TTSZRbW7IPs3yzM7pg
	eturiP2RXFGvCf2HzXDvpvyIjFx2dSqRWMR9lC/esPHG/YNtPGJqtCAwgmYn7N7cCVSAQs
	+KxHmpYjmXolg+E1MwkmTXULoK8mNBQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15BD343BDC;
	Wed,  4 Feb 2026 16:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7674FC4CEF7;
	Wed,  4 Feb 2026 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770222941;
	bh=5/OZ1qIQmuwJcm9OYX9ZIjpspcSxqstv+AWTE6uVKoc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=guHG9jw3N8I+xNLsa3f9nQa+Pmm2chRIav6Y51f4z/2JnAkdTEpX16Fbp74Vrsyfq
	 Np8Ej508J36pKV5jc21t9LWaCvrngApFoEihPykdHOB5+GRDryzPG5TRTewk4V23Sz
	 Wr1eyMyqWy6ZZ+F5Cg3X12kq4hY2A384zk5sqv9uxI9kYUl62ub6ovbRSafVvtZrfl
	 6XKUvmI+uG20ar43iJqGmP1+y4MMzYu18Ha5HWbnYJKTCIPh1LgnmAMv/Ck9tJ6Hns
	 CchYrBzdmIMmlYg8vgJvzobxdWYpN0Q+T4STBKBmXwKXv4BxtnsW0+vvdlw/o6oT0c
	 XGofgnumfQ/Zw==
Message-ID: <7e21f06e-6948-465c-b531-100749a76b26@kernel.org>
Date: Wed, 4 Feb 2026 17:35:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 04/17] mm: Move set/clear_compound_head() next to
 compound_head()
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-5-kas@kernel.org>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-5-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1BB3E1C0009
X-Stat-Signature: k6kd4aj9kem33o5t3tqowcs77t6kx36s
X-Rspam-User: 
X-HE-Tag: 1770222942-996334
X-HE-Meta: U2FsdGVkX190Bo9jGfKEAVAtcPk0UAzw51fMsGfuNjb8+9RKL5b0eQVyvRKdhvvnGq/V4YCGB1WGi8MtemF/MJ5bMKbKpcueDzjN8Fxs1KndSawU0hhl6l+BjP5kmZ2MFaZfe3IxCNheraIGb0LuTdRf3eqP741WpwsaHtwKyCjEgwoHvVMJ3WTT1Qc+y+ntm8l3YKijfLQilsK3eNYy2s4KahI7WAlY1H9jC0f/SrNJG8U17IFzTwy4h/T+amW9BFdK3jkpTgmQRWMTduN2gYVbc5nN7gKuE+enoPAWM4AbcWRwFqz7GDuRZPjX5kyUA77qGGZb/yhWuidXcrG7ofRxQVAuxoQjMFxzXabHjnWLMJzPpK3cfcEDRmbkg32PrvqwwkBAooSIFCocUA46eYpVnMNU00AmDkl/VX2vDsi8uYv02YtDK1dL3Vp4Qbmal/gXx5NLQtogaPUszkDtjFgopyEyGVT1tfHpzdKatRJdD16lHsrwrG0dzfGxNfNC8wLXWNsECSt35Vw7/Hqeffm/Ps1O88B1Qcf1xvZ3Z0GA3lKeBLQS1Fk459tjRY8nYmkOGnxi6KU+nlmpzLKerttDIEuD6RKbkhVAAuyROBbDxJl2qZE/lYNUZ+GO1JqTNSM6u9xdtPZicGHyGrF7CXeonjJURaoJIKNqofs8pVoRlhGLjgTVEakn9KpTPqt2y/LY4W0s1TtuCSNGiTpL3TkccY3yr1kcC1rPERTYcqb1mgiBnewnu0UM+ZYlN5OselnH6I43o4KwBPHSMupnWcketvEmt+2KzxpkQGQmu71GzbI+4JMruUgJOCQ8HsSe3Soh3QP3ZtVXGnHOMuw+GKmXdJKJyNCcpFqLT8ObGZ1AlKwQLY72tMoJNahRVlVqGNhYp2TqehyYykZI6jRy7Mo4PfXOa4Vixfwh5qp4TGUuOHQgJFBkKQCBjEUfPQwo84D5fs0YQ4NyI5FilBZ
 8yR25m+9
 ja6Qh8tGDLG26+53y0vCWS8RtZuts7nMQDDhlLoTAgUbvzcXwoVwcRbTwfEfE8SVtSyEe+9eL7cSjq4x0Pg5E4TkuJ23KP89K30PILH1u765SpMRUZZfo+6i/qiwn8h5YaiAfcz79YypRTKy2HyU9VOrRBLv47o8erKajina0paIHrlGAL91XWfemnYA1JVuJZxyvxeWQ4ZWj3qNfZXyT4W03qJV3AySraLUWS227OeEiQOLlBHFaH4GhDIP356F/X0YFb2gcRikUUlBQMsJUmCKup7YoKftJCI9KGr9SgpAqpRgY02pYahhw2T/hK73DenGimwl/opZEYeYYOoWkdCi87gecDDZlC6aO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> Move set_compound_head() and clear_compound_head() to be adjacent to the
> compound_head() function in page-flags.h.
> 
> These functions encode and decode the same compound_info field, so
> keeping them together makes it easier to verify their logic is
> consistent, especially when the encoding changes.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/page-flags.h | 24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index aa46d49e82f7..d14a17ffb55b 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -290,6 +290,18 @@ static __always_inline unsigned long _compound_head(const struct page *page)
>   
>   #define compound_head(page)	((typeof(page))_compound_head(page))
>   
> +static __always_inline void set_compound_head(struct page *page,
> +					      const struct page *head,
> +					      unsigned int order)

^ :)

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

