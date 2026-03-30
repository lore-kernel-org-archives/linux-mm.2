Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC8E3103D95A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 13:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4DB36B0096; Mon, 30 Mar 2026 09:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE456B0098; Mon, 30 Mar 2026 09:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B246B0099; Mon, 30 Mar 2026 09:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C48F86B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:53:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 102F25A0A1
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:53:36 +0000 (UTC)
X-FDA: 84602872032.22.2C99B1E
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3BA511C0007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:53:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dYSZYK8Q;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774878814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l78p31yEoZ3arnxGyYF6VPRhnCnmHLaaS+hRioFyojM=;
	b=2qe08wK6q4CYRYkXwCgBlB3iY9XGd1dXvjJblxNaiDIhHtjOnAWFK0nQw24JqojMTGpaeX
	QdSmHPK+GbjEOGwA3HZpLGH5+rgR7A7qLBs5zGp15Z5NnQwHLHCfCTB8/cnuwGu72kGWEq
	7kDQgsgwsbjBCROwkij0QF2fhIEpTZo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dYSZYK8Q;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774878814; a=rsa-sha256;
	cv=none;
	b=QEjBDCBR8zAi6IUY0Gz45uZlD8d1UtKPeGK5VzEu+jbBJMLgtAEhveXhTXONvXdm+68+4H
	8gyp9mitEFgmwuZ8RWpm5QZQa1p69O5+iMRyyGIAWYv5PEIqjIuwinFOaGuUKPjrAeM2yw
	41nN78+8UQ8x/tyQHypKrhy0Hgh1bzU=
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-41c4d660b19so1367360fac.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774878813; x=1775483613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l78p31yEoZ3arnxGyYF6VPRhnCnmHLaaS+hRioFyojM=;
        b=dYSZYK8QuwgECV7cEt1MPQ0rjmqZb7IIxWMgCT1lDTxv37+vNlX2Xw+O3FOwuMDhGr
         0f1bi/qSlVgYruTLVEf+g9qu0s+e6ikpOLj5niUX6Rszfh6NgtNnFcEpSByG7zIIkf0g
         YW+qj7JIXhBJQ4VpOeWZh4XPAgcGCa7GmyjW/KRtZ40SyRnYfAr3VwC0dnJ+hzAWo0fM
         ag9RiAC8ZXKmLXIELi5QkVy4n5+DdLherYQBREvibsfygxrlCTnYhSvBA33GcfoBHA3J
         MKloDi11EzIHmvsQ9LpSwAJQIVbJhKLLYMtOnsQyiDcfVM2CotcMXneDopsRrQdBdZMS
         K8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774878813; x=1775483613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l78p31yEoZ3arnxGyYF6VPRhnCnmHLaaS+hRioFyojM=;
        b=o02qq/Htv2j0/eCOo9nxcAhfiju0JHOgY9LI9w2enZBxpxy1wtVjCTpxDtt1XAA6Nv
         PwhD34cwUQnwuWsWA5DYKWBHhVrwPkAS++bnWCam2QwoQwpcKr/gE+9IGq0yBXMN4dOY
         iqf5z8BO27Xa8K0S7mWYsT2n8Uc17zQ6w3k+KdbrPyBDpWvS0mXxpuGzn8MFVQ6bE69B
         S1e4he8aZkLW9Qe3FTuQxDInR36ivd8A/ei9j+3PdXfZgLgx44F7eUuPs1/OiQRpPoeC
         4/bsfKXtsB2ui/1DQ2Hzd1Ed9lbgRAIb8foa96NvbpG6rQyVpQYMlnu2VGh9buJ0yxC6
         ALpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJtTVHTa0gdcOLwMVHhiaDSMF/69FWBTQLpGmvUowKFJnYnEDUAIv3xkr8nN23knUqi05ZMZZ4tQ==@kvack.org
X-Gm-Message-State: AOJu0YxkGlJpNofQcy8bh7J9fA7i1wx9TipgCjxMKxfDv/2wa9bUH+Mu
	mfSfUhWBQttoxabGF6pVhbRlRmDPhxIoyp4fm/Le5A9/pOm6nYa8TXJ+
X-Gm-Gg: ATEYQzzoSDVoYI9AuNU4EIOOI+ulD5mo9787wRP3E6PQmcl1fj03LR8yf7mm/mc4xEx
	0dT8rSoePYVUr0KvEDnA5i27csAqhPI4oVdF5eKu4vYjUSqJze8EL6YN+Gub5kCIwCOH0XF57fj
	K64CPslcbPseMSqG+VX3FIEPGGSqXn4I2kx4H12wlZo+2rmRnfoulmd2I8gokrhWeFxz6AFVbKi
	hSQs9BujptCGTPET1XX/KacAbVzn0QZu/gP4v9wWFi+jtIcSo87G9cnLDFiuIpVlRtkBrNRfAso
	fn6QrWEJpaFQW1zODKlVdcPqVdRYR9bFLKjKkYeiW3boUDx5NaxM4hfKNdV3rtlMqKiSN3SEVhD
	WAKppu17/0A+Wt/+BLq9rh2SPazvforDi7SVVLMv3S1rlQPRAWBGiqxb0MRmO7UnyYOXxCRwNLP
	bT+om7yDSyqb6Q6BI8Jj97zA==
X-Received: by 2002:a05:6870:d376:b0:417:9244:d180 with SMTP id 586e51a60fabf-41cec375cc6mr6655147fac.46.1774878813034;
        Mon, 30 Mar 2026 06:53:33 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5a::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41d04cf9ceesm5252471fac.15.2026.03.30.06.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 06:53:32 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hao Li <hao.li@linux.dev>
Cc: david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	joshua.hahnjy@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug
Date: Mon, 30 Mar 2026 06:53:30 -0700
Message-ID: <20260330135331.2948804-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260330035941.518186-1-hao.li@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: icpzcesrco18muh199gxun75g4iatph5
X-Rspamd-Queue-Id: 3BA511C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774878814-675747
X-HE-Meta: U2FsdGVkX19MBVVVru4bX7ObgFwQqxok3fYwEViBX5g32azkDWCcPnvjPO8fuC5h28R4XZkl2jmuJi23dFpkUAJOAB1pJF1pGVJODVq3dSpPENhbrMblcnq0A/XQ/hGth9yfjkXOFiz7T5cizfhkhvTCxQ5kFvqcnfFfYAG/4NDe+ehQlXzND77sFkk3YeRhtHvBjzqqZ9SHEpc4AoKHKPEcYWZXOUxPzzXposbVaTMR9viW3F+4xrEX16tQYsEPyOv+JOZf9JoY+c2utYGeFTLax5lElKqfRp+sVi8bopD245fs6suMT3iUyjrLTdWfNtbD1DoelAH9+AvsYobr2+I9xDEIrgGpApHTQI5csXdFMxWeEyMNjyUDZOakzSOkPE/r6wyzhQrGtc747x35WbeFYPr6pA2xoMfShsBEi8xqBZqYQRYr6cpP7A9vxlLp1LwY3TPUq1eBr5YN9pKzJF6CEto41HZ5Dmtnjndj3nAXCxahEMCUubTn9ULb/lR06w3pgs46mXQjFDXlO/soFb+3x+Xc4WgTVlkZDxAs6a50U7Fcx5HK304bpTyTx8bRVtTbT5UxWCI6ZOSiuFiPMN8HuS6IFS+O3KPTlp3shs6aSSdcsg9su9RNnbar4zprgmx8ee6lK/KTj2nUdTKoF0lfQqi4AES74BJ/Y6+pLJeeTy5rZVvUSysnTk2ww5338viYFnCWfYxqD3A4ggEV7TXcVfZX0KQ2n/7Z65MHkvbqSVFZ/dmi8+FopuOPQj9M1oiaW9ONCtkjcDp6bn9pnpivwQM1+59lfI5jEhogPaFEm4vT526eGWzC1JWEiO08TwK3+Tk6qxldKShwMk40ZuDHj6lS/2M48t9XdHil7Jatco0cXervrJYgFoyXw1u45oVZ5tpzrGthxTfUcfm0UiwpPnfCZkk1aTNCREEzk7lJSXRe2Y79kWKWTHuHhbIYQlw5H4f8uRQ02Zapgkj
 zmfa6ovW
 8SCUgTnroH9hvLSz1a2JGU+LWnHR6ZdT3XuOybHYAQro6XBofCCzONGcFetPRaQaKYEYtArmq4/EaUSFqhsZAhUlWHmRRX+ofrxaxw1WrtMzrRle0VbELnIYQbB1pUUbAO5aVT7v9/0hSTRsLlnxTNq1VGq5mWVPSaW/E5bYlIHgZm4rBaZeD2ngOfCBqN1SigP1DS7QiJ28giLTpKk/ib9zMqjvyEgly6JocRmnfTTSMS1JKSrBPypFvsTInPx4ZTam/uF6gkLSdLIUsrppb/gREtYMtxcG1onh1UuubPKc+0eBEUmgDnqtZDNXl58cD4YCJ6a/Ey7SVM8QA/ipwJqsXsfko89w7PxLbent08Iw7TBcJIf0YO/tgIby17+QTv8Q6QsekpE1elzOlfqlU0gkrbiyYOU4XOa4/NS6isCbSklvWnIBJZeB399fwAURZ1dp4ZB1Ca6SzeMGkp0Y/7dGh7bDi7uxgZCYQToQCAk6LD0T1jUQByeYq4j7O61X6TRWDdH2FcMkm/WUgbR9+xF6a/fCFWkJjT3zA7CHv/c3MIQ41zy/d+2BWnAletpXKX9ugXLhx6krX9AkjdU4oIgxftAFbHchKVQFVOqWF1rHpR1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 11:57:49 +0800 Hao Li <hao.li@linux.dev> wrote:

> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> hotplug currently only updates N_MEMORY. As a result, a node that gains
> normal memory via hotplug can remain invisible to users iterating over
> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> incorrectly marked as such.
> 
> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> offline_pages(). Set the bit when a node that currently lacks normal
> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> offlining removes the last present pages from zones <= ZONE_NORMAL.
> 
> This restores the intended semantics without bringing back the old
> status_change_nid_normal notifier plumbing which was removed in
> 8d2882a8edb8.
> 
> Current users that benefit include list_lru, zswap, nfsd filecache,
> hugetlb_cgroup, and has_normal_memory sysfs reporting.
> 
> Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")
> Signed-off-by: Hao Li <hao.li@linux.dev>

LGTM, thanks for the new version Hao! I hope you have a great day : -)

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> ---
> Changes: simplify the code. (Thanks Joshua and David)
> ---
>  mm/memory_hotplug.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index bc805029da51..05a47953ef21 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c

