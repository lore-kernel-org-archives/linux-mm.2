Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6100D68BE7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0586B0088; Thu, 18 Dec 2025 02:52:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423616B0089; Thu, 18 Dec 2025 02:52:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325D76B008A; Thu, 18 Dec 2025 02:52:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0586B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:52:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2B89160D95
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:52:22 +0000 (UTC)
X-FDA: 84231824124.18.380AA3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 45321100006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:52:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gt8bWe3X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766044341; a=rsa-sha256;
	cv=none;
	b=lOfQuWv/DuTJrt1rpuOz4u+H60LuTPiPzAIQnEFPQtzgE1xXUC0cTBJKGfxEMJgk2V/wSr
	Xz+gGNfCSwr8QbCZ9/hHRNIuBWhS4ssZwYs8wtNkmfvhY8C1fr+81tCCijtjwrAicmjxD5
	3ESoyL45O0I7SZKkWNA5oWPlE3s7RhY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gt8bWe3X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766044341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwNNQe9HkNqr/4QRueNpcLXFJw3AqhnKE+rnhsvWb0o=;
	b=Uqsh1TaNK4u9EBvr7ZKMK9zCHEZfHQ5yav6LzwdqSqeVeNW3O9k7/lO4WIk3CGX+MCv23A
	fTiyXBvu4xyQwzFlOKjpgSKR4rPtYK4zz0mXNCwhvIXfD6Eek3nXQBBnd6VPPgKSZdVsLO
	Dh7diK9LWvQrY8frY8hKHwnPhOZIOQs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 847AB600B0;
	Thu, 18 Dec 2025 07:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1335C4CEFB;
	Thu, 18 Dec 2025 07:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766044340;
	bh=z7L/COQjj+dxj156zLOK5p2xjWggF5cjflPxJeDDgmc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gt8bWe3XjkS5yiewXH+wkKJpwHQZ7eU0DgDYmQJsraZPH48T4U8/IvENlrMLeaNB9
	 BydYKjugZeEMqFOU02jXXydkdM/Bt5a1zw+1ydmJQH/qgwfQkC5ROkUTDfuthjygh0
	 Dc8Y3wB/XmMGiQN8kt0Juxzz5Y1VVNDa8KCsT84hzx3ddKt0COqGOc79Ai19bJO0js
	 quoBd/AgFwgSHnCvWq7oQBLHugjgdD2y9+4H7ZVkquN5N1XCzacYAd3Fm23Yv/ZR21
	 uauRJxOG7K8+wFuwcTSmKaIbm3/Dqchzi2yHkiCcGOIfMnrb3Q9yTOqCWhYd10tXpl
	 8O1zFP3JAppkg==
Message-ID: <1e4c889c-f594-4d1c-92cb-e94af04acc91@kernel.org>
Date: Thu, 18 Dec 2025 08:52:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] introduce pagetable_alloc_nolock()
To: Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
 ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
 rostedt@goodmis.org, catalin.marinas@arm.com, will@kernel.org,
 kevin.brodsky@arm.com, dev.jain@arm.com, yang@os.amperecomputing.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, linux-arm-kernel@lists.infradead.org
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
 <916c17ba-22b1-456e-a184-cb3f60249af7@arm.com>
 <aUGOPd7gNRf1xHEc@e129823.arm.com>
 <100cc8da-b826-4fc2-a624-746bf6fb049d@arm.com>
 <aUKKZR0u22KOPfd7@e129823.arm.com>
 <d96ac977-222e-4e8d-9487-da1306198419@arm.com>
 <aUKnfU/3FREY13g1@e129823.arm.com>
 <d912480a-5229-4efe-9336-b31acded30f5@suse.cz>
 <DF0J58HOVLL4.2E16Q87D2UXRW@google.com>
 <d5354d96-6f28-41d7-9f66-64c254d9477b@suse.cz>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <d5354d96-6f28-41d7-9f66-64c254d9477b@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 45321100006
X-Stat-Signature: sh6934897eohmyttfpxwwax7czx9x3t7
X-HE-Tag: 1766044341-650135
X-HE-Meta: U2FsdGVkX18jjNdFqYjyVsQdR2gpUPPooPllkCvS3ah1Sek0Y3NbWMztinSC+NFcDn2ZK2+0rTfloM88jSO9i5iHFvMhNzl8QxKaB92G7BQkAcZCDU1ZwBNhpuiM5/vCodGQrFbmNRE9RsFj2/9AoAfFLENVInhlddf7KhuxcL17GmveEaM5yyB4QeUsxBK22B2Qvj/vc9Gt1/MhQUoGRz37U4cVazhSEJXY/RNAUJvhYDaBXlH/GBptjvaqbnCsLq2wn5bMxC/EEoQI1zr/Hh0I2hMAuOHlFUmnm2wzYfJ0ZqUNMimDk3fbYuasKXA9JicKqzCXzq38ZDB092uC1UfX5123p07sKI8ULe39cL8f3+834KliqfvF7uJsz0WBzUhulPqv+FZ5xLFBJpzL5kVbimCEt4oSQo6owp37KKWk6BhqoQdd8AJAqKMzc8txMsxQqxVeAEIkF3/FkUyflyxAvuEdT63luFCnMtwpiMmo2H60eVYWSEpbmQnvNutxq5PpEjcxXjjtayL0cjK6qZAQkooEZmWOeFoDsZuA0Dkzxxl8RDcfdwwVU3/HaMoPVYLFQ84pw+LMbTdLdGWJq/xZyueDNKVnO3n0me6ERBGbQu21kLnS38bS07CZIoLP3MUMgelNwXMqH/E3w4A+vFVMqYPKPpGwSpZc3KVAHBLtWo2hzaPaTjNkCjyS55SmbkJx4dXimYl4nyL6KYIeXm/B6S1vLSw09A5PPtOsVcVRV7Rey+pWB23Wj121sDbGIqx1WP1nvUNFj12+ZH4BQMkN1bZdJGkuPbJAlaZrwFuBI7romF8xKAxSVInofbGe/PLJ5aZP6BBwulKy+9ktBbohukvL9Qrf4X4/SDe5houxOnO5ymmEpsub8Tcx3kfw9QTtMha0Wk7v2Mjc+P2/h7YyNz8/XVyiY0iJHdweL6pPyXCEWbbc+b8DjI4HzNSaCSce7/S05e3hkhmtu3D
 SK2p5Dal
 vJ4XXlzJMeFHDKlKIs6tWNvJ2cYOpZVySE00haIDSWTCiX4xXp/5D+380s+QL/0YeNJ3/QsiU7CW3p9g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> Link: https://lore.kernel.org/all/d912480a-5229-4efe-9336-b31acded30f5@suse.cz/
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Clarifies things for me

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

