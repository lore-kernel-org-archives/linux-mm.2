Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77143CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 02:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C6E6B0005; Wed,  3 Jun 2026 22:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D2A6B0088; Wed,  3 Jun 2026 22:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC126B008A; Wed,  3 Jun 2026 22:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA506B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:36:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE561120591
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:36:05 +0000 (UTC)
X-FDA: 84840665490.27.74A3047
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id C41FC100004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:36:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gpQc3e3G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780540563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLAxFtsFe46fSa82xZpNfQF3MHB85xuM5UN74w7VLM4=;
	b=TcdjoagiKz5Q3NdE935CkfO7Xp+V4pN0Wn0PUgSWody8/YHmJ9PmT9ZF/XrLExFMqEHLzF
	zsqQPSdryakiwO3sgsodyNLsmSkOrIqhfDxbzuEiihip/ZprvLBmWX5aNN485b4RIbpmR1
	ukgzmej9Cf49PjxvtO3fxHsOWVHmAjA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gpQc3e3G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780540563;
	b=fSzYHUUVbJqXhstD19+PBZ9KEH6qCA4ovk3q6VBtnDqjYZxkOW5bWPLGUyAonAC/tqxQWM
	C0+psbdEZOxvRj7Jtmi5Ag7DMnKoV0Dkn2W4Bq8OqJQunddFhW56F9YtiyifdheObKrtSF
	JyzpaFgrsWHY5t4jog8L7cUoEEzjcck=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aa5ce4904eso174403e87.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 19:36:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780540562; cv=none;
        d=google.com; s=arc-20240605;
        b=i5B6HcgSbNukmURcRp6Jbvu0dMtb5eyYVrdOvuNhPFRmHw0mkCt+AWf2tvWPULuSEE
         aStLSWSMAOW2A54dkbRyT43nwxGMTQrrimCnj8/GWWrDC62x3yNaOidN6zRcDLveV/8M
         5E2rzS2SfV9X2RV5HF6C5uUmR/668ICJNr1jQ3Ca0jJEukRTQ1k9PI0jahN19pRChC1g
         2a7SM+mB0YkvaBXdMkC6BnzqKnJTpgiE3wOHNdEOEo14R3AWuQEgFPqhObAE4IBhI1DE
         r6CZH9fex4oA44CRG/+U69fxFrL3PRgcI5tvBUfsiJfJSghyeThCC9fklbY2VZsIcurq
         uOsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lLAxFtsFe46fSa82xZpNfQF3MHB85xuM5UN74w7VLM4=;
        fh=+MZNp+87pnIOjKdNLlzxQP0Nf7IwPvZNWjfTep3c2+Y=;
        b=VysMnADDuehoFztz5uFsOlzFER5BxGy1Bs3oKiFZ2OJd3g9ImQHp7znQh8BQ3F33Ra
         9/aVO4qcY46pYl5WyBZfR2Cz2Qi59SHFm0tBRsQpxA5bNXz4siRVz7Bz7Hze3CzcdcTl
         QXzHXt16crllHU3DDKfRGeykaUqRIcvkVhArJ0zxOgkR+pAKiT/OS7VqGzgL6F9i+cfq
         JSk23cvJCqXerZ6iI3fhLAYd3YhJNHPvC9N7Lx7CThY8rhGCem6i1vJxFbpR+HQdw7y1
         HXXlHFaTju5P9BaNT5D/VszEkv5bdfKNoOjlJnaMKna45KvE6HLXD4i8TOSBCYpWrHNT
         rumQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780540562; x=1781145362; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLAxFtsFe46fSa82xZpNfQF3MHB85xuM5UN74w7VLM4=;
        b=gpQc3e3Gu6RavC/t0DWgkqvbI5p4jSIBvnv/DIkjBAoribWwZp8Vy4pZAeYVIsY/Mz
         tgShB8QxEymeAC5MbPWrztWgTR100fAzpLo5KajmxJ6W+4PDc0LpxZ8gBfdyEjfyQEZ6
         wRDphrcrzjqm/bU82tYY8Vo7Z9sARTgKd9gEpz2Zvj6jn0LKBmf41e8nHsL5lt0QAEXL
         7QrqNOu9jMuEsY8ClNYh6YVesR7UzKa7YrevYa3g/xdblk32Cu5r5CvgtTyiqdntruZI
         ns76qTK9gV8nv0iZASbBjFYGXbVj7egD6blvK38jYzHMt1Nni9xGEgKObmRwV+oidBFE
         Br3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780540562; x=1781145362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lLAxFtsFe46fSa82xZpNfQF3MHB85xuM5UN74w7VLM4=;
        b=Y7htseRLnKNpWuEAmAWGSCtBqc0TUAHY+AdqYe8UTutdOekH+/+tZRdu+wYm7o1QR1
         4VeJEj3ICBDWemQWnXJXSpsljf84aoUL66j7dmXzla/3gPxmNMWcxps5uiXeyaHxWWj5
         PyBPV2DO5rBwcxTf6I9Ae6yhUNJvIetkbdz2AdwGLtl94AdIBI57F/yCD71ZrYM1F6Er
         82gvQdQY09DvGrG1JsMBemsPGkIcEfEzecsyu1Z3X5M8F+xQ3Wp7LMLArOJuO13CoZ0d
         oXoqjitHm+fUxfBUtv52JqoVXYdBumNj9XyllQdZm19tBhjpVqJRDPqcBUAeGsCoyGer
         1W1Q==
X-Forwarded-Encrypted: i=1; AFNElJ94253fgnFzQZML4qUHEaAYvjkysW7NESWXed1mHIMMlYsIm86W82WKtQ4xn/wkTCdc8APWFZg0pg==@kvack.org
X-Gm-Message-State: AOJu0YzEJ9cV/blfc/1VpWQGfN8XXFK1ujWA2NfYfWbyotU1Rp3BYuo1
	3pkxi+EwZDQoO38RDs2EAvVviS1lb1cUAc/lwNmcxVB88EWw9tvZJdwcfBwh7eJuQWxtuu2JmVe
	u8Uf9JQ6AWUIFIQ9QUrjvoFyDbRf2PcQ=
X-Gm-Gg: Acq92OF6uxOyEvA/a4AzZORr9YsDEUZQ4QmqZqXvqUWI0sTvMJxv/zatjnS+LGo9ifW
	ykBAIniuAEwGXiiiembbyXqNPTsSB7I3g/zF51MrYt6OIJeQU3pRYVMITPmn1g3zMeqXkJIEZFY
	rbGeulBWOdIAQ8U793ujK/nPqZFuEolGbjd5GyV6rR5SAXL5qKiq6FebYLJRsaEKaDuZRCgG1HS
	i9zS2foAdzkSHzgjjKn2pyu1bA5+/fgRVR9+15tJmYubGBvF1B58pY74z3fq3bifxxPBoBn8D6g
	lNalH591XbB8qSYfVRSxH7DXA8Viji79493h2fZUskgHJvLp
X-Received: by 2002:a05:6512:641b:b0:5aa:6db6:530 with SMTP id
 2adb3069b0e04-5aa7c132a98mr1679500e87.39.1780540561715; Wed, 03 Jun 2026
 19:36:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
 <ah79c9IIuXt51ybs@casper.infradead.org> <aiAGrJsNm_uAf1qu@MiWiFi-R3L-srv>
 <aiAXwQQz0MeGrD1x@lucifer> <CAJxJ_jhTAS3gbo5AoLPGCUSchUPTsUVzkNVprg9pfzqXFpPEaA@mail.gmail.com>
 <aiBKx7t7XRBWJLm_@casper.infradead.org>
In-Reply-To: <aiBKx7t7XRBWJLm_@casper.infradead.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Thu, 4 Jun 2026 10:35:48 +0800
X-Gm-Features: AVHnY4IHjvRwGyyBKk4_oB_lVa0SOk6XAU0xbOvdFDBcfTAADNNwXEM5Z_e59K0
Message-ID: <CAJxJ_jhXcNQ2bCrt7JEjCLQ4Ah8YQ8_Y3pCWaZtMKzGw7nGJeg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: move folio LRU code out of swap
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Tal Zussman <tz2294@columbia.edu>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C41FC100004
X-Rspam-User: 
X-Stat-Signature: 69zspz9ooy1cozh9pgkk9rs8m7wms9bb
X-Rspamd-Server: rspam09
X-HE-Tag: 1780540563-157795
X-HE-Meta: U2FsdGVkX18jvSW3+m27rh1Z6Ka0muelFT38ARDi79TmONNvq+iDCK7h0j/HMYzYh52oBi2cVt0k5ivJCs37fjkrboKgPNnzN3Ylm9eUp7nh/n4s2hIVSysAkcmC9OnJrJrvnIZQFB0YeKIEapURFfUw0cZjGwwgGL/OlnkOHwAeDuNmpsCGhy+jU+efqzS+XNFR53a/lSrbJ2BbCH/LAYa8KWWXdT5q50Z+oDMtQhexYfm/QGSVv5KCfrsDGOT5+OLdr2z2WtvU2NyGC/A9ZshVhBmS3z40FeRJIkmvYnETsbPIb/V4i5sx9yetWVOFEqAAlBfHuiVoxFOx22RCbYNKM3TrEFlsU1G4jJLLYMfU88qwpfmZ/tBA7RTcGeAcnz7DWCYohCRI0i8kHKKY+iZX+Jw+Af0O3ST0Eb632FmE6qyxf5BLShDnd4biigLRuAaO8HNg00uBGS3SVTwtfRWo0xOM6TQq+uDX5erPNvLZ6JPq2hklSFoUn6jj9CxNFMi0quZiNi1duijHozQN81ro3TPE+PQ238Y+R+M8qEzcG1MMhz+PtRAQaDUtM67vR32IopHVBJ8AnCcKl+hAkqStsgDD9zI83g/RBAeXl2ruZa1FHLSW4LjOutNtP7CwUE7SUVoamrPPoOrvwIwvbbwoL3661KhVd5m9rrZx431RocO4n6lIPlNWgd2jgbyveSVGkdgW36V3YBjrrtyDXbLhlRb56IuRvYbVAPSnyf7t5iJl/8D5HweGn/XwoqS134EpjEwCA+k3yasMNEVb+H5m+0PybE1c9HhJUntOE1BwYA8nYKJYLv90X8zeiX16TTxDcF/g7H+DpQ1LOXyIdbVOwfiEvetbzhYLzyJOBJ/W3m4FhWhiPUsbwq6VpfYBWc1XUkBvXVquvyrBPKnYM2k6MRXragkLp7Wx9vY1vpZbakHtmkY3CBb9SYXesvFc64NEVr2cAEWE/RdcM8t
 LSd2bNcE
 O0M5xtzZOutfKmm5CsxcPlq2PAet9VCXm2YaH6VWNmdyuINNaJQL8WAzUUIGQQSxkpAUSZFyrYSJHd8ube5x6xnxg2an1jDn4euQ1mRjvvcfc0Jz/8SnoeUVcV3hoXmraBWTYn+NZHNCmpdCy+paSpnYaXu7n1TYEhXMReIowCvClH4rrUnGsoBMBcG/AnCBAHX/sB/tbPVOCFKf+8FwF91RaRe8wti57xbKEm7yLyCj+4hYO9L44+FTw7dHTKxo9A6tISHALwWoThwgQIAZcYE03e1zI7wAvrp5EyQnQLvXNve4Yw2I4hJU8ZIKFeXqIcb/6iU40Ki1qD3O56qeBOZEDX9SVaz1wTXg8KT9a7Rx6xBpmNIVFrOYPr+uILiWJDzgGMo3lV9+Yqa61Fc7Nom1U9QjdLF3AugswjthCpw4qUbbipbNlDEBIV4brLE2r4OXEvLai7UN3iABZ8p5wF4t6szBhtiGJBwHQLey2g8/EwFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 11:40=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> What's the hurry to post a v3?  It's not going in this merge window.
> I don't mean that you should also pull in Tal's patch series, merely
> that your series renames swap.c to folio.c (and we give serious thought
> to whether we create a folio.h, or leave folio functions spread over
> mm.h and swap.h)
>
> Then Tal comes along afterwards and moves the folio locking functions
> into your folio.c.
Thanks Matthew,

Yes, a bit rushed previously:) Actually not aiming for the merge window, ju=
st
because I want to update some of the code comments and commit logs.

I=E2=80=99ll wait for consensus on the folio.c/.h discussion and update the=
 naming once
that settles.

Best regards,
Jianyue

