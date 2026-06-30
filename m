Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB87C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953316B00F3; Tue, 30 Jun 2026 11:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929CA6B00F8; Tue, 30 Jun 2026 11:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8404F6B00F9; Tue, 30 Jun 2026 11:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 513F86B00F3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:25:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDD75167F11
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:25:09 +0000 (UTC)
X-FDA: 84936952338.17.273F1CF
Received: from mail-qv2-f1.google.com (mail-qv2-f1.google.com [74.125.230.129])
	by imf28.hostedemail.com (Postfix) with ESMTP id 01CF2C0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:25:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m0Uh3Z2J;
	spf=pass (imf28.hostedemail.com: domain of coregee2000@gmail.com designates 74.125.230.129 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782833108;
	b=16v8236ZCQD2/nmSE4iAdmVde+mh4xZpeMCLagclHvaQ2U/XBaKOTFGsD05dbk/r+YXbCk
	jUeGoSObWCcRuzxkK0L7yvGdpZcYftEea9WUftrc5ufuAVBLWtFCMA/KFI1kp6X1x0yjIp
	x9Q0a+S452hfyOd8Np5ioeJkP4KZVi0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782833108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVIYUAiOb39REUcmN11MI5Dcw1qwjBtG4fOsMKnpR7w=;
	b=3PxvY1p3cltrr/y1r4Xi8KGZ2yStRQldB/Gb8NmyssuwO8oUaN1GZJzHtmPeZhQ9/Tx7ME
	I4ObZEwMJiIqnOhjkXjT3d+sGF96HcoGD0JCCk11v/OkKMAw4ews+E4U5YdnfL4qU+FCbe
	gS+pwT9fXpRMmm3tmJbqAxOHfGPpeKY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m0Uh3Z2J;
	spf=pass (imf28.hostedemail.com: domain of coregee2000@gmail.com designates 74.125.230.129 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv2-f1.google.com with SMTP id 6a1803df08f44-8efa6c5bebdso1043926d6.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:25:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782833107; cv=none;
        d=google.com; s=arc-20260327;
        b=mQBDOy6oVZm3vEgaG0UCXO6fpppZ8x6EFqjw33ITqWrNlgVc8EPjM0eXLhWBZgJZU2
         YEzarF7RDLtIVXbaahU9xjIBr8YiXGmKrIuyegfYEcoC7I/e3XjGzBnXqDsHlMVKewD1
         eeDLbGD9HfFeaFPhpP4EDf9H3xLlV8C9fIiQLGIz0xvBvb/OJMmpcNs9oEtf82AUPjfy
         eIyxP2/S9PIco2OmwtTWwxTppp4RXFj5jk9/TT6cVtRm2wflmP8p8618UCEwXegzNLgW
         LlXSWMtWpUdCKE+Qp63qqQjmdhBPlW1TKnzOd90muzFQoiSSYshq7YcR2qPSbxak4XRO
         Mr3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=mVIYUAiOb39REUcmN11MI5Dcw1qwjBtG4fOsMKnpR7w=;
        fh=vSEwZdrp1SiLtPeQXbZ7/6SmZ2tUT5MQGAfYZD69h+4=;
        b=E39cIjqW999uB2Q6ZsEuqCnuPH+1AfJQzRAACVHOpOSsb65L2FVqYUB+gDaqlz1p8N
         rskj75lCUxbu89+XvpCP2vsdA/LnGj9QKuu6TiI02gHAO4ZwUbKTnQRhZlLsmTjDAqPK
         UQCxtm5EQBZKK4kZj0F7iR/hJACpNh5fd8iPigoavhIKZRUKYzyOOT2tGzWtX6usGOvn
         4WWbNgudbxZyggRKdjt+BbyMo9f10WIFKAbGfH5BN8wjBjUHDJOWU9t9E5LtSrXR+fMH
         Z96qEIJj+OnSpl4J5T0s/MswbDLAWeHkdHtHU2M72hW02ib/rXFZhun8vTJd2PhDtsx7
         slJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782833107; x=1783437907; darn=kvack.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mVIYUAiOb39REUcmN11MI5Dcw1qwjBtG4fOsMKnpR7w=;
        b=m0Uh3Z2JzqFFiN2DHzlhkDr1VuuhQ97RpRgJwOvGFlfXG6vFWDybyCFLh+sA6VYhUB
         tcMxKs2FEebtomlhvMB/9PjlDMVskENqruSMWe3JFu+wV55Li2/TDgqRkmtSS9yzBxSb
         XkTpemD8OzJvt7ZXC7zDJRnVFx7yfEBu8uGCx90j458Fxjh0aQ/c5pxov3z/GWXcxY3y
         EqSrVuWWiNAcvgeOqRNFWMVwpVlEgkmuQmwjLqEbaVjvreyci50dDxhTtkvwiwI1eoje
         6FGbZCbGxInMPTMtodeRbqy/nz/MZGgLTRPdgWq4X1gdCXcjOS3trNpJu+OtY3NUBUAC
         4t5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782833107; x=1783437907;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mVIYUAiOb39REUcmN11MI5Dcw1qwjBtG4fOsMKnpR7w=;
        b=CqGrebGOicFZNoibeQB1nLrZq3aEeS72OA+b0ohMe6npsbASlJyMx02s5g8L3jTRHX
         OnK9n42y2u/24VDXrSa85knVswh/I7ktPYtd+i/Y7WqcPpCi/hRdjPI8yEP93vPrnBO5
         gyd5IrheR35ZPD5o/vgQ7/iJmypMFhlEwKF6bJ7vU/CZedoWFwcesaZe9wye6QyLHD3r
         IM48NS2xH4GNzdS1q6R7Tw/3Kd0BQFlVfCxdAhN4T6DeEgZL/9xIhWA42I2nIhQDP4wb
         K68adKr1Kr6h/FtRwqyjt7JWnj8jDqZN12BxfwjT71zHcQMMFTjdB9sP1ok4HsfQF1lx
         rU+g==
X-Forwarded-Encrypted: i=1; AHgh+RqV8wtldVwcK+gdSaQSxlm+ibKNyKtixOY992ttCDfHKlHc53UsukIXS9ELTTUBn/aqxNn5aix0XA==@kvack.org
X-Gm-Message-State: AOJu0Yx1kGaroDqVtddCv7l7BDpGlOx89EW4LV5NgUfVeyWOtKa6bTVI
	lav+A/ILLl8Y3RIh0fKXOmr7K2I+ln/S5E2BkSRJh32PJbT0RY/kFe13EvpNVimWmZsze9FOjhq
	YN+ACBlPYvYvHPwOg2jrCwuJn5hEXjd0=
X-Gm-Gg: AfdE7ckQ+l2ZIrdn5EF6E08FfaQ13s+o+m+U8Hp5bou0EZ6c5E8uLDiC9qdu2oeH49a
	U+L8KuAGq2nDQjfe/JZ+aOULqL5XXAXfyTYIdPAKDBaQhvVyZzLkFhSNYf/EuOo+eD3gdrSrn63
	WsgKN5f/Mm1SNtH27d7wqtlL+L/lPT+Cu3FFPORoZDg/sA99Z5ufR6cWSMHjLHavCqORcptXq7C
	UPpvw5l2UqZrqlNX8xhMZvc/oBKGMN79cYiPZ4dJiULbgWKQ+gtbsxzaFjDw+6MauFinkBfkg==
X-Received: by 2002:a05:6214:8212:20b0:8e9:f5de:d62e with SMTP id
 6a1803df08f44-8f2d2f62b1emr12390496d6.47.1782833106904; Tue, 30 Jun 2026
 08:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAHPqNmyHRaGj0fn+2FvvaJYi4WYOVmai6XX3bRCwbAZoj_GwWg@mail.gmail.com>
In-Reply-To: <CAHPqNmyHRaGj0fn+2FvvaJYi4WYOVmai6XX3bRCwbAZoj_GwWg@mail.gmail.com>
From: Longxing Li <coregee2000@gmail.com>
Date: Tue, 30 Jun 2026 23:24:58 +0800
X-Gm-Features: AVVi8Cf5cp4dsUIxK9ZOAQHkbDizIcj1Jx3P7T5zVQ-KEKspjGpIHXrn2AwxyXk
Message-ID: <CAHPqNmzacLWxDM4CSyEorgyh1tEyBfeOVr2gwUvUrtjZRCuh7A@mail.gmail.com>
Subject: Re: [Kernel Bug] KASAN: slab-use-after-free Read in filemap_free_folio
To: syzkaller@googlegroups.com, willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000008095706557a2e11"
X-Rspamd-Queue-Id: 01CF2C0009
X-Stat-Signature: 4fxagancnhjxubpkdwqsce8h9jhy8nzi
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782833107-297818
X-HE-Meta: U2FsdGVkX19r7rt/eKH1If6fXxPDyIQCMeENS2VqY4KOVIaTsaZg19QEZ1XVl8BCPdH2fuoJw2qm2rP9rsSeZBk1dQaofKCLui2ZUkbZ7wY/wFY8wKQIFeYdB/xHEK79bzN87IHs9f1o5fLRVp5W5bDNEcc2KAUjCb2iG4XTIXQpAy7i9lWfYfPx8wejdLZOrP8cImBCj/Qg/O7NfqNKShpsK73/Kod044HQAbbEhw4B1aU+ggK29eG2pV31hXeMF08jAb4jLVIhSW3rieQN7R8uYRlu7AKsZI0d1AXXFzSsYTsoHakXXDyZMFG/fYjxTPRY7aPKYRBjNytTh6Pzf2A04CGxDI0s80Pb3Ni6nPJ6nS8rBRuRFTJ6fKJ4pUVSgzjDPyoq9NI7ENEMXsjZPeajXheTrnkl/6WEadEX8bViqPP91zIPidxoARskrse5R0Vu0BVKVsY9vRPY0Vsd8sN1BZOW/CDFEuX2wtxGAUhJNr+6HJjXXfG7JRw1QHrS+23zqaqb6Yz55RMjUgFFwWAWq97HfhE//cCczOX9GbnW+6QxEwdMx8NG7KN3pej+1lM3mlZmxedJrZ9b97OginuQiPLxyaQqj3SmsZ9MJSEhBsiYO/hQp6OQcO7LdlqIx84/+9LkR9qUrnT8q/ly1YDPjDxwxZRUtflcGy/f8RCTlB7lJ26ao9sSVJNHVWReTL65QbI9N14UWXkRpwoxsU5O9FJLdIu2Lvh/GIqIMx18TDaIDyhDcJKh6M/Nvf6vzKoOwtOtiX0suENZdCz+zGPfBZy76JRvzK92urQ4iSgIx6EE0IQuzApxl8K1bUleiMpNhJqK3SE7mDuNMpEIgaUbs0+6FxwO6GkUwzFggPBzMLtbzzAtQlsCnCbj3aGtSzc93mpExzNF49M+pPd+mjBx7gqbig0UwZthEvDdCPWLE81aEJrGK/RefoGz+6s8dkPvB21NIDrs09hj6UP
 b1nKHpH2
 zO57BURfPOoeszWN9IknjjlGchWEyU4UMtyAQhaHCeuJog/BEhi8jzggAFflbj1uaJldtOJp7umcygq/V3v7aesmdFXjjcpf7vyPK0xJrLRa0bIB+umDKbl1+sK6aUsN2X67nec0DDCtBDS8MR01z7R6227IC2vvM+2H23s/nVACQ2XfLWvyvpj/AWUB1RPGPIqPgW9CN7y0IyUHjDpWygVZpEWG89yNGPTlO/lsEPCZ//EN6XlGjwEI9G07IT8Jj/+xaQWRZTDvFwLWV5uCFBJXIkQfS0+k6H1j1/a+Mp9Qn8rdLtnr68l3mMqDA8amuUajI8vfAUS0V8YInZSWbtQpc4sYOkz9xQN/woiQ2COpeRVwbq5+C8LArf/cz/cuCEXV3vk4aBZsA5YPYfJggcadOpGaBQb5v2nWxT8Jy/GcpK/RzIeExWexviNquPmGhlAotbI+8jh0Du5TZmQQivo6Jzurv0wzWpp3aNdZgdmacjYypkS/8fN/82UfyHaDjmUq/3k/+5K105RoLusu1h6vsH7QtXB9V989ArC7aplS+gASsdXBV4eJsXSsZoPYHYb2woqLGKy6v0zcOH7EjBHXjUTw2gRqRXAIFtH4SkT0xqmixsvBnMiiAqkwCodmo/Vx5suhtc/yU7hwA++x5nC+HaPA4yXvBTMKji8Rj9n67yfae/G5xXhFJQMLRAiLiWMvnLbbZCddqGbhXF3sh/am5kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000008095706557a2e11
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear maintainers,

I'm trying to fix this issue. The bug analysis and patch fix are as follows=
.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Bug Summary

ext4_add_complete_io() queues i_rsv_conversion_work without holding an
extra inode reference. If the inode is unlinked & evicted before the
delayed work runs, ext4_do_flush_completed_IO() accesses a freed inode =E2=
=80=94
use-after-free.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Fix

Take igrab(inode) when first queueing the work (detected via
list_empty check), and iput() after processing in
ext4_do_flush_completed_IO(). A per-inode bit (i_rsv_need_iput) tracks
whether the reference was taken.

Changes:
  fs/ext4/ext4.h      - add i_rsv_need_iput bit to struct ext4_inode_info
  fs/ext4/super.c     - init the bit to 0 in ext4_alloc_inode()
  fs/ext4/page-io.c   - igrab() before queue_work, iput() after flush

Full patch is as follows and is attached in the link.

Best regards,
Longxing Li

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Patch:
From: Longxing Li <coregee2000@gmail.com>
Date: Tue, 30 Jun 2026
Subject: [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion

ext4_add_complete_io() queues the inode's i_rsv_conversion_work without
holding an extra reference to the inode. If the inode is unlinked and
evicted before the delayed work runs, the inode slab object is freed.
When ext4_do_flush_completed_IO() later accesses io_end->inode, it is
accessing a freed/reallocated object =E2=80=94 a use-after-free detected by=
 KASAN.

Fix: take an inode reference in ext4_add_complete_io() (when first queueing
the work), and drop it in ext4_do_flush_completed_IO() after processing
all io_ends. A per-inode flag tracks whether the extra reference was taken.

Reported-by: Longxing Li
Signed-off-by: Longxing Li <coregee2000@gmail.com>
---

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1158,10 +1158,12 @@
 #endif
  spinlock_t i_block_reservation_lock;

  /* Lock protecting lists below */
  spinlock_t i_completed_io_lock;
+ /* Track if ext4_add_complete_io() took an extra inode reference. */
+ unsigned short i_rsv_need_iput:1;
  /*
  * Completed IOs that need unwritten extents handling and have
  * transaction reserved
  */
  struct list_head i_rsv_conversion_list;

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1414,10 +1414,11 @@
  memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
  ei->jinode =3D NULL;
  INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
  spin_lock_init(&ei->i_completed_io_lock);
+ ei->i_rsv_need_iput =3D 0;
  ei->i_sync_tid =3D 0;
  ei->i_datasync_tid =3D 0;
  INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
  ext4_fc_init_inode(&ei->vfs_inode);
  spin_lock_init(&ei->i_fc_lock);

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -260,12 +260,16 @@
  !io_end->handle && sbi->s_journal);
  WARN_ON(!io_end->bio);

  spin_lock_irqsave(&ei->i_completed_io_lock, flags);
  wq =3D sbi->rsv_conversion_wq;
- if (list_empty(&ei->i_rsv_conversion_list))
- queue_work(wq, &ei->i_rsv_conversion_work);
+ if (list_empty(&ei->i_rsv_conversion_list)) {
+ if (igrab(io_end->inode)) {
+ ei->i_rsv_need_iput =3D 1;
+ queue_work(wq, &ei->i_rsv_conversion_work);
+ }
+ }
  list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
  spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 }

 static int ext4_do_flush_completed_IO(struct inode *inode,
@@ -289,10 +293,17 @@

  err =3D ext4_end_io_end(io_end);
  if (unlikely(!ret && err))
  ret =3D err;
  }
+
+ /* Release inode reference from ext4_add_complete_io. */
+ if (ei->i_rsv_need_iput) {
+ ei->i_rsv_need_iput =3D 0;
+ iput(&ei->vfs_inode);
+ }
+
  return ret;
 }

 /*
  * Used to convert unwritten extents to written extents upon IO completion=
,

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Patch Link:
https://drive.google.com/file/d/1rPdp91vPxDnc74LxOJcJV3juvWhRxUtR/view?usp=
=3Ddrive_link

=E6=9D=8E=E9=BE=99=E5=85=B4 <coregee2000@gmail.com> =E4=BA=8E2026=E5=B9=B42=
=E6=9C=882=E6=97=A5=E5=91=A8=E4=B8=80 14:20=E5=86=99=E9=81=93=EF=BC=9A
>
> Dear Linux kernel developers and maintainers,
>
> We would like to report a new kernel bug found by our tool. KASAN:
> slab-use-after-free Read in filemap_free_folio. Details are as
> follows.
>
> Kernel commit: v6.18.2
> Kernel config: see attachment
> report: see attachment
>
> We are currently analyzing the root cause and  working on a
> reproducible PoC. We will provide further updates in this thread as
> soon as we have more information.
>
> Best regards,
> Longxing Li
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in filemap_free_folio+0x147/0x170
> mm/filemap.c:234
> Read of size 8 at addr ffff88805e6535a8 by task kworker/u9:28/46327
>
> CPU: 1 UID: 0 PID: 46327 Comm: kworker/u9:28 Not tainted 6.18.2 #1 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/0=
1/2014
> Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xcd/0x630 mm/kasan/report.c:482
>  kasan_report+0xe0/0x110 mm/kasan/report.c:595
>  filemap_free_folio+0x147/0x170 mm/filemap.c:234
>  folio_unmap_invalidate+0x514/0x850 mm/truncate.c:653
>  filemap_end_dropbehind+0x17f/0x1d0 mm/filemap.c:1616
>  folio_end_dropbehind mm/filemap.c:1637 [inline]
>  folio_end_dropbehind+0xbe/0xe0 mm/filemap.c:1624
>  folio_end_writeback+0xe4/0x1f0 mm/filemap.c:1695
>  ext4_finish_bio+0x78f/0xa20 fs/ext4/page-io.c:144
>  ext4_release_io_end+0x119/0x3a0 fs/ext4/page-io.c:159
>  ext4_end_io_end+0x13e/0x4a0 fs/ext4/page-io.c:210
>  ext4_do_flush_completed_IO fs/ext4/page-io.c:290 [inline]
>  ext4_end_io_rsv_work+0x205/0x380 fs/ext4/page-io.c:305
>  process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3263
>  process_scheduled_works kernel/workqueue.c:3346 [inline]
>  worker_thread+0x6c8/0xf10 kernel/workqueue.c:3427
>  kthread+0x3c5/0x780 kernel/kthread.c:463
>  ret_from_fork+0x675/0x7d0 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> Allocated by task 49607:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:77
>  unpoison_slab_object mm/kasan/common.c:342 [inline]
>  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:368
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4978 [inline]
>  slab_alloc_node mm/slub.c:5288 [inline]
>  kmem_cache_alloc_lru_noprof+0x254/0x6e0 mm/slub.c:5307
>  ext4_alloc_inode+0x28/0x610 fs/ext4/super.c:1393
>  alloc_inode+0x64/0x240 fs/inode.c:346
>  new_inode+0x22/0x1c0 fs/inode.c:1145
>  __ext4_new_inode+0x392/0x4f00 fs/ext4/ialloc.c:961
>  ext4_create+0x303/0x550 fs/ext4/namei.c:2822
>  lookup_open.isra.0+0x11d3/0x1580 fs/namei.c:3796
>  open_last_lookups fs/namei.c:3895 [inline]
>  path_openat+0x893/0x2cb0 fs/namei.c:4131
>  do_filp_open+0x20b/0x470 fs/namei.c:4161
>  do_sys_openat2+0x11b/0x1d0 fs/open.c:1437
>  do_sys_open fs/open.c:1452 [inline]
>  __do_sys_openat fs/open.c:1468 [inline]
>  __se_sys_openat fs/open.c:1463 [inline]
>  __x64_sys_openat+0x174/0x210 fs/open.c:1463
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 49611:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:77
>  __kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:587
>  kasan_save_free_info mm/kasan/kasan.h:406 [inline]
>  poison_slab_object mm/kasan/common.c:252 [inline]
>  __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:284
>  kasan_slab_free include/linux/kasan.h:234 [inline]
>  slab_free_hook mm/slub.c:2543 [inline]
>  slab_free mm/slub.c:6642 [inline]
>  kmem_cache_free+0x2d4/0x6c0 mm/slub.c:6752
>  i_callback+0x46/0x70 fs/inode.c:325
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0x79c/0x1530 kernel/rcu/tree.c:2861
>  handle_softirqs+0x219/0x8e0 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa4/0xc0 arch/x86/kernel/apic/apic.c:1052
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:697
>
> Last potentially related work creation:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
>  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:559
>  __call_rcu_common.constprop.0+0xa5/0xa10 kernel/rcu/tree.c:3123
>  destroy_inode+0x12c/0x1b0 fs/inode.c:401
>  evict+0x5b4/0x920 fs/inode.c:834
>  iput_final fs/inode.c:1914 [inline]
>  iput.part.0+0x6a9/0xb00 fs/inode.c:1966
>  iput+0x35/0x40 fs/inode.c:1929
>  do_unlinkat+0x518/0x6a0 fs/namei.c:4744
>  __do_sys_unlink fs/namei.c:4783 [inline]
>  __se_sys_unlink fs/namei.c:4781 [inline]
>  __x64_sys_unlink+0xc5/0x110 fs/namei.c:4781
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
>  kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:559
>  insert_work+0x36/0x230 kernel/workqueue.c:2186
>  __queue_work+0x97e/0x1160 kernel/workqueue.c:2341
>  queue_work_on+0x15f/0x1f0 kernel/workqueue.c:2392
>  queue_work include/linux/workqueue.h:669 [inline]
>  ext4_add_complete_io fs/ext4/page-io.c:266 [inline]
>  ext4_put_io_end_defer fs/ext4/page-io.c:325 [inline]
>  ext4_put_io_end_defer+0x398/0x460 fs/ext4/page-io.c:321
>  ext4_end_bio+0x2bc/0x580 fs/ext4/page-io.c:385
>  bio_endio+0x713/0x860 block/bio.c:1672
>  blk_update_request+0x93e/0x15f0 block/blk-mq.c:999
>  scsi_end_request+0x7c/0x9c0 drivers/scsi/scsi_lib.c:637
>  scsi_io_completion+0x17d/0x14c0 drivers/scsi/scsi_lib.c:1078
>  scsi_complete+0x124/0x250 drivers/scsi/scsi_lib.c:1547
>  blk_complete_reqs+0xb1/0xf0 block/blk-mq.c:1236
>  handle_softirqs+0x219/0x8e0 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
>  instr_sysvec_call_function_single arch/x86/kernel/smp.c:266 [inline]
>  sysvec_call_function_single+0x57/0xc0 arch/x86/kernel/smp.c:266
>  asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:704
>
> The buggy address belongs to the object at ffff88805e652fd0
>  which belongs to the cache ext4_inode_cache of size 2320
> The buggy address is located 1496 bytes inside of
>  freed 2320-byte region [ffff88805e652fd0, ffff88805e6538e0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5e65=
0
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff8880268b4801
> flags: 0xfff00000000040(head|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000040 ffff888101bc3a00 ffffea0001822400 dead000000000002
> raw: 0000000000000000 00000000000d000d 00000000f5000000 ffff8880268b4801
> head: 00fff00000000040 ffff888101bc3a00 ffffea0001822400 dead000000000002
> head: 0000000000000000 00000000000d000d 00000000f5000000 ffff8880268b4801
> head: 00fff00000000003 ffffea0001799401 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Reclaimable, gfp_mask
> 0xd2050(__GFP_RECLAIMABLE|__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|=
__GFP_NOMEMALLOC),
> pid 15633, tgid 15633 (syz-executor.7), ts 460463106471, free_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x1af/0x220 mm/page_alloc.c:1845
>  prep_new_page mm/page_alloc.c:1853 [inline]
>  get_page_from_freelist+0x10a3/0x3a30 mm/page_alloc.c:3879
>  __alloc_frozen_pages_noprof+0x25f/0x2470 mm/page_alloc.c:5178
>  alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2416
>  alloc_slab_page mm/slub.c:3059 [inline]
>  allocate_slab mm/slub.c:3232 [inline]
>  new_slab+0x24a/0x360 mm/slub.c:3286
>  ___slab_alloc+0xd79/0x1a50 mm/slub.c:4655
>  __slab_alloc.constprop.0+0x63/0x110 mm/slub.c:4778
>  __slab_alloc_node mm/slub.c:4854 [inline]
>  slab_alloc_node mm/slub.c:5276 [inline]
>  kmem_cache_alloc_lru_noprof+0x443/0x6e0 mm/slub.c:5307
>  ext4_alloc_inode+0x28/0x610 fs/ext4/super.c:1393
>  alloc_inode+0x64/0x240 fs/inode.c:346
>  new_inode+0x22/0x1c0 fs/inode.c:1145
>  __ext4_new_inode+0x392/0x4f00 fs/ext4/ialloc.c:961
>  ext4_symlink+0x462/0xde0 fs/ext4/namei.c:3388
>  vfs_symlink fs/namei.c:4817 [inline]
>  vfs_symlink+0x403/0x680 fs/namei.c:4801
>  do_symlinkat+0x261/0x310 fs/namei.c:4843
>  __do_sys_symlinkat fs/namei.c:4859 [inline]
>  __se_sys_symlinkat fs/namei.c:4856 [inline]
>  __x64_sys_symlinkat+0x93/0xc0 fs/namei.c:4856
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff88805e653480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88805e653500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88805e653580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                   ^
>  ffff88805e653600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88805e653680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> https://drive.google.com/file/d/1ZjRNEOf0XFYtFl5UZ7dvpJpzmPhje8it/view?us=
p=3Ddrive_link
>
> https://drive.google.com/file/d/1ShZndTsP1CZuwyZmbuZ-e5nHEdPjeIVX/view?us=
p=3Ddrive_link

--00000000000008095706557a2e11
Content-Type: text/plain; charset="UTF-8"; name="bug-fix.patch.txt"
Content-Disposition: attachment; filename="bug-fix.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mr0sscoo0>
X-Attachment-Id: f_mr0sscoo0

RnJvbTogTG9uZ3hpbmcgTGkgPGNvcmVnZWUyMDAwQGdtYWlsLmNvbT4KRGF0ZTogVHVlLCAzMCBK
dW4gMjAyNgpTdWJqZWN0OiBbUEFUQ0hdIGV4dDQ6IGZpeCB1c2UtYWZ0ZXItZnJlZSBpbiBleHQ0
IGRlbGF5ZWQgSS9PIGNvbXBsZXRpb24KCmV4dDRfYWRkX2NvbXBsZXRlX2lvKCkgcXVldWVzIHRo
ZSBpbm9kZSdzIGlfcnN2X2NvbnZlcnNpb25fd29yayB3aXRob3V0CmhvbGRpbmcgYW4gZXh0cmEg
cmVmZXJlbmNlIHRvIHRoZSBpbm9kZS4gSWYgdGhlIGlub2RlIGlzIHVubGlua2VkIGFuZApldmlj
dGVkIGJlZm9yZSB0aGUgZGVsYXllZCB3b3JrIHJ1bnMsIHRoZSBpbm9kZSBzbGFiIG9iamVjdCBp
cyBmcmVlZC4KV2hlbiBleHQ0X2RvX2ZsdXNoX2NvbXBsZXRlZF9JTygpIGxhdGVyIGFjY2Vzc2Vz
IGlvX2VuZC0+aW5vZGUsIGl0IGlzCmFjY2Vzc2luZyBhIGZyZWVkL3JlYWxsb2NhdGVkIG9iamVj
dCDigJQgYSB1c2UtYWZ0ZXItZnJlZSBkZXRlY3RlZCBieSBLQVNBTi4KCkZpeDogdGFrZSBhbiBp
bm9kZSByZWZlcmVuY2UgaW4gZXh0NF9hZGRfY29tcGxldGVfaW8oKSAod2hlbiBmaXJzdCBxdWV1
ZWluZwp0aGUgd29yayksIGFuZCBkcm9wIGl0IGluIGV4dDRfZG9fZmx1c2hfY29tcGxldGVkX0lP
KCkgYWZ0ZXIgcHJvY2Vzc2luZwphbGwgaW9fZW5kcy4gQSBwZXItaW5vZGUgZmxhZyB0cmFja3Mg
d2hldGhlciB0aGUgZXh0cmEgcmVmZXJlbmNlIHdhcyB0YWtlbi4KClJlcG9ydGVkLWJ5OiBzeXpr
YWxsZXIKU2lnbmVkLW9mZi1ieTogTG9uZ3hpbmcgTGkgPGNvcmVnZWUyMDAwQGdtYWlsLmNvbT4K
LS0tCgotLS0gYS9mcy9leHQ0L2V4dDQuaAorKysgYi9mcy9leHQ0L2V4dDQuaApAQCAtMTE1OCwx
MCArMTE1OCwxMiBAQAogI2VuZGlmCiAJc3BpbmxvY2tfdCBpX2Jsb2NrX3Jlc2VydmF0aW9uX2xv
Y2s7CiAKIAkvKiBMb2NrIHByb3RlY3RpbmcgbGlzdHMgYmVsb3cgKi8KIAlzcGlubG9ja190IGlf
Y29tcGxldGVkX2lvX2xvY2s7CisJLyogVHJhY2sgaWYgZXh0NF9hZGRfY29tcGxldGVfaW8oKSB0
b29rIGFuIGV4dHJhIGlub2RlIHJlZmVyZW5jZS4gKi8KKwl1bnNpZ25lZCBzaG9ydCBpX3Jzdl9u
ZWVkX2lwdXQ6MTsKIAkvKgogCSAqIENvbXBsZXRlZCBJT3MgdGhhdCBuZWVkIHVud3JpdHRlbiBl
eHRlbnRzIGhhbmRsaW5nIGFuZCBoYXZlCiAJICogdHJhbnNhY3Rpb24gcmVzZXJ2ZWQKIAkgKi8K
IAlzdHJ1Y3QgbGlzdF9oZWFkIGlfcnN2X2NvbnZlcnNpb25fbGlzdDsKCi0tLSBhL2ZzL2V4dDQv
c3VwZXIuYworKysgYi9mcy9leHQ0L3N1cGVyLmMKQEAgLTE0MTQsMTAgKzE0MTQsMTEgQEAKIAlt
ZW1zZXQoJmVpLT5pX2RxdW90LCAwLCBzaXplb2YoZWktPmlfZHF1b3QpKTsKICNlbmRpZgogCWVp
LT5qaW5vZGUgPSBOVUxMOwogCUlOSVRfTElTVF9IRUFEKCZlaS0+aV9yc3ZfY29udmVyc2lvbl9s
aXN0KTsKIAlzcGluX2xvY2tfaW5pdCgmZWktPmlfY29tcGxldGVkX2lvX2xvY2spOworCWVpLT5p
X3Jzdl9uZWVkX2lwdXQgPSAwOwogCWVpLT5pX3N5bmNfdGlkID0gMDsKIAllaS0+aV9kYXRhc3lu
Y190aWQgPSAwOwogCUlOSVRfV09SSygmZWktPmlfcnN2X2NvbnZlcnNpb25fd29yaywgZXh0NF9l
bmRfaW9fcnN2X3dvcmspOwogCWV4dDRfZmNfaW5pdF9pbm9kZSgmZWktPnZmc19pbm9kZSk7CiAJ
c3Bpbl9sb2NrX2luaXQoJmVpLT5pX2ZjX2xvY2spOwoKLS0tIGEvZnMvZXh0NC9wYWdlLWlvLmMK
KysrIGIvZnMvZXh0NC9wYWdlLWlvLmMKQEAgLTI2MCwxMiArMjYwLDE2IEBACiAJCSFpb19lbmQt
PmhhbmRsZSAmJiBzYmktPnNfam91cm5hbCk7CiAJV0FSTl9PTighaW9fZW5kLT5iaW8pOwogCiAJ
c3Bpbl9sb2NrX2lycXNhdmUoJmVpLT5pX2NvbXBsZXRlZF9pb19sb2NrLCBmbGFncyk7CiAJd3Eg
PSBzYmktPnJzdl9jb252ZXJzaW9uX3dxOwotCWlmIChsaXN0X2VtcHR5KCZlaS0+aV9yc3ZfY29u
dmVyc2lvbl9saXN0KSkKLQkJcXVldWVfd29yayh3cSwgJmVpLT5pX3Jzdl9jb252ZXJzaW9uX3dv
cmspOworCWlmIChsaXN0X2VtcHR5KCZlaS0+aV9yc3ZfY29udmVyc2lvbl9saXN0KSkgeworCQlp
ZiAoaWdyYWIoaW9fZW5kLT5pbm9kZSkpIHsKKwkJCWVpLT5pX3Jzdl9uZWVkX2lwdXQgPSAxOwor
CQkJcXVldWVfd29yayh3cSwgJmVpLT5pX3Jzdl9jb252ZXJzaW9uX3dvcmspOworCQl9CisJfQog
CWxpc3RfYWRkX3RhaWwoJmlvX2VuZC0+bGlzdCwgJmVpLT5pX3Jzdl9jb252ZXJzaW9uX2xpc3Qp
OwogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmVpLT5pX2NvbXBsZXRlZF9pb19sb2NrLCBmbGFn
cyk7CiB9CiAKIHN0YXRpYyBpbnQgZXh0NF9kb19mbHVzaF9jb21wbGV0ZWRfSU8oc3RydWN0IGlu
b2RlICppbm9kZSwKQEAgLTI4OSwxMCArMjkzLDE3IEBACiAKIAkJZXJyID0gZXh0NF9lbmRfaW9f
ZW5kKGlvX2VuZCk7CiAJCWlmICh1bmxpa2VseSghcmV0ICYmIGVycikpCiAJCQlyZXQgPSBlcnI7
CiAJfQorCisJLyogUmVsZWFzZSBpbm9kZSByZWZlcmVuY2UgZnJvbSBleHQ0X2FkZF9jb21wbGV0
ZV9pby4gKi8KKwlpZiAoZWktPmlfcnN2X25lZWRfaXB1dCkgeworCQllaS0+aV9yc3ZfbmVlZF9p
cHV0ID0gMDsKKwkJaXB1dCgmZWktPnZmc19pbm9kZSk7CisJfQorCiAJcmV0dXJuIHJldDsKIH0K
IAogLyoKICAqIFVzZWQgdG8gY29udmVydCB1bndyaXR0ZW4gZXh0ZW50cyB0byB3cml0dGVuIGV4
dGVudHMgdXBvbiBJTyBjb21wbGV0aW9uLAo=
--00000000000008095706557a2e11--

