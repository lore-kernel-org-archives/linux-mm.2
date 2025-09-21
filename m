Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B718CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 17:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485B88E0005; Sun, 21 Sep 2025 13:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436168E0001; Sun, 21 Sep 2025 13:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B7B8E0005; Sun, 21 Sep 2025 13:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE0E8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 13:28:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B32881A02F7
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 17:28:50 +0000 (UTC)
X-FDA: 83913942420.22.11DE170
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 046E440004
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 17:28:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=oNji14LK;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758475729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBPqvNFiwkKgijISpeeAo0RvLJMFkjxb+cTy38dnT2Q=;
	b=tbHSsIBMf3ci8dSOmwydDkNGyhXOSCoeVCPnGjeJ5UFdE/BWpkn4mlNnpCAPWKfgbBE+1e
	c79VPhAc5iJsxgRXKK67N07T7v5CPZnaRqZ5yKIMwQSaQP4yD/DGDXoBwqLy2Ww9zag9uK
	jbN0aEJAbIh4BUnjaK8gCgbLUiRDLBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758475729; a=rsa-sha256;
	cv=none;
	b=c9FVJrj7qpKFXHu3Pjj3cA7rd2BSCsDj1J3JuIVrt6Z8xAg3UB+TQXGsu58ayKBvvKL6QR
	hxEl5Q/1w6w1FLlNrl/40JwqYxBhW57VXW9znxLVvgu9RlV7qBk7iqCB9zmAHLULSsQ66/
	bL3xUgJnMV2l2EhlLOvv4RLZn3mSjJo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=oNji14LK;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B6386013B;
	Sun, 21 Sep 2025 17:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22692C4CEE7;
	Sun, 21 Sep 2025 17:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758475727;
	bh=OhAKhAi+AnzI3Qc3qjl3chOvflGQ1Z6G7nQKCQgIA6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oNji14LKsaN74d6/6VxXQLAaEWqiMK1odhhlWG54PmdesR086HbzOQPsvLp4l8W8h
	 erd/geKCs7blyB1imhKlNfDZtIHl2vwbNw8z3TSYAfWxPI4STRspwkbfLQuyq+0pRc
	 wfxpVS7OtRaNl868jtRKMkgfZDW20Ck1f7t2BQsw=
Date: Sun, 21 Sep 2025 19:28:44 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Eliav Farber <farbere@amazon.com>
Cc: linux@armlinux.org.uk, jdike@addtoit.com, richard@nod.at,
	anton.ivanov@cambridgegreys.com, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	tony.luck@intel.com, qiuxu.zhuo@intel.com, mchehab@kernel.org,
	james.morse@arm.com, rric@kernel.org, harry.wentland@amd.com,
	sunpeng.li@amd.com, alexander.deucher@amd.com,
	christian.koenig@amd.com, airlied@linux.ie, daniel@ffwll.ch,
	evan.quan@amd.com, james.qian.wang@arm.com, liviu.dudau@arm.com,
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
	dsterba@suse.com, jack@suse.com, tytso@mit.edu,
	adilger.kernel@dilger.ca, dushistov@mail.ru,
	luc.vanoostenryck@gmail.com, rostedt@goodmis.org, pmladek@suse.com,
	sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
	linux@rasmusvillemoes.dk, minchan@kernel.org, ngupta@vflare.org,
	akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
	yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, jmaloy@redhat.com, ying.xue@windriver.com,
	willy@infradead.org, sashal@kernel.org, ruanjinjie@huawei.com,
	David.Laight@aculab.com, herve.codina@bootlin.com, Jason@zx2c4.com,
	bvanassche@acm.org, keescook@chromium.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org, linux-edac@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
	linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-staging@lists.linux.dev, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-sparse@vger.kernel.org,
	linux-mm@kvack.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, tipc-discussion@lists.sourceforge.net,
	stable@vger.kernel.org, jonnyc@amazon.com
Subject: Re: [PATCH 00/27 5.10.y] Backport minmax.h updates from v6.17-rc6
Message-ID: <2025092136-unelected-skirt-d91d@gregkh>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
X-Stat-Signature: 3yhszj9wds7nihxk18a575oqcuhrdhk5
X-Rspamd-Queue-Id: 046E440004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758475728-740864
X-HE-Meta: U2FsdGVkX18uuB6OaE2sH5vK1Q8icVHvLcUpuDdaq1S/FEqerRzNYytT03Ju/SaaCO2oO0Pt17Q+O4bFguRLqbRlUaAdrsdRIttKOQQlOzrZINtZtGuctcRhc1IwNuBDJddI4ceH5fP4Voyuq4Ejt7DZmujo7SzZJey2TMhAZKaLWMgFjTD10I/G7XbpoVBcYtQYDbaDVhUugdqhQwz/m7kThZ41BYsx8p52lqDzti7vVu0p1gWam+71gMcFuNP6ccVrt/i7ZDuKYbVJ9QP2WxZqeiRnVKVlyhC55+XlZS9i90TVoztCcv4cSrBKzcGwBiFu/T5pXEOC73SwjiGVZ2loa+ya2PrpM2A+qbqgyO/rpo1BbKMoXMcp9p76j+W+FSCovgNgHHhGH+diEfR/UXYcrw/Gci8FeVqxvnJGIV9eXTQMv6gTgCeTHwN/v4a1iuBUYQnm2IZYy1+SRjuqwjxGX4uVGoAc1swoPTMw0qpYhxCq5sfU36m5fXrkvIMCwFZ0g5Kz3k4NVWxbcOKmOKX2nx4ObQZ7NfhTIuduXwST6i07wxJCNPTujFKfgVeL0idTOtMllO9mtJ6v8DGgExlM1wV/OruuQrrtluokl5vhs/3hb3auz38jotm6cPTsqxc/vyVwFaMYKhK2fJ63oWLpPiPJWpzhT3mwygFFDkW3stFNmYITwwlF1MvVZN1vHXgG49yXMg3i4Sd0oH3SiQ/W95p/MeZVLMFDzud4dqvTSLkXx+3DpMEQ1K0vfkCGUqKQf/k06R+7P1LnqTRQWbG3LhCWROOzdVginrfPIiHnWghiA8KSxcf9feWL9Lgu/VwGkK5lIFiwVtlOD8a8utXJ6uftXuEUe0/7Hv/mOG88D5WLOpTC8zI2Jk9WTH9O1wdMKZBJXzrFoa/dLc2OcRTefRqeFnHGhWcNrBLqYL/K8T8HagV2Bl7FNlD976Z3XfddMRuzD6yk46w19oT
 wKdlniQ4
 292BezfpMJyYxZkTIUMUnvNANZ2xLUIXuij/l2XhN5NjuXdVJLoauGG5+2cfWxS3+y4EDluir3Zzc7irUs1shiG+MB2IogVIdIe1jB93fBi3D0UxM4iR/9+Jg3yQ4YrfyQ89hEx8ACoGwB0h3Rvuxud5McLgAU1DpLedO8AN+6OK4/DZGpY/mXDnbJ2oEgrJ1nwRMDQLk1NstwxvybSiPXw3IjyQjom8x3WOMg3Pg+o3ATuMlr41kwuYV9lvJJ0RiewkiXbu+CSR0IihgpHlafKqMcAQXJlusqnnutd5aNLRz5yGepx0QUl2rZCg9PMWOKeaciK0RuAfWSOrQpw8G0wQ5LwaIMaJHqZhwejpIgowB0LfUDevOHdQQYyA3cnEHJ3MNANhXM+cPVuew1clJaAy786KnP28VTIxL1P8QoVXsLSq42UgfKcSgDleqy/ISOuz31TWGZ2rqm4SMJk/waXrTI2KSPMNEXrcXQZwI+xIiCLVSraX4x3yVD7pZ0qIP7J6ys80qdcNjTuGxh/IGqWuYUpc159WY32M2/4gME2GOlQxoXH7EhFvZOIaUHq1BiPMhNxX4NC5aq/kOJwn0C7KyQzNCvygc8nclUHvOoM7Y0Kv/oGrM9RrdHVXVFrr8wuVyRtjWhTEPtaCWLf68nQb7GI0kOTHZzCcaWqSzS6OWPBkrG/EYD7NT2O05U4lVw/pF6y0seiP7OssfMT081DUmw+hKxjk11VeWlUZO15/yDP1iaWXXV8w/eYlVnT08M7vlabQpAH2mxJZDl1/Y/wFypu9N7NcCd2ZKkBwt3bmQRLc2gdYJt9MEpjliR/gMr/6JrYZOw5eGzNycsWc4dn5V7WZPpDCrPnDTjuY12u7EBVyko4MHC6n8EgZ5FUzMN/zC8RoSMUpRrAWiRD3GCNO0YHvrHvwq4OrNvNuhnuiU5dfJAXPJM/8wr99a/QDgNphv4/32IwFtSDFTTc/bcQT1jKnw
 1BzjA/mY
 oG71ifP0Se1i/oHqvbak3alhoMZRh55D7A+VJz2w3NU8btbfHIhNNXtd5xhhNhtknfzmgsK+R2sjRgVTmtNdjboioxrQcI2DPnQH3XEyfyHOThk70+2x3iW/KFzlM5fatvNM7ke7ChnpSWC4uLtcJ0RFVLodEqJ9QD9dxHAnX1od3O4bY9Vo3texcGQ/zsK+TajAHNWR4dPN9CDVSw0bnCaE5Qs2d5vSxkaOL6O6tS9tNbsObgCRsUFfZMK1Qs2yWy9+T08RgTb7VDwL/J1uZ0uVUVc9OBx05JYW55PMTkm89rbWZAm4N+TbOy9mxffLouO4YjHjjAlUmDw8fLYx54b2pa7dPdSXpN1xGlf5bp0HrkB39FNTtI/jKsu2tg3IxF7h0Q3JYn8E8ead2l/JGKv3FO2QRM4eT1FmL4BkSPjQb6ZMxIryG0w65DveHqJgzmqGXT7geQEEnXBtxZCP8x8EeH8vZDCYErR9TW16gqLvPFrDjgiKdor4Yw4qpm4PFPyEgzZLhSojJ6UT5LqFZgCyopbaE08ywt2Y5mpxj/VZej/glxD0nxMWZESRXNR2HBDtY238wc4uRRpPN1z65rBjgqFfNsA7ncLmEquc5wONM860nU+9QLOo6cYfWMRQGBQKZK5Xnj5ysPZ3TG9zMBIMACFO2c5jWkdU1pi1chsZ4kyqcvWNlyIEV236lJgYpK+V84M0WgDFgxQqK1Q9yGWW8sk3PxUorX7NblG70g2/aQ6ADIJi3yc1AssrCUP9hb73+1Tam0TYY+Vtlc8qI2QTO1wVxVoEwPPoyQCuYFlkNxLENOZbLV0L0bKx6yS1+RHJzOPS+aCeycjr97r1ZPlLLHfxOmmkT4E/+4/CeTdSAyRakj6QPhyF8WP8BhKyEFnZPhq3jYMuH9GGgDmGpfCirhTuuD/7RgvBvqLOudp+OHbWtExjcPR9bPBJerlOc/f6Nyv4hJmeWOazPNMOuflrD+NGN
 0NyDyXl9
 QVsVG13hfRwdoNX5j9fk0qFGVTC199xFwESf0hi+ULgsjs/+SJGUusuwdF867p+XM3Onazf/jXVlSNKgoNfkJ5ES+a0KRKNk9a/MbKcznYobl2Ny9ew4gQBT6MDR0quQatqSju31GIs1ZmGGfPX4mRC4O0KpRaT04ypni53TpSdTTZ3aiuyZzAp2eboBCqDI5W+V33cE4sHQ2kNiX5yn/BhPOyFLZLSpwFRc4sI6DoG4j7GdYPqSkHWvvNc+8QFrgD4TQ8JN0oEG/oPT8A5aW4FgYW72d0+V32LxCb4el0V8esYNi83bZ4AwrtknLrF0RXrmOCVUOZHz+v1+C4JuDwWc6mP0nPf+Mw5dGRei4dLWrxe39v4zYDPYBRhwWlZAqoKawoGgB2+/68zHmtTAvSs7yw3nBhUDv4UwKf+9TfsgcbtmPDdn7wHoUGIYPUbB+mHvVGYTp0Xg/cK+ZPFyPaVhqYinSrOw6vvxjGc760O13+5Ij8Sz/+9m3PyiPsTKNOlFhC8KTb1EoxvhFHHqxFGq2Dq0Mj29P9OsZ6831eROVMdQcLTPxqW4IpuqI5IKLxhBulWXRUzr6kSymnwAzDI63lRol8E4wwEjVwJmJ5l6jSWoQRON8XlRAban1s6j1EsS90XRcwEJlbbj+Ozd+AIsnepPdke+QaYqWlnFtIm0Wk4Pql5b1m3zSsUyiiJSA/tp7lzD1pB/+xl/P3LLvO/8BtaVnlzUUno5SGJS9x7eB6tupptezmlxiNVaTgqDSutBJ4D55zVO4WsMN/SN5Tj1GXLS8pfLYfTrirYuMD48QvNOtSgEi+2EtvwWG9dDwExCkj9raco19Gt0yfAKzOXfNyBFZmEnUXkKTTtlJM2J3TODbhnbxsLv7C3ySLPDwQlx1FMwVn57QW3R/aI0iMSajf7tPAmZ7NQ3Icvo6ZIyxJbg+IZi7X0v7NDBEKM/5zr0clBL49Jmo6RQP4ZqEGaBzoTxW
 F7rlylD2
 kW/QBZdBQTDuPnRSF7yKf0Yns6R9Pc6YPRD6xISgsBgUE44ed/QIQVewNefEGjdUThyaOBqaC3OpjLEFcF7HFciSfqDaTZYsBA+yH8jP6tkK4qq/F66VTZJr+iwtVpiUiAmqo57rAZZ2kRbnC9foWt2mSORpgZeI2NQSquJChwDEfubx3PJg3tGMSPXcik57NLRt8guGelCK4MhEhabwE/hffYSfe9iy8OujvPRIGQq9AExFg56BCQM+C/fhWriFyGXrjo9jn0sD3q39cYCplo9vKj3qSnK1DNumXfUSGGnvcgY9xmXTxxTVuayapd+MdP2O68lgVuyYRe4OM22NBSwVSFEURj6jcpEa9bw6Sgku7zqCdS49Ovs1gw5cBBVlIfNkzCWOZrCdBGiPoPNdPYms/5/2zWq7ap3MBZ3HMN3rRq+V+vspeKfXHExFlFnzycmRC74Z0tbrrCjcnxwFSQ7rOuZxksLNQFHN8JqIA4ttbOLn+cYMNLuBFV194E3UayC5btTrTA1vTlKKBEf241JpQWh8zItNaq8ddPohzGpdSTXfMh9T//04gtlcOV7hwvwgitIIf0OgVoGGRo2EUUFqTNfvm5fINhJ4fitiuLCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 10:17:00AM +0000, Eliav Farber wrote:
> This series includes a total of 27 patches, to align minmax.h of
> v5.15.y with v6.17-rc6.
> 
> The set consists of 24 commits that directly update minmax.h:
> 1) 92d23c6e9415 ("overflow, tracing: Define the is_signed_type() macro
>    once")

But this isn't in 5.15.y, so how is this syncing things up?

I'm all for this, but I got confused here, at the first commit :)

> 2) 5efcecd9a3b1 ("minmax: sanity check constant bounds when clamping")



> 3) 2122e2a4efc2 ("minmax: clamp more efficiently by avoiding extra
>    comparison")
> 4) f9bff0e31881 ("minmax: add in_range() macro")
> 5) c952c748c7a9 ("minmax: Introduce {min,max}_array()")
> 6) 5e57418a2031 ("minmax: deduplicate __unconst_integer_typeof()")
> 7) f6e9d38f8eb0 ("minmax: fix header inclusions")
> 8) d03eba99f5bf ("minmax: allow min()/max()/clamp() if the arguments
>    have the same signedness.")
> 9) f4b84b2ff851 ("minmax: fix indentation of __cmp_once() and
>    __clamp_once()")
> 10) 4ead534fba42 ("minmax: allow comparisons of 'int' against 'unsigned
>     char/short'")
> 11) 867046cc7027 ("minmax: relax check to allow comparison between
>     unsigned arguments and signed constants")
> 12) 3a7e02c040b1 ("minmax: avoid overly complicated constant
>     expressions in VM code")
> 14) 017fa3e89187 ("minmax: simplify and clarify min_t()/max_t()
>     implementation")
> 15) 1a251f52cfdc ("minmax: make generic MIN() and MAX() macros
>     available everywhere")
> 18) dc1c8034e31b ("minmax: simplify min()/max()/clamp()
>     implementation")
> 19) 22f546873149 ("minmax: improve macro expansion and type
>     checking")
> 20) 21b136cc63d2 ("minmax: fix up min3() and max3() too")
> 21) 71ee9b16251e ("minmax.h: add whitespace around operators and after
>     commas")
> 22) 10666e992048 ("minmax.h: update some comments")
> 23) b280bb27a9f7 ("minmax.h: reduce the #define expansion of min(),
>     max() and clamp()")
> 24) a5743f32baec ("minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi
>     test in clamp()")
> 25) c3939872ee4a ("minmax.h: move all the clamp() definitions after the
>     min/max() ones")
> 26) 495bba17cdf9 ("minmax.h: simplify the variants of clamp()")
> 27) 2b97aaf74ed5 ("minmax.h: remove some #defines that are only
>     expanded once")

Some of these are also only in newer kernels, which, as you know, is
generally a bad thing (i.e. I can't take patches only for older
kernels.)

I want these changes, as they are great, but can you perhaps provide
patch series for newer kernels first so that I can then take these?

thanks,

greg k-h

