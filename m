Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E9C1CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 14:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFDD78E000F; Sat, 16 Aug 2025 10:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87778E000A; Sat, 16 Aug 2025 10:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976458E000F; Sat, 16 Aug 2025 10:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86FF88E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:05:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0133CB9849
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:05:19 +0000 (UTC)
X-FDA: 83782792758.20.8EBEB76
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id CE211100009
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:05:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mq7GmEyT;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755353117;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LehmCnZx1yko/qSdfjX6v6hA4L40hs+khHZtFziTSWg=;
	b=Wsh77nm/ieHUgtmsHGU0WCzA8X4gEHYGdhRTediyeX5GDCXI1TO3fIPP4l2aRL3vqqMKcv
	Zdf1z5EyWfr8Znn+D+yn1NrYRlkHgkeso7TIkHX3VHM/9EqbCvqmDY0do0KldY1PkRPhfP
	Jmlk6IICZCR36hZyfdxFpaaM0klCZK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755353117; a=rsa-sha256;
	cv=none;
	b=30wvTZ+GAnKtyINFYbiuyuk1I8QWzK4gib11sinBoN86DDfpEyG3crwrnZSLRVBgweoRQK
	UoDDX76fV3GFvMmvR4dSEYA+I2zqWAAJPGH0h2YgICXoLjdUvu/wJze6T/samgjNzXNG0c
	ecJQRHqRf7cGx2v3DwIxGL5lvpkL0JM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mq7GmEyT;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb731ca8eso457773966b.0
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755353116; x=1755957916; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LehmCnZx1yko/qSdfjX6v6hA4L40hs+khHZtFziTSWg=;
        b=Mq7GmEyTTl/JyZF7wxiMQfl21JKmMRgC0LgbOAv1daTvddjIi2OSY7ZDygU5uN80i4
         3D0XbDN01mOuVMOoeVrW3iGLhNzjcYo2iFaPWQefn/rrAZqKhE0Rpz5oZzR2soJInHWw
         i+h2rhrOm/znJNMCqjU1j0TOVfCt+uRfrTAc/Qo/ZHxcauKdQTBXbx3scUZ6WooNMEfu
         h11JuZ+QSQhqs0Pp42KX2xkjYzhYWogw2ndP41txRx8fh3DGzFqj9VhpSAGPg+HADHmN
         BVLG5B7cG7xFsniQkJkBCc5NJ8hqDOm4d1aWFnjwEsgSnWctbQcsg25ukOzG6aTkjIic
         nryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755353116; x=1755957916;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LehmCnZx1yko/qSdfjX6v6hA4L40hs+khHZtFziTSWg=;
        b=JWdzC/l2Elesp+JxXbitMIZ92fPDCnGxG1krRTVssYYjNfOwUe5QM9NjV+hMyjQ+B4
         UJm7cdxdhEamWKc/+fKJq3anS/JhBh4BDyaVAY+TFE2BvJq9gWOmvBzfMAyxYXVg1oJ/
         tjQzKB/GcDEgZpeLidItWCLLFtXqLe16wYva7EsaipMIQkH9nAHi47T1tTpuEc9k1ShG
         o4dXK8E1y0OyEGCyRQH62mO0QfojSEC/RW4EA4KYeE53EA/xNJEnalKl1GlemZpgIQKD
         54JlyQmbKltcJIV5h3Dzs61YHO9UUg04pJZtSNGlKQ2QKk2ExT/C3vLLAexKc95uoy7B
         61tA==
X-Forwarded-Encrypted: i=1; AJvYcCUhnRSAkQQeNlXBWBloaFAXkIBCLrKTo5JZEs8Yahx5CKt5m3tF9Y18XJeRUA0zWcmSJ6BRmarJqA==@kvack.org
X-Gm-Message-State: AOJu0YzzH31IUEEjigkfLVFyH8eSIGJWj+ZJaqq6fndUULPRJbPPyaEL
	mmjWhZ3+xWkl0NkTz4JRNd8W2ISgUZ4oWgaG84tNEtVrcxVHTMpoXuY6
X-Gm-Gg: ASbGnctMpE4N7nQmzvLmaOqMwlfaNEZ78zYzRUMEZX4D8vwSVmb/hd5dzaz7NYXzTmM
	EnJmh/3UJb/A/J2N/iknbZ0r4HYK83oPLOgLPgYmZJR6/paIcomVIxKT3oG2bjQL8ilHW6x0g6v
	XC2/ZR43ob4zB98YXubcVkJhLJy3WMLL9p+s2NgnGdG9ncs2Ucvo4dLdJDwAwCH9kg/9EodFbLy
	p5Yl8yDajfzCIRxqkaZY/lLxtEqJ1LSux50jS7Zo1bI28MZtD+RKYnbdBXL1yTZfXiPFOisBwce
	njEB3k1hUB1prN6vFlB7SbAs7pF4qen0Ommw208CeeBB7LIJjoWqbK6+iLTkgR5YHPmP5iWs3rr
	Rxep61Q9aGpXA3lVDQY4I3Q==
X-Google-Smtp-Source: AGHT+IFNBUk8vITn40hxacWVUuBSPpKuZF96ELm+tG9TnV02/li3LJAECvOdiM/TTO4mOd2zz+lBuA==
X-Received: by 2002:a17:907:7291:b0:ad8:9b5d:2c1e with SMTP id a640c23a62f3a-afcdc35df57mr544419966b.29.1755353116251;
        Sat, 16 Aug 2025 07:05:16 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdcfccbe0sm385523166b.63.2025.08.16.07.05.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 07:05:15 -0700 (PDT)
Date: Sat, 16 Aug 2025 14:05:15 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	donettom@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 1/7] mm/selftests: Fix incorrect pointer being passed
 to mark_range()
Message-ID: <20250816140515.do2negtg4e2onwrf@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-2-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816040113.760010-2-aboorvad@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE211100009
X-Stat-Signature: 78chmkn3sbz6goye5h6czo4hfpxux7gr
X-Rspam-User: 
X-HE-Tag: 1755353117-491595
X-HE-Meta: U2FsdGVkX1+QZVGIzuNECIh8QCC+QZdzq9nHMazu/2fF8Xs1HXnGfsTuQBzgFca9qgFfincgZYqH4q7ugvGjF66gAzLy1INukaDE0kMag2lpmMbKtEvtdgZ3zgw6z3YpssIhdDY5iyPJ99XWu8ec5yZbWGTiVral7jlNcoBCOpBl9F2W8hyipFjoE9DpXE1Lxe0izrOfWvo401Ins46Qov2IQeVrIr0KUCmzfr8aM0CjKSIEmtUiY2NO9oV3olylJveKi/GsRoqOeC4xfFyCuT+7tsgSZdzP+lmWUrxamN/A36iSIsEC98EnvPyQFlWngWQG1TYKViMKSMRMcvqZwgMM457L8mMMMnLGTBpvB6BM+3ygcCWlmS4+yMYo+QpIVx61FqRLTJrvjGNHHblKeQv4Bd4hiZWgw74exoPpoGbqyfBoRePIaG0Y6TqVUfbKSs34xJHXP6AbnlctgYRNdLsjGkt6Bb9RIs/x8acnRtIV6UNWQdl2bvjALuLcEDJKwqunFjhtuQrmg/URG8Mve5tg2DYn4mPwsgZvEpVgccap17GY4i6ezLX6rwYOhX40pK6YuCD0qdldDbrIPveEw+yx8CQHM1O6Qnd7zz+yWa4eD1drDZXZH1Oazt17JfvTrVuMo/kzgiAoxLHKrTk3tcHo5NBoA3wkNVrJP2dUHU1kenQ3zeux22NFQQw6guOA8wbfLgSOcKsJaa0RgrMDriBlOeZUPJXpNOOXOvrJPMjMbs7U6W+Ee2DLqp7mzgHoeKfWqfp77AAIqVXbpXn4S/linpOn1VJvExuq8zvlLDeh+UhtYWE1ml+cTKJg0IAxEcOCSAzVW2w94sEsDeWbZNY4qMQBvicV1Iwi3kSEHDJb/dK5Zy/KxEjY6N6Kgl/mMaSF760xu+PttqeDTt4wpvkVKjVVw+eArLbn8u3E8ia8oqfid3H7DNeroFyEUX3V/4HUHlL/fElFBXNyFd5
 vS5Hbl0Z
 L4eNmV1OFHZBAt/UmdW68uq1kznwdW8oR/0fPyqknbdYVMlHomY7tQILixjPTV+g980rDhsdw1s7EpxfYK/cauzQTexF3FShvvsnSTPmGMW2bwUYZyNRxSB73lypfJE6w0r2cimZ9lAqNHjqHjaYHQh3voYRMs7UBlI5LWh7Z6SeG4z180l0qR0CJ7K7/Qtq31AqI/WWpMlcJDp2bWWQb9qMH2MN0eYia9CslvQXDyZrDmblQz+/gMpJU7QqGsCwwzF3CIYZKby51hV6UGqdH3vS/dRagsyajvAuHiTjqHz+eCuFDjpgciWWM1Kr1GOzZlUi/rhmBWt+2MK2ka66Dh2+J4QPN1wOXRMzpreGyfQZSbqDLQRkqxQAlazVGIRETnKeszUIPpHbQJQwcei+YuAENLzn5OIZb8nkZ8XTOhjzlBHUYxbiNyAwDJeoIzjA14NZKIPtzyMn6rErE65kwkp5fXEZ2xZQADXFovunt6Gny0jFrtRS9uS9oRckGQMDjdc3V8QZzF6ak/9xfacL3Jx2l/EDKZPRB3vx0pdaHwJeUhYV1UQxcPA73M7+hd9lodpipAQ13Tps2FiRHsNQRazTdFAu+iUQRPk7vtfS4JV6eQm3UOUz+Biux5DLMcqi2TaTEykkxX6GfWtGVN2OG3CtQt67z8YWeQzhQULGLwgDav/z75wtrkyKdrAWRiMXqna031JA2JYedZp9rDbhDnLlDMFINxAGe/lDZR/e0V+Yj49vlfoLlzeNEcFVekE9kztBtBUgv2KafEZbJwNK9BC3ZhXUcwcKCVdsQYsyeJmGVk28fBUu8wMz66xH4Jv4iKl5tP/u3Fx/I+33k8pLEO7bnGo/dpoYhNJS0fC84mFDXsOZQ4TFBld9bX6us/VZ8nZgx95CgmspJ3Yxat7FbSU5VCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 09:31:07AM +0530, Aboorva Devarajan wrote:
>From: Donet Tom <donettom@linux.ibm.com>
>
>In main(), the high address is stored in hptr, but for mark_range(),
>the address passed is ptr, not hptr. Fixed this by changing ptr[i] to
>hptr[i] in mark_range() function call.
>
>Fixes: b2a79f62133a ("selftests/mm: virtual_address_range: unmap chunks after validation")
>Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>Reviewed-by: Dev Jain <dev.jain@arm.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Donet Tom <donettom@linux.ibm.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

