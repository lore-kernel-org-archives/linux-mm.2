Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88DFDCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66A48E001F; Wed, 22 Oct 2025 21:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16788E001D; Wed, 22 Oct 2025 21:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05C98E001F; Wed, 22 Oct 2025 21:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC4BA8E001D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:26:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BA671298E9
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:26:15 +0000 (UTC)
X-FDA: 84027638310.06.3B64605
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id A5E0A20009
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:26:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RaY1k7Ug;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ano9/YQNDNXsOPFgrKsrcHGubIIri3HGnZ6CPUeVE5Y=;
	b=k1wnS1JU+3FJEkR5ba4BHGL7qsPZngNgq30zStsPZFDwehngg9ARaDvMQ10kcdCzzWFC46
	EPuK7dAcvrA78PBlKjqcDbRiDhhmKQiFZooD/T+ReCjUj70GjJdlmekDEEJPy5zI/WAn88
	aV+CC4QrDuCOpucJ83DlgrAr6TN13jc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182773; a=rsa-sha256;
	cv=none;
	b=dTrO//hWaw+N9gkqoL84LIp+wG0eDarxS4DdduXbmWvvH5xn32FnvL/vciFlTM0hb8fUkx
	JY3P2E8M80d2O4lNc5i40WrkbT4oWFlqM32aqZolSNLupP8YfADQ7uGg4f3euIZT6sMckE
	xyd7QMeQf4P/u3J0OcryqljZFsfXB+U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RaY1k7Ug;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-77f5d497692so328908b3a.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761182772; x=1761787572; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ano9/YQNDNXsOPFgrKsrcHGubIIri3HGnZ6CPUeVE5Y=;
        b=RaY1k7UgjXDBA63TYKxUG1UJhsOiY9CN7a7Et0k5084nk7AxdGdOXWuWff5k3QWu/j
         jdmQmBDUFAtE1iKueY8XpwpX1WhnYblu1rRI+0pK2n0FXf/16FBmHhVrCi6wnSa3EXxo
         WXagWih9fwvcLjKxmTdgvIEMRta7XAEMXHxzd8wULtczEbyKeRoa1OaXK4obBRSgtmD1
         VD/9SI8eRiFaiuxG0O1hYpOaAcVhg71S6IVu+4y0oZ3oxhBoUFfF9KvGYqfYby6otgbP
         JAYssH7beHZQddognHBJpa6vntEvwJ2XbPRIg02IfTXMvuZQ5/1kRpKdYD4CNSkca9K6
         Dggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761182772; x=1761787572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ano9/YQNDNXsOPFgrKsrcHGubIIri3HGnZ6CPUeVE5Y=;
        b=uJJivDk57VBB1ui8+nyA7yfuCE7nQA4T4WSx0nbxZuw4tjDlr3qhqBt/fFSuvjLBPF
         dRP7oMyQGrN2opQMGYl0ZtpuJS41rTq/+dDi3uAhrADMaohdgTp0Jyxa4A9haTGD5e7d
         jbb9BRwxdLCp1vv7XDuZWMQtfpjK4rDdq3ioavSUbAwAMZoBan5t6paxWtdwzWy6QBnP
         5nhlKqcDKkt+3vJjIo8IKdGCbdP7ydh9Nw6VOg7AwnFJoloQsldqRiLgZRmkmrailRaM
         XJvbEBDVy1TgaBdQfjcpBJOHwz+E2ZYMIE6TNeXbzZw8dg34MWdY+gqyiiEXd8yeg4Mt
         29fA==
X-Forwarded-Encrypted: i=1; AJvYcCU/6ew87n/WsWGixi4XxKF/J7vTDI0IZITKeXR493PnMUov+iNpdEYvPxboZ8QlOi3UQx084D7XCA==@kvack.org
X-Gm-Message-State: AOJu0Yx6w29UNRfgCktYm2A3+rvcvSIr8aZfyts4jiNv/c6kMcnkEsx/
	Irqo/JF8cNIcYR3BDKRkfndxURzg27slJc8ywqWQvizR8gFOqLWGPpn7
X-Gm-Gg: ASbGncuj+rM/GOzmi0q/1FqUTx2WkXo8+HEqJqPcHdpVMzGTAc8To8JC6zmRtyiikMC
	39PPFromRnT/rHMiTHme13YOdjnx6j/y2JtretVXtbSuf1y5RVN+z15SY1MSznLx2GTUBwRKST8
	q7l/FUQbLwxM+8HhAMBPaPe7JYuWqlujMFvhUjHG41nl5unnO86i/DzaptotkO/jyM/ARQKwRUv
	LkXexQM7BFs4+Du5V+Clykcw58a1E6WFC3XQQsIE42kGiQbUJ09JbrsotiyhSHznE7QmLBvq8kN
	1UYGJMU/fmqtWqu5t8gpx/txv06Ig65IZUdR/VBxQRe6w23/Zcxea2b0hlOGTjyBL/bDVmI6CxD
	vUh4hl729HBKMYozJt1FBFceNsevgUa+zW895LutQrnK3dmGYsl8yCeLjEcrYI+LILI+LNgkUfi
	HyvSqi08Ntyk/HRL0NYltOSVR2k+YtK2t1W8ZpP4Q=
X-Google-Smtp-Source: AGHT+IEvBNSL7vlx52ZtkHb1Xk8Evd1Uy+LDFIqzBn7+oCyo43HBNEgCTRgmVCSv2yI7yzNjD+DHGQ==
X-Received: by 2002:a05:6a20:7489:b0:32b:810c:2ba5 with SMTP id adf61e73a8af0-334a8652285mr31519248637.59.1761182772458;
        Wed, 22 Oct 2025 18:26:12 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:1af1:e76d:71f3:4e0f:3054:cd47])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274bb3636sm610575b3a.61.2025.10.22.18.26.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Oct 2025 18:26:11 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: richard.weiyang@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com
Subject: Re: [Patch v3 2/4] mm/huge_memory: update folio stat after successful split
Date: Thu, 23 Oct 2025 09:26:02 +0800
Message-ID: <20251023012602.14780-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251021212142.25766-3-richard.weiyang@gmail.com>
References: <20251021212142.25766-3-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A5E0A20009
X-Rspamd-Server: rspam02
X-Stat-Signature: h5tztj7c9mcnokfiamcxqo6dpr513ech
X-HE-Tag: 1761182773-111296
X-HE-Meta: U2FsdGVkX1/F/D+IqP6acZUot6MKoQFOPZ7EXBZ4JIBTrIMZLXOjqSbCrfa0gIOh6YZkkOD62miuc01lSDNQ4fYoEHsbHSgY9Cl7Hyt79pl7zLxk+ydo0kRSeT5KkkpDUAnMg0ie67C3yj24JigPHq7jIDvP0yIUgmV7cEMGE//92an/cdkit6Ith7JEw3SonMtcnYXhRxw8SJzAeYBlxiay7lFjvM1Es5Ab8JFhRd1R7LA4cDukn8HqRncpoI/RnyV0d+6OylOgnDjrZ/FXdj4/yxmS4b+7dtV3YUY9NZYEZLUt3D70Ej1ECS1hxLPZj4u5dQ4SpeMUmioYrh6Q+slc6buVHRMS0z3vmJfcIBIN87jKDQprjgOP+xpXivOKf34kSurO8Bml7BVHuFJ/OrUhVzkipqdSAlAFI/rl8YZCIvmpiEpxkBnNxZOz5LCRFjFm60goIJWG7BghLisWuNRMSdl2tAZ54Ri0exGNZpGEh+OgjMbW3NVV68to5TA7kVmHTkrD48jRROCMJBq9wFR1XrR/KJoXCoqC15V83vkfnWfNOlE9wG47335X0T8dIOXx5ZGy8R++zru82ZxnnIqFG9VWnaudl5XFyQpGbETA9OFESR7QIhp6SKtzHqF8npW4HhupMsQ6PhvBDgaDQ6cMkeOWiOO+BYINBGVDVTooi7uPSmyCKAmJicP2+cBeJXJQol74l9VRIoFLZ8S6B0wF611ITTQJuxSZZ3qbdC6UyzG1Ub6xOuXVRMAThs9R1wrGMfP59Ie5GDeTXked3ZHViLRPPWLMHVVciU0Qx7F0tNLFulTsNoIhqIQ02MJyulRyu6nr680E0j77wl9UMqKtyl53LLuud5/1D8xcxKJKqfl7+waFSWhZ6WlMGf4B+DfBLelv/Py5qMfTxkXe51/cJMZ67CQHA0iZMoyAH6kkE1t/iRdsdIjGGXRuZbKZGcksMLPSQ2RtxYABOz/
 hG4dd/Ib
 4rA2fpQdypjhpUNRl8l76961sJNWqovR1QvLK24A/Mjge1sjnRGd/EzsR5r8ts//eB0H8EEy42QNCL2++GNWmwUSdS9nT8oLvopPto50AL2MeNpvicKEDuBF1qHm2VVP9X3OtfwXYn9O02PQullzGhewTLE9RcU2Ci9sJ6fCeAonpMtxzOc26j+rvA+0lPT+k8rZYCwgmgBKxHb2gG6+EYu3TJdv4fzWNBc9yhDfK2W8lHZ3XLjSwZsBWxI5+ul7dOtbTQE0Xg4VHHhHxno3Zi9cJy8wZlgHWchDT3t63KTAIf/GXWj2rMdqLJs5aYJf/dk8Xk3MleIcCMrE1pitT1TNfAYIaxAR56mzf7ap1tWcm/qZAVuKu8rV5WxGPxieCWsOfgcRWPhVq9HXuJr7VgUd8qpGvDDE9NupgCT7Ixhe2qgt3z5DqLLJdY8UwvavP14u+psPQ6KVcwihsEb3B44WNFtm020aQQscr0f/UM1d3V9bLeNhwmk+KE37YJcX8qpbYnHgzKyAjw4UUCgmWAWwWZOJcxov2OLVX4GvmJzI9pOXwsnSP9p4MUuFCwBKLHxbdkLU1uLP+jmy43rF+GmDzQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The current implementation complicates this process:

> * It iterates over the resulting new folios.
> * It uses a flag (@stop_split) to conditionally skip updating the stat
>    for the folio at @split_at during the loop.
>  * It then attempts to update the skipped stat on a subsequent failure
>   path.

> This logic is unnecessarily hard to follow.

> This commit refactors the code to update the folio statistics only after
> a successful split. This makes the logic much cleaner and sets the stage
> for further simplification of the stat-handling code.

> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: wang lian <lianux.mm@gmail.com>
---

LGTM.

Reviewed-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

