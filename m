Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0952CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26FF08E000E; Mon, 22 Sep 2025 04:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2477D8E0001; Mon, 22 Sep 2025 04:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1372F8E000E; Mon, 22 Sep 2025 04:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F219D8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:20:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E29959363
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:20:58 +0000 (UTC)
X-FDA: 83916190596.30.2713721
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id ADA8F40006
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:20:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bdl0ZS2U;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758529256; a=rsa-sha256;
	cv=none;
	b=7DIR3vSjyrQmQIE5GwkR+ORZlqAvHztyWq0b9rZDJR3oqB5j+0bV71HrG+H1haQhpGXxp2
	6Yh4F04118q0PJoE+0uy7ee5q2PVwuU2JFa659n/MSf6mDaeYo+/9AyGQ0xKH32LyDHHOK
	c5VZ355nHXkcy4CLeTx5ShltaGflAms=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bdl0ZS2U;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758529256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWul91Ypvcl4/Z8/7o75pIG7A+MoT7DTZL7QIYZ08GM=;
	b=y71m7rwF8h2EuVaRfvC+MWmZSDYRSb0vFil61bdUtXzYFncShLY++Sk7YPD1q3pAk5IjqL
	d/qEmIUFwJkRF6Hf26t8u44ja09Xr3vNfR+ZHE3BcVCYXTYR4S0CQYMdIyS2QX1arw6yJD
	KcsfgA+b1Qo8f1o1MNWyyLEkpL5VbSU=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-62105d21297so6836427a12.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758529255; x=1759134055; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bWul91Ypvcl4/Z8/7o75pIG7A+MoT7DTZL7QIYZ08GM=;
        b=bdl0ZS2UcOKM7wQAvDUNtdbVnLnKymi8P90zcAaJxZJHsJvMnXvoRJqFGNnkr4lVhC
         1lAkSOexrY2viQ8wqjT+Q3IYuowY70DB70QqtNjdrsh+c+gHP6XV9cqZq6eXZovrBDzI
         SleuqDD+6VN9mAIiAfjE7hZzofQr9wczrXjyA5j/nqDnGCr5REU30eN75iXfAMOshvqA
         shvKCou41xHmdlO0HKQ0LqjApLv3RFoN1/Cf1zPAZAkfFTc/Bzu4smBPp13Edc1L0T/j
         E5Mbj4yYaPZZjgKB04XdwCKJ3s4w2iU57EBnZW8tY+Xq5I9certtHjmogve5bfTJKkbS
         QWlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758529255; x=1759134055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWul91Ypvcl4/Z8/7o75pIG7A+MoT7DTZL7QIYZ08GM=;
        b=V4ZebvFotkB6PU8OLA7gdrZX3EtM1rzju4XHC1qypR0Z/BC7kOmFuAUOKIQ3W3Odt1
         5TGUUz29UOgrCynholMxulsutGt4BPYzLCtCp9GBsRFrtXuCaZ8QJFwGcRfxXbO/R4X1
         fA4elZuPjNROQq5YoTXFEflOgwORh2sqVbn+rFoosm8mnYna/t8wkEbFMF8nk+jSrMWk
         NIUA0NBa1nutbsevokgj/UxAd69RGmz92vlXyX9hLC4NUpxu8P7Phnp2tME+miYqePcz
         5fvROOlHqdW8rus6tAWc9NeVoqMzHjQ1R/7O8hC4XpU73eZnbpbY7I0j5SpMo+teZt/E
         ClKA==
X-Forwarded-Encrypted: i=1; AJvYcCVKXXpHj2kEjlU34+JzZ/ugutt4oWpGIQ0HC5ueOoDIoQQGFWUNfE2tUqh566cFy9pTCtsgRgm0UA==@kvack.org
X-Gm-Message-State: AOJu0YzpSEu54FplT57M2bw3hc9Af8RmtHWJylQqaU6TS47S5Sc8tI/7
	/U8HtGXg+nsNCBr/9f7FlvjadHzZl95Je1sn/8VJwmLdhus+1aCT0gJ6f05nEJfLR9o=
X-Gm-Gg: ASbGncvO8Acd7CqhSTGQgfzzITC8ZPhtx927h1vuC31O8KVc+nN65mvCLKxB9ZXpH4P
	/VIfE22vOWanQCedBcnd2S31uHej97aIUkH11rto6oCecJKPSr8+Qt79Zk7k3KtxZQsNcGNVFmF
	J5jq1RgAS7y7EgPncR2Kscr45Ogt/8+RsIga50bYFJsNMgK3SA5pzAa6isat1gMlH7QVDurTZFe
	uPhLU1hlL+r5GVs6tEd863QtilIRVfdg+ErXfKJPiWQpQeoIew0rsQnI7Z4NnfRSyj7gZM1u8Bg
	zV/DxwXnmZwh9CpXIFyIrSeXwINvAwQDS6lv4Za6SdArIp387AoCvHuhSnH9Oy70eJ8yN2kCEdj
	3XC2SLIc4cVBdkMNfRmhoBSr1wkmAU2ZgiB4NDGEPezK+
X-Google-Smtp-Source: AGHT+IHxaY0GwSB34k5+NBnTaegItK7TZCUiH69yPauB/fSzm2ILNNKQYpIgAd49Vk4qkxbTnJOrIQ==
X-Received: by 2002:a17:907:970e:b0:b2c:15aa:ff4b with SMTP id a640c23a62f3a-b2c15ab1084mr303701066b.4.1758529255122;
        Mon, 22 Sep 2025 01:20:55 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b29b80eaec6sm426411666b.87.2025.09.22.01.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 01:20:54 -0700 (PDT)
Date: Mon, 22 Sep 2025 10:20:53 +0200
From: Michal Hocko <mhocko@suse.com>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, david@redhat.com,
	chengming.zhou@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH linux-next v3 0/6] memcg: Support per-memcg KSM metrics
Message-ID: <aNEG5W0qLPKKflQA@tiehlicka>
References: <20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADA8F40006
X-Stat-Signature: atjirhswmqi4f9j4rpmdtzamt547wm6p
X-Rspam-User: 
X-HE-Tag: 1758529256-716597
X-HE-Meta: U2FsdGVkX19TxljsKsftaN5BnEtQ4n+mTCpk7QU44MIzBm1DTHkydIWsZ8mznvt1bwwKmlV0dVyO041ITW97Vgfpj9l5YG6K5KW72JDv4CpRdv2yEfK4meEHuX6cE1pq1RavOeVWu5GmTiguMxCaH/C0U5fdsrmw0gOTmda50MB7FfWx4LLjOleEMLJLF/BqzO6xFKftySAoF9/Ut3GDp1AthXiT0+gMC8vgaNJNqs70GxgMzSfaqMI+XXGDzhsl3bJCjW7TIYy4pGnBpPm7Es7jGnYHTl+BX5rMyMIfdYi6/CTQBHyGixOEOl3/3kVfEGL7+Yh9KzCNVOHX05KBNlyGsayTZmYTQcgze5bnsJrzfQL8kOQDjrKyExv68zcp69tf6gm/Yp7EG/OxiC8Lc+kMiiKyry2BakXKbv9mHxmhowAhAUOLk+wvuRZ0hRN3gRFsDoWhurKel+RCbMeM9w6mWZdOZCtKTy+zW76VI5kywxwOVcS1/wIAjfxWdXfF1j2mc0NW0hh44bViuVktwKKKroiBjhJXPhpKl3nI5CFArluBbz9KicWmCa0QxEwHw5ovJ271+qRxO1RrQc14qJjb63zIDnMhsCK0PukXkg0KJKgYFlP43QWVSpA5uNEpfmnexI9KK1I0L/v12Z+3sZ1v4R6tIH6hr67qDSoJTkFpzkTJliPdnwPUamR+XwQ97leVxPtlI9Zn4SjNFEAhpQFgR8w1WUE33nTnT0kkkI2EXu88n58syoNt6Ju2v1QzLTJglqUfDgnbl0eDY15x42f4YNKW9Cbs8l0v8z89AdTyQ/02nhdaeZsgL2uaIosblF9EQ0ioTLI4se7NEYRyDKomzB3Gtvdzq1yFOIFzL7CB2UH3WWMJHicTOc49xv9J0URII3T2W/19yqpNB8r7GazYVCQxgRILzmr6Bfv+tPSlRQViIHGGA4vwbao1MkQwNqeKkR1y2EM0h6OoSHR
 RPpfH+0t
 vdvTKsl9vLsNes/BCQqv74qKfOwwOgg+Pqfa+YY2JQX7lEi+uC3Mj7h2zuUqtdS+Cm0nOGH3E1d/Id2UMSc3TcsxcONYVh/ulHd/D0DuFOWdJqzOFDrBs9PUajXnxbBVL5vUWXZW20KH8reux5pjmgw+aVJfahB4KdRvcsQTJ4k82Y+uQIuNLDJvieQlu9UX7Hw0DQWwg3PPQ5hXem2yfDgUQHG1GcOwhRU+YGhvfPtZaTg2IQviLoxzS05t5Z5JPr/ZKqH5KY9OoR5+YAEwtL1Jkc9XlTdPoq35r4t4WSnRVFu0VLRkWB+otvmCPn/0w9jN1u1b8rQvrAvGYPE94z4V0zmkTgV11wMVPXeOzXXwqCcNKF7qFJnwbsib2wcdl6CDzX5LVM45z/SQKOak/vqaryvLo2rcz5eraBPyBEjcR4MA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 21-09-25 23:07:26, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> v2->v3:
> ------
> Some fixes of compilation error due to missed inclusion of header or missed
> function definition on some kernel config.
> https://lore.kernel.org/all/202509142147.WQI0impC-lkp@intel.com/
> https://lore.kernel.org/all/202509142046.QatEaTQV-lkp@intel.com/
> 
> v1->v2:
> ------
> According to Shakeel's suggestion, expose these metric item into memory.stat
> instead of a new interface.
> https://lore.kernel.org/all/ir2s6sqi6hrbz7ghmfngbif6fbgmswhqdljlntesurfl2xvmmv@yp3w2lqyipb5/
> 
> Background
> ==========
> 
> With the enablement of container-level KSM (e.g., via prctl [1]), there is
> a growing demand for container-level observability of KSM behavior. However,
> current cgroup implementations lack support for exposing KSM-related metrics.

Could you be more specific why this is needed and what it will be used
for?
-- 
Michal Hocko
SUSE Labs

