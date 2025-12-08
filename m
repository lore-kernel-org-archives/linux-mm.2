Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1513AD3B7F2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 15:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4736B0007; Mon,  8 Dec 2025 10:44:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC2E6B0008; Mon,  8 Dec 2025 10:44:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABAA6B000A; Mon,  8 Dec 2025 10:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AABE6B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:44:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D17AA13321E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:44:57 +0000 (UTC)
X-FDA: 84196727034.16.868878C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 62055180013
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:44:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hZMEdh7J;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765208695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZA8EtJ/Yb3hDRtk61pdFksnnDW88iHKAyV8Vf/m1G0=;
	b=UqL+XNrcU+ySqsz7v/0CCix52k5DaBYhRiV/Bhvtk/yXr/JimsqgilqfNtK1PEoWpXHmff
	oKFrx21ZphHbeUzACkJLwIE1e6UV4SycWYCK1dl++kOyL2FemUCi5TbU9LcHjbjPp5IgL8
	T/YnZFVD7Dz9NhoCFlKsfYegjz0XpdQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hZMEdh7J;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765208695; a=rsa-sha256;
	cv=none;
	b=bHmQNRXgfpxHkVVeJW6lIAUs2qfC8ToXoXWMRFTz5mIOECUfUCumgWRPFb+SC+za9+wxAS
	Ji/sehpHSiaumLBN+FvCKxS/nCPlvlCOlaMdJnyG9bjYJsK7udgjbcYdCFFPth17UKo+gw
	sbolLAVs7ww+DhKCYhuibZelVQPTqNA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765208694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+ZA8EtJ/Yb3hDRtk61pdFksnnDW88iHKAyV8Vf/m1G0=;
	b=hZMEdh7JeC2yGOR8gelUNXqUcCrOQre/qo1MsdtVT+ASdCxi/beKwM2clf+mSRcFU7BXKE
	MBt7hUaoPcyNvYybNFo1xJRYZOrlmrk/QXspghcgLDM9O95FIQPprAQ+Wd045pg5Jhz3cJ
	dMprupf4r0dqUJHSYp6zk7kqFdYZ3A0=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-9PQaGh0SPoaf1zglz2yLJw-1; Mon, 08 Dec 2025 10:44:53 -0500
X-MC-Unique: 9PQaGh0SPoaf1zglz2yLJw-1
X-Mimecast-MFC-AGG-ID: 9PQaGh0SPoaf1zglz2yLJw_1765208692
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b630753cc38so6747675a12.1
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 07:44:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765208692; x=1765813492;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ZA8EtJ/Yb3hDRtk61pdFksnnDW88iHKAyV8Vf/m1G0=;
        b=B18lwG5mf2S7WRO58pomtiklqnWOEXkfal0VLhxb6MSgequGPVSTWFQ6mWE41/QRWq
         4IlDMZ71gyh7ZVAnW6S+MZ8u58lSKO5Z+dMPuO11l0nuy6saCuU//+6qv6IL/QJNM9jH
         N/ndOSBQZKSn49svPkUpZ1zaT71DhikyqwI4huRae42EpWOgVVhiGnn/eDLR7rFl/tp1
         lvor7P8nopf8oicGGKIpteG9JONM7P4trw3i6pv3P5NupLPVVjRGlq1vCkUz101FjVVC
         r4Owc3QEOy9Aq+6Zae3/pwaMyztr7brZ6hMTgEEg2OGFG5v7A4p+dHMuZyjRctkcRyRX
         2hLw==
X-Forwarded-Encrypted: i=1; AJvYcCVC0+Mf9YYpzilcm3p8jGjVdGA+CSeVcMJJYbeZUfUwz4TalAzIbZxEOPmH7uj7BN4Y5SPoyckeSg==@kvack.org
X-Gm-Message-State: AOJu0YwyDRBefS2jBH+XCPQRbZo1wl93gTEwFxnRGLz5qY1lFO1Q+dMG
	HinHKnsnCLwbifKMzcjp2uY7ZBjkb72/JrrOkfwjV7WGhqrH6Jlt0AbaIfoh6EF6LisHD1puwfG
	cE5J+FtszaKU5DcYus4i8QgNMdxITsus8bo5/Q8amquYWlt5tyJmH
X-Gm-Gg: ASbGnct1c2nulT0lQvpWYfBN7TEQIIckvmWvQRpRem1zCQxHI+J3kkxYS9WvRjrVyME
	TGBXb7HMt/RHRFRvR0uy/b/WxrI7aTl2kuD9ZYSEkGbIPCxEA681q1J2SeYZZ1wQiTY2mO1sVbO
	fp3m8HHGJa4/G5+T+U8F+tu4/Uj3Tao5ebC5bm09OvJ92My/+7dp2P7yBMzCGrR2ytlIip5sM2v
	bM+pvKHtZsOU5Zp0Sm6SO6k8qve40hqPiKtbf9t6CNb+YRQE7vTUe6y9POKzNu8WCbmz7FfHpV0
	ACVH+YLkAaZ6q066rE8wcuvGmdGgMuRsZXJjaofEBUgRGKEmsrG9KLzlc5/2fr4cYTfvBmIfyh7
	OAYTg4EqAh/rUwgBW0VBni3UeOQ7d48BqUvNhHTVl5cfKeiBEUSMxDiTUZF6epmL3wtF51DjLEw
	==
X-Received: by 2002:a05:7022:ec0c:b0:11d:f44d:1863 with SMTP id a92af1059eb24-11e0326b11fmr5785261c88.11.1765208692251;
        Mon, 08 Dec 2025 07:44:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAjO/iQcpglYWmyAUY5NhlLp8TjzTsbzOXCBjpFZBwT6DwAEkwKSVISxY8b2i+m6RPHCfxhQ==
X-Received: by 2002:a05:7022:ec0c:b0:11d:f44d:1863 with SMTP id a92af1059eb24-11e0326b11fmr5785242c88.11.1765208691771;
        Mon, 08 Dec 2025 07:44:51 -0800 (PST)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-48-76-65-77-217.dsl.bell.ca. [76.65.77.217])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df7552defsm56860378c88.2.2025.12.08.07.44.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Dec 2025 07:44:51 -0800 (PST)
Message-ID: <f8d1e504-2009-4bd6-b1b7-c98c1f49374a@redhat.com>
Date: Mon, 8 Dec 2025 10:44:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] selftests/mm: fix va_high_addr_switch.sh return
 value
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 david@kernel.org, shuah@kernel.org, linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20251207122239.3228920-1-chuhu@redhat.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20251207122239.3228920-1-chuhu@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Tt-rYXfhkEecu2wHVL3a2iqkhgKGQsDz5IQ9yI-P7KI_1765208692
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fk9gc6yh8cnge58gg569ehbmuzxujm4k
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 62055180013
X-HE-Tag: 1765208695-321101
X-HE-Meta: U2FsdGVkX1+JWKzqFJbxkQA7sNiNVc4Gy32R3w42Ck9TczPK6FpA81SFKwim38ZTubhKrz+uYkK6sWE8Uw5HXXzV1qctq2N9UmOVFxTKt08fyD7pBV2GKkp8S6mKZugllDr8RB+U1Ux8nHX8W0tEY8oXvjHp8HVbMWEzn/DZWnwVv8P3s6tC2cfZGFwtdTESsGjzXmvsipuH3uVfa/+YIf/KWUe6Z4Pa24ho5PGqA8C6v0Jd8e8bpc+S60yzVt2MFY8Ww5yprjmlbScUZlM7df5RbbYc5M/D66tz9AyWe3JiFIppo9ge1Ybtje/JKHLUw0i1R7p9nB+a+6HlVhIn/5uoxCzmuEBcRXP9dfgz+vaGlRahyAdTtKYEwyhD8SGQfy79nJtkpCQcy4+WNARP5brASuRmhNi4QPldLw9tP0zUCrS85CqRgeqCcBjtCAHtl9TlmK985Hz2G3lhgFLBVojcjdQeTouLOVIteHwBaXxHCkU46R5cqkPVUuxoZjG5UiSde6TD2jcmMGGF8zdFpdqfobexzbErz5h0ftZFQA/TuZLV0JIBdsnQVevJSrbe1TvUbVtPKVFYTVINgxejfZGZBEPuQvbKbw489AznHRTQrMnURzKfjlbc2VEYuWdK8Hmx85Z8KxgjU0zStW+WT8xVQ+TdwELMC5GxG/R0r8hTsKXT1MUPZ9h2K4+a0hLv0NkBIofI8XEdj6yIGu3QSktQXWerWyavuoSHJIDMmPIfyOgVywYQSnYjrtvovg6KLUyv892fZprZv7gkkaFDOY4h1F3nNm88YalFIO1sJgigO/C+Ghs1Du36Ltcyr0LXjB3IZNayt4pqS+b8HfDM6K8fNkgqxk1AtyPBVnebsVJpl/dHinHo9rJq7YR/IqMol2ffzkJ7FaMhJhguFSC5OMF/cZuD6cajGC80sbocv3EDoKx/K5CkQTnVn0kkaaBWm2YxBFAyOtuMErvevOG
 y6frmXJx
 FF+9xTXN3ypZLAk5mUXfqJ89cdbDXv9MAhMWdRpXlFhX+KAMSLSHvCxU5ug+8skFtnaclGGpiNEmZS6wWq5UMmW+Xn9cz4EpGWXt+iv9iPCtlqWLnREIiMjPNCkIGR8aOMV0iO8Lh0imzXI5G6a3XPsSKc7dcHU65aLj8GU75Xl/5FbWkm8mj1oL4AVreA968mKxpsdA1u4gGXrpctkFC5BsjfW4GbEB/zT8S8HeibTu+m7icrhO7obtHNsN/RG8sq1iRWvVxwFSxMcBh7wK/s94K7kctlWZLpuqSGwDvokuD3nR/fAPgkNvwW8jIY5x/umH1NG4s+5poOPfQB95yE6VRMg85N23mVY1ekifiBZeJD17Fr0eNgUbtyVaHoHh4L51kwjhrfjD1yUtU+P4rbGrYU08VjgzKRKZWGY3EuWo78oV8ABWK3c7rA+HeDMieZBc4Thmaloz3MbH/dQldtpyJu6ns0cUrPDLd/xengIUmtmzWIuXNbP1UIi03fOBGhHp2eaduYkWfiO9zPkuQtyVfcq+gB0zDV1X9wDW2nSaPOHJpBRN8sl06/qQkcUhJu8g1WIvV4g8YWkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-07 07:22, Chunyu Hu wrote:
> Patch series "Fix va_high_addr_switch.sh test failure - again", v1.
> 
> There are two issues exist for the  va_high_addr_switch test. One issue is
> the test return value is ignored in va_high_addr_switch.sh. The second is
> the va_high_addr_switch requires 6 hugepages but it requires 5.
> 
> Besides that, the nr_hugepages setup in run_vmtests.sh for arm64 can be
> done in va_high_addr_switch.sh too.
> 
> This patch: (of 3)
> 
> The return value should be return value of va_high_addr_switch, otherwise
> a test failure would be silently ignored.
> 
> Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
> CC: Luiz Capitulino <luizcap@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

This fix is good, but there are two additional issues that need fixing
(maybe in separate patches):

1. In main() we do:

"""
         ret = run_test(testcases, sz_testcases);
         if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
                 ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
"""

The second run_test() overwrites the return code of the first one, so if
the first fails and the second one succeeds, the test will report
success.

2. The following comment in va_high_addr_switch.sh is wrong in two
counts: there's an eligibility check for powerpc64 and the test doesn't
reject other architectures as it runs on arm64 as well.

"""
     # The test supports x86_64 and powerpc64. We currently have no useful
     # eligibility check for powerpc64, and the test itself will reject other
     # architectures.
"""

For this fix:

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   tools/testing/selftests/mm/va_high_addr_switch.sh | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
> index a7d4b02b21dd..f89fe078a8e6 100755
> --- a/tools/testing/selftests/mm/va_high_addr_switch.sh
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
> @@ -114,4 +114,6 @@ save_nr_hugepages
>   # 4 keep_mapped pages, and one for tmp usage
>   setup_nr_hugepages 5
>   ./va_high_addr_switch --run-hugetlb
> +retcode=$?
>   restore_nr_hugepages
> +exit $retcode










