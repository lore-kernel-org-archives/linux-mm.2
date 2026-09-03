Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B18BC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3432D6B0088; Thu,  3 Sep 2026 10:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5226B008A; Thu,  3 Sep 2026 10:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E49F6B0095; Thu,  3 Sep 2026 10:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1B926B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:25:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C0C0404E2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:25:58 +0000 (UTC)
X-FDA: 85172675196.24.9EE462F
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf02.hostedemail.com (Postfix) with ESMTP id 49C7F80005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:25:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ICtgOfXe;
	spf=pass (imf02.hostedemail.com: domain of "prvs=6995cc46d=itazur@amazon.co.uk" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=6995cc46d=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788445556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6eMMxN4253jmYyW8/yZiXUi1dvjY1m86L11q+LiDRRo=;
	b=SlhMLZavGgq+pugkjpwKCEPz7SBUKuC3sxVqSFPB5NpXKSOdeNLJpxslvdwWwY8t+lBpR+
	pJmEtZjNw3zDGAluZ/WKDCY3g9RrzbUXNVEaqNUElb7+tN1VwiaawdrG8ikBbsy731NAsG
	0jRH44xvi4JCoURphSjlcnZmkg2qJTw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788445556;
	b=ea/1VqmBAijlUx5w3GU/KwuLWCjfOaLDN3kFzrxVF+tYmpGsAdZ/qB2QA7ScmrlMQHSujC
	xY2qyPiR/NiGb+68yMYl0WRHoyYyB/i/9oawm96SQaCpn7bjSWBhMOKbv+Y7cUKwxxmeWr
	7fIOEHaYeam/IwhsduCmBUNnfbJu224=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ICtgOfXe;
	spf=pass (imf02.hostedemail.com: domain of "prvs=6995cc46d=itazur@amazon.co.uk" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=6995cc46d=itazur@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788445556; x=1819981556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6eMMxN4253jmYyW8/yZiXUi1dvjY1m86L11q+LiDRRo=;
  b=ICtgOfXezHIJ7LFeudNMny2V5s21R0MlX17BjoupyjOz0Akf13LQw/Cn
   mxAOmmo7js1B8IDCJ9ttvPQ/poXkNKPKQcKW7an3SMUERoVyS1OErB4Jd
   AaHuFwXOCAjpLXTHpi1jNh9amHc5qEOTtqmxOjv3gRZUqfRd7fFvPl+XQ
   hjU/dMhAs3d3w260bfwfRX0uvtjWEaIgiIWjKMwgp6s75CIAH7WMzgtoK
   1UdkYerQDJqK2H47TNszdtYefDBNQgMk4gZCKv6V/gFoZQK9nD3uDNO2m
   EvLXbcQf6SPtdx3VGiDJNZwrn3awXLhBAfZ3uSQdCyZNQEqpoxNRxVNos
   w==;
X-CSE-ConnectionGUID: 4VTVDDtfTNOIGEJOl9hYlQ==
X-CSE-MsgGUID: QucrdA79S6KqegrJUpnJ2A==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27759244"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 14:25:50 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:12884]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.134:2525] with esmtp (Farcaster)
 id 7b7cb4ee-0ded-43ad-a581-5ab47fc893db; Thu, 3 Sep 2026 14:25:50 +0000 (UTC)
X-Farcaster-Flow-ID: 7b7cb4ee-0ded-43ad-a581-5ab47fc893db
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 3 Sep 2026 14:25:49 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.82.11) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 3 Sep 2026 14:25:44 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: Yosry Ahmed <yosry@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Brendan Jackman
	<brendan.jackman@linux.dev>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu
	<weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
	<ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, Sumit Garg
	<sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>,
	<rientjes@google.com>, Roy Patrick <patrick.roy@linux.dev>, Andy Lutomirski
	<luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, Thomas Gleixner
	<tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, Reiji Watanabe
	<reijiw@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, "Ackerley
 Tng" <ackerleytng@google.com>, Takahiro Itazuri <zulinx86@gmail.com>,
	<cc-open-source@amazon.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
Date: Thu, 3 Sep 2026 15:25:30 +0100
Message-ID: <20260903142529.19709-2-itazur@amazon.com>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <CAO9r8zMxdg2BTFguwcRQn8n-2CPaEJJfg+T8dWcgO2eV4uNaHQ@mail.gmail.com>
References: <CAO9r8zMxdg2BTFguwcRQn8n-2CPaEJJfg+T8dWcgO2eV4uNaHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.106.82.11]
X-ClientProxiedBy: EX19D032UWA004.ant.amazon.com (10.13.139.56) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 49C7F80005
X-Stat-Signature: 4mfixmer5rcn5ip78mwaoypro38k8dse
X-HE-Tag: 1788445556-881094
X-HE-Meta: U2FsdGVkX1/h5uRmmIljkLGx2AuYIffARyP5JmDs/1d2RsmPMfsWTRDmUhRkNdsTCzl1skIynsQRHqfgcll/P2jpbWD5ocuAuu144tvgCuTVSx68QwPiLu7tFKsv4Pv928fD9wzmobQKf1LFT2Mv3n/AgG7H/KuLb+d7HohyQ/wjm6D3iQ+eN0IzyJiLaa9oPJq5czA3rn07zFKr3mcfnqARy/ysi18fZoFtv3/r+0d0/K43P6U3r1W/3uFMsEQ6qlxq+Sv3Ry7+np2efOf7RsYPEmKXq/UHmdabJpJSymW5rdg6xmC/Dzs2DxphwN/7Og5nnzTQ5CuHqb+RGvBReo6nv6f22GsR/r7zxZze58SuZ1MG9pufs/bbpNQAJxCw6iMwpp02bPkJCgurZugiveps5FHDD2VFsxUeQ7YEY6IB76i4nVTbBtsEywTH2/R2hzHDtumzAWeIKDnPsBK5J5bXtXM3XR779AmUHNF8yAB7zmiQMt+dRzIi3Lol4AUws2lJQ3A+XIPQHOXKpzzZVcmP9NQAOQUEVxHcC3eq1UI0FPK/qnrzXrPoYxbbFde6rTLHL+vk4ZTMYUaXlF8B1gNwVRygZ1vWi8b+TJZY6VoB0JbfEDbrMiQYyIf3PPtHCwqWCJjRKiWvvz95HH48HjKdWl+rolpCAeZRq7ctyxmbKn9PzSMJFgPrpt0z5SIaUc6nn/LOIfHN0hThnwT0ab/fyqsJ5rhg2LC+FfXFyglPFKT+y7+MaRPz81W8IZ/rPcqDvJuPEWxcVLXZOFGfw9oD8XqLeXR2DSvjZEBMDgwyoaFVqSi7DLuA04uylMO5jkop4wx8mLUuJ3bgQoSuniLAKgP5Sm2I0Jrkh1mh1r6mSP7CsN3TF3IVbkUcdalYoIIc1i0MFA0mqPqyWqotimdWShOktv8RVAkMj5dXEPL05mc6Gc+pS1yhTkyA8CHnoFZXPjnm5/j1W8BO43U
 SIY+BDoH
 T4BSuDA+ZIuecTGJklfEj+WyJQ2k0iiCI4SOiSkcjrFNmMzIQrZcyW0t8j1gcZfPz6VFnEGC6wk18eDYGOUtC3O1fVjht4eb0lFJ6ig3fQ1vS8meHX19TozzBAoKNi36nsGBeRpbjFdiu7Ho1Wkj6EAwXi/4d8OqNAhlISc58Vf36VezSgpFRwwsdvXZltszvmWWX//iTg76Xm5dM9/GtyOu1fY+BUiuguRQHaoGwBVnRI38QHFo9C9ruSssI2W3G1Dv5hVbsgnGSA2jWGfTU9VrrAs+RyA860mIUdghnE0oTKl2mIZYMjinljy4bTYxcfdQheAwGJVSD5bm4G5gWa5lZ6nbnzW2zC8feUeKuqXSqVa2bv2DSim68loF4iOQqbhutJeDGtqwNDw4TRuTiVd4SJiRppx4U7WAgJKvsepzKKn3zT+bvLQkat63dBbgAOK7NXYRJDxWYFzWixKaVo2uhB1cvaE+fLi4MUkohylCCsLW0w/KGNlNmSpZAw/nSTkmCYe1G7az4K3OGxtGB5S5ZEHxwqrC2TxFFhVQOrMa+7qmmx9aou7jcojA2dalQl7gzhgNTsZKEOXEJZVWtHQ4T8uztwUwjGEctl4j8woLTyEhUNlgWDgDj6hZYAyffwhT1ZhUdOP+jH2AQOIcpkmxfzVGTAe6MH1ooLU9NQXeG+ISRE7OrPvVFuox+DDJa7+zJEACbV7mYxuwWIS6i49fiL1y7NjjKhrG8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 3 Sep 2026 07:06:02 -0700, Yosry Ahmed <yosry@kernel.org> wrote:
> I am currently working on a new version of the ALLOC_UNMAPPED series,
> I am hoping to send something out soon.

Thanks for letting me know!

> Perhaps wait until I send the new version, then we can discuss if we
> want to split it based on how the feedback looks like. Does this work
> for you?

Yes, that works for me. Thank you for moving this forward!

