Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D74CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 333F38E0079; Wed, 17 Sep 2025 17:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E30D8E006B; Wed, 17 Sep 2025 17:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2201D8E0079; Wed, 17 Sep 2025 17:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 141698E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:20:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A92FB1A06A7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:20:46 +0000 (UTC)
X-FDA: 83900011692.05.4DF51C5
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id BE9DB40007
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:20:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PTINCYN+;
	spf=pass (imf12.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758144044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qm04iO7/3sYnnmFBSTq3Jy38SggYiX1vAG/ti9DkIJ8=;
	b=F0icVb4yXPLC9cn3IXz67J7jRooflh9AKWgGZs++PRSGx8SGBxmBtGVhZ5TZN0/XM2PySD
	ybsrMGU20nky10EA6VzNdsrQdmo68U+/pgwpUFXrtGM3kfKVLI76BRjp1IX6dFGB/ls3s3
	FsBG9T8SHs+U4NjlvlR4pJtHIAqFw+c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758144044; a=rsa-sha256;
	cv=none;
	b=KdwYk/x/5ubTVglIHfcGEHi6QXSfperzHHda+CoQ8JRIF//CsP1fkP4quikYFyRfM4KP9r
	4ta90qOUa/43NjSJCWctcZn/evbTNtt7y6gg3BIie3ZE7D1dia8mV3N2hdosSRAo3Civ5Y
	wW6RWNajYeG09K/AKgWk6rCn3QGCSZ4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PTINCYN+;
	spf=pass (imf12.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-62f28da25b9so317618a12.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758144043; x=1758748843; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qm04iO7/3sYnnmFBSTq3Jy38SggYiX1vAG/ti9DkIJ8=;
        b=PTINCYN+nttZXUoyv/PIbRR8pLVscWPF1QwzTEb5Y3yu2zfnS8gIf6eh6SK/igXzAS
         Mt+5OlTajQmF/YKXo1hGCzlx+0zbK3TzZprDbNmmwxdqEJUgFbXMuZolw92AooV0/qtX
         C+Z+n0xNzrdG1NMBZsTeScanbCmtomyIgbZg4pefVVIa+LyD2Nr/BhEcDtsAeQUaRSO/
         tWnM1kn/ukBQ/Q+JCGyEREoe1Aj83+Dx7beOIJNrjqfuJqQ56v2lOyIdg4LgSEnpGqch
         GDocA5Tb8lB/2srFPJnCsj6PHvpPW73G7KeYRtY7NTNpveMlw4+RPpL2oNMJI7YRnc5P
         7upQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758144043; x=1758748843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qm04iO7/3sYnnmFBSTq3Jy38SggYiX1vAG/ti9DkIJ8=;
        b=pdCFq4GGVASfUyHgGM3ZjmgDEpr3FjrfYwTUaRYvGWK43F2Lqlf0isikayU7K6ipIZ
         0/X2N38q9Ib8F80KWsStRKQeNe2LUwfVvfLqDNr40ZD2+1W0UameEAsbT4rWAmDez8fb
         UL+dvSa6cGhrWqRj/205byKPbJhJcOnM1I1YDaV+VYlXJ5WUGyWU8ZIKfRCxcov8oFLS
         HV/tnzk9QlfQvBy1/c2KwwfOPSg89ff5poqEUSxmBisfnKyYv17vCtDZ/6u7AIbTkHjy
         Q4RSi3shhmpP2oaoE5zh1RwUUQOYJMc5sfbGyMogJUA1qJC3ol/mHCdgORDt9ZovqvdG
         AoDA==
X-Forwarded-Encrypted: i=1; AJvYcCXVHb2nGpBHjPcXeDYuseNzTUFsPewZCR3HSCrrsXpMEJ6LxAx3j27ZKw1YsZ0zQXSuO7vDWnQ1Vw==@kvack.org
X-Gm-Message-State: AOJu0Yxp9D38PipHhxjpeAnCABtg8GWCHQxdZPZd0peTpPfwHslmn2JG
	NW+ceU5tNvxy7zwDntZvQ6r/4lMYbDN1Z8Vcgjm8/2ZSkt/lT0+OW+q/iYq2ShamkGw2YGQVy9X
	RJwRlKd0cb5YZ3NKXubsLPpbF2Ke4Nug=
X-Gm-Gg: ASbGnctfrVsc7X0ZX9PLbQmymeBAGePdI/6s4hyZaJDkCVqfG1YXKZmnXFoGAJiAlKX
	dKEnuN9VFTwsQHy+OA+0OIujzJpaFhBI6zmKEnN6/vSGhh+cL19MtWPbyvqae0fbDdMiyh5LcwQ
	8aFbSqk5eRHQ/1LIZBu90OpyeJzR4valFgZ4z+y4KWarovXAidlwP/kh/By0wLeSWFkES8t+6ar
	xCGXHUJMHemNzW/N/NGoDvtfxwbUBKz6G7n4cZVKJfYFxdLhz/HU1yi/g==
X-Google-Smtp-Source: AGHT+IHUs74RiuzMxtMB/SJNv66S3T8Y+4J7/v/JeOClSkPet/FUx/BcGD0yy1WcahJITTBzZkWaZvd3zcPgO7Lq5J0=
X-Received: by 2002:a05:6402:5211:b0:629:3f9d:b06c with SMTP id
 4fb4d7f45d1cf-62f84444eb5mr3183454a12.33.1758144043263; Wed, 17 Sep 2025
 14:20:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV> <CAKPOu+8wLezQY05ZLSd4P2OySe7qqE7CTHzYG6pobpt=xV--Jg@mail.gmail.com>
 <20250917211009.GE39973@ZenIV> <CAKPOu+-yOH6yzPEw1rayR1thO0OdPYCRL-CWkRTp9YFuHuRr9A@mail.gmail.com>
In-Reply-To: <CAKPOu+-yOH6yzPEw1rayR1thO0OdPYCRL-CWkRTp9YFuHuRr9A@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 23:20:31 +0200
X-Gm-Features: AS18NWD_v5OF_xdeJXUDk_UQNpV1LRyG_6pKAZAV2UR008iFDMbWoAW5oKUSiLo
Message-ID: <CAGudoHFdbmrLfLNKRb4cauzHOPBDqQT1zJ4xYCLXW5RJViwmZA@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE9DB40007
X-Stat-Signature: pukaw1qrumaq6s45icx1f4u9o5zbbcr1
X-Rspam-User: 
X-HE-Tag: 1758144044-774754
X-HE-Meta: U2FsdGVkX1/v3aNb2ShV5MknxEF0VvhMgWBc++cnezFUAQXenZOhjUYi3UUbK9ECmEm8i8bKeZ6Nv/PzTvdIZwoVoOHVRPKtwY4iV3Fqds2zWHztTUbnR/HRw6MJb025wnnpEa5T13/E+EP42O5k9VUPspH+KHh8GbI5tV1xzpKFaaBUH1l7qSIOkHlRxbIFwjbAn8Qa6+U3S31AKexmFnKKUoUzO+CnKVaomx6UOyoMK9ooG/WliI9puKucOjNBsXmb1rSHBQZi5Hv0LxpJWGGubJYbEwLuNBfTaD6FuUOL9gPJgtNX1COTVN52BUjp62UOgIXDwNhAplVDTfLiaF2I7F+tldBvjXXLhp9hHgc4OrZC0lgLheyMnm9D0fvN3y+Zl5YMuoUr2jPWHl4i0Cea5L0x6JaULBbNV8SBz8wQf+nO+FUJKI2fUJ8woYcfliply058ds+mE9u7W3bQnX/K5mGqpSseifO3i9aeI6+5Hl1aBFIZPrcJk6PEBb0xRtuuqIJGCW6wiFPbmSwwkxxVJfh6b2tGAb7H8+ZKTgw9k8gEdT4pgl0tOWmmS7ljG7/IGJI5ycnltbqmATZAQzZjPRPhS3WS9sQ4p5zbgaZMgCPNxJfG6R2D+RztqJQEvhDF25bNZpFL4ON8ASVUyu8wu1KbOncxgp4iFtBViJYcIOqZOIsC7SDNyAmP2iPddfPSkeyZ1nVlEabF6MhYguXvWKGzFtk9pqpJrhzhHP+svSLacOjjYaIdHqgMClTig+mu5HLYhjL5bfj333o14GKhpdjv7NaHFy1K20SER5wSpH4KNTr06Unza3fx/hjw4W2/xVa/Y9CTheNCn8TyPA+4K9V+9kIKoFvhzYQ1/0EEt4qjutjOyKxtEsaBDa8TAdd2pqKpsmkSTZ5tRP40gYHVtP98yZ6zlkeP68K6Vs3If79EkNgm60dou3d83y2CPBX8qEyTW+k4/5o8742
 T0oXTXld
 DLi5TcijjwSQgFoquJtM1yAu3BCy4bW4EJ5mDBA3gQKc9uC8cv6prObnOm3G30zTdNp6E9GftDxuBFLI+8PA8mP1CxoExRCsfD9/ZsVjBP0CWZbHbxmrXLvoE1sSyt85NO8IAMr9JUPgO9/Kbl2mSMYYs/CnJUJOHdVsNsKJ02n/dyNYGnssOdfI3U61ZTf2USqC+GSjn7tk+q88VKBgWqi5l8WdkXaOeHQNSxlqWph2U1GYE3pqmwCnJwSM3GvEf3Tc0vLZ/EKezdccM+SauIhXq8TL5fRWHbRS4+T8G0ou/yb+mQrLmwgovnDAJFXMdxlzHqzq4PlVUJtasGQUritUPteOYoACJMlQHoeB1AOoqem83GrkwRYrlO8c7vp12JgFqCCF0KG+st2ExAVgd1Lsr3UjWuKaIxobma3hJervmoiYskQjBjBQl3oQN2BvSuF98ZVScC1lFHQ5C2S89SdAtMfRUOZghCQPX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 11:19=E2=80=AFPM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> On Wed, Sep 17, 2025 at 11:10=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk=
> wrote:
> > > Each filesystem (struct ceph_fs_client) has its own inode_wq.
> >
> > Yes, but
> >          if (llist_add(&ci->async_llist, &delayed_ceph_iput_list))
> >                  schedule_delayed_work(&delayed_ceph_iput_work, 1);
> > won't have anything to do with that.
>
> Mateusz did not mention that the list must be flushed on umount, but
> that's what "incomplete sketch" means.
>
> (The patch I submitted uses inode_wq, but that's a different thread.)

I assumed someone would flush it to speed up the unmount.

I fully admit I did not realize it was a correctness issue here (see
my other mail).

