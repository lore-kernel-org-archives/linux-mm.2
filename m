Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A816CF357C5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D306B008A; Tue, 24 Feb 2026 12:11:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114D66B008C; Tue, 24 Feb 2026 12:11:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38E76B0092; Tue, 24 Feb 2026 12:11:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E182D6B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:11:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92C31140225
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:11:01 +0000 (UTC)
X-FDA: 84479990322.19.28B8EAA
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 98C9E80016
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:10:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="JgbE/PFq";
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771953059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UG99rsaRgJbLzDIGBIBYqn0yFl3SYVfB0ArseQHsWSU=;
	b=zH9PZ9phVIZ/qPaYgjqHzjBeUuLUMpS3a+UU9hpUAvdcNYP7FGhSvZoI+341D5imGzw3PQ
	zNUdbyIl07+7JwDwJ3xNcbYY41q3RzeYHyT1g5sRPFshqdXugCZHe/aPy7zGR1MxW+blQ1
	tKbhTW3fVnx1CoXx3n2ZfguiKAkPjxc=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="JgbE/PFq";
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771953059; a=rsa-sha256;
	cv=pass;
	b=eXIpfurt+R8+NMaLUy5zyXKI3tVkUMbUxZE1bAHLv3hS6k+AFV2U+XGW4E6iK9/UzePvQW
	0NXH/f2mLUW853UiRyKgu5rmlNurOhhJkY74A4j89ayTLeEcSXku7w1liXK9imzmjmdd7Y
	b96POKijC6XblrveZQInlu/H6xe/zW8=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-505d3baf1a7so76271cf.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:10:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771953059; cv=none;
        d=google.com; s=arc-20240605;
        b=jfgpsQJC+WbtdndNvTtEzrmebQL1zs4SKQOmn8Kb0OaJJ+BOxNMH+dBVswtRalIEL0
         4jSb3rzDbw9F4wehtGkK/8IOIyyERor0bgbkKb0lgg+cKQOiJD6TttMvxLAICNPNkgie
         0i8rYqZzZgmw36nNKHG+KiSZf6NK8rPj9CilkRX9ZuLqlUSI2ctERuRN+IDLGu3LP1Us
         4C9iyKW3Fe7ReX73JlKWb8kZOySnHrTHoLgqcAFeGi5gNIR7+g7eVA57JMCnmMrtu7yH
         zCblKUODhuQNPFO9XZlHlq0fkh5WCXb2j5u9em2NY6HxPj7JyGl3qnXtNY7cLViKzJ5t
         u68Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UG99rsaRgJbLzDIGBIBYqn0yFl3SYVfB0ArseQHsWSU=;
        fh=Oyvdj++l02xzm5BNZ74dRtFiEuSJw6kdWkAlXBwcaes=;
        b=HRV04ZkORwmKSHRL+Vir6mtAdMtH7DeDIhHaNRALSM+JNUQQH0nDpzUFKwwzDjOhpf
         sx1K3flU3N7u7UmMHFTILnvNMYNa57XH7mWWGcA14Anor4J2IKGkqQbqAba5+t3ae3QQ
         q3OCYdIWjCZYx5+Q8SCddzOt9NpvijKcCLOTHP2A3RnUjabDX7hwvNkLfeE72fSlgu5O
         i4Dn/WnpBoUzjVIBWkoH8AL+FhH50tVconUHsyXXiaVxYrIDDBy7eQibq8ipjXDJxDPV
         1erbH8TH8cLJhwDNUzo8Cyd+86QYhfcvNv1KO3dhxXhK1B5ldJKPEaRxDxAvrw3xHO7N
         xSfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771953059; x=1772557859; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UG99rsaRgJbLzDIGBIBYqn0yFl3SYVfB0ArseQHsWSU=;
        b=JgbE/PFq9OTP+ufqNjNNOHBlP+Rvlbxey5s1yvEDwvvLCo+KU9Ek1+TDzL5gkXu7Tx
         ICQ9V385g6VHQJIDqtXxEpG0aGKvC/VKroIrUEr3jGRaAyzrai3xMZ/GAGZ6aTzRnp2E
         nDXuzPGJDWyniv94qlFDwqdo/X3xTV6R36T6gtBAN0myMtToZLZ5g+xHUk1WKTp58Oae
         I2pbJE9YxUMq6PRq+eFjOxbekKgGRef6kCxZdkuiwqWoAQ9fROQrILRq59qI5PcBZGSl
         GddH2nuCigeLYScZO3JKObJTjdb96juH556pmV0KMHwjSLlidxnJ/TLcmjIJpfKzqDUT
         OUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771953059; x=1772557859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UG99rsaRgJbLzDIGBIBYqn0yFl3SYVfB0ArseQHsWSU=;
        b=uV8j77aZTwP4O3lM26injgW1RjjGUBatcauSxY2Q/0aFW5HwX1QkoIJB9Q7Jlje6At
         2XuKTpFkB1XYnL9CqaQIV1MptL6n8/WuhLlZ5pi1KjIGvJ5efmh3t3iSyqdyfwAcTGWF
         ciWz8mprWhZGTFu3a1FDoyEdvmujcp3ihM8Gf+90TaI4nwqG+li7SPlOP+XZRhKkChfp
         Ws/HwbSFqyKmHSq8dDCtRbVq2+deMlSGKEs/7Z0PYQv9ZoTXCBC3O8nMdAaj1Wlosac0
         A1sBuq2VOGN6O71Z9gksqpxM5z31gj11iP0irRb8RT1nmCF/TRIiFZwPrUJrSmn8Lp6u
         1tqw==
X-Forwarded-Encrypted: i=1; AJvYcCWNV/gs7VPIFaCLk/MeCOSlvuCxRGC2r8JksOi9Gx9ivHxg+AKasY5761yLa4gEbFekdLNjD612eA==@kvack.org
X-Gm-Message-State: AOJu0Yy4nrhx7PYNq0RXNNh56pDa5lwvZZEMbW2Vkj0Hfc0nj/XgCVkA
	VBIsDXOm7Xq3jg3U3Zkq1fvakXMZo+Sw0vue2qtpaMHYRHv3k0PbBy819w402+xk5erVFqsTnPq
	cik4iP0r0LcCjMQfZa+7+EQTanD+KKgKffq04vzPM
X-Gm-Gg: AZuq6aJJtAqcuuvxGXMVJc+YaXtHJneXB/e7hbh0h5S9zvAMOFAVJFyE8x76cW0psx9
	1zBQ3dBu8JFyyiLvg0L57PtorNj+Xwb8Ogva9qaxyaWe2e4eEE8gv8LdOGmyIJ61HLEpZgbiil0
	iQySjNO0qyhg+KXCDjgI29d/NiRrbtyVjiNXGjgZIEzVsuk+hLxh3pfQSb8U9XUTCKRCrKXr4wZ
	mjAxLo3nQhJkUXSYXHFkEYyzN5rJi2dGwmTcj6pbLjWN+bP5RzBszPEm6BFATbdxxmuqHncihS2
	XPtA0nhkITidL/jQ3FUGQBLdyJ8XldhS6HmM7w==
X-Received: by 2002:a05:622a:650:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-5072df2149emr11811881cf.17.1771953057504; Tue, 24 Feb 2026
 09:10:57 -0800 (PST)
MIME-Version: 1.0
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
In-Reply-To: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Feb 2026 09:10:45 -0800
X-Gm-Features: AaiRm51arY2kpYRFEEBmZsncUFuYZcjm4HWopA4t3Yo2217J1VEhgALCoVmrzvE
Message-ID: <CAJuCfpHzTdwcGh8wXetEcAy-93-WqPmoyDnbC8UhzGttpcm_Cw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and Challenges
To: wangzicheng <wangzicheng@honor.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, wangxin 00023513 <wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, 
	wangtao <tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, 
	zhouxiaolong <zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>, 
	"weixugc@google.com" <weixugc@google.com>, Randy Dunlap <rdunlap@infradead.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "willy@infradead.org" <willy@infradead.org>, 
	Kalesh Singh <kaleshsingh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 98C9E80016
X-Stat-Signature: 7pr5fxi3xbi7wc6sc1f65bhkd1ks535q
X-HE-Tag: 1771953059-879746
X-HE-Meta: U2FsdGVkX1+C1X1x+iRe5hk8yhvXS0J5CTkbLBnOvrcnykdlkKSjMn7lTN4QfsCIDFPlpLD0nA0f+RsPFkSV3rexC3Kh1u8ofxRjDZl7tgXIvbbHPVLypTzkBRkp0vdI8Z52EsqqPwt/vlwHOtLYc54bqnplvv1jKE8x5973G/WRyPUzhRvanmBk+rztx2jgW1JSxEr+a2oWdTIcKqD5teTz4O+jYxtOuWURZDSJXOg7c0oOwX0krQ1+UDSSDRH3SUJ39LRbRsdOOQAfnjgfbInsySwPLDG+ASkz6nCtcakXTWcyeUkDDCKXCDi1Q1xkCriyR2Oor8fTF74NMe8P4WcR4S8kZp9BrMBvN3n18+1WFdjlKj+MVXMzee/VngsGIJBqXKGkxER7Io4oDiNrzr5lz+pnKn74ViRPYeBRENwGFUjlQG8kYu0dHLLmOUiU1nyzjKMRCANEjsI3BFt6H0sAqa6Q8GWldu2PaRx53OuBZd74IDyBGmFHKpIGzFg253ICtVNX3LG5D9UWMKjaa984JXx50Rlux9NANOaA/WZVVV8wDU/4a8b0GWO9rHHG/slSODoRJLdZ8GFHzwzCAFtTyaiwdvhAIyxk7YjyHfulwEZ3gW1Vbp7198qAOkZQnnV2f5px+bSogaHr2idOqqyx9uXyL2Xtk6ACiYUxpm/Lqmj5eI15k2GJrfJ0l3qLY3yZ9KFRln56owxMvEm03RXRcy8M4+wq86EHSpJEQV/xuZ/QqJ+vqIZkx6293q5ls9YJSU2mqWm6O4KnS5NX/tat+fYAH0h3kIPHU32JyPl558j+SwRv4hKt+Y4AQxwLfpTYRrb+mCMaXdsWydgO4nhSdhnfxjKE14ceWnbLZz8ckAx3QhyOhoKcIMZ7XTbWnjy1TbYk9eO9eceIlE/Cra0Wj7EomXnZ7aigERiY3qoa1B8t03dWhqdVTNgXEs+a8nz+0Fa4STdUJ4BewEg
 +faU/F60
 bY3r1hXfkLmeuiUDK76iIiCXfM6+wCZXiB2NVbjIkmjqUg7DN5j2F2oT73FzR6CQk6Pnbg7H4nhpUj9+jkD4i+hdMkcYqVxxFYbLgJUX6vVUm4Ak/YjyLaVCzuf6v8Hn1YYovnip46+BGxyX1IO49j6NzPm+tqnvSegS/SwPUnvoV87xsE4XRkHBQRBunHvzhJ7DfF68uvAmbq1hcRrn+0dBuFbbYS8ngfALbkB6YG34gnRoZQQ7fy1rLlNFYxKyzYSYX6nMGYHxo6qj34jYl6AUnKAKdQAiHfYr/toopE5Tozu+/mIZw0mZ/f9aGmtqX6MKgamGSUulNdXatMGTRpXZQb99kdJGq04bbfhZ7QyJO+7qH2i/f4Zh4ezeeyVNezrtrBeMariv1AKvRkvAI6Hb+3SBRwqAU0L0FHgkkaQEJtrJ2k9rnFk2vaP4pBAU9KqxE0GCSy/sVMszXq008+h7n5B50ABOd7i+i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.014233, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 7:17=E2=80=AFPM wangzicheng <wangzicheng@honor.com>=
 wrote:
>
> Hi,
>
> I previously sent a similar email which unfortunately had encoding issues=
.
> I'm resending a cleaned-up version here so it's easier to read and discus=
s.
>
> MGLRU has been available on Android for about four years, but many
> OEM vendors still choose not to enable it in production.
> HONOR is a major Android OEM shipping tens of millions of devices
> per year, and we run MGLRU on all our devices across multiple kernel
> versions (5.15~6.12) and RAM configurations(4G~24G), backed by
> large-scale beta and field data. From this deployment, we have identified
> four concrete issues (Q1-Q4) and current workarounds, and would like to
> work with the community to design upstream solutions.
> Also we would like to discuss MGLRU's future direction on Android.
>
> Below is a short summary of what we see.
>
> Q1: anon/file imbalance and drop in available memory
> Android apps workload show a persistent anon/file generational
> imbalance under MGLRU:
> anon pages tend to stay in the youngest 2 generations;
> file pages are spread across multiple generations and over-reclaimed.
> Tuning swappiness to 200 and ANON_ONLY does not fully fix this.
> On a 16G media workload we see:
> MGLRU: MemAvailable ~ 6060 MB
> legacy: MemAvailable ~ 6982 MB (differs by ~1G)
> Today we mitigate this via explicit memcg aging in Android
> userspace [1], which is a vendor-only workaround.
>
> Q2: Hard to control reclaim amount and stopping conditions (memcg)
> For memcg reclaim it is hard to stop near a target reclaim amount:
> kswapd can continue reclaiming even after watermarks are met
> (e.g. to satisfy higher-order or memcg allocations);
> reclaim via try_to_free_mem_cgroup_pages() lacks clear abort
> semantics and can overshoot the intended reclaim amount.
> We currently use OEM hooks [2] to early-exit or bypass reclaim under
> some conditions
>
> Q3: High reclaim cost and long uninterruptible sleep on lower-end
> devices
> On lower-end devices, reclaim cost and latency are harder to control:
> throttle_direct_reclaim can make tasks wait for kswapd instead of
> doing direct reclaim;
> sometimes the target generations in many memcgs have very few
> reclaimable
> pages, so the CPU spends time scanning with little progress.
> We observe tasks staying in uninterruptible sleep in try_to_free_pages()
> We haven't find any proper ways to fix it.
>
> Q4: Lack of global hot/cold + priority view with per-app memcg
> Android uses a per-app memcg model and foreground/background levels
> for resource control. root reclaim lacks a cross-memcg hot/cold and
> priority view;
> foreground app file pages may be reclaimed and reloaded frequently,
> causing visible stalls;
> We currently use a hook [3] to skip reclaim for foreground apps.
>
> Discussion
>
> - Vendor-only workarounds -> generic mechanisms (Q1-Q4)
> Our current fixes (userspace memcg aging [1], OEM reclaim hooks
> [2,3]) are Android/vendor-only=E2=80=94what parts should be turned into
> generic MGLRU/kernel mechanisms vs. kept as Android policy?
> We need guidance from community.
>
> - How much control should MGLRU expose to Android? (Q1-Q3)
> For Q1/Q2, Android has strong fg/bg and priority semantics that
> the kernel does not see. Should MGLRU provide more explicit control
> points (e.g. anon-vs-file / generation steering,
> "target amount + abort condition" memcg reclaim) so Android can
> safely trade complexity and risk for better performance and bounded
> reclaim latency (Q3)?
>
> - MGLRU evolution without memcg LRU: global hot/cold & scanning (Q4)
> If memcg LRU will be removed [4], how should we maintain a cross-memcg
> global hot/cold view and per-app priority on Android?
> Given that much of the power benefit seems to come from page-table
> scanning while generations are complex, is it reasonable to decouple
> page-scanning functionality from MGLRU and make it a seperate kernel
> configuration.
>
> We are happy to share more detailed data and experiments and to help
> with PoCs and large-scale validation if there is interest in
> pursuing these directions.

For obvious reasons I'm interested in this discussion. We also notice
some shortcomings of MGLRU and would like to collaborate on resolving
them.
Thanks,
Suren.

>
> Reference
> [1] https://lore.kernel.org/linux-mm/20251128025315.3520689-1-wangzicheng=
@honor.com/
> [2] https://android-review.googlesource.com/c/kernel/common/+/3866554
> [3] https://android-review.googlesource.com/c/kernel/common/+/3870920
> [4] https://lwn.net/Articles/1051882/
>
> --
> Best regards, and wishing you a prosperous Year of the Horse,
> Zicheng Wang

