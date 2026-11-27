Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931FB606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIZ2PgCC
Received: by kanga.kvack.org (Postfix)
	id A72ED6B05B4; Fri, 27 Nov 2026 07:14:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A696B05B5; Fri, 27 Nov 2026 07:14:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9874F6B05B6; Fri, 27 Nov 2026 07:14:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68AD66B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:14:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E963A160291
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:14:56 +0000 (UTC)
X-FDA: 85480792992.25.74A014B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F4711A000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:14:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIZ2PgCC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sumit.garg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795781695;
	b=XmXv1OlYHwzfm6g57ZrqmDbhx48O5Dxff+1D6GD1nBPUvDJ2FtoFXyVgIgFVKV9U4JGy8G
	Xo+9yimtb3aheWVZIXocd89Kd5fEc8k2Lk5qbaaOIUz6PiI/fxPzJim6oOtXuHdx+qCRMU
	c6b3h+FPx92TmAHGYG5aaOE6r22EpQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795781695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tM8SXc9WGf6iPLFbf68oH/I2l2oZdLX38iKCsqiqJkY=;
	b=XrZ5maVzN3efGsmsAyerbovIzdnXP1L42j9rfitKHkBxOyGdQnGNy7b4jqGWlubAB0Iyva
	jjpVlEMUsXyX+1aWxPPrEtvSDv45xhLvrZ7ctpbMx7W97DQmV+Qm3NbHaWGc33uQdFbKmO
	i07D3nawT0+hTuc1MmrIHLxQcj/l8+Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIZ2PgCC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sumit.garg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sumit.garg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 858874049B;
	Fri, 27 Nov 2026 12:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEA71F000C1;
	Fri, 27 Nov 2026 12:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795781694;
	bh=tM8SXc9WGf6iPLFbf68oH/I2l2oZdLX38iKCsqiqJkY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=aIZ2PgCCSdBh7XmzcJDpf7YgWkZ8/PzA4YV/zcGM11or/4gPkPdmyzwzeb9vzZBJU
	 2zInaHrgLawwRJSVDG3/2z8/A/J4ua/wchlgufVddjLb2qXuTzOsHq19DMrOjjlYGo
	 y/d6vI+nO6hHY28DEzoq5C0Ugv4xhzLEPQkjO/3kYBlbt4wFZbQtZtG6pM2qMSnsNm
	 mqIcvp7NHajVYr5/7FUdPyuZAGi6I9T5LKUUwGzQz13mMpGOZSC6LPs/5t84y60w3O
	 uVvR8ajJcLWMClOKml8jHc6pnzWmLQNzRta+n958LFQOaxkvMwk82yGQjzF3k9H3W1
	 hhLpTPbUqqsGA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 5/8] dma-mapping: Introduce lendable-dma-pool
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
In-Reply-To: <20261111110738.872947-6-vdonnefort@google.com>
References: <20261111110738.872947-1-vdonnefort@google.com>
 <20261111110738.872947-6-vdonnefort@google.com>
Date: Fri, 27 Nov 2026 17:44:23 +0530
Message-Id: <179578166371.172025.2529658384273765570.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=974; i=sumit.garg@kernel.org;
 h=from:subject:message-id; bh=Sx4ywZBhiyullZrUtgY82SttR0yq7G5O52iMdmFQsBE=;
 b=owGbwMvMwCV2RWpxpe9rmzmMp9WSGLI5S3Q33F0lUXiz/xDP3tOl0RxvDeZkfjTJm7Dr88pGL
 puQ1PbbHaUsDGJcDLJiiiypX79N2yb0rzbU6gQPzBxWJpAhDFycAjCRZAZGhm7vDu0tNkxffpat
 f6wmaad/knepippM+rqdy3k+Zk3OU2H4X/fAReDjgWa2WUuZ9tT9XZR/OTpDcP3+JQtvMH1bE16
 pygYA
X-Developer-Key: i=sumit.garg@kernel.org; a=openpgp;
 fpr=65F5F696B612FE7D553AC80CD41AA3794DEB3C9C
X-Rspamd-Queue-Id: 2F4711A000A
X-Stat-Signature: cxsuobm4i4fmb99x3z1aux7w8b9w8io5
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795781695-561598
X-HE-Meta: U2FsdGVkX1+l2Wk1Mo5XtmJcBHZZjoNIcoEXmypcBgRwCnnK/BRA4oEVDWI9dcVVphbm1WetRpXMda9GJZB+SMtAP1BSUGjpBmUH7NL7vSBmzyARqL8WCyaD2CphTkgga4fDpaNXaEUICa3Ga8E/YIHC+tn6tfR1smU6oMdXKYiO+/XLBQCYSZksJAYtVxhw2PFJagnsNwqwLPgXBF5EurrVIndD5kfrEOacEKm15ukzi+7dly6NHxzXSV0cRNgt3gQIDgacBbWcEvx4Zbl2qEowHjQea5GvBeBZsWVxqzoyQWMLU3KNUmOhW0ZXWxNNPfV7DcIH9v6WxUe33KffIfREt+vJ807XvfTE7H1GCUN6YRkkL0q7asnLvAIyDNGFPcqRIsmGMZ9whejQtZePKZrX+ER8vezJ4lQuRzgcSzpE72750vWJziCPb8hjDkyiFArdVWzLaVzlE8bzootY+k6yCmY9f2f3p2RwJbIdKs/vKWojgaERnjIz6CwoP4kuKoh/2NqPHBvvNkGLTmqDnFuv+0yMZu9QLvc5D7QQJPKdxGZFG/2/Cs4X0Va8kg43Rn31m94wc1dagJYSw8Vqbm/4cT7RooZ71amnCgDBV3vlIsTO00QjBGswnE+LJ5PO2Io3YUeQd8MjJfR8vLvJdV3kNpiZdo4+epjVSXEDvawj5YelLeLW8uciFJFgNl205wc5BcJX4SI9XgGvB1+I5s8c8+HBdXt9mboxOznZT9uHaYZ8/mkxHgQrifk2zIVfR9UBPwyzMgnESroc6cFgz/tZNUdXjpG8S8F1/1bcHRA+BTxGfo2c5wwEMLxxa9cZNJ5xnynp1VrhvOaoqDh3b+lrJsnqNWqCkW9JjtjX2hqAJHloLO3LWOO43xdJc8QOEPj4OUxqemFxCmheQ5Kfd8NAGF+GinnMPgVEMpIP09oIcx6XtHoRDWMyeCwaWe/7mfiE1dZInrwtGdirvgl
 Gm2xYHSG
 bV0OzyuzpALDZxQqbaZyJbU0gDdcEhT8CyPBhPp+ekZtbm7wKPVorb/7EdXUXZSV+mXpHr4mZVcOMW6iDW9uNxIF4j10Q7CZwAsxgYySoLR0Zn6BS4aM1KRdNNL72lfiVrXOE2tDaiqrdnnAhGWttRd5faFeZ+d7Ssws9bMhTkdc9ECk7XvTgHteQZp+y91iRb4e25/jgaguVK+afnarqM1wCocYobUpIbQ6c84YysQk5zKDQq5KqCEATtBRs/VcnEHBnKE1L2HlGj0PHQE70PHR8AO/S9Gh/TWvQ8YrvZsosd/ZUrU5WTnnVxkj8nLqdYXdsXiuJelSGLLGa/RWjSTArvGFaAKyn+c8T9L7ebnMsoi5V+tiSStFNX/48dMN1KCugBP91YUSoHqZrfj0NMhInslmn8x10bjKOahQLpKJsJ9Gnb+Ge5PhMsJqn6p1hA1gG5GOf92DCK9Ik1WTsGwQTVrP38Ga7OUnWEUXs+6DICE85E3nQMFMUuRjvYXvEqzlCHKReMDaZdmUpDqwk06lTm8gLmukUQD7Ep0tP0+m5BUGnKeEp+coySrPAP4bWkFBWGC6Mr7qo0yTWNurVN9XT9uUl2cEMJLCv4WvNx7PjXQv5HlOev53ZOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> On arm64, when memory is lent to secure world (e.g. via Arm FF-A), fatal
> CPU speculative reads can still occur while it retains a cacheable
> direct mapping. Introduce the "lendable-dma-pool" reserved-memory CMA
> driver with dma_zap_direct_map() and dma_restore_direct_map() to unmap
> pages before lending and restore them upon reclaim. Devices use the pool
> via "memory-region" or "linux,cma-default":
> 
>   reserved-memory {
>       #address-cells = <0x2>;
>       #size-cells = <0x2>;
>       ranges;
> 
>       linux,cma {
>           compatible = "lendable-dma-pool";
>           reusable;
>           linux,cma-default;
>           size = <0x0 0x4000000>;
>       };
>   };
> 
> If no lendable-dma-pool node is provided, the API falls back to
> can_set_direct_map().
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Acked-by: Sumit Garg <sumit.garg@oss.qualcomm.com>

-Sumit

-- 
Sumit Garg <sumit.garg@kernel.org>

