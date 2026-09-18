Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 162DAC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346B36B00A0; Fri, 18 Sep 2026 06:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E4C6B00A1; Fri, 18 Sep 2026 06:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25AFA6B00A2; Fri, 18 Sep 2026 06:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01AF16B00A0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:17:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CB87C05C3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:17:01 +0000 (UTC)
X-FDA: 85226479842.27.0C5BBBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 92FAE20002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:16:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=BMj01Alh;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726618;
	b=cBLHVNmxzIFV1DoZPyHx1iE4+59UBCUEBa5Yl0+pQTTvhYjYaIZw0aohWP150o04v0BHzc
	in3VMgDbbSu+RE64gura2ldrJ+OXN5wx2LWsuztX5T/Q1JUj+vrm/kjytBfYnmeVKHk04+
	p3QEsGninz98rA+xdlOPq5pOtW9s/iI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=BMj01Alh;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726618;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifyrwe6h27+ZjrRKqNws8Hoy5jINQJxAWqPe8NSyJco=;
	b=Nq1C43h/jMOmq6wlqRrbPEFQIkLxQuX7AbvVRIv9VB675W6qWc+gDKSdwun7gge26nl6dm
	FLuDgWHeNm4hDF2KnK9SpOZkSZVo9M+LqjBjhyAHJ+Q1t0sDeCvp/eEJwA/Kx5IP4bfUef
	xZaJdqSXgMRTB0b+B3rRv1XLg6gPA1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9FF843CCC;
	Fri, 18 Sep 2026 10:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667AE1F00899;
	Fri, 18 Sep 2026 10:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726617;
	bh=ifyrwe6h27+ZjrRKqNws8Hoy5jINQJxAWqPe8NSyJco=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BMj01AlhbDDpoLoXxwn9PPhookstPQzvNzHcu3cfhmO/Vm1xskm1uSEn1VcRtOM63
	 v4FbuEGxl6N6K4hGy9mp3VPfdcYEi9Lt7ZAbiZrOOZJ0H76sH7Yfj41EFFY4kifUUJ
	 U1nyr9h3Wc6OFP7bzybInQVTbPMdB7n385RxAbDMpf0E0z2qmIOuSmMJLA0mzCgRn0
	 REbqAaRoOj6TTCGDA3UVM3ORDYou5nsQBAirRmO25yhfVyCRZefWSTyLWDBVZMDXh7
	 ivKDTJnqkoWlyNwdABc2086K40l/8qfUK9FEg1TIu4WwHLNY/RUoSJ/8Qc7TZFokWg
	 jmShFPclYOnug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/17] LoongArch: kexec_file: Fix CMA page leaks in
 segment placement retry loops
Reply-To: sashiko-reviews@lists.linux.dev
To: maqianga@uniontech.com, mpe@ellerman.id.au, akpm@linux-foundation.org, catalin.marinas@arm.com, dave.hansen@linux.intel.com, graf@amazon.com, vishal.l.verma@intel.com, me@linux.beauty, mclapinski@google.com, hpa@zytor.com, sshegde@linux.ibm.com, yeoreum.yun@arm.com, pratyush@kernel.org, eric.devolder@oracle.com, gshan@redhat.com, bgwin@google.com, guodongtai@kylinos.cn, ruirui.yang@linux.dev, ruanjinjie@huawei.com, kernel@xen0n.name, piliu@redhat.com, driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, lizhengyu3@huawei.com, james.morse@arm.com, chenhuacai@kernel.org, sourabhjain@linux.ibm.com, adityag@linux.ibm.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, robh@kernel.org, npiggin@gmail.com, dakr@kernel.org, ritesh.list@gmail.com, takahiro.akashi@linaro.org, thuth@redhat.com, linux-mm@kvack.org, liukexin@kylinos.cn, palmer@rivosinc.com, rppt@kernel.org, x86@kernel.org, coxu@redhat.com, loongarch@lists.linux.dev, bp
 @alien8.
 de, ardb@kernel.org, zhangtianyang@loongson.cn, chleroy@kernel.org, chao.gao@intel.com, linuxppc-dev@lists.ozlabs.org, "Jinjie
 Ruan" <ruanjinjie@huawei.com>, maddy@linux.ibm.com, blum@kernel.org, seanjc@google.com, gregkh@linuxfoundation.org, baoquan.he@linux.dev, pasha.tatashin@soleen.com, rafael@kernel.org, tglx@kernel.org, kas@kernel.org, hbathini@linux.ibm.com, tangyouling@kylinos.cn, jbouron@amazon.com, kees@kernel.org, will@kernel.org, leitao@debian.org, mingo@redhat.com
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-7-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-7-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:16:54 +0000
Message-Id: <20260918101654.667AE1F00899@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 92FAE20002
X-Stat-Signature: e516chghxbne5pu884c1ig395amnkmh6
X-HE-Tag: 1789726618-173654
X-HE-Meta: U2FsdGVkX18vZ1nt0A8hucWCHvwtv79ioC2utWAsTQIMJfcMnR1KTFtwE0y0THxiudMvkdvO2NdTQPkuT/0tzMU9VIcAP/hp2qYPiRUKTRn4Uv7Ld3yOBmowOaGFj0gPGHTNI+A0W/LXHOusIsEh11gX+tQt1SrCqG5xPVO+oN0Yu47bnqTq2s9xOQwKwovFefdVCRWYUfj6ry57MRRC6upc8eADMYHcRNzlVEOtLOq61tOi9ABQ4PursgLdzbHKRqqx4qLBb/TKuceb4lN7vy+avMCzo+Nrb9mEumlexbD7dOZhmwrrGOVCjMPP3ciA1Jxh6cWYrOCDtOfluIii0cjoh1WHVWq090cipFfv8uVppp/FKlmwudiYYk6ZAKTfGHdxAzLWZQOcnex2dXf1JNWH3peFC4SYzJQgEWjc183Rr9gEReMNWk5B1jy/nq+Ax8ETjwIVY4bIH2iLjs6YYaoZ+pu1yk0viYnoqL9nJ3YqedaWnqO4hPhoAUU6mhwCQu4Z0sxXtDfsrj3QUF/oS5FBd+wPBC1iY+bNLfyGe9YlvpANQ3gwit/FAn6E2yqCvQWZWTve8qJJNTBe0v63EO38xO3UTIWTWGR1JswSGa7Jtc5nFML6iej9/ussocfYLeN0xuH+lcOzfBRaBonk/fm8g8VDm4fPUQLeZd5fzKoagTdsMh9Ulq8tHtyslCsxoLEGaIGn10PyI0m7gvYSSsb2T8B3lTumDgPmoPyu11hUot4G85BP5FKvyZyBzYCNe/GqLhEIaMXeXzZ08Twxovq3TIsHk728pZzfnLsZVZMdEhQ8nQGmdq+owIf/ip5PuxK3Sppw8Yk0oGiSTz31uGy0FCHbkoIeL1pKmDoT9iI5etdtwQ+vj7tlo6lykbUlO4wFgJBou091pc6SheMf3cI7u35UNuiji+U4HJxshhE2NH0ogJOiFhBdyKQtk+pzniok1N26PbZLTNFqNwZ
 xIh4eMIs
 +GPyZ8RpmzJQVbR3F7+QRt7vYs3efj2sU3FGwFLSnmMLwju7X8+BeM99MKSyFU3Kryo6lGBmyULFG2YTBPJ6aKM4oyNkWRj6TTtZqysyt+fp8M+boCjgJy/SC2WKluep1tlMM+YZYITiZK2umcvSKRJeLNlfrSldYCGmKJ1fX/ZAcd03kefIWs/Kx2z25I8H6/odRX+PSoS9Auorg1d7d0PiRadtOlPBmsVxgP/U6PtJTaTA0S1UE+vIVf9CfcFNudmo7XoPdk0vfy+q8Rg4of5YRMWeo5vpV8R89IzFXLt1WRyXzgJAGKBL95Jjb2OkjrTTX64/mnaXrX9ocMYwQQWqBagHC2rOaOZMVA1SYNbUFIf+p5Fi45w4DanH03KavemWSjtdCtKAvPOvcJU/cMukSz7YkWDe+6yptn+j6Pf9vHawSwpnq7TbNdVLv+RqwuSenREklDG0Y4SFYN8CCi6lgaMUv5PIVMG6NxukM+aZzeTTZvuXSFMN7cCjUBksKeWeWfsd+fCU6J2omMMmAdnzPRKXeuskX5QT1Gca8ByLAsGPFzmkpBox/+kDYUK35WnWOcs8Pj3WoyrmmrEGJNe6qgPerwQZUF9/yut/pQoelQ1qnswrOcWW/N/mWV2WLNX211SvhoZ152gu3EvNfTjG4Y/jaraOfTvjXpET0va/LDLleLS/D9Z4EIyQIJZWj/cZUs1txQfssUDXxckyiy7xPW9iCA3zJCKe6VvA+6Gu2l6t7ApGO936s7tM2EhkIBsGvx/aIlcY1/zx09sqBFSO5wdCPTXVkpzeII1Z7amFG6DLl+Wn6/HKPCUN1sXg6rPdX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> During kexec image placement retry loops, any midway failure causes
> the loader to truncate `image->nr_segments` back to its initial state
> to purge the failed segments.
>=20
> However, this truncation introduces a memory leak. The CMA pages
> allocated via kexec_add_buffer() during the failed attempt are tracked
> in the `image->segment_cma` array. Because the subsequent cleanup paths
> only iterate up to the truncated `nr_segments` boundary, these allocated
> CMA pages outside the new boundary are permanently leaked.
>=20
> Fix this by explicitly releasing the associated CMA buffers in
> the failure paths before `image->nr_segments` is reduced.
>=20
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Youling Tang <tangyouling@kylinos.cn>
> Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Cc: Kees Cook <kees@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%=
40huawei.com
> Fixes: 55d990f0084c ("LoongArch: Add EFI binary support for kexec_file")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D6


