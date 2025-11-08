Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8E7CCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 16:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474348E0007; Sat,  8 Nov 2025 11:03:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424408E0003; Sat,  8 Nov 2025 11:03:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ECD28E0007; Sat,  8 Nov 2025 11:03:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17CEE8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 11:03:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3235BB571
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 16:03:49 +0000 (UTC)
X-FDA: 84087910578.01.E67CD14
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6E70C0011
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 16:03:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IjrED39Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ankitkhushwaha.linux@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=ankitkhushwaha.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762617827; a=rsa-sha256;
	cv=none;
	b=edfTe8jErIZNpao6EP54JJjiX+lD6XJvxyseY/j+FDbkI3JusutnB5kQ9bM+P1RLSqzfaE
	/mWsC3h+vFNNZsEDGSjZH5CvF0lM9FmY37HsalN7B2oDBaSivcv0+ksuJe37Bp9owI/y6z
	MotYBp7N8/EiAIpBsU3qNsy6wBfbrI4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IjrED39Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ankitkhushwaha.linux@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=ankitkhushwaha.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762617827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuVjvWt5pWlBdwB9kStq+sIEfsEspJe0fkwfw20IDZE=;
	b=6G0VJOwz5AgMXqG5sqjNGRCScDvcUKdPRZ1z/MVlE20Q4zVKa7v+/gP1FL3Q7ceVmZqfS9
	eyfPzLER72s6s68SOBp9QvA8k2ZK17W5kggS2dl0jAPzlw0t/2hRDKYjU0Pt18qwob8tJ9
	e+mKYQNqlqHQDJcQCH5aSJARabhAWbg=
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-b593def09e3so1090349a12.2
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 08:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762617826; x=1763222626; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CuVjvWt5pWlBdwB9kStq+sIEfsEspJe0fkwfw20IDZE=;
        b=IjrED39ZhFDVptg0AQPmVaHJb0L+oBY5TbFvsVt+6eJQze6zLTNrVWvj7wxWNXAqgY
         iz5szDRUbMCIFxPuh3/xcziZqFnF/F+9mnSazM1cbf4LASaVKRtv024iR5q7/P5UIyBE
         64xjy9o6hb4low6knLClVoVqkX7X3I5gCpj7AGLwRfC9bWSYZZY352GPhboeywn/onmH
         DhJb7XyGHotDEAOPf9+mrBDLJHysmTeWiQnRvDgj91Xp6rZYQkuqeCdCS2mrbjpqEmvZ
         hwIl7jGzhMis084FpMc7ps6G5aVRRy1cSIDwGoPkJ3KOAocpoUNnY1z6FqN5Q49FjiVN
         cPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762617826; x=1763222626;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CuVjvWt5pWlBdwB9kStq+sIEfsEspJe0fkwfw20IDZE=;
        b=ORrD1LYrzwqDzQLGeuJ48EmzdfT5Fv1N2/EruAmL9BoOrk/zx4Ljm4vftlB6xwaKYj
         0+FeSC8Di9dhuBlwyladwlQbzPFOPIsK2sIIC/Yg+xs+Gc4IMU4mCYiBmCBsvWxBfuL+
         z529mWBXBIZYnN9i5HJZsPlSkylhohFneausV7QvnpmrlgyZ8OhjC3znvMzyEEoGe+/B
         2kfWhMn/heC6P+ZbwUp5h0xxa9gbWnX9U2O/EBzbqlbB4pSMwawRBXByFGnPYgz4/1NX
         8cU5sYAouLKnUWcNuyxpNgNzk1CvTWnlHhEmj/YFxUqnApeF5GGp3TBjc4ZIvPFuZK+G
         pXMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwekIlB8viOoSYpn82IlGzywGdXXUyhVkqmajVLVNjvBsapDLvHw4iDYzHaRjnkpY1IR1CFlOFVA==@kvack.org
X-Gm-Message-State: AOJu0Yx5TtKMfe51CjLtZicxGSWHZhr2vujqCDwYlpIQE1x7HlCXf1uo
	os9oTK1YHkQNo7+Z1ahL/AfO95FFFQ0zvdwFTj1jrW5rIy9IIFSjTatv
X-Gm-Gg: ASbGncu7Po1Pyu9nz9LzNTH7yBcgTA1laf970OqSY0aUF0Xsul8TdkJyem+sElbEm6e
	QYFc1ryIzqUDPIaKKrdSZfqLm9h9qzwL3ZZBdhSXyQM5MfpH3OUkEgWoNC5/hkActz6SY2t7PB/
	8wK5yjPk+PJI3RoWLN1qXmG75uZln8zcPuE3EYJTrpLcsS90mQZhKrCQk7j1ajIGHrJdx8sL2eR
	O8Pv93UuFZ4DW5hbnyfKSO7B0ME8V+VbRJqBqry3Om65gbiBAob9Sx0H9queibVnbBggL4Ovtl0
	Lk+XEZ9K0C3RcyLY6TIFFooCVOBRuC9vkUdqA+usx6uTPu4aNI0wmxNIPracaK0jemQOEX0rdxX
	j5TQyt5GXYS+MZC39dfzofBf1FIYk9rwdTRhobisK6ku6E2N3gYscjhfwosbmDpyC4TfntW+UTu
	kJ+DDTTYcRWd9AG3CGmL5W1mek0MYDaWUn0IpkwlaK
X-Google-Smtp-Source: AGHT+IEE4oksO9LbHCgRQRuTc/gmfnr3f8yjUh+jBjYO6mFyInWa/Uxiu+FDx81kzpxEEQ/Iw2vrsg==
X-Received: by 2002:a17:903:4b2b:b0:295:6427:87d4 with SMTP id d9443c01a7336-297e56cbe33mr33577915ad.50.1762617826483;
        Sat, 08 Nov 2025 08:03:46 -0800 (PST)
Received: from fedora ([103.120.31.122])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096b8f4sm93174305ad.10.2025.11.08.08.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 08:03:46 -0800 (PST)
Date: Sat, 8 Nov 2025 21:33:38 +0530
From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftest/mm: fix pointer comparison in mremap_test
Message-ID: <aQ9p2srpUtRG4Ltp@fedora>
References: <20251106104917.39890-1-ankitkhushwaha.linux@gmail.com>
 <fc051006-5cb2-49e1-bb27-7839837439cd@kernel.org>
 <aQyOZ6eYng-IjxS_@fedora>
 <6e07949b-d86f-46d8-a68c-9717cfb26084@kernel.org>
 <20251107160855.58891ac6df6854a3b608185f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107160855.58891ac6df6854a3b608185f@linux-foundation.org>
X-Rspamd-Queue-Id: D6E70C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: sz9pbs19bqika6k4z7egb6uexxsfuk9j
X-Rspam-User: 
X-HE-Tag: 1762617827-987264
X-HE-Meta: U2FsdGVkX1/4WvagHZ0Snn9JFA+J2Uw0cchXsOaVM98z19HjCud1TD5zOox2i7voI6o2vmg9TcTCAoC+mSqsZ6XehBKkq49aMr/hrVyyJCAUBbfKwI9EPp8k4iY+UZF0dKr1d9rFTrfLk5QjU5Kz05frseahcY/5aLHydYEyW78ya2kx3vClX2x1f3EctGMltIcKstn6dnfH4YPd6WBQZgsxoo+1H9zCgaTjHlAiwaSu/OfPUGnhBsUZF54NzCiVaRrprvIBjGvbSqpXNi1tx3u12vkOwIReODTa/4zyiI+FzUdvwPYTqKhddegdBgRJOHMIvD5Mr4aA+ZjyKp05gFyfQqUXoC0b2I1eQrGOOm2CcxazZzgnfooOrOK/nCraw6fl+iQzPbtEHpiGpwKdaoHERWQwKbo6KUzWq9i0nhX6iAdTHfFLAZml16SunUuMk1iD3o86VDnXEz8e+UA3tdYCluk48KGPx3SDrfkoww6uW8J1M+r8evIxk/O2VVDFEic7/5tQG/Z5HhqwtfPepv1P6dJHB0y70/jAXrGN2Cc2bykwwDb8IYtWvESFmdwU0baH4ts+KxgD8ccFDFtgZFTwjO81KMzVkBBYe81b0x20jmjYB0ncE922scUiBGvENpGMSFWluMFKLDtv5MrINTJvSOu6jwbS3sXucAX4VIXluFogs9ytjs0K9TFxwp/yXbSPJCEmiPAT+twkRWdlQWsQ+yQZLPxIkckue3GOcxabwMmfEQdA5YGbbQGdDkA+C5PJ+pe/b92qtto1q+ngaQrM1sZWInczwNKzLKGKwwVYq7KImXLBYhZvTyvL5P44NEo/K6NBkqbqf2Q/p1vrEWimIPd727WRegaGgSzY/4Bu8ElfyvXV2C3b0UA2yblP+W+kq8tICWaiUN+s5rfLRgTDpX4BDegHNrL+v+mVCdLQlAuXpqvyhMWPP9HJ7LnH9kc6XOrGOySt5i7mNb0
 NBbfqwb7
 CJIed0r74lQnN0ATAddt+ELub9+w3ZlyTe4ab0mpVGabcUVwRlTJSlLcpNfArz3WgzNV/b3DW5P8rB+SB4Jk85g7a0bli7j/NTzQs32UqujYEalZiIpYu5MXZe5mDqpTyby+ybvaBI+ulSxDWTxU9YkP2LwgGFXthua6/iaL/ssY9eH4PhkD5S5UzNVG6Sz9uW0HcRbQhEFmdrKmng0IuOtUNIHF2bBPQhH4mA/WQvPa1km4Wi1D9gpheC+hcQQS8ib9+owOSFriL0PhODgv8oGZASbh6oF+rd1JnK7TldlR3S+xetCvADzZY/1tjZxEP9I/bL6uUOstH6Th6oUqrxL3+zyutviKRRG0wyW6k7BPgyNaSbHkrqJi+8pEqa3c6cpIrIrjiIV+MUib/09tTKqE45gUwZxMLiD65TRbZcsrwUpATdymss81ndOzK1s2GTDd86DtSZcsMC8CXJA4pgzGPBz99KWV/TauCIcwz5GwJGgynZ9AgKXd5cOuEhkNs/+obl4rBGVW9Z7OZvJLtiT5cfXEGMOkbHzeSM+S8HFfpF1p+uq8EiArhXS75XD9Y1OZkD006NgLBEN0S2humgZKn7DcLDHtnESeYk9z3FM96+eDSScAwPuqizj1XvxzbLP4j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:08:55PM -0800, Andrew Morton wrote:
> 
> 	void *addr2 = addr + c.dest_alignment;
> 	if (addr2 < addr)
> 		...
>
Hi Andrew,
i have tried this and clang is raising no warning.
I will send v2 patch with this changes.

Thanks
-- Ankit

