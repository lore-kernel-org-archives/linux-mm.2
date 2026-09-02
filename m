Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE9BC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DAE36B00D0; Wed,  2 Sep 2026 11:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3426B00D1; Wed,  2 Sep 2026 11:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6896B00D3; Wed,  2 Sep 2026 11:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1CE66B00D0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:49:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56075A38FF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:49:56 +0000 (UTC)
X-FDA: 85169257992.04.0D89420
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 87EC5100005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:49:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YPPkja5R;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788364194;
	b=gGITXrznfo6V/S6udJY8996AtyYaOuPePjRMKlu7x/6xS0WyxCF12HZDXS02Nq8CsxLprV
	PRUUjphohG/Q+3MsDOinMciLsBjg7kc9m/Q7R4NxbYwMDCFt4i4cP/jOjM/RoHfrHkmdx6
	XpJEO5YUKSx0kdpO0T0MpAl+iiM2sq8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YPPkja5R;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788364194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z89yPC+uk4DMPmL1ApFKYR0uaTYQLE6V3binhup5tUc=;
	b=SCTcJhfW5806Atu0dbnFoRF6fvM3W0y+nqZFgkYyswaMH7WZnohDxt7mvwXEYmclAl3STC
	yuog9EbGfGn2BcmxdZafZcU/pS+a/YHShsQyPPcsKhS8WJQIK11t+AzxXgBFJTGs8IWU8D
	6SyiLaBIpMPH/4BALjDP9AyK5CPHnTQ=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cbe827e3cb4so1543268a12.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 08:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788364193; x=1788968993; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z89yPC+uk4DMPmL1ApFKYR0uaTYQLE6V3binhup5tUc=;
        b=YPPkja5R1VDcIMpVHTn4EyZNRga+PQPO3BvtJ4IYIJDEI4EG7Y2+wvg3u266nieVi8
         Nrs/2sTTr7nxxvSkDmi4pj9r5ihHnH15PItX/MK5FXSSGi0sgG+uB2fP+g5r+FjQgX7t
         If7RKaQMh7/WVR64Q0OZTg5ghg5d9yV9HzRsQvvLVUAnn8kwu+6Yf6iYqhx4geagTI8K
         76SHxBMTBektAp6nkaTQh7Di7kxdTt/pJbUjsqgpLrDKaRwz+qAz7RB/jaGwYmK9zsJG
         o9FpSoxfHIXItIFegLK8cAMxwsAsFa5jE4SCoSo7y2t9zFMxTn5AOGhrBmzmVdFslDG2
         dV2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788364193; x=1788968993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z89yPC+uk4DMPmL1ApFKYR0uaTYQLE6V3binhup5tUc=;
        b=Gxpc5rf1/IcQP9MBDIQm3ZREgfRai2gFxyp00BXCv8n9eBaonhMTS6rL0FK91nrYxW
         DwwFMVvym2tvrCyXbeTiMc3FLXN0KHZU46h5UkagR6KQ45yucmyYsbOSF0NYnq1qk+eF
         faqwJM+9SrgL44hMdJZTOAbpJL9NFSnFpgtLrw9b41QPo7S1Cko316kIPLiKj4yjwRp8
         qqgMCV6Q1VMZe0aQ+Vz9DWHM1fozJwGKZ7wZfhaa2XKoABV3BCVTr3jc/+058DzPmtzI
         A6X/IUDHokxHFNqXr4yVP2Q27s+OTaFnRgDO7AJi0ORcRniFr9tezqXLMx3LITC9Ux8w
         aj+A==
X-Forwarded-Encrypted: i=1; AKwUvBxG54E4+ThJ624Zhcxc0Gr4hMOV7Hqka4GEj7VDfCwIAla3IYrEBUZ51FMizgqesrFr/37G+RIdDQ==@kvack.org
X-Gm-Message-State: AFuF++mFn4Yg23SVQ1iWK2dYJCB4ekp/Q0b3hPC9KC79mHS66SVtEyi0
	XrEv3zoXhnBzDTTq5vyxKCgX3d/jCZGrexS9QjnWlrcL49gQQh0JOZQ2
X-Gm-Gg: AYBFou1w57S1mcw7C0uUNukjz1cSdfFLiMZ93KNwWiOxXkcCakOon9axf/PgvLHJaBl
	PID/zeZf5H9W8TJYp3QHML6ltPrAbFpYd4eVQNQSr6GiUR0fHUchA/5nCi60lHyCLMGM7Iyi9E0
	yZ0Xy5DPjAPzMm49KWkhBJNqYBTmqXwV7X3C72fsT8McTEjKETBDw7GggM/P6KRJhM8heWaKvdJ
	uH3YDwudl+k7MLglvb8l+3Pdj2PgS8s2kQoGw8iiLbrSFwfNzLp3wmzuPB/RAJDpjW5LS9G5E60
	pYyiCyJhEEYaVOw0wjibmO/qpoLG17G82EFxViNGZBezoH44EuWXGkE3aEIrmUU5PuNX2500Sq2
	ddv5UNeIKvs3pTyzze9NgGG3XY8DTPH50SWP2jVVUR+fwVQ2xoGJz9qcgLd2Wg3cMtc8d0nSdXI
	nKftrGO0VY6+BVEQFl459+U+RKjJNvS67beBkAnkQ+Z47tjAM7KxgnvO4PjUQ=
X-Received: by 2002:a17:90b:57eb:b0:393:19a3:4f1 with SMTP id 98e67ed59e1d1-39aedfcc06amr9073487a91.6.1788364193126;
        Wed, 02 Sep 2026 08:49:53 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08300ba2sm81417a91.1.2026.09.02.08.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 08:49:52 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 09/12] mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
Date: Wed,  2 Sep 2026 23:49:42 +0800
Message-ID: <20260902154944.4035059-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902151955.88892-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8anwesiiex3d8d7819phcd5ytew3t4w4
X-Rspamd-Queue-Id: 87EC5100005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788364194-643934
X-HE-Meta: U2FsdGVkX18OLv1IVJtAQoev7gbvXKPfhO//1PdB8Q5JmMMs/sTJTbEgD27VbppwZ7J3/kSsk3EIFPdRbFVBN5ntLWLE4WOLoT92mobGJD+XIxhCr2g1pawj9ONPtBAc7Boh7ao5CjfiBU/u4atBHeD4iUtDe4lJMLARGeArIvjT3Gbu/Udd4k7MhWnVjun4jd9E2towzhe7zE+leGmEsv09a6+siq2hpUebbIJcepivgPdxPVCVqYickL0S1RMI8ZQAwMCqYMpgtUfLSifie9DCcxVXPeGOVTwIzuCneHKXMXgXF9jo5UyFJyflv7tI1Y0Rsne3318NJLY6IgJUbg9dGCwg8Z9r/ftWnz5wQooZivtH4k6xBg1QGiFOBdfs5f45yxyYhjTb96wS46P5Vbpbo9fsTznTW4xq0TMpvs88inWXO/roeEUHSX/M/8LLla21QOSqQR+r9LC2ernWf6NHad96Wij6qk5T4GtQo0AQxe4D3BBmEFnXIcVMIQzukShJnCHZW/2wNRiYBlL6d99Mq3I5xfzuxWiAyHXgVpd8c9t4vk3nL8niSCoQFoO3eStXEDFZWcN7bFhLP2m3xpNsDzMz3AmoJa/1PU9izcD870GBkn0pLpEKKnjEhF1inp42VPZcaG9CKza9lBQvI6m3BkF1+UZkhxwhb9t0uGzL6L+qlKOMBfLaorbsqlDC94t42wL8wyIdSHv5rFZVtfYC/zhte+M+ATqOtukabuIxPgufXO0uvfvL7C5zUyenM0fFb+9aV89GKrMHHaW4BTLMVZAdi7TKb44S98EkuM9rhwnd+RFu9RMDgvfkKKGdIr82BM5MYSR5x2O6BcdX24PZEPk6BV4ImiYqBcAG/isjCwdZhfuwCcTV+aSR8V7d/O4INCYvAtxCdOwyqIi8fzoxYNnlc4eEzMt2ZGgssTjrCHSSGTACs/1GuwfHr/FGMGzTKbmfEl/ERWtdw+r
 hWKkuUE8
 8i0QC2me2eQarpLueJGvmgwKSl+5F18VTPRFf1dqT9lYJGsK/cOhvPVFq53NVtUgF5K1lpCuzlDNOgil8T4SN6B1PIdANxulhoWuVuS7f9mRxgcbBNsA+S0EBAiziukWlAVKdSNtAabQ1jTNACMgeYpXt8jI6HOb86rAr2KF96E4t30mxPv5Doui7bgD7cUuyF5b5ygKfIB1dN2kgTNIuqgQiODNhjJCqAxmJRU/VF3D2+s7WBA/jPVp9cfMQY9mQmoyFwlwj/jpW+3UsIeEKktZQOHKOQaX6CIPOu/6fl1Y9lt5AIGhOgnUPCTT3KLbBdGOkUtF65m7IrfV7VKFMXvltR5xW6jFUcywYstASBmJD0JuI6vsaKDZrOrjtHCycFw2Zf6y0pjNg6ZdVbaQxSIohRLHbo7es69bDzWfEKF7xsBGtgLSNYepKGHxlyhRrYjwkogG3PRMm0IqMxCkPNcaYQ4KtiERY/J8ZeyXZ8Q5dqisxDL4erf5Klg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 08:19:54 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed,  2 Sep 2026 23:08:41 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:
> 
> > On Tue,  1 Sep 2026 22:47:42 -0700 SJ Park <sj@kernel.org> wrote:
> [...]
> > Both `sample_interval` and `aggr_interval` are zero here.  Since
> > `sample_interval` is the denominator in `damon_nr_samples_per_aggr()`,
> > would it be better to keep `aggr_interval` non-zero when testing the
> > zero `sample_interval` case?
> > 
> > This would make the test explicitly cover the divide-by-zero protection.
> > If the `aggr_interval == 0` behavior is also worth covering, perhaps it
> > could be tested separately.
> 
> Thank you for your review and question, Kunwu!
> 
> Yes, that kind of additional test case would be nice.  Please feel free to post
> a patch if you'd like to! :)  And no pressure, no rush.  I will also consider
> doing it myself if it seems you are not interested.

Thanks for the feedback, SJ!

I will prepare a small follow-up patch for this test
clarity improvement.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

> 
> 
> Thanks,
> SJ
> 
> [...]
> 

Sent using hkml (https://github.com/sjp38/hackermail)

