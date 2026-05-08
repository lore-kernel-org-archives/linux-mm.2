Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87CD4CD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 12:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0836B015A; Fri,  8 May 2026 08:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E518C6B015B; Fri,  8 May 2026 08:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41426B015C; Fri,  8 May 2026 08:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C28E36B015A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:23:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EAA440956
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:23:49 +0000 (UTC)
X-FDA: 84744168978.14.8479CA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 87A621A0004
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:23:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P4/rF3ZS";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778243027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNabx182soMOkOT4MR+98Ku4CE/Ri1nsul1yO1fh+Kw=;
	b=2BcGgdFQzMeAMr1lhrPbLzHbYWM3YZSWo23xgGjeRuUnYVUjNsyGRMnAcTLtxAC3Gqs9Zo
	8tGVV1eKuoISIcMAaliu5IsT0XfJyToDsJJ0keUVG1YduwQblqtTuzCaSIxKrQ3brGE3rx
	8dlvUHRxtPtII4OmlBk1ITzlA/XsQyg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P4/rF3ZS";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778243027; a=rsa-sha256;
	cv=none;
	b=2I9ed7FSYZrTcRmJ9TGQvLtDd3WE6irJIzHXvjNvYrf/ZkdgXJgq2ytlMe94YblnXSlQbJ
	Hd6pmkasV/gEZrWpB6G7TRma2gR4cq5AOGzfjdj6cNMsLPRQnteRf+tbDIaSnj+EtN+trx
	h/mrMmiqjxqVPkNo8MzGz6s7IFmgEBo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B02C40641;
	Fri,  8 May 2026 12:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4752C2BCB0;
	Fri,  8 May 2026 12:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778243026;
	bh=s6tGTUaX5JCjVeOsD5Mbqpz/lOTnCe2Wdvu98w/3EP8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P4/rF3ZSylK+dBUn1xj86IryMJaFVSWYryQkubG/z59q5KlNELky4PZ+r/+crs+3/
	 x0fiFk8gCSwBCSmUIuer6Nh57SBsgRlLSj2h+W/S9YQnj4i4psF2+6eTxqqFcr2hei
	 RE6Nerb9ueRW98FtkrpIDj2W8P1dnxuG9jYVj2H2KiyW5gJgpIHHmyi/OKVysbk9lT
	 oOvf67FK2U+4t4iJo5U/xrql5kBpn6/Q9fqgJhZxh/fWH2GLiERdc07aBflBERS+MA
	 kDosDukktUDSaWtlsu+Q7XaTOD1rdDyaRDEear7F3Eqg4K6g0kJllG6kvx2lCAi/gL
	 8PpvF9vRbTNag==
Message-ID: <bdc711fc-c625-4696-b6bc-28461c0c80f2@kernel.org>
Date: Fri, 8 May 2026 14:23:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: add MADV_COLLAPSE sub-PMD range tests
To: Chen Wandun <chenwandun1@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, shuah@kernel.org, zokeefe@google.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260507070558.3064142-1-chenwandun@lixiang.com>
 <20260507070558.3064142-3-chenwandun@lixiang.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260507070558.3064142-3-chenwandun@lixiang.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 87A621A0004
X-Stat-Signature: qn85ddggsmk9d8jkg43r3ufugmazw1me
X-HE-Tag: 1778243027-721825
X-HE-Meta: U2FsdGVkX19KKWmNKLflG3FeM35qfCYBh0nurj37FCT2wzZ80Y10pH7vF/TfZyfz0jkt1OevNzJSNEdfHQzeRw9Av3Y7Y5GrfBf3pJ31300ry+e46L88Tp6+8CuzmXb71V9BowvqIy2rzrfRthAlXAxqxALwDeVOU/PLcTR4dV3KkVuCSadq36xz/tCvo6QikPjOqEr5u+l3TnUjb0ijIQzV5PLooSO12lHRTnRp6ozUqrzOv5ejXY72qeD24wz+WEAskCCsaVcWIgCaZHZXVrRMNRpxqr+gX9sGbs8BqvdWAIN6Q9xcKandUq/U4hDQCML8KKCJxCrXWFplU78x6MTjaMN96ubAZbsgaPXI+FgEXSPQCTETlWNyQhfFZ+H/qG+9ZjpyI8EKv4hDD8EW4Bg6hpTQ8kCrvG5KYf2lU5AdfGyfcoV5twn4BaW0SmecUy+0DWL9Su4TnucsCJoSu5o2ZdKfDqlujWO76LhIcCZZQALGnkuHBfzztsvhtTVzDMN/p6P+dK4iWKVFzcmReGklo5RzaCjx/MiuSbpxieQgw5z2KSDUZrwVk8ciXK4VtuO41QMrlxluV2Xru1xe96K2RuPB2/87CCPzm3Zf3UHPlkPazTCVsjphThMExfJQG24UsP8M2A09gaAIulzaNTwWbKajcjzjF4Rtc/f3t9T4SFOFMNh3E5Euut61nHYw48VB4CjJsqHJLuIDBr9vDa2sQpaxyStrzV+IZAW13M9oLXlD4E0iiuICVj+LsB1w8Pl3we9CKL0pgQG1OSDf6fHFOcPh0sXdUkc14S4onwereQYJq5S1J5p0BX6gjB1tA0Hpu27AOrpCgxS+hnIaj+mrqVNxCle7ytuOokBqzTeVu/93dGgI12VVLUAa2goS69wFZA19tJNbP06+B5hMtMuP+Ru9NiUMIanrtt+mNEDFlIN6KABn1AfnVvIzT5ZQtDnePqeo53L6kkPkVrG
 t7xPYLZh
 +cEt73N0jodMHMoXBOvJwsIpOocGLMGsgNd1w6mjGdqVFVbRVaE+TECN2UtkFGuXfHn0UD8dg/o6GFgB7PPQHpaoX2iSAny89hXnFJWlRZlOvJLxzVtphjRVTPbckPtOrm7dkQNgnR5z1jLGFm8osmz+FM8yPsHDg41gZxKMDUDp7aEh+NVf6d1dzPNSGeBlH0IFLwlYynQVdRu1Si56mlDeoZF+jByYsJdeVelmO34T1sSUGAG5rmdKeWE+gx0Wft64eDtcgzbUrWzOTC4ECEm5dxp6qMBmGSzCyJ47o6rIucwe0MNcVF3WCuOtv2+YiKoAcinzrLbnx+3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/7/26 09:05, Chen Wandun wrote:
> Add madv_collapse_range to verify the fix for the spurious -EINVAL
> returned by madvise_collapse() when the madvised range contains no
> complete PMD-aligned window.

Do we really need 141 LOC of test to verify a "userspace is being stupid" scenario?

Nothing was really broken, it's just a suboptimal return value, or what am I
missing?

-- 
Cheers,

David

