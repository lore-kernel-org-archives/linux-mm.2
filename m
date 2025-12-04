Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D9FD206A1
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94E736B0088; Thu,  4 Dec 2025 09:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FEDD6B0089; Thu,  4 Dec 2025 09:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814566B008A; Thu,  4 Dec 2025 09:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7C36B0088
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:08:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC93AC0189
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:08:29 +0000 (UTC)
X-FDA: 84181968738.29.736ED8A
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id B919040008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:08:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MKraXiCK;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMOwkCCOXRmK+PmUi0fLo6U/u7b05fOR+uX/3TVEFPY=;
	b=FTSdKpWqxpnD6MW3ajpnNApSfxaAhZynbs8oJ0w8hPOycCEifXjMmzkWcopJwuRlBsqiJ2
	8XvG3oZbbn0HrrOU9aDUt9WxUqIwJq9moKl7DMiBlDmn0pWyH0DVggNWqW6+kkc6nIteBv
	ZM/GpN21j/nrE583NYADJiY75B1flY4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MKraXiCK;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857307; a=rsa-sha256;
	cv=none;
	b=icsmmgq1rh3BQ9rKiX0XQs3WkNIeen3Lx86+tq/TGLoIbpAa5pbfWm+O2LcT0yeK5lxKuo
	CCvePds838TAEM4aewrAXCHGmW1xR3xo13qQo9/GDBs8hjxF1Qea0vD+PaOZ5g8sJqLHaY
	6kTI3RtwWiDRxkmKWiJdHq0MTC2gAOE=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64149f78c0dso1414712a12.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764857306; x=1765462106; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMOwkCCOXRmK+PmUi0fLo6U/u7b05fOR+uX/3TVEFPY=;
        b=MKraXiCKVJaPyO+8H6Zuqa6rKukAL5BTIzzvZyunQIf0vhnylP95Mxra1q2JFf/+6d
         SAd1Yro03pLYRCVbFC5UursHEok/EH4iSLeTkzyewLNUD+cTxo7sVc/cnhRfe4CQtAry
         xtlon8NcVl7fFx3lpnOVY40UZTtWYRt6IjvCfVBlqO+cqXvjCkG0W0MjfDz2M1YGvh6/
         gq/G+zVA40ffTFv9uEn7sAKbPcp/VgeHOR39u9OU/P4faSv+QkfoUuDM0qZu8mZnOMYz
         TcvQj9HiipqG3iY6WKIM0AaQUB0aGIYUwN8QhdBji4V5/Gggpt/WXlQohRcrfSK6yvJy
         +xPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857306; x=1765462106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FMOwkCCOXRmK+PmUi0fLo6U/u7b05fOR+uX/3TVEFPY=;
        b=Pq4ki8dwRIJInN0TNx7gMlxOqMzKKk8JKv0UwHf5222PGquvka/YVeVZyGctfDQDYM
         6QS/niP0QQWulnT0ZvGAyhpGbrXBBXFWxZOJW42mPwI/Ay0up96MwlfU68Dnxucto5fI
         RhKQ9oYJXTChrQMbXx968YpAiWol/Qk1l1ARkAikkR0a+k5CBAhE0jiS9hhCx0szv3p+
         zYgyQw6lqlrtVcMZJjsEgvTI0oAI4Ri/49abz4E/0/aPQVARk0q17YPzeKgKPkf14L42
         2JF+F0aGyln4Isk4FLSHrYjRbQcUAbZ++gXtvEJMlywglNf6uE/Yg4nqWqkMBcvuTMH8
         MkhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjSYTR8U9xxV6pzUfelNcMOjvozTqEcexopZ3v4jpj7jB2M9wK58aIFhqMXjxi9ahk4Z53uJ7Y4w==@kvack.org
X-Gm-Message-State: AOJu0YyaGluIwctfFMAZ+AqB7nUkqi9v4vCxkXzSsv2naNocz5y9gf99
	G0qmF8z5RuLl2mF1Pt4+084+MPwGYMyKxscRC8CDt9Zwz0rjliER/v1DZlG1wcdXxqF3gvNcCqr
	gOuYsh/VPnjGwILm6sm7jhr+cWP6FVhCaazKSPakB6Q==
X-Gm-Gg: ASbGncv3gjVo5km0qESdM2PzszDWNcgrnao/lqh9ryHbMpMB/gv4NSCzxPy+4VlU/M5
	Irh+e8JR1Pvs2eeSxBLAFeRmiHRtGAJTow3JIHdNFK8eVelGyNshWCNny3zAryc3+IL67DIiXBY
	bT83RwjUkKMuZ2ZOtjGL4Ibgm8uKAWBbn5tGn3SJA7fsusbaMdivBGQtVzzDplqf8k3RaiygoNn
	PUBCxT1/aoJyuZKvfqfRbhIQ2iAIhhECtbAH8OqdXO+sIyMLNXNpdK3h85HRWWdwbKe
X-Google-Smtp-Source: AGHT+IFGS+c9kgy3VrG+JaO4AnhSSWyoIWGGHt2hc+Q8Rz7FLaoWan2qllB5kV6c4VqMD+jesGHl9lkqYWMu7rS3avg=
X-Received: by 2002:a17:907:3f8a:b0:b73:301c:b158 with SMTP id
 a640c23a62f3a-b79dbe71be1mr650789066b.6.1764857306070; Thu, 04 Dec 2025
 06:08:26 -0800 (PST)
MIME-Version: 1.0
References: <20251204094444.1030143-1-arnd@kernel.org>
In-Reply-To: <20251204094444.1030143-1-arnd@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 4 Dec 2025 09:07:49 -0500
X-Gm-Features: AWmQ_bn9CxYfkKHOlAeHrru5COa4pNCE4WNkwOB2cqOgsuFRcuxC2a_kdtrP-hk
Message-ID: <CA+CK2bASowj8quGMaUDsxpCKmhkqg0ySiuiAngty3z3zjbYFBw@mail.gmail.com>
Subject: Re: [PATCH] mm: shmem: avoid build warning for CONFIG_SHMEM=n
To: Arnd Bergmann <arnd@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Guo Weikang <guoweikang.kernel@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B919040008
X-Rspamd-Server: rspam11
X-Stat-Signature: nhfxy51e3dwseyf71qp3hqdjhkjijk1n
X-HE-Tag: 1764857307-637189
X-HE-Meta: U2FsdGVkX1+2mb35oeBeQYXLotNrdGBQoFblEqhqtP0c40TSx5PtiYpW4PqWHSMPUcwr9vp4zSNxzOpI5xfWXtl45MWlxlTIMNyZbu4bmerJkNsAw7gg6g+U9tJe6kAtuLEwu456eFtmeMjXhEk8hQHKr2E5DOpZlyND+9HPPhp36ggAx5/+QPp6vMLm+tTOmTPR1n2w+SiDSLO97ENj7tiCat/ZvSAMGOr+zaRYqW/Tqn2WJYLdhsZ7F4yoPs+mTPvQDMCrKQ0Fkyxndn8cN/8W548el+tDB+pLrBPoyhI3K+Bv2VRPPjIVgknLbZtk9De7KyS3umnhQWcKscrT5P2nukaRCsZw3CmWhJLpnhl+q2nyAyPfMwMWvI9egvUEqVWlgGjXCd6723pEwT0UUecI5jsQ0k+LTmGsw0tkB2M9x5HIbJuNUDXDCdYsQz8pm17uM7QGtHmjj5p5BW7kjsDhA7fBnI7EOwW40CsYJYRJ1Ifgn+o+5gSD3V6+Z9/2FgxOGSQGNkXqTJjeKkF8r6oth+9zC65kIlRi9zFOhsWPNcrrJn7ycf4r4UmqcWdy3itXugWC7W2m9s3TZhsLMVGWObq9E7o9ZeKJNyXaYMvqjC6SvFBo2GmFUH5P7VUC+3ngskNn1XvU0g3+5piV3ympMAcjC6iUy/jqe76vhET1jDNfLKgxX2OTb+nfNuPAYwhSnPcdhSSvtyq0lDvOjSCDsvv2t8MeeArl4dcia7jJRNS+fPTc+H9NsS0Y0RIrgKZ/tE5VPil18J6dkH0jsgSD0ouuYAx+oQhS3TQ5yohX8SPqeWvfu+vYglp5ZlAyzNFqSmPDUcKHlu+D0i+96LH54tOCN6zHmCyk9ehanjUp/hsJ+VV6Ov1damhNu2b7vNrUt7BZscQcSwGCsMLJsUk7qJD3PUjdTyF/x5b5Mf/38VcvSsurn6qbXEGG8SQUkXp5EFvUqIJhRdCsfLL
 U6UNnQpQ
 /6s92/d/G7XY9qO8Dz+DPolGpO/O9bIbBAsKUFvAUCVMsQT1t+ubQzHjNm+vEFMfPG0LNrZVLQNiHcebuLTkZ+Xnwv0w3bDDhJh5Oz3VIOzT5Z8b939GDdmEUn2Jxk5+jC2N54ikDLWhckVhsrwOqAnN1Se/Zoo5xJB+aB+wUYDCTItAmbFlWzjUlMiBQT0FP8RpsltVXnYNrkwCHyes5Wb0W3h7socXpNr9qoLS0EslF3LFyMnujiVm1VgrIuFNa/sTtvuBVKbFvkD51VQbhqmOsyhS2IwqtvawOgT981MjqJ7AGlqkVKUuRJgC7OISsI7W/G4IslC5hM5Km3cpIjlaMngG5Bt24JFZPIp/E4wm7yDSbWGJZ83VxIUm2Pxqjmq3o9mHqa2L8Z9hGa1TT7SgyHZfTqPulyF/c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 4:44=E2=80=AFAM Arnd Bergmann <arnd@kernel.org> wrot=
e:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The newly added 'flags' variable is unused and causes a warning if
> CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
> into does nothing:
>
> mm/shmem.c: In function '__shmem_file_setup':
> mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=3Dunused-vari=
able]
>  5816 |         unsigned long flags =3D (vm_flags & VM_NORESERVE) ? SHMEM=
_F_NORESERVE : 0;
>       |                       ^~~~~
>
> Replace the macro with an equivalent inline function to get the
> argument checking.
>
> Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flag=
s")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Thanks,
Pasha

