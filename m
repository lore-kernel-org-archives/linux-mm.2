Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23517C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 00:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D546A6B009D; Tue,  7 Jul 2026 20:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE266B009F; Tue,  7 Jul 2026 20:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6036B00A0; Tue,  7 Jul 2026 20:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4426B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:24:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D61EE8FBDA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:24:02 +0000 (UTC)
X-FDA: 84963711924.05.03B89DF
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 14518100006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:24:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=boGbChI1;
	spf=pass (imf14.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783470241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fwb6T7QVdGDxs2wP5yfln48hkZneD+IuZNOtsCtvSik=;
	b=clIpzZ5yvDeaHIXjr0TFFhT+cPpQcWoXtbT8ci8Iy4JlhUeml8BNZuoBr4Fb/pbuDCziWx
	G6ewOoZ7NEn0Wxp09aoWZRQQLDFT3cibJ9bI3tObs0WyDa+/uzgccjrTwu2snuj4uC57O4
	pgChy7a7lXJ44q/e+YjUujTWPsCPli8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=boGbChI1;
	spf=pass (imf14.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783470241;
	b=F86VpIUbL8RXeA18idpAMAnlum1YWoTHbW9Qu1Zyl+oEOPNQoe7tKL2a+puy5ny8f4tEZd
	cx9m9z1yaZW4inBR2OnEzJg8XfW821sYWdSuV4Zjmo5QnYl/3ANfdepAhKaZMv3reF+Ci/
	v4hm+PXaNEf2gmhhRmVkJ0H6TXrwjpE=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ccdf36f63dso55195ad.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 17:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783470240; x=1784075040; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fwb6T7QVdGDxs2wP5yfln48hkZneD+IuZNOtsCtvSik=;
        b=boGbChI1zn1nPOB/ZZDbPUcC/GhvLbsxN1FH9at0uKYxIX8rsrGWmHVt9poaoPT4ur
         WPzyKwgTHI+T4BHfzCnKRmK0yY2dcmwREYSMv2IIDkFMXS9oamlvYb6tVzWPU+uU5wiv
         Are/x4VtBLL/zCrWUSMZsVOVHoHOvtjBw8ipBg09N1qqqWLtFPWGuqpt2ypSXo7DjkSD
         IaAJIN8cbefGaJKsd4QtJEKZlJxGLP+2QJgFRzRrSr4H8v4gGIgugd0o+XWMVJhGueX3
         i///3DWVDYjP8x62IzCI7mnWYkrmAc6yUPcVaXbVgBuF4G2P2InSgPbUwCg7QHW6hNBO
         DuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783470240; x=1784075040;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fwb6T7QVdGDxs2wP5yfln48hkZneD+IuZNOtsCtvSik=;
        b=lS+93bUxlLBvP0s7a+hrww6luI1rlr6ITOf0IiAtakd+RTQ1NieipYJcIIDF/dvA6M
         cjDy2ErUDFvA3ziKtNtoOvXnmof5vDhiztDJZV4/8/MSGKsUhgE9DJ+Fno2PjBkpMM5u
         Uv9hFpW80eMKKj4cVKu+6fqFA5ye3yO9ayH1FcIrhZFLYmUBsYX3S39BdajBrkAWFrob
         CSWwlEwLQncJitItYU/g19kyqCcfFYjgHqvLU4gGB0aq/jDYvr3kB3cWGsZVj4LVc1+q
         JYAjLNH80fYMf1Xl/Q/MiklONZDuM0gIYAKmf+I98/Dzi/voevVw0nG6Kcar3Qk5q4ec
         Uyug==
X-Forwarded-Encrypted: i=1; AHgh+Rpjr8c/qTn6r8cYFcrAVd3AgczZDopn8JEC3GZZxhXFiTu3f2p+zbsYvg6zSkXnmJiNgzKmodPxBA==@kvack.org
X-Gm-Message-State: AOJu0YzMGIUvLHLVnheJuP1d+SYefaU+FSljfxKqXmL+cmNHqWmc+OAl
	ssQp2pIoqDN1OsQOA4INEY193TOOA+rxTeRr4sJRQDxC7LVeaN2Jjvngii7YfT5gcQ==
X-Gm-Gg: AfdE7cl3K3zcu+SKswzrVQVomV2bL+AA9KpDLMkEU3MPrtbeDpR4zj/ZaTa80YJJIZe
	38awKhV1/jhsT00FIHMOqLDjywmVDIBR3kZMLmTq7t/+MUctcRMNV7Cy8rWqYCPznHrpSAkT1bS
	AUrgMvmtVyIJxZnQamR1O/CFaMFjL1tj8QpDXxrW8PzY/2AbZrzEHa+iwZJEtXaEqO/S1XXCVOm
	SU/gB6nXsqxuQsSMSVDTzL0eM2DP6uS5qF6wmixf+lO3rQMwgjRdfD6iEn9lTati7b0UBOrnrYM
	XmWogzcz+uKNNMrFSCqFB4c86OOLPnrjpltTMTyMxsTtnZYXzCLqHDgr1+MZRHAlc93aeh3k716
	4MWOjWatCSY2htvVJWtySA6uc0rAQufCvv/Qc79Z9e2B8MfsJ2mPsu5D5WcVJHovdt9fO+6vVSa
	nHI79y91f6dnqow5ignCN3vZOqsLyg1yqD8pgLRn5VMIdcMTnUtwVSUPK1H94PRbu/+1Z5a5nmc
	xKdhNMpnmw=
X-Received: by 2002:a17:902:d589:b0:2bf:3579:cdaa with SMTP id d9443c01a7336-2ccc9c2d137mr5761425ad.10.1783470239360;
        Tue, 07 Jul 2026 17:23:59 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dd9237sm6303930b3a.59.2026.07.07.17.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 17:23:58 -0700 (PDT)
Date: Wed, 8 Jul 2026 00:23:55 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pranjal Shrivastava <praan@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] kho: Introduce kho_split_preserved_pages() helper
Message-ID: <ak2YXFNGvCGo4oz6@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <20260703020832.1731864-5-praan@google.com>
 <178341290877.3292146.993563652569119942.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <178341290877.3292146.993563652569119942.b4-review@b4>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14518100006
X-Stat-Signature: 4inr48bqsojru3crromweu1br45upfud
X-HE-Tag: 1783470240-114171
X-HE-Meta: U2FsdGVkX1/qNMP1cuVgZ/ykW3TNFJuklTv5+IiFTisunspDd2iH3D+iD/QzX78btFxVrIc06VoxLCJ/C3KsMrxV3J2pqa7hWRE1cIge8fvv2nTxsMNZdh/uPrVx3bYelu31w90IqICmqNnANHnag8EdhJcWLjJMxEj+utKJ9k3K6utNm5Y5jJfhJaz9tiQCcQtr40jRN5RtJwzBMJi0A0qfL2YbNvVjfdexlzVmoHxg2PRK5gblPzsA97ZLNs3RND4MDyw/sLtGOBuj0Wb0UtQhS1CoCUqjcuVS9bD2ohjdA4ILtWYzGYFk15Xb9O3JWMsGQk62MWTzh0B6/lLiuifuslV6c/UDaXYnXxEALNBQRheyqHeo5KW6gfQFiu+J50mdlVjGp5mdml4xfckVo/pUJfneAMlzyh45Ev1gBglwqdHhQwH4GMt8EHfoxO0up56z/8/PLLOD9jRhgnp2UgkHCdhyQ4nVVBJgUDPtwCn7KB9oR4BIKRmNFH3fMkRjfZMGmWq4uiIR/txFKCgHWIN3ZLdt8u54AKTqyx8IU/tvJXnI0yJgMqfstNETyha+WC0KHflCnUYud7I3qm5HB4XSnAlTGs9+9Cwhi8ZhBYNm3/IOwkoOQEgR0PoiCMsOCFlZQygcKC2My9+hAsnEub6W2pUm7ie4zVZiGSFBDFlGJ5mI3J+FLRhXGytiwPsex8Kd4sH+Ht7ey57JbSnPeQoHdfPNHsCYmorgmUKde+RR5x4l6VgekZTU1hvsOGMRSlVdlGCfl6cGFWtTa48LLpRWhV4LdsocD9b6JiKtXPQeygWwThrVyBI16HByDajNE7N+TXUIMtueYnI9tEbO+GV/R12muszuNl4ZacjH5aeMS1mgFPAwzvPxGqaBOUc0pC3IBropwsHJDctPM8TwxgWYnwBBx3JZ0z4iORb5gBH5ziyCn1qOt7VxiUIglev5kRSlpQqNWQUJ1zMkTL0
 mlIoQe5S
 ZXbtaFcKH3QqJCOp0HsorDn4q/Mxai051B3AuxrmSxPgoa/LuELa+YlbTJu75Li12ziUJ7PmTSadH2a6RU3sH8BOy38fa53EdV+n0dW1wXDFBvjraKtWH7JsXU3yPz6990+wNZZKXFqGKNfbDmjHPpOS6KCT8hgyAweLV/gpoCafECl9hgK3vU8yzmEq6Adah5zykIXM19JgGCC7jRtmwqCaEnX6i5fqXsp1Hz8Dzeeyk0IHPGH041XiQ3yaQcw0MVT0UluNfv0VJRy9F3ZZmMRAPO4XeEKLr4wvUa6yqh8ZSPn+kQK9x+JwiOWHLhp7dyTwd5Plbs8JTp1USD3O6FxX0Qp/I2sTo0YHhFiIWnhsbBCPQRW4sA2lbzHy7JgvAlxD8SdFhl/WMc1kaBsq82icjfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 11:28:28AM +0300, Mike Rapoport wrote:
>> A driver may need to split a high-order allocation that has already
>> been preserved. If the pages are split using split_page() manually,
>
>Why?
>Are there particular examples?
>
>> the refcounts would change but KHO won't record the change in the
>> preserved page-type, resulting in a metadata mismatch during
>> restoration in the new kernel.
>>
>> Introduce kho_split_preserved_pages() to handle splitting of preserved
>> pages. The helper follows an unpreserve -> split -> re-preserve sequence,
>> while ensuring that the KHO radix tree is updated with the correct
>> KHO_PAGE_SPLIT type bits.
>>
>> The helper returns 0 on success, or a negative error code if the
>> re-preservation fails. Callers must ensure the provided order matches
>> the original allocation and that the operation is serialized against
>> other preservation API calls.
>
>Let's put this on hold until there are actual users.

+1

I think we discussed in this in one of the hypervisor liveudpate meeting
sessions and it was concluded that the split of preseved pages is not
needed.
>
>-- 
>Sincerely yours,
>Mike.
>

