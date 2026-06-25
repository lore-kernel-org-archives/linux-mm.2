Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E973BCDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29056B00BB; Thu, 25 Jun 2026 06:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9026B00BC; Thu, 25 Jun 2026 06:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF12F6B00BD; Thu, 25 Jun 2026 06:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A65F06B00BB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:07:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3588FC2B80
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:07:31 +0000 (UTC)
X-FDA: 84918007902.22.0AFA409
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E4B640005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:07:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="o2x/0XO1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782382049;
	b=INIKT2uq+Ao9XYlnPVfUPe59y7S6aDyAVOQ5ALYqMP+v8M7ZpKswQa3vJtecymao05hB+2
	z0KFD4mUtbA1Yr2RqorhJXXjiejjiceIANFqI25oTv1gZRA+R9bR5g2ZXTYlgxWNjt4EZz
	cd0EkI90LTwvqr+gwUux4XYtRoMf+T4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782382049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRKcCwku1VbtJJEhFhz+Kf1u5xuWM/axT/2vwJWLaos=;
	b=IagF9/EWFqNykKA64YAjOe/OWxxbKx65WSOJ3hqxQjrBmdAB3p/BjR/MVu8q1ipn2oofw5
	gMcS832hMOtctZ9jdB1P89VaxmGwI9Ny/B8NSHuiNT2+hQrCYXmYO8oEQ9L+ezN8WN7tQJ
	gdHzV3kgUCc/XgdlK+YZ4bltNQvGUDY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="o2x/0XO1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABCC660221
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EE81F0155C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782382048;
	bh=JRKcCwku1VbtJJEhFhz+Kf1u5xuWM/axT/2vwJWLaos=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=o2x/0XO1xrRvf319YAiLAVMBX4BXD1ncJXyBMYgfFq4a0w4pQnpJ5bgMTXs3J27/n
	 FTtTRqrTi4lTZNpt8p4+X4HLj0iVvwKzZ7JXa92i2mNgbMoRWQU5TBpmB+35IdeNSY
	 lI+GaaarnUhFjjUdr2eIIjb1qsDlEvSkR5Xt+0wvIp7LeZRKxZiuZc9MOyLnOmd7we
	 HaETwwRJkf9H2RrWj4ZrbIW7soSd2dKY+96Vsz1+Na97Z3YOTVRFY7iG9R3ojDkjWi
	 rftx81cOqv4cUO8si2SBFX02bEbR5ZYU1r2FZ4devdrmhZPxX2UpkTmA4uGTwyOmk+
	 8X8oxlBL5t8mg==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9158643e538so160160485a.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:07:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+pgkPi5ue/T1SfJQVIPJhvKcMgs0WINXL98SVCrxlIQoyqwgVa5394YuZj0lOz5ZBl1vAQudExbg==@kvack.org
X-Gm-Message-State: AOJu0YybZM7ZUkohHGA/e8VCbqde5wWfz4/ueKbRn7J94BrI0mWf50De
	N8xoYBOjA+JqOMnFbk0ZlJAV4Dq2DEmNLxZ5NSKRonWDyv3eBvbLKlibsOiTz0Rj2p9sW8UkzXV
	CshP3u0WmKgWddQdm5Hs5NBpChiFqBZI=
X-Received: by 2002:a05:620a:1720:b0:920:56af:cef2 with SMTP id
 af79cd13be357-9293af9a8e7mr225785685a.25.1782382047433; Thu, 25 Jun 2026
 03:07:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260623024237.45990-1-qi.zheng@linux.dev> <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
 <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev> <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
 <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev> <dfe5d773-2992-448b-a6cb-ef633714a08f@kernel.org>
 <1d638906-6d64-4e57-a181-4b77683652b5@linux.dev> <b5c85cea-5daa-4690-ac41-a6f5aebd1555@kernel.org>
 <f18bf1b1-ccf7-4d77-9389-07311d2d1613@linux.dev>
In-Reply-To: <f18bf1b1-ccf7-4d77-9389-07311d2d1613@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 25 Jun 2026 18:07:15 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zwyaOtNkk8Xgqc3rNNE23XbU-kCB8oULqdGhpMERPsug@mail.gmail.com>
X-Gm-Features: AVVi8Cds3hyjYY1EEWV4vTH8VzylNNkIBPvgwWgSkKxNrZ0vwSNhmCzbjB5L9p8
Message-ID: <CAGsJ_4zwyaOtNkk8Xgqc3rNNE23XbU-kCB8oULqdGhpMERPsug@mail.gmail.com>
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg reparenting
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, akpm@linux-foundation.org, david@kernel.org, 
	kasong@tencent.com, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, 
	muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, 
	roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E4B640005
X-Rspam-User: 
X-Stat-Signature: j8etyj36heenjx7cwxh7mh16h33tipr3
X-HE-Tag: 1782382049-185640
X-HE-Meta: U2FsdGVkX1+k2MbYYd9VYHAnrbPMCOee2tgRgCK1566AM42mg3vUFFhZgNBB8ZgomSv26nm1qEo+4F9RJ056ZessRjZ3CSpXoZWEvYEuNL/R7jzaPOmjE9ITGSTznpWKy2BOYu2ZpgcNiUz0gWQC+dNCjd0GGMu7efn7Zcg9NLDtU/FXoSyAcTYGYxuOxEea5aT9ruR1+nvzrtmcJx39NHrMQpTmv22yCAgSfUIh54v6fVgXAW1h+MHgFq78haXQoMJI8jh+Lq+shtziibWCm5JIWD4l34TQrjqiKMpXNllsRAgme9CxZRZUJt7hB9tFBjBr237icpYstZx3/WJa1J+OfL3jNrtI2EUiDN3O3Qbxq542WEw0NVsn5EwRAJsANgOxUM+AeFrGTDfR3fpDqQYxMhxqZmia/ICFv/tZGyiGxlM/0Fl9h0M0P530v0vJbeDktFHhV4QqRz4Fu9o+GqFdNkf030sUbo+zMQTKoKgY6Mo2q+7kZDmuelIcrwPXJHDfx3wQSTZi+tQCGDPtNrAmzBYjfF15nvjujxRQfOxrHPIKT8LGZFVNJ8+PQjsSo3iuBFgLl2pdhIy/3g3pFR4Umya+jbw5sUfi7s+Bhj0OqoBSiRD0HlySRquE05z2VVPubyDNuhz/+8vI6wRT2ySCABXdjZYz8Oamt2nrMpiWhkjEtNSNEuAOiYQj5DUqVgHT7w+x5WOOYgLLN71YODJVS5hZnOYgzjRGo/426w2IwFLdM1rO9BcqEGrQSB8owKV7TIQ6iPDJb9jP1cz+XXLBTW4iaQzmrXhtuQcQbW//+gIRUIHJpteZpSCCh8yxrbbG481VAjMVQ7ZkLYy0uwOui+RsiguKDo197N4kYzG0NT43al0bV1Ig/c96IImpuVsbuiEzRov+I5/h5qU25gVhqidWQpR6UUfI0jHE0MnkAVmnRnAcXQ9WtU1Y88lmLocwZXurKKwKKGamyAw
 O0uhaiDu
 /yAwF3YD0S3h5o62bA4CHQrbQamIPDMZ6OvxMmjcDXl1ekGqV0StWbrgszJj7Af1lnNXVk2aG01W0+7UkOKsPOWwORKNMCWO5uloWGHBYjOz7KiT0EFsnIc+jm1qlXDyimpmutyCmAaGZqU3jkTMnt7CGXum3+BOPP9Q4sUmJEuSM/QeyC4N4IrV6eWb5lm4Yr83oOCDNTkZekfomph5ueNekGZ9X1eqyqwAA6pNtcmILEswe9Mz2qpy+4p3fThqwMsDec5LutsVtRltWLWqOFeqQ4++7aL4p4oQ/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 2:11=E2=80=AFPM Qi Zheng <qi.zheng@linux.dev> wrote=
:

[...]
> >>
> >> Does this make sense?
> >
> > Yes, looks good to me!
>
> OK, this sync method makes more sense as it doesn't require adding a
> new lrugen->reparente. I'll go with this method and update v3.
>
> Hi Barry and Baolin, what do you think? Since the sync method has been
> changed, I will temporarily drop your previous Reviewed-by tags in v3. ;)

Feel free to proceed with the new version and drop my tag :-)

Best Regards
Barry

