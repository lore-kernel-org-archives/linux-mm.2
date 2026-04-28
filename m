Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A02FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24C86B0088; Tue, 28 Apr 2026 04:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD276B008A; Tue, 28 Apr 2026 04:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3ACB6B008C; Tue, 28 Apr 2026 04:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6DE06B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:52:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 677EE1604E6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:52:00 +0000 (UTC)
X-FDA: 84707347200.04.4F3FB16
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf15.hostedemail.com (Postfix) with ESMTP id BCCA2A0002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:51:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=s+aCq0AG;
	spf=pass (imf15.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777366318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DF30WaXgLPexQczR9IVmne/D+PkK2gAY9qsZNS33OHI=;
	b=yzC4FE8KU1UBHrswiTfH9QuqTQ42edbTuXqH1GWCBhdw6XUwicu3xWbxQlK40M453svnYk
	LhBifCiJjGEt3r2+lo2ZUKXOeCacqwJ/tqMBm1czTcR9ZpG/FiQo+5rpt6bgtKFsoxOTU5
	yjXuKBo/vd4GiNCS4v0EFO4vaAX1ruw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=s+aCq0AG;
	spf=pass (imf15.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777366318; a=rsa-sha256;
	cv=pass;
	b=cuJYjEm+kB/2o92JDFysYVbT0fSgjHTpse1bNM3a6zU+2+dmS/Pjxs5WcvIkJn3qZum6JA
	lKzTmmy67yXmfkOb0Z3RG5mOCqAvNMsdK6tjF6YuChsPbSCS8/VNZQsSpJMwNNzgGBVozz
	bQhLEcWgDPZgt8mh6hjo0M9MEpJGSNc=
ARC-Seal: i=1; a=rsa-sha256; t=1777366309; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=V430eAGGjHxk9o5rY1sptIPiuxu+bRQ/KMwhnoqFchL8SAdW9XWp+lO1hjkt/NboqTDAg4+j2IY6mDspYaCE4xXRVgP2nRwDpOyhoXLd2DXz62dTjQoYzYatqWSIIOYop09ciGgCP+tB/TWYxA323H0oP/bkP2uRSEdHaFqU+uM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1777366309; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=DF30WaXgLPexQczR9IVmne/D+PkK2gAY9qsZNS33OHI=; 
	b=Qo1Y/WVndzqKqO84i2NwPE4OikY+3bn3LDcrEQ0w+N1MirxxzydWUAumoSIK+jolTCaf0cjDelwa8nNwv2I/7wQwpQBYkrm+ZUQZRqPZvKNtdOCYDfnox8SIatKRm3yi5HUXm4rZyiCP/pidRiEBARfQbKdsFddEDLee4HLyPMY=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1777366309;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=DF30WaXgLPexQczR9IVmne/D+PkK2gAY9qsZNS33OHI=;
	b=s+aCq0AGVPHjeqDoU/IN5hYhfZcnnzmFVk2DVLkx07rebaiw+u3RHoLxME6Gy81G
	B5Py3i9dsSLcF7LcLhAosZwyQy1rNTS3ReQ6eTz349yeMn97IReFODmIkS5FXjPEZUA
	KGVMBkj7c8W9osqu8gvst/N//SaixwQwdKOUOuso=
Received: by mx.zoho.in with SMTPS id 1777366307405215.0067515055872;
	Tue, 28 Apr 2026 14:21:47 +0530 (IST)
Message-ID: <c37426f7-5824-434e-9a95-fe6cecf6526f@zohomail.in>
Date: Tue, 28 Apr 2026 14:21:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] mm/vmalloc: reclaim tail resources on large
 vrealloc() shrink
To: Uladzislau Rezki <urezki@gmail.com>, Fujunjie <fujunjie1@qq.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <tencent_824873CD3C7F2A76CD237A308C00DF18580A@qq.com>
 <ae-O3URyANS-mkoV@milan>
 <tencent_54339C62C9BCA8C7ED48DB0D91451157FB06@qq.com>
 <ae-X0MTt6GtCssA2@milan>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <ae-X0MTt6GtCssA2@milan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Stat-Signature: rxyigxbq8og7u8dzgsphrsfx9q9ytyg8
X-Rspamd-Queue-Id: BCCA2A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777366317-431176
X-HE-Meta: U2FsdGVkX18CXEQhd8RVtscctHXJf221v5lOaiv1pnBOLoRa83jZp8XE3sT7vwlM8PuA9O8qn6veH5z6Dng1u2YLdt6Zpg78M+WdQ6e5GM7TSLaM8CUrwACg/Q+v7sRTcnrbltbrynWRbjd8fdL61hS08ZzQF4tiaPVoG6uF5tKHcQ6oAemKyjMMtFbRt3TSzXOsB3JY9Cd49T5197Qt7h2SJRJCHbwjRVZuHqGyXRu6B7XAkBicZqOD9GWF1r0ElqHGZq85EQl6gLFrFABA3PPwBHlZnO83pKqd6efTlgnuRIaLbeRoLlccEpXr47DCzhedeJaJETH4MQDlM4HQz3BAfUvKNSLxGKXMhj35TEEEYgnVcROPVgUU/umkWfjz8Omo22/S/Bzwo+P1+rcrKKzGzGkTczJG//fd+caVSrhOuptDxq2lJvw1sU4uvZvdwDEuHZ1yljkhIdKNalyyaN0XVqlrzGaSKgxzz8/HxUtnTAm0yMRYRqoyD9k3Tx23eqRqjA2yQdTOUrLsHzGL6ZEMpa05vYtpl2WOzOX9GEKsuhAAqHgbQba8gXDOwUwi4ikXkGXc7F24zQLmiH3wyBg5FBau3fLzlMzMeGHTfwFJOoTEKNh2H+Sjb2kttt9/0smlnBos79X0MW9vpnFVNDyPm33ttTPFzP87w89yWXdqWVzcAkBQ1B6jTsiJXcTFwZcpiFjsdUv8qold/bfJv4R3Bm0BJk4eEojmQtHVUJPLBUKakxytCG46wg5ZAcwUMgavcFDPE8fwsCIZI+7XF4C+G0RbSZ5A0MntFUNCDLs1LbX/3L6uQgERxt7DK7Bmi/JnZk8Uur8VFREMDIIG37sSOtaxKCRqDUbLITmz00lqCcBB+EVo2nWFYeugd5Ysat3HxpB56ukscekrzV8zngga1Z2MA3+zRUE2/zVBNq524wJHOQe1GLiwEBKHsQy7Bf98zemqs1eFAa2dVQr
 +UOwHFIr
 5RFuaW10aNLc71db3ZJgGcAer3XdFtJ3zyu6mevFAdkxWM8gGU0JtKPI6GYW+WR5xZYja0cRK7ot6uIIQDG4Sv06b3Wy56lui32pvdPCL3u3SrVKL3crgYnw5yh5ZglsBQfrgtWjm5M2HutPSI0SiiYF4MmkaKbReaLbhmYfUdbiIjtOl1OVe0crdbqgIvP/yRGsYivNW6NEK2nyThFmTrks7qLTA+yKwmrmb5aBcQ9+kDPfW+V1zHw1IkAXKX70JUavVA7175r2xKhsLBMYUwtZ1deIDkGuQ9D+T4fC1z6xeAhSitEqjrG7Nnw3pkOYjmqy/CevwWxpjaX8H2sE19yM7PcDbpyKczxxJfZoU0iNg+3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Fujunjie

In my patch series,
1. I am freeing at least a single page.
2. Did not change the vmap area, only changed the nr_pages at vm_struct
    and update the pages array.

Rest of the questions are addressed in my patch series.

Feel free to review or test my patch series and let me know if you
have any suggestions.

Shivam

