Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E4A4CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 13:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF1A8E0028; Mon, 29 Sep 2025 09:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568F28E0002; Mon, 29 Sep 2025 09:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457C98E0028; Mon, 29 Sep 2025 09:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DFA38E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:50:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC6B8B90DE
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:50:02 +0000 (UTC)
X-FDA: 83942421444.18.331D59F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E9D3A0005
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:50:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="2IR/w1Nh";
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759153801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7P7vMN0Ar+JMc/jW5ng/Nk6H4Fc4OXsm3Ytfdh2J/g=;
	b=G4Yh+kq3A80ly7ddFMDPXtpskK5V3/U4Kbb/rzbUwAkHNMM0c0NCqhxXzZsLpO2V5397J6
	bdW+7e4QDZeXj3NHmlubORtzBmcO0r3dZsoWaX5rA2JWXgKn6weEXcMElKqhbKdSZ/i7MY
	7BBdqV6cueMD3mLwmgCXcZJj3NAldI4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="2IR/w1Nh";
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759153801; a=rsa-sha256;
	cv=none;
	b=jW9OpKMKV4gw3V0ATmUI0xdmctNRsdYYa6CM+FvE9mbvnLq/Ph+1kLZtpR5czNDECWvhB1
	Oa4nLT8DY/1iyixASTO0Ww/Db3zfBcuAlw/i4Azkd9QiylGa4R4SXGNO1Icx6BYZaYnkKa
	9+if6uMh/ytGHy8ImU3ESGhyiuMfbPA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 663EC62508;
	Mon, 29 Sep 2025 13:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F31BC4CEF7;
	Mon, 29 Sep 2025 13:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759153800;
	bh=ZP+96JhjkkrBnIK+mwXVIYMy7g62X4hPExrb6o1Qe/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2IR/w1NhD6rO3VZzjaHsa/G5y5Y6EFTRaRCQoBFOIMmzFRk3gM0W0Mf+I/1sje/zM
	 6eTkAuMiRzcWzHrNhmk6po9GpoWWRMGPau/mhN/FLC8qEKMftJ9tX/aLdXfc1Agx/E
	 GgRNIXRtdpmNbgceNNbtDpd4ehAmTPd7HqANSrhw=
Date: Mon, 29 Sep 2025 15:49:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Eliav Farber <farbere@amazon.com>
Cc: linux@armlinux.org.uk, richard@nod.at, anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	tony.luck@intel.com, qiuxu.zhuo@intel.com, mchehab@kernel.org,
	james.morse@arm.com, rric@kernel.org, harry.wentland@amd.com,
	sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
	alexander.deucher@amd.com, christian.koenig@amd.com,
	Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
	evan.quan@amd.com, james.qian.wang@arm.com, liviu.dudau@arm.com,
	mihail.atanassov@arm.com, brian.starkey@arm.com,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	tzimmermann@suse.de, robdclark@gmail.com, quic_abhinavk@quicinc.com,
	dmitry.baryshkov@linaro.org, sean@poorly.run, jdelvare@suse.com,
	linux@roeck-us.net, linus.walleij@linaro.org,
	dmitry.torokhov@gmail.com, maz@kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org, agk@redhat.com,
	snitzer@kernel.org, dm-devel@redhat.com, rajur@chelsio.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, peppe.cavallaro@st.com,
	alexandre.torgue@foss.st.com, joabreu@synopsys.com,
	mcoquelin.stm32@gmail.com, krzysztof.kozlowski@linaro.org,
	malattia@linux.it, hdegoede@redhat.com, markgross@kernel.org,
	artur.paszkiewicz@intel.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, sakari.ailus@linux.intel.com,
	fei1.li@intel.com, clm@fb.com, josef@toxicpanda.com,
	dsterba@suse.com, jack@suse.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, dushistov@mail.ru,
	luc.vanoostenryck@gmail.com, rostedt@goodmis.org,
	mhiramat@kernel.org, pmladek@suse.com, senozhatsky@chromium.org,
	andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
	minchan@kernel.org, ngupta@vflare.org, akpm@linux-foundation.org,
	yoshfuji@linux-ipv6.org, dsahern@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de, jmaloy@redhat.com,
	ying.xue@windriver.com, andrii@kernel.org, mykolal@fb.com,
	ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
	jolsa@kernel.org, shuah@kernel.org, keescook@chromium.org,
	wad@chromium.org, willy@infradead.org, sashal@kernel.org,
	ruanjinjie@huawei.com, quic_akhilpo@quicinc.com,
	David.Laight@aculab.com, herve.codina@bootlin.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org, linux-edac@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
	linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
	linux-sunxi@lists.linux.dev, linux-media@vger.kernel.org,
	netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
	platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-staging@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-sparse@vger.kernel.org,
	linux-mm@kvack.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, tipc-discussion@lists.sourceforge.net,
	bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH 07/19 v6.1.y] minmax: make generic MIN() and MAX() macros
 available everywhere
Message-ID: <2025092923-stove-rule-a00f@gregkh>
References: <20250924202320.32333-1-farbere@amazon.com>
 <20250924202320.32333-8-farbere@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924202320.32333-8-farbere@amazon.com>
X-Stat-Signature: b9o8wksqqw1qpfjfjwwsbgiitco5di13
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E9D3A0005
X-Rspamd-Server: rspam04
X-HE-Tag: 1759153800-336351
X-HE-Meta: U2FsdGVkX1+OQ3713S7A9xfQ9/IwFpJQtNT9CWYjkTi6NrP/yt0cj+nxESQ596kX5dvvNyEQJ+kvh6csApwtlKjvid0ipWmZkskV/C6FDZ+l5WgELX/SsRqJA5EGCEDypdZHOBwP7RBXLAjc/zPsGAbcNq6Cn/3wlmsUqFI87GCr4Sy0Ru/ksF+/YrOJdyPR5P/S8io9A1eD7NVhLvSau7XSniJvRd24Ik9UiEA1u28MQNdJOKH/orB/jSvC60lXoj3GvH90l7G09HhNJp+ST12kt+sldOiCCaA/9MTMNI9d7rtwMFcqMX573nXUaapAizz/uqBIbRPmKvKBrjjyhfXcCST9dMoV2GPlKNCXupWj/Gb/6QHs8VEWfH3zURKI5SQBtZWTk1nRM18RhOWeJ096mhvmuEVgUhqjigP1/FN/LbKCuhDccawOHKp/osZgPnQiQzJ/sHEMVjEQ23zUXk4uwE1OI4cykboiPM7bxNqOTlI9c/ucJqLE8B95YwLwQyI3jpo0NG/IuJUvR13yR1lpqI5h9WZC2TyuPvFA/PYQWkrziVRO22pfQYx3fvgvALgYZPyUPW3I/oWr+JVmu6yteVu1KtBG/Q96vnao9euydNSMWD4foT1+gnb5+lAb1zEQ6X1DT9HBV5g6/rXG+eei4ndv+dpmQrLyK0Fk1VMHPLgApPcqSiZsQ/AcAj8J3ojDQxQPO/iXtugSR61PWmGAuqfBm7+vPFU4F7nQsH7Ic5v+l6sMZEfF8x/Ps3rYD9h4lsc9miMi8eMSFMrkwxrXvF/an5Udq+qDs03Q7TG6WW3Sq7PciSaz5AdnZ4V9j0TvtxEL52BKeskrkp8Fy61JvH0JnPk1LDDapw4XLBBZTXaTqyCmQyh5KDx0ctqLLMS2ErhHwiB51zwJPHUcjRXYJzwIutteJf+AYh0655dmt8r04nOfagEAJog8UCHSXKTuACZX39RndC/MGBi
 p8GrvqNr
 OKLRAySUetClyFxHHx9zuufTlE7ZA8a1walNXqV2BuctwDSPPpI8z8W+glRdEl2tr178vEBsEjphJW13NomkTTRocszv1TkbzJlQlx2+cPMsCt+UjhBKUwF5823xfLzf+G8P11tp5E83QQJFwLXcPSwofjmun+dNN7felsqV0R9OyqZmBc9L9Eu8omaKxzFWbOoklL0HbAyOme0ZAuv+3o+Gf/TA0/qI9ln3js9xMJ3GMTUpnH8nrxvdJulA6JUWmJyFALjzoo3e7IWtUTsGMt/U7ZC5bQ6tPnhk67IFlYGDoNKR544EMrTmHe2BDnTlnUxJ4z6KUbFCye0Qewe2mw4FcI5ceNDJOKkAYfk9hNPoBNJD3cw3vjsTfBjHakrOLFeYf3nz7YFAlO8S6F78TBEOnX9gU8W8IT/3VF2n2jwUHVR6DnBSAqHBL2Z49vGv/op6OIq8mBGRYATyYB1LXANOBGEN+oc24m5EFINTxd23nqPz1pp0ZWU4za0Q7fo1Ju0Tps25Aotpcv9KuV69uEeejL+166mUEHKOgwvl7gKxfM009WlZf9EMlVRw8rUp+jaIz9qxkCPN8pfMM9+ASqeYI8GJhCH8z7MLVugPcu/z3C6s7lxX9WiyXFYKjU6L0r/c6Htda/+K/zLeSUheKPPcgs32PwTBX4hQAnjed4Y5RXbDVzrrfyvDV1W1fhI+H8Zh90jpuxxoCDU2gdPTVO+WndmeiVTL+6OhLMxaadkf4e2pwvNb9m08VBOJ29+R42HO62DD30f7cAHgOoBgdQkMafn0sBdOIN8RPxZVuorlLIbQbKVxrLCnSNyZeVroI6R4qdea4IRYtWz5y7oovrvvgO8Wz/sMkrBZXCC9f9/U+JxdmEil8Zi4zR9go4Qhmpe9WcbisCMFsxvg1iv/8WOpAwO4ysyc/sMWS4CnL1sM4Z02Pzixdq4AVtH1hiGcLR8dW1LDjt1V7Jm6X5N9MIYu7eRuq
 6K9U4DRf
 +/R2hD00vnfUjlfouIHl6ul9zSb7DV95FsE+b8vj1tZZFJ+rogpkW9NU++eT5b6Bk7oFmYiX9KGBg4thkVHYNh8+9zG4XRMK1AyGn9ic7BDozpAJAxVupErHm35mR6/6WSXavFwLv9448fuAyv2fr4Cm2u9/go0fpwadFzdnf3l4kho8zrCIT33vcnDkbw4nDYmHmmHG36vTqn6MaZLdBedZY6Hg1HDJmmkrcQ/EtVSsbWw1bdAIYoBtKvhWTBcGoYQEytKSQBk2klxPW3WcwiTclqgBGCutKzBQw9Ex6MXzntJu/mGLFtqfB3c64DJH5BJF/DSL+d3gieuYCYtqnS5w1gqqCFW7s1wRCb9WwKZTy3+MKtOcpI6MihsMiqZS7eFxDC57hvp2eVwNpZq9Q1YroMoOQSrpEUmbbF8jpgVpNAwXhSEJHT47kl2etKcoSsSBnHHEyKvWsQLbRxB+JXbbhqHQ92tFRoRSPqIMoaIKiOb8xUIG5fAPuUuYmSWte4Sszw6f83IItr53hlzl4p20uxVpEy9PMYFQDHvaTL23oKgI5O+kvMbvPaDaKnzgLXowAij7VhG84/IhfUZ7LMsAlxor6FTgRHCQGzIq/XZ1ydDrbVNC6uVzlGlp8gaENrtLSFOTnUm8ShuHU5X7877X4AUQV4lJ/1k/byrQXS5YRyyiAK+g0VQqzJYVCXKzxRhr595y5CIPFbP9P7wv27I18rCnH5F8zXd9GIN5tLRC9TnEyIv3I4vH2FCPyg5TjuQk35CCgOOLDBAAjtDXk6KwyrYwe1HBK8eQvv8VbGT5LJoSuAxqg9euagX5h3ugMOKYpJ8ugiZGOQhDCE84A6baftkOkmkwz05xUNJ4a1WpyW77GIHGtttnkB7P33rqfOQzikLzLvnttzJOaJRtkqsn7Cczhji+WUGBcoLnxxcJIGFEC4ZC9Kp2tATIbt8iARp+G+uqb+lkjrAegxjNE8lP95/3K
 6OMCHJau
 HQD0QNUd1DsIsjhZAJwmXKU+XVKROFilmE+CVrV9XabCBIoUw+Ym1maFsZfQajnzgwjBopFs/73TgQ9CQc2NhrJztdI4iQTUF4M4h7HPMLpr9OTt5TXmQ3B8pE8u3ew/afkv1c3qsekC0gBn1FFpwdIch4Elf1i3HQfTA7TaTIfEIUzyDuT8pjGDKvloubgIZiuCiMFoQMQKUERYoXTWLZ/fJHjE+JVWK7QusD8O869Kz7BH/5ZPfSN9LVm2bVzxDPyBRY1IQDb1ZDBUdmuCVrTPbzSXy//kAArQeH0t75oIV4CM9SJAmIqDaX59HRFLP7QKH1DNzqBCYG/FRciaRBOFrBaehW6K0kgqYq125MmVKs7v2IiTozInNdASxTQeSreHgNrr+KSlQ4VYVYgJVNjXlyxUMcJvdAr0p2lMtdwfsXLsisSku0HWLUx8UM0YlQEpnnXb0KR6as5c6GnqvIj9unj3EjQWR1tzRqPVpENcsmyF9weErJOqWEjaQgvxdXzIIGd5HX818W6w8p7svC0QVtTcr8XxWPfCq1W1YavTwKYwOd4NRuqNMpVq1AX4b7XxYKW6FdsUNHMhwtcbIC0zewMB2ba4/b9sya2oOXOmRZB8gCBvBB0dJ36LaAUrNDuWlXve6aUXEzf/GKYuqrsaIfl1I/pDzWtAGfaQynJhQOquBxVEBNWPkjwzpEnDJ4V850xM6Iur4OBCDYX7E2wEBRZGXZd4r4LM/TorPfH+eVZvwUlYwNrWUeSIH8Uh+c2TLnvu7sCubXLvZITcxmGvkxv4ZgmM1FmQotGDCTYbLyWQppvnB+ubfZ8syuvlvVh2PXxjXF3SDXFtB5LkFuu4EMMTo5WTWjQm/Um8cuq//RbRALNhsmi1IZHhVMnkOKa9X5xvDY/niefCc3NS3wyRNPJFNru3dn8fFI5b7T8tD4JBPke0b9mVaVCy/zsJEvnSGehRNyMCW3KVNMPa88BbFdXc1
 TjbG68Vz
 Sa/9VQoki+CqMDYI2Jf2R7reifSlZ30jT2Wt+oN5RRBBS3Crnscq2z8Oa1OY7Hp8yA9sj75dU98YbRlmpiA2y9wdeVRD7+eIkqchknZmWNHOLFjzrjhegjDmZmDPqpRcDlcPa7pT4Jej6AnZaf3PQXG9etz9j2tjmauzK5rGSrj+opWSRLRc7Xtf6mUAgNZT1OHk+C8zMlRFwP//KtlTx8eXbTdcfCXInYipcfee2kB27c2v7nipJQbMkTZ3GD4RWx53bWq7jyzEnMQZecF8V9EGH0TkTksaw/JW7och5yE8hrXSyU0KzKT1V27VdCRo9bIOMwOhSaN6QLxHcOSOflv5vMmB8f5i1GjIURI+lo3Y46SulE/zAyrL5wEc+gVt3qcnWkkGk2ZPoV9uCaf81LCl5G+vjh6WS593Ys03R2c/6QfE8z57PvUpLQtn0lfu5lpWb0b3B2NX4yZt6cjColgfaJ+ZnttPE5oWrw8MVjlqygY9M3Ut5WlTbGSmQ3hoIXDmzk+ZZoeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 08:23:08PM +0000, Eliav Farber wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> [ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]

<snip>

As this didn't go into 6.6.y yet, I'll stop here on this series for now.
Please fix up for newer kernels first and then resend these.

thanks,

greg k-h

