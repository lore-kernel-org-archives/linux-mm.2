Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B61C8C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC176B0099; Tue, 28 Jul 2026 11:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C0E6B00A3; Tue, 28 Jul 2026 11:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F846B00A4; Tue, 28 Jul 2026 11:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5342D6B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:54:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC57D1A03D3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:54:38 +0000 (UTC)
X-FDA: 85038633036.10.31C078C
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id C2575C0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:54:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hERqnDiP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785254076;
	b=nz4Wr8Zau8fn9fInEQRrxAN24ii++sXJuUmq4ykjPxNRui628pOHmyLBgkXcSAOLVKg6A7
	vCrM4sAHb9ubApk/epg4iiTqMp65B//fTE6RmEGy/QY6JZxbGSdwep45HQaajsKaivrLgA
	wYZxKYCHOdw//yFIhMpWEsU+qPLNlWk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hERqnDiP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785254076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBsfXxp655wnJEMHI9WpUa0JDeWDZ1N+76VJg9u87E8=;
	b=Hz5X3KBwyV3PPJBCQBj77i6quuG6aaREkSRbY9W+glYRDQHk7Uk3ZcsH0qU2d3yqb+9NYS
	BghwsYui/clCLnAnKQ3qI3EwX/QO82PHdkIT5m2HwNLkdV9W2ZSXsID065+FWbZc7buxbP
	11J5jFhidmXsIV9xs83dMzH6mYBMa0U=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so26683f8f.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:54:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785254075; cv=none;
        d=google.com; s=arc-20260327;
        b=eItxN1g2vZ7GpDCA8jqT2ipPB4+bU+YZdrsX9f1Qs4JVV11c9RiCGV6FGgiXE/Q9FL
         6tUIwUmatAlLHd8LUju25jqrbWmCpCNazu0BprBIG5gjVNxIY+uPDvuwNSDGfQxZYkzU
         oM+KgKbFY8MnTGSK74FVDR19uGm63AMvYfDWy/F7xTX/1EInMnuvzrkyxlKEP/XcZctb
         DxnNzubPO02Yqt/otVl929Yy3e6T545JYloFtUuFj2pEANz5dnMkHtVOnPaQ2jxWKcGG
         Ga4yt78vC5CM1OjIEHMC9UN92qvQe41x89k/PwT0Se7Hm3+17VHayxY9F1xqsTyrAykF
         ghVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FBsfXxp655wnJEMHI9WpUa0JDeWDZ1N+76VJg9u87E8=;
        fh=5Fo5wBnw/zPTmn2dO7C9WX1AeRyrqEjIw6HEZG6WKLE=;
        b=hPlgYT1ntl8kLbvlIn0SLqzK7ueZ3kGaItRwFo3B3YrjGH6caFAKnlklqFQBWWN5FD
         TY0ccs7DKP9XPCqKR8NwgzMUPnrTOHwTOIJS3BEG0usDDUBS/AIZb7nTuajE2atlQnjY
         r3fKaUt7XJRvv9X8mOhiIAwJjD7XSq/H7LmSvD5Sh45wMRKIt1/bHQ+F3fgVsNKsWkf3
         HMLAlQ825ZwyZa4+oJIFmrLSzCqT9oHMSNqRp/kSqrqFpUu7H5d+e8+AVWy0tRueXEJC
         0ovGTYxegbjSve7xYv+r4gl3e6BuMEgEl1nEVEIC4zzrGZJuhrz/SlhyvYRGskbZHPAM
         TMSQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785254075; x=1785858875; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FBsfXxp655wnJEMHI9WpUa0JDeWDZ1N+76VJg9u87E8=;
        b=hERqnDiPhmiK0DQatcca45PwDI5BAUqbV0p9ST+j25D1rBin6tzgwb4uKHP9T5EYQO
         LYyebCQHquAOhNoweSba3vK52dJz5roK0hdpULZmBSguF3bN0+xKO81yX7DsuaYMf6oZ
         GTon5ZvbuY+bd2IZWnmkNDMmDaT/KCN9uMrsARBqbZySqoE6zf82Z2lyP94phoJtVn/V
         GSourqzGBTlY1vJKxwchOyG1JkdQjzTaq7ULlkJNR5EnIMQm/jKwhSyoeVfwxpmkdcxF
         /2Fpnwcq16T/poxlF3CWC5mim07wZRH9tz2Fo2Y2eTgonoJXbhC5YYx5IFnDhBn9Baix
         CjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785254075; x=1785858875;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBsfXxp655wnJEMHI9WpUa0JDeWDZ1N+76VJg9u87E8=;
        b=lng66JqXmrLbHXeRR+ujaIeY0u+R+qMazWVOfMlp/fTaAK8g9osDeTsCGvRyyTJML5
         y4oNZuooAYhqJAWzYRFwnlRsBmM0APeTShF0vsY5SDEFuGS2UzVj8zeQjw3w3sR8O9uV
         2l7+nRCfweULlj6NgDP+Ha2pKAGGpAMaufzUNXnxETIyAT95rFyXsI4SqxpTwIQeNiSJ
         q6lTsmy2En6i+h8AKg7EdSgBLQ6FMnIMLd9JOELYaGBvkuzo5wDPmliaJ4lNXZmQ4HUz
         gPb+clGnKmoTkmTuJCh5Y12UdjzIvSU4SqV9YZCLW6Y4M/qE3GtsHCUL3lMlzBzge4qe
         IaTg==
X-Forwarded-Encrypted: i=1; AHgh+RqmZyDjY7HYSKAym5RBz89YO/T9ixDTjC/ZLkkIYshpn7KjFuo+Gb85lokBym9A7o2EmuVlUqUNXQ==@kvack.org
X-Gm-Message-State: AOJu0YyVYgOrX5KGvb2vaRA9LYs34dIXL9NsgeWUT0xqhULzz/ZtN52a
	/H4uIXrAfefCMjdNuZC9/7aZZbRqxzkIafIQlH/+DgyTQy3kLALffoWP5FYAEvQMRsvuotbqxaG
	Tb3dvQTUBWDtd4TL/c9j+4KMmaV6PCew=
X-Gm-Gg: AR+sD12O6wYSQj3DZ7JnciQRK3xcWEc+GGRvGNpg7yCvGkdfO3gU17BPwUpjuINvfNP
	yOO37WNsEsSSnV4CmooJJoU4EkbdM5fgYhGLvrXBb4eXlMykT7jq89KaStcIfb12XpLnG6hEw8T
	tMI/ZJ9HuYVl65hKdwcGbfp8WwBdy0m+hombLhm/pdqAjcO30qy2Bd+gsBYVKVCMx+DoYXlElrT
	uvEq1MEHFFG/VFEpfeID3EsFDuYg80itYk4q7d/Pw/lfZon00ByPEfCn00LQgkuYB5RmUrjIkhE
	QCdBhEyirgDG/C91Kw==
X-Received: by 2002:a05:6000:60f:b0:47f:90a5:be77 with SMTP id
 ffacd0b85a97d-47fb1ec88ebmr3876146f8f.6.1785254075316; Tue, 28 Jul 2026
 08:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260727143618.1582318-1-alex@ghiti.fr> <20260727143618.1582318-4-alex@ghiti.fr>
 <CAO9r8zNJ1cfCVgxtpqx4Db380bjZ+Z0P842eAxPXw6Mh4XBrww@mail.gmail.com>
 <CAEmasaXR5EmGCv3T5AzM_2908R-VjfMcObrACyVGokY2U=+i+Q@mail.gmail.com>
 <CAKEwX=P5G=Ckafy6fm9ws3njWP_Zm_AHRKOFERScB9Pkd_KvGw@mail.gmail.com> <CAO9r8zNsZUvMknjmH7MvkQ=09DnB9YvtYoA0ei5Hj_cESQAVPg@mail.gmail.com>
In-Reply-To: <CAO9r8zNsZUvMknjmH7MvkQ=09DnB9YvtYoA0ei5Hj_cESQAVPg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 28 Jul 2026 08:54:22 -0700
X-Gm-Features: AUfX_mwM9uU80mkdUZmobdZV83JB46gEM8E-6OObYnKo-qwfoaG6M9zE0eFhdcI
Message-ID: <CAKEwX=MPPEBBepeaJtvZUZBJL0KmP6zGevD9HqTiUCKO4Pt_Cw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
To: Yosry Ahmed <yosry@kernel.org>
Cc: Alexandre Ghiti <alexghiti@meta.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C2575C0002
X-Stat-Signature: z7935qg8xmpu9wjnysocoib9w41qbc8e
X-Rspam-User: 
X-HE-Tag: 1785254076-209917
X-HE-Meta: U2FsdGVkX1+xG/uuJW1/VQgd+1ecenC7KOQgTU+IaGYcXVb7OHZXh1i5o+TCaIXpBEvAgqefsCx8ApIdwW+4ISDiAtB4tI/NAHLasSsvBoGmcWLIzhhXu6RrVLmhfRDFK5Pinbfx8SPYNRPmRuFZTQKSxtNaqdlqcyL7vCGxyej5S9bgBFTky6zfzSs12PgWO0fcgc+5OwXLlw/0SAai/xcY7D5vnKqHyHK5q444YuewpzmmEyNZpk0lr7CULQdCJ2QooUg5O1/QPcWFaw9j8vBUmuBDTLqgpaOtwgn1y1X6GKXuch7Apmm/+kr01aBXaSd/XqsjIIeybet5VMAVtlGwTVJAUoDfHqBUqq2BZzOCwqGKSGH5Ve5rlDP/EanRgRYEsbSfpuFp19rB+iJXWOyuaQyzUX9pC85OweSTympPzyNQh8ca/uURz1i4quNGFaNJ/WgeZ8l4dvuCd1X5yz+IXes3rcgU1be0t2aVXrD4doJiknFEJCP7Vbl2/K/MJ7BrCC6A5tKMn45reTPzn2qtCOLWR2XXrI+T4NpVdJKILW29UH0QmutAN03Ng6PgHpt6G+QMe3fBHVdXLa8Vka85Ri+wkWxjj3kC5A4sIsMMJL/wBLNPg4a57mkCFM374Fha4zCTclq2TvHo6LiJP3a0h0iwMuT0FHXnJjGdbFuikSKrxfacnZreH9m/5odtttoy+I9nG6T+Sh1HArXXgGWeF0ZVyP9cfJmAulFSGxwSO5xRQiQRAsAztvL/HzW2vWMsWoTKNREgAqVHduJp8CULN5x0R7JCPJ32tjlFVzcy/SJzpp90BJXu7yo5+4EDkW2ZS7RHnyy4XsWFnFKcnGOdpkYyUZbiAJwQER3K/EnjYv6z6EpSWJHowvzzpdLyPAchaIdTXsC1nXektIMgFmxgZHz9Un9yikrQ1k2kLgD9mPG7gEBnjQ4LZmbNTt/duj5mzRNi4o8MB5XLq82
 unHfj9ij
 yuQ76Cwy1gS044y7sdR7bj82vVFymAon+Ppz7p9VszbmJ/XB3ikelWvWLwTvjAqMM/9J9f44AA9vkSj9VOKVK7lj86dGLyGuGlXR50eiaPRt6ENELQ7Cf43LPIaswbRPDC0ixetWVN5kELCHWykGObVSY6B+Qtbi3kjrtzQjIWk/72bubRn0cponHWFhktuqOfdZWRmUE/zsULgTv3IgfrNdTKHFSPe0Lkzhbnp5mHVPuy7NmSTmL+epaznZi06xyonanW6RNrvFRqxI0byADUYSxCcb64QyyrGWLSa4dxq6DGWKDRvqYK8st5aWUY9IQ5u+jlZeCgIH3p/1mZacUp29JzVDUGPgcT2X8q2h0dzuBze451Yb8jRH1IZBu5frcBqcDd9JWlI7yp3IbOyuwhQEqotcMljYRMxohqncMcsSQFootB5BA5QzL5oD9oSfXOc+y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 8:52=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Jul 28, 2026 at 8:48=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> I don't think it's worth optimizing zswap + sync backend tbh.

Yeah that's what I'm thinking too, to be completely honest. But my
mental model for sync backend is zram, so I'm not sure if there are
other cases that are interesting that I'm not familiar with.

Normally I just use zswap on zram for correctness stress testing :)
That set up fishes out a surprising amount of bugs.

