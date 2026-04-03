Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E96D6E8538B
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 17:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC7E6B008C; Fri,  3 Apr 2026 13:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD786B0092; Fri,  3 Apr 2026 13:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3A86B0093; Fri,  3 Apr 2026 13:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9556B008C
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 13:16:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C110BC1FFE
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:16:56 +0000 (UTC)
X-FDA: 84617899632.01.5EE159D
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id A4990C000D
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:16:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qBUmisBs;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775236614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1SyoVLAt1yCyzm5+Yd3lOzM3kjZo/TmY4bzd+hRNO48=;
	b=vL/4IHPBirq6Eg/eD9HD+rELLtrAnzerrdWGL6jI6PjYbquij99jAacMsJgsBsKIksiMg2
	Ul0F0lFoOaEJSDwPWvH8h2pfJ0KujcirslXv+ny6aLPRD12cKdygEOT6qIyxeGZbSZqu+v
	KaKV4WOJ65rutin/l2Zhm8P6z121UT4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qBUmisBs;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775236614; a=rsa-sha256;
	cv=pass;
	b=yqzQy9RLj8irxDFBDQmf98mAH3TSVaiP2LPHP/wVAWar/5+/9dQoNpt7c/k2qPzgpPRn5E
	u84bqVb7MLB3rDG9IS/bTNEoxa3+5veQLjU9yms7Km1uzib1fDd/XhZyOol3wihBU9GxBu
	b4c69pOvC5hgmYA5RqCCw0bT7mM0tjE=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d17bb1c65so1196107f8f.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 10:16:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775236613; cv=none;
        d=google.com; s=arc-20240605;
        b=kWuiBfkFghK4WpP66Zk7Cw9jyCPDef05GlyV4jR7Ckr3Ene6Sv1LfBad8zRUqH24Si
         xw1ctAR4rcmG81MIa37dvCAuw5OPxa39sgJtuJ4ERSEQQXQn9YXhlqmVi12j6IWt+KGX
         Qb0JZrmrUfdS14VYN5Y7KSwwHOArYSzaBw6qLHrltl8h7HC0MduVGw5fQ0NB4JEAqAZE
         I7UQpuxLNP4FGg8jsbO2t0dDyO63XXYeWx3QUn2UE6cHmwJF8rPRnpbIHaN7GnAzixid
         Km7BxxZ0bNFBJA6OQCepvwX9W4VGrXJBHA1pFHqfxRw9CeZ4kUkjc5VAM0tKozC6AJ1V
         jMEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1SyoVLAt1yCyzm5+Yd3lOzM3kjZo/TmY4bzd+hRNO48=;
        fh=mpKFx2VnLKylqaXgTSSXfi3e1vTGGoM5Mj7K4Zra8Ss=;
        b=PW+xp4DF/dWFU02kBDqwUSOOOFplIcqfO2OH4kbwmqq7TL+MT4SC54hVw387UBePch
         cCKjJM3zL4LUofC1+dz17Cw2PKk/SjnqnkQU3e4y0QjCFlAaR8IKQ6F+rB/eoZgDAeNm
         qppe3tNEjcNgcjlIVVurRAG73zd798/B3dM/iYGcha610cXInQYgeN/cskbRIL4BYCIa
         RPwdG4PSiCEYqdvREmmAWdC30SaFPpcXaZUH2fsQrlO/xMIoqSz86E2zxh4605jMoCzn
         KC50zalSteMTh2r/gPOm7Gidj+uuC9qvw99lcFTQEe61D+jxt61Qzz/2YmzAuzCi8HMt
         GT+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775236613; x=1775841413; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1SyoVLAt1yCyzm5+Yd3lOzM3kjZo/TmY4bzd+hRNO48=;
        b=qBUmisBsKssNkNhron7vpQfr6sCBviN2pe9C2RDPNJwLWCnkuBmvPsmH8c5KUUlNJ7
         Yu40IUTvohUzQHBCN05pblNVmhss3eQkC/6uv9TPBbrHb0AFohEDxhyg/zM2nQanUPHC
         YfFbgRsyujcJ4z7HRGKEbesvuSFNxYA3VnfCxK7rkMWqB9YqE0Nm/g92R2/uGE73goeB
         2IGcBc7D2ZWyehA72D/o+PORMafnoJ1SmT7sbL5zwPTpsDncFo+U8YvOBOOZ7UdD+TFQ
         iave54TttKQ9dHkrUbRAA/dU0ByvORcnE3J1sV+qKXuFXMv4jaEVkQ1OeVWs1uXo0h/g
         N+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775236613; x=1775841413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1SyoVLAt1yCyzm5+Yd3lOzM3kjZo/TmY4bzd+hRNO48=;
        b=KjSLrOBhR/1dSfq9HQYgCBxCRcxyyCcz2WfyhAPcEpy/g82a0L+fzhLz38AG6pUKKn
         LT+N5zhLQGcniLuOuocwiSzigQ1KwjeI4XLWi6c+FhAAukRbVMMPqN4UbJazb40A9zeR
         wP1hEjjgG73PoegZtv1fYiap+PRjpitIN4G0UqcIRPdb0ccTfxHUQAeQuP6pwH07WvdS
         WLg0fwDUh+2Iry1kLTKeGbXYmh7bZU8ZlKd8NkToIxIHTjxheZQgfqKdwoMH4WlJb0E5
         moo9NnkV1HLrb9iLm0UHoeSQzniMauOlhktnEP4jZ3G0snE9ElLA5uajqQy58AjshWvO
         e2hw==
X-Forwarded-Encrypted: i=1; AJvYcCX2Rp4RHkcYp6LNFmusvYCcNyoYUH82XAGyRCIOQZPs80+jp85Cqss8xd2X6/CB+moKxkg93l6Xyg==@kvack.org
X-Gm-Message-State: AOJu0Yywj9WTBJPqmfBc3d3qczM6vwyNzyyKJsPWkRJwpQx+NkMtkHkg
	LN8mbGo2D4nZPkPH0/W3S61vIQqDlw5UsxBRetb1cqz9CQvJbgdFJEumBG7YiYT4BlCth7pXU/7
	g8uup0I8/FYnfza3eB/V8R3VIiro6GeQ=
X-Gm-Gg: AeBDiesfPz2wDBOqQyNpi0KJIMr+BiXwKSc/h02w9a5tSY6G/NXKLMQSsn225s1sPSN
	x5Pvwx3TZO9UZ4fBK74ClMgUcIxr9CYmnecxXgRSA7eYTdC+cefQo54li97wSFxjIkRSAhQRcIK
	5igl/QYjDcyTaqeqvXA1Usn/eIL9ORxW7b9+gG+AdK4yC29KJjE2chTPDe3kr2PWCJ0TY+ikVnF
	MML2Z9HH9MmH/4vrmjXY6WR8ONObr5BiKRMuN/zr2ONpzhkM6GnpJtNmKdX8W/zUvl94BOzCGhz
	W+l0MCvWyBHsNoPSSeDWunYlqeJLxo2lXnCQ41N9locunoeJZQ==
X-Received: by 2002:a05:6000:2885:b0:43b:87bf:89cc with SMTP id
 ffacd0b85a97d-43d292f9ab0mr6063228f8f.49.1775236612678; Fri, 03 Apr 2026
 10:16:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260402063714.55124-1-liwang@redhat.com> <20260402063714.55124-6-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-6-liwang@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 3 Apr 2026 10:16:40 -0700
X-Gm-Features: AQROBzB0e0tCl_YCjgHALlhPlXxgnQULvs8SWo3GWsE0zwlBRZHXMDg93N-xH90
Message-ID: <CAKEwX=PVQD7i796z0unVDp3M9k9tZrWEzPTsE5hCL=s=zBna4Q@mail.gmail.com>
Subject: Re: [PATCH v6 5/8] selftests/cgroup: replace hardcoded page size
 values in test_zswap
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, rppt@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, yosry@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, 
	mhocko@suse.com, shuah@kernel.org, chengming.zhou@linux.dev, 
	longman@redhat.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A4990C000D
X-Stat-Signature: zzumwzn48y1oeefxnzk38u1u3srdf3nf
X-Rspamd-Server: rspam06
X-HE-Tag: 1775236614-966733
X-HE-Meta: U2FsdGVkX19YDq0JLOtFvnQt3Bo4uFJid4+F3n6fa87XylwjZ3f7hZ5ZjvgsaSTw/QpZ0fifYd6SG6FamHAnt1EnDrAoAFk101mveOelJ296EXb2UheleHtOL+i3WuioXjZmccYTKAgfYwcPhLMNFgEm293QjK+SEMzPjkkQjAa2GP5QyV1OuJpE8czHRu2CH5FLw26JkLw8dBm64Lc7azj620UU0PYb0qp3aXRcCfF2660PMRZ0w1qXsLKkfIaG7rByU2bnq6EQ1FnTmWr2RL46iHrND3z2Tql4THm3N20Z8WIjRLU8wZYIsMsAzpr/pL6kUxsDsnpBoMTRfNEQxLaFxl1HNyLqPrt/Ui/ui0DQXzKbDQ/bmxxaG26WXqlnJPGeOSegA3Wq2c1Hc1siYlqMplzA096xN3MtHgZ4YVUlp94svm56IbiFIVRlYlA/Cc4G7+CxVx18fy03hRiX0vwtL2VqNCRLLJMkENPAH3iBd+1IQIumdz7Yfx2/pY3IEnsrW9n6dbkjfnVjK7b3tJTEKKomLt5Fu5Pypv7rF2I0y1Rah2sY7Bozp9k4thHOT55xcTJh/RpLN74w+7GIrsQqkCgiFIVoOF0wnCCfWR7ZmH5ePlfNzkMASp7rEaRb/QwXS6Dr3RGM3qzsjiOZAqF9DsCId27h671BgDs5wDJLtw4qP3ySg0KQ0IhWWGmU626hK313v+wXV959oZlzpVvjT0s8HpT66EGDX2FG9V3qZQ0AhNmnhcshLTzxYj5L5swTAe6NHmXuEZs+crYMbDYMUfb3JHnDx/fJTGInMxKPljBiQmkcyqM02CcJCej2ohk3S8lcL0FkXSHDhFP3KlIr004dBX/Sxl57ViwvA8IrYnWSFGHyjki1SAuViDf0rVbbh7htdfLqYmVpA8n2noICcp9Uc9tjixCiWjmhPh8kUfxFt7KxtADGOEjT4E5pFicwWTaDus1MLpj3R6C
 jLZ52F0J
 ANhQVkNJaAB7+riLxFHczSltbMie7TFgrPBY3F/OoXmnMM4ZCIdO2lTFYen4ANAtHSxQ4yeF/ScdPOvDsHMZm4q6mHAfWovWqm9kZBFbxJfA7rFeCRrsboRFr1LhV8xVbdyo3vR/kDzl5eX1qkShvcVWNm3ZH3eotl+14U2QrPOdi5hGWTjTLfsD+bUFxXCQz+i9iMVPRB6ljzsNIU8xOu+sGD/3GtcJlyOwFOO6n/Y/kDyhiPWNr5Ol7CWS3UdAX/FF/DOEIhnFeH3101tFff7E+Y5RRkq2N/nZOv0HTDbWSLNxazCmHuRogJhcnFLn2VI0QrW9zvq1ebWEq9gQ2v+gPD6ZgxLCGly1STCqnCtxxXhOMiSeLQF5buW1pHkglE9TaslyHNyT+es33N/xOW5/3TgVmD7ctZzjrYcrWxJm/ZEOs8XSXOd+mhC+tO1VfbOSFHVT1qBzFGMgGglThrS+XpjZl4y324059XFzZjk5CgPP3l0wpDDGdSSdSTHWJCcpzIx3cMwlYSSb6g53UZ92IjsH02SJRN5HWwtgR7VSMjUUAj9SnJ6ZDX6wPbADFFl3zOHE5FZKp5d5lEvPm8AEZxIBvkfLCIdsN45G1Rf5VfEhb9kOpQUTMo38oQMYtRBme
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 11:38=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> test_zswap uses hardcoded values of 4095 and 4096 throughout as page
> stride and page size, which are only correct on systems with a 4K page
> size. On architectures with larger pages (e.g., 64K on arm64 or ppc64),
> these constants cause memory to be touched at sub-page granularity,
> leading to inefficient access patterns and incorrect page count
> calculations, which can cause test failures.
>
> Replace all hardcoded 4095 and 4096 values with a global pagesize
> variable initialized from sysconf(_SC_PAGESIZE) at startup, and remove
> the redundant local sysconf() calls scattered across individual
> functions. No functional change on 4K page size systems.
>
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Yosry Ahmed <yosry@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

