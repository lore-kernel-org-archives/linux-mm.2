Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F03C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAADD6B0099; Sun, 20 Sep 2026 08:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82D16B009B; Sun, 20 Sep 2026 08:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9716C6B009D; Sun, 20 Sep 2026 08:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66EB86B0099
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:24:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 983FF140409
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:38 +0000 (UTC)
X-FDA: 85234059036.01.93E55C0
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id CBACF140007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:24:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TYtA72DV;
	spf=pass (imf09.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYqPAHe6dDWQaMD5MN6ftRH3n900tUiGNAP8+qEZJDw=;
	b=otDB5MxLfvW5494LOmeaHaseR1QPkCqUcW+wCtXPdYqAxE/CEr976X+jA3w4hURbjD6mXu
	1p0UV7B6gBshNC9NBSM85awaqYja76h6ceh2sYsOZli6Ay3J03A9rN0oQxRjWgDmaYuWNi
	BOAiu36S3cJJK7RWEgyJVq+vykXzAfA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TYtA72DV;
	spf=pass (imf09.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907076;
	b=W0PlXMu86PS0xtSzr7btEKkhDvCi2CT8K91tkUlgicR4fSCtjcNMIob1gwvMEJpG4mj9iu
	pMq4vj0O5LHwXn9M2ueUNxDEcSoJURceX0HKWQuJcdNaE/uZYM9O0RJpcfTN1o2S4TPF0s
	S607UK4yAbC/zctXRlbVPxnOsVi4SQk=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea4c79fso883837a12.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789907076; x=1790511876; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RYqPAHe6dDWQaMD5MN6ftRH3n900tUiGNAP8+qEZJDw=;
        b=TYtA72DVTcM5J7MBKHerXxqTy9DHLOxT7b7JSoVCBhD3FAq+0qt7u49NFWX+iRqlMf
         yobTNIR74x7SwHyr2r5p9At+Uvqm4SfFn9W8Semeup/bTMgotAcekz0es39hJefTOBtg
         cA7MomiRpu16BCXLImONbsVfgsWiHQYTlmvLFwLmnWY1/BDKSfGwx7V2gDyZL+uRktS1
         uZ9K0RzDfEGLsumU1ZTZVUjDliTNPJVDx7x2Zp4wtzHHSqHTTHIe4wmIw6rTuS9YPH2z
         agwIoz6+jcFni/39yEouU1VDNzIKJUlAXAXxby/7EFWGTRc5nB96qWUaEO2owj2X0zEt
         UFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789907076; x=1790511876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RYqPAHe6dDWQaMD5MN6ftRH3n900tUiGNAP8+qEZJDw=;
        b=Mp86qTI245X3NidbosaPYpiCr6TCAHmewqEf/yX9NjsViAwxuaHTrqO/x7I+ZiXcq0
         wUZg+DdAl6ly5KDHqYQX5QSp8GyPSihUH+4W1fFSoT+dmnB+tYEwnzNf7l3PFQ1z78yL
         YMzNwUtFbEOEkzbeV+FDtOpvD5EFd40KrtqOjuC5g8Y96ZLEtUA2WXKhQ6/WM42DvwGV
         j8wR2TJ2+6BUFn8V7mqqkZ2IYu1kkFlRtPFkvJ0LofCm5BLpqan+2G+Ht6UNUL2CH/R4
         Mpq7EhT2F8/s/jxqPzrElT9SF0OobWjvQPpFuFFrsRNucWdZWq5byDPM2Zvp5o2Cq1ib
         6AjA==
X-Forwarded-Encrypted: i=1; AKwUvBwget+23IrsiuRY7OchtE/sqUQIy2czEUr8Rx50OrtibW0uVAn4TCAbGvWKlMkh16WaR3I0yWaDwQ==@kvack.org
X-Gm-Message-State: AFuF++lJoiJGXMjZElZEWMvAAKG3M9klzhghOAU0uGD10V5KIWG6NtQI
	o5PsNVrgHWSZ8dJJ2mzElW3/Z/a2Ghmb574+yr4bSCuH/x669NHka44=
X-Gm-Gg: AYBFou0GTaE9kJIA6oKUuQWoyQQqerjZP/CimJPfpd3Gk/CLVYag8zXb86lWBW4Ok0Q
	tAZFiKf44ks3y1OgT0B7zncBVtv0U/PfYtLc9PN9AC0OSjRoC1YUBYjiawVxsLVWGgcjyQ6XjWL
	14LbF8Otdjb+RLuAxXNCyHOn3vOBwtfbbJ0G+pXkAosmActPo2A47JbFqXpJ/t7jPNnId5uv58D
	xZh8oabbUtG9ubLed2raVTXJfdDZzD3hGLQfqUtpspoE7X3vHLDgtTBXHClIgjmN5A7pxzzO8hv
	0FPOsrNueMDx2cb7SbeNIbbtH/2Kh4l0jBzwCOR9s3F9rr5Vxb8KazerpeEr/Ae5nEQcZTUNCr5
	zZiGejouIhkbyUfzalQQzLlZwUSWMGA/LBTd/Qp8rwvU0mmY6Vt2TvJI4QwknxE/U3bfYKWfU9+
	oUNs/ZlmIJxtXR0EMmw4LlaU9C46bZuMG9QiESRHpLTj7AQgv6/JOa6W1vS2PuX08OHPmftJ9KM
	DjiNGPXb9XKVV3xjNybBY6uNlI=
X-Received: by 2002:a17:90b:5281:b0:3a0:3673:dbbf with SMTP id 98e67ed59e1d1-3a03673dd7bmr2099459a91.59.1789907075684;
        Sun, 20 Sep 2026 05:24:35 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:e0d6:4b87:c472:c9ae])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a03bcecdd2sm1173362a91.1.2026.09.20.05.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 05:24:35 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: Re: [PATCH v2 1/3] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sun, 20 Sep 2026 21:24:30 +0900
Message-ID: <20260920122430.610257-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920103714.47722-1-sj@kernel.org>
References: <20260920023111.2466265-1-donggeunyoo.kernel@gmail.com> <20260920023111.2466265-2-donggeunyoo.kernel@gmail.com> <20260920103714.47722-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBACF140007
X-Stat-Signature: r56h6zgw8mu5h3wtqrqgwpxe8h6yfb96
X-Rspam-User: 
X-HE-Tag: 1789907076-44524
X-HE-Meta: U2FsdGVkX1+RY8/jlLvmXSqh/Vdac29KiVXKhWNSxdKUB1WwLjhGDdYFjAg48Z95u7JpPvIAJfxJetkLAD93CEQ8ob5g/y95IHQCH2FeZ/X4HGUGNCva3Va7QiQP/qeGjC53WMLEOuJyeBAo7fgLj6js+lyd+gajGWrLexdohQKnxu3lvcOg8dwnwZFS152uHXDDG2H0zkDWCqFcC6x+Kd0d9BXsxJyJ3yAuJZNHGYQ+1h+39DMG2+N0YDw9/PKR6oR3MKMcRDc+ZCiBxs+9cSo0recXsFkxeoTbBMoVxn5D2vGhktD2mIo/YLbGwUl4qJIs6Ht9Wqe8YEUWa23Egmp4oNUWZgZX+sj5cSSJJDU+h3qXKXvQjjkp2i3m7y/q3ffJBfGmhKDOziBBJhNHX1Yj4kay3eywTfHy8fccI4/sZzkINfAGY4CldpVX7iK+t1BxxivkRPN9GHL9/VBA+d3PRo+CdsSy3NKk3fZsAi+0HGMFaer9C3pXBlRm5OBGtiCh2fsLEJr/MXi5zyf4Rp511kbi8S1P21PDCfwbkBlojD6yUP5gHXdYgfk2SgUVHsq5X0e72ucHklFZDT5QkpBMNG4h9Bz+cMoa0WxtdK/scASMopmKNm5edravY7GixnT06QzRMU4sK6/3KrCPwmKNeWHR1viQuSG9b2kbZTGRTbSkopmeNJ7+ONrPlTuvYNzmEaODBy1+2jchDfuvDnbIYmIexOEiN0ZIKa+eQF4xDTAzUxxf0WyyqX+PTZ/EhxrNXfE53s/AffraY5ZWo4kjpMvmCddem+mAjp1VYbrmujc1tG9LwsXTwviQamapD2vnE/EgS1OUHV099HN4bG0h3edIuBM2bw4lIgYr/o8b9KE0YCG893EHIW64g8lughUvHJgn3rNTUAStVy7bFnnt3paPQINO0J8hPcWfa/IuCbL0JWSds/UpQB8ohoRzID2o+cTrkHjI0kVMqT/
 MHKkcoki
 aykMh/BLp8pMDyfStNb1EmevSlRQO48swkaaj3Ogu8YW+Gti80O9FTvqlPvazBgIaxczQx6GqYZWnzZAhU+AwceyN6ZX4zBNw2Mcm+zwGHzKcxZuu0piRHJHCk9xPF4ya9zxBuo14P+1LDQF5CXWv9whS9mKmhd0aNSwOb3vQPhvqmhgS/X+x3ffp0kqy5Dkh++exHe9y5ntpwkcfAqd+LLyVhaGtm4A7Doe3UYaWbIKxhCfgR0yfmkBBlcLQOUsQDtH2hUjI1/cI3z/N9vUj7IrrcF/gyYeK2ZyUng1C/vYEJJvhKTwzlSQBLELd0PtS+gs8h61u/3lzNzWnbfjLb0ZKNenNSfAKWP9kppNiwDjH+WephLETfxIhgjrjBlM5leRr5VTaPGdGqiU0U6tT2K3lqIg1lTx1DKzVEIQaKnTY4uty6ybhh2kTr3rDwygSwhp2wDjHZ5m3L77MhB6I3PlT72XCgj9ywDR9qts9FpP3e54NvHgw5yhyTKMCMr1kw1NHtefPFrWfcLScNoi4kR3GjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for the detailed review.

On Sun, 20 Sep 2026 03:37:13 -0700 SJ Park <sj@kernel.org> wrote:
> Let's break commit message lines with 72 columns limit.

Done in v3, here and in 2/3.

> Why 256 MiB, not 429,496 bytes?

They are two different numbers.  429496 is where the multiply starts
to wrap, and every size above it is wrong.  256 MiB is where the
wrapped value lands on exactly zero: 256 MiB * 10000 is 625 * 2^32, so
on 32-bit the product wraps around 625 times and ends at zero.

> So, the way to work around is updating the size quota to smaller value,
> correct?

Correct.  v3 says so.

> But why a sane user would set such huge number?

They would not, which is why v3 no longer argues the 64-bit case in its
own paragraph.  The threshold is now stated once, as part of what it
takes to reach the bug: above ULONG_MAX / 10000, which is 429496 bytes
on 32-bit and 1844674407370955 on 64-bit.

> Because this patch Cc stable@, let's make super clear about the user
> impact [...]

v3:

  Triggering this needs a scheme with a quota goal, the temporal goal
  tuner, and a size quota above ULONG_MAX / 10000 -- 429496 bytes on
  32-bit, 1844674407370955 on 64-bit -- so it is unlikely to be hit on
  a tested setup.  Nothing is corrupted and nothing leaks.  The scheme
  makes no progress for as long as the goal is unachieved, which is
  easy to notice, and writing a smaller size quota restores it.

> > Bound the conversion, so a size quota it cannot represent falls to the
> > ULONG_MAX the function already writes for a scheme with no size quota.
>
> I don't understand the above sentence.  Is the grammar correct?

You are right that it is hard to read.  The sentence was too long and
tried to say two things at once.  v3:

  Bound the multiply.  A size quota too large to convert now takes the
  same ULONG_MAX branch as a scheme with no size quota, so the
  effective quota becomes ULONG_MAX / 10000 instead of a wrapped value.

> > Widening esz_bp instead would reach the consist tuner [...]
>
> I don't quite understand above.  could you please elaborate?

Sorry, that paragraph was not clear.  It was meant to explain why I did
not simply widen the type.

The other way to fix the overflow is to make esz_bp wider than unsigned
long, u64 for example.  But esz_bp is not used only here.  The consist
tuner keeps its own value in the same field, and
damos_goal_tune_esz_bp_consist() passes it to
damon_feed_loop_next_input(), which takes unsigned long and returns
unsigned long.  So widening esz_bp means widening that function too,
and the consist tuner would change for a problem it does not have.
Bounding the multiply is one line, and only the temporal tuner is
touched.

I dropped the paragraph in v3.  It argues against a fix nobody
proposed, so it only makes the changelog harder to read.

Thanks,
Donggeun

