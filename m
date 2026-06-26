Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDA0CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED7B6B00A2; Fri, 26 Jun 2026 04:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5E26B00A3; Fri, 26 Jun 2026 04:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC9E6B00A4; Fri, 26 Jun 2026 04:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2C76B00A2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:16:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 836A8167546
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:16:42 +0000 (UTC)
X-FDA: 84921357444.11.3142C4E
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id ACA6CC0004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:16:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HK7C2gdC;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782461800;
	b=ZLe2oS5p/RKektuJyTgFjN9MTZ6VMk/cjzK40UPi1+8pFxPpcYhxk/u5vxVyGkB4DRJMBM
	Be4QdoB+S0DuYKn7mb60AI+Fpv+JTYhUsfn0i62jeDtmmLMhn3A0/KwfdjzLZbbwlc+qm1
	jv0C/iRU2VohjIUhdQcICkHDGngowcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782461800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G63b5nYObYU0Y4sNpYQEyJ95BJJfMv5+6+UUn5+s5qA=;
	b=ee5WVU34sBfAILDfBRvYkR/E85iwzNjGh0W1C6AgwjhC8Thq1wdueImLyaBUPbn2Wqz3f0
	Hq0m6QUdGZxO5hsXTdot0Y8AyjScDfYRXezbLXaD0gZD36LzDufXorIXtr1SCzW1+ndyeX
	mDY/2UabiJ5WMokzJ8LSgGLIbwpKkX8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HK7C2gdC;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49263703c6eso6497505e9.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782461799; x=1783066599; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G63b5nYObYU0Y4sNpYQEyJ95BJJfMv5+6+UUn5+s5qA=;
        b=HK7C2gdCCJDi3ZQocGVj6PzC4XBEJ7maZUpkvRIZpSK4vC9VmUJuLcHgzotn8Tc8kz
         vvCY72eCEBUndstD/a8AKvvTMqClDKbXKpnk0z72Id6yBVJQbjQya1qm8bacM+lfXji2
         ZD7QnIWrFffiNgkncPypn2/y3c6YbducDWe2w33Wd+GI27yJcrU9wDpT8jY7ftDzRKMC
         I6uFF4nUE7PfIOnWF7yGwrJ0TSJl2/NiVTGN4WxVsWwdGtngIpq1Xp6psKmsawighCvg
         fHaj2O21WIiJr2yyUN4s+MSYKPpbyfD7VwtLDN/igYzvPKONIohhBYNGXw0QkmzG9nxo
         6f5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782461799; x=1783066599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G63b5nYObYU0Y4sNpYQEyJ95BJJfMv5+6+UUn5+s5qA=;
        b=s9G8s6qVeWx5ilZxZu0ZJx9YaeTr2ppishrNWz1cgkXPQOGB+ugqpPU0je3g8pHva1
         iAPCpoBrkP3HuWZ7JLHgrqbHrorHm4odJs3+6VCjde+w/JfOGrCA1KAvoUz2GbMNXBx7
         WuFk0X5NdMBlhazC2d3cBXMpC6Irx/IeHzB9A2pErStaHamyPOwOYmCeZGn2syKhK85U
         FBVg2v/BbSSQnb8eQL0xkadxVrxN/EEoNmHCnO93ao511mgHT1dM9Hn7ttl+BOQs4viO
         xXURKzExlCFArcQpdY9Yxvy16gVwb8m2TCkfUmy7DzgFmwKiZxPvHdSBjU6C0Oha0kxi
         AFIg==
X-Forwarded-Encrypted: i=1; AFNElJ8CpdoeSArKLxSJ5oqdH9JmD5zki5p7mJh99P8lAe1N7V33Ajnk57t3nR6vW57cQ39eACO5MPxrpQ==@kvack.org
X-Gm-Message-State: AOJu0YwT52QVox2VCl8x2xP9HGTRtWYIQOgrI7rzmkK9wZQ6cYvwrKej
	kI2uSTDZ02w26byoFPC4B337QtydAecLFeepmNEddKTNurtr5lfwYgnU
X-Gm-Gg: AfdE7clkN0ZQ9elej4n6uL//5y70kAFRgrqnuvnta0JllK41uIi8svqvSCpmnaHfzNd
	nezYFMwgbrvlANVq3eJ73sd/W9ypRjDeBYs+zL4dHIaA2neGNXmNr/pBDf/xAt/5bRZKnngOK73
	dUlBxut+9GkKiS0pavP1Nnea9uVOjawaKHkBb7rqoMQzOwULdtyH6cafwiLcnQ7uUvjApccV2yR
	QN+tpBjLYmE4pmYinUFBTfTXpyZsy083yL45L/OqZAe/KHHDwlIANvQfQk5sGx86wxWyiggkS70
	e1X5DfFAe0N8MXFtzSX1mQ01s6tw4UCY59BatA1y6XWK93gEJlGKEnYq6mKmp/piD3yGFzPS0DU
	YXTRbPOejABNGeQAhMei8A67feAStrrtBxmL2GYmIlMep3nOvHbxDtR8R4DTAoBb9nxHjTw3kCL
	4zgUTFf7Zi+KML8OA1OdSsJc7rxyfXO+No1a33Xj14aXHa0kb6sQ==
X-Received: by 2002:a05:600c:e547:20b0:492:40f2:4d78 with SMTP id 5b1f17b1804b1-4926685ffd3mr60370715e9.2.1782461799049;
        Fri, 26 Jun 2026 01:16:39 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49268fef710sm106993125e9.7.2026.06.26.01.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 01:16:38 -0700 (PDT)
Date: Fri, 26 Jun 2026 09:16:37 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Zach O'Keefe" <zokeefe@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 David Stevens <stevensd@google.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, Will
 Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, Kees
 Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Message-ID: <20260626091637.484ee07d@pumpkin>
In-Reply-To: <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
References: <20260424191456.2679717-1-stevensd@google.com>
	<da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
	<6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
	<dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
	<CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: x3rs9dz6qinye8my3okaxae39jm8bo9s
X-Rspamd-Queue-Id: ACA6CC0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782461800-781343
X-HE-Meta: U2FsdGVkX19UwssYhuMymw3PJWckul6sofSBf2R1sTTVRicol1LlfJO8xIxkm6dWmhQbvjJ7t3MZc0lC2Sz5zcmCl9O6t/PbL5RGSESvZkOnBlyS4FN4qd/Dj4F1NTlmVGsrdNLb+B6B9wrHgJCdpX9lF5TQhl1+Cp0+K8wyGL0B+548fQn4BRYvxV90Ct/0lwAKkRr64KBfYH2pXI9wLmtJueMfwsVcCoOAUgesgurSqPyJHgzrVvjeuH7s1tORZCnAIm2GhDDRCawekwZ16QQy0NpjNpsO4smLHP2nYh+wGNYVNneAkUIjmP+yojz6WNZqbazxGj11hdPxekGKVsbBHfoNr3lQ6Ee8qXS+uBPz9jHuzXknSpCrExnFOBvrUcAXQoMMjY2WVHV0tZvXX4EL9C1Igl9n7xqh402c8Zm9PGNz5z77c3z+R2knG5Aoys3B+vAH4Y5cGmGZ3kTRn47OiNMH0ZYrljaH7rTy7k0Kx+C0jboRNGI/vZNOXzwiusnQooakhWZQrl91jyaTKqEfuA4t8IxSJ7Uw7NFv4rWsv86u6ldShubnQTGqcObsOEdfEK0Gt94bVKgy36cWPIV/gy8aW0fD4/fSdnnZdO6TbPhjwGzOZhAYYmr9lkwaksRip+LBhBh+aHFWFCx0u5XngyVUataAefxoas0iWWj4MMIV8iH8UOf9DQ2kR6KY55INO4CefWothyY0P3/jdIwiqCCpdd+++FqRMjS71Wx44HVEMc6LqTBfcX9wRlGgp9kYnPSNWmgN8g8sE9M1a9CunTeGvNMCpyfck/wnUYGnUA1D3cPVIFOiXm5rzsxsEPQrSZ92y50mvYzaehLCQ45hwRyTHvBICsh9OPqjRbHaNyRvcJVh1Pdsc23J+/3w3F70T57fS7FZKQsQobZHUAbuXDUB2zCIdE0iuVpS3QfLpYWBOql47Ost2IQkxGIFzJ9/icLhSUJvXezMMgj
 gV+r58KN
 NcFzwYvnMfWCTb3s3J6ur4cqIFKBRqTlFEbvNQD4eW7LtscqeltcICcK4Du3/55qw9bDFoL2F03/2+B2Xi3HDDOL7KiLQSt10HMdnzNlDTcRO8VRmY2sTIxqpbOeXF5WqJNMVK3oT52Y3Ti3EKQnb31GecimwKA7eDv2c1pc5qqgMf/X7XRocmfwkWBspRvnz3eYtF3aezpTeD5dbJyLTSMYOeZiViAGXFHw3yGc8ZYJPunrWHGzYEDxb23KnXizmHsepVdhL7r/DuM7ZV6EtT3XyEry9lewUQnL+D/EhFy6eNK/+LRW3mQg73M2J/cT9pO0syWvlQk6lnQF2+QSBcFXPySXonsrHKT340/jrRSyweO04Mpr/aawKFoy2x+T5dfMdix/74/y30Fb11hjsic7dG/D2etC/AJphMeA0lJHAN0lJj/P3JrXm4t/sMbTl1SQwyofR1ChGI0QkyHlXyUJ56uWURK72/6qQjrgrYFaqszI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 07:50:26 -0700
"Zach O'Keefe" <zokeefe@google.com> wrote:

...
> Dave,
> 
> Necroing this thread, as the potential aggregate savings continue to
> stand out for us on the datacenter side (whereas David is motivated
> separately, from the consumer device side).

What are the other kernel memory costs associated with each thread?
While thinks like ps used to assume it was just 4k, it won't be any more.
Even for user threads many things that used to be per-process aren't
any more either.
But just the task structure and FP save area are non-trivial.

	David L

