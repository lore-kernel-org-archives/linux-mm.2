Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEEC9606A8A0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 16:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Ov2tBg+j
Received: by kanga.kvack.org (Postfix)
	id 03A446B00EF; Wed, 11 Nov 2026 11:44:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D9B6B05B0; Wed, 11 Nov 2026 11:44:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF53E6B05B1; Wed, 11 Nov 2026 11:44:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA2196B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:44:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CD8680354
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:44:22 +0000 (UTC)
X-FDA: 85423411164.21.D3BEFB1
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id EE5DC40008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:44:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Ov2tBg+j;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794415460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZsD1auAFGH9focpKeQLt7lmstuziSR0maGDEOD7IaE=;
	b=sV/I2KAiWB7MvCTmiAffa6JLxztjq/mfeNEzhiY+T9RQ5i9ejarB7Ul6xi4oPTLiW2ygM1
	X0kSmXbSf5EOLybz4vTPjwnY7eFkOKvrwAZaRAaqd9ovcBQKjTezGBWftVC8td+fdcHVBX
	qo5tFY4XUaXWMuNrW9C+TJXwI/gr6UQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794415460;
	b=TF06fn1wPXCr5GCuCDXFZAIUCaf0WoIdaJ4EECclkHMVANre/zWlY7tXe58FY9LSZa+XjW
	ftuNN0ZTaFyPa+1KvaVRTcGswhlofmX99OqJc0hKiEyzWUiUPHExa9503GZMJM7w6r42t/
	aQd/2JNEWYHF/SXjphmRrISO+Q3tckY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Ov2tBg+j;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ede7cb02daso65485ad.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794415458; x=1795020258; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eZsD1auAFGH9focpKeQLt7lmstuziSR0maGDEOD7IaE=;
        b=Ov2tBg+judDWQcE8KO+GXUzpUxpyf2a0AoT/tnW2Eks4kKO6+9z1woVivRGDggSLnk
         483PvH8AmaXQDt3uKVBV7mM0AEq2Le3YFJz6lHWD2OF8Y00l5ZTWVCahLSId9pknQsnN
         8NnRRsVXt4ShLtOUpeM5ensmVpkfDZCXlBCps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794415458; x=1795020258;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eZsD1auAFGH9focpKeQLt7lmstuziSR0maGDEOD7IaE=;
        b=GiPMB812aMG46CNusTy/khrILyp5tYQRsN6cSh5PoorH6lDrl9aLEN10HAWa/E6g1O
         +dGpDPPVQxOzXgRoNC0+b53aPSrpBs7U4T2JMyzPblu5/cWPnK9X87lOzKIYE483ONNK
         jvrLUfWHlZSLSWJoyu6OsZ+2qZPRAR4BQPXCeYv6PbM32oTbrWAheM/d+yzwNnj689rn
         zyOJZx237wgwxCon06+w33Rc3xKsObjEGJwkEtvo4NW032sshMb1/Fmvdr8Mey8tWnu9
         YXtKJXRaB4ehG1PsKk6IgbYKI36j0FDBvpWBijHPTQoIO3hwA8E735YUkaPifA8RO/Zu
         qOTw==
X-Forwarded-Encrypted: i=1; AL+hErHrCRa6H7B9U7Pi9HJH5nDEFBaJwpESPEjr+17X8Ce+tcAF9zyvzVuS5o7pCddU/miPVvV+6m34hg==@kvack.org
X-Gm-Message-State: APuU4Z/HZtWIOJkLFG4Z977BS+TzxKhaqd1M891prwxTRGDqUavYn/IY
	05jL9X6tabu/9Ht/hR8fJnzoUmIgpe2dzhrofi+CIa6Ulp9GEVoQ2J3baeiUUaYXomvuxX9eo/K
	7uuwp8XrNxQ==
X-Gm-Gg: AYBFou0ty+bMiSVZ5evEUDAyP69jI2qBHEVt9czJYDyjaPAL4UOo+X9h5+vnu3nSn49
	BKN1YtelLsWvz6qtpmODQJzwKnfeZR/I8dohHSC85v3pMmTbE3DW7stXuz2B+0q+g6H1HBphw+C
	ADHBMUjERPjv7pN/Ntv0o3vzAIqd4cchaMGAVqWpiffB5sb1VtAtHEwdohxwZonjz0usNKdTe3O
	bRxewDYs9nptmGe+i+WMXWU8bgnbyKEKvKwn7BHdW9X3d8tHviGT5oV7oYL/ejcrqaZJDIbQ+f/
	Po3FFTXU3OKpTL93p5SbTwECSdcB5xWU4mxBLArYU+Y3JnQAfTZDF89lFYVvK5JTd/TyisVw9tr
	NUWBPh8jv8/vdUm+vkyoxHCXVBoFRHpUY+b1QPkhOZAIw1qyRugoF6ZfEOSU5+UsVcD33p8ttSi
	3HKxSvRF+cs8/mDi81jrtiP4mPPeZWY3glT1DwXDMDy8eHtyqoyRnDOdE6TkTWj/DchlVI+L6kO
	lgDMjvN/EHmBvWS01tJ3QFyNStnkNJ44hOb+OLC6ZEDKf/JoVWUtoICmCW2EnxlgTPhfpNY2LDt
	Txi6ZpljbbtFZ2TlUPtAQW/9ZH7kQ/O4yhqfWrXTis9nUKRdQusQDia6HPemzT+/LuN32uEfc58
	1870=
X-Received: by 2002:a17:90b:1b01:b0:3b1:6689:a016 with SMTP id 98e67ed59e1d1-3b197c93f3amr20413a91.16.1794415458086;
        Wed, 11 Nov 2026 08:44:18 -0800 (PST)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com. [209.85.216.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c42a4csm63828a91.4.2026.11.11.08.44.16
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 08:44:16 -0800 (PST)
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ae1b34e0d2so6294a91.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:44:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErG3TRWpdb1m+k8n8VATRtIgsp9ChBS1m2YbToHzR92KfhKOIBR4FV08x08o1mpYIcPJHfBpC3LdcQ==@kvack.org
X-Received: by 2002:a17:90b:1d45:b0:3a0:cca0:4a8c with SMTP id
 98e67ed59e1d1-3b197c817dbmr35589a91.7.1794415456305; Wed, 11 Nov 2026
 08:44:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110145241.536019-1-kas@kernel.org> <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org> <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
 <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner>
In-Reply-To: <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Nov 2026 08:43:53 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
X-Gm-Features: AclHuK9b6hltBFcCGqxpbtG8UmrJwldogvwXrVDW7-YQ5_XK3IWVlpv59flts7k
Message-ID: <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
To: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Amit Shah <amit@kernel.org>, 
	Jan Kara <jack@suse.cz>, "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Bernd Schubert <bschubert@ddn.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3em8asmsno1ykoyk5d7axn7e19fqoumg
X-Rspamd-Queue-Id: EE5DC40008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794415459-404940
X-HE-Meta: U2FsdGVkX1+ZaxaZ/yTGZKa5knpccZSEfh+YpJzASfWVzvxMOnnhyozR8+iF3j+SSDK4t9+qIq5NPzaMRNppHXHEisl2kFBZ4lPenbBMOzQNDB0JGwEExt9IG0Aj91XMY/SNw/qaCyty6THmXv2kQ9NIVGcYuCOHR3iG4QPjF5wZVOkCzCV4Lf4p/NmzJ2KuxXdjtSYcFbxPJbL2AuCBBO2oqQZ4r6B5vkNnjcD9+w3CCUaC/QRXlPr5Nc2ZLu2+zLOI5A22uaeeWmYuV2H8FVu0a/Thra2lhz76KncOFtthm7LrCiORbGjQwp5DTVAkVlUtOggz0tT8+TOKhlwYQLtThT3KzG63Dycn8LdZLaQ5GzgU0C5i5nThu5zhWdMZjJCUo+3t/yrrn/2l6v6lT4nuj+4SqomGFNpaBUyf3LOSQDB8uddVXGuE/VqLWbo5Dg6cI1zDRZQ/XaQg1anjIlcxvqEK0pafEGsn1HqOP2A+cWHbaG3rJbMlPdAuD5N3tKBNWEeyJUjd1mnTwVJ2UoMpDVKtvoslr0s1BwcigJEV8kOtOsBvP3EySdNM+9YBCXc04mZ78qHExFDKcEkuf6ZRes4P4p+N15IOAJksvkt35eGz6ZNN/7wxQm21he5oucOhsAveYRSvHyItYGt44v21/vZnkuJb7NJc+eGHueA0d3Ws8Z03jMRMpqvh6mJYCsbQTC5ZadCcBcQl5XG+rqP/2qdc6yvbGphOXyKo/Fjk/cbynXmqD+TeITcEqDfSfD9qsweTlAUMvXXoJd5W7HS1xFuN7CRZiKhBA5sQVNNrKtLU2fYN7heeGia8TJagWr2uWxnHan6Gwmm4JXFvUaLx0nLJZ+UoMgpN4dCKqPAzi2gK+hwSLz51z800XJ07pwkiXka7AFRBR/s7kDySEdQYCfNOY2d2iryP6DiJ1nTC65Ye/HyUTzWi3N+mlVrE74nHPQg99m1hmz9CW6Z
 XUlgNade
 4Hd19oIa7O/5t51h1RwTwioFqY0LOPWsAvP/KxfaRMy1UdN6PdJb0amrbyH7gYgcVD7/RqcICY9T3OAJJ27Egc07i7xOeQq9YpksH4JtgAA9V7qHOB3belsEHSzp9Zeyee94n3gW1ElRw5rki72EGQSiLC4zaFUTHII1xGwpJjL6SGMnGYN1Ve6Igi/aU/LcZYcBZbeB0U8CpIjxs0ICvbFAjORzOZuVZBbNvX3QAfyNSXkCmZPANVY9k1NyU2dTae/2GM7YVurfkBqPKWkc+BHfT18P0X8pjviTKUDS+Lp+5yplmGB8uz8NK6H3Zi0rtgGmrCYY+5x8jlOHAjdL1Tqv6UMZ9juIFp4tE8jqFi3eKAk+lleLRE7fKU7sqEy0KB9Nz1NusMqLt4d2Qyv7vIlier5qQEU1OlRgvWLOM/NrXQaQSVACZHNT95cNgY/8rQZVEPUJxnQR3dWFC+Hy8HWV8m5p3qA2cQtOLwO/iEDvRfSuRUfQQfixtb5KHBF+tVu6A+ZnyQe0gpR/YioJfCCZOeHZsJb6kBnita3oT/T8K34T1PnRVW+hmXMVqQSAccA4MuCQGTsfBzpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 at 05:42, Christian Brauner <brauner@kernel.org> wrote:
>
> So the fix below is what we've done before for pipes and I think it's
> the right thing to do here too. I put the following on vfs.fixes:

Please no.

> -       src = kmap_local_page(buf->page);
> -       memcpy(page_address(page) + offset, src + buf->offset, len);
> -       kunmap_local(src);

This boils down to one memcpy.

HIGHMEM is dead. Nobody sane uses it. It *will* go away. It's already
effectively never ever used.

There are some broken 32-bit arm setups that use it, and legacy museum
32-bit x86.

Don't make one memcpy() that can be inlined become this garbage:

> +       /* The buffer can span several pages of a compound page. */
> +       kv.iov_base = page_address(page) + offset;
> +       kv.iov_len = len;
> +       iov_iter_kvec(&to, ITER_DEST, &kv, 1, len);
> +       if (copy_page_to_iter(buf->page, buf->offset, len, &to) != len) {
> +               __free_page(page);
> +               return -EFAULT;
> +       }

just because of broken shit that nobody has ever complained about or ever hit.

              Linus

