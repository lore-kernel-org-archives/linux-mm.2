Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABF65FF512F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 00:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7F536B0088; Tue,  7 Apr 2026 20:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30516B0089; Tue,  7 Apr 2026 20:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F956B008A; Tue,  7 Apr 2026 20:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD1276B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 20:41:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73AFB1409CC
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:41:39 +0000 (UTC)
X-FDA: 84633535518.27.07E3695
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5A5C240012
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:41:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TbFrdYSZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775608897; a=rsa-sha256;
	cv=pass;
	b=hR9nZToL4O/elw5Mv1VSaYk9wJ6CYT0IQesHj8/GQFIb3yIrjaBXw+hP3mcjvRmfc4P7jG
	S6bxKWw9btphfSWpr15mwRSFPxOk35FrHlPLNKjVkAccle/pxY1BHIlFDgC99RsKAaeTuH
	l9JbJt2PXlW7fRQCGf6g47PN9I+/yFw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TbFrdYSZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775608897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLZuonShLh1lz/eJKBt9cQQcwUX+NOfVWyR7MbWH85s=;
	b=jgrYGlhgeD6zdHnou2OI4Csjw0aZpVviKoLW43+WVeWj6VSZyGOtVJdI/zabx0VToUPKte
	dmatIoX+0V9SA+YG+evpDGzV8j7MpJu7IH8VACqTRMb9hcs0x8fosl1qiFSWzGugJxHwW7
	oZSMN0WDnRIQ1vK5ekcLMm98EsSQTRc=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a3d2824e4bso4689190e87.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 17:41:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775608895; cv=none;
        d=google.com; s=arc-20240605;
        b=UMRRibahAlA+KpsVSZodUABhyBSxyo7hFdjBulRa1i46iCDZgxApqRp9Il7pQbe5X/
         BbMyuE8wpl3hEPkH59DyRisfcLQiWQEeWQd1x5BuTTYwERTylq1B63dm16mxl9rvNV88
         PCWTNameaeMnaGJ0RSEa7K9+GNKgmv6osS9Ussv5hMUyOCVS15JrNuo2c2UdIsC9586J
         5EyX3yjykXvW+C/pTPgS3CFoNgN7F+iNebSAKX2YWEDLn2+Cq0bWRUIZ1cH4SZfqkUgX
         avA9YU5Rt2qqyCBgt07rTmWATz2oTiDwAmnrAC6KTNh9t0pg2dRiz8YgJBqpgobqR4jF
         4qNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lLZuonShLh1lz/eJKBt9cQQcwUX+NOfVWyR7MbWH85s=;
        fh=wfq/3fI9hX61lyfTedxRjO9iZAFqGoMGugDW7cEjeBQ=;
        b=aNnFU92rX3ZlMds7X1dH9JTVDC9E0ewQHqIgu671DuRZ/PU+JPUq5WQdCvbjKprhr0
         y+44+F8TuyHbXjovWXSOkkT1MH0RIerBN//HeVOFgSi21wSTdOV6Li/T05zziQgUAWfu
         rD5IBwiW8Rc5WtoX+QDW/3fSWlFrR7PStzsdM4HGQ2IG+w3aCkP0zjFKSLfzakWB2lgs
         mqRN8g/HB5y9JwjlXoI9joBB+FtzurioOfBgJ0KLXs6WGa/3CHNf2Fl9S+e/2vXBxV3u
         XZDx7DBUzqFfB2yCE6Tj9dZtx/uQxSm+a+1YNooWRWqlk3Ktwwxyy7MoE+NnLVFtRE4+
         pZ+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775608895; x=1776213695; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLZuonShLh1lz/eJKBt9cQQcwUX+NOfVWyR7MbWH85s=;
        b=TbFrdYSZZHpZd3ra2jvGEWpgTW/FIplWGApjhlJoU0NcTmrvF8FZNBh9AuQwWojSkS
         0NEmx5QOfNxLLaA1B/hICmYFG1fT23oVgwvosDN5ksDtmoty5SCRI2szZoK8zsyXfG4C
         1vjY0X4CgeXLexeuI97o3aRO10B5WQsGbgxicTpE2cRGuMyZFamdmlNYTI/mQqn56WcR
         hqyRiHFiKyyScfKazTN3nFag4mSYFxhZf72gc9R/jiBX03nlUrVY9cCT0tlMXx/JFCoq
         mKDV9WULGzSGOjvFn0i8qdDi/Y+iFE1mS3bZCf0rSUlpun1tUnyf9yXmHOWM60pp651P
         o1vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775608895; x=1776213695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lLZuonShLh1lz/eJKBt9cQQcwUX+NOfVWyR7MbWH85s=;
        b=DmliqIJHxpgnQPTpqmN8EBGMk1Ft95dnAQTUI+A+RV/USvBAKvM8DH9zXif8lcGc88
         wK6AkcdoO5E8AsuD3z/rs6hV2tldvNB4rrPf+oPRcEap5njqwaYnqGeTilcotJmRuLDb
         KG/pQbqMiB0SsP2HT8/B/3RjkmtbLh4Y6kR4osq5JuuP0nDPGLLPOeykb1Ovdhn2LUS8
         MF8DrAHI+4FfU6KCLRzY8/7qm1HqwnvnOLBzJfOJ8cFXw7hiupEbWUOzdSwPdZniOfv7
         r3BFy7zx2hUm3KoHnV1yekPtQpTivAopwrkff/aTDpbXA885YyeKvkc8++K/4SuBBB3m
         cIzQ==
X-Gm-Message-State: AOJu0YxMlm0nTbe/n95O7p8LD2ueEUQFLdXQKQwk3GsELOnzLkD7HV3t
	+9Glf/a5cIAWIv5T+HS+GKfjm9aCuEGVM7kk8RKEkm96AnOEQn1FIf/p7SPdasQ07epJdpfiobr
	Qe7fkmhhP71F1RTdsC2cbLI7iOtRi0JE=
X-Gm-Gg: AeBDiev/EDSShmoUQugOedvIoPLZLrAKgD/VZ2OSBExHlPFc358aATc5M+FaieSiYzV
	Bcia+CPWcDqGHDAdwLRfCimdxk3dC1kPtBrg2u8GBNz2yFq+UCTnRIaBHdvIRSzj8MW9Z3/NEci
	8p78/a2DFNjjCzwbm4BNF+o/e8EQ/r+5/7Z52etwE9dcsgGt/KhYzwW7dPQ6kvASqvOX1xi59XS
	lnIO/qc4HVDjVrMVUXNcDsBQKiTAJDwyQ3aBwfsQbvxNuPB7PAkJ783IRgXcgUE5S6dHbbS7KAc
	TyB5
X-Received: by 2002:a05:6512:3b1f:b0:5a1:3bfd:b87b with SMTP id
 2adb3069b0e04-5a337588a0emr5759803e87.30.1775608895144; Tue, 07 Apr 2026
 17:41:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260407110002.204755-1-wujianyue000@gmail.com> <adUTC-7iyOAUlhR7@cmpxchg.org>
In-Reply-To: <adUTC-7iyOAUlhR7@cmpxchg.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 8 Apr 2026 08:41:23 +0800
X-Gm-Features: AQROBzBImcVczlFix289RYmnAc7HOw2II6M6q97j5mTReWmSsdDBZMDRyjqgaNk
Message-ID: <CAJxJ_jjJtpJJrSA39E1La7qcBE1QMx_Eb1FNwEgy7u0=M6X0-w@mail.gmail.com>
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
	mhocko@suse.com, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org, 
	bhe@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1njtw41zijpygwqg8yjdcyigugww8iwb
X-Rspamd-Queue-Id: 5A5C240012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775608897-592445
X-HE-Meta: U2FsdGVkX19p9nRHIQ+IjcyG91uTXYyuL5t320OsAoQXzQ4uXOdr+J24phtj0/eltM6MhAxYyBE9TvCFg5DUJzkeFkOxchuuw2w7tan0ctwgZdUXgv0eQmmD/15eRY3MbOh3nPZbL8xiztx2nRjKye249vtNU37meUGaGYh3FVuXBNIGIJw92KvOBzSdGWG9a8UYEhK40L4a76kPd5RxpsHJS16jaA+j3gwjTkha4HEyNnfUCsn/S+EvQA5Czoor5RQOLzfC91j3M8yQvtl/O18CfqebvHjJocyuhdeaHXy7CyZm4F8jch4uQBgw903FERSib9jXY8Rzh+eOhC7Cc3/IIfFT0l1aMcMVLyNuOWj6HSM3qXLT7Yl0FjxjfzITY2hgnDIGwQi8IvX2/AA2FnKZwr2w8ASM6lybYPtTWr9E1po50Ob5zinbm/m4hcFtNAYAH2wCHqdz2pf1btSIwokOSEo3OE/UlTrTXi6J/jgqIhnMH2YWCQmYsj7S6TwPv4yOLZU5K5hoWb6XmA9WBPdFE8UcPo2t7oVyhoIUsag+HTf20VU0TFw0qdjoU/50Prx6y3UEnX3crDlN/pWjG58Tl1VyP1v94B1ZuYs+p94NJRTQodgta/6dgkyZtuS4eWZ7n3Ru55SHDgruD6q0JqcMQDZFI5erAc2lEvRuYusMhsV4Rz+GJMbzNs7to90fxDGeAoF9EShZcmdbII1TDNqhFzB5LwALkho+0tAD9vjmDgpGVPcbSeIcJoB1uwiw3w4ujmEPYls+NG7N8VRjEkSQoE8DDfLMpxnygK/XbIRJQbKtFaXqxga0QyRvwHLUk7fmNToKISDImEJVE833LRvPDtu5UgJQ+fuggH+hYbkqBoXjjczcM8EyqHpb1E+WpIBgeTnQVqaFa/Lxb+0nnTCT8LzbXjvpZe6b4qIJEHZeVjcsFq2rrNl7E3oUSsikfXmTWqZH1Sl4aqTDvh7
 SENkVMyn
 3NjJIxgJb/MdwkkIboPBfCmt9DmMVp2UZ5nHcgpEqRXBiyMaJEylKT6BT9s25OA3cLvQuWdgDCRh/kKiNMLLIDJ89aFfuzzyeZrvsB7+cfiTsG+cvJirOlv9XluaabuCWn53t4jjB7bunCA1+HURX6nI0Kk0LvjcfPYRffbIZ/zmkNvoJ8hsTpomav+QH02+GqY2jiAOWIdCBQUaXlDaimZ8mdQ+qKtzEvBQXU6wwkx5sNEyLoaFezRCtDP7u3o1mvbVxuMkUXrWMfRsmGr6jo/QtJ4T14lQ8rR8TqhFlDAp0V/GJtxrSNjCeqc1LQ2b/X4hJyLLReXxkfFMk9RkmFudlPnDmn+2S0iEW+C+oalENUHJQ895lm04qoCFKs/mcSXeorj0wf3WwPv6Jw7k/H+mHXJZfbAUSI7HtL+pBUjjYNFHBZvZ/v1FAYaFL7r2BmzqfrMoLvkFarOF0vlGFB0fCl+fTNUxrOtWononp8zW4E68=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/2026 10:22 PM, Johannes Weiner wrote:
> Ironically, the only thing that doesn't fit in this file is the swap
> stuff. The page_cluster & sysctl should be static in swap_state.c.
>
> The rest seems thematically relatively clean - infrastructure for
> managing folio lifetime. swap.c is not the best name for it, but short
> of finding a very clear improvement I'd just leave it alone.

Thanks everyone for the reviews and the clear feedback.

I=E2=80=99m withdrawing this patch. I understand the concerns about the
relative include path, the limited benefit versus churn/conflicts.
I learned a lot from the discussion, many details in mm parts.

Thanks again for your time.

Best regards,
Jianyue Wu

On Tue, Apr 7, 2026 at 10:22=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Tue, Apr 07, 2026 at 07:00:02PM +0800, Jianyue Wu wrote:
> > All allocated folios are added into lru lists for later reclaim whether
> > they are file or anonymous folios. However those folio lru operation co=
des
> > are put in mm/swap.c which is not so appropriate. Because swap code is
> > only for anonymous folios.
>
> Ironically, the only thing that doesn't fit in this file is the swap
> stuff. The page_cluster & sysctl should be static in swap_state.c.
>
> The rest seems thematically relatively clean - infrastructure for
> managing folio lifetime. swap.c is not the best name for it, but short
> of finding a very clear improvement I'd just leave it alone.

