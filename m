Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BFA9EB2703
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 19:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C596B0088; Tue, 10 Feb 2026 14:23:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48FC36B0089; Tue, 10 Feb 2026 14:23:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371766B008A; Tue, 10 Feb 2026 14:23:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 229DD6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:23:43 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5D921B2D07
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:23:42 +0000 (UTC)
X-FDA: 84429521484.23.7841457
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB83314000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:23:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gkwH3Z1A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770751420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBYVGOJgAAh0wUGtGHCzoyofcM36bp9tfn4+54TVIks=;
	b=F3E6PXi6EVfN2zQtlvgPdR1fV7uBkF39MH7OhP/SJI+XLUIQOQIMuOJx+uIrdmDRCJk4GY
	fdUU0NXuIrHdpusQUUcKPnVNOnTtTQipvw+bprDnCGJah3xN7S5tAU84TTID90ORQPmRLn
	K3T2ywAFBVjaaGkfARvy5A7r/l8kVJ0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770751420; a=rsa-sha256;
	cv=pass;
	b=TNph3/eqnvi9CDPZSOJh34LAW+wdQIMsExxsM2G2eJxoZKBLfLD5OVbnzQS/HjssasL6P7
	7RNFWKWhsmzfXhdF6PqQNIc8yvRETPjZmgY6odWA/32tI7nQMpmSGLL4kfB/x7YhubHPAC
	iO79fVVzzLD45BwLqcVs+OMhqfcU1BU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gkwH3Z1A;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47ee937ecf2so1711825e9.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:23:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770751419; cv=none;
        d=google.com; s=arc-20240605;
        b=HY9pcE/pEYLFG4DkcLK3eCFhiUe4Vr+FYIK7V2QKabRUNRRYt9gvLXp4kJEC0ueoaL
         OEZGMYrae/P/FPgxjVns8CJGIpTuPR7VJSE5EWfXv23w598HEM3CBJn+VbkmMLasnz4N
         XEElEeuwr3ucQL5AQVgACZIm7dOb7Bi0q1wn67Um9wFmfIPJGvYVtuZxpGCAsmRmBC1A
         Asiij21o07aPCgEcEpaXnN7m4XvUaIM3/EzDTlBlSTjctkRzmpzdQAIb6E6XghaxSuUb
         cADYWkIkwMyqkNG1KZuWeVa/KTjmI1WR5y7TX7u/n8ooGcuBWKjO5zo8pJbVCm7+E3KU
         45Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pBYVGOJgAAh0wUGtGHCzoyofcM36bp9tfn4+54TVIks=;
        fh=ABXmZnBdoZTR4yAxk+iKzJ1hvPe/vHvC1K3Uxj2KghI=;
        b=jAp63Xxm9zyPb6/IxG8lGaDVpYmctlh8D0NDQ7OkBXc7P1o+X1n9xkw7xyGX1aRck4
         7bvnuCgXXNSqqhJ/DdEGQb705RwNEK7rBFeQNszpnq8RnmVnwcqQsJDDOvB69uC1cF1s
         LnOg/3A0CPnzqp45MO2nm8hyME780edaKBK0Tn6554xX4piPTtvBF3/fJlF3EcwFz1fI
         40mNUiYY+Lo7ll/xI2q8kayT/4QvBJKxPdzKMxQZkPm/RCTUHIbyfn9vfJsTG+Ya75/W
         ANWcTHOGhWBVIPKeBiwb0/CSVI7FN7Zxm+iIfHOsUj4pkaKBF9PFvmfkIJ3lCIT7Mpre
         s5OQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770751419; x=1771356219; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBYVGOJgAAh0wUGtGHCzoyofcM36bp9tfn4+54TVIks=;
        b=gkwH3Z1AtEx3mkvPvBtMSO2P59xSrdB7Gy2hn1XZUk0QYF86hyFWZ3FjkZJUhnKnV2
         eSiRDUIoEd4YeconGtWpFIwe8e8kdzBQUJN1gPYyIiT/D/WWTnDzDYsFwQIEcO1zCs9R
         V0yOpIWSbU/gAfV2MbOAdmMJp4Sj2EBVs0GzD6gHWvZfD8pSGMPjcmRp3iBaIACiJN90
         zm3Om5Z9d03sQQxLKe8wBmzUT3BQ5vInfrfg3uJm6uRbkTm1hsRmDKfwrfO9xekHIJzw
         5QatP6B+sIxc0i0OyCZNOhDeT/Sagtturs7j6tbTSdYnzYfAyA3ZWAF+R48vx5YCU46h
         RnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770751419; x=1771356219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pBYVGOJgAAh0wUGtGHCzoyofcM36bp9tfn4+54TVIks=;
        b=bQpFRCZRYC8SQFCUD1RMaLSe+SoSVc2FB3x4KBbbWbLS7i6uz3my4XsrpNg2nGFsYd
         BDtml8JjuolAjeO332Ej+3D9AUW21rX9G7lNxcWoX3jhlm5Y1+ASxuYXBHgTBpzBKwJR
         jsoQ9nJD3lKUyWrNyjU/HxGG2Rn87SpYlAq1v1Qj+htc4Mk0FYAlILRvzw8/vXHqTPox
         bCDT4vnU0kS+OXWpEyXUITznP/FPd8t6M3CzcfnDKV9/t6UVbwELQubUBGgYdb7ZHneh
         8GMcVMP4jcKYbEwTg2Q5TGZC2k2YVheT5UKfx7M0SVjNpo8qlEtIPRc0A4Y1mkzLD+zR
         L1Dg==
X-Gm-Message-State: AOJu0Yz9DLgLzipP8WwGWDl9ZvApid9DIZoM5kdnf6wDGt8VqBwILM4q
	tbk08tmdz7/pWKfMIeTUI0uLY+eS3WBFh4BVP+vAqikt8k2HE5jMEcxaKa9deDll6M50HLwAVBt
	gsqGikbCMn2P25qVfuh+tMY48LR+aOuM=
X-Gm-Gg: AZuq6aJFfny9alY4NuI0ZhvgiBBMaHBTbfAQyHw1vfI57qcUbWm1C10wRoHQPt1zdN+
	EEpIJUZdYrB+8yRvAYJir2dTM+q6n8by8Q8CryvQwIdfFRIsP0QpXlcEizIGQRwts15yY5CvzH8
	EYyGsD8D6IDccoukhpO06AghuKtCkX6muCVaQrgv3Z0xhoEm56LmLfsAXHvxGT+lVO56Ek3bg+D
	Zqd/NdxwEWULAZRETF4DKQFIJsXC1781KmZoc9WpzaDYOjN0o34ORU8DgfmlK0jQ5n2Qjcsj8Ey
	LWl+J9yoqLBgh4ByXb+yZM5XY+zCX0dBKQrj0Ys=
X-Received: by 2002:a05:600c:5288:b0:483:14ec:5925 with SMTP id
 5b1f17b1804b1-4835022927amr50988035e9.2.1770751419161; Tue, 10 Feb 2026
 11:23:39 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-2-nphamcs@gmail.com> <20260208222652.328284-1-nphamcs@gmail.com>
 <CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com> <CAKEwX=OUni7PuUqGQUhbMDtErurFN_i=1RgzyQsNXy4LABhXoA@mail.gmail.com>
In-Reply-To: <CAKEwX=OUni7PuUqGQUhbMDtErurFN_i=1RgzyQsNXy4LABhXoA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Feb 2026 11:23:27 -0800
X-Gm-Features: AZwV_QhDHop3xuaKmlrjyEY_sdgVS3677YBZxGUueqqiU-9ugNQbef3e4wRWWfo
Message-ID: <CAKEwX=OYauRgQoj7cxznpROknHt9NsKLOmkvaFtkEh8T1KASag@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	len.brown@intel.com, chengming.zhou@linux.dev, chrisl@kernel.org, 
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com, shikemeng@huaweicloud.com, 
	viro@zeniv.linux.org.uk, baohua@kernel.org, bhe@redhat.com, osalvador@suse.de, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CB83314000C
X-Stat-Signature: io1qcdpfb7mt95by5m1iqyq4hj7fafa6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770751420-903156
X-HE-Meta: U2FsdGVkX1/HpDAo1YfB1iVvcd/TpIL2jWphUXaQiu4JpwmTc9G3jRF/UZG8rjuVZab9qyum7BbPjwLtyDxmEPintQehJnW5s7dJO8P2faNB8As4q9Y3jQgj04jm/xkBRoL/jG/f69xCA4QJhH5q0SqNvAk3duXM4QOqfsfMEzY7euKZm8TnmT+NvS0JE5bHfz6U381gfIecF535uYq5SxO4aMJwkOTJMe639NCCp4zsApFi1vDGoTqmd94kOcn/QwANgB+pdlH3hrQ3XCZevN3h6qjViNAPQ6upEiIcJWv14vDr1+WeFwt3jls1ImbOCk7jJrJIvOV0qbGlUEfJoOYnF5C3OzJHa+mLn9L0NKBUgOBQudjX4wYb+NzGWlLlB2u8Y81G76GQxp6jbp2wbPtE/rHBOmO2huN0QQw5XD00MSzAKfWJ8a5VgWgrqL4TMLl1+4Zc0gQEe/sDrGlkTXZaYV33HEi3IQK0tXyu9ocsB4WkFjaKRwJQQgz9O69FDkX6+tLMOOkaRVYcMFXXRsJIpPALUFTGK0yzOAmUvvt48Wu1O8i+z/XvTonr5xECBQpgRiF0zDfija1tdVrERnPNR6KJqiL8xSnOwJgjHmiXmlL2bODg47ALNJ8/xP7LFcMQ5IigyJBoTNV13yeVzjiThBaPy3iGqt+7VBWpoDYcSEtHJEcu4rv4awmYP+kHNo0faF6HTrmpM8YcNfWqiBCK5smDtLm1Ri/49qgb8CWS6x7L16JhYZwlEsZOqNgZMYs8iJloNZhatpp6+axLnX7l6P3RCXxshMzoGLe+7oTlG35jYf7yUYO2QQ1q8847lCuct6A3bl3KUVpqdLup7BHCvv7ARW6A/3A6zq2mXOsUCqMyffTUrJYAC52xiHfqDXPCc43jsNkCP0Cl6knu0GEACipDD3DNS15baP2hX0TK4ax50migIIOysiBw/p9/OldLu69CFMkDcyZ8cgg
 GEC/s9ZI
 3UyrXG9SKoK4f0LCAYBV5iR5wcVzkwe9oPLqfWLAMudmhMIiEJQ/VjSC7EqnKg0zrdW5WaQGUynQpg67bShbl+1F+DS0P1kED7yn8ITIFclCwmrLAxx5tSCe0abCktDfh0uNJ6wa67JUcxmS5hSG0sU7BqiAbrbDmV74JRNh0sa3CGh85BeJfkRW/RDiJxmteyyfvXqpTb+MsiXQQkNvQoSPboD7C7tbJx+2IWqt1iYu2xTvWH600i5/rFcQvYyDgXQ3z5NVewxN2oLmleGlQEH6N5FVM9kneJH9AEKDgtTh5iq5r0BParHA8KB+co03yQhyJtpNLuJY9Q6CYVrRuQIAO7p7xRCn0chl7rcZzWUi2khMCI1JQ4+Bf/Maxj7XCHFeVGCDh3KV7uou95wubTn0uYOupWAxBaxiGcnKXQx6TrG2OPuKEJA6qvfbLlbe2w4bwVfzztxZ9AfhTnKmVOzoL+qDKjY5yPEmn7xWej4N005lNxe9k1K341A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 11:11=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>>
> Hmm this one I don't think I can reproduce without your laptop ;)
>
> Jokes aside, I did try to run the kernel build with disk swapping, and
> the performance is on par with baseline. Swap performance with NVME
> swap tends to be dominated by IO work in my experiments. Do you think
> I missed something here? Maybe it's the concurrency difference (since
> I always run with -j$(nproc), i.e the number of workers =3D=3D the number
> of processors).

Ah I just noticed that your numbers include only systime. Ignore my IO
comments then.

(I still think in real production system, with disk swapping enabled,
then IO wait time is going to be really important. If you're going to
use disk swap, then this affects real time just as much if not more
than kernel CPU overhead).

