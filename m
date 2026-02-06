Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D864EE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 22:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0C36B0089; Fri,  6 Feb 2026 17:37:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86DD66B0092; Fri,  6 Feb 2026 17:37:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A02E6B0093; Fri,  6 Feb 2026 17:37:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7006B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:37:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1038BC0FF8
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:37:53 +0000 (UTC)
X-FDA: 84415495626.23.B662565
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0688980005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:37:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CtjalNpz;
	spf=pass (imf02.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770417471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cacv21b2V9VURDvVULHeLUdzvx66P3ydxu2nFeKvxDM=;
	b=WqHGgtFhVXNMQ//S5JzRnbbCKUVnYs1R2umraYgaip7qlMrqDGvoc2YygnR+DpNs/X6l05
	Ov4DzsVDWeiHY5qqEvrR6Or3nR1eLIG/1ItFZHzKFwCnw73V3QG5TBUehZ6Km3fWyZZm6c
	JiqxpSXgh1gbeA3Bpikuo06M+6inE6Y=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CtjalNpz;
	spf=pass (imf02.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770417471; a=rsa-sha256;
	cv=pass;
	b=EYwXkeQpUWaFdjpH+QjrQmuuMgJIycl1MS3EZi/ZosORAb3IqBFhbDm+ldEOgCd2MsFyMj
	zMeCmZHWNUsuZ6uCK9k0R+OA0xxHKqJPxxHi05f3g0S36FRmls0JZN80jVZNXeKMk70QZo
	xRjHbRAAMerEDbyNOtyWCcVwFnRLnHw=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7d1890f7ee4so1698218a34.0
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 14:37:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770417470; cv=none;
        d=google.com; s=arc-20240605;
        b=QOpEO5E7hf/AsVj6CK3HnxhbpeaQA5VXu5QPJhEd5AM8BBJfqOv/RTAPGn6GTv97hI
         XFk2n+YqwScZCi/pv/8O1RlvsMIP7d7Lsz39DPpab5aQiEIdQpGmOO9mVCToAqIG56WS
         WC1goKGeNVpXKVzQl9n2uLuO/ISVOL4BNxLjYhv6KQHx/Vi4akhkA0KPG5jCbWW/cOkt
         6767U9Ux+kXwDUGt0rCKpu4rzvSb9rWDvMJpnS5bqe6MclI/x+5HcbzYfsXOjp7Njn3G
         q9Xdd64jjWTCOK3INTRZW4jKoitubRHDCC3sVJecrayyGysuT/e/2VhsxrSs7aup+Nes
         fUqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cacv21b2V9VURDvVULHeLUdzvx66P3ydxu2nFeKvxDM=;
        fh=Cnq3kVpcE0EnoEy1VVc60KiiG0OIyGC80gYVCYO3s3g=;
        b=VHMB67BZz2cFnTMrmwTgNRwfr6npqJv1G71UjrWULBul2iQD0iT4sbyIzI2q4IXrm5
         kqXLWWttTgzKK84IsaBKPDhAXfN6YxJHjLI7CD22TuNvjjCPw/NmcGe4QdLn3MrViBDj
         5uGZu1DVQh9thjZ/jdIVJ1iKhMD7CRnYOf3bITaNX8G2C0iuQS0XI5QpRFNKyXAKtgoG
         Kp4Smgjl2RSL4t4FR7ZfYeDwDoUAukemBqaaoKg61o+OGGUsmVhr+/GaU/tYd/gPMje5
         sRjR3DzRdAXc6MFL0PiGcmeOL8hUfPgSCGiPplna4WAqd1KTgXiLTqFQS4iy8eF0i44H
         ywnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770417470; x=1771022270; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cacv21b2V9VURDvVULHeLUdzvx66P3ydxu2nFeKvxDM=;
        b=CtjalNpzgousMp3r2w0rucQfMPVuTixry9LGp3Bk8IErabM47XAssVFdQtDIOh1af6
         8lLMAP8ZrNPzARqr+EqkoUjARMxssafBwNIZtvvuRyTTFLXs7/iqN9Tmq8nGTDO0ILG/
         ieHi5eadsY+WlZ9KLehxpXh9SdwGAyvnOt5Pr5iBAdjEiDSGDF959ro6CHzNKXsX4/PQ
         fTfWGqqCp1u76JHI6vfhLVL8Io8UZl0ZVdM79+zEwPlQ6Ud0YJWGo75Koi1OZInA9KU0
         1xiF7FJm1v8u8WtOswARq+AXp6cSuBm5Q6akwS90I77AHUn1+OPBdIeddLFneZCP1VTs
         ME6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770417470; x=1771022270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cacv21b2V9VURDvVULHeLUdzvx66P3ydxu2nFeKvxDM=;
        b=CN3AHrHPTssnOJXVsJseEPjrN8xbqlHwXTMy4TmKWpRqm962eihr+9cKHBv09D00DA
         5eBXKpd2CxR+VCtP39JRCLwYze7yNfHG4oboujtVezer8X0lLXOHg07K/BEAumeCH1E6
         uNLcc/HzrqYraESVjvdAMs3cHcSFhJSEUhu7yV/k3jccLJ0o0Bl2UmpLdHrT+cCNnfQo
         L8Js5+AxICFN9LdlwJ46cuvIRFSbHxgqqrSa2mds9u+RLAMUpSxrkX0lYQfYAwDQ8Qzg
         Oww8g2MJyFYVd+MBz5GA+6xaXOM51CQvXb/nuT2988ARIBS+6Hw7/x06WknUPcVkk44Y
         Y/Gw==
X-Gm-Message-State: AOJu0YySw+1HVCnrGXIZQmnp6alO/An3Fjh+ti+FwKjWWNPbXGMvidzE
	GBrDiIhkfIQSfmqrZWCNwh85UYP1OFfHmU1un3JH7TcPfHUhG+efpwqkfRDcoc2pEmkHNpwJSoY
	Q6vOY3Ut96Rfuv3M3zdCZ5W+qqlQ3Nvg=
X-Gm-Gg: AZuq6aLOO3o4Ra2LRn93pOkSmu0YM65R2P1gFQrDYKN/XXiyygauta++QgbtC2Qrj03
	0coZ+zpatMjpDk/S7bJmwDPEXYzmGGsw29pppkmKG60luDBBVimd6WeG2t9g2dk6iTyIQgFAy4d
	coYO6rGAFWjLIGnrmSIEbY2vAGugGEzuL4wPu82v7e0Kxc/bZV1TV9K+WKAYMGBuErk3Zzm/a/n
	913+3QOMXLnZjN5ZasH6j5VzVR5jd6R/y0bxVVEzwgZGhHOFhaO4mNJXa9H0b0R00QRVER1Yg==
X-Received: by 2002:a05:6830:6aa7:b0:7cf:cc2c:1d9f with SMTP id
 46e09a7af769-7d4646a97c0mr2354785a34.32.1770417470058; Fri, 06 Feb 2026
 14:37:50 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
 <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com> <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
 <CABXGCsOMzrQTsByYraNby_MXnTuYBNt2vbWu65KCGX6bmi11iQ@mail.gmail.com>
 <F36AF979-5BE3-4399-9420-F41A475EA87D@nvidia.com> <B6CDB0B7-CB9A-492E-90DA-F8D7E3B037E1@nvidia.com>
 <7C7CDFE7-914C-46CE-A127-B7D34304C166@nvidia.com> <4C3D8E3E-D9D6-4475-A122-FA0D930D7DAD@nvidia.com>
 <CABXGCsP2z6sbf_FYZjdxyLhfJZEaxz0_WrEeteS50GLyU=KQGA@mail.gmail.com>
In-Reply-To: <CABXGCsP2z6sbf_FYZjdxyLhfJZEaxz0_WrEeteS50GLyU=KQGA@mail.gmail.com>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Sat, 7 Feb 2026 03:37:37 +0500
X-Gm-Features: AZwV_QgwJjKjc-AgTrd1ux4zGKdLDvb618tkhqrDGZHWJIHQbK04Qor0t3Z5NFA
Message-ID: <CABXGCsNM8Oex-V3vFSUy3ftMw1fAweHZHQYzRHWU9M6gm7r-rw@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: clear page->private in split_page() for
 tail pages
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@suse.cz, 
	chrisl@kernel.org, kasong@tencent.com, hughd@google.com, 
	stable@vger.kernel.org, David Hildenbrand <david@kernel.org>, surenb@google.com, 
	Matthew Wilcox <willy@infradead.org>, mhocko@suse.com, hannes@cmpxchg.org, 
	jackmanb@google.com, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0688980005
X-Rspamd-Server: rspam07
X-Stat-Signature: a9jqk3hrtyh7u3r94pe7qz3z5rewkoji
X-HE-Tag: 1770417470-230317
X-HE-Meta: U2FsdGVkX1/GVZNLA1Eh9oWmTE2NLlbpJ/OzHlj9i8+my0oTrYHzeIkbOhes1GIw/3Nr+BsncNG6DFVJDzjWLePoNjFC47l8Jkh8hMpX5FP3Vc3+dntnhbuQmKEyde4k90ZqPE5FGhhSwRB0hX0xwhoPTZOe1CyaBgUz6JFLUrFvuq885I1/PlpQzJQ2OqNhkMldY356zAicDZAGgcfNwR0A+Y12ho01KnFs/IYaJVu9YnqAOWBfOghtfQc2frntegleM0WBzk3G1ol4jsFUTb7AwUtN+Vsa2ebpX/TPh3SW0vDzyMMuPWDvpjoZvBYOgFVE4FCEXwy+KWnTnanhKMx8aPZeAkiVWa6mpoDn2dojtw12cN8UWKRztyx9eXIiUframtelCvfo8Od7xNe9yCEm7XbLM5cqIWrvtEiFA7FHO9vTUOrXZt4TAy6sk1Ii3jfFmz0MAGZbRixny1YOcnHOBoDZGLB3bqfjC2FMS2EQaHTRtxK/mc0DmM2dWixqk3IQK7TV6CziHKKsOrM99WfDOb5XSG0tyxqQ2Pj9tnx2QA5Qh/qS1CM6ULjtQ9YVMiIsUDa5R4Y39qYZh2XmkyebdozK6gQE6WHG+F1Vd6mM36rtU5++kByZb9naYQqi1wlPX/wgk17IqBKY0pCUnLqRKfW20rAby65Am+f3c/yQ91iKwiHh1SZGpz0wCV6PKNRKEjuJ/xoxOnA+6eyDHFcWCQTXH8hUFwCCI1YE0NyH8aOB5S3nA+LIRskanpoywS6Ps14GV1t+sExrb8jKBABxEWxxsXvhEcqQvRp1+dn/bBrZtjp0S0ilk0YxfpFlBK0EOIy0HdFe6q3lUgTbml29S/SzTjZsGI9BzdezxedMBE37/z3fzyILYhzc5+X1H+ErOAlyf/0OxEd7JEFEVdHUoJl2Tn2eIRYY5PCbcaJq3tNTs8lrOkrvryye+TvX854kgAcXA8ywCQkSrHW
 0BrB1qgl
 RTQz9opUKoVrXan1lQH46pMe7/2Och2wPGvC5AzCJdJ3en5is84XPC73lH4IihDRHt79jJ91tqCTMK9TWV6jGfN+ByHJAL422skIbnHYstGg2VS1wWdI+M1LfOF6KHXM7AFk+ntipZ1i5kJw3e6ulZJhDTcJp7kg+Z2o6HbU0mWuSyil+1YFUUfsodu7Ih/i8qKo5ZgXSFyyfTucz8I0WbY5VakDuc9CAyxSIkP1ejrn0ubpaRx11JAAho3ywUeZ+qZKvG32TwjIPlxxyIYlS0l9bPCSD2Ft49CvAc4RsLO5YcrQjZqe0k9bzho/3mBPrnh2qoQcnmE2/yF/8r7FOCVsCVzPkzSBdjjcrK8ejZmyxhBrXQjrUcSbgwAnD9i56KIP+bWMuaHVaJa5G8urponNG1MQ2TlyxaSynXuLOwJgA5S8FL5PFm2Zn3Fs/5vqxIWr6nQaZMuQCePc3/p18Do6Xvjwksx9X0V6kZNjin54YJtiKjRhJ/Ii3ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 7, 2026 at 3:16=E2=80=AFAM Mikhail Gavrilov
<mikhail.v.gavrilov@gmail.com> wrote:
>
> Hi Zi,
> Thanks for the deep investigation!
> So the actual culprit is KASAN's kasan_save_stack() leaving non-zero
> page->private.
> That explains why it only reproduces with KASAN enabled.
> Looking at the code, kasan_save_stack() doesn't seem to use
> page->private directly - it goes through stack_depot. Is stack_depot
> the actual culprit?
> Happy to help investigate further if needed.
> Regarding the fix location - even if we fix KASAN/stack_depot,
> split_page() clearing page->private still seems like the right
> defensive fix.
> The contract for split_page() is that it produces independent usable
> pages, and page->private being clean is part of that.
> Other code could potentially leave stale values too.
> I can share my .config if still needed, but it sounds like you've
> already reproduced it.
>

I think I found it. Looking at mm/internal.h:811, prep_compound_tail()
clears page->private for tail pages,
but it's only called for compound pages (__GFP_COMP).
Before commit 3b8000ae185c, vmalloc used __GFP_COMP, so tail pages got
their page->private cleared via prep_compound_tail().
After that commit dropped __GFP_COMP, tail pages keep stale values
from buddy allocator (which uses page->private for order).
So the stale value comes from buddy allocator's set_buddy_order() at
mm/page_alloc.c:755,
and __del_page_from_free_list() at line 898 only clears the head page's pri=
vate.
This confirms the split_page() fix is the right place - it ensures
tail pages are properly initialized for independent use after
splitting.

--=20
Best Regards,
Mike Gavrilov.

