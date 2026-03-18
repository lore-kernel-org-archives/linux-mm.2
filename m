Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F3871088E43
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7983A6B0374; Wed, 18 Mar 2026 18:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748E56B0376; Wed, 18 Mar 2026 18:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65EE56B0377; Wed, 18 Mar 2026 18:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2B16B0374
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:31:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 224A6160167
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:31:24 +0000 (UTC)
X-FDA: 84560631288.23.0C84E9B
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id CD80A1C0003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:31:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YpGwhr6J;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feR+WZOS3OTfblzJeHeIi+2BIqJt5V6mtxKjgXtF058=;
	b=3v/AqZhcvj/RALoCeGP5g9mez7nPYolcAdlKVTnz0YBg4BDZUWAywNgksjxxa99XuYQTdc
	wAVihYxDEGLjb1e8soh2vE60wcTjur2D1lxqDBIJq1gWUBIe01BVZ1Mk0s/LAxc4OvPwQW
	J5Mqk/a/5vgqd7LZozrT6+f4zKieA40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873082; a=rsa-sha256;
	cv=none;
	b=i7jMmlyvp3NLSYBQlOwKYlypxp5HTkJpkpAkAkWyAR0p3fao8k692cxQt/XYTbUo4EPPGP
	EhYChhivHUbd7LFbzzzPOiKBUmofJ9Mz7tpkI9+6jkfjV8rVOGrUiWVWuzSOVBcMPU+bp3
	T2oyIZ2a8sGpu/ATJr3No7vVeRBY36k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YpGwhr6J;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cd7c372929so3397185a.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773873080; x=1774477880; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=feR+WZOS3OTfblzJeHeIi+2BIqJt5V6mtxKjgXtF058=;
        b=YpGwhr6JZWJDjDdmYRbcBADSqFEAOrn7dLzZet4BA4rIYzG12lYILp21N1T7nMI3mG
         o9sOJKIBYT4V8OnAQC2QeH587NZh39cqlrsYSYecEhbkqf6nNLVEa9q99MVchGzODgd+
         Q6a8+KN16B4vW5fbl+01n0fZYxtPap5Jglz+5l2DKWn0/QJd7XKRBuu6fxRbq+JYPmZo
         6zFPsO9QlLCxfla+FxwmgHgbIPazcZxGWakAH4jkf/XnAjXG2qU3+4p8nHMB/Y6SKxBh
         cH9YTU+DO0NCY2CS8q1W6li9we/OvI7T+20Fu27q8u6PpkLWw1bj9J+P7rNO+tRGTDWT
         uDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873080; x=1774477880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=feR+WZOS3OTfblzJeHeIi+2BIqJt5V6mtxKjgXtF058=;
        b=oZcGMYrucC+PtEgzhm7Ekwcwb05UXXUFZonEVfWG34wtjGUXxq4mE353zG5LRp2GJy
         ML2OLOA9lgn88Htfx9gUC6SUJPOxXOTRBtCbHu+furPEzo6UFWLxEZ4cWTMlutfiC0p7
         B9H0rDsKwioWbEyCw6oJJGVTWS7pt3fSty5zUrkoTzmLy/9z7jAjVqb2Gn5N28qjqZ1M
         Iwr56okEYpOFwLreVQCRRYcwVa32vfqW2sisf5un6CRDaZIBUNFcND/95ZEjdqhjlKhl
         iFOis3z7pcE2Sf2h/dtM1D/JNDdvj00XfmdLFo/7eIGzFTaDVW40N3MRmNsyLxdB68EV
         UZiA==
X-Forwarded-Encrypted: i=1; AJvYcCXHCLb7ZOIQtiPyRFKQcGfhizhxRxsXCC+zY6d9ykgdeLiaMSU6qC8FzEYOSYwVzzfVhAP2l0G1MQ==@kvack.org
X-Gm-Message-State: AOJu0Yzl6m1QSWLU/gSQ8/6iolrlW7CLbEDgVA22dI0lHUzj8sSUnS9n
	Hzu7jZCxOL84U2wwVEDPrvRMFWzfdCBVaT8lbqypDxL6hX+Pp+qgbeIt2h9FF508a00=
X-Gm-Gg: ATEYQzyX3tnrubdgQsBgCC7mfqbfRYu5l/By0ifHe755HpAS84xVRT8/OSQlnvLpyZM
	Yvx1UgRI7GFF6RiTDimqcuEwy66XRB9stdL+z/eK2gqHfOpsDU75Is4F1oVq3QUYKZVWj6Sh/Km
	cPwd0RhT02W/XnYmtIv95JyGfc9Gin46U+VFzpF9hI9tLKhRm+seUYcvC4d7BTj+yuwWybxDgsi
	hwvIQ8JhGJfb+uoze57Mx+oCzx66AP43kcwyHw6PulG6EV7B0t53z6ELvPz18OvD8+UAXioMPvR
	kZRlJx584Q/EE5hdyQiWrWj9biUs3Y96VIAdg1pI6cTvN3PPj6gKRUAlrNoAda0I8bEVPieBeWw
	VWsbzqH/1E7VHngjZ9/HzOotCELa/JH3bXRClU6nm/Glk45ZgTHwwIDvaD9YiwSuZ6S3uF7W4cH
	WLByMq2/i5oN5n62xZl/tgzA==
X-Received: by 2002:ac8:59d1:0:b0:4ee:168a:9ebb with SMTP id d75a77b69052e-50b148bb1f5mr65777391cf.58.1773873080466;
        Wed, 18 Mar 2026 15:31:20 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b135d523bsm32134991cf.27.2026.03.18.15.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:31:19 -0700 (PDT)
Date: Wed, 18 Mar 2026 18:31:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] mm: switch THP shrinker to list_lru
Message-ID: <absnshL4E4iXSC1y@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <dc95cd21-8e7e-4903-b337-03f2a39e256e@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc95cd21-8e7e-4903-b337-03f2a39e256e@lucifer.local>
X-Rspam-User: 
X-Stat-Signature: 5cj8ag789ydmxgwhirjwhrxidqeztnj5
X-Rspamd-Queue-Id: CD80A1C0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773873081-491673
X-HE-Meta: U2FsdGVkX19SrgE2wbcADsmmQm5EvUFt6evceU1rmAsYUpa4eEa7OdAesanKY/F4mWUwINx28W7cXICeYnYlwQtCUl/7rsjWPQYMZbau7V/T406FLMaUkPUCMpSWsI9NUTFqJpgTmq2kj5yVcD2JDTFxnMfFkQ2RayiVqxZd43AnlKjHexMeQM2iadZTSO5SFudDVfshxS8zcxpg4aW5gcEpg81SFFUgatQEax/wME0Z2eChZ4YjiF7Ob7+rIoc7dBbGWt5qt1LZn5ArsEE3rWMMGlbUlpn7oM8Zmms99nCudQhv100JoNfE0MFTWJDohn9V5/YxgGIuGOpH3ysim3iG9KIxPMGErAPjieBwrSTGTNVDf01dof4FWaN+n3kuzl70Rh9Ja9jh2YoWHTkDziXsy32+oIqZe2N9daHmQDwSSj9HeRsr0L9MuUsTUdiWO1m1L2N6gaiEkRq+TNcK1N+rPc5dQpXNWpG5VvYyKIXegQnehRwokRy7ZXd9ycEM0yqlTiX5uE/1XdL4eFdZrvllXNyLrFnKNZN0OKXJNyrQoNQq7PiiUGvSLxushyYeorsHXQMYVJ8UPU5vIRC6D0n0xA6CMqkSSN1k92f6UNAaO1ii2JY/TAmee6DDAfKAk6WNyrz8M5mOHrnCt4Vr/wLinkYCf8nYaenkWBFFIZi01S73OBMm6CfBu2QaTNJBk6SU4c8ceosW7Fxzi8r9kl4/nK2C87dTd86iXyGHm9oD752AdD/ybnzZ+A4/UQ0u92Neh55ikaG/0B3ayjvdP+/HPRV71n1JRWXDeP0P9U6yZYrKh6lDux36nR1JRFVuhmrNgfyOBmCn3wbbhBrEM4no/dcpA5WXcKbZXb7FXtzRnblm9tcSjY1TYq/YvQPDHTEwdidGw9xudOhbFmAyiBqeCYJBrcsiymiUptV4ZBE+rc1NQDfHfhFNe8URJx8L4b2N6mNLWUl5e5jtASX
 mhR0GHZO
 vCnqQDRjNibjTwk1apXA6Us75q5eKMDUoU5twpV4Dzhy946Ex+m40HzdVRqIpHys42QG6WolmdjCehYDR+AgjVfu65gcarw2beP6QyMJ2FNZHLDUUFBh+T3fICHgB1e//hO3tPJfdvP8YL9UBNolzjmERWsl4ioUURMq8Wcd2LfL8C4byv/ShFISC2LEsBphT6jVeKzAwGCElqjV3TzOiIh92a/m/gu+iMM9NqTkBmg3vcSBwsX9ZUG1kE7oWsVANOd4OPXOW+US1xAxvM2vak3ZY+1+U5l/5bPNpGseOeu7PZSpsF0WRdDfebSs+SAZJ/dail2Ttau62hFDfm8moa4dEBKGIjMKVnoCWdPSV8OCpMwb/4K+DlCyQH6XE1rd/+76yMS8GaNk3Vyei2Fcl4MQRrY2zMFnd796Q16EaVVWccJoPrlX3ZrDijOqYOhdWqiz16T3Pz9+eprZ66RWe21NFJd/p4YYaWpnGmxZVHAJDHl1koVlfVJg/ze8/gGENp221wZg5UapVU94VBBMCDRcSMfUQI5SGDRDfrX2ymwIcQLUX+vZWUfwnVD/l3UyQC3JeYv1G7l3PH+DxEjunHhvmA3kPNgGu18rKUDY0fKv+NzJwwy8U0IR6adDPmiSexnl2isDe8WgBceRQwy5gxIFF+p6ol9K1RHqOsQjAIgtKP18ao8i5xWLROA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 09:00:57PM +0000, Lorenzo Stoakes (Oracle) wrote:
> Hi Joannes,
> 
> This is at v3 and you've not cc'd the majority of THP people:
> 
> MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
> M:	Andrew Morton <akpm@linux-foundation.org>
> M:	David Hildenbrand <david@kernel.org>
> M:	Lorenzo Stoakes <ljs@kernel.org>            <--- (!)
> R:	Zi Yan <ziy@nvidia.com>
> R:	Baolin Wang <baolin.wang@linux.alibaba.com> <---
> R:	Liam R. Howlett <Liam.Howlett@oracle.com>
> R:	Nico Pache <npache@redhat.com>              <---
> R:	Ryan Roberts <ryan.roberts@arm.com>         <---
> R:	Dev Jain <dev.jain@arm.com>                 <---
> R:	Barry Song <baohua@kernel.org>              <---
> R:	Lance Yang <lance.yang@linux.dev>           <---
> 
> I'd assume it was an oversight but you're an mm sub-maintainer yourself so
> I'm a little surprised...
> 
> Anyway could you please make sure to do that going forward?
> 
> I'd like to rely on lei's file-tracking stuff to catch cases like this, but
> I just haven't got new mail tracking working properly in that environment
> and it's really too slow.
> 
> It sucks to rely on people cc-ing but email development is what it is :)
> 
> Thanks, Lorenzo

I apologize, there was no ill intent here at all. get_maintainers.pl
gave me 27 addresses for this series and I honestly thought that was
too aggrandizing and self-important for what these patches are lol.

So what you're looking at is a (poor) attempt at trimming down the CC
list based on who I had talked to about these patches at the THP
meeting and who I remember had worked on shrinkers & cgroups.

I can CC everybody going forward, not a problem. Personally I don't
mind getting CCd generously, but my understanding is that some people
do...

