Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B48D3CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 04:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35548E000C; Tue, 16 Sep 2025 00:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D1E8E0003; Tue, 16 Sep 2025 00:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22F88E000C; Tue, 16 Sep 2025 00:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB3568E0003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:00:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BBD85B717
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:00:22 +0000 (UTC)
X-FDA: 83893761084.07.441C5EF
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 76092140008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:00:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CeMZQUWH;
	spf=pass (imf26.hostedemail.com: domain of hughd@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757995220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNJEtVfq2GcQ0AyVudDE40VF7bLdO7axK4ZeL2S3GZw=;
	b=YFursmiHUGcI0pBojvg3b0riygdsufKADJYtsy8I5V1eIwZnD+OEBg/zYKExiY+M+cJni8
	cObjULaptjS6xVrFbg2B8zvLps7R/S0ACm37/a7NC7iqTlCLoyy4cx+YNJVNhfxtEvDDHP
	qGN9cV2iPrNqVUJmNRTMNr4nkwPwEyY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CeMZQUWH;
	spf=pass (imf26.hostedemail.com: domain of hughd@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757995220; a=rsa-sha256;
	cv=none;
	b=F/XfMJWx6I/6LbuulDBBiQcZWin9DQnebczYnHJLaKUIAW/SsyumdvltC8o57a4RYqNwf6
	XpaGBP5Vbuabg8N/yR/YEpfWoRnLLb6KL67VXalPbTD2TffCytlkZZTNOaneSh0qi5Gg1m
	ikM5nSSBglG78KtWXs8QR2UR3RH1Oys=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-25caef29325so43369515ad.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757995219; x=1758600019; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MNJEtVfq2GcQ0AyVudDE40VF7bLdO7axK4ZeL2S3GZw=;
        b=CeMZQUWHlk/R5VvyUziLqmynlHEgjnsojpxnHy7G5WzISj+tZCLZbImvdXfVwDyUnJ
         gyU0eDYEVdTlj+FPst8Ijb19l5eywS89zeGGjeBSdI6lkRKHdm8EMmDEhofP2UMrOfBD
         2qqORrYCmvO2/2IGbMZ32oNZQeb9Ftzy6WLOJ71TVNpw7YVOu5pQIqEqmTSmYhl1yJvK
         Tdfq/18EpFvxbR+3Mb7Yz3mJEn41jKbLEhToiVERatcTq0pgTX4VyGqdBYv1CS8CCptm
         g463Bgn4dKZuS30HF7lePF362pRescDse5lXn9pWZwPgi0JniAlcjPhWw6qHJMueunjx
         ZLIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757995219; x=1758600019;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MNJEtVfq2GcQ0AyVudDE40VF7bLdO7axK4ZeL2S3GZw=;
        b=sZPh7dUA2PvTDkxVFUTXlYr43i5H4juEqQ9Ds302nuUuO2olZOUCITWnH+RE/xWefk
         3g6l/SjHuTF7CWUoOBki88dXiyYKtOUmKLisaSzWfJjfSf4+malY3dCkMOp0YgeIhRUE
         ojkyz+K5fhEy+R/kQyLdyk4dlMyzuf6LFmRB24wxUUSIJxscvwQArP/j8pmeW7JHHI3B
         aQEWEwgvKocMbwOf5mnL9ycJcUj+ZMWXXzxzn/qepA+jzQiFevmC1H5EjRFPGBMEv7CJ
         GLlizlT+NTzAvVosfQfpbpqYJ2mBBk/+8r7CUhNbeGp//Nk+ow8DQhPszqNJx/3+A+In
         5NaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWq9GwFd15K4qhV8vbkewjSevgRmGX63ncuqYtx3YG6YcJ1ABW2prD65OIGbnY9tQG7yqAzSdrWyA==@kvack.org
X-Gm-Message-State: AOJu0YxKVFpPHAS7bJLsnZFgO6FC5bGRCINcocUoyZWXKiRXrisc1qx3
	SQ2kMhlbPDwLCijWawCnb/zl2BOgqBtl+g5WdCtUSg0Lxa1o+Ec0fBONKVGsXCd72Q==
X-Gm-Gg: ASbGnctxlQ6Ty+OqMoJgL4jKS7alFPXgvMVzO4naaheGkuoB0fJlu0JDp1fNLUsJAXE
	XqPs88sbhMNMWfFIpnBFW9vU82fiUwT/NJLfKfdc/EEZTsr161YoJRHwki4lPwWlelp+6/Sr4AE
	7/WUXQ88plTrMLhumlcp+qFsRPguK9NMM7xkxSAQxo/ZUSLVgAGuvGUsii0myrsYFnNCjgRvf0X
	4cEYdMw9aTfZfOiqVm8tBx3sDokV1qxqjBki8lTNaj/0get3GMyx1ockdp/ru5VVlbuJHgrfpu5
	voJJTVorUNP1JNbmYFUvo9EJ7Wx8NG/PseU80w1RbgcfMACPPzF+WOPdWPTWhw8xWw9O6R0NK+7
	J+8P7kYi5Jmhh+rmyrapwUTLFhgAvYGf+xUeJSp28ym/q584dm0kkVU9zuI0Yd9DNftk7xeYCc3
	iVM+q4uzsGx5UXL917ZlmrJIIG
X-Google-Smtp-Source: AGHT+IG53T40RNUouBo3s/mXkbMb2lD7TO6r4nQUvRGb2r6am8D5LXotHvJ3Vh5+L4tCmKOg3d7KJg==
X-Received: by 2002:a17:903:234f:b0:24c:8984:5f9c with SMTP id d9443c01a7336-25d26470152mr168660115ad.36.1757995218820;
        Mon, 15 Sep 2025 21:00:18 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2631e29e60fsm71657895ad.137.2025.09.15.21.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 21:00:16 -0700 (PDT)
Date: Mon, 15 Sep 2025 21:00:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, 
    hannes@cmpxchg.org, david@redhat.com, mhocko@kernel.org, 
    zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, hughd@google.com, 
    willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
In-Reply-To: <02798d6c-1ad3-4109-be3a-e09feb5e4eda@linux.alibaba.com>
Message-ID: <9b01a2cc-7cdb-e008-f5bc-ff9aa313621a@google.com>
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com> <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com> <qe56xt2natnxnkht7wgknsb5nqjhinaaajomvvvgnfpwry2jih@hsj2w5zqj6wv>
 <02798d6c-1ad3-4109-be3a-e09feb5e4eda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 76092140008
X-Stat-Signature: 84cfu36irumug634b5136k19qrgtcsmf
X-HE-Tag: 1757995220-398177
X-HE-Meta: U2FsdGVkX1+4vzpe3kwyMekrv2glL9jQn9otz1Qw7fupxDvmht8rd+jbV3R91+4dyy7H19NWuaCifVH0MStnu+F7X23NeYxTBGbkQIuLNBmWaOvnASPkJMRc7D+ofOu+vmuYjOxpGMwDPMasFYe4bQ6jbF/GiZCcaJv0H/20XfaahlS9m4uzmFx+kcifr8TN79NsFLPuyKdTjVvjksOi2crGlhZE2VNGTqGRfNNunqN3w0ix8JKO9QfHe96Yfb6KAZsg2H/xXtFxC6SiKymrbTlbro4MpZqZzD5uC6t1RGooD+CEDDcU60ZWX4IS/+l2+5pY2ZEdFzh3S+NpSUb02Nm4gzH3lnoNI3dJm5eQ7pu5bGmDv5WGfWQZfXcoa4iMkNe4QHpG/QkVH5jLTb73rGzKXtqbD4oEr90JDMdMp+YslYodLPHl3W6mbSK3SNtkqwY/64MOoKh0RRtMBsVOComWy04HmQSbgPNGSS/sbgrIIpLA3VsmlSnKon7POSRGfQ91zZLY9yP+qKSC5stTuiSTxU55C2Vxi/mCBbyUAVNJTnhw5y0Sgfrk27rHmkOV/rslwZuRvAjAaDpOARTwY0N2C118Cw1cxFym2u5mAett0n0W+Ozu7e+/BTLLcuRi3/o2B6a5sMR8evfRqz/GHc+A6Ejk5C67qonjLNTEFVDW/A5JdHYTvf663dFwmI0wZ+eGFXNfkxhgu6HukhYi6GZjwUDbdtplfPbMYm+e2CqO3t+fNrMmMUkFr9LaEHsg3hepP4Ql28V/9RLn6PCJIxTfXqJ6qLcqpu5CifqUuwkAtFNdLmr0jFq1O5dZCx2og/o+vklmR9lI2ag1W8RfFJMXXYc7gZ8QSL34HxlyWXcQSWeaYQpkf/a+c12CrpGcI+zhdeZDiXOsoLLhNHoXrBr0OWrB9hELuHS0+d1aRvInDxPyJX7XD3ZzVu2arhYKSDNsafO9xGNYZC9Zx74
 qByrQnDk
 opDu9AJhNQZ81xLreWnjxCZmSFGPQpZD/gzT3PtUnP3sMOPyTndND9OUtoKIsv17QlfLkL1la6H92Bkxozl7qBADEknObylRk2wycgqEtlxCfQfL1rVCc2GK3W5l9K8MITufGLoWxRd7NfEmA5KV2si4SlKNg+9kyVkMFa0Wf8jMy4G/gXlRwFLVFP1eJ0rqGxgEfVWeOIuHWbQQpsdco9NnAjcuF/wj3lxxfzWTLl0wb8/TsCQpcYvA9/8pFeqV37oFyCP5By5l58+GMWJCCVN4qPUKeG3di/0ZNJY2RgRkd45Zy+mq8wBpZrlUHicF4ENsNAz7/emwXWspjFw/6G2K69IhXI8AiayEGfJQkYXfRTVxmBq0g8l+9XyPdTDDkq0E8OnTl4u+4hbrifv5FfiLjQJD/HD7NwLSilAN1NjeDXok+jgleu1oFJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Sep 2025, Baolin Wang wrote:
> On 2025/9/13 00:13, Shakeel Butt wrote:
> > On Fri, Sep 12, 2025 at 11:45:07AM +0800, Baolin Wang wrote:
> >> Currently, we no longer attempt to write back filesystem folios in
> >> pageout(),
> >> and only tmpfs/shmem folios and anonymous swapcache folios can be written
> >> back.
> >> Moreover, tmpfs/shmem and swapcache folios do not use the PG_private flag,
> >> which means no fs-private private data is used. Therefore, we can remove
> >> the
> >> redundant folio_test_private() checks and related buffer_head release
> >> logic.
> >>
> >> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> ---
> >>   mm/vmscan.c | 16 +---------------
> >>   1 file changed, 1 insertion(+), 15 deletions(-)
> >>
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index f1fc36729ddd..8056fccb9cc4 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, struct
> >> address_space *mapping,
> >>     * swap_backing_dev_info is bust: it doesn't reflect the
> >>     * congestion state of the swapdevs.  Easy to fix, if needed.
> >>     */
> >> -	if (!is_page_cache_freeable(folio))
> >> +	if (!is_page_cache_freeable(folio) || !mapping)
> >>   		return PAGE_KEEP;
> >> -	if (!mapping) {
> >> -		/*
> >> -		 * Some data journaling orphaned folios can have
> >> -		 * folio->mapping == NULL while being dirty with clean
> >> buffers.
> >> -		 */
> > 
> > Can this case not happen anymore and try_to_free_buffers is not needed?
> 
> For dirty file folios, pageout() will return PAGE_KEEP and put them back on
> the LRU list. So even if mapping = NULL, background workers for writeback will
> continue to handle them, rather than in shrink_folio_list().

You've persuaded everyone else, but I'm still not convinced:
what are those "background workers for writeback",
that manage to work on orphaned folios with NULL mapping?

I think *this* is the place which deals with that case, and you're
now proposing to remove it (and returning PAGE_KEEP not PAGE_CLEAN,
so it misses the filemap_release_folio() below the switch(pageout())).

There's even a comment over in migrate_folio_unmap():
"Everywhere else except page reclaim, the page is invisible to the vm".

And your argument that the code *afterwards* rejects everything but
shmem or anon, and neither of those would have folio_test_private(),
certainly did not convince me.

Please persuade me.  But I've no evidence that this case does or does
not still arise; and agree that there must be cleaner ways of doing it.

Hugh

> >> -		if (folio_test_private(folio)) {
> >> -			if (try_to_free_buffers(folio)) {
> >> -				folio_clear_dirty(folio);
> >> -				pr_info("%s: orphaned folio\n", __func__);
> >> -				return PAGE_CLEAN;
> >> -			}
> >> -		}
> >> -		return PAGE_KEEP;
> >> -	}
> >>   
> >>    if (!shmem_mapping(mapping) && !folio_test_anon(folio))
> >>   		return PAGE_ACTIVATE;
> >> -- 
> >> 2.43.7

