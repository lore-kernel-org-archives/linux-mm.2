Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C67BCCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 11:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90F88E0016; Fri, 17 Oct 2025 07:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67C58E0006; Fri, 17 Oct 2025 07:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C828E0016; Fri, 17 Oct 2025 07:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B74658E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:59:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9334B1A0156
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:59:40 +0000 (UTC)
X-FDA: 84007461720.24.32DFFBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB7A6160005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:59:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=cSItTMlZ;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760702379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JanebDxbE/kr6ucVM486lEx9oeuMHOmRkDUFLuDZlZo=;
	b=k6lMfJe6nNQTbf16Go6Uzj79iDnM8lI3hWav2Iat1GafHmIQMye4ZtpqB8MJqwF9dKJ/4X
	GjQLEaIWUgb9PsT+YeZVB0rvYI5uCr4nuucFFzO2R8SyTT1Sd2BAp3eNcoYMKZ0IwM54KX
	R3mNZXVa9Dy6kkB1c3f/OYv/XpPt1bk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760702379; a=rsa-sha256;
	cv=none;
	b=iZ1U8mzm2vOP4cRnaxriLp0KEsGXTKJYNsBay5X5Q2JwYkEI7JWtPXAy82fqSAxK3lkgHp
	yhfvF+LXOag3OV+msbohlH+ZNPJ/8yFB3IyYAJcU6lelc6cY/p/15sr50sBWwFnX4fsE41
	D3Nt73vIYyZlsZBPAgupJWGnLj5QTC0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=cSItTMlZ;
	spf=pass (imf08.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DEF60604CB;
	Fri, 17 Oct 2025 11:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3037FC4CEE7;
	Fri, 17 Oct 2025 11:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760702377;
	bh=38uFLiDTAO+A1PWpRP2bVJ1ijHpCWsegoKBcJwzF2PE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cSItTMlZ+xkWo77L3dJDjTz61eq44oatBXCgbcCC5ycxjVd62F5ZBD5t/I/P7IMAl
	 lQe+zy+uvgq1Iphq58yIzjQNmbjsJLGcQk9xMD89Oyn29Qra+kKcuYPJON2XTLg6Wc
	 Tx4/0gvLYtBA9RdvGnygRkoazMU/mLdzs1fx2bZA=
Date: Fri, 17 Oct 2025 13:59:33 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Eliav Farber <farbere@amazon.com>
Cc: stable@vger.kernel.org, linux@armlinux.org.uk, jdike@addtoit.com,
	richard@nod.at, anton.ivanov@cambridgegreys.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, tony.luck@intel.com, qiuxu.zhuo@intel.com,
	mchehab@kernel.org, james.morse@arm.com, rric@kernel.org,
	harry.wentland@amd.com, sunpeng.li@amd.com,
	alexander.deucher@amd.com, christian.koenig@amd.com,
	airlied@linux.ie, daniel@ffwll.ch, evan.quan@amd.com,
	james.qian.wang@arm.com, liviu.dudau@arm.com,
	mihail.atanassov@arm.com, brian.starkey@arm.com,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	tzimmermann@suse.de, robdclark@gmail.com, sean@poorly.run,
	jdelvare@suse.com, linux@roeck-us.net, fery@cypress.com,
	dmitry.torokhov@gmail.com, agk@redhat.com, snitzer@redhat.com,
	dm-devel@redhat.com, rajur@chelsio.com, davem@davemloft.net,
	kuba@kernel.org, peppe.cavallaro@st.com, alexandre.torgue@st.com,
	joabreu@synopsys.com, mcoquelin.stm32@gmail.com, malattia@linux.it,
	hdegoede@redhat.com, mgross@linux.intel.com,
	intel-linux-scu@intel.com, artur.paszkiewicz@intel.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	sakari.ailus@linux.intel.com, clm@fb.com, josef@toxicpanda.com,
	dsterba@suse.com, xiang@kernel.org, chao@kernel.org, jack@suse.com,
	tytso@mit.edu, adilger.kernel@dilger.ca, dushistov@mail.ru,
	luc.vanoostenryck@gmail.com, rostedt@goodmis.org, pmladek@suse.com,
	sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
	linux@rasmusvillemoes.dk, minchan@kernel.org, ngupta@vflare.org,
	akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
	yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, jmaloy@redhat.com, ying.xue@windriver.com,
	willy@infradead.org, sashal@kernel.org, ruanjinjie@huawei.com,
	David.Laight@aculab.com, herve.codina@bootlin.com, Jason@zx2c4.com,
	keescook@chromium.org, kbusch@kernel.org, nathan@kernel.org,
	bvanassche@acm.org, ndesaulniers@google.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org, linux-edac@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
	linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-staging@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-mm@kvack.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	tipc-discussion@lists.sourceforge.net,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Isabella Basso <isabbasso@riseup.net>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Sander Vanheule <sander@svanheule.net>,
	Vlastimil Babka <vbabka@suse.cz>, Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH v2 01/27 5.10.y] overflow, tracing: Define the
 is_signed_type() macro once
Message-ID: <2025101708-obtuse-ellipse-e355@gregkh>
References: <20251017090519.46992-1-farbere@amazon.com>
 <20251017090519.46992-2-farbere@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017090519.46992-2-farbere@amazon.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: 6enjg5hmkg95c1xhdr3ers7z6dpzqo1u
X-Rspam-User: 
X-Rspamd-Queue-Id: EB7A6160005
X-HE-Tag: 1760702378-539363
X-HE-Meta: U2FsdGVkX18NSYxu0d/nV1n4UI0y2eAbsLaRkicWZINzcc4TNoQEL0qS5G5dPGIOQ7h/ijROomWKt3bjyQVxptwQ8Eu3yGVkae8/vD6vSz3zkz8dprQsfSeqevpvN51agWeQk5UVlWLvukeeK/SgKhimBmxNC4dSPkbvVSaNGz/W+IWiVoHtxr2hneTBxKI6Uy4bF3XwPRH43adaytBB3WPH8QkaC8hgzKolP6UMsI9OJRK3523k/7u/1n0TkjWEQgyIm99r4hv+Z0Les+vE9+Bgor63/pKJxWSlIetvS5vCnXQV6kodJTZCOH9pECr/ZUrmNmUpToM0tU4BmAj/+GW/YxjkVJM+B9qHeAdLr54TW2WDKj1kEL5uMeH4QtsSKXb8tC8f3oQGduv5MK4lFP8MwaXSgNB6Xb6MwxKvNjvc9fpSeOJ9jqdCxftzwQ30vS8+icpY28AGXS7kx/NM2DmkmGKk4NLrXjLb8m6DHiua5HjJHJrGF7wpc6jgytJDC2uym9CauB29uv30CPAK1OfNqKbncLFE/craEb8Z1zqDAL4NKB8HBPat+72jpS1CZc04Auvc0VFCTtdmzPDUkeZlpN8YKSSW6J/bU6JaEWb7Bxuu0b4wGuYDlQG5pmzRrD7z3Ob/OeHl2R8URueFBrbUFGr2sPQTNUIy8FEr5zbUSJBCnUSy+1bA/ihsY/3Yq7F8JXnKA/9IShB0gvg6ChN5tfLWmvVT3JcQt3mZ3ati6GzMe2WuDrrNL/MtU00QYJHHeGE/0Cbk96QZurKLU5IdLPFNnZMHK3bR/wF4ZHvOyYm8QZGh+Ze1mwRudBybs8IM+IaAyxN8R/8NRivVBAlrcGE7Hz++l7RLxdI+KhRGZAJO+mzoRSUKYBZzSCCPZzPepVSlkYLg8xmNM7PZk80Pp0DY2sieVtJdYS3EfFHM7/BUQM0pUi+x60iIhn4ygRw2qZkzJkc9K1c712Y
 oEKXFojz
 IfK2Auo670KJg4dIogxE+yOkKgD3eG4q0O8tjpQtMzds8GZb6EBLwCPB1p55wKeCtacBc/kTXSetaFfexmsQJSPxoS9Pig92lrW8h+YeOZ2gdVfEwilw7boTCR/9m4FhN7vI8r7n6CA/WrUZgEuLR7r3gSxVEe4mofJ+s6e1aLnokfKAie2qsi0yzfeK7s/DR+O/41CH3Iv0OdDHSdyHEvXTbJEmgokHpWti8VGFMRYZCQzrFAENQhS789eKvoYmMac1oVLIF07HwvliKcsP7vWDmk9a5mUS4TMgrsPXomOhly95ZDk1KHYgFZb5f7npO6pAH+/Vj7DeUkdwt8/u11dsPvz+60bAva7jwQUJiIQc3QSfxPjG2/Wee0k5YZHA77vHFv/7KW2oN3q+e8lWTcAjGtbNNsbl/OQM/7Vj1oj5B7lRAUT9FIm5QADomjDZb9x8IdC8irh/48ObDU2qoVi9pPswcbJAqGJJfVEVI+2i0OsbwJ/m60QbyaIgyR381GicoMIn7yevmYgOX7YCGLFnYr7YdbrgFFCGL1zWaQuLCia37G58/H5vnezGFri5srhlagMSIM5Km+A3mD/0q19POh2XuDcDnXMrFEEwitcEDSo4EL2M11oAdiQ/w+PXAbjPER7c6HvNverxvsYYTKa00Ytc0JfxGZAb1tsPi1H6KSfDsLCVPSeSjAmmxHWomtLgbcCFHLYW9neu09eKPnCDzitceBTlkATYhmn8iAznShgZY+GCHUosJeyWo976XvPWy8QTZ6Le0+C/ovDoWnbPCwfqC5X03EzchntQ6314u9QTc4AGOsk3WhV48Uf9bu9tPqiYdJzHSIzArs5rUmv6l30786J1+boiO274jHiLOznVuXPtmRnP9LFpfmFRowESVVt0BCH49OiJjCqb79Ec4ssgO5dCF9SejXtpO9yOWhCeiOG2QkKauKX+3ch1UipqhBWVlSjp38OH7yS2+18LyUD6J
 zioBK9R4
 PW3rrcZyUncTrULV7Tdse6BciACsTdbuMLxwRYFb2ldHEaOeRR0EEPQlx3Lix8hrA/TPAU3I/4BQi2OWuDv7YrNG2huguxwKzecTIMVe5dU5Nq+o+vbBmzoEy/ZYknFzNuAsljxo8csZO+ze+gJsP0qNgIOoK66zk4D0HYN7lUlHabxcPkVC01mJbH1ReZL3CF7MM6TAl4dfHAs3mt8NxlBM2VvMx4W9PUsuLUZwOGstvNq5/zdy4GuZ1mGyo3gsbF01ypQcTe2aOD5cUrRQ0no8u0Y/Nn5c/8DFTv1yPY1/YmrToYEdkgWqj1wbYmCnB8/0kN8YuQcX6lmXq8hKsuXp2ki8hLuKwLU/hJrAesaLNpxf1DeDvifEMp289uQp0EHvSlcVe8QhSkbaG6RnxWGGjJdkCbOC9SgsXizPglc+PspwtlziZuODVGkYL05fbu1GzXHfupzPO5k6FyiE7X5MEfKxg3t1pMgCpFARU3b2ROieF5Ux1OOeUWWaykRbUDwFlDwUfAFLbol/Y4SpM8hwKT+ml/52GFvyDpt8jAxIJxUGpx/ZZFk7HlNQvaPRoNVFB7phaBZlluBGS0oNmxu2XsGx8l1Bj/OAPK9lpxjchvm9KD9Mk5rErmrPhA6rM1u6L2o0i0gW25RZo9WvnFneMvVtb47ZSIq06eQ1l46mxvDtl3C2Kf0j2aL7N+SF1iLsZDjzqYWCKiTs03oJM9047cBiB74cY2DpZWLVvVHS/Cduj3MjeYrhocw53/3BSwhhSCI2saLH0sNgAKBYndxHRMIewq9vebmpOh4z+KaxDKGgqVuDxbtz2D9pCqnnuyQRYLdOiLC7g8LK+mgR7VcCd4SX3KkqrD7h9KsNnJnpVWliPufaHZS00Ow0vJg3NxQkZi1+iAopyOkEoo6zZqifM2eOTK0AJtjRsz6ejd73tImA1JIvzaTXuSt54hiWAWOUCLUfvJ10QPNrTQcVwTEFJROts
 IvInGtol
 5OBwZWOTGqSIdXraCMaXloXjGG5QoTKwzM138Oc4KVAEi/m/DxDi58IPkG1/H1mEXmi+I8J+wjZUu1ZqCCtdcD778pWRJf8EPN4PGGLk8QmD9tpCu9/4v0fsJGXzdP33SiE0zedR16Dbip5LrK+zRx7RWYjVf7eS4CxrPSUYrFr2vjnr4saQKKG22SizKKebDbKUb2AYBcFaLhgzucb5dA1r/iETLYwsN2F+u8YeMnlvC+pYq2JSmegGiavhFXF8zEV9jyyOZ0+c4/8ZZfF8szKyaTae168Wufh9aTVKHuB1rsL/h1tRomhdxSZuAbvGgAAvigwD/VMlW3rh0tiXkHJCW2AEp8/g+tC9zK3QgZkRSWsoAC5PoJrOpvKlRr0pRdDkcqGkgWKNojRoYMkTfRFO4sjJ2Vlfwcc8DixBAHmrwELQAubH2H+vigv+U9ib5wUJ+52+IaGMt1J7tfaynv6u/6ZjDa5dQKj3ytAY+5dwQxZxD4YfVDSaptoDoVcWuPAFFwqcJy8fj31EIW1Wvu8l/lGtJN21rtAkWifm7lzZHoqNmYDtSIkFMj3F3VMdZy4PCb/fC55lExBxHgamHCauJUj/Xp1pdxE5Cwd7UlukLxGFKIorQO1cQxwhPn3puGMYDWrH4sDJTk7u1/JOUNX+bDQL9vnCuJyvfGbNhEh3KQg0cPEEBpbbHYUKFL1cNlM40hjMCFkj4OPWb2Bc5CsJAD66MkHKL8nlwsu6+5QwZ7o9JaATOuxSXmsmrp0xkf4on/P/a8UeUd6FUgBz69vL0f9EEOtx7ocgaF6tuPciw5bcSSFtIu48cybE5Cj/O/XfWHOONbKC54Wov5P9IqtULaMMKFZSYQFJpiIEWuGn7YGmBp0CtrhfKEp9FxRz7PGvkiJj4iK6RbDrXZkd2r1adfCAOaq4K36doPLYDIXIYWWw5eXR4KbubqFExZvSXQttxM0Edo9NMnsoOgEVr3V4R2PJz
 tiy4S4FX
 Jj5zBa7FfqvEIliu53hz2qlxkOwU4SLnQsGY0S8LVT/O019q/0lHKmqClYVHNqkAb2xB/IcbFwGZ2HCGMSXDFmO1Ejg/rVsLf+RU7z+UoFmVTYdmjhC0oD9qJz9uHLLQkguEgHQEJYlmU9BN0V7X7HDDHikeW7EX3zKxEHiXBCktN4hZP1GKCljkrWwB6Pnd0SlXUjy4OzSmckuQTIenHtw2dd+l1nmRiQOlI1YGfhLCYDIgZJun527Hw4K893rI6XkT2ByTDudzX0U2wzfMWzIVYLznrLQrFxxm1y6iDxJR8wQIK8FamU5p/Gp9tQysAbI+TykjAJ/Hth1l3KL9Lufd8icsFQmF6RDb2bT+TJwKlBhUt8cxT3cIeaDoGQku50iav6TI2R9mOkKqJwTlBPTZ/WDtHlyirpNok3r8XVbExMM3WkAswRDWzvoS6ta9A8FGUyqHoIm5Qe6Vq7Z9fRzD7VLBjVnucbWBrxGr4sBWqsD0wtP6g9rkvV5Flr3hlCuBbTbVit1P9Xe9TvB1HJlqaUja/O2WY7AynX+3ry1fNHZZ4sYNpFW3RKEBCW42Pj8fcEoY+L0ZpqruzRh5ANgyUEqzqZ5scpddvJ7h4xkEc5G7GQhFqioTbv3MnYLcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 09:04:53AM +0000, Eliav Farber wrote:
> From: Bart Van Assche <bvanassche@acm.org>
> 
> [ Upstream commit 92d23c6e94157739b997cacce151586a0d07bb8a ]

This isn't in 5.15.y, why is it needed in 5.10.y?

thanks,

greg k-h

