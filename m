Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CCECA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 17:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37FE8E001D; Wed, 20 Aug 2025 13:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DA68E000B; Wed, 20 Aug 2025 13:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23498E001D; Wed, 20 Aug 2025 13:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CAE948E000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:33:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 508451DD8C1
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:33:06 +0000 (UTC)
X-FDA: 83797831572.29.DDC2B6B
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6C3D7180009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:33:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nh4kn7NG;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755711184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThfuItRzO5dAi8yX67yobCtdK1/gMRrLN7ssTg7iVaw=;
	b=q63n5w1Tz69D4wlT5Amzt31tnsdLhSatv87yWxKESh+f1xTjF6Zqbdc4H2bmUMM+liqdus
	qTIV/WWicn+ONmPu5fFKup8yZasKHwQVfI3d9Nz3rMaA9xkskivSz0BfxdshkvGnzSgfwt
	VWpk7UX3JiaZTWLzmNTW3EdvulzbV1E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nh4kn7NG;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755711184; a=rsa-sha256;
	cv=none;
	b=IqUoa+gj6gSqeMTvk42Ye/tPl0u8HDc9GF1W4u0MCDKg3QBry8hQOmo9dxjk9uYAsdvpmY
	+c1Ij47oLOJs0OrEyU/9xB1XULM9u7xxE+mvO23MV1NmjSXMluj73zazhWcJ6PQIp9dTSe
	5ODfm6Qau/mC9ZkbXQGxYBXe5nqcLgM=
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-88432cbf3fbso4169539f.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755711183; x=1756315983; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ThfuItRzO5dAi8yX67yobCtdK1/gMRrLN7ssTg7iVaw=;
        b=nh4kn7NGOqMxJ3r4qrj+tH7b1QR6hjM9c2Dl09h35ej43GTyG26CC2hfoA9/FbIBbV
         mN6hVXsmU1ZmtaPN8wRVJqTO4rRCX0jZxtQgJZ7JgZ8ng+8YgAKuK95UXPyFn2BqQ0bL
         ZkyxOTHgX9pdVFOsvhPTzQ8UPhiN+o/08mh1g98uVVJjCCwB15cgmx2YwG4KYaz7fyOt
         7A94RmcX2M3BEWLc7M0jYHXUz4u/EqZKutUNCCmSHx+nayiTr/YjHQS5a/54GcOT6oVE
         d/01HxwzKaoc48n39jSAQhw9UhUJgxjZya1a2B9fcd1FiXBrGk07q/cwOksS0TnTIu8A
         LAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755711183; x=1756315983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ThfuItRzO5dAi8yX67yobCtdK1/gMRrLN7ssTg7iVaw=;
        b=d3njRmm4/cLx7KwYdTRqxVmNLGNs/5NdiShvrN6/CjzR3xCgNWp1ZVhNhTgglTSlNK
         9UuOmp0tElSeMM/utRPphDXptHWL057vWGhM8NkYUhkmOez6jHI445fuO+7/PLsGHiKB
         Zw+Z6tLRRYDTvS1VI2odqeFOdFIj7IsYyv7u3HM7HBwebHR2h6jQPLN7nOUoEyMW2Yt0
         SAaqHoDjl6lLORWCFAElyEvRDyRyQt9FrmSrTS8kgSHHsmeVff/11OTf1YSioag8Y2hQ
         nUFDofQGz0fqNOX/C6OlvDU05XIoVZ6z4v/YWw5cmhVyYDGiwDYeVK+a+Klrkfs5Z5Y9
         kEUg==
X-Forwarded-Encrypted: i=1; AJvYcCWaq4msQOWAIkNgTmt3WoESwn+ujQWODHwUUMLPAHnLE5yt+bunN4DtK3kAuo+xpQrY2gPouNfd7w==@kvack.org
X-Gm-Message-State: AOJu0YwgHsGOEXFlxU6xWWgwi5sjKYNhwVBfUi/X+0ZtJI0eiHvZLv49
	EVigVrywBRrydGRvO4BYbcRFWf4Kds6SgaUyn2pWcLnT3q2BdZfGSqxoEzfi4vj0+YMmEHNFPJn
	lTXDku2Ry8/5XXqFpAIt23hwjvb6C12c=
X-Gm-Gg: ASbGncv5Vn2fwucwq8Rl/T7FMp9yiszYHrqAxVBP84s9yJb+eCJD9rAnP6Yq7dx0k9q
	VtwG5pt7cQZVm8KXJO4dfgzOtSUhDv9fxpHnE+YHOgGmoKGta+tZejCK1LgZJfuz43lt44hO15j
	SXBipx7BtZUbZ3reGz3T6lRMUgn5oCCKPVT0bug9vY91WKMhtXq1SbhSZOzex7hwZuAI/UBvrIb
	lco
X-Google-Smtp-Source: AGHT+IHo3KxAA012zFqs6RhvbLPpLx+6J7o9tijiKGSWLorPFqpg2/Omsh8aBWipT8mtpeYGOMKEzTXUFSLSaOXuzxQ=
X-Received: by 2002:a05:6e02:380b:b0:3e6:7981:1fdc with SMTP id
 e9e14a558f8ab-3e67ca4983emr72265165ab.21.1755711183165; Wed, 20 Aug 2025
 10:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250819193404.46680-1-sj@kernel.org> <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
 <aKUi7hvcaK0h0oMg@gondor.apana.org.au> <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
 <aKUmyl5gUFCdXGn-@gondor.apana.org.au>
In-Reply-To: <aKUmyl5gUFCdXGn-@gondor.apana.org.au>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 20 Aug 2025 10:32:51 -0700
X-Gm-Features: Ac12FXwLFWidn2lw5_reaDVdpK_8xLH_KQmd5o4JTROLVpqWQ-9XKmGxaOyFOcM
Message-ID: <CAKEwX=P9T315JcOBOBGK21Zk8XyDruMTv_XEPa0CuD=oAN2QYQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Barry Song <21cnbao@gmail.com>, SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>, David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qchofywdtg3b8poneb6kz4qz5zwbh4ht
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C3D7180009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755711184-498717
X-HE-Meta: U2FsdGVkX1+BtQHuQgRuQbVPouPCVrJhvXwDFoK7N2tIiAhP9FyfvEfeJFTvnKJnaPmm4xMixRUSQ/2TZho2engL5/lXNv4Wlfy6UZnp6tfZokX1UHLpBY0vPpoQLxW+mflwvRDquz3M4K9bPtHIU+KXGSjd4xcOlWwXATnjSboiyqfpR1P4/8CSp8EpvyNhqc0oWLMUMu3Hveo67ey+aLHdPIkTG2piMhGxYhOg4yGa8LbYWnRl40NfWCFPmgIJBHTES2912MGrvE3SHgzk+/Lsl1OgAxXtJAOiLvt7cwH8B8MUg4KwtSuDBO/UAiuhS24kVaMk51qm6b6MA12sQjTzXT4NGQCxmj4oUc8cYKugLyrSQ61LavYVcs0w+EEb+fFP/boJjGW82IA/odrsn2L2Msi5Z6XmcbkIAarrj1zWEowqXHhz78j+IfByQUGutcRZ4Zy1VNH8tCOKuJAuibrrvD8ud1RZ5LLGvA6nBNY74jCSLNSz7zfDVtciBX9H6LaaNXp0HVgmfi/BsBtpjpI8deNBfixIiFil/N7TKroSfWUi40g+khIgBMVB4F88P4nV+WoTY4qbuI8RKm5VtGv5cLCNVwSYEXbSf2fxIJAhSKITZR3SMj4pBebGTCTFoSp1D/KPVpcioseArFzRMqflYqq5O21dZUYhFz/zitTL8YJqRr9+jl93GVNjt6fjIjXYXakM+Of51ow264y5N0JPWRLQiiA5Eb4367SY98uAcUdWYyxQqOw7JhXi1ueuQOvAl9/IBmvaK2tMwuOgFK6kXIuwHHfY5RxQQJjdPP5XHCd4+MZlp+QxTnDObZmfd7j63uFPUXhCf7XfV9HwWeXhauZp7gO3VtsPhVqlS98dmzRj3NDt+y5xNR4ciAp+H6OsEuqJtUWsAYBorWehCvgeH/Em4APc4MGImMnIXqrwUHF6seZqyTRBDIBGvylUV4E/XLbS/N0FLGtxIjc
 Xv7m3JAP
 ltu6HCcdhUEBWQjzVbzkbEicm12oAgriUDPiStTZq4Ni+3wjEKbk08eh0RCj6s/hLU2mcN2kWyBfs9+LzM3QXjYRZuYyztRpXCIPsVH+H2qSKnCavLoCZtDGzeCbXO194+twPGeIvqm3quiL6FyvfLSwaBsyAwNZhvXfu0K4anc6tKVjCZuvTLbOUR3nKb3Ehz+W8gxyKXi2Ws2ts9kY+2dQnV7nWblICw2bylGiMv2cs/lJILDXpxrFxien5xWu0cxbjleXCSBgH6IO0hKU8PJbONW9Seya0C8tfSu9BfClm8dngBldEcOg6gIHh9aBkhCETcHURjZZ4bUKkpodOlraF4nmTOR7RD98UIKHg3RzwO5mP/8CMxLKkzUZfmzmSPX4sCtSo2YelCNK2UgjW+x6T8ff5C0aORxHwPZdk9wLapl9LLDZbGxP74IhfzBvY1vIkrWy01kTJIfwJ/iXUWlasK7lJmdyuyLfL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 6:37=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, Aug 20, 2025 at 01:34:01PM +1200, Barry Song wrote:
> >
> > We might want to revisit the old thread to check whether it is now safe=
 for us
> > to move to PAGE_SIZE in zswap now.
>
> It's perfectly safe as LZO was fixed months ago.

Perfect. Then I'll revive Chengming's patch (see [1]) to reduce the
compression buffer :)

[1]: https://lore.kernel.org/linux-mm/20231213-zswap-dstmem-v4-1-f228b059dd=
89@bytedance.com/

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

