Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5777DC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 14:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91FEC6B0088; Wed, 21 Jan 2026 09:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA236B0089; Wed, 21 Jan 2026 09:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790146B008A; Wed, 21 Jan 2026 09:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 639426B0088
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:58:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1441016052D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:58:47 +0000 (UTC)
X-FDA: 84356277894.19.E9569BF
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id E2D4A1C0007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:58:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=B9Zr8P0p;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769007525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11H3Sl0B2LnnaUo00s74ciXm10QbO4phXHCmMu1QEis=;
	b=vQmKLCk5Wmm3noZNE/2bPIKVuEz8fRHkpEDzp6oQ+LEy5+Uxt0o82AZpdkzWpA9Iczdo4Q
	/3IpUfGfzH3JbIvU6MYP9hQH8Kqu7r2Go+XNnQBXa0iJfEatktGnukzzbtKjIywTKwVHVb
	DSKaGm30kfz7S7xCtb/tknUiUJ3JP4c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769007525; a=rsa-sha256;
	cv=none;
	b=24q2Px3W9+92BJhDd6/Dd6oVfQ8dEPrakSZPfRxsf3HGs/UA9aGhB6SoqnAJaJm0TVJoxs
	VXGdsQuH1VCuDVYvkp8sCLEUDhzDAgrjihj0tvYEzvoA9x6u9OwMaTDC5PfQmwGaUM83Qm
	1K7oGjlJnvgfPmruPpXGSoQuNz17PUc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=B9Zr8P0p;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-88ffcb14e11so87904846d6.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1769007524; x=1769612324; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=11H3Sl0B2LnnaUo00s74ciXm10QbO4phXHCmMu1QEis=;
        b=B9Zr8P0pgzDjTanRYDIc0YdQmDp0ANG9rQ54AzHYiqqizkmpFQZOGfTjoKVVxfuVdj
         o/mK3/WqXoZHz87/b5ZwRDnVUy5CUGRcz1f1JG/VLk2PF81xpUUfOJH6zRD2/Aw8JexW
         Njo3z7FnBJsYwfzpxKhvcBHi7UfXb8T4YByBo+a6UeSUllVhmtt/XvO+8TLH8RFkBNNQ
         bBbxgP7FlPOlpKaX+WS/7JVZkrBm8Y/GRMBOoK8k15vv7rpnlHmz0tuXf40UOBxzha75
         tc25oznn2xSJSW1VPjl+cd2whxK4ngpxmfeBjiGWi0/vCc7yk1tCqxubuLHvgXa+1CdC
         9WTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769007524; x=1769612324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11H3Sl0B2LnnaUo00s74ciXm10QbO4phXHCmMu1QEis=;
        b=wsegKWig0cV6NxDrK592JwfN9zdQumRys0aXHwLGy6l7fDEhZ98oAEWhNWErN/RwPv
         Vh8c2hOGymQW69cWaNMbVvnnCXqcRXgO1PZWeCENF5owc7ytcsOa7oYyDFdQ1KGAQXCo
         Wiu7BpTHPc6U5Tp2LB4c46E5CSepmeFKxwXc+iW8XpBZK8dv8cwNl6mFvK/JHK12NxXe
         nFjvrbD/FV5L90uAc5BWsQ5soQuMCYvgpUlDWr3mbXFuh78iU0FdvM+kmh2U/IHGaUf3
         CZnRjCpNNfSrVU4ZzJ8Bx/FHfZcKhS0dCcFlD4vuzZCO2lST6E5NVd7p4J/eMXY23CjN
         DDjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcKR8pkDjgpzuJ8YFSn8+ShJzvb+7sLgAq7tEqYgjYarqcMq4O3u7mCHvH2uXxZjn0FY3947Lr2g==@kvack.org
X-Gm-Message-State: AOJu0YwkNj+FyVF8yMB6lMbeon2fvYHoI7y2jYo8fwFY+9Jzt+TW3Zes
	QgI8ju7BPUElWFh1ljpfJD70mGoXR8fpoxd7VxWmdg87Yp4MaSn3SfsQpCYI5phmrjc=
X-Gm-Gg: AZuq6aJHJSXk3dlMPkCQ6O/9e9sE6knHEdYP8DrNfHmiJhD5QobSmg7ceijv0abH92/
	PHU5lNl6lkOdlHBRbdXMA9PSg7Q/ThOuCV2GTSUh3whwbcjW9cqr4bgJrtFytYlW8YDx0VTS27g
	525UqtHYYiyGC1TjpGEb7jC1/iKoGOk3yFx3PALS7pdVVAI2WOsaWzS/V30bSEqho9mOPdUbm8I
	H3G/xq/bq35waQ0Gha/bMD4LrZPil+IxttUNct50vFHXe4WXhqRmOE4Mm1f/PPd+OEhnb6ta1ya
	rql+CYbixXIjSqv5nRfYn59DZu1RR1Ghcvl719+mwJoV6NRSb74OPEGXhXEJND2xSrk3HrxdqR5
	9t6e2OQieB86S1DmWt6CZfwn+HFpGh3B+t+QXPpKn7APjQsAS05xZptSqQ+kPA+bh50P+FEn0Xv
	XBXdQDL9hPhw==
X-Received: by 2002:a05:6214:400c:b0:888:498e:5a3a with SMTP id 6a1803df08f44-89463d16ca5mr80297446d6.68.1769007523747;
        Wed, 21 Jan 2026 06:58:43 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6c9a9dsm132520486d6.43.2026.01.21.06.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 06:58:42 -0800 (PST)
Date: Wed, 21 Jan 2026 09:58:42 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com,
	Muchun Song <muchun.song@linux.dev>,
	Minchan Kim <minchan@kernel.org>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
Message-ID: <aXDponX2AQoACOaI@cmpxchg.org>
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
 <20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
 <CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
 <CADhLXY7FJqRLjX7X2yJfa0=iDbUAMwhS35cOEExW+qBJWAnt+A@mail.gmail.com>
 <20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
X-Stat-Signature: uo5bwos6je1mq79pdwpzeonzm7n38twg
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E2D4A1C0007
X-Rspam-User: 
X-HE-Tag: 1769007524-831125
X-HE-Meta: U2FsdGVkX1+4WWwLGaJvywV0bnUuJJLgq07bkYkK05C2SPTavBPVaMacWsAUkApMX/mTP/aOP//XW1InVpnBige/XIFsHbyHMT43X53/AoRG1UwdWTV4jwPKRtBz6c2tTolyUvVNuucHNu/9gKoYvCgcCicJVYZYqVIjgmhCJGivHElXd8Gssq8EoqkODo+7TGJnNMFm4n+h75iTD59zke0RJo3mPofrrJlPjAP1C+ybrEYuKioltf6PTqPPFNrYvV1ubNKKN5yvQnNTDF//ukG6YfcY99YXdUnxUbaWbrSx+bNQW9nv9p9X53v5hpr+sQ9T5X+SaCrJ6mieZjjeUE/kCDslfsVhvjYCaNoPPnbVjKPHGFfVEOjIW2s6zTPTryEQWvIKZFZu720PiprYwH6oXzgSPFx6pdBVbljYaSNt0MTR1zkldAJy0QQIx5nx4T/S580Qyqx2pRKwAKW6LfFYSsODLHFPwgT8m9ZnrNphO/ep+y8bGNvYOdHhfacmUycvBS08in4TbR+wPgSDM3Mv0oL4VU28apBJWbsU3kQfIKfBlm3Dlxqjf5j0a6wOl3pojS6fSEy2CTS/7FLLsuUKGjdbU2GTlLANUsHupw9i9xW8Ng/EOdVpkAq7oDMTNlA1kfv1MKFtwlVN5Lg6/tQgjcsyHXNivOTe4kqE2V18oJ/K5fqoUxkukg1/OshY53SE2FtMgAwTkuZTk7zaWQsVV4sAp3pRc3kEHRt5yeBvEZKFClRvJ+AlEMrHI3JF6OM9dr80Nycy8IZispwDAmwQKfjVVCleIxMfDSmlipDSgYOxkYSnoBL4mwqzNKtjOnA0+Ber/EKWGADiyS53Vrn35hy+AVCpC78BCISflWmW2c7mRxa+IaIPdxh+79OPbx3IMVWeBkG4W65tgBYycDlcaOHFvzBVgAHvJmuOnXYIHXEtq28KW1+A+sDapAlA/jQkm07S3PuSB6RaqOH
 cHR0xs+j
 rVOPAKWwccH4Ef6MVeBTGNUlIKPbwBa50iWcRtADRI+9RLuCVhfTbnaZ4u7RGMUSyNEUvvclDdj8lRdUAdPk5hvjSI50DQHSMeOxB8bRGkMqHF/wUsu1/GcbkIwhPKoiM7yFvW5yYlkHxxEX9Skkdfjp6jwoIFedJc6GJVJ4rZuwlvzfoM5TgelrM8htQYuC81sSAwRdxq1AUcGV+yTAs9K9WmWHUG7Ee9UwS+UgZu34+UXNnwi0SyGcZF3waApyehnVAHbaFBphycUAj9UOpu4QaxeEbsASIeqP1X33Mp+kDyZPmiLhsjFow3TBwH8M0aoshWU4GeKUqZu3yPzVVaePqt6Q6pc0W3Kk218iOslz+V45kgqn4e0sXmEPWIw7rUhH0iBuxpWOWYiOzMNQPeF044M4tVQO+czxKkkd9CdCy3k7nPq/GShX0lyAN6UjC8c1pMmhegsGrQ7T3HtgoHrVjGW7mAAMSkbNhGN0j6BSuo31dvKEmoSBrc4rzBdAepOOoit8s+tim5j0gUGu+i9QEWiAWEPCGMi1/xtocmpiZJlsqbl+i/k4lqXVfRU+EfoyRNJkL7zBEKgYn7fioFBRFesL7djK09/QTCCKQKFE0H6aIq+i4FPARCXXkTLNWpSSAi+lnj8PP/ZA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 12:53:11PM -0800, Andrew Morton wrote:
> On Sun, 18 Jan 2026 12:31:43 +0530 Deepanshu Kartikey <kartikey406@gmail.com> wrote:
> 
> > > >
> > > > That's
> > > >
> > > >         VM_WARN_ON_ONCE(oldid != 0);
> > > >
> > > > which was added by Deepanshu's "mm/swap_cgroup: fix kernel BUG in
> > > > swap_cgroup_record".
> > > >
> > > > This patch has Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT"),
> > > > which is six years old.  For some reason it has no cc:stable.
> > > >
> > > > Deepanshu's patch has no reviews.
> > > >
> > > > So can I please do the memcg maintainer summoning dance here?  We have a
> > > > repeatable BUG happening in mainline Linux.
> > > >
> > >
> > > Hi Andrew,
> > >
> > > I checked the git blame output for commit 0f853ca2a798:
> > >
> > > Line 763: memcg1_swapout(folio, swap);
> > > Line 764: __swap_cache_del_folio(ci, folio, swap, shadow);
> > >                     (d7a7b2f91f36b - Kairui Song, 2026-01-13 02:33:36 +0800)
> > >
> > > Kairui's reordering patch appears to have been merged on Jan 13.
> 
> Eek, there are many patches, it helps to identify them carefully.
> 
> I think you're referring to
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch

This was supposed to be the replacement for Deepanshu's patch below.

> > > The syzbot report is also from Jan 13, likely from earlier in the
> > > day before the reordering patch was merged.
> > >
> > > So this report is from before the fix. The warning should not appear
> > > in linux-next builds after Jan 13.
> > >
> > > Thanks,
> > >
> > > Deepanshu
> > 
> > Hi Andrew,
> > 
> > I tested with the latest linux-next in sysbot. It is working fine
> 
> Great, thanks.  But we still don't have review for this one.

IOW, this is not necessary anymore. Kairui's (cc'd) fix which you
picked up fixed the syzbot reported problem.

> For some reason I don't have cc:stable on this - could people
> make a recommendation?

So this:

> From: Deepanshu Kartikey <kartikey406@gmail.com>
> Subject: mm/swap_cgroup: fix kernel BUG in swap_cgroup_record

can be dropped.

Please correct if I'm wrong.

