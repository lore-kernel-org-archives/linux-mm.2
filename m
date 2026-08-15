Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD066C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 04:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74E196B0333; Sat, 15 Aug 2026 00:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FEDB6B0334; Sat, 15 Aug 2026 00:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615076B0335; Sat, 15 Aug 2026 00:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 386816B0333
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:16:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACF9E1602EB
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:16:03 +0000 (UTC)
X-FDA: 85102191006.09.06E9E99
Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	by imf14.hostedemail.com (Postfix) with ESMTP id A1F8E100003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:16:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5mZEqQ6;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786767362;
	b=J9IpxBHFwcER1dd3Rp4k1wM+nY/dEMnHCoY6jIY98ml3uuv562RnSk7GyM7aQo414/1PFi
	FPfSww1TN4jCVKDD1sYaFs3Gz0YY6Z2L8HysqYufa5DDmGQZ95Drie5aBRkSMNQmXeMz4B
	nX24OZGHCVtYoRQKmcLUBjS5OJKBJaM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5mZEqQ6;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786767362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y3K7b6ckx2Hltas4lYepUcEXu3vNRV1wOWoPphH5tTA=;
	b=7Qp68+iZF4CGJ3rfo32g2XqLwrsRWNpf9htXlHV6+M3zYEQdmEv0vIlM1AWn5oGi0UeCqX
	dE38KdTVl20WNSPKys2AwisFi2XBOLzynHkPJmvrdPLAG/UTS9LtftbJwwwS2FAiGOjOMj
	j9lI4bsdQUnBFEUfeZUxhpQo1676LDM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=y3K7b6ckx2Hltas4lYepUcEXu3vNRV1wOWoPphH5tTA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786767359; v=1; x=1787372159;
 b=G5mZEqQ6LnD8bSDJbWEXDKeLE5ZYVSDmjjWsYAUu/ygOFUgoitVo2j7uhwWyKlbDoV60AOq7
 aqnvdU7Tcx0Lc8GIT7jruvfhlwTof2bhhVgksqTZnf0m8EHNaoXxqlO8o62FoM2VKsgiSUwNhOk
 Rb2+U00Ju6i8A6p0Wk/0HeX4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (183.241.20.126)
	by smtp.migadu.com with ESMTPS id b647dc149dd61193;
	Sat, 15 Aug 2026 04:15:59 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: seohyun.kim@outlook.kr
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/rmap: synchronize lock and unlock target in anon_vma_clone
Date: Sat, 15 Aug 2026 12:15:51 +0800
Message-Id: <20260815041551.84041-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com>
References: <OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A1F8E100003
X-Stat-Signature: 5dgbsbu3wiw8wnu6fqrj7my7k3mkiybj
X-HE-Tag: 1786767361-804493
X-HE-Meta: U2FsdGVkX19Z39oyAfEiNETNtMeYYRnPinge9rqOEUQ7umWTwmucOkuD9mNYlln+7dTzr33ZpDEmoyrqhngv4KJK6Q0Anus90jjhAl0lZXtcel5KePFRPApac6zCUiPvGCdLfrV+rbq7gBaAPgeQ/32EHwVPB3eem7avvCUdsKO9ci1rJriGELJHzqApNpLl0g1ulHkiSLtf1hqKmtz1CgC7jG9KxcJx72s5A406KPcARzD4EDkD95C+g7k0IG3+26f64pTE5Xzn03h+hcwgSQG4D5MWSvD+jXCeCtFOIvK/nCcifwcyBZQgvgL05yTWZ5OR/MN92xtCIgDv+0/qPvm74qbR7Ya1o3IpD5UiRXxbd8CxFowhZc08tInSzFZ7dpE+Ms2rDIf2+OKMPwQYQSCAZP9Pl+9Ul+MCMg4qliE483SRrDYHbTRMQdzA4wTZwdjOIlWA2Z08oLUuijT7X/rUqVrxgRhCdsiVf/bUBr44VpaREN9eIU7L5i4TV/Ab+cgNx0sRvcDlLyddsRnQtXNb5wCgeFVzxqBRHj6jJjjaa4Vw3h3UQsoGWlv1V/a08G4TVIXTSaGo6qFe2/nYBJ2/LjDhntftLN6/ss0M8ebZzgptMWEfL6wz0bxW/beh+Wd+V4orUdtvU/zSTUgodiBGwjX5uwXCNS/xdnfSIeLRQ85L6pOFZ4b2hH4riDKaw4fgJBphCi2vYdvIjqqXCrBmC/OnfO/KzeXQzavhn+YZZM5/pTunicPpIAOuxHOZ3sY52Tc0SnGoAwDeDZQYiN44af1Trva5iU14msQemgtI+0LXUHctNI0YUW1CqP+zue4UfsTUOnnfs7RGRmggX+9BUNswPKRsZz3atYMl/dWNBpidHAqsYgZJVZKTfsGJToKrKF3LyENQ0aRT0GO8SYwtXGUUmP22iMjVSLa7c/ZtEoXgdh9BjtYjG3JzYM+fdEfBlwDdAEgSFmR2WZY
 5G/s81fC
 qzqh59RECmaR3KkdbGaYv286CXN34WFkVIRS1t399LzZYWu2AKECF9WzoTzJ1KiO1f8QmtAuR237dmKIuYZ4PCLvRyUvXelu9k9u2eJzdOuZ4NbPbKC1dS88tXqg29qKwya6wuJWh4mvA57lEGj9xqkRZm2BMyt2NAr5KhwfaeHKYHh9qSu06pUg2SDJULDJz5GeWrzDOWKw4GtYVcAwUlaRHG5CystfB2U6LYrI4FLcSKaKohGN9E28NYX9FAmtANS9LDJSY9+nrijOzq6jko2jmZakY57uoOULV8B0Gl6dwNQfQIZ2TJuTcJzKgc+MFcNh3bciYuiq9FwcJVKua+GoLT7KMeZRMoeYxked8ZHf0Sg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Aug 14, 2026 at 03:30:51PM +0900, Eric Kim wrote:
>Currently, in anon_vma_clone(), src vma's anon_vma is assigned to
>active_anon_vma and is used when unlocking anon_vma after linking new
>AVCs. However, the anon_vma is locked using src->anon_vma, instead of
>active_anon_vma, making the lock and unlock target inconsistent.
>
>Use active_anon_vma for both locking and unlocking.
>
>Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

