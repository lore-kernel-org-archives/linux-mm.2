Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D661E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506CA6B0088; Wed, 18 Feb 2026 03:22:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4606B0089; Wed, 18 Feb 2026 03:22:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396436B008A; Wed, 18 Feb 2026 03:22:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 25A856B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:22:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A82C51A024F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:22:09 +0000 (UTC)
X-FDA: 84456884778.23.6996052
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id C5AB5140005
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:22:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lPrasF0h;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771402927; a=rsa-sha256;
	cv=pass;
	b=WtkFrFqf75NvuTav5yj8n6wcMg1huoHMoXT0SJ3TRVy9NsD3GH2o5/IidVtpK2Y2ZVwaLe
	MlDz4kxz++mfQ3uzuB5KhGYFpztnjIW6Jo2GAMTOxd+6ucLSKgn7yxkQv7VIV/bapuulC+
	pXNEsh4CFH+vSYjkMz9/Yv1fHW0NF8k=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lPrasF0h;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771402927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VwAoqmz66WeIU23esW8xdZMDlNsUNI3Eyt5WAil5ec=;
	b=VWVxFmvop33cO+MMTVcLkGIbIOp57tovIG7Cjesh9UtNRTkr3f6Lily5UKCEhjLi+BI/oc
	/rWi3iVWxww2l8rQ2ytmeEiCn1F8XylvCy1ev38vpkHo0lnZ+gnTG0fiFXroS/FXhix1Kw
	0Fu91BahnBCkQBsIzsryrHi+g9tg3Us=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-897023602b1so69263406d6.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:22:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771402927; cv=none;
        d=google.com; s=arc-20240605;
        b=QveIQdFEQtLGg5sgEPkv8TVRgLLLSfrHdK9fNmxi4lhG90jB6LdLPSqh1Y1f9owt0B
         AK2s0Rv7XJKAg1NNR1EhtR1T/cV5wgo8GrxJTLQ5Y3IHsnyGdfnC1xgzo9+Nb9wNiOik
         drqBdMIJ9ps6ekflkOcpdRP1G+fpJGPbv3M1+Q8mi9G/iPpA53E75gSwQ8JKf78WuVzc
         QsAOnGHT4hYbn7WZ+m0E7BwSkqp5Yrcb5yFsQs5Sp5O++msPBEzMYRJnmhHtumkICDq/
         KiIvbOJcrCm7LvXa56l25mjkIlKqoGpYlvupkfntBuj8ZJ5H6e3fYxKmA40Crfpq9xpN
         pTsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0VwAoqmz66WeIU23esW8xdZMDlNsUNI3Eyt5WAil5ec=;
        fh=ax0SVDDNj9e0avQJCZXKE/RdhH5t7AkPo7KIZY3RsYk=;
        b=JWVoCDnmDSm2zEpfwQ2QHUD7U2N924ehex88ccnHeWR7+QOpwGQtsInYKKPMVXzrhF
         Lg3joD56wRTQK+ICHhkatT9QCOUMGhJ9P/Z8eZD2Rqg5meZa/hrJgsoJOMEvwdsSxkhq
         jFV8VECnfFNixJn6lKDA/oi8N0InworiUTzBet6NRjPcdi/X83bONZx0HxgB0opIg3sP
         UOz+U4GeobQVRWQKIQ9C8m3Vv9s1rvlcQKMUi3HvW7CF8QEvfrG0ZynozoD9xwWKn6Uj
         cgVx2Z2D1Kl2EdgStnKrXzj5EkdKuGJZ5OTqneibto1QdIvnTSiOrt5YkkkaTO2kxb9W
         h9fA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771402927; x=1772007727; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VwAoqmz66WeIU23esW8xdZMDlNsUNI3Eyt5WAil5ec=;
        b=lPrasF0hAbgTdWljp5G+dmFMo9kdm+yVFnQLenfvxFtgz+eIkye+zzoeE6ngcYaLYA
         oYHt7W/HMNxzsYvVsoAzpAiXBcQIoRkn6WECL4JlZo+eCb1kYUz6Zy0pVof+CINnr5Tf
         PVgAE+QdVdqQBp8leUs+ujdDvlB+HVOLCBhmedHMfkchmEAFNjHuGv36tIbEpOT4TbWZ
         Z2YRwI+N62gt45G0LmNcqyUw8k2yv1ZoEUVyQ3xyHWmhC2Ic7Fz9bvUczRhkQJArMW73
         tIKzaDcJ1aX0+owZAfYoDtMkqCYOEaLwj1BwHOxtVsQXGjQh4Vs0iYfRimR9nHPCu5FJ
         +F7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771402927; x=1772007727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0VwAoqmz66WeIU23esW8xdZMDlNsUNI3Eyt5WAil5ec=;
        b=RH0W4wIMCSfG8/VkFqFM3aYLwtoT85L0FyUPjYF8lyr2etjJTbjUjMcTy72s1+44WO
         /5uohbi8fxg1s4820Izy3undHBYpyxJqQHvWdyEo9+Ng9/TZWQWK6dSnKmc3D0DlBQYn
         G0WDRFxpAeMmNWwBU+I5Popbt6FTB2UAm8UzbqGfo3dMOETyhXwjJl3o0SWPXtXOPSFV
         4kC5dNMrYeEMFQG0Yt3LrTVCni+0m8X7tRxP+SxSkyy/2qUjCCd2MuJDHPEW34y5S3zz
         XRfRlsvl5GAeZEbE+ASxbXMwME1wTj88v7ZNOemv0pcafH0+wt2CXswl1ch24wDHukA4
         AsUQ==
X-Gm-Message-State: AOJu0YzxbiOS8qnalAnxALQmC0Z8y4rnaezcuZyPiwBX71uKTXBboTtl
	zgntcfOCtrqKITRsb0tHxl60XbRLUVXM0AG7dq0KV9hKrpgXfKVKqqqu09PfZk/wJWV7kY9NVPK
	d7mpLLcbWRTPm0z0efmq54kpDR6S8r5hoI5lL
X-Gm-Gg: AZuq6aJvI1AC0WYL8avTVm8OWaiFA63vLfs3QFq4KpDJu2E1CBXeMkaMmYsHav620oI
	lXZrX/P6RSZm0P572Kt2DBHu6ozPYagZ0HRRFATJjpCTUHEruJmoX1XW1rAmVG9n5bsUYe6QesF
	IP6j2bRF67flgdwfJqlnokDdHbIc67sHAvxXHJ/+/1LzBzndS0SLo6dfwpfa1+KlvPi2s+dWFn2
	rMlEAQw3VdzB3NFFG485TsBpFzA5GJ/3iTF3qmxAstpqwJ402R86RItY14jyIy+IcvsBheEAmiy
	CoPanQ==
X-Received: by 2002:a05:6214:1c85:b0:896:f910:c906 with SMTP id
 6a1803df08f44-8995811af93mr11500986d6.66.1771402926552; Wed, 18 Feb 2026
 00:22:06 -0800 (PST)
MIME-Version: 1.0
References: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com> <20260216-hibernate-perf-v4-2-1ba9f0bf1ec9@tencent.com>
In-Reply-To: <20260216-hibernate-perf-v4-2-1ba9f0bf1ec9@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 18 Feb 2026 16:21:55 +0800
X-Gm-Features: AaiRm53oR7JEByBnQ7WayK0ocGjk6XfMhYuZuHIES33oMMJ7Hockf9ku4FZ0lhQ
Message-ID: <CAGsJ_4z83AvzDNXFOY7UftOAkPcK+6AoR2rE_2rzQLTqx400eA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm, swap: reduce indention for hibernate
 allocation helper
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Carsten Grohmann <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dqnmznojrehaqcik6c38djpm54iosuar
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C5AB5140005
X-HE-Tag: 1771402927-116686
X-HE-Meta: U2FsdGVkX1/wWyg7gpOeJKQ+M8AvaPKGtnqgw09KnfhXI78rLbPH24kfSxLPYEY+kabApvEj+ZvJYXWWAm7s6+lVKGZHlHJfZrd81389R9fWFDLi+Tzd7HJhWtGvsB91O3/HnY09ocOUap55Pn9vusFzlUVNyNkx812lPQsbldSPBfvwa23/PSYTMnz3PN/cK1oT2NIs6VhzMjRB9WuO1p4Kfipf7q2Qfn4UW2uF+nUFijINtFfUn47hU6sTUw+JBFOdwlvgZkwPVdRQPfZ8c5VyN6kSt5nQMuXi0xIb5NBYwcHj+t2BRhO65o1nRAcGot5RNs2J87CvYzbr24iCB5fCUJdO3jTXPgfbUt+zxxz3j+Kp2uaXKGJbtgoU+wNAYR5WJH13ecEZQIxfpxwmLFwMf4kmf4xas2KtTESBoUJDOihCUXS5RMrosvnx37syqqlwgwFeeYzDIFGfCa8fn/4F+RKoU7z6npzCn1wX2xRx6ujjDvxr7NIF4o7TkEiiHOpSABhqhQp3UFYuYt30rrJkobIhc0G3Ta9vUMB+YhX7UjBnDZrw8qbu9Gb0X5KUJkOnvhYQXPkjZ+9JrccNZ54Bl0ZEtJKBLwLCzwD3LSXrgTMXipz8hd04a+FHXFfJXvQPk545/VRvaevIh8537f9ima58DHD7b4r1QRIfd1Q6gMWcUaXT7IoyZcDwKn8zt+h6PCs30GanDkXkbhPrlitITYjdciqzVxhy4cjg+y4rIC1lgF056fKQrg4b1NM4UFrVgqvk9e/ofFbYnp0t7rwPGWmWZPgOnNMDMI63En9O16MWpXfe1lufgFQIw/FiUlFU6i/tjIxfZGtYW+2yzwzMKF7h4Q0DkXGD1o7pZGG6z8hDUmBS+bqSJ/JAb0PMippApvcNlN4arguz32jXxYzSsnPauBzG/tQx9IrvCd3PAP9o/GSGSjkZxqmktLxAv5T8d37MK3m11/bHlvR
 EhTsTaXE
 bzHaasy6JYdEwAxBPG3WaGUH/7GXaJIZv/YIvJCzBxvZVpQq5hVECvlVDeGXG11UEUT7vmDaUbYjtRfv6ddcn+O830ctH+ATLm4ojCdV1yhrulnqhxqM1tnYmLkE7Gmz3jOIGqHKut4/rBgJBVdhgIVGNTFP8cZWOQlsZDUig61B/QEs4Wz/bCFWx6YJs2ihy1Anx8hkzJXIyNpMJza60q+0hbRcvipAPMhwVPFTDkVzsWgzuoXTB8waN6Gjvk8i9g02EMLTR/AyYrG4FTH5O/k/vU/upymeluXbl/ssTIKBSaDf6TMXE8E9uJ/Pi1bTSHz8e3R7ibV6vtnKvinUal7LF5+UzIn+R5YtNNhLeWY7BTLYUEcs9/7Bss9NZbTb5074SXfMoOCO67C8+MDdaZMKWGabBG4aAXPqB6IH8dFJdhUI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 10:58=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
[...]
> +       /* Return empty entry if device is not usable (swapoff or full) *=
/

I feel like swap full only affects the swap_avail_head /
swap_available list. Does it also make
get_swap_device_info() return false?

> +       if (!si || !get_swap_device_info(si))
> +               return entry;

Best Regards
Barry

