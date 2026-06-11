Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60C40CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 02:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FD596B008C; Wed, 10 Jun 2026 22:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE256B0092; Wed, 10 Jun 2026 22:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D796B0093; Wed, 10 Jun 2026 22:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 786E16B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:39:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FE66120399
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:39:54 +0000 (UTC)
X-FDA: 84866076708.01.9A86C0A
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id DC4301C0003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:39:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ylur9LOb;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781145592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmCQQQhz3RRkcOuWvQuvWEV1Q/sDcBAnzpjLxmkrBH8=;
	b=CCF0woaHMTaltkMlghOR1zB6acYvJaJ5nF3FwSXso73dVLuDa+exAiea8K2FGO+jr9KMWA
	8ve7jgq+pUKHAlDtTQ60HOvsimmClstQGYoUkfVBkUVyW2CVfLKQU+ZXqbOLUxOSmmVYCZ
	PvxB82l9UNLEls6ttMhSRWkg72XvMeM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ylur9LOb;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781145592;
	b=5f0IXPAuwDSXjjY+Ra/MfLiwXeNHE/Uw5UdAWw6azbTp3f+9hND2puwWyC2Z6iYjMPE9gI
	jo4PIbpxZazWHju9zIO8hDqxnc/MrN7dTDRS3Pk7GFbdZnu/nD/qp/fMj5FFjFk3fIKiBm
	2+jhGS88T4sU2kVHnuxLLNExldyFu8s=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aa679cc2c9so1008195e87.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781145590; cv=none;
        d=google.com; s=arc-20240605;
        b=FG8AB7lXHNwgC0fQAjSkpwtljGcEO5hdGco8pblnBPq0m5Jxn3tbZxwOotKGEYnm13
         ezA7+M7Z2C+bBw283qHoyrzCu9Yr5244VJfqx9X60pgj96zcPQxZ+sPl3fnWarLjYm2c
         8fLQ9Yvsb784duI0pkAewOBzF8N66wwt63SxASyIZKgxPNRUfx8MC7AXYpdEEPVnm0PK
         JslASpRFTSC5ql/GDFKRGGyUcrqPO0Hubst+ZdFUUQNncuAus2GaqGP4PIFuEfc10ql4
         0xEaGSQTwAeJcebKcbuY4KggWzhWlZTZ6tTHDxYE4H/ycsXYjBb8nkHR8LfUE4S+AEc9
         jlkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rmCQQQhz3RRkcOuWvQuvWEV1Q/sDcBAnzpjLxmkrBH8=;
        fh=vHy7C2nqk5+yfK1LgYOAWlPIGEjAoxYEhwQpUASkjuU=;
        b=AL+PfbP8+ytRQTcNjX1D35w3KDHY1bKJ+J1x6EXeWfmxYfGW7suw0bTOqVO70Gln6T
         3pofrn/Wh9wKgV02S8c0jUT3I/tpX4g5fO6imbolWvENjse3VbVOpfbnKmbaZgilZYSi
         /AcCg0xQzLL27rnFrjZMztsMaJOT0+JPZYM+dsbiw+FkWOnLTsIHey0fwmY2PIrv8hTQ
         Z1EQqM0ihrvN5gQJ9Hla9HQDYTs2NvI6YsftD7HkZwPjcgVSJfBOEI/V6YZolRhN5FUl
         BLBg/MCVUltM0sa548jYd+nJNr3s/Y5Twflh8hxKvfpjgTIuOZW7bUP+Nq1xWq+/cG95
         Lkew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781145590; x=1781750390; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rmCQQQhz3RRkcOuWvQuvWEV1Q/sDcBAnzpjLxmkrBH8=;
        b=Ylur9LObBT3dBfVbN1J4t4f5UI1TMSu4I08ifQW8zW1Do+bMEXcp0nlvgnqn9a+gOY
         z13g0QaWESIvYoslC2NsfytMGNyY3Crr6jcEOzs6EwKjUGFSkj5BJA7+rgpUc56uTDYr
         C8zMvsI5oe69oK7t2t95NoXetsq07ZdS41pfuDes27CT2ARl/Koge9IE/HbhQsKbauaW
         ABypkjkkZYryNZNJdqR0Dq66gSUj21kLgPyfslsfcc0IXwqTccMb1mbPmFewyqvCv4qF
         AnC+byIaAkqnKLfqXStu6amYv4ixL8F/yWucU5lSKo3ZU7RL64w7TmXDSJhmqT3PnVFd
         2KOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781145590; x=1781750390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rmCQQQhz3RRkcOuWvQuvWEV1Q/sDcBAnzpjLxmkrBH8=;
        b=ZbPCV1AozitBrWZWpPDTizivropqmVvdqDGtSVaMu84mOW+ypQcYUvHJrJ9plCg7fI
         5SYE1Mn/wPId92j0Rw9MTXv1A/Z3DQmmALXHiCNbZKLDlu/YX9O5a6BDKBd0BSJZCfxk
         DABj+7khjodmfAwgP6+6BrQ6jxfGr23aLS7btSdRAQeMdDriifOOGWewcG/UGsb9n4gv
         sqj9MDVdXscWIFRzbBc1vJQP8WXNPxgbm74AtEVYdQD8l9jorEG2AW1RqFTTreoG8iwE
         eKG6KvVsK2DfmaRG32neTJmXWjdY2qKz1+9FohQbBvc5Y2OU6icPJL6X93Inb082dPa4
         GtJA==
X-Forwarded-Encrypted: i=1; AFNElJ9VgT83tD0t+PCLVBaEdsjpAeXVx6ENDa+pdGf7KLWtbbyVHtCycovFKMRCMkYeAjllUoRIQ6oroA==@kvack.org
X-Gm-Message-State: AOJu0Yz5SSAhM/UCFRwkvY3cnBSyxKUDhylqotFY1Yna3y0I+WDXEcf8
	WqC9W9P9QMBzNVJcGzHaeGiS6x/vcRK/8YrzgBPItZ8O1NNkPhBnlOxSbHmMZJR7Wp4CKWolB3e
	NwxJZ1mr7YTsu+osIu0NW7yEc+RBZloo=
X-Gm-Gg: Acq92OFOUdrzqo5DjNPJyknrgQwBvgbpL41UhDIH+cQT8MeQYcv4q5Ya4J+Q/EAPgIV
	1qW3Q957m4gZcgKmn1rLddgFtsXIWpIyq/1R3X6A6ONCJmRmxzMclPB5u9SjDBN+jFyfzlgCs3Z
	B186srWkoNKIXKyqYnmHqZDcxL5w4l+yGVp3UOM9OzPGrxBC1OwstiL0Ml/Hkb8WeMyaPMaiEPk
	olNAJOLkpHcJFLQSi+X8FHhIcQkysRqcgG1zW2mANUfFnjY3cy4TDRVDx1bt2szq1Y2RX2MVyrZ
	coeruf8cMkjoDLcbGaE=
X-Received: by 2002:a05:651c:150c:b0:396:7fd1:f574 with SMTP id
 38308e7fff4ca-3991a20d04dmr614231fa.3.1781145589532; Wed, 10 Jun 2026
 19:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org> <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
 <CAGWkznFQH65gJO=xvxZLoDGWLu7YTCnSyfoy7JdLKV5eY8qLzg@mail.gmail.com> <2F9A72CC-772C-4691-9F18-77306EADC6CB@nvidia.com>
In-Reply-To: <2F9A72CC-772C-4691-9F18-77306EADC6CB@nvidia.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 11 Jun 2026 10:39:37 +0800
X-Gm-Features: AVVi8Cdt57Z3_CMcE0UrAhcMf-tckBWMbgMRgqOppIdKJJey9vxj7gAf4flNh84
Message-ID: <CAGWkznEGt1eRmiTLsU6DAJBmmbUG4ZY4HE5Cx=Oy0yznqGb0UA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com, 
	xiuhong.wang@unisoc.com, hao_hao.wang@unisoc.com, 
	"jyescas@google.com" <jyescas@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DC4301C0003
X-Stat-Signature: 8o8siynhnqfdaes7sxppkybxynt3b3qf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781145591-852238
X-HE-Meta: U2FsdGVkX19ltm9uPkdNfITXaYXpAxUQDpk/FiQxuH4MtlGcV9aEHmWYJyfN9po958anOP+4CrZPSRI8WMDfpzqTSHBmMfvSsQVWiEfKSXP8JWUe8zLQdRbS+kD/hZdH7EeTbMZ8aXikeB8KhL1fYno6YsjnVmh51hNP14CLfAdaAfJb99D2V93hULk+yWKFhQLFNCfUfiQuZQYlECkWpYF+hx0VkRNP788d5tdYdvTh2mprwnAkyv3DGjmhvuM2E6jIl7byglVPOfZjSYeI/NNLH73smfsgc8sQfGZ7iTmT8OvruPmd1P4qW/2sh7/0ifWTLEp9NpnRd9/72ahILgJobT90vX0x/4tP8oEd19T+dRSxiHzIkRlKzNCmVupZhBVznxK2SSbJWWihKVpsm7w/KOHgi0SK5SfydEMQEW2R5G0ck0MGCCTVsJyJB9gjbUzlKBwbUnBvh+BMcPRQPEp8LecdP5fl8tYV3rBamfDglpFkyqVcpVhVSXkUFV5pe6J3vAu72sw+pSsDWivESBesqh3PPW/kTUbrrLjA4smsPO6sy2oi39+tyOifKNbiJ26Kj27yDO2meC6VxaabW6/+aevc6a8zsW02kTRFvQUjHdY7u+cLB/MlHsj7RItBZRKdXTyPoLVj6hYVsbBeMmPpiBR2lVfQCniBoY7oc/JfFIMUMSdlKA60eSseX926tMBxzQ774gInpqPWxU8TwWT+AV0E5kt/tRJx78AjA49jJLlGExkRWbZo2LhFnsLWeKn/djMgKY0ZTvpqjb+gJ67RlXj4BE3V4A3xuFpnJYBgOMQxK4kA/16H5+9+2MsyxXr8V/9aViHeLqW9Lk/CkZL2Oz07xfyKMmNPkBMZ4anNO9NNpYV9Yw4MiJNZYUDvdgjRiYKpuS6CKf9M1+gJvTiYcaJGGWzqfU4VqN0iTTztUJqz2iClz9h7hu7Yz7m8dPFuiqW6v1feCcvgkeX
 86kk0FBm
 nSdysfYoQ9Mb0yBKszxTZQXRk05JpC6Ud0FyDg/HhqvTSCCtUVn5arWAWT1y1bnDQdJ2zCnyspR4Aq9VlX1+uRYHQYHYnmrAQsgq1HpgvYCdSJQ3L1hwbvlzJUFtC0FWcd7OmspepLGVDe2SCXcl6nMtpNRWXqr+ygAheYTkV0X5o/sfH0zQks8rkujhNIcarXse9dQC1Hc/eDXsRHF4erAoPLeQCBCytUph7pSs9P8HC4OZosKjQiPXMM9EThZFoL+V1lccAQ1fTKMdngBs1A5WWRFVYp8HTks0AbRFwaw1p+XNoSmLsGSq3JvQ4JW/uuLRX5C3NwdCh1LZG6VQW4aczCpdjyXMnocORxTMU/Rr7uIey5lRrevuIFm++dBb6KDgYfNeNv1INGtgiGklwZoedzn4X1tWTheGgdKxwUPTUWA1HL59VYjhnnGu8Gutp7U0Hzepx5BC7ijY30osWCAMUUvbgGhVIsK4RtYv5PUM7cXzs8HEC6mBx69bt07Ww5yKvci3YP/sZQ/aGTlSwpICccphwjfN7YX9mzBISeGKMmvoAtFGeX8QEtoAc41BjQL41
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 9:56=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 10 Jun 2026, at 21:39, Zhaoyang Huang wrote:
>
> > On Wed, Jun 10, 2026 at 10:38=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On 10 Jun 2026, at 8:50, David Hildenbrand (Arm) wrote:
> >>
> >>> On 6/10/26 14:05, zhaoyang.huang wrote:
> >>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>>>
> >>>> The kernel panics are keeping to be reported especially when the f2f=
s
> >>>> partition get almost full. By investigation, we find that the reason=
 is
> >>>> one f2fs page got freed to buddy without being deleted from LRU and =
the
> >>>> root cause is the race happened in [2] which is enrolled by this com=
mit.
> >>>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: =
remove
> >>>> non-uptodate folio from the page cache in move_data_block").
> >>>
> >>> But I assume, that other FSes can trigger this as well? Any insights?
> >
> > Yes, I think all FSes support big folio could suffer from this defect.
> >
> >>>
> >>>>
> >>>> There are 3 race processes in this scenario, please find below for t=
heir
> >>>> main activities. However, by further investigation over the code, I
> >>>> think there is a common race window for the truncated folios between
> >>>> split_folio_to_order and folio_isolate_lru, where the folios lost th=
e
> >>>> refcount on page cache and remains the transient one of the split
> >>>> caller, under which the folio could enter free path and compete with=
 the
> >>>> isolation process. This commit would like to suggest to have the fol=
ios
> >>>> beyond EOF stay out of LRU.
> >>>>
> >>>> Truncate:
> >>>> The changed code in move_data_block() lets the GC path evict the tai=
l-end
> >>>> folio from the page cache through folio_end_dropbehind().  Once
> >>>> folio_unmap_invalidate() removes the folio from mapping->i_pages, th=
e
> >>>> page-cache references for all pages in the folio are dropped.  The f=
olio
> >>>> is then kept alive only by temporary external references, which allo=
ws a
> >>>> later split to operate on a folio whose subpages are no longer prote=
cted
> >>>> by page-cache references.
> >>>>
> >>>> Split:
> >>>> After the page-cache references are gone, split_folio_to_order() can
> >>>> split the big folio into individual pages and put the resulting subp=
ages
> >>>> back on the LRU.  For tail pages beyond EOF, split removes them from=
 the
> >>>> page cache and drops their page-cache references.  A tail page can t=
hen
> >>>> remain on the LRU with PG_lru set while holding only the split calle=
r's
> >>>> temporary reference.  When free_folio_and_swap_cache() drops that fi=
nal
> >>>> reference, the page enters the final folio_put() release path.
> >>>>
> >>>> Isolate:
> >>>> In parallel, folio_isolate_lru() can observe the same tail page with=
 a
> >>>> non-zero refcount and PG_lru set.  It clears PG_lru before taking it=
s own
> >>>> reference.  If this races with the final folio_put() from the split =
path,
> >>>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio=
().
> >>>> The page is then freed back to the allocator while its lru links are
> >>>> still present in the LRU list.  A later LRU operation on a neighbori=
ng
> >>>> page detects the stale link and reports list corruption.
> >>>
> >>> Complicated mess :(
> >>>
> >>> So, folio_isolate_lru() really only requires the caller to hold a fol=
io
> >>> reference, which can happen given that we did the folio_ref_unfreeze(=
). It can,
> >>> for example, be triggered by memory offlining or page migration.
> >>>
> >>> So we really want to not allow folio_isolate_lru() while we are still=
 processing
> >>> the folio.
> >>
> >> Or we should defer adding split folios to LRU after unfreeze.
> >>
> >>>
> >>> What your patch does is, simply not add folios that we will drop from=
 the page
> >>> cache to the LRU?
> >>>
> >>>
> >>> You should describe here how you are fixing it: "Let's fix it by..."
> > Yes. This commit would like to suggest to fix it by having the folio
> > skip the lru_add_split_folio
>
> Skipping it causes more issues like LRU counter mismatch, firing up bad_p=
age()
> since PG_active, PG_unevictable, or MGLRU fields in ->flags.f could stay
> uncleared at page free time.

OK, we should solve this issue.
>
> >>>
> >>>>
> >>>> [1]
> >>>> [   22.486082] list_del corruption. next->prev should be fffffffec10=
e0ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
> >>>> [   22.486130] ------------[ cut here ]------------
> >>>> [   22.486134] kernel BUG at lib/list_debug.c:67!
> >>>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SM=
P
> >>>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
> >>>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> >>>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS=
 BTYPE=3D--)
> >>>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> >>>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> >>>> [   22.488539] sp : ffffffc08006b830
> >>>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000=
000000000000
> >>>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: ffff=
fffec10e0ac0
> >>>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead=
000000000122
> >>>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffff=
ffc080061060
> >>>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000=
000000000058
> >>>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000=
000000000003
> >>>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe8=
5721f0e25f00
> >>>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65=
645f7473696c
> >>>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000=
000000000010
> >>>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000=
00000000006d
> >>>> [   22.488647] Call trace:
> >>>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> >>>> [   22.488661]  __folio_put+0x2bc/0x434
> >>>> [   22.488670]  folio_put+0x28/0x58
> >>>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
> >>>> [   22.488689]  f2fs_gc+0x230/0x9b4
> >>>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> >>>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> >>>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> >>>> [   22.488725]  invoke_syscall+0x58/0xe4
> >>>> [   22.488732]  do_el0_svc+0x48/0xdc
> >>>> [   22.488739]  el0_svc+0x3c/0x98
> >>>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
> >>>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
> >>>>
> >>>> [2]
> >>>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU=
2 (folio_isolate_lru)
> >>>>
> >>>> F: pagecache refs =3D n
> >>>> F: extra refs =3D GC + split
> >>>> F: PG_lru set
> >>>> move_data_block()
> >>>> folio =3D f2fs_grab_cache_folio(F)
> >>>> ...
> >>>> __folio_set_dropbehind(F)
> >>>> folio_unlock(F)
> >>>> folio_end_dropbehind(F)
> >>>>   folio_unmap_invalidate(F)
> >>>>     __filemap_remove_folio(F)
> >>>>     folio_put_refs(F, n)
> >>>> folio_put(F)
> >>>>                             split_folio_to_order(F)
> >>>>                               folio_ref_freeze(F, 1)
> >>>>                               ...
> >>>>                               lru_add_split_folio(T)
> >>>>                                 list_add_tail(&T->lru, &F->lru)
> >>>>                                 folio_set_lru(T)
> >>>>                               __filemap_remove_folio(T)
> >>>>                               folio_put_refs(T, 1)
> >>>>                               /* T refcount =3D=3D 1, PageLRU set */
> >>>>                             free_folio_and_swap_cache(T)
> >>>>                               folio_put(T)
> >>>>                                 /* refcount: 1 -> 0 */
> >>>>                                                                   fo=
lio_isolate_lru(T)
> >>
> >> If refcount is 0 at this point, VM_BUG_ON_FOLIO(!folio_ref_count(folio=
), folio) in
> >> folio_isolate_lru() would be triggered. Maybe we could just return fal=
se in that case.
> > No, isolate caller will grab one refcount.
>
> As I said in another email, isolate caller cannot grab a refcount when fo=
lio refcount
> is 0.

pin_user_pages*(..., FOLL_LONGTERM)
=E2=94=94=E2=94=80 __gup_longterm_locked() [gup.c:2465]
=E2=94=82 =E2=94=9C=E2=94=80 follow_page_pte() [gup.c:802]
=E2=94=82 =E2=94=82 =E2=94=94=E2=94=80 try_grab_folio() [gup.c:858]
             if (WARN_ON_ONCE(folio_ref_count(folio) <=3D 0))
                 return -ENOMEM;

                               // Could __folio_split->folio_put could
race here ?
             if (flags & FOLL_GET)
                 folio_ref_add(folio, refs);
=E2=94=94=E2=94=80 check_and_migrate_movable_pages() [gup.c:2490]
=E2=94=94=E2=94=80 collect_longterm_unpinnable_folios() [gup.c:2391]
=E2=94=94=E2=94=80 =E2=94=94=E2=94=80if (!folio_isolate_lru(folio))

Could the __folio_split race in the above scenario? It looks like
try_grab_folio set the refcount without using atomic operation.

>(from previous mail)
> Wait, if folio->mapping is NULL and folio is not anonymous,
> folio_check_splittable() returns false at the beginning of
> __folio_split(). So the split cannot happen.

According to my understanding, the folio checked here is still big
folio which is locked and with folio->mapping set, right?
>
> >>
> >>>>                                                                     =
folio_test_clear_lru(T)
> >>>>                                 __folio_put(T)
> >>>>                                   __page_cache_release(T)
> >>>>                                     folio_test_lru(T) =3D=3D false
> >>>>                                     /* skip lruvec_del_folio(T) */
> >>>>                                   free_frozen_pages(T)
> >>>>                                                                   fo=
lio_get(T)
> >>>>                                                                   lr=
uvec_del_folio(T)
> >>
> >> But in CPU2 (folio_isolate_lru), lruvec_del_folio(T) should remove T f=
rom LRU list.
> >>
> >>>> later:
> >>>>   list_del(adjacent->lru)
> >>>>     next =3D=3D &T->lru
> >>>>     next->prev =3D=3D LIST_POISON / PCP freelist
> >>>>     BUG
> >>>>
> >>
> >> Why does CPU0 still see the stale link from adjacent?
> > The staled link should be from LRU since the folio never be deleted fro=
m lru.
> >>
> >>>> Assisted-by: Cursor:claude-opus-4-8
> >>>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >>>
> >>> I'm wondering if this has been broken the whole time, or if some rewo=
rk allowed
> >>> this to trigger.
> > This issue is from AOSP with v6.18 which just supports big folio in
> > f2fs. Besides, it is triggered by the timing of f2fs's partition get
> > almost full during the test case of filling f2fs's partition(should be
> > the trigger factor of f2fs's gc which enroll truncate thing)
>
> Are you able to reproduce it with other FSes supporting large folio?

Sorry, I can't so far since only f2fs has gc in the Android system.
>
> >>>
> >>> I assume the issue can be triggered for other FSes, and we want Fixes=
: + CC: stable?
> >>>
> >>> Looking into the history, I think we always unconditionally did the
> >>> lru_add_split_folio()/lru_add_page_tail().
> >>>
> >>>> ---
> >>>>  mm/huge_memory.c | 2 +-
> >>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>>> index 970e077019b7..7465525a94a8 100644
> >>>> --- a/mm/huge_memory.c
> >>>> +++ b/mm/huge_memory.c
> >>>> @@ -3966,7 +3966,7 @@ static int __folio_freeze_and_split_unmapped(s=
truct folio *folio, unsigned int n
> >>>>                      folio_ref_unfreeze(new_folio,
> >>>>                                         folio_cache_ref_count(new_fo=
lio) + 1);
> >>>>
> >>>> -                    if (do_lru)
> >>>> +                    if (do_lru && !(mapping && new_folio->index >=
=3D end))
> >>>
> >>> It might be clearer to write this as
> >>>
> >>>       do_lru && (!mapping || new_folio->index < end)
> >>>
> >>> To match the page-cache check further below
> >>>
> >>>       if (!mapping)
> >>>               continue
> >>>
> >>>       ...
> >>>       if (new_folio->index < end)
> >>>               ...
> >>>
> >>>>                              lru_add_split_folio(folio, new_folio, l=
ruvec, list);
> >>>>
> >>>>                      /*
> >>>
> >>> folio_check_splittable() makes sure that we have a mapping for non-an=
on folios.
> >>> (no truncation). end is then only set for non-anon folios.
> >>>
> >>> @Zi, any thoughts?
> >>
> >> The fix works but I feel that it is masking the race between folio_iso=
late_lru() and
> >> folio_put(). I worry that the same issue might be triggered in other w=
ays or
> >> in new code if we do not fix the race.
> >>
> >> To summarize my thoughts above:
> >> 1. adding frozen folios in LRU might be problematic, since folio_isola=
te_lru()
> >> has a VM_BUG_ON_FOLIO() for it but still chooses to proceed the isolat=
ion.
> >>
> >> 2. the race analysis is not clear, since both folio_isolate_lru() and =
folio_put()
> >> do lruvec_del_folio() if folio is on LRU. When list_del(adjacent->lru)=
 sees
> >> the stale link, the folio is already in buddy and page->lru is modifie=
d for
> >> PageBuddy use? So even without CPU0, folio_isolate_lru()'s lruvec_del_=
folio()
> >> can do the wrong thing on pages on buddy?
> >>
> >>
> >> --
> >> Best Regards,
> >> Yan, Zi
>
>
> --
> Best Regards,
> Yan, Zi

