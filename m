Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D45C624DB
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 03:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB116B00C1; Sat,  5 Sep 2026 23:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3586B00C2; Sat,  5 Sep 2026 23:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0F76B00C3; Sat,  5 Sep 2026 23:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF94C6B00C1
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 23:50:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6330814042F
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 03:50:48 +0000 (UTC)
X-FDA: 85181960976.24.1C33939
Received: from r3-20.sinamail.sina.com.cn (r3-20.sinamail.sina.com.cn [202.108.3.20])
	by imf22.hostedemail.com (Postfix) with ESMTP id 14D61C0005
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 03:50:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=zoYGZAAa;
	spf=pass (imf22.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.20 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788666646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQxvNMzas3x+IlCCh6neBcmKorR8pDTgu0p5/v3lP/I=;
	b=JNlYNoG/BYL802sW9qki0IUreVd7+gN+bpZ7SGg89W8pqgyLSVMIiyTf3G2pyesSSaG9qp
	lTeF8m3RSuj5KG8Wwzr4jr3WWeWdffsvScZFzI7rqh5ygkG31sj1lsXXcXkp5TZpHeRy5D
	kh53VQh0T+NO8PtgLHlhsrNi8sQ5fZo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788666646;
	b=OU2ryimYMIiXdPKukIaZEjgjV3/XGNXkSIB/Qi8JXcZNonlejvs7tW2gSGBb8gwyXsIIeu
	fGPE46tHajE9fbX8N6u4WN+ATXe2IWysxJxgd2zE7YTaUuweeRa1lBJrsxqUA6ju+VL4Xa
	zNeU4CFgYfP+VirF1E3Lzsx2ZQwx5LM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=zoYGZAAa;
	spf=pass (imf22.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.20 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1788666645;
	bh=PQxvNMzas3x+IlCCh6neBcmKorR8pDTgu0p5/v3lP/I=;
	h=From:Subject:Date:Message-ID;
	b=zoYGZAAaufr+kDuqfuWAU/mzH7d0jKRHilKTB/o9KeMtIuszYEFxdXpOg83wXTwJI
	 VW2FRtq2iwEn1U4mGO9wTVWzhq638J0c98EMOkB0sciRdT0aCUziL75QkGYTDKEaAw
	 3guBahgvhUdWeqNk4DYEyEOEySL/7x0tZdC+2cZQ=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.194])
	by sina.com (10.54.253.32) with ESMTP
	id 6A9CE30D00007E2F; Sun, 6 Sep 2026 11:50:40 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 6954354456958
X-SMAIL-UIID: 553362F731704953BFFB61FDF2BADA41-20260906-115040-1
From: Hillf Danton <hdanton@sina.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	stable@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>,
	Ye Liu <ye.liu@linux.dev>,
	lirongqing <lirongqing@baidu.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for vmap drain
Date: Sun,  6 Sep 2026 11:50:24 +0800
Message-ID: <20260906035027.2106-1-hdanton@sina.com>
In-Reply-To: <20260905152717.11711-1-urezki@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14D61C0005
X-Stat-Signature: ahr78jpj81jowgkqhs8jyjrkkicg19q3
X-HE-Tag: 1788666644-159762
X-HE-Meta: U2FsdGVkX19Uzr9Npu1CbHkD1CVJsL/pft5DaRl2kmm7ZmCdrnTVujBHOsePySSPGA96rMC5zYeNB4Qr712QeaRnlhSRxCzScvyW2b2Yddecj3DLTzi6fIa+vrrC0hJBKCRaWnOzKHtVUjf+KrG1S2muoprmKzMs2iSKXdALK+VAtcQ00WPeaR34khcQAmbAJexRkL0VwlU+02/NV3verbOyx2vCd9plizT46ptgMDX1kR3OMYXgxxlvTKJDGDjGgVctVxtUa0/MEEmPcjmZzvsTm5QsiXLra7QTQ1pETYOPbK5xCT6FxVWxEs0/7eBwuBmsWf1cmdrT2eVYqg9PkzujKUuSam1JtDB7oQAauEhBK+9eDk3cGd5PDG724VpFpnlx0/KDODR0hFYUugCnKv1/rrye0U6emwgaTbreu5Q3BXat1SHTolYsmkOkshx78qJ23TwbexdHnqnKft/bTfO2nfEhEBOx2sYsa0nf+uagq/IQ/i6mDl6/CDnWSpiPZ885e3qAx4ancd8sR1eJ7ZO0cInoPR9B76JAh3bdZIO36sKxmFhb8O6bIBYW+jw5gH593Cn+aqD/sixtbChX94Qgh9OAKParSU89vCnQNt8cRGVBmK9yBhIc5IHuyrwb+koxumE/b9N0I5nKA2wmcOqMEcz040xoiFE8gGbjocdVgpFscV6N1haNtntr63em+NrdfTTVOoBX8pVBbrDymKFxLjiKd9z6SssSwXQ9f1aLKo5WqmqCxIvaRMASpCdSjxyBNwyil6AFNHvDELPfLm4yz8VCBPSQpdsxzviJLf3Uh3ioBES7m8UiMdA8iu6jQeMDq+2wDynoCAVBQuL5SAbtTOwkEh4uURqcC0qfkrXBJ5v5gFnrm2xAql3XL3SL/BzQ22Cqt6gf52Zfxw5GEVH941vTmDNUOX/RdYEPTorszgOswb4LiZkpTnW3zhcoLgLD1Z2FN9jNabjsQSw
 ylfm0loC
 TeHruDeHggZ+GntQ4WU3EHVvrc3DURxvCaxq0tdyREtBR2YRGjB4Q3TLJtQzMhXzy+gyYIb1aOEk5RzMxii3ZmBQZ5qi8XvaZJG1VFEoVXjRrYj//KaBz3i0FbOP0YMAQyQXJAwY62r4HJjn9xOCOe6hELhSk5uWD79QhUukIjc7H3zp1/bONG1Gw9OXgmVqqDgt2ZsV7MzUqpDlkiVsSwYA2SRTU85/nEd9WRknnIUwW6KPFOHhGfXaKTLeuAHeDc+6Ivrfoh5l8E1DPmQLD2yDfGU51SkhzHpGKtzPdHsEXkOkjXLstGzWcbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 5 Sep 2026 17:27:17 +0200 "Uladzislau Rezki (Sony)" wrote:
> drain_vmap_area_work() function can take >10ms to complete
> when there are many accumulated vmap areas in a system with
> high CPU count, causing workqueue watchdog warnings when run
> via schedule_work():
> 
>   workqueue: drain_vmap_area_work hogged CPU for >10000us
> 
> Move the top-level drain work to a dedicated WQ_UNBOUND
> workqueue so the scheduler can run this background work
> on any available CPU, improving responsiveness. Use the
> WQ_MEM_RECLAIM to ensure forward progress under memory
> pressure.
>
If the dedicated worker will run for 4ms on CPU2 before the tick irq kicks it
off cpu, the system event worker on CPU2 has to wait at least for 4ms to handle
200 events for example in 1ms, the net effect is the same as the current scenario
where 200 events wait for the drain_vmap_area_work to complete on CPU1.

Different workers does not help to dramatically decrement the micro seconds
the drain_vmap_area_work takes.

