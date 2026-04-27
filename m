Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FDF1FF8864
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 23:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC72C6B0088; Mon, 27 Apr 2026 19:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76656B008A; Mon, 27 Apr 2026 19:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98B7F6B008C; Mon, 27 Apr 2026 19:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85A156B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:41:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24FA0140329
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:41:20 +0000 (UTC)
X-FDA: 84705959520.08.8BA3AC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9580E80004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:41:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YzjLCjcU;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777333278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cuj/cBK6GSOykEn6TV/D9GcN7Pz8N200Od5X+PR2Fqc=;
	b=hXdScG2MJSHuaOcBtQHt8gn/wC4BhkY9+CBzEbo/P//7ABL14CL8FqOUN02exX/QJ/pCGP
	H+8KL2QeXPMDLUQS1p7FBJth88AZYfo+0rESh1Oh4vpYCAP634P3XITZFj5IJIMJDM4JEV
	3LiBAL/T5t8HgF8VZUlwEmY1k9JWpPk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YzjLCjcU;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777333278; a=rsa-sha256;
	cv=none;
	b=aPw/B7Poyy83nNrkxT/nC3wF+i1xrwL+4ZrfeePZVqDVrCC2fDQynBTyPUuuM4lCCPC3zQ
	22b6PJiU3a2/SIAUuV0rJVnWoLUBAbIEfSKuyGGZPCyKPwGZYOlPgKQ50tzYorahgTaA0A
	Ds1V7kg5dTL8LIhZJFeIHTIWILoeyCY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04EAE60121;
	Mon, 27 Apr 2026 23:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF35C19425;
	Mon, 27 Apr 2026 23:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777333277;
	bh=j3eKjY8PPbVBXWxEaIlKvaUtDpsq77HAbJa5qEyE5Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzjLCjcURhfZe0BV5T9KU2DvNDTKg4XYXnNshRfqh3jFPqC1uRK8HQJezCNJd/Ifp
	 pxHQP0JaSRLm5pHQ4PfZwpY0UpRtZ3u9aVpPl/Y/WHeLyUl9I2BnVt3uSqRpiSAeif
	 pkZxeVJrhlgdAVklYA2LB3BhTEOTxuKDmupQDJ5xJFVgoHDVaTKSZSH2XVWIUMRitm
	 QwhW7yo+BcSmYQDntRDqaV9cZNS/8xkNqY6DfWemilTxfp1PPRZ+CdCoSVsajbxz9n
	 BTMjc0VJ6a5TB/fMD+dhd/a9ZkTaUDWlLXRAt2cfR8sjvx1eAcVzzI4Sigy908E9EW
	 i9kTXupYN/kEQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 4/4] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Mon, 27 Apr 2026 16:41:14 -0700
Message-ID: <20260427234115.154563-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426231619.107231-5-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fo7nnap78gxpdyo4ajgicjz6niopxkon
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9580E80004
X-Rspam-User: 
X-HE-Tag: 1777333278-314095
X-HE-Meta: U2FsdGVkX18t7yAHALEhfgK6OoTR8K/VzIkQkc0G+Rah+rqAcft2XD5w6S0tpPlUZoUA4HJjVfrO8KqE7Qb7fL5rz1BzmWru0q3B7ZFED2GL3RuiJg7HHyZx6xyGvL0nMSVD7QmFukTGiFC50NYUvOvE1zPCZl8dUL2MjOmSb7p5sv7lPR7EIGzkku7oePQl36hyIrVSUe8rxmMXfNugDvyZBXiu6qiyX2lvqBEKrWB66b6rs2echvYaUZRsWRFDLNUulH4VPmnHT/uPWEmAT3wKkNgwoAzo4L+y3TBz4kPsdagK1IvF9uAzyJaD5L3wPoPhsWLOPzRX88DfWMnt80k5ohbxAkOOkFichPpjA+4HsvWczBomZMFwW/5QRUNJIxEgbLFRvrs0DKW6SELVRF8yL/hVcRp7DEhW1N/oD/Tr+jRSdTBN1UZgybS3e5kQN4j4qIMCdeHVTCZ5hk3DCmP8zlbXTHKSscb6UFPmSk2EVBKcqNKQJ+TK0xatEPEzYHoJ0N8EHJ4psD/+peh+tiO2yqLnhH56uV4ikrM4GlIaQI2C3p2BBhnEYykNbHpbU/fVrREZbbbRE1QGg7ctlvynirVzfbyHVisnRaOWIm/T5W+ND+Jq6r6lEzNHbhhqm2Miv9TcbjhVRFNnD+8zGHy4rMBWYlvUnjg38XPEsXGPQnd0BPijMi4lAd9Wx1QevdErQB7EejDXJljBpRxLCascm4BSeTTH0qr8l8JI+qdjG+w/FQPswhXP/ZB+qgI9LC4EBP+4xwFaZBUZj9q+iFA3Q1+3WF4YIieQfkwwQAHRK/aOpEdK+V5XmlroYZqrHZ5PUHcnu6XL91shyXgpYCFGAjD0Y3Wvc/sQ6qtDZmnQ+8aWL1/th7sXQ+DEJnxeZ+9hu+VZ/Cq0WJGNWH1u2WYDs2LlyXn3oDCof55N8XaMUU6AEht1evdvk3VJ65S6PhuknSDlOG/9wnI6CRi
 WOhU1jVK
 GSsNCBqXNh09Tkxg7akgE/uLN6t/n2bIRdB8Mj/jTw8oKMh8nW9ClJy90P4Bye6RkpqphhRrvRXyTCthZ1I2ffKNFnAXzK3HhyuoBZO4ixD2bnzeM43wkpEfQ+wCc310r9EHhZ1bfHmOTsHr6fIk8kQhT2xNLEhX1al04YorCoMhmgH9HEWIKdpEB4jRie5h867LMq/h9MAnZbUkXfEocIC/CLKJ7dnu1etQG0+GkCgqHfdVP9Y8+TMuMGhM4IHRRNXUfqZjt9PbXFToyrJ14yMNb/Vux+Hp92dVdTopqVeqEOY6XRAwx9UGdhATPUCd3ohgkXNLRFmux6wez5H9kX5ITFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 16:16:17 -0700 SeongJae Park <sj@kernel.org> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch set introces a new action:  DAMOS_COLLAPSE.
[...]
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

I forgot adding my Reviewed-by: tag here.

Reviewed-by: SeongJae Park <sj@kernel.org>

Andrew, could you please add the above Reviewed-by: for me?


Thanks,
SJ

[...]

