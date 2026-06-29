Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CDE3C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324856B00E9; Mon, 29 Jun 2026 09:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D43B6B00ED; Mon, 29 Jun 2026 09:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3B26B00EE; Mon, 29 Jun 2026 09:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F20D66B00E9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:57:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D4B216330C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:57:05 +0000 (UTC)
X-FDA: 84933101610.27.FA1C283
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8252D1C0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:57:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RUu9Xm6Z;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of alhouseenyousef@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=alhouseenyousef@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782741423;
	b=JZ7hJS7Aui9gFtcDoENm0rBZ75QIKaBB9krfDSHNOcN/hZexREKAoTNKgJLrRB6rgpLTrN
	LRkNf44oLdzQmPjDtncBCNsMRISopkQsAO8u2lSxcFLL3sbV0V3HiQkx/bQosZ4DUs49h4
	CCV8GVuhsS8rvMyfsNKkuYarr6TX8EM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782741423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdFo5cH/XscFmXKFc2L0Oc/loLftDgeJhJslg7IrnE8=;
	b=dHI6lx2rUDew3oJx+Wx+6gB9SoW6OqPMmpYah6rd4hc8SKuLLfvvkfWGJSKDW4sQ4MYuUZ
	6nuBqRn+5MIXNOly8VWBzoMFX4nUjI1T5v+bL5HbvdvD59B6s/DrNWA154SkLFpjsdkx9F
	rm3BmlhCsyEPTGTRxE/q2q3cB5vmwnA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RUu9Xm6Z;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of alhouseenyousef@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=alhouseenyousef@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-80e46c00f3bso8039057b3.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:57:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782741422; cv=none;
        d=google.com; s=arc-20260327;
        b=R+RlXJ/xNy01NrlkREkYViyIKyEp26QIB4FrVs6XycxIgRbsugrSssyfAlLWp2byzC
         XsCF4+XVIQgftP4Rrn5D52/QgqPNy5Vk0lpijw+5v7ji1giowT62NWs7oxKecLw2OhqR
         k2csDP5hDl4wvmHh97AYuhdgVR27MlgR4u/5lvobOPXxlBoM0g2hKhThDX0AcvGSz4hR
         bPztr1/+mQknm7YAfZ1seZFzJGRObWPfZOZYknsaOMMR+ZaF2a5GaTDLN77kG1nczI6y
         xHD9ygbiqKNrZMDDbZy9dStBrimuoM4NKgJZoYO5yD7ISyyNZVJqNKhp8gnGa5PLVj0M
         zVmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=jdFo5cH/XscFmXKFc2L0Oc/loLftDgeJhJslg7IrnE8=;
        fh=CCgchuCRTcTROkBoqrW5f3RaDE5cmgZDMbcQkRYS+l4=;
        b=KnvIneLM+fGUv2Bn/EdCiSzOYyKVoPW02w3JEM/6HCpq7MG91SJHjg1wcpV18IWW8a
         /8WkNOp3v5/+mUzhjJ+Khlyw/O5nOEA/EUCfYHZmEBa6CHCXlmzQ94UuYRPOx2YOFIy/
         hOyxq5DawVSOE6W/65K6vzx4wk/nxO5ClCEYbqP2NAHjaL87MM49CCAdUW3RKEfarvID
         thYfDGJk+Wm+gZ5W+ir2Z+lcpTYCWzT7aJ4O3s+avRQDGyKQzoZcmJQW6rknCVjdTKLP
         gqGj3i4baOcsXAxACCaN7j8sjgHiehaeaSGs4AiRYwcPlWr8OEpmroQlzRPWIz3+5CZ+
         rKQA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782741422; x=1783346222; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jdFo5cH/XscFmXKFc2L0Oc/loLftDgeJhJslg7IrnE8=;
        b=RUu9Xm6ZNpzcLbHetaX1Z5s2SN/RgEOnmBCUnSDzP31umyKIBAIPEUkCFsL6K0g7DL
         3Wh9tCODB3zHUNgB55pIfn9rNajpU9tmhPJ4wab06FcOAhaXIBiJcU1EMkLhrbUR5WFG
         hKcgmDNhU/HhFh2sjaRr8KeVu9NT0/dj3tVqIk8GM6QQyE65VHbT12kIZDNSBZELPTci
         KMVenWkmFid1fYEJbuz5pWJkt11m8wW6fTIknv033BlY45zV59YoPmriRYgO95GrsgIP
         1yuksBDs8fpUE+610hEw/Sa8p98arIr0B/QDb6oB3n09TtEsFG8g0ir8jxbGwM/bH1Ag
         O6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782741422; x=1783346222;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdFo5cH/XscFmXKFc2L0Oc/loLftDgeJhJslg7IrnE8=;
        b=cLwznlPncf964yFZ1lyz9lJqtSFmerFWE0V4CuA/VPRvLhlda1RlFNfnqM/x93O28o
         hIXbHJ8WTXg/ZimXlXt6OD8Z4yeXAL4ehEjbBhnvAyJ7JQ+KMczi6PJshuYkR5OZVURD
         aKog3HOZwg2Kdt7KvT4B79uX4pDbBeDS3bcTDhfHqCOmUe8q8I/YLBeyXHtgJKX/l63F
         Hcr8FwSThtTBQNrDxRbvGHMXovfcLQB4BsNzDfyIv0aT7sszYuxoPZrHYe5w2/EHWOaa
         e3F9IeaPEVb3EL9xDnNG67Xk6H4/cYM7J0TYksFVyMfwNYnW5JcvchOTFRsWr5UqyJLV
         3CuA==
X-Forwarded-Encrypted: i=1; AHgh+RoGm7Mg5d57DkXd3HqosGtJK77VZ7SNkQrXRJwTqqa1eslSIAn3h0ZjPl8Xg7kTdpe4NqYVURxLLw==@kvack.org
X-Gm-Message-State: AOJu0Yw3PDQ4IJoDte/xXDbkzJFRuHfYOz3xgFPy9DopVzzKEjCPTeZb
	DKGyL4INYZ+MKOpeDyHc9BQDGS9zx7SGokW2uTWB32qIQvLATy9qn7IdGBlbsIO0LK7jWzWWH21
	4w1YKZl9kx78BR0bN0iTl3kfMiW7by+4=
X-Gm-Gg: AfdE7cmf2qamCh9jfujYx8+aD5ta1q6g+8o1G6zGgUh1CO18sEhkw9Ds2m4DRE3LOAs
	k0keZJ6EJvCMGzQMgVwWylB7rVFpo5ams+zoKY7egBpBYtHaTZ8d9nnqk4id/GXjwj3ZbME+RcU
	20Y4d7+Xqu1eUIGUMKuDhN3ImZjzu6eupCuvqVMWZMmIsn3MQr/2mvDeW+vp8tlQnpJ+CkhtSCR
	r2+CJI/t7Z4L6xhIBkPZbKoS04mNwRhJU8Wh6v25eYk/BRjGvS2Yg/v3s7NoeHQo7ws+HPr
X-Received: by 2002:a05:690c:6c08:b0:808:f9bb:3832 with SMTP id
 00721157ae682-80c7281f47cmr91490817b3.22.1782741422304; Mon, 29 Jun 2026
 06:57:02 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 29 Jun 2026 08:57:01 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Mon, 29 Jun 2026 08:57:01 -0500
In-Reply-To: <dde92cd4-c6fe-4339-a892-004ca78ebc30@linux.alibaba.com>
References: <20260628004314.27370-1-alhouseenyousef@gmail.com> <dde92cd4-c6fe-4339-a892-004ca78ebc30@linux.alibaba.com>
MIME-Version: 1.0
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
Date: Mon, 29 Jun 2026 08:57:01 -0500
X-Gm-Features: AVVi8Cf117p4oIGfG8WMvH8mjl3V9I8oAyu9H_TLtIAqQHBS5gnrowmyLrhOSto
Message-ID: <CAMuQ4bWRePpX_R0BcGgvFYuACGPL2e8pVqf=dh54EBteTx-Bxg@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: zero unused folio tail for long symlinks
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	syzbot+bf5586280a66e9ccdfa9@syzkaller.appspotmail.com, 
	Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jwyfps1n5bpmdizxy7iogy3skef8k7cq
X-Rspamd-Queue-Id: 8252D1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782741423-77879
X-HE-Meta: U2FsdGVkX1/ityqt6FJ+5UaB5iijiTnGLflhweWftC2/S4dLsYWzJlE8KQ4WcM7z2A+wdD5kAFF3s3Do9JrBuXK4L+lv/hwdDlQqvfJ+H2q574wqoBgDTj3yEXLxgHApdUt/8YBeBYDn8nNmDUDdzvz134jLU5lGGvk2ywZOIClASYTDi9Oj0WJhuDpyXpzEFq7PxA7I2M+R7hB22066hacQ/mLCdeGHaJmEbB4XOpXgecTT91NlATBu8J+YjfJe477WOjvMrdh7J45kSkS0BGgoii0+IDXtXKsD+ElniXkjSTLyWWQ291kgmy1S0gkjJoiQhyzM5FMCFLHWN8ZwoWSthlaPL1lE9sB8dJmCcciux597li8kDHnF5llzkajf7IbGkfACbgawA05r2ymKm0haiackvmCclSijB4pMDLNpzDKUc2bs4mnmnfCJpJPG8YYms7VlstiDchiP5KdIh3t99hX2yB2tmV6VwbgCqrIx7GuBLBHVe+3WHrLlAfF/1zSnBRPzovU+RkWzAKxnFEfCVo8t2aogZAG81F7bTadPMD0M6vu8X3yEvuOVMaStWJUv/Gnhg13kJ7w+pyTWVmLnFXBmXmWt9iTU0tYMv3mqTHvd5q8gi7HzYYTPigTcHtjr7m3mWU3lEvWecIaGNyUYZgqeGEjidMJsThFnvlFQEBmYeg25D05GkzqUcWdLmAJ+shv478CLZ4LjOJSjaHixnIqLK5hPEkwYib7vEf9oqDXyWuSXn4hVGRzQZL3T+d2IdYN0AJbPUClH4/qKC/jpSB5sEKGQoJ6WiVynRdSMwgayBM+9A2gMcsmkWY8RJPyeOBEQrjJ/y2q3p8xiv4KchS6MUUX14Nrpp66h1Hk4O009xBv5a/aXOR8Z+L0fv1K3RF74mZjwgzlQ34UWRXaXI9FPJYfBxThvoOhmfORKGLtOZfzOeDma93A5ZN1nqPWtcj7+8GlYRoeV/8x
 KzbpFoEH
 Crhy6Jg3D5tZKy2KS9i+Ja9G3JDlssy06DwtxvbcZpK3Lf34SfGVpozVWiVcoCfgVFlrgtmbF1vPuyuBkrqd3B1KHjLKhDHxoI9BTffMsFtfieTzjZa0UDzHZ+cZXi0BnEgDi+LRVkv+y9cnKAKqtummBwFan4ibFm1SA1wUoF4xFDExxsgtJMzlENvsRqTxE7wXcIi/SqB1FsANp+77N9ww2AwYxk1NNOR4NoW6NWiH8i7SC1zQvSbcGLyqTI0w4T0SUjZup1vlhW67aCzKvls+SqHJZfgi/x4XbBDp6zjP3TPr4iy0Oe7Mb+iiN13x09nDI44ufZ1y1Sxi0I4RGuwnmFCZlTL8wOBDLu4PHhCVgMsFTCjOpcS5w6IpkkDS440+xLgGG4eKJk16Om/CFznQzXsl30ufYpN4LaekyE5nLP5AG3+2tUjD6AE1tY626/M+vWAq30FC4DApyc7RhohxRnl398ltROuJe2sJeiO/LAfaL8iveSZmCrxWa7tuqikt042gL8rqn5abIYAnb/zaLZt4keLYiEzaPrItOy4cLk0DauyaTFLEO6m8O0aCYl0PTX7prCM9sXA6F2rww6WAQRopPJoQpHiKQd91488VkOd4ngOwRCzH4h5YsOYX9vEszQuSkpw8riVxbQIwYcr4y+Ur0yRIP9JQW7ln7tes854Ccer9JgqF9G4B7WbSn63rJ2CfRVl1sXn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I only observed the KMSAN uninitialized-read report and did not
establish user-visible corruption or disclosure. I agree that does not
justify stable backporting by itself.

Andrew, please drop the Cc: stable tag if the patch is carried.

Thank you for the review and for the pointer to Barry's earlier patch.

Thanks,
Yousef

On Mon, 29 Jun 2026 11:27:47 +0800, Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> CC Barry.
>
> On 6/28/26 8:43 AM, Yousef Alhouseen wrote:
> > shmem_symlink() marks the entire folio uptodate after copying only the
> > NUL-terminated link target. The remainder of the freshly allocated folio
> > is left uninitialized.
> >
> > Reclaim may pass the whole folio to a swap compressor. KMSAN observed
> > sw842_compress() computing a checksum over the uninitialized tail. If
> > the folio is written to a swap device, those bytes can also leave the
> > kernel.
> >
> > Zero the remainder of the folio before marking it uptodate and dirty.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: syzbot+bf5586280a66e9ccdfa9@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=bf5586280a66e9ccdfa9
> > Cc: stable@vger.kernel.org
>
> Do we need CC stable? Have you observed any actual impact?
>
> > Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
> > ---
> > mm/shmem.c | 1 +
> > 1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index b51f83c970bb..b06c1ae2f50c 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -4057,6 +4057,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
> > goto out_remove_offset;
> > inode->i_op = &shmem_symlink_inode_operations;
> > memcpy(folio_address(folio), symname, len);
> > + folio_zero_range(folio, len, folio_size(folio) - len);
> > folio_mark_uptodate(folio);
> > folio_mark_dirty(folio);
> > folio_unlock(folio);
>
> Thanks. Barry sent the same fix before[1] (though I forgot why it didn't
> get merged). I think this is a reasonable fix. So:
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>
> [1] https://lore.kernel.org/lkml/20251224020424.52976-1-21cnbao@gmail.com/

