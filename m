Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31DA3606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 07:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=BPuUzS4G
Received: by kanga.kvack.org (Postfix)
	id CC3646B05B2; Fri, 27 Nov 2026 02:39:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74076B05B3; Fri, 27 Nov 2026 02:39:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15B46B05B4; Fri, 27 Nov 2026 02:39:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5516B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:39:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07432160201
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:39:15 +0000 (UTC)
X-FDA: 85480098270.14.F0AB13B
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0369BA000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:39:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=BPuUzS4G;
	spf=pass (imf25.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795765153;
	b=IHnEFVn2nOUVDLofhfoZxEYZyCKHBCcLQ9f+icK/ImywKSb5ESrNmIOcRYFzB5QVjPbOvj
	lEIvxK5pMCCJIozMV52E8twOs+kt2g4D0Zj8ksXv5iB4WxZVOJAnNYslbRlXxQP9G7hBto
	uL1ow9BaIG4+0mURJ2OQu94MOxgwNAg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795765153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=elRobw03dcntZqHObYzX3/o3w3bPFPTdi+etMxyE3js=;
	b=UHy5rRs64jquvC11THe4jYUjZ0onRh2XTOTPoZmbg3akOvu2tQjqhf0mFoXZMdR+bvkike
	l1iZMyoZb7LdS323Emh4ME2k9M2kDr0LYcWo41MXvyNIGJloVzRXdzLzJG450VyS1hRvir
	uVUAazNr93EMVXZ3Udw3VK5Ry6NXhT0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=BPuUzS4G;
	spf=pass (imf25.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=elRobw03dcntZqHObYzX3/o3w3bPFPTdi+etMxyE3js=; t=1795765152; x=1796629152; 
	b=BPuUzS4G+I1QYFTxnCj6pZZ5o77E5CL4vvTmVNG/KsjvXuiVWLoau87sNn0LTAQLoxSRiQvENCY
	Nda3GYbpkeMyiTJRLIiMZtthQXX7ktlop1PXLzhfaQlSMfyqdovfm4aoPN8y0Pwa0e5iSCO77cQ2p
	s5F12KLVuaSvNgT7vJI/RNQwtV1HOBkMZt0XCfjJDGoLA8EJbtkLRdBlCQCWMxbzZU+p/U0sY+dxx
	NoPuTyC/Zb+LL8dwDNHvnQ/Nt7hMILqMC9FOpMTn8a8lRjg6ReevEMZE57FCt6YDfP5qEqw/R5fER
	C3rikjFMW5W4o66DWsB34UBRuY6jY12OMRYA==;
Received: from [167.220.238.14] (helo=[127.0.1.1])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1xWqXC-006xzP-2A;
	Fri, 27 Nov 2026 02:38:18 -0500
From: "Srivatsa S. Bhat (Microsoft)" <srivatsa@csail.mit.edu>
Date: Fri, 27 Nov 2026 13:07:40 +0530
Subject: [PATCH] cpu/hotplug: Rename cpuhp_remove_multi_state to be
 symmetric with setup
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-fix-rename_cpuhp_remove_multi_state-v1-1-097db4564cbd@csail.mit.edu>
X-B4-Tracking: v=1; b=H4sIAEMzCWsC/x2NwQrCMBAFf6Xs2YAbikF/RSTE9GkXTBo2aRFK/
 93gcQ4zs1OFCirdhp0Um1RZcgc+DRTnkN8wMnUme7YXZuvMS75GkUOCj2Wdi1ekZYNP66eJry0
 0mKe7TiEyu3EE9VJRdO1/uT+O4wdLJAbudQAAAA==
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 Chanwoo Choi <cw00.choi@samsung.com>, 
 MyungJoo Ham <myungjoo.ham@samsung.com>, 
 Kyungmin Park <kyungmin.park@samsung.com>, Heiko Stuebner <heiko@sntech.de>, 
 Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>, 
 Moritz Fischer <mdf@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Mike Leach <mike.leach@arm.com>, James Clark <james.clark@linaro.org>, 
 Leo Yan <leo.yan@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Sizhe Liu <liusizhe5@huawei.com>, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, 
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, 
 Haren Myneni <haren@linux.ibm.com>, Rick Lindsley <ricklind@linux.ibm.com>, 
 Nick Child <nnac123@linux.ibm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Marcin Wojtas <marcin.s.wojtas@gmail.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Dan Williams <djbw@kernel.org>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Ira Weiny <iweiny@kernel.org>, Shuai Xue <xueshuai@linux.alibaba.com>, 
 Mark Rutland <mark.rutland@arm.com>, Jonathan Cameron <jic23@kernel.org>, 
 Jing Zhang <renyu.zj@linux.alibaba.com>, Frank Li <Frank.li@nxp.com>, 
 Xu Yang <xu.yang_2@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 Fabio Estevam <festevam@gmail.com>, Yushan Wang <wangyushan12@huawei.com>, 
 Jijie Shao <shaojijie@huawei.com>, 
 Gowthami Thiagarajan <gthiagarajan@marvell.com>, 
 Geetha sowjanya <gakula@marvell.com>, Justin Tee <justin.tee@broadcom.com>, 
 Paul Ely <paul.ely@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Daniel Jordan <daniel.m.jordan@oracle.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
 linux-fpga@vger.kernel.org, coresight@lists.linaro.org, 
 iommu@lists.linux.dev, linux-raid@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev, 
 nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
 linux-cxl@vger.kernel.org, imx@lists.linux.dev, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, 
 Prasanna Kumar T S M <ptsm@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>
X-Mailer: b4 0.13.0
X-Rspam-User:
X-Rspamd-Queue-Id: 0369BA000C
X-Stat-Signature: 73jwgjz58zcypc9iskmrqnyraw9qzfwe
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795765152-947092
X-HE-Meta: U2FsdGVkX1+B60H+UxEz/rZQBZLcdjJjmfMTCcaQPJjVRxgSX1IZ6fjdg/30nxM7bYnLHnU0uMOTYhaabU1Ndp5t/KwaATMYPn3q19q7vWdfGXdrLHp/vK7olU8NIPcXieecrp4lfoA1f7MAE1Kfjr8oBksP+E8A8J1zgXGNaUj/BqDdsfR1v01qVAZG28dLtHKUYMPGmJ3au35DQdof0IbpMNDbdUmpB8zFaH+X5uPYKMi/i+9K5s8V72j01pFkFDmrs2hYgiCwxlovB9JaS32xqwuXPQpfzZuX0vt10B2/PDaRalz3+ZzDYTWTI/7gw+YD+nvhiQpkttyfTJUPZv4CUPRdSVimYVXMmDUZhLXzBdTtjagwAKCtZbhMv6Y4lMg49E4X2W8TcEE+YaKdEI3v3PO+8MlPYfj+yMhlnMjHP2PZIvAkW429HmqmvMB+HMLPv+0AFLkmCuLXyk2Z5Ev/zBEDqwmWOCm15JU2A64qR5znrtHH+KtaZsTbjkFAAbxS1vroSUZPonb/GU979eNyg+zXABq+ztAr+44zeafkGAKm8jPC4SVeQXWREjerQhueK/JK3oDnmrEqnouYeKgOtiimdIFAjod1wtFv5hu8ceS9Sjf9l8P79v9T4ETVCdYnv6ZvFs17b8q9D0Xot7y3Cg0wRU6LeZ8mWr2EG6yUvsLvtE/DGUZSpcwiMLWAwwUBhWdGF6ROdoD7wp7inXLR4RtpWNTFDNQJL04oQak2IIeSSh0Ct9xK5TyqkzbbEg66HiwOyfZwQ7FOQq5qAwXr3zURr//f24qd6cWqd4KxgIA5SysE3iS9deYBOXVQ6tzjjId1Zlhw45tw4bsJAAkJzeo43CcQT+Gt54nhvnjtKqwaZ4fvm5a5fDcdtp6FWLT1V+waYSYa5yUEE+70uGXz1jLNqPPvdfekXanAgA5IeJ/9y+KpBA4ZAJ90lqzPdZjjFKNh7FBvCTJtYZB
 8iZvfNGT
 F0Xu8FpmjlGyhPd9AxLG6KIsoXg7Q55z7gPX95+zWVJjoFCQWbRIg61RZmQCdRZ99c/nv26UgSy6LZBEVR6wcFDav1BlZlWX8p3RljUnoh0EU9/AMgSSiutcZHnVo9Xh6BT2kSzaoM6Pn0jIs5Pghd3eG10h0DxWyHPKzgviF3zVp5L7CvgaYnp/dhEA3CgbXpOnNpsnqFkJAQy9uS+BnD83Q5uo6sExyQ6uI/q26S1ZljaLKfrR/M43Osf7AfSxtF2/+42JrBUt0lJypcXPcPXSWg/bx7gFq+Bqxy4sNTEsbA+yt7o0BtpXs7SIr2rm5apTIsbRArr+sUfK8suMGRn6kGq+VlSYonImdYQMtsYi/AExQX0czKxX6ftKG1zbr4XrovQNBiTMab9eMAqWG9c6yD2FmAiC1fERIsb+Z/odors4FTqFSgxdxnXmy6HwFwubZHB33Ia+caNS8FIrkyz8GTjnwUl13VMdu0NtDc6yKuibwgokmtLM4CcX3nvBr4faTDbiI1Wc9hxQ6vOrfsEAsKU0ktpXEQWUTEpQaHjcLuP+eJjR7Piaoct5YK4KaRB68/RmkI5AnYs4X3a9EXJ2aDKdfXvJplu3L8qa6Lj3cvg0Yym2jo4bwcdCet083JQPmhjyeCjXdxQiwgrCU2eeVy8C1U0ReS750OuI0BQ64A6JmCmVyBoYCtqmVFSTs02E+gq24YksOviN/yHNBNH50ZronFf4NJObWlkPBGwJHRex+yDEdM6FGgieSzSZwFLISzRYvM+lG5NTIvWL01VtPjhaNhodmxj1EqfsjePZn7JQ4FTfVmC/L57LS8IAHLhWdReY+cP7ryzhTDjOhYrVwbZ3WjlVkEudB0G8Ib8l7AcSRDhlacd+kY/TO10ye4btVkmcpgIWVVk0jAyE1u9V4KiDlUFCJySxbwUjU2BvbmqKVHt/NJsYS7D9uSDJXj2vK7VSr+R/IDPh2DH24raHhW0/y
 zvR9g3eX
 xJVxgT2nS4zyV5zhp25/QHX8HxQbEMsheInqnUo1o31pLDAJTiGQtWkDkMzaopnhbWfCLGsjMkZ0uzvxMTeNWFC8oXPrD28/R+nYQWBKP8Ii0SmFWt138S1Kekm4n2YlArMUcCH62ujOCIvNlWRehZwKBjGWyId1EXQBlyiOnkeKpMwYY+TZstFTECnh4+YxW6pBW4/esAb7HfWD4C502/hpKcdp2fLRiB79nJdStNbGccWOJvhjvaDxPaJVRwSF4aXfzuVzKsoK5C+DWeaTktBUPIA5oVr5HYmfWkq2QPGr1RIEJarzjdCpF48S6ix6dlzVir9LCoOTP+0+XkuOMRzandGdw5zR4bASLCkzAu0c08UrW7OhmrLsygIC12hjeBO4Mb17NClG7irDpoNc0fW8tA4K+r4Wgo7QNJOMjV0EtgLHc4RyZE+g7N+OnuK132YmnKSZ8GV5jiW+LJz9PFHzITFE9bWRK8uyp7kwz0ZSpLF9GZNdR2seOBshNOIPNbNQOX67KIwQZmjTa9BfemA/FkVOqSBo6by3n6GmIzHGmc4I/+gVMYP7oLhNWTFXA1pwPDYXmVKoHwqNUU2GbRTHkWIv22F36HsOmzU4+osjHSX5jxfLAhv/5xbbjL/DhaPliGB3L1XQ2FO3tfTae+8VWyU0sNVv8DqqXoYxjw/zKnrB1fhwKuvXaohd125xNQLKaLsaRJRYPxS1Pjaa61xJzj0MUkcdTsiUt6m3tuF6U3ajhGR8SnYLHDX3kRZ8qu6EGQ9z07rGjMHIC7sNJy5dBdhsaHrnAOT9raOTG9X8uJh/pBCn6FruCzKtyegtDnChsJev1mQ5YxuUeFpW0GNEr/ulxEJolnUJZqho19O1TZkDqHQH13SV5TYkK0ZSwHWSjYukbvTA6GFYQKp0b26WuNUEI4JcTjXdoBF9pKmeTfstSnNnpZ10BIWevPkr6D/MrNnEq4KarUi11vddyzaKK2WxH
 P8HApfHw
 bJ5EpALPS6Z4ieQXQDcNuHFlMu1IRbvFSPF02YXkxS62cTSjQyURKsqux2evoy8nTFLWbrOchdCmeFARldkhYDXNxFOpuYfBXYVz+StOGW+ta0BV97+QsiFWs4pP9TRREakhOKoj2lrt3bypFsY3j1tu7qJOujyL8qwIEu2hTD0u+kPpRpymjE55AZ0pEOMhEcGxeFsUXn1ed4POoMz9ThywAsgThkmtqfgtq5BabWwF40DvNPaftCuuOWtb9IVuLIp/qD8U3W3T1B+44urobox/lQpVHrVRfzNWhBwOrby49nqj8b/Xp5iscEySzF4KzWGP/qOE3XNu0tMm24zHwb8iJC00catB4pdK7bp6r1uWU48GsO5jEDhnUo0rZ519jyeVj2pY4f8/hhh4eSpxUHmNed5iLikvBwtsmkFOuH2W9RflgXr9Try1R80sfLdua+WNm7rG8/DLtC7YaNx2zATpiR6lTn7PVafgTBt/2i0cG1G5jj+mFF2i9YliE4DyJOuWz8xe9IfjaKqJyduAfMRtGRUt/KYgrlolAb9XOEgegEdn83/bZI0XJrZWJxGaVZTPgHDcV3PVH8BVryQ+DnnIYD6L4MOQELvWfxZoGM/gXXimdd6sL0juqGQXT4LlhdXGLOxlzyZAJmFVXZVwBt/FNAjS69tNUUP/laDHESC6L2hWCRHoz+jbRa5dPYGDSkkY8wdBBQWZF+skC0AJDvKWwv8Hv5gGGUPsvFOaYcqaPe3uj24RJbFdRVc+SpWatJzkKRM2sME1u2muyMiP2wmjIIKtR4Ly84fEeBDsNust6eZK8jAw7iR9dx+o+OeXbsEIS0oJJQSOSXrz70knZ7b0cqeHTlx1Mgsewcqxzpw3C7vW3LnOgDnEe7pjW/+0Oa2dpT2uvOIK+Wg8t3RXuQoG8AvW37jIj+aZrGMzqRf6NkOTVBeWgekxJUQ94pDj4Rv3BYxIVAqOQb3R8hyWuSRvAfRU9
 GOXY6Lko
 RhimB9LQG7OltcZuls2g/SVVTzYrHuk7UdBVdrJKOMOY6UwXFEClGbW1vxGZH5v5iJcEainbCH68NmLP9DmlJCWw0FsPqO8FOoR5e4hOXG4CIDapcN7nVY22Z1IYgGstgQf2u3H8oFFuepqgbtpdP+sX6ibjA9hBB1UePzBxHmadQuxTZ3z/BLaXiqMTBmKidN4FTfnVoYTpAZrXQMbMQxP5tqobwpqiMN/OUagwHzu4hVd7GSZlh1JWqYb1/PWajIZ9MDJB0taKdDcNmol5OwSGsHE14CTKIcRAubKbF1F4kIh+ILSI3klvwH08UtvVGMyZMZNME9aRcePZqfI6Q3boAv+wYSqhx+7ENPul4uXw8Gvdq6gL/vQGWgNChcr+2XBpKmuh4dt3c/uJsUyvi09TpbnlkCBABoJw/YXAquYbLL0nceuACbPe3ag4yJvez4ZxDPInPGmg5b5SY5O/16m86se14BMTn1Mqrqvm+xim71pX+fV5ByKOsMS4yW6aIlWlw5WJLhrqGvr30FyeYTsdADOqfmIg5VokvWzIXt+XysV8K3wcP/qhscCa6OY+6Y5a9GUxeXJnIJPUbQNwS4WzQ4oXEdCU3ovrHZM1w9Bp3loz+Qa37SyV5KX/DTjckfocfIP33ILz9yKzyaM6LdpQ3k0eaDEBivLHUGZCE//vD+TnaBHmlJgKlAbsjeWUvDGlcBkMMJ2UQvmUNHWv+FP/9PlSTdgYHPCaEN+DrbFcAgIMFVANkUYR//dcgZS85vR+UJQG5uYkYKtTGdtfmHG/n6sH8DaZgHxAMdn7ZyNliuL2h+0j3Gdaykc4OI/gtwBVoQTZd1n/frHx9CmN0+CE0bI12QVGlWJZmX+Xxi5XpDzDjoyjS+PQbCcI8SJY+RDF1WjyZuSQb5096qwuVyiIY0D2x52gMiCTO7lq8s5F8AKHXI4oTjj4orMFOGLd/UkMT4w/BcSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The multi-instance CPU hotplug state setup API is named as
cpuhp_setup_state_multi(), whereas the corresponding remove API is
currently named as cpuhp_remove_multi_state(). Rename the latter as
cpuhp_remove_state_multi() to fix the asymmetry. This also helps
maintain consistency in the API names by letting them share a common
prefix, i.e., cpuhp_setup/remove_state_*() across all the variants
[none|nocalls|nocalls_cpuslocked].

Signed-off-by: Srivatsa S. Bhat (Microsoft) <srivatsa@csail.mit.edu>
---
Performing the API rename in
Documentation/translations/zh_CN/core-api/cpu_hotplug.rst is left as a
to-do, as I don't know how to edit that file correctly, and didn't want
to mess up the translation in the process. If someone can help do the
rename in that file safely, that would be much appreciated!
---
 Documentation/core-api/cpu_hotplug.rst       | 6 +++---
 drivers/block/zram/zram_drv.c                | 6 +++---
 drivers/devfreq/event/rockchip-dfi.c         | 2 +-
 drivers/fpga/dfl-fme-perf.c                  | 4 ++--
 drivers/hwtracing/coresight/coresight-trbe.c | 4 ++--
 drivers/hwtracing/ptt/hisi_ptt.c             | 4 ++--
 drivers/iommu/iova.c                         | 2 +-
 drivers/md/raid5.c                           | 4 ++--
 drivers/net/ethernet/ibm/ibmvnic.c           | 8 ++++----
 drivers/net/ethernet/marvell/mvneta.c        | 8 ++++----
 drivers/net/virtio_net.c                     | 8 ++++----
 drivers/nvdimm/nd_perf.c                     | 6 +++---
 drivers/perf/alibaba_uncore_drw_pmu.c        | 4 ++--
 drivers/perf/arm-ccn.c                       | 4 ++--
 drivers/perf/arm-cmn.c                       | 4 ++--
 drivers/perf/arm-ni.c                        | 4 ++--
 drivers/perf/arm_cspmu/arm_cspmu.c           | 2 +-
 drivers/perf/arm_dmc620_pmu.c                | 4 ++--
 drivers/perf/arm_dsu_pmu.c                   | 4 ++--
 drivers/perf/arm_smmuv3_pmu.c                | 4 ++--
 drivers/perf/arm_spe_pmu.c                   | 4 ++--
 drivers/perf/cxl_pmu.c                       | 4 ++--
 drivers/perf/dwc_pcie_pmu.c                  | 4 ++--
 drivers/perf/fsl_imx8_ddr_perf.c             | 4 ++--
 drivers/perf/fsl_imx9_ddr_perf.c             | 4 ++--
 drivers/perf/fujitsu_uncore_pmu.c            | 4 ++--
 drivers/perf/hisilicon/hisi_pcie_pmu.c       | 4 ++--
 drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c | 4 ++--
 drivers/perf/hisilicon/hisi_uncore_pmu.c     | 2 +-
 drivers/perf/hisilicon/hns3_pmu.c            | 4 ++--
 drivers/perf/marvell_cn10k_ddr_pmu.c         | 4 ++--
 drivers/perf/marvell_cn10k_tad_pmu.c         | 4 ++--
 drivers/perf/marvell_pem_pmu.c               | 4 ++--
 drivers/perf/nvidia_t410_c2c_pmu.c           | 2 +-
 drivers/perf/nvidia_t410_cmem_latency_pmu.c  | 2 +-
 drivers/perf/thunderx2_pmu.c                 | 4 ++--
 drivers/scsi/lpfc/lpfc_init.c                | 4 ++--
 include/linux/cpuhotplug.h                   | 4 ++--
 kernel/padata.c                              | 2 +-
 kernel/trace/trace.c                         | 2 +-
 mm/zswap.c                                   | 2 +-
 41 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/Documentation/core-api/cpu_hotplug.rst b/Documentation/core-api/cpu_hotplug.rst
index f8b3f59a3d5f..a387ccb08eef 100644
--- a/Documentation/core-api/cpu_hotplug.rst
+++ b/Documentation/core-api/cpu_hotplug.rst
@@ -471,7 +471,7 @@ To remove a previously set up state, the following functions are provided:
 * cpuhp_remove_state(state)
 * cpuhp_remove_state_nocalls(state)
 * cpuhp_remove_state_nocalls_cpuslocked(state)
-* cpuhp_remove_multi_state(state)
+* cpuhp_remove_state_multi(state)
 
 The @state argument is either a statically allocated state or the state
 number which was allocated in the dynamic range by cpuhp_setup_state*(). If
@@ -481,7 +481,7 @@ available for dynamic allocation again.
 The functions differ in the way how the installed callbacks are treated:
 
   * cpuhp_remove_state_nocalls(), cpuhp_remove_state_nocalls_cpuslocked()
-    and cpuhp_remove_multi_state() only remove the callbacks.
+    and cpuhp_remove_state_multi() only remove the callbacks.
 
   * cpuhp_remove_state() removes the callbacks and invokes the teardown
     callback (if not NULL) for all online CPUs which have currently a state
@@ -611,7 +611,7 @@ ONLINE section for notifications on online and offline operation::
    ....
    cpuhp_state_remove_instance(state, &inst2->node);
    ....
-   cpuhp_remove_multi_state(state);
+   cpuhp_remove_state_multi(state);
 
 
 Testing of hotplug states
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ab064c84b092..d152c356bd6a 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3270,7 +3270,7 @@ static void destroy_devices(void)
 	zram_debugfs_destroy();
 	idr_destroy(&zram_index_idr);
 	unregister_blkdev(zram_major, "zram");
-	cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
+	cpuhp_remove_state_multi(CPUHP_ZCOMP_PREPARE);
 }
 
 static int __init zram_init(void)
@@ -3288,7 +3288,7 @@ static int __init zram_init(void)
 	ret = class_register(&zram_control_class);
 	if (ret) {
 		pr_err("Unable to register zram-control class\n");
-		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
+		cpuhp_remove_state_multi(CPUHP_ZCOMP_PREPARE);
 		return ret;
 	}
 
@@ -3297,7 +3297,7 @@ static int __init zram_init(void)
 	if (zram_major <= 0) {
 		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
-		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
+		cpuhp_remove_state_multi(CPUHP_ZCOMP_PREPARE);
 		return -EBUSY;
 	}
 
diff --git a/drivers/devfreq/event/rockchip-dfi.c b/drivers/devfreq/event/rockchip-dfi.c
index 16b25779d2f8..137adb1b7d27 100644
--- a/drivers/devfreq/event/rockchip-dfi.c
+++ b/drivers/devfreq/event/rockchip-dfi.c
@@ -614,7 +614,7 @@ static void rockchip_ddr_cpuhp_remove_state(void *data)
 {
 	struct rockchip_dfi *dfi = data;
 
-	cpuhp_remove_multi_state(dfi->cpuhp_state);
+	cpuhp_remove_state_multi(dfi->cpuhp_state);
 
 	rockchip_dfi_disable(dfi);
 }
diff --git a/drivers/fpga/dfl-fme-perf.c b/drivers/fpga/dfl-fme-perf.c
index a0e3abc64c9e..9cd5327ceab4 100644
--- a/drivers/fpga/dfl-fme-perf.c
+++ b/drivers/fpga/dfl-fme-perf.c
@@ -998,7 +998,7 @@ static int fme_perf_init(struct platform_device *pdev,
 pmu_register_err:
 	cpuhp_state_remove_instance_nocalls(priv->cpuhp_state, &priv->node);
 cpuhp_instance_err:
-	cpuhp_remove_multi_state(priv->cpuhp_state);
+	cpuhp_remove_state_multi(priv->cpuhp_state);
 	return ret;
 }
 
@@ -1009,7 +1009,7 @@ static void fme_perf_uinit(struct platform_device *pdev,
 
 	fme_perf_pmu_unregister(priv);
 	cpuhp_state_remove_instance_nocalls(priv->cpuhp_state, &priv->node);
-	cpuhp_remove_multi_state(priv->cpuhp_state);
+	cpuhp_remove_state_multi(priv->cpuhp_state);
 }
 
 const struct dfl_feature_id fme_perf_id_table[] = {
diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 3fa663c7f026..06d2c5b93f63 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -1524,7 +1524,7 @@ static int arm_trbe_probe_cpuhp(struct trbe_drvdata *drvdata)
 
 	ret = cpuhp_state_add_instance(trbe_online, &drvdata->hotplug_node);
 	if (ret) {
-		cpuhp_remove_multi_state(trbe_online);
+		cpuhp_remove_state_multi(trbe_online);
 		return ret;
 	}
 	drvdata->trbe_online = trbe_online;
@@ -1534,7 +1534,7 @@ static int arm_trbe_probe_cpuhp(struct trbe_drvdata *drvdata)
 static void arm_trbe_remove_cpuhp(struct trbe_drvdata *drvdata)
 {
 	cpuhp_state_remove_instance(drvdata->trbe_online, &drvdata->hotplug_node);
-	cpuhp_remove_multi_state(drvdata->trbe_online);
+	cpuhp_remove_state_multi(drvdata->trbe_online);
 }
 
 static int arm_trbe_probe_irq(struct platform_device *pdev,
diff --git a/drivers/hwtracing/ptt/hisi_ptt.c b/drivers/hwtracing/ptt/hisi_ptt.c
index 6ed65b44a4af..7d7dbc0916c1 100644
--- a/drivers/hwtracing/ptt/hisi_ptt.c
+++ b/drivers/hwtracing/ptt/hisi_ptt.c
@@ -1425,7 +1425,7 @@ static int __init hisi_ptt_init(void)
 
 	ret = pci_register_driver(&hisi_ptt_driver);
 	if (ret)
-		cpuhp_remove_multi_state(hisi_ptt_pmu_online);
+		cpuhp_remove_state_multi(hisi_ptt_pmu_online);
 
 	return ret;
 }
@@ -1434,7 +1434,7 @@ module_init(hisi_ptt_init);
 static void __exit hisi_ptt_exit(void)
 {
 	pci_unregister_driver(&hisi_ptt_driver);
-	cpuhp_remove_multi_state(hisi_ptt_pmu_online);
+	cpuhp_remove_state_multi(hisi_ptt_pmu_online);
 }
 module_exit(hisi_ptt_exit);
 
diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index b710e5ad37e2..266d9ce3a712 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -998,7 +998,7 @@ void iova_cache_put(void)
 	}
 	iova_cache_users--;
 	if (!iova_cache_users) {
-		cpuhp_remove_multi_state(CPUHP_IOMMU_IOVA_DEAD);
+		cpuhp_remove_state_multi(CPUHP_IOMMU_IOVA_DEAD);
 		kmem_cache_destroy(iova_cache);
 		kmem_cache_destroy(iova_magazine_cache);
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d52adf81065a..5ffa3583fc11 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -9402,7 +9402,7 @@ static int __init raid5_init(void)
 err_unregister_raid6:
 	unregister_md_submodule(&raid6_personality.head);
 err_cpuhp_remove:
-	cpuhp_remove_multi_state(CPUHP_MD_RAID5_PREPARE);
+	cpuhp_remove_state_multi(CPUHP_MD_RAID5_PREPARE);
 err_destroy_wq:
 	destroy_workqueue(raid5_wq);
 	return ret;
@@ -9413,7 +9413,7 @@ static void __exit raid5_exit(void)
 	unregister_md_submodule(&raid6_personality.head);
 	unregister_md_submodule(&raid5_personality.head);
 	unregister_md_submodule(&raid4_personality.head);
-	cpuhp_remove_multi_state(CPUHP_MD_RAID5_PREPARE);
+	cpuhp_remove_state_multi(CPUHP_MD_RAID5_PREPARE);
 	destroy_workqueue(raid5_wq);
 }
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5a510eed335e..73b3fb306333 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -6779,9 +6779,9 @@ static int __init ibmvnic_module_init(void)
 
 	return 0;
 err_vio_register:
-	cpuhp_remove_multi_state(CPUHP_IBMVNIC_DEAD);
+	cpuhp_remove_state_multi(CPUHP_IBMVNIC_DEAD);
 err_dead:
-	cpuhp_remove_multi_state(ibmvnic_online);
+	cpuhp_remove_state_multi(ibmvnic_online);
 out:
 	return ret;
 }
@@ -6789,8 +6789,8 @@ static int __init ibmvnic_module_init(void)
 static void __exit ibmvnic_module_exit(void)
 {
 	vio_unregister_driver(&ibmvnic_driver);
-	cpuhp_remove_multi_state(CPUHP_IBMVNIC_DEAD);
-	cpuhp_remove_multi_state(ibmvnic_online);
+	cpuhp_remove_state_multi(CPUHP_IBMVNIC_DEAD);
+	cpuhp_remove_state_multi(ibmvnic_online);
 }
 
 module_init(ibmvnic_module_init);
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 915c4c35364a..7f7a090e78b6 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5967,9 +5967,9 @@ static int __init mvneta_driver_init(void)
 	return 0;
 
 err:
-	cpuhp_remove_multi_state(CPUHP_NET_MVNETA_DEAD);
+	cpuhp_remove_state_multi(CPUHP_NET_MVNETA_DEAD);
 err_dead:
-	cpuhp_remove_multi_state(online_hpstate);
+	cpuhp_remove_state_multi(online_hpstate);
 out:
 	return ret;
 }
@@ -5978,8 +5978,8 @@ module_init(mvneta_driver_init);
 static void __exit mvneta_driver_exit(void)
 {
 	platform_driver_unregister(&mvneta_driver);
-	cpuhp_remove_multi_state(CPUHP_NET_MVNETA_DEAD);
-	cpuhp_remove_multi_state(online_hpstate);
+	cpuhp_remove_state_multi(CPUHP_NET_MVNETA_DEAD);
+	cpuhp_remove_state_multi(online_hpstate);
 }
 module_exit(mvneta_driver_exit);
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 1cd64f9e12e7..b11f2180de47 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -7354,9 +7354,9 @@ static __init int virtio_net_driver_init(void)
 		goto err_virtio;
 	return 0;
 err_virtio:
-	cpuhp_remove_multi_state(CPUHP_VIRT_NET_DEAD);
+	cpuhp_remove_state_multi(CPUHP_VIRT_NET_DEAD);
 err_dead:
-	cpuhp_remove_multi_state(virtionet_online);
+	cpuhp_remove_state_multi(virtionet_online);
 out:
 	return ret;
 }
@@ -7365,8 +7365,8 @@ module_init(virtio_net_driver_init);
 static __exit void virtio_net_driver_exit(void)
 {
 	unregister_virtio_driver(&virtio_net_driver);
-	cpuhp_remove_multi_state(CPUHP_VIRT_NET_DEAD);
-	cpuhp_remove_multi_state(virtionet_online);
+	cpuhp_remove_state_multi(CPUHP_VIRT_NET_DEAD);
+	cpuhp_remove_state_multi(virtionet_online);
 }
 module_exit(virtio_net_driver_exit);
 
diff --git a/drivers/nvdimm/nd_perf.c b/drivers/nvdimm/nd_perf.c
index 9e497cae65b3..aec1f3d71fc4 100644
--- a/drivers/nvdimm/nd_perf.c
+++ b/drivers/nvdimm/nd_perf.c
@@ -245,7 +245,7 @@ static int nvdimm_pmu_cpu_hotplug_init(struct nvdimm_pmu *nd_pmu)
 	/* Register the pmu instance for cpu hotplug */
 	rc = cpuhp_state_add_instance_nocalls(nd_pmu->cpuhp_state, &nd_pmu->node);
 	if (rc) {
-		cpuhp_remove_multi_state(nd_pmu->cpuhp_state);
+		cpuhp_remove_state_multi(nd_pmu->cpuhp_state);
 		return rc;
 	}
 
@@ -253,7 +253,7 @@ static int nvdimm_pmu_cpu_hotplug_init(struct nvdimm_pmu *nd_pmu)
 	rc = create_cpumask_attr_group(nd_pmu);
 	if (rc) {
 		cpuhp_state_remove_instance_nocalls(nd_pmu->cpuhp_state, &nd_pmu->node);
-		cpuhp_remove_multi_state(nd_pmu->cpuhp_state);
+		cpuhp_remove_state_multi(nd_pmu->cpuhp_state);
 		return rc;
 	}
 
@@ -263,7 +263,7 @@ static int nvdimm_pmu_cpu_hotplug_init(struct nvdimm_pmu *nd_pmu)
 static void nvdimm_pmu_free_hotplug_memory(struct nvdimm_pmu *nd_pmu)
 {
 	cpuhp_state_remove_instance_nocalls(nd_pmu->cpuhp_state, &nd_pmu->node);
-	cpuhp_remove_multi_state(nd_pmu->cpuhp_state);
+	cpuhp_remove_state_multi(nd_pmu->cpuhp_state);
 
 	if (nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR])
 		kfree(nd_pmu->pmu.attr_groups[NVDIMM_PMU_CPUMASK_ATTR]->attrs);
diff --git a/drivers/perf/alibaba_uncore_drw_pmu.c b/drivers/perf/alibaba_uncore_drw_pmu.c
index c47c6ac170b2..e114330d6ea8 100644
--- a/drivers/perf/alibaba_uncore_drw_pmu.c
+++ b/drivers/perf/alibaba_uncore_drw_pmu.c
@@ -799,7 +799,7 @@ static int __init ali_drw_pmu_init(void)
 
 	ret = platform_driver_register(&ali_drw_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(ali_drw_cpuhp_state_num);
+		cpuhp_remove_state_multi(ali_drw_cpuhp_state_num);
 
 	return ret;
 }
@@ -807,7 +807,7 @@ static int __init ali_drw_pmu_init(void)
 static void __exit ali_drw_pmu_exit(void)
 {
 	platform_driver_unregister(&ali_drw_pmu_driver);
-	cpuhp_remove_multi_state(ali_drw_cpuhp_state_num);
+	cpuhp_remove_state_multi(ali_drw_cpuhp_state_num);
 }
 
 module_init(ali_drw_pmu_init);
diff --git a/drivers/perf/arm-ccn.c b/drivers/perf/arm-ccn.c
index 0c69165e0041..86d6edd18c84 100644
--- a/drivers/perf/arm-ccn.c
+++ b/drivers/perf/arm-ccn.c
@@ -1543,14 +1543,14 @@ static int __init arm_ccn_init(void)
 
 	ret = platform_driver_register(&arm_ccn_driver);
 	if (ret)
-		cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_CCN_ONLINE);
+		cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_CCN_ONLINE);
 	return ret;
 }
 
 static void __exit arm_ccn_exit(void)
 {
 	platform_driver_unregister(&arm_ccn_driver);
-	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_CCN_ONLINE);
+	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_CCN_ONLINE);
 }
 
 module_init(arm_ccn_init);
diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 68a096c1fe6b..787de602b60c 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -2969,7 +2969,7 @@ static int __init arm_cmn_init(void)
 
 	ret = platform_driver_register(&arm_cmn_driver);
 	if (ret) {
-		cpuhp_remove_multi_state(arm_cmn_hp_state);
+		cpuhp_remove_state_multi(arm_cmn_hp_state);
 		debugfs_remove(arm_cmn_debugfs);
 	}
 	return ret;
@@ -2978,7 +2978,7 @@ static int __init arm_cmn_init(void)
 static void __exit arm_cmn_exit(void)
 {
 	platform_driver_unregister(&arm_cmn_driver);
-	cpuhp_remove_multi_state(arm_cmn_hp_state);
+	cpuhp_remove_state_multi(arm_cmn_hp_state);
 	debugfs_remove(arm_cmn_debugfs);
 }
 
diff --git a/drivers/perf/arm-ni.c b/drivers/perf/arm-ni.c
index 1f8eecf8ca11..6d3e63ba8ca8 100644
--- a/drivers/perf/arm-ni.c
+++ b/drivers/perf/arm-ni.c
@@ -844,14 +844,14 @@ static int __init arm_ni_init(void)
 
 	ret = platform_driver_register(&arm_ni_driver);
 	if (ret)
-		cpuhp_remove_multi_state(arm_ni_hp_state);
+		cpuhp_remove_state_multi(arm_ni_hp_state);
 	return ret;
 }
 
 static void __exit arm_ni_exit(void)
 {
 	platform_driver_unregister(&arm_ni_driver);
-	cpuhp_remove_multi_state(arm_ni_hp_state);
+	cpuhp_remove_state_multi(arm_ni_hp_state);
 }
 
 module_init(arm_ni_init);
diff --git a/drivers/perf/arm_cspmu/arm_cspmu.c b/drivers/perf/arm_cspmu/arm_cspmu.c
index d0b29213f451..6a43a21f2953 100644
--- a/drivers/perf/arm_cspmu/arm_cspmu.c
+++ b/drivers/perf/arm_cspmu/arm_cspmu.c
@@ -1449,7 +1449,7 @@ static int __init arm_cspmu_init(void)
 static void __exit arm_cspmu_exit(void)
 {
 	platform_driver_unregister(&arm_cspmu_driver);
-	cpuhp_remove_multi_state(arm_cspmu_cpuhp_state);
+	cpuhp_remove_state_multi(arm_cspmu_cpuhp_state);
 }
 
 int arm_cspmu_impl_register(const struct arm_cspmu_impl_match *impl_match)
diff --git a/drivers/perf/arm_dmc620_pmu.c b/drivers/perf/arm_dmc620_pmu.c
index 9a7b05b48da0..7c33f09bf236 100644
--- a/drivers/perf/arm_dmc620_pmu.c
+++ b/drivers/perf/arm_dmc620_pmu.c
@@ -765,7 +765,7 @@ static int __init dmc620_pmu_init(void)
 
 	ret = platform_driver_register(&dmc620_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(cpuhp_state_num);
+		cpuhp_remove_state_multi(cpuhp_state_num);
 
 	return ret;
 }
@@ -773,7 +773,7 @@ static int __init dmc620_pmu_init(void)
 static void __exit dmc620_pmu_exit(void)
 {
 	platform_driver_unregister(&dmc620_pmu_driver);
-	cpuhp_remove_multi_state(cpuhp_state_num);
+	cpuhp_remove_state_multi(cpuhp_state_num);
 }
 
 module_init(dmc620_pmu_init);
diff --git a/drivers/perf/arm_dsu_pmu.c b/drivers/perf/arm_dsu_pmu.c
index 751bfed944a9..c737e492175a 100644
--- a/drivers/perf/arm_dsu_pmu.c
+++ b/drivers/perf/arm_dsu_pmu.c
@@ -852,7 +852,7 @@ static int __init dsu_pmu_init(void)
 	dsu_pmu_cpuhp_state = ret;
 	ret = platform_driver_register(&dsu_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(dsu_pmu_cpuhp_state);
+		cpuhp_remove_state_multi(dsu_pmu_cpuhp_state);
 
 	return ret;
 }
@@ -860,7 +860,7 @@ static int __init dsu_pmu_init(void)
 static void __exit dsu_pmu_exit(void)
 {
 	platform_driver_unregister(&dsu_pmu_driver);
-	cpuhp_remove_multi_state(dsu_pmu_cpuhp_state);
+	cpuhp_remove_state_multi(dsu_pmu_cpuhp_state);
 }
 
 module_init(dsu_pmu_init);
diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
index 97440b6233c6..c328238c215a 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -1016,7 +1016,7 @@ static int __init arm_smmu_pmu_init(void)
 
 	ret = platform_driver_register(&smmu_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(cpuhp_state_num);
+		cpuhp_remove_state_multi(cpuhp_state_num);
 
 	return ret;
 }
@@ -1025,7 +1025,7 @@ module_init(arm_smmu_pmu_init);
 static void __exit arm_smmu_pmu_exit(void)
 {
 	platform_driver_unregister(&smmu_pmu_driver);
-	cpuhp_remove_multi_state(cpuhp_state_num);
+	cpuhp_remove_state_multi(cpuhp_state_num);
 }
 
 module_exit(arm_smmu_pmu_exit);
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 707778c67dab..30a946fccb94 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -1442,7 +1442,7 @@ static int __init arm_spe_pmu_init(void)
 
 	ret = platform_driver_register(&arm_spe_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(arm_spe_pmu_online);
+		cpuhp_remove_state_multi(arm_spe_pmu_online);
 
 	return ret;
 }
@@ -1450,7 +1450,7 @@ static int __init arm_spe_pmu_init(void)
 static void __exit arm_spe_pmu_exit(void)
 {
 	platform_driver_unregister(&arm_spe_pmu_driver);
-	cpuhp_remove_multi_state(arm_spe_pmu_online);
+	cpuhp_remove_state_multi(arm_spe_pmu_online);
 }
 
 module_init(arm_spe_pmu_init);
diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index ce4097c4f64e..7b354c190d55 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -1138,7 +1138,7 @@ static __init int cxl_pmu_init(void)
 
 	rc = cxl_driver_register(&cxl_pmu_driver);
 	if (rc)
-		cpuhp_remove_multi_state(cxl_pmu_cpuhp_state_num);
+		cpuhp_remove_state_multi(cxl_pmu_cpuhp_state_num);
 
 	return rc;
 }
@@ -1146,7 +1146,7 @@ static __init int cxl_pmu_init(void)
 static __exit void cxl_pmu_exit(void)
 {
 	cxl_driver_unregister(&cxl_pmu_driver);
-	cpuhp_remove_multi_state(cxl_pmu_cpuhp_state_num);
+	cpuhp_remove_state_multi(cxl_pmu_cpuhp_state_num);
 }
 
 MODULE_DESCRIPTION("CXL Performance Monitor Driver");
diff --git a/drivers/perf/dwc_pcie_pmu.c b/drivers/perf/dwc_pcie_pmu.c
index 039730a3b80d..3b715294e2f5 100644
--- a/drivers/perf/dwc_pcie_pmu.c
+++ b/drivers/perf/dwc_pcie_pmu.c
@@ -928,7 +928,7 @@ static int __init dwc_pcie_pmu_init(void)
 err_unregister_driver:
 	platform_driver_unregister(&dwc_pcie_pmu_driver);
 err_remove_cpuhp:
-	cpuhp_remove_multi_state(dwc_pcie_pmu_hp_state);
+	cpuhp_remove_state_multi(dwc_pcie_pmu_hp_state);
 err_cleanup:
 	dwc_pcie_cleanup_devices();
 	return ret;
@@ -940,7 +940,7 @@ static void __exit dwc_pcie_pmu_exit(void)
 		bus_unregister_notifier(&pci_bus_type, &dwc_pcie_pmu_nb);
 	dwc_pcie_cleanup_devices();
 	platform_driver_unregister(&dwc_pcie_pmu_driver);
-	cpuhp_remove_multi_state(dwc_pcie_pmu_hp_state);
+	cpuhp_remove_state_multi(dwc_pcie_pmu_hp_state);
 }
 
 module_init(dwc_pcie_pmu_init);
diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index 39b25d70942d..af9319ef2f5c 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -877,7 +877,7 @@ static int ddr_perf_probe(struct platform_device *pdev)
 ddr_perf_err:
 	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
 cpuhp_instance_err:
-	cpuhp_remove_multi_state(pmu->cpuhp_state);
+	cpuhp_remove_state_multi(pmu->cpuhp_state);
 idr_free:
 	ida_free(ida, pmu->id);
 	dev_warn(&pdev->dev, "i.MX8 DDR Perf PMU failed (%d), disabled\n", ret);
@@ -889,7 +889,7 @@ static void ddr_perf_remove(struct platform_device *pdev)
 	struct ddr_pmu *pmu = platform_get_drvdata(pdev);
 
 	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
-	cpuhp_remove_multi_state(pmu->cpuhp_state);
+	cpuhp_remove_state_multi(pmu->cpuhp_state);
 
 	perf_pmu_unregister(&pmu->pmu);
 
diff --git a/drivers/perf/fsl_imx9_ddr_perf.c b/drivers/perf/fsl_imx9_ddr_perf.c
index 739c6567cd68..c09eeb9b6a21 100644
--- a/drivers/perf/fsl_imx9_ddr_perf.c
+++ b/drivers/perf/fsl_imx9_ddr_perf.c
@@ -849,7 +849,7 @@ static int ddr_perf_probe(struct platform_device *pdev)
 ddr_perf_err:
 	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
 cpuhp_instance_err:
-	cpuhp_remove_multi_state(pmu->cpuhp_state);
+	cpuhp_remove_state_multi(pmu->cpuhp_state);
 cpuhp_state_err:
 format_string_err:
 	ida_free(&ddr_ida, pmu->id);
@@ -862,7 +862,7 @@ static void ddr_perf_remove(struct platform_device *pdev)
 	struct ddr_pmu *pmu = platform_get_drvdata(pdev);
 
 	cpuhp_state_remove_instance_nocalls(pmu->cpuhp_state, &pmu->node);
-	cpuhp_remove_multi_state(pmu->cpuhp_state);
+	cpuhp_remove_state_multi(pmu->cpuhp_state);
 
 	perf_pmu_unregister(&pmu->pmu);
 
diff --git a/drivers/perf/fujitsu_uncore_pmu.c b/drivers/perf/fujitsu_uncore_pmu.c
index f6165eb44c07..91ee608a5fd5 100644
--- a/drivers/perf/fujitsu_uncore_pmu.c
+++ b/drivers/perf/fujitsu_uncore_pmu.c
@@ -593,7 +593,7 @@ static int __init fujitsu_uncore_pmu_init(void)
 
 	ret = platform_driver_register(&fujitsu_uncore_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(uncore_pmu_cpuhp_state);
+		cpuhp_remove_state_multi(uncore_pmu_cpuhp_state);
 
 	return ret;
 }
@@ -601,7 +601,7 @@ static int __init fujitsu_uncore_pmu_init(void)
 static void __exit fujitsu_uncore_pmu_exit(void)
 {
 	platform_driver_unregister(&fujitsu_uncore_pmu_driver);
-	cpuhp_remove_multi_state(uncore_pmu_cpuhp_state);
+	cpuhp_remove_state_multi(uncore_pmu_cpuhp_state);
 }
 
 module_init(fujitsu_uncore_pmu_init);
diff --git a/drivers/perf/hisilicon/hisi_pcie_pmu.c b/drivers/perf/hisilicon/hisi_pcie_pmu.c
index 2414f222afcd..0c083a45fdd3 100644
--- a/drivers/perf/hisilicon/hisi_pcie_pmu.c
+++ b/drivers/perf/hisilicon/hisi_pcie_pmu.c
@@ -989,7 +989,7 @@ static int __init hisi_pcie_module_init(void)
 
 	ret = pci_register_driver(&hisi_pcie_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_HISI_PCIE_PMU_ONLINE);
+		cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_HISI_PCIE_PMU_ONLINE);
 
 	return ret;
 }
@@ -998,7 +998,7 @@ module_init(hisi_pcie_module_init);
 static void __exit hisi_pcie_module_exit(void)
 {
 	pci_unregister_driver(&hisi_pcie_pmu_driver);
-	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_HISI_PCIE_PMU_ONLINE);
+	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_HISI_PCIE_PMU_ONLINE);
 }
 module_exit(hisi_pcie_module_exit);
 
diff --git a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
index 167e369cf74c..78fb005907a2 100644
--- a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
@@ -952,7 +952,7 @@ static int __init hisi_l3c_pmu_module_init(void)
 
 	ret = platform_driver_register(&hisi_l3c_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(hisi_l3c_pmu_cpuhp_state);
+		cpuhp_remove_state_multi(hisi_l3c_pmu_cpuhp_state);
 
 	return ret;
 }
@@ -961,7 +961,7 @@ module_init(hisi_l3c_pmu_module_init);
 static void __exit hisi_l3c_pmu_module_exit(void)
 {
 	platform_driver_unregister(&hisi_l3c_pmu_driver);
-	cpuhp_remove_multi_state(hisi_l3c_pmu_cpuhp_state);
+	cpuhp_remove_state_multi(hisi_l3c_pmu_cpuhp_state);
 }
 module_exit(hisi_l3c_pmu_module_exit);
 
diff --git a/drivers/perf/hisilicon/hisi_uncore_pmu.c b/drivers/perf/hisilicon/hisi_uncore_pmu.c
index 346c87594614..9b7e39404510 100644
--- a/drivers/perf/hisilicon/hisi_uncore_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_pmu.c
@@ -639,7 +639,7 @@ module_init(hisi_uncore_pmu_init);
 
 static void __exit hisi_uncore_pmu_exit(void)
 {
-	cpuhp_remove_multi_state(hisi_uncore_pmu_cpuhp_state);
+	cpuhp_remove_state_multi(hisi_uncore_pmu_cpuhp_state);
 }
 module_exit(hisi_uncore_pmu_exit);
 
diff --git a/drivers/perf/hisilicon/hns3_pmu.c b/drivers/perf/hisilicon/hns3_pmu.c
index 3069257ca79f..70eeae0b07e5 100644
--- a/drivers/perf/hisilicon/hns3_pmu.c
+++ b/drivers/perf/hisilicon/hns3_pmu.c
@@ -1656,7 +1656,7 @@ static int __init hns3_pmu_module_init(void)
 	ret = pci_register_driver(&hns3_pmu_driver);
 	if (ret) {
 		pr_err("failed to register pci driver, ret = %d.\n", ret);
-		cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_HNS3_PMU_ONLINE);
+		cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_HNS3_PMU_ONLINE);
 	}
 
 	return ret;
@@ -1666,7 +1666,7 @@ module_init(hns3_pmu_module_init);
 static void __exit hns3_pmu_module_exit(void)
 {
 	pci_unregister_driver(&hns3_pmu_driver);
-	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_HNS3_PMU_ONLINE);
+	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_HNS3_PMU_ONLINE);
 }
 module_exit(hns3_pmu_module_exit);
 
diff --git a/drivers/perf/marvell_cn10k_ddr_pmu.c b/drivers/perf/marvell_cn10k_ddr_pmu.c
index c699a4545935..5e1187ade225 100644
--- a/drivers/perf/marvell_cn10k_ddr_pmu.c
+++ b/drivers/perf/marvell_cn10k_ddr_pmu.c
@@ -1345,7 +1345,7 @@ static int __init cn10k_ddr_pmu_init(void)
 
 	ret = platform_driver_register(&cn10k_ddr_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(
+		cpuhp_remove_state_multi(
 				CPUHP_AP_PERF_ARM_MARVELL_CN10K_DDR_ONLINE);
 	return ret;
 }
@@ -1353,7 +1353,7 @@ static int __init cn10k_ddr_pmu_init(void)
 static void __exit cn10k_ddr_pmu_exit(void)
 {
 	platform_driver_unregister(&cn10k_ddr_pmu_driver);
-	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_MARVELL_CN10K_DDR_ONLINE);
+	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_MARVELL_CN10K_DDR_ONLINE);
 }
 
 module_init(cn10k_ddr_pmu_init);
diff --git a/drivers/perf/marvell_cn10k_tad_pmu.c b/drivers/perf/marvell_cn10k_tad_pmu.c
index 2d64a3351433..46f3cecf46d8 100644
--- a/drivers/perf/marvell_cn10k_tad_pmu.c
+++ b/drivers/perf/marvell_cn10k_tad_pmu.c
@@ -477,7 +477,7 @@ static int __init tad_pmu_init(void)
 	tad_pmu_cpuhp_state = ret;
 	ret = platform_driver_register(&tad_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(tad_pmu_cpuhp_state);
+		cpuhp_remove_state_multi(tad_pmu_cpuhp_state);
 
 	return ret;
 }
@@ -485,7 +485,7 @@ static int __init tad_pmu_init(void)
 static void __exit tad_pmu_exit(void)
 {
 	platform_driver_unregister(&tad_pmu_driver);
-	cpuhp_remove_multi_state(tad_pmu_cpuhp_state);
+	cpuhp_remove_state_multi(tad_pmu_cpuhp_state);
 }
 
 module_init(tad_pmu_init);
diff --git a/drivers/perf/marvell_pem_pmu.c b/drivers/perf/marvell_pem_pmu.c
index f72837fa02f9..9b8a34220351 100644
--- a/drivers/perf/marvell_pem_pmu.c
+++ b/drivers/perf/marvell_pem_pmu.c
@@ -407,14 +407,14 @@ static int __init pem_pmu_init(void)
 
 	ret = platform_driver_register(&pem_pmu_driver);
 	if (ret)
-		cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_MRVL_PEM_ONLINE);
+		cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_MRVL_PEM_ONLINE);
 	return ret;
 }
 
 static void __exit pem_pmu_exit(void)
 {
 	platform_driver_unregister(&pem_pmu_driver);
-	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_MRVL_PEM_ONLINE);
+	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_MRVL_PEM_ONLINE);
 }
 
 module_init(pem_pmu_init);
diff --git a/drivers/perf/nvidia_t410_c2c_pmu.c b/drivers/perf/nvidia_t410_c2c_pmu.c
index 1fc2adeb7195..209e90f76f3c 100644
--- a/drivers/perf/nvidia_t410_c2c_pmu.c
+++ b/drivers/perf/nvidia_t410_c2c_pmu.c
@@ -1040,7 +1040,7 @@ static int __init nv_c2c_pmu_init(void)
 static void __exit nv_c2c_pmu_exit(void)
 {
 	platform_driver_unregister(&nv_c2c_pmu_driver);
-	cpuhp_remove_multi_state(nv_c2c_pmu_cpuhp_state);
+	cpuhp_remove_state_multi(nv_c2c_pmu_cpuhp_state);
 }
 
 module_init(nv_c2c_pmu_init);
diff --git a/drivers/perf/nvidia_t410_cmem_latency_pmu.c b/drivers/perf/nvidia_t410_cmem_latency_pmu.c
index f1eff644b0ba..d8c04f47e41b 100644
--- a/drivers/perf/nvidia_t410_cmem_latency_pmu.c
+++ b/drivers/perf/nvidia_t410_cmem_latency_pmu.c
@@ -725,7 +725,7 @@ static int __init cmem_lat_pmu_init(void)
 static void __exit cmem_lat_pmu_exit(void)
 {
 	platform_driver_unregister(&cmem_lat_pmu_driver);
-	cpuhp_remove_multi_state(cmem_lat_pmu_cpuhp_state);
+	cpuhp_remove_state_multi(cmem_lat_pmu_cpuhp_state);
 }
 
 module_init(cmem_lat_pmu_init);
diff --git a/drivers/perf/thunderx2_pmu.c b/drivers/perf/thunderx2_pmu.c
index 3cf079c7ff41..08c370bd5fa4 100644
--- a/drivers/perf/thunderx2_pmu.c
+++ b/drivers/perf/thunderx2_pmu.c
@@ -1026,7 +1026,7 @@ static int __init tx2_uncore_driver_init(void)
 	}
 	ret = platform_driver_register(&tx2_uncore_driver);
 	if (ret)
-		cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_CAVIUM_TX2_UNCORE_ONLINE);
+		cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_CAVIUM_TX2_UNCORE_ONLINE);
 
 	return ret;
 }
@@ -1035,7 +1035,7 @@ module_init(tx2_uncore_driver_init);
 static void __exit tx2_uncore_driver_exit(void)
 {
 	platform_driver_unregister(&tx2_uncore_driver);
-	cpuhp_remove_multi_state(CPUHP_AP_PERF_ARM_CAVIUM_TX2_UNCORE_ONLINE);
+	cpuhp_remove_state_multi(CPUHP_AP_PERF_ARM_CAVIUM_TX2_UNCORE_ONLINE);
 }
 module_exit(tx2_uncore_driver_exit);
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6df5f4e7c5d6..39da93377e03 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -15715,7 +15715,7 @@ lpfc_init(void)
 	return error;
 
 unwind:
-	cpuhp_remove_multi_state(lpfc_cpuhp_state);
+	cpuhp_remove_state_multi(lpfc_cpuhp_state);
 cpuhp_failure:
 	fc_release_transport(lpfc_transport_template);
 	fc_release_transport(lpfc_vport_transport_template);
@@ -15816,7 +15816,7 @@ lpfc_exit(void)
 {
 	misc_deregister(&lpfc_mgmt_dev);
 	pci_unregister_driver(&lpfc_driver);
-	cpuhp_remove_multi_state(lpfc_cpuhp_state);
+	cpuhp_remove_state_multi(lpfc_cpuhp_state);
 	fc_release_transport(lpfc_transport_template);
 	fc_release_transport(lpfc_vport_transport_template);
 	idr_destroy(&lpfc_hba_index);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 1b6dba159bb2..c9563bb15e0a 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -450,14 +450,14 @@ static inline void cpuhp_remove_state_nocalls_cpuslocked(enum cpuhp_state state)
 }
 
 /**
- * cpuhp_remove_multi_state - Remove hotplug multi state callback
+ * cpuhp_remove_state_multi - Remove hotplug multi state callback
  * @state:	The state for which the calls are removed
  *
  * Removes the callback functions from a multi state. This is the reverse of
  * cpuhp_setup_state_multi(). All instances should have been removed before
  * invoking this function.
  */
-static inline void cpuhp_remove_multi_state(enum cpuhp_state state)
+static inline void cpuhp_remove_state_multi(enum cpuhp_state state)
 {
 	__cpuhp_remove_state(state, false);
 }
diff --git a/kernel/padata.c b/kernel/padata.c
index 5a113c667d4c..551c432b506f 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1111,7 +1111,7 @@ void __init padata_init(void)
 
 remove_online_state:
 #ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_remove_multi_state(hp_online);
+	cpuhp_remove_state_multi(hp_online);
 err:
 #endif
 	pr_warn("padata: initialization failed\n");
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 65b9d67647e5..8fd2de42efc4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10073,7 +10073,7 @@ __init static int tracer_alloc_buffers(void)
 out_free_temp_buffer:
 	ring_buffer_free(temp_buffer);
 out_rm_hp_state:
-	cpuhp_remove_multi_state(CPUHP_TRACE_RB_PREPARE);
+	cpuhp_remove_state_multi(CPUHP_TRACE_RB_PREPARE);
 out_free_cpumask:
 	free_cpumask_var(global_trace.tracing_cpumask);
 out_free_buffer_mask:
diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301fced..18eddeb2d69c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1880,7 +1880,7 @@ static int zswap_setup(void)
 shrinker_fail:
 	destroy_workqueue(shrink_wq);
 shrink_wq_fail:
-	cpuhp_remove_multi_state(CPUHP_MM_ZSWP_POOL_PREPARE);
+	cpuhp_remove_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE);
 hp_fail:
 	kmem_cache_destroy(zswap_entry_cache);
 cache_fail:

---
base-commit: 9437ee8b6cf607e883b36e44bd755968daaebd48
change-id: 20261127-fix-rename_cpuhp_remove_multi_state-b79dac11744e

Regards,
Srivatsa


