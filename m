Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4290DC531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 13:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42EB96B008C; Thu, 23 Jul 2026 09:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8C56B0092; Thu, 23 Jul 2026 09:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25EBA6B0093; Thu, 23 Jul 2026 09:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F04E46B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:32:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 720E8C04EC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:32:35 +0000 (UTC)
X-FDA: 85020131070.16.9AD83B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A663840009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:32:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RxKeUhdm;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784813553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NAWPQDEwgUQenFjlFjzBd00tOhMhEOyT4kNXUGq7gfw=;
	b=kCloH40rVw5IY9bniJRnc/Pz/T2yyUi6tP1Nfo1NX6YGxGUprpLZZiQMhzJ8ItOh3hV/r6
	y0AUhfDVwKkkK1657CZnoSSYT9zOzUqTVh7SvWG84KIOdH7oBuxmLiDNtAisPdMSW2LyMO
	wUOjohplj7wuqR42uSPqPW+Gje8u0EU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RxKeUhdm;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784813553;
	b=dTp1opklL3ECGOpk8+xm6sbCP/pgCSs+os0PPumCSxoZe8uHkZnoij90Rxay63BzAwNBYf
	j+pTsek7V6RMhKlO+WRCnK+UyA64gfnL/whZcq7f7Bb51uvmxPT64zfPeXKGAT2IicEb7b
	JaCyss9TgfV1g1eKSIK1qBECEYCQ9T4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1266C600FC;
	Thu, 23 Jul 2026 13:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90D81F00A3A;
	Thu, 23 Jul 2026 13:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784813552;
	bh=NAWPQDEwgUQenFjlFjzBd00tOhMhEOyT4kNXUGq7gfw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=RxKeUhdmBj4gJ1n4H1BRQDxOeHFg7Em7lrvFM95dPVAlyrqEEKogQVYaETnHVeev2
	 geYcv0RmFhuu30Q+RaFN0kQfKqIorfqhzFt4g7mFnEVulsghRfHaTqiNVaGt7etaac
	 yAOmy68hWehWYt4nkKVWJ2kxMoEhr02NkP+XMMIuVI0R6YdcnySFDuLWa5DkjWhY6K
	 HaG0+YdObuc19bGQxK/pVLT2mIkZ4k5w9ZEs5Fy2atEdxVgbj5m0PGVjXzM43oSEmL
	 6++8JM05scF/b7faXlUJId7oQljZ+E6hJDH6MWykOW5GRvZ88g4cNhK7sakvQFRiXl
	 FyRSSS3WdVMrw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 00/21] binfmt_misc: transparent interpreters and
 PT_INTERP loader substitution
From: Christian Brauner <brauner@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
 linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, 
 mail@johnericson.me
In-Reply-To: <178477872729.254289.15918342296936455606.b4-review@b4>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
 <178477872729.254289.15918342296936455606.b4-review@b4>
Date: Thu, 23 Jul 2026 15:32:09 +0200
Message-Id: <20260723-entmilitarisieren-respekt-lehne-5db75924c69a@brauner>
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=692; i=brauner@kernel.org;
 h=from:subject:message-id; bh=pmGT3faBfzPliMxibFwp5n4R6WM3SvhEchhx/+niCQk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlib81X/yro9uX6wzT4+aHLBEPXf2fbNT/97/Xvf3F5
 risLLmgjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIl85WBk2MB8ZUJZ64Y7+1pc
 DH5eufWsnX+Fh+Wq13alRYI1v3cz6zAyLJ06c8vDJ0cCLGqrLF/U8/f6mok2TlI0mm4VeeCTyNK
 XTAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: A663840009
X-Rspamd-Server: rspam01
X-Stat-Signature: b9sg16rgxo3o68hrxfenkwnwauemrtce
X-HE-Tag: 1784813553-411439
X-HE-Meta: U2FsdGVkX1/r9rdttj+cwIjgtHuFe0aHdKHVHadY5Sj9sgvICJsYSwL63j71ZVkEwBVfML4sxMgMvS7IEOcO06PsvgpzbN1kbMs/vzVsoBIM5GLEy5IMVq6Rev/Lgotinj8BTUfD4dpRKXXQjbUh+laFtLgiJ8bgr7eRh5oUBxi/ZeSrlfcviTM7nNvJVZjK9obDFJJJqPowzsQ/KcYxrgoiSjONWIA4e+8DoNQo+JAoo9XiszyG8bhfKoAf2QNAP2jp9xw2Mwml3ilLQwc05+WWtPIaO5NLlYEF9B/hUfI50QeOLoKfyoBzqJQ+YH2Dxt2yYa0H7Lfu/4dITHHCFEcpupFUH4vW8pQ0U5O3bZbs0i4oWAbcxZyX+QdjtsmV+Fk7HhwMtw46ApN+hW5CNbqgxrnonmFfDEQZH0RoX3HTLTHTRQGjpKHjb1ojZl8aFY5qYsQn5+hnq/rJHRb9ELKJehSiSTd3gbJfUSFrhk4PSLe5RTZtIdAeWDlw8c2ZWAuNRIdCQUrkojJrc8mKYDcm1tSOdCslpz4UViLN5aP3LFI9kKYoC5zSahBIjKjB0gqIr9bTehpoKJtaMQK6GCOkrI/zxvQo/JoaMfLsPYy03wvEAuWRJQixQhJUi2gfCOwCmx97llcNkMolQV9HcptvcGOQD+mno9cn2JXWliYd5xo9tNXbQYGAW3BOEyrDLojQZ3OuhIAY5LZMyRmi3zWJe2NLe/XX98dEa5sbA28ob1cJ65km5awYwKSD4BvEGL2Pf+/V+2nRDV2+IPTNfRKFUP7GWE/mpU9G2ZrmZnBnVwinI+ON720W4MbVrDRwOiebuErcaytRG38Tn+bso2+oWgypgkVBOYiaBSVYpr2FzcRvBAi+OLPg/2+1su+OGoyGSKxHubXuowLoCJoRWietbOuKXhN/YJVaD4/+ZcfZ9ByiYF1GUQ9MBePea5TLw79QGRJ68A6JPNUhQpm
 z0HQXBWI
 DRDg6Yl/rXi9tqXs80hC5Sfd2+kU2bPkVbF5Io186MNsellERVOA5I/8ZcRU7ESkAd8wo6ORYWTenrctT2gRHcTV1oaZUhFbsqa52aZEWJNxHayXtOteLktk2h6SFUoTYVYpjyjHNiTc/YMviwtP+DakM7tPR/ztdJVmWY56hkm0dBUqJDQ0ih6tUbwwwH03d90wAFj9fUI4u4dXJxY2J5LD9L4uOkvxl7y/j3ikRgDBce0J7sfIYe9V9I0Nkenyx2ZRgU+9DF1RHCGvJo9v/xhHNuJHJD4KDplDRCtiJvBYs6xGGzzY2m1WtdmAdyX8/bMJ32G2rtHdfzJuoxYtAdHNAzmCvS4XCpBPh6IAz6I4+ilVEzZ0FhMcMDXKe1BW2WzJ+jCXoBZpMV/scy1Xy45vwnEHFXJEuI38u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-22 20:52 -0700, Farid Zakaria wrote:
> On Tue, 21 Jul 2026 16:13:42 +0200, Christian Brauner <brauner@kernel.org> wrote:
> > [...]
> >  tools/testing/selftests/exec/loader.bpf.c          |  56 ++++
> >  tools/testing/selftests/exec/transparent.bpf.c     |  57 ++++
> >  19 files changed, 1823 insertions(+), 303 deletions(-)
> > ---
> > base-commit: 6cea93ff6fe97df34b63fe94487473e16c73b74b
> > change-id: 20260719-work-bpf-binfmt_misc-ptinterp-e6ee99ff6ba8
> 
> Started to review (slowly); looks like the first ~10 are mostly NFC / refactor
> / documentation.
> 
> This b4 thing is so slick; I want something like this for GitHub now.

You're not the only one. :)


