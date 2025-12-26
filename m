Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF89E8FDAC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 18:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932306B0089; Fri, 26 Dec 2025 13:32:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF966B008A; Fri, 26 Dec 2025 13:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809A06B008C; Fri, 26 Dec 2025 13:32:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70ED76B0089
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:32:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14FD512B76
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:32:26 +0000 (UTC)
X-FDA: 84262467492.10.862646C
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 41422120012
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:32:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eguVOvY6;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of fvdl@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=fvdl@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766773944; a=rsa-sha256;
	cv=pass;
	b=1mmAHGvicNM5b3l+wjdr2gF4Gf1/2EgfNeU3TY4YnxUhegOqsu5yuHl4bL6DwHcKuKJYy/
	V+w/4Y1QS+YbxFCTt17QZy7BhxYmXSLwQgE0xhIAjuI0dT42nO63S75GOZePghGDiJ6R5a
	HMU22/iLmfZWvfK7JWOKIXN4UGdY7M8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eguVOvY6;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of fvdl@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=fvdl@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766773944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TN2DlxyR37XyHyze4Nt6qS0Z2cpD/q+OiOkA/HCTPyk=;
	b=b/7cyheuKNqwgK+LXDgiGJo/RM+ql7LBJLg8IINtEUnwv9ZN4zF3h28lr35Ya8xUBWkesK
	Ieq9nNotz912VmC8o37xryY+0OAB+K0BMAJMYPS0wIIUtbQF+Gkbv67ZsntMkZWClZjfU8
	T3ckEmsaVNputH8qOta9DMYkbcTssgk=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4f34f257a1bso2464761cf.0
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:32:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1766773943; cv=none;
        d=google.com; s=arc-20240605;
        b=AmNQhcYCOd1I2IYSYesP5WO6O37r1cbXNVBB5XpVtFQhwJX5Z9raTIoPFryR6Ec+FA
         j4KNqUHFfdSaLqKP/4Tg23oTYce7D3l9NCO2b/Xq/yjE1ZIZszZcdgQeF9Aj/gREybwX
         ljzUzqWk14JoN1fOmETyTGd5zG15LA7x6spVsYkBtTI4US30vuuxoTOKIjeqGel1h8+k
         LWKEgcKtHKiyoY3a1vEFDk07vYM1ONkuJQhEfSy/1OxlDlG2eLICT/axa2F/cBgpV8Gi
         J66lWqkfxpKCGVLiEUVj16y6AlIo5TwIet7bqD2xgQGDz2hg3osOkkW343ZLQTEdJEzA
         BH6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TN2DlxyR37XyHyze4Nt6qS0Z2cpD/q+OiOkA/HCTPyk=;
        fh=CEIFlI2Bwnbysvsyu/VA2bfCqXnMSz23ewgr3eczdz0=;
        b=NJVhgAAtltpLXLtZXmSKF2vqO5UyOcZdQHtz30vewM7r0HH6IIRZ0DlJlliCgxqXHM
         Ww2b+b4lAcDbSm3OoWqSnVA1Kh74/EIv5SlF1411lRYdCdaKthHmqYVtn4pzXUBUTown
         9TKL0fTabHe1V6xW5CHOmJlapH2/CcGfVQxGDGiF3+rToukSmMeX6ZN7vQGutLI7FugW
         8SJ6Mw1OJH3z4GRleR6bjARugNsafPqs963fCziSjOlHtZ6km3qGdXS10uN6hOxHxLQP
         9/kqImVKei0UFhyKadgJR4C0cgP7r4+6RCtTH1pFrVvTh6IYlUsMCt2SpyQQEmXhbpwi
         Ngiw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766773943; x=1767378743; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TN2DlxyR37XyHyze4Nt6qS0Z2cpD/q+OiOkA/HCTPyk=;
        b=eguVOvY69MpS9JAyfJqO0JudernUNFv3hijjZY1g1geIZh6c9wdcpfQmQHM3ZM3DAK
         lZEdlpxEUou0HcbyDfiZ6MMw1V+bmGq+WtloBoG+RcE6TDY1sQECMFq3Ml9hEnHU3fgG
         8UX1qDJKVjg9QjtmyPYz5M4tjd+y+oe6vSv9ICbI3JsHFDBNQcm6U+oiJ2rV0fHrdkFn
         f+CRJnFJ+sd3NVGdtBei+Hkq0+dC4sKNIq/aa8G9410fxLMhTEAd57xabkD72iocSm0x
         SMt3VmZg90SOJim4KTisbfMBHAFW4xyX17J/AtmV2hsPZxquzZ7SW9GOaBfUYmAiuNyh
         1CPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766773943; x=1767378743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TN2DlxyR37XyHyze4Nt6qS0Z2cpD/q+OiOkA/HCTPyk=;
        b=eV1smfrW71XldQsmLxNTCdYiPhiu/ZQgUOQC2iiO9EpT2BQDXh8nxASMvvUbWYYLTB
         cJ1Pl7hRsUO3u3Ok2JUCMoYnuDasqMFDgeAYG2vXhI8tctdNeK5aRHXVKczQ9eZiJbtv
         2OB+x7MsyC2NF70RJgnNB7JHjmli5RbhO3VCi2lqyxlTS1f+91ZebYIjR6Fc8Zo0Jzg0
         /5Fado+3OCxw5+jhvrooMQ1R8vNT0K6HZIWv6iys4hen0Q+BJTV8VPryfInJv6vV2sAB
         mUtsNnFQROETE14QSFYxIV0gZRk2w54JuhGdYIqQTmTwaOyGF9lk5Cxfqt3TUp0C0/iC
         3h0A==
X-Forwarded-Encrypted: i=1; AJvYcCX0/ylQi3uGvpzN+uLS3RG1nwNePYJsYfTpVa2A7pZerKQtvagD3bXYIEN2AQh8rZf+AJ1ajoioNw==@kvack.org
X-Gm-Message-State: AOJu0YyvnGVXkeosRzDEFGcw8F41sh6YhR1ZZA927dI6VoZXHWiKNMNa
	gHSfDtA1EYMxb4hXKZpEyaNNiONHMivJNgx3mrePGkdXGAnN4O3NOvaAsQhISdh9h+f2KOy8ZR5
	EDY1ihPkkIzqqHo2WMv3IuyIJLnpw96Uy44UO1RQ4
X-Gm-Gg: AY/fxX5AX7w+UGQvZazZi/g1RkNRnhOsHtGk3gxGK6j5ggPePRok0BXonFWyrA4HM9X
	E/ttANxb0CQ7yh1PrlH4I4eskjSPPiBfef+0UtHBA5q9HxWB2B1wDm8xmI1LiVVS6XQeYxJTVI4
	fcdvzC0FmAAtekHkWAVrNtfIiknTAVkKRTElvTsOCTQk9KJvwRdWqnh9El/eUlK2NpDnsr+PyhB
	PcSyMWSeEtHdx3K2Swm+70tiYesGzure2uMLXhsMVaoPUT6xFjzFso3Jtrsiw87oLsVbzI=
X-Google-Smtp-Source: AGHT+IGN+z66uUikrBVNeg3A5piJ3z4guyft1ZEevN2a0zGQ3FeKtZo2JRk4VhxbvgfFtKcUhkNdzFEq7idsdTVZcRk=
X-Received: by 2002:a05:622a:14d4:b0:4f4:b46e:34a0 with SMTP id
 d75a77b69052e-4f4e5f62fb9mr11971721cf.5.1766773943154; Fri, 26 Dec 2025
 10:32:23 -0800 (PST)
MIME-Version: 1.0
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
From: Frank van der Linden <fvdl@google.com>
Date: Fri, 26 Dec 2025 10:32:11 -0800
X-Gm-Features: AQt7F2pV5Qob1caVeo1ftkCOrmoAHIhNaN-LlJ-ltikJkbnxZ0HEjlFwEKFq0LI
Message-ID: <CAPTztWaiDDvgq1Q-GQjGO75Ujy30qy+m5wQXuFiTPmRLEm3aPw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Introduce a huge-page pre-zeroing mechanism
To: =?UTF-8?B?5p2O5ZaG?= <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 41422120012
X-Stat-Signature: i1izyoydanycu3sycp8a3uym3n691p44
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766773944-769300
X-HE-Meta: U2FsdGVkX19KlYNkv3ZkTyeyufON8Z2kQu2qCSRXrR5SemV94YMSSmM9hLM64VGl39j2xopVP3T3e8mHBiNoeRF2/i5NzlNisvmuvfwAape+BOQKHksTbOxHIYUA+2Al/lbtw2f6wiNEDZXOmPkBNNLUrJPN1U/UsUiTvopLrgQc0Gi8uNWMXT3G3P0bF3ZvoHLKUSIs480XY3W+GmrbHMFhs9qF9uPZ7c3/kXUCY/qR48FvreDJJ+Hkyr4VAbWJwNgfKMihAWHMFEonP7GLvq5T72poV1n3MvcoRSKvQzt/2hXA81gETv9/S18frF6wq5I3VjQJvv560uO72OERvcg/x9DAJGjCgHKVJrTnyf9fIJGCzOxlypa2mJtjwun1Uf4Q/xWtp+IkXKRpJ0uKBjkRFZPkMmBEZbOHbgFBY5Uz57190/IU7Ym3A4yj6MA5eMTeBk92R90ejxtkEx7nmikW3BY/jRixaiTtUVYD62c3/yR9U+NbT7wX+coXO+o43tBR+/Kd4MRQGw58gZqL+DJKbp5QrJivI7OuJctP9zfQcK8ydh3PDMN+WGBt1VnHcHAognmaiCoDICOdISvr/y/c4mMqsN27JCUOf9GnmXsdZg6VrnRLLR+mcYWuXAKCnhqAnJiLd/s5/1WR7ozkbi/jpG72BOcBMVktZUfbBpqQH1WhRhBOOlAsz3Khm9LOrY5cBZefpARFR15FEI8VrZ9vDjk6JIHr9vBvjwoY1JmO0657+/SrdMr8088MjISG8OeSqPicII4pFN43MJNkvWOhe0q2sgOxzT0N97cbF/KygcUvPXetyJDByjtTIZjdDgEWqH3JjcB4t6hs9DFpmgeOpe67BkNEoZAtA7YMEIgnbpiLvrOtAtWlYQMzD1aWP7ikn8aj+ZKWZmFzPnoWGC1ISgPUCqkezNi5JFcJSQiS81FSJjNRRIJMvYImClKdwUuGK6YofRg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 25, 2025 at 12:21=E2=80=AFAM =E6=9D=8E=E5=96=86 <lizhe.67@byted=
ance.com> wrote:
>
> From: Li Zhe <lizhe.67@bytedance.com>
>
> This patchset is based on this commit[1]("mm/hugetlb: optionally
> pre-zero hugetlb pages").
>
> Fresh hugetlb pages are zeroed out when they are faulted in,
> just like with all other page types. This can take up a good
> amount of time for larger page sizes (e.g. around 40
> milliseconds for a 1G page on a recent AMD-based system).
>
> This normally isn't a problem, since hugetlb pages are typically
> mapped by the application for a long time, and the initial
> delay when touching them isn't much of an issue.
>
> However, there are some use cases where a large number of hugetlb
> pages are touched when an application (such as a VM backed by these
> pages) starts. For 256 1G pages and 40ms per page, this would take
> 10 seconds, a noticeable delay.
>
> To accelerate the above scenario, this patchset exports a per-node,
> read-write zeroable_hugepages interface for every hugepage size.
> This interface reports how many hugepages on that node can currently
> be pre-zeroed and allows user space to request that any integer number
> in the range [0, max] be zeroed in a single operation.
>
> This mechanism offers the following advantages:
>
> (1) User space gains full control over when zeroing is triggered,
> enabling it to minimize the impact on both CPU and cache utilization.
>
> (2) Applications can spawn as many zeroing processes as they need,
> enabling concurrent background zeroing.
>
> (3) By binding the process to specific CPUs, users can confine zeroing
> threads to cores that do not run latency-critical tasks, eliminating
> interference.
>
> (4) A zeroing process can be interrupted at any time through standard
> signal mechanisms, allowing immediate cancellation.
>
> (5) The CPU consumption incurred by zeroing can be throttled and containe=
d
> with cgroups, ensuring that the cost is not borne system-wide.
>
> On an AMD Milan platform, each 1 GB huge-page fault is shortened by at
> least 25628 us (figure inherited from the test results cited herein[1]).
>
> In user space, we can use system calls such as epoll and write to zero
> huge pages as they become available, and sleep when none are ready. The
> following pseudocode illustrates this approach. The pseudocode spawns
> eight threads that wait for huge pages on node 0 to become eligible for
> zeroing; whenever such pages are available, the threads clear them in
> parallel.
>
>   static void thread_fun(void)
>   {
>         epoll_create();
>         epoll_ctl();
>         while (1) {
>                 val =3D read("/sys/devices/system/node/node0/hugepages/hu=
gepages-1048576kB/zeroable_hugepages");
>                 if (val > 0)
>                         system("echo max > /sys/devices/system/node/node0=
/hugepages/hugepages-1048576kB/zeroable_hugepages");
>                 epoll_wait();
>         }
>   }
>
>   static void start_pre_zero_thread(int thread_num)
>   {
>         create_pre_zero_threads(thread_num, thread_fun)
>   }
>
>   int main(void)
>   {
>         start_pre_zero_thread(8);
>   }
>
> [1]: https://lore.kernel.org/linux-mm/202412030519.W14yll4e-lkp@intel.com=
/T/#t

Thanks for taking my patches and extending them!

As far as I can see, you took what I did and then added a framework
for the zeroing to be done in user context, and possibly by multiple
threads, right? There were one or two comments on my original patch
set that objected to the zero cost being taken by a system thread, not
a user thread, so this should address that.

I'll go through them to provide comments inline.

- Frank

