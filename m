Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C24FB44A2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959976B0005; Fri, 24 Apr 2026 00:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B446B008A; Fri, 24 Apr 2026 00:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820406B008C; Fri, 24 Apr 2026 00:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE926B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:28:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1059A1B9231
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:28:40 +0000 (UTC)
X-FDA: 84692168400.24.2FEA38B
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5450C1C000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:28:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BwLo0zj5;
	spf=pass (imf21.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777004918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=xij6ep2gWC7gef2Qky7OxxlHC1yt3hwCxCR56tcvUXc=;
	b=y/6UWg8Ldyi2JCpGDYaqKCdft0otKLtA7ZxxsHYI/W41y2wSjf/Bq5ABt9ef/ngJxmlsCJ
	LEQAs90y3/i+AwdGloYmwshpcsyMHZOU/8prNWz49pG59ex9iw/M96xgH5qzJ5dxuhPnHQ
	NIxgiFJPN8z1kRZiLgEnaBl28ygqGLg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BwLo0zj5;
	spf=pass (imf21.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777004918; a=rsa-sha256;
	cv=none;
	b=irDI5b62AHBg1dU2AhOZDgUaIoMTqaLDV5INgHqwwtLKmHyPvHVVARnqd1DfvU/YSYwnPD
	x69Jl4AbWbojpqofwn/y3IWID8Y27UF0vVH0QouqpJ2MaFQLDMAZyAzTftKSEwEqKBID4v
	pDbbgHb+EfUrNuLChZFXNGFT+PSNo5w=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82f1f6103afso3492589b3a.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777004917; x=1777609717; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xij6ep2gWC7gef2Qky7OxxlHC1yt3hwCxCR56tcvUXc=;
        b=BwLo0zj5LnDzeX4hLeNNgLaqxxq6zYnL0gW6Ifmj3JzyMEjOSYKXI70A6VBlxFEUy5
         /VjMfaHQ0sx/QqYC3jCdI+dPNJfDZRgNKwCNsK0Ks6zf8NewDnZ2Tpo0KXLh/I8SlqZl
         nNIDZ1CY3Oy1+U+FpuBtt0qbGxo2UDGCg53NZ0K17BJxee93ceX4PrApUHYkveUfe9M1
         d9zmCspRVDnaJjCdGKpIfsQy8ssI3J9joZXwJuBTd+TtacLh+CSb6z/Uy2TcK+55F/r8
         3U/Ul1bKH+o85yi8FC7oYZjRtrbVoHE2bHMPctf5w5+HCqCskfL7ot6GXjAq+hgQqu4W
         MCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777004917; x=1777609717;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xij6ep2gWC7gef2Qky7OxxlHC1yt3hwCxCR56tcvUXc=;
        b=psAPGd1HfUHJ7gaCMiIiAa3liyHu57dZTTZQ8zLwVwJ59ac99vjQYP3MROexZq7WZ8
         kU/v9O2w2DjgRFgZWm9ksJ0/X9NaHQ/q/4gOUd2OU2D50T3sohHgPtJ+ChcK1Dss0bSV
         0MdfDGDuhCiIdU+XoV6tpjUsx+lkAZxlOvu0CMbEHZpENT/UY/+p5JS1z/n5OYHIh/aW
         iJNjcOrlkblPz9tG8+I5Qur6oZbqRSUZOoM5r0mdnTEOuwnMROcvzNr6d1sB7AlSYXoi
         5uut5qSf+HpwipUch95duNR0qDJbyOykAN9H1uR+fzaPjgWAjf6s4WSdLp/aIMuzlN5Q
         VpLQ==
X-Forwarded-Encrypted: i=1; AFNElJ8YvrDeaTiWEIMotESZSKpeiVoz62keawj0WwMd/ZAl+KxkGe2Bwhz45wVA+exUksEBl65fK5XJfw==@kvack.org
X-Gm-Message-State: AOJu0YxIJy0KM/CyschFVdc53MPmLUCGFsG5Q4wHCIdQhcpzSRdKnDnr
	LD2yr+TnMwAXeGLIEJmVaQF/4TA0+9oY92gs9Tl5B0puWjrx+NVJGFVy
X-Gm-Gg: AeBDietQghlqnfBK997H9NM7w3rzybZafvIQ/NkEJuy38IR8FVMaDu3T81qfcmlEF5j
	OZNgPE+kAb3JnPqUD4+TQCHpiY2PnkRJQDTSxaGNIUunZXzJpmAAA+E/D5dZbG1sJnLHyTjLCfO
	Z0UmcsQ0T4OHgQZkPZKgN+arYjvvtcgOIHuEEaYUUN5MlPGlPnedrAS+9TjEPo09cUuN9DXYeIn
	8WZKhziZ9HK/CwJPHGxdQitay+UrM5l8uuSCg9fj+O02n7pJQQumrjro1q7JxZHqZUjJyxPl5cH
	GiM7IltIUnRje+CucP/MFtrXZpNevnen4tfyecd+nuCPSBQ4rUlfxRsXgJjYQRaWBsEMA2MSB8H
	5Srn/3xWvmOFP0jtiu6t9UbXex7ujul3q2kFa9ZwbEQux0+VXV+4+BpYkN6+rqzLMP0zjZofWWs
	WC0GDq1hnCRux80544PByxOHeJO9t5Sr6Ccn6xoE5OOck=
X-Received: by 2002:a05:6a00:cd6:b0:82c:eafa:8875 with SMTP id d2e1a72fcca58-82f8c82e889mr32885163b3a.2.1777004916865;
        Thu, 23 Apr 2026 21:28:36 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebb33fcsm20983354b3a.33.2026.04.23.21.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 21:28:36 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Christian Brauner <brauner@kernel.org>, lsf-pc@lists.linux-foundation.org, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com> 
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Pankaj Raghav <pankaj.raghav@linux.dev>, Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
In-Reply-To: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
Date: Fri, 24 Apr 2026 06:32:03 +0530
Message-ID: <wlxxrx10.ritesh.list@gmail.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5450C1C000E
X-Stat-Signature: umssfnq3wqeio77d4tjebabz6ohepm7o
X-Rspam-User: 
X-HE-Tag: 1777004918-540802
X-HE-Meta: U2FsdGVkX1/sjpRClH1ImE5hmm+PfzkxVbXbG54KFJGIP6SgORRbQlNUbpDQyi1/3akHvCl3LSGaFOHro9JYjr+4RXjeK3FN6S31YFdlkhsvNIOK9Hpedc3GzGYay5S7A1BABfjjCkhV426t6a9YsV4byrcX1uhp2SMejuQh6HhfE4qQr0sUneidfyNi0OjGel8zLIRKKlSw8ZWA4JFkfm5K7vgTk70N1X5mBVaIMoNOwFZdoMmM8xK/xFFiBDOHEv5oC9q4YhVzorsgO9pTqysCJSYo4TmvPZRyJ0/pGUiKUi+crBEsj32Y4eIvXtwhRToz7dDcjmv7glTV51U2IdWvyZFT7eKus+Y9TAyqy895lbZGV1+kW2RgaHsT1twGXUOFiUAkQcSfoDUkVLJXMrUyCNRT4fOzhgJRmv3k3Wfz8r7vYCxwKLuVh1kF93NgMZi6RwTFVOeo07nda0LD76AaaCS42obfKEvY1fKfNYLVnQCMqz8wYUTKRLpfti3jGKWZqaTPGeDVIYKNW65Jv+IpW0FEhvaajuo1tZt+BKkM/CWXob7qfhAWPlWdZsvcR1wxuR0IkMMU7hKBATv2/qji3mgaCajOFbYXF2sxrmNp+6yy+zZkaoVwe8ccaLvHsj1bvdmpyBqEMVp/LpQU2rt1jPk3l6cG2bHpEJQ7ZtkfmVo72rzkmh4g71ac8l725wrQTVB90qHLuBFLKwfSwSKcXy5Z21RFAcujmkWJ/oaJ+TUrHhmWly4NxOjzGlIXGD12MHG4okQkF5a1K6xzUcIj9Q8qh3uGQwAr+CnYM4HbAMde6pmtIIC7NL2aiGHv9fEv3pZTMG4LJZZH3VyWILglcSNXRNp9mZPthFU/l2gHHYqiax71Lf40aHTrqMcKZiAWQ746xK/eNW03wkYE74RyMY55dItjhfXQvgLFwj+7Am9HQ9HuaEFMAuLALKf8W0wXcQYv/Db7+XkNNut
 zHqzdipR
 6W8agQIzzHHUlN675Jrn+lc6+CIh8Jx3I2PJ7ItAoCDPei8tga6eB7gAdpCki2XE29Diirr4qBO/ct41P0fBfNDAiEhY1GHaNU7x7ImO64RIhQg1rCAt5hVGDgsHC4TsoeQT110cLQfWyTPjHXejkEnG7aIV6fS3lTaAKmxc5tCr8d/s7qPrNXlMgjZRZlPm8Knc1pIMa06qq3KVUboXnZYoi7+QwgmX/VjTW90z/a8PQz5WsxGO02Gb+lIcaJyhl9RtfUPn006QsDxFYlILBqk8xYYU3ZFSR9x/H/ue0iF8eVEHHNZuxiejslzmq7Nhmc+7utMv54gyp/bTFlYYrh7qaKGlqnJkEwS3oiTihC0rXGsBqR+6N/LiX7nDnuklq3OgiU9MLl7C18HScDfGkLwvwRSzgC89Ga/rE3AqXEftFWO6tssdjzLK14DXZOoINNVjf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Christian / LSF committee,

> The preliminary schedule is accessible here:
> https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?gid=1852749899#gid=1852749899
> It just hasn't been liked on the website yet.

Thanks for sharing the preliminary schedule. We had a discuss about this
among us Me, Ojaswin, Pankaj and Andres too is on the same page.

We were thinking if it is possible to extend the Buffered Atomic Write
session into two "continuous" halves of 30mins each (total of 60mins)?
Looks like in the past couple of months, there has been some good
discussion & progress on this topic and we feel a 30min slot might not
be enough to cover everything, since we want to give more time for
QnA/Discussions.

This is how we were thinking it might go:

Buffered atomic write: Usecase & Discussion with Postgres
I think in this slot Pankaj and Andres would like to cover:
1. Buffered atomic write usecases
2. How Postgres would like to use it and why is it important for them, ...
3. Q&A/Discussion

@Pankaj / Andres - please add and/or correct if I missed anything in above.

Buffered atomic write: The writethrough approach 
Ojaswin and I have been working on this and since a few approaches were
tried, before we landed on the writethrough model, we think this may
need a 30-minute slot of its own:

So, I think Ojaswin can cover the following in this slot:

1. Briefly cover the previous 2 approaches on buffered atomic writes and
   what were the problems in those approaches.
2. Design of writethrough and its use beyond just support of buffered atomic
   writes.
3. Performance concern with the current approach (not sure if we will be
   able to get a thorough benchmarking numbers, but will try to share
   some initial data at least)
4. Q&A/Discussion 


Do you think this is possible? It will be best to keep both back to back,
so that buffered writethrough can be discussed in continuation.

-ritesh

