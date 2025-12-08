Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF128D3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 15:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082196B0008; Mon,  8 Dec 2025 10:47:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032E46B000A; Mon,  8 Dec 2025 10:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63AD6B000C; Mon,  8 Dec 2025 10:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D21456B0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:47:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69BA21A01E5
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:47:34 +0000 (UTC)
X-FDA: 84196733628.11.E521A59
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id D956B40013
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:47:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yri4SrOy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765208852; a=rsa-sha256;
	cv=none;
	b=x+ltTnh6sxj31LWH0I5LN4SVfWqVzEn3JrSu8/XldTwDHwS/8sL9FEng/d+afb8svzntTw
	oNyyhe+0SjDshcfu1A5cHUad2xA+vorRU5W7gwzrOxgHtVwddrFzFwrBmtgl9IyvGHjb+g
	6pHEVeZd6lZWnxF4XsRWLuNmQNDT4p4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yri4SrOy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765208852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgJIxL0CX5OTd128INGYaD4p8fQ/cO5lOBgWZ/PrYF8=;
	b=sgnwdp6RZjWVxguWYKr3uVHqmLmy0wOTgOjKPnyaOP/AA21d+wgwaKLmJiSVxyWyjAQGTo
	sZ5TMzrchf1SfBbv0RhTfxE2+I9m44lhiUyFpYwSYfc4tTyVPvKDVzXrP2T8dBZCICgY9s
	f7/fUQlce2+2PcfBW5X6Ys240lQRRcI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765208851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kgJIxL0CX5OTd128INGYaD4p8fQ/cO5lOBgWZ/PrYF8=;
	b=Yri4SrOyl07ACDzI08/+0+6Tz2/YQrGNi7109sc+MqoJsAz2G0k9F22iBO3iRfroplocJQ
	4hIIyaoizgWaoSbWGZQxFBOWOHexcTHpjhs3eKp757Jcjv94DrhUclPEz1fMgFTN2IgyVM
	WoY4f2ANMTRQoMRs9mdupO2aJ5uiKAc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-aW7a7K6RP16Q5D01D5H_yQ-1; Mon, 08 Dec 2025 10:47:26 -0500
X-MC-Unique: aW7a7K6RP16Q5D01D5H_yQ-1
X-Mimecast-MFC-AGG-ID: aW7a7K6RP16Q5D01D5H_yQ_1765208845
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7ba92341f38so4598379b3a.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 07:47:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765208845; x=1765813645;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kgJIxL0CX5OTd128INGYaD4p8fQ/cO5lOBgWZ/PrYF8=;
        b=nRsIrRE6t4OjBEsA65ygqoXq2tDMCjbj59wcFjfOPo+DacvXa0C38mTP6q6f3SJ5u/
         1I1+fzefxQHJyEb1/Wstt/OFkM5HAn7yaM1C1ZEmhsUp/TlhHkMNUvlH7sXVb6d53QQo
         ftmukqBp2smHAFediHxL4/Mc8JRuxlus5VDr0fnSTzV0coGPkrAQZKjHwf4MyGP5HF+B
         ng3j0lVTf4zqipH0VPr7lMI7YPmrajBVIOpuvP6EkEPXWBq/QRYP5n2aLhmfVqlkGY0L
         nPejabOL/XATFvotc4XHIAgN0O15uw6QeZDjgTtrLNmtRClIBfJbwps7gcE6FY2u5H/l
         khVA==
X-Forwarded-Encrypted: i=1; AJvYcCUpQs1cEHltM7v6fvu114mRKBTA1uHuUDdZ0NqYQQ5ZEhkUzrZQBURV6drDHBldIXxZrYqnG45y6g==@kvack.org
X-Gm-Message-State: AOJu0YxTrT4Ewfs4CsIZAp2g1E2L1SgReqh4Vm7mMGlVcE3jmtmGdVqO
	g6LyDTdS4XAIWGKJJvFvibHzH3LAB1+xo6PFM5xNhLljKx03MC1Qpl0U4CXElSPF64Toy96HkmO
	yxmdmSA7dce7WupiZj8BycI81Yp8kOw0dHkRFTnIK1Xp9PRXhraiU
X-Gm-Gg: ASbGncvY7ErboiWHb4t/XDKh2HFln9Th3EaqnBxuYSpIii2SbL12PWxvFK+bEodhxzQ
	NwZ2KGqWqoYwBjOBynJUeWpRYDScl+ttlmGUB/rxKfJO7W4PcReOdqrSRRkxOyyTwnKqn+Cdcc4
	bALLAD6wJNLSFZV5cyDwmamdq7NBraiUvNofkdSWSSoZ3l/HzFSpRwtQEkatmmOCn4lr+k3BJwG
	iasYhOz+vEXdvEjKyjgHAo+ffhVkvytn5uAdPYot5HAT1SOHFfWpPuhtIFPYl4OAVxUML2UAwys
	JzAR4d8sMoSilLPoLRiBBL4jjbNKMCAbafqVONOvxY49A1dP//6IDx8n8A01QljsKp3s4k82d8U
	3D2a1V25hnR6uGFQpea05FiI/XeDpDIW82m7uIMBwDQ4aL2FHtMp8AAr06p7oIeEYMeoysYDmEg
	==
X-Received: by 2002:a05:7022:e0d:b0:11b:ca88:c50f with SMTP id a92af1059eb24-11e032ae38cmr5385597c88.40.1765208845337;
        Mon, 08 Dec 2025 07:47:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGcI88OCdHn0429dQauXa74FPpbQ0zI+AbQVlLrbOvpfEmA7o1JoeSaFNGOnyv86keP6Q29fw==
X-Received: by 2002:a05:7022:e0d:b0:11b:ca88:c50f with SMTP id a92af1059eb24-11e032ae38cmr5385574c88.40.1765208844810;
        Mon, 08 Dec 2025 07:47:24 -0800 (PST)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-48-76-65-77-217.dsl.bell.ca. [76.65.77.217])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df7552defsm56899085c88.2.2025.12.08.07.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Dec 2025 07:47:24 -0800 (PST)
Message-ID: <efdd610d-a56f-4f3f-ab5c-9b0da1762ab6@redhat.com>
Date: Mon, 8 Dec 2025 10:47:19 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] selftests/mm: allocate 6 hugepages in
 va_high_addr_switch.sh
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 david@kernel.org, shuah@kernel.org, linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20251207122239.3228920-1-chuhu@redhat.com>
 <20251207122239.3228920-2-chuhu@redhat.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20251207122239.3228920-2-chuhu@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RJZVaSjKpzKpG1RUGzl6K9f9WfZKaqHX9v571QD5f9Q_1765208845
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D956B40013
X-Rspamd-Server: rspam10
X-Stat-Signature: c1ajy7hethcdsba3ah3izxco4x7j8on9
X-HE-Tag: 1765208851-920968
X-HE-Meta: U2FsdGVkX19I5pDzrq/ajbe8nkCI5Ho3fkaATLmq3JW8g+QFCJOxbnuPaClRhYLnJz6Utc2NiL8PWPmt6cPgos3aPtf5vUE5Iny3eblSW406SR841CoUmaxGUVhjeaCOJrbvYAG6TJlshSXk5RnRQdpUR2zUOq0v6sB4zfK3p0vvAYdehDbfaBQiORuNiWEYAw0RFTRdoHSspkjrjkjsm7jatkaFPUCn24GV/Jn/wOhUXKpOLgW5OjZCp+sZQQDO+/adNHcp7zT3q3SR0c3YM7A/cJqw3Bm47c/MSoYHLh1zA6SlLOWA10xJlQkI6b4d6hJD6yvfemdyTjx3+pXTWkTBMBRlkhp1GbLXireXB/s8dXfByJP0oD5XEda3zvMQo1B+lfXkxS6samTNqEXCGzJQcEZqgqSbqaQVbaJvEx2lzcvCElAFc2sp2t3N/oWATk/DmNUxDVVSbdYDMtgDFYlRlqyFTfeitK9C4y2gidoi8Jgy3LOwYf7yR1XpAnW6xPYUxqhwuS5fyDVbpP48tjmUkwW9PxYcq93hOPN6So9Z/dKmPfhTWzcPj9H5u2PVrz+XVhm/z8gLVnn4dv5yXqjcVF9aeKZhp0j1GsE3clgLKspK9jaEqXVXyfQMHwXRacfnEIPVP6T6SMwEevhPOT/6X2dhkm/h/m2TAei59uQ3F3yizthS7s8pCnjkpvfHnfv429cCOl+qImifcDho1hsTaaSTi5bqdrKmfaeKs0f+NNir2e1zoxQ6ltmu3Wg1tpvSgyMNkI6/HdyFe17gO5+vSgdxQxak0GyYM1L9zuDkAKTZeJBoc3PCaXDYpE1d+YgBWgJKgsxsYHm49EuHv9rR/ArEZhrlz/lkYXJS2OURshDYxu3/El0IDtfCe+4J/e4LE6+xYGQdgeCRw1/DrcB8O62V+TOYW4f1J8fVax+URdF/7NXkbOxuOyuJXHFOM7YFkny6jQXRi/IBEHi
 8pM+WmvX
 pWT6Mc3+fmzM24WdAujOkDeA/Xt8h+lSzy422/2faWhRW9wlLBv0dxU7dUMNRy1xeRlzKcks1cqGI74Quxn43MuZ4IdMgskpK4XqLqAPR5XMzIV/zLz1vuFCG7YvAOIm1UpEzIZEGpWhngbRO3Pe0jG+uU3jdt3vjyr1sQaeSrypQrWgZewy+USuSyKEJb9TqIzooB7WCx5jcfwiPy/WxkW3v77yE+w1E96/J5iwAxR3KreTKDqpnRmI8zJC4fHSrvcNhQhyF/yYBHfT39uO4C7L2nE8lRm8TIc7SJ7FzR9HT6M089Zi8WFBJXh0zs+hwy267KhNLoDuNpahPjOuaRJ1GKyaRZWUdW+8tu/MQOA8kq2mXFkpoiCxs7y8E1FdUpD7XxgWUvRmqScgidxxDSfgfnFIzihZ1EBjPYFQZKtLirVt0wbFf4VHBSdbh+3xP0AJ7o83MIEK3pUcIMhvHxSTJA3RQmrFVCCCpg6Huav6zafM5XBBk/lzpgYhuhADoFSJlAxD+wX1bVmnYpqaqU8bNFbBdh3qcGplT53uG07xB3aAZ9uQrd+M0jjxmcSWjy6bZ+OIVBH8aNGA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-07 07:22, Chunyu Hu wrote:
> The va_high_addr_switch test requires 6 hugepages, not 5. If running the
> test directly by: ./va_high_addr_switch.sh, the test will hit a mmap 'FAIL'
> caused by not enough hugepages:
>    ```
>    mmap(addr_switch_hint - hugepagesize, 2*hugepagesize, MAP_HUGETLB): 0x7f330f800000 - OK
>    mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0xffffffffffffffff - FAILED
>    ```
> The failure can't be hit if run the tests by running 'run_vmtests.sh -t
> hugevm' because the nr_hugepages is set to 128 at the beginning of
> run_vmtests.sh and va_high_addr_switch.sh skip the setup of nr_hugepages
> because already enough.
> 
> CC: Luiz Capitulino <luizcap@redhat.com>
> Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
>   tools/testing/selftests/mm/va_high_addr_switch.sh | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
> index f89fe078a8e6..98f3dfab62c5 100755
> --- a/tools/testing/selftests/mm/va_high_addr_switch.sh
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
> @@ -111,8 +111,10 @@ setup_nr_hugepages()
>   
>   check_test_requirements
>   save_nr_hugepages
> -# 4 keep_mapped pages, and one for tmp usage
> -setup_nr_hugepages 5
> +# 5 keep_mapped hugepages are reserved in the first testings, and the last test
> +# requires two hugepages, with one verlaped with the last second test, so one
> +# extra, totally 6 hugepages

IMHO, I'd just say "The HugeTLB tests require 6 pages", otherwise the
fix look good to me.

> +setup_nr_hugepages 6
>   ./va_high_addr_switch --run-hugetlb
>   retcode=$?
>   restore_nr_hugepages


