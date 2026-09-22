Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 091F8C982ED
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 01:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E368E6B00A4; Mon, 21 Sep 2026 21:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE74D6B00A5; Mon, 21 Sep 2026 21:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6806B00A6; Mon, 21 Sep 2026 21:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC51B6B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:02:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21DB41202FE
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:02:05 +0000 (UTC)
X-FDA: 85239596610.22.214EB56
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf28.hostedemail.com (Postfix) with ESMTP id 606DEC0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:02:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HI1EKSj3;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790038923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88TeD9vXDrKYbs/Tr89klO5h2tOaiUe/TfsMlOHrFjA=;
	b=RJBQ9xg0siaIEE9DTInmC94IWfDmwKpGmR6sL+CITSTowob40Qf7Djopf2pMJH54CcGt1o
	M6LM20aY0RTVdXgs68GQgem4rOxx93Z/FsOYYo6yzfaVbB4Rf4AP3HUAANaD1RdnJo4Tqh
	7+kowJD22efXtZKZlC2uG0yQvgySd3Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790038923;
	b=pRdGfj+6JRWEJFTMAkP9u/F/T/ny2xDxcJt0fbR21waORlA1GN6jL7cFPuVr3uU9POazrZ
	N66qRLCHahC92GREN7LAjNcvel48nuc07h27IUJkDsDv4BqCOxu9PujtjYBe/2fAuAynHz
	U8DFWGzHOhu5OiO9eqdDgcIfifL75y8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HI1EKSj3;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910c9ff1cso285624485a.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790038922; x=1790643722; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=88TeD9vXDrKYbs/Tr89klO5h2tOaiUe/TfsMlOHrFjA=;
        b=HI1EKSj3V9oGYHbGEQct/sWhsOVV2Qbqdi8dZhPdtj03WOS/KLdHsnIfyz/Ns+mIA+
         86+2G4FJfdR6wn4EpyxDYGGOVs3fXu0+0XJB6FcshEFsTKYCBf+v6qEciERwGvj8IP6+
         BmXggHuhJhBNyC7ZPiDBB5LAHzgioDnc4xwSYxsUbtzXl8B+vErqoCtyvJ9bkKXbvvBS
         YN/RAYJFKBhkw8YVkXBScZuj32734msxxShWSrmj/UA63Co1jT7Wo+yN+4jWKbBPJk4T
         mrOtdc3itcgZi2h73mSrdqjF6HL/ph6z339Sw1Xd9zj7iEh2AIGFJ5TP7fAfysUtwF/E
         DdOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038922; x=1790643722;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=88TeD9vXDrKYbs/Tr89klO5h2tOaiUe/TfsMlOHrFjA=;
        b=WkVD8wCMJvr+WGFB3PdBOW25J+HcTSCZKh8FmwAjP28hZFiykNz1aO/sGw6WgGxiW9
         PkCJbyeiDtjILyFvMQe8vsNbz8dcbA7GMR9XcFnOGivlug9IzngI02T633l/Wos7UxYY
         S8OIuGCakAFMPJ1WPfhz3WeuUTEvYGsnTPXNnBKFE+HsqlZw/5sE+5M/Au5ySoAHIzi+
         pDLv/MQhoF4xqkpIPjt9Iqefcl+jvuFUlBXSQrV7MP8nrfGaNeFY3Lx3tgiSEbKe+xoM
         qqEbMN+n3KB2uIT6mAgESp7jeD8FwYO+YXnR6tjxfhCXQlDiTh8kvr+ndJRsoKbClkWP
         u8Rg==
X-Gm-Message-State: AFuF++mVKz+wwYLlTDSyrGgXxWay2vblFwAaWsXZ7kj56bYdRFo/Tcsl
	gYah4bcpqe3/m3ISgRYgU+wtpIQ5k6HMqcWc2by3DHVpins0yGp4O7deWxtIcnwTpd0=
X-Gm-Gg: AYBFou2Jasr6HTFIhh+rzG7KeWOyIsSffQl32wRaw839oGdahglYTvtRXDZCnhsLvjH
	CE2RW5IA+BXb27Sw3sbweaRnWEZX9EGn08AENe9G+oL7jh9rri8PQ3C/uOlV3Fr16aVKsCbKJcN
	qq5yBQiXSiahxcq7PoCsqJBiD2jdXEahvBGyJhhUmTG3QwBTlWgxPwOEgww21/GUbb1WNxNvxb1
	FpFB8wbUSZvj364cgfPjuwFW9TTDO1yy27qGmlMBnn2PcCX9KI/K622wN/BwrYxPeseIRf+7dvH
	D8lfWaiLAtV+IgbUUUCLDJmDzZSrvfvBGW6cEEUpoNdRbHZSCap36uML5SPTdvYi8stGZFZxZ1H
	cYUtX1+U15Wh6DQJjl3QQ14WL7/+HwGcl9VCQQXsqa0bJJXD6KPAuR052FCwo/jzqrG1K7YU9lb
	txhElbi6vXi6ieSpoi6cJp84ZxFLFE/URODASS5U2pnsanKTzzJjZ/ptCroV1vcFzs2gXAdZaSh
	PjdrZTkV3g7n+/XnRWt0I17RkdmuGxdz4kTWzkpVvs4zFbTnUcZVDU=
X-Received: by 2002:a05:620a:4803:b0:939:f5c4:ae5c with SMTP id af79cd13be357-93c15e5c4camr314965785a.43.1790038922471;
        Mon, 21 Sep 2026 18:02:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1d17afcfsm6766585a.20.2026.09.21.18.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 18:02:02 -0700 (PDT)
Date: Mon, 21 Sep 2026 21:02:00 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist() out
 of build_zonelists()
Message-ID: <arHS2anjIvS7v8w2@gourry-fedora-PF4VCD3F>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
 <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
 <arCeH_aD5PUM1tNE@gourry-fedora-PF4VCD3F>
 <C7A2977A-CDD8-4EEF-9448-A130411878B6@nvidia.com>
 <arFaiV9iVgxIsZ1g@gourry-fedora-PF4VCD3F>
 <72A76ED6-51F5-4A0B-B34F-C8F5416F640C@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72A76ED6-51F5-4A0B-B34F-C8F5416F640C@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 606DEC0002
X-Stat-Signature: 5kbq6nsuuyj71keowscqxpebokonqqwx
X-Rspam-User: 
X-HE-Tag: 1790038923-249800
X-HE-Meta: U2FsdGVkX19vRHqrz1dgqvRw+HcTr4ifcT/TP2XlSZFpFukB5eUbatQSgziGu8rOWcqMqDtH5GqOnbAlum5cruiRbut0IdWa/ej6kVnUqKAHuSSIrJbYlGYqbKBZEN9inyU6xVvYqJ5Pf/A2AnoQGGypphwbvHmgJBH+qqAb94Ze8WLWd5Cvz4m44JwhGIkEq6qIR/Ahkvtl2JGqa65O4eTi3lpuh24+7gro4SCsHqYmE7rSOSjzz0tFW/oGueP+VM0WZ1+gDjO/sO6kTFZdpQnEpkjnfuIUnS18eBoqC19NWmrTD2/88+mWRh0Wl5dPse8uZun2z7KOzpfqc16hhr5vRdW1jInsfFxev7Rc5l4OINrR5L/wIVNvo1rgLCPqJAYwRYA2GIN4ZeQlYw9721qBIiJN6kvsCBrrSqYYRMB0CexwoThT/CzdPlk9VydRF0YcHUmMWYH5CW40E3Hu/pGL1mgn5l3+9w4A3pIyu2gACvAQHslsD4k5rWcHMaUKmc+B8l+ZpfZu1fcuvJ5cCb6MOgGWJcDQ1X+Ww58FQTm21W+PqlT3AoEmhnr+EoMbCd+R+SwkrnfsQHmw3zyPNxbLG+VQvwiJOQSmI06VMOZzdTt45rw9PzVrDd9/FQTXr48EWn5sx38ofvfjbeqwb5h/zOO9wGrEQ+bjg4vlNfTIzgOuoK9WxDvjfG+mbV7Vy+U7Bsiwp7QMfhIgCBGXbhCMB+ok9ViADJjKlBscwCeImcT37YiMPq9ejnkb3tzWN75mtDSYRvutIeKXaXZJgSqfSsb6WtRLYPijA3ikEHNUzgg2bwFJ4UMhVL+SxqmJWWptSZ602WDLCQA//6DSzXKyokTFpPIvVu/YtCk8lDeuZkOrxO8ivWGtNP3x34IlrhK9P8+LQvgp3xGLZXuJ3b5wFY687KpFhGbCXz4kg43BpwtlcokxakSWUUdzJG8g5tmV91kdU+PqqXsfIUr
 FOogSSL3
 pHax6jo3h1xkdS1dgoqWrdmYFqHoTEHpAMw8cz9HQTb7aEljjsbscdwSze/1lbKUjDeLf1e0p7/Ke0Af9VwCKVFULf9lCdNAZ4rNw5WGAKrM461D1kizqN7t4YPW5rOZ1cnxLmWrL2+uUDdczrLHkp78s3gA7lLsQC1UQJWaq23Uxw4TgHrB4y5Cmir/G7bQpByVdBYeH9KoFvUYXq+wAvYyaK002Llnd7JGMza0rI4wdM7VrhVGgb7bSBsY6mT3WpXPXkBPV7n369QJi4Nd52BLaq3QOJDiHhCxK0A78rvxMNlDGuevw/0rErGuMX7sJVNsSIQFcWss1RCLj64DVXmMNJ81S9Ts1CwRZmtIqYuGmKBP0L9Zg2Vc73g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 07:58:38PM -0400, Zi Yan wrote:
> On 21 Sep 2026, at 12:38, Gregory Price wrote:
> 
> One more question. What prevents one adding
> build_node_zonelists(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK)?
> Based on your above mapping, each of ZONELIST_* has its own candidate.
> 

Other than build_zonelist and build_node_zonelist being static functions
only reachable by page_alloc.c?

Nothing presently.  It could possibly be asserted.

~Gregory

