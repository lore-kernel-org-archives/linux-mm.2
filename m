Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9907DE674B9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 19:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B1AF6B0088; Mon, 22 Dec 2025 14:36:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03EBE6B0089; Mon, 22 Dec 2025 14:36:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84306B008A; Mon, 22 Dec 2025 14:36:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D83CD6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:36:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F7E313786D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:36:24 +0000 (UTC)
X-FDA: 84248113488.15.A479EEB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1AC0480008
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:36:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MooInMLg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766432182; a=rsa-sha256;
	cv=none;
	b=5NG0GQlzcXTIrXHNWfWwzdGNga6z+2HOTPs7iFa4jn+6wG5f+64fOfkk8W0IzF8V80heei
	UpqVOVRO0Z/bhaXRa52vSp+tzvwMcfmBA8LHLC2hyXDJEjdgROhKBlPaGoUMIIX0sMFkin
	ysOaTBOjKeckf4l65e+5M1AojEZJvKU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MooInMLg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766432182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWFglRNrhHIkSED0pY4mFYnNdUnj8iod8G1skdCiVi0=;
	b=CUMJiAd0/m4UNpmo3B5VWb4zGrosLSezGGNiczVrdVA3M3FtmKsMWtcoBs5rsWuGoxSslw
	OVxFlCpeBtWgcMXd2o3Q22xmVkc4fopZTzxk7M6/GtLEBaBjCKh/w01kKR4CWg01Mcj1XZ
	+Gp6OCbNpSy+cltTf/DU/wI6UjJPkd4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766432181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZWFglRNrhHIkSED0pY4mFYnNdUnj8iod8G1skdCiVi0=;
	b=MooInMLgW7ystPQma5yiCtVBsxjCYLlwBbHJsWZR+NCbTbze0pHuH54yxzEjheC6Yai05k
	VoudBeUmzKZr+TVVrvYkJdqj62A4lcod/iod65SGMqxQrsnMgwmACVP3xqqcp533WAijR8
	DDfPjrjm+LdjvPDrg29YuCjsFKLj3CE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-pURET3D2O3WtFe5onHRl9g-1; Mon, 22 Dec 2025 14:36:20 -0500
X-MC-Unique: pURET3D2O3WtFe5onHRl9g-1
X-Mimecast-MFC-AGG-ID: pURET3D2O3WtFe5onHRl9g_1766432180
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ee0c1d1b36so116992251cf.0
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:36:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766432180; x=1767036980;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZWFglRNrhHIkSED0pY4mFYnNdUnj8iod8G1skdCiVi0=;
        b=SuGcuhqpB0CgN/72dHbOoFJA0264ie368ihoghtTOERVP0cvhqtnK4D+0d7nJbUncP
         7YRvDxaECRxajr1QIP6ugIL/5QdCCD9dz35J+HWRZPiEjpBpH3IBI+8TAJVwxxuElYZZ
         OsuOzJR2kSq0t7WKYWkjVbIqVqf3EYob0NviKe1eMjGhqPRNAHQFF/EnvOnMPgbN2jSO
         LbxpZXLZ6euxC7spkUaGL1RGiJODMgKs0kWqXSzKS6tdbxyJg4ua5qfoWEN7jy60tRNn
         lwMdPB0qNscYfPvHe55lXVGOvsUAQZFiBwFWMVMNZLy8juuemCxVvFWCiZDdHCb7UG6v
         sU2g==
X-Forwarded-Encrypted: i=1; AJvYcCWrjgGzuT2qb5/xD0XlVxAvKoSy6u2iVaZYQ1KQVFYErTjxK7TN3xuazFCeIvEBxkIsrp1xsvtvSw==@kvack.org
X-Gm-Message-State: AOJu0YxlG529ceSJaOh7brLE+6N142nQm2lXTOCbn8iVFKNs1M3YYyCF
	FcUREZOUWTAKdOigqjNtU7ULWgkeC2Cn1MA0lKoA87JskUYy27sR8VyOSxu/ZZ+V0LDgaC+BpK2
	9qJqJun/rEgLzy2dtpZgufbzKR16pNcuSBnWZsvCUztuUdOonx6x8
X-Gm-Gg: AY/fxX5Eb4Wk0IqGNHHzS9REEW1GhxYh59sPid87F5wEcjpu7cAuNJ1v+m7s5H1WXYS
	4BbEZ+IMLpcZSu29rM7jgTO0j/YvA4WYnOQ50AGIWo53F1NlHFmgcgem4RMMduQlq7rXenBnMVk
	gfciSM+IuI+vxzaCuNP/vl1r8WpN2lagU0upWo9E1jq7YNQKp314BWRGWN8s8fk2W+hW1nVGva4
	BxViwrH7K1V2IwlAH6MLNQHAKMh8CH2OHETy5G6xr0Ts/zhsg9bfgKUPjwEAcHyc01FzbltMNgq
	fh5/eXFJmyWLre889/RqoA7IWVM4onVmvV18l2UP87lxVu+oWZCi4eZY6WArFO+KCuGqEJ3aUrB
	Wr+/kj3M3Qvo4voDkCaiSOXDfZSj1S0TMAdrWmXF3jRcJ1aSjUSQ/MF5ns5TzvL2sC6e1bWdEAw
	==
X-Received: by 2002:ac8:594e:0:b0:4ee:ce3:6c9c with SMTP id d75a77b69052e-4f4aac5d23bmr164621791cf.2.1766432179676;
        Mon, 22 Dec 2025 11:36:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDk3FjtineRhvc1jPppKJR8ZeFRYgYn64r+f+ezu6FGdQbbfW4MbqUOXuDnwzesgGVYYYTRg==
X-Received: by 2002:ac8:594e:0:b0:4ee:ce3:6c9c with SMTP id d75a77b69052e-4f4aac5d23bmr164621571cf.2.1766432179295;
        Mon, 22 Dec 2025 11:36:19 -0800 (PST)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-48-76-65-77-217.dsl.bell.ca. [76.65.77.217])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4b1302d44sm79789771cf.29.2025.12.22.11.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 11:36:19 -0800 (PST)
Message-ID: <469acbcf-22f2-4774-8cf3-7f68c7095c0a@redhat.com>
Date: Mon, 22 Dec 2025 14:36:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] selftests/mm: va_high_addr_switch return fail when
 either test failed
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 david@kernel.org, shuah@kernel.org, linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20251221040025.3159990-1-chuhu@redhat.com>
 <20251221040025.3159990-2-chuhu@redhat.com>
 <20251221040025.3159990-3-chuhu@redhat.com>
 <20251221040025.3159990-4-chuhu@redhat.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20251221040025.3159990-4-chuhu@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SFFdSZmvl5Dsh5OTxeQThYNOEOc9Z89_oDkc4HUbSgc_1766432180
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1AC0480008
X-Stat-Signature: hqw999c1uh17zi14oseiprrts35d9t6w
X-Rspam-User: 
X-HE-Tag: 1766432181-427861
X-HE-Meta: U2FsdGVkX19FX1xu6S5a3aS8Tw1Cik5cBhiNLk40jip2ljieL69+vsNG97mrcVd+PWoJxToQCb6pBtVC6ze/FfFAmwZLu8oYl5SlVz+lzzc+HeuY8ZRCz95tMQyISc5CDjo8LP9TZbi7MkXs4RbNXrPSHagOkHZrf+RRmCgZiZY+KqReFKjXX0zX+oYRgP6afIVXp+hnFgJZWYIRJ10GDjYJQ9ny/BVBVVNR+m5919OhcxK4reDSQc3zX6uk9fmoYEaC+XsWYBHrIT3KdXhV2va3RqGrTBJqjyr7DJZK0P+C5hw2P93WXv1Q9q1KcWDmQFoNLLtE48gbazTZJyWdiWmjaND3qKTqaAS/LAWoWZoxTApNASuf/0DaQIJeQ1Jc2+sgSbriPioDJKKsBP5w456BUSpYDJwEWGYAUkX+dxdIwrItWb79PCCPmPaiiS7sJ0WXfI+nIjzngHr+nMLvGOnz5XYT1htCa9b6qYsO7I7zd+pvrV9U5mFrSgDeDO9/JTuDarSz1CuNeJ8yr7Vt9eCbOzV+ViLh2b9SxxhwKvNHyDBBeOL1/TnfGsIQdhlcAHchCNJbHDbIDOIRqgxcSBgy68A1D4t1vxlayxevLVNBiez4klj86soKMYVB6YbVHyUXArV9LOT4/SIhfdgDdeXMKgftXoJbuTfXKZRkdl+ihNcAwwqZ1979eeIOryDYXgmh5v7hlpwcea3BZgLGpvGXQCdKBhOzkdLj6OgUmAI9e4j68dNWEeoxiIcF81EJhM/+gqM5VKEktyuYAx783w78ONvda//12qW1Ku21dmE08Rv9TBOXuEJICWr7T/+eLEdROIhYi4Ff/pM8Vnl9g8ySFn9w3ErZxXJk4TvxsulPt06M6d3iQvE2xqUgSgdy9UgRTufUM6fGGDTASYlmJnD2riDmHArqUTuHxzINF9VDk6dtg9u9yBHLH/MrOzEfNjNyUYee2cFt52zhGuD
 Zel8kmyc
 0I5+Bcq08jSPjTFBpNhvqPb9X4v7y1JFYyvvQP7Y3YC+eEmqkXluQFMlhYuptvDcrghGTqg6MtgXTKyuesYEB60YfMdJSetXI416gRTW9TLz9GD+sqI2Sk5pKjWxJSJU6Vr1te4Ou7iIoaG0qMwg0VtvB5d8TwKhQ+lAWgnvwV7Wj87eEYdM9seSvug//OZlmGlzwTlPIsio15lX0Yz2dAuRbs648vZBNTwAsqxa48s2hF49B7tiJx2BmwS85hse5/wWw2KiU9+JeCyBog7TH9JNfhSAunvmrUd/EhbwsDk4DeDJnxQ9HolXCZDvIMm2szsIgZLv+Xvv5qLzCOfZGsfuryA1fnLC5a1Af3WQKKdh4zO0qX8GRehC1wG7EMAgnhFsOmPVa2ytGe5qzhUprodsRF8t11ORyhQC1L3n+cVNdZH1U+RU0oAKZ0BGDxQPDOQq/7nqRl06hI68BgDFLPVbsSJ6qdN3i4zHyEjYEx56UfSX/A15Lal0/F6VTOsqCMduFib1ji8s6C3rU39grA8RkvJ6HIeXnMI7CtF73yR6kRBU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-20 23:00, Chunyu Hu wrote:
> When the first test failed, and the hugetlb test passed, the result would
> be pass, but we expect a fail. Fix this issue by returning fail if either
> is not KSFT_PASS.
> 
> CC: Luiz Capitulino <luizcap@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
>   tools/testing/selftests/mm/va_high_addr_switch.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
> index 02f290a69132..51401e081b20 100644
> --- a/tools/testing/selftests/mm/va_high_addr_switch.c
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.c
> @@ -322,7 +322,7 @@ static int supported_arch(void)
>   
>   int main(int argc, char **argv)
>   {
> -	int ret;
> +	int ret, hugetlb_ret = KSFT_PASS;
>   
>   	if (!supported_arch())
>   		return KSFT_SKIP;
> @@ -331,6 +331,10 @@ int main(int argc, char **argv)
>   
>   	ret = run_test(testcases, sz_testcases);
>   	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
> -		ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);

Maybe you could just have used:

		ret |= run_test(hugetlb_testcases, sz_hugetlb_testcases);

But anyways, as this is just testing code:

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> -	return ret;
> +		hugetlb_ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
> +
> +	if (ret == KSFT_PASS && hugetlb_ret == KSFT_PASS)
> +		return KSFT_PASS;
> +	else
> +		return KSFT_FAIL;
>   }


