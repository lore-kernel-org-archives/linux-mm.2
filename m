Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58DF5C98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 12:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E1C6B0093; Sat, 26 Sep 2026 08:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715E16B0095; Sat, 26 Sep 2026 08:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C186B0096; Sat, 26 Sep 2026 08:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD9A6B0093
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:42:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B734DC0876
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:42:19 +0000 (UTC)
X-FDA: 85255876398.22.9E30F4E
Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 075A2180005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:42:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lVXYGt40;
	spf=pass (imf24.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790426538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3nGMV9CTrwS9xcsel/dvLA5UKRn0rUB5yA3qbzghtk=;
	b=cXRPUgCoGJsinjnKND8rxS2iEbbZNRrdRKvrLNYqz1EpSK98KtuXPig1sUNlJlDXMN2d2g
	UDHSWCNxgq0Skq323FBoGZblLh2zSAVRWMbB0QBQ+EzWvQilTQKc0vzUBR+MuB29tXN19V
	bUZOojBizS/8Or+XwucS/uypuCVaPVk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790426538;
	b=D7kGDk5ledohMaWjcvsWX3ILXxT+1cV7EVRxJyoNFiqmnjt5kTH2viCZplexEcmHJZQ0Nl
	I/KfQ/dP9q8UBYQZHVivGY/wexPhhROJkwqzNYFTnDnp4QWbKhycY0yWnSSPEgrnfGCPrI
	T6GqCXa/FRjFqMg82fSkq/dfzyIPA+8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lVXYGt40;
	spf=pass (imf24.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a0bcdf41a3so775702a91.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790426537; x=1791031337; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n3nGMV9CTrwS9xcsel/dvLA5UKRn0rUB5yA3qbzghtk=;
        b=lVXYGt40LRSgzixaS40BCaLQX8r4vzTICxG48HPJYDlP+Qgq/o58JhCOjRnLGniB4z
         i4aXiAe9q7SuznPAEod2HBxSuAYoRi4LEXo6ff7cOq9SDFidLiec7od5BW/HdX/Dz5Hi
         tcyh5dQ5YnttE0OnTcpbsZEmuNGxFRkYSJVMQ+PYNjkufL5Y3uynX8WVcJwRFjIiCwCT
         Kg+LZGDpfzBCVFCxFqt0rGbgKmzAXpG2uvrGgE9UKdzoBFD0tpsQy5GbANkZNKTV2lFS
         sfj5GBA6vNSPSuQ+Y2qizO83y2o+XV5sWtz0QPUFivz9MBKCbOC4f5zu4Oe/7XLQsjKA
         f5nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790426537; x=1791031337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n3nGMV9CTrwS9xcsel/dvLA5UKRn0rUB5yA3qbzghtk=;
        b=ZtOL+gUdCX3XljyMZEke2oT6zX0vygNX/7i521F5xlp7jjCKPtt3+VbrZf6h59PSx7
         JEgvFizQaAKTBXWQDVPUw7XPk3x4Gy7mbLX/DcgWOzH11V/hhn2AZdDQjLBqzqucQbaE
         n/CUuS4mY9Kq1SfqMMfuUT5UHxm8D3StD8AwfS50oYBaOe1QWwYZWDUS2G4h1O9Eiz9K
         0knJjKrUYJTX0KOTyicyyUm/XL6YkFglgUbUi06Z2EeUV10Yo2GcTNyVxPnEAO9n3jFN
         JEVtHBpfgx+/GwibqM0vqOolIlxs/t+gT+Sul9PYnLi4MAoHi4t1AstohDxoGBxgv8Z7
         pN0Q==
X-Forwarded-Encrypted: i=1; AKwUvBzfhnCRZ87+9g5Xy0aQkbVGJzjnZ0JYgd+LHnwkKJ40bGm3dIIDVjMmVAbrmq42qp4w6Z/xiSq2lA==@kvack.org
X-Gm-Message-State: AFq9FYJPtzdQheB2utDw5acFUkfuOXY+JplDgtr23n1RXERrMYSniS6V
	txvviHTiCcCC4Fz5XPmkpmMPYevPoriQqWCfrA+XoU0IPu+4FHCeeF8=
X-Gm-Gg: AYBFou1iF1eMec49uahblh325OaY0Njx5+FDC+x4FO24kK8tQqw8SWQdzBQEnYhUsV2
	mHZF3koCZNRVxPxz6XLv9Dh92LjDRAjb+vZODrL4mu50Sf9si/CbB99QU94Gp9O1kGUGKrLI/u6
	huKiTM1k+2exWYtN+Vhrw550Ny8gbheNyd+eUEeajjXXjKRzTsD0h0Q4X0sQJ0l1OAio2hIv6yc
	RSelyGLPcq3qOZ6Hm7G8HyPJreJPUUDviUq+suI9FRM8Mt0DVUYRMz9+QcapvGF6dPk+9MNgb/i
	49jf4uxgT6Tk6ijOL0gmWIBqEjYDru+jaIysOQ5wJ5nZhZ1h7/jBSI6D/dmtoVqdA+F2SNanweC
	cqYvOTf+kit/XWHA2p4I8jKE3sFhCFCOX3iiZCeAJYaE6wr5Trx79R/ZemEY22ORfmq71LBtMyP
	PF0lCsbjr78C0G6USSab8qeIetDnsyIopXLq/5Ee9pxc7RkzmMWf7sTMgCfrWIHuP4ZkhQjFqtx
	RjA5bi+Rb/GQtse+opBBGfq
X-Received: by 2002:a17:90b:254e:b0:39e:6a81:f351 with SMTP id 98e67ed59e1d1-3a098bb66b0mr6996915a91.43.1790426536797;
        Sat, 26 Sep 2026 05:42:16 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976c8f8dsm16337350a91.12.2026.09.26.05.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 05:42:16 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	rppt@kernel.org,
	peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kirill@shutemov.name,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Sat, 26 Sep 2026 21:42:10 +0900
Message-ID: <20260926124210.2878601-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924214811.19ef8af417d37071ed8338c4@linux-foundation.org>
References: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com> <20260925042907.2330519-2-donggeunyoo.kernel@gmail.com> <20260924214811.19ef8af417d37071ed8338c4@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 075A2180005
X-Stat-Signature: qknyrq6yaa44mqigkqudt54rwgmt34oh
X-Rspam-User: 
X-HE-Tag: 1790426537-939540
X-HE-Meta: U2FsdGVkX18drFy4erLZwuBKxdTXA/9HUVUCEYwn9lKxY9udNLb20nKWfX9a4tBBOVDlU2PV/9OnyHbEVTR2EI0rztq0vOhswk2EGsSVBlr2Kp93qhUTZNwyA2WobUBmTbR5t++W2j3rD+1GV7doLSpGUMm0YXjcvcoIJEVdm05Ij3q9XGNkO5R8cZAZ2kSrTqwlpfah+byBsvtQnk46ftPLspiFPZ453h9ddyyvYZG9ONA5ODT7wpSzN0EqqPpt51xfgS5GI3XiFc2U1mZwPKmmwFq/FLP0OrtxHFuzUlsMYOKBydNm/x5ryUd7UF1Ytfcu1aclgXqpDUxaOiKTE2JrRL3rwlU7q2T2h06WiAJHga/aDehDCqIQbfdAm+7VolDAxOT2zJovnCLxVJBlp8wyFOY78KLoGiZ9UhApsx7bNlW6+Md6MDePRnxO9JeDy6eWnlBuu0ci2RyL73EKV4jTjMAim2squ2JQ/ic6Bd2jv+8uJj7q4eCdtoijbjc1doR0OVv6HFwGOL9dhraYdcjPKy8PMLB9TdzTiHlfNv2PBIBFCEDJufHEkptwO15nhFgpZu/yTSC+X5vXYsk1yRDS/r1eaiZDLemqiVwSTwDRNWR/9J8yfgkn+Xy+u9MHxVmPA1XgdwlmRa2mBn8lZx68X/P52z/NuRp88E7I7cXLjSsC6T4OHO2O1AoX4yvBHdvwaY6lRbWiEoK+itNWeRG9nF3MrPXD+LVWqemfgvKj8YO9Kx3wZnKhQI+ODAn5jK6jeNYWFMF6lY2bOZXRDjC0oPb4N3nAX3ecXnAKCRpGS4sblBKi/Mx0XNWCeNHRp7rSiYOgnEEDlWpLOhAxFx0ygyeuUWQxA1uPWFWus25x0MGBTnMuaxtiz1WZA3XJoeR6W+FmNmMEv/UEfTGvurWEBgXWWqN2P/5PxbApCslORp99WtBUGvskHu5WrOZP9qKYu5UZpJLKfCHrQkU
 xaGpcpPL
 6qdHOtDXH1JdebA7Wp+JUNFD2MtBeyCCSVddMqiapA72HZ9c68lT2VC0UuUTT3djIRrRPAMQVNrXN2EKKNO/UZ7o1HHc67qOQk+IuUC+CvEd+XkzP7byVxPADlBVBK1wsNjFWJBEFwJihw8aL5EzlD0GKgZK9sZZJLEKhZ1qGK04JWeMyF8IQCeDcYZ68emB5lJuDpChAGWxwDD6YqQS1p/S/6Xhfp/aMnMNW/90lJoo88lBQTN86canqjUj6n8Dafu9qaDIocbnPjcpQGVOsafAu1+a/T1+R/pScPfgiTHjZRJ8IP4syH7UGwC8FJime7CDvsRaYuGXJVDkEKAWVb433Ukh/fPs9fjYhzm8rhoutlWwtzlwXJr+tTW8hq6FHfCF4TEn7bNr/42shMTslMQkR0/s/nddKhc+/qVCn9gP3dMQiJahIHzTE5VAGIimYfHkEOKW1CK6ocAQI4OOI9vA9ylG00x16rC9oKtU7EUfB97qFBctfKuwFfP7OMzEcv9Uv9QUtmz3S1vCfkq2LSsPZU2EX7r6zyhqU49xebSQjP4+3B0ZiX+Ksjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sep 2026 21:48:11 -0700, Andrew Morton wrote:
> When fixing a bug, please always fully describe the userspace-visible
> effects of that bug.

Done in v3:
https://lore.kernel.org/all/20260926124145.2878520-1-donggeunyoo.kernel@gmail.com/

> Great!  Please add a prompt to LLM's .md ensuring that future
> changelogs always provide this information.

Added.

Thanks,
Donggeun

