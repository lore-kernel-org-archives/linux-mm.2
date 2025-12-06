Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1015BD374BD
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 07:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD9B6B035C; Sat,  6 Dec 2025 02:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D862D6B035D; Sat,  6 Dec 2025 02:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DAB6B035E; Sat,  6 Dec 2025 02:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADFA86B035C
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 02:59:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5994A133B42
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 07:59:07 +0000 (UTC)
X-FDA: 84188295534.02.131CC12
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7367820004
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 07:59:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765007945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7rCQFIncPbyn5+Opr2+eFlJACt0F77Tv3JuEuA3cuvs=;
	b=2VrmoPPie2djoN1bDYpioaZmw16OgdpZ1dGDoTm5+XKg6rfMjQjjD5r04PZhCNeCjnbYyt
	e+dFWpfAwJGTPq3elor3Vg/CH4mhnx7iIwzCtHxo+HBS0jzf+CZWktVM60rJE9RWZS0J+t
	W7gAtxrDrig5DpukJie3E4seK+X+Wks=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765007945; a=rsa-sha256;
	cv=none;
	b=fW6lNLQ+pLS1ZLgDpOb3WT37HOmVWhmBdAeYeQJjkVPlX3XSeGZvBRaqa+U5NIUK9hkH4p
	q/FeCquSgO/jhMPrLoHWg7TfMrRjmEU/FEV+zvfaf7pF99oEc3ejtTiAvRZL+iRbx08dfl
	5STKPKqqNwl2cnsTYAED3vJjVc9dsIE=
X-UUID: 6703177cd27911f0a38c85956e01ac42-20251206
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:24d1c11a-0485-457b-b7ae-f774be3e8a44,IP:10,U
	RL:0,TC:0,Content:3,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:8
X-CID-INFO: VERSION:1.3.6,REQID:24d1c11a-0485-457b-b7ae-f774be3e8a44,IP:10,URL
	:0,TC:0,Content:3,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:8
X-CID-META: VersionHash:a9d874c,CLOUDID:f46e655ae615888f6a1a766054581a24,BulkI
	D:251206095026SCT0TVTN,BulkQuantity:2,Recheck:0,SF:17|19|38|64|66|78|80|81
	|82|83|102|127|841|898,TC:nil,Content:4|15|50,EDM:-3,IP:-2,URL:0,File:nil,
	RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DK
	P:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6703177cd27911f0a38c85956e01ac42-20251206
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(61.48.214.33)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 613505101; Sat, 06 Dec 2025 15:58:50 +0800
Message-ID: <924cfaa0-ad83-4d68-a6da-c1e8537b3232@kylinos.cn>
Date: Sat, 6 Dec 2025 15:58:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Enze Li <lienze@kylinos.cn>
Subject: Re: [PATCH v3] mm/damon/stat: deduplicate intervals_goal setup in
 damon_stat_build_ctx()
To: JaeJoon Jung <rgbi3307@gmail.com>, SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, enze.li@gmx.com
References: <20251206011716.7185-1-rgbi3307@gmail.com>
 <20251206015010.47826-1-sj@kernel.org>
 <CAHOvCC78_ci_6dg=ctt5HjgZDn4bVmNZw-qfATvShnn_7qoMaA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAHOvCC78_ci_6dg=ctt5HjgZDn4bVmNZw-qfATvShnn_7qoMaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ewh71ob48frydos6ftgjj1wxze3dk8hx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7367820004
X-HE-Tag: 1765007943-753051
X-HE-Meta: U2FsdGVkX19CmH6lVpcsEPxARHkARtKQ3Iy3IV92CaS5Q2VkphZwlBJwvok5nMmF2a3DmPT0Y0vKz2QOi1IutklAAWGbJFU9+smIdJdzv+wCOrL7DqUPolBVAoLaqQU3HYAo78liniPl+grovoeCyltFWT45p37kF71Bb1kzpDshjgHHndjhdGdRMubdD0Htvye9W5o/gqfaehjrEEJDr+DVUDfSIh7viFpdCnQe5HwQ08/LVVYno829yP9Mscqnsn91AKtkROg4sJZ12PB2ci9hM403AkexZnw9mdlcTR7SsnT9Ko5jBnC6dMnehjwAEQOYXxhrzJ1DdLUO1RlnqtqTr5/Wdl7P65kB4yprtIsEy0k/KIaxhVu9J+5giNjc9DSDSqrYdPizQM18Ep7kjlUixeIEYoTgSxG5doa3SDDdEQzKpDHxUSzYqZyJ6oA4re9sSWjPBu8AvY5viYeFrX7dfK5X4bdeWvBMg8WXPexaBkxUGCXdh1UV1ELJFtQzqUWBvZ71DzvpI0Cm6q6HGV4dNe8y7ujNRB6VWqfP+z2y8+ueROmNUVU+9tALN7nEj8knU6/w88v3W7lGXiyrAMw2dydGl7eRqp0LCYDxyrhFhLIgzasW48qSB/zK4dBqfrFkwN8a53c9H82C1bCQsMR1BRqZBYTq+NN+tRlqOpjBQSnCS7fTlWEGWfFEve13nNyx1018yDL42eiiUW72BJ8jsm0y8hLsCVRvFU6Jqd3p+kKdtGwjRvcMk5aFFgh4SrejPNrt+0WSruxdWk0uPCcHKQ+bSN1/i9wEDm0vwSLQR9xapYTuq3EiaLUCmZkNNQg0JR4DMeUs4/8BRYxecGQk1+3P0K4aXacP9nywsg/Yzp6GcbTm2VCa3WNWsL6c97ye66osLrc+q3gb4ixrVNNrJFnEaiG1XTEgLXNi98YvQRsIebqmo8WpafJH0Y4WgqKE5AHojtbK5f6twPk
 OEkcIVlc
 RJqor0BmNB+l/I1duSa/KxDhWcgamQLYJz6DoohCN88QH9rSusvbAcLoaAkUvaoo2+cmIONjnz+9HTc9cPEPIlG6hW7s1Wbn9mu/qGw6A0TGa+vilKglZBmCXVK89Vi3OfZQIy1mz8N1DBp4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/6 12:17, JaeJoon Jung wrote:
> On Sat, 6 Dec 2025 at 10:50, SeongJae Park <sj@kernel.org> wrote:
>>
>> On Sat,  6 Dec 2025 10:17:13 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>>
>>> The damon_stat_build_ctx() function sets the values of intervals_goal
>>> structure members.  These values are applied to damon_ctx in
>>> damon_set_attrs().  However, It is resetting the values that were already
>>> applied previously to the same values.  I suggest removing this code as it
>>> constitutes duplicate execution.
>>>
>>> Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
>>> Reviewed-by: Enze Li <lienze@kylinos.cn>
>>
>> I show Enze did suggest changes [1] to v2 of this patch.  But I don't show Enze
>> gave Reviewed-by: tag to the patch.  Am I missing something?
> 
> I added "Reviewed-by: Enze".
> It is just minor commit message format suggestion.
> Am I putting too much emphasis on this?
> Should I delete "Reviewed-by: Enze"?

I have carefully reviewed both the commit message and the code changes
in the patch, it looks good to me.

Feel free to add,

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

<...>

