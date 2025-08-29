Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7716FCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14D96B0023; Fri, 29 Aug 2025 19:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C85B6B0092; Fri, 29 Aug 2025 19:37:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D326B0093; Fri, 29 Aug 2025 19:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77A226B0023
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:37:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DFFC1609AF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:37:16 +0000 (UTC)
X-FDA: 83831408472.27.59CD10A
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 51C8CC0006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:37:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VOgNYN8m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510634; a=rsa-sha256;
	cv=none;
	b=T1s0EouBu9v6KonNI7rmiOcp1nPms5pJnQYX18pWmuKldp+5/KpxvMrP4rHnXe4nZeRJF+
	XjaSyAkqHe9ktBmhlDUgr32DGVGR+VOurvbwoF+5jR4skCkGLypulmcsZ7SHdhWGY/M2Bd
	BOilo9zjOuY2YZM44PLjw86EsiMJqNI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VOgNYN8m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glS3sDuuGoAFcVgGKRUacpCdPCUL1DR9254ZlAJsmig=;
	b=2T3SoPgmqlSzpnYHa5eZ7fnjXelTXV/Z+UPRENAGZ3OmU/VcxQtD276066FVOeCgFFk7Vf
	ARQkdS6ucTxZlRDhukHW9x4UmUpfe5BfjYAQSTvcU2aFq8vxSSAXjl1Bcr+ZxEsdqq66GJ
	15hDMPtBuJlZ7Ua3RKwVEOfa5BZct6E=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b47175d02dcso2204567a12.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510633; x=1757115433; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=glS3sDuuGoAFcVgGKRUacpCdPCUL1DR9254ZlAJsmig=;
        b=VOgNYN8m24qVXWkmSanC+3TtFDM0VZqnjFsqLmXL18UvOMvKv6ZGLUvnQxjvlfon3F
         87t/lzd9gIpbncCC272rv6AhmLnENF3cDF4j04y8bBxoGsyPqxLDGIqOoTPZKznyokLP
         1zBkok00KnUDPoWDFhYVDFZXmens5Siv68ROY1Zt/wpN2eOMJ1YEInTBogPOJ94iK5qV
         zo6WBk1MFLOVupMzYteJrcPK8nejYNIVdYqz7j/ZpRkkMc06LaEKWCfXvVRA9EtgoAdg
         10Esq9EjcB+TsVJz5OnCSpsbbUf5lHvbNMS9RSnwIQguGgEcuuAXhhaHPG5rPkGh7LH4
         KecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510633; x=1757115433;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glS3sDuuGoAFcVgGKRUacpCdPCUL1DR9254ZlAJsmig=;
        b=xAtNpBKAogZ3+pmlhmL+UkqAJ75XjwCm5M6MfA6AiCXverrEctFvzxrH5rj6DXa8pR
         pACJ0xgkIVqxFO/azBOmAnoRvy86GnQu7tgfKBnVO1hajAt/zLZItYMMBztXEU5wemIj
         4upzrCi5QKCWR6qwlrq9HCdSqhLlQOK6E7FIRTnXObE7HSztuFvNkrvykeXzWa2bFxkq
         wWrxb1+23ek/0lXDetIDPgQxdPCq9Wns3Ib1/fuAsOyrBxQAS47tQD8jojO+xvBfVsiX
         kv7R3qe0Gh6phsfRSskwXtdO0YZ0il27+GG2JNpBF2DHCu/3l6OEKNskdj7FU/kDaCWC
         nWdA==
X-Forwarded-Encrypted: i=1; AJvYcCWue+ekTa1XBE2t0EVouUq0+Inl5utOUBbeg/9C5Rvq7bOWQVuEa+ByQZDqglopt12n7rWBjkDMOA==@kvack.org
X-Gm-Message-State: AOJu0Ywq9EnQCr7QMxbIwa4dk5sVGOUuOgO9nksiOeEAYHFvv8g/Fkoa
	+xLfcpJT1aSwdLGK8Ztk8m11j7yoydBVIECAvw8ihxrP4F92cFcpGXF7
X-Gm-Gg: ASbGncsMWX0zFOESEKmuhNPiTl64Ivr508FyjPXj178UlBqNAZdP0hQZZYk/8ipAmNN
	UAWdQ7H6oNAV6IRy7wSWbYPM08qRq/Pje489sgBA84g9waox7tYIyNMD5GCa5RxbtDzAb9NKQuD
	zc6jZX6+vb/qzQxvIxIKPMGUk6j9He/ZUU/nEOHQxPPFrkC304y7xqhW473yXIFqZKJQfCHYWa5
	HNRgdBP9J+fGptLzvSEjvFwLKzRv3nG8eYCDB/3Y37T3zz+8NZnm9GYCKGNKoflvzY/3d17UQY7
	KDf+vuzIH/OJv0IMPMqZCjX/0Q0TRLDyEtvCQIoVrDacCaW+JhvxP2zhgMWj5cEYGqYHmr2FehD
	CX2+MuojLZdptK8mexYVdyx59bSNa0lm4mPxT2zgkhKlQHaPBZS/bmQ==
X-Google-Smtp-Source: AGHT+IEPKsWyINA/5OCwHsDa8dMAPLFlmlltwSr8LA5tQwEEhdGovo5KtOdnVVjxX+/e01qwpKw+lQ==
X-Received: by 2002:a17:902:f543:b0:240:50ef:2f00 with SMTP id d9443c01a7336-24944a0e817mr5201615ad.26.1756510633134;
        Fri, 29 Aug 2025 16:37:13 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3276fce1f30sm9433712a91.23.2025.08.29.16.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:37:12 -0700 (PDT)
Date: Fri, 29 Aug 2025 16:37:09 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 09/12] include/mm_types.h: add `const` to several pointer
 parameters
Message-ID: <aLI5pfQIJWewLK-S@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-10-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-10-max.kellermann@ionos.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 51C8CC0006
X-Stat-Signature: 7kdg3ax478aghrnruhwp3wunyw8jdcdz
X-HE-Tag: 1756510634-943447
X-HE-Meta: U2FsdGVkX1+1tqeC2haKFXGlTDZikmBmnOcKqQ6BDERQRFqQ9Dra7mPmq59q0k3dkHZqQ/r7pP73gaj+oSSoAcLoFByCBtYvAvlBivlmH44giCyB7mdS5zvmn2Jz8ONJHtxaAh1rAvrwKCkgSfMDVQ5L7EdopMxjetx7Yzqz0cQ8XoS7dvWNcgZmTCaOVZZvc0oSZ2ZwBO+Emrw2EnLPuoO8nC1P2dm8URc5HjmxBk6ZwtJQS7xrNklqITkp8HesjLYqIn+G59i466tztvBR4t670SGWGUmdxcO4mMWiS2xYGy3Ha3mA1Zg5QU1nR3JsiMHt/HjThCPnIpnN0JluEq562WBhoZ+TILY5ym+qSWqy8t6ispPsE51jKgUgGysxAPjA7JfrH6SOqU/vYxUOh0SuUsO+Bqt5Ek6oTEm9T5OVLU8HCd0h+kbn/7ftsG3m8EmyB4/8VfVJ1ASJW4fNodDtkcgsoOU459mMhygA3CIA1heGlEL9w3pV1sFOoVsZlX11Laj5D2B9mku63+iqJfqAaTi7Qzh+eNz6WmnHsmpcB709e7znvLHtHM1Gwc3BpyriW2zmlkEHyaIr3cSg/bL3w4F2RlnzuF9JAIJcUlCl2EYZrlTI/mg+pcBhNOVJRhR34t84XYbUz0Dzze2pfzXxQsHBNcWN9n6u6GeLLdQl68RRB0DfDS3ubCxaaAoHywECE2MxNmy2wE99KYN5P7jetvMd8orntpo8MQVGQngwDpCa97g5DeBZgqVUq/ER6L8zwbYJjIGrW9Fz2AVIUQDXxRTBC6rwA+Sq3hKDupJRtD8NjpXMxUEXUmqWVeLFUYrwMY1bGNJXqsngs0g67J3IaRq+Y2PP0Oz8NitQoZJLIc+HDgYwdR1W+kZSOf61tpE84hw/acUk6Snp4Agd/qZ3F+L9G1XEibLUAs4vPkKZwh6BhNW29kcjmAjQpZ3u5YIFJV2ExbDkqV3pq0+
 x7w+nBxh
 O8FTwDikd+vmNUcQvXZHxB3psJ/5Wcu9JV0VtkKJfzElJLBlujlAr7gSa2Kj4M7qY+FsmdwbCSJpY4LYKXcLc6eZXJHQdjq651aY3CKtu0BDg8eNWOlaZqTf7Mx9r4lNh13tTktm7v0SM9pSeKoLq3QJ8z7bx3KZGX9RwI2ah1sXhuvxSg2SmjbcOCj4eJ7HFqQCTNwnnX9oDdi5cKjjf6wLhMPiUECEZhlib9QtsJPx/ew6PbOSYM7JCabkEisOXMQNvz6/DJOozxRUurBR8/dSMi0bpZLWL8TaAG2UAOx5gRGJdOgzByJMaB2Oidaho2zkHsRpQdSjKq5oXr0p8/8sEOnCByXEoiEm5LI1nql7Wkb/bbLGjZwKJcCqB1zIy/Fj3XZA3/YoIubMrCVFvzfxp0RZ5mQf6BcAXI5uKLomHF6pdZwXNJqTfdZGwXJcNCQZcLEbB260tdPvRgXMce4zU8XNYpi5xDHF01v27056g9FutMRp7uc5+vnbhCTzSpUnbTI8XK8MyO5O1om04Bg3iDQPNiGK60zqSSh6cKwH7cJILMRU8Tp7336TYf6i/eIssOoEGuaiviUorMBKkhqp27vcZZsFtpCKUQLujKAmf7PU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:31:56PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

