Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D74C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81426B0156; Wed, 12 Aug 2026 09:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59886B015B; Wed, 12 Aug 2026 09:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95E06B0161; Wed, 12 Aug 2026 09:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 830446B0156
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:42:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01990140387
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:42:22 +0000 (UTC)
X-FDA: 85092731766.14.1B58A68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5C1C6140011
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:42:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6YnCJWl;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786542141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/v3X9kDnaj2Mwr/HHxgw6e3NrNjwRw1A4OPoazOeV+Y=;
	b=7mP3YL5BUSzbk/GhxtCTYVm1j70+DWzzthfuCP2ZxHayB9IRbmO7ZN/RIJ6yEsjhRThrmH
	KPUHLjoyoj1sgRg5R/4Rt5C8Uv7ZBWRnAk5tGO7AVOZlvC3YbrbbUIKk7dIAGdBTTcBgbG
	s1byfqPSQPifqAI3R12kkyZAUzODlms=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786542141;
	b=x/v1Gx83Z2PPOlWJKRACCqZq7xDMWW4sHDAcRd5V9Mp4L+2POB4Oxrs+T7qNsYTyvXyKC8
	a2dPJhYkL79slyj68nlM/MaL1Rq6ny9VGwXB7v9TSN0HhlLxImuRqwo/sb03zjuIqtpnWQ
	gUN0Z7Ogb6vpjIjRtnako9TX8l4aO8I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F6YnCJWl;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9884D40431;
	Wed, 12 Aug 2026 13:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9FC1F000E9;
	Wed, 12 Aug 2026 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786542140;
	bh=/v3X9kDnaj2Mwr/HHxgw6e3NrNjwRw1A4OPoazOeV+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F6YnCJWl07aBrUyTvYaOjCTLeFvwaF3p2SgFe3SAOg5tAl242wTSagMumlOFtMrE6
	 fb2vDsZCP1OZOi2fUXaG3HfKFXoXYNFa4mcZmZDLk7xGZJ4gbpMV6GQPMNZPrI8vdr
	 sUmHWk4NzSqAUjWjDosNI8F0xsKcyrHJ151vHgig0Jiba3RoqdTsbq1i+tfgkcPabe
	 psTIP4pTLwXBvdcm7oJINbvvsJp5DQ44jHowy4CvZ4TeWZh2FOvhmOXsTh9KgHCcVS
	 AKtbmk6aXuJgSUqqNs6MXwLG36TEqTXyBSGuY6PcodtdSfb+Pto5G/kcGuNTU7GvYo
	 Xh5VUcKZJqIsQ==
Date: Wed, 12 Aug 2026 16:42:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, shuah@kernel.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	peterx@redhat.com, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] selftests/mm: restore enable_soft_offline in
 hugetlb-soft-offline
Message-ID: <anx4NBqyMKwqvEGb@kernel.org>
References: <20260812120821.523860-1-husong@kylinos.cn>
 <20260812120821.523860-4-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812120821.523860-4-husong@kylinos.cn>
X-Rspam-User: 
X-Stat-Signature: hj47ri96sfop6kctc637rc3k1zwsne5k
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C1C6140011
X-HE-Tag: 1786542141-294905
X-HE-Meta: U2FsdGVkX198CzgH5v+El0n01ag7ZnwRlU0yPjvhHKhvBCnb//mcJgwmW/HmFZaq9vxmHI26Ly013r04n7rMVAY6L1Anz85CFWBjmoPHpz7HM7sVYzLnsSlhP+77M3OTrzFATL0dq4pK4BMRTearWQ5HWLsuZA3G2Asj4FzcVQOUhVfbO1SMRUxz7RpERh75pAu+bNi46iPLvB55T6B5+az+Eo30jMW6hZnFi7/qCXjlF8Pk09GDz+KDi4hNQSiVnFOs/QPilGkVNOtMTopaP50ftgPgkvK90gGCjUkbCjXnRuvwh2nHGR2q81UYvwxQCtt/Y4JUv6MSg3P0A1Hp85RvtyTdpQ5sWvjEQxcFkRNAsVkNlOfJZx95qm8bivbTjh6yL8UILTXGDs83yPQoGB/hqHtPr1S2uW5eKNFvd4jrHnJ+dT4vbbUW83Geu/S2iB6I37wLzTY7iv5CmbHQSo0/ph0N0/gF+tzZZSIFxog4YbcPLr5sqX+wTn9kbWt/Xg7FQyiqS9TD0QMjB82vedWuhuVjDlx7ReMrGWo3sm+QEidl8pP/CAaMwlxPNulKJSugiIncXoredW+eHT1TJIkrxbc7bW5XJ75KcS81I73Le8xHY2NHcqSAUdwvybM11YAWBZeCoejAyBOTteFCCjQKuUfPJLnZ+lTcWDDS29vISf6OY0GDjbSR7b4DM+uZevJtYeTIUmxDZqrZ6TbB4eeFV9P7uh7S1ytNJwJs8ubFIRrUA24jxu+dK+r+Jsl7Tpga/vWIADN2icxZikFbY0u4UtCJgiY1zJFg/I+lLybnn5o6mLh8uKdj734hsw1CVeL1Mi4p2JU4d9lAt31Asjbhf88bOyuUeEo4sUky66XwJRZbRIqAvMOpcEgAcgD/GVSSu0m5wz+0RHDnRGAKC2u3/eZI9V6eDzG87k9hmsi4NZxcy5TopAHtuJqdwMeHTDQVIcYIe3NIKLXtfy8
 Hrt3rl2j
 3z3saqwaSUFi2rBhm+dXRy7pralRRw1XNBFapWYYwMQPBcExuokTSH7ec412DlqORRjls1zod4XnpUN1TWpXoV5GVq3ksy93NNOoxexkaS+mj1tZHWg7dXkgT2GSR1Ld+S0dmQXhhox0WILvpGs0wOyQA83h4umZfFsBdBJXN+4/20ARIHQE7kS+BH3WR4Csk4w7FF/KImllV6G0+35ifrQYzQhE4zQryT6l8g47CgGeSmGHt3yZ2biI4FfvhMWWdFmDFp/YEJlQKyPodinMe29Fl6motAA751ZcCzc11xjQCpG4D80iP32Wwmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, Aug 12, 2026 at 08:08:21PM +0800, Song Hu wrote:
> hugetlb-soft-offline toggles /proc/sys/vm/enable_soft_offline between 1 and
> 0 (test_soft_offline_common(1) then (0)) and leaves it at 0 when it
> finishes, silently disabling soft offlining for the whole system after the
> run.  Read the original value before the test and restore it before
> ksft_finished().
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  .../selftests/mm/hugetlb-soft-offline.c       | 24 +++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> index bc202e4ed2bd..35dcf661b091 100644
> --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
> +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> @@ -99,6 +99,23 @@ static int set_enable_soft_offline(int value)
>  	return 0;
>  }
>  
> +static int get_enable_soft_offline(void)
> +{
> +	FILE *fp = fopen("/proc/sys/vm/enable_soft_offline", "r");
> +	int value = -1;
> +
> +	if (!fp) {
> +		ksft_perror(EPREFIX "failed to read enable_soft_offline");
> +		return -1;
> +	}
> +	if (fscanf(fp, "%d", &value) != 1) {
> +		ksft_perror(EPREFIX "failed to parse enable_soft_offline");
> +		value = -1;
> +	}
> +	fclose(fp);
> +	return value;
> +}

We have read_num() in vm_util and write_num() that can replace
set_enable_soft_offline().

> +
>  static int create_hugetlbfs_file(struct statfs *file_stat)
>  {
>  	int fd;
> @@ -185,6 +202,8 @@ static void test_soft_offline_common(int enable_soft_offline)
>  
>  int main(int argc, char **argv)
>  {
> +	int orig;

Please spell out what orig is this.

> +
>  	ksft_print_header();
>  
>  	if (!hugetlb_setup_default(8))
> @@ -192,8 +211,13 @@ int main(int argc, char **argv)
>  
>  	ksft_set_plan(2);
>  
> +	orig = get_enable_soft_offline();
> +
>  	test_soft_offline_common(1);
>  	test_soft_offline_common(0);
>  
> +	if (orig >= 0)
> +		set_enable_soft_offline(orig);
> +
>  	ksft_finished();
>  }
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

