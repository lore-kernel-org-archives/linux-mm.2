Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22CD8CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7EF8E0084; Fri, 22 Aug 2025 05:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398FB8E0056; Fri, 22 Aug 2025 05:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2875F8E0084; Fri, 22 Aug 2025 05:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1173B8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:47:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5AF483489
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:47:05 +0000 (UTC)
X-FDA: 83803914810.05.EE174BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 40BD91C0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:47:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F5HjmEbX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLPYIA3eAY/LKZ9+AmjdNmU1MFOqmIzxGTpd17k3HPw=;
	b=7d/6SyHg+Kxlb65nZ+ox/AAQHdLhU9+fw+xqE9y1GNav7HF67EBnIF2BO+2TmVcXzGWMvf
	Hsre82eIlMmqtlSgVgM2bq/0qOKOaE5eOR91aaLjAWVrRQy5Af6ZF8OC0fDt8X6GcmxxXC
	9klJwkxQzB7vuTM5h7Dv62x7X/4TAB4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F5HjmEbX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856023; a=rsa-sha256;
	cv=none;
	b=PfWjfyVUJ4V/KWJfcq7kKsEx5FoAwygczhz4clr5jYWG61E5+N/jBrP4GhoZ2prkKhbnDR
	W4OWCPg97q/gCbEOC0qEqZ7ywczT0H621QZBfK3/OEtkDznhnK1D0td/kkDGPodAtnCMM1
	KsFnvx97ASNSqozNwfRkrPSWpfYv02Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755856022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GLPYIA3eAY/LKZ9+AmjdNmU1MFOqmIzxGTpd17k3HPw=;
	b=F5HjmEbXqmMLT369gTIooFvdaNOrzMNssTRQYuAGL28YWJOfgHomgqd7gJe1ze79lYUCsy
	0aQ0D0IR4Fw1OO+aY/VEWkfz8CCEu0HsXQUDlBMayh4SqMSDve8abdJWT1CjsrGf3jn+FD
	dGrps49muBvSEomM6MMVQ3jJPH0iJVU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-D1brde--N02ajwbIVbTu2g-1; Fri, 22 Aug 2025 05:47:01 -0400
X-MC-Unique: D1brde--N02ajwbIVbTu2g-1
X-Mimecast-MFC-AGG-ID: D1brde--N02ajwbIVbTu2g_1755856020
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0d0feaso13404385e9.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755856020; x=1756460820;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GLPYIA3eAY/LKZ9+AmjdNmU1MFOqmIzxGTpd17k3HPw=;
        b=p68AoLVPCE5xEPzk3oRRRDMOnyW3EM3tQps1JkA4OIefayyVqWr/nDONimxPWVeNdb
         +KfHK8nC4m0Xa0R+52GXrwk158ZY+OWsrtXP3pmS60m4oI3RyzveqzlMHdvBZbKHJFc0
         Fzqadq9nKmYU1TYONKBRdXKtDl/Xz1mrKLFrzrkTsczGldjiArsM5pbdPD/L7dOB5Z2f
         AjCoN6wTS391KAfM/gCtHfst5WDczBW1Hv9ZCjdd+fJwA7oFZ9SiWMWnyqTY6PmCrysm
         atK7faB/U+pctcQjASnUwpfXkeac0WQzfQrxZI05vsjJ62eVgMpgIPZRf7sgwHDXePcR
         zyfw==
X-Gm-Message-State: AOJu0YyhgslYZXk9biKbIu2WxLX4EcOky6iBt2TKbInYkAa8sBlikc7h
	HXs20YsVOwP6I/G6umdOyEEMo3m4fFaf50jOzpRBcWQ6vVf02juo4k1oih7cyqB0WSb72iiYZA8
	M3wQWwl66AYlkWp6BRyoDccxjw1WfWKJoYeUuSuv45/HbXCxstqtp
X-Gm-Gg: ASbGncuYL8sKNjMUl5ZPdosJuk+nSnoEOi4Zkq1v7x39qpTNs61MP1eDBFUMvkpEufo
	5PbZtWadGicb3X7g1L7B68iWf0cSMPGOUUpL+4XYRmVkxs2RgyWGcn6s3nKYPYvF4UmE7ahwuY0
	YNc7X+VnX+OQqOptZor01ADxCrhA1kkqEpreh7zhOGtvjr77YJOHtWk5FV+Zb1Ef99FfOxKOz3S
	9ru7UrSiFkNRvoEj9ZarvjkQqXspHanXfo50S6ZqLIkBYCNjrru5iLVDTtCs0Gs3QidnkMKnmis
	t/r7oikyPzlOdEnvRPyUrJso58ZOCjwHewvCiAn5/jMNFj56zEVBfkfBHermZnURjX905MA+GIw
	SCWMEIt9vhWfj4DmO+oqPyO2R0ksIkjmbLaI7jLcZ0f49mjkCjXFn0Psg2tlyBOQa5JE=
X-Received: by 2002:a05:600c:c87:b0:45b:47e1:ef76 with SMTP id 5b1f17b1804b1-45b517dfe11mr15858255e9.37.1755856019783;
        Fri, 22 Aug 2025 02:46:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKPmSE8ikyT/hFGBRRCldVTL6tSTtrjI4Uje+dCROpHcjF3Yvju8oONVLJaw3WWDMbs8ltPQ==
X-Received: by 2002:a05:600c:c87:b0:45b:47e1:ef76 with SMTP id 5b1f17b1804b1-45b517dfe11mr15857955e9.37.1755856019287;
        Fri, 22 Aug 2025 02:46:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2e:6100:d9da:ae87:764c:a77e? (p200300d82f2e6100d9daae87764ca77e.dip0.t-ipconnect.de. [2003:d8:2f2e:6100:d9da:ae87:764c:a77e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50dc023dsm31789505e9.5.2025.08.22.02.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 02:46:58 -0700 (PDT)
Message-ID: <aa1c3209-2ba6-4930-9a5a-0b3da7a9b09b@redhat.com>
Date: Fri, 22 Aug 2025 11:46:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use list_xxx() helper to improve
 readability
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org
Cc: linux-mm@kvack.org
References: <20250822025732.9025-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250822025732.9025-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 13ZhUPOlmwtIPF2I7p1OBKYnk7GP7ZlqdWnINcR5GUs_1755856020
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40BD91C0004
X-Stat-Signature: bqzdisc34cdi66yddpkjjtmy36e5c8is
X-Rspam-User: 
X-HE-Tag: 1755856023-986540
X-HE-Meta: U2FsdGVkX19096lpMsxzs4iRL+X3rFvIX1pW+Q5ragR2uNgpHXbc5CY7HPWJ/22V2lEoRKG+5F5UDFbLglmHcxYwnxx95DiPMtl4qzpZeauKIvqZARId1YBMYO33LkAGMgtaInL1lyGIjuc/c6RibgYDO8o/sbwRKhzYBlxKyRAGsLz+HggzZNn94UG5wqznoQEy+1dx1Fqc0Cq0c33D1tE0GdxVOaL2rJ3UgRe/2JiV3k6TXhlkhmVjt3j4l37nDb5X8Uv7OUiuv/cb97jUgqoL3T+DEy94xqrPuwxjW7712NfJZUqjJvBLoZ10lBFj9cb2duQKXxfz9PM4Kc5wxbrg3E9Mjk8TTNQ4eJYUf1Dx9rdAO+Py4KkhpRs4t+RVEuQ01VAKi79/TQLZDeScYsawUU/QKrmbW5wIylvLd8p14j26Qp87WEpQ2jb2B7zskyadItQcEtzun1YDpmCOKTv1vmGzRomfcmQEURgUZPonEX2vDGcNAoE29kZsKCkMdhYVU+4dX8O8vE7oQ2GoOH0xlsKu0GmUqWZDwbogYs2q1nKfL/HCtjeJ876KZaJBtbzJaCDU1icrVwluA6H6kqNPfLB1NPfFQ1Jx1HoO53BD+4YfApnIUliEA9IZqRswF8hgDBxsqBi5h99fHxjCJ6AzbEHguYsNB0oUJhfGhxdgXXki04AHfvUgvWgAZ972Bn1dNwbgossRd4K/VePxHStCSA5NBLR/fErli6n2xRPtLoW71Bu1Gs5/X5s4RCp4mAmfz4LwtI8n2gp52JUexKbLdcc76pkqpwp3xQitdu6RL5gtUTwLJIWGAA7rjA1bBhToDIxbGq4we12v4l4Tdarvxk0vbjY0AhP7foigK9x+/pES8vIEYF0vLnc/WDYKBxmga0VYj0r/12wzFbEG63ZV1HPqrBthkOBADDM55vVZEVEdqkXa0Y2VCGZTokhOg/5obZ4PpG/84T4t90J
 Bm2oyNP9
 Ihd/5kM8nNdl0bmejUj+mDj7El8id6nJRraTcAI88kqWWY3/RHHdDH/CqfbTkjSwDaIWnGYrnRiLt3U3XvH64ZdQ2PqzHsiQ4MQ7SBU8eDGT7vK0wPb428ZbCFWIjxjDt0pDM7Jz4XPiy7bLmwSSlJIcskcmj56SAiLrUSl7JjhKzfTPL97+haR/L6Vlm34cZqZUC1aMP/lUk8jthmCi9TA244+IdkUa7K5QnLy6KfMGOkKG/iZa1g1rUuDBF6UFUdhcRVvusH6tkr32rYXRv+5FY++PTDkKiSQgZRKCikNvGJtU6ZUvHfQlXsXYOLiRLmuS7sY2o9ynIzOGkPNoO0Jwb8OuMLdeocv/HmSCzj/5Jkgu7dWuzGNNQsHysxb5Z519MvqP3I3xpKm4NEZsoBJlBRflqQt9fEEk9VIbr9Xbz9U/hnNfIGGb/lZEbFuWHn28pPF09ZMCmLka+Voc/Ws9uSWH6oaeZeDTAc9hAsgIT0sN3B2nKVMjcNQFV6PTf4y5ZmR8NWKhEP72VwPBSvLhDzT/eKpgVRBYUSeANuhrxiJH2v2b01H/j5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 04:57, Wei Yang wrote:
> In general, khugepaged_scan_mm_slot() iterates khugepaged_scan.mm_head list
> to get a mm_struct for collapse memory.
> 
> Use list_xxx() helper would be more obvious to the list iteration
> operation.
> 
> No functional change.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


