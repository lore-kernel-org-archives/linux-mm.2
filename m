Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419B1606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=kDOnTvee
Received: by kanga.kvack.org (Postfix)
	id 623A76B05B3; Wed, 11 Nov 2026 04:02:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4CA6B05B5; Wed, 11 Nov 2026 04:02:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3D96B05B6; Wed, 11 Nov 2026 04:02:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5626B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:02:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B137080250
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:02:29 +0000 (UTC)
X-FDA: 85422247218.29.5843084
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7239C40006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:02:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=kDOnTvee;
	spf=pass (imf12.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.181 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794387747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjyYgf5Mt5Oaaa+hEYrZohiloVo+c5H01zKLrOs5Ypw=;
	b=CLJBS0Lcingqw6ouhcu/TKIvhKpUPsWWfzWl6dBmyw4KA2klAJMtHO0wwqkaBcbmmOUSQ/
	px3M2dnafsYao7U1M+fA9l5mRl1B8Q2uRaxOLe8TFICf1iHtsAHZuRIq/tq+l8OsQK/BoW
	fXQtHAhA+kKPF0opRVpe45tKcswETco=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794387747;
	b=IdRVffIUJhdM9ugvarDZSGNzBUGrlURSCOfNHqhSH98BfYjHgOlhs/WttL9f8vtdjAdYUq
	nDM6wArJZ/pdFRGDYFNrQunmfeYw6n2/tEa2O4OdNeA+zGgSRHawAdFoxfaJIGN+0UYsLM
	3Sg14wdfZGP5I2iwffZDjmjP7fpR+fc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=kDOnTvee;
	spf=pass (imf12.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.181 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53bb57f1310so32804481cf.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:02:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794387746; cv=none;
        d=google.com; s=arc-20260327;
        b=swSTfmgo2pmykYbDu8jzoVn0OUKRZSDlMwlt5H3bEn8c4RWQUDHP5tFNNIbpg+qn7d
         yZxgj9ipTV5u3dhzE67i1tnwcnezrIKT5hmnPY0ZiMp1sR5gZ7Dy0cpKQgmE/f07lVwh
         e6/aJM4tOnjxcOC3rJYvvLCeW8Z8Ql5L3Lr7WOEC5Uw/hMk4R2v+kaC4UMeaCNKATh+Q
         NKxSCrLCaJERl/b5E1+qANiQ9crtjvJBQTeDO5SdIQkhiAeXOd5wLYtjZFIkg+8kJvFR
         vgAywrM8TIpr++pVvVXDrWNleZeN/CqtsDnKER2tRmCwC6BIvq1ETx/OSevepFCdgJ8t
         d9sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IjyYgf5Mt5Oaaa+hEYrZohiloVo+c5H01zKLrOs5Ypw=;
        fh=oBWFRaAfTpxhpkhTQPgIi6h1vXZaZtG74+JAUYlnKBw=;
        b=IW3x9TjuYc5ZQUSOAAqFXJG7b9OL1OzXymtf+VP1bQmSIOo8PDcVh/RqaxRQF66iWg
         t88UEG3knA875vg1DvP/eJcAn8OCmVajz7XLuVCkX02KPxBeQaTtO2Mh3XTFYNBfF0dZ
         Br/XwWfW6O4zDS+eK6SKzpJDucaLzNq0klb0HN0QWBq9A68aGPhGlBHm2uRcdQNzBx76
         WoC2MD29JlB8p2I9VtKsow3RBMf4C1M4hwT3SYDUFteVqOufnlCG7kR76F994bRfv/nI
         2NFta3ofgPljHrr5hg9+jamwe2Ck7CVLsSdmftZ/h1k9LzMPebNs1weq+Jls1kVjs4/4
         0TQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1794387746; x=1794992546; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IjyYgf5Mt5Oaaa+hEYrZohiloVo+c5H01zKLrOs5Ypw=;
        b=kDOnTvee5aZt+Gll8wMVyDZMGJFa9/LOcFvN3qRlIYPQ4tm0Ddt8EyZpaS+ic97q/3
         oA+VwalEYoe0bla3lxmr1pstCWm7tXLbOkXttzFMcm/LJhs7hKid5+lrqzb4NhrIFUsy
         fLZidZorHDGI3FrflHHo7apP7NvHjRhzw4DZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794387746; x=1794992546;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IjyYgf5Mt5Oaaa+hEYrZohiloVo+c5H01zKLrOs5Ypw=;
        b=p2d+OKlPdGl9+Xao2yrXDA9h/D4rn7vBoZq202j/EUzczWm4SB/xcyrGLhTMIeXeip
         kMn4rPFwXY4LYpSxMaVVh9wMdRq6kg7BqURblwU4eVYb5u09lfqmS6dUdYFJWPY9sWcI
         Yr1wiKS6GMJFCIPI3mm3m2Xc+lv/EfVWtPCDW2jLOA1lM5rswJg8p98WKNd3JOFffeAw
         W1vOmglZxTdqBT5LVU//z9opFReHfdeYMhlSWFy6tRv2Oz5neNht7qHDPBWLifZOS9+C
         tMqq3xbSID3zYpSoXE6JBs2LcpbLjq3t6OqcNASgb4K0WXn2WH8KWGK8AN4DELu0ChBP
         BQhg==
X-Forwarded-Encrypted: i=1; AL+hErHkEXDUjWFy4CkzdRKFA+84eDMq2sY5hzz9Km0AT9BnEHJ/g+GcVqCPjab1Z6CaS1NdTgAuLvnOlA==@kvack.org
X-Gm-Message-State: APuU4Z/ywfaFab7b76yNjK4waEOhnjCtNxQmQH9l/V7U3bJlEqYbLmjS
	iUzTTVW36f7rrpNORst9j22foeNFcSXwkyAIyUF4Y5YojGPm+ayaNoodUBJeKOM4pWjp++QhWiV
	2B6U7mxqR4rt7VGEAVFV67QA6pOvx9ABHwBQ/BHPLBQ==
X-Gm-Gg: AYBFou0cF+1ldR9/rpAno9DUT6A5LldKGjwnOtusGF26wjCNfOJf1Qkabq2Fz2v+/1A
	GgVEu9Th8lZIVo+j8ABhXmrSwwwt0ghQeWZ5OmQmMxX1+5qULV435UUmGUTqun+eY8Svja+akcA
	Yw44NQLWJ0/3LP10nryS5vuQShnpkVwiZn38GJZp9Br8FwFfqBiIgDtsBhjws5yARQ0qa6OGgbv
	k1dgQA/Q91TDP5M7TRFMoY4/JLGQavHCvTsFf3POlhZuJM9/5DcRknUTJKHEfq4HrS5sYsJPlzJ
	LFbdPpvxttF6XSm7e1j8HSodYxI/nwCz+uL+MzR03xlviYEvacfZYvl1HYcIUAdLpZTK+TRSxGI
	HwExfph/HfBhd56YlMSaHVg0sr6wfgLrFZ1fLCg9Upise6+Y4bFBOjfY1mjYFWp3x5g==
X-Received: by 2002:a05:622a:34d:b0:536:8f5a:64a with SMTP id
 d75a77b69052e-556c222b82bmr24946931cf.63.1794387746372; Wed, 11 Nov 2026
 01:02:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110145241.536019-1-kas@kernel.org> <20261110145241.536019-3-kas@kernel.org>
In-Reply-To: <20261110145241.536019-3-kas@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Nov 2026 10:02:15 +0100
X-Gm-Features: AclHuK9XqiIqd0G6zWinytDup_EFg0rRz4_cn9sSXLX9jTiH3KRFdGlFPrXk02Q
Message-ID: <CAJfpegvEeGN073FbaCRnhMeX8RHrckSxmFjkpdoyea2EuRf+zg@mail.gmail.com>
Subject: Re: [PATCH 2/4] fuse: don't move pipe buffers into the page cache
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Amit Shah <amit@kernel.org>, Jan Kara <jack@suse.cz>, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Bernd Schubert <bschubert@ddn.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: bzwzutwhrgr66qrtssugh9ugsf54jfbs
X-Rspamd-Queue-Id: 7239C40006
X-Rspam-User: 
X-HE-Tag: 1794387747-648124
X-HE-Meta: U2FsdGVkX18ggGx731vWCJ94CFJRtm7ql75w9gW1+GMfmkXYrC1l2zYWL8QzS4WjoKUlLYex8oya9bLikuvTcOg7gB3QldIjW45Z2OgtAPudRg1+tZWZmTvrtBUXdKPGwoXnqDVVBjFdHqoWodSSkaLXdCqUFSCPAhWows1nMBhFtMRocAc/HhX+8sL5ThjWdfOM3QF+qMSG2J6mhqqKgG/db4Ek7CEBdNFO60tSSYq8oMEQpTah8WlYf996AI8kojvUb03Ah9VT3qkacEtlCOHHIutqRFDrboPVg5lrKuoaRJga2Uq+2DF3CH5M8xufin2ALOg6xos1ILovp+BkFHwjtIhaQLNjHS8+3/PyAKjSM1evTTws5OBgUlU8KTAA20w1BeE/b4KIaXtbEHXtIK7btIqK9BmX79mSba1bTHnDX8XDPK/eGKloY7G6/F9+YeFkriOacVu5Wbpv6GAFuH8Rx5NjqYAq91KkOpZbqiofBV9RJBJnDNE9Q7vC6fkO+j4xmGP1sWuP3KO5Ef7CnPZ3e68B6R/pdjEt85STQvxVyAV0rWRKNRAxvCJB9ZbAgF9UX0H/9fw8M19aVkdw06kAHpo5uj/JR3/Xsw1LOlmYeJLhxEfrFosslm5xTsChc2oBH3DCc7ydjIQnazu+Y65bqfFNxNI5oTTJzaO/u7M0EX4gUK8mt5nIszb1WXMRFPYyOgbWMLQE4yRd3dFRRDl2dDt7zqaGyXH41ZcImhETYq3VAnbkIo4XGsurhtw6VZuMWuwRMsfsyIYnc+YDiVtoVAOZOHtG234wlGUVc+MOqw4CCewBUW9BXHRV/o2rERru0ekIAfFlz2XD2ORKfZIir1MTRjQqOlyOW1jQx3bLHVFyfIG7R9SX3WMIlNmdfTsfvn6mlQrge5v/IYDK13PIpR+T5qO9Hp3iZh1vBXDWSdAdU08u7ThX8EsWCl2LxwWe7bNJKQuAFMnUrdg
 JpSCl91n
 juBufZeSpFCly00fSkD4Yim/fziTkFGQakSibIrDbmLfLBFuwwkJyJZflnW3NiDXga4Fp/lR/XFEaGi9gtFkqjCRGvQ89xII2rNeL97nfknm+rh7lsrkl9nnJsZegtGo93L0JP9dB+b7tkzAM4UQe/psUH9Uklfdin9aBX/fPOMP/BhWAm0tMWElVzeypC1dkWW7Pt8ogVoqfkb2GebCMd049+RMs5PaZDbQKLI452PEZ4fqM9GsCSnlWAESTRNwmQ5Gl2TN5wu4ZjOcuToXPe1TqgNJhhNp++GS7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 at 15:53, Kiryl Shutsemau (Meta) <kas@kernel.org> wrote:
>
> A splice() into /dev/fuse with SPLICE_F_MOVE lets the reply to a read
> request steal full pages from the pipe.  Each stolen page replaces, in
> the fuse file's page cache, the folio that the request allocated.  The
> page can be a page cache folio of another file, a page written into the
> pipe, or a gifted user page.
>
> Always copy.  The server sees the same data, and the move was a hint
> that splice() never promised to honour.

Did some research and looks like this feature is not used by any major project.

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos

