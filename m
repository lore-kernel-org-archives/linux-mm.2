Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D348DC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 18:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AFA26B0088; Sat, 29 Aug 2026 14:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960896B008A; Sat, 29 Aug 2026 14:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828216B008C; Sat, 29 Aug 2026 14:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 585F26B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:43:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD377401A8
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:43:03 +0000 (UTC)
X-FDA: 85155179046.06.19124E3
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id D66A41C0003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:43:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=YaJycs+P;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Jhp8Foo4;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788028981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bd5PAmYpGy8JaYT1BKzRh2l/HCvYP+lW1f+KIURCm8=;
	b=dCwQ7QtQb1AjVierO2orUmsv4AVqyncDh802tuzwvS1PMA344mhXHPd4XKlfVDM2WpMM27
	XShvoDtxkchuYdojVhwpG6IOk0RpchSDcTKYTgTyy+WE+Gq04DJQSF2v+0cvW40YmQIOGd
	12QjCasbZ97dyVpT0rkLJUQhnnI3U8Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788028981;
	b=TRwv1aDC3qGc6imS3KaxXapKsI8HLkfizw1MDOW+5mSziZw3In6LRHJzdjP7l/pPsLdBoA
	WCzRWZXMitcXZD9QVtVCKMNZbGwwFfeWSyEuYUcJwcEEauSFxX1A248AzEtjsloeu132SY
	sy6kyRagPFfLBYDJS6IOwyh29fd8Wio=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=YaJycs+P;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Jhp8Foo4;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TIZ3oN1919341
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0bd5
	PAmYpGy8JaYT1BKzRh2l/HCvYP+lW1f+KIURCm8=; b=YaJycs+PgkXAxiEmTQzc
	x40/bpBx1OYZh241szBo3lKKjWsHNNTm/SUNCPAfRi3n/VvGgS3pPmiT6vJfeTeE
	GiYqlQAcB9LxnBFHNoESzb5esOccev9qrcQWHm0gEHQGot5RZ3TlnUHgTh1mlvDz
	d9N5rHFvicpTxBVJ1Kc7qEh1Y27NhJ6xXj8g377SAqIe5++so+krlfoZAvQs/gIU
	kCMT6z/E5NYAilPWjvHEyj6ymy4uPe3Gtsnyao6hjzXSseIMYastb0rZJFYPC+xh
	8rKV341s6RpP56zWTz8d8V831a4RBpe5IcA1BvubzOBoLFQUXRg3oy5g0dCR/q6W
	2A==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbqy7b0u7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:42:59 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90284139cceso40861466d6.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788028979; x=1788633779; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0bd5PAmYpGy8JaYT1BKzRh2l/HCvYP+lW1f+KIURCm8=;
        b=Jhp8Foo4Ju2JFAReeUXwwjpyaTTuEOn2tV7nAEDMgoTqk10UKl5fBdy2BMcSuKZpoz
         QYWj16JEhz9BTem3CU9cDpG4NWT2LaD2eBjueq01JFDIzgakiGFnKoXK+v72iT9ubdWc
         gSiYSRLzvh46RP4RkZZnVtFmtO58BAj4X0X6GVGovvIWY0/BQ6ZkBkJIcTdudbWqHHKD
         +laIsTA1USd7KFBlokdotjcM27kH7udLC2lcqTri+yzHY8xLFsKJ7gzrSCwcjtuDh0Yb
         IW5DU7z7PZATaJwr/CBW4VQZporCA2v0N3GbC7me0aX+XTwPXH0zD9D8j1T8IS7fmPYi
         XIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788028979; x=1788633779;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0bd5PAmYpGy8JaYT1BKzRh2l/HCvYP+lW1f+KIURCm8=;
        b=Xg4kyxkTpaTa8gWeIAoH+tocjfXF3uWJASq56T1++nuUlZz8yF+b33Ll/1WcdL17I7
         OYR/14tuOUqpC18R009kmAs7/Z0ckVqBPzq5a77d7iHiBtjAZsbIBy7JmVQA0Qygghaw
         aBAu0e4ilkgZeMl6EeHKcZQi0wssO8wnD/b8mcO95+Mp3tT1t5fvhW58emjLMb50ZjdT
         2Q29PHQBzS0SH8MmfQDt52e6CPmIVEV/gk1vObbwjX7kpyrqhGzUerj+JCYsICjIoWth
         R5O7DLz0vvO2yIXPhr0m26QG/9/LHc+QhGFgcprCNhKocWBiDdeftGQ8pdt9Hv1HH6vh
         Z9lQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp5IcIGlkt9EtUt0/cl2b9XYkkyVq3tjPUkq10Ff7YdokxhK6RgGTggbuhGaXEukFa+gzUSNAmsUw==@kvack.org
X-Gm-Message-State: AFuF++k5IYhgO83hDV67Ln6n+EzQ2R7pLDqPb4+PRdY/ow7RzUG8zXBB
	W94CFSoUh70iTT+dlYNUlQ96nY7jgoj6xwZm9NFDc6EmZQlfUj/UKXCJZumD2YVtEiZ4sjP4sif
	RhY81wIbEQtGM7lfAUHuWBh1QeVS1i7Vd5Q8tiXs8ABCbUIQo
X-Gm-Gg: AR+sD12WoujOLR6KQVAxhfl4qQbsxkSZ5kOcNMQch5dvK8JXvgHjbM/NtxWXkWhOtdh
	UiqOId5hiOOUd3SeZ43iDajQLu31NJauClsaPkW5lfuae9w6tGqNUuw6wrhzILe5AUT9LC3Y7R/
	6uNxwzNEdAjsoii5ExDojsthVm3EcxAV1eKNNT/5KbJF6e6aRgE2ae0iZ7Rxu/9naZZiXm4oF4J
	fNrjM45KcPK8/CemBotClKwFJ/SkXIY94/KS7NAVeaft0XQK8Xm39BksTo+Si+2qazUTI2eJBln
	5zdr3i42cJ8zFByqwb6qs2U8sg7891UuHwGdwtbMWEfijsWOEd1GQaUrBoO6iqfhoV4luO2T2CL
	Ec0ivA7Hzaqr5apyOKJB4sPG4IYPHVa+BcaiBRKvjdkvN0mU=
X-Received: by 2002:a05:622a:1910:b0:52e:4982:22cc with SMTP id d75a77b69052e-52fa1a4aab2mr249923181cf.5.1788028979075;
        Sat, 29 Aug 2026 11:42:59 -0700 (PDT)
X-Received: by 2002:a05:622a:1910:b0:52e:4982:22cc with SMTP id d75a77b69052e-52fa1a4aab2mr249922571cf.5.1788028978606;
        Sat, 29 Aug 2026 11:42:58 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbb32d30sm12171637f8f.34.2026.08.29.11.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 11:42:57 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 6/6] userfaultfd: collapse
 VM_UFFD_{MISSING,WP,MINOR,RWP} into single VM_UFFD
From: Tal Zussman <tz2294@columbia.edu>
To: Mike Rapoport <rppt@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
        "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
        Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
        "Liam R. Howlett" <liam@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>,
        Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
        Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <apK7s4xSgA_GmY7d@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
 <ao16VxNvaYzlt2WG@gremlin> <ao_9R3CbjYFipFu7@kernel.org>
 <apAB9GSnHNyNoSc1@gremlin> <apAcweThjiD-iIBF@gremlin>
 <37f6af95-950e-4457-886e-6548d4719f0d@kernel.org>
 <apK7s4xSgA_GmY7d@kernel.org>
Date: Sat, 29 Aug 2026 14:42:52 -0400
Message-Id: <178802897277.671075.10362065249796431311.b4-reply@b4>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788028972; l=1768;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=8Gj2G76gEDUSTrJh9wyKhjlV0WDG+1riVaR0UmTV1c4=;
 b=cMv3WyS297uSy6OhyEPKL7TFiV6NgPyRlli6/52vFPU3U+wxk43IDrwyt65mNyPQi/updU28Q
 fXkQOPOdareAvP+hQQ2rgHqvMZY30DpDTGX/m0/lnTSj2MdkKXGNeAi
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE2MCBTYWx0ZWRfX546nAJSPAWBU
 KsAsdqLk/8OUX/yL5rUtMlcwoiKdAauqf7GwCeIOlYmtwejWg519Ny20HHCjO1GEimn6D7wmtIP
 DTGsiiE/VFgu8WaGPKlfAzNe1dTYaP1nu6iYvn4+S/8frwiLLiOR
X-Authority-Analysis: v=2.4 cv=e+I2j6p/ c=1 sm=1 tr=0 ts=6a932833 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=kX8B4L1VaituP6mSkuYA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-ORIG-GUID: IDfiFF07_68q7JOJAumRiuIfN3fsLvy1
X-Proofpoint-GUID: IDfiFF07_68q7JOJAumRiuIfN3fsLvy1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE2MCBTYWx0ZWRfX/LAapiPpemS8
 o7OWIROPwqzguhFFvjP3djwyDh29OYSHk/c16lT5llcazJDnbapIRDGLJ5OfpHiRYYhvqZCixcE
 COx/I2pGQaq1oj6jBusJ2AHrcZCYuo77yHa+Mm/fVnNjc6NpTZJrTb264f3hjYus6f4Qf9WQE5s
 wxnl2WklbDcdsfgascAMkrvYBKReO+3cWGfx22yLLo02LRdsH8uXjxa4NyPIe1vPXyLXPBr++Ch
 vTI8f/zP+AZXMMBFAOG98HGO2lmpGBnnBYhE6WYCykZfnZbmOrnzbmW7El1dWk0kpA5hf9dW+6r
 Pus8+T5uN6ht6cLNQtU3S28Eim8ux0wHnzOlUrJVX9H+jp/QMTIppHSuXXwz8QqLdZm4LKzGM5h
 V4ax5GnIUZ53XE2KIg9bgCTuoYrows/+cp+I+by77qrn4AFLWiRXTUCj1pYHhxtrQjSxpPiwhtD
 UjbGqIRAdx0G8ZyXOSA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 bulkscore=10 phishscore=0 priorityscore=1501 suspectscore=0
 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=10 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290160
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D66A41C0003
X-Stat-Signature: 7pu9tf89f1jp4h66r8rnz7aicu6xiahk
X-Rspam-User: 
X-HE-Tag: 1788028980-572956
X-HE-Meta: U2FsdGVkX18bSj7IcoKR/zsSsSHRmbJsxpMFCssTJUORrDh3SuzBr/s1t7pye5q002OyuARStWETTU/kIdmSOnJXNtf02uoE0Pe56vgxYR04cGCFQ1jX5XuIwWZ6OILwLXC0eGU97WZQdKzKf7DDPcCvoI78QN5CVLUiYC/iv25xLKIXQ/oeZfolF8XJbLnFli1qIlrzFd34WfkJVUW9ug8QVZFPPSiJ1SjkdFpCHl0laKFVYDY5c4YGoVDA2FvtzC+GWMz+roWUbVeerTgEGG9cCGWpY2XPBNn/mhQ6cpKEWNgR8qL10WQcgJMp91OfjgVjymmOdEqgCZXSJNyYvA2oj4oDBipWt+ZqXb8hlZnVdyciDqVg3sU6Q2uvIy+uF1XgqHoU1YdUclineSzkh4mqYz7XXbdX4VNAa5mJwIrzIdCzURN200/0JS6Wgnwo7LUcoI5QT3iz5jXiS1kUukb2R3csu43XogTdYOGgJaM4OaGFoHszkDE4NXGOPawJ2Oihw0wEuY2LUUARVMqe9WeQ7pTkskfkHi82x7+iVdPflxWpUgM5svXqqTW++hY/Z6PzAht0Q+6v8L0cY/kDD+9Wu8v5GbVLFlFSHU9H4Zs1SrK3y14I6wsh4LDMJynHioiJDDywqP0vtdp7wW1q28fQnM38ADyvjEYeiR9lIKSDI91tAtA1jl1iU00jQl44+6Orxt0dz5lll65bGoPO4v/PeQ3GmV0UgjYDEtDzCbKCrQXgiJHi5epcsGiU/89zHeitPGIf9lLg4Llt4SKQ8om3s86UzidkLGQhyM/aQ/bZTUtm0eqbx4L82YaC3YsL4uF6Cd/Ybz4WQdH9sJEmstEXiiHQlyMYtBle0ob94VwFFMFqtWk+75kt3y0dr522b7ayNsXnK7EMtolQJhiJ/R6DKg2pH+zjn71oBtqLF8cUj0pESRH42SkClyYzYJ+YAWkxOXxJFBqTSx4DUAU
 zc0LiCl7
 wo0//vswF6G8RKxhxupAEqoQIRpsNJAkQ1dfLEmt8ai3+QYSIKuVmCnSJKgM6114lXwwZo45l9cLL/DrP2jco4WakgO3MdRBMUs1SJWYqTkAF6OvOV4pun6W2Ge74IW56H81r28nIv8MfH5uJA3Wc/iieY/cbkQ6HY8LAvUC/HAOMAXeMffRUwDEvgbBF3hL0W7wWOsUDhCLD8J/V9h88StYe4QQymfItapME8amig6GUUhxmFUqCsE6loVBUROsNEvClAHszbQfr9pUbEmLygYBaGxQvqBP2hLulcxfW0oDrJa3eP34ewgOG6yWuYHcI5RPFHoWREAjUu1LsZf2VKF/Pke+UzTyplVOl6D9iOJF+YsklEVxiS92djm+VjLsIPu8MXae8Im9TYCiqfjEN4KN1lm+0JK+ZfOoKDfV7vsp4YXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-29 14:00 +0300, Mike Rapoport wrote:
> On Thu, Aug 27, 2026 at 05:19:30PM +0200, David Hildenbrand (Arm) wrote:
> > On 8/27/26 13:18, Lorenzo Stoakes (ARM) wrote:
> > > On Thu, Aug 27, 2026 at 12:16:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> > >> So actually you're increasing by a cacheline and increasing the VMA size by
> > >> 64 bytes, i.e. 1/3, which is unacceptable obviously.
> > >>
> > >> Maybe there's something that can be done with:
> > >>
> > >> 		/* forced alignments: 1 */
> > >>
> > >> Perhaps? But that looks potentially ugly.
> > >>
> > > 
> > > I say elsewhere (or think I do) but to highlight - I think probably we could fix
> > > this by putting the flags in the low bits of vm_uffd_state.ctx?
> > 
> > if that's possible that would be clearly preferable memory-wise.
> 
> This gives only 4 bits and makes this completely not extendable.

Wouldn't it be 6 bits? struct userfaultfd_ctx is allocated with
kmem_cache_create() and SLAB_HWCACHE_ALIGN, and most of the flags are
only available on 64 bit, so it should be 64-byte aligned in the
relevant cases.

(Not that 6 is that much better than 4... but it's a little more wiggle
room.)

It could in theory also be bumped up to 7 by setting align in
kmem_cache_create(). userfaultfd_ctx already takes 192 bytes due to
existing alignment. Aligning it to 128 bytes would make it 256 bytes,
adding 64 bytes to each uffd rather than each VMA. But this sounds like
more pain for little gain :)

> So I think I'll drop this for now and wait until VMA grows another cache
> line or until having per-VMA uffd state rather than a pointer to per-fd
> context is a must.
>  
> > -- 
> > Cheers,
> > 
> > David
> 
> -- 
> Sincerely yours,
> Mike.
> 
> 



