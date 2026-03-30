Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5AC10D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAFAC6B0092; Mon, 30 Mar 2026 07:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FCA6B0095; Mon, 30 Mar 2026 07:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EA66B0096; Mon, 30 Mar 2026 07:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF8B16B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:56:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56D4813B275
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:56:37 +0000 (UTC)
X-FDA: 84602577234.15.579941B
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4C6CF1A0002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:56:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RQsmH6Uy;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871795; a=rsa-sha256;
	cv=none;
	b=EoObPclexJO5nVuBRMpGbv/ZNKPxYCG0hZ1eDJzUD9I4sF6nzH1EIForfPS4rWas9w12fO
	T6CkHVKwkZCBX+7gSdGwPm2CNfn8WjHKcQ9Khk7IzzNmLsGNCSCxg+lV/Ajz8G/fWQNnHH
	uzoyWk6BR43nJezrsbZmlNxIVzG/IEQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MX3sNhAhPpZu7EQC0NlANj9qKvyIoy92fBnjmNHbYpo=;
	b=gBDcgeLa47YXuXBvRpSvkrzmzRLSQgqoXM1h0cwljqdjFlvorbY3RDEcTCEPrtN0lBzuqE
	wbmIc9V1IhF+CZwC5o5G9d+jGmzs4c30ZIBzI9KshjB2JY1hDq5kmAoPcciHm1/URbp4E5
	gvc0SN3xw4CTIhvcwa2BKd9Oaf4H4pk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RQsmH6Uy;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-485358f43e7so4933735e9.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774871794; x=1775476594; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MX3sNhAhPpZu7EQC0NlANj9qKvyIoy92fBnjmNHbYpo=;
        b=RQsmH6Uy/f75GLQfI5cSmcoyUNL8a9b8+bfqR4rm8DznBq1/Q44Awb27Knm7eDclAc
         RZHq6z+GNWY2/TQ4jnCihxjmZNF8CWEXBh9x+MwlRyG0y1xwYdDX2wUeRwjwi4itCYaC
         PlnhEmsUmEC71Waly56c3eGCdWznIqrFIyoGqifthBzFxnmA8g0dM0CfUXXOmPsZGg11
         jxYKuaTmDnCo/N4ymrXdrx+Dk6X27SIvhT9GeO/ZST2X88CyCZGALmlVzNR281ELMB/V
         9KUSLY+TBnM+oBSpp7m32ji1rUi4pBIURATJifi7G897NnaF8eG2G625CDG/P9mtK7NO
         o8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871794; x=1775476594;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MX3sNhAhPpZu7EQC0NlANj9qKvyIoy92fBnjmNHbYpo=;
        b=T1Pbh1nEqopUkiJeQ5O/P0d2ibIPncvoieRwoArn2+K/+TK45Y45FfP93SF0NjpyB5
         VRSaqsV+/SV0j8Zhww+q297m7jaUUPtXxU/++KQY5dOUS3wC2Knm4+5sTMynAWm3rMjs
         rdTl7b7Se4IO794vq+7MDxyjGsinTt6USA/gE/TjKyeEtrGzGiOzYy2IR/nNP8jfg70C
         z6WYvsgwGh/UU0QT30+V0FNK3TLgMzn1Uf6h0Qj2ryF/kOhGvM+M3GKUj8ZRD1hcg/Ik
         XdPqdNffdX8ERLmSZmvw/IfihalaPIVZsTEwVs5JjExw9yMOK9MB0FANoYBw2Wrac5Z4
         1cNg==
X-Forwarded-Encrypted: i=1; AJvYcCUQoo0B6AOAHMf9qoz4rroZX+2OAdrCgcS+THNXSBZ1hlf/f5YMtUssUuEWeI/8AVQcJwfZ+5HyNw==@kvack.org
X-Gm-Message-State: AOJu0YzYDhB8p6l94vjOvsylAZw/nhd3E2o47UueoprGAw/wEn7vXj74
	1H84XTcCdDGHWCmxaOEaGIfmju38m88cc44ij+bUY1glwiwl3i8L62wyNZFuyy6ydtQ=
X-Gm-Gg: ATEYQzzgIOBL2PRLuiHengr6BfSkkjoAFcd7gKtG+JrYenRvvdYederLV7gFHSJCGut
	TewgWiUSUvDMwbVdvksyV+pw+ztmVOljFNrqM3WGAGzI/L6JLkh6r0W4kYxX0TYsQOBZVq9ZfAe
	fk+0qFO9a7LeL2HwdA/2ojleS/fTGLPNZ2pU3yQrjl97uwvBoOPwZc6Qjkd0vLwyWUozrO85OSj
	sFZarpKOBYDXtXatFLT8g2rtQptcnQkAj7Y3lDeN/yQODsZ+1iCoX5QXCdGhjClFCXEkeqNew6l
	DYweZ68+6/dzJ3LrsZJBuuBtCA89M8PHKRpT0Plg6Rwm7OGuZ4tyVCu6f8/b4nroO+oBYL1fJJa
	u5RhclYhtVqb15VAkOgEnT3TnFsh8h8XaCspHjLFSJYd56n6d2pd9NlnEAP6g2I/3iTBw9SujjS
	CERUndnpd0rQ74uwA74MoiG0yHnPKQTsC8MqJsFdgvXyI1SDoAYAHH7v9FzIe7aRyh26gH
X-Received: by 2002:a05:600c:c178:b0:486:fc61:541d with SMTP id 5b1f17b1804b1-48727ef6475mr106823855e9.2.1774871793473;
        Mon, 30 Mar 2026 04:56:33 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722d40741sm287373255e9.13.2026.03.30.04.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 04:56:33 -0700 (PDT)
Message-ID: <f031418a-af79-41bb-96a9-2f88ea6ee3fd@suse.com>
Date: Mon, 30 Mar 2026 13:56:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
Content-Language: en-US
To: Herbert <objecting@objecting.org>, david@kernel.org
Cc: krzk@kernel.org, ljs@kernel.org, hlcj1234567@gmail.com, sj@kernel.org,
 akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 kees@kernel.org, gregkh@linuxfoundation.org, brauner@kernel.org
References: <20260326072737.341964-1-objecting@objecting.org>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
 <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
 <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
 <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
 <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
 <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
 <82256A72-42FD-475E-935C-629964FA80E7@objecting.org>
 <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
 <6deb290e-b168-4de2-95f8-fc784ed31c27@kernel.org>
 <25688dbc-cd11-4137-bad4-a215198feee6@kernel.org>
 <19d3e3d3297.190bc89f62053.5899613485100180781@objecting.org>
 <6f045727-91ff-45ea-842b-c78ea61ae4d1@kernel.org>
 <19d3e5747e1.83b0f66f64051.6129386944586321569@objecting.org>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <19d3e5747e1.83b0f66f64051.6129386944586321569@objecting.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C6CF1A0002
X-Stat-Signature: 94j5wt85yfea6bht6z5stgqcnxzhzqhi
X-HE-Tag: 1774871795-18830
X-HE-Meta: U2FsdGVkX19cUNYKWAwZOoTK1GT6s9pgU5mSy+P2KWG3eufprx77IuqjT2Ho7HC/L/ndPZwER/Xa9HU8005VLo7HINwDVi2dCCPh83dpU2tz97xrYbGiJJOd41shz7PEyM5NSD/viQ5CXmR1IPK94GZOEYdCpXlx3rhRyqlhtXZRmFPchS8t7fZKNV//VsWebh0iymtrb4O5Ba4GxSnasC21CCPE3nu2+EU8MFTfGXB2h1PcVaJvxAbFgGwBz5VLI7nYwXHXO+9F+VZ8NQxhiJc8JmRUi90Z3QKjyA5zxDCjr1yt/i5yl2OhRq8pjhb+tNZFG/HAkg7oNh0slesTb/FggaVriNQ5X29FFmDzJRKTD6buyvXoBzGFiXCAMTuneAnjD3t+MEnqVUPoycXKIDolEl30j9c/S0ePZiUcSoYcXzhXreF2JvzCR7w1+EmFkvYiZJs80XQ781zS+3u/VHfm3h3LAVZ5WUi9y8x+sEb8Dx6XDC57VnOyT9J+SpVY8026TRhwz1xqsvxHOYb7Un47yjkeLBHebu7b36jzuL+q9/m3vBYg7aFZgGwtijGqa1/IJej/b7nGYz4oosO/xaW+qmk4KkTAZ+XBxPNPILkxKeVrpzjgtVaDeHOT8RK+p0FTnyXPETkX45+YaD7sJUEfN2UrxGdh4zPwGOcAH5JjXw58iTPMC/1U59wWtuHShsep/BivPyokmuR4aVUgM34TSP8CObrof2wIpwqIenA79MjKspwMd+tf/oBbG1ZwsNH7HWbkoygzyOClhZwi9Fn5bAbqcMEsDqEm+pYPjQuPxyNJSfYu6QK+vz4EhDWbsvYv1SnU9VCHkzMP2zvOQsLmwrvSEkMb6L94lt5Q7R1LCV/n9x3hYxpV+9O30NwCoKWY/x3zT/h5xDvF3JIEp6pUOKLYdwpCdiLzo3M/zJVX29Z1kw1T3NEMoWRtLn8xFVmvvkRqeBOxoZK32M2
 Mv1Chqxb
 ob63o2VAoToyHoPMtSmBvirl8sTIMg7FjYFz5CeeMDGjHxJONP+veVdPvVyc3Mf34VDJm73ErpZ0rCdD4EM5BVXw37RvY12tMGBs6IlG6E+OY+IEQLst9dkeI6Ej5bhHC1VKOAA1uJcnsVh+PkmHLKLCa02VlUrlPu5mWADZLhBy/4TIKtUbBWujqBTvJMeMDbBh4/JSuvW6i/ro4dxfIdRhMRXUn4HeyhlnTMxy5JAk4mtmWZyNAy9jm46jy3N63EmIhsPyOym1Q3eGh1cJw6j991iM/oA33MbpkNdzLa5Qj9PQEBhJGwSrUoA+Pab8Q9lPYDJO3alKfxpzJLtcqgdO+P25wAkXabvYL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 12:43, Herbert wrote:
>> >
>> >
>> > ? That was me learning the ropes, by making a patch to the QCOM subsystem
>> >
>> >
>> > and it was a genuinely "ok" patch.
>> >
>> >
>> > May you please tell me what I did wrong here.
>> I thought you wanted to "take a couple months break"? And I suggested
>> getting a mentor first.
> 
> Yeah, that again, was a bit stupid of me, but sorry for breaking my break, but I wanted to try doing a human patch, to see if I am capable 
> 
> 
> 
> 
>> Anyhow, this mail was sent from "Herbert", which is quite ... confusing.
> 
>  
> Changed, it was a display name for some reason.

We've heard enough of your excuses that look less and less plausible. Just
go away at this point, please.

