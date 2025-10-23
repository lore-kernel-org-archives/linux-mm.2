Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259DFCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 18:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CCE48E0008; Thu, 23 Oct 2025 14:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A43D8E0003; Thu, 23 Oct 2025 14:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0E98E0008; Thu, 23 Oct 2025 14:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9868E0003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:49:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF475160C3B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:49:47 +0000 (UTC)
X-FDA: 84030268014.21.4D9EFBB
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 064BFC0008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:49:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hnynzDao;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761245386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nd652PUMtxe+A7zqF5Bu33R+D4iWOSC+2cXUl6RNFw=;
	b=QsKgzaMMgSdhCVpi7uw6RFVoPIzO/30OiKV38wG2ThaRKAG72NpBMMJ328cDOF2k1nAxcx
	j/22eiC3582YnF3DMQ3NrqN7RSVXxKDs8jflSxqDGkLl+cCvaKxG9BI4OUTwtlWmM+tHsc
	uFpiAdEU128Pg0Rzoi6Ae3vasOqIGKs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hnynzDao;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761245386; a=rsa-sha256;
	cv=none;
	b=0Pw/mAl7vWRHZYOgiusanyG0TEqZCM9V0fRkQCWFmmxpG8HXTbNFm+HASt/QWRyxAc0TKc
	v6AxnHgH8Qjh8517tG4rhAhFjzpz9E/SPD9OxpUVDFfShgbHDUut/QlCgx9YTSnB3T0FUB
	IfQZBEjT2G4HMN2bNFGqqOUozYjXEG4=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42421b1514fso828513f8f.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761245384; x=1761850184; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2nd652PUMtxe+A7zqF5Bu33R+D4iWOSC+2cXUl6RNFw=;
        b=hnynzDaoohWc9zhXUEEDcCeeHrs6H3RWbPCVgHvtT+jDcOrghaLGOwg6DRaDA+FsAM
         x0cFmw/k//4oIHrYicRyPZx2cXTbQpovlGYF049e6JUeM8lgx8w/nJbOUhvfR6uAjBZW
         8v628hrmv8f0DfUPbCqkkbBC0O+GSM+Yp1GY2X9a5+GKPlw7n4bbx7/gqdPxu8wsvuLM
         CcLTOQwh3RMlNBU1uEoQpqBeY3a0ZaeNpweDqAOo1qEyh8bYGoWm1s3B4n7Hkd1HQb72
         ZVYtRT72gPg3ryF8XjNvBqh/5HG1tkErqWh5GcIunKVbOq7G2jUXCMT0fgrj75zjvraL
         e61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761245384; x=1761850184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2nd652PUMtxe+A7zqF5Bu33R+D4iWOSC+2cXUl6RNFw=;
        b=YIsSYUxQ7YwlDsaD0kWdsSmfUDTEvUBa2vMPr9ZDLMVYCSW0BflM4qtX5UeuKFpX56
         bcw7PfNFbWEoIkhj5FZGBc+UUEvdtclwZ2jk0WDlMtE9uiRfxHBC7SI6OlxK4G2pQZlh
         WiN6dp0BA7IjEIYItkgCFRZCjBSWMnBDZ2Ops3/mTvS9qXMTHzqC/7Z4WM5NzeINAMr5
         aWpQ6In4x7UKby4tn1+TPX3DMd7PYcgG62KBvcDEs7xlJ5HRSiBYWsVvS+Kg9o39vRLv
         95P/Yr1PQ3SqsYF3HWC9rWffTbZELnVHNPRDHMzXt5oRtw9lu7uAHIrxdguJ6T7CwjNS
         +nVQ==
X-Gm-Message-State: AOJu0YyrJVxHKdyMmPvyxsHd+o9bDe3Q75ZcMqCUiYTaepDspMHJ+wp9
	WaHmeFfVDgkFxO6Qtze5KGaokFcO4gFHbKhkpy8uZh/tNAFPccDUk6dtA3Y3JDSysJFnFj7M5zz
	F/J2tSgOxKMN9PXilP1DXtIKB+WzWDd4=
X-Gm-Gg: ASbGnct0spc6SvIkyyleHkwyseXoFoI1D/CLy32jQL1rPE6mb0vo19eOaWDJh/4o+vP
	iSQMlSM+FHqwfe5bZazrhSmV2S0FRR5IS5enuX1oGqkIFzmVO9sVc/shvgA/LS/okuKsghyTei/
	rrYwxLLAn0J0dlZ+9NE2pa0Z0WEe52d4fjL218iY89ne1hMGdDLs/Oytq2cRdxQF6HY1nt+k4hf
	Z1sfw2Y0sMXlp21914TqfOC7/tmgR51kBRJ/ifUzzolHX3TyD4mo065+iQZVyp2qzDyVNVZZ8PM
	cBCcXFt5XCw=
X-Google-Smtp-Source: AGHT+IEeHRMJWPv3/iVJ9quZ//H+bz+8QmjfPzxud/29WWYKF0dtb/o8Ka+b/OD/RMRH+3FeY1cruqwGT5+h2lnbztU=
X-Received: by 2002:a05:6000:2405:b0:426:d5ac:8660 with SMTP id
 ffacd0b85a97d-42704e0eed1mr18520576f8f.58.1761245384235; Thu, 23 Oct 2025
 11:49:44 -0700 (PDT)
MIME-Version: 1.0
References: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
 <20251024-swap-clean-after-swap-table-p1-v2-5-a709469052e7@tencent.com>
In-Reply-To: <20251024-swap-clean-after-swap-table-p1-v2-5-a709469052e7@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 23 Oct 2025 11:49:32 -0700
X-Gm-Features: AWmQ_bmPTHIQQvWwNe5YWL2_sylNwTUwWHrORzXS9fyw3tv9sd81xVKAoFs0KoI
Message-ID: <CAKEwX=NO3v_rMcjkUHQuL1GjxnNCZPceYrL2Wm1C6WaHrJcM2A@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] mm, swap: remove redundant argument for isolating
 a cluster
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	YoungJun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 064BFC0008
X-Rspamd-Server: rspam03
X-Stat-Signature: z3afewxfmae9ufzkdc87weesth61encs
X-HE-Tag: 1761245385-670568
X-HE-Meta: U2FsdGVkX18sug2dH8E8eU7CuS416TBjoZxx8U78C7GMsOoYb5pKSW1qrq8/Wg2V8xEN77vlRE+w+VvCBAwjBArVmvuHJf3OM8Sv9LHMqT/EJX7RAzMRt5TCoYoz2uiSrz+hTKl2YhKdZaEJchTmaOk4jp+Xmm5nZrJKsrvzbHudbvR/6sdqaJ2GgF4KMBeZZLGlWUqb93auK68uqyveRohNgV5fg+FeWdVoez8JpeqPOSGSE8lWfnnj8YxQpmX5VVD3CEEEDp1U/tBeIqRRvGUg1FnxbyHWbY5P4Gegbl3RnWmZtKUq5KZ4GNZ5r9Kr/B0b1nxSMa4zeggs8yXiawH7fHQwEPc6oWd3pn+vjroSil6uNzt2VhTSIPHPcu/Qeg6reh3o9ueTvEkqM4jeP+7xx7aZ3QmollV9hHCSRhpg4ZFfccu9F0e9wr7mXzN/pxzOhrJ0bs4uFATZmjAhas8JtZ/ZuhfCgqPbNl69mgHf7SUjqEnuSoJ8yU1+p8O41HtUVMc2q9v6PJanwe82tBO0XEgUyivOkudRWoNzRvNsiC1ubhFhbnoQdV/aWdey35nLeFx4P3pE3DQHG2lX2xycrX4jmkQk1SbVTqFuc1O3egUl53YfzdxRmtqnle0K7V/5zTlhCGv03mJ1lpOsDDw3MnTSxWLK+Re55q52UkETWveeGWkL2RF5MQ3RJ71JKjhaZFUVefve+dHkZf0IgSySbLFPgeZY3Po4oTDjGNvbx1qAU65V1+XcqoeNSIx19PsH/amP5TDbQmvyFfn3lRf8tjGDV/0n5liFTP4Yvf1rGcoEU/SwSvLRTytdevY7Y0acQbel+rC17T/DJ3IS+P78OfNccmMcVj0giBZNXYip6EQ8CE13gDjnFUP2yCxVMuc2GH/J2kBSjtpQc2QNW5e+mIEmCM/bsokByKif0f8E+zqREadDt9/Yb/35JoijXDFf0D/Ffrod8Q1Y1WV
 63HcoMaz
 AfIdmzEmUY30/7KOGln0qEoJkO27OQolWicTnK/43bMwu7IX7b62phDmtBqAFUTEL3EAXNsmbabb9jdgTRNGgvIgFpEREKnW3KWgZ8GaG86JnW5jbBz8JNgWjEOGXfsWM4eED3k4bpCCKacEW3YU5/6bKcynPWOK9/3JuYQgMiRCvg0eNKpBRBl2xdwb62ZRssYkIH4VSn0lCE39onF/0t0WrTm69MvXhMzAlHLCFNKjpfzc+AuiIwGmlGgoOMOUFOls90LXIdFpRbnvStAxv7kjGUcFNu7tWozuwlIMCTwX29DU6ykWoeHvi8sOnv0qcSPX5MsQWiHM4ztAhWj4wDEYt0qFYiqiXq08vxXZzm5sYPVkt4cWudfn8ohOD0W33JVkLL8h73gAfOZVp7Wco34ewYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 11:02=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> The order argument was introduced by an intermediate commit and was then
> never used, just remove it.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

