Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63702C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 02:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93376B007B; Mon, 28 Jul 2025 22:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D026B0089; Mon, 28 Jul 2025 22:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4CD6B008A; Mon, 28 Jul 2025 22:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC726B007B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:24:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1ECAE1DADA2
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:24:45 +0000 (UTC)
X-FDA: 83715708930.01.1510888
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 350551C0005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:24:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ro7dVf+i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753755883; a=rsa-sha256;
	cv=none;
	b=f70BMr7dQ9QZMWIKBlid7VkKC6AbDfi3GpvV6sE+1KUJ3WiIBkY6YYjk+zey+cwbjQoWci
	zpjWtWNKrT/ZAUYi/XBWdESsKJ6JDrzNaYMU8mzOmHwbfrexSknQ4AWbXonsP+D6uaUGms
	RvWsedj7KXEpAdQ9lSHam6Lh1H9wKM0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ro7dVf+i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753755883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zd+Dzg53O5t7UFkMgGNSFCBrYAjg0xRifizsUJq0KwI=;
	b=VAaFfxxEvXxFS5z618Xh7mHOwn4z0Gf0qRpZ3oM9mqmudxwVJ9Bxlb0QAMVShZyeTg5Qoo
	9t0zuPdyulIpsaacErB2gbYgZ9mqucZmJpIxt0soeuvVjaxISvDlJYgmohYs8lWzYuKhUF
	wCdLMLXCGwg4dgHxkAi4XE0Yh7uMMKk=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-32f144d0db8so3364421fa.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 19:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753755881; x=1754360681; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zd+Dzg53O5t7UFkMgGNSFCBrYAjg0xRifizsUJq0KwI=;
        b=Ro7dVf+idNyJhwA+sR1CWLXWm/6G1oS2WuUX7jKiKFrKDe2ok820Xnc5wONi3/RCFF
         Ar9fKNANUs7YituCb6MhFXVnDo+joX6Qt0/lb7D+OIzBhmcWWoWKRYE+tAB65O8iajOa
         gw1It+oqU5ZMXOHWnPjxFXJvzqxQ7avGbTLwy2zVTPvfcuOrppK1XTsLgPo8+yavVY3P
         3la6j0zCP5LYBPspEIajYI21paUZcP2EEXDix7bM8/ri117iH2qq/odLybURDzTrQUtQ
         kmkQFjw7tNuaTw17XUHT15QkbK+pE70YxAhswgHe7NlQOV0/sE2zql2C90oj6rxUiIXk
         nNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753755881; x=1754360681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zd+Dzg53O5t7UFkMgGNSFCBrYAjg0xRifizsUJq0KwI=;
        b=N2S58brn6eEa4P5xB5ypsNEFfyFHwZNQNLbcOS/J/LwWWFDpF9Z7dfL1z2QuDlU1JH
         WCKIibRG/SzrzBLfQCOKNFE4LQQQ8S1hEJpCVyEkZUMznbLRXoKAMXHiuP8LUOv+ocJ1
         78NZsiqMtJzDbePPLLrG+tz2EehTq51owhNHyopJzaTVnl/3zZXw7YYfjyswK3vY3vIF
         h5Za4Lm/BKZIc8xOvWsr3VLPMegTtjBx4ne4SEwCSg94AuNUDZ3o0uuhxaJCqFdKrTwP
         22PKYgrBlxD5n2O2uNg1xrbswnQQz4UQJYDWfHSzV74+A06nvu3EsLPPQ/IbC5cFcxtS
         Afxg==
X-Gm-Message-State: AOJu0Yy63khNyvfs9bdggEkTKDVzDRXWqPdcqpvwpbOJ6KYHYIneSfO4
	5ER6Xe4qiWLgZn7LDOpiDGK43p2grCqBc7XM1bFAczhDRTor9qFS8RHYC3gGbp9VIJhcsu4IDEI
	gZexX9HUGcyZ/sDIM3eFZPDQ1W5iPZ7s=
X-Gm-Gg: ASbGnctinliqYQEFIYGHo6dmjEtjZjwDH+q0ViLOIencMj08NeN8npx54gi/bmONa1s
	d36DRTYDiZb53nL92QP81C3zA+oT4F5tvBZDPcfjNun6JTyACfS4U5GQ2Q+Sf1LlKPSyz60QQVZ
	2+Fywmk19juKbEnSU6mBJeFTT4K9D/DSI5WfesoIPRR3H7sJUCv97dqRQFtL2a+g/pdo9hFRDTY
	N1YRWY=
X-Google-Smtp-Source: AGHT+IFeymq4prHfwBj6WHOb8b1QylWEfWW4wNVKbT5mwWgYqJjzq9+ZEAAXpfqxDyYwZRsmMcrUGtpdFQuh0I4FNmg=
X-Received: by 2002:a2e:a01c:0:b0:30b:b78e:c445 with SMTP id
 38308e7fff4ca-3321549ac3bmr2889191fa.17.1753755881077; Mon, 28 Jul 2025
 19:24:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250728075306.12704-1-ryncsn@gmail.com> <20250728150258.4cba730ba36da5cce659d067@linux-foundation.org>
In-Reply-To: <20250728150258.4cba730ba36da5cce659d067@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 29 Jul 2025 10:24:03 +0800
X-Gm-Features: Ac12FXyo5LUE90u4fcIAuGEL1tV1TPGLzOEP6TPG2-CxFPH7YHSLceFX52EBwVc
Message-ID: <CAMgjq7BY4WG3pq4OhL3MRsCERXxSUuWNPA36uuYbDF7d5Sz_KQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/8] mm/shmem, swap: bugfix and improvement of mTHP
 swap in
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 350551C0005
X-Stat-Signature: m5f3oo3gnaasriazw83atszycgdd465b
X-Rspam-User: 
X-HE-Tag: 1753755882-233995
X-HE-Meta: U2FsdGVkX1/OHNQy7BSnuk2uL31yK8Wjrvbu7MU0/nDJcM0XYdyFJdyEuuiR5/2iGN6bdCVhgQiKH+1Z1a4FqKDnAe1lPb1+E2I8C/j6xoYK6+vukRDsimW1P5+gBzD//fjJRTtBnOuNup8QLbk//XTpCTz4jbS8EiV/orOSDHMCejfpVDXr+6xRQMFmIBTKb2gEATcM47LUORrTagH/Ic+5Yv3MAY1WBpwNdwaMsMrEM/KKE2QiQGumPHLw7YBsNVJaSfMBH19T96/q1L3zOJzDiR9UgBXzB6IW8FbagnT8ToBq5qrcWhN0mcFlKA70OJ3Zo9+twJdie8vv1WyOUQE4iNQjM01JUBqSTazhvDqF83967OPDC8L5OFHfGzKVqVyfh49dI9CXWKi+k3DBT/tFTY8hgxgLzN2bt8M2PziwO1HpgJrxSZlpGPARfg9BkoBfbGzvflzV2l05nu+rDyx0epgU9C8QdPwNiokyyqh6x2V7Rud83aNIIGfu/qPHUWIvZplpB/qFfOoTya4nXGTmp7Bgq3xk6FI4fwnqx041NzgAjydhTrZyaVa7yVbE4rMQ2AE317WHF52NYqFdRiepoe22QeOYBLLp0nASIQx5d+QpdrsCFwmxQbb9s9V6DIfHnEFdQVJIUISOS3ZwfytVoe2ys2XpHQTv8hADVQzZEL0YzU0PzOxcAeDYNuRsxntmfz1lNAKi7H2oIbJtj0aWyLXYso4d53H278cSnWkUl/iptN7WlVtc3yJBS/cvJkfCqQsI7Yhf5vvAOGxe2SiByihRkpLVGUIGtMpqN/VGnYvO7bhcMGGMkpm7QXcv0navTEzTEiQx6vIEkVemM4udP/QKst/HXA9vAtSCnRf9gijqErgOfiz9FLKCFq8WSfGUODWfPUTs9E2JTSltp2bQ78fN2gavhuBtTO0/qfkId+fp8bcoHjGmWjsTMrSr0vNWYT9Ugz/lRc6T3Uj
 JNNdd/Ns
 nvV/u0wAwf0glDmjEnHLjdv0cemBuNtS3MUUfgMdWWW/gpliD1R3XVk/7pd8AwtKxvb6c7uv1jPK0tmb3M6RXNvq/9ieh+qew9sc58PaxLDnh7cpZMbYEEkHm+b72sooONSwqnnPGQYnU1tloHVunk56rFnOZDRggYBA7+DkTRRu185T/Ah0R+PUwtTxDOJJuAcgD9m0sUQFH8rEN7NU1Swi0o1UImjTBF+MiRfxLSO9tKyhbDr3PbnFlJpybxxoL3DprFOg5NtOqUquNB8Ghf2WDESktZ4wntzwxSiP2RAIm46/2jvmDiLfN58bpeVJ/3uNADzqsAXem7uMyzU4b20qGu7k4qqfv+f6eED5nSDr6Pors+NmdoFEE2D8FSXAf+/PRG6rIOuNKO6ADWYlN9QYOez9haglGplNXe2KMDzYfbF2ayXxjFoZsvRv5hMOuqtSnImZLnP9FoGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> =E4=BA=8E 2025=E5=B9=B47=E6=9C=88=
29=E6=97=A5=E5=91=A8=E4=BA=8C 06:03=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, 28 Jul 2025 15:52:58 +0800 Kairui Song <ryncsn@gmail.com> wrote:
>
> > From: Kairui Song <kasong@tencent.com>
> >
> > The current THP swapin path have several problems. It may potentially
> > hang, may cause redundant faults due to false positive swap cache looku=
p,
> > and it issues redundant Xarray walks. !CONFIG_TRANSPARENT_HUGEPAGE
> > builds may also contain unnecessary THP checks.
> >
> > This series fixes all of the mentioned issues, the code should be more
> > robust and prepared for the swap table series. Now 4 walks is reduced
> > to 3 (get order & confirm, confirm, insert folio), !CONFIG_TRANSPARENT_=
HUGEPAGE
> > build overhead is also minimized, and comes with a sanity check now.
> >
>
> Below are the changes since v5 of this series.  It's a lot, and we're
> now in the merge window.
>
> So I'll merge this into mm.git's mm-new branch.  After -rc1 I'll move
> them into mm-unstable, targeting a 6.18-rc1 merge.  However at that
> time I'll move the [1/N] patch (which has cc:stable) into mm-hotfixes,
> planning to merge that into 6.17-rcX.
>
> Does this sound OK?

Sounds good to me, thanks!

