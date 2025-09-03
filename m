Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68A9ECA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 11:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC95A8E000F; Wed,  3 Sep 2025 07:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1728E0001; Wed,  3 Sep 2025 07:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FA38E000F; Wed,  3 Sep 2025 07:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9862C8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:54:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59D23C0640
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:54:57 +0000 (UTC)
X-FDA: 83847782634.02.A9D6C9F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id F06C21C000B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:54:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dDRZrJiv;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756900495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vy+lxzXfL0kgtP99rbzpLuAz47IO4D0JFyDaKKvEah0=;
	b=I+jNFdUGMQeJ3alVe8HpKGtzCpWyUnGOf/ml3kL7dVAdLafxVoXULasbEW9G1bbtPLdItT
	cEHwhxAkwCF9Rh9XLMD4zjPE1Rz7534vmkvAY0/d/VzED+P2Tem42qfnAOH6rUFmaiJUNv
	CyFokk/JNMi6mgz6yB2ONI8lBAh7s6I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dDRZrJiv;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756900495; a=rsa-sha256;
	cv=none;
	b=xjASiXoVJaPCPbBQnehY8pNKmkAXsH8AQupgTssrAf6Tue9Eg2+AzdyDDV1I9Ph0/8Is3u
	vAPDDTfLHqI6s2uZ07pcn6gb+vYfjBLGeAEU3kgieBChkebrtBk8WhyTwVdBg2DSwaiEmw
	uOUQ+kuOeMe1WDqo9Xvisols0VihGZg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756900494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vy+lxzXfL0kgtP99rbzpLuAz47IO4D0JFyDaKKvEah0=;
	b=dDRZrJivtvIXxAnkZlWy3Ku1u91kpQ9r7ZOtO4MW9APA2iGkP5vOAc0Zibs9ah5YSg9Qd4
	YL1le+SSSiqnmpdQoptf/1RIzejR0o91VVmuZUT7lxerAC4ayxpJ97HlyPHikKfJFUn4pO
	SLqqiYzgCG97ecTNtGpoCnNK638YlGA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-Lt3y4LUIOSWRR2gCVpTkOA-1; Wed, 03 Sep 2025 07:54:53 -0400
X-MC-Unique: Lt3y4LUIOSWRR2gCVpTkOA-1
X-Mimecast-MFC-AGG-ID: Lt3y4LUIOSWRR2gCVpTkOA_1756900492
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b96c2f4ccso11452475e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 04:54:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756900492; x=1757505292;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vy+lxzXfL0kgtP99rbzpLuAz47IO4D0JFyDaKKvEah0=;
        b=g5V4PYraudGT5i+yS4B87U50Sg/FVzs4akv1UTWKh2zE2sTgWJL4WDKamja3A/MlUF
         rGklsVTjZgOLYeA8KiGRtGO1TKkpB30lDmWYK7clZhLndy935+ExxWdWa+9B6NrZXRop
         F/AZrC6O8DM2s0M3cWZ7yMiSIjHHTL1H3IPW8l4BKzvdZF70pBmrJALDD1+zi/UiTibx
         PTr/3D+MwO3pLlz46mT+gpA8YMeqhMfINZY5epYLB96jE1JRmzsbfju702ykqIYLpBLZ
         bzFzIstaPrmdgluM/AXVr/itzbombjzp1EUIHtV/riKiofq9GEfQMTSJ9gWjAtV42k8N
         k/2A==
X-Forwarded-Encrypted: i=1; AJvYcCWf4CgPlDA4c+clo/O6i+SDDbgdhgmDixTjyZC5eZPhtTRgbod7SQKN5QnUaEBPV2XcTyy0bsSPoA==@kvack.org
X-Gm-Message-State: AOJu0YztK4FuI1eZg1r5JA/oGMWmT0k8hw7/VnaTvw0CMCsw++T5zcPt
	vygviAmFY1c20jM8E1pexFExcYbZ/nwlzkZeq1Baks0y0a67Sd0iqD4fp9ct4tg4ZpnjJfduxnp
	Zg7+rXmGr2fQMTLage4npRpGdd5pS3Nkqita0pk+C+tN3KgloY/fg
X-Gm-Gg: ASbGncvs6rXdG9te4aRZTQej3g7tWOISyx6L/ScoDIY68KUjKoSobq2xNXrv60k/DLG
	eOCxBx28APARTM0fXFNPSwG4v3oX/ZVgNxNnQr8YjCA4vzmJJkB7kJDbNizJqIIua0FeB0+1TfI
	ULF4+DjjypsV1eRNIpZ/tXcpi+S75c6IdZSoLsjfd55vMcTe1H7EflBZ1fPYbKULIdI/qIXccwk
	6lcWHBpgFd8nvRd+30ZVBpBsz+OPRkc2sQzA+lTcNd+yKszMpjR5wQpxbzLkVaBRJteYmQ0474O
	tAdOP246W75gCYjgePgQjNFjcQ1eeW9FIcNQ4JUR9Dbcd70XURQzLbQTQod9wQ1guX00iVwIhVU
	CdV8AQguAhOawcoSTBnmUDaNKSW9WlAAVGaTIWvmkkBQSxmsPHNBgc+ez7NESIamFmwQ=
X-Received: by 2002:a05:600c:3b07:b0:45b:b05a:af04 with SMTP id 5b1f17b1804b1-45bbd1e7bdemr33528675e9.14.1756900491953;
        Wed, 03 Sep 2025 04:54:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4cpqBq++Zrb9IT80A4uabVZk9ElZFleozbFNUtapOQ1NF258s1FbhAQ7gOCAX/tb7ptHTCQ==
X-Received: by 2002:a05:600c:3b07:b0:45b:b05a:af04 with SMTP id 5b1f17b1804b1-45bbd1e7bdemr33528325e9.14.1756900491452;
        Wed, 03 Sep 2025 04:54:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0d32a2sm347689785e9.9.2025.09.03.04.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 04:54:51 -0700 (PDT)
Message-ID: <735f70a4-049b-4be7-9d08-97e2b326808a@redhat.com>
Date: Wed, 3 Sep 2025 13:54:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] dma-buf: heaps: Add Tegra VPR support
To: Thierry Reding <thierry.reding@gmail.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250902154630.4032984-1-thierry.reding@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 05rbMtSXut2VUAvQHs-Hln2fltR3Xfg0MT3sBp_F6mk_1756900492
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gspyho4bkhmmkgnq3ihn3mcncr7mq5xy
X-Rspam-User: 
X-Rspamd-Queue-Id: F06C21C000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1756900494-588999
X-HE-Meta: U2FsdGVkX1/MljjjHnFW2LGvCgCTL39fNobh2T2oRJU13y230KQ/kAtxG1ReHotKP6txJd9zpQJZmHSISB73Uj5sbwT2+Eyu7NMrDJClFtAqJCp7+IJzfjagBZsndy/1tkUATxVvmb6acMYuyTjk/Whw7PDq09gXspuSCwsf7HHNGo68QDcT1LYCXZMZ3tdxiBmRLRITHx5hX0kexvgHuPwzGADlZF7RDmJr999lgDlRDV1yaMZoKAkVC17Mo6RZ+Ul50V1vTvttv4IKVY28h6Q8MfdeTSmCmoy4p/sr7lSfLREmEDFpQr7yH3gtL5mLPlnMmyOkB8iGYAa5caRr5HK746F6zOGiqABKRADhXD4GIMITPVd5pVJnAbGIHCnHhhUm+ZnT6kyivsUN8LTucKkqpk/9A+zWzb2ZyZkrWqDb9zOGil11MYOYCeU4GbQNZHKz9q2hBavdPqtRB9CnHlI1Dd2w9kSfSOWcwVooVNREwY1eskViQ0AzkmTHefjnd/sEBEv5o6MONfRP+qkSVpaTaqZseIeG77Qu4EcqwrSKlSwE8tSx2DtRBqS/KM3MvupI/gvPMXK4oSW+tNM+SFJ7jynLMcG42cPu/6HaotJxRlx3HlHCqq/VDXXg3mizjagVWQ/zgBdw1HZeyLseF2XvDDCh3+DXQDLoH/8cDGZRgaHh6Z/tMPo9PlSoyegcCkiKCoaanckrFojxUefjmQXMotmiR8XnZPVTRP3dGrbEfyOWPZSNUv1MY5MGSoklKbeenM/J4dzYLIojHjbeimlXrgoQEDjxFMfW8rPl8QnLUj+n7bM9N3Dwx3YxolJwoFtpw7KtdueUJOUnNaJXnFlczKznc9APcwmVVOgxlptfgDVgi0z9TnYJA2TosBngoQmgjS4UECW0FiMFfPC8lzD6Jt8CoDxv5G6ph82pejcQRILKqfa5ltZxr7XjeVSPwjYaewPTHUsG5Q+LbR+
 dBTYiHAf
 0qVTwx+KT68pSdGPMaWvuZSxjP7/CwD4gKN+eC/LD9MejrPp0FdAILju95M8cg0KcdZlDQpgeJ0zZqZOGr3wjoQJ9tKhXQhcUkzG2lDFp/iKIFmYzw2r7v2XCtkKC97Ag/vvgHKL7kixRCsd4CCORnPr0bKQm3hQCxelznbNdvZZp7fBiW14f3kVs5Fy5neCCI5SATLLlPljHrf9WbcEWxhaaRj2wWoG04SrjBoNh+ebLFwhOnYziKpR5+bO2yQ8JdH66COH+Yc34HnpGAfFSC9xWeidzaWbR3Wk6r9qNWK9PeheOq6ZuJ5NIA+1/2rfweWfgmiXV0HTyOmvIcy4ig2L+6kuWughvrPFbeEvOuV+tLxTEJSxXWgNW4wIXbayKV8SycV5pLnJz6qQPbTiWiKZGfb0mKSJwq+AVfSe7IJulORNEXgxUJbkXpZUu/3gloEUFakK91dhLA7RMc81Ej9oF4wXM5emiCv47WO0kkDGr8gzXIBSKb+ulzys8FJ70U7eQHITfYX4QfJHQftyYpm6Jbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 17:46, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Hi,
> 

Hi,

> This series adds support for the video protection region (VPR) used on
> Tegra SoC devices. It's a special region of memory that is protected
> from accesses by the CPU and used to store DRM protected content (both
> decrypted stream data as well as decoded video frames).
> 
> Patches 1 and 2 add DT binding documentation for the VPR and add the VPR
> to the list of memory-region items for display and host1x.
> 
> Patch 3 introduces new APIs needed by the Tegra VPR implementation that
> allow CMA areas to be dynamically created at runtime rather than using
> the fixed, system-wide list. This is used in this driver specifically
> because it can use an arbitrary number of these areas (though they are
> currently limited to 4).

I am pretty sure we want a system-wide list. Currently we maintain all 
areas in a static array limited by CONFIG_CMA_AREAS.

We can adjsut that to support for more dynamically.

-- 
Cheers

David / dhildenb


