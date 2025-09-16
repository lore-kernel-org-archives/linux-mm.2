Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2713CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7C88E0002; Tue, 16 Sep 2025 17:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7848E0001; Tue, 16 Sep 2025 17:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD948E0002; Tue, 16 Sep 2025 17:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 03E888E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:10:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92905B835C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:10:26 +0000 (UTC)
X-FDA: 83896356852.04.4FC1F1D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id DB1794000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:10:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rzggNwY2;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SDnxirkN;
	spf=pass (imf07.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758057025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pj5Qf/1bxCFrPvhs0jRUa6YUBACyGl4rbZxu2Lu22Yo=;
	b=Q+jaoMPFQmO8HDZD0WXPkx/aAVXXmgaiCILoaw1wbI74Xo1qj1aqCA0Fr52eviHC2ZX+4w
	mbPPND/airXVHv773i6UfRIywMkOIyq1Gsu0S3MNPTxbDeED1AHwAb27jO5q68eW2g7enz
	scPkQA8J0NWWgzlYZkqNxcGPfTv638E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rzggNwY2;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=SDnxirkN;
	spf=pass (imf07.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758057025; a=rsa-sha256;
	cv=none;
	b=FA8ziNHoeXeIEd7WxrY/0uFfGH2jnfL+hxutclfIMm7Rg4dOA3Nr0Cq6mdCCFqQHC8A4u7
	veNrJw2f4RFN9iOiNWddkERgtaA6y33jgCCeAl8uYnXzGiPBuEpy4y22nHkaSw0PMc/6Yu
	Y6xpo3dAGLMwh8FMOL4qZ/eygZuKYbo=
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758057022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pj5Qf/1bxCFrPvhs0jRUa6YUBACyGl4rbZxu2Lu22Yo=;
	b=rzggNwY2vNIxBIBWhIM2eNT5/Wfp/pOEx3vtX/gpirUkPKVvJ0xOMkn1gIzyLdOdcJM/AD
	LJ2HK4ybwmU0mn9P3gCiw4KAwCnEtKWMS9Sb/0qKfySh8hUCPH70rJAg5Vq0oS1Etq5y9s
	fWaUbCSElmQMt6NX3zClcf91wEMcC1oZuAdCi/5IRA+Ig27XqQiW9KvpUqkD9NqXkHLd/0
	Gd0n3URf4LrYUw8JAffVYVHTmdNOaBv3i4kwOMJvXw8NmVIpVwwAtKoaJo94DrP41+tyCK
	c1/lgsIXQKLPw28SqA5WCxffxdnDK3zoAfFJs9W+tYUbrCs6XWPUEcEbL4SF7g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758057022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pj5Qf/1bxCFrPvhs0jRUa6YUBACyGl4rbZxu2Lu22Yo=;
	b=SDnxirkNQwaVrfSM04srsZSWToQc90VpYlu25/LRFyplMb/H/OpA4GODTfBkYO63u2m+3S
	JVN0QitkAjbE61Dw==
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, Eugen Hristev <eugen.hristev@linaro.org>
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
In-Reply-To: <20250912150855.2901211-10-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org>
Date: Tue, 16 Sep 2025 23:10:21 +0200
Message-ID: <87cy7q9k8y.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DB1794000C
X-Stat-Signature: cak3diy4x7ay1nemembp8941k1smnrag
X-HE-Tag: 1758057024-923514
X-HE-Meta: U2FsdGVkX1/uKE9RK9Z/A5Y53nFw5jUw4uUjuhODuZkzLLnB14w5WF5JzmgVhF0kpmrg3ZygXpaOtDO2U/72RPM9FGN2G+lguF6ePBmRyiIXag652r1KC0eS54WxQGdsffiIly7BTmrere1cjpw7CYw3lP0gS6DrvM6teMNYpABUlVU6JiKQwLWtgIX3mXUDyU4AISFNWQsTLzqrfdQ0QF/RaYu7fX8hzJDeSHCA0xYx+mOJmuOYZ4sPzew+cB2iHy0ClKzYXDXBqTbMX2cioFjGdghIR1CRyo2/rGl1H5ntAUzvRnm4aoI5+1TQwst+Lnfpv7s2m2cnbAbg13AjWnYU+HjfMZ/TSA8BCh1kT9GaSsgv1B5GhE3+cK8fgVgiXYvrdmlN3TNiH1uTr19P6bHnazERLqmLSxZYJmk/kTxR12J6Ic4cxkeP2of4+CE7TA/YhGedjwOlgcel7ftwXJ8bZTi7jkA6zC50tvVEi3Pc9qs5Y6gn22l/lzPeiUfhHBjCRkRytBcZdUi4IFqPoNy5axw6j+znrn2rJFc/Dwf3BkrWoCXTQ/04+j6dpKnBh1c5+dIAsqQlHG7zvFwS79rwUZEpl6Y1geE+ohoK+em9T9C3CjSl7kERGROq0nHHvPDLH2x5QEYPhqlS/ngIlCsCkv7AWqXxSGM0O7d5wgbtvKUHWjyUksV3utIwzy2kRKNCo4VhUbFiDqJsWd6B0oS5jzKODYidG6a3PMzB5XOJbfCtA4r89ovjvwFWR6zSY2rdKvmZVVT8YI7dRn2yqRU1YSLKzBuvFev880dHJ54waIWYxFLdkqFcegodG3kyNOnR5kRVE7EwEsItREQNAtZr/6LphoNvjExdxTL/jP0GMBmpbAywKhufFi+Ar66DrGEWv68ZHfEJzXn3xYpEl1nUUEhY8cmc+PZVdH5kOzpdFNxxfSkzAwPY4/+QKn2OJ3SKD8fT1bTeLaf3DBT
 Ya2HkM38
 zfJ7ktuLeOIBcIdmlCmAgX+HSJCuTc6NBwDlZmkPXoWktPlGJxm7HYXF/zDba4uggpHPGtG7LS1JhTdikwsxPZFfsohULfzYmYlaIpl8QPBLiR6ulG1IRys/dNxI+4KuEFrV0phqDTljvx2TfglLUgAV1CWprSJ/v04pyguHhwKXUOcrNXXekrrQCT/ZK78OT+N1AwhWzfPMdzadhPlBeDsIlXIksRsBBMmK2oyF2SVlvHB8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12 2025 at 18:08, Eugen Hristev wrote:
> nr_irqs is required for debugging the kernel, and needs to be
> accessible for kmemdump into vmcoreinfo.

That's a patently bad idea.

Care to grep how many instances of 'nr_irqs' variables are in the
kernel?

That name is way too generic to be made global.

Thanks,

        tglx

