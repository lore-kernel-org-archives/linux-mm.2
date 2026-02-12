Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8220EB2719
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7FA6B0089; Wed, 11 Feb 2026 21:25:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4658E6B0093; Wed, 11 Feb 2026 21:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364C66B0095; Wed, 11 Feb 2026 21:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23DE76B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:25:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC49BD6FA7
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:25:27 +0000 (UTC)
X-FDA: 84434213094.03.ED5C76B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 80FB940009
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:25:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aWdm6wEm;
	spf=pass (imf07.hostedemail.com: domain of coxu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=coxu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770863125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BW+Mgpaq6SwF9hkVhCNywA9aCMpLFaTHrW15uFZTbFY=;
	b=1uYFQJ5LUNflq2GzlcbZkZnI2yPeSR713CyVE3D8B6t9HDvl+05iKZmU47X18c8zZY2ugG
	/qT3uMf88iwgk5x059MChaDXBvk8gWJVRt6b69+Bi74SsnaI2+3m0GmTq9OqZ4qBzlWC1j
	o1fRwB6cHm/lK3efMdyzg68IIqSLpIY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aWdm6wEm;
	spf=pass (imf07.hostedemail.com: domain of coxu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=coxu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770863125; a=rsa-sha256;
	cv=none;
	b=br7VknZZ6cS4Hc+PPHheTa0XN9IZQjcSqtVOao6EttzVi/SRw5j6R67snhmqYJ8Xfhk0FG
	uCCsIq5MmTH0YBNFLYz9PQCVRc9/IF5qcJM7DO5TihE7awZ8wbSDcEGdPYVvGxVKWv/kjt
	81s2SvcZJ/M5+ecEGy9Q41ZslpvB7aI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770863124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BW+Mgpaq6SwF9hkVhCNywA9aCMpLFaTHrW15uFZTbFY=;
	b=aWdm6wEmGAPcy/Y9swaHVWXF1YjSWPSSe57VSJ6UmNOHONNnxZEcI7ovEnTVdkEIus8Woo
	sE3AEZzqfQaG/GgDQUq+GR/rHtuoSikskyLuFEnlbPt1OD9Ve3jaReevevX76S+vAlLlNJ
	CPfN0pAVOBOpCVzYJ8kD39AV2dHHbNc=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-VGapQ_iTML2TU8t4sxq78Q-1; Wed, 11 Feb 2026 21:25:23 -0500
X-MC-Unique: VGapQ_iTML2TU8t4sxq78Q-1
X-Mimecast-MFC-AGG-ID: VGapQ_iTML2TU8t4sxq78Q_1770863122
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-81d9b88caf2so2596253b3a.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:25:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770863122; x=1771467922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BW+Mgpaq6SwF9hkVhCNywA9aCMpLFaTHrW15uFZTbFY=;
        b=u+ayfyOyS1s+UObKHXKSYa0rQh1lBZ2cmNNW7Q83IA3HsWGrwH8T6vqd5UGUdgvuM/
         uKvf9YXUp/RLvWZBRk5FFuoieiJGpUR2hnz7B9d1dH0TzSEdH7bH/E+vFZCo2z82Xnaj
         +vtZPhLMRa/slRDDTkJnOSQ7L8lSFB8itBcJiHJsc0k72HI2AxjrWAd7ey55EMPU/iZA
         C8ODgMoNlU3LX7QIXeYxpyMbEgdngoCUAlTIpodj61gx4NVwPreQTPcTRGl5mT2ywwDT
         WTEBsZAjjsDel6HaKIKGIHT0csZ/r7QhqpqXwsRu3mg/QRpJqc7ItFnjJ7rWg499vzAG
         ZMtg==
X-Forwarded-Encrypted: i=1; AJvYcCVU+++AhWQFHU1/SsTjslFqeCLkkI9alz3iftc50UFCxGUHuLjeLEtwrm9GiC1NjD1UFXwXHEx/MQ==@kvack.org
X-Gm-Message-State: AOJu0Yx2OqqBtBUS2sAKG+nTVMOwEkFQNYwqZOzBbuNS7aoTxaPhxMkS
	emGLQ05EF37f18ijycbfik/7X52KJfCO9e+iU7IWmnVvlUDoVoxogpioLpcFha93xpG4vBzVWCQ
	aHooJwQrFixH+dHa+h9pa/5nbSjf3l8usyZ0CP1pcK4JyIulYPRO4
X-Gm-Gg: AZuq6aICU/uEj6TsgGCIiCRFZSXOHf7QmWilfehXh7ODH/g3JT2jYaotKAR39f3C7bJ
	nbdzqSqoO6UGASG8qRq7L6JjzWoCl6BfH6LWUW3KO4xqzemgCVGA5C1JapEqIx5DHL3oE3oG0SY
	lntfpwaGH3VAf6iu3fP7W5O8oT35D940gPWMTWZa3TPm74HGJraEq7YZr40jizaEHcZLU4Dl041
	/5HnanVzcyoiUsDmXLsl/2bfv5y3hkbFbmdJ4Q0aOt67zoX2pDQs56k2U/whbdtyNoPQo+qGEV4
	Cbt+qr+qgGYzsxRVAvZtdPnwpGEIit7WLcevGku/pCqZfqBZgDFgASs4daIRA6qtR8iywmPBm1R
	8vd5aiiQwIHN3
X-Received: by 2002:a05:6a00:1d84:b0:824:9451:c1ee with SMTP id d2e1a72fcca58-824b3068659mr493717b3a.55.1770863122001;
        Wed, 11 Feb 2026 18:25:22 -0800 (PST)
X-Received: by 2002:a05:6a00:1d84:b0:824:9451:c1ee with SMTP id d2e1a72fcca58-824b3068659mr493667b3a.55.1770863121385;
        Wed, 11 Feb 2026 18:25:21 -0800 (PST)
Received: from localhost ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e8198a6sm3984873b3a.50.2026.02.11.18.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 18:25:20 -0800 (PST)
Date: Thu, 12 Feb 2026 10:22:10 +0800
From: Coiby Xu <coxu@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: kexec@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, devicetree@vger.kernel.org, oe-kbuild-all@lists.linux.dev, 
	Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>, Baoquan he <bhe@redhat.com>, Dave Young <dyoung@redhat.com>, 
	Kairui Song <ryncsn@gmail.com>, Pingfan Liu <kernelfans@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh@kernel.org>, 
	Thomas Staudt <tstaudt@de.ibm.com>, Sourabh Jain <sourabhjain@linux.ibm.com>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] arm64,ppc64le/kdump: pass dm-crypt keys to kdump
 kernel
Message-ID: <aY05DpHN6QL8xQQ4@Rk>
References: <20260211082401.2407853-3-coxu@redhat.com>
 <202602120648.RgQALnnI-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202602120648.RgQALnnI-lkp@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sLbRSmwClMbtafbCGyaZT-2St_8yydzg80pTKXeh-PY_1770863122
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 80FB940009
X-Stat-Signature: 4pbc9o3c9smsa7jepadkq8cnue7cz79e
X-Rspam-User: 
X-HE-Tag: 1770863125-578649
X-HE-Meta: U2FsdGVkX1/fwlM6Oi9UB945HVr3dupPPZRA90j07qeAMxY4WK7rcRrNNyCX4l4FtDnb0ZViT4ubQv8a2QvdBeVVK2ZsaVVUL0fxj53R9dh7yO/ZjFtbvqJ+0VzSX/o6y4OpiKZvtsbMpBxfGqkIEk5zTZFAndxiFEEqgQi+ZaGsD2/rsaH/43eeijMMwBeUOaqIctnTW5x9zR+YVeb1g6XDYdG8W4pu2hzr4rgMnOMMod+Qc/VhKHlPp/LANGR0BYsR7R8486J645Y1DqCIhY1vvJFBSmRIkng3CbPH+ae1nTPdfD56KTuxaEMr6dgAomhV6gCds23aOzpqOl031Bd4rYxDkpu5NdD7Fqyq8wV43tVQQmwIzgiYC5Q2cYTg+Vci7hq0LkjPppiEanjcrMxJXGTgYX2NYwlsN+4Vj9bSyXeW622EuZuTPdwjjAo2oDFloWzQDfWYoqG2fMuQsOLc6EjgFV7v2teD5zooPkVywvMkfzdClemuIxe4eJKWoO1S93HYpgeKYCDkrdE+W9Ts/daw3573nZGdfrjLdwvU0gogkPnEFc54P8RdlBCduJaZ+MFU/NVYikeCmTx1iDats3L5rcJ/etVTZLJ4B8Rma7D50PC8AsxYwQkUZoOHjF13NrWbDGFf+7UgNnJKvUISiWmzbcMIMOXqZ/W5DHMh+CjHKK+Po4g0+grqsLC54SXLEpUe60ncri5t5T1cmMPV9mu6LfMPpxeR3C8Otiq3xco/f2PyocvqPT7dmfUeeoTSR/+/6Nb5JmeXnoK2FU0azp9JBH5Fw5TVrRSFqfMN38oXMvswuTbPkBfJcHtJ4Fdy9S0RWrirljfXrvi3lBitWM3k9F4RaPIbs4S8tslp7upEXiONSLxcbvebBn0LJqWAQeAuVSnx+cj+4IvpiU5qXhsNGXatXkPah7ZeSR+FtGqEax94T4uNXurwQ0QvHUjU3WtokuIlBS3e1FX
 +ENRqCCd
 yXuiTPf3j5myec6LxV/xb+aCg5MkU4HHQKP7uyGyGXUiiCXcMpXyODIlUbiiFAxQUe2oWmAAgQw+iwLr4SwAyyYLpa5e3EPnZosst9BqAuMV5DijFKU94FoJQ1zZitpAALSC52g2wFepxUpGh+pzD73f/Pkv/fmPrnL3wOnS0AtrOR0t6aKIyWTLOdG+pakQB+h9gvgoejcqS9kdL2QIMhPyzvGIbqYRzFgL0bT9wmH/t7ctvzaqLw+50ey5/rwPdxk/4Va18OGFhxWC//WqG87bvyo/wzsTPnAepfYTOFqpQl4sxIkP31wvOAB2HMckvYESFCPBa+m5/8I1eP4GkHGOAGcfepRuZe/KBkXd/VAeOK6+jmXp1zrnnWFXW0WHUVRq8q7eZSjLIHmwv+b/CoF3gmQQ3Z4NooZhDyk0nXVOqaorwmEZ3cm9HF9NnQ6xwBbmyFcgV2c97p1H9+FCz5Zi2mnzJiB9qNZuCRFAqmK4PTNKHe6Kq6b1jts11zvOiW39UUhvZyn6FeGfpTin6M4H6kKlExCobrjTinJ10MWqb0w78hxdOoX+RHwOTcCjcMlQtf5fYxn7HBsl/G/w6dniu3F4WpEY91kScws/FhQScBeIgAM8BgIpgheZqVAgRIUZn5g3qgbnXX4ls33jd9AlYwXW2+49R1opa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 06:35:52AM +0800, kernel test robot wrote:
>Hi Coiby,
>
>kernel test robot noticed the following build errors:
>
>[auto build test ERROR on 2619c62b7ef2f463bcbbb34af122689c09855c23]
>
>url:    https://github.com/intel-lab-lkp/linux/commits/Coiby-Xu/crash_dump-dm-crypt-Don-t-print-in-arch-specific-code/20260211-162729
>base:   2619c62b7ef2f463bcbbb34af122689c09855c23
>patch link:    https://lore.kernel.org/r/20260211082401.2407853-3-coxu%40redhat.com
>patch subject: [PATCH v4 2/2] arm64,ppc64le/kdump: pass dm-crypt keys to kdump kernel
>config: powerpc64-randconfig-r111-20260212 (https://download.01.org/0day-ci/archive/20260212/202602120648.RgQALnnI-lkp@intel.com/config)
>compiler: powerpc64-linux-gcc (GCC) 11.5.0
>reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260212/202602120648.RgQALnnI-lkp@intel.com/reproduce)
>
>If you fix the issue in a separate patch/commit (i.e. not just a new version of
>the same patch/commit), kindly add following tags
>| Reported-by: kernel test robot <lkp@intel.com>
>| Closes: https://lore.kernel.org/oe-kbuild-all/202602120648.RgQALnnI-lkp@intel.com/
>
>All errors (new ones prefixed by >>):
>
>   arch/powerpc/kexec/elf_64.c: In function 'elf64_load':
>>> arch/powerpc/kexec/elf_64.c:82:23: error: implicit declaration of function 'crash_load_dm_crypt_keys' [-Werror=implicit-function-declaration]
>      82 |                 ret = crash_load_dm_crypt_keys(image);
>         |                       ^~~~~~~~~~~~~~~~~~~~~~~~
>   cc1: some warnings being treated as errors

Thanks for reporting this issue. I'll fix this issue in new patch set.

-- 
Best regards,
Coiby


