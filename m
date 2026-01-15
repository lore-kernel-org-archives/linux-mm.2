Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E7D7D29FFA
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 08:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EFED6B0088; Thu, 15 Jan 2026 03:05:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99DFA6B0089; Thu, 15 Jan 2026 03:05:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C0F6B008A; Thu, 15 Jan 2026 03:05:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78ABE6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:05:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EEE191B105
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:05:41 +0000 (UTC)
X-FDA: 84333464082.21.7DBE641
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 05BFF40013
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:05:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L6PiASeE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768464340; a=rsa-sha256;
	cv=none;
	b=YWrs5hQbHpS0E9B/NDO91+xLPBGQxW0pRQe834c5guOl68YRWY58HN2GwV26qQgEmQ9XGM
	/dnhhCy4tee5SipoIJ7JGv/pnUtvUvHgZbBkn4CQm1Ic/gT+ZhXG4SLvnd4wnRzxLYCiTf
	mWkUJm84f1AOTpU+XRV+DSY1HDS8s1Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L6PiASeE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768464340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eI5Aks8p/qGW9HFMkJeBYiCSRBBx6IXlghuKINHgvU8=;
	b=AIO4CD6ugsNsFwfXjuI0M69s9Y/pDJ3/XPEZa8FjDuyC4i3eweUu08RdjHuBWtfiiqJxwN
	w98KCZc0gdsc8jy+iIlMuAXA7XRBHCbuZxzAADus7oiZQwubTk6ovjek/aGkzoOz69MZiE
	MIQpk6Vmj9pU7otJY6yzixoXM9Mj78U=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34c84dc332cso287391a91.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768464339; x=1769069139; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eI5Aks8p/qGW9HFMkJeBYiCSRBBx6IXlghuKINHgvU8=;
        b=L6PiASeEHGiJ0n+nwzdu5K+Io/aqq/wF/xjutLr2XACO2tR6p/XGK1Gi2qISwxyNrv
         fazHNGhWsqnJeo0tlirXQJgk+CPmhL6YRYJYZvuCQxWuXD+jKdcmaNiwyfV0cNYjC7LN
         Ph6WbpkRigy+2Lf3V4F2n7t13Nz1RN8YeCCxjGu2K+/WD2QKZAgpg3Mgybsg6tONRsUc
         1dclp953vgCBEPa5Wo8mVImF54BEVqSVygCb607l65efroWGU7dtp1pgH6V3cgMFI++b
         9cF75OEDnJGKDa3K/J5Dg1vDMJcU/w16Qz6YdW948xt3Ln16VMgCLUnNMGCSqQ6urT9s
         QXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768464339; x=1769069139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eI5Aks8p/qGW9HFMkJeBYiCSRBBx6IXlghuKINHgvU8=;
        b=cx7mgFbWTjGuAz/SUvFyYudiiEAX59osEr4X6iZh6rhZG4WjuM8tlVN8qp5rkyVbJw
         dzfTl+/qWT1tmh8fKxOE2FUVWLJxX8De+IZ0EXrYdGI3retKEF5Q9UyelLwmiCyq9Aos
         dKFs76ePPzjfhxVfidROPiipGBluZC6THGakSwfpek0wPsnfM/U0CH/50lg9aB9DEZoT
         xLG3XwIKuEdnzTwOvxvUdD2XmUhcKqa3Jgtxrl6DJq9JOJoSgAnEoQX+qtDlIoMjq6mE
         C4UhuxAY7Fr5DcNSDuzc/HgIjyPzOc/oQAyw9W2uJrEyMexh5BiXasAWW3dRsInXQqvR
         tPyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLrosY+iyg54WBGmP2tuNKMjXAvBO1z9FmfjMohd2CuYgXlI0WiwDW28TK6AdLV1g7ygZM1SM7Eg==@kvack.org
X-Gm-Message-State: AOJu0YwnAxjs++PT5184hFcDElM45z16EWOD4kZyjHcApFUc9sGFSDrX
	aQ3pTAi2hH2833uWkoTnIjrNgaq6mlB+hIjCXQ3UhncJRxHRMGOCaa+9UUs4SHXrfv244DICq3N
	iYHCcKKIe65C+5mF9gW7WKrToOkz6PHA=
X-Gm-Gg: AY/fxX6dv/3Ox2yRx84iyNGqfym8w6KcTLOExirC5/LlS5CXvtT/ArwSfkSJiyN9Ca+
	3VZ7JU0I3ddzZjH3UJNZ7kMYlegQ0jn/w5XXqndjNpl4TB5uqsO89eKV0JsL+KsI6iioAKswgmx
	gFfn2pFgjWp8hGHFQiHssghm9hlhOOFPG8EpVcP0IS9rqItT71ZSyxbt95vqJdGtXH1pTFsWVnQ
	LMdepL7wYe4qJeYyZBN8fdx0VqPGY8+vRBQkNakPa5q+ZF7M+oevX7zOhIzqUEYHLsjZgQwvD6M
	Bznjtez2h4WmDygmzFWogb4/GFiH
X-Received: by 2002:a17:90b:1d4e:b0:34f:6312:f22c with SMTP id
 98e67ed59e1d1-3510afcbd46mr4909265a91.0.1768464338603; Thu, 15 Jan 2026
 00:05:38 -0800 (PST)
MIME-Version: 1.0
References: <20260115001405.3513440-1-robin.kuo@mediatek.com>
In-Reply-To: <20260115001405.3513440-1-robin.kuo@mediatek.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 15 Jan 2026 16:04:58 +0800
X-Gm-Features: AZwV_QgPLO0RVfJdVJxqFZ4Y4W_kG-gmBtwevH7JFUpri4EIC-T2EJV0cJ8my68
Message-ID: <CAMgjq7CrKv7QJNFO_vg1_nXA+RSW83mu8X4cMSVd2tfMA==Wew@mail.gmail.com>
Subject: Re: [PATCH 1/1] Restore swap_space attr aviod krn panic
To: robin.kuo@mediatek.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, wsd_upstream@mediatek.com, 
	casper.li@mediatek.com, chinwen.chang@mediatek.com, Andrew.Yang@mediatek.com, 
	Qun-wei.Lin@mediatek.com, oliver.sang@intel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 05BFF40013
X-Rspamd-Server: rspam06
X-Stat-Signature: 4x3ba5rbk56rhb67ekhfukzg3pwhebw3
X-Rspam-User: 
X-HE-Tag: 1768464339-630380
X-HE-Meta: U2FsdGVkX1+f40AeRTT4hcgrvhIP7vBUnd8kN4a/sgb4V5mk6DmzEuwSf3uCmHSM9Iy5YtdIgHOg7gbSfcvPn5M3E4A7TIiN6q6uDpzHfinaNSS/1nWIhjW9fIRVRq69lX7vKtQRXug08q13gM2kUM5ytTKlsowRYtL1EKoU+O5qjgtZhf0SxVh/snXk/4KUBBznz+/czCfwPGW6M3nXtXvP8Z1BECNadBgAWXKwKK4P+e+ZFpSG+4i5JmAaxLBTYZQ2Vc1FUnMJDbGm02dPTNG9d4dmr4qa9siebe0Jrkae1N+jKpTgwhk9rJc7OHh4m+il7EgRehuJ30oJW9TPQrKePes5qvGsMDRHiUdebz7MTDCmBZ1AG6OWgGxzqe/cryZsPliUBhhRsZh5o1umg8FcEd9wc9czEBKxsmwpV4C77kTXBiwzt8lQOk6XcvekljkgOMsLa7LPxuqket6yHZciXumuhKQaN9nidDhnpol6O215DaVL0XHXlQUF25XeGqSNy7tlIvvHOEAah3eGySw7kf4VeaQ8+uWmQM8NlAIT6KymSG4r73YbbEn4dZ0HRb1aF7UV5N51I1jqKfL9V4CmiIekpC8+pojYyS7dL3UcDD9hC5rYtpl8aoFdtgsLSNCa8ols8UmJBr6Vpk9N17Y2WrETbso+w/16GMgrdxEqNwPclfyltaWFThPKpeCj2VtGBTJpojDVFe/hGUZhzublR4hKHdswPaHeITBZFs+AHKkLMK4IN7jfXmc19IrIioIjnf74AvUutLOM8diAinXhdUCjARXFobfyuGCEvJdsUowfxwcjTaYs3TMtxhNyDjUgND9VWjcBM5P8Hel4VFS94C5E7zPV6ll/1QECV4vawlpx/kPGu+mARF9QpZ5qYjeR/EhPWMic4VhabbFyvFXxcZhPisA66eZdwtpX/mpk4UzS+ZVwk0Lef3YoXQMF8xulziCpqAyb9HZ2a7U
 M+vx21ai
 J4ECDzV+oCgKCTmhpA9fuzQAkvewQq9OkRuj6/ah3Jyq9spGsGXfFUbu9JofweUAT338xuTdD/mckOuCJhGAy24EQi7L3vHAgwZ7Ho+94elx+M5Rpb57ADs+bsGXb29WU5JTxv5IeFP5I9WbTNB6htofdYkZL8/digavYBuvwJKdffEnoGYObLMuhodGbzwBWio9igMc6rWCPR90Oqhpw1DVdy+VDFGsVt5YwiTl1YniJuNTkvqyFOrjpdRMC8f8rfuhd5K2/d1TIywRCLDm3rS00E0xyigx2llZtHBJ423COXoexzLJiEmVl2Xoejfg7BEkmn92J0eWxKwQ40iGEhZS1xQdQxvBoBaOeW7lc+qjaKKfINBkdwDDVZbPSs3YZG71ULi1//rVKl1yuWyRABAVlXIGWNBTGj6PCoe+KZ0jSP+wAf76mceDAFya9PY+PW+a9Xdkjiz8lfAZMkvjT2aqPm03OV+wAiXhJa+3ZLgwrSxc8wujmZLXvhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 8:14=E2=80=AFAM <robin.kuo@mediatek.com> wrote:
>
> From: "robin.kuo" <robin.kuo@mediatek.com>
>
> Restore swap_space attr avoid krn panic
>
> Commit 8b47299a411a ('mm, swap: mark swap address space ro and add
> context debug check') made the swap address space read-only.
> It may lead to kernel panic if arch_prepare_to_swap returns a failure
> under heavy memory pressure as follows,
>
> el1_abort+0x40/0x64
> el1h_64_sync_handler+0x48/0xcc
> el1h_64_sync+0x84/0x88
> errseq_set+0x4c/0xb8 (P)
> __filemap_set_wb_err+0x20/0xd0
> shrink_folio_list+0xc20/0x11cc
> evict_folios+0x1520/0x1be4
> try_to_shrink_lruvec+0x27c/0x3dc
> shrink_one+0x9c/0x228
> shrink_node+0xb3c/0xeac
> do_try_to_free_pages+0x170/0x4f0
> try_to_free_pages+0x334/0x534
> __alloc_pages_direct_reclaim+0x90/0x158
> __alloc_pages_slowpath+0x334/0x588
> __alloc_frozen_pages_noprof+0x224/0x2fc
> __folio_alloc_noprof+0x14/0x64
> vma_alloc_zeroed_movable_folio+0x34/0x44
> do_pte_missing+0xad4/0x1040
> handle_mm_fault+0x4a4/0x790
> do_page_fault+0x288/0x5f8
> do_translation_fault+0x38/0x54
> do_mem_abort+0x54/0xa8
>
> Restore swap address space as not ro to avoid the panic.

Hi Robin

Thanks very much for the patch! I'm fine with it with some suggestions:

Marking it as RO was intentional to avoid silent unexpected usages of
the swap space, the swap space is hollow now, as all content is now in
the swap table.

For example the one you posted, calling filemap_set_wb_err for the
swap space is meaningless, the error info will be ignored without any
notice.
In the comment for mapping_set_error (wrapper for filemap_set_wb_err):
 * When a writeback error occurs, most filesystems will want to call
 * mapping_set_error to record the error in the mapping so that it can be
 * reported when the application calls fsync(2).

So far there is no fsync for swap or other ways to report mapping
errors to userspace. For example, __end_swap_bio_write will just print
an error log if writetback failed. I went through the code, currently
only arch_prepare_to_swap will cause a call to filemap_set_wb_err.
Swap is not a persistent storage like normal FS, so simply bouncing
the writeback folio back as active is good enough for almost all
cases, like the one in end_swap_bio_write.

Catching potential issues with RO/panic is overkill indeed. So I'm
fine with dropping the RO by default. But perhaps we can keep the RO
attribute at least for VM_DEBUG build? Like this:

diff --git a/mm/swap.h b/mm/swap.h
index eba4c04ad039..307cc71d3635 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -220,7 +220,12 @@ int swap_writeout(struct folio *folio, struct
swap_iocb **swap_plug);
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);

 /* linux/mm/swap_state.c */
-extern struct address_space swap_space __ro_after_init;
+#ifdef CONFIG_DEBUG_VM
+#define __swap_space_attr __ro_after_init
+#else
+#define __swap_space_attr __read_mostly
+#endif
+extern struct address_space swap_space __swap_space_attr;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
        return &swap_space;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 3916d144eddc..11273e0ec811 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -38,7 +38,7 @@ static const struct address_space_operations swap_aops =
=3D {
 };

 /* Set swap_space as read only as swap cache is handled by swap table */
-struct address_space swap_space __ro_after_init =3D {
+struct address_space swap_space __swap_space_attr =3D {
        .a_ops =3D &swap_aops,
 };

---

And as for this particular error marking issue you posted, maybe we
should just drop the handle_write_error I think. That helper was
useful when the filesystems are still using the .writepage interface,
but now all filesystem have switched to .writepages and only swap may
call that helper, which is no longer helpful, as the error info is
completely ignored with no report back to userspace. Maybe we need
something like this:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 39f0336d9c29..62fe433aac0b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -477,27 +477,6 @@ static int reclaimer_offset(struct scan_control *sc)
        return PGSTEAL_DIRECT - PGSTEAL_KSWAPD;
 }

-/*
- * We detected a synchronous write error writing a folio out.  Probably
- * -ENOSPC.  We need to propagate that into the address_space for a subseq=
uent
- * fsync(), msync() or close().
- *
- * The tricky part is that after writepage we cannot touch the mapping: no=
thing
- * prevents it from being freed up.  But we have a ref on the folio and on=
ce
- * that folio is locked, the mapping is pinned.
- *
- * We're allowed to run sleeping folio_lock() here because we know
the caller has
- * __GFP_FS.
- */
-static void handle_write_error(struct address_space *mapping,
-                               struct folio *folio, int error)
-{
-       folio_lock(folio);
-       if (folio_mapping(folio) =3D=3D mapping)
-               mapping_set_error(mapping, error);
-       folio_unlock(folio);
-}
-
 static bool skip_throttle_noprogress(pg_data_t *pgdat)
 {
        int reclaimable =3D 0, write_pending =3D 0;
@@ -650,9 +629,10 @@ static pageout_t writeout(struct folio *folio,
struct address_space *mapping,
        else
                res =3D swap_writeout(folio, plug);

-       if (res < 0)
-               handle_write_error(mapping, folio, res);
-       if (res =3D=3D AOP_WRITEPAGE_ACTIVATE) {
+       if (res < 0) {
+               pr_alert_ratelimited("Swap failure of folio (order:
%d, error: %d)\n",
+                                    folio_order(folio), res);
+       } else if (res =3D=3D AOP_WRITEPAGE_ACTIVATE) {
                folio_clear_reclaim(folio);
                return PAGE_ACTIVATE;
        }

