Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0610BC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9294B6B00CC; Fri, 17 Jul 2026 13:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9876B00CD; Fri, 17 Jul 2026 13:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EFD66B00CE; Fri, 17 Jul 2026 13:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 459B76B00CC
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:27:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB76514015B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:27:48 +0000 (UTC)
X-FDA: 84998951016.24.2BA5336
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id CCF01180005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:27:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V0foVGk0;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nP+ERT3+kKuGzYG6wUyZ7uxfvv7Dz0HnBqVepPGu9uY=;
	b=k6FgVCg5TJYbqRF3zVktXM1GZJlCMmnNfc9HRPQIYDz8ZE2hRl6gu6+SRubl57nufTpVxL
	O4APV9lWdPEoeQ+Ekyqbc50WJbX5RVPNsGohWptAfkfCfqTF5AqxCw4tAhUwWvcq//EVKc
	YtiiiSITa2Xr3vumnO3eol47sWoXUdc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V0foVGk0;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784309266;
	b=WppWxDGqtOpksjuU89JFfSsq6xre6dL0Ctk/4FYhisr+xTrLRPv4AK6M9zXKuyyF1uPyTP
	qj272cpfIiA2IiaWH4QuIxP9Sd6lsNZ4SAtHwPYMRIIZnbCiMxNw3GFjLlxkjE996WNBjN
	s/KRwFbEnsNGTu0EEQU8s+2gOadzuVo=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69a45011a92so17735a12.0
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 10:27:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784309265; cv=none;
        d=google.com; s=arc-20260327;
        b=Jy/3WEMPUKV6rSQy8Hvr0FQOxLvRun1WAkvB7qCcQExxqJApmZi/jf1cpHScONBxdW
         ggIZaEXKHY/jJCfF/5xsck1vThLDQ9Wg9cgHWrydbc4pj+QzcaXrBn8se7VLgrF8VeYy
         M+erO/sAUTrZcxmy4kqbQvIUxIpvdtaTx2sLeuIfbtCUC3DS0WrtyGxhlFFAY5p9hIkD
         93OJta7MTYbyZ5BYUDxtYSD2kBO09JoZNhesu6M7eocryTolVGElIJBV+T/5Nmb5qiqB
         J+DmmmL0gIwA6mmPztomMSXiN8wrbVvZRfar25FPVg2X7JGfi85s49/tztCOzc8X7pLk
         tsFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nP+ERT3+kKuGzYG6wUyZ7uxfvv7Dz0HnBqVepPGu9uY=;
        fh=0bSN6tyVWED1PMMWbvlakXNhQ6kOVIjF4nd0b1evrzU=;
        b=OqghqsJMwhMjOQvvd5sUM2d9cir6qJcbDuMpww4kL6oTP8ICuBv+DADA5rGO6cT4Vf
         Fpf8e2jbxnF+R0VRx3mmJQWRIJr82IgTC8l990p15gbQJ4PWxkWzfqKreKNosYEutofY
         FQLV7dqSDwml82WTrDL5Y4cB7bluBlX50q2QtW+h4ljZVKfOd47CSgnx101ce7qCnLn3
         YGTE9vyRZ7+WuYk538+SAanxOw9eusQGZixzKdgojyPmc4maSzuqgTzf1ETOYwMiPiVV
         T9dHIchkfqVbkyAoxkPg6wEE0ZTpkXWw6wf8YqnNUrgUahBFYLaP1egUxpf+7iKEY6hf
         cR9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784309265; x=1784914065; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nP+ERT3+kKuGzYG6wUyZ7uxfvv7Dz0HnBqVepPGu9uY=;
        b=V0foVGk0OQkFYxiOnrBDDDBx2Iq62SAZ5iI46oSswb6WVF3zPpfQBQ8PPkElbnVcvi
         1+tgEszZDPvVKifPUbKJU5eFMkEaaiL/+AQLRjIrsz3nDrlao58RjOdbilHQAgmO0MjQ
         DBnmHCPMA1cW8pC2zAszVSBt52Rxgn3VJyKGg7PILaXwMrifuch4pj+SsQrEIb3R1oeb
         FaZ81uTjy3B7EpLeI0Ed8a/zX5sPFu99Dw7u20ZNZWD4OeYt4GwrB8BJvfHv6Hm5Zdbo
         yFkHy7NVbelMeKtSejnh+gedCExXblda4ElBmfDrIzlO2BS5IRfvsDrnaSHT26Enxnm1
         +Kdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784309265; x=1784914065;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nP+ERT3+kKuGzYG6wUyZ7uxfvv7Dz0HnBqVepPGu9uY=;
        b=c620ziCj1Mt6sV1ct3+fVn9bQHXj61+3Idpks7BSxinoH5QvSxk3gN2ou/vO0JtUGR
         GEb208U8uvZotTthGPQ4+4ieFJ0d+zzwEDBK4mFDoflB7IkjKh50zzd+8pkIp1oNSOGl
         uZZvut4XbsEiL1OPmvxxDAMQr7GIQTqWZ1GWbSZoN1K6io5KGoD9upx75Gkbx3AONPZQ
         pWhK0OXd1MIN65ObDABcm3FRBaC7ZyqpQHzv5BGVxFKvyRM3aF4u7RdDLf53S4dce7q+
         jd4L6IjpZVTxhkpibGbffVOlxP77n2EhO3JloxQrczsIN5zKOLx5n9mup52psbIh24mo
         3pYw==
X-Forwarded-Encrypted: i=1; AHgh+RrKNer3l+HdmHAqtMderMHcyapDzcZaqR3vluI6dPwBiui6fvpyAWo7DlANapHzV6u/iyflOMsgSg==@kvack.org
X-Gm-Message-State: AOJu0YzWm2QizbIzjeV+L3xe/8MBFLT+q1Rl+tDyoiEBrsXWa7QDcwW9
	bIorHK4a5PH9V+E1+pyNnIseykulB+7Iy2H98c324iMqT0uMSUGWyBVNbxTsSbfbEYtJQVcUOia
	nlvB59Ztn5DvcTVl7r449W43SbiaXbZF4oHhQxqHL
X-Gm-Gg: AfdE7cnJWgg5MgmOJO6/xOedcnrsGSik1QekQqQMMH3R09JmGAfhagRYAiSrTK4RtG9
	XbbqbeIcmUGbTGFeMzInTn8eT+7oJwmYWJO+Ul0E5qv6rfx2h6j0o5HB4s08509f0i+8La6o9GW
	HQJU9vvgDt7hbHooQWTof/mAX6dbOk11u6T95XXt5t7eniUjFglnwdO68Uvib8xs/zysWmIRefE
	ikBo3x5SRpygpYkIUO0PYBVIIQB4Lssfaqx2a9tZaWg3PyMza7OPY/CzqloLkUSDdvgTl1DBdzU
	j6qABFR2glv0nkVg
X-Received: by 2002:a05:6402:1244:b0:68a:e1ba:9cc0 with SMTP id
 4fb4d7f45d1cf-69e89ac9e37mr3047a12.8.1784309264850; Fri, 17 Jul 2026 10:27:44
 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784268206.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1784268206.git.baolin.wang@linux.alibaba.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 17 Jul 2026 10:27:08 -0700
X-Gm-Features: AUfX_my4s_cr8cST07zBhBCtOyb4QtTLMfg0xmNqIQKs6yFJtts29MFsAI7J6Ms
Message-ID: <CAJHvVch1nyWbOpt2PV57UFJNg=Poge-pQ17dYrogvO30fYuNSA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] promote mapped executable folios after first usage
 for MGLRU
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	yuanchu@google.com, weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CCF01180005
X-Stat-Signature: eq5mxyse6scug5brrsuwypxmuoqjxatz
X-HE-Tag: 1784309266-817633
X-HE-Meta: U2FsdGVkX1+TkRgWb5bTsDS98v9Sn5KzeQmf2MwtTh5yJXBHPtELhP4Ok582Mmmh4zLp2obwSmBBT3me1kEEUXAUtqrhCOJXWRjXsPC+6uqmIH4eRYXAaUvt6LH8L+SttZi/S/Hoiron8yBPTaoitEkmVL4o7T0Ve3Spn/P35P4LL9XAHRvUPzjElXJpEnF4ZYkAah3Q4l1qA5z/j5DZPNCW9CuPu3pFyMRnz31Uy5+R0mOlS0lKx7VTHFWgJpmTckj1o4E0FXRuOJZaBwhMbfKbXC+bsnGruJC9Fti/CjnOfYENuR8qAbiDF8uMNZdi5c3ekyDdLcCutCpCZzDjHyJjNu8mC3cxmUVJmNFnewv0hO5LTxNK3P1+zbt0vnxV6LIOoTvSUjQJwAozrd2JYAaefcAzL7aaHwYiPdRfzR9a9Ybery7Lb4rP0CygLJZiI/TDSxtosg/qDYvdzEr0yNtX4kAWe7DLcmG0qGNnKJV9RvZ8EWlWqaYk/shtRWIm3rKXC/A+DFymgFFBWS2gGDDNrhqueq6CnYZve4VEXSE0laxlLnYiSkHdAkJ2p0ERVHAuEMFtv9Jcd+nkRjKNhfB5bobpFIr5v0KGdRPsAhv9R4garocCK3wod+J2ClV7h4w5iiIRpbROGX7EIX470Nr2hW0f0Dg4YqXXuMYP/vgjP4QtlQ6uBvupk2C0b33vy7FpU5ewrNyKRNlfJp7yLj+bEI8/SDNZhNGFHl0o1/BoAzXEnJuyTdmDUDrPDMju2mRZ8Y56mNoBd13udwihpVPLP5PWN6DDukZq5xMmGkeeFiLrcjj5u4YsJ0S99aWKgixq6bupTFuVxwyFv+YCY1DlvP4BDgSaPzE0ASSQvzY7lAR/7FLuCJQJNmqtgQ5MTI956xpg2etqAki+DDhvckiUW1G8l8JttBsr4sz7128tc+q5izjcdwXoGhaEzh0Jni48LBOpCpWtqgxhLjt
 nQPpv509
 BaVzfMPbNztb8rtj8+4STRzcR3Kjm9HTUeypX8vKQgpTPytsCeffzFRU9pGcY0DJz0bBLK2f7mZbMieybH7s3VLSzakaQkIYZaGQgllX5QISWqVDxyTT5urEZxeuVeyO/b3J8Mh+KB5NN/HjO93mHBBNE8l5ugT1Sa/+sTr+VDICfKv/N06t1lDv01YOIPDUWeyCVM861rRF/YH5VISV/jPMG8JQbJl9Jy5nLYFrX0SHzH7HWkwznJUs1K4b8K7AhRfUk21jg0qM5c4kw2l+0nJjBpKfKu/jeH3Lhv/TlPD5BUpyEO5vUbgdRkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 3:06=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Now MGLRU's protection of mapped executable file folios is less reliable.
> Follow the classical LRU's logic, promoting mapped executable file folios
> after their first usage to give executable code a better chance to stay i=
n
> memory and improve workload performance (See patch 2 for more details).

Both patches look correct to me, and the premise of the functional
change makes sense. For what it's worth feel free to take (on both):

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

>
> Changes from v2:
> https://lore.kernel.org/all/cover.1784197559.git.baolin.wang@linux.alibab=
a.com/
>  - Add acked tag from David. Thanks.
>  - Rename the exec-file-folio helper and move it into vmscan.c (per David=
).
>
> Changes from v1:
> https://lore.kernel.org/all/4b921ed528c483e13c9e22d1ae44ba58b4a15b0b.1784=
096432.git.baolin.wang@linux.alibaba.com/
>  - Add a new patch to clean up vma flags as preparation.
>  - Add a new helper to check exec file folios (per Kaisui).
>  - Promote exec file folios in lru_gen_set_refs (Per Sashiko).
>
> Baolin Wang (2):
>   mm: vmscan: convert folio_referenced() to use vma_flags_t
>   mm: mglru: promote mapped executable folios after first usage
>
>  include/linux/rmap.h |  7 +++---
>  mm/rmap.c            | 19 ++++++++-------
>  mm/vmscan.c          | 57 ++++++++++++++++++++++++++++----------------
>  3 files changed, 50 insertions(+), 33 deletions(-)
>
> --
> 2.47.3
>

