Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B5BC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DAFE6B00E7; Wed, 29 Jul 2026 10:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B43D6B00FB; Wed, 29 Jul 2026 10:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B276B00FD; Wed, 29 Jul 2026 10:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 552106B00E7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:32:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A9DF40644
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:47:09 +0000 (UTC)
X-FDA: 85041335778.24.5F17636
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5E39B40002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:47:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkmwOjSZ;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785318427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rua1RKrJjiJNOIidWLTZk95Yzmjh2kX7wHbfY4bO+oo=;
	b=Xl26OW9LllXxBJhPosdDFC25cgLJ82+YHGv3IgXp5PFQ2Ixyz+tvcKW0ri/W/6aiFVU2O9
	Kmh7T2RixalJIrbI0X3SKI9ZkwHNeJmSavsgf4zQFQBjRMCh74rcmqe673cFoDtopsrbvZ
	8w38YhCsfIPlaJj2PUyOZ5SRzKHuyJg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785318427;
	b=QWp2eeR6q9TmR7Z6EPsrj5BVfw6QNRfhFoRCXs67iIYftQtNVMzPYMovfvr1TvC0o34RM1
	kDl5/R//NqNoasHOSi7GHplp0QNedbfHPv3TU0LMdYJoCiN0cOesZgtSeuDwXFF4Uudi8I
	jedIFOvAIhNesQ23uDp1Tes0pfo4xzE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkmwOjSZ;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8ACD60A9D;
	Wed, 29 Jul 2026 09:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A346D1F00A3E;
	Wed, 29 Jul 2026 09:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785318425;
	bh=Rua1RKrJjiJNOIidWLTZk95Yzmjh2kX7wHbfY4bO+oo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kkmwOjSZv+QNGaxoleaGShT4fXXQ27JMIKH+oFVuBrL+OWLtWoWiqpyvM/uGsZRnJ
	 ckow47+/MsLwKh3tOGv92MSGOxD4TYx1NCvlu9r3+C14cI48LfqAzOjlZgQ+lks4od
	 MLWuFX8F2+Z4f4oUWiruUCOsMw7932uA9KQ76EL2VXsUDKQQcjYBmyuV1p4Pdy6tdv
	 BvFWLS9s+fL9OrtIWIstduANmC34ffFS2XM7cGEK+p/FGopTY+c2V8FZWUUBE40U5j
	 D8B4Kf3GJE+6fKTo622F/5Rd11gd6FnWTm+xl3RqwYYdNeIDeDf6CPste0na7UxyOJ
	 JkDKFH3vvdy6g==
Message-ID: <ffb091ee-affe-41b2-939c-6437dd9cc13e@kernel.org>
Date: Wed, 29 Jul 2026 11:47:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm/khugepaged: extract young page check into
 collapse_is_referenced() helper
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260715025941.1571316-1-npache@redhat.com>
 <20260715025941.1571316-3-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715025941.1571316-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5E39B40002
X-Stat-Signature: 58eey7epiqzndboaiggz8knat1nr4umg
X-HE-Tag: 1785318427-441386
X-HE-Meta: U2FsdGVkX1/mfnoYRvNDMeXPPvsn0b6UqVtMwH/cI2F/HjMQsG6Cg3qcZ2I2zueJ5YvhqSrBlixdu9e8tFwifUUqmaWzQi/UbsRq+ix4OJFz1ZdLE7IYhMvMbz+V4UyxGYf3ROb2nXnsSpwBe9shuny6RQ1CfY75b/Ha+FHJ5uaZkg4Jm/oifoP4I+EG3UjUWG/nLh0NKiYOu/SM4FNbkBmOAJ1EbzdW6Brgj4FSU+36NguF7Dybo6kehb8/1oDzCFeATF7oSJACMs2zr4hqg3jluk2V5hG0q4IY/VBVGUWwXEtX2QBpfc8NkXGC3UtbBWLvl4UnHpUpLh0j3/y0pn/Coulacmeq2vBF87uiaDfYBUXknWgHdxaGLQ2X0J65EHHfqob51BEGm2leZFlfku+iLKxhQ+3ESO4aign43lfqKTmh3lRPXb3E5IIYGs9dzEH9X7pFyu83J0WguS3wL2ofAokjlilKCdjX7+YHihSHH1C1mETS9/g+0CDUbtkGvuZu4ZY59dI1w76vK884W9ZGlm/xrky7/VINbRuITmfVchQ3WYBJCm4TfMOof5s2icAQfK31jXyHZ3jTbp/3twG8LwhacRbD773P57fNfPNSv5NYWThaG7yTgziYkchY0HsKaW374SdDUASVY7qJIBvho6ZQ1rdKdrwo3ebO0vAqR4RnVy66GYwhGCeaePB9QVOWvV3NfJr6sEak1MKMvu2AHxZ/QiAA4+WoEWtkRSEUlx/IJmDLYlFrARD2q/58Z/spki+6Fsrhh/gDsVjv4+xh9wIYDeaIr3rqIhFXnRUXxVdN79KJzRsrsNtWN+LB6Dz4TFg04fliCA0dK+F6ojzVrlvqCpN0OnqQyLDAwR4GpWxfQ2v9j+FkJLA52M91Tn8qa/EWnuBSJ87gOlVseoyRP6MxY/bvCPfG6pnRyGnXB6fG2BiyZMyTEMR9qRGG1VSPHjKnXLabwzbY86g
 eqMknjTU
 q1kqQLvo+81xcLkxMLoQpEW7ihZfSrTDXer7S1sOwh2BfT4OyS4ha2I5woVFtjwsubfDWjlOGUVjIvRmXtH7VpNTZaH0Jp+VE6Fq7czgSUS8X36q/ZVm/UssBAGLypBMPSBfmBnIhNbsSIXe9rykb5NiiyzwYr+R1s00ynl7QM4HHcnM7ixnlJBS+0j9qUnzyIS6fuh7Iq8EmJnxPGkb5Ik1YqarmyV+voH8LMhyli1uLMdkPzOzIc+1PR5YeEDc4mgIUXBM1iblRlxekRAuVfIJ36Zae98DQCmGEn9MWtqqFq2thC2yKo4SHqfTybXAN6qhqDuY1jts8Q/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 04:59, Nico Pache wrote:
> This change deduplicates the "is this PTE/folio referenced enough to be
> considered for a collapse" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> a single inline helper function.
> 
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accessed
> one.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Also, do we really need this (badly named :) ) helper given that there will only
be a single invocation after #5?

-- 
Cheers,

David

