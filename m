Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54546C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 04:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8E26B008C; Mon, 20 Jul 2026 00:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489FB6B0092; Mon, 20 Jul 2026 00:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C676B0093; Mon, 20 Jul 2026 00:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F64C6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 00:37:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 925011C0A42
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:37:35 +0000 (UTC)
X-FDA: 85007896470.22.5C3AD27
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id A6F2A1A0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:37:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pR4fQ8BJ;
	spf=pass (imf19.hostedemail.com: domain of richardycc@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784522253;
	b=cdu6SfFr5ZLNOYGLnh1cww5KH6d1YCWEecHztTzBRqaig7XnSYKYxmrP7H4IajZ07mkg+5
	T6zYCiSokHXJSNljd683hR1nnbHwYMNh82Z9OeyfgF8AyYEowwXDtGe/u6WzqN3OWCRWDN
	kntPRhrYnqA0fLP7rwQxcwdbyTmSUSA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pR4fQ8BJ;
	spf=pass (imf19.hostedemail.com: domain of richardycc@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784522253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPiTUznDxpntDtckCtIqszjXCP85MKGrHtJrG3XhBBw=;
	b=CDFzv+SpAY3ay5Ey4SffAEK3Q7CrR0F0ADnBIYCjtaZsbZtyl/U01gLWC3dO3tTsh16zIj
	zfHM2ZCdkFV4kkNIGv1nwQdU+c3t4NeVcig1FFdm1dvwezjIYYcBYvm312YYp9Kf34rI77
	BoN+59GTSepprE9DtLqacXSlsMJE2/0=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so17865e87.1
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 21:37:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784522252; cv=none;
        d=google.com; s=arc-20260327;
        b=n6hjyQBxQMG86C5wjIIoeB6H00LKDaoFObRJuIrBc7G2X8/Q6WzQT5MTQimz/rvvuA
         ZZhE9+JU9U1tST+jQ/0cEa7z/G3sOAiUNYMKUZHBlMcuzxnxjVdeqf1Jsi0I1Zf2NWFR
         zkTFaxN9l4JNm3TTn3HuRHkl72wd822zTZVl7fYqJSTGis7mSj+R7eoOYiS7C+LUx++8
         c1G9vGDBiMcJTsmC258/PNonOzaROGGsKrsJUcbC4YEQ6nNxjVRKVRs1SyWzNR3wBxV+
         HgFLzaUwjMs4Vkx2xG7HCP7GzPBoKMQ1URyIl3Wvk33h+quCYFputjTvuCFsSYOhFM6t
         cPyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=rPiTUznDxpntDtckCtIqszjXCP85MKGrHtJrG3XhBBw=;
        fh=n5v2FKrJ/GLcpakl5MX61dp5o9HitkjDJ3lrFNu7Rkc=;
        b=YPFZgxnMdxgIEKySjtZoqVZR5guprgw7M/s31P3TH7PeTEownezWezrrIWxVHX84kH
         F7D2lUAY3VcvBkLxGIrStFX64LSulMEEF3YG6jdFfro5524HPUHw+k42esl4JQ5UZ+WU
         YY6s4yjAXLjIYfvWitIbG3kKgoP9I4FclHUiMKPJCZUX2F7+ZpaQHMszzVL/k3uMfyog
         /YY9zCAJr9BtS+1sfLEoSq0A0h8UGbiAmXx4uNjMSL4+HlbQpBgJjlfUEOzzie8K+E3y
         rAKJRr41iAfNg72M9xDMFMjKLhUqnfIA0/5/2yfJS1HYHc2p5V2r+QzGvthS9uZzKFdx
         Q2Hg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784522252; x=1785127052; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rPiTUznDxpntDtckCtIqszjXCP85MKGrHtJrG3XhBBw=;
        b=pR4fQ8BJgWSlHVGy4UPgeiDyipk2/cOxnvYUSwcZoBJqDLblKUXsgwV5kwwAqRK/jh
         C4wV9WjEnEQIVxXNshow3lbprtscs1ti1HNMKwUXzFFWNXFUGHCNxInvL76lsepJWWHF
         dKfUFOx1aJSuP1zKKajRe9lYjWJPuo9Hfl/ZXnTHDScCovFC3yOw2tPowfnIFlBHFoDs
         HppVquVJp6xEDqpdE1mVQ+bttvit/QUUlK2rzvL/ngw6+l0DV5JalypDZUFfE+oKBhN5
         0tPnjsEzTD5s3YhMn9DSy96vqxPMHG0TtXm0nFVv9OuaO0MW78la5moIxhP3yx69qFow
         VXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784522252; x=1785127052;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rPiTUznDxpntDtckCtIqszjXCP85MKGrHtJrG3XhBBw=;
        b=Uo+I+7oVcdI34bKMyWpdhXKYNEmyZTwi8RCHYRSafRCuNGtSRbo03hj6FCdpsFxc/Y
         OsYUwiMAGl+8/nELattefDuzaC+rJ077xJbOM19bIaQNQi69eSJTqMTCD7lK2UrE6HEC
         AkPe1agtTC21tx37Twh7aSGlr7gjI3u60rzjVicv+xmr8R6ERNkZIDXyGLINILgskWa4
         b7gXfOQGU4DG7Lcre7h4t4phT8CxZNL05R+cK/Ty7fvd+Nc65/KhXH2UahoU4Xwmimkp
         vUNOyL/lx1bLJFvzbsrrGSSNb53lNlXbZ9gWEwkbFmis2VSYv09QNJao/0Aql0Ln24Yy
         VU9Q==
X-Forwarded-Encrypted: i=1; AHgh+RpcgV8hHXIgrGmtsGePRh43mElq37kQIcYYsSflHuv+cmCWDkg6f3mmq+p/QP+J4zIldBzNxRi8ZQ==@kvack.org
X-Gm-Message-State: AOJu0YyFxgUhhLCJWeO7FSJ92TeDrUq7aV6xOFhi7fnvQGROhykSGvl9
	6Vtq52Yo9RXcRRbdlLNBXuTtGkcVXqqnivBqA0gmKAeuCUduEOs7pnrXUUTKqDTbLJu7BkihQN/
	bgFcNgOrjqLEkiR8aFkMvqQ6h7k90VFQwgID81us=
X-Gm-Gg: AfdE7cnKo8qyZRA8GPnebWXywkiYBWYTQnflQ2GNF2Q7yM15q3cBzxHjnKwrUJnDl6g
	cPQzqomHc6dGZ1z2wlOEiZjgAYKwfYgBTARbvEojy24lyJ+fRKI7ueYzDmWih5lpdC4RR4zkzk5
	uIOq4aG6qnMSJyPU0minYc4O42dGQHYz1NJPOBu3wsK/C6XhIW0jgeQCK0232EU706bbC8dkJzE
	QaMRm1avCEWSOrFwXJCEL/C0xXjI9eNLnIASqr0uV6/cFebPdjIsB2pprp3+N+JzR3zMmey7LSk
	S5nl4Gg7NzEuxMFxHLU=
X-Received: by 2002:a05:6512:3c89:b0:5a8:6646:d7b4 with SMTP id
 2adb3069b0e04-5b295397beemr166313e87.1.1784522251598; Sun, 19 Jul 2026
 21:37:31 -0700 (PDT)
MIME-Version: 1.0
References: <CALC_0q8ntqjCwC6CBN_0h_z9-_+pDp8-pqQgZ39O2s8ke==9cQ@mail.gmail.com>
 <20260717181252.2277818-1-richardycc@google.com> <alp4ud1b9aX6rmXo@redhat.com>
In-Reply-To: <alp4ud1b9aX6rmXo@redhat.com>
From: Richard Chang <richardycc@google.com>
Date: Mon, 20 Jul 2026 12:37:20 +0800
X-Gm-Features: AUfX_mzW2_la2KTBKTWduRFaUGRZ5gbvH3SkLK--D6vjKpCF5mVg8_98CM48u2w
Message-ID: <CALC_0q8rz7U-8x+syTFcWS6Nihxvzd00ruzOThb90P+cDqi=TA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Martin Liu <liumartin@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A6F2A1A0004
X-Stat-Signature: zt8oim5xhz48b37wsbr4ccsdkb9a6qmk
X-HE-Tag: 1784522253-825038
X-HE-Meta: U2FsdGVkX1+qJFzc+FCoWNlzjVlWwlT6BM2hXeAbKFA7WR/s17j3Z724xmMUqjJi7ZanjSdE/zdmvXIAb/4aZIhbwV2sqxhStLG1XLi9Wh9SwSR9oabu+EU4TXV269Fq5HdK8Qx0+iigR7mcniK2u8j52yhUVAh1zwFV26Px0ZuCU8giPaxpDYGel46c7JzlM2JjJigSLf9q3ZedMZ9FjoXKahiOUQKYNWgVEMHqxAQb/sWXXVaXGEtK3hzE9B3cQQpLXGDMjZ1ZCc1X6UyjwHSSHShLbDyndpO8cfFQ2ouxGZ2uFjTe0RfG3C53u8iABIXUur414eAOoCs80TUVHxZc/PY6ifOJK16hsJhkgXsXugtbW/H6KBsQ6XxGP1UymryPrTtnVXVqZnsBrQ8k9qK3Gvze5/B5TRd/7hDOo1NaHod8WN45i0TA6NRKMyLyZmSYfmpnNuPciAPMcdELCWoX42z4HLSSy1RbCdLKIcNU0quEMqce+OnZFC7rCPj6oQFsqAw5K+iF5t4VYua823jqTI1ao00oPvBOTlwak9xWqQ6yhMqnKIa3BwNwty3ZCArNAe115w2ymnFRS51q5p3lQZ4rCa5Ht3P8C/2/ulvTJ1/8yzDFpurBBnbNvYgkk7beRcYXNKasIAu7ZLl4Re2kPSkQukxuSFW+ofv7Pd+PxtpODuwCjnlgEnyrxpD0mss3kxwsXD0vzbimaEbeHf8yEyfspdyzqLLmM/UhKireenfbKyS7omPAGVg2RIU+yWUrl4yFnHgBgz7qwGX3vehzijLokjrUWJyNnfWXXqS1rIZNKdl16hA/RHKl9sOLVSkKu3spV4uGC3Skc6C5vtc7dSeZXkt172kNgtJZ4r1jrIRcVw3FUXPcVRLGb07C+Y1P5iiur7vEWV0JRwSj5/9PtNYIgqe1HvSTboiqB/h7gMBzDYwasYqtzTww/0aYmrCstGh+I34DL+7zN+K
 zgQEZ5ze
 YRV0W/PSbspEXPQBWhdS6K2v4KGUGx3xqY9/wulDomxQQTa+MuOluysBzbFRnwd+37Uz8vKxtrA+IhRdYxLzQMpgkHx8BKH7UbybPEAyQ0bUCR9RnkHfe+WCkm6HvE75e8Agx18ltzvfGO5x/UalWDIw6vLbwIY8KEMF3gfE4iGX+IcFWyiAdfGmmjM9LD2OZwl3yZpCn7oD12IbpmuBm/2ztdM9Jwc0k0hJj6TtNAV/iLgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oleg,

You are right, and this is a great catch.
I am updating v4 to accurately reflect the `SA_RESTART` semantics.
Thanks!

