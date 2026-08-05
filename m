Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19BBCC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 18:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C69FD6B007B; Wed,  5 Aug 2026 14:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41656B0088; Wed,  5 Aug 2026 14:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F9E6B008A; Wed,  5 Aug 2026 14:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1EE6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:13:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8B6340573
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 18:13:41 +0000 (UTC)
X-FDA: 85068013842.14.E1889FD
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id D29164000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 18:13:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GSWeqdqK;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785953619;
	b=tJQ6IVuN4JgfeNS6awavynZQRXKEDqDsOyLXu84HiSwAZq7H8OeF3t0savtu9N/xOxcn84
	zvJ0r612GQ73mi5fXSHxphEMZqMJniwQ8IKUfdOemt1URaHoXFteJCBKyyMFas/kC1IVvU
	PIpR0SQETigt2ldybTV0HnlvCIanmCo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GSWeqdqK;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785953619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VttIK0xBzWBUBWmIkqwiW97WNyQTZbTR6HIBNbzaOsQ=;
	b=8MMCrfpGmpxIJRon+wYqPShxWm1kPMavcsNxsrQwblzEWqPKxd0Do4RiRHzRilyooO3880
	FtHZfZCfahFkQbE6pk/5RzkO86ZtCCYAVd2Ze92GNKl1OjwT0nfxj/Iquo/GbufcUP5wRv
	TwrQlpNLU7RuavZNtPJ0isl8cIz8xVs=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-495635a85d2so11504175e9.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 11:13:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785953618; cv=none;
        d=google.com; s=arc-20260327;
        b=VsH+Ys3CMSORGCjI/EJRXGSB2bPlfE78DVvZBwoMkNFJQQjptD+cH7b+ancFABAMCX
         vwaFwboSxKq4Q6A+8BWZbzd1SzDi0NsVkovGIIDzx1+ShHDLhKcZZIpjb7nqNmIr6Qap
         KLQf6PSQE2AkA4ZvbbKpzPoF5U5UQHzgoUUOe0H/y6wuwrVMdrcMlvszDRbeWURks7oE
         xJtkuq40GpVZxeRS4SuouLfeLGLZBkmaHWwqUkGET7eLAmZnkYDorsJjwGfwJ/HXsv93
         1tT6pnmh5eg2YAN4/8kHgOGOIVnUqxiY4x8sj8blRTCQL5AMrZEyRCsOWK53wPYAOIfY
         V3Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VttIK0xBzWBUBWmIkqwiW97WNyQTZbTR6HIBNbzaOsQ=;
        fh=K0SL9VhINW/lqX5ph81TISIeeYbMNS7p3uPn7LPG0yI=;
        b=jteJoz/v6RfTKBIX7fxdQJLVu7jup6GF66d0YuFa0bYJaT99s8Af1PW7iHaHrH+D7k
         tHLJSvXCSCJl1neddRa/U2G+xxA3rxe2Fna30qYSA3XxFU1rBvy3GcyOGbSzO8tERKVp
         K57QBvjb426xneQgsW3k/L6OOmc01Uq5IyX8nl9pZZsdNJ5+AO/W7JaJywuGQcvQ+Jy/
         y/KfjGlGYMp/a/3ZIsTW4Y/IVPhZj6JneAp+W8a8ILyUfnlIAMfCDe8DtA3ehcGYhbbC
         3NmtpZvVJJKU6mnkqiYt2I9FRiXrhMuG/VJy+MmJyzCfzxzvN8r7c0F2rwT0rC562f88
         duXQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785953618; x=1786558418; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VttIK0xBzWBUBWmIkqwiW97WNyQTZbTR6HIBNbzaOsQ=;
        b=GSWeqdqKjcrsfI3VfPr4KZGpkMuGdysEtk5bJJjmd3xne09usJSuaROAVWgFLdZUSj
         nv0C7zG4/SJBov4/mgAArzEv6T+qB4YFumOU2spRKolcESm7yQlaq+VEXBSRhWrVZInR
         Xzp092RqwErkaDd6bX4tNVZzUx6c7g5XRvPKkOzOigT2LvhgfDOB3HByRBW8Q7yx4KQv
         Us5mUfCIZevWHqXpkpcCFw0R2LxPvB/CyqP6IpoNNX5QVMYSwTY79e6gAx8ADUla9Fhh
         Ml3d1IUEdTAAnNbKR60FHd7I4DAyNA1L+acH/U1mJPyXBR3MLM26+k0Y/DFVwGNmofiP
         HXbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785953618; x=1786558418;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VttIK0xBzWBUBWmIkqwiW97WNyQTZbTR6HIBNbzaOsQ=;
        b=iy1aH7vfL5nNRu5JvqnUAzPjDqo5B10KaDLHwbWyOwVfOqVqJOdBP+ct3oJzipClYk
         UYbHB5kvViF9v1mGgBecU0W33DCZNODrmsd++y3Gdb3KqvB2qs1VT2YYgXSIs+oz3m+G
         MuzScZRnXpV3ujAqmMd7vePR88mw+aUBkLVwJrlz3lkbEE7NO85evF+mLXN3enwDxrEQ
         +ME+pSY59E3u7IGWZYdViJASb09r+pALI2vmOKZcwKgUBqhNs+3VxoRn2sPwF/PEKvZ0
         upHbW3wmPn3T66wVe86Dbch65QnZe3sNkrN5Fs2Nll9k8XbyvXnrZB8MzZOM2yyMhCS5
         b+FA==
X-Forwarded-Encrypted: i=1; AHgh+RovQzGwjzNGJVwfTYDiaupcZsKia5bytgrVAf/OZX0AsHuWEI+U6MAS0KYEIBNt8+Zyt0injHjQUw==@kvack.org
X-Gm-Message-State: AOJu0YxcWYDpE0VDLvJqxlnGRfrZ0/6/EQIVWI6N7JZ1gx/nyYVNhyWr
	Hhf3k3mAYUcDLPkRgQZg3Lr6yt3SBSl0VDofc31zhT2UNqOP6bjqLYq8HGT0hAZMhcuWx4Wxtg7
	Auyu6TzHgcXFsg58gHnsYE53yA3lXkpQ=
X-Gm-Gg: AR+sD130kov4s0PlDyOCt8a2JKIAxahMC9BdtUfy91pS5AkSxNMmm6rZ2tkM/1ANbRX
	a7ywSEn9jx2toK3luDDak1o8SqXMXxlgtbMoSoSqqGK5+tDxZZqzeq3NUfF4esr/ZDtPPUA5Sp8
	Oii3BocEepz+qcdr0wdGt0KXmoW8Chkn1Zyu7OW2UosYPQusfmsssaExuzIFSBnwJKRSUEcpaZi
	sEwl1h++ySYGjrEZaCfRCPyICZ59wNOTOfbFLWGw/14TJ6D7ySY/ODDzLaK/r1w+BcD0SBVGtRa
	tYI9jnqYg6CQ6CCyQ0sl5u39NYRBOgigiJM659XuYOAuZol/O/HN8rC0Tvy51/NwyzQWJMPimEG
	7iSD87qNxevat
X-Received: by 2002:a05:600c:1d23:b0:499:51b8:d649 with SMTP id
 5b1f17b1804b1-49951b8d652mr45542765e9.3.1785953618093; Wed, 05 Aug 2026
 11:13:38 -0700 (PDT)
MIME-Version: 1.0
References: <amufiuAaZbuDdKkQ@cmpxchg.org> <20260731071900.38942-1-jiahao.kernel@gmail.com>
 <amy8gAN33W4QsM5R@cmpxchg.org> <6e16a760-d84d-98e1-433e-3233a9dd2236@gmail.com>
 <94d74382-2e2c-8f8e-35e6-1ecafdcc445f@gmail.com>
In-Reply-To: <94d74382-2e2c-8f8e-35e6-1ecafdcc445f@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 5 Aug 2026 11:13:25 -0700
X-Gm-Features: AUfX_mz21OIvgUV13HlTkmRouDqof-qc0oL4x2fG4bWuvZaziIySVbUWkVknIP4
Message-ID: <CAKEwX=OuXHCV1G67AgJa+S42O0S+u+CGyOKcg9HqJ_6Pu_=5hg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, yosry@kernel.org, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, jiahao1@lixiang.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	mkoutny@suse.com, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, stable@vger.kernel.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D29164000B
X-Stat-Signature: xgs417xajgijrtnu4a9dp6y8tfkrk465
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785953619-821136
X-HE-Meta: U2FsdGVkX1/uaT0N589v9cijq2gTNgoQ6y+zHFClNyLlSeG/ULfpphSvRCjTjIym6v7V5s/v9kbG81NF/8+DDRbGFwzFUQrQOx7yXcfFPG5og0MLFxk2HY2eDPvv2cjbBpbyi6IH2ow0zpmw4q4VyhbEKOVNQzw4Gz5c1TqW7BnUnu+JNFs697F2n5KRjQNGiLadIVWamnljNnn9G/xjiv16H9KCnGJ04vLf94R3NOtIn8+MzOQMrppltrL86ng228lrFUp+cS1tW59+Le4ix/2VRYQtwrXImkCrbvNw69B76Bd4LyPzO9lmXy73zIuw6+8699jyBSNlocKDuAc7bi7f68Rj7ACHzDJdBKK5uJ3m20JSc1XHyWuw3rTUmLsuj6IfX5zmjuwBJ1AAdvxCqCAmlLcxa7ftNwcUC8xO031mS7ARwSsoF+PcsVDiJdnitBd1IqhEZVrk+XmADHQ5iUE1edyP+TpYsSbwqBV2/u98co9PkzUt0DQshJBKpGxSOwuaKk11mtUWAbRvFYWg7MQIZJwLi1OWlzGhsVKEacLh2V0fyun0t8qosgvA/rRZ+CA4oqUWdjl9r75LOygiqSCVfAF538hej1dhP990OiZfJU4X4UbOPlGbB7mOfDJxYH0NUg8M+ddExrwNZDnkKswfbhpPZu4QK8AJR5fkHQ6Va2CXmJ1bcgH+euAJbUkrkBNoVlDVVyGMO0rFI93LDe9N1nWdB6gSOt8hSC8UVlnyj6ReEh8dAooKHKksU9ugizwj3DgwsYZ6HBEM8ebKRGNxNVZA/Plky/crEmCg0HKkCWgJFBLbqSbVSSjA6ivxfAhF9Jx/UgNV/Dtufbwbwco/mh1JockmEHfdYl6Z58/Tcmyt1tmUz/DSQXzaDk6fJhBCgICJ8VzHdSOi326tKxwhBkIAbxl/xkcfm1kl9eIqI28ExyszYJqRa2b093w642GzlFkjDaWZKiVSpfB
 1TUPBjBe
 eKRPlVK0PjeHh5a0T1jrF7AyMI1Ed9Txpzo1+yRz7c1/P6jCQJLqgjyupcck7Ptxh8aZrdpCkdgIjHu/vNTcH5pix/jw+89fi5D1Pf6PI4ZK+0x/Wacqw192LKLlC5YkUwGgywWos3tZgiG6/UwetVCVbpcD31GujE2H1uxygGqfqQznx9+Zgm5aqx2IfGoMxRWCZs52vzN9YRty5Zw+hv8QGjxJCy97rUCY1ny4AwEkSzwWQ4S8A3DP+qF8wpc5J0VBmVWPUL29KimxvupEcHmeqrZIPB94/cNdBRTWR3NtbsfVyYnqTd0R/LKZ96HFt2WG/OpxJD/VuZ4+l3sF26S9SriNLXFTGmRh1WBwp3U6y6bf+DnI5y0xkPLKdj3iEn/QB7ttulNSzCTsxyrK2BFh1zgHDifPL/wbSHBQIQ4steK53BQebOgNjo/q/nREY/YGboU0hULlPPl4J0Dvo3QHQ7SY7AEsgoBwEamPxaB25m+Eo+a8qhauvd+/uUInpLYP/0EwX/6h6qKbC9Joexqb7qIlA3QDvFt48Bi/z5a4zDGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 11:21=E2=80=AFPM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/8/1 08:31, Hao Jia wrote:
> >
> >
> > On one hand, this avoids scanning the same entry multiple times within =
a
> > single pass. Since the second-chance algorithm rotates referenced
> > entries to the tail of the LRU, entries on nodes with a large number of
> > zswap entries require at least two shrink_memcg() calls to be written
> > back, whereas entries on nodes with fewer entries might get written bac=
k
> > in a single shrink_memcg() call instead. On the other hand, we also

Same thing happens if you have more entries, no? Say you have 64
entries and 96 entries in node 1 and node 2, respectively. Then you
need to go to round 3 to reclaim an entry in node 1, and round 4 for
node 2. What's special about 1/2 rounds vs 3/4 rounds?

I think it's probably fine to just pass SWAP_CLUSTER_MAX as nr_to_walk
- we're applying equal amount of reclaim pressure to 2 nodes. Without
prior information, seems like a reasonable strategy to me. I think
what you did is already a pretty big improvements to status quo - we
can always add more fine tuning on top of it later if needs be.

> > avoid spinning repeatedly on entries that fail writeback.

SWAP_CLUSTER_MAX is 32, so I assume it's not going to spin for a
terribly long amount of time?

