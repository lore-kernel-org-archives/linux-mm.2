Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DCCECCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 03:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0908E000A; Fri,  7 Nov 2025 22:01:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490FE8E0006; Fri,  7 Nov 2025 22:01:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37FC08E000A; Fri,  7 Nov 2025 22:01:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 214D98E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:01:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 966D813B928
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 03:01:42 +0000 (UTC)
X-FDA: 84085939644.20.0512917
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93444140006
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 03:01:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ccj8oQjU;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762570900;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IvQMGIBRXMAfRMIt2kKWb8Pd94P2qwTUjsmasBUxq4U=;
	b=Ds3L9gFjGiuZHsScmfto/3Qj+m2/sor8Fb0XoPo5sP3/o8GhZnz4I6lbaZzs+vBWtDop2F
	0ScP2SGgdriGOP0w3NTJuT4nzSbkanUE8WKcTUpD3jSPfkjoisF3J/qbwHvH1ld/+Yh832
	raz3R3OpGnz0JNZ+TcSV5i/7JmFM5oc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762570900; a=rsa-sha256;
	cv=none;
	b=GuUSki11ag31q1ezW4DvAtL5HgdE/FiOB1bi+yFiPDS0y+M52p+d2f/qulUjM3/hAjF0gy
	IWn7Ruvm3ku50q+mxdexRPp6YkOrNbbawyoQ5rHyhwqChe4N8DrHivxAO20ExkIJR6n/Nc
	D9FSwrmEltDf5lbB07CFeg0VwQWuceg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ccj8oQjU;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b5a8184144dso179534766b.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 19:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762570899; x=1763175699; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvQMGIBRXMAfRMIt2kKWb8Pd94P2qwTUjsmasBUxq4U=;
        b=Ccj8oQjUXHDqgkFCC6FPIg+C0FDsRiE3i6rAOY5+xnNqDgWcpBfQwYeXhjFU3Qo/yL
         aHTPOWq7p5BhHnTXUTnK9edHlC0YPo8NeZcY2KyCdzHHxUmkBCetD6O8JEeMuT8If1WH
         OHiWYTd41Ue2z4rscxGqo8P6d0bxezzhPEs+CKeya/QnkuMbAhGlEOAaBLvBOyWyvUWY
         GU2jX8XjpxBwUFj4AUBmcHTKWzcjECco/Hy2jwDQYKBQyvSLyBNArJqTatnIEyqGGik5
         dB6R+U/ALpZNRp1d+5ViqPaqfJX+owauYskoF62uRu3IEzpW0kXvbX4mJV2MIxYIyc0l
         zjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762570899; x=1763175699;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IvQMGIBRXMAfRMIt2kKWb8Pd94P2qwTUjsmasBUxq4U=;
        b=pssIgx7nSvV+NRbxJfKX6Vbhu1CRRg4m2CN+RrFV46M5gMk/m7LoxOI5YFIHJHX+6r
         ppxKeiroiSV5UM53XCZDuitV7lNnIo7zEtqrl7nTuvgxNVXCShuayyGnuB5J1wFfD47b
         YK+jB+6EFIk/DHfisbn8mxcIYmdRwQ/VUFIC5u0CxjJhqewhV2beGM7obFO6Y8AjpNCu
         dCMeu+JW/P/rtz0djn3Gn3RVPT4qzCwNSVtgEQQnoWlyn+VPsv+99T5BOETCbQhqI6AA
         fLNJHCYOjb7p53+ZylpeXFg8JC1obyKaDGW1kaA2n9abAodpCWbgTC02k+CvoEVF+nhQ
         rpEw==
X-Forwarded-Encrypted: i=1; AJvYcCX6kX7I4QtWXptnrZVJwrgCQQpHDZNWBO/iLWBj147xQ8pKMNxKU3kuEZIS3uaDhiUsznDH0HtPdw==@kvack.org
X-Gm-Message-State: AOJu0Ywk0tEPSVSUsYnB7FaoQoxYbxstVo+NBLV9e78v2Ep2yxCosUyo
	6OjV1QancM8ydLFvKQih2l8SiMJpDW94uRzsp4i3EJpI2rlppysk7tp6
X-Gm-Gg: ASbGnctaqWQz4BXJY5McWjtOLyXehAmYuJpDGs8q0xBePSdp+4gq5FipxD6w4OPbaS9
	MnYBZYVDtmly/opAywyXoisi7lEc6gO6cWwQGL8vWNfaH+FPyAUundVF0qp0GVG5exqCVH0mj68
	B0yRnwILAF3CCbqUyUtRBaBnVwJHJzzkAaw/uTnfZgjhBKU4UIvC2Kf114z1XCc+lS/jFdKMkxh
	jj7/BmY4oXAWjenZw2g3TXpPYvrNu/q6b9EEun0Nsr7Bcnj5A1K1vFafdrHbL3a+54AmypAC7v2
	S7VUB9QC6NU59eQTl08/nafBZdddi63scal0d1YZisRJnAC+Z1kyXfDG9VQmvn+N8/LCK6OoMWT
	9zJW1hS4oeDRrUWxFdKZ8zN+TKXHxcOpJ4pq62z/jAhiQsw1rlOBQmQL+ZoQ6JlSBdAtURI76H/
	A=
X-Google-Smtp-Source: AGHT+IFpe9qLqPYcxu/67GnD+yfSvSPuX6hzgETXb3TcPECOp4WGRyEJjWKfcLIhMsnwyzl+jMrZig==
X-Received: by 2002:a17:906:7313:b0:b72:b8e4:3aea with SMTP id a640c23a62f3a-b72e02b35cbmr147921966b.10.1762570898658;
        Fri, 07 Nov 2025 19:01:38 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf312e25sm397398366b.20.2025.11.07.19.01.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Nov 2025 19:01:38 -0800 (PST)
Date: Sat, 8 Nov 2025 03:01:37 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
	cl@gentwo.org, jglisse@google.com, surenb@google.com,
	zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
	mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 05/15] khugepaged: generalize
 __collapse_huge_page_* for mTHP support
Message-ID: <20251108030137.mud7xxwg5fxdgm6k@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-6-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-6-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: j6femjngtxddq1namkogx9grq84qz6j5
X-Rspam-User: 
X-Rspamd-Queue-Id: 93444140006
X-Rspamd-Server: rspam01
X-HE-Tag: 1762570900-14968
X-HE-Meta: U2FsdGVkX1/l+S6MRhd1Fp9GoyPFcormzjZcvvR8XF24xzBvS+phKd6tonyc47gNv/UnYI1RYNMbYKm8B1NHiVuk9IpSKNt4eww6Izy46slZHzcBRChQxLG6XHoS9wX8GQEWtUHisIK1HGRgsipzLnaOjp4pJT2jyiF3Abnae5OHqSTrdMSJR9/RLKmuYzEQ9G0maHIRl7GxLRjjkG54UwoLXB57L/N30Aa5lOzaJ115xeEpvHopRMGp4PHGDVhv6CgWK1oahpegLYxDC4OTo7os/3JQaMBShRYuDxmh67sbP1Ggg8spzFc0LA0pdzYVv+Jpo9fX1hlZuENAHZJbXYPOTab1gYC1+57v0a4A6I2Hkzv6AfqEvHPJy856GPbTGHJXtmYOPoQYR5CPNKi+j8qfrzwCYdoQdkg9IJoaNgQbRDK150UbZ9g/gomPgu5tvlgOdUrKDReVed0qGIYrRWuwo8FMf1on/WomEILwNTD1BOKufu9ALsZhouqh7zin7TMW8N5glaVF3rJAJIY0SYLXLJDLxQrVmHROQYhYai9OoiI9zuJxJzI3GI96rOfYEkpusTPQy0vf4hmOLeSCXtZySMlVeGxSzHcFLGWXrQVCqt+6pMRTgM1t2n1O7fN4KmaIxY2Ql8NNi82lSJDFr9o1yQRY8CmM/7Ir2y7gz7NxpQBnbvarJymwewhv+hnnw4Hj+JaqGiGPq3NBjTs2CVrFzZkLNtd3YV1zYvpVAH2CEw1tR5QBUXt1fmYhur402K9iOFFACC7XwyitQ6xWNbO7J5eBISy3fNBISctr5IFoNES7FhT9ZDzQjcGf4MIVSnSYqSRbvfTOcY7lkZQFTcsoptfWvPq3DaAP7xgN9PlHO/LyRBVzUJrc8tyukENZ3DClo/a/uDRfFAbBtJT3DZvSjS5kmmAxsQtbm4rL0AdPZSuyrTYOLXV7A/IUPwWO2W2IDyj/Za5oqjjZ0Rv
 bDzQT9es
 aEb9J4COeV2S9xtmG5kdUeGOnEFYFMQmbfIQ+1PQKQ2M9q1GyWbNH2j89qzsUpXoPDK5Ngj2Ky7b/PtA4gx22nZ/pcb+16g9vP1wvY9ZzgsnkqJavC2A4kFYqwRO1Y/t7hnwSIjY9Hc9klXs/jyFnBbQxoBawmVc7SfY7HgDHurpZPfANTgaB7gIQimhstJjaCNmTIBe3+nEecY4LvAI0O8HxDe9btRXeLXKQaZ9nRE35uPyTix/LQ7T6dKvXqdz1TbMG1tF4rtAu5On3NdwXmGQQo60XBQAxrTlA/MURvU+MqDX8JNYHW8zmqUI4H///OgTvVJceFVYhRv1v+O1Cp24Oh6G8pJloBsgMkhZahidgL48apYDkjoAxZsjv0T0vK6RgRHAJJNqFoWyRfxcF+ZWpXBmy9wi5rXeftZ7eOQl0xERrN93StLx0G3yXb1zTJ7c294jJRhjKSlpoFGAZbYzfTjKSf9GX+fowMWTrHexd0GPKEOrl2QJpS52/CTz+O+NQyCfgEa6RJVanGI2TW+90PPBvfUKX61BXeEWs/W1gg+Xf9aeGpDKIsZmxYqq6sBEAKmMQQf2JTei3ZExG6ejuRcfWwCHpUiz5tZ7W5dT0fAKFi5yQT32K3C/hGVYbVCtwbzui/Hz6QjHG5tN4B66Wk73lCHKE9/GyXm21NIT58nvOD2x8zMsNeZUSVRKxaE8ZU6C5MfobdC4Jp/C/MDoOVRH6uE6mtCnmwUQ7/qCok13hHr0MswbNZCu+UiQUcFjo5ewbN3tUWopypt2zrtZE4S5BRxgeBmPWd05/pS0Zq1+WEYmkc/fkNSdLEgVLIVoQ6SKP7j8Xy3xG2xKSYEMij2fvuiRWdqyVgY0kE2YBYr5XxPhZF2KXa+Z7MkJ+HcND
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:07PM -0600, Nico Pache wrote:
>generalize the order of the __collapse_huge_page_* functions
>to support future mTHP collapse.
>
>mTHP collapse will not honor the khugepaged_max_ptes_shared or
>khugepaged_max_ptes_swap parameters, and will fail if it encounters a
>shared or swapped entry.
>
>No functional changes in this patch.
>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Co-developed-by: Dev Jain <dev.jain@arm.com>
>Signed-off-by: Dev Jain <dev.jain@arm.com>
>Signed-off-by: Nico Pache <npache@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

