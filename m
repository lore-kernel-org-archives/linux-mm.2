Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4710606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dtt1283S
Received: by kanga.kvack.org (Postfix)
	id 9FD656B05B5; Fri, 27 Nov 2026 07:15:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5186B05B6; Fri, 27 Nov 2026 07:15:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9128C6B05B7; Fri, 27 Nov 2026 07:15:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 334846B05B5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:15:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8CD8A7BCF
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:15:06 +0000 (UTC)
X-FDA: 85480793412.03.6D29AF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DD6BAC0007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:15:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtt1283S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sumit.garg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795781705;
	b=VQ5BUGRcJTNawBKh+Ht1NhEZs4U/Z58B2jU9UeuiMINK8Tj0lRlk6g5+dLb2OvvjOx8cyI
	18j7yQEcy6lAIQmECBHrtZq0ZObnp/MIOtsyTTZJnfZs/8zIWyVXF/O+nBgUNGFlbyinA0
	zmiy+NEtXLWWWbcLKLVBJHZi/a0alxg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795781705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM54K9orOriSVeFYm8Tg3Py4IYE5anR7lg79PbJmHes=;
	b=WTffHNBpwjMzd7THuacnQuzJTSDAFFp6HQKgpTUsv4XbbBQGPNDvCH7CWCi5mB/FW20qhD
	TNHg59ecMREY7ffA+8/jC/ZBET3nTFvISnUwKbJ+Nx2e44FjCs1a0kEcTV4aU9floFKWlU
	q9StE+/F4r/6xvRZ9UY8iEg2d/1w9b8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtt1283S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sumit.garg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 893F76254E;
	Fri, 27 Nov 2026 12:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B0A1F00919;
	Fri, 27 Nov 2026 12:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795781703;
	bh=iM54K9orOriSVeFYm8Tg3Py4IYE5anR7lg79PbJmHes=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=dtt1283SmVlMJDALB8+fBXMf9DpoJ/7duRnkVxmjg9BRCMUmL36GBysLxMuEUnc6L
	 NW05HR0AteyNXiALdjX0kNEoQS1iGQV3dNU2074CQ6xn5Qy/KAuuQKK7ZgL/v0zglo
	 aQnlcYatWQ/16jLUmzBmCzBq16QBDXkb07IHKc9bPo48Pmn5HEWsuSw3yDu8lDQh15
	 4vVAQNpU+4801ZTfCfRhqVwKEc6VoUKRlrZfCLY1/mdxwi5sjFq5uqSTfpq/rI+j2h
	 t1BrO1KSr6StxWy2CHoeWL3nUFdig+6cQvltOqpUS/feBqaZmViFLklXQ+sMzB/znc
	 Ti308wFpeHxyQ==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 8/8] optee: Add support for lendable-dma-pool
From: Sumit Garg <sumit.garg@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
 akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
 robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
 mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
 ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
 ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
 danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261111110738.872947-9-vdonnefort@google.com>
References: <20261111110738.872947-1-vdonnefort@google.com>
 <20261111110738.872947-9-vdonnefort@google.com>
Date: Fri, 27 Nov 2026 17:44:23 +0530
Message-Id: <179578166371.172025.1170602724631713692.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=469; i=sumit.garg@kernel.org;
 h=from:subject:message-id; bh=Y+fnpb+6sgyx/TICAWkXBLbJdNddcf3dmWbm5GHNfSA=;
 b=owGbwMvMwCV2RWpxpe9rmzmMp9WSGLI5S3Stv366/n7plf8Ot9/EukWzz7haXJDOvVWsU4v9/
 t/qn+eWdZSyMIhxMciKKbKkfv02bZvQv9pQqxM8MHNYmUCGMHBxCsBENjcy/JWrfuZ8cN60h88P
 3OLZJalc9e5m+ebZ/w/xd75snDkhw3oaw1/RFY9W6+5S/7WJ+YNH/jKlWJfFzIsSbMtevzAJ+Ln
 f1o8ZAA==
X-Developer-Key: i=sumit.garg@kernel.org; a=openpgp;
 fpr=65F5F696B612FE7D553AC80CD41AA3794DEB3C9C
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD6BAC0007
X-Stat-Signature: hfgw4ixwuijir1jb5iw1he73yuy8pt37
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795781704-642718
X-HE-Meta: U2FsdGVkX1/hVVNvCtyLEkeRZnULD8vKhRrxeTfT2pUslaAKZq1Nnk0MdveXOhOmKf3Sf6Gbqc5kY3c4E7guIHN1OQliU/sIEBmebCfCldPCR2kBRRyfceKobDQVSouXJWMfNcWEQEF/KSMa7ZrF46l9S7QZxz0Ph/n/TqdAb2yHNNVq+X9lCjWXpx0H6arwMhL1ERjCsXMFDtNb7pDu9+JaxLJ5cN5eG8uE6BfWdd8V/s+uFzYxXNEaM5NInJ5r0ryMV+Bf8EnaFZhyG5YRGSyL0gglb9uX0+RtGgqYnIbt69O72f2tZhzSg610sKiSrKk3XZVRB2ugtxMqo3L1HC5vgA08FVVubmBL1d434TSPdvItqxCDOI/KZi3z3L7e4cYisk0mwKYYbEN3aejqMJ8vBkXJgFym0kP2AiN1xqo3C5aPPq95UZW/X0NSNFovODVNIjlhpbhQKVJnw7apC/lH2YC3lYLxGn/ncFMOcOjqDa3lLX1LvzBUoREZ5r9y8IphO6lobvVlXt6WySCTIE3shhqJ83oiSRmUM+V+XA0/ezwKKlf0suIwyrP4/bJ5bNqwof2zUUwH52Ba5XEe14R0e/ACMXen8V3sHOFAvMZoBfumdnzVnZ2FmghlKDrBhgIukInYPuoV0e8wItSEqrdOyH/B568SgT8+pibP/fkXfczxWMIVPpTfi/T8cRcpH9UngXEzCKjGJpXLpE/jcQvmjcv2ZrFHPM1Ecq+EEjkUjpYlHWuqb3mxlvZY5atCSsXC/W14KS3ILHVolprewneaY+qqQCORjZpCwmy9Fu76oOLgGMyl9F+Am6a2xiHR7T4Wwrhs5x5TX9pSS8FOJmuHT0kXpV7rLYiBWNiC2OXNBEU6mHlm7zj2EDRQl8tqp3Y54QQA/IANCffA1XUUFjmWbb2R0cpAScf9g3QmzIWF/yVkWcfGBkw4DITAXY6U2t/stJ7OiC5nW4YHSkO
 oF9uBGuN
 FNq19t6VPPgLx2EYCq0mQzjG8U9lYTJVtVMwbAzro0pAK7lE46ktEe5IiWlmiBOpzaT3TSYH9lSyZvVYzYYDe6vCm7eXRZecxAQOGvdq8I0J3qZ99Vo5dtAz9hs5ah33otWdhB9eenrR5k2ClYPaofe0/lLvR7DIMei8Otu5svhdzd7xXD/lo4QAhk2y60ixR9Uv25KLYUKEGjQu7kxhQzMgRVeTwZ2+8QyPoIBTtCiQddr3BMoZ3Xry+CN1l7ns3WYffPciQllpZl1yoUGFkbyh+CBGhF+kKIUoPt8Vt440ga+8vyUco370jjDNHf0XtfrEjY/dWQh/I+f+XmmHq0N5EUKCK40O8AsOx5wZnUbwKrLagmKYhobsvnmaXBELQswbuzObVMczpZCysHUOlsmCB5Uq2y8ZJKDNrjuvEVzpVyA1QLFRrNCgtsly535nmi5FDZc6BzJg0jE79mqooFyBQD10vHW8ewMkhmZ8c6Qfpn4R7sGuGSAAvfvOCpeoFMmcazlJFGiT63ampO68EJCV/dr5na3XiyZ3Yq9pwugaTy5vk6vvP0bABNIVHEw+gISZNiIWKo63BNcwheLeo0NANzRFGUiY7nzH+HuAe+B1kzqy3fM6Oq94FBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> When memory is lent to secure world, fatal CPU speculative reads can
> still occur while it retains a cacheable mapping. Use the
> lendable-dma-pool API to unmap pages before lending and restore them
> upon reclaim.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Thanks for all the rework, the OP-TEE changes looks good to me. FWIW:

Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>

-Sumit

-- 
Sumit Garg <sumit.garg@kernel.org>

