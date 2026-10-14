Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3343CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 00:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 568866B0088; Tue, 13 Oct 2026 20:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513186B008A; Tue, 13 Oct 2026 20:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DACB6B008C; Tue, 13 Oct 2026 20:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08F186B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:06:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B482A78CF
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:05:48 +0000 (UTC)
X-FDA: 85319288376.06.6198CEE
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1D7D940010
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:05:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NJhH6i8X;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791936346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Y1oo8EWenBlY3BpHQDLYrrC9DTOm+pseWLNNQG3q3Q=;
	b=3BZSy7y8SEXYjgeZdDlqBB9uWkomgBwrfFkO0MEPkgC0JOEEPAuqOwS0mi86NopSWMqZVv
	DyyUo/nSTzC1/JsHOQcthmWTP2i3DNTbL1RC9NUaoXdcmpXyoGIMlQwOE8Pylfmc1uCR/R
	g7fliyZKZA2I+F9LPv5pA/hs4I1nAcw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NJhH6i8X;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791936346;
	b=UyGtGLHdB+8p3dBsFhHGfUnjbLueMj2M5njxBoO5pCqYqABXy0pSyeGMlFoyadTywbYiCD
	YhZc/fr5OA996mMjbDEt4I7S3AIatoviDPHT0Qh0Abx4XMFbFF8PuaV+n6q6z6kFvMGsig
	SrBMD+clGo45kjMG5rGbKBUjHAHtW5Y=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b9d8055dfso2658032f8f.3
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:05:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791936344; cv=none;
        d=google.com; s=arc-20260327;
        b=PoOf9PSykVw1wVnto4aBnNg1Ae1xbO1HiXbENv5f+bbl6BfqrnKbhT8CQMlsygZJjy
         UxCDyqjDbrw+K4v46jmliPbAyZ525Tp249g4xGjWeiN8PcwoojjAMFebz/cTf/8U6oIc
         xUnaw3bRUE5kzPTyc7+djnS2IcT3cn7MRDzyK/mMXtjAXVZspj4Tn3U62E+icvjGXY02
         Wq4rNqH12NOGFbbThNWgRIU2m94LHzHZl0zJAMgEfFe5yMwCBvjtszfTM0EzXsC/0pdN
         hp49rtHBI4TLe9cA19g0HqsAF2SEszw6eWaeT6FvNMJL4pGLrtG+WRlcuetUH/f4Rm7q
         VDmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0Y1oo8EWenBlY3BpHQDLYrrC9DTOm+pseWLNNQG3q3Q=;
        fh=nB+WPIMK0bwF3RxOx8N4f9nteMLQMZJv82fcusyS+04=;
        b=jjAJ5p/BdWy9FgEsFCliZwIEYuNJvYvP3xfjWihAV17Q4GlXgCrVk7hVjPmrW9ve5g
         zMm7t3HRRbZSn8UwVU/XBoo3Xw5TvYIgzsR8zC7zD87N6izUIRCqaU+grET3c5UdB0nv
         YP+12UBOe62oxE6VKfKnoNOPONl9SE+xwCbGGEoGdIpb+plQ7zbft1j5mS8oZixoJqMU
         2T8apXVbuajGRcRYYZiYcLHoSogEzaNteJTNBlKoT/1tdgU/lVY/uLCOtvGt2RVd5K8N
         WnI3Fi1rJ9MP3u73T5zwlo7f51JtFWOcZi5cwFwCAQvdM2Y+Re0sdS64EHqsCa4gybEo
         Qdow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791936344; x=1792541144; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Y1oo8EWenBlY3BpHQDLYrrC9DTOm+pseWLNNQG3q3Q=;
        b=NJhH6i8XDovWgru8axXJanu3BDgtAo0c9MAUyRMUage5sCLzNXmLNTcAHQgzaofR06
         bXgrg8+E5uO4IjlKDO5fRjJvy5enbA7BYR/TTJohhC6oPiM/tyxfJudmqzbVOLrKcvM/
         shO7I4XgwJmsyVUxgALf0cj0LG8sagKMCSCa/QktRxOg7aoxzARY1/dvQ5kKFFUoAOLZ
         +lvCfpguCUrb7clt0PLU72eSpkXzgXNSQIfm+gdDUyqV9Wg3GFQzlNqfvHc4Ylxj37zF
         cSPnCRniw2MbaVUKmZYBWVBXQse2pPNNvorMp0qsW+tVf37O9jYlRs1zQg8AWpwxR0bw
         Z24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791936344; x=1792541144;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Y1oo8EWenBlY3BpHQDLYrrC9DTOm+pseWLNNQG3q3Q=;
        b=dw6HkdSMZwQbQ0Itzo2TlkiLPz7RSaz8Bk/KinCEWbzE6g+Ip87t4bHvenh32c9F3W
         kFo03guaYNEbixhstZX2oC+9uWHMOU7qO652zBhjQRS9zVQPXTNwCtKTLMMN3e7TIgQK
         pR0g6ESMwyGXL0u8/eyt2p/Trh2yoW8It0kH6fxXDDjfW4JuZlB7YC54vbbS5gd2lzL/
         NAxSUgrBFB6J5FWZLb5gCRCV1vL0GLbNiXw+fIJqZlMDGx2o4CnFZ0Ywd5MSRUV1HoSy
         zRLYL/kqfhoc9DRVRlNdQwy7qHaiwjJ19B3E/OdurN0zOj7yJryla1VHsH1+NdWo3a8v
         j+uw==
X-Forwarded-Encrypted: i=1; AKwUvBzO06hzGEDhsEopmYTw0/0Nful6Ks9qkt2nZRZ08m7clOF/TTMVyptjm8aMhM1pLwaJsEQDf8PAiw==@kvack.org
X-Gm-Message-State: AFq9FYLW5kvt+JOcSKKHdVjvchRE0iVKnp5TYiShNYWhLXkZiSCC2Qgz
	Rca7430XVAmI0ciGmC+Zx4JAeuOyiHctJu3bZw+dZmsV4efY6nLadcEzRd3x9xXxuK1QrqmdTBX
	27nJBKTVN55yw+AIerhWfgZoFnU7WE34=
X-Gm-Gg: AYBFou0vMeo+rRAs3w/xtg42sVa27VSg3CkCUtrikudYq/YRDDsBMYXhajaxT8cIk7l
	LPy9N8HWDq9cQyWOxx686mRDn0+jbzV449Py+nU+x6N+K/uCUzZ8a28uANF2Va8kHBrKfPBnuFX
	DO0MBVWfbyAYh/C7TTrHrxBBA4ruiBbyJykuvDVi7DRQX+nLQeL7MMeHF12oQN7b8mIAsn5lbyb
	4QrhVU5mYYDbtgrpeVIbp8AWbczKOyhaNbQ4/VNmFWaK5Ey3hK5hEsv6hf54EuOTpxQhTRqdCwr
	T2Qe1l2IlZlps5WWKQb/xzsIy5Lc4XMvlE228kPHyeBPjFX04HF9U/x5pRRwqHYTWBnqnbqp9Nk
	uZYkXNMcjYoK0XL2wKGX9dbaca6UtEHjEB+ra9gc/r8vLbS7SX+lK
X-Received: by 2002:a05:6000:491c:b0:485:1bcc:67f8 with SMTP id
 ffacd0b85a97d-48dbaadb2d5mr26190862f8f.13.1791936344413; Tue, 13 Oct 2026
 17:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
 <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
 <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com> <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
In-Reply-To: <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 13 Oct 2026 17:05:32 -0700
X-Gm-Features: AclHuK8WhcrCOTeK0kKrzzEhohmXHWs0Un0onHQb7Xyw4WEMp2HD0VK19I_-6P8
Message-ID: <CAJnrk1ayOhrFY8LOMYxqEMYZvhK10zjTTyOK93VzMgxpV5W5sA@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, James Houghton <jthoughton@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D7D940010
X-Stat-Signature: onuqkf3xr6xqrphjduyhkqj8uneubaqy
X-HE-Tag: 1791936345-426778
X-HE-Meta: U2FsdGVkX1+c7edo2g/qn2cXQEpneFCm04TUzrZpENBlxiihrQ2GRn0dWyxuZMDEjzRoJs8lIttk9apIjVRPS83IXWs1jYajktQ13U8FEF6+ehA15AVyqvUg9bYYTYcGhC3y1d6+7w6zFM+CROhG6kd9/V4Fgekj1w918NYKPfQnzRbqV6ufeCnC+tcs/8JRc1+SWSjdgEJvUeVhRuP+2xjJXvd05xBUuFljPZjtLiilbCHMqJ9qMK3QiP1EX4KOCrze2MzqhB7wx+MOl0C3yrCPmQQ+7rWrpjk4FZNAQnoW2eowoTShlvmOQ/o1HvU0UaIhH3O5upxLC46c6pYR22mHSf/lbC2uYY1pHlkhmIOIk/zy8jdjxV3ZNF6VG2cEYilp5Ifg1j4DM1NSwLSxQ+tK5VmuvLHlaxCCBlRi46UT4xNFigzsSiZrGSYWlaZ6I6dzlAr026i60L6UMoqv1tpalUUGPzyoRC0DvPG3gYQH1yz2uxO0ATo34L0hgxZYmHcGXf2qm3iWIPvvIjg4SeQjz7VI5UvXLN/awvLiumK6K3HRQK6irQ4djTM4sbrFuQAUHgm8fEvHDzhTQ3+7dFTDsRrPhwAKegRmlwCUpg0Z6Nwd8VJ8wXUdI3TLIHRI6RHSbtRynlrpgWatCnPYQKRSC6yMgpLj/ZhIOoigUT1F9w+z2q5L0oAM6qZhU5TG07I8RpYW0YqxVLPc6tQSgE7tg3fnFI/G+rYkjm+EEx0XhcrfTmkSfmAw9Wdcr/zeScb1peX4NA2EQTKPxfWi1KlRHT53EoyNTRVsDKfQK9kQH8UGsTI9txc4idR4h7DtDaKjAepZTWPmxannPAJSKIjhhJDXvrnkStdSzeP1jbCcpet00jiUq53FY+6medwtD7BpGJgdA8zqMePtWSjA7nw7eV3FizC0vhbzSUc9U/HdDmStS5nOVsgTcizJxah0apgIt0Y33WgYZy7HseG
 9lIFiNsG
 vL4sUnLmhGahVSHKp1Zxg5tW3O/nQE63cdEUM6YL0cRoXWSIdzI5tCuh8qxMrBMB9wkQz58C8W/LmOqcnj8kNeppKddg5tIaoeh18qChImhYhmH7ANW83NSq32PVgwAE8zWXJ9t/1/Oxcepg/MWoiApubY/wfOlKopBA1isIrF7c7jJs/MvBbixsQ2kIe4fNF1mOdXiuA7gH8zvTu+YKvHiWCBO1SMK7fBM9reEko6eMYBd8iZWB5JalHq9i7fvPgsOfkTQRb0eanMr8o/KL+HSbb04yNMF5ht7VB7jDX3WVZLulYFhBpa8oQdNlaqtRpiz9n/Bl7WD8mZtcCFykv2+ADMDi5lRb+tJWUmbNWjwWK8gpeHB++BW8C31umLLudoCz43Zn8iltIEvdLo0oBfOqNrV2uNVpfEaaWFWddBB+svDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

On Mon, Oct 5, 2026 at 1:45=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > I added some instrumentation to prepare_scan_control() and have been
> > seeing that the OOM gets triggered in this pathway:
> > a) the memcg is created with memory.max set to unlimited. 512 M gets
> > faulted in. The new anon folios get put on the inactive list. Nothing
> > reclaims them yet
> > b) userspace then sets memory.max to half of memory.current (~271M
> > from ~542 M currently used). This causes memory_max_write() to trigger
> > reclaim logic
> > c) the folios have already moved to the active list (my
> > instrumentation shows 122684 active vs. 179 inactive) when reclaim
> > does the scanning, which means the only way for pages to be reclaimed
> > is for pages to get deactivated from the active list back to the
> > inactive list.
> > d) prepare_scan_control() (which decides if the pages get deactivated)
> > reads the LRU sizes from rstat. This memcg hasn't been flushed yet
> > (the 2s flusher hasn't yet triggered since when the memcg was
> > created), so the NR_INACTIVE_ANON and NR_ACTIVE_ANON stats are all
> > still zero. The real values are all still sitting in per-cpu buffers
> > that haven't yet been flushed. My instrumentation shows:
> >         inactive_anon       rstat: 0    actual: 179
> >         active_anon          rstat: 0    actual: 122684  (~479 MB)
> > e) the deactivation logic in prepare_scan_control() is:
> >
> >                 refaults =3D lruvec_page_state(target_lruvec,
> >                                 WORKINGSET_ACTIVATE_ANON);
> >                 if (refaults !=3D target_lruvec->refaults[WORKINGSET_AN=
ON] ||
> >                         inactive_is_low(target_lruvec, LRU_INACTIVE_ANO=
N))
> >                         sc->may_deactivate |=3D DEACTIVATE_ANON;
> >                 else
> >                         sc->may_deactivate &=3D ~DEACTIVATE_ANON;
> >
> > The if check fails:
> >      refaults !=3D prev refaults: 0 !=3D 0      (false)
> >      inactive_is_low(): both LRU inactive and active values are 0: 0 *
> > inactive_ratio < 0     ( false)
> >
> > DEACTIVATE_ANON gets cleared
> >
> > f) pages don't get moved from the active list to the inactive list, so
> > reclaim ends up freeing nothing. memory_max_write() goes through all
> > MAX_RECLAIM_RETRIES and OOMs, even though there's 479 MB reclaimable
> > (but it's all on the active list).
> >
> > I saw that the skipped_deactivate retry did fire (on 858 of 4264
> > scans), but not enough to get the memory.current back under the halved
> > memory.max, so memory_max_write() still exhausted MAX_RECLAIM_RETRIES
> > and OOMed.
> >
> >
> > imo I think the best fix would be
> > a) for non-root memcgs, revert back to the non-ratelimited version
> > (mem_cgroup_flush_stats())
> > b) for root-memcgs (which if flushed will flush every cgroup on the
> > machine), don't use rstat at all and use the existing node counters
> > instead (which is what the non-memcg case already uses).
> > mod_lruvec_state() always updates the node vmstat and the memcg lruvec
> > stat in the same call. For the root lruvec, the node counter reflects
> > the same value and doesn't need any flushing. It has an error bound of
> > 125 pages/cpu at most, but this is tighter than what we currently have
> > with the ratelimited version.
>
> This seems like the right thing to do. If we have global stats, we
> should avoid a rstat flush. I actually wonder if we should start
> systematically eliminating root flushes, and if that ends up being
> good enough to keep everything else as-is for in-kernel flushers. The
> flush in zswap_shrinker_count() is also a good candidate, we already
> use global stats when memcg is disabled there as well.

I agree, I think we should replace all root flushes with reading the
node counter values. I'll submit some patches for that.

>
> >
> > commit 90a6f2a8f442 ("memcg: use ratelimited stats flush in the
> > reclaim") was what switched vmscan to using ratelimited flushing. The
> > reason for this was to fix the stalls from concurrent reclaimers
> > contending on the rstat lock. For the Cloudflare case, kswapd threads
> > were contending on the rstat lock on 8 numa-node machines. That's the
> > global path (eg sc->target_mem_cgroup is NULL,
> > mem_cgroup_flush_stats() turns it into root, so this flush essentially
> > ends up flushing every cgroup on the machine), which gets addressed by
> > adding the fix in b), which takes kswapd and global direct reclaim off
> > rstat entirely. For the non-root memcg case, the flushing is bounded
> > by the MEMCG_CHARGE_BATCH * num_online_cpus() threshold (a non-root
> > memcg's stats_updates only accumulates its own subtree's updates, so
> > it takes a lot longer for it to be exceeded than the root's does).
> >
> > I ran some benchmarks to get a rough idea of what a) costs. I set up a
> > workload that allocates 512M of anon memory in a memcg with memory.max
> > set to half of that to trigger reclaim continuously. I varied the
> > number of threads touching the memory, so that N of them hit
> > memory.max and enter direct reclaim on the same memcg at once. I used
> > bpftrace to measure the time spent inside css_rstat_flush() and
> > shrink_node() and used those two numbers to get a percentage for how
> > much of reclaim is spent in flushing. These are the numbers I saw:
> >
> > # threads      flush as % of shrink_node()
> > 1                ratelimited: 1.10%       non-ratelimited: 2.22%
> > 16              ratelimited: 0.36%       non-ratelimited: 2.87%
> > 64              ratelimited: 0.16%       non-ratelimited: 2.52%
> >
> > Between the ratelimited and the non-ratelimited runs, walltime and
> > pgsteal were pretty much indistinguishable (42.7s vs 43.6s at 16
> > threads and 41.7 s vs 42.4s at 64, with the ranges overlapping, and
> > pgsteal within 0.2%).
> >
> > I also measured the lock contention. At 16 and 64 threads, 15-20% of
> > __css_rstat_lock() acquisitions hit a contended trylock with the
> > non-ratelimited version. At 16 threads, the mean flush time rises
> > about 8% and at 64 it roughly triples from the single-thread case
> > (26us at 1 thread, 42 us at 16, 87us at 64)  but I didn't see any
> > effect of this on wall time or pgsteal between the non-ratelimited and
> > the ratelimited version, and the percentage of reclaim time spent
> > flushing stayed at 2-3%. I think that's because css_rstat_flush()
> > takes and drops the lock once per cpu rather than holding it across
> > the walk.
> >
> > I also ran it with 32 actively churning sub-cgroups under the reclaim
> > target, since css_rstat_flush() walks the descendants that have
> > pending updates. I saw that per-flush cost rises slightly (~24 us to
> > 27 us) but the share of reclaim time spent flushing went down rather
> > than up (4.1% to 3.2%), because reclaim gets more expensive faster
> > than flushing does. I don't have a ratelimited baseline at 32 children
> > though, because with the ratelimited version, all the runs I tried
> > OOMed. I think this is an alternative repro to the OOM issue but
> > doesn't need/have KVM dependencies, so if this would be useful to
> > clean up and send as a standalone C repro, please let me know.
>
> It might be useful if it can be added as a selftest or similar, so
> that such regressions can be caught more easily in the future?
>
> >
> > (Also btw (this is a bit tangential to this OOM issue, but somewhat
> > semi-related), I don't think the WORKINGSET_ACTIVATE_{ANON,FILE} stats
> > checking really does anything in practice. On my benchmark runs, the
> > "refaults !=3D prev_refaults" check evaluates to false in pretty much
> > every scan. Even with flushing working properly, it didn't trigger on
> > 1673718 of 1674912 samples, even though the cgroup was thrashing the
> > whole time (a separate run of the same workload counted 6371860 anon
> > refaults vs 6523 activations). I think it's because reclaim is
> > scanning faster than the refaults counter advances, so it'll almost
> > always see no change. I'm not sure how much this matters in practice,
> > but I think effectively in that check above in prepare_scan_control(),
> > deactivation relies entirely on the inactive_is_low() check.)
>
> I am also not sure about this one. I am not sure if reclaim moving
> faster than refaults is something universal, it seems like it would be
> workload-specific. Johannes is the person that comes to mind when I
> think about these heuristics, so maybe he has an opinion about this?
> :)
>
> >
> > What do you all think about adding a) and b) as the fix for this issue?
>
> I generally agree. Doesn't really matter much, but I think we should
> do (b) then (a) to avoid reintroducing the regression temporarily?

I'll send out the patch for (b) and then (a).

Thinking some more about how stats are used... I think there's two
categories the stats fall into: a) hot in-kernel ones (eg LRU sizes,
workingset counters, dirty/writeback, zswap) which are read very
frequently from the reclaim, refault, writeback and zswap paths and b)
userspace-only ones (everything else) that are read through
memory.stat / bpf / etc and much less often. The hot in-kernel ones
are a small subset (~20 of ~80). Most of the stats fall into category
b). However right now, a flush always aggregates *all* of these stats,
even when the caller only needs / cares about the hot in-kernel ones.
Flushing does all the work for the stats in category b), which the
in-kernel flushers don't need. With the per-node lruvec copies, a
flush goes through 100+ counters per cgroup per CPU vs ~30 for just
the hot in-kernel ones (on a single-node machine).

What do you think about splitting the stats into two rstat trees, one
for each category? In-kernel flushers would then only flush the hot
tree (~30 counters). memory.stat would still flush both (eg userspace
would see the same thing as it sees today). Each tree would have its
own lock and its own stats_updates threshold. I can run some
benchmarks but I think this would make flushes a lot cheaper, and
since flushes would hold the lock for less time, it should also reduce
the contention we see between concurrent flushers right now. Together
with using node counters for root readers, hopefully this will make
the non-ratelimited flush cheap enough for all non-root in-kernel
readers and ideally let us get rid of the ratelimiting variant
altogether.

Do you think something like this makes sense?

Separate from this but also kind of semi-related, I noticed
css_rstat_flush() takes the rstat lock for every possible cpu, even
cpus that have nothing to flush for the subtree. Maybe another
improvement is to just first check locklessly whether there's any
updates and then just skip the cpu if there aren't any. I can send a
patch out for this.

Thanks,
Joanne

