Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B019E606A329
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 07:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=O8iYprrr
Received: by kanga.kvack.org (Postfix)
	id E813C6B05B0; Fri, 27 Nov 2026 02:45:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59876B05B1; Fri, 27 Nov 2026 02:45:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6ED16B05B4; Fri, 27 Nov 2026 02:45:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A74BA6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:45:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DD07160201
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:45:46 +0000 (UTC)
X-FDA: 85480114692.05.F1ED491
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf30.hostedemail.com (Postfix) with ESMTP id 519A380007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:45:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=O8iYprrr;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf30.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795765544;
	b=LZ0RXpdk5GrXby1p9ixQNbIg1AT9WdjPkBr23TZimoEkshbhrNMuIiZV5p3H4RR5l6vAq1
	2ZEliWsy9k7Xi9xeHi+1B3/myFWrmm1ManfiN20dSFhNro1M2rjTtIsYxc0860Yo0cE6Ag
	HzB3Asl7tn0P4rM0ymDjXmG71LvXCwY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795765544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWtt4J80wKcGIrTczzzJ5vqcfxic++6ySZn4Y5POe30=;
	b=791wbHSe/nfuw7x6dVm3A+sY49IR1sV7pRXThCKiHhPyjFyo1t0x4mgbta0qpD9LTQAnSE
	f4uvO8EF2k8YXPcfJtZklraKvvuTz764VQB0ps7wFp7AHx9R9YaQ7kL1Dm9V5XaelhSqWt
	gF4K7nUO8YyXCAL7JGnD/WHpkLoY4WY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=O8iYprrr;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf30.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kWtt4J80wKcGIrTczzzJ5vqcfxic++6ySZn4Y5POe30=; t=1795765544; x=1796629544; 
	b=O8iYprrrYFxhN1v605USYPUQP4qpvBBbWwrqMAkax0zUPn7/lWNTlcXFpVRzSBYFW5oFxUD6Unc
	qCAzJMN0T/IwPyiRjbNB80ckZOaxXppmLH+GHIMPoGtYzEqWvQKPaTwArImaBxOP6JO1EG0cVX/MN
	M7/+OGop11pHi9cy0dvU6feUx6VTIT8h2XSC8qKSTTws1l0vO/wsBqTFPpP54N1xpvtwuVrtBcfGa
	MIbWgBk7kcvieHLnOoQUaqBbx2MQyqk8ciUhY30QOm3/jz2zke/1+4d6f0VlFubYGO9C2+svgXEoC
	10tZ/KGD3nJXWQgrVgz8ZuL+SZKjqPYclMsQ==;
Received: from [167.220.238.14] (helo=csail.mit.edu)
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1xWqdU-006z5N-OT;
	Fri, 27 Nov 2026 02:44:49 -0500
Date: Fri, 27 Nov 2026 13:14:17 +0530
From: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To: Jonathan Corbet <corbet@lwn.net>,
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
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Message-ID: <awk00RK93iRx3e3S@csail.mit.edu>
References: <20261127-fix-rename_cpuhp_remove_multi_state-v1-1-097db4564cbd@csail.mit.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127-fix-rename_cpuhp_remove_multi_state-v1-1-097db4564cbd@csail.mit.edu>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 519A380007
X-Stat-Signature: 75esas16qu7j6iok853thbgu9bw1diyo
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795765544-516005
X-HE-Meta: U2FsdGVkX192nByieG+XtutYohEdCUsxVeZJKyqVrNqwm27dy3KZtQtg+2BLe1e7pgTH52DYfGg4VUIUXwLBpnCSK+sDIO8N6SGsZ/JLXhthpBXEl3LXk8USFolSBKfeulxoTGU9SiOhLKQpAIjdB0z5P/hkCp6jUdFlMu65yxh6Ij/X9UzOVOihpanp1mLdx0NJLkVR6uX9Wci+7RpSl5peAZ7IYZrvaBT6ia5xdQ/6dbjxULDo/d+Z2iGSK28SCSmikiWWDPq80Bkt5de+00HTdgJDwuHJEjw+rdqRxqHic3lylsSk/kvhqYeIP0iSxImKuDjDwWCIcg2decywFzGffWWypP0tnY7pQzfUmHtXL6rBTcv7WpuSFfPKdfOgHxOUnIB0JldApGP54mRCM3csxWLZ+zY3F0dHkzv+hX8BVOp/uiuBqO3iIugjaZsj3LPdQIVgr32GUl0GSmr83BO7FPhiNjk0tYD8e3tWx/z4p3zuv3s5FNPe/gbEDUa2lk7k9kUvPnzGITSLfI8X4Nkp6NkG5Uy15GGpS4vdmCxicOzVLcmTJPKJJRhnCYQ3Hdjv2VmcgTSMTeQ2N/e7kAW0NMvI8uEpR83DRrTMa5rFDIFjssZ+ZtyflR7cPFTI+/PyvAQ2yCO1DSYaKh0xuGU5oEO/mmfdisanKEspLiVHC03aCicZN1YZ30xrCOh7N/MbtcYQdpqXuf4zz06Y6dUiDpIfovBpzn5td4FjAfZ9Y0kmvc7OSSdW5Wcg3s2RVIDxPINvcSCRjbaXItKJ/0UDQPC2pXAHdsWuzgxLl4mNYQNHQOdmhpDHsdWnw/j/Clu3kZkE69M0DQeLO6yNr/52/VQJFw/5ifOcIeYD6EJmL/7IVgPaULKExvgU/ZuHTogT38sWnndCeSpLoqpjY+UYZHZitAgpR0rwYxNAYA8jQPa0RZwBf0/7T1fKj+9Vw5s4pqTuGcBebr+t8S6
 FJ34W7OX
 UJ6tE9wcSYJxmsg+ftXBEhyX8UTC0y999LkdDwjHNzAq5L+TREXTAZGGTtMpyEQz5E/COX48sUZ8dK4eNcc7QTq7iunN84hKCuqwW/ZJYtrvv0ZnKadymiOxsLkPwK35IsWuClSpLZJx8uvcM8IdcT8O+AqnY/YDm6lSwEEQQJi08C/JjcwMSaascMzd9Ah03DGtUHd9FXYLfh740loNd5dqz3MCQh72GQITAvLZLIn6X5/ooxjRIzxsDLiyLviZYSUmcWm07ope7g3QyxqYUeb1om/3DkNnY28szIaJpr7o2XM0ZQxtvbHim3sUJeW80KsK7TNUctqOjZfzEzqq5EZZnnUydb3qDVICH++QO+4fRlBYLbV5ssbLpW+5cWRqBfqn9BGoPjt5rSUlY8xbL6iqC8KxBDkQUfdgC0LGnVjRgkJV4BT5cFnNOUWQPX6rr0Y61P0KkL68Jin2txQc7KMPOWNtRnNPD0WMOEPIueGr16xd7GVTvZ8VdTPXKQ8hjl+L1OP1VFJCvNj9VaB7/ZdjhOF09NqRE1wGicQLj4KNg+W8alfDu7nkgvCBqWTrP6P6qMEgude8E0Ol+6MHF0ZZvNfT71tKOhe2KnamlULPvILL3s7SJAGaJzA2Om68AVczg/e9e43q8Rt7P5qTqLb5KGiGr3TfL+X4PQVg4yVaE93Tl2noDAfsFxqoWYm79XdOIq/8C9Tkm10PeByizDGxNgiknRlSMy2QFqU3kMb4LZQeusU5VWQ5sfF19ZzMQjsYLbJt21PH1ggmzhoC7jGJuoZ4hfgQv/9+Ll+jrqxj7u+g/xPbE8rKHMfw//SmhDU0oc2XdTkXg9aSZbuvjhzOotU+ASETz1L2muUo/QKzPy5TltCKJfPuWpsUQmFp/iu+Z3ayxEiSNAR9suOhOTGPPDSdZkfLTUdRSA+NAPVsKRTKWQKcZI64KZSxA9VMEyAIv8fdf13N1nUVHvZr+pIOLkQia
 9dMPWQFz
 Iwfj4T9XG8/k/exuEJuSmdtIn2ZdNDNH5OQOo0GJDvh+TA00RaazCRD3/kFtfqTCh9DEd6JgRtMeAEhJH4hgNpnmmtb6lsR1kvXezzSfKYicNkB/mMbBDk1tLH/2WBX0HTbr9XVewMlyl8GG4e5O1vR8gxFwE2Uw/xRPW8ZIZMAhGandehLXxbwEGcoU5jqEiSvZ+ATDGk4QjFwppLmXM/4Dx4gk2Uowl2PDduls0yL3kD4p6OB8k5s3iTTqNzODaC6nabDeSgdqsRtXfsLWMoeZV0DYQZ1NnNOvt3uDL79wo0ECNy+93An5VHO64shvjtuOyA6cxmXugNp2hrEE9YOI4tDNotQTNAFOPbx/5NewLq+pf8ZdIDsWKl3bAkB1ZOo1l4g1jjXRoQhfy2hU0JPcJn93pNPIRrcCEgCo7FPT9L7DcnbOHYc40lJwJnya0qzgIWsxMN7pXL5iL9rnNHTn09TRtpiJCKxbJ8vIqGqprjD4W0XqZQ619LAjPcORqz07Lc2FP2nqIawhYFEp1SoUIUaQl3rKrbvOGoOpie6F89LXP+QYatOe0zDSOPvPAgCvEQqpON9MfWy0OYGffjSI+k+I7PAVdjUPkMqFvLcw70O7iGjTCDIw89dWSxrOtXEN9CFC5k7B4Bsoqjrb8ckYLYP2xDVs4te2Urk2+EpTnwu3ejx+gKb4s+XGvBtFhJ5LBQzKKMHvdnY/Yv61fLdFxLXPS46U88nNpO8bIzJr4AqTp2KkemL7ZDjufRK202TmsTSCJVtNJuPY2ju6AoZnLMr+H1/rR5gEmjnGy0chtm6Q6EWmPIUJDDTA3ZMlseNLSy/kBzZR4Zd3+/yF8jPBPjpRQOqZE2J9XmKh9NZWNK270UmaaopDNMHcC3dKPISNPBkSnavRTcn8e6S6Nz5whKFRoTw5sf59CUd11pflcuK39Bs2u/09HUtqIQIuyRI6unZY7clkdftXVYNnLlgUZp5uI
 OuO2+R6D
 J9dpVpuo3PWP7Dl260lTpmbbSnXRGaRnSEHhtOY+W/bVVPpX457Q41gcvBuVFN+vdt9XBlJfqF0x/NBBJ5wmpgYDC2Mba37pc+kM1maS7dc/dBbZQOWLMApsLP0YoEDunHiKMapIx4OBu/YE5KNgVPZaivCIhVLaMl6RyURNmyFlFVeatt2Y2n8f5K6xOfggeCvrk5R9uE1kc20VubWqspo+/6suHkcUo6orC1fsqcLEVVKmp6IvBlHo1jzQkXg3pryUE7kxtPmkECgonWF3i36ECtRj1MIFCvDrSlKWPuzRRLYnArpgpkkSxptupkxu2Vb2rU/Rt/rCBzFZFoDMfiYepr084LNFfs9f0/p7rXR5/q1Y+Yv++cwXz5MdQ7mI1SrIYnggeclgsiUlDvOq3cWUZwMAGKf6MQORW3Tx3R4YrXgeUBRn4HeqwrOI9QvYxzs7YEJaiU8/CBCfy1/74huiaisf7kzjlsyvT53F11Dmu+FtBx/iEszeJqLI49DEAuuoXHh1J6F+JmarjUz6ACmIh8PT+c1CnVtO/ftDPR3bG9ENEAcMy1vu1ZAJWx/q5o0hYnGv4jWtiF8PVfbDXi1Xpq4pBgEIQxj0F0veKLt7zjTkLQ3F7SUF5LuK3VAT9G/TyiLlGXEz0ETUS2lC+rTYtQ5nLbuE84YaY7NvI7gNLAgq85F/Z1IJ0Oby3eyPWKowzJlLtA3D44XwkMIzrDG3A4zcXuCVDlIL30PuNYk61ewFjKfxXO/LiuJA/8HBnZEONYT7IyigAMtk4duC+0IBWhhsbNv+GGatlvSvstFW8nPycBRtgdzfb9GnXyg70GGlZb+5iW38OczCkZA5ZMVBlyhOskXnFM8fsl1lT9mqDApyRL1mUOEd7Sh7bQ79QEfUZ7Dfotso8N1OsEt4tdXIygXGPhEERrvnvVJ/qQX9tdo6BAQXwNSfI0dfU9oZAygvFJvkTK6iaPdfsIlQPg1JbjKGu
 oxgmZEj2
 3n9sUNCvgCwvB3mwl53xd8cvPhLjoLzBcMmFUMDZXHVkmAixJwqmccUqCu/9VR30Oczy7raSxYReF7nLguVxWJWgU2jWj/JJXWB5Niz59W3GjWyzaZYX8WJgZsJ0vS0jCBGEFETxIEfUNU4Ag9UMNjnpXByoCMjdn97B73poAzzC5IYBe7cv+uC8mQg4GU6XLPC/I/4RGgkdmfSZxv28Lku2sQ5SO1k+tuGF61zoHuKEBySBljbcuIiZGATUGiuEVQMgn9dAjZ5Ns6Z/uU1gSLkYXZBrdhBZSauRDC4azJyVOcdX1cKbMxBX9lECd7WJG3ie5oZD/lu+mJoAoJzg+9MqfewKTdErTWoXXoAGqQL78OWij6hB7xwStMu4/GZhS+SlYEKXy7wUt+oH+6kBAmexA7OJvzSDdAE8+odm6D0htVVFgfipaAZwixQEGA5XrzdF1JOu71YEhDdCYBpCHTZTJPgMaFDjNkIyL/uAN6r8yKI4FK8w0Fi2udbMFnGKf6RZz0AUCSpIZADNX9rHIIYIc/l2XRqkiHbF86FOjUtpxgrXuNF3329WMHVbTNd05+ndDpEDM3J87Mga5s7X6udTbBtm7eY5RD1cDo4+HB3xZfzxXgnevRCqPUFE4zrnfW5kuNa/dnMnNlPgk88qgeVfO9CA/wBSE4u70nwuoFYi4JzPGaeJc/V+51+z/7m3EAeJCZkM6fwb0ay9ERZ61SG37pSlHx+0BZVzK16grc0F4z0c+vNfzul9/idOPkncYHcqQeYm4dEZ+UPmcqSHFd+PEN2U3XYSnnL+zgCzx17y9l74ade67d1zQiTvrRYKsas5Y5ewDxdaGgsP62SHFzMzeVoL9KL2ModXa56BZIxWNuZIP/MmMvP/JVUMHm196auaAsGU/FhvBLZ2oaX21GszdE3xiEmOC5rX1q0LmzfcX/3/YgqbST
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 01:07:40PM +0530, Srivatsa S. Bhat wrote:
> The multi-instance CPU hotplug state setup API is named as
> cpuhp_setup_state_multi(), whereas the corresponding remove API is
> currently named as cpuhp_remove_multi_state(). Rename the latter as
> cpuhp_remove_state_multi() to fix the asymmetry. This also helps
> maintain consistency in the API names by letting them share a common
> prefix, i.e., cpuhp_setup/remove_state_*() across all the variants
> [none|nocalls|nocalls_cpuslocked].
> 

I think the prefix in the patch title should have been "treewide:" instead of
"cpu/hotplug" given that it does a treewide-sweep to perform the rename.

I can do that in a v2 later if there are other any other comments/suggestions to
address as well.

Thank you!

>  Documentation/core-api/cpu_hotplug.rst       | 6 +++---
>  drivers/block/zram/zram_drv.c                | 6 +++---
>  drivers/devfreq/event/rockchip-dfi.c         | 2 +-
>  drivers/fpga/dfl-fme-perf.c                  | 4 ++--
>  drivers/hwtracing/coresight/coresight-trbe.c | 4 ++--
>  drivers/hwtracing/ptt/hisi_ptt.c             | 4 ++--
>  drivers/iommu/iova.c                         | 2 +-
>  drivers/md/raid5.c                           | 4 ++--
>  drivers/net/ethernet/ibm/ibmvnic.c           | 8 ++++----
>  drivers/net/ethernet/marvell/mvneta.c        | 8 ++++----
>  drivers/net/virtio_net.c                     | 8 ++++----
>  drivers/nvdimm/nd_perf.c                     | 6 +++---
>  drivers/perf/alibaba_uncore_drw_pmu.c        | 4 ++--
>  drivers/perf/arm-ccn.c                       | 4 ++--
>  drivers/perf/arm-cmn.c                       | 4 ++--
>  drivers/perf/arm-ni.c                        | 4 ++--
>  drivers/perf/arm_cspmu/arm_cspmu.c           | 2 +-
>  drivers/perf/arm_dmc620_pmu.c                | 4 ++--
>  drivers/perf/arm_dsu_pmu.c                   | 4 ++--
>  drivers/perf/arm_smmuv3_pmu.c                | 4 ++--
>  drivers/perf/arm_spe_pmu.c                   | 4 ++--
>  drivers/perf/cxl_pmu.c                       | 4 ++--
>  drivers/perf/dwc_pcie_pmu.c                  | 4 ++--
>  drivers/perf/fsl_imx8_ddr_perf.c             | 4 ++--
>  drivers/perf/fsl_imx9_ddr_perf.c             | 4 ++--
>  drivers/perf/fujitsu_uncore_pmu.c            | 4 ++--
>  drivers/perf/hisilicon/hisi_pcie_pmu.c       | 4 ++--
>  drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c | 4 ++--
>  drivers/perf/hisilicon/hisi_uncore_pmu.c     | 2 +-
>  drivers/perf/hisilicon/hns3_pmu.c            | 4 ++--
>  drivers/perf/marvell_cn10k_ddr_pmu.c         | 4 ++--
>  drivers/perf/marvell_cn10k_tad_pmu.c         | 4 ++--
>  drivers/perf/marvell_pem_pmu.c               | 4 ++--
>  drivers/perf/nvidia_t410_c2c_pmu.c           | 2 +-
>  drivers/perf/nvidia_t410_cmem_latency_pmu.c  | 2 +-
>  drivers/perf/thunderx2_pmu.c                 | 4 ++--
>  drivers/scsi/lpfc/lpfc_init.c                | 4 ++--
>  include/linux/cpuhotplug.h                   | 4 ++--
>  kernel/padata.c                              | 2 +-
>  kernel/trace/trace.c                         | 2 +-
>  mm/zswap.c                                   | 2 +-
>  41 files changed, 82 insertions(+), 82 deletions(-)
> 

Regards,
Srivatsa

