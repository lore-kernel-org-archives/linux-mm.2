Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54930D6ACDA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B75756B0088; Thu, 18 Dec 2025 04:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23686B0089; Thu, 18 Dec 2025 04:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21CB6B008A; Thu, 18 Dec 2025 04:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 909FB6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:55:47 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33EECC110D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:55:47 +0000 (UTC)
X-FDA: 84232135134.03.C9AAAB6
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6D2391A0017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:55:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=vf+N+HZy;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766051745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+zvG+8e11n24pJutZahktO9rCuNJt6S0wGRGf9V6C8=;
	b=ciOmwv1USpq5bU2RSCZmFVAzp/calADs36gq30egPSxojJERjAo3B+zAqTiDykPvWrxxwx
	wLKEJvoj6nVe/Fpyu385iFGdr1GK/tnfiFF0D268y/vZrIelNOelJXc34xMYkJGzSskyoc
	uiQ72iRVhPUXdzgHu7/l/Pl5RO/dEf8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=vf+N+HZy;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766051745; a=rsa-sha256;
	cv=none;
	b=XTFDL0aDNVuhPmiN3pQtfkXXgBZOqlS8vmSKB2C44pvaPW4OJk/C7k/XRuq90tZnitWcvO
	eDsiopSQubDITDMak4MtGZAxkYIOCBQEz3duW4JDO20ZGUU0vM5/DRf/Z31DniG0nbtSnb
	Ctc2oYaWc1sSMsUcnsGYAvssg44D60Y=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20251218095541euoutp015d663ba0aca41d598f77b39779bcdcd5~CRrO_MVoH1247012470euoutp01E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:55:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20251218095541euoutp015d663ba0aca41d598f77b39779bcdcd5~CRrO_MVoH1247012470euoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1766051741;
	bh=d+zvG+8e11n24pJutZahktO9rCuNJt6S0wGRGf9V6C8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=vf+N+HZyDAEGEWfu9J9gaf5Bj8YdEQ0Eo1YJM42hBxIqalmnJHaFk4r1miBih2b6+
	 oDDzqFXu90kFDpGbSMxXRpc3yf7AffyTPEtVfr4nWdX/3QKLoVd3nB+ElIsJzFI2Qi
	 pnFdGYVUHE4/VxIMhM3iPyAEwMMs/7bUgrHkze/k=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20251218095541eucas1p158c5660f096a107393085fe89f5bdd6d~CRrOeW8ch1259512595eucas1p16;
	Thu, 18 Dec 2025 09:55:41 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251218095539eusmtip2689dadc5b8a592c5508b1a1b9a94aaf1~CRrMzcUAy0481204812eusmtip2N;
	Thu, 18 Dec 2025 09:55:39 +0000 (GMT)
Message-ID: <99dc91c9-59fd-47c5-b1d9-157bda86ad59@samsung.com>
Date: Thu, 18 Dec 2025 10:55:38 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
To: Rob Herring <robh@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>
Cc: ye.li@oss.nxp.com, kernel@oss.qualcomm.com, saravanak@google.com,
	akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, robin.murphy@arm.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev,
	quic_c_gdjako@quicinc.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <X-TH#1.CAL_JsqL6VVQ7K_ZAbHJ8Gb7ei_jusLx6wRn=AdOVgV50dX0ejQ@mail.gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251218095541eucas1p158c5660f096a107393085fe89f5bdd6d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20251210002053eucas1p1d1408ad0fb49a49bf4371687f8df7395
X-EPHeader: CA
X-CMS-RootMailID: 20251210002053eucas1p1d1408ad0fb49a49bf4371687f8df7395
References: <CGME20251210002053eucas1p1d1408ad0fb49a49bf4371687f8df7395@eucas1p1.samsung.com>
	<20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
	<X-TH#1.CAL_JsqL6VVQ7K_ZAbHJ8Gb7ei_jusLx6wRn=AdOVgV50dX0ejQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D2391A0017
X-Stat-Signature: mz1ab4cne7b58wmj67u4wwwkmsanjhi7
X-HE-Tag: 1766051744-852064
X-HE-Meta: U2FsdGVkX1/y4LefixQ2iKBUuxLXTSN3X7TsGy6x2snkyckkQSpJhTQvvlljFkcO+qPoAYL6edcKHDRDAAu2yAIZWxBx7iTlOWg3+Te4+0P2woDWpooUV/FKrr6OabsMjA9ChCVD85KKXyK+8aVUmzkQH5fWwRrHK2JoyiNc9hM6Qm+lvTYbVasPEPnTtOyyZ+JXWvjehirp0IsQ+cjzhIaJdweG4PsxXInx6cGq0BxSwA2mrA+TcJZkwm7r5DCmWtqvm50TQ7Os9gTqQONlKrOTwC4hpnMLasUOpZxtki0QqoEqVBPfQuAnCzKs/7axFUeIQKFt9/Ek18XndPmj7B9Iit7Rig39KQbQ65SZPUE+m1Ypacucg7n+0c/Ui8wvm+ODOuuaoxo1WPJqD1Q9kl5qJkfiGEH06CFvoW2jDnm6MNvcs/tKrHifhII6HCkp1VNjN6mL0B0MgWbOyN2fd7pg7p7pwgzT7xFwibuBaKSFRqSKMEt5pbS6XNueOUkBmlHCkKpb9Y2+GbqgKvx8zLCyb25QdSSidFuAwYAh7m/FrtAefXRE99f47K1pifsYPq/1ey2W4tI1XYOBNzT15K6j9sAzSY7wyn88uDEn00l+ytndRtabnO381Aijq0jxSm4SsrT9Z077wUyjnKrj+/MR39xy7Kdqhm20Zaa4NYQGcQlpMzE75cbRnvj1+7Nj9KoDZ0osMlo9sDJc0y5SYNYaK2n6D2BrM8mgOKMD+vJm2GUC2wgXirb2IhLckbHFeFRAsnHvxgL2Af2LLXrSzRr2cDLvU+ZdBB4xyigb/Xe9Fzrrx9bzbKrcG/CTg5HlS/Ynpjpw6I9/7RQUJLQDugHxX/IhRLxnC9dclh3CLaqQHVxS8Zrm5XuNVWMelolaNDmwIo4AiuRXG3QklL+NosTzXeczkpyDO6+n9Lefft4I6MfDB9cdlAs5f0rMkYdgYyhzHJ7tIBBdqoTxJaN
 nbYeS9I/
 X5+rOW1RmhCudjxZuZsQrqnzdzhW5ev2B680JgR4T0Wn7ZtPbsd5rZKb/yZrWJEm4vPh2THmM5b+/0jcUGpQqFMoAMh5bj9BsVq5//z70u8yMxNGbYLAZB4izmQHhSxN2zUT2NSrsNBhFiZnNfh1FBAYU+u42cf77mZ6dV2CWzB4wPuaWb3EXU7/pDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.12.2025 15:07, Rob Herring wrote:
> On Tue, Dec 9, 2025 at 6:20 PM Oreoluwa Babatunde
> <oreoluwa.babatunde@oss.qualcomm.com> wrote:
>> When initializing the default cma region, the "cma=" kernel parameter
>> takes priority over a DT defined linux,cma-default region. Hence, give
>> the reserved_mem framework the ability to detect this so that the DT
>> defined cma region can skip initialization accordingly.
> Please explain here why this is a new problem. Presumably the
> RESERVEDMEM_OF_DECLARE hook after commit xxxx gets called before the
> early_param hook. And why is it now earlier?
>
> I don't really like the state/ordering having to be worried about in 2 places.

I also don't like this spaghetti, but it originates from 
commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved 
memory regions are processed") and the first fixup for it: 2c223f7239f3 
("of: reserved_mem: Restructure call site for 
dma_contiguous_early_fixup()").

It looks that it is really hard to make reserved memory 
initialization fully dynamic assuming that the cma related fixups have 
to be known before populating kernel memory pages tables. I also advised 
in 
https://lore.kernel.org/all/be70bdc4-bddd-4afe-8574-7e0889fd381c@samsung.com/ 
to simply increase the size of the static table to make it large enough for the sane use cases, but 
it turned out that this approach was already discussed and rejected:
https://lore.kernel.org/all/1650488954-26662-1-git-send-email-quic_pdaly@quicinc.com/

Maybe it would make sense to revert the mentioned changes and get back 
to such simple approach - to make the size of the static table 
configurable in the Kconfig?

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


