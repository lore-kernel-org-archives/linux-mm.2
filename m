Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD09A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ceTqtg98
Received: by kanga.kvack.org (Postfix)
	id E29796B05B5; Thu, 12 Nov 2026 06:55:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8F66B05B8; Thu, 12 Nov 2026 06:55:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF236B05BA; Thu, 12 Nov 2026 06:55:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A31D66B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:55:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 419A6A6FDC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:55:58 +0000 (UTC)
X-FDA: 85426313196.18.50B53EA
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F69880002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:55:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ceTqtg98;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9NIZBLJNCk3VF8bguUf3mZiur03yP583DFsDhIKC8I=;
	b=VPHcU8X3/vJn+LOx7TLzjfABXmjylLRX9kEhyDXNrAW/TmcsB2sxxlFwLd92FDBUENPW9s
	ALJlYdPnwb02TUcApp6t8l2xKmp28TO3J0SLdFdYWV3R/shMyoA4kfGSOx/KeSimridm7N
	LdV+yxDgpV5tqHYlMId0EAt7OaJ9bbo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ceTqtg98;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794484556;
	b=6rXzdfTRs99TSffyN0U+Bf+OT0TZ+dV+OnOWiWpSwK1lhgwTm/Lkb2ECLeYOnUQgKwccqp
	P+wxFb9xW/zT4sZtqBarTHvknrOmX0myuJFPEhXzIyveFEx73LgE+60fNPk+vzmxVrIdfP
	h8/8bpbROHGuDrwABGU1KtmWYG04C/U=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-679334baa1fso5631373d50.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:55:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794484555; cv=none;
        d=google.com; s=arc-20260327;
        b=jIkTc2cwUE4fnCXpI1HHBS5tKpJ9TXPCdDBfjS06A8rUZpNZfVlflmI3Tw/cBB35Ba
         lVT+JZNVsToVVWeBjESaKai9P1TGFYFoopQF1CO1tjo/Wj+qLevK6Ty0b/4NHQwK9YBX
         eZ2xS+eV+F5G1JT6KmPAb6cBUFsT5SVtDKyUFvOY7a2Kov/xwZNZQITXUI3t5hyDkFWG
         goeSAadzme39PZ8VRsVp/4bcTkhwe12TqDFYH1kV21PStVNlijELvT6y/ToBufBgMiVx
         pxoFrgB8kQY4F6uLWH9GqgQvv4bV34PdAY23yHNoQWjPGqzUfd2XoJfpgTr+QcePCeC5
         k4jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H9NIZBLJNCk3VF8bguUf3mZiur03yP583DFsDhIKC8I=;
        fh=3Etbt/q0F+091QTEoDh8HLscP/ijhkYX7FyEuabuA/Y=;
        b=k7m5ChmA8ydj4MrI2q03kisQbOvzRdBQiFgxjgEV64xbL/6+iniJWeUEa4/O+WgaKr
         ftulZzEhjMUNSnmZNv1IQ+9P87kJE+EAP0KA1ZqQVCWwPUNq6i8tBkJcFxjngsTvVI5z
         5FSo5CgQPgESqt5emy40+Kb/uL1QZb7+o9W6v6bgtT846FMLpjPDwU5HY5dYTTkZQn0i
         d9VvUG6mbnxWmsTOeoZoYUDdwefH+ZRb+svl9pq8R91/RK2sHA/vc75mFo61UOIWAKL2
         2ApLQA73N2cHmeFtaRZCiaUhrnkKy8nagcZjk2eaiMy1PIk5khI+BaNio8btmZaszDvY
         un7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794484555; x=1795089355; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H9NIZBLJNCk3VF8bguUf3mZiur03yP583DFsDhIKC8I=;
        b=ceTqtg983YqC7e9RDi+ejK8MLcxrB1DCLvMR92Nf1lNpQTTg3shGZkE6mL6NFZjIfV
         qMjtKYGb+ztokqyyE9WRqOJftsOKX6tEg3okx5ZMRau61OgskbC6vP6pIHbi4cgWt6yP
         OeG4jJSM2kOK/na++4HejXzdMXxtY4ZCnwvZ6hbX1XqwJFqwo+yBKz4iCrVxb0p2EesE
         e5ITK23xTXh/XzY204oPG0n3y8aKk95TLOZcA1qKSFhI/9cTkKnW3HpNITVdU/CkY7F4
         wwx8Ee+1il0bl/uHx5ncUZ4oYilvJOoEepjHA6Vd/S2y68I/NRs0ME+JQvGplVDHOAN/
         Jg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794484555; x=1795089355;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H9NIZBLJNCk3VF8bguUf3mZiur03yP583DFsDhIKC8I=;
        b=tt3g+ulv7peVMr/AfmOOEOFjivkkFbXPP9SfZg+AKadWbV1GsOP7tCvfFVwkR1set9
         hrXdoHINJgFdXyxcMfEq0m+0cZ3iyLFp+y90bGOSWgo40jW8jeRkWF47/Y0wnmMxdh4t
         q72RdMKzESUCvHijim5yowS+BWynAT6yWoFZcd/rKWATJFrun7UCL4LhJvtcKSGFs7q8
         aTj7rbp2kRc4LvjbdkIrR9+4PeBGTPzMR2R1pwE/TqV/wQdB0ekD6/IjAG4Kdx2EjOIQ
         r56EZjGZ+AVHDyeN2lgKHLFyj8QXHGt3/SYTu4StXaPsyQcCMtWXxy2UjIhe4ecPTcuh
         qPIg==
X-Forwarded-Encrypted: i=1; AL+hErEZOnh4YhaXL0nrRNGTAXWIKYKWqeM8WJfKFs020w1Fx32bCCxY7P5AwfsvcglXoCKOWFBaV6YvoQ==@kvack.org
X-Gm-Message-State: APuU4Z8Sj27kLnAI6LrEMMgE8pJs3/jUnjT/1L2h5CMVg4UvfDOZQWOb
	zVr9Fn7JYm0YO06c1Czo1USOJArBdoBsqoniHEhMFFKzJS+lFSaSJAUfAjyW98VDO6e+bLd31gp
	KyoA44FgMEFfG0Uaf1RQjdTkQqjlvj9A=
X-Gm-Gg: AYBFou3h7G4tv9F+Kr+fXyznO8ijGSMD5mZ8fGf3Rfzp+8WvagXHE0OkC1jlDmnAMJ8
	wkWNa0weMzfu+AIUC/U18uERGQpeRC24fXMqNhN8vJlZWGeKckB/69MIX4+KqGA+88ytTuNnMGl
	uAYSvHFEcDUopM81jgC2UOsqH8r7UT8cMdYFmdAQ0EnrUqTUscjOJqjoSJKmSg5VGqTutW+ODc7
	7Ja6VmRoQkTqzcF6L/oZNjPENSV2QuykG/pq1iw5Uht+bxT2qLl+3uStSLS8bxsis0WhSBucPTk
	OBm06nuimlS0GcPcbYAzO0hcP+paBjwXUAY2+9yeHF2JJ0by3iw9mrIOjlOlK1fTvZWrhEy8rt8
	Yc5T1cijUUPZ4wxC3VjMusUYmF/qdVDeCbAGUGjZSdKaH992cd9loV/dkv2TXa0T+Hw==
X-Received: by 2002:a05:690e:1381:b0:67b:fa48:40c6 with SMTP id
 956f58d0204a3-67c680512c2mr3277682d50.89.1794484555468; Thu, 12 Nov 2026
 03:55:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
In-Reply-To: <20260918165601.1014666-1-ekffu200098@gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 12 Nov 2026 20:55:42 +0900
X-Gm-Features: AclHuK9PmUV8BrYAjnqEoTS4EvgydQ1Uyiy02kEKk-TSeQV6BgCr13vlHCGtulw
Message-ID: <CABFDxMEW7a1yxZJ5TOdP244gbMebCzHBFsF7w7qJhxfxJUZRyg@mail.gmail.com>
Subject: Re: [PATCH 0/2] memcg: remove unused page-based helpers
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4F69880002
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: descamae8m1oq68gunazxarqr7x3uxt6
X-HE-Tag: 1794484556-479226
X-HE-Meta: U2FsdGVkX19NakMB7Nkv8Lv6N2FVtkPWzc/XWELaPPglOmlK0itchPVwwc/AmL7IO7JHR25hS/uHoD3jS+GHeYzi7wf91JZUQKi1J9fFyPWhondNF8FxvrOIkjkS/RnJ42qRRR+6hGHMn8QsejX2fwXZ48XTZH17mADKvWX9iWwhXae5H59cxvaf8CgpO4ocrWBon9BtqliR+IoDGhZkCX6DTtxH+FLtfNnB17rOAEPfu1KHmlgA9N+gKKo8nYbS5AajszGW9z4zEOGWx1mYZ/K/49lb/fERb4uH8iOpTJ5Ct0oH99zOzsJZ5yCdlPGaoT9ytOO/3s5MNY5XrN3pcPWQniw0q1Uzc3aiOZv8kC9fHuwEq/if/CPfHn0uucCM6Xvwim6vYA8ESGv4oiCK4K9nNzhJuQMSLNJpXDkWMAz1zDisDonwt2Io4NIifQhdCyQeEmXDbflV/fBj1u90zdYR+iEO4/Hoi2FrvUA2Rvtr+GHHc4nxgx1N2/3ekvrIPKyokILrm68ppgVGWb1I4Z525lFXqsP+X4oIbyVyGnKy+mFMsgbtGxFwBEoDwPPPWxpOrA3bU3tSMK/XCg6MHI6IAZauW0C51zMpZrKvik77Hz5sk55wu5156kZtrz+rq9ZaNdDtqnnAYVawCK4wYU3AVEDNXKU9DAG9fZ4/Fibm8QlggRa50oYfRWn3d8zjv+cJaHU1pd7TJ5mZZIOH3Ipc7aK8y59FObUX3LYhm2rCe9128WMkpMhbpFxxYxaZh/xv4hjohE5IuamwZY+XeySpE8IWsVicka6m17qyX5V9SdTcg8g2RjYpUckbp/G58rS/ZSOoCCj2W8RxKpZFFad7aRzVx/tQV7GVbiOtBDnU1c/q2haSWdk5XQQ9eJd4+wCl2jAML/eMsMcDPOd7tnEJMnL1VP4c9A2HQkSxI/8XiitIyj7fGCThd8OAz1Zn5hyUKa1ck4BmuFc7AaU
 asi8PdbE
 ZzGjJM/20zS3ENGEcYI9Qc88JT5/PVo77JaxjHzLm1ohQEX7v6jGYZ1YwkS7vU0wP81TXvE/j20mf9OJwCsNdKFZAXUnCx1w6cB0EmGNaaDZzRofgeziJ89J8gBtZqYtgBU1C8yxHvhW/UxytwMorRGRuFMwESz1kXv1POjqTI4X+0EgPt4F21BqaqQy0tZqaO7ClkZxeD5kWasM4yALGMJa8ucFdLZPrsPcPcOZnT5U+pyEIgshmL1Cf1FvmYhbqdH6ZekgxSH1LvX8nxyR8Co98YasfPGFvsckOypMnmuFjYSJQvsqeyW5gJPwdmkK43FSRIDbySVCjSiGT9aqiAd+3+/ItpHbPB9Kwg5He4Fo3iBlQ25vFc5wlaDEzKYJCX5tur1q4wkaRFtDLgxsg2qVCG8pZ95z/DPi38wIvs0kc10/csVyJ8mE6eO1jMOynteet
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

2026=EB=85=84 9=EC=9B=94 19=EC=9D=BC (=ED=86=A0) =EC=98=A4=EC=A0=84 1:56, S=
ang-Heon Jeon <ekffu200098@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Hello,
>
> While reading memcontrol.h, I found two page-based helpers that have
> no callers.
>
> No functional change.
>
> Sang-Heon Jeon (2):
>   memcg: remove unused page_memcg_check()
>   memcg: remove unused mod_memcg_page_state()
>
>  include/linux/memcontrol.h | 32 --------------------------------
>  1 file changed, 32 deletions(-)
>
> --
> 2.43.0
>

While clean-up my mailbox, It looks like a later series with the same
change has been applied instead [1].
Either way, we succeeded in removing unused helpers :)

[1] https://lore.kernel.org/all/20261014-memcg-unused-page-helpers-v1-0-240=
b37c53831@columbia.edu/

