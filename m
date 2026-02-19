Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E07C6E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 06:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26FE26B0088; Thu, 19 Feb 2026 01:48:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D0C6B0089; Thu, 19 Feb 2026 01:48:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A756B008A; Thu, 19 Feb 2026 01:48:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F031F6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 01:48:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 901B51C484
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:48:48 +0000 (UTC)
X-FDA: 84460278336.20.310685F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A9CD740006
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:48:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L4sxzf9u;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771483726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAmWyHA6AYZ//WnolpPECri0NGfv11ICupPJIysv0AY=;
	b=QOiXMinvWIEkv7WKrjS5IQY1VWgAaFAWkLyLnOgthaOxh9U6TTqFaPOm0dmJYiK2yEY/S+
	5XWgUgsa3miRfnw2nEAb0zZgNebIV/I7nMkE2/W/AzH2Pif5kE3xmxrtFQLiT/n4KAzsF7
	65CCXFGxhM1NOjIGRy9c8OJi3L1y+7s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L4sxzf9u;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771483726; a=rsa-sha256;
	cv=none;
	b=G0jCY/v6jZA4KffwXGhfu+GA3M+zmH55nOHnJmkHilL8yFoq3Vnyu3/zJ/WqX/hmJwSNIX
	O8md1AGp1bNe3zOI2pSqRDFPoZtoRlTJq0QwJQ2Mb1DYFOzDIJXW2yRSMG4iJaIsJc5FXq
	fbjmQopEuEcF01EAnNl+FeIN2XUVozs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 99167406EE
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77553C19421
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771483725;
	bh=aAmWyHA6AYZ//WnolpPECri0NGfv11ICupPJIysv0AY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=L4sxzf9uQZxApgNwWC9AHrcYe/4iI7hfsb2mkt7pJMcCqvqm0jBg9wz0113HQjHbK
	 ogXKiVuOebHKJHt5kWerWrIN1jRIbX9ViBriRZqomXp9hsJLY+tfSCkagEKN9tWLtH
	 iNgJpRa0Uin9WLQ8oEPCeR4ujU5sQFlW81/oRfZIgP8yz4zT9i1XOHXRJfmtzcRWG5
	 OlSU7FPO4T2pf1V/ON6VqLwBXLDUaPs7HpxmMk8AHvWR7ELyqx3VSi+rzd4b3yfEGG
	 5l2UMgejoHUKeIG0veir+BUglnwlJFaJWE4fntgI5SmvQmucyaVfCe+zcDj5VPpTIe
	 73Ef1bARxZhMQ==
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-649b5f5570fso841103d50.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:48:45 -0800 (PST)
X-Gm-Message-State: AOJu0Ywrzimy8fXBx/GTVx8o5OXILcPOpDMYPHJMG/i9tdwE/qCvCTe/
	sbyHu4ehago486ikPHQrL2CZEZtVXVjCuhl0zaPFFM9LTyPLVVH21dX+O1gc00iteroQN4rELXQ
	YuUnGauvYtflmf9/Y6kh0I1O5cMos9FDlYax0Uye+Zg==
X-Received: by 2002:a05:690e:bc9:b0:64a:d716:c8e7 with SMTP id
 956f58d0204a3-64c6400c0e4mr515899d50.11.1771483724746; Wed, 18 Feb 2026
 22:48:44 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-3-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-3-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 22:48:33 -0800
X-Gmail-Original-Message-ID: <CACePvbV7HWsDqBoPU+ePL2F+jGO7X0E9M_9HhrWQ5VghnVREug@mail.gmail.com>
X-Gm-Features: AZwV_QiLj1Q9kwxKoL4od6I0w3xsSLRzcXdYmSTOZOXM7thdLdCDYGSNTY7_BwI
Message-ID: <CACePvbV7HWsDqBoPU+ePL2F+jGO7X0E9M_9HhrWQ5VghnVREug@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] mm, swap: remove redundant arguments and locking
 for enabling a device
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9CD740006
X-Stat-Signature: sym9jywhw16wg89wbgbomatdkcmz9hwk
X-Rspam-User: 
X-HE-Tag: 1771483726-925665
X-HE-Meta: U2FsdGVkX1/js/vtCy/6Im0tAOkh17fw2pfk/MhioIx5CGgvjibyj4WWufn/ZdVMqIG/3r9k8r9R7UkSzz3oP/Q/T1WytjygNRkgPHdLnfr/SxDb6SbAqaZ4dzaKr4+N/18EQDXHOvc9bDL1UvZIy/l+tnAYtF8zYmUni4xvO91/KxMhBT3WzHQ/23nxRZbgpnaOSU3DAvtGsNl9iN3PzaNVW0IboA8MUA8+0lGQJW9yWNeVG1B04fn9djV9GEn/z2zsTpaWs7dQzi9lDaUoTIJHfP/GkIHHJOBc2hOlssv0cu2Ko13q4yG/1v73+F9q+Nzgyq66cMqRwFXYGOG4aAfZ3xVHlFQAiWXlpM+/ENdk3fxy1zCDYW2F6dHj3optWmDyt2KyGWQWiz+rBfkCr1RiUudyUKtYUnHj83CArhKqL+EZsWCHuJ/2AbtBSeUm6eSbxIN7sgdRAc5UDTtHIlVdsdB7LKenuVW/0S+eXYln5bPoMB2xkfuLA4yi6HE2T6Q8EneE1YiRvTsYyU4q7M2vV0IAe6maYRbjLXTCSvC1vKPYGV3uUZpLLdGIKIirPMigofXLW9MvP5fCVneBI3MPeXhsG9i7cDJuaYa0FrsVFKxS4qQYaCgUaiOQBSbBR/AcoB7Lt1d6QOZuZ0a73jChMJmQHpQLUH0WEHJuZT7k0l5ph+Z8DCr9inTxGvOACIs6u1lDa+pqgrgPer3EC4uYzAOOHnrnluPys5uIL0KScPk6HW07SXFglzCf9+26vvavxFWUnyPXhdS/F+eU8s1KBJC7bO3s4gDazeQsEM07+Z81PaRji2A5YhP3HdfnBK5Qgp/Mf+x8vb6xhZgEZoO3Zub3Fai6V5P7qoL4XQSyruad71aJrRmZ0kTioZ6McckmbUtn00NtxAwb2dQhpscN6qSSZ/0FFljjZCMhpYWfLGDNDPddyrDxbqOsfyeLV1/j6xdxSt8Q1GcpFpL
 lwQ9DTUm
 64Owp5CvfAWE4jfCIaDsGbrGfXvC7LUVyYJ1As5vslwMf9c13nrinuWbe9wGOOz9ohdauQ1+cwzFD/9mi1wZlhv0tay63P6weON45J+2RhG6Ppce9P0+QtLxC5/7y1KzN0JmkN/GiYQUWQW3Fex2QJLNWDxNTw2PybFn0ZwUN3o/npHhzua8HF87lgeiUHw/90lsMeVAE5HR3S3CJCwcvdw8VTPPPE/Tdg9+7Pb39jdhyC0rVCWbJGVR1usz441cQcuctRMhknNb1fpUjs0van88vXqLPFWgZczmTD3fLrlaX4mq3rverJi75nsMt8aAcKTZYYGeGel3nqP0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:06=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> There is no need to repeatedly pass zero map and priority values.
> zeromap is similar to cluster info and swap_map, which are only used
> once the swap device is exposed. And the prio values are currently
> read only once set, and only used for the list insertion upon expose
> or swap info display.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>


Acked-by: Chris Li <chrisl@kernel.org>

Chris

