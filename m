Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2029ECA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81BBB8E000A; Wed,  3 Sep 2025 05:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CD008E0001; Wed,  3 Sep 2025 05:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB498E000A; Wed,  3 Sep 2025 05:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 598D68E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:32:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 239711405B4
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:32:41 +0000 (UTC)
X-FDA: 83847424122.16.21EE748
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1BC17100013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:32:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qhfLccV8;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756891959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tkZi1hqb7jdEmw/46wBYRYDsSEnL6BoP1nCDfCgTg4=;
	b=Z7u8hoPB0ERf4EVCn4awB05zH3lbiTnLoaNyeI0XZZ83ff/vQTQfGbtml77FtWfV1rDYQ2
	WAvQGQIWVUAizZXHnv/628IGtrCLF0E8P6VnoOO25OaMVWGF1iizYEsm8rJcFDS81Xi6hU
	tTktUWPiCEc3RwOsXXw+OCeZA+EnvPk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qhfLccV8;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756891959; a=rsa-sha256;
	cv=none;
	b=2366AhYawFLOflofLZJ4knbs/8CIPpq4wSgm84UxLgESmErV54Ru5Nq+w8q4xSkrYbJwvZ
	VVRZ0ZgKxonAb9jZnt99pFcwqHW15YusoYDEubKJDkQw9ekX9bz8KrGtL3KErt5/Xl3MrU
	lYbkJX02n4Oon3y/9MUPqfQvZnSuniM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C84B44B04
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81461C116B1
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756891957;
	bh=QYNEiv8UzZcglF4OuHMoI1sYm9C7MmUjrT8VXMrcbjs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qhfLccV8/Wbfuwadslg9tMoSbyC9NvfNemfzNfxSH06nEDnEN0sNAWr77z/XZ8n9J
	 9VfNzkq4/ecF1fmyWEYvi+TEKFq8YzUvonjCkDUs9OAqZkgBBDCbe2gugiQYPpdaol
	 X6b6WfUD71CUarVo/NS1fFB5p3xaogSGU6DU+p4va/RS1u0jfd3T0UwXKkF+ESNYh7
	 Z9g4X1DWTGA0TnA39LqW/05YHGpCm9C9d65MPwAD8TYxHTOtJ8vuvUboATXt8PyvVg
	 y/nAbH+p7iBztJIeDNbx4bkVnHUwusXDiQyKpxkSVTpwDSm2G4C+cG1rWD4c/4GUJS
	 pdFRWp+53f01Q==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71d603a269cso54399947b3.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 02:32:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXgiFZaDtArEo8k9LgKO8kXIrMCZB2TdTdcU64Q60ks6tbhwYCcCdml/avY/NMhsL7lIEqcj3sXTg==@kvack.org
X-Gm-Message-State: AOJu0Yzl5m8JIr5MLsHHj4YyS2CcZ+eSj2ulv7SCTaKX7tQDA3j24iDN
	GuLsojbAid2x6aaN2pebsy8lTYt+uDS2uQz+Sp7R7/PeYwLCCDkjFVyL6J02VC3y1fmdbvEpWVc
	Yflqd0Gi+9aMPDJ6jzkttPOLgyEZcvxvDS/mCjCbsJQ==
X-Google-Smtp-Source: AGHT+IHVyg4p5QR0RAptgKvMSgPMubewuNwv+4U8GLEeqLb+YipS9iGNECUENqyGY22+4BFCeDQZqDuyHgVV9qNx8gs=
X-Received: by 2002:a05:690c:6d8c:b0:722:6a6c:c010 with SMTP id
 00721157ae682-7227633350bmr137460257b3.8.1756891956703; Wed, 03 Sep 2025
 02:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <aKgD7nZy7U+rHt9X@yjaykim-PowerEdge-T330> <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
 <aKsAES4cXWbDG1xn@yjaykim-PowerEdge-T330> <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
 <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330> <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
 <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330> <CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com>
 <aLRTyWJN60WEu/3q@yjaykim-PowerEdge-T330> <CACePvbVu7-s1BbXDD4Xk+vBk7my0hef5MBkecg1Vs6CBHMAm3g@mail.gmail.com>
 <aLXEkRAGmTlTGeQO@yjaykim-PowerEdge-T330> <CACePvbXAXbxqRi3_OoiSJKVs0dzuC-021AVaTkE3XOSx7FWvXQ@mail.gmail.com>
In-Reply-To: <CACePvbXAXbxqRi3_OoiSJKVs0dzuC-021AVaTkE3XOSx7FWvXQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 3 Sep 2025 02:32:25 -0700
X-Gmail-Original-Message-ID: <CACePvbU2iqLyjc2uR3d=56S4A-N4P7k3oUnwA-6D=TFfQ17jBA@mail.gmail.com>
X-Gm-Features: Ac12FXybUwxod4Em_QKVug5j6Ua_Z4DLXXFTPr86WOiopqyMskJfrqtzgT6b41k
Message-ID: <CACePvbU2iqLyjc2uR3d=56S4A-N4P7k3oUnwA-6D=TFfQ17jBA@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
To: YoungJun Park <youngjun.park@lge.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com, 
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@redhat.com>, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1BC17100013
X-Rspam-User: 
X-Stat-Signature: t4p555udikneynnbehh9jjaoa4bfhdcg
X-Rspamd-Server: rspam09
X-HE-Tag: 1756891958-689425
X-HE-Meta: U2FsdGVkX19qsDc1YDYBCFMxmutJQnwntyDrS6TysNUuN6zu9nZRs4XdvltdleocGctvFNTw4On9sLK5+e8lpOco2t1sV7zIO8DYNvVRJEZttc7PUbi+M0JgtlYBofC6p0FBbBsTLJccvz5hB7svqRFJlIcQjTDP6qRaq6Ycq7D0puhx4c69MbHsxQVwpu4Mnwd5R1a2N9KEpWRgUii+yWKJJZyHPGcbBYSciEHJgXXn+f0v1IyxosinGsSLTaFgOucd2Pgk9WOkCD/NNViLUkrIQESudiH7XL2ORmlE1EQ//DPfs1x+M39oz3M8Y2Mc1NXx6b9KknjjEEYqZ+NebtzsRmYPp5bnUZ33ktykz6qtak5Lb5ECTBjZZSr4Mlf3srsrti+Sn1+vuB3NDStOPEC3QjqWjo29V10szBeNufF0rU45kMnjCwogCtyf2akijSplud+5jG3mfmkucFWhEGSdVFG0bBd4mGtxKVm7cteGvuHCLqdnO8NWxRomN+Dz1hSPzRMI/SkwGUpN/D4Bs88XtSrl6vCl5T/boynBjNovWcVMFqzV867mbTTS22R6HgSLBvSqvbioeBchaJSV25Wp8dh3f7SPlARgkRh1B3Nrg3CBh+BoEMYWiwonHd0Lou5H9f6Y5QlT98mRVJxH1q4ZClrVLHLyvv82I2xZ9ZxUYu8futwr6cbdFaomHcAAhEJ3EOpHrVfXTRQ55z9+89Bzwqhp/mMn61C99nxDxt3nRaNPDek/yp6EBDvjL5HJ1lya1qn/fCN4fc7+PDvt4tJGwjU4lAD5uYE8cloI9HC2q2JOkDznNe9k5oji+7nDl8yJi78M0Mevk103KviUW/6ysAiPWxBF+Zop7Xxq7abwWkVW2g121nsxWVCXLZpk12HD6NbgKN3J/maFmiue3sbfcPHQH7b1yHow2goMuiKp15IhX/OKKi3OGtsRMEWK0IJ+2vG7AnLZ2tzbAIU
 1USDdh5I
 mE6ih/TxfEMG0pHn0/QK21lyrnnI14OoOOd1kYvYBJoCyHd5ncDEPLDjSQPyPHmeLFjBHVwxw9jbIsu/7m9PFtVjyr7BpSMUKJyzzl0z+/4+x/e+7AK5V8HCXQnd6Q9c3WdPUOMvWFil4OckZmXCO/vEdc60Zff7aDo4xnVnxV5QZUbHGZT2aVeyTsD11hzHkL9y613C4dqhjDzom9MEU2VGyw7pq3+kybFslda/j1EbCQMvQyZNvP22mCHR/sRXxeux/iYg0cSVtLl7i683+bbKUiLCa6dYGRGySkVL1TgzF/+Q8AnKucVbtCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 3:40=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
> You are missing the fact that you need to track two sets of the tier mask=
.
> the "swap.ters" is a local tiername you need to track. Default is empty.
>
> The runtime tier set is the local tier mask walk to the parent, and
> collect all parent local bitmasks and aggregate into an effective set.
> The effective tier bitmask is used as the swap allocator.
>
> What you purpose still has the same problem at:
> 1) parent "- +ssd"
> 2) child "' # same as parent.
>
> If we do what your proposal is. Child will have "ssd" on the bit mask
> at creation
> When parents remove the "ssd". the child will keep having the "ssd".
>
> In  my original proposal, if a parent removes ssd then the child will
> automatically get it as well.
>
> I am not happy that you keep introducing change to my proposal and
> introduce the same buggy behavior again and again. Please respect my
> time, I am spending my long weekend writing an email to you. Please
> don't introduce the same bug again just for the sake of changing
> behavior. Be careful and think through what you are proposing.

Please accept the sincere apology from me.  I was grumpy, sorry about
that. I was under pressure to be somewhere else but this email is
taking longer than I expected to write. I let my bad temper get the
better of me and I am sorry about that.

You might not have realized that the proposal you made has the same
kind of buggy behavior for the usage case where the change of the
parent and the child gets it.

One side note, I do want to rate limit the new proposals I have to
defend against. On the other hand, when you make a proposal to change,
you have no way to predict where I will consider it good or bad.
Otherwise we don't need to have this discussion. My hash reply is
uncalled for and I realized that now.

I am over it now, let's put this behind us and continue our discussion.

Best regards,

Chris

