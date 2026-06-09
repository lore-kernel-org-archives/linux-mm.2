Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 143B9CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EABA6B0005; Tue,  9 Jun 2026 07:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79AE56B0088; Tue,  9 Jun 2026 07:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689F26B00A1; Tue,  9 Jun 2026 07:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 595756B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:47:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 277BEA051C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:47:14 +0000 (UTC)
X-FDA: 84860198388.06.F235AB2
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	by imf22.hostedemail.com (Postfix) with ESMTP id 627EDC0006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:47:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cf0sOl22;
	spf=pass (imf22.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.222.194 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781005632;
	b=W+lM6Reon0isVTFGLf7+QSzp9+u0GotnitNUgdDRy7kagfjTNa3oYe+GyxHqZajzmoh8oV
	rGWHKWANINXrfm2GASTUPBsNUklCBLtdHgSUfLNdT4RjkDpNC5MVgR6zOovUv8DENGsJYr
	n6SoileIb1tAG/hEw+pvORIKWfESUss=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cf0sOl22;
	spf=pass (imf22.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.222.194 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781005632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Mks4AbxGceQLkjBq7lF5lzg62U5EZdMRKoT0riXe6aU=;
	b=2a+lUBD8jR1VmX/a4H60bIOeP0oRLxWgk27WhC2csStaMsLm5A4etqkUU0CTLoz1sd4u9V
	IU1TIeX2Jr4omAcIxBJrrZ+1iF2/AlVfsOHJ4qPX2uyyAVVWzwvRSlxiLx5yjhvKbWEkQw
	dtTqSaxcSnoZGki6uIg4tpVGc7R0bvQ=
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-915ab38ac14so600183285a.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781005631; cv=none;
        d=google.com; s=arc-20240605;
        b=I6HH1X+s999b3d+3c7Cml4yM6nJVorlJQirv412xEFbtTIgK2JvkYb4VXHNfyOtqj7
         u6MwdnWVd6YeD1LX7NKdLRluSpXyiZ4M0yEdrNO66A2D26n6PzEZmxq5btLuwwTUssBF
         lT9zva6JWtw4w2plB+lWk0wf+BL1t2z7LR/YHq8YsTKzyRYIvlxznN8OLNuASvFvHKvu
         8DOgaFQ5cSzbcNZmJE18xZI+ag56jnXFfR16B1vga1d2P/YpPep2d3RqWvRe+Kxh6q3E
         APPI9urs6Hf/u9D4rH3XN9YoCLkG9ZDjT5+dewHRkOuXnkkvLTPQll+gyC8JzC4WFxQy
         JtXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Mks4AbxGceQLkjBq7lF5lzg62U5EZdMRKoT0riXe6aU=;
        fh=SbT8/TdXOiGOfqmhTk3Z3x8WD9hG3u3KJuYGQfK/omk=;
        b=FTfdNV9bF61rgcyiLVzvk/9ttFn9sG+LK+rcW43IzG8wlFwtuz0NXqS2FNrFbsCriI
         67sj90RdJioyvGX8U/r1KU8dMTkCorV0sa3JpEZs6boKvAfab32SMWHUY+owkdjM+QsD
         Q8+eBq7egbJwb+nkxeLWKuSfAhoM0KIVOBYynYWM9hm5Q6kQQZCZ6ZD8gN4LnfrGVfoc
         7StKnKWOGYvlOO+++giRfhSGll0tKEQ+N7hMcJlKk+UZk8RJNxCq6CaJ1YhJ8fC/9eED
         97V2HxVEwfnjfxG5isVrooDIHthqB0JeOLNI2SduSpTLszvBbWHjgJg50Qe6GnelOGQW
         CoNQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781005631; x=1781610431; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mks4AbxGceQLkjBq7lF5lzg62U5EZdMRKoT0riXe6aU=;
        b=cf0sOl228cxzA9t5Nz/opKC1HtqiMWTgXPpqTocsyxCFKbyGsvO4khEIze/aDiGLUM
         cl8a2G+sF/LI51GeXjh2WIfJR9LmxA8CPEhcQiEtlBT8IYQPtzqPOehPrvhiFx3Rk+Xk
         K/Q05HjuCjGRosZn4ocKbKOTmldQ+zZlXlw/mWSgBI0jlnVVqdqz91kCSubIfIiPwLAD
         UYDMIC1QYu3l8c2hH/5qlTJbea1vVo0/BcF4aSLMOu1AOBGVLMAgy/q8gCUyjT9qj+QW
         lx5lIu6d2Sgvt5S44IEp/EpLbU+fSxL2HvAhGVp6bw2JZXFtnRzmd/pDRMHradYdL/qL
         HFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781005631; x=1781610431;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mks4AbxGceQLkjBq7lF5lzg62U5EZdMRKoT0riXe6aU=;
        b=fyt4uChBauZ1PPT4luQyngFjFm6l7ETWY2ghrZ0YcwclDTBdBfawGJdLDqq6EGnRY0
         7C5fUFD2wu0sE1CtnHKH2Of6ActbztL+vIg6fRjtYGxtrPoiLnb74HT6BteF9hCQkmKj
         4ZbKpUTO4BObRaEUOQBa03FMbnNYc3yhJE3mnFSOftjUA4e/XAYOF73KNPF2XU5jTiod
         w3i7xBr6IQN5U6X4B9pJzvzqaj2XncqgPc04mTAVSsRKVkp9OaTMzX/HmnzrR8MlEEkK
         Fe6CcZb4Ll5cqWyKy/xePwWmkEEKiJp5MAARIaA644tO+KaaArKyEiTOniY+E4CgkMor
         lR+w==
X-Forwarded-Encrypted: i=1; AFNElJ+Q4/EM2rD24+W+z7Rsx+uvMq2RQy/NiX0y715P4NNljS67hrIK2v8tBvImk3Rm83ua7veFWuiQjA==@kvack.org
X-Gm-Message-State: AOJu0YxUdrLtURHMFBZwo4mTf2Z4fUZYJV/6Wz9aek+v+dYt2i3octKo
	EULJwPV3St501vGpHZcGmk+5loQp+iH7X9fZPurEaBKeceU46ayyuZIlzL9VYsnP0jj17KKFGV+
	iaDqYUvzoy+qk7lxZgviwEFan6XhYZlY=
X-Gm-Gg: Acq92OE3h4w8xzM9bXnLK70U+M4B/N9qC8e4QYrmA0vlX13uyp4bsJtPEiVZelGDw7i
	3VeijDjXXp3pCdey2RRuwr+Oz1qhDPil8z9IkUI0YfrtvekrT7mJivZRW/lE2hz7kzw6orWsb00
	DlBkvjDZK5Jz66hOgQ42SGkYYAGMqtz/fvQ1L7SFMwIQoukQgOKqFXo1uxjywFXupAc/ZQN5GY/
	qPARD8SlLHV+aCEcSuMnuOt6eyMNdaLsthiOaNN+Rn9+iSi5hVog/jwMGOZuFjoZgKon1vjt/J+
	nrYR/b47Y7oFkAn7nw==
X-Received: by 2002:a05:620a:8805:b0:915:afa5:725 with SMTP id
 af79cd13be357-915afa50e57mr3016561585a.6.1781005631489; Tue, 09 Jun 2026
 04:47:11 -0700 (PDT)
MIME-Version: 1.0
From: Longxing Li <coregee2000@gmail.com>
Date: Tue, 9 Jun 2026 19:46:59 +0800
X-Gm-Features: AVVi8CdkSxnwEDnnvWRatmOIEaenZMh2Rtxg6YigScvzARxEs-ANXISvN1v3wHE
Message-ID: <CAHPqNmy9uoc=UnbTEwz1Ecnt7pZVRw-1Hor906OdDE3N4J4cug@mail.gmail.com>
Subject: [Kernel Bug] BUG: soft lockup in kfree_rcu_monitor
To: syzkaller@googlegroups.com, vbabka@kernel.org, harry@kernel.org, 
	akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 627EDC0006
X-Rspam-User: 
X-Stat-Signature: ammzb8nekud1mhks7ynpzh3wsdcsybc3
X-HE-Tag: 1781005632-280161
X-HE-Meta: U2FsdGVkX18YfJWHNVc+NcBiNFWWD63K35V3s9OxU94lletdcYfrUkIqLuE2s59QF6WGmF+MgMavvtFaG2qxJu9G6oLvOM3y7Q5vskEapWF2f5f8EEkaBR+45GtE6VA3Cx9L/cXCUTPgEXZabVix9DYuf3+c0QjaDkpEpzgomcaS364qwPmMcELB298L2Q/aeiPRlJAba7tlkTZgWLyLjJv2zK4G3heMiQs+luwia6Ps2jFgHo0rsUQ4gJMLyIxbi9FksGTxb4FsmOLfdyDlxpCIojQ3Lu2gaZszEfz4XVXBKLkwxRIesCkt/wIE7u6HFmjlOX0bxr1281uJkqvzRGvdNAPHPkngnRkp/V1ry14BJ1+dzyQcj/U7fYtDNWvV+mwRtgb1rLrm/mIoniiscC65fZcBN4e7Vi7cPgE8SdZsvcc+ZUiLwQPp1Y7dQjnzYsnPTMHgGAw+o2Z9WE6xy9j9NIKPUCWrA2UWp+qY9r3kNI3UroudEj44kjel1N2cenAFshOIdn2J7Pcn8c8gdtfJlinW2Y3mOBSt7qvvxRq4Z7UCT9wlK16h0nO8O82QwX40adQaqVk2lQ/r5EIDZTOgoIeJBnnlGRdHJ+6fTGPbsGyfokBhA1YaXvbON23UAv+hXSHCby+42qQl+4ig+ovV4wxedA2rNtRxzeKHiVdcOpXqa04meSnwfR2o+4tpc32gxkKMy9TadBKqv8xSPdAtOD73bkIFfIoy1gXupQFKqAB7CBus98b52c29GsQwmnScxKez56tSd60vuEQd5z4oUbwJqUAJzvW49X3yYo6OCG5WDO7Jcdg8UtxNFy4xuNlvrP+aXTb25F/9UnoAy3Nf3N2R2DOdhxIyQAHnKdI6Vquzf0WJj6NIh+iyMmX3kcJgROKcQ7EHiuRuOBzraWTzlLyyYIrB3aPT6Nqj02wCUCLBHAA+ZYkT7qHpnHS+wcbmOt6GSYYTmsRRYIy
 mGcMme4u
 L9ujnWuUBdnCda40uxmKYQDDIUXmCInU10QjpldhIKwNXCIoaclKA7DK2ELcuGBefyqdCeF+l+DepCyuzHlAPRifEQ+297y1Hr4q5YoV4op0HBpcyvRhBrNOlqyX5WyecVgw7V1o0v7pvos3Sydv2G8ngxgo0t/zZwWQobT4s0u89Of+jj4M50aOWLpXgtwEyW93bm8JSd168hCDPKL7oYpuuThKSeKjMSTOF3CQzDhWx2S+IeteLQY7b/lXS2ReV0tQLJhXSsjhC6d0bWVkTDsgziyPoZkPfAXm5ZNZm3RtZKuWH/hGsZx0+K9fYu3kMrgplR5QeRYfTVWK4O+7LPacqk+IeM01ACp3ONXcezjP6C8n10XoKK4ZHHAvdNHZB8JAxugHgpsJQkMYgFxSW1MZxPzo5buoVnltAzMP5vHIUJwMYtCVwmtCet+fjt2uI0Pr003DJSWpLbr5q/ISB0UqmXou/vca03uybOHNe1PkKcDRf6R3vqH9KLoqTjIL5UqUAPSLApIl4Vzlu3gg9cf1ENqG0fQti2+BQIOPm2WKlBbUee4jw0ZZQlk64OXkzVIg04mI1s10ZzJMg6+/oRmuCYDY0OdutFsxuaNM/wyRSL5vpR2MA5enPl7J8S68Eeq6szBzmtpYOvw8ppvD9SYw7wBx2Iry8I+o7TdoZRQL8tYq5+7eEJyVrR2H9QsktcBh2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Linux kernel developers and maintainers,

We would like to report a new kernel bug found by our tool. BUG: soft
lockup in kfree_rcu_monitor. Details are as follows.

Kernel commit: v7.0.6
Kernel config: see attachment
report: see attachment
C repro and Syz repro: see attachment

We are currently analyzing the root cause. We will provide further
updates in this thread as soon as we have more information.

Best regards,
Longxing Li

==================================================================
https://drive.google.com/file/d/1Bx2unEf-QntjVi8g6Zw7QNO6OP4cjGO_/view?usp=drive_link

https://drive.google.com/file/d/1Rqp_YWdi2uAcO7O8plg5k0NWxulZzoVu/view?usp=drive_link

https://drive.google.com/file/d/1nByyr16htns6Fy46FecT2lNzlogiK6e2/view?usp=drive_link

https://drive.google.com/file/d/1tJn4jOqAoXxROTevNlotQOefVn1FqS3t/view?usp=drive_link

