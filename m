Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E423DD65C49
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 13:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B436B0005; Wed, 17 Dec 2025 08:55:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4190B6B0089; Wed, 17 Dec 2025 08:55:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED966B008A; Wed, 17 Dec 2025 08:55:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC426B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:55:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CDAA3140AF1
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:55:30 +0000 (UTC)
X-FDA: 84229110420.12.FDD77B5
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id DBBED140003
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:55:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fjEIaWK5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765979728; a=rsa-sha256;
	cv=none;
	b=mIE1lqVkE0vYgzWn/cohl/d9T1cqRwEZEsyPWBnxn2yNBR/PiLgbAh8xwd2bYjWyuhim9i
	nNjiK1DhEDmth8pEowCSd0Kgc0eg2MmFOOIM7QQInOcKhQJtrEipdGbRDPCkmKZS4XlLUm
	VsEeAWjcLrNjKzcn29rSe39UGozS18E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fjEIaWK5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765979728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzX7ZM1o+TOjCQmRVqRs/ozyaJkAfH+0WTUZVqy7yPs=;
	b=DSWc+RA9BntCETjzVQQelHHLteHBG24mLEMREO27XLrveM9bwOkkQZX242juGg0TySO9fi
	ZGf4TU5aX3IpTIjdGWC7KDFL7BlPjQ2Z/lCj/CVFKEbdN8d48t1r/nqiGe/7igXOASuG7Z
	aFZ4CxVOClW1Coadxg3w3Ou6OVE/O38=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88888c41a13so69686236d6.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765979728; x=1766584528; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzX7ZM1o+TOjCQmRVqRs/ozyaJkAfH+0WTUZVqy7yPs=;
        b=fjEIaWK5L+vsBCoWouzPP/cgbtRxSq/5ppHzJ/5IYTyCL+7krDTAm3TYI1QPnJvXnI
         M8jh+LMqOVEiIUT6kaBjT9Bof5YN4cJnzkZ5esEbM/nG6KDdjxCDv4Avt1KN806mZzzc
         89dv2MahfqtO/Uqiw2a7q/GmMaCzZMUrG6lbJBWsSrGfHkPS5IQlaWcMxZztJrVFu+fg
         kN8DQ3zHS93sCMsrA4Ml0GWTF3ja4U/zkM6SWykVb0fWNgc7rY7BPMzAXf1myhgn7zeD
         y070AFc/Zq3VAG0doOYpZ5HPYrHDtyx0qPKeyME5GQ/zavgQGwvpl5NvheNMga2Hh91y
         IwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765979728; x=1766584528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YzX7ZM1o+TOjCQmRVqRs/ozyaJkAfH+0WTUZVqy7yPs=;
        b=itUY1xVzvrbhDTKML4XJLV8jvrRx33KENXERGx2Kuzm7ZKmg5bdf7ijXKN9EW16loN
         7ORaeVqErcuF/5bmvE1Sncoe8aImyUdrvt1jhHMaz4HkrU2spOcwfb5a49WUfspdZQcq
         2lHSvOEat60gIsUuhgVHXtZBptgF3/zF3tp2mV9zMydwdjLXhfaYrRE/LIvv7QVQCc2L
         lmcoivKq0NHTxyCWw+qre7zZwL/47WfPvBhbEJW/FP0ftjT+E6bfOOcRltkvv1Ao2AnD
         OSGd4FBvExYsjRJ88ikQM6628/JveUza8micA0hcYCy8w9V2R04tI9l6tE3lbvKFNF0S
         hBig==
X-Forwarded-Encrypted: i=1; AJvYcCWqdQQT405G7l1/qWk5vX9dSTXKThBm+AP0wZ40/Unr1NaUuyvQM6RSaiVxTM6me9NQTJqOveW1mA==@kvack.org
X-Gm-Message-State: AOJu0Yya2QXZ/8CDwByCMloVq9q3Y3suXIOp7h8Tx//eKZsTanD6kem4
	ov8BVaRVP6hTd04UFRp/dx+TXh3EHWrGLytPDWeLKT7Cl5eIGTOgPNuAFBcqp/9xsW4WM91sGpj
	WBi4PautR0k97xa6qGikFYXk/YJ7yNpg=
X-Gm-Gg: AY/fxX4SxsoYiN2IZLgfUtAGsV7B1bmCrtcLdo5lhmcWxlEdqn46iCDncMm4XJbCCXP
	i9vyNLExcO0dH4yI5B8FkBBFJ4e3MnA5i+0R0qut5jQP3EMVmwu+uoLGhJ0pdzZH5WI46OnyP0s
	9IzdTsbruppp8yZLqLfdOzldUymikhJIVRQ+0BBWm9Kjje46Ms3JyyCPur1+yaotCYCp0mRqpWb
	mzLXU5KMw3/C47FH1ciLGbiLjyoxEGqTMUPoPwU6w/zK0rMNzvnNJ+Hjw4i0+4PYr0Eoja7ivjW
	KRDMBDl+Hw0xydc72p5wH5rKAr+3KoyYjw==
X-Google-Smtp-Source: AGHT+IGVQ6ivX51FgYkbTDWi4T0CCt2/UMyMmgbf3Bd7aWDbLzTqzMHzid8Kd7YuMhBhbGaUeS9qrFBkh4vq4FKbIEk=
X-Received: by 2002:a05:6214:5083:b0:88a:2444:36e1 with SMTP id
 6a1803df08f44-88a24443797mr195078936d6.62.1765979727833; Wed, 17 Dec 2025
 05:55:27 -0800 (PST)
MIME-Version: 1.0
References: <20251208094028.214949-1-akinobu.mita@gmail.com>
 <20251208094028.214949-2-akinobu.mita@gmail.com> <20251216122441.2810043bbc51621315e3862c@linux-foundation.org>
In-Reply-To: <20251216122441.2810043bbc51621315e3862c@linux-foundation.org>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 17 Dec 2025 22:55:16 +0900
X-Gm-Features: AQt7F2oAJ1HD8RfcX46WepqOZrXvmZQK_-FtPhsJi5EQDV_sv1QcyY-Fdn9cU14
Message-ID: <CAC5umyjCXSm1TMiv+OOdK1vHp5nA7zGRxLegMzhbLd9U=3Dbhg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: memory-tiers, numa_emu: enable to create memory
 tiers using fake numa nodes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DBBED140003
X-Stat-Signature: 7zepr7jdekq5p9qerg5rd6oiy17xp5oj
X-HE-Tag: 1765979728-782743
X-HE-Meta: U2FsdGVkX19gWyQ1U9ujjrAz5Mm9Z4y83oriKhTHsA6Yc0bImFh5tkC7lQGq3ks+5/RY42RVnwGnNpx8gv+hWgsJZ2BjAD4O7SfBz6DnBfqu1JZ+YvzPdPIs+V0C4PU4a1h7SMVRYcJXmKgBbY8YccgcAtZ3xVqXmFSUuAUnLmGRqtM6rlvWjdgI3RJkv0hUUrmak5HzJHz8Qpu8cDqDt1wZc50h87w/pQo3w4anIk1udICowuTmxMQmZ6Gv4Wm12QrPDk32nc1pOI4MsoV+psGoT83B4e1D+6cCoWz5ZwQF68C1zBMf4+Yp2QwunfhnF96MU5oCW6v5N4vDBpV8ikThzNtz//r/TM1tbnKY74mkqasbGUX3napCWowuh3DcsFqtbE8bF6vOgoxYX/PF+Cq/teugQ6X4XhakXuQk+wLQiGigob1+uDPCwCHt6yqw5IVIKoamGke71bKAuoJxZQpOMmZTvFmqPMgyxE9wH+av3f6TpoOHKtZFme1cWAaprFdl73EoNebpMenerRmYr+ZPtPBkRIZSU8ZA4YqLhyFlkREeNFKKrCwtDyCyi6mn858w1y3XavTdbr7KQD7vclvHjdedqcv1mt4WRZUWRk8wOfsw9AYaoPv1kMfAiyQJpUi3Oe1vyGhfha35SIyKRMof2VuRW1jQsTT14/YgmzzclCRmD4ol0EeoiGekR65oc6SwLfHRacCkBA6JI+Bhqm2iLaXLCi20EOCtKUwaJWHSZtauXu5c3tVrXGlQmr1AhaBQFihYsWkhZ+8N2hazHEYzOLJvdfj/Anuzi7aU0K7pZNEoV3nJZUV8ebIygAdT+k8NBYAXFJgl+RnVbNkXi/nC0qapI7etbbhV1XIrBYAhB/lrkjo7RAw0uXpDoIFZ8AmCbuaOp6mJ3FO/Iv+XhYB/VPivsJWbfqv9ztTD0LVwfhdKgUsiif08xhHD8zfhxgDASUbgQaAPmx3tZpB
 j7Elt1vO
 XaRP3eUhR/MjV3fZnSRLm090ICbK8yGNlNBjsZgxqPXS1y/BlTJ1JibcxcK5jh6dHeY7Mcc/+o+vzOIgRrEr+5QKWy6FlOCR6i51r6slHsnNS25kiWYzjicgeoSU1b+y+OchFMh9p+hNCPb8iI2By7Pzj2YEjQSZyJKHxGOS7M4+7wqwo66l9l/8oE3ykcniDFMy4NRN5OhPhO9Y3QaeFOc1/P30Qwivn+2PHXOFpn1n7UQ5ngkr6tnBiMIt3L3iHZjr9xMcX3seZ3GWexpSdPqN9seVtprGgtUotaieBXt1PiJIuiACQxHuwaLvEALWl5MNZ9g3svc0fHnih4TwWWh8jj88mnprFX5TowmJXJ9mS6zCkDZPTBn0MluzpP+zZCZSquVSDyW0JehxBryYVOt2L6u0nvjhhWgBa7H7MH+m8lMtfsyYWtZZyg+Hu+jNbDJi0GB7i2QXj9S3GW8J57J3lE0E18T6eZlxYiv/gOIkGpYpT3BghXCEWmTVhBYMVrQFjiqly6ZIBcNU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2025=E5=B9=B412=E6=9C=8817=E6=97=A5(=E6=B0=B4) 5:24 Andrew Morton <akpm@lin=
ux-foundation.org>:
>
> On Mon,  8 Dec 2025 18:40:27 +0900 Akinobu Mita <akinobu.mita@gmail.com> =
wrote:
>
> > This makes it possible to create memory tiers using fake numa nodes
> > generated by numa emulation.
> >
> > The new "numa_emulation.adistance" kernel parameter allows you to set t=
he
> > abstract distance for each NUMA node.
> >
> > For example, if the system is booted with the parameters
> > "numa=3Dfake=3D2 numa_emulation.adistance=3D576,704", it will configure=
 memory
> > tiers with node0 having the default DRAM adistance value and node1 havi=
ng
> > a lower adistance value.
>
> Confusing.  I'd have thought that this commandline would gave node0 a
> distance of 576 and node1 a distance of 704?  But the text talks about
> some third "default" distance, of unknown value.
>
> Can we please clear all this up?

The DRAM abstract distance is defined by MEMTIER_ADISTANCE_DRAM
in linux/memory-tiers.h and has a value of 576.

Each memory tier covers an abstract distance chunk size of 128,
so nodes with abstract distances between 512 and 639 are classified
into the DRAM tier.

Here, the abstract distances of node0 and node1 are set to 576 and 706,
respectively, so they are classified into different tiers.

> Also, we have little documentation for this stuff.
> fake-numa-for-cpusets.rst and kernel-parameters.txt.  Can you please
> find somewhere appropriate to document this new user-facing feature?
> Maybe a new Documentation file?

Looks good.
I'll create a new Documentation/mm/numa_emulation.rst and
document at least this new parameter.

