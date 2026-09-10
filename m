Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B787AC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9FD46B0095; Thu, 10 Sep 2026 13:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A770A6B0096; Thu, 10 Sep 2026 13:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D396B0098; Thu, 10 Sep 2026 13:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F67C6B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:57:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA4B01605F5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:57:55 +0000 (UTC)
X-FDA: 85198610910.25.FAAFDB2
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id B3A6F100003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:57:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OegIkFJV;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789063073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=chDs8kh1zdBwjxwYSwuG6A9ObdHaGIGSIO2PG5Q5Fkw=;
	b=GtCjfvIaEOF6YnHG4u6kTSZOcebi7dbyh+ulFue3hlhlzRsQinruLxZpehMtTahxrFsvrk
	IemhSA01gOSuzQIrfLlZTkW8Gv1J0DBCKOTnVUbOGCmB3t2UeytMFX+0HHvqRy78Rqk6+S
	vq7o1YIzNulS5zPhl14CWzAN0aorhpk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789063073;
	b=5NiVWfXtsJcM75qJHWNd3lf2tHKV/xit8SP9p+ysRliqes8tiRcKVtO9qp3dPPaV+IGi5c
	e+R7Poucw27m7CHRHyx6OYeIRkRHXMxPAmXsjzTN9mYBIRhzNs1n0Ib7sc8keGEda2fu69
	FFYYY23uK2d2eIMYc98paBvGGZ3M8gA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OegIkFJV;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-485888b3c3dso8623f8f.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:57:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789063072; cv=none;
        d=google.com; s=arc-20260327;
        b=nUCrXMRUe4nIMrq2KucR2uJFTu/eSPzoK9Cj3rW9xCG+eivtpunJA5qNTED1hv1On7
         cn3wJP/W9WwZluHVh5RovtxtwtG1/cErom8uthCholxO2ngKJqo7naL+ENWG9ipFp31J
         o7YDbI7jO9whILIdGbO7zUXX7CywGdZhYxfOxE08BtowqnQsk8okAR16Y0SOzDzdLepX
         QZ/SimsKETFG1uza/7e2Lq5EpXMbs7gdh8D0Jfw3p26lyw1B78itMzGCP7FKVdwNkEzy
         SVr56VINS+TCwaAdR1JV25YJzVU6Pl3jhMz97dRiXpBp9nlc+fdLhgxBVCdxgGYWj0sd
         bSFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=chDs8kh1zdBwjxwYSwuG6A9ObdHaGIGSIO2PG5Q5Fkw=;
        fh=Ey1W1oUkrcDmwWiUIyiXarGRap838XmVys0KxU+1/DI=;
        b=KC2ZzoI4kO9S8rorRlvJDXoXhr8fR/oWUdhKXSE67QXCU5VrO2qnAwv4ejua/4jnYW
         yh0+BUkLciE1eO6aF08geR9WtTATh3CoVdRrU+87M3Hm80mqV+85VI7NZx95inlkUHpt
         yocJFxHSeKUaXmH8nq8UaBVjbvXmbfJuxXxGC60WnRbUhQtYp9neQE93bN04z/nAVn++
         /9O+RwY85A6Vgov1YxL5/oNvzP/BF/44uHN0FyRI8C+cAG3LKbFluLA2iFd+WL5hI9r8
         f3Ot4BowBTtfpOgx5dtnSZjTAATNcoqVT0c8tmEObzseg1obIyOisv9jy/NMJLFQcps+
         xsng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789063072; x=1789667872; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=chDs8kh1zdBwjxwYSwuG6A9ObdHaGIGSIO2PG5Q5Fkw=;
        b=OegIkFJVigABHGKzz9pODr+CdBc3V4kjdabYoKdd1SsWiHB2W2p5+3Mw+fCvNIldAy
         AKAvQDUoHx2W+1NsSbqeQCDa4kEBF7F/XTWjsSGrdTkk4sUT+9XvRow9bEL5JIPvg/0q
         7aaeOttNPUIxsE+9KV0qYjNo7fsI9TwW/tqTXshcorsqhSa/pfTmh8CLoJ5GTeOug3Bn
         IJFNUF4TRnfN7rKibYfgyZuMv+5invxRE9khd58mX5cWOmJ7tk+qqO1zUpywoSjpp/+O
         2tAl2Hed05AEBHlIrv1Q73nLfAleck2Tw5SfSzLJ9r7VUbdvcvR0nLuwJeXj/3XBbdZp
         3drg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789063072; x=1789667872;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=chDs8kh1zdBwjxwYSwuG6A9ObdHaGIGSIO2PG5Q5Fkw=;
        b=R6Yh/lfRsf9LBrdjmZ9WCBUuUOnvAjuzcIbk/TAov0alL6ZI0gnFNmLdII/LSysUOr
         zbQGnk8PYP0RBMS/XKEBOaFt2UGBfonqcBminqkm5L4j47tTxqtm0MUXLtvYA+Qj/mEF
         xxnahO27Cb6m2taato5tUCb07B6F6Ij5p8105lm1DxpzhKD3IPHM4ylBrUNXkoK03SP/
         /8bSKzlbfspG71dlxLMYAfA8aKKkQ5oRLYsErNhEwn6msmlegv3evxR8qQojU5BMlSNh
         b4NVWgdQE4JY+RiTHjc//xKzag8Dyb/BCh5OI3/4xJG/mPCbY01x1Cl72wav1FKp1P3o
         J6hw==
X-Forwarded-Encrypted: i=1; AKwUvBx6/vdDAuF14EBanUWibnlJqtEPIoBKr2+kjKFBBqT4ZRPZ7qCcwbOHLmynYDahkDcKqwZPP6OBmw==@kvack.org
X-Gm-Message-State: AFuF++kz7oiFjTFZSMg//edGgLHAZWYha+I13xSEqs7cIu9VcV8/kQ9F
	StEWi6PXFKWnTcM4c15y57ujruJuz3qni/K+5NZnTSTp96KgvUwcRA85YBbqlR0vZDgdWpmoepp
	xzO2IkrkCnh1/ZrE7sH1r7d+PdRKdnaU=
X-Gm-Gg: AYBFou1vSCFKPLGhDGkT/tQKs3XhzekVdPbsciY69zUQslovQ4HKWnS2Iisjw9hg833
	8ihOWth1ZiYGYgiSStT+sE3/g7pQ1fgO5tUPZQeyXbpjEpusya9sFNEdDjTa17nIntebd4Fffdz
	S2w4hoeXP+3dU0P9CcPbZTjHND+yr5tAkAn0hG+EUsYla9ukB63L/WFVbJcUFppFoEkPYXShRJF
	EGO9e6HDw6CVgemjNYl2J71Vb52cTZ4gGK+TCO/zFlhBNdUq0FxwshYoh7/hIC9qpfaTN63d1er
	21vijsah5jBvyL7l5Z+mTjKYgkjFOknC8e6NO6GNz6uaSZw0K3FaN4dwziX7swd4EG6HoRH+O7w
	9ZvpEu6R8aolgOHu4DN1nSg==
X-Received: by 2002:a05:6000:4008:b0:485:8c16:5ef2 with SMTP id
 ffacd0b85a97d-486eb308b39mr157710f8f.44.1789063071921; Thu, 10 Sep 2026
 10:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com> <20260910095449.715183-2-wangkefeng.wang@huawei.com>
In-Reply-To: <20260910095449.715183-2-wangkefeng.wang@huawei.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 10 Sep 2026 10:57:39 -0700
X-Gm-Features: AcwNN1VBw2jygdZBjlLk001WX_5VBekB3m3SmhzarXKErHk8VuLz1nYnj5r1kJo
Message-ID: <CAKEwX=NyZSagZq4HNP76qu4-zQEtmCmAKszY7_=L9-ad7qfHvg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: zswap: pass type and offset to
 zswap_invalidate() directly
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B3A6F100003
X-Stat-Signature: 1c8f3p85dfhamr3j6awzjihzbyfz4ijw
X-Rspam-User: 
X-HE-Tag: 1789063073-871200
X-HE-Meta: U2FsdGVkX1/XclVHe7ikrUJZBJvzDTboHlwe6v0zEdLoEtqCwpOSAIneO+wJpjnU2RwJT4yDRgVCxWaYnzLzAUo0wch243q8OIemrL05p90LHn6foNzxxDk5+4TyNxD3lbSMyP32WAfNJ7h+eHiv0OyNbQTx7Em5fWfFLp+GQQ8y/keGFIAOTAHdEqlIvyOTZzGLz3BJfGhgpR+ueNOSFAKIWmfvHDxQL1+ErhUCXbZh3b38IvfK4SQh6g24ksiA30C5QflFG/wR7DU747jFJgi5ftAyF8BSCaxMgBKQ/JYIpfQUjniI0VsdMDpuQy6BjmfBzIz0AAv1N67yeVg4T8l8SUbbyx3/pifIsOX3T9T0ADN0bIyDhAitAI7EmIas0AKXnNchGpL1C7IIjO5v5HEdPdM38Qdjo1XAnuB4oSB7+pGXP9VtxoDgWjvJgMFBo5pep1xjJs0VTUIfKn/FPRf/CQPmRZSYZaKiaFkUG8pEn95z4wkJRcO6a4jZYaqVe3WCuWY64lZy+nbeH2GkxxVbDwZ0k91y1gu0kzsCf4LyXzrwsXCeJSTksVWYgamIHNxIIfjL9rJ4hfvbs2krXnHuSp+cex9e0ZHSJfb7xFxXfte14uxYJcP4ZVUBOc/4RE5mySlxTbvt0Z0KZDOA6kowqkfAt3BHozGaGaAHDcgHT4JP+DhIkDNgjIVAVDjoH2ACiPOYPnxXZS2agxqlH7OxRM4wVpkYM9+2OnDoyAL6VC2FsR0LnsIB3VzOXESdz49XOLDS4iohLZSxfZ0y6vQJSUOnd1Fo00nXZfJ4LBxcwZgQf/CG+S4CzsfVryFtHcnwi261bpHEmJLnzBpwbO89DO70cLYOJ/CU3aNvYi2AcI7MIvUxrvYUPBSiP5GnQun8La+wCwtmQzfP2kL+qKZFEgcbDgyRlK2avhoD6Gap2E0hmVnOOQnVfduf9VLPb3KHmOep879IwdYxd/o
 bP5XHpWf
 6f0wCC4l3ywD5+xmHxsMjzZjXlDGNCcmWi4k+U/SiTcuXDLFnDn9L1rvvrqXaItgMNMdE6EsHmDvZ6FeLCbR4JdhFUrWGsoq8bApWNSsTDTUfyLKrRY9SXvSjZLpYdQCSSNgAZkgMT7kSc7GOaC7OTRXnvL/0GjJMlr54UO8G/BYJC9mWJfpc8Dco3e1z9ViAtwfjoYqAKI1oIblD5iA6oqYoIIDfQuKde0QlYRu97BAhTYos4RJQ56YVtiZcrldeaMdYTESi8IZyVEEpdEhhfw4IZi61nfbC+yvCpRqukaMgPsxH7XdCphvSeKjS5W0j6Z28PdYv/uDf+d6h9LRtC/kZAF3bDW5ADwLpzLbk/tWvZrRaWGEz1o/lTrDmITNrldE+vRLL4It/8OWAhDGdvLUmjByRIs4n3N+Zane20LNRfBgHqkSL6n4vjdslFH1AAE2+drle99WnDeakeYYobg3JI4cUxQxlfcNQOfB/WpNJZ3Md0ZTfK9g+8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 2:54=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
> zswap_invalidate() takes a swp_entry_t only to unpack it right back
> into type and offset.  Both callers already have those values, so
> pass them directly and drop the swp_entry()/swp_type()/swp_offset()
> round-trip.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

