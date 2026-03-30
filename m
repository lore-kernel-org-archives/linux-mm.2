Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A2A1061B22
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 21:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06F86B008C; Mon, 30 Mar 2026 17:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB77B6B0095; Mon, 30 Mar 2026 17:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD416B0096; Mon, 30 Mar 2026 17:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7306B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:27:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E511C2227
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:27:21 +0000 (UTC)
X-FDA: 84604015482.12.95BB2E4
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0E2C9C0002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:27:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wu6nAOnV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774906039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lk7LQhkM2WP8nqMeaOF343t6fTpbTtYx15pmZes5guA=;
	b=Q4HdyaVjXvjbxtdeDXtSFBzM75MJg7HgK/EM47kQj/lQs5aGmXvVmNySLa6J04CMCX3sPv
	lkPXBxf08L5UybKquyhzv1fshTgY/y3scE3HVr3wH0yNx72vZmlprZnsHjUm15qeB+YWWV
	DGvD94NCT6uhTrVtfHcreg8qvBA/JXQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774906039; a=rsa-sha256;
	cv=pass;
	b=V18vF9RCNiPVnaxyv3/n+I+6Nutc1aHt9jLtd9fqIzniEu0yztLlGVTHBIjfG09jT76ZrH
	I40/21Wi6BbFYO+Bn1jqgwDAIqS/rpQyCQrg4XD9f0IdL7TCS1p6CApIwhDRvXWNzEdao9
	DKXJI0yI6bTCcSgcFnCsYPjFBVIgSdc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wu6nAOnV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40f1ffba6a0so2527329fac.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:27:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774906038; cv=none;
        d=google.com; s=arc-20240605;
        b=fKGKovGPkQWd9qENN9fZpt85NwMe2wderLWOxYNupFpaefqcLGBCSZaeWjBwtvkjaj
         uM7eLvHA7Lf7J/JApv8uMHpc5ZykJDuG7e+18q+Mt4G71pd4OWaT03gNJDxl4U/E2U/P
         vGlt/7Dvwh2YPKrDVFPnd/nkZh63sz4dPTEZKVdPzcDtSKve9C1oJijpqhZoRieb3poK
         9YSZrCyJ5d2B+6ZkM84DLGSos4WHDm2MGDZA8Z7hA4LaxFVtTeNHqIipt9u0aH5ewvmc
         S1n0WRAIjYRJswwFSWYsZcFXFQnjZV/O5nSDxMNrBgCvX4538CBGtnLaxd/KY1nXICOc
         67fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lk7LQhkM2WP8nqMeaOF343t6fTpbTtYx15pmZes5guA=;
        fh=9W0OfIBe+znO+HMaB8TLv8xIRzibSRH5h79VO6fjbGY=;
        b=IZEqZH09tLQluQ0+fpBwK/5mNRbCsK4U29kqpOLTErwClB2pCc8q1jYehVI+Dav2sW
         aORzpA6SqNZmYqfwrpKB6nhX3lVHYwoVQsoFVBsIe8n7p+KY/KFCzfh3rigVgbZgEa60
         pNZUEHqL5l2lZMB383cUQv2lyKafrgYCwtPfYPPQuhKEvqZhVoPA4RnTchBib1fJt51I
         NwffiqqD+l4fjl/id8DzDA1iX13ywfKqnJ5yTJ2b+ULcZPM+6LalpVWk6BpPfLH7nZBK
         /cJUzdquF4sUBNu5K+mE5xn7JIaCTcS0ywGYb6QO4XeiHpHBJmrmA6OEQvXQtIUTuRKQ
         jHTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774906038; x=1775510838; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lk7LQhkM2WP8nqMeaOF343t6fTpbTtYx15pmZes5guA=;
        b=Wu6nAOnV1zDvdEg4s9YVXotYXvVSKtViBnd2Y++CAaiII0WHEmsen7nocPaNZScWEF
         4YnbcchiGrh4nVRzK5AFxnyRWhhvd2DuDAWIrF10w2wHJ80VONRqnQWZJzNgbRQsvwN4
         eQXotDGW2ZY6ErRz9XQ9EUx9+YCKk/Hj5r20S5oTd76vhE2LrYV+9jE4AkJgB4M+TiLJ
         CjkXd6SCAHu3aT0nzWAB+EcZ5lDZwvML+rGszQrDHGVDjGErHsR65/tkAamiv9hzznx1
         a72zgdMy7cEInukVJV5C1KckvD1R+8oDkzc2x4mMLDULoeuwmASKs2/3OngF942OQV6j
         zYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774906038; x=1775510838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lk7LQhkM2WP8nqMeaOF343t6fTpbTtYx15pmZes5guA=;
        b=gbt54N7dpKmN9RQGJ0POuIu5wxyKWTzPKdg3z+tt9QQxScyrID2bEEoxYzAcwVPNPy
         MeeBsnNEuPWQN9uwSQvCjP9CESvTc554CfluWXwvwbp/RDE1KGmsksIXKsTr0RGWugeL
         NM4gAyvs1bQT4ue4AZAO5AaDEXX4ffysLwm6MsD6FjLATgPvKFMrYNidwb1chn44Rf3b
         qYvJR6K5BqFdETjn+/zam4bU2NOJnWtIMZjloCQ9o7/I5wWE4kS7nMyrZ5TvxQbsjIew
         upRWUeS1GJhiG1LG1Hm4qygou2H7npR4xMODW/Vxy21ZVPM9emRbQ6S0oByG9RHmgfIY
         F9LA==
X-Forwarded-Encrypted: i=1; AJvYcCXILVP1se3CuFlJMc2B0Qo0DsPYX9lr5Uh2RxJ7plmHmXNI+eTz49ez4MjpCavBm3l0TXgTMKjnwA==@kvack.org
X-Gm-Message-State: AOJu0YwuEx3bUWi3+4sn2WX13avmi6kkpThB16FWIBtQmkJUHWe0cnzz
	ho9TMM4bRWVxGiVw5PLSOf7imO6DGoEWrKI16ffBSfS9JG0PmJdCiWvB08JWmFvFgZdFP/s+rMx
	2+OYYAs52V+YMYwgjvnZFvu0LdTvorvw=
X-Gm-Gg: ATEYQzwSezln9LHJqjrjwN0p0DIZnJznGepGB3TkbMNfiTJgM+nycYKFsGx9+4TvZim
	DpnOczgT0O66OZ/j4y7Fi8PXS9h6+K3txxzdLGat56ACoVK9t9+X35CBV1xvhFvLbWL0HnRXPyC
	ix5LtFnIFJzdktisoKjmQp5VjMPvzv+03pad5yfBZY8ZXeNmHk/HvIbjkuS9Bw5UlIV77aAFLRU
	XIfJGRI0P0RlIhyFAylOzXO/rJsEtNilJqzQXxYpwqdselfQkrLmJuAVGEDqN/+P2CdXlvgbFyQ
	zkVGMqR9OsxsbC24JHZayu4XuQtpuK8XZKkewA==
X-Received: by 2002:a05:6870:d366:b0:3e8:44ec:3416 with SMTP id
 586e51a60fabf-41cec475241mr9425362fac.46.1774906037974; Mon, 30 Mar 2026
 14:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260330202909.136776-1-devnexen@gmail.com> <20260330134021.171441c4c236b03efebc9a77@linux-foundation.org>
In-Reply-To: <20260330134021.171441c4c236b03efebc9a77@linux-foundation.org>
From: David CARLIER <devnexen@gmail.com>
Date: Mon, 30 Mar 2026 22:27:04 +0100
X-Gm-Features: AQROBzBFM_22r9M73kCmr2mRhrr_ps3OwyMq_rGFS731r8dL701F_-CyI0SOBWY
Message-ID: <CA+XhMqxnbuLObLF4kEucVmeabPXj94zdwWqdivyt2CzH8Lca=A@mail.gmail.com>
Subject: Re: [PATCH v2] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0E2C9C0002
X-Stat-Signature: tm6k4hjotsb8iqsc79cuwchkhq8ojz99
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774906038-9994
X-HE-Meta: U2FsdGVkX1+PFneSTRkVB8ev6J6DdcL2QL5ExgnoUkmmxu3JXRvTa7us2zLsP+BxB93nZyXLVH4MOqGxBA6MSgIKYm6MY7FjNgC01kM5UrMSLnAzk7aVKIlrHS1qDtHi4AFZhDm5sXVmSyP99BWTHxeGRZWiarNxMUzbnr7xmkZEHFU61EXI/5CQ0xfF13PDN7sHFdsbR25qzINL3A/fFm2GSANyxvCqjZGN4K2MZXaN9mNKUkn6ZUuaLB3Pz36oUALW3jw1BkOma1il71c0SKJv2MdL17k+YR0lgr+w1ohjSJCq/uX4c9vuvtTcyGUxRwClTuyEKof+vyoYESkD44guB5qelTsodRhsZl2Qr7/gKVfrnbKNXAh9rRhm70zmv8/Pimrpxi1qYvMZLuAFidwLDy5mWmSGcE8s8TpuNan2giDF3tZTSzvz/+fmhAdzTEUEEz+4VdG0BxdnXZxuJw2j3UQb++LXd5wneg7aVx2tPt8m+1JC0WpBfveImyRnARxD8LtbzbSqpNl1pHupXNsCrh3UQtfedPwl5BC1gW4mGSnyPLpTWkvdX5KvN9NPwyDXBvV17Z2dUJeqths3W2b0AeLDdIj56hQ4KGiswY7LAALBRxL5UbdzKIDXHxaHmmaTSxNYWcSLDtFVwyHhtVbwC4bU8KYVXj/uqf7g1XFX8/7QHaIWykB4lcqZxP18blbgQdsYj3FCgTl3US3PV1HgbHbdMEQrUJOmirQeVLqEDjh3f3+KbiJkr8ZZ5+YSL0Euqf2ky60BtzkPLALBBHDT5LtCgIjAKZrVe9HLRB4uvSzcIOOmeiWiRue0Hdj7anFZumysF1Zbl9LWxEkFfTZZ8dAyEdkISD/NcgHRSmQoqDbXpJ3UEQXFu2lClRDlVxvjhDlvgWeb+0DwoGDeOfJ5l8p4OPiZGR5SPjOTPEgFW0ETB+dsuPsauqmWGJYpYnKvFMtAnZwknL1q2sP
 62cUkGMN
 NjV8QqcB25Hmw/SpnvgM9E8FwhelpHcyPdiJBmZBKjCV7BS3l8bv6ll3b2VTpVcFqdbsWpucFDsFe6rj1reTkofJN5JnTkJ51j1siySbHcQfMIf4cJ6gnC+k/aaDJ1wR0GUeNjNfPsQFVd4Ft6R4usWarNdhqJ0fmZ2gNr2hsISV1TqWP72/7LwglVDxJzrSQLzSiAXK94FoWt2OonfC7qNRMrUxV0ejulLVtXgjzJv+HMN0JaMeJ1lDZEVq9PfBPBqygMtqmdSsQ/o4PkXE7wkqK6ZXGFOov3VOK2EnpoIfu3Oc1U8KJ1OzRrq02AiegWbYirqL1GGrhS7wvIuO4S1ndzXl6JEefBBZdTMReNX9d9ZsiLyoFl/CtL8dc5l32MhrwtYhf4qNjYK3InpsldoxTsiFMtnOL57kFrDFu2dIVAUoUbuI5IM9wrgMnoJozVJnerywu4woeSG+NyNn8G/pkAFUlrRsUWC67Y8iZA7zExTSLy1aTUG2RIQ3ju61Q55USNBLVTU00baptrklaTNwqmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On Mon, 30 Mar 2026 at 21:40, Andrew Morton <akpm@linux-foundation.org> wro=
te:
>
> On Mon, 30 Mar 2026 21:29:09 +0100 David Carlier <devnexen@gmail.com> wro=
te:
>
> > In mfill_copy_folio_retry(), all locks are dropped to retry
> > copy_from_user() with page faults enabled. During this window, the VMA
> > can be replaced entirely (e.g. munmap + mmap + UFFDIO_REGISTER by
> > another thread), but the caller proceeds with a folio allocated from th=
e
> > original VMA's backing store.
> >
> > Checking ops alone is insufficient: the replacement VMA could be the
> > same type (e.g. shmem -> shmem) with identical flags but a different
> > backing inode. Take a snapshot of the VMA's inode and flags before
> > dropping locks, and compare after re-acquiring them. If anything
> > changed, bail out with -EAGAIN.
>
> Thanks.  What are the userspace-visible runtime effects of the bug?
>
> If they're serious we might be looking at a cc:stable and a
> Fixes: tag?
>

The bug manifests as a NULL pointer dereference in
shmem_mfill_filemap_add() via file_inode(vma->vm_file) when vm_file is
NULL (anonymous VMA). This is a kernel
  oops/panic =E2=80=94 so it's definitely serious enough for Cc: stable and=
 Fixes:.

Cheers

