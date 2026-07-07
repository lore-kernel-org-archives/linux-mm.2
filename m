Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D836C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8C96B00A4; Tue,  7 Jul 2026 16:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F216B00AD; Tue,  7 Jul 2026 16:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD7F6B00AE; Tue,  7 Jul 2026 16:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E63086B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:20:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6ACB41A057A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:20:51 +0000 (UTC)
X-FDA: 84963099102.08.18CD816
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4818440003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:20:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=multikernel-io.20251104.gappssmtp.com header.s=20251104 header.b=ZY9zlA9a;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of cwang@multikernel.io designates 209.85.218.41 as permitted sender) smtp.mailfrom=cwang@multikernel.io;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783455649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJY4UQNwZDSX3Ty+RTKFDTWqS5ZEkBgH5FUefscWr/Y=;
	b=UAW4ovJxsCz8jEuXsVUpBWivkVuwdYQOR/NCpMBzKcSQlKx55MAhONT3Pkgi7qc9GY7WdE
	k4BxQcFjQ+rNZNK2TRK6fej4/P8Q7vfIIQW4gxf/RgXDK00PaGN0cYWricCGmzH2TdqAqd
	jZpOJN7BxsTghHVnFdEpC0tnfO1HS9M=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=multikernel-io.20251104.gappssmtp.com header.s=20251104 header.b=ZY9zlA9a;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of cwang@multikernel.io designates 209.85.218.41 as permitted sender) smtp.mailfrom=cwang@multikernel.io;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783455649;
	b=oXDqyrVmHnGZ8lmDnQbwmxGa/hiyNoxj2OygZWqdhPSQ22lLSX51p2sgF33WMK0SbaICOB
	o8QEhfgAtLLn4/M1xsS+c38mr0h0+/LIoriM/vt1g+fVa1k9w1WGgWxFb5926vJLmpUqoG
	tLrw8uDIc4gjz1ykv69dMl3qIer40k0=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15c257a488so7758266b.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 13:20:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783455647; cv=none;
        d=google.com; s=arc-20260327;
        b=mDdifUXi4CHVJ8dzv8ero3FbYjoSnl4ewDwFNkEaQ8KOZoIEsQgl39A1cGb2J7wwpG
         YSCib4E8LT20bOFGbTlj8pEiUq1nRh79G9FWXicrjU2n0WJNGXsbRQz8zgEmRl9C9rm4
         iklQSSydoCaxNgcMf6CBMr69yi8P4nCFZ8LA7zmbUH6zg3BzPsyEq9BtnO3Hnux4whrP
         oC+na9KT5/WwM1SWI/F+AMYvhsOjwBviSveaKHVLgKudi4uUyfLvsv9M6BlzdIGcRZiO
         JH5peiXL5QKW4vLsSrR7bcb++h4NatkGSPkSsMsVF6V3qgjeZ2JWzrrvgao450fhACDq
         PJvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IJY4UQNwZDSX3Ty+RTKFDTWqS5ZEkBgH5FUefscWr/Y=;
        fh=Elr2Qr1YA28O1pphnGhN/aGvyt11LoiE0N5ecQ4VOE4=;
        b=gFeTF3YDikWfOFT/VsGBwEHoRcyk+brzE2wc1nHHViVCdYt/+Ju9Uloo3b13o4yLU6
         bK1826Hgb3TNX1KJpSn7Gxr3reITS5O3bp68ht5n+oIS4S2EBFD5vwuz/fyiFS7OXDcG
         4ElunqOCuxLA7L/WsUApaET+sZEVm7CWEKvf9d8QTACqI5Bo/2Kxmr2bkIpAKtCjut19
         T90mP6WzcP7YhwDUS9xvl6rbcQBIA9D5sI41c4Z/xJjv4GWhevYXyIWkPyJgpA1jzyxg
         25awYd6fwVcC0r1f+Ssi8Pp+3XXRZ9ynmzaXhSIZ/Ldqj1ur95s4ZNsud6gQMRpuueKj
         ZZJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=multikernel-io.20251104.gappssmtp.com; s=20251104; t=1783455647; x=1784060447; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IJY4UQNwZDSX3Ty+RTKFDTWqS5ZEkBgH5FUefscWr/Y=;
        b=ZY9zlA9aslfxvDOBkzE2McUWOlgto9NUtxV60zXHvZKrObjIKEMWf7Gbd4ESkJ7zt4
         cwRIq2l282si5x9CMxB3COUrufaKQXkcicNTODGUDLY5+dHBmlX/s0gaZaJv/7om0HUs
         PNLX0IRbLiulaakypr8CJx5ac+Oe13BjOP+Hg9rpNMDsdSklfPgWORasXgCQFph56QgJ
         viMOFh4OsvGwopc/9GhShOhfrXjXWP0+v4hIcyJYmAGcz9A3JGjMAbotxHCpMTc24ILV
         Rxr5sP8yb5xGJKpZ6veqvFYRPlXpZzsi92+c3pg2cIB4BTNxe9BBt0ucILmHaaHrGW0l
         U/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783455647; x=1784060447;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IJY4UQNwZDSX3Ty+RTKFDTWqS5ZEkBgH5FUefscWr/Y=;
        b=PM+wSVE+CiGNlZ7rFzV9zFvEWGoBnWUB6YR97V7xe8e0t/L8EaerrMEZgmxbXQ7LqL
         R/tbvUR9GqtVqwLDg3XzOdt71BOW7clbtizFuLC/ZFVgcliYb5yfLEDASjShsepUMjrj
         3tpfkXzIj8zedmgzSIOXxapePSlWkl/UfSLRkO1xpX/TwwOen/vUAywUep49drNocExJ
         1PjBGQzzbu2SUGrtW0UjSZSJ90PIHoYPsMY5S4TEPwRJnnWm6kC0RbbIuamgEbUDpg+a
         ULbxiVlckmDhhL8PfbzD8bripX1GmvyfBCR4mXMvC3TeIAsTh5cZtVHOTMG5wpA0mjl4
         SL5w==
X-Forwarded-Encrypted: i=1; AHgh+Rp7vCLiU3r15gRDzVdmOt7VJrEyNLbHmxj2BLrkguN0RaKoBnP9ZNhIc7k6J6YEjJT4ih3Rrq819w==@kvack.org
X-Gm-Message-State: AOJu0YyTLs4w7aAcNscEwV1snVSwMqnXaP6wdn+l2KdAARi2TOSLrVJo
	QqFrAMeyq8Cef0cRkFhZs7jO+bpfElq9RBr/EUXmp3LUJAlqHv8PMjy9qodmPlyIcwH5aWwph1+
	rAYKzPrHF7/Oxhf623606EM6l7CWOBV2Y2bLiKFvvSw==
X-Gm-Gg: AfdE7cnd/eTz5WOFbc7UaTFeuv+rc/XyKjzJ2gYRWPSlyg63/trf0ZlJaKuAbelSe9G
	1hFEZIM/L9yyaTe7wFNXmrL/F4JGKVMU+THkg2K6veVDnqnGUfVsDIIchUl846uRyQ9OiV8dC6H
	ajDoiskTIJaNBMEXnEDULOMXK/lQf2mP7n+S9IP78qtVwJiBvw6L6++Rz7XjFsVvtgn6ACZ42R3
	04aayMg4X/xSXUH5QOaegMovLuDx7ePmiqY3HiFBacsyB5otzkHjtZEijwf3UJmPVJbI1Aj0oie
	bK60ffXXR6quNmHyPok/MGhd9hawcFLEGI89nbTyww==
X-Received: by 2002:a17:906:d71:b0:c12:1dd4:13ea with SMTP id
 a640c23a62f3a-c15a68c644amr278396866b.30.1783455647325; Tue, 07 Jul 2026
 13:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
From: Cong Wang <cwang@multikernel.io>
Date: Tue, 7 Jul 2026 13:20:35 -0700
X-Gm-Features: AVVi8CfGLtFoJOFYimGVdvg53iul44JrwBlAlfgw7Pqj4m0vivoZqsE8rR5IEyk
Message-ID: <CAGHCLaQwfgTJkQ5fgvGifrJNgwj-yEzoQsUzcWuSuy74KiMfJQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] seccomp: non-cooperative pinned-memfd argument redirect
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	Will Drewry <wad@chromium.org>, Christian Brauner <brauner@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4818440003
X-Stat-Signature: cd6wmtofdmsk7qxgcftki87hzqkpzypb
X-HE-Tag: 1783455649-826267
X-HE-Meta: U2FsdGVkX19LKGZeB9CG0Vbk44ShzkavWy3m0j5pLTjtA15xVsCVkzCArGEha7J5co4FhN28p4A5VAcq7a/NaYUmo8uJKQmiA+c0W9k5+NuJ8QZam+HEv8sca2lsanHfTmyh7mknE15wR76eJWjE+6357yXFtNJNEDvCVYq21pFvqVYFgJvdt3UAhYcx5r2tf0QPw2SMcR1PdTdFt+NnesLUg5G2EqazWtqI8HFCSuhauc0JvM3Qa4MI86YUoZO8j2MshiSShqweCMVsUmlkOutjmvUQhDkPtD75HRTOfLzmNZdc1rVYC0/x3JEOFH14scBS5yHaxhz7dCNbfOwMaFsw+7WQYggnhHLwO54FlSXryXG3hFjdRneaF/wUpmLyMXO/EIAEMEaraCa9TeYU49jV5+j3mAxHBsGg1NNMFa9O6590DkEyYlQNDRZqsdwEFdPoEfkiBrAd+BFydAbFXnvyD7Qhqhu5KHoNG0hmgfeb/T1GTvzHWOm+MIjfVqAB4uOwm7aOMa+kSW1kVIObRZdgH5vCh3F9HPCkkDmtCQO0ukwWJMFhniv5VZytX3hTvZ5kv0jL0B9H0Dwl4Fo4Vri0ZGbDo5nXetlMdrV05TgsZ29MJuIdSAdcN3ijTkEmINUnJaF7Fg77fKbq0BSlsPtn0KjO/ZtN6F6MU9cpU+9bt6T2qvqmHClX5azF7JOJ4mn7PxwA5WIKyGsxT+sqwdqrU9H428EokLEWQCUSr3RPo/cU4DqI6XTEIyeRaefhipHp9EQkJpt+5mjPugHggKFNhGgmuha1QTZ+OpWvzie6sgnl3tzR1dwd9lag1vix9hLZoKcxp6wbX18kp3gpkxpHlvaZ9RGyrwmmLfnwTe6NjjCjCEs8Vh4C0LgLvN+ZWs5X1rbEjZ856pKqf/NjD4i74vqY2ToiPFL4BDvnfusz4nD7IRW2/ivGyZKz1/ABVROlU/zJqQWj6dqMoxW
 X2ml25u5
 yHkUP9gqhKq+axKeBbB3WoVTOSMMuhzBa6CJ2I1jAT33D5xhDSM+ScbzaS/Az9aMLsH/C0wjkPurX1bykae8KVlmzfBaLGUr/AS5mgUGynQjefgKte42MBIbnZ2Hi3hA3Qw/4aldTKbgaC38O1rn10+CQA1LkcCyxD3bGBi+jVxXYwky1Mu9FhFAfGJGmfxHXooZwbKXyFvmetOzX1ma1Ti07Smx/sL1Vtj2G+FrfZWx1d6TotlxBp/HXeHwvM9QIgraQjkZh8mVzDVsswYwrlF7FYD95dWBu9rlY9/uXbo7daocZP6j4Y2eMP4Bq59Kxs1PfNjsWL7rgL3tFzpGvy+mbUPnxog5Qq36DxUyDoMB3oJQ6CVM4Zzj/l1s8ouj3VJPpCvTRqWkXPFhXU/vszmYeS/MLcKCAbq41v+MEINFpVqSdMfqvxyJIGaFQVUUmpiTJdcd7Mjw+JkTIDDIcM+EfbG8ISt2nqPpD5XnZd8ank7H76FSLXfkgLmzAkVZux85W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I see the AI reviews on Sashiko:
https://sashiko.dev/#/patchset/20260704231831.354543-1-xiyou.wangcong%40gmail.com

I am reviewing these reviews. Meanwhile, please let me know if you
have any other feedback.

@Andy, does the re-validation logic in patch 5/7 look good to you?

Thanks.
Cong

