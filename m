Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B482CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574966B0088; Fri, 16 Oct 2026 08:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54C0C6B008A; Fri, 16 Oct 2026 08:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420D16B008C; Fri, 16 Oct 2026 08:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB456B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:16:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B109A140303
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:16:47 +0000 (UTC)
X-FDA: 85328388054.30.99D3C42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id D066B8000C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:16:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dYFV1OMQ;
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792153005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXwcfo+faB/d8Y5clwXPismEZjCAQ2x4NezFd8SmQ80=;
	b=YLvSAsA7kLUlwfgMFRFyMl7XjZ8bpK+eqYUbbSl4CV9A5V3q/KaZ/mR42CWGlaskKBBP9v
	akReVKop9brP/CNKI8ei7kh6Ohp9Z3PKD5ufJZIMzGmozOkbDRq/8BTXZd6PrASmXDmgS3
	OjqS//4gcJLYsTZvpoaK+Rk4zZKFyb4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dYFV1OMQ;
	spf=pass (imf30.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792153005;
	b=gF5eU1OWJJdbSjCkWCUnmDLcAXn0WpVkmn1AQvzrxNjhDN659rJiTTZy1ol3pektip7yjK
	LvWAFnYXfRuax6jRET/ah0q66p297Mub5S+1OEhfUtdXJeg/fIPJgZOYOL9fwQaWk/fOct
	3Vri9QQRmwxMHM5XLq9DnglmVAjjdMU=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48c45111bebso4085526f8f.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792153004; x=1792757804; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kXwcfo+faB/d8Y5clwXPismEZjCAQ2x4NezFd8SmQ80=;
        b=dYFV1OMQLwGaoKtO9E3knpx0cPanCPReLMgfqzOJyUAKzFcQQyhEV0Kj3Dq9o7dI7l
         jZhJKIAvcxNaJ1a9Jg4Th1+30ks5+v7uB7zfwQeayBVV2883jSosWnRZ8VELOXeaK1kb
         LpgLFGvYFnYBKYKBlbbuC1Th80FZzsHblrl1kAettQmWxUo8a+fiQ+LxRZQiFOFfee4P
         V5/2jtts5BLYdfQnHvWStpHOJ/RKNrzCyNakFc2d3UI9bYP/O5X4NvW4HAOmlJ7jI0yF
         sT7feIXBwgv6AY+c0EO497SMkUxVyRD3RbDnWbzlOpbskCBn/zjhoEJiddNNWDBV5cre
         fSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792153004; x=1792757804;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kXwcfo+faB/d8Y5clwXPismEZjCAQ2x4NezFd8SmQ80=;
        b=QeUTIMK7weYos+KvztoyCzPeUrf764+ZwZnekWmSdRdZPzn/aM1AShqLww8IUVOSnT
         5X+qTbDawM22pAiMPEwQ5a8ID5vABSVeqKJSwvYZGc+2NQE/ogX51Ir8RcKN7LviN61Z
         1Tl+VSewgtWG+lzFo1cphJHwBolSrpVsZj97RJpRSTODeqNTllajicgr9Vwn4boOJzhv
         hB4rXoteeb3zrRKVm9t5ftZiwKmvt9JaLAxYNjZjdrjb6fEsuHuc+wMZg8+PN+S1yhFm
         vWRpdYKykSdpGkY0jc82EC6fezq+2iB0bk7H8CVI0nVTY0dzM3LQ/iQwerjKcKq/Zws0
         lOkg==
X-Gm-Message-State: AFq9FYI7oG0P6QgP4XlW2tGEkLEu20kUmiLf9of8VC2vRtybJmuahKL+
	y4ar//+xOZb9ynaEJOTg3a7LW73eJxQoROdBWOBQ+rcn3zz4ym5NSevH
X-Gm-Gg: AYBFou27nUKFSdU1SJc5VEsb5Ural3w+Aeq7Eideu4+Ik7SQQdNdlf8dViv1xzr4MEr
	RRbCt9MFMEA2Pl8te/mfQyYUMXMf3pBdFAa5SGnDGDz2wO+RkrPihcv/ziHufycXdJWkg9EIgsQ
	SqCG+3ziiZOPi/rloPAcCRaOjBrY9bTwUAU1RGsVTMKxu2ZZB7EAdwVqMrgRMoPgPEmpMN8zIzv
	IYNATN1wCQ9V64QLoRcT20G0SZVisJ8M4M0klHdLT5hQbJPW6zexjfonq5YDjOi5PPY8QjWM8C8
	JkTtC79m4cyF9wPWGsapR2S/e5hCNnbHtwAzzwbt8J3U7V6e/W4IOmhnvcv7EEuESD/aFYW/Y8D
	ppgW7/YynI8gNgICP9/9wLqPtOz56EsPqhuf93qP07ZQYLGftXwuyAN8XDOQOXW+x0UGvVKoK3D
	KX50hggdWQ4d0Ke45Fi+eRip8cWFqQS1RVyR3B5sBiEkypkhQPYEDz0GbjfMS3cdd1aQ==
X-Received: by 2002:a05:6000:4303:b0:48d:de0f:b79 with SMTP id ffacd0b85a97d-48dde0f0ba0mr29342329f8f.0.1792153004392;
        Fri, 16 Oct 2026 05:16:44 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f5b2dsm5076765f8f.31.2026.10.16.05.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 05:16:43 -0700 (PDT)
Message-ID: <6e0c5a1a-1e82-4847-ae23-1b2574042ca1@gmail.com>
Date: Fri, 16 Oct 2026 14:16:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Daehyeon Ko <4ncienth@gmail.com>
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D066B8000C
X-Stat-Signature: 3p44496ugcoiu9g5hfpdo3toenq451g1
X-HE-Tag: 1792153005-66540
X-HE-Meta: U2FsdGVkX1/oRBA+kJ0km4y3tsAQ5RjKZCrnbVoj1RA7ZUnCba4yLB2C8SGZ1lZaxP4NmnmQCV0MC5oQ94g9v3bQoU0RisG3FUteTgmU69Eh7njkAdu4jtZB8bm8rmwh8hyCzNxJtXAgh/s/yKDC9V/hUl4ozzV6bzHFG2l9+G4vPOF+Qgb0KzuZmEdXXhuZRQlfK34ZrIhlYam8f3FI0TW58YBawQdmS7DrKed82uJ0gViTHZOs2FTLwvZtZ4q/1RKoss8A6g8ExTZDOTG+QH9Q1YJVbexZEaD6McMQ33++7m/+JSdF1ZHNDCtF0WVxXfF4PQZe4xPHhbkedaqRdTvytVinM/YFKG4GhBSOgRiYGkkSvpIiU7jPCrrcuIaMvC41uOPt+NxIFPy4XHo+vXbwIzxV0UTLoxP8QvwxeeB4uTIRPldvbbWRToYkEIEZ1Mqe6f5hgTABTERJyNAKiP5uu0PG8nrw5MJq58JCHBTauxyw/k6zkjiYyap8+Zp62TEVy7YA9zHriHebiqx0aiu6r5ypd+OOjyVDD4oFPGj8FDuBdFs47z0W07QXe2fF5mi1xL9Qxq4kBrjjvq8BFK2WCtYBFZtfpqSsQZiZUCOr+fCmyQKWgpOy2GIcEXxOHqhRW4w2ibku98Z8fktOL4lM2pxu18WMadILD7S1JGoqBfixsoxXVk6R9L0krJDfgpUM4DeCCx6J/CPflF9P5YMSBuBuhPTlHnQU4RHhJo3OrQlnJfA4i03onOeOodsnyfGSpyIG+qxSEX4Fn/sJwlhtIvMcPRGtLGnK2NZ5W8RhZocgGpDxM2AVR7iCzdvqZDzZZ5mvuNIpeHImSlPs/Wyd0wqc9CDVNtmOSZ53vuWwBMXj3niJwq6uVu+g0PPBj/AVN+63nsZdM2vnU3gh1P59gy0jHaSgASTpUxbxyJjFzh3i6ivKWsuWaH53HqIPdhPzPvN1LBErAH2Y1TR
 bt6EneJ4
 dnf6DkLdOiawRtgp6/D9/IgFR6INxTw3Z413Ojiyh1C6PTM8zUyQdtyG/rcWQQOd6lT4VOIrEQZITvJX0pugn+fg6UbwBE+VrG2mwUBGjC2XJVrP/RxaQL2gV43RIZtvYeed7/9IqNIRsqWwcBSDsv7f2mh8MjYmeJMlc7ZL2iobUq/0dM8+ZSaUqlGCi4o/lgMlB2X7wsAcJGqeYp+mTgy2RYl4cEtscb5WLmXN7E1yJsz4zoJw7FcZVotBKcw/ywKz41tmU13YO3eH8l56w3g+JfAWoaKE6KXIve7Rzd5tLTh39dElTz3nx4my6oTAWb8gfwk+53Zb/8j3HahA3exWnghsEIkBXmdvsdGHCw4YUAguV52rkUvjGLxHHuViCyGRABLhOKikGVYBeXdKtoJD3D+c54s2jJkRSDG7BtZgN67V3FqhzGTZ62KB3L6fsaHdJICU5tDl2e/tz1PgJzjx4Hqm/tPLxg3XFrijxgBkCAfLB3XC76H5nPfq3rqC3NjcO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 1:34 PM, Lorenzo Stoakes (ARM) wrote:
> So far the assumption has been that mm->mm_lock_seq overflow is benign,
> resulting only in readers spuriously falling back to the mmap lock, however
> it turns out that this was an unsafe assumption.

[snip]

LGTM :) and also tested on qemu so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

