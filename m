Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9A8C56207
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 15:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52C46B007B; Thu,  6 Aug 2026 11:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A032A6B0088; Thu,  6 Aug 2026 11:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4D16B008A; Thu,  6 Aug 2026 11:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF4B6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:13:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FA191A07F7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:13:51 +0000 (UTC)
X-FDA: 85071189462.01.12A47CA
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7E857140002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:13:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=DPFGxbZk;
	spf=pass (imf09.hostedemail.com: domain of jackzxcui1989@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786029229;
	b=Ib+QP6qZ4RBGKZ4RiRiVPDkGs4hk5mcPNtKBW2c4KQCHtM8YxJM+8mH3LiCa40hZYLTv5l
	0PDY+xVNYHViMUeqdl/18G/agAGcJa+sgznonLM06iHDfrMoGmH+3q2FOC/6BzaMSjE+x+
	hUqeH9HoV/p4iPEyuNY1DGtA5rcGdhQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=DPFGxbZk;
	spf=pass (imf09.hostedemail.com: domain of jackzxcui1989@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786029229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwi9iYgVIz2PjYVlalCQyEOyqE7a1Bmy1TlzV0GkyVE=;
	b=zQoZ807peeLgr+Rt33qjCPSsLKGuJH0eHfNJm/Q99prPKikhxKjVnVeQubZ08R3ktsdQN6
	aMeGj+tQf4g6L67cnEfUF2oFau43v8WkjGt/B87pYG3FExsqZqXVNiN7uQDFELhsMltn7I
	EPHY4PZzAW3KxoictyHs9nLmWv4OwpA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=dw
	i9iYgVIz2PjYVlalCQyEOyqE7a1Bmy1TlzV0GkyVE=; b=DPFGxbZkl3Pr+zJTS0
	tqDPVIL4GvDE9/8si5GMcnmTSMHUW+8O1T0e0xRgkOX516yvKZxOYqvbOk+oMLq8
	hbv5PjfZa+xvjicZ3zyZJnDv0pD3j05TgInzzmtpC5SF+YACo9XahdUGDgMHUPS9
	eI8Djsk6XbbO2XrEgkuSxOD3I=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCXn69gpHRqAwzILg--.36236S2;
	Thu, 06 Aug 2026 23:12:34 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	alex.aring@gmail.com,
	allen.lkml@gmail.com,
	arnd@arndb.de,
	brauner@kernel.org,
	chuck.lever@oracle.com,
	corbet@lwn.net,
	ebiederm@xmission.com,
	j.granados@samsung.com,
	jack@suse.cz,
	jackzxcui1989@163.com,
	jlayton@kernel.org,
	juri.lelli@redhat.com,
	keescook@chromium.org,
	kuba@kernel.org,
	liam@infradead.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mcgrof@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	mjguzik@gmail.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rppt@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@kernel.org,
	vincent.guittot@linaro.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v6] coredump: Add bit 9 of coredump_filter for pre-exit files before dumping
Date: Thu,  6 Aug 2026 23:12:32 +0800
Message-Id: <20260806151232.1263773-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <8c763f1b-85ad-44b9-b36c-becd7598fe77@kernel.org>
References: <8c763f1b-85ad-44b9-b36c-becd7598fe77@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgCXn69gpHRqAwzILg--.36236S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrGr4UZFykKw4DXryDur45KFg_yoWxXwcE9r
	Z7AFn5XFZ2yFW8CF4xtFs5WwnIvFsakr1kZr1fZayqyw17JFZ7AFyDJry0yrWUJrWI9r4r
	CFs8XrsIyFnIyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUj3l13UUUUU==
X-Originating-IP: [124.77.128.89]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbC5wL4A2p0pGKOXQAA3V
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E857140002
X-Stat-Signature: kgc6a35is7adn131okma8195sreiz8et
X-Rspam-User: 
X-HE-Tag: 1786029228-700161
X-HE-Meta: U2FsdGVkX18+G+NPqVJV1hqRswYnyjwEZtljRlQ6Dz7Gfj9IcqidWnzGo0AIKJTENxH7/2eT7vW+jAEva5ijWvKEMuRuaEaheFVUtt1WL/NBxVcBncCGDny8ICwBjd8M2/hidN4yB1bbhaYLuHJSgvbos+/j6EgGnYIQw0hv4+G8hYL6hKDOzEs/vr5YfeOTcUbY2qrXfuogtpSl/b2AwJkGputKO78N/SFLyRmKFclQfwkX2n81Gd6R1WWol31oVfliUjdpjipGOt2tr6mdoANdADNSmEfWP19E+Gf+rBXMOy1QQrgOuIi+0N4VSihd6yWP5ER6C4Nh/qC6e1K2VagoMgOEL99msC7UrEuQ6j0D0Xj8eraa1i+wSdc9+uqBnxeJzPcx7vn3m1KnilcKskMq8F+n/NgJFqAWJ13r23UjButRgxWMym5x0W9h1/MW2W6ovuqvU1YtYSWYWhxMtzMii4mW8nz1FbEEH5gORU/jt2YDqGRebCVMQdRE6b1RviIDNR0MA6yzIge8PuQaSBRi62aQlCkYvkml7TJyLza1VI9g4NFZZ2h8oxY3yKthbFFiYZ6HqacQLAqJwZAaI5TY0dFL1lN2yK8Z/T8ceUP0/GPb/elDI76vWsU5Aet2fiE5kNJy3/3YDb4fsHQ8U8NmjonOqnnmlKg+oetB2h612Patwpx8lXOXWc+ZycWFKpNvx2EVdWDWN/aLGtc1XKq6MSvsToiK0RdyFXfSPsun8Npu1Qf+cr8gi+FxcSDOTUSYwhB0CvrrHFj9csOnRMHHGzqF1k2a168XRhsQMQfne1BSLphEZmB//GL+bgb6bt/ZQYy4708QLMpoG7rjCNpho7OwNhiB+5XSiy1af5d6Fs1zA0dT8AO65B15vHG11fKEnbk7DmBoLZJKwonbkms+YqaTtzsyPlM7jKNzdT2IAn7Y5tyvpuTnpd8db67XVDqFDgF+WQ7ewgdjAKa
 oL3RVcWD
 IxG0WMFR1gxBuZnGhl1MQjxGEaVQhPqDtxIJJkZZ62ChhnZi0wVDRQx0hsnxmbjHN9uGhQAGFs0DJ6xbU2WgdKtol+cIjCVpsy6BFCZ4sGtJCKbL0T2tvXUQ2+2wD7Rp35xnVtp0020SZz2FQjHQkrGmvQDEk9fTMGVsK3/+UWserVCnh+Py6owmkZWOJR9gDGjtZMdTylCYrh2bLnThizdTvy2CSVA0vm7qKl1S6dAUK1C0pxw9G8/8YqubzLAQ3TCKOpvgzuuJSa5Rj/HycgnS8W/Rn/ojfmLKsmCDiaZTOHNCtHtB2Y4E2AE/8yKV34+zBU9wumXCSPCJv0J3uHAIo3hwQ0Tjn+s+UkoIRI8sn52TwADQoGL2Icanuh0+7niAwldOhoHPiDob4kqR9YkVxlEezB40KtQWgUh0kSTLB4mV8hrojtdyHanJQipIp/wmeMFUryn/hk1iOubANtevqudnd54TLKfQKXkIWjcR6dTCcL3fgrLP83K9hjDWkZIGg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 6 Aug 2026 16:01:55 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > index db6167bef..d590a1dda 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -1939,6 +1939,7 @@ The following 9 memory types are supported:
> >    - (bit 6) hugetlb shared memory
> >    - (bit 7) DAX private memory
> >    - (bit 8) DAX shared memory
> > +  - (bit 9) fd list
> 
> "The following 9 memory types are supported: ... fd list"
> 
> What?

Thank you. It is a silly mistake. I'll fix it.

Thanks
Xin Zhao


