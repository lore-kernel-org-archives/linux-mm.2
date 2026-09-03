Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43ACDC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 19:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE5F6B0088; Thu,  3 Sep 2026 15:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FF86B008C; Thu,  3 Sep 2026 15:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06EAD6B0096; Thu,  3 Sep 2026 15:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D97616B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:01:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BAA6A4834
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:01:38 +0000 (UTC)
X-FDA: 85173369876.07.059B783
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 837F14000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:01:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f8FcuwgL;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788462096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4k6051qYGqcOE0IbvTlu78LucmjSeHvrRypj52NEgg0=;
	b=SrpTxdUmU1DxMP2QCkP7rwPAGs5OgeJED8g/h/gHebfOpS5IcFkGw+wMi4kV77wxXBRSve
	pSjbx9SJy4/5DnXUehk/vSh4MIL1psgBQXG825LYdcBvUuhAnJiI3MiDf90gF+LZ6Bk7iJ
	2CblTHnNbPDbR9Um2SBu52EU3t7ahLM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f8FcuwgL;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788462096;
	b=MgraqLiAKy2zR2aoE9A3AN7+9UmKWOBZ71rTbn4Wn0zivXcvOV8BoPa48N5z+c3tvmEpOV
	0DNuhOeNXTSl7W4Z4A183c+MXQRMp2rc6cgkGmuRFgqRQsfyV+yv4wMzTC7wHBRcHu56BH
	eKKGxRH0oCCCBjq7REMEsCJ4o/6blKc=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4843e397f74so232433f8f.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 12:01:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788462095; cv=none;
        d=google.com; s=arc-20260327;
        b=L+lopPyybojMQUxlVYGoKE7V/gwpFgHUMR130nSMLouvF7OPkhz4qhtbETWLQXooqc
         VamzeA0OcUYB0dib+Ho8B7CuwOe28G9d+cb3ydK4A/NWav4O79FBDNpfmpcFueuIPbnC
         CvF1y76Xz35escWUq36Xlb6GRaFiTnXXeyYlL/OICR98GEXZzXqJpRLBf9AHYphGuVhr
         lKtUBDGg1eTEXSmyuIh1n6Ibtlo+nZnTwkGLWnhXiiUuUfadChQgpmmcXYi6/XnvwOUI
         3neceofN3zdM395nOWNTFxy6IkB+RCjY9XEtBZ4OWCfqPfUp+k9xmWAJHT+7QI1fN4L1
         Sdow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4k6051qYGqcOE0IbvTlu78LucmjSeHvrRypj52NEgg0=;
        fh=ADQYGoFp7OVoUemyxaMhUTdLFFV8+JAYf7HQVZkXFDQ=;
        b=Xx4fgywfibbtHfds/Tj0t9eqEP/tOL1gGvjuB7LZzLYAIcQfVt7wmfvn3N60usE8i3
         7jyuqYcuQoPlxcHy0Q2cYWW+v92hH10xgW8q4E1H/KrSTkR+1jpvkYvQm5xnkGqih3vs
         au63slKy3NJEhoju5NiSvNo1cAafVy6QFmXhYhrjQGOMFfdw+Jx7E/yJoY5sr+rGbSnx
         Z6NHfLQRJf0A5ios4lmzkk0UUWY/BwKSJjdnXJQcQgmi5tQdesvkswXnxmL/D5x8rewo
         +8oGA7jJrYc6HfLfjGFLNXZdG60yNyRFcr1Kt8T/kqX/jy+ijSoRC9hU5dfF0y5qhGCh
         6UeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788462095; x=1789066895; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4k6051qYGqcOE0IbvTlu78LucmjSeHvrRypj52NEgg0=;
        b=f8FcuwgLlBba9Ww9Uec3oHOLN9CVg2a1VfYFaDZ3CvLHlgSIoM7RB/vLNOuzcLsDuv
         Ya/REWr+v0gN0On4kG9jCedlly3cc6rfJPWC+Gs3CrWNsKmPPzoxVula7Ow/dosAxvD5
         hGo4bYP+42SdO5QxWa1ljp2nFMrh0fzLpTONsfsN6K9QuQ3FRE/OOpWoN0v79581Xerp
         fzIHnyQqSqGdBnQYT/5f9bBkoYCluJZ96Wl+UwsnUfZfG9qVSveYSn5ZGIM0hojrQeCh
         ITtQyx6o4zPLhdzBRu/GhVPhV1/HK+hSSTkppnQJR79k2AmhNocsmqj89GlIqSkZnPNs
         48HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462095; x=1789066895;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4k6051qYGqcOE0IbvTlu78LucmjSeHvrRypj52NEgg0=;
        b=tKYITK9ls5dNM0GrOtenM6fiz2aE0zgzRVfTRNuNqxC5I2egYjwe3QTNqehdr4lkkf
         fpzRM3ft2Va+6/L88hgBR2E+OblTbxe8SAQWcVXAa2BQQezCe+yosaFRpYjsojloKDY/
         04NnTDChaIyezFyCIraCHfF0L3FokzDqzGbb3eosClaVEvWB2tHVSxUECJgStZ4zufGo
         sJiAecf5FTFn3AT4CPKiYEs1Aw338mLpl1SYSQkHqNFirEd2k1sW5bOzIXdGzunQ180u
         P/jajYavReRBV0zpi6Cg2K0DGGIUQ6MgKw5WHnWnwAEq2GV6DS4g3Wo52Ne/ME3033hE
         1Z2w==
X-Gm-Message-State: AFuF++lkwwu2UXFiilLe4KtxDjI8JHmEn8t6gi9nhthCQl9UlseT+Tg3
	bIGacuH32kO8guDFKOKYuBDf8x1F0KA7R0m/Gx+kpm+6NeL7SsdE5tDJp6LgRVDTAA7zGMPUy8l
	t0vJ3nNLTPp1nFDalQhitPyaL48qw5tk=
X-Gm-Gg: AYBFou1mWxaSOrQXXD1+lBEG/JpBLBAbEo96KicaWNYfJ3X2xBD27I3bZWYjrEdzkR/
	CCjaCLKpvyuiKokANcI9ATPfYuE4gqOf4dSN4p8NXEGehbn1BCqNYplllovEzL/b1BGQAivlLk9
	GFC8jXXy3SxNVVAwbh8lO277iHCfu8XGyIjz4xd++p90MmWKfRRfUQ2vtC2imFIuM+MYzLExIcK
	XrS81n5vCkxHxFQvdN1g1TcaTZI2KesvnNbnv3TfqWVSl9Gy4ZXfu9XmSMIBA0QDWsmnwbG+Z39
	zcq+nKsGHGGFeT/kIh11TFlcJ24U1BRawtbcln+QanaSGQ/Ztm8idK34DwjfuwFdzXhCaegINp0
	ZYADb5a5rDiI/NUon/WsYx6Q/P9I=
X-Received: by 2002:a5d:64c4:0:b0:485:7d6d:e0e0 with SMTP id
 ffacd0b85a97d-48582315f07mr6561895f8f.3.1788462094628; Thu, 03 Sep 2026
 12:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
In-Reply-To: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 3 Sep 2026 12:01:22 -0700
X-Gm-Features: AcwNN1Xq1z0FxsQ9zPWn4QO4ZTMRixlUUwLEJLuKQWt5XQuIf6s3hWHxYB2ovjw
Message-ID: <CAJnrk1ZLzNQxrSLQx7TsLK89QC_=9cDfoDcyKNBNde0CiDGoNg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in truncate_inode_partial_folio()
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com, 
	willy@infradead.org, jack@suse.cz, ziy@nvidia.com, bfoster@redhat.com, 
	djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, 
	yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fszd5e51pjkytj3s3pr8cfy9ddsrbfx5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 837F14000E
X-Rspam-User: 
X-HE-Tag: 1788462096-779050
X-HE-Meta: U2FsdGVkX18mRxWw5WSHRT10yY1mxJBdsFmQVBPZVKaN1i/eB6O9WPHtfaNJ/+SM/7xO4V3mk6sPAdr8rFoXwYaGmqkCrD4pUk0ZznHwlsUpVRTzr9YTTKqDn6Y6G6h83tV3Bv6YCS6DQLd1/ldW5iAmgCP0MtYMwL2JX/KJu6l9umw3rh3sCOzNUZATf5XydDCNEg8BwXyJ5B7YYrJq/0wp3QzEQO2togslN8A0q9Xgt4jpHsEpb1zIRcorHW0tcKQ9E1luNN8ll7CDbBc2YBecjtrvlZ3y4xL9csKIkGBC0q9MWEOSqSfA2UlP1siEsRl/aiUwDK9qGzIPzyBN/QmftHy9hHLsy9Jifvtdh3OG41FZYBl58GUKEFqrXQSN/ic33VSpBcOi9qLVDPAS8dqJEtBCIWTVq6cmNi4xFjpMW6Tml7ZbjjLeZwAJDo1pFyWXQ0Ta9FgCHO4wu9EBCEfJA4UH54zegNZcFya8W5DOZ5d6py8KH84wf4vE58lxW/plaswgh/ERfp02+T3S+lqZCdvgup3Q1hPvcX+xIZu6VmBSIryDGP4c+rqTxpG76Wqg78XOZWuA4XugrAkuUjWUevCRn59Jb7ePBPjB1GjgzRo1aH5kQ19OgkFKsacxP4OJuOuOsjQRggZffbXFpM+VfJDtMKFFXoho3eKbgxr/LbCkUB+jhK/ukPgYjwNMSIjCo1QymszOJF+NCzvb6jKkfF4bKN/1guihCuH/asRdPgsM+lELKjFB4S5NrutJTEaqofcPvhWhqvZ4EKl871q/prs1Iuz+w1/SDQqfMijrT8rqLlhksVCgEcMaCRhHoDCe1cyqzM5OYBHXd7YsFaHz0PMLWFVfKMn0AYKKEhF9bNwRudpHNmGBT08VBESFjQYgbAss8JEOF+nOpN2Jbc/kyAgDyOaX+EvIu6cN6g3Ll0cTu2x4G1QrTns3ECQknmLNa/ryTl6w4CsMkc+
 Bw38D6JZ
 Tq2MrmLUEfXlKpTp1IpNej7LMGU3FHqkNZeDsZ/r3xSTiuWCJ5X1uwxCE9QMa5Es0edabjmDLwp96cE6A+4k/51rPh/WWPpkXTFK47TcpnllzgpdZYyrBvAvmbjm6wk8Cbv4g2x5uPy1jBAQ5h8zJJNn6wbaSrDNi838TP+SLRWb9Wj37uG2tTtJxw0kj7NTiveDyLKEC/eKQS8vNUfWWrO+lTwwYpuXEOKX80uTxrD0zuT5a8fFazP9MBddI4hyZtgJ5+sqAc7sv0zzCGQV2Y3fC01T3oR6umCzE0yrwQq5EzvDKNJsP/k/ZassmXoKzFlPrJluhc7DrjlGB9MPBXbL3N4pAOhRP9AtLEhjHca8+sNWDYpAZiz9ohFcfSblr7wkpeh2wUWbb97xutc9jxzpEx5+GMLM6V8A27RFHRVvkcEdLb1DQTeR0LJyXumPy7XRYLkoEZU6xpU64wkZEk/DhJ2FPvfHIAxDotFdzn6TXrlc+/Te44bL9lV0UEDloDq5tilx+xP1nWZYnbWjdb9h6tlhvrTkvXU4Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 5:01=E2=80=AFAM Zhang Yi <yi.zhang@huaweicloud.com> =
wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
>
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
>
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
>
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio =3D=3D true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 =3D p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end =3D 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
>
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.
>
> Rework the contract so the caller is told where to stop instead of
> silently truncating the straddler:
>
>   - Return true only when a split occurred, false otherwise. This
>     clarifies the existing confusing return value semantics.
>
>   - Add an optional out-parameter pgoff_t *end, set to the index of the
>     folio that contains @lend and must be kept by the caller's loop. It
>     is only written when the folio actually straddles @lend. On the
>     success path it defaults to the page index of the end edge and is
>     refined to folio2->index when the second split fails to isolate the
>     tail.
>
>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>     clashing with the new @end output and to separate byte offsets from
>     folio indices.
>
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass &end
> only when the folio straddles lend. After all, no caller discards a
> straddling folio anymore, the in-range cleanly-split sub-folios below it
> are still dropped.
>
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operatio=
n")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/internal.h |  4 ++--
>  mm/shmem.c    | 12 +++++------
>  mm/truncate.c | 57 ++++++++++++++++++++++++++++++---------------------
>  3 files changed, 41 insertions(+), 32 deletions(-)
>
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..2ebb00f6c379 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -206,15 +206,18 @@ static int folio_split_or_unmap(struct folio *folio=
, struct page *split_at,
>  /*
>   * Handle partial folios.  The folio may be entirely within the
>   * range if a split has raced with us.  If not, we zero the part of the
> - * folio that's within the [start, end] range, and then split the folio =
if
> + * folio that's within the [lstart, lend] range, and then split the foli=
o if
>   * it's large.  split_page_range() will discard pages which now lie beyo=
nd
>   * i_size, and we rely on the caller to discard pages which lie within a
>   * newly created hole.
>   *
> - * Returns false if splitting failed so the caller can avoid
> - * discarding the entire folio which is stubbornly unsplit.
> + * When @end non-NULL, set to the index of the folio that contains @lend
> + * and must be kept by the caller's truncate loop.  Return %true if the
> + * folio was split, %false otherwise, in which case the folio is dropped=
 or
> + * may still straddle the range, so the caller must not discard it.
>   */
> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, lof=
f_t end)
> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
> +                                 loff_t lend, pgoff_t *end)
>  {
>         loff_t pos =3D folio_pos(folio);
>         size_t size =3D folio_size(folio);
> @@ -222,19 +225,22 @@ bool truncate_inode_partial_folio(struct folio *fol=
io, loff_t start, loff_t end)
>         struct page *split_at, *split_at2;
>         unsigned int min_order;
>
> -       if (pos < start)
> -               offset =3D start - pos;
> +       if (end && pos + size > (u64)lend)
> +               *end =3D folio->index;
> +
> +       if (pos < lstart)
> +               offset =3D lstart - pos;
>         else
>                 offset =3D 0;
> -       if (pos + size <=3D (u64)end)
> +       if (pos + size <=3D (u64)lend)
>                 length =3D size - offset;
>         else
> -               length =3D end + 1 - pos - offset;
> +               length =3D lend + 1 - pos - offset;
>
>         folio_wait_writeback(folio);
>         if (length =3D=3D size) {
>                 truncate_inode_folio(folio->mapping, folio);
> -               return true;
> +               return false;
>         }
>
>         /*
> @@ -248,7 +254,7 @@ bool truncate_inode_partial_folio(struct folio *folio=
, loff_t start, loff_t end)
>         if (folio_needs_release(folio))
>                 folio_invalidate(folio, offset, length);
>         if (!folio_test_large(folio))
> -               return true;
> +               return false;
>
>         min_order =3D mapping_min_folio_order(folio->mapping);
>         split_at =3D folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZ=
E);
> @@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *foli=
o, loff_t start, loff_t end)
>                  * for shmem truncate
>                  */
>                 struct folio *folio2;
> +               bool tail_isolated =3D true;
> +
> +               if (end)
> +                       *end =3D (pos + offset + length) >> PAGE_SHIFT;

If I'm understanding it correctly, based on how
truncate_inode_pages_range() uses the end value (eg the "while (index
< end)" loop condition and the find_get_entries(..., end - 1, ...)),
end needs to point to the start of the folio if the tail folio from
the split is a large folio, in order to exclude that folio from then
being truncated. But with the (pos + offset + length) >> PAGE_SHIFT
calculation here, does that result in some cases in it pointing to the
middle of a large folio? Maybe some logic is needed to make sure that
it points to the start?

Thanks,
Joanne

