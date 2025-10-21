Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E4CCCD1A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 01:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A0B8E000F; Mon, 20 Oct 2025 21:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE18E8E0002; Mon, 20 Oct 2025 21:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E7F8E000F; Mon, 20 Oct 2025 21:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B11D88E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:08:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D622C0364
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:08:52 +0000 (UTC)
X-FDA: 84020336904.07.78222AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id CE7B2140005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:08:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WvgMIthJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761008930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tzVBV0pAEJIOjyuvkLKo0YR2LnsPcwGlXxKHbAbaGMU=;
	b=nZp7esIS4yC6qrpf0Xf0rZJAKn6V0HsHSDiDMnirt3jEJbP39+6TMmhYRhp5pFdQfZTQYv
	qedE8mafExKjgANZjnMpQ3+pzHmtKi5MsADWpQzQOG9WJqoWeyQplj0B8HvmW3NqhZb/jP
	csrWx1V2FybnMuh6JenDeEzGBiAmbYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761008930; a=rsa-sha256;
	cv=none;
	b=zA0bSgDvnbjCogyZqyrQ5jaMmu+c+3+UCJg5hUEnOufTUsIJShp9VS87YEi4qQ9weoECdM
	dZ2sjj2lo0dbX+aCYSKtrU6HzuQ8/joerz+FnqwLg5mFFxNC1VpVGj0r3ccMlHBF6kbHX8
	V10gxeHKgZRiXldORrwAzfgO46u1JTQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WvgMIthJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2EFE6033D;
	Tue, 21 Oct 2025 01:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08544C4CEFB;
	Tue, 21 Oct 2025 01:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761008929;
	bh=oxV6DkSuzv67RKygZK1LFo8YEpvX0EUdzoFetLXu8UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvgMIthJ9SQxyaW3JpAr/WZsuYjZratdc9EjcLbPJRzPyBIU8k7kz2hbJVE8jrfWO
	 sHdgVx2arHT2FYNVnnsyrjunuNXpDv4Y/QjK029h/y0y/LZYGpFlsNlXb+9ENj4NNi
	 scNqrMwb8zEHl6Uw3Dw1Ql8WHfd16eoNbMP7beU495GzI34VcegiXTji4VVfb5tvHN
	 KqyNGx5mgBCrsttYPbdzmtqfJ3I1STv3Vz7jW/jxPkVAvfVwupJAlOE2QTTgnDoLQg
	 lia+48SNFDWzC5xbe4z3ZYglHnxmMAqbMgSHEXLlD6w0jVeXNKo4iJDL3+bpB5OXsA
	 byM0UDe8/TRbw==
From: SeongJae Park <sj@kernel.org>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev (open list:DAMON),
	linux-mm@kvack.org (open list:DAMON),
	linux-kernel@vger.kernel.org (open list),
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com
Subject: Re: [PATCH] mm/damon/sysfs: Remove misleading todo comment in nid_show()
Date: Mon, 20 Oct 2025 18:08:46 -0700
Message-ID: <20251021010847.68473-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021021712.59017-2-swarajgaikwad1925@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CE7B2140005
X-Rspamd-Server: rspam02
X-Stat-Signature: fmjpogxc83wtg18o7aj3k4uzkstosy1k
X-HE-Tag: 1761008930-484956
X-HE-Meta: U2FsdGVkX19JDGG+I4+PXicw2IyhOnM3l0TQbkagVAsHW851tkHyctbYeDzfeG8pMtQYaBxaUuk0oKhx34JQQZg5dcN8LCBHqSz8od1Q0fU9xAImwmhccTIF8IgBvjgWMhMhy6LF5m+Ocl9XljkoRXa8VxgOZ87qCANlaKaIfdxofbiApCP5OmsLzpT1zoFslQh9Z/Y4iS4LAz1HkQYDVtPicT9wU7JrAtUNrLke0c4GCuxq/dNQurJB1fsbhilT5jG8m1p26d1UldF5O0Eiz3qNBFC+QCsgZlpGQZRDgIApdbDh7cDWOHGf1ruIX68DbRYSAfaxMfQ4LV0MeBkaiFJalcRhvRtZIZP6wDYsHYD8a00TQlhOeD0nbJ0xHjOh76pITXp9QY7zWSTM8Fstum/jPcIDeytJAFYpAluqJ7FBXwddqHO0ranzLwdFqSOVenfhcOpGjGp9hzM9+sdby8IJa6HnjlMMn3T8eL+/mxiC0iF3/bUDgTcDKc59qfSKvlA298qpWis+n9qwF3Pg+cZNRCxBDKoasAyevm/ar0kdywiexvU4qHdtOUDMWgqR5ZxXc9s9uGgW4vhEULpQA7gpUOQEDkVL7NxCdgd8ndudi7Iv8s4Plb5tXpq6CpmebixwQKKDMJNeNMncMJcL4Ct6L8mIII3uPtzLiCRCg9vfyBMYYwOFSwfJ6dqGQYEm6v3ELmVsu1fKSuNt+Lqv2ulwWIaJl5BWDPlV3evPZB87yEoh3bPBjBOIWxaA/3QHDJG9PGHsMUr7Jsw/boUzeGD2z3Rh3zSTdyJdIO94tiVLLbDEujNUYwSgCAjO2VsKV9C34tw7huEaHJVe7s1+TM6NVIjtoydg9LJnRjbwISn5O2wG6rSVcYP/1aC7Dud1dRShkc988ff0y5qScq7KzLbxa0RN8VXSFnUPGY4UfkdR05N2iIQaVrexc180IG1L0vNVsw70BRmjHNM56VK
 IQ2mCOW0
 tlsKtLLEsKyGSpI79b8Mc3qj98ytJ6F0F0L3yobAEOrVY0g9ipa61/vNUVYf8mQUv71DP468J3fNF9SI+1/XUPBAWZGY2Mwl6TO7JzYkIHeCL2OnOX+IScs0VoWzh0w68R+EQwUolPlm2nGoSkGq/L48FU5Wa9f0WBT4mSddCKUA5l6h+gvas8Lmt0tExxe82+29YyS1PL4XwFLsY999ILkCEDdEBuwnWR1mONEag0Tnhg2FZM+Ii/sotqA+oRcW/909A0G91/K/9IHZYzqwFsNoyLFmZUKyq0GHLgfUp6dnGOqFeMtdCExKD87R7vvpPaQVL9x2qKYAV+LIqdepaF0KVJ6sbNmpdGpIIgmpZ7CCKNJ/Sg7CywlMnbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Swaraj,

On Tue, 21 Oct 2025 02:17:13 +0000 Swaraj Gaikwad <swarajgaikwad1925@gmail.com> wrote:

> The TODO comment in nid_show() suggested returning an error if the goal was
> not using nid. However, this comment was found to be inaccurate and misleading.
> This patch removes the TODO comment without changing any existing behavior.

checkpatch.pl complains as below.

    WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)
    #10:
    not using nid. However, this comment was found to be inaccurate and misleading.

> 
> This change follows feedback from SJ who pointed out that wiring-order

s/wiring/writing/

Also, giving a pointer to the previous discussion could be a good practice, in
my opinion.  E.g.,

   This change follows feedback from SJ who pointed out [1] that ...
   [...]
   [1] https://lore.kernel.org/20251020151315.66260-1-sj@kernel.org

> independence is expected and the function should simply show the last set value.
> 
> No functional code changes were made.
> 
> Tested with KUnit:
> - Built kernel with KUnit and DAMON sysfs tests enabled.
> - Executed KUnit tests:
>   ./kunit.py run --kunitconfig ./mm/mm/damon/tests/.kunitconfig

Not an important thing, but...  if you were doing this on the root of
unmodified linux tree, the command you executed would be,

./tools/testing/kunit/kunit.py run --kunitconfig ./mm/damon/tests

I guess it was just a simple copy-and-pasta mistake and I don't really mind,
though.

> - All 25 tests passed, including damon_sysfs_test_add_targets.
> 
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> Suggested-by: SeongJae Park <sj@kernel.org>

Other than the abovely mentioned trivial things, so nice patch, thank you!  For
another version of this patch that the above trivial things are fixed, please
feel free to add below.

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

