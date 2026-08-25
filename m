Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A6E5C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 21:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5FFB6B0088; Tue, 25 Aug 2026 17:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10F96B008A; Tue, 25 Aug 2026 17:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00366B0095; Tue, 25 Aug 2026 17:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B33086B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:38:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DE501401E2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:38:42 +0000 (UTC)
X-FDA: 85141106484.17.A6F7862
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 34AB11C0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:38:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HONgP90j;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787693920;
	b=O/TqFq22f0mpp4/mmGgwFWDqQMRepXmRvgGiZ4ML8FQTI+7JwQ4TaFF/bAfRaA3cmVhCgI
	EmeAi6d19pLp4CUsz77olplPR6UmMX4Ww14jo1ruLydmpWu+y6h8n0gLMWAQwp4hrjpHab
	rNsu+DzjmWwphqN6VgainTtigHdA7I8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HONgP90j;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787693920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYoUB1Na3ffx4HMxwu5FpWOUsgMdosFB1oqn09IKv2s=;
	b=Wmz203Sgt2oQfHzdpZlKqllFwFjibrADCTP+Vj91SiPKCLChxz6SpcbweTSJLmAnBnUmE1
	JNU92TswNsBYxem5gVjWTVEuhXJEi/VsiplGnEYrOJw2NysimQk5wqFdz7JgjndL04KJj+
	SBdlV/rbksDKM4hT+F3TQw7xcuDfJUo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB11C601E9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAC71F00ACA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787693918;
	bh=sYoUB1Na3ffx4HMxwu5FpWOUsgMdosFB1oqn09IKv2s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HONgP90jayF3Ozs/LiRxwbrMin1KMPf2WUyAmBunxe71eOdMFFP8AI5kLwGogpePA
	 NaIs99jSWQYNvY/9R3j6wPDT7qJDTusdpEBxlpxy+RoXw5qnN3XR08cc42mwTqo5sJ
	 EvhfPma+AJVHSr4StJD9VYayNg6azovMEHDaNC4YZ/CorOsPzIqQJ0VRVQdti+0UM1
	 b2mRfAilTcpDkGjlTVFB5vE6GrgnRq5Dod7NEFuYb8CEmKp/BAmigdEKJj5s2gpaU/
	 TbWxk9X1ZOIQrXPuOP8tZUgmPED/0dyfw60e3jwwQgtp09Xy/xRWB4RWm/KOLUsBPK
	 wQiKhmGAA+E5Q==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-90cca401c89so20996d6.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:38:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrP+6FluhXZM5IphFttvekh10rU0Wupu6Wa6efjv89lsJxFlMrU4r/iYZIamAbizt9eFu+55eRU7Q==@kvack.org
X-Gm-Message-State: AFuF++kLBqCsxJg66Ktb894dvE5uzbWW9uUQjIm5tje8NkOHYA4v9gI5
	NVkC3Zqi/tKKK1asH0oA2Otf6jgcAdnrRn9Ai3AhYYt296w4uymBXJCMA5JMprnFf6Hc4ziAI9J
	NlX8nyRnQW9EJYuNTIsMFvlnQ+TAMxog=
X-Received: by 2002:a05:622a:5916:b0:51e:47a4:4851 with SMTP id
 d75a77b69052e-52e4228e096mr23708961cf.8.1787693917737; Tue, 25 Aug 2026
 14:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-2-baohua@kernel.org>
 <20260822014208.36934-1-lianux.mm@gmail.com>
In-Reply-To: <20260822014208.36934-1-lianux.mm@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 26 Aug 2026 05:38:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zWX52QBTvHUmGukVU18+JTnNZH-u7JgdPSJg5DQM7W4A@mail.gmail.com>
X-Gm-Features: AcwNN1UfuIc7jmzbpS-neuftdca88Od21UxZh2_WPlk0aVBfuNtlVvK9qPd8Epk
Message-ID: <CAGsJ_4zWX52QBTvHUmGukVU18+JTnNZH-u7JgdPSJg5DQM7W4A@mail.gmail.com>
Subject: Re: [PATCH 1/6] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
To: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 34AB11C0003
X-Stat-Signature: 5wtrswmi8y1if1kpcch7cob5f6z9htrf
X-Rspam-User: 
X-HE-Tag: 1787693920-861965
X-HE-Meta: U2FsdGVkX18HMqMhlNZwPxIAyjgTG+FcwWlNcThXxE6l0MK3T94XvIgCWpOwCo8p+fBq7XVJTDrFaZHhHK+dliInBCkMUQ12LIIZfUpa4crpzooagtsKjHn8PpKc7HUDwyJVecJF1kMOVuHZq1RoptBnoSwBBE/NrhlMoJ6OkhfbLKS+mVAoPlIhunqKy6ienWa5Gvzl+g+IiawmRmnlQuAGUcGSxWOb/x/eF+yjawgYbzaq1dNmsZKEBQbpGTjt/DpkFU6WuJZd5WAosLM9KMggEMAWgtDIBCs73yQXhkCNIOaUMcV0qfs0c9CHF72HBCwcEF6bLhPFKLDtS5PeglJ6jfAyXHy7TCjCA1AJkV6VLhL5OJ10MjBVo8OrDVH3uBnSqlxy3Yxvk5bf1mPQtOIIhklLVwVrQiNvWBNopwXbcsGSWQvnvhB6vycxTKW8QumWBjYk+uuYYNi06b1FbDTNPnMAZpQBH21PJD9RY18gE+oskG0DBaljRxOgqOJWrSH92jbktOthHP2WY3RSkuf44fGC/0TwiBGeCnltKfA4wIFCR4EwKfBuq3T3XmdrgJ3M8hETDv2VUnYagFch8z81Ul/4S3fk46qqq0xxV4KyfehiqDIsrdrHmyhWaJ8ibGbij9+VKJueGuePuwagKdEf5oE4qtneyTdFRYssSJIlk0j/wxDT0NkWU2xajH2olS18M1+/o/GhY6hhiIF4P9TrLgl/uTSl6K5k3b95uaNPjO2EYGjS1rElkqGC6NVLg7GSbxzZybK/MvsZScWG83N9oWGHSpTzlqk4+YVzsBiP3ZxymoOi36chBwofwdSXju0bgGMwNJwHX9D2M79jq2XgVK91vS3Xd2nqcHdgQUZ8VsY4wVMpFvMbIwQSlWKDp8cQPusPcfHHCRbs2wWgp+ENjgCp1yQaMoWc8tvqnMIiwYRfDJXks/HFVNdEFmCH7IgAY9hJ7+SssktVoIw
 QXv8AwtN
 jYO+7/KadkYHDYOxyhTF3Co9CQoMdlcpXXthKFj8jZN28J/SbMKpN7gBFrRYA43NU7AskHpEapHrx4ZyQf+UYU9PoVV5OD08fLmCNwVTo/QhPcy7GBegL1Xb+d9xf9F1+IUYwUmPIGHO89HzmWwlBhlieQXn+QoDIdQj18TyI7RdtEal3OgLpY2Qm4BYF2OUGINCpzzHwiS177CPatuarHgkWHC5/A8KZkQjCSYQLqs8fSg/QaOybjDz+n7KwAPj/hi6elX33k2lVfR4/ZDTblNniohW85dAkObWSKdwd7lEvM4U1N1AuAoFRsHHpHnJXbZLFzDuIzeZTHAxXbz6pjAKrySoqTzjGxiEYQYplYT1FltPmFqaopGBjAFKa1UGlToIk117LjDW++AVLhEo2z1B7YnRDxqj0aLmJVq/6zSK4/JI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 22, 2026 at 9:42=E2=80=AFAM Lian Wang (ProcessMission)
<lianux.mm@gmail.com> wrote:
>
> From: Lian Wang <lianux.mm@gmail.com>
>
> Hi Barry,
>
> A small nit:
>
> > +             unsigned long delta =3D 0;
>
> lrugen->nr_pages is a signed long and is documented as being able to
> transiently go negative while reset_batch_size() is pending. Could delta
> remain a long as well, so this arithmetic stays signed?

Thanks, Lian, for the review. Changing it from unsigned long to long
makes sense to me.

>
> In 2/6, where the declarations are combined, this could be:
>
>         unsigned long protected[MAX_NR_TIERS] =3D {};
>         long delta =3D 0;
>

Best Regards
Barry

