Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D7D7C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 01:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472296B0088; Tue,  1 Sep 2026 21:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D036B008A; Tue,  1 Sep 2026 21:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E386B008C; Tue,  1 Sep 2026 21:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F78D6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 21:04:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AC1C805EE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:04:27 +0000 (UTC)
X-FDA: 85167026574.26.4B0228A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E5D391C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:04:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jtFMi347;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788311065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Di+0IBh6tLmVqnPdTQZVJOnFu1lqBzd2k5DnV3cMywo=;
	b=1gSV/AVEMLWAdqv73MCSPv1OLJW6+MVoxRuoxbvRn3ZFq8DiCAG/ucIJD3aIvSysslaFCu
	mhtN28Iy4z2YG4kiEKpOeT40OX93umqM7JadvyfRUbXFuqhSaZXYwoH6UnI1vY4cP6GSsc
	ACDDYS3K6fCSvgSdGKFA99grsjqgMIs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jtFMi347;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788311065;
	b=hz7I5eZtYwce0drCEkviDIUTHwZqy0Y9PgFdaDheNk7e4ao1WuXNI95KI6VK19b3kXYgDh
	33ezgB+DLmkk+Ee866s/DK1zCkNi+tUJo1uaJTYSaexqYD0RUlpWCUJ359gZFh8WhJvQ6p
	dt3kvsGh88ZhIxv2WkvNfZo8NCozAkQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AAD460120;
	Wed,  2 Sep 2026 01:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6DB1F000E9;
	Wed,  2 Sep 2026 01:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788311065;
	bh=Di+0IBh6tLmVqnPdTQZVJOnFu1lqBzd2k5DnV3cMywo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtFMi3479qMs5alvGgR9GLqx37YivkxohtOlpbk+IeZ7HqpglQ1UCHej5hEcebuFj
	 4LfYBJJsxBHHtgRFwvZNcL5Llr+uh2RWnlABbCY0vNilX+gFLDIL5wwzS0C12WAtgd
	 miKvr4cL/Pd6J3wAe0UqA7F7hhVVigWF0whEPSFm3DXOXDYMNRDuAIV0X0wOqJv50R
	 kGK4o2/TQERIj7sl+4sMEIZ3azo98OWKRdP4hw6pfY2ui/wxpZH5IN+KHNgDHQSG2Q
	 cZqoaM6YvqpLmgiO9zArfpl1j1m1jxn053/Zl0zKXmkIBHZrpRpJkhfIUMQk/x5psD
	 kpOReVJ1SjbKw==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: fix quota could not be set to zero
Date: Tue,  1 Sep 2026 18:04:17 -0700
Message-ID: <20260902010418.109621-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901105951.106246-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9y8sa5wfkhxsej3fifc4a4p8wh8m9fx9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E5D391C0003
X-Rspam-User: 
X-HE-Tag: 1788311065-471339
X-HE-Meta: U2FsdGVkX1+SFAsrNnwF4pGaMoNIgD9c8nvcsHToBYGQALVrEtMyyCCHOw3R8xQIrqgkq7iERBl8GnV+XRcu4LhMAvJIyeusY3jOps7Uouomg7r456hhRZbgJKTzpFn2G4ZzFVyyQ0muF3PUZGxlgvJV5fwMGja5RERG7kLgxiAZVrgqzX+OkRDFzmivR89z48K+DhzcXR4xpiDLcTgxNZ3Kr9YAShP+kBMWwFIgzWbBOJAMuPCEsVRQVL3Ya9yVgbxAoLZVCPmyMD5h0THmq8jg1PSUzbBjrHoEHcTwFbt2t08G0esnsdlxF7FNZ9dJ/1fO/mwEpGu3m8WbrpqbuQSSJdesSxDDoSo2hDqY8OmuJE3g1zsrzajo+R2r2kz1Mk9NWo989FQJL71l+DEqg4VfK1b76rCOC+oiz5Zzdl4noY+rJQ0QMncuARmwe1McVXR+4Hseruh7Gf6DEoyQu6fk8sKWo39IWrsLz2CZ3KP9+7+fcK3mcpYNBE8qplUpsMLB6T87YUHVySPwuHMFV/wWd2HEy0wlRnj2P1sIT68MnK1mP7zsV37B2Lya+p5tXiWALH2gB1jwiZg+6Cd4ahk5UNWqyL31h2tY1aCMYp8sdXk7gE0Fv7n6oWbnc3bm+GhrGdxBx6zHwYINsm7QUar02HBvseXx8Qk3Ms0DwTpuwCaq6ZGBq/2w/sqqW/Opeg5HbVGkdkG3uEqD6kPwu6HtORJ83Kc/fD5BSdya+lezE5vUr1DyAoEM1StbTu6b0yctdPiwHroJPn79rpMZ6b8LUe/9XMOYHzX9da2EoAx+3RbJyfjGD8sybl9KFNVDFdMjOhxrVndxIwE/cSlsl/HKiDfjJgGaLd3Ma4evA1fxwqck6YDH6l7TYjLrn2nSpm5Hm1/O/4kkz8g+9QBY9tMYzsN4QDl/rpDBFcHGXyo4qSsiNFos4n59hbLfoVSOeBSdj8M55TBJPFIU2K/
 QXeJ4Ni/
 e7DBLAqxy0BRsiF7uT4ikMyicKuS89H3Hy+PvSUVWo8tNL7wXDvEk6DBjACSjDOFc6qSsT9ehj00yHIeTlzghH36MQA6Y9rama9PP/BbgKN/U8d5x9YxMoXL1+R4qOfZQeipMjFDOXQukkCqvQ/DZ6Q84WfJ1nWH7i/5N1g/uqngpIT5n30i/1wLBZ8BytUHhszADsBGDaRlwVOSWGjg2qJHbiTcAQYwpvW6V6BZSFXlCuMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,


Seems Sashiko found something and you are planning to revision this patch that.
I will hold review until the next version is posted.  Same for your other patch
that sent in the same time.


Thanks,
SJ

[...]

