Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88444C56206
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 15:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2686B0005; Fri, 20 Feb 2026 10:14:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62EF6B0089; Fri, 20 Feb 2026 10:14:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EDE6B008A; Fri, 20 Feb 2026 10:14:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFC256B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:14:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4AD0D140207
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:14:17 +0000 (UTC)
X-FDA: 84465180954.18.1214580
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 26EF380013
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:14:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=fsQpAbD+;
	spf=pass (imf30.hostedemail.com: domain of "prvs=05111aad59=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=05111aad59=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771600455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZ6JzFx/gAcIdTl8EzxWzPWAjICWFXjclrNpnYrngjI=;
	b=0wXildUW/PA5YTy/Vz+PEP8vNBILUlS5vVFryFEWd26mnAKcWKe0oN/cJGy0oLUG+yx2Hi
	ygksgBz2n+GT9IhHSHssG32OPp/G+AYkaAr0Gz0rsHnIIKwsqqgasx1EJ4ZNLUaIMsAgGM
	Nxkl5BsbnYz9bN5nmLoAUCUY61blRmc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=fsQpAbD+;
	spf=pass (imf30.hostedemail.com: domain of "prvs=05111aad59=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=05111aad59=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771600455; a=rsa-sha256;
	cv=none;
	b=A2OmtJ6fyz80ahkmfN4bndBJK8UvTRWQ/EXQ3DKM25ndj0HZFo86Liel0AkCXDpXskm1ql
	nXe2HHYlwAccbxYoXYUr1h8O3LkpB8WeaWnwHfG69ElZUsSsHxczApDor8/UidmZbENq6j
	zCBvy82wYHRVcdZf9MoJdhFm6++i/9U=
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61KAhAu52807757;
	Fri, 20 Feb 2026 07:13:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=VZ6JzFx/gAcIdTl8EzxWzPWAjICWFXjclrNpnYrngjI=; b=fsQpAbD+YS3C
	KNNbYxfmJZ9bsqDPibziRz1xtqJa+H3Ht0PeWcYkVr7kwLjEQA6kagw+FHMO4gLl
	wCADDvLibZgpzxG1deqisHF84NBFaZ4C00fg07DddBM1PpSj8OJl3y3t3CWPMFc2
	GS+iF0GPpIu6defvPPcGFxnqEnu5CJc/CWKwpIT2Feol+6LCktHZ/ijPhQUbInt+
	n7im83SAQEHcvpNbe65IjUjxp+KNx2va3GgdGc7cLeCoTXrPL/tvhwEFPZFHUL7n
	VGyLalAUORf9EiSi7alGaFf6koERtJTCd5EbmXe+1BFrdx6RioG6X/j8XTvm8ttF
	K1NgbI6uDA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4cep3gss33-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 20 Feb 2026 07:13:54 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Fri, 20 Feb 2026 15:13:52 +0000
From: Chris Mason <clm@meta.com>
To: Youngjun Park <youngjun.park@lge.com>
CC: Chris Mason <clm@meta.com>, <akpm@linux-foundation.org>,
        <stable@kernel.org>, <chrisl@kernel.org>, <kasong@tencent.com>,
        <shikemeng@huaweicloud.com>, <nphamcs@gmail.com>, <bhe@redhat.com>,
        <baohua@kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/2] mm/swapfile: fix list iteration when next node is removed during discard
Date: Fri, 20 Feb 2026 07:13:33 -0800
Message-ID: <20260220151338.3234934-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251127100303.783198-2-youngjun.park@lge.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::30]
X-Authority-Analysis: v=2.4 cv=H4zWAuYi c=1 sm=1 tr=0 ts=69987a32 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=57SyGIRnAAAA:8 a=GvQkQWPkAAAA:8
 a=-gGpC8dyzBLQY5EMcocA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDEzMyBTYWx0ZWRfX0Yy92bDfioOi
 tVdmW+qdIfqcZNEF6Sgeg5mWKQ/nCk5UIYvww/Uapo3kzb5zZinF4Zi3j8MgTqQNlcHTRGz/zcH
 gHghGo/CQmK1ndy4xZ/bCAxxot0O9YL879VFhNVnD4RocX3gjSsRQRHx/4p7p34bEf7Tasxap1J
 0jBDTA8cBxujADB4srHiEjYG2J4nw1Ea1TX8sUWL9tgGI5GZ5hwH1R/mqF9mDk4jCtac8Y2Gkga
 Gx2IK7OXfTPl0Y++Usv34RLNyAYeF4RvAm9KynD4NK5FeskBoWIGoWeb8GYM/Yntvu/Toir3M7a
 JlsONz9TeDZTHIXEbuJcyOl5WiJleBeCZrQ4Xe2D2dvYfJuoOkPw+6CkGKmpFfyJZC6rICCPSdV
 ITwg098wbSuxLZYqWyBvvbySPxCsl5cqO0rg+UUs8pv4MbjXlTt6Jv6fVY1WrLXEaShpwSUC+L3
 UtImXbCDxWcbLatmrgw==
X-Proofpoint-GUID: 5qz9-x9PKyP-MxVfZvWAo_97U_VZh9Pj
X-Proofpoint-ORIG-GUID: 5qz9-x9PKyP-MxVfZvWAo_97U_VZh9Pj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_01,2026-02-20_02,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 26EF380013
X-Stat-Signature: coheg54fgi9zbnoysnwdo8kzgx87f365
X-HE-Tag: 1771600454-554344
X-HE-Meta: U2FsdGVkX1++gpLWARoGF5Rl34LY2WSxSULq+jqRiuFHWblasi5WAYbafUon0VLAG765ED+nHtVVlRKJ/jqUyy31F9tmUd6u3n01arCbV81IhW2zB84KO77sXbjMm1D4cwfuA5ED+f+nHUJDXrmZ2lzaMOsea0S8uxyTlNprWYZld0CMJWHtcwu65cNNlpbdgF9xzjCiVm09z9sghsbIICf6QdS+yLqgSWayRAwO1rAyPVuzDCyhO0mMY1+bj7YQ1nIZpOOZaiKQ5VimceF0szRLwdsnnE1UPPmejWbk37putEUX49SkmgxpbYYiaSkzn5Anp4HJP2nmq3L3Z4fSFGTi9L5et90VhK2Jo0QRxGHvMMmSWj6XS5rj9QNzdNchMJnVwHpciYlx1NXUpoaBeYD7Ocln5dEbPu3azI8P5NWeOglu3fGFLOzmvZ48j/eASamyWzJHVMv9pPd0hSg8WsjkomMZWL6bvryuc2gsRXVdRgmNPYiOfddpjgIR78/oMfc9zmjxrx1jX/07puJYAuFHjCOFf44wAZBfgEmFVpYG6LABgj3rljiTL4/yA56imddxdkFNq1NmZ78csDpvrq2V9KAEE1UWALIkrQh880SpE4gPaEmiy3JhDFI7rqXwhGSXj+w0JzAsDtzzPQu+p8lhhWr61vXIppuzjCnNwAvb/o6e+b2t5TujN1kwoe2TOtmuup5VRkOTBWJNgdStIWdt8u9ofpBya3bizO9xGERq/7PAlR91gLtm6NRgD+ZNLAV0m0Xq0zgsQjocVoEpY/UxemQGp6SbHa6Ks0MQt5n3s3lADJOHN/DTVrKWom1PgC1cZzeZESlizwWU/t8Zj1Y6nINj320uB/6swUIVUGJxJoVGqMIC9NX4gkA+wPNrnBaRWX1b0MHhK1vdGsPEn130G5SaUz/bgzmPWa4FqwcrS0iUD+QZe1toQcI88vcoB9ixetx77LMCmawcY7y
 A4JVbenU
 05+KwjFWse94/R1SavVDTu6MSJ/uURxPK5DZWRwFNc6U6uiZL0nKSnuW0HNsTiYfThQBQu+Anttm8Z4yDRaxvXfn0e+NzdV4SC1PYod59hp+OTL7CmdJTLi1oVMAx9tXRKTa7IxzMEp7+S8MR2O/tXUm6iAC/DUbwuEBnqSmAclzpsN/kUW+CW1q4jF7j3hhwpPZ5Mj5F5U4UZdQIPMehbs/L2muTx53pWAmgo6sJRlhA7Ekvsyg7S2UtS9IPI6gg9+40A8uyjj63QsguhaLKC5vbs0VnU3/ELR0G4jPVq8HG61FOanTO7kyvzsMXQmQmCrwmjBLn+cy1mjYhlLjypoCD5GtxTVmMgFl4J1nGAqVaZtDSEBzrNq7WjZR33a3ZucuCbZDEzGBay1WWPNiABWZcGlwK4yVeIfmB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Nov 2025 19:03:02 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> When the next node is removed from the plist (e.g. by swapoff),
> plist_del() makes the node point to itself, causing the iteration to
> loop on the same entry indefinitely.
> 
> Add a plist_node_empty() check to detect this case and restart
> iteration, allowing swap_sync_discard() to continue processing
> remaining swap devices that still have pending discard entries.
> 
> Additionally, switch from swap_avail_lock/swap_avail_head to
> swap_lock/swap_active_head so that iteration is only affected by
> swapoff operations rather than frequent availability changes,
> reducing exceptional condition checks and lock contention.
> 
> Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> Suggested-by: Kairui Song <kasong@tencent.com>
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
>

Hi everyone,

This fix landed upstream in v6.19-rc1:

commit f9e82f99b3771eef396dbf97e0f3c76e20af60dd
Author: Youngjun Park <youngjun.park@lge.com>
Date:   Thu Nov 27 19:03:02 2025 +0900
Subject: mm/swapfile: fix list iteration when next node is removed during discard

Looks like the commit being fixed is actually:

commit 9fb749cd15078c7bdc46e5d45c37493f83323e33
Author: Kairui Song <kasong@tencent.com>
Date:   Fri Oct 24 02:34:11 2025 +0800
Subject: mm, swap: do not perform synchronous discard during allocation

v6.18.y stable has Kairui Song's commit, but this fix hasn't made it to stable.
Johannes noticed the Fixes: tag doesn't match, which probably explains
the gap, but I think we should pull this fix (f9e82f99b) in.

> ---
>  mm/swapfile.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d12332423a06..8116f36e440b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1387,9 +1387,10 @@ static bool swap_sync_discard(void)
>  	bool ret = false;
>  	struct swap_info_struct *si, *next;
>  
> -	spin_lock(&swap_avail_lock);
> -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> -		spin_unlock(&swap_avail_lock);
> +	spin_lock(&swap_lock);
> +start_over:
> +	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> +		spin_unlock(&swap_lock);
>  		if (get_swap_device_info(si)) {
>  			if (si->flags & SWP_PAGE_DISCARD)
>  				ret = swap_do_scheduled_discard(si);
> @@ -1397,9 +1398,12 @@ static bool swap_sync_discard(void)
>  		}
>  		if (ret)
>  			return true;
> -		spin_lock(&swap_avail_lock);
> +
> +		spin_lock(&swap_lock);
> +		if (plist_node_empty(&next->list))
> +			goto start_over;
>  	}
> -	spin_unlock(&swap_avail_lock);
> +	spin_unlock(&swap_lock);
>  
>  	return false;
>  }
> -- 
> 2.34.1
> 
> 
> 

