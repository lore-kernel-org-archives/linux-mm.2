Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBF9DCA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096838E00D8; Tue, 26 Aug 2025 09:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E3A8E00A8; Tue, 26 Aug 2025 09:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9EED8E00D8; Tue, 26 Aug 2025 09:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5D1A8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:22:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A485BBA2C3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:22:20 +0000 (UTC)
X-FDA: 83818972440.25.F083DEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A2E440017
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:22:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TFhjuDCC;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756214538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejwt2KXyE6SL3SffCoyBx/2GldVYshUfsPo38DTQflo=;
	b=4NRG3z/O8/pVv1YRmpEMnhY9PXlnWQQW7HhrKdzWwAuEPT2e4QVsxhmpV+Nwu6SWGpXHLz
	nCTSUtoB6H6uh7DR3zAwtFqUxrgbRg9sDXz0GobHQ415gL3dj9Wsuch2dUW3lqnQMxKg6/
	WNjMYKvPkPNmNqpi3+3jQuvoWcJa8CE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TFhjuDCC;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756214538; a=rsa-sha256;
	cv=none;
	b=hFB3stfS0ADn2w7OPSk/pkac4+y8Ti8Uz5xfUKtEOC2MCjBK6YMO1hN7uVw74KsQ+Xr5VG
	HoU1fkvFNSUPpLRh0sZ+KwLflyVqdgLiGVHsym4xSZOgAAffKZX+uXDm9KEY0xxR+EySYc
	FnP3H1dpDLfu0Poss17xqVsHB+mhhxo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756214537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ejwt2KXyE6SL3SffCoyBx/2GldVYshUfsPo38DTQflo=;
	b=TFhjuDCCo8pkEd2sCAGY0K3RQQGIzt4KwWsJfoAWo1Cqyx7CRYm5Y5yFl5D4vEEHYfT5Kj
	D915sbhS8z5/zI58NTWsdNxanvnTmAOe62JaXiCGmGX3yFj3YyWfBTQ3KRG7fMNVAgLCLl
	0O87aWGKyFt4/tzbuhDptZlov7YL570=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32--A_JgywpOiKDKKlwnwTylw-1; Tue, 26 Aug 2025 09:22:14 -0400
X-MC-Unique: -A_JgywpOiKDKKlwnwTylw-1
X-Mimecast-MFC-AGG-ID: -A_JgywpOiKDKKlwnwTylw_1756214533
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b05a59cso39652895e9.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756214533; x=1756819333;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ejwt2KXyE6SL3SffCoyBx/2GldVYshUfsPo38DTQflo=;
        b=V4BqcLIS7azYQq512wa6ri+9/sxlUlMWyR/gS9UGa2FGw89JB4hz+njuLGP1IvJkxt
         FZfd86SKI0YSyRtdg9uUMEeuhuG7MrdezP7Ojydf4DfJ7cF206XigxKPw17NjcEwFgRu
         yL0FBogAo23JaveH9sTyk8vqFr2hMBBn769g/4k8HwgjZaVX0Jnl+Zrk34So6x90nd4D
         rkm+Eabi22PZu9feBKVVGuGfBBiJ39rq+1v+m7Uow2cXPmh/Fvm4XnJ+zSUAk2xwLvD7
         XZnFglH3vnaalhjpW+F1QpPK+JGTO0Gesd7+/+YxWetHzkaN0kRQ+BHmdU/y6HnapKIp
         OjAw==
X-Forwarded-Encrypted: i=1; AJvYcCXgZ+zz0Lvr6q3OfewFgRVifD60/yUQ7o8Iq063IBE3TrNUEmc/OOkRcnskaXHAqml69dHkubt3Rg==@kvack.org
X-Gm-Message-State: AOJu0Yz5RBAHw7XMhupOnAdcIHKpCQM1sAtekINmi6LoGtH/E84zO/Tg
	dXqZ/7jEChaCOpyQRC2RPTtgtT6NQHGU6Ib713Gm0Gxge4wDWwoXFSy0qYyZpXkKbLvapUYYON7
	PqpDVaxMR8LrhHuu8Nb9cILPs+RZ75UNF3vz9C51HX9ru8yK1cllu
X-Gm-Gg: ASbGncs3T6YcCkgiklLbTgZvO1VXBGg1I+nQIcUGQ09npJTp7rNm83giKlqPp8PohcJ
	JRmYlKNzgZP4kafZe7y2XiVWBSkr2eT7nefgvAx7npTOJ+UGMluWbgy8aceTJ/MZ9/eOiBE1Xz9
	cLLpPzizFEJ9qMkd17pn7htREARwpz9C6Qx8V+ZlPH4zccbgzmbyo9ppWoEFlK0N0c2LGJhJobO
	t/22GndOmh+KufPBoZ6ZWjlyB+W75iLcR211QtthI8LICrrQ+hfl8i0AOCPKTaQwAQ1NhxWg/4P
	swFXhotyMkNpJvDG4XtosFk23lvXKizFyns/jyiSOiBmjX+0DzpilrFSIOyWhSXclB17TFQK6g=
	=
X-Received: by 2002:a05:600c:1c09:b0:43c:eeee:b713 with SMTP id 5b1f17b1804b1-45b68a59459mr15830085e9.20.1756214532900;
        Tue, 26 Aug 2025 06:22:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdhrt4HXHiQdFvEf1QK9x4hO8TiEtRV/0QYg6xcfCu7yN72HN+Y2pTEUqhcMa/Na09mCwQAg==
X-Received: by 2002:a05:600c:1c09:b0:43c:eeee:b713 with SMTP id 5b1f17b1804b1-45b68a59459mr15829785e9.20.1756214532407;
        Tue, 26 Aug 2025 06:22:12 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c7116e1478sm16178696f8f.46.2025.08.26.06.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:22:11 -0700 (PDT)
Message-ID: <ba6d3e50-d8dc-4ee4-ae44-bc1b57e4a2dd@redhat.com>
Date: Tue, 26 Aug 2025 15:22:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: add fork inheritance test for
 ksm_merging_pages counter
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Wei Yang <richard.weiyang@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
 <88d6d5f08ff119625fa9accaa7b849dd77f9df25.1756211338.git.donettom@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <88d6d5f08ff119625fa9accaa7b849dd77f9df25.1756211338.git.donettom@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ouDb4kTeJeZ1HeVtIZScoTgP20Q4YDNf1NLeoAumg-E_1756214533
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2A2E440017
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: mxnjtp895mkarefk963iozsi4ib1ek3z
X-HE-Tag: 1756214538-989412
X-HE-Meta: U2FsdGVkX1/d5b7YAipZyYK0u9cV6ceW6xgbbqRUfADb/rgpor4+FY6GdUJGQ3dv4FJOgTduuDuBA0qIcPnN8ie443o1RKXg4HcY33bI5V0bfaIDZ8ohnlACiJLvIYdEe4h3/n2H23I9HQoUQPMro0mEKi1TxSzFCjlp3OjZ82XJNgvBDJ6Mm3qDo4oQvZmobRtXRp2btljiUyNcY/G6kaCmuaHRHALGM2Lt8qSaYE9y3qL2v3IjRhkeS4Jo5M7VyIvcSInZ+pKBILi8Kf3KFqpAIq6btwrad/lyS3P4JVE4eGQhvNSd5PCPQfaKTcrGtjVkitLvLw7ilF0Iz89EGD3yi9/aLBhAHSaxOQ9vxYseRKb/gHarcOARH6JQfjr4HIEvovbDMw6dP+0Hrz2ERfLjAvKjRjEtiOv6WgUqJdiJnsZWC85MF9Jc80IPog2ejEdlAoMT+n6/l3HvUSHzWhjxHnZ4xZGXY+o/gviQ1YY3v7WX0N8zhAzrGTsZbn1VjWJEgsxqGfvRMnsFTrlrCVdt6Llc3EQlZjrCRVAKLkMIYsRrbEghhkhYB4LeGWwLH2MqsSJYqxKiUi0NLbKRTtwg82MtHjF2VVxu9K6mzYRaz5mG2UaOyZxxHaYoh8bKi0S3T5/ETxffQoghAfbQcFh8Sh9bosRT7DdEo4aOb4hFoGW6/MGAYukazH/InNt80vz6AXs/Vo/k3fcfJlrcfGS5xltxA7rX3VH5esjpQUY5zh/FraU2zCbqQd9gduEJQBwL4jyh+GlDdFzgtp4GhiFSYht1SDUKDPwOjMkfLyCS3eZ1tAkQlEjVoQcbh3GA//mkxyE9PVhZNCsqrGNJWvtt1q9WSmvO+ZUVySlAUocR6DYSR/0Q6665bQRfDZbBaAZ1njfReSEvKrma/l5pW2JvGdYEX+JEmmTSWw5ZafvNfb663zdhhoHzLyzG5Zk3oR+WQyIMLhAxj/XNYgl
 R1mvf9Fx
 Oh66wD+8y89bJliZqmJFpZtsN34TsvrwdNhFfDrR4Ug+TKyy/mCEu8qj3bL6bZCM8gKj7EkirJytSbeRB4yY4VD+aKG03YlzxJCzDA2Z1ZpaKMRHbhfMf3L1/aj7NRuDyr/qGk/Wm5QdjeXFsMxf4qA4dzcAmWUJg/6BC9mQKsgDqPNOoppw8B68Pq+Q9cK4iBdx5X1zBQ1miDekNb7DAb+j0DcIH8JYKfwutz6xIf/DNFDF9lo2Z7BYRxWkcul2J+MMwnYpTeR2nX1coj/inhb04krWbcT/gX3CFgIGdzVmOo7Xe/ee9EABYEVIlbOlaVOtXAtWifmOP5QJ5vIxCPGAwIKdbtH7GV2lVdsKUUx0aR5mLC4mbp8XwzFZFDiK338er4zRtUdQDSys8nwNfpI5QQ+MeRPnw5hvGpdRdw5XTnT9pvR/J8C8JtUEI/edRGH3wo4pPyyLS34VvFFJihIP1ULnmRJXS/bc4yFxWWWk0tyxopz2Dw4DADTPcuNH6SY8unnENfO+we1Y2zXe6rcR9TzqwhLMsyo6jhy1X0eHJUXwrovW4Sty5KjdcfVoRBJgG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 14:49, Donet Tom wrote:
> Add a new selftest to verify whether the `ksm_merging_pages` counter

"to verify ... is *not* inherited" ?

> in `mm_struct` is inherited by a child process after fork. This helps
> ensure correctness of KSM accounting across process creation.
> 
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>   .../selftests/mm/ksm_functional_tests.c       | 42 ++++++++++++++++++-
>   1 file changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index 712f43c87736..d971394c9567 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -602,6 +602,45 @@ static void test_prot_none(void)
>   	munmap(map, size);
>   }
>   
> +static void test_fork_ksm_merging_page(void)
> +{
> +	const unsigned int size = 2 * MiB;
> +	char *map;
> +	pid_t child_pid;
> +	int status;
> +
> +	ksft_print_msg("[RUN] %s\n", __func__);
> +
> +	map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
> +	if (map == MAP_FAILED)
> +		return;
> +
> +	child_pid = fork();
> +	if (!child_pid) {
> +		int mpages;
> +
> +		init_global_file_handles();
> +		mpages = ksm_get_self_merging_pages();
> +		if (mpages > 0)
> +			ksft_test_result_fail("ksm_merging_page in child: %d\n", mpages);
> +
> +		exit(0);
> +	} else if (child_pid < 0) {
> +		ksft_test_result_fail("fork() failed\n");
> +		return;
> +	}
> +
> +	if (waitpid(child_pid, &status, 0) < 0) {
> +		ksft_test_result_fail("waitpid() failed\n");
> +		return;
> +	}
> +
> +	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");

Won't this trigger a fail in the child and a pass in the parent process?

You should likely instead let the child return the result (or the 
number) and check that here.

-- 
Cheers

David / dhildenb


