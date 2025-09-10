Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 890DECA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 09:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27266B000D; Wed, 10 Sep 2025 05:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7286B000E; Wed, 10 Sep 2025 05:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F016B0010; Wed, 10 Sep 2025 05:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B52546B000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:16:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5789111ADB9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:16:27 +0000 (UTC)
X-FDA: 83872784814.08.CBF67AC
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 554D210000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:16:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k1p+nHJi;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757495785;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWoZ3l7726OX3jB4OzkYOebIG9vuSYZtg5rWWfuavnw=;
	b=lm2WFvCc1HtsHzfst/tJIihsfl5sXdAmJ6qYoRe9BphuBMPsQyembPzmRRHcWRjA0nCae0
	Pcpsngilcsf93IMw57yjD9pdcHWrGBg3dwuVd89t5DFYmMk9gqtWd5bywrfRtNswd91DcM
	ro84kxzaz0w3+RiyT+R0CKv35pCSMw4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k1p+nHJi;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757495785; a=rsa-sha256;
	cv=none;
	b=YOslHq6gD4K51KoEVhvMi9ddtiYzaWSBymu1abI2T2mkNl2OUxwRCw3/vZKcOU/hq+oo8u
	qhMVhLUsNX2/TfPKTUFO8rHuPvuYAwNeIc59925x+Ia4SyCmIdpqn929oHrdwgXDbN9vCL
	qT4NdjoS5Xv4J/rvswhYiLKHyGMXE0g=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b0472bd218bso1011026566b.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757495784; x=1758100584; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iWoZ3l7726OX3jB4OzkYOebIG9vuSYZtg5rWWfuavnw=;
        b=k1p+nHJi2gC9cfYVyWXJwA2VWd4+IErPzd8R3vIO8/KIZSqFjrWhBFpweB8BA/kZne
         Mn4QAMHaDERsXI88fbW86C8Wx4xmxjpb7Vm8cXBrm9uWwyCutmZA3fPSM7oIWSvdLp6d
         s8Yr77l46D7cUhT+9aINVk9DMC71sr0UwJlOCqyRI4LnAlZiNVIJonO5Xg101YX5MTKp
         YxfQM09NS93pKg4k3skiBKXBhStEHTpXsTIz5t482HW9s96VEaGdZYnCAPboWHGzBz72
         GsO0TUfW/cZgNAi1SK/2ezheqIT3aJ3p9caKR3U/ZyfNoW4aS5kBCWE+P1EJ4Sso8Qom
         DQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757495784; x=1758100584;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iWoZ3l7726OX3jB4OzkYOebIG9vuSYZtg5rWWfuavnw=;
        b=b9aQwXxsbFi6zgJCtVEwmmAeof6FMfMo9LBUe0eUtmFNUQAA+iQ/B5i7QQrXMLyBAl
         zwO/IWIbAN+ANCHP1FEY5Xmv3FK5PfC5fJKrPRLskUzV+Bw+IMoex7qgGMRHSZLB0RpK
         PMebiXgq6VN9UjpxwqCMrsgdBMrR9qHtiGMZKz8Fd+PZoEHkZuo3Mp2cNh2jjvdV5WEy
         EQUylkUcO8iHDtnpnroJ2PuEwBySk/7yBLPXFIMrqZYFkxnMSU0arJ8mjYElM17Og/CO
         Whid89UBmfg/tG0XqNotz9V4HHavlg2xOxFSGnFT+aK9SlCXwgfLk2qiR1MOJWBB4YmJ
         f8gw==
X-Forwarded-Encrypted: i=1; AJvYcCWIzZebv6k/a/gzebkgkkeNhfk3y41jvSl8TiEp/fvChTQzRoCmTQFFJrRN4gvyb9NccCzzsAQbBQ==@kvack.org
X-Gm-Message-State: AOJu0YzPubhqz9djGKDjMPbDN0cUKo+Nk+IMnDL76Rz0930Yq7PImvdT
	m3I1wBbA/9i+psoFfki8aIxuaClSnra+0cmV4QRICC9yDnWVey6A7VOH
X-Gm-Gg: ASbGncvrlBFz2+sdDwy6PWClNY5yM00FBXMqeUnqaesZygJ/FwP4pdBkmesmNgXFndY
	OjMWxsBGVgfRbbObV+htQY8hP1CPOrAuqw7r+OZCqfed/ei5XV/1hn9RsdupjfF9RwQEn8yZQdp
	pfCqje127ndvrj6O6+9XnBIFoql/KTXVIMbkqKJ7jP9YAORIn+YqsP113skUYOpOgTScrDyORTE
	4HpxA0D/teNhl4LCTde6/p6EKa0uO6lKPMsGewS09oEcUoh81VCJfjBj/h90qETMEVVfF9zbVrw
	tbQnvEgEO3ZhIkRzb2xjmYjqDWMFGZ6zvriqA4KJuUBZDkcakgzv0R2lo6U/9xALSHUH+P3k4cz
	Iy8WESb1oeeqnKI4YuCCjCO9cZ8KgflMpkCig
X-Google-Smtp-Source: AGHT+IHqqOBwc9MStuYkne49yKfqkD7CJb5YxJGgDsZcBRqDaXnifBZ7VkKR89evu+GCbSRqZYXxQw==
X-Received: by 2002:a17:906:fe46:b0:b04:5cca:9963 with SMTP id a640c23a62f3a-b04b155a032mr1515367266b.41.1757495783403;
        Wed, 10 Sep 2025 02:16:23 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62bfe99ffc0sm2868513a12.6.2025.09.10.02.16.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Sep 2025 02:16:22 -0700 (PDT)
Date: Wed, 10 Sep 2025 09:16:22 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zach O'Keefe <zokeefe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: remove PROT_EXEC req from file-collapse
 tests
Message-ID: <20250910091622.n25zvgw27olskao2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250909190534.512801-1-zokeefe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190534.512801-1-zokeefe@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 554D210000A
X-Stat-Signature: j9s4goq1e8uqwp9kjtu9qjrs9xs4jxf1
X-HE-Tag: 1757495785-212207
X-HE-Meta: U2FsdGVkX19g23RsGuwI6bCvrkXgAhoioxbiqWsqrnLcrSSkxkEwqGcrBA29X53Yy8lH+cG0r9xrYZUEy8Azo/3pk8nBzzH2A6z70COp2u98T0q9bqUNl2t/HGPXQCi8QwUbEKHzMTuUOvCCw2hMcu83y0bS/IhE63IfXTAnPIEsek96XL5T9QcXbSmNk5f2GC4+nIpjGKWsXod/jLuljtw0rzK/6e+S9idOMJn6zw4RH9fDMGYmsRrLzUZM3KYK7en2d5n3ek9wRqDjoPyNwUsszCQc4QFmOugKRzfU1bY+ixttTdk+CGZp69YSClVd9gQkKYICppIEbU+0q1ZRs55QY33lytDS08V0QjJfLWIsiSoiYahPM9Y1UIPa024R+HMv0+VppjPP63EisgsE23lg2ZJY23l9pY+AnSW8WSs6IEUMcz+Qzjw2l1uNijrN4J8PYsIOpH+YfOrtUwfIFGgAeIz7UlOwrJ1m6q4MxppUDodNvdO9Gualvp4EOFXHhv4WUVqykhgfDrX6nJlN6ExLEvf1QDbF0rsC+gCJ/OgQp2dnKwOXAZGCPwc6cPoOhiNg9hlvCG8/lLdw7uumrLRpc3EpdWlkQvUD5LGs1D8aLuILmdCf99cdg7dPagtY6pWgXDBgiSxtk0b8cbJ9U8cCjE9i7AnCKmbzua3aJq4Otf8/2xfn/qf8t3ZIwPxClJw7JVx+RZS4d+CYW+Uql/StJWwm7Tb1ubDh4gKg4/e43j7KqIiIcNuLD2cytct+F5cfmPbpAHCeNxovbSu8lMi56aBodkJTA5WuM/WAU1nb3yZrO40UwwIyx53MyBYzTpZnbtQ9H16afqZI3FHDkOrlQFzgLrhz1nqK84Q+7UMbAZFB1bEfenODHMBreozSs/9DKvCZcheA06vCNmbrP5zfGBjkOm5ZbTwu6jwFL5QffmMh6rvEPqmAD5y6X/CX9nlNJnXzMtfVN030r/V
 OO9HfWq2
 yOycccE5qKH6V+TT9FsC99ggPDN92DssU9fzej2vhv7GmQrs1Ayb/9BZ8nJ5FwXLm7uh1/73YLo3u83Ljn9vicehIPtE4M7wfcpp5nWwkR1eSSBiJb8COtAakS8uYrFwqEMNPQV3CKCRpCKlk4Skxh+sxWxLGOhCF43osA8jqYFWE52SdTdiY/R3l+n+CE5RNi3H9Q1lDAfB9e6GeuexIHUmmeLjkBxhyEVFd0bZUR42PHYfPPv1DNRXXx6ssTDfdX2XehNi3xwCP8E0Isz3now4Hg+xKP/x4cuwX/eQL3+6q3WAOdtpAnN+N/XlNECrVNtss3hHhV4LQhTdxkRNaIyxP7rcCGHXhfOo37SAyt8uCoNdvPFHv1wRvf6mv2Egh7s+JTMuaTdNvuD5j4wG9W+nFmpJjRgukP9QhnpeVGTtFr6Xikc9dYeWrJxLuhDcizjW2JROUAe4rARfQ/tFQ+sIz+ccIRpalyICX3tGYedtN7z9t09HxIG7CeiHcDMAZrmc5HIFu4Cuwy/4GO+R3J2ttWa7GpmHuRKz5Ty9DMT7aN0lc+NfxR8YrEZWZEFCMGAz4vweAH4PO7nYW/F43OHG5fysf9QLNSRAYB9K6F8uYGug3u3Ed174y8oWtMpYnLS+bjJFZEYN4n2RnOCg32tqOYGf/4dYEhlINqOFjsYpSMVSngbvNbP+pNrsjs8+bb30biog16mhaJH0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 12:05:34PM -0700, Zach O'Keefe wrote:
>As of v6.8 commit 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
>thp collapse no longer requires file-backed mappings be created with
>PROT_EXEC.
>

One question, what if user run this new version test on old kernel?

Is there a guideline for user?

>Remove the overly-strict dependency from thp collapse tests so we test
>the least-strict requirement for success.
>
>Signed-off-by: Zach O'Keefe <zokeefe@google.com>
>---
> tools/testing/selftests/mm/khugepaged.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>index a18c50d51141..3fe7ef04ac62 100644
>--- a/tools/testing/selftests/mm/khugepaged.c
>+++ b/tools/testing/selftests/mm/khugepaged.c
>@@ -394,7 +394,7 @@ static void *file_setup_area(int nr_hpages)
> 		perror("open()");
> 		exit(EXIT_FAILURE);
> 	}
>-	p = mmap(BASE_ADDR, size, PROT_READ | PROT_EXEC,
>+	p = mmap(BASE_ADDR, size, PROT_READ,
> 		 MAP_PRIVATE, finfo.fd, 0);
> 	if (p == MAP_FAILED || p != BASE_ADDR) {
> 		perror("mmap()");
>-- 
>2.51.0.384.g4c02a37b29-goog
>

-- 
Wei Yang
Help you, Help me

