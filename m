Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A552A606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6zqLY51
Received: by kanga.kvack.org (Postfix)
	id C58236B05B2; Fri, 30 Oct 2026 10:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09276B05B5; Fri, 30 Oct 2026 10:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9446B05B6; Fri, 30 Oct 2026 10:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE4D6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:42:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20B8B1606B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:42:31 +0000 (UTC)
X-FDA: 85379558502.22.4708AFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 50C8180007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:42:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6zqLY51;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OU3zDVKepXMBwwR1kv5zeSUQ4EZ22iKhEWe2jjy3QKQ=;
	b=kduEGO9Lk1QS/vLveoU06QZ/fSu3TL6lPexQ+3x9sArziQP+hKB1Jzxobo7+0sOi3o1iU/
	QFbur5lj6y04q1rv/kOItKthQiZPk7cmnzaPaF7vDNJMFSTfFgT+iNqqHFDdMA01uucR8y
	96p8BX2nndyYjjl0IZQaYYaU+G2PaNw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6zqLY51;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371349;
	b=yfwyUKRX6ywflBP46/mI/ZbmDWws68APVXaNaQqa6Dhc+UM0ugnm9BPMjuU9QxhlsW+RD4
	z9NCYQIUGRlhtrrXEHPTg100/BoiGPV67skAw4xyZGYT4qx22bw/OjCwL3/4GbM202p7e/
	fuFDhbK96AZfDJ7Tv+fgDdCC7LHHNUc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F5D643FBA;
	Fri, 30 Oct 2026 14:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A3A1F000C1;
	Fri, 30 Oct 2026 14:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793371348;
	bh=OU3zDVKepXMBwwR1kv5zeSUQ4EZ22iKhEWe2jjy3QKQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B6zqLY51HL03HAbN7lCtJ3lFh7DfqAs+MNDqt4pDlmekKLANxMB0eErrw8PsTrl/J
	 bhk9I9VG57rWGojcbjPYDvfXOZwhTgar1YEV5quKfL1b0Pwe/drjQd34EpBd3Y815W
	 1d9Q5G2Cd5PIPAL+eTV/ecP9RuZBDZ7nl5Bl3mFrSUhrXD4jFsLHyYyYQHsTylLkGn
	 NlinJiDxut9+mjHqjAAEc2p/loJkudu7r+TscY+B+okD70yxrGultokQdRtQ0P+G3n
	 9sfhmK4CrBl/FEGq+tDpEnsQ7/pUWjxBP13v0uhwQR2Gi+eXMrx0jHd1x30BELyFhY
	 i4QHMyc1GAT4g==
Message-ID: <40eadc1b-5057-4286-9be2-021cb16bc020@kernel.org>
Date: Fri, 30 Oct 2026 15:42:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
To: Tal Zussman <tz2294@columbia.edu>
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, mcgrof@kernel.org, liyouhong@kylinos.cn
References: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
 <20261030105022.903008-1-tz2294@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261030105022.903008-1-tz2294@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50C8180007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: c4kki6kh1s37tre6xyrwamn667ha8o9d
X-HE-Tag: 1793371349-330000
X-HE-Meta: U2FsdGVkX18azehMh/VBUSgE6UYuUwkdxj+CbfrKVANVBXwZxV7bkKpWWnbFWm6ZadUYQycS1csKxdCwueEMUTjS510h0rJ6Un4FtVev7uwje98TUDwJjTGB0Msy2NYSSB9EbCT4H/2RQWCtHWgeRrkmAA+wbY6i3C78H4rcFVhl9aEylc82YPZ95FSiJ3SEK0RBbpMPcKOQtlxFpdk0olytefebPsIl0ZSmly3RfffF2BnAbKkoUfPmuUuTOjt5VnngJf0dqMRVkam+XswrNECuJsIgLAYVvRG1Zlu8yx3Dia7wHZddFAUtXTZgYF7CEywpdJYQxH/jmYMEduIZrIIGsL776dilbQjWqA8XXMmqNsIY2rF9YAlQVYCsMMsI+ovon3+Q834ZYr9xO4DvPdNte4GPiOpllIAKsHl1+P4AkizDN87RBagB7C0xvP1lUkflSbDMkQowPtZYNGH+viiIthZvrNjE3yAzhHwHtBe1xC/OaaL6wBjaFrbb6wSLGgNkeKfax3kYO7qPPF61oK9KGqoyvDQQyRMPubkFA6pkNHPeQvqnAkEht3MgSkq6Ep32lW8hmAQv7kLAxwHl1s7+u7sbfGGk86eYEZTOe1fjSCOihsI0rlmy61Cr7cQh66gqVETgiDOWG94vAheUld/EJ4EG35kcBSU+dpZxM83oXEe01ynMHIieK1LI294gn7strMTMBXynBgKJIc0DlA1qfFIpetvjrzj0RAgvbmT1ZMieKdR0BRmXbVCdl4ffKqEdrrpEJ03YCgU3Qot8lPegbhfuT8nGD2i5H0TOqoBOJ6dqKmlxEW7q6tGUe5qbd0pbfOfmYKhAdZfoOXs3PhSezeA/3sP0P0aEsAm1CrJOj3s+tM0dzvENOTGN9WnGaEAYUWXDLvNu6zEFeFjOYIC8YxmeTnQh0c5Zjd0dX8Y+ps50Wz3a1sB+Auvmf0eTb7TR4RTi4G1ZKqhx6Al
 kDUbQpWV
 YmSF4zrl7yZiVWJJB5BWA8Vr3SANFWXExGy/EGi82K8bQJ0UoHv4FzPEC6e+zbdffKAIX6Bl7FlY0vGyA6bKX0HQNezgHSSnHunRHN1dtbeMbJUUMAa2e/m6ft6PCK/VkgMcQNpJQrphjO1RFj3oL1rF/krudRw/ZRg6LGDWvTdKEm6y2QjV9N1U2FiBss5lSS9XonxOHcbCjvEXsJgxSe8PB75Wj2f7if5O//milkokYUpU5/e/h42niMZxAtOuxiEZhCdZtnHHEZjyG6R75p/Qeo4Q/tpiIBtkstl1NMSiwR/oOfVd7Hqwayoic/cqP3pQTAFLfoQbPoLu2rr+OZNHbQPxnQ7/vmyn4r7/IInnPjmiKY+k899HavtKOBFkEutHSSYVn7dPpSYIJzHZKHsa8nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 11:50, Tal Zussman wrote:
> On Thu, Aug 06, 2026 at 01:14:38PM +0200, David Hildenbrand (Arm) wrote:
>> hwpoison code can end up calling min_order_for_split() without holding
>> the folio lock. There isn't really something that would prevent
>> concurrent folio split. Consequently folio->mapping can get set to
>> NULL after checking for "!folio->mapping", and if the compiler
>> reloads folio->mapping, mapping_min_folio_order() would try to
>> dereference NULL.
> 
> Hi David,
> 
> Did this patch ever make it in?

If you ask this way ... I guess not? :D

I can see if it still applies and resend + apply.

-- 
Cheers,

David

