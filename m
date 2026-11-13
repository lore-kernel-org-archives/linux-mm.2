Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11728606A889
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186816B0653; Fri, 13 Nov 2026 04:54:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E176B0655; Fri, 13 Nov 2026 04:54:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B9C6B0656; Fri, 13 Nov 2026 04:54:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD2646B0653
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:54:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76E00801F6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:54:58 +0000 (UTC)
X-FDA: 85429637076.28.F382BC8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id 812B9100009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:54:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794563696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XflFerSSX8/DRZ0nDIfVWn5DuNcdHJxrlRvSa/LouyE=;
	b=vWXnx34pzg+p5suss3QQfduyQU/ka5t48Q60p7+eHtsqfSjr+9es85QNe+7tgEfPFZDl39
	DOKSD+h7czcvIZAuGxhQZ+dqIuATQjlTLyjyoydUqXiitauciPuaOSvyrXKlQasmAiljHP
	WUZ3dwZJ+ZrGTY2EGlcwzS4M/7Vapas=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794563696;
	b=XBmHyrec/29xinuxpt+HU/bp5Wi1ovnpIJi06EaMyV5eeqM6H/PmCud4CABHvkfv8jeLQt
	C2X367JK5tW7XpIUQ5koa8tvOEl0+S9YOChsFhbl6ccp/nH/5dBg0hagEanyF6roopB8NX
	ylf8RsfXHODxWyMRMReS866TsnbHMrs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
X-UUID: 3fbb9ca2df4811f19a56ed5b684f684d-20261113
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:9c27602e-87ec-4c9c-98ce-81fa5be77e03,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:9c27602e-87ec-4c9c-98ce-81fa5be77e03,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:438bb5e73a121e35e5892c22171444ca,BulkI
	D:261113175444ZD0JE9K2,BulkQuantity:0,SF:17|19|38|64|66|78|80|81|82|83|102
	|127|136|153|841|865|898,TC:nil,Content:0|15|50|99|100|101|118,EDM:-3|-100
	,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:
	0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3fbb9ca2df4811f19a56ed5b684f684d-20261113
X-User: lienze@kylinos.cn
Received: from [192.168.111.179] [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 480940769; Fri, 13 Nov 2026 17:54:42 +0800
Message-ID: <db00f01d-c9c1-4207-ae7d-9dd77cf5afa7@kylinos.cn>
Date: Fri, 13 Nov 2026 17:54:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] Docs/mm/damon/design: update for
 DAMON_FILTER_TYPE_ACTIVE
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261113051711.89274-1-sj@kernel.org>
 <20261113051711.89274-5-sj@kernel.org>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <20261113051711.89274-5-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 8nek7o49d9xyjzb9dp6wa8k365shu5r9
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 812B9100009
X-Rspam-User: 
X-HE-Tag: 1794563694-930665
X-HE-Meta: U2FsdGVkX190lIvE2bUP5Ag0AZpZYooiT4NsggP/fnJl9AuTHNG6TgCcHh/ogz54VtLFlxwdPTP1M3l7yuOh81mMLPIRcbr4KVvPv6PE9L7rmKiBvkcPO5HxvPXITZ95z/cSewBOs+4//001iJKY8mTt4LMXxIxFoExYVj1SAXXy1NXfhNWu7dmekP737G0oBpDuiC5h6IdAXwIvH75z7W1mdI/6Fw/YAsSxsiNQe9o8ThC2c8YNBm0FnXE4TggmS1g8pH7nkjAmk4CuqCwN7wkBA7ITM6g0aR3R7yZZXRTDHHUCZm/gQjDNS8vRC7x40Xj4T7DPw+G0eDcqGn9xpukmBHocgPy0a8KHOmfGp6X9gZzPwInGU6i4W9dip/YGTlXeY3qo6JOCesRdEycn7TreP3vsjsn5/dDwLG7LKtQFO5UJxVkjPsknb4MzR562FWApLZQ4BD4bme5+GadYfuBnP2Kj1j2+09FuHJAvVCaa3GmIyzCVPunscoXi2Ck8VmmfcxJpq/yAW3mfwkguTjtXWWascAkcwEJmUXCuJHuZtRedVEQ6pzjK4msPlxJUW8rvcsWOk17KbBdGNZ/+6Qz38DU+oGvustmrHx875pWI9kux3QocbzJN13EBtTY5xjh7TScUpqxLWbvcfTVQn/P5Rl1uPIx9S7nJCc56Q+/AULkNxWOwlGeymZ3Hf/tZMdtYwf4+qAiTOWn5oSSxcHscoFMF8DAymhk/cR20VCs0BCk6NOjnx6FX5j0oH633bsEWh/y0N3/PiYG1/pnkm9mH/L/HeIxjELNvaab1MzbcK4O7DmjQ93eKNfjhGgoIOLtHlSQA+WQfjhrcfAB/SXdGWHaqbV7+oVF5G5Upi84w1dowwR0bC1rqnXQ2ME4+h2SYChZSk5CYK8tER3kO6Bb2zd8FNkF84YWlaDv9uy7lkknWGF7l1jb3fQVNojTJVZM5JbOiIioruvOG6cK
 ykxtlNs1
 UkHvEKDsgZcxw5o84IKFGVS1UtxRczrPcaNNrCq6G+vkC9u5v5ktG4Zz1B1VrPzT+IAXUQz94JizJBgeLvksAOU6JbZqTEOU+yDiXyv8UZ7NQDXRav7w/dwM1Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On 11/13/26 1:17 PM, SJ Park wrote:
> Update DAMON design document for the newly added LRU-activeness DAMON
> filter type.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  Documentation/mm/damon/design.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index 8440c4954090e..b676be6971589 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -302,6 +302,7 @@ filter types.  Currently below filter types are supported.
>  - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
>  - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
>    of a given size range.
> +- ``active``: Same to that for DAMOS filters.

This reads a bit awkward to me.  How about:

  "Same as that for DAMOS filters."

The ``anon`` and ``memcg`` entries above use the same wording, so
it would be nice to fix those at the same time.

WDYT?

Thanks,
Enze

>  
>  If such probes are registered, DAMON executes the probes for each region's
>  sampling memory when it does the access :ref:`sampling


