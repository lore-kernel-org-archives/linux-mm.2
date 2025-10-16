Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B958FCCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230E58E0023; Thu, 16 Oct 2025 15:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208B88E0002; Thu, 16 Oct 2025 15:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7AA8E0023; Thu, 16 Oct 2025 15:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F37D48E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:15:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A184C1A0413
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:15:15 +0000 (UTC)
X-FDA: 84004930590.21.8F5F26D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 76B36140004
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:15:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DLzqCxA4;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760642113; a=rsa-sha256;
	cv=none;
	b=Gc0u1xCsPquUGwNUtnzZTzUFQj7JKDnQBu91IYvBX9fmJ2qZa7MfOUzSrvSQ2DhXKKSP6G
	/jRili7/HyATUTthy5BeKM2U9dhb0tkVadFUWQQP/H7tm8Jossp3tJmPbCWz5NvLhFn+yf
	MXszSBqoK5JChIE5mZ00xOTTimJTJ1Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DLzqCxA4;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760642113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVHh5PR4TvqqguUhfaerHBEOYknHgUGYrVSqECH8sUI=;
	b=kNnsnFYJv48/Am9S1w3mkMdoj0U0sKEncbgKqPk8kXRtBMvz7QlhAnq4laJoEDqWa1/5fP
	atxjbIZXMjgxJtPvUvn6rTutk8Fc/2xybV30zmZI3HlrHD2as4LSG/7sogEHCMZbTqTdNb
	0rQ4EYSfmpkVPuSqRrPy80uX3akk4f4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760642111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hVHh5PR4TvqqguUhfaerHBEOYknHgUGYrVSqECH8sUI=;
	b=DLzqCxA4GoAi534zS1kF78egJhMKDAdTdHIWTZ4sU0/ZSJLNmxVu5bjpO0+xzaOpmLZF77
	c/4mHId4MVoH9X/w44EhTzHo4Qnr6yADxua2k+29BDlvTcdTIOvl2UHBFgxrJx73BoRF/+
	7LiK6jXd7LTYeW0+6dLSodIJ8JcxXec=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-AspeVkT5MPGoyhEP8yRHBg-1; Thu, 16 Oct 2025 15:15:10 -0400
X-MC-Unique: AspeVkT5MPGoyhEP8yRHBg-1
X-Mimecast-MFC-AGG-ID: AspeVkT5MPGoyhEP8yRHBg_1760642109
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-427015f62a7so423421f8f.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760642109; x=1761246909;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hVHh5PR4TvqqguUhfaerHBEOYknHgUGYrVSqECH8sUI=;
        b=QY6rA9NA59BcHF/D3xEdxe1GXdKAw0px9vb4THUmFEOIVj34kxJAira307OSQ1BQ+4
         vcWMq2ihg8XBgLnZOxJTE58uS1EgLo6yK8VZSSd0g80nq65ww/5vgAt2YNtejaD8G3JQ
         sAfV+eBExCckWvp2nOBc1GlSQJs/aGQLcLJWbEKbh/21Mu6cuYMzSi0VPl2CYz+NJeuo
         Y2e/lp3e2I02o77yarEf8xehQbdOyWME0clBcheCU+PRdSdEcBHfnN8cYy9iBaIWMVVF
         aKTuhY4Wi414CMkPZx7L33jj/9kyv3ZRod95h6Ce4z53lW5Dv0LCZk9z9LPf0f0Gkhn2
         1FqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVR4DPgNZ2cor1yvTlWNCVrDdeykohtzzeNvtDcZQgHRbRqywxv3ncX5H6VU+pkYdPVoNtb69suSg==@kvack.org
X-Gm-Message-State: AOJu0YyM9TeBcuRkgeo1Ua+Iwulmlp+HV2y5GUWfbFF3zquzC4xuLeSu
	HioroW5JyyLB51/nn5C/pxTwGGsNAyA8is72x+IMpA3FHUK7YYca5cr4icmdHALhfxrn9X9ml3T
	g9WuisourJsh9f3tdx39rpF/zk45kmwddvabMQB4Ov5v5IbY2ISrk
X-Gm-Gg: ASbGnct0PUUBafwChARd/kG9spywSJF32GADdWsLgfEfZVo4dlGSshTXNtTiNTaFJhs
	/nVgEKE880UGsJNCag83czMr/TCpXcFscCH02+/oG92Tqk0NLdnKiasUnwgoWPj2MPlOMWPBVtW
	PhBmgl2Hgal3AGlfsSBgZ0AlacwhftO43L1RThaATNAHiwmPWZVyh5MI3FU6JMpZlcZRTP7DL4N
	6G6qfroL0BhciO6I5wjIxKiAyGmuiTVkETSthpiPDomM0a1FHWhBfJEMKm/1zskxLjjFhrWagZu
	T3h+GxJ7KiVvEdw9czLayK5osacGV1uxI+XS316X1+amvWffbAoJECtzO0kj7jd7wDjAU6qlro5
	JhYDfWdetpG8Bqa5jRmjRV45PtpFXeqnpnWcf33nEwsw+K7CHfKzrOtEz69FxFQ7Mqr8Qdbvn18
	+566S+M+QeD78lhrKycAbHCsOBTXU=
X-Received: by 2002:a05:6000:1446:b0:40b:c42e:fe39 with SMTP id ffacd0b85a97d-42704d963b3mr855966f8f.40.1760642109095;
        Thu, 16 Oct 2025 12:15:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTwjlQtEo8QmL86bVhgI5H+nKBsihjFtBhqqdNCCeLESucnFPVLdDF1Syd2/2TIS9wcEA8jg==
X-Received: by 2002:a05:6000:1446:b0:40b:c42e:fe39 with SMTP id ffacd0b85a97d-42704d963b3mr855922f8f.40.1760642108544;
        Thu, 16 Oct 2025 12:15:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm64839695e9.3.2025.10.16.12.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 12:15:08 -0700 (PDT)
Message-ID: <dc14c183-d93e-405a-831a-dca69ede3cd2@redhat.com>
Date: Thu, 16 Oct 2025 21:15:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] mm: fix off-by-one error in VMA count limit checks
To: Kalesh Singh <kaleshsingh@google.com>, Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 pfalcato@suse.de, kernel-team@android.com, android-mm@google.com,
 stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251013235259.589015-1-kaleshsingh@google.com>
 <20251013235259.589015-2-kaleshsingh@google.com>
 <144f3ee6-1a5f-57fc-d5f8-5ce54a3ac139@google.com>
 <CAC_TJvdLxPRC5r+Ae+h2Zmc68B5+s40+413Xo4SjvXH2x2F6hg@mail.gmail.com>
 <af0618c0-03c5-9133-bb14-db8ddb72b8de@google.com>
 <CAC_TJvdy4qCaLAW09ViC5vPbj4XC7_P+9Jjj_kYSU6d+=r70yw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAC_TJvdy4qCaLAW09ViC5vPbj4XC7_P+9Jjj_kYSU6d+=r70yw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qC4aJ6QkvBW80PFG-oRE5DPP8ABPT1ij2Rvjg6sPvag_1760642109
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 6kopptjoucgn6ncokbg9thjdp8jxfwfm
X-Rspamd-Queue-Id: 76B36140004
X-Rspamd-Server: rspam09
X-HE-Tag: 1760642112-986863
X-HE-Meta: U2FsdGVkX18CNul6o2MZ6h63rUZycFQuowjMUYnEwgkLRiM/fVLqMwbhf+vnJ+U429mZJLLBGnM3+ueK+MZKbnorHXZ/2hWsscl0BzFZ3qVJUmZb0eyulI0824ueYU3vEQV6u9NPL/GcOXJO3VgCpvZOplhS1LMRP2VXRmvnZ1DaTNVJm7yNUXv/21NmvOwy/VrHZQC7Lq8nsi5sGX/kDpXe87NfnBrD2EPxvm97n+hZRLlDTENEIlV69K248tt7CvtZ0swwnSOUMshSljn1qYTkNkFEVBprB3SoBlJ5XkjUJOSIPSryNquDt4MgH7ctqc13J6pLpzTNWXOHaajhmszNiuamtdPOBOx3w58B/vRNZqAV0tiR6XSGD+51krJe/5h14C6DMGSbG9sZ4rNB+/Tuohh3hsi6P683CkIFAVXVDA0ebQIPsoTIACQqyDL4PF0CakFMFmL0a+H1GZJF1Ug0yG+e4ruXH8gsKK2RAoIxt13t9aaZODdnx8OSc7x8pPRHPN/RRyYaT8oXO9hDw0XUIZf1ppd7K+V5IcHcE7dcOzVKckYRs9RjgVwKzK5Hu6YDpsfzYOvkunyaaFv7Sayfxj94xOW6DkPPbO69miW5UIG2tCgQvHyOtQCZLaCqSB9mqhrON8usl6jFJlpah6Tb3DatjK1qkDPbewx9Be5k3E/VyquYpZgjK8BHdy+3+PP8u0yPhjK6OqbyjS8PQKsOev7Dt+Z/NDaHa04Y7QEM3tfVfp7Ch22iWV2OY1Z9gw7I2vGr1vllCI4A8Bl5dJINyonQ2GG7QfX54QyUr4olGYHnwA5Hja5Nsnx72hMAYo6Vf5jh24woO78t+zH5Xmj52jcLdLrvNhkZnAa20h5c2xxreLgARc/J7XkFws3ZTswOJHbKkdj44lP4Bn5sx3/1fO9kJyWMXZd1i3SqfR5nPhONbG8Nu5mBsFyeiNeIMSPcBSRCujQiiOJMjDa
 t6ZYLolM
 s27yos+tLXlY2oiqLnF8EwxV2nDDQDgk5Sx8BIlBZKMYC70s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> Would this be an acceptable path forward?
>>
>> Possibly, if others like it: my concern was to end a misunderstanding
>> (I'm generally much too slow to get involved in cleanups).
>>
>> Though given that the sysctl is named "max_map_count", I'm not very
>> keen on renaming everything else from map_count to vma_count
>> (and of course I'm not suggesting to rename the sysctl).
> 
> I still believe vma_count is a clearer name for the field, given some
> existing comments already refer to it as vma count. The inconsistency
> between vma_count and sysctl_max_map_count can be abstracted away; and
> the sysctl made non-global.

Yes, to me that part makes perfect sense (taste differs as we know).

-- 
Cheers

David / dhildenb


