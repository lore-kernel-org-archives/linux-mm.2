Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C8B7CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 21:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B998E003B; Wed, 15 Oct 2025 17:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3137C8E0027; Wed, 15 Oct 2025 17:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229338E003B; Wed, 15 Oct 2025 17:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11C608E0027
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:31:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEB2158FB1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:31:51 +0000 (UTC)
X-FDA: 84001646022.03.72609BA
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id C964610000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:31:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ACWj617Z;
	spf=pass (imf05.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760563909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o41vuZjJtBNKQRqyuAm3WdKOiYyj4LMJ+UjhEIzRCo0=;
	b=nNJ+uf4N4g+M+p7ScqPwJ+g5QGKAfdXHqvWZpX2dU3dL5MF9owdSvFNzCCfsv3kfzEoR9v
	tLE+10JknKLJzEr4IIaNo80jVW/c7RSlRtzUjiKC7WzMn3pcknoCxSY8a9Wu8bpFa4Zx1U
	AeXikN/qFTEf8jydUhKskS+sZ68U6QU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ACWj617Z;
	spf=pass (imf05.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760563909; a=rsa-sha256;
	cv=none;
	b=OvxckpO7pKwGBIKuNjGdCNQpNL+9K3K8pGRCKQOg1z74/J3DT21VlpKQSwyewS7XAy7GdZ
	3QIm+O8t04e8cucyqlgrqPbf49NREJNkfeJmpIro8IubCUJhqYTBIqiCo1cYVTjmJRC2gg
	uV1QOl+/Yr6g5JkHJ19jl/XJ+JboFGw=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-271d1305ad7so863335ad.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760563909; x=1761168709; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o41vuZjJtBNKQRqyuAm3WdKOiYyj4LMJ+UjhEIzRCo0=;
        b=ACWj617Z6yb6iH2xPDpskokzhjBHUBG63YAYBLaLWFf4Illz6DIMdHubDfroPdRfM/
         gZO8b4DPvi/ASBEQiF4/3LTAb527Q2rd2si/hNttPAwyLYl7km4H00CLjh078byTyXbI
         cAdfuWeOV87asc6C1o10XFomKkoO0tFLRda+phzWqpqcob072OHKyZj0zW2yvdP8W8U7
         19rMiT56rsMfO+kbCyNofCvGumui7LrwowJ44Y/2n1YfJFw7Yz3PyQjKe4YDurlXaelL
         Zxs9tXgWaGhTp8F8mz3yimqpTbNb/IUuodyNFA9uFwWAsXGA4TSUtX6R5gOnzIg7cKgX
         fZag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760563909; x=1761168709;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o41vuZjJtBNKQRqyuAm3WdKOiYyj4LMJ+UjhEIzRCo0=;
        b=kOGCqJn3KrLsIH9Fl/XiOwsCYOKemW85BPqpLz8wbnfm6Pz+tBVXCl3KPesMu9MEap
         QF6+h4RecucEY7twADqb8CJMfoKrRwWRUH4KA9NowIso7HQ3qCKurh17z7tBju2t1TFJ
         larzarVNzhyngXGIpulftAembm85othgwbDULL6mbpcMHh52mIZcb0OFrEea1UbFWJIg
         Is+IcHW+DQsQO338qZVFweSC6Ll3aLrJVLCcZjBHKQeglAzaiZ5Xd7W9N8NZlgpAr1GA
         wRKa2xpIo53q0sU8LdOQ6ZQBNW87HDPpk5Cawqb4kybEuM8t0z/ZMg7cdQ2J8fElZyrw
         4y5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVAN0zcULeIHzRFVR5YZQaAHegYPqlPejrBoLTGKM4lmNnL3tHOr5B79A8QrqZ7TVAKInvlhIsB2Q==@kvack.org
X-Gm-Message-State: AOJu0YwVxGzGVXJVGxXeq4RpneDNrMiIdJn3R9b1rPxEdGeC/N9vxx4K
	ew74WkTQzDPCEDW05Ji/wnIWNfUhBG5YM8jNtBwq3oB7qRp15Fq6/ocj
X-Gm-Gg: ASbGncv7lpiaK4q/mwYexH+gzXhKMmUbuEDuK9dfSucevKLS4zOtI3Qzv5t9SHzobyf
	I5s5XtiLoU98HhQYMxEUmYjH76wvYz1VadNkyPjJdHnVTicr9vDCFjFBmNdTBF0wVSxangdDlBT
	/S585Pk/CZqXZOzx8cIoj1dXR8t/HYihtJaNSLheIevt6KCjXqQDCecNMuVXZE5FPlDb7RzOYBW
	KgpKu9CrLB1WCPiftngVUk36G1Y7nYy5vB2T5cgQc9SeVPGmR7/h4m1+Niq4Bzf/gqpKK3TySiw
	07T62U2DQ+32JAVGvsy+qKdTq0oi3N/SXUXu/U+tKCGo20Qj9x1xsb1zAHnTEK4a9ePpsKK4h32
	FevIdenFjtBK8xHUSZsqP/zjt/tVBF4PFN9yXAyJnP0He4sv8Bc0ruTcjuii+PRpJsELAgJselp
	+40EuvBIpa7yZnVhOzZrVOxJMFBl33qLx06PX7
X-Google-Smtp-Source: AGHT+IGLK2KNCFy9yJ+ADGHoDXWEeD5vBSwlRiksZRTqduHXWjG/eR8aCqJMbVLWcmpfhZzSaXvxZw==
X-Received: by 2002:a17:902:c94c:b0:27e:f201:ec94 with SMTP id d9443c01a7336-29027373e8cmr428236025ad.18.1760563908494;
        Wed, 15 Oct 2025 14:31:48 -0700 (PDT)
Received: from deb-101020-bm01.eng.stellus.in ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099abdaa3sm6039635ad.94.2025.10.15.14.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 14:31:48 -0700 (PDT)
Date: Wed, 15 Oct 2025 21:31:46 +0000
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, kirill@shutemov.name,
	tytso@mit.edu
Cc: Matthew Wilcox <willy@infradead.org>, Linux-MM <linux-mm@kvack.org>,
	Swarna Prabhu <s.prabhu@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Devasena Inupakutika <devasena.i@samsung.com>,
	Luis Chamberlain <mcgrof@kernel.org>, dave@stgolabs.net
Subject: Re: Optimizing small reads
Message-ID: <aPASwn_cHrJw3KSn@deb-101020-bm01.eng.stellus.in>
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <aN9D2i4qOroaktSc@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aN9D2i4qOroaktSc@bombadil.infradead.org>
X-Rspamd-Queue-Id: C964610000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xifunnf5hdxinr5bgd6sd7m4um76hs3k
X-HE-Tag: 1760563909-750014
X-HE-Meta: U2FsdGVkX18tE7QP1rjagXSdM9/H76G0QAuzuaOUFvlrnOAHLDjcIPIwz9JnZuDbHlZJM01uVXApZ0XBsBfQWLD7B4KyragdOUvvCuTVTiVmbD14FGOe1Pafuu95ye52W7CWVHWu30rjPT7OOgpQjRuOy82uqi/1DgwLMz426aNh+nG8EqwJTXhKxDeTyZJwjfAPGn0ZxrGYa9gITycHr45BHYC9ci7Di61TObIlgZ27RsC9BkwjMNnha3uuMipwbFm5QaRZ4qRFSLuw4r0DSKNFkfIq7lL/9BlRfqqGv5xKa/nqT8pdZWCUUCCDsBHl+Gx4I0VSaVRCuqzZ9sBuvnbLTuOvjmAAcVCuOgR2zY9mKNMgwjbFOihpp3k86+KdMmntpgs4SAIaVqXEU3wpn+gxV2/xntu6IKW1rRcZ7kINZV+k7amVFD7Q6pU7TjAKg86ZRsoysPC1H4+csj6BbJ7gTTEo5oGcRfRcDLR2/gdZHgmoRX7zOiAWIwh5hNTA/5P5ijx8HZhtP5OlidKTsnWl46Sipha4wzHXweX+0pS2cYPiK2O66E77cTtMF+5uN56D4lJ+5ePTPORqPSF+COCRt1MZGWQ8rVFr9+tZ+QqHUMJOUMMkLjdGKBHM6Ez3WIsgfYxdRxogvH1SYC+uQpi8HIWIBaNUsnxRnnGjs7O5wgPyVogZo9ZrS62SQfKSZjI2ZOR5tuZwyn6uMPqwuFm7dtFqWAcHm3RgykJVg0oUJzbov0EAr2hrj8Y+7gTvF1eZoXOpsEpWgyDJXeR82uPzLU9MsTBOgLn1WTbenozr3VxViMMni+JG8aevQRzlCLkHW/K7OKrruYj4M8uPW9xylTJo1neAaY9xinQp+XFWXacC9jpbsBVbstrhBbvnCy0xN4IT1JNvJCrs80X2Wk7qWICe489v5sH0iPMd/FrDKEm4aX8sg7bK11nMug0dGmFoXLGTwj7+Z2ZWmTv
 AQJgZL15
 6moiHw54xpXjHWOx4D7FgJowlVkwaefwtrr+td60QJB0jTBUEMkFCu2E0Ouo7CxDL9nvi0+2ElC1WCr7qPw3Tqmx5tRNUD0U6MO5uYcIEpOvUYG7Lvypm/y5G1QxivNnL/u1hI7RWeAvofA2CXeyLFm9XKIAPc1gdyJSK1a1iEox1HPMNIKNqiLKpR2jkKnpdPM69Dcf2O8m0LoA+JQiY4NKuc1h+G91zU1X5WNfaOKTjKCHF/i0khXn3TLK52IUDzbYyvHczS2VPxvioOuRYMt5zu4f1mSeNyDWY3vahf8erZLAd+++nBbZiGCcWPMsGRW8ycOwu/UOE0sMQFVtKJIOVQPVt+oy/GbdFN7QL/aEvsm9FM6hvG9E2EP81WUhIyqAUhdPztmJ8BtzOUDrT26mkZ4tpomA4iMeINrevggaR34RXdSkyUcYvUAXIWjcHgO+E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 08:32:42PM -0700, Luis Chamberlain wrote:
> However since there was no *rush* I figured its a nice candidate effort
> to get someone new to hack on the kernel. So give us a bit of time and
> will surely justify its merit with a clear workload, and with a thorough
> dig why its failing on the above.

The original patch was showing regressions on kdevops xfs_reflink_4k
profile for generic/095 and generic/741. I tested the same patch and the
regressions reported earlier is no longer seen. Further testing with
different profiles and Kirill's latest patch is under progress.

Swarna

