Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 227CFCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2E88E0027; Mon, 17 Nov 2025 13:55:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673738E0002; Mon, 17 Nov 2025 13:55:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561818E0027; Mon, 17 Nov 2025 13:55:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 465B48E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:55:25 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A92F87B9F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:55:25 +0000 (UTC)
X-FDA: 84121002210.26.0BF2130
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 93E738000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:55:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PwqKS+bh;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763405722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4saTekz2qSp4ayUKrRPAgd+eGcPNxQ+jxmXq5BkA8E=;
	b=2u+fzLJnEe8w7K0oZymlzEjJs+lRNtZLoIEC6X8JTr55bv6FvSOb74cOGSncBOlKHnFheq
	6LRdFSA4cjcEdONFt6SKPnYWuQCNdEEljJHbI8kYtFEy7n4n2yDdJotRf19ZFdZL7gn+11
	QnI3Cqe39ge1WOYtDts+Lxsi1zgBu90=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PwqKS+bh;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763405722; a=rsa-sha256;
	cv=none;
	b=5NyGL28tfth2y3/fK/wcYjByO736LJmFTuQmPev9YkMWmwx9ewRZvSHkJ2SQ4bFBvxbg3e
	k4FxRNUIoiQHti569LHNu0EPuC8NuczR4TmUGTYZgiEqEhY2QNl7TRfWyaPGh+2B3fcz/b
	FRpx7y7YvXnhCT4Z96WFo1/SYrnhqms=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763405721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4saTekz2qSp4ayUKrRPAgd+eGcPNxQ+jxmXq5BkA8E=;
	b=PwqKS+bhOz/bu3E1zazVZblsMeo6QhsdadIfdQZzbAhvjzmA9nvuhSPyAFVLAcsHCIPdIu
	dORPgrUn25mlXFpDSkBHb5q1ZCjw8R8I3yB1Z8wIn3zUsff/6Mx++558frH64gPcmX7l0e
	IJ5Q406u2nALWSeGt0g3AqH58jOwVMY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-2kUXSyP2Pkieb9_MfmzFMA-1; Mon, 17 Nov 2025 13:55:18 -0500
X-MC-Unique: 2kUXSyP2Pkieb9_MfmzFMA-1
X-Mimecast-MFC-AGG-ID: 2kUXSyP2Pkieb9_MfmzFMA_1763405717
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8826a2b2d9aso170695346d6.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:55:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405717; x=1764010517;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I4saTekz2qSp4ayUKrRPAgd+eGcPNxQ+jxmXq5BkA8E=;
        b=N4jNiXCbjkWV+SnMT48w+faEgweFF656EADMUmN2Yng5lzLN6hoWr6SH5O7XxBqvet
         tApmKGFSnxOGOIW3rBDpEAFhZOAyYzRjpQUJdYX37kQwzQDp1MjiogK67Jn5b+Ym6ajl
         8fG4ndh4tWULQR3dCIaIPqW3E2PLktDh8XlPgyIDyECdMfn0X/YBRJsqV7VaQO6+UKgu
         hgmwlXUBM1iKFGbg5RUskeGCpDWC4aGBpzSUdqI5Kev7J+JUNqMpRqap+2XEv+5fEUcd
         DaA9RObX7P6C+sjhM/6nUBLTnyJUmUsiVkMIX6j7KNWTObM7e63n6YoB6wcPwWh5BM7k
         coVw==
X-Forwarded-Encrypted: i=1; AJvYcCW/GUXLiqCZ6KwUUBBU7YkMbODi4oitDfSNCPxYc3xHGMTartlnq5N2Wfo1f0sz2SREnTz+sb8gVw==@kvack.org
X-Gm-Message-State: AOJu0Yy/WPVCAnNE2utd1e6QOuJ1EqeqV1LJQVuhkIQBN9Y4TkoMid4M
	hJUSpHSWz/y+jKZr4zxsz/WiQRsQ1EOY9dH0AxD9bCMyOnLLWpxVo2lrEERIBn0FYFHCOwMmrRV
	cBJZAupRoceUNzTmK0d5mA5mbBemCr1VstfgrbZTH3AM+M+UuVlPH
X-Gm-Gg: ASbGncuxAUmnhKXrQ4KG1DqjetcswbKuzfcX0P9bPNrEdAIWJXRYNa4V8XWAz9uLIiV
	rtWIc5m7x10dNwbEW0Jwt191TUlhqdUT+XIodRzXBjlshcRkikJxZZTta7xm1X6q9pywt7/Vpnt
	fcbX40QUPMCj/bWyPnsgFpRU96fee4GHhqsf/XfjQOrDBqAul/cC/D1CCO5hdSYEo8+kULOLRbH
	WnTjTT/L/4ePJifX2CWemeWVQa9fL8k/WgrJ9ubSmzTZSxCf7bzoeKuoIVW6KwMOHEUlwIqyG39
	FKrpNP+K+Iwu+eCxI4gQMwnPnYfDt08DtJNc3IXMmhIVzISgxXdsivSHS5z/8Kyj8LETKULwwXr
	TZ72anW4RpppmeoKags1cneJUlu+qrEJgje0MxPFvm4GxXrJTqI6YU5DKY1V3jSAO9LvAP27F/w
	==
X-Received: by 2002:ac8:7e86:0:b0:4ec:f1a4:5511 with SMTP id d75a77b69052e-4edf2160d82mr167691291cf.65.1763405717611;
        Mon, 17 Nov 2025 10:55:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEtMZVukIyibHwI+DRiA0waOmzoGwweTf0fxlTZly2n4z7oX2AtJ/FaMOEx0rAxWMSYW/OLag==
X-Received: by 2002:ac8:7e86:0:b0:4ec:f1a4:5511 with SMTP id d75a77b69052e-4edf2160d82mr167690911cf.65.1763405717057;
        Mon, 17 Nov 2025 10:55:17 -0800 (PST)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-48-76-65-77-217.dsl.bell.ca. [76.65.77.217])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee0bcfdedfsm50628441cf.16.2025.11.17.10.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 10:55:16 -0800 (PST)
Message-ID: <21386400-9a67-4fcf-b686-1e7c9678d123@redhat.com>
Date: Mon, 17 Nov 2025 13:55:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 04/10] drivers: i915 selftest: use pgtable_has_pmd_leaves()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <297c6fa3dfc50c28c05c0974c86a205984d752ed.1762464515.git.luizcap@redhat.com>
 <8c745e54-1cb1-44d4-abc3-00e6511cf67c@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <8c745e54-1cb1-44d4-abc3-00e6511cf67c@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TRQnoMNBCc-QsiElTcz3KK2Q4-Kphyghe0QzDGGwk5c_1763405717
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93E738000D
X-Stat-Signature: 6544d3i9a6rqgwmo91cscucctsntcc1p
X-Rspam-User: 
X-HE-Tag: 1763405722-617999
X-HE-Meta: U2FsdGVkX19m5sAnHmgiFVjz2P31L7MrpNesTQo67A2as3cNjoyowpm4lcOfL+oBiP+HGWoVZKacXgc70/rhb8xjIZ89+zOY5bfd1lU97lyC5SNqAThOyr+qcTjDrS85tlOn4kwGwKitpxQDJ5j7y2ofvNg0Q5K1BSbB+lS+pMC/+hDe2LpZhGUCnsAvhCvG1edqDMAE6Xl+LwE2QKVixuR8VxusgAPqEmlf4YyDs+xqOpFW6ePU04N0UMeYOf0VMkq7AM4bwlUSaxsK85Cub3SnrOzrTtKZcypdQT8c85KkdB55bJS4Abd7/GRLPWtVWJj/6rqhrTY8Dqh0XARYfW+bI/YecnCCrSnFG738HrilA3rAi8IpDss00LNgF9kVg6OcLdIikqt2xaVvZRdhs6uaTkTjr86M1wzgD2d2orM/OdNUq8LGTOPlD8marNsCoiCHWVom/b183Zlh7FLWPUx2KaPcY5ccr2eLXpvuLxLKAwDPgLacH3ES/Vuesugb/wBl2h+JjD0WHFL2u8/UqnjHJxQMnOpOKoQ9UWTcFyy8F+3gWoScqdSwYj5bKLlwTvJzD1EjpNY9uQCr9BmEKxhQEqRm2LLFrKy0vpIMkaNyiUPCZWle0q/gB9fSrBdrScrnC18bMa7MfqP2ITjUngwiCQbGc3EaeuXq97lxYNX3aia7c8qiPhTiU9OyOTU1TyWZsoj0sBCkk31ACGo89wOfwO/Hg+De6JT/I62QkGuOHGByIMkCBkRBffyLmvDg0+zY3sILFxppgP+aESIiVnIdxPMBbFZPzsVMDvXVLDTEownEcuBtId4jrK+dlsIM5cjQASkdacns6gDVznAjyOSqagNGhTkLkDbPDxbWy05NuRHMhvrEyYCNuxTOyFriUdY5tikl6Lm4zZV8XZyfjSM2291UJex65K13B62NOXBy0KPu3c7M9LhXa5Gkxx3J+PZEp+xluC/3BfgGo0j
 4b/S58vY
 NXxCQBsZVlxUIY0Ve8BDFOnkapqy+iOX4vly9/ZsYjgu3maEzMgIqCGCkWXf3SrdxRMfhHh2DHkyBJ5hRFt7uJ2ksbkxk9ZGz6RYy+T94WFssS1k2RjBj2MtbQHC0odoEG+Bi2q7ZpmmErI0CWS4Jn21iW+mMRU2Y8zodSaLAYlQ7IpK1LpcdEDlIYnHmxQVQCv0LXqUGzClNUH4fkczHBfhIbGnLo8urLkxUEkvHDqLXqWuSfE5V4XnMDdGoaZiiawpoq813rJl5vAK0glxABsK5geg1Id/1y1uYGNjU2+ppvUt2wjo2TSGBwc8z9S5UdW3EfmLl/rNsxX9lTjA0FmuVCIzkuIJZ53ja1GrHzH2XIboS+T7xwaF6p0ISQu8sz67fNWKTqKC1ozBMGdyGugZjYCZBmH4efDmb13Vc2B9arOTLU2S5q6GHQPy2ynGLDhjsfSE/jzvuyTTnKuXSvBXipSPYTuJRA2pMJKJM1HEk+3dCnP3kMgDBPdR7ecZ13e2WACEFk7p9uwd6pYGRil3w9jdNKbNVy1KhUMEhKIAGvLugKzvHEDombSphIFNePGFUuFY4TLc2QEY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-17 12:30, David Hildenbrand (Red Hat) wrote:
> On 06.11.25 22:28, Luiz Capitulino wrote:
>> igt_can_allocate_thp() uses has_transparente_hugepage() to check if
>> PMD-sized pages are supported, use pgtable_has_pmd_leaves() instead.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>> index bd08605a1611..c76aafa36d2b 100644
>> --- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>> +++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
>> @@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
>>   static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
>>   {
>> -    return i915->mm.gemfs && has_transparent_hugepage();
>> +    return i915->mm.gemfs && pgtable_has_pmd_leaves();
> 
> On second thought, is it problematic that we might be losing the CONFIG_TRANSPARENT_HUGEPAGE check? Should we check for that separately?

That's a good point.

In this RFC, pgtable_has_pmd_leaves() should be functionally equivalent
to has_transparent_hugepage() so I think we're good. That beind said, I
also think that we should disentangle pgtable_has_pmd_leaves() from THP
now or in the future. When we do this the breakage you're spotting will
happen.

What about adding thp_has_pmd_support() which does:

   return IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pgtable_has_pmd_leaves();

Then I can convert all the cases you spotted to thp_has_pmd_support().


