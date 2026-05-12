Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6D5CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFAC6B0088; Tue, 12 May 2026 03:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD116B0093; Tue, 12 May 2026 03:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214646B0095; Tue, 12 May 2026 03:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14F2F6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:24:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C81911403E7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:24:34 +0000 (UTC)
X-FDA: 84757930068.07.E66F1B9
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F46A80002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:24:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=KTE+l0RE;
	spf=pass (imf30.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLBmIVgGqAm1WgQmG2CCAsu20EJzohul4rqXqPsB24w=;
	b=hLbFhtE1YvaUkzdMX8ynYGAkFaRx/OmzHSw/5ISJ4gSfIaiiv4i15qBnM+pb/WO5bgtU/4
	oXEfeO4nVCadcM3Gxc6PSSScTMaSCMH9nIjX3OQQJtT2gs/C2bP3ex221N4EKSZsk+TT35
	YwF0tjv7o3BH/pakCLgm1seRz2fQZ1k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=KTE+l0RE;
	spf=pass (imf30.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570673; a=rsa-sha256;
	cv=none;
	b=ildC5xq3PIH4yfs5p5SJU3kEpJKt57SWH0PdQkhfKH26uEJUK+KMPNS5dlFR1hdQ0Ltaao
	uAXBQFh2jpOQvJE9/L+5pgKrutHo1d14+/sBLHy09c7j8KhuPvLOEB6P+KQcZaG/bWgV7a
	w6w2bF2R8/YKgPR6pxA0/b0QY8ign7Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778570667; bh=vLBmIVgGqAm1WgQmG2CCAsu20EJzohul4rqXqPsB24w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KTE+l0RELO6nyyJN3zhI4UCsnTlSEqyQ8hXGxJIrpyI+ENz8HKuR/mhvJC0UPCYfE
	 pm+gP6+kfBVf+dnCYyrVKUy8GyubzOMLtkVrlLY2QvhDy5dI2IPp2RyP2PfKZWSn12
	 amyCS77BMDy9P7RMEMON0xmW5RdKojy1GNpm/1MA=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 618BE4F8; Tue, 12 May 2026 15:24:24 +0800
X-QQ-mid: xmsmtpt1778570664tqfecap3n
Message-ID: <tencent_B49EC91555E7B93CE646566E0A2DBEB9BE09@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+Zap4hDs08HaF9zaVs0jQUNat9/uAQOz37raUQURZq4YA3VcyqL
	 jp7SC867tbUdYkbU2Iyvagw4v/z9+peY6LYMDvbsHEUABQSLIBCSR/8adNZL2DuA9Vy4+K5hDe3l
	 Hj1UO7T93RrfIkothez9lPMDm6r7QGhjUaVDlqomBgw8t04Wic8H3sDUhleBKMubQeXr5VeMZTsH
	 4hlbZm1H4L3Iy0t0T1tNu7ErtKCTvoTOo2dSHaGq1Y3GI3EFaS+jwHXyDWRlaKSgdlpu8hgmb4KV
	 FiDv7I5G6JeooJsOG+wXcTv9TA5o/WUZSHKhQqieUZuZDDUZmAaGy7TklbTNGLOOg39gTGPD07tS
	 QLfBOaVqU31xFiOQhBxHFNVpDLYrmrQ8tZZ2oEP0OLTW3jcteg4CemI+U2kpc/y9mr3YAFmij8y3
	 QS/rKos6zcEk+ffoSFRgDeYkDQ9e7goL6IWDdPTbkkCZUL7IpIEv2TfOCaff9qcoRB55r2ifGo5d
	 XccaXYDTD4KrcWNukBZWdOcTC/QB6R0hHq76anGBsOVVAb0hbg1AYC/Ddw8PWyZK6MCx5Tf2tGBD
	 7cS1+t6ogkYPWpgMh2cU+Wr0auE+RVsDe3Yog0XHdwcPjO1mQbDwJq6RgwKYIZzEwe7RiTnG+7hd
	 B8ZWq9Puaz/PqDPu6SUwas82INSo5sK+mOgHpq1zYoF5bMqSpTtaOa5eEfof8cU35uEEsZgbG+CU
	 c3XJ5RHSCYcbEWnTR3rTPwc4GhoEcm+gfDNq63C8reFUNOOcV596oXLeGDBitE0ZGTAx1FOpib6F
	 j6irYa468LB3Uf1GxSHrG5+KovLQWbGP55HyVutTJDs42KmSccvq/Sz59vQ2//FlRgUQ4FvH2EnJ
	 aRhQWOb4TrG9GSu4JI0PZ+mqFvP7TiZT4lZ4nZ7tomtI1AI/w0W5uatsgQjSwi5aNyvDJ4iO2Xia
	 ZnUFpzGEqVuZxMVibvgoKm+TwZdAnvOgwpofh5OD9EOUATBhBfzPTNch+4OvveCF7RBEMd930JAw
	 9VbHj5Aa20yo8/LwoT
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-OQ-MSGID: <49f042ac-7bb8-45d3-9e43-97ab00dd0a96@qq.com>
Date: Tue, 12 May 2026 15:24:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
To: Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
 <agHmO4i4YUhs3cSG@lucifer>
 <CAG48ez1sLtSKVQLHbLO5usBgMgjyOGhbX29pKEfku4Ht05HffA@mail.gmail.com>
 <agH1ZSdX_7QF8P_I@lucifer>
 <CAG48ez17evhhcoDKF6AoPqzYZwGuFCkVAsc-0bBzevf0LHYNxA@mail.gmail.com>
 <agH7ONBSX7XLzS6q@lucifer>
 <CAG48ez0y3N9uEOzvr4N85Js4XN1fh4JiUFjW=PQB2UZ_5t1R4A@mail.gmail.com>
 <agICeiIEshWf-1xa@lucifer>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <agICeiIEshWf-1xa@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F46A80002
X-Stat-Signature: 3trbha79cy9ptmxmyifx5sx7a9uejych
X-HE-Tag: 1778570671-243950
X-HE-Meta: U2FsdGVkX1/Tk0lh8gQpQmGgTOjwxk0nRUQ+E/k3jGZ/HJ6GhKnRn0JH87vr+ZH5OX29LLIHklKsM5oh0HWb5LlXGuVx5EtvitPVaD2tX8dhpClqmqhtnPGgaHwqmustdFVi8SbvaCIWB8uCsGFhpwc4ITozrwNnfV1xSzqTFpxa1Y1SB9gAXZsuWQbnfzAq4G6CH/a/3D8dBd2m63JKkZy6uKE0WH8BkIz2GyA6KT/+Ozm4V7XDj+rS5WwW3HbE31SqsImi1fqX/quN/DKfHiTWp9Kg5/3ad8H1vNUM+RpECPYXq+Frjj4lYo/VH1MFRZ2YyY49/68fudxT0EKEtWBqv+U3k8XxYk6k0gWDaXabbdRFQ6IaBy1FLszuzX0mIaMPYDBk51H0LJ36nebkM4LAgxGIuDwZzNldwQA9uqMh3bMS6vu5EbBeQN71d07+36qsMoe4M/w2sCEMinLFFv8B5JEgqLrRk7qHZnqwbOpzEgbn2zROv6WIk42GRmiXexV6dmbf/xyvnggfy8CUJjg0q3i9hlYdXTorrfk/OvnQ76oNfbyyQzrbgUMclnIXBiMwAstRGsITDBs8z7P5DpYYs/knlVVy0/Z0AHGwizVguju+9JxBZ3aeqYbVBbtnTWI8dsXnMHJmb1JhwkuxEBmsplUQktf2UyEnqCc2bK8t+gCGcaTuUngcW97CgAXqDPfE14onncKuFSAHMMRQC+t1D2IZGUfZZaqnvDKmiJ3HAKDGrgZxVa0YAFvQkZGINTDPB94aJlTOZ/4z4pgaDJ5xfE4LIt9y9MS6KY9d16hmwnM5Sl7jAXqKtyAcCxe0Joej3Ae5IO9HF6aQih5d74G0Qy6NI8BjpcUgVpY9Ak5J5ukNWrkJ7OWDGCTS6oXBCt9G7cPSQB2blD4JoiO44n2dA7cWMecBzTbAoxxeHfhm0oFflk0fZoB3AfaRRtVeS6eUenzy23rJU+dy1/3
 fOgpl2A4
 DPbpVMuKpd4tYe2IhL8mHOf3YIvpp3Uj2+qN4eP6OqcZ6Rgc3VJg/M9393WR8sdyopGxFRBcxlZ8s8PRq+lYcxtd3o2krjeDAxZVFqlUjMsfa4D9k8xXLcPRvL45YaHz3nJcuxjKyntvDlvXrnSlmWsWoaNE0MvsztotKp1pRh/fsP2y4UZbG+CN4dLOAKeUEwdJcUdWwtrLEeTScrmXTZ9LeVz16ljHHAm7qa89Sp4ygiRrWmzr562pUlS5TkBLUDDDXkf9MTKquQ69MEnE6DJ2bOv/FUtBhCK5oLYzpYTUj5FSCp4s2FK3vXu3wFIQfmVYSwCVLrCVLBsClTy0IIlWLSdpnJhJ/WZ+S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/2026 12:30 AM, Lorenzo Stoakes wrote:
> Yeah let's go with that then I think :)


Thanks Lorenzo and Jann.

I agree that the patch as posted goes in the wrong direction by treating
source gaps as ranges that should be propagated to the destination.  Please
drop this patch.

If disallowing source gaps in this multi-VMA move path still sounds right,
I can look into a v2/new patch that rejects sparse source ranges up front
instead.

Thanks,
fujunjie


