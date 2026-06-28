Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3509C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 16:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF3D6B0092; Sun, 28 Jun 2026 12:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F276B0093; Sun, 28 Jun 2026 12:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD176B0095; Sun, 28 Jun 2026 12:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9A36B0092
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:10:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E2441C66D8
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:10:41 +0000 (UTC)
X-FDA: 84929809482.04.07F09C9
Received: from outbound.st.icloud.com (p-east2-cluster1-host2-snip4-10.eps.apple.com [57.103.76.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 30E58180009
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:10:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Uv1cAx4I;
	spf=pass (imf24.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.76.43 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782663039;
	b=Jpuv+rNyg2qi0ay9QYkZVvVg6J378EZMORLgegBYmB/LBNHHjhEoCGwMlXdIzeUIuCVPjC
	Z/E41b88q1BK8vfTv5yhFtM4mX3LsrpdBvM9UWfu7D4SMztOtxry93163uOVCfU/slRjJz
	3Fo7gxZFH8ps13d38gzSGY7sn582Y1g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782663039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ew3lUvxDAU0i04pP9OMra7iRyqb9tX2u5eM5WOx02Pg=;
	b=XI5FSUh+m2wzpJUxEmnTivFJ7SGXxXHs0+kcsevgOG3g786xbjhKD2wI6A3ZqfH3khU3lF
	eevZwGQCdUZBtCtF7RutoYwN2kmMOZfGrRlSMvAEKp/c/B8zzsOBeM5ab/KUQyVqW+MlvD
	IVSD2WR2ijTUoRHKna0uykjoJZrwll4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Uv1cAx4I;
	spf=pass (imf24.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.76.43 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-11 (Postfix) with ESMTPS id 47C761800C36;
	Sun, 28 Jun 2026 16:10:32 +0000 (UTC)
X-ICL-RepId: 019f0eff-313b-772f-b613-896e1996b055
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhKB0MGWQReCEsLQwZcBlBcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAVaEhhcFFxQWB5GElYNXQkZGEZeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKVwVBWkkCWgZcH0ULHQtAA18FRRRABF4GRgUUXEEEDAJZBhYMTHMEVAddBV1WUAJaVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1782663038; x=1785255038; bh=Ew3lUvxDAU0i04pP9OMra7iRyqb9tX2u5eM5WOx02Pg=; h=Message-ID:Date:MIME-Version:To:Subject:From:Content-Type:x-icloud-hme; b=Uv1cAx4IHp+LngLoi2HkVwbRyqpi4cRLcjxl3m7MPerh40AGVv89OywMTPlB6U5qGvn+4ZqT9e7x7YFISEdyyv4nSetKNU5S6VDPX6mcpfUgAEk5XCy3IORcbdhIo+2tLS2RcqXpxnCF0NwFw5OrmeWVYLRs1UrYGhlUkbylZJ79tMDmnL5QeY5d3jGsiH6zqB62ZzEACQ3GZnWlf3yAxOZajIsdyimAZvfk4WEksNbn7UiGTpxug/otf6jbuqGgJJ6EUagLFpne+WTJVvw7KbTtMMix8cGcEGqLtTYN7s3gFk0j5xft+aQviakIGKEDrI7jdu08u/ZdHO/TqJ/zLA==
Received: from [192.168.255.10] (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-11 (Postfix) with ESMTPSA id 60C781800123;
	Sun, 28 Jun 2026 16:10:26 +0000 (UTC)
Message-ID: <71c11717-52e8-4475-8731-7de97a524f54@icloud.com>
Date: Mon, 29 Jun 2026 00:10:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: david@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org,
 bruzzhang@tencent.com, hannes@cmpxchg.org, kasong@tencent.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 vbabka@kernel.org, weixugc@google.com, yuanchu@google.com,
 zippermonkey@icloud.com
References: <5c665b98-088a-401f-aab8-7c9c4d4f484d@kernel.org>
Subject: Re: [PATCH v4 3/5] mm/vmscan: extract pageout_one() from
 shrink_folio_list()
From: Zhang Peng <zippermonkey@icloud.com>
In-Reply-To: <5c665b98-088a-401f-aab8-7c9c4d4f484d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: DZzefIPOFiNZyZyNcxQB3XGMydJ2m4dG
X-Proofpoint-ORIG-GUID: DZzefIPOFiNZyZyNcxQB3XGMydJ2m4dG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI4MDE0NCBTYWx0ZWRfX75ShFZc+UaDw
 ktX248gnG+szdXwsCN8a5uA37eBqtz3enQJUFin3DtO/KXR8BcDO3RJ83LVV2BKyciNd8z1xfLk
 Dxy33qTPeQ+jPsEbhCqJPQrGkuROIPr4ZrjvdJ/PGpj8DwgFa6HgakYk0G38gQ7sOJVnJXe7YNr
 QgXQC4wfZNCFXywR1/M2GHBRf6ZzoZqV5Es27Q0iRkItuX6uRS87zYnMkOnxwA2IOnQ1diEWpKP
 o74jSMIi7meR3f73Xi6X1nIKgH0+AhTb2+hcE+Fl27bCNnFtCPczEaZOGF9PhD1PxzgjhA02jCW
 /FsGnkZchAEo5QdhldN
X-Stat-Signature: iraksxisxeyowehgngrazbzmznh5u9qu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 30E58180009
X-HE-Tag: 1782663039-758203
X-HE-Meta: U2FsdGVkX1/OvtxUK/b03rem6h1JxJlNhaYvcO4sqv7+0RBSseDQ5apfaJcwq/hP39AuQ44klH02yJ5b+FwRjoN/TXW9ZE3bY5uJRuzTH9d7CK+g4KNl61IMkImgqpBh8Y2ouMF5fBIcwZCckqI6fKXzY5YHjvf0dcZgYtTyf84P9oq4nb1st/YR1qB1up86nSsTJ/AOCSY15qDSyg6eUmJvZnRLx8xdhsy9vhpuy4tuMXJWsl8R6j13Wa3zXd3D6iFiHGhwvpr44osqiB/97c2PdZTJHAaoEtFIbYFkG301etPlV/840mJLaUDrB2cYgmq6t0b6gFz1rNQd2f/5jt6dodisd9qOmhMQJdqRKHF5pFkOJMU6wK8btwsL7pZC3AH+p341Ne7kF1Hi++TJF2VBWjdSLF9IPgeCR2I5oCTvYwAgy/K+Arv6i3BhCDwJgr+aF2azeZ/Uy+j9LpM714uT+yd8bOKvA6UC0/uamBB4Hylo5CaTDGdhfbX8hYPMu1Nmb0oB6ldCjII29hV+6K9s2XkPcl1eBWUJON2oXU/hFctcia2pypDqn/uHiAmGfd9UK23WE0R9S6/pwkmPKsn3VIZDW4BrXWuJivd20S1TQx2DBF06SAWkmxR16VltzDFsibybWTa3oP5jerF/exNlaa1TfyX75EXlQHw5xOyxhpmi57PBZhrDMShcz4igTWxON1u8ZnH8SEtW3eKT1kCZUHtB7tNX7DUm6dCrzWdRkfalCmHCgZjGrkgQ7KnY06RgA+AqxfIChRY5OGALqSuB6xFd63Ql9RdwsIrthVTflIfKeuYS6spG2BJE45jfNL6/8GUD14RzhrQ7hmr+nsdE862KtrT/U+HyZesaB5A8txeTG+iu5JsvqBjS4EbgqxYOO2XGsrtmD1Cpke4QM4lPL574b4XV4dFgz+QZ58Sy4QRtX212EY03+XbzJTGnpM97vYW1aKg41ctpY1q
 gFgk3lao
 jE4vb1PoOCCkrpq+ctDBa7wvZediHUS2cn9yPgFjulDd/HZyNeTLtplCwowXdLKZ7NJntNEAcai53cTqSdvFiF/Bms/k+1r6in17O6iafj0scksetL4OZgLa3AEFM+NF0PXBnymH/JkAXi8ZdnciC6Yj6dL9iUheUOG7diCkpJtPJr1TYgXOzaBFR+hK5kp1JqkZJtHdZF3vH/AioyW/70dpUl50tDbc5mfUdW92XaPHy4T8S24z/ClyArQrPOl1GoTCljrePWVouDiFWI8q2wVaiMOPMsdQKPA1wDJxnC5rP4awJPa86121eTRy0O8Cu4uuZg95THE3d70MfqPFQvPlfgpgmypYPo6lJXulI5RJWXKpSvn51YJWfV6yi70TERAwQz6YBo1YlxFxkUXLY+UAUb5LGshgd70u5UhTIfi3OrNSxJRhntZgH4zxnf3pWH9KLdorOPKriChcNza5BDWPA8JsvjKp1jqhNIFALqhgdSBNaMPaluGx00Dqo+1bVgZ4F08KMOiuaV7pouAfBA115LFVph3iLQCN+gVfs+/eYf0D0/C3dQqMiqGJk5hAEW4ZVRivr8LNoouc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 02:19:38PM +0200, David Hildenbrand wrote:
 > Two tabs please.
 > Same comment regarding returning a bool.
 > Can both be const I assume.

On Wed, Jun 17, 2026 at 02:25:07PM +0200, David Hildenbrand wrote:
 > Thinking again, should we call this "folio_try_pageout" or something
 > like that (and keep the bool)?

Renamed to folio_try_pageout() — consistent with the other helpers.
Fixed alignment, added const to nr_pages and mapping, reflowed the
comments to use the wider columns.


