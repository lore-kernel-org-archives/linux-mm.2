Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1154DFEA834
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433B76B0005; Wed, 25 Mar 2026 04:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4D56B0089; Wed, 25 Mar 2026 04:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3026B008A; Wed, 25 Mar 2026 04:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7B66B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:46:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA8381A0806
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:46:55 +0000 (UTC)
X-FDA: 84583955190.24.70A64A6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0AE9C20002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:46:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hc3MBvA7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774428414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQnoxuo+RfJVqr7nd3qZJp1iTq7jEvOPdb9UXk5XaM0=;
	b=muLREniY/oYn+Grvt+NHq5GpW8RlPsF/AQoRqtzH/D0yqUutF+5a7ktb//Fs56Av7jAifH
	3PwUD21aFk+9vB2J+rObow+0u3XgCaWOgke2uNh8i1ZPPa2FDI5KN2f5n7VbbvXuH5rSAa
	7Wwt5RjubrsepmFbw1UYseHUQgBdhjs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774428414; a=rsa-sha256;
	cv=none;
	b=iOsbswDCAyL1Vv+gqjMuRlFqpQdnqM/nOvZCObgtxzzl3rskmv27vG3s9/sm25t1yacYoO
	KSL8vlsMSM+i6MS6iHYv5cXDSPKhmwDREKyYp18VzMOVmI/Qrybdy7fsLWMn65q497/2VG
	Ineq0nJsDT9y2Omj6wO7L+FCvbEx2sg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hc3MBvA7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-486fb439299so52198405e9.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774428412; x=1775033212; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQnoxuo+RfJVqr7nd3qZJp1iTq7jEvOPdb9UXk5XaM0=;
        b=hc3MBvA7buSoJ09esdqpNCvhSvuwDE89XJ/BEZD1VOoc9XvxOG2O4qe1IQgwkWvkH8
         RxIHkMUWk4ZnffCuGDwrZi3OM2faZgtMal44aYmHYqqSCRKKhkiflDfutBkgPoi5sZmN
         0e8SiuLxhgW6ItyYLsZGnc0QrOrxbIlAlhMHBjc+IFyoPGMihTkgyZXCYRmB491aRrED
         tGLLTva0K+QJ5LP/FjRjWWqV+dUt/MDN6jq0YHYa+ifyVxUQMHqav6FsyOD8GUIp5Rk4
         vKsMPonw6qUl+22KwVshUPvg4Vi0L10NqX64vqaIF7pglY4YV35p6taORjao65x8X1Mt
         vnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774428412; x=1775033212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MQnoxuo+RfJVqr7nd3qZJp1iTq7jEvOPdb9UXk5XaM0=;
        b=I3YXBqr/t1tF8iNVI/xJNehIf9llDcn7Xc+k1QqprP3XRkc71SZEiZPDtlbhbfZxCj
         lRr1JbVtiKWrXFijH6TFz/SSyJcCbd0kubBA5k2R+6Ry0KIYvG4fnuhdO/wWoH5eeC/F
         mG1Y4mHeMdL6tSosQU64IPPLQRrtH83zs6wT8eoDwFvVqkREiBUj0z8+VGf7A286RRag
         8ZUADlYRLkYGmiBU78Ftm1sJsDxA0Kse9WQSiA/3EaksT8SHLb/EpzBXv2aU4aS3blqM
         S5nev8vBKkWYnX4P+grRSZ9fzupYTdwIO15chX6KJXYY81Hd9GXM0UlneM3GJcHwa9xw
         V76Q==
X-Forwarded-Encrypted: i=1; AJvYcCXqd9UCJg1FwTOywX1x+Gu3LZyxqnNVFvzB00hUwtSPmEzuehMRXhSWQIKbgUlh+A7NGb0S7unrRQ==@kvack.org
X-Gm-Message-State: AOJu0YxCPoDNf6/M4zaSGslWPduOwXjFLw0eISCLjYUKl6po7mLbJULb
	RTTgW7KaYRBWaHFXRq7Sj1deKqcutW0wSdk9ctySwBaDVFLw4+QGOWOg
X-Gm-Gg: ATEYQzwd/uhmpnHQ0wYgGx2AH1gZfhlXn1hhqh2kgIIYfF0fnNEjfQCd3kfCPtJGqyR
	YaUUVOopkdpTU8IJQWed9rVTwcyt3fG8A8oHN+jiEHvlUjLuAZfy7HkIsHJU/gghNb8kZRv7dwZ
	xkc565UNnD1gkHNuSLdoJX8sQOa1jGOjUuU0tJi2BaBw43vzKVN39oA+NVEXkJnLcBn8IBJkOET
	o6XrI/HUu2uKpvwA0N3+qMiHNxLBak5J3DXJD+Di0cMiaIG6q3FN4ALI9GUTIsUCXL20AZemLw8
	ykXym1EqYwTYSXQC/vnA7iogizNhRMY5QVoimx+zpY5ei1U4Bl4uRjrW5BCwoz+NIp8W5NaiiT3
	DmuMXGDzmfmza5KcIc725egWERvkpHOwwbucbk5LAK15akmo0LflgVllcKojR2jxUMXm4zRNljr
	Bid8FsHZwEpUckScZoTTw=
X-Received: by 2002:a05:600c:4685:b0:485:3eba:ab96 with SMTP id 5b1f17b1804b1-48715fc3725mr41087225e9.3.1774428412054;
        Wed, 25 Mar 2026 01:46:52 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4871174f39dsm99718895e9.11.2026.03.25.01.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 01:46:51 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: jack@suse.cz
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	ardb@kernel.org,
	baolin.wang@linux.alibaba.com,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	lsf-pc@lists.linux-foundation.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@suse.cz,
	will@kernel.org,
	willy@infradead.org
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Per-process page size
Date: Wed, 25 Mar 2026 11:46:32 +0300
Message-ID: <20260325084633.906324-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <pqwem5hownnfwcqrubksdwwraqbkthpzucknhavrghmw5lyszs@vdorbx4fyyaf>
References: <pqwem5hownnfwcqrubksdwwraqbkthpzucknhavrghmw5lyszs@vdorbx4fyyaf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0AE9C20002
X-Stat-Signature: ppm48861cuqiwrz9yexk3dj3fi8g99xt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774428413-2622
X-HE-Meta: U2FsdGVkX1+g7TRKyYyr8TTvvrNC3u6lZKcgtWT84dx8geDyU3J0MGVKfA1Fqw+lEVDIp+S1Fid6z+tgXvJdNgVsRmhgKmxPNyHboFBMN3VuZO0OKQln/+bm/eUOTI7bybOs84spfLJqPA+reWHd3rlJtzi28WtlhvqY8hfslenjar1+IH/k4hpWzoBaltvqczNGmL5N5nkCYWTGlVIG7r1ZB8+DS8w018dHLzPffiTfI9LeS+Z3txEbA3APqupePrXG67Q9QSBZeRk4641HUT3iQIraIbVWOrHU6wdRbg88IayN1Jkjhpbch5XlNkBUejQ2MJq3I5PJOVJgPrH0dcdkXkR86sWZCKgOY+bG9Eb3yWCEnrDNxtJ+kHoPI/P9ERRG4q8phXcJH+MTmzRpAsI+hnixnMgV7zaNrRSM9VP/r6iMpJMTXNaXap4Z+HXhAOjjvcSQRqlRv66p3NQVu8zrEh1UIC3rGe+MtSmUDm3ShKh8gDORYj3AuoKCAEUAzsgt4xvM9oFUpejacD6jZpOCZQpMERmD/Gy2kedpZFHkAytHbOIKKS50/VH8gJO6pc3U+uCxwiAyXp/Q0ZNucNBp5HfuI/yB0jfG+S5ysXsp//HnSuyswK/WxDjQBjty4Yrxh6IObERh5K/A6Lf5y70mdgocLZaLwtI8VBk4YuC7LYHgJ0A3RVgYfyKf4wZ0R8gMSLp9gBcy0NYjk/SXqJU3xyqVAXNp1pPViOV6MnvwZqSnOPP3XpV0XI4eXgwLA6LCC07uvrcgSa3LkAYd0sAF4m32Jl0bCUy2PUMciF5UcwS1NN8/Tl5AktsM8RATcK+Jg5ePw6taOUtWCRtJM726R3u6TTYTq3gjH2od5rn/Bglleij3T58loxcUuY4rO10gb1ej/ktLX2OGrDRcOjaj9Sz4hZEv/fKQpPP7nYz4Y2Dy/LbC/vkZEIbQ7PEvHFcSjzGhdqpiKvdSbPz
 Ix+TnmBK
 o3PbRbSx3UmEDbz+8ZGcSEDMe5Jq3GyxmrTLXhkeNUTuHMwtrL0jsuGTcOEVwym2r38k+Bwlo0dnph3Z5GcgB6BRDivQ2/5aKzWArbhhZgOx/P3yMoNEJfK1FI+LC1hnBjD/ZXCoUNu4oyZH3M2x/6oojYtwo5XpYSneSz6A0miC2bBTZaKuxfR3LjIJh573QnfqgPqIh+2z0q5MQ2g2uA0uKNOKNV7euDyOdpzVxWTE2IDSiaPsYdMnqJVYj2owYHrLuDF8oNXyaazzce7R29jQn5hqfTNChcc3O8kyL/c2f6jZghvTvPqkPFS7HsTGdoisDZknDyekWEtYR4LA0liJpJPwiIQ/rsoShTAhfL+H8za/atKhH94jw3ASAnlasKThtD0tNEfIXJNYQQjqNe0QK68/F8bVLBh59GyGXzyn8CLEdPw+bFnJV8RNC4hV+mdfP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan Kara <jack@suse.cz>:
> > Is there some other way for someone to block a page from getting evicted
> > from the pagecache?
> > 
> > We have this memfd_pin_folios() thing, but I don't think we have something
> > comparable for ordinary pagecache files.
> > 
> > ... putting them into a pipe and never reading from the pipe maybe (I assume
> > that's what splice() does, but not sure if it actually places the pages in
> > there or whether it creates a copy first)?
> 
> Standard splice copies data first (it's using standard IO callbacks such as
> ->read_iter) so that doesn't pin page cache AFAICT. Only vmsplice(2) does
> but that requires mmap.

Splice from page cache to pipe sometimes doesn't copy data.

That is why test program mentioned here may print "new":
https://lore.kernel.org/all/CAHk-=wjixHw6n_R5TQWW1r0a+GgFAPGw21KMj6obkzr3qXXbYA@mail.gmail.com/

-- 
Askar Safin

