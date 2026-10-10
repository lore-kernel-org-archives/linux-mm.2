Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3BF2CA9ECA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 23:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09926B0088; Sat, 10 Oct 2026 19:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB316B008A; Sat, 10 Oct 2026 19:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0B96B008C; Sat, 10 Oct 2026 19:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A68E6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:34:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E122312059A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 23:34:01 +0000 (UTC)
X-FDA: 85308321882.18.582B473
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf07.hostedemail.com (Postfix) with ESMTP id DCDF440008
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 23:33:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=unithV+W;
	spf=pass (imf07.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791675240;
	b=ErurKFysEryJxzpypzpVliPeSag03fMWSIeOUkceSZ5bjbpozf4Ya3OjpMX61y1hO0s0fT
	vfqFSxrCJz4XtKyG/npEhOefYgAmJ36JgUQxzUtgqs3vl/lA/cNrOHJWyeLCZUBcexX2rc
	R5fnKRJyZwHEdpNdJwGLcBTqBEnpJKA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=unithV+W;
	spf=pass (imf07.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791675240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUJnoizHqRjV2lEHRvMaIyHFuZqZCjH0FTOcKYJEFGU=;
	b=cYBUCgs48KALxjQWeaX/Naw6+iuc61plmiNpb6xOwpYmPj3pf5Iz0vk7w/L17kjfsNg+Me
	AqR1J6fD+nsv/oYrwQ9V9eL+OnL0Y/kEcR+eAOR6FIEPzM58zVyL4TVtX5I3RKkgNKYoY/
	YEQTp2KwWCH3ohFxUvZRgM4D7q0v33g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Content-Transfer-Encoding:
	Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
	MIME-Version:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XUJnoizHqRjV2lEHRvMaIyHFuZqZCjH0FTOcKYJEFGU=; t=1791675239; x=1792539239; 
	b=unithV+WsGxCsYAZVk6xw0G80mgpZCJzEhCGmFHAei2KGlWHOSDCxt5tPgdLShRtmUyBO1WujP2
	v+MI8o4w9RuwJeZrY+YnJ/DGw5CTdbJI6sUaW+yfWkdiGY6k/wiWP954g9UsLxdLD2vLTMH5T4jbK
	i9e3rqbVl8rClYCxHg9Xgq+aXjf/5ak6FpbFHU9docCdEJpe0YStUs3g0UrvXU0TkeUeK1SmtBwu/
	JWB7tI3Y1LJRGz5Iq+YEWY0jxxH3byPanXvVf+PdS4mNqDmpr5cduJz7eMalSjIUoX6X8KgbkCuy3
	2sRYdsW5dx6A/rj+kM9cv8tv+v4JLN4p7a4A==;
Received: from mail-dl1-f44.google.com ([74.125.82.44])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xFgZj-007q4w-3H
	for linux-mm@kvack.org;
	Sat, 10 Oct 2026 19:33:59 -0400
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-15dd124bbe7so1725562c88.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:33:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwmuKRhRfEUe63WdTS8MB+gX5qjcnoELyq73I7LGQ6NPweTQNx7JVk0BK9MV/QYoN/Qz+txNDUFTw==@kvack.org
X-Gm-Message-State: AFq9FYLWeCPgIieGMkbGXe/DmYT9ef8H03a+XFdNaig+KTv0oYJXwn+o
	NTA8EiMKVHidIagVmfwEx9Wx78ysmkTyEaKlv1XnepYVNlT9TYoFrS9Zkd192LR2ReRrGw6KiI9
	VIvrVn66ToIcriyr7+4ndaK14gYeSzOo=
X-Received: by 2002:a05:701b:241a:b0:164:475f:1a07 with SMTP id
 a92af1059eb24-16a55f1e60bmr7781779c88.1.1791675237998; Sat, 10 Oct 2026
 16:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20261009051857.758182-1-nickolai@csail.mit.edu> <20261010162558.62abcd2ec967b009d0cb3bbb@linux-foundation.org>
In-Reply-To: <20261010162558.62abcd2ec967b009d0cb3bbb@linux-foundation.org>
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Sat, 10 Oct 2026 19:33:46 -0400
X-Gmail-Original-Message-ID: <CADGQE7G-PAiJ2W8uhFO_-e9GGtEPey=drfSqLfWdxXDys3mJNg@mail.gmail.com>
X-Gm-Features: AclHuK8NTVPdGlZpNuys5-JYOCzxE3B81f4B5GgR965MyMgqHe7NumhALMGGqqk
Message-ID: <CADGQE7G-PAiJ2W8uhFO_-e9GGtEPey=drfSqLfWdxXDys3mJNg@mail.gmail.com>
Subject: Re: [PATCH] lib/plist: fix plist_requeue() shortcut inserting the
 node at the list head
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	I Hsin Cheng <richard120310@gmail.com>, Ching-Chun Huang <jserv@ccns.ncku.edu.tw>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DCDF440008
X-Stat-Signature: 7tffauct19ydk53k4s7tb1j7jkm67xik
X-HE-Tag: 1791675239-981679
X-HE-Meta: U2FsdGVkX18+uutf6XFVY8P7vQqZ3t3wxh3hxufdDa+oZbJRDxcOk5zKk5ZoBMZk15fH/VDZhMosLYYjoCcNg71oKKMrEZiSF/J6lFPV0+mCOXTHkeElBfQ2rcw2RBbO85nClsdW5gLCmZI8ly6u3BEK3s+eUTbA6q02gdSbyyJkd0E/mFlXrpYnb8NeiBbHnZw7Bb7wC1D1sw8lWjqe3kUjzp+OYjLqnz0rqtDrZT9jsWyZ0k3MOTwqrOdbhPfjVGETec+hT1lx+1arEEevRkJ/hJOBz/ivtjTGlmyHoXTN/NHXRSB3OtURTExcTeECGADFMsSQotaH0iSmDEWwrTwjeVpozN5W+TdGB7hP/kb6Cs7EUfxUfxXsE+Cxghuoun7y9vW7rz+tS7Ar6gIODoenIDTWTi9/IlPjKu0glaxmrAKdhcYVaGu13H/ybhXmJ0siLIfCqeDu2t72PrmSl2DuzxzpOHpksTeDX1AYrjBWbKatK6aotmAEc8VatUlMb0anSx/sdZm6tj50v4h2ELigtcCLQhfCOBl7+MfKC4Ix/CBM7WphtoXYHS0qHoValZW5xD1cpBbyly/c618yLQQzkWixnqZVoCYG+PX7fwlV8/tJEhAMz+TVIxZVWkHn5TDRhJ0POrzNtnP3dgBrPZ4E7P1TL/uo85f7OEzcn3bOAktjclaJrMhetk9ScDjWIzR2HI0a7YjQTaeiuuHBtDhgkW3fKuuUKIyqv+bREmnd2/uenHTLtq739Yza86ixp/s1Ot5hQpz/pKoB/29jC/HnMgO2h6Dfkm7TeKP5RNt6KtZkXij9sAGXsdvot8/OFG4wG8JeG+d1WBZ07JlNXEnU0Qo/QjDb4epHsm0ay7SQAy9SGhNNnNWkGK1rs1ZQCwvBXeWvtWXmzP0gVdSxISkanFcW7PaHINr5y6oD6mFOtOxHXjVQsHMJIgmCEyPo/C1cxREeM4xuhlAX27i
 M78kg6J3
 Si0fm98WptCIMx2WipUJ4+A9xKc10xKFTTy58aj61JkhVkuw0Mz1pvXRC0N/fncZcTIZ9B7dHWjr2hwZITYgxrtBT2b6aKUNi0O4mag/DSDMFUZpNWxgykhIIjT+t9g421wZtzsJJ9NkL0x/9T48ZPOEx0Jko0DsUwLhbseSFtkY50fRfm5IjHyntnoGyyKr1ilNnJWUGstq6NuPUAa4eJAwZawVjqcFMwMKMKfrW6TNl51EABRw0n6//GEpqfSaIbHOT16gg7VsbAqEXMyqZ2HPkbqIz0zhbUrGgartbitnVjo+RYBeZdPf8enWrufZyZsKQq3vhmAmdO/f4Rf+G+P4xFEBvi+tBsFewTP6rRuPB70OgOpFrFdM2iARNYwHvkmJFJmlP4/evBfrbykfZtCULz887OeUc/3RrQHyuQjg0sKCpwaCxKIIfEqhKPfSVc1DN9YAcp/uuCKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 7:26=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> I recently queued a fix for this problem from Alex:
>         https://lore.kernel.org/20260903222456.1881786-1-handyhandyman.ad=
am@gmail.com
>
> The two patches are rather different.  Please review Alex's change and
> and let us know of any alterations/improvements which you see.

This patch is equivalent; I don't see any reason to prefer my fix
(except for the test case that might be helpful in catching
regressions).

Thanks,

Nickolai.

