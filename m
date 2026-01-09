Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7EAAD232C7
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 01:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94FBA6B0005; Thu,  8 Jan 2026 20:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D31D6B0089; Thu,  8 Jan 2026 20:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5E56B008A; Thu,  8 Jan 2026 20:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1796B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:18:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0437F13A994
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:18:41 +0000 (UTC)
X-FDA: 84310665684.19.249FE81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5796440013
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:18:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BkqB56df;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767921520; a=rsa-sha256;
	cv=none;
	b=tdXVRxGEC3mWu13VL8UtREA/RH+rfXEbvsmkGOCkkjZ/p4ILv0aM4+tRoSItT0RuI37gHA
	X4UydXrlbR3gbS1o2oCTBkTjcITho8ZJA9BK05LsFgX3aL+wrEgbR04n/eI60any/grQKP
	US+3ftFTrbVoRHYsUIWCQd7FyUmEbXA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BkqB56df;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767921520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TE257OZLb+NzdeuNTIJlQZX7ETIjfiodX0rpyiirEqU=;
	b=xVVYnAX1psbwjIEZKoblXhf0EoWJzba2ASunbYa6fMX+O000Zt+5bjPuOe8FXJRfdV1mcc
	i/2FLDmlGOelZpEukyn80VmV2KL1kj68kYeh6ytVZG40qk6jo6zRMWGj4EVzGRaKEI1Xpm
	RVVrvojytl+Lj7RPK9iOxxZ7ecf2aP0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 330C842E41;
	Fri,  9 Jan 2026 01:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84DAC116C6;
	Fri,  9 Jan 2026 01:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767921519;
	bh=R30MjaWiVKCZO6hL4X3IntKJmzte8Kq+Ssd8NLay3oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkqB56dfCx9uUDKm5unPnjRrTu9HKQyKexFq74u/W2yHm2DpERk7SMCcKAalcNKRU
	 +d6TN1Zr+mnMQ31Cvif8BV5ZF24QsU2jSf8uWCd3k1mhFQx3dxTVFAaoAD54PdoOHO
	 L9tXGanUp5L9ns1cnkkUHHsC+FeVZttfDt/pKNAtnt75h+syCJQZasJ3A/+DC8QQiS
	 1moKsG5F7CxLBbKky99hnYwqfGi1CL0d+CAn0DpjqtUu9YEyZhOghz2BDGbg25253x
	 Maww4O4TSU9ido4UD36yiOm11x6Jk2WufwPc4HInbzww6ebVBF6rmOMuiQrOiBTxqL
	 jgwQTlbr/b0Lg==
From: SeongJae Park <sj@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Hildenbrand <david@redhat.com>,
	amd-gfx@lists.freedesktop.org,
	linux-mm@kvack.org
Subject: Re: Finding mm patches to review before those are pulled into the mainline (was "Re: [PATCH v2] fix AMDGPU failure with periodic signal")
Date: Thu,  8 Jan 2026 17:18:29 -0800
Message-ID: <20260109011830.68325-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1c758937-787a-4afa-983d-e5b89578b101@lucifer.local>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5796440013
X-Rspamd-Server: rspam06
X-Stat-Signature: ug898mmqffwsmn6b3btgnadeby9ti7oy
X-Rspam-User: 
X-HE-Tag: 1767921520-995424
X-HE-Meta: U2FsdGVkX1+hcQLkL4QlZMszI/e1qlVHdhMif+zac9JRvg1yf/afLVrYiC115HV/Q4gjPO6Jfj2jUUbeMppShFsfWnDLFHpnK7Grevt+OGZDkL2tqtlLRhJVpBwLT7KAVTWXhOFVRUPArXxUZcShG1o79RgNQFctcLb+X4ohA73E7/TwGrlVofgaDrMoNyy8Ik4efejfUNizHbgfnF46l++o3vyhZ9aiWZjY044skiPEoKpYpgXEGrN3WXkdf9m66O0T7hPn5pZkIrDBLwiGTS7CyxhAzsDxrXrIHAkkhezyucTzwOHhJDGkrLoKrkwmKZ7Q9jHfGjbtE3NU4kjkT9+e02nlbwqVrfunflXmfSiWKZ/ur2/JAzROLXBkR4Jk3fvoJGrSFdL67y7svXTqnC4NDSawfC/GLDUuFedFwe9YSAsADKxmvFI6QHqhxbfJlck9obtzGq5lL8c2MhAys5uLGPz1gNHm+vMUecsaYR4SlXIzjL22cGT8O6ydmRwwayRgW/3iK0UGS3PpuklZ7cO5vXlg9NhcVd5WSpZomAV9XVMYRDUhRcLUt9edC+JPhMqIdwNXZrEsU6jjWOZ8FijmVhB62lpF9f+SVGWbm57UgLGwTgTaoTWHl9aC6VI2V9cobbO20y/XfvHBu7VFwjBigz0oRMcEABrzkTVL5plQecIK/ok6S7rUrAWXjpHuVN7eCbKzPTk1vuroKPst68REqbiaCHt91GJm/dTVdq+NvnaYzHbdpRFujfcS2CU1z81fViFD97b9K1S8iRp09RDPlX2dQrOrGQ9G7ZDGRyiAPsdf18zco1oYFXEmSq3QwB7ua5xJWkD+NV3+DgCoh7/1YPLdeouisboEwO/QOfmphvVyASSLUecEOhw9HkskLEwA68HUq1lz//XrXkhs5qcGNNVmLJMHWUxvOCnXnQIf1zgO1kzgfeo5SO5EmxqqkG62Ubz3NZjp0ESWog2
 usnIgmdC
 R8iZK8aVUNK9CMPhl3iSGSBwzyAV5XkIAj4sHcGmuv2gs7haY/8MN6gNawH+/2RF0BVHZ9lbWRYE8H+FISz8k3Wdkx1GWh2p+pzcw32FAFZyc3UleRucxDZYadj52aqgFLvESCvqG1UTWa0+qceg36ss6pJMB3BhPCRt6U7hyQ2TnkGcb6hirSFcGtAnbUu/VngMrM5coBzurw4vm8hlQUUOSqtKzGL2OXDb9LcdFHg44QOM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 8 Jan 2026 09:05:16 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Wed, Jan 07, 2026 at 10:26:35PM -0800, SeongJae Park wrote:
[...]
> We need to change that in my opinion, but I'm no longer hopeful that we will any
> time soon.

Thank you for kindly and patiently clarifying the situation and your opinion,
Lorenzo.  Thanks to that, I now better understand what you are saying, though I
don't have a good idea to add on here, for now.  I will also take more time on
thinking and help if I get some ideas later.


Thanks,
SJ

[...]

