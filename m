Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A75C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3BD6B0102; Wed, 29 Jul 2026 10:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74E86B0103; Wed, 29 Jul 2026 10:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A647A6B0104; Wed, 29 Jul 2026 10:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77E526B0102
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:34:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA1B7140645
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:48:53 +0000 (UTC)
X-FDA: 85041340146.24.6D86762
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 25F8D40009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:48:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b1BzF6jm;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785318532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbhZWFKE79CcMIz2NYlHFMvfqfQ19xORU3yp3UaJjCA=;
	b=OKqQqy5byrU3LebwvC1fINRR3FKlIu5Jclq1Fyz1o5k5Ukzj/YLnEfYhiPlyfNOwOcyTtv
	cffcbrRRpdDF6PJFlSkYnAG15sCTKhkRHBUNiZSA4xGFqqJ/C8NgE3YD6R7PW7xWMQkQRG
	sMlAW3xv55n/mMTIlfuH+X8KKlhwPfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785318532;
	b=XAVdAQMphqNDXCfeBRnqvTOM1XjiofTp1XDTnAZ1AAVsSMboQpfi4SBaOJJUOlf6DKCl/D
	3w7hZ3i0uFZrPeUKaBNivF/3XPXvlW3dXk4pbZi7q4Jg5MtuVEawr+DzQZWiv4DZw5jUU+
	UPQI++h7YNVnbY7n3DSCzDGTcf2K3Y0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b1BzF6jm;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD0D060A9B;
	Wed, 29 Jul 2026 09:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3881F000E9;
	Wed, 29 Jul 2026 09:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785318531;
	bh=dbhZWFKE79CcMIz2NYlHFMvfqfQ19xORU3yp3UaJjCA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b1BzF6jmxhThRD5qnHbsijWJFg5k8GNrB8nfS1X7McxikgFSQdsyjjf7pWKrRXcAX
	 zyqDifsvq3VmRiEgFvJxe/bpEMAkPTx59IGH9U2SgKxNZWfihq51b3AndymQctPzgw
	 /ggKYyCaBSBu8SmkxRIY3ZhnRZXQXqPmeqgrobOR8rCSu59tIrSagQ3F2ENc1APLfJ
	 AP1wTmQhCg6nqXD5Uo7ggS+IPkjcASOh0x6Bhcul23cvJSK1tpkQg/9H/LjL6Tm/Xu
	 WJv0FapHTz79t2zVH3QxYXqa7jbYtuOFm5v548sLAXbbQmIcOhx9bYLJpDPcWKTrVJ
	 JdE7TfP+tO9PA==
Message-ID: <24704855-9f9c-4432-98ac-d22150d2d634@kernel.org>
Date: Wed, 29 Jul 2026 11:48:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] mm: Documentation: clarify where the mTHP stats
 live
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260715025941.1571316-1-npache@redhat.com>
 <20260715025941.1571316-8-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715025941.1571316-8-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 25F8D40009
X-Stat-Signature: zyu5xckf33m7wgxunfobjxixfa87sbhq
X-Rspam-User: 
X-HE-Tag: 1785318531-709532
X-HE-Meta: U2FsdGVkX18w2Vh5nPJo3rc7uOWnPY7MPXTIFDxQuBGuTLgqGZ9KBnRVKtnEPUFZGnEaB3g1ykM1mgbJOR18gNXS0sB0ui9aHliVgPQf2xhumUHLZn89+eiERbsfjqXr5eQ5VK7y1MJTASi8IhW/C5od5X+BUHyQoXhW6gVbLwM69fYnnJinTka6npv93Ayk1ZZjxwlWbA1EJH4mSPm1RE4zXM1/L6iSPSJoNGlzQ99ODCqyG53p1nI99/xbXtVXAaTV8j1hiAzL0o9eUn09L1qn/7qqb0Qurjtluztg+rNMIiX2Kqq1RnKj7adkuWmvNnxx3IzqY92949RycocpcE7f5TRSvcwWsqE+hk+WH97rhXbaVhtGMYQxXmuOq5cDusdXx5AFznDB29ZP2V8AvyFSzNXQnfSpsHj/5QHXwclOBZSTeRUJb6/BSDdO46Sry68lEkIfylPBN06QY7+htIcGKrkmug7yQVY+mbqOuPandfjhDCxbI+2QdGHHB7v8OSyBzd76yBrfXHLx8ngR6hBo71Ep3A7DH5mj/uBKt9nVutL5BdcVQGddsE25WN7nLhG117NNz290wTpdB5GxbOohBqyrCZAhHQ5/VVNzZsf9SUPbK0nmjBnuDQqbZ3akWXI2QLTTvmEorpTofIGHSWuKJuKBaYoU5Jkxed3BfLi7evEs8Sc/KoApagFXhyxpKalBiZXF+iNFhVlDdgplu6VnSqQLTVzgQPFU6lIakuLriHFXGwbWpJiqiJpxOXg9tZsDiCUGFK3zU04xS3dh7q50Fk7AwIBDPFORHo05W31ypcBxAD5i+rIH/cLpYtk8vM7vmYi27SlZBDDc0c+Xm0Hh+rPwbSTvjOlFkrn73KZfJfko5A/GU3KVmGfOQ2ObVbo6BNoLv0QTafOtkAZkj/7IpECk+EE43pxxyVKiBc+huAiiiTEf9fqUQZusLbieoQfoSue+1+DyeIY9u3a
 G8G0h9TN
 Ul8xWf1pzObjR6OF7gpidYksEsMfGYcTUJjHu0vgTLfBymLyCHyVjhXSSgeJ/j5Zo1w7OQOubDSh6k/tkfkcS9CejnEslsaeXXj3Jy8zGX0N1mbOjaISygCB+l5DvzWEOBGVY5sWqWLg/c/bbfNgNxIzjFj1irVVpKTGp1Y7kSvCYfTn/+MXJEtF1LYVapltRW14QQMhz5qYQPhb2N6veHhyl/I6AaKi/AQi5pQIz/qMH0WTC0iLhrXPWif5xmVAKPnCmAmY07J/L0D7klOZokBApZVYHBR7YkvCXBFrJIzE8M2dX+QOWk9ZZljGwZwmRuyKHZSzsjrMNnig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 04:59, Nico Pache wrote:
> The note about khugepaged counters references /proc/vmstat for the PMD
> case, but never mentions where the mTHPs stats can be found
> (i.e.: /sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)
> Add a small addition to this section for clarity.
> 
> Also fix a missing period while we are at it.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

