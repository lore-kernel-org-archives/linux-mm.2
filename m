Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85233CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 04:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3816B00F3; Sun, 31 May 2026 00:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2CAB6B00F4; Sun, 31 May 2026 00:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4BE6B00F5; Sun, 31 May 2026 00:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5656B00F3
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:40:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 233C58DCF2
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:40:28 +0000 (UTC)
X-FDA: 84826463736.03.00B5232
Received: from outbound.mr.icloud.com (p-west2-cluster4-host1-snip4-7.eps.apple.com [57.103.69.198])
	by imf18.hostedemail.com (Postfix) with ESMTP id 514C51C0002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:40:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=kaKYiBTF;
	spf=pass (imf18.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.69.198 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780202425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0v+AK95/DomgagXm+aA2trUlyQrybSNCOrQtZ1lwCg=;
	b=uyMm5jsOn/f9w+ha1IXd2gqv85wS9qilE4/VkOaeh4br6vXBbqSgFvSiHYUJn2P6KWpNXs
	j0ymX376EPcrUz8jKZNVMRDVw4+gjEszR/hXbPETG4j+maiHjNeIU8DU6AyPVG+Zul7AYa
	yosgIqLZTXGLXIOgrNcOhGRw7PQ93V4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=kaKYiBTF;
	spf=pass (imf18.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.69.198 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780202425; a=rsa-sha256;
	cv=none;
	b=q4SlqDYEtj4ka0n6UhMvWhpXXWILXTQng+9ROGYkzk1QKtuu88lM6MvN99ZSSolZPwnWUk
	bhHBwoobQgMSCXccB6zYQZBwoFg8ii0+Hr561v60UGZDDDQgdqreNv7kUyG1xM5oOiuXY5
	cG5pk9274Enxs+z8CYCBFkX5DhnplBE=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-2 (Postfix) with ESMTPS id 53847180013D;
	Sun, 31 May 2026 04:40:20 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQUZWxgAGXgBXBJYCBoERkkPOH84fCpwMXBVfi4GVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1780202424; x=1782794424; bh=n0v+AK95/DomgagXm+aA2trUlyQrybSNCOrQtZ1lwCg=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=kaKYiBTFsoslWZtWBNVh+UvncsFZS7zsE2JGDMVE3g+MWqfZ8NbC2hl7wS3zqOLvoNmdpaitT6MEVS+fru8J0JmxzXfLbLjBdsGtQQ3XAOFI5wRNL6b/scQqnU7XlIFoNHf4L7Lw6LUqQ3abhBBFvVOYZ5GQ1L2+e6lTSelNt3K294E5WMUzPDQx7egbUnSON18+j9ZuE08ZXAU9jOEHqPB/Yq9SR9cws1EbxvrtkD5Ji4yxDRZ6kY/87NY+1eOqr9YO4EK5zyxFjTBkZH28uX8ptvBftALSOvofrOFW7Xz3b3KYjY4di+RqxSjb4rJa61AgF7Qr/9EBA5o7Z9U+mQ==
Received: from localhost (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-20-percent-2 (Postfix) with ESMTPSA id CF8CB18001AF;
	Sun, 31 May 2026 04:40:18 +0000 (UTC)
Date: Sun, 31 May 2026 12:40:12 +0800
From: Luka Bai <lukafocus@icloud.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
Message-ID: <ahu7rJqejke-ot96@LUKABAI-MC1>
References: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
X-Authority-Info-Out: v=2.4 cv=e+0LiKp/ c=1 sm=1 tr=0 ts=6a1bbbb7
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=GvQkQWPkAAAA:8 a=1x-ZuSSpuTJnMfZcizEA:9 a=CjuIK1q_8ugA:10
 a=QYH75iMubAgA:10
X-Proofpoint-ORIG-GUID: tPGyWFfpeYnRb3Isv1nwXFN21NF7ofRl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0OCBTYWx0ZWRfX7OLtb1udWGas
 fxnHtqQRX3WMEXs0NJr1oM4PIa+T/LYyEcEFtLtwzfkgPXFy0MHe4PoFbfLZKcKVRbJOXCtgXkr
 AvZNH959kZ57Ux87fZhtqU6WfOZ+JVk4rVd9U8MtQeIO6pxvDnFf76fbN4q9TACcp5B9ojP5Qnf
 siBMtT7gZ97veppnamhVyQeQP1R6Z4INiYDi04g4Y+mXv9Bpfi3JDCNMm6zvin/Q83j+vMEhQAn
 xfN4kXUoB/bfoxmMhtdjhFZbGeWT8m7Qet99kKt3zMKfx8J28OcFGhaKP5LtYpJXaqrRsUv1tHz
 v/Rz9FuJiAGV2M+x36E+/cJaZHrHt0AUlvG0HC6uAzlBSySbfvXUKqKNbt3D5E=
X-Proofpoint-GUID: tPGyWFfpeYnRb3Isv1nwXFN21NF7ofRl
X-Stat-Signature: uzq8jicj4nagzamjxakpdm8nbdmdj3xr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 514C51C0002
X-HE-Tag: 1780202425-239647
X-HE-Meta: U2FsdGVkX1+nbKc6PkaLGmn7bsZHBONQXXvbpuE/AbWumuyhIhDEayzmdmd+2NHPdpa7bo1bs//5wZhCRLAVf7HbqgsKtBMil0nMRYbAHhwzsN57cPcothfGUjzTrsOaxUX5Ii8MVDV+Q6koKuXi+wfn1raX+FTEpvDs5PwUS5zXVPrinxBuWmrThD6CgbXiF4iKqo7hOXW8fLmlBJ8mzf3ug0KdiQf0S/qUhHJgOXct0TXdMfaZWiTYT5FEEkpZhI5v/3dlpgsKHCRvPaRLzx4QT/w68mXxnImCHrqDNA3jtyokVR5zBMoXXPYQciAzwh8ZNeyKi0o+DJsIlUSkixWhfo8QJHkZGqD61VTTmtyMIfdufgOZLcpL+btmLIkxfzvGQRKP4D8mYWz8Rz1y2MZtn8A7L3ErJ+Rk2Lw86vSouT5z5f4muEgi7unJumh8R+xWaBN7SD/K1pODdWZFFcnDDbWWe49IWhjOIstpnhjP+0AMHiyJPC4vywPmRdT2rfAAzbwGinyOX7RMq8bej7E9KSaNCc0iUM/lQQM45UilOcJRSFevmC8JvtbWrSA37OxLn63FS52SDmpsulodUh1Jy86QHY3Sv7WHpuVCIci3j9Aukh0IueErDEPYYlEgBHRfEaeiXiUeBzH4mOT6WLJiX8jydmm7m1Aq9o0ImeqwrphMksEsJ39j/nzhLVlc9vQbYGEqFPqsDhEeR9Qp1Mvpj10pl7xc6Vtd+sz9BESTnpGFr0rek7OA5ubm0+NT7nsBkiUmECvowPw2T6NRgWnaWj5u0HQRT5sh6i3yCJ6ws/SLfrV5WtI03etLpHKzuuZllPK7aCAgWWnmCY0U34KXWM6IeFCntJ4on2lkqNe+ScnThXrxuDe4LF4zQDhlUcF04LpjAUAb9ehPf8hKUUG2dVG3v/adj6hFrIHlMvLluy5UqQ2swBwybg41QtuVhC6jjWLncoEepOBKHGA
 0doDm4sV
 PkZGHeIftgHcRjFu6zgToEy+JMWL3lvW1NanB4OBfpbkPjJVSFdnx8Sdx5su7DYTaV7Z6cB4BXabJtWGrAB5lo2bgPnBN+Sk3bcjeAo8XjBna1IcrT4+fPcyVi8byepWuXXEymdjklkZ/Y40pn9FvS/odIMyPofUF20vdd6c1lQ5n69wqQfOWD2BkBgCDV18WNO61xxYgTwhWglY7WQyVRc0HA3eJrctmqhx5kVG40MfVfwDrP3IdkdEHTDk6eHoQFGVuqasaEuNBMe7cP7MF0LoiRZ6Uo9qDWTeKBrCiUOYpd1p3KELX9u56SNZdNKXFz8Xfc8zx0j9osRUwR87LWSM6kNr6EesbzFBlen/jHKmbjydobMXBwsMiYJwAk/4hjlBrT+JT+5SCEHMfUwzw98FuYlGRIqkeA3qm8gNtQ+4i9f9utCgAWLGE/qrp30Hr2mUrenhCwv63UPlh98snsKWOKYdvtFnV6PWKYdMBnKTxhjWrg03y/7MF2fL+QQ1ueB3UYFfvxPDL57MaGvT45Lw2DZTz5yJlDviG+lJQap44jqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Sorry for the noise, this patch series was sent twice for network problem.
The original is at:
https://lore.kernel.org/linux-mm/20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com/T/#t
This thread is also not complete, lacks patch 5.
Please ignore the duplicate. And directly read the original one, thanks!

Best,
Luka

