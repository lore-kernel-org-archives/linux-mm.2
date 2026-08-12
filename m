Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8125DC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 07:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4366B00A5; Wed, 12 Aug 2026 03:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674646B00A7; Wed, 12 Aug 2026 03:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BEB6B00A9; Wed, 12 Aug 2026 03:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1976B00A5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:03:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 940BE1C0495
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:03:58 +0000 (UTC)
X-FDA: 85091727756.29.1D1CF24
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E22918000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:03:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AwIq+J9d;
	spf=pass (imf16.hostedemail.com: domain of vmalik@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vmalik@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786518236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMSQFwJ3Pn8MGM6lOdOzrV1KHdix97IWR2KeUG/GEeU=;
	b=EOGa6zZkM5ivMotdUopamtDMDGRHqpOJmRaNCWPSwY9c+NS/1OBPlAhFWAMzujPE2ctK4I
	i07fHmafGSkHMZg0EAzpAd6AkhaVw0YgxYCP/32Otq7R9Jym0d69KSQjOOIZDvpwSngME2
	6yC2cirAnPfuII3KzN/9t599AGjij5A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AwIq+J9d;
	spf=pass (imf16.hostedemail.com: domain of vmalik@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vmalik@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786518236;
	b=V410oY4uwQ9o8ERvsoguenFWEnEpWdGmg47blTJj0Iq6aU+VTgTA/qtFEJ4TO0Km5ulfi4
	HKRKfSaherJ4qU2AhzwRTl8b3AIoQaq+ULZP6HMaUBTRrwu2gBdZLJvA+gZD+tpX2XeyID
	fHKwv32+5sX96kPbMLvRY0sA69QQwZI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786518235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMSQFwJ3Pn8MGM6lOdOzrV1KHdix97IWR2KeUG/GEeU=;
	b=AwIq+J9dxpqYQWpI96V9rbgJb1hxlMkzj1AcQiN5/EmSzIHw/e9412XXmI/d+xqKPYWkRj
	3vqiQWNr0UyzcChbdaQSDAR2AIOUV5EZjfVdMZRyCww5B50bvFclPeF00ElRiiUnECmX6d
	j14rpKS03OPNq1zt1uguIFbWWtPJLSw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-wOcL0Ey_OPm0_-uO_PxkpA-1; Wed, 12 Aug 2026 03:03:51 -0400
X-MC-Unique: wOcL0Ey_OPm0_-uO_PxkpA-1
X-Mimecast-MFC-AGG-ID: wOcL0Ey_OPm0_-uO_PxkpA_1786518230
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4996832e7b4so11750435e9.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 00:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786518230; x=1787123030;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GMSQFwJ3Pn8MGM6lOdOzrV1KHdix97IWR2KeUG/GEeU=;
        b=MJ2qU+2o2S7nHDm1qXSddfWvpC4G95WuG50srcvg3a1nfABYLIiSIIZRqOCCdsq40u
         mmzXmNBVrMab54eICevCbESU0XUcBn38fNlcWyJBQFpBoKcreTw/F7iSJfv1lNjPjIro
         LfbXVGIxh6q3lEYxX0hTHqSaPzr3Ym2m8RawcR0agJxMlA24HuRMqrZdsmCFWesfkNBL
         J5ZihyuF35ntproGGFigOZbWyY+pSI2um1/8xPPfAnpxoCbm9hawoBQHalcxzapjl4mk
         JbnfVU+Yax3vujI3UTy+b0kb21HxBhXKHnHhQMuEKJxQEzjCYXJZydzpSnphI4jeymsH
         IAvQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpm6ojtLiROHay4vpWQlhjrmhxd+S/TohPREXUMVUX4uleiShR7hifJdYQ3OTs8i1g1UfJzqwjmsg==@kvack.org
X-Gm-Message-State: AOJu0YwqKlC5+7pp9hUYx8tFbuHUDqEM1yWmpbcRonHho14r3vzWRhnq
	SH4LF2yMTsTTc+gYaDiywhdOJvZUS5f2UxS3/CqGgGrW1e4SZUr8se07ozNNM54lv2+y3y53kLI
	GwtX9YjBba3wl8Zc8OP73VC/2+76aVKWVYwHTbdiuf4m9QAFIJYk=
X-Gm-Gg: AR+sD10DrEG/tMnToA0YFMjDunf79cmJmF5xdebzwO8VxbX3Pnd8zoUK0/u0HJEEoRL
	ED3iwuVe+918Ep197iosIH/uSbcCAk9VvO6Yxyrz8PSjFOfwW7NJxEZaaYSmoFLtyo+fSX4PKx8
	XVGYVkAvUiU2iPoU7MPQ5m7AFCGDuRxwb7vEZ9bRTwg7nj23pQXqOV4zU7J0zSfVQ9Zi7epQBD5
	yIXjST/I4YYlSXoVutyhx714LYs9dn+3txHn/ZfJHhow4vXy9V/fYq3gnIs8kLR9NdOTzLH1rOQ
	hMtRa/qXIpvvUbqH3Hk3Hw3rn/t4b14bI28lCaygYr1j8yQ+LdBn9FDYK/szbhtaxrcmaMw5AxZ
	iadDIAu1nVgf9Aayut0cV9hXSLOIxUvUgfTY=
X-Received: by 2002:a05:600c:138b:b0:495:5d6d:9cc1 with SMTP id 5b1f17b1804b1-4997c30b80fmr29456725e9.0.1786518229768;
        Wed, 12 Aug 2026 00:03:49 -0700 (PDT)
X-Received: by 2002:a05:600c:138b:b0:495:5d6d:9cc1 with SMTP id 5b1f17b1804b1-4997c30b80fmr29455945e9.0.1786518229435;
        Wed, 12 Aug 2026 00:03:49 -0700 (PDT)
Received: from [192.168.0.135] (185-219-167-205-static.vivo.cz. [185.219.167.205])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997ada79a3sm46337885e9.1.2026.08.12.00.03.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 00:03:48 -0700 (PDT)
Message-ID: <02ce6b65-7670-4dac-ac9c-8875867d6ad3@redhat.com>
Date: Wed, 12 Aug 2026 09:03:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] selftests: add shared lib.bpf.mk to build BPF
 progs and skeletons
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jiri Kosina <jikos@kernel.org>,
 Benjamin Tissoires <bentiss@kernel.org>, David Vernet <void@manifault.com>,
 Eduard Zingerman <eddyz87@gmail.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, JP Kobryn
 <inwardvessel@gmail.com>, Mykola Lysenko <mykolal@meta.com>,
 Nathan Chancellor <nathan@kernel.org>, linux-kselftest@vger.kernel.org,
 cgroups@vger.kernel.org, linux-input@vger.kernel.org,
 sched-ext@lists.linux.dev, linux-mm@kvack.org, kernel-team@meta.com,
 bpf@vger.kernel.org, llvm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
 <20260721174833.1232771-2-ziyang.meme@gmail.com>
 <f2a0db3b-ac66-4b29-9dff-a691d9464123@redhat.com>
 <anTlFSsr5FqQt+o8@devvm16600.scu0.facebook.com>
From: Viktor Malik <vmalik@redhat.com>
In-Reply-To: <anTlFSsr5FqQt+o8@devvm16600.scu0.facebook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ivs450jRBlBoWiZG4gWeJopMi5ilMGGAFRTmfQcdfIs_1786518230
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0E22918000C
X-Stat-Signature: ngttnxtcnfsgpcuxofqi35c5o3csezqf
X-Rspam-User: 
X-HE-Tag: 1786518235-829051
X-HE-Meta: U2FsdGVkX1/nN6CfYIf8SuqH1eAapdwP15EP9Ezdp/9NgTzDdoTWBgf7d0pC/xsp6cGTDQCsghZY3caYvRBEop22Dob26cY5fHvvmBCpw0Nk2/S4cQd8k6JT/ccJJwLCSYWCqsNHCovm7lDLuRJrb/faCNHAio7UXo+4ElPtARlofbhegOL0urOxkbqwinMvyOhqMs+WN3cdFwgnZqfvkihRYRT6fJ/OdWkBWc74Us4S5JEnMNWlkC1ykrvFGU/LiTRAexZB0v32Nt9X1D37UpTOghPB1L5sTj/gpxo06PBaAq5Ti2p/Yb71qX5FIjrvtMszJzDMtBIdWVSAuxL/WuurYkSaPiBAKx9DxaBH76uAd7FOYJBhZYSzqCzHKfjnrI96OrLtygRtVlxRaDld5i1BNAQ+VIgMUcwEVQ2I1yvFeGKeFAhfBbhyCQskPiLSGl8h2StBuTYrWp8ys7q3leFenLB+VRiABG9ugci7SK4e4u6c2J42Bsl+8UBMkQ5IgP8xa4wspQCgVnPfHSPle/xrn3QY2qb2WR4RS+T5YudQoP6/2q9t+AeKBUkqFPAaNzrSK5TQYHwBsi8w69RSirQQ2ZmS2I0S76/lRuVBSGzJdlD4bqXyMZNegEnaQ1vM53ICOtn+0zT8E+9sSvCYy8vvouzerVn4P8G3M+OMgNj/ETb7BGZ2yQpX/43R8EZ6hl63WgRVxcMmq6YCE9mxAl+2gacN/Hea/lsoV7Gr4fR9hX1biDLO8q6z8o7l7WZvsUBbrMWfmrqcO4E3mytoru3QlPzz8frJKMzlskCLv77IRBeFTa23i4VA9RwCqSjeHVh0tLt9qUPpq10nyH0PAqOHAF8iou66WO2hHk3Kae2zKGXrN+TxNIn5wB4tzE2vzkyzAs3ibxpwT7uefqQtYKXzFYIFcKIIgsvWS8z/4LLvRl81+Mgxpt28J67GZD50IkW9PP1tZBgdxqQccHa
 QQ6bJw9J
 0Uey45voFruaPZWs3Ds3kANcwzqvds9u2NqGTWZ8pBTGQJUFlrMQOhxu28CEZMfuWjsEyWHbXW8xg4WTddeoUVcfV55TWFle8ZqBhBmMwr2e1cF71FJ7O+uLzfus66Zg7Yo6AIjfmobah0W9EZDi1ALiLidhfkdSCxlsDeFnhLEBOOopQBnuqebByyZoGctR1/SG5dPTYrHP42N5ECFmS/h64CINivHTS3fzOqvynIvVOAx012K4QrvgF0MiELeg0lBEnxhftNuEf4lTuTy9AGrzDw7+WcH4egAU7RVxb5RL+Gqu8RZkxJ++a4oQ6Eb3/empCndbl7WTWOU+BpOWZgWsuT76ZFvswnSANvHG2xg/DAv3u57L1VQMJf8Ii7nLVpmq5cdD/8alybT4XUy+rXuI9PbhRZ0PchQWh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 21:48, Ziyang Men wrote:
> On Wed, Jul 22, 2026 at 08:50:06AM +0200, Viktor Malik wrote:

[...]

> Hi Viktor, 
> 
> Thanks for your suggestions!
>>
>> Looking at the same line in tools/testing/selftests/bpf/Makefile:
>>
>>            EXTRA_CFLAGS='-g $(OPT_FLAGS) $(SAN_CFLAGS) $(EXTRA_CFLAGS)' \
>>
>> is there a reason why this is not respected and -O0 and -fPIC are
>> hard-coded?
> Yes it is true that there is no good reason. I will fix it in the next version.
> 
>> What if someone wants to build selftests (including libbpf)
>> with -O2 and some additional flags?
> I will add a flag such as OPT_FLAGS ?= $(if $(RELEASE),-O2,O0), which follows
> the pattern in the bpf/Makefile:37. So if we run 
> $ make -> -g -O0 -fPIC (taget libbpf) and -g -O0 (host bpftool)
> $ make RELEASE=1 -> -g -O2 -fPIC (taget libbpf) and -g -O2 (host bpftool)
> 
>> Is that possible with the new
>> lib.bpf.mk? It would be nice if it used at least EXTRA_CFLAGS or
>> USERCFLAGS defined in lib.mk.
> Good idea. I will add the EXTRA_CFLAGS for target libbpf, host libbpf and host
> bpgtool. Such that: 
> $ make OPT_FLAGS=-O2 EXTRA_CFLAGS=-DFOO -> -g -O2 -fPIC -DFOO (for target
> libbpf) and -g -O2 -DFOO (for host bpftool)

I'm wondering if we could use USERCFLAGS (and USERLDFLAGS) instead.
These seem to be the preferred way for all selftests, per
tools/testing/selftests/lib.mk:

    # Enables to extend CFLAGS and LDFLAGS from command line, e.g.
    # make USERCFLAGS=-Werror USERLDFLAGS=-static
    CFLAGS += $(USERCFLAGS)
    LDFLAGS += $(USERLDFLAGS)

At the time I was adding the extra flags to libbpf/bpftool sub-makes, I
wasn't aware of USER*FLAGS so I used EXTRA_*FLAGS instead. But now, when
someone wants to build multiple selftest collections with extra flags,
they need to define both. For instance, building with PIE requires:

    make -C tools/testing/selftests TARGETS="bpf ..." \
        USERCFLAGS=-fpie EXTRA_CFLAGS=-fpie \
        USERLDFLAGS=-pie EXTRA_LDFLAGS=-pie \

Switching to USER*FLAGS for bpf selftests would simplify things a bit.

Viktor

> 
>>
>> Same questions would apply to other rules for libbpf and bpftool below.
> I would check it them as as well in next version.
> 
>> Thanks!
>> Viktor
>>
>>
> Thanks for your time and reviewing. Please let me know your concerns. Thanks!
> 
> Best,
> Ziyang


