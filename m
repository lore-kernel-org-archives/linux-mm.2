Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD528CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6DB8E0018; Mon, 25 Aug 2025 08:30:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7A48E0001; Mon, 25 Aug 2025 08:30:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BE148E0018; Mon, 25 Aug 2025 08:30:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EDAA98E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:30:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6780F115CB6
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:30:06 +0000 (UTC)
X-FDA: 83815212012.08.CBDAD5F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id C99194000B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:30:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N92dL++x;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756125004; a=rsa-sha256;
	cv=none;
	b=nfJzPbhaL6uFIUDY4+Z118/UsEMgFAp8HKz8w5XwMo0lBZnHp79JDbgomdlOgz10ebgsV5
	vL6qBvzbFv93gibqFWw1nvUntg/4oBauIL7lXElCBi7T9g9tDFHEhrU3U6EcGT5yHPyUNt
	nDbZnVLwmDek573tGpuOgt3BYTLiCBA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N92dL++x;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756125004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qkP7cC48R3McdGtVAl1xmnxt2NnQDjW6KguPLzrpC8=;
	b=Qtvb6Ng13vxLj9H5XhuTOaus/OLuDb5iQ+jgHooxERic21WViPSgAimGPmcCfuqODFaXmV
	wEHXp9zsGbFnpoVR5+6Pe84rOHzW70fcJTp1lZfEYk1t/h5YFDmzWUMkUGWEth9OvNKOvM
	WQOEXsGEnbIqfC6kIVwiDfLtIJ8c9k0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756125003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1qkP7cC48R3McdGtVAl1xmnxt2NnQDjW6KguPLzrpC8=;
	b=N92dL++xSAOrZES8dtD4a8e71m1fnmgiuwdb3x3BPE7aVQgTT/zwkVt+xdu39TOweEL65u
	IPdPQsoyIXUEuFP0IY1x9QJDbDHmhEc8iQE002CNw6ikkMs1Ny+YUCI34Xi8EEZ3ga3jjv
	4svSyWIkqQbOKwnWnBdkH/JHOvLugYA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-vaZ_no5LN36NkMoPV1OzDQ-1; Mon, 25 Aug 2025 08:30:01 -0400
X-MC-Unique: vaZ_no5LN36NkMoPV1OzDQ-1
X-Mimecast-MFC-AGG-ID: vaZ_no5LN36NkMoPV1OzDQ_1756125000
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3c6ae25997cso1474336f8f.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756125000; x=1756729800;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1qkP7cC48R3McdGtVAl1xmnxt2NnQDjW6KguPLzrpC8=;
        b=qM5QRxegk85D9Vd3oQXnsAbuhSc2dCdfBJXfW82k+RuMELHNgz4GSIwGu3J6MfOth0
         prMK0TWgWg9HCznNh0Pq9FyvX8GaAv/kdKynJnTlwHxt8qRrdKb/oEUqwXPmqIMdW4XC
         fWLc+glSivvDTCcXmCXhJuL+VDtwl0xwimFuDfaYCReKYpFJL4/BVAo18/hrmLRc2XM5
         X07OTnt5WQEy+QuM9QEEAbP0QbaNNfu1LXWU5LXf4VzuPJjpWRdYHO5ZyDVYz0IXN/2o
         5fakVYglfrLARHasdYAzGJtHkv1UUZATSc8cizSO2JoCHwyqvsz9gAcRAK6k2lWgznD4
         Ugdw==
X-Forwarded-Encrypted: i=1; AJvYcCWcwNxiKAQOS2mKYgjgTHspV3Yv3cxLnj3FodVZqgr6SyQRGMFFwUZNjQs5w9sA4uw8nCBa6g8QNw==@kvack.org
X-Gm-Message-State: AOJu0Yz8vV/RD/IO6HwfdgbHEEcwGWVFZTasUNaUyPX2a43iUnHpMJPK
	qTf2AdRL6A3XvcBQHFVw1bsBkWI5usxQ6rkl7v39LQuO7k0PWhOQMDpkdQpzaqUQOZ6GzAm4b2O
	/xF+widkiumlTdYP1s6qTjxA0bTV9aQ9b+z5w2RJ6L696izK+4p/F
X-Gm-Gg: ASbGncvL17hEGMeM+q/UMsjSqvIqWZSFvsxIL6yvmWTrVHvfeC1TJ6dxiqRicsfzfga
	yVSMKfLBppJOWf71F0A5yuLseE/VOy+knfjnP2L5NIngAyyM79DOgIwn0x3+NWT4VxXO5+0kLBU
	SVhQDjVcqJQeC3eqWRG5s1jCpwaMvKChNh0+RrsAKVoEpBoOEq1JG4zKp7OkXB5mNMn6wK/MAjN
	FMIxzjD/qmFZBh8lZLJ3HGYKt5go0iKuZQefWxDNc8KBFs0pCSqU3l4FtN8TOsLhAQGiKV3MXBh
	mCQ3VqbRQ2EFo4tGNwIYFIfNuX14SI3DNoIxbq0fJpR/X4Gp1FqVbJnK3lSJkXXW2+ZtrLEivpQ
	CdF63GFwC2t4WKpq1gBn40MgbhAGDNS5++ENB8Wmx44kR0QZ7VG+zzIvLFG/3A5i2IMU=
X-Received: by 2002:a05:6000:4287:b0:3b8:ffd1:80d2 with SMTP id ffacd0b85a97d-3c5dac1aae7mr11054363f8f.24.1756125000384;
        Mon, 25 Aug 2025 05:30:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyzvAMPfQuR1qLbhAVikypL96VkyB/QYgs0RchKjLOu+NkcDo15lGJc6glNklhghjHWJxl4A==
X-Received: by 2002:a05:6000:4287:b0:3b8:ffd1:80d2 with SMTP id ffacd0b85a97d-3c5dac1aae7mr11054345f8f.24.1756124999946;
        Mon, 25 Aug 2025 05:29:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5f28fa02sm50710175e9.11.2025.08.25.05.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 05:29:59 -0700 (PDT)
Message-ID: <b066d806-5fc5-42a8-b0db-74ca5b454683@redhat.com>
Date: Mon, 25 Aug 2025 14:29:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-unstable 102/221] include/linux/pgtable.h:2000:17:
 error: implicit declaration of function 'VM_WARN_ON_ONCE'; did you mean
 'WARN_ON_ONCE'?
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <202508250425.yEOYgcC5-lkp@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <202508250425.yEOYgcC5-lkp@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zSihLIKIfI4OOA1aiHoWX4EnUB75vEtx8XqZ6Z0SW44_1756125000
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C99194000B
X-Stat-Signature: g3to3y3kuan9niwmp4kkko1z49ph9tk5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756125003-813319
X-HE-Meta: U2FsdGVkX1/Tik0JDwlDt5LWZQIIthc4v/mePdN8fIYOS8cDvHzONgUxJb+0rQ7wCTizHCOGWa+IzRnwjlRJE73ltQMwJgz8pYarl0rjmLg4Vqek2aI5vQLCyfmtut9lXsmWCnt8M5x/vjcc+De85I7aorC8DjYInQIMmWrY8mxTF+V+g3uGo83F6I1MvaBqKM9WVc2qCnxmodEcNBpYfnAFLxbHn0vSp20FDBrASSgK2w/9zsqTNrNtq3brMiZjtK/LqUMElh32lYwWIRmZn511wpkw1WvIJGFutMrwsk59tsIG09G8W0kFdXZxKkgfL1def735fR3/Fpf2ctYSTeHegRRhVgAvQISZb4ovCwW5gwrsaQ8AGFNWL9q7QVZii1bNv33mCmTgWauVe3554cnjbBVXS/wbnLIxy7Vtz9787flmhwrX/feS7QP8DV1aU/jjZE3YqsZjsb0di50Btd8Obwe2OR8pv5Kz1m96n8UFcN+sWrrQHvMA7h2zK9oadI+QV7gvBeEM5eDY02B4NXsO4Jr1CGTiANzvLQiTpu4UvkZRBjcaXTeY/TiyInarwNqHbLNBnk7QeIbAPZ8qfKP9XDn06lfk6oBkbs1vXIc/wPbM9aYK17LUYb6xS48b/xgFqRvGjoSgCb3n5pMHQnrL7QbrvYXz/+9Aupz6yzkIUQ5rQcRscJ2X1J0UvVZ5Y/ytvyE7G20LUwkV5mqGnUM+awjZxmk9A2fdFmANyi2SrCKsQLA3WmIYgOZghck8p4c9BuaQwyRFlKo3F0bdqqCm9EINTo2u2VSIQ9CPUIONzpgAXipKcGv3ljHDdphBHurXX5+jpIAfmzcKdKE1Sll9ETquZdrUyz0ophFbUrmkaO7XKZI9oaOI94S7Zn1bhUHBoSpAL6ODLHw4u15NnYCUGQWB/oU42y9zpLKJpZurgt0FD4L/nCOx/wXXTImkVaqPJBx+EB8MAef5A63
 /Oec8pp8
 5qXCSTS8vi21ijfRIt+vmUQTBPhPgrtAbaeKF/zyVXzcYZTnJ4ao/fz56ELHWbcxAkDI3AyXdiFkNs6EJynOIWQpL3C5RpGhx1GB2phCOiQLgfED5YsQkHE1J98vv9V30K0YyqbhDwWJ5Vs9FrYLzkJK1m/TKr+c8bs10
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.08.25 22:10, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   3c3393d4b766eebdc475ea5bd6bbd3a221e2526e
> commit: d2e502b0fe1166f68c7ca5815e73ad12bf87e74d [102/221] mm/memory: convert print_bad_pte() to print_bad_page_map()
> config: xtensa-nommu_kc705_defconfig (https://download.01.org/0day-ci/archive/20250825/202508250425.yEOYgcC5-lkp@intel.com/config)
> compiler: xtensa-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250825/202508250425.yEOYgcC5-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508250425.yEOYgcC5-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>     In file included from arch/xtensa/include/asm/io.h:19,
>                      from include/linux/io.h:12,
>                      from lib/iomem_copy.c:8:
>     include/linux/pgtable.h: In function 'pgtable_level_to_str':
>>> include/linux/pgtable.h:2000:17: error: implicit declaration of function 'VM_WARN_ON_ONCE'; did you mean 'WARN_ON_ONCE'? [-Wimplicit-function-declaration]
>      2000 |                 VM_WARN_ON_ONCE(1);
>           |                 ^~~~~~~~~~~~~~~
>           |                 WARN_ON_ONCE
> 

The bot really had to try hard finding a config where that doesn't work :)

#syz test

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 9f0329d45b1e1..94249e671a7e8 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1997,7 +1997,6 @@ static inline const char 
*pgtable_level_to_str(enum pgtable_level level)
  	case PGTABLE_LEVEL_PGD:
  		return "pgd";
  	default:
-		VM_WARN_ON_ONCE(1);
  		return "unknown";
  	}
  }

-- 
Cheers

David / dhildenb


