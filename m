Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCA9C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 16:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFEA06B026A; Thu, 24 Jul 2025 12:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF506B026B; Thu, 24 Jul 2025 12:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B783A6B026C; Thu, 24 Jul 2025 12:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A80676B026A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:27:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70FFD1DA940
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:27:39 +0000 (UTC)
X-FDA: 83699689038.14.FF4BBC9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id EDAF114000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:27:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VL3bzDXX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753374457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJ7KLOjoQ2RUfqXaqGnqtGxyf1BuO+ZeK5rMypknKHA=;
	b=a+S0OI+HqfgIDAOusnzqy+UbjAPL2Udc0qz0PRmZPc36aPRHwlTjsPhfcU7d0jA7eMskn9
	xdDLRkdz4zh/kpqa4b50ZZsvB9BlPSodM9entzAwwPUjUdmAiXvm2y1ZnhCM8Q+If/1HWY
	ElPtnzdQsdiPF70IrvyNW/+KG55tFEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753374457; a=rsa-sha256;
	cv=none;
	b=4QZ6wABL3YOl+ce5Yr/h5TBW/Yap/SOhFRk+Z1ftp4PZqgDXyfWKYMzkm21InRL7yedFaR
	nE9RmD3wNHhTnUKcs2OgpyfMAuKjUNH7aJPL55PLM/6aLiZdcEKjRZ/weLgroGn8YFJp2E
	sGTKju96W6RlI3LcXXemsVpxRA5VR/g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VL3bzDXX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753374456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eJ7KLOjoQ2RUfqXaqGnqtGxyf1BuO+ZeK5rMypknKHA=;
	b=VL3bzDXXqB8TldTPAt5AXa/kvP/vVHgrQlB8l05qe44+PzGK22BIUU1X63+GK0sIUNhb5N
	888o+K5CqQaGFDvTSemh4XGAivVr55U1BPSjtgxRTae6XiNRRavBFtK6nt4Y9V/kSTr6Us
	qIjSc6UK6sC+yDsbanZm4zJyLkwiKvc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-_ErzWd6jPaeCkbp3s7x74w-1; Thu, 24 Jul 2025 12:27:30 -0400
X-MC-Unique: _ErzWd6jPaeCkbp3s7x74w-1
X-Mimecast-MFC-AGG-ID: _ErzWd6jPaeCkbp3s7x74w_1753374449
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43e9b0fd00cso7075595e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:27:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753374449; x=1753979249;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eJ7KLOjoQ2RUfqXaqGnqtGxyf1BuO+ZeK5rMypknKHA=;
        b=fwsSBX2RExeg/Lkp4DpB+4nqoOak95BbENdcrGtWS9diIK34OTZDZfzh+D1UteeXaa
         QzuXZPGHiJHklWiz0tmIhPyHByM6Zhl718TIX5akChCt8DmdgEPA2Y+z6WD2tySrhds1
         ICL8EMp8HIpHf5ZO0J4AfhdzHqusekZcX2UN21ZH0Gx2DgI38ERE2HjaAbWKmfsoiQLf
         bhi6Pi9E5r2WhhdrMBUYyKqUaNPVlHR327V8BLcsISBeEX6LqHf4/wsKh5TrAxnnChQ9
         09WYPP3a19FfNW3C6DL6gZ3yGYgl9Ug7R7Xh7ctBAz975sqa+5g3zRtC757NmXxcwhyL
         8uNA==
X-Gm-Message-State: AOJu0YzpjAYgCc7pqvAxuWl2eFxb/cNOxD5jPB1aJSZzGl2LMkXavbrz
	PViYx35ZJ+ESXC8BIoccJwSVghjQxAlie9DEM/KvjMFGVxkc8ETEmEalYI88uxyer165AuObhcb
	YsrNzJDUtJPKeOnFzyaJES37hrNHLNpt/z8pbpcSJkp3OZEuJ7PQq
X-Gm-Gg: ASbGncsCNHj0h9gcFD66Drw+WD8jcSmYdc0ZZbMMnN1brOQsHcXVSyYwrnKRYpvQBDn
	qR8t63W4nq8gxv975kEUQ1azTZukwF7YL97wJ7UdWACy6cNdzelcboJb132ekz7DFvNdeM8Le+H
	R5ryzPRH46WE60vglQXxo3snNBmuozW1oxOb9GV6G6j/wEB7FCHH386XSbxBFz5vfMU/JiFiNzV
	e9j0tIi/59oJWp9ejg9taHw1GPRKzeiEog2+zXmHzZb6GIBm7FCDun7tjngpvDE9P+fJLLAo9Lb
	60wBnDNkARSjgbseWOdWfNfOmE4Uw8/5cTQBNZGYK61ifFsoalKWNwbQskR9763Zrwk7rU+Vjh5
	Sy3nw9A8u0tYX3RXqTSnX+dC/DfjmP0r/e+CWIKjRqSbfI0cg5B7tKj0fyS2iTT/MoH8=
X-Received: by 2002:a05:600c:5027:b0:455:f7d5:1224 with SMTP id 5b1f17b1804b1-4587075c4edmr25917175e9.9.1753374448627;
        Thu, 24 Jul 2025 09:27:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZUjqTvwu7DcKf9PwdSwHndxFed/g/sr8OUtiD8sEuO5cj1+7fDFOV8HeaeBAbaLYrPJUr7A==
X-Received: by 2002:a05:600c:5027:b0:455:f7d5:1224 with SMTP id 5b1f17b1804b1-4587075c4edmr25916825e9.9.1753374448135;
        Thu, 24 Jul 2025 09:27:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4586e801838sm22484885e9.1.2025.07.24.09.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 09:27:27 -0700 (PDT)
Message-ID: <ce7e8f4e-a8e7-4d79-b4d5-8d82d98e6951@redhat.com>
Date: Thu, 24 Jul 2025 18:27:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/smaps: fix race between smaps_hugetlb_range and
 migration
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 dev.jain@arm.com, catalin.marinas@arm.com, lorenzo.stoakes@oracle.com,
 thiago.bauermann@linaro.org, superman.xpt@gmail.com,
 christophe.leroy@csgroup.eu, brahmajit.xyz@gmail.com, andrii@kernel.org,
 avagin@gmail.com, baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 hughd@google.com, rientjes@google.com, mhocko@suse.com, joern@logfs.org
Cc: linux-mm@kvack.org, wangkefeng.wang@huawei.com
References: <20250724090958.455887-1-tujinjiang@huawei.com>
 <20250724090958.455887-2-tujinjiang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250724090958.455887-2-tujinjiang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U3wbfYNETwe2L_pqdMmeoNpmplbPH6jPQNDCZLUOAIA_1753374449
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EDAF114000A
X-Stat-Signature: 7ezuyaycizg15bzuryzr63zfu49un5er
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753374456-433439
X-HE-Meta: U2FsdGVkX18Y91FMg2VGWq4kQIbG9Z1MbsG+JDRm3jGw6HMmJVK5PdFGESV0P0Y4t5UrjKeX0Wh+LkrewH7GqT+QTfzBnziElTlv7OL3f8Idi8UeKhI3Hj7BWcwNE6jqsCTKSf4T1QNGKalycuF/eLpnaXGki0m4khAZsdLmddmiGuMCWCklKKjM557WphmGPJdBLLHHy1/KkyiIRKxEBix9nPvcFIoShj6XGTNN3i8ie6DvQi6oAg2bwKbVcZB+lnDHN7elRMlmEGu/E+qCkXwPsD9IzUfOrVI0JLfV+6Astfvk9wnlamQ1Smi4R0H21RMqrVGCE/gJDQekhzHNNzDWXUsn3a+uoxiqDkdrbAKEKjkbAB6DIDmtGoaeowau0Ax+Qx5h0jbcSpjSxIpN7aNLA4jnXYkbeHkcxOp47m9phNfG5xzWs/gfciT035TeH7I4n4DP/bUyEBKRblQFlBvQhIn1tYwbXsB8x8I6qKfhjkOz69Ti+iYqmzPVobhzOKIW5U5DgCM7rFynr9Q1aYGVY2rOXIcgj7lS2HJ3eo+6wIWACEHrt9J9OBq4WX86kxGpSea3dSlF0rXjGjesAbC8VDvAOrcrmB1+gPSf8a3CBpKYxSx2Irbi7gJUag70XtlWPddnVm0TBHTzda1ftOjbG/YevV+nnnxeptdXS7Q55GfieinXjdB1yOjKgwfenVKEfLWBU+bqEzbKSjgcQFjEwguTLo5J7vz6PL/H0gtGAxdHPnCh70TRfHlDKEZ/a/duV4LXjlEni+jnFluO0Y7Wuzami3yV5ahl7i76jHDsKm3801rzqCprVMvn25io4dpIYApAZrxtYBP4CFex1Bwr9u54cCpVL+vgjYMyr3Zoi7Kx32kFPXsBVZqEvFx4nKw9IZnwDF4oVwfas3ROy1IrPETRZztg7y5uJHFy18s/FOXxmlqfsoF8U6sjuJC+OIrlLc3t1aIhvBjUPYW
 9GoCBJVG
 3tn2m9bcxPPK/CX0tL9LoRp4f+h80w+DGUTVEhNCrUKkrT3aCQAHLGUli5gdtBsN4Z3knlvakvkQbfWOYkdUvTWRzA+NCIvBQs8Sxz32Stp4ItWwiWfpugHfIpa66OO7o9i5zjiMqb31neaoLOV8tlT45JgRxomA1GhOzZYc11DSR59sECBeMqdHsN3XlY5cjKHrRg3DKnEDnNMh0ZYKdjfdYeTF4D0DJAbNRD9oNVD4mK6eNfBz/l1XXg4hMOGCXQRyHij20fyCM31zQt3910bHp8UXBVs6vzIohpVe6c1gVnDo6Xox6LdlYfD9P/QzINEHLVbbdfoYVNIGAnenKT+m4FxD4pJ6u+YfMNxsk6HcMnn9RQLd3xu8jbnwPOTPAdjr1X0PI1n9F+XmcmHC2dIH6zaNBNB/v3ka5ECGrpNC9pmfs1xtZpOoX3HEzsxmrsS+4K6iTYTMVyBD21fguQkP23F08G5SPisPxEXvHZd0QpnlNhctXf1f1AiWcPlNxXbb1ojfg5xMbfuyHs523HsuC950yybbIUqEMCOKK1I6W0BhcUck7scqCgFIEsQyhpqJ4RODw3rG0RtI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 11:09, Jinjiang Tu wrote:
> smaps_hugetlb_range() handles the pte without holdling ptl, and may be
> concurrenct with migration, leaing to BUG_ON in pfn_swap_entry_to_page().
> The race is as follows.
> 
> smaps_hugetlb_range              migrate_pages
>    huge_ptep_get
>                                     remove_migration_ptes
> 				   folio_unlock
>    pfn_swap_entry_folio
>      BUG_ON
> 
> To fix it, hold ptl lock in smaps_hugetlb_range().
> 
> Fixes: 25ee01a2fca0 ("mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


