Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC59CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 07:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE608E001D; Mon, 18 Aug 2025 03:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286806B00F9; Mon, 18 Aug 2025 03:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CEC8E001D; Mon, 18 Aug 2025 03:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 08DA66B00F8
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:57:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7CDCF1606DC
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:57:03 +0000 (UTC)
X-FDA: 83789122326.05.656BB68
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 34EB614000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:57:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pc+7F9sn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755503821; a=rsa-sha256;
	cv=none;
	b=iVoQp0ia3KI8XJGCJGJQFdygd6l7ZcOD68jtrTrJFm19ExEVCRSbZ6YkacUAdAqEMFJlr4
	UMDBDdOr2Vfo+VixDamNo3U9IrAZvVuBGvwqzoHPN3F06DMKCKGjE0MkyFtoqxqepKiMLJ
	TkG2BjXzNeGrclLJE6RY3VpkUi6zxtc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pc+7F9sn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755503821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJ/waxf7shlm26D4jZ2oS7S6MeDF1K+mmlGn6PRutyk=;
	b=LVJJcPiyXSfn/BBbLQkdgnF+Py/RJIBu0TOeerzgEyXqQia8iUjaKCFGQGenGPciUQe9x8
	jGVvwsvKyX1q+68OwdziGZN6KSl4flrbr1XuZU35IfqS8CM2tq4Frbfozb6FvKJSQbvvXC
	pFAgV9auy2riicV8+9njiuOAGd0v7TY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755503820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BJ/waxf7shlm26D4jZ2oS7S6MeDF1K+mmlGn6PRutyk=;
	b=Pc+7F9snQ3n677lAmK96+xb2JQ8KfOI5wK2sZ588Si2Z0T7NLd/QmTgYHklGIXxXLCTHns
	KBC1arohrUYor/uI8vNwDKZkW7yn8Hng6BQr1LNwWJBFolCG9+C5cigbYboCnQRsQGSKnQ
	J+CmSylBhfOH3Seg1tvQcfWPnlRa0jQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-cG6l2zHjOpif1JE2BhGLQA-1; Mon, 18 Aug 2025 03:56:57 -0400
X-MC-Unique: cG6l2zHjOpif1JE2BhGLQA-1
X-Mimecast-MFC-AGG-ID: cG6l2zHjOpif1JE2BhGLQA_1755503816
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05d3c4so22918655e9.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:56:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755503816; x=1756108616;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BJ/waxf7shlm26D4jZ2oS7S6MeDF1K+mmlGn6PRutyk=;
        b=LPbCBEF/XaO94A09BnduYgjgZ35cvU0OVFrnuPyrXcoGOG7IceS0dy9K6xtdJL2jqz
         b2ovFD6pFPdb+rqJX3u1NWs0/Pn7VZ5JC/zCc0K/GaWZYAIKz1853UyJc2idpvEXuxGY
         VtCLpF2M0xi03UYxDkWmdNccsC62QT2sy6iuTBswUb6+uwrP1W60jyy0AKjS4F15Atxf
         ts8FERvPjrnf+IYqy3EFUXXK9flNGfSXDECxDG3kp8O7vDupSJzLdbrlBhcfhgveS/rc
         JYv0hXnSiTS5K7lzXMXsvPBCa/+mX8Pi2uPbhupF1rJR6RaOHlxLK5teQsIsX8UVofLc
         DPsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzkES3AKjShX5iSGbZtjlnQN4V/QGY/xn6PNJc2+01m3rhuUMbZl5CoN3QXhaAWwW+/O9m4eMgaQ==@kvack.org
X-Gm-Message-State: AOJu0YyNdY8IhwZr3SdgOix6CFseSr7U3fMPUl4kpwBAoIf0sMeiDNm2
	AdrsezibfG6N+0zTZfSJ3LT34cYj4sgRXE2THtWIkPngJafaYI6SejQBxs/j8YACKndnfPU+7Dl
	Ou0g4gY2/b+aI+yA7g7Ow1c8JOiY34rZ303hT3fm3+S1xFOg76mMO
X-Gm-Gg: ASbGncs+ilKmm9xiZjWN2GqKQaGq1WdHODmb71V91epraNuC+H/nKni7AWz7PpDjd1V
	NCE4QzlhyZqhVmgGtGMNfVGdBrPKVTrpgEua5igG2xnoOhnKqgesfKSRKjPfb4s7280ZGO5tsNq
	TqkRI0O+SS1fM2a4vOoeff4MJqWC6+O9zmk5XC9/0wih2UM5RVIYgN6rWz9Cl8U0rkpti3oFTeS
	ECUSKrv8ScV0qmz6xNTX5O+vMYZHGZcjUk/XWJFNtolthCNyhQi7sPEG7ILfAhDTwUGdElW9T20
	V8is9DtY+L+KObPuIQo9SpYv3lHyzZzGzJJeBU3RX47hajg/2EEs3Wir6SIBKalHLCfyJKBpDEN
	tb525mSbj++wCzN97Qf7nggQegroxQXloW9WrIoqM8IQaPdwgJmepyadPJhxRa9/g
X-Received: by 2002:a05:6000:2485:b0:3b7:99cb:16e5 with SMTP id ffacd0b85a97d-3bb68cfaedfmr8252291f8f.28.1755503816003;
        Mon, 18 Aug 2025 00:56:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5lIFG/pwp9cWcad1i1QkSJoxL9baJo8KcsDGdZ6bqql9vBoqBBDo9o9ETypZV9s2yLKqg8w==
X-Received: by 2002:a05:6000:2485:b0:3b7:99cb:16e5 with SMTP id ffacd0b85a97d-3bb68cfaedfmr8252265f8f.28.1755503815615;
        Mon, 18 Aug 2025 00:56:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb6863d9a4sm11799764f8f.61.2025.08.18.00.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 00:56:55 -0700 (PDT)
Message-ID: <36a05826-76e4-4723-8f9a-592c745af38c@redhat.com>
Date: Mon, 18 Aug 2025 09:56:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] selftests/mm: mark all functions static in
 split_huge_page_test.c
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 wang lian <lianux.mm@gmail.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250815023915.1394655-1-ziy@nvidia.com>
 <20250815023915.1394655-3-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815023915.1394655-3-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: phDJrbWtPcUrAqHPJPnf7ZiJYI8N743c-DV4vJmAS9o_1755503816
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 34EB614000A
X-Stat-Signature: 6c1j37k85of68cpysxxi7ake4wnytuqs
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755503821-492698
X-HE-Meta: U2FsdGVkX1+HXRDPCupFmF8znm04OjULsnP86hzTNyWtvz5AKu6b4q+2grOmcSrMN8tlNdugc4yat3gu7hFvB0AjXEQcVx4r/TFW+pv2FnfDLuCdHKCu0GTNRCVJjuU2grCmgT3end8wbpzCZkBLVmJJEq0W110QdWACjbSFsinchP+aiXa8Avg+dr1VeG03jeF/kEpIxzPy39JmaeJZFaDG2dBYGSBhYK8QlP93Z7yNGMWHl2Ip92CjF1eNjPzjbphneFQHNTEzsOBJVxYzZQ+9LtCckcXmpz/UH3CG849bBmshXRxpf8ilXHjvMgxUGMLqeiibN5xsPxbsTbbWZde5KpSwZ9LDzUN0kgPiONVjooQiSGdnN/J0vVcxHqE5iE2VTduHN68gkjr8TT/qU7sYGxzoh/mX1cxOaP8pQ2+C6qw/vfMGU18FR15iryx5X8Rn3v3pSpzBtVtC8DyVG3Kk5sKXK1AX7xyomopXCbtmNR0yK6K78f2NGD3JD8/VfLu/qm1s4UFqcbIeo0hIO6Sk+zbJlk9GQQfGGzDdOSRrtP4//wDOAfDiGsnFgqXxYPDgRX+XMaO8hOFPF6FPAvCusErUDxyB65beWeDuojmxfZPLtzex7CQkYsB/ofeQsKe+fHaPecaGRBxjWOsJZK3sZZr+B19aJbCX3+Cd6AJm3Kj6ybrE2XT0/MSxoKLHCJ3exkFY22eeQwYYMwc56f666m8K8PAtwW5acjU+8QXzroTgvKa9nfFxDw6+jO62fv0n9e53u0P1lhceSa2OcFwriXW8K+qTBezfq6IX7hO9chdNDvCywG+i/eS5cwTG+XaCY3Fer9JrU7UNvU2RrckGuGKs80dE8mdY5EGE8hlLuC4U11pshqJAEPVaI+i0uH522dMo46ipU4syMjvRLMOsfs+DMdfWSzRRkX4ygXv9o7TmIKYjiFwPjpVvVdf53ND/Q2KjbN5Cv3nB3gj
 93GTbssk
 LoWJbwoXXr6e8RsK8gtqJAIS/b8a4JiW3H5kR4oDvXcMbnZLC/slHiXxr94CWlzBfkeKvPln5ZHsq4BpVXHxqO3q/Kz+W59hx/SnGDNcvZVdBKfLk3GP6zNIyxLLEZmp8lDGJV6UU+yLYFPvh5TTyaLYW9gGp0kN/FQS8WBM5ZKAv/tpexy5yvEZ2YiLtypJ2DlfGrEFX2SudHfeFCHSMc07floBaivxRXbYSGyG3XD9grAnyj//f6CH8YaUvWlO/c6rXiP6yd+V5oem0sJPHC/LdP5CVsfnsJGnPqDEEFQY4MWAR+RhtGktpt8vR8TGv+ZeAZD6w6BPLPYpctwFzw3J21opf11S7sUjTmUcD3wWRDmhOR+Vt3AcygDFr8q6jHo1lEqAoZNgFur1eTylUEUPgKrcvu6a4VALy1uTjqTMzlSCynJInCwTyYEn3fleW6VHDMzpkfOo38FULMnJn2NhcO4JlPcMHZsnAZL7wP9NoeDerHd571p7QtdVeAkHAEqog0TM2vMxAbBEwSHVHRHM9bkqlrG2eKFQ8ZacAKh2spLJeoIi3jO8P6lQ+JMEDYG6S1y28U2iI8hs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 04:39, Zi Yan wrote:
> All functions are only used within the file.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


