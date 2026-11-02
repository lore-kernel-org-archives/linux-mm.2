Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3209606EEA1
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=Ne3wYAR2
Received: by kanga.kvack.org (Postfix)
	id 258B96B05BD; Mon,  2 Nov 2026 14:16:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208B36B05C6; Mon,  2 Nov 2026 14:16:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F606B05C7; Mon,  2 Nov 2026 14:16:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E14EB6B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:16:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05DB6A01B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:16:10 +0000 (UTC)
X-FDA: 85391134500.22.D673DD2
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id D0458C000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:16:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Ne3wYAR2;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793646968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSwUt1ejfmZqGDfLTWVnhEyPBYCa77Ql8jnQXRCQM2M=;
	b=ju5W9z0oqk/84P9uMajs1KrpSFG6JFzu1t1gxWAgCypbRToQO3CmhZ9ECp+I1bsDzpc6q4
	eBJDBug37+miZCU9kFhBcmNgyEGEUVmW4Vkfz0KRhUV4LLRMDGQKiTO6vRhEx04/Sv1Y1f
	6bvZFDiUjhZdc139YR2PzX/jj1UH5Ok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793646968;
	b=lgcMj10eaxCTbrglCzYj1pN6pUW2JDwYbXeSyyxzBFwial9cJFwUK05H97EQIbNI8//Rhi
	r6N2S5BeX8TNHtq18iSej3mgDk1ymqN2DWpbfuooxOSOta9Z1XwBPTo6mz8SLtjmFxLOsS
	5y1qsl/bHQuVIran95zBUruflrstf50=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Ne3wYAR2;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8ad98c3fb15so28786107b3.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 11:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793646967; x=1794251767; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xSwUt1ejfmZqGDfLTWVnhEyPBYCa77Ql8jnQXRCQM2M=;
        b=Ne3wYAR2MQ52MawU1m4B9RWRn9sJbIUT7ZPE+bap8uJ85GtyXlbSw+HxhpRHf78yor
         z8Qjs5djZo6CWimbikWOVWf7dmyep+UEIhC16A6AAYl4AclN4dgfVkdeeZiT0xWbVjJS
         hyCoX8Vpg7lYidLPDg8M4ZwpnZTcjKNz5ndXkKPugQRgYkqClEhCkrVqoC76c11bzib8
         3TUcFokvZhn9lRTUCreqyGfXjlJH8emz2QQcPrPnfEIJ8UAJThXhMQ0ge1GlKqHLgNd1
         57FBic+IqoSLxhVOg9Fp5ZSYGBrK4Y2YHDek9mx+prsgyguTd4DJ/gqC7MLUKqq4Caz0
         yBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793646967; x=1794251767;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xSwUt1ejfmZqGDfLTWVnhEyPBYCa77Ql8jnQXRCQM2M=;
        b=hIcbneVy+lRtkGu7sGMkbB3lRI0GluQGijcbnoC6Dh+nvudGFB+n6PmXnrbpQlcm3B
         Wt+B7nZMah1ewn/qlWBcGVD8o4LyuBSm54bwsYyWF1KGAFJDxKDGaoXavTsF6/CgDE9j
         27Nz9BLq8uDrv0AbLEoFJt01XDmLj2mBO98rThfGs+Sag3dm4ux3QpNSFeWQsbTtFhDf
         xgOGDRR/BE34t0Bpv/O0lTplQF/PzzdoS9cND5PRlDWxW3BK/bXMfC0swvoUeV/UKWxR
         3JptF7AHrr0i6bVdPT9KCXpeWe6gMP0WgO72UyHBqq+wBsCA3KWOnSzM7/Q7AhQK4bbG
         svKQ==
X-Forwarded-Encrypted: i=1; AKwUvBwYlV2niVQHdyMAxWf+KcXXp/uQPulmBzyibhygbd044/JyLSYM4RXmDTk3D5+kAbohe6n3Iy0Jeg==@kvack.org
X-Gm-Message-State: APuU4Z9k4BMyVjkRcUt0i+AUPJEh5Z3PQnI13L9WN2n8V/ZZ6wbXMT2t
	MpOc4KbRRzjPzmYLzRwLGRgberbUdp+Kiv+V0Bwe1nvaxm+DHvJigbwuiVRZ6NWx0M0=
X-Gm-Gg: AYBFou0iEYUjQ+H5wzJl65okMycbnQLx/VXfTLWmpi+bEVrpOAPFoo/zTS4IOswBPYm
	B6vRlIuVCEeGQmO6D3GFRQsijBCANgP+qkqPOjtVC0i6UgostInozGgNQ+o80u4ns3Ozf8X14Du
	Oyb2cFyd3SvY7/tnMSZnXKAr+MRIvAKPu4Nd8EyaD/HT5RM7Rp16/A/L8wEuubExt48PCHZlxZ+
	2tg5mBVIO7a1U/9mjfyeDVReuADFolfNB7zcP7md9mil3qTF+qMwwiPezzJm7H0I04tPpuZc0vC
	Em3WHuK42np32lkoFZXyE92GJNV6gkAhG4sI1E2pvTsQrZXY1JphnnxvMZjCwjAJZVwTPQBWxSp
	vYDSlUc9xqDP+2x7RYnnpn5GU6MoHFO8ByK5PomUo+xokMpjxL2uEbpq6a5kJTtejIel95U/+D2
	mzw/ZUY2IBNiRilcQLXKqrYFgKCtTgJACvOQib53RNv2XwSaKQgDVi8L2DAvFEKYGgzqCcBJkvb
	CSbgcE42C69GklSihP2iccXAbBVeR1JaoeGifji7aiE0Wbb6gyC2CQbtpkTwit7cak5mCCWQI9m
	KvVaEEsn/Ho6eSdasfFFS+md02C+/YqBwhvn0XRaYMrbsgwg
X-Received: by 2002:a05:690e:191a:b0:67b:9a76:cd0b with SMTP id 956f58d0204a3-67ba4edd88fmr8834059d50.28.1793646966752;
        Mon, 02 Nov 2026 11:16:06 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67baf147246sm5737296d50.1.2026.11.02.11.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 11:16:00 -0800 (PST)
Date: Mon, 2 Nov 2026 14:15:52 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tao Cui <cui.tao@linux.dev>, Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <aujhaEfimB0S5Msu@cmpxchg.org>
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
 <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
 <32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev>
 <7ia41p9341lv.fsf@castle.c.googlers.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ia41p9341lv.fsf@castle.c.googlers.com>
X-Stat-Signature: 74audj1gywjq3enqf46rzf8iys5yyf5y
X-Rspamd-Queue-Id: D0458C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793646967-729430
X-HE-Meta: U2FsdGVkX1/Q0IqnjHtAwOZAMARk+1bDZJYuoPOYtUnZcY254NWDI8b3xmuYVfQ8MYQf8mxYD9hGv5lLtT+A6uCgshLlEEmyuzc2FsVOW6ClSX0nm0HF1oFC3qBRaCAOSTtnqxcwPoWBt6Uu8wgTKjddpqxGFN5MBe3cNALa86FsmMukZUerPKC0obftw/0W3ByW305TIpzhMbg46vC7CZj8xjgN5EK4W6LxeBh1MQPC0k5rnDdE6cInF2g5p3K8Wk1nNsYqj8axPJDw57DzTFUW5oGl2nKb31Rg9xnHKhlSFirpLfb+gUn+1dnh9u95B2PYXdbscY7fPJ0SFGPSpkT9NasB8aKsWfuyqYj4uQFNv1SUp1qNDpQtQtHT0OEKd7t/cvJCsT7q2iI7Ae3FdXXB6l2H59CRRGssuA4HiF64Wl1ORePGa3wXdfWlBNTnLeOfPDv4KTkDvR2LlapQ43MbAH+quTDhLfCUng+DIF49RJbwYs2ZzmY7Erg0YREUquK0pYJ3WAB91kWO+YhjvMYjP6qLGfTYfIBImf8WN9q8oVYNtz0LQolAGE7vL/+LG8pXVp/fCBTTko50g5bd+ESmjiGdkfds9oSY9aU4QU/49Pa7eWZDfIq1R14+VFaqI2oED3ZliUerAs6fKDSSMUB+YWsBSgAtFlmn1ruc8P8CGOeaFZmGTL3+bu+yd9gn06ZBZyOSz7jM1/3xj37pPzNrDhERAjCH0r72+aMcfH84cMpQf8K/oL3p9cC8KMmr2ZbAg1VtfM2IKT1eq3pn4d60VKti6wlE48LROI2Z6fp+vQoTUG55NWnPQtHYGNP8Ix4s3VHokI70zDyH0TVenBM0pgYIHSRMGyV5BwMQw2KJJSycRpsmfGjbEOY2VlspPb3YPep8sNMcleCMpDg+WjwJG6GJVFQ8O6vtr9JEvaOvFcGqr85toRxcEJ5F+2xwdScfRXL5/9+yU0AmLfb
 mQIOQIah
 aRnWxStw0uVcILWl02arOlDWu/2pcw3FeNx3FXYI0l2nJJE2qfwHZXDQnnznvcID60pr7hYVb7migsvnkoSQSEe9mMckr+2tpUXFjOvVBMQd37OroVBpcbeh30PRqrUti/+rCjUYcg7OgJ0l/80eaBcum+LUwRK6KdWEKlde5gbUe0BmVq1v8Kx81U8fodU2r9ntJBf2NTMlTLC66mMLLtrfqeFAjsPJ0tn5pV0o14zrliBwSVg0ArtWBELvMI3xzw5O0O+uE6aDKAuN9DPO5SfYN3PDBWiAuhPWrE4Xx2BLqrtrjAheLQM3L2a8yims3gu8vkmssrLbsh61LXPOswz1sgANFjYU6EkVDU2xzRbQ8p6yx+6IzabhCiJ/9yWHGfFzqmMOByFZH+C/s4+B/c6w8dl0Eo+plDI45e5IRs38njqrSC6u5iBauChaFTEEgb4DBK5gi9Rao3Gu4SLPYrnhO6quvGYfjYfZJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 04:52:44PM +0000, Roman Gushchin wrote:
> Tao Cui <cui.tao@linux.dev> writes:
> 
> > Hi Roman,
> >
> > 在 2026/10/30 14:05, Roman Gushchin 写道:
> >> I believe we want to delete this code sooner than later, why would we rewrite it before that?
> >> 
> >
> > My assumption was that v1 would still be maintained for some time
> > before its eventual removal, and the goal was to reduce the coupling
> > between the remaining v1 code and the shared core structures during
> > that period, rather than to rewrite the implementation for its own
> > sake.
> 
> I understand. But personally I don't see big issues with the current
> code caused by the v1 stuff. Maybe I miss something...
> 
> The proposed changes on the other hand create difficulties for those
> who use v1 and maintain some local changes or simple backport upstream
> fixes. Of course, it's not a reason to not change the upstream code if
> it's justified, but in this case I'm hardly convinced.
> 
> > If the expectation is that the remaining v1 implementation will be
> > removed in the near future, then I agree this work becomes much harder
> > to justify.
> >
> > Am I being too optimistic about how long the remaining v1 code is
> > expected to stay around?
> 
> Well, Idk, it was considered deprecated for quite some time already,
> so maybe announcing that it will be deleted in a year is reasonable?

That might be tougher for v1 users than the member placement :-)

My understanding is that there are still a few heavy v1 users out
there. I'm not sure they can move within that timeframe. Personally I
think the cost of the v1 code now is kind of negligible now?

> Shakeel, Johannes, Michal, wdyt?

I was a weak yes on Tao's patch. Happy to keep it out with you and
Michal not being fans of it.

