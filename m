Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF9E606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I7+niy5y
Received: by kanga.kvack.org (Postfix)
	id 65FFC6B05C2; Tue, 10 Nov 2026 03:11:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610596B05C4; Tue, 10 Nov 2026 03:11:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500396B05C5; Tue, 10 Nov 2026 03:11:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1586B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:11:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABDEFA085E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:11:47 +0000 (UTC)
X-FDA: 85418490654.04.39E42BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CCE5A100005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:11:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7+niy5y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794298305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6XKHkEPKtsOptLLp6CkrLlzFIFu7B8MPqkMARI4hXEU=;
	b=5SSMcESWRGAtOJ7Krqn7S3RUcdtYjCi77JRcQ+0tQhLXhyM/nd+EYoB3EEWYJuhH8ntrv6
	B1eMsYv5MfW84Y21xDK3PlYtx9mZ3HFae3CjJxAYEd8iJf7DPiP7RAOdSUz8xq2oxmPjSe
	buLkd7lIFbPMUiHTKj1VqX0CZFlrfb8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794298306;
	b=5tw0vHVXiKkhVse2g5HV+IvXQ0wNDMZGavkzn0f1dbfYDlRI3UFwIvJUUo6vHBj9AHbNSr
	9203JyS/ch8FCwKnXB7zhA6Ep0ntzMQ5JHgMYqsmw9T6XtCIGcIXqQKXmhoPnMExT5nl41
	i5f0BBocLeMbCK5+lCBaDNA3QvKi8hY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7+niy5y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B038E45859
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964031F008A1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794298304;
	bh=6XKHkEPKtsOptLLp6CkrLlzFIFu7B8MPqkMARI4hXEU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=I7+niy5yn7ysiyT/VBjM6NXG4+i7P/4VGRUpvP5ZIEEt/GJGGf7yjJrwp7WtMuLuy
	 Pspa2YrRE2g2epU7k6G14u6yYGsRHSJVOgnTBrplChcr1TfM/1kbgAijVWTcThK2sj
	 sE+UQM2lxZfynVvdzO26XYD0IkDzeyrledCRQYrawZQr9XPDmWSJtCaFBTkhqBns2Z
	 snU+076DS+Cgnerf/XdfHBiJhZFEBURlSLSRWC/OuBxmH8v9ZyJJyTX056a3rZQ0c6
	 4v8bMtBY1fZfJZ+RWaAV9or9YFGyS2abcin+h/yN50Kv3X5IljlLJBYY6BH21OP5U7
	 t2cW68t4s0kWg==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93efc0452b5so115856185a.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:11:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEtMGCSfI4x9mrthTRhDGa8EoQiZAozxGEUPCIzCFeEfJ/+HwJhIXt3EG8BX2XhDeH9cRTYJlib/Q==@kvack.org
X-Gm-Message-State: APuU4Z9g5bxhj+LP+IDKZ9UegIl9lPT+XxZiWYpr72edW4WyJDBbHZGu
	3Zw/5Fmho8M1h2yXZxyszi/LZFgMZHqj1YavXBo/Lc8PUVlC4fx5UWY/MESWAEXk+9A2NX4Dfam
	I9bd2p2Y4i3FdlyLNdbk87bgqYvXI0dw=
X-Received: by 2002:a05:620a:1728:b0:940:f224:5a69 with SMTP id
 af79cd13be357-9479f348f5bmr314297685a.65.1794298303673; Tue, 10 Nov 2026
 00:11:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org> <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 10 Nov 2026 16:11:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xXTRsn=Wf3j6u7QyNs4zRc+1i6MG45vtao=5gdQv8Pig@mail.gmail.com>
X-Gm-Features: AclHuK_7DysJ1y5_bnFyuAOrVgsW65eT05aJKGB8T07cT1zr_AQPphy0esTgfR0
Message-ID: <CAGsJ_4xXTRsn=Wf3j6u7QyNs4zRc+1i6MG45vtao=5gdQv8Pig@mail.gmail.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 31d4o3hxjnxqbhp1kc83m8qb6pnna45o
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCE5A100005
X-HE-Tag: 1794298305-493073
X-HE-Meta: U2FsdGVkX1+0njJUQ+ddoloNhOE7v4mRYILwiBRbK36yhzxe9TbvNakLTCd/brLG6b+8x1hwRpxI7ZHqYp6jkNtzbwv612NzMqYDUThAApicZIi+eeCwmg8C334y3YD7f4M2Bjwx/Gw2OdJ+t10aP6OkNH6qsZQsvkWpJmB8gxZdtGBx3B4gGaT5+0EDe/8hBC2VbaEPFTCF0vWMEEhWB6GX7+Fl+xycsq7835+iicbhk5djjUW7gYb7lpowvrlx/JjBJw2NFE86b4ddVm/gQe7OiEmXvTJg83sEDDpT4LMkxDp0Jbfok1flE35pNOK+CAf5bLG3YdgphchK1keNisVBKoemoFoC1ac8wuuVr3znFdwHa0tUFGHCwNISlYZ5ZBouIoU7iqNDQygZtGOmbRsgQ4+YMvFz5sao7ugmvxfvtJNKyBEo3BHOezTkscGGMH652HNFexQhShiJceETBwQCzRjlClIvvVyQg2JR94NDp6J+Xbg4Gf4V06pjB3l0JBlfM2Chn3tgtBp85fArWPq8CQpU81Z+m5HkEhb+q+bSdE7AkbZ6De37WJoqFTLIZct5sGXYF0VFZqVrvgy1/rzaUHRRqnD5N34Pt2ssaK9BiERVvWcOneOURe6IP/SRc4p2RTu33zdZL4TfikZO7/Fvn8X75l+krXvL3xPlQiFqYITW6yAvK7xNl/K06WTi3vW7M+j7uwF9Ec6s7B3uEBDNohOQpXI8UnnN7hbBPPNp8SUa9ee5FB1S1EblCoqL9kBWsKtFBV5tFoKrUfN2w4gTPywRhRgHQRRLbrat0XmvEq/Xr/b4eJbJggsI5nHxcYtRSHaNx79PruF7xd1qYOUqQkmCBbMbPCeXbVznCsGdhPfpRQ8W1qbBe7REpe4QQBdQmGdwy6ubChJoIPWyzQypnSbDOFsemHjxDulDZM9VYazKJC4b54Al5a3EM/Byvz1ncbjwFA3lldJpjqE
 nkZ5+O02
 aCylte3nFIRCBmbLXESow5zObMl7LLXjPZq18T3MBHzcX2fyc9qGS1sGs9sL4tPn/T1egJ4YGp5Z0hbVRpVSum4MxM4MN0dvyQ27qjjxQpA802bJYW9tbQUgLbsNsVy4b+1H8csdwvIm9cpSpuQYvlpz5J40LaU172itWkT73Sbpxoz0NvHVecIWCfGOXKysgiJ1drkYSXjQqKeAneYh0cwF9XQ0Gu/bZJ9ghARAz9pRnTe3Zn/xG99nxYFnjC9fYBY2TNSwpW9x9B4Hkzc29NTcAhY5VED5IXUseRi+QXm598D2i/Abplkp6NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 2:32=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> MGLRU is currently the only MM component without a dedicated component
> maintainer. Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more responsibility
> by officially taking care of it.
>
> Given that Kairui is already an established MM component maintainer in
> a related MM component (SWAP), add him as an MGLRU maintainer right away.
>
> For Barry, the idea is to transition him towards a component maintainer
> role over the coming months, starting by moving him to the top of the
> reviewer list.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Thanks very much to David for all his work on this.

I also want to thank Andrew, SJ, Qi, Baoquan, Muchun,
Baolin, Lance, Ridong, and Kairui for their encouragement
and kind words.

Acked-by: Barry Song <baohua@kernel.org>

Thanks,
Barry

