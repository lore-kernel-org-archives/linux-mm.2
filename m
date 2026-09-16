Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56825C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 03:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA4F6B0088; Tue, 15 Sep 2026 23:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B2A6B008C; Tue, 15 Sep 2026 23:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8D556B0092; Tue, 15 Sep 2026 23:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A98746B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:04:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E57AFC052C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:04:57 +0000 (UTC)
X-FDA: 85218133434.11.E9CB85F
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf02.hostedemail.com (Postfix) with ESMTP id 01C2B80007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:04:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=prGsO16p;
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789527896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNcs5b0+flkxyF/2A6UlNYIVXcCm2tD7ZxippPqrmeQ=;
	b=IE9VkCFJ/HeL7oeAUd6XuZydKndgGTmskX2556S1XuN0SNv1zqunGJd7BBAEQkl1OvFDPV
	w6lRc8I7bWy8OhgbrvK0kAl9+Ze0miGdBGy550d/cEDoAJfGnAExi0t6GRTBKBlI1wo9ss
	nHc2EeK0bVvxYf5CriiRMPOU9P9d2bg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789527896;
	b=yEAD5mVRUtAa6ISEn6Zj9uYpAzPKD1IEwnyK8N5ACXo4HEJCeTCJzyE2yKAr1BARTJ3V2k
	LFcva2j1jADFFb/Hq6YLJrh/p/MqO7IPULpemum8CA4MTGjsxUrh2YEB5iB2dfEYGgJfBP
	KBjqLWQUD6LapWqaq3XxcIIgmLQ8+aQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=prGsO16p;
	spf=pass (imf02.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e721b5503so4716465e9.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:04:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789527894; cv=none;
        d=google.com; s=arc-20260327;
        b=X1G+up2Y8+e1ewoJq3FEaY5Ob8Uc2848XKeEx2f/eN9v87n0k7EHMPpsX7gQD8hNAc
         5XSo0Fvvms5/gRE1ieKw7dgv0E28IssPa8VUl3Gldw9dWw8+VTKUYdzyIphPxoZYjq1C
         Xw7Nil6KDaVaIZBXwHVhiD/LSGFFG2dFFJ2JeKYLDGLOCXvsDq3ZLnpGIcNS1V7OGnkW
         z0cGcYaFclRif/l7/+CXdgykw1h9buS1WErtRWYxBAvzg5ti2Y3J11vzvIjQ/wdZraQB
         Hx81gHvKhMmxbtA/T9ahzkdQA94IkvOCluZyPexCXVjpplU/XJaWR5fr2LBh3LzKMBh+
         kOaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FNcs5b0+flkxyF/2A6UlNYIVXcCm2tD7ZxippPqrmeQ=;
        fh=AURj88uE1Om/McI0jNIIXfqTuj2uK/zav3/jLQbZ4zw=;
        b=eYxOUd38VVCALJ80vp+NFhgkCHMuQSH9WYKpWFDrgShREIpDcyNScTPE34y3CgPgYY
         B+o6YWLoqHguZZQv37WuNfDRMNlP/4dQXKhCHOqhd2PHNhXRuhT0WToiRUifsFFflyH9
         kbYwFGUtA7B7n9dPRmewzAXtJAQBycUCD5Iy01T2z8ByAPKC6Tnanm18c1PgkQAfsI3T
         sEeM4y1nVWsm8FCDOOdWFzqJBe2kwLl5NglIAjM3KAd00OozNsOS63y08MHxOFzCe6vu
         q8TTRjR90OTGHadDw2OwXcLpBwoiLKK/mIqvdBSVvP3jIyxxUQqduf36MiOkp7hsa3EU
         dVsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789527894; x=1790132694; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FNcs5b0+flkxyF/2A6UlNYIVXcCm2tD7ZxippPqrmeQ=;
        b=prGsO16pVm8VvXQTO4FGCWQAjrX9zNlHCW6t9GFE+c9wYEvyqNwMmslecrdCp2cO9X
         /QPPb9PO3cC9MIQcruYFG9tp5we7+e3lMQbcYxkUnly0TCg6iBF+8YSpsS9S1t8qCegN
         nL8IhVug4rCjxIVDHlJkGnGSzS3ai4VXyT8E5WaH5sDscupBNcJtCcgEe5n62d54RXpZ
         r4bIkPvzohjSXkdDu0tGhmXz4Sp50UEgzxURpVFaq5quH/B+qDaj37DagWRtIZr+Z8g3
         Il+9IQDCQYBakp/9i829SchB8WAQJcbRaE7w17asIq++POf2sGCROKiCkEQa2BPYf/dm
         6lcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789527894; x=1790132694;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNcs5b0+flkxyF/2A6UlNYIVXcCm2tD7ZxippPqrmeQ=;
        b=czOMnNq/tli8XDnZ8FQ4cE8YtHBedgv9FuqsgCzbXXbuttmv7XK/Rl92Il+2kWIoAb
         PcK7UG9fPBrWbKkUuGGDtKdxwvWSjei9QeOxtVobDUjJHEmSv4i7LWAf9rGnYb2onpw8
         d6J66CiK89liDxRWdnUz5ZDlZS2gT6tJ/dlOxGVsr7/eMoHQXXGPSNGu5oEWBMLseIW1
         lHcadmEaaxGmBcu6EjLuTSIMAwkLlVOXXKOuAIRpS7a9al0qeGfWu7JaSmfcLETryCQt
         3QUOVLhpoPancfzXelohiB6gAr+g+bTAnfBktpIZ3KfL1dMyzs77AneHDgcZeIZIrPGD
         JcGg==
X-Forwarded-Encrypted: i=1; AKwUvBykmO/XYhR+942K9tGjm7j+jl8fy7KtP7G1o5sVwWKgeup5QWPaMamTGbg/bskaiJl5I0K46/qbfA==@kvack.org
X-Gm-Message-State: AFuF++ku7N2PKiu6NYRCXgfYb77RVMe21NjVAOsD3Uy1ToIb3XE7O+Jj
	oDVZwc0gv+zUmBjgGu3h6tuMCChrJdRwq5NhVI4q6Y3oGwhfwooAnxlO4E3wszHP4HxHUDQEXnc
	IK28VWXCCDEpD8w1hIOEOYPX/M0DSc/4=
X-Gm-Gg: AYBFou1nEubkQE+EWq2QsDy7hI3c+2WlYFu65Rq+gsTar4eyERDSRohnHiiciI1OvYP
	mcFCaSKVmNsuAmEYsgBa+mRWGnDr6JZssh32L5khJuSXti/gmA502b613FI7eK1HZRUPYKf/m1P
	0Rw04p1MgtoYtOVwVHub4BdQOZVQ/gzqBQ53XNxWlxHXWNP9AsKgNVBQoy24F9MSgumIiKx4QEl
	egdLQDGMK98XMoZSWZdC4pbv8cC7zFJjbPhypq7edCv0fx3aNRXOvOBjgmvpoubVgbvNeINyD3B
	LVG6fuW6CnbiLteVxmKl3mMvIQ842VkCw7zS1QLOiio4WBQfMwp0z3L2/wT8vWb5YCkka94ha/9
	+toNdmCudTL1TUPQ=
X-Received: by 2002:a05:600c:350d:b0:49c:fc6c:be0d with SMTP id
 5b1f17b1804b1-49eb732e3b2mr7259115e9.19.1789527894329; Tue, 15 Sep 2026
 20:04:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260913075014.1732524-2-hebaoquan@kylinos.cn>
 <20260915100308.1599989-1-kunwu.chan@gmail.com> <aqoEVyxikqQ476IS@fedora>
In-Reply-To: <aqoEVyxikqQ476IS@fedora>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Wed, 16 Sep 2026 11:04:42 +0800
X-Gm-Features: AcwNN1UTsGwChzZ0QocjkEw-cF_hHSS0TI-2fHXvF2dzuUqmP2ZSHZ6lt3NUjbs
Message-ID: <CAN_Opa-cx24WX6Xioyu4fMUOqJH=_F8kJ2yB1cATa9VZ8-j9QA@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mm: xswap support for zswap
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, Kunwu Chan <chentao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6mx9qohishte7ng178tifkq8dq5pxphp
X-Rspam-User: 
X-Rspamd-Queue-Id: 01C2B80007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789527895-11358
X-HE-Meta: U2FsdGVkX193DgoxFCYWGnkvsNC7S6kPp0/90DE6s/wJTfu8rdCaUqbN0PGV18MelxvzCHh3b9vk7WREalLzdHzlLLSBxW6nQFhvxXHGrir88lGL9mt+w33zEe7CE+PDQpzvsdIhjRDob87ZcEPx+HJSa+x2+oO5UzyTNYTRMLRAzyPvhhFR2uGb4Mt3t6oi7bRFLc6/Hm5aO/n+2qj27P9OF4M1q4xOdckZCROfUmRyx4gg3n0sUjyUP05Hlk75X39OSntWEsn4Eijej+7nr78/gQPJ7+uTrVbIFeUG7BIllbKDJlI71ucIkdEeWYDmIGK1rm+pUufijZJ5UUEnxHU0JVjObepoz0wyAV9TW/qvUjr1t3kK0o7WmM9FfWrTaZeVpQB5GDr6hioLCQs27ymc1kfAbdUx/rJKAX9+d1j8bfbEHl1Ne7uOLwG7jUIv0RRgzWPn2b6ov//yLSFzAsCuKdcWNU02N9LhnJV+cNRpnIPjbKETuwmh8MzXMa873mLgzjY8+0YF0novXK4pkGYKAHqB9C1mIC4Rt0SnpVVEJgU70K5ZeBZ7XfxPBo0h8iX6FC4Hujqovt+VwaFjpcx76YwZNLBWaV5DgqW5dmLEw1s94vVDJKcaPcfwhcfCOpmCwkyL7dpOjHHfH172jh5tjokLQWKrtSSLBiDpjqWSBoMK+7I2hWVrcVFhaWAM91rDjxsWijK9OFSZeygr77yi7QY08K2R8IVVJZiv+ZCNmelfLpV23wYHIKE+zwzn51F8f+f7csWpo3NzyEz6IyEF37N761VKhJChBbtw+bWu0l4KGAObpI3ZkPlF7RqohZNIjdx3l1LCJ93JEY8coDDdP7hvvT2/JRWs8wH0BIKPh7HriECAfoKpQC9l3KbOcd6LoRE59QHPQ9oiI5eVbsVoy0OfvOeBYzRGg2tVVIGbYmBLXZ6HMQp3HnGND6ZaGiSTsrY6SVEjIgtPrlc
 kSlQHYAx
 RbaQm56HVo0t2We/CfBl0k+cdWmh9VnDxqt9o9KPWu25PUqVSPKqKjGY1TOEUcOzv4xfKrRVZZe8TNiOVcedVubbvmAXptzTX21CPxEU6wI8hu+WMjX0YCw9CTT/Uzde2q8uAyERRs2Z78rS/HNvuRpu0zAgNpfsVuRNpP9mLK0hrRNYwpWe6F8nu1EQIoPit3hi7aW580ZQ0Er3uFTN7c4tZ3r7K08Dp9XPG1zjrkJYd34oax/0zjSiHmOjgi5UykMxldiboaoBqF25jRmXvkw7Ndk3M7MmcONc53scqpnJJ0iYWRzsR887/21vXp3oYiK00ODLgJhucGi0Kn1kk/PvX7ABsTOgAkl1qb/Nw3k6Ni3FGXA2HLqtstODtcvL0FAWKYzpXTuLuILZi+k9owi0wtFt+PKmGQ+kjEYvrw5uPJPP93peV202QYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 10:52=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> On 09/15/26 at 06:03pm, Kunwu Chan wrote:
> > On Sun, 13 Sep 2026 15:50:03 +0800 Baoquan He <hebaoquan@kylinos.cn> wr=
ote:
> ...snip...
> >
> > The SWP_XSWAP flag and nr_real_swapfiles accounting look correct. The w=
riteback guard
> > in page_io.c (both swap_writeout and swap_read_folio paths) properly sh=
ort-circuits
> > xswap devices, and the zswap writeback gating on nr_real_swapfiles ensu=
res writeback
> > only fires when a real swap device is active.
> >
> > No issues found.
> >
> > Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
>
> Thanks for careful reviewing. I will post v3 soon. I found this v2 is
> based on a older commit of mm-unstable, and I forgot adding base-id, so
> Sashiko reviewing is failed to launch. I have rebased this onto the
> latest mm-new, hope Sashiko can be satisfied.

Thanks, Baoquan.

I=E2=80=99ll keep following the series and look forward to reviewing v3.

