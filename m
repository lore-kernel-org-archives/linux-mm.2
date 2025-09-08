Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A9FCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C678E0014; Mon,  8 Sep 2025 10:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D636D8E0007; Mon,  8 Sep 2025 10:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52A88E0014; Mon,  8 Sep 2025 10:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3FF18E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:28:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 566BF1395E2
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:28:21 +0000 (UTC)
X-FDA: 83866313202.25.C4F1375
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6B5D5120006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:28:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j4q3orw3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757341699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FkQvNzNp9Np9r2urRAnfM6gA70u5E/wzFHlmS7bRCBQ=;
	b=4w1tteNqRN3H0h3Nk8h1e3QXOQFhbMHhydc1vlNzA75YuEchw9h4I2aobh58/FsulwZAnn
	s5hzNRQejIkXFLaAruDqH65Akn5gBNqE1UjctTJSVbeCNbjSc8hManL104yM/AsHiUXoBK
	JB3RLSxaSBrSvgWfYO9ilE8mAWcgtx4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j4q3orw3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757341699; a=rsa-sha256;
	cv=none;
	b=AldbZA3dK5vXXzO7kbiSzTUjOuYBnJmFF+NBAY9sj+s6t/nYf3HNRqthNVKafwMqIeMVkU
	4otswL227wtFDWEgl8d7ei+FKzl/HtGAU8jTuwX4Pw/S868a+IVii3cfzN8EBp9Sy9REDL
	QKIGecj/mgcuFfvJdjiheWJLNaejz44=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-80b7a6b2b47so422127185a.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 07:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757341698; x=1757946498; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FkQvNzNp9Np9r2urRAnfM6gA70u5E/wzFHlmS7bRCBQ=;
        b=j4q3orw3wbmeGxNKe1a4ILIpCBWVlLHeUSC4ddo7LffI+naqkV39u0h3izNzPUIX8v
         mnQ9oioO3tiSV9Ov80zBPQ8/fCxPu7NqlK1tOp/emJVHamkvlmuLGSdKQfM6sbA2CUo+
         go0GMI9a6SI+TWSKN0Foe3uzpdlbdopSQv91ClhdiQnHk2GzeXOinrxj3WYBkXW9vzym
         DI8pVuhOoXq5X3oBFeII7PHxnfYRLqPPKr8wAEsZuj7l6gWymcz884geKsWvt4T9lCn2
         MLDqasefUsq1RydE8WoP8vj/aJnaygmG7QRogq2IyWN+U6gfKB7pFhfgU55mtST2Ohpl
         OBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757341698; x=1757946498;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FkQvNzNp9Np9r2urRAnfM6gA70u5E/wzFHlmS7bRCBQ=;
        b=GvKs41bvIut508b7P/kK2EUaMUWCZ73cTJ5GaYmTb+WQyTsHzz8Gg/hzgMupE5zvfT
         XzFBcK3lIQmZ3QJgUZP8nIHCINONLEIfJRfGdnyv8yEjcgzZrN6JIfGAgCOR0JZceQlm
         M3m48a9QuN7DFInimRHcPjnGO8J0coXjJti+d7C8yxxkMqt5iXvLtplArJRbuisu5FR6
         +faciFEYPkKCShJF6T3TtDmPeurTFXwCgLQOj8zbkKcBE+9CRFsAFhh8m3bK+Ie8XRBp
         Jy+KuSSzancNYw1QEgmw2DKUS6q2TptLuFpXJULcZmSS8QhvdPOAhwwLUGGk/AqfqiZD
         P+TQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9trksBGmYuk7WkQaets28lMLRNsvyfMjeraHmni1WrjpuP2mr799vVkpzcymJ3pi61J8PeT8/qw==@kvack.org
X-Gm-Message-State: AOJu0Yw7UGmsrqcs4+OUGwZbTKPnMXqczthg1zyKHMVHTC3wbcMBc2JY
	S0c74LiSV86NAKRHCc3G/zFcA5y1Z2orAphyzf4UleAfDa6C1JJAYqIL
X-Gm-Gg: ASbGnctRROYAgly9YBeE0ad+TxiY5cultHayOSG8WTuxNl5x/ccTZP5x7MSPfulDeFu
	NwyFLN1G8Gv9RZ8nHnJVt4Vg3fg31fm41Ga3ESMUfLfyyxDRcFpHvnDzlR6Yswekb1D7zp1oovA
	yCP9sSpjQJYnenBMr+8C5NO38IKCde1ec+bKFVlCGs8mlguhivSjxVDnmA0tzE+5StKm2j91kp2
	Rz/Re0Cpm7OoRttqXKb5DH30ES7MQtyJRWgvhUPxMMcxfzIh2fEmbesewLuPgc7WfAuwWC94XPN
	mjUNWiTh5cE+KFMf3Y1n10TmJ7M24BYfj6MPlYd3sIVy29KdZzjyr43BX1xjvp7WbSb1JZkRlsh
	gW7uPLh8sf6WUcTb0aIHx5NCX+Z62fXalJODsq8yIxK/WqlBPe2HSCm7YZVN05SeG2kzUOxmylK
	BGDEvzF9xLCKc=
X-Google-Smtp-Source: AGHT+IG3FI6qQXWbQjRiDr40C6wDknp3bM4B6cMgZXxuj30zC2RffBMpUFnNnKDRFGROvsosTsCJTA==
X-Received: by 2002:a05:620a:720a:b0:814:bfd2:fd73 with SMTP id af79cd13be357-814bfd2fddamr766450685a.15.1757341698260;
        Mon, 08 Sep 2025 07:28:18 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1145:4:1456:e851:ddd5:be9f? ([2620:10d:c091:500::3:4e10])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-811b7490eaesm715891685a.65.2025.09.08.07.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 07:28:17 -0700 (PDT)
Message-ID: <fe2655f8-1f8c-467f-afd1-49da0d191744@gmail.com>
Date: Mon, 8 Sep 2025 10:28:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
Content-Language: en-GB
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com
Cc: Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 ziy@nvidia.com
References: <20250908090741.61519-1-lance.yang@linux.dev>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250908090741.61519-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6B5D5120006
X-Stat-Signature: oieccsa3y6ehfe3jrczmis6uq85a8oau
X-Rspam-User: 
X-HE-Tag: 1757341699-553708
X-HE-Meta: U2FsdGVkX1+y5fwF1PSUOe8tsFk1cPYZ+IkkF7liMsqFOT5KZc+XR4RXPPGVyg8KjnP2uaMG36Mwuu0YVWJdYFvJ98+nJrUz0PmQ+j8N25vWCA+qpOsbIuv+bjxIc5fBPe8xGH+NXq/cwNWzVNmGaUkiQ4AIiuEkZYxwYmkr6xwpC6G1HAGorWDEE+ZDMFeSycgFT1pe7r6Dhgz8jfiM9ChVsNSg/jOQKd2tSAfJ8jb4btxBlw/bdCwMcb+mFmU5MxIpKz913tlw9FexOGSKYHaU5WNr9yXjnSYtA5q1TsiRKkoEjQYJhNhB7hpnbacyRJNvfpD1Y+GFnse1OCgL8OYlnG+lI5aTrr4MvvDlaiMgaf1REnCRrTZ54y5x2CO3CB+9cHVikezP22P0Yjh19XV54kQSlbaKN6uYF0a+dV45i+SHEm8SkgPZ1JMfFZVkkGm3DGCDVTHgvHiNZrjTyyWj8j/WXyFx48+rYrehxHfBunyRCmJLylWos/wqAgi7955NNlhXL4NTMkSMWbGt8KatmoB9Y+1p7K7kooHqxbUGxL+tohMmIY3zlQSiKL52ORYrdjULjfDxJhp54fWnG9z74MvG8nzUzkxKignEh1YMJ2qdmtVhnVKIeNjIW50k4QP5LC59x0z5uzOaiO4K+YMFthVdEPq/GD7doP4ATZGRDvZO4WnZXCMJ9+KLUgXps31stv2ODZ4Irt1sR+xqynStWTA/jXuKj5ZicTrg5muOxrs31YqCs7fVz/zsZ5Ixr+Y+PnUwfn0lDoRzylDOx5q6fn3lHReQCNVdBucQNKjkhiDsQ66wrY1orGeE27A42+eMZKmLVFSLt2a++AOGUvPw2SQvG/rezt0Bn43h6p3o55u7ZIqm3AauXDcoxJTl2HPbYuyluoU8eIrU1VpUT8rL1wuIG6c3gcutZwfH/+IV/ge50Iv1eXTpLc/9oa8hzlNct9vAowk2rvU8oWt
 TARvH2K4
 sWkfZZD7n1fPTgqjUTcIIu4BNT9NRNDSzvF18sjTVadAMU2nSadkvfeyujmSa8EMaZSMpzeVy+HNZ0PxMTT0fC5rzu6TVwUAyjK0LknOFaG7UJ6yFXZREzQ4yjJbjesgkJSooR89QfQLD7iG05CsMgeTQ+TlKwIS+J71/fEmJh1PxAddqNkLvVYtqxflHdcNP41t8CCjNAo9GFiPU16Wrd65L2PSG3XowpkET98hQg9lCNsKWKuhF/rYrL9nF+zbeLPwY8ZiLnkKizXlwfdc41mcxX37oyJ25cNlUd6173n3Ujwo5pBce8Yb2Eb62EyXKdflNnE5bFEzzmC3eLAcc2qaHAMH9WdCLI84+gy2j7aRoxrcsRIzOUdE9ar7xXxvaHxz/chgiRcwanuNd1qLhTUbKArVEbGmqukEVh/dRWKvqc4vHnu7EmRJoGijGAwNDAdP3XPGbHurrvGd2AxBu7msNEb1vUk6KUj7nybntSEko2u4Bnz8phEnm7uab3J+1Jo9Kdo2aXGS/kte2wbLLYd3OMsuDiGhT9DXOnFIRc2t7AIe/5G0h+wS/Cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/09/2025 10:07, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
> it does not make sense to try to detect whether it is underused, because
> try_to_map_unused_to_zeropage(), called while splitting the folio, will not
> actually replace any zeroed pages by the shared zeropage.
> 
> Splitting the folio in that case does not make any sense, so let's not even
> scan to check if the folio is underused.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>

