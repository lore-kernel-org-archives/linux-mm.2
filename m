Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E626D116F3
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 02:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02716B0024; Mon,  1 Dec 2025 21:31:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2116B0026; Mon,  1 Dec 2025 21:31:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1046B0027; Mon,  1 Dec 2025 21:31:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 97C6A6B0024
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:31:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97CAD50D63
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:31:35 +0000 (UTC)
X-FDA: 84172954950.08.8774FB1
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 713DC20006
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:31:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764642693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t58sVggozBc4lIyKGf4MhPbJgMGz91kVA3t8N4ag+vw=;
	b=IOzSjxA8KkYsUMXWv0AjhiyOZv1K/iiOCUwo1L/sk2gFeA3NMZVFOqIqTR1kAL88DkinTl
	Irz5fmyREw/N/zyjXIVc+vnpwA0iWUOwwvYnFHvpyeKkN63pPiHAZv8fBZHyx/jH0qB+14
	BpZPxAZoCkr5FE86Wq4+c5Gr6DrM+/0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764642693; a=rsa-sha256;
	cv=none;
	b=fJMsgkUA5mBvePGIAPPRHifSmt0/4Gcadhi5Y9lghyvYT1iFDDctnu3tIqUG1K8mNZuuH9
	1ZNQOORI9/dGVO26jjyLl7Xlv5LtQkxRykp8soj/TYc3T6Le0LMa8Iu/85TqgPl9Ys8eDw
	569DRmquASeJMckIwLOXdtKYH4ouYH4=
X-UUID: fda16c16cf2611f0a38c85956e01ac42-20251202
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_MISS, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:0340e088-8886-4e8b-b737-9cd91a7a2b38,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:0340e088-8886-4e8b-b737-9cd91a7a2b38,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:20bd76f10c9bd4ad895830f7141bf70e,BulkI
	D:2512021031260E6B9Z8S,BulkQuantity:0,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,
	DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fda16c16cf2611f0a38c85956e01ac42-20251202
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1310363433; Tue, 02 Dec 2025 10:31:21 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,  damon@lists.linux.dev,  linux-mm@kvack.org,
  enze.li@gmx.com,lienze@kylinos.cn
Subject: Re: [PATCH] mm/damon/core: support multiple damon_call_control
 requests
In-Reply-To: <20251202021407.11818-1-lienze@kylinos.cn> (Enze Li's message of
	"Tue, 2 Dec 2025 10:14:07 +0800")
References: <20251202021407.11818-1-lienze@kylinos.cn>
Date: Tue, 02 Dec 2025 10:31:14 +0800
Message-ID: <87zf818vil.fsf@>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 713DC20006
X-Rspamd-Server: rspam11
X-Stat-Signature: pdbt3gfxrs3tsm5ztjcr9uq97nqhypux
X-HE-Tag: 1764642692-455807
X-HE-Meta: U2FsdGVkX19bGfhbTm9VxrHsDnhvUua/4UhzWieVEk45BqLGVaFC+Nv8QXoQ6ClyLZuNfRlkhMXp2HRtcKmAFJ6vusYexIBF6Qcjj+bsqXG850pBtMhjiiVDUJMLdm8eS4lChCkOsD6vXoLT/+FM6+v/y2LCCeFJKEmoX2d+JK4QHWgM9g8gmgO63p1djrgoWU46i3bNPA5LxLN5yzv/hK8kfhqs31Z0qCnk6pIPBEdJ9LrX2YrK56L9athJzk/rm7lXHcRPQcrhQ9j4YOz75pB+TgbNX7SpyRvMbdlabbEeLeianU6TXs/8JV2s/LucO/DKGdmeZvB0Ybe1HxUzN4ypK1QUFlubGAlPWeP5lzS+UTDtCWNUbgz1N7pkRAbqL1LRtzVvr0ATL0ByB/8+2bkfqZxuHzj0gFuFj6oGuoZUH+j4JlICYjT6ilD7y5/8gVdXFDJYavrhM0tKtOjmKc+pW7n9LrR9ma3U3ebpfgwSkwHiq1xuSt9VLM+AZyzgvm6KHQ4PoprFpTr8dwa/zfDsK2SR2Cn+Wom8sPlcc6h4G5rGGGLBByaCmVicRDzVR0NkJzW7rvECi2ynpP7b/QVqwmu58jwvgkF8LCGN77/DnRkW5iMHRzzTmWMbQJisDfobR+EYWIelKFC4Gq4eWMgrp65zMRNJDNjDoYT8a35ZCf04WXDBLCB8U6nHApSAR76wSU8uCrFhIijv/OvN2El9+5YuMYm2xooPEUC76L4UMWXNhAzvrXtWV8gge6I6qhMzyy8zGah2Fxb9fBzPbmG0Jg31HrFIoGOIvlrdrOj7pJBus/xXgNvTVc08KmtpydDzQE0Um8La+3XDSEtQYQlKV0xPX49taUIJVt7589IqoUGnH8g5HWeZllshfJVmHjL3Y7YwG9+rDalE4XfUDl/AquJceA1fY9vypImFd+cI/KkBfbWFI5OsZvLqHK6r1C9s752HmEp/Yl8Hme4
 /wkYOiSj
 FCuo7Ho4qBgyyFp1iUyGyj3JDDMgUhKkewuMUUuW9nJeXyO0pFYmKeAUdWD5LvO0qGThdA4j9ieH4dV0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


FTR, this is my testing patch for samples/damon/prcl.c based on tag v6.18.

8<------------------------------------------------------
diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index b7c50f2656ce..94fd6184fb14 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -39,6 +39,7 @@ static int damon_sample_prcl_repeat_call_fn(void *data)
        struct damon_ctx *c = data;
        struct damon_target *t;
 
+       pr_info("repeat_call\n");
        damon_for_each_target(t, c) {
                struct damon_region *r;
                unsigned long wss = 0;
@@ -52,11 +53,22 @@ static int damon_sample_prcl_repeat_call_fn(void *data)
        return 0;
 }
 
+static int damon_sample_prcl_repeat_call_v2_fn(void *data)
+{
+       pr_info("repeat_call_v2\n");
+       return 0;
+}
+
 static struct damon_call_control repeat_call_control = {
        .fn = damon_sample_prcl_repeat_call_fn,
        .repeat = true,
 };
 
+static struct damon_call_control repeat_call_control_v2 = {
+       .fn = damon_sample_prcl_repeat_call_v2_fn,
+       .repeat = true,
+};
+
 static int damon_sample_prcl_start(void)
 {
        struct damon_target *target;
@@ -109,6 +121,9 @@ static int damon_sample_prcl_start(void)
        if (err)
                return err;
 
+       repeat_call_control_v2.data = ctx;
+       damon_call(ctx, &repeat_call_control_v2);
+
        repeat_call_control.data = ctx;
        return damon_call(ctx, &repeat_call_control);
 }
>8------------------------------------------------------

Thanks,
Enze

On Tue, Dec 02 2025 at 10:14:07 AM +0800, Enze Li wrote:

> The current implementation only supports repeated calls to a single
> damon_call_control request per context.  This limitation introduces
> inefficiencies for scenarios that require registering multiple deferred
> operations.
>
> This patch modifies the implementation of kdamond_call() to support
> repeated calls to multiple damon_call_control requests.  To demonstrate
> the effect of this change, I made minor modifications to
> samples/damon/prcl.c by adding a new request alongside the original
> damon_call_control request and performed comparative tests.
>
> Before applying the patch, I observed,
>
> [  381.661821] damon_sample_prcl: start
> [  381.668199] damon_sample_prcl: repeat_call_v2
> [  381.668208] damon_sample_prcl: repeat_call
> [  381.668211] damon_sample_prcl: wss: 0
> [  381.675194] damon_sample_prcl: repeat_call
> [  381.675202] damon_sample_prcl: wss: 0
>
> after applying the patch, I saw,
>
> [   61.750723] damon_sample_prcl: start
> [   61.757104] damon_sample_prcl: repeat_call_v2
> [   61.757106] damon_sample_prcl: repeat_call
> [   61.757107] damon_sample_prcl: wss: 0
> [   61.763067] damon_sample_prcl: repeat_call_v2
> [   61.763069] damon_sample_prcl: repeat_call
> [   61.763070] damon_sample_prcl: wss: 0
>
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>  mm/damon/core.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 109b050c795a..66b5bae44f22 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2526,13 +2526,19 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
>  			list_add(&control->list, &repeat_controls);
>  		}
>  	}
> -	control = list_first_entry_or_null(&repeat_controls,
> -			struct damon_call_control, list);
> -	if (!control || cancel)
> -		return;
> -	mutex_lock(&ctx->call_controls_lock);
> -	list_add_tail(&control->list, &ctx->call_controls);
> -	mutex_unlock(&ctx->call_controls_lock);
> +	while (true) {
> +		control = list_first_entry_or_null(&repeat_controls,
> +				struct damon_call_control, list);
> +		if (!control)
> +			break;
> +		/* Unlink from the repeate_controls list. */
> +		list_del(&control->list);
> +		if (cancel)
> +			continue;
> +		mutex_lock(&ctx->call_controls_lock);
> +		list_add(&control->list, &ctx->call_controls);
> +		mutex_unlock(&ctx->call_controls_lock);
> +	}
>  }
>  
>  /* Returns negative error code if it's not activated but should return */
>
> base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449

