Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B617DCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 19:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF1E6B0005; Wed, 13 May 2026 15:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7336B0088; Wed, 13 May 2026 15:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFF076B008A; Wed, 13 May 2026 15:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE6876B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:50:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 888811C033E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:50:50 +0000 (UTC)
X-FDA: 84763439460.16.92DE40A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 19037C000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:50:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NSPy73qN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778701848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tznq59GQix5Xa32WSC2NKVF0l1LzcTg3d6SxGF8a4kQ=;
	b=lxbyz3ac7PNCaVkXCEAbt0elxAeLM5vHH0fkkAkFWWEU7n9QgubQS4AOD2A+9fFjbf1tp1
	VRHooHJBMetucOoWFbCRtxz3JXKg2ggEYplpfAXWgHGx3iQOsnp5eqnGpTWMk4arRjjU4X
	UM00pbZeX+uCPtzNWDETqvpKthRXEYM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778701848; a=rsa-sha256;
	cv=none;
	b=XmX0wjIlIouBnbh+uv2RBwRSH9qnxFcrb08i5Kz3qTNCgWSOa3ozp+Poc/Zo/2RLOLlaR2
	xi99pGg/oUVE7iq2XB2nh8QS5idsI8K3g1QVUUtidiq8kRz01+vCMU4AbErUJ1tUaY1Qhk
	C+QYT9f5wbspP5Ao/EwOBDVVL5KlUmg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NSPy73qN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778701847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tznq59GQix5Xa32WSC2NKVF0l1LzcTg3d6SxGF8a4kQ=;
	b=NSPy73qNHXHGx47SsR7QdgdH0/8oClohCpsc/TyDq8/NwfCcaDaNaucB+A+XYuuLL5+L4i
	y0IndqoGmQOvQQq9JjS9RPFzL5zuBLMwXNpii+dA40RXfRl3FwZ9aMqOHiiTVHH6fT269z
	rSAlV05A0NDS9vPVyDl6MjqVPk1gt8I=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-3QpBfXmIOEC50SHhe6CTAA-1; Wed, 13 May 2026 15:50:42 -0400
X-MC-Unique: 3QpBfXmIOEC50SHhe6CTAA-1
X-Mimecast-MFC-AGG-ID: 3QpBfXmIOEC50SHhe6CTAA_1778701842
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8acb85a973cso89690886d6.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 12:50:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778701842; x=1779306642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tznq59GQix5Xa32WSC2NKVF0l1LzcTg3d6SxGF8a4kQ=;
        b=YtHHozTvgJLNmuCAczPSE3JsaS0qJogFbxP8LnvwTdpanG36mkXazuU55PSgWhH1oH
         DZT5ZmUcoVE4BKPWpT7UR5/v6eIazQ9oIhRgnrSq+q50KhxmxH/xo/n9ZTH15ysCy5UX
         zJ8laPzLskb/QcCmxYcJ2qpvgtSU3Kd2ly36dUGEtv+E+ylZo6tIGkYpcmpciptPpnpD
         MvE1fj7zY/axxDb4X9Z8PCCQEYXHglA2rLq5shg6xX0y1yo6t+jAbp5hEMYpo/bS7/s2
         N1uh3kKG2V9oQg6JHZF3+qIDw8XjmgdH5O+S/SalJVVGQx+R0zHvUVPS0bULMoJIZ/FN
         StHQ==
X-Forwarded-Encrypted: i=1; AFNElJ/LSSLspc9J1eFo5UM78dv6LEYfyHahR1/Ku94F9UHLjcQj9hyCeQbH78DMBk+f/pxcrnMmvr8Rbw==@kvack.org
X-Gm-Message-State: AOJu0YxrQoDMl6hM7kP1XUlfh+Hek02LIkJxxcMAwPTruxBhMb6ekJHp
	q5F2ww6hqicXg8Qf+1QRNrxEqUoKF+ME1jku7IfrB1pfSOdfetLEJ3QI1PWeaz1raUDmLj3iXlH
	me2DEzJY45GT/AcwsNKtx/idaLz/ElN3Y+5D9287vM2wcX4ZL/CgO
X-Gm-Gg: Acq92OGqf6fSViJVmYUnuwXAUtF6dSm1PMtmhmsaqHdNSK8LMM9uwciATsheVmRfV0E
	QXn9+uWOrdPZfI50swhKprZfcdHqRT7L0ml17f4tecu2SVFzYgFtUdurK0n9ALyIZVxoC9eNyP/
	vI2ZDKKsGvFd7eHJty2Q8JYiTF9K3YR5nnlJ74NE583qfnnUHeM8WMzYJKs8WNJzCHAcxpHBdUY
	AdqgV9nKTImb21Q6VTFu6X1AkjotvKOVGnT/wEqgtyBXWmasdxX034qx/CQEmAVoY6OxhmsxpTa
	Zu8mYBHRiUdAK049seLvu/JKNs54WmJdnkSA95flyeq2QFE+1X/cBf6OQM2SpGrtZxuu3uOar6O
	TP+mxZ6vKMSOQjbQahUxU5eRenbdaCWwc6F+w7cX72exeKA82/eDbNnNyfZMyzGqiMWJEigaxrh
	wI1AMfbufRUz8l
X-Received: by 2002:a05:6214:ca2:b0:8ac:a553:528c with SMTP id 6a1803df08f44-8c7dfdbab72mr69192546d6.42.1778701841715;
        Wed, 13 May 2026 12:50:41 -0700 (PDT)
X-Received: by 2002:a05:6214:ca2:b0:8ac:a553:528c with SMTP id 6a1803df08f44-8c7dfdbab72mr69191846d6.42.1778701841137;
        Wed, 13 May 2026 12:50:41 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90b2db84asm4478246d6.29.2026.05.13.12.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 12:50:40 -0700 (PDT)
Message-ID: <635a6440-9339-49fb-ad9b-ee2f4b285ef6@redhat.com>
Date: Wed, 13 May 2026 15:50:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 28/55] selftests/mm: hugepage_settings: add APIs for
 HugeTLB setup and teardown
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Li Wang <li.wang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260511162840.375890-1-rppt@kernel.org>
 <20260511162840.375890-29-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260511162840.375890-29-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M_STcBz3eFrpDQ0R8kzmPm1_ifgFyPxEQd4wRqsDrDM_1778701842
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 19037C000B
X-Stat-Signature: yffsh7r4by47ubm6u551w49ce8r536an
X-Rspam-User: 
X-HE-Tag: 1778701847-182922
X-HE-Meta: U2FsdGVkX18Lr48uRONcgfu40REGt+2ez+oT4/M56w+ifaKQEcSdCS7LidHeozm7wUfRHPFSKPIgoUxkssNw2E1Udp9RjU+KVPCgMloAgDU03XLtVyvjKhwTmcMjTbsBAwqR/voCjv9BvBXsF/WqVPO3BiL2aF8u9Ftp9QZDqUyjVOu8h0oHoT6m5ZDwRhcK4BV2C4N0/w0BolDOTblwtG3XwVn+utMW3iFQolIQqru8CVptjurlO0xFkQXIy3qMdROVGdnMEQ5f5rg4pVPbkcmNiinfIhO7llPBcGMxRom51/CLMecPNZhfXlPHsC5TRuLLNNo9jhVpd02oROBrqfCep1ghAZ0bKb3W8ujz2jAN6wcrot1VfepvV6SdIQic3ZxRaA094U27MlawpbyUZBEVfT68WM3C7C+G4vdQzabnZgP1A9xe8IDKI5fmIuM4ei8gnCK/RCXBSHpz4GBtmBXJA0k0JYsEU93UcSX5ys8lAvRAKH7/QNIV6aYh1wbm6vwk3MjuEUp/IhPOFR4K0ihouoUhg1GyVnGZUwBk0lNma0G7EqqucunWDR0vwy66nIHlk6MJm/bZCtv/hUIBUNCSxNt3CPKSvUlhPxRigcIRieAcBV8LYIS90pjmAmAvlWoerS1OZJ5m/BGeAG0JAqqOZiTbUUzZTqJaB+iFw1SEFAhrqr5qHvB0VWrBU1wIxruivpwbyC1PqrAnRI4DteVCL66qztwlF00b6HlSw4nh4UDAbVI5SlPrjItJsVYcd/m8cGoIM4CTsf8uODBKccaPY6UgujjQLVe1h6spJpQxK8HfIGRd9c/8lRKDGuFtu2MVK4iD+2yfI8ULedBARukdDPfszWh7IA8H387F2BKBH474jNshvMJTs2FX8IzISUeZIdyIPPM1j9aIaTgpQgpYT6envfFAB0EklgnNPzFSrDsnQ4sz0jH373AM8PkUMT/AjkJzuJ/ijnebI+e
 rubQoKW9
 WXuI5EKknpMI1yB9PssYKCb9UR9elyq85uO6hKYAZIARoTZSnUY8iFUifzfWridjrVXHp3Me89BxLKZqAMnEQ1qU55mhXI7rZmgQK0ScjFus6mvHlT/qJwuWFKHVCviqMI6cFkISrjuxGtCILsESdutC/s0sMIm0yrI5brJlGwyeb50awCxl7mylWlTC8qlkxvKzgGOcT82JyanEgwHt/SaYouhmFCLokG15omSu7NNKX5xFh44dLCr00XG5J327bVNkj8YXAtKyYnZkb/vhs1n8p5qlJQVN3/ddAVQnIyLSIUAVJ/aBWtZxhiktyQEDCD12vKT6ulDEkhF9whYe2h3NJuT3bAPiLRqszLTb2NR0C2KSQnLVDQATJxO80qX9aMaos8IUVuEo0HqEZDA0OW0tuYfXWr1l9wkJBGYf+jj72pspoEbLSEY2JmR4scthoAooPpYFTGy6X8eQjNs0QJJHp0Hb1p5+jfyw7YUo68HgQLGHQu1SGMsiMhIrbdd0QmZwk85omV6/WX8uhN36FrYNqmV6ghNwOvU4fIj28fhzCsJwu6aFiIvKttAokGHfjviW1U6DBK2At5Bg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-11 12:28, Mike Rapoport wrote:
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
> Tested-by: Luiz Capitulino <luizcap@redhat.com>
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   .../testing/selftests/mm/hugepage_settings.c  | 205 ++++++++++++++++--
>   .../testing/selftests/mm/hugepage_settings.h  |  31 ++-
>   2 files changed, 213 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index 3c944d28d14a..01a557f372d1 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -306,31 +306,16 @@ void thp_restore_settings(void)
>   		thp_write_settings(&saved_settings);
>   }
>   
> -static void thp_restore_settings_atexit(void)
> +static void __thp_save_settings(void)
>   {
> -	thp_restore_settings();
> -}
> +	if (!thp_available())
> +		return;
>   
> -static void thp_restore_settings_sighandler(int sig)
> -{
> -	/* exit() will invoke the thp_restore_settings_atexit handler. */
> -	exit(KSFT_FAIL);
> -}
> +	if (thp_settings_saved)
> +		return;
>   
> -void thp_save_settings(void)
> -{
>   	thp_read_settings(&saved_settings);
>   	thp_settings_saved = true;
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
>   }
>   
>   void thp_set_read_ahead_path(char *path)
> @@ -398,11 +383,32 @@ bool thp_is_enabled(void)
>   	return mode == 1 || mode == 3;
>   }
>   
> +#define HUGETLB_MAX_NR_PAGESIZES 10
> +struct hugetlb_settings {
> +	unsigned long nr_hugepages[HUGETLB_MAX_NR_PAGESIZES];
> +	unsigned long sizes[HUGETLB_MAX_NR_PAGESIZES];
> +	unsigned long default_size;
> +	int nr_sizes;
> +};
> +
> +static struct hugetlb_settings hugetlb_saved_settings;
> +static bool hugetlb_settings_saved;
> +
>   int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
>   {
> -	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
> +	static struct hugetlb_settings *settings = &hugetlb_saved_settings;
> +	DIR *dir;
>   	int count = 0;
>   
> +	if (settings->nr_sizes) {
> +		if (settings->nr_sizes < max)
> +			max = settings->nr_sizes;
> +		for (count = 0; count < max; count++)
> +			sizes[count] = settings->sizes[count];
> +		return count;
> +	}
> +
> +	dir = opendir("/sys/kernel/mm/hugepages/");
>   	if (!dir)
>   		return 0;
>   
> @@ -426,11 +432,16 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
>   
>   unsigned long default_huge_page_size(void)
>   {
> +	static struct hugetlb_settings *settings = &hugetlb_saved_settings;
>   	unsigned long hps = 0;
>   	char *line = NULL;
>   	size_t linelen = 0;
> -	FILE *f = fopen("/proc/meminfo", "r");
> +	FILE *f;
> +
> +	if (settings->default_size)
> +		return settings->default_size;
>   
> +	f = fopen("/proc/meminfo", "r");
>   	if (!f)
>   		return 0;
>   	while (getline(&line, &linelen, f) > 0) {
> @@ -478,3 +489,153 @@ unsigned long hugetlb_free_pages(unsigned long size)
>   
>   	return read_num(path);
>   }
> +
> +static bool __hugetlb_setup(unsigned long size, unsigned long nr)
> +{
> +	unsigned long free = hugetlb_free_pages(size);
> +	unsigned long total = hugetlb_nr_pages(size);
> +
> +	if (free >= nr)
> +		return true;
> +
> +	hugetlb_set_nr_pages(size, total + (nr - free));

We're using 'total' to preserve the HugeTLB reservation that's already
there, right? I guess this won't have the desirable effect because the
tests calling hugetlb_setup_default_exact() will override this anyways.

Having said that, this is just a minor nit and not a bug, so:

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> +
> +	return hugetlb_free_pages(size) >= nr;
> +}
> +
> +bool hugetlb_setup_default(unsigned long nr)
> +{
> +	unsigned long size;
> +
> +	hugetlb_save_settings();
> +	size = default_huge_page_size();
> +	if (!size)
> +		return false;
> +
> +	return __hugetlb_setup(size, nr);
> +}
> +
> +bool hugetlb_setup_default_exact(unsigned long nr)
> +{
> +	unsigned long size;
> +
> +	hugetlb_save_settings();
> +	size = default_huge_page_size();
> +	if (!size)
> +		return false;
> +
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
> +	/* request nr HugeTLB pages of every size. */
> +	for (int i = 0; i < nr_enabled; i++) {
> +		if (!__hugetlb_setup(enabled[i], nr))
> +			continue;
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
> +	if (hugetlb_settings_saved)
> +		return;
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
> +	/* exit() will invoke the hugepage_restore_settings_atexit handler. */
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
> +	 * setup exit hooks to make sure THP and HugeTLB settings are
> +	 * restored on graceful and error exits and signals
> +	 */
> +	atexit(hugepage_restore_settings_atexit);
> +	signal(SIGTERM, hugepage_restore_settings_sighandler);
> +	signal(SIGINT, hugepage_restore_settings_sighandler);
> +	signal(SIGHUP, hugepage_restore_settings_sighandler);
> +	signal(SIGQUIT, hugepage_restore_settings_sighandler);
> +}
> diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
> index 436f4ce02984..c07722b7f102 100644
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
> @@ -127,4 +140,20 @@ static inline unsigned long hugetlb_free_default_pages(void)
>   	return hugetlb_free_pages(size);
>   }
>   
> +static inline bool hugetlb_available(void)
> +{
> +	return default_huge_page_size() != 0;
> +}
> +
> +bool hugetlb_setup_default(unsigned long nr);
> +bool hugetlb_setup_default_exact(unsigned long nr);
> +unsigned long hugetlb_setup(unsigned long nr, unsigned long sizes[],
> +			    int max);
> +
> +#define HUGETLB_SETUP_DEFAULT_PAGES(nr_pages) \
> +static void __attribute__((constructor)) __hugetlb_setup_default(void)	\
> +{									\
> +	hugetlb_setup_default((nr_pages));				\
> +}
> +
>   #endif /* __HUGEPAGE_SETTINGS_H__ */


