Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E7DC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 20:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217E36B007B; Fri,  1 Aug 2025 16:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE006B0089; Fri,  1 Aug 2025 16:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103BC6B008A; Fri,  1 Aug 2025 16:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F08886B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:44:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A88231A033A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 20:44:52 +0000 (UTC)
X-FDA: 83729367624.07.DA570E5
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id CCAF22000E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 20:44:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OUcLrcWX;
	spf=pass (imf03.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754081090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQokanDIaeAB/qcCWloa6Wo5lh3IIVCmtWumD0Huw8g=;
	b=HZ50wBTBYx+PulDt5Qrv5w9XuOrThUXDhZcK//G8Xv6/9z2tUw3kG6WrM2saYfwRzRgc8E
	zkp2lnZumTuh95n86i91KUhrXuz/BE+eZtH/0ZMao++0Awwwu7Dawp2LVoNAeouwPqYy7U
	UK6h/pA+uTGFX36oAR1/MK3Q410KvG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754081090; a=rsa-sha256;
	cv=none;
	b=FhWrWpiUsgJy4lBIWVJytHqdDTTNLHJj0foqVVuuixiWRkkFAfpYLEF67f8YPPcdZf8rd5
	bAT9ftm/YZjq9ompd8J2BDaUMoOffSwPHI+Z7c0iZlG8btyMCM1AbcngrHRNq1aGbmilvM
	v00ccHnqhiqsyle1i9OcBMqpQ0+bAps=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OUcLrcWX;
	spf=pass (imf03.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4af14096b9eso2336511cf.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 13:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754081090; x=1754685890; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQokanDIaeAB/qcCWloa6Wo5lh3IIVCmtWumD0Huw8g=;
        b=OUcLrcWXvOYXla00E+MrSkRZj9/f/xFyszifaGfGtcAazaSBPHxy2ZXmXf6vj7vuGs
         UMPZ56xhINr5gHkTYnu5MQzX2sOswLo67S0zDWJXk+W/VNFGUWCvvve3VJ0LloMbiJoJ
         8kSBMQS/EThY0XAqkbRR1FI02EQjHNjf6xJcSr5TDwor36hmoYgGPk7GIzI27a+EZBjW
         +jIzex/4L7NdY0oJjG9PJrO75HT3Tx+FOKorRqjlAHZBE0H8Y6ZrA2I3QMtlqoSAaN1o
         R3+T6AnDzsFxxr/Pod/5ECCzjzh360ap+CZzFxjNf5dGbqWrc1mJOguySa8gbJPpteeL
         94RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754081090; x=1754685890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQokanDIaeAB/qcCWloa6Wo5lh3IIVCmtWumD0Huw8g=;
        b=h/CQegBfEFul4xMkEE1WEtlrz/2azF44IcGi1pX5PsWTKr+6S4VuxciDAdgi6SV/Gw
         3Y20rQQ9U5DQcmYz4lkwGYhdCO2cdMh2BKAdrqF8wBovs2NIjUqQW/HzInQHXDb3eWN3
         wEr0aBETykprgn23N2Q2a4MLUpD0jWR896MXHfV2Bc8Rupp+2rZA8hHqVc7Qd+vgnqLf
         zD//+WjXqn+S7hdqS5BKGshNm1vCxlcSwNy/DIe0nf+BYFmXmBlBR0mjurtDSrOtmkuq
         v/mfhPq9y87adpuye4hBA6nDOlmAiRuB6PBitFgxbSrYAXUD6MgF9jtynu3ogTKoHyt9
         vm+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXo8XP9NQ89rk+6aqeQn4tnFJyhtSePwaQ5GY+RPBlReW4oL5BBDjcY9l/XPH4Rowvb91oxRbIGSg==@kvack.org
X-Gm-Message-State: AOJu0YwgCn7SVM4WexQU13TTesQhRpp/kNKF9HSwe1xmPra5oo5Iw1/o
	8Hvq1Vl9nv316fVvjgFFbtH6ZZiizdBdyMNJPmSa8/9QN3JaBqHR2nJq5ZDoYnsRNP88tXcC59T
	HgI0wxmJvA4/VfrIgMhAa4ZTl5R85aQg=
X-Gm-Gg: ASbGncuneK5k7+YI45w5bM7Hk66ekNyGLPIqUWgLIn3vcolNP2ym6nPCE7Rhw3Rt5Z6
	1K+x+mJy1R1ZqLYdashyLLSQbr6jApGInKHkMOtjSAh3YsactYzfTU/g21LTB/Ma9VnsrooiXLw
	2SNWembSP+hO5YIA2evI6H2AMRWCzapyVwxZI29OVzir7RbX+GridwWWMGz4dJTJs76baW+sx/z
	k2rI6Vp5wP2X4f5NA==
X-Google-Smtp-Source: AGHT+IGGkiWVOP2eW9xtatXxP/oleTW3Uru3b+oV7nB56HJr40rit1lONms2uHURn2u1st5gGNdGreVd4pfLGjVtDkc=
X-Received: by 2002:a05:622a:4292:b0:4ab:66d1:dcdd with SMTP id
 d75a77b69052e-4af10aa84dfmr18917041cf.39.1754081089786; Fri, 01 Aug 2025
 13:44:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250707234606.2300149-1-joannelkoong@gmail.com>
In-Reply-To: <20250707234606.2300149-1-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 1 Aug 2025 13:44:38 -0700
X-Gm-Features: Ac12FXzPiRacLzTH1VBKySCsSuC4Rr1d84DSIiIVoqRk8dcxoWcduN_EowlL3Gg
Message-ID: <CAJnrk1bTNV_uUUfoP9tYjqUVM1JvWwAo1HvVARY8RXPbACHc2A@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] fuse/mm: remove BDI_CAP_WRITEBACK_ACCT
To: miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, david@redhat.com, willy@infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CCAF22000E
X-Stat-Signature: ytojnynw74k8zsthpk4br6npfjoid8js
X-Rspam-User: 
X-HE-Tag: 1754081090-746342
X-HE-Meta: U2FsdGVkX1+GBEPRFdG8XkLQJuiDZ8CUyuhYJQM2uA6jfykYQE4+7+gJnLWcpWqxtprjFs2Uzk6/yFQkfDjuVAsFL+hMF2tTyg317W9egWogXJwi3x5CqksedRM9USOBNmRCznD0mWoW36+JCNGXtpAmdzPaesUc9JmWMhXmX4E1jqTNDZaaB8UkmIg/O+oF+ccWqpNnA081PyBczdDF8Dt40u/RYDIiK18snikDsW6nCZpC/ZWKvD/h+m7JgXCG5ewdoJSB+hd/K1MmKetNb0w+TOXSO/qw4wWoKzKV57YNntK2O/PFpsdA9CZ1gUKN/HUAuYBMdsjDdpIhS6T9oDjnBAx5yJfOXT7yQPK5jbVtnbMOHXw2zli+erkpXkUEZIrZrT1iW08y2NmlEa2ZLOrE6hr5ZWj0Y1ehK7b2J2mjuqIgceLAgefnyXJ6luUl8AI/geVqmVURdc7oXbctGoUxfZ3tHNKkblKD5LEv2/Yaj/b8XDEh2Bp/cEc4BF/4Iz/KC27mvYsREAVe7R+wlu+cnxaMYkmLBAbIEtO4uqzO1jxYThLO0ChroGbWXIj5i27+RvMq6o5ldEmNWaKo1/I+Xpif/rNLLCJaqezYC+1vaAnjjIFGr0UFoM3u3Z5VBKky/5hIj06ixYBRu8aglBL4PEsuaTbiORNCmUsojje2P6HQ3zuRxGh951ws86mFyz2nzs+BJWx9+xajOYjauhp2q6tdn3VVewyWBMbB8uOm3AEK5ae7zrF8SXwMDcrJgOhVJZE1gxXkgJGyfWvdl+KEuPw9+UUbs3eIRq6xmcuAGVZipwidcb4COI8ZRtupPL3H+ajpXPi+qzLV7R3jNmxX2Qj6zxIwkCJQQtA97L6ZYdYxC9fDRXu6bnULb2zOZatNo561K/8cjCXhlDhLLow3iiLK8g1hMgl00mQZUaQ+YyQd5yWH7y4j5ZddITZD2ydbT8mlNCq7U+ArJ0e
 Etlk4p25
 2JvG/aVpWBeagdvkwHAkRH6XgOCruyvdbQmwjYdfn9/xXpGIvD77O+O0SIkFy/QYv3V6AT0QABk+Otr2eE3V9y4rtINBfvsAKFzqXdGCKrIx45LOeFBcIMrcupB/BrQhEw25NKD2bcCgSw3oWHF42fs8bP8Ipupl0a7Oc7tWT6xADkUOk99l2YI6+td4gU444fBURl2YXPi19xz0yya9ZeCsZzWV/MASD0bUbeWWPNDTAyPcR8ISOhGekBIBotBOJ+GGxT2oWd8xHg59E6HL7HGS1idZfG+p7/GOlrv3Z4/mFliMcyYjN6FO/S/b6c0d5feAza6KPZbL1DymXDTllyA64/EnI4591hLoFrGyXQlDjvFE3x7Ovk7/qTyrHtfErzkreorIhtliI6VYAlQj4zsVUWDSxQKlofVaM6UOFciXohOxTweyefKmYXwkR4c0i93fq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 7, 2025 at 4:46=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> With the changes in commit 0c58a97f919c ("fuse: remove tmp folio for
> writebacks and internal rb tree") which removed using temp folios for dir=
ty
> page writeback, fuse can now use the default writeback accounting instead=
 of
> doing its own accounting. This allows us to get rid of BDI_CAP_WRITEBACK_=
ACCT
> altogether.
>
>
> Changelog
> ---------
> v1: https://lore.kernel.org/linux-fsdevel/20250703164556.1576674-1-joanne=
lkoong@gmail.com/
> v1 -> v2:
> * Get rid of unused variable declarations (kernel test robot)
> * Add David's acked-by
>
>
> Joanne Koong (2):
>   fuse: use default writeback accounting
>   mm: remove BDI_CAP_WRITEBACK_ACCT
>
>  fs/fuse/file.c              |  9 +-------
>  fs/fuse/inode.c             |  2 --
>  include/linux/backing-dev.h | 14 +-----------
>  mm/backing-dev.c            |  2 +-
>  mm/page-writeback.c         | 43 ++++++++++++++++---------------------
>  5 files changed, 21 insertions(+), 49 deletions(-)
>

Hi Miklos,

Do you find this patchset acceptable for the fuse tree?

Thanks,
Joanne
> --
> 2.47.1
>

