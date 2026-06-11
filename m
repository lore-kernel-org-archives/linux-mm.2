Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DA5CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 14:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971966B0096; Thu, 11 Jun 2026 10:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9227B6B0098; Thu, 11 Jun 2026 10:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838CD6B0099; Thu, 11 Jun 2026 10:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 756D96B0096
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:35:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C0271C27CF
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:35:45 +0000 (UTC)
X-FDA: 84867880650.10.13C7979
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id E294A1A000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:35:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eqdvS1CX;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781188543;
	b=1DpuV4XhRbhPqD31DCz2nZpE9BofdWok6lHUYZIMkc1cbDAWpucM2edgmM42j/lrYEha0F
	JWtMQO+iK3vsSgETneqJo5FjCZZxppRpIRhBWtfDDL7/iP549eQMDqiDbLo6vAndFtPNen
	02W4B6d0uRVhAC3Wb5XRYZCS+ouu1xw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eqdvS1CX;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781188543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUi88M8OfN2nhAGtLyoxPLBw+xuAxEnmxBQ02BQEW0M=;
	b=3p/a9sQvFmjPFPn3HbS7N4BnttM4MF/vm81c04RP9jCROJy001dtWz6phk6Eq3bG7r5bKx
	uPCkd9lBgTO2kIPxvuK3NoPcuNuSffxMZfcvbllC5ZGvXqh09czryizOj/PX7nCAfdfI+Y
	h1pCJ2L7ChN0sitVK1ulr46nr3iRLJI=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-46015dc517aso6532506f8f.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:35:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781188541; cv=none;
        d=google.com; s=arc-20240605;
        b=FOprwpVsG+dp04ndj1h86ZY2/bjMycVnH/yKBe/aKi2ICodiptFxtRt7lkTK6Rcijs
         LTzGkV3YhOSIeM7CV/xFGD5lsJNArRrAWl3PgR2YDgpC7MWppjFsYTEwdYOs10YcUc3H
         l4ZmTbBoZaO5e68Wl9UE81OxzsT7X48cHZTdwiPvwKfopxJAWqKMRQ7W6z3UeFXOZDuk
         mtNRm5PROOK+2G8zyAl6tgC2pHiMjD6FXuypcnKyzkIuwoX7D07cHGV2Cuoh1m5/b6qF
         DyNZAUJOgby3RT1pkNIX+5RBz042/z88+YPbaXjQCZPZzz/AYqnvYEVVmBR6oO0ZjUDo
         Xpyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sUi88M8OfN2nhAGtLyoxPLBw+xuAxEnmxBQ02BQEW0M=;
        fh=5H3CL/iVCNAesxaZW2Xj47pHPXS3EycE8sk4j4XVJh0=;
        b=h+m3VOM83EHoq+bFi5DVzBtYN569sCtvgFwAiuqIlKHPG5yfjejrd6KDzSpPn9eF5H
         iVnftZk5/1Cro6QqLRTEMMshsHfxoYQSliQNVwf+l27xWWKeoehHlSWEX5oxsmEHOu3R
         D+VytPVWeRoANWC1jUZQEXf/MQsITnzcni9FAAps3BBWSAd4T67NEzfN5KptJN0Qy/+b
         elhW+y48e1NgYW02UsL/Y9zG2mRJLWD7gihqkSF4V2Vv+R8jIEflXKCJnIzaNUDCw+mQ
         bLByYkJgMylDW+8D+lowbr3N/AvCFS/jx8ixSgWoPwvwFDq402r4yx3hEQTHkucLqwKv
         yi+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781188541; x=1781793341; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sUi88M8OfN2nhAGtLyoxPLBw+xuAxEnmxBQ02BQEW0M=;
        b=eqdvS1CXg0K81eSZS+iCAULSoBjE1xX83Xlzx4LTptofBkzns2BHb+I8oqvbQovMNr
         eiBmhgpnYeGf6xf7URJuDhQa+sZniHGDSgAPdWfNq6RokLz0C6OsriZQ6Gzwa3sNMWfh
         Y+eKVv12mm7lTRHwJaxeUpvekTnj73VctAJ0gjuPKh/2o4DxUsnAW+tVUE5sevh8zmRk
         F1cVQuUDYW0ybbPmY2jh0YV3TGKiK5/Lxg8m23QZTMbcZH+QUhE7XrS0HQqURAJw19xi
         IblZkOFHlqT4M60I5oWbIo9yxk9LEe0kzMwiZiM/0lrX3Ps0a7FOysd+r+Hh9CxfhXXM
         mzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781188541; x=1781793341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sUi88M8OfN2nhAGtLyoxPLBw+xuAxEnmxBQ02BQEW0M=;
        b=V71AGbganlH9Xh1oD/IyXJea1CG5SXoPIiDDwdCwuwmLaWDLIAbaTSnbDcjTetsxCD
         YiXTKqfP+7VnCxEHhSaVz5ijzYtILHUvP1ia55C0XBaWp7yCzvFLo3a9jRfwJUwG9xNR
         am31ulpqT1YHEaFVx75kVV9dIdPqtdRt8C1w5qQ1LIzwdwpjtfldqC30E8+lUZozIVVj
         qgMBYiCUZ1U7K15AKh0532uyIIv1wA12/pt6MV8olnx0ABncbiT8ISPZgr5ZS10W4RfC
         Mzsz+Yo2T/6JB744mmCUUM/mYiO3fP3LQ1Lb1NOxEMCmyKz6CcngxE7tXOpx9YZ9Q0tZ
         GiHw==
X-Forwarded-Encrypted: i=1; AFNElJ/NlY3g9XdrFiu86RxxDsSK0ImK9Y6vzQlmunHRhrNMRITpXpDv7NCnK3rgQik0dAtI8/o7a2GqhA==@kvack.org
X-Gm-Message-State: AOJu0YyT0bgGcXl/HBkAb2S5WgUHdW2dB8iUh0FMyjDw/Y2gXm1D2u5+
	gnERKm8pDwNIWg9gZz4qByBAtU0R6jSQtpvQ0oqSomawMH32dJ0BEhtlB1fHOua3wIW32BsipeC
	rz9wr4GSpFQRhbaXZazlIkyT3OHOcTrg=
X-Gm-Gg: Acq92OE5O+eBnogMbSFf4/OMx2E2zqzvvmJjleTU0GJCQ5supeaofISvYWvRV3mukAF
	Ry++elT/Dn80u1jjmvR7mwlKXiXHteL7JotO2hQuIm9cxWRqymDD/asbx1qKDpFpQ3GNV4XESCH
	3m47Fx15CXncE1BTimVH1WnAC+zHOw0QcS3cyPVSGqNCAqemMsBhCznU6EW5H52jwdiB9ualrQO
	g+IQUazyG4o+Kfb3C/JxnreKs5tWELc8mEyJOoVnOCAs5VKLYR9hxoH6KyIH8ZCN2NtiNt59x0Q
	KBksfzgy41Zx4bOVZhJxp2VTb61YLYdmFLGqGduxLaTJAtzR78WQj+tMxF23dRSpAw==
X-Received: by 2002:adf:ef42:0:b0:45e:73b4:85cc with SMTP id
 ffacd0b85a97d-460677b5fefmr3775796f8f.35.1781188541341; Thu, 11 Jun 2026
 07:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260610232048.62930-1-shakeel.butt@linux.dev>
In-Reply-To: <20260610232048.62930-1-shakeel.butt@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 11 Jun 2026 07:35:29 -0700
X-Gm-Features: AVVi8CfWU9wIuMHeCAJ7I4nBsHfRFhYVyjvgKe-WEnxkiEU3lY46a3vY0cfR3yk
Message-ID: <CAKEwX=OBzRjixTXNmUF79Ej-HkhuBCX5mjnyfqh=SHwKcntKAg@mail.gmail.com>
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in shrinker_debugfs_count_show()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Zenghui Yu <zenghui.yu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E294A1A000E
X-Stat-Signature: df3oo6hi6ymeczgcgesb9qic8cj56ua9
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781188542-450248
X-HE-Meta: U2FsdGVkX1/fjww9joo761zbZerx6xnjpTKENTKXzn+EgJR/SQnMp+Uiy0jk5AAwQSDCBremKYvdL9K2sTExLm5OLLniM6OZ1ipP+X1NZTOqSzrQXPxhSGcImajOhz0UPXP/9wrRroUn8UMtzahWZmstTosXlr0ZTiQCyvnzBIBBNcpVBaC1yvzNKipFiFHJoP45lKPdJYJvuPqNMgUjRmfuL7KikoogqPxpav5bG/JKJ1IGnRehNZc4kOmz9wWKzlZp6qMMW8bzGIKBwz6r0k/FEy+lPr1iefjUb7jL5P1hqVQewXkaqhbTclwzeG3TE0N4IEBjeYv6qtTnPslKgYG3UVWlf7UK/4YOFNli83tiRpPzfaAUGVvowKytt9/peOTXWSQGOIU+pK3tuv30ld9moenCDSILG7dGwelCGSKLt8S7HPMq+zLfpyUnivxIiJUTzuToCBFGl9tZQYTtwmwGtTdTAXssfn8/q46VM8wE3VDQyoxLwB3OUOzZPfEqHdKHataRm9Q6o/NYCY2stjTeQAxaaDlA2mL5AGnJm8Jo9KZNpM9zmlNqIhTNDZBdc/ygL8pMsVLw2jhtXb/4fMmLvHSmONOLLQsw1J063ar06BRZLSrnakyBdnQBytYKkCc6NyCnlqF6IHYSJRb+DBSXB0yMdCWO9EtlLuRil4U/vVPIRXSugLFQIDQixCebqgJJ4BTcxX9IBnypnJ0tj2A7w+dKTNKqZJP/nhYPJUQ8MFhF4sdfySIhIbWRzWqDyGtE3OJ9v0tS4OEkHAq5QJ4NGok6Kdm8AQKmbAJTuhvprbFJ7UXHegA+6DCeSMwxKtRktTsZVDSw6xvoK0m0hCOyWhmP0GKWCilBUPfFlgmhAeANp6MfATG+7pmov/ZTyysz5HnC5p8kcQN4WAQEEmdqxO7ytEz8Uh6H9iZ1u500mQpvSpvwFKdw9bFbJKikv6pPqGX5VQvquQB5UZg
 1o1/0cMm
 jpM8Ai4VEUMVJU2xfSmcDKwCN6cw0UYg9gtyN+WHF+ZxeOiSNOFxs36gvB3kjNeoJQbvTupQJKpSl8G0nzL7sSUT+vofrSuao+P30W7Fqa21CQYgW/dSHkgiM/QhO+izv11bpGdcuew3sKHitFOVsJDcW8tD34U7ME2vgzgfenKz+d3IzLcS3LFxE3IfeyY4wTtb58r3OsHr7YseMAjsx/w4N1cV9vp2HZueako+MV9xN5GDqsYl4RsNkeZU4Nj1ys6HPOBntVOPpkX0JN77feUtvUQb7mlLdBkt9m6YzTbDY960p5LiERcQG931NkZEBBbbS6Ijg9BD1EcLIwfdPc+t7SDf+fHwy3GwVVTcJKGIVFIHiowxuqIN48+atiGhsCFNXk+LSV4itTFAf6qGMEaWyY5tl4KCKJS4bHW9WHQ+cSacQUiztwdbAijD+n7zWIgCzHnnV579ahvGOSJrxOH2wSrxRSOB9UXXY3naHDgMtEcrak3MRVO9KwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 4:21=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> inside an RCU read-side critical section:
>
>   BUG: sleeping function called from invalid context at kernel/cgroup/rst=
at.c:421
>   RCU nest depth: 1, expected: 0
>    css_rstat_flush
>    mem_cgroup_flush_stats
>    zswap_shrinker_count
>    shrinker_debugfs_count_show
>
> shrinker_debugfs_count_show() invokes the ->count_objects() callback
> under rcu_read_lock(). The zswap callback flushes memcg stats via
> css_rstat_flush(), which may sleep, so it must not run under RCU.
>
> The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
> and returns a memcg holding a css reference (dropped on the next
> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> without it. The shrinker is kept alive by the open debugfs file:
> shrinker_free() removes the debugfs entries via
> debugfs_remove_recursive(), which waits for in-flight readers to drain,
> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
> already invokes the sleeping ->scan_objects() callback with no RCU
> section.
>
> Drop the rcu_read_lock()/rcu_read_unlock().
>
> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memo=
ry shrinkers")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@=
linux.dev/
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Too fast :)

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

