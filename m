Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A51EC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5921D6B008A; Fri, 18 Sep 2026 20:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B4F6B0093; Fri, 18 Sep 2026 20:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A96F6B00A1; Fri, 18 Sep 2026 20:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 293D56B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:57:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0338160171
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:57:50 +0000 (UTC)
X-FDA: 85228699500.23.C366CA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2232F80003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:57:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h87AVbGm;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789779469;
	b=HV8DA9WPxgIfr60V2jcJ8wabxiOKA8CaFxIkTaGotzlO8CGvS8WnX5luwM/pmpSJWCBVbR
	jVgcDwOEHWDADykimpVJLlIvqEml+aLR6mIGbcgaLVMCRwS3w2Q27hOoQLxGcTiVbqn53k
	Ljqm4iZwY2igV1dNeVNmh9+8E5IIZAI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h87AVbGm;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789779469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ou5Coji7GvP7rg1t+gMtICHH8GO2v2T+xA+Md9mjovQ=;
	b=KoiYfMYTw/0E9pJIdmzQAkurc5LiYh9ffjdmZJr8zgShxPC/xmfFA3rOez2Y7xyGJAYf0H
	dgLpM6kU1krLcZbDotw7eC4eRyKXZGI3vFEtVhVj/vlVXH3LC1SqOERjP/REAIkstz1MLt
	g1R3a1G72ahXQwKiBP+syPxxZcHfNLI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46A7D41817;
	Sat, 19 Sep 2026 00:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24841F000FF;
	Sat, 19 Sep 2026 00:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789779468;
	bh=Ou5Coji7GvP7rg1t+gMtICHH8GO2v2T+xA+Md9mjovQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h87AVbGmoFOfBWO7pFDu1hE8BqkQpNxItv7YaHnYPOp/FWH4Q7teRITPVCo/yVWD8
	 BAttH12CmgD2YP2nAuFF9KGBc6bhWXhrdSqmUhWfg3QleUcT5I2/S/ENOnx0PODy1D
	 Pif0hMae4HEOQeNBgNW71ZpPwgAw6kE0q1F1lucjS0Qt4HmNnVSTpLNysob/l/DiBR
	 9vAoiwv/R0JQQH31kfzcuxzD8jj5Z6ncYg8nG8BXGVJJu2m02PgLzNV9OFxXZpqAs6
	 L+ikMO8MHaIrcV1RACLbWq+a0darZ4e7fQ7iV/93Zl19cHHDpn9HxRIuJ4bZRbNYPg
	 f0teyhE9IL/ew==
From: SJ Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>
Subject: Re: [PATCH] mm/swapops: remove unused is_hwpoison_entry()
Date: Fri, 18 Sep 2026 17:57:35 -0700
Message-ID: <20260919005735.87860-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918165642.1014988-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2232F80003
X-Rspam-User: 
X-Stat-Signature: 6yjqi4sbck31q7jhtyg9ibpgfgj5r6nu
X-HE-Tag: 1789779468-839822
X-HE-Meta: U2FsdGVkX18f6f9HtRhN7rhey4cyfygZL/Yx503Uzw5CcjqgIYn/XKyVk/EnnidYrWyR7rVeLIPc31eOM4jrWCXSJ/WDd0/OGODGUX8UQT6w4cjqNsRcFtAhgI7YKlKltayy01ioXDJFKsllHshJ0PHmDGaJsn5dqcMlOSwZORhc3bi/t3IvsdeFAgdVx1z3a0JHGVKfYr5otJK5W0XFPU9Uq1scVhQLm/RyA/ukU+fbBs0o3E6laGg4OKq9vtu0D1oq4SsO0xUJQ89Cggdg9kgrkQu+V4GrdS7qUfQAczkLCYiFuUpiQnnq3b4D9+Dw4WNjDsbFJS9QEi4kZesF5FAA9Y78cHLR5vkTXgkvS62ECx5iixEgWgzm8YOp+1XLh2ZMwMM/yYYD53thcQLfEfrNzH2DETIF+kQSc+3UC0Vhisu1m8/DRR5ijeivwa+ALOea/8t8Fb7n3tekRC2WBGqy4N7FBRH/jz/1ogF3r7CzGlY4EzI/viLTKswq1t3c8vnIH0wI1yxWBYzy89a+A7uAZq0LTre10xYIilmREgVxLt4qe4GA03X3bkiifFJuyr8lHvT5C3awaY6TD0aH3xSdV2Zno2s1/kryF3AVcW8q6eoL7tjX3oMUg0lj+m9gvUJXsXlvl3NSOkU4exRvV4De8fCdF6s37gX8f1gLovBbR5nObBBDaYGIJZFE5WpZxMZLDV1wvThGejZEP/qIJkqlg3NXhOUznFu5Br0cMVcykKQx1a7VtJVxGHNKuQrpGU5nInX8rE+M+ELNZKVBK8UUcVvEz99lPysKog+zGzJnbGxH/6OOk/SBKbKiH+uJbA26HAnE96wfPoxzdfC52sWr2okGc7LaZQFFIQzlXD9zi6aZJx9u/tI8gNK9QaB+JTfQpNxkWA4RBVQNZ9t/QB6G40CIfSYz2thF/k54O3n/MTO8R+irNbKYp55+5qCe8JNYwakR1+bl9VE12Q1
 ywk/PWe2
 s4Ad7A+7+sCuIrN9ZuKuscEyQCR5H1yCs+UYnqJ5zV+I1cde2PJFQjabLjLD1kHO61lrixalvRMCd5Lp4TVtqLLLjhD8MTyU1DaGsj8+1qAGSCq4nTaEMguJ5LW4KvnKA90mTeYaH7tb/xtAMp1F/yG+rqlK3qihY8I5P/oYRntfF4qvC6I+B7KofY8CrK93FCQfkmA/3wn4gn1wyfPkmwg77PLrzk59A6BnGuyLMwrDXXHVJekPYw+RIaqNISt056ziTKyzW0IflwkyK3h7mkhy44KrGmrREjBXG5ijLpjbacPpAnCjDzVoAiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 01:56:40 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Since commit 93976a20345b ("mm: eliminate further swapops predicates"),
> is_hwpoison_entry() has no callers.
> 
> So remove it.
> 
> No functional change.

Looks correct cleanup to me.

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

