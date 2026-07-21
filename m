Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC3FC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492D86B0093; Tue, 21 Jul 2026 14:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443BE6B0095; Tue, 21 Jul 2026 14:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E61D6B0099; Tue, 21 Jul 2026 14:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03D336B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:17:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77F7716023A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:17:51 +0000 (UTC)
X-FDA: 85013592342.20.674E22D
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id A814AA0016
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:17:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DgM6LoKv;
	spf=pass (imf25.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784657869;
	b=e9XdRLxxR5FHDDnfzEUqSu7l41CpenogIBGANdzflr7skWkcW0zWuSMeKBoAQJco5S5FFr
	zfw2DNGUwQbK++RKNSJIdG1njqa1666eZ02Q1vOHSG/fmIcGYgQ48unyEFcocYc5s5AGvE
	E/2d4uDQ3t8dxpq/wwzraeCHhNKr0kE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DgM6LoKv;
	spf=pass (imf25.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784657869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jqLDltTJbUvwEIP0udTW108q5ygNeFApM+0PrI1Yp4=;
	b=Q+T7LkInzgq/YNV1NHg3rGsLyj/JfYW+BIcIBraCkx1+PDnrUpOfee3KyCAE4zTOThtl8z
	v/iwaKOUFZI6eZGQCjzkKHYw78zs/t0+RWYvUwSlt4CQ3EmjUQJWHIj3MXrRIQ7NRL0KTf
	bxTWjfg2bmCeDpsJZrUK3KmdxLiCrdk=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so89538355e9.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784657868; x=1785262668; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/jqLDltTJbUvwEIP0udTW108q5ygNeFApM+0PrI1Yp4=;
        b=DgM6LoKvhzutm1YM5cBXw4d5SelaaZxoFNuf5HCr9VQjYe2oEKOMjUNI/wnL+tSLvX
         Q9q9IqMAqY/DliP3wXd4dDpd7wwYO7N5obNQFbLfKt9KfJ5ITe1TAa2Sk0J5b5p0P/hI
         B9C/dXJsxcDruutBQ42efV+icTipV8w4zsWm/hE6EVNIB3ila0L30232aFxh+TbLOc0G
         skf3BQvuzu/mery2Dx3ZjS21mX3QLjPzadGQ0mP6wUx1kgAUdWHh1WfVjeZ4WNuc7gL0
         F+S1cRb1HnQfvyVq3YVUsS+Iv3TtIj9zUiOPXYoJEnQzdVl/AH3tZ62Z+3fPc7+AacH0
         3cLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784657868; x=1785262668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/jqLDltTJbUvwEIP0udTW108q5ygNeFApM+0PrI1Yp4=;
        b=CC/DpV9GQgnSfYwnzZdy822JrRf4ZV9uCXb6LZysEx2K73v/se9taIGGl/2mNi9w1S
         W9QlwKAoYaq/nvvKGLKbNUkfTqt+UfPpUIcYVUtYal//Y8TofhdFlJklRFeAlxjKQHFT
         CsqZRDTIa0kZ0+YoVSTR5p5z5f6gOGPd7RI03pk0L3Z17A5OYYnKxR0KRQe0gLBzX2bv
         WoX8ix387eB1BpdKxhJQ8pmK6Dkfslp3XUqiDAAKG28OBlreRPMOFCYsUFUkkdkEpx7/
         UjF6rOH/SIo6zoW5MlYEHPfdckJyznkH1Jwb/HcEjangbj5Wxa4InRf5d9gYl7/0u/wu
         L9KQ==
X-Forwarded-Encrypted: i=1; AHgh+RqtTkUKeGJvgGYzIinZD0G67yBVlGfdFIJy/n+0Z73A5AxrtXfqqx/LpVtznMPV2DBEvuvoCcBlpw==@kvack.org
X-Gm-Message-State: AOJu0Ywh+IX7GH4TI/wMc0NCISGMMuxCVlDQa7bURZh7bV7NmCOvrPzf
	n8X9sBjgMb7TOe6i8+Tv0tGBvaiX+wTSK+a7Ai4v5tw2r1rOQjHSSnXF
X-Gm-Gg: AfdE7clH0EyyD19TDwh67EMOL+Es8wG5L/XEjcw60yVoLjBkqwsYzwI1Kuff+bOrbm8
	wgmdg8tIqNCH8KMQ7Rsnd5rs4URKnYPgZvdX+Pn1EY+YVNWHiSo4yf/NLhg7qIIOHFj43/uxTeI
	xcsS4WkERhWts7SqzUydeKlfEZTbQO+rqBm7wcsKOMCfAfqtDjKiGfHV0DCIdi45MxaLLbbfK4p
	AAH2bjv4qf9uTvM9Z/oBBKhFKp944Cyv6QE1aEwXImYlJkFx0J3njxi/2wCK22NFklayJnaGrhZ
	wJys0Z8E1NnUrtRUj9C50DBgc57uHTmGWRii7uYFXJcdYmaM2Gcu16alxtwNX1HDjfZmMbuJKpz
	BA0bBO4fRj/Tvq1Azyn9J3IyUFnfliXATHSuJGivUkvk/KgLs8gLjxvxELbOddRtHnrMFdwQcpi
	IG39D0ANwPrc9xozIHGI/WKYw8oUoK5HzvpO8RB9vnuAUltc0dp+oRIC21Cg6kyQ==
X-Received: by 2002:a05:600c:3515:b0:495:5b4a:53c9 with SMTP id 5b1f17b1804b1-4955b95bfbbmr117595275e9.39.1784657867969;
        Tue, 21 Jul 2026 11:17:47 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63eddd27sm41048235f8f.28.2026.07.21.11.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 11:17:47 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: baohua@kernel.org
Cc: jiangwenxiaomi@gmail.com,
	dev.jain@arm.com,
	david@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	David Carlier <devnexen@gmail.com>
Subject: Re: [PATCH v7 2/7] arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE
Date: Tue, 21 Jul 2026 19:17:29 +0100
Message-ID: <20260721181729.305137-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715120813.3609949-3-jiangwen6@xiaomi.com>
References: <20260715120813.3609949-3-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rjn9okzso3mwgy7fhd1abza7iq6km65n
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A814AA0016
X-Rspam-User: 
X-HE-Tag: 1784657869-473619
X-HE-Meta: U2FsdGVkX18EuNRF9qWUh295HJIjNx+q/C9TXPU0lUPyxfmCht34I8PtXolO6zljR+lI2nvvhXJgowRum6spvrnbYo1JibWjpEVwbok0CvhNrf3i8JMwHEyU1kn7HVA00tmKL6B43Vuh+9GUNhraffOne1frztxoFPEv3tyH8ist8FVgvB0u6xeiF8gFTxqzO6DpgZ04nv2OmjVJ03CMF62MTHxI5x+v6i/pkbxmvoV/aRIHrzRwrJx/aR/ITQv7w//ai2kxFEk5HTqhG3VVq/F02Tyxx+8ihu+aHC0Ed02Vhl164Wc5+mAadHxb/2b87vuBe1jiZUCGAV+ztAokb4Gftqw5y+4hntCBORTH3NhPyi4/wlKDAuFkWwy55q4ZwmFyR1sJsJw8RPL7WKNCb6LAkiSRhbRDPtWThxaSbhRO2EvsqymPGcZLpU7+qw9XCcoI40z/o5hhfZsMJMs9IBHa/n/hpiqy+px4r+Sh6uBNYIzlyu+PCEW6UR60I8FNzUGp0I9w1N06IIUyRW9RruyV/4/z3OIXvq79SNFU8xK23K/LFgO1etjAcU5dtpzTet9EynuLRqf5UAzIz4LXD+8R0rppwWoGpyzjtfXZ1IwRxwfQlXUqNdJ1g/w3BarZL5CKf6COz2LufulD5FXrHQ/lNwWiXdXXB0rxyFNEfbYDa4vHpt+KKq9mfytDoPBpI+PZVnzguSrgIofAUoGWu8P03OZwUSly8jlV332sJs6VPERqvB7smJ0CrftlOiBVAXcutECmVg/2xWJE/UQk2ifCargnM1EGRrMe9R4O8xo6HpRJKB7iPsfM4niHq2aMQ0RR50/FwJtnlmbbUz8v84pyYoCkkEPMRXFGd6m6yq/rT//SmCnIFih5tAbBv1eW/qYPXEhcxGYfPe76uWQQa2W7XIoPTqOgTY9AF82qXuPxoQlQNqjoptVRDN5c4TYr4MS0YBq8lAiJnJqTnHB
 epcIMqQ1
 CwB439G0uXlJp2NQ4/6HhHRoReJ2voDyUsKT3EXTCxY2vZ1FPRgoaXYXSTIPAxhhWKab1GL967Z9w1OdDQgGco0/lfySZ0XyZEVU/KZjJJS7Z8aw0vi3Wlo5wqnmKqwU6UuBhuq9Bt2BEizOyN5vAkD90I4ztJOO0v7O7Bet1pvJHDaEDX+GjOBXInxhmvT8e5khAFDSoPMncf+SQfX8mK9w/Lv+MT/VUPDYKjP7rElVcsVkHD86Ct4tqM4Nr9z8/MgJ0l7i+JjOezPvEPNK0kzxoe9yLjQxUC71wc+wmLUxgmYMzElTTrU00+2CEAz9Ny4PEEUsn0Duz5WYkExn14oGI7Vrz5FUG0lgrhuh8iYYBoKeXkJmLsR3I00NCp7b6QzpsKLCwetbx4L9AtHzpmdlWEtg5ZNC0a0/cq1rKFiwFh8tefEkwGZq4fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry, Wen - the returned span is capped at PMD_SIZE >> 1 but only
checked for CONT_PTE_SIZE alignment. In the batched vmap() path pages
are only contiguous within a naturally aligned block, so when a PMD
boundary splits a batch the next region starts mid block and the span
runs past the contiguous run - set_huge_pte_at() maps the wrong pages,
tail of the array left unmapped, no warning.

What do you think of clamping the span to the pfn physical alignment,
like 8xx does:

	while (!IS_ALIGNED(PFN_PHYS(pfn), size))
		size >>= 1;

Cheers.

