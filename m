Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5018FEEA851
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA176B0088; Thu, 12 Feb 2026 16:20:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A84F6B0089; Thu, 12 Feb 2026 16:20:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789316B008A; Thu, 12 Feb 2026 16:20:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 67E296B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:20:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09E2E140241
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:20:42 +0000 (UTC)
X-FDA: 84437073924.14.D181070
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id F388AA0006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:20:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kSCoiqJV;
	spf=pass (imf15.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770931240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+vxOwDndj4zObe1CvOSxWnI7S8T1aXhKqAzJ6Mv/p0=;
	b=X/AtjrMZ8ZL21QMc5EDp7Rv5eZulY4JyQHhuIfjp3D3So6zp+n4qgFgbuKo9oUtXjZb3fP
	+bi8q9poya9Ya8bY4A2J2MdTycKLki3omdzUQlqoKF0bjrLDGRPC3dXeAjlRIWR8Q4m5lA
	IRmhZ/bMgXSF5s4ALWaxGl2Hr20Lu9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770931240; a=rsa-sha256;
	cv=none;
	b=SBxP0ta0x+kiyVhI+JwiVF6fUsUcWU3pVun50pzvBtwrbAlyR/OrTe0eG3bBZfK8/caHOY
	SVK7oHXSXhZYosFfRkG/etmOq17KOVfN1S1plJ5qV9+hsXqZi60vraueuRKK0j6q9J46iE
	KKEqGgaMuNRxrH5rvvpdWpqa9y7E7BM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kSCoiqJV;
	spf=pass (imf15.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2b785801c93so684945eec.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770931239; x=1771536039; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m+vxOwDndj4zObe1CvOSxWnI7S8T1aXhKqAzJ6Mv/p0=;
        b=kSCoiqJVHWsrvaO0ESWsAPawKjwxVmOhuqPEtAZ+6kxY5HLW1TxoiYqbTrmLyvrBOl
         a+YTWRXxsI5EHXB3tTEgKtJ8lBTUJkHDtT8FJrVyd8/CM0QlJjbz43CLAlGUW9yAPM1D
         7bKYtA1oJVGQ2T7XNxytyM34xyiHEGeTgX+gILH7GppxJ0dseiN/ZUu9xKd/QihL9FHI
         Y/PzE/ehbu46w/aW3U/eBMISxMNcf/eCz5c72fW6/7zSYrifSn4GygQibPm6t1G/w6K3
         t7j2CBIlGCRCR2JVl8mu1fqCDNWrbFmkvXq3NBCxMz/NOnqpunk78Hruxe8KL8CQXICU
         a++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931239; x=1771536039;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m+vxOwDndj4zObe1CvOSxWnI7S8T1aXhKqAzJ6Mv/p0=;
        b=jHSZBhF4T9QNPDAquqiOSZ6gDk5EBKGGqC7qAqMpEjHeOHg4OWAX++0o66Guip/fYB
         rnIJeG1X+eXeLAGlSJTfLJwv/aVtadneeubU+sa/+FK2MQw+1hAC41rGKRSbv1J/6/Ba
         Lc7LkYX6HsFReLMSFt1ztvgKw7HHe96lQH5D/nEqnR77H6aL0skHnqHItkcWikqMKe8+
         w4w7tWB8myCpE4WvWoxnxuVmvXjRKEAPdZ08X6UIclCoFaWpSyxD/FSwaJ08ZJim77T/
         XfSa1eIQ70hbPJqsk0Swhkwhqq2DfTLCfblymBUx+WFNKeOREpN0TGzv48njthdsp418
         MzpA==
X-Gm-Message-State: AOJu0YzazhJ6ITGqb7op/ltrLbmeTF4kXSFdSePgFaZxod3FLhWbO7io
	eF/CcEpBy5XHIIgDiZviY7JDUfq+knySRPMb9b6qWM5XDRzCxVxTIBiw
X-Gm-Gg: AZuq6aLxhztq0GzsMC/IVICsKSs2daLMrN+M4IQShRNE2Iye2LvFl3itdVhbEH8pBY6
	sWZHysv/NairX+FCL1t3fQLrV9ks3QiR/leNXgawrJ8FvYVEnWZYeSeMUXpZmXPa3qHod2NKBqV
	Rsimt/ACg+MH412s1SpBaDQVePwIVLW6ANi1hgTfiWlvMi+LMzkABoiJMx82AtYrSojaMBd7dDZ
	ZUog4hFHMT1a3zPhXa3E4NZVbQ+TR/5FAjkPG5Z9Eq1uHYziTPi4+m6DXqtjQlSnlvJ3ufbHbfs
	N7AcSsLHsY3dFiCH3xVC+aRQOskZlj0JNudDeAFgED/ZuMZwY77y1izaLK9d1Jcyp18OsF+JdFh
	E7W5HIw8lFI/Wn0nQN2p0P0NZYWA06ZESRfwChrxFJCsvzGQI2YfBzskuYH+BB7BzCIK+1heLeC
	L9Hs6FrzvMCwExlDis0AOYBKARL6OQikXe3xwQjN/aINs=
X-Received: by 2002:a05:7022:250f:b0:11b:9386:a3bf with SMTP id a92af1059eb24-1273985be5cmr198075c88.42.1770931238369;
        Thu, 12 Feb 2026 13:20:38 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1272a6942ccsm6165153c88.3.2026.02.12.13.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 13:20:38 -0800 (PST)
Message-ID: <ba761a76-78e1-4215-a95c-290f9ca8cb55@gmail.com>
Date: Thu, 12 Feb 2026 13:20:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: move pgscan and pgsteal to node stats
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-3-inwardvessel@gmail.com> <aY2BVsYlPa4QMbUC@tiehlicka>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <aY2BVsYlPa4QMbUC@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F388AA0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gbyrdkkt6eo4xr8tf8jatuepsimejpq6
X-HE-Tag: 1770931239-995840
X-HE-Meta: U2FsdGVkX18v42ANSGvkdUAnobA0eZm2fChhH/ZpqjVhJxw3chkVZZp9pZfHzfCDXcVNaoUaLgh4Ahgmc+CKJXh5tSL6D9uGALP1m0CSmLTJ4Sr/su06Medl5VBJ7Csj/gn6diq3ReqMX1PukPjC9f2zZJiBkFjgy5Z0T4gWbcHWGS8OV/FGhEp0eMgjaoUOCZVNwvhCmK8NUrtW+GLsDnsOz3v6jZLrROkteuTpEmiXUAQ8i1uq3+dgUHJselDsa7fyYTR74l+2wMvc8cD1loK7J4ZomlLp+WP+Df7DK9wpWp1uLFztWiYDWaWx51EhIZRKzT39WqJ+eVMl5MgnYk02hVG9MeMQLjywVQ/0OMeB3K/swZiqPWSQUvEsCulI51/ywjYdQWPZrNMuagPiF4rfUMQDTBDMQJwXreEbPyc6f/rIsbnVGI8tgDAQ5R8D/F5thxpbh4ah3nkvB6G3c+OKc6oGWUlg/o+Y0rfi2eU7S5JrkvMeUD0aOfEGLMp03Mtx0ERwjUcDWKnD/NoKToQMN9wwRGOIg3B2hOMXWOm6Ry8N0GznmpXRvzDR//e5Bv7PUpfA4e+T2rlpiLYI9RIiDcsU20Tbn5UnWfoiq08IBt6IqLoJuXcK9qMNZWeZjUwZuaxE5c8+QGRc5Xg9sqZxh6ZO5QkSsEAgTNbf4+CN0yzFu14WKITmFxLWs9LTn530bWEgC3gwdPypRHar/g/9P9fwryQBiWAOQ8I2oJVYEouUZVaOkiZeYmsd50eZUQcJuW0rCKUwYLBiN5ze7E6uKg+Tr0/sCHCgXnQFIo8MiP2BynOCnokazFcXWqzP7IKFwnL2gyOU1A1KATK8G81XJcXLwe7PaZc9jA0/QBF8Xu+U0qHYoZcOFg8cajbkdrw2S7amsMKJSoctswrh7f10xQKSKaMHfM951pM1s4Eujg5D5Ngua7DArFDs1MtMVHvAN18Pb35U+lZ5WLH
 GN7KeAS1
 yJaQJwv82aJsFbn1EN/Ui+q7LWVafKSkaPZ6iybFb/XLChNgsdGAbtSttmFk29WJ+1q8dIowCDIjlGIedf528+r8sH4PBdhRO87VMOfkPwct2o0T9/gRnhMOpDF9i8C0cVkUpbQm0K9j0D31knhQR2/rkuaK7u/l0XJFJfgko6vU8vBPgsb9fmznFEdILd+ByeuA4l913xZTve8HN+gGx4/pIp7uHoterIBO6ketH2j76IQtnf1l3QHiVvUsjjqdBJgmftA3nq+DB1sWOrY9aoZ0O3Ks8ltDl4sMSjLPr0WTWspIoVpGChUA3VI8hP0WUo5ap0377RKzGY+PKwA8HSmj103+PHER1afrH3QzZx0aazVraKE4a8Tiu9Ft0f6AuEoRbzP6/KU2zTjkn0SnjUjNa3YCDhFFK7HIcrPKYfzH6St4Fim7bkfvVAQ0lTwRp3+3zfKQfSS7CK8M7t1C52ycLYYbTfpU/5kkEcc5UtpGr+E2DBYIECvtS1tIUK8mmEL7/yzG3FTUgtRbxBNqSMs1AZBsiKZ2w/vtGR0IggZCzuf4q3K6ikJEflBxxZ1DfulPZBko7gcvrXD5rIGJmwpHnyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 11:29 PM, Michal Hocko wrote:
> On Wed 11-02-26 20:51:09, JP Kobryn wrote:
>> It would be useful to narrow down reclaim to specific nodes.
>>
>> Provide per-node reclaim visibility by changing the pgscan and pgsteal
>> stats from global vm_event_item's to node_stat_item's. Note this change has
>> the side effect of now tracking these stats on a per-memcg basis.
> 
> The changelog could have been more clear about the actual changes as
> this is not overly clear for untrained eyes. The most important parts
> are that /proc/vmstat will preserve reclaim stats with slightly
> different counters ordering (shouldn't break userspace much^W), per-node
> stats will be now newly displayed in /proc/zoneinfo - this is presumably
> the primary motivation to have a better insight of per-node reclaim
> activity, and memcg stats will now show their share of the global memory
> reclaim.
> 
> Have I missed anything?

That's accurate. Plus aside from reading /proc/zoneinfo they will also
be in /sys/devices/system/node/nodeN/vmstat. I see I could have been
more explicit about this. Let me make additions to the changelog in v2.
Thanks for taking a look.

