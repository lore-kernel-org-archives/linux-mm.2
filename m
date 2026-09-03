Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5AB7C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EED86B00A9; Thu,  3 Sep 2026 09:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F916B00AA; Thu,  3 Sep 2026 09:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6506B00AB; Thu,  3 Sep 2026 09:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68FDA6B00A9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:36:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 055961C2185
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:36:53 +0000 (UTC)
X-FDA: 85172551506.28.FA8E6AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5C8641C000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:36:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q2dXhmu3;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788442611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAGhxl8EbQxM1Ac+USBKoQykwVMmqUI0h7OiFM/Tf5E=;
	b=Si7N/PhvFxE8Kaw2QIEoNjeyebnRgvWmpu7HFf4UJEg0Mfed4XweVNomrVIw625M/m9owz
	ZoFp8zFTdbuULMaHI4662+R8S6c3vTYZfiZ9PlYgV+eKACG7jtQ8Qk3GzhXTpNTxKhNmC6
	kJlxD27DMwpD18/VOttm8J6juuRRPn8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788442611;
	b=vjibgthqAXGD0M0KuHjbqyCeXVp2DFk9jwmPiqQOF1QWOocpsCJdtyIJd60jSiKEFG12Iu
	T+ps/l1icJk9hmLZzr31dSQKz9AnLKRxAGniu5by/cu6vdGIhD1UCyqkVmTEHm8yyd8Cxf
	9Qu0SatiZps86Zz0MxXd8AOvAFtq0AE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q2dXhmu3;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7ED8040F8B;
	Thu,  3 Sep 2026 13:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF8F1F00A3A;
	Thu,  3 Sep 2026 13:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442610;
	bh=tAGhxl8EbQxM1Ac+USBKoQykwVMmqUI0h7OiFM/Tf5E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Q2dXhmu3w2oLEKxpW+JcEtPwvZ+KUq3hJVKdfddjyndz8sk2Snpi0NzGdegKVGss7
	 rWD/SvinZQthCyfqKCM5nddpOiwHVwwMulEAjVZdxau317S8dEUAZKfLk93/bG9+Lb
	 Vh1afM+CNolwuYa2RJGg91AykTMWYr1jIKO1i6eoB2se9lPSDCyarHkpU3pOlm++N4
	 xa+w7U262gz4cVZfaBnrqGK5i5FZy75YeylAkMDN3P08EyBzIPMl5myBW8CqXdTs8J
	 klxWoZsIdGWBt5BwtDRVv0EJSSC1WSwGPqTzx1jUKNCtVOzD2+nx/Mm31s4tmqbpy8
	 VaFIh0OoiGcCQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Meijing Zhao <zhaomeijing100@gmail.com>
Cc: Meijing Zhao <zhaomeijing@lixiang.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Wandun Chen <chenwandun@lixiang.com>
In-Reply-To: <20260902075944.3742866-1-zhaomeijing100@gmail.com>
References: <20260902075944.3742866-1-zhaomeijing100@gmail.com>
Subject: Re: [PATCH v3] mm: memblock: show all region flags in debugfs
Message-Id: <178844260467.3691663.6752975072255908040.b4-ty@b4>
Date: Thu, 03 Sep 2026 16:36:44 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5C8641C000B
X-Stat-Signature: mw4ewkqdxdzomnfqaygm56yp48eas1wp
X-HE-Tag: 1788442611-651768
X-HE-Meta: U2FsdGVkX1+jflT3HX83ABwKFRDkr0nD8OdxPi9mBu+gzvpzXO5fpxejYD0YZXuEZPJd4/GK7U7fU8MoKqGMJaq2erwnJ+4kwiRp3ox4L4OoobSRV4k6MOtAHG2B+WYwChLeox/NVQeUL8nGZ1G0ezDdzs0JMjSRZ9E+xcct4oMPa3z5tuLMkHbnQQLuUZKmfkdsI5912uOkjass23DnTkVXVmI6rD5ATJgMWSIp0z6qUdzvAxv+S7yLwBEaLhVVTXo3f2b/kF2rxc7HJBKkAPyfhHqwGsIwpEzGaPL9I/SRb7GgdEknMJcn0fcBlR1etAsvCcxbtFaM2b5beRxG6n2D9FeK2NSFMbtXhAfyqSzzCMafdgBGz4O9etKauLgMA7/KG7NdReEA5K9EEIyWX8aTFDeqoAL+3uh2PoHosCWFx8MZEyT7Y+IOD5l8QhxRE4sZew367RP4Ysb5h1npOrWa6J5hDmqpwc4SMWvk4EBP5X7DMnM1SY32wNq3cybXsiqPT16rVrN4ZoeBcmZYCo7ThPCp1FC3ysvJwQbyW1ehzZJgeq7s21aqoVUHPBVHAtaw4hx7Hx0fGro77V5NH8cPzoOAO6siAje10R2nDblL/Lx/wjsy5VJDQ9ONlj+vBxrWbWroHItcRQCxy4+4hE/sfggio+//lc8zIv7qa3mJX4+TJmSbGPwdujTh1UU/UYcCL3DKh6sICf2E67QtVmm05WKicylkPZN2DhlGh0uhMu8r+2MRiImjivoET8QK1ha2OcTgd7k3GHn1wouTEP2lavaiu7MVyN8z+76tRtFT0vE9bxjhTiFx71z86UzHfsnuQTCKD7DWTmrcYooKPFwzr5XEzVOxEcbBwB6+iP5owByrGSsHA4tOUU8UcXlCGUTAuY4go5TcYFde/jlZ7Sc0TT20KVVsl4TkAywbqTFds2tCTBwfnmCxawOCtivCAsyh7+KD5FqYhsk2Cl/
 P/PXqkhD
 BvTkHN32B1zYBd9ePJNAeTGm1ernp5VYSGK4d2FCKjPy3PMi6/h4EQVJgbxdc6e62E1tJiePAQhu9psZJh4CZLPAuo5mMObICw3VKegjxFX8BwbfWPc41FOpo91bkz2xCWta4T2gu7GLjM9Tx03c6MNxdEmnMbdHAs/jqYQ4Y5wFjN96ivWF5xIHPbHqwX5en2EFZVCTtNCWgQhHnFZIvu0yimfjTvquBL9ObBF5szSMLBxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 15:59:44 +0800, Meijing Zhao wrote:
> mm: memblock: show all region flags in debugfs

Applied to fixes branch of memblock.git tree, thanks!

[1/1] mm: memblock: show all region flags in debugfs
      commit: 6178b127603540da56cc7c339994d2ad7c68ab2f

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: fixes

--
Sincerely yours,
Mike.



