Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A55C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 12:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976146B009D; Fri, 21 Aug 2026 08:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926D76B009F; Fri, 21 Aug 2026 08:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D106B00A0; Fri, 21 Aug 2026 08:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9FE6B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:54:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA89D140113
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:54:35 +0000 (UTC)
X-FDA: 85125270510.05.7F60839
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A15240007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:54:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ClW0ENRr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of agruenba@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787316873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3T0DA5j0vwcwUo9HIMuCVlwa1ONI5AchHTxjE6rvQY=;
	b=d93C/nOHrOd9RRqFoSj08qZwIJ7D4I/dPiWq0WwLA45w9CG5g6WoUfizuiOJpaQ420odch
	JsJPT729/7ik3vXooFssU7G54NruwNlPMH79Wsca9tJLDp7Zjg9cjvHLI/2F6CDcf6LaB2
	yJPDBNcMKdaaMkpUdDKHB+ZJKxeUhX4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ClW0ENRr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of agruenba@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787316873;
	b=uKM23VjFGtZoXb5s9G/hKm7q48TOWu26dr72ylpDVMUeroaGbiVxE3JPvZS63dX2M+tc8a
	RMOPTyUcSAkd7v1yePFFEGpu23bidZMHF6p5vc4Y5yN4C9HAv3KvS0H20GSfWcR2Ni+rNt
	Qa/jwIvWWrspVwbjFE5tLwiIYklSMes=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787316872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T3T0DA5j0vwcwUo9HIMuCVlwa1ONI5AchHTxjE6rvQY=;
	b=ClW0ENRr0SKnR1vPRfriR0uw0as8k/CXALmMG9BQsnaHQHARf7jF3kHlTCJB5rGM3UJ6uh
	hFzf6PxC2P6DzFr08BJBDFBdbL1+KPjR9E42e/fwaajyG7dXvc6Vm/RmZv/ONRKb4V2owl
	1iC/R3qK5sKQuNkIPVdFCgyCN7edqWs=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-hMNnVLdjPnansTuzZ7jd6A-1; Fri, 21 Aug 2026 08:54:31 -0400
X-MC-Unique: hMNnVLdjPnansTuzZ7jd6A-1
X-Mimecast-MFC-AGG-ID: hMNnVLdjPnansTuzZ7jd6A_1787316871
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66cc65a15dfso2118352d50.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787316871; x=1787921671;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T3T0DA5j0vwcwUo9HIMuCVlwa1ONI5AchHTxjE6rvQY=;
        b=sdq04lRyYK0oFc0aEAvYrPbZLrLmpLSW26K+0AsRaQ65IKXWGotR9GOiX+hg1/3lPt
         maFP7hKJ+Lx7qTFEHsKoAkzM+M6ocdfOxIUxtp0M1u5XBdCBkCEbbQ6jMGKG7sMo9U/D
         NoE/04ClbAQlFy13jU6P4IphVkfRgVY3jzyXGlKUgJKW8TbYBPdSzZTHLAvPvXcpXOvg
         fPB9w6Z9544niKTZ9TTGvtDX2H13ECvaywe1MzpJKHHEHdcoj0osZW13sa5KAg9YZRDk
         cFGKq3J8tIwObDZHBF3Zy+TLVPPUDBhoQyddNUBWfsfFfpAiNglYwtslcAcJDWED0IKQ
         tkyA==
X-Forwarded-Encrypted: i=1; AHgh+RqA7LcHkqtWb8Y6LobpxMOSwvneDGo4Pt4FpPvocpTXX0bzpFpKTVKaGCHxdL2Zn7SxxdKmFnFmlQ==@kvack.org
X-Gm-Message-State: AFuF++mx69321SNzLnaaD3ts/Z84KkANY94woM0Pa+qJ1rdc8d7I2BUm
	IVZXK99LgHxfHVCILz97Z6Uk8WCpvHs8KCjvMFmhvSM8TlvdtlVl2yvXXwr4ZzVe1TfvBwKmnY2
	HWgwjkeDYTefeyZehXWo1ikoeRRsaQ+RrMZdRLtWzCv07y+LMWydzlkZ5jLeiZRM/XqECupa83h
	5TrX1AE6zVrQEi6oiFR46R7edt2T4=
X-Gm-Gg: AR+sD12ljEgDQYKVbz+sSqpjPgWFgwFh/ygM+dNPVSCscupArd4XubJlvqn/DBNyMYG
	EFU+rsyfcSoKlU0x30GYOwQKouTp6MXQOcsg4l3Zb/o66wKcNWJgdV/kSNWKyejkQGEoEr8dNLW
	TwfrkrozC/uoChEP3Wchp6rn3iq3hXwHRbq7kXWdNdkNM6Rbf0sv/l2XPrH005Xcp+lfg8V7Jwv
	6vpUdS7+q5TCfcor0r2Z/a2hW1FhLXJz4f9Xp2y2V97
X-Received: by 2002:a53:ce8f:0:b0:66c:e3eb:9443 with SMTP id 956f58d0204a3-66ce4ac2100mr1991127d50.31.1787316870693;
        Fri, 21 Aug 2026 05:54:30 -0700 (PDT)
X-Received: by 2002:a53:ce8f:0:b0:66c:e3eb:9443 with SMTP id
 956f58d0204a3-66ce4ac2100mr1991100d50.31.1787316870126; Fri, 21 Aug 2026
 05:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <6a863306.ae6ddae5.3da009.0013.GAE@google.com> <tencent_D69518E8F6ED56CE0479766DD82CC56EF00A@qq.com>
In-Reply-To: <tencent_D69518E8F6ED56CE0479766DD82CC56EF00A@qq.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 21 Aug 2026 14:54:19 +0200
X-Gm-Features: AcwNN1WdIh2VqMnJFVL8XqYKLmq06uENKjCJ84-TLUojbAOKdvIO7i189zyeTag
Message-ID: <CAHc6FU4HnRSQmtLyTJsZ=qio7NEBFbkN=Y2GyG46=nn_TYi1pQ@mail.gmail.com>
Subject: Re: [PATCH] gfs2: valid the length of rgrp header
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+9d20c3ad7d29227de28d@syzkaller.appspotmail.com, swhiteho@redhat.com, 
	akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@kernel.org, gfs2@lists.linux.dev, gourry@gourry.net, 
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rcLKUZ5HExvjcQ1AyAyiqt2sp_2hOz5kTIOGeRrpDTg_1787316871
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 3cmbqrj45bebobxwafd1ao45g6r5g8oh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A15240007
X-HE-Tag: 1787316873-500995
X-HE-Meta: U2FsdGVkX1+wkojvFdpfautXsB8j3S2hY6fmMXeWHdR381vUl0fGx6H2btUGyIpuOfZiWlCd18fk8wo0D41EsiPcYkH4iI8puFxaRIpa9vKCHXxak4qHA9iO2mjLEYq81uOkmoBJwquGLLHQb0OEWYP64dKtt+6Dtn1F8BUthdKb59ZXJh9sM4bjsi7NDexg3XXo3ol2hwydcUbBKRpV3srjpfteKbJGxVf4Xi/gGqolaLASBh7hgaiwokEgJoRd7GXaJHRfkkxJeaC0HEfx+VeUotmBbd7Zi29o62C/I3BMAnB0K9c8psm+c5H4ROFklaA5vKnE/QpCr0fBKH+XQjjonVfNYpMX7nPaWs3rN0mOczIfUBAAw4E5KZRExQOttHpDV9w8mjRUjMh8X6sT+IaJn/QHh/a1+gE8hsco+jUwpQuLkYZIMY7B4FHvRS7OuhOM0HVtPdFqV5Rh1Ors5CFD2o8FKAPz2AI3aVYXwPZ/AKaclLHb9evbwUjdJa+gxxRY/g+nvUf2X9OtWsId/z7uUcpIP8mRJYlk8DdRozjd/SSGQVrbjjnDE7VWgLRIJ42x4oBPPiPSTgPy+GACCyrTAwz76d7J1Dc7qHdd8VpNB3rNjdjMDwehFZYBEAFXrk37y3IDuuWFKvHzWvItHv/MHn7zauXsdFRr56T2zyckooXsQWOawOGNNLhZNeG1ASRC1SqmuQv0AOSGm9zoxTee0+NUwLTMoqynnFKU6DHjg0tMANXdcFi4l50IYBQ5k/RzB0BmLQHdo4Js8reGNgn7+cgOpjmk+qJrRFKkmg04R9RTPtwUMqh4qg5txHPv7aKs+UQJ8WfYc61nqjQS/BmHKqr+MY848flAtSQVwEBMfGW2QLB/jBM6natWcmxJgnZHb1gwXZS7iNWauqk7l+zlOSPrqPZmqtqGuMshjsNfycPvChBwdccUKbforZffnbYfbn2yIMRLef78Tad
 ynhZFFAr
 5h4jZ0D1/9OzfYvZRZ8n1HxJesEkqMwl9/4vDngNzTY5FjArgL3R2z9NdvEs0N7PUn+jjkW6jdH+sQIaRSk/tbDNhcPN62G8iKuQs4XnRjrzFboo/G6NaEMSJfVPb6FxrxE0YGuByYKPwTTqwmLtiXwc3AN10Pny96sTfjJkLik26ANLYW7E1QBpdnx7ALEv0Hl31qMLOHUtkdxi6YMl+HTfyo7t6OCZfmQ1lcOjZ70M0OTIHAngsv3+UBuqJAgyPMaeQ7TYAo+F0lpqdRVbfWKZpilOUEdk2bBxmuGGPzyl+n+tFHBqLmAmETnoGl7M1yj549bSnTua9YvMujttbC+fUZeCv9IFyTdack2CdXcYxKcMjb3tNSxcBDoYz24Z5Wp5MTd8D2N4Ix/+HfIV/yAkYJ5VLFUFtFCaIeo2SJWXOEPZlv00905G1POBgXpTmOIA8VsM2Z1FnBis9B0g7ysL2YsqiOOG6EQKkt26F1hrkJmoOOPtzbdK/A1ZcAt5rWWpQ85WEJWYt9wyIZFJieNwNeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 6:37=E2=80=AFAM Edward Adam Davis <eadavis@qq.com> =
wrote:
> When mounting a deliberately corrupted filesystem image, an excessively
> large rgrp header length is used in a call to kzalloc_objs() within
> compute_bitstructs(), and the memory allocator cannot handle such a large
> allocation request. This triggers [1].
>
> Add a check for the rgrp header length to avoid [1].
>
> [1]
> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2427/0x2dc=
0 mm/page_alloc.c:5280, CPU#1: syz-executor256/5629
> Call Trace:
>  alloc_pages_mpol+0x1fb/0x540 mm/mempolicy.c:2490
>  ___kmalloc_large_node+0xe5/0x120 mm/slub.c:5274
>  __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5305
>  __do_kmalloc_node mm/slub.c:5322 [inline]
>  __kmalloc_noprof+0x5a1/0x820 mm/slub.c:5359
>  _kmalloc_noprof include/linux/slab.h:992 [inline]
>  _kzalloc_noprof include/linux/slab.h:1309 [inline]
>  compute_bitstructs fs/gfs2/rgrp.c:766 [inline]
>  read_rindex_entry+0x4a1/0x1250 fs/gfs2/rgrp.c:931
>  gfs2_ri_update+0x6f/0x3b0 fs/gfs2/rgrp.c:1001
>  gfs2_rindex_update+0x40b/0x480 fs/gfs2/rgrp.c:1051
>  init_inodes+0x1f78/0x2790 fs/gfs2/ops_fstype.c:872
>  gfs2_fill_super+0x1d3d/0x2cf0 fs/gfs2/ops_fstype.c:1250
>  get_tree_bdev_flags+0x38c/0x620 fs/super.c:1640
>  gfs2_get_tree+0x4e/0x280 fs/gfs2/ops_fstype.c:1332
>  vfs_get_tree+0x92/0x320 fs/super.c:1700
>  fc_mount fs/namespace.c:1198 [inline]
>
> Fixes: bb8d8a6f54c1 ("[GFS2] Fix sign problem in quota/statfs and cleanup=
 _host structures")
> Reported-by: syzbot+9d20c3ad7d29227de28d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D9d20c3ad7d29227de28d
> Tested-by: syzbot+9d20c3ad7d29227de28d@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/gfs2/rgrp.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
> index 5988a165a830..53d097ce668e 100644
> --- a/fs/gfs2/rgrp.c
> +++ b/fs/gfs2/rgrp.c
> @@ -899,6 +899,7 @@ static int read_rindex_entry(struct gfs2_inode *ip)
>         struct gfs2_rindex buf;
>         int error;
>         struct gfs2_rgrpd *rgd;
> +       size_t size;
>
>         if (pos >=3D i_size_read(&ip->i_inode))
>                 return 1;
> @@ -917,6 +918,13 @@ static int read_rindex_entry(struct gfs2_inode *ip)
>         rgd->rd_sbd =3D sdp;
>         rgd->rd_addr =3D be64_to_cpu(buf.ri_addr);
>         rgd->rd_length =3D be32_to_cpu(buf.ri_length);
> +
> +       size =3D rgd->rd_length * sizeof(struct gfs2_bitmap);
> +       if (get_order(size) > MAX_PAGE_ORDER) {
> +               error =3D -EINVAL;
> +               goto fail;
> +       }
> +
>         rgd->rd_data0 =3D be64_to_cpu(buf.ri_data0);
>         rgd->rd_data =3D be32_to_cpu(buf.ri_data);
>         rgd->rd_bitbytes =3D be32_to_cpu(buf.ri_bitbytes);
> --
> 2.43.0

Thanks. The patch I've pushed to 'for-later' for validating the
resource group geometry [*] should prevent this from happening in the
first place.

[*] https://lore.kernel.org/gfs2/20260821124944.1648686-1-agruenba@redhat.c=
om/

Andreas


