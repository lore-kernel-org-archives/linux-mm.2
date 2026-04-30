Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9F6CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C876B0088; Thu, 30 Apr 2026 14:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214646B008A; Thu, 30 Apr 2026 14:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1033B6B008C; Thu, 30 Apr 2026 14:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 015856B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:31:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D0BD160137
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:31:57 +0000 (UTC)
X-FDA: 84716066274.03.05985E2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 327844000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:31:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i+XmagGk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777573915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TbGELHrPLFOQhp06QpDsqTx/eZpkTPeNIqqLpkLs2KU=;
	b=oKlYxVi3tt+1Px02BaQOXZpj0NDs4HOz4RsXIC26eG0QI++cnJewHE21JIjfPdXuldug6L
	jLTlWTApk4EktfePSDwyNPlg2BXBXW4EsJrY/PV1dRy7FBBlXYt40MU1VvgjNrsb8bH0Qd
	DYA/0UO3AghZOJ7T0mODutHj5EtUiOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777573915; a=rsa-sha256;
	cv=none;
	b=vzgt7o7Ubp2gmHq/m/gSiixQ2GmHRuGps/BRgLwsSa211ZcfG9nSqXgWccmlyUf9/zd3sT
	/T2Vpn5hzEoXJPXC33qud37ki6u4Y7gZsq243SG1w2an0neKpzoqjoWJPgefXaYDM5MN4f
	EWWAdBHiB7+j6Se1LLhZluRj1AKNzmo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i+XmagGk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777573914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TbGELHrPLFOQhp06QpDsqTx/eZpkTPeNIqqLpkLs2KU=;
	b=i+XmagGkY4ZRAA7aNAF7hS9oXIMBoyUIzgdNwhFvIsvdA7c4bSWQWwywkAawqoY6SE9UuA
	GBVBeUuMAjZEi8wt5L9COW0Bksh1tLk7a1Hd7wLAdHxh69LAC22eNSyYGLJS03stUOnLgf
	OlyilqfsQUGLDvaNSzZA7oGL2QHgFkk=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-9em7sxKhO0CHWCMf-FN8dA-1; Thu, 30 Apr 2026 14:31:53 -0400
X-MC-Unique: 9em7sxKhO0CHWCMf-FN8dA-1
X-Mimecast-MFC-AGG-ID: 9em7sxKhO0CHWCMf-FN8dA_1777573912
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-6546ccc8989so2432463d50.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777573912; x=1778178712;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TbGELHrPLFOQhp06QpDsqTx/eZpkTPeNIqqLpkLs2KU=;
        b=FI2dNv6xy49M4HIfXnF3T2zYTC754mFMJ+BYtIDk9tEMpWNSPbVlzqkCBOCly4cslA
         e5SGCTXb/XpYTvOVuqXg4W/Bq96EPGFGcI/sCP6sMsOFKydZ3hVttWIh+effiPvvK0xz
         P+cHwKqI/F2x/W5AAH0dskihZciAZhSeU5QkDbfsGJCEnfQVtjECvdaFij4T+Nx3Ptic
         p12nF+ND46bogqJ3OieBFwo4sor5u/OzbOQkHeA3Ht4kdovXh/j8sKmEDi8LVKVQonlC
         PAtNgYXWeoB9/G3n2RgGdmH6A9VhBIftMNeXyoUjZpc8rlfxGWwa7lZH15GsDk0xOWQb
         lrsA==
X-Forwarded-Encrypted: i=1; AFNElJ+ZZ7WjELcWy0YEHYjEdEZhZtDPMQwAnRbXdFhWaFitI6dYifeiJGq9W4LJhQm9uFzNcm4mAvONwQ==@kvack.org
X-Gm-Message-State: AOJu0Yy/XWLQA9kDrwa+doWmIi+YFqvfLS3dAIY/jR4JAK4utC0aYdyy
	MzJCaZ129hpsfaMMjigZVDEDYeTNiRqKM0YJuAv3gK2d7Nz78FAZJ8xlKCSB99tcikiTEY19V4X
	XUuNJr/8hLAvdpj8iCQYXl3Zbuo0oRYikqhmVdAkFc5WGxEav9AeB
X-Gm-Gg: AeBDiet62sfybrmBA6CXPTCJwv9Nl3jqyo9kdNEXxwYFtBWNDBQAG7TDlUjh/+3PKHq
	EcLKNRv6b/H7wxRwXdjcecY6vdTYwhJD7Qs9zLCBOFs4wxk6wJPA/bYl4WmV3IJTgu+qeugP/xa
	TNtkgFW0T3zkA10aeRgZVS/71cfcU3/mhyBIH/FoUFNyPFYSEboKRXdufHnhKFoCz9BDHxrpfK6
	hWo+aC/JGASIVrtOpq9L7uI9y14iMzzblA1ZhHoNRvXE34OK6HV4kzR5weQA4KvIKTx9Tmy4xpn
	S0J+B8dCHIslrEFS59nOjpqJnWBASttuY+17o10EMq9WlYOyGbz7YfeSwXiDtUbdpsqJfGy2k75
	S+I42P4uJTP2J8QMx/eUZSWOi+mJmaoOch4m1VeZbTVrq/i6i/K/cBOmlUuInZQtg7wop3rruuu
	3+yrKX8qSVsU7uGV4f/DOyZ88=
X-Received: by 2002:a05:690e:b48:b0:65c:1f97:2c36 with SMTP id 956f58d0204a3-65c1f972f36mr3030224d50.4.1777573911941;
        Thu, 30 Apr 2026 11:31:51 -0700 (PDT)
X-Received: by 2002:a05:690e:b48:b0:65c:1f97:2c36 with SMTP id 956f58d0204a3-65c1f972f36mr3030035d50.4.1777573910300;
        Thu, 30 Apr 2026 11:31:50 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b3ff343daasm27187316d6.21.2026.04.30.11.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 11:31:49 -0700 (PDT)
Message-ID: <2f443474-4448-462e-bc1e-55bc657d70ba@redhat.com>
Date: Thu, 30 Apr 2026 14:31:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 27/54] selftests/mm: hugepage_settings: add APIs for
 HugeTLB setup and teardown
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
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-28-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-28-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YM5KR75Nchb29Exb0w7N6RBnUhswJSJlSoglsxaUGfI_1777573912
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 327844000A
X-Stat-Signature: 96gky617zck83px5xnwaacqsnrsi7koj
X-Rspam-User: 
X-HE-Tag: 1777573915-69699
X-HE-Meta: U2FsdGVkX1+IXIEczdoiG7Rcywme706oqjYZ18+JqoujCQYaMUKP6DQJ4jJPANTfhRW+GwFcW7tjaGjDJM8DB0YOCxtwRUldDI4V3DhcCnhQvmq+oRzxfKnrVAozfPAqXzXfT1KOwUy8tWXK6/KOJ32NUxKcf4L5K1uEt9SwkAJIu1FBqOe/idpej734hdG5NMV/0V6JwQD5enhE3HXFBcJKqZDiAqztTy8UKi+O4JWzcPLlvcFkIf9c802UuRr3uwt8Y48VDrkPrm2Qej+JaX9dJiIVPCKwpSkheSqXYru/8AaxCogVbJMiNdHHybdYI9QuAvlcmZewM5HYtUh7Al4Fz89aNvLUMSsPnYQWeKsvXzXWVREMimFe379H6gOzwRlipKM4CKc0zL0YDR7gOGCKUBinyH80uIMryF/NC7BNeZRRgju07+kyf/QSiKCX/Tm6m0LBY6fiUadDcOKzB7XuMu9ofNqEaMt29PHn91/vwFGzL1Hmzot0mr7glriDOL5Nzwrg3trKWHl42dYvdtAUA4NtuVCSTOFOKA/OBzm3zK5dJc+ddDwT/oRg5gNHMv+uYBV2BPsa0SAMm+LtozFBDiExEuBw/hw74AGs/CWfMm+2EBImwflWiuAA4IN5qgDUEWAN5lb8/TMeLbKGJ+1iTmCPRDo1+u1zzXXXmI2oGDc572Mi+tQ924w74px7YJwS4BZ1ICBUT5ZXOftlteQ+LqE9Tqbd+ZxQsfeQFN2EcuRvwn0iVaXS5D1XGUXTOCME7z8mFU7KBjgvfNSPapdS4dyZgjC0TrPGEvhxnAuvVvRtf1UnVBOIp6K6d4MeKi+wvWp+klE7YR68Urq52NJtL/PcDRI6QQQswfdr4LSGxMhNhOZ1pVOWVXLU4ejYVvVzX+ZjB3MAnuk9K91rKwz87BjEIFPcAhXGukD2aQ5UyCDztC72vQzm4j4TvQfuCwMRmbNrUedlWqn4No4
 OB+WQUfx
 76KJYjKfi1ejGu8WKDcHWh0+WspLoUnnbXwb8NNIAJzQlotnJz5b2o7RFDwJQDP1avO88+hVGiEUt1EsOsasAEgg7ppGGv2Io0qZtue0TtQ1za9C+I+Zc+VHmF/Zse6t6OPldc6E+2r235JWiPAqxc0fCr/WKlcPesGxjupKPNOXfxN3frr1oBm5fD33CjPb5NpoTirwPz28HESAWh7l5rsvkOih+PfKwzGFtkiuRgw2V5x0NAsSd8MlqbG+ua9XWxa1Ifcrj1HIzujrgTBbRop29/UjP1dCcBFQAft7R4SFyUzcJ5JsQ8j77GlUl0XeKOMUEXWxnG5bckz9lmY0/S7p6IK2a09k/oiOYq0dNwM2Ra8Vwly1n5ZOn1iQs7/PfS0TjqgKwG7z1tgr7huKzMRekwkTN0xERJXZr0uuvnRx3VD6SRy7LuaI6DaPD+tW3mngUl73WXU9tw8NbqKrDQpFQO7FBY81AbSOkKrEZs7yE5LevWJFVN+mTNxJ6FzKqSxk1t2sSKQvNkBttCUXm0FKWhZSqUX+gAq8O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:42, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> A lot of tests require free HugeTLB pages. Some need just a few default
> huge pages, some need a certain amount of memory available as HugeTLB, and
> some just skip lots of tests if huge pages of all supported sizes are not
> available.
> 
> This all resulted in a huge mess in run_vmtests.sh that sets up some huge
> pages, adjusts them later and restores some of the settings if the stars
> align.
> 
> Add APIs that allow saving the state of HugeTLB and setting up the desired
> amount of HugeTLB pages.
> 
> Saving the state also registers atexit() callback and signal handler that
> will ensure restoration of HugeTLB state.
> 
> Since many tests use both HugeTLB and THP, the atexit() callbacks and
> signal handler are restoring both.
> 
> For kselftest_harness tests that run fixture setups and test in child
> processes add a constructor that will save and restore settings in the main
> process.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   .../testing/selftests/mm/hugepage_settings.c  | 178 +++++++++++++++---
>   .../testing/selftests/mm/hugepage_settings.h  |  30 ++-
>   2 files changed, 183 insertions(+), 25 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index 4ae7332b5e1b..9d31b53dbc67 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -306,31 +306,12 @@ void thp_restore_settings(void)
>   		thp_write_settings(&saved_settings);
>   }
>   
> -static void thp_restore_settings_atexit(void)
> +static void __thp_save_settings(void)
>   {
> -	thp_restore_settings();
> -}
> -
> -static void thp_restore_settings_sighandler(int sig)
> -{
> -	/* exit() will invoke the thp_restore_settings_atexit handler. */
> -	exit(KSFT_FAIL);
> -}
> +	if (!thp_available())
> +		return;
>   
> -void thp_save_settings(void)
> -{
>   	thp_read_settings(&saved_settings);
> -
> -	/*
> -	 * setup exit hooks to make sure THP settings are restored on graceful
> -	 * and error exits and signals
> -	 */
> -	atexit(thp_restore_settings_atexit);
> -	signal(SIGTERM, thp_restore_settings_sighandler);
> -	signal(SIGINT, thp_restore_settings_sighandler);
> -	signal(SIGHUP, thp_restore_settings_sighandler);
> -	signal(SIGQUIT, thp_restore_settings_sighandler);
> -
>   	thp_settings_saved = true;
>   }
>   
> @@ -399,11 +380,31 @@ bool thp_is_enabled(void)
>   	return mode == 1 || mode == 3;
>   }
>   
> +#define HUGETLB_MAX_NR_PAGESIZES 10
> +struct hugetlb_settings {
> +	unsigned long free_hugepages[HUGETLB_MAX_NR_PAGESIZES];

It looks like we don't actually use this in the API or maybe I'm missing
something?

Otherwise, the API looks great to me. But if you allow me to bikeshed :)

I think I'd do:

struct hugetlb_state {
	unsigned long nr_hugepages;
	unsigned long size;
};

struct hugetlb_settings {
	struct hugetlb_state hstate[HUGETLB_MAX_PAGESIZES];
	unsigned long default_size;
	int nr_sizes;
};

Maybe for the future...

> +	unsigned long nr_hugepages[HUGETLB_MAX_NR_PAGESIZES];
> +	unsigned long sizes[HUGETLB_MAX_NR_PAGESIZES];
> +	unsigned long default_size;
> +	int nr_sizes;
> +};
> +
> +static struct hugetlb_settings hugetlb_saved_settings;
> +bool hugetlb_settings_saved;
> +
>   int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
>   {
> -	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
> +	static struct hugetlb_settings *settings = &hugetlb_saved_settings;
> +	DIR *dir;
>   	int count = 0;
>   
> +	if (settings->nr_sizes) {
> +		for (count = 0; count < settings->nr_sizes; count++)
> +			sizes[count] = settings->sizes[count];
> +		return settings->nr_sizes;
> +	}
> +
> +	dir = opendir("/sys/kernel/mm/hugepages/");
>   	if (!dir)
>   		return 0;
>   
> @@ -427,11 +428,16 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
>   
>   unsigned long default_huge_page_size(void)
>   {
> +	static struct hugetlb_settings *settings = &hugetlb_saved_settings;
>   	unsigned long hps = 0;
>   	char *line = NULL;
>   	size_t linelen = 0;
> -	FILE *f = fopen("/proc/meminfo", "r");
> +	FILE *f;
>   
> +	if (settings->default_size)
> +		return settings->default_size;
> +
> +	f = fopen("/proc/meminfo", "r");
>   	if (!f)
>   		return 0;
>   	while (getline(&line, &linelen, f) > 0) {
> @@ -479,3 +485,127 @@ unsigned long hugetlb_free_pages(unsigned long size)
>   
>   	return read_num(path);
>   }
> +
> +bool hugetlb_setup_default(unsigned long nr)
> +{
> +	unsigned long size;
> +
> +	hugetlb_save_settings();
> +
> +	size = default_huge_page_size();
> +	hugetlb_set_nr_pages(size, nr);
> +
> +	return hugetlb_free_pages(size) == nr;
> +}
> +
> +unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
> +			    int max)
> +{
> +	unsigned long enabled[10];
> +	int nr_sizes = 0;
> +	int nr_enabled;
> +
> +	hugetlb_save_settings();
> +
> +	nr_enabled = detect_hugetlb_page_sizes(enabled, ARRAY_SIZE(enabled));
> +	if (!nr_enabled)
> +		return 0;
> +
> +	if (nr_enabled > max) {
> +		ksft_print_msg("detected %d huge page sizes, will only test %d\n", nr_enabled, max);
> +		nr_enabled = max;
> +	}
> +
> +	/* If HugeTLB is supported, request 2 HugeTLB pages of every size. */
> +	for (int i = 0; i < nr_enabled; i++) {
> +		hugetlb_set_nr_pages(enabled[i], nr);
> +		if (hugetlb_free_pages(enabled[i]) < nr)
> +			continue;
> +
> +		sizes[nr_sizes++] = enabled[i];
> +	}
> +
> +	return nr_sizes;
> +}
> +
> +static void __hugetlb_save_settings(void)
> +{
> +	struct hugetlb_settings *settings = &hugetlb_saved_settings;
> +	int nr_sizes;
> +
> +	settings->default_size = default_huge_page_size();
> +	if (!settings->default_size)
> +		return;
> +
> +	nr_sizes = detect_hugetlb_page_sizes(settings->sizes,
> +					     HUGETLB_MAX_NR_PAGESIZES);
> +	if (!nr_sizes) {
> +		settings->default_size = 0;
> +		return;
> +	}
> +
> +	for (int i = 0; i < nr_sizes; i++) {
> +		unsigned long sz = settings->sizes[i];
> +
> +		if (!sz)
> +			continue;
> +
> +		settings->free_hugepages[i] = hugetlb_free_pages(sz);
> +		settings->nr_hugepages[i] = hugetlb_nr_pages(sz);
> +	}
> +
> +	settings->nr_sizes = nr_sizes;
> +	hugetlb_settings_saved = true;
> +}
> +
> +void hugetlb_restore_settings(void)
> +{
> +	struct hugetlb_settings *settings = &hugetlb_saved_settings;
> +
> +	if (!hugetlb_settings_saved || !settings->default_size)
> +		return;
> +
> +	for (int i = 0; i < HUGETLB_MAX_NR_PAGESIZES; i++) {
> +		unsigned long sz = settings->sizes[i];
> +
> +		if (!sz)
> +			continue;
> +
> +		hugetlb_set_nr_pages(sz, settings->nr_hugepages[i]);
> +	}
> +}
> +
> +static void hugepage_restore_settings_atexit(void)
> +{
> +	if (thp_settings_saved)
> +		thp_restore_settings();
> +	if (hugetlb_settings_saved)
> +		hugetlb_restore_settings();
> +}
> +
> +static void hugepage_restore_settings_sighandler(int sig)
> +{
> +	/* exit() will invoke the hugetlb_restore_settings_atexit handler. */
> +	exit(KSFT_FAIL);
> +}
> +
> +void hugepage_save_settings(bool thp, bool hugetlb)
> +{
> +	if (!thp && !hugetlb)
> +		return;
> +
> +	if (thp)
> +		__thp_save_settings();
> +	if (hugetlb)
> +		__hugetlb_save_settings();
> +
> +	/*
> +	 * setup exit hooks to make sure THP settings are restored on graceful
> +	 * and error exits and signals
> +	 */
> +	atexit(hugepage_restore_settings_atexit);
> +	signal(SIGTERM, hugepage_restore_settings_sighandler);
> +	signal(SIGINT, hugepage_restore_settings_sighandler);
> +	signal(SIGHUP, hugepage_restore_settings_sighandler);
> +	signal(SIGQUIT, hugepage_restore_settings_sighandler);
> +}
> diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
> index 57fbf2f57e13..d6a1b4e5f734 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.h
> +++ b/tools/testing/selftests/mm/hugepage_settings.h
> @@ -6,6 +6,8 @@
>   #include <stddef.h>
>   #include <stdint.h>
>   
> +void hugepage_save_settings(bool thp, bool hugetlb);
> +
>   /* Transparent Huge Pages (THP) */
>   
>   enum thp_enabled {
> @@ -79,7 +81,11 @@ struct thp_settings *thp_current_settings(void);
>   void thp_push_settings(struct thp_settings *settings);
>   void thp_pop_settings(void);
>   void thp_restore_settings(void);
> -void thp_save_settings(void);
> +
> +static inline void thp_save_settings(void)
> +{
> +	hugepage_save_settings(/* thp = */ true, /* hugetlb = */ false);
> +}
>   
>   void thp_set_read_ahead_path(char *path);
>   unsigned long thp_supported_orders(void);
> @@ -97,6 +103,13 @@ unsigned long hugetlb_nr_pages(unsigned long size);
>   void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
>   unsigned long hugetlb_free_pages(unsigned long size);
>   
> +static inline void hugetlb_save_settings(void)
> +{
> +	hugepage_save_settings(/* thp = */ false, /* hugetlb = */ true);
> +}
> +
> +void hugetlb_restore_settings(void);
> +
>   static inline unsigned long hugetlb_nr_default_pages(void)
>   {
>   	unsigned long size = default_huge_page_size();
> @@ -127,4 +140,19 @@ static inline unsigned long hugetlb_free_default_pages(void)
>   	return hugetlb_free_pages(size);
>   }
>   
> +static inline bool hugetlb_available(void)
> +{
> +	return default_huge_page_size() != 0;
> +}
> +
> +bool hugetlb_setup_default(unsigned long nr);
> +unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
> +			    int max);
> +
> +#define HUGETLB_SETUP_DEFAULT_PAGES(nr_pages) \
> +static void __attribute__((constructor)) __hugetlb_setup_default(void)	\
> +{									\
> +	hugetlb_setup_default((nr_pages));				\
> +}
> +
>   #endif /* __THP_SETTINGS_H__ */


