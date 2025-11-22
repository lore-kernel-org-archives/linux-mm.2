Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCF22CFC50C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 05:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05A096B0012; Sat, 22 Nov 2025 00:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00AD56B0022; Sat, 22 Nov 2025 00:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B596B0023; Sat, 22 Nov 2025 00:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF9086B0012
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:23:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 965218A0A6
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 05:23:00 +0000 (UTC)
X-FDA: 84137098920.22.C2CCD63
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id E180F40002
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 05:22:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=O71ZRjK7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763788979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctiiXJqj43yt6JFDqmOGbkwRPsJgQSrgpqu+YQaEadw=;
	b=dLkUWYqgZnRSS2xgSssNLgxxTUTbp6oWtVUEybumdexBCn4F+NpnskUq2u2rxje1et9dKk
	fiYrRF5CM0YBwfEz8xV8wWgp6+x/fKG5E+tz7rNnCCer4gOyMVFCfymiTftndmWPQagRX1
	Oh1RSTmQr1HL1w0DwiaXYCmKbN9D1ko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763788979; a=rsa-sha256;
	cv=none;
	b=TnXUttEdokF+k3SzdlsQv2a7Qimp1EBh/VwKNhKVhv1agrXxmPPNoTBS3GLkwKJ5SS8VAu
	W+RsSLidDctfjfabdUf7bejC99vj5/6ohEbLnvtMzqbrdDmtsHDNBVpBRwyvv2R4NH5c7f
	dZKbiuHscvfYCEyD+C4lEjnlsmRcN0E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=O71ZRjK7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=ctiiXJqj43yt6JFDqmOGbkwRPsJgQSrgpqu+YQaEadw=; b=O71ZRjK77TRPcnC4NwHOF25PzM
	QXIKzNKT5MHAYI9TGOp2dd9ftqObQfTYmmqaeudsDv+ftQNBr8lEf5215q5bHLh36kZ5KlHu+nUpY
	oePTHC1A2TdwX92YkkNo79STpXJMmcxsDEUjETKuimRzLMtlv7Uet6XddETu2X2EslVlHPIOi8Y54
	2ZRy/7DQWXkdKjJ2U4Ct3dDAUgN3pXND3NerPs+rDUUbb7Bj26zzf/zFxuzOOpRNbDd3WlaMGMmq8
	h2UmE7ShTS8n/kkhvaLanI1hDi1wclKfrX7hDWjxcyofgAyAqLtUDPn0m70i7WUDS5mfoIGRRfQKe
	XJUYTC0g==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMg5G-00000009HOl-42QK;
	Sat, 22 Nov 2025 05:22:55 +0000
Message-ID: <26083ba9-1979-4d14-8465-3f54f2f96d23@infradead.org>
Date: Fri, 21 Nov 2025 21:22:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 2/2] ras: mem: Add ACPI RAS2 memory driver
To: shiju.jose@huawei.com, rafael@kernel.org, bp@alien8.de,
 akpm@linux-foundation.org, rppt@kernel.org, dferguson@amperecomputing.com,
 linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
 leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org
Cc: jonathan.cameron@huawei.com, linuxarm@huawei.com, rientjes@google.com,
 jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
 naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
 somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
 duenwen@google.com, gthelen@google.com, wschwartz@amperecomputing.com,
 wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
 prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
 kangkang.shen@futurewei.com, wanghuiqiang@huawei.com
References: <20251121182825.237-1-shiju.jose@huawei.com>
 <20251121182825.237-3-shiju.jose@huawei.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251121182825.237-3-shiju.jose@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mgtzoix71z8mes4amztbm1h5orpd3xak
X-Rspam-User: 
X-Rspamd-Queue-Id: E180F40002
X-Rspamd-Server: rspam10
X-HE-Tag: 1763788978-504953
X-HE-Meta: U2FsdGVkX19ry+/owvVF/Pbb5JOo3d8ud4+wA6yEwSOgqPScqy6so6LLw3Btixub7TCchsU2NX6lNB3O0bOm4Qtrm/slLIeB3HU1UXvrKBKiEJg5NIJm6TvI0COE6iPiG6pIaFdXKsMay1DpgWEJQwLaakxeJE9mUCOTM/6o38W3ad5w5AkUrTsiO38dMbtRPGQI9D23SMQ7KT4b1uPBM5Y7a4ZIcKz1D6+HmRYs0avhcrYDx9Kc/OdRI2RYHCdrPNF/OIjYqeFeTKCwmMPMblZAFwf78W3/Twj/67mxZBNj6wZN3HwmZmrTYd2ivAeiwTM8eY/ePYnhTUd0nbzGZOLFxpO+xVh4XNcrniAjH4mo7I8B01Y8S5AY5b+YCJVfe56K8Gm0jxKrQzg1H7zz6pXefpeJaoKyHBOqodKIjRs09X40uzMGmYKLpV0iPLi7nN+Lcf7RCCYrlfa2xR3n5pfdBRnCweq32MHzKqXhlKQ+k0F5tqvm/uOD8XUrajZrbERYgUetihfjhpm18kOlYidEmie92cPeGt4QZsulKZ+y43rvJhpaBtJkgZe6GdupMRNZeKLSUz5BGgUtIPe9Ii7bW6CPbEBqG9Z0UyLW3QsFTE/fIwJ3u6xAMT8QzXk8SUN1FvtlMeOFBISEILkhuoklHLrHQ9rHCqJl4DXXeAhujDADc3rXHYh+SHWUQyBfLYoYy5z2zzV8MBcB8ESbNKd9mw60UyfOzHOS1pB6nulxQxbt9kjKg9Daxg61FR3EaJiNN85YNHfSrAiVWzbWgtojh2hrP54xyinx6cSAH4BNR/BFlBHDQjjam3JsxjzaaxQgTvyH/4oxTYv5wKlUJlVYIj6W+xksLiztQeBJ4PB3baLQg85ze3lLJIAnv5dM2M6bYKHsPYJkihqRt/6QKr/B94GwNi8e5K/uJsjCvr+miIPoEN+48Z+qffc8V6rfuOTQEoRd4hMm7H5s/90
 xMUURfl6
 O7d5yZCz+Fz0oldXwB0TfXahvn7HLc4sQ3jyCMb7/DL3lJ/U+8GGuAosLNmPcQIlmocAtfEAl9nf2bMxYqWAjzX4wef1BEZdIgurpAlxRgzYdnoiWjOF/TTIJVqG5gSrA7zQPByKnCtXo2OzDwYFZqF3X7WdvsVwDAoIDHlLo2neFPB1VXbyej2/uubWUaIgTgpWhpnuTPSXFpchtraa38EABIuLkn/2jSlxQKOFbbnB4CmsR6cX7YfNwLufd2IyRBoZVVbYIP0c8CVVLYqClax5Lx2zSiugr2tdvLXWtWPPLdNO1NbzvtDM6dx9sLdsrce9anMAZdTWXqybfVNBLD9yMAulgA1hYpV1f+iiBHuiN5et4XosnOSCdhMzNMcl2gndq/XG4ffEJIB4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/21/25 10:28 AM, shiju.jose@huawei.com wrote:
> diff --git a/Documentation/edac/scrub.rst b/Documentation/edac/scrub.rst
> index 2cfa74fa1ffd..737a10da224f 100644
> --- a/Documentation/edac/scrub.rst
> +++ b/Documentation/edac/scrub.rst
> @@ -340,3 +340,61 @@ controller or platform when unexpectedly high error rates are detected.
>  
>  Sysfs files for scrubbing are documented in
>  `Documentation/ABI/testing/sysfs-edac-ecs`
> +
> +3. ACPI RAS2 Hardware-based Memory Scrubbing
> +
> +3.1. On demand scrubbing for a specific memory region.
> +
> +3.1.1. Query the status of demand scrubbing
> +
> +# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_demand
> +
> +0
> +
> +3.1.2. Query what is device default/current scrub cycle setting.
> +
> +Applicable to both demand and background scrubbing.
> +
> +# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/current_cycle_duration
> +
> +36000
> +

What units (above)?

> +3.1.3. Query the range of device supported scrub cycle for a memory region.
> +
> +# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/min_cycle_duration
> +
> +3600
> +
> +# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/max_cycle_duration
> +
> +86400
> +

ditto.

> +3.1.4. Program scrubbing for the memory region in RAS2 device to repeat every
> +43200 seconds (half a day).
> +
> +# echo 43200 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/current_cycle_duration
> +
> +3.1.5. Start 'demand scrubbing'.
> +
> +When a demand scrub is started, any background scrub currently in progress
> +will be stopped and then automatically restarted once the demand scrub has
> +completed.

Will it restart where it left off or at the beginning?

> +
> +# echo 1 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_demand
> +
> +3.2. Background scrubbing the entire memory
> +
> +3.2.1. Query the status of background scrubbing.
> +
> +# cat /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_background
> +
> +0
> +
> +3.2.2. Program background scrubbing for RAS2 device to repeat in every 21600
> +seconds (quarter of a day).
> +
> +# echo 21600 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/current_cycle_duration
> +
> +3.2.3. Start 'background scrubbing'.
> +
> +# echo 1 > /sys/bus/edac/devices/acpi_ras_mem0/scrub0/enable_background

-- 
~Randy


