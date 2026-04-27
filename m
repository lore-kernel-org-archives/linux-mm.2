Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B017FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE66F6B0088; Mon, 27 Apr 2026 16:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDDC6B008A; Mon, 27 Apr 2026 16:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D51A6B008C; Mon, 27 Apr 2026 16:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2EA6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:10:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B68D160210
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:10:42 +0000 (UTC)
X-FDA: 84705428724.07.CF7165C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id CD94D40017
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:10:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="P/4jdxx9";
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777320640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtWJa+k+/j6GoRAsuYaJzsipGZCN4xrLFGICBvPF+ns=;
	b=5m2puBR5SCi8GVMsABsBUp8O1ROzwJBVEKhMuYbuBNIlANjvNv/XEfDOZ3NiZ238TLLCeJ
	A+caZwDBWdPvPh8HZp3nDi+bPo9dFiWwBVNABqshetfFGry4jU+w858Mx7UuknR+GoZoG8
	Zq23DTjEFuRXgigfdSLfYMe5Ba5XUK4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="P/4jdxx9";
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777320640; a=rsa-sha256;
	cv=none;
	b=uyNIGKuqaXs1PwBdfdttL/COKrLSqnLyrklOk5ipeRy/O44/MYpvE9lcwcVgIj2FNyYQNF
	kHaDJXVJqIXVRofVRoOKvgw+33epbN0N1C1m30cjhmGo6nVUCbmtOV9PSurQH4VfCIzb2p
	6LogCWsBCLociFAzYE+c8gqSRKORx4U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777320639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtWJa+k+/j6GoRAsuYaJzsipGZCN4xrLFGICBvPF+ns=;
	b=P/4jdxx9z/sB4nBU4JEX7S5lNn5Fmn0QHVMKE7mqFPuNJ7NhXkSXiw8k7mlNdbiBWoWXFg
	3w1DlmluRChW/Hp4YM80mj1ycGIZD8t606QnKwBOYNNU795RzMVR/ELpyzmW5aGISwiuST
	g1yCL33SdJ08XwP+Vx96LlNbLshZBDA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-RY9ksxVJPWeDiyQO4z2Pjg-1; Mon, 27 Apr 2026 16:10:36 -0400
X-MC-Unique: RY9ksxVJPWeDiyQO4z2Pjg-1
X-Mimecast-MFC-AGG-ID: RY9ksxVJPWeDiyQO4z2Pjg_1777320636
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8eb04352924so1625447785a.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777320636; x=1777925436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WtWJa+k+/j6GoRAsuYaJzsipGZCN4xrLFGICBvPF+ns=;
        b=Ta8NelMdqFk5AC7NUFavkO76D+at1CFcfaL/Qr+muSPnZ9iHUBsIxS0SlZbeukvghO
         GOJp0JfB3eEqC5U5oWF/X2BrSIuaFyTNpEdPk8HRH6DPoTC5IRwFC8imrG1Q/1DvW1Np
         mkpyFy5Deuuws8rJ2U9CUYYcrz/9vLN6zaConxYO5zmpMH5vb9pp2tQM5HlLUyI7OLHj
         TmeUZ+dZIHe+0LRYL+sUDPLKzlqeURi5oNbdMQnN8/Xj+dz7BpmGbwW2uI2Xy2oZCu2X
         At22t0fVC5tAB2EcqZlwFYfYTvPt6N0xe4Vw7zgSyGaiC4fJtMzCVJ9oYP3JEanvPuhB
         CoYA==
X-Forwarded-Encrypted: i=1; AFNElJ+ZD1FcrFd0mQTCC1NbruU9o25jwXd+XfHhPzI0GfyOURsT+PWqCCUVqAkkAsd/P6bc+hweSZ99Mw==@kvack.org
X-Gm-Message-State: AOJu0YymPhIhcL7bbsP0BX0A2gx7hElekDqm1sGCrzBuESLKlhtItaG3
	G2NNVp1tJJT03mZYVtElMLgbkCusDmRyxlf0tNYHxOTVqrObbbKdnzlfiYnzRDp/rSxGshO2xZv
	OAi4HFPZWHt2jwfT0YIMZnl9tcCXST/em9pKwAGbYnNIov+oKc/yS
X-Gm-Gg: AeBDieunYkuv4bMnQegODe13Kacwv0mcx1fFDdV7POF4ALj+g2vwycvb5TJEgblZBPh
	SipykgFNrJbShpv7i0CkRftqvllZIW33r4olBmV44NH4qissLTl80NyYGs9RbaqKz6xh7MTHT2p
	bYM6c4BSI6mlQXIiesVXjluX6lZn606apkl4voBfaj8PgMHMpg7eJsWPeNnS+AmSWBSh5AbfxaH
	JVOex5Ah/EooGxlkFBaeLN+YUe+3ir6fu1QlB2+MXrlsdOimvlCgg0fQUll4JtglWA3qTedhooG
	SzRGycAV4FMBufWEu5D8KLD2aojvX4owd1Pd7Pey2ghOuD/WZH1tRgACH1cgVeaa0d21gu9yxKv
	fnOmMc6lGz/f+06lIJyso7jThKRCKwKXArCeZ
X-Received: by 2002:a05:620a:25cc:b0:8cf:bcf7:fcf4 with SMTP id af79cd13be357-8f7d78341bamr13559085a.22.1777320635583;
        Mon, 27 Apr 2026 13:10:35 -0700 (PDT)
X-Received: by 2002:a05:620a:25cc:b0:8cf:bcf7:fcf4 with SMTP id af79cd13be357-8f7d78341bamr13555285a.22.1777320634999;
        Mon, 27 Apr 2026 13:10:34 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8f7c51ae6easm28476085a.19.2026.04.27.13.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 13:10:34 -0700 (PDT)
Message-ID: <0d52f348-5f4c-4480-b854-6b73ca5ae294@redhat.com>
Date: Mon, 27 Apr 2026 16:10:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 31/53] selftests/mm: gup_longterm: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-32-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260418105539.1261536-32-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8oo1An6zQfZ0tV1z_wXWOIRk5jxzoj5KrCuhyxQr4Co_1777320636
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wnfogrboro3zrp3hoi74s1qwpfyuopiy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD94D40017
X-Rspam-User: 
X-HE-Tag: 1777320639-642667
X-HE-Meta: U2FsdGVkX196ghh3Y9Iq+rCP5m/t08b0r2gyrNUhRXxMZ0ORevaxXhoNYSXmpyptUqYAMLaQ0rExcxE4DKJveBjy+J9zVTj5LSoU6+TNn6WLyhLZ/XOGMS14S9hkNa2ZsoI0OIFRrclK4xKP7bGoFp0foOMUYG3ulxacqOBIU04fGLkYHTrGPvUIgGn72ed8dZZLB9jkVZ/a7rbvcrgSs4AdAYZjs18XrpsC3XwBquocMI8ZRci4EOrvZ1Q5iepsG1j5xcfMyuuXzKCSIa5kihYDtOpUh+ORisY50MmKNRQ6BImL3PemJt8+85Kp7Gd0urMSl+LcT7DCCEjY3rXwST0w3DHM8nQzdT7nsLS5t6ApfSmf2VUyD7plpx8KEu3CP6uA6GIzw6c0yhXoOT2d/bLvKxrs0eHo4P9SmdF6RurvIhMSm3L65K9ak4GtqLDcczbh8AZxh3C6UIwmRvqcVlhfhE0o9ZBsF0EKBYse+Upd1Ieja35cEuiSEkDJj0wXLXTmIEr1espsMnlvHYtpzLJoD/RiS1Uv3sccnB5adrfmJIZ1p4W36xRiRWbEC0wuZC82IY+ngN0xR4FJ6krzovqXPvWq00nv57CJyXJCwuAKLLpLEjyKD7sO5waOazUo/kF0l2T8uFaGc0RnqMaJaFJC+bTI4vDEwwZYDs72XtasTbeIGVKnXEU3zYvYULSlEUufGKr9pwR/8GGnmvRaSou8M2S/SJDS8vnW5j1zvULgsUYJngD7k/pq3JP9CIaNpn3yFwb4z5H7+44FeP523tywOBIYS7FCT1ayJ1GJOk1vep6iINGYY76w+15ItHJ+S49t9I+Q8PPKAlQy4K4wTMiIsxO3B9Ur6md0nGXZoD/JZJL59nrRYrkE3ReW3KKe/1RxkcglthPr3paAk2vkyHLGjd8/5OeJyef229SUzcQsGIXTwEJi46jz5btYdwu+4qhIWC3UkiZqYPjel4Y
 VdL0VRuH
 YNJAOhV4dLFpl4h4kYkCNVnRysoK219wmb0jNMNNOo0o/WGQWjo1aX1FdTGsMyiuWsdmMT02vSjp+6Z7WXTZi3H0tLTmhTpHJ6WD90KVpi83VdFCFMju/DJiBZWcYAX/++sszayR89o1PsLgBCTg5jNeunNM9KFMNMM9FTDCW9M6fprFXcEWVkNbMiw+qqPtZ0ICKDZNC0dyZGVlo0StjvErco6GoA39XckUj+q270Sh6nWGG9cFazoMvT3zE4pQeV3YyGtiy0uOglHq4MyB/oULwiGBgzHYFKbq4gjKEpJIsoDpWXxgdLYBrVNlBpk4D+rS/4Y91CTUAD3kk87HnPBHU9iIki1G+guKJm1EM6UQSJDihZizG2k43K4mehah8wyV3zp9rRa1eXVcjKvJszzUNQmUU+oAPFzIiEM3M2pzV0OqN8Fw16cPVivXL/daSFNNp1+i4lAsRcHjDP2PmNKunMue2g2cz2M2SIkgL9LTqu31BBDRD6Jwh3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-18 06:55, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> gup_longterm tests skips HugeTLB tests if there are no free huge pages
> prepared by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   tools/testing/selftests/mm/gup_longterm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
> index ab4eaf4feb7c..6e1de12bf28c 100644
> --- a/tools/testing/selftests/mm/gup_longterm.c
> +++ b/tools/testing/selftests/mm/gup_longterm.c
> @@ -510,7 +510,7 @@ int main(int argc, char **argv)
>   	int i;
>   
>   	pagesize = getpagesize();
> -	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
> +	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes,
>   						    ARRAY_SIZE(hugetlbsizes));

Are we missing a call to hugetlb_save_settings()? If yes, should we do
it in hugetlb_setup()?

>   
>   	ksft_print_header();


