Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99946606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 02:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rYHGkt++
Received: by kanga.kvack.org (Postfix)
	id A64766B05B2; Wed,  4 Nov 2026 21:00:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14316B05B5; Wed,  4 Nov 2026 21:00:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903C66B05B6; Wed,  4 Nov 2026 21:00:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 677B96B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:00:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8FCD1A094B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:00:52 +0000 (UTC)
X-FDA: 85399411944.08.1ADDBFF
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 059061C000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:00:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rYHGkt++;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793844051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2tqjA76vRfCUQoWeCH/paZIcbbeFKw2hvgd2Oi1xO5A=;
	b=DMTatu3TVDYekW1SGi2B7xjshvoVVS7i9AwUf/z8Dh2RY0YvWw6zKqrmkwl9yC0bYh4NcJ
	p/ZE31g3TvcxP6PJ3mW7VQKVJ6SzfBAevX4SfolLpBYzlRVig3Dw2Brff6CiAj+3JatI9U
	M3EYskxqJsK5AFlLKpY4cvCkKt1Fwyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793844051;
	b=s11g5fdmDqs/u5EwPWiPAwxE2gPZsOLS096lKudjfzv3HPDxYLOdxw8xbr+e6wZCmdLdnN
	FyZfjYoxJtViw2xutQ0LVU+WvvuwzGDjP6Dta2bNzJZTxz6oy/7Xmsm4f+3QttaFq3MLKs
	mPHNimyTBiic+VL4NGkv3VJlS/YhwhY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rYHGkt++;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e946155442so12093955ad.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 18:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793844050; x=1794448850; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2tqjA76vRfCUQoWeCH/paZIcbbeFKw2hvgd2Oi1xO5A=;
        b=rYHGkt++H8eT3Z0HeUgqm9FhHnsbIfn8HlzL6hOX04RiDs9DeTVDFF3WnR82R/4p4j
         cDA2CkF3gtcGLAdfhAg15IHyMfpxQU2+z0+1jyDdsVOYM/h6Od6WqWDEAcsOI6EpVi8C
         9zelKm8nB8d3O/K8i3mZS5IGJ4EFsjzdJU1I/rgYUoQxdZqBvC+9KhB+C8jfvtGOM2j7
         bV88bgNaYDVwqPo1Yt5bGuDmDIvpDNdCatxMRBSV7yF3niU4YUDLV7O+G2kJ56fm8AvV
         9GruEwGABvPVQHPaUH/uuR1k5g9f6ZG86sF1OQZ5OQZT20uEp85tlJ8xxF8DAx7ZPQSN
         KLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793844050; x=1794448850;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2tqjA76vRfCUQoWeCH/paZIcbbeFKw2hvgd2Oi1xO5A=;
        b=wchCzrxaVs9MHxwagyZI48+GeDk13IdUDAuQfl9zaPI1IlMjG5guU9ZcaAXhKJnRET
         C67OONfOc2Hcsu1HSXuRLZRRI8rq8p3C15Ea7pP349AtJa3px1dsfVEHxAX2XXJk46D/
         IHyL9F3QiwbGtSAEQaMeMGkj2maNXZbrlpcqDDqRFcZYATdhKzVLT0RE0jq8IM11Ct5T
         TUDgn4FiRJFj//+vUuDi2S6cCwv9++SnMooMPOz9IVtZSrj9oZD2LEwsHeMe+IEKCAzM
         bMkmWWYqGDdcASkLvEcTOIBmfVP6q5R4+Z8PMAFfuyxHVfYtzJTAxo12xpC0elD2OB+G
         QBnA==
X-Forwarded-Encrypted: i=1; AKwUvBymnTsxP1AnKGsVcIGvq65RJicglV8i2K3rw4ufSrv8iqFOgk4wRqxWA29vBj+XQsCUI36rOxj0EQ==@kvack.org
X-Gm-Message-State: APuU4Z943oInrIN32mTTmP5bNCVMQk4iSQIpbqb8yH2sFaHCtGNM09jS
	ImokXwFJpSP730uLcBgwzXpl5jL+0L6wfH7JXd4dNgMVKy0Ef6CJQWBk
X-Gm-Gg: AYBFou0AUK8BeCu3AmyJWPY2HSjRLcx3jus2O7R7mjn0mvHvbzu0r+jO0Fkwj5oP8aZ
	UB3NyfKEpSYKEjHiYXqdyMf3asXVErTsDMjiq3oeWKSptLl42ew6HwSYvyZEvFVRT3o4jspnM9l
	9PijeX/i+77YAr1kVYw7YcDMVzkmuhRVWCeaphv76vbFWkkbfJ+FXNAegzAd/G7T5AnrBdqfbvh
	ckJnTC2DZ0NyTamaAkptoN5kbBfB5dvOBl/Mr//wM8zFJWuUlyYnHvD+GjvP1f1Opa7XICZoOc+
	ERyhAzD9dDgYgpFxlX/4BNSu+u1fMv37To9x063jVKYGIveFhNgoS1/vyiXvF4duXhA+EJdNj5f
	83E7ue7VbPd20Fa/IUNrN21QCbuuPly/g0kfQEaKyhyJH/2MJjpgpXdG0vV029qPbcddeW12NX8
	kXsNDsHDgFg6B19TEF/H0DrVlx+VeHNFWudW7qcEIobfG5+zXdDw6iHpz97NjH7Ml5CZfb0q0G7
	5z9TYc6kt+mgFkC3vZu/XbLtZLoyHaFcYUpuU0VBqzpHgJsOSajVJGVdorIMk9qyAj4eVeNZnhA
	DlY2cb9bzQAsHt1l/8Q+xB7BeJOo+pPoiZ21ugwCVZ/30VpCq9QShhjyEPvUawpE0FToP+oWEQ=
	=
X-Received: by 2002:a17:902:d58e:b0:2e9:776f:66b4 with SMTP id d9443c01a7336-2ed2d9781cbmr853015ad.44.1793844049572;
        Wed, 04 Nov 2026 18:00:49 -0800 (PST)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed090fadcesm12330035ad.46.2026.11.04.18.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 18:00:43 -0800 (PST)
Date: Thu, 5 Nov 2026 10:00:36 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <baohua@kernel.org>, ehab.ababneh@intel.com
Cc: sashiko-bot@kernel.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	kasong@tencent.com, lance.yang@linux.dev, linux-mm@kvack.org, qi.zheng@linux.dev, 
	sashiko-reviews@lists.linux.dev, shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, 
	yuzhao@google.com
Subject: Re: [PATCH] mm/mglru: fix using folio_mark_accessed to replace
 folio_set_active
Message-ID: <auviWipVDTh_yk_T@KASONG-MC4>
References: <sashiko-outbox-175822@kernel.org>
 <20261018064458.86435-1-baohua@kernel.org>
 <CAGsJ_4zY5PrYgbFvY96R+52Tftp_eVrMkSbf_-2b3Tw0r6FgBw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zY5PrYgbFvY96R+52Tftp_eVrMkSbf_-2b3Tw0r6FgBw@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: j41hcw4fis8sy3u9b8znup6ajfmtg5c8
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 059061C000B
X-Rspam-User: 
X-HE-Tag: 1793844050-878919
X-HE-Meta: U2FsdGVkX18GHOywsB3EabIJV3TtahKmoDLF3MNzwqM44BVk8l9E/iKUED2hxO8okcxnddS5oT7mJ6TrF0DPxtBV+NKwuw8Htki43t9gzGuSWdLu4w27pHJGCdGxjcVo0i7ymBgKtoh2uiaaOX25gniMnfXz74hMUDSBUcDA4YN33wYnPZ9gfWvEwuR8iEpCYp3lYM3HYSLztM79gPaQZ5m395/1jEJFlAJtE9dUmCPbsFIw0n+5hoivBZ7qfaNDSbvKh/WJK6bw+lvY3LHwJ0+WyCD7doigLg6NOjHQ5Sdjib63XYSdcaKe4AFbvVSe/hyO6bmp8ZVNnc492G9LyYu3V+ghl12XHutrDgsg3imAQPW6LcVGGdWPiTALvCE3Qy8B/RhXm1yzEDJwXqWkd8ifedSar+gx9vTzJ5K3l3tnw0n4X2fXGutq7pf+JknUIcsJMNe6H9BI2ARSkPnK1TE1+LKkgDhLShD9Ywh8+hmUY4mAiWz8xPCwy9H5wgmNADdK5RLOim40TX/ExcXz6uOPaffnEEWM17nhNhiR7yw3rZDIUVpawpDQlIG+7O5z84qlmTy6pvnTsCimDYee5ndKQPXv6ruT456WqYd8UX77k11/g6Uvn6ua56Bxyi9XdQp56fGvI6M1Z+4Nydi+kxnkK9TDi4pnjWN0v6fNvkIDV19ie8QKhzr3U9PAlYtnOu1trnunprWY59IUBgpNJ24F31JFCcxMT+R1hRbbLZopp2rwqfPs2vKxzH3mclannYOw6QO/WFQE0O/u6Sv15pNZt++kBFzx3NivtuPLhiL02cEUfur+GeRJ/Rnb+KHTdnQPg1OkWoXD6lS/k80w3Tgzcsngz4GJMSMyjbj+kWw4uq52JdQTFOYUzbXJKGmMLZnN/NSDM4SE+afGnprq8sI/7qxOABcL2q56x6WBykPEWBknJPwGul8a1Avm/je7r0C3ZX2D/cyEYfoEMbU
 dMhR0oFx
 KKd08GwkK/fLBXKUplpJsraTFw/5pNyck5LCHZONwCW7f3GNvxbZcCxtJyY5dESmhcYEhuNK15jww/uiHRRsoXSOmlfPAOwJh4YD39HOOPR+B28q3pjZIs+MSrCKNixYYutzLknVJyFN4TWwYYMQ1n7D+KZOCdHjkMDkux4oW3ltua9HVMvIj8L8CCjDTr3YG+LYLB3XH1HSyQhoeWyVzlpfy/rk9SbinFRUxxbKY8HK/R4g8Uvliu3nxFki+Lxl8Y7NpOrwX7RjYAXby2n+REdBDB7vVS52NJay3NYUjwcz8RV2mF7vu5WH5XroVViCJhbJzmNYENxaCPhc8UkyW9wq4El6yfYm6U1zJSuPAaAxypTGaPCpbHQQDe95g+aqUtrzVaSNMra1cMOZM6RvaW5tQ6UgeENFRyOmXJ+6mwFTijJ7MQa9y6C30i81gRB/uvbeJcSVTr9JpTqhPGHVK6bdFax7vvUExdhoKFSeONxAZ0CpAHDxeaKm0Q0sa8PUNC1eRRDD9ln2MPurvnR1vuRBkbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 06:57:09AM +0800, Barry Song wrote:
> On Sun, Oct 18, 2026 at 2:45 PM Barry Song (Xiaomi) <baohua@kernel.org> wrote:
> [...]
> >
> > Thanks. I guess the real problem is that we have no reliable way to
> > identify whether a folio comes from in-fault readahead. I've tried
> > various combinations of PG_ flags, but none of them works. So the
> > only solution seems to be separate LRU-add callbacks for readahead
> > file folios and other folios.
> >
> > I've drafted a version below, but it's pretty ugly and feels like
> > using a sledgehammer to crack a nut for a quick fix — simply not
> > worth it. Maybe the best approach is to revert 6cbdd9726fb5 and
> > leave the proper fix to Kairui's MGLRU-FG.
> >
> 
> Before reverting the patch (and regressing workloads such as kernel builds),
> I tried the following two options:
> 
> 1. Remove folio_test_referenced() as PG_referenced might interfere with syscall.
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..e231e56f0257 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -327,7 +327,7 @@ static inline unsigned long
> lru_gen_folio_seq(const struct lruvec *lruvec,
>                   (folio_test_dirty(folio) || folio_test_writeback(folio))))
>                 gen = MIN_NR_GENS;
>         else
> -               gen = MAX_NR_GENS - (folio_test_workingset(folio) ||
> folio_test_referenced(folio));
> +               gen = MAX_NR_GENS - folio_test_workingset(folio);
> 
>         return max(READ_ONCE(lrugen->max_seq) - gen + 1,
> READ_ONCE(lrugen->min_seq[type]));
>  }
> 
> 2. changing to > 1 for folio_lru_refs() to reduce the syscall
> ra/non-ra interference:
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..a3a894aae10b 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -327,7 +327,7 @@ static inline unsigned long
> lru_gen_folio_seq(const struct lruvec *lruvec,
>                   (folio_test_dirty(folio) || folio_test_writeback(folio))))
>                 gen = MIN_NR_GENS;
>         else
> -               gen = MAX_NR_GENS - (folio_test_workingset(folio) ||
> folio_test_referenced(folio));
> +               gen = MAX_NR_GENS - (folio_test_workingset(folio) ||
> folio_lru_refs(folio) > 1);
> 
>         return max(READ_ONCE(lrugen->max_seq) - gen + 1,
> READ_ONCE(lrugen->min_seq[type]));
>  }
> 
> In both cases, kernel build performance holds up. Reverting the
> patch would regress system time from 3m40s to 4m4s.
> 
> I believe either option would eliminate or reduce interference
> with syscalls that use PG_referenced.
> 
> All we need is to give in-fault folios slightly higher
> priority through folio_mark_accessed(folio). I now realize
> the original patch might have gone a bit too far with
> || folio_test_referenced(folio).
> 
> I will wait for Ehab's and Kairui's testing results on these options.

Hello, Enab and Barry,

I can confirm folio_lru_refs(folio) > 1 works for me, the LevelDB test
basically aligned with pre 6cbdd9726fb5, the same for some other DB
that had regressions.

And any update from Enab?  Given the fact that Enab's regression is
also caused by that incidental bias, perhaps we can go forward with
this path? I'm looking forward to rebase MGLRU-FG on top of this.

Thanks!

