Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E006E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7E16B0088; Wed, 18 Feb 2026 06:53:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9923E6B0089; Wed, 18 Feb 2026 06:53:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894B96B008A; Wed, 18 Feb 2026 06:53:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 74F366B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:53:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08ED1AA720
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:53:47 +0000 (UTC)
X-FDA: 84457418094.05.718F46F
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 20ABC140005
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:53:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0AMEZjub;
	spf=pass (imf23.hostedemail.com: domain of 3R6iVaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3R6iVaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771415625; a=rsa-sha256;
	cv=none;
	b=ezAhdWIMY8LxKCCgN4peOroMxSIiTDPyczxVW7r05UQ83cbcSSEdSUmfHTud5UPnDUlxrS
	dXUNEBkbz+mZpLCeXmSpxr2DH5qA0FCtawTz8IS2LTJ94msMq9dYZSWOpzQh/92GEnUBnJ
	tJL94DUOblP7LpItMKsIbH6ZAhw/Jjg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0AMEZjub;
	spf=pass (imf23.hostedemail.com: domain of 3R6iVaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3R6iVaQkKCEIepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771415625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jabDmLqCWECXnNK4LiTet3HnR07/Mdte6Ju6ZynhZhU=;
	b=1SKBmshw1rD7jFsSjZoFLVIEP0V2fx6rFhdhlQsVxMI/yd1t5nVlfql+WH/cL1DKtAsk5q
	sgZ6mHDkGTurrRM1DUJX7GZ6K0aeUxgIHgcq3KcVfzVATQE7+JuqCT27KXmB22Hq6ke476
	/TknpDN9PDs4sFktG8k+R5Fh1qNRSjE=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837c597cd5so22779345e9.3
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771415623; x=1772020423; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jabDmLqCWECXnNK4LiTet3HnR07/Mdte6Ju6ZynhZhU=;
        b=0AMEZjubc5kFZXkPk9ucPKz+16SzQ0bEf//KWB72xiseyq2uaV30YNs1MDsG7b8Sql
         HfTdw72oiH4EyKuyOk1Wx5QrNX+aaofvV0Eu8an2TKK1tcWLuI4jLB1GAVVzut31AEx5
         mHvj4TvPVm8AMRrCWkkM+fnbgjR3Tib8qqUa7yqwP9F3LlOQiNu/n+tKOrzitA0kISlm
         y+Of2w7oakETfgRm/zJPo0pqtJNsUhesnz1IiSdNvZlFPe5nQcxkutPJZ6GGIFXZPOX2
         7HJ3oRLAW9eUUfHsmZj+s1mzO7K9CWdPZamNNHDJJeUFKn6hvO7bqeJKXz8vUAahiXJT
         5zQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415623; x=1772020423;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jabDmLqCWECXnNK4LiTet3HnR07/Mdte6Ju6ZynhZhU=;
        b=pGWtXbHz/0YZ9XeCAtAhbPKMirj0groVdWDyxp+hU3OSTbrkh7QrELk7hiekAG5JkK
         WOXG47Wc0IQuTjLC7J5fhpiSsy9fSoDkL/0l564lQgGUjEnICJvuC7ZAaeslAZm+oY0z
         d1RRfX4wELh733yXKg4zxsYHK1NdMWPGn5NR2EFWVm1TBqcdmCH03W9UIFiOAfScEmQ4
         KzClyoF1ugQEAq4b+7EdOkixZJ7RhDWHQydIuyrqq5bBcnW02MKnx5cIjt65djQVQX4W
         OTdh4n+yirgf+1uB+j5KuEjpEq9Y8ZyXCIpT/246eGfxfscqbohZEoLk2olEa1U5vzYM
         pXMg==
X-Forwarded-Encrypted: i=1; AJvYcCWYMNCAcs/18nxiX7IkOb3qtEIGG0H3ZlcXfR9b56C22hL1uUE6aFh4aiRZUBCKY4ggHFgdWOgGWQ==@kvack.org
X-Gm-Message-State: AOJu0YxVOgxTZpTTeUFsnogZMhHuSuS24LjrBFNd5XVfrtc8lnTec4yb
	/cpLylhwKCBl89oPslX0mJTRhLlqN3std5DR+iVaFyyELO5PcccD3HmzkscQhS8qdjUcscYqSgz
	8kxW9gZiq0Cws2adKnw==
X-Received: from wmkz14.prod.google.com ([2002:a7b:c7ce:0:b0:480:46d7:9c4e])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b77:b0:483:6d4e:9811 with SMTP id 5b1f17b1804b1-48398ae6736mr34831615e9.31.1771415623348;
 Wed, 18 Feb 2026 03:53:43 -0800 (PST)
Date: Wed, 18 Feb 2026 11:53:25 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIADaolWkC/32NQQrCMBBFr1Jm7UgzSqKuvId0kaTTdtA2kkhQS
 u5u7AFcvgf//RUSR+EEl2aFyFmShKUC7Rrwk11GRukrA7WkW1IGnSw9R8yzRT+xv6PTg7dH4vN Je6izZ+RB3lvy1lWeJL1C/GwPWf3sn1hW2KKy5A5mMM5ouo4hjA/e+zBDV0r5AqSRwEOxAAAA
X-Change-Id: 20260217-binder-vma-check-b6fca42e986c
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1043; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=midTfKHBQR4+V9ov+ZGnHBfc/KST2dfDvfMiMRqYAuY=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBplag6e4SnfP5Lm6TFw/Rn7c9jU60pUWbZGgoRG
 eiJ3ogJMByJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaZWoOgAKCRAEWL7uWMY5
 RgX1D/sFWg5zD0sy5I1A49njTIky+VabjigVV7dwODVE083PmcgpYC+86lQTWYCw1ykaZU1ThIk
 dwSruKbdJw1CGF0UrsBboCdupwT4qNJreAWqwk+/yYLRwRssqxokhI55Wl5gI+0NoxbnL0NMJVC
 BhKOwHD+9lCaLdqHhf0gIEW5PBbdsktewAAbejBGEYth19DdAl5goD8ACw/LzFuU62gkQPXif5/
 d2xpP3IHAJuMRAfzx6G77lPnZ718g+yW5WHHy80/rI5wRivDvCnua5ChxAORQPeruSxvuacEBVB
 +dQxy47+EE46hsaX+kihSkcJSA1wcAcJzNqsKnCv219waPh4bzxsGRmKwpG1jZQneWu1relVtyQ
 7nzzJY8DF1absFKxu55m4eu5FtByKoBPIoYk91GIS9CgK5LlRnDg5+Nd7MOteEBR6aLU6wkEJbS
 iU6meSuXAaf5Ei/EaPYG/xuMa/QzCBiFMrxpUJO5PRw3R62iFOq/tsRLbgu219aYet4Wwr1AUvk
 tf2lcu6DJQH5CHD797OAbrXMWRaE5w0manWX+ivKpL+fzdAB/kc+fZEhLuRIkrCmqdnqeNyDAtU
 dsUnKt2LDGqqAoMsAevJlgIqH+8DXwKxXRdeHAqNRz9A3h6u82aFNmHJZjxVTcZalbhczkLpdsf E5l0/YzkV8YDchA==
X-Mailer: b4 0.14.2
Message-ID: <20260218-binder-vma-check-v2-0-60f9d695a990@google.com>
Subject: [PATCH v2 0/2] Fix VMA confusion in Rust Binder
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Jann Horn <jannh@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 20ABC140005
X-Stat-Signature: 1uf3jwr7nzeyzr3poupbko1nekt7g57w
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771415624-688811
X-HE-Meta: U2FsdGVkX19nne+dpjA9EkVSpaA/7eTY1/xTrp6fc6LflBcRXXoKAZ65Ds+CrTus7fbXOFFiA9H9OpiugyIIbZxQpHRI6EaiKqU8aERkFACP+D+vEY9ZdUIkAtnsPPJgBbpGacjd3aI7DJJcEs/f6tK+DUY3yGq2WDyV0DU+KMtHfNtsnfTM3JoZxb5F0K3bHTcHzWbXQbn2qGf2T5NjB3+H6oNkt4GFvB34Uz2O03ytx+cpw7KVsEIjISWYPmMnnSHsasVlAhpqRlZd9fEa4YQ6rh+35kVYAkzSUsWBYY95q7popoRmg4w/LRiySjg6gSuNGs04LNGmzTEbVj6Y1+B1vQAWPfRtVyqruhjPEdQozptjwZYK3QbinPH529gnwNGnztZFq+7JvnTDlGRgEVkPAVeCDUujNo/jfaz5wFiOGvnaKduYf3RueAmdx8ZB82D/s+6fptpVBN3waRlMx+VUKPqYXNiG8oLgZ5X+k1+0lIgxUfTycutnYP8SSyWdVoWN+myB8vKPq509t+Ot71XcJ1xkl8b0tzvRIdBIkziZIwhB9qfnvmJtvXOIwJZHzLl++f9HhOM68Hzqmo8/twSTD4RsyjHQELxOmP71QGBUybnblAhkavJa6sFDWF7UFlGg89CPtAJaox5qqEoyIp9z58+SHlHb4Hb3Ln2+k924VlMW5pwyieYlbCpZx4KdFeM+SE9sQIpzBHxyKV4Aizb8Xp1s1o6jm0qhgT3ld0P5up3s8AG12LXmAyZce5K38jSk1u+NXSv6Q4O7XezubqHqsfzg6oFYI9Qnc3wrY8Zf65KmVOAB02VonZEYjYyKfSGC1LuXLclySWTs3FJSMu+tjd0GZ+3AJFeroUuHwMaeFBCUYwed+2hjw1iXJ1xFiJ2WLnnclO3SjX8lX1BNkWA7vABTy/Bg4ZLZ4gFfMrgWUl1Qvh4QJXYwxTV/L4CbrxS+YS2zgdEAfwoIVct
 6LuyjFf5
 VAt6hOwWPgCN+k8HS7lmySO5C14FtFTDvwwGfbh7RMBXpWMssptGQlJIsHta8PFAQmAjVHlU2LMjDqidmuYDnlLQaNAGdQpuWtifbXRHktNQav+myoDDPuTYVd8VkCV0UNKxn8Jq2KSbfpca/ugahMd7Qj+N4sKR0zTIbvc7hzH5//nQcEBYRuX6SusdXWXSLUbVScO5x/go751CFmWz9AcSB6wizOzuy7nQfnY7NJrTybyWLUJO0AEAkDiu35ZG+rHTT/qfJsnNGIsEpQg7D5751M1zrMoH+v5e6BXJjeuwZphwjXirks77RWgSNHxX+kzCNpaLJ/pswo82Mc3mVm4xkIq2mqiaKcPrmLtCb5K8qw3j6JXO1N17UsRBWj6+FQe4SLI2FFok2OHEGVeyC9T8TT4Nq9MDwtLZMXGYUdcnyIQ+kfEQVvTjoSWNjgX5hQAbYglCsZkpvUoeGQ+R+eweRbYeQk6nwBs7a2wNsmYW2CtuAEJB4HrOTH6gZ7DDsX8EPCV07LSs20AUnZdLtss0FqRCbOixyaAYxM1VZcl+qYJBq3qZXdpXWH543cVeRpMHBzkdeTscksoLgSodh30zxdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series contains two bugfixes for Rust Binder. I'd like to follow
them up with better solutions by changing the VMA api, but as an
immediate fix this should work.

See the first commit for an explanation of the actual bug.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Changes in v2:
- Use imperative mood.
- Add some comments about why reuse of ShrinkablePageRange is not a
  problem.
- Use ptr::from_ref()
- Rustfmt
- Link to v1: https://lore.kernel.org/r/20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com

---
Alice Ryhl (2):
      rust_binder: check ownership before using vma
      rust_binder: avoid reading the written value in offsets array

 drivers/android/binder/page_range.rs | 83 +++++++++++++++++++++++++++---------
 drivers/android/binder/thread.rs     | 17 +++-----
 2 files changed, 69 insertions(+), 31 deletions(-)
---
base-commit: 0f2acd3148e0ef42bdacbd477f90e8533f96b2ac
change-id: 20260217-binder-vma-check-b6fca42e986c

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


