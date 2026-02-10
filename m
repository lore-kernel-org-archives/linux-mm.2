Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB51E9462E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B697F6B0005; Mon,  9 Feb 2026 23:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20FE6B0088; Mon,  9 Feb 2026 23:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E146B0089; Mon,  9 Feb 2026 23:10:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94E786B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:10:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C47E140349
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:10:36 +0000 (UTC)
X-FDA: 84427220472.20.3769EC3
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5002180005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:10:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=kEuxZCMx;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770696634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mScTVjrr5hgqDSceepZk2KFe97cs6wupSJIij6NU0Os=;
	b=IU1XnGSzKzABfQgq1KofWQHHWBXommSt2T3OHh1ussRL6pnQOY7iZOCl6npaf5w6D1bMrF
	eh8NynaA45pUyDwLUamI6rBT3jRtvs2XLt1U6zGj8oMkzA1Bvx2Ybm15lm48Z7hVQ3QXIe
	WhZ8z57iFulEa4W1FtZLyh+JTzoVso8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=kEuxZCMx;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770696634; a=rsa-sha256;
	cv=none;
	b=iJUt/Rvemi8Atldzd58Wa7QeewqQ7HbOSdHCyzbNk22XhVarY3IpMaF9ZqdxpRkQACtLab
	4dvR9cgQtqP6CHpXTaEgXRqkjlhu0J3GFEIVqL7CFaeorIBu2IAr8VjR9pb70SwasJuco2
	XSgViNXsGGJip7563eClBfBtOCmMXkU=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a90055b9e9so21866675ad.1
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 20:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770696633; x=1771301433; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mScTVjrr5hgqDSceepZk2KFe97cs6wupSJIij6NU0Os=;
        b=kEuxZCMxdRJqaM9XOryA3cNs0A3Fwv9o+7oHPix9BRKdpH1gp2Z0QwYJ5k1ymOfmYp
         25coAjKKBUND8MQKbP4TZuD9kL4VYLg3xw7TLJeuhLO4tXBozDjsbF2blj06eiO0WdiT
         9a7m6GjMz2W0QqVYm4p8plfYh7lzSe5VBzs/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770696633; x=1771301433;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mScTVjrr5hgqDSceepZk2KFe97cs6wupSJIij6NU0Os=;
        b=ObZYBSugWpam00BgCemy5IhYhMkDiiXteRGqUrxk9D8j43tfY6809raEl0EYg69ACG
         UoEl7FbROjfuKoMbmwX9c+5MMoPVZfPyn6dRwI9hd32XdeHbhjnlaj+vhZNEWV2auRxc
         4/OaLdiRtJmpjNbLh7jAZ8KKg1nTvSb/QfxJzDsTwpEmkbmEvRx9vmsxbgoWK4LXW61R
         HJmMFl34hymmkiUmonGzLYk8Wla7jcQ4bhvshzSlAVONpkBUb22W4ZFZCdvdBnpkH/dX
         4NbWiKNCPlCqVwoRf0fZgP3dtVXuTKXGzxOjMobQ9k2W5kPPW+e9dcKhOZ3TNmvkti+9
         cTPw==
X-Forwarded-Encrypted: i=1; AJvYcCXQK1UfqJ0is6OtuS9ZiCbEXCbspuh3TNZvWBI2xIeV7wL9ooDXKXhUIp0QOhUSGbPWmVi0eV/38g==@kvack.org
X-Gm-Message-State: AOJu0YzqhZYXBMoGP827l/d6ASYg07sZZKKAeQi3bKFVzl27DMQPKiQl
	bKWJ1LIzkojKuL/7UALHZVoE8KASUskvmBiw9I4xD/QpfhULrMwrVS5WiuEheU3+gg==
X-Gm-Gg: AZuq6aLYOU9HdSb8vApcmIbTyUITpGKc5c6ugOgvvL6KVM/25s1PRn1maxVxKTI2Hhz
	z54jMhuopiIxzjkGSzNRMI+nACCkxGFJTveAXZ0YliXaz+w/GVT/UXFK9u3f2Lxc7sSikq++4gz
	N4mzBhfhJhIDVr7qBSZxQF6sFfVKiyoVbbgdDMXVOVEXLqGtlwcKMFytg3iQ07D+VU2CQ0l4O4/
	3s0lCzw/oTbtfL/e9Su6U5Yw4KfF/mQficB/GydZU6n0uMNmO0/LKPJlL6t+Yt8mFOC6rF1duz4
	vcnqHijVWb5b2XlNWv9CM/L1f9VWC8ZgXKIOgKNXdLVwCO56HuRmc4PCO/3B2W2ELfTJHwIJYfW
	S5BP09QmM9kUXHGQJ7aY3NzWinTwSrefrKAyNUYaTXqV7I9veoxDs7MOGQux0lLWEF+JvMWtU0v
	qNokRkKxGlzSzpK9xKyYB9naN1IyonwoL9Lk1jzAFphML7xNRKTC2tDhhrhFdG
X-Received: by 2002:a17:902:c945:b0:29e:9c82:a918 with SMTP id d9443c01a7336-2a95214a72amr125016215ad.22.1770696633129;
        Mon, 09 Feb 2026 20:10:33 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:3f6:92b2:887b:120])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a951a638c0sm132083815ad.15.2026.02.09.20.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 20:10:32 -0800 (PST)
Date: Tue, 10 Feb 2026 13:10:28 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>, 
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org, Richard Chang <richardycc@google.com>, 
	David Stevens <stevensd@google.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH] zram: drop slot trylock and miss_free
Message-ID: <fkx7xu4nl7olte26x6ra4p4nokc6frnpguc3wkmk45hmqfw3z2@ewyryw3mx54y>
References: <20260210035045.3817297-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210035045.3817297-1-senozhatsky@chromium.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5002180005
X-Stat-Signature: 4i5gmriyppya8h1nmwajxy6hf7e6e3gg
X-Rspam-User: 
X-HE-Tag: 1770696634-690648
X-HE-Meta: U2FsdGVkX184K5Vih/VhwT/VbZD32q3S3gMab3y+DaT07T3+DbJ7xqaQSxyXpGpos5DDwm+a+ccPMpbcQiD2b4p9GbroqWzRruwDAhfD+N2HLm+x9UUPy87u2+9Vlvl4ZJgVVrtXiWV+2EnH29Cv9Qs3D27Ua8qKliqRR9eq1u0lhz9z02VnPdPB/Nn93raXcCC5w6OseBXecLBYNpPX/5mRRMiBUWQQUMsgbgRSK51CRN+WDPK9ITy9CpXFmgsneTCih8d+Z1F3xsoQiEhW+OaAgzFU3yPWtoNkQ05I+fQ/KcWDgV2KFm1Ifs7hgkH+gzNDeCEDTI7n2qYqMnzyWUi3IODYrQ69FNsD15OjPcIEaibMabe5DVCa6APYOAgW87Bt7FjSc16aS6pW9bXVF1RODt7Zg/ZHepyFZX8s1qapBA9Uo8oaf3RlYK4XCXuqjZRsSpwuaGgOL6XgKGgmjBn7Z4QxzdDLp35kqbnFzdZqS9x1whif5o74ZJP1nEK0iJoec1gZbUYVbUOKaOcww5PV/E3hwYU78d/CF5Qe2NOTgF2ZLUCqa67CLZ7cOmhZg3xx0C0RyCtIN5yNK0nClSff792WW29qXXcieY4RZP047fkjYM1DRMKfqeHlagL7U6ks4wL4PhUdYbpEKusiH+AnckpNlyVxouaklj8kyVVgYV3lh9hSYVJGF1fn1MzzfwUCZj9bhq38jjSHED+Ed20X2YidDKvJWrBfccPA8k2tfG0fTKSBzYuMCGO+1Q+7QyAh20BykOmflGZPJFjq9HWpH5BA7IXZvxHPUSewe/KYAwcE67QDj5aG/0fIiOzxHXwWdq2YhlbEPJzDorrhWLsYY+/aPBOQhbCQKOCAxk4kUQv0DAJs+HejDis29EqC/8h8Ej8KKezSr0Sr9t5Rut1rNReCRxhF2aRTwXxMeW6TcxL5jk2F40qXmEdmf3JKsan1QEOyWI5VxNouXZ+
 nFmUG9l+
 DgZsjhypAyz76kKAWUNUmtiYRBKjryqG4s0G/yxOvFYNr4IZSA0Yd7pJb5yiGIinGVxPo5hbBGOddDOAAt7Qhu81S7j/I3NXGJXt6ZTIm2Li3MC1HATjybQZ8ndKwHSf7OkcgqZJv3gteGWmk72o4vrxSavdEYOIH5b/6Jfegx7SF5v4IbLY4NLsImnxUJd1nC+TGSjz/TvQA9VTlVA/j+SSVPB7vnY6Y5h0TjjJbprzgfyxv2l6vfwcBlAL2qkDLp1GDPNfPvZwdVy5fBj12c//WAXofPGsQWrTMEYO01o1BMp3elLXO+ErRhzBIIDhnL5IyU0LGUciDY9yCrBYJWNx8aC1yBWe38kR5gPynjw/PS0PwlP2cfkT2/dBYnTNsIpkJdddsU8bJkUM67GKaF1Phfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/10 12:50), Sergey Senozhatsky wrote:
> Commit e914d8f00391 ("mm: fix unexpected zeroed page
> mapping with zram swap") removed swap_slot_free_notify()
> calls from end_io callbacks.  This means that there is
> no more slot_free_notify() from IRQ context and hence
> slot-free cannot deadlock on slot lock any more.  Drop
> slot trylock.

Oh, please ignore this patch.  I realized it doesn't make sense,
we can drop miss_free, but trylock has to stay.

