Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0AFC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 18:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74FF89000C9; Wed, 13 Aug 2025 14:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727C2900088; Wed, 13 Aug 2025 14:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664739000C9; Wed, 13 Aug 2025 14:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54BB9900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:58:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18EFB58F9C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:58:48 +0000 (UTC)
X-FDA: 83772645936.27.8C49E8C
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4C9D9100009
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:58:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Igkw2dKP;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755111526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErXJd0vSKv5PIPRtkelRINjdCNBVARkoKSWpOpAGMuo=;
	b=2QnZKPqUx4DttlIRWDuwJnmBdE1IodLnFfAwXUwH0zQgdZCTESqZmSvF7nWJ+mTsrBRbdw
	R/1MC9jfoJghzFLx12fvzPTmUU/9G8d5PekeKUt8C4iPiVnvVGbnx5vUzCioxU37ZZF61Z
	N/U2XvNHeiOUrp3gLO5jOLiuYD76PXk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Igkw2dKP;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755111526; a=rsa-sha256;
	cv=none;
	b=m40cx8J0sT5qtK8XLeIp6moZT3E+D7oqODRnFB/Bfu7bHQfr8JnfcNevBcNTfVex6VBhms
	vKKqq0GMWk9RNsbcxOOEAVdBcn3Epj+cXPVuCDmxr0XXU6A7Y6ELvzGKHs8+pop9XR+q+Z
	WcYJ8/44ZFRRUPMYbCYKyI+betUlhsI=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71d6014810fso2331447b3.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755111525; x=1755716325; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ErXJd0vSKv5PIPRtkelRINjdCNBVARkoKSWpOpAGMuo=;
        b=Igkw2dKPW+CCh1FKz/6Iz6XBUlAF6ZvygIBSdVKK+es1W7i4civ1qQqpYM3saXBr5W
         hwtgz7YKOgMUJJdihJkYgGlRaEKpEFycYf2R/QOngAK3Xph+CwSIVT+xqYFgQHUvEfpx
         LOtktlStnopMCnfpDIj1z7f14y/siK3l0oAzZesUST2JlbrPDtzGH0wGPzu4Mfq3XZvY
         p+TsCqMO9zOk3Fted0VodrT8lgfD4ATQeswy969xUIR0I+Q5W+4+UqYQ3P5u0OFANwPK
         IdPm6RkAVBFnN1F3ebqXku2RpqJKm3Ma/RhbsBuQ4OsriiWytCAwfxlz973jPtOSwq19
         AAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755111525; x=1755716325;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ErXJd0vSKv5PIPRtkelRINjdCNBVARkoKSWpOpAGMuo=;
        b=uVkyG7QkHcrVHy0AJ6b2ey0Qls9YYPIv7TzXeq2aMhlE4Z1awABX2xGKxuKzuB389Y
         ndI0v2tw0gy6GUc+s3m/wXyrPvn9sXD5KV0foYgkHqiyBzBfZLYf+4EZ87xTaVmyZ8pe
         cJvgnJYw0+eRE7SUrsjywYUOKmnQjPlnYUJTel21n1fKJ/0ZA5Op7lpmf0hXkckf1seH
         UsrLPqzIgWbJ2hN5xnOJMLYWyYNh93NXD93EN5PjcMiseEsb/6x0RaOrA+TNJa3hwCcy
         dCUcxmLAhzsJ+UQReb6X48MWjEBK/6VF8w0uvrHJ5/t5fqhqniksj5luo0Jm13TUKT3j
         n39g==
X-Forwarded-Encrypted: i=1; AJvYcCXLwsn8wIhqfNkbI8JVuXijpesbDgolhbJS2xGyZWDf0vAeiaC38H1hSe7d11Cjij5o/S4L93AOqw==@kvack.org
X-Gm-Message-State: AOJu0YxGmQrN+cI2bXOOzWeLw5mKgp5mqPPgHJSvuXOIqUCVVZ2Qr5od
	GN9ykq8+g6niRFcVgDQFslvrElnJLY4vl/SkDxAreZjj86y2z1TvB8PzVapMaBeyOw==
X-Gm-Gg: ASbGnculv7jICmX9PO1PkRikbAoBeYoBUXM2rRUDLES7+siffa9u1L/XlZx71LIEswg
	g9oF1/0Zbx4ghhfpTp1zASG+rgeukdf1EyQoXlNlYA/o0sxlUEX4apAaRNFcRsuCb4MMqd5YOwn
	PzYstG46ZboLyjQweM4KhWIWDrrOehBna0zJ0zi05oXlLd1IOw9N7omuLUiQe1xwKGITrCxuyc3
	EUqHeNoT2OLoQ/nM1nBZkdsBBzEBMIzpzdvA1BpNkwJ0Me9kfV/NBL5cNyQiPocQzmAriwA7pIZ
	AvB/VozYOo8Zaf74bOCEAJcAgdms3/24I1OXj/qLmEtiPn5MBOCwMbR0m0LNqliUXR/jkBBMXjf
	XJRI2DQaHOhOUNjKXqWxE1+ihVxT59lYd9SjFBfuqTCggRMI5+m+V+CIkS6eS8Ttlg22C/LgmUR
	SsmOTLCQgnLOuv3TGqXg==
X-Google-Smtp-Source: AGHT+IHmWCKebeCYcagzzC5EU9PLeskZg7d3tFyQeQvq8T7WEqyHz15NqNtOu+rYzodMCmCovveD5g==
X-Received: by 2002:a05:690c:708c:b0:71b:9c07:cfa7 with SMTP id 00721157ae682-71d4e5b2bfamr55195207b3.40.1755111525090;
        Wed, 13 Aug 2025 11:58:45 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71d6107d1a0sm812637b3.76.2025.08.13.11.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 11:58:44 -0700 (PDT)
Date: Wed, 13 Aug 2025 11:58:32 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Chris Li <chrisl@kernel.org>
cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
    Chengming Zhou <chengming.zhou@linux.dev>, 
    David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
    Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
In-Reply-To: <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
Message-ID: <2f75a76c-bdc1-6ca7-4438-21554831ec56@google.com>
References: <20250812170046.56468-1-sj@kernel.org> <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: t68f9aheewsn8br9z964c1fsrsrug6gj
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C9D9100009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755111526-340087
X-HE-Meta: U2FsdGVkX18tq/Qssj9khrOiN6RkKaL8LnhmW+i9eGurrBHPMBx/kwrvexcG76KIT2lh51oQ9YzSMBPJgs9u1AfH1sH2cdFR/Mo/FW4v0j9+XTUgvSJy/okeA33o8M4nxffyA4QAN5bL7jMu7J496BA6Nw7bsdqSvlg/Q4l0jKDM7+cCSOvkT6y45Z1Y17rTWpsEnWx4x76H6z06YQPkkcO0/9Wi7o6j6Ok8HzibROf043QH2N1vta8f9yjbNCgttAWKw6VwEK4v4bnWX8wQKgTY5axWJ30a1UkGfXH5u7VHFIZx7Q/Q7RBwXddbiZ0kvGstWB3dDZJyHWpBul7FjgYyBGSCal+QwsCM222dJdnImguQm8GpeJZYBKqwtXt9u/gc9Qaif0kWtwyMSrAsU53EOsiqBLxREKDdIHXp6UKox+49usGqn4H/oPtgWv93kMmz5QmkA6Frc1R7LCduMAxkPXl0Bl24bUzVEVlqCP0IeYbipqzxzgLZnAWdv14ytqQjf7d2bpXsIWtK/kFU/J797RTRtcIC5HDRgqEdyfqmyuubB8cXAGCzG75N1iixXnVZVvd8T0P4tbMxkbQqOBmA/J6lnM4UOtUSbd40YS8SsVYA3OReQOXueTH6XmKoGLd5wVyyr1pSO+CD5Os2BTCiWhkYxDfyTUNOG/Hp0fbm5pNzyiiUdNlbTHxBgKnPJwL7rGQnuI3QznjSw4GdlV70Kz+HIyDsloLeIsmxW7fI6gHJzrafA1WNt7yg921kIxwlGl2ZOFq5/exzt6Z9m5FxFTOhTPYZj3xjseDTGktKX2Ygeb42xhLMJeO1oeZEsm6UNT4V6L9m3LuVNmTsYBRvQveNYvixBqhjGmo8tGE8SpyFLcGcJkbRV3coGk2MikWLQZMbgKldO/PqioAKywdiemr3T0r1AIerRBPAxrfEgNkXhfvSIhaUTsPDv/Uj+vcnYGubm84I3NwG0y+
 6tmKFtoF
 9K4pyyyFczVOtiEQg7B4mFdNi+hoyqaEhrI2JDU5/umUwFpaUh0QR/qrHajYHqDet/inIR1lBgj3o50427GUren+fSdLWSS4H8dtScE3YrWFZnPIflkx+8GIWiYfHXDAvszw9p8ZgrIkV6EisyuG/f43dPbyREvjJyvBcFvpC+PC0WAmuRVZbg7mTOXtzZnA88zSrA5y0RrcsGMTJ5pBi612PCpduZfk/EhN9OnzIDbZ1YyATuB21C4WizLIIrA/iwSXN/ZYafWZ92hPhiH6chnqc93jyTSyWDJhSyjHcPRO8PZzNUCcP76Dg8cuRZNtILYur2J22PmjT6WspfVGSlrPMle/myWoEgacn5oR3bI+lFkBVEbJRjj9rPjPsjswkmCy0c7C4CgyxUo2WLTd8Of4Wa/FcTIjuGY3P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025, Chris Li wrote:
> 
> I know Hugh has some idea to store incompressible pages in the swap
> cache as well. Hugh?

No, I don't have any idea or plan to store incompressible pages in the
swap cache myself.  But yes, incompressible pages could well be "stored"
in the swap cache.

Hugh

