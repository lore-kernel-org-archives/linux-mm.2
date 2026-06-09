Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A8E3CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09FD6B008A; Tue,  9 Jun 2026 06:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2226B008C; Tue,  9 Jun 2026 06:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7F96B0092; Tue,  9 Jun 2026 06:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BED326B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:06:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7373C140416
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:06:47 +0000 (UTC)
X-FDA: 84859945254.27.7DF9B13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 957AB20004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:06:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/DNTIH/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780999605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ihPSDA/h0Hov+M03ajn9GoQMpAb1QB0ZzEH18p98fI=;
	b=q0AeWZ4f58PqKmTUfpzLC54YZQPUYlqODu1GU4ykT+ZZHwjH319LlNuYqruUUdHeCw1KMp
	Xp6BXGVLkadSRA2zp/8eYwdAFHqtd0Zolk+yoBQRlPSKQMI5vwtJ1sav6wdsJBKpzO2jwl
	a5uiBXExOOOie6bSBz5WEnKUn0PiAqA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="f/DNTIH/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780999605;
	b=pILHluZnrV/Y6zNVhvZBoPF+bTq3LeTgaGYkXeL8Gyop4kJbDkXg1pHwTuzH3JF/MLt4qj
	6XpazC5aDr9kpWss+6MyVZ9kJk3ebepTFzaSzi5PwqNvidl57GifhEju+colfWmpiiJRWZ
	yALWW8JvDTy4NPZd8Kedc3FHaXydPY8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8AA74090E;
	Tue,  9 Jun 2026 10:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF681F00899;
	Tue,  9 Jun 2026 10:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780999604;
	bh=1ihPSDA/h0Hov+M03ajn9GoQMpAb1QB0ZzEH18p98fI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f/DNTIH/yx46ZasoAMnEH1+Guyhpk0JvhSaZTirQQds6faAGBzhYHerjrdgUJJXsL
	 NxG7D2lZanD7LmDxrolbWQwz1dgenNB8N/Sk3ZjzoJtO4qCGocSDl3ka2ajzQwzINO
	 ufSlpY6Mw0IEcUn5oDqsTUaF8tN4YxQX/omJoDv9avZg2Lj5GgPJLD6hYn4LMbVlWS
	 qJpz8NsESC8hOvNFqp6R4rjHENMkwgI54a/ADNU+G/qhYgGo93a+0egI/oPX4EKYS2
	 wQTSOcY/Hqs6YvPvTydGkejXD076sN7iZsS1Aj3OK7xeY3ZHeOFWVwc1J1o3NMWSbe
	 ZhJct0Cn7Aa9g==
Message-ID: <b62e071b-9dec-423f-9b4b-e3c34ea0a409@kernel.org>
Date: Tue, 9 Jun 2026 12:06:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/9] mm/memory_hotplug: add multi-range hotunplug
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-6-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260605211911.2160954-6-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 957AB20004
X-Stat-Signature: mbzppbigpon1ojxhibawrn6w7pt464zp
X-Rspam-User: 
X-HE-Tag: 1780999605-141258
X-HE-Meta: U2FsdGVkX19wUVsw36xz71A0xc2J7EFYJNwFfOJXddSYiorShOJFg7xZtlNmrvdyw/eOiAodImqc7smHo5dO8Aq1Nuq03piOtrdz0C4E0xycnuiJI3nz/z/3OqBn5mLZ+N1XxqyXLtqhkHrrYB/3NT1mxAzjksUH1065ktG4YaFV/CY74HvwcfKcr4TcLDFOHEahNg2jUQIUM1E7wgepJNrKbtqH9/WBlmIbjsyeTfSLnwXGBJuQlxsNL44RH6jQ1upyckdCjXXGdbvn2qaeYg77Sx6yizwM5I6PCsghZ6OxSqN3CdyNevnqMXXQ9SEKV5gG97s/T0NuB4Kf7w2XJCs981QNDXG/AZHHaZFnlfB72p6NtLBlI6YhQs46sXlIkpHnjRathQRDxZGCw42HLWPs6S5JQKGfbWQAlpmC8zcDOO4W5ZqjkKbLII8ckMKTUkRAEQbRe2TRZA6SfvUxpUpRngPblyWcx+qpQTxaKJXuiiEX4F/VtIPaWsdzUnIMn8cFHsK/tjFZwit4wUJHRHt/AiRcs7eSpocRa8AwDOrEotlzHXbwYdw6FURptXO/QQrF5swn6N2k5PNsq4uiAnhN/PAbxFXdoXf2Sp1/Y/IAQBWRqbTkJb8dDqJ+b++y0rKC7I6PPXQfdwRETahKGxbC451N0czYdbHMrkMwX4R6j66dFawR8rclJ7B2YtVUqGNLy9EEXITO4Xsxwix3TtVpuRIAFDXqqYpFCco01HE6dw+dL9VsshQlfQEBGOAkwzhaI2fFa6kJw43Eiy9zQmRwrSNXFyXk4ctZFo7ZQWYW5IbThoqnYg7DrwEfVBTH1eY2gCLwvoMvLOF168WW49iTNOEu4uMu+bX/epHyLzSchh02EIi6qC1P5Az5PTTuN34QG/DEzyxT7pOSed1DHNkJvCtvUJfqQNUnZlRV5Zch0NIqn2j5kKJkAHUOFcPOkInHeHxPnhtGuxba+ko
 hKtyZdA8
 zpj973AgnFssZXSeveteenrOWJKc4ebnBSnoSRsTcrWKnTUD2V4PUIIOfw9sVfEzkncP89Nx8mODYCcg/zNOOSI6TtLQv72xD1pfhyrJ3mGzBORdN8pOIkmFNhdtIUNkdd7N46Kl2gelGhI3LteZVlrvCFGyYrUK7LjSaOQRxeKcxDvdTSBMT4c3Dp/tHW5kfGgw58S+5xtXZr38vsYaH/+xMcM83PtgYxuAQ2C+DupA+WSJNRCXGfLxQX4Enf01UiX/CUYNDopr+YNt20c1rFNFySlWebdydYHs3hzo8fzues0EK8xz9M6+sxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  EXPORT_SYMBOL_GPL(offline_and_remove_memory);
> +
> +/**
> + * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
> + * @ranges: array of physical address ranges to offline and remove
> + * @nr_ranges: number of entries in @ranges
> + *
> + * Offline and remove several memory ranges as one operation, serialized
> + * against other hotplug operations by a single lock_device_hotplug().
> + *
> + * Unlike calling offline_and_remove_memory() in a loop, this offlines *all*
> + * ranges before removing any of them.  If offlining any range fails, the
> + * offlining of the ranges processed so far is reverted and nothing is
> + * removed, leaving every range online as it was before the call.  This gives
> + * callers all-or-nothing semantics for the offline step, so a failed unplug
> + * does not leave a device split between online and removed ranges.
> + *
> + * Each range must be memory-block aligned in start and size.
> + *
> + * Return: 0 on success, negative errno otherwise.  On failure no range has
> + * been removed.
> + */
> +int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges)
> +{

Is there a way to just generalize the logic in offline_and_remove_memory() to
multiple ranges, making offline_and_remove_memory() then a simple wrapper around
the new offline_and_remove_memory_ranges(), providing only a single range?

-- 
Cheers,

David

