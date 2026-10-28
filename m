Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C499606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ApHKPPw1
Received: by kanga.kvack.org (Postfix)
	id 718F16B05B4; Wed, 28 Oct 2026 09:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F00F6B05B7; Wed, 28 Oct 2026 09:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62CF46B05B8; Wed, 28 Oct 2026 09:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 490906B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:48:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF8E3140C83
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:48:00 +0000 (UTC)
X-FDA: 85372163520.06.9E1BFE8
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	by imf17.hostedemail.com (Postfix) with ESMTP id BD9B740002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:47:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ApHKPPw1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793195279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idoYOC3z+fcHVodb6uVVCkkEj9ml2yjsfszDNHVYELw=;
	b=VvW5BBkoDBxCs8kzdYeiCb8ycXdmVIP558HmxXhgodQIUC8liFNKk22Y6IYIROTHeGGQ6T
	/yvVsaGj1WSawUTbeXffvJGf7HyAfnAmFbvK9AwKqY9L3+BNGbvdwLiyK/DO5Rm6QltHmX
	bBcFUxwb8Xpq952dZBTdhVbMGkp6cVk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ApHKPPw1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793195279;
	b=L7hwIHusCBtpX1z4/72i75lBjVcA44bPdfvaYNGbH3Jy1LzULvKG4pnie2QujZNKxFAlQY
	C0Y/kHqyZm7y0Ah6OYVkCKwSotL0nmv6B9qAqneyr1n0FRjTlU3oKs3hiieJDChYHxQrKb
	4cqUz251QPQNbBpsgMnZTrEU4oqeAY4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=idoYOC3z+fcHVodb6uVVCkkEj9ml2yjsfszDNHVYELw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793195277; v=1; x=1793800077;
 b=ApHKPPw1H1Xc1WQqFBILX6ARyMr3+ZSovKwWSKxV9S4CAR559P0xbjqaljbiacDk0PsadFVu
 /duWA3QB5jSf/tAGDUbwE+mpbt+R74UVGU8eVLzSu49UyKzGFASuU78xjnr7NUhTslEOd0o3geW
 PVwWhr426TgexAD3F9Dx3bZI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 29e8c50da497430a;
	Wed, 28 Oct 2026 13:47:57 +0000
X-Mizu-Trace-ID: 29e8c50da497430a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/3] mm/hugetlb_cma: fix incorrect hugetlb_cma_size
 assignment on malformed input
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028113319.38544-2-kaitao.cheng@linux.dev>
Date: Wed, 28 Oct 2026 21:47:32 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Frank van der Linden <fvdl@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Chris Down <chris@chrisdown.name>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B3545C17-96BB-4A17-937F-3C91F8A0A1CF@linux.dev>
References: <20261028113319.38544-1-kaitao.cheng@linux.dev>
 <20261028113319.38544-2-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: BD9B740002
X-Stat-Signature: 7jc7psqqepf88e3qge3x9bscion3h37s
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793195278-422346
X-HE-Meta: U2FsdGVkX1+XC50X7SmWVU7KY4zbPWFtjPDrXBP6SJUQsz7e2SUATBdTSLzAtJ3yThoOyMN47pTUM6tcLgxaBds1AFSu6Vnq5/WU6ywp0vIxkwoWaE2+Id8AZrHnBxMga5VuLWGwNWqgrmnarvPlZoBMGkKOhF793H+aEc0xIa3xzHmw3z9EHBETt90QscS6U93bzhPDwC870gp1JP1pxTEIBZ0XXZOQKw05eNZ0vAD6DxUKInon9Sw9ar5Sd27Aoo/cTQrrgafKaxnO6IcqNw389Yud9CHEKi11scYihOXVBVnL8uzyIvmgz3/fQm4Q5TSalZjJD3U13wv0jWzhAK3xzeX8w/7qcbyYSrntEupIfps1gmvwu0sAS6Zu+bo2MTdLOJMbK9o/eSaNIBGm39ldsfPFfZqkvPC4jmIgGjN6AA7z2kxSKcYfpGOBnDdadno5HJggtG0p3gb+0qp4Lk//cZdVO8DEpjw0S5GWrdiEAijfPJJNgJWZ2ZywHfc9bJuYsYIArzLt4CYmX2sMs5YTL4Ia4pjfd/TcX3+/9enjnh/hKU3G9bbQOhAg1dbuO9wZEaTrEW9KlSWYcK5/9BJVRf/ywT0cz8dyiL4BiwsDVwUXoSyt0MLyXJ2K3rJMJmYe21pzLH5WEEBTQTJqND9TQsRZFm7VElTkLw4oPnT8mXpkRp8+lPTbyWoWVx/a8EwNDXP5dKov22VI6dUHJgNlfnKAHnlDqdNtg32698VkGYWu54rSf7Dth3fZ3H2VXClp6zIsx8PNwQMmhDyQUdVDi5JMIF9lHV3433Mn14q+yqqHpR/Q5VecraBnv2fMXaBfra/Sf2hjJHQtkjCyQAdl48nqZeraY8aruqTOjo9WlrjGh6AWh/GAT2je06XzdA35daIiSS0k+iSrxWZnwXFjbSLz95mpXqgwmNkP11xHB+a6bZH5J6axCh42cdavmgQe7hc9gKiXGcX40iJ
 gOlVX/BE
 Wp22ILXtEiHrQwTQh+pilX78k6IxGhZ8/WCraelNFLtSGQMr4fu3TXeH96Av+SMb9+23IcarU3HvkXt5OGGqWVS4PxKdSMViqXp2AwS6CA1WpH16+1xcpzVJORnY+HjT4ryKdut2LsT8syQUBrXC+kj2jJZTCRRfJoYwNMyK8xqup5z9Ec3/GEuzKjCaaaFjz34lCC+/Xem1r6lcPYLdXwBG6qU1of2wVV10l1zo5CB3fYyhbZSnDv6VxeenFw5jgL/keXYB/IgrDAUMA3HwAA7HU3MuwIzhVMLajh0P/tnz0n5QfCSORPF4Me+BqBtrXmbuAa47VsG/1F+NUr1KAkmp0XPkhiWki2HT322qdkpb4wXzkKWUlVI5JZ7iEpGzp/v3g/2+aKRX0loxxz3e7Lx3dnrIwwdgpMoXVtbAXf4p+5sbO/Nxk+Jrh7aWMLnA6IiLh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 28, 2026, at 19:33, Kaitao Cheng <kaitao.cheng@linux.dev> =
wrote:
>=20
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>=20
> When hugetlb_cma contains a global size after node-specific entries,
> cmdline_parse_hugetlb_cma() enters the global branch and reparses the
> original parameter string. For hugetlb_cma=3D1:2G,4G, this interprets =
the
> initial node ID as a one-byte global size and clears the 2 GiB =
reservation
> recorded for node 1.
>=20
> Global and node-specific formats cannot be mixed. Return -EINVAL when =
a
> global entry follows a node-specific entry, before updating any =
settings.
> This preserves the valid prefix, so the example retains node 1's 2 GiB
> reservation and reports the malformed option.
>=20
> Fixes: 38e719ab2673 ("hugetlb: support node specified when using cma =
for gigantic hugepages")
> Closes: =
https://sashiko.dev/#/bug/linux-10f40d3e-3feb-4622-9da8-1fedecb2d0e2
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>


Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks


