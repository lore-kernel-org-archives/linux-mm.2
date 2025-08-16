Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E71CA0EE9
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 19:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703CC8E0030; Sat, 16 Aug 2025 15:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611158E000A; Sat, 16 Aug 2025 15:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C5E8E0030; Sat, 16 Aug 2025 15:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5AA8E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 15:36:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 976CFB9B98
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 19:36:03 +0000 (UTC)
X-FDA: 83783626206.06.BDAB7E8
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9359440007
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 19:36:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755372961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5IzhDVRHoc/8AGOhcCfW6wbkvIAOSvwEj2UVDsOGo/k=;
	b=P/YyY073iJvkJfVkk8z5C5fzCwLsX0Y6FAaVm9/xb9h33pB8Xcr9PxwKGA+Z3aFh6yfaM3
	Y1OKetsMnzEy+eHWxusxEURkswzu8o9IZflAnHvGyZaw5aWjJsOQ6Daqa7a3uyVYc1Wwyg
	OzRwR4HerA143ohAQzoBiMVmGxe56Lc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755372961; a=rsa-sha256;
	cv=none;
	b=DVlGNu9KHR+DBbN+UnloCk3GiNVwdU51LK/vtsujs0OP9PgcThrccFZdFF59yEqNBa9Chg
	9+gLAPYOCZTCYVbDExK8vaKKodX59D5Y4e4ivVOJZwgGThzyXt/u9hXaGXP+xRm3V0VGEP
	gLrsswh+BcE6/mdRLaidXDOeEjX9kIM=
Received: by mail.gandi.net (Postfix) with ESMTPSA id E7FD744349;
	Sat, 16 Aug 2025 19:35:56 +0000 (UTC)
Message-ID: <c5bf56b8-da06-4e17-86bc-1b69af3065cd@ghiti.fr>
Date: Sat, 16 Aug 2025 21:35:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/sysfs-schemes: put damos dests dir after
 removing its files
To: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250816165559.2601-1-sj@kernel.org>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250816165559.2601-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: 0
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugeejjeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecunecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnhephffhuddtveegleeggeefledtudfhudelvdetudfhgeffffeigffgkeethfejudejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepvdefrddvfeegrdduudeirdduhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvdefrddvfeegrdduudeirdduhedupdhhvghloheplgdutddrudehhedrudejuddrjeekngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopeeipdhrtghpthhtohepshhjsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrmhhonheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigq
 dhmmhesk
 hhvrggtkhdrohhrgh
X-GND-Sasl: alex@ghiti.fr
X-Rspamd-Queue-Id: 9359440007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: m4tf5ct6mqyhp3kwj6jfm59s8dyqq6ie
X-HE-Tag: 1755372961-148351
X-HE-Meta: U2FsdGVkX18779PilI/ECsVjnXWCXdmfFBkE4rxqowG7z4o5ncO4uxAf8HLRb2E2HGd3g5Cc7wlFaoxkYCEg/C4njktRMlJbb99rHdXpbgGNdnLVSllplePnPn74zNzRBUeS3kbHMUOpGSdq9YuH+L/DHKgqa55CeyJ7POV9/WnfNMWLoXDtTs1GVpdT7Y/j6/kOjucUIbOK9qc9eJjitvF9W0Tk8qJYlASL7ns3MeV5Cd5JzAIt8DvU/OBujCFexKL6p0H1Ry2QmhAAEwdd/2L8Pn3I6QTkgAEHmtPDklzF15muP2xgX0oV7ss8WHOWsR3qfYUzY9KLrRhbDSHnaQZr7dAp/elzco4O+wQzUROo4WkmM178+6lz+tIxZpWY9CIFpPZuZDka+Ykhi8ALUyoy/ozSxItdigpaTuDLToiLGPsAfUQo79HMVMz9HyKfPXvvVWQv9ixInBaxcQO9eT/N5Ttkfo9xrW6akuVfDQIYp3Tb5uy76oJNPMU0t2nHnFAA5heWwERuGgu3l5zd9xtnajxWAW0zRQAXBH8Y1snmmMfN9Diz1qVUZ26VhZrEGZbVcnisrMAGwauaJSqXwoBkWni6KeuNYuIAt522/2zQKMk4R78sdrE9v3DocFAp96/7/+CQU8vtaEonnQjQsKSzFEU+N5b7RblxwAhgSF1cPAJxv0L4DO2Ytc9d8+tD7I+KvS6xrxG7IfxmmmHfg+PTLKvsmuYL6o9WdGM4Q7OxqlWX4i1cL3aybbRUpB7wFfXCLnEteuLBZQPuo+torWKWyUVe4EavCRGSNBJvMO2dX9p0Z9cSnm7C1F0y45ZgEzy31z8rG3vOtoidSsKvhpHZCO1+Zr8LyFdiVkV0LJXs0+j1T6KStiLo2WL0D5X2nI6s/jd7Ktnx4+FW/P/5667M/rxnwO4L0QB4HaDNII8aN0Y2A5n/0iB55eNDbpthKRv5mrhFes4lzmsXKH8
 92VrA9Lr
 9lrLfTNX+P+9qQg15R4cVbUBgKuvoDxUXh5yrYtq4IBx23tkuosUknVf5PWS6MEttyOU+hHef/eAPLPW/Xt87W/kgPaXf1AVe+qbYO8SeS8Dzoj8Np2rHXGkpBwWoqlkgCELr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000004, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On 8/16/25 18:55, SeongJae Park wrote:
> damon_sysfs_scheme_rm_dirs() puts dests directory kobject before
> removing its internal files.  Sincee putting the kobject frees its
> container struct, and the internal files removal accesses the container,
> use-after-free happens.  Fix it by putting the reference _after_
> removing the files.
>
> Reported-by: Alexandre Ghiti <alex@ghiti.fr>
> Closes: https://lore.kernel.org/2d39a734-320d-4341-8f8a-4019eec2dbf2@ghiti.fr
> Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory") # 6.17.x
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
> Not Cc-ing stable@, since the broken commit is in 6.17-rc1 and hence probably
> this fix will land on the mainline before the release of the first 6.17 stable
> kernel (6.17.1).
>
>   mm/damon/sysfs-schemes.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 74056bcd6a2c..6536f16006c9 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -2158,8 +2158,8 @@ static void damon_sysfs_scheme_rm_dirs(struct damon_sysfs_scheme *scheme)
>   {
>   	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
>   	kobject_put(&scheme->access_pattern->kobj);
> -	kobject_put(&scheme->dests->kobj);
>   	damos_sysfs_dests_rm_dirs(scheme->dests);
> +	kobject_put(&scheme->dests->kobj);
>   	damon_sysfs_quotas_rm_dirs(scheme->quotas);
>   	kobject_put(&scheme->quotas->kobj);
>   	kobject_put(&scheme->watermarks->kobj);
>
> base-commit: 9aa69ba9d9e220ea1d8ba62592fe7ffba376b2cc


Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks for the quick fix!

Alex



