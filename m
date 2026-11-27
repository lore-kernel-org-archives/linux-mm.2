Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0536606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=NwXIr9Wy
Received: by kanga.kvack.org (Postfix)
	id 7C5A26B05B0; Fri, 27 Nov 2026 03:51:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7766E6B05B1; Fri, 27 Nov 2026 03:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63DC76B05C3; Fri, 27 Nov 2026 03:51:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 386706B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:51:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80DC9A0244
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:51:10 +0000 (UTC)
X-FDA: 85480279500.22.5C620DF
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf24.hostedemail.com (Postfix) with ESMTP id A9A52180004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:51:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=NwXIr9Wy;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf24.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795769469;
	b=RnKBcEJgZ3iBocWsor8vC/b5KeOSulFjj47P5CIgx6uxTMQRItDi6OFYGMhw77wVZeNQDs
	DUbgq+t5Vsa91RnrOYypgS5ZUycdCRlZqJjMSh+g20K9TvV4YGNsF4qg4FomEGByZUnS9J
	PVpM1bReALYPuUT68xAuaFiMZZHCW/8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795769469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njh3SQBBAQE61UxliWgOlIeTiJ2q96ejV3+knyCCvnY=;
	b=npwwNTmOJMVF5k5pKMzNueYUnc/Izcn2gwdLEM1fxs3HzJ+5KPKMAmx9jines4LZVSCkeV
	XtuewVwN5gLnoT+7940IDUhsQSrl8u3ZB6Fkc7DmZ/IkWECwBpCFqk55kcr9kogDOioCH0
	h4FtrOqRt8bXUAhAngZAjg8AuItcjv0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=NwXIr9Wy;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf24.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=njh3SQBBAQE61UxliWgOlIeTiJ2q96ejV3+knyCCvnY=; t=1795769468; x=1796633468; 
	b=NwXIr9WyTdr+ALEwtGLX4VDaax0f4KAuotKP07i/8zwZshXQz9hpyqOIAMSAiMVfByXZugXAniM
	Byd315FTG49qSuKEvOu30uK+VgFWriazTLG5OGPNNSB8Qs0ODM0Zp1Nn1cOSgN9GkDHXn8ELbU4Vt
	iKonXWVUQvYYy0weHIxWy+hVHt8QLdRPjU0zZo9qTChpCyelVN8i8idPFwxMMEsh6+bbVtz0wFZ+w
	JlZR3jgT2VoF1lLZ31mIuCRsvIj1wznNUIEhT282O0DZwnkkdsNqJQZkHOMyiKPbhtbC3RcOPtMdB
	a9N0lQV7vS8uOKt+iQrOu4VV5bJxp+3AFivQ==;
Received: from [167.220.238.14] (helo=csail.mit.edu)
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1xWreR-007Btx-5B;
	Fri, 27 Nov 2026 03:49:51 -0500
Date: Fri, 27 Nov 2026 14:19:20 +0530
From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To: Richard Cheng <icheng@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>, Chanwoo Choi <cw00.choi@samsung.com>,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heiko Stuebner <heiko@sntech.de>, Xu Yilun <yilun.xu@intel.com>,
	Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@arm.com>,
	James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Sizhe Liu <liusizhe5@huawei.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>, Haren Myneni <haren@linux.ibm.com>,
	Rick Lindsley <ricklind@linux.ibm.com>,
	Nick Child <nnac123@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Marcin Wojtas <marcin.s.wojtas@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Frank Li <Frank.li@nxp.com>, Xu Yang <xu.yang_2@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Yushan Wang <wangyushan12@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Gowthami Thiagarajan <gthiagarajan@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-fpga@vger.kernel.org,
	coresight@lists.linaro.org, iommu@lists.linux.dev,
	linux-raid@vger.kernel.org, netdev@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-cxl@vger.kernel.org, imx@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: Re: [PATCH] cpu/hotplug: Rename cpuhp_remove_multi_state to be
 symmetric with setup
Message-ID: <awlEEAmT4k7fvQck@csail.mit.edu>
References: <20261127-fix-rename_cpuhp_remove_multi_state-v1-1-097db4564cbd@csail.mit.edu>
 <awk6TGp9riwDD55i@MWDK4CY14F>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awk6TGp9riwDD55i@MWDK4CY14F>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9A52180004
X-Rspam-User:
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: meq6oeastrj8m5qcjn4pept7rogkjk5e
X-HE-Tag: 1795769468-603887
X-HE-Meta: U2FsdGVkX1/CVcku0ZrX2iEsc+0IDWEw60Xe+Ce2ZzW6TGOf5iOrA5DvbnfEdet6N2YBE3KgrIU7iTgxAYKW8lAHlauPmHLx+akc3WxZTkHU/dz0WgyfO3CEnWr03Nq+glEupNyyqaomiq7H+yajMTmVGe3aBauP8HiMFbw72SZ+10j75whaG+CF71Mrl/Z2enaDdTO1eKbYCPtUkk6ubnEJ/DNhjEEfixX/FFMpZrKf9aZEi20NviU50JurkqKUSDuqQnHgrc56Fi7j+YWTfdR8OOOTkzp5Rl9y7Lg/xhayCDh+YfQECbXOpt1/sl0xkV9rNtmomke8nRsRItKxeWiLZhyeOMHVXVPJSrD+MjXO2VdYqoNuqCWz2OdQQZwmV6fkUgRYHps2if9B+kSEWEjsGJU6TpVpqBTTVheInwvqgPLxxfIhrs8TKWbx9awq3+xGUAk/xcGOJwsBrgMcmfaXb29yB3mvVskedXnzVg8YiJk7951Gx2bO2kWqA73TUalPvpSWXibJOqOgWKlJglZzLDrxYh+eOJsbllM8mYzl+BcdoH12Fr4BdQAxw7rbeI9gSF0H7QPq+Cb08FEV1oFhXEP9fnbspOAE4zRSMBD+oTHcXRO/yjRo5l++AzYtwDzdK5Whywtezh6ck/ccuFNihRf6LC0jdnLoi0k4Wh1jjms3XetA+ddUdo3M6mL7FJcVc3VUKtaubCfrdGhVLtDGzCdOGSt+0KS49mk6s2xUOL4P3c/KcgjXpLjy/qrVoyg0boA1pRyh2UxP+48OEiZ9W0qXOdMdlTuG8FB4ewB6qmp2O/TjT4m/vPIqErf54YsYHsYnPVvYFbp/kr/5D8hw3eZZeladXy+/mDUJQmMPgng7hnNIHxeUQPYfIqTlaaNP18rmNDimVUY5ZrcagTQN4FV5tyIWtLbVPGiTDvtNmdSq0qbBNQEl7d7LY7cQJb2O7Hf7UJgJ+fBgFHI
 MTNr04SN
 GR3L1MzswtNd2jAi8fcIuokBYydWoK08Ahoxwnf0yePaYAG3B0aIvyxzOd9Zx5dRAUS1jdBrcysuSj2BVeLBeP13rp+gFrWYASLsxDAZ861w8WgI8ssQElwiMWOUMIysEmKcoa05nd3CU+EGKWfvLKAhapA8ilcvCS62gi1dMx6cR92ZjHCpn9KnoZItWg6jGXPjafwNA56ksJcP+KjM/JYtcqh2sEHZF6nueuQZE5NMmyKecP/A+bsz2iZ569N8buAWZI2vOB/aydQUCo/GcHZpeKbnj7L+i/x1zU7pLTdsFUZW8fOuH1SQ1lHjrLtvZehOaHgiJRCVioZnROEOue9GFDd47ZjBrIcuHvUlQuaCwM/cK6nXKu8AiCFm0BTvW0erSafyAPNwCsle94UJn+nZHgcNhmAXLNSNvzCtbuZ0VKQ9sLqsI1hV4slJruS4hnSLx0tJNVAzAkH7IPpoD6wvJ9yea1PLdNEXWBrncfmZZYSH7q2JJ+xOVDaU9g8rm1U+ExosAzwrXfolUNf0ucjYo3Dum78ZFmSMXk3C6zkmpYfOaG3jyZJQYZWdT/jP7z+C8PekJDIixaH01te7M83YYMTQy2FRtZwa11GF+e87JS3+hQ8YfmqJ5UX1KBiRIo50VOxEss/TxYohz16DE73QnyAr8jYVOP4UQCwgPFaJNBXuPcc9zoZEsuqiW1ZBsXxPCr/P5YK+5B4ou7GELkBIM+PbsUrNYFRucx0HWOP1TByy0r8HwbvY70hk9m0bHqyViQETD6Y8OyxAA1S3hlZE5rZ4AePPB6oRLXVkvq52b7rPNq0zzLT0lZinpFCbn90ispxwod494EkWYKfaVEsjemQ78HaFp66su03/Vvt8IkwLR06rb5ttmaUmNeazLVGSmudifNPptfbHw7mv1PePia6klp9f2n4QmRkaNAVDCRauwDgwzcpjDDG4m6WeZDRd5372X2soAD/sK1K4dmZGyFSyb
 73J/mzBG
 qWnlPheyPSx7mRm3XR8efvvYIkKsrsqJlIuIFRM+pJI0unRT1Koz5NjaLKDz0HztiVHcbccSIIGWNEHguXTXD1sIQ/fJuAZNQARs3myqzfi5FckLTElqBSLVvlERebpZOmAqs4Kz8fntemy1SI0glDr8TdTZfLiMi9st2YMH+HZAa9FryHGfw8vFsXDGL0Nnk1rGTRJw7z6FkojHD4l3NfsI/hRFs+GN4vpS6w66reZxmo0BAE9M0OTAbB8uCSJHW5v3uB5oArWzukNgzhMS+Ipe5gtR0zYxQT9DUowWozYqeNqqyM9Kie5kewJOGrPzSpFdhv8p8slmAt/m3+JxGX/4yPHq3VlAuT3ZPZIRAaoNJod7sKl1S5isANTsVGgrm31M8IegP4PCmqzuBR7GFR2X9sblWjdo2PrAAXy6GURlfdLBPwptPz5QaOAw6NCXx9g7S9K56LhAhLSS/n2gyWebKTD731VCX1B8yhYOthe4aNUd/o9t9oW/ol0Y0O7Tj2X7BAHvkck/4m84vzqhwwTGFY/LmaLhv9ofWJ3CkUjm5hICTKG6MTzyOdGMo/jJRKU4aH3i0+YiWaNX5/m5DVZB+6JwFsqtyQZLE+h6MvSrM/kl3oYzgjaD2YIOrgqdGucBr8fWksmGT041KCSEExRPuOUQ07JYAYBcdHek3Guw5w3B68il5mAoiFF/3cW/Yy42+uKdzdnTvWJ73JY/+f78knIE29N4eqMmE7KgOY2U5SzgNwX6JXsymRaSNRlkhOAtjvWYZl9Rzlha39Rj4NQ0K4tFmMPESFjGnKn7TqV6AP4wCPTktXIyNFprflX+aXp5ZY0kcFEIrC3n7nT9IiorG5XvklHXq/bsz6nl7YGXLVw8fWTF4kJBqvWnjCHYp/GWHRqup5uFztL7s8fjBytQjapM0X7nTNr47doquaj89RRXk7fRVQQn4IpEBhINBsiyPArO+CF0rgU0lCdnaHjwp8Gau
 1LgimhdH
 keNGEW4zNarl3tLTy8WPakDVs0N2wcwGkzRTauZ1ATVVLS8+4g8qriiTpynHi8jhACthpzTqztlxWtBVHcNKeSC29aWOitIIvmgXv26hIyZJjZfdWOzad8c71E9Xps5YGs8gu6tjH+WzYOycs9W2E5huOIhOJaqO4Xam6zpEix6aeSaN/WVvB1EdwD6hiV5khaFY/0mIab+bHM9fsqxdYcLDhzNkspo9ivgDfmP7QbYzyOpRE+nDlsIILBvgFA2Mf3stT2upxw31ULs1M292moSM4cnVSotqKzLMbzagpkyZ+W/+ATIGF34askbpVjcCvAjbbLU9HdxAp6T1C/x/V79ceVdyk2KwT2LN2IiXk/QmtYDf47RFBOF2gX7MaRYYglhc0GrpTgbMf3HK9GZu+s9xWV4X7m3MtAxr5Z3sZr3QZ4UjcGhVrXP93FBxvc9SAr4NHpFEAtIwn10YA0ly9/spcCGmIE5X/yzG67WWUSooBDNqwwhl+UDVUFGqbL4S2UI+/dAIZmTkhrW7j7xLvWwFCLld+RmO/csErYW9iKbQTWK2PDPsFdiygFwpU3C70uFtvssG18gyLzmZqcEEqnr+vUje4ka4TiqkTztHNDw29EKVrv5F9J8moTuutnQvXEbJ1y6d6hT9pos59BylJGxqVhP+CBU+UfGOwqplZRYBo7EOE8ECjmivby81IOlU+ba+CIVGcLWCSn2BVet1w3wYPM7+VWipbsL4scoQ8duXiOn+rUyhvT1+vkjSnW2nbn1QctDu8wmlnoCIiUV9vYsjr+Ksc+IW55SfmsSwAT1YvtGIGuhGDKrxeLNrmqV2IKgdm6AT2IL3hU+w4PpQ2KxNh8S2eKAw2pFOl0NDqa3HqkYCUTBMCYJFSzImpW1iVV/lzBoprcSp0j9wF8q0mZJ3beHgKVHKAdSxAjUhEAx7hvm6IbHUTTStKclK/uHcvPQDuldZJJJPyy3PTbb0VAszYwM6z
 +UD5WSom
 0k7kjzAFOoZmuHmZzmYrWbXYcFmJGE6RdOlvmSHVtJZTyRzVsmzp1rHFl3kpRnFTFJU87SQhimu9hEhFtjsWWBK+d8rqprHKcmOpCQx3X1mUT5ncdCUF2udctyOs6/Fd9QluJnCSTV+ZuvhXlMDVi82UyYpnJzKDQymgeiRhtkNPpFaGFsUyTMwgPTy1MpmwrRPeFaeZt9ocpiLRlgysD7XAKd+7fLUir2uo/1gsgqkcaA2aeWBhbqbakdMVVp/i+HuTS04uM35ISW9UVFlnP/jpF+UeBEa+PH6PqlGIPSaUtAnVDttHswaiKbMGR3dBgvgLeKLWv4uac2yL8qduJjmatuhkTD4NbYTsOWTNlg/eNIO5ahsLCqdsOO+a7ofdFJqdZu7+PnHiWgeWj5CQHC/pQHAiLGesk2FL5Z+RP5bPv9WkggaFSTRR1m8IkwXfTJ4SzcaveersDclAgnQuP1gSyeRSGkNSkWmLiFYZriTu52nIlPT6QknZNABv8GVfr7Xo8Cp5Eo/p5c2EEIeWNmoY7z9NyslNtvOhnKyvgXilzUptSE1kiRJskq3660w8WwnMikIREuyikEvfBDs7gaSD7zFDYkIFx9Duii0lhC5pKjVJNUrgvkCY5/x77cqmQM+d4JFha+p4LcEuMK2RYMUM36YfbdCgp95gYqwCFbL7ATIuq9NzyXuTQTtNHmv8Fi23tcu60l+J8Sv4Qy3rGjRX4uoUZETsLmjYGOO81wzc3iex8P0uuMZyAusMAcNANmjEs62DJm8GTXO3SXh+oZxSzXwDQnmSnmYahx2K68Xtw7l0MpuNNM4Zmfph2+MKr0AYI1Df4wmSMWd7aqUIMlZkTwJDyPt1l5qQuRvnUiNdVCcLhUk2qTXIo4H+t693/koIfl0YVE3rAySkraXiuXQUaOHBN3zXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Richard,

On Fri, Nov 27, 2026 at 04:09:11PM +0800, Richard Cheng wrote:
> On Fri, Nov 27, 2026 at 01:07:40PM +0800, Srivatsa S. Bhat (Microsoft) wrote:
> > The multi-instance CPU hotplug state setup API is named as
> > cpuhp_setup_state_multi(), whereas the corresponding remove API is
> > currently named as cpuhp_remove_multi_state(). Rename the latter as
> > cpuhp_remove_state_multi() to fix the asymmetry. This also helps
> > maintain consistency in the API names by letting them share a common
> > prefix, i.e., cpuhp_setup/remove_state_*() across all the variants
> > [none|nocalls|nocalls_cpuslocked].
> > 
> > Signed-off-by: Srivatsa S. Bhat (Microsoft) <srivatsa@csail.mit.edu>
> 
> Hi Srivatsa,
> 
> Not sure whether this is really needed, it doesn't harm anything,
> but IMHO it doesn't really brings us benefit.
> 

I agree, this is not intended to be a functional change. The cleanup benefit is
on the side of the CPU hotplug core API to provide better consistency in terms
of the API naming pattern, but the current callsites that consume this API
should see no functional difference as a result of this change. The consistency
will help future callsites though!

Regards,
Srivatsa

