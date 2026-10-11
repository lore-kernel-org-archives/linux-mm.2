Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5573FCA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 01:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45F656B008C; Sat, 10 Oct 2026 21:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E9E86B0092; Sat, 10 Oct 2026 21:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DAD76B0095; Sat, 10 Oct 2026 21:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0302D6B008C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:23:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E8F2160580
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:23:32 +0000 (UTC)
X-FDA: 85308597864.30.0D011B2
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF3B720005
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 01:23:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=WqmPXieq;
	spf=pass (imf13.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791681810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NWM+eldm9EciYsTQn972KMZgMpvJjJhXLQrDig7no0=;
	b=zbq/Ioi6VwHYG5mxpAY5VegZWoGia3WxaCK0e4RtibWafG1Z5EnIJZeceru22YiLz6jyS2
	nGNXIVGTS1CrUshRMvRtFxdrCr+a2VjR1XJkwsUnAYGEIjQkPFACH8dl9aHns8PhpmbLXv
	g4BSyE3vZgV7cNuj47GHOEawa6eBHiY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=WqmPXieq;
	spf=pass (imf13.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791681810;
	b=yQXTmBez8/ItKp/7+wyKLTVk7i0Rd+PfmOfgM9k7YEB+BU5Koj7RsziXXfkut2DeYxCVCT
	R544DKuKh1v/WXBVCRTESh601nvt3/ttocVtAT4TaAxmANxnc38NOpBrk3CgZvVt5UCOi5
	u69hGX2X3ht01S6+nnlpWHvxxGWBb60=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Content-Transfer-Encoding:
	Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
	MIME-Version:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6NWM+eldm9EciYsTQn972KMZgMpvJjJhXLQrDig7no0=; t=1791681810; x=1792545810; 
	b=WqmPXieqM25eR9Lbno6Z6M7ibuDw9cWq5u4sji5wPPp3OQa+wi8WQS8iOxSHA2OnWIXogCfVhWA
	NXaoxHDr+1xgjWhfGzB9GghtDzoxY+SLdcDvI4wfC0z8V7gFsGpb5qHK0upyPm715e8eS7nbcgBXE
	rCzIDTwRGhEXWFxmd3aZDxJbTofahyNgXCYvWkjRlFKJj5TuLb46bW9JGCRweEPPJLXZ1VMzUoErJ
	GG9xcnHmOuNL0HDgEGWRDxIWWo9o4gsVCdmu4DQe9K2BCgt6NzhwvgF6XOWtc6G2DTpxZoCfuGY8B
	VFcdWpoOGLgANyQ9lqlEUQCjMgQfkPL62Cxg==;
Received: from mail-dy1-f171.google.com ([74.125.82.171])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xFiHi-008AUl-7R
	for linux-mm@kvack.org;
	Sat, 10 Oct 2026 21:23:30 -0400
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3282db206d3so3174087eec.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 18:23:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwolwXRVmqX5GC8MNewcibDvuyZZ/Tc/3jjOGqxBAVyPKO0F197mEIR7HPg+gyrvn0eAY6bzkfOow==@kvack.org
X-Gm-Message-State: AFq9FYIeSePuOiftXTMeqS//n6gdaKobDwzDC9ng7onLLsMEelyO05Si
	8+WGPfI7aYNScW+xjA0uChe1aO61kDPNIM1dLF3WlkSS2sjZaI0CaPuRkVEGgWsPOXFYciPwffD
	XzNJKNBMSiRqMDIMty/IqG1/fS17NFLs=
X-Received: by 2002:a05:701b:2092:20b0:16d:c848:d36e with SMTP id
 a92af1059eb24-16dc848d4ecmr5183168c88.13.1791681809283; Sat, 10 Oct 2026
 18:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <20261009051857.758182-1-nickolai@csail.mit.edu>
 <20261010162558.62abcd2ec967b009d0cb3bbb@linux-foundation.org>
 <CADGQE7G-PAiJ2W8uhFO_-e9GGtEPey=drfSqLfWdxXDys3mJNg@mail.gmail.com> <20261010181016.44f5e2883b6820bb32c04204@linux-foundation.org>
In-Reply-To: <20261010181016.44f5e2883b6820bb32c04204@linux-foundation.org>
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Sat, 10 Oct 2026 21:23:17 -0400
X-Gmail-Original-Message-ID: <CADGQE7F5SsRjqCAWJbwsT9P8+Uq-d_movTmiCM1ko=dg52kmCQ@mail.gmail.com>
X-Gm-Features: AclHuK_JytmvPKHV2JJKLmw644JZVHLd9i3B6iNoev1zmZ91lFgee4W5dbKHjvk
Message-ID: <CADGQE7F5SsRjqCAWJbwsT9P8+Uq-d_movTmiCM1ko=dg52kmCQ@mail.gmail.com>
Subject: Re: [PATCH] lib/plist: fix plist_requeue() shortcut inserting the
 node at the list head
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	I Hsin Cheng <richard120310@gmail.com>, Ching-Chun Huang <jserv@ccns.ncku.edu.tw>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AF3B720005
X-Rspam-User: 
X-Stat-Signature: 7mxpay98q4tr4bpx8xjc58g9ne1kpeee
X-HE-Tag: 1791681810-377095
X-HE-Meta: U2FsdGVkX1+2RnglCQ8mgy+DA3ScbHfhrEPdhyf7VLrR1m2bIZ+Ih8wkRPWYmlexDgWB5z1o6K+gzlsaBliKHq2ywoIUQLO/2ezwmvicFupxrKocyI5wIVuhqgwQOW+RjZVsq9ND3N1MYUIBSIrjMNQXBmYMKC3OYBK99iieFFrJ5K8QxsFdPK1pRUfpLFV795PwzOwTTHeBTZFK32ERjEXvztOffEM7/wonW+xkabAZmyxPaApkAhJOLftNMAA07vpY47FEzgpENQdrDraukLQXAAbIh6pIVFWv991rpEcRc7loKxZyBgDd77b9wLi46V+8unawq7TDgNpVRrXuMf5iD5TKPTlnRUx1S7eT/xpmuyb/J8mjY9/FiUjF7+N0tC1xnNmOQh6X4ITYNLkRUZu2wYeY1Z6JWzEEZO5VP+OtrtuIzrnFGFwFNWfGj98L6r4zvZVtP+ZR56s6BbeBkMIFIGc5KJSHqj2xsjanh5/QpVBhhfgtMfce3WCiEeJyvg7AKRcw406bZZyXWHZs5G7uVGEBoSn1T3BJfHWjTT2Y3lavwFzPr6JE4xcHHMoAr0Qc2K53O+1yN0dWqUm1JZQxCtV+M2itMTb2buoy+8OEAXV2/KVi48IwCRoOmJ5voD5UFHGvR9IQY6hqiTSs5tpsXNWLP5bbwORkr8DU+EU4owcXoMHUGQmWC+k3d7C7kwUo044Z6xC4rcHQUpCG1GvbJF4hgf1Tk9vuoqg0X4cNgpAplw11QcDWxLFNvprMXAHuVwuLQ9s2hu9dm4pzHQF8suDQcRl/6ofJ48vetGMYOu/u3goT5fj+Nw7DVrR3pAMZhTBPbt6h0mD1XatU7o42DxvfiVznvU9wNHnkAMzddCqjOk4BxbZrt9+JqZjao/XH3uU+V3GpU4y25Dq7Ib9s4YVaL2oXMO+mwkngdXMXja6ey1IVaanzT6GFKBzgY1K+W8N+rYUIBvqwFX1
 nE1txmdw
 X53SfbkGp0GYUnEiu7ka6IcAZHZkp5M8nl0uQqxzePD7eflCsyAaovMmhRj+dkVpQXoj4erWIRMLeUrO32SLEm1GWeCpWlTl/O8Nec0c30Nhf5w/T6WsUvh3JlkW8KMbpWubFLzjkr0rtFJljJsdEGLaZzsPwdtkjNgrndS4tC2D0OsATgVT98UagWv5uCqHt087XsQN81V11MK8GuvOxPkBku9Kw6DOTo8C+RkkSazRZvvjeGzzujWxG3ypleu1G7DGC5nr8mJ/aWgzEPE8WjbpDJ4LeXc2tkf6f61UG9eHWYuBjuLRLNmvy2WbOZEFZeADpap9tZ7bNuXYzbaTul5sEmRfxidp0uMZzEHMK4F+awN+KzQW39TTpxnWmSOTs06aKBO0ThNfANX3RU4/pZZeYQTdqo4WawOlwrp/7FUjqFyD23bbx3nevPUKpbvwerpJRNMvkxR68T3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 9:10=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> On Sat, 10 Oct 2026 19:33:46 -0400 Nickolai Zeldovich <nickolai@csail.mit=
.edu> wrote:
> > On Sat, Oct 10, 2026 at 7:26=E2=80=AFPM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> > > I recently queued a fix for this problem from Alex:
> > >         https://lore.kernel.org/20260903222456.1881786-1-handyhandyma=
n.adam@gmail.com
> > >
> > > The two patches are rather different.  Please review Alex's change an=
d
> > > and let us know of any alterations/improvements which you see.
> >
> > This patch is equivalent; I don't see any reason to prefer my fix
>
> Thanks.  Can I add your Reviewed-by:?

Sure, sounds good to me.

> > (except for the test case that might be helpful in catching
> > regressions).
>
> I like test cases and I take patches ;)

Sent just now.

Thanks,

Nickolai.

