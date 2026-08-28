Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52262C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 04:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15BF56B0088; Fri, 28 Aug 2026 00:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D296B008A; Fri, 28 Aug 2026 00:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049C66B008C; Fri, 28 Aug 2026 00:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C50946B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:00:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A13D1C1C45
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:00:08 +0000 (UTC)
X-FDA: 85149325296.26.D6BAC8E
Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id EC838A0009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:00:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J0mcbCvY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787889606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PpUui4Aoboix6IYzEwYjY/WN4G5wLu6VM7wBCJYbQ9I=;
	b=lLyR4ox9EMDTy2aQxifdk9/qRPFNJXkWSUNmB3qOqyo5fyWyR+m6+BWlJEx2X9cxWCGv3a
	eADopbZHj8rX02PkF0ke3qtn/19Fpb8FikxJDVpnImLlBzzPuk9DMNRS152YM6FpPYm6/1
	ZidiBsScuxNAJeOHQ1Yogf0SasiWQ3M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787889606;
	b=m2qPBSMyGLszeGeP2qtzjZAPr0CgfoG//kl+cJrVYsvwIjPlYv9MFJLOaO+P0aN+AeZyby
	6oETjIDFYviCn9CNPPja13DNsGJ7sbT070IpEM6gMwwFQPOCqgd5I5fbLcmwU4K7K/+ZBr
	R6eBihk7MZNJT6qpeSdv6CSjXxTEsa8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J0mcbCvY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Zn+AIrmF0AVNoZFHPA81gQXKhbPcNqU7a3t2IJTk6d8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787889604; v=1; x=1788494404;
 b=J0mcbCvYD4VM8SleU+j2QybbNKtChjqZvc27Ti9ifUxxLr6oW5fNcjuvsBesWGc3mQiJkjit
 5NgMyPd56OExI4vzdTisEbj7ZNghoMmbIg+m3qGP2iVVrAIVT87g0+g32JLx7/YSJ5mCTTWSkIg
 s4JF3TUUdk+faxRsid299/wY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 293d25efb3c88b71;
	Fri, 28 Aug 2026 04:00:02 +0000
X-Mizu-Trace-ID: 293d25efb3c88b71
X-Migadu-Flow: FLOW_OUT
Message-ID: <3cb41363-76e8-434b-add3-3cb4b83a6d9e@linux.dev>
Date: Fri, 28 Aug 2026 11:59:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 22/37] mm/damon/sysfs: implement cpumask file under
 sample filter dir
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251208062943.68824-1-sj@kernel.org>
 <20251208062943.68824-23-sj@kernel.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20251208062943.68824-23-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC838A0009
X-Stat-Signature: wstay9m1boi1hfk7hyok4w6t4icfwwbw
X-Rspam-User: 
X-HE-Tag: 1787889605-601910
X-HE-Meta: U2FsdGVkX18BiuH2Qy39AkYb/Wh9PvujR3vr48/qpQzo0kzK4tLQVQPUI2cCXDzGBHm4/YzGvTQo7RGuXqW+0StDfT9vxNIB6MXeJSBqBwzopFfRvs+PuHcMSEGoLbXRLtqTMo2CXNKbGkxPTVVOhw7gKl6jKa3nIw21aDUZbaCJPhooDY58S+fgeCTkPkXLw/yRMc09SanqpC7pqZhp7MpGFkbtR+nuEDe4CtFP3fW+vyBW8mwOb6pYmH3/wx3D6N/+wmYLfGb+NOtYe7pM0bzkdr5qE+eMQQhJGsK/vNexKD0XZSITG/y8Qglpw3267ogYUgNpw1uEMmuxLU4kEx8Xbn1muGIgNGfIhJpuC+OxjaACdBDUCIBOaPt2MqmpOD/9iwHkmrSitHj9Gnj8KPjtVHlwczUzApgnNs4jyjW82Wm5dJQ85l0evm1D0gOPu5JZOKsbQA9OfeqArRXyYLlMJ/Er36dd/gI97A+bozTaiL5Y93mm1olGlUI3U6OrRd98THBpktPK+LUXfDNFB7tb6ZkRXGYazgT4g9pUXCjtc88aiNjshHfRk4OSLn6KDnmanfojiHUjNUZF4UleU6msEaCDKLyvLwk3gI3Cvr2648wGPay/tJTSXlx8reqgBcfSchEaX9D5NUR5yR4Li+TWKwfCvEBava1wNSA+wf/z3NHnM2LQyXsuE49cJRbul1ARL45NYKtYFUEAS/cwCoi1dyq8TwAsBH9J+yPrZCMM6ytaNQv9AxqKjoz+HTT90gkqRYBLJFKlE98/gVX5d2FKF9zPbublC26SVWfnFlocFXl+YC7w3QK52Nf2BzCdSveiHo8ywMihHIxrgJUk92NxPDKzH3w50EkttNi85+ehdRk3jMpw72sNT/IeHhLZZEDhbuXJswFb2LVPs6Zi9qK42hmyJ8RjEMhHeDjs11MRb9MfmwU7FyhYpS7eChMavV918Kd0A3nyLeG+Klq
 lvELIOY4
 Aosx6qS+JTOnfyRure9Acmi1Ys3I/lnK5lZMwKfYywrM0tqVpAkJx1LWfzRZDKr+YVpy9cm+3uJ9XRjUaLgkKs606WWO37KudbjGdlm0GDaR5mox6v5YTU6Slz0ibIoI4sUrxa+5POvSZYI3E/35zNKgQTx9HdtFv3DbA0fnjW2l6eVEyUoMAQ+cegSISmvU3FT1HMR2kCTYB3mBv0DJiXDqe+nw3b9yBYtxFpB41QqDtepKy8OarNBdbbYgfjSqBa5Feyqa4RZm2SaErUBAiJ4DR178YVvmN/Ga53Gc3jtm7aVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/8/25 2:29 PM, SeongJae Park wrote:
> The DAON sample filter directory has files for only common properties.

DAMON

> Add a file to further specify the CPUs to filter in or out.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/sysfs.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 74594e6e461c..d6b0b6513fd1 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -758,6 +758,7 @@ struct damon_sysfs_sample_filter {
>  	enum damon_sample_filter_type type;
>  	bool matching;
>  	bool allow;
> +	cpumask_t cpumask;
>  };
>  
>  static struct damon_sysfs_sample_filter *damon_sysfs_sample_filter_alloc(void)
> @@ -765,6 +766,19 @@ static struct damon_sysfs_sample_filter *damon_sysfs_sample_filter_alloc(void)
>  	return kzalloc(sizeof(struct damon_sysfs_sample_filter), GFP_KERNEL);
>  }
>  
> +struct damon_sysfs_sample_filter_type_name {
> +	enum damon_sample_filter_type type;
> +	char *name;
> +};
> +
> +static const struct damon_sysfs_sample_filter_type_name
> +damon_sysfs_sample_filter_type_names[] = {

Looks like this should be defined in patch #21.

Thanks,
Zenghui

