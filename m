Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 591AACD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9826B0088; Fri,  5 Jun 2026 07:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A5C6B008A; Fri,  5 Jun 2026 07:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889516B008C; Fri,  5 Jun 2026 07:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 798706B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:30:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2872CC34D8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:30:14 +0000 (UTC)
X-FDA: 84845640348.09.C85466A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5030A40008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:30:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b2HGYkKv;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780659012;
	b=xUVyBjiSIRG4ZE0CJZH7cvwiGHD+W9G2idpbnCUpyXwpiNANfs7FIEUv/r8nHtf//86l/3
	o1bt8eBx/QbrtflnA/lA380RALCVfxywqaabDRc0JEIpHblBVlKfck9NJDTNPT8vXNmRlQ
	hi1tBT40FExYmAhQ0JGxdncNZQ/FahM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b2HGYkKv;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780659012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmTaJUj1lazUmadTOmGXnm/0jLcTFlnKa5WXCRJQ9Yo=;
	b=7hMvP22dVFc2Oj5zbE1rQnrY0IomQtUxK6I/LA55zwtD9duqJtutgd2sKjeR982glhJxiS
	W30Nsp9h+Y/E6hKI/S0qIF7+x7M9uLUApgwLKpY+0jAAFKtrlVAEnco2s323rz5dWb07QP
	ZEsu1o7gU8FKD6XINNcGSe0m7BPd6Og=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2536643873;
	Fri,  5 Jun 2026 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B9C1F00893;
	Fri,  5 Jun 2026 11:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780659011;
	bh=zmTaJUj1lazUmadTOmGXnm/0jLcTFlnKa5WXCRJQ9Yo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b2HGYkKv44kDDtzjt6zO4Sp4zEDiseh/8H35sCiD5i5BXeN9IOpRzFYog5HZWppKe
	 DzZ2Ee8BTUhzvyE4dHMnDl9godhh1QtTIL2eq8ZOCxjEALQNMXjNGBF9fEn9LI5fTz
	 Mb3Ns1UMCGshENCB2J/CKVVYHEmq2DSQtJ3aUD3r/agEp4Ck3tYpBrLaEQyvAw9jjS
	 L9zJrsHRuEnlotBz8YRpiSmsDreYf9SZyhUj1K4IUzXkyGZyA+evSbMyOiDEWOloHw
	 tew7Caegi387fDbDC+ALZvM6qPgmeca6+cPm3gEJvLinFbIuduGDwEUS1LVfSPwGjy
	 bXZeB2nO79Mig==
Message-ID: <0465e8ac-c2c6-4745-9027-da4fc9c402e4@kernel.org>
Date: Fri, 5 Jun 2026 13:30:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] mm: memory_failure: Clarify the MF_DELAYED
 definition
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
 vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
 tabba@google.com, dave.hansen@linux.intel.com
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-1-a5bc7db5a9b2@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-1-a5bc7db5a9b2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5030A40008
X-Rspam-User: 
X-Stat-Signature: y7q83k6zg3oq1bwatwe543syjn4cxukb
X-HE-Tag: 1780659012-892669
X-HE-Meta: U2FsdGVkX18sBp7US7FgBVasRJtO8LMr8XFfMZaMKFV855C68+Z9SVych5h3dBaoTWvfoyAlwlaZrS6z5tjBh7D6wy2XNJGLdken/LZuh02Wvupd5BrFR5S+2Nlbka5wY3lfBY6ORbi8nOsE3lYjczO9HOeYBZJs1A9r1vadh//WE6+D5VpOeaDV0iJ8vWUBtEJPKRwOCsabWDs0GHHb3yf24ZxJKeXRr2ACErUGnMiAu4aq1V51Q+FNcypwtACeB15zGXd+/lKRtQ4s5cxnh6hH/KOyEWl7x9R8CTzp/7nVX6rDVP1BBb3IRKwCHia6klG+yfPf5o1Vb+fr4SzbpzdExG5sotoJXFpPr82mO9fxoQnBpmi8OvJ6tfR25hYdieDy5apa+88BETnMNAp2BgNDHxynMGy0yeq3NbXSsWHKtwwEBhuSJlrlfe0eg+hKEnfQQz0dMmIedsF2mT6BsL6gtsYHdpq9c6fUBWBRmZ+TY771mawvsGeEIyAv5jhyktdNWFoSIhWD0asVGUCsA4Cq6ejA9hKFGIw33X8OG5YDAsr7HZh/LidkVTjMgFqKssQPrUnodqlH4qMAlIWTLi0GTEEGAeNjEwYnk8dgop+tD5mPR1/FWFtTPORGKCjaCywX178S3kE1sWx6z6JlpbDbJaLYFyXyXt/T1T44ZUQj+y86L5KoIbNvxeKa5jxfvrj20xtjBhPYNJlNTITwRxTVBORmmwNuGsQLIyhZ5jX/4+btz2jOg/oFaaPLv9mX9ydmPfOeo1X96W5VDMtsjEBX9Xl2ntpCnWk0i5qNqC90irz2RJXPz0IdmQsj5OJqjh17Fbzu8DvrKrclJgUMsUUpgY5g/h9lzl5xjc/yAdbvDFYDZpzM7PczgNAiQJQ1oaz3h+cssPT7duECGta0GYDIU42njXO8/xEbyesET0gLSjeM1hTlkB3OfD7lLStuUCpNtw/ndr5Wq7TfRcp
 W6ePhOkq
 hTymtkenlf4fP0dQmZh0hetGNCj3Yhz88oj9kUqwiUHNDwiJLWsCT/mQuQtGEu0gZuElMoZQP0xX6bfL3okI7owqsEzdIkPzV2C2UdjGyJfekChsRPBbRWpHBBRBStty0UiLH4BDzVo+MFKrEYxhTIgccEPfwDQftzd9dMaCWAMXX8KTGgStRBUI3RzSqc42WFC2ed67hbUhTHXgi6q2h8AhscXXv+INcsaSaQmSS3pOkU0biTjOWVEqT0B0PRHyfV2JIsYGmG4Qiw/PSo/4r+Ho8WxaE9HF7yLIBn3bBrQtPiHJn/vDtn9gwXN82cobFyYCfTLBtylVKqY76ZGybLQh2DCDQvQ5V1RwFN96Z6rTOV+6HaMto2DxLc8868oSepL7BTQUrCLMMN9sV44rmVstHKPYwWn4Q/fy4ajIO6kds288=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 23:55, Lisa Wang wrote:
> This patch clarifies the definition of MF_DELAYED to represent cases
> where a folio's removal is initiated but not immediately completed
> (e.g., due to remaining metadata references).
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

